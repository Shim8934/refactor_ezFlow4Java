package egovframework.ezEKP.ezApprovalG.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.StringReader;
import java.net.URLDecoder;
import java.util.Locale;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.codec.binary.Base64;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzApprovalGarchiveController extends EgovFileMngUtil {

    private static final Logger logger = LoggerFactory.getLogger(EzApprovalGarchiveController.class);
    
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "crypto") 
    private EgovFileScrty egovFileScrty;

	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;
	
	@Autowired
	private EgovMessageSource messageSource;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	/*
	 * 기록물대장 리스트
	 */
	@RequestMapping(value = "/ezApprovalG/cabinetMain.do", produces = "text/xml;charset=utf-8")
	public String cabinetmain(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("cabinetMain Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String sFlag = (request.getParameter("sFlag") != null ? request.getParameter("sFlag") : "");
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
	    
    	if (userInfo.getRollInfo().indexOf("a=1") > -1) {
    		susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
    	
		String result = ezOrganService.getPropertyList(userInfo.getId(), "extensionAttribute4;extensionAttribute5", userInfo.getPrimary(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(result);
		
		deptInfo  = doc.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent();
		buJaeInfo = doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent().trim();
		
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
		
		logger.debug("cabinetMain ended");
		
		return "ezApprovalG/apprGcabinetMain";
	}
	
	@RequestMapping(value = "/ezApprovalG/sendOfferCheck.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String sendOfferCheck(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("sendOfferCheck Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String pDocID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
        String pUserID = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        String result = ezApprovalGService.sendOfferCheck(pDocID, pUserID, "MUST", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
        
        logger.debug("sendOfferCheck ended");
        
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/contDocView_NoDoc.do", produces = "text/xml;charset=utf-8")
	public String contDocView_NoDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("contDocView_NoDoc Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String docType = request.getParameter("docType");
		String orgDocID = request.getParameter("orgDocID");
		String formID = request.getParameter("formID");
		String endDir = request.getParameter("endDir");
		String docTitle = request.getParameter("docTitle");
		String listSusin = request.getParameter("listSusin");
		String susinAdmin = request.getParameter("susinAdmin");
		String g_RecID = request.getParameter("g_RecID");
		String g_SepAttNo = request.getParameter("g_SepAttNo");
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
		String pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag);
		
		if (pass.equals("<RESULT>TRUE</RESULT>")) {
			String readRecXML = "<PARAMETER><DOCID>" + commonUtil.cleanValue(docID) +
                    "</DOCID><USERID>" + commonUtil.cleanValue(userInfo.getId()) +
                    "</USERID><USERNAME>" + commonUtil.cleanValue(userInfo.getDisplayName1()) +
                    "</USERNAME><USERTITLE>" + commonUtil.cleanValue(userInfo.getTitle1()) +
                    "</USERTITLE><DEPTCODE>" + commonUtil.cleanValue(userInfo.getDeptID()) +
                    "</DEPTCODE><DEPTNAME>" + commonUtil.cleanValue(userInfo.getDeptName1()) +
                    "</DEPTNAME><COMPANYID>" + commonUtil.cleanValue(userInfo.getCompanyID()) +
                    "</COMPANYID><USERNAME2>" + commonUtil.cleanValue(userInfo.getDisplayName2()) +
                    "</USERNAME2><USERTITLE2>" + commonUtil.cleanValue(userInfo.getTitle2()) +
                    "</USERTITLE2><DEPTNAME2>" + commonUtil.cleanValue(userInfo.getDeptName2()) +
                    "</DEPTNAME2></PARAMETER>";
			ezApprovalGService.saveRecReadHist(readRecXML, userInfo.getTenantId());
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("docHref", docHref);
		model.addAttribute("docType", docType);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("formID", formID);
		model.addAttribute("endDir", endDir);
		model.addAttribute("docTitle", docTitle);
		model.addAttribute("pass", pass);
		model.addAttribute("listSusin", listSusin);
		model.addAttribute("g_RecID", g_RecID);
		model.addAttribute("g_SepAttNo", g_SepAttNo);
		model.addAttribute("docID", docID);
		
		logger.debug("contDocView_NoDoc ended");
		
		return "ezApprovalG/apprGcontDocView_NoDoc";
	}
	
	@RequestMapping(value = "/ezApprovalG/getRecordInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getRecordInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model,@RequestBody String xmlPara) throws Exception{
		logger.debug("getRecordInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.GetRecordInfo(xmlDom, userInfo.getPrimary(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getRecordInfo ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/regRecord.do", produces = "text/xml;charset=utf-8")
	public String regRecord(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("regRecord started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
	    String regY = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(0,4);
	    String regM = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(5,7);
	    String regD = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(8,10);
	    String regH = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(11,13);
	    String regMi = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(14,16);
	    
	    model.addAttribute("userInfo", userInfo);
	    model.addAttribute("useEditor", useEditor);
	    model.addAttribute("regY", regY);
	    model.addAttribute("regM", regM);
	    model.addAttribute("regD", regD);
	    model.addAttribute("regH", regH);
	    model.addAttribute("regMi", regMi);
	    
		logger.debug("regRecord ended");

	    return "ezApprovalG/apprGregrecord";
	}
	 
	@RequestMapping(value = "/ezApprovalG/setRecUserRole.do", produces = "text/xml;charset=utf-8")
	public String setRecUserRole(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setRecUserRole Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("setRecUserRole ended");
		
		return "ezApprovalG/apprGsetRecUserRole";
	}
	
	@RequestMapping(value = "/ezApprovalG/getRecViewerInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getRecViewerInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model,@RequestBody String xmlPara) throws Exception{
		logger.debug("getRecViewerInfo Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.getRecViewer(xmlDom,userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("getRecViewerInfo ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/saveRecUserRole.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveRecUserRole(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model,@RequestBody String xmlPara) throws Exception{
		logger.debug("saveRecUserRole Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.saveRecUserRoleInfo(xmlDom,userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale());
		
		logger.debug("saveRecUserRole ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/viewRecReadHistory.do", produces = "text/xml;charset=utf-8")
	public String viewRecReadHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("viewRecReadHistory Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("viewRecReadHistory ended");
		
		return "ezApprovalG/apprGviewRecReadHistory";
	}
	
	@RequestMapping(value = "/ezApprovalG/getRecReadHistory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getRecReadHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model,@RequestBody String xmlPara) throws Exception{
		logger.debug("getRecReadHistory Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getRecReadHistory(xmlDom, userInfo.getOffset(), userInfo.getTenantId());
		
		logger.debug("getRecReadHistory ended");
		
		return result;
	}
	
	/** 기록물등록대장 등록정보 화면 호출*/
	@RequestMapping(value = "/ezApprovalG/viewRecInfo.do", produces = "text/xml;charset=utf-8")
	public String viewRecInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("viewRecInfo Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("viewRecInfo ended");
		
		return "ezApprovalG/apprGviewRecInfo";
	}
	
	/** 기록물등록대장 등록정보 화면 분류정보 탭*/
	@RequestMapping(value = "/ezApprovalG/getRecClassInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getRecClassInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getRecClassInfo Started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getRecordClassInfo(xmlDom, userInfo.getTenantId());
		
		logger.debug("getRecClassInfo result = " + result);
		logger.debug("getRecClassInfo Ended");

		return result;
	}
	
	/** 기록물등록대장 변경이력 화면*/
	@RequestMapping(value = "/ezApprovalG/viewRecHistory.do", produces = "text/xml;charset=utf-8")
	public String viewRecHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("viewRecHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("viewRecHistory ended");
		
		return "ezApprovalG/apprGviewRecHistory";
	}
	
	/** 기록물등록대장 변경이력 화면 상세정보*/
	@RequestMapping(value = "/ezApprovalG/getRecordHistory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getRecordHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model,Locale locale, @RequestBody String xmlPara) throws Exception{
		logger.debug("getRecordHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getRecordHistory(xmlDom,userInfo);
		Document xmlResult = commonUtil.convertStringToDocument(result);
		
		if (xmlResult.getElementsByTagName("ROW") != null){
			for (int k = 0; k < xmlResult.getElementsByTagName("ROW").getLength(); k++) {
				if (!xmlResult.getElementsByTagName("ROW").item(k).getChildNodes().item(8).getChildNodes().item(0).getTextContent().trim().equals("")) {
					xmlResult.getElementsByTagName("ROW").item(k).getChildNodes().item(8).getChildNodes().item(0).setTextContent(messageSource.getMessage(("ezApprovalG." + xmlResult.getElementsByTagName("ROW").item(k).getChildNodes().item(8).getChildNodes().item(0).getTextContent().trim()),locale));
				}
			}
		}
		
		logger.debug("getRecordHistory ended");
		
		return commonUtil.convertDocumentToString(xmlResult);
	}
	
	/** 기록물등록대장 이동 */
	@RequestMapping(value = "/ezApprovalG/moveRecord.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String moveRecord(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model,Locale locale, @RequestBody String xmlPara) throws Exception{
		logger.debug("moveRecord started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.moveRecord(xmlDom,userInfo.getLang(), userInfo.getTenantId());
		Document xmlResult = commonUtil.convertStringToDocument(result);
		
		logger.debug("moveRecord ended");
		
		return commonUtil.convertDocumentToString(xmlResult);
	}
	
	/** 기록물등록대장 수정 */
	@RequestMapping(value = "/ezApprovalG/changeRecordInfo.do", produces = "text/xml;charset=utf-8")
	public String changeRecordInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("changeRecordInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("changeRecordInfo ended");
		
		return "ezApprovalG/apprGchangeRecordInfo";
	}
	
	/** 기록물등록대장 수정 상세화면 */
	@RequestMapping(value = "/ezApprovalG/getRecordSimpleInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getRecordSimpleInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model , @RequestBody String xmlPara) throws Exception{
		logger.debug("getRecordSimpleInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getRecordSimpleInfo(xmlDom,userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
        
        logger.debug("getRecordSimpleInfo ended");
        
		return result;
	}
	
	/** 기록물등록대장 수정 상세화면 저장 */
	@RequestMapping(value = "/ezApprovalG/changeRecInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String changeRecInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model , @RequestBody String xmlPara) throws Exception{
		logger.debug("changeRecInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String result = ezApprovalGService.changeRecordInfo(xmlDom,userInfo.getLang(), userInfo.getTenantId());
        
        logger.debug("changeRecInfo ended");
        
		return result;
	}
	
	/** 기록물등록대장  문서출력 화면 호출*/
	@RequestMapping(value = "/ezApprovalG/docListView.do", produces = "text/xml;charset=utf-8")
	public String docListView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("docListView started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("docListView ended");
		
		return "ezApprovalG/apprGdocListView";
	}
	
	/** 기록물등록대장  문서출력 상세화면*/
	@RequestMapping(value = "/ezApprovalG/getDeliveryList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getDeliveryList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getDeliveryList started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String p_DeptID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent().trim();
        String pPageNum = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        String pPageSize = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
        String pOrderCell = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
        String pOrderOption = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
        String pQuery = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent();
        String isdocprint = xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent();
        String result = "";
        String deptcode = "";
        String deptcode2 = "";
        String title = "";
        String sregdate = "";
        String eregdate = "";
        String debenturer = "";
        
        if (xmlDom.getDocumentElement().getChildNodes().item(7).getTextContent().equals("0")) {
        	result = ezApprovalGService.getDeliveryList(p_DeptID, pPageSize, pPageNum, pOrderCell, pOrderOption, pQuery, userInfo.getCompanyID(), userInfo.getLang(), deptcode, deptcode2, title, sregdate, eregdate, debenturer, isdocprint, userInfo.getTenantId(), userInfo.getOffset());
        } else {
            deptcode = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(0).getTextContent().trim();
            deptcode2 = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(1).getTextContent().trim();
            title = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(2).getTextContent().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
            sregdate = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(3).getTextContent();
            eregdate = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(4).getTextContent();
            debenturer = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(5).getTextContent().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
            result = ezApprovalGService.getDeliveryList(p_DeptID, pPageSize, pPageNum, pOrderCell, pOrderOption, pQuery, userInfo.getCompanyID(), userInfo.getLang(), deptcode, deptcode2, title, commonUtil.getDateStringInUTC(sregdate, userInfo.getOffset(), true), commonUtil.getDateStringInUTC(eregdate, userInfo.getOffset(), true), debenturer, isdocprint, userInfo.getTenantId(), userInfo.getOffset());
        }
        
        logger.debug("getDeliveryList ended");
        
		return result;
	}
	
	/** 기록물등록대장  새 DocID 생성*/
	@RequestMapping(value = "/ezApprovalG/createNewDocId.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String createNewDocId(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("createNewDocId started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalGService.getNewID(userInfo.getCompanyID(),userInfo.getTenantId());
		
		logger.debug("createNewDocId ended");
		
		return result;
	}
	
	/** 기록물등록대장  기록물 등록*/
	@RequestMapping(value = "/ezApprovalG/registerRecord.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String registerRecord(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("registerRecord started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.registerRecord(xmlDom, userInfo.getTenantId(), userInfo.getOffset(), userInfo.getLocale());
		
		logger.debug("registerRecord ended");
		
		return result;
	}
	
	/** 기록물등록대장  첨부 추가*/
	@RequestMapping(value = "/ezApprovalG/regRecordAttach.do", produces = "text/xml;charset=utf-8")
	public String regRecordAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("regRecordAttach started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
        String susinAdmin = "";
        String serverName = userInfo.getServerName();
        String poptExt = "";
        String maxSize = "";
        String isBody = "";
        String hasattach = "NO";
        String docID = "NO";
        String realPath = commonUtil.getRealPath(request);
        
        docID = request.getParameter("docID") != null ? request.getParameter("docID") : "";
        
        if (userInfo.getRollInfo().indexOf("a=1") > -1) {
    		susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		poptExt = ezApprovalGService.getOptionInfo("A39", "001", userInfo, "CODE");
		maxSize = ezApprovalGService.getOptionInfo("A39", "002", userInfo, "CODE");
		
		String dirPath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		 
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
	    model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("serverName", serverName);
		model.addAttribute("poptExt", poptExt);
	    model.addAttribute("maxSize", maxSize);
		model.addAttribute("isBody", isBody);
		model.addAttribute("hasattach", hasattach);
		model.addAttribute("docID", docID);
		model.addAttribute("dirPath", dirPath);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("orgCompanyID", orgCompanyID);
		
		logger.debug("regRecordAttach ended");
		
		return "/ezApprovalG/apprGregRecordAttach";
	}
	
	
	/** 기록물등록대장  등록정보 인쇄*/
	@RequestMapping(value = "/ezApprovalG/printMetaInfo.do", produces = "text/xml;charset=utf-8")
	public String printMetaInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("printMetaInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("printMetaInfo ended");
		
		return "/ezApprovalG/apprGprintMetaInfo";
	}
	
	/** 기록물등록대장  등록정보 인쇄 상세화면*/
	@RequestMapping(value = "/ezApprovalG/printFormRecInfo.do", produces = "text/xml;charset=utf-8")
	public String printFormRecInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("printFormRecInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String RecID= request.getParameter("ID1");
		String SepAttNo =request.getParameter("ID2");
		String pXml = "<PARAMETERS><RECORDID>" + commonUtil.cleanValue(RecID.trim()) +
                "</RECORDID><SEPATTACHNO>" + commonUtil.cleanValue(SepAttNo.trim()) +
                "</SEPATTACHNO><COMPANYID>" + commonUtil.cleanValue(userInfo.getCompanyID()) +
                // 2010.07.30 다국어
                "</COMPANYID><STRLANG>" + commonUtil.cleanValue(userInfo.getLang()) + "</STRLANG></PARAMETERS>";
		Document xmlDom = commonUtil.convertStringToDocument(pXml);
		String resultXML = ezApprovalGService.GetRecordInfo(xmlDom, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		String resultXML2 = ezApprovalGService.getRecordClassInfo(xmlDom, userInfo.getTenantId());
		
		Document oBXml = commonUtil.convertStringToDocument(resultXML);
		String title = oBXml.getElementsByTagName("TITLE").item(0).getTextContent().trim();
		String regType= oBXml.getElementsByTagName("REGTYPE").item(0).getTextContent().trim();
		String deptName= oBXml.getElementsByTagName("DEPTNAME").item(0).getTextContent().trim();
		String regNo= oBXml.getElementsByTagName("REGNO").item(0).getTextContent().trim();
		String sepAttachNo= oBXml.getElementsByTagName("SEPATTACHNO").item(0).getTextContent().trim();
		String drafter = oBXml.getElementsByTagName("DRAFTER").item(0).getTextContent().trim();
		String aprMember= oBXml.getElementsByTagName("APRMEMBER").item(0).getTextContent().trim();
		String regDate = oBXml.getElementsByTagName("REGDATE").item(0).getTextContent().trim();
		String executeDate = oBXml.getElementsByTagName("EXECUTEDATE").item(0).getTextContent().trim();
		String receiptMember = oBXml.getElementsByTagName("RECEIPTMEMBER").item(0).getTextContent().trim();
		String deliveryNo = oBXml.getElementsByTagName("DELIVERYNO").item(0).getTextContent().trim();
		String produceDeptSn = oBXml.getElementsByTagName("PRODUCEDEPTSN").item(0).getTextContent().trim();
		String modifyFlag = oBXml.getElementsByTagName("MODIFYFLAG").item(0).getTextContent().trim();
		String rejectFalge = oBXml.getElementsByTagName("REJECTFLAG").item(0).getTextContent().trim();
		String electronicFlag = oBXml.getElementsByTagName("ELECTRONICFLAG").item(0).getTextContent().trim();
		String oldFlag = oBXml.getElementsByTagName("OLDFLAG").item(0).getTextContent().trim();
		String oldProduceDept = oBXml.getElementsByTagName("OLDPRODUCEDEPT").item(0).getTextContent().trim();
		String oldRecNo = oBXml.getElementsByTagName("OLDRECNO").item(0).getTextContent().trim();
		String oldRecKp = oBXml.getElementsByTagName("OLDRECKP").item(0).getTextContent().trim();
		String avSummary = oBXml.getElementsByTagName("AVSUMMARY").item(0).getTextContent().trim();
		String avType = oBXml.getElementsByTagName("AVTYPE").item(0).getTextContent().trim();
		
		Document oCXml = commonUtil.convertStringToDocument(resultXML2);
		String cabClassID = oCXml.getElementsByTagName("CABCLASSID").item(0).getTextContent().trim(); 
		String cabTitle = oCXml.getElementsByTagName("CABTITLE").item(0).getTextContent().trim();
		String specialRecCode = oCXml.getElementsByTagName("SPECIALRECCODE").item(0).getTextContent().trim();
		String publicCode = oCXml.getElementsByTagName("PUBLICCODE").item(0).getTextContent().trim();
		String limitRange = oCXml.getElementsByTagName("LIMITRANGE").item(0).getTextContent().trim();
		String confirmFlag = oCXml.getElementsByTagName("CONFIRMFLAG").item(0).getTextContent().trim();
		String catatransFlag = oCXml.getElementsByTagName("CATATRANSFLAG").item(0).getTextContent().trim();
		String catatransYear = oCXml.getElementsByTagName("CATATRANSYEAR").item(0).getTextContent().trim();
		String docTransFlag = oCXml.getElementsByTagName("DOCTRANSFLAG").item(0).getTextContent().trim();
		String docTransYear = oCXml.getElementsByTagName("DOCTRANSYEAR").item(0).getTextContent().trim();
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("title", title);
		model.addAttribute("regType", regType);
		model.addAttribute("deptName", deptName);
		model.addAttribute("regNo", regNo);
		model.addAttribute("sepAttachNo", sepAttachNo);
		model.addAttribute("drafter", drafter);
		model.addAttribute("aprMember", aprMember);
		model.addAttribute("regDate", regDate);
		model.addAttribute("executeDate", executeDate);
		model.addAttribute("receiptMember", receiptMember);
		model.addAttribute("deliveryNo", deliveryNo);
		model.addAttribute("produceDeptSn", produceDeptSn);
		model.addAttribute("modifyFlag", modifyFlag);
		model.addAttribute("rejectFalge", rejectFalge);
		model.addAttribute("electronicFlag", electronicFlag);
		model.addAttribute("oldFlag", oldFlag);
		model.addAttribute("oldProduceDept", oldProduceDept);
		model.addAttribute("oldRecNo", oldRecNo);
		model.addAttribute("oldRecKp", oldRecKp);
		model.addAttribute("avSummary", avSummary);
		model.addAttribute("avType", avType);
		model.addAttribute("cabClassID", cabClassID);
		model.addAttribute("cabTitle", cabTitle);
		model.addAttribute("specialRecCode", specialRecCode);
		model.addAttribute("publicCode", publicCode);
		model.addAttribute("limitRange", limitRange);
		model.addAttribute("confirmFlag", confirmFlag);
		model.addAttribute("catatransFlag", catatransFlag);
		model.addAttribute("catatransYear", catatransYear);
		model.addAttribute("docTransFlag", docTransFlag);
		model.addAttribute("docTransYear", docTransYear);
		
		logger.debug("printFormRecInfo ended");
		
		return "/ezApprovalG/apprGprintFormRecInfo";
	}
	
	/** 기록물등록대장 재발송*/
	@RequestMapping(value = "/ezApprovalG/ezSelectSusin.do", produces = "text/xml;charset=utf-8")
	public String ezSelectSusin(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("ezSelectSusin started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String susinAdmin ="";
		String serverName = userInfo.getServerName();
		String susinXML="";
		
    	if (userInfo.getRollInfo().indexOf("a=1") > -1) {
    		susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
    	
    	if (userInfo.getLang().equals("1")) {
    		susinXML="/xml/ezApprovalG/TreeViewEndAddDept.xml";
    	} else {
    		susinXML="/xml/ezApprovalG/TreeViewEndAddDept" + userInfo.getLang() + ".xml";
    	}
    	
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("serverName", serverName);
		model.addAttribute("susinXML", susinXML);
		
		logger.debug("ezSelectSusin ended");
		
		return "/ezApprovalG/apprGezSelectSusin";
	}
	
	/** 기록물등록대장 발송의뢰*/
	@RequestMapping(value = "/ezApprovalG/ezSelectOne.do", produces = "text/xml;charset=utf-8")
	public String ezSelectOne(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("ezSelectOne started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
		
		String susinAdmin ="";
		String serverName = userInfo.getServerName();
		String susinXML="";
		String mDeptInfo="";
		
    	if (userInfo.getRollInfo().indexOf("a=1") > -1) {
    		susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
    	
    	String searchList = "extensionAttribute4::" + userInfo.getCompanyID().trim();
    	String strRetXml = ezOrganService.getSearchList(searchList, "", "", "group", 100, userInfo.getPrimary(), tenantID);
    	Document xmlResult = commonUtil.convertStringToDocument(strRetXml); 
    	
    	if (xmlResult.getElementsByTagName("DATA2").getLength() > 0) {
    		mDeptInfo = xmlResult.getElementsByTagName("DATA2").item(0).getTextContent();
    	}
    	
    	model.addAttribute("userInfo", userInfo);
    	model.addAttribute("susinAdmin", susinAdmin);
    	model.addAttribute("serverName", serverName);
    	model.addAttribute("susinXML", susinXML);
    	model.addAttribute("mDeptInfo", mDeptInfo);
    	
    	logger.debug("ezSelectOne ended");
    	
		return "/ezApprovalG/apprGezSelectOne";
	}
	
	/** 기록물철등록부 발송의뢰 저장1*/
	@RequestMapping(value = "/ezApprovalG/updateReceiptOffer.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String updateReceiptOffer(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("updateReceiptOffer started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String docID = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent();
		String orgDocID = xmlDom.getElementsByTagName("OrgDocID").item(0).getTextContent();
		String result = ezApprovalGService.updateReceiptOffer(docID,orgDocID,userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("updateReceiptOffer ended");
		
		return result;
	}
	
	/** 기록물철등록부 발송의뢰 저장2*/
	@RequestMapping(value = "/ezApprovalG/sendOfferG.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String sendOfferG(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("sendOfferG started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
   		String realPath = commonUtil.getRealPath(request);
		String dirPath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = ezApprovalGService.doSendOffer(xmlDom,dirPath , userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("sendOfferG ended");
		
		return result;
	}
	
	/** 기록물철등록부 화면*/
	@RequestMapping(value = "/ezApprovalG/getCabinetList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getCabinetList started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getCabinetList(xmlDom,userInfo);
		
		logger.debug("getCabinetList ended");
		
		return result;
	}
	
	/** 기록물철등록부 철등록*/
	@RequestMapping(value = "/ezApprovalG/regCabinet.do", produces = "text/xml;charset=utf-8")
	public String regCabinet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("regCabinet started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("regCabinet ended");
		
		return "/ezApprovalG/apprGregCabinet";
	}
	
	/** 기록물철등록부 상세보기*/
	@RequestMapping(value = "/ezApprovalG/viewCabInfo.do", produces = "text/xml;charset=utf-8")
	public String viewCabInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("viewCabInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("viewCabInfo ended");
		
		return "/ezApprovalG/apprGviewCabInfo";
	}
	
	/** 기록물철등록부 상세보기*/
	@RequestMapping(value = "/ezApprovalG/getCabinetDetailInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetDetailInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getCabinetDetailInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getCabinetDetailInfo(xmlDom, userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getCabinetDetailInfo ended");
		
		return result;
	}
	
	/** 기록물철등록부 상세보기 특수목록탭*/
	@RequestMapping(value = "/ezApprovalG/getCabSCInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCabSCInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getCabSCInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getCabScInfo(xmlDom, userInfo.getTenantId());
		
		logger.debug("getCabSCInfo ended");
		
		return result;
	}
	
	/** 기록물철등록부 상세보기 인쇄*/
	@RequestMapping(value = "/ezApprovalG/printFormCabInfo.do", produces = "text/xml;charset=utf-8")
	public String printFormCabInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("printFormCabInfo started");
		
		  String STRGet_t106 = "";
          String STRGet_t117 = "";
          String STRGet_t573 = "";
          String STRGet_t574 = "";
          String STRGet_t576 = "";
          String STRGet_t577 = "";
          String STRGet_t599 = "";
          String STRGet_t600 = "";
          String STRGet_t816 = "";
          String STRGet_t819 = "";
          String STRGet_t825 = "";
          String STRGet_t826 = "";
          String STRGet_t827 = "";
          String STRGet_t828 = "";
          String STRGet_t829 = "";
          String STRGet_t830 = "";
          String STRGet_t831 = "";
          String STRGet_t832 = "";
          String STRGet_t833 = "";
          String STRGet_t834 = "";
          String STRGet_t835 = "";
          String STRGet_t836 = "";
          String STRGet_t837 = "";
          String STRGet_t838 = "";
          String STRGet_t839 = "";
          String STRGet_t840 = "";
          String STRGet_t841 = "";
          String STRGet_t842 = "";
          String STRGet_t843 = "";
          String STRGet_t844 = "";
          String STRGet_t845 = "";
          String STRGet_t846 = "";
          String STRGet_t847 = "";
          String STRGet_t848 = "";
          String STRGet_t849 = "";
          String STRGet_t850 = "";
          String STRGet_t851 = "";
          String STRGet_t852 = "";
          String STRGet_t853 = "";
          String STRGet_t854 = "";
          String STRGet_t855 = "";
          String STRGet_t856 = "";
          
		  userInfo = commonUtil.aprUserInfo(loginCookie);
		  String cabinetID= request.getParameter("ID1");
		  String pXml = "<PARAMETERS><CABINETID>" + commonUtil.cleanValue(cabinetID.trim()) +
			        "</CABINETID><COMPANYID>" + commonUtil.cleanValue(userInfo.getCompanyID()) +
			        "</COMPANYID><STRTYPE>" + commonUtil.cleanValue(userInfo.getLang()) + "</STRTYPE></PARAMETERS>";
			
		  Document xmlDom = commonUtil.convertStringToDocument(pXml);
		  String resultXML = ezApprovalGService.getCabinetPrintInfo(xmlDom,userInfo.getLang(), userInfo.getTenantId());
		  Document oXml = commonUtil.convertStringToDocument(resultXML);
			
		  String title = oXml.getElementsByTagName("TITLE").item(0).getTextContent().trim();
		  String cabClassID= oXml.getElementsByTagName("CABCLASSID").item(0).getTextContent().trim();
		  String recType= oXml.getElementsByTagName("RECTYPE").item(0).getTextContent().trim();
		  String deptName= oXml.getElementsByTagName("DEPTNAME").item(0).getTextContent().trim();
		  String taskName= oXml.getElementsByTagName("TASKNAME").item(0).getTextContent().trim();
		  String produceY = oXml.getElementsByTagName("PRODUCEY").item(0).getTextContent().trim();
		  String regSn = oXml.getElementsByTagName("REGSN").item(0).getTextContent().trim();
		  String volNo = oXml.getElementsByTagName("VOLNO").item(0).getTextContent().trim();
		  String regDate = oXml.getElementsByTagName("REGDATE").item(0).getTextContent().trim();
		  String numOfRec = oXml.getElementsByTagName("NUMOFREC").item(0).getTextContent().trim();
		  String numOfPage = oXml.getElementsByTagName("NUMOFPAGE").item(0).getTextContent().trim();
		  String numOfFile = oXml.getElementsByTagName("NUMOFFILE").item(0).getTextContent().trim();
		  String modifyFlag = oXml.getElementsByTagName("MODIFYFLAG").item(0).getTextContent().trim();
		  String oldFlag = oXml.getElementsByTagName("OLDFLAG").item(0).getTextContent().trim();
		  String oldCreateOrgan = oXml.getElementsByTagName("OLDCREATEORGAN").item(0).getTextContent().trim();
		  String oldClassNo = oXml.getElementsByTagName("OLDCLASSNO").item(0).getTextContent().trim();
		  String endY = oXml.getElementsByTagName("ENDY").item(0).getTextContent().trim();
		  String keepPeriod = oXml.getElementsByTagName("KEEPPERIOD").item(0).getTextContent().trim();
		  String keepMethod = oXml.getElementsByTagName("KEEPMETHOD").item(0).getTextContent().trim();
		  String keepPlace = oXml.getElementsByTagName("KEEPPLACE").item(0).getTextContent().trim();
		  String dispEndDate = oXml.getElementsByTagName("DISPENDDATE").item(0).getTextContent().trim();
		  String dispReason = oXml.getElementsByTagName("DISPREASON").item(0).getTextContent().trim();
		  String cabCharger = oXml.getElementsByTagName("CABCHARGER").item(0).getTextContent().trim();
		  String confirmFlag = oXml.getElementsByTagName("CONFIRMFLAG").item(0).getTextContent().trim();
		  String cataTransFlag = oXml.getElementsByTagName("CATATRANSFLAG").item(0).getTextContent().trim();
		  String cataTransYear = oXml.getElementsByTagName("CATATRANSYEAR").item(0).getTextContent().trim();
		  String docTransFlag = oXml.getElementsByTagName("DOCTRANSFLAG").item(0).getTextContent().trim();
		  String docTransYear = oXml.getElementsByTagName("DOCTRANSYEAR").item(0).getTextContent().trim();
		  String cabTransFlag = oXml.getElementsByTagName("CABTRANSFLAG").item(0).getTextContent().trim();
		  String transDate = oXml.getElementsByTagName("TRANSDATE").item(0).getTextContent().trim();
		  String tDeptName = oXml.getElementsByTagName("TDEPTNAME").item(0).getTextContent().trim();
		  String tDeptCode = oXml.getElementsByTagName("TDEPTCODE").item(0).getTextContent().trim();
		  String tTaskName = oXml.getElementsByTagName("TTASKNAME").item(0).getTextContent().trim();
		  String tTaskCode = oXml.getElementsByTagName("TTASKCODE").item(0).getTextContent().trim();
		  String tProduceY = oXml.getElementsByTagName("TPRODUCEY").item(0).getTextContent().trim();
		  String tRegSn = oXml.getElementsByTagName("TREGSN").item(0).getTextContent().trim();
		  String tVolNo = oXml.getElementsByTagName("TVOLNO").item(0).getTextContent().trim();
		  
		  model.addAttribute("STRGet_t106", STRGet_t106);
		  model.addAttribute("STRGet_t117", STRGet_t117);
		  model.addAttribute("STRGet_t573", STRGet_t573);
		  model.addAttribute("STRGet_t574", STRGet_t574);
		  model.addAttribute("STRGet_t576", STRGet_t576);
		  model.addAttribute("STRGet_t577", STRGet_t577);
		  model.addAttribute("STRGet_t599", STRGet_t599);
		  model.addAttribute("STRGet_t600", STRGet_t600);
		  model.addAttribute("STRGet_t816", STRGet_t816);
		  model.addAttribute("STRGet_t819", STRGet_t819);
		  model.addAttribute("STRGet_t825", STRGet_t825);
		  model.addAttribute("STRGet_t826", STRGet_t826);
		  model.addAttribute("STRGet_t827", STRGet_t827);
		  model.addAttribute("STRGet_t828", STRGet_t828);
		  model.addAttribute("STRGet_t829", STRGet_t829);
		  model.addAttribute("STRGet_t830", STRGet_t830);
		  model.addAttribute("STRGet_t831", STRGet_t831);
		  model.addAttribute("STRGet_t832", STRGet_t832);
		  model.addAttribute("STRGet_t833", STRGet_t833);
		  model.addAttribute("STRGet_t834", STRGet_t834);
		  model.addAttribute("STRGet_t835", STRGet_t835);
		  model.addAttribute("STRGet_t836", STRGet_t836);
		  model.addAttribute("STRGet_t837", STRGet_t837);
		  model.addAttribute("STRGet_t838", STRGet_t838);
		  model.addAttribute("STRGet_t839", STRGet_t839);
		  model.addAttribute("STRGet_t840", STRGet_t840);
		  model.addAttribute("STRGet_t841", STRGet_t841);
		  model.addAttribute("STRGet_t842", STRGet_t842);
		  model.addAttribute("STRGet_t843", STRGet_t843);
		  model.addAttribute("STRGet_t844", STRGet_t844);
		  model.addAttribute("STRGet_t845", STRGet_t845);
		  model.addAttribute("STRGet_t846", STRGet_t846);
		  model.addAttribute("STRGet_t847", STRGet_t847);
		  model.addAttribute("STRGet_t848", STRGet_t848);
		  model.addAttribute("STRGet_t849", STRGet_t849);
		  model.addAttribute("STRGet_t850", STRGet_t850);
		  model.addAttribute("STRGet_t851", STRGet_t851);
		  model.addAttribute("STRGet_t852", STRGet_t852);
		  model.addAttribute("STRGet_t853", STRGet_t853);
		  model.addAttribute("STRGet_t854", STRGet_t854);
		  model.addAttribute("STRGet_t855", STRGet_t855);
		  model.addAttribute("STRGet_t856", STRGet_t856);
		  model.addAttribute("title", title);
		  model.addAttribute("cabClassID", cabClassID);
		  model.addAttribute("recType", recType);
		  model.addAttribute("deptName", deptName);
		  model.addAttribute("taskName", taskName);
		  model.addAttribute("produceY", produceY);
		  model.addAttribute("regSn", regSn);
		  model.addAttribute("volNo", volNo);
		  model.addAttribute("regDate", regDate);
		  model.addAttribute("numOfRec", numOfRec);
		  model.addAttribute("numOfPage", numOfPage);
		  model.addAttribute("numOfFile", numOfFile);
		  model.addAttribute("modifyFlag", modifyFlag);
		  model.addAttribute("oldFlag", oldFlag);
		  model.addAttribute("oldCreateOrgan", oldCreateOrgan);
		  model.addAttribute("oldClassNo", oldClassNo);
		  model.addAttribute("endY", endY);
		  model.addAttribute("keepPeriod", keepPeriod);
		  model.addAttribute("keepMethod", keepMethod);
		  model.addAttribute("keepPlace", keepPlace);
		  model.addAttribute("dispEndDate", dispEndDate);
		  model.addAttribute("dispReason", dispReason);
		  model.addAttribute("cabCharger", cabCharger);
		  model.addAttribute("confirmFlag", confirmFlag);
		  model.addAttribute("cataTransFlag", cataTransFlag);
		  model.addAttribute("cataTransYear", cataTransYear);
		  model.addAttribute("docTransFlag", docTransFlag);
		  model.addAttribute("docTransYear", docTransYear);
		  model.addAttribute("cabTransFlag",cabTransFlag);
		  model.addAttribute("transDate", transDate);
		  model.addAttribute("tDeptName", tDeptName);
		  model.addAttribute("tDeptCode", tDeptCode);
		  model.addAttribute("tTaskName", tTaskName);
		  model.addAttribute("tTaskCode", tTaskCode);
		  model.addAttribute("tProduceY", tProduceY);
		  model.addAttribute("tRegSn", tRegSn);
		  model.addAttribute("tVolNo", tVolNo);
		  
		  logger.debug("printFormCabInfo ended");
			
		  return "/ezApprovalG/apprGprintFormCabInfo";
	}
	
	/** 기록물철등록부 수정버튼*/
	@RequestMapping(value = "/ezApprovalG/changeCabinetInfo.do", produces = "text/xml;charset=utf-8")
	public String changeCabinetInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("changeCabinetInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("changeCabinetInfo ended");
		
		return "/ezApprovalG/apprGchangeCabinetInfo";
	}
	
	/** 기록물철등록부 수정버튼*/
	@RequestMapping(value = "/ezApprovalG/getCabinetSimpleInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetSimpleInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getCabinetSimpleInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getCabinetSimpleInfo(xmlDom, userInfo.getTenantId());
		
		logger.debug("getCabinetSimpleInfo ended");
		
		return result ;
	}
	
	/** 기록물철등록부 수정 등록*/
	@RequestMapping(value = "/ezApprovalG/changeCabInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String changeCabInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("changeCabInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.changeCabinetInfo(xmlDom, userInfo.getTenantId(), userInfo.getCompanyID());
		
		logger.debug("changeCabInfo ended");
		
		return result ;
	}
	
	/** 기록물철등록부 이력보기 화면*/
	@RequestMapping(value = "/ezApprovalG/viewCabHistory.do", produces = "text/xml;charset=utf-8")
	public String viewCabHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("viewCabHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("viewCabHistory ended");
		return "/ezApprovalG/apprGviewCabHistory";
	}
	
	/** 기록물철등록부 이력보기 화면 상세내용*/
	@RequestMapping(value = "/ezApprovalG/getCabinetHistory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getCabinetHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getCabinetHistory(xmlDom, userInfo);
		
		logger.debug("getCabinetHistory ended");
		
		return result;
	}
	
	/** 기록물철등록부 검색 화면 */
	@RequestMapping(value = "/ezApprovalG/searchCab.do", produces = "text/xml;charset=utf-8")
	public String searchCab(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("searchCab started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		StringBuilder yearOption = new StringBuilder("");
		int curYear = Integer.parseInt(EgovDateUtil.getTodayTime().substring(0, 4));
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		yearOption.append("<Option Value=\"\"></Option>");
		
		for (int i = curYear; i >= curYear - 5; i--) {
			yearOption.append("<Option Value=\"" + Integer.toString(i) + "\">" + Integer.toString(i) + "</Option>");
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("yearOption", yearOption.toString());
		model.addAttribute("approvalFlag", approvalFlag);

		logger.debug("searchCab ended");
		
		return "/ezApprovalG/apprGsearchCab";
	}
	
	/** 기록물철등록부 업무담당자 지정  */
	@RequestMapping(value = "/ezApprovalG/setTaskChrger.do", produces = "text/xml;charset=utf-8")
	public String setTaskChrger(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setTaskChrger started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("setTaskChrger ended");
		
		return "/ezApprovalG/apprGsetTaskChrger";
	}
	
	/** 기록물철등록부 업무담당자지정 상세내용  */
	@RequestMapping(value = "/ezApprovalG/getTaskCharger.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getTaskCharger(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getTaskCharger started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getTaskCharger(xmlDom,userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("getTaskCharger ended");
		
		return result;
	}
	
	/** 기록물철등록부 업무담당자지정 저장  */
	@RequestMapping(value = "/ezApprovalG/saveCabRoleInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveCabRoleInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("saveCabRoleInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.saveCabRoleInfo(xmlDom, userInfo.getTenantId(), userInfo.getCompanyID());
		
		logger.debug("saveCabRoleInfo ended");
		
		return result;
	}
	
	/** 기록물배부대장 검색  */
	@RequestMapping(value = "/ezApprovalG/searchDelivery.do", produces = "text/xml;charset=utf-8")
	public String searchDelivery(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("searchDelivery started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		logger.debug("searchDelivery ended");
		return "ezApprovalG/apprGsearchDelivery";
	}
	
	/** 기록물배부대장 추가배부  */
	@RequestMapping(value = "/ezApprovalG/getCheckEndHref.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCheckEndHref(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getCheckEndHref started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String docID = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent();
		String result = "FALSE";
		String strXml = ezApprovalGService.getDocInfo(docID, "END", "Href", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
		Document resultXML = commonUtil.convertStringToDocument(strXml);
		
		if(resultXML.getElementsByTagName("HREF").getLength()>0){
			if(!resultXML.getElementsByTagName("HREF").item(0).getTextContent().trim().equals("")){
				result = "TRUE";
			}
		}
		
		logger.debug("getCheckEndHref ended");
		
		return "<Result>" + result + "</Result>";
	}
	
	/** 기록물배부대장 추가배부  */
	@RequestMapping(value = "/ezApprovalG/addBebu.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String addBebu(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("addBebu started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String realPath = commonUtil.getRealPath(request);
		String dirpath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator ;
		String result = ezApprovalGService.addBebu(xmlDom, dirpath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo);
		
		logger.debug("addBebu ended");
		
		return result;
	}
	
	/** 기록물등록대장 재발송  */
	@RequestMapping(value = "/ezApprovalG/selectReceipts.do", produces = "text/xml;charset=utf-8")
	public String selectReceipts(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("selectReceipts started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("pDocID");
		String serverName = userInfo.getServerName();
		
		model.addAttribute("docID", docID);
		model.addAttribute("serverName", serverName);
		
		logger.debug("selectReceipts ended");
		
		return "ezApprovalG/apprGezSelectReceipts";
	}
	
	/** 기록물등록대장 재발송 완료  */
	@RequestMapping(value = "/ezApprovalG/resendEndDoc.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String resendEndDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("resendEndDoc started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
	    String realPath = commonUtil.getRealPath(request);
		String dirPath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = ezApprovalGService.doReSendDoc(xmlDom, dirPath, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("resendEndDoc ended");
		
		return result;
	}
	
	/** 기록물등록대장 등록정보 특수목록 탭  */
	@RequestMapping(value = "/ezApprovalG/getRecSCInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getRecSCInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getRecSCInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getRecSCInfo(xmlDom,userInfo.getLang(),userInfo);
		logger.debug("getRecSCInfo ended");
		
		return result;
	}
	
	/** 발송의뢰 재발송 */
	@RequestMapping(value = "/ezApprovalG/UpdateProcessYN.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String UpdateProcessYN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("UpdateProcessYN started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String docID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String deptID = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String processYN = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		String deptName = "";
		String deptName2 = "";
		
		if (xmlDom.getDocumentElement().getChildNodes().getLength() > 3) {
			deptName = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
			deptName2 = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
		}
		
		String result = "";
		
		if (!deptName.equals("")) {
			result = ezApprovalGService.updateProcessYN2(docID, deptID, deptName2, deptName2, processYN, "EXECUTE", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		} else {
			result = ezApprovalGService.updateProcessYN(docID, deptID, processYN, "EXECUTE", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		}
		
		logger.debug("UpdateProcessYN ended");
		
		return result;
	}
	
	/** 메일발송 */
	@RequestMapping(value = "/ezApprovalG/GetDocInfoMode.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String GetDocInfoMode(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("GetDocInfoMode started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String docID = xmlDom.getElementsByTagName("DocID").item(0).getTextContent();
		String mode =  xmlDom.getElementsByTagName("mode").item(0).getTextContent();
		String fields =  xmlDom.getElementsByTagName("fields").item(0).getTextContent();
		String result = ezApprovalGService.getDocInfo(docID, mode, fields, userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
		
		logger.debug("<<<docID : " + docID);
		logger.debug("<<<mode : " + mode);
		logger.debug("<<<fields : " + fields);
		
		logger.debug("GetDocInfoMode ended");
		
		return result;
	}
	
	/** 전자결재 G 자동 알림 메일 */
	@RequestMapping(value = "/ezApprovalG/getMailAddress.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getMailAddress(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getMailAddress started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String proplist = "displayName;mail;department";
		String email = "";
		String name = "";
		String deptID = "";
		String result = "";
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String id = xmlDom.getElementsByTagName("id").item(0).getTextContent();
		
		if (!id.equals("")) {
			String infoXML = ezOrganService.getPropertyList(id, proplist, userInfo.getPrimary(), userInfo.getTenantId());
			Document doc = commonUtil.convertStringToDocument(infoXML);
			
			email  = doc.getElementsByTagName("MAIL").item(0).getTextContent();
			name = doc.getElementsByTagName("DISPLAYNAME").item(0).getTextContent().trim();
			deptID = doc.getElementsByTagName("DEPARTMENT").item(0).getTextContent().trim();
			result = name + "," + email + "," + deptID;
		}
		
		logger.debug("getMailAddress ended");
		
		return result;
	}
	
	/** 전자결재 G 자동 알림 메일 */
	@RequestMapping(value = "/ezApprovalG/mail_intersend.do", produces = "text/xml;charset=utf-8")
	public void mailInterSend(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse res, Model model,Locale locale) throws Exception{
		logger.debug("mail_intersend started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
//		String from = request.getParameter("from");
		String to[] = request.getParameter("to").split(",");
		String Subject = request.getParameter("Subject");
		String Content = request.getParameter("Content");
        boolean flag;
		StringBuilder bodyContent = new StringBuilder();
        
        bodyContent.append("<DIV id=\"msgBody\" style=\"font-size: 13px; font-family: " + messageSource.getMessage("main.t246", userInfo.getLocale())+ ";\" name=\"urn:schemas:httpmail:textdescription\">");
        bodyContent.append(Content);
        bodyContent.append("</DIV>");
    	InternetAddress from = new InternetAddress();
    	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
    	from.setAddress(userInfo.getEmail());
    	
    	InternetAddress to1 = new InternetAddress();
    	to1.setPersonal(to[0], "UTF-8");
    	to1.setAddress(to[1]);
    	
    	String xmlApprovNotiConfig = ezPersonalService.getApprovNotiConfig(userInfo.getId(), userInfo.getId(), userInfo.getTenantId());
    	Document doc = commonUtil.convertStringToDocument(xmlApprovNotiConfig);
		String saveSendBoxFlag = doc.getElementsByTagName("SAVEMAILFLAG").item(0).getTextContent().trim();
		logger.debug("saveSendBoxFlag= " + saveSendBoxFlag);
		
    	if (saveSendBoxFlag.equals("Y")) {
    		flag = true;
    	} else {
    		flag = false;
    	}
    	
    	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to1}, null, null, Subject, bodyContent.toString(),flag);
    	
    	logger.debug("mail_intersend ended");
	}
	
	/** 전자결재 G 자동 알림 메일 */
	@RequestMapping(value = "ezApprovalG/getReceiverList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getReceiverList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getReceiverList started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result ="";
		String deptID = request.getParameter("receiveDeptID");
		result = ezOrganService.getDeptReceipterIDs(deptID, userInfo.getTenantId());
		
		logger.debug("getReceiverList ended");
		
		return result;
	}
	
	/** 전자결재 G 서명등록*/
	@RequestMapping(value = "ezApprovalG/saveSingInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveSingInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("saveSingInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String fileName = request.getParameter("extensionAttribute3");
		
		ezOrganAdminService.updateProperty(userInfo.getId(), "extensionAttribute3", fileName, "user", userInfo.getTenantId());

		logger.debug("saveSingInfo ended");
		
		return "OK";
	}
	
	/** 전자결재 일반 개인함 관리*/
	@RequestMapping(value = "ezApprovalG/mngUserCont.do", produces = "text/xml;charset=utf-8")
	public String mngUserCont(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("mngUserCont started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String userCont = ezApprovalGService.getUserContTree(userInfo.getId(), "ROOT", userInfo.getDeptName(), userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale());
		model.addAttribute("userCont", userCont.replace("\"", "\\\""));
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("mngUserCont ended");
		
		return  "ezApprovalG/apprMngUserCont";
	}
	
	/** 전자결재 일반 개인함 관리 생성 호출*/
	@RequestMapping(value = "ezApprovalG/getContName.do", produces = "text/xml;charset=utf-8")
	public String getContName(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getContName started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String title = request.getParameter("Title");
		String titleText = URLDecoder.decode(request.getParameter("TitleText"), "utf-8");
		
		if (title.equals("")) {
			title = messageSource.getMessage("ezApproval.t297", userInfo.getLocale());
		}
		
		logger.debug("titleText= " + titleText);

		model.addAttribute("titleText", titleText);
		model.addAttribute("title", title);
		 
		logger.debug("getContName ended");
		 
		return  "ezApprovalG/apprGetContName";
	}
	
	/** 전자결재 일반 개인함 관리 생성*/
	@RequestMapping(value = "ezApprovalG/insertUserCont.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String insertUserCont(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model , @RequestBody String xmlPara) throws Exception{
		logger.debug("insertUserCont started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String OwnUserID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String ParentContID = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String OwnUserName = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		String description = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
		
		String result = ezApprovalGService.insUserCont(OwnUserID, ParentContID, OwnUserName, description, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		logger.debug("insertUserCont ended");
		
		return  result;
	}
	
	/** 전자결재 일반 개인함 관리 문서함 추가 생성*/
	@RequestMapping(value = "ezApprovalG/getUserContSubTree.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getUserContSubTree(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model , @RequestBody String xmlPara) throws Exception{
		logger.debug("getUserContSubTree started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String OwnUserID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String ParentContID = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String OwnUserName = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		
		String result = ezApprovalGService.getUserContTree(OwnUserID, ParentContID, OwnUserName, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale());

		logger.debug("getUserContSubTree ended");
		
		return  result;
	}
	
	/** 전자결재 일반 개인함 관리 이름 수정*/
	@RequestMapping(value = "ezApprovalG/updateUserCont.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String updateUserCont(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model , @RequestBody String xmlPara) throws Exception{
		logger.debug("updateUserCont started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String ContID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String OwnUserID = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String ParentContID = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		String UserContName = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
		String Description = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
        
		String result = ezApprovalGService.updateUserCont(ContID, OwnUserID, ParentContID, UserContName, Description, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		logger.debug("updateUserCont ended");
		
		return  result;
	}
	
	/** 전자결재 일반  개인함 관리 삭제*/
	@RequestMapping(value = "ezApprovalG/deleteUserCont.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String deleteUserCont(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model , @RequestBody String xmlPara) throws Exception{
		logger.debug("deleteUserCont started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String pContID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String pMode = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        
		String result = ezApprovalGService.delUserCont(pContID, pMode, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		logger.debug("deleteUserCont ended");
		
		return  result;
	}
	
	/** 전자결재일반 문서함 선택*/
	@RequestMapping(value = "ezApprovalG/selectContainer.do", produces = "text/xml;charset=utf-8")
	public String selectContainer(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("selectContainer started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String susinAdmin = "";
		if(userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		
		logger.debug("selectContainer ended");
		
		return  "ezApprovalG/apprGselectContainer";
	}
	
	/** 전자결재 일반 문서함 사용 부서*/
	@RequestMapping(value = "ezApprovalG/getContUseGroup.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getContUseGroup(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getContUseGroup started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String pDeptID = request.getParameter("deptID");
		
		String result = ezApprovalGService.getContUseDeptInfo(pDeptID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("getContUseGroup ended");
		
		return result ;
	}
	
	/** 전자결재 일반 개인함 등록 화면*/
	@RequestMapping(value = "ezApprovalG/selUserCont.do", produces = "text/xml;charset=utf-8")
	public String selUserCont(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("selUserCont started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String userCont = ezApprovalGService.getUserContTree(userInfo.getId(), "ROOT", userInfo.getDeptName(), userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale());
		model.addAttribute("userCont", userCont);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("selUserCont ended");
		
		return "ezApprovalG/apprGseluserCont";
	}
	
	/** 전자결재 일반 개인함 등록*/
	@RequestMapping(value = "ezApprovalG/setUserContDoc.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setUserContDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("setUserContDoc started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String docID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String contID = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String description = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		String orgCompanyID = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
		if (orgCompanyID == null || orgCompanyID.equals("")) {
			orgCompanyID = userInfo.getCompanyID();
		}
		
		String result = ezApprovalGService.registerUserContDoc(docID, contID, description, orgCompanyID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("setUserContDoc ended");
		
		return result;
	}
	
	/** 전자결재 개인 문서함 리스트*/
	@RequestMapping(value = "/ezApprovalG/getUserContList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getUserContList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getUserContList started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		Document xmldomsub = null;
		String pContID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String pPageNum = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String pPageSize = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		
		String pSubQuery = "";
		String p_UserLang = userInfo.getLang();
		if ( xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent().length() > 10) {
            try {
            	String TempQuery = "";
            	String ReturnQuery = "(1 = 1) ";
            	
            	xmldomsub = commonUtil.convertStringToDocument(xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent());
                TempQuery = xmldomsub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();

                if (TempQuery.indexOf("DOCNO;") != -1) {
                    ReturnQuery += " AND DOCNO LIKE '%" + xmldomsub.getElementsByTagName("DOCNO").item(0).getTextContent() + "%' ";
                }
                if (TempQuery.indexOf("DOCTITLE;") != -1) {
                    ReturnQuery += " AND DocTitle LIKE '%" + xmldomsub.getElementsByTagName("DOCTITLE").item(0).getTextContent() + "%' ";
                }
                if (p_UserLang.equals("2")) {
                    if (TempQuery.indexOf("WRITERNAME;") != -1) {
                        ReturnQuery += " AND WRITERNAME" + p_UserLang + " LIKE '%" + xmldomsub.getElementsByTagName("WRITERNAME").item(0).getTextContent() + "%' ";
                    }
                } else {
                    if (TempQuery.indexOf("WRITERNAME;") != -1) {
                        ReturnQuery += " AND WRITERNAME LIKE '%" + xmldomsub.getElementsByTagName("WRITERNAME").item(0).getTextContent() + "%' ";
                    }
                }
                
                if (commonUtil.getDatabaseType().equalsIgnoreCase("mysql")) {
	                if (TempQuery.indexOf("STARTDATEAF;") != -1) {
	                    ReturnQuery += " AND LINKDATE >= " + "STR_TO_DATE('" + xmldomsub.getElementsByTagName("STARTDATEAF").item(0).getTextContent() + "'  ,'%Y-%m-%d %H:%i:%s') ";
	                }
	                if (TempQuery.indexOf("STARTDATEBF;") != -1) {
	                    ReturnQuery += " AND LINKDATE <= " + "STR_TO_DATE('" + xmldomsub.getElementsByTagName("STARTDATEBF").item(0).getTextContent() + "'  ,'%Y-%m-%d %H:%i:%s')";
	                }
	                if (TempQuery.indexOf("ENDDATEAF;") != -1) {
	                    ReturnQuery += " AND ENDDATE >= " + "STR_TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("ENDDATEAF").item(0).getTextContent(), userInfo.getOffset(), true) + "'  ,'%Y-%m-%d %H:%i:%s')";
	                }
	                if (TempQuery.indexOf("ENDDATEBF;") != -1) {
	                    ReturnQuery += " AND ENDDATE <= " + "STR_TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("ENDDATEBF").item(0).getTextContent(), userInfo.getOffset(), true) + "' ,'%Y-%m-%d %H:%i:%s')";
	                }
                } else if (commonUtil.getDatabaseType().equalsIgnoreCase("oracle")) {
                	if (TempQuery.indexOf("STARTDATEAF;") != -1) {
 	                    ReturnQuery += " AND LINKDATE >= " + "TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("STARTDATEAF").item(0).getTextContent(), userInfo.getOffset(), true) + "'  ,'YYYY-MM-DD HH24:MI:SS') ";
 	                }
 	                if (TempQuery.indexOf("STARTDATEBF;") != -1) {
 	                    ReturnQuery += " AND LINKDATE <= " + "TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("STARTDATEBF").item(0).getTextContent(), userInfo.getOffset(), true) + "'  ,'YYYY-MM-DD HH24:MI:SS')";
 	                }
 	                if (TempQuery.indexOf("ENDDATEAF;") != -1) {
 	                    ReturnQuery += " AND ENDDATE >= " + "TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("ENDDATEAF").item(0).getTextContent(), userInfo.getOffset(), true) + "'  ,'YYYY-MM-DD HH24:MI:SS')";
 	                }
 	                if (TempQuery.indexOf("ENDDATEBF;") != -1) {
 	                    ReturnQuery += " AND ENDDATE <= " + "TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("ENDDATEBF").item(0).getTextContent() , userInfo.getOffset(), true) + "' ,'YYYY-MM-DD HH24:MI:SS')";
 	                }
                }
                
                if (TempQuery.indexOf("FORMID;") != -1) {
                    ReturnQuery += " AND TBL_ENDAPRDOCINFO.FormID = '" + xmldomsub.getElementsByTagName("FORMID").item(0).getTextContent() + "' ";
                }
                if (p_UserLang.equals("2")) {
                    if (TempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                        ReturnQuery += " AND WriterDeptName" + p_UserLang + " LIKE '%" + xmldomsub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent() + "%' ";
                    }
                } else {
                    if (TempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                        ReturnQuery += " AND WriterDeptName LIKE '%" + xmldomsub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent() + "%' ";
                    }
                }
                if (TempQuery.indexOf("KAPR;") != -1) {
                    ReturnQuery += " AND TBL_EXPENDAPRDOCINFO.keyword LIKE '%'KEYWORD'%' ";
                }
                if (TempQuery.indexOf("KEND;") != -1) {
                    ReturnQuery += " AND TBL_EXPAPRDOCINFO.keyword LIKE '%'KEYWORD'%' ";
                }
                if (TempQuery.indexOf("CAPR;") != -1) {
                    ReturnQuery += " AND TBL_EXPENDAPRDOCINFO.itemcode = '" + xmldomsub.getElementsByTagName("ITEMCODE").item(0).getTextContent() + "' ";
                }
                if (TempQuery.indexOf("CEND;") != -1) {
                    ReturnQuery += " AND TBL_EXPAPRDOCINFO.itemcode = '" + xmldomsub.getElementsByTagName("ITEMCODE").item(0).getTextContent() + "' ";
                }

                pSubQuery = ReturnQuery;
            } catch (Exception Ex) {
                pSubQuery = "";
            }
        }

        String oc = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
        String oo = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent();

        if (xmlDom.getDocumentElement().getChildNodes().getLength() > 6) {
            if (!xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent().trim().equals("")) {
                pSubQuery = pSubQuery + " AND " + xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent();
            }
        }

        String result = ezApprovalGService.getUserContList(pContID, pSubQuery, pPageSize, pPageNum, oc, oo, userInfo.getCompanyID(), userInfo.getLang(), xmldomsub, userInfo.getTenantId(), userInfo.getOffset(), userInfo.getId());

		logger.debug("getUserContList ended");

		return result;
	}
	
	
	/** 전자결재 개인 문서함 리스트*/
	@RequestMapping(value = "/ezApprovalG/getUserContListSave.do", produces = "text/xml;charset=utf-8")
	public void getUserContListSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getUserContListSave started");
		
		StringBuilder resultExcel = new StringBuilder();
		String excelValue = "";
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		response.setContentType("application/ms-excel");
		response.setCharacterEncoding("utf-8");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + EgovDateUtil.getTodayTime().substring(0, 10) + "_" + userInfo.getDeptID() + "_" + CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), messageSource.getMessage("ezApprovalG.t1750", userInfo.getLocale())) + ".xls\"");
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		Document xmldomsub = null;
		String pContID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String pPageNum = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String pPageSize = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		String AllFG = xmlDom.getDocumentElement().getChildNodes().item(7).getTextContent();
		
		String pSubQuery = "";
		String p_UserLang = userInfo.getLang();

		if (xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent().length() > 10) {
            try {
            	String TempQuery = "";
            	String ReturnQuery = "(1 = 1) ";
            	
            	xmldomsub = commonUtil.convertStringToDocument(xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent());
                TempQuery = xmldomsub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();

                if (TempQuery.indexOf("DOCNO;") != -1) {
                    ReturnQuery += " AND DOCNO LIKE '%'DOCNO'%' ";
                }
                if (TempQuery.indexOf("DOCTITLE;") != -1) {
                    ReturnQuery += " AND DocTitle LIKE '%'DOCTITLE'%' ";
                }
                if (p_UserLang.equals("2")) {
                    if (TempQuery.indexOf("WRITERNAME;") != -1) {
                        ReturnQuery += " AND WRITERNAME" + p_UserLang + " LIKE '%'WRITERNAME'%' ";
                    }
                } else {
                    if (TempQuery.indexOf("WRITERNAME;") != -1) {
                        ReturnQuery += " AND WRITERNAME LIKE '%'WRITERNAME'%' ";
                    }
                }
               
                if (commonUtil.getDatabaseType().equalsIgnoreCase("oracle")) {
	                if (TempQuery.indexOf("STARTDATEAF;") != -1) {
	                    ReturnQuery += " AND LINKDATE >= " + "TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("STARTDATEAF").item(0).getTextContent(), userInfo.getOffset(), false) + "'  ,'YYYY-MM-DD HH24:MI:SS') ";
	                }
	                if (TempQuery.indexOf("STARTDATEBF;") != -1) {
	                    ReturnQuery += " AND LINKDATE <= " + "TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("STARTDATEBF").item(0).getTextContent(), userInfo.getOffset(), false) + "'  ,'YYYY-MM-DD HH24:MI:SS')";
	                }
	                if (TempQuery.indexOf("ENDDATEAF;") != -1) {
	                    ReturnQuery += " AND ENDDATE >= " + "TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("ENDDATEAF").item(0).getTextContent(), userInfo.getOffset(), false) + "'  ,'YYYY-MM-DD HH24:MI:SS')";
	                }
	                if (TempQuery.indexOf("ENDDATEBF;") != -1) {
	                    ReturnQuery += " AND ENDDATE <= " + "TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("ENDDATEBF").item(0).getTextContent() , userInfo.getOffset(), false) + "' ,'YYYY-MM-DD HH24:MI:SS')";
	                }
                } else if (commonUtil.getDatabaseType().equalsIgnoreCase("mysql")) {
                	if (TempQuery.indexOf("STARTDATEAF;") != -1) {
 	                    ReturnQuery += " AND LINKDATE >= " + "STR_TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("STARTDATEAF").item(0).getTextContent(), userInfo.getOffset(), false) + "'  ,'%Y-%m-%d %H:%i:%s') ";
 	                }
 	                if (TempQuery.indexOf("STARTDATEBF;") != -1) {
 	                    ReturnQuery += " AND LINKDATE <= " + "STR_TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("STARTDATEBF").item(0).getTextContent(), userInfo.getOffset(), false) + "'  ,'%Y-%m-%d %H:%i:%s')";
 	                }
 	                if (TempQuery.indexOf("ENDDATEAF;") != -1) {
 	                    ReturnQuery += " AND ENDDATE >= " + "STR_TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("ENDDATEAF").item(0).getTextContent(), userInfo.getOffset(), false) + "'  ,'%Y-%m-%d %H:%i:%s')";
 	                }
 	                if (TempQuery.indexOf("ENDDATEBF;") != -1) {
 	                    ReturnQuery += " AND ENDDATE <= " + "STR_TO_DATE('" + commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("ENDDATEBF").item(0).getTextContent() , userInfo.getOffset(), false) + "' ,'%Y-%m-%d %H:%i:%s')";
 	                }
                }
                
                if (TempQuery.indexOf("FORMID;") != -1) {
                    ReturnQuery += " AND TBENDAPRDOCINFO.FormID = '" + xmldomsub.getElementsByTagName("FORMID").item(0).getTextContent() + "' ";
                }
                if (p_UserLang.equals("2")) {
                    if (TempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                        ReturnQuery += " AND WriterDeptName" + p_UserLang + " LIKE '%'WRITERDEPTNAME'%' ";
                    }
                } else {
                    if (TempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                        ReturnQuery += " AND WriterDeptName LIKE '%'WRITERDEPTNAME'%' ";
                    }
                }
                if (TempQuery.indexOf("KAPR;") != -1) {
                    ReturnQuery += " AND TBEXPENDAPRDOCINFO.keyword LIKE '%'KEYWORD'%' ";
                }
                if (TempQuery.indexOf("KEND;") != -1) {
                    ReturnQuery += " AND TBEXPAPRDOCINFO.keyword LIKE '%'KEYWORD'%' ";
                }
                if (TempQuery.indexOf("CAPR;") != -1) {
                    ReturnQuery += " AND TBEXPENDAPRDOCINFO.itemcode = '" + xmldomsub.getElementsByTagName("ITEMCODE").item(0).getTextContent() + "' ";
                }
                if (TempQuery.indexOf("CEND;") != -1) {
                    ReturnQuery += " AND TBEXPAPRDOCINFO.itemcode = '" + xmldomsub.getElementsByTagName("ITEMCODE").item(0).getTextContent() + "' ";
                }

                pSubQuery = ReturnQuery;
            } catch (Exception Ex) {
                pSubQuery = "";
            }
        }

        String oc = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
        String oo = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent();

        if (xmlDom.getDocumentElement().getChildNodes().getLength() > 6) {
            if (!xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent().trim().equals("")) {
                pSubQuery = pSubQuery + " AND " + xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent();
            }
        }
        
        if (AllFG.equals("0")) {
        	excelValue = ezApprovalGService.getUserContList(pContID, pSubQuery, pPageSize, pPageNum, oc, oo, userInfo.getCompanyID(), userInfo.getLang(), xmldomsub, userInfo.getTenantId(), userInfo.getOffset(), userInfo.getId());
        } else if(AllFG.equals("1")) {
        	excelValue = ezApprovalGService.getUserContListAll(pContID, pSubQuery, pPageSize, pPageNum, oc, oo, userInfo.getCompanyID(), userInfo.getLang(), xmldomsub, userInfo.getTenantId(), userInfo.getOffset());	
        }
        
        Document objXML = commonUtil.convertStringToDocument(excelValue);
        //2018-10-16 김보미 - 개인문서함 엑셀출력 workBook 이용해서 출력하도록 변경
/*		
		resultExcel.append("<table><tr>");
		
		for (int k = 0; k < objXML.getElementsByTagName("HEADER").getLength(); k++) {
			String headerName = objXML.getElementsByTagName("NAME").item(k).getTextContent();
			String headerWidth = objXML.getElementsByTagName("WIDTH").item(k).getTextContent();
			
			int width = Integer.parseInt(headerWidth) * 2;
			
			resultExcel.append("<td style='BORDER-BOTTOM: windowtext 0.5pt solid; BORDER-LEFT: windowtext; BACKGROUND-COLOR: #a6a6a6; BORDER-TOP: windowtext 0.5pt solid; BORDER-RIGHT: windowtext 0.5pt solid;width:" + width + "'><p align=center><STRONG>" + " " + commonUtil.cleanValue(headerName) + "</STRONG></p></td>        ");
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
				
				resultExcel.append("<td style='BORDER-BOTTOM: windowtext 0.5pt solid; BORDER-LEFT: windowtext; BORDER-TOP: windowtext 0.5pt solid; BORDER-RIGHT: windowtext 0.5pt solid;width:" + width + "'><p align=left>" + commonUtil.cleanValue(cellValue) + " </p></td>       ");
			}
			resultExcel.append("</tr>");
		}
		resultExcel.append("</table>");
		
//		response.getWriter().write(resultExcel.toString());
		
		//2018-07-13 천성준 - (#13042) 임시로 euc-kr로 해결, 추후에 왜 utf-8이 안먹는지 분석해서 utf-8로 고쳐야됨.  
		response.getOutputStream().write(resultExcel.toString().getBytes("euc-kr"));
*/
        
        //엑셀시작
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet;
	
		//헤더 폰트 굵게
		HSSFFont headerFont = workbook.createFont();
		headerFont.setBoldweight((short) headerFont.BOLDWEIGHT_BOLD);
		
		HSSFCellStyle headerStyle= workbook.createCellStyle();
		headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		headerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		headerStyle.setFont(headerFont);
		
		HSSFCellStyle bodyStyle= workbook.createCellStyle();
		bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		 
		Row row;
		Cell cell;
		      
		sheet = workbook.createSheet("report");
		row = sheet.createRow(0);
		for (int i = 0; i <objXML.getElementsByTagName("HEADER").getLength(); i++) {
			String headerName = objXML.getElementsByTagName("NAME").item(i).getTextContent();
			
			cell = row.createCell(i);
			cell.setCellValue(headerName);
			cell.setCellStyle(headerStyle);
		    row.setHeight((short)512);
		    sheet.autoSizeColumn(i);
		    sheet.setColumnWidth(i, (sheet.getColumnWidth(i)) + 512);
		}//header
		
		NodeList objRow = objXML.getElementsByTagName("ROW");
	
		for (int j = 0; j < objRow.getLength(); j++) {
			row = sheet.createRow((j + 1));
			
			Element rowElem = (Element) objRow.item(j);
			NodeList objCell = rowElem.getElementsByTagName("CELL");
	
			for (int k = 0; k < objCell.getLength(); k++) {
				Element cellElem = (Element) objCell.item(k);
	 			String cellValue = cellElem.getElementsByTagName("VALUE").item(0).getTextContent();
				
				cell = row.createCell(k);
				cell.setCellValue(cellValue);
				cell.setCellStyle(bodyStyle);
				row.setHeight((short)384);
				sheet.autoSizeColumn(k);
			    sheet.setColumnWidth(k, (sheet.getColumnWidth(k)) + 512);
			}
		}//body
	
		workbook.write(response.getOutputStream());
		workbook.close();
		logger.debug("getUserContListSave ended");
	}
	
	/** 전자결재 일반 결재문서 첨부*/
	@RequestMapping(value = "ezApprovalG/aprDocAttach.do", produces = "text/xml;charset=utf-8")
	public String aprDocAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("aprDocAttach started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String susinAdmin = "";

		String deptID = "";
		String deptNM = "";
		String deptNM1 = "";
		String deptNM2 = "";
		String title = "";
		String title1 = "";
		String title2 = "";
		String docID = request.getParameter("pDocID");
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
        String orgCompanyID = request.getParameter("orgCompanyID");
        
        if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
        
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
            susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
        
		if( docID != null && !docID.equals("")) {
			String result = ezApprovalGService.docAttachLineInfo(docID, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
			Document xmldoc = commonUtil.convertStringToDocument(result);
                if (xmldoc.getElementsByTagName("APRMEMBERDEPTID").getLength() > 0) {
                	deptID = xmldoc.getElementsByTagName("APRMEMBERDEPTID").item(0).getTextContent();
                	deptNM1 = xmldoc.getElementsByTagName("APRMEMBERDEPTNAME").item(0).getTextContent();
                	deptNM2 = xmldoc.getElementsByTagName("APRMEMBERDEPTNAME2").item(0).getTextContent();
                    title1 = xmldoc.getElementsByTagName("APRMEMBERJOBTITLE").item(0).getTextContent();
                    title2 = xmldoc.getElementsByTagName("APRMEMBERJOBTITLE2").item(0).getTextContent();
                } else {
                	deptID = userInfo.getDeptID();
                	deptNM1 = userInfo.getDeptName1();
                	deptNM2 = userInfo.getDeptName2();
                    title1 = userInfo.getTitle1();
                    title2 = userInfo.getTitle2();
                }
		} else {
			deptID = userInfo.getDeptID();
			deptNM1 = userInfo.getDeptName1();
			deptNM2 = userInfo.getDeptName2();
            title1 = userInfo.getTitle1();
            title2 = userInfo.getTitle2();
        }

        if (userInfo.getPrimary().equals("2")) {   
        	deptNM = deptNM2;
            title = title2;
            userInfo.setDeptName(userInfo.getDeptName2());  
        } else {
        	deptNM = deptNM1;
            title = title1;
            userInfo.setDeptName(userInfo.getDeptName1());
        }
        
		model.addAttribute("detpID", deptID);
		model.addAttribute("detpNM1", deptNM1);
		model.addAttribute("detpNM2", deptNM2);
		model.addAttribute("detpNM", deptNM);
		model.addAttribute("title", title);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("title1", title1);
		model.addAttribute("title2", title2);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("orgCompanyID", orgCompanyID);
		
		logger.debug("aprDocAttach ended");
		
		return "ezApprovalG/apprGaprdocattach";
	}
	
	/** 전자결재 일반 문서첨부*/
	@RequestMapping(value = "/ezApprovalG/mgetDeptUseDocType.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mgetDeptUseDocType(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception {
		logger.debug("mgetDeptUseDocType started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);

		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String deptID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		
		String result = ezApprovalGService.getContainerInfoManage(deptID, "XML", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("mgetDeptUseDocType ended");
		
		return result;
	}
	
	/** 전자결재 일반 문서첨부 리스트*/
	@RequestMapping(value = "/ezApprovalG/aprDocAttachList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprDocAttachList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception {
		logger.debug("aprDocAttachList started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String contID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String pageNum = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String pageSize = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		
		String result = ezApprovalGService.getContDocListS(contID, userInfo.getId(), "", pageSize, pageNum, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo.getLocale());

		logger.debug("aprDocAttachList ended");
		
		return result;
	}
	
	/** 전자결재 개인 문서함 문서 삭제*/
	@RequestMapping(value = "/ezApprovalG/delUserContDoc.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String delUserContDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception {
		logger.debug("delUserContDoc started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String docID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String contID = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String orgCompanyID = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		if (orgCompanyID == null || orgCompanyID.equals("")) {
			orgCompanyID = userInfo.getCompanyID();
		}
		
		String result = ezApprovalGService.deleteUserContDoc(docID, contID, orgCompanyID, userInfo.getLang(), userInfo.getTenantId());

		logger.debug("delUserContDoc ended");
		
		return result;
	}
	
	@RequestMapping(value = "ezApprovalG/setCabinetHesong.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setCabinetHesong(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setCabinetHesong started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String deptName = request.getParameter("deptName");
		String deptName2 = request.getParameter("deptName2");
		String userName = request.getParameter("userName");
		String userName2 = request.getParameter("userName2");
		String docSN = request.getParameter("docSN");
		String dirpath =  commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		String result = ezApprovalGService.setCabinetHesong(docID, deptID, deptName, deptName2, userName, userName2, dirpath, docSN, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo.getLocale());
	
		logger.debug("setCabinetHesong ended");
			
		return result;
	}
	
	/** 문서유통 암호화여부 팝업*/
	@RequestMapping(value = "/ezApprovalG/selectEnc.do", produces = "text/xml;charset=utf-8")
	public String selectEnc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("selectEnc started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);

		logger.debug("selectEnc ended");
		return "/ezApprovalG/apprGselectEnc";
	}
	
	/**
	 * 외부 부서검색 팝업창 호출
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezApprovalG/searchOrganGList.do", produces = "text/xml;charset=utf-8")
	public String searchOrganGList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("searchOrganGList started");
		userInfo = commonUtil.userInfo(loginCookie);

		String keyword = request.getParameter("keyword");

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("keyword", keyword);
		
		logger.debug("searchOrganGList ended");
		return "/ezApprovalG/apprGsearchOrganGList";
	}

	/**
	 * 외부 부서검색 데이터 리스트 가져오기
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezApprovalG/searchOrganGListData.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String searchOrganGListData(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception {
		logger.debug("searchOrganGListData started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String keyword = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
        String strFilter = "(&(ou=*" + keyword + "*)(objectclass=ucorg2))";
        int intScope = 3;
        String strXML = ezOrganService.searchOuterOrgan(strFilter, intScope);
        
		logger.debug("searchOrganGListData ended");
		return strXML;
	}

	/**
	 * 외부 수신처 이름 수정 팝업창 호출
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezApprovalG/aprDeptName.do", produces = "text/xml;charset=utf-8")
	public String aprDeptName(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("aprDeptName started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("aprDeptName ended");
		return "/ezApprovalG/apprGaprDeptName";
	}

	/**
	 * 외부 수신처 발송 시 코드 xml 화
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezApprovalG/getencodeinfoxXML.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getencodeinfoxXML(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("getencodeinfoxXML started");
		userInfo = commonUtil.userInfo(loginCookie);
		
        String realPath = commonUtil.getRealPath(request);
		String filePath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "encodeinfo.xml";
		
		File file = new File (filePath);
		String FileText = "";
		StringBuilder result = new StringBuilder();

		BufferedReader br = new BufferedReader(new FileReader(file));

		while ((FileText = br.readLine()) != null) {
			result.append(FileText);
		}
		br.close();
		logger.debug("getencodeinfoxXML ended");
		return result.toString();
	}

	/**
	 * 외부 수신처 발송 시 문서 정보
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezApprovalG/getEndDocInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getEndDocInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("getEndDocInfo started");
		userInfo = commonUtil.userInfo(loginCookie);
		
        String docID = request.getParameter("docID");
		String result = ezApprovalGService.getDocInfo(docID, "END", "ALL", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");

		logger.debug("getEndDocInfo ended");
		return result;
	}

	/**
	 * 외부 수신처 발송 시 문서 본문 xml 타입으로
	 * 
	 * @throws Exception
	 *             // HTML 정리 페이지로 MSHTML을 사용하여 태그를 정리한다. 
	 *             // MSHTML로 ElementTag의 Attribute를 정리하지는 않고 필수 Attribute 추가만 진행한다. 
	 *             // Attribute 전체 목록(사용하지 않는 Attribute포함)을 가지고 오기 때문에 이를 체크하는데 시간이 많이 소요되기   때문이다.(각 태그당 100개 이상의 속성) 
	 *             // 사용하지 않는 Attribute에 대한 처리는    Javascript 에서 처리한다. 
	 *             // 또한 Width, Height속성은 width_kaoni, height_kaoni로 리턴하여 자바스크립트에서 Replace하여 사용한다. 
	 *             // IE에서 Width, Height에 숫자만 인식되는 현상을 피하기 위해서이다.
	 * 
	 *             // 주의. 각 Element처리시 Element.OuterHTML을 사용하는 경우 해당 Element 하위의     Element의 값이 인식되지 않는 문제로 인해 OuterHTML 수정시에는 
	 *             //     GetElementsByTagName을 다시 로드하여 사용하도록 한다.
	 */
	@RequestMapping(value = "/ezApprovalG/getContentXml.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getContentXml(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("getContentXml started");
		userInfo = commonUtil.userInfo(loginCookie);
		
        String fontFamily = request.getParameter("fontFamily");
		String fontSize = request.getParameter("fontSize"); 
		String content = request.getParameter("content");

		String result = ezApprovalGService.startXmlConvert(content, fontFamily, fontSize, userInfo);
		logger.debug("getContentXml ended");
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/getLineInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getLineInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception {
		logger.debug("getLineInfo started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String docID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();

		String result = ezApprovalGService.getAprLineXmlForExt(docID, userInfo);
		logger.debug("getLineInfo ended");
		return result;
	}

	@RequestMapping(value = "/ezApprovalG/simsaGUpload.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String simsaGUpload(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception {
		logger.debug("simsaGUpload started");
		userInfo = commonUtil.userInfo(loginCookie);

		String docID = request.getParameter("docID");
		StringBuilder saveXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"euc-kr\"?><?xml-stylesheet type=\"text/xsl\" href=\"siheng.xsl\"?><!DOCTYPE pubdoc SYSTEM \"pubdoc.dtd\">");
		saveXML.append(xmlPara.replace("\n", "").replace("\t", "").replace("&amp;nbsp;", " ").replace("&amp;gt;", "&gt;").replace("&amp;lt;", "&lt;"));
		String realPath = commonUtil.getRealPath(request);
		String savePath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator	+ "sendXML"	+ commonUtil.separator + docID + "pubdoc.xml";
 		boolean saveFlag = false;
		String result = null;
		try {
			char intxt[] = new char[saveXML.toString().length()];
			saveXML.toString().getChars(0, saveXML.toString().length(), intxt, 0); // 입력하고자 하는 문자열을 문자 배열 intxt에 저장

			File file = new File(realPath + savePath);
			FileOutputStream fop = new FileOutputStream(file);
			// get the content in bytes
			fop.write(saveXML.toString().getBytes("euc-kr"));
			fop.flush();
			fop.close();

			saveFlag = true;
		} catch (Exception e) {
			e.printStackTrace();
			saveFlag = false;
		} 
		
		if (saveFlag) {
			result = "OK";
		} else {
			result = "O";
		}

		logger.debug("simsaGUpload ended");
		return result;
	}

	@RequestMapping(value = "/ezApprovalG/checkPubDocXML.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String checkPubDocXML(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("checkPubDocXML started");
		userInfo = commonUtil.userInfo(loginCookie);

		String xmlPath = request.getParameter("xmlPath");
		String mapPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID();

		String result = ezApprovalGService.checkPubDocXML(mapPath + xmlPath);
		logger.debug("checkPubDocXML ended");
		return result;
	}

	@RequestMapping(value = "/ezApprovalG/sendMsg2.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String sendMsg2(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("sendMsg2 started");
		userInfo = commonUtil.userInfo(loginCookie);
 
		String extXML = request.getParameter("extXML");
		Document xmlDom = commonUtil.convertStringToDocument(extXML);
		String mapPath = commonUtil.getRealPath(request);

		xmlDom.getElementsByTagName("send-gw").item(0).setTextContent(Base64.encodeBase64String(xmlDom.getElementsByTagName("send-gw").item(0).getTextContent().getBytes("euc-kr")));
		xmlDom.getElementsByTagName("send-name").item(0).setTextContent(Base64.encodeBase64String(xmlDom.getElementsByTagName("send-name").item(0).getTextContent().getBytes("euc-kr")));
		xmlDom.getElementsByTagName("title").item(0).setTextContent(Base64.encodeBase64String(xmlDom.getElementsByTagName("title").item(0).getTextContent().getBytes("euc-kr")));
		xmlDom.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").setNodeValue(Base64.encodeBase64String(xmlDom.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").getNodeValue().getBytes("euc-kr")));
		xmlDom.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").setNodeValue(Base64.encodeBase64String(xmlDom.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").getNodeValue().getBytes("euc-kr")));

		for (int i = 0; i < xmlDom.getElementsByTagName("content").getLength(); i++) {
				switch (xmlDom.getElementsByTagName("content").item(i).getAttributes().getNamedItem("content-role").getNodeValue()) {
				case "pubdoc":
					xmlDom.getElementsByTagName("content").item(i).getAttributes().getNamedItem("filename").setNodeValue(Base64.encodeBase64String("pubdoc.xml".getBytes("euc-kr")));
					xmlDom.getElementsByTagName("content").item(i).setTextContent(Base64.encodeBase64String(xmlDom.getElementsByTagName("content").item(i).getTextContent().replace("&lt;", "<").replace("&gt;", ">").replace("\n", "").replace("\t", "").replace("&amp;", "&").getBytes("euc-kr")));
					break;

				default:
					xmlDom.getElementsByTagName("content").item(i).getAttributes().getNamedItem("filename").setNodeValue(Base64.encodeBase64String(xmlDom.getElementsByTagName("content").item(i).getAttributes().getNamedItem("filename").getNodeValue().getBytes("euc-kr")));
					break;
				}
		}
		
		String result = ezApprovalGService.createSendMsgXML(xmlDom, mapPath, userInfo);
		logger.debug("sendMsg2 ended");
 		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/sendMsg.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String sendMsg(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("sendMsg started");
		userInfo = commonUtil.userInfo(loginCookie);
		 
		String extXML = request.getParameter("extXML");
		Document xmlDom = commonUtil.convertStringToDocument(extXML);
		String mapPath = commonUtil.getRealPath(request);
		String xmlPath = request.getParameter("xmlPath");
		String path = mapPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "sendXML" + commonUtil.separator + xmlPath;
		logger.debug("xmlPath=" + xmlPath);
		
		xmlDom.getElementsByTagName("send-gw").item(0).setTextContent(Base64.encodeBase64String(xmlDom.getElementsByTagName("send-gw").item(0).getTextContent().getBytes("euc-kr")));
		xmlDom.getElementsByTagName("send-name").item(0).setTextContent(Base64.encodeBase64String(xmlDom.getElementsByTagName("send-name").item(0).getTextContent().getBytes("euc-kr")));
		xmlDom.getElementsByTagName("title").item(0).setTextContent(Base64.encodeBase64String(xmlDom.getElementsByTagName("title").item(0).getTextContent().getBytes("euc-kr")));
		xmlDom.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").setNodeValue(Base64.encodeBase64String(xmlDom.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").getNodeValue().getBytes("euc-kr")));
		xmlDom.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").setNodeValue(Base64.encodeBase64String(xmlDom.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").getNodeValue().getBytes("euc-kr")));

		for (int i = 0; i < xmlDom.getElementsByTagName("content").getLength(); i++) {
				switch (xmlDom.getElementsByTagName("content").item(i).getAttributes().getNamedItem("content-role").getNodeValue()) {
				case "pubdoc":
					xmlDom.getElementsByTagName("content").item(i).getAttributes().getNamedItem("filename").setNodeValue(Base64.encodeBase64String("pubdoc.xml".getBytes("euc-kr")));
					xmlDom.getElementsByTagName("content").item(i).setTextContent(Base64.encodeBase64String(xmlDom.getElementsByTagName("content").item(i).getTextContent().replace("&lt;", "<").replace("&gt;", ">").replace("\n", "").replace("\t", "").replace("&amp;", "&").getBytes("euc-kr")));
					break;

				default:
					xmlDom.getElementsByTagName("content").item(i).getAttributes().getNamedItem("filename").setNodeValue(Base64.encodeBase64String(xmlDom.getElementsByTagName("content").item(i).getAttributes().getNamedItem("filename").getNodeValue().getBytes("euc-kr")));
					break;
				}
		}
		
		String xmlData = ezApprovalGService.createSendMsgXML(xmlDom, mapPath, userInfo);
		xmlData = xmlData.split("::")[1];
		xmlData = xmlData.replace("\n", "").replace("\t", "");
		FileOutputStream fop = null;
		
		try {
			File file = new File(path);
			fop = new FileOutputStream(file);
			fop.write(xmlData.getBytes("utf-8"));
			fop.flush();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fop != null) {
				try { fop.close(); } catch (Exception e) { }
			}
		}
		
		xmlData = xmlData.replace("<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">", "");
	    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();  
	    DocumentBuilder builder = factory.newDocumentBuilder();  
        xmlDom = builder.parse( new InputSource( new StringReader(xmlData) ) );  
		
		String sendID = xmlDom.getElementsByTagName("send-id").item(0).getTextContent();
		String receiveID = xmlDom.getElementsByTagName("receive-id").item(0).getTextContent();
		String[] arrReceiveID = receiveID.split(";");
		String strReceiveID = receiveID;
		
		if (receiveID.substring(0, 1).equals(";")) {
			strReceiveID = receiveID.substring(1);
		}

        if (receiveID.substring(receiveID.length() - 1, receiveID.length()).equals(";")) {
        	strReceiveID = receiveID.substring(0, receiveID.length() - 1);
        }

        xmlDom.getElementsByTagName("receive-id").item(0).setTextContent(strReceiveID);
        xmlDom.getElementsByTagName("date").item(0).setTextContent(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));

        String strXML = "<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">";
        strXML = strXML + commonUtil.convertDocumentToString(xmlDom); //.Replace("&amp;", "&");

        String strTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyyMMddHHmmss"), userInfo.getOffset(), false);
        String result = "";
        
        //여러부서 보낼수 있게 수정
        for (String recevID : arrReceiveID) {
        	result = ezApprovalGService.getFileName(mapPath, sendID + recevID + strTime, "sendtemp", strXML, userInfo.getTenantId());
        	
        	if (result.equals("FALSE")) {
        		logger.debug("sendMsg Fail : " + sendID + recevID + strTime);
        		
        		return result;
        	}
		}
        
        logger.debug("sendMsg ended");
        return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/cert.do", produces = "text/xml;charset=utf-8")
	public String cert(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("cert started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		logger.debug("cert ended");
		return "/ezApprovalG/apprGcert";
	}
	
	
	@RequestMapping(value = "/ezApprovalG/getRelayDocInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getRelayDocInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("getRelayDocInfo started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getRelayInfo(docID,userInfo);
		logger.debug("getRelayDocInfo ended");
		return result;
	}
	
	
	@RequestMapping(value = "/ezApprovalG/loadDocXML.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String loadDocXML(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("loadDocXML started");
		userInfo = commonUtil.userInfo(loginCookie);
		String result = "";
		String xmlPath = request.getParameter("XMLPATH");
		String strContent = "";
		try {
			 Document xmlDoc = commonUtil.xmlLod(commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + xmlPath);
			 
			 strContent = commonUtil.convertDocumentToString(xmlDoc);
			 strContent = strContent.substring(strContent.indexOf("<content>"),strContent.indexOf("</content>")).replace("<content>", "");
			 
			 strContent = "<![CDATA[" + strContent + "]]>";
			
			 xmlDoc.getElementsByTagName("content").item(0).setTextContent("");
			 xmlDoc.getElementsByTagName("content").item(0).setTextContent(strContent);
			
			 result = "<?xml version=\"1.0\" encoding=\"utf-8\"?>" + commonUtil.convertDocumentToString(xmlDoc).substring(commonUtil.convertDocumentToString(xmlDoc).indexOf("<pubdoc>"), commonUtil.convertDocumentToString(xmlDoc).length());
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("loadDocXML ended");
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/setHref.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setHref(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("setHref started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String fileType = request.getParameter("fileType");
		String mode = request.getParameter("mode");
		
		String result = ezApprovalGService.setHref(docID, fileType, mode, userInfo);
		logger.debug("setHref ended");
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/setRecvDocInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setRecvDocInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("setRecvDocInfo started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String fileType = request.getParameter("fileType");
		String mode = request.getParameter("mode");
		String publicFlag = request.getParameter("publicFlag");
		String docNo = request.getParameter("docNo");
		String docNumCode = request.getParameter("docNumCode");
		String orgDocNumCode = request.getParameter("orgDocNumCode");

		if (docNo == null) {
			docNo = "";
		}
		
		if (docNumCode == null) {
			docNumCode = "";
		}
		String result = ezApprovalGService.setRecvDocInfo(docID, publicFlag, docNo, docNumCode, orgDocNumCode, mode, fileType, userInfo);
		logger.debug("setRecvDocInfo ended");
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/setRecvComplete.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setRecvComplete(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("setRecvComplete started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String docID = request.getParameter("tempDocID");
		String docNo = request.getParameter("tempDocNo");
		String docNumCode = request.getParameter("tempDocNumCode");
		String orgDocNumCode = request.getParameter("tempOrgDocNumCode");
		String cabinetID = request.getParameter("tempCabinetID");
		String taskCode = request.getParameter("tempTaskCode");
		String userID = request.getParameter("tempUserID");
		String userName = request.getParameter("tempUserName");
        String userName2 = request.getParameter("tempUserName2");
        String deptID = request.getParameter("tempDeptID");
        String userTitle = request.getParameter("tempTitle");
        String userTitle2 = request.getParameter("tempTitle2");
        String deptName = request.getParameter("tempDeptName");
        String deptName2 = request.getParameter("tempDeptName2");
        String tempCompanyID = request.getParameter("tempCompanyID");
        
		String result = ezApprovalGService.updateRecvDocInfo(docID, docNo, docNumCode, orgDocNumCode, cabinetID, taskCode, userID, userName, userName2, deptID, userTitle, userTitle2, deptName, deptName2, tempCompanyID, userInfo, commonUtil.getRealPath(request));
		logger.debug("setRecvComplete ended");
		return result;
	}
	
	/** 전자결재 G 최종결재 개인합의 갯수 구하기*/
	@RequestMapping(value = "/ezApprovalG/lastKyulJeHabYuiYN.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String lastKyulJeHabYuiYN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("lastKyulJeHabYuiYN started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String flag  = request.getParameter("flag");
		
		int result = ezApprovalGService.lastKyulJeHabYuiYN(docID, flag, userInfo.getCompanyID(), userInfo.getTenantId());
	
		logger.debug("lastKyulJeHabYuiYN ended");
			
		return Integer.toString(result);
	}
	
	@RequestMapping(value = "/ezApprovalG/sendAckforReSend.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String sendAckforReSend(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("sendAckforReSend started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String type = request.getParameter("type");
		String userName = request.getParameter("userName");
		String userDeptName = request.getParameter("userDeptName");
		String errMsg = request.getParameter("tempCabinetID");
		
		if (userDeptName == null) {
			userDeptName = "";
		}

		String result = ezApprovalGService.sendAck(docID, type, userName, userDeptName, errMsg, userInfo.getCompanyID(), userInfo.getTenantId());
		logger.debug("sendAckforReSend ended");
		return result;
	}
	
	/** 전자결재 후결 승인*/
	@RequestMapping(value = "/ezApprovalG/setWhoKyulUpdate.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setWhoKyulUpdate(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setWhoKyulUpdate started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");

		String result = ezApprovalGService.doWhoKyulComplete(docID, userID, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLang());
		
		logger.debug("result = " + result);
		logger.debug("setWhoKyulUpdate ended");
	return result;
	}
	
	/** 전자결재 후결 승인*/
	@RequestMapping(value = "/ezApprovalG/getWhoKyulSignInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getWhoKyulSignInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getWhoKyulSignInfo started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");

		String result = ezApprovalGService.returnWhoKyulSingInfo(docID, userID, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLang());
		
		logger.debug("result = " + result);
		logger.debug("getWhoKyulSignInfo ended");
	return result;
	}
	
	/** 전자결재 후결 왼쪽 카운트*/
	@RequestMapping(value = "/ezApprovalG/getContDocCount.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getContDocCount(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getContDocCount started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String contID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
        String subQuery = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        
		String result = ezApprovalGService.getContDocListS(contID, userInfo.getId(), subQuery, "1", "0", "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo.getLocale());

		xmlDom = commonUtil.convertStringToDocument(result);
		logger.debug("result = " + result);
		logger.debug("getContDocCount ended");
	return "<RESULT>" + xmlDom.getElementsByTagName("TOTALCNT").item(0).getTextContent() + "</RESULT>";
	}
	
	/** 전자결재 참조 원기안문서 진행상태*/
	@RequestMapping(value = "/ezApprovalG/getLineMode.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getLineMode(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getLineMode started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");

		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = ezApprovalGService.getLineModeFlag(docID, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("result = " + result);
		logger.debug("getLineMode ended");
	return result;
	}
}
