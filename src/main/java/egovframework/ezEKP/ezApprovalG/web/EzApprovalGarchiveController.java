package egovframework.ezEKP.ezApprovalG.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.StringReader;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import org.apache.commons.codec.binary.Base64;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.json.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzApprovalGarchiveController extends EzFileMngUtil {

    private static final Logger logger = LoggerFactory.getLogger(EzApprovalGarchiveController.class);
    
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
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

	@Value("#{globals['Globals.DbType']}")
	private String dbType;
	/*
	 * 기록물대장 리스트
	 */
	@RequestMapping(value = "/ezApprovalG/cabinetMain.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String cabinetmain(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("cabinetMain Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String sFlag = (request.getParameter("sFlag") != null ? request.getParameter("sFlag") : "");
		String selSendStatus = request.getParameter("selSendStatus");
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

		/* 상위부서문서함 사용 시 관련 정보 같이 전달 */
		String upperDeptCode = "";
		String upperDeptName = "";
		Map<String, String> upDeptInfo = ezApprovalGService.getUpperDeptInfo(userInfo.getDeptID(), userInfo.getTenantId());
		if (upDeptInfo.get("USEUPPERDEPTBOX") != null && upDeptInfo.get("USEUPPERDEPTBOX").equals("Y")) {
			upperDeptCode = upDeptInfo.get("upperDeptCode");
			upperDeptName = upDeptInfo.get("upperDeptName");
		}
		
		// 2023-05-23 이혜림 - 전자결재G > 기록물대장 미리보기 - 전자결재 미리보기영역 관련 변수 추가
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String previewInfo = "OFF";
		String useAprPreview = ezCommonService.getTenantConfig("useAprPreview", userInfo.getTenantId());
		
		if (useAprPreview.equalsIgnoreCase("YES")) {
			previewInfo = ezApprovalGService.getApprovConfig(userInfo.getId(), userInfo.getTenantId());
		}

		// 2024-06-07 전인하 - 기록물대장 > 하위부서 문서함 조회
		// 하위부서문서함은 다음과 같은 경우에 표출된다 ; 관리자 권한(전체관리자, 회사관리자, 기록물관리책임자 중 1)이 존재하면서 기록물등록대장, 기록물접수목록, 기록물발송목록, 기록물철등록부일 경우
		// 2024-07-18 양지혜 - 상위부서문서함을 사용하고 있는 경우 하위부서문서함 기능을 표출하지 않음
		String underDeptShowFlag = "FALSE";
		List<String> needUnderDeptsFlag = new ArrayList<>(Arrays.asList("m01", "m02", "m05", "m06"));
		if (needUnderDeptsFlag.contains(sFlag) && commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;m") && upperDeptCode.equals("")) {
			underDeptShowFlag = "TRUE";
		}

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
		model.addAttribute("selSendStatus", selSendStatus);
		model.addAttribute("useReceiveInfoName", ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId()));
		model.addAttribute("upperDeptCode", upperDeptCode);
		model.addAttribute("upperDeptName", upperDeptName);
		
		logger.debug("cabinetMain ended");
		
		return "ezApprovalG/apprGcabinetMain";
	}
	
	@RequestMapping(value = "/ezApprovalG/sendOfferCheck.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	
	@RequestMapping(value = "/ezApprovalG/contDocView_NoDoc.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
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
		String pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());
		
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
		
		// 2023-05-26 조수빈 - 전자결재 첨부파일 미리보기 기능 사용 여부
		String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		
		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
			useAprFilePrvw = "1";
		} else {
			useAprFilePrvw = "0";
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
		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		
		logger.debug("contDocView_NoDoc ended");
		
		return "ezApprovalG/apprGcontDocView_NoDoc";
	}
	
	@RequestMapping(value = "/ezApprovalG/getRecordInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getRecordInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model,@RequestBody String xmlPara) throws Exception{
		logger.debug("getRecordInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.GetRecordInfo(xmlDom, userInfo.getPrimary(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getRecordInfo ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/regRecord.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String regRecord(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("regRecord started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
	    String apprTotalAttachLimit = ezCommonService.getTenantConfig("ApprTotalAttachLimit", userInfo.getTenantId());
		// 2023-05-26 조수빈 - 전자결재 첨부파일 미리보기 기능 사용 여부
 		String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
 		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
 		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
 		
 		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
 			useAprFilePrvw = "1";
 		} else {
 			useAprFilePrvw = "0";
 		}
		 
		/* 2024-08-09 김유진 - 파일첨부(aprAttach.do)창의 noti 문구와 동잃하게 표출하기 위한 설정 */
		String spanDisplayStyle = "inline-block";
		String apprAttachLimit = ezCommonService.getTenantConfig("ApprAttachLimit", userInfo.getTenantId()); // 일반 첨부파일의 총 크기제한 = 일반 첨부파일 -> 대용량으로 변경되는 기준 크기
		String bigSizeAttachLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 개수제한
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
		String bigSizeApprAttachLimit = ezCommonService.getTenantConfig("BigSizeApprAttachLimit", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 크기제한
		int pBigAttachLimitCount = bigSizeAttachLimitCount == null || bigSizeAttachLimitCount.equals("") ? 0 : Integer.parseInt(bigSizeAttachLimitCount);
		int pBigAttachDownloadLimitCount = bigSizeAttachDownloadLimitCount == null || bigSizeAttachDownloadLimitCount.equals("") ? 0 : Integer.parseInt(bigSizeAttachDownloadLimitCount);

		// 전자결재 첨부파일은 메일과 다르게 "총 첨부용량제한"값이 존재하므로, 알림 메세지의 첫번째 문구로 추가한다. (apprTotalAttachLimit)
		String pAttachWarning0 = messageSource.getMessage("ezSystem.HSBAppr02", userInfo.getLocale()) + apprTotalAttachLimit + messageSource.getMessage("ezSystem.HSBAppr03", userInfo.getLocale()); // 전체 첨부파일의 파일크기 합은 ~MB까지 가능합니다.
		String pAttachWarning1 = messageSource.getMessage("ezEmail.lhm18", userInfo.getLocale()) + apprAttachLimit + messageSource.getMessage("ezEmail.lhm19", userInfo.getLocale())
				+ bigSizeApprAttachLimit + messageSource.getMessage("ezSystem.HSBAppr03", userInfo.getLocale()); // 일반첨부파일은 총 10MB까지 가능하며, 대용량첨부는 800MB까지 가능합니다.

		if (pBigAttachLimitCount > 0) {
			pAttachWarning1 += messageSource.getMessage("ezSystem.HSBAppr08", userInfo.getLocale()) + messageSource.getMessageExtend("ezEmail.hdp03", new Object[] {pBigAttachLimitCount}, userInfo.getLocale()); // 일반첨부파일은 총 10MB까지 가능하며, 대용량첨부는 800MB까지 가능(최대 1개 첨부)
		}

		if (pBigAttachLimitCount > 0 && pBigAttachDownloadLimitCount > 0) {
			pAttachWarning1 += ", ";
		}

		if (pBigAttachDownloadLimitCount > 0) {
			// 여는 괄호 기호가 없는 경우에만 추가
			if (pAttachWarning1.indexOf(messageSource.getMessage("ezSystem.HSBAppr08", userInfo.getLocale())) < 0) {
				pAttachWarning1 += messageSource.getMessage("ezSystem.HSBAppr08", userInfo.getLocale());
			}
			pAttachWarning1 += messageSource.getMessageExtend("ezEmail.hdp04", new Object[] {pBigAttachDownloadLimitCount}, userInfo.getLocale()); // 일반첨부파일은 총 10MB까지 가능하며, 대용량첨부는 800MB까지 가능(최대 1개 첨부, 1회까지 다운로드 가능)
		}

		// 괄호 내부 옵션이 존재했을 경우에만 닫는괄호 표출
		if (pBigAttachLimitCount > 0 || pBigAttachDownloadLimitCount > 0) {
			pAttachWarning1 += messageSource.getMessage("ezSystem.HSBAppr09", userInfo.getLocale());
		}
		// 전자결재 첨부파일 총용량제한 기능을 사용하지 않는 경우(apprTotalAttachLimit값이 0), 총용량제한 문구는 표출하지 않는다.
		if (apprTotalAttachLimit.equals("0")) {
			pAttachWarning0 = pAttachWarning1;
			spanDisplayStyle = "none";
		}

		// 대용량 첨부기능을 사용하지 않는 경우, 일반 첨부만 사용하므로 "일반첨부파일은 총 ~MB까지 가능" 문구만 표출한다.
		if (bigSizeApprAttachLimit.equals("0")) {
			pAttachWarning0 = messageSource.getMessage("ezSystem.HSBAppr04", userInfo.getLocale()) + apprAttachLimit + messageSource.getMessage("ezSystem.HSBAppr03", userInfo.getLocale());
			spanDisplayStyle = "none";
		}
		// 파일첨부 noti 설정 끝
 		
	    model.addAttribute("userInfo", userInfo);
	    model.addAttribute("useEditor", useEditor);
	    model.addAttribute("apprTotalAttachLimit", apprTotalAttachLimit);
	    model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		model.addAttribute("pAttachWarning0", commonUtil.stripScriptTagsAndFunctions(pAttachWarning0));
		model.addAttribute("pAttachWarning1", commonUtil.stripScriptTagsAndFunctions(pAttachWarning1));
		model.addAttribute("spanDisplayStyle", commonUtil.stripScriptTagsAndFunctions(spanDisplayStyle)); // 첨부파일 알림 메세지 스타일

		logger.debug("regRecord ended");

	    return "ezApprovalG/apprGregrecord";
	}
	 
	@RequestMapping(value = "/ezApprovalG/setRecUserRole.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String setRecUserRole(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setRecUserRole Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("setRecUserRole ended");
		
		return "ezApprovalG/apprGsetRecUserRole";
	}
	
	@RequestMapping(value = "/ezApprovalG/getRecViewerInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getRecViewerInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model,@RequestBody String xmlPara) throws Exception{
		logger.debug("getRecViewerInfo Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.getRecViewer(xmlDom,userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("getRecViewerInfo ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/saveRecUserRole.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String saveRecUserRole(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model,@RequestBody String xmlPara) throws Exception{
		logger.debug("saveRecUserRole Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.saveRecUserRoleInfo(xmlDom,userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale());
		
		logger.debug("saveRecUserRole ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/viewRecReadHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String viewRecReadHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("viewRecReadHistory Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("viewRecReadHistory ended");
		
		return "ezApprovalG/apprGviewRecReadHistory";
	}
	
	@RequestMapping(value = "/ezApprovalG/getRecReadHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/viewRecInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String viewRecInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("viewRecInfo Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("viewRecInfo ended");
		
		return "ezApprovalG/apprGviewRecInfo";
	}
	
	/** 기록물등록대장 등록정보 화면 분류정보 탭*/
	@RequestMapping(value = "/ezApprovalG/getRecClassInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/viewRecHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String viewRecHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("viewRecHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("viewRecHistory ended");
		
		return "ezApprovalG/apprGviewRecHistory";
	}
	
	/** 기록물등록대장 변경이력 화면 상세정보*/
	@RequestMapping(value = "/ezApprovalG/getRecordHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/moveRecord.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/changeRecordInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String changeRecordInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("changeRecordInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("changeRecordInfo ended");
		
		return "ezApprovalG/apprGchangeRecordInfo";
	}
	
	/** 기록물등록대장 수정 상세화면 */
	@RequestMapping(value = "/ezApprovalG/getRecordSimpleInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/changeRecInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String changeRecInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model , @RequestBody String xmlPara) throws Exception{
		logger.debug("changeRecInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String result = ezApprovalGService.changeRecordInfo(xmlDom, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());
        
        logger.debug("changeRecInfo ended");
        
		return result;
	}
	
	/** 기록물등록대장  문서출력 화면 호출*/
	@RequestMapping(value = "/ezApprovalG/docListView.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String docListView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("docListView started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("docListView ended");
		
		return "ezApprovalG/apprGdocListView";
	}
	
	/** 기록물 배부대장 목록 */
	@RequestMapping(value = "/ezApprovalG/getDeliveryList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getDeliveryList(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlPara) throws Exception{
		logger.debug("getDeliveryList started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String p_DeptID = xmlDom.getElementsByTagName("PROCESSDEPTCODE").item(0).getTextContent().trim();
        String pPageNum = xmlDom.getElementsByTagName("PAGENO").item(0).getTextContent();
        String pPageSize = xmlDom.getElementsByTagName("PAGESIZE").item(0).getTextContent();
        String pOrderCell = xmlDom.getElementsByTagName("pOrderCell").item(0).getTextContent();
        String pOrderOption = xmlDom.getElementsByTagName("pOrderOption").item(0).getTextContent();
        String pQuery = xmlDom.getElementsByTagName("pQuery").item(0).getTextContent();
        String isdocprint = xmlDom.getElementsByTagName("ISDOCPRINT").item(0).getTextContent();
        String extReceptYN = xmlDom.getElementsByTagName("EXTRECEPTYN").item(0).getTextContent();
        String result = "";
        String deptcode = "";
        String deptcode2 = "";
        String title = "";
        String sregdate = "";
        String eregdate = "";
        String debenturer = "";
		String upperDeptCode = xmlDom.getElementsByTagName("UPPERDEPTCODE").item(0).getTextContent();
        
        if (xmlDom.getElementsByTagName("search").item(0).getTextContent().equals("0")) {
        	result = ezApprovalGService.getDeliveryList(p_DeptID, pPageSize, pPageNum, pOrderCell, pOrderOption, pQuery, userInfo.getCompanyID(),
					userInfo.getLang(), deptcode, deptcode2, title, sregdate, eregdate, debenturer, isdocprint, extReceptYN, userInfo, upperDeptCode);
        } else {
            deptcode = xmlDom.getElementsByTagName("SEARCHPARAM").item(0).getChildNodes().item(0).getTextContent().trim();
            deptcode2 = xmlDom.getElementsByTagName("SEARCHPARAM").item(0).getChildNodes().item(1).getTextContent().trim();
			title = xmlDom.getElementsByTagName("SEARCHPARAM").item(0).getChildNodes().item(2).getTextContent().replace("[", "\\[").replace("%", "\\%").replace("_", "\\_");
            sregdate = xmlDom.getElementsByTagName("SEARCHPARAM").item(0).getChildNodes().item(3).getTextContent();
            eregdate = xmlDom.getElementsByTagName("SEARCHPARAM").item(0).getChildNodes().item(4).getTextContent();
            debenturer = xmlDom.getElementsByTagName("SEARCHPARAM").item(0).getChildNodes().item(5).getTextContent().replace("[", "\\[").replace("%", "\\%").replace("_", "\\_");
            result = ezApprovalGService.getDeliveryList(p_DeptID, pPageSize, pPageNum, pOrderCell, pOrderOption, pQuery, userInfo.getCompanyID(),
					userInfo.getLang(), deptcode, deptcode2, title, commonUtil.getDateStringInUTC(sregdate, userInfo.getOffset(), true),
					commonUtil.getDateStringInUTC(eregdate, userInfo.getOffset(), true), debenturer, isdocprint, extReceptYN, userInfo, upperDeptCode);
        }
        
        logger.debug("getDeliveryList ended");
        
		return result;
	}
	
	/** 기록물등록대장  새 DocID 생성*/
	@RequestMapping(value = "/ezApprovalG/createNewDocId.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String createNewDocId(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("createNewDocId started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalGService.getNewID(userInfo.getCompanyID(),userInfo.getTenantId());
		
		logger.debug("createNewDocId ended");
		
		return result;
	}
	
	/** 기록물등록대장  기록물 등록*/
	@RequestMapping(value = "/ezApprovalG/registerRecord.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/regRecordAttach.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezApprovalG/printMetaInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String printMetaInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("printMetaInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("printMetaInfo ended");
		
		return "/ezApprovalG/apprGprintMetaInfo";
	}
	
	/** 기록물등록대장  등록정보 인쇄 상세화면*/
	@RequestMapping(value = "/ezApprovalG/printFormRecInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
		String publicCode = oCXml.getElementsByTagName("PUBLICCODE").item(0).getTextContent().trim(); // 대민공개
		String publicCode2 = oCXml.getElementsByTagName("PUBLICCODE2").item(0).getTextContent().trim(); // 공개여부
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
		model.addAttribute("publicCode2", publicCode2);
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
	@RequestMapping(value = "/ezApprovalG/ezSelectSusin.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezApprovalG/ezSelectOne.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
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
    	String strRetXml = ezOrganService.getSearchList(searchList, "", "", "group", 100, userInfo.getPrimary(), tenantID, "n");
    	Document xmlResult = commonUtil.convertStringToDocument(strRetXml); 
    	
    	if (xmlResult.getElementsByTagName("DATA2").getLength() > 0) {
    		mDeptInfo = xmlResult.getElementsByTagName("DATA2").item(0).getTextContent();
    	}
    	
    	String simsaListByDept = ezCommonService.getTenantConfig("simsaListByDepartment", userInfo.getTenantId());
    	
    	if (simsaListByDept == null || simsaListByDept.equals("")) {
    		simsaListByDept = "YES";
    	}
    	
    	model.addAttribute("userInfo", userInfo);
    	model.addAttribute("susinAdmin", susinAdmin);
    	model.addAttribute("serverName", serverName);
    	model.addAttribute("susinXML", susinXML);
    	model.addAttribute("mDeptInfo", mDeptInfo);
    	model.addAttribute("simsaListByDept", simsaListByDept);
    	
    	logger.debug("ezSelectOne ended");
    	
		return "/ezApprovalG/apprGezSelectOne";
	}
	
	/** 기록물철등록부 발송의뢰 저장1*/
	@RequestMapping(value = "/ezApprovalG/updateReceiptOffer.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/sendOfferG.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/getCabinetList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/regCabinet.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String regCabinet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("regCabinet started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		/* 상위부서문서함 사용 시 관련 정보 같이 전달 */
		String upperDeptCode = "";
		String upperDeptName = "";
		Map<String, String> upDeptInfo = ezApprovalGService.getUpperDeptInfo(userInfo.getDeptID(), userInfo.getTenantId());
		if (upDeptInfo.get("USEUPPERDEPTBOX") != null && upDeptInfo.get("USEUPPERDEPTBOX").equals("Y")) {
			upperDeptCode = upDeptInfo.get("upperDeptCode");
			upperDeptName = upDeptInfo.get("upperDeptName");
		}
		model.addAttribute("upperDeptCode", upperDeptCode);
		model.addAttribute("upperDeptName", upperDeptName);
		
		logger.debug("regCabinet ended");
		
		return "/ezApprovalG/apprGregCabinet";
	}
	
	/** 기록물철등록부 상세보기*/
	@RequestMapping(value = "/ezApprovalG/viewCabInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String viewCabInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("viewCabInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("viewCabInfo ended");
		
		return "/ezApprovalG/apprGviewCabInfo";
	}
	
	/** 기록물철등록부 상세보기*/
	@RequestMapping(value = "/ezApprovalG/getCabinetDetailInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/getCabSCInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/printFormCabInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/changeCabinetInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String changeCabinetInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("changeCabinetInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("changeCabinetInfo ended");
		
		return "/ezApprovalG/apprGchangeCabinetInfo";
	}
	
	/** 기록물철등록부 수정버튼*/
	@RequestMapping(value = "/ezApprovalG/getCabinetSimpleInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/changeCabInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/viewCabHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String viewCabHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("viewCabHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("viewCabHistory ended");
		return "/ezApprovalG/apprGviewCabHistory";
	}
	
	/** 기록물철등록부 이력보기 화면 상세내용*/
	@RequestMapping(value = "/ezApprovalG/getCabinetHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/searchCab.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String searchCab(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("searchCab started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		StringBuilder yearOption = new StringBuilder("");
		int curYear = Integer.parseInt(EgovDateUtil.getTodayTime().substring(0, 4));
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String useDeptSearchCab = ezCommonService.getTenantConfig("useDeptSearchCab", userInfo.getTenantId());

		yearOption.append("<Option Value=\"\"></Option>");
		
		for (int i = curYear; i >= curYear - 5; i--) {
			yearOption.append("<Option Value=\"" + Integer.toString(i) + "\">" + Integer.toString(i) + "</Option>");
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("yearOption", yearOption.toString());
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("useDeptSearchCab", useDeptSearchCab);

		logger.debug("searchCab ended");
		
		return "/ezApprovalG/apprGsearchCab";
	}
	
	/** 기록물철등록부 업무담당자 지정  */
	@RequestMapping(value = "/ezApprovalG/setTaskChrger.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String setTaskChrger(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setTaskChrger started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("setTaskChrger ended");
		
		return "/ezApprovalG/apprGsetTaskChrger";
	}
	
	/** 기록물철등록부 업무담당자지정 상세내용  */
	@RequestMapping(value = "/ezApprovalG/getTaskCharger.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/saveCabRoleInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/searchDelivery.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String searchDelivery(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("searchDelivery started");
		
		//2019.03.25 천성준 - 사용안해서 일단 주석
		//userInfo = commonUtil.aprUserInfo(loginCookie);
		
		logger.debug("searchDelivery ended");
		return "ezApprovalG/apprGsearchDelivery";
	}
	
	/** 기록물배부대장 추가배부  */
	@RequestMapping(value = "/ezApprovalG/getCheckEndHref.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/addBebu.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/selectReceipts.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezApprovalG/resendEndDoc.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/getRecSCInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/UpdateProcessYN.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/GetDocInfoMode.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/getMailAddress.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/mail_intersend.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public void mailInterSend(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, @RequestParam String targetUserId, @RequestParam int subType) throws Exception{
		logger.debug("mail_intersend started. subType: {}", subType);
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		// 받는 사람 알림환경설정 체크
		if (ezPersonalService.hasNotiDiableItem(targetUserId, NotiType.valueOf(2, subType), NotiPlatform.MAIL, userInfo.getTenantId())) {
			logger.debug("mail_intersend ended");
			return;
		}

		String Subject = request.getParameter("Subject");
		String Content = request.getParameter("Content");
        
        String content = commonUtil.createNotiMailContent(Content, userInfo.getTenantId(), userInfo.getLocale()); 
        
    	InternetAddress from = new InternetAddress();
    	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
    	from.setAddress(userInfo.getEmail());
    	
    	InternetAddress to1 = new InternetAddress();
    	String to[] = request.getParameter("to").split(",");
    	to1.setPersonal(to[0], "UTF-8");
    	to1.setAddress(to[1]);
    	
    	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to1}, null, null, Subject, content, false);
    	
    	logger.debug("mail_intersend ended");
	}
	
	/** 전자결재 G 자동 알림 메일 */
	@RequestMapping(value = "ezApprovalG/getReceiverList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "ezApprovalG/saveSingInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "ezApprovalG/mngUserCont.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
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
	@RequestMapping(value = "ezApprovalG/getContName.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
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
	@RequestMapping(value = "ezApprovalG/insertUserCont.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "ezApprovalG/getUserContSubTree.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "ezApprovalG/updateUserCont.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "ezApprovalG/deleteUserCont.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "ezApprovalG/selectContainer.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
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
	@RequestMapping(value = "ezApprovalG/getContUseGroup.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "ezApprovalG/selUserCont.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
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
	@RequestMapping(value = "ezApprovalG/setUserContDoc.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/getUserContList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getUserContList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getUserContList started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		Document xmldomsub = null;
		String pContID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String pPageNum = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String pPageSize = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		
		Map<String, Object> queryMap = new HashMap<>();
		String p_UserLang = userInfo.getLang();
		
		if (xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent().length() > 10) {
            try {
            	String TempQuery = "";
            	
            	xmldomsub = commonUtil.convertStringToDocument(xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent());
                TempQuery = xmldomsub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
                
				String qOptionDocNo = "";
				String qOptionDocTitle = "";
				String qOptionWriterName = "";
				
                if (TempQuery.indexOf("DOCNO;") != -1) {
					qOptionDocNo = xmldomsub.getElementsByTagName("DOCNO").item(0).getTextContent();
                }
                if (TempQuery.indexOf("DOCTITLE;") != -1) {
					qOptionDocTitle = xmldomsub.getElementsByTagName("DOCTITLE").item(0).getTextContent();
                }
				if (TempQuery.indexOf("WRITERNAME;") != -1) { // 다국어 처리 쿼리단으로 이동
					qOptionWriterName = xmldomsub.getElementsByTagName("WRITERNAME").item(0).getTextContent();
				}
				
				queryMap.put("qOptionDocNo", qOptionDocNo);
				queryMap.put("qOptionDocTitle", qOptionDocTitle);
				queryMap.put("qOptionWriterName", qOptionWriterName);
				queryMap.put("p_UserLang", p_UserLang);
				
				String qOptionStartDateAF = "";
				String qOptionStartDateBF = "";
				String qOptionEndDateAF = "";
				String qOptionEndDateBF = "";
				
                if (TempQuery.indexOf("STARTDATEAF;") != -1) { // 등록일자 시작 (년-월-일 형태로 전달됨, 시:분:초 추가)
					qOptionStartDateAF = commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("STARTDATEAF").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), true);
                }
                if (TempQuery.indexOf("STARTDATEBF;") != -1) { // 등록일자 종료
					qOptionStartDateBF = commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("STARTDATEBF").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true);
                }
                if (TempQuery.indexOf("ENDDATEAF;") != -1) { // 완료일자 시작
					qOptionEndDateAF = commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("ENDDATEAF").item(0).getTextContent(), userInfo.getOffset(), true);
                }
                if (TempQuery.indexOf("ENDDATEBF;") != -1) { // 완료일자 종료
					qOptionEndDateBF = commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("ENDDATEBF").item(0).getTextContent(), userInfo.getOffset(), true);
                }
                
				queryMap.put("qOptionStartDateAF", qOptionStartDateAF);
				queryMap.put("qOptionStartDateBF", qOptionStartDateBF);
				queryMap.put("qOptionEndDateAF", qOptionEndDateAF);
				queryMap.put("qOptionEndDateBF", qOptionEndDateBF);
				
				String qOptionFormName = "";
				String qOptionWriterDeptName = "";
				String qOptionKeyword = "";
				String qOptionItemcode = "";
				
                if (TempQuery.indexOf("FORMID;") != -1) {
					//2021-08-26 김성준 개인문서함 폼양식명으로 검색하도록 수정
					//ReturnQuery += " AND TBL_ENDAPRDOCINFO.FormID = '" + xmldomsub.getElementsByTagName("FORMID").item(0).getTextContent() + "' ";
					qOptionFormName = xmldomsub.getElementsByTagName("FORMID").item(0).getTextContent();
                }
				if (TempQuery.indexOf("WRITERDEPTNAME;") != -1) { // 다국어 처리 쿼리단으로 이동
					qOptionWriterDeptName = xmldomsub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent();
				}
                
                // 2021-03-16 박기범 - 키워드 검색 추가
				if (TempQuery.indexOf("KAPR;") != -1 || TempQuery.indexOf("KEND;") != -1) {
					qOptionKeyword = xmldomsub.getElementsByTagName("KEYWORD").item(0).getTextContent();
				}
				
                if (TempQuery.indexOf("CAPR;") != -1 || TempQuery.indexOf("CEND;") != -1) {
					qOptionItemcode = xmldomsub.getElementsByTagName("ITEMCODE").item(0).getTextContent();
                }
                
				queryMap.put("qOptionFormName", qOptionFormName);
				queryMap.put("qOptionWriterDeptName", qOptionWriterDeptName);
				queryMap.put("qOptionKeyword", qOptionKeyword);
				queryMap.put("qOptionItemcode", qOptionItemcode);
				
            } catch (Exception Ex) {
            	logger.error(Ex.getMessage(), Ex);
            }
        }

        String oc = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent(); // orderCell
        String oo = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent(); // orderOption
        String result = ezApprovalGService.getUserContList(pContID, pPageSize, pPageNum, oc, oo, userInfo.getCompanyID(), userInfo.getLang(), xmldomsub, userInfo.getTenantId(), userInfo.getOffset(), userInfo.getId(), queryMap);
        
		logger.debug("getUserContList ended");

		return result;
	}
	
	
	/** 전자결재 개인 문서함 리스트 내보내기 (엑셀 다운로드) */
	@RequestMapping(value = "/ezApprovalG/getUserContListSave.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public void getUserContListSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getUserContListSave started");
		
		//StringBuilder resultExcel = new StringBuilder(); //2019.03.25 천성준 - 사용안해서 일단 주석
		String excelValue = "";
		Map<String, Object> queryMap = new HashMap<>();
		
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
		
		String p_UserLang = userInfo.getLang();

		if (xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent().length() > 10) {
            try {
            	String TempQuery = "";
				String qOptionDocNo = "";
				String qOptionDocTitle = "";
				String qOptionWriterName = "";
            	
            	xmldomsub = commonUtil.convertStringToDocument(xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent());
                TempQuery = xmldomsub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
                
                if (TempQuery.indexOf("DOCNO;") != -1) {
					qOptionDocNo = xmldomsub.getElementsByTagName("DOCNO").item(0).getTextContent();
                }
                if (TempQuery.indexOf("DOCTITLE;") != -1) {
					qOptionDocTitle = xmldomsub.getElementsByTagName("DOCTITLE").item(0).getTextContent();
                }
				if (TempQuery.indexOf("WRITERNAME;") != -1) { // 다국어 처리 쿼리단으로 이동
					qOptionWriterName = xmldomsub.getElementsByTagName("WRITERNAME").item(0).getTextContent();
				}
				
				queryMap.put("qOptionDocNo", qOptionDocNo);
				queryMap.put("qOptionDocTitle", qOptionDocTitle);
				queryMap.put("qOptionWriterName", qOptionWriterName);
				queryMap.put("p_UserLang", p_UserLang);

				String qOptionStartDateAF = "";
				String qOptionStartDateBF = "";
				String qOptionEndDateAF = "";
				String qOptionEndDateBF = "";
				
            	if (TempQuery.indexOf("STARTDATEAF;") != -1) { // 등록일자 시작 (년-월-일 형태로 전달됨, 시:분:초 추가)
					qOptionStartDateAF = commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("STARTDATEAF").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), true);
                }
                if (TempQuery.indexOf("STARTDATEBF;") != -1) { // 등록일자 종료
					qOptionStartDateBF = commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("STARTDATEBF").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true);
                }
                if (TempQuery.indexOf("ENDDATEAF;") != -1) { // 완료일자 시작
					qOptionEndDateAF = commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("ENDDATEAF").item(0).getTextContent(), userInfo.getOffset(), true);
                }
                if (TempQuery.indexOf("ENDDATEBF;") != -1) { // 완료일자 종료
					qOptionEndDateBF = commonUtil.getDateStringInUTC(xmldomsub.getElementsByTagName("ENDDATEBF").item(0).getTextContent(), userInfo.getOffset(), true);
                }
                
				queryMap.put("qOptionStartDateAF", qOptionStartDateAF);
				queryMap.put("qOptionStartDateBF", qOptionStartDateBF);
				queryMap.put("qOptionEndDateAF", qOptionEndDateAF);
				queryMap.put("qOptionEndDateBF", qOptionEndDateBF);
				
				String qOptionFormName = "";
				String qOptionWriterDeptName = "";
				String qOptionKeyword = "";
				String qOptionItemcode = "";
                
                if (TempQuery.indexOf("FORMID;") != -1) {
					qOptionFormName = xmldomsub.getElementsByTagName("FORMID").item(0).getTextContent();
                }
				if (TempQuery.indexOf("WRITERDEPTNAME;") != -1) { // 다국어 처리 쿼리단으로 이동
					qOptionWriterDeptName = xmldomsub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent();
				}
                if (TempQuery.indexOf("KAPR;") != -1 || TempQuery.indexOf("KEND;") != -1) {
					qOptionKeyword = xmldomsub.getElementsByTagName("KEYWORD").item(0).getTextContent();
                }
                if (TempQuery.indexOf("CAPR;") != -1 || TempQuery.indexOf("CEND;") != -1) {
					qOptionItemcode = xmldomsub.getElementsByTagName("ITEMCODE").item(0).getTextContent();
                }
                
				queryMap.put("qOptionFormName", qOptionFormName);
				queryMap.put("qOptionWriterDeptName", qOptionWriterDeptName);
				queryMap.put("qOptionKeyword", qOptionKeyword);
				queryMap.put("qOptionItemcode", qOptionItemcode);
				
            } catch (Exception Ex) {
            }
        }

        String oc = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent(); // orderCell
        String oo = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent(); // orderOption
        
        if (AllFG.equals("0")) {
        	excelValue = ezApprovalGService.getUserContList(pContID, pPageSize, pPageNum, oc, oo, userInfo.getCompanyID(), userInfo.getLang(), xmldomsub, userInfo.getTenantId(), userInfo.getOffset(), userInfo.getId(), queryMap);
        } else if(AllFG.equals("1")) {
        	excelValue = ezApprovalGService.getUserContListAll(pContID, pPageSize, pPageNum, oc, oo, userInfo.getCompanyID(), userInfo.getLang(), xmldomsub, userInfo.getTenantId(), userInfo.getOffset(), userInfo.getId(), queryMap);
        }
        
        Document objXML = commonUtil.convertStringToDocument(excelValue);
        // 2018-10-16 김보미 - 개인문서함 엑셀출력 workBook 이용해서 출력하도록 변경
        // 엑셀시작
        // 2023-05-31 이사라 : 시큐어코딩 리소스 close
        try (HSSFWorkbook workbook = new HSSFWorkbook()) {
			HSSFSheet sheet;
		
			// 헤더 폰트 굵게
			HSSFFont headerFont = workbook.createFont();
			headerFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
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
			    
			    /* 2024-11-05 홍승비 - 엑셀 파일 저장 시 동적인 너비 계산이 setColumnWidth()에서 허용하는 최대 제한을 넘지 않도록 수정 (255 * 256 = 65280) */
			    sheet.setColumnWidth(i, Math.min(65280, sheet.getColumnWidth(i) + 512));
			} // header
			
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
					sheet.setColumnWidth(k, Math.min(65280, sheet.getColumnWidth(k) + 512));
				}
			} // body

			workbook.write(response.getOutputStream());
			//workbook.close();
			logger.debug("getUserContListSave ended");
		}
	}
	
	/** 전자결재 일반 결재문서 첨부*/
	@RequestMapping(value = "ezApprovalG/aprDocAttach.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
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

		String draftAllFlag = request.getParameter("draftAllFlag") != null ? request.getParameter("draftAllFlag") : "N";
		String anNo = request.getParameter("anNo") != null ? request.getParameter("anNo") : "0";
        
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
        
        //2021-03-05 남학선 첨부를 올린사람 이외의 사람도 삭제가능여부를  결정하는 테넌트 값
        String delAttachByOthers = ezCommonService.getTenantConfig("delAttachByOthers", userInfo.getTenantId()).equals("") ? "0" : ezCommonService.getTenantConfig("delAttachByOthers", userInfo.getTenantId());
        
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
		model.addAttribute("delAttachByOthers", delAttachByOthers);
		model.addAttribute("draftAllFlag", draftAllFlag);
		model.addAttribute("anNo", anNo);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		logger.debug("aprDocAttach ended");
		
		return "ezApprovalG/apprGaprdocattach";
	}
	
	/** 전자결재 일반 문서첨부*/
	@RequestMapping(value = "/ezApprovalG/mgetDeptUseDocType.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/aprDocAttachList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String aprDocAttachList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception {
		logger.debug("aprDocAttachList started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		String SortHeader = xmlDom.getElementsByTagName("SortHeader").item(0) != null ? xmlDom.getElementsByTagName("SortHeader").item(0).getTextContent() : "";
		String sortType = xmlDom.getElementsByTagName("sortType").item(0) != null ? xmlDom.getElementsByTagName("sortType").item(0).getTextContent() : "";
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String contID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String pageNum = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String pageSize = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		
		String result = ezApprovalGService.getContDocListS(contID, userInfo.getId(), "", pageSize, pageNum, SortHeader, sortType, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo.getLocale());

		logger.debug("aprDocAttachList ended");
		
		return result;
	}
	
	/** 전자결재 개인 문서함 문서 삭제*/
	@RequestMapping(value = "/ezApprovalG/delUserContDoc.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	
	@RequestMapping(value = "ezApprovalG/setCabinetHesong.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/selectEnc.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezApprovalG/searchOrganGList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezApprovalG/searchOrganGListData.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String searchOrganGListData(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception {
		logger.debug("searchOrganGListData started");
		//userInfo = commonUtil.userInfo(loginCookie); //2019.03.25 천성준 - 사용안해서 일단 주석
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String keyword = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
        String strFilter = "(&(ou=*" + keyword + "*)(objectclass=ucorg2))";
        int intScope = 3;
        String strXML = ezOrganService.searchOuterOrgan(strFilter, intScope);
        
		logger.debug("searchOrganGListData ended");
		return strXML;
	}
	
	/**
	 * 2020-04-23 : 외부 수신처 검색 후 조직도 이동 시 검색정보
	 * 
	 * @throws Exception
	 */	
	@RequestMapping(value = "/ezApprovalG/searchOrganGListDataTreeView.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String searchOrganGListDataTreeView(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception {
		logger.debug("searchOrganGListDataTreeView started");

		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String parentoucode = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String selcode = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        String strXML = "<DATA><ROWS>";
        int intScope = 3;
		
		strXML += "<ROW><PARENTCODE>" + parentoucode + "</PARENTCODE><SELCODE>"  + selcode + "</SELCODE></ROW>";

		int searchCnt = 0;
		boolean read = true;
		while(read && searchCnt < 10){
			if(!parentoucode.equals("0000000")){

				String strFilter = "(&(oucode=" + parentoucode + ")(objectclass=ucorg2))";
				String tmpXML = ezOrganService.searchOuterOrgan(strFilter, intScope);

				Document parentDom = commonUtil.convertStringToDocument(tmpXML);

				parentoucode = parentDom.getElementsByTagName("DATA5").item(0).getTextContent();
				selcode = parentDom.getElementsByTagName("DATA1").item(0).getTextContent();

				strXML += "<ROW><PARENTCODE>" + parentoucode + "</PARENTCODE><SELCODE>"  + selcode + "</SELCODE></ROW>";

				searchCnt = searchCnt + 1;
			}else{
				read = false;
			}
		}

		strXML += "</ROWS></DATA>";

		logger.debug("searchOrganGListDataTreeView ended");
		return strXML;
	}	

	/**
	 * 외부 수신처 이름 수정 팝업창 호출
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezApprovalG/aprDeptName.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String aprDeptName(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("aprDeptName started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		
		logger.debug("aprDeptName ended");
		return "/ezApprovalG/apprGaprDeptName";
	}

	/**
	 * 외부 수신처 발송 시 코드 xml 화
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezApprovalG/getencodeinfoxXML.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getencodeinfoxXML(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("getencodeinfoxXML started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
        String realPath = commonUtil.getRealPath(request);
		String filePath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "encodeinfo.xml";
		
		File file = new File (commonUtil.detectPathTraversal(filePath));
		String FileText = "";
		StringBuilder result = new StringBuilder();

		// CWE-404 보안 취약점 대응
		try (BufferedReader br = new BufferedReader(new FileReader(file))) {
			while ((FileText = br.readLine()) != null) {
				result.append(FileText);
			}
		}
		logger.debug("getencodeinfoxXML ended");
		return result.toString();
	}

	/**
	 * 외부 수신처 발송 시 문서 정보
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezApprovalG/getEndDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getEndDocInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("getEndDocInfo started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
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
	@RequestMapping(value = "/ezApprovalG/getContentXml.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getContentXml(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("getContentXml started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String useHWP = ezCommonService.getTenantConfig("useHWP", userInfo.getTenantId());
		
        String fontFamily = request.getParameter("fontFamily");
		String fontSize = request.getParameter("fontSize"); 
		String content = request.getParameter("content");
		String docType = request.getParameter("docType");

		String result = "";
		if("YES".equals(useHWP) && !"MHT".equals(docType)) {
			result = ezApprovalGService.startXmlConvertHwp(content, fontFamily, fontSize, userInfo);
		} else {
			result = ezApprovalGService.startXmlConvert(content, fontFamily, fontSize, userInfo);
		}
		logger.debug("getContentXml ended");
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/getLineInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getLineInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception {
		logger.debug("getLineInfo started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String docID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();

		String result = ezApprovalGService.getAprLineXmlForExt(docID, userInfo);
		logger.debug("getLineInfo ended");
		return result;
	}

	@RequestMapping(value = "/ezApprovalG/simsaGUpload.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String simsaGUpload(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception {
		logger.debug("simsaGUpload started");
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String docID = request.getParameter("docID");
		StringBuilder saveXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"euc-kr\"?><?xml-stylesheet type=\"text/xsl\" href=\"siheng.xsl\"?><!DOCTYPE pubdoc SYSTEM \"pubdoc.dtd\">");
		saveXML.append(xmlPara.replace("\n", "").replace("\t", "").replace("&amp;nbsp;", " ").replace("&amp;gt;", "&gt;").replace("&amp;lt;", "&lt;").replace("﻿", ""));
		String realPath = commonUtil.getRealPath(request);
		String savePath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator	+ "sendXML"	+ commonUtil.separator + docID + "pubdoc.xml";
 		boolean saveFlag = false;
		String result = null;
		try {
			char intxt[] = new char[saveXML.toString().length()];
			saveXML.toString().getChars(0, saveXML.toString().length(), intxt, 0); // 입력하고자 하는 문자열을 문자 배열 intxt에 저장

			File file = new File(commonUtil.detectPathTraversal(realPath + savePath));
			// CWE-404 보안 취약점 대응
			try (FileOutputStream fop = new FileOutputStream(file)) {
				// get the content in bytes
				fop.write(saveXML.toString().getBytes("euc-kr"));
				fop.flush();
			}

			saveFlag = true;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
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

	@RequestMapping(value = "/ezApprovalG/checkPubDocXML.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String checkPubDocXML(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("checkPubDocXML started");
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String xmlPath = request.getParameter("xmlPath");
		String mapPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID();

		String result = ezApprovalGService.checkPubDocXML(mapPath + xmlPath);
		logger.debug("checkPubDocXML ended");
		return result;
	}

	@RequestMapping(value = "/ezApprovalG/sendMsg2.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String sendMsg2(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("sendMsg2 started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
 
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
	
	@RequestMapping(value = "/ezApprovalG/sendMsg.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String sendMsg(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("sendMsg started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		 
		String extXML = request.getParameter("extXML");
		Document xmlDom = commonUtil.convertStringToDocument(extXML);
		String mapPath = commonUtil.getRealPath(request);
		String xmlPath = request.getParameter("xmlPath");
		String path = mapPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "sendXML" + commonUtil.separator + xmlPath;
		
		String docID = request.getParameter("docID");
		
		logger.debug("xmlPath=" + xmlPath);
		
		//pubdoc 의 컨텐츠가 있는지 확인하여 내용이 없으면 senderr/temp 폴더로 이동
        String sendPath = "senderr" + commonUtil.separator + "temp";
		
		xmlDom.getElementsByTagName("send-gw").item(0).setTextContent(Base64.encodeBase64String(xmlDom.getElementsByTagName("send-gw").item(0).getTextContent().getBytes("euc-kr")));
		xmlDom.getElementsByTagName("send-name").item(0).setTextContent(Base64.encodeBase64String(xmlDom.getElementsByTagName("send-name").item(0).getTextContent().getBytes("euc-kr")));
		xmlDom.getElementsByTagName("title").item(0).setTextContent(Base64.encodeBase64String(xmlDom.getElementsByTagName("title").item(0).getTextContent().getBytes("euc-kr")));
		xmlDom.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").setNodeValue(Base64.encodeBase64String(xmlDom.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").getNodeValue().getBytes("euc-kr")));
		xmlDom.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").setNodeValue(Base64.encodeBase64String(xmlDom.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").getNodeValue().getBytes("euc-kr")));

		for (int i = 0; i < xmlDom.getElementsByTagName("content").getLength(); i++) {
				switch (xmlDom.getElementsByTagName("content").item(i).getAttributes().getNamedItem("content-role").getNodeValue()) {
				case "pubdoc":
					
					//pubdoc xml String으로 추출
                    String pubdocString = xmlDom.getElementsByTagName("content").item(i).getTextContent();
                    System.out.println("pubdocString: " + pubdocString);

                    int sIndex = pubdocString.indexOf("<content>") + 9;
                    int eIndex = pubdocString.indexOf("</content>");
                    
                    String contentStr = pubdocString.substring(sIndex , eIndex).trim(); 

                    if(contentStr.length() > 0) {
                    	sendPath = "sendtemp";
                    }
                    
                    System.out.println("sendPath: " + sendPath);
					
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
			File file = new File(commonUtil.detectPathTraversal(path));
			fop = new FileOutputStream(file);
			fop.write(xmlData.getBytes("utf-8"));
			fop.flush();
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (fop != null) {
				try { fop.close(); } catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
		}
		
		xmlData = xmlData.replace("<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">", "");
	    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
//	    factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
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
//        for (String recevID : arrReceiveID) {
//        	result = ezApprovalGService.getFileName(mapPath, sendID + recevID + strTime, "sendtemp", strXML, userInfo.getTenantId());
//        	
//        	if (result.equals("FALSE")) {
//        		logger.debug("sendMsg Fail : " + sendID + recevID + strTime);
//        		
//        		return result;
//        	}
//		}
        
        // 여러부서 보낼수 있게 수정 -> 문서유통센터에서 전화옴 19.12.18
        // 문서유통센터에서 전화옴 19.12.18 xml 파일 하나 떨구는 걸로 변경
        logger.debug("####sendPath : " + sendPath);
        logger.debug("####mapPath : " + mapPath);
        logger.debug("####sendID : " + sendID);
        logger.debug("####recevID : " + arrReceiveID[0]);
        logger.debug("####strTime : " + strTime);
        
        Map<String, Object> sendOutMap = new HashMap<String, Object>();
        
        sendOutMap.put("V_DOCID", docID);
        sendOutMap.put("V_WRITERID", userInfo.getId());
        sendOutMap.put("V_WRITERNAME", userInfo.getDisplayName());
        sendOutMap.put("V_WRITERDEPTID", userInfo.getDeptID());
        sendOutMap.put("V_WRITERDEPTNAME", userInfo.getDeptName());
        sendOutMap.put("V_TENANT_ID", userInfo.getTenantId());
        sendOutMap.put("V_COMPANYID", userInfo.getCompanyID());
        
        result = ezApprovalGService.getFileName(sendOutMap, mapPath, sendID + arrReceiveID[0] + strTime, sendPath, strXML, userInfo.getTenantId());
        
        if (result.equals("FALSE")) {
               logger.debug("sendMsg Fail : " + sendID + arrReceiveID[0] + strTime);
               return result;
        }

        logger.debug("sendMsg ended");
        return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/cert.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String cert(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("cert started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		logger.debug("cert ended");
		return "/ezApprovalG/apprGcert";
	}
	
	
	@RequestMapping(value = "/ezApprovalG/getRelayDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getRelayDocInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("getRelayDocInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
/*		String currCompanyID = request.getParameter("companyID"); // 2023-03-29 홍승비 - 전자결재 사간겸직 상태에서 겸직부서의 대외수신문서 접근 시, 해당 회사의 ID 사용 
		
		if (currCompanyID != null && !currCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(currCompanyID);
		}*/
		
		String result = ezApprovalGService.getRelayInfo(docID, userInfo);
		
		logger.debug("getRelayDocInfo ended");
		return result;
	}
	
	
	@RequestMapping(value = "/ezApprovalG/loadDocXML.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String loadDocXML(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("loadDocXML started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String result = "";
		String xmlPath = request.getParameter("XMLPATH");
		String strContent = "";
		try {
			 Document xmlDoc = commonUtil.xmlLod(commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + xmlPath);
			 
			 strContent = commonUtil.convertDocumentToString(xmlDoc);
			 
			 //문서유통 본문 내용이 없을 경우 공백으로 들어가도록 처리. textContent를 strContent로 넣으면 폰트 스타일이 다 사라짐. 2019-12-13 홍대표
			 if("".equals(xmlDoc.getElementsByTagName("content").item(0).getTextContent())) {
				 strContent = "";
			 } else {
				 strContent = strContent.substring(strContent.indexOf("<content>"),strContent.indexOf("</content>")).replace("<content>", "");
			 }
			 
			 strContent = "<![CDATA[" + strContent + "]]>";
			
			 xmlDoc.getElementsByTagName("content").item(0).setTextContent("");
			 xmlDoc.getElementsByTagName("content").item(0).setTextContent(strContent);
			
			 result = "<?xml version=\"1.0\" encoding=\"utf-8\"?>" + commonUtil.convertDocumentToString(xmlDoc).substring(commonUtil.convertDocumentToString(xmlDoc).indexOf("<pubdoc>"), commonUtil.convertDocumentToString(xmlDoc).length());
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("loadDocXML ended");
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/setHref.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setHref(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("setHref started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String fileType = request.getParameter("fileType");
		String mode = request.getParameter("mode");
		
		String result = ezApprovalGService.setHref(docID, fileType, mode, userInfo);
		logger.debug("setHref ended");
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/setRecvDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setRecvDocInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("setRecvDocInfo started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
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
	
	@RequestMapping(value = "/ezApprovalG/setRecvComplete.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setRecvComplete(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("setRecvComplete started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
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
	@RequestMapping(value = "/ezApprovalG/lastKyulJeHabYuiYN.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	
	@RequestMapping(value = "/ezApprovalG/sendAckforReSend.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String sendAckforReSend(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("sendAckforReSend started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String type = request.getParameter("type");
		String userName = request.getParameter("userName");
		String userDeptName = request.getParameter("userDeptName");
		String errMsg = request.getParameter("errMsg");
		
		if (userDeptName == null) {
			userDeptName = "";
		}

		String result = ezApprovalGService.sendAck(docID, type, userName, userDeptName, errMsg, userInfo.getCompanyID(), userInfo.getTenantId());
		logger.debug("sendAckforReSend ended");
		return result;
	}
	
	/** 전자결재 후결 승인*/
	@RequestMapping(value = "/ezApprovalG/setWhoKyulUpdate.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezApprovalG/getWhoKyulSignInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	
	/** 전자결재 후결 왼쪽 카운트 (일반버전) */
	@RequestMapping(value = "/ezApprovalG/getContDocCount.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getContDocCount(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getContDocCount started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String contID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
        String subQuery = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        
        /* 2024-03-07 홍승비 - 전자결재 일반버전에서만 사용 가능한 후결 기능의 SQL Injection 수정 (G버전에서는 테스트 불가능) */
		String result = ezApprovalGService.getContDocListS(contID, userInfo.getId(), subQuery, "1", "0", "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo.getLocale());

		xmlDom = commonUtil.convertStringToDocument(result);
		logger.debug("result = " + result);
		logger.debug("getContDocCount ended");
	return "<RESULT>" + xmlDom.getElementsByTagName("TOTALCNT").item(0).getTextContent() + "</RESULT>";
	}
	
	/** 전자결재 참조 원기안문서 진행상태*/
	@RequestMapping(value = "/ezApprovalG/getLineMode.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
	
	/** 원문공개정보 수정 */
	@RequestMapping(value = "/ezApprovalG/changeOpenGovInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String changeOpenGovInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("changeOpenGovInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("changeOpenGovInfo ended");
		
		return "ezApprovalG/apprGchangeOpenGovInfo";
	}
	
	/** 원문공개정보 수정 상세화면 */
	@RequestMapping(value = "/ezApprovalG/getOpenGovSimpleInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getOpenGovSimpleInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model , @RequestBody String xmlPara) throws Exception{
		logger.debug("getOpenGovSimpleInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getRecordSimpleInfo(xmlDom,userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
        
        logger.debug("getOpenGovSimpleInfo ended");
        
		return result;
	}
	
	/** 2022-07-20 홍승비 - 기록물철등록부 > 기록물보기로 진입 시 해당 기록물철의 생산년도를 가져오기 위한 AJAX용 메서드 */
	@RequestMapping(value = "/ezApprovalG/getCabProduceYear.do", method = RequestMethod.GET)
	@ResponseBody
	public String getCabProduceYear(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getCabProduceYear started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		String cabinetClassNo = request.getParameter("cabinetClassNo");
		
		String result = ezApprovalGService.getCabProduceYear(cabinetClassNo, companyID, userInfo.getTenantId());
		
		logger.debug("getCabProduceYear ended, result = " + result);
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/readingRecord.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String readingCabinet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("readingRecord Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String sFlag = "m01";
		String shareDeptId = (request.getParameter("shareDeptId") != null ? request.getParameter("shareDeptId") : "");
		String contType = "END";
		String dirpath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + "doc";
		String deptInfo = "";
		String buJaeInfo = "";
		String susinAdmin = "";
    	// OCS 사용 여부
	    String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
	    String userEmail = userInfo.getEmail();
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
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("dirpath", dirpath);
		model.addAttribute("deptInfo", deptInfo);
		model.addAttribute("buJaeInfo", buJaeInfo);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("userEmail", userEmail);
		model.addAttribute("openYear", openYear);
		model.addAttribute("contType", contType);
		model.addAttribute("sFlag", sFlag);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("shareDeptId", shareDeptId);
        model.addAttribute("previewInfo", previewInfo);
		model.addAttribute("useAprPreview", useAprPreview);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("useDraftAll", ezCommonService.getTenantConfig("useDraftAll", userInfo.getTenantId()));
		model.addAttribute("useReceiveInfoName", ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId()));
		
		logger.debug("readingRecord ended");
		
		return "ezApprovalG/apprGreadingRecord";
	}
}
