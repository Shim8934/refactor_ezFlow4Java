package egovframework.ezEKP.ezApprovalG.web;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.service.impl.EzApprovalGKlibServiceImpl;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachOptionVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocInfoWebSrvVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGGroupDocInfoVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.KlibUtil;

@Controller
public class EzApprovalGHwpController extends EgovFileMngUtil{
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGHwpController.class);
	
	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private KlibUtil klibUtil;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzApprovalGAdminService")
	private EzApprovalGAdminService ezApprovalGAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
    @Resource(name = "EzOrganService")
    private EzOrganService ezOrganService;
	
	/**
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 * 전자결재 한글기안기 오픈
	 */
	@RequestMapping(value = "/ezApprovalG/draftuiHWP.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String draftuiHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("draftuiHWP started");
		
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
		String nonElecRec = request.getParameter("nonElecRec");
		String docSN = "";
		
		if (nonElecRec == null) {
			nonElecRec = "";
		}
		
		if (listType.equals("21")) {
			if (request.getParameter("docSN") != null) {
				docSN = request.getParameter("docSN");
			}
		}
		
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
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
		/* 2020-03-31 홍승비 - 재기안 시 반송의견 유지여부 컨피그 추가 */
		String useRedraftOpinionKeep = ezCommonService.getTenantConfig("useRedraftOpinionKeep", userInfo.getTenantId());
		
		model.addAttribute("approvalFlag", approvalFlag);
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
		model.addAttribute("docSN", docSN);
		model.addAttribute("isHWP", "Y");
		model.addAttribute("nonElecRec", nonElecRec);
		model.addAttribute("useReceiveDocNo", useReceiveDocNo);
		model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));
		model.addAttribute("useOpenGov", config.getProperty("config.useOpenGov"));
		model.addAttribute("useRedraftOpinionKeep", useRedraftOpinionKeep);
		//결재 세부정보
		String formId = ezApprovalGService.getFormId(formURL);
		String formAprOption = ezApprovalGService.getFormAprOptionInfo(formId, "FORM", userInfo.getCompanyID(), userInfo.getTenantId());
		model.addAttribute("formAprOption", formAprOption);

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
		
		logger.debug("draftuiHWP ended");
		
		return "ezApprovalG/apprGdraftuiHWP";
	}
	
	/**
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 * 전자결재 한글결재 오픈
	 */
	@RequestMapping(value = "/ezApprovalG/approvuiHWP.do", method = RequestMethod.GET)
	public String approvuiHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("approvuiHWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String susinAdmin = "";
		String orgAprUserID = request.getParameter("id");
		String orgAprUserName = request.getParameter("name");
		String orgAprUserDeptID = request.getParameter("deptID");
		String docID = request.getParameter("docID");
		String tempUserID = userInfo.getId();
		String orgDocID = request.getParameter("orgDocID");
		String useOpenGov = config.getProperty("config.useOpenGov");
		String allFlag = request.getParameter("allFlag");
		//hwp 툴바가 6줄인데 맨윗줄 부터 '1' 이면 사용 '0' 이면 사용하지 않는다. ex)'100001' 맨위랑 맨아래 툴바만 표시
        String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
        String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		String docState = request.getParameter("docState");
		String mailChk = request.getParameter("mailchk");// 메일에서 전저결재 열람 여부('Y'일때는 메일 그 외에는 전자결재)
		String mode = request.getParameter("mode");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		if (docID == null) {
			docID = "";
		}
		
		if (mailChk == null) {
			mailChk = "";
		}
		
		if (orgDocID == null) {
			orgDocID = "";
		}

        if (userInfo.getRollInfo().indexOf("a=1") > -1) {
        	susinAdmin = "YES";
        } else {
        	susinAdmin = "NO";
        }
                
        String docDir = docID.substring(docID.length() - 3);
                
        if (docDir.substring(0, 1).equals("0")) {
        	docDir = docDir.substring(docDir.length() - 2, 2);
        } else if (docDir.substring(0, 2).equals("00")) {
        	docDir = docDir.substring(docDir.length() - 1, 1);
        } else if (docDir.equals("000")) {
        	docDir = "0";
        }

        String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
        String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + docDir + "." + docID + ".hwp" ;

        if (!allFlag.equals("1") && !allFlag.equals("2")) {
        	allFlag = "0";
        }
        
        if (!docID.equals("")) {
			String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1", userInfo.getTenantId(), userInfo.getOffset());
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
			
			if (checkPermission) {
				Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), "APR", userInfo.getCompanyID(), userInfo.getTenantId(), docState);
				
				if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
					if(mailChk != null && mailChk.equals("Y")) {
						model.addAttribute("chk", "no");
					}
					return "main/warning";
				}
			}
		}
        
        String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
        String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
        String optisSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
        String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
        String optjunKyukInfo = ezApprovalGService.getOptionInfo("A32", "001", userInfo, "CODE");
        String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
        
        String nonElecRec = ezApprovalGService.checkNonElecRec(orgDocID, userInfo.getCompanyID(), userInfo.getTenantId());
        if (!nonElecRec.equals("")) {
        	model.addAttribute("nonElecRec", nonElecRec);
        }
        
        String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
        
        model.addAttribute("approvalFlag", approvalFlag);
        model.addAttribute("approvalPWD", approvalPWD);
        model.addAttribute("useEditor", useEditor);
		model.addAttribute("orgAprUserID", orgAprUserID);
		model.addAttribute("orgAprUserName", orgAprUserName);
		model.addAttribute("orgAprUserDeptID", orgAprUserDeptID);
		model.addAttribute("docID", docID);
        model.addAttribute("tempUserID", tempUserID);
        model.addAttribute("optSignDateFormat", optSignDateFormat);
        model.addAttribute("optisSplit", optisSplit);
        model.addAttribute("optSplitKind", optSplitKind);
        model.addAttribute("optjunKyukInfo", optjunKyukInfo);
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("allFlag", allFlag);
        model.addAttribute("oldYear", oldYear);
        model.addAttribute("dirPath", dirPath);
        model.addAttribute("hwpToolbar", hwpToolbar);
        model.addAttribute("susinAdmin", susinAdmin);
        model.addAttribute("docState", docState);
        model.addAttribute("isHWP", "Y");
        model.addAttribute("useReceiveDocNo", useReceiveDocNo);
        model.addAttribute("orgCompanyID", orgCompanyID);
        model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));

		if (useOpenGov.equalsIgnoreCase("YES") && approvalFlag.equalsIgnoreCase("G")) {
			Map<String, Object> openGovMap = ezApprovalGService.getOpenGovInfo(docID, userInfo.getTenantId(), userInfo.getCompanyID());

			model.addAttribute("basis", openGovMap.get("basis"));
			model.addAttribute("reason", openGovMap.get("reason"));
			model.addAttribute("listOpenFlag", openGovMap.get("listOpenFlag"));
			model.addAttribute("fileOpenFlagList", openGovMap.get("fileOpenFlagList"));
		}

		model.addAttribute("useOpenGov", useOpenGov);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		//결재 세부정보
		String formAprOption = ezApprovalGService.getFormAprOptionInfo(docID, "DOC", userInfo.getCompanyID(), userInfo.getTenantId());
		model.addAttribute("formAprOption", formAprOption);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));

		logger.debug("approvuiHWP ended");
		
		return "/ezApprovalG/apprGapprovuiHWP";
	}
	
	/**
	 * 전자결재 문서정보이력 상세보기
	 */	
	@RequestMapping(value = "/ezApprovalG/docViewerHWP.do", method = RequestMethod.GET)
	public String docViewerHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("docViewerHWP started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		String docHref = request.getParameter("docHref");
		String useWebHWP = ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId());
		
		model.addAttribute("docHref", commonUtil.cleanValue(docHref));
		
		logger.debug("docViewerHWP ended");
		
		if(useWebHWP.equals("YES")) {
			return "ezApprovalG/apprGdocViewerWHWP";
		} else {
			return "ezApprovalG/apprGdocViewerHWP";
		}
	}
	
	/**
	 * 
	 */	
	@RequestMapping(value = "/ezApprovalG/ezviewAprHWP.do", method = RequestMethod.GET)
	public String ezviewAprHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezviewAprHWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String susinAdmin = "";
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String opinionFlag = request.getParameter("opinionFlag");
		String docState = request.getParameter("docState");
		String listSusin = request.getParameter("listSusin");
		String orgDocID = request.getParameter("oDoc");
		String showOpinion = request.getParameter("isOpinion");
		String listTypeValue = request.getParameter("listType");
		String hasOpinionYN = "";
		String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String orgCompanyID = request.getParameter("orgCompanyID");
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}

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
		
		//2018-08-29 천성준 - 부서수신함에 들어온 접수문서를 최초 접수창으로 열지않고 문서보기로 열었을경우 문서파일이 생성되지 않아서 에러터지는것 수정 
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
			File file = new File(commonUtil.detectPathTraversal(dir));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			File newFile = new File(commonUtil.detectPathTraversal(docFile));
			
			if (!newFile.exists()) {
				File orgFile = new File(commonUtil.detectPathTraversal(orgDocFile));
				
				// KLIB 복호화
				if (orgDocFile.endsWith("." + EzApprovalGKlibServiceImpl.ENCRYPTED_FILE_EXT)) {
					byte[] orgBytes = commonUtil.readBytesFromFile(orgFile.toPath());
					FileUtils.writeByteArrayToFile(newFile, klibUtil.decrypt(orgBytes));
				} else {
					FileUtils.copyFile(orgFile, newFile);
				}
			}
		}
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
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
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		
		logger.debug("ezviewAprHWP ended");
		
		return "ezApprovalG/apprGviewAprHWP";
	}
	
	/**
	 * 한글기안기 결재문서 메일발송 시 첨부파일로 떨구기
	 */	
	@RequestMapping(value = "/ezApprovalG/mail_interuploadX_Server.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mail_interuploadX_Server(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception {
		logger.debug("mail_interuploadX_Server started");

		userInfo = commonUtil.aprUserInfo(loginCookie);

		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);

		String sFileTitle = xmlDom.getElementsByTagName("name").item(0).getTextContent();
		String sFileData = xmlDom.getElementsByTagName("filedata").item(0).getTextContent();
		String sExt = xmlDom.getElementsByTagName("ext").item(0).getTextContent();
		String sFileTypeCode = xmlDom.getElementsByTagName("fileTypeCode").item(0).getTextContent();
		String sFileUrl = xmlDom.getElementsByTagName("fileUrl").item(0).getTextContent();
		
		//2019.03.25 천성준 - 사용안해서 일단 주석
		//String sGUID = xmlDom.getElementsByTagName("guid").item(0).getTextContent();
		//String sFolder = xmlDom.getElementsByTagName("dir").item(0).getTextContent();
		//String sPrefix = xmlDom.getElementsByTagName("prefix").item(0).getTextContent();
		
		//String filename = sFileTitle;
		String pBigFileUpload = sFileData;
		String newguid = UUID.randomUUID().toString();
		String newfilename = newguid + "." + sExt;
		String newwindowid = xmlDom.getElementsByTagName("newid").item(0).getTextContent();

		if (newwindowid == null) {
			newwindowid = "";
		}

		String useExtension = "";
		String pDirTempPath = "";
		if (ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId()) != null) {
			useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		}
		
		String useHwpDownSecurity = ezCommonService.getTenantConfig("useHwpDownSecurity", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String extResult = "";
		String pDate = "";
		String sFileHref = xmlDom.getElementsByTagName("filehref").item(0).getTextContent(); 
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String copyPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;

		// 2018.07.05 - KLIB - ezd 확장자로 변경
		if (sFileHref.endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
			newfilename += "." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT;
		}

		if (pBigFileUpload.equals("Y")) {
			// 2018-10-08 분리된 대용량파일(largeFile) 폴더 사용 여부
			String useSeparatedLargeFileFolder = ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", userInfo.getTenantId());

			if (useSeparatedLargeFileFolder.equals("YES")) {
				pDirPath += commonUtil.separator + "largeFile";
				copyPath += commonUtil.separator + "largeFile";
			}

			// 대용량 첨부파일인 경우에는 오늘 날짜를 이름으로 갖는 폴더를 사용한다.
			pDate = EgovDateUtil.getToday("");
			pDirTempPath = pDirPath + commonUtil.separator + pDate;
			copyPath = copyPath + commonUtil.separator + pDate;
		} else {
			// 일반 첨부파일인 경우에는 tempFileUpload 폴더를 사용한다.
			pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload";
			copyPath = copyPath + commonUtil.separator + "tempFileUpload";
		}

		File f = new File(commonUtil.detectPathTraversal(pDirTempPath));

		// 파일을 업로드할 폴더가 존재하지 않으면 생성한다.            
		if (!f.exists()) {
			f.mkdirs();
		}

		String saveLocalPath = pDirTempPath + commonUtil.separator + newfilename;
		String orgFileName = sFileTitle + "." + sExt;            
		//long fileSize = 0; //2019.03.25 천성준 - 사용안해서 일단 주석
		// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
		if ((sExt.isEmpty() || useExtension.toLowerCase().indexOf(sExt.toLowerCase()) == -1) && !useExtension.equals("*")) {
			extResult = "denied";
		} else {
			// 대용량 첨부파일의 경우에는 후에 다운로드 받을 때 파일명을 내려보내기 위해 원 파일명을 저장한다.                
			if (pBigFileUpload.equals("Y")) {                    
				String base64OrgFileName = Base64.encodeBase64String(orgFileName.getBytes("UTF-8"));
				FileOutputStream fos = null;

				try {
					File nameFile = new File(commonUtil.detectPathTraversal(saveLocalPath + "__.txt"));
					fos = new FileOutputStream(nameFile);
					fos.write(base64OrgFileName.getBytes("ISO-8859-1"));
				} catch (Exception e) {
					throw e;
				} finally {
					if (fos != null) {
						fos.close();
					}
				}
			}
			
			File file2 = new File(commonUtil.detectPathTraversal(pDirTempPath + commonUtil.separator + newfilename));
			File file3 = new File(commonUtil.detectPathTraversal(realPath +  commonUtil.separator + sFileHref ));
			
			if (!file2.exists()) {
				
				// useHwpDownSecurity의 값이 Y일 때, 배포용 문서로 변환된 파일은 URL을 통해 웹한글기안기 서버에서 해당 파일을 다운로드
				if (useHwpDownSecurity.equals("Y") && approvalFlag.equals("G") && sExt.equalsIgnoreCase("hwp") && sFileTypeCode.equals("document") && !sFileUrl.equals("noUrl")) {
					String targetFilePath = commonUtil.detectPathTraversal(pDirTempPath + commonUtil.separator + newfilename);
					Path pathTarget = Paths.get(targetFilePath);
					URL downloadUrl = new URL(sFileUrl);
					InputStream inpStream = null;
					
					try {
						inpStream = downloadUrl.openStream();
						Files.copy(inpStream, pathTarget);
						
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
				} else {
					FileUtils.copyFile(file3, file2);
				}
			}

			extResult = "OK";
		}

		logger.debug("mail_interuploadX_Server ended");

		// 2023-05-23 이사라 : 시큐어코딩 문자열 비교 오류 수정
		if ("Y".equalsIgnoreCase(pBigFileUpload)) {
			return pDate + "|!|" + copyPath + commonUtil.separator + newfilename + "_kaonisplit_" + pBigFileUpload + "_" + extResult;
		} else {
			return copyPath + commonUtil.separator + newfilename + "_kaonisplit_" + pBigFileUpload + "_" + extResult;
		}
	}
	
	/**
	 * 전자결재 한글양식 정보 버튼 
	 */	
	@RequestMapping(value = "/ezApprovalG/ezDocInfoG_View.do", method = RequestMethod.GET)
	public String ezDocInfoG_View(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezDocInfoG_View started");

		String urgentApproval = "";
		String summary = "";
		String specialRecordCode = "";
		String publicityCode = "";
		String limitRange = "";
		String pageNum = "";
		String securityCode = "";
        String securityDate = "";
        
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
        String docID = request.getParameter("docID");
        String pIngFlag = request.getParameter("ingFlag");

        String strXML = ezApprovalGService.getDocInfo(docID, pIngFlag, "UrgentApproval;SpecialRecordCode;PublicityCode;LimitRange;PageNum;Summary;SecurityCode;SecurityApproval", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");

		Document xmlDom = commonUtil.convertStringToDocument(strXML);
		
		if (xmlDom.getElementsByTagName("SUMMARY").getLength() > 0) {
			summary = xmlDom.getElementsByTagName("SUMMARY").item(0).getTextContent();
		}
		
		if (xmlDom.getElementsByTagName("PAGENUM").getLength() > 0) {
			pageNum = xmlDom.getElementsByTagName("PAGENUM").item(0).getTextContent();
		}
		
		if (xmlDom.getElementsByTagName("LIMITRANGE").getLength() > 0) {
			limitRange = commonUtil.cleanValue(xmlDom.getElementsByTagName("LIMITRANGE").item(0).getTextContent());
		}
		
		if (xmlDom.getElementsByTagName("PUBLICITYCODE").getLength() > 0) {
			publicityCode = xmlDom.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent();
		}
		
		if (xmlDom.getElementsByTagName("SPECIALRECORDCODE").getLength() > 0) {
			specialRecordCode = xmlDom.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent();
		}
		
		if (xmlDom.getElementsByTagName("URGENTAPPROVAL").getLength() > 0) {
			urgentApproval = xmlDom.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent();
		}
		
		if (xmlDom.getElementsByTagName("SECURITYCODE").getLength() > 0) {
			securityCode = xmlDom.getElementsByTagName("SECURITYCODE").item(0).getTextContent();
		}
		
		if (xmlDom.getElementsByTagName("SECURITYAPPROVAL").getLength() > 0) {
			securityDate = xmlDom.getElementsByTagName("SECURITYAPPROVAL").item(0).getTextContent();
		}
                
        if (securityDate.isEmpty()) {
        	securityDate = "N";
        }

        String securityNode = ezApprovalGService.getSecurityType("", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag );
		
        model.addAttribute("urgentApproval", urgentApproval);
        model.addAttribute("summary", summary);
        model.addAttribute("specialRecordCode", specialRecordCode);
        model.addAttribute("publicityCode", publicityCode);
        model.addAttribute("limitRange", limitRange);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("securityCode", securityCode);
        model.addAttribute("securityDate", securityDate);
        model.addAttribute("docID", docID);
        model.addAttribute("pIngFlag", pIngFlag);
        model.addAttribute("securityNode", securityNode);
        
		logger.debug("ezDocInfoG_View ended");
		
		return "ezApprovalG/apprGezDocInfoGView";
	}
	
	/**
	 * 전자결재 한글양식 결재완료 문서 보기
	 */	
	@RequestMapping(value = "/ezApprovalG/ezViewEnd_HWP.do", method = RequestMethod.GET)
	public String ezViewEnd_HWP(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezViewEnd_HWP started");

		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String listSusin = request.getParameter("listSusin");
		String orgDocID = request.getParameter("orgDocID");
		String formID = request.getParameter("formID");
		String sendType = request.getParameter("sendType");
		String endDir = "";
		String docTitle = request.getParameter("title");
		String susinAdmin = "";
        String pass = "";
        String orgCompanyID = request.getParameter("orgCompanyID");
        String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		String uFlag = request.getParameter("uFlag");
		
        userInfo = commonUtil.aprUserInfo(loginCookie);

        String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
        String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
 
		if (orgDocID != null  && !orgDocID.equals("")) {
			endDir = String.valueOf(Integer.parseInt(orgDocID) % 1000);
		}

		String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
		// 2023-10-16 전인하 - 전자결재G > 배부대장 > 문서 열람 시 진행문서/완료문서 여부에 관게없이 권한 체크 진행
		/* 2023-07-17 민지수 - 전자결재 > 배부대장 > 진행/완료 체크 */
		String docAprEnd ="";
		if ((uFlag != null && uFlag.equals("m03")) || (uFlag != null && uFlag.equals("m14"))) {
			docAprEnd = ezApprovalGService.getAprOrEndStr(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		}

		if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("q=1") && !userInfo.getRollInfo().contains("m=1")) {
			if (docAprEnd.equals("APR")) {
				pass = ezApprovalGService.getAccessYNGforAPR(docID, accessInfo, approvalFlag, userInfo);
			} else {
				pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());
			}
		} else {
			pass = "<RESULT>TRUE</RESULT>";
		}
		
		if (pass.equals("<RESULT>TRUE</RESULT>")) {
           if (docHref.trim().equals("") || docHref.indexOf("/1000/") >= 0) {
                String strXML = ezApprovalGService.getDocInfo(docID, "END", "Href", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");

        		Document xmlDom = commonUtil.convertStringToDocument(strXML);

                if (xmlDom.getElementsByTagName("HREF").getLength() > 0) {
                	if (!xmlDom.getElementsByTagName("HREF").item(0).getTextContent().trim().equals("")) {
                		docHref = xmlDom.getElementsByTagName("HREF").item(0).getTextContent().trim();
                	}
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
        }
		
		if (sendType == null || sendType.equals("")) {
			sendType = ezApprovalGService.getDocSendType(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("listSusin", listSusin);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("formID", formID);
		model.addAttribute("endDir", endDir);
		model.addAttribute("docTitle", docTitle);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("hwpToolbar", hwpToolbar);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("sendType", sendType);
		model.addAttribute("pass", pass);
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		
		// 전자결재 미리보기 영역에서 열렸는지 여부 플래그
		model.addAttribute("isPreview", isPreview);
		
		logger.debug("ezViewEnd_HWP ended");
		
		return "ezApprovalG/apprGviewEndHWP";
	}
	
	
	
	@RequestMapping(value = "/ezApprovalG/ezRecevGSusinHWP.do", method = RequestMethod.GET)
	public String ezRecevGSusinHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezRecevGSusinHWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optIsSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");

		String sihangURL = ezApprovalGService.getOptionInfo("A36", "004", userInfo, "CODE");
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());

		String docID = request.getParameter("docID");
		String orgDocID = request.getParameter("uOrgID");
		String isReDraft = request.getParameter("isReDraft");
		String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String draftFlag = request.getParameter("draftFlag");
		String retFlag = request.getParameter("retFlag");
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		String approvalRoot = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String dirPath = commonUtil.getRealPath(request) + approvalRoot;

		String rtnVal = ezApprovalGService.getOrgDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String pSusinAdmin = "";
        if (userInfo.getRollInfo().indexOf("a=1") > -1) {
        	pSusinAdmin = "YES";
        } else {
        	pSusinAdmin = "NO";
        }
        
		Document xmlDom = commonUtil.convertStringToDocument(rtnVal);
		
		if (xmlDom.getElementsByTagName("ORGHREF").getLength() > 0) {
			String orgDocFile = xmlDom.getElementsByTagName("ORGHREF").item(0).getTextContent();
			String docFile = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();
			
			orgDocFile = dirPath + orgDocFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			docFile = dirPath + docFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			
			String dir = docFile.substring(0, docFile.lastIndexOf(commonUtil.separator) + 1);
			File file = new File(commonUtil.detectPathTraversal(dir));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			File newFile = new File(commonUtil.detectPathTraversal(docFile));
			
			if (!newFile.exists()) {
				File orgFile = new File(commonUtil.detectPathTraversal(orgDocFile));
				InputStream orgFileInputStream = null;

				// CWE-404 보안 취약점 대응
				try {
					// 2018.06.21 - KLIB으로 암호화된 파일일 때는 복호화 하여 저장
					if (orgDocFile.endsWith("." + EzApprovalGKlibServiceImpl.ENCRYPTED_FILE_EXT)) {
						byte[] encryptedBytes = commonUtil.readBytesFromFile(orgFile.toPath());
						orgFileInputStream = new ByteArrayInputStream(klibUtil.decrypt(encryptedBytes));
					} else {
						orgFileInputStream = new FileInputStream(orgFile);
					}
					
					Files.copy(orgFileInputStream, newFile.toPath());
				} finally {
					if (orgFileInputStream != null) {
						orgFileInputStream.close();
					}
				}
			}
		}
		
		// 비전자문서 구분 값  (return >> "Y" = TRUE, "" = FALSE)
		String isNonElecRec = ezApprovalGService.checkNonElecRec(orgDocID, userInfo.getCompanyID(), userInfo.getTenantId());

		String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
		/* 2020-03-31 홍승비 - 재기안 시 반송의견 유지여부 컨피그 추가 */
		String useRedraftOpinionKeep = ezCommonService.getTenantConfig("useRedraftOpinionKeep", userInfo.getTenantId());
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optIsSplit", optIsSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("sihangURL", sihangURL);
		model.addAttribute("docID", docID);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("isReDraft", isReDraft);
		model.addAttribute("hwpToolbar", hwpToolbar);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("retFlag", retFlag);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("isNonElecRec", isNonElecRec);
		model.addAttribute("approvalRoot", approvalRoot);
		model.addAttribute("useReceiveDocNo", useReceiveDocNo);
		model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));
		model.addAttribute("useRedraftOpinionKeep", useRedraftOpinionKeep);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("pSusinAdmin", pSusinAdmin);
		
		logger.debug("ezRecevGSusinHWP ended");
		
		return "ezApprovalG/apprGrecevgsusinHWP";
	}	
	
	
	@RequestMapping(value = "/ezApprovalG/ezDeptRecevUI_HWP.do", method = RequestMethod.GET)
	public String ezDeptRecevUI_HWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezDeptRecevUI_HWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optIsSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

		String docID = request.getParameter("docID");
		String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String draftFlag = request.getParameter("draftFlag");
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String opinionYN = "N";
        String opinionGamsaYN = "N";
        String usePassword = "N";
		String pSusinAdmin = "";
		String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "form" + commonUtil.separator;
		
		String useDirectSign = ezCommonService.getTenantConfig("USE_DirectSign", userInfo.getTenantId());
		String draftDeptID = ezApprovalGService.getOrgDraftDeptID(docID, userInfo.getTenantId(), userInfo.getCompanyID());
		String signImageSize = ezCommonService.getTenantConfig("SignImageSize", userInfo.getTenantId());
		String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		if (approvalFlag.equals("G")) {
			String nonElecRec = ezApprovalGService.checkNonElecRec(docID, userInfo.getCompanyID(), userInfo.getTenantId());
			if (!nonElecRec.equals("")) {
				model.addAttribute("nonElecRec", nonElecRec);
			}
		}
		
		String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
		
        if (userInfo.getRollInfo().indexOf("a=1") > -1) {
        	pSusinAdmin = "YES";
        } else {
        	pSusinAdmin = "NO";
        }
        
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optIsSplit", optIsSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("docID", docID);
		model.addAttribute("hwpToolbar", hwpToolbar);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("pSusinAdmin", pSusinAdmin);
		model.addAttribute("opinionYN", opinionYN);
		model.addAttribute("opinionGamsaYN", opinionGamsaYN);
		model.addAttribute("usePassword", usePassword);
		model.addAttribute("isHWP", "Y");
		model.addAttribute("dirPath", dirPath);
		model.addAttribute("useDirectSign", useDirectSign);
		
		model.addAttribute("draftDeptID", draftDeptID);
		model.addAttribute("useReceiveDocNo", useReceiveDocNo);
		model.addAttribute("docNumZeroCnt", docNumZeroCnt);
		model.addAttribute("signImageSize", signImageSize);
		
		logger.debug("ezDeptRecevUI_HWP ended");
		return "ezApprovalG/apprGdeptRecevuiHWP";
	}
	

	@RequestMapping(value = {"/ezApprovalG/ezSimsaG_HWP.do", "/ezApprovalG/ezConvSihang_HWP.do"}, method = RequestMethod.GET)
	public String ezSimsaG_HWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezSimsaG_HWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
	    String docID = request.getParameter("docID");
	    String docHref = request.getParameter("docHref");
	    String orgDocID = request.getParameter("orgDocID");
	    String docTitle = request.getParameter("docTitle");
	    String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
	    String Use_ImgTagTOAttah_body = "N";
	    String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
	    String approvalRoot = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator;
	    String orgCompanyID = request.getParameter("orgCompanyID");

        boolean isConvSihang = false;
        if (request.getRequestURI().endsWith("ezConvSihang_HWP.do")) {
            isConvSihang = true;
        }
        
        //회사아이디가 기관코드로 안돼있기때문에 지정해줘야됨
        String companyID = "";
        if (!isConvSihang) {
            //기관코드와 회사 아이디가 다를 경우 보정처리.
            companyID = config.getProperty("config.companyNum");
        } else {
            companyID = orgCompanyID;
        }
        userInfo.setCompanyID(companyID);

	    model.addAttribute("userInfo", userInfo);
	    model.addAttribute("docID", docID);
	    model.addAttribute("docHref", docHref);
	    model.addAttribute("orgDocID", orgDocID);
	    model.addAttribute("hwpToolbar", hwpToolbar);
	    model.addAttribute("useEditor", useEditor);
	    model.addAttribute("approvalRoot", approvalRoot);
	    model.addAttribute("approvalPWD", approvalPWD);
	    model.addAttribute("Use_ImgTagTOAttah_body", Use_ImgTagTOAttah_body);
	    model.addAttribute("orgCompanyID", orgCompanyID);
	    model.addAttribute("docTitle", docTitle);
	    model.addAttribute("isConvSihang", isConvSihang);
		
		logger.debug("ezSimsaG_HWP ended");
		
		return "ezApprovalG/apprGezSimsagHWP";
	}	
		
	/**
	 * 전자결재G 발송의뢰문서 발송 발송 저장 Method
	 */
	@RequestMapping(value = "/ezApprovalG/saveEndFileHwp.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String saveEndFile(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, @RequestBody JSONObject jsonObj) throws Exception{
		logger.debug("saveEndFileHwp started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = "";
		String docID = jsonObj.get("docID") == null ? null : jsonObj.get("docID").toString();
		String formText = jsonObj.get("html") == null ? "" : jsonObj.get("html").toString();
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String path = commonUtil.getRealPath(request) +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		try {
			if (docID == null || formText.equals("")) {
				result = "FAIL";
				
				logger.debug("<<<docID : " + docID);
				logger.debug("<<<formText : " + formText);
				logger.debug("there is no primary data.");

				return result;
			}
			
			File file = new File(commonUtil.detectPathTraversal(path + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID)));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			String saveFileName = path + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator + docID + ".hwp";
			saveFileName = commonUtil.detectPathTraversal(saveFileName);
			byte[] documentBytes = Base64.decodeBase64(formText);
			
			// 2018.08.23 KLIB 암호화
			if ("yes".equalsIgnoreCase(ezCommonService.getTenantConfig("useApprovalKlib", userInfo.getTenantId()))) {
				documentBytes = klibUtil.encrypt(documentBytes);
				saveFileName += "." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT;
			}
			
			commonUtil.writeBytesToFile(Paths.get(commonUtil.detectPathTraversal(saveFileName)), documentBytes);

			result = "SUCCESS";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result = "FAIL";
		}
		
		logger.debug("saveEndFileHwp ended");
		
		return result;
	}
	
	/**
	 * 직인의뢰접수HWP화면 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezConvOutHWP.do", method = RequestMethod.GET)
	public String ezConvOutHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezConvOutHWP started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("hwpToolbar", hwpToolbar);
		
		logger.debug("ezConvOutHWP ended.");
		
		return "/ezApprovalG/apprGezConvOutHWP";
	}
	
	public String makeXMLString(String orgString) throws Exception{
		return orgString.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
	}
	
	/**
	 * 결재문서 > 저장버튼 다운로드
	 */
	@RequestMapping(value = "/ezApprovalG/downloadHWPdoc.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		logger.debug("============ downloadHWPdoc started ============");
		
		userInfo = commonUtil.userInfo(loginCookie);		
		
		String docID = request.getParameter("DocId");
		int tenantID = userInfo.getTenantId();
		String companyID = userInfo.getCompanyID();
		
		ApprGDocInfoWebSrvVO fileVO = ezApprovalGService.getHWPdownload(docID, tenantID, companyID);
		
		String filePath = fileVO.getHref();
		String fileName = fileVO.getDocTitle() + ".hwp";
		
		String realPath = commonUtil.getRealPath(request);
		/*String uploadFilePath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());*/
		
		if (fileName == null || fileName.equals("")) {
			fileName = filePath; 
		}
		
		String fullFilePath = realPath + filePath;

		downFile(request, response, fullFilePath, fileName);	
	}
	
	
	/**
	 * 전자결재 웹한글기안기
	 */
	@RequestMapping(value = "/ezApprovalG/draftuiWHWP.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String draftuiWHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("draftuiHWP started");
		
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
		String nonElecRec = request.getParameter("nonElecRec");
		String connKey = StringUtils.defaultString(request.getParameter("connKey"));
		String connFormCode = StringUtils.defaultString(request.getParameter("connFormCode"));
		String docSN = "";
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		String attachedDocList = request.getParameter("attachedDocList") == null ? "" : request.getParameter("attachedDocList");
		
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());
		String draftJunGyulFlag = ezCommonService.getTenantConfig("draftJunGyulFlag", userInfo.getTenantId());

		if (nonElecRec == null) {
			nonElecRec = "";
		}
		
		if (listType.equals("21")) {
			if (request.getParameter("docSN") != null) {
				docSN = request.getParameter("docSN");
			}
		}
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0,4) + commonUtil.separator;
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
		String sihangURL = ezApprovalGService.getOptionInfo("A36", "004", userInfo, "CODE");
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String optIsSplit = ezApprovalGService.getOptionInfo(approvalFlag.equals("S") ? "SA33" : "A33", "001", userInfo, "CODE");
		String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
		/* 2020-03-31 홍승비 - 재기안 시 반송의견 유지여부 컨피그 추가 */
		String useRedraftOpinionKeep = ezCommonService.getTenantConfig("useRedraftOpinionKeep", userInfo.getTenantId());
		
		/* 2020-11-13 홍승비 - 대용량첨부 관련 파라미터 추가 */
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
		String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String bigAttachDownloadPeriod = EgovDateUtil.getToday("/") + " ~ " + EgovDateUtil.addDay(EgovDateUtil.getToday("/"), Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");
		
		String preSusinGroupStr = ezApprovalGService.getCode2Name("A53", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		String beforeUrl = "";
		String beforeDocID = ObjectUtils.defaultIfNull(request.getParameter("beforeDocID"), "");
		String isUsed = ObjectUtils.defaultIfNull(request.getParameter("isUsed"), "");
		String fromGongram = request.getParameter("fromGongram");
		String orgDocID = request.getParameter("orgDocID");
		
		if (!beforeDocID.isEmpty()) {
			if (fromGongram != null && fromGongram.equals("1") && isUsed.equals("reuse")) {
				beforeDocID = orgDocID;
			}
			beforeUrl = ezApprovalGService.getDocHref(beforeDocID, "END", "", "", userInfo.getCompanyID(), userInfo.getTenantId());
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
		
		model.addAttribute("approvalFlag", approvalFlag);
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
		model.addAttribute("docSN", docSN);
		model.addAttribute("isHWP", "Y");
		model.addAttribute("nonElecRec", nonElecRec);
		model.addAttribute("useReceiveDocNo", useReceiveDocNo);
		model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));
		model.addAttribute("useOpenGov", config.getProperty("config.useOpenGov"));
		model.addAttribute("useRedraftOpinionKeep", useRedraftOpinionKeep);
		model.addAttribute("beforeUrl", beforeUrl);
		model.addAttribute("beforeDocID", beforeDocID);
		model.addAttribute("isUsed", isUsed);
		
		//결재 세부정보
		String formId = ezApprovalGService.getFormId(formURL);
		String formAprOption = ezApprovalGService.getFormAprOptionInfo(formId, "FORM", userInfo.getCompanyID(), userInfo.getTenantId());
		model.addAttribute("formAprOption", formAprOption);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("connKey", connKey);
		model.addAttribute("connFormCode", connFormCode);
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		// 비전자문서의 기안 시 파라미터 오류 방지
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("preSusinGroupStr", preSusinGroupStr);

		// 2022-03-03 박기범 : 양식파일 경로 추가
		String formPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "form" + commonUtil.separator;

		if (isTmpDoc != null && !isTmpDoc.isEmpty()) {
			formPath += ezApprovalGService.getFormIdFromApr(isTmpDoc, userInfo.getCompanyID(), userInfo.getTenantId());
		} else {
			formPath += formId;
		}

		model.addAttribute("formPath", formPath + ".hwp");
		
		model.addAttribute("isPreview", isPreview);
		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		model.addAttribute("attachedDocList", attachedDocList);
		model.addAttribute("tenantID",userInfo.getTenantId());
		model.addAttribute("junGyulFlag", junGyulFlag);
		model.addAttribute("draftJunGyulFlag", draftJunGyulFlag);
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

		logger.debug("draftuiWHWP ended. formPath:" + formPath);
		
		return "ezApprovalG/apprGdraftuiWHWP";
	}
	
	/**
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 * 전자결재 한글결재 오픈
	 */
	@RequestMapping(value = "/ezApprovalG/approvuiWHWP.do", method = RequestMethod.GET)
	public String approvuiWHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("approvuiWHWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String susinAdmin = "";
		String orgAprUserID = request.getParameter("id");
		String orgAprUserName = request.getParameter("name");
		String orgAprUserDeptID = request.getParameter("deptID");
		String docID = request.getParameter("docID");
		String tempUserID = userInfo.getId();
		String orgDocID = request.getParameter("orgDocID");
		String useOpenGov = config.getProperty("config.useOpenGov");
		String allFlag = request.getParameter("allFlag");
		//hwp 툴바가 6줄인데 맨윗줄 부터 '1' 이면 사용 '0' 이면 사용하지 않는다. ex)'100001' 맨위랑 맨아래 툴바만 표시
        String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
        String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		String docState = request.getParameter("docState");
		String mailChk = request.getParameter("mailchk");// 메일에서 전저결재 열람 여부('Y'일때는 메일 그 외에는 전자결재)
		String mode = request.getParameter("mode");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());
		String draftJunGyulFlag=ezCommonService.getTenantConfig("draftJunGyulFlag", userInfo.getTenantId());
		String signImageType = ezCommonService.getTenantConfig("signImageType", userInfo.getTenantId());
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		if (docID == null) {
			docID = "";
		}
		
		if (mailChk == null) {
			mailChk = "";
		}
		
		if (orgDocID == null) {
			orgDocID = "";
		}

        if (userInfo.getRollInfo().indexOf("a=1") > -1) {
        	susinAdmin = "YES";
        } else {
        	susinAdmin = "NO";
        }
                
        String docDir = docID.substring(docID.length() - 3);
                
        if (docDir.substring(0, 1).equals("0")) {
        	docDir = docDir.substring(docDir.length() - 2, 2);
        } else if (docDir.substring(0, 2).equals("00")) {
        	docDir = docDir.substring(docDir.length() - 1, 1);
        } else if (docDir.equals("000")) {
        	docDir = "0";
        }

        String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
        String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + docDir + "." + docID + ".hwp" ;

        if (!allFlag.equals("1") && !allFlag.equals("2")) {
        	allFlag = "0";
        }
        
        if (!docID.equals("")) {
			//String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1", userInfo.getTenantId(), userInfo.getOffset());
        	String proxyUser = ezApprovalGService.getProxyUser2(userInfo.getId(), "1", userInfo.getTenantId(), userInfo.getOffset());
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
			
			if (checkPermission) {
				Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), "APR", userInfo.getCompanyID(), userInfo.getTenantId(), docState);
				
				if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
					if(mailChk != null && mailChk.equals("Y")) {
						model.addAttribute("chk", "no");
					}
					return "main/warning";
				}
			}
		}
        
        String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
        String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
        String optisSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
        String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
        String optjunKyukInfo = ezApprovalGService.getOptionInfo("A32", "001", userInfo, "CODE");
        String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
        
        String nonElecRec = ezApprovalGService.checkNonElecRec(orgDocID, userInfo.getCompanyID(), userInfo.getTenantId());
        if (!nonElecRec.equals("")) {
        	model.addAttribute("nonElecRec", nonElecRec);
        }
        
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
		
		// 2024-06-11 김우철 - 부서수신함에서 첨부, 문서첨부 기능 사용여부
		String useReceiptDeptFileAttach = ezCommonService.getTenantConfig("useReceiptDeptFileAttach", userInfo.getTenantId());
		

		String addLastKyulJeYN = ezCommonService.getTenantConfig("addLastKyulJeYN", userInfo.getTenantId());

		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
			useAprFilePrvw = "1";
		} else {
			useAprFilePrvw = "0";
		}

		/* 2024-12-10 기민혁 - 수정버전 변경 기능 사용 여부 */
		String editVersionYN = ezCommonService.getTenantConfig("EditVertionYN",userInfo.getTenantId());
		
        model.addAttribute("approvalFlag", approvalFlag);
        model.addAttribute("approvalPWD", approvalPWD);
        model.addAttribute("useEditor", useEditor);
		model.addAttribute("orgAprUserID", orgAprUserID);
		model.addAttribute("orgAprUserName", orgAprUserName);
		model.addAttribute("orgAprUserDeptID", orgAprUserDeptID);
		model.addAttribute("docID", docID);
        model.addAttribute("tempUserID", tempUserID);
        model.addAttribute("optSignDateFormat", optSignDateFormat);
        model.addAttribute("optisSplit", optisSplit);
        model.addAttribute("optSplitKind", optSplitKind);
        model.addAttribute("optjunKyukInfo", optjunKyukInfo);
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("allFlag", allFlag);
        model.addAttribute("oldYear", oldYear);
        model.addAttribute("dirPath", dirPath);
        model.addAttribute("hwpToolbar", hwpToolbar);
        model.addAttribute("susinAdmin", susinAdmin);
        model.addAttribute("docState", docState);
        model.addAttribute("isHWP", "Y");
        model.addAttribute("useReceiveDocNo", useReceiveDocNo);
        model.addAttribute("orgCompanyID", orgCompanyID);
        model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));

		if (useOpenGov.equalsIgnoreCase("YES") && approvalFlag.equalsIgnoreCase("G")) {
			Map<String, Object> openGovMap = ezApprovalGService.getOpenGovInfo(docID, userInfo.getTenantId(), userInfo.getCompanyID());

			model.addAttribute("basis", openGovMap.get("basis"));
			model.addAttribute("reason", openGovMap.get("reason"));
			model.addAttribute("listOpenFlag", openGovMap.get("listOpenFlag"));
			model.addAttribute("fileOpenFlagList", openGovMap.get("fileOpenFlagList"));
		}

		model.addAttribute("useOpenGov", useOpenGov);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		//결재 세부정보
		String formAprOption = ezApprovalGService.getFormAprOptionInfo(docID, "DOC", userInfo.getCompanyID(), userInfo.getTenantId());
		model.addAttribute("formAprOption", formAprOption);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));

		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		model.addAttribute("preSusinGroupStr", preSusinGroupStr);
		model.addAttribute("isPreview", isPreview);

		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		
		model.addAttribute("useReceiptDeptFileAttach", useReceiptDeptFileAttach);
		/* 2024-06-24 양지혜 - 지정반송 사용 여부 */
		model.addAttribute("useReturnByDesignation", ezCommonService.getTenantConfig("returnByDesignationUsed", userInfo.getTenantId()));
		
		model.addAttribute("draftJunGyulFlag", draftJunGyulFlag);
		model.addAttribute("junGyulFlag", junGyulFlag);
		model.addAttribute("useReceiveInfoName", ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId())); // 수신처에 "장" 붙이는 옵션
		model.addAttribute("addLastKyulJeYN", addLastKyulJeYN);
		model.addAttribute("signImageType", signImageType);
		model.addAttribute("editVersionYN", editVersionYN);

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

		// 2025-02-18 박기범 - 프론트에서 문서 편집시, 문서를 오픈한 이후로 다른 문서/결재진행 변화가 있었는지 체크하기 위한 코드
		model.addAttribute("snapshotCode", ezApprovalGService.getDocumentSnapshotCode(userInfo.getTenantId(), userInfo.getCompanyID(), docID));

		logger.debug("approvuiWHWP ended");
		
		return "/ezApprovalG/apprGapprovuiWHWP";
	}
	
	/**
	 * 전자결재 한글양식 결재완료 문서 보기
	 */	
	@RequestMapping(value = "/ezApprovalG/ezViewEnd_WHWP.do", method = RequestMethod.GET)
	public String ezViewEnd_WHWP(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezViewEnd_WHWP started");

		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String listSusin = request.getParameter("listSusin");
		String orgDocID = request.getParameter("orgDocID");
		String formID = "";
		String sendType = request.getParameter("sendType");
		String endDir = "";
		String docTitle = request.getParameter("title");
		String susinAdmin = "";
        String pass = "";
        String orgCompanyID = request.getParameter("orgCompanyID");
        String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
        userInfo = commonUtil.aprUserInfo(loginCookie);

        String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
        String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());

		String docAttachParent = request.getParameter("docAttachParent") != null ? request.getParameter("docAttachParent") : "";
		boolean isDocAttach =  StringUtils.isNotBlank(docAttachParent);

		/* 진행/완료(APR/END) 체크 */
		String docAprEnd = ezApprovalGService.getAprOrEndStr(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		/* 2023-12-07 홍승비 - 전자결재 서명데이터 재맵핑에 필요한 docState 파라미터 추가 */
		String docState = request.getParameter("docState") != null ? request.getParameter("docState") : "";
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
 
		if (orgDocID != null  && !orgDocID.equals("")) {
			endDir = String.valueOf(Integer.parseInt(orgDocID) % 1000);
		}

		String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
		
		if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("q=1") && !userInfo.getRollInfo().contains("m=1")) {
			if (docAprEnd.equals("APR")) {
				pass = ezApprovalGService.getAccessYNGforAPR(docID, accessInfo, approvalFlag, userInfo);
			} else {
				pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());
			}
			// 2024-06-11 양지혜 - 취약점보완 : 보안결재 체크
			String securityDate = ezApprovalGService.checkSecurityApprovalDate(docID, userInfo.getCompanyID(), userInfo.getTenantId(), docAprEnd);
			if (!securityDate.equals("")) {
				String checkLine = ezApprovalGService.checkAprLine(docID, docAprEnd, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
				if (checkLine.equals("<RESULT>FALSE</RESULT>") && formatter.parse(commonUtil.getTodayUTCTime("yyyy-MM-dd")).compareTo(formatter.parse(securityDate)) < 0) {
					pass = "<RESULT>FALSE</RESULT>";
				}
			}
		} else {
			pass = "<RESULT>TRUE</RESULT>";
		}
		
		if (pass.equals("<RESULT>TRUE</RESULT>")) {
			String strXML = ezApprovalGService.getDocInfo(docID, docAprEnd, "ALL", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
			Document xmlDom = commonUtil.convertStringToDocument(strXML);
			
			if (xmlDom.getElementsByTagName("FORMID").getLength() > 0) {
				formID = xmlDom.getElementsByTagName("FORMID").item(0).getTextContent().trim();
			}
			
           if (docHref.trim().equals("") || docHref.indexOf("/1000/") >= 0) {
                if (xmlDom.getElementsByTagName("HREF").getLength() > 0) {
                	if (!xmlDom.getElementsByTagName("HREF").item(0).getTextContent().trim().equals("")) {
                		docHref = xmlDom.getElementsByTagName("HREF").item(0).getTextContent().trim();
                	}
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
        } else {
			// #147057 - 권한 없는 사용자가 결재선열람인 일괄기안 문서 열람할 때 빈 화면으로 표시되는 결함
			// 2024-10-15 박기범 : 권한 없을시 받아오지 못하는 정보를 아래 로직에서 이용시 exception 발생.
			// 권한 없을시 다른 DB조회 필요 없고 권한없음 페이지 표출하므로 바로 리턴 처리 함.
			return "main/warning";
		}
		
		if (sendType == null || sendType.equals("")) {
			sendType = ezApprovalGService.getDocSendType(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		}
		
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
		
		/* 2023-12-07 홍승비 - docState값이 정상적으로 전달되지 않은 경우, 해당 값을 찾아 페이지로 전달 */
		if (docState.equalsIgnoreCase("")) {
			ApprGDocListVO apprGDocVO = null;
			docAprEnd = ezApprovalGService.getAprOrEndStr(docID, userInfo.getCompanyID(), userInfo.getTenantId());
			
			if (docAprEnd.equals("APR")) {
				apprGDocVO = ezApprovalGService.getIngDocInfo(userInfo.getId(), docID.trim(), orgCompanyID, userInfo.getTenantId());
			} else {
				apprGDocVO = ezApprovalGService.getEndDocInfo(docID.trim(), orgCompanyID, userInfo.getTenantId());
			}
			
			if (apprGDocVO != null && apprGDocVO.getDocState() != null) {
				docState = apprGDocVO.getDocState();
			}
		}
		
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("listSusin", listSusin);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("formID", formID);
		model.addAttribute("endDir", endDir);
		model.addAttribute("docTitle", docTitle);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("hwpToolbar", hwpToolbar);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("sendType", sendType);
		model.addAttribute("pass", pass);
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("useBoard", ezCommonService.getTenantConfig("useBoard", userInfo.getTenantId()));
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		// 전자결재 미리보기 영역에서 열렸는지 여부 플래그
		model.addAttribute("isPreview", isPreview);

		model.addAttribute("useAprFilePrvw", useAprFilePrvw);

		/* 2023-07-13 민지수 - 배부대장 문서 진행/완료(APR/END) 값 전달 */
		model.addAttribute("docAprEnd", docAprEnd);
		
		/* 2023-12-07 홍승비 - 전자결재 서명데이터 재맵핑에 필요한 docState 파라미터 추가 */
		model.addAttribute("docState", docState);

		/* 이유정 - 첨부문서 확인 여부 (첨부문서 창 닫을시 발생하는 오류 방지를 위한 Flag) */
		model.addAttribute("isDocAttach", isDocAttach);
		
		/* 2024-06-26 조소정 - 웹한글 문서 재사용 시 양식선택창 표출 여부 테넌트 컨피그와 양식 정보 */
		String resultXML = ezApprovalGService.getFormInfoDetail(formID, userInfo.getCompanyID(), userInfo.getTenantId());
        Document formInfo = commonUtil.convertStringToDocument(resultXML);
        
        /* 2024-11-07 홍승비 - 전자결재 (일반, G) > 완료된 웹한글 문서가 합의접수문서(FORMID = 2003000007)인 경우, TBL_FORMINFO에 레코드가 없으므로 예외처리 추가 (MHT와 동일) */
        String formUrl = "";
        String formDocType = "";
        
        if (formInfo.getElementsByTagName("FORMFILELOCATION").getLength() > 0) {
			formUrl = formInfo.getElementsByTagName("FORMFILELOCATION").item(0).getTextContent().trim();
		}
		if (formInfo.getElementsByTagName("FORMDOCTYPE").getLength() > 0) {
			formDocType = formInfo.getElementsByTagName("FORMDOCTYPE").item(0).getTextContent().trim(); 
		}
        
        model.addAttribute("formUrl", formUrl);
        model.addAttribute("formDocType", formDocType);
		model.addAttribute("useFormContOnReuseForWHWP", ezCommonService.getTenantConfig("useFormContOnReuseForWHWP", userInfo.getTenantId()));

		logger.debug("ezViewEnd_WHWP ended");
		
		return "ezApprovalG/apprGviewEndWHWP";
	}
	
	/**
	 * 
	 */	
	@RequestMapping(value = "/ezApprovalG/ezviewAprWHWP.do", method = RequestMethod.GET)
	public String ezviewAprWHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezviewAprWHWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String susinAdmin = "";
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String formID = "";
		String opinionFlag = request.getParameter("opinionFlag");
		String docState = request.getParameter("docState");
		String listSusin = request.getParameter("listSusin");
		String orgDocID = request.getParameter("oDoc");
		String showOpinion = request.getParameter("isOpinion");
		String listTypeValue = request.getParameter("listType");
		String hasOpinionYN = "";
		String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String orgCompanyID = request.getParameter("orgCompanyID");
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}

		if (userInfo.getRollInfo().indexOf("a=1") > -1 ) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}

		String strXML = ezApprovalGService.getDocInfo(docID, "APR", "ALL", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
		
		Document resultXML = commonUtil.convertStringToDocument(strXML);
		
		if (resultXML.getElementsByTagName("HASOPINIONYN").getLength() > 0) {
			if (resultXML.getElementsByTagName("HASOPINIONYN").item(0) != null && !resultXML.getElementsByTagName("HASOPINIONYN").item(0).getTextContent().trim().equals("")) {
				hasOpinionYN = resultXML.getDocumentElement().getTextContent();
			}
		}

		if (resultXML.getElementsByTagName("FORMID").getLength() > 0) {
			if (resultXML.getElementsByTagName("FORMID").item(0) != null && !resultXML.getElementsByTagName("FORMID").item(0).getTextContent().trim().equals("")) {
				formID = resultXML.getDocumentElement().getTextContent();
			}
		}
		
		//2018-08-29 천성준 - 부서수신함에 들어온 접수문서를 최초 접수창으로 열지않고 문서보기로 열었을경우 문서파일이 생성되지 않아서 에러터지는것 수정 
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
			File file = new File(commonUtil.detectPathTraversal(dir));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			File newFile = new File(commonUtil.detectPathTraversal(docFile));
			
			if (!newFile.exists()) {
				File orgFile = new File(commonUtil.detectPathTraversal(orgDocFile));
				
				// KLIB 복호화
				if (orgDocFile.endsWith("." + EzApprovalGKlibServiceImpl.ENCRYPTED_FILE_EXT)) {
					byte[] orgBytes = commonUtil.readBytesFromFile(orgFile.toPath());
					FileUtils.writeByteArrayToFile(newFile, klibUtil.decrypt(orgBytes));
				} else {
					FileUtils.copyFile(orgFile, newFile);
				}
			}
		}
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		String forceCallBackYN = ezCommonService.getTenantConfig("forceCallBack_YN", userInfo.getTenantId());
		
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
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("forceCallBackYN", forceCallBackYN);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("useBoard", ezCommonService.getTenantConfig("useBoard", userInfo.getTenantId()));
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		model.addAttribute("isPreview", isPreview);
		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		
		/* 2024-06-26 조소정 - 웹한글 문서 재사용 시 양식선택창 표출 여부 테넌트 컨피그와 양식 정보 */
		String formInfoXML = ezApprovalGService.getFormInfoDetail(formID, userInfo.getCompanyID(), userInfo.getTenantId());
        Document formInfo = commonUtil.convertStringToDocument(formInfoXML);
		String formUrl = "";
		String formDocType	= "";

		if (formInfo.getElementsByTagName("FORMFILELOCATION").getLength() > 0) {
			formUrl = formInfo.getElementsByTagName("FORMFILELOCATION").item(0).getTextContent().trim();
		}
		
		if (formInfo.getElementsByTagName("FORMDOCTYPE").getLength() > 0) {
			formDocType = formInfo.getElementsByTagName("FORMDOCTYPE").item(0).getTextContent().trim();
		}
        
        model.addAttribute("formUrl", formUrl);
        model.addAttribute("formDocType", formDocType);
		model.addAttribute("useFormContOnReuseForWHWP", ezCommonService.getTenantConfig("useFormContOnReuseForWHWP", userInfo.getTenantId()));
		
		logger.debug("ezviewAprWHWP ended");
		
		return "ezApprovalG/apprGviewAprWHWP";
	}
	
	@RequestMapping(value = "/ezApprovalG/ezRecevGSusinWHWP.do", method = RequestMethod.GET)
	public String ezRecevGSusinWHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezRecevGSusinWHWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());

		String sihangURL = ezApprovalGService.getOptionInfo("A36", "004", userInfo, "CODE");
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String optIsSplit = ezApprovalGService.getOptionInfo(approvalFlag.equals("S") ? "SA33" : "A33", "001", userInfo, "CODE");
		String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());

		String docID = request.getParameter("docID");
		String orgDocID = request.getParameter("uOrgID");
		String isReDraft = request.getParameter("isReDraft");
		String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String draftFlag = request.getParameter("draftFlag");
		String retFlag = request.getParameter("retFlag");
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		
		String approvalRoot = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String dirPath = commonUtil.getRealPath(request) + approvalRoot;

		String viewDocFlag = request.getParameter("viewDoc") != null ? request.getParameter("viewDoc") : "";
		String orgCompanyID = request.getParameter("orgCompanyID");

		String rtnVal = ezApprovalGService.getOrgDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String pSusinAdmin = "";
        if (userInfo.getRollInfo().indexOf("a=1") > -1) {
        	pSusinAdmin = "YES";
        } else {
        	pSusinAdmin = "NO";
        }
        
		Document xmlDom = commonUtil.convertStringToDocument(rtnVal);
		
		if (xmlDom.getElementsByTagName("ORGHREF").getLength() > 0) {
			String orgDocFile = xmlDom.getElementsByTagName("ORGHREF").item(0).getTextContent();
			String docFile = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();
			
			orgDocFile = dirPath + orgDocFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			docFile = dirPath + docFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			
			String dir = docFile.substring(0, docFile.lastIndexOf(commonUtil.separator) + 1);
			File file = new File(commonUtil.detectPathTraversal(dir));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			File newFile = new File(commonUtil.detectPathTraversal(docFile));
			
			if (!newFile.exists()) {
				File orgFile = new File(commonUtil.detectPathTraversal(orgDocFile));
				InputStream orgFileInputStream = null;

				// CWE-404 보안 취약점 대응
				try {
					// 2018.06.21 - KLIB으로 암호화된 파일일 때는 복호화 하여 저장
					if (orgDocFile.endsWith("." + EzApprovalGKlibServiceImpl.ENCRYPTED_FILE_EXT)) {
						byte[] encryptedBytes = commonUtil.readBytesFromFile(orgFile.toPath());
						orgFileInputStream = new ByteArrayInputStream(klibUtil.decrypt(encryptedBytes));
					} else {
						orgFileInputStream = new FileInputStream(orgFile);
					}
					
					Files.copy(orgFileInputStream, newFile.toPath());
				} finally {
					if (orgFileInputStream != null) {
						orgFileInputStream.close();
					}
				}
			}
		}
		
		// 비전자문서 구분 값  (return >> "Y" = TRUE, "" = FALSE)
		String isNonElecRec = ezApprovalGService.checkNonElecRec(orgDocID, userInfo.getCompanyID(), userInfo.getTenantId());

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
		
		// 2023-05-26 조수빈 - 전자결재 첨부파일  미리보기 기능 사용 여부
		String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		
		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
			useAprFilePrvw = "1";
		} else {
			useAprFilePrvw = "0";
		}
		
		// 2024-06-04 김우철 - 부서수신함 첨부, 문서첨부 기능 사용 여부
		String useReceiptDeptFileAttach = ezCommonService.getTenantConfig("useReceiptDeptFileAttach", userInfo.getTenantId());
				
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optIsSplit", optIsSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("sihangURL", sihangURL);
		model.addAttribute("docID", docID);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("isReDraft", isReDraft);
		model.addAttribute("hwpToolbar", hwpToolbar);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("retFlag", retFlag);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("isNonElecRec", isNonElecRec);
		model.addAttribute("approvalRoot", approvalRoot);
		model.addAttribute("useReceiveDocNo", useReceiveDocNo);
		model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));
		model.addAttribute("useRedraftOpinionKeep", useRedraftOpinionKeep);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("pSusinAdmin", pSusinAdmin);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("useOpenGov", config.getProperty("config.useOpenGov"));
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		model.addAttribute("isPreview", isPreview);
		model.addAttribute("useAprFilePrvw", useAprFilePrvw);

		model.addAttribute("viewDocFlag", viewDocFlag); // 문서보기 Flag
		model.addAttribute("orgCompanyID", orgCompanyID);

		model.addAttribute("junGyulFlag", junGyulFlag);
		
		model.addAttribute("useReceiptDeptFileAttach", useReceiptDeptFileAttach);

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
		
		String allowDeptIDs = ezApprovalGService.getSameDeptBoxUseID(upperDeptCode.equals("") ? userInfo.getDeptID() : upperDeptCode, userInfo.getTenantId());
		model.addAttribute("allowDeptIDs", allowDeptIDs);

		logger.debug("ezRecevGSusinWHWP ended");
		
		return "ezApprovalG/apprGrecevgsusinWHWP";
	}	
	
	@RequestMapping(value = "/ezApprovalG/ezDeptRecevUI_WHWP.do", method = RequestMethod.GET)
	public String ezDeptRecevUI_WHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezDeptRecevUI_WHWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String optIsSplit = ezApprovalGService.getOptionInfo(approvalFlag.equals("S") ? "SA33" : "A33", "001", userInfo, "CODE");

		String docID = request.getParameter("docID");
		String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String draftFlag = request.getParameter("draftFlag");
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String opinionYN = "N";
        String opinionGamsaYN = "N";
        String usePassword = "N";
		String pSusinAdmin = "";
		String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "form" + commonUtil.separator;
		
		String useDirectSign = ezCommonService.getTenantConfig("USE_DirectSign", userInfo.getTenantId());
		String draftDeptID = ezApprovalGService.getOrgDraftDeptID(docID, userInfo.getTenantId(), userInfo.getCompanyID());
		String signImageSize = ezCommonService.getTenantConfig("SignImageSize", userInfo.getTenantId());
		String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());

		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		if (approvalFlag.equals("G")) {
			String nonElecRec = ezApprovalGService.checkNonElecRec(docID, userInfo.getCompanyID(), userInfo.getTenantId());
			if (!nonElecRec.equals("")) {
				model.addAttribute("nonElecRec", nonElecRec);
			}
		}
		
		String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
		
        if (userInfo.getRollInfo().indexOf("a=1") > -1) {
        	pSusinAdmin = "YES";
        } else {
        	pSusinAdmin = "NO";
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
				
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optIsSplit", optIsSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("docID", docID);
		model.addAttribute("hwpToolbar", hwpToolbar);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("pSusinAdmin", pSusinAdmin);
		model.addAttribute("opinionYN", opinionYN);
		model.addAttribute("opinionGamsaYN", opinionGamsaYN);
		model.addAttribute("usePassword", usePassword);
		model.addAttribute("isHWP", "Y");
		model.addAttribute("dirPath", dirPath);
		model.addAttribute("useDirectSign", useDirectSign);
		
		model.addAttribute("draftDeptID", draftDeptID);
		model.addAttribute("useReceiveDocNo", useReceiveDocNo);
		model.addAttribute("docNumZeroCnt", docNumZeroCnt);
		model.addAttribute("signImageSize", signImageSize);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		model.addAttribute("isPreview", isPreview);
		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		model.addAttribute("junGyulFlag", junGyulFlag);

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
		
		logger.debug("ezDeptRecevUI_WHWP ended");
		
		return "ezApprovalG/apprGdeptRecevuiWHWP";
	}
	
	@RequestMapping(value = {"/ezApprovalG/ezSimsaG_WHWP.do", "/ezApprovalG/ezConvSihang_WHWP.do"}, method = RequestMethod.GET)
	public String ezSimsaG_WHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezSimsaG_WHWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
	    String docID = request.getParameter("docID");
	    String docHref = request.getParameter("docHref");
	    String pFormURL = request.getParameter("pFormURL");
	    String orgDocID = request.getParameter("orgDocID");
	    String docTitle = request.getParameter("docTitle");
	    String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
	    String Use_ImgTagTOAttah_body = "N";
	    String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
	    String approvalRoot = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator;
	    String orgCompanyID = request.getParameter("orgCompanyID");
	    String recordID = request.getParameter("recordID") != null ? request.getParameter("recordID") : ""; // 시행문의 반송을 위한 recordID 추가

        boolean isConvSihang = false;
        if (request.getRequestURI().endsWith("ezConvSihang_WHWP.do")) {
            isConvSihang = true;
        }
        
        //회사아이디가 기관코드로 안돼있기때문에 지정해줘야됨
        String companyID = "";
        if (!isConvSihang) {
            //기관코드와 회사 아이디가 다를 경우 보정처리.
            companyID = config.getProperty("config.companyNum");
        } else {
            companyID = orgCompanyID;
        }
        userInfo.setCompanyID(companyID);

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
				
	    model.addAttribute("userInfo", userInfo);
	    model.addAttribute("docID", docID);
	    model.addAttribute("docHref", docHref);
	    model.addAttribute("orgDocID", orgDocID);
	    model.addAttribute("hwpToolbar", hwpToolbar);
	    model.addAttribute("useEditor", useEditor);
	    model.addAttribute("approvalRoot", approvalRoot);
	    model.addAttribute("approvalPWD", approvalPWD);
	    model.addAttribute("Use_ImgTagTOAttah_body", Use_ImgTagTOAttah_body);
	    model.addAttribute("orgCompanyID", orgCompanyID);
	    model.addAttribute("docTitle", docTitle);
	    model.addAttribute("isConvSihang", isConvSihang);
	    model.addAttribute("recordID", recordID);
	    model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
	    model.addAttribute("approvalFlag", ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId()));
	    model.addAttribute("pFormURL", pFormURL);
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		
		logger.debug("ezSimsaG_WHWP ended");
		
		return "ezApprovalG/apprGezSimsagWHWP";
	}	
	
	@RequestMapping(value = "/ezApprovalG/downloadAttachForHwp.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadAttach(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttachForHwp started");
		
		String filePath = request.getParameter("filePath");
		
		downImage(filePath, request, response);
		
		logger.debug("downloadAttachForHwp ended");
	}
	
	@RequestMapping(value = "/ezApprovalG/uploadAttachForHwp.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadAttachForHwp(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("uploadAttachForHwp started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		MultipartFile multiFile = request.getFile("fileToUpload"); 
		String companyID = request.getParameter("companyID") != null ? request.getParameter("companyID") : userInfo.getCompanyID();
		
		String realPath = request.getServletContext().getRealPath("");
		String pFileName = "";
        String sGUID = "";
        String pUploadSN = "";
        
        sGUID = UUID.randomUUID().toString();
        pUploadSN = "{" + sGUID + "}";
        
        if (StringUtils.isNotEmpty(multiFile.getOriginalFilename()) && StringUtils.isNotBlank(multiFile.getOriginalFilename())) {   
        	String _pFileName = multiFile.getOriginalFilename();
            if (_pFileName.indexOf(commonUtil.separator) > 0) {
                _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
            }
            pFileName = _pFileName;
        }
        
        pFileName = pFileName.replace("%2b", "+");
        pFileName = pFileName.replace("%3b", ";");
        
        String pDirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
        pDirPath = realPath + pDirPath + commonUtil.separator + companyID + commonUtil.separator;
        logger.debug("pDirPath : " + pDirPath);
        
        File tempFile = new File(pDirPath + "tempUploadFile");
        
        if (!tempFile.exists()) {
        	tempFile.mkdirs();
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
        String newFileName = pUploadSN;
        
        writeUploadedFile(multiFile, newFileName + pFileName, pDirPath + "tempUploadFile");            		
        	
		strXML.append("<DATA1><![CDATA[" + pFileName + "]]></DATA1>");
		strXML.append("<DATA2><![CDATA[" + newFileName + pFileName + "]]></DATA2>");
		strXML.append("<DATA3><![CDATA[OK]]></DATA3>");
        
        strXML.append("</NODES></ROOT>");
        
		logger.debug("uploadAttachForHwp ended");
		return strXML.toString();
	}
	
	@RequestMapping(value = "/ezApprovalG/tempUploadFileDelete.do", method = RequestMethod.POST)
	public String tempUploadFileDelete(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("tempUploadFileDelete started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String fileName = request.getParameter("fileName");
		String companyID = request.getParameter("companyID") != null ? request.getParameter("companyID") : userInfo.getCompanyID();
		
		String pDirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + companyID + commonUtil.separator + "tempUploadFile";
		
		logger.debug("filePath : " + (pDirPath + commonUtil.separator + fileName));
		
		File file = new File(pDirPath + commonUtil.separator + fileName);
		file.delete();

		logger.debug("tempUploadFileDelete ended");
        
        return "json";
	}
	
	/**
	 * 전자결재G 한글 웹 기안기 양식작성기 화면 호출
	 */
	@RequestMapping(value="/ezApprovalG/WHWPEditor.do", method = RequestMethod.GET)
	public String WHWPEditor(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("WHWPEditor started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String type = request.getParameter("type");
		
		model.addAttribute("webHWPUrl", ezCommonService.getTenantConfig("webHWPUrl", userInfo.getTenantId()));
		model.addAttribute("type", type);
		
		logger.debug("WHWPEditor ended.");
		return "ezApprovalG/apprGWHWPEditor";
	}
	
	/**
	 * 전자결재G 한글 웹 기안기 관련 파일 호출
	 */
	@RequestMapping(value="/ezApprovalG/hwpctrlmain.do", method = RequestMethod.GET)
	public String hwpctrlmain(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("hwpctrlmain started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("webHWPUrl", ezCommonService.getTenantConfig("webHWPUrl", userInfo.getTenantId()));
		
		logger.debug("hwpctrlmain ended.");
		return "ezApprovalG/hwpctrlmain";
	}
	
	/* 2022-01-11 홍승비 - 전자결재G 웹한글기안기 일괄기안 기능 추가 */
	/**
	 * 전자결재 웹한글기안기 일괄기안 페이지 호출
	 */
	@RequestMapping(value = "/ezApprovalG/draftuiAll_WHWP.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String draftuiAll_WHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("draftuiAll_WHWP started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String susinAdmin = "";
		String formURL = request.getParameter("formURL") != null ? request.getParameter("formURL") : ""; // 필수는 아니다. 
		String draftFlag = request.getParameter("draftFlag") != null ? request.getParameter("draftFlag") : "DRAFT"; // 임시저장이나 재기안이 아닌 경우, draftFlag를 기안으로 고정
		String formDocType = request.getParameter("formDocType") != null ? request.getParameter("formDocType") : "";
		String susinSN = request.getParameter("susinSN") != null ? request.getParameter("susinSN") : "";
		String docState = request.getParameter("docState") != null ? request.getParameter("docState") : "";
		String listType = request.getParameter("listType") != null ? request.getParameter("listType") : "";
		String aprState = request.getParameter("aprState") != null ? request.getParameter("aprState") : "";
		String isTmpDoc = request.getParameter("isTmpDoc") != null ? request.getParameter("isTmpDoc") : ""; // 반송문서 재기안 시 docID, 임시보관문서 재기안 시 docSN이 전달됨
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		String nonElecRec = ""; // 일괄기안 기능은 비전자기록물 등록을 지원하지 않음
		String docSN = "";
		
		if (listType.equals("21")) {
			if (request.getParameter("docSN") != null) {
				docSN = request.getParameter("docSN");
			}
		}
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) { // 수발신담당자
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
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
		/* 2020-03-31 홍승비 - 재기안 시 반송의견 유지여부 컨피그 추가 */
		String useRedraftOpinionKeep = ezCommonService.getTenantConfig("useRedraftOpinionKeep", userInfo.getTenantId());
		
		/* 2020-11-13 홍승비 - 대용량첨부 관련 파라미터 추가 */
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
		String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String bigAttachDownloadPeriod = EgovDateUtil.getToday("/") + " ~ " + EgovDateUtil.addDay(EgovDateUtil.getToday("/"), Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");
		
		String preSusinGroupStr = ezApprovalGService.getCode2Name("A53", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		// 일괄기안 가능 양식 리스트
		List<ApprGFormVO> apprGFormVOList = ezApprovalGService.getDraftAllFormInfo(userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId());
		String groupDocSN = ""; // 임시저장 또는 재기안된 문서의 일괄기안그룹 DOCID
		List<ApprGGroupDocInfoVO> groupDocInfoList = new ArrayList<ApprGGroupDocInfoVO>();
		
		/* 2022-01-21 홍승비 - 일괄기안된 문서의 재기안인 경우, request 데이터를 그대로 가져가 일괄기안창으로 포워드 */
		if (draftFlag != null && draftFlag.equals("REDRAFT")) {
			
			if (listType.equals("21")) { // 임시보관함
				// 임시저장된 문서의 경우, docSN에 해당 문서의 임시저장용 DOCID가 들어있다. (사용자ID@순번 형태)
				// 웹한글기안기의 비동기 동작으로 1안이 늦게 저장되어 GROUPDOCSN값이 다를 수 있다. 따라서 정상적인 GROUPDOCSN값을 다시 가져오도록 한다.
				groupDocSN = ezApprovalGService.getGroupDocSN(docSN, userInfo.getTenantId(), userInfo.getCompanyID());
				groupDocInfoList = ezApprovalGService.getGroupDocList(groupDocSN, "TMP", userInfo.getTenantId(), userInfo.getCompanyID());
			}
			else { // 반송문서 재기안 (isTmpDoc = docID)
				groupDocSN = ezApprovalGService.getGroupDocSN(isTmpDoc, userInfo.getTenantId(), userInfo.getCompanyID());
				groupDocInfoList = ezApprovalGService.getGroupDocList(groupDocSN, "APR", userInfo.getTenantId(), userInfo.getCompanyID());
			}
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
				
		model.addAttribute("approvalFlag", approvalFlag);
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
		model.addAttribute("docSN", docSN);
		model.addAttribute("isHWP", "Y");
		model.addAttribute("nonElecRec", nonElecRec);
		model.addAttribute("useReceiveDocNo", useReceiveDocNo);
		model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));
		model.addAttribute("useOpenGov", config.getProperty("config.useOpenGov"));
		model.addAttribute("useRedraftOpinionKeep", useRedraftOpinionKeep);
		//결재 세부정보
		String formId = ezApprovalGService.getFormId(formURL);
		String formAprOption = ezApprovalGService.getFormAprOptionInfo(formId, "FORM", userInfo.getCompanyID(), userInfo.getTenantId());
		model.addAttribute("formAprOption", formAprOption);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		// 비전자문서의 기안 시 파라미터 오류 방지
		model.addAttribute("preSusinGroupStr", preSusinGroupStr);
		
		// 일괄기안 관련 데이터
		model.addAttribute("apprGFormVOList", apprGFormVOList);
		model.addAttribute("groupDocInfoList", groupDocInfoList); // 임시저장 또는 반송된 문서 리스트 데이터 
		model.addAttribute("groupDocSN", groupDocSN); // 임시저장 또는 반송된 문서의 일괄기안그룹 DOCID (GROOUPDOCSN)
		
		model.addAttribute("isPreview", isPreview); // 미리보기 영역 관련 
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
		
		logger.debug("draftuiAll_WHWP ended");
		
		return "ezApprovalG/apprGdraftuiAll_WHWP";
	}
	
	/**
	 * 전자결재G 한글 웹 기안기 일괄기안 전용 양식화면 호출
	 */
	@RequestMapping(value="/ezApprovalG/draftContentAll_WHWP.do", method = RequestMethod.GET)
	public String draftContentAll_WHWP(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("draftContentAll_WHWP started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String type = request.getParameter("type") != null ? request.getParameter("type") : "";
		String frameNum = request.getParameter("frameNum") != null ? request.getParameter("frameNum") : "";
		String docID = request.getParameter("docID") != null ? request.getParameter("docID") : "";
		String docHref = request.getParameter("docHref") != null ? request.getParameter("docHref") : "";
		String formID = request.getParameter("formID") != null ? request.getParameter("formID") : "";
		String webHWPUrl = ezCommonService.getTenantConfig("webHWPUrl", userInfo.getTenantId());
		String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String draftJunGyulFlag = ezCommonService.getTenantConfig("draftJunGyulFlag", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String optisSplit = ezApprovalGService.getOptionInfo(approvalFlag.equals("S") ? "SA33" : "A33", "001", userInfo, "CODE");

		// 2023-05-26 조수빈 - 전자결재 첨부파일 미리보기 기능 사용 여부
		String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		
		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
			useAprFilePrvw = "1";
		} else {
			useAprFilePrvw = "0";
		}
				
		model.addAttribute("type", type);
		model.addAttribute("formID", formID); // 사실상 iframe 내부에서 GetAprDocFormID()를 호출하여 가져오므로, 필요없는 파라미터임
		model.addAttribute("frameNum", frameNum);
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("webHWPUrl", webHWPUrl);
		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		model.addAttribute("junGyulFlag", junGyulFlag);
		model.addAttribute("draftJunGyulFlag", draftJunGyulFlag);
		model.addAttribute("optisSplit", optisSplit);

		logger.debug("draftContentAll_WHWP ended.");
		return "ezApprovalG/apprGdraftuiAllContent_WHWP";
	}
	
	
	/**
	 * 일괄기안 안추가시 파일첨부, 문서첨부, 의견, 분리첨부 복제
	 */
	@RequestMapping(value = "/ezApprovalG/copyDocAttachHwp.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public void copyDocAttachHwp(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, ApprGAttachOptionVO apprGAttachOptionVO) throws Exception {
		logger.debug("copyDocAttachHwp started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String oldYear = ezApprovalGService.getDocHrefYear(apprGAttachOptionVO.getCurrentDocID(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		dirPath += userInfo.getCompanyID() + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(apprGAttachOptionVO.getCurrentDocID()) + commonUtil.separator;
		
		apprGAttachOptionVO.setTenantID(userInfo.getTenantId());
		apprGAttachOptionVO.setCompanyID(userInfo.getCompanyID());
		apprGAttachOptionVO.setDirPath(dirPath);
		
		ezApprovalGService.copyDocAttach(apprGAttachOptionVO, realPath);

		logger.debug("copyDocAttachHwp ended");
	}
	
	/**
	 * 일괄기안 안추가시 결재선 복제
	 */
	@RequestMapping(value = "/ezApprovalG/copyAprLine.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public void copyAprLine(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, ApprGAttachOptionVO apprGAttachOptionVO) throws Exception {
		logger.debug("copyAprLine started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		apprGAttachOptionVO.setTenantID(userInfo.getTenantId());
		apprGAttachOptionVO.setCompanyID(userInfo.getCompanyID());
		
		//logger.debug("userID : " + userInfo.getId() + " / userName : " + userInfo.getDisplayName() + " / mainDocID : " + apprGAttachOptionVO.getMainDocID() + " / currentDocID : " + apprGAttachOptionVO.getCurrentDocID());
		
		ezApprovalGService.copyAprLine(apprGAttachOptionVO);
		
		logger.debug("copyAprLine ended");
	}
	
	/**
	 * 전자결재G 웹한글기안기 일괄기안 결재할문서 페이지 호출
	 */
	@RequestMapping(value = "/ezApprovalG/approvuiAll_WHWP.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String approvuiAll_WHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("approvuiAll_WHWP started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String susinAdmin = "";
		String orgAprUserID = request.getParameter("id");
		String orgAprUserName = request.getParameter("name");
		String orgAprUserDeptID = request.getParameter("deptID");
		String docID = request.getParameter("docID") != null ? request.getParameter("docID") : "";
		String tempUserID = userInfo.getId();
		String orgDocID = request.getParameter("orgDocID") != null ? request.getParameter("orgDocID") : "";
		String useOpenGov = config.getProperty("config.useOpenGov");
		String allFlag = request.getParameter("allFlag");
		//hwp 툴바가 6줄인데 맨윗줄 부터 '1' 이면 사용 '0' 이면 사용하지 않는다. ex)'100001' 맨위랑 맨아래 툴바만 표시
        String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
        String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String useReceiveDocNo = ezCommonService.getTenantConfig("useReceiveDocNo", userInfo.getTenantId());
		String docState = request.getParameter("docState");
		String mailChk = request.getParameter("mailchk") != null ? request.getParameter("mailchk") : ""; // 메일에서 전저결재 열람 여부('Y'일때는 메일 그 외에는 전자결재)
		String mode = request.getParameter("mode");
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		String docDir = docID.substring(docID.length() - 3);
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) { // 수발신담당자
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		if (docDir.substring(0, 1).equals("0")) {
        	docDir = docDir.substring(docDir.length() - 2, 2);
        } else if (docDir.substring(0, 2).equals("00")) {
        	docDir = docDir.substring(docDir.length() - 1, 1);
        } else if (docDir.equals("000")) {
        	docDir = "0";
        }
		
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
        String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + docDir + "." + docID + ".hwp" ;

        // 일괄기안된 문서는 모두결재(연속결재)를 지원하지 않으므로, allFlag는 항상 0으로 고정된다.
        if (!allFlag.equals("1") && !allFlag.equals("2")) {
        	allFlag = "0";
        }
        
        // 일괄기안된 문서는 각 안 별 결재선이 전부 동일하므로, 대표로 1안에 대해서만 접근권한을 확인한다.
        if (!docID.equals("")) {
        	String proxyUser = ezApprovalGService.getProxyUser2(userInfo.getId(), "1", userInfo.getTenantId(), userInfo.getOffset());
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
			
			if (checkPermission) {
				Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), "APR", userInfo.getCompanyID(), userInfo.getTenantId(), docState);
				
				if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
					if (mailChk != null && mailChk.equals("Y")) {
						model.addAttribute("chk", "no");
						
						// 진행문서인 경우
						ApprGDocListVO apprGIngDocVO = ezApprovalGService.getIngDocInfo(userInfo.getId(), docID.trim(), orgCompanyID, userInfo.getTenantId());
						if (apprGIngDocVO != null && apprGIngDocVO.getHref() != null && !apprGIngDocVO.getHref().trim().equals("")) {
							model.addAttribute("docID", docID.trim());
							model.addAttribute("docHref", apprGIngDocVO.getHref().trim());
							model.addAttribute("orgCompanyID", orgCompanyID); // 결재문서 기안 당시의 회사ID
							model.addAttribute("listType", "3"); // 진행중문서 listType
							model.addAttribute("docState", apprGIngDocVO.getDocState());
							
							return "redirect:/ezApprovalG/ezviewAprAll_WHWP.do";
						} else {
							// 완료문서인 경우 (1안 기준으로 단일 완료문서 보기창 표출)
							ApprGDocListVO apprGEndDocVO = ezApprovalGService.getEndDocInfo(docID.trim(), orgCompanyID, userInfo.getTenantId());
							if (apprGEndDocVO != null && apprGEndDocVO.getHref() != null && !apprGEndDocVO.getHref().trim().equals("")) {
								model.addAttribute("docID", docID.trim());
								model.addAttribute("docHref", apprGEndDocVO.getHref().trim());
								model.addAttribute("orgCompanyID", orgCompanyID); // 결재문서 기안 당시의 회사ID(문서 재사용에 필요)
								model.addAttribute("formID", apprGEndDocVO.getFormID());
								model.addAttribute("docState", apprGEndDocVO.getDocState());
								
								return "redirect:/ezApprovalG/ezViewEnd_WHWP.do";
							} else {
								return "main/warning";
							}
						}
					}
					return "main/warning";
				}
			}
		}
		
        String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
        String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
        String optisSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
        String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
        String optjunKyukInfo = ezApprovalGService.getOptionInfo("A32", "001", userInfo, "CODE");
        String docNumZeroCnt = ezApprovalGService.getDocNumZeroCnt(userInfo.getCompanyID(), userInfo.getTenantId());
        
        String nonElecRec = ezApprovalGService.checkNonElecRec(orgDocID, userInfo.getCompanyID(), userInfo.getTenantId());
        if (!nonElecRec.equals("")) {
        	model.addAttribute("nonElecRec", nonElecRec);
        }
        
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
		
		// 1안의 docID를 GroupDocSN으로 전달한다.
		List<ApprGGroupDocInfoVO> groupDocInfoList = new ArrayList<ApprGGroupDocInfoVO>();
		groupDocInfoList = ezApprovalGService.getGroupDocList(docID, "APR", userInfo.getTenantId(), userInfo.getCompanyID());
		
		// 2023-05-26 조수빈 - 전자결재 첨부파일 미리보기 기능 사용 여부
		String useAprFilePrvw = ezCommonService.getTenantConfig("useAprFilePrvw", userInfo.getTenantId());
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		
		if (useAprFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
			useAprFilePrvw = "1";
		} else {
			useAprFilePrvw = "0";
		}
				
		model.addAttribute("approvalFlag", approvalFlag);
        model.addAttribute("approvalPWD", approvalPWD);
        model.addAttribute("useEditor", useEditor);
		model.addAttribute("orgAprUserID", orgAprUserID);
		model.addAttribute("orgAprUserName", orgAprUserName);
		model.addAttribute("orgAprUserDeptID", orgAprUserDeptID);
		model.addAttribute("docID", docID);
        model.addAttribute("tempUserID", tempUserID);
        model.addAttribute("optSignDateFormat", optSignDateFormat);
        model.addAttribute("optisSplit", optisSplit);
        model.addAttribute("optSplitKind", optSplitKind);
        model.addAttribute("optjunKyukInfo", optjunKyukInfo);
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("allFlag", allFlag);
        model.addAttribute("oldYear", oldYear);
        model.addAttribute("dirPath", dirPath);
        model.addAttribute("hwpToolbar", hwpToolbar);
        model.addAttribute("susinAdmin", susinAdmin);
        model.addAttribute("docState", docState);
        model.addAttribute("isHWP", "Y");
        model.addAttribute("useReceiveDocNo", useReceiveDocNo);
        model.addAttribute("orgCompanyID", orgCompanyID);
        model.addAttribute("docNumZeroCnt", Integer.parseInt(docNumZeroCnt));
		
		// 원문정보공개 관련
		if (useOpenGov.equalsIgnoreCase("YES") && approvalFlag.equalsIgnoreCase("G")) {
			Map<String, Object> openGovMap = ezApprovalGService.getOpenGovInfo(docID, userInfo.getTenantId(), userInfo.getCompanyID());

			model.addAttribute("basis", openGovMap.get("basis"));
			model.addAttribute("reason", openGovMap.get("reason"));
			model.addAttribute("listOpenFlag", openGovMap.get("listOpenFlag"));
			model.addAttribute("fileOpenFlagList", openGovMap.get("fileOpenFlagList"));
		}
		model.addAttribute("useOpenGov", useOpenGov);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		
		//결재 세부정보
		String formAprOption = ezApprovalGService.getFormAprOptionInfo(docID, "DOC", userInfo.getCompanyID(), userInfo.getTenantId());
		model.addAttribute("formAprOption", formAprOption);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		// 비전자문서의 기안 시 파라미터 오류 방지
		model.addAttribute("preSusinGroupStr", preSusinGroupStr);
		
		// 일괄기안 관련 데이터
		model.addAttribute("groupDocInfoList", groupDocInfoList); // 문서 리스트 데이터 
		model.addAttribute("groupDocInfoListCnt", groupDocInfoList.size()); // 문서 리스트 데이터 카운트 (안의 갯수)
		model.addAttribute("groupDocSN", docID); // 일괄기안그룹 DOCID (GROOUPDOCSN)
		
		model.addAttribute("isPreview", isPreview);

		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		model.addAttribute("loadTimeForApprAll", ezCommonService.getTenantConfig("loadTimeForApprAll", userInfo.getTenantId()));
		
		logger.debug("approvuiAll_WHWP ended");
		
		return "ezApprovalG/apprGapprovuiAll_WHWP";
	}
	
	/**
	 * 전자결재G 웹한글기안기 일괄기안 결재할문서 양식부분 호출
	 */
	@RequestMapping(value="/ezApprovalG/approvContentAll_WHWP.do", method = RequestMethod.GET)
	public String approvContentAll_WHWP(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("approvContentAll_WHWP started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String type = request.getParameter("type") != null ? request.getParameter("type") : "";
		String frameNum = request.getParameter("frameNum") != null ? request.getParameter("frameNum") : "";
		String docID = request.getParameter("docID") != null ? request.getParameter("docID") : "";
		String docHref = request.getParameter("docHref") != null ? request.getParameter("docHref") : "";
		String webHWPUrl = ezCommonService.getTenantConfig("webHWPUrl", userInfo.getTenantId());
		
		model.addAttribute("type", type);
		model.addAttribute("frameNum", frameNum);
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("webHWPUrl", webHWPUrl);
		model.addAttribute("isHWP", "Y");
		
		logger.debug("approvContentAll_WHWP ended.");
		return "ezApprovalG/apprGapprovuiAllContent_WHWP";
	}

	/**
	 * 전자결재G 웹한글기안기 일괄기안 기안한문서, 결재진행문서 문서보기 전용창 페이지 호출
	 */	
	@RequestMapping(value = "/ezApprovalG/ezviewAprAll_WHWP.do", method = RequestMethod.GET)
	public String ezviewAprAll_WHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezviewAprAll_WHWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String susinAdmin = "";
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String opinionFlag = request.getParameter("opinionFlag");
		String docState = request.getParameter("docState");
		String listSusin = request.getParameter("listSusin");
		String orgDocID = request.getParameter("oDoc");
		String showOpinion = request.getParameter("isOpinion");
		String listTypeValue = request.getParameter("listType");
		String hasOpinionYN = "";
		String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String orgCompanyID = request.getParameter("orgCompanyID");
		String isPreview = request.getParameter("isPreview") != null ? request.getParameter("isPreview") : ""; // 미리보기 영역에서 열렸는지 여부 플래그
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyID())) {
			userInfo.setCompanyID(orgCompanyID);
		}

		if (userInfo.getRollInfo().indexOf("a=1") > -1 ) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}

		// 1안의 정보를 기준으로 의견존재 여부 플래그를 전달
		String strXML = ezApprovalGService.getDocInfo(docID, "APR", "HasOpinionYN", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
		Document resultXML = commonUtil.convertStringToDocument(strXML);
		
		if (resultXML.getElementsByTagName("HASOPINIONYN").getLength() > 0) {
			if (resultXML.getElementsByTagName("HASOPINIONYN").item(0) != null && !resultXML.getElementsByTagName("HASOPINIONYN").item(0).getTextContent().trim().equals("")) {
				hasOpinionYN = resultXML.getDocumentElement().getTextContent();
			}
		}
		
		/* 해당 부분은 부서수신함에서의 문서보기 관련이므로, 일괄기안용 결재진행문서 보기창에서는 지원하지 않는 부분임. 코드 주석처리함 */
		// 일괄기안용 결재진행문서 보기창은 일괄기안된 문서인 경우에만 동작함 (결재진행문서, 기안한문서에서만 접근 가능)
		//2018-08-29 천성준 - 부서수신함에 들어온 접수문서를 최초 접수창으로 열지않고 문서보기로 열었을경우 문서파일이 생성되지 않아서 에러터지는것 수정 
		/*
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
			File file = new File(commonUtil.detectPathTraversal(dir));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			File newFile = new File(commonUtil.detectPathTraversal(docFile));
			
			if (!newFile.exists()) {
				File orgFile = new File(commonUtil.detectPathTraversal(orgDocFile));
				
				// KLIB 복호화
				if (orgDocFile.endsWith("." + EzApprovalGKlibServiceImpl.ENCRYPTED_FILE_EXT)) {
					byte[] orgBytes = commonUtil.readBytesFromFile(orgFile.toPath());
					FileUtils.writeByteArrayToFile(newFile, klibUtil.decrypt(orgBytes));
				} else {
					FileUtils.copyFile(orgFile, newFile);
				}
			}
		}
		*/
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		String forceCallBackYN = ezCommonService.getTenantConfig("forceCallBack_YN", userInfo.getTenantId()); // 강제회수 옵션
		
		/* 2020-11-13 홍승비 - 대용량첨부 관련 파라미터 추가 */
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
		String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
		String bigAttachFileMinSaveDate = ezApprovalGService.getAttachFileMinSaveDate(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String bigAttachDownloadPeriod = bigAttachFileMinSaveDate + " ~ " + EgovDateUtil.addDay(bigAttachFileMinSaveDate, Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");
		
		// 1안의 docID를 GroupDocSN으로 전달한다. 임시저장된 문서도 문서보기가 가능하므로, listType을 체크한다.
		List<ApprGGroupDocInfoVO> groupDocInfoList = new ArrayList<ApprGGroupDocInfoVO>();
		String groupDocSN = "";
		
		if (listTypeValue.equals("21")) { // docID = 임시저장된 docSN (사용자ID@순번 형태)
			// 웹한글기안기의 비동기 동작으로 1안이 늦게 저장되어 GROUPDOCSN값이 다를 수 있다. 따라서 정상적인 GROUPDOCSN값을 다시 가져오도록 한다.
			groupDocSN = ezApprovalGService.getGroupDocSN(docID, userInfo.getTenantId(), userInfo.getCompanyID());
			groupDocInfoList = ezApprovalGService.getGroupDocList(groupDocSN, "TMP", userInfo.getTenantId(), userInfo.getCompanyID());
		} else {
			groupDocInfoList = ezApprovalGService.getGroupDocList(docID, "APR", userInfo.getTenantId(), userInfo.getCompanyID());
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
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("forceCallBackYN", forceCallBackYN);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		// 대용량첨부 관련 정보
		model.addAttribute("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
		model.addAttribute("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
		model.addAttribute("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
		
		// 일괄기안 관련 데이터
		model.addAttribute("groupDocInfoList", groupDocInfoList); // 문서 리스트 데이터 
		model.addAttribute("groupDocInfoListCnt", groupDocInfoList.size()); // 문서 리스트 데이터 카운트 (안의 갯수)
		model.addAttribute("groupDocSN", docID); // 일괄기안그룹 DOCID (GROOUPDOCSN)
		
		model.addAttribute("isPreview", isPreview);

		model.addAttribute("useAprFilePrvw", useAprFilePrvw);
		model.addAttribute("loadTimeForApprAll", ezCommonService.getTenantConfig("loadTimeForApprAll", userInfo.getTenantId()));
		
		logger.debug("ezviewAprAll_WHWP ended");
		
		return "ezApprovalG/apprGviewAprAll_WHWP";
	}
	
	/**
	 * 전자결재G 웹한글기안기 일괄기안 기안한문서, 결재진행문서 문서보기 전용창 양식부분 호출
	 */
	@RequestMapping(value="/ezApprovalG/apprViewContentAll_WHWP.do", method = RequestMethod.GET)
	public String apprViewContentAll_WHWP(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("apprViewContentAll_WHWP started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String type = request.getParameter("type") != null ? request.getParameter("type") : "";
		String frameNum = request.getParameter("frameNum") != null ? request.getParameter("frameNum") : "";
		String docID = request.getParameter("docID") != null ? request.getParameter("docID") : "";
		String docHref = request.getParameter("docHref") != null ? request.getParameter("docHref") : "";
		String webHWPUrl = ezCommonService.getTenantConfig("webHWPUrl", userInfo.getTenantId());
		
		model.addAttribute("type", type);
		model.addAttribute("frameNum", frameNum);
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("webHWPUrl", webHWPUrl);
		
		logger.debug("apprViewContentAll_WHWP ended.");
		return "ezApprovalG/apprGviewAprAllContent_WHWP";
	}
////////////////////// 일괄기안 코드 끝 ///////////////////////
	
	/**
	 * 2023-02-08 홍승비 - 전자결재 WHWP > 변경내역(문서변경정보) > 결재문서이력 상세보기 (수정사항 비교가능)
	 */	
	@RequestMapping(value = "/ezApprovalG/docViewerWHWPCompare.do", method = RequestMethod.GET)
	public String docViewerCompare(HttpServletRequest request, Model model) throws Exception {
		logger.debug("docViewerWHWPCompare started");

		String pDocHrefAfter = request.getParameter("docHrefAfter");
		String pDocHrefBefore = request.getParameter("docHrefBefore");
		
		model.addAttribute("docHrefAfter", commonUtil.cleanValue(pDocHrefAfter));
		model.addAttribute("docHrefBefore", commonUtil.cleanValue(pDocHrefBefore));
		
		logger.debug("docViewerCompare ended");
		return "ezApprovalG/apprGdocViewerWHWPCompare";
	}
	
}
