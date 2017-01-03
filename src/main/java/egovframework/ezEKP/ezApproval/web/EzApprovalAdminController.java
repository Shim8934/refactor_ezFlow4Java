package egovframework.ezEKP.ezApproval.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.coobird.thumbnailator.Thumbnails;

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
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApproval.service.EzApprovalAdminService;
import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocGroupVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocItemVO;
import egovframework.ezEKP.ezApproval.vo.ApprExcelOutVO;
import egovframework.ezEKP.ezApproval.vo.ApprFormContVO;
import egovframework.ezEKP.ezApproval.vo.ApprFormInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprReceiveGroupVO;
import egovframework.ezEKP.ezApproval.vo.ApprSealInfoVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;


/** 
 * @Description [Controller] 전자결재 일반
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.11.30    황윤진         신규작성
 *
 * @see
 */

@Controller
public class EzApprovalAdminController extends EgovFileMngUtil {

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzApprovalAdminService ezApprovalAdminService;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource messageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalAdminController.class);
	
	/**
	 * 전자결재 일반 관리자 메인 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/apprMain.do")
	public String apprMain(Model model, HttpServletRequest request) {
		logger.debug("apprMain started");
		
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isIEBrowser = browser.indexOf("IE") > -1 ? true : false;
		
		model.addAttribute("isIEBrowser", isIEBrowser);
		
		logger.debug("apprMain ended");
		
		return "admin/ezApproval/apprMain";
	}

	/**
	 * 전자결재 일반 관리자 레프트메뉴 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/apprLeft.do")
	public String apprLeft(Model model, HttpServletRequest request) throws Exception {
		logger.debug("apprLeft started");
		
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isIEBrowser = browser.indexOf("IE") > -1 ? true : false;
		
		model.addAttribute("isIEBrowser", isIEBrowser);
		
		logger.debug("apprLeft ended");
		
		return "admin/ezApproval/apprLeft";
	}
	
	/**
	 * 전자결재 일반 관리자 양식등록 메인 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/formAdmin.do")
	public String formAdmin(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("formAdmin started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String multiDataNum = commonUtil.getMultiData(userInfo.getLang());
		String useReform = ezCommonService.getTenantConfig("Usereform", userInfo.getTenantId());
		String docType = ezApprovalAdminService.getDocType("", userInfo);
		StringBuilder companySel = new StringBuilder();
		String[] docs;
		
		if (docType.split("t").length != 0) {
			docs = docType.split("t");
			
			for (int k = 1; k < docs.length; k++) {
				docs[k] = "t" + docs[k].split("<")[0];
				docType = docType.replace(docs[k], messageSource.getMessage("ezApproval." + docs[k], userInfo.getLocale()));
			}
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getLang(), userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("companySel", companySel);
		model.addAttribute("editor", editor);
		model.addAttribute("multiDataNum", multiDataNum);
		model.addAttribute("useReform", useReform);
		model.addAttribute("docType", docType);
		
		logger.debug("formAdmin ended");
		
		return "admin/ezApproval/apprFormAdmin";
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 메인 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/MCont.do")
	public String MCont(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("MCont started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		StringBuilder companySel = new StringBuilder();
		String topID = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "main/warning";
		}
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topID = userInfo.getCompanyID();
		} else {
			topID = "Top";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getLang(), userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
			}
		}
		
		model.addAttribute("topID", topID);
		model.addAttribute("companySel", companySel);
		model.addAttribute("serverName", userInfo.getServerName());
		
		logger.debug("MCont ended");
		
		return "admin/ezApproval/apprMCont";
	}

	/**
	 * 전자결재 일반 관리자 문서함관리 메인화면 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/MgetContinfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MgetContinfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("MgetContinfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("comID");
		String result = ezApprovalAdminService.getContainerInfoManage(deptID, "LIST", companyID, userInfo);
		
		logger.debug("MgetContinfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 문서함명관리 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/MContType.do")
	public String MContType(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		logger.debug("MContType started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		
		logger.debug("MContType ended");
		
		return "admin/ezApproval/apprMContType";
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 문서함명관리 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/MLgetDoctype.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MLgetDoctype(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("MLgetDoctype started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String companyID = request.getParameter("comID");
		String result = ezApprovalAdminService.getContTypeInfo("LIST", companyID, userInfo);
		
		logger.debug("MLgetDoctype ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 문서함명관리 추가 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/insertContType.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String insertContType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("insertContType started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docTypeName = request.getParameter("docTypeName");
		String docTypeName2 = request.getParameter("docTypeName2");
		String companyID = request.getParameter("comID");
		String result = ezApprovalAdminService.insertContainerType(docTypeName, docTypeName2, companyID, userInfo.getTenantId());
		
		logger.debug("insertContType ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 문서함명관리 삭제 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/deleteContType.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String deleteContType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("deleteContType started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String codeID = request.getParameter("docTypeID");
		String companyID = request.getParameter("comID");
		String result = ezApprovalAdminService.deleteContainerType(codeID, companyID, userInfo.getTenantId());
		
		logger.debug("deleteContType ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 문서상태등록 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/MinsContType.do")
	public String MinsContType() {
		logger.debug("MinsContType started");
		logger.debug("MinsContType ended");
		
		return "admin/ezApproval/apprMinsContType";
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 문서상태등록 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/getContDocType.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getContDocType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getContDocType started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String companyID = request.getParameter("comID");
		String result = ezApprovalAdminService.getContainerToDocStateInfo(companyID, userInfo.getLocale(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("getContDocType ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 문서상태등록 추가,삭제 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/updateContDoctype.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String updateContDoctype(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlPara) throws Exception {
		logger.debug("updateContDoctype started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String result = ezApprovalAdminService.updateContainerToDocStateInfo(doc, companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("updateContDoctype ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 추가,수정 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/MinsContMain.do")
	public String MinsContMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("MinsContMain started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String title = "";
		String tCheck = request.getParameter("TCheck");
		
		if (tCheck != null && tCheck.equals("DContIns")) {
			title = messageSource.getMessage("ezApproval.t740", userInfo.getLocale());
		} else {
			title = messageSource.getMessage("ezApproval.t741", userInfo.getLocale());
		}
		
		model.addAttribute("title", title);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("serverName", userInfo.getServerName());
		
		logger.debug("MinsContMain ended");
		
		return "admin/ezApproval/apprMinsContMain";
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 추가,수정 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/MgetContGroup.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MgetContGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("MgetContGroup started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String contID = request.getParameter("contID");
		String companyID = request.getParameter("comID");
		String result = ezApprovalAdminService.getContainerUseDeptInfo(contID, companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("MgetContGroup ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 추가 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/MinsCont.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MinsCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("MinsCont started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String companyID = request.getParameter("comID");
		String contType = request.getParameter("contType");
		String contOwnDeptID = request.getParameter("contOwnDeptID");
		String selUseDept = request.getParameter("selUseDept");
		String result = ezApprovalAdminService.insertContainer(contType, contOwnDeptID, selUseDept, companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("MinsCont ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 수정 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/MupdateCont.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MupdateCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("MupdateCont started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String companyID = request.getParameter("comID");
		String contID = request.getParameter("contID");
		String contType = request.getParameter("contType");
		String contOwnDeptID = request.getParameter("contOwnDeptID");
		String selUseDept = request.getParameter("selUseDept");
		String result = ezApprovalAdminService.updateContainer(contType, contID, contOwnDeptID, selUseDept, companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("MupdateCont ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 삭제 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/MdelCont.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MdelCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("MdelCont started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String companyID = request.getParameter("comID");
		String contID = request.getParameter("contID"); 
		String result = ezApprovalAdminService.deleteContainer(contID, companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("MdelCont ended");
		
		return result;
	}

	/**
	 * 전자결재 일반 관리자 문서함관리 특수문서함 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/manageSpecialCont.do")
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
		
		return "admin/ezApproval/apprManageSpecialCont";
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 특수문서함 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/specialContListInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String specialContListInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("specialContListInfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalAdminService.getSpecialContList(deptID, companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("specialContListInfo ended");
	
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 특수문서함 추가 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/manageSpecialContInfo.do")
	public String manageSpecialContInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("manageSpecialContInfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String contType = request.getParameter("contType");
		String sn = request.getParameter("sn");
		String companyID = request.getParameter("companyID");
		
		String codeXML = ezApprovalAdminService.getSpecialContCode(contType, companyID, userInfo.getLang(), userInfo.getTenantId());
		String infoXML = ezApprovalAdminService.getSpecialContInfo(deptID, contType, sn, companyID, userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("deptID", deptID);
		model.addAttribute("contType", contType);
		model.addAttribute("sn", sn);
		model.addAttribute("companyID", companyID);
		model.addAttribute("codeXML", codeXML);
		model.addAttribute("infoXML", infoXML);
		
		logger.debug("manageSpecialContInfo ended");
		
		return "admin/ezApproval/apprManageSpecialContInfo";
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 특수문서함 추가 양식함리스트 양식리스트 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/MgetForm.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MgetForm(@CookieValue("loginCookie") String loginCookie, ApprFormInfoVO apprFormInfoVO) throws Exception {
		logger.debug("MgetForm started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprFormInfoVO.setTenantID(userInfo.getTenantId());
		apprFormInfoVO.setLang(userInfo.getLang());
		
		String result = ezApprovalAdminService.getFormInfo(apprFormInfoVO);
		
		logger.debug("MgetForm ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 확인창 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/ezAprAlert.do")
	public String aprAlert() {
		logger.debug("aprAlert started");
		logger.debug("aprAlert ended");
		
		return "admin/ezApproval/apprAprAlert";
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 특수문서함 추가/수정 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/specialContAdd.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String specialContAdd(@CookieValue("loginCookie") String loginCookie, ApprContInfoVO apprContInfoVO) throws Exception {
		logger.debug("specialContAdd started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalAdminService.addSpecialCont(apprContInfoVO, userInfo.getTenantId());
		
		logger.debug("specialContAdd ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 의견창 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/ezAprOpinion.do")
	public String aprOpinion(HttpServletRequest request, Model model) {
		logger.debug("aprOpinion started");
		
		String type = request.getParameter("type");
		
		model.addAttribute("type", type);
		
		logger.debug("aprOpinion ended");
		
		return "admin/ezApproval/apprAprOpinion";
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 특수문서함 삭제 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/specialContDelete.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String specialContDelete(@CookieValue("loginCookie") String loginCookie, ApprContInfoVO apprContInfoVO) throws Exception {
		logger.debug("specialContDelete started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalAdminService.delSpecialCont(apprContInfoVO, userInfo.getTenantId());
		
		logger.debug("specialContDelete ended");
		
		return result;
	}

	/**
	 * 전자결재 일반 관리자 문서함관리 특수문서함 위/아래 순서바꾸기 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/specialContChangeSN.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String specialContChangeSN(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("specialContChangeSN started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String sContType = request.getParameter("contType");
		String sSn = request.getParameter("sn");
		String tContType = request.getParameter("contType2");
		String tSn = request.getParameter("sn2");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalAdminService.changeSpecialContSN(deptID, sContType, sSn, tContType, tSn, companyID, userInfo.getTenantId());
		
		logger.debug("specialContChangeSN ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서이동 메인화면 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/moveContainer.do")
	public String moveContainer(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("moveContainer started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		StringBuilder companySel = new StringBuilder();
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "main/warning";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getLang(), userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
			}
		}
		
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("companySel", companySel);
		
		logger.debug("moveContainer ended");
		
		return "admin/ezApproval/apprMoveContainer";
	}

	/**
	 * 전자결재 일반 관리자 문서이동 부서선택 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/organ.do")
	public String organ(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("organ started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("serverName", userInfo.getServerName());
		
		logger.debug("organ ended");
		
		return "admin/ezApproval/apprOrgan";
	}
	
	/**
	 * 전자결재 일반 관리자 문서이동 문서함명 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/MgetDocList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MgetDocList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("MgetDocList started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String contID = request.getParameter("contID");
		int pageNum = Integer.parseInt(request.getParameter("pageNum"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));
		String companyID = request.getParameter("companyID");
		StringBuilder subQuery = new StringBuilder();
		
		if (request.getParameter("docNO") != null && !request.getParameter("docNO").equals("")) {
			subQuery.append(" A.docNO LIKE '%" + request.getParameter("docNO") + "%' ");
		}
		
		if (request.getParameter("docTitle") != null && !request.getParameter("docTitle").equals("")) {
			if (!subQuery.toString().equals("")) {
				subQuery.append(" AND ");
			}
			
			subQuery.append(" A.docTitle LIKE '%" + request.getParameter("docTitle") + "%' ");
		}
		
		if (request.getParameter("drafter") != null && !request.getParameter("drafter").equals("")) {
			if (!subQuery.toString().equals("")) {
				subQuery.append(" AND ");
			}
			
			subQuery.append(" A.writerName LIKE '%" + request.getParameter("drafter") + "%' OR A.writerName2 LIKE '%" + request.getParameter("drafter") + "%')");
		}
		
		if (request.getParameter("draftFrom") != null && !request.getParameter("draftFrom").equals("") && request.getParameter("draftTo") != null && !request.getParameter("draftTo").equals("")) {
			if (!subQuery.toString().equals("")) {
				subQuery.append(" AND ");
			}
			
			subQuery.append(" A.StartDate >= '" + commonUtil.getDateStringInUTC(request.getParameter("draftFrom"), userInfo.getOffset(), true) + "' AND A.StartDate <= '" + commonUtil.getDateStringInUTC(request.getParameter("draftTo"), userInfo.getOffset(), true) + "' )");
		}
		
		if (request.getParameter("aprFrom") != null && !request.getParameter("aprFrom").equals("") && request.getParameter("aprTo") != null && !request.getParameter("aprTo").equals("")) {
			if (!subQuery.toString().equals("")) {
				subQuery.append(" AND ");
			}
			
			subQuery.append(" A.EndDate >= '" + commonUtil.getDateStringInUTC(request.getParameter("aprFrom"), userInfo.getOffset(), true) + "' AND A.EndDate <= '" + commonUtil.getDateStringInUTC(request.getParameter("aprTo"), userInfo.getOffset(), true) + "' )");
		}
		
		if (request.getParameter("deptName") != null && !request.getParameter("deptName").equals("")) {
			if (!subQuery.toString().equals("")) {
				subQuery.append(" AND ");
			}
			
			subQuery.append(" A.writerDeptName LIKE '%" + request.getParameter("deptName") + "%' OR A.writerDeptName2 LIKE '%" + request.getParameter("deptName") + "%')");
		}
		
		String result = ezApprovalAdminService.getContDocList(contID, "", subQuery, pageSize, pageNum, "", "", companyID, userInfo);
		
		logger.debug("MgetDocList ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서이동 문서함명 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/MgetDeptUseDocType.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MgetDeptUseDocType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("MgetDeptUseDocType started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalAdminService.getContainerInfoManage(deptID, "XML", companyID, userInfo);
		
		logger.debug("MgetDeptUseDocType ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서이동 검색 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/ezStatisticsSearch.do")
	public String statisticsSearch(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("statisticsSearch started");
		
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
		
		logger.debug("statisticsSearch ended");
		
		return "admin/ezApproval/apprStatisticsSearch";
	}
	
	/**
	 * 전자결재 일반 관리자 문서이동 검색 양식명 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/getFormCont.do")
	public String getFormCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getFormCont started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docFileType = request.getParameter("fileType");
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String docType = ezApprovalAdminService.getDocType("", userInfo);
		String[] docs;
		
		if (docType.split("t").length != 0) {
			docs = docType.split("t");
			
			for (int k = 1; k < docs.length; k++) {
				docs[k] = "t" + docs[k].split("<")[0];
				docType = docType.replace(docs[k], messageSource.getMessage("ezApproval." + docs[k], userInfo.getLocale()));
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("docFileType", docFileType);
		model.addAttribute("serverName", userInfo.getServerName());
		
		logger.debug("getFormCont ended");
		
		return "admin/ezApproval/apprGetFormCont";
	}
	
	/**
	 * 전자결재 일반 관리자 문서이동 확인 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/moveContainer.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String moveContainer(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlPara) throws Exception {
		logger.debug("moveContainer started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalAdminService.moveDocList(xmlPara, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("moveContainer ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서삭제 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/docDelete.do")
	public String docDelete (@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("docDelete started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		StringBuilder companySel = new StringBuilder();
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "main/warning";
		}
		
		String periodNode = ezApprovalAdminService.getKeepType("", userInfo);
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getLang(), userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
			}
		}
		
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("companySel", companySel);
		model.addAttribute("periodNode", periodNode);
		
		logger.debug("docDelete ended");
		
		return "admin/ezApproval/apprDocDelete";
	}
	
	/**
	 * 전자결재 일반 관리자 문서삭제 문서리스트 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/SPeriodDocList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String SPeriodDocList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("MgetDocList started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String contID = request.getParameter("contID");
		String storagePeriod = request.getParameter("period");
		int pageNum = Integer.parseInt(request.getParameter("pageNum"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));
		String companyID = request.getParameter("companyID");
		StringBuilder subQuery = new StringBuilder();
		
		if (request.getParameter("docNO") != null && !request.getParameter("docNO").equals("")) {
			subQuery.append(" A.docNO LIKE '%" + request.getParameter("docNO") + "%' ");
		}
		
		if (request.getParameter("docTitle") != null && !request.getParameter("docTitle").equals("")) {
			if (!subQuery.toString().equals("")) {
				subQuery.append(" AND ");
			}
			
			subQuery.append(" A.docTitle LIKE '%" + request.getParameter("docTitle") + "%' ");
		}
		
		if (request.getParameter("drafter") != null && !request.getParameter("drafter").equals("")) {
			if (!subQuery.toString().equals("")) {
				subQuery.append(" AND ");
			}
			
			subQuery.append(" A.writerName LIKE '%" + request.getParameter("drafter") + "%' OR A.writerName2 LIKE '%" + request.getParameter("drafter") + "%')");
		}
		
		if (request.getParameter("draftFrom") != null && !request.getParameter("draftFrom").equals("") && request.getParameter("draftTo") != null && !request.getParameter("draftTo").equals("")) {
			if (!subQuery.toString().equals("")) {
				subQuery.append(" AND ");
			}
			
			subQuery.append(" A.StartDate >= '" + commonUtil.getDateStringInUTC(request.getParameter("draftFrom"), userInfo.getOffset(), true) + "' AND A.StartDate <= '" + commonUtil.getDateStringInUTC(request.getParameter("draftTo"), userInfo.getOffset(), true) + "' )");
		}
		
		if (request.getParameter("aprFrom") != null && !request.getParameter("aprFrom").equals("") && request.getParameter("aprTo") != null && !request.getParameter("aprTo").equals("")) {
			if (!subQuery.toString().equals("")) {
				subQuery.append(" AND ");
			}
			
			subQuery.append(" A.EndDate >= '" + commonUtil.getDateStringInUTC(request.getParameter("aprFrom"), userInfo.getOffset(), true) + "' AND A.EndDate <= '" + commonUtil.getDateStringInUTC(request.getParameter("aprTo"), userInfo.getOffset(), true) + "' )");
		}
		
		if (request.getParameter("deptName") != null && !request.getParameter("deptName").equals("")) {
			if (!subQuery.toString().equals("")) {
				subQuery.append(" AND ");
			}
			
			subQuery.append(" A.writerDeptName LIKE '%" + request.getParameter("deptName") + "%' OR A.writerDeptName2 LIKE '%" + request.getParameter("deptName") + "%')");
		}
		
		if (storagePeriod != null && !storagePeriod.equals("")) {
			if (!subQuery.toString().equals("")) {
				subQuery.append(" AND ");
			}
			
			subQuery.append(" TBEXPENDAPRDOCINFO.StoragePeriod LIKE '%" + storagePeriod + "' ");
		}
		
		String result = ezApprovalAdminService.getContDocList(contID, "", subQuery, pageSize, pageNum, "", "", companyID, userInfo);
		
		logger.debug("MgetDocList ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서삭제 삭제 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/delDocList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String delDocList(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlPara) throws Exception {
		logger.debug("delDocList started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalAdminService.deleteDocList(xmlPara, userInfo.getOffset(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("delDocList ended");
		
		return result;
	}

	/**
	 * 전자결재 일반 관리자 수신처 그룹지정 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/receiveGroup.do")
	public String receiveGroup(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("receiveGroup started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		StringBuilder companySel = new StringBuilder();
		String topID = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topID = userInfo.getCompanyID();
		} else {
			topID = "Top";
		}
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "main/warning";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getLang(), userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
			}
		}
		
		model.addAttribute("companySel", companySel);
		model.addAttribute("topID", topID);
		model.addAttribute("serverName", userInfo.getServerName());
		
		logger.debug("receiveGroup ended");
		
		return "admin/ezApproval/apprReceiveGroup";
	}
	
	/**
	 * 전자결재 일반 관리자 수신처 그룹지정 그룹리스트 표출
	 */
	@RequestMapping(value = "admin/ezApproval/getAdminReceivGroup.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getAdminReceivGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getAdminReceivGroup started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String groupID = request.getParameter("groupID");
		String mode = request.getParameter("mode");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalAdminService.getReceiveGroupInfo(groupID, mode, companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("getAdminReceivGroup ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 수신처 그룹지정 서브리스트 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/setGroupSubItemInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setGroupSubItemInfo(@CookieValue("loginCookie") String loginCookie, ApprReceiveGroupVO apprReceiveGroupVO) throws Exception {
		logger.debug("setGroupSubItemInfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprReceiveGroupVO.setTenantID(userInfo.getTenantId());
		
		String result = ezApprovalAdminService.insertReceiveGroupItemInfo(apprReceiveGroupVO);
		
		logger.debug("setGroupSubItemInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 수신처 그룹지정 그룹추가 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/setGroupMainInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setGroupMainInfo(@CookieValue("loginCookie") String loginCookie, ApprReceiveGroupVO apprReceiveGroupVO) throws Exception {
		logger.debug("setGroupMainInfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprReceiveGroupVO.setTenantID(userInfo.getTenantId());
		
		String result = ezApprovalAdminService.insertReceiveGroupInfo(apprReceiveGroupVO);
		
		logger.debug("setGroupMainInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 수신처 그룹지정 그룹이름변경 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/updateGroupMainInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String updateGroupMainInfo(@CookieValue("loginCookie") String loginCookie, ApprReceiveGroupVO apprReceiveGroupVO) throws Exception {
		logger.debug("updateGroupMainInfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprReceiveGroupVO.setTenantID(userInfo.getTenantId());
		
		String result = ezApprovalAdminService.updateGroupMainInfo(apprReceiveGroupVO);
		
		logger.debug("updateGroupMainInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 수신처 그룹지정 그룹삭제 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/deleteGroupMainInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String deleteGroupMainInfo(@CookieValue("loginCookie") String loginCookie, ApprReceiveGroupVO apprReceiveGroupVO) throws Exception {
		logger.debug("deleteGroupMainInfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprReceiveGroupVO.setTenantID(userInfo.getTenantId());
		
		String result = ezApprovalAdminService.deleteGroupMainInfo(apprReceiveGroupVO);
		
		logger.debug("deleteGroupMainInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 수신처 그룹지정 서브그룹삭제 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/deleteGroupSubItemInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String deleteGroupSubItemInfo(@CookieValue("loginCookie") String loginCookie, ApprReceiveGroupVO apprReceiveGroupVO) throws Exception {
		logger.debug("deleteGroupSubItemInfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprReceiveGroupVO.setTenantID(userInfo.getTenantId());
		
		String result = ezApprovalAdminService.deleteGroupSubItemInfo(apprReceiveGroupVO);
		
		logger.debug("deleteGroupSubItemInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 분류코드관리 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/docNumUI.do")
	public String docNumUI(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("docNumUI started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		StringBuilder companySel = new StringBuilder();
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "main/warning";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getLang(), userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
			}
		}
		
		model.addAttribute("companySel", companySel);
		model.addAttribute("serverName", userInfo.getServerName());
		model.addAttribute("primaryStr", userInfo.getPrimary());
		
		logger.debug("docNumUI ended");
		
		return "admin/ezApproval/apprDocNumUI";
	}
	
	/**
	 * 전자결재 일반 관리자 분류코드관리 메인화면 그룹 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/getDocNumGroupNode.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getDocNumGroupNode(@CookieValue("loginCookie") String loginCookie, ApprDocGroupVO apprDocGroupVO) throws Exception {
		logger.debug("getDocNumGroupNode started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprDocGroupVO.setTenantID(userInfo.getTenantId());
		apprDocGroupVO.setLang(userInfo.getLang());
		
		String result = ezApprovalAdminService.getItemCodeGroup(apprDocGroupVO);
		
		logger.debug("getDocNumGroupNode ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 분류코드관리 체계추가 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/minsGroupMain.do")
	public String minsGroupMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("minsGroupMain started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String title = "";
		String tCheck = request.getParameter("tCheck");
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		if (tCheck != null && tCheck.equals("Ins")) {
			title = messageSource.getMessage("ezApproval.t765", userInfo.getLocale());
		} else {
			title = messageSource.getMessage("ezApproval.t766", userInfo.getLocale());
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("title", title);
		
		logger.debug("minsGroupMain ended");
		
		return "admin/ezApproval/apprMinsGroupMain";
	}
	
	/**
	 * 전자결재 일반 관리자 분류코드관리 체계추가 추가 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/mInsDocNumGroup.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mInsDocNumGroup(@CookieValue("loginCookie") String loginCookie, ApprDocGroupVO apprDocGroupVO) throws Exception {
		logger.debug("mInsDocNumGroup started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprDocGroupVO.setTenantID(userInfo.getTenantId());
		
		int result = ezApprovalAdminService.insertItemCodeGroup(apprDocGroupVO);
		
		logger.debug("mInsDocNumGroup ended");
		
		return String.valueOf(result);
	}
	
	/**
	 * 전자결재 일반 관리자 분류코드관리 체계삭제 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/mDelDocnumGroup.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mDelDocnumGroup(@CookieValue("loginCookie") String loginCookie, ApprDocGroupVO apprDocGroupVO) throws Exception {
		logger.debug("mDelDocnumGroup started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprDocGroupVO.setTenantID(userInfo.getTenantId());
		
		String result = ezApprovalAdminService.deleteItemCodeGroup(apprDocGroupVO);
		
		logger.debug("mDelDocnumGroup ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 분류코드관리 체계수정 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/mUpdateDocNumGroup.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mUpdateDocNumGroup(@CookieValue("loginCookie") String loginCookie, ApprDocGroupVO apprDocGroupVO) throws Exception {
		logger.debug("mUpdateDocNumGroup started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprDocGroupVO.setTenantID(userInfo.getTenantId());
		
		String result = ezApprovalAdminService.updateItemCodeGroup(apprDocGroupVO);
		
		logger.debug("mUpdateDocNumGroup ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 분류코드관리 리스트갯수 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/getDocNumItem.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mGetDocNumItem(@CookieValue("loginCookie") String loginCookie, ApprDocGroupVO apprDocGroupVO) throws Exception {
		logger.debug("mGetDocNumItem started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprDocGroupVO.setTenantID(userInfo.getTenantId());
		apprDocGroupVO.setLang(userInfo.getLang());
		
		String result = ezApprovalAdminService.getItemCodeItem(apprDocGroupVO);
		
		logger.debug("mGetDocNumItem ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 분류코드관리 분류추가 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/mInsCodeMain.do")
	public String mInsCodeMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("mInsCodeMain started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		if (request.getParameter("companyID") != null) {
			userInfo.setCompanyID(request.getParameter("companyID"));
		}
		
		String title = "";
		String tCheck = request.getParameter("tCheck");
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		String periodNode = ezApprovalAdminService.getKeepType("", userInfo);
		String securityNode = ezApprovalAdminService.getSecurityType("", userInfo);
		
		if (tCheck != null && tCheck.equals("Ins")) {
			title = messageSource.getMessage("ezApproval.t733", userInfo.getLocale());
		} else {
			title = messageSource.getMessage("ezApproval.t734", userInfo.getLocale());
		}
		
		int maxItemCode = ezApprovalAdminService.getMaxItemCode(userInfo);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("title", title);
		model.addAttribute("periodNode", periodNode);
		model.addAttribute("securityNode", securityNode);
		model.addAttribute("maxItemCode", maxItemCode);
		
		logger.debug("mInsCodeMain ended");
		
		return "admin/ezApproval/apprMinsCodeMain";
	}
	
	/**
	 * 전자결재 일반 관리자 분류코드관리 분류추가 추가 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/mInsDocNumItem.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mInsDocNumItem(@CookieValue("loginCookie") String loginCookie, ApprDocItemVO apprDocItemVO) throws Exception {
		logger.debug("mInsDocNumItem started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprDocItemVO.setTenantID(userInfo.getTenantId());
		
		String result = ezApprovalAdminService.insertItemCodeItem(apprDocItemVO);
		
		logger.debug("mInsDocNumItem ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 분류코드관리 분류수정 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/mUpdateDocNumItem.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mUpdateDocNumItem(@CookieValue("loginCookie") String loginCookie, ApprDocItemVO apprDocItemVO) throws Exception {
		logger.debug("mUpdateDocNumItem started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprDocItemVO.setTenantID(userInfo.getTenantId());
		
		String result = ezApprovalAdminService.updateItemCodeItem(apprDocItemVO);

		logger.debug("mUpdateDocNumItem ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 분류코드관리 분류삭제 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/mDelDocnumItem.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mDelDocnumItem(@CookieValue("loginCookie") String loginCookie, ApprDocItemVO apprDocItemVO) throws Exception {
		logger.debug("mDelDocnumItem started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprDocItemVO.setTenantID(userInfo.getTenantId());
		
		String result = ezApprovalAdminService.deleteItemCodeItem(apprDocItemVO);

		logger.debug("mDelDocnumItem ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 관인대장 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/manageSeal.do")
	public String manageSeal(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("manageSeal started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		StringBuilder companySel = new StringBuilder();
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "main/warning";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getLang(), userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
			}
		}
		
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("manageSeal ended");
		
		return "admin/ezApproval/apprManageSeal";
	}
	
	/**
	 * 전자결재 일반 관리자 관인대장리스트 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/getSealList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getSealList(@CookieValue("loginCookie") String loginCookie, ApprSealInfoVO apprSealInfoVO) throws Exception {
		logger.debug("getSealList started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprSealInfoVO.setTenantID(userInfo.getTenantId());
		apprSealInfoVO.setLang(userInfo.getLang());
		apprSealInfoVO.setOffSet(userInfo.getOffset());
		
		String result = ezApprovalAdminService.getSealList(apprSealInfoVO);
		
		logger.debug("getSealList ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 관인대장 관인추가 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/addSealInfo.do")
	public String addSealInfo(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) {
		logger.debug("addSealInfo started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("isCrossBrowser", isCrossBrowser);

		logger.debug("addSealInfo ended");
		
		return "admin/ezApproval/apprAddSealInfo";
	}
	
	/**
	 * 전자결재 일반 관리자 관인대장 관인추가 관인업로드 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/sealImageUpload.do")
	public String sealImageUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		logger.debug("sealImageUpload started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String strXML = "";
		String realPath = commonUtil.getRealPath(request);
		MultipartFile multiFile = request.getFile("file1");
		
		String companyID = request.getParameter("companyID");
		String mode = request.getParameter("mode");
		String fileName = multiFile.getOriginalFilename();
		
		String newFileName = companyID + "_" + commonUtil.getTodayUTCTime("yyyyMMddHHmmss") + "." + fileName.substring(fileName.lastIndexOf(".") + 1);
		
		if (newFileName.length() > 110) {
			newFileName = newFileName.substring(0, 105) + "." + fileName.substring(fileName.lastIndexOf(".") + 1);
		}
		
		String tempSealPath = realPath + commonUtil.separator + "fileroot" + commonUtil.separator + userInfo.getTenantId() + config.getProperty("upload_approval.SEALIMG");
		String thumbSealPath = realPath + commonUtil.separator + "fileroot" + commonUtil.separator + userInfo.getTenantId() + config.getProperty("upload_approval.SEALIMG") + commonUtil.separator + "T" + newFileName.substring(0, newFileName.lastIndexOf("."));
		
		File tempSeal = new File(tempSealPath);
		File thumbSeal = new File(thumbSealPath);
		
		InputStream stream = null;
		OutputStream bos = null;
		
		try {
		    stream = multiFile.getInputStream();
	
		    if (!tempSeal.isDirectory()) {
				boolean _flag = tempSeal.mkdirs();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }
	
		    bos = new FileOutputStream(tempSealPath + commonUtil.separator + newFileName);
	
		    int bytesRead = 0;
		    byte[] buffer = new byte[BUFF_SIZE];
	
		    while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
		    	bos.write(buffer, 0, bytesRead);
		    }
		} catch(IOException e) {
			logger.debug(e.getMessage());
		} finally {
			bos.close();
			stream.close();
		}
		
		thumbSeal.getParentFile().mkdirs();
		Thumbnails.of(new File(tempSealPath + commonUtil.separator + newFileName)).size(119, 128).outputFormat("png").toFile(thumbSeal);
		
		strXML = "<ROOT><NODES>";

        strXML += "<NODE><PUPLOADSN><![CDATA[" + newFileName + "]]></PUPLOADSN>";
        strXML += "<RESULTUPLOADA><![CDATA[" + "true" + "]]></RESULTUPLOADA>";
        strXML += "<PFILENAME><![CDATA[" + fileName + "]]></PFILENAME>";
        strXML += "<FILESIZE>" + multiFile.getSize() + "</FILESIZE>";
        strXML += "<FILELOCATION><![CDATA[" + newFileName + "]]></FILELOCATION>";
        strXML += "<MODE><![CDATA[" + mode + "]]></MODE>";
        strXML += "</NODE>";

        strXML += "</NODES></ROOT>";
        
        model.addAttribute("strXML", strXML);
		
		logger.debug("sealImageUpload ended");
		
		return "admin/ezApproval/apprSealImageUpload";
	}
	
	/**
	 * 전자결재 일반 관리자 관인대장 관인추가 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/insertSealInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String insertSealInfo(@CookieValue("loginCookie") String loginCookie, ApprSealInfoVO apprSealInfoVO) throws Exception {
		logger.debug("insertSealInfo started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprSealInfoVO.setTenantID(userInfo.getTenantId());
		apprSealInfoVO.setRegDate(commonUtil.getTodayUTCTime(""));
		apprSealInfoVO.setDelDate(commonUtil.getTodayUTCTime(""));
		
		String result = ezApprovalAdminService.insertSealInfo(apprSealInfoVO);

		logger.debug("insertSealInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 관인대장 관인정보 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/sealInfo.do")
	public String sealInfo() throws Exception {
		logger.debug("sealInfo started");
		logger.debug("sealInfo ended");
		
		return "admin/ezApproval/apprSealInfo";
	}
	
	/**
	 * 전자결재 일반 관리자 결재건수조회 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/statistics.do")
	public String statistics(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statistics started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		StringBuilder companySel = new StringBuilder();
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "main/warning";
		}
		
		String tempYear = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("YYYY"), userInfo.getOffset(), false);
		String tempMonth = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("MM"), userInfo.getOffset(), false);
		
		int year = Integer.parseInt(tempYear) - 1;
		int month = Integer.parseInt(tempMonth) - 1;
		
		if (month <= 0) {
			month = 12;
		} else {
			year = year + 1;
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getLang(), userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
			}
		}
		
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("tempYear", tempYear);
		model.addAttribute("tempMonth", tempMonth);
		model.addAttribute("month", month);
		model.addAttribute("year", year);

		logger.debug("statistics ended");
		
		return "admin/ezApproval/apprStatistics";
	}
	
	/**
	 * 전자결재 일반 관리자 결재건수조회 csv저장 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/excelExportOut.do")
	public void excelExportOut(@CookieValue("loginCookie") String loginCookie, ApprExcelOutVO apprExcelOutVO, HttpServletResponse response) throws Exception {
		logger.debug("excelExportOut started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String excelValue = "";
		StringBuilder resultExcel = new StringBuilder();
		
		apprExcelOutVO.setTenantID(userInfo.getTenantId());
		apprExcelOutVO.setLang(userInfo.getLang());
		
		if (apprExcelOutVO.getListType() != null && apprExcelOutVO.getListType().equals("ADMINUSERCOUNT")) {
			excelValue = ezApprovalAdminService.getUserDocCount(apprExcelOutVO, userInfo.getLocale(), userInfo.getOffset());
		} else {
			excelValue = ezApprovalAdminService.getDeptTranSendDocCount(apprExcelOutVO, userInfo.getOffset());
		}
		
		Document objXML = commonUtil.convertStringToDocument(excelValue);
		NodeList headers = objXML.getElementsByTagName("HEADERS");
		
		for (int k = 0; k < headers.item(0).getChildNodes().getLength(); k++) {
			String headerName = headers.item(0).getChildNodes().item(k).getChildNodes().item(0).getTextContent();
			
			if (k > 0) {
				headerName = "," + headerName;
			}
			
			resultExcel.append(headerName + "\t");
		}
		
		resultExcel.append("\n");
		
		NodeList rows = objXML.getElementsByTagName("ROWS");
		
		for (int k = 0; k < rows.item(0).getChildNodes().getLength(); k++) {
			NodeList cells = rows.item(0).getChildNodes().item(k).getChildNodes();
			
			for (int h = 0; h < cells.getLength(); h++) {
				String cellValue = cells.item(h).getChildNodes().item(0).getTextContent();
				
				if (h > 0) {
					cellValue = "," + cellValue;
				}
				
				resultExcel.append(cellValue + "\t");
			}
			resultExcel.append("\n");
		}
		
		response.setContentType("application/ms-excel");
		response.setCharacterEncoding("MS949");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyyMMddHHmmss"), userInfo.getOffset(), false) + "excelExport" + ".csv\"");
		response.getWriter().write(resultExcel.toString());
		
		logger.debug("excelExportOut ended");
	}
	
	/**
	 * 전자결재 일반 관리자 결재건수조회 개인별 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/getUserDocCount.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getUserDocCount(@CookieValue("loginCookie") String loginCookie, ApprExcelOutVO apprExcelOutVO) throws Exception {
		logger.debug("getUserDocCount started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		apprExcelOutVO.setTenantID(userInfo.getTenantId());
		apprExcelOutVO.setLang(userInfo.getLang());
		
		String result = ezApprovalAdminService.getUserDocCount(apprExcelOutVO, userInfo.getLocale(), userInfo.getOffset());
			
		logger.debug("getUserDocCount ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 결재건수조회 처리과별 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/getDeptTranSendDocCount.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getDeptTranSendDocCount(@CookieValue("loginCookie") String loginCookie, ApprExcelOutVO apprExcelOutVO) throws Exception {
		logger.debug("getDeptTranSendDocCount started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		apprExcelOutVO.setTenantID(userInfo.getTenantId());
		apprExcelOutVO.setLang(userInfo.getLang());
		
		String result = ezApprovalAdminService.getDeptTranSendDocCount(apprExcelOutVO, userInfo.getOffset());

		logger.debug("getDeptTranSendDocCount ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 양식등록 메인화면 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/getFormContInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getFormContInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFormContInfo started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String id = request.getParameter("id");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalAdminService.getFormContainerInfo(id, "", companyID, userInfo.getLang(), userInfo.getTenantId());

		logger.debug("getFormContInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 양식등록 양식함 추가 호출
	 */
	@RequestMapping(value = "/admin/ezApproval/formContMain.do")
	public String formContMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("formContMain started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String topID = "";
		String title = "";
		String tCheck = request.getParameter("tCheck");
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		if (tCheck != null && tCheck.equals("FContIns")) {
			title = messageSource.getMessage("ezApproval.t754", userInfo.getLocale());
		} else {
			title = messageSource.getMessage("ezApproval.t728", userInfo.getLocale());
		}
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topID = userInfo.getCompanyID();
		} else {
			topID = "Top";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("title", title);
		model.addAttribute("topID", topID);

		logger.debug("formContMain ended");
		
		return "admin/ezApproval/apprFormContMain";
	}
	
	/**
	 * 전자결재 일반 관리자 양식등록 양식함 추가 저장 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/setFormContIns.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setFormContIns(@CookieValue("loginCookie") String loginCookie, ApprFormContVO apprFormContVO) throws Exception {
		logger.debug("setFormContIns started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprFormContVO.setTenantID(userInfo.getTenantId());
		
		String result = ezApprovalAdminService.insertFormContainer(apprFormContVO, userInfo.getOffset());

		logger.debug("setFormContIns ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 양식등록 양식함 리스트 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/getFormList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getFormList(@CookieValue("loginCookie") String loginCookie, ApprFormInfoVO apprFormInfoVO) throws Exception {
		logger.debug("getFormList started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprFormInfoVO.setTenantID(userInfo.getTenantId());
		apprFormInfoVO.setLang(userInfo.getLang());
		
		String result = ezApprovalAdminService.getFormInfo(apprFormInfoVO);

		logger.debug("getFormList ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 양식등록 양식함 삭제 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/delFormCont.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String delFormCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("delFormCont started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String formContID = request.getParameter("id");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalAdminService.deleteFormContainer(formContID, companyID, userInfo.getTenantId());

		logger.debug("delFormCont ended");
		
		return result;
	}
	
	@RequestMapping(value = "/admin/ezApproval/formMainReform.do")
	public String formMainReform(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("formMainReform started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "main/warning";
		}
		
		String realPath = commonUtil.getRealPath(request);
		String topID = "";
		String title = "";
		String tCheck = request.getParameter("tCheck");
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		String formProcSpelling = ezCommonService.getTenantConfig("FormProcSpelling", userInfo.getTenantId());
		String useReform = ezCommonService.getTenantConfig("Usereform", userInfo.getTenantId());
		String companyID = request.getParameter("companyID");
		String contID = request.getParameter("contID");
		String formID = request.getParameter("formID");
		String formURL = request.getParameter("formURL");
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topID = userInfo.getCompanyID();
		} else {
			topID = "Top";
		}
		
		userInfo.setCompanyID(companyID);
		
		String docType = ezApprovalAdminService.getDocType("", userInfo);
		String securityNode = ezApprovalAdminService.getSecurityType("", userInfo);
		String periodNode = ezApprovalAdminService.getKeepType("", userInfo);
		String[]  docs;
		
		if (docType.split("t").length != 0) {
			docs = docType.split("t");
			
			for (int k = 1; k < docs.length; k++) {
				docs[k] = "t" + docs[k].split("<")[0];
				docType = docType.replace(docs[k], messageSource.getMessage("ezApproval." + docs[k], userInfo.getLocale()));
			}
		}
		
		if (tCheck != null && tCheck.equals("FIns")) {
			title = messageSource.getMessage("ezApproval.t760", userInfo.getLocale());
		} else {
			title = messageSource.getMessage("ezApproval.t761", userInfo.getLocale());
		}
		
		String listHeader = ezApprovalAdminService.getListHeader("110", userInfo);
		String aprTypeXML = ezApprovalAdminService.getAprType(userInfo);
		String aprRule = "";
		String aprRuleLine = "";
		
		if (formID != null && !formID.equals("")) {
			aprRule = ezApprovalAdminService.getFormAprRule(formID, companyID, userInfo.getTenantId());
			aprRuleLine = ezApprovalAdminService.getFormAprRuleLine(formID, companyID, userInfo.getTenantId());
		}
		
		String docTypeOption = "<OPTION VALUE='A02001' >" + messageSource.getMessage("ezApproval.t437", userInfo.getLocale()) + "</OPTION><OPTION VALUE='A02011' >" + messageSource.getMessage("ezApproval.t990013", userInfo.getLocale()) + "</OPTION><OPTION VALUE='A02012' >" + messageSource.getMessage("ezApproval.t990014", userInfo.getLocale()) + "</OPTION>";
		String reFormJSURL = ezApprovalAdminService.getFormContentReform(formID, userInfo.getLang(), companyID, userInfo.getTenantId());
		String strJSInfo = "";

		if (reFormJSURL != null) {
			String tempPath = realPath + commonUtil.separator + "fileroot" + commonUtil.separator + userInfo.getTenantId() + config.getProperty("upload_approval") + commonUtil.separator + reFormJSURL;
			File file = new File(tempPath);
			
			if (file.exists()) {
				strJSInfo = FileUtils.readFileToString(file);
			}
		}
		
		model.addAttribute("docTypeOption", docTypeOption);
		model.addAttribute("strJSInfo", strJSInfo);
		model.addAttribute("aprRule", aprRule);
		model.addAttribute("aprRuleLine", aprRuleLine);
		model.addAttribute("listHeader", listHeader);
		model.addAttribute("aprTypeXML", aprTypeXML);
		model.addAttribute("docType", docType);
		model.addAttribute("securityNode", securityNode);
		model.addAttribute("periodNode", periodNode);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("title", title);
		model.addAttribute("topID", topID);
		model.addAttribute("contID", contID);
		model.addAttribute("tCheck", tCheck);
		model.addAttribute("formURL", formURL);
		model.addAttribute("companyID", companyID);
		model.addAttribute("formProcSpelling", formProcSpelling);
		model.addAttribute("useReform", useReform);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("formMainReform ended");
		
		return "admin/ezApproval/apprFormMainReform";
	}
	
	@RequestMapping(value = "/admin/ezApproval/getFormInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getFormInfo(@CookieValue("loginCookie") String loginCookie, ApprFormInfoVO apprFormInfoVO) throws Exception {
		logger.debug("getFormInfo started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalAdminService.getFormContentReform(apprFormInfoVO.getFormID(), apprFormInfoVO.getLang(), apprFormInfoVO.getCompanyID(), userInfo.getTenantId());

		logger.debug("getFormInfo ended");
		
		return result;
	}
	
	@RequestMapping(value = "/admin/ezApproval/getFormRecvAdmin.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getFormRecvAdmin(@CookieValue("loginCookie") String loginCookie, ApprFormInfoVO apprFormInfoVO) throws Exception {
		logger.debug("getFormRecvAdmin started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprFormInfoVO.setTenantID(userInfo.getTenantId());
		apprFormInfoVO.setLang(userInfo.getLang());
		
		String result = ezApprovalAdminService.getFormRecvAdmin(apprFormInfoVO);

		logger.debug("getFormRecvAdmin ended");
		
		return result;
	}
	
	@RequestMapping(value = "/admin/ezApproval/getFormPropList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getFormPropList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFormPropList started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalAdminService.getFormProperty(userInfo.getLocale(), companyID, userInfo.getTenantId());

		logger.debug("getFormPropList ended");
		
		return result;
	}
	
	@RequestMapping(value = "/admin/ezApproval/reformDesignProcessorSub.do")
	public String reformDesignProcessorSub(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("reformDesignProcessorSub started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "main/warning";
		}
		
		String companyID = request.getParameter("companyID");
		String formProcSpelling = ezCommonService.getTenantConfig("FormProcSpelling", userInfo.getTenantId());
		String useReform = ezCommonService.getTenantConfig("useReform", userInfo.getTenantId());
		
		if (!formProcSpelling.equals("1")) {
			formProcSpelling = "0";
		}
		
		model.addAttribute("companyID", companyID);
		model.addAttribute("formProcSpelling", formProcSpelling);
		model.addAttribute("useReform", useReform);
		
		logger.debug("reformDesignProcessorSub ended");
		
		return "admin/ezApproval/apprReformDesignProcessorSub";
	}
	
	@RequestMapping(value = "/admin/ezApproval/formSaveReform.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String formSaveReform(@CookieValue("loginCookie") String loginCookie, ApprFormInfoVO apprFormInfoVO, HttpServletRequest request) throws Exception {
		logger.debug("formSaveReform started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		
		apprFormInfoVO.setTenantID(userInfo.getTenantId());
		//TODO: 일반버젼 하고 리폼 하기
		String rtnValue = ezApprovalAdminService.saveFormInfoReform(apprFormInfoVO, realPath, userInfo.getLocale());

		logger.debug("formSaveReform ended");
		
		return "";
	}
	
	@RequestMapping(value = "/admin/ezApproval/formMain.do")
	public String formMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("formMain started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "main/warning";
		}
		
		String topID = "";
		String title = "";
		String tCheck = request.getParameter("tCheck");
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		String formProcSpelling = ezCommonService.getTenantConfig("FormProcSpelling", userInfo.getTenantId());
		String companyID = request.getParameter("companyID");
		String contID = request.getParameter("contID");
		String formID = request.getParameter("formID");
		String editorType = request.getParameter("type");
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topID = userInfo.getCompanyID();
		} else {
			topID = "Top";
		}
		
		userInfo.setCompanyID(companyID);
		
		String docType = ezApprovalAdminService.getDocType("", userInfo);
		String securityNode = ezApprovalAdminService.getSecurityType("", userInfo);
		String periodNode = ezApprovalAdminService.getKeepType("", userInfo);
		String[]  docs;
		
		if (docType.split("t").length != 0) {
			docs = docType.split("t");
			
			for (int k = 1; k < docs.length; k++) {
				docs[k] = "t" + docs[k].split("<")[0];
				docType = docType.replace(docs[k], messageSource.getMessage("ezApproval." + docs[k], userInfo.getLocale()));
			}
		}
		
		if (tCheck != null && tCheck.equals("FIns")) {
			title = messageSource.getMessage("ezApproval.t760", userInfo.getLocale());
		} else {
			title = messageSource.getMessage("ezApproval.t761", userInfo.getLocale());
		}
		
		String listHeader = ezApprovalAdminService.getListHeader("110", userInfo);
		String aprTypeXML = ezApprovalAdminService.getAprType(userInfo);
		String aprRule = "";
		String aprRuleLine = "";
		
		if (formID != null && !formID.equals("")) {
			aprRule = ezApprovalAdminService.getFormAprRule(formID, companyID, userInfo.getTenantId());
			aprRuleLine = ezApprovalAdminService.getFormAprRuleLine(formID, companyID, userInfo.getTenantId());
		}
		
		String docTypeOption = "<OPTION VALUE='A02001' >" + messageSource.getMessage("ezApproval.t437", userInfo.getLocale()) + "</OPTION><OPTION VALUE='A02011' >" + messageSource.getMessage("ezApproval.t990013", userInfo.getLocale()) + "</OPTION><OPTION VALUE='A02012' >" + messageSource.getMessage("ezApproval.t990014", userInfo.getLocale()) + "</OPTION>";
		
		model.addAttribute("docTypeOption", docTypeOption);
		model.addAttribute("aprRule", aprRule);
		model.addAttribute("aprRuleLine", aprRuleLine);
		model.addAttribute("listHeader", listHeader);
		model.addAttribute("aprTypeXML", aprTypeXML);
		model.addAttribute("docType", docType);
		model.addAttribute("securityNode", securityNode);
		model.addAttribute("periodNode", periodNode);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("title", title);
		model.addAttribute("topID", topID);
		model.addAttribute("contID", contID);
		model.addAttribute("tCheck", tCheck);
		model.addAttribute("companyID", companyID);
		model.addAttribute("formProcSpelling", formProcSpelling);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("editorType", editorType);

		logger.debug("formMain ended");
		
		return "admin/ezApproval/apprFormMain";
	}
	
	@RequestMapping(value = "/admin/ezApproval/formSave.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String formSave(@CookieValue("loginCookie") String loginCookie, ApprFormInfoVO apprFormInfoVO, HttpServletRequest request) throws Exception {
		logger.debug("formSave started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		String resultXML = "";
		String rtnValue = ezApprovalAdminService.saveFormInfo(apprFormInfoVO, realPath, userInfo.getLocale());
		
		if (rtnValue.indexOf("ERROR") > 0) {
			resultXML = "<DATA>" + rtnValue + "</DATA>";
		} else {
			resultXML = "<DATA>OK</DATA>";
		}

		logger.debug("formSave ended");
		
		return resultXML;
	}
	
}
