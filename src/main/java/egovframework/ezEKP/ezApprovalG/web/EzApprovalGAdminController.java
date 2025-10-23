package egovframework.ezEKP.ezApprovalG.web;

import java.io.FileOutputStream;
import java.nio.charset.StandardCharsets;

import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.web.LoginController;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.json.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGContInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormConnInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezApprovalG.vo.KEDAuthorUserInfo;
import egovframework.ezEKP.ezApprovalG.vo.KEDSharedUserInfo;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezJournal.service.EzJournalService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganProxyVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopOtherCompanyAddJobVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

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
public class EzApprovalGAdminController extends EzFileMngUtil {
	
	@Autowired	
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzApprovalGService ezApprovalGService;
	
	@Autowired
	private EzApprovalGAdminService ezApprovalGAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzJournalService ezJournalService;

	@Autowired
	LoginService loginService;

	@Autowired
	LoginController loginController;

	@Value("#{globals['Globals.DbType']}")
	private String dbType;
	
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGAdminController.class);
	
	/**
	 * 전자결재G관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMain.do", method = RequestMethod.GET)
	public String apprGMain() throws Exception {
		return "/admin/ezApprovalG/apprGMain";
	}
	
	/**
	 * 전자결재G관리 왼쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGLeft.do", method = RequestMethod.GET)
	public String apprGLeft(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("apprGLeft started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		String useAdminBujae = "";
        if (ezCommonService.getTenantConfig("useAdminBujae", tenantID).equalsIgnoreCase("YES")) {
        	useAdminBujae = "YES";
        }
        else {
        	useAdminBujae = "NO";
        }
        
        logger.debug("useAdminBujae = " + useAdminBujae);
        
        String useEnforceSihang = ezCommonService.getTenantConfig("UseEnforceSihang", userInfo.getTenantId());
		
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("useAdminBujae", useAdminBujae);
		model.addAttribute("useEnforceSihang", useEnforceSihang);
		model.addAttribute("lang", userInfo.getLang());
		
		//원문공개사용여부
		String useOpenGov = config.getProperty("config.useOpenGov"); 
		
		model.addAttribute("useOpenGov", useOpenGov);
		
		/* 2022-12-27 홍승비 - 전자결재G 기록물철 자동생성기능 메뉴 표출 플래그 추가 */
		String useRegisterCabinetSemiAuto = ezCommonService.getTenantConfig("useRegisterCabinetSemiAuto", userInfo.getTenantId());
		
		model.addAttribute("useRegisterCabinetSemiAuto", useRegisterCabinetSemiAuto);
		
		/* 2024-07-22 양지혜 - 대외발신현황 사용여부 */
		String useSendOutState = ezCommonService.getTenantConfig("useSendOutState", userInfo.getTenantId());
		model.addAttribute("useSendOutState", useSendOutState);
		
		logger.debug("apprGLeft ended. approvalFlag = " + approvalFlag);
		
		return "/admin/ezApprovalG/apprGLeft";
	}
	
	/**
	 * 전자결재G관리 양식등록 메뉴 호출 함수
	 * 전자결재관리 양식등록 메뉴 호출함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formAdmin.do", method = RequestMethod.GET)
	public String formAdmin(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("formAdmin started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		String docType = ezApprovalGService.getDocType("ALL", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale(), approvalFlag);
		String multiData = userInfo.getPrimary();
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
//		폼프로세서 사용하려면 useEditor "" 으로 세팅
		String useHWP = ezCommonService.getTenantConfig("useHWP", userInfo.getTenantId());
		String useWebHWP = ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId());

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("docType", docType);
		model.addAttribute("multiData", multiData);
		model.addAttribute("list", resultList);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useHWP", useHWP);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("useWebHWP", useWebHWP);
		
		logger.debug("formAdmin ended.");
		
		return "admin/ezApprovalG/apprGFormAdmin";
	}
	
	/**
	 * 전자결재G관리 양식등록 기안양식함목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getFormContInfo.do", method = RequestMethod.POST)
	public String getFormContInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getFormContInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String id = request.getParameter("id");
		String companyID = request.getParameter("companyID");
		
		logger.debug("id : " + id + ", companyID : " + companyID);
		
		String result = ezApprovalGService.getFormContainerInfo(id, "", companyID, userInfo.getPrimary(), userInfo.getTenantId(), approvalFlag);
		
		model.addAttribute("resultXML", result);
		
		logger.debug("getFormContInfo ended.");
		
		return "json";
	}
	
	/**
	 * 전자결재G관리 양식등록 기안양식목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getFormList.do", method = RequestMethod.POST)
	public String getFormList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getFormList started.");
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String id = request.getParameter("id");
		String kind = request.getParameter("kind");
		String companyID = request.getParameter("companyID");
		String searchType = request.getParameter("searchType");
		String searchName = request.getParameter("searchName");
		
		//양식목록에 특수문자처리, 양식등록/수정 양식명1,2 둘다 넣어야 저장되는지 확인필요
		String result = ezApprovalGService.getFormInfo(id.trim(), kind, searchType, searchName, userInfo.getId(), userInfo.getDeptID(), companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("id : " + id + ", kind : " + kind + ", companyID : " + companyID);
		
		model.addAttribute("resultXML", result);
		
		logger.debug("getFormList ended.");
		
		return "json";
	}
	
	/**
	 * 전자결재G관리 양식등록 기안양식목록 정렬순서 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setFormOrder.do", produces="text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setFormOrder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("setFormOrder started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String formContID = request.getParameter("formContID");
		String boardIDList = request.getParameter("boardIDList");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.setFormOrder(formContID, boardIDList, companyID, userInfo.getTenantId());
		
		logger.debug("setFormOrder ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록 양식함추가 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formContMain.do", method = RequestMethod.GET)
	public String formContMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("formContMain started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String serverName = userInfo.getServerName();
		String tCheck = request.getParameter("tCheck");
		String primary = ezCommonService.getTenantConfig("LangPrimary"+userInfo.getLang(), userInfo.getTenantId());
		String secondary= ezCommonService.getTenantConfig("LangSecondary"+userInfo.getLang(), userInfo.getTenantId());
		String title = "", topID = "";
		String parentID = request.getParameter("parentID");
		String contID = request.getParameter("contID");
		String companyID = request.getParameter("companyID");
		String parentName = "";
		
		if (tCheck.equals("fContIns")) {
			title = egovMessageSource.getMessage("ezApprovalG.t1623", userInfo.getLocale());
		} else {
			title = egovMessageSource.getMessage("ezApprovalG.t1627", userInfo.getLocale()); 
		}
		
//		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
//			topID = userInfo.getCompanyID();
//		} else {
//			topID = "Top";
//		}
		if (companyID != null && !companyID.equals("")) {
			topID = companyID;
		} else {
			topID = userInfo.getCompanyID();
		}

		if (tCheck.equals("fContIns")) {
			if (contID != null) {
				if (!contID.equalsIgnoreCase("ROOT")) {
					/*기존 20190710 변경 김은석*/
