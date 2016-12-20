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

import net.coobird.thumbnailator.Thumbnails;
import net.coobird.thumbnailator.makers.ThumbnailMaker;

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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApproval.service.EzApprovalAdminService;
import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocGroupVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocItemVO;
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
		
		return "/admin/ezApproval/apprFormAdmin";
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
	 * 전자결재 일반 관리자 문서함관리 특수문서함 추가 양식함리스트 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/MgetFormContinfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MgetFormContinfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("MgetFormContinfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String id = request.getParameter("id");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalAdminService.getFormContainerInfo(id, "", companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("MgetFormContinfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일반 관리자 문서함관리 특수문서함 추가 양식함리스트 양식리스트 표출
	 */
	@RequestMapping(value = "/admin/ezApproval/MgetForm.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MgetForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("MgetForm started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String id = request.getParameter("id");
		String kind = request.getParameter("kind");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalAdminService.getFormInfo(id, kind, "", "", companyID, userInfo.getLang(), userInfo.getTenantId());
		
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
	@RequestMapping(value = "/admin/ezApproval/mGetDocNumItem.do", produces = "text/xml;charset=utf-8")
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
	
	@RequestMapping(value = "/admin/ezApproval/sealImageUpload.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String sealImageUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request) throws Exception {
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
		
		String tempSealPath = realPath + commonUtil.separator + userInfo.getTenantId() + config.getProperty("upload_approval.SEALIMG");
		String thumbSealPath = realPath + commonUtil.separator + userInfo.getTenantId() + config.getProperty("upload_approval.SEALIMG") + commonUtil.separator + "T" + newFileName.substring(0, newFileName.lastIndexOf("."));
		
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
		
		logger.debug("sealImageUpload ended");
		
		return strXML;
	}
}
