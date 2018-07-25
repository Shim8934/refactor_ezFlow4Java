package egovframework.ezEKP.ezApprovalG.web;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.binary.Base64;
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
import org.w3c.dom.Document;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.service.impl.EzApprovalGKlibServiceImpl;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.KlibUtil;

@Controller
public class EzApprovalGHwpController extends EgovFileMngUtil{
	private static final Logger LOGGER = LoggerFactory.getLogger(EzApprovalGHwpController.class);
	
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
	
	/**
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 * 전자결재 한글기안기 오픈
	 */
	@RequestMapping(value = "/ezApprovalG/draftuiHWP.do", produces = "text/xml;charset=utf-8")
	public String draftuiHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("draftuiHWP started");
		
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
		String docSN = "";
		
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
		
		LOGGER.debug("draftuiHWP ended");
		
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
	@RequestMapping(value = "/ezApprovalG/approvuiHWP.do")
	public String approvuiHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("approvuiHWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String susinAdmin = "";
		String orgAprUserID = request.getParameter("id");
		String orgAprUserName = request.getParameter("name");
		String orgAprUserDeptID = request.getParameter("deptID");
		String docID = request.getParameter("docID");
		String tempUserID = userInfo.getId();

		String allFlag = request.getParameter("allFlag");
		//hwp 툴바가 6줄인데 맨윗줄 부터 '1' 이면 사용 '0' 이면 사용하지 않는다. ex)'100001' 맨위랑 맨아래 툴바만 표시
        String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
        String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String docState = request.getParameter("docState");

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

        String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
        String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
        String optisSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
        String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
        String optjunKyukInfo = ezApprovalGService.getOptionInfo("A32", "001", userInfo, "CODE");
             
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
        
		LOGGER.debug("approvuiHWP ended");
		
		return "/ezApprovalG/apprGapprovuiHWP";
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
		String orgDocID = request.getParameter("oDoc");
		String showOpinion = request.getParameter("isOpinion");
		String listTypeValue = request.getParameter("listType");
		String hasOpinionYN = "";
		String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

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
		model.addAttribute("approvalFlag", approvalFlag);
		
		LOGGER.debug("ezviewAprHWP ended");
		
		return "ezApprovalG/apprGviewAprHWP";
	}
	
