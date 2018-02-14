package egovframework.ezEKP.ezApprovalG.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Controller
public class EzApprovalGHwpController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzApprovalGHwpController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzApprovalGAdminService")
	private EzApprovalGAdminService ezApprovalGAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@RequestMapping(value = "/ezApprovalG/drafuitHWP.do", produces = "text/xml;charset=utf-8")
	public String drafuitHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("drafuitHWP started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String susinAdmin = "";
		String formURL = request.getParameter("formURL");
		String draftFlag = request.getParameter("draftFlag");
		String formDocType = request.getParameter("formDocType");
		String susinSN = request.getParameter("susinSN");
		String docState = request.getParameter("docState");
		String listType = request.getParameter("listType");
		String aprState = request.getParameter("aprState");
		String isTmpDoc = request.getParameter("isTmpDoc");
		String connkey = request.getParameter("connkey");
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0,4) + commonUtil.separator;
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optIsSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
		String sihangURL = ezApprovalGService.getOptionInfo("A36", "004", userInfo, "CODE");
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		model.addAttribute("hwpToolbar", hwpToolbar);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("dirPath", dirPath);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("formURL", formURL);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("formDocType", formDocType);
		model.addAttribute("susinSN", susinSN);
		model.addAttribute("docState", docState);
		model.addAttribute("listType", listType);
		model.addAttribute("aprState", aprState);
		model.addAttribute("isTmpDoc", isTmpDoc);
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optIsSplit", optIsSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("sihangURL", sihangURL);
		model.addAttribute("connkey", connkey);
		model.addAttribute("isHWP", "Y");
		
		LOGGER.debug("drafuitHWP ended");
		
		return "ezApprovalG/apprGdrafuitHWP";
	}
	
	/**
	 * 전자결재 문서정보이력 상세보기
	 */	
	@RequestMapping(value = "/ezApprovalG/docViewerHWP.do")
	public String docViewerHWP(HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("docViewerHWP started");

		String docHref = request.getParameter("docHref");
		
		model.addAttribute("docHref", commonUtil.cleanValue(docHref));
		
		LOGGER.debug("docViewerHWP ended");
		
		return "ezApprovalG/apprGdocViewerHWP";
	}
	
	/**
	 * 
	 */	
	@RequestMapping(value = "/ezApprovalG/ezviewAprHWP.do")
	public String ezviewAprHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("ezviewAprHWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String susinAdmin = "";
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String opinionFlag = request.getParameter("opinionFlag");
		String docState = request.getParameter("docState");
		String listSusin = request.getParameter("listSusin");
		String orgDocID = request.getParameter("odoc");
		String showOpinion = request.getParameter("isOpinion");
		String listTypeValue = request.getParameter("listType");
		String hasOpinionYN = "";
		String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1 ) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}

		String strXML = ezApprovalGService.getDocInfo(docID, "APR", "HasOpinionYN", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
		
		Document resultXML = commonUtil.convertStringToDocument(strXML);
		
		if (resultXML.getElementsByTagName("HASOPINIONYN").getLength() > 0) {
			if (resultXML.getElementsByTagName("HASOPINIONYN").item(0) != null && !resultXML.getElementsByTagName("HASOPINIONYN").item(0).getTextContent().trim().equals("")) {
				hasOpinionYN = resultXML.getDocumentElement().getTextContent();
			}
		}
		
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("opinionFlag", opinionFlag);
		model.addAttribute("docState", docState);
		model.addAttribute("listSusin", listSusin);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("showOpinion", showOpinion);
		model.addAttribute("listTypeValue", listTypeValue);
		model.addAttribute("hasOpinionYN", hasOpinionYN);
		model.addAttribute("hwpToolbar", hwpToolbar);
		model.addAttribute("useEditor", useEditor);
		
		LOGGER.debug("ezviewAprHWP ended");
		
		return "ezApprovalG/apprGviewAprHWP";
	}
}