//					parentName = ezApprovalGAdminService.getParentContName(contID, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLang());
					parentName = ezApprovalGAdminService.getParentContName(contID, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getPrimary());
				} else {//ezApprovalG.t1539
					parentName = egovMessageSource.getMessage("ezApprovalG.t1539", userInfo.getLocale());
				}
			}
		} else {
			if (parentID != null) {
				if (!parentID.equalsIgnoreCase("ROOT")) {
					/*기존 20190710 변경 김은석*/
//					parentName = ezApprovalGAdminService.getParentContName(parentID, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLang());
					parentName = ezApprovalGAdminService.getParentContName(parentID, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getPrimary());
				} else {//ezApprovalG.t1539
					parentName = egovMessageSource.getMessage("ezApprovalG.t1539", userInfo.getLocale());
				}
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("serverName", serverName);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("tCheck", tCheck);
		model.addAttribute("title", title);
		model.addAttribute("topID", topID);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("parentName", parentName);
		
		logger.debug("formContMain ended.");
		
		return "admin/ezApprovalG/apprGFormContMain";
	}
	
	/**
	 * 전자결재G관리 양식등록 양식함추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setFormContIns.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
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
	 * 전자결재G관리 양식등록 양식함수정 사용부서목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getGroupDept.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getGroupDept(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getGroupDept started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String contID = request.getParameter("fContID");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGAdminService.getGroupDept(contID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), companyID, userInfo.getTenantId());
		
		logger.debug("getGroupDept ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록 양식함수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setFormContMod.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
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
		
		if (contDept.equals("")) {
			contDept = "none";
		}

		String result = ezApprovalGAdminService.updateFormContainer(contName, contName2, contDescript, contParent, contDept, contID, deptList, companyID, userInfo.getTenantId());
		
		logger.debug("setFormContMod ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록 양식함삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/delFormCont.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
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
	 * 전자결재G관리 양식등록 양식등록,양식수정 화면호출함수(폼프로세서)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formMain.do", method = RequestMethod.GET)
	public String formMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("formMain started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		//관리자 권한 체크
		if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("k=1")) {
			return "cmm/error/adminDenied";
		}
		
		String formProcSpelling = ezCommonService.getTenantConfig("FormProcSpelling", userInfo.getTenantId()); 
		String primary = ezCommonService.getTenantConfig("LangPrimary"+userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary"+userInfo.getLang(), userInfo.getTenantId());
		String tCheck = request.getParameter("tCheck");
		String contID = request.getParameter("contID");
		String formID = request.getParameter("formID");
		String docType = ezApprovalGService.getDocType("", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale(), approvalFlag);
		String companyID = request.getParameter("companyID");
		
		String title = (tCheck.equals("fIns") ? egovMessageSource.getMessage("ezApprovalG.t1667", userInfo.getLocale()) : egovMessageSource.getMessage("ezApprovalG.t1668", userInfo.getLocale()));
		
		if (approvalFlag.equals("S")) {
			String listHeader = ezApprovalGService.getListHeader("S110", companyID, userInfo.getLang(), userInfo.getTenantId());
			String securityNode = ezApprovalGAdminService.getSecurityType("", userInfo, companyID, approvalFlag);
			String periodNode = ezApprovalGAdminService.getKeepType("", userInfo, companyID, approvalFlag);
			String aprRule = "";
			String aprRuleLine = "";
			String aprTypeXML = ezApprovalGService.getAprType(approvalFlag, companyID, userInfo.getLang(), userInfo.getTenantId());
			
			if (formID != null && !formID.equals("")) {
				aprRule = ezApprovalGAdminService.getFormAprRule(formID, companyID, userInfo.getTenantId());
				aprRuleLine = ezApprovalGAdminService.getFormAprRuleLine(formID, companyID, userInfo.getTenantId());
			}
			
			model.addAttribute("listHeader", listHeader);
			model.addAttribute("securityNode", securityNode);
			model.addAttribute("periodNode", periodNode);
			model.addAttribute("aprRule", aprRule);
			model.addAttribute("aprRuleLine", aprRuleLine);
			model.addAttribute("aprTypeXML", aprTypeXML);
		}
		
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
		model.addAttribute("approvalFlag", approvalFlag);
		
		logger.debug("formMain ended.");
		
		return "admin/ezApprovalG/apprGFormMain";
	}
	
	/**
	 * 전자결재관리 양식등록 양식추가,양식수정 화면호출함수 CK에디터
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formMainOther.do", method = RequestMethod.GET)
	public String formMainOther(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("formMainOther started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		//관리자 권한 체크
		if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("k=1")) {
			return "cmm/error/adminDenied";
		}
		// 2021-01-21 심기영 오피스결재 여부 추가
		String useOfficeApproval = ezCommonService.getTenantConfig("UseOfficeApproval", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String formProcSpelling = ezCommonService.getTenantConfig("FormProcSpelling", userInfo.getTenantId()); 
		String primary = ezCommonService.getTenantConfig("LangPrimary"+userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary"+userInfo.getLang(), userInfo.getTenantId());
		String useReceiveInfoName = ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId());
		String useReform = ezCommonService.getTenantConfig("useReform", userInfo.getTenantId());
		String tCheck = request.getParameter("tCheck");
		String contID = request.getParameter("contID");
		String formID = request.getParameter("formID");
		String type = request.getParameter("type");
		String docType = ezApprovalGService.getDocType("", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale(), approvalFlag);
		String companyID = request.getParameter("companyID");
		String reformflag = request.getParameter("reformflag");
		String openGovFlag = request.getParameter("openGovFlag");
		
		String usePassAprLine = ezCommonService.getTenantConfig("usePassAprLine", userInfo.getTenantId());
		String passAprLineFlag = request.getParameter("passAprLineFlag");
		String receptGubunYN = ezCommonService.getTenantConfig("receptGubunYN", userInfo.getTenantId());
		String useDraftAll = ezCommonService.getTenantConfig("useDraftAll", userInfo.getTenantId());
		String useMobileDraft = ezCommonService.getTenantConfig("useMobileDraft", userInfo.getTenantId());
		
		String title = (tCheck.equals("fIns") ? egovMessageSource.getMessage("ezApprovalG.t1667", userInfo.getLocale()) : egovMessageSource.getMessage("ezApprovalG.t1668", userInfo.getLocale()));
		
		if (approvalFlag.equals("S")) {
			String listHeader = ezApprovalGService.getListHeader("S110", companyID, userInfo.getLang(), userInfo.getTenantId());
			String securityNode = ezApprovalGAdminService.getSecurityType("", userInfo, companyID, approvalFlag);
			String periodNode = ezApprovalGAdminService.getKeepType("", userInfo, companyID, approvalFlag);
			String aprRule = "";
			String aprRuleLine = "";
			String aprTypeXML = ezApprovalGService.getAprType(approvalFlag, companyID, userInfo.getLang(), userInfo.getTenantId());
			
			if (formID != null && !formID.equals("")) {
				aprRule = ezApprovalGAdminService.getFormAprRule(formID, companyID, userInfo.getTenantId());
				aprRuleLine = ezApprovalGAdminService.getFormAprRuleLine(formID, companyID, userInfo.getTenantId());
			}
			
			model.addAttribute("listHeader", listHeader);
			model.addAttribute("securityNode", securityNode);
			model.addAttribute("periodNode", periodNode);
			model.addAttribute("aprRule", aprRule);
			model.addAttribute("aprRuleLine", aprRuleLine);
			model.addAttribute("aprTypeXML", aprTypeXML);
		}
		
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
		model.addAttribute("lang", userInfo.getLang());
		if (type != null && (type.equals("HWP") || type.equals("WebHWP"))) {
			model.addAttribute("useEditor", type);
			model.addAttribute("ext", "hwp");
			model.addAttribute("realPath", commonUtil.getRealPath(request).replace("\\","/"));
		} else {
			model.addAttribute("useEditor", useEditor);
		}
		
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("locale", userInfo.getLocale());
		model.addAttribute("useReceiveInfoName", useReceiveInfoName);
		model.addAttribute("receptGubunYN", receptGubunYN);
		
		if (config.getProperty("config.useOpenGov").equals("YES")) {
			model.addAttribute("useOpenGov", "YES");
			model.addAttribute("openGovFlag", openGovFlag);
		} else {
			model.addAttribute("openGovFlag", "N");
		}
		if (usePassAprLine.equals("YES")) {
			model.addAttribute("usePassAprLine", usePassAprLine);
			model.addAttribute("passAprLineFlag", passAprLineFlag);
		} else {
			model.addAttribute("usePassAprLine", "NO");
			model.addAttribute("passAprLineFlag", "N");
		}
		
		/* FormBuilder */
		boolean isReform = "y".equalsIgnoreCase(reformflag);
		
		// 폼빌더 사용 여부 (폼빌더 양식이어도 true, 한글 에디터라면 무조건 false)
		model.addAttribute("useReform", (!("HWP".equals(type) || "WebHWP".equals(type))) && (useReform.equalsIgnoreCase("yes") || isReform));
		// 폼빌더 양식 여부
		model.addAttribute("isReform", isReform);
		
		String reformUrl = "";
		
		if (isReform) {
			Path realPath = Paths.get(commonUtil.getRealPath(request));
			Path reformDirectory = Paths.get(commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()).substring(1), companyID, "form", "reform", formID);
			Path reformFunctionPath = realPath.resolve(reformDirectory.resolve(formID + "_FORMBuilder.js"));

			// 상대 경로로 해야함
			Path reformMhtPath = reformDirectory.resolve(formID + "_FORMBuilder.mht");
			
			if (Files.exists(reformFunctionPath)) {
				String reformFunctionStr = new String(commonUtil.readBytesFromFile(reformFunctionPath));
				
				model.addAttribute("reformFunction", reformFunctionStr);
			}
			
			if (Files.exists(realPath.resolve(reformMhtPath))) {
				reformUrl = commonUtil.separator + reformMhtPath.toString().replace("\\", "\\\\");
			}
		}
		
		model.addAttribute("reformUrl", reformUrl);
		/* FormBuilder end */
		
		// 2021-01-21 심기영 오피스결재 여부 추가
		model.addAttribute("useOfficeApproval", useOfficeApproval);
		
		/* 2022-01-07 홍승비 - 일괄기안 옵션 추가 */
		model.addAttribute("useDraftAll", useDraftAll);

		/* 2025-08-22 김유진 - 모바일기안 옵션 추가 */
		model.addAttribute("useMobileDraft", useMobileDraft);
		
		logger.debug("formMainOther ended.");
		
		return "admin/ezApprovalG/apprGFormMainOther";
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/reformDesignProcessor.do", method = RequestMethod.GET)
	public String reformDesignProcessor(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("reformDesignProcessor started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		int tenantId = userInfo.getTenantId();

		// 관리자 권한 체크
		if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("k=1")) {
			return "cmm/error/adminDenied";
		}

		// 현재 사용 중인 에디터
		String editor = ezCommonService.getTenantConfig("EDITOR", tenantId);
		
		String defaultFontFamily = egovMessageSource.getMessage("main.t246", userInfo.getLocale());
		String  defaultFontSize = "13px";
		
		// 사용자 언어가 한국어이고 editorFontStyle 값이 있을 경우 editorFontStyle 값 적용
		if (userInfo.getLang().equals("1")) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", tenantId);

			if (!editorFontStyle.isEmpty()) {
				String[] fontInfo = editorFontStyle.split("\\|");
				defaultFontFamily = fontInfo[0];
				defaultFontSize = fontInfo[1];
			}
		}
		
		model.addAttribute("editor", editor);
		model.addAttribute("userlang", userInfo.getLang());
		model.addAttribute("defaultFontFamily", defaultFontFamily);
		model.addAttribute("defaultFontSize", defaultFontSize);

		logger.debug("reformDesignProcessor ended.");

		return "admin/ezApprovalG/reform/reformDesignProcessor";
	}
	
	@RequestMapping(value = "admin/ezApprovalG/reformStyleDialog.do", method = RequestMethod.GET)
	public String reformStyleDialog() throws Exception {
		logger.debug("reformStyleDialog started.");
		logger.debug("reformStyleDialog ended.");

		return "admin/ezApprovalG/reform/reformStyleDialog";
	}
	
	@RequestMapping(value = "admin/ezApprovalG/reformDataBindControlDialog.do", method = RequestMethod.GET)
	public String reformDataBindControlDialog() throws Exception {
		logger.debug("reformDataBindControlDialog started.");
		logger.debug("reformDataBindControlDialog ended.");
		
		return "admin/ezApprovalG/reform/reformDataBindControlDialog";
	}
	
	@RequestMapping(value = "admin/ezApprovalG/reformSelectValueDialog.do", method = RequestMethod.GET)
	public String reformSelectValueDialog() throws Exception {
		logger.debug("reformSelectValueDialog started.");
		logger.debug("reformSelectValueDialog ended.");
		
		return "admin/ezApprovalG/reform/reformSelectValueDialog";
	}
	
	@RequestMapping(value = "admin/ezApprovalG/reformParamControlListDialog.do", method = RequestMethod.GET)
	public String reformParamControlListDialog() throws Exception {
		logger.debug("reformParamControlListDialog started.");
		logger.debug("reformParamControlListDialog ended.");
		
		return "admin/ezApprovalG/reform/reformParamControlListDialog";
	}
	
	@RequestMapping(value = "admin/ezApprovalG/reformDisplayColumnDialog.do", method = RequestMethod.GET)
	public String reformDisplayColumnDialog() throws Exception {
		logger.debug("reformDisplayColumnDialog started.");
		logger.debug("reformDisplayColumnDialog ended.");
		
		return "admin/ezApprovalG/reform/reformDisplayColumnDialog";
	}
	
		
	/**
	 * 전자결재G관리 양식등록 양식등록,양식수정 양식작성기 화면 호출함수 (한글기안)
	 */
	@RequestMapping(value="/admin/ezApprovalG/HWPEditor.do", method = RequestMethod.GET)
	public String HWPEditor() throws Exception {
		logger.debug("HWPEditor started.");
		
		logger.debug("HWPEditor ended.");
		
		return "admin/ezApprovalG/apprGHWPEditor";
	}
	
	/**
	 * 전자결재G 관리자 > 한글 웹 기안기 양식작성기 화면 호출
	 */
	@RequestMapping(value="/admin/ezApprovalG/WHWPEditor.do", method = RequestMethod.GET)
	public String WHWPEditor(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("WHWPEditor started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("webHWPUrl", ezCommonService.getTenantConfig("webHWPUrl", userInfo.getTenantId()));
		
		logger.debug("WHWPEditor ended.");
		return "admin/ezApprovalG/apprGWHWPEditor";
	}

	/**
	 * 전자결재G관리 양식등록 자동분류코드 메뉴 화면 호출함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGDocNumUI.do", method = RequestMethod.GET)
	public String apprGDocNumUI(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("apprGTaskCodeManage started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("k=1")) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("list", resultList);
		
		logger.debug("apprGTaskCodeManage ended.");
		
		return "admin/ezApprovalG/apprGDocNumUI";
	}
	
	/**
	 * 전자결재G관리 양식등록 양식등록,양식수정 양식기본정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getFormInfo.do", method = RequestMethod.POST)
	public String getFormInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getFormInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String formID = request.getParameter("formID");
		String companyID = request.getParameter("companyID");
		
		ApprGFormVO vo = ezApprovalGAdminService.getFormContent(formID, userInfo.getLang(), companyID, userInfo.getTenantId(), approvalFlag);
		
		model.addAttribute("vo", vo);
		
		logger.debug("getFormInfo ended.");
		
		return "json";
	}
	
	/**
	 * 전자결재G관리 양식등록 양식등록,양식수정 양식작성기 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formSave.do", produces="text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String formSave (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("formSave started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String companyID = request.getParameter("companyID");
		String contID = request.getParameter("formContID");
		String formID = request.getParameter("formID");
		String formInfo = request.getParameter("formInfo");
		String formMHT = request.getParameter("formMHT");
		String formConnInfo = request.getParameter("formConn");
		String formWorkFlow = request.getParameter("formWorkFlow");
		String formAutoRule = request.getParameter("formAutoRule");
		String formAutoRuleLine = request.getParameter("formAutoRuleLine");
		String formRecevGroup = request.getParameter("formRecevGroup");
		// FormBuilder
		String reformMht = request.getParameter("reformMht");
		String reformHtml = request.getParameter("reformHtml");
		String reformFunction = request.getParameter("reformFunction");
		
		logger.debug("formAutoRule = " + formAutoRule);
		logger.debug("formAutoRuleLine = " + formAutoRuleLine);
		String result = ezApprovalGAdminService.saveFormInfo(contID, formID, formInfo, formConnInfo, formWorkFlow, formRecevGroup, formMHT, formAutoRule, formAutoRuleLine, companyID, realPath, userInfo, approvalFlag, reformMht, reformHtml, reformFunction);
		
		logger.debug("formSave ended. result = " + result);
		
		
		return "<DATA>OK</DATA>";
	}
	
	/**
	 * 전자결재 관리자 페이지
	 * 전체 문서 조회(진행문서) -> 편집모드 ->수정 후 저장
	 * */
	@RequestMapping(value = "/admin/ezApprovalG/editApprDoc.do", produces="text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String editApprDoc (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("editApprDoc started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		//관리자 권한 체크		
		if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("k=1")) {
			return "cmm/error/adminDenied";
		}
		
		String docID = request.getParameter("docID");
		String companyID = request.getParameter("companyID");
		String formMHT = request.getParameter("formMHT");     
		String formHTML = request.getParameter("formHTML");   // 수정된 html
		String filePath = request.getParameter("filePath");   // 원본 html
		String htmlData = request.getParameter("htmlData");
		String realPath = commonUtil.getRealPath(request);
		
		ezApprovalGAdminService.editApprovalDoc(docID, companyID, formMHT, formHTML, realPath, userInfo, filePath, htmlData);
		
		logger.debug("editApprDoc ended.");
		return "";
	}
	
	/**
	 * 전자결재G관리 한글양식등록 양식등록,양식수정 양식작성기 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formSaveHWP.do", produces="text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String formSaveHWP (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("formSaveHWP started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String companyID = request.getParameter("companyID");
		String contID = request.getParameter("formContID");
		String formID = request.getParameter("formID");
		String formInfo = request.getParameter("formInfo");
		String formMHT = request.getParameter("formMHT");
		String formConnInfo = request.getParameter("formConn");
		String formWorkFlow = request.getParameter("formWorkFlow");
		String formAutoRule = request.getParameter("formAutoRule");
		String formAutoRuleLine = request.getParameter("formAutoRuleLine");
		String formRecevGroup = request.getParameter("formRecevGroup");
		
		logger.debug("formAutoRule = " + formAutoRule);
		logger.debug("formAutoRuleLine = " + formAutoRuleLine);
		
		String result = ezApprovalGAdminService.saveFormInfoHWP(contID, formID, formInfo, formConnInfo, formWorkFlow, formRecevGroup, formMHT, formAutoRule, formAutoRuleLine, companyID, realPath, userInfo, approvalFlag);
		
		logger.debug("formSaveHWP ended. result = " + result);
		
		return "<DATA>OK</DATA>";
	}
	
	/**
	 * 전자결재G관리 양식등록 양식작성기 속성조회함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getFormPropList.do", produces="text/xml;charset=utf-8", method = RequestMethod.POST)
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
	 * 전자결재G관리 양식등록 양식등록,양식수정 연동정보 추가 화면호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formConnInfo.do", method = RequestMethod.GET)
	public String formConnInfo (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("formConnInfo started");
		
		String companyID = request.getParameter("companyID");
				
		StringBuilder processIdx = new StringBuilder();
		StringBuilder processTime = new StringBuilder();
		StringBuilder connStringFlag = new StringBuilder();
		StringBuilder queryType = new StringBuilder();
		StringBuilder keyKind = new StringBuilder();
		
		List<ApprGFormConnInfoVO> list = ezApprovalGAdminService.getFormConnInfo();
		
		for (ApprGFormConnInfoVO vo : list) {
			switch (vo.getConnNode()) {
				case "PROCESSIDX":
					processIdx.append("<option value='" + vo.getDescription() + "'>" + vo.getConnInfo() + "</option>");
					break;

				case "PROCESSTIME":
					processTime.append("<option value='" + vo.getDescription() + "'>" + vo.getConnInfo() + "</option>");
					break;

				case "CONNSTRINGFLAG":
					connStringFlag.append("<option value='" + vo.getDescription() + "'>" + vo.getConnInfo() + "</option>");
					break;

				case "QUERYTYPE":
					queryType.append("<option value='" + vo.getDescription() + "'>" + vo.getConnInfo() + "</option>");
					break;

				case "KEYKIND":
					keyKind.append("<option value='" + vo.getDescription() + "'>" + vo.getConnInfo() + "</option>");
					break;

				default:
					break;
			}
		}
		
		model.addAttribute("processIdx", processIdx);
		model.addAttribute("processTime", processTime);
		model.addAttribute("connStringFlag", connStringFlag);
		model.addAttribute("queryType", queryType);
		model.addAttribute("keyKind", keyKind);
		model.addAttribute("companyID", companyID);
		
		logger.debug("formConnInfo ended");

		return "admin/ezApprovalG/apprGFormConnInfo";
	}
	
	/**
	 * 전자결재G관리 양식등록 양식등록,양식수정 양식별 고정수신처목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getFormRecvAdmin.do", produces="text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getFormRecvAdmin(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFormRecvAdmin started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String useReceiveInfoName = ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId());
		String formID = request.getParameter("formID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getFormRecvAdmin(formID, userInfo.getLang(), companyID, userInfo.getTenantId(), approvalFlag, useReceiveInfoName);
		
		logger.debug("getFormRecvAdmin ended. result = " + result);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록 양식삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/delForm.do", produces="text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String delForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("delForm started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String formID = request.getParameter("formID");
		String companyID = request.getParameter("companyID");
		String realPath = commonUtil.getRealPath(request);
		String officeFlag = request.getParameter("officeFlag");
		
		String result = ezApprovalGAdminService.delForm(formID, companyID, realPath, userInfo.getTenantId(),officeFlag);
		
		logger.debug("delForm ended");

		return result;
	}
	
	/**
	 * 전자결재G관리 양식등록 미리보기 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formPreview.do", method = RequestMethod.GET)
	public String formPreview(HttpServletRequest request, Model model) throws Exception {
		String docHref = request.getParameter("href");
		 
		model.addAttribute("docHref", docHref);
		
		return "admin/ezApprovalG/apprGFormPreview";
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/reformPreview.do", method = RequestMethod.GET)
	public String reformPreview() throws Exception {
		logger.debug("reformPreview started.");
		logger.debug("reformPreview ended.");
		
		return "admin/ezApprovalG/reform/reformPreview";
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/reformPreviewContent.do", method = RequestMethod.GET)
	public String reformPreviewContent(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("reformPreviewContent started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		
		model.addAttribute("editor", ezCommonService.getTenantConfig("EDITOR", tenantId));
		model.addAttribute("ie11editor", ezCommonService.getTenantConfig("IE11EDITOR", tenantId));
		model.addAttribute("lang",userInfo.getLang());
		
		logger.debug("reformPreviewContent ended.");
		
		return "admin/ezApprovalG/reform/reformPreviewContent";
	}
	
	/**
	 * 전자결재G관리 양식등록 양식이동화면 호출함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formSelect.do", method = RequestMethod.GET)
	public String formSelect(@CookieValue ("loginCookie") String loginCookie) throws Exception {
		logger.debug("formSelect started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("formSelect ended.");
		
		return "admin/ezApprovalG/apprGFormSelect";
	}
	
	/**
	 * 전자결재G관리 양식등록 양식이동 실행함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/formMove.do", method = RequestMethod.POST)
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
	 * 전자결재G관리 양식등록 ActiveX 다운로드 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/componentListTransfer.do", produces="text/xml;charset=utf-8" , method = RequestMethod.GET)
	@ResponseBody
	public String componentListTransfer(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("componentListTransfer started.");
		
		StringBuilder result = new StringBuilder();
		String realPath = commonUtil.getRealPath(request); 
		String path = "xml" + commonUtil.separator + "ezApprovalG" + commonUtil.separator + "componentlist_admin.xml";
		
		logger.debug("realPath : " + realPath);
		logger.debug("path : " + path);
		logger.debug("commonUtil.separator : " + commonUtil.separator);
		
		path = realPath + commonUtil.separator + path;
		
		logger.debug("path : " + path);
		
		try {
			File file = new File(commonUtil.detectPathTraversal(path));
			// CWE-404 보안 취약점 대응
			try (BufferedReader br = new BufferedReader(new FileReader(file))) {
				String line = null;
		
				while ((line = br.readLine()) != null) {
					result.append(line);
				}				
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("result : " + result.toString().replace("DOWNLOADSERVER", request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getRequestURI()))));
		logger.debug("componentListTransfer ended.");
		
		return result.toString().replace("DOWNLOADSERVER", request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getRequestURI())));
	}
	
	/**
	 * 전자결재G관리 양식등록 ActiveX 다운로드 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/progressAdmin.do", method = RequestMethod.GET)
	public String progressAdmin(Model model) {
		logger.debug("progressAdmin started.");

		String AdminActiveX = config.getProperty("config.AdminActiveX");
	    
		model.addAttribute("AdminActiveX", AdminActiveX);
	    	    
		logger.debug("progressAdmin ended.");

		return "/admin/ezApprovalG/apprGProgressAdmin";
	}
	
	/**
	 * 전자결재G관리 문서함관리 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMCont.do", method = RequestMethod.GET)
	public String apprMCont(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("apprGMCont started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		//관리자 권한 체크
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		String serverName = userInfo.getServerName();
		
		model.addAttribute("serverName", serverName);
		model.addAttribute("approvalFlag", approvalFlag);
		
		logger.debug("apprGMCont ended.");
		
		return "/admin/ezApprovalG/apprGMCont";
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함데이터 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMgetContInfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String apprMgetContInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("apprMgetContInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("comID");
		String lang = userInfo.getLang();

		String result = ezApprovalGAdminService.getContainerInfoManage(deptID, "LIST", companyID, lang, userInfo.getTenantId());
		
		logger.debug("apprMgetContInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함명관리 팝업 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMContType.do", method = RequestMethod.GET)
	public String apprMContType(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("apprMContType started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String primary = ezCommonService.getTenantConfig("LangPrimary"+userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary"+userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		logger.debug("apprMContType ended.");

		return "admin/ezApprovalG/apprGMContType";
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함명관리 팝업 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMLgetDoctype.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String apprGMLgetDoctype(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("apprGMLgetDoctype started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("comID");
		String primary = userInfo.getPrimary();
		String lang = userInfo.getLang();
		
		String result = ezApprovalGAdminService.getContTypeInfo("LIST", companyID, primary, userInfo.getTenantId(), lang);
		
		logger.debug("apprGMLgetDoctype ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함타입 등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGInsertContType.do", method = RequestMethod.POST)	
	@ResponseBody
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
	@RequestMapping(value = "/admin/ezApprovalG/apprGDeleteContType.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/admin/ezApprovalG/apprGMinsContType.do", method = RequestMethod.GET)
	public String apprGMinsContType(HttpServletRequest request, HttpServletResponse response) throws Exception {		
		return "admin/ezApprovalG/apprGMinsContType";
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서상태등록 등록된 문서함상태 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGGetContDocType.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String apprGGetContDocType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("apprGGetContDocType started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String companyID = request.getParameter("comID");
		String primary = userInfo.getPrimary();
		String lang = userInfo.getLang();
		
		String result = ezApprovalGAdminService.getContainerToDocStateInfo(companyID, primary, userInfo.getTenantId(), approvalFlag, lang);
		
		logger.debug("apprGGetContDocType ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서상태등록 문서함상태 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGUpdateContDoctype.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String apprUpdateContDoctype(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("apprGUpdateContDoctype started. data = " + data);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);		
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();
		
		String result = ezApprovalGAdminService.updateContainerToDocStateInfo(doc, companyID, userInfo.getTenantId());
		
		logger.debug("apprGUpdateContDoctype ended. result = " + result);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함 추가/수정 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMinsContMain.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/admin/ezApprovalG/apprGMgetContGroup.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String apprGMgetContGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("apprGMgetContGroup started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String contID = request.getParameter("contID");
		String companyID = request.getParameter("comID");
		String primary = userInfo.getLang();
		
		String result = ezApprovalGAdminService.getContainerUseDeptInfo(contID, companyID, primary, userInfo.getTenantId());
		
		logger.debug("apprGMgetContGroup ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함 추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMinsCont.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String apprGMinsCont(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("apprGMinsCont started. data = " + data);
		
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
	@RequestMapping(value = "/admin/ezApprovalG/apprGMupdateCont.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/admin/ezApprovalG/apprGMdelCont.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
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
	
	/* 2024-04-19 홍승비 - 특수문서함 관련 기능 > 호출되지 않는 URL로 확인, 관련 메서드와 쿼리 전체 주석처리 */
	/**
	 * 전자결재관리 문서함관리 특수문서함 호출
	 */
	/*@RequestMapping(value = "/admin/ezApprovalG/manageSpecialCont.do", method = RequestMethod.GET)
	public String manageSpecialCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("manageSpecialCont started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("companyID");
		String deptName = request.getParameter("deptName");
		
		model.addAttribute("deptID", deptID);
		model.addAttribute("companyID", companyID);
		model.addAttribute("deptName", deptName);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("manageSpecialCont ended");
		
		return "admin/ezApprovalG/apprGManageSpecialCont";
	}*/
	/**
	 * 전자결재관리 문서함관리 특수문서함 목록 호출
	 */
	/*@RequestMapping(value = "/admin/ezApprovalG/specialContListInfo.do", method = RequestMethod.POST)
	public String specialContListInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("specialContListInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("companyID");
		String resultXML = ezApprovalGAdminService.getSpecialContList(deptID, companyID, userInfo.getLang(), userInfo.getTenantId(), approvalFlag);
		
		model.addAttribute("resultXML", resultXML);
		
		logger.debug("specialContListInfo ended. resultXML = " + resultXML);
	
		return "json";
	}*/
	/**
	 * 전자결재관리 문서함관리 특수문서함 추가,수정화면 호출
	 */
	/*@RequestMapping(value = "/admin/ezApprovalG/manageSpecialContInfo.do", method = RequestMethod.GET)
	public String manageSpecialContInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("manageSpecialContInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String contType = request.getParameter("contType");
		String sn = request.getParameter("sn");
		String companyID = request.getParameter("companyID");
		
		String codeXML = ezApprovalGAdminService.getSpecialContCode(contType, companyID, userInfo.getPrimary(), userInfo.getTenantId());
		String infoXML = ezApprovalGAdminService.getSpecialContInfo(deptID, contType, sn, companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("codeXML = " + codeXML);
		logger.debug("infoXML = " + infoXML);
		
		model.addAttribute("deptID", deptID);
		model.addAttribute("contType", contType);
		model.addAttribute("sn", sn);
		model.addAttribute("companyID", companyID);
		model.addAttribute("codeXML", codeXML);
		model.addAttribute("infoXML", infoXML);
		
		logger.debug("manageSpecialContInfo ended.");
		
		return "admin/ezApprovalG/apprGManageSpecialContInfo";
	}*/
	/**
	 * 전자결재관리 문서함관리 특수문서함 추가/수정 실행함수
	 */
	/*@RequestMapping(value = "/admin/ezApprovalG/specialContAdd.do", method = RequestMethod.POST)
	public String specialContAdd(@CookieValue("loginCookie") String loginCookie, ApprGContInfoVO apprGContInfoVO, Model model) throws Exception {
		logger.debug("specialContAdd started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalGAdminService.addSpecialCont(apprGContInfoVO, userInfo.getTenantId());
		
		model.addAttribute("result", result);
		
		logger.debug("specialContAdd ended. result = " + result);
		
		return "json";
	}*/
	/**
	 * 전자결재관리 문서함관리 특수문서함 삭제 실행함수
	 */
	/*@RequestMapping(value = "/admin/ezApprovalG/specialContDelete.do", method = RequestMethod.POST)
	public String specialContDelete(@CookieValue("loginCookie") String loginCookie, ApprGContInfoVO vo, Model model) throws Exception {
		logger.debug("specialContDelete started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalGAdminService.delSpecialCont(vo, userInfo.getTenantId());
		
		model.addAttribute("result", result);
		
		logger.debug("specialContDelete ended");
		
		return "json";
	}*/
	/**
	 * 전자결재관리 문서함관리 특수문서함 순서변경 실행함수
	 */
	/*@RequestMapping(value = "/admin/ezApprovalG/specialContChangeSN.do", method = RequestMethod.POST)
	public String specialContChangeSN(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("specialContChangeSN started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String sContType = request.getParameter("contType");
		String sSn = request.getParameter("sn");
		String tContType = request.getParameter("contType2");
		String tSn = request.getParameter("sn2");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGAdminService.changeSpecialContSN(deptID, sContType, sSn, tContType, tSn, companyID, userInfo.getTenantId());
		
		model.addAttribute("result", result);
		
		logger.debug("specialContChangeSN ended");
		
		return "json";
	}*/
	/**
	 * 전자결재G관리 수신처 그룹지정 메뉴 호출함수
	 * 전자결재관리 수신처 그룹지정 메뉴 호출함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGReceiveGroup.do", method = RequestMethod.GET)	
	public String apprGReceiveGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("apprGReceiveGroup started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String useReceiveInfoName = ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId());
		String serverName = userInfo.getServerName();
		String topID = "";
		
		//관리자 권한 체크
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topID = userInfo.getCompanyID();
		} else {
			topID = "Top";
		}
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(j, vo);
			}
		}
		
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("serverName", serverName);
		model.addAttribute("topID", topID);
		model.addAttribute("list", resultList);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("useReceiveInfoName", useReceiveInfoName);
		model.addAttribute("userLang", userInfo.getLang());
		
		logger.debug("apprGReceiveGroup ended.");
		
		return "admin/ezApprovalG/apprGReceiveGroup";
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 등록된 그룹데이터 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getAdminReceivGroup.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getAdminReceivGroup(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getAdminReceivGroup started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(data);
		
		String pid = doc.getDocumentElement().getChildNodes().item(0).getTextContent();
		String pmode = doc.getDocumentElement().getChildNodes().item(1).getTextContent();
		String pcompanyID = userInfo.getCompanyID();
				
		if (doc.getDocumentElement().getChildNodes().getLength() > 2) {
			pcompanyID = doc.getDocumentElement().getChildNodes().item(2).getTextContent();
		}
		
		//2018-09-06 김보미 - primary에서 lang으로 변경
		//String result = ezApprovalGAdminService.getReceiveGroupInfo(pid, pmode, pcompanyID, userInfo.getPrimary(), userInfo.getTenantId(), userInfo.getOffset(), approvalFlag);
		String result = ezApprovalGAdminService.getReceiveGroupInfo(pid, pmode, pcompanyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), approvalFlag);
		
		logger.debug("getAdminReceivGroup ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 부서등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setGroupSubItemInfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setGroupSubItemInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("setGroupSubItemInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String groupID = request.getParameter("node1");
		String deptID = request.getParameter("node2");
		String deptName = request.getParameter("node3");
		String companyID = request.getParameter("node4");
//		부서의회사아이디가 아닌 상위셀렉트박스의 회사아이디를 사용
//		String pCompanyID = request.getParameter("node5");
		String deptName2 = request.getParameter("node6");
		String extReceptYn = StringUtils.defaultString(request.getParameter("node7"), "N");
		
		String result = ezApprovalGAdminService.insertReceiveGroupItemInfo(groupID, deptID, deptName, deptName2, companyID, companyID, userInfo.getTenantId(), extReceptYn);
		
		logger.debug("setGroupSubItemInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 부서명변경
	 */
	@RequestMapping(value = "/admin/ezApprovalG/updateGroupSubItemInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateGroupSubItemInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("updateGroupSubItemInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String groupID = request.getParameter("node1");
		String deptID = request.getParameter("node2");
		String deptName = request.getParameter("node3");
		String companyID = request.getParameter("node4");
		String deptName2 = request.getParameter("node6");
		
		String result = ezApprovalGAdminService.updateReceiveGroupItemInfo(groupID, deptID, deptName, deptName2, companyID, companyID, userInfo.getTenantId());
		
		logger.debug("updateGroupSubItemInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 부서삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deleteGroupSubiteminfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/admin/ezApprovalG/updateGroupMainInfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/admin/ezApprovalG/setGroupMainInfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/admin/ezApprovalG/deleteGroupMainInfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
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
	 * 전자결재 분류,단위업무관리 메뉴 호출함수
	 * 전자결재 분류코드관리 메뉴 호출함수 
	 */
	//일반 docNumUI.do
	@RequestMapping(value = "/admin/ezApprovalG/apprGTaskCodeManage.do", method = RequestMethod.GET)
	public String apprGTaskCodeManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("apprGTaskCodeManage started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("list", resultList);
		
		logger.debug("apprGTaskCodeManage ended.");
		
		return "admin/ezApprovalG/apprGTaskCodeManage";
	}
	
	/**
	 * 전자결재 관리 분류,단위업무관리 분류목록 호출함수
	 * 전자결재 관리 분류코드관리 체계목록 호출함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCategoryTree.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskCategoryTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getTaskCategoryTree started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String categoryType = request.getParameter("categoryType");
		String parentID = request.getParameter("parentID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCategoryTree(categoryType, parentID, companyID, userInfo.getTenantId(), approvalFlag, userInfo);
		
		logger.debug("getTaskCategoryTree ended.");
		
		return result;
	}
	
	/**
	 * 전자결재 관리 분류,단위업무관리 분류목록에따른 단위업무 목록 호출함수
	 * 전자결재 관리 분류코드관리 체계목록에 따른 분류코드 목록 호출함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskInSubCategoryForManage.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskInSubCategoryForManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getTaskInSubCategoryForManage started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		String sCateCode = request.getParameter("sCateCode");
		String companyID = request.getParameter("companyID");
		String userFlag = request.getParameter("userFlag");
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		//사용자에서 부를때 컴패니 추가
		if (companyID == null || companyID.equals("")) {
			companyID = userInfo.getCompanyID();
		}
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			companyID = orgCompanyID;
		}
		
		String result = ezApprovalGAdminService.getTaskInSubCategoryForManage(sCateCode, userInfo.getLang(), companyID, userInfo.getTenantId(), approvalFlag, userFlag);
		
		logger.debug("getTaskInSubCategoryForManage ended.");
		
		return result;
	}
	
	/**
	 * 전자결재 분류,단위업무관리 분류추가,분류수정 메뉴 호출함수
	 * 전자결재 분류코드관리 체계추가, 체계수정 메뉴 호출함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskCategoryInsert.do", method = RequestMethod.GET)
	public String taskCategoryInsert(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskCategoryInsert started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String tCheck = request.getParameter("tCheck");
		String title = "";
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		if (tCheck == null) {
		    logger.debug("--> tCheck is null");
		    return "";
		}
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		if (approvalFlag.equals("S")) {
			if (tCheck.equals("ins")) {
				title = egovMessageSource.getMessage("ezApproval.t765", userInfo.getLocale());
			} else {
				title = egovMessageSource.getMessage("ezApproval.t766", userInfo.getLocale());
			}
		} else {
			if (tCheck.equals("ins")) {
				title = egovMessageSource.getMessage("ezApprovalG.t734", userInfo.getLocale());
			} else {
				title = egovMessageSource.getMessage("ezApprovalG.t735", userInfo.getLocale());
			}
		}
		
		model.addAttribute("title", title);
		model.addAttribute("tCheck", tCheck);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		logger.debug("taskCategoryInsert ended.");
		
		return "admin/ezApprovalG/apprGTaskCategoryInsert";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류추가  중복확인 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCategoryDuplicate.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskCategoryDuplicate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getTaskCategoryDuplicate started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String categoryType = request.getParameter("cateType");
		String categoryCode = request.getParameter("sCateCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCategoryDuplicate(categoryType, categoryCode, companyID, userInfo.getTenantId());
		
		logger.debug("getTaskCategoryDuplicate ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류추가 분류선택 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/selectTaskCategory.do", method = RequestMethod.GET)
	public String selectTaskCategory() {
		return "admin/ezApprovalG/apprGSelectTaskCategory";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류추가,분류수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setTaskCategory.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setTaskCategory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("setTaskCategory started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String categoryType = request.getParameter("categoryType");
		String categoryCode = request.getParameter("categoryCode");
		String categoryName = request.getParameter("categoryName");
		String categoryName2 = request.getParameter("categoryName2");
		String categoryDesc = request.getParameter("categoryDesc");
		String pCode = request.getParameter("pCode");
		String companyID = request.getParameter("companyID");
		SecureRandom secRandom = new SecureRandom();
		
		if (approvalFlag.equals("S") && categoryCode.equals("")) {
			String tempCategoryCode1 = Character.toString((char)(secRandom.nextInt(26) + 65)) + Character.toString((char)(secRandom.nextInt(26) + 65));
			String tempCategoryCode2 = Integer.toString(secRandom.nextInt(1000000));
			logger.debug("tempCategoryCode1 = " + tempCategoryCode1);
			logger.debug("tempCategoryCode2 = " + tempCategoryCode2);
			categoryCode = tempCategoryCode1 + tempCategoryCode2;
		}
		
		String result = ezApprovalGAdminService.setTaskCategory(categoryType, categoryCode, categoryName, categoryName2, categoryDesc, pCode, companyID, userInfo.getTenantId(), approvalFlag);
		
		logger.debug("setTaskCategory ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류삭제 시 하위노드 여부 체크 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCategoryNodeExist.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskCategoryNodeExist(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getTaskCategoryNodeExist started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String categoryType = request.getParameter("cateType");
		String categoryCode = request.getParameter("sCateCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCategoryNodeExist(categoryType, categoryCode, companyID, userInfo.getTenantId(), approvalFlag);
		
		logger.debug("getTaskCategoryNodeExist ended.");
		
		return result;
	}

	/**
	 * 전자결재G관리 분류,단위업무관리 분류삭제 실행함수
	 * 전자결재관리 분류코드관리 체계삭제 실행함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/removeTaskCategory.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String removeTaskCategory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("removeTaskCategory started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String categoryType = request.getParameter("cateType");
		String categoryCode = request.getParameter("cateCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.removeTaskCategory(categoryType, categoryCode, companyID, userInfo.getTenantId(), approvalFlag);
		
		logger.debug("removeTaskCategory ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드추가,수정 화면 호출 함수
	 * 전자결재관리 분류코드관리 분류추가,수정 화면호출함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskCodeInsert.do", method = RequestMethod.GET)
	public String taskCodeInsert(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskCodeInsert started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String tCheck = request.getParameter("tCheck");
		String companyID = request.getParameter("companyID");
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		if (tCheck == null) {
		    logger.debug("--> tCheck is null");
		    return "";
		}
		
		String title = "";
		
		if (approvalFlag.equals("S")) {
			if (tCheck.equals("ins")) {
				title = egovMessageSource.getMessage("ezApprovalG.t1642", userInfo.getLocale());
			} else {
				title = egovMessageSource.getMessage("ezApprovalG.t1643", userInfo.getLocale());
			}
			
			String securityNode = ezApprovalGAdminService.getSecurityType("", userInfo, companyID, approvalFlag);
			String periodNode = ezApprovalGAdminService.getKeepType("", userInfo, companyID, approvalFlag);
			
			model.addAttribute("securityNode", securityNode);
			model.addAttribute("periodNode", periodNode);
		} else {
			if (tCheck.equals("ins")) {
				title = egovMessageSource.getMessage("ezApprovalG.t763", userInfo.getLocale());
			} else {
				title = egovMessageSource.getMessage("ezApprovalG.t764", userInfo.getLocale());
			}
		}
		
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("title", title);
		model.addAttribute("tCheck", tCheck);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		logger.debug("taskCodeInsert ended.");
		
		return "admin/ezApprovalG/apprGTaskCodeInsert";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드추가 단위업무코드 중복확인 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCodeDuplicate.do", produces = "text/html; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskCodeDuplicate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getTaskCodeDuplicate started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String taskCode = request.getParameter("sCateCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCodeDuplicate(taskCode, companyID, userInfo.getTenantId());

		logger.debug("getTaskCodeDuplicate ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드수정 단위업무정보 호출함수
	 * 전자결재관리 분류코드관리 분류수정 분류코드정보 호출함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskInfo.do", produces = "text/html; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getTaskInfo started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String pTaskCode = request.getParameter("taskCode");
		String pDeptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskInfo(pTaskCode, pDeptCode, companyID, userInfo.getTenantId());

		logger.debug("getTaskInfo ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드추가,수정 실행함수
	 * 전자결재관리 분류코드관리 분류추가,삭제 실행함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setTaskCode.do", method = RequestMethod.POST)
	@ResponseBody
	public String setTaskCode (@CookieValue("loginCookie") String loginCookie, ApprGTaskVO vo, HttpServletRequest request) throws Exception {
		logger.debug("setTaskCode started.");
		logger.debug("vo.level = " + vo.getLevel());
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String categoryName = request.getParameter("categoryName");
		String categoryName2 = request.getParameter("categoryName2");
		String categoryDesc = request.getParameter("categoryDesc");
		
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.setTaskCode(vo, categoryName, categoryName2, categoryDesc, companyID, userInfo, approvalFlag);
		
		logger.debug("setTaskCode ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 단위업무의 소속 기록물철 여부 체크 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCodeNodeExist.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskCodeNodeExist(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getTaskCodeNodeExist started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String taskCode = request.getParameter("taskCode");
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("companyID");
		String result = "";
		
		if (approvalFlag.equals("S")) {
			result = "FALSE";
		} else {
			result = ezApprovalGAdminService.getTaskCodeNodeExist(taskCode, deptID, companyID, userInfo.getTenantId());
		}
		
		logger.debug("getTaskCodeNodeExist ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리분류,단위업무관리  코드삭제 실행 함수
	 * 전자결재관리 분류코드관리 분류삭제 실행함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/removeTaskCode.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String removeTaskCode(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("removeTaskCode started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String taskCode = request.getParameter("taskCode");
		String companyID = request.getParameter("companyID");
		
		logger.debug("taskCode = " + taskCode + ", companyID = " + companyID);
		
		String result = ezApprovalGAdminService.removeTaskCode(taskCode, companyID, userInfo, approvalFlag);
		
		logger.debug("removeTaskCode ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 사용부서 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskDeptInfoManage.do", method = RequestMethod.GET)
	public String taskDeptInfoManage(@CookieValue("loginCookie") String loginCookie, Model model) {
		logger.debug("taskDeptInfoManage started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String serverName = userInfo.getServerName();
		
		model.addAttribute("serverName", serverName);
		
		logger.debug("taskDeptInfoManage ended.");

		return "admin/ezApprovalG/apprGTaskDeptInfoManage";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 사용부서 부서에 포함된 단위업무목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCodeDeptInfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskCodeDeptInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getTaskCodeDeptInfo started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String taskCode = request.getParameter("taskCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCodeDeptInfo(taskCode, companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("getTaskCodeDeptInfo ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 사용부서 부서추가 실행함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/addTaskCodeDeptInfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/admin/ezApprovalG/removeTaskCodeDeptInfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String removeTaskCodeDeptInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("removeTaskCodeDeptInfo started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String taskCode = request.getParameter("taskCode");
		String deptCode = request.getParameter("deptID");
		String deptName = request.getParameter("deptName");
		String deptName2 = request.getParameter("deptName2");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.removeTaskCodeDeptInfo(taskCode, deptCode, deptName, deptName2, companyID, userInfo);
		
		logger.debug("removeTaskCodeDeptInfo ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드정보 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/viewTaskInfo.do", method = RequestMethod.GET)
	public String viewTaskInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("viewTaskInfo started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("viewTaskInfo ended.");

		return "admin/ezApprovalG/apprGViewTaskInfo";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드이력 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskHistoryInfo.do", method = RequestMethod.GET)
	public String taskHistoryInfo() {
		return "admin/ezApprovalG/apprGTaskHistoryInfo";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드이력 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskHistory.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskHistory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getTaskHistory started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String taskCode = request.getParameter("docID");
		String companyID = request.getParameter("companyID");

		String result = ezApprovalGAdminService.getTaskHistory(taskCode, companyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getTaskHistory ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 부서별 단위업무 조회 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskAdminDept.do", method = RequestMethod.GET)
	public String taskAdminDept(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("taskAdminDept started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String serverName = userInfo.getServerName();
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		int taskCount = ezApprovalGAdminService.getTaskListCount(userInfo.getCompanyID(), userInfo.getCompanyID(), userInfo.getTenantId(), null, null, "0");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("serverName", serverName);
		model.addAttribute("list", resultList);
		model.addAttribute("taskCount", taskCount);
		
		logger.debug("taskAdminDept ended.");

		return "admin/ezApprovalG/apprGTaskAdminDept";
	}
	
	/**
	 * 전자결재G관리 부서별 단위업무 목록 호출 함수(분류기준표 정보를 가져온다.)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskFullList.do", produces = "text/html;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getTaskFullList (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getTaskFullList started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String deptCode = request.getParameter("deptCode");
		String pageSize = request.getParameter("pageSize");
		String pageNo = request.getParameter("pageNo");
		String langType = request.getParameter("langType");
		String companyID = request.getParameter("companyID");
		String title = request.getParameter("title");
		String code = request.getParameter("code");
		String flag = request.getParameter("flag");
		String orderOption1 = request.getParameter("orderOption1");
		String orderOption2 = request.getParameter("orderOption2");
		
		String listXML = ezApprovalGAdminService.getTaskFullList(deptCode, pageSize, pageNo, langType.trim(), companyID, userInfo.getTenantId(), title, code, flag, orderOption1, orderOption2);
		
		Document xmldoc = commonUtil.convertStringToDocument(listXML);
	
		if (xmldoc.getElementsByTagName("ROW") != null) {
			for (int i = 0; i < xmldoc.getElementsByTagName("ROW").getLength(); i ++) {
				if (!xmldoc.getElementsByTagName("ROW").item(i).getChildNodes().item(11).getChildNodes().item(0).getTextContent().trim().equals("")) {
					xmldoc.getElementsByTagName("ROW").item(i).getChildNodes().item(11).getChildNodes().item(0).setTextContent(egovMessageSource.getMessage("ezApprovalG." + xmldoc.getElementsByTagName("ROW").item(i).getChildNodes().item(11).getChildNodes().item(0).getTextContent().trim(), userInfo.getLocale()));
				}
			}
		}
		
		logger.debug("getTaskFullList ended.");

		return commonUtil.convertDocumentToString(xmldoc);
	}
	
	/**
	 * 전자결재G관리 관인대장 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/manageSeal.do", method = RequestMethod.GET)
	public String manageSeal (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("manageSeal started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		
		logger.debug("manageSeal ended.");

		return "admin/ezApprovalG/apprGManageSeal";
	}
	
	/**
	 * 전자결재G관리 관인대장 회사별 관인목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getSealList.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getSealList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getSealList started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String listFlag = request.getParameter("listFlag");
		String companyID = userInfo.getCompanyID();
		
		if (request.getParameter("companyID") != null) {
			companyID = request.getParameter("companyID");
		}
		
		//'pListFlag : "LIST" - 리스트 가져오기, "ADMIN" - 대장 가져오기(관리자)
		String result = ezApprovalGAdminService.getSealList(commonUtil.getRealPath(request), listFlag, companyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getSealList ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 관인대장 관인정보보기 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/sealInfo.do", method = RequestMethod.GET)
	public String ezSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("ezSealInfo started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		boolean checkIE = commonUtil.checkIE(request);
		String pDeptYN = request.getParameter("pDeptYN");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("checkIE", checkIE);
		model.addAttribute("pDeptYN", pDeptYN);
		
		logger.debug("ezSealInfo ended.");

		return "admin/ezApprovalG/apprGSealInfo";
	}
	
	/**
	 * 전자결재G관리 관인대장 관인등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/addSealInfo.do", method = RequestMethod.GET)
	public String addSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("addSealInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		boolean checkIE = commonUtil.checkIE(request);
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("checkIE", checkIE);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		logger.debug("addSealInfo ended.");
		
		return "admin/ezApprovalG/apprGAddSealInfo";
	}
	
	/**
	 * 전자결재G관리 관인대장 관인등록 파일등록 실행 함수 최신
	 */
	@RequestMapping(value = "/admin/ezApprovalG/sealImageUpload.do", method = RequestMethod.POST)
	public String sealImageUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		logger.debug("sealImageUpload started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		MultipartFile multiFile = request.getFile("file1");
		String companyID = request.getParameter("companyID") != null ? request.getParameter("companyID") : "";
		String deptID = request.getParameter("deptID");
		String realPath = commonUtil.getRealPath(request);
		String dirPath = commonUtil.getUploadPath("upload_approvalG.SEALIMG", userInfo.getTenantId());
		String currentDate = commonUtil.getTodayUTCTime("yyyyMMddHHmmss");
		String fileExt = multiFile.getOriginalFilename().substring(multiFile.getOriginalFilename().lastIndexOf("."));
		
		/* 2021-12-08 홍승비 - 전자결재 관인대장, 부서직인대장 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		logger.debug("sealImageUpload file extension is : " + fileExt.substring(1));
		if (commonUtil.checkImgExtension(fileExt.substring(1)) == false || (!useExtension.equals("*") && useExtension.toLowerCase().indexOf(fileExt.substring(1).toLowerCase()) < 0)) {
			logger.debug("sealImageUpload failed, checkImgExtension return false");
			
			model.addAttribute("msg", "UPLOAD_EXT_ERROR");
			return "json";
		}
		
		File dir = new File(commonUtil.detectPathTraversal(realPath + dirPath));
		
        if (!dir.exists()) {
        	dir.mkdirs();
        }
        
		String fileName = "";
		
		if (deptID == null) {
			fileName = companyID + "_" + currentDate + fileExt;
		} else {
			fileName = companyID + "_" + deptID + "_" + currentDate + fileExt;
		}
		
		writeUploadedFile(multiFile, fileName, realPath + dirPath);
		
		model.addAttribute("fileName", fileName);
		model.addAttribute("path", dirPath + commonUtil.separator);
		model.addAttribute("msg", "OK");
		
		logger.debug("sealImageUpload ended.");
		
		return "json";
	}
	
	/**
	 * 전자결재G관리 관인대장 관인등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/insertSealInfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String insertSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("insertSealInfo started.");

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
		
		logger.debug("insertSealInfo ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 관인대장 관인등록  임시파일삭제 실행 함수 (등록하지 않고 종료시 파일 삭제)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/sealDelete.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String sealDelete(HttpServletRequest request) throws Exception {
		logger.debug("sealDelete started.");

		String realPath = commonUtil.getRealPath(request);
		String dirPath = request.getParameter("dirPath");
		String fileName = request.getParameter("fileName");
		
		String result = ezApprovalGAdminService.sealDelete(realPath, dirPath, fileName);
		
		logger.debug("sealDelete ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 관인대장 관인삭제 실행 함수(삭제일자만 추가, 파일삭제X)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deleteSealInfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String deleteSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("deleteSealInfo started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String pSealNum = request.getParameter("pSealNum");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.deleteSealInfo(pSealNum, companyID, userInfo.getTenantId());
		
		logger.debug("deleteSealInfo ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/manageDeptSeal.do", method = RequestMethod.GET)
	public String manageDeptSeal(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("manageDeptSeal started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String serverName = userInfo.getServerName();
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("serverName", serverName);
		model.addAttribute("list", resultList);
		
		logger.debug("manageDeptSeal ended.");

		return "admin/ezApprovalG/apprGManageDeptSeal";
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 부서에따른 직인목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getDeptSealList.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getDeptSealList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getDeptSealList started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String listFlag = request.getParameter("listFlag");
		String deptID = request.getParameter("deptID");
		String companyID = userInfo.getCompanyID();
		
		if (request.getParameter("companyID") != null) {
			companyID = request.getParameter("companyID");
		}
		
		//'pListFlag : "LIST" - 리스트 가져오기, "ADMIN" - 대장 가져오기(관리자)
		String result = ezApprovalGAdminService.getSealDeptList(commonUtil.getRealPath(request),listFlag, deptID, companyID, userInfo.getPrimary(), userInfo.getOffset(), userInfo.getTenantId());
		
		logger.debug("getDeptSealList ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 직인등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/addDeptSealInfo.do", method = RequestMethod.GET)
	public String addDeptSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("addDeptSealInfo started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		boolean checkIE = commonUtil.checkIE(request);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("checkIE", checkIE);
		
		logger.debug("addDeptSealInfo ended.");

		return "admin/ezApprovalG/apprGAddDeptSealInfo";
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 직인등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/insertDeptSealInfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String insertDeptSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("insertDeptSealInfo started.");

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
		
		logger.debug("insertDeptSealInfo ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 직인등록 삭제 실행 함수 (등록하지 않고 종료시 파일 삭제)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deptSealDelete.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String deptSealDelete(HttpServletRequest request) throws Exception {
		logger.debug("deptSealDelete started.");

		String realPath = commonUtil.getRealPath(request);
		String dirPath = request.getParameter("dirPath");
		String fileName = request.getParameter("fileName");
		
		String result = ezApprovalGAdminService.sealDelete(realPath, dirPath, fileName);
		
		logger.debug("deptSealDelete ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 부서별관인대장 직인삭제 실행 함수(삭제일자만 추가 파일삭제X) 
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deleteDeptSealInfo.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String deleteDeptSealInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("deleteDeptSealInfo started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String pSealNum = request.getParameter("pSealNum");
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.deleteDeptSealInfo(pSealNum, deptID, companyID, userInfo.getTenantId());
		
		logger.debug("deleteDeptSealInfo ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 문서유통암호화설정 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/manageSendInfo.do", method = RequestMethod.GET)
	public String manageSendInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("manageSendInfo started.");

		LoginVO userInfo  = commonUtil.aprUserInfo(loginCookie);
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		String encodeInfoPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		model.addAttribute("encodeInfoPath", encodeInfoPath);
		
		logger.debug("manageSendInfo ended.");

		return "/admin/ezApprovalG/apprGManageSendInfo";
	}
	
	/**
	 * 전자결재G관리 문서유통암호화설정 설정파일 조회함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getOptionInfo.do", method = RequestMethod.POST)
	public String getOptionInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getOptionInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		String realPath = commonUtil.getRealPath(request);
		String companyPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + companyID;
		String encodeInfo = "";
		
		File fileDir = new File(commonUtil.detectPathTraversal(realPath + companyPath));
		
		if (!fileDir.exists()) {
			fileDir.mkdirs();
		}
		
		File file = new File(commonUtil.detectPathTraversal(realPath + companyPath + commonUtil.separator + "encodeinfo.xml"));
		encodeInfo = FileUtils.readFileToString(file);
		
		model.addAttribute("encodeInfo", encodeInfo);
		
		logger.debug("getOptionInfo ended.");
		
		return "json";
	}
	
	
	/**
	 * 전자결재G관리 문서유통암호화설정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/saveOptionInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveOptionInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("saveOptionInfo started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String optionValue1 = request.getParameter("option1");
		String optionValue2 = request.getParameter("option2");
		String optionValue3 = request.getParameter("option3");
		String companyID = request.getParameter("companyID");
		String realPath = commonUtil.getRealPath(request);
		String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		
		String returnString = "<ENCODEINFO><SIGN>" + optionValue1 + "</SIGN><ENCODE>" + optionValue2 + "</ENCODE><NONE>" + optionValue3 + "</NONE></ENCODEINFO>";
		 
		try {
			File cFile = new File(commonUtil.detectPathTraversal(realPath + dirPath + commonUtil.separator + companyID));
			if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				if (!_flag) {
					throw new IOException("Directory creation Failed ");
				}
			}
			
			File file = new File(commonUtil.detectPathTraversal(realPath + dirPath + commonUtil.separator + companyID + commonUtil.separator + "encodeinfo.xml"));
			// CWE-404 보안 취약점 대응
			try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, false))) {
				writer.write(returnString);
				writer.flush();
			}
			
			logger.debug("saveOptionInfo success.");

			return "TRUE";
		} catch (Exception e) {
			logger.debug("saveOptionInfo exception.");
			
			return "FALSE";
		} finally {
			logger.debug("saveOptionInfo ended.");
		}
	}
	
	/**
	 * 전자결재G관리 결재건수조회 메뉴 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/statistics.do", method = RequestMethod.GET)
	public String ezStatistics(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statistics started.");
		
		LoginVO userInfo  = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());

		String tempYear = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("YYYY"), userInfo.getOffset(), false);
		String tempMonth = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("MM"), userInfo.getOffset(), false);
		
		int tempPYear = Integer.parseInt(tempYear);
		String tempPMonth = Integer.toString(Integer.parseInt(tempMonth) - 1);
		
		if (Integer.parseInt(tempPMonth) <= 0) {
			tempPYear = tempPYear - 1;
			tempPMonth = "12";
		}
		
		if (tempPMonth.length() == 1) {
			tempPMonth = "0" + tempPMonth;
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		model.addAttribute("tempPYear", tempPYear);
		model.addAttribute("tempPMonth", tempPMonth);
		model.addAttribute("tempYear", tempYear);
		model.addAttribute("tempMonth", tempMonth);
		model.addAttribute("approvalFlag", approvalFlag);
		
		logger.debug("statistics ended.");
		
		return "admin/ezApprovalG/apprGStatistics";
	}
	
	/**
	 * 전자결재G관리 결재건수조회 처리과별 검색 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getDeptTranSendDocCount.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getDeptTranSendDocCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getDeptTranSendDocCount started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		String sYear = request.getParameter("sYear");
		String sMonth = request.getParameter("sMonth");
		String eYear = request.getParameter("eYear");
		String eMonth = request.getParameter("eMonth");
		String pMode = request.getParameter("pMode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getDeptTranSendDocCount(sYear, sMonth, eYear, eMonth, pMode, companyID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId(), approvalFlag);
		
		logger.debug("getDeptTranSendDocCount ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 결재건수조회 개인별 검색 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getUserDocCount.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getUserDocCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getUserDocCount started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		String sYear = request.getParameter("sYear");
		String sMonth = request.getParameter("sMonth");
		String eYear = request.getParameter("eYear");
		String eMonth = request.getParameter("eMonth");
		String userFlag = request.getParameter("userFlag");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getUserDocCount(sYear, sMonth, eYear, eMonth, userFlag, companyID, userInfo, approvalFlag);
		
		logger.debug("getUserDocCount ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G관리 결재건수조회 엑셀저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/ezStatistics/excelExportOut.do", method = RequestMethod.GET)
	@ResponseBody
	public void excelExportOut(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("excelExportOut started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
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
			excelValue = ezApprovalGAdminService.getUserDocCount(sYear, sMonth, eYear, eMonth, mode, companyID, userInfo, approvalFlag);
		} else {
			excelValue = ezApprovalGAdminService.getDeptTranSendDocCount(sYear, sMonth, eYear, eMonth, mode, companyID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId(), approvalFlag);
		}

		Document objXML = commonUtil.convertStringToDocument(excelValue);
		
		resultExcel.append("\uFEFF");
		resultExcel.append("<table><tbody><tr>");
		
		for (int k = 0; k < objXML.getElementsByTagName("HEADER").getLength(); k++) {
			String headerName = objXML.getElementsByTagName("NAME").item(k).getTextContent();
			String headerWidth = objXML.getElementsByTagName("WIDTH").item(k).getTextContent();
			
			int width = Integer.parseInt(headerWidth) * 2;
			
			resultExcel.append("<td style='BORDER-BOTTOM: windowtext 0.5pt solid; BORDER-LEFT: windowtext; BACKGROUND-COLOR: #a6a6a6; BORDER-TOP: windowtext 0.5pt solid; BORDER-RIGHT: windowtext 0.5pt solid;width:" + width + "'><p align='center'><STRONG>" + commonUtil.cleanValue(headerName) + "</STRONG></p></td>");
		}
		resultExcel.append("</tr>");

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
				
				resultExcel.append("<td style='BORDER-BOTTOM: windowtext 0.5pt solid; BORDER-LEFT: windowtext; BORDER-TOP: windowtext 0.5pt solid; BORDER-RIGHT: windowtext 0.5pt solid;width:" + width + "'><p align='left'>" + commonUtil.cleanValue(cellValue) + "</p></td>");
			}
			resultExcel.append("</tr>");
		}
		resultExcel.append("</tbody></table>");
/*
		response.setContentType("application/ms-excel");
		response.setCharacterEncoding("utf-8");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + EgovDateUtil.getTodayTime().substring(0, 10) + "_excelExportOutUser" + ".xls\"");

		logger.debug("excelExportOut ended.");

		response.getWriter().write(resultExcel.toString());
*/
		// 2023-08-30 이주원 - html형식을 HSSF형식으로 변환후 xls로 다운로드
		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
			HSSFSheet sheet;

			HSSFCellStyle headerStyle = workbook.createCellStyle();
			headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);

			HSSFCellStyle bodyStyle = workbook.createCellStyle();
			bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);

			Row row;
			Cell cell;

			String pFileName = "";
			pFileName = EgovDateUtil.getTodayTime().substring(0, 10) + "_excelExportOutUser";
			sheet = workbook.createSheet("report");

			String StrAnalysisDate = resultExcel.toString().trim().replaceAll("&nbsp;", "").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\t", "");

			Document analysisData = commonUtil.convertStringToDocument(StrAnalysisDate);

			Node tableNode = analysisData.getElementsByTagName("table").item(0);
			Node tableHeadNode;
			Node tableBodyNode;

			tableHeadNode = tableNode.getChildNodes().item(0).getChildNodes().item(0);
			tableBodyNode = tableNode.getChildNodes().item(0);

			row = sheet.createRow(0);
			
			for (int i = 0; i < tableHeadNode.getChildNodes().getLength(); i++) {
				cell = row.createCell(i);
				cell.setCellValue(tableHeadNode.getChildNodes().item(i).getTextContent());
				cell.setCellStyle(headerStyle);

				sheet.autoSizeColumn(i);
				
				/* 2024-11-05 홍승비 - 엑셀 파일 저장 시 동적인 너비 계산이 setColumnWidth()에서 허용하는 최대 제한을 넘지 않도록 수정 (255 * 256 = 65280) */
				sheet.setColumnWidth(i, Math.min(65280, sheet.getColumnWidth(i) + 1024)); // 너비 더 넓게
			}

			for (int i = 0; i < tableBodyNode.getChildNodes().getLength() - 1; i++) {
				row = sheet.createRow(i+1);
				Node tr = tableBodyNode.getChildNodes().item(i+1);

				for (int j = 0; j < tr.getChildNodes().getLength(); j++) {
					cell = row.createCell(j);
					cell.setCellValue(tr.getChildNodes().item(j).getTextContent());
					cell.setCellStyle(bodyStyle);

					sheet.autoSizeColumn(j);
					sheet.setColumnWidth(j, Math.min(65280, sheet.getColumnWidth(j) + 1024)); //너비 더 넓게
				}
			}
			response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
			workbook.write(response.getOutputStream());

		}

	}
	
	/**
	 * 전자결재G관리 전체문서조회(진행문서) 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/forAprDoc.do", method = RequestMethod.GET)
	public String forAprDoc(@CookieValue ("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("forAprDoc started.");
		
		LoginVO userInfo  = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String useEditApprDoc = ezCommonService.getTenantConfig("useEditApprDoc", userInfo.getTenantId());
		
		String type = request.getParameter("type");
		type = (type == null || type.isEmpty()) ? "admin" : type;

		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER) || organAuth.isAuth(AdminAuth.APR_QUERY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());

        if (!organAuth.isAuth(AdminAuth.ADMIN_MASTER)) {
			// 전체관리자가 아닌경우 회사관리자나 결재조회관리자 권한이 있는 회사만 필터
            list = list.stream()
                    .filter(vo -> 
                            organAuth.isAuth(AdminAuth.COMPANY_MANAGER, vo.getCn()) || organAuth.isAuth(AdminAuth.APR_QUERY_MANAGER, vo.getCn()))
                    .collect(Collectors.toList());
        }

        model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", list);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("type", type);
		model.addAttribute("useEditApprDoc", useEditApprDoc);
		model.addAttribute("nowDateUTC", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		model.addAttribute("openYear", ezCommonService.getTenantConfig("Site_OpenYear", userInfo.getTenantId()));
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("useReceiveInfoName", ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId()));
		
		logger.debug("forAprDoc ended.");
		
		return "admin/ezApprovalG/apprGForAprDoc";
	}
	
	/**
	 * 관리자->전체 문서 조회(진행문서) // 문서편집 기능 추가
	 * */
	@RequestMapping(value = "/admin/ezApprovalG/modifyAprDoc.do", produces = "text/html;charset=utf-8", method = RequestMethod.GET)
	public String modifyAprDoc(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("modifyAprDoc started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		//관리자 권한 체크
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		String docID = request.getParameter("docID");
		String pURL = request.getParameter("url");
		String companyID = request.getParameter("companyID");
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		logger.debug("docID : " + docID);
		logger.debug("pURL : " + pURL);
		
		model.addAttribute("docID", docID);
		model.addAttribute("url" , pURL);
		model.addAttribute("companyID", companyID);
		model.addAttribute("useEditor", useEditor);
		
		logger.debug("modifyAprDoc ended.");
		
		return "admin/ezApprovalG/modifyAprDoc";
	}	
	
	/**
	 * 전자결재G관리 전체문서조회(진행문서) 문서목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatSearchAprDocList.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getStatSearchAprDocList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getStatSearchAprDocList started.");

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
        String formName = request.getParameter("formName");
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
				draftToYear,draftToMonth,draftToDay, apprFromYear, apprFromMonth, apprFromDay, apprToYear, apprToMonth, apprToDay, formID, formName, draftDeptName, 
				draftDeptName2,pageNum, pageSize, docState, subQuery, orderCell, orderOption, companyID, userInfo.getLang(), approvUser, userInfo.getOffset(), userInfo.getTenantId());
        
			logger.debug("getStatSearchAprDocList ended.");

        return result; 
	}
	
	/**
	 * 전자결재G관리 전체문서조회(진행문서) 문서별 결재선 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatLineList.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getStatLineList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getStatLineList started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("flag");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGService.getLineInfo(docID, mode, "", "", companyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getStatLineList ended.");

		return result;
	}
	
	/** 
	 * 전자결재G관리 전체문서조회(진행문서) 문서별 수신자 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatReceiptList.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getStatReceiptList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getStatReceiptList started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("flag");
		String companyID = request.getParameter("companyID");
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		String result = ezApprovalGService.getReceiptInfo(docID, mode, "", "", companyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), approvalFlag, "", userInfo.getLocale());
		
		logger.debug("getStatReceiptList ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 전체문서조회(진행문서) 문서별 첨부 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatAttachList.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getStatAttachList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getStatAttachList started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("flag");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGService.getAttachInfo(docID, mode, "", "", companyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getStatAttachList ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 전체문서조회(진행문서) 문서별 의견 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatOpinionList.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getStatOpinionList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getStatOpinionList started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("flag");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGService.getOpinionInfo(docID, mode, "", "", companyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getStatOpinionList ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 전체문서조회(완료문서) 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/forDoc.do", method = RequestMethod.GET)
	public String forDoc(@CookieValue ("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("forDoc started.");
		
		LoginVO userInfo  = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		String type = request.getParameter("type");
		type = (type == null || type.isEmpty()) ? "admin" : type;

		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER) || organAuth.isAuth(AdminAuth.APR_QUERY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());

		if (!organAuth.isAuth(AdminAuth.ADMIN_MASTER)) {
			// 전체관리자가 아닌경우 회사관리자나 결재조회관리자 권한이 있는 회사만 필터
			list = list.stream()
					.filter(vo ->
							organAuth.isAuth(AdminAuth.COMPANY_MANAGER, vo.getCn()) || organAuth.isAuth(AdminAuth.APR_QUERY_MANAGER, vo.getCn()))
					.collect(Collectors.toList());
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("list", list);
		model.addAttribute("type", type);
		model.addAttribute("nowDateUTC", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		model.addAttribute("openYear", ezCommonService.getTenantConfig("Site_OpenYear", userInfo.getTenantId()));
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("useReceiveInfoName", ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId()));
		
		logger.debug("forDoc ended.");
		
		return "admin/ezApprovalG/apprGForDoc";
	}
	
	/**
	 * 전자결재G관리 전체문서조회(완료문서) 문서목록 호출 함수 (2024-03-14 분석 결과 실제 호출이 없는 코드로 확인, /admin/ezApprovalG/getStatSearchEndDocList.do 호출만 사용됨)
	 */
	/*@RequestMapping(value = "/admin/ezApprovalG/getStatSearchDocList.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getStatSearchDocLlist(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getStatSearchDocList started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String offset = userInfo.getOffset();
		Locale locale = userInfo.getLocale();
		String lang = userInfo.getLang();
		
		//양식아이디
		String formID = request.getParameter("formID");
		//양식명 2021.01.13 박기범 추가
		String formName = request.getParameter("formName");
		//문서번호
		String docNumber = request.getParameter("docNumber");
        //문서제목
		String docTitle = request.getParameter("docTitle");
        //기안자
		String drafter = request.getParameter("drafter");
        //결재자
		String approvUser = request.getParameter("approvUser");
        //기안부서
		String draftDeptName = request.getParameter("deptName1");
        
		//기안일자 시작
        String draftFromYear = request.getParameter("draftFromYear");
        String draftFromMonth = request.getParameter("draftFromMonth");
        String draftFromDay = request.getParameter("draftFromDay");
        
        String draftFrom = "";
        
        if (draftFromYear != null && !draftFromYear.equals("")) {
        	draftFrom = commonUtil.getDateStringInUTC(commonUtil.makeDate(draftFromYear, draftFromMonth, draftFromDay, true), offset, false).trim();
        }
        
        //기안일자 끝
        String draftToYear = request.getParameter("draftToYear");
        String draftToMonth = request.getParameter("draftToMonth");
        String draftToDay = request.getParameter("draftToDay");

        String draftTo = "";
        
        if (draftToYear != null && !draftToYear.equals("")) {
        	draftTo = commonUtil.getDateStringInUTC(commonUtil.makeDate(draftToYear, draftToMonth, draftToDay, true), offset, false).trim();
        }
        
        //완료일자 시작
        String apprFromYear = request.getParameter("apprFromYear");
        String apprFromMonth = request.getParameter("apprFromMonth");
        String apprFromDay = request.getParameter("apprFromDay");
        
        String aprFrom = "";
        
        if (apprFromYear != null && !apprFromYear.equals("")) {
        	aprFrom = commonUtil.getDateStringInUTC(commonUtil.makeDate(apprFromYear, apprFromMonth, apprFromDay, true), offset, false).trim();
        }
        
        //완료일자 끝
        String apprToYear = request.getParameter("apprToYear");
        String apprToMonth = request.getParameter("apprToMonth");
        String apprToDay = request.getParameter("apprToDay");
        String aprTo = "";
        
        if (apprToYear != null && !apprToYear.equals("")) {
        	aprTo = commonUtil.getDateStringInUTC(commonUtil.makeDate(apprToYear, apprToMonth, apprToDay, true), offset, false).trim();
        }
        	
        //페이지 번호
        String pageNum = request.getParameter("pageNum");
        //총페이지 수
        String pageSize = request.getParameter("pageSize");

        //정렬 대상 셀
        String orderCell = request.getParameter("orderCell");
        //정렬 옵션
        String orderOption = request.getParameter("orderOption");
        
        //테넌트 아이디
        int tenantID = userInfo.getTenantId();
        
        //회사 아이디
        String companyID = request.getParameter("companyID");
        
        //일반/공공구분
        String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		//키워드 2021.03.11 박기범 추가
		String keyword = request.getParameter("keyword");

        String result = "";

        result = ezApprovalGAdminService.getAdminSearchDocList(formID, formName, docNumber, docTitle, drafter, approvUser, draftDeptName, draftFrom, draftTo, aprFrom, aprTo, pageSize, pageNum, orderCell, orderOption, companyID, tenantID, lang, offset, approvalFlag, keyword,locale);
        
        logger.debug("getStatSearchDocList ended.");
        
		return result;
	}*/
	
	/** 
	 * 전자결재G관리 전체문서조회 검색 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/search.do", method = RequestMethod.GET)
	public String search(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("search started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String ingFlag = request.getParameter("ingFlag");
		String initDate = EgovDateUtil.getToday("-");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("aprFlag", ingFlag);
		model.addAttribute("initDate", initDate);
		
		logger.debug("search ended.");
		
		return "admin/ezApprovalG/apprGSearch";
	}
	
	/**
	 * 전자결재G관리 전체문서조회 폐기 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setContainerIDForDoc.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setContainerIDForDoc (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("setContainerIDForDoc started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String containerType = request.getParameter("containerType");
		String companyID = request.getParameter("companyID");
		String orgContainerID = request.getParameter("orgContainerID");

		String containerID = ezApprovalGAdminService.setContainerIDForDoc1(orgContainerID, containerType, companyID, userInfo.getTenantId());
		
		if (containerID == null) {
			containerID = ezApprovalGService.makeContainer(deptID, containerType, companyID, userInfo.getTenantId());
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
	
	/**
	 * 전자결재G관리 문서이동 메인화면 호출
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMoveContainer.do", method = RequestMethod.GET)
	public String apprGMoveContainer(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("apprGMoveContainer started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("list", resultList);
		
		logger.debug("apprGMoveContainer ended");
		
		return "admin/ezApprovalG/apprGMoveContainer";
	}
	
	/**
	 * 전자결재g 관리자 문서이동 부서선택 표출
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGOrgan.do", method = RequestMethod.GET)
	public String apprGOrgan(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("apprGOrgan started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("serverName", userInfo.getServerName());
		
		logger.debug("apprGOrgan ended");
		
		return "admin/ezApprovalG/apprGOrgan";
	}
	
	/**
	 * 전자결재g 관리자 문서이동 문서함 문서 표출 (2024-03-07 기준 해당 URL은 실제로 호출되지 않는 것을 확인함, /admin/ezApprovalG/getDocListjson.do URL로 개선됨)
	 */
	/*@RequestMapping(value = "/admin/ezApprovalG/getDocList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getDocList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getDocList started");
		logger.debug("period = " + request.getParameter("period"));
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String contID = request.getParameter("contID");
		String pageNum = request.getParameter("pageNum");
		String pageSize = request.getParameter("pageSize");
		String companyID = request.getParameter("companyID");
		
		// 2024-03-07 홍승비 - SQL Injection 제거 > 검색 쿼리를 문자열이 아닌 맵으로 전달
		Map<String, Object> searchQueryMap = new HashMap<String, Object>();
		
		if (request.getParameter("docNO") != null && !request.getParameter("docNO").equals("")) {
			searchQueryMap.put("col_where_DOCNO", request.getParameter("docNO"));
		}
		
		if (request.getParameter("docTitle") != null && !request.getParameter("docTitle").equals("")) {
			searchQueryMap.put("col_where_DOCTITLE", request.getParameter("docTitle"));
		}
		
		if (request.getParameter("drafter") != null && !request.getParameter("drafter").equals("")) {
			searchQueryMap.put("col_where_WRITERNAME", request.getParameter("drafter")); // 다국어 처리 쿼리단으로 이동
		}
		
		if (request.getParameter("draftFrom") != null && !request.getParameter("draftFrom").equals("") && request.getParameter("draftTo") != null && !request.getParameter("draftTo").equals("")) {
			searchQueryMap.put("col_where_STARTDATE_START", commonUtil.getDateStringInUTC(request.getParameter("draftFrom"), userInfo.getOffset(), true));
			searchQueryMap.put("col_where_STARTDATE_END", commonUtil.getDateStringInUTC(request.getParameter("draftTo"), userInfo.getOffset(), true));
		}
		
		if (request.getParameter("aprFrom") != null && !request.getParameter("aprFrom").equals("") && request.getParameter("aprTo") != null && !request.getParameter("aprTo").equals("")) {
			searchQueryMap.put("col_where_ENDDATE_START", commonUtil.getDateStringInUTC(request.getParameter("aprFrom"), userInfo.getOffset(), true));
			searchQueryMap.put("col_where_ENDDATE_END", commonUtil.getDateStringInUTC(request.getParameter("aprTo"), userInfo.getOffset(), true));
		}
		
		if (request.getParameter("deptName") != null && !request.getParameter("deptName").equals("")) {
			searchQueryMap.put("col_where_WRITERDEPTNAME", request.getParameter("deptName"));
		}
		
		if (request.getParameter("formID") != null && !request.getParameter("formID").equals("")) {
			searchQueryMap.put("col_where_FORMID", request.getParameter("formID"));
		}
		
		if (request.getParameter("period") != null && !request.getParameter("period").equals("")) {
			searchQueryMap.put("col_where_STORAGEPERIOD", request.getParameter("period"));
		}
		
		// 기존 searchQuery 문자열 대신 searchQueryMap을 사용하여 검색 조건 전달
		String result = ezApprovalGService.getContDocList(contID, "", searchQueryMap, pageSize, pageNum, "", "", companyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
	
		logger.debug("getDocList ended");
		
		return result;
	}*/
	
	/**
	 * 전자결재 일반버전 관리자 문서이동 및 문서삭제 문서함 문서 표출
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getDocListjson.do", method = RequestMethod.POST)
	public String getDocList_json(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model  model) throws Exception {
		logger.debug("getDocListjson started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String contID = request.getParameter("contID");
		String pageNum = request.getParameter("pageNum");
		String companyID = request.getParameter("companyID");
		String pSelectTab = request.getParameter("pSelectTab");
		boolean publicFlag = false;
		boolean securityFlag = false;
		String userSecurityCode = "";
		List<ApprGDocListVO> list = null;
		Map<String, Object> queryMap = new HashMap<>();
		
		if (pageNum == null || pageNum.equals("")) {
			pageNum = "1";
		}
		
		int totalcnt = 0;
		int maxItemPerPage = 15; 
		int currentPage = Integer.parseInt(pageNum);
		int startRow = Math.multiplyExact(Math.subtractExact(currentPage, 1), maxItemPerPage);
		
		if (pageNum.equals("-1")) {
			startRow = -1;
		}
		
		if (ezApprovalGAdminService.getIsUse("A22", "001", companyID, userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			securityFlag = true;
		}
		
		if (ezApprovalGAdminService.getIsUse("A22", "004", companyID, userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			publicFlag = true;
		}
		
		if (securityFlag) {
			userSecurityCode = ezOrganService.getPropertyValue("", "extensionAttribute6", userInfo.getTenantId());
		}
		
		if (userSecurityCode == null || userSecurityCode.equals("")) {
			userSecurityCode = "0";
		}
		
		String qOptionDocNo = "";
		String qOptionDocTitle = "";
		String qOptionWriterName = "";
		String qOptionEndDate1 = "";
		String qOptionEndDate2 = "";
		String qOptionDeleteTime1 = "";
		String qOptionDeleteTime2 = "";
		String qOptionWriterDeptId = "";
		String qOptionFormId = "";
		
		if (request.getParameter("docNO") != null && !request.getParameter("docNO").equals("")) {
			qOptionDocNo = request.getParameter("docNO");
		}
		
		if (request.getParameter("docTitle") != null && !request.getParameter("docTitle").equals("")) {
			qOptionDocTitle = request.getParameter("docTitle");
		}
		
		if (request.getParameter("drafter") != null && !request.getParameter("drafter").equals("")) {
			qOptionWriterName = request.getParameter("drafter");
		}
		
		if (request.getParameter("aprFrom") != null && !request.getParameter("aprFrom").equals("") && request.getParameter("aprTo") != null && !request.getParameter("aprTo").equals("")) {
			if (pSelectTab.equals("completedoclist")) {
				qOptionEndDate1 = commonUtil.getDateStringInUTC(request.getParameter("aprFrom"), userInfo.getOffset(), false) + " 00:00:00";
				qOptionEndDate2 = commonUtil.getDateStringInUTC(request.getParameter("aprTo"), userInfo.getOffset(), false) + " 23:59:59";
			} else {
				qOptionDeleteTime1 = commonUtil.getDateStringInUTC(request.getParameter("aprFrom"), userInfo.getOffset(), false) + " 00:00:00";
				qOptionDeleteTime2 = commonUtil.getDateStringInUTC(request.getParameter("aprTo"), userInfo.getOffset(), false) + " 23:59:59";
			}
		}
		
		if (request.getParameter("drafterdept") != null && !request.getParameter("drafterdept").equals("")) {
			qOptionWriterDeptId = request.getParameter("drafterdept");
		}
		
		if (request.getParameter("formID") != null && !request.getParameter("formID").equals("")) {
			qOptionFormId = request.getParameter("formID");
		}
		
		queryMap.put("qOptionDocNo", qOptionDocNo);
		queryMap.put("qOptionDocTitle", qOptionDocTitle);
		queryMap.put("qOptionWriterName", qOptionWriterName);
		queryMap.put("qOptionEndDate1", qOptionEndDate1);
		queryMap.put("qOptionEndDate2", qOptionEndDate2);
		queryMap.put("qOptionDeleteTime1", qOptionDeleteTime1);
		queryMap.put("qOptionDeleteTime2", qOptionDeleteTime2);
		queryMap.put("qOptionWriterDeptId", qOptionWriterDeptId);
		queryMap.put("qOptionFormId", qOptionFormId);
		
		if (pSelectTab.equals("completedoclist")) {
			totalcnt = ezApprovalGAdminService.getContDocListCountjson(contID, "", userSecurityCode, publicFlag, companyID, userInfo.getTenantId(), queryMap);
		} else {
			totalcnt = ezApprovalGAdminService.getDeleteDocListCountjson("", userSecurityCode, publicFlag, companyID, userInfo.getTenantId(), queryMap);
		}
		
		int totalPage = totalcnt / maxItemPerPage ;
		
		if (totalcnt < 1) {
			totalPage = 1;
		} 
		
		if ((totalPage * maxItemPerPage) != totalcnt && (totalcnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1 ;
		}
		
		currentPage = Math.min(currentPage, totalPage);	
		
		if (pSelectTab.equals("completedoclist")) {
			list = ezApprovalGAdminService.getContDocList_json(contID, "", userSecurityCode, publicFlag, startRow, maxItemPerPage, pageNum, "", "", totalcnt, companyID, userInfo.getLang(), userInfo.getTenantId(), commonUtil.getMinuteUTC(userInfo.getOffset()), userInfo.getLocale(), queryMap);
		} else {
			list = ezApprovalGAdminService.getDeleteDocList_json("", startRow, maxItemPerPage, pageNum, totalcnt, companyID, userInfo.getTenantId(),commonUtil.getMinuteUTC(userInfo.getOffset()), userInfo.getLang(), userInfo.getLocale(), queryMap);
		}
		
		model.addAttribute("DocDeleteHistList", list);
		model.addAttribute("totalcnt",totalcnt);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("currPage", currentPage);
		model.addAttribute("pSelectTab", pSelectTab);
		
		logger.debug("getDocListjson ended");
		
		return "json";
	}
	
	/**
	 * 전자결재 일반버전 관리자 문서이동 로직
	 */
	@RequestMapping(value = "/admin/ezApprovalG/moveContainer.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String moveContainer(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("moveContainer started");
		
		String strMoveListIDInfo = request.getParameter("strMoveListIDInfo");
		String SourceContID = request.getParameter("SourceContID");
		String TargetContID = request.getParameter("TargetContID");
		String SourceCompanyID = request.getParameter("SourceCompanyID");
		String chkAll = request.getParameter("chkAll");
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		String result = ezApprovalGAdminService.moveDocList(strMoveListIDInfo, SourceContID, TargetContID, chkAll, SourceCompanyID, userInfo.getTenantId());
		
		logger.debug("moveContainer ended");
		
		return result;
	}
	
	/**
	 * 전자결재g 관리자 문서이동 검색 호출
	 */
	@RequestMapping(value = "/admin/ezApprovalG/ezStatisticsSearch.do", method = RequestMethod.GET)
	public String ezStatisticsSearch(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezStatisticsSearch started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String aprFlag = request.getParameter("ingFlag");
		String listType = request.getParameter("listType");
		String startDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String endDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		model.addAttribute("aprFlag", aprFlag);
		model.addAttribute("listType", listType);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("monthEndDay", endDate.substring(5, 7));
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("initDate", startDate.substring(0, 10));
		
		logger.debug("ezStatisticsSearch ended");
		
		return "admin/ezApprovalG/apprGStatisticsSearch";
	}
	
	/**
	 * 전자결재g 관리자 문서삭제 메인화면 호출
	 */
	@RequestMapping(value = "/admin/ezApprovalG/docDelete.do", method = RequestMethod.GET)
	public String docDelete (@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("docDelete started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
				
		String periodNode = ezApprovalGAdminService.getKeepType("", userInfo, userInfo.getCompanyID(), approvalFlag);

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("list", resultList);
		model.addAttribute("periodNode", periodNode);
		
		logger.debug("docDelete ended");
		
		return "admin/ezApprovalG/apprGDocDelete";
	}
	
	/**
	 * 전자결재g 관리자 문서삭제 삭제 로직 (2024-06-04 확인 시 현재 사용되지 않는 로직으로 확인하여 주석처리, delDocListjson으로 대체됨)
	 */
	/*@RequestMapping(value = "/admin/ezApprovalG/delDocList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String delDocList(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlPara) throws Exception {
		logger.debug("delDocList started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalGAdminService.deleteDocList(xmlPara, userInfo.getOffset(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("delDocList ended");
		
		return result;
	}*/
	
	/**
	 * 전자결재 일반버전 관리자 문서삭제 삭제 로직
	 */
	@RequestMapping(value = "/admin/ezApprovalG/delDocListjson.do", method = RequestMethod.POST)
	public String delDocListjson(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model  model) throws Exception {
		logger.debug("delDocListjson started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String DocDelIDArr[] = request.getParameter("docIDList").split(";");
		String DocDelNoArr[] = request.getParameter("docNoList").split(";");
		String DocDelTitleArr[] = request.getParameter("docTitleList").split(";");
		String DocDelWriterNameArr[] = request.getParameter("WriterNameList").split(";");
		String DocDelDeptNameArr[] = request.getParameter("DeptNameList").split(";");
		String deleteDay = request.getParameter("deleteDay");
		String companyID = request.getParameter("companyID");
		ezApprovalGAdminService.deleteDocListjson(DocDelIDArr, DocDelNoArr, DocDelTitleArr, DocDelWriterNameArr, DocDelDeptNameArr, deleteDay, userInfo.getId(), userInfo.getOffset(), companyID, userInfo.getTenantId());
		
		logger.debug("delDocListjson ended");
		
		return "json";
	}
	
	/**
	 * 전자결재G 관리자 HWP양식작성기 연동정보 저장 실행함수
	 * 전자결재 관리자 HWP양식작성기 연동정보 저장 실행함수
	 */
	/*HWP연동정보 xml파일로 저장, HWP문서 내부에 저장된 연동정보 사용중이라 주석처리*/
	@RequestMapping(value = "/admin/ezApprovalG/formConnSave.do", method = RequestMethod.POST)
	public String formConnSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("formConnSave started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String path = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		String formID = request.getParameter("formID");
		String formText = request.getParameter("formText");
		String companyID = request.getParameter("companyID");
		
		if (formID == null || formID.trim().equals("")) {
			formID = "CONN" + commonUtil.getTodayUTCTime("yyyyMMddHHmmss");
		}
		
		String result = ezApprovalGAdminService.formConnSave(formID, formText, path, companyID);
		
		model.addAttribute("result", result);
		
		logger.debug("formConnSave ended.");
		
		return "json";
	}
	
	@RequestMapping(value="/admin/ezApprovalG/approvGAdminPopupChoiceDept.do", method = RequestMethod.GET)
	public String  scheduleAdminPopupShareDept(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		
		logger.debug("============ approvGAdminPopupChoiceDept started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String lang = loginSimpleVO.getLang();
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("lang", lang);
		model.addAttribute("CompanyID",userInfo.getCompanyID());
		return "admin/ezApprovalG/approvGAdminPopupChoiceDept";
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/adminBujae.do", method = RequestMethod.GET)
	public String manageBujae(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Locale locale, Model model) throws Exception{
		logger.debug("adminBujae started");

		userInfo = commonUtil.userInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		String userID = "";
		String deptID = "";
		String startDate = "";
		String endDate = "";
		String bReason = "";
		String textName = "";
		String proxyUserID = "";
		String proxyDeptID = "";
		String proxyUserName = "";
		String textProxyName = "";
		String initDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		/*String result = ezOrganService.getPropertyValue(userInfo.getId(), "extensionAttribute5", userInfo.getTenantId());*/
		String cDate = "";
		String cTime = "";
		/*if (result != null && !result.equals("")) {
			String[] info = result.split(":");
			
			userID = info[0];
			textName = info[1];
			deptID = info[2];
			startDate = info[3] + ":" + info[4];
			endDate = info[5] + ":" + info[6];
			
			if (info.length > 7) {
				bReason = info[7];
			}
		} else {
			cDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false);
			cTime = cDate.split(" ")[1].substring(0, 2);
			
			cDate = cDate.substring(0, 10);
			startDate = cDate + " " + cTime + ":00:00";
			
			cDate = cDate.substring(0, 10);
			endDate = cDate + " " + Integer.toString((Integer.parseInt(cTime) + 1)) + ":00:00";
		}*/
		
		cDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false);
		cTime = cDate.split(" ")[1].substring(0, 2);
		
		cDate = cDate.substring(0, 10);
		startDate = cDate + " " + cTime + ":00:00";
		
		cDate = cDate.substring(0, 10);
		endDate = cDate + " " + Integer.toString((Integer.parseInt(cTime) + 1)) + ":00:00";
		
		
		/*if (userInfo.getRollInfo() != null && userInfo.getRollInfo().toLowerCase().indexOf("a=1;") > -1) {
			result = ezOrganService.getProxyUserInfo(userInfo.getId(), userInfo.getTenantId(), userInfo.getOffset());
			
			Document xmlDom = commonUtil.convertStringToDocument(result);
			
			if (xmlDom.getElementsByTagName("PROXYUSERID").getLength() > 0) {
				proxyUserID = xmlDom.getElementsByTagName("PROXYUSERID").item(0).getTextContent();
				proxyDeptID = xmlDom.getElementsByTagName("PROXYUSERDEPTID").item(0).getTextContent();
				proxyUserName = xmlDom.getElementsByTagName("PROXYUSERNAME").item(0).getTextContent();
				startDate = xmlDom.getElementsByTagName("STARTDATE").item(0).getTextContent();
				endDate = xmlDom.getElementsByTagName("ENDDATE").item(0).getTextContent();
				
				textProxyName = proxyUserName;
			}
		}*/
		
		if (bReason.trim().equals("")) {
			bReason = egovMessageSource.getMessage("ezPersonal.t35", locale);
		}
		
		/* 2020-10-21 홍승비 - 회사 선택 기능 추가 */
		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		model.addAttribute("deptID", deptID);
		model.addAttribute("userID", userID);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("bReason", bReason);
		model.addAttribute("proxyUserID", proxyUserID);
		model.addAttribute("proxyDeptID", proxyDeptID);
		model.addAttribute("proxyUserName", proxyUserName);
		model.addAttribute("initDate", initDate);
		model.addAttribute("textName", textName);
		model.addAttribute("textProxyName", textProxyName);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("list", resultList);

		logger.debug("manageBujae ended");
		return "admin/ezApprovalG/apprGManageBujae";
	}
	
	/**
	 * 전자결재 부재자설정 끄기 Method
	 */	
	@RequestMapping(value = "/admin/ezApprovalG/saveBujae.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String saveBujae(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("saveBujae started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String buJaeId = request.getParameter("buJaeId");
		// String proxyuserid = request.getParameter("proxyuserid");
		String buJaeInfo = request.getParameter("buJae");
		String buJaeInfo2 = "";
		String proxyInfo = request.getParameter("proxy");
		String dept = request.getParameter("dept");

//		String proxyInfo2 = "";
		//TODO: 원래는 user를 ad에서 정보 가져오는데 임시로 하드코딩함 전자결재외에 다른 부분 발견하면 수정요망(전자결재만 존재하면 그냥 박아도됨)
		String pClass = "user";
		if (buJaeInfo != null && !buJaeInfo.equals("")) {
			if (buJaeInfo.split(":").length >= 5) {
				buJaeInfo2 = buJaeInfo.split(":")[0] + ":" + buJaeInfo.split(":")[1] + ":" + buJaeInfo.split(":")[2] + ":" + buJaeInfo.split(":")[3] + ":" + buJaeInfo.split(":")[4] + ":" + buJaeInfo.split(":")[5] + ":"  + buJaeInfo.split(":")[6];
			}
			
			if (buJaeInfo.split(":").length > 7) {
				buJaeInfo2 +=  ":" + buJaeInfo.split(":")[7];
			}
		}
		String result = "";
		String userRealDeptId = "";


		userRealDeptId = ezOrganService.getUserOrgDeptId(buJaeId, userInfo.getTenantId(), userInfo.getCompanyID());
		if (dept == null || dept.equals("") || dept.equals(userRealDeptId)) {
			result = ezOrganService.updateProperty(buJaeId, "extensionAttribute5", buJaeInfo2, pClass, userInfo.getTenantId());
			logger.debug("updateProperty buJaeId:" + buJaeId + " / buJaeInfo2:" + buJaeInfo2);
		} else {
			result = ezOrganService.updateAddJobProxy(buJaeId, buJaeInfo2, userInfo.getTenantId(), dept);
			logger.debug("updateAddJobProxy buJaeId:" + buJaeId + " / buJaeInfo2:" +buJaeInfo2 + " / dept:" + dept);
		}
		
		if (result.equals("OK")) {
//			if (proxyInfo.split(":").length >= 5) {
//				proxyInfo2 = proxyInfo.split(":")[0] + ":" + proxyInfo.split(":")[1] + ":" + proxyInfo.split(":")[3] + ":" + proxyInfo.split(":")[4];
//			}
						
			if (proxyInfo.split("\\|")[0].trim().equals("")) {
				result = ezOrganService.delProxyUserInfo(buJaeId, userInfo.getTenantId());
				logger.debug("delProxyUserInfo buJaeId:" + buJaeId);
			} else {
				result = ezOrganService.setProxyUserInfo(buJaeId, proxyInfo.split("\\|")[0], proxyInfo.split("\\|")[1], proxyInfo.split("\\|")[2], proxyInfo.split("\\|")[3], proxyInfo.split("\\|")[4], userInfo.getTenantId(), userInfo.getOffset());
				logger.debug("setProxyUserInfo buJaeId:" + buJaeId + "proxyInfo:" + proxyInfo);
			}
		}

		logger.debug("saveBujae ended");
		return result;
	}
	/**
	 * 관리자페이지 > 전자결재 > 부재자 설정 관리 > 부재자 지정 호출 Method
	 */
	@RequestMapping(value = "/admin/ezApprovalG/selectPerson.do", method = RequestMethod.GET)
	public String selectPerson(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("selectPerson started");

		userInfo = commonUtil.userInfo(loginCookie);
		// String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		String type = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(request.getParameter("type")));
		String selectedCompanyID = request.getParameter("selectedCompanyID");
		String uploadPortalPath = commonUtil.getUploadPath("upload_portal.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		model.addAttribute("type", type);
		model.addAttribute("selectedCompanyID", selectedCompanyID);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("uploadPortalPath", uploadPortalPath);

		logger.debug("selectPerson ended");
		return "/admin/ezApprovalG/apprGSelectPerson";
	}
	
	/**
	 * 관리자페이지 > 전자결재 > 부재자 설정 관리 > 대리 결재자 지정 호출 Method
	 */
	@RequestMapping(value = "/admin/ezApprovalG/DselectPerson.do", method = RequestMethod.GET)
	public String DselectPerson(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("selectPerson started");

		userInfo = commonUtil.userInfo(loginCookie);
		// String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		String type = request.getParameter("type");
		String buJaeId = request.getParameter("buJaeId");
		String buJaedeptid = request.getParameter("buJaedeptid");
		
		String uploadPortalPath = commonUtil.getUploadPath("upload_portal.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		/* 2020-10-22 홍승비 - 부재자의 겸직부서 ID로 찾은 해당 회사의 ID를 전달 */
		//String buJaeCompanyID = ezOrganService.getPhysicalDeliveryOfficeName(buJaeId, "PHYSICALDELIVERYOFFICENAME", userInfo.getTenantId());
		String buJaeCompanyID = ezOrganService.getPropertyValueForDept("EXTENSIONATTRIBUTE2", buJaedeptid, userInfo.getTenantId());
		
		logger.debug("***companyID*** : " + buJaeCompanyID);
		
		model.addAttribute("buJaeId", buJaeId);
		model.addAttribute("buJaedeptid",buJaedeptid);
		model.addAttribute("buJaeCompanyID",buJaeCompanyID);
		model.addAttribute("type", type);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("uploadPortalPath", uploadPortalPath);

		logger.debug("selectPerson ended");
		return "/admin/ezApprovalG/apprGDSelectPerson";
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/checkSubstitute.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> checkSubstitute(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Locale locale, HttpServletRequest request) throws Exception{
		logger.debug("adminBujae started");

		userInfo = commonUtil.userInfo(loginCookie);
		String userID = "";
		String deptID = "";
		String startDate = "";
		String endDate = "";
		String bReason = "";
		String textName = "";
		String proxyUserID = "";
		String proxyDeptID = "";
		String proxyUserName = "";
		String textProxyName = "";
		
		String buJaeId = request.getParameter("buJaeId");
		
		String result = ezOrganService.getPropertyValue(buJaeId, "extensionAttribute5", userInfo.getTenantId());
		String cDate = "";
		String cTime = "";
		if (result != null && !result.equals("")) {
			String[] info = result.split(":");
			
			userID = info[0];
			textName = ezOrganService.getPropertyValue(info[0], "displayname", userInfo.getTenantId());
			deptID = info[2];
			startDate = info[3] + ":" + info[4];
			endDate = info[5] + ":" + info[6];
			
			if (info.length > 7) {
				bReason = info[7];
			}

			/*
			logger.debug("userID : " + userID);
			logger.debug("textName : " + textName);
			logger.debug("deptID : " + deptID);
			logger.debug("startDate : " + startDate);
			logger.debug("endDate : " + endDate);
			logger.debug("bReason : " + bReason);
			*/
			
		} else {
			cDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false);
			cTime = cDate.split(" ")[1].substring(0, 2);
			
			cDate = cDate.substring(0, 10);
			startDate = cDate + " " + cTime + ":00:00";
			
			cDate = cDate.substring(0, 10);
			endDate = cDate + " " + Integer.toString((Integer.parseInt(cTime) + 1)) + ":00:00";
		}

		String rollInfo = ezApprovalGAdminService.getExAttribute(buJaeId, userInfo.getTenantId());
		OrganProxyVO proxyInfo = ezOrganService.getProxyInfo(buJaeId, userInfo.getTenantId(), userInfo.getOffset());
		String subalsin = ezOrganService.getPropertyValue(buJaeId, "extensionAttribute1", userInfo.getTenantId());
		boolean subalsinFlag;
		if(subalsin.toLowerCase().indexOf("a=1;")>-1){
			subalsinFlag = true;
		}else{
			subalsinFlag = false;
		}
		
		boolean bReasonFlag;
		if(bReason != null && !bReason.equals("")){
			bReasonFlag = true;
		}else{
			bReasonFlag = false;
		}
		
		if (rollInfo != null && rollInfo.toLowerCase().indexOf("a=1;") > -1 && proxyInfo != null) {
			result = ezOrganService.getProxyUserInfo(buJaeId, userInfo.getTenantId(), userInfo.getOffset());
			Document xmlDom = commonUtil.convertStringToDocument(result);
			
			if (xmlDom.getElementsByTagName("PROXYUSERID").getLength() > 0) {
				proxyUserID = xmlDom.getElementsByTagName("PROXYUSERID").item(0).getTextContent();
				proxyDeptID = xmlDom.getElementsByTagName("PROXYUSERDEPTID").item(0).getTextContent();
				proxyUserName = xmlDom.getElementsByTagName("PROXYUSERNAME").item(0).getTextContent();
				startDate = xmlDom.getElementsByTagName("STARTDATE").item(0).getTextContent();
				endDate = xmlDom.getElementsByTagName("ENDDATE").item(0).getTextContent();
				
				textProxyName = proxyUserName;
			}
		}
		
		if (bReason != null && bReason.trim().equals("")) {
			bReason = egovMessageSource.getMessage("ezPersonal.t35", locale);
		}
		
		List<OrganUserVO> list = new ArrayList<OrganUserVO>();
		OrganUserVO bujaeUserInfo = ezOrganService.getUserInfo(buJaeId, userInfo.getLang(), userInfo.getTenantId());
		list.add(bujaeUserInfo);
		
		list.addAll(ezOrganAdminService.getUserAddJobList(buJaeId, userInfo.getPrimary(), userInfo.getTenantId()));
		
				
		Map<String,Object> mapJson = new HashMap<String,Object>();
		
		mapJson.put("AddJobList",list);
		mapJson.put("proxyUserID",proxyUserID);
		mapJson.put("proxyDeptID",proxyDeptID);
		mapJson.put("textProxyName",textProxyName);
		mapJson.put("deptID",deptID);
		mapJson.put("textName",textName);
		mapJson.put("startDate",startDate);
		mapJson.put("endDate",endDate);
		mapJson.put("userID",userID);
		mapJson.put("subalsinFlag", subalsinFlag);
		mapJson.put("bReasonFlag", bReasonFlag);
		mapJson.put("bReason", bReason);

		logger.debug("manageBujae ended");
		return mapJson;
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/aprDeptName.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String aprDeptName(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("aprDeptName started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		
		logger.debug("aprDeptName ended");
		return "/admin/ezApprovalG/apprGaprDeptName";
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/docNumZeroCnt.do", method = RequestMethod.GET)
	public String docNumZeroCnt(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("docNumZeroCnt started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		model.addAttribute("approvalFlag", approvalFlag);
		
		logger.debug("docNumZeroCnt ended");
		return "/admin/ezApprovalG/apprGDocNumZeroCnt";
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/getDocNumZeroCnt.do", method = RequestMethod.POST)
	@ResponseBody
	public String getDocNumZeroCnt(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getDocNumZeroCnt started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		
		String rtnVal = ezApprovalGService.getDocNumZeroCnt(companyID, userInfo.getTenantId());
		
		logger.debug("getDocNumZeroCnt ended");
		return rtnVal;
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/setDocNumZeroCnt.do", method = RequestMethod.POST)
	@ResponseBody
	public String setDocNumZeroCnt(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setDocNumZeroCnt started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		String docNumCnt = request.getParameter("docNumCnt");
		
		String rtnVal = ezApprovalGService.setDocNumZeroCnt(docNumCnt, companyID, userInfo.getTenantId());
		
		logger.debug("setDocNumZeroCnt ended | result = " + rtnVal);
		return rtnVal;
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/enforceSihangSeal.do", method = RequestMethod.GET)
	public String enforceSihangSeal(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("enforceSihangSeal started");

		userInfo = commonUtil.userInfo(loginCookie);

		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);

		logger.debug("enforceSihangSeal ended");
		return "/admin/ezApprovalG/apprGManageEnforceSihangSeal";
	}

	/**
	 * 전자결재G관리 원문공개문서함 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/openGovForDoc.do", method = RequestMethod.GET)
	public String openGovForDoc(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("openGovForDoc started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());

		String startDateTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		String type = request.getParameter("type");
		type = (type == null || type.isEmpty()) ? "admin" : type;

		if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("k=1") && !userInfo.getRollInfo().contains("q=1")) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();

		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (userInfo.getRollInfo().contains("c=1") || (userInfo.getRollInfo().contains("k=1") && vo.getCn().equals(userInfo.getCompanyID()))) {
				resultList.add(vo);
			}
		}

		model.addAttribute("startDateTime", startDateTime);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("list", resultList);
		model.addAttribute("type", type);

		logger.debug("openGovForDoc started.");

		return "admin/ezApprovalG/apprGOpenGovForDoc";
	}

	/**
	 * 전자결재G관리 원문공개문서함 문서목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatSearchDocListForOpenGov.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getStatSearchDocLlistForOpenGov(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getStatSearchDocLlistForOpenGov started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docNumber = request.getParameter("docNumber");
		String docTitle = request.getParameter("docTitle");
		String drafter = request.getParameter("drafter");

		String draftFromYear = request.getParameter("draftFromYear");
		String draftFromMonth = request.getParameter("draftFromMonth");
		String draftFromDay = request.getParameter("draftFromDay");

        @SuppressWarnings("unused")
		String draftFrom = "";

        if (draftFromYear != null && !draftFromYear.equals("")) {
            draftFrom = draftFromYear + "-" + draftFromMonth + "-" + draftFromDay;
        }
        String draftToYear = request.getParameter("draftToYear");
        String draftToMonth = request.getParameter("draftToMonth");
        String draftToDay = request.getParameter("draftToDay");

        @SuppressWarnings("unused")
		String draftTo = "";

        if (draftToYear != null && !draftToYear.equals("")) {
            draftTo = draftToYear + "-" + draftToMonth + "-" + draftToDay;
        }

        String apprFromYear = request.getParameter("apprFromYear");
        String apprFromMonth = request.getParameter("apprFromMonth");
        String apprFromDay = request.getParameter("apprFromDay");

        @SuppressWarnings("unused")
		String aprFrom = "";

        if (apprFromYear != null && !apprFromYear.equals("")) {
            aprFrom = apprFromYear + "-" + apprFromMonth + "-" + apprFromDay;
        }

        String apprToYear = request.getParameter("apprToYear");
        String apprToMonth = request.getParameter("apprToMonth");
        String apprToDay = request.getParameter("apprToDay");
        @SuppressWarnings("unused")
		String aprTo = "";

        if (apprToYear != null && !apprToYear.equals("")) {
            aprTo = apprToYear + "-" + apprToMonth + "-" + apprToDay;
        }

		String formID = request.getParameter("formID");
		String formName = request.getParameter("formName");
		String draftDeptName = request.getParameter("deptName1");
        String pageNum = request.getParameter("pageNum");
        String pageSize = request.getParameter("pageSize");
        String docState = request.getParameter("docState");

        String subQuery = request.getParameter("subQuery");
        String orderCell = request.getParameter("orderCell");
        String orderOption = request.getParameter("orderOption");
        String approvUser = request.getParameter("approvUser");
        String companyID = request.getParameter("companyID");
        String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

        String result = "";
        result = ezApprovalGService.getSearchDocListForOpenGov("ADMIN", "", subQuery, docNumber, docTitle, drafter, formID, formName, draftFromYear, draftFromMonth, draftFromDay,
                draftToYear, draftToMonth, draftToDay, apprFromYear, apprFromMonth, apprFromDay, apprToYear, apprToMonth, apprToDay, "", "", "", "", "", "",
                draftDeptName, docState, "", pageSize, pageNum, orderCell, orderOption, "", companyID, userInfo.getLang(), approvUser, userInfo.getTenantId(), userInfo.getOffset(), approvalFlag, "", userInfo.getLocale());

        logger.debug("getStatSearchDocLlistForOpenGov ended.");

        return result;
    }

	/**
	 * 원문공개 재전송
	 */
	@RequestMapping(value = "/admin/ezApprovalG/resendOpenGov.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public void resendOpenGov(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("resendOpenGov started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String resendStartDate = request.getParameter("resendStartDate");
		String resendEndDate = request.getParameter("resendEndDate");
		
		String resendStartTime = resendStartDate + " 00:00:01";
		String resendEndTime = resendEndDate + " 23:59:59";
		
		logger.debug("resend period : " + resendStartDate + " ~ " + resendEndDate);
		ezApprovalGAdminService.resendOpenGov(resendStartTime, resendEndTime, userInfo.getTenantId(), userInfo.getCompanyID());
		
		logger.debug("resendOpenGov ended.");
	}

	/**
	 * 원문공개 수정이력 페이지
	 */
	@RequestMapping(value = "/admin/ezApprovalG/modifyOpenGovHistory.do", method = RequestMethod.GET)
	public String modifyOpenGovHistory() {
		return "admin/ezApprovalG/apprGModifyOpenGovHistory";
	}

	/**
	 * 원문공개 수정이력 내역
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getModifyOpenGovHistory.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getModifyOpenGovHistory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getModifyOpenGovHistory started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");

		String result = ezApprovalGAdminService.getModifyOpenGovHistory(docID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getOffset());

		logger.debug("getModifyOpenGovHistory ended.");

		return result;
	}

	@RequestMapping(value = "/admin/ezApprovalG/getModifyOpenGovHistoryReason.do", produces = "text/html;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getModifyOpenGovHistoryReason(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model)
			throws Exception {
		logger.debug("getModifyOpenGovHistoryReason started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String sn = request.getParameter("sn");

		String result = ezApprovalGAdminService.getModifyOpenGovHistoryReason(docID, sn, userInfo.getTenantId(), userInfo.getCompanyID());

		logger.debug("getModifyOpenGovHistoryReason ended.");

		return result;
	}
	
	/**
	 * 전자결재G관리 첨부파일 개수제한 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/manageAttachLimit.do", method = RequestMethod.GET)
	public String manageAttachLimit(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("manageAttachLimit started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		// 전체관리자, 회사관리자만 접근 가능
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		int apprAttachLimitMax = 100; // 첨부파일 개수제한 default 최대값은 100개
		String apprAttachCntLimitMax = ezCommonService.getTenantConfig("ApprAttachCntLimitMax", userInfo.getTenantId());
		if (apprAttachCntLimitMax != null && !apprAttachCntLimitMax.equals("")) {
			apprAttachLimitMax = Integer.parseInt(apprAttachCntLimitMax);
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		model.addAttribute("apprAttachLimitMax", apprAttachLimitMax);
		
		logger.debug("manageAttachLimit ended.");
		return "/admin/ezApprovalG/apprGManageAttachLimit";
	}
	
	/**
	 * 전자결재G관리 첨부파일 개수제한 설정값 가져오기 (GET)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getAttachLimit.do", method = RequestMethod.GET)
	@ResponseBody
	public int getAttachLimit(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getAttachLimit started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		
		int result = ezApprovalGAdminService.getAttachLimit(companyID, userInfo.getTenantId());
		
		logger.debug("getAttachLimit ended");
		return result;
	}
	
	/**
	 * 전자결재G관리 첨부파일 개수제한 설정 저장 (POST)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/saveAttachLimit.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveAttachLimit(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("saveAttachLimit started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		String attachLimit = request.getParameter("attachLimit");
		
		ezApprovalGAdminService.saveAttachLimit(attachLimit, companyID, userInfo.getTenantId());
		
		logger.debug("saveAttachLimit ended");
	}
	
	/**
	 * 전자결재G관리 첨부파일 개수제한 설정 삭제 (POST)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deleteAttachLimit.do", method = RequestMethod.POST)
	@ResponseBody
	public void deleteAttachLimit(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("deleteAttachLimit started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		
		ezApprovalGAdminService.deleteAttachLimit(companyID, userInfo.getTenantId());
		
		logger.debug("deleteAttachLimit ended");
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/docDirShareManage.do", method = RequestMethod.GET)
	public String docDirShareManage(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("docDirShareManage started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		List<KEDAuthorUserInfo> ownerList = ezApprovalGAdminService.getDocDirOwnerList(userInfo.getCompanyID(), userInfo.getTenantId());
		
		String lang = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());
		model.addAttribute("lang", lang);
		model.addAttribute("ownerList", ownerList);
		
		logger.debug("docDirShareManage ended");
		return "/admin/ezApprovalG/apprGDocDirShareManage";
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/getDocDirShareList.do", method = RequestMethod.POST)
	public String getDocDirShareList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("docDirShareManage started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String ownerId = request.getParameter("ownerId");

		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		List<KEDSharedUserInfo> shareList = ezApprovalGAdminService.getDocDirShareList(ownerId, userInfo.getTenantId());
		
		String lang = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());
		model.addAttribute("lang", lang);
		model.addAttribute("shareList", shareList);
		
		logger.debug("docDirShareManage ended");
		return "/admin/ezApprovalG/apprGDocDirShareList";
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/docDirOwnerInsert.do")
	public String docDirShareInsert(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("docDirOwnerInsert started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String ownerId = request.getParameter("ownerId");
		String ownerName = request.getParameter("ownerName");
		String ownerType = request.getParameter("ownerType");
		String ownerCompanyId = request.getParameter("ownerCompanyId");

		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		model.addAttribute("ownerId", ownerId);
		model.addAttribute("ownerName", ownerName);
		model.addAttribute("ownerType", ownerType);
		model.addAttribute("ownerCompanyId", ownerCompanyId);
		model.addAttribute("companyId", userInfo.getCompanyID());
		model.addAttribute("deptId", userInfo.getDeptID());
		model.addAttribute("primaryLang", primaryLang);
		
		logger.debug("docDirOwnerInsert ended");
		return "/admin/ezApprovalG/apprGDocDirOwnerInsert";
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/selectDocDirOwner.do")
	public String selectDocDirOwner(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("selectDocDirOwner started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		model.addAttribute("companyId", userInfo.getCompanyID());
		model.addAttribute("deptId", userInfo.getDeptID());
		model.addAttribute("primaryLang", primaryLang);
		
		logger.debug("selectDocDirOwner ended");
		return "/admin/ezApprovalG/apprGSelectDocDirOwner";
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/insertDocDirList.do")
	@ResponseBody
	public String insertDocDirList(@CookieValue("loginCookie") String loginCookie, @RequestParam String shareListStr, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("insertDocDirList started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String ownerId = request.getParameter("ownerId");
		String ownerType = request.getParameter("ownerType");
		Gson gson = new Gson();
		List<KEDSharedUserInfo> shareList = gson.fromJson(shareListStr, new TypeToken<List<KEDSharedUserInfo>>(){}.getType());
		
		String result = ezApprovalGAdminService.insertShareDocDir(ownerId, ownerType, shareList, userInfo.getTenantId());

		logger.debug("insertDocDirList ended");
		return result;
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/deleteDocDirOwner.do")
	@ResponseBody
	public String deleteDocDirOwner(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("deleteDocDirOwner started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String ownerId = request.getParameter("ownerId");
		
		String result = ezApprovalGAdminService.deleteShareDocDir(ownerId, userInfo.getTenantId());
		
		logger.debug("deleteDocDirOwner ended");
		return result;
	}
	
	/**
	 * 전자결재G 발송현황 (기본적으로 관리자단 좌측메뉴에서 display:none 처리된 상태)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/sendOut.do", method = RequestMethod.GET)
	public String sendOut(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("sendOut started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String openYear = ezCommonService.getTenantConfig("Site_OpenYear", userInfo.getTenantId());
		String buJaeInfo = "";
		String nowDate = EgovDateUtil.convertDate(org.egovframe.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", "");
		String susinAdmin = "";
		String listType = "1";
		String viewLeftCount = ezCommonService.getTenantConfig("APPROVLEFTCOUNT", userInfo.getTenantId()); 
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String selMenu = "all";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String forceCallBackYN = ezCommonService.getTenantConfig("forceCallBack_YN", userInfo.getTenantId());
		String subQuery = "";
		OrganProxyVO proxyInfo = ezOrganService.getProxyInfo(userInfo.getId(), userInfo.getTenantId(), userInfo.getOffset());
		String userLang = userInfo.getLang();
		String shareUserId = request.getParameter("shareUserId");
		
		// 문서유통 문서 타입
		String relayG_type = ezCommonService.getTenantConfig("UserInfo_RelayG_Type", userInfo.getTenantId()); 
		
		nowDate = nowDate.substring(0, 16);
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		List<PortalTopOtherCompanyAddJobVO> companyList = ezApprovalGService.getAllCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary());
		
		String result = ezOrganService.getPropertyList(userInfo.getId(), "extensionAttribute4;extensionAttribute5", userInfo.getPrimary(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(result);
		
		String userRealDeptId = ezOrganService.getUserOrgDeptId(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		if (userInfo.getDeptID().equals(userRealDeptId)) {
			buJaeInfo = doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
		} else {
			buJaeInfo = ezOrganService.getAddJobProxy(userInfo.getId(), userInfo.getDeptID(), userInfo.getTenantId());
		}
		
		if (shareUserId != null && !shareUserId.equals("")) {
			userRealDeptId = ezOrganService.getUserOrgDeptId(shareUserId, userInfo.getTenantId(), userInfo.getCompanyID());
			userInfo.setId(shareUserId);
			userInfo.setDeptID(userRealDeptId);
			model.addAttribute("shareUser", "shareUser");
		}
		
		model.addAttribute("SubQuery", subQuery);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("viewLeftCount", viewLeftCount);
		model.addAttribute("buJaeInfo", buJaeInfo);
		model.addAttribute("nowDate", nowDate);
		model.addAttribute("selMenu", selMenu);
		model.addAttribute("openYear", openYear);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("listType", commonUtil.stripScriptTags(listType));
		model.addAttribute("proxyInfo", proxyInfo);
		model.addAttribute("forceCallBackYN", forceCallBackYN);
		model.addAttribute("relayG_type", relayG_type);
		model.addAttribute("nowDateUTC", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		model.addAttribute("companyList", companyList);
		model.addAttribute("useHWP", ezCommonService.getTenantConfig("useHWP", userInfo.getTenantId()));
		model.addAttribute("useAdditionalRole", ezCommonService.getTenantConfig("USE_AdditionalROle", userInfo.getTenantId()));
		model.addAttribute("userLang", userLang);
		model.addAttribute("primary", commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		logger.debug("sendOut ended.");
		
		return "admin/ezApprovalG/apprGSendOut";
	}
	
	/**
	 * 전자결재G 전자결재 발송대장 (발송현황) 표출 Method
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getSendOutDocList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getSendOutDocList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getSendOutDocList started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		String susinManagerFlag = request.getParameter("susinManagerFlag");
		String pageSize = request.getParameter("pageSize");
		String pageNum  = request.getParameter("pageNum");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		//2018-09-28 김보미 - 검색 추가
		String searchQuery = request.getParameter("searchQuery");
		String listType = request.getParameter("listType");
		String searchStatus = request.getParameter("searchStatus");

		String userLang = userInfo.getLang();
		Document domSub = null;
		Map<String, Object> queryMap = new HashMap<>();
		queryMap.put("userLang", userLang);
		
		//2018-09-28 김보미 - 검색 추가
		if (searchQuery != null && searchQuery.length() > 10) {
			String tempQuery = "";
			domSub = commonUtil.convertStringToDocument(searchQuery);
			tempQuery = domSub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
			
			String qOptionDocNo = "";
			String qOptionDocTitle = "";
			String qOptionWriterName = "";
			String qOptionWriterDeptName = "";
			
			if (tempQuery.indexOf("DOCNO;") != -1) {
				qOptionDocNo = domSub.getElementsByTagName("DOCNO").item(0).getTextContent();
			}
			
			if (tempQuery.indexOf("DOCTITLE;") != -1) {
				qOptionDocTitle = domSub.getElementsByTagName("DOCTITLE").item(0).getTextContent();
            }
			
			if (tempQuery.indexOf("WRITERNAME;") != -1) { // 다국어 처리 쿼리단으로 이동
				qOptionWriterName = domSub.getElementsByTagName("WRITERNAME").item(0).getTextContent();
			}
			
			if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) { // 다국어 처리 쿼리단으로 이동
				qOptionWriterDeptName = domSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent();
			}
			
			queryMap.put("qOptionDocNo", qOptionDocNo);
			queryMap.put("qOptionDocTitle", qOptionDocTitle);
			queryMap.put("qOptionWriterName", qOptionWriterName);
			queryMap.put("qOptionWriterDeptName", qOptionWriterDeptName);
			
			String qOptionStartDate1 = "";
			String qOptionStartDate2 = "";
			String qOptionReceivedDate1 = "";
			String qOptionReceivedDate2 = "";

            if (tempQuery.indexOf("APRSTARTDATE;") != -1) {
                if (listType.equals("10")) {
					qOptionReceivedDate1 = commonUtil.getDateStringInUTC(domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), true);
                } else {
					qOptionStartDate1 = commonUtil.getDateStringInUTC(domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), true);
                }
            }
            
            if (tempQuery.indexOf("APRENDDATE;") != -1) {
                if (listType.equals("10")){
					qOptionReceivedDate2 = commonUtil.getDateStringInUTC(domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true);
                } else {
					qOptionStartDate2 = commonUtil.getDateStringInUTC(domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true);
                }
            }
            
			queryMap.put("qOptionStartDate1", qOptionStartDate1);
			queryMap.put("qOptionStartDate2", qOptionStartDate2);
			queryMap.put("qOptionReceivedDate1", qOptionReceivedDate1);
			queryMap.put("qOptionReceivedDate2", qOptionReceivedDate2);
			
			String qOptionSearchStatus = "";
			String qOptionFormId = "";
			String qOptionFormName = "";
			String qOptionKeyword = "";
			String qOptionItemCode = "";
			String qOptionUrgentApproval = "";
            
            if (searchStatus != null && !searchStatus.equals("") && !searchStatus.equals("ALL")) {
				qOptionSearchStatus = searchStatus;
            }
            
            // FORMID 태그로 전달되나 양식ID가 아닌 양식명(FORMNAME) 검색으로 수정됨
            if (tempQuery.indexOf("FORMID;") != -1) {
				qOptionFormName = domSub.getElementsByTagName("FORMID").item(0).getTextContent();
            }
            
            if (tempQuery.indexOf("KAPR;") != -1) {
				qOptionKeyword = domSub.getElementsByTagName("KEYWORD").item(0).getTextContent();
            }
            
            if (tempQuery.indexOf("KEND;") != -1) {
				qOptionKeyword = domSub.getElementsByTagName("KEYWORD").item(0).getTextContent();
            }
            
            if (tempQuery.indexOf("CAPR;") != -1) {
				qOptionItemCode = domSub.getElementsByTagName("itemCODE").item(0).getTextContent();
            }
            
            if (tempQuery.indexOf("CEND;") != -1) {
				qOptionItemCode = domSub.getElementsByTagName("itemCODE").item(0).getTextContent();
            }
            
            if (tempQuery.indexOf("URGENTAPPROVAL;") != -1) {
				qOptionUrgentApproval = domSub.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent();
            }
            
			queryMap.put("qOptionSearchStatus", qOptionSearchStatus);
			queryMap.put("qOptionFormId", qOptionFormId);
			queryMap.put("qOptionFormName", qOptionFormName);
			queryMap.put("qOptionKeyword", qOptionKeyword);
			queryMap.put("qOptionItemCode", qOptionItemCode);
			queryMap.put("qOptionUrgentApproval", qOptionUrgentApproval);
		}
		
		String result = ezApprovalGAdminService.getSendOutDocList(userID, deptID, susinManagerFlag, pageSize, pageNum, orderCell, orderOption, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), queryMap);
		
		logger.debug("getSendOutDocList ended");
		
		return result;
	}
	
	@RequestMapping(value = "admin/ezApprovalG/cabTransfer.do", method = RequestMethod.GET)
	public String cabTransfer(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("cabTransfer started");

		userInfo = commonUtil.aprUserInfo(loginCookie);

		// 2024-06-12 전인하 - 전자결재G > 기록물관리 > 기록물철인계 > 리스트헤더 정보 호출
		String listHeaderTemp = ezApprovalGService.getListHeader("095", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		Document listXML = commonUtil.convertStringToDocument(listHeaderTemp);
		StringBuffer listHeaderString = new StringBuffer();

		int hlength = listXML.getElementsByTagName("NAME").getLength();

		listHeaderString.append("<LISTVIEWDATA>");
		listHeaderString.append("<HEADERS>");

		for (int k = 0; k < hlength; k++) {
			listHeaderString.append("<HEADER>");
			listHeaderString.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			listHeaderString.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			listHeaderString.append("</HEADER>");
		}
		listHeaderString.append("</HEADERS>");
		listHeaderString.append("<ROWS></ROWS></LISTVIEWDATA>");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("listHeaderString", listHeaderString);

		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();

		model.addAttribute("ironListYear", ezApprovalGAdminService.getIronListYear(companyID, tenantID));

		logger.debug("cabTransfer ended");

		return "admin/ezApprovalG/apprGcabTransfer";
	}

	//관리자 전자결재 완료문서 삭제 팝업
	@RequestMapping(value = "/admin/ezApprovalG/statisticsDelDocInfo.do", method = RequestMethod.GET)
	public String officialregister_pop(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("statisticsDelDocInfo started");
		
		String docID = request.getParameter("DocID");
		
		model.addAttribute("docID", docID);
		
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("planguage", userInfo);
		
		logger.debug("statisticsDelDocInfo Controller");
		
		return "/ezStatistics/statisticsDelDocInfo";
	}
	
	/**
	 *add get data title 
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getDelDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getDelDocInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getDelDocInfo started  "+ xmlPara);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String docID = xmlDom.getElementsByTagName("DocID").item(0).getTextContent();
		
		//String	result = ezApprovalGService.getDocInfo("docID", "END", "DELFLAG;SUMMARY", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(),"", "");
		String	result = ezApprovalGService.getDocInfo(docID, "END", "DELFLAG;SUMMARY", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(),"", "");
					
		logger.debug("getDelDocInfo ended " +result);
		
		return result;
	}
	
	/**
	 *add set data title 
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setDelDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setDelDocInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getDelDocInfo started  "+ xmlPara);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String docID   = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent();
		String delFlag = xmlDom.getElementsByTagName("DELFLAG").item(0).getTextContent();
		String delInfo = xmlDom.getElementsByTagName("DELINFO").item(0).getTextContent();
		
		
		String	result = ezApprovalGService.updateDocInfo(docID, userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), delFlag, delInfo);
					
		logger.debug("getDelDocInfo ended " +result);
		
		return result;
	}
	
	/**
	 * 감사 결재선 설정 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/auditApprLineManage.do", method = RequestMethod.GET)
	public Object auditApprLineManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse response, ModelAndView model) throws Exception {
		model.setViewName(ezApprovalGAdminService.auditApprLineManage(loginCookie, request, response, model));
		return model;
	}
	
	/**
	 * 감사 결재선 list 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getAuditApprLineList.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public void getAuditApprLineList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception {
		response.setContentType("application/json;charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		response.getWriter().write(ezApprovalGAdminService.getAuditApprLineList(loginCookie, request, response, model).toString());
	}
	
	/**
	 * 감사결재선관리 등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/auditApprLineManagePop.do", method = RequestMethod.GET)	
	public Object auditApprLineManagePop(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse response, ModelAndView model) throws Exception {
		model.setViewName(ezApprovalGAdminService.auditApprLineManagePop(loginCookie, request, response, model));
		return model;
	}
	
	/**
	 * 감사결재선관리 DB 반영
	 */
	@RequestMapping(value = "/admin/ezApprovalG/auditApprListPrc.do", method = RequestMethod.POST)
	@ResponseBody
	public void auditApprListPrc(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception {
		response.setContentType("application/json;charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		response.getWriter().write(ezApprovalGAdminService.getAuditApprLineListPrc(loginCookie, request, response, model).toString());
	}
	
    @RequestMapping(value = "/admin/ezApprovalG/convertXmltoHtml.do", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> convertXmltoHtml(
            @RequestBody JSONObject codeData) {
        logger.debug("convertXmltoHtml started");
        
        ResponseEntity<String> resEntity = null;
        String resultHtmlCode = "";
        
        try {
        
            String xsltCode = (String) codeData.get("xsltCode");
            String xmlCode = (String) codeData.get("xmlCode");
            
            if(xsltCode.isEmpty() || xmlCode.isEmpty()) {
                throw new Exception("xsltCode or xmlCode is empty");
            }
                
            resultHtmlCode = commonUtil.convertXsltToHtml(xsltCode, xmlCode);
            
            HttpHeaders header = new HttpHeaders();
            header.setContentType(new MediaType("text", "html", StandardCharsets.UTF_8));
            
            resEntity = new ResponseEntity<String>(resultHtmlCode, header, HttpStatus.OK);
        } catch(Exception e) {
            logger.error(e.getMessage(), e);
            resEntity = new ResponseEntity<String>(HttpStatus.CONFLICT);
        }
        
        logger.debug("convertXmltoHtml ended");
        
        return resEntity;
    }

	/* General auditing statistics */	
	@RequestMapping(value = "/admin/ezApprovalG/apprGeneralAuditingStatistics.do", method = RequestMethod.GET)
	public String apprGeneralAuditingStatistics(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("apprGeneralAuditingStatistics started.");		
		LoginVO userInfo  = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());		
		String type = request.getParameter("type");
		type = (type == null || type.isEmpty()) ? "admin" : type;		
		if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("k=1") && !userInfo.getRollInfo().contains("q=1")) {
			return "cmm/error/adminDenied"; 
		}		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			if (userInfo.getRollInfo().contains("c=1") || (userInfo.getRollInfo().contains("k=1") && vo.getCn().equals(userInfo.getCompanyID()))) {
				resultList.add(vo);
			}
		}		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("list", resultList);
		model.addAttribute("type", type);
		model.addAttribute("nowDateUTC", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		model.addAttribute("openYear", ezCommonService.getTenantConfig("Site_OpenYear", userInfo.getTenantId()));
		logger.debug("apprGeneralAuditingStatistics end.");
		return "/admin/ezApprovalG/apprGeneralAuditingStatistics";
	}
	
	/**
	 * 관리자 감사/bilingual 통계 list
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getAuditStatisticsDocList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public void getAuditStatisticsDocList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception {
		response.setContentType("application/json;charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		response.getWriter().write(ezApprovalGAdminService.getAuditStatisticsDocList(loginCookie, request, response, model).toString());
	}

	/**
	 * 2021-02-23 박기범 - 수신자 그룹 일괄등록(엑셀파일)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setGroupWithExcel.do", method = RequestMethod.POST)
	@ResponseBody
	public String setGroupWithExcel(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request) throws Exception {
		logger.debug("setGroupWithExcel started.");

		String ext = request.getParameter("ext");
		String result = "";

		if (ext.equals("xls")){
			result = ezApprovalGAdminService.xlsSetGroupWithExcel(loginCookie, request);
		}else if (ext.equals("xlsx")){
			result = ezApprovalGAdminService.xlsxSetGroupWithExcel(loginCookie, request);
		}else {
			result = "ext out";
		}

		logger.debug("setGroupWithExcel ended.");

		return result;
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/getChaebunDeptList.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getChaebunDeptList(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getChaebunDeptList started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(data);
		String deptID = doc.getDocumentElement().getChildNodes().item(0).getTextContent();
		String companyID = doc.getDocumentElement().getChildNodes().item(1).getTextContent();
		
		String result = ezApprovalGAdminService.getChaebunDeptList(deptID, companyID, userInfo);
		
		logger.debug("getChaebunDeptList ended.");
		return result;
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/setChaebunDeptList.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setChaebunDeptList(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlPara, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("setChaebunDeptList started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		
		String result = ezApprovalGAdminService.setChaebunDeptList(doc, userInfo);
		
		logger.debug("setChaebunDeptList ended.");
		return result;
	}
	
	/**
	 * 2022-12-09 홍승비 - 전자결재G > 생산연도 입력을 받아 현재 년도 기준의 종료예정 기록물철을 내년도로 자동 생성하기 위한 페이지 호출 (자동 생성이지만 사용자의 입력 및 확인 후 동작)
	 */
	@RequestMapping(value = "/admin/ezApprovalG/registerCabinetSemiAutoManage.do", method = RequestMethod.GET)
	public String registerCabinetSemiAutoManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("registerCabinetSemiAutoManage started.");

		LoginVO userInfo  = commonUtil.aprUserInfo(loginCookie);
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		// 생산연도를 전달하여 회계연도 가져오기 (1월 ~ 12월이 아닌 3월 ~ 익년 2월인 경우 대비)
		// 올해 1월 1일 ~ 12월 31일까지를 회계연도로 가지는 경우는 현재 날짜에 -0 (변함없음)
		// 올해 3월 1일 ~ 내년 2월 28/29일까지를 회계연도로 가지는 경우는 현재 날짜에 -2개월 감소 보정
		//    -2개월 감소 보정의 예) 2022년 2월 10일 = -2개월 감소 보정 => 현재 연도 2021년으로 취급 (2021년 12월 10일)
		//    -2개월 감소 보정의 예) 2023년 3월 1일 = -2개월 감소 보정 => 현재 연도 2023년으로 취급 (2023년 1월 1일)
		String nowYear = ezApprovalGService.getAccountingYear(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false), userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		// 회계종료월
		String accountLastMonth = ezApprovalGService.getCode2Name("A30", "003", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		// 회계종료월 값이 이상한 경우(12개월을 초과하는 값이 존재하는 경우)에 대한 예외처리
		int accountLastMonthTemp = Integer.parseInt(accountLastMonth);
		if (accountLastMonthTemp > 12) {
			accountLastMonthTemp = (accountLastMonthTemp % 12); // 12로 나눈 나머지를 월 값으로 계산
		}
		// 상단의 예외처리 후, 기본적인 종료 월 단위 환산 (0 = 12월의 마지막, 2 = 2월의 마지막...)
		if (accountLastMonthTemp == 0) {
			accountLastMonthTemp = 12;
		}
		
		// 회계종료 예정 연도
		int accountYear = Integer.parseInt(nowYear);
		
		// 만약 회계종료월이 12월이 아니라면, 내년도의 2월이 되므로 연도에 + 1 처리
		if (accountLastMonthTemp != 12) {
			accountYear += 1;
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList); // 그룹사 개념 + 회사 선택을 위해 추가
		model.addAttribute("nowYear", nowYear);
		model.addAttribute("accountYear", accountYear);
		model.addAttribute("accountLastMonth", String.valueOf(accountLastMonthTemp));
		
		logger.debug("registerCabinetSemiAutoManage ended.");

		return "/admin/ezApprovalG/apprGRegisterCabinetSemiAutoManage";
	}
	
	/**
	 * 2022-12-09 홍승비 - 전자결재G > 생산연도 입력을 받아 현재 년도 기준의 종료예정 기록물철을 내년도로 자동 생성하는 기능
	 */
	@RequestMapping(value = "/admin/ezApprovalG/registCabinetSemiAutoManual.do", method = RequestMethod.POST)
	@ResponseBody
	public String registCabinetSemiAutoManual(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("registCabinetSemiAutoManual started.");
		
		LoginVO userInfo  = commonUtil.aprUserInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId()); // 현재 사용자가 아닌 시스템 기준으로 기본 언어를 선택
		String regYear = request.getParameter("regYear");
		String companyID = request.getParameter("companyID");
		String retVal = "";
		int successCount = 0;
		
		// 종료연도(기산일 적용된 현재 기준의 연도)와 선택한 회사ID를 조건으로 자동 생성할 기록물철을 찾아서 전달
		String currYear = ezApprovalGService.getAccountingYear(commonUtil.getTodayUTCTime(""), companyID, userInfo.getLang(), userInfo.getTenantId());
		
		List<Map<String, Object>> cabinetList = ezApprovalGAdminService.getCabinetListByExpireYear(currYear, companyID, tenantID);
		
		if (cabinetList.size() > 0) {
			successCount = ezApprovalGAdminService.cloneMultipleCabinets(regYear, cabinetList, primaryLang, companyID, tenantID);
		}
		
		// 일부 기록물철 자동 생성 시 오류가 발생한 경우, 실패한 갯수를 전달
		if (cabinetList.size() != successCount) {
			retVal = "FALSE;" + (cabinetList.size() - successCount);
		}
		else if (cabinetList.size() == successCount && cabinetList.size() != 0) {
			retVal = "TRUE";
		}
		else if (cabinetList.size() == 0) {
			retVal = "EMPTY";
		}
		
		logger.debug("registCabinetSemiAutoManual result : " + retVal);
		logger.debug("registCabinetSemiAutoManual ended.");
		
		return retVal;
	}
	
	/* 2022-12-13 홍승비 - 기산일 적용된 현재 기준의 회계종료 연월 가져오기 (회사ID 파라미터 전달) */
	@RequestMapping(value = "/admin/ezApprovalG/getAccountingYMByCompanyID.do", produces = "text/plain; charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getAccountingYMByCompanyID(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getAccountingYMByCompanyID started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("companyID");

		String result = ezApprovalGService.getAccountingYear(commonUtil.getTodayUTCTime(""), companyID, userInfo.getLang(), userInfo.getTenantId());
		String accountLastMonth = ezApprovalGService.getCode2Name("A30", "003", companyID, userInfo.getLang(), userInfo.getTenantId());
		
		// 회계종료월 값이 이상한 경우(12개월을 초과하는 값이 존재하는 경우)에 대한 예외처리
		int accountLastMonthTemp = Integer.parseInt(accountLastMonth);
		if (accountLastMonthTemp > 12) {
			accountLastMonthTemp = (accountLastMonthTemp % 12); // 12로 나눈 나머지를 월 값으로 계산
		}
		// 상단의 예외처리 후, 기본적인 종료 월 단위 환산 (0 = 12월의 마지막, 2 = 2월의 마지막...)
		if (accountLastMonthTemp == 0) {
			accountLastMonthTemp = 12;
		}
		
		result += (";" + String.valueOf(accountLastMonthTemp)); // 현재 기준의 회계종료 "연;월" 형식으로 반환
		
		logger.debug("getAccountingYMByCompanyID ended, result = " + result);
		
		return result;
	}

	@RequestMapping(value = "/admin/ezApprovalG/getTaskCount.do", method = RequestMethod.GET)
	public String taskAdminDept(@CookieValue("loginCookie") String loginCookie,  HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskAdminDept started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String deptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String title = request.getParameter("title");
		String code = request.getParameter("code");
		String flag = request.getParameter("flag");
		
		try {
			int taskCount = ezApprovalGAdminService.getTaskListCount(deptCode, companyID, userInfo.getTenantId(), title, code, flag);
			model.addAttribute("status", "OK");
			model.addAttribute("taskCount", taskCount);
		} catch (Exception e) {
			model.addAttribute("status", "error");
			logger.error(e.getMessage(), e);
		}
		return "json";
	}

	/**
	 * 전자결재G관리 양식함 이동 페이지
	 */
	@RequestMapping(value = "/admin/ezApprovalG/moveFcontSelect.do", method = RequestMethod.GET)
	public String moveFcontSelect(@CookieValue ("loginCookie") String loginCookie) throws Exception {
		logger.debug("moveFcontSelect started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		logger.debug("moveFcontSelect ended.");

		return "admin/ezApprovalG/apprGMoveFcontSelect";
	}

	/**
	 * 전자결재G관리 양식함 이동 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/contMove.do", method = RequestMethod.POST)
	public String contMove(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("contMove started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		String contID = request.getParameter("contID");
		String selContID = request.getParameter("selContID");
		String parentContID = request.getParameter("parentContID");

		String result = ezApprovalGAdminService.contMove(companyID, contID, selContID, parentContID, userInfo.getTenantId());

		model.addAttribute("result", result);

		logger.debug("contMove ended.");

		return "json";
	}

	/**
	 * 전자결재 관리 양식함 순서조정 페이지
	 */
	@RequestMapping(value = "/admin/ezApprovalG/moveSNFcontSelect.do", method = RequestMethod.GET)
	public String moveSNFcontSelect(@CookieValue ("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("moveSNFcontSelect started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		String contID = request.getParameter("contID");
		String companyID = request.getParameter("companyID");
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		List<ApprGFormVO> contList = ezApprovalGAdminService.getSNFContList(contID,companyID,userInfo.getTenantId());

		model.addAttribute("contList",contList);
		model.addAttribute("userInfo", userInfo);
		logger.debug("moveSNFcontSelect ended.");

		return "admin/ezApprovalG/apprGMoveSNFcontSelect";
	}

	/**
	 * 전자결재 관리 양식함 순서조정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/moveContSN.do", method = RequestMethod.POST)
	@ResponseBody
	public String moveContSN(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("moveContSN started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String contID = request.getParameter("CONTID");
		String groupList = request.getParameter("GROUPLIST");
		String companyID = request.getParameter("COMPANYID");

		String result = ezApprovalGAdminService.moveContSN(contID, groupList, companyID, userInfo.getTenantId());

		logger.debug("moveContSN ended.");

		return result;
	}

	/**
	 * 전자결재G 관리자 > 문서조회
	 */
	
	@RequestMapping(value = "/admin/ezApprovalG/apprGDocListAdminIndex.do", method = RequestMethod.GET)
	public String docListAdminIndex(HttpServletRequest request, Model model, LoginVO userInfo, HttpServletResponse response){
		logger.debug("apprGMain Started");

		int listType = request.getParameter("listType") != null ? Integer.parseInt(request.getParameter("listType")) : 1;
		String selectDeptID = selectDeptID = request.getParameter("selectDeptID") != null ? request.getParameter("selectDeptID") : "";

		model.addAttribute("listType", listType);
		model.addAttribute("selectDeptID", selectDeptID);

		logger.debug("docListAdminIndex ended");

		return "/admin/ezApprovalG/apprGDocListAdminIndex";
	}

	/**
	 * 전자결재G 관리자 > 문서조회 LEFT화면 호출 Method
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGDocListAdminLeft.do", method = RequestMethod.GET)
	public String apprGDocListAdminLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
		logger.debug("apprGDocListAdminLeft Started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String viewLeftCount = ezCommonService.getTenantConfig("APPROVLEFTCOUNT", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String listType = request.getParameter("listType");
		String userSendOut = "";
		String firstContainerID = "";
		String subTitleString = "";
		boolean isSubTitle = false;
		String userCont = "";
		String approvalForDoc = ezCommonService.getTenantConfig("approvalForDoc", userInfo.getTenantId());
		String hideSusin =  ezCommonService.getTenantConfig("hideSusin", userInfo.getTenantId());
		//공유결재문서 추가개발
		String useShareApproval = ezCommonService.getTenantConfig("useShareApproval", userInfo.getTenantId());
		// 한글 웹기안기 사용여부
		String useWebHWP = ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId());
		//원문공개사용여부
		String useOpenGov = config.getProperty("config.useOpenGov");
		String howToSendOffer = ezCommonService.getTenantConfig("howToSendOffer", userInfo.getTenantId());
		// 일괄기안 사용여부
		String useDraftAll = ezCommonService.getTenantConfig("useDraftAll", userInfo.getTenantId());
		
		//부서 문서 조회
		int primaryLang = Integer.parseInt(userInfo.getPrimary());
		String selectDeptID = request.getParameter("selectDeptID");
		String selectDeptName = "";

		OrganDeptVO deptInfo = ezOrganService.getDeptInfo(selectDeptID, userInfo.getPrimary(), userInfo.getTenantId());
		selectDeptName = primaryLang == 1 ? deptInfo.getDisplayName() : deptInfo.getDisplayName2();

		model.addAttribute("useOpenGov", useOpenGov);

		if (listType == null) {
			logger.debug("--> listType is null");
			return "";
		}

		StringBuffer containers = new StringBuffer();

		List<ApprGLeftVO> apprGLeftVOList = ezApprovalGService.getUseContInfo(userInfo, "2");

		//CODELIST 에서 후결 결재선 사용여부에 따른 후결문서함 사용여부
		String whoKyulYN = ezApprovalGService.getWhoKyulYN(userInfo);

		if (apprGLeftVOList.size() > 0) {
			firstContainerID = apprGLeftVOList.get(0).getContainerID();
		}

		for (int k = 0; k < apprGLeftVOList.size(); k++) {
			if (k == 0) {
				containers.append("'" + apprGLeftVOList.get(k).getContainerID() + "'");
			} else {
				containers.append(", '" + apprGLeftVOList.get(k).getContainerID() + "'");
			}
		}

		String sendOutDept = ezApprovalGService.getOptionInfo("A55", "001", userInfo, "CODE");
		String optGamsabu = ezApprovalGService.getOptionInfo("A40", "001", userInfo, "CODE");

		logger.debug("apprGLeft Value : sendOutDept=" + sendOutDept + "optGamsabu=" +optGamsabu);

		if (sendOutDept.toUpperCase().indexOf(userInfo.getDeptID().toUpperCase()) > -1) {
			userSendOut = "YES";
		}

		String infoXML = ezOrganService.getPropertyValue(userInfo.getDeptID(), "extensionAttribute4", userInfo.getTenantId());
		String relayShowFlag = "N";
		// 개인의 심사자 권한도 체크하도록 추가해줌.
		if (infoXML != null && infoXML.equals(config.getProperty("config.companyNum", "")) && userInfo.getRollInfo().contains("i=1")) {
			relayShowFlag = "Y";
		}

		//List<Object> referenceTemp = new ArrayList<Object>();
		//referenceTemp.add(subTitleString);
		//referenceTemp.add(isSubTitle);

		//getUserSubTitle(userInfo, referenceTemp);

		String autoSendOfferFlag = ezCommonService.getTenantConfig("autoSendOfferFlag", userInfo.getTenantId());

		if(approvalFlag.equals("S")) {
			String useApprFormCont = ezCommonService.getTenantConfig("useApprFormCont", userInfo.getTenantId());
			model.addAttribute("useApprFormCont", useApprFormCont);
			if(useApprFormCont != null && useApprFormCont.equals("YES")) {
				List<ApprGFormVO> itemList = ezApprovalGService.getFormContainer(userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getLang(), userInfo.getId());
				model.addAttribute("itemList", itemList);
			}

			String useApprCodeCont = ezCommonService.getTenantConfig("useApprCodeCont", userInfo.getTenantId());
			model.addAttribute("useApprCodeCont", useApprCodeCont);
			if(useApprCodeCont != null && useApprCodeCont.equals("YES")) {
				List<ApprGTaskVO> taskItemList = ezApprovalGService.getCodeContainer(userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getDeptID(), commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()), approvalFlag, userInfo.getLang());
				model.addAttribute("taskItemList", taskItemList);
			}

			userCont = ezApprovalGService.getUserContTree(userInfo.getId(), "ROOT", userInfo.getDeptName(), userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale());

			List<ApprGContInfoVO> apprContInfoVOs2 = ezApprovalGService.getSpecialContTree(userInfo);

			int subContCount = 0;

			for (int k = 0; k < apprContInfoVOs2.size(); k++) {
				if (!apprContInfoVOs2.get(k).getContType().equals("005")) { //심사할 문서만 제외
					subContCount += 1;
				}
			}
			List<KEDSharedUserInfo> deptShareList = ezApprovalGService.getShareList(userInfo.getId(), userInfo.getDeptID(), "D", userInfo.getLang(), userInfo.getTenantId());
			Map<String, List<ApprGFormVO>> shareUsersItemList = new HashMap<String, List<ApprGFormVO>>();
			for (KEDSharedUserInfo kedSharedUserInfo : deptShareList) {
				List<ApprGFormVO> shareUserItemList = ezApprovalGService.getFormContainer(userInfo.getTenantId(), "", kedSharedUserInfo.getShareId(), userInfo.getLang(), userInfo.getId());
				shareUsersItemList.put(kedSharedUserInfo.getShareId(), shareUserItemList);
			}
			List<KEDSharedUserInfo> userShareList = ezApprovalGService.getShareList(userInfo.getId(), userInfo.getDeptID(), "U", userInfo.getLang(), userInfo.getTenantId());

			model.addAttribute("deptShareList", deptShareList);
			model.addAttribute("userShareList", userShareList);
			model.addAttribute("shareUsersItemList", shareUsersItemList);
			model.addAttribute("specialContTreeList", apprContInfoVOs2);
			model.addAttribute("specialContTreeCount", apprContInfoVOs2.size());
			model.addAttribute("subContCount", subContCount);
			model.addAttribute("userCont", userCont);
		} else {
			List<KEDSharedUserInfo> deptShareList = ezApprovalGService.getShareList(userInfo.getId(), userInfo.getDeptID(), "D", userInfo.getLang(), userInfo.getTenantId());
			List<KEDSharedUserInfo> userShareList = ezApprovalGService.getShareList(userInfo.getId(), userInfo.getDeptID(), "U", userInfo.getLang(), userInfo.getTenantId());

			model.addAttribute("deptShareList", deptShareList);
			model.addAttribute("userShareList", userShareList);
		}

		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("apprGLeftVOList", apprGLeftVOList);
		model.addAttribute("listType", commonUtil.stripScriptTags(listType));
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("containers", containers.toString());
		model.addAttribute("viewLeftCount", viewLeftCount);
		//model.addAttribute("subTitleString", referenceTemp.get(0));
		//model.addAttribute("isSubTitle", referenceTemp.get(1));
		model.addAttribute("relayShowFlag", relayShowFlag);
		model.addAttribute("userSendOut", userSendOut);
		model.addAttribute("optGamsabu", optGamsabu);
		model.addAttribute("firstContainerID", firstContainerID);
		model.addAttribute("szRoleInfo", userInfo.getRollInfo());
		model.addAttribute("strLang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("approvalForDoc", approvalForDoc);
		model.addAttribute("hideSusin", hideSusin);
		model.addAttribute("whoKyulYN", whoKyulYN);
		model.addAttribute("useShareApproval", useShareApproval);
		model.addAttribute("useWebHWP", useWebHWP);
		model.addAttribute("autoSendOfferFlag", autoSendOfferFlag); // 전자결재G 미처리문서함 사용여부
		model.addAttribute("howToSendOffer", howToSendOffer);
		model.addAttribute("useDraftAll", useDraftAll);
		model.addAttribute("selectDeptID", selectDeptID);
		model.addAttribute("selectDeptName", selectDeptName);

		logger.debug("apprGDocListAdminLeft Value : listType= " + listType + "containers= " + containers.toString() + "viewLeftCount= " + viewLeftCount);
		logger.debug("apprGDocListAdminLeft Ended");

		return "/admin/ezApprovalG/apprGDocListAdminLeft";
	}

	/*
	 * 전자결재G 관리자 > 문서조회 > 기록물대장 리스트
	 */
	@RequestMapping(value = "/admin/ezApprovalG/cabinetMain.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String cabinetmain(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("cabinetMain Started");

		userInfo = commonUtil.aprUserInfo(loginCookie);

		String sFlag = (request.getParameter("sFlag") != null ? request.getParameter("sFlag") : "");
		String shareDeptId = (request.getParameter("shareDeptId") != null ? request.getParameter("shareDeptId") : "");
		String contType = "END";
		String dirpath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + "doc";
		String deptInfo = "";
		String buJaeInfo = "";
		String susinAdmin = "";
		// OCS 사용 여부
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String userEmail = userInfo.getEmail();
		String use_Editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String openYear = ezCommonService.getTenantConfig("Site_OpenYear", userInfo.getTenantId());

		String useOpenGov = config.getProperty("config.useOpenGov");

		if (useOpenGov != null && useOpenGov.equals("YES")) {
			model.addAttribute("useOpenGov", useOpenGov);
		}

		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}

		String result = ezOrganService.getPropertyList(userInfo.getId(), "extensionAttribute4;extensionAttribute5", userInfo.getPrimary(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(result);

		deptInfo  = doc.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent();
		buJaeInfo = doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent().trim();

		// 2023-05-23 이혜림 - 전자결재G > 기록물대장 미리보기 - 전자결재 미리보기영역 관련 변수 추가
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String previewInfo = "OFF";
		String useAprPreview = ezCommonService.getTenantConfig("useAprPreview", userInfo.getTenantId());

		if (useAprPreview.equalsIgnoreCase("YES")) {
			previewInfo = ezApprovalGService.getApprovConfig(userInfo.getId(), userInfo.getTenantId());
		}

		// 2024-06-07 전인하 - 기록물대장 > 하위부서 문서함 조회
		// 하위부서문서함은 다음과 같은 경우에 표출된다 ; 관리자 권한(전체관리자, 회사관리자, 기록물관리책임자 중 1)이 존재하면서 기록물등록대장, 기록물접수목록, 기록물발송목록, 기록물철등록부일 경우
		String underDeptShowFlag = "FALSE";
//		List<String> needUnderDeptsFlag = new ArrayList<>(Arrays.asList("m01", "m02", "m05", "m06"));
//		if (needUnderDeptsFlag.contains(sFlag) && commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;m")) {
//			underDeptShowFlag = "TRUE";
//		}

		JSONArray underDeptList = new JSONArray();
		if (underDeptShowFlag.equals("TRUE")) {
			List<OrganDeptVO> tempDeptList = ezApprovalGService.getUnderDeptList(userInfo);
			for (int i = 0; i < tempDeptList.size(); i++) {
				JSONObject json = new JSONObject();
				json.put("id", tempDeptList.get(i).getCn());
				json.put("name", commonUtil.cleanValue(tempDeptList.get(i).getDisplayName()));
				underDeptList.put(json);
			}
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("dirpath", dirpath);
		model.addAttribute("deptInfo", deptInfo);
		model.addAttribute("buJaeInfo", buJaeInfo);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("userEmail", userEmail);
		model.addAttribute("use_Editor", use_Editor);
		model.addAttribute("openYear", openYear);
		model.addAttribute("contType", contType);
		model.addAttribute("sFlag", sFlag);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("shareDeptId", shareDeptId);
		model.addAttribute("previewInfo", previewInfo);
		model.addAttribute("useAprPreview", useAprPreview);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("useDraftAll", ezCommonService.getTenantConfig("useDraftAll", userInfo.getTenantId()));
		model.addAttribute("underDeptFlag", underDeptShowFlag);
		model.addAttribute("underDeptList", underDeptList);

		logger.debug("cabinetMain ended");

		return "/admin/ezApprovalG/apprGDocListAdminCabinetMain";
	}

	/*
	 * 전자결재G 관리자 > 결재연동 테스트 페이지
	 */
	@RequestMapping(value = "/admin/ezApprovalG/connTestManage.do", method = RequestMethod.GET)
	public String connTestManage(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		logger.debug("connTestManage started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("connTestManage ended");
		return "admin/ezApprovalG/apprGConnTestManage";
	}

	@RequestMapping(value = "/admin/ezApprovalG/alterCookie.do", method = RequestMethod.POST)
	public String alterCookie(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("alterCookie started");

		String userId = request.getParameter("userId");
		
		String serverName = request.getServerName();
		int tenantId = loginService.getTenantId(serverName);

		// loginVO 생성
		LoginVO paramUserInfo = new LoginVO();
		paramUserInfo.setId(userId);
		paramUserInfo.setTenantId(tenantId);
		paramUserInfo.setDn("NOPASSWORD");

		LoginVO userInfo = loginService.selectUser(paramUserInfo);

		// userId 가 관리자인지 체크
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "NOAUTH";
		}

		// 로그인쿠키 생성
		Cookie[] cookies = request.getCookies();
		boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));

		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (useDbSession || cookie.getName().equalsIgnoreCase("loginCookie")) {
					loginService.deleteSession(cookie.getValue());
				}

				if (!"JSESSIONID".equalsIgnoreCase(cookie.getName())) { // JSESSIONID는 지우지 않음 (이중화 시 JSESSIONID 쿠키를 사용)
					cookie.setMaxAge(0);
					cookie.setPath("/");
					response.addCookie(cookie);
				}
			}
		}

		loginController.createLoginCookie(userId, "", "", tenantId, request, response, userInfo.getDeptID(), userInfo.getCompanyID());

		logger.debug("alterCookie ended");
		return "TRUE";
	}
}
