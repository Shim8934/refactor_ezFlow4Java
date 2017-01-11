package egovframework.ezEKP.ezApprovalG.web;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/** 
 * @Description [Controller] 관리자 - 전자결재G
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.04    장진혁         신규작성
 *	  2016.07.13	이효진	         추가작성
 * @see
 */

@Controller
public class EzApprovalGAdminController extends EgovFileMngUtil {
	@Autowired	
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzApprovalGService ezApprovalGService;
	
	@Autowired
	private EzApprovalGAdminService ezApprovalGAdminService;
	
	@Autowired
	private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGAdminController.class);
	
	/**
	 * 전자결재G관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMain.do")
	public String apprGMain() throws Exception {		
		return "/admin/ezApprovalG/apprGMain";
	}
	
	/**
	 * 전자결재G관리 왼쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGLeft.do")
	public String apprGLeft() throws Exception {		
		return "/admin/ezApprovalG/apprGLeft";
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formAdmin.do")
	public String formAdmin(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("formAdmin started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docType = ezApprovalGService.getDocType("", userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
		String multiData = commonUtil.getMultiData(userInfo.getLang());
		String editor = ""; //config에는 CK등록되어있고 ""일때 폼프로세서적용 

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("docType", docType);
		model.addAttribute("multiData", multiData);
		model.addAttribute("list", resultList);
		model.addAttribute("editor", editor);
		
		logger.debug("formAdmin ended.");
		
		return "admin/ezApprovalG/apprGFormAdmin";
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 기안양식함목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getFormContInfo.do")
	public String getFormContInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getFormContInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String id = request.getParameter("id");
		String companyID = request.getParameter("companyID");
		
		logger.debug("id : " + id + ", companyID : " + companyID);
		
		String result = ezApprovalGService.getFormContainerInfo(id, "", companyID, userInfo.getPrimary(), userInfo.getTenantId());
		
		logger.debug("result : " + result);
		
		model.addAttribute("resultXML", result);
		
		logger.debug("getFormContInfo ended.");
		
		return "json";
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 기안양식목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getFormList.do")
	public String getFormList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getFormList started.");
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String id = request.getParameter("id");
		String kind = request.getParameter("kind");
		String companyID = request.getParameter("companyID");
		String searchType = request.getParameter("searchType");
		String searchName = request.getParameter("searchName");
		
		String result = ezApprovalGService.getFormInfo(id.trim(), kind, searchType, searchName, userInfo.getId(), companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("id : " + id + ", kind : " + kind + ", companyID : " + companyID);
		
		model.addAttribute("resultXML", result);
		
		logger.debug("getFormList ended.");
		
		return "json";
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 기안양식목록 정렬순서 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setFormOrder.do", produces="text/html;charset=utf-8")
	@ResponseBody
	public String setFormOrder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String formContID = request.getParameter("formContID");
		String boardIDList = request.getParameter("boardIDList");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.setFormOrder(formContID, boardIDList, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식함추가 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formContMain.do")
	public String formContMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String serverName = userInfo.getServerName();
		String tCheck = request.getParameter("tCheck");
		String primary = config.getProperty("config.lang_Primary" + userInfo.getLang());
		String secondary= config.getProperty("config.lang_Secondary" + userInfo.getLang());
		String title = "", topID = "";
		
		if (tCheck.equals("fContIns")) {
			title = egovMessageSource.getMessage("ezApprovalG.t1623", userInfo.getLocale());
		} else {
			title = egovMessageSource.getMessage("ezApprovalG.t1627", userInfo.getLocale()); 
		}
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topID = userInfo.getCompanyID();
		} else {
			topID = "Top";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("serverName", serverName);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("tCheck", tCheck);
		model.addAttribute("title", title);
		model.addAttribute("topID", topID);
		
		return "admin/ezApprovalG/apprGFormContMain";
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식함추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setFormContIns.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String setFormContIns(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("setFormContIns started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String contName = request.getParameter("fContName");
		String contName2 = request.getParameter("fContName2");
		String contDescript = request.getParameter("fContDescript");
		String contParent = request.getParameter("fContParent");
		String contDept = request.getParameter("fContDept");
		String deptList = request.getParameter("deptList");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.insertFormContainer(contName, contName2, contDescript, contParent, contDept, deptList, companyID, userInfo.getTenantId());
		
		logger.debug("setFormContIns ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식함수정 사용부서목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getGroupDept.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getGroupDept(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String contID = request.getParameter("fContID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getGroupDept(contID, commonUtil.getMultiData(userInfo.getLang()), companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식함수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setFormContMod.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String setFormContMod(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("setFormContMod started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String contName = request.getParameter("fContName");
		String contName2 = request.getParameter("fContName2");
		String contDescript = request.getParameter("fContDescript");
		String contParent = request.getParameter("fContParent");
		String contDept = request.getParameter("fContDept");
		String contID = request.getParameter("fContID");
		String deptList = request.getParameter("deptList");
		String companyID = request.getParameter("companyID");

		String result = ezApprovalGAdminService.updateFormContainer(contName, contName2, contDescript, contParent, contDept, contID, deptList, companyID, userInfo.getTenantId());
		
		logger.debug("setFormContMod ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식함삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/delFormCont.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String delFormCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("delFormCont started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String contID = request.getParameter("id");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.deleteFormContainer(contID, companyID, userInfo.getTenantId());
		
		logger.debug("delFormCont ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식등록,양식수정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formMain.do")
	public String formMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("formMain started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);		
		//관리자 권한 체크
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String formProcSpelling = config.getProperty("config.FormProcSpelling"); 
		String primary = config.getProperty("config.lang_Primary" + userInfo.getLang());
		String secondary = config.getProperty("config.lang_Secondary" + userInfo.getLang());
		String tCheck = request.getParameter("tCheck");
		String contID = request.getParameter("contID");
		String formID = request.getParameter("formID");
		String docType = ezApprovalGService.getDocType("", userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
		String companyID = request.getParameter("companyID");
		
		String title = (tCheck.equals("fIns") ? egovMessageSource.getMessage("ezApprovalG.t1667", userInfo.getLocale()) : egovMessageSource.getMessage("ezApprovalG.t1668", userInfo.getLocale()));
		
		model.addAttribute("formProcSpelling", formProcSpelling);
		model.addAttribute("topID", userInfo.getCompanyID());
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("title", title);
		model.addAttribute("isInsUp", tCheck);
		model.addAttribute("contID", contID);
		model.addAttribute("formID", formID);
		model.addAttribute("docType", docType);
		model.addAttribute("companyID", companyID);
		
		logger.debug("formMain ended.");
		
		return "admin/ezApprovalG/apprGFormMain";
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식등록,양식수정 양식기본정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getFormInfo.do", produces="text/html;charset=utf-8")
	@ResponseBody
	public String getFormInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFormInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String formID = request.getParameter("formID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getFormContent(formID, userInfo.getLang(), companyID, userInfo.getTenantId());
		
		logger.debug("getFormInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식등록,양식수정 양식작성기 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formSave.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String formSave (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		String companyID = request.getParameter("companyID");
		String contID = request.getParameter("formContID");
		String formID = request.getParameter("formID");
		String formInfo = request.getParameter("formInfo");
		String formMHT = request.getParameter("formMHT");
		String formConnInfo = request.getParameter("formConn");
		String formWorkFlow = request.getParameter("formWorkFlow");
		String formRecevGroup = request.getParameter("formRecevGroup");
		
		String result = ezApprovalGAdminService.saveFormInfo(contID, formID, formInfo, formConnInfo, formWorkFlow, formRecevGroup, formMHT, companyID, realPath, userInfo);
		
		logger.debug("result = " + result);
		
		if (result.indexOf("ERROR") > 0) {
			return "<DATA>" + result + "</DATA>";
		} else {
			return "<DATA>OK</DATA>";
		}
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식작성기 속성조회함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getFormPropList.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getFormPropList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFormPropList started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getFormProperty(userInfo.getLocale(), companyID, userInfo.getTenantId());
		
		logger.debug("getFormPropList ended");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식등록,양식수정 연동정보 추가 화면호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formConnInfo.do")
	public String formConnInfo (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		String realPath = commonUtil.getRealPath(request);
		String path = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		
		File file = new File(realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + "conninfo.xml");
		
		Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(file);
		
		List<String> processIdxList = new ArrayList<String>();
		for (int i = 0; i < doc.getElementsByTagName("PROCESSIDX").getLength(); i ++) {
			processIdxList.add(doc.getElementsByTagName("PROCESSIDX").item(i).getTextContent());
		}
		
		List<String> processTimeList = new ArrayList<String>();
		for (int i = 0; i < doc.getElementsByTagName("PROCESSTIME").getLength(); i ++) {
			processTimeList.add(doc.getElementsByTagName("PROCESSTIME").item(i).getTextContent());
		}
		
		List<String> connStringFlagList = new ArrayList<String>();
		for (int i = 0; i < doc.getElementsByTagName("CONNSTRINGFLAG").getLength(); i ++) {
			connStringFlagList.add(doc.getElementsByTagName("CONNSTRINGFLAG").item(i).getTextContent());
		}
		
		List<String> queryTypeList = new ArrayList<String>();
		for (int i = 0; i < doc.getElementsByTagName("QUERYTYPE").getLength(); i ++) {
			queryTypeList.add(doc.getElementsByTagName("QUERYTYPE").item(i).getTextContent());
		}
		
		List<String> keyKindList = new ArrayList<String>();
		for (int i = 0; i < doc.getElementsByTagName("KEYKIND").getLength(); i ++) {
			keyKindList.add(doc.getElementsByTagName("KEYKIND").item(i).getTextContent());
		}
		
		model.addAttribute("processIdxList", processIdxList);
		model.addAttribute("processTimeList", processTimeList);
		model.addAttribute("connStringFlagList", connStringFlagList);
		model.addAttribute("queryTypeList", queryTypeList);
		model.addAttribute("keyKindList", keyKindList);
		
		model.addAttribute("companyID", companyID);
		
		return "admin/ezApprovalG/apprGFormConnInfo";
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식등록,양식수정 양식별 고정수신처목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getFormRecvAdmin.do", produces="text/html;charset=utf-8")
	@ResponseBody
	public String getFormRecvAdmin(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String formID = request.getParameter("node1");
		
		String result = ezApprovalGAdminService.getFormRecvAdmin(formID, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getTenantId());

		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/delForm.do", produces="text/html;charset=utf-8")
	@ResponseBody
	public String delForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String formID = request.getParameter("formID");
		String companyID = request.getParameter("companyID");
		String realPath = commonUtil.getRealPath(request);
		
		String result = ezApprovalGAdminService.delForm(formID, companyID, realPath, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 미리보기 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formPreview.do")
	public String formPreview(HttpServletRequest request, Model model) throws Exception {
		String docHref = request.getParameter("href");
		 
		model.addAttribute("docHref", docHref);
		
		return "admin/ezApprovalG/apprGFormPreview";
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식이동화면 호출함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formSelect.do")
	public String formSelect(@CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		
		return "admin/ezApprovalG/apprGFormSelect";
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) 양식이동 실행함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formMove.do")
	public String formMove(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("formMove started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		String contID = request.getParameter("contID");
		String selContID = request.getParameter("selContID");
		String formID = request.getParameter("formID");
		
		String result = ezApprovalGAdminService.formMove(companyID, contID, selContID, formID, userInfo.getTenantId());
		
		model.addAttribute("result", result);
		
		logger.debug("formMove ended.");
		
		return "json";
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) ActiveX 다운로드 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/componentListTransfer.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String componentListTransfer(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("componentListTransfer started.");
		StringBuilder result = new StringBuilder();
		String realPath = commonUtil.getRealPath(request); 
		String path = "xml" + commonUtil.separator + "ezApprovalG" + commonUtil.separator + "componentlist_admin.xml";
		path = realPath + commonUtil.separator + path;
		
		logger.debug("path : " + path);
		
		try {
			File file = new File(path);
			BufferedReader br = new BufferedReader(new FileReader(file));
			String line = null;
	
			while ((line = br.readLine()) != null) {
				result.append(line);
			}
			
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("result : " + result.toString().replace("DOWNLOADSERVER", request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getRequestURI()))));
		
		return result.toString().replace("DOWNLOADSERVER", request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getRequestURI())));
	}
	
	/**
	 * 전자결재G관리 양식등록(MHT) ActiveX 다운로드 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/progressAdmin.do")
	public String progressAdmin(Model model) {
	    String IsJMochaStandAlone = config.getProperty("config.IsJMochaStandAlone");
	    
	    model.addAttribute("IsJMochaStandAlone", IsJMochaStandAlone);
	    
		return "/admin/ezApprovalG/apprGProgressAdmin";
	}
	
	/**
	 * 전자결재G관리 문서함관리 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMCont.do")
	public String apprMCont(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO user = commonUtil.aprUserInfo(loginCookie);		
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String serverName = user.getServerName();
				
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(user.getPrimary(), user.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (user.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(user.getCompanyID())) {
				resultList.add(j, vo);
			}
		}
		
		model.addAttribute("companyID", user.getCompanyID());
		model.addAttribute("serverName", serverName);
		model.addAttribute("list", resultList);
		
		return "/admin/ezApprovalG/apprGMCont";
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함데이터 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMgetContInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprMgetContInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("apprMgetContInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("comID");
		String primary = userInfo.getPrimary();

		String result = ezApprovalGAdminService.getContainerInfoManage(deptID, "LIST", companyID, primary, userInfo.getTenantId());
		
		logger.debug("apprMgetContInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함명관리 팝업 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMContType.do")
	public String apprMContType(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String primary = config.getProperty("config.lang_Primary" + userInfo.getLang());
		String secondary = config.getProperty("config.lang_Secondary" + userInfo.getLang());
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		return "admin/ezApprovalG/apprGMContType";
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함명관리 팝업 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMLgetDoctype.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGMLgetDoctype(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("apprGMLgetDoctype started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("comID");
		String primary = userInfo.getPrimary();
		
		String result = ezApprovalGAdminService.getContTypeInfo("LIST", companyID, primary, userInfo.getTenantId());
		
		logger.debug("apprGMLgetDoctype ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함타입 등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGInsertContType.do")	
	public void apprGInsertContType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("apprGInsertContType started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docTypeName = request.getParameter("docTypeName");
		String docTypeName2 = request.getParameter("docTypeName2");
		String companyID = request.getParameter("comID");
		
		ezApprovalGAdminService.insertContainerType(docTypeName, docTypeName2, companyID, userInfo.getTenantId());
		
		logger.debug("apprGInsertContType ended.");
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함타입 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGDeleteContType.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGDeleteContType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("apprGDeleteContType started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docTypeID = request.getParameter("docTypeID");
		String companyID = request.getParameter("comID");
		
		String result = ezApprovalGAdminService.deleteContainerType(docTypeID, companyID, userInfo.getTenantId());
		
		logger.debug("apprGDeleteContType ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서상태등록 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMinsContType.do")
	public String apprGMinsContType(HttpServletRequest request, HttpServletResponse response) throws Exception {		
		return "admin/ezApprovalG/apprGMinsContType";
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서상태등록 등록된 문서함상태 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGGetContDocType.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGGetContDocType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("apprGGetContDocType started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("comID");
		String primary = userInfo.getPrimary();
		
		String result = ezApprovalGAdminService.getContainerToDocStateInfo(companyID, primary, userInfo.getTenantId());
		
		logger.debug("apprGGetContDocType ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서상태등록 문서함상태 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGUpdateContDoctype.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprUpdateContDoctype(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);		
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();
		
		String result = ezApprovalGAdminService.updateContainerToDocStateInfo(doc, companyID, userInfo.getTenantId());

		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함 추가/수정 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMinsContMain.do")
	public String apprMinsContMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("apprGMinsContMain started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String tCheck = request.getParameter("tCheck");
		String serverName = userInfo.getServerName();
		String title = "";
		
		if (tCheck != null) {
			if (tCheck.equals("DContIns")) {
				title = egovMessageSource.getMessage("ezApprovalG.t1651", userInfo.getLocale());
			} else {
				title = egovMessageSource.getMessage("ezApprovalG.t1652", userInfo.getLocale());
			}
		}
		
		model.addAttribute("title", title);
		model.addAttribute("serverName", serverName);
		
		logger.debug("apprGMinsContMain ended.");
		
		return "admin/ezApprovalG/apprGMinsContMain";
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함 추가/수정 팝업 공유부서 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMgetContGroup.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGMgetContGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("apprGMgetContGroup started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String contID = request.getParameter("contID");
		String companyID = request.getParameter("comID");
		String primary = userInfo.getPrimary();
		
		String result = ezApprovalGAdminService.getContainerUseDeptInfo(contID, companyID, primary, userInfo.getTenantId());
		
		logger.debug("apprGMgetContGroup ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함 추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMinsCont.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGMinsCont(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("apprGMinsCont started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		String companyID = doc.getDocumentElement().getChildNodes().item(doc.getDocumentElement().getChildNodes().getLength() - 1).getTextContent();
		
		String result = ezApprovalGAdminService.insertContainer(doc, companyID, userInfo.getTenantId());
		
		logger.debug("apprGMinsCont ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함 수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMupdateCont.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGMupdateCont(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("apprGMupdateCont started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		String companyID = doc.getDocumentElement().getChildNodes().item(doc.getDocumentElement().getChildNodes().getLength() - 1).getTextContent();
		
		String result = ezApprovalGAdminService.updateContainer(doc, companyID, userInfo.getTenantId());
		
		logger.debug("apprGMupdateCont ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMdelCont.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGMdelCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("apprGMdelCont started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String contID = request.getParameter("contID");
		String companyID = request.getParameter("comID");
				
		String result = ezApprovalGAdminService.deleteContainer(contID, companyID, userInfo.getTenantId());
		
		logger.debug("apprGMdelCont ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGReceiveGroup.do")	
	public String apprGReceiveGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {		
		LoginVO user = commonUtil.aprUserInfo(loginCookie);
		String serverName = user.getServerName();
		String topID = "";
		
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		if (user.getRollInfo().indexOf("c=1") == -1) {
			topID = user.getCompanyID();
		} else {
			topID = "Top";
		}
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(user.getPrimary(), user.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (user.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(user.getCompanyID())) {
				resultList.add(j, vo);
			}
		}
		model.addAttribute("companyID", user.getCompanyID());
		model.addAttribute("serverName", serverName);
		model.addAttribute("topID", topID);
		model.addAttribute("list", resultList);
		
		return "admin/ezApprovalG/apprGReceiveGroup";
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 등록된 그룹데이터 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getAdminReceivGroup.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getAdminReceivGroup(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO user = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		
		String pid = doc.getDocumentElement().getChildNodes().item(0).getTextContent();
		String pmode = doc.getDocumentElement().getChildNodes().item(1).getTextContent();
		String pcompanyID = user.getCompanyID();
				
		if (doc.getDocumentElement().getChildNodes().getLength() > 2) {
			pcompanyID = doc.getDocumentElement().getChildNodes().item(2).getTextContent();
		}
		
		String result = ezApprovalGAdminService.getReceiveGroupInfo(pid, pmode, pcompanyID, user.getPrimary(), user.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 부서등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setGroupSubItemInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String setGroupSubItemInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("setGroupSubItemInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String groupID = request.getParameter("node1");
		String deptID = request.getParameter("node2");
		String deptName = request.getParameter("node3");
		String companyID = request.getParameter("node4");
		String pCompanyID = request.getParameter("node5");
		String deptName2 = request.getParameter("node6");
		
		String result = ezApprovalGAdminService.insertReceiveGroupItemInfo(groupID, deptID, deptName, deptName2, pCompanyID, companyID, userInfo.getTenantId());
		
		logger.debug("setGroupSubItemInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 부서삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deleteGroupSubiteminfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String deleteGroupSubiteminfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("deleteGroupSubiteminfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String groupID = request.getParameter("node1");
		String companyID = request.getParameter("node2");
				
		String result = ezApprovalGAdminService.deleteReceiveGroupItemInfo(groupID, companyID, userInfo.getTenantId());
		
		logger.debug("deleteGroupSubiteminfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/updateGroupMainInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String updateGroupMainInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("updateGroupMainInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String groupID = request.getParameter("node1");
		String groupName = request.getParameter("node2");
		String companyID = request.getParameter("node3");
		
		String result = ezApprovalGAdminService.updateReceiveGroupInfo(groupID, groupName, companyID, userInfo.getTenantId());
		
		logger.debug("updateGroupMainInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setGroupMainInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String setGroupMainInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("setGroupMainInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String groupName = request.getParameter("node1");
		String companyID = request.getParameter("node2");
		
		String result = ezApprovalGAdminService.insertReceiveGroupInfo(groupName, companyID, userInfo.getTenantId());
		
		logger.debug("setGroupMainInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deleteGroupMainInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String deleteGroupMainInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("deleteGroupMainInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String groupID = request.getParameter("node1");
		String companyID = request.getParameter("node2");
		
		String result = ezApprovalGAdminService.deleteReceiveGroupInfo(groupID, companyID, userInfo.getTenantId());
		
		logger.debug("deleteGroupMainInfo ended.");
		
		return result;
	}
	
	//장진혁과장 작성 이후 이효진사원 추가
	
	/**
	 * 전자결재G관리 분류,단위업무관리 메뉴 호출 함수 
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGTaskCodeManage.do")
	public String apprGTaskCodeManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		
		return "admin/ezApprovalG/apprGTaskCodeManage";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCategoryTree.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskCategoryTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String categoryType = request.getParameter("categoryType");
		String parentID = request.getParameter("parentID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCategoryTree(categoryType, parentID, companyID, userInfo.getTenantId());

		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류목록에따른 단위업무 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskInSubCategoryForManage.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskInSubCategoryForManage(@CookieValue("loginCookie") String loginCookie, @RequestBody String data) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		
		String result = ezApprovalGAdminService.getTaskInSubCategoryForManage(doc, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류추가,분류수정 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskCategoryInsert.do")
	public String taskCategoryInsert(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String tCheck = request.getParameter("tCheck");
		String title = "";
		
		if (tCheck.equals("ins")) {
			title = egovMessageSource.getMessage("ezApprovalG.t734", userInfo.getLocale());
		} else {
			title = egovMessageSource.getMessage("ezApprovalG.t735", userInfo.getLocale());
		}
		model.addAttribute("title", title);
		
		return "admin/ezApprovalG/apprGTaskCategoryInsert";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류추가  중복확인 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCategoryDuplicate.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskCategoryDuplicate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String categoryType = request.getParameter("cateType");
		String categoryCode = request.getParameter("sCateCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCategoryDuplicate(categoryType, categoryCode, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류추가 분류선택 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/selectTaskCategory.do")
	public String selectTaskCategory() {
		return "admin/ezApprovalG/apprGSelectTaskCategory";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류추가,분류수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setTaskCategory.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String setTaskCategory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String categoryType = request.getParameter("categoryType");
		String categoryCode = request.getParameter("categoryCode");
		String categoryName = request.getParameter("categoryName");
		String categoryName2 = request.getParameter("categoryName2");
		String categoryDesc = request.getParameter("categoryDesc");
		String pCode = request.getParameter("pCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.setTaskCategory(categoryType, categoryCode, categoryName, categoryName2, categoryDesc, pCode, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류삭제 시 하위노드 여부 체크 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCategoryNodeExist.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskCategoryNodeExist(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String categoryType = request.getParameter("cateType");
		String categoryCode = request.getParameter("sCateCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCategoryNodeExist(categoryType, categoryCode, companyID, userInfo.getTenantId());

		return result;
	}

	/**
	 * 전자결재G관리 분류,단위업무관리 분류삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/removeTaskCategory.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String removeTaskCategory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String categoryType = request.getParameter("cateType");
		String categoryCode = request.getParameter("cateCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.removeTaskCategory(categoryType, categoryCode, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드추가,수정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskCodeInsert.do")
	public String taskCodeInsert(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String tCheck = request.getParameter("tCheck");
		String title = "";
		
		if (tCheck.equals("ins")) {
			title = egovMessageSource.getMessage("ezApprovalG.t763", userInfo.getLocale());
		} else {
			title = egovMessageSource.getMessage("ezApprovalG.t764", userInfo.getLocale());
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("title", title);
		
		return "admin/ezApprovalG/apprGTaskCodeInsert";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드추가 단위업무코드 중복확인 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCodeDuplicate.do", produces = "text/html; charset=utf-8")
	@ResponseBody
	public String getTaskCodeDuplicate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String taskCode = request.getParameter("sCateCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCodeDuplicate(taskCode, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드수정 단위업무정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskInfo.do", produces = "text/html; charset=utf-8")
	@ResponseBody
	public String getTaskInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String pTaskCode = request.getParameter("taskCode");
		String pDeptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskInfo(pTaskCode, pDeptCode, companyID, userInfo.getTenantId());

		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드추가,수정 실행함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setTaskCode.do")
	@ResponseBody
	public String setTaskCode (@CookieValue("loginCookie") String loginCookie, ApprGTaskVO vo, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.setTaskCode(vo, companyID, userInfo);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 단위업무의 소속 기록물철 여부 체크 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCodeNodeExist.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskCodeNodeExist(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String taskCode = request.getParameter("taskCode");
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCodeNodeExist(taskCode, deptID, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리분류,단위업무관리  코드삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/removeTaskCode.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String removeTaskCode(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String taskCode = request.getParameter("taskCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.removeTaskCode(taskCode, companyID, userInfo);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 사용부서 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskDeptInfoManage.do")
	public String taskDeptInfoManage(@CookieValue("loginCookie") String loginCookie, Model model) {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String serverName = userInfo.getServerName();
		
		model.addAttribute("serverName", serverName);
		
		return "admin/ezApprovalG/apprGTaskDeptInfoManage";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 사용부서 부서에 포함된 단위업무목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCodeDeptInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskCodeDeptInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String taskCode = request.getParameter("taskCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCodeDeptInfo(taskCode, companyID, userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 사용부서 부서추가 실행함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/addTaskCodeDeptInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String addTaskCodeDeptInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("addTaskCodeDeptInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String taskCode = request.getParameter("taskCode");
		String deptCode = request.getParameter("deptID");
		String deptName = request.getParameter("deptName");
		String deptName2 = request.getParameter("deptName2");
		String companyID = request.getParameter("companyID");
		
		logger.debug("taskCode : " + taskCode + ", deptCode : " + deptCode + ", deptName : " + deptName + ", deptName2 : " + deptName2 + ", companyID : " + companyID);
		
		String result = ezApprovalGAdminService.addTaskCodeDeptInfo(taskCode, deptCode, deptName, deptName2, companyID, userInfo);
		
		logger.debug("result : " + result);
		logger.debug("addTaskCodeDeptInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 사용부서 부서삭제 실행함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/removeTaskCodeDeptInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String removeTaskCodeDeptInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String taskCode = request.getParameter("taskCode");
		String deptCode = request.getParameter("deptID");
		String deptName = request.getParameter("deptName");
		String deptName2 = request.getParameter("deptName2");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.removeTaskCodeDeptInfo(taskCode, deptCode, deptName, deptName2, companyID, userInfo);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드정보 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/viewTaskInfo.do")
	public String viewTaskInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		return "admin/ezApprovalG/apprGViewTaskInfo";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드이력 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskHistoryInfo.do")
	public String taskHistoryInfo() {
		return "admin/ezApprovalG/apprGTaskHistoryInfo";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드이력 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskHistory.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskHistory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String taskCode = request.getParameter("docID");
		String companyID = request.getParameter("companyID");

		String result = ezApprovalGAdminService.getTaskHistory(taskCode, companyID, userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 부서별 단위업무 조회 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskAdminDept.do")
	public String taskAdminDept(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String serverName = userInfo.getServerName();
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("serverName", serverName);
		model.addAttribute("list", resultList);
		
		return "admin/ezApprovalG/apprGTaskAdminDept";
	}
	
	/**
	 * 전자결재G관리 부서별 단위업무 목록 호출 함수(분류기준표 정보를 가져온다.)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskFullList.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskFullList (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String deptCode = request.getParameter("deptCode");
		String pageSize = request.getParameter("pageSize");
		String pageNo = request.getParameter("pageNo");
		String langType = request.getParameter("langType");
		String companyID = request.getParameter("companyID");
		
		String listXML = ezApprovalGAdminService.getTaskFullList(deptCode, pageSize, pageNo, langType.trim(), companyID, userInfo.getTenantId());

		Document xmldoc = commonUtil.convertStringToDocument(listXML);
	
		if (xmldoc.getElementsByTagName("ROW") != null) {
			for (int i = 0; i < xmldoc.getElementsByTagName("ROW").getLength(); i ++) {
				if (!xmldoc.getElementsByTagName("ROW").item(i).getChildNodes().item(11).getChildNodes().item(0).getTextContent().trim().equals("")) {
					xmldoc.getElementsByTagName("ROW").item(i).getChildNodes().item(11).getChildNodes().item(0).setTextContent(egovMessageSource.getMessage("ezApprovalG." + xmldoc.getElementsByTagName("ROW").item(i).getChildNodes().item(11).getChildNodes().item(0).getTextContent().trim(), userInfo.getLocale()));
				}
			}
		}
		
		return commonUtil.convertDocumentToString(xmldoc);
	}
	
	/**
	 * 전자결재G관리 관인대장 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/manageSeal.do")
	public String manageSeal (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		
		return "admin/ezApprovalG/apprGManageSeal";
	}
	
	/**
	 * 전자결재G관리 관인대장 회사별 관인목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getSealList.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getSealList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String listFlag = request.getParameter("listFlag");
		String companyID = userInfo.getCompanyID();
		
		if (request.getParameter("companyID") != null) {
			companyID = request.getParameter("companyID");
		}
		
		//'pListFlag : "LIST" - 리스트 가져오기, "ADMIN" - 대장 가져오기(관리자)
		String result = ezApprovalGAdminService.getSealList(listFlag, companyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 관인대장 관인정보보기 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/sealInfo.do")
	public String ezSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		boolean checkIE = commonUtil.checkIE(request);
		String pDeptYN = request.getParameter("pDeptYN");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("checkIE", checkIE);
		model.addAttribute("pDeptYN", pDeptYN);
		
		return "admin/ezApprovalG/apprGSealInfo";
	}
	
	/**
	 * 전자결재G관리 관인대장 관인등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/addSealInfo.do")
	public String addSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		boolean checkIE = commonUtil.checkIE(request);
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("checkIE", checkIE);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		return "admin/ezApprovalG/apprGAddSealInfo";
	}
	
	/**
	 * 전자결재G관리 관인대장 관인등록 파일등록 실행 함수 최신
	 */
	@RequestMapping(value = "/admin/ezApprovalG/sealImageUpload.do")
	public String sealImageUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		MultipartFile multiFile = request.getFile("file1");
		String companyID = request.getParameter("companyID");
		String realPath = commonUtil.getRealPath(request);
		String dirPath = commonUtil.getUploadPath("upload_approvalG.SEALIMG", userInfo.getTenantId());
		String currentDate = commonUtil.getTodayUTCTime("yyyyMMddHHmmss");
		String fileExt = multiFile.getOriginalFilename().substring(multiFile.getOriginalFilename().lastIndexOf("."));
		
		File dir = new File(realPath + dirPath);
		
        if (!dir.exists()) {
        	dir.mkdirs();
        }
        
		String fileName = companyID + "_" + currentDate + fileExt;
		
		writeUploadedFile(multiFile, fileName, realPath + dirPath);
		
		model.addAttribute("fileName", fileName);
		model.addAttribute("path", dirPath + commonUtil.separator);
		
		return "json";
	}
	
	/**
	 * 전자결재G관리 관인대장 관인등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/insertSealInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String insertSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String pSealNum = request.getParameter("pSealNum");
		String pSealName = request.getParameter("pSealName");
		String pSealPath = request.getParameter("pSealPath");
		String pSealWidth = request.getParameter("pSealWidth");
		String pSealHeight = request.getParameter("pSealHeight");
		String pRegUserID = request.getParameter("pRegUserID");
		String pRegUserName = request.getParameter("pRegUserName");
		String pRegUserName2 = request.getParameter("pRegUserName2");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.insertSealInfo(pSealNum, pSealName, pSealPath, pSealWidth, pSealHeight, pRegUserID, pRegUserName, pRegUserName2, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 관인대장 관인등록 삭제 실행 함수 (등록하지 않고 종료시 파일 삭제)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/sealDelete.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String sealDelete(HttpServletRequest request) throws Exception {
		String realPath = commonUtil.getRealPath(request);
		String dirPath = request.getParameter("dirPath");
		String fileName = request.getParameter("fileName");
		
		String result = ezApprovalGAdminService.sealDelete(realPath, dirPath, fileName);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 관인대장 관인삭제 실행 함수(삭제일자만 추가, 파일삭제X) 
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deleteSealInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String deleteSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String pSealNum = request.getParameter("pSealNum");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.deleteSealInfo(pSealNum, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/manageDeptSeal.do")
	public String manageDeptSeal(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String serverName = userInfo.getServerName();

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("serverName", serverName);
		model.addAttribute("list", resultList);
		
		return "admin/ezApprovalG/apprGManageDeptSeal";
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 부서에따른 직인목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getDeptSealList.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getDeptSealList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String listFlag = request.getParameter("listFlag");
		String deptID = request.getParameter("deptID");
		String companyID = userInfo.getCompanyID();
		
		if (request.getParameter("companyID") != null) {
			companyID = request.getParameter("companyID");
		}
		
		//'pListFlag : "LIST" - 리스트 가져오기, "ADMIN" - 대장 가져오기(관리자)
		String result = ezApprovalGAdminService.getSealDeptList(listFlag, deptID, companyID, userInfo.getPrimary(), userInfo.getOffset(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 직인등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/addDeptSealInfo.do")
	public String addDeptSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		boolean checkIE = commonUtil.checkIE(request);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("checkIE", checkIE);
		
		return "admin/ezApprovalG/apprGAddDeptSealInfo";
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 직인등록 파일등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deptSealUpload.do")
	public String deptSealUpload (@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		MultipartFile multiFile = request.getFile("file1");
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("companyID");
		String realPath = commonUtil.getRealPath(request);
		String dirPath = commonUtil.getUploadPath("upload_approvalG.SEALIMG", userInfo.getTenantId());
		String currentDate = commonUtil.getTodayUTCTime("").replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "");
		String fileExt = multiFile.getOriginalFilename().substring(multiFile.getOriginalFilename().lastIndexOf("."));
		
		File dir = new File(realPath + dirPath);
        if (!dir.exists()) {
        	dir.mkdirs();
        }
        
        int width = 0;
		int height = 0;
		String fileName = companyID + "_" + deptID + "_" + currentDate + fileExt;
		
		writeUploadedFile(multiFile, fileName, realPath + dirPath);
		
		File imageFile = new File(realPath + dirPath + commonUtil.separator + fileName);
	
		if (imageFile.exists()) {
			BufferedImage bi = ImageIO.read(new File(realPath + dirPath + commonUtil.separator + fileName));			    
			width = bi.getWidth();
			height = bi.getHeight();
		}
		
		model.addAttribute("fileName", fileName);
		model.addAttribute("path", dirPath + commonUtil.separator);
		model.addAttribute("width", width);
		model.addAttribute("height", height);
		
		return "json";
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 직인등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/insertDeptSealInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String insertDeptSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String pSealNum = request.getParameter("pSealNum");
		String pSealName = request.getParameter("pSealName");
		String pSealPath = request.getParameter("pSealPath");
		String pSealWidth = request.getParameter("pSealWidth");
		String pSealHeight = request.getParameter("pSealHeight");
		String pRegUserID = request.getParameter("pRegUserID");
		String pRegUserName = request.getParameter("pRegUserName");
		String pRegUserName2 = request.getParameter("pRegUserName2");
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.insertDeptSealInfo(pSealNum, pSealName, pSealPath, pSealWidth, pSealHeight, pRegUserID, pRegUserName, pRegUserName2, deptID, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 직인등록 삭제 실행 함수 (등록하지 않고 종료시 파일 삭제)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deptSealDelete.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String deptSealDelete(HttpServletRequest request) throws Exception {
		String realPath = commonUtil.getRealPath(request);
		String dirPath = request.getParameter("dirPath");
		String fileName = request.getParameter("fileName");
		
		String result = ezApprovalGAdminService.sealDelete(realPath, dirPath, fileName);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 직인삭제 실행 함수(삭제일자만 추가 파일삭제X) 
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deleteDeptSealInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String deleteDeptSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String pSealNum = request.getParameter("pSealNum");
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.deleteDeptSealInfo(pSealNum, deptID, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서유통암호화설정 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/manageSendInfo.do")
	public String manageSendInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		String encodeInfoPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		model.addAttribute("encodeInfoPath", encodeInfoPath);
		
		return "/admin/ezApprovalG/apprGManageSendInfo";
	}
	
	/**
	 * 전자결재G관리 문서유통암호화설정 설정파일 조회함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getOptionInfo.do")
	public String getOptionInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getOptionInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		String companyPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		String encodeInfo = "";
		
		File file = new File(realPath + companyPath + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "encodeinfo.xml");
		encodeInfo = FileUtils.readFileToString(file);
		
		model.addAttribute("encodeInfo", encodeInfo);
		
		logger.debug("getOptionInfo ended.");
		
		return "json";
	}
	
	
	/**
	 * 전자결재G관리 문서유통암호화설정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/saveOptionInfo.do")
	@ResponseBody
	public String saveOptionInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String optionValue1 = request.getParameter("option1");
		String optionValue2 = request.getParameter("option2");
		String optionValue3 = request.getParameter("option3");
		String companyID = request.getParameter("companyID");
		String realPath = commonUtil.getRealPath(request);
		String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		
		String returnString = "<ENCODEINFO><SIGN>" + optionValue1 + "</SIGN><ENCODE>" + optionValue2 + "</ENCODE><NONE>" + optionValue3 + "</NONE></ENCODEINFO>";
		 
		try {
			File cFile = new File(realPath + dirPath + commonUtil.separator + companyID);
			if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				if (!_flag) {
					throw new IOException("Directory creation Failed ");
				}
			}
			
			File file = new File(realPath + dirPath + commonUtil.separator + companyID + commonUtil.separator + "encodeinfo.xml");
			BufferedWriter writer = new BufferedWriter(new FileWriter(file, false));
			writer.write(returnString);
			writer.flush();
			writer.close();
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";
		}
	}
	
	/**
	 * 전자결재G관리 결재건수조회 메뉴 화면 호출 함수
	 */
	@RequestMapping("/admin/ezApprovalG/EzStatistics.do")
	public String ezStatistics(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}

		String tempYear = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("YYYY"), userInfo.getOffset(), false);
		String tempMonth = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("MM"), userInfo.getOffset(), false);
		
		int tempPYear = Integer.parseInt(tempYear);
		int tempPMonth = Integer.parseInt(tempMonth) - 1;
		
		if (tempPMonth <= 0) {
			tempPYear = tempPYear - 1;
			tempPMonth = 12;
		}
				
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		model.addAttribute("tempPYear", tempPYear);
		model.addAttribute("tempPMonth", tempPMonth);
		model.addAttribute("tempYear", tempYear);
		model.addAttribute("tempMonth", tempMonth);
		
		return "admin/ezApprovalG/apprGEzStatistics";
	}
	
	/**
	 * 전자결재G관리 결재건수조회 처리과별 검색 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getDeptTranSendDocCount.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getDeptTranSendDocCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String sYear = request.getParameter("sYear");
		String sMonth = request.getParameter("sMonth");
		String eYear = request.getParameter("eYear");
		String eMonth = request.getParameter("eMonth");
		String pMode = request.getParameter("pMode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getDeptTranSendDocCount(sYear, sMonth, eYear, eMonth, pMode, companyID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 결재건수조회 개인별 검색 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getUserDocCount.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getUserDocCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String sYear = request.getParameter("sYear");
		String sMonth = request.getParameter("sMonth");
		String eYear = request.getParameter("eYear");
		String eMonth = request.getParameter("eMonth");
		String userFlag = request.getParameter("userFlag");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getUserDocCount(sYear, sMonth, eYear, eMonth, userFlag, companyID, userInfo);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 결재건수조회 엑셀저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/ezStatistics/excelExportOut.do")
	public void excelExportOut(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		StringBuilder resultExcel = new StringBuilder();
		String excelValue = "";
		String flag = request.getParameter("flag");
		String sYear = request.getParameter("p0");
		String sMonth = request.getParameter("p1");
		String eYear = request.getParameter("p2");
		String eMonth = request.getParameter("p3");
		String mode = request.getParameter("p4");
		String companyID = request.getParameter("p5");
		
		if (flag.equals("USER")) {
			excelValue = ezApprovalGAdminService.getUserDocCount(sYear, sMonth, eYear, eMonth, mode, companyID, userInfo);
		} else {
			excelValue = ezApprovalGAdminService.getDeptTranSendDocCount(sYear, sMonth, eYear, eMonth, mode, companyID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());
		}
		
		Document objXML = commonUtil.convertStringToDocument(excelValue);
		
		resultExcel.append("\uFEFF");
		resultExcel.append("<table><tr>");
		
		for (int k = 0; k < objXML.getElementsByTagName("HEADER").getLength(); k++) {
			String headerName = objXML.getElementsByTagName("NAME").item(k).getTextContent();
			String headerWidth = objXML.getElementsByTagName("WIDTH").item(k).getTextContent();
			
			int width = Integer.parseInt(headerWidth) * 2;
			
			resultExcel.append("<td style='BORDER-BOTTOM: windowtext 0.5pt solid; BORDER-LEFT: windowtext; BACKGROUND-COLOR: #a6a6a6; BORDER-TOP: windowtext 0.5pt solid; BORDER-RIGHT: windowtext 0.5pt solid;width:" + width + "'><p align=center><STRONG>" + commonUtil.cleanValue(headerName) + "</STRONG></p></td>        ");
		}
		resultExcel.append("</tr></table>");
		
		resultExcel.append("<table>");
		
		NodeList objRow = objXML.getElementsByTagName("ROW");
		
		for (int k = 0; k < objRow.getLength(); k++) {
			resultExcel.append("<tr>");
			Element row = (Element) objRow.item(k);
			NodeList objCell = row.getElementsByTagName("CELL");
			
			for (int p = 0; p < objCell.getLength(); p++) {
				Element cell = (Element) objCell.item(p);
				String cellValue = cell.getElementsByTagName("VALUE").item(0).getTextContent();
				String headerWidth = objXML.getElementsByTagName("WIDTH").item(p).getTextContent();
				int width = Integer.parseInt(headerWidth) * 2;
				
				resultExcel.append("<td style='BORDER-BOTTOM: windowtext 0.5pt solid; BORDER-LEFT: windowtext; BORDER-TOP: windowtext 0.5pt solid; BORDER-RIGHT: windowtext 0.5pt solid;width:" + width + "'><p align=left>" + commonUtil.cleanValue(cellValue) + "</p></td>       ");
			}
			resultExcel.append("</tr>");
		}
		resultExcel.append("</table>");
		
		response.setContentType("application/ms-excel");
		response.setCharacterEncoding("utf-8");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + EgovDateUtil.getTodayTime().substring(0, 10) + "_excelExportOutUser" + ".xls\"");
		
		response.getWriter().write(resultExcel.toString());
	}
	
	/**
	 * 전자결재G관리 전체문서조회(진행문서) 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/forAprDoc.do")
	public String forAprDoc(@CookieValue ("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		
		return "admin/ezApprovalG/apprGForAprDoc";
	}
	
	/**
	 * 전자결재G관리 전체문서조회(진행문서) 문서목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatSearchAprDocList.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getStatSearchAprDocList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docNumber = request.getParameter("docNumber");
        String docTitle = request.getParameter("docTitle");
        String drafter = request.getParameter("drafter");
        String drafter2 = request.getParameter("drafter2");
        
        String draftFromYear = request.getParameter("draftFromYear");
        String draftFromMonth = request.getParameter("draftFromMonth");
        String draftFromDay = request.getParameter("draftFromDay");

        String draftToYear = request.getParameter("draftToYear");
        String draftToMonth = request.getParameter("draftToMonth");
        String draftToDay = request.getParameter("draftToDay");

        String apprFromYear = request.getParameter("apprFromYear");
        String apprFromMonth = request.getParameter("apprFromMonth");
        String apprFromDay = request.getParameter("apprFromDay");
        
        String apprToYear = request.getParameter("apprToYear");
        String apprToMonth = request.getParameter("apprToMonth");
        String apprToDay = request.getParameter("apprToDay");

        String formID = request.getParameter("formID");
        String draftDeptName = request.getParameter("deptName1");
        String draftDeptName2 = request.getParameter("deptName2");
        String pageNum = request.getParameter("pageNum");
        String pageSize = request.getParameter("pageSize");
        String docState = request.getParameter("docState");

        String subQuery = request.getParameter("subQuery");
        String orderCell = request.getParameter("orderCell");
        String orderOption = request.getParameter("orderOption");
        String approvUser = request.getParameter("approvUser");
        String companyID = request.getParameter("companyID");
		
        String result = ezApprovalGAdminService.searchManageAprDocList(docNumber, docTitle, drafter, drafter2, draftFromYear, draftFromMonth, draftFromDay, 
				draftToYear,draftToMonth,draftToDay, apprFromYear, apprFromMonth, apprFromDay, apprToYear, apprToMonth, apprToDay, formID, draftDeptName, 
				draftDeptName2,pageNum, pageSize, docState, subQuery, orderCell, orderOption, companyID, userInfo.getPrimary(), approvUser, userInfo.getOffset(), userInfo.getTenantId());
        
        return result; 
	}
	
	/**
	 * 전자결재G관리 전체문서조회(진행문서) 문서별 결재선 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatLineList.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getStatLineList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("flag");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGService.getLineInfo(docID, mode, "", "", companyID, userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/** 
	 * 전자결재G관리 전체문서조회(진행문서) 문서별 수신자 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatReceiptList.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getStatReceiptList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("flag");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGService.getReceiptInfo(docID, mode, "", "", companyID, userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 전체문서조회(진행문서) 문서별 첨부 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatAttachList.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getStatAttachList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("flag");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGService.getAttachInfo(docID, mode, "", "", companyID, userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 전체문서조회(진행문서) 문서별 의견 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatOpinionList.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getStatOpinionList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("flag");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGService.getOpinionInfo(docID, mode, "", "", companyID, userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 전체문서조회(완료문서) 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/forDoc.do")
	public String forDoc(@CookieValue ("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		boolean auth = commonUtil.checkAdmin(loginCookie);
		String useEditor = config.getProperty("config.EDITOR");
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("list", resultList);
		
		return "admin/ezApprovalG/apprGForDoc";
	}
	
	/**
	 * 전자결재G관리 전체문서조회(완료문서) 문서목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatSearchDocList.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getStatSearchDocLlist(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getStatSearchDocList started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docNumber = request.getParameter("docNumber");
        String docTitle = request.getParameter("docTitle");
        String drafter = request.getParameter("drafter");
        
        String draftFromYear = request.getParameter("draftFromYear");
        String draftFromMonth = request.getParameter("draftFromMonth");
        String draftFromDay = request.getParameter("draftFromDay");
        
        String draftToYear = request.getParameter("draftToYear");
        String draftToMonth = request.getParameter("draftToMonth");
        String draftToDay = request.getParameter("draftToDay");

        String apprFromYear = request.getParameter("apprFromYear");
        String apprFromMonth = request.getParameter("apprFromMonth");
        String apprFromDay = request.getParameter("apprFromDay");
        
        String apprToYear = request.getParameter("apprToYear");
        String apprToMonth = request.getParameter("apprToMonth");
        String apprToDay = request.getParameter("apprToDay");

        String formID = request.getParameter("formID");
        String draftDeptName = request.getParameter("deptName1");
        String pageNum = request.getParameter("pageNum");
        String pageSize = request.getParameter("pageSize");
        String docState = request.getParameter("docState");

        String subQuery = request.getParameter("subQuery");
        String orderCell = request.getParameter("orderCell");
        String orderOption = request.getParameter("orderOption");
        String approvUser = request.getParameter("approvUser");
        String companyID = request.getParameter("companyID");

        String result = ezApprovalGService.getSearchDocList("ADMIN", "", subQuery, docNumber, docTitle, drafter, formID, draftFromYear, draftFromMonth, draftFromDay, 
				draftToYear, draftToMonth, draftToDay, apprFromYear, apprFromMonth, apprFromDay, apprToYear, apprToMonth, apprToDay, "", "", "", "", "", "",
				draftDeptName, docState, "", pageSize, pageNum, orderCell, orderOption, companyID, userInfo.getLang(), approvUser, userInfo.getTenantId(), userInfo.getOffset());
        
        logger.debug("result = " + result);
        logger.debug("getStatSearchDocList ended.");
		return result;
	}
	
	/** 
	 * 전자결재G관리 전체문서조회 검색 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/search.do")
	public String search(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String ingFlag = request.getParameter("ingFlag");
		String initDate = EgovDateUtil.getToday("-");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("aprFlag", ingFlag);
		model.addAttribute("initDate", initDate);
		
		return "admin/ezApprovalG/apprGSearch";
	}
	
	/**
	 * 전자결재G관리 전체문서조회 폐기 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setContainerIDForDoc.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String setContainerIDForDoc (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("setContainerIDForDoc started.");
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String containerType = request.getParameter("containerType");
		String companyID = request.getParameter("companyID");

		String containerID = ezApprovalGAdminService.setContainerIDForDoc1(deptID, containerType, companyID, userInfo.getTenantId());
		
		if (containerID == null) {
			containerID = ezApprovalGService.makeContainer(deptID, containerID, companyID, userInfo.getTenantId());
		}
		
		String result;
		if (containerID != null) {
			result = ezApprovalGAdminService.setContainerIDForDoc2(docID, containerID, companyID, userInfo.getTenantId());
		} else {
			result = "NOCONTAINERID";
		}
		
		logger.debug("setContainerIDForDoc ended.");
		
		return result;
	}
}
