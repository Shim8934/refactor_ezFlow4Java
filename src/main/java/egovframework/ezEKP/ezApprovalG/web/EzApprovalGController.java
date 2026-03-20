package egovframework.ezEKP.ezApprovalG.web;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAI.util.AICommonUtil;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.service.impl.EzApprovalGKlibServiceImpl;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGContInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGGroupDocInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpenGovAttachVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpenGovInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpinionVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiveDocVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSecondApprVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSummaryVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSusinProcessInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezApprovalG.vo.KEDSharedUserInfo;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganProxyVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopOtherCompanyAddJobVO;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.KlibUtil;
import egovframework.let.utl.fcc.service.EzFAL;
import egovframework.let.utl.fcc.service.EzFAL.*;
import egovframework.let.utl.rest.Result;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDeliveryListVO;

import java.io.BufferedInputStream;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilderFactory;

import kr.dogfoot.hwplib.object.HWPFile;
import kr.dogfoot.hwplib.reader.HWPReader;
import kr.dogfoot.hwplib.tool.objectfinder.CellFinder;
import kr.dogfoot.hwplib.tool.objectfinder.FieldFinder;
import kr.dogfoot.hwplib.tool.textextractor.TextExtractMethod;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpStatus;
import org.apache.logging.log4j.util.Strings;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.HandlerMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;


/** 
 * @Description [Controller] 사용자 - 전자결재G
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.22    황윤진         신규작성
 *
 * @see
 */

@Controller
public class EzApprovalGController extends EzFileMngUtil{
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGController.class);

	@Autowired
	private CommonUtil commonUtil;
	
 	@Autowired
    private AICommonUtil aICommonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private ServletContext servletContext;

	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "crypto") 
    private EgovFileScrty egovFileScrty;

	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzApprovalGAdminService")
	private EzApprovalGAdminService ezApprovalGAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name="EzCabinetAdminService")
	private EzCabinetAdminService cabinetAdminService;
	
	@Resource(name="MApprovalGService")
	private MApprovalGService mApprovalGService;
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	@Autowired
	private EgovMessageSource messageSource;
	
	@Autowired
	private KlibUtil klibUtil;

	@Value("#{globals['Globals.DbType']}")
	private String dbType;
	/**
	 * 전자결재G 메인화면 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/apprGMain.do", method = RequestMethod.GET)
	public String apprGMain(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, HttpServletResponse response){
		logger.debug("apprGMain Started");
		
		int listType = 1;
		String leftFrameWidth = "220";
		int width = 0;
		
		if (request.getParameter("listType") != null) {
			listType = Integer.parseInt(request.getParameter("listType"));
		}

		if (request.getParameter("__wwidth") != null) {
			String widthParam = request.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String dashBoard = "N";
		try {
			dashBoard = ezCommonService.getUserConfigInfo(userInfo.getTenantId(), userInfo.getId(), "dashBoard");
		} catch (Exception e) {
			dashBoard = "N";
		}
		
		if (listType == 25) {
			if (("N").equals(dashBoard)){
				listType = 1;
			} 
		}
		
		model.addAttribute("listType", listType);
		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		logger.debug("apprGMain ended");
		
		return "ezApprovalG/apprGMain";
	}

	/**
	 * 전자결재G LEFT화면 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/apprGLeft.do", method = RequestMethod.GET)
	public String apprGLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
        logger.debug("apprGLeft Started");
        
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
		
        logger.debug("apprGLeft Value : sendOutDept=" + sendOutDept + ", optGamsabu=" +optGamsabu);

		if (sendOutDept != null && sendOutDept.toUpperCase().indexOf(userInfo.getDeptID().toUpperCase()) > -1) {
			userSendOut = "YES";
		}

		String infoXML = ezOrganService.getPropertyValue(userInfo.getDeptID(), "extensionAttribute4", userInfo.getTenantId());
		String relayShowFlag = "N";
		// 개인의 심사자 권한도 체크하도록 추가해줌.
		if (infoXML != null && infoXML.equals(config.getProperty("config.companyNum", "")) && userInfo.getRollInfo().contains("i=1")) {
		    relayShowFlag = "Y";
		}
		
		List<Object> referenceTemp = new ArrayList<Object>();
		referenceTemp.add(subTitleString);
		referenceTemp.add(isSubTitle);
		
		if (!"Y".equals(ezCommonService.getTenantConfig("switchUserCompany", userInfo.getTenantId()))) {
			getUserSubTitle(userInfo, referenceTemp);
		}
		
		String autoSendOfferFlag = ezCommonService.getTenantConfig("autoSendOfferFlag", userInfo.getTenantId());

		//개인 수신함 사용 여부
		String personalHideSusin =  ezCommonService.getTenantConfig("PersonalHideSusin", userInfo.getTenantId());

		//개인문서함 사용 여부
		String useUserCont =  ezCommonService.getTenantConfig("useUserCont", userInfo.getTenantId());
		model.addAttribute("useUserCont", useUserCont);
		if ("YES".equals(useUserCont)) {
			userCont = ezApprovalGService.getUserContTree(userInfo.getId(), "ROOT", userInfo.getDeptName(), userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale());
			model.addAttribute("userCont", userCont);
		}
        
		if(approvalFlag.equals("S")) {
			String useApprFormCont = ezCommonService.getTenantConfig("useApprFormCont", userInfo.getTenantId());
			model.addAttribute("useApprFormCont", useApprFormCont);
			if (useApprFormCont != null && useApprFormCont.equals("YES")) {
				/* 2024-11-14 홍승비 - 양식별 문서함 다국어 처리 */
				List<ApprGFormVO> itemList = ezApprovalGService.getFormContainer(userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getLang(), userInfo.getId());
				model.addAttribute("itemList", itemList);
			}
			
			String useApprCodeCont = ezCommonService.getTenantConfig("useApprCodeCont", userInfo.getTenantId());
			model.addAttribute("useApprCodeCont", useApprCodeCont);
			if (useApprCodeCont != null && useApprCodeCont.equals("YES")) {
				List<ApprGTaskVO> taskItemList = ezApprovalGService.getCodeContainer(userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getDeptID(), commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()), approvalFlag, userInfo.getLang());
				model.addAttribute("taskItemList", taskItemList);
			}
			 
			List<ApprGContInfoVO> apprContInfoVOs2 = ezApprovalGService.getSpecialContTree(userInfo);

			int subContCount = 0;
			
			for (int k = 0; k < apprContInfoVOs2.size(); k++) {
				if (!apprContInfoVOs2.get(k).getContType().equals("005")) { //심사할 문서만 제외
					subContCount += 1;
				}
			}
			
			/* 2024-11-14 홍승비 - 개인공유함, 부서공유함 다국어 처리 */
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
		model.addAttribute("subTitleString", referenceTemp.get(0));
		model.addAttribute("isSubTitle", referenceTemp.get(1));
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
		model.addAttribute("personalHideSusin", personalHideSusin);
		model.addAttribute("draftAllTypeB", ezCommonService.getTenantConfig("draftAllTypeB", userInfo.getTenantId()));
		
        logger.debug("apprGLeft Value : listType= " + listType + "containers= " + containers.toString() + "viewLeftCount= " + viewLeftCount);       
        logger.debug("apprGLeft Ended");

		return "ezApprovalG/apprGLeft";
	}

	/**
	 * 전자결재G 서브타이틀 실행 Method
	 */
	public void getUserSubTitle(LoginVO userInfo, List<Object> referenceTemp) throws Exception{
        logger.debug("getUserSubTitle started");       

		// 2023-08-28 전인하 - 전자결재 > 좌측 겸직 변경 드롭다운 > JobId 정보 조회 위해 로직 변경 -
		// extensionAttribute4의 정보만 조회하여 리스트를 구성하는 것에서, 필요한 정보를 DB에서 가져오는 것으로 변경.
		// 해당 과정에 겸직 드롭다운 정렬이 포함됨.
		String propList = "extensionAttribute4;department;description;title;title2;description2;physicalDeliveryOfficeName;company;company2;extensionAttribute7";
		String results = ezOrganService.getPropertyList(userInfo.getId(), propList, userInfo.getPrimary(), userInfo.getTenantId());
		String myDept = "";
		String myTitle= "";
		String subTitleString = "";
		boolean isSubTitle = false;
		Document doc = commonUtil.convertStringToDocument(results);

		List<OrganUserVO> userAddJobList = ezOrganService.getAddJobListForEzApprDropdown(userInfo.getPrimary(), userInfo.getId(), userInfo.getTenantId());
        String deptID = doc.getElementsByTagName("DEPARTMENT").item(0).getTextContent();
        String deptName = doc.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
        String title = doc.getElementsByTagName("TITLE1").item(0).getTextContent();
        String deptName2 = doc.getElementsByTagName("DESCRIPTION2").item(0).getTextContent();
        String title2 = doc.getElementsByTagName("TITLE2").item(0).getTextContent();
        String companyID = doc.getElementsByTagName("PHYSICALDELIVERYOFFICENAME").item(0).getTextContent();
        String companyName = doc.getElementsByTagName("COMPANY").item(0).getTextContent();
        String companyName2 = doc.getElementsByTagName("COMPANY2").item(0).getTextContent();
		String extensionAttribute7 = doc.getElementsByTagName("EXTENSIONATTRIBUTE7").item(0).getTextContent();
        int deptListFlag = 0;
        
        myDept = userInfo.getPrimary().equals("1") ? deptName : deptName2;
		myTitle = userInfo.getPrimary().equals("1") ? title : title2;
		
        if (companyID.equals(userInfo.getCompanyID())) {
	        if (userInfo.getDeptID().equals(deptID)) {
	        	if (title.equals("")){
	        		subTitleString = "<option value='" + deptID + "|" + myDept + "|" + title + "|" + deptName + "|" + deptName2 + "|" + title + "|" + title2 + "|" + companyID + "|" + companyName + "|" + companyName2 + "|" + extensionAttribute7 + "'  selected >" + myDept + "</option>";
	        	} else {
	        		subTitleString = "<option value='" + deptID + "|" + myDept + "|" + title + "|" + deptName + "|" + deptName2 + "|" + title + "|" + title2 + "|" + companyID + "|" + companyName + "|" + companyName2 + "|" + extensionAttribute7 + "'  selected >" + myDept + "[" + myTitle + "]" + "</option>";
	        	}
	        } else {
	        	if (title.equals("")){
	        		subTitleString = "<option value='" + deptID + "|" + myDept + "|" + title + "|" + deptName + "|" + deptName2 + "|" + title + "|" + title2 + "|" + companyID + "|" + companyName + "|" + companyName2 + "|" + extensionAttribute7 + "' >" + myDept + "</option>";
	        	} else {
	        		subTitleString = "<option value='" + deptID + "|" + myDept + "|" + title + "|" + deptName + "|" + deptName2 + "|" + title + "|" + title2 + "|" + companyID + "|" + companyName + "|" + companyName2 + "|" + extensionAttribute7 + "' >" + myDept + "[" + myTitle + "]" + "</option>";
	        	}
	        }
	        deptListFlag++;
        }
		
		String lang = userInfo.getPrimary().equals("1") ? "" : "2";

        if (! userAddJobList.equals("")) {
        	for (int k = 0; k < userAddJobList.size(); k++) {
				OrganUserVO addJobVal = userAddJobList.get(k);
				String pDeptNM_ = commonUtil.cleanValue(addJobVal.getDescription());
                String pDeptNM1_ = commonUtil.cleanValue(addJobVal.getDescription1());
                String pDeptNM2_ = commonUtil.cleanValue(addJobVal.getDescription2());
				// 2023-10-06 전인하 - 전자결재 > 좌측메뉴 겸직선택 드롭다운 > 겸직 드롭다운 조작 시 회사ID, 회사 이름 정보가 제대로 조회되지 않는 오류 수정
				String pCompanyID_ = commonUtil.cleanValue(ezOrganService.getPropertyValue(addJobVal.getDepartment(), "EXTENSIONATTRIBUTE2", userInfo.getTenantId()));
				String pCompanyName_ = commonUtil.cleanValue(ezOrganService.getPropertyValue(addJobVal.getDepartment(), "EXTENSIONATTRIBUTE3", userInfo.getTenantId()));
				String pCompanyName2_ = commonUtil.cleanValue(ezOrganService.getPropertyValue(addJobVal.getDepartment(), "COMPNM2", userInfo.getTenantId()));
				String pJobid = commonUtil.cleanValue(addJobVal.getJobID());
				String pTitle_ =  commonUtil.cleanValue(addJobVal.getTitle());
				String pTitle1_ = commonUtil.cleanValue(addJobVal.getTitle1());
				String pTitle2_= commonUtil.cleanValue(addJobVal.getTitle2());
				String displayName = commonUtil.cleanValue(ezOrganService.getPropertyValue(addJobVal.getDepartment(), "DisplayName" + lang, userInfo.getTenantId()));
				
                if (pCompanyID_.equals(userInfo.getCompanyID())) {
	                if (userInfo.getDeptID().equals(addJobVal.getDepartment())) {
	                    if (pTitle_.equals("")) {
	                    	subTitleString += "<option  value='" + addJobVal.getDepartment() + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "|" + pCompanyID_ + "|" + pCompanyName_ + "|" + pCompanyName2_ + "|" + pJobid + "'  selected>" + displayName + "</option>";
	                    } else {
	                    	subTitleString += "<option  value='" + addJobVal.getDepartment() + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "|" + pCompanyID_ + "|" + pCompanyName_ + "|" + pCompanyName2_ + "|" + pJobid + "'  selected>" + displayName + "[" + pTitle_ + "]" + "</option>";
	                    }
	                } else {
	                    if (pTitle_.equals("")) {
	                    	subTitleString += "<option  value='" + addJobVal.getDepartment() + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "|" + pCompanyID_ + "|" + pCompanyName_ + "|" + pCompanyName2_ + "|" + pJobid + "' >" + displayName + "</option>";
	                    } else {
	                    	subTitleString += "<option  value='" + addJobVal.getDepartment() + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "|" + pCompanyID_ + "|" + pCompanyName_ + "|" + pCompanyName2_ + "|" + pJobid + "' >" + displayName + "[" + pTitle_ + "]" + "</option>";
	                    }
	                }
	                deptListFlag ++;
				}
        	}
        }
        if (deptListFlag > 1) {
        	isSubTitle = true;
        } 
        
        logger.debug("getUserSubTitle Value : subTitleString = " + subTitleString);
        logger.debug("getUserSubTitle Value : isSubTitle = " + isSubTitle);

        referenceTemp.set(0, subTitleString);
        referenceTemp.set(1, isSubTitle);
        logger.debug("getUserSubTitle ended");
	}
	
	/**
	 * 전자결재G 우측리스트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprManage.do", method = RequestMethod.GET)
	public String aprManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception {
		logger.debug("aprManage started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String openYear = ezCommonService.getTenantConfig("Site_OpenYear", userInfo.getTenantId());
		String buJaeInfo = "";
		String nowDate = EgovDateUtil.convertDate(org.egovframe.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", "");
		String susinAdmin = "";
		String listType = request.getParameter("listType");
		String viewLeftCount = ezCommonService.getTenantConfig("APPROVLEFTCOUNT", userInfo.getTenantId());
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String selMenu = "all";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String forceCallBackYN = ezCommonService.getTenantConfig("forceCallBack_YN", userInfo.getTenantId());
		String subQuery = request.getParameter("SubQuery");
		OrganProxyVO proxyInfo = ezOrganService.getProxyInfo(userInfo.getId(), userInfo.getTenantId(), userInfo.getOffset());
		String userLang = userInfo.getLang();
		String shareUserId = request.getParameter("shareUserId");
		
        if (listType == null) {
            logger.debug("--> listType is null");
            return "";
        }
		
		//문서유통 문서 타입
		String relayG_type = ezCommonService.getTenantConfig("UserInfo_RelayG_Type", userInfo.getTenantId()); 
		
		nowDate = nowDate.substring(0, 16);
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}

		List<PortalTopOtherCompanyAddJobVO> companyList;
		
		if ("Y".equals(ezCommonService.getTenantConfig("switchUserCompany", userInfo.getTenantId()))) {
			companyList = Collections.emptyList();
		} else {
			companyList = ezApprovalGService.getAllCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary());
		}
		
		String result = ezOrganService.getPropertyList(userInfo.getId(), "extensionAttribute4;extensionAttribute5", userInfo.getPrimary(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(result);
		
		String userRealDeptId = ezOrganService.getUserOrgDeptId(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		List<OrganUserVO> orgUserInfolist = ezOrganService.getOrgUserInfo(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());

		// 2022-02-11 박기범 : 직책이 없을경우 null이 들어오는 경우 체크 추가
		String userGetTitle = userInfo.getTitle() != null ? userInfo.getTitle() : "";
		String userRealTitle = orgUserInfolist.get(0).getTitle() != null ? orgUserInfolist.get(0).getTitle() : "";
		String userRealTitle2 = orgUserInfolist.get(0).getTitle() != null ? orgUserInfolist.get(0).getTitle2() : "";

		/* 2023-08-04 민지수 - 부재자 설정값 다국어 처리 */
		if (userInfo.getDeptID().equals(userRealDeptId) && userGetTitle.equals(userRealTitle) && !userLang.equals("2")) {
			buJaeInfo = doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
		} else if (userInfo.getDeptID().equals(userRealDeptId) && userGetTitle.equals(userRealTitle2) && (userLang.equals("2") || userLang.equals("3")|| userLang.equals("6"))) {
			buJaeInfo = doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
		} else {
			//buJaeInfo = ezOrganService.getAddJobProxy(userInfo.getId(), userInfo.getDeptID(), userInfo.getTenantId());
			buJaeInfo = ezOrganService.getAddJobProxy(userInfo.getId(), userInfo.getDeptID(), userInfo.getTitle(), userInfo.getTenantId());
		}
		
		if(shareUserId != null && !shareUserId.equals("")){
			userRealDeptId = ezOrganService.getUserOrgDeptId(shareUserId, userInfo.getTenantId(), userInfo.getCompanyID());
			userInfo.setId(shareUserId);
			userInfo.setDeptID(userRealDeptId);
			model.addAttribute("shareUser", "shareUser");
		}
		
		String absenceAllClear = ezCommonService.getTenantConfig("absenceAllClear", userInfo.getTenantId());
		
		/* 2021-04-07 홍승비 - 비전자문서 양식 MHT 확장자 추가 (기본은 HWP) */
		String nonElecRecType = ezCommonService.getTenantConfig("ApprNonElecRecType", userInfo.getTenantId()) != null ? ezCommonService.getTenantConfig("ApprNonElecRecType", userInfo.getTenantId()) : "HWP";
		
		// 전자결재 미리보기영역 관련 설정 추가
		String previewInfo = "OFF";
		String useAprPreview = ezCommonService.getTenantConfig("useAprPreview", userInfo.getTenantId()); // 미리보기 영역 사용여부 테넌트 컨피그
		
		/* 2023-04-18 홍승비 - 전자결재 > 미리보기 영역의 설정값 반환 이전, 미리보기 영역 사용여부를 먼저 체크 (사용하지 않으면 OFF 유지) */
		if (useAprPreview.equalsIgnoreCase("YES")) {
			previewInfo = ezApprovalGService.getApprovConfig(userInfo.getId(), userInfo.getTenantId()); // 미리보기 영역 사용설정 (OFF, H)
		}

		/* 2024-06-28 양지혜 - 전자결재 > 지정목록 접근 권한 체크 */
		String assignPermission = (userInfo.getRollInfo().indexOf("a=1") != -1 || userInfo.getRollInfo().indexOf("m=1") != -1) ? "Y" : "N";

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
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("useAdditionalRole", ezCommonService.getTenantConfig("USE_AdditionalROle", userInfo.getTenantId()));
		model.addAttribute("userLang", userLang);
		model.addAttribute("primary", commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("absenceAllClear", absenceAllClear);
		model.addAttribute("nonElecRecType", nonElecRecType);
		model.addAttribute("previewInfo", previewInfo);
		model.addAttribute("useAprPreview", useAprPreview);
		model.addAttribute("useReceiveInfoName", ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId()));
		model.addAttribute("assignPermission", assignPermission);
		model.addAttribute("draftAllTypeB", ezCommonService.getTenantConfig("draftAllTypeB", userInfo.getTenantId()));

		logger.debug("aprManage ended.");
		
		return "ezApprovalG/apprGManage";
	}
	
	/**
	 * 전자결재G 결재리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getAprDocList.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getAprDocList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("getAprDocList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String listType = request.getParameter("listType");
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		String pageSize = request.getParameter("pageSize");
		String pageNum = request.getParameter("pageNum");
		String companyID = request.getParameter("companyID");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String searchQuery = request.getParameter("searchQuery");
		String searchCompanyID = request.getParameter("searchCompanyID");
		String searchStatus = request.getParameter("searchStatus");

		logger.debug("listType = " + listType + " || userID = " + userID + " || deptID(AddJob) = " + deptID);
		
        if (userID == null) {
            logger.debug("--> userID is null");
            return "";
        }
        if (searchQuery == null) {
            logger.debug("--> searchQuery is null");
            return "";
        }
        if (orderCell == null) {
            logger.debug("--> orderCell is null");
            return "";
        }
        if (listType == null) {
            logger.debug("--> listType is null");
            return "";
        }
        if (deptID == null) {
            logger.debug("--> deptID is null");
            return "";
        }
        if (companyID == null) {
            logger.debug("--> companyID is null");
            return "";
        }
		
		if (!commonUtil.isIntNumber(pageSize)) {
		    logger.debug("pageSize is not int value");
		    return "";
		}
		if (!commonUtil.isIntNumber(pageNum)) {
		    logger.debug("pageNum is not int value");
		    return "";
		}
		
 		String userLang = userInfo.getLang();
		Document domSub = null;
		
		if (pageNum.equals("0")) {
			pageNum = "1";
		}
		
		// 김민재 - sql에서 $ 기호 제거를 위해, map 사용하여 값 전달
		Map<String, Object> searchMap = new HashMap<>();
		if (searchQuery != null && searchQuery.length() > 10) {
			String tempQuery = "";
			domSub = commonUtil.convertStringToDocument(searchQuery);
			tempQuery = domSub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
			
			if (tempQuery.indexOf("DOCNO;") != -1) {
				searchMap.put("docnoSearch", "1");
				searchMap.put("DOCNO", domSub.getElementsByTagName("DOCNO").item(0).getTextContent());
			}
			
			if (tempQuery.indexOf("DOCTITLE;") != -1) {
				searchMap.put("doctitleSearch", "1");
				searchMap.put("DOCTITLE", domSub.getElementsByTagName("DOCTITLE").item(0).getTextContent());
			}
			
			/* 2020-06-29 홍승비 - WRITERNAME, WRITERDEPTNAME칼럼은 2까지만 존재함(일본어인 경우 3이 전달되는 오류 수정) */
            if (commonUtil.getPrimaryData(userLang, userInfo.getTenantId()).equals("2")) {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
					searchMap.put("writerNameSearch", "1");
					searchMap.put("WRITERNAME", domSub.getElementsByTagName("WRITERNAME").item(0).getTextContent());
                }
            } else {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                    searchMap.put("writerNameSearch", "2");
                    searchMap.put("WRITERNAME", domSub.getElementsByTagName("WRITERNAME").item(0).getTextContent());
				}
            }
            
            if (commonUtil.getPrimaryData(userLang, userInfo.getTenantId()).equals("2")) {
                if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) {
					searchMap.put("writerDeptNameSearch", "1");
					searchMap.put("WRITERDEPTNAME", domSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent());
				}
            } else {
                if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) {
					searchMap.put("writerDeptNameSearch", "2");
					searchMap.put("WRITERDEPTNAME", domSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent());
				}
            }
            
            String dateReg = "^[0-9]{4}-[0-9]{2}-[0-9]{2}$"; //sql injection 처리 
            if (tempQuery.indexOf("APRSTARTDATE;") != -1) {
            	String aprStartDate = domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent();
            	
            	/* 2021-03-24 심기영 전자결재 -> 문서검색 -> 오늘 문서 검색 시 한 자리수 달, 일로 인해 생기는 오류 조정 */
                String tempMonth = aprStartDate.split("-")[1];
                String tempDay = aprStartDate.split("-")[2];
                
                if (tempMonth.length() < 2 && tempDay.length() < 2) {
                	tempMonth = "0" + tempMonth;
                	tempDay = "0" + tempDay;
                	aprStartDate = aprStartDate.substring(0,5) + tempMonth + "-" + tempDay;
                }
                else if (tempMonth.length() < 2 && tempDay.length() > 1) {
                	tempMonth = "0" + tempMonth;
                	aprStartDate = aprStartDate.substring(0,5) + tempMonth + "-" + tempDay;
                }
                else if (tempMonth.length() > 1 && tempDay.length() < 2) {
                	tempDay = "0" + tempDay;
                	aprStartDate = aprStartDate.substring(0,5) + tempMonth + "-" + tempDay;
                }
                else if (aprStartDate.length() > 10) {
                	aprStartDate = aprStartDate.substring(0, 10); // 년-월-일 뒤의 시-분-초를 제거 (아래에서 시간을 붙이므로)
                }
                /* 2021-03-24 심기영 전자결재 -> 문서검색 -> 오늘 문서 검색 시 한 자리수 달, 일로 인해 생기는 오류 조정 끝 */
                
                if (!Pattern.matches(dateReg, aprStartDate)) {
                    return "";
                }
                
                // 검색 시간 시작 조건은 쿼리에 상관없이 동일하므로 분기 바깥으로 이동, 각 DB 별 쿼리 내부에서 함수 사용 등 처리
                searchMap.put("APRSTARTDATE", commonUtil.getDateStringInUTC(domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), true));
                
                if (listType.equals("10")) {
					searchMap.put("aprStartDateSearch", "2"); // RECEIVEDDATE 칼럼으로 검색
                } else {
					searchMap.put("aprStartDateSearch", "4"); // STARTDATE 칼럼으로 검색
                }
            }
            
            if (tempQuery.indexOf("APRENDDATE;") != -1) {
                String aprEndDate = domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent();
                
                /* 2021-03-24 심기영 전자결재 -> 문서검색 -> 오늘 문서 검색 시 한 자리수 달, 일로 인해 생기는 오류 조정 */
                String tempMonth = aprEndDate.split("-")[1];
                String tempDay = aprEndDate.split("-")[2];
                
                if (tempMonth.length() < 2 && tempDay.length() < 2) {
                	tempMonth = "0" + tempMonth;
                	tempDay = "0" + tempDay;
                	aprEndDate = aprEndDate.substring(0,5) + tempMonth + "-" + tempDay;
                }
                else if (tempMonth.length() < 2 && tempDay.length() > 1) {
                	tempMonth = "0" + tempMonth;
                	aprEndDate = aprEndDate.substring(0,5) + tempMonth + "-" + tempDay;
                }
                else if (tempMonth.length() > 1 && tempDay.length() < 2) {
                	tempDay = "0" + tempDay;
                	aprEndDate = aprEndDate.substring(0,5) + tempMonth + "-" + tempDay;
                }
                else if (aprEndDate.length() > 10) {
                	aprEndDate = aprEndDate.substring(0, 10); // 년-월-일 뒤의 시-분-초를 제거 (아래에서 시간을 붙이므로)
                }
                /* 2021-03-24 심기영 전자결재 -> 문서검색 -> 오늘 문서 검색 시 한 자리수 달, 일로 인해 생기는 오류 조정 끝 */
                
                if (!Pattern.matches(dateReg, aprEndDate)) {
                    return "";
                }
                
                // 검색 시간 종료 조건은 쿼리에 상관없이 동일하므로 분기 바깥으로 이동, 각 DB 별 쿼리 내부에서 함수 사용 등 처리
                searchMap.put("APRENDDATE", commonUtil.getDateStringInUTC(domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true));
                
                if (listType.equals("10")){
					searchMap.put("aprEndDateSearch", "2"); // RECEIVEDDATE 칼럼으로 검색
                } else {
					searchMap.put("aprEndDateSearch", "4"); // STARTDATE 칼럼으로 검색
                }
            }
            
            if (tempQuery.indexOf("FORMID;") != -1) {
				searchMap.put("formIdSearch", "1");
				searchMap.put("FORMID", domSub.getElementsByTagName("FORMID").item(0).getTextContent());
			}
			// 2021-01-14 박기범 formname추가
			if (tempQuery.indexOf("FORMNAME;") != -1) {
				searchMap.put("formNameSearch", "1");
				searchMap.put("FORMNAME", domSub.getElementsByTagName("FORMNAME").item(0).getTextContent());
			}
            
            if (tempQuery.indexOf("KAPR;") != -1) {
            	if (listType.equals("10")) {
					searchMap.put("kaprSearch", "1");
				} else {
					searchMap.put("kaprSearch", "2");
				}
            	
            	// 임시보관함 키워드 검색 추가
            	if (listType.equals("21")) {
					searchMap.put("keywordSearch", "1");
					searchMap.put("KEYWORD", domSub.getElementsByTagName("KEYWORD").item(0).getTextContent());
				} else {
					searchMap.put("keywordSearch", "2");
					searchMap.put("KEYWORD", domSub.getElementsByTagName("KEYWORD").item(0).getTextContent());
				}
            }
            
            if (tempQuery.indexOf("KEND;") != -1) {
				searchMap.put("kendSearch", "1");
				searchMap.put("KEYWORD", domSub.getElementsByTagName("KEYWORD").item(0).getTextContent());
            }
            
            if (tempQuery.indexOf("CAPR;") != -1) {
				searchMap.put("caprSearch", "1");
				searchMap.put("itemCODE", domSub.getElementsByTagName("itemCODE").item(0).getTextContent());
			}
            
            if (tempQuery.indexOf("CEND;") != -1) {
				searchMap.put("cendSearch", "1");
				searchMap.put("itemCODE", domSub.getElementsByTagName("itemCODE").item(0).getTextContent());
			}
            
            if (tempQuery.indexOf("URGENTAPPROVAL;") != -1) {
				searchMap.put("urgentSearch", "1");
				searchMap.put("URGENTAPPROVAL", domSub.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent());
			}
		}
		
		if (searchCompanyID != null && !searchCompanyID.equals("")) {
			if (listType.equals("10")) {
				searchMap.put("companyIdSeach", "1");
				searchMap.put("searchCompanyID", searchCompanyID);
			} else {
				searchMap.put("companyIdSeach", "2");
				searchMap.put("searchCompanyID", searchCompanyID);
			}
		}
		
		if (searchStatus != null && !searchStatus.equals("") && !searchStatus.equals("ALL")) {
			if (listType.equals("1") || listType.equals("2") || listType.equals("3") || listType.equals("11")) {
				searchMap.put("searchStatus", searchStatus);
			}
		}
		
		String resultXML = ezApprovalGService.aprDocList(listType, userID, deptID, pageSize, pageNum, orderCell, orderOption, companyID, userLang, searchQuery, domSub, userInfo.getTenantId(), userInfo.getOffset(), searchMap);
		
		logger.debug("getAprDocList ended.");
		
		return resultXML;
	}
	
	/**
	 * 전자결재G 결재라인리스트 호출 Method
	 */
	@RequestMapping(value = {"/ezApprovalG/getLineList.do","/ezApprovalG/getTotalAttachInfo.do","/ezApprovalG/getReceiptinfo.do","/ezApprovalG/getOpinionInfo.do", "/ezApprovalG/getCirculationinfo.do"}, produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getLineList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("getLineList started.");
		
		String docID = request.getParameter("docID");
		String mode = request.getParameter("mode");
		String flag = request.getParameter("flag");
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		String docState = request.getParameter("docState");
		//2018-10-23 이효진 대리결제 지정된 사람 결재 시 메일발송부분 권한체크때 현재결재선진행되고 다음결재선의 ID로 자꾸 비교되서
		String proxyUserFlag = request.getParameter("proxyUserFlag");
		/* 2021-04-28 홍승비 - 전자결재 알림메일 발송 시, 대리결재자도 메일 발송을 위해 결재선에 접근 가능하도록 판단하는 플래그 추가 */
		String isMailSendFlag = request.getParameter("isMailSendFlag") != null ? request.getParameter("isMailSendFlag") : "";
		
		//2018-09-04 강민수92 비공개문서일때 결재라인 안보이게 하기 위해 추가
		String publicityYN = request.getParameter("publicityYN");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
        int tenantID = userInfo.getTenantId();

		String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
		String pass = "";
		
		/* 2024-05-08 양지혜 - 공개문서에서 파라미터 조작으로 접근 취약점 보완. 매번 권한체크를 하도록 함 */
        //2018-09-04 강민수92 비공개문서일때 결재라인 안보이게 하기 위해 추가
        if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("m=1") == -1) {
        	pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), tenantID, approvalFlag, userInfo.getDeptID());
        	
			if (!pass.equals("<RESULT>TRUE</RESULT>")) {
				return "NOTPERMISSION";
			}
        }
        
        if (mode == null) {
        	mode = "APR";
        }
     
        logger.debug("docID = " + docID + ", mode =" + mode + ", tenantID=" + tenantID);       
		// c=1 : 전체관리자, k=1 : 회사관리자, q=1 : 문서조회관리자, m=1 : 기록물관리책임자
		if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("q=1") && !userInfo.getRollInfo().contains("m=1")) {
			if (mode.toUpperCase().equals("APR") || mode.toUpperCase().equals("TMP")) {
				if (docID != null && !docID.equals("")) {
//					String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1", tenantID, userInfo.getOffset());
					String proxyUser = ezApprovalGService.getProxyUser2(userInfo.getId(), "1", tenantID, userInfo.getOffset());
					String[] proxyUserArray = proxyUser.split(",");
					boolean checkPermission = true;
					
					if (proxyUserArray.length > 0) {
						String docList = ezApprovalGService.getAprLineInfoDB(docID.trim(), "1", "", "", userInfo.getCompanyID(), userInfo.getTenantId(), "", "", mode, "");
						Document docXML = commonUtil.convertStringToDocument(docList);
						
						for (int k = 0; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
							// APRSTATE 002(진행) OR 005(보류)
							if (docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("002") || docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("005") || docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("000")) {
								String curAprUserID = null;
								
								if (proxyUserFlag == null) {
									curAprUserID = docXML.getElementsByTagName("ORGUSERID").item(k).getTextContent();
								} else {
									if (k > 0) {
										curAprUserID = docXML.getElementsByTagName("ORGUSERID").item(k-1).getTextContent();
									} else {
										curAprUserID = docXML.getElementsByTagName("ORGUSERID").item(k).getTextContent();
									}
								}
								
								for (int j = 0; j < proxyUserArray.length; j++) {
									if (curAprUserID.equals(proxyUserArray[j].trim().substring(1, proxyUserArray[j].trim().length() - 1))) {
										checkPermission = false;
										break;
									}
								}
							}
						}
					}

					//해당문서가 우리 부서의 배부대장에 있는 문서인지 확인
					if (checkPermission) {
						int deliveryCount = ezApprovalGService.isMyDeptDeliveryDoc(userInfo.getDeptID(), docID, userInfo.getCompanyID(), userInfo.getTenantId());
						if(deliveryCount > 0){
							checkPermission = false;
						}
					}
					
					if (checkPermission) {
						String checkMode = "";
						
						if (mode.toUpperCase().equals("TMP")) {
							checkMode = "TMP";
						} else {
							checkMode = "REC";
						}
						
						Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), checkMode, userInfo.getCompanyID(), userInfo.getTenantId(), docState);
						
						if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
//							Document docXML2 = null;
//							boolean checkPer = false;
//		                    String MDept = ezApprovalGService.getDocManageDeptInfo(userInfo.getDeptID(), tenantID);
//		                    String [] deptArray = MDept.split(",");
//		                    for (int i = 0; i < deptArray.length; i++) {
//		                        if (!deptArray[i].trim().equals("")) {
//		                            String mDpet = deptArray[i].trim().substring(deptArray[i].trim().indexOf("'") + 1, deptArray[i].trim().lastIndexOf("'")).toUpperCase().trim();
//		                            if (!mDpet.equals(userInfo.getDeptID().toUpperCase().trim())) {
//		                            	docXML2 = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), mDpet, mode, userInfo.getCompanyID(), tenantID, docState);
//		                                if (docXML2.getElementsByTagName("DOCID").getLength() > 0) {
//		                                    checkPer = true;
//		                                    break;
//		                                }
//		                            }
//		                        }
//		                    }
//
//		                    if (!checkPer) {
//		                        return "NOTPERMISSION";
//		                    }
							
							/* 2021-04-28 홍승비 - 전자결재 알림메일 발송 시, 대리결재자도 메일 발송을 위해 결재선에 접근 가능하도록 수정 */
							//2018-08-23 천성준 - Document doc = ezApprovalGService.checkPermission 에서 결재선에 올라와 있지만 부서가 다르단 이유로 권한이 없다고 걸러버려서 부서가 다르면 결재선에 있는지 체크로직 추가
							if (docID != null && mode != null) {
								String checkLine = ezApprovalGService.checkAprLine(docID.trim(), mode, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
								if (!checkLine.equals("<RESULT>TRUE</RESULT>") && !isMailSendFlag.equals("Y")) {
									return "NOTPERMISSION";
								}
							} else {
								return "NOTPERMISSION";
							}
							//return "NOTPERMISSION";
		                }
					}
				}
			} else if (mode.toUpperCase().equals("END")) {
				pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());
				
				//회람일때 권한 노체크
				if (flag != null && !flag.equals("Y")) {
					if (!pass.equals("<RESULT>TRUE</RESULT>")) {
						return "NOTPERMISSION";
					}
				}				
			}
		}
		
		String result = "";
		
		if (requestURL.indexOf("getLineList") > -1) {
			result = ezApprovalGService.getLineInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		} else if (requestURL.indexOf("getTotalAttachInfo") > -1) {
			result = ezApprovalGService.getAttachInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		} else if (requestURL.indexOf("getReceiptinfo") > -1) {
			result = ezApprovalGService.getReceiptInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), approvalFlag, "", userInfo.getLocale());
		} else if (requestURL.indexOf("getOpinionInfo") > -1) {
			result = ezApprovalGService.getOpinionInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		} else if (requestURL.indexOf("getCirculationinfo") > -1) {
			result = ezApprovalGService.getCirculationinfo(docID, mode, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		}
		
		logger.debug("getLineList ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 레프트메뉴카운트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getListCount.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getListCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, @RequestBody String docXml) throws Exception{
		logger.debug("getListCount started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(docXml);
		String listType = doc.getElementsByTagName("LISTTYPE").item(0).getTextContent();
		String mode = request.getParameter("mode");
		String susinAdmin = "user";
		String result = "";
		String nowDateTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), true);
		String type = "";
		if (request.getParameter("type") != null) {
			type = request.getParameter("type");
		}
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1 || ezOrganService.isProxyUser(userInfo.getTenantId(), userInfo.getId(), nowDateTime).equals("1")) {
			susinAdmin = "admin";
		}
		
		if (mode != null) {
			result = ezApprovalGService.getWebPartList(listType, userInfo.getId(), userInfo.getDeptID(), "", "LEFT", susinAdmin, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), type);
		} else {
			result = ezApprovalGService.getWebPartList(listType, userInfo.getId(), userInfo.getDeptID(), "", "COUNT", susinAdmin, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), "");
		}
		
		logger.debug("getListCount ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안양식 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getFormCont.do", method = RequestMethod.GET)
	public String getFormCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
		logger.debug("getFormCont started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String deptID = userInfo.getDeptID();
		String pFormType = request.getParameter("pFormType") != null ? request.getParameter("pFormType") : "ALL";
		String ext = request.getParameter("ext");
		String docType = ezApprovalGService.getDocType(pFormType, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale(), approvalFlag);
		String userForm = ezApprovalGService.getOptionInfo("A57", "001", userInfo, "CODE");
		String docFileType = "";
		String useEnforceSihang = ezCommonService.getTenantConfig("UseEnforceSihang", userInfo.getTenantId());
		String reuseFlag = "";
		String resendFormYN = ezCommonService.getTenantConfig("ResendFormYN", userInfo.getTenantId());
		String draftTypeFlag = request.getParameter("draftTypeFlag");

		if (approvalFlag.equals("S") && useEnforceSihang.equals("YES") && pFormType.equals("004")) {
			model.addAttribute("onlySihang", "YES");
		}
		
		if (request.getParameter("fileType") != null) {
			docFileType = request.getParameter("fileType");
		}
		
		if (request.getParameter("reuseFlag") != null) {
			reuseFlag = request.getParameter("reuseFlag");
		}
		
		model.addAttribute("deptID", deptID);
		model.addAttribute("docType", docType);
		model.addAttribute("userForm", userForm);
		model.addAttribute("docFileType", docFileType);
		model.addAttribute("ext", ext);
		model.addAttribute("reuseFlag", reuseFlag);
		model.addAttribute("resendFormYN", resendFormYN);
		model.addAttribute("draftTypeFlag", draftTypeFlag);

		logger.debug("getFormCont ended.");
		
		return "ezApprovalG/apprGFormCont";
	}
	
	/**
	 * 전자결재G 작은 크기의 기안양식 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getMiniFormCont.do", method = RequestMethod.GET)
	public String getMiniFormCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
		logger.debug("getMiniFormCont started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String deptID = userInfo.getDeptID();
		String pFormType = request.getParameter("pFormType") != null ? request.getParameter("pFormType") : "ALL";
		String ext = request.getParameter("ext");
		String docType = ezApprovalGService.getDocType(pFormType, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale(), approvalFlag);
		String userForm = ezApprovalGService.getOptionInfo("A57", "001", userInfo, "CODE");
		String docFileType = "";
		String useEnforceSihang = ezCommonService.getTenantConfig("UseEnforceSihang", userInfo.getTenantId());
		String reuseFlag = "";
		String resendFormYN = ezCommonService.getTenantConfig("ResendFormYN", userInfo.getTenantId());
		
		if (approvalFlag.equals("S") && useEnforceSihang.equals("YES") && pFormType.equals("004")) {
			model.addAttribute("onlySihang", "YES");
		}
		
		if (request.getParameter("fileType") != null) {
			docFileType = request.getParameter("fileType");
		}
		
		if (request.getParameter("reuseFlag") != null) {
			reuseFlag = request.getParameter("reuseFlag");
		}
		
		model.addAttribute("deptID", deptID);
		model.addAttribute("docType", docType);
		model.addAttribute("userForm", userForm);
		model.addAttribute("docFileType", docFileType);
		model.addAttribute("ext", ext);
		model.addAttribute("reuseFlag", reuseFlag);
		model.addAttribute("resendFormYN", resendFormYN);
		
		logger.debug("getMiniFormCont ended.");
		
		return "ezApprovalG/apprGMiniFormCont";
	}
	
	/**
	 * 전자결재G 기안양식 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getForm.do", produces="text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		logger.debug("getForm started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String id = request.getParameter("id");
		String kind = request.getParameter("kind");
		String searchType = request.getParameter("searchType");
		String searchName = request.getParameter("searchName");
		String draftTypeFlag = request.getParameter("draftTypeFlag");
		String result = ezApprovalGService.getFormInfo(id.trim(), kind, searchType, searchName, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), draftTypeFlag);
		
		logger.debug("getForm ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안양식함 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getFormContainer.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getFormContainer(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		logger.debug("getFormContainer started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String id = request.getParameter("id");
		String deptID = request.getParameter("deptID");
		String result = ezApprovalGService.getFormContainerInfo(id, deptID, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId(), approvalFlag);
		
		logger.debug("getFormContainer ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 양식즐겨찾기등록 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setFormUserInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setFormUserInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		logger.debug("setFormUserInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String formID = request.getParameter("tempFormID");
		String result = ezApprovalGService.setUserFormInfo(formID.trim(), userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("setFormUserInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 양식즐겨찾기삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/delFormUserInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String delFormUserInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		logger.debug("delFormUserInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String formID = request.getParameter("tempFormID");
		String result = ezApprovalGService.delUserFormInfo(formID.trim(), userInfo.getId(), userInfo.getCompanyID(),userInfo.getTenantId());
		
		logger.debug("delFormUserInfo ended.");
		return result;
	}
	
	/**
	 * 전자결재G 얼러트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezAprAlert.do", method = RequestMethod.GET)
	public String ezAPRALERT() throws Exception{
		return "ezApprovalG/apprGezAPRALERT";
	}

	@RequestMapping(value = "/ezApprovalG/ezAprSelectAlert")
	public String ezAprSelectAlert(HttpServletRequest request, Model model) throws Exception {
		return "ezApprovalG/apprGezAprSelectAlert";
	}

	/**
	 * 전자결재G 기안하기 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/draftui.do", method = RequestMethod.GET)
	public String draftui(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
		logger.debug("draftui started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		int tenantID = userInfo.getTenantId();        
		String useEditor = ezCommonService.getTenantConfig("EDITOR", tenantID);
		String realPath = commonUtil.getRealPath(request);
		String susinAdmin = "";
		String formURL = request.getParameter("formURL");
		String draftFlag = request.getParameter("draftFlag");
		String formDocType = request.getParameter("formDocType");
		String susinSN = request.getParameter("susinSN");
		String docState = request.getParameter("docState");
		String listType = request.getParameter("listType");
		String aprState = request.getParameter("aprState");
		String isTmpDoc = request.getParameter("isTmpDoc");
		String isUsed = request.getParameter("isUsed");
		String nonElecRec = request.getParameter("nonElecRec");
		// 2021-01-21 심기영 오피스 결재 여부 추가
		String officeFlag = request.getParameter("officeFlag");
		String connKey = request.getParameter("connKey");
		String connFormCode = request.getParameter("connFormCode");
		// FormBuilder
		// String reformflag = request.getParameter("reformflag");
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		String attachedDocList = request.getParameter("attachedDocList") == "" ? null : request.getParameter("attachedDocList");

		if (nonElecRec == null) {
			nonElecRec = "";
		}

		if (isUsed == null) {
			isUsed = "";
		}

		String useOpenGov = config.getProperty("config.useOpenGov");
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());
		String draftJunGyulFlag = ezCommonService.getTenantConfig("draftJunGyulFlag", userInfo.getTenantId());
		String signImageSize = ezCommonService.getTenantConfig("SignImageSize", userInfo.getTenantId());
		String signImageType = ezCommonService.getTenantConfig("signImageType", userInfo.getTenantId());
		//String docNumZeroCnt = ezCommonService.getTenantConfig("docNumZeroCnt", userInfo.getTenantId());
		String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
		String addLastKyulJeYN = ezCommonService.getTenantConfig("addLastKyulJeYN", userInfo.getTenantId());
		String apprReuseConfig = ezCommonService.getTenantConfig("apprReuseConfig", userInfo.getTenantId());
		
		//baonk 추가 2018-08-08
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
		if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("apprv", userInfo);
		}
		
		String docSN = "";
		String beforeUrl = "";
		String beforeDocID = request.getParameter("beforeDocID");
		
		if (beforeDocID == null) {
			beforeDocID = "";
		}
		
		String fromGongram = request.getParameter("fromGongram");
		String orgDocID = request.getParameter("orgDocID");
		
		if (!beforeDocID.isEmpty()) {
			if (fromGongram != null && fromGongram.equals("1") && isUsed.equals("reuse")) {
				beforeDocID = orgDocID;
			}
			beforeUrl = ezApprovalGService.getDocHref(beforeDocID, "END", "", "", userInfo.getCompanyID(), userInfo.getTenantId());
		}
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		if (listType.equals("21")) {
			if (request.getParameter("docSN") != null) {
				docSN = request.getParameter("docSN");
			}
		}
		
		String dirPath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0,4) + commonUtil.separator;
		String mode = "APR";
		String docID = isTmpDoc;
		
		EzFile file = new EzFile (commonUtil.detectPathTraversal(dirPath));
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		if (listType.equals("1") || listType.equals("2") || listType.equals("3")) {
			mode = "APR";
		} else if (listType.equals("4") || listType.equals("6") || listType.equals("10") || listType.equals("99")) {
			mode = "REC";
		} else if (listType.equals("21")) {
			docID = docSN;
			mode = "TMP";
		}
		
		if (docID != null && !docID.equals("")) {
			String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1", tenantID, userInfo.getOffset());
			String[] proxyUserArray = proxyUser.split(",");
			boolean checkPermission = true;
			
			if (proxyUserArray.length > 1) {
				String docList = ezApprovalGService.getAprLineInfoDB(docID.trim(), "1", "", "", userInfo.getCompanyID(), tenantID, isUsed, beforeDocID, "", "");
				Document docXML = commonUtil.convertStringToDocument(docList);
				
				for (int k = 0; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
					if (docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("002") || docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("005")) {
						String curAprUserID = docXML.getElementsByTagName("ORGUSERID").item(k).getTextContent();
						
						for (int j = 0; j < proxyUserArray.length; j++) {
							if (curAprUserID.equals(proxyUserArray[j].trim().substring(1, proxyUserArray[j].trim().length() - 1))) {
								checkPermission = false;
								break;
							}
						}
					}
				}
			}
			
			if (checkPermission) {
				Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), mode, userInfo.getCompanyID(), tenantID, docState);
				
				if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
					return "main/warning";
				}
			}
		}
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optisSplit = "";
		
		if (approvalFlag.equals("S")) {
			optisSplit = ezApprovalGService.getOptionInfo("SA33", "001", userInfo, "CODE");
		} else {
			optisSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		}
		
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
		String sihangURL = ezApprovalGService.getOptionInfo("A36", "004", userInfo, "CODE");
		
		//2020-01-28 김은석 추가
		String useAnnualSusinYN = ezCommonService.getTenantConfig("useAnnualSusinYN", userInfo.getTenantId());
		
		/* 2020-11-13 홍승비 - 대용량첨부 관련 파라미터 추가 */
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
		String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String bigAttachDownloadPeriod = EgovDateUtil.getToday("/") + " ~ " + EgovDateUtil.addDay(EgovDateUtil.getToday("/"), Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");
		
		String preSusinGroupStr = ezApprovalGService.getCode2Name("A53", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		// 2023-05-26 조수빈 - 전자결재 첨부파일 미리보기 기능 사용 여부
		String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		
		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
			useAprFilePrvw = "1";
		} else {
			useAprFilePrvw = "0";
		}
		
		// 2024-05-23 김우철 - 헤더 숨기기 기능 사용 여부
		String useHideHeaderArea = ezCommonService.getTenantConfig("useHideHeaderArea", userInfo.getTenantId());

		// 2024-07-04 기민혁 - 자동 임시저장
		String autoSaveFlag =  ezCommonService.getUserConfigInfo(userInfo.getTenantId(), userInfo.getId(), "autoSave");
		String autoSaveFlag2 = ezCommonService.getTenantConfig("AprAutoSaveFlag", userInfo.getTenantId());
		if(approvalFlag.equals("G") && autoSaveFlag2.equals("YES")){
			if(autoSaveFlag.equals("")){
				autoSaveFlag = "0";
			}
		}else{
			autoSaveFlag = "0";
		}
		
		model.addAttribute("useAnnualSusinYN", useAnnualSusinYN);
		model.addAttribute("beforeDocID", beforeDocID);
		model.addAttribute("isUsed", isUsed);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optisSplit", optisSplit);
		model.addAttribute("optSplitKind", optSplitKind);
 		model.addAttribute("sihangURL", sihangURL);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("formURL", formURL);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("formDocType", formDocType);
		model.addAttribute("susinSN", susinSN);
		model.addAttribute("docState", docState);
		model.addAttribute("listType", listType);
		model.addAttribute("aprState", aprState);
		model.addAttribute("isTmpDoc", isTmpDoc);
		model.addAttribute("docSN", docSN);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("dirPath", dirPath);
		model.addAttribute("junGyulFlag", junGyulFlag);
		model.addAttribute("draftJunGyulFlag", draftJunGyulFlag);
		model.addAttribute("signImageSize", signImageSize);
		model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));
		model.addAttribute("beforeUrl", beforeUrl);
		model.addAttribute("signImageType", signImageType);
		model.addAttribute("addLastKyulJeYN", addLastKyulJeYN);
		model.addAttribute("useCabinet", use_cabinet); // 캐비넷 추가 baonk 2018-08-08
		model.addAttribute("apprReuseConfig", apprReuseConfig);
		model.addAttribute("nonElecRec", nonElecRec);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		// FormBuilder
		if (docID == null || docID.isEmpty()) {
			model.addAttribute("reformflag", ezApprovalGService.isReform(formURL, userInfo.getId()) ? "Y" : "N");
		} else if (listType.equals("21") ) {
			model.addAttribute("reformflag", ezApprovalGService.isReformTempDoc(docSN, userInfo.getCompanyID(), tenantID) ? "Y" : "N");
		} else {
			model.addAttribute("reformflag", ezApprovalGService.getReformInfoApprovalDocument(docID, userInfo.getId(), userInfo.getCompanyID(), tenantID).getReformFlag());
		}
		// 2021-01-21 심기영 오피스결재 여부 추가
		model.addAttribute("officeFlag", officeFlag);

		String formId = ezApprovalGService.getFormId(formURL);
		if (useOpenGov.equalsIgnoreCase("YES")) {
            String openGovFlag = ezApprovalGService.getOpenGovFlag(formId, userInfo.getTenantId(), userInfo.getCompanyID());
            model.addAttribute("openGovFlag", openGovFlag);
        }
		//결재 세부정보
		String formAprOption = ezApprovalGService.getFormAprOptionInfo(formId, "FORM", userInfo.getCompanyID(), tenantID);
		model.addAttribute("formAprOption", formAprOption);
		//
		model.addAttribute("useOpenGov", useOpenGov);
		
		/* 2020-03-31 홍승비 - 재기안 시 반송의견 유지여부 컨피그 추가 */
		String useRedraftOpinionKeep = ezCommonService.getTenantConfig("useRedraftOpinionKeep", userInfo.getTenantId());
		
		model.addAttribute("useRedraftOpinionKeep", useRedraftOpinionKeep);
		
		/* 2020-07-30 홍승비 - 가변결재선 사용 여부 컨피그 추가 */
		String useDynamicAprLine = ezCommonService.getTenantConfig("UseDynamicAprLine", userInfo.getTenantId()); //가변 결재선 사용여부 - 1(사용) / 0(사용안함)
		
		model.addAttribute("useDynamicAprLine", useDynamicAprLine);
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		model.addAttribute("preSusinGroupStr", preSusinGroupStr);
		model.addAttribute("connKey", connKey);
		model.addAttribute("connFormCode", connFormCode);
		model.addAttribute("isPreview", isPreview);

		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		model.addAttribute("attachedDocList", attachedDocList);

		model.addAttribute("useHideHeaderArea", useHideHeaderArea);

		model.addAttribute("useAutoSaveTime", autoSaveFlag);
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
		
		String formName = "";
		String formInfoXml = "";
		if (StringUtils.isBlank(formId)) {
			formId = ezApprovalGService.getFormIdFromApr(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		formInfoXml = ezApprovalGService.getFormInfoDetail(formId, userInfo.getCompanyID(), userInfo.getTenantId());
		Document formInfo = commonUtil.convertStringToDocument(formInfoXml);
		if (formInfo.getElementsByTagName("FORMNAME").item(0) != null) {
			if ("1".equals(userInfo.getPrimary())) {
				formName = formInfo.getElementsByTagName("FORMNAME").item(0).getTextContent().trim();
			} else {
				formName = formInfo.getElementsByTagName("FORMNAME2").item(0).getTextContent().trim();
			}
		}
		
		// ai 관련 컨피그 추가
		// AI 첨부파일 이름 최대 길이 - 기존 첨부파일과 동일한 값 사용
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		// AI 사용여부 확인
		boolean useAI = aICommonUtil.checkUseAI(userInfo.getTenantId());
		// AI 챗봇 첨부파일 최대용량
		String aiAttachMBSize = ezCommonService.getTenantConfig("aiAttachMBSize", userInfo.getTenantId());
		
		model.addAttribute("formName", formName);
		model.addAttribute("moduleType", "approval");
		model.addAttribute("moduleSubType", "draftDoc");
		model.addAttribute("useAI", useAI);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("aiAttachMBSize", aiAttachMBSize);

		logger.debug("draftui ended.");

		return "ezApprovalG/apprGDraftui";
	}
	
	@RequestMapping(value = "/ezApprovalG/getReformFlag.do", method = RequestMethod.GET)
	@ResponseBody
	public String getReformFlag(String formHref, HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		userInfo = commonUtil.aprUserInfo(loginCookie);
		return ezApprovalGService.isReform(formHref, userInfo.getId()) ? "Y" : "N";
	}
	
	/**
	 * 전자결재G 패스워드 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getApprovalPWD.do", produces = "text/plain;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getApprovalPWD(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		logger.debug("getApprovalPWD started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String result = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		logger.debug("getApprovalPWD ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안내용 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/draftContent.do", method = RequestMethod.GET)
	public String draftContent(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		logger.debug("draftContent started.");
		
		String mode = "";
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String isUsed = request.getParameter("isUsed");
		String officeFlag = request.getParameter("officeFlag");
		if (request.getParameter("draftFlag") != null) {
			mode = request.getParameter("draftFlag");
		}
		String frameNum = request.getParameter("frameNum") != null ? request.getParameter("frameNum") : "";
		String docID = request.getParameter("docID") != null ? request.getParameter("docID") : "";
		String docHref = request.getParameter("docHref") != null ? request.getParameter("docHref") : "";
		String formID = request.getParameter("formID") != null ? request.getParameter("formID") : "";
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());
		String draftJunGyulFlag = ezCommonService.getTenantConfig("draftJunGyulFlag", userInfo.getTenantId());
		String optisSplit = "";

		if (ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId()).equals("S")) {
			optisSplit = ezApprovalGService.getOptionInfo("SA33", "001", userInfo, "CODE");
		} else {
			optisSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("mode", mode);
		model.addAttribute("editor", editor);
		model.addAttribute("isUsed", isUsed);
		model.addAttribute("officeFlag", officeFlag);
		model.addAttribute("formID", formID); // 사실상 iframe 내부에서 GetAprDocFormID()를 호출하여 가져오므로, 필요없는 파라미터임
		model.addAttribute("frameNum", frameNum);
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("junGyulFlag", junGyulFlag);
		model.addAttribute("draftJunGyulFlag", draftJunGyulFlag);
		model.addAttribute("isSplit", optisSplit);
		logger.debug("draftContent ended.");
		
		return "ezApprovalG/apprGDraftContent";
	}
	
	/**
	 * 전자결재G 기안시 리폼 HTML
	 */
	@RequestMapping(value = "/ezApprovalG/reform/draftHtml.do", method = RequestMethod.GET)
	public String reformDraftHtml(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws IOException {
		logger.debug("reformDraftHtml started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String formId = request.getParameter("formID");
		String reformBody = "";
		
		String approvalUploadPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		String reformDirectoryPathStr = String.join(commonUtil.separator, approvalUploadPath, userInfo.getCompanyID(), "form", "reform", formId);
		
		String reformFilePrefix = reformDirectoryPathStr + commonUtil.separator + formId;
		String reformHtmlRelativePathStr = reformFilePrefix +  "_FORMBuilder.html";
		String reformFunctionRelativePathStr = reformFilePrefix + "_FORMBuilder.js";
		
		Path realPath = Paths.get(request.getServletContext().getRealPath(""));
		Path reformHtmlRelativePath = realPath.resolve("." + reformHtmlRelativePathStr);
		
		// EzFAL 적용
		EzFile reformHtmlRelativePathEzFile = new EzFile(reformHtmlRelativePath.toString());
		EzFile reformFunctionRelativePathEzFile = new EzFile(realPath.resolve("." + reformFunctionRelativePathStr).toString());
				
		//if (Files.exists(reformHtmlRelativePath)) {
		if (reformHtmlRelativePathEzFile.exists()) {
			reformBody = new String(commonUtil.readBytesFromFile(reformHtmlRelativePathEzFile.toPath()));
		}
		
		//if (Files.exists(realPath.resolve("." + reformFunctionRelativePathStr))) {
		if (reformFunctionRelativePathEzFile.exists()) {
			model.addAttribute("reformFunctionUrl", reformFunctionRelativePathStr);
		}
		
		model.addAttribute("reformBody", reformBody);
		model.addAttribute("lang", userInfo.getLang());
		
		logger.debug("reformDraftHtml ended.");
		
		return "ezApprovalG/reform/draftHtml";
	}
	
	/**
	 * 전자결재G 결재 리폼 HTML
	 */
	@RequestMapping(value = "/ezApprovalG/reform/approveHtml.do", method = RequestMethod.GET)
	public String reformApproveHtml(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws IOException {
		logger.debug("reformApproveHtml started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String formId = request.getParameter("formId");
		
		// 전자결재 업로드 폴더 경로에서 앞부분 경로구분자를 없앰
		String approvalUploadPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		String reformFunctionRelativePath = String.join(commonUtil.separator, approvalUploadPath, userInfo.getCompanyID(), "form", "reform", formId, formId + "_FORMBuilder.js");
		
		Path realPath = Paths.get(request.getServletContext().getRealPath(""));
		
		// EzFAL 적용
		EzFile reformFunctionRelativePathEzFile = new EzFile(realPath.resolve("." + reformFunctionRelativePath).toString());
		
		//if (Files.exists(realPath.resolve("." + reformFunctionRelativePath))) {
		if (reformFunctionRelativePathEzFile.exists()) {
			model.addAttribute("reformFunctionUrl", reformFunctionRelativePath);
		}

		model.addAttribute("lang",userInfo.getLang());
		
		logger.debug("reformApproveHtml ended.");
		
		return "ezApprovalG/reform/approveHtml";
	}
	
	/**
	 * 전자결재G 폼빌더 useProcessor selectionDialog 페이지
	 */
	@RequestMapping(value = "/ezApprovalG/reform/selectionDialog.do", method = RequestMethod.GET)
	public String reformStyleDialog() throws Exception {
		logger.debug("selectionDialog started.");
		logger.debug("selectionDialog ended.");

		return "ezApprovalG/reform/selectionDialog";
	}
	
	/**
	 * 전자결재G code 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getCodeData.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getCodeData(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getCodeData started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String code1 = request.getParameter("code1");
		String code2 = request.getParameter("code2");
		String flag = request.getParameter("flag");
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		if (approvalFlag.equals("S")) {
			if (code1.equals("A03")) {
				code1 = "SA03";
			}
		}
		
		String result = ezApprovalGService.getOptionInfo(code1, code2, userInfo, flag);
		
		logger.debug("getCodeData ended.");
		
		return "<RESULT>" + result + "</RESULT>";
	}
	
	/**
	 * 전자결재G 결재정보 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezApprovalInfo.do", method = RequestMethod.GET)
	public String ezApprovalInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("ezApprovalInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String signImageSize = ezCommonService.getTenantConfig("SignImageSize", userInfo.getTenantId());
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String useDoc24 = ezCommonService.getTenantConfig("useDoc24", userInfo.getTenantId());
		String chamjoAfterYN = ezCommonService.getTenantConfig("chamjoAfterYN", userInfo.getTenantId());
		String receptGubunYN = ezCommonService.getTenantConfig("receptGubunYN", userInfo.getTenantId());
		String addLastKyulJeYN = ezCommonService.getTenantConfig("addLastKyulJeYN", userInfo.getTenantId());
		String useReceiveInfoName = ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId());
		String securityNode3 = ezApprovalGService.getSecurityType("", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag);
		String periodnode = ezApprovalGService.getKeepType(userInfo.getLang(),userInfo.getTenantId(), userInfo.getCompanyID());
		String startDateTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String endDateTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String initFlag = request.getParameter("initFlag");
		String guBun = request.getParameter("guBun").trim();
		String docType = request.getParameter("docType");
		String isUsed = request.getParameter("isUsed");
		String beforeDocID = request.getParameter("beforeDocID");
		String ext = request.getParameter("ext");
		String docSN = "";
		String susinAdmin = "";
		String aprTypeXML = "";
		String useAddressOpenAPI = config.getProperty("config.USE_AddressOpenAPI");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		String useOpenGov = config.getProperty("config.useOpenGov");

		String useDynamicAprLine = ezCommonService.getTenantConfig("UseDynamicAprLine", userInfo.getTenantId()); //가변 결재선 사용여부 - 1(사용) / 0(사용안함)
		
		String formID = request.getParameter("formID");
		
		// 일괄결재여부 (원문공개 시 첨부파일에 "안"번호 추가 및 부서추가버튼 제외용 플래그)
		String draftAllFlag = request.getParameter("draftAllFlag") != null ? request.getParameter("draftAllFlag") : "N";

		/* 상위부서문서함 사용 시 관련 정보 같이 전달 */
		String upperDeptCode = "";
		String upperDeptName = "";
		Map<String, String> upDeptInfo = ezApprovalGService.getUpperDeptInfo(userInfo.getDeptID(), userInfo.getTenantId());
		if (upDeptInfo.get("USEUPPERDEPTBOX") != null && upDeptInfo.get("USEUPPERDEPTBOX").equals("Y")) {
			upperDeptCode = upDeptInfo.get("upperDeptCode");
			upperDeptName = upDeptInfo.get("upperDeptName");
		}

		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		if (isUsed == null) {
			isUsed = "";
		}
		
		if (beforeDocID == null) {
			beforeDocID = "";
		}
		
		if (request.getParameter("docSN") != null) {
			docSN = request.getParameter("docSN");
		}
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		if (initFlag == null || initFlag.trim().equals("")) {
			initFlag = "0";
		}
		
		aprTypeXML = ezApprovalGService.getAprType(approvalFlag, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		String optGamsabu = ezApprovalGService.getOptionInfo("A40", "001", userInfo, "CODE");
		String susinGroupUseFlag = ezApprovalGService.getCode2Name("A53", "002", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
        boolean isOuterForm = ezApprovalGService.isOuterForm(formID, userInfo.getCompanyID(), userInfo.getTenantId());
        String preSusinGroupStr = ezApprovalGService.getCode2Name("A53", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		String nonElecRecType = ezCommonService.getTenantConfig("ApprNonElecRecType", userInfo.getTenantId()) != null ? ezCommonService.getTenantConfig("ApprNonElecRecType", userInfo.getTenantId()) : "HWP";
		String nonUseDocAttachYN = ezCommonService.getTenantConfig("NonUseDocAttachYN", userInfo.getTenantId());

		model.addAttribute("periodnode", periodnode);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("optGamsabu", optGamsabu);
		model.addAttribute("susinGroupUseFlag", susinGroupUseFlag);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("securityNode3", securityNode3);
		model.addAttribute("startDateTime", startDateTime);
		model.addAttribute("endDateTime", endDateTime);
		model.addAttribute("initFlag", initFlag);
		model.addAttribute("guBun", guBun);
		model.addAttribute("docSN", docSN);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("aprTypeXML", aprTypeXML);
		model.addAttribute("useAddressOpenAPI", useAddressOpenAPI);
		model.addAttribute("signImageSize", signImageSize);
		model.addAttribute("chamjoAfterYN", chamjoAfterYN);
		model.addAttribute("isUsed", isUsed);
		model.addAttribute("beforeDocID", beforeDocID);
		model.addAttribute("receptGubunYN", receptGubunYN);
		model.addAttribute("docType", docType);
		model.addAttribute("addLastKyulJeYN", addLastKyulJeYN);
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("ext", ext);
		model.addAttribute("useReceiveInfoName", useReceiveInfoName);
		model.addAttribute("useOpenGov", useOpenGov);
		model.addAttribute("useDynamicAprLine", useDynamicAprLine); //가변 결재선 사용여부 - 1(사용) / 0(사용안함)
		model.addAttribute("isOuterForm", isOuterForm);
		model.addAttribute("useDoc24", useDoc24);
		model.addAttribute("primary", commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId())); // 다국어 여부 - 1(primary) / 2(secondary)
		model.addAttribute("preSusinGroupStr", preSusinGroupStr);
		model.addAttribute("draftAllFlag", draftAllFlag);
		model.addAttribute("nonElecRecType",nonElecRecType);
		model.addAttribute("nonUseDocAttachYN",nonUseDocAttachYN);
		model.addAttribute("upperDeptCode", upperDeptCode);
		model.addAttribute("upperDeptName", upperDeptName);
		model.addAttribute("draftAllTypeB", ezCommonService.getTenantConfig("draftAllTypeB", userInfo.getTenantId()));

//		logger.debug("ezApprovalInfo ended.");
		
		return "ezApprovalG/apprGezApprovalInfo";
	}
	
	/**
	 * 전자결재G 결재라인 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprLineRequest.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String aprLineRequest(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("aprLineRequest started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String reDraftFlag = "DRAFT";
		String isUsed = request.getParameter("isUsed");
		String beforeDocID = request.getParameter("beforeDocID");
		String mode = request.getParameter("mode");
		String docState = request.getParameter("docState");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		if (isUsed == null) {
			isUsed = "";
		}
		
		if (beforeDocID == null) {
			beforeDocID = "";
		}
		
		if (request.getParameter("reDraft") != null) {
			reDraftFlag = request.getParameter("reDraft");
		}
		
		String result = ezApprovalGService.getAprLineInfo(docID.trim(), userID, formID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), reDraftFlag, isUsed, beforeDocID, mode, docState);

		logger.debug("aprLineRequest ended.");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/getLineTemplist.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getLineTemplist(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Locale locale) throws Exception{
		logger.debug("getLineTemplist started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String tempList = ezApprovalGService.getTempList(userID, formID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		String headerXML = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t379", locale) + "</NAME><WIDTH>100%</WIDTH></HEADER></HEADERS><ROWS>" + tempList + "</ROWS></LISTVIEWDATA>";
		
		logger.debug("getLineTemplist ended.");
		
		return headerXML;
	}
	
	/**
	 * 전자결재G 양식체크 얼러트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/formCheckUI.do", method = RequestMethod.GET)
	public String formCheckUI(){
		return "ezApprovalG/apprGFormCheckUI";
	}
	
	/**
	 * 전자결재G 의견얼러트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezAprOpinion.do", method = RequestMethod.GET)
	public String ezAprOpinion(HttpServletRequest req, Model model){
		
		if (req.getParameter("type") != null) {
			String type = req.getParameter("type");
			model.addAttribute("type", type);
		}
		
		if (req.getParameter("formURL") != null) {
			String formURL = req.getParameter("formURL");
			model.addAttribute("formURL", formURL);
		}
		
		if (req.getParameter("formDocType") != null) {
			String formDocType = req.getParameter("formDocType");
			model.addAttribute("formDocType", formDocType);
		}

		if (req.getParameter("editModeYN") != null) {
			String editModeYN = req.getParameter("editModeYN");
			model.addAttribute("editModeYN", editModeYN);
		}
		
		return "ezApprovalG/apprGezAprOpinion";
	}
	
	/**
	 * 전자결재G 메일발송 선택 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezAprOpinionSend.do", method = RequestMethod.GET)
	public String ezAprOpinionSend(){
		return "ezApprovalG/apprGezAprOpinionSend";
	}
	/**
	 * 전자결재G 결재라인저장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprLineSave.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String aprLineSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("aprLineSave started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String strXML = request.getParameter("ret");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = ezApprovalGService.updateLineInfo(strXML, userInfo.getCompanyID(), userInfo.getLang(), userInfo, "");
		
		logger.debug("aprLineSave result : " + result); 
		logger.debug("aprLineSave ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 수신정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDeptSave.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String aprDeptSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("aprDeptSave started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String strXML = request.getParameter("aprDeptInfo");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}

		String result = ezApprovalGService.updateReceiptInfo(strXML, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag);
		
		logger.debug("aprDeptSave ended.");
		
 		return result;
	}
	
	/**
	 * 전자결재G 결재선저장 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprLineTempletName.do", method = RequestMethod.GET)
	public String aprLineTempletName(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("aprLineTempletName started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		model.addAttribute("type", request.getParameter("type")== null? "" : request.getParameter("type"));
		model.addAttribute("mode", request.getParameter("mode")== null? "" : request.getParameter("mode"));
		model.addAttribute("approvalFlag", approvalFlag);
		
		logger.debug("aprLineTempletName ended.");
		
		return "ezApprovalG/apprGaprLineTempletName";
	}
	
	/**
	 * 전자결재G 결재선리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprLineTempletList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String aprLineTempletList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("aprLineTempletList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.getLineTempletInfo(formID, userID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("aprLineTempletList ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 결재선리스트 정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprLineTempletListInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String aprLineTempletListInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("aprLineTempletListInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprSN = request.getParameter("aprLineSN");
		String result = ezApprovalGService.getLineTempletDetailInfo(formID, userID, aprSN, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("aprLineTempletListInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 양식세부사항 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getFormDetail.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getFormDetail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,HttpServletRequest request) throws Exception{
		logger.debug("getFormDetail started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String formID = request.getParameter("formID");
		String companyID = request.getParameter("companyID");
		String resultXML = ezApprovalGService.getFormInfoDetail(formID, companyID, userInfo.getTenantId());
		
		logger.debug("getFormDetail ended.");
		
		return resultXML;
	}
	
	/**
	 * 전자결재G 기안하기 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getFormRecv.do", produces = "text/plain;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getFormRecv(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getFormRecv started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String formID = request.getParameter("formID");
		String useReceiveInfoName = ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId());
		String result = ezApprovalGService.getFormRecvApr(docID, formID, userInfo.getId(), userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), useReceiveInfoName);

		logger.debug("<<<result : " + result );
		logger.debug("getFormRecv ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 새문서만들기 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/createNewDoc.do", produces = "text/plain;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String createNewDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("createNewDoc started.");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.createNewDoc(formID, userInfo.getCompanyID(),userInfo.getTenantId());
		logger.debug("createNewDoc end.");

		return result;
	}
	
	/**
	 * 전자결재G 현재날짜(시분초까지) 표출 Method
	 * @throws Exception 
	 */
	@RequestMapping(value = "/ezApprovalG/getFullDate.do", produces = "text/plain;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getFullDate(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		logger.debug("getFullDate started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String fullDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset() ,false);
		fullDate = fullDate.substring(0, 16).replace("-", "."); 
		
		logger.debug("getFullDate ended.");
		
		return fullDate;
	}
	
	/**
	 * 전자결재G 현재날짜 표출 Method
	 * @throws Exception 
	 */
	@RequestMapping(value = "/ezApprovalG/getDate.do", produces = "text/plain;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getDate(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		logger.debug("getDate started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String fullDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		fullDate = fullDate.substring(0, 10).replace("-", ".");
		
		logger.debug("getDate ended.");
		
		return fullDate;
	}
	
	/**
	 * 전자결재G 기안취소시 언두 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/undoDoc.do", produces = "text/plain;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String undoDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("undoDoc started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");

		String result = ezApprovalGService.deleteDocInfo(docID, "CHECK", userInfo.getCompanyID(), userInfo.getTenantId());

		logger.debug("undoDoc ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 결재선저장하기 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/createAprLineTemplet.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String createAprLineTemplet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String aprLineXml) throws Exception{
		logger.debug("createAprLineTemplet started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(aprLineXml);
		String result = ezApprovalGService.updateLineTempletDetailInfo(xmlDom, userInfo.getLocale(), userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		logger.debug("createAprLineTemplet result = " + result); 
		logger.debug("createAprLineTemplet ended." );
		
		return result;
	}
	
	/**
	 * 전자결재G 결재선 삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/delAprLineTempletList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String delAprLineTempletList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("delAprLineTempletList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprLineSN = request.getParameter("aprLineSN");
		String result = ezApprovalGService.deleteLineTempletDetailInfo(formID, userID, aprLineSN, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("delAprLineTempletList ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 결재선적용하기 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/addToAprLine.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String addToAprLine(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("addToAprLine started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprSN = request.getParameter("aprSN");
		String result = ezApprovalGService.addToAprLine(userID, formID, aprSN, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("addToAprLine ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 수신자정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDeptRequest.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String aprDeptRequest(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("aprDeptRequest started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String mode = "ING";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String isUsed = request.getParameter("isUsed");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		if (isUsed == null) {
			isUsed = "";
		}
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		
		String result = ezApprovalGService.getReceiptInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang(),userInfo.getTenantId(), userInfo.getOffset(), approvalFlag, isUsed, userInfo.getLocale());
		
		logger.debug("aprDeptRequest ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 수신처저장얼러트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDeptTempletName.do", method = RequestMethod.GET)
	public String aprDeptTempletName(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("aprDeptTempletName started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		model.addAttribute("approvalFlag", approvalFlag);
		
		logger.debug("aprDeptTempletName ended.");
		
		return "ezApprovalG/apprGaprDeptTempletName";
	}
	
	/**
	 * 전자결재G 수신처저장리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getAprDeptTempletList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getAprDeptTempletList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getAprDeptTempletList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		
		String result = ezApprovalGService.getReceiptTempletInfo(formID, userID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("getAprDeptTempletList ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 수신처 즐겨찾기 리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getReceptTemplist.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getReceptTemplist(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Locale locale) throws Exception{
		logger.debug("getReceptTemplist started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String tempList = ezApprovalGService.getTempList3(userID, formID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		String headerXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t379", locale) + "</NAME><WIDTH>100%</WIDTH></HEADER></HEADERS><ROWS>" + tempList + "</ROWS></LISTVIEWDATA>";
		
		logger.debug("getReceptTemplist ended.");
		
		return headerXml;
	}
	
	/**
	 * 전자결재G 수신처 즐겨찾기 리스트디테일 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getAprDeptTempletListInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getAprDeptTempletListInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getAprDeptTempletListInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprSN = request.getParameter("aprSN");
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		String result = ezApprovalGService.getReceiptTempletDetailInfo(formID, userID, aprSN, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), approvalFlag);
		
		logger.debug("getAprDeptTempletListInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 수신처 그룹 리스트 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getReceptGroupList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getReceptGroupList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Locale locale, HttpServletRequest request) throws Exception{
		logger.debug("getReceptGroupList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
        String extReceptYn = request.getParameter("extReceptYn");
        
        String tempList = ezApprovalGService.getTempList(userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), extReceptYn);
		String headerXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t1568", locale) + "</NAME><WIDTH>100%</WIDTH></HEADER></HEADERS><ROWS>" + tempList + "</ROWS></LISTVIEWDATA>";
		
		logger.debug("getReceptGroupList ended.");
		
		return headerXml;
	}
	
	/**
	 * 전자결재G 수신처 그룹 추가 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getReceptGroupADDTo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getReceptGroupADDTo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getReceptGroupADDTo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String groupID = request.getParameter("groupID");
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		String xmlList = ezApprovalGService.getListXML(groupID, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLocale(), approvalFlag);
		
		logger.debug("getReceptGroupADDTo ended.");
		
		return xmlList;
	}
	
	/**
	 * 전자결재G 수신처 그룹 리스트디테일 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getReceptGroupDetailList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getReceptGroupDetailList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Locale locale, HttpServletRequest request) throws Exception{
		logger.debug("getReceptGroupDetailList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String groupID = request.getParameter("groupID");
		String tempList = ezApprovalGService.getTempList2(groupID, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
		String headerXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t950", locale) + "</NAME><WIDTH>100%</WIDTH></HEADER></HEADERS><ROWS>" + tempList + "</ROWS></LISTVIEWDATA>";
		
		logger.debug("getReceptGroupDetailList ended.");
		
		return headerXml;
	}
	
	/**
	 * 전자결재G 수신처 즐겨찾기 적용 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/addToAprDept.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String addToAprDept(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("addToAprDept started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprDeptSN = request.getParameter("aprSN");
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		String result = ezApprovalGService.addToAprDept(userID, formID, aprDeptSN, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo.getLocale(), approvalFlag);
		
		logger.debug("addToAprDept ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 수신처 즐겨찾기 삭제 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/delAprDeptTempletList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String delAprDeptTempletList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("delAprDeptTempletList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprDeptSN = request.getParameter("aprSN");
		String result = ezApprovalGService.deleteReceiptTempletDetailInfo(formID, userID, aprDeptSN, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("delAprDeptTempletList ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 수신처 즐겨찾기 추가 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/createAprDeptTemplet.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String createAprDeptTemplet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlDom) throws Exception{
		logger.debug("createAprDeptTemplet started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlDom);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		String result = ezApprovalGService.updateReceiptTempletDetailInfo(doc, userInfo.getCompanyID(), userInfo.getTenantId(), approvalFlag);
		
		logger.debug("createAprDeptTemplet ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 대기능 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getTaskCategory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskCategory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getTaskCategory started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String type = request.getParameter("strType");
		String result = ezApprovalGService.getTaskCategory(deptCode, companyID, type, userInfo.getTenantId());
		
		logger.debug("getTaskCategory ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 중기능 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getTaskMiddleCategory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskMiddleCategory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getTaskMiddleCategory started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String cateCode = request.getParameter("cateCode");
		String result = ezApprovalGService.getTaskMiddleCategory(deptCode, companyID, cateCode, userInfo.getTenantId());

		logger.debug("getTaskMiddleCategory ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 소기능 이하 모두 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getTaskSubCategoryAll.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskSubCategoryAll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getTaskSubCategoryAll started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String cateCode = request.getParameter("cateCode");
		String strType = request.getParameter("strType");
		String initFlag = request.getParameter("initFlag");
		String viewFlag = request.getParameter("viewFlag") == null ? "N" : request.getParameter("viewFlag");

		String result = ezApprovalGService.getTaskSubCategoryAll(deptCode, companyID, cateCode, strType, initFlag, userInfo.getTenantId(), viewFlag);
		
		logger.debug("getTaskSubCategoryAll ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 소기능 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getTaskSubCategory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskSubCategory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getTaskSubCategory started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String cateCode = request.getParameter("cateCode");
		String strType = request.getParameter("strType");
		String result = ezApprovalGService.getTaskSubCategory(deptCode, companyID, cateCode, strType, userInfo.getTenantId());
		
		logger.debug("getTaskSubCategory ended.");

		return result;
	}
	
	/**
	 * 전자결재G 기록물철 소기능(소분류) 별 단위업무정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getTaskInSubCategory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTaskInSubCategory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getTaskInSubCategory started.");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		String deptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String cateCode = request.getParameter("cateCode");
		String strType = request.getParameter("strType");
		String result = ezApprovalGService.getTaskInSubCategory(deptCode, companyID, cateCode, strType, userInfo.getPrimary(), userInfo.getTenantId(), approvalFlag);
		
		logger.debug("getTaskInSubCategory ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getCabinetSimpleList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getCabinetSimpleList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getCabinetSimpleList started.");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String companyID = request.getParameter("companyID");
		String processDeptCode = request.getParameter("processDeptCode");
		String productionYear = request.getParameter("produceYear");
		String taskCode = request.getParameter("taskCode");
		String flag = request.getParameter("flag");
		String langType = request.getParameter("langType");
		String selYear = request.getParameter("selYear");

		/* 2024-08-08 양지혜 - 전자결재G > 상위부서문서함 */
		Map<String, String> upDeptInfo = ezApprovalGService.getUpperDeptInfo(userInfo.getDeptID(), userInfo.getTenantId());
		if (upDeptInfo.get("USEUPPERDEPTBOX") != null && upDeptInfo.get("USEUPPERDEPTBOX").equals("Y")) {
			processDeptCode = upDeptInfo.get("upperDeptCode");
		}		
		
		String result = ezApprovalGService.getSimpleCabinetList(companyID, processDeptCode, productionYear, taskCode, flag, langType, userInfo.getTenantId(), selYear);
		logger.debug("getCabinetSimpleList ended.");
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 단위업무 검색 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/findTask.do", method = RequestMethod.GET)
	public String findTask() throws Exception{
		return "ezApprovalG/apprGFindTask";
	}
	
	/**
	 * 전자결재G 기록물철 단위업무 검색 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/findTaskList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String findTaskList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("findTaskList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		String deptCode = request.getParameter("deptCode") != null ? request.getParameter("deptCode").trim() : "";
		String title = request.getParameter("title") != null ? request.getParameter("title").trim() : "";
		String code = request.getParameter("code") != null ? request.getParameter("code").trim() : "";
		String flag = request.getParameter("flag") != null ? request.getParameter("flag") : "";
		String companyID = request.getParameter("companyID") != null ? request.getParameter("companyID") : "";
		String langType = request.getParameter("langType") != null ? request.getParameter("langType") : "";
		String pageSize = request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "";
		String pageNO = request.getParameter("pageNO") != null ? request.getParameter("pageNO") : "";
		String result = "";
		
		if (approvalFlag.equals("S")) {
			companyID = userInfo.getCompanyID();
			langType = userInfo.getLang();

			result = ezApprovalGService.findTaskS(deptCode, title, companyID, langType, userInfo.getTenantId(), approvalFlag);
		} else {
			result = ezApprovalGService.findTask(deptCode, title, code, flag, companyID, langType, pageSize, pageNO, userInfo.getTenantId(), approvalFlag);
		}
		
		logger.debug("findTaskList ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 의견버튼 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprOpinion.do", method = RequestMethod.GET)
	public String aprOpinion(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		logger.debug("aprOpinion started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String susinAdmin = "";
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());
		String agreeReturnType = ezCommonService.getTenantConfig("PersonalAgreeReturnType", userInfo.getTenantId());
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		String orgDeptID = request.getParameter("orgDeptID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
			if (orgDeptID != null && !orgDeptID.equals("") && !orgDeptID.equals(userInfo.getDeptID())) {
				String decData = egovFileScrty.decryptAES(loginCookie);
				
				String[] decDataArray = decData.split("///", -1);
				
				decDataArray[9] = orgDeptID;
				decDataArray[10] = orgCompanyID;
				
				decData = "";
				for (int i = 0; i < decDataArray.length; i++) {
					if (i==0) {
						decData += decDataArray[i];
					} else {
						decData += "///"+decDataArray[i];
					}
				}
				
				String loginCookie2 = egovFileScrty.encryptAES(decData);
				
				userInfo = commonUtil.aprUserInfo(loginCookie2);
			}
		}
		
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("junGyulFlag", junGyulFlag);
		model.addAttribute("agreeReturnType", agreeReturnType);
		
		logger.debug("aprOpinion ended.");
		
		return "ezApprovalG/apprGaprOpinion";
	}
	
	/**
	 * 전자결재G 기안 의견리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/opinionRequest.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String opinionRequest(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("opinionRequest started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		/* 2023-06-26 민지수 - 문서 state에 따른 진행/완료문서 분기처리 */
		String state = request.getParameter("state");

		// 진행
		if (state.equals("001") || state.equals("004") || state.equals("APR")) {
			String result = ezApprovalGService.getOpinionInfo(docID, "CAPR", "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
			logger.debug("opinionRequest ended.");
			return result;
		}
		// 완료
		else {
			String result = ezApprovalGService.getOpinionInfo(docID, "CADD", "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
			logger.debug("opinionRequest ended.");
			return result;
		}

	}

	/**
	 * 전자결재G 기안 의견삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/opinionDel.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String opinionDel(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("opinionDel started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String isSihangReject = request.getParameter("isSihangReject") != null ? request.getParameter("isSihangReject") : ""; // 시행문의 반송을 위한 플래그 추가
		String result = "";
		String pMode = request.getParameter("pMode");

		if (isSihangReject.equals("Y")) { // 미처리문서함에 들어온 내부시행문의 의견 삭제 분기 (완료된 문서의 의견테이블에 접근)
			result = ezApprovalGService.deleteEndOpinionInfo(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		} else if (pMode.equals("END")) { // 2023-06-26 민지수 - 완료문서 추가의견 삭제 분기
			result = ezApprovalGService.deleteAddOpinionInfo(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		} else { // 기존 의견 삭제 분기
			result = ezApprovalGService.deleteOpinionInfo(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		}
		
		logger.debug("result = " + result);
		
		logger.debug("opinionDel ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 의견저장 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/opinionSave.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String opinionSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlDom, HttpServletRequest request) throws Exception{
		logger.debug("opinionSave Start");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document docXML = commonUtil.convertStringToDocument(xmlDom);
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		String isSihangReject = request.getParameter("isSihangReject") != null ? request.getParameter("isSihangReject") : ""; // 시행문의 반송을 위한 플래그 추가
		String pMode = request.getParameter("pMode");

		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = "";
		
		if (isSihangReject.equals("Y")) { // 미처리문서함에 들어온 내부시행문의 반송의견 저장 분기 (완료된 문서의 의견테이블에 접근)
			result = ezApprovalGService.updateOpinionSihangReject(docXML, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		} else if (pMode.equals("END")) { // 2023-06-26 민지수 - 완료문서 추가의견 저장 분기
			result = ezApprovalGService.updateAddOpinionInfo(docXML, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		}else { // 기존 의견 저장 분기
			result = ezApprovalGService.updateOpinionInfo(docXML, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		}
		
		logger.debug("opinionSave End");
		return result;
	}

	/**
	 * 전자결재G 기안 첨부 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprAttach.do", method = RequestMethod.GET)
	public String aprAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("aprAttach Started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String formID = request.getParameter("formID");
		String docID = request.getParameter("docID");
		String draftFlag = request.getParameter("draftFlag");
		String serverName = userInfo.getServerName();
		String susinAdmin = "";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		//2017-11-09 장진혁 전자결재 총 첨부용량 제한 기능 추가
		String apprTotalAttachLimit = ezCommonService.getTenantConfig("ApprTotalAttachLimit", userInfo.getTenantId());
		String ext = request.getParameter("ext");
		
		// a=1은 수발신담당자
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		// A36 : 변환문서, A39 : 첨부문서
		String formList = ezApprovalGService.getOptionInfo("A36", "007", userInfo, "CODE");
		String poptExt = ezApprovalGService.getOptionInfo("A39", "001", userInfo, "CODE");
		// 첨부파일의 maxSize 설정(단위 MB)
		String maxSize = ezApprovalGService.getOptionInfo("A39", "002", userInfo, "CODE");
		
		// 첨부파일명 최대길이
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
		String isBody = "";

		if (!formList.replace(formID, "").equals(formList)) {
			isBody = "YES";
		}
		
		/* 2020-11-12 홍승비 - 전자결재 대용량첨부 관련 설정 추가 */
		String apprAttachLimit = ezCommonService.getTenantConfig("ApprAttachLimit", userInfo.getTenantId()); // 일반 첨부파일의 총 크기제한 = 일반 첨부파일 -> 대용량으로 변경되는 기준 크기
		String bigSizeAttachLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 개수제한
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
		String bigSizeApprAttachLimit = ezCommonService.getTenantConfig("BigSizeApprAttachLimit", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 크기제한
		//String pBigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String spanDisplayStyle = "inline-block";
		
		logger.debug("apprAttachLimit=" + apprAttachLimit + ", bigSizeApprAttachLimit=" + bigSizeApprAttachLimit);
		
		// 2020-12-30 김민성 - 시행문 양식인 경우 첨부파일 6MB로 제한
		boolean isOuterForm = ezApprovalGService.isOuterForm(formID, userInfo.getCompanyID(), userInfo.getTenantId());
		if(isOuterForm) {
			bigSizeApprAttachLimit = "0";
			apprTotalAttachLimit = "20";
			apprAttachLimit = "20";
		}
		
		//String bigSizeMailAttachDelDate = EgovDateUtil.addDay(EgovDateUtil.getToday("-"), Integer.parseInt(pBigAttachDownloadDay), "yyyy-MM-dd");
        //String pBigAttachDownloadPeriod = EgovDateUtil.getToday("/") + " ~ " + EgovDateUtil.addDay(EgovDateUtil.getToday("/"), Integer.parseInt(pBigAttachDownloadDay), "yyyy/MM/dd");
        int pBigAttachLimitCount = bigSizeAttachLimitCount == null || bigSizeAttachLimitCount.equals("") ? 0 : Integer.parseInt(bigSizeAttachLimitCount);
        int pBigAttachDownloadLimitCount = bigSizeAttachDownloadLimitCount == null || bigSizeAttachDownloadLimitCount.equals("") ? 0 : Integer.parseInt(bigSizeAttachDownloadLimitCount);
        
        // 전자결재 첨부파일은 메일과 다르게 "총 첨부용량제한"값이 존재하므로, 알림 메세지의 첫번째 문구로 추가한다. (apprTotalAttachLimit)
        // 전체 첨부파일의 파일크기 합은 ~MB까지 가능합니다.
        String pAttachWarning0 = messageSource.getMessage("ezSystem.HSBAppr02", userInfo.getLocale()) + apprTotalAttachLimit + messageSource.getMessage("ezSystem.HSBAppr03", userInfo.getLocale());
        
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
        
        // 대용량 첨부파일 자동삭제(저장만료)기능 사용하지 않음
        //pAttachWarning1 += pBigAttachDownloadDay + messageSource.getMessage("ezEmail.lhm21", userInfo.getLocale()); // 일반첨부파일은 총 10MB까지 가능하며, 대용량첨부는 800MB까지 가능(최대 1개 첨부, 1회까지 다운로드 가능, 14일후 자동삭제)
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
        
        logger.debug("pAttachWarning1=" + pAttachWarning1 + ", pBigAttachLimitCount=" + pBigAttachLimitCount+ ", pBigAttachDownloadLimitCount=" + pBigAttachDownloadLimitCount);
        // 대용량첨부 관련 설정 끝
        
        //2021-03-05 남학선 첨부를 올린사람 이외의 사람도 삭제가능여부를  결정하는 테넌트 값
        String delAttachByOthers = ezCommonService.getTenantConfig("delAttachByOthers", userInfo.getTenantId()).equals("") ? "0" : ezCommonService.getTenantConfig("delAttachByOthers", userInfo.getTenantId()); 
        
        /* 2022-01-20 홍승비 - 일괄기안 시 각 안의 파일첨부여부 플래그 변경을 위하여 일괄기안여부 플래그와 안 번호 전달 */
        String draftAllFlag = request.getParameter("draftAllFlag") != null ? request.getParameter("draftAllFlag") : "N";
        String anNo = request.getParameter("anNo") != null ? request.getParameter("anNo") : "0";
        
		model.addAttribute("formID", formID);
		model.addAttribute("docID", docID);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("serverName", serverName);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("poptExt", poptExt);
		model.addAttribute("maxSize", maxSize);
		model.addAttribute("isBody", isBody);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		//2017-11-09 장진혁 전자결재 총 첨부용량 제한 기능 추가
		model.addAttribute("apprTotalAttachLimit", apprTotalAttachLimit);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("ext", ext);
		/* 2020-11-12 홍승비 - 전자결재 대용량첨부 추가 */
		model.addAttribute("pAttachWarning0", commonUtil.stripScriptTagsAndFunctions(pAttachWarning0));
		model.addAttribute("pAttachWarning1", commonUtil.stripScriptTagsAndFunctions(pAttachWarning1));
		model.addAttribute("apprAttachLimit", apprAttachLimit); // 일반 첨부파일의 총 크기제한 = 일반 첨부파일 -> 대용량으로 변경되는 기준 크기
		model.addAttribute("bigSizeAttachLimitCount", bigSizeAttachLimitCount); // 전자결재 대용량 첨부파일 개수제한
		model.addAttribute("bigSizeApprAttachLimit", bigSizeApprAttachLimit); // 전자결재 대용량 첨부파일 크기제한
		//model.addAttribute("bigSizeApprAttachDelDay", pBigAttachDownloadDay); // 전자결재 대용량 첨부파일 보존기간
		model.addAttribute("spanDisplayStyle", commonUtil.stripScriptTagsAndFunctions(spanDisplayStyle)); // 첨부파일 알림 메세지 스타일
		model.addAttribute("isOuterForm", isOuterForm);
		model.addAttribute("delAttachByOthers", delAttachByOthers);
		// 일괄기안 관련 파라미터
		model.addAttribute("draftAllFlag", draftAllFlag);
		model.addAttribute("anNo", anNo);
		
		logger.debug("aprAttach ended");
		
		return "ezApprovalG/apprGaprAttach";
	}
	
	/**
	 * 전자결재G 기안 첨부 업로드(멀티) 호출 Method
	 * 2017-11-08 장진혁 구현
	 */
	@RequestMapping(value = "/ezApprovalG/multiUpload.do", method = RequestMethod.POST)	
	public String multiUpload(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, MultipartHttpServletRequest request, Model model) throws Exception{
		logger.debug("multiUpload started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);		 
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		String companyID = request.getParameter("compid");		
		String docID = request.getParameter("docid");
		String fileAttachSN = request.getParameter("attachsn");
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String oldYear = ezApprovalGService.getDocHrefYear(docID, companyID, userInfo.getTenantId());
		
		// uploadFile, tempUploadFile 디렉토리 경로
		String upd = dirPath + companyID + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator;
		String tempUpd = dirPath + companyID + commonUtil.separator + "tempUploadFile" + commonUtil.separator;
		EzFile uFile = new EzFile(commonUtil.detectPathTraversal(upd));
		File tFile = new File(commonUtil.detectPathTraversal(tempUpd)); // tempUploadFile 경로의 임시 파일이므로 EzFAL 적용 제외
		
		if (uFile.isDirectory()) {
			uFile.mkdirs();
		}
		
		if (!tFile.isDirectory()) {
			tFile.mkdirs();
		}
		
		if (!uFile.isDirectory()) {
			uFile.mkdirs();
		}
		
		//2017-11-08 장진혁 멀티 파일업로드 작업
		List<MultipartFile> multiFile = request.getFiles("file1");
		int cnt = multiFile.size();
		String[] resultUploadArray = new String[cnt];
		String[] fileLocationArray = new String[cnt];
		String[] fileNameArray = new String[cnt];
		int[] fileSizeArray = new int[cnt];
		
		for (int i = 0; i < cnt; i++) {
			String fileName = multiFile.get(i).getOriginalFilename();
			
			int fileSize = (int) multiFile.get(i).getSize();
			int maxSize = 0;
			
			if (request.getParameter("maxsize") != null) {
				maxSize = Integer.parseInt(request.getParameter("maxsize"));
			}
			
			if (fileName.indexOf("\\") > -1) {
				fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
			}
			
			fileNameArray[i] = fileName;
			fileSizeArray[i] = fileSize;
			
			// 첨부파일 순번 설정 4자리
			String fileAttachFormatSN = "00000" + fileAttachSN;
			fileAttachFormatSN = fileAttachFormatSN.substring(fileAttachFormatSN.length() - 4, fileAttachFormatSN.length());
		
			String saveFileName = docID + fileAttachFormatSN + fileName;
			
			/* 2022-03-17 홍승비 - maxSize가 0인 경우, 전자결재 첨부파일 총용량제한은 무제한으로 취급 */
			if (maxSize != 0 && fileSize > maxSize) {
				resultUploadArray[i] = "overflow";
			} else {
				// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
				String extStr = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

				// 첨부파일의 확장자가 useExtension에 포함되지 않은경우
				if ((extStr.isEmpty() || useExtension.toLowerCase().indexOf(extStr) == -1) && !useExtension.equals("*")) {
					resultUploadArray[i] = "denied";
				} else {
					// tempUploadFile에 파일 생성
					writeUploadedFile(multiFile.get(i), saveFileName, tempUpd);
					fileLocationArray[i] = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + companyID + commonUtil.separator + "tempUploadFile" + commonUtil.separator + saveFileName;
					resultUploadArray[i] = "true";
					
					fileAttachSN = Integer.toString(Integer.parseInt(fileAttachSN) + 1);
				}
			}
		}
			
		model.addAttribute("resultUpload", resultUploadArray);
		model.addAttribute("fileLocation", fileLocationArray);
		model.addAttribute("fileName", fileNameArray);
		model.addAttribute("fileSize", fileSizeArray);
		
		logger.debug("multiUpload ended");
		
		return "json";
	}
	
	/**
	 * 2020-11-17 홍승비 - 전자결재 > 웹폴더 첨부 전용 메서드 추가
	 * */
	@RequestMapping(value = "/ezApprovalG/multiUploadWebFolder.do", method = RequestMethod.POST)	
	public String multiUploadWebFolder(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, MultipartHttpServletRequest request, Model model) throws Exception{
		logger.debug("multiUploadWebFolder started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);		 
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		String companyID = request.getParameter("compid");		
		String docID = request.getParameter("docid");
		String fileAttachSN = request.getParameter("attachsn");
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String oldYear = ezApprovalGService.getDocHrefYear(docID, companyID, userInfo.getTenantId());
		String webFolderFileStr = request.getParameter("webFolderFileStr");
		
		// uploadFile, tempUploadFile 디렉토리 경로
		String upd = dirPath + companyID + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator;
		String tempUpd = dirPath + companyID + commonUtil.separator + "tempUploadFile" + commonUtil.separator;
		EzFile uFile = new EzFile(commonUtil.detectPathTraversal(upd));
		File tFile = new File(commonUtil.detectPathTraversal(tempUpd)); // tempUploadFile 경로의 임시 파일이므로 EzFAL 적용 제외
		
		if (uFile.isDirectory()) {
			uFile.mkdirs();
		}
		
		if (!tFile.isDirectory()) {
			tFile.mkdirs();
		}
		
		if (!uFile.isDirectory()) {
			uFile.mkdirs();
		}
		
		String[] webFolderFileArray = webFolderFileStr.split("\\|\\|\\|");
		int cnt = webFolderFileArray.length;
		String[] resultUploadArray = new String[cnt];
		String[] fileLocationArray = new String[cnt];
		String[] fileNameArray = new String[cnt];
		int[] fileSizeArray = new int[cnt];
		
		// 0:파일명, 1:파일사이즈, 2:파일경로
		for (int i = 0; i < cnt; i++) {
			
			String[] tempWebFolderFile = webFolderFileArray[i].split("\\|");
			String fileName = tempWebFolderFile[0];
			int fileSize = Integer.parseInt(tempWebFolderFile[1]);
			int maxSize = 0;
			
			if (request.getParameter("maxsize") != null) {
				maxSize = Integer.parseInt(request.getParameter("maxsize"));
			}
			
			if (fileName.indexOf("\\") > -1) {
				fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
			}
			
			fileNameArray[i] = fileName;
			fileSizeArray[i] = fileSize;
			
			// 첨부파일 순번 설정 4자리
			String fileAttachFormatSN = "00000" + fileAttachSN;
			fileAttachFormatSN = fileAttachFormatSN.substring(fileAttachFormatSN.length() - 4, fileAttachFormatSN.length());
		
			String saveFileName = docID + fileAttachFormatSN + fileName;
			
			if (fileSize > maxSize) {
				resultUploadArray[i] = "overflow";
			} else {
				// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
				String extStr = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

				// 첨부파일의 확장자가 useExtension에 포함되지 않은경우
				if ((extStr.isEmpty() || useExtension.toLowerCase().indexOf(extStr) == -1) && !useExtension.equals("*")) {
					resultUploadArray[i] = "denied";
				} else {
					// 웹폴더 파일 경로의 해당 파일이 존재한다면, 새로운 전자결재 첨부파일 경로에 파일 카피를 진행 (실제 파일이 없다면 다음 루프 진행)
					File orgWebFolderFile = new File(commonUtil.getRealPath(request) + tempWebFolderFile[2]);
					if (!orgWebFolderFile.exists()) {
						fileLocationArray[i] = "";
						resultUploadArray[i] = "false";
						continue;
					}
					else {
						File newAttachFile = new File(tempUpd + saveFileName); // 새로운 전자결재 첨부파일 경로에 형식적인 임의 파일을 생성
						FileUtils.copyFile(orgWebFolderFile, newAttachFile); // 새로운 파일을 웹폴더 파일로 덮어쓰기(카피)
						
						String tempUploadFilePath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + companyID + commonUtil.separator + "tempUploadFile" + commonUtil.separator + saveFileName;
						fileLocationArray[i] = tempUploadFilePath;
						resultUploadArray[i] = "true";
						
						fileAttachSN = Integer.toString(Integer.parseInt(fileAttachSN) + 1);
					}
				}
			}
		}
			
		model.addAttribute("resultUpload", resultUploadArray);
		model.addAttribute("fileLocation", fileLocationArray);
		model.addAttribute("fileName", fileNameArray);
		model.addAttribute("fileSize", fileSizeArray);
		
		logger.debug("multiUploadWebFolder ended");
		
		return "json";
	}
	
	/**
	 * 전자결재G 기안 첨부업로드 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/upload.do", method = RequestMethod.POST)
	public String upload(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, MultipartHttpServletRequest request, Model model) throws Exception{
		logger.debug("upload started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		MultipartFile multilFile = request.getFile("file1");
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		String companyID = request.getParameter("compid");
		String docID = request.getParameter("docid");
		String fileAttachSN = request.getParameter("attachsn");
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String oldYear = ezApprovalGService.getDocHrefYear(docID, companyID, userInfo.getTenantId());
		String fileName = multilFile.getOriginalFilename();
		String resultUpload = "";
		String fileLocation = "";
		int fileSize = (int) multilFile.getSize();
		int maxSize = 0;
		
		if (request.getParameter("maxsize") != null) {
			maxSize = Integer.parseInt(request.getParameter("maxsize"));
		}
		// uploadFile, tempUploadFile 디렉토리 경로
		String upd = dirPath + companyID + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator;
		String tempUpd = dirPath + companyID + commonUtil.separator + "tempUploadFile" + commonUtil.separator;
		EzFile uFile = new EzFile(commonUtil.detectPathTraversal(upd));
		File tFile = new File(commonUtil.detectPathTraversal(tempUpd)); // tempUploadFile 경로의 임시 파일이므로 EzFAL 적용 제외
		
		if (uFile.isDirectory()) {
			uFile.mkdirs();
		}
		
		if (!tFile.isDirectory()) {
			tFile.mkdirs();
		}
		
		if (!uFile.isDirectory()) {
			uFile.mkdirs();
		}
		if (fileName.indexOf("\\") > -1) {
			fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
		}
		// 첨부파일 순번 설정 4자리
		String fileAttachFormatSN = "00000" + fileAttachSN;
		fileAttachFormatSN = fileAttachFormatSN.substring(fileAttachFormatSN.length() - 4, fileAttachFormatSN.length());
		
		String saveFileName = docID + fileAttachFormatSN + fileName;
		
		if (fileSize > maxSize) {
			resultUpload = "overflow";
		} else {
			// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
			String extStr = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

			// 첨부파일의 확장자가 useExtension에 포함되지 않은경우 (확장자 대소문자 무시하도록 수정)
			if ((extStr.isEmpty() || useExtension.toLowerCase().indexOf(extStr) == -1) && !useExtension.equals("*")) {
				resultUpload = "denied";
			} else {
				// tempUploadFile에 파일 생성
				writeUploadedFile(multilFile, saveFileName, tempUpd);
				fileLocation = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + companyID + commonUtil.separator + "tempUploadFile" + commonUtil.separator + saveFileName;
				resultUpload = "true";
			}
		}
		
		model.addAttribute("resultUpload", resultUpload);
		model.addAttribute("fileLocation", fileLocation);
		model.addAttribute("fileName", fileName);
		model.addAttribute("fileSize", fileSize);
		
		logger.debug("upload ended");
		
		return "ezApprovalG/apprGupload";
	}
	
	/**
	 * 전자결재G 기안 첨부명,쪽수 호출 Method
	 * @throws Exception s
	 */
	@RequestMapping(value = "/ezApprovalG/aprAttachName.do", method = RequestMethod.GET)
	public String aprAttachName(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("aprAttachName started");
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		model.addAttribute("approvalFlag", approvalFlag);

		// 첨부파일명 최대길이
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);

		logger.debug("aprAttachName ended");
		return "ezApprovalG/apprGaprAttachName";
	}
	
	/**
	 * 전자결재G 기안 첨부리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/attachRequest.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String attachRequest(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("attachRequest started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "ING";

		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			companyID = orgCompanyID;
		}
		String result = ezApprovalGService.getAttachFileInfo(docID, mode, "", "", companyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("attachRequest ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 첨부삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/deleteServerFile.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String deleteServerFile(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		logger.debug("deleteServerFile started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String rtnVal = "";
		String docID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String attachSN = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String fileName = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		String realPath = commonUtil.getRealPath(request);
		String uploadPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String fileAttachFormatSN = "00000" + attachSN;
		fileAttachFormatSN = fileAttachFormatSN.substring(fileAttachFormatSN.length() - 4);
		
		String attachHref = uploadPath + userInfo.getCompanyID() + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator + docID + fileAttachFormatSN + fileName;
		String fileSpec = realPath + attachHref;
		
		if (ezApprovalGService.isLinkedAttachFile(attachHref)) {
			rtnVal = "TRUE";
			logger.debug("is linked attach file: {}", attachHref);
		} else if (new EzFile(commonUtil.detectPathTraversal(fileSpec)).exists()) {
			// EzFAL delete로 서버 상의 파일 삭제
			new EzFile(commonUtil.detectPathTraversal(fileSpec)).delete();
			
			rtnVal = "TRUE";
		} else {
			rtnVal = "FALSE";
		}
		
		// 대용량파일인 경우, 다운로드 횟수 레코드를 제거 (실제 파일 제거 여부와는 상관없음)
		ezApprovalGService.deleteBigAttachFileDownloadCnt(docID, attachSN, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("deleteServerFile ended");
		
		return rtnVal;
	}
	
	/**
	 * 전자결재G 기안 첨부히스토리 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/updateAttachHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String updateAttachHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("updateAttachHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String attachSN = request.getParameter("attachSN");
		String tempUserID = request.getParameter("userID");
		String tempUserName = request.getParameter("userName");
		String tempUserName2 = request.getParameter("userName2");
		String tempUserJobTitle = request.getParameter("userJobTitle");
		String tempUserJobTitle2 = request.getParameter("userJobTitle2");
		String tempUserDeptID = request.getParameter("userDeptID");
		String tempUserDeptName = request.getParameter("userDeptName");
		String tempUserDeptName2 = request.getParameter("userDeptName2");
		String modifyFlag = request.getParameter("modifyFlag");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = ezApprovalGService.updateHistoryForAttach(docID, attachSN, tempUserID, tempUserName, tempUserName2, tempUserJobTitle, tempUserJobTitle2, 
																  tempUserDeptID, tempUserDeptName, tempUserDeptName2, modifyFlag, dirPath, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("updateAttachHistory ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 첨부저장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprAttachSave.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String aprAttachSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		logger.debug("aprAttachSave started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}

		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		for (int k = 0; k < xmlDom.getElementsByTagName("DATA1").getLength(); k++) {
			String fileDocID = xmlDom.getElementsByTagName("DATA3").item(k).getTextContent();
			String oldYear = ezApprovalGService.getDocHrefYear(fileDocID, userInfo.getCompanyID(), userInfo.getTenantId());
			String upd = dirPath + userInfo.getCompanyID() + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(fileDocID) + commonUtil.separator;
			String beforePath = commonUtil.getRealPath(request) + commonUtil.detectPathTraversal(xmlDom.getElementsByTagName("DATA1").item(k).getTextContent());
			String fileName = Paths.get(beforePath).getFileName().toString();
			String deleteYN = xmlDom.getElementsByTagName("DELETE").item(k).getTextContent();

			if (!(deleteYN != null && deleteYN.equals("N"))) {
				EzFile beforeFile = new EzFile(beforePath);
				EzFile afterFile = new EzFile(commonUtil.detectPathTraversal(upd + fileName));

				// EzFile 객체 생성 시 항상 File 객체를 함께 생성하며, 기존 FileUtils를 사용하여 비교 가능
				if (FileUtils.contentEquals(beforeFile.getFile(), afterFile.getFile())) {
					continue;
				}

				try {
					if (beforeFile.isFile()) {
						if (beforeFile.exists()) {
							EzFAL.copyFile(beforeFile, afterFile);
						} else {
							throw new FileNotFoundException("not file:" + beforePath); 
						}
					} else {
						throw new FileNotFoundException("not file:" + beforePath);
					}
				} catch (Exception e) {
					logger.error("An error occurred while copying files", e);
				}

				xmlDom.getElementsByTagName("DATA1").item(k).setTextContent(commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(fileDocID) + commonUtil.separator + fileName);
			}
		}
		String result="";
		
		try {
			result = ezApprovalGService.updateAttachFileInfo(xmlDom, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = "File_NonAttach";
		}
		
		logger.debug("aprAttachSave ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 첨부삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/attachRemove.do", produces = "text/plain;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String attachRemove(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("attachRemove started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = ezApprovalGService.deleteAttachFileInfo(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("attachRemove ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 첨부다운 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/downloadAttach.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadAttach started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String docStatus = request.getParameter("docStatus");
		String filePath = request.getParameter("filePath");
		String fileName = request.getParameter("fileName");
		String docAttachSN = request.getParameter("docAttachSN") == null ? "" : request.getParameter("docAttachSN"); // 전자결재 첨부파일의 순번(없는 경우 첨부파일 다운로드가 아님)
		String realPath = commonUtil.getRealPath(request);
		String result = "";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String checkLine = "";
		
		/* 2023-03-08 홍승비 - 통합PC저장으로 결재문서와 첨부파일 다운로드 후, 임시 생성된 .zip파일 삭제 */
		String isToDelFG = request.getParameter("isToDelFG") == null ? "" : request.getParameter("isToDelFG");
		
		if (StringUtils.isBlank(fileName)) {
		    fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
		}
		
		logger.debug("docID : " + docID);
		logger.debug("docStatus : " + docStatus);
		logger.debug("filePath : " + filePath);
		logger.debug("fileName : " + fileName);

		//관리자는 권한 제한없도록 추가
		if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("m=1") > -1) {
			
			result = "PERMISSION";
		} else {
			// 결재 문서의 첨부를 다운받으려 하는사람이 결재라인에 있는지 체크 추가 2018-04-10 천성준
			if (docID != null && docStatus != null) {
				checkLine = ezApprovalGService.checkAprLine(docID.trim(), docStatus, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
			}
			
			if (docStatus != null && (docStatus.toUpperCase().equals("APR") || docStatus.toUpperCase().equals("TMP"))) {
				if (docID != null && !docID.equals("")) {
					String checkMode = "";
					
					if (docStatus.toUpperCase().equals("TMP")) {
						checkMode = "TMP";
					} else {
						checkMode = "REC";
					}
					
					Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), checkMode, userInfo.getCompanyID(), userInfo.getTenantId(), "");
					
					if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
						if (!checkLine.equals("<RESULT>TRUE</RESULT>")) {
							result = "NOTPERMISSION";
						}
					}
				}
			} else if (docStatus != null && docStatus.toUpperCase().equals("END")) {
				String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
				String pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());
				
				if (!pass.equals("<RESULT>TRUE</RESULT>")) {
					result = "NOTPERMISSION";
				}
				
				logger.debug("docStatus = " + docStatus + "|| result = " + result);
			}
			
			logger.debug("docStatus = " + docStatus + "|| result = " + result);
		}

		//해당문서가 우리 부서의 배부대장에 있는 문서인지 확인
		if (result.equals("NOTPERMISSION")) {
			int deliveryCount = ezApprovalGService.isMyDeptDeliveryDoc(userInfo.getDeptID(), docID, userInfo.getCompanyID(), userInfo.getTenantId());
			if(deliveryCount > 0){
				result = "";
			}
		}
		
		/* 
		 	2021-06-14 심기영 전자결재 첨부 파일 다운로직에서, 미리보기 뷰어 사용할 확장자 옵션화
		 	useApprImageConvert 0 이면 파일 다운 1이면 일부 확장자는 뷰어, 나머지는 다운로직
	 	*/
		String useApprImageConvert = ezCommonService.getTenantConfig("useApprImageConvert", userInfo.getTenantId());
		String apprConvertExt = ezCommonService.getTenantConfig("apprConvertExt", userInfo.getTenantId());
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		String fileNameExt =  fileName.substring(fileName.lastIndexOf(".")+1).toLowerCase();
		OutputStream output = null;
		
		// logger.debug(" === Ext Check ----->  apprConvertExt : " + apprConvertExt.toLowerCase() + "  |   fileNameExt : " + fileNameExt + "  ===  ");
		// logger.debug(" === useApprImageConvert Check ----->  useApprImageConvert : " + useApprImageConvert + "  |   fileNameExt : " + fileNameExt + "  ===  ");
		
		if (useApprImageConvert.equals("1") && apprConvertExt.toLowerCase().indexOf(fileNameExt)!=-1) {
			try {
				if (useImageConvertServer.equals("1")) { //SAT
					
					fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
					filePath = filePath.substring(0, filePath.lastIndexOf("/"));
					String fileExt = fileName.split("\\.")[fileName.split("\\.").length - 1];
					
					EzFile newFolder = new EzFile(filePath);
					if (!newFolder.exists()) {
						newFolder.mkdirs();
					}
					
					logger.debug("filePath : " + filePath);
					logger.debug("fileName : " + fileName);
					logger.debug("fileExt : " + fileExt);

					String SATimageConvertServerURL = ezCommonService.getTenantConfig("SATimageConvertServerURL", userInfo.getTenantId());
					
					filePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + filePath + "/" + fileName;
					// logger.debug("==== fileOriginPath = " + filePath);
					
					String satPath = SATimageConvertServerURL + 
							"?filepath=" + URLEncoder.encode(filePath, "UTF-8").replace("+", "%20") +
							"&filename=" + URLEncoder.encode(fileName, "UTF-8").replace("+", "%20") +
							"&fileext=" + URLEncoder.encode(fileExt, "UTF-8").replace("+", "%20") +
							"&viewerselect=image" +
							"&userid=" + userInfo.getId();
					
					// logger.debug("======= 최종 패스 :" + satPath);
					
					response.setCharacterEncoding("UTF-8");
					response.setContentType("text/html; charset=UTF-8");
					response.getWriter().write("<script language='javascript'>\n");
//					response.getWriter().write("window.history.back();");
					response.getWriter().write("window.open('"+ satPath +"', '', '_blank');\n");
					response.getWriter().write("if (typeof parent.removeTempFrame === 'function') {parent.removeTempFrame();}\n");
					response.getWriter().write("</script>");
					response.getWriter().flush();
				} else {
					
				}
				
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			} finally {
				logger.debug("downloadAttach - ViewSatDocImage ended. ");
			}
		}
		else {
			//2017-04-02 클라이언트단에서 replace해서 받아와야함.
			//fileName = fileName.replaceAll("&amp;", "&").replaceAll("&lt", "<").replaceAll("&gt;", ">");
			
			if (fileName == null || fileName.equals("")) {
				fileName = filePath.substring(filePath.lastIndexOf("/") + 1); 
			}
			
			// 대용량첨부 파일의 다운로드 횟수 초과 시 다운로드 불가능 처리
			String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
			String isBigAttachFileDownloadCntOver = "NO";
			if (!bigSizeAttachDownloadLimitCount.equals("0") && !bigSizeAttachDownloadLimitCount.equals("")) {
				isBigAttachFileDownloadCntOver = ezApprovalGService.checkBigAttachFileDownloadCntOver(docID, docAttachSN, Integer.parseInt(bigSizeAttachDownloadLimitCount), userInfo.getCompanyID(), userInfo.getTenantId());
			}
				// 대용량 첨부파일의 기간만료 및 자동삭제기능 사용안함
			// 다운로드받을 파일이 대용량첨부인 경우, 저장기간이 지나 삭제된 파일은 다운로드 불가능 처리
			/*
			String isAttachFileCanDownload = "NO";
			if (docAttachSN.equals("")) { // 전자결재 첨부파일이 아닌 경우, 분기 생략
				isAttachFileCanDownload = "YES";
			} else {
				isAttachFileCanDownload = ezApprovalGService.checkAttachFileCanDownload(docID, docAttachSN, userInfo.getCompanyID(), userInfo.getTenantId());
			}
			*/
			String isAttachFileCanDownload = "YES";
			
			if (isBigAttachFileDownloadCntOver.equals("NO") && isAttachFileCanDownload.equals("YES") && !result.equals("NOTPERMISSION")) {
				downFile(request, response, realPath + filePath, fileName);
				
				// 대용량첨부파일인 경우, 다운로드 성공 시 다운로드 카운트 증가
				ezApprovalGService.updateBigAttachFileDownloadCnt(docID, docAttachSN, userInfo.getCompanyID(), userInfo.getTenantId());
			}
			else if (isBigAttachFileDownloadCntOver.equals("YES")) { // 대용량첨부 다운로드횟수 초과
				response.setCharacterEncoding("UTF-8");
				response.setContentType("text/html; charset=UTF-8");
				response.getWriter().write("<script language='javascript'>\n");
				response.getWriter().write("alert(\'" + messageSource.getMessageExtend("ezEmail.hdp05", new Object[] {bigSizeAttachDownloadLimitCount}, userInfo.getLocale()) + "\');\n");
//				response.getWriter().write("window.history.back();");
                response.getWriter().write("if (typeof parent.removeTempFrame === 'function') {parent.removeTempFrame();}\n");
				response.getWriter().write("</script>");
				response.getWriter().flush();
			}
			else if (isAttachFileCanDownload.equals("NO")) { // 대용량첨부 저장기간 초과
				response.setCharacterEncoding("UTF-8");
				response.setContentType("text/html; charset=UTF-8");
				response.getWriter().write("<script language='javascript'>\n");
				response.getWriter().write("alert(\'" + messageSource.getMessage("main.t4", userInfo.getLocale()) + "\');\n");
//				response.getWriter().write("window.history.back();");
                response.getWriter().write("if (typeof parent.removeTempFrame === 'function') {parent.removeTempFrame();}\n");
				response.getWriter().write("</script>");
				response.getWriter().flush();
			}
			
			logger.debug("downloadAttach ended. result = " + result);
		}
		
		// 2023-03-08 홍승비 - isToDelFG 플래그값이 Y인 경우, 첨부파일 다운로드 후 해당 파일을 삭제함 (통합PC저장 등, 임시 생성된 파일 삭제 시 사용)
		if (isToDelFG.equalsIgnoreCase("Y")) {
			EzFile delFile = new EzFile(commonUtil.detectPathTraversal(realPath + filePath));
			
			if (delFile.exists()) {
				delFile.delete();
			}
		}
	}
	
	/**
	 * 2020-11-18 홍승비 - 모두저장(압축파일 내려받기)
	 * */
	@RequestMapping(value="/ezApprovalG/downloadAttachAll.do", method = RequestMethod.POST, produces="text/plain; charset=UTF-8")
	@ResponseBody
	public void downloadAttachAll(@CookieValue("loginCookie") String loginCookie, Locale locale, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttachAll started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String filePaths = request.getParameter("filePaths");
		String fileNames = request.getParameter("fileNames");
		String realPath = commonUtil.getRealPath(request);
		// zip 파일을 pDirTempPath 하위에 임시로 만들어 다운받은 뒤, 다운 완료 시 삭제한다.
		String tempFileUploadPath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "tempUploadFile";
		String guid = UUID.randomUUID().toString();
		String pDirTempPath = tempFileUploadPath + commonUtil.separator + guid;
		
		logger.debug("fileNames : " + fileNames);
		
		ZipOutputStream zos = null;
		String downFileName = "";
		
		try {
			File tempFile = new File(pDirTempPath + commonUtil.separator + ".zip"); // tempUploadFile 경로의 임시 파일이므로 EzFAL 적용 제외
			
			if (tempFile.exists()) {
				tempFile.delete();
			}
			
			tempFile = new File(tempFileUploadPath);
			
			if (!tempFile.exists()) {
				tempFile.mkdirs();
			}
			
			zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"), Charset.forName("utf-8"));
			
			String[] fileNamesArr = fileNames.split(":::");
			String[] filePathsArr = filePaths.split(":::");
			
			downFileName = fileNamesArr[0] + " " + messageSource.getMessage("ezCircular.t50", userInfo.getLocale()) + " " + (fileNamesArr.length-1) + messageSource.getMessage("ezStatistics.t1067", userInfo.getLocale()) + ".zip"; // zip파일명
			
			// 중복된 파일명을 덮어쓰지 않고 (1), (2)... 붙임 (commonUtil.getUniqueFileName 사용)
			Map<String, Integer> fileNameMap = new HashMap<String, Integer>();
			
			if (fileNamesArr.length != 0) {// 파일이 있으면 zip 생성
				for (int i = 0; i < fileNamesArr.length; i++) {
					BufferedInputStream bis = null;
					
					try {
						EzFile sourceFile = new EzFile(commonUtil.detectPathTraversal(realPath + filePathsArr[i])); // 다운받기 위한 원본 파일의 경로 (서버 상에 정식 업로드된 파일이므로 EzFAL을 적용)
						byte[] fileBytes = null;
						
						// 원본 파일을 스트림에서 바이트로 read
						// EzFAL EzFileInputStream 사용 (자동 close 호출)
			    		try (EzFileInputStream fis = new EzFileInputStream(sourceFile.getFile().getPath())) {
			    			fileBytes = IOUtils.toByteArray(fis);
			    		} catch (Exception e) {
			    			logger.error(e.getMessage(), e);
			    		}
						
						// fileNamesArr는 확장자를 포함함
						if (filePathsArr[i].endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
							fileBytes = klibUtil.decrypt(fileBytes);
						}
						
						fileNamesArr[i] = commonUtil.getUniqueFileName(fileNamesArr[i], fileNameMap);
						ZipEntry zentry = new ZipEntry(fileNamesArr[i]);
						zos.putNextEntry(zentry);
						zos.write(fileBytes);
						zos.closeEntry();
					} catch (IOException e) {
						logger.error(e.getMessage(), e);
					} finally {
						if (bis != null) {
							try {
								bis.close();
							} catch (Exception e) {
								logger.error(e.getMessage(), e);
							}
						}
					}
				}
				zos.flush();
				zos.close();
				zos = null;
	
				File file = new File(pDirTempPath + ".zip"); // tempUploadFile 경로의 임시 파일이므로 EzFAL 적용 제외
				
				if (file.exists()) {
					downFile(request, response, pDirTempPath + ".zip", downFileName);
					file.delete();
				}
			}
		} catch (Exception e) {
			File file = new File(pDirTempPath + ".zip");
			
			if (file.exists()) {
				file.delete();
			}
		} finally {
			if (zos != null) {
				try {
					zos.close();
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		logger.debug("downloadAttachAll ended.");
	}
	
	/**
	 * 전자결재G 통합pc 저장 리스트 더블클릭 다운
	 */
	@RequestMapping(value = "/ezApprovalG/downloadAttachDbClick.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadAttachDbClick(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadAttachDbClick started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String type = request.getParameter("type");
		String docStatus = request.getParameter("docStatus");
		String fileName = request.getParameter("fileName");
		String docAttachSN = request.getParameter("docAttachSN");
		String realPath = commonUtil.getRealPath(request);
		
		String companyID = userInfo.getCompanyID();
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !companyID.equals(orgCompanyID)) {
			companyID = orgCompanyID;
		}

		String href = ezApprovalGService.getDocHref(docID, docStatus, type, docAttachSN, companyID, userInfo.getTenantId());
		
		downFile(request, response, realPath + href, fileName);
		
		logger.debug("downloadAttachDbClick ended.");
	}
	
	/**
	 * 전자결재G 통합pc 저장 리스트 더블클릭 다운(hwp 배포용 문서 저장)
	 */
	@RequestMapping(value = "/ezApprovalG/downloadHwpDbClick.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadHwpDbClick(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadHwpDbClick started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String fileName = request.getParameter("fileName");
		String p_downloadUrl = request.getParameter("downloadUrl");
		String realPath = commonUtil.getRealPath(request);
		long time = System.currentTimeMillis();
		String s_time = String.valueOf(time);
		
		// 동시에 다운로드 시 폴더가 겹치는 현상을 피하기 위해 폴더명에 System.currentTimeMillis()를 추가
		String tempFileUploadPath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "tempUploadFile" + commonUtil.separator + docID + s_time;
		File fileDir = new File(commonUtil.detectPathTraversal(tempFileUploadPath)); // tempUploadFile 경로의 임시 파일이므로 EzFAL 적용 제외

		if (!fileDir.exists()) {
			fileDir.mkdirs();
		}
		
		String targetPathStr = tempFileUploadPath + commonUtil.separator + fileName;		
		File targetFile = new File(commonUtil.detectPathTraversal(targetPathStr));
		
		if (targetFile.exists()) {
			targetFile.delete();
		}
		
		Path pathTarget = Paths.get(targetPathStr);
		URL downloadUrl = new URL(p_downloadUrl);
		InputStream inpStream = null;
		
		try {
			inpStream = downloadUrl.openStream();
			Files.copy(inpStream, pathTarget); // URL을 통해서 배포용 HWP파일을 다운받게 되므로 EzFAL 적용 제외
			
			inpStream.close();
		} catch (Exception e) {
			logger.debug("e InputStream: " + e);
		} finally {
			if (inpStream != null) {
				try {
					inpStream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
		
		try {
			downFile(request, response, targetPathStr, fileName);
			
			if (targetFile.exists()) {
				targetFile.delete();
			}
			
			if (fileDir.exists()) {
				fileDir.delete();
			}
			
		} catch (Exception e) {
			logger.debug("e : " + e);
		}
		
		logger.debug("downloadHwpDbClick ended.");
	}
	
	@RequestMapping(value="/ezApprovalG/downloadMhtDbClick.do", method = RequestMethod.GET, produces="text/plain; charset=UTF-8")
	@ResponseBody
	public void downloadMhtDbClick(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadMhtDbClick started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String filePath = request.getParameter("filePath");
		String fileName = request.getParameter("fileName");
		String fileName2 = request.getParameter("fileName2");
		String realPath = commonUtil.getRealPath(request);
		String tempFileUploadPath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "tempUploadFile";
		String guid = UUID.randomUUID().toString();
		String pDirTempPath = tempFileUploadPath + commonUtil.separator + guid;

		logger.debug("fileName : " + fileName);

		ZipOutputStream zos = null;
		String downFileName = "";

		try {
			File tempFile = new File(pDirTempPath + commonUtil.separator + ".zip"); // tempUploadFile 경로의 임시 파일이므로 EzFAL 적용 제외

			if (tempFile.exists()) {
				tempFile.delete();
			}

			tempFile = new File(tempFileUploadPath);

			if (!tempFile.exists()) {
				tempFile.mkdirs();
			}

			zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"), Charset.forName("utf-8"));

			downFileName = fileName2 + ".zip"; // zip파일명

			BufferedInputStream bis = null;

			try {
				EzFile sourceFile = new EzFile(commonUtil.detectPathTraversal(realPath + filePath)); // 다운받기 위한 원본 파일의 경로 (서버 상에 정식 업로드된 파일이므로 EzFAL을 적용)
//				byte[] fileBytes = commonUtil.readBytesFromFile(sourceFile.toPath());
				byte[] fileBytes = null;
				
				// 원본 파일을 스트림에서 바이트로 read
				// EzFAL EzFileInputStream 사용 (자동 close 호출)
	    		try (EzFileInputStream fis = new EzFileInputStream(sourceFile.getFile().getPath())) {
	    			fileBytes = IOUtils.toByteArray(fis);
	    		} catch (Exception e) {
	    			logger.error(e.getMessage(), e);
	    		}
				
				ZipEntry zentry = new ZipEntry(fileName);
				zos.putNextEntry(zentry);
				zos.write(fileBytes);
				zos.closeEntry();
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			} finally {
				if (bis != null) {
					try {
						bis.close();
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
					}
				}
			}
			zos.flush();
			zos.close();
			zos = null;

			File file = new File(pDirTempPath + ".zip");

			if (file.exists()) {
				downFile(request, response, pDirTempPath + ".zip", downFileName);
				file.delete();
			}

		} catch (Exception e) {
			File file = new File(pDirTempPath + ".zip");

			if (file.exists()) {
				file.delete();
			}
		} finally {
			if (zos != null) {
				try {
					zos.close();
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		logger.debug("downloadMhtDbClick ended.");
	}

	/**
	 * 전자결재G 기안 문서첨부 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprCabinetAttach.do", method = RequestMethod.GET)
	public String aprCabinetAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("aprCabinetAttach started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String draftflag = request.getParameter("draftFlag");
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		/* 2022-01-20 홍승비 - 일괄기안 시 각 안의 파일첨부여부 플래그 변경을 위하여 일괄기안여부 플래그와 안 번호 전달 */
        String draftAllFlag = request.getParameter("draftAllFlag") != null ? request.getParameter("draftAllFlag") : "N";
        String anNo = request.getParameter("anNo") != null ? request.getParameter("anNo") : "0";

		model.addAttribute("draftFlag", draftflag);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("draftAllFlag", draftAllFlag);
		model.addAttribute("anNo", anNo);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		logger.debug("aprCabinetAttach ended.");
		
		return "ezApprovalG/apprGaprCabinetAttach";
	}
	
	/**
	 * 전자결재G 기안 문서첨부 헤더정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getLVHeaderInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getLVHeaderInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getLVHeaderInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String listFlag = request.getParameter("listFlag");
		String listType = request.getParameter("listType");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGService.getListInfoXml(listFlag, listType, companyID, userInfo.getLang(), userInfo);
		
		logger.debug("getLVHeaderInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 진행율 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/showProgress.do", method = RequestMethod.GET)
	public String showProgress(HttpServletRequest request, Model model){
		logger.debug("showProgress started.");
		
		String fileInfo = request.getParameter("fileInfo");
		
		model.addAttribute("fileInfo", fileInfo);
		
		logger.debug("showProgress ended.");
		
		return "ezApprovalG/apprGshowProgress";
	}
	
	@RequestMapping(value = "/ezApprovalG/getTransList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTransList() throws Exception{
		//TODO: 닷net버전이 미구현 된거같음 미구현 + 사용안함
		return "";
	}
	
	/**
	 * 전자결재G 기안 문서첨부 문서리스트 / 기록물대장 기록물 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getRecordList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getRecordList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, @RequestBody String xmlDom) throws Exception{
		logger.debug("getRecordList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlDom);
		String result = ezApprovalGService.getRecordList(doc, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo.getDeptID());
		
		logger.debug("getRecordList ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 문서첨부 검색 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/searchRec.do", method = RequestMethod.GET)
	public String searchRec(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("searchRec started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("searchRec ended.");
		
		return "ezApprovalG/apprGsearchRec";
	}
	
	/**
	 * 전자결재G 기안 문서첨부 코드리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getCodeList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getCodeList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getCodeList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGService.getCodeInfo(companyID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("getCodeList ended.");
		
		return result;
	}

	/**
	 * 전자결재G 기안 문서첨부 업무담당자 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/selectUser.do", method = RequestMethod.GET)
	public String selectUser() throws Exception{
		return "ezApprovalG/apprGselectUser";
	}
	
	/**
	 * 전자결재G 기안 문서첨부 문서첨부정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getAttachInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getAttachInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getAttachInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "ING";

		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			companyID = orgCompanyID;
		}
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		String result = ezApprovalGService.getAttachDocInfo(docID, mode, "", "", companyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), approvalFlag);
		
		logger.debug("getAttachInfo ended.");
		
		return result;
	}

	/**
	 * 전자결재G 기안 문서첨부 업무담당자여부 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/iSCabCharger.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String iSCabCharger(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,HttpServletRequest request) throws Exception{
		logger.debug("iSCabCharger started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		String cabClassNo = request.getParameter("cabClassNo");
		String userID = request.getParameter("userID");
		String result = ezApprovalGService.isCabCharger(companyID, cabClassNo.trim(), userID, userInfo.getTenantId());
		
		logger.debug("iSCabCharger ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 문서첨부 업데이트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/updateDocAttach.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String updateDocattach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlDom, HttpServletRequest request) throws Exception{
		logger.debug("updateDocAttach started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !userInfo.getCompanyID().equals(orgCompanyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		Document doc = commonUtil.convertStringToDocument(xmlDom);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		String result = ezApprovalGService.updateAttachDocInfo(doc, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag);
		
		logger.debug("updateDocAttach ended.");
		
		return result;
	}

	/**
	 * 전자결재G 기안 문서첨부 삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/delAttachDoc.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String delAttachDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("delAttachDoc started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.deleteAttachDocInfo(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("delAttachDoc ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 문서보기 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/contDocView.do", method = RequestMethod.GET)
	public String contDocView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("contDocView started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String susinAdmin = "";
		String endDir = "";
		String signCheck = "";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String signImageType = ezCommonService.getTenantConfig("signImageType", userInfo.getTenantId());
		
		//baonk 추가 2018-08-08
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
		if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("apprv", userInfo);
		}
		
		String useBoard = ezCommonService.getTenantConfig("useBoard", userInfo.getTenantId());
		if(useBoard == null || useBoard.equals("")) {
			useBoard = "YES";
		}
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String listSusin = request.getParameter("listSusin");
		String orgDocID = request.getParameter("orgDocID");
		String formID = request.getParameter("formID");
		String title = request.getParameter("title");
		String uFlag = request.getParameter("uFlag");
		String admin = request.getParameter("admin");
		String docState = request.getParameter("docState");
		String share = request.getParameter("share");
		String pass = "";
		String formUrl = "";
		String formDocType = "";
		String formVersion = "";
		String sendType = request.getParameter("sendType");
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		String docAttachParent = request.getParameter("docAttachParent") != null ? request.getParameter("docAttachParent") : "";
		boolean isDocAttach =  StringUtils.isNotBlank(docAttachParent);

		/* 진행/완료(APR/END) 체크 */
		String docAprEnd = ezApprovalGService.getAprOrEndStr(docID, userInfo.getCompanyID(), userInfo.getTenantId());

		if (orgDocID != null  && !orgDocID.equals("")) {
			endDir = ezApprovalGService.getDocDir(orgDocID);
		}
		
		String orgCompanyID = request.getParameter("orgCompanyID");
        String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
        if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("q=1") == -1 && userInfo.getRollInfo().indexOf("m=1") == -1) {
			// 2023-11-06 박기범 - 문서첨부에서 문서를 열 경우 첨부문서의 권한이 아니라 문서의 권한으로 체크
			if (isDocAttach && ezApprovalGService.isAttachDoc(docID, docAttachParent, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId())) {
				if (docAprEnd.equals("APR")) {
					pass = ezApprovalGService.getAccessYNGforAPR(docAttachParent, accessInfo, approvalFlag, userInfo);
				} else {
					pass = ezApprovalGService.getAccessYNG(docAttachParent, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());
				}
			} else {
				if (docAprEnd.equals("APR")) {
					pass = ezApprovalGService.getAccessYNGforAPR(docID, accessInfo, approvalFlag, userInfo);
				} else {
					pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());
				}
			}
			// 2024-06-11 양지혜 - 취약점보완 : 보안결재 체크
			String securityDate = ezApprovalGService.checkSecurityApprovalDate(docID, userInfo.getCompanyID(), userInfo.getTenantId(), docAprEnd);
			if (!securityDate.equals("")) {
				String checkLine = ezApprovalGService.checkAprLine(docID, docAprEnd, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
				if (checkLine.equals("<RESULT>FALSE</RESULT>") && formatter.parse(commonUtil.getTodayUTCTime("yyyy-MM-dd")).compareTo(formatter.parse(securityDate)) < 0) {
					pass = "<RESULT>FALSE</RESULT>";
					return "main/warning";
				}
			}
		} else {
			pass = "<RESULT>TRUE</RESULT>";
		}
		if (share != null && share.equals("Y")) {
			pass = "<RESULT>TRUE</RESULT>";
		}
		
		if (pass.equals("<RESULT>TRUE</RESULT>")) {
			if (docHref.trim().equals("") || docHref.indexOf("/1000/") >= 0 || docHref.split("/").length == 1) {
				String strXML = ezApprovalGService.getDocInfo(docID, docAprEnd, "Href", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
				Document resultXML = commonUtil.convertStringToDocument(strXML);
				
				if (resultXML.getElementsByTagName("HREF").item(0) != null && !resultXML.getElementsByTagName("HREF").item(0).getTextContent().trim().equals("")) {
					docHref = resultXML.getElementsByTagName("HREF").item(0).getTextContent();
				}
			}
			
			String readRecXML = "<PARAMETER><DOCID>" + makeXMLString(docID) +
                    "</DOCID><USERID>" + makeXMLString(userInfo.getId()) +
                    "</USERID><USERNAME>" + makeXMLString(userInfo.getDisplayName1()) +
                    "</USERNAME><USERTITLE>" + makeXMLString((userInfo.getTitle1() == null ? "" : userInfo.getTitle1())) +
                    "</USERTITLE><DEPTCODE>" + makeXMLString(userInfo.getDeptID()) +
                    "</DEPTCODE><DEPTNAME>" + makeXMLString(userInfo.getDeptName1()) +
                    "</DEPTNAME><COMPANYID>" + makeXMLString(userInfo.getCompanyID()) +
                    "</COMPANYID><USERNAME2>" + makeXMLString(userInfo.getDisplayName2()) +
                    "</USERNAME2><USERTITLE2>" + makeXMLString((userInfo.getTitle2() == null ? "" : userInfo.getTitle2())) +
                    "</USERTITLE2><DEPTNAME2>" + makeXMLString(userInfo.getDeptName2()) +
                    "</DEPTNAME2></PARAMETER>";
			ezApprovalGService.saveRecReadHist(readRecXML, userInfo.getTenantId());
			String rtnXML = ezApprovalGService.getDocInfo(docID, "END", "SignCheck", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
			Document resultXML = commonUtil.convertStringToDocument(rtnXML);
			
			if (resultXML.getElementsByTagName("SIGNCHECK").item(0) != null && !resultXML.getElementsByTagName("SIGNCHECK").item(0).getTextContent().trim().equals("")) {
				signCheck = resultXML.getElementsByTagName("SIGNCHECK").item(0).getTextContent().trim();
			}
			
			if (title == null || title.equals("")) {
				String reUseInfo = ezApprovalGService.getDocInfoS(docID, docAprEnd, userInfo, userInfo.getCompanyID(), userInfo.getTenantId());
				Document resultXML2 = commonUtil.convertStringToDocument(reUseInfo);
				if (resultXML2.getElementsByTagName("FORMFILELOCATION").getLength() > 0) {
					formUrl = resultXML2.getElementsByTagName("FORMFILELOCATION").item(0).getTextContent().trim();
				}
				if (resultXML2.getElementsByTagName("FORMDOCTYPE").getLength() > 0) {
					formDocType = resultXML2.getElementsByTagName("FORMDOCTYPE").item(0).getTextContent().trim(); 
				}
				if (resultXML2.getElementsByTagName("FORMVERSION").getLength() > 0) {
					formVersion = resultXML2.getElementsByTagName("FORMVERSION").item(0).getTextContent().trim(); 
				}
			}
		} 
		
		if (sendType == null || sendType.equals("")) {
			sendType = ezApprovalGService.getDocSendType(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		
		int whoKyulCount = ezApprovalGService.getWhoKyulCount(docID, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLang());
		String checkPwdFlag = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(),  userInfo.getCompanyID());
		String ext = docHref.substring(docHref.toLowerCase().lastIndexOf(".") + 1);
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		/* 2020-11-13 홍승비 - 대용량첨부 관련 파라미터 추가 */
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
		String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String bigAttachFileMinSaveDate = ezApprovalGService.getAttachFileMinSaveDate(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String bigAttachDownloadPeriod = bigAttachFileMinSaveDate + " ~ " + EgovDateUtil.addDay(bigAttachFileMinSaveDate, Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");
		
		// 2023-05-26 조수빈 - 전자결재 첨부파일 미리보기 기능 사용 여부
		String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
		
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
 		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
 		
 		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
 			useAprFilePrvw = "1";
 		} else {
 			useAprFilePrvw = "0";
 		}
 		
 		// 2024-05-23 김우철 - 헤더 숨기기 기능 사용 여부
 		String useHideHeaderArea = ezCommonService.getTenantConfig("useHideHeaderArea", userInfo.getTenantId());
 		
 		if (approvalFlag.equals("G")) {
 			String nonElecRec = ezApprovalGService.checkNonElecRec(orgDocID, userInfo.getCompanyID(), userInfo.getTenantId());
 			if (!nonElecRec.equals("")) {
 				model.addAttribute("nonElecRec", nonElecRec);
 			}
 		}

		model.addAttribute("editor", editor);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("signCheck", signCheck);
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("listSusin", listSusin);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("endDir", endDir);
		model.addAttribute("formID", formID);
		model.addAttribute("title", title);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pass", pass);
		model.addAttribute("uFlag", uFlag);
		model.addAttribute("admin", admin);
		model.addAttribute("formUrl", formUrl);
		model.addAttribute("formDocType", formDocType);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("docState", docState);
		model.addAttribute("whoKyulCount", whoKyulCount);
		model.addAttribute("checkPwdFlag", checkPwdFlag);
		model.addAttribute("ext", ext);
		model.addAttribute("signImageType", signImageType);
		model.addAttribute("useCabinet", use_cabinet); // 캐비넷 추가 baonk 2018-08-08
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("formVersion", formVersion);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("useBoard", useBoard);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("sendType", sendType);
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		// 전자결재 미리보기 영역에서 열렸는지 여부 플래그
		model.addAttribute("isPreview", isPreview);
		
		model.addAttribute("useAprFilePrvw", useAprFilePrvw);

		/* 2023-07-13 민지수 - 배부대장 문서 진행/완료(APR/END) 값 전달 */
		model.addAttribute("docAprEnd", docAprEnd);

		/* 이유정 - 첨부문서 확인 여부 (첨부문서 창 닫을시 발생하는 오류 방지를 위한 Flag) */
		model.addAttribute("isDocAttach", isDocAttach);

		model.addAttribute("useHideHeaderArea", useHideHeaderArea);

		logger.debug("contDocView ended.");
		
		// 2024-04-23 전인하 - 전자결재G > 완료문서 열람 권한 관련 URL 조작 웹취약점 - 권한 체크 후 권한 없을 시 warning 페이지로 이동하게 함
		if (pass.equals("<RESULT>TRUE</RESULT>")) {
			return "ezApprovalG/apprGcontDocView";
		} else {
			return "main/warning";
		}
	}
	
	public String makeXMLString(String orgString) throws Exception{
		return orgString.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
	}
	
	/**
	 * 전자결재G 부서에수발신담당자체크 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/receiverChk.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String receiverChk(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("receiverChk started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String rtnVal = ezApprovalGService.receiverChk(deptID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("receiverChk ended.");
		
		return rtnVal;
	}
	
	/**
	 * 전자결재G 대결재자정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/checkAprPerson.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String checkAprPerson(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("checkAprPerson started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String msg = request.getParameter("msg");
		Document xmlDoc = commonUtil.convertStringToDocument(ezApprovalGService.getEA5Value(msg, userInfo.getTenantId(), userInfo.getCompanyID()));
		String ex5 = "", langType = "", name = "";
		
		if (!userInfo.getPrimary().equals("1")) {
			langType = "2";
		}
		
		for (int k = 0; k < xmlDoc.getElementsByTagName("EXTENSIONATTRIBUTE5").getLength(); k++) {
			ex5 = xmlDoc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(k).getTextContent();
			
			String[] arry = ex5.split(":");
			
			name = ezOrganService.getPropertyValue(arry[0], "DISPLAYNAME" + langType, userInfo.getTenantId());
			xmlDoc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(k).setTextContent(xmlDoc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(k).getTextContent().replace(arry[1], name));
		}
		
		logger.debug("checkAprPerson ended.");
		
		return commonUtil.convertDocumentToString(xmlDoc);
	}
	
	/**
	 * 전자결재G 기안 기록물철 즐겨찾기 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getMyTaskCode.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getMyTaskCode(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getMyTaskCode started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		String upperDeptCode = request.getParameter("upperDeptCode");
		String result = ezApprovalGService.getMyTaskCode(userID, deptID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), upperDeptCode);
		
		logger.debug("getMyTaskCode ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 분리첨부 추가 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/insSepAttach.do", method = RequestMethod.GET)
	public String insSepAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("insSepAttach started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("insSepAttach ended.");
		
		return "ezApprovalG/apprGinsSepAttach";
	}
	
	/**
	 * 전자결재G 기안 즐겨찾기 추가 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setMyTaskCode.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setMyTaskCode(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("setMyTaskCode started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String cabinetID = request.getParameter("cabinetID");
		String taskCode = request.getParameter("taskCode");
		String type = request.getParameter("type");
		
		logger.debug("type = " + type);
		
		String result = ezApprovalGService.setMyTaskCode(userInfo.getId(), userInfo.getDeptID(), cabinetID, taskCode, type, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("setMyTaskCode ended.");

		return result;
	}
	
	/**
	 * 전자결재G 기안 철정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getCabinetInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getCabinetInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getCabinetInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String cabinetID = request.getParameter("cabinetID");
		String companyID = request.getParameter("companyID");
		String strType = request.getParameter("strType");
		String result = ezApprovalGService.getCabinetInfo(cabinetID, companyID, strType, userInfo.getTenantId());
		
		logger.debug("getCabinetInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 분리첨부 등록 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/regSepAttach.do", method = RequestMethod.GET)
	public String regSepAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("regSepAttach started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("regSepAttach ended.");
		
		return "ezApprovalG/apprGregSepAttach";
	}
	
	/**
	 * 전자결재G 기안 분리첨부 등록 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/regSepAttach.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String regSepAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String para) throws Exception{
		logger.debug("regSepAttach started");
		userInfo = commonUtil.aprUserInfo(loginCookie);

		Document doc = commonUtil.convertStringToDocument(para);
		String result = ezApprovalGService.registerSepAttach(doc, userInfo.getTenantId(), userInfo.getLocale());
		logger.debug("regSepAttach result = " + result);
		logger.debug("regSepAttach ended");

		return result;
	}
	
	/**
	 * 전자결재G 기안 인쇄 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezApprovalPrint.do", method = RequestMethod.GET)
	public String ezApprovalPrint() throws Exception{
		return "ezApprovalG/apprGezApprovalPrint";
	}
	
	/**
	 * 전자결재G 기안 인쇄상세질문 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezprtQuestion.do", method = RequestMethod.GET)
	public String ezprtQuestion(HttpServletRequest request, Model model) throws Exception{
		logger.debug("ezprtQuestion started");
		
		String opinion = request.getParameter("opinion");
		String attach = request.getParameter("attach");
		
		model.addAttribute("attach", attach);
		model.addAttribute("opinion", opinion);
		
		logger.debug("ezprtQuestion ended");
		
		return "ezApprovalG/apprGezprtQuestion";
	}
	
	/**
	 * 전자결재G 기안 변경내역 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezAprHistory.do", method = RequestMethod.GET)
	public String ezAprHistory(HttpServletRequest request, Model model) throws Exception{
		logger.debug("ezAprHistory started");
		
		String docID = request.getParameter("docID");
		String ext = request.getParameter("ext");
		model.addAttribute("docID", docID);
		model.addAttribute("ext", ext);
		
		logger.debug("ezAprHistory ended");
		
		return "ezApprovalG/apprGezAprHistory";
	}
	
	/**
	 * 전자결재G 기안 변경내역 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getDocHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getDocHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getDocHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !userInfo.getCompanyID().equals(orgCompanyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = ezApprovalGService.getHistoryForDoc(docID, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getDocHistory ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 변경내역 결재선탭 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getLineHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getLineHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getLineHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !userInfo.getCompanyID().equals(orgCompanyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = ezApprovalGService.getHistoryForLine(docID, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getLineHistory ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 변경내역 첨부탭 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getAttachHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getAttachHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getAttachHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !userInfo.getCompanyID().equals(orgCompanyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String result = ezApprovalGService.getHistoryForAttach(docID, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), approvalFlag, userInfo.getLocale());
		
		logger.debug("getAttachHistory ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 변경내역 결재문서탭 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getLineHistoryDetail.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getLineHistoryDetail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getLineHistoryDetail started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String modifySN = request.getParameter("changeSN");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !userInfo.getCompanyID().equals(orgCompanyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());		
		String result = ezApprovalGService.getHistoryForLineDetail(docID, modifySN, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), approvalFlag);
		
		logger.debug("getLineHistoryDetail ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 임시보관 삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/removeTMPDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String removeTMPDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("removeTMPDocInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		
		logger.debug("docID = " + docID);
		
		String userID = docID.split("@")[0];
		String sn = docID.split("@")[1];
		String path = commonUtil.getRealPath(request);
		
		String result = ezApprovalGService.deleteTmpDocInfo(userID, sn, path, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("removeTMPDocInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 임시보관 저장 표출 Method
	 */
	@RequestMapping(value = {"/ezApprovalG/saveTmpFile.do", "/ezApprovalG/saveTmpFileHWP.do"}, produces = "text/xml;charset=utf8", method = RequestMethod.POST)
	@ResponseBody
	public String saveTmpFile(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, @RequestBody JSONObject jsonObj) throws Exception{
		logger.debug("saveTmpFile started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		String extension = ".mht";
		
		if (requestURL.indexOf("HWP") > -1) {
			extension = ".hwp";
		}
		
		String docID = jsonObj.get("docID") == null ? null : jsonObj.get("docID").toString();
		String formId = jsonObj.get("formId") == null ? "" : jsonObj.get("formId").toString();
		String formText = jsonObj.get("html") == null ? "" : jsonObj.get("html").toString();
		String realPath = commonUtil.getRealPath(request);
		String path = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String ret = "";
		InputStream stream = null;
		
		try {
			if (docID == null || formText.equals("")) {
				ret = "FALSE";

				logger.debug("<<<docID : " + docID);
				logger.debug("<<<formText : " + formText);
				logger.debug("there is no primary data.");

				return ret;
			}
			
			String tmpPath = realPath + path + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator + "TMP";
			
			EzFile tmpDir = new EzFile(commonUtil.detectPathTraversal(tmpPath));
			
			if (!tmpDir.exists()) {
                tmpDir.mkdirs();
			}
			
			String saveFileName = tmpPath + commonUtil.separator + docID + extension;

            ApprGFormVO formVO = ezApprovalGService.getFormPath(formId, userInfo.getCompanyID(), userInfo.getTenantId());
			
			// 아래 코드 formFile 변수를 불러오는 곳은 logger 뿐이다. 굳이 필요한가... 일단 실제로 서버상에 업로드된 양식이므로, EzFAL은 적용함
            EzFile formFile = new EzFile(realPath + formVO.getFormFileLocation());
			
            EzFile targetFile = new EzFile(saveFileName);
            
            logger.debug("formId = " + formId + ", formFile.length = " + formFile.length() + ", targetFile.length = " + targetFile.length());
            
            // 양식의 본문 (html)을 읽어서 stream에 저장
			if (extension.equals(".hwp")) {
				stream = new ByteArrayInputStream(Base64.decodeBase64(formText));
			} else {
				stream = new ByteArrayInputStream(formText.getBytes("UTF-8"));
			}
			
			// EzFAL EzFileOutputStream 사용 (자동 close 호출)
			try (EzFileOutputStream fos = new EzFileOutputStream(targetFile)) {
				int bytesRead = 0;
				byte[] buffer = new byte[BUFF_SIZE];
				
				while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
					fos.write(buffer, 0, bytesRead);
				}
				
				ret = "TRUE";
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			ret = "FALSE";
		} finally {
		   if (stream != null) {
				try {
					stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
	    
		logger.debug("saveTmpFile ended");
		
		return ret;
	}
	
	/**
	 * 전자결재G 기안 표출 Method
	 */
	@RequestMapping(value = {"/ezApprovalG/doDraft.do", "/ezApprovalG/doDraftHWP.do"}, produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String doDraft(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		logger.debug("doDraft started.");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		String extension = ".mht";
		if (requestURL.indexOf("HWP") > -1) {
			extension = ".hwp";
		}
		logger.debug("requestURL = " + requestURL);
		logger.debug("xmlPara = " + xmlPara);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		String docID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String[] docIDSplit = docID.split(",");
		String oldYear = ezApprovalGService.getDocHrefYear(docIDSplit[0], userInfo.getCompanyID(), userInfo.getTenantId());
		// <HERF></HERF>에 저장된 .htm 파일의 위치를 .mht 파일이 저장될 위치로 변경해준다.
		String tmphref = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear +
				commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(docIDSplit[0]) + commonUtil.separator +
				(xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent().equals("001") ? "TMP" + commonUtil.separator : "") + docIDSplit[0] + extension;
		for(int i = 1; i < docIDSplit.length; i++){
			tmphref += "," + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear +
					commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(docIDSplit[i]) + commonUtil.separator +
					(xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent().equals("001") ? "TMP" + commonUtil.separator : "") + docIDSplit[i] + extension;;
		}
		xmlDom.getDocumentElement().getChildNodes().item(6).setTextContent(tmphref);
		String aprState = "003"; // 003 승인
		if (xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent().equals("000")) {
			aprState = "000"; // 000 미결
		} else if (xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent().equals("001")) {
			aprState = "001"; // 001 대기
		}
		userInfo.setRealPath(commonUtil.getRealPath(request));
		
		String result = ezApprovalGService.doProcess(aprState, xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent(), 
				xmlDom.getElementsByTagName("PUSERNAME2").item(0).getTextContent(), dirPath, xmlDom.getDocumentElement().getChildNodes().item(22).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent(), xmlDom, "", userInfo.getCompanyID(), userInfo.getLang(), userInfo); 
		
		//기결재통과 플래그
		String passAprLine = "";
		
		if (xmlDom.getElementsByTagName("PASSAPRLINE").getLength() > 0) {
			passAprLine = xmlDom.getElementsByTagName("PASSAPRLINE").item(0).getTextContent();
		}
		
		if (passAprLine != null && passAprLine.equals("Y")) {
			ezApprovalGService.sendMailToPassAprMember(docIDSplit[0], request, loginCookie, userInfo, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		
		logger.debug("doDraft ended. result = " + result);
		
		return result;
	}
	
	/**
	 * 전자결재G 첨부사이즈 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getExtTotalAttachSize.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getExtTotalAttachSize(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getExtTotalAttachSize started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getTotalAttachSize(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("getExtTotalAttachSize result =" + result );
		logger.debug("getExtTotalAttachSize ended.");

		return result;
	}
	
	/**
	 * 전자결재G 결재선 체크 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/checkAprLines.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String checkAprLines(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		logger.debug("checkAprLines started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.chkAprLines(doc, userInfo.getLang(), userInfo);
		
		logger.debug("checkAprLines ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 결재선 체크 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/checkDeptLines.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String checkDeptLines(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		logger.debug("checkDeptLines started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.chkDeptLines(doc, userInfo.getCompanyID(), userInfo.getLang(), userInfo);
		
		logger.debug("checkDeptLines ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 얼럿트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezAprAlertLong.do", method = RequestMethod.GET)
	public String ezAprAlertLong() throws Exception{
		return "ezApprovalG/apprGezAprAlertLong";
	}
	
	/**
	 * 전자결재G 서명 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getSignRequest.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getSignRequest(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Locale locale) throws Exception{
		logger.debug("getSignRequest started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		
		String result = ezOrganService.getPropertyValue(userID, "extensionAttribute3", userInfo.getTenantId());
		// 서명이 있는 경우 XML에 append 해서 return
		if (result != null) {
			String[] signText = result.split(";");
			int tempLength = signText.length;
			StringBuilder resultXML = new StringBuilder("<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t433", locale) + "</NAME><WIDTH>140</WIDTH></HEADER></HEADERS><ROWS>");
			
			for (int k = 0; k < tempLength; k++) {
				if (!signText[k].equals("")) {
					resultXML.append("<ROW><CELL><VALUE>" + messageSource.getMessage("ezApprovalG.t434", locale) + k + "</VALUE><DATA1>" + signText[k] + "</DATA1></CELL></ROW>");
				}
			}
			
			resultXML.append("</ROWS></LISTVIEWDATA>");
			
			logger.debug("getSignRequest ended.");
			
			return resultXML.toString();
		} else {
			StringBuilder resultXML = new StringBuilder("<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t433", locale) + "</NAME><WIDTH>140</WIDTH></HEADER></HEADERS><ROWS>");
			
			resultXML.append("</ROWS></LISTVIEWDATA>");
			
			logger.debug("getSignRequest ended.");
			
			return resultXML.toString();
		}
	}
	
	/**
	 * 전자결재G 서명 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprSign.do", method = RequestMethod.GET)
	public String aprSign(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("aprSign started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userInfoApprovalG = config.getProperty("config.UserInfo_ApprovalG");
		String signCount = ezOrganService.getPropertyValue(userInfo.getId(), "extensionAttribute3", userInfo.getTenantId());
		String existSign = Strings.isNotBlank(signCount) ? "Y" : "N";
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("userInfoApprovalG", userInfoApprovalG);
		model.addAttribute("existSign", existSign);
		
		logger.debug("aprSign ended.");
		
		return "ezApprovalG/apprGaprSign";
	}
	
	/**
	 * 전자결재G 서명저장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/approvalGSign.do", method = RequestMethod.GET)
	@ResponseBody
	public void approvalGSign(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("approvalGSign started");

		userInfo = commonUtil.aprUserInfo(loginCookie);

		String fileName = request.getParameter("fileName");
		String signatureDir = commonUtil.getUploadPath("upload_approvalG.SIGNIMGS", userInfo.getTenantId());
		
		fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
		signatureDir = signatureDir + commonUtil.separator + fileName.substring(0, fileName.lastIndexOf("_"));
		
		String result = signatureDir + commonUtil.separator + fileName;

		downImage(result, request, response);
		
		logger.debug("approvalGSign ended");
	}
	
	/**
	 * 전자결재G 파일저장 표출 Method
	 */
	@RequestMapping(value = {"/ezApprovalG/saveFile.do", "/ezApprovalG/saveFileHWP.do"}, produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String saveFile(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, @RequestBody JSONObject jsonObj) throws Exception{
		logger.debug("saveFile started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		String extension = ".mht";
		
		if (requestURL.indexOf("HWP") > -1) {
			extension = ".hwp";
		}
		
		String docID = jsonObj.get("docID") == null ? null : jsonObj.get("docID").toString();
		// String formId = jsonObj.get("formId") == null ? "" : jsonObj.get("formId").toString();
		String formText = jsonObj.get("html") == null ? "" : jsonObj.get("html").toString();
		String orgCompanyID = jsonObj.get("orgCompanyID") == null? null : jsonObj.get("orgCompanyID").toString();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !userInfo.getCompanyID().equals(orgCompanyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}

		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String path = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		String saveFileName = "";
		String saveDir = "";
		String ret = "";
		String realPath = commonUtil.getRealPath(request);
		InputStream stream = null;
		
		saveFileName = realPath + path + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator + docID + extension + (jsonObj.get("draftAllB") == null ? "" : jsonObj.get("draftAllB").toString()); 
		saveDir = realPath + path + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(docID);
		
		logger.debug("<<<userID : " + userInfo.getId());
		logger.debug("<<<userName : " + userInfo.getDisplayName());
		logger.debug("<<<realPath : " + realPath);
		logger.debug("<<<path : " + path);
		logger.debug("<<<saveFileName : " + saveFileName);
		logger.debug("<<<saveDir : " + saveDir);

		try {
			if (docID == null || formText.equals("")) {
				ret = "FALSE";

				logger.debug("<<<docID : " + docID);
				logger.debug("<<<formText : " + formText);
				logger.debug("there is no primary data.");

				return ret;
			}
			
			EzFile file = new EzFile(commonUtil.detectPathTraversal(saveDir));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			if (extension.equals(".hwp")) {
				stream = new ByteArrayInputStream(Base64.decodeBase64(formText));
			} else {
				stream = new ByteArrayInputStream(formText.getBytes("UTF-8"));
			}

			String tmpPath = commonUtil.detectPathTraversal(saveFileName);
			if (extension.equals(".hwp")) {
				tmpPath += "_tmp";
			}
			
			// EzFAL EzFileOutputStream 사용 (자동 close 호출)
			try (EzFileOutputStream fos = new EzFileOutputStream(tmpPath)) {
				int bytesRead = 0;
				byte[] buffer = new byte[BUFF_SIZE];
				
				while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
					fos.write(buffer, 0, bytesRead);
				}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}

			if (extension.equals(".hwp")) {
				try {
					EzFile tmpFile = new EzFile(tmpPath);
					EzFile targetFile = new EzFile(commonUtil.detectPathTraversal(saveFileName));
					HWPFile hwpFile = HWPReader.fromFile(tmpFile.getFile()); // 상단 EzFileOutputStream으로 write한 HWP파일에 접근
					
					if (hwpFile != null) {
						String clickTitle = FieldFinder.getClickHereText(hwpFile,"doctitle", TextExtractMethod.OnlyMainParagraph);
						ArrayList<kr.dogfoot.hwplib.object.bodytext.control.table.Cell> cellTitle = CellFinder.findAll(hwpFile, "doctitle");
						if (clickTitle == null && cellTitle.size() == 0) {
							tmpFile.delete();
							return "FALSE";
						} else {
							EzFAL.copyFile(tmpFile, targetFile); // 로컬 경로 또는 오브젝트 스토리지 상의 파일 복사를 위해 EzFAL 적용
							tmpFile.delete();
						}
					}
				} catch (Exception e) {
					EzFile tmpFile = new EzFile(tmpPath);
					EzFile targetFile = new EzFile(commonUtil.detectPathTraversal(saveFileName));
					EzFAL.copyFile(tmpFile, targetFile);
					tmpFile.delete();
				}
			}

			ret = "TRUE";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			ret = "FALSE";
		} finally {
			if (stream != null) {
				try {
					stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
		}
	    
		logger.debug("saveFile ended");
		
		return ret;
	}
	
	/**
	 * 전자결재G 결재선이력 업뎃 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/updateLineHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String updateLineHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("updateLineHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String userName = request.getParameter("userName");
		String userName2 = request.getParameter("userName2");
		String userJobTitle = request.getParameter("userJobTitle");
		String userJobTitle2 = request.getParameter("userJobTitle2");
		String userDeptID = request.getParameter("userDeptID");
		String userDeptName = request.getParameter("userDeptName");
		String userDeptName2 = request.getParameter("userDeptName2");
		String chkFlag = request.getParameter("chkFlag");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !userInfo.getCompanyID().equals(orgCompanyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = ezApprovalGService.updateHistoryForLine(docID ,userID, userName, userName2, userJobTitle, userJobTitle2, userDeptID, userDeptName, userDeptName2, chkFlag, userInfo.getCompanyID(), userInfo.getTenantId());
		logger.debug("docID = " + docID + ", userID = " + userID + ", userName = " + userName + ", userName2 = " + userName2 + ", userJobTitle = " + userJobTitle + ", userJobTitle2 = " + userJobTitle2 + ", userDeptID = " + userDeptID + ", userDeptName = " + userDeptName + ", userDeptName2 =" + userDeptName + ", chkFlag = " + chkFlag);
		logger.debug("updateLineHistory result = " + result);

		logger.debug("updateLineHistory ended");

		return result;
	}
	
	/**
	 * 전자결재G 결재시 암호입력 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezchkPasswd.do", method = RequestMethod.GET)
	public String ezchkPasswd(Model model, HttpServletRequest request) throws Exception {
		logger.debug("ezchkPasswd started");

		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "";
		
		model.addAttribute("publicModulus", publicModulus);
        model.addAttribute("publicExponent", publicExponent);
        model.addAttribute("mode", mode);
        
        logger.debug("ezchkPasswd ended");
        
		return "ezApprovalG/apprGezchkPasswd";
	}
	
	/**
	 * 전자결재G 결재시 암호입력 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezchkPasswdall.do", method = RequestMethod.GET)
	public String ezchkPasswdall(Model model) throws Exception {
		logger.debug("ezchkPasswdall started");
		
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		
		logger.debug("ezchkPasswdall ended");
		
		return "ezApprovalG/apprGezchkPasswdall";
	}
	
	/**
	 * 전자결재G 결재시 암호입력 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/chkPasswd.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String chkPasswd(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("chkPasswd started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = "";
		String orgPassword = "";
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
		String eUserID = request.getParameter("userID");
		String ePassWd = request.getParameter("passWd");
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		String dPassWd = EgovFileScrty.decryptRsa(pk, ePassWd);
		String dUserID = EgovFileScrty.decryptRsa(pk, eUserID);
		String password = EgovFileScrty.encryptPassword(dPassWd, dUserID);
		String flag = ezApprovalGService.getApprovalPWD(dUserID, userInfo.getTenantId(), userInfo.getCompanyID());
		
		if (flag != null) {
			if (flag.equals("Y")) {
				String pType = ezApprovalGService.getApprovalPWD2(dUserID, userInfo.getTenantId(), userInfo.getCompanyID());
				
				if (pType.equals("L")) {
					orgPassword = ezOrganService.getEncPassword(dUserID, userInfo.getTenantId());
					
					if (orgPassword.trim().equals(password)) {
						result = "1";
					}
				} else {
					String dbPassword = ezApprovalGService.getApprovalPWD1(dUserID, userInfo.getTenantId(), userInfo.getCompanyID());
					
					if (dbPassword.trim().equals(password)) {
						result = "1";
					}
				}
			} else {
				orgPassword = ezOrganService.getEncPassword(dUserID, userInfo.getTenantId());
				
				if (orgPassword.trim().equals(password)) {
					result = "1";
				}
			}
		} else {
			orgPassword = ezOrganService.getEncPassword(dUserID, userInfo.getTenantId());
			
			if (orgPassword.trim().equals(password)) {
				result = "1";
			}
		}
		
		logger.debug("chkPasswd ended");
		
		if (result.equals("1")) {
			return "TRUE";
		} else {
			return "FALSE";
		}
	}
	
	/**
	 * 전자결재G 결재화면 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/approvui.do", method = RequestMethod.GET)
	public String approvui(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("approvui started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
        int tenantID = userInfo.getTenantId();
        
		String crossEditor = ezCommonService.getTenantConfig("EDITOR", tenantID);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantID);
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", tenantID);
		String signImageSize = ezCommonService.getTenantConfig("SignImageSize", userInfo.getTenantId());
		//String docNumZeroCnt = ezCommonService.getTenantConfig("docNumZeroCnt", userInfo.getTenantId());
		String susinAdmin = "";
		String signImageType = ezCommonService.getTenantConfig("signImageType", userInfo.getTenantId());
		
		//baonk 추가 2018-08-08
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
		if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("apprv", userInfo);
		}
		
		// a=1 수발신담당자
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}

		String useOpenGov = config.getProperty("config.useOpenGov");
		
		String docID = request.getParameter("docID");
		String uID = request.getParameter("id");
		String name = request.getParameter("name");
		String deptID = request.getParameter("deptID");
		String allFlag = request.getParameter("allFlag");
		String tempUserID = userInfo.getId();
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator;
		String approvalPWD = ezApprovalGService.getApprovalPWD(uID, userInfo.getTenantId(), userInfo.getCompanyID());
		String addLastKyulJeYN = ezCommonService.getTenantConfig("addLastKyulJeYN", userInfo.getTenantId());
		String agreeReturnType = ezCommonService.getTenantConfig("PersonalAgreeReturnType", userInfo.getTenantId());
		String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		String draftDeptID = ezApprovalGService.getOrgDraftDeptID(docID, userInfo.getTenantId(), userInfo.getCompanyID());
		String mailChk = request.getParameter("mailchk");// 메일에서 전저결재 열람 여부('Y'일때는 메일 그 외에는 전자결재)
		String docState = request.getParameter("docState");
		String mode = request.getParameter("mode");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		String functionType = request.getParameter("functionType");
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
		String orgDocID = request.getParameter("orgDocID");
		String formId = "";
		boolean isReform = false;
		
		/* 2023-07-06 홍승비 - 기안 시점에는 사용자의 회사ID를 사용하나, 결재 시점에는 해당 문서의 orgCompanyID를 체크하도록 수정 */
		// FormBuilder
		ApprGFormVO reformInfo = ezApprovalGService.getReformInfoApprovalDocument(docID, userInfo.getId(), orgCompanyID, tenantID);
		if (reformInfo != null) {
			formId = reformInfo.getFormID();
			isReform = "Y".equals(reformInfo.getReformFlag());
		}
		
		if (docID == null) {
			docID = "";
		}
		
		if (orgDocID == null) {
			orgDocID = "";
		}
		
		if (mailChk == null) {
			mailChk = "";
		}
		
		String docDir = docID.substring(docID.length() - 3);

		if (docDir.substring(0, 1).equals("0")) {
			docDir = docDir.substring(docDir.length() - 2);
		} else if (docDir.substring(0, 2).equals("00")) {
			docDir = docDir.substring(docDir.length() - 1);
 		} else if (docDir.equals("000")) {
			docDir = "0";
		}
		
		dirPath = dirPath + docDir + "/" + docID + ".mht";
		// allFlag : 0(결재), 1(모두결재), 2(일괄결재)
		if (!allFlag.equals("1") && !allFlag.equals("2")) {
			allFlag = "0";
		}
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optIsSplit = "";
		
		// 결재칸 split 유무
		if (approvalFlag.equals("S")) {
			optIsSplit = ezApprovalGService.getOptionInfo("SA33", "001", userInfo, "CODE");  // Y
		} else {
			optIsSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE"); // N
		}
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE"); // FIX
		String optJunKyulInfo = ezApprovalGService.getOptionInfo("A32", "001", userInfo, "CODE"); //전결 처리 방법
		
		if (docID != null && !docID.equals("")) {
//			String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1", tenantID, userInfo.getOffset());
			String proxyUser = ezApprovalGService.getProxyUser2(userInfo.getId(), "1", tenantID, userInfo.getOffset());
			String[] proxyUserArray = proxyUser.split(",");
			boolean checkPermission = true;
			
			if (proxyUserArray.length > 1) {
				if (mode == null) {
					mode = "APR";
				}
				String docList = ezApprovalGService.getAprLineInfoDB(docID, "1", "", "", userInfo.getCompanyID(), userInfo.getTenantId(), "", "", mode, "");

				Document docXML = commonUtil.convertStringToDocument(docList);
				
				for (int k = 0; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
					if (docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("002") || docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("005") || docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("000")) {
						String curAprUserID = docXML.getElementsByTagName("ORGUSERID").item(k).getTextContent();
						
						for (int j = 0; j < proxyUserArray.length; j++) {
							if (curAprUserID.equals(proxyUserArray[j].trim().substring(1, proxyUserArray[j].trim().length() - 1))) {
								checkPermission = false;
								break;
							}
						}
					}
				}
			}
			
			/* 2020-07-22 홍승비 - 메일링크 클릭 시 결재진행&완료문서 보기 분기 추가 */
			if (checkPermission) {
				Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), "APR", userInfo.getCompanyID(), userInfo.getTenantId(), docState);
				
				if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
					if(mailChk != null && mailChk.equals("Y")) {
						model.addAttribute("chk", "no");
					
						// 진행문서인 경우
						ApprGDocListVO apprGIngDocVO = ezApprovalGService.getIngDocInfo(userInfo.getId(), docID.trim(), orgCompanyID, userInfo.getTenantId());
						if (apprGIngDocVO != null && apprGIngDocVO.getHref() != null && !apprGIngDocVO.getHref().trim().equals("")) {
							model.addAttribute("docID", docID.trim());
							model.addAttribute("listType", "3"); // 진행중문서 listType
							
							return "redirect:/ezApprovalG/view.do";
						} else {
							// 완료문서인 경우
							ApprGDocListVO apprGEndDocVO = ezApprovalGService.getEndDocInfo(docID.trim(), orgCompanyID, userInfo.getTenantId());
							if (apprGEndDocVO != null && apprGEndDocVO.getHref() != null && !apprGEndDocVO.getHref().trim().equals("")) {
								model.addAttribute("docID", docID.trim());
								
								return "redirect:/ezApprovalG/view.do";
							} else {
								return "main/warning";
							}
						}
					}
				}
			}
		}
		
		if (approvalFlag.equals("G")) {
			String nonElecRec = ezApprovalGService.checkNonElecRec(orgDocID, userInfo.getCompanyID(), userInfo.getTenantId());
			if (!nonElecRec.equals("")) {
				model.addAttribute("nonElecRec", nonElecRec);
			}
		}
		
		//2020-01-23 김은석 추가
		String useAnnualSusinYN = ezCommonService.getTenantConfig("useAnnualSusinYN", userInfo.getTenantId());
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		/* 2020-11-13 홍승비 - 대용량첨부 관련 파라미터 추가 */
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
		String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String bigAttachFileMinSaveDate = ezApprovalGService.getAttachFileMinSaveDate(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String bigAttachDownloadPeriod = bigAttachFileMinSaveDate + " ~ " + EgovDateUtil.addDay(bigAttachFileMinSaveDate, Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");
		
		String preSusinGroupStr = ezApprovalGService.getCode2Name("A53", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		// 2023-05-26 조수빈 - 전자결재 첨부파일 미리보기 기능 사용 여부
		String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
 		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
 		
 		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
 			useAprFilePrvw = "1";
 		} else {
 			useAprFilePrvw = "0";
 		}

	 	// 2024-05-23 김우철 - 헤더 숨기기 기능 사용 여부
	 	String useHideHeaderArea = ezCommonService.getTenantConfig("useHideHeaderArea", userInfo.getTenantId());
	 	// 2024-06-11 김우철 - 부서수신함에서 첨부, 문서첨부 기능 사용여부
	 	String useReceiptDeptFileAttach = ezCommonService.getTenantConfig("useReceiptDeptFileAttach", userInfo.getTenantId());
	    // 2024-12-10 기민혁 - 본문버전 변경 기능 사용 여부
	    String editVersionYN = ezCommonService.getTenantConfig("EditVertionYN",userInfo.getTenantId());
		
		// 기안자 정보
		String aprLinexml = ezApprovalGService.getLineInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		Document aprLineInfo = commonUtil.convertStringToDocument(aprLinexml);
		String drafterName = "";
		String drafterDept = "";
		if ("1".equals(userInfo.getPrimary())) {
			drafterName = aprLineInfo.getElementsByTagName("DATA13").item(0).getTextContent().trim();
			drafterDept = aprLineInfo.getElementsByTagName("DATA15").item(0).getTextContent().trim();
		} else {
			drafterName = aprLineInfo.getElementsByTagName("DATA14").item(0).getTextContent().trim();
			drafterDept = aprLineInfo.getElementsByTagName("DATA16").item(0).getTextContent().trim();
		}
		
		model.addAttribute("drafterName", drafterName);
		model.addAttribute("drafterDept", drafterDept);
		
		// 양식 정보
		String formName = "";
		if (StringUtils.isBlank(formId)) {
			formId = ezApprovalGService.getFormIdFromApr(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		String formInfoXml = ezApprovalGService.getFormInfoDetail(formId, userInfo.getCompanyID(), userInfo.getTenantId());
		Document formInfo = commonUtil.convertStringToDocument(formInfoXml);
		if (formInfo.getElementsByTagName("FORMNAME").item(0) != null) {
			if ("1".equals(userInfo.getPrimary())) {
				formName = formInfo.getElementsByTagName("FORMNAME").item(0).getTextContent().trim();
			} else {
				formName = formInfo.getElementsByTagName("FORMNAME2").item(0).getTextContent().trim();
			}
		}
		
		// ai 관련 컨피그 추가
		// AI 첨부파일 이름 최대 길이 - 기존 첨부파일과 동일한 값 사용
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		// AI 사용여부 확인
		boolean useAI = aICommonUtil.checkUseAI(userInfo.getTenantId());
		// AI 챗봇 첨부파일 최대용량
		String aiAttachMBSize = ezCommonService.getTenantConfig("aiAttachMBSize", userInfo.getTenantId());
		
		model.addAttribute("formName", formName);
		model.addAttribute("moduleType", "approval");
		model.addAttribute("moduleSubType", "apprDoc");
		model.addAttribute("useAI", useAI);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("aiAttachMBSize", aiAttachMBSize);

		model.addAttribute("useAnnualSusinYN", useAnnualSusinYN);
	    model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optIsSplit", optIsSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("optJunKyulInfo", optJunKyulInfo);
		model.addAttribute("uID", uID);
		model.addAttribute("name", name);
		model.addAttribute("deptID", deptID);
		model.addAttribute("dirPath", dirPath);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("docID", docID);
		model.addAttribute("tempUserID", tempUserID);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("allFlag", allFlag);
		model.addAttribute("oldYear", oldYear);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("crossEditor", crossEditor);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("junGyulFlag", junGyulFlag);
		model.addAttribute("signImageSize", signImageSize);
		model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));
		model.addAttribute("signImageType", signImageType);
		model.addAttribute("addLastKyulJeYN", addLastKyulJeYN);
		model.addAttribute("agreeReturnType", agreeReturnType);
		model.addAttribute("draftDeptID", draftDeptID);
		model.addAttribute("docState", docState);
		model.addAttribute("useCabinet", use_cabinet); // 캐비넷 추가 baonk 2018-08-08
		model.addAttribute("useReceiveDocNo", useReceiveDocNo);
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("functionType", functionType);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		// FormBuilder
		if (isReform) {
			model.addAttribute("isReform", isReform);
			model.addAttribute("formId", formId);
		}
		
		if (useOpenGov.equalsIgnoreCase("YES") && approvalFlag.equalsIgnoreCase("G")) {
			Map<String, Object> openGovMap = ezApprovalGService.getOpenGovInfo(docID, userInfo.getTenantId(), userInfo.getCompanyID());
			
			model.addAttribute("basis", openGovMap.get("basis"));
			model.addAttribute("reason", openGovMap.get("reason"));
			model.addAttribute("listOpenFlag", openGovMap.get("listOpenFlag"));
			model.addAttribute("fileOpenFlagList", openGovMap.get("fileOpenFlagList"));
		}

		model.addAttribute("useOpenGov", useOpenGov);
		
		//결재 세부정보
		String formAprOption = ezApprovalGService.getFormAprOptionInfo(docID, "DOC", userInfo.getCompanyID(), userInfo.getTenantId());
		model.addAttribute("formAprOption", formAprOption);
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		model.addAttribute("preSusinGroupStr", preSusinGroupStr);
		model.addAttribute("isPreview", isPreview);
		model.addAttribute("useReceiveInfoName", ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId())); // 수신처에 "장" 붙이는 옵션
		model.addAttribute("draftJunGyulFlag", ezCommonService.getTenantConfig("draftJunGyulFlag", userInfo.getTenantId())); // 일반버전 서명 remapping 시 전결문자 표출 확인용

		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		
		model.addAttribute("useHideHeaderArea", useHideHeaderArea);
		model.addAttribute("useReceiptDeptFileAttach", useReceiptDeptFileAttach);

		/* 2024-06-24 양지혜 - 지정반송 사용 여부 */
		model.addAttribute("useReturnByDesignation", ezCommonService.getTenantConfig("returnByDesignationUsed", userInfo.getTenantId()));
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
		
		model.addAttribute("editVersionYN", editVersionYN);

		// 2025-02-18 박기범 - 프론트에서 문서 편집시, 문서를 오픈한 이후로 다른 문서/결재진행 변화가 있었는지 체크하기 위한 코드
		model.addAttribute("snapshotCode", ezApprovalGService.getDocumentSnapshotCode(userInfo.getTenantId(), userInfo.getCompanyID(), docID));
		
		logger.debug("approvui ended");
		
		return "ezApprovalG/apprGapprovui";
	}
	
	/**
	 * 전자결재G 결재화면 결재내용 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/approvUIcontent.do", method = RequestMethod.GET)
	public String approvUIcontent(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		logger.debug("approvUIcontent started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useAllowTextSelection = ezCommonService.getTenantConfig("useAllowTextSelection", userInfo.getTenantId());
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());
		String draftJunGyulFlag = ezCommonService.getTenantConfig("draftJunGyulFlag", userInfo.getTenantId());
		boolean isReform = false;
		String reformFunctionUrl = "";
		
		// FormBuilder
		if (Boolean.valueOf(request.getParameter("isReform"))) {
		    isReform = true;
			
			String formId = request.getParameter("formId");
			String approvalUploadPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
			String reformFunctionRelativePath = String.join(commonUtil.separator, approvalUploadPath, userInfo.getCompanyID(), "form", "reform", formId, formId + "_FORMBuilder.js");
			
			Path realPath = Paths.get(request.getServletContext().getRealPath(""));
			
			// EzFAL 적용
			EzFile reformFunctionRelativePathEzFile = new EzFile(realPath.resolve("." + reformFunctionRelativePath).toString());
			
			//if (Files.exists(realPath.resolve("." + reformFunctionRelativePath))) {
			if (reformFunctionRelativePathEzFile.exists()) {
			    reformFunctionUrl = reformFunctionRelativePath;
			}
		}
		
		model.addAttribute("editor", editor);
		model.addAttribute("useAllowTextSelection", useAllowTextSelection);
        model.addAttribute("isReform", isReform);
        model.addAttribute("reformFunctionUrl", reformFunctionUrl);
		model.addAttribute("lang",userInfo.getLang());

		model.addAttribute("junGyulFlag", junGyulFlag);
		model.addAttribute("draftJunGyulFlag", draftJunGyulFlag);
		
		logger.debug("approvUIcontent ended");
		
		return "ezApprovalG/apprGapprovUIcontent";
	}
	
	/**
	 * 전자결재G 결재정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getApproveDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getApproveDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getApproveDocInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String mode = request.getParameter("mode");
		String chamState = request.getParameter("chamState");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		userInfo.setRealPath(commonUtil.getRealPath(request));
		
		String result = ezApprovalGService.getApproveDocInfo(userInfo, docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), mode, chamState);

		logger.debug("getApproveDocInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 결재문서정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getDocInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String isUsed = request.getParameter("isUsed");
		String beforeDocID = request.getParameter("beforeDocID");
		
		if (isUsed == null) {
			isUsed = "";
		}
		
		if (beforeDocID == null) {
			beforeDocID = "";
		}
		
		String result = ezApprovalGService.getDocInfo(docID, "APR", "ALL", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), isUsed, beforeDocID);
		
		logger.debug("getDocInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 마지막의견내용 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getLastOpinonCotent.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getLastOpinonCotent(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getLastOpinonCotent started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getLastOpinionContent(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("getLastOpinonCotent ended");
		
		return "<PARA><Row><![CDATA[" + result + "]]></Row></PARA>";
	}

	/**
	 * 전자결재G 사인정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getSignInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getSignInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Locale locale) throws Exception{
		logger.debug("getSignInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getSignInfo(docID, userInfo.getOffset(), userInfo.getLocale(), userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("getSignInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물번호 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getCabinetSN.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getCabinetSN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getCabinetSN started");
	
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			companyID = orgCompanyID;
		}
		String result = ezApprovalGService.getCabinetNum(deptID, "", companyID, docID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		logger.debug("docID = " + docID + "deptID = " + deptID);

		logger.debug("getCabinetSN result = " + result);
		logger.debug("getCabinetSN ended");

		return result;
	}
	
	/**
	 * 전자결재G 기록물번호롤백 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/rollbackCabinetSN.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String rollbackCabinetSN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("rollbackCabinetSN started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String sn = request.getParameter("docNumber");
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.rollbackCabinetNum(deptID, "", sn, userInfo.getCompanyID(), docID, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("rollbackCabinetSN ended");

		return result;
	}
	
	/**
	 * 전자결재G 사인날짜 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getSignDate.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getSignDate() throws Exception {
		logger.debug("getSignDate started");
		
		String month = EgovDateUtil.getTodayTime().substring(5, 7);
		String day = EgovDateUtil.getTodayTime().substring(8, 10);
		String gyulJaeDate = month + "/" + day;
		
		logger.debug("getSignDate ended");
		return gyulJaeDate;
	}
	
	/**
	 * 전자결재G 사인정보 저장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setSignInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setSignInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		logger.debug("setSignInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.updateSignInfo(xmlDom, userInfo.getCompanyID(), "SET", userInfo.getTenantId());
		
		logger.debug("setSignInfo ended.");
		
		return result;
	}

	/**
	 * 전자결재G 결재 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doApprov.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String doApprov(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		logger.debug("doApprov started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);

		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		userInfo.setRealPath(commonUtil.getRealPath(request));
		
		if (xmlDom.getElementsByTagName("ORGCOMPANYID") != null && !xmlDom.getElementsByTagName("ORGCOMPANYID").item(0).getTextContent().equals(userInfo.getCompanyID()) ) {
			userInfo.setCompanyID(xmlDom.getElementsByTagName("ORGCOMPANYID").item(0).getTextContent());
		}
		
		String result = ezApprovalGService.doProcess("003", xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(19).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent(), 
				xmlDom.getDocumentElement().getChildNodes().item(43).getTextContent(), dirPath, xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent(), 
				xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent(), xmlDom, xmlDom.getDocumentElement().getChildNodes().item(26).getTextContent(), userInfo.getCompanyID(), userInfo.getLang(),userInfo);
		
		logger.debug("doApprov ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 백단 컨트론 결재 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doApprovBackEnd.do", produces = "application/json;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject doApprovBackEnd(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody JSONObject docObj, HttpServletRequest request) throws Exception{
		logger.debug("doApprovBackEnd started.");
		JSONObject result = new JSONObject();

		userInfo = commonUtil.aprUserInfo(loginCookie);

		try {
			String userId = userInfo.getId();
			int tenantID = userInfo.getTenantId();
			String companyID = userInfo.getCompanyID();

			// MCommonVO commonUserInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userInfo.getId(), userInfo.getTenantId());
//			String locale = request.getParameter("locale");
			String docID = docObj.get("docID") == null ? "" : docObj.get("docID").toString();
			String aprMemberSN = docObj.get("aprMemberSN") == null ? "" : docObj.get("aprMemberSN").toString();
			String mode = docObj.get("mode") == null ? "" : docObj.get("mode").toString();
			String type = docObj.get("type") == null ? "" : docObj.get("type").toString();
			String realPath = commonUtil.getRealPath(request);

//			String serverName = request.getHeader("x-user-host");

			if (mode == null || mode.equals("")) {
				mode = "APR";
			}

			String rtnVal = "";

			//docId로만 정보 가져오기
			MApprovalGDocInfoVO approvalGDocInfoVO = null;
			if (type.equalsIgnoreCase("GR")) {
				approvalGDocInfoVO = mApprovalGService.getAprDocInfo(docID, "GR", userInfo.getLang(), userInfo.getOffset(), companyID, userInfo.getTenantId(), aprMemberSN, mode);
			} else {
				approvalGDocInfoVO = mApprovalGService.getAprDocInfo(docID, "DO", userInfo.getLang(), userInfo.getOffset(), companyID, userInfo.getTenantId(), aprMemberSN, mode);
			}

			if (type.equals("APR")) {
				String lineMode = ezApprovalGService.getLineModeFlag(docID, userInfo.getId(), companyID, userInfo.getTenantId());

				// userID로 추출
				String aprState = ezApprovalGService.getDocAprState(docID, aprMemberSN, userInfo.getId(), companyID, userInfo.getTenantId());
				// userID로 추출한 값이 없을 경우 orgID로 추출
				if (aprState == null || aprState.equals("")) {
					aprState = ezApprovalGService.getDocAprState(docID, "", approvalGDocInfoVO.getAprMemberID(), companyID, userInfo.getTenantId());
				}
				// userID로 추출
				String rValue = ezApprovalGService.getDocAprLine(docID, aprMemberSN, userInfo.getId(), aprState, companyID, userInfo.getTenantId());
				// userID로 추출한 값이 없을 경우 orgUID로 추출
				if (rValue == null || rValue.equals("<DATA></DATA>")) {
					rValue = ezApprovalGService.getDocAprLine(docID, "", approvalGDocInfoVO.getAprMemberID(), aprState, companyID, userInfo.getTenantId());
				}
				Document xmlDom = commonUtil.convertStringToDocument(rValue);
				String aprType = xmlDom.getElementsByTagName("APRTYPE").item(0).getTextContent();
				
				if("016".equals(aprType) || "008".equals(aprType) || "009".equals(aprType)){
					throw new Exception("Not supported Approval Type");
				}

				if(approvalGDocInfoVO.getHref().endsWith("mht")) {
					rtnVal = ezApprovalGService.mobileSrvConn(userId, "A", approvalGDocInfoVO.getFormID(), "", docID, approvalGDocInfoVO.getAprMemberID(), userInfo.getLang(), companyID, request, userInfo, lineMode, aprMemberSN);
				} else {
					rtnVal = ezApprovalGService.mobileSrvConn_HWP(userId, "A", approvalGDocInfoVO.getFormID(), "", docID, approvalGDocInfoVO.getAprMemberID(), userInfo.getLang(), companyID, request, userInfo, lineMode, aprMemberSN);
				}

				/* 2020-07-02 홍승비 - 모바일에서 최종결재 완료 시 서명에 결재날짜 삽입 동작 추가(결재날짜 필드가 없는 경우에만, 웹과 동일하게) */
				if (rtnVal != null && !rtnVal.contains("ERROR")) {
					String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantID);
					if(approvalFlag.equals("S")) {
						String domain = request.getServerName() + ":" + request.getServerPort();
						String scheme = "http://";

						if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
							scheme = "https://";
						}
						rtnVal = mApprovalGService.insertSeumyungdateMobile(docID, realPath, userInfo.getOffset(), userInfo.getLocale(), domain, scheme, companyID, tenantID);
					}
				}

				if (rtnVal != null && !rtnVal.contains("ERROR")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else if (type.equals("BAN")) {
				String lineMode = ezApprovalGService.getLineModeFlag(docID, userInfo.getId(), companyID, tenantID);
				if(approvalGDocInfoVO.getHref().endsWith("mht")) {
					rtnVal = ezApprovalGService.mobileSrvConn(userId, "B", approvalGDocInfoVO.getFormID(), "", docID, approvalGDocInfoVO.getAprMemberID(), userInfo.getLang(), companyID, request, userInfo, lineMode, aprMemberSN);
				} else {
					rtnVal = ezApprovalGService.mobileSrvConn_HWP(userId, "B", approvalGDocInfoVO.getFormID(), "", docID, approvalGDocInfoVO.getAprMemberID(), userInfo.getLang(), companyID, request, userInfo, lineMode, aprMemberSN);
				}

//				String pBansongDeptID = ezApprovalGService.getBansongDeptID(docID, companyID, userInfo.getTenantId(), loginVO);

//				rtnVal = ezApprovalGService.doBansong(docID, "", approvalGDocInfoVO.getAprMemberID(), "004", realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator, pBansongDeptID, companyID, userInfo.getLang(), loginVO, "");

				if (rtnVal != null && !rtnVal.contains("ERROR")) {
//				    if (rtnVal != null && !rtnVal.equals("FALSE")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else if (type.equals("BO")) {
				rtnVal = ezApprovalGService.doBoryu(docID, approvalGDocInfoVO.getAprMemberID(), "005", companyID, userInfo.getLang(), tenantID, userInfo.getDisplayName(), "");

				/* 일괄결재 보류 DB 백단 처리 */
				List<ApprGGroupDocInfoVO> groupDocList = ezApprovalGService.getGroupDocList(docID, "APR", userInfo.getTenantId(), companyID);
				if(groupDocList.size() > 1){
					for(int i = 1; i < groupDocList.size(); i++){
						rtnVal = ezApprovalGService.doBoryu(groupDocList.get(i).getDocID(), approvalGDocInfoVO.getAprMemberID(), "005", companyID, userInfo.getLang(), tenantID, userInfo.getDisplayName(), "");
					}
				}
				
				if (rtnVal != null && !rtnVal.equals("FALSE")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else if (type.equals("HWE")) {
				/* 2021-08-18 홍승비 - 회수메일 발송 시점은 회수동작 이전이 되도록 수정 (현재 결재진행(승인)상태인 참조자와 결재자에게 메일을 보내야 하므로) */
				// mApprovalGService.sendApproveNoticeMail(userInfo, userInfo, approvalGDocInfoVO, docID, type);

				rtnVal = ezApprovalGService.doCallBack(docID, userId, companyID, userInfo.getTenantId(), "");

				/* 일괄기안 DB 백단 처리 */
				List<ApprGGroupDocInfoVO> groupDocList = ezApprovalGService.getGroupDocList(docID, "APR", userInfo.getTenantId(), companyID);
				if(groupDocList.size() > 1){
					for(int i = 1; i < groupDocList.size(); i++){
						rtnVal = ezApprovalGService.doCallBack(groupDocList.get(i).getDocID(), userId, companyID, userInfo.getTenantId(), "");
					}
				}
				
				if (rtnVal != null && !rtnVal.equals("<RESULT>FALSE</RESULT>")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else if (type.equals("CHECK")) {
				rtnVal = ezApprovalGService.doApprove(docID, approvalGDocInfoVO.getAprMemberID(), "003", approvalGDocInfoVO.getAprMemberName(), approvalGDocInfoVO.getAprMemberName2(), realPath + approvalGDocInfoVO.getHref(), approvalGDocInfoVO.getAprMemberDeptID(), userInfo.getId(), companyID, userInfo.getLang(), userInfo, "", "017", "", "", "");

				/* 일괄기안 DB 백단 처리 */
				List<ApprGGroupDocInfoVO> groupDocList = ezApprovalGService.getGroupDocList(docID, "APR", userInfo.getTenantId(), companyID);
				if(groupDocList.size() > 1){
					for(int i = 1; i < groupDocList.size(); i++){
						rtnVal = ezApprovalGService.doApprove(groupDocList.get(i).getDocID(), approvalGDocInfoVO.getAprMemberID(), "003", approvalGDocInfoVO.getAprMemberName(), approvalGDocInfoVO.getAprMemberName2(), realPath + groupDocList.get(i).getDocHref(), approvalGDocInfoVO.getAprMemberDeptID(), userInfo.getId(), companyID, userInfo.getLang(), userInfo, "", "017", "", "", "");
					}
				}
				
				if (rtnVal != null && !rtnVal.equals("FALSE")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else if (type.equals("GR")) {
				rtnVal = ezApprovalGService.gongRamUpdate(docID, userInfo.getId(), companyID, userInfo.getLang(), userInfo.getTenantId());
				
				if (rtnVal != null && !rtnVal.equals("FALSE")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else {
				//오류
				result.put("status", "error");
				result.put("code", "1");
			}

			// 회수알림메일의 경우, 회수동작 이전에 결재진행(승인)상태인 결재자 및 참조자에게 메일을 발송하므로 예외처리함
			if (!type.equals("HWE") && "SUCCESS".equals(result.get("data"))) {
				ezApprovalGService.sendMailToNextAprMember(docID, request, loginCookie, userInfo, companyID, userInfo.getTenantId());
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");
		}
		logger.debug("doApprovBackEnd ended.");

		return result;
	}
	
	/**
	 * 전자결재G 반송 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doBansongApprov.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String doBansongApprov(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		logger.debug("doBansongApprov started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		userInfo.setRealPath(commonUtil.getRealPath(request));
		
		if (xmlDom.getElementsByTagName("ORGCOMPANYID") != null && !xmlDom.getElementsByTagName("ORGCOMPANYID").item(0).getTextContent().equals(userInfo.getCompanyID()) ) {
			userInfo.setCompanyID(xmlDom.getElementsByTagName("ORGCOMPANYID").item(0).getTextContent());
		}
		
		String pDeptID = "";
		if (xmlDom.getElementsByTagName("BANSONGDEPTID").item(0) != null && !xmlDom.getElementsByTagName("BANSONGDEPTID").item(0).getTextContent().trim().equals("")) {
			pDeptID = xmlDom.getElementsByTagName("BANSONGDEPTID").item(0).getTextContent();
		} else {
			pDeptID = xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent();
		}
		
		String result = ezApprovalGService.doProcess("004", xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(19).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent(), 
				xmlDom.getDocumentElement().getChildNodes().item(43).getTextContent(), dirPath, pDeptID, 
				xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent(), xmlDom, "", userInfo.getCompanyID(), userInfo.getLang(), userInfo);
		
		logger.debug("doBansongApprov ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 보류 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doBoryuApprov.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String doBoryuApprov(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		logger.debug("doBoryuApprov started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		userInfo.setRealPath(commonUtil.getRealPath(request));
		
		if (xmlDom.getElementsByTagName("ORGCOMPANYID") != null && !xmlDom.getElementsByTagName("ORGCOMPANYID").item(0).getTextContent().equals(userInfo.getCompanyID()) ) {
			userInfo.setCompanyID(xmlDom.getElementsByTagName("ORGCOMPANYID").item(0).getTextContent());
		}
		
		String result = ezApprovalGService.doProcess("005", xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(19).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent(), 
				xmlDom.getDocumentElement().getChildNodes().item(43).getTextContent(), dirPath, xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent(), 
				xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent(), xmlDom, "", userInfo.getCompanyID(), userInfo.getLang(), userInfo);
		
		logger.debug("doBoryuApprov ended.");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/sendAckforExch.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String sendAckforExch() throws Exception{
		return "";
	}
	
	/**
	 * 전자결재G 회수 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doCanCelYN.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String doCanCelYN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("doCanCelYN started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String tempUserID = request.getParameter("userID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !userInfo.getCompanyID().equals(orgCompanyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
 		String result = ezApprovalGService.getCallBackYN(docID, tempUserID, userInfo.getCompanyID(), userInfo.getTenantId());
		
 		logger.debug("doCanCelYN ended.");
 		
 		return result;
	}
	
	/**
	 * 전자결재G 강제회수 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doForceCancelYN.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String doForceCancelYN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("doForceCancelYN started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String tempUserID = request.getParameter("userID");
		String result = ezApprovalGService.getCallBackYNForceLine(docID, tempUserID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("doForceCancelYN ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 문서보기 내용 호출 Method
	 * 
	 */
	@RequestMapping(value = "/ezApprovalG/ConDocViewContent.do", method = RequestMethod.GET)
	public String ConDocViewContent(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("ConDocViewContent started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		model.addAttribute("editor", editor);
		
		logger.debug("ConDocViewContent ended.");
		
		return "ezApprovalG/apprGConDocViewContent";
	}
	
	/**
	 * 전자결재G 첨부파일정보 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/totalSaveFileInfo.do", method = RequestMethod.GET)
	public String totalSaveFileInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("totalSaveFileInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String pass = "";
		String docID = request.getParameter("docID");
		String type = request.getParameter("type");
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
		String useHwpDownSecurity = ezCommonService.getTenantConfig("useHwpDownSecurity", userInfo.getTenantId());
		String webHWPUrl = ezCommonService.getTenantConfig("webHWPUrl", userInfo.getTenantId());
		String HwpSecurityNum = "";
		String hasOpinion = "";
		String orgCompanyID = request.getParameter("orgCompanyID");

		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}

		/* 2023-05-10 김우철 - 한글문서 배포(수정 및 복사 제한)를 위한 배포용 암호 설정 테넌트 컨피그로 추가 */
		if (useHwpDownSecurity.equals("Y") && approvalFlag.equals("G")) {
			HwpSecurityNum = ezCommonService.getTenantConfig("HwpSecurityNum", userInfo.getTenantId());
		}
		
		/* 2023-06-23 한태훈 - 통합 PC 저장시 완료 문서의 경우 문서의 의견을 가져와서 표출하는 기능 추가. */
		List<ApprGOpinionVO> apprGOpinionList = ezApprovalGService.getDocOpinionList(docID, userInfo);
		if (apprGOpinionList.size() > 0) {
			hasOpinion="Y";
		} else {
			hasOpinion="N";
		}

		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("m=1") == -1) {
			pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());
		} else {
			pass = "<RESULT>TRUE</RESULT>";
		}

		// 부서수신함 문서를 열람하지않고 통합PC저장을 클릭한 경우 문서 파일이 해당 경로에 존재하지 않아 발생하는 오류 수정.
		String approvalRoot = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String dirPath = commonUtil.getRealPath(request) + approvalRoot;
		String rtnVal = ezApprovalGService.getOrgDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());

		Document xmlDom = commonUtil.convertStringToDocument(rtnVal);

		if (xmlDom.getElementsByTagName("ORGHREF").getLength() > 0) {
			String orgDocFile = xmlDom.getElementsByTagName("ORGHREF").item(0).getTextContent();
			String docFile = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();

			orgDocFile = dirPath + orgDocFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			docFile = dirPath + docFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");

			String dir = docFile.substring(0, docFile.lastIndexOf(commonUtil.separator) + 1);
			EzFile file = new EzFile(commonUtil.detectPathTraversal(dir));

			if (!file.exists()) {
				file.mkdirs();
			}

			EzFile newFile = new EzFile(commonUtil.detectPathTraversal(docFile));

			if (!newFile.exists()) {
				EzFile orgFile = new EzFile(commonUtil.detectPathTraversal(orgDocFile));

				// KLIB 복호화
				if (orgDocFile.endsWith("." + EzApprovalGKlibServiceImpl.ENCRYPTED_FILE_EXT)) {
/*					byte[] orgBytes = commonUtil.readBytesFromFile(orgFile.getFile());
					write(newFile, klibUtil.decrypt(orgBytes));*/
					
					byte[] orgBytes = FileUtils.readFileToByteArray(orgFile.getFile());
					
					// EzFAL EzFileOutputStream 사용 (자동 close 호출)
					try (EzFileOutputStream fos = new EzFileOutputStream(file)) {
						fos.write(klibUtil.decrypt(orgBytes));
						fos.flush();
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
					}
				} else {
					EzFAL.copyFile(orgFile, newFile);
				}
			}
		}

		model.addAttribute("pass", pass);
		model.addAttribute("docID", docID);
		model.addAttribute("type", type);
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("useHwpDownSecurity", useHwpDownSecurity);
		model.addAttribute("webHWPUrl", webHWPUrl);
		model.addAttribute("HwpSecurityNum", HwpSecurityNum);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("useHWP", ezCommonService.getTenantConfig("useHWP", userInfo.getTenantId()));
		model.addAttribute("hasOpinion", hasOpinion);

		logger.debug("totalSaveFileInfo ended.");
		
		return "ezApprovalG/apprGtotalSaveFileInfo";
	}
	
	/**
	 * 전자결재G 통합문서다운 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getTotalDoc.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getTotalDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getTotalDoc started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String mode = request.getParameter("mode");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = ezApprovalGService.getTotalDownload(docID, mode, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("getTotalDoc ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 통합문서다운 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/saveTotalDoc.do", produces = "text/plain;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String saveTotalDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		logger.debug("saveTotalDoc started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String realPath = commonUtil.getRealPath(request);
		String docID = xmlDom.getElementsByTagName("PDOCID").item(0).getTextContent().trim();
		String zipFileName = xmlDom.getElementsByTagName("PTITLE").item(0).getTextContent().replaceAll("\\t", " ");
		String hasOpinion = xmlDom.getElementsByTagName("POPINIONCHK").item(0).getTextContent().trim();
		String orgCompanyID = xmlDom.getElementsByTagName("PORGCOMPANY").item(0).getTextContent().trim();
		String separators = "\\|\\|\\|";
		String[] fileTypes = xmlDom.getElementsByTagName("PTYPEINFO").item(0).getTextContent().split(separators);
		String[] filePaths = xmlDom.getElementsByTagName("PPATHINFO").item(0).getTextContent().split(separators);
		String[] fileNames = xmlDom.getElementsByTagName("PFILEINFO").item(0).getTextContent().split(separators);
		String[] downUrl = new String[fileTypes.length];
		String[] hwpInfo = xmlDom.getElementsByTagName("PHWPINFO").item(0).getTextContent().split(separators);
		String useHwpDownSecurity = ezCommonService.getTenantConfig("useHwpDownSecurity", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String attMark = messageSource.getMessage("ezApprovalG.t56", userInfo.getLocale()); // 첨부

		/* 2023-05-10 김우철 - 한글문서 배포(수정 및 복사 제한)를 위한 설정 테넌트 컨피그 추가 */
		if (useHwpDownSecurity.equals("Y") && approvalFlag.equals("G")) {
			downUrl = xmlDom.getElementsByTagName("PDOWNINFO").item(0).getTextContent().split(separators);
		}
		
		InputStream inpStream = null;
		ZipOutputStream zout = null;
		String zipFilePath = null;
		String sourceDirPath = commonUtil.detectPathTraversal(realPath + commonUtil.getUploadPath("upload_common.DOCDOWNLOAD", userInfo.getTenantId()) + commonUtil.separator + docID);
		
		try {
			File sourceDir = new File(sourceDirPath); // docDownload 경로의 임시 파일이므로 EzFAL 적용 제외
			
			if (sourceDir.exists()) {
				// 2019.03.26 천성준 - 폴더경로 하위에 파일이 존재하면 File삭제 함수가 안돌아서 해당경로에 파일먼저 삭제 후 폴더삭제하도록 로직추가
				for (File sDirFile : sourceDir.listFiles()) {
					sDirFile.delete();
				}
				sourceDir.delete();
			}
			
			sourceDir = new File(commonUtil.detectPathTraversal(realPath + commonUtil.getUploadPath("upload_common.DOCDOWNLOAD", userInfo.getTenantId()) + commonUtil.separator + docID));
			
			if (!sourceDir.exists()) {
				sourceDir.mkdirs();
			}
			
			/* 2023-03-08 홍승비 - 전자결재 통합PC저장 시, 중복된 파일은 (1), (2)... 등으로 숫자를 붙여 다운로드 가능하도록 수정 (메일, 게시판 모듈과 동일) */
			Map<String, Integer> fileNameMap = new HashMap<String, Integer>();
			
			zipFilePath = commonUtil.getUploadPath("upload_common.DOCDOWNLOAD", userInfo.getTenantId()) + commonUtil.separator + docID + commonUtil.separator + zipFileName + ".zip";
			zout = new ZipOutputStream(new FileOutputStream(new File(commonUtil.detectPathTraversal(realPath + zipFilePath))));
			
			//첨부파일 있을 시 첨부 폴더 생성
			if (Arrays.asList(fileTypes).contains("ATT")) {
				zout.putNextEntry(new ZipEntry(attMark + commonUtil.separator));
				zout.closeEntry();
			}

			for (int k = 0; k < filePaths.length; k++) {
				if (filePaths[0] == "") {
					break; // 의견 파일만 다운로드 하는 경우 문서, 첨부파일, 문서첨부 파일 다운로드 x
				}

				BufferedInputStream bis = null;
				
				try {
					EzFile sourceFile = new EzFile(commonUtil.detectPathTraversal(realPath + filePaths[k])); // 다운받기 위한 원본 파일의 경로 (서버 상에 정식 업로드된 파일이므로 EzFAL을 적용)
//					byte[] fileBytes = FileUtils.readFileToByteArray(sourceFile.getFile());
					byte[] fileBytes = null;
					String realExt = "";
					String sourceFilePath = "";
					
					// 원본 파일을 스트림에서 바이트로 read
					// EzFAL EzFileInputStream 사용 (자동 close 호출)
		    		try (EzFileInputStream fis = new EzFileInputStream(sourceFile.getFile().getPath())) {
		    			fileBytes = IOUtils.toByteArray(fis);
		    		} catch (Exception e) {
		    			logger.error(e.getMessage(), e);
		    		}
					
					// 전자결재 KLIB 암/복호화
					if (filePaths[k].endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
						fileBytes = klibUtil.decrypt(fileBytes);
						
						// 복호화하여 다운로드하므로, .ezd로 끝나는 확장자(/\\.ezd$/)가 파일명에 존재한다면 제거
						fileNames[k] = fileNames[k].replaceAll(("\\." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT + "$"), "");
						realExt = filePaths[k].replaceAll(("\\." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT + "$"), "");
					}
					
					// 파일경로에서 찾은 실제 파일 확장자 보존 (.문자 포함)
					realExt = filePaths[k].substring(filePaths[k].lastIndexOf("."));
					
					// 파일명에 확장자가 존재하지 않는 경우, 실제 확장자를 어펜드 (KLIB 암/복호화 관련 확장자는 제외)
					if (!fileNames[k].endsWith(realExt) && !filePaths[k].endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
						fileNames[k] = fileNames[k] + realExt;
					}
					
					fileNames[k] = commonUtil.getUniqueFileName(fileNames[k], fileNameMap);
					
					// 페이지에서 문서 타입과 확장자(hwp)를 확인하기 때문에 배포용 문서에 해당하는 경우만 if문 진입
					if (useHwpDownSecurity.equals("Y") && approvalFlag.equals("G") && !hwpInfo[k].equals("noPath")) {
						sourceFilePath = sourceDirPath + commonUtil.separator + fileNames[k]; // docDownload 경로 하위, 다운로드를 위해 배포용으로 복사한 HWP파일이 생성될 경로
						Path pathSource = Paths.get(sourceFilePath);
						URL downloadUrl = new URL(downUrl[k]);
						
						try {
							inpStream = downloadUrl.openStream();
							Files.copy(inpStream, pathSource); // 배포용 HWP파일이 docDownload 경로에 복사됨, URL을 통해서 다운받게 되므로 EzFAL 적용 제외
							
							inpStream.close();
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
						} finally {
							if (inpStream != null) {
								try {
									inpStream.close();
								} catch (Exception ignore) {
									logger.error(ignore.getMessage(), ignore);
								}
						    }
						}
						
						// 위에서 fileBytes를 정의하므로 충돌을 피하기 위한 null값 설정
						fileBytes = null;
						fileBytes = commonUtil.readBytesFromFile(pathSource);
						
						// fileBytes 변수에 배포용 문서 파일을 read했기 때문에, 임의로 만들어준 배포용 문서 파일은 바로 삭제
						File hwpSourceFile = new File(commonUtil.detectPathTraversal(sourceFilePath));
						if (hwpSourceFile.exists()) {
							hwpSourceFile.delete();
						}
					}
					
					// 첨부파일인 경우 첨부폴더에 파일 추가
					String entryFilePath = fileTypes[k].equals("ATT") ? attMark + commonUtil.separator + fileNames[k] : fileNames[k];
					ZipEntry zentry = new ZipEntry(entryFilePath);
					zout.putNextEntry(zentry);
					zout.write(fileBytes);
					zout.closeEntry();
					
				} catch (IOException e) {
					logger.error(e.getMessage(), e);
				} finally {
					if (bis != null) {
						try {
							bis.close();
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
						}
					}
				}
			}

			// 의견 정보 다운로드 추가
			if (hasOpinion.equals("Y")) {
				FileWriter fw = null;
				PrintWriter writer = null;
				String opinionTxtFileName = messageSource.getMessage("ezApprovalG.t00012", userInfo.getLocale()); // 의견 파일
				String opinionWriterMark = messageSource.getMessage("ezApprovalG.t00014", userInfo.getLocale()); // 작성자 :
				String opinionContentMark = messageSource.getMessage("ezApprovalG.t00015", userInfo.getLocale()); // 의견 내용 :

				if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
					userInfo.setCompanyID(orgCompanyID);
				}

				List<ApprGOpinionVO> apprGOpinionList = ezApprovalGService.getDocOpinionList(docID, userInfo);

				logger.debug("downloading endAprdoc opinions starts");
				// 의견 파일을 임시로 만들어서 내용 작성 후 다운로드가 완료되면 삭제함.
				String tempOpinionFilePath = commonUtil.getUploadPath("upload_common.DOCDOWNLOAD", userInfo.getTenantId()) + commonUtil.separator + docID + commonUtil.separator;

				File opinionFile = null;

				String lineSepearator = System.lineSeparator();

				// try-with-resources
				try {
					opinionFile = new File(commonUtil.detectPathTraversal(realPath + tempOpinionFilePath + opinionTxtFileName + ".txt")); // docDownload 경로의 임시 파일이므로 EzFAL 적용 제외
					fw = new FileWriter(opinionFile, false);
					writer = new PrintWriter(fw);
					String opinionFileContent = ezApprovalGService.makingOpinionFileContent(userInfo, apprGOpinionList, opinionWriterMark, opinionContentMark, lineSepearator);

					if (apprGOpinionList.size() > 0) {
						writer.write(opinionFileContent);
						writer.flush();
						byte[] fileOpinionBytes = commonUtil.readBytesFromFile(opinionFile.toPath());

						ZipEntry zentry = new ZipEntry(opinionTxtFileName+".txt");
						zout.putNextEntry(zentry);
						zout.write(fileOpinionBytes);
						zout.closeEntry();
					}
				}
				catch (Exception e) {
					logger.error(e.getMessage(), e);
				} finally {
					if (fw != null) {
						try {
							fw.close();
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
						}
					}
					if (writer!=null) {
						try {
							writer.close();
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
						}
					}
					// 파일압축 완료 후 임시로 생성한 파일 삭제.
					if (opinionFile.exists()) {
						opinionFile.delete();
					}
				}

				logger.debug("downloading opinions ends");

				List<String> docIdlist = new ArrayList<String>();
				docIdlist.add(docID);
				// 통합 PC 저장 다운로드 이력 남기기.
				ezApprovalGService.insertTotalSaveHistory(docIdlist, userInfo, "D");
			}
		} catch (FileNotFoundException fnfe) {
			logger.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			logger.debug("ioe: {}", ioe);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		} finally {
			if (zout != null) {
				try {
					zout.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
		}
		
		logger.debug("saveTotalDoc ended.");
		
		return zipFilePath;
	}
	
	/**
	 * 전자결재G 수신처리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getReceivedDocList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getReceivedDocList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getReceivedDocList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		String receiveDocMode = request.getParameter("mFlag");
		String pageSize = request.getParameter("pageSize");
		String pageNum = request.getParameter("pageNum");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String searchQuery = request.getParameter("searchQuery");
		String searchStatus = request.getParameter("searchStatus");
		String assignChk = request.getParameter("assignChk");
		String userLang = userInfo.getLang();
		Document xmlDomSub = null;
		
		/* 2024-02-23 홍승비 - SQL Injection 제거 > 검색 쿼리를 문자열이 아닌 맵으로 전달 */
		Map<String, Object> searchQueryMap = new HashMap<String, Object>();
		
		if (searchQuery != null && searchQuery.length() > 10) {
			String tempQuery = "";
			xmlDomSub = commonUtil.convertStringToDocument(searchQuery);
			
			tempQuery = xmlDomSub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
			
			if (tempQuery.indexOf("DOCNO;") != -1) {
				searchQueryMap.put("col_where_DOCNO", xmlDomSub.getElementsByTagName("DOCNO").item(0).getTextContent());
			}
			
			if (tempQuery.indexOf("DOCTITLE;") != -1) {
				searchQueryMap.put("col_where_DOCTITLE", xmlDomSub.getElementsByTagName("DOCTITLE").item(0).getTextContent());
            }

			/* 2020-06-29 홍승비 - WRITERNAME, WRITERDEPTNAME칼럼은 2까지만 존재함(일본어인 경우 3이 전달되는 오류 수정) */
            if (commonUtil.getPrimaryData(userLang, userInfo.getTenantId()).equals("2")) {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                	searchQueryMap.put("col_where_WRITERNAME2", xmlDomSub.getElementsByTagName("WRITERNAME").item(0).getTextContent());
                }
            } else {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                	searchQueryMap.put("col_where_WRITERNAME", xmlDomSub.getElementsByTagName("WRITERNAME").item(0).getTextContent());
                }
            }

            if (commonUtil.getPrimaryData(userLang, userInfo.getTenantId()).equals("2")) {
                if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                	searchQueryMap.put("col_where_WRITERDEPTNAME2", xmlDomSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent());
                }
            } else {
                if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                	searchQueryMap.put("col_where_WRITERDEPTNAME", xmlDomSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent());
                }
            }
            
            /* 2024-02-29 홍승비 - 부서수신함의 문서 표출 시 UTC 날짜 조건을 사용하도록 수정 */
            if (tempQuery.indexOf("APRSTARTDATE;") != -1) { // 간단검색 시 사용
            	searchQueryMap.put("col_where_PROCESSDATE_START1", commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), true));
            }
            
            if (tempQuery.indexOf("APRENDDATE;") != -1) {
            	searchQueryMap.put("col_where_PROCESSDATE_END1", commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true));
            }
            
            if (tempQuery.indexOf("FORMID;") != -1) {
            	searchQueryMap.put("col_where_FORMID", xmlDomSub.getElementsByTagName("FORMID").item(0).getTextContent());
            }

            if (tempQuery.indexOf("FORMNAME;") != -1) {
            	searchQueryMap.put("col_where_FORMNAME", xmlDomSub.getElementsByTagName("FORMNAME").item(0).getTextContent());
            }
            
            // 부서수신함, 대외수신함, 대외발송함은 APR type으로 검색하므로 KEND, CEND 조건의 완료 테이블에는 접근하지 않는다. CAPR(ITEMCODE) 조건은 문서검색창에서 사용되지 않으므로 제거함.
            if (tempQuery.indexOf("KAPR;") != -1) {
            	searchQueryMap.put("col_where_KEYWORD", xmlDomSub.getElementsByTagName("KEYWORD").item(0).getTextContent());
            }
            
            if (tempQuery.indexOf("URGENTAPPROVAL;") != -1) {
            	searchQueryMap.put("col_where_URGENTAPPROVAL", xmlDomSub.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent());
            }
            
            // 상단 APRSTARTDATE, APRENDDATE 분기에서도 동일한 테이블과 칼럼에 접근하는 쿼리가 존재하나, 둘 다 사용되는 쿼리이므로 전부 유지
            if (tempQuery.indexOf("RECVSTARTDATE;") != -1) { // 상세검색 시 사용
            	searchQueryMap.put("col_where_PROCESSDATE_START2", commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("RECVSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), true));
            }
            
			/* 2024-02-29 홍승비 - 부서수신함의 문서 표출 시 UTC 기간 조건을 사용하도록 수정, 종료일시 조건을 23:59:59로 통일 */
            if (tempQuery.indexOf("RECVENDDATE;") != -1) {
            	searchQueryMap.put("col_where_PROCESSDATE_END2", commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("RECVENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true));
            }
            
            if (tempQuery.indexOf("SENTDEPTNAME;") != -1) {
            	searchQueryMap.put("col_where_SENTDEPTNAME", xmlDomSub.getElementsByTagName("SENTDEPTNAME").item(0).getTextContent());
            }
            
            if (tempQuery.indexOf("RECEIVEDDEPTNAME;") != -1) {
            	searchQueryMap.put("col_where_RECEIVEDDEPTNAME", xmlDomSub.getElementsByTagName("RECEIVEDDEPTNAME").item(0).getTextContent());
            }
            
            if (searchStatus != null && !searchStatus.equals("") && !searchStatus.equals("ALL")) { // 상태 (011, 014, 012, 015)
            	searchQueryMap.put("col_where_APRSTATE", searchStatus);
            }
		}
		
		// 기존 searchQuery 문자열 대신 searchQueryMap을 사용하여 검색 조건 전달, 사용하지 않는 Document xmlDomSub 파라미터 제거
//		String result = ezApprovalGService.getReceiveDocList(userID, deptID, receiveDocMode, pageSize, pageNum, orderCell, orderOption, userInfo.getCompanyID(), userLang, searchQueryMap, userInfo.getTenantId(), userInfo.getOffset(), assignChk);
		String result = ezApprovalGService.getReceiveDocList(userID, deptID, receiveDocMode, pageSize, pageNum, orderCell, orderOption, userInfo.getCompanyID(), userLang, searchQueryMap, userInfo.getTenantId(), userInfo.getOffset(), assignChk, userInfo.getPrimary());
		
		logger.debug("getReceivedDocList ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 공람정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/gongRamDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String gongRamDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("gongRamDocInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			companyID = orgCompanyID;
		}
		
		String result = ezApprovalGService.gongRamDocInfo(docID, companyID, userInfo.getTenantId());
		
		logger.debug("gongRamDocInfo ended.");
		
		return "<RESULT>" + result + "</RESULT>";
	}
	
	/**
	 * 전자결재G 수신처 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/recevGSusin.do", method = RequestMethod.GET)
	public String recevGSusin(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("recevGSusin started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String realPath = commonUtil.getRealPath(request);
		String crossEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());
		String signImageSize = ezCommonService.getTenantConfig("SignImageSize", userInfo.getTenantId());
		String signImageType = ezCommonService.getTenantConfig("SignImageType", userInfo.getTenantId());
		String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		String docID = request.getParameter("docID");
		String orgDocID = request.getParameter("uOrgID");
		String isReDraft = request.getParameter("isReDraft");
		String draftFlag = request.getParameter("draftFlag");
		String retFlag = request.getParameter("retFlag");
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optisSplit = "";
		int isReceived = 0;
		
		if (approvalFlag.equals("S")) {
			optisSplit = ezApprovalGService.getOptionInfo("SA33", "001", userInfo, "CODE");
		} else {
			optisSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		}
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
		String sihangURL = ezApprovalGService.getOptionInfo("A36", "004", userInfo, "CODE");
		
		String dirPath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		String rtnVal = ezApprovalGService.getOrgDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		Document xmlDom = commonUtil.convertStringToDocument(rtnVal);
		
		if (xmlDom.getElementsByTagName("ORGHREF").getLength() > 0) {
			String orgDocFile = xmlDom.getElementsByTagName("ORGHREF").item(0).getTextContent();
			String docFile = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();
			
			orgDocFile = dirPath + orgDocFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			docFile = dirPath + docFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			
			String dir = docFile.substring(0, docFile.lastIndexOf(commonUtil.separator) + 1);
			EzFile file = new EzFile(commonUtil.detectPathTraversal(dir));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			EzFile newFile = new EzFile(commonUtil.detectPathTraversal(docFile));
			
			if (!newFile.exists()) {
				EzFile orgFile = new EzFile(commonUtil.detectPathTraversal(orgDocFile));
				
				// KLIB 복호화
				if (orgDocFile.endsWith("." + EzApprovalGKlibServiceImpl.ENCRYPTED_FILE_EXT)) {
					byte[] orgBytes = FileUtils.readFileToByteArray(orgFile.getFile());
					
					// EzFAL EzFileOutputStream 사용 (자동 close 호출)
					try (EzFileOutputStream fos = new EzFileOutputStream(newFile)) {
						fos.write(klibUtil.decrypt(orgBytes));
						fos.flush();
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
					}
				} else {
					EzFAL.copyFile(orgFile, newFile);
				}
			}
		}

		/* 상위부서문서함 사용 시 관련 정보 같이 전달 */
		String upperDeptCode = "";
		String upperDeptName = "";
		Map<String, String> upDeptInfo = ezApprovalGService.getUpperDeptInfo(userInfo.getDeptID(), userInfo.getTenantId());
		if (upDeptInfo.get("USEUPPERDEPTBOX") != null && upDeptInfo.get("USEUPPERDEPTBOX").equals("Y")) {
			upperDeptCode = upDeptInfo.get("upperDeptCode");
			upperDeptName = upDeptInfo.get("upperDeptName");
		}
		String allowDeptIDs = ezApprovalGService.getSameDeptBoxUseID(upperDeptCode.equals("") ? userInfo.getDeptID() : upperDeptCode, userInfo.getTenantId());

		if (docID != null && !docID.equals("")) {
			Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), (upperDeptCode.equals("") ? userInfo.getDeptID() : upperDeptCode), "REC", userInfo.getCompanyID(), userInfo.getTenantId(), "");
			
			if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
				return "main/warning";
			}
			
			// 접수된 문서인지 확인하기.
			// return 값이 1 이상이면 접수된 문서로 판단.
			isReceived = ezApprovalGService.checkReceivedDoc(docID.trim(), userInfo.getCompanyID(), userInfo.getTenantId());
		}
		
		String isNonElecRec = "";
		if (approvalFlag.equals("G")) {
			// 비전자문서 구분 값 (return >> "Y" = TRUE, "" = FALSE)
			isNonElecRec = ezApprovalGService.checkNonElecRec(orgDocID, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		
		String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
		/* 2020-03-31 홍승비 - 재기안 시 반송의견 유지여부 컨피그 추가 */
		String useRedraftOpinionKeep = ezCommonService.getTenantConfig("useRedraftOpinionKeep", userInfo.getTenantId());
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		/* 2020-11-13 홍승비 - 대용량첨부 관련 파라미터 추가 */
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
		String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String bigAttachFileMinSaveDate = ezApprovalGService.getAttachFileMinSaveDate(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String bigAttachDownloadPeriod = bigAttachFileMinSaveDate + " ~ " + EgovDateUtil.addDay(bigAttachFileMinSaveDate, Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");
		
		// 2023-05-26 조수빈 - 전자결재 첨부파일 미리보기 기능 사용 여부
		String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		
		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
			useAprFilePrvw = "1";
		} else {
			useAprFilePrvw = "0";
		}
		
		// 2024-05-23 김우철 - 헤더 숨기기 기능 사용 여부
		String useHideHeaderArea = ezCommonService.getTenantConfig("useHideHeaderArea", userInfo.getTenantId());

		// 2024-06-04 김우철 - 부서수신함 첨부, 문서첨부 기능 사용 여부
		String useReceiptDeptFileAttach = ezCommonService.getTenantConfig("useReceiptDeptFileAttach", userInfo.getTenantId());

		model.addAttribute("crossEditor", crossEditor);
		model.addAttribute("docID", docID);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("isReDraft", isReDraft);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("retFlag", retFlag);
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optIsSplit", optisSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("sihangURL", sihangURL);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("junGyulFlag", junGyulFlag);
		model.addAttribute("signImageSize", signImageSize);
		model.addAttribute("signImageType", signImageType);
		model.addAttribute("isReceived", isReceived);
		model.addAttribute("isNonElecRec", isNonElecRec);
		model.addAttribute("useReceiveDocNo", useReceiveDocNo);
		model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));
		model.addAttribute("useOpenGov", config.getProperty("config.useOpenGov"));
		model.addAttribute("useRedraftOpinionKeep", useRedraftOpinionKeep);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		model.addAttribute("isPreview", isPreview);
		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		
		model.addAttribute("useHideHeaderArea", useHideHeaderArea);
		model.addAttribute("useReceiptDeptFileAttach", useReceiptDeptFileAttach);

		model.addAttribute("upperDeptCode", upperDeptCode);
		model.addAttribute("upperDeptName", upperDeptName);
		model.addAttribute("allowDeptIDs", allowDeptIDs);

		logger.debug("recevGSusin ended.");
		
		return "ezApprovalG/apprGrecevGSusin";
	}
	
	/**
	 * 전자결재G 접수된 문서인지 확인하는 Method
	 * */
	@RequestMapping(value = "/ezApprovalG/isReceivedDoc.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String isReceivedDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("isReceivedDoc started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		
		int isReceived = ezApprovalGService.checkReceivedDoc(docID.trim(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("docID : " + docID);
		logger.debug("isReceived : " + isReceived);
		
		logger.debug("isReceivedDoc ended.");
		
		return String.valueOf(isReceived);
	}
	
	/**
	 * 전자결재G 수신처내용 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/recevEndContent.do", method = RequestMethod.GET)
	public String recevEndContent() {
		return "ezApprovalG/apprGrecevEndContent";
	}
	
	/**
	 * 전자결재G 수신처문서 정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getReceiveDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getReceiveDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getReceiveDocInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getReceivedDocInfo(userInfo, docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getReceiveDocInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 문서정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getDocData.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getDocData(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getDocData started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String flag = request.getParameter("mode");
		String data = request.getParameter("sel");
		String result = ezApprovalGService.getDocInfo(docID, flag, data, userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
		
		logger.debug("getDocData ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물선택 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/selectCabinet.do", method = RequestMethod.GET)
	public String selectCabinet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("selectCabinet started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String initFlag = request.getParameter("initFlag");
		//반송회송문서 대장등록할때 철선택 해주기 위해추가
		String docId = request.getParameter("docId");
		String hesongFlag = request.getParameter("hesongFlag");
		
		// 2023-05-23 이사라 : 시큐어코딩 문자열 비교 오류 수정
		if (StringUtils.isNotBlank(docId) && !"undefined".equalsIgnoreCase(docId)) {
			model.addAttribute("regDocId", docId);
		}
		
		if (StringUtils.isNotBlank(hesongFlag) && !"undefined".equalsIgnoreCase(hesongFlag)) {
			model.addAttribute("hesongFlag", hesongFlag);
		}
		
		model.addAttribute("initFlag", initFlag);
		model.addAttribute("userInfo", userInfo);

		/* 상위부서문서함 사용 시 관련 정보 같이 전달 */
		String upperDeptCode = "";
		Map<String, String> upDeptInfo = ezApprovalGService.getUpperDeptInfo(userInfo.getDeptID(), userInfo.getTenantId());
		if (upDeptInfo.get("USEUPPERDEPTBOX") != null && upDeptInfo.get("USEUPPERDEPTBOX").equals("Y")) {
			upperDeptCode = upDeptInfo.get("upperDeptCode");
		}
		model.addAttribute("upperDeptCode", upperDeptCode);
		
		logger.debug("selectCabinet ended.");
		
		return "ezApprovalG/apprGselectCabinet";
	}
	
	/**
	 * 전자결재G 문서상태 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getDocState.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getDocState(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getDocState started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String result = ezApprovalGService.getDocRecvState(docID, deptID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("getDocState ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 수신수락 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezReceiveAssignUI.do", method = RequestMethod.GET)
	public String ezReceiveAssignUI(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		logger.debug("ezReceiveAssignUI started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String susinAdmin = "";
		String serverName = userInfo.getServerName();
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "";
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("serverName", serverName);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("mode", mode);
		
		logger.debug("ezReceiveAssignUI ended.");
		
		return "ezApprovalG/apprGezReceiveAssignUI";
	}
	
	/**
	 * 전자결재G 수신처 지정 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setJijung.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setJijung(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("setJijung started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String receiveSN = request.getParameter("receiveSN");
		String processorID = request.getParameter("processorID");
		String processorName = request.getParameter("processorName");
		String processorJobTitle = request.getParameter("processorJobTitle");
		String receivedDeptID = request.getParameter("receivedDeptID");
		String receivedDeptName = request.getParameter("receivedDeptName");
		String docState = request.getParameter("docState");
		String processorName2 = request.getParameter("processorName2");
		String processorJobTitle2 = request.getParameter("processorJobTitle2");
		String receivedDeptName2 = request.getParameter("receivedDeptName2");
		
		String result = ezApprovalGService.setJijung(docID, receiveSN, processorID, processorName, processorJobTitle, receivedDeptID, receivedDeptName, docState, processorName2, processorJobTitle2, receivedDeptName2, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("setJijung ended.");
		
		return result;
	}
	

	//mht 문서유통 중계문서 수신에 쓰임
	@RequestMapping(value = "/ezApprovalG/recevG.do", method = RequestMethod.GET)
	public String recevG(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("recevG started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String realPath = commonUtil.getRealPath(request);
		String docID = request.getParameter("docID");
		String orgDocID = request.getParameter("uOrgID");
		String isReDraft = request.getParameter("isReDraft");
		String draftFlag = request.getParameter("draftFlag");
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		//String docNumZeroCnt = ezCommonService.getTenantConfig("docNumZeroCnt", userInfo.getTenantId());
		String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
        // 문서유통 편철시 에러수정하기 위해 추가. 2019-07-19 홍대표
		String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optisSplit = "";
		
		if (approvalFlag.equals("S")) {
			optisSplit = ezApprovalGService.getOptionInfo("SA33", "001", userInfo, "CODE");
		} else {
			optisSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		}
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
		String sihangURL = ezApprovalGService.getOptionInfo("A36", "004", userInfo, "CODE");

		String dirYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());		
		String dirPath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String approvalRoot = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String rtnVal = ezApprovalGService.getOrgDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());

		String viewDocFlag = request.getParameter("viewDoc") != null ? request.getParameter("viewDoc") : "";
		String orgCompanyID = request.getParameter("orgCompanyID");

		String susinAdmin = "";
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		Document xmlDom = commonUtil.convertStringToDocument(rtnVal);
		
        String isNonElecRec = "";
        if (approvalFlag.equals("G")) {
                // 비전자문서 구분 값 (return >> "Y" = TRUE, "" = FALSE)
                isNonElecRec = ezApprovalGService.checkNonElecRec(orgDocID, userInfo.getCompanyID(), userInfo.getTenantId());
        }

		
		if (xmlDom.getElementsByTagName("ORGHREF").getLength() > 0) {
			String orgDocFile = xmlDom.getElementsByTagName("ORGHREF").item(0).getTextContent();
			String docFile = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();
			
			orgDocFile = dirPath + orgDocFile.replace(commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			docFile = dirPath + docFile.replace(commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			
			String dir = docFile.substring(0, docFile.lastIndexOf(commonUtil.separator) + 1);
			EzFile file = new EzFile(commonUtil.detectPathTraversal(dir));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			EzFile newFile = new EzFile(commonUtil.detectPathTraversal(docFile));
			
			if (!newFile.exists()) {
				EzFile orgFile = new EzFile(commonUtil.detectPathTraversal(orgDocFile));
				
				EzFAL.copyFile(orgFile, newFile);
			}
		}

		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}

//		if (docID != null && !docID.equals("")) {
//			Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), "REC", userInfo.getCompanyID(), userInfo.getTenantId(), "");
//			
//			if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
//				return "main/warning";
//			}
//			if (!doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals(userInfo.getId()) && !doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("NULL")) {
//				if (doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("") && (!doc.getElementsByTagName("RECEIVEDDEPTID").item(0).getTextContent().equals(userInfo.getDeptID()) || userInfo.getRollInfo().indexOf("a=1") == -1)) {
//					return "main/warning";
//				}
//				if (!doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("")) {
//					return "main/warning";
//				}
//			}
//		}
		
		/* 2020-03-31 홍승비 - 재기안 시 반송의견 유지여부 컨피그 추가 */
		String useRedraftOpinionKeep = ezCommonService.getTenantConfig("useRedraftOpinionKeep", userInfo.getTenantId());
		
		model.addAttribute("docID", docID);
		model.addAttribute("dirYear", dirYear);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("isReDraft", isReDraft);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optIsSplit", optisSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("sihangURL", sihangURL);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("junGyulFlag", junGyulFlag);
		model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));
		model.addAttribute("approvalROOT", approvalRoot);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("useReceiveDocNo", useReceiveDocNo);
		model.addAttribute("isNonElecRec", isNonElecRec);
		model.addAttribute("useRedraftOpinionKeep", useRedraftOpinionKeep);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("isPreview", isPreview);

		model.addAttribute("viewDocFlag", viewDocFlag); // 문서보기 Flag
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("useExternalMailServer", useExternalMailServer);

		/* 상위부서문서함 사용 시 관련 정보 같이 전달 */
		String upperDeptCode = "";
		Map<String, String> upDeptInfo = ezApprovalGService.getUpperDeptInfo(userInfo.getDeptID(), userInfo.getTenantId());
		if (upDeptInfo.get("USEUPPERDEPTBOX") != null && upDeptInfo.get("USEUPPERDEPTBOX").equals("Y")) {
			upperDeptCode = upDeptInfo.get("upperDeptCode");
		}
		model.addAttribute("upperDeptCode", upperDeptCode);
		String allowDeptIDs = ezApprovalGService.getSameDeptBoxUseID(upperDeptCode.equals("") ? userInfo.getDeptID() : upperDeptCode, userInfo.getTenantId());
		model.addAttribute("allowDeptIDs", allowDeptIDs);

		logger.debug("recevG ended.");
		
		return "ezApprovalG/apprGrecevG";
	}
	
	/**
	 * 전자결재G 결재라인 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprLine.do", method = RequestMethod.GET)
	public String aprLine(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("aprLine started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String userEmail = userInfo.getEmail();
		String susinAdmin = "";
		String serverName = userInfo.getServerName();
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String optGamsabu = ezApprovalGService.getOptionInfo("A40", "001", userInfo, "CODE");
		String aprTypeXML = ezApprovalGService.getAprType(approvalFlag, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("aprTypeXML", aprTypeXML);
		model.addAttribute("optGamsabu", optGamsabu);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("userEmail", userEmail);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("serverName", serverName);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("aprLine ended.");
		
		return "ezApprovalG/apprGaprLine";
	}
	
	/**
	 * 전자결재G 수신처 업데이트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setSusinUpdateDocID.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setSusinUpdateDocID(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("setSusinUpdateDocID started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String orgDocID = request.getParameter("orgDocID");
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String result = ezApprovalGService.updateSusinDocInfo(orgDocID, docID, deptID, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("setSusinUpdateDocID ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 수신처 얼러트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezReceiveDistributeUI.do", method = RequestMethod.GET)
	public String ezReceiveDistributeUI(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("ezReceiveDistributeUI started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		//2015-06-26 표준모듈:수정(자기부서 배부 가능여부)
        String USE_SELFDISTRIBUTE = "N";
		String susinAdmin = "";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String mode = request.getParameter("mode");
//		String docID = request.getParameter("docID");
//		
//		String strXML = ezApprovalGService.getDocInfo(docID, "APR", "formID", userInfo.getCompanyID());
//		Document doc = commonUtil.convertStringToDocument(strXML);
//		String formID = "";
//		
//		if (doc.getElementsByTagName("FORMID").item(0).getTextContent() != null) {
//			formID = doc.getElementsByTagName("FORMID").item(0).getTextContent();
//		}
//		
//		if (formID == null || formID.equals("")) {
//			strXML = ezApprovalGService.getDocInfo(docID, "", "formID", userInfo.getCompanyID());
//			doc = commonUtil.convertStringToDocument(strXML);
//			formID = doc.getElementsByTagName("FORMID").item(0).getTextContent();
//		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("USE_SELFDISTRIBUTE", USE_SELFDISTRIBUTE);
		model.addAttribute("mode", mode);
		model.addAttribute("approvalFlag", approvalFlag);

		logger.debug("ezReceiveDistributeUI ended.");
		
		return "ezApprovalG/apprGezReceiveDistributeUI";
	}

	/**
	 * 전자결재G 문서보기 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDocView.do", method = RequestMethod.GET)
	public String aprDocView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("aprDocView started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		 
		String crossEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String signImageType = ezCommonService.getTenantConfig("signImageType", userInfo.getTenantId());
		String forceCallBackYN = ezCommonService.getTenantConfig("forceCallBack_YN", userInfo.getTenantId());
		
		//baonk 추가 2018-08-08
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
		if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("apprv", userInfo);
		}
		
		String susinAdmin = "";
		String hasOpinionYN = "";
		String realPath = commonUtil.getRealPath(request);
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String opinionFlag = request.getParameter("opinionFlag");
		String docState = request.getParameter("docState");
		String listSusin = request.getParameter("listSusin");
		String orgDocID = request.getParameter("oDoc");
		String isOpinion = request.getParameter("isOpinion");
		String listType = request.getParameter("listType");
		String mode = "VIE";
		String callBackType = request.getParameter("CallBackType");
		String ext = request.getParameter("ext");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String pageType = request.getParameter("pageType");
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		String formID = "";
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		if (listType.equals("1") || listType.equals("2") || listType.equals("3") || listType.equals("11")) {
			mode = "VIE";
		} else if (listType.equals("4") || listType.equals("6") || listType.equals("10") || listType.equals("99")) {
			mode = "REC";
		} else if (listType.equals("21")) {
			mode = "TMP";
		}
		
		String strXML = ezApprovalGService.getDocInfo(docID, "APR", "hasOpinionYN", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
		Document resultXML = commonUtil.convertStringToDocument(strXML);
		
		if (resultXML.getElementsByTagName("HASOPINIONYN").item(0) != null) {
			if (!resultXML.getElementsByTagName("HASOPINIONYN").item(0).getTextContent().trim().equals("")) {
				hasOpinionYN = resultXML.getElementsByTagName("HASOPINIONYN").item(0).getTextContent();
			}
		}
		
		String dirPath = realPath +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String rtnVal = ezApprovalGService.getOrgDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		Document xmlDom = commonUtil.convertStringToDocument(rtnVal);
		
		if (xmlDom.getElementsByTagName("ORGHREF").getLength() > 0) {
			String orgDocFile = xmlDom.getElementsByTagName("ORGHREF").item(0).getTextContent();
			String docFile = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();
			
			orgDocFile = dirPath + orgDocFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator, "");
			docFile = dirPath + docFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator, "");
			
			String dir = docFile.substring(0, docFile.lastIndexOf(commonUtil.separator) + 1);
			EzFile file = new EzFile(commonUtil.detectPathTraversal(dir));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			EzFile newFile = new EzFile(commonUtil.detectPathTraversal(docFile));
			
			if (!newFile.exists()) {
				EzFile orgFile = new EzFile(commonUtil.detectPathTraversal(orgDocFile));
				
				// KLIB 복호화
				if (orgDocFile.endsWith("." + EzApprovalGKlibServiceImpl.ENCRYPTED_FILE_EXT)) {
/*					byte[] orgBytes = commonUtil.readBytesFromFile(orgFile.toPath());
					FileUtils.writeByteArrayToFile(newFile, klibUtil.decrypt(orgBytes));*/
					
					byte[] orgBytes = FileUtils.readFileToByteArray(orgFile.getFile());
					
					// EzFAL EzFileOutputStream 사용 (자동 close 호출)
					try (EzFileOutputStream fos = new EzFileOutputStream(newFile)) {
						fos.write(klibUtil.decrypt(orgBytes));
						fos.flush();
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
					}
				} else {
					EzFAL.copyFile(orgFile, newFile);
				}
			}
		}
		
		if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("q=1")) {
			if (docID != null && !docID.equals("")) {
				String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1", userInfo.getTenantId(), userInfo.getOffset());
				String[] proxyUserArray = proxyUser.split(",");
				boolean checkPermission = true;
				
				if (proxyUserArray.length > 1) {
					String docList = ezApprovalGService.getAprLineInfoDB(docID, "1", "", "", userInfo.getCompanyID(), userInfo.getTenantId(), "", "", mode, "");
					
					Document docXML = commonUtil.convertStringToDocument(docList);
					
					for (int k = 0; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
						if (docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("002") || docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("005") || docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("000")) {
							String curAprUserID = docXML.getElementsByTagName("ORGUSERID").item(k).getTextContent();
							
							for (int j = 0; j < proxyUserArray.length; j++) {
								if (curAprUserID.equals(proxyUserArray[j].trim().substring(1, proxyUserArray[j].trim().length() - 1))) {
									checkPermission = false;
									break;
								}
							}
						}
					}
				}
				
				if (checkPermission) {
					Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), mode, userInfo.getCompanyID(), userInfo.getTenantId(), docState);
					
					if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
						model.addAttribute("chk", "no");
						return "main/warning";
					}
					if (!doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals(userInfo.getId()) && !doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("NULL")) {
						if (doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("") && (!doc.getElementsByTagName("RECEIVEDDEPTID").item(0).getTextContent().equals(userInfo.getDeptID()) || userInfo.getRollInfo().indexOf("a=1") == -1)) {
							return "main/warning";
						}
						if (!doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("")) {
							return "main/warning";
						}
					}
				}
			}
		} else {
			if (pageType != null && pageType.equals("admin")) {
				//do nothing..
			} else {
				Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), mode, userInfo.getCompanyID(), userInfo.getTenantId(), docState);
				
				if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
					model.addAttribute("chk", "no");
					return "main/warning";
				}
			}
		}
		
		/* 2020-11-13 홍승비 - 대용량첨부 관련 파라미터 추가 */
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
		String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String bigAttachFileMinSaveDate = ezApprovalGService.getAttachFileMinSaveDate(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String bigAttachDownloadPeriod = bigAttachFileMinSaveDate + " ~ " + EgovDateUtil.addDay(bigAttachFileMinSaveDate, Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");
		
		// 2023-05-26 조수빈 - 전자결재 첨부파일 미리보기 기능 사용 여부
		String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		
		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
			useAprFilePrvw = "1";
		} else {
			useAprFilePrvw = "0";
		}
		
		// 2024-05-23 김우철 - 헤더 숨기기 기능 사용 여부
		String useHideHeaderArea = ezCommonService.getTenantConfig("useHideHeaderArea", userInfo.getTenantId());

		// 2024-06-12 조소정 - 공람할문서, 공람완료문서 게시판 게시, 재사용 기능 추가
		String formUrl = "";
		String formDocType = "";
		String formVersion = "";
		String docAprEnd = "";
		
		String reUseInfo = ezApprovalGService.getDocInfoS(orgDocID, docAprEnd, userInfo, userInfo.getCompanyID(), userInfo.getTenantId());
		Document resultXML2 = commonUtil.convertStringToDocument(reUseInfo);
		
		if (resultXML2.getElementsByTagName("FORMFILELOCATION").getLength() > 0) {
			formUrl = resultXML2.getElementsByTagName("FORMFILELOCATION").item(0).getTextContent().trim();
		}
		
		if (resultXML2.getElementsByTagName("FORMDOCTYPE").getLength() > 0) {
			formDocType = resultXML2.getElementsByTagName("FORMDOCTYPE").item(0).getTextContent().trim(); 
		}
		
		if (resultXML2.getElementsByTagName("FORMVERSION").getLength() > 0) {
			formVersion = resultXML2.getElementsByTagName("FORMVERSION").item(0).getTextContent().trim(); 
		}

		if (resultXML2.getElementsByTagName("FORMID").getLength() > 0) {
			formID = resultXML2.getElementsByTagName("FORMID").item(0).getTextContent().trim();
		}

		model.addAttribute("docID", docID);
		model.addAttribute("crossEditor", crossEditor);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("hasOpinionYN", hasOpinionYN);
		model.addAttribute("docHref", docHref);
		model.addAttribute("opinionFlag", opinionFlag);
		model.addAttribute("docState", docState);
		model.addAttribute("listSusin", listSusin);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("isOpinion", isOpinion);
		model.addAttribute("listType", listType);
		model.addAttribute("mode", mode);
		model.addAttribute("callBackType", callBackType);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("signImageType", signImageType);
		model.addAttribute("forceCallBackYN", forceCallBackYN);
		model.addAttribute("useCabinet", use_cabinet); // 캐비넷 추가 baonk 2018-08-08
		model.addAttribute("ext", ext);
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("useBoard", ezCommonService.getTenantConfig("useBoard", userInfo.getTenantId()));
		model.addAttribute("formID", formID);
		model.addAttribute("formUrl", formUrl);
		model.addAttribute("formDocType", formDocType);
		model.addAttribute("formVersion", formVersion);
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		model.addAttribute("isPreview", isPreview);

		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		
		model.addAttribute("useHideHeaderArea", useHideHeaderArea);

		logger.debug("aprDocView ended.");
		
		return "ezApprovalG/apprGaprDocView";
	}
	
	/**
	 * 전자결재G 문서보기내용 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDocViewContent.do", method = RequestMethod.GET)
	public String aprDocViewContent() throws Exception{
		logger.debug("aprDocViewContent started.");
		logger.debug("aprDocViewContent ended.");
		return "ezApprovalG/apprGaprDocViewContent";
	}
	
	/**
	 * 전자결재G 모두결재 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezAprAllAlert.do", method = RequestMethod.GET)
	public String ezAprAllAlert() throws Exception{
		logger.debug("ezAprAllAlert started.");
		logger.debug("ezAprAllAlert ended.");
		return "ezApprovalG/apprGezAprAllAlert";
	}
	
	/**
	 * 전자결재G 모두결재 다음문서 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getNextDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getNextDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getNextDocInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String userDeptID = request.getParameter("userDeptID");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String isIEFlag = request.getParameter("isIEFlag");
		String result = ezApprovalGService.getNextDocInfo(docID, userID, userDeptID, isIEFlag, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getNextDocInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 반송,회수문서 삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/delDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String delDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("delDocInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String mode = request.getParameter("field");
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals("undefined") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = ezApprovalGService.deleteDocInfo(docID, mode, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("delDocInfo ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 결재리스트 검색 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setSearchInfo.do", method = RequestMethod.GET)
	public String setSearchInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setSearchInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String type = request.getParameter("type");
		String searchType = request.getParameter("searchType");
		if(searchType != null && (searchType.equals("4") || searchType.equals("97"))){
			searchType = "recDept";
		}
		String susinAdmin = "";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String monthEndDay = EgovDateUtil.getTodayTime().substring(9, 10);;
		String initDate = EgovDateUtil.getTodayTime().substring(0, 10);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("type", type);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("monthEndDay", monthEndDay);
		model.addAttribute("initDate", initDate);
		model.addAttribute("searchType", searchType);
		
		logger.debug("setSearchInfo ended");
		
		return "ezApprovalG/apprGsetSearchInfo";
	}

	/**
	 * 전자결재G 대결정보 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/secondApprovalInfo.do", method = RequestMethod.GET)
	public String secondApprovalInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("secondApprovalInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		List<ApprGSecondApprVO> strResult = ezApprovalGService.getSecondApprovalInfo(userInfo.getCompanyID(), userInfo.getTenantId());
		
		model.addAttribute("strResult", strResult);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("secondApprovalInfo ended");
		
		return "ezApprovalG/apprGsecondApprovalInfo";
	}
	
	/**
	 * 전자결재G 철생성 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/createCabinet.do", method = RequestMethod.GET)
	public String createCabinet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("createCabinet started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);

		logger.debug("createCabinet ended");
		
		return "ezApprovalG/apprGcreateCabinet";
	}
	
	/**
	 * 전자결재G 특수목록위치 추가 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/insSpecialList.do", method = RequestMethod.GET)
	public String insSpecialList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,Model model) throws Exception{
		logger.debug("insSpecialList started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("insSpecialList ended");
		
		return "ezApprovalG/apprGinsSpecialList";
	}

	/**
	 * 전자결재G 철생성 등록 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/registerCabinet.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String registerCabinet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		logger.debug("registerCabinet started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		logger.debug("xmlPara = " + xmlPara);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.registerCabinet(xmlDom, userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("registerCabinet ended");
		return result;
	}

	/**
	 * 전자결재G 철생성 권호수등록 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/addVolume.do", method = RequestMethod.GET)
	public String addVolume(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("addVolume started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);

		logger.debug("addVolume ended");
		
		return "ezApprovalG/apprGaddVolume";
	}

	/**
	 * 전자결재G 철생성 권호수등록 새호수 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getNewVolNo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getNewVolNo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getNewVolNo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String cabClassNO = request.getParameter("cabClassNO");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGService.getNewVolumeNo(cabClassNO, companyID, userInfo.getTenantId());
		
		logger.debug("getNewVolNo ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 철생성 권호수등록 저장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/addNewVolume.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String addNewVolume(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("addNewVolume started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String cabClassNO = request.getParameter("cabClassNO");
		String companyID = request.getParameter("companyID");
		String newVolNO = request.getParameter("newVolNO");
		String result = ezApprovalGService.addNewVolume(cabClassNO, newVolNO, companyID, userInfo.getTenantId());
		
		logger.debug("addNewVolume ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 검색 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/searchCabinet.do", method = RequestMethod.GET)
	public String searchCabinet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("searchCabinet started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("searchCabinet ended");
		
		return "ezApprovalG/apprGsearchCabinet";
	}
	
	/**
	 * 전자결재G 기록물철 검색 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getCabinetSearch.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getCabinetSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,HttpServletRequest request) throws Exception{
		logger.debug("getCabinetSearch started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		String processDeptCode = request.getParameter("processDeptCode");
		String productionYear = request.getParameter("productionYear");
		String searchKeyword = request.getParameter("searchKeyword");
		String flag = request.getParameter("flag");
		String langType = request.getParameter("langType");
		
		String result = ezApprovalGService.getFindSimpleCabinetList(processDeptCode, productionYear, searchKeyword, flag, companyID, langType, userInfo.getTenantId());
		
		logger.debug("getCabinetSearch ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 검색 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getCabinetSearchAll.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getCabinetSearchAll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getCabinetSearchAll started.");
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String companyID = request.getParameter("companyID");
		String processDeptCode = request.getParameter("processDeptCode");
		String productionYear = request.getParameter("productionYear");
		String searchKeyword = request.getParameter("searchKeyword");
		String flag = request.getParameter("flag");
		String langType = request.getParameter("langType");
		
		String result = ezApprovalGService.getFindSimpleCabinetListAll(processDeptCode, productionYear, searchKeyword, flag, companyID, langType, userInfo.getTenantId());
		
		logger.debug("getCabinetSearchAll ended.");

		return result;
	}
	
	/**
	 * 전자결재G 접수 배부 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/setBebu.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setBebu(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		logger.debug("setBebu started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String realPath = commonUtil.getRealPath(request);
		String dirPath = realPath +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = ezApprovalGService.setBebu(xmlDom, dirPath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo, "");
		
		logger.debug("setBebu ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 접수 재배부 요청 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/setReBebu.do", produces = "text/plain;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setReBebu(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("setReBebu started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		userInfo.setRealPath(commonUtil.getRealPath(request));
		
		String docID = request.getParameter("docID");
		String receiveSN = request.getParameter("receiveSN");
		String deptID = request.getParameter("deptID");
		
		String result = ezApprovalGService.setReBebu(docID, receiveSN, deptID, userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLang());
		
		logger.debug("setReBebu ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 접수 회송 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/setHeSongDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setHeSongDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("setHeSongDocInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String realPath = commonUtil.getRealPath(request);
		String dirPath = realPath +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String docID = request.getParameter("docID");
		String receiveSN = request.getParameter("receiveSN");
		String deptID = request.getParameter("deptID");
		String docState = request.getParameter("docState");
		String userID = request.getParameter("userID");
		String userName = request.getParameter("userName");
		String userName2 = request.getParameter("userName2");
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		if (approvalFlag.equals("S")) {
			String rtnVal = ezApprovalGService.getOrgDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());
			
			Document xmlDom = commonUtil.convertStringToDocument(rtnVal);
			
			if (xmlDom.getElementsByTagName("ORGHREF").getLength() > 0) {
				String orgDocFile = xmlDom.getElementsByTagName("ORGHREF").item(0).getTextContent();
				String docFile = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();
				
				orgDocFile = dirPath + orgDocFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
				docFile = dirPath + docFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
				
				String dir = docFile.substring(0, docFile.lastIndexOf(commonUtil.separator) + 1);
				EzFile file = new EzFile(commonUtil.detectPathTraversal(dir));
				
				if (!file.exists()) {
					file.mkdirs();
				}
				
				EzFile newFile = new EzFile(commonUtil.detectPathTraversal(docFile));
				
				if (!newFile.exists()) {
					EzFile orgFile = new EzFile(commonUtil.detectPathTraversal(orgDocFile));
					
					EzFAL.copyFile(orgFile, newFile);
				}
			}
		}
		
		String result = ezApprovalGService.doSusinHesong(docID, receiveSN, deptID, docState, userID, userName, userName2, dirPath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("setHeSongDocInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 일괄결재 호출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/doApprovAllselect.do", method = RequestMethod.POST)
	public String doApprovAllselect(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("doApprovAllselect started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		StringBuilder sbStr = new StringBuilder();
		int cnt = 0;	
		Document xmlDom = commonUtil.convertStringToDocument(request.getParameter("APPXML"));
		
		String useAdditionalRole = ezCommonService.getTenantConfig("USE_AdditionalROle", userInfo.getTenantId());
		String listType = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
//		String docType = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String userID = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		String deptID = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
		String pageSize = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
		String pageNum = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent();
		String companyID = xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent();
		String orderCell = xmlDom.getDocumentElement().getChildNodes().item(7).getTextContent();
		String orderOption = xmlDom.getDocumentElement().getChildNodes().item(8).getTextContent();
		String searchQuery = "";
		String approvalFlag = xmlDom.getDocumentElement().getChildNodes().item(10).getTextContent();
		String userLang = userInfo.getLang();
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String viewCompany = ezCommonService.getTenantConfig("viewCompany", userInfo.getTenantId()); //companyID 관련 tenant_config 추가 [return ::> 1 = 회사 보임(YES), 0 = 회사 가림(NO)]
		String searchCompanyID = xmlDom.getDocumentElement().getChildNodes().item(11).getTextContent();
		
		Map<String, Object> searchMap = new HashMap<>();
		Document xmlDomSub = null;
		//<SEARCHQUERy> > 10인 경우	
		if (xmlDom.getDocumentElement().getChildNodes().item(9).getTextContent().length() > 10) {
			String tempQuery = "";
			String returnQuery = "(1 = 1) ";
			xmlDomSub = commonUtil.convertStringToDocument(xmlDom.getDocumentElement().getChildNodes().item(9).getTextContent());
			
			tempQuery = xmlDomSub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
			
			if (tempQuery.indexOf("DOCNO;") != -1)
            {
                returnQuery += " AND DOCNO LIKE '%" + xmlDomSub.getElementsByTagName("DOCNO").item(0).getTextContent() + "%' ";
            }
            if (tempQuery.indexOf("DOCTITLE;") != -1)
            {
                returnQuery += " AND DocTitle LIKE '%" + xmlDomSub.getElementsByTagName("DOCTITLE").item(0).getTextContent() + "%' ";
            }

            //2012.05.23 작성자언어설정
            if (commonUtil.getPrimaryData(userLang, userInfo.getTenantId()).equals("2")) {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                    returnQuery += " AND WRITERNAME" + userLang + " LIKE '%" + xmlDomSub.getElementsByTagName("WRITERNAME").item(0).getTextContent() + "%' ";
                }
            } else {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                    returnQuery += " AND WRITERNAME LIKE '%" + xmlDomSub.getElementsByTagName("WRITERNAME").item(0).getTextContent() + "%' ";
                }
            }

            //2012.05.23 부서언어설정
            if (commonUtil.getPrimaryData(userLang, userInfo.getTenantId()).equals("2")) {
                if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                    returnQuery += " AND WriterDeptName" + userLang + " LIKE '%" + xmlDomSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent() + "%' ";
                }
            } else {
                if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                    returnQuery += " AND WriterDeptName LIKE '%" + xmlDomSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent() + "%' ";
                }
            }

            // STARTDATE -> 기안일자
            if (tempQuery.indexOf("APRSTARTDATE;") != -1) {
            	if (!dbType.equals("mysql")) {
            		returnQuery += " AND STARTDATE >= TO_DATE('" + commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), false)+"','YYYY-MM-DD HH24:MI:SS') ";
            	} else {
            		returnQuery += " AND STARTDATE >= STR_TO_DATE('" + commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), false)+"', '%Y-%m-%d %H:%i:%s') ";
            	}
            }
            if (tempQuery.indexOf("APRENDDATE;") != -1) {
            	if (!dbType.equals("mysql")) {
            		returnQuery += " AND STARTDATE <=  TO_DATE('" + commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), false)+"','YYYY-MM-DD HH24:MI:SS') ";
            	} else {
            		returnQuery += " AND STARTDATE <=  STR_TO_DATE('" + commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), false)+"','%Y-%m-%d %H:%i:%s') ";
            	}
            }
            // FormID -> 양식아이디
            if (tempQuery.indexOf("FORMID;") != -1) {
                returnQuery += " AND FormID = '" + xmlDomSub.getElementsByTagName("FORMID").item(0).getTextContent() + "' ";
            }
            if (tempQuery.indexOf("KAPR;") != -1) {
                returnQuery += " AND keyword LIKE '%" + xmlDomSub.getElementsByTagName("KEYWORD").item(0).getTextContent() + "%' ";
            }
            if (tempQuery.indexOf("KEND;") != -1) {
                returnQuery += " AND TBL_EXPAPRDOCINFO.keyword LIKE '%" + xmlDomSub.getElementsByTagName("KEYWORD").item(0).getTextContent() + "%' ";
            }
            // itemcode -> 분류코드
            if (tempQuery.indexOf("CAPR;") != -1) {
                returnQuery += " AND TBL_EXPENDAPRDOCINFO.itemcode = '" + xmlDomSub.getElementsByTagName("itemCODE").item(0).getTextContent() + "' ";
            }
            if (tempQuery.indexOf("CEND;") != -1) {
                returnQuery += " AND TBL_EXPAPRDOCINFO.itemcode = '" + xmlDomSub.getElementsByTagName("itemCODE").item(0).getTextContent() + "' ";
            }
            // URGENTAPPROVAL -> 긴급결재 여부
            if (tempQuery.indexOf("URGENTAPPROVAL;") != -1) {
                returnQuery += " AND URGENTAPPROVAL = '" + xmlDomSub.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent() + "' ";
            }
            if (searchCompanyID != null && !searchCompanyID.equals("")) {
            	returnQuery += " AND COMPANYID = '" + searchCompanyID + "' ";
            }
            returnQuery += " AND TENANT_ID = " + userInfo.getTenantId() ; 
            searchQuery = returnQuery;         
		}
		
		String result = ezApprovalGService.aprDocList(listType, userID, deptID, pageSize, pageNum, orderCell, orderOption, companyID, userInfo.getLang(), searchQuery, xmlDomSub, userInfo.getTenantId(), userInfo.getOffset(), searchMap);
		
		Document xmlResult = commonUtil.convertStringToDocument(result);
		NodeList docListNode = xmlResult.getElementsByTagName("ROW");
		
		if (docListNode != null) {
			String strDocState = "";
			String strAprState = "";
			String aprType_aprState = "";
			String aprDocUserID = "";
			String orgCompanyID = "";
			String aprMemberSN = "";
			
			for (int k = 0; k < docListNode.getLength(); k++) {
				strDocState = docListNode.item(k).getChildNodes().item(0).getChildNodes().item(15).getTextContent();
				strAprState = docListNode.item(k).getChildNodes().item(0).getChildNodes().item(13).getTextContent();
				aprDocUserID = docListNode.item(k).getChildNodes().item(0).getChildNodes().item(4).getTextContent();
				
				if (docListNode.item(k).getChildNodes().item(0) instanceof Element) {
					Element rowElement = (Element) docListNode.item(k).getChildNodes().item(0);
					
					aprMemberSN = rowElement.getElementsByTagName("APRMEMBERSN").item(0).getTextContent();
					orgCompanyID = rowElement.getElementsByTagName("orgCompanyID").item(0).getTextContent();
				}
				
				/* 2018-04-27 천성준 - 부재자 결재문서는 일괄결재에서 제외시킨다 */
				if (!aprDocUserID.equals(userID)) {
					docListNode.item(k).removeChild(docListNode.item(k).getFirstChild());
				} else {
					// docState : 공람, aprState : 대기, aprState : 보류
					if (strDocState.equals("015") || (!strAprState.equals("002") && !strAprState.equals("005"))) {
						docListNode.item(k).removeChild(docListNode.item(k).getFirstChild());
					} else {
						String href = docListNode.item(k).getChildNodes().item(0).getChildNodes().item(3).getTextContent();
	
						if (!docListNode.item(k).getChildNodes().item(0).getChildNodes().item(7).getTextContent().equals(userInfo.getDeptID()) && useAdditionalRole.equals("YES")) {
							docListNode.item(k).removeChild(docListNode.item(k).getFirstChild());
						} else {
	  						aprType_aprState = ezApprovalGService.getAprType_AprState(docListNode.item(k).getChildNodes().item(0).getChildNodes().item(1).getTextContent(), docListNode.item(k).getChildNodes().item(0).getChildNodes().item(4).getTextContent(), strDocState, orgCompanyID, userInfo.getTenantId());
							
							String mhtOrHwp = "MHT";
							
							if (href.length() > 0) {
								if (href.substring(href.length() - 4).toUpperCase().equals(".HWP")) {
									mhtOrHwp = "HWP";
								}
							}
							// aprType -> 001(결재), 019(검토), 004(전결), 007(참조)
							// 결재, 검토, 전결, 참조 제외 모두 제거
							if (!aprType_aprState.split("/")[0].equals("001") && !aprType_aprState.split("/")[0].equals("019") && !aprType_aprState.split("/")[0].equals("004") && !aprType_aprState.split("/")[0].equals("007")) {
								docListNode.item(k).removeChild(docListNode.item(k).getFirstChild());
							} else {
								cnt++;
								
							    sbStr.append("<tr>");
	                            sbStr.append("<TD style='padding:0;background-color:White' align='center'><input type='checkbox' name='chk' id='chk' orgCompanyID="+orgCompanyID+" value = \""+ docListNode.item(k).getChildNodes().item(0).getChildNodes().item(1).getTextContent() + "|" + docListNode.item(k).getChildNodes().item(0).getChildNodes().item(4).getTextContent() + "|" + docListNode.item(k).getChildNodes().item(0).getChildNodes().item(20).getTextContent() + "|" + mhtOrHwp + "|" + strDocState + "|" + aprMemberSN + "\")'></td>");
	                            //sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(xmlResult.getElementsByTagName("DOCTITLE").item(k).getTextContent()) + "</TD>");
	                            //sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(xmlResult.getElementsByTagName("WRITERDEPTNAME").item(k).getTextContent()) + "</TD>");
	                            //sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(xmlResult.getElementsByTagName("WRITERNAME").item(k).getTextContent()) + "</TD>");
	                            //sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(xmlResult.getElementsByTagName("STARTDATE").item(k).getTextContent()) + "</TD>");
	                            
	                            if (viewCompany.equals("1")) {
		                            sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(docListNode.item(k).getChildNodes().item(0).getChildNodes().item(0).getTextContent()) + "</TD>");
		                            sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(docListNode.item(k).getChildNodes().item(1).getChildNodes().item(0).getTextContent()) + "</TD>");
		                            sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(docListNode.item(k).getChildNodes().item(2).getChildNodes().item(0).getTextContent()) + "</TD>");
		                            sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(docListNode.item(k).getChildNodes().item(3).getChildNodes().item(0).getTextContent()) + "</TD>");
		                            sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(docListNode.item(k).getChildNodes().item(4).getChildNodes().item(0).getTextContent()) + "</TD>");
	                            } else {
	                            	sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(docListNode.item(k).getChildNodes().item(0).getChildNodes().item(0).getTextContent()) + "</TD>");
	                            	sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(docListNode.item(k).getChildNodes().item(1).getChildNodes().item(0).getTextContent()) + "</TD>");
	                            	sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(docListNode.item(k).getChildNodes().item(2).getChildNodes().item(0).getTextContent()) + "</TD>");
	                            	sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + commonUtil.cleanValue(docListNode.item(k).getChildNodes().item(3).getChildNodes().item(0).getTextContent()) + "</TD>");
	                            }
	                            
	                            sbStr.append("</tr>");    
							}
						}
					}
				}
			}
		}
		
		model.addAttribute("cnt", cnt);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("sbStr", sbStr.toString());
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("viewCompany", viewCompany);
		logger.debug("doApprovAllselect ended");
		
		return "ezApprovalG/apprGdoApprovAllselect";
	}
	
	/**
	 * 전자결재G 회수 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/doCancel.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String doCancel(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, @RequestParam(value = "docIDAry[]", required = false) String[] docIDAry) throws Exception {
		logger.debug("doCancel started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		/* 2022-02-22 홍승비 - 일괄기안 회수용 파라미터 추가 전달 (모든 안의 회수 동작을 하나의 트랙잭션으로 묶기 위해, docIDAry 배열을 @RequestParam으로 전부 전달함) */
		String draftAllFlag = request.getParameter("draftAllFlag") != null ? request.getParameter("draftAllFlag") : "";
		String result = "";
		String sendNotiFlag = "";
		// 기존 단일문서 회수분기
		if (!draftAllFlag.equals("Y")) {
			result = ezApprovalGService.doCallBack(docID, userID, userInfo.getCompanyID(), userInfo.getTenantId(), sendNotiFlag);
		}
		// 일괄기안문서 회수분기
		else {
			for (int i = 1; i <= docIDAry.length -1; i++) { // 1안부터 시작
				if (i != 1) {
					sendNotiFlag = "N"; 
				}
				result = ezApprovalGService.doCallBack(docIDAry[i], userID, userInfo.getCompanyID(), userInfo.getTenantId(), sendNotiFlag);
				// 루프 도중에 하나라도 실패하면 트랙잭션에 오류를 발생시켜서 전체 DB작업을 롤백한다.
				if (result.equals("<RESULT>FALSE</RESULT>")) {
					logger.debug("doCancel failed in draftAll loop[" + i + "], docID = " + docIDAry[i]);
					throw new Exception(); // ajax 동작에서 에러 발생 시, 페이지단의 doCancel_error() 함수가 동작한다.
				}
			}
		}
		
		logger.debug("doCancel ended, result = " + result);
		
		return result;
	}
	
	/**
	 * 전자결재G 재기안 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getFormConnFlag.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getFormConnFlag(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getFormConnFlag started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String docID = request.getParameter("docID");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGService.getFormConnFlag(docID, companyID, userInfo.getTenantId());
		
		logger.debug("getFormConnFlag ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 양식아이디 가져오기 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getAprDocFormID.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getAprDocFormID(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getAprDocFormID started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getDocInfo(docID, "APR", "FormID", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
		
		logger.debug("getAprDocFormID ended");
		
		return result;
	}

	/**
	 * 전자결재G 공람정보 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezLineInfo.do", method = RequestMethod.GET)
	public String ezLineInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("ezLineInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String docState = request.getParameter("docState");
		String aprState = request.getParameter("aprState");
		String childDocInfo = ezApprovalGService.getInnerLineInfo(docID, deptID, docState, userInfo.getCompanyID(), userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		model.addAttribute("docID", docID);
		model.addAttribute("deptID", deptID);
		model.addAttribute("docState", docState);
		model.addAttribute("aprState", aprState);
		model.addAttribute("childDocInfo", childDocInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("lang", userInfo.getLang());
		
		logger.debug("ezLineInfo ended");
		
		return "ezApprovalG/apprGezLineInfo";
	}
	
	@RequestMapping(value = "/ezApprovalG/getContainerInfo.do", method = RequestMethod.GET)
	public String getContainerInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getContainerInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String realPath = commonUtil.getRealPath(request);
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String userEmail = userInfo.getEmail();
		String itemID = request.getParameter("itemID");
		String endAprType = request.getParameter("ENDAPRTYPE");
		String endAprState = request.getParameter("ENDAPRSTATE");
		String userInfoEnforce = ezCommonService.getTenantConfig("UserInfo_Enforce", userInfo.getTenantId()); 
		String openYear = ezCommonService.getTenantConfig("Site_OpenYear", userInfo.getTenantId());
		String susinAdmin = "";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String useEnforceSihang = ezCommonService.getTenantConfig("UseEnforceSihang", userInfo.getTenantId());
		String userLang = userInfo.getLang();
		//부서공유함의 부서,사용자 아이디
		String shareDeptId = request.getParameter("shareDeptId");
		String shareUserId = request.getParameter("shareUserId");

		// 2023-07-13 전인하 - 전자결재 > 공유문서함 > 미리보기영역 활성화여부 플래그를 문서함 공유자의 설정값으로 가져오는 현상을 개선
		String userIdForPreview = userInfo.getId();

		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String contType = "END";
		String dirPath = realPath + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator;
		String propList = "extensionAttribute4;extensionAttribute5";
		String contID = request.getParameter("contID");
		String sQuery = request.getParameter("sQuery");
		String type = request.getParameter("type");
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String tmpValue = request.getParameter("tmpValue");
		String result = ezOrganService.getPropertyList(userInfo.getId(), propList, userInfo.getPrimary(), userInfo.getTenantId());
		
		Document xmlDom = commonUtil.convertStringToDocument(result);
		
		String deptInfo = xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent();
		String buJaeInfo = xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
		
		if(shareDeptId != null && !shareDeptId.equals("")){
			StringBuffer containers = new StringBuffer();
			LoginVO userInfo2 = new LoginVO();
			userInfo2.setDeptID(shareDeptId);
			userInfo2.setCompanyID(userInfo.getCompanyID());
			userInfo2.setLocale(userInfo.getLocale());
			userInfo2.setTenantId(userInfo.getTenantId());
			userInfo2.setLang(userInfo.getLang());
			
			List<ApprGLeftVO> apprGLeftVOList = ezApprovalGService.getUseContInfo(userInfo2, "2");
			for (int k = 0; k < apprGLeftVOList.size(); k++) {
				if (k == 0) {
				    containers.append("'" + apprGLeftVOList.get(k).getContainerID() + "'");
				} else {
					containers.append(", '" + apprGLeftVOList.get(k).getContainerID() + "'");
				}
			}
			contID = containers.toString();
			model.addAttribute("share", "share");
		} else if(shareUserId != null && !shareUserId.equals("")){
			StringBuffer containers = new StringBuffer();
			LoginVO userInfo2 = new LoginVO();
			String userRealDeptId = ezOrganService.getUserOrgDeptId(shareUserId, userInfo.getTenantId(), userInfo.getCompanyID());
			userInfo2.setId(shareUserId);
			userInfo.setId(shareUserId);
			userInfo2.setDeptID(userRealDeptId);
			userInfo2.setCompanyID(userInfo.getCompanyID());
			userInfo2.setLocale(userInfo.getLocale());
			userInfo2.setTenantId(userInfo.getTenantId());
			userInfo2.setLang(userInfo.getLang());
			
			List<ApprGLeftVO> apprGLeftVOList = ezApprovalGService.getUseContInfo(userInfo2, "2");
			for (int k = 0; k < apprGLeftVOList.size(); k++) {
				if (k == 0) {
					containers.append("'" + apprGLeftVOList.get(k).getContainerID() + "'");
				} else {
					containers.append(", '" + apprGLeftVOList.get(k).getContainerID() + "'");
				}
			}
			//contID = containers.toString();
			model.addAttribute("share", "share");
		}
		
		String previewInfo = "OFF";
		String useAprPreview = ezCommonService.getTenantConfig("useAprPreview", userInfo.getTenantId()); // 미리보기 영역 사용여부 테넌트 컨피그
		
		/* 2023-04-18 홍승비 - 전자결재 > 미리보기 영역의 설정값 반환 이전, 미리보기 영역 사용여부를 먼저 체크 (사용하지 않으면 OFF 유지) */
		if (useAprPreview.equalsIgnoreCase("YES")) {
			// 2023-07-13 전인하 - 전자결재 > 공유문서함 > 미리보기영역 활성화여부 플래그를 문서함 공유자의 설정값으로 가져오는 현상을 개선
			previewInfo = ezApprovalGService.getApprovConfig(userIdForPreview, userInfo.getTenantId()); // 미리보기 영역 사용설정 (OFF, H)
		}

		model.addAttribute("useEnforceSihang", useEnforceSihang);
		model.addAttribute("buJaeInfo", buJaeInfo);
		model.addAttribute("endAprType", endAprType);
		model.addAttribute("endAprState", endAprState);
		model.addAttribute("itemID", itemID);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("contType", contType);
		model.addAttribute("dirPath", dirPath);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("type", type);
		model.addAttribute("sQuery", sQuery);
		model.addAttribute("contID", contID);
		model.addAttribute("deptInfo", deptInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("userEmail", userEmail);
		model.addAttribute("userInfoEnforce", userInfoEnforce);
		model.addAttribute("openYear", openYear);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("tmpValue", tmpValue);
		model.addAttribute("userLang", userLang);
		model.addAttribute("nowDateUTC", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		//2019-02-19 김보미 - 개인문서함의 경우 파일다운로드 방식이 틀려, 파일명을 javascript에서 지정하기 때문에 가져간다.
		model.addAttribute("excelFileName", EgovDateUtil.getTodayTime().substring(0, 10) + "_" + userInfo.getDeptID() + "_" + messageSource.getMessage("ezApprovalG.t1750", userInfo.getLocale()));
		model.addAttribute("shareDeptId", shareDeptId);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("previewInfo", previewInfo);
		model.addAttribute("useAprPreview", useAprPreview);
		model.addAttribute("useReceiveInfoName", ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId()));
		model.addAttribute("useUserCont", ezCommonService.getTenantConfig("useUserCont", userInfo.getTenantId()));
		
 		logger.debug("getContainerInfo ended");
		
		return "ezApprovalG/apprGgetContainerInfo";
	}
	
	@RequestMapping(value = "/ezApprovalG/getFormSearchDocListS.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getFormSearchDocListS(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		logger.debug("getFormSearchDocListS started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String docNumber = "";
		String docTitle = "";
		String drafter = "";
		String formID = "";
		String formName = "";
		String draftDeptName = "";
		                       
		String containerID = "";
		String userID = "";
		String pageNum = "";
		String pageSize = "";
		String docState = "";
		String itemCode = "";
		String endAprType = "";
		String endAprState = "";
		                       
		String subQuery = "";
		String orderCell = "";
		String orderOption = "";
		String searchStatus = "";
		
		String result = "";
	
		docNumber = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent().replace("[", "\\[").replace("%", "\\%").replace("_", "\\_");
		docTitle = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        drafter = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent().replace("[", "\\[").replace("%", "\\%").replace("_", "\\_");
        String draftfrom = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
        String draftto = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
        String apprfrom = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent();
        String papprto = xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent();
        String mypapprfrom = xmlDom.getDocumentElement().getChildNodes().item(7).getTextContent();
        String mypapprto = xmlDom.getDocumentElement().getChildNodes().item(8).getTextContent();
        formName = xmlDom.getDocumentElement().getChildNodes().item(9).getTextContent();
        draftDeptName = xmlDom.getDocumentElement().getChildNodes().item(11).getTextContent().replace("[", "\\[").replace("%", "\\%").replace("_", "\\_");
        containerID = xmlDom.getDocumentElement().getChildNodes().item(12).getTextContent();
        userID = xmlDom.getDocumentElement().getChildNodes().item(13).getTextContent();
        pageNum = xmlDom.getDocumentElement().getChildNodes().item(16).getTextContent();
        pageSize = xmlDom.getDocumentElement().getChildNodes().item(17).getTextContent();
        docState = xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent();
        orderCell = xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent();
        orderOption = xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent();
        searchStatus = xmlDom.getDocumentElement().getChildNodes().item(19).getTextContent();
        String ReturnQuery = "(1 = 1) ";
        Document xmldomsub = commonUtil.convertStringToDocument(xmlDom.getDocumentElement().getChildNodes().item(23).getTextContent());
        String TempQuery = xmldomsub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
        String shareDeptId = "";
        if (xmlDom.getDocumentElement().getChildNodes().getLength() >= 25 && xmlDom.getDocumentElement().getChildNodes().item(24).getTextContent() != null && !xmlDom.getDocumentElement().getChildNodes().item(24).getTextContent().equals("")) {
        	shareDeptId = "share/" + xmlDom.getDocumentElement().getChildNodes().item(24).getTextContent();
        }
        
        // 2021-03-16 박기범 - 키워드 검색 추가
        if (TempQuery.indexOf("KAPR;") != -1) {
        	ReturnQuery += " AND TBL_EXPAPRDOCINFO.keyword LIKE '%" + xmldomsub.getElementsByTagName("KEYWORD").item(0).getTextContent() + "%' ";
        }

        if (TempQuery.indexOf("KEND;") != -1) {
			ReturnQuery += " AND TBL_EXPENDAPRDOCINFO.keyword LIKE '%" + xmldomsub.getElementsByTagName("KEYWORD").item(0).getTextContent() + "%' ";
        }

        /* 2024-10-28 홍승비 - SQL Injection 제거 > 전자결재 일반 > 서브쿼리 문자열 대신 각 검색조건에 대응하도록 별도 파라미터 분리 (itemCode, endAprType, endAprState) */
        if (TempQuery.indexOf("CAPR;") != -1 || TempQuery.indexOf("CEND;") != -1) {
        	// itemCode는 전자결재 일반버전에서 사용하지 않는 검색조건이나, 일단 기존 코드를 유지하여 명시함
        	itemCode = xmldomsub.getElementsByTagName("ITEMCODE").item(0).getChildNodes().item(0).getTextContent();
        }
        
        // 좌측메뉴에서 후결문서함 접근 시 및 후결문서함 내부 간단검색에서 사용하는 SearchQuery 형식
        if (TempQuery.indexOf("EAPRTYPE;") != -1) {
        	endAprType = xmldomsub.getElementsByTagName("ENDAPRTYPE").item(0).getChildNodes().item(0).getTextContent();
        }
        if (TempQuery.indexOf("EAPRSTATE;") != -1) {
        	endAprState = xmldomsub.getElementsByTagName("ENDAPRSTATE").item(0).getChildNodes().item(0).getTextContent();
        }
        
        subQuery = ReturnQuery;
        
        if (xmlDom.getDocumentElement().getChildNodes().getLength() > 22) {
            if (!xmlDom.getDocumentElement().getChildNodes().item(22).getTextContent().trim().equals("")) {
                subQuery = subQuery + " AND " + xmlDom.getDocumentElement().getChildNodes().item(22).getTextContent();
                
                /* 2024-10-28 홍승비 - SQL Injection 제거 > 전자결재 일반 > 후결문서함을 표출하기 위한 서브쿼리 분리 */
                // 후결문서함 내부 상세검색에서 사용하는 pSubQuery 형식
                if (subQuery.toUpperCase().replace(" ", "").contains("TBL_ENDAPRLINEINFO.APRTYPE='040'") && subQuery.toUpperCase().replace(" ", "").contains("TBL_ENDAPRLINEINFO.APRSTATE='002'")) {
                	endAprType = "040";
                	endAprState = "002";
                }
                
                /* 2024-11-14 홍승비 - 서브쿼리에 포함될 수 있는 양식명 검색조건 추가 */
                // <Param9> 태그로 전달된 formName은 상세검색에서 사용되고, 서브쿼리로 전달된 formName은 부서공유함/양식별 문서함 등에서 사용된다.
                // 만약 상세검색 조건으로 전달된 formName이 있다면 해당 값을 우선적으로 사용하도록 한다.
        		if (subQuery.toUpperCase().replace(" ", "").contains("TBL_EXPENDAPRDOCINFO.FORMNAME='") && (formName == null || "".equals(formName.trim()))) {
        			Pattern pattern = Pattern.compile("(TBL_EXPENDAPRDOCINFO.FORMNAME\\s*=\\s*')(.*?)(')"); // 정규식으로 그룹핑하여 작은따옴표 안의 양식명만 추출
        			Matcher matcher = pattern.matcher(subQuery);
        			if (matcher.find()) {    			     
        				formName = matcher.group(2).trim();
        			}
                }
            }
        }
        
        result = ezApprovalGService.getSearchDocListS(containerID, userID, subQuery, docNumber, docTitle, drafter, formID, formName, draftfrom, draftto, apprfrom,
        		papprto, mypapprfrom, mypapprto, draftDeptName, docState, "", itemCode, endAprType, endAprState, shareDeptId, pageSize, pageNum, orderCell, orderOption, searchStatus,
                userInfo.getCompanyID(), userInfo.getLang(), "", userInfo.getTenantId(), userInfo.getOffset(), approvalFlag, userInfo.getLocale());
		
         logger.debug("getFormSearchDocListS ended");
         
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/getFormSearchDocList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getFormSearchDocList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		logger.debug("getFormSearchDocList started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		String docNumber = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String docTitle = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        String drafter = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
        String draftFromYEAR = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
        String draftFromMONTH = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
        String draftFromDAY = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent();
        String draftToYEAR = xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent();
        String draftToMONTH = xmlDom.getDocumentElement().getChildNodes().item(7).getTextContent();
        String draftToDAY = xmlDom.getDocumentElement().getChildNodes().item(8).getTextContent();
        String apprFromYEAR = xmlDom.getDocumentElement().getChildNodes().item(9).getTextContent();
        String apprFromMONTH = xmlDom.getDocumentElement().getChildNodes().item(10).getTextContent();
        String apprFromDAY = xmlDom.getDocumentElement().getChildNodes().item(11).getTextContent();
        String apprToYEAR = xmlDom.getDocumentElement().getChildNodes().item(12).getTextContent();
        String apprToMONTH = xmlDom.getDocumentElement().getChildNodes().item(13).getTextContent();
        String apprToDAY = xmlDom.getDocumentElement().getChildNodes().item(14).getTextContent();

        String myApprFromYEAR = xmlDom.getDocumentElement().getChildNodes().item(15).getTextContent();
        String myApprFromMONTH = xmlDom.getDocumentElement().getChildNodes().item(16).getTextContent();
        String myApprFromDAY = xmlDom.getDocumentElement().getChildNodes().item(17).getTextContent();
        String myApprToYEAR = xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent();
        String myApprToMONTH = xmlDom.getDocumentElement().getChildNodes().item(19).getTextContent();
        String myApprToDAY = xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent();
        String formID = "";
        String formName = xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent();
        String draftDeptName = xmlDom.getDocumentElement().getChildNodes().item(23).getTextContent();

        String containerID = xmlDom.getDocumentElement().getChildNodes().item(24).getTextContent();
        String userID = xmlDom.getDocumentElement().getChildNodes().item(25).getTextContent();
        String pageNum = xmlDom.getDocumentElement().getChildNodes().item(28).getTextContent();
        String pageSize = xmlDom.getDocumentElement().getChildNodes().item(29).getTextContent();
        String docState = xmlDom.getDocumentElement().getChildNodes().item(30).getTextContent();

        String subQuery = xmlDom.getDocumentElement().getChildNodes().item(31).getTextContent();
        String orderCell = xmlDom.getDocumentElement().getChildNodes().item(32).getTextContent();
        String orderOption = xmlDom.getDocumentElement().getChildNodes().item(33).getTextContent();

        if (subQuery.indexOf("KEND;") == 0) {
			subQuery = subQuery.substring(subQuery.indexOf("KEND;")+5);
			subQuery = "KEYWORD LIKE '%" + subQuery + "%'";
		}

        String result = ezApprovalGService.getSearchDocList(containerID, userID, subQuery, docNumber, docTitle, drafter, formID, formName, draftFromYEAR, draftFromMONTH, draftFromDAY, draftToYEAR,
        		draftToMONTH, draftToDAY, apprFromYEAR, apprFromMONTH, apprFromDAY, apprToYEAR, apprToMONTH, apprToDAY, myApprFromYEAR, myApprFromMONTH, myApprFromDAY, myApprToYEAR, myApprToMONTH,
        		myApprToDAY, draftDeptName, docState, "", pageSize, pageNum, orderCell, orderOption, "", userInfo.getCompanyID(), userInfo.getLang(), "", userInfo.getTenantId(), userInfo.getOffset(), approvalFlag, userInfo.getLocale());
        
        logger.debug("getFormSearchDocList ended");
        
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/ezReceiptHistoryInfo.do", method = RequestMethod.GET)
	public String ezReceiptHistoryInfo(HttpServletRequest request, Model model) throws Exception{
		logger.debug("ezReceiptHistoryInfo started");
		
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		
		model.addAttribute("docID", docID);
		model.addAttribute("deptID", deptID);
		//TODO: aspx 파일이 Cross 버젼으로 닷넷소스에는 걸려져있는데 파일이 존재안함 그래서 일단 일반으로 넣었으나 엑티브엑스 사용해서 수정해야됨
		logger.debug("ezReceiptHistoryInfo ended");
		
		return "ezApprovalG/apprGezReceiptHistoryInfo";
		
	}
	
	@RequestMapping(value = "/ezApprovalG/getReceiptHistoryInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getReceiptHistoryInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getReceiptHistoryInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		
		String result = ezApprovalGService.getReceiptHistoryInfo(docID, deptID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getReceiptHistoryInfo ended");
		
		return result;
	}
	
	//2019-01-24 천성준 - 완료문서 문서정보 팝업UI 공공,일반버전 공통으로 소스구현
	@RequestMapping(value = "/ezApprovalG/ezDocInfoView.do", method = RequestMethod.GET)
	public String ezDocInfoView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezDocInfoView started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String params = "";
		String docID = request.getParameter("docID"); 
		String ingFlag = request.getParameter("ingFlag"); //완료문서에선 END로 고정되서 들어옴
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		//공통정보
		String urgentApproval = "";		//긴급결재여부	(Y : 긴급, N : 일반)
		String publicityCode = "";		//공개여부		(G=대민공개여부, S=공개여부)
		String securityCode = "";		//보안등급		(100:1등급, 200:2등급, 300:3등급, 400:4등급, 500:5등급)
		String summary = "";			//요약정보
		String keyword = "";			//키워드	2021.03.09 박기범 - 문서정보 키워드 추가
		//G전용
		String specialRecordCode = "";	//특수기록물
		String securityApproval = "";	//보안결재 (ex. 2019-01-24)
		String publicityYN = "";		//G버전 문서 공개여부
		String limitRange = "";			//공개제한부분
		String pageNum = "";			//쪽수
		//S전용
		String storagePeriod = "";		//보존기간
		String taskCode = "";			//분류코드ID
		String itemName = "";			//분류코드명
		
		if (approvalFlag.equals("G")) {
			params = "SECURITYCODE;SPECIALRECORDCODE;URGENTAPPROVAL;PUBLICITYCODE;LIMITRANGE;PAGENUM;SECURITYAPPROVAL;SUMMARY;PUBLICITYYN;KEYWORD"; //보안등급;특수기록물;긴급결재;대민공개여부 및 공개등급;공개제한부분;쪽수;보안결재;요약정보;공개여부;키워드
		} else {
			params = "SECURITYCODE;STORAGEPERIOD;URGENTAPPROVAL;PUBLICITYCODE;TASKCODE;ITEMNAME;SUMMARY;KEYWORD"; //보안등급;보존기간;긴급결재;공개여부;분류코드ID;분류코드명;요약정보;키워드
		}
		
		String strXML = ezApprovalGService.getDocInfo(docID, ingFlag, params, userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
		
		Document docXML = commonUtil.convertStringToDocument(strXML);
		
		
		if (docXML.getElementsByTagName("URGENTAPPROVAL").item(0) != null) {
			urgentApproval = docXML.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent();
		}
		if (docXML.getElementsByTagName("PUBLICITYCODE").item(0) != null) {
			publicityCode = docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent();
		}
		if (docXML.getElementsByTagName("SECURITYCODE").item(0) != null) {
			securityCode = docXML.getElementsByTagName("SECURITYCODE").item(0).getTextContent();
		}
		if (docXML.getElementsByTagName("SUMMARY").item(0) != null) {
			summary = docXML.getElementsByTagName("SUMMARY").item(0).getTextContent();
		}
		if (docXML.getElementsByTagName("KEYWORD").item(0) != null) {
			keyword = docXML.getElementsByTagName("KEYWORD").item(0).getTextContent();
		}
		
		if (approvalFlag.equals("G")) {
			if (docXML.getElementsByTagName("SPECIALRECORDCODE").item(0) != null) {
				specialRecordCode = docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent();
			}
			if (docXML.getElementsByTagName("SECURITYAPPROVAL").item(0) != null) {
				securityApproval = docXML.getElementsByTagName("SECURITYAPPROVAL").item(0).getTextContent();
			}
			if (docXML.getElementsByTagName("PUBLICITYYN").item(0) != null) {
				publicityYN = docXML.getElementsByTagName("PUBLICITYYN").item(0).getTextContent();
			}
			if (docXML.getElementsByTagName("LIMITRANGE").item(0) != null) {
				limitRange = docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent();
			}
			if (docXML.getElementsByTagName("PAGENUM").item(0) != null) {
				pageNum = docXML.getElementsByTagName("PAGENUM").item(0).getTextContent();
			}
		} else {
			if (docXML.getElementsByTagName("STORAGEPERIOD").item(0) != null) {
				storagePeriod = docXML.getElementsByTagName("STORAGEPERIOD").item(0).getTextContent();
				storagePeriod = ezApprovalGService.getStoragePeriodName(storagePeriod, userInfo.getLang(), approvalFlag, userInfo.getCompanyID(), userInfo.getTenantId());
			}
			if (docXML.getElementsByTagName("TASKCODE").item(0) != null) {
				taskCode = docXML.getElementsByTagName("TASKCODE").item(0).getTextContent();
			}
			if (docXML.getElementsByTagName("ITEMNAME").item(0) != null) {
				itemName = docXML.getElementsByTagName("ITEMNAME").item(0).getTextContent();
			}
		}
		
		model.addAttribute("specialRecordCode", specialRecordCode);
		model.addAttribute("securityApproval", securityApproval);
		model.addAttribute("urgentApproval", urgentApproval);
		model.addAttribute("publicityCode", publicityCode);
		model.addAttribute("publicityYN", publicityYN);
		model.addAttribute("storagePeriod", storagePeriod);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("securityCode", securityCode);
		model.addAttribute("limitRange", limitRange);
		model.addAttribute("taskCode", taskCode);
		model.addAttribute("itemName", itemName);
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("summary", summary);
		model.addAttribute("keyword", keyword);

		logger.debug("ezDocInfoView ended");
		return "ezApprovalG/apprGezDocInfoView";
	}
	
	@RequestMapping(value = "/ezApprovalG/ezDocInfoGView.do", method = RequestMethod.GET)
	public String ezDocInfoGView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("ezDocInfoGView started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String summary = "";
		String pageNum = "";
		String limitRange = "";
		String publicityCode = "";
		String specialRecordCode = "";
		String urgentApproval = "";
		String securityCode = "";
		String securityDate = "";
		String keyword = "";
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String docID = request.getParameter("docID");
		String ingFlag = request.getParameter("ingFlag");
		String strXML = ezApprovalGService.getDocInfo(docID, ingFlag, "UrgentApproval;SpecialRecordCode;PublicityCode;LimitRange;PageNum;Summary;SecurityCode;SecurityApproval", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
		
		Document docXML = commonUtil.convertStringToDocument(strXML);
		
		if (docXML.getElementsByTagName("SUMMARY").item(0) != null) {
			summary = docXML.getElementsByTagName("SUMMARY").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("PAGENUM").item(0) != null) {
			pageNum = docXML.getElementsByTagName("PAGENUM").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("LIMITRANGE").item(0) != null) {
			limitRange = docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("PUBLICITYCODE").item(0) != null) {
			publicityCode = docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("SPECIALRECORDCODE").item(0) != null) {
			specialRecordCode = docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("URGENTAPPROVAL").item(0) != null) {
			urgentApproval = docXML.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("SECURITYCODE").item(0) != null) {
			securityCode = docXML.getElementsByTagName("SECURITYCODE").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("SECURITYAPPROVAL").item(0) != null) {
			securityDate = docXML.getElementsByTagName("SECURITYAPPROVAL").item(0).getTextContent();
		}

		if (docXML.getElementsByTagName("KEYWORD").item(0) != null) {
			keyword = docXML.getElementsByTagName("KEYWORD").item(0).getTextContent();
		}
		
		if (securityDate.equals("")) {
			securityDate = "N";
		}
		
		String securityNode = ezApprovalGService.getSecurityType("", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag);
		
		model.addAttribute("summary", summary);
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("limitRange", limitRange);
		model.addAttribute("publicityCode", publicityCode);
		model.addAttribute("specialRecordCode", specialRecordCode);
		model.addAttribute("urgentApproval", urgentApproval);
		model.addAttribute("securityCode", securityCode);
		model.addAttribute("securityDate", securityDate);
		model.addAttribute("securityNode", securityNode);
		model.addAttribute("keyword", keyword);

		logger.debug("ezDocInfoGView ended");
		
		return "ezApprovalG/apprGezDocInfoGView";
	}
	
	@RequestMapping(value = "/ezApprovalG/getEndOpinionInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getEndOpinionInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getEndOpinionInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = ezApprovalGService.getOpinionInfo(docID, "CEND", "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getEndOpinionInfo ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/aprEndOpinion.do", method = RequestMethod.GET)
	public String aprEndOpinion(HttpServletRequest request, Model model) throws Exception{
		logger.debug("aprEndOpinion started");
		String resize = request.getParameter("resize");
		
		model.addAttribute("resize", resize);
		
		logger.debug("aprEndOpinion ended");  
		return "ezApprovalG/apprGaprEndOpinion";
	}
	
	@RequestMapping(value = "/ezApprovalG/updateSignCheck.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String updateSignCheck(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("updateSignCheck started");  
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String signCheck = request.getParameter("signCheck");
        String result = ezApprovalGService.updateSignCheck(docID, signCheck, userInfo.getCompanyID(), userInfo.getTenantId());
        
        logger.debug("updateSignCheck ended");  
        
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/aprAttachMail.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String aprAttachMail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		logger.debug("aprAttachMail started");   
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		//String docID = xmlDom.getDocumentElement().getTextContent();
		String docID = xmlDom.getElementsByTagName("DocID").item(0).getTextContent();
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		} else if (xmlDom.getElementsByTagName("ORGCOMPANYID").getLength() > 0) {
			orgCompanyID = xmlDom.getElementsByTagName("ORGCOMPANYID").item(0).getTextContent();
			if (!orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
				userInfo.setCompanyID(orgCompanyID);
			}
		}
		
		String ingFlag = ezApprovalGService.aprAttachMail(docID, "1", userInfo.getCompanyID(), userInfo.getTenantId());
		
		Document xmlQuery = commonUtil.convertStringToDocument(ingFlag);
		
		String rtnVal = "";
		
		if (xmlQuery.getDocumentElement().getTextContent().trim().equals("")) {
			ingFlag = ezApprovalGService.aprAttachMail(docID, "2", userInfo.getCompanyID(), userInfo.getTenantId());
			
			xmlQuery = commonUtil.convertStringToDocument(ingFlag);
			NodeList nodeList = xmlQuery.getElementsByTagName("DOCTITLE");
			if (nodeList.getLength() > 0) {
				rtnVal = nodeList.item(0).getTextContent();
			} else {
				rtnVal = xmlQuery.getDocumentElement().getTextContent();
			}
			
			if (!rtnVal.equals("")) {
				ingFlag = ezApprovalGService.aprAttachMail(docID, "3", userInfo.getCompanyID(), userInfo.getTenantId());
			} else {
				ingFlag = ezApprovalGService.aprAttachMail(docID, "6", userInfo.getCompanyID(), userInfo.getTenantId());
				
				xmlQuery = commonUtil.convertStringToDocument(ingFlag);
				nodeList = xmlQuery.getElementsByTagName("DOCTITLE");
				if (nodeList.getLength() > 0) {
					rtnVal = nodeList.item(0).getTextContent();
				} else {
					rtnVal = xmlQuery.getDocumentElement().getTextContent();
				}
				
				ingFlag = ezApprovalGService.aprAttachMail(docID, "7", userInfo.getCompanyID(), userInfo.getTenantId());
			}
			
			rtnVal = "<ATTACHINFO><DOCTITLE>" + makeXMLString(rtnVal) + "</DOCTITLE>" + ingFlag + "</ATTACHINFO>";
		} else {
			ingFlag = ezApprovalGService.aprAttachMail(docID, "4", userInfo.getCompanyID(), userInfo.getTenantId());
			
			xmlQuery = commonUtil.convertStringToDocument(ingFlag);
			NodeList nodeList = xmlQuery.getElementsByTagName("DOCTITLE");
			if (nodeList.getLength() > 0) {
				rtnVal = nodeList.item(0).getTextContent();
			} else {
				rtnVal = xmlQuery.getDocumentElement().getTextContent();
			}

			ingFlag = ezApprovalGService.aprAttachMail(docID, "5", userInfo.getCompanyID(), userInfo.getTenantId());
			
			rtnVal = "<ATTACHINFO><DOCTITLE>" + makeXMLString(rtnVal) + "</DOCTITLE>" + ingFlag + "</ATTACHINFO>";
		}
		logger.debug("aprAttachMail ended"); 
		return rtnVal;
	}
	
	/**
	 * 전자결재G 내보내기, 전체내보내기 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/excelExportOut.do", method = {RequestMethod.POST, RequestMethod.GET})
	//2018-10-16 김보미 - 전자결재 엑셀출력 workBook 이용해서 출력하도록 변경
	public void excelExportOut(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Locale locale) throws Exception{
		
		/* 2025-05-30 임채영 : (VOC #159464) : 전체 내보내기 기능 속도 개선  */
		SXSSFWorkbook workbook = new SXSSFWorkbook(100);
		try {
			logger.debug("excelExportOut started");
			userInfo = commonUtil.aprUserInfo(loginCookie);

			String listType = "";

			listType = request.getParameter("listType");

			String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
			String allFG = request.getParameter("allFG");

			String excelValue = "";

			Map<String, Object> searchQueryMap = new HashMap<>();
			if (listType.toUpperCase().equals("DOC")) {
				String containerID = request.getParameter("cont");
				String pageNum = request.getParameter("PN");
				String pageSize = request.getParameter("PS");
				String orderCell = request.getParameter("OC");
				String orderOption = request.getParameter("OO");

				excelValue = ezApprovalGService.getContDocList(containerID, userInfo.getId(), searchQueryMap, pageSize, pageNum, orderCell, orderOption, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
			} else if (listType.toUpperCase().equals("PRINT")) {
				excelValue = request.getParameter("saveExcelData");
			} else {
				String P0 = request.getParameter("P0");
				String P1 = request.getParameter("P1");
				String P2 = request.getParameter("P2");
				String P3 = request.getParameter("P3");
				String P4 = request.getParameter("P4");
				String P5 = request.getParameter("P5");
				String P6 = request.getParameter("P6");
				String P7 = request.getParameter("P7");
				String P8 = request.getParameter("P8");
				String P9 = request.getParameter("P9");
				String P10 = request.getParameter("P10");
				String P11 = request.getParameter("P11");
				String P12 = request.getParameter("P12");
				String P13 = request.getParameter("P13");
				String P14 = request.getParameter("P14");
				String P15 = request.getParameter("P15");
				String P16 = request.getParameter("P16");
				String P17 = request.getParameter("P17");
				String P18 = request.getParameter("P18");
				String P19 = request.getParameter("P19");
				String P20 = request.getParameter("P20");
				String P21 = request.getParameter("P21");
//            String P22 = request.getParameter("P22");
				String P23 = request.getParameter("P23");
				String P24 = request.getParameter("P24");
				String pageNum = request.getParameter("PN");
				String pageSize = request.getParameter("PS");
				String orderCell = request.getParameter("OC");
				String orderOption = request.getParameter("OO");
				String subQuery = request.getParameter("SQ");

				if (approvalFlag.equalsIgnoreCase("G")) {
					excelValue = ezApprovalGService.getSearchDocList(P24, userInfo.getId(), subQuery, P0, P1, P2, "", P21, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16, P17, P18, P19, P20, P23, "", "", pageSize, pageNum, orderCell, orderOption, allFG, userInfo.getCompanyID(), userInfo.getLang(), "", userInfo.getTenantId(), userInfo.getOffset(), approvalFlag, userInfo.getLocale());
					//  excelValue = ezApprovalGService.getSearchDocList(P24, userInfo.getId(), subQuery, P0, P1, P2, P21,"", P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16, P17, P18, P19, P20, P23, "", "", pageSize, pageNum, orderCell, orderOption, allFG, userInfo.getCompanyID(), userInfo.getLang(), "", userInfo.getTenantId(), userInfo.getOffset(),  approvalFlag, userInfo.getLocale());
				} else {
					excelValue = ezApprovalGService.getSearchDocListS(P12, userInfo.getId(), subQuery, P0, P1, P2, P9, "", P3, P4, P5, P6, P7, P8, P11, "", allFG, "", "", "", "", pageSize, pageNum, orderCell, orderOption, "", userInfo.getCompanyID(), userInfo.getLang(), "", userInfo.getTenantId(), userInfo.getOffset(), approvalFlag, userInfo.getLocale());
				}
			}

			Document objXML = commonUtil.convertStringToDocument(excelValue);

			//엑셀시작
			SXSSFSheet sheet = workbook.createSheet("report");
			sheet.trackAllColumnsForAutoSizing();
			
			//헤더 폰트 굵게
			Font headerFont = workbook.createFont();
			headerFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

			CellStyle headerStyle = workbook.createCellStyle();
			headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			headerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			headerStyle.setFont(headerFont);

			CellStyle bodyStyle = workbook.createCellStyle();
			bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

			Row row;
			Cell cell;

			row = sheet.createRow(0);
			for (int i = 0; i < objXML.getElementsByTagName("HEADER").getLength(); i++) {
				String headerName = objXML.getElementsByTagName("NAME").item(i).getTextContent();

				cell = row.createCell(i);
				cell.setCellValue(headerName);
				cell.setCellStyle(headerStyle);
				row.setHeight((short) 512);
				sheet.autoSizeColumn(i);
				sheet.setColumnWidth(i, (sheet.getColumnWidth(i)) + 512);
			}//header

			NodeList objRow = objXML.getElementsByTagName("ROW");

			Map<String, String> docTypeMap = new HashMap<>();
			docTypeMap.put("001", "품의");
			docTypeMap.put("002", "협조");
			docTypeMap.put("003", "감사");
			docTypeMap.put("004", "심사");
			docTypeMap.put("011", "수신");
			docTypeMap.put("012", "합의");
			docTypeMap.put("013", "시행");
			docTypeMap.put("014", "검사부 감사");
			docTypeMap.put("015", "공람");
			docTypeMap.put("016", "회람");
			docTypeMap.put("017", "참조");
			docTypeMap.put("018", "후결");
			docTypeMap.put("019", "발신");
			docTypeMap.put("020", "신청");
			docTypeMap.put("031", "반송");
			docTypeMap.put("032", "회송");

			for (int j = 0; j < objRow.getLength(); j++) {
				row = sheet.createRow((j + 1));

				Element rowElem = (Element) objRow.item(j);
				NodeList objCell = rowElem.getElementsByTagName("CELL");

				for (int k = 0; k < objCell.getLength(); k++) {
					Element cellElem = (Element) objCell.item(k);
					String originalValue = cellElem.getElementsByTagName("VALUE").item(0).getTextContent();
					String cellValue = docTypeMap.getOrDefault(originalValue, originalValue);

					cell = row.createCell(k);
					cell.setCellValue(cellValue == null ? "" : cellValue);
					cell.setCellStyle(bodyStyle);
					row.setHeight((short) 384);
				}
			}//body
	
			// 각 행,열에 데이터맵핑 후에 각 열의 헤더의 넓이로 해당하는 열의 셀에 모두 일괄적용 
			int columnSize = objXML.getElementsByTagName("HEADER").getLength();
			for (int k = 0; k < columnSize; k++) {
				//autoSizeColumn은 성능 부하가 많이 걸리는 작업이므로, 별도로 HEADER 열의 수만큼 실행으로 변경
				sheet.autoSizeColumn(k);
				sheet.setColumnWidth(k, Math.min(255 * 256, sheet.getColumnWidth(k) + 512));
			}
			
			/* 2019-11-18 홍승비 - 전자결재문서 엑셀 저장 시 부서ID 대신 부서명을 파일명에 사용하도록 수정 */
			// 2020-10-08 김민성- 크롬에서 다운로드시 확장자 사라지는 오류 수정
			String pFileName = EgovDateUtil.getTodayTime().substring(0, 10) + "_" + userInfo.getDeptName() + "_" + messageSource.getMessage("ezApprovalG.kms01", locale).replace(" ", "_") + ".xlsx";
			response.setContentType("application/ms-excel");
			response.setCharacterEncoding("utf-8");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), pFileName) + "\"");

			workbook.write(response.getOutputStream());
		} catch (IOException e) {
			logger.error("### 엑셀 저장 중 IOException 발생 = {}", e.getMessage());
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		} finally {
			logger.debug("excelExportOut ended");
			workbook.dispose();
			workbook.close();
		}
	}
	
	/**
	 * 전자결재G 결재함 감사함 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getGamSaSearchDocList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getGamSaSearchDocList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		logger.debug("getGamSaSearchDocList started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String docNumber = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
        String docTitle = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        String drafter = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
        String draftFromYEAR = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
        String draftFromMONTH = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
        String draftFromDAY = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent();
        String draftToYEAR = xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent();
        String draftToMONTH = xmlDom.getDocumentElement().getChildNodes().item(7).getTextContent();
        String draftToDAY = xmlDom.getDocumentElement().getChildNodes().item(8).getTextContent();
        String apprFromYEAR = xmlDom.getDocumentElement().getChildNodes().item(9).getTextContent();
        String apprFromMONTH = xmlDom.getDocumentElement().getChildNodes().item(10).getTextContent();
        String apprFromDAY = xmlDom.getDocumentElement().getChildNodes().item(11).getTextContent();
        String apprToYEAR = xmlDom.getDocumentElement().getChildNodes().item(12).getTextContent();
        String apprToMONTH = xmlDom.getDocumentElement().getChildNodes().item(13).getTextContent();
        String apprToDAY = xmlDom.getDocumentElement().getChildNodes().item(14).getTextContent();

        String myApprFromYEAR = xmlDom.getDocumentElement().getChildNodes().item(15).getTextContent();
        String myApprFromMONTH = xmlDom.getDocumentElement().getChildNodes().item(16).getTextContent();
        String myApprFromDAY = xmlDom.getDocumentElement().getChildNodes().item(17).getTextContent();
        String myApprToYEAR = xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent();
        String myApprToMONTH = xmlDom.getDocumentElement().getChildNodes().item(19).getTextContent();
        String myApprToDAY = xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent();
        String formID = xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent();
        String draftDeptName = xmlDom.getDocumentElement().getChildNodes().item(23).getTextContent();

        String containerID = xmlDom.getDocumentElement().getChildNodes().item(24).getTextContent();
        String userID = xmlDom.getDocumentElement().getChildNodes().item(25).getTextContent();
        String deptID = xmlDom.getDocumentElement().getChildNodes().item(26).getTextContent();
        String pageNum = xmlDom.getDocumentElement().getChildNodes().item(28).getTextContent();
        String pageSize = xmlDom.getDocumentElement().getChildNodes().item(29).getTextContent();
        String docState = xmlDom.getDocumentElement().getChildNodes().item(30).getTextContent();

        String subQuery = xmlDom.getDocumentElement().getChildNodes().item(31).getTextContent();
        String orderCell = xmlDom.getDocumentElement().getChildNodes().item(32).getTextContent();
        String orderOption = xmlDom.getDocumentElement().getChildNodes().item(33).getTextContent();
        
        String result = ezApprovalGService.getGamSaSearchDocList(containerID, userID, deptID, subQuery, docNumber, docTitle, drafter, formID, draftFromYEAR, draftFromMONTH, draftFromDAY,
        		draftToYEAR, draftToMONTH, draftToDAY, apprFromYEAR, apprFromMONTH, apprFromDAY, apprToYEAR, apprToMONTH, apprToDAY, myApprFromYEAR, myApprFromMONTH, myApprFromDAY,
        		myApprToYEAR, myApprToMONTH, myApprToDAY, draftDeptName, docState, "", pageSize, pageNum, orderCell, orderOption, userInfo);
       
        logger.debug("getGamSaSearchDocList ended");
        
		return result;
	}
	
	/**
	 * 전자결재G 단위업무관리 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/taskManage.do", method = RequestMethod.GET)
	public String taskManage(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("taskManage started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		// 2024-04-05 전인하 - 전자결재G > 기록물관리 > 단위업무 리스트 총 카운트 호출 추가
		int taskCount = ezApprovalGAdminService.getTaskListCount(userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId(), null, null, "0");

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("taskCount", taskCount);

		logger.debug("taskManage ended");
		
		return "ezApprovalG/apprGtaskManage";
	}
	
	/**
	 * 전자결재G 기록물철인계 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/cabTransfer.do", method = RequestMethod.GET)
	public String cabTransfer(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("cabTransfer started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		// 2024-06-12 전인하 - 전자결재G > 기록물관리 > 기록물철인계 > 리스트헤더 정보 호출
		String adminFlag = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;m") ? "YES" : "NO";
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
		model.addAttribute("adminFlag", adminFlag);
		model.addAttribute("listHeaderString", listHeaderString);

		/* 상위부서문서함 사용 시 관련 정보 같이 전달 */
		String upperDeptCode = "";
		Map<String, String> upDeptInfo = ezApprovalGService.getUpperDeptInfo(userInfo.getDeptID(), userInfo.getTenantId());
		if (upDeptInfo.get("USEUPPERDEPTBOX") != null && upDeptInfo.get("USEUPPERDEPTBOX").equals("Y")) {
			upperDeptCode = upDeptInfo.get("upperDeptCode");
		}
		model.addAttribute("upperDeptCode", upperDeptCode);

		logger.debug("cabTransfer ended");
		
		return "ezApprovalG/apprGcabTransfer";
	}
	
	/**
	 * 전자결재G 기록물철인계 단위업무코드 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/selectTask.do", method = RequestMethod.GET)
	public String selectTask(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		logger.debug("selectTask started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String initFlag = "";
		String multiSelect = "";
		
		if (request.getParameter("initFlag") != null) {
			initFlag = request.getParameter("initFlag");
		}
		if (request.getParameter("multiSelect") != null) {
			multiSelect = request.getParameter("multiSelect");
		}
		
		if (initFlag.trim().equals("")) {
			initFlag = "0";
		}
		
		if (multiSelect.trim().equals("")) {
			multiSelect = "0";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("initFlag", initFlag);
		model.addAttribute("multiSelect", multiSelect);
		
		logger.debug("selectTask ended");
		
		return "ezApprovalG/apprGselectTask";
	}

	/**
	 * 전자결재G 기록물철인계 인수부서 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/selectDept.do", method = RequestMethod.GET)
	public String selectDept(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("selectDept started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("selectDept ended");
		
		return "ezApprovalG/apprGselectDept";
	}
	
	/**
	 * 전자결재G 기록물철인계 인계가능여부확인 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getUncompleteDocCount.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getUncompleteDocCount(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getUncompleteDocCount started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String cabinetID = request.getParameter("cabinetID");
		String result = ezApprovalGService.getUncompleteDocCount(userInfo.getDeptID(), userInfo.getCompanyID(), cabinetID, userInfo.getTenantId());
	
		logger.debug("getUncompleteDocCount ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/getUncompleteDocListOpen.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String getUncompleteDocListOpen(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getUncompleteDocListOpen started");
		
		String cabinetID = request.getParameter("cabinetID");
		String cabinetName = request.getParameter("cabinetName");
		
		model.addAttribute("cabinetID", cabinetID);
		model.addAttribute("cabinetName", cabinetName);
		
		logger.debug("getUncompleteDocListOpen ended");
		
		return "ezApprovalG/apprGunCompleteDocListOpen";
	}
	
	@RequestMapping(value = "/ezApprovalG/getUncompleteDocList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getUncompleteDocList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getUncompleteDocList started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String cabinetID = request.getParameter("cabinetID");
	
		String strXML = ezApprovalGService.getUncompleteDocList(userInfo.getDeptID(), userInfo.getCompanyID(), cabinetID, userInfo.getTenantId(), userInfo.getLang(), userInfo);
		
		logger.debug("getUncompleteDocList ended");
		
		return strXML;
	}
	
	/**
	 * 전자결재G 기록물철인계 인계버튼 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/transferCab.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String transferCab(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		logger.debug("transferCab started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.transferCabinet(xmlDom, userInfo.getTenantId());
		
		logger.debug("transferCab ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 관리자 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/adminPage.do", method = RequestMethod.GET)
	public String adminPage(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Locale locale, Model model) throws Exception{
		logger.debug("adminPage started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String initFlag = request.getParameter("initFlag");
		String pageTitle = "";
		String deptCode = userInfo.getDeptID();
		String deptName = "";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		if (userInfo.getPrimary().equals("1")) {
			deptName = userInfo.getDeptName1();
		} else {
			deptName = userInfo.getDeptName2();
		}
		
		switch (initFlag) {
		case "0":
			pageTitle = messageSource.getMessage("ezApprovalG.t520", locale);
			break;
		case "1":
			pageTitle = messageSource.getMessage("ezApprovalG.t521", locale);
			break;
		case "2":
			pageTitle = messageSource.getMessage("ezApprovalG.t522", locale);
			break;
		case "3":
			pageTitle = messageSource.getMessage("ezApprovalG.t523", locale);
			break;
		case "4":
			pageTitle = messageSource.getMessage("ezApprovalG.t559", locale);
			break;
		default:
			pageTitle = messageSource.getMessage("ezApprovalG.t520", locale);
			break;
		}
		
		model.addAttribute("pageTitle", pageTitle);
		model.addAttribute("deptCode", deptCode);
		model.addAttribute("deptName", deptName);
		model.addAttribute("initFlag", initFlag);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		logger.debug("adminPage ended");
		
		return "ezApprovalG/apprGadminPage";
	}
	
	/**
	 * 전자결재G 분리첨부 철변경 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/selectCabinetInTask.do", method = RequestMethod.GET)
	public String selectCabinetInTask(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("gongRamUpdate started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String openYear = ezCommonService.getTenantConfig("Site_OpenYear", userInfo.getTenantId());
		String currYear = commonUtil.getTodayUTCTime("yyyy");

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("openYear", openYear);
		model.addAttribute("currYear", currYear);

		logger.debug("gongRamUpdate ended");
		
		return "ezApprovalG/apprGselectCabinetInTask";
	}

	/**
	 * 전자결재G 공람문서 공람승인 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/gongRamUpdate.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String gongRamUpdate(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("gongRamUpdate started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = ezApprovalGService.gongRamUpdate(docID, userID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("gongRamUpdate ended");	
		
		return result;
	}
	
	/** 2023-06-20 조소정 - 전자결재(G/일반) 공람할문서 일괄공람 / 회람수신함 일괄회람 표출 Method */
	@RequestMapping(value = "/ezApprovalG/gongRamAllUpdate.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String gongRamAllUpdate(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestParam String userID, @RequestParam(value = "docIDArray[]") String[] docIDArray, @RequestParam(value = "orgCompanyIDArray[]") String[] orgCompanyIDArray, HttpServletRequest request) throws Exception {
		logger.debug("gongRamAllUpdate started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String result = "";
		int totCnt = docIDArray.length;
		int trueCnt = 0;
		String rtnVal = "";
		
		for (int i = 0; i < docIDArray.length; i++) {
			String orgCompanyID = orgCompanyIDArray[i];
			result = ezApprovalGService.gongRamUpdate(docIDArray[i], userID, orgCompanyID, userInfo.getLang(), userInfo.getTenantId());
			
			if (result.equals("<RESULT>TRUE</RESULT>")) {
				trueCnt++;
			}
		}
		
		rtnVal = totCnt + "/" + trueCnt;
		
		logger.debug("gongRamAllUpdate ended, rtnVal = " + rtnVal);
		
		return rtnVal;
	}
	
	/**
	 * 전자결재G 종료연기 신청,취소 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/delayCabEndY.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String delayCabEndY(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,HttpServletRequest request) throws Exception{
		logger.debug("delayCabEndY started");
		
	    userInfo = commonUtil.aprUserInfo(loginCookie);

		String companyID = request.getParameter("companyID");
		String deptCode = request.getParameter("deptCode");
		String flag = request.getParameter("flag");
		String cabClassList = request.getParameter("cabClassList");
		
		String result = ezApprovalGService.delayCabEndY(deptCode, flag, cabClassList, companyID, userInfo.getTenantId());
		
		logger.debug("delayCabEndY ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 관리자 편철확정 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getUncabinetedDocCount.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getUncabinetedDocCount(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getUncabinetedDocCount started");
		
	    userInfo = commonUtil.aprUserInfo(loginCookie);
	    
		String deptID = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String confirmYN = commonUtil.getTodayUTCTime("yyyy");
		String result = ezApprovalGService.getUncabinetedDocCount(deptID, confirmYN, companyID, userInfo.getTenantId());
		
		logger.debug("getUncabinetedDocCount ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 관리자 편철확정 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/chkIfNotArrangedCabExist.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String chkIfNotArrangedCabExist(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("chkIfNotArrangedCabExist started");
		
	    userInfo = commonUtil.aprUserInfo(loginCookie);

		String deptID = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGService.chkIfNotArrangedCabExist(deptID, companyID, userInfo.getTenantId());
		
		logger.debug("chkIfNotArrangedCabExist ended");
		
		return result;
	}

	/**
	 * 전자결재G 관리자 편철확정 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/confirmClassfy.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String confirmClassfy(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("confirmClassfy started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String deptID = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGService.confirmClassify(deptID, companyID, userInfo.getTenantId());
		
		logger.debug("confirmClassfy ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 전자결재 발송대장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getSendOutDocList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
		
		//2018-09-28 김보미 - 검색 추가
		if (searchQuery != null && searchQuery.length() > 10) {
			String tempQuery = "";
			domSub = commonUtil.convertStringToDocument(searchQuery);
			tempQuery = domSub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
			
			String qOptionDocNo = "";
			String qOptionDocTitle = "";
			String qOptionWriterName = "";
			String qOptionWriterDeptName = "";
			String qOptionAprStartDate = "";
			String qOptionAprSReceivedDate = "";
			String qOptionAprEndDate = "";
			String qOptionAprEReceivedDate = "";
			
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
			
            if (tempQuery.indexOf("APRSTARTDATE;") != -1) {
                if (listType.equals("10")) {
                	qOptionAprSReceivedDate = commonUtil.getDateStringInUTC(domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), true);
                } else {
                	qOptionAprStartDate = commonUtil.getDateStringInUTC(domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), true);
                }
            }
            
            if (tempQuery.indexOf("APRENDDATE;") != -1) {
                if (listType.equals("10")) {
                	qOptionAprEReceivedDate = commonUtil.getDateStringInUTC(domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true);
                } else {
                	qOptionAprEndDate = commonUtil.getDateStringInUTC(domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true);
                }
            }
            
			queryMap.put("userLang", userLang);
			queryMap.put("qOptionDocNo", qOptionDocNo);
			queryMap.put("qOptionDocTitle", qOptionDocTitle);
			queryMap.put("qOptionWriterName", qOptionWriterName);
			queryMap.put("qOptionWriterDeptName", qOptionWriterDeptName);
			queryMap.put("qOptionAprStartDate", qOptionAprStartDate);
			queryMap.put("qOptionAprSReceivedDate", qOptionAprSReceivedDate);
			queryMap.put("qOptionAprEndDate", qOptionAprEndDate);
			queryMap.put("qOptionAprEReceivedDate", qOptionAprEReceivedDate);
			
			String qOptionSearchStatus = "";
			String qOptionFormId = "";
			String qOptionFormName = "";
			String qOptionKeyword = "";
			String qOptionItemCode = "";
			String qOptionUrgentApproval = "";
            
            if (searchStatus != null && !searchStatus.equals("") && !searchStatus.equals("ALL")) {
				qOptionSearchStatus = searchStatus;
            }
            
            // 현재 FORMID 태그로 값이 전달되어도 양식명(FORMNAME) 검색을 사용함
            if (tempQuery.indexOf("FORMID;") != -1) {
            	qOptionFormName = domSub.getElementsByTagName("FORMID").item(0).getTextContent();
            }
            
            /* 2024-05-27 홍승비 - 양식명 검색조건 누락된 부분 추가 */
            if (tempQuery.indexOf("FORMNAME;") != -1) {
				qOptionFormName = domSub.getElementsByTagName("FORMNAME").item(0).getTextContent();
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
		
		String result = ezApprovalGService.getSendOutDocList(userID, deptID, susinManagerFlag, pageSize, pageNum, orderCell, orderOption, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), queryMap);
		
		logger.debug("getSendOutDocList ended");
		
		return result;
	}

	/**
	 * 전자결재G 정리대상목록 편철확인 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/endCabProduce.do", method = RequestMethod.GET)
	public String endCabProduce(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("endCabProduce started (GET)");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String tempYear = EgovDateUtil.getTodayTime().substring(0, 4);
		
		int pYear = Integer.parseInt(tempYear) - 1;
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pYear", pYear);
		
		logger.debug("endCabProduce ended (GET)");

		return "ezApprovalG/apprGendCabProduce";
	}
	
	/**
	 * 전자결재G 정리대상목록 편철확인 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/endCabProduce.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String endCabProduce(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("endCabProduce started (POST)");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String companyID = request.getParameter("companyID");
		String cabClassNo = request.getParameter("cabClassNO");
		String flag = request.getParameter("flag");
		
		String result = ezApprovalGService.endCabProduce(cabClassNo.trim(), flag, companyID, userInfo.getTenantId() );
		
		logger.debug("endCabProduce ended (POST)");
		
		return result;
	}
	
	// 2024-03-14 분석 결과 구포탈(ezPortal)에서만 사용되던 코드로 확인
	/**
	 * 전자결재G 포틀릿 결재리스트 표출 Method
	 */
	/*@RequestMapping(value = "/ezApprovalG/getPortletAprDocList.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getPortletAprDocList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		logger.debug("getPortletAprDocList started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		Map<String, Object> searchMap = new HashMap<>();
		
		String pListType = request.getParameter("pListTypeName");
		String pUserID = request.getParameter("pUserID");
		String pUserDeptID = request.getParameter("pUserDeptID");
		String pPageSize = request.getParameter("pPageSize");
		String pPageNum = request.getParameter("pPageNum");
		String companyID = request.getParameter("companyID");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String searchQuery = request.getParameter("searchQuery");
		
		String result = ezApprovalGService.getAprDocList(pListType, pUserID, pUserDeptID, pPageSize, pPageNum, orderCell, orderOption, companyID, searchQuery, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), searchMap);

		logger.debug("getPortletAprDocList ended");

		return result;
	}*/
	
	/**
	 * 전자결재G 포틀릿 결재리스트 표출 Method - 수정버전
	 * 박종균
	 */
	/*@RequestMapping(value = "/ezApprovalG/getPortletAprList.do", method = RequestMethod.POST)
	@ResponseBody
	public Object getPortletAprList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramData, LoginVO userInfo) throws Exception{
		logger.debug("getPortletAprList is started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String imgPath = commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + "/";
		String lang = userInfo.getLang().equalsIgnoreCase("1") ? "" : userInfo.getLang();
		
		logger.debug("paramData : " + paramData.toString());
		paramData.put("tenantID", userInfo.getTenantId());                         
		paramData.put("approvalFlag", approvalFlag);
		paramData.put("imgPath", imgPath);
		paramData.put("lang", lang);
		
		Map<String, Object> portletList = ezApprovalGService.getPortletAprList(paramData, userInfo.getOffset());
		logger.debug("getPortletAprList is ended");
		
		logger.debug("portletList : " + portletList.toString());

		return portletList;
	}*/
	
	/**
	 * 전자결재 포틀릿 결재할 문서 시간 표시 Method
	 * */
	/*@RequestMapping(value = "/ezApprovalG/getPortletApprGapTime.do", method = RequestMethod.POST)
	@ResponseBody
	public Object getPortletApprGapTime(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramData, LoginVO userInfo) throws Exception {
		logger.debug("getPortletApprGapTime is started.");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		paramData.put("tenantID", userInfo.getTenantId());     
		
		Map<String, Object> ret = ezApprovalGService.getPortletApprGapTime(paramData);
		logger.debug("ret.toString() " + ret.toString());
		logger.debug("getPortletApprGapTime is ended.");
		return ret;
	}*/

	/**
	 * 전자결재G 철생성 비치기록물 변경 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/insDisplayInfo.do", method = RequestMethod.GET)
	public String insDisplayInfo() throws Exception{
		logger.debug("insDisplayInfo started");
		logger.debug("insDisplayInfo ended");
		return "ezApprovalG/apprGinsDisplayInfo";
	}

	/**
	 * 전자결재G 결재 일괄결재 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doApprovAllG.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String doApprovAllG(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		logger.debug("doApprovAllG started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String rtnVal = "OK/0/0/0"; // OK or ERR/ totalCount / trueCount / falseCount
		int totCnt = 0, trueCnt = 0, falseCnt = 0;
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		logger.debug("<<<xmlDom : " + commonUtil.convertDocumentToString(xmlDom));
		String userID = xmlDom.getElementsByTagName("USERID").item(0).getTextContent().trim();
		// String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
		String langType = xmlDom.getElementsByTagName("LANGTYPE").item(0).getTextContent().trim();
//		String formID = xmlDom.getElementsByTagName("FORMID").item(0).getTextContent().trim();
		String orgUID = "";
		String realPath = commonUtil.getRealPath(request);
		
		userInfo.setRealPath(realPath);
		
		if (xmlDom.getElementsByTagName("DOCID").getLength() > 0) {
			totCnt = xmlDom.getElementsByTagName("DOCID").getLength(); // 결재 체크된 문서 갯수 확인
			String mode = xmlDom.getElementsByTagName("MODE").item(0).getTextContent().trim();
			
			for (int k = xmlDom.getElementsByTagName("DOCID").getLength() - 1; k > -1; k--) {
				orgUID = xmlDom.getElementsByTagName("ORGAPRUSERID").item(k).getTextContent(); // 원결재자
				mode = xmlDom.getElementsByTagName("MODE").item(k).getTextContent();
				
				String docState = xmlDom.getElementsByTagName("DOCSTATE").item(k).getTextContent().trim();
				String orgCompanyID = xmlDom.getElementsByTagName("orgCompanyID").item(k).getTextContent().trim();
				String approveRet = ezApprovalGService.getApproveDocInfo(userInfo, xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), orgCompanyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(),mode,docState);
				String aprMemberSN = xmlDom.getElementsByTagName("APRMEMBERSN").item(k).getTextContent().trim();
				String formID = xmlDom.getElementsByTagName("FORMID").item(k).getTextContent().trim();
				
				Document aprXML = commonUtil.convertStringToDocument(approveRet);
				
				if (xmlDom.getElementsByTagName("TYPE").getLength() > 0) {
					if (xmlDom.getElementsByTagName("TYPE").item(k).getTextContent().equals("MHT")) {
						logger.debug("type = MHT");
						//공유결재자에 의해 결재가 완료된 문서인지 확인
						int checkAprState = ezApprovalGService.getCheckAprState(xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), orgUID, docState, aprMemberSN, orgCompanyID, userInfo.getTenantId());
						if (checkAprState == 0) {
							//checkAprState가 0인 경우 현재 결재자의 진행,보류,미결 상태가 아님을 의미
							rtnVal = "ERROR";
						} else if (aprXML.getElementsByTagName("DocFlag").item(0).getTextContent().equals("CHAMJO")) {
							//rtnVal = ezApprovalGService.mobileSrvConn(userID, "A", formID, "", xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), orgUID, langType, companyID, request, userInfo, mode);
							//참조일때
							rtnVal = ezApprovalGService.doApprove(xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), orgUID, "003", aprXML.getElementsByTagName("WRITERNAME").item(0).getTextContent(), aprXML.getElementsByTagName("WRITERNAME2").item(0).getTextContent(), realPath + aprXML.getElementsByTagName("HREF").item(0).getTextContent(), aprXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent(), userInfo.getId(), orgCompanyID, userInfo.getLang(), userInfo, "", "017", "", "", "");
						} else {
							rtnVal = ezApprovalGService.mobileSrvConn(userID, "A", formID, "", xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), orgUID, langType, orgCompanyID, request, userInfo, mode, aprMemberSN);
						}
					} else {
						rtnVal = ezApprovalGService.mobileSrvConn_HWP(userID, "A", formID, "", xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), orgUID, langType, orgCompanyID, request, userInfo, mode, aprMemberSN);
						logger.debug("type = HWP");
					}
				} else {
					//rtnVal = ezApprovalGService.mobileSrvConn(userID, "A", formID, "", xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), orgUID, langType, companyID, request, userInfo, mode);
					//참조일때
					if (aprXML.getElementsByTagName("DocFlag").item(0).getTextContent().equals("CHAMJO")) {
						rtnVal = ezApprovalGService.doApprove(xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), orgUID, "003", aprXML.getElementsByTagName("WRITERNAME").item(0).getTextContent(), aprXML.getElementsByTagName("WRITERNAME2").item(0).getTextContent(), realPath + aprXML.getElementsByTagName("HREF").item(0).getTextContent(), aprXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent(), userInfo.getId(), orgCompanyID, userInfo.getLang(), userInfo, "", "017", "", "", "");
					} else {
						rtnVal = ezApprovalGService.mobileSrvConn(userID, "A", formID, "", xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), orgUID, langType, orgCompanyID, request, userInfo, mode, aprMemberSN);
					}
				}
				
				if (rtnVal.equals("ERROR")) {
					falseCnt++;
				} else {
					if (!docState.equals("017")) { // 참조가 아닌 경우에만 발송
						ezApprovalGService.sendMailToNextAprMember(xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), request, loginCookie, userInfo, orgCompanyID, userInfo.getTenantId());
					}
					trueCnt++;
				}
			}
			
			if (falseCnt > 0) {
				rtnVal = "ERR/" + totCnt + "/" + trueCnt + "/" + falseCnt;
			} else {
				rtnVal = "OK/" + totCnt + "/" + trueCnt + "/" + falseCnt;
			}
		}
		
		logger.debug("doApprovAllG ended.");
		
		return rtnVal;
	}

	/**
	 * 전자결재G 종료연기 종료연기신청 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/reqDelayCabEndY.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String reqDelayCabEndY(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("reqDelayCabEndY started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String companyID = request.getParameter("companyID");
		String cabClassList = request.getParameter("cabClassList");
		String flag = request.getParameter("flag");
		
		String result = ezApprovalGService.reqDelayCabEndY(cabClassList, flag, companyID, userInfo.getTenantId());
		
		logger.debug("reqDelayCabEndY ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 발송의뢰문서 발송 호출 Method
	 */
	@RequestMapping(value = {"/ezApprovalG/ezSimsaG.do", "/ezApprovalG/ezConvSihang.do"}, method = RequestMethod.GET)
	public String ezSimsaG(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("ezSimsaG started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String orgDocID = request.getParameter("orgDocID");
		String docTitle = request.getParameter("docTitle");
		String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String recordID = request.getParameter("recordID") != null ? request.getParameter("recordID") : ""; // 시행문의 반송을 위한 recordID 추가

		String pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());
		
		/* 2020-11-13 홍승비 - 대용량첨부 관련 파라미터 추가 */
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
		String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String bigAttachFileMinSaveDate = ezApprovalGService.getAttachFileMinSaveDate(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String bigAttachDownloadPeriod = bigAttachFileMinSaveDate + " ~ " + EgovDateUtil.addDay(bigAttachFileMinSaveDate, Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");
		
		// 2023-05-26 조수빈 - 전자결재 첨부파일 미리보기 기능 사용 여부
		String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		
		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
			useAprFilePrvw = "1";
		} else {
			useAprFilePrvw = "0";
		}
				
		if (docID != null && docID.equals("")) {
			Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), "REC", userInfo.getCompanyID(), userInfo.getTenantId(), "");
			
			if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
				return "main/warning";
			}
			
			if (!doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals(userInfo.getId()) && !doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("NULL")) {
				if (doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("") && (!doc.getElementsByTagName("RECEIVEDDEPTID").item(0).getTextContent().equals(userInfo.getDeptID()) || userInfo.getRollInfo().indexOf("a=1") == -1)) {
					return "main/warning";
				}
				
				if (!doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("")) {
					return "main/warning";
				}
			}
		}
		
        boolean isConvSihang = false;
        if (request.getRequestURI().endsWith("ezConvSihang.do")) {
            isConvSihang = true;
        }
        
        //회사아이디가 기관코드로 안돼있기때문에 지정해줘야됨
        String companyID = "";
        if (!isConvSihang) {
            //기관코드와 회사 아이디가 다를 경우 보정처리.
            companyID = config.getProperty("config.companyNum");
        } else {
            companyID = request.getParameter("orgCompanyID");;
        }
        userInfo.setCompanyID(companyID);
		
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("accessInfo", accessInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("pass", pass);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("docTitle", docTitle);
		model.addAttribute("isConvSihang", isConvSihang);
		model.addAttribute("recordID", recordID);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수

		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		
		logger.debug("ezSimsaG ended");
		
		return "ezApprovalG/apprGezSimsaG";
	}
	
	/**
	 * 전자결재G 발송의뢰문서 발송컨텐츠 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/enforceContent.do", method = RequestMethod.GET)
	public String enforceContent(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("enforceContent started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		model.addAttribute("editor", editor);
		
		logger.debug("enforceContent ended");
		
		return "ezApprovalG/apprGenforceContent";
	}
	
	/**
	 * 전자결재G 발송의뢰문서 발송 수신자 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezReceiptInfo.do", method = RequestMethod.GET)
	public String ezReceiptInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("ezReceiptInfo started");
		
		//userInfo = commonUtil.aprUserInfo(loginCookie); //2019.03.25 천성준 - 사용안해서 일단 주석
		String docID = request.getParameter("docID");
		String ext = request.getParameter("ext");
		String mode = request.getParameter("mode");
		
		if (mode == null || mode.isEmpty()) {
		    mode = "APR";
		}
		
		model.addAttribute("docID", docID);
		model.addAttribute("ext", ext);
		model.addAttribute("mode", mode);
		
		logger.debug("ezReceiptInfo ended");

		return "ezApprovalG/apprGezReceiptInfo";
	}
	/**
	 * 전자결재 진행중 문서 수신자탭에서 수신자 더블클릭시 나타나는 팝업
	 */
	@RequestMapping(value = "/ezApprovalG/ezReceiptInfoIng.do", method = RequestMethod.GET)
	public String ezReceiptInfoIng(@CookieValue("loginCookie") String loginCookie, @RequestParam String docId, @RequestParam String receiptId, @RequestParam String receiptName, Model model) throws Exception{
	    logger.debug("ezReceiptInfoIng started");
	    
	    LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
	    
	    List<Map<String, Object>> receipts = ezApprovalGService.getReceiptInfoIng(docId, receiptId, userInfo);
	    
	    String susinGroupPrefix = ezApprovalGService.getCode2Name("A53", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
	    
	    model.addAttribute("receiptId", receiptId);
	    model.addAttribute("receiptName", receiptName);
	    model.addAttribute("receipts", receipts);
	    model.addAttribute("susinGroupPrefix", susinGroupPrefix);
	    model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("useReceiveInfoName", ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId()));
		
	    logger.debug("ezReceiptInfo ended");
	    
	    return "ezApprovalG/apprGezReceiptInfoIng";
	}

	/**
	 * 전자결재G 발송의뢰문서 발송 발송 저장 Method
	 */
	@RequestMapping(value = "/ezApprovalG/saveEndFile.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String saveEndFile(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, @RequestBody JSONObject jsonObj) throws Exception{
		logger.debug("saveEndFile started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = jsonObj.get("docID") == null? null : jsonObj.get("docID").toString();
		String formText = jsonObj.get("html") == null? null : jsonObj.get("html").toString();
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String path = commonUtil.getRealPath(request) +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		InputStream stream = null;
		
		try {
			EzFile file = new EzFile(commonUtil.detectPathTraversal(path + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID)));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			String saveFileName = path + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator + docID + ".mht";
	
			if (formText != null) {
				stream = new ByteArrayInputStream(formText.getBytes("UTF-8"));
				
				// EzFAL EzFileOutputStream 사용 (자동 close 호출)
				try (EzFileOutputStream fos = new EzFileOutputStream(saveFileName)) {
					int bytesRead = 0;
					byte[] buffer = new byte[BUFF_SIZE];
					
					while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
						fos.write(buffer, 0, bytesRead);
					}
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (stream != null) {
				try {
					stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
		}
		
		logger.debug("saveEndFile ended");
		
		return "SUCCESS";
	}

	/**
	 * 전자결재G 발송의뢰문서 발송 발송 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/sendOfferAprove.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String sendOfferAprove(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("sendOfferAprove started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String orgDocID = request.getParameter("orgDocID");
		String userID = request.getParameter("userID");
		String userName = request.getParameter("userName");
		String userName2 = request.getParameter("userName2");
		String deptID = request.getParameter("deptID");
		
		String dirPath = commonUtil.getRealPath(request) +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = ezApprovalGService.doSendOfferApprove(docID, orgDocID, userID, userName, userName2, deptID, dirPath, "", userInfo.getCompanyID(), userInfo.getLang(), userInfo, "");
		
		logger.debug("sendOfferAprove ended");
		
		return result;
	}

	/**
	 * 전자결재G 발송의뢰문서 발송 반송 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/sendOfferReject.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String sendOfferReject(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("sendOfferReject started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		String isSihangReject = request.getParameter("isSihangReject") != null ? request.getParameter("isSihangReject") : ""; // 시행문의 반송을 위한 플래그 추가
		String recordID = request.getParameter("recordID") != null ? request.getParameter("recordID") : ""; // 시행문의 반송을 위한 recordID 추가
		String result = "";
		
		if (isSihangReject.equals("Y")) { // 미처리문서함에 들어온 내부시행문의 반송 분기 (완료된 문서의 테이블에 접근)
			result = ezApprovalGService.doSihangConvReject(docID, recordID, userID, deptID, userInfo.getCompanyID(), userInfo.getTenantId());
		} else { // 기존 반송 분기
			result = ezApprovalGService.doSendOfferReject(docID, userID, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		
		logger.debug("sendOfferReject ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물 열람권한 확인 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getUserRecRight.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getUserRecRight(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getUserRecRight started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String companyID = request.getParameter("companyID");
		String recID = request.getParameter("recID");
		String sepAttNo = request.getParameter("sepAttNo");
		String userID = request.getParameter("userID");
		
		String result = ezApprovalGService.getUserRecRight(recID, sepAttNo, userID, companyID, userInfo.getTenantId());
		
		logger.debug("getUserRecRight ended");
		return result;
	}
	
	/**
	 * 전자결재G 겸직 쿠키 생성 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ChangeUserInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public void changeUserInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		logger.debug("ChangeUserInfo started");

		String deptID = request.getParameter("deptID");
		String deptName = request.getParameter("deptName");
		String deptName2 = request.getParameter("deptName2");
		String title = request.getParameter("position");
		String title2 = request.getParameter("position2");
		String companyID = request.getParameter("companyID");
		String companyName = request.getParameter("companyName");
		String companyName2 = request.getParameter("companyName2");
		
		// 2023-08-28 전인하 - 전자결재 > 좌측 드롭다운 이용하여 겸직 변경 > 겸직 변경 시 쿠키로 jobId 삽입
		String jobId = request.getParameter("jobId");
		
		boolean isSecure = request.isSecure(); //http, https 판단
		String forwardedProto = request.getHeader("X-Forwarded-Proto");
		
		if (!isSecure && "https".equalsIgnoreCase(forwardedProto)) {
			isSecure = true;
		}
		
		if (isSecure) {
			response.addHeader("Set-Cookie", "APRUI0=" + URLEncoder.encode(deptID, "utf-8") + "; Path=/; SameSite=None; Secure");
			response.addHeader("Set-Cookie", "APRUI1=" + URLEncoder.encode(deptName, "utf-8") + "; Path=/; SameSite=None; Secure");
			response.addHeader("Set-Cookie", "APRUI2=" + URLEncoder.encode(deptName2, "utf-8") + "; Path=/; SameSite=None; Secure");
			response.addHeader("Set-Cookie", "APRUI3=" + URLEncoder.encode(companyName, "utf-8") + "; Path=/; SameSite=None; Secure");
			response.addHeader("Set-Cookie", "APRUI4=" + URLEncoder.encode(companyName2, "utf-8") + "; Path=/; SameSite=None; Secure");
			response.addHeader("Set-Cookie", "APRUI5=" + URLEncoder.encode(title, "utf-8") + "; Path=/; SameSite=None; Secure");
			response.addHeader("Set-Cookie", "APRUI6=" + URLEncoder.encode(title2, "utf-8") + "; Path=/; SameSite=None; Secure");
			response.addHeader("Set-Cookie", "APRUI7=" + URLEncoder.encode(companyID, "utf-8") + "; Path=/; SameSite=None; Secure");
			response.addHeader("Set-Cookie", "APRUI8=" + URLEncoder.encode(jobId, "utf-8") + "; Path=/; SameSite=None; Secure");
		} else {
			Cookie cookieID0 = new Cookie("APRUI0", URLEncoder.encode(deptID, "utf-8"));
			cookieID0.setPath("/");
			response.addCookie(cookieID0);
			
			Cookie cookieID1 = new Cookie("APRUI1", URLEncoder.encode(deptName, "utf-8"));
			cookieID1.setPath("/");
			response.addCookie(cookieID1);
			
			Cookie cookieID2 = new Cookie("APRUI2", URLEncoder.encode(deptName2, "utf-8"));
			cookieID2.setPath("/");
			response.addCookie(cookieID2);
			
			Cookie cookieID3 = new Cookie("APRUI3", URLEncoder.encode(companyName, "utf-8"));
			cookieID3.setPath("/");
			response.addCookie(cookieID3);
			
			Cookie cookieID4 = new Cookie("APRUI4", URLEncoder.encode(companyName2, "utf-8"));
			cookieID4.setPath("/");
			response.addCookie(cookieID4);
			
			Cookie cookieID5 = new Cookie("APRUI5", URLEncoder.encode(title, "utf-8"));
			cookieID5.setPath("/");
			response.addCookie(cookieID5);
			
			Cookie cookieID6 = new Cookie("APRUI6", URLEncoder.encode(title2, "utf-8"));
			cookieID6.setPath("/");
			response.addCookie(cookieID6);
			
			Cookie cookieID7 = new Cookie("APRUI7", URLEncoder.encode(companyID, "utf-8"));
			cookieID7.setPath("/");
			response.addCookie(cookieID7);
	
			Cookie cookieID8 = new Cookie("APRUI8", URLEncoder.encode(jobId, "utf-8"));
			cookieID8.setPath("/");
			response.addCookie(cookieID8);
		}

		logger.debug("ChangeUserInfo ended");
	}
	
	/**
	 * 전자결재G 회송후 대장등록  Method
	 */
	@RequestMapping(value = "/ezApprovalG/removeDocCabinetInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String removeDocCabinetInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("removeDocCabinetInfo Started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String deptName = request.getParameter("deptName");
		String deptName2 = request.getParameter("deptName2");
		String flag = request.getParameter("flag");
		String realPath = commonUtil.getRealPath(request);
		String dirPath = realPath +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = "";
		
		/* 2022-03-11 홍승비 - 일괄기안된 문서의 경우, 모든 안에 대하여 대장등록 진행 */
		List<ApprGGroupDocInfoVO> groupDocInfoList = new ArrayList<ApprGGroupDocInfoVO>();
		String groupDocSN = ezApprovalGService.getGroupDocSN(docID, userInfo.getTenantId(), userInfo.getCompanyID());
		
		if (groupDocSN != null && !groupDocSN.equals("")) {
			groupDocInfoList = ezApprovalGService.getGroupDocList(groupDocSN, "TMP", userInfo.getTenantId(), userInfo.getCompanyID());
			for (ApprGGroupDocInfoVO tempVO : groupDocInfoList) {
				result = ezApprovalGService.setCabinetReject(tempVO.getDocID(), deptID, deptName, deptName2, dirPath, realPath, flag, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo.getLocale());
				
				// 일괄기안 문서의 경우, 대장등록이 하나라도 실패하면 동작을 중지하고 바로 리턴시킨다.
				if (result.indexOf("FALSE") > -1) {
					String[] resultArr = result.split(","); // 대장등록 실패 시, 해당 문서번호를 롤백
					if (resultArr.length > 1 && resultArr[1] != null && !resultArr[1].trim().equals("")) {
		        		ezApprovalGService.rollbackCabinetNum(deptID, "", resultArr[1], userInfo.getCompanyID(), "", userInfo.getLang(), userInfo.getTenantId());
		        	}
					return result.split(",")[0];
				}
			}
		}
		else { // 기존 단일기안문서 대장등록 진행 분기
			result = ezApprovalGService.setCabinetReject(docID, deptID, deptName, deptName2, dirPath, realPath, flag, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo.getLocale());
			
			if (result.indexOf("FALSE") > -1) {
				String[] resultArr = result.split(",");
				if (resultArr.length > 1 && resultArr[1] != null && !resultArr[1].trim().equals("")) {
	        		ezApprovalGService.rollbackCabinetNum(deptID, "", resultArr[1], userInfo.getCompanyID(), "", userInfo.getLang(), userInfo.getTenantId());
	        	}
			}
		}
		
		logger.debug("removeDocCabinetInfo ended");

		return result.split(",")[0];
	}
	
	/**
	 * 전자결재G 기록물등록대장 공람발송 호출  Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprGongRamLine.do", method = RequestMethod.GET)
	public String aprGongRamLine(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("aprGongRamLine started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String type = "APR";
		String serverName = userInfo.getServerName();
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		if (request.getParameter("type") != null) {
			type = request.getParameter("type");
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("type", type);
		model.addAttribute("serverName", serverName);
		model.addAttribute("approvalFlag", approvalFlag);
		
		logger.debug("aprGongRamLine ended");
		
		return "ezApprovalG/apprGaprGongRamLine";
	}
	
	/**
	 * 전자결재G 기록물등록대장 공람발송 등록  Method
	 */
	@RequestMapping(value = "/ezApprovalG/gongRamSave.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String gongRamSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, @RequestBody String xmlPara) throws Exception{
		logger.debug("gongRamSave started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String type = "APR";
		
		if (request.getParameter("type") != null) {
			type = request.getParameter("type");
		}
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String dirPath = commonUtil.getRealPath(request) +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = "";
		
		String docID = xmlDom.getElementsByTagName("ROW").item(0).getChildNodes().item(8).getTextContent().trim();
		String gongRamDocID = ezApprovalGService.gongRamDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		List<ApprGAprLineVO> beforeGongRamSaveAprList = null;

		// 2024-04-23 한태훈 > 병렬 공람 시 공람 대상자들에게 공람 문서 도착 알람 발송 목적으로 공랍 결재선 정보 미리 저장. (알림 중복 발송 피하기 위한 목적)
		if (gongRamDocID != null && !gongRamDocID.equals("") && !gongRamDocID.equals("NONE")) {
			beforeGongRamSaveAprList = ezApprovalGService.getGongramAprLineInfo(gongRamDocID, userInfo.getCompanyID(), userInfo.getTenantId());
		}

		if (type.equals("APR")) {
			result = ezApprovalGService.gongRamSave(xmlDom, dirPath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		} else if (type.equals("ING")) {
			result = ezApprovalGService.gongRamSaveIng(xmlDom, dirPath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		} else {
			result = ezApprovalGService.gongRamSaveEnd(xmlDom, dirPath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		}
		
		String gongRamOption = ezApprovalGService.getCode2Name("A56", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		if (gongRamDocID == null || gongRamDocID.equals("") || gongRamDocID.equals("NONE")) {
			gongRamDocID = ezApprovalGService.gongRamDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		List<ApprGAprLineVO> afterGongRamSaveAprList = ezApprovalGService.getGongramAprLineInfo(gongRamDocID, userInfo.getCompanyID(), userInfo.getTenantId());

		// 2024-04-23 한태훈 > 병렬 공람 시 공람 대상자들에게 공람 문서 도착 알람 발송, 순차발송 시엔 gongRamActivate 메소드에서 알림 발송함.
		if (gongRamOption.toUpperCase().trim().equals("Y") && type.equals("END")) {
			for (ApprGAprLineVO afterAprLineMember : afterGongRamSaveAprList) {
				boolean foundInBefore = false;
				if (beforeGongRamSaveAprList != null) {
		            for (ApprGAprLineVO beforeAprLineMember : beforeGongRamSaveAprList) {
		                if (beforeAprLineMember.getAprMemberID().equals(afterAprLineMember.getAprMemberID())) {
		                	foundInBefore = true;
		                    break;
		                }
		            }
				}

	            if (!foundInBefore) {
	            	ezApprovalGService.sendNoti(gongRamDocID, "", "", afterAprLineMember.getAprMemberID(), afterAprLineMember.getAprMemberName(), afterAprLineMember.getAprMemberDeptID(), "GONGRAM", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
	            }
			}
		}

		logger.debug("gongRamSave ended");
		
		return result;
	}
	
	/**
	 * 전자결재G 임시저장 재기안 Method
	 */
	@RequestMapping(value = "/ezApprovalG/makeTmp2Ing.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String makeTmp2Ing(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("makeTmp2Ing started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("tmpDocID");
		String userID = docID.split("@")[0];
		String sn = docID.split("@")[1];
		String result = ezApprovalGService.makeTmp2IngDocInfo(userID, sn, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), "", "", "");
		
		logger.debug("makeTmp2Ing ended");

		return result;
	}
	
	/**
	 * 전자결재G 메일보내기 Method
	 */
	@RequestMapping(value = "/ezApprovalG/sendToMailApproval.do", method = RequestMethod.GET)
	public String sendToMailApproval(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("sendToMailApproval started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

//		String docHref = request.getParameter("docHref");
		String cmd = request.getParameter("cmd");
		String docID = request.getParameter("docID");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String strImgCount = "";
		
		logger.debug("sendToMailApproval ended");
		
		return "redirect:/ezEmail/mailWrite.do?docHref=IMAGE&cmd=" + cmd + "&docID=" + docID + "&imageCnt=" + strImgCount + "&target=APPROVALG&orgCompanyID="+userInfo.getCompanyID();
	}
	
	/**
	 * 전자결재G 메일보내기 Method
	 */
	@RequestMapping(value = "/ezApprovalG/createMailImg.do", method = RequestMethod.POST)
	@ResponseBody
	public String createMailImg(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("createMailImg started");
		//자바에서 결재문서 캡쳐 하는 것 대기 상태, phantomjs
//		userInfo = commonUtil.userInfo(loginCookie);
//		String docID = request.getParameter("docID");
//		String strPath = commonUtil.getRealPath(request)+ commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId()) + commonUtil.separator + commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(0,10).replace("-", "") ;
//
//		String filePath = "";
//        String uploadModule = commonUtil.getUploadPath("upload_common.MHTIMAGE", userInfo.getTenantId()) + commonUtil.separator; 
//        String realPath = commonUtil.getRealPath(request);
//        String strURL = request.getParameter("imgUrl");
//        String domain = request.getServerName() +":" +request.getServerPort();
//        
//        filePath = realPath + uploadModule;
//        
//        File file = new File(filePath);
//        if (!file.exists()) {
//        	file.mkdirs();
//        } 
//        
//        String m_strMHT = "";
//        
//        try {
//        	m_strMHT = ezCommonService.loadMHTFile(realPath + strURL);
//		} catch (Exception e) {
//			logger.error(e.getMessage(), e);
//			m_strMHT= "";
//		}
//        String strHTML = ezCommonService.startMHT2HTML(filePath, m_strMHT, filePath, realPath, userInfo.getLocale(), domain);
//        
//        try{
//                         
//            // BufferedWriter 와 FileWriter를 조합하여 사용 (속도 향상)
//            BufferedWriter fw = new BufferedWriter(new FileWriter(strPath + commonUtil.separator+docID+".html", false));
//            String content = new String(strHTML.toString().getBytes(), "UTF-8");
//
//            // 파일안에 문자열 쓰기
//            fw.write(content);
//            fw.flush();
//            
//            // 객체 닫기
//            fw.close();
//
//        }catch(Exception e){
//            logger.error(e.getMessage(), e);
//        }
//	
//		DesiredCapabilities caps = new DesiredCapabilities();
//		
//		caps.setJavascriptEnabled(true);
//		caps.setCapability(PhantomJSDriverService.PHANTOMJS_EXECUTABLE_PATH_PROPERTY, "E:\\phantomjs-2.1.1-windows\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe");
//		
//		WebDriver driver = new PhantomJSDriver(caps);
//		driver.get("file:///" + strPath + commonUtil.separator+ docID+".html");
//		driver.manage().window().maximize();
//		driver.manage().timeouts().implicitlyWait(20L, TimeUnit.SECONDS);
//					
//		File srcFile = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE); // temp 폴더에 파일이 생성됨 
//		
//		FileUtils.copyFile(srcFile, new File(strPath+commonUtil.separator+docID+".png")); // temp폴더에 생성된 이미지파일을 사용자가 지정한 폴더로 복사함. 
//		driver.quit();
	     
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String strPath = commonUtil.getRealPath(request)+ commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId()) + commonUtil.separator + commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(0,10).replace("-", "") ;
		
		try {
			File file = new File(commonUtil.detectPathTraversal(strPath)); // upload_common 경로의 파일이므로 EzFAL 적용 제외
			
			if (!file.exists()) {
				file.mkdirs();
			}
			String data = request.getParameter("imgUrl");
			
			if (data == null || data.equals("")) {
			    throw new Exception();
			}
			data = data.replaceAll("data:image/png;base64,", "");
			byte[] file2 = Base64.decodeBase64(data);
		    
			// try문 적용하여 stream 자동 close 호출로 변경
			try (FileOutputStream fos = new FileOutputStream(commonUtil.detectPathTraversal(strPath + commonUtil.separator + docID + ".png"))) {
				fos.write(file2);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
			
		} catch (FileNotFoundException fnfe) {
			logger.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			logger.debug("ioe: {}", ioe);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		}
		
		logger.debug("createMailImg ended");
		
		return "true";
	}
	
	/**
	 * 전자결재 일반버전 부서(병렬,순차)합의 Method
	 */
	@RequestMapping(value = "/ezApprovalG/recev.do", method = RequestMethod.GET)
	public String recev(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("recev started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String draftFlag = request.getParameter("draftFlag");
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		String susinAdmin = "";
		String optSignDateFormat = "";
		String optisSplit = "";
		String optSplitKind = "";
		String useDirectSign = "";
		String draftDate = "";
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());
		String signImageSize = ezCommonService.getTenantConfig("SignImageSize", userInfo.getTenantId());
		String draftDeptID = ezApprovalGService.getOrgDraftDeptID(docID, userInfo.getTenantId(), userInfo.getCompanyID());
		
		//부서합의문 서명 이미지타입일때 이미지랑 부서아이디 같이 들어가는 버그 수정 20200313 윤상원
		String signImageType = ezCommonService.getTenantConfig("signImageType", userInfo.getTenantId()); 
		
		//부서합의문에서 채번하기 위해 수정 2019-02-08 홍대표
		String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());

		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		
		if (approvalFlag.equals("S")) {
			optisSplit = ezApprovalGService.getOptionInfo("SA33", "001", userInfo, "CODE");
		} else {
			optisSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		}
		optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
		
		useDirectSign = ezCommonService.getTenantConfig("USE_DirectSign", userInfo.getTenantId());
		
		draftDate = commonUtil.getTodayUTCTime("");
		
		if (approvalFlag.equals("G")) {
			String nonElecRec = ezApprovalGService.checkNonElecRec(docID, userInfo.getCompanyID(), userInfo.getTenantId());
			if (!nonElecRec.equals("")) {
				model.addAttribute("nonElecRec", nonElecRec);
			}
		}
		
		model.addAttribute("docID", docID);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optisSplit", optisSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("useDirectSign", useDirectSign);
		model.addAttribute("draftDate", draftDate);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("junGyulFlag", junGyulFlag);
		model.addAttribute("signImageSize", signImageSize);
		model.addAttribute("draftDeptID", draftDeptID);
		model.addAttribute("useReceiveDocNo", useReceiveDocNo);
		model.addAttribute("docNumZeroCnt", docNumZeroCnt);
		model.addAttribute("signImageType", signImageType);
		model.addAttribute("useOpenGov", config.getProperty("config.useOpenGov"));
		model.addAttribute("isPreview", isPreview);
		
		logger.debug("recev ended");

		return "ezApprovalG/apprGrecev";
	}
	
	/**
	 * 전자결재G 결재정보 수신처 민원인주소입력 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDeptAddressUserName.do", method = RequestMethod.GET)
	public String aprDeptAddressUserName() throws Exception{
		logger.debug("aprDeptAddressUserName started");
		logger.debug("aprDeptAddressUserName ended");
		return "ezApprovalG/apprGaprDeptAddressUserName";
	}
	
	/**
	 * 전자결재G 결재정보 수신처 민원인상세주소입력 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDeptAddressName.do", method = RequestMethod.GET)
	public String aprDeptAddressName() throws Exception{
		logger.debug("aprDeptAddressName started");
		logger.debug("aprDeptAddressName ended");
		return "ezApprovalG/apprGaprDeptAddressName";
	}
	
	/**
	 * 전자결재G 부서병렬합의 접수 컨텐츠 Method
	 */
	@RequestMapping(value = "/ezApprovalG/recevContent.do", method = RequestMethod.GET)
	public String recevContent() throws Exception{
		logger.debug("recevContent started");
		logger.debug("recevContent ended");
		return "ezApprovalG/apprGrecevContent";
	}
	
	/**
	 * 전자결재G 부서병렬합의 접수 컨텐츠2 Method
	 */
	@RequestMapping(value = "/ezApprovalG/recevContentTwo.do", method = RequestMethod.GET)
	public String recevContent2() throws Exception{
		logger.debug("recevContent2 started");
		logger.debug("recevContent2 ended");
		return "ezApprovalG/apprGrecevContent2";
	}
	
	/**
	 * 전자결재G 결재선 사용자 포함여부 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/checkAprLineUser.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String checkAprLineUser(@CookieValue("loginCookie") String loginCookie,  LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("checkAprLineUser started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("mode");
		String userID = request.getParameter("userID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGService.checkAprLine(docID, mode, userID, companyID, userInfo.getTenantId());
		
		logger.debug("checkAprLineUser ended");
		return result;
	}
	
	/**
	 * 전자결재G 수신순번 겟 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getSusinSN.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getSusinSN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		logger.debug("getSusinSN started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String docID = doc.getElementsByTagName("DOCID").item(0).getTextContent();
		String orgCompanyID = doc.getElementsByTagName("orgCompanyID").item(0).getTextContent();
		String result = ezApprovalGService.getSusinSN(docID, orgCompanyID, userInfo.getTenantId());
		
		logger.debug("getSusinSN ended");
		
		return result;
	}
	
	// 2024-03-14 분석 결과 구포탈(ezPortal)에서만 사용되던 코드로 확인
	/*
	 * 전자결재G 결재할문서 개수 가져오기 Method
	@RequestMapping(value = "/ezApprovalG/getWebPartCount.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getWebPartCount(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		logger.debug("getWebPartCount started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String pFlag = doc.getElementsByTagName("FLAG").item(0).getTextContent();
		
		int result = ezApprovalGService.getWebPartListCount(pFlag, userInfo.getId(), userInfo.getDeptID(), "", "COUNT", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("getWebPartCount ended");
		
		return "<DATA><RESULT>"+result+"</RESULT></DATA>";
	}*/
	
	/**
	 * 전자결재G 강제회수
	 */	
	@RequestMapping(value = "/ezApprovalG/doCancelForce.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String doCancelForce(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,  HttpServletRequest request, @RequestParam(value = "docIDAry[]", required = false) String[] docIDAry) throws Exception{
		logger.debug("doCancelForce started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		/* 2022-02-22 홍승비 - 일괄기안 회수용 파라미터 추가 전달 (모든 안의 회수 동작을 하나의 트랙잭션으로 묶기 위해, docIDAry 배열을 @RequestParam으로 전부 전달함) */
		String draftAllFlag = request.getParameter("draftAllFlag") != null ? request.getParameter("draftAllFlag") : "";
		String result = "";
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !userInfo.getCompanyID().equals(orgCompanyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		// 기존 단일문서 회수분기
		if (!draftAllFlag.equals("Y")) {
			result = ezApprovalGService.doCancelForce(docID, userID, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		// 일괄기안문서 회수분기
		else {
			for (int i = 1; i <= docIDAry.length -1; i++) { // 1안부터 시작
				result = ezApprovalGService.doCancelForce(docIDAry[i], userID, userInfo.getCompanyID(), userInfo.getTenantId());
				// 루프 도중에 하나라도 실패하면 트랙잭션에 오류를 발생시켜서 전체 DB작업을 롤백한다.
				if (!result.equals("OK")) {
					logger.debug("doCancelForce failed in draftAll loop[" + i + "], docID = " + docIDAry[i]);
					throw new Exception(); // ajax 동작에서 에러 발생 시, 페이지단의 doCancel_error() 함수가 동작한다.
				}
			}
		}
		
		if (result.equals("OK")) {
			result = "<RESULT>TRUE</RESULT>";
		} else {
			result = "<RESULT>FALSE</RESULT>";
		}
		
		logger.debug("doCancelForce ended, result = " + result);
		
		return result;
	}
	
	
	@RequestMapping(value = "/ezApprovalG/uploadDocHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String uploadDocHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,  HttpServletRequest request ,@RequestBody String xmlPara) throws Exception{
		logger.debug("uploadDocHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String docID = doc.getElementsByTagName("pDocID").item(0).getTextContent();
		String mode = doc.getElementsByTagName("mode").item(0).getTextContent();
		String pHTML = doc.getElementsByTagName("pHtml").item(0).getTextContent().replace("\r\n", "\n").replace("\n", "\r\n");
		String isBeforeDoc = doc.getElementsByTagName("ISBEFOREDOC").item(0).getTextContent();

		String companyId = userInfo.getCompanyID();
		int tenantId = userInfo.getTenantId();
		
		/* 2020-02-24 홍승비 - 편집전후 판단을 위하여 파일명에 문자 추가 */
		String oldYear = ezApprovalGService.getDocHrefYear(docID, companyId, tenantId);
		String fileName = docID + "-" + commonUtil.getTodayUTCTime("yyyyMMddHHmmss") + isBeforeDoc + "." + mode;
		String uploadApprovalRoot = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		String docDirName = ezApprovalGService.getDocDir(docID);
		String dirPath = uploadApprovalRoot + commonUtil.separator + companyId +  commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + docDirName + commonUtil.separator + "history" ;
		String dirPath2 = uploadApprovalRoot + commonUtil.separator + companyId +  commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + docDirName;
		String realPath = commonUtil.getRealPath(request);
		
		String originFileExt = ezApprovalGService.getDocExt(docID, companyId, tenantId);
		boolean useKlibEncryption = false;
		boolean useKlibBackup = false;
		
		// KLIB 암호화 처리 (마지막 결재자가 편집모드를 사용했을 때의 히스토리 파일은 결재 완료 프로세스가 끝낸 후에 저장되기 때문에 암호화가 안 되는 상태로 저장됨, 때문에 암호화하여 히스토리 파일을 저장해야함)
		// .ezd 확장자가 붙어있으면 결재완료된 문서로 판단함
		if (EzApprovalGKlibService.ENCRYPTED_FILE_EXT.equalsIgnoreCase(originFileExt)) {
			if ("yes".equalsIgnoreCase(ezCommonService.getTenantConfig("useApprovalKlib", tenantId))) {
				useKlibBackup = "yes".equalsIgnoreCase(ezCommonService.getTenantConfig("useApprovalKlibBackup", tenantId));
				useKlibEncryption = true;
			}
		}
		
		try {
			EzFile file = new EzFile(commonUtil.detectPathTraversal(realPath + dirPath2));
			if (!file.exists()) {
				file.mkdirs();
			}

			EzFile file2 = new EzFile(commonUtil.detectPathTraversal(realPath + dirPath));
			if (!file2.exists()) {
				file2.mkdirs();
			}
			
			byte[] fileBytes;
		
			if (mode.equals("hwp")) {
				fileBytes = Base64.decodeBase64(pHTML);
			} else {
				fileBytes = pHTML.getBytes("UTF-8");
			}
			
			if (useKlibEncryption) {
				if (useKlibBackup) {
					Path backupDirPath = Paths.get(realPath, uploadApprovalRoot, companyId, EzApprovalGKlibService.BACKUP_DIR_NAME, "doc", oldYear, docDirName, "history");
					
					EzFile backupDir = new EzFile(backupDirPath.toString()); // EzFAL을 이용한 백업 디렉토리 생성
					if (!backupDir.exists()) {
						backupDir.mkdirs();
					}
					
					// EzFAL EzFileOutputStream 사용 (자동 close 호출)
					try (EzFileOutputStream fos = new EzFileOutputStream(backupDirPath.resolve(fileName).toString())) {
						fos.write(fileBytes); // 백업 파일 저장
						fos.flush();
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
					}
					
					//Files.createDirectories(backupDir);
				//	commonUtil.writeBytesToFile(backupDirPath.resolve(fileName), fileBytes);
				}
				
				fileBytes = klibUtil.encrypt(fileBytes);
				fileName += "." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT;
			}
			
			Path outputFilePath = Paths.get(commonUtil.detectPathTraversal(realPath + dirPath + commonUtil.separator + fileName));
			//commonUtil.writeBytesToFile(outputFile, fileBytes);
			
			// EzFAL EzFileOutputStream 사용 (자동 close 호출)
			try (EzFileOutputStream fops = new EzFileOutputStream(outputFilePath.toString())) {
				fops.write(fileBytes); // Klib 암호화 및 확장자가 적용된 파일을 저장
				fops.flush();
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("uploadDocHistory ended");
		
		return dirPath + commonUtil.separator + fileName;
	}
	/**
	 * 전자결재G 문서 내용 변경 이력
	 */	
	@RequestMapping(value = "/ezApprovalG/updateDocHistory.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String updateDocHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,  HttpServletRequest request ,@RequestBody String xmlPara) throws Exception{
		logger.debug("updateDocHistory started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String docID = doc.getElementsByTagName("pDocID").item(0).getTextContent();
		String url = doc.getElementsByTagName("pURL").item(0).getTextContent();
		String userID = doc.getElementsByTagName("pUserID").item(0).getTextContent();
		String userName = doc.getElementsByTagName("pUserName").item(0).getTextContent();
		String userJobTitle = doc.getElementsByTagName("pUserJobTitle").item(0).getTextContent();
		String userDeptID = doc.getElementsByTagName("pUserDeptID").item(0).getTextContent();
		String userDeptName = doc.getElementsByTagName("pUserDeptName").item(0).getTextContent();
		String userName2 = doc.getElementsByTagName("PUSERNAME2").item(0).getTextContent();
		String userJobTitle2 = doc.getElementsByTagName("PUSERJOBTITLE2").item(0).getTextContent();
		String userDeptName2 = doc.getElementsByTagName("PUSERDEPTNAME2").item(0).getTextContent();
		String isBeforeDoc = doc.getElementsByTagName("ISBEFOREDOC").item(0).getTextContent();
		String beforeDocURL = doc.getElementsByTagName("BEFOREDOCURL").item(0).getTextContent();

		String editVersion = null;
		if (doc.getElementsByTagName("editVersion").item(0) != null) {
			editVersion = doc.getElementsByTagName("editVersion").item(0).getTextContent();
		}

		String editMode = null;
		if (doc.getElementsByTagName("editMode").item(0) != null) {
			editMode = doc.getElementsByTagName("editMode").item(0).getTextContent();
		}
		
		if (doc.getElementsByTagName("ORGCOMPANYID").getLength() > 0 && !doc.getElementsByTagName("ORGCOMPANYID").item(0).getTextContent().equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(doc.getElementsByTagName("ORGCOMPANYID").item(0).getTextContent());
		}
		
		/* 2020-02-24 홍승비 - 편집 전후 문서를 판단하기 위한 플래그 isBeforeDoc, 편집전문서 파일경로 beforeDocURL 추가 */
		String result = ezApprovalGService.updateHistoryForDoc(docID, url, userID, userName, userName2, userJobTitle, userJobTitle2, userDeptID, userDeptName, userDeptName2, isBeforeDoc, beforeDocURL, userInfo, editMode, editVersion);
		
		logger.debug("updateDocHistory ended");
		
		return result;
	}
	
	/**
	 * 전자결재S 결재정보 분류코드탭
	 */	
	@RequestMapping(value = "/ezApprovalG/getCodeTreeInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getCodeTreeInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getCodeTreeInfo started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String code = request.getParameter("code");
		String level = request.getParameter("level");
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = ezApprovalGService.getCodeTreeInfo(code, level, userInfo);

		logger.debug("getCodeTreeInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재S 결재정보 분류코드탭 서브트리
	 */	
	@RequestMapping(value = "/ezApprovalG/getCodeSubTreeInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getCodeSubTreeInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getCodeSubTreeInfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String code = request.getParameter("code");
		String level = request.getParameter("level");

		String result = ezApprovalGService.getCodeSubTreeInfo(code, level, userInfo);
		
		logger.debug("getCodeSubTreeInfo ended");
		
		return result;
	}
	
	/**
	 * 전자결재S 결재정보 분류코드 즐겨찾기
	 */	
	@RequestMapping(value = "/ezApprovalG/getFrequencyClassList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getFrequencyClassList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFrequencyClassList started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalGService.getFrequencyClassList(userInfo);

		logger.debug("getFrequencyClassList ended");
		
		return result;
	}

	/**
	 * 전자결재 문서정보이력 상세보기
	 */	
	@RequestMapping(value = "/ezApprovalG/docViewerCK.do", method = RequestMethod.GET)
	public String docViewerCK(HttpServletRequest request, Model model) throws Exception {
		logger.debug("docViewerCK started");

		String docID = request.getParameter("docHref");
		
		model.addAttribute("docID", commonUtil.cleanValue(docID));
		
		logger.debug("docViewerCK ended");
		
		return "ezApprovalG/apprGdocViewerCK";
	}
	
	/**
	 * 2020-02-25 홍승비 - 전자결재 문서정보이력 상세보기 (수정사항 비교가능)
	 */	
	@RequestMapping(value = "/ezApprovalG/docViewerCompare.do", method = RequestMethod.GET)
	public String docViewerCompare(HttpServletRequest request, Model model) throws Exception {
		logger.debug("docViewerCompare started");

		String pDocHrefAfter = request.getParameter("docHrefAfter");
		String pDocHrefBefore = request.getParameter("docHrefBefore");
		
		model.addAttribute("docHrefAfter", commonUtil.cleanValue(pDocHrefAfter));
		model.addAttribute("docHrefBefore", commonUtil.cleanValue(pDocHrefBefore));
		
		logger.debug("docViewerCompare ended");
		return "ezApprovalG/apprGdocViewerCompare";
	}
	
	/**
	 * 전자결재 문서정보이력에서 상세내역 저장하기
	 */	
	@RequestMapping(value = "/ezApprovalG/savePCTmpFile.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String savePCTmpFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("savePCTmpFile started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docTitle = request.getParameter("docTitle");
		String docHref = request.getParameter("docHref");
		String realPath = commonUtil.getRealPath(request);
		
		String path = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
		String subFolder = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyyMMdd"), userInfo.getOffset(), false);
		
		path += commonUtil.separator + subFolder + commonUtil.separator;
		
		File file = new File(commonUtil.detectPathTraversal(realPath + path)); // upload_common 경로의 파일이므로 EzFAL 적용 제외
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		/* 2018-09-19 홍승비 - 문서보기 > 변경내역의 결재문서이력 저장 시 파일명으로 사용할 수 없는 특수문자 제거 */
		docTitle = docTitle.replace("\\", "").replace("/", "").replace(":", "").replace("?", "").
                replace('"' + "", "").replace("*", "").replace("<", "").replace(">", "").replace("|", "");
		
		String saveFilePath = path + docTitle + ".mht";
		
		EzFAL.copyFile(new EzFile(commonUtil.detectPathTraversal(realPath + docHref)), new EzFile(commonUtil.detectPathTraversal(realPath + saveFilePath)));

		logger.debug("savePCTmpFile ended");
		
		return saveFilePath;
	}
	
	/**
	 * 전자결재S 양식 자동분류코드 겟
	 */	
	@RequestMapping(value = "/ezApprovalG/getAutoDocNumItemCode.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getAutoDocNumItemCode(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getAutoDocNumItemCode started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.getAutoDocNumItem(formID, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("getAutoDocNumItemCode ended");
		
		return result;
	}
	
	/**
	 * 전자결재S 재발송 페이지 (전자결재G에서는 미사용)
	 */	
	@RequestMapping(value = "/ezApprovalG/docReSend.do", method = RequestMethod.GET)
	public String docReSend(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("docReSend started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String susinAdmin = "";
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		
		String docInfo = ezApprovalGService.getDocInfo(docID, "END", "ALL", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
		
		Document doc = commonUtil.convertStringToDocument(docInfo);
		
		String formID = doc.getElementsByTagName("FORMID").item(0).getTextContent();
		String writerID = doc.getElementsByTagName("WRITERID").item(0).getTextContent();
		
		if (!userInfo.getId().equals(writerID)) {
			return "main/warning";
		}
		
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String preSusinGroupStr = ezApprovalGService.getCode2Name("A53", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("docID", docID);
		model.addAttribute("formID", formID);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("docHref", docHref);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("oldYear", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(0, 4));
		model.addAttribute("preSusinGroupStr", preSusinGroupStr);
		
		logger.debug("docReSend ended");
		
		return "ezApprovalG/apprGDocReSend";
	}

	/**
	 * 전자결재S 재발송 
	 */	
	@RequestMapping(value = "/ezApprovalG/sendOffer.do", produces ="text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String sendOffer(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlPara) throws Exception {
		logger.debug("sendOffer started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		Document docXML = commonUtil.convertStringToDocument(xmlPara);
		
		String result = ezApprovalGService.doSendOfferS(docXML, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		logger.debug("sendOffer ended");
		
		return result;
	}
	
	/**
	 * 전자결재S 유저 주소 가져오기 (양식상의 habyuiaddress 필드 맵핑을 위한 기능이나, 2024-05-31 기준으로 확인 시 양식작성창에 habyuiaddress 필드 추가 UI가 없어 실제로 사용되지는 않고 있음)
	 */
	@RequestMapping(value = "/ezApprovalG/getAddress.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getAddress(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getAddress started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userIDs = request.getParameter("userID");
		String[] userIDArray = userIDs.split(",");
		
		List<String> addressArray = ezApprovalGService.getAddress(userIDArray, userInfo.getTenantId());
		
		String result = StringUtils.join(addressArray, "||"); 

		logger.debug("getAddress ended");
		
		return result;
	}
	
	/**
	 * 전자결재S 라스트합의 APRMEMBERSN 가져오기
	 */
	@RequestMapping(value = "/ezApprovalG/getSameOrgHAPYUIDoc.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getSameOrgHAPYUIDoc(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getSameOrgHAPYUIDoc started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getSameOrgHAPYUIDoc(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		logger.debug("getSameOrgHAPYUIDoc ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/checkResend.do", produces = "text/plain;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String checkResend(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlPara) throws Exception {
		logger.debug("checkResend started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String docID = doc.getElementsByTagName("DOCID").item(0).getTextContent();
		
		String result = ezApprovalGService.checkResend(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("result=" + result);
		logger.debug("checkResend ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/setHeSongHapyuiDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setHeSongHapyuiDocInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody String xmlPara) throws Exception {
		logger.debug("setHeSongHapyuiDocInfo started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		userInfo.setRealPath(commonUtil.getRealPath(request));

		String result = ezApprovalGService.doHabyuiHesong(doc, dirPath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo, "");
		
		logger.debug("result=" + result);
		logger.debug("setHeSongHapyuiDocInfo ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/deleteSignInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String deleteSignInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("deleteSignInfo started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String result = "";
		
		/* 2023-12-07 홍승비 - 일괄기안된 결재문서 > 재기안 동작 등 서명 데이터 삭제 > 1안뿐만이 아니라 각 안 별로 서명 데이터를 삭제하도록 수정 */
		List<ApprGGroupDocInfoVO> groupDocInfoList = new ArrayList<ApprGGroupDocInfoVO>();
		String groupDocSN = ezApprovalGService.getGroupDocSN(docID, userInfo.getTenantId(), userInfo.getCompanyID());
		
		if (groupDocSN != null && !groupDocSN.equals("")) {
			// 서명 데이터를 삭제하기 위해 docID값만 사용하므로, v_MODE값은 공백으로 전달(임시저장된 문서에는 서명 데이터가 존재하지 않으므로 분기처리 하지 않음) 
			groupDocInfoList = ezApprovalGService.getGroupDocList(groupDocSN, "", userInfo.getTenantId(), userInfo.getCompanyID());
			
			for (ApprGGroupDocInfoVO tempVO : groupDocInfoList) {
				result = ezApprovalGService.deleteSignInfo(tempVO.getDocID(), userInfo.getCompanyID(), userInfo.getTenantId());
			}
		}
		else { // 기존 단일기안문서 서명 데이터 삭제 분기
			result = ezApprovalGService.deleteSignInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		
		logger.debug("deleteSignInfo ended, result = " + result);
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/delCirculation.do", method = RequestMethod.POST)
	@ResponseBody
	public void delCirculation(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("delCirculation started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		logger.debug("delCirculation docID : " + docID);

		ezApprovalGService.delCirculation(docID, userInfo.getCompanyID(), userInfo.getTenantId());

		logger.debug("delCirculation ended");
	}
	
	/**
	 * @return  전자결재G 문서유통 재발송 요청한 문서에 요청 시 의견 표출
	 */
	@RequestMapping(value = "/ezApprovalG/getRelayReqOpinion.do", method = RequestMethod.POST)
	public String getRelayReqOpinion(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getRelayReqOpinion started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		List<String> reqDeptIDs = ezApprovalGService.getRelayReqDeptID(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		StringBuffer sb = new StringBuffer();
		
		for (String deptID : reqDeptIDs) {
			String filePath = commonUtil.getRealPath(servletContext) + commonUtil.getUploadPath("upload_relay.R_DocPath", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "ExOpinion" + commonUtil.separator + docID + deptID.split(":")[0] + "return.txt";
			//기관명 명시해주기 
			sb.append(deptID.split(":")[1] + " : ");
			
			try (BufferedReader br = new BufferedReader(new FileReader(new EzFile(commonUtil.detectPathTraversal(filePath)).getFile()))) {
				String readLine = "";
				
				while ((readLine = br.readLine()) != null) {
					sb.append(new String(Base64.decodeBase64(readLine), "euc-kr"));
				}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
			
			sb.append("<br/>");
			sb.append("<br/>");
		}
		
		String textOpinion = sb.toString();
		
		if (textOpinion == null || textOpinion.equals("")) {
			textOpinion = "의견정보가 없습니다.";
		}
		
		model.addAttribute("opinion", textOpinion);
		
		logger.debug("getRelayReqOpinion ended");
		
		return "json";
	}
	
	/**
	 * @return 중계문서 재전송 요청 의견 호출
	 */
	@RequestMapping(value = "/ezApprovalG/ezRetOpinon.do", method = RequestMethod.GET)
	public String ezRetOpinon() throws Exception {
		logger.debug("ezRetOpinon started");


		logger.debug("ezRetOpinon ended");
		return "ezApprovalG/apprGezRetOpinon";
	}
	
	/**
	 * 전자결재G 기록물철 삭제
	 */
	@RequestMapping(value = "/ezApprovalG/deleteCabInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteCabInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("deleteCabInfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String cabinetID = request.getParameter("cabClassNO");
		String ipAddress = request.getLocalAddr(); 
		
		String deleteResult = ezApprovalGService.deleteCapInfo(cabinetID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		// 2023-05-23 이사라 : 시큐어코딩 문자열 비교 오류 수정
		// 표준에서는 삭제버튼을 숨김처리하여 사용하지 않고 있음
		// 이 기능을 살리기 위해서는 ezApprovalGService.deleteCapInfo, insertDelCapInfo 내의 코드도 수정이 필요 함
		// 우선 사용하지 않고 있어서 단순 문자열 비교만 처리 함
		if (!"TRUE".equalsIgnoreCase(deleteResult)) {
			logger.debug("error");
		}
		String insertResult = ezApprovalGService.insertDelCapInfo(cabinetID, userInfo.getId(), ipAddress, userInfo.getCompanyID(), userInfo.getTenantId());
		if (!("TRUE".equalsIgnoreCase(deleteResult) && "TRUE".equalsIgnoreCase(insertResult))) {
			logger.debug("error");
		}
		
		logger.debug("deleteCabInfo ended");
		
		return "TRUE";
	}
	
	@RequestMapping(value = "/ezApprovalG/selectExpCabDocInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String selectExpCabDocInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("selectExpCabDocInfo started");
		String cabinetID = request.getParameter("cabClassNO");
		String result = ezApprovalGService.selectExpCabDocInfo(cabinetID);
		
		logger.debug("selectExpCabDocInfo ended");
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/deleteOpinionTypeInfo.do", method = RequestMethod.POST)
	public String deleteOpinionTypeInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("deleteOpinionTypeInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String opinionType = request.getParameter("opinionType");
		
		ezApprovalGService.deleteOpinionTypeInfo(docID, opinionType, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("deleteOpinionTypeInfo ended.");
		
		return "json";
	}
	
	@RequestMapping(value = "/ezApprovalG/delOpinionsExceptHesong.do", method = RequestMethod.POST)
	public String delOpinionsExceptHesong(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("delOpinionsExceptHesong started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		
		ezApprovalGService.delOpinionsExceptHesong(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("delOpinionsExceptHesong ended.");
		
		return "json";
	}
	
	@RequestMapping(value = "/ezApprovalG/delOpinionsExceptDrafters", method = RequestMethod.POST)
	public String delOpinionsExceptDrafters(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("delOpinionsExceptDrafters started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		
		ezApprovalGService.delOpinionsExceptDrafters(docID, userID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("delOpinionsExceptDrafters ended.");
		
		return "json";
	}
	
	/**
	 * 전자결재G 재배부 후 재배부의견을 제외한 모든의견 삭제
	 */
	@RequestMapping(value = "/ezApprovalG/OpinionDel2.do", method = RequestMethod.POST)
	public String OpinionDel2(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("OpinionDel2 started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		
		ezApprovalGService.OpinionDel2(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("OpinionDel2 ended.");
		
		return "json";
	}
	
	/**
	 * 전자결재G 중계문서 접수 시 재배부의견은 삭제처리
	 */
	@RequestMapping(value = "/ezApprovalG/OpinionDel3.do", method = RequestMethod.POST)
	public String OpinionDel3(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("OpinionDel3 started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		
		ezApprovalGService.OpinionDel3(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("OpinionDel3 ended.");
		
		return "json";
	}
	
	/**
	 * 직인의뢰접수화면 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezConvOut.do", method = RequestMethod.GET)
	public String ezConvOut(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezConvOut started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("approvalPWD", approvalPWD);
		
		logger.debug("ezConvOut ended.");
		
		return "/ezApprovalG/apprGezConvOut";
	}
	
	/**
	 * 직인의뢰 접수 Method
	 */
	@RequestMapping(value = "/ezApprovalG/updateSusinState.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateSusinState(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("updateSusinState started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String mode = request.getParameter("mode");
		String deptID = request.getParameter("deptID");
		
		String result = ezApprovalGService.updateSusinState(docID, mode, deptID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("updateSusinState ended.");
		
		return result;
	}
	
	/**
	 * 전자결재 민원인주소 우편번호검색 사용 여부 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getUseZipCodeSearchInApr.do", method = RequestMethod.POST)
	@ResponseBody
	public String getUseZipCodeSearchInApr(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getUseZipCodeSearchInApr started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezCommonService.getTenantConfig("useZipCodeSearchInApr", userInfo.getTenantId());
		
		logger.debug("getUseZipCodeSearchInApr ended.");
		
		return result;
	}	
	/*
	 * 2018-05-14 강민수92 문서의 확장자 체크
	 */
	@RequestMapping(value="/ezApprovalG/checkDocExt.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String checkDocExt(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("checkDocExt started");
		userInfo = commonUtil.userInfo(loginCookie);
		String docID = request.getParameter("docID");
		String companyID = userInfo.getCompanyID();
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			companyID = orgCompanyID;
		}
		
		int tenantID = userInfo.getTenantId();
		
		String ext = ezApprovalGService.getDocExt(docID, companyID, tenantID);
		
		logger.debug("checkDocExt ended");
		return ext;
	}
	/* 2018-06-18 천성준
	 * 비전자문서 부서수신함에서 문서를 열었을때 호출됨.
	 * return 비전자문서XML
	 * */
	@RequestMapping(value="/ezApprovalG/getNonElecInfoSusinInit.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getNonElecInfoSusinInit(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getNonElecInfoSusinInit started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String docID = request.getParameter("docID");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();

		String result = ezApprovalGService.getNonElecInfoSusinInit(docID, companyID, tenantID);
		logger.debug("getNonElecInfoSusinInit ended.");
		return result;
	}

	/* 2018-06-18 천성준
	 * 비전자문서 수신처 등록 메소드
	 * */
	@RequestMapping(value = "/ezApprovalG/nonElecRecSusinInit.do", method = RequestMethod.POST)
	@ResponseBody
	public void nonElecRecSusinInit(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("nonElecRecSusinInit started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");

		ezApprovalGService.setNonElecRecSusinInit(docID, userInfo.getDeptID(), userInfo.getDeptName(), userInfo.getDeptName2(), userInfo.getCompanyID(), userInfo.getTenantId());

		logger.debug("nonElecRecSusinInit ended.");
	}

	/* 2018-06-21 천성준
	 * 비전자문서 접수 후, 임시 캐비넷 아이디 선택 캐비넷 아이디로 바꿈
	 * */
	@RequestMapping(value = "/ezApprovalG/nonElecRecTempCabSwitch.do", method = RequestMethod.POST)
	@ResponseBody
	public void nonElecRecTempCabSwitch(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("nonElecRecTempCabSwitch started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String orgDocID = request.getParameter("orgDocID");
		String nonElecRecXML = request.getParameter("xml");

		ezApprovalGService.setNonElecRecCabID(docID, orgDocID, nonElecRecXML, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLocale());

		logger.debug("nonElecRecTempCabSwitch ended.");
	}

	/* 2018-07-17 천성준
	 * 비전자문서 등록 후, 바로 기안자 문서함에서 삭제
	 * */
	@RequestMapping(value = "/ezApprovalG/setNonElecRecDocDel.do", method = RequestMethod.POST)
	@ResponseBody
	public void setNonElecRecDocDel(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setNonElecRecDocDel started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");

		ezApprovalGService.setNonElecRecDocDelFlag(docID, userInfo.getCompanyID(), userInfo.getTenantId());

		logger.debug("setNonElecRecDocDel ended.");
	}
	
	/* 2018-07-18 천성준
	 * 수신된 비전자문서 삭제 버튼 Action
	 * */
	@RequestMapping(value = "/ezApprovalG/susinNonElecRecDocDel.do", method = RequestMethod.POST)
	@ResponseBody
	public String susinNonElecRecDocDel(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("susinNonElecRecDocDel started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		
		String result = ezApprovalGService.susinNonElecRecDocDel(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("susinNonElecRecDocDel ended. result = " + result);
		
		return result;
	}
	
	/* 2018-07-18 천성준
	 * 비전자문서 여부
	 * */
	@RequestMapping(value = "/ezApprovalG/checkNonElecRec.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkNonElecRec(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("checkNonElecRec started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String orgDocID = request.getParameter("orgDocID");
		String rtnVal = "";
		
		String result = ezApprovalGService.checkNonElecRec(orgDocID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (result.equals("Y")) {
			rtnVal = "TRUE";
		} else {
			rtnVal = "FALSE";
		}
		
		logger.debug("checkNonElecRec ended. result = " + rtnVal);
		
		return rtnVal;
	}
	
	/* 2018-10-24 배현상
	 * 결재상태 여부(진행, 보류인지 검사), 중복결재를 방지하기 위한 검사
	 */
	@RequestMapping(value = "/ezApprovalG/checkAprState.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkAprState(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("checkAprState started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		if ("NO".equalsIgnoreCase(ezCommonService.getTenantConfig("useShareApproval", userInfo.getTenantId()))) return "TRUE";
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String docState = request.getParameter("docState");
		String aprMemberSN = request.getParameter("aprMemberSN");
		String companyID = userInfo.getCompanyID();
		String retValue = "";
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		} 
		
		int result = ezApprovalGService.getCheckAprState(docID, userID, docState, aprMemberSN, userInfo.getCompanyID(), userInfo.getTenantId());
			
		if (result > 0) {
			retValue = "TRUE";
		} else {
			retValue = "FALSE";
		}
		
		logger.debug("checkAprState ended");
		return retValue;
	}
	
	@RequestMapping(value = "/ezApprovalG/checkHabYuiState.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkHabYuiState(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("checkHabYuiState started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		
		String result = ezApprovalGService.checkHabYuiState(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("checkHabYuiState ended.");
		return result;
	}
	
	/* 
	 * 회송문서의 철정보를 원문서 정보로 변경
	 * */
	@RequestMapping(value = "/ezApprovalG/setHesongCabinetInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public void setHesongCabinetInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setHesongCabinetInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		
		ezApprovalGService.setHesongCabinetID(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("setHesongCabinetInfo ended.");
	}
	
	/**
	 * 전자결재G 부서(병렬,순차)합의 Method
	 */
	@RequestMapping(value = "/ezApprovalG/recevGDeptHapyui.do", method = RequestMethod.GET)
	public String recevGDeptHapyui(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("recevGDeptHapyui started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String draftFlag = request.getParameter("draftFlag");
		String susinAdmin = "";
		String optSignDateFormat = "";
		String optisSplit = "";
		String optSplitKind = "";
		String useDirectSign = "";
		String draftDate = "";
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());
		String signImageSize = ezCommonService.getTenantConfig("SignImageSize", userInfo.getTenantId());
		String signImageType = ezCommonService.getTenantConfig("signImageType", userInfo.getTenantId());
		String draftDeptID = ezApprovalGService.getOrgDraftDeptID(docID, userInfo.getTenantId(), userInfo.getCompanyID());
		String isReDraft = request.getParameter("isReDraft");
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		
		//부서합의문에서 채번하기 위해 수정 2019-02-08 홍대표
		String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());

		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		
		if (approvalFlag.equals("S")) {
			optisSplit = ezApprovalGService.getOptionInfo("SA33", "001", userInfo, "CODE");
		} else {
			optisSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		}
		optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
		
		useDirectSign = ezCommonService.getTenantConfig("USE_DirectSign", userInfo.getTenantId());
		
		draftDate = commonUtil.getTodayUTCTime("");
		
		if (approvalFlag.equals("G")) {
			String nonElecRec = ezApprovalGService.checkNonElecRec(docID, userInfo.getCompanyID(), userInfo.getTenantId());
			if (!nonElecRec.equals("")) {
				model.addAttribute("nonElecRec", nonElecRec);
			}
		}
		
		/* 2020-11-13 홍승비 - 대용량첨부 관련 파라미터 추가 */
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
		String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String bigAttachFileMinSaveDate = ezApprovalGService.getAttachFileMinSaveDate(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String bigAttachDownloadPeriod = bigAttachFileMinSaveDate + " ~ " + EgovDateUtil.addDay(bigAttachFileMinSaveDate, Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");

		// 2023-05-26 조수빈 - 전자결재 첨부파일  미리보기 기능 사용 여부
		String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		
		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
			useAprFilePrvw = "1";
		} else {
			useAprFilePrvw = "0";
		}
				
		model.addAttribute("docID", docID);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optisSplit", optisSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("useDirectSign", useDirectSign);
		model.addAttribute("draftDate", draftDate);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("junGyulFlag", junGyulFlag);
		model.addAttribute("signImageSize", signImageSize);
		model.addAttribute("signImageType", signImageType);
		model.addAttribute("draftDeptID", draftDeptID);
		model.addAttribute("useReceiveDocNo", useReceiveDocNo);
		model.addAttribute("docNumZeroCnt", docNumZeroCnt);
		model.addAttribute("isReDraft", isReDraft);
		model.addAttribute("useOpenGov", config.getProperty("config.useOpenGov"));
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		model.addAttribute("isPreview", isPreview);
		model.addAttribute("useAprFilePrvw", useAprFilePrvw);

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
		
		logger.debug("recevGDeptHapyui ended");

		return "ezApprovalG/apprGrecevGDeptHapyui";
	}
	
	/* 
	 * 회송문서의 철정보를  선택한 철 정보로 변경
	 * */
	@RequestMapping(value = "/ezApprovalG/setHesongBansongCabinetInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public void setHesongBansongCabinetInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setHesongBansongCabinetInfo started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String cabinetID = request.getParameter("cabinetID");
		String taskCode = request.getParameter("taskCode");
		logger.debug("docID = " + docID + ", cabinetID = " + cabinetID + ", taskCode = " + taskCode);
		
		//철정보 변경을 못하면 에러처리하기위해
		if (docID == null || cabinetID == null || taskCode == null) {
			Exception Exception = new Exception();
			throw Exception;
		}
		
		/* 2022-03-11 홍승비 - 일괄기안된 문서의 경우, 모든 안에 대하여 철변경 진행 */
		List<ApprGGroupDocInfoVO> groupDocInfoList = new ArrayList<ApprGGroupDocInfoVO>();
		String groupDocSN = ezApprovalGService.getGroupDocSN(docID, userInfo.getTenantId(), userInfo.getCompanyID());
		
		if (groupDocSN != null && !groupDocSN.equals("")) {
			groupDocInfoList = ezApprovalGService.getGroupDocList(groupDocSN, "TMP", userInfo.getTenantId(), userInfo.getCompanyID());
			for (ApprGGroupDocInfoVO tempVO : groupDocInfoList) {
				ezApprovalGService.setHesongBansongCabinetID(tempVO.getDocID(), cabinetID, taskCode, userInfo.getCompanyID(), userInfo.getTenantId());
			}
		}
		else { // 기존 단일기안문서 철변경 진행 분기
			ezApprovalGService.setHesongBansongCabinetID(docID, cabinetID, taskCode, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		
		logger.debug("setHesongBansongCabinetInfo ended.");
	}
	
	/* 
	 * 기안창 기안자 부서 정보와 현재 사용자의 부서 정보가 같은지 체크
	 * */
	@RequestMapping(value = "/ezApprovalG/checkDeptAndCabinetId.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkDeptAndCabinetId(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("checkDeptAndCabinetId started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String orgDeptId = request.getParameter("orgDeptId");
		String orgCabinetId = request.getParameter("orgCabinetId");
		String userRealDeptId = ezOrganService.getUserOrgDeptId(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		List<OrganUserVO> list = ezOrganAdminService.getUserAddJobList(userInfo.getId(), userInfo.getPrimary(), userInfo.getTenantId());
		
		// 1 : 정상 , 2 : 기록물철 변경, 3 : 겸직변경 필요, 4 : 부서변경 or 겸직삭제
		//기안창의 부서와 현재 유저의 부서정보 비교
		if (userInfo.getDeptID().equals(orgDeptId)) {
			if (!orgCabinetId.equals("") && !orgCabinetId.equals("nonElecRecTempCabinet") && approvalFlag.equals("G")) {
				String cabinetDept = ezApprovalGService.getDeptIdOfCabinet(orgCabinetId, userInfo.getTenantId(), userInfo.getCompanyID()).trim();
				logger.debug("cabinetDept : " + cabinetDept);
				logger.debug("orgDeptId : " + orgDeptId);
				//기안창 부서와 기록물철 부서 정보가 다를경우
				if (!orgDeptId.equals(cabinetDept)) {
					//기록물철 정보를 변경하라는 메세지
					return  "2";
				}
			}
			//정상일경우
			return "1";
		} else {
			//사용자의 원부서와 비교 
			if (orgDeptId.equals(userRealDeptId)) {
				//겸직변경 메세지
				return "3";
			}
			
			for (OrganUserVO userVO : list) {
				if (orgDeptId.equals(userVO.getDepartment())) {
					//겸직부서 변경 메세지
					return "3";
				}
			}
			
			///여기까지 왔으면 부서가 없는 것
			// 부서가 변경되거나 겸직부서가 삭제되었습니다 메세지
			return "4";
		}
	}
	
	/**
	 * 전자결재G 기안 의견버튼 호출 Method_New
	 */
	@RequestMapping(value = "/ezApprovalG/aprOpinionNew.do", method = RequestMethod.GET)
	public String aprOpinionNew(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		logger.debug("aprOpinionNew started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		/* 2023-07-19 민지수 - [추가의견] 버튼 클릭 시 의견창 모드값 전달 */
		String opMode = request.getParameter("opMode");

		/* 2024-06-24 양지혜 - 지정반송 사용 여부 */
		String returnByDesignationUsed = ezCommonService.getTenantConfig("ReturnByDesignationUsed", userInfo.getTenantId());
		if (returnByDesignationUsed == null || returnByDesignationUsed.equals("")) {
			returnByDesignationUsed = "NO";
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("primary", commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("opMode",opMode);
		model.addAttribute("DesignationUsed", returnByDesignationUsed);

		logger.debug("aprOpinionNew ended.");
		return "ezApprovalG/apprGaprOpinionNew";
	}
	/**
	 * 전자결재G 기안 의견내용 작성 팝업 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprOpinionPopup.do", method = RequestMethod.GET)
	public String aprOpinionPopup(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		logger.debug("aprOpinionPopup started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);

		/* 2024-06-24 양지혜 - 지정반송 > 반송위치에 표출할 결재라인 호출 */
		String docID = request.getParameter("docID");
		if (docID != null && !docID.equals("")) {
			String returnUserList = ezApprovalGService.getReturnUserList(docID, userInfo.getTenantId(), userInfo.getCompanyID());
			model.addAttribute("aprUserList", returnUserList);
		}

		model.addAttribute("primary", commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()));
		
		logger.debug("aprOpinionPopup ended.");
		return "ezApprovalG/apprGaprOpinionPopup";
	}
	
	/**
	 * @param model
	 * @param request
	 * @return
	 * 오피스결재에서 오피스문서파일을 업로드 하는 화면
	 */
	@RequestMapping(value = "/ezApprovalG/officeAttach.do", method = RequestMethod.GET)
	public String officeAttach(Model model, HttpServletRequest request) {
		logger.debug("officeAttach started.");
//		model.addAttribute("converterServerURL", config.getProperty("config.officeConverterServerURL"));
		logger.debug("officeAttach ended.");
		return "ezApprovalG/officeAttach";
	}
	
	/**
	 * @param request
	 * @return
	 * @throws Exception
	 * 오피스결재에서 오피스문서파일을 서버에 올리는 과정
	 */
//	@ResponseBody
//	@RequestMapping(value = "/ezApprovalG/officeUpload.do", method = RequestMethod.POST)
//	public ResponseEntity<JSONObject> officeUpload(MultipartHttpServletRequest request) throws Exception {
//		logger.debug("officeUpload started.");
//		
//		String docId = request.getParameter("docId");
//		int tenantId = Integer.parseInt(request.getParameter("tenantId"));
//		String companyId = request.getParameter("companyId");
//		String userId = request.getParameter("userId");
//		MultipartFile file = request.getFile("fileToUpload");
//		
//		// 변환솔루션이 다른 서버에 설치되어있을 경우, 이 경로를 변환솔루션 서버에 마운트 시켜야함
//		String tempUploadPath = config.getProperty("config.officeTempUploadPath");
//				
//		JSONObject convertedImgInfo = ezApprovalGService.convertDocumentToImg(file, tempUploadPath, docId, tenantId, companyId, userId);	
//	
//		logger.debug("officeUpload ended.");
//		return new ResponseEntity<JSONObject>(convertedImgInfo, HttpStatus.OK);	
//	}
	
	
	/**
	 * @param request
	 * @return
	 * @throws Exception
	 * 오피스결재에서 오피스문서파일을 서버에 올리는 과정
	 */
	@ResponseBody
	@RequestMapping(value = "/ezApprovalG/officeUpload.do", method = RequestMethod.POST)
	public String officeUpload(MultipartHttpServletRequest request) throws Exception {
		logger.debug("officeUpload started.");
		
		String docId = request.getParameter("docId");
		
		String companyId = request.getParameter("companyId");
		String userId = request.getParameter("userId");
		String ext = request.getParameter("ext");
		MultipartFile file = request.getFile("fileToUpload");
 		int tenantId = Integer.parseInt(request.getParameter("tenantId"));

		// 변환솔루션이 다른 서버에 설치되어있을 경우, 이 경로를 변환솔루션 서버에 마운트 시켜야함
//		String tempUploadPath = config.getProperty("config.officeTempUploadPath");
				
		String convertedImgInfo = ezApprovalGService.convertDocumentToImg(file, request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort(), docId, tenantId, companyId, userId, ext);
	
		logger.debug("officeUpload ended.");
		return convertedImgInfo;	
	}

	@RequestMapping(value = "/ezApprovalG/enforceSihangDocView.do", method = RequestMethod.GET)
	public String enforceSihangDocView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
		logger.debug("enforceSihangDocView started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String pRealPath = commonUtil.getRealPath(request);
		String pDocID = request.getParameter("pDocID");
		//String pFormID = request.getParameter("pFormID");
		String pFormURL = request.getParameter("pFormURL");
		//String pFormType = request.getParameter("pFormType");
		String pDocHref = request.getParameter("pDocHref");
		String pCompanyID = request.getParameter("pOrgCompanyID") != null ? request.getParameter("pOrgCompanyID") : userInfo.getCompanyID();
		
		String rtnVal = ezApprovalGService.enforceSihangDoc(pFormURL, pDocHref, pRealPath, userInfo.getLocale(), pCompanyID, userInfo.getTenantId());
		
		model.addAttribute("docID", pDocID);
		model.addAttribute("docHref", rtnVal);
		model.addAttribute("orgDocHref", pDocHref);
		model.addAttribute("companyID", pCompanyID);
		
		logger.debug("enforceSihangDocView ended.");

        return "ezApprovalG/apprGenforceSihangDocView";
    }

	/**
	 * 결재정보 원문공개정보 저장
	 */
	@RequestMapping(value = "/ezApprovalG/openGovInfoSave.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String openGovInfoSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("openGovInfoSave started.");
		  
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String openGovListFlag = request.getParameter("openGovListFlag");
		String fileOpenFlagList = request.getParameter("fileOpenFlagList");
		String basis = request.getParameter("basis");
		String reason = request.getParameter("reason");
		String publicity = request.getParameter("publicity");
		String docID = request.getParameter("docID");
		String limitDate = request.getParameter("limitDate");
		
		String result = ezApprovalGService.openGovInfoSave(openGovListFlag, fileOpenFlagList, basis, reason, publicity, docID, limitDate, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("openGovInfoSave ended.");
		
 		return result;
	}
	/**
	 * 기록물등록대장 원문공개수정
	 */
	@RequestMapping(value = "/ezApprovalG/updateOpenGovInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String updateOpenGovInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("updateOpenGovInfo started.");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String openGovListFlag = request.getParameter("listOpenFlag");
		String fileOpenFlagList = request.getParameter("fileOpenFlagList");
		String basis = request.getParameter("basis");
		String reason = request.getParameter("reason");
		String publicity = request.getParameter("publicityCode");
		String limitDate = request.getParameter("openLimitDate");
		String modifyReason = request.getParameter("modifyReason");

		String result = ezApprovalGService.updateOpenGovInfo(openGovListFlag, fileOpenFlagList, basis, reason, publicity, docID, limitDate, userInfo.getCompanyID(), userInfo.getTenantId(), modifyReason, userInfo);
		
		logger.debug("updateOpenGovInfo ended.");
		
		return result;
	}
	
	/* 
	 * 결재정보 첨부리스트 호출
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezApprovalG/getAttachListForOpenGov.do", produces = "application/json;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public JSONArray getAttachListForOpenGov(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getAttachListForOpenGov started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String endFlag = request.getParameter("endFlag");
		logger.debug("docID = " + docID);
		
		List<ApprGOpenGovAttachVO> attachList = ezApprovalGService.getAttachListForOpenGov(docID, endFlag, userInfo.getCompanyID(), userInfo.getTenantId());
		
		JSONObject attachJson = null;
		
		JSONArray attachJsonArr = new JSONArray();
		
		for (ApprGOpenGovAttachVO attach : attachList) {
			attachJson = new JSONObject();
			attachJson.put("fileOpenFlag", attach.getFileOpenFlag());
			attachJson.put("sn", attach.getAttachFileSN());
			attachJson.put("fileName", attach.getDisplayName());
			
			String fileSize = attach.getAttachFileSize();
			
			int cnt = (int) (Math.log10(Double.parseDouble(fileSize)) / Math.log10(1024));
			String[] unit = {"bytes", "KB", "MB", "GB"};
			
			double filesize = Double.parseDouble(fileSize) / Math.pow(1024, cnt);
			fileSize = String.format("%.1f",filesize);
			fileSize = fileSize + unit[cnt];
			
			attachJson.put("fileSize", fileSize);
			
			attachJsonArr.add(attachJson);
		}
		
		logger.debug("getAttachListForOpenGov ended.");
		return attachJsonArr;
	}

	/* 
	 * 원문정보 수정
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezApprovalG/getOpenGovInfoForUpdate.do", produces = "application/json;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getOpenGovInfoForUpdate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getOpenGovInfoForUpdate started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		logger.debug("docID = " + docID);
		
		ApprGOpenGovInfoVO openGovInfo = ezApprovalGService.getOpenGovInfoForUpdate(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		JSONObject openGovJson = new JSONObject();
		openGovJson.put("openGovInfo", openGovInfo);
		
		logger.debug("getOpenGovInfoForUpdate ended.");

		return openGovJson;
	}

	@RequestMapping(value = "/ezApprovalG/enforceSihangSealChoose.do", method = RequestMethod.GET)
	public String enforceSihangSealChoose(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
		logger.debug("enforceSihangSealChoose started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		logger.debug("enforceSihangSealChoose ended.");
		
		return "ezApprovalG/apprGenforceSihangSealChoose";
	}
	
	@RequestMapping(value = "/ezApprovalG/enforceSihangDocSave.do", method = RequestMethod.POST)
	public String enforceSihangDocSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
		logger.debug("enforceSihangDocSave started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String pDocHref = request.getParameter("pDocHref");
		String pMhtBody = request.getParameter("pMhtBody");
		String realPath = commonUtil.getRealPath(request);
		
		String convertedMht = ezCommonService.startHtml2Mht(pMhtBody, realPath, userInfo.getLocale());
		
		try {
			// EzFAL EzFileOutputStream 사용 (자동 close 호출)
			try (EzFileOutputStream fos = new EzFileOutputStream(commonUtil.detectPathTraversal(realPath + pDocHref))) {
				fos.write(convertedMht.getBytes());
				fos.flush();
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("enforceSihangDocSave ended.");
		return "";
	}

	/*
	 * 한글일괄기안 원문정보 가져오기
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezApprovalG/getOpenGovDocInfo.do", produces = "application/json;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getOpenGovDocInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getOpenGovDocInfo started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		logger.debug("docID = " + docID);

		Map<String, Object> openGovMap = ezApprovalGService.getOpenGovInfo(docID, userInfo.getTenantId(), userInfo.getCompanyID());

		JSONObject openGovJson = new JSONObject();
		openGovJson.put("basis", openGovMap.get("basis"));
		openGovJson.put("reason", openGovMap.get("reason"));
		openGovJson.put("listOpenFlag", openGovMap.get("listOpenFlag"));
		openGovJson.put("fileOpenFlagList", openGovMap.get("fileOpenFlagList"));

		logger.debug("getOpenGovDocInfo ended.");

		return openGovJson;
	}
	
	 /**
	  * 2020-02-18 홍승비 - 회사관인/부서별관인(직인) 선택 레이어팝업 호출 메서드
	  * */
	@RequestMapping(value = "/ezApprovalG/selectSeal.do", method = RequestMethod.GET)
	public String selectSeal() throws Exception {
		return "ezApprovalG/apprGselectSeal";
	}
	
    /**
     * 전자결재G 대외문서 접수시 접수부서 정보 업데이트 Method
     */
    @RequestMapping(value = "/ezApprovalG/updateReceivedDept.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
    @ResponseBody
    public String updateReceivedDept(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
        logger.debug("updateReceivedDept started.");

        userInfo = commonUtil.aprUserInfo(loginCookie);

        String docID = request.getParameter("docID");
        String processorID = request.getParameter("processorID");
        String processorName = request.getParameter("processorName");
        String processorJobTitle = request.getParameter("processorJobTitle");
        String receivedDeptID = request.getParameter("receivedDeptID");
        String receivedDeptName = request.getParameter("receivedDeptName");
        String processorName2 = request.getParameter("processorName2");
        String processorJobTitle2 = request.getParameter("processorJobTitle2");
        String receivedDeptName2 = request.getParameter("receivedDeptName2");

        String result = ezApprovalGService.updateReceivedDept(docID, processorID, processorName, processorJobTitle, receivedDeptID,
        		receivedDeptName, processorName2, processorJobTitle2, receivedDeptName2, userInfo.getCompanyID(), userInfo.getTenantId());

            logger.debug("updateReceivedDept ended.");

        return result;
    }
    
	/**
	 * 2020-04-29 - 전자결재 결재자 aprtype 정보
	 */	
	@RequestMapping(value = "/ezApprovalG/getAprStateToAprType.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getAprStateToAprType(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getAprStateToAprType started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String pDocID = request.getParameter("docID");
		String pUserID = request.getParameter("userID");
		String pDocState = request.getParameter("docState");
		String pOrgCompanyID = request.getParameter("orgCompanyID");		

		String aprType_aprState = ezApprovalGService.getAprType_AprState(pDocID, pUserID, pDocState, pOrgCompanyID, userInfo.getTenantId());
		
		logger.debug("getAprStateToAprType ended");
		return aprType_aprState;
	}  
	
	/**
	 * 2020-05-08 - 결재정보확인 시 문서정보 저장
	 */	
	@RequestMapping(value = "/ezApprovalG/setApprDocInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setApprDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception {
		logger.debug("setApprDocInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String returnVal = ezApprovalGService.setApprDocInfo(xmlDom, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("setApprDocInfo ended");
		return returnVal;
	}	
	
	/**
	* 기결재통과버튼 표출
	*/
	@RequestMapping(value = "/ezApprovalG/isPassAprLineShow.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String isPassAprLineShow(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("isPassAprLineShow started.");
		userInfo = commonUtil.aprUserInfo(loginCookie);
	
		String docID = request.getParameter("docID");
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.isPassAprLineShow(docID, formID, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
	
		logger.debug("isPassAprLineShow result =" + result );
		logger.debug("isPassAprLineShow ended.");
		
		return result;
	}
	
	/* 2020-10-05 홍승비 - 임시저장문서의 결재선이 정상적인지 체크하는 메서드 */
	@RequestMapping(value = "/ezApprovalG/getTmpDocAprStateIsOK.do", method = RequestMethod.GET, produces = "text/xml;charset=utf8")
	@ResponseBody
	public String getTmpDocAprStateIsOK(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getTmpDocAprStateIsOK started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String pDocSN = request.getParameter("pDocSN");
		
		String result = ezApprovalGService.isTmpDocAprStateOK(pDocSN, userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		logger.debug("getTmpDocAprStateIsOK ended");
		return result;
	}
	
	/**
	* 결재선 추가될 준법지원인
	*/
	@RequestMapping(value = "/ezApprovalG/getAuditAdd.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public void getAuditAdd(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		response.setContentType("application/json;charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		response.getWriter().write(ezApprovalGService.getAuditAdd(loginCookie, userInfo, request).toString());
	}
	 /**
	  *  전자결재G 기안 의견내용 작성 팝업 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getGamsaYesanDeptInfo.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getGamsaYesanDeptInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		logger.debug("getGamsaYesanDeptInfo started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		String gamsa = ezApprovalGService.getGamsaYesanDeptInfo(approvalFlag, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());;
		
		logger.debug("getGamsaYesanDeptInfo ended.");
		
		return gamsa;
	}
	
	@RequestMapping(value = "/ezApprovalG/returnYN.do", method = RequestMethod.GET, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String returnYN(@CookieValue("loginCookie") String loginCookie, @RequestParam String docID, @RequestParam String orgDocID, @RequestParam String orgCompanyID) {
	    logger.debug("returnYN started.");
	    String retStr = "N";
	    try {
	        LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
	        if (!userInfo.getCompanyID().equals(orgCompanyID)) {
	            userInfo.setCompanyID(orgCompanyID);
	        }
	        
	        Map<String, Object> docProcessState = ezApprovalGService.getDocProcessState(docID, orgDocID, userInfo);
	        
	        if (docProcessState != null) {
	            String docState = (String) docProcessState.get("DOCSTATE");
	            String functionType = (String) docProcessState.get("FUNCTIONTYPE");
	            String procDocState = (String) docProcessState.get("PROCDOCSTATE");
	            String procAprState = (String) docProcessState.get("PROCAPRSTATE");
	            
	            if ("011".equals(docState)) {
	                if ("011".equals(procDocState)) {
	                    if (!"015".equals(procAprState)) {
	                        if ("011".equals(functionType) || "004".equals(functionType) || "006".equals(functionType)) {
	                            retStr = "Y";
	                        }
	                    }
	                }
	            }
	        }
	    } catch(Exception e) {
	        logger.error(e.getMessage(), e);
	        retStr = "E";
	    }
	    
	    logger.debug("returnYN ended.");
	    return retStr;
	}
	
	/**
	 * 2021-04-19 홍승비 - 문서의 ORGDOCID를 리턴하는 ajax용 함수 추가 (mode에 따라서 진행문서, 완료문서 분기)
	 */
	@RequestMapping(value = "/ezApprovalG/getOrgDocIDByMode.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getOrgDocIDByMode(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getOrgDocIDByMode started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String mode = request.getParameter("mode");
		String result = ezApprovalGService.getOrgDocIDByMode(docID, mode, orgCompanyID, userInfo.getTenantId());
		
		logger.debug("getOrgDocIDByMode ended.");
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/getChaebunDept.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getChaebunDept(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		logger.debug("getChaebunDept started.");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		String result = ezApprovalGService.getChaebunDept(deptID, orgCompanyID, userInfo.getTenantId());
		
		if(result != null) {
			deptID = result;
		} 
		
		String propName = "displayName;extensionAttribute6;cn";
		String infoXML = ezOrganService.getPropertyList(deptID, propName, userInfo.getPrimary(), userInfo.getTenantId());
		
		logger.debug("getChaebunDept ended.");
		return infoXML;
	}
	
	@RequestMapping(value = "/ezApprovalG/getBujaeInfo.do", method = RequestMethod.GET, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getBujaeInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception{
	    logger.debug("getBujaeInfo started.");
	    
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    
	    String userID = request.getParameter("userID");
	    String deptID = request.getParameter("deptID");
	    
	    String result = ezApprovalGService.getBujaeInfo(userID, deptID, userInfo.getTenantId(), userInfo.getOffset(), userInfo.getCompanyID());
	    
	    logger.debug("getBujaeInfo ended.");
	    
	    return result;
	}
	
	/* 2021-08-25 홍승비 - 개인병렬협조/합의자의 반송 시 처리 타입을 리턴 (1:반송해도 다음 결재권자에게 진행문서로 전달      2:한 명이라도 반송한 경우 원 기안자에게 반송) */
	@RequestMapping(value = "/ezApprovalG/getPersonalAgreeReturnType.do", method = RequestMethod.GET, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getPersonalAgreeReturnType(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception{
		logger.debug("getPersonalAgreeReturnType started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String result = ezCommonService.getTenantConfig("PersonalAgreeReturnType", userInfo.getTenantId());
		
		logger.debug("getPersonalAgreeReturnType ended, result = " + result);
		return result;
	}
    
	@RequestMapping(value = "/ezApprovalG/setSusinRollbackDocID.do", produces = "text/plain; charset=utf-8", method = RequestMethod.GET)
    @ResponseBody
	public String setSusinRollbackDocID(@CookieValue("loginCookie") String loginCookie, @RequestParam String beforeAprState, @RequestParam String docId, @RequestParam String orgDocId) throws Exception {
        logger.debug("setSusinRollbackDocID started.");
        
        LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
        
        String result = ezApprovalGService.setSusinRollbackDocID(beforeAprState, docId, orgDocId, userInfo);

        logger.debug("setSusinRollbackDocID ended.");
        
	    return result;
    }

	// 기산일 적용 년도 가져오기 (양식에 채번 년도 표출 시 사용)
	@RequestMapping(value = "/ezApprovalG/getAccountingYear.do", produces = "text/plain; charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getAccountingYear(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getAccountingYear started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		/* 2025-04-01 홍승비 - 전자결재G > 기산일(회계년도) 시간대 기준 값을 테넌트 컨피그로 옵션화, 디폴트로 UTC 정시가 아닌 한국시(UTC + 9)를 기준으로 사용하도록 수정 */
		String todayUTCTime = commonUtil.getTodayUTCTime("");
		String accountYearTimeZone = ezCommonService.getTenantConfig("accountYearTimeZone", userInfo.getTenantId()); // UTC, KST
		
		if ("KST".equals(accountYearTimeZone)) {
			todayUTCTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), "235|+09:00", false);
		}
		
		String result = ezApprovalGService.getAccountingYear(todayUTCTime, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		logger.debug("getAccountingYear ended.");
		
		return result;
	}
	
	/**
	 * 2022-01-14 홍승비 - 전자결재G 일괄기안 결재선저장 Method
	 * 일괄기안에선 모든 안별로 결재선이 동일하므로, docID를 전부 가져와서 같은 결재선을 넣어준다.
	 */
	@RequestMapping(value = "/ezApprovalG/aprLineSaveAll.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public void aprLineSaveAll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestParam(value = "docIDAry[]") String[] docIDAry, HttpServletRequest request) throws Exception {
		logger.debug("aprLineSaveAll started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String strXML = request.getParameter("ret");
		
		// 일괄기안 시 결재정보 strXML상의 docID는 현재 선택한 탭의 docID를 모든 문서에 동일하게 부여하게 된다. 따라서 실제 docID를 담고있는 배열을 파라미터로 전달한다.
		for (String docID : docIDAry) {
			ezApprovalGService.updateLineInfo(strXML, userInfo.getCompanyID(), userInfo.getLang(), userInfo, docID);
		}
		
		logger.debug("aprLineSaveAll ended.");
	}
	
	/**
	 * 2022-01-14 홍승비 - 전자결재G 일괄기안 결재정보 원문공개정보 저장
	 * 일괄기안에선 모든 안별로 원문공개정보가 동일하므로, docID를 전부 가져와서 같은 데이터를 넣어준다.
	 */
	@RequestMapping(value = "/ezApprovalG/openGovInfoSaveAll.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String openGovInfoSaveAll(@CookieValue("loginCookie") String loginCookie, @RequestParam(value = "pDocIDAry[]", required = false) List<String> docIDAry,
			@RequestParam(value = "fileOpenFlagListAry[]", required = false) List<String> fileOpenFlagListAry, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("openGovInfoSaveAll started.");
		  
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String openGovListFlag = request.getParameter("openGovListFlag");
		String fileOpenFlagList = request.getParameter("fileOpenFlagList");
		String basis = request.getParameter("basis");
		String reason = request.getParameter("reason");
		String publicity = request.getParameter("publicity");
		String docID = request.getParameter("docID");
		String limitDate = request.getParameter("limitDate");
		
		String result = "";
		if (docIDAry != null && docIDAry.size() > 1) { // [0]번 인덱스는 제외하며, 1안부터 시작하므로 [1]부터 접근한다.
			for (int i = 1; i < docIDAry.size(); i++) {
				if (!docIDAry.get(i).equals("delete")) {
					result = ezApprovalGService.openGovInfoSave(openGovListFlag, fileOpenFlagListAry.get(i), basis, reason, publicity, docIDAry.get(i), limitDate, userInfo.getCompanyID(), userInfo.getTenantId());
				}
			}
		} else {
			result = ezApprovalGService.openGovInfoSave(openGovListFlag, fileOpenFlagList, basis, reason, publicity, docID, limitDate, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		
		logger.debug("openGovInfoSaveAll ended.");
		
 		return result;
	}
	
	/** 2022-01-17 홍승비 - 전자결재G 일괄기안 결재정보 원문공개 첨부파일정보 복사
	 * 일괄기안 > 1안 이후 추가 시 원문공개 첨부파일 정보를 복사한다.
	 *  */
	@RequestMapping(value = "/ezApprovalG/copyOpenGovAttachInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public void copyOpenGovAttachInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("copyOpenGovAttachInfo started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String parentDocID = request.getParameter("parentDocID");
		
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();
		
		ezApprovalGService.copyParentOpenGovFileInfo(docID, parentDocID, tenantID, companyID);
				
		logger.debug("copyOpenGovAttachInfo ended");		
	}
	
	/** 2022-01-17 홍승비 - 전자결재G 일괄기안 결재정보 원문공개 첨부파일정보 리턴 */
	@SuppressWarnings({ "unchecked" })
	@RequestMapping(value = "/ezApprovalG/getAttachListForOpenGovDraftAll.do", produces = "application/json;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public JSONArray getAttachListForOpenGovDraftAll(@CookieValue("loginCookie") String loginCookie,
			@RequestParam(value = "pDocIDAry[]", required = false) List<String> docIDAry, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getAttachListForOpenGovDraftAll started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String draftAllFlag = request.getParameter("draftAllFlag") != null ? request.getParameter("draftAllFlag") : "N";
		
		docIDAry.remove(0); // docIDAry의 경우, 1안부터 확인해야 하므로 [0]을 제외하고 전달한다.
		
		List<ApprGOpenGovAttachVO> attachList = null;
		if (draftAllFlag.equals("Y") && docIDAry != null && docIDAry.size() > 0) {
			attachList = ezApprovalGService.getAttachListForOpenGovDraftAll(docIDAry, userInfo.getCompanyID(), userInfo.getTenantId());
		} else {
			return new JSONArray();
		}
		
		JSONObject attachJson = null;
		JSONArray attachJsonArr = new JSONArray();
		
		for (ApprGOpenGovAttachVO attach : attachList) {
			attachJson = new JSONObject();
			attachJson.put("fileOpenFlag", attach.getFileOpenFlag());
			attachJson.put("sn", attach.getAttachFileSN());
			attachJson.put("fileName", attach.getDisplayName());
			attachJson.put("docID", attach.getDocID());
			
			String fileSize = attach.getAttachFileSize();
			
			int cnt = (int) (Math.log10(Double.parseDouble(fileSize)) / Math.log10(1024));
			String[] unit = {"bytes", "KB", "MB", "GB"};
			
			double filesize = Double.parseDouble(fileSize) / Math.pow(1024, cnt);
			fileSize = String.format("%.1f",filesize);
			fileSize = fileSize + unit[cnt];
			
			attachJson.put("fileSize", fileSize);
			attachJsonArr.add(attachJson);
		}
		
		logger.debug("getAttachListForOpenGovDraftAll ended.");
		return attachJsonArr;
	}
	
	/**
	 * 2022-01-18 홍승비 - 전자결재G 일괄기안그룹 임시저장
	 */
	@RequestMapping(value = "/ezApprovalG/saveTmpGroup.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String saveTmpGroup(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("saveTmpGroup started");
		
		String result="";
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		int tenantID = userInfo.getTenantId();
		String userID = userInfo.getId();
		String lang = userInfo.getLang();
		String orgCompanyID = userInfo.getCompanyID();
		String docID = request.getParameter("docID");
		String tabSN = request.getParameter("tabSN");
		String groupDocSN = request.getParameter("groupDocSN");
		
		try {
			result = ezApprovalGService.saveTmpGroup(docID, tabSN, groupDocSN, userID, lang, orgCompanyID, tenantID);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = "error";
		}
		
		logger.debug("saveTmpGroup ended");
		
		return result;
	}
	
	/**
	 * 2022-01-18 홍승비 - 전자결재G 일괄기안그룹 임시저장을 위한 GROUPDOCSN 리턴
	 */
	@RequestMapping(value = {"/ezApprovalG/getMaxTmpGroupDocSN.do", "/ezApprovalG/getMaxTMPDocSN.do"}, produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getMaxTmpGroupDocSN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getMaxTmpGroupDocSN started");
		
		String result = "";
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		int tenantID = userInfo.getTenantId();
		String userID = userInfo.getId();
		String lang = userInfo.getLang();
		String companyID = userInfo.getCompanyID();
		
		try {
			String sn = ezApprovalGService.getMaxTMPDocSN(userID, companyID, lang, tenantID);
			
			result = (userID + "@" + Integer.parseInt(sn));
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = "error";
		}
		
		logger.debug("getMaxTmpGroupDocSN ended, result = " + result);
		return result;
	}
	
	/**
	 * 2022-01-27 홍승비 - 전자결재G 일괄기안 그룹 여부 리턴
	 */
	@RequestMapping(value = "/ezApprovalG/checkIsGroupDoc.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String checkIsGroupDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("checkIsGroupDoc started");
		
		String result = "";
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		int tenantID = userInfo.getTenantId();
		String userID = userInfo.getId();
		String docID = request.getParameter("docID"); // 임시저장된 문서의 경우 docSN 형식으로 전달
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID == null || orgCompanyID.trim().equals("")) {
			orgCompanyID = userInfo.getCompanyID();
		}
		
		try {
			result = ezApprovalGService.checkIsGroupDoc(userID, docID, orgCompanyID, tenantID);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = "error";
		}
		
		logger.debug("checkIsGroupDoc ended. result = " + result);
		return result;
	}

	/**
	 * 전자결재 미리보기 설정 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setApprovConfig.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String setApprovConfig(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("setApprovConfig started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("pUserID");
		String preView = request.getParameter("pPreView");

		String result = ezApprovalGService.setApprovConfig(userID, preView, userInfo.getTenantId());

		logger.debug("setApprovConfig ended");
		return result;
	}
	
	/**
	 * 2022-01-27 홍승비 - 전자결재G 일괄기안 그룹 DOCID(DOCSN) 데이터 리턴
	 */
	@RequestMapping(value = "/ezApprovalG/getGroupDocListByDocID.do", method = RequestMethod.GET)
	@ResponseBody
	public ArrayList<String> getGroupDocListByDocID(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getGroupDocListByDocID started");
		
		ArrayList<String> resultAry = new ArrayList<String>();
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		int tenantID = userInfo.getTenantId();
		String companyID = userInfo.getCompanyID();
		String docID = request.getParameter("docID"); // 임시저장된 문서의 경우 docSN 형식으로 전달
		List<ApprGGroupDocInfoVO> groupDocInfoList = new ArrayList<ApprGGroupDocInfoVO>();
		
		try {
			String groupDocSN = ezApprovalGService.getGroupDocSN(docID, tenantID, companyID);
			groupDocInfoList = ezApprovalGService.getGroupDocList(groupDocSN, "TMP", userInfo.getTenantId(), companyID);
			
			for (ApprGGroupDocInfoVO tempVO : groupDocInfoList) {
				resultAry.add(tempVO.getDocID());
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("getGroupDocListByDocID ended. resultAry = " + resultAry.toString());
		return resultAry;
	}
	
	/**
	 * 2022-02-10 홍승비 - 전자결재G 일괄기안그룹 삭제 전용 메서드 (docID 또는 docSN을 전달받아 GROUPDOCSN을 찾은 뒤, 일치하는 레코드 전부 제거)
	 */
	@RequestMapping(value = "/ezApprovalG/delGroupDocInfoByDocID.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public void delGroupDocInfoByDocID(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("delGroupDocInfoByDocID started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		String orgCompanyID = userInfo.getCompanyID();
		String docID = request.getParameter("docID"); // 실제 DOCID 또는 임시저장된 DOCSN
		String mode = request.getParameter("mode"); // 모든 일괄기안 레코드를 삭제 또는 현재 전달된 DOCID에 대한 레코드만 삭제에 대한 모드값 (ALL, ONE)
		
		try {
			ezApprovalGService.delGroupDocInfoByDocID(docID, mode, orgCompanyID, tenantID);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("delGroupDocInfoByDocID ended.");
	}
	
	/**
	 * 2022-02-09 홍승비 - 전자결재G 일괄기안그룹 실제 기안 시 저장 (기존의 임시저장된 레코드는 제거)
	 */
	@RequestMapping(value = "/ezApprovalG/saveAprGroupAndDelTmp.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public void saveAprGroupAndDelTmp(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("saveAprGroupAndDelTmp started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		String orgCompanyID = userInfo.getCompanyID();
		String docID = request.getParameter("docID"); // 실제 기안이 진행된 뒤 부여받은 DOCID
		String tabSN = request.getParameter("tabSN"); // 안 번호
		String newGroupDocSN = request.getParameter("newGroupDocSN"); // 실제 기안이 진행된 뒤 부여받은 일괄기안 그룹ID (1안의 DOCID)
		// 임시저장된 문서를 기안했을때만 임시저장 레코드 삭제를 위해 전달하며, 일반적인 기안 시 그냥 공백으로 전달한다. (전달해도 지워지는 레코드는 없음)
		String tmpGroupDocSN = request.getParameter("tmpGroupDocSN"); // 임시저장 -> 기안한 경우, 전달할 임시저장된 일괄기안그룹 ID 파라미터
		
		try {
			// 내부적으로 임시저장 레코드의 삭제(tmpGroupDocSN != "" 인 경우) 및 신규 레코드 삽입을 진행
			ezApprovalGService.saveAprGroupAndDelTmp(docID, tabSN, newGroupDocSN, tmpGroupDocSN, orgCompanyID, tenantID);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("saveAprGroupAndDelTmp ended.");
	}
	
	/**
	 * 2022-02-10 홍승비 - 전자결재G 일괄기안그룹 임시저장문서 또는 재기안문서 가져올 때 수신처 존재여부 체크 (TRUE / FALSE)
	 */
	@RequestMapping(value = "/ezApprovalG/getReceiptExists.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getReceiptExists(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getReceiptExists started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		String orgCompanyID = userInfo.getCompanyID();
		String docID = request.getParameter("docID"); // DOCID 또는 DOCSN(임시저장문서)
		String mode = request.getParameter("mode"); // TMP 또는 APR
		String result = "FALSE";
		
		try {
			result = ezApprovalGService.getReceiptExists(docID, mode, orgCompanyID, tenantID);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("getReceiptExists ended, result = " + result);
		return result;
	}
	
	/**
	 * 2022-02-18 홍승비 - 전자결재G 일괄기안 > 그룹으로 묶인 1안의 보류의견 또는 반송의견을 각 안으로 복사
	 */
	@RequestMapping(value = "/ezApprovalG/copyFirstTabOpinion.do", method = RequestMethod.POST)
	@ResponseBody
	public void copyFirstTabOpinion(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("copyFirstTabOpinion started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		String orgCompanyID = request.getParameter("orgCompanyID");
		String docID = request.getParameter("docID"); // 각 안의 DOCID
		String groupDocSN = request.getParameter("groupDocSN"); // 그룹으로 묶인 일괄기안문서 중 1안의 DOCID
		String opinionType = request.getParameter("opinionType"); // OPINIONGB칼럼 : 001(일반), 002(반송), 003(보류), 004(회송) 
		
		try {
			ezApprovalGService.copyFirstTabOpinion(docID, groupDocSN, opinionType, orgCompanyID, tenantID);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}
	
	/**
	 * 2022-03-02 홍승비 - 현재 문서가 가진 총 의견의 갯수를 체크하여 의견 존재 여부를 리턴 (Y/N)
	 */
	@RequestMapping(value = "/ezApprovalG/chkOpinionInfoExist.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String chkOpinionInfoExist(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("chkOpinionInfoExist started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		String docID = request.getParameter("docID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String result = "N";
		
		try {
			result = ezApprovalGService.chkOpinionInfoExist(docID, orgCompanyID, tenantID);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("chkOpinionInfoExist ended, result = " + result);
		return result;
	}
	
	/**
	 * 2022-03-08 홍승비 - 양식ID로 양식을 찾아 문서번호의 포맷을 문자열로 리턴하는 메서드 (.hwp 파일 전용)
	 * 2024-07-02 정주환 - .mht 추가
	 */
	@RequestMapping(value = "/ezApprovalG/getDocNumFormatByFormID.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getDocNumFormatByFormID(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getDocNumFormatByFormID started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		String formID = request.getParameter("formID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String realPath = commonUtil.getRealPath(request);
		String result = "";
		
		try {
			result = ezApprovalGService.getHWPDocNumFormatByFormID(formID, realPath, orgCompanyID, tenantID);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("getDocNumFormatByFormID ended, result = " + result);
		return result;
	}
	
	/**
	 * 2022-06-28 홍승비 - 전달한 DOCID로 진행중문서(APR) 또는 완료문서(END) 여부를 문자열로 리턴
	 */
	@RequestMapping(value = "/ezApprovalG/getAprOrEndStr.do", produces = "text/plain;charset=utf8", method = RequestMethod.GET)
	@ResponseBody
	public String getAprOrEndStr(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getAprOrEndStr started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		String docID = request.getParameter("docID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String result = "";
		
		try {
			result = ezApprovalGService.getAprOrEndStr(docID, userInfo.getCompanyID(), tenantID);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("getAprOrEndStr ended, docID = " + docID + " / result = " + result);
		return result;
	}
	
	/**
	 * 2023-04-20 홍승비 - 일괄기안된 문서의 문서정보를 ArrayList로 리턴하기 위해 기능 분리 (반복호출 제거, 속도향상 관련)
	 */
	@RequestMapping(value = "/ezApprovalG/getApproveDocInfoAll.do", produces = "application/json;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public ArrayList<String> getApproveDocInfoAll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getApproveDocInfoAll started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		ArrayList<String> resultArrList = new ArrayList<String>(); 
		String[] docIDArr = request.getParameterValues("docIDArr[]");
		int docIDArrLength = docIDArr.length;
		String mode = request.getParameter("mode");
		String chamState = request.getParameter("chamState");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		userInfo.setRealPath(commonUtil.getRealPath(request));
		
		resultArrList.add(""); // 0번 인덱스는 사용하지 않음, 공백 값을 부여
		
		// 각 배열애 대하여 순차적으로 루프, 1안 ~ 마지막 안까지의 순서를 유지
		for (int i = 1; i < docIDArrLength; i++) {
			String result = ezApprovalGService.getApproveDocInfo(userInfo, docIDArr[i], userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), mode, chamState);
			resultArrList.add(result);
		}
		
		logger.debug("getApproveDocInfoAll ended");
		
		return resultArrList;
	}
	
	/**
	 * 2023-04-20 홍승비 - 일괄기안된 문서의 첨부파일 정보를 ArrayList로 리턴하기 위해 기능 분리 (반복호출 제거, 속도향상 관련)
	 */
	@RequestMapping(value = "/ezApprovalG/getTotalAttachInfoAll.do", produces = "application/json;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public ArrayList<String> getTotalAttachInfoAll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getTotalAttachInfoAll started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		ArrayList<String> resultArrList = new ArrayList<String>(); 
		String[] docIDArr = request.getParameterValues("docIDArr[]");
		int docIDArrLength = docIDArr.length;
		String mode = request.getParameter("mode");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		userInfo.setRealPath(commonUtil.getRealPath(request));
		
		// 문서기안창, 진행중문서보기창, 문서결재창 내부에서만 해당 첨부파일 정보에 접근 가능하므로 권한체크는 필요하지 않음
		// 권한체크 로직은 문서를 리스트 상에서 클릭했을 때, 하단 결재선/의견/첨부파일 등을 표출할지 여부에 대한 것이므로 이미 권한체크 완료된 상태에서 문서가 열렸을때는 추가 권한 체크 불필요함
		resultArrList.add(""); // 0번 인덱스는 사용하지 않음, 공백 값을 부여
		
		for (int i = 1; i < docIDArrLength; i++) {
			String result = ezApprovalGService.getAttachInfo(docIDArr[i], mode, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
			resultArrList.add(result);
		}
		
		logger.debug("getTotalAttachInfoAll ended");
		
		return resultArrList;
	}
	
	/**
	 * 2023-04-21 홍승비 - 일괄기안된 문서의 기본 문서정보를 ArrayList로 리턴하기 위해 기능 분리 (반복호출 제거, 속도향상 관련)
	 */
	@RequestMapping(value = "/ezApprovalG/getDocInfoAll.do", produces = "application/json;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public ArrayList<String> getDocInfoAll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getDocInfoAll started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		ArrayList<String> resultArrList = new ArrayList<String>(); 
		String[] docIDArr = request.getParameterValues("docIDArr[]");
		int docIDArrLength = docIDArr.length;
		
		resultArrList.add(""); // 0번 인덱스는 사용하지 않음, 공백 값을 부여
		
		for (int i = 1; i < docIDArrLength; i++) {
			String result = ezApprovalGService.getDocInfo(docIDArr[i], "APR", "ALL", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
			resultArrList.add(result);
		}
		
		logger.debug("getDocInfoAll ended");
		
		return resultArrList;
	}

	// 2023-05-25  조수빈 - 전자결재 첨부파일 미리보기
	// 전자결재 첨부파일 미리보기 아이콘 생성 시 useAprFilePrvw 테넌트 컨피크를 체크하므로, 해당 테넌트 컨피그의 값이 1(사용)인 경우에만 컨트롤러 접근 가능
	@RequestMapping(value = "/ezApprovalG/attachItemPreview.do", method = RequestMethod.GET)
	public void attachItemPreview(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response
			, @RequestParam String pFilePath, @RequestParam String fileName) throws Exception {
		
		logger.debug("attachItemPreview started.");
		logger.debug("fileName : " + fileName + " / pFilePath : " + pFilePath);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		// try-catch-with-resources로 자동 close 사용
		try (OutputStream output = response.getOutputStream()) {
			// 기존 첨부파일 객체 생성
			pFilePath = commonUtil.htmlUnescape(URLDecoder.decode(pFilePath, "UTF-8"));
			fileName = commonUtil.htmlUnescape(URLDecoder.decode(fileName, "UTF-8"));

			logger.debug("filePath(decode) : {}", pFilePath);
			
			String realPath = commonUtil.htmlUnescape(commonUtil.getRealPath(request));
			EzFile srcFile = new EzFile(commonUtil.detectPathTraversal(realPath + pFilePath));
			
			if (!srcFile.exists() || !srcFile.isFile()) {
				throw new FileNotFoundException(fileName);
			}
			
			String destFilePath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + "tempUploadFile";
			MessageDigest md2 = MessageDigest.getInstance("SHA-256");
			md2.update(fileName.substring(0, fileName.lastIndexOf(".")).getBytes());
			byte mdDate2[] = md2.digest();
			StringBuffer sb2 = new StringBuffer();
			
			for (int i = 0; i < mdDate2.length; i++) {
				sb2.append(Integer.toHexString((int) mdDate2[i] & 0x00ff));
			}
			
			// SAT 이미지 변환을 위한 파일명은 '해시.확장자' 형태로 전달됨
			String md5FileName = sb2.toString() + fileName.substring(fileName.lastIndexOf("."));
			EzFile destFile = new EzFile(destFilePath + commonUtil.separator + md5FileName);
			File newFolder = new File(destFilePath); // tempUploadFile 경로의 임시 파일이므로 EzFAL 적용 제외
			
			if (!newFolder.exists()) {
				newFolder.mkdirs();
			}
			
			EzFAL.copyFile(srcFile, destFile);
			
			String SATimageConvertServerURL = ezCommonService.getTenantConfig("SATimageConvertServerURL", userInfo.getTenantId());
			String fileExt = fileName.split("\\.")[fileName.split("\\.").length - 1];
			destFilePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId())
			+ commonUtil.separator + "tempUploadFile" + commonUtil.separator + md5FileName;
			output.write((SATimageConvertServerURL 
					+ "?filepath=" + URLEncoder.encode(destFilePath, "UTF-8").replace("+", "%20") +
					"&filename=" + URLEncoder.encode(fileName, "UTF-8").replace("+", "%20") +
					"&fileext=" + fileExt.replace("+", "%20") +
					"&viewerselect=image" +
					"&userid=" + userInfo.getId()).getBytes());
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("attachItemPreview ended.");
	}

	/** 2023-03-22 한태훈 - 전지결재 > 기록물 등록대장, 완료문서 조회 > 다중 문서 통합 PC 저장시  문서열람 권한 확인 */
	@RequestMapping(value = "/ezApprovalG/checkRightTotalSave.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkRightTotalSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("checkRightTotalSave started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String passResult ="";
		String docIDstr = request.getParameter("docIDstr");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String[] docIDarr = docIDstr.split("\\|\\|\\|");
		String failDocIDstr = "";

		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}

		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("m=1") == -1) {

			for (int i = 0; i < docIDarr.length; i++) {
				String tempPassResult = ezApprovalGService.getAccessYNG(docIDarr[i], userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());

				if (tempPassResult.equals("<RESULT>FALSE</RESULT>")) {
					failDocIDstr += docIDarr[i] + "|||";
				}
			}

		} else {
			passResult = "<RESULT>TRUE</RESULT>";
		}

		if (failDocIDstr.length() > 0) {
			StringBuffer sb = new StringBuffer();
			sb.append("<RESULT>");
			sb.append(failDocIDstr);
			sb.append("</RESULT>");
			passResult = sb.toString();
		} else {
			passResult = "<RESULT>TRUE</RESULT>";
		}

		logger.debug("checkRightTotalSave ended.");

		return passResult;
	}

	/** 2023-03-28 한태훈 - 전지결재 > 기록물 등록대장, 완료문서 조회 > 다중 문서 통합 PC 저장 보안결재 설정된 문서 다운로드 시도시 결재선 포함 여부 확인하는 메소드 */
	@RequestMapping(value = "/ezApprovalG/chkSecDocInAprLine.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String chkSecDocInAprLine(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("chkSecDocInAprLine started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docIDStr = request.getParameter("docIDStr");
		String mode = request.getParameter("mode");
		String userID = request.getParameter("userID");
		String companyID = request.getParameter("companyID");
		String separator = "\\|\\|\\|";
		String[] docIDarr = docIDStr.split(separator);

		String result = ezApprovalGService.checkAprLineAll(docIDarr, mode, userID, companyID, userInfo.getTenantId());

		logger.debug("chkSecDocInAprLine ended");
		return result;
	}

	/** 2023-03-20 한태훈 - 전지결재 > 기록물 등록대장, 완료문서 조회 > 다중 문서 통합 PC 저장 */
	@RequestMapping(value = "/ezApprovalG/totalSaveFileAll.do", method = RequestMethod.POST)
	@ResponseBody
	public String totalSaveFileAll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("totalSaveFileAll started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docIDstr = request.getParameter("docIDstr");
		String type = request.getParameter("type");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String separators = "\\|\\|\\|";
		String[] docIDarr = docIDstr.split(separators);

		String realPath = commonUtil.getRealPath(request);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
		String zipFilePath = "";
		String opinionTxtFileName = messageSource.getMessage("ezApprovalG.t00012", userInfo.getLocale()); // 의견 파일
		String opinionWriterMark = messageSource.getMessage("ezApprovalG.t00014",userInfo.getLocale()); // 작성자 :
		String opinionContentMark = messageSource.getMessage("ezApprovalG.t00015",userInfo.getLocale()); // 의견 내용 :
		String attMark = messageSource.getMessage("ezApprovalG.t56",userInfo.getLocale()); // 첨부

		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}

		try {
			zipFilePath = ezApprovalGService.totalSaveDownloadAll(docIDarr, userInfo, type, approvalFlag, accessInfo, realPath, opinionTxtFileName, opinionWriterMark, opinionContentMark, attMark);
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			return "FALSE";
		} finally {
			// 로딩바 숨기기 위해 cookie에 값 설정.
			Cookie cookie = new Cookie("fileDownload", URLEncoder.encode("true", "utf-8"));
			cookie.setPath("/");
			response.addCookie(cookie);
		}

		logger.debug("totalSaveFileAll ended.");

		return zipFilePath;
	}

	/** 2023-06-16 한태훈 - 전지결재 > 단일 문서 통합 PC 저장 시 의견 파일만 다운로드 */
	@RequestMapping(value = "/ezApprovalG/opinionDown.do", produces = "text/plain;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String opinionDown(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("opinionDown started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String orgCompanyID = request.getParameter("orgCompanyID");

		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}

		String opinionTxtFileName = messageSource.getMessage("ezApprovalG.t00012", userInfo.getLocale()); // 의견 파일
		String opinionWriterMark = messageSource.getMessage("ezApprovalG.t00014",userInfo.getLocale()); // 작성자 :
		String opinionContentMark = messageSource.getMessage("ezApprovalG.t00015",userInfo.getLocale()); // 의견 내용 :
		String realPath = commonUtil.getRealPath(request);
		List <ApprGOpinionVO> apprGOpinionList = ezApprovalGService.getDocOpinionList(docID, userInfo);
		String tempOpinionFilePath = commonUtil.getUploadPath("upload_common.DOCDOWNLOAD", userInfo.getTenantId()) + commonUtil.separator + docID + commonUtil.separator;

		File opinionFile = null;
		FileWriter fw = null;
		PrintWriter writer = null;

		String lineSepearator = System.lineSeparator();
		File sourceDir = new File(commonUtil.detectPathTraversal(realPath + commonUtil.getUploadPath("upload_common.DOCDOWNLOAD", userInfo.getTenantId()) + commonUtil.separator + docID));

		if (!sourceDir.exists()) {
			sourceDir.mkdirs();
		}

		try {
			opinionFile = new File(commonUtil.detectPathTraversal(realPath + tempOpinionFilePath + opinionTxtFileName + ".txt")); // docDownload 경로의 임시 파일이므로 EzFAL 적용 제외
			fw = new FileWriter(opinionFile, false);
			writer = new PrintWriter(fw);
			String opinionFileContent = ezApprovalGService.makingOpinionFileContent(userInfo, apprGOpinionList, opinionWriterMark, opinionContentMark, lineSepearator);

			if (apprGOpinionList.size() > 0) {
				writer.write(opinionFileContent);
				writer.flush();
			}

		} catch (FileNotFoundException fnfe) {
			logger.error(fnfe.getMessage(), fnfe);
		} catch (IOException ioe) {
			logger.error(ioe.getMessage(), ioe);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (fw != null) {
				try {
					fw.close();
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
			if (writer!=null) {
				try {
					writer.close();
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}

		String url = tempOpinionFilePath+opinionTxtFileName + ".txt";

		logger.debug("opinionDown ended.");

		return url;
	}

	@GetMapping(value = "/ezApprovalG/endAbsence.do", produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public String getEndOfAbsence(@CookieValue("loginCookie") String loginCookie) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		Optional<ZonedDateTime> optional = ezApprovalGService.getEndOfAbsence(userInfo.getId(), userInfo.getTenantId(), userInfo.getOffset());
		System.out.println("id:" + userInfo.getId() + "/tenantId:" + userInfo.getTenantId() + "/offset:" + userInfo.getOffset());

		return optional.map(zonedDateTime -> zonedDateTime.format(formatter)).orElse("");
	}


	// 2023-06-20 전인하 - 전자결재G > 기록물대장 미리보기 - 보안결재여부와 지정된 날짜를 체크하는 메소드
	@RequestMapping(value = "/ezApprovalG/getSecurityApprovalDate.do", method = RequestMethod.GET)
	@ResponseBody
	public String checkSecurityApprovalDate(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("checkSecurityApprovalDate (Controller) started");

		userInfo = commonUtil.aprUserInfo(loginCookie);

		String docID = request.getParameter("docID");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();
		// 2023-09-25 전인하 - 진행문서를 조회하는 경우를 체크하기 위한 파라미터 추가
		String linemode = ezApprovalGService.getLineModeFlag(docID, userInfo.getId(), companyID, tenantID);

		String result = ezApprovalGService.checkSecurityApprovalDate(docID, companyID, tenantID, linemode);

		logger.debug("checkSecurityApprovalDate (Controller) ended, result = " + result);
		return result;
	}
	
	/* 2023-11-30 홍승비 - 전자결재 > 서명 재맵핑 > TBL_SIGNINFO 테이블의 결재서명 데이터를 XML(문자열) 형식으로 리턴 */
	@RequestMapping(value = "/ezApprovalG/getAllAprSignDataXML.do", produces = "text/plain;charset=utf8", method = RequestMethod.GET)
	@ResponseBody
	public String getAllAprSignDataXML(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getAllAprSignDataXML started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String orgCompanyID = request.getParameter("orgCompanyID");
		int tenantID = userInfo.getTenantId();
		
		String resultXML = ezApprovalGService.getAllAprSignDataXML(docID, orgCompanyID, tenantID);
		
		logger.debug("getAllAprSignDataXML ended");
		return resultXML;
	}

	@RequestMapping(value = "/ezApprovalG/accessWarning.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String noAccessWarning(Model model) throws Exception {
		model.addAttribute("chk", "NoAccess");
		return "main/warning";
	}

	@PostMapping("/ezApprovalG/attachRecordDoc")
	@ResponseBody
	public String attachRecordDoc(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request) throws Exception {
		logger.info("attachRecordDoc started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		String newDocID = request.getParameter("newDocID");
		String attachedDocList1 = null;
		String attachedDocList2[] = null;

		if (request.getParameter("attachedDocList") == null) {
			attachedDocList2 = request.getParameterValues("attachedDocList[]");
		} else {
			attachedDocList1 = request.getParameter("attachedDocList");
		}

		String result;

		if (attachedDocList1 == null && attachedDocList2 == null) {
			return "There is no attached document list";
		}

		result = ezApprovalGService.attachRecordDoc(userInfo, newDocID, attachedDocList1 == null ? attachedDocList2 : attachedDocList1);

		logger.info("attachRecordDoc ended");
		return result.toString();
	}

	/* 2024-06-24 양지혜 - 지정반송 > 결재라인 업데이트 */
	@RequestMapping(value = "/ezApprovalG/updateReturnByDesignation.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String updateReturnByDesignation (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("updateReturnByDesignation started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String returnUserSN = request.getParameter("returnUserSN");
		String docID = request.getParameter("docID");

		String res = ezApprovalGService.updateReturnByDesignation(userInfo, docID, returnUserSN);

		logger.debug("updateReturnByDesignation ended");
		return res;
	}

	@RequestMapping(value = "/ezApprovalG/getAprDocInfoForLink.do", method = RequestMethod.GET)
	@SuppressWarnings("unchecked")
	@ResponseBody
	public JSONObject getAprDocInfoForLink(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getAprDocInfoForLink (Controller) started");
		JSONObject result = new JSONObject ();
		try {
			userInfo = commonUtil.userInfo(loginCookie);

			String docID = request.getParameter("docId");
			String companyID = request.getParameter("companyId");
			String mode = "ING";
			int tenantID = userInfo.getTenantId();
			ApprGDocListVO apprGDocInfo = ezApprovalGService.getDocInfoForNoti(companyID, docID, tenantID, mode);

			if (apprGDocInfo != null) {
				ApprGDocListVO apprGMemberSnVO = ezApprovalGService.getAprMemberSnForNoti(companyID, docID, tenantID, userInfo.getId());
				if (apprGMemberSnVO != null) {
					apprGDocInfo.setAprMemberSN(apprGMemberSnVO.getAprMemberSN());
					apprGDocInfo.setAprState(apprGMemberSnVO.getAprState());
					apprGDocInfo.setDocState(apprGMemberSnVO.getDocState());
				}
			}

			if (apprGDocInfo == null) {
				mode = "END";
				apprGDocInfo = ezApprovalGService.getDocInfoForNoti(companyID, docID, tenantID, mode);
			}

			if (apprGDocInfo == null) {
				mode = "ERROR";
				result.put("status", "error");
				result.put("data", null);
				logger.debug("getAprDocInfoForLink (Controller) ended, result = " + result);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("mode", mode);
			result.put("data", apprGDocInfo);
			result.put("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
			result.put("relayG_type", ezCommonService.getTenantConfig("UserInfo_RelayG_Type", userInfo.getTenantId()));
			result.put("approvalFlag", ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId()));

		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", null);
			logger.error(e.getMessage(), e);
		}
		logger.debug("getAprDocInfoForLink (Controller) ended, result = " + result);

		return result;
	}

	@RequestMapping(value = "/ezApprovalG/getSusinProcessInfo.do", method = RequestMethod.GET)
	@SuppressWarnings("unchecked")
	@ResponseBody
	public JSONObject getSusinProcessInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getSusinProcessInfo (Controller) started");
		JSONObject result = new JSONObject ();
		try {
			userInfo = commonUtil.userInfo(loginCookie);
			String docID = request.getParameter("docId");
			String companyID = request.getParameter("companyId");
			String deptId = request.getParameter("userDeptId");
			String receiveUserId = request.getParameter("userId");
			int tenantID = userInfo.getTenantId();
			ApprGSusinProcessInfoVO apprGDocInfo = ezApprovalGService.getSusinProcessInfo(docID, tenantID, deptId, companyID, receiveUserId);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", apprGDocInfo);

		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", null);
			logger.error(e.getMessage(), e);
		}
		logger.debug("getSusinProcessInfo (Controller) ended, result = " + result);

		return result;
	}
	
	/**
	 * 2023-05-16 임정은 - 전자결재G > 기록물등록대장 > 공람정보 > 공람회수
	 */
	@RequestMapping(value = "/ezApprovalG/gongRamCancel.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String gongRamCancel(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("gongRamCancel started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		int count = Integer.parseInt(request.getParameter("count"));
		int aprMemberSN = Integer.parseInt(request.getParameter("aprMemberSN"));

		String result = ezApprovalGService.gongRamCancel(docID, count, aprMemberSN, userInfo.getCompanyID(), userInfo.getTenantId());

		logger.debug("gongRamCancel ended");

		return result;
	}
	
	/**
	 * 전자결재G 일괄접수 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/receiptAllG.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String receiptAllG(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		logger.debug("receiptAllG started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String rtnVal = "OK/0/0/0"; // OK or ERR/ totalCount / trueCount / falseCount
		int totCnt = 0, trueCnt = 0, falseCnt = 0, exclCnt = 0;
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String userID = xmlDom.getElementsByTagName("USERID").getLength() > 0 
						? xmlDom.getElementsByTagName("USERID").item(0).getTextContent().trim() : "";
		String langType = xmlDom.getElementsByTagName("LANGTYPE").getLength() > 0  
						? xmlDom.getElementsByTagName("LANGTYPE").item(0).getTextContent().trim() : "";
		String orgUID = "";
		String realPath = commonUtil.getRealPath(request);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		userInfo.setRealPath(realPath);
		String useOpenGov = config.getProperty("config.useOpenGov");
		String docIDsForGongram = ""; // 일괄접수 시 공람 기능 대응 > 정상 접수된 docID 저장 변수
		
		if (xmlDom.getElementsByTagName("DOCID").getLength() > 0) {
			totCnt = xmlDom.getElementsByTagName("DOCID").getLength(); // 결재 체크된 문서 갯수 확인
			String mode = xmlDom.getElementsByTagName("MODE").getLength() > 0
						? xmlDom.getElementsByTagName("MODE").item(0).getTextContent().trim() : "";
			
			NodeList docListElements = xmlDom.getDocumentElement().getElementsByTagName("DOC");
			for (int k = xmlDom.getElementsByTagName("DOC").getLength() - 1; k > -1; k--) {
				String res = "";
				
				// k번째에 해당하는 값을 가지고올 때 k번째가 존재하는지, k번째의 값이 있는지 여부를 판단해야하는데, 전자의 경우에는 삼항연산자를 사용할 수 없기 때문에
				// 과정에서 예외(NullPointerException, IndexOutOfBoundsException가 발생하는 경우 필요 값이 제대로 전달되지 않은 상황이므로  실패로 카운트
				try {
					orgUID = xmlDom.getElementsByTagName("ORGAPRUSERID").item(k).getTextContent(); // 원결재자
					mode = xmlDom.getElementsByTagName("MODE").item(k).getTextContent();
					
					String orgCompanyID = xmlDom.getElementsByTagName("orgCompanyID").item(k).getTextContent().trim();
					String aprMemberSN = xmlDom.getElementsByTagName("APRMEMBERSN").item(k).getTextContent().trim();
					String formID = xmlDom.getElementsByTagName("FORMID").item(k).getTextContent().trim();
					String docID = xmlDom.getElementsByTagName("DOCID").item(k).getTextContent().trim();
					String aprState = xmlDom.getElementsByTagName("APRSTATE").item(k).getTextContent().trim();
					String orgDocID = xmlDom.getElementsByTagName("ORGDOCID").item(k).getTextContent().trim();
					String seperateAttachXmlFlag = xmlDom.getElementsByTagName("SEPERATEATTACHXMLFLAG").item(k).getTextContent().trim();
					
					// 2023-10-18 조수빈 - 해당하는 내용(k번째)의 xml 부분만 추출하는 과정.
					Element docElement = (Element) docListElements.item(k);
					Document newDoc = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
					Element newDocElement = (Element) newDoc.importNode(docElement, true);
					newDoc.appendChild(newDocElement);
					
					String docType = newDoc.getElementsByTagName("DOCTYPE").item(0).getTextContent().trim();
					String docState = newDoc.getElementsByTagName("DOCSTATE").item(0).getTextContent().trim(); 
					
					if (xmlDom.getElementsByTagName("TYPE").getLength() > 0) {
						//접수된 문서인지 확인
						int checkRecvDoc = ezApprovalGService.checkReceivedDoc(docID.trim(), userInfo.getCompanyID(), userInfo.getTenantId());
						
						if (checkRecvDoc != 0) {
							res = "ERROR";
						} else if (aprState.equals("015") || seperateAttachXmlFlag.equals("Y") || docState.equals("012")
									|| (approvalFlag.equals("S") && docType.equals("004"))
									|| (approvalFlag.equals("G") && docType.equals("001"))) {
							// 2024-04-05 조수빈 - 문서 상태가 회송이거나 분리첨부가 존재하는 경우, 합의문, 시행문 제외
							res = "EXCL";
						} else if (xmlDom.getElementsByTagName("TYPE").item(k).getTextContent().equals("MHT")) {
							logger.debug("type = MHT");
							res = ezApprovalGService.receiptAll_MHT(userID, "A", formID, "", docID, orgUID, langType, orgCompanyID, request, userInfo, mode, aprMemberSN, newDoc, orgDocID, loginCookie);
							
							// 2024-06-10 조수빈 - 원문공개가 사용일 때 수신 시에는 tbl_opengovdocinfo 테이블의 createDate만 update 되는 부분 구현.
							if (res.contains("TRUE") && useOpenGov == "YES") {
								ezApprovalGService.updateCreateDateOfOpenGovDocInfo(docID, userInfo.getTenantId(), userInfo.getCompanyID());
							}
						} else if (xmlDom.getElementsByTagName("TYPE").item(k).getTextContent().equals("HWP")) {
							logger.debug("type = HWP");
							res = ezApprovalGService.receiptAll_HWP(userID, "A", formID, "", docID, orgUID, langType, orgCompanyID, request, userInfo, mode, aprMemberSN, newDoc, orgDocID, loginCookie);

							// 2024-06-10 조수빈 - 원문공개가 사용일 때 수신 시에는 tbl_opengovdocinfo 테이블의 createDate만 update 되는 부분 구현.
							if (res.contains("TRUE") && useOpenGov == "YES") {
								ezApprovalGService.updateCreateDateOfOpenGovDocInfo(docID, userInfo.getTenantId(), userInfo.getCompanyID());
							}
						}
						
					} 
				} catch (IndexOutOfBoundsException e) {
					logger.error("Error occured in receiptAllG. Index number that generated the error is {}. message: {}", k, e.getMessage());
					res = "<RESULT>FALSE</RESULT>";
				} catch (NullPointerException e) {
					logger.error("Error occured in receiptAllG. Please check if there is a null value. Index number that generated the error is {}. message: {}", k, e.getMessage());
					res = "<RESULT>FALSE</RESULT>";
				}
				
				if (res.contains("TRUE")) {
					trueCnt++;
					
					// 일괄접수 성공한 문서에 대하여 DOCID를 저장
					if (res.contains("<DOCID>") && res.contains("</DOCID>")) {
						docIDsForGongram += (res.split("<DOCID>")[1].split("</DOCID>")[0] + ";");
					}
				} else if (res.contains("EXCL")) {
					exclCnt++;
				} else {
					falseCnt++;
				}
			}
			
			/* 2024-11-18 홍승비 - 전자결재 G > 일괄접수 시에도 공람 기능이 정상 동작하도록 수정, 리턴값에 정상 접수된 docID 이어붙여 전달 */
			// 2024-04-09 조수빈 - 성공한 건이 0, 예외도 0, 실패가 0 이상일 때에만 실패로 반환. 
			if (trueCnt == 0 && exclCnt == 0) {
				rtnVal = "ERR/" + totCnt + "/" + trueCnt + "/" + falseCnt + "/" + exclCnt;
			} else {
				rtnVal = "OK/" + totCnt + "/" + trueCnt + "/" + falseCnt + "/" + exclCnt + "/" + docIDsForGongram;
			}
		}
		
		logger.debug("receiptAllG ended. result: {}", rtnVal);
		
		return rtnVal;
	}
	
	// 한글파일 sign 칸 수 세기
	@RequestMapping(value = "/ezApprovalG/getHwpSignCount.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getHwpSignCount(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getHwpSignCount started");
		String href = request.getParameter("href");
		// 문서에서 찾을 필드명
		String key = request.getParameter("key");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		int rtn = ezApprovalGService.getHwpSignCount(href, key, request, userInfo);
		
		logger.debug("getHwpSignCount ended");
		return Integer.toString(rtn);
	}
	

	/**
	 * 2024-07-09 임정은 - 전자결재G > 기록물배부대장 > 배부정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezDistributeInfo.do", method = RequestMethod.GET)
	public String ezDistributeInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezDistributeInfo started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docId = request.getParameter("docId");
		String sn = request.getParameter("sn");
		ApprGDeliveryListVO docInfo = ezApprovalGService.getDistributeInfo(docId, userInfo.getCompanyID(), userInfo.getTenantId());

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("docId", docId);
		model.addAttribute("docInfo", docInfo);
		model.addAttribute("sn", sn);

		logger.debug("ezDistributeInfo ended.");

		return "ezApprovalG/apprGezDistributeInfo";
	}

	/**
	 * 2024-07-09 임정은 - 전자결재G > 기록물배부대장 > 배부정보 불러오기
	 */
	@RequestMapping(value = "/ezApprovalG/getDistributeInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public List<ApprGDeliveryListVO> getDistributeInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getDistributeInfo started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docId = request.getParameter("docId");
		String deliverySN = request.getParameter("sn");
		List<ApprGDeliveryListVO> docList = ezApprovalGService.getDistributeInfo2(docId, deliverySN, userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getOffset());

		logger.debug("getDistributeInfo ended.");

		return docList;
	}
	
	/**
	 * 2024-10-04 홍승비 - 전자결재 버전 플래그(ApprovalFlag) 테넌트 컨피그값을 가져오는 AJAX 호출용 메서드 추가
	 */
	@RequestMapping(value = "/ezApprovalG/getApprovalFlag.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getApprovalFlag(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("getApprovalFlag started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		logger.debug("getApprovalFlag ended");
		return approvalFlag;
	}
	
	/**
	 * 2024-11-18 홍승비 - 전자결재 G > 일괄접수 시에도 공람 기능이 정상 동작하도록 전용 메서드 분리 (일괄접수자전결 시에는 공람자 지정 불가능)
	 */
	@RequestMapping(value = "/ezApprovalG/gongRamSave_receiptAll.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String gongRamSave_receiptAll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("gongRamSave_receiptAll started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String[] docIDArr = request.getParameterValues("docIDArr[]"); // 공람문서를 생성할 docID 배열 (일괄접수가 정상 완료된 문서들)
		String xmlPara = request.getParameter("xmlPara");
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = "";
		String docAprOrEndStr = "";
		
		// 전달받은 docID 배열에 대해 루프하며 공람문서 생성, 내부에서 예외가 발생하는 경우 catch 없이 상위로 예외를 throw
		if (xmlPara.contains("<DATA name='DocID'>")) { // 태그 및 문자열 패턴은 공람정보 생성시부터 고정되므로 그대로 사용 (Lineinfo.js > APRLINEXMLParsingCC 함수 참고)
			Pattern pattern = Pattern.compile("(<DATA name='DocID'>)(.*?)(</DATA>)"); // 정규식으로 그룹핑하여 xml 문자열에 고정된 docID 추출
			Matcher matcher = pattern.matcher(xmlPara);
			
			if (matcher.find()) {
				for (int i = 0; i < docIDArr.length; i++) {
					if (!"".equals(docIDArr[i])) {
	    				// docID가 아닌 다른 값을 교체하지 않도록 교체할 문자열 패턴은 엄격하게 제어 (matcher.replaceAll() 사용 시 matcher값이 초기화되므로 주의)
	    				String tempXmlPara = xmlPara.replace(("<DATA name='DocID'>" + matcher.group(2).trim() + "</DATA>"), ("<DATA name='DocID'>" + docIDArr[i] + "</DATA>"));
	    				
	        			// 공람발송할 문서가 진행중인지 완료인지 확인 (APR / END) 
	        			docAprOrEndStr = ezApprovalGService.getAprOrEndStr(docIDArr[i], userInfo.getCompanyID(), userInfo.getTenantId());
	        			
	        			if ("APR".equals(docAprOrEndStr)) {
	        				result = ezApprovalGService.gongRamSaveIng(commonUtil.convertStringToDocument(tempXmlPara), dirPath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
	        			} else {
	        				result = ezApprovalGService.gongRamSaveEnd(commonUtil.convertStringToDocument(tempXmlPara), dirPath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
	        			}
					}
				}
			}
		}
		
		logger.debug("gongRamSave_receiptAll ended, result = " + result);
		
		return result;
	}

	@GetMapping(value="/ezApprovalG/checkJobTransferStatus.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public ResponseEntity<String> checkJobTransferStatus(@CookieValue("loginCookie") String loginCookie, @ModelAttribute LoginVO checkVO, Locale locale) {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		ResponseEntity<String> failure =  ResponseEntity.badRequest().body(messageSource.getMessage("ezApprovalG.pgb12", locale));
		// 가독성을 위해 실패하는 조건 분리함. checkVO의 정보도 창을 띄울때 쿠키에서 받은 정보이므로 단순 equals로 비교
		// 호출 횟수가 많을것으로 예상되어 불일치 시에만 로그 남김.
		if (!userInfo.getId().equals(checkVO.getId())) {
			logger.info("checkJobTransferStatus - {} : {} / {}", "id", userInfo.getId(), checkVO.getId());
			return failure;
		}
		
		if (!userInfo.getDeptID().equals(checkVO.getDeptID())) {
			logger.info("checkJobTransferStatus - {} : {} / {}", "deptId", userInfo.getDeptID(), checkVO.getDeptID());
			return failure;
		}

		if (!((StringUtils.isBlank(userInfo.getJobId()) && StringUtils.isBlank(checkVO.getJobId())) || userInfo.getJobId().equals(checkVO.getJobId()))) {
			logger.info("checkJobTransferStatus - {} : {} / {}", "jobId", userInfo.getJobId(), checkVO.getJobId());
			return failure;
		}
		
		return ResponseEntity
				.ok()
				.header("Vary", "Cookie")
				.body("success");
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezApprovalG/checkDocRightForAttachApr.do", produces = "application/json;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject checkDocRightForAttachApr(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("checkDocRightForAttachApr started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		JSONObject result = new JSONObject();
		try {
			String[] docIdList = request.getParameterValues("docIdList");
			String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
			String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
			Map<String, Object> docRightInfo = ezApprovalGService.getDocRightInfoForAttachApr(docIdList, userInfo.getId(), userInfo.getDeptID(), userInfo.getRollInfo(), accessInfo, approvalFlag, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getTenantId());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("noRightDocIds", docRightInfo.get("noRightDocIds"));
			result.put("aprlineRightDocIds", docRightInfo.get("aprlineRightDocIds"));
			result.put("hasRightDocIds", docRightInfo.get("hasRightDocIds"));
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("checkDocRightForAttachApr ended");
		return result;
	}

    /**
     * 2024-07-11 기민혁 - 전자결재G > 자동 임시저장 문서 확인
     */
    @RequestMapping(value = "/ezApprovalG/checkAutoSaveDocId.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
    @ResponseBody
    public String checkAutoSaveDocId(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
        logger.debug("checkAutoSaveDocId started");

        userInfo = commonUtil.aprUserInfo(loginCookie);
        String docID = request.getParameter("docID");

        String result = ezApprovalGService.checkAutoSaveDocId(docID, userInfo.getCompanyID(), userInfo.getTenantId());

        logger.debug("checkAutoSaveDocId ended");

        return result;
    }

	/* 2024-12-10 기민혁 - 전자결재 > 수정 버전 호출 */
	@RequestMapping(value = "/ezApprovalG/getEditVersion.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getEditVersion(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getEditVersion started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String editMode = request.getParameter("editMode");
		String editVersion = ezApprovalGService.getEditVersion(docID, userInfo.getCompanyID(), userInfo.getTenantId());

		if(editVersion == null){
			editVersion = "1.0";
		}

		String[] editVersionArray = editVersion.split("\\.");
		int editVersion1Array = Integer.parseInt(editVersionArray[0]);
		int editVersion2Array = Integer.parseInt(editVersionArray[1]);
		
		if(editMode.equals("1")){
			editVersion1Array += 1;
			editVersion2Array = 0;
		}else if(editMode.equals("2")){
			editVersion2Array += 1;
		}
		
		logger.debug("getEditVersion ended");
		return editVersion1Array + "." + editVersion2Array;
	}
    
	/* 2024-12-25 기민혁 - 전자결재 > 일괄 지정 등록  */
	@RequestMapping(value = "/ezApprovalG/setJijungALL.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setJijungALL(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("setJijungALL started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String result = "" ;
		String docIDs = request.getParameter("docID");
		String receiveSNs = request.getParameter("receiveSN");
		String processorID = request.getParameter("processorID");
		String processorName = request.getParameter("processorName");
		String processorJobTitle = request.getParameter("processorJobTitle");
		String receivedDeptID = request.getParameter("receivedDeptID");
		String receivedDeptName = request.getParameter("receivedDeptName");
		String processorName2 = request.getParameter("processorName2");
		String processorJobTitle2 = request.getParameter("processorJobTitle2");
		String receivedDeptName2 = request.getParameter("receivedDeptName2");
		String susinAdmin = "NO";
		
		// a=1은 수발신담당자
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}

		String[] docIDsplitArray = docIDs.split(",");
		String[] receiveSNsplitArray = receiveSNs.split(",");

		int tResult = docIDsplitArray.length; //총 개수
		int yResult = 0; //성공 개수
		int nResult = 0; //제외 개수
		int eResult = 0; //오류 개수
		String susinCheck = "N";
		
		if (tResult > 0) {
			for (int i = 0; i < docIDsplitArray.length; i++) {
				try{
					ApprGReceiveDocVO checkDocReceiveInfo = ezApprovalGService.checkDocReceiveInfo(userInfo.getCompanyID(), userInfo.getTenantId(),docIDsplitArray[i],receiveSNsplitArray[i]);
	
					if(checkDocReceiveInfo != null && (checkDocReceiveInfo.getDocState().equals("011") || checkDocReceiveInfo.getDocState().equals("013")) && !checkDocReceiveInfo.getAprState().equals("015") && !checkDocReceiveInfo.getAprState().equals("013")){ //수신테이블에 데이터가 있고 docstate가 수신(011),시행(013) 이면서 aprstate가 회송(015), 접수(013)이 아닐경우 일괄 기안 진행
						if((checkDocReceiveInfo.getAprState().equals("011") || checkDocReceiveInfo.getAprState().equals("012") || checkDocReceiveInfo.getAprState().equals("014")) &&
								 susinAdmin.equals("YES") && (checkDocReceiveInfo.getProcessorID() == null || checkDocReceiveInfo.getProcessorID().isEmpty() || checkDocReceiveInfo.getProcessorID().trim().equals(userInfo.getId()))) {
							//수발신 담당자 일때 도착(011),지정(012),배부(014) 의 경우 
							susinCheck = "Y";
						} else if((checkDocReceiveInfo.getAprState().equals("011") || checkDocReceiveInfo.getAprState().equals("012")) &&
								 susinAdmin.equals("NO") && (checkDocReceiveInfo.getProcessorID() != null && !checkDocReceiveInfo.getProcessorID().isEmpty() && checkDocReceiveInfo.getProcessorID().trim().equals(userInfo.getId()))) {
							//수발신 담당자가 아닐때 도착(011),지정(012) 의 경우  
							susinCheck = "Y";
						} else {
							susinCheck = "N";
						}
					} else {
						susinCheck = "N";
					}
	
					if(susinCheck.equals("Y")){
						result = ezApprovalGService.setJijung(checkDocReceiveInfo.getDocID(), checkDocReceiveInfo.getReceiveSN(), processorID, processorName, processorJobTitle, receivedDeptID, receivedDeptName, checkDocReceiveInfo.getAprState(), processorName2, processorJobTitle2, receivedDeptName2, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
						yResult ++;
					}else {
						nResult++;
						continue;
					}

				} catch ( Exception e){
					eResult++;
					logger.error("setJijungALL error = {}", e);
				}
			}
			
		}
		logger.debug("setJijungALL ended.");
		return tResult + "/" + yResult + "/" + nResult + "/" + eResult;
	}
	
	/**
	 * 전자결재 공람완료문서 삭제 Method
	 */
	@RequestMapping(value = "/ezApprovalG/gongramDocDelete.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String gongramDocDelete(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("gongramDocDelete started");
		String result = "";
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String aprmemberSN = request.getParameter("aprmemberSN");
		
		result = ezApprovalGService.gongramDocDelete(docID, Integer.parseInt(aprmemberSN), userInfo.getTenantId(), userInfo.getCompanyID());
		
		logger.debug("gongramDocDelete ended");
		
		return result;
	}
	
	/**
	 * 전자결재 일괄배부 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setBebuAll.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String setBebuAll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("setBebuAll started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String rtn = "ERR/0/0/0/0";
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String realPath = commonUtil.getRealPath(request);
		String dirpath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator ;
		
		try {
			String result = ezApprovalGService.setBebuAll(xmlDom, dirpath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo, "");
			String[] resArr = result.split("/");
			rtn = Integer.parseInt(resArr[0]) > 0 ? "OK/" + result : "ERR/" + result;
		} catch (Exception e) {
			logger.debug("setBebuAll error: " + e.getMessage());
		}
		
		logger.debug("setBebuAll ended");
		
		return rtn;
	}
	
	@RequestMapping(value = "/ezApprovalG/apprGSummaryEdit.do", method = RequestMethod.GET)
	public String apprGSummaryEdit(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("apprGSummaryEdit started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String docID = request.getParameter("docID");
		
		ApprGSummaryVO summary = ezApprovalGService.getSummaryDB(docID, userInfo.getCompanyID(), userInfo.getTenantId(), "APR");
		String mode = Strings.isNotBlank(summary.getSummary()) ? "edit" : "new";
		
		model.addAttribute("summary", summary);
		model.addAttribute("mode", mode);
		
		logger.debug("apprGSummaryEdit ended");
		return "ezApprovalG/apprGSummaryEdit";
	}
	
	@RequestMapping(value = "/ezApprovalG/apprGSummaryView.do", method = RequestMethod.GET)
	public String apprGSummaryView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("apprGSummaryView started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("mode");
		
		ApprGSummaryVO summary = ezApprovalGService.getSummaryDB(docID, userInfo.getCompanyID(), userInfo.getTenantId(), mode);
		
		model.addAttribute("summary", summary);
		logger.debug("apprGSummaryView ended");
		return "ezApprovalG/apprGSummaryView";
	}
	
	@RequestMapping(value = "/ezApprovalG/saveApprGSummary.do", method = RequestMethod.POST)
	public String saveApprGSummary(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("saveApprGSummary started");
		
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String docID = request.getParameter("docID");
			String summary = request.getParameter("summary");
			String summaryMht = request.getParameter("summaryMht");
			ApprGSummaryVO summaryVO = new ApprGSummaryVO(docID, userInfo.getCompanyID(), userInfo.getTenantId(), summary, "");
			
			String path = ezApprovalGService.saveSummaryFileContent(summaryVO, summaryMht, "APR");
			summaryVO.setSummaryPath(path);
			ezApprovalGService.saveSummaryDB(summaryVO, "APR");
			
			model.addAttribute("status", "success");
			model.addAttribute("path", path);
 
		logger.debug("saveApprGSummary ended.");
		return "json";
	}
	
	@RequestMapping(value = "/ezApprovalG/printApprGSummary.do", method = RequestMethod.GET)
	public String printApprGSummary(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("apprGSummaryView started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("mode");
		
		String docName = ezApprovalGService.getDocInfo(docID, mode, "DOCTITLE", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
		ApprGSummaryVO summary = ezApprovalGService.getSummaryDB(docID, userInfo.getCompanyID(), userInfo.getTenantId(), mode);
		
		model.addAttribute("summary", summary);
		model.addAttribute("docName", docName);
		
		logger.debug("apprGSummaryView ended");
		return "ezApprovalG/apprGSummaryPrint";
	}
	
	@RequestMapping(value = "/ezApprovalG/printContentApprGSummary.do", method = RequestMethod.GET)
	@ResponseBody
	public String printContentApprGSummary(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("apprGSummaryView started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("mode");
		
		ApprGSummaryVO summary = ezApprovalGService.getSummaryDB(docID, userInfo.getCompanyID(), userInfo.getTenantId(), mode);
		
		logger.debug("apprGSummaryView ended");
		return summary.getSummaryPath();
	}
	
	@RequestMapping(value = "/ezApprovalG/copySummary.do", method = RequestMethod.POST)
	@ResponseBody
	public String apprGCopyForReuse(@CookieValue("loginCookie") String loginCookie, @RequestParam String orgDocID, @RequestParam String orgDocStatus, @RequestParam String docID) throws Exception {
		logger.debug("apprGSummaryEdit started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String result = "";
		
		ApprGSummaryVO summary = ezApprovalGService.getSummaryDB(orgDocID , userInfo.getCompanyID(), userInfo.getTenantId(), orgDocStatus);
		if (summary != null && Strings.isNotBlank(summary.getSummary())) {
			result = ezApprovalGService.copySummary(summary, docID, "APR");
		}
		
		logger.debug("apprGSummaryEdit ended");
		return result;
	}
	
	@GetMapping(value = "/ezApprovalG/getDocumentSnapshotCode.do")
	@ResponseBody
	public String getDocumentSnapshotCode(@CookieValue("loginCookie") String loginCookie, @RequestParam String docID) {
		String code = "";
		try {
			LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
			code = ezApprovalGService.getDocumentSnapshotCode(userInfo.getTenantId(), userInfo.getCompanyID(), docID);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return code;
	}
	
	@PostMapping(value="/ezApprovalG/saveDrawSignImg.do")
	@ResponseBody
	public Map<String, String> saveDrawSignImg(@CookieValue("loginCookie") String loginCookie, @RequestParam MultipartFile signImg) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		Map<String, String> rtnVal = new HashMap<>();
		try {
			String signImgUrl = ezApprovalGService.saveSignImg(signImg, userInfo.getCompanyID(), userInfo.getTenantId());
			rtnVal.put("status", "ok");
			rtnVal.put("url", signImgUrl);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			rtnVal.put("status", "error");
		}
		return rtnVal;
	}

	/* 2025/01/22 결재가 백단결재로 실패 이력이 있는지 체크 */
	@RequestMapping(value = "/ezApprovalG/getCheckNotFailDoc.do", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	@ResponseBody
	public String getCheckNotFailDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getCheckNotFailDoc started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("pDocID");

		boolean rtnValue = ezApprovalGService.getCheckNotFailDoc(docID, userInfo.getCompanyID(), userInfo.getTenantId());

		logger.debug("getCheckNotFailDoc ended");
		return rtnValue ? "TRUE" : "FALSE";
	}

	@RequestMapping(value = "/ezApprovalG/isDraftAllForm.do", produces = "application/json;charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String isDraftAllForm(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("isDraftAllForm started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String res = "FALSE";
		String formID = request.getParameter("formID") != null ? request.getParameter("formID") : "";
		if(Strings.isBlank(formID)){
			logger.error("isDraftAllForm FormID is null");
			return res;
		}
		
		List<ApprGFormVO> apprGFormVOList = ezApprovalGService.getDraftAllFormInfo(userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId());
		if(apprGFormVOList != null && apprGFormVOList.size() > 0){
			for(ApprGFormVO vo : apprGFormVOList){
				if(vo.getFormID().equals(formID)){
					if("Y".equals(vo.getFormDraftAllFlag())){
						res = "TRUE";
					}
				}
			}
		}
		
		logger.debug("isDraftAllForm ended");
		return res;
	}

    @RequestMapping(value = "/ezApprovalG/approve.do")
    public String approve(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
        logger.debug("approve started");

        String docID = request.getParameter("docID");
        if(docID == null)
            return "ezApprovalG/reload";
        String share = request.getParameter("share");
        String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
        String allFlag = request.getParameter("allFlag");
        if (!"1".equals(allFlag) && !"2".equals(allFlag)) {
            allFlag = "0";
        }
        LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
        int tenantID = userInfo.getTenantId();

        ApprGDocListVO docInfo = ezApprovalGService.getApprovalDocInfo(docID, userInfo, share);
        
        if(docInfo == null || "015".equals(docInfo.getDocState())){
            model.addAttribute("docID", docID);
            return "redirect:/ezApprovalG/view.do";
        }

        String formInfoDetail = ezApprovalGService.getFormInfoDetail(docInfo.getFormID(), userInfo.getCompanyID(), userInfo.getTenantId());
        Document resultXML2 = commonUtil.convertStringToDocument(formInfoDetail);
        boolean isMHT = docInfo.getHref().endsWith("mht");
        if (resultXML2.getElementsByTagName("FORMFILELOCATION").getLength() > 0) {
            isMHT = resultXML2.getElementsByTagName("FORMFILELOCATION").item(0).getTextContent().trim().endsWith("mht");
        }
        
        String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantID);

        String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", tenantID);
        String susinAdmin = userInfo.getRollInfo() != null && userInfo.getRollInfo().contains("a=1") ? "YES" : "NO";
        String signImageType = ezCommonService.getTenantConfig("signImageType", userInfo.getTenantId());
        String useOpenGov = config.getProperty("config.useOpenGov");
        String orgAprUserID = docInfo.getAprMemberID();
        String orgAprUserName = docInfo.getAprMemberName();
        String orgAprUserDeptID = docInfo.getAprMemberDeptID();
        String tempUserID = userInfo.getId();
        String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
        int docDir = Integer.parseInt(docID.substring(docID.length() - 3)) % 1000;
        String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + docDir + "/" + docID + (isMHT ? ".mht" : ".hwp");
        String addLastKyulJeYN = ezCommonService.getTenantConfig("addLastKyulJeYN", userInfo.getTenantId());
        String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
        String docState = docInfo.getDocState();
        String mode = docInfo.getEndDate() != null ? "END" : "APR";
        String orgCompanyID = docInfo.getCompanyID();
        String companyID = userInfo.getCompanyID();

        if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
            userInfo.setCompanyID(orgCompanyID);
        }

        String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(companyID, userInfo.getTenantId());
        String orgDocID = docInfo.getOrgDocID();
        if (orgDocID == null) {
            orgDocID = "";
        }

        String useWebHWP = ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId());
        List<ApprGGroupDocInfoVO> group = new ArrayList<>();
        String draftAllTypeB = ezCommonService.getTenantConfig("draftAllTypeB", userInfo.getTenantId());
        // mht
        if(isMHT){
            String crossEditor = ezCommonService.getTenantConfig("EDITOR", tenantID);
            String signImageSize = ezCommonService.getTenantConfig("SignImageSize", userInfo.getTenantId());
            String agreeReturnType = ezCommonService.getTenantConfig("PersonalAgreeReturnType", userInfo.getTenantId());
            String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
            if (use_cabinet.equals("YES")) {
                use_cabinet = cabinetAdminService.checkModuleActive("apprv", userInfo);
            }
            String draftDeptID = ezApprovalGService.getOrgDraftDeptID(docID, userInfo.getTenantId(), userInfo.getCompanyID());

            model.addAttribute("crossEditor", crossEditor);
            model.addAttribute("signImageSize", signImageSize);
            model.addAttribute("agreeReturnType", agreeReturnType);
            model.addAttribute("useCabinet", use_cabinet); // 캐비넷 추가 baonk 2018-08-08
            model.addAttribute("draftDeptID", draftDeptID);
            // FormBuilder
            String formId = "";
            boolean isReform = false;
            ApprGFormVO reformInfo = ezApprovalGService.getReformInfoApprovalDocument(docID, userInfo.getId(), orgCompanyID, tenantID);
            if (reformInfo != null) {
                formId = reformInfo.getFormID();
                isReform = "Y".equals(reformInfo.getReformFlag());
            }

            if (isReform) {
                model.addAttribute("isReform", isReform);
                model.addAttribute("formId", formId);
            }
            model.addAttribute("optJunKyulInfo", ezApprovalGService.getOptionInfo("A32", "001", userInfo, "CODE")); //전결 처리 방법
            model.addAttribute("optSignDateFormat", ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE"));
            //2020-01-23 김은석 추가
            model.addAttribute("useAnnualSusinYN", ezCommonService.getTenantConfig("useAnnualSusinYN", userInfo.getTenantId()));
            // 2024-05-23 김우철 - 헤더 숨기기 기능 사용 여부
            String useHideHeaderArea = ezCommonService.getTenantConfig("useHideHeaderArea", userInfo.getTenantId());
            model.addAttribute("useHideHeaderArea", useHideHeaderArea);

            // 기안자 정보
            String aprLinexml = ezApprovalGService.getLineInfo(docID, mode, "", "", companyID, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
            Document aprLineInfo = commonUtil.convertStringToDocument(aprLinexml);
            String drafterName = "";
            String drafterDept = "";
            if ("1".equals(userInfo.getPrimary())) {
                drafterName = aprLineInfo.getElementsByTagName("DATA13").item(0).getTextContent().trim();
                drafterDept = aprLineInfo.getElementsByTagName("DATA15").item(0).getTextContent().trim();
            } else {
                drafterName = aprLineInfo.getElementsByTagName("DATA14").item(0).getTextContent().trim();
                drafterDept = aprLineInfo.getElementsByTagName("DATA16").item(0).getTextContent().trim();
            }
            model.addAttribute("drafterName", drafterName);
            model.addAttribute("drafterDept", drafterDept);
            // 양식 정보
            String formName = "";
            if (StringUtils.isBlank(formId)) {
                formId = ezApprovalGService.getFormIdFromApr(docID, companyID, userInfo.getTenantId());
            }
            String formInfoXml = ezApprovalGService.getFormInfoDetail(formId, companyID, userInfo.getTenantId());
            Document formInfo = commonUtil.convertStringToDocument(formInfoXml);
            if (formInfo.getElementsByTagName("FORMNAME").item(0) != null) {
                if ("1".equals(userInfo.getPrimary())) {
                    formName = formInfo.getElementsByTagName("FORMNAME").item(0).getTextContent().trim();
                } else {
                    formName = formInfo.getElementsByTagName("FORMNAME2").item(0).getTextContent().trim();
                }
            }
            model.addAttribute("formName", formName);

            // ai 관련 컨피그 추가
            // AI 첨부파일 이름 최대 길이 - 기존 첨부파일과 동일한 값 사용
            String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
            // AI 사용여부 확인
            boolean useAI = aICommonUtil.checkUseAI(userInfo.getTenantId());
            // AI 챗봇 첨부파일 최대용량
            String aiAttachMBSize = ezCommonService.getTenantConfig("aiAttachMBSize", userInfo.getTenantId());

            model.addAttribute("moduleType", "approval");
            model.addAttribute("moduleSubType", "apprDoc");
            model.addAttribute("useAI", useAI);
            model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
            model.addAttribute("aiAttachMBSize", aiAttachMBSize);
            model.addAttribute("draftJunGyulFlag", ezCommonService.getTenantConfig("draftJunGyulFlag", userInfo.getTenantId())); // 일반버전 서명 remapping 시 전결문자 표출 확인용
        }else{
            String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
            model.addAttribute("approvalPWD", approvalPWD);
            //hwp 툴바가 6줄인데 맨윗줄 부터 '1' 이면 사용 '0' 이면 사용하지 않는다. ex)'100001' 맨위랑 맨아래 툴바만 표시
            model.addAttribute("hwpToolbar", ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId()));
            model.addAttribute("useEditor", ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId()));
            model.addAttribute("optjunKyukInfo", ezApprovalGService.getOptionInfo("A32", "001", userInfo, "CODE"));
            model.addAttribute("isHWP", "Y");
            if("YES".equals(useWebHWP)){
                group = ezApprovalGService.getGroupDocList(docID, "APR", userInfo.getTenantId(), userInfo.getCompanyID());
                model.addAttribute("draftAllTypeB", draftAllTypeB);
                model.addAttribute("loadTimeForApprAll", ezCommonService.getTenantConfig("loadTimeForApprAll", userInfo.getTenantId()));
                model.addAttribute("group", group);
                model.addAttribute("groupDocInfoList", group); // 문서 리스트 데이터 
                model.addAttribute("groupDocInfoListCnt", group.size()); // 문서 리스트 데이터 카운트 (안의 갯수)
                model.addAttribute("groupDocSN", docID); // 일괄기안그룹 DOCID (GROOUPDOCSN)
            }
        }

        // 결재칸 split 유무
        String optIsSplit = ezApprovalGService.getOptionInfo("S".equals(approvalFlag) ? "SA33" : "A33", "001", userInfo, "CODE");
        String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE"); // FIX

        String proxyUser = "NO".equals(useWebHWP) && !isMHT ?
                ezApprovalGService.getProxyUser(userInfo.getId(), "1", userInfo.getTenantId(), userInfo.getOffset())
                : ezApprovalGService.getProxyUser2(userInfo.getId(), "1", tenantID, userInfo.getOffset());

        String[] proxyUserArray = proxyUser.split(",");
        boolean checkPermission = true;

        if (proxyUserArray.length > 1) {
            String docList = ezApprovalGService.getAprLineInfoDB(docID, "1", "", "", companyID, userInfo.getTenantId(), "", "", mode, "");

            Document docXML = commonUtil.convertStringToDocument(docList);

            for (int k = 0; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
                if (docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("002") || docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("005") || docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("000")) {
                    String curAprUserID = docXML.getElementsByTagName("ORGUSERID").item(k).getTextContent();

                    for (int j = 0; j < proxyUserArray.length; j++) {
                        if (curAprUserID.equals(proxyUserArray[j].trim().substring(1, proxyUserArray[j].trim().length() - 1))) {
                            checkPermission = false;
                            break;
                        }
                    }
                }
            }
        }

        if (checkPermission) {
            Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), "APR", companyID, userInfo.getTenantId(), docState);
            if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
                return "main/warning";
            }
        }

        if (approvalFlag.equals("G")) {
            String nonElecRec = ezApprovalGService.checkNonElecRec(orgDocID, companyID, userInfo.getTenantId());
            if (!nonElecRec.equals("")) {
                model.addAttribute("nonElecRec", nonElecRec);
            }
        }

        String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
        if (useExternalMailServer == null || useExternalMailServer.equals("")) {
            useExternalMailServer = "NO";
        }

        /* 2020-11-13 홍승비 - 대용량첨부 관련 파라미터 추가 */
        String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
        String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
        String bigAttachFileMinSaveDate = ezApprovalGService.getAttachFileMinSaveDate(docID, companyID, userInfo.getTenantId());
        String bigAttachDownloadPeriod = bigAttachFileMinSaveDate + " ~ " + EgovDateUtil.addDay(bigAttachFileMinSaveDate, Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");
        String preSusinGroupStr = ezApprovalGService.getCode2Name("A53", "001", companyID, userInfo.getLang(), userInfo.getTenantId());

        // 2023-05-26 조수빈 - 전자결재 첨부파일 미리보기 기능 사용 여부
        String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
        // 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
        String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
        if (!"1".equals(useAprFilePrvw) || !"1".equals(useImageConvertServer)) {
            useAprFilePrvw = "0";
        }

        // 2024-06-11 김우철 - 부서수신함에서 첨부, 문서첨부 기능 사용여부
        String useReceiptDeptFileAttach = ezCommonService.getTenantConfig("useReceiptDeptFileAttach", userInfo.getTenantId());
        // 2024-12-10 기민혁 - 본문버전 변경 기능 사용 여부
        String editVersionYN = ezCommonService.getTenantConfig("EditVertionYN", userInfo.getTenantId());

        model.addAttribute("optIsSplit", optIsSplit);
        model.addAttribute("optSplitKind", optSplitKind);
        model.addAttribute(isMHT ? "uID" : "orgAprUserID", orgAprUserID);
        model.addAttribute(isMHT ? "name" : "orgAprUserName", orgAprUserName);
        model.addAttribute(isMHT ? "deptID" : "orgAprUserDeptID", orgAprUserDeptID);
        model.addAttribute("dirPath", dirPath);
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("docID", docID);
        model.addAttribute("tempUserID", tempUserID);
        model.addAttribute("susinAdmin", susinAdmin);
        model.addAttribute("allFlag", allFlag);
        model.addAttribute("oldYear", oldYear);
        model.addAttribute("approvalFlag", approvalFlag);
        model.addAttribute("junGyulFlag", junGyulFlag);
        model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));
        model.addAttribute("signImageType", signImageType);
        model.addAttribute("addLastKyulJeYN", addLastKyulJeYN);
        model.addAttribute("docState", docState);
        model.addAttribute("useReceiveDocNo", useReceiveDocNo);
        model.addAttribute("orgCompanyID", orgCompanyID);
        model.addAttribute("useExternalMailServer", useExternalMailServer);
        model.addAttribute("useWebHWP", useWebHWP);
        model.addAttribute("share", share);

        if (useOpenGov.equalsIgnoreCase("YES") && approvalFlag.equalsIgnoreCase("G")) {
            Map<String, Object> openGovMap = ezApprovalGService.getOpenGovInfo(docID, userInfo.getTenantId(), companyID);

            model.addAttribute("basis", openGovMap.get("basis"));
            model.addAttribute("reason", openGovMap.get("reason"));
            model.addAttribute("listOpenFlag", openGovMap.get("listOpenFlag"));
            model.addAttribute("fileOpenFlagList", openGovMap.get("fileOpenFlagList"));
        }
        model.addAttribute("useOpenGov", useOpenGov);

        //결재 세부정보
        String formAprOption = ezApprovalGService.getFormAprOptionInfo(docID, "DOC", companyID, userInfo.getTenantId());
        model.addAttribute("formAprOption", formAprOption);

        // 대용량첨부 관련 정보
        model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
        model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
        model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수

        model.addAttribute("preSusinGroupStr", preSusinGroupStr);
        model.addAttribute("isPreview", isPreview);
        model.addAttribute("useReceiveInfoName", ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId())); // 수신처에 "장" 붙이는 옵션
        model.addAttribute("useAprFilePrvw", useAprFilePrvw);
        model.addAttribute("useReceiptDeptFileAttach", useReceiptDeptFileAttach);

        /* 2024-06-24 양지혜 - 지정반송 사용 여부 */
        model.addAttribute("useReturnByDesignation", ezCommonService.getTenantConfig("returnByDesignationUsed", userInfo.getTenantId()));
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

        model.addAttribute("editVersionYN", editVersionYN);

        // 2025-02-18 박기범 - 프론트에서 문서 편집시, 문서를 오픈한 이후로 다른 문서/결재진행 변화가 있었는지 체크하기 위한 코드
        model.addAttribute("snapshotCode", ezApprovalGService.getDocumentSnapshotCode(userInfo.getTenantId(), companyID, docID));

        logger.debug("approve ended");

        return group.isEmpty() && isMHT ? "ezApprovalG/apprGapprovui" :
                "NO".equals(useWebHWP) ? "/ezApprovalG/apprGapprovuiHWP" :
                group.isEmpty() || "Y".equals(draftAllTypeB) ? "/ezApprovalG/apprGapprovuiWHWP" :
                "ezApprovalG/apprGapprovuiAll_WHWP";
    }

    @RequestMapping(value = "/ezApprovalG/view.do")
    public String view(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
        logger.debug("view started.");

        userInfo = commonUtil.aprUserInfo(loginCookie);
        String docID = request.getParameter("docID");
        if(docID == null)
            return "ezApprovalG/reload";
        
        String share = request.getParameter("share");
        String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
        String listSusin = request.getParameter("listSusin");
        String sendType = ezApprovalGService.getDocSendType(docID, userInfo.getCompanyID(), userInfo.getTenantId());
        String docAttachParent = request.getParameter("docAttachParent") != null ? request.getParameter("docAttachParent") : "";
        String admin = request.getParameter("admin");
        boolean isDocAttach =  StringUtils.isNotBlank(docAttachParent);
        String listType = request.getParameter("listType");
        String pageType = request.getParameter("pageType");
        String isOpinion = request.getParameter("isOpinion");
        String callBackType = request.getParameter("CallBackType");
        
        ApprGDocListVO docInfo = ezApprovalGService.getViewDocInfo(docID, userInfo);
        
        if(docInfo == null){
            model.addAttribute("chk", "no");
            return "main/warning";
        }

        String docHref = docInfo.getHref();
        boolean isMHT = docHref.endsWith("mht");
        boolean ing = docHref.contains("/1000/");
        String docAprEnd = ing ? "APR" : "END";
        String formUrl = "";
        String formDocType = "";
        String formVersion = "";
        String formInfoDetail = ezApprovalGService.getFormInfoDetail(docInfo.getFormID(), userInfo.getCompanyID(), userInfo.getTenantId());
        Document resultXML2 = commonUtil.convertStringToDocument(formInfoDetail);
        if (resultXML2.getElementsByTagName("FORMFILELOCATION").getLength() > 0) {
            formUrl = resultXML2.getElementsByTagName("FORMFILELOCATION").item(0).getTextContent().trim();
            isMHT = formUrl.endsWith("mht");
        }
        if (resultXML2.getElementsByTagName("FORMDOCTYPE").getLength() > 0) {
            formDocType = resultXML2.getElementsByTagName("FORMDOCTYPE").item(0).getTextContent().trim();
        }
        if (resultXML2.getElementsByTagName("FORMVERSION").getLength() > 0) {
            formVersion = resultXML2.getElementsByTagName("FORMVERSION").item(0).getTextContent().trim();
        }

        List<ApprGGroupDocInfoVO> groupDocInfoList = new ArrayList<>();
        String draftAllTypeB = ezCommonService.getTenantConfig("draftAllTypeB", userInfo.getTenantId());
        // 1안의 docID를 GroupDocSN으로 전달한다. 임시저장된 문서도 문서보기가 가능하므로, listType을 체크한다.
        String groupDocSN = "";

        if ("21".equals(listType)) { // docID = 임시저장된 docSN (사용자ID@순번 형태)
            // 웹한글기안기의 비동기 동작으로 1안이 늦게 저장되어 GROUPDOCSN값이 다를 수 있다. 따라서 정상적인 GROUPDOCSN값을 다시 가져오도록 한다.
            groupDocSN = ezApprovalGService.getGroupDocSN(docID, userInfo.getTenantId(), userInfo.getCompanyID());
            groupDocInfoList = ezApprovalGService.getGroupDocList(groupDocSN, "TMP", userInfo.getTenantId(), userInfo.getCompanyID());
        } else {
            groupDocInfoList = ezApprovalGService.getGroupDocList(docID, "APR", userInfo.getTenantId(), userInfo.getCompanyID());
        }
        if(!groupDocInfoList.isEmpty() && !"Y".equals(draftAllTypeB)){
            model.addAttribute("loadTimeForApprAll", ezCommonService.getTenantConfig("loadTimeForApprAll", userInfo.getTenantId()));
        }
        String pass = viewChk(docInfo, docAttachParent, userInfo, model, pageType, isDocAttach, share, isMHT, !groupDocInfoList.isEmpty());
        if("main/warning".equals(pass))
            return pass;
        
        String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
        String susinAdmin = "";
        String signCheck = "";
        String title = docInfo.getDocTitle();
        String orgDocID = docInfo.getOrgDocID();
        String formID = docInfo.getFormID();
        String docState = docInfo.getDocState();

        // 한글
        model.addAttribute("useFormContOnReuseForWHWP", ezCommonService.getTenantConfig("useFormContOnReuseForWHWP", userInfo.getTenantId()));
        model.addAttribute("draftAllTypeB", draftAllTypeB);
        // 일괄 Type B
        if("Y".equals(draftAllTypeB)){
            List<ApprGGroupDocInfoVO> group = ezApprovalGService.getGroupDocList(docID, "APR", userInfo.getTenantId(), userInfo.getCompanyID());
            model.addAttribute("group", group);
        }

        String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
        model.addAttribute("hwpToolbar", hwpToolbar);
        model.addAttribute("useEditor", editor);
        model.addAttribute("groupDocInfoList", groupDocInfoList); // 문서 리스트 데이터 
        model.addAttribute("groupDocInfoListCnt", groupDocInfoList.size()); // 문서 리스트 데이터 카운트 (안의 갯수)
        model.addAttribute("groupDocSN", docID); // 일괄기안그룹 DOCID (GROOUPDOCSN)
        
        if(groupDocInfoList.isEmpty() && isMHT || (!groupDocInfoList.isEmpty() && !ing && isMHT)){
            String signImageType = ezCommonService.getTenantConfig("signImageType", userInfo.getTenantId());
            String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
            if (use_cabinet.equals("YES")) {
                use_cabinet = cabinetAdminService.checkModuleActive("apprv", userInfo);
            }
            String useHideHeaderArea = ezCommonService.getTenantConfig("useHideHeaderArea", userInfo.getTenantId());
            
            model.addAttribute("useHideHeaderArea", useHideHeaderArea);
            model.addAttribute("ext", "mht");
            model.addAttribute("signImageType", signImageType);
            model.addAttribute("useCabinet", use_cabinet);
            model.addAttribute("crossEditor", editor);
            model.addAttribute("editor", editor);
            model.addAttribute("title", title);
            model.addAttribute("admin", admin);
            
            if(ing){
                String mode = "VIE";
                if ("4".equals(listType) || "6".equals(listType) || "10".equals(listType) || "99".equals(listType) || "98".equals(listType)) {
                    mode = "REC";
                } else if ("21".equals(listType)) {
                    mode = "TMP";
                }
                model.addAttribute("mode", mode);
                model.addAttribute("callBackType", callBackType);
            }else {
                String rtnXML = ezApprovalGService.getDocInfo(docID, "END", "SignCheck", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
                Document resultXML = commonUtil.convertStringToDocument(rtnXML);

                if (resultXML.getElementsByTagName("SIGNCHECK").item(0) != null && !resultXML.getElementsByTagName("SIGNCHECK").item(0).getTextContent().trim().equals("")) {
                    signCheck = resultXML.getElementsByTagName("SIGNCHECK").item(0).getTextContent().trim();
                }
                model.addAttribute("signCheck", signCheck);
                int whoKyulCount = ezApprovalGService.getWhoKyulCount(docID, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLang());
                model.addAttribute("whoKyulCount", whoKyulCount);
                String checkPwdFlag = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(),  userInfo.getCompanyID());
                model.addAttribute("checkPwdFlag", checkPwdFlag);
                if ("G".equals(approvalFlag) && orgDocID != null && !orgDocID.equals("")) {
                    String nonElecRec = ezApprovalGService.checkNonElecRec(orgDocID, userInfo.getCompanyID(), userInfo.getTenantId());
                    if (!"".equals(nonElecRec)) {
                        model.addAttribute("nonElecRec", nonElecRec);
                    }
                }
            }
        }

        // 진행중
        if(ing){
            model.addAttribute("opinionFlag", docInfo.getHasOpinionYn());
            String forceCallBackYN = ezCommonService.getTenantConfig("forceCallBack_YN", userInfo.getTenantId());
            model.addAttribute("forceCallBackYN", forceCallBackYN);
            String realPath = commonUtil.getRealPath(request);
            String dirPath = realPath +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
            String rtnVal = ezApprovalGService.getOrgDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());

            Document xmlDom = commonUtil.convertStringToDocument(rtnVal);
            if (xmlDom.getElementsByTagName("ORGHREF").getLength() > 0) {
                String orgDocFile = xmlDom.getElementsByTagName("ORGHREF").item(0).getTextContent();
                String docFile = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();

                orgDocFile = dirPath + orgDocFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator, "");
                docFile = dirPath + docFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator, "");

                String dir = docFile.substring(0, docFile.lastIndexOf(commonUtil.separator) + 1);
                EzFile file = new EzFile(commonUtil.detectPathTraversal(dir));

                if (!file.exists()) {
                    file.mkdirs();
                }

                EzFile newFile = new EzFile(commonUtil.detectPathTraversal(docFile));

                if (!newFile.exists()) {
                    EzFile orgFile = new EzFile(commonUtil.detectPathTraversal(orgDocFile));

                    // KLIB 복호화
                    if (orgDocFile.endsWith("." + EzApprovalGKlibServiceImpl.ENCRYPTED_FILE_EXT)) {
                        byte[] orgBytes = FileUtils.readFileToByteArray(orgFile.getFile());

                        // EzFAL EzFileOutputStream 사용 (자동 close 호출)
                        try (EzFileOutputStream fos = new EzFileOutputStream(newFile)) {
                            fos.write(klibUtil.decrypt(orgBytes));
                            fos.flush();
                        } catch (Exception e) {
                            logger.error(e.getMessage(), e);
                        }
                    } else {
                        EzFAL.copyFile(orgFile, newFile);
                    }
                }
            }
        }else{
            // 완료
            if (orgDocID != null  && !orgDocID.isEmpty()) {
                String endDir = ezApprovalGService.getDocDir(orgDocID);
                model.addAttribute("endDir", endDir);
            }
        }

        if (userInfo.getRollInfo() != null && userInfo.getRollInfo().contains("a=1")) {
            susinAdmin = "YES";
        } else {
            susinAdmin = "NO";
        }

        String orgCompanyID = docInfo.getCompanyID();

        String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
        if (useExternalMailServer == null || useExternalMailServer.equals("")) {
            useExternalMailServer = "NO";
        }

        String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
        String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
        String bigAttachFileMinSaveDate = ezApprovalGService.getAttachFileMinSaveDate(docID, userInfo.getCompanyID(), userInfo.getTenantId());
        String bigAttachDownloadPeriod = bigAttachFileMinSaveDate + " ~ " + EgovDateUtil.addDay(bigAttachFileMinSaveDate, Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");
        String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
        String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());

        if (!"1".equals(useAprFilePrvw) || !"1".equals(useImageConvertServer)) {
            useAprFilePrvw = "0";
        }

        model.addAttribute("useBoard", ezCommonService.getTenantConfig("useBoard", userInfo.getTenantId()));
        model.addAttribute("docID", docID);
        model.addAttribute("share", share);
        model.addAttribute("docAttachParent", docAttachParent);
        model.addAttribute("pageType", pageType);
        model.addAttribute("isOpinion", isOpinion);
        model.addAttribute("susinAdmin", susinAdmin);
        model.addAttribute("formVersion", formVersion);
        model.addAttribute("docHref", docHref);
        model.addAttribute("listSusin", listSusin);
        model.addAttribute("orgDocID", orgDocID);
        model.addAttribute("formID", formID);
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("pass", pass);
        model.addAttribute("formUrl", formUrl);
        model.addAttribute("formDocType", formDocType);
        model.addAttribute("approvalFlag", approvalFlag);
        model.addAttribute("docState", docState);
        model.addAttribute("orgCompanyID", orgCompanyID);
        model.addAttribute("useExternalMailServer", useExternalMailServer);
        String useWebHWP = ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId());
        model.addAttribute("useWebHWP", useWebHWP);
        model.addAttribute("sendType", sendType);
        model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
        model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
        model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
        model.addAttribute("isPreview", isPreview);
        model.addAttribute("useAprFilePrvw", useAprFilePrvw);
        model.addAttribute("docAprEnd", docAprEnd);
        model.addAttribute("isDocAttach", isDocAttach);
        model.addAttribute("hasOpinionYN", docInfo.getHasOpinionYn());
        model.addAttribute("listType", listType);
        model.addAttribute("listTypeValue", listType);
        model.addAttribute("docTitle", title);
        model.addAttribute("showOpinion", isOpinion);
        logger.debug("view ended.");

        if (pass.equals("<RESULT>TRUE</RESULT>")) {
            String url = "";
            if(!groupDocInfoList.isEmpty()){
                url = !"Y".equals(draftAllTypeB) && ing ? "apprGviewAprAll_WHWP" : ing ? "apprGviewAprWHWP" : 
                        isMHT ? "apprGcontDocView" : "apprGviewEndWHWP";
            }else{
                url = isMHT ? ing ? "apprGaprDocView" : "apprGcontDocView" :
                        !"YES".equals(useWebHWP) ? ing ? "apprGviewAprHWP" : "apprGviewEndHWP" :
                        ing ? "apprGviewAprWHWP" : "apprGviewEndWHWP";
            }
            return "ezApprovalG/" + url;
        } else {
            return "main/warning";
        }
    }

    private String viewChk(ApprGDocListVO docInfo, String docAttachParent, LoginVO userInfo, Model model, String pageType, boolean isDocAttach, String share, boolean isMHT, boolean isGroup) throws Exception{
        logger.debug("viewChk started.");
        String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
        String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
        String href = docInfo.getHref();
        boolean ing = href.contains("/1000/");
        String mode = ing ? "APR" : "END";
        String docID = docInfo.getDocID();
        String docState = docInfo.getDocState();
        String pass = "<RESULT>FALSE</RESULT>";
        String docAprEnd = mode;
        if((!isGroup && isMHT) || !ing){
            if(ing){
                if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("q=1")) {
                    if (docID != null && !docID.isEmpty()) {
                        String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1", userInfo.getTenantId(), userInfo.getOffset());
                        String[] proxyUserArray = proxyUser.split(",");
                        boolean checkPermission = true;

                        if (proxyUserArray.length > 1) {
                            String docList = ezApprovalGService.getAprLineInfoDB(docID, "1", "", "", userInfo.getCompanyID(), userInfo.getTenantId(), "", "", mode, "");

                            Document docXML = commonUtil.convertStringToDocument(docList);

                            for (int k = 0; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
                                if (docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("002") || docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("005") || docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("000")) {
                                    String curAprUserID = docXML.getElementsByTagName("ORGUSERID").item(k).getTextContent();

                                    for (int j = 0; j < proxyUserArray.length; j++) {
                                        if (curAprUserID.equals(proxyUserArray[j].trim().substring(1, proxyUserArray[j].trim().length() - 1))) {
                                            checkPermission = false;
                                            break;
                                        }
                                    }
                                }
                            }
                        }

                        if (checkPermission) {
                            Document doc = ezApprovalGService.checkPermission(docID, userInfo.getId(), userInfo.getDeptID(), mode, userInfo.getCompanyID(), userInfo.getTenantId(), docState);

                            if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
                                model.addAttribute("chk", "no");
                                return "main/warning";
                            }
                            if (!doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals(userInfo.getId()) && !doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("NULL")) {
                                if (doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().isEmpty() && (!doc.getElementsByTagName("RECEIVEDDEPTID").item(0).getTextContent().equals(userInfo.getDeptID()) || !userInfo.getRollInfo().contains("a=1"))) {
                                    return "main/warning";
                                }
                                if (!doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().isEmpty()) {
                                    return "main/warning";
                                }
                            }
                        }
                    }
                } else if (!"admin".equals(pageType)) {
                    Document doc = ezApprovalGService.checkPermission(docID, userInfo.getId(), userInfo.getDeptID(), mode, userInfo.getCompanyID(), userInfo.getTenantId(), docState);

                    if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
                        model.addAttribute("chk", "no");
                        return "main/warning";
                    }
                }
                pass = "<RESULT>TRUE</RESULT>";
            }else{
                if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("q=1") && !userInfo.getRollInfo().contains("m=1")) {
                    // 2023-11-06 박기범 - 문서첨부에서 문서를 열 경우 첨부문서의 권한이 아니라 문서의 권한으로 체크
                    String tmpID = isDocAttach && ezApprovalGService.isAttachDoc(docID, docAttachParent, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId()) ? docAttachParent : docID; 
                    pass = ezApprovalGService.getAccessYNG(tmpID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());
                    // 2024-06-11 양지혜 - 취약점보완 : 보안결재 체크
                    String securityDate = ezApprovalGService.checkSecurityApprovalDate(docID, userInfo.getCompanyID(), userInfo.getTenantId(), docAprEnd);
                    if (!"".equals(securityDate)) {
                        String checkLine = ezApprovalGService.checkAprLine(docID, docAprEnd, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
                        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                        if (checkLine.equals("<RESULT>FALSE</RESULT>") && formatter.parse(commonUtil.getTodayUTCTime("yyyy-MM-dd")).compareTo(formatter.parse(securityDate)) < 0) {
                            return "main/warning";
                        }
                    }
                } else {
                    pass = "<RESULT>TRUE</RESULT>";
                }

                if (share != null && share.equals("Y")) {
                    pass = "<RESULT>TRUE</RESULT>";
                }
            }
        }else{
            if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("q=1") && !userInfo.getRollInfo().contains("m=1")) {
                if (ing) {
                    pass = ezApprovalGService.getAccessYNGforAPR(docID, accessInfo, approvalFlag, userInfo);
                } else {
                    pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());
                }
                // 2024-06-11 양지혜 - 취약점보완 : 보안결재 체크
                String securityDate = ezApprovalGService.checkSecurityApprovalDate(docID, userInfo.getCompanyID(), userInfo.getTenantId(), docAprEnd);
                if (!"".equals(securityDate)) {
                    String checkLine = ezApprovalGService.checkAprLine(docID, docAprEnd, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
                    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                    if (checkLine.equals("<RESULT>FALSE</RESULT>") && formatter.parse(commonUtil.getTodayUTCTime("yyyy-MM-dd")).compareTo(formatter.parse(securityDate)) < 0) {
                        pass = "<RESULT>FALSE</RESULT>";
                    }
                }
            } else {
                pass = "<RESULT>TRUE</RESULT>";
            }

            if (!"<RESULT>TRUE</RESULT>".equals(pass)) {
                // #147057 - 권한 없는 사용자가 결재선열람인 일괄기안 문서 열람할 때 빈 화면으로 표시되는 결함
                // 2024-10-15 박기범 : 권한 없을시 받아오지 못하는 정보를 아래 로직에서 이용시 exception 발생.
                // 권한 없을시 다른 DB조회 필요 없고 권한없음 페이지 표출하므로 바로 리턴 처리 함.
                return "main/warning";
            }
        }

        if (pass.equals("<RESULT>TRUE</RESULT>") && !ing) {
            String readRecXML = "<PARAMETER><DOCID>" + makeXMLString(docID) +
                    "</DOCID><USERID>" + makeXMLString(userInfo.getId()) +
                    "</USERID><USERNAME>" + makeXMLString(userInfo.getDisplayName1()) +
                    "</USERNAME><USERTITLE>" + makeXMLString((userInfo.getTitle1() == null ? "" : userInfo.getTitle1())) +
                    "</USERTITLE><DEPTCODE>" + makeXMLString(userInfo.getDeptID()) +
                    "</DEPTCODE><DEPTNAME>" + makeXMLString(userInfo.getDeptName1()) +
                    "</DEPTNAME><COMPANYID>" + makeXMLString(userInfo.getCompanyID()) +
                    "</COMPANYID><USERNAME2>" + makeXMLString(userInfo.getDisplayName2()) +
                    "</USERNAME2><USERTITLE2>" + makeXMLString((userInfo.getTitle2() == null ? "" : userInfo.getTitle2())) +
                    "</USERTITLE2><DEPTNAME2>" + makeXMLString(userInfo.getDeptName2()) +
                    "</DEPTNAME2></PARAMETER>";
            ezApprovalGService.saveRecReadHist(readRecXML, userInfo.getTenantId());
        }
        logger.debug("viewChk ended.");
        return pass;
    }
}