	/**
	 * 한글기안기 결재문서 메일발송 시 첨부파일로 떨구기
	 */	
	@RequestMapping(value = "/ezApprovalG/mail_interuploadX_Server.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mail_interuploadX_Server(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception {
		LOGGER.debug("mail_interuploadX_Server started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String sGUID = xmlDom.getElementsByTagName("guid").item(0).getTextContent();
		String sFileTitle = xmlDom.getElementsByTagName("name").item(0).getTextContent();
		String sFileData = xmlDom.getElementsByTagName("filedata").item(0).getTextContent();
		String sExt = xmlDom.getElementsByTagName("ext").item(0).getTextContent();
		String sFolder = xmlDom.getElementsByTagName("dir").item(0).getTextContent();
		String sPrefix = xmlDom.getElementsByTagName("prefix").item(0).getTextContent();
		
		String pBigFileUpload = sFileData;
		String filename = sFileTitle;
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
               // 대용량 첨부파일인 경우에는 오늘 날짜를 이름으로 갖는 폴더를 사용한다.
               pDate = EgovDateUtil.getToday("");
               pDirTempPath = pDirPath + commonUtil.separator + pDate;
               copyPath = copyPath + commonUtil.separator + pDate;
           } else {
               // 일반 첨부파일인 경우에는 tempFileUpload 폴더를 사용한다.
               pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload";
               copyPath = copyPath + commonUtil.separator + "tempFileUpload";
           }

	          File f = new File(pDirTempPath);
	          
	            // 파일을 업로드할 폴더가 존재하지 않으면 생성한다.            
	            if (!f.exists()) {
	                f.mkdirs();
	            }

	       String saveLocalPath = pDirTempPath + commonUtil.separator + newfilename;
           String orgFileName = sFileTitle + "." + sExt;            
           long fileSize = 0;
	       if (useExtension.toLowerCase().indexOf(sExt.toLowerCase()) == -1 && !useExtension.equals("*")) {
               extResult = "denied";
           } else {
        	// 대용량 첨부파일의 경우에는 후에 다운로드 받을 때 파일명을 내려보내기 위해 원 파일명을 저장한다.                
               if (pBigFileUpload.equals("Y")) {                    
                   String base64OrgFileName = Base64.encodeBase64String(orgFileName.getBytes("UTF-8"));
                   FileOutputStream fos = null;
                   
                   try {
                       File nameFile = new File(saveLocalPath + "__.txt");
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
               
       		File file2 = new File(pDirTempPath + commonUtil.separator + newfilename);
       		File file3 = new File(realPath +  commonUtil.separator + sFileHref );
       		
			if (!file2.exists()) {
				FileUtils.copyFile(file3, file2);
			}
                                           
               extResult = "OK";
           }

         LOGGER.debug("mail_interuploadX_Server ended");
         if (pBigFileUpload == "Y") {
        	 return pDate + "|!|" + copyPath + commonUtil.separator + newfilename + "_kaonisplit_" + pBigFileUpload + "_" + extResult;
         } else {
        	 return copyPath + commonUtil.separator + newfilename + "_kaonisplit_" + pBigFileUpload + "_" + extResult;
         }
	}
	
	/**
	 * 전자결재 한글양식 정보 버튼 
	 */	
	@RequestMapping(value = "/ezApprovalG/ezDocInfoG_View.do")
	public String ezDocInfoG_View(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("ezDocInfoG_View started");

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
			limitRange = xmlDom.getElementsByTagName("LIMITRANGE").item(0).getTextContent();
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
        
		LOGGER.debug("ezDocInfoG_View ended");
		
		return "ezApprovalG/apprGezDocInfoGView";
	}
	
	/**
	 * 전자결재 한글양식 결재완료 문서 보기
	 */	
	@RequestMapping(value = "/ezApprovalG/ezViewEnd_HWP.do")
	public String ezViewEnd_HWP(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("ezViewEnd_HWP started");

		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String listSusin = request.getParameter("listSusin");
		String orgDocID = request.getParameter("orgDocID");
		String formID = request.getParameter("formID");
		String endDir = "";
		String docTitle = request.getParameter("title");
		String susinAdmin = "";
        String SignCheck = "N";
        String pass = "";
        
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
		
		if (!userInfo.getRollInfo().contains("c=1") && !userInfo.getRollInfo().contains("k=1") && !userInfo.getRollInfo().contains("f=1")) {
			pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId(), approvalFlag);
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

            String rtnXML = ezApprovalGService.getDocInfo(docID, "END", "SignCheck", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");

    		Document xmlDom2 = commonUtil.convertStringToDocument(rtnXML);

            if (xmlDom2.getElementsByTagName("SIGNCHECK").getLength() > 0) {
            	SignCheck = xmlDom2.getElementsByTagName("SIGNCHECK").item(0).getTextContent().trim();
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
		model.addAttribute("SignCheck", SignCheck);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("hwpToolbar", hwpToolbar);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("pass", pass);
		
		LOGGER.debug("ezViewEnd_HWP ended");
		return "ezApprovalG/apprGviewEndHWP";
	}
	
	
	
	@RequestMapping(value = "/ezApprovalG/ezRecevGSusinHWP.do")
	public String ezRecevGSusinHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("ezRecevGSusinHWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optIsSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");

		String sihangURL = ezApprovalGService.getOptionInfo("A36", "004", userInfo, "CODE");
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

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

                
		Document xmlDom = commonUtil.convertStringToDocument(rtnVal);
		
		if (xmlDom.getElementsByTagName("ORGHREF").getLength() > 0) {
			String orgDocFile = xmlDom.getElementsByTagName("ORGHREF").item(0).getTextContent();
			String docFile = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();
			
			orgDocFile = dirPath + orgDocFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			docFile = dirPath + docFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			
			String dir = docFile.substring(0, docFile.lastIndexOf(commonUtil.separator) + 1);
			File file = new File(dir);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			File newFile = new File(docFile);
			
			if (!newFile.exists()) {
				File orgFile = new File(orgDocFile);
				InputStream orgFileInputStream;

				// 2018.06.21 - KLIB으로 암호화된 파일일 때는 복호화 하여 저장
				if (orgDocFile.endsWith("." + EzApprovalGKlibServiceImpl.ENCRYPTED_FILE_EXT)) {
					byte[] encryptedBytes = Files.readAllBytes(orgFile.toPath());
					orgFileInputStream = new ByteArrayInputStream(klibUtil.decrypt(encryptedBytes));
				} else {
					orgFileInputStream = new FileInputStream(orgFile);
				}
				
				Files.copy(orgFileInputStream, newFile.toPath());
				orgFileInputStream.close();
				//FileUtils.copyFile(orgFile, newFile);
			}
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
		model.addAttribute("approvalRoot", approvalRoot);
		
		LOGGER.debug("ezRecevGSusinHWP ended");
		
		return "ezApprovalG/apprGrecevgsusinHWP";
	}	
	
	
	@RequestMapping(value = "/ezApprovalG/ezDeptRecevUI_HWP.do")
	public String ezDeptRecevUI_HWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("ezDeptRecevUI_HWP started");

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
		
		LOGGER.debug("ezDeptRecevUI_HWP ended");
		return "ezApprovalG/apprGdeptRecevuiHWP";
	}
	

	@RequestMapping(value = "/ezApprovalG/ezSimsaG_HWP.do")
	public String ezSimsaG_HWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("ezSimsaG_HWP started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
	    String docID = request.getParameter("docID");
	    String docHref = request.getParameter("docHref");
	    String orgDocID = request.getParameter("orgDocID");
	    String hwpToolbar = ezCommonService.getTenantConfig("HWPToolbar", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
	    String Use_ImgTagTOAttah_body = "N";
	    String approvalRoot = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator;

	    model.addAttribute("userInfo", userInfo);
	    model.addAttribute("docID", docID);
	    model.addAttribute("docHref", docHref);
	    model.addAttribute("orgDocID", orgDocID);
	    model.addAttribute("hwpToolbar", hwpToolbar);
	    model.addAttribute("useEditor", useEditor);
	    model.addAttribute("approvalRoot", approvalRoot);
	    model.addAttribute("Use_ImgTagTOAttah_body", Use_ImgTagTOAttah_body);
		
		LOGGER.debug("ezSimsaG_HWP ended");
		
		return "ezApprovalG/apprGezSimsagHWP";
	}	
		
	/**
	 * 전자결재G 발송의뢰문서 발송 발송 저장 Method
	 */
	@RequestMapping(value = "/ezApprovalG/saveEndFileHwp.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveEndFile(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		LOGGER.debug("saveEndFileHwp started");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = "";
		String docID = request.getParameter("docID");
		String formText = request.getParameter("html");
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String path = commonUtil.getRealPath(request) +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		InputStream stream = null;
		OutputStream bos = null;
		
		try {
			File file = new File(path + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			String saveFileName = path + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator + docID + ".hwp";
		
			stream = new ByteArrayInputStream(Base64.decodeBase64(formText));

			bos = new FileOutputStream(saveFileName);
			
			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];
			
			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
			
			result = "SUCCESS";
		} catch (Exception e) {
			e.printStackTrace();
			
			result = "FAIL";
		} finally {
			if (bos != null) {
				try {
					bos.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
			}
			
			if (stream != null) {
				try {
					stream.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
			}
		}
		
		LOGGER.debug("saveEndFileHwp ended");
		
		return result;
	}
	
	/**
	 * 직인의뢰접수HWP화면 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezConvOutHWP.do")
	public String ezConvOutHWP(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("ezConvOutHWP started.");
		
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
		
		LOGGER.debug("ezConvOutHWP ended.");
		
		return "/ezApprovalG/apprGezConvOutHWP";
	}
	
	public String makeXMLString(String orgString) throws Exception{
		return orgString.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
	}
}
