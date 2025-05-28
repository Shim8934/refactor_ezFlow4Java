package egovframework.ezEKP.ezApprovalG.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Base64;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.ProcessingInstruction;
import org.xml.sax.InputSource;

import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGAdminDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGRelayConfigVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGRelayXMLVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Component
public class EzApprovalGRelayScheduler {
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGRelayScheduler.class);

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private ServletContext servletContext;

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
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;
	
	@Resource(name = "EzApprovalGAdminDAO")
	private EzApprovalGAdminDAO ezApprovalGAdminDao;
	
//	@RequestMapping(value = "/ezApprovalG/relay.do")
//	@Scheduled(cron = "0 0/1 * * * *")
	public void receiverMain_old() throws Exception{
		if (config.getProperty("config.Run_RelayScheduler").equals("NO")) {
			return;
		}
		logger.debug("receiverSchedulerMain Started");
		 String strRelayFolderPath = "";
		 String strAprDocPath =  "";

    	 List<OrganUserVO> list = ezApprovalGService.getTenantID();
		 int tenantID = list.get(0).getTenantId();
		 
		 if(!(config.getProperty("config.RelaySchedulerTenant") == null || config.getProperty("config.RelaySchedulerTenant").equals(""))) {
			 tenantID = Integer.parseInt(config.getProperty("config.RelaySchedulerTenant"));
		 }
    	 
         strRelayFolderPath = commonUtil.getRealPath(servletContext) + commonUtil.separator + "fileroot" + commonUtil.separator + tenantID + commonUtil.separator + "files" + config.getProperty("upload_relay.ROOT").trim();
         strAprDocPath = commonUtil.getRealPath(servletContext) + commonUtil.getUploadPath("upload_relay.R_DocPath", tenantID).trim(); 
         
         if (!strRelayFolderPath.substring(strRelayFolderPath.length() - 1).equals(commonUtil.separator)) {
        	 strRelayFolderPath = strRelayFolderPath + commonUtil.separator;
         }
         
         if (!strAprDocPath.substring(strAprDocPath.length() - 1).equals(commonUtil.separator)) {
        	 strAprDocPath = strAprDocPath + commonUtil.separator;
         }
         
         logger.debug("relayFolderPath = " + strRelayFolderPath + "// aprDocPath = " + strAprDocPath);

         String strFileName = "";
         String strFilePath = "";
         String strFileType = "";
         String strFileDate = "";
         String strReceiveID = "";
         String strSendOrgCode = "";
         String strSendID = "";
         String strTitle = "";
         String strXDocID = "";
         String strDocType = "";
         String strSendName = "";
         String strXGW = "";
         String strXDTDVersion = "";
         String strXSLVersion = "";
         String strRecDate = "";
         String strCompanyID = "";
         String strCont_Role = "";
         String strCont = "";
         String strCont_Name = "";
         String strWriterName = "";
         String strWriterDept = "";
         boolean bRet;
         boolean bGPKI;

         List<List<String[]>> AdminMail = new ArrayList<List<String[]>>();
         List<String[]> receiveerrList = new ArrayList<String[]>();
         List<String[]> xmlparsingerrList = new ArrayList<String[]>();
         List<String[]> senderrList = new ArrayList<String[]>();
         
         //receiveerr 폴더에 쌓인 XML 파일들을 접수 처리 한다.
         if (config.getProperty("USE_RECEIVEERR_FILE_MOVE_RECEIVETEMP").equals("YES")) {
        	 File dirFile = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receiveerr"));
        	 
        	 logger.debug("receiveerrPath = " + strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receiveerr");
        	 
        	 if (dirFile.exists()) {
        		 for (File tempFile : dirFile.listFiles()) {
        			 if (tempFile.isFile()) {
        				 //receiveerr 폴더의 파일들을 수신처리 하기위해, ReceiveTemp로 이동 한다.
        				 String errorfilename = tempFile.getName();
        				 String errorfilepath = tempFile.getParent() + commonUtil.separator + errorfilename;
        				 String errorfileextension = errorfilename.substring(errorfilename.indexOf("."), errorfilename.length());
        				 
        				 logger.debug("errorfilename = " + errorfilename);
        				 logger.debug("errorfilepath = " + errorfilepath);
        				 logger.debug("errorfileextension = " + errorfileextension);
        				 
        				 if (errorfileextension.toLowerCase().equals(".xml")) {
        					 File receiveTemp = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receivetemp" + commonUtil.separator + errorfilename));
        					 File receiveComp = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receiveComp" + commonUtil.separator + errorfilename));
        					 File receive = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receive" + commonUtil.separator + errorfilename));
        					 
        					 logger.debug("receiveTemp = " + strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receivetemp" + commonUtil.separator + errorfilename);
        					 logger.debug("receiveComp = " + strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receiveComp" + commonUtil.separator + errorfilename);
        					 logger.debug("receive = " + strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receive" + commonUtil.separator + errorfilename);

        					 
        					 boolean checkresult = CheckXMLElements(errorfilepath);
        					 boolean XMLLoadTest = TryXMLLoad(errorfilepath);
        					 
        					 if (!receiveTemp.exists() && !receiveComp.exists() && !receive.exists()) {
        						 if (XMLLoadTest && checkresult) {
        							 Document xmlDoc = commonUtil.xmlLod(errorfilepath);
        							 
        							 String[] receiveerrFileInfo = new String[5];
        							 //receiveerr 폴더의 XML 파일명
        							 receiveerrFileInfo[0] = errorfilename;
        							 //송신기관명
        							 receiveerrFileInfo[1] = base64Decode(xmlDoc.getElementsByTagName("send-name").item(0).getTextContent());
        							 //수신기관코드
        							 receiveerrFileInfo[2] = xmlDoc.getElementsByTagName("receive-id").item(0).getTextContent();
        							 //문서제목
        							 receiveerrFileInfo[3] = MakeDNString(base64Decode(xmlDoc.getElementsByTagName("title").item(0).getTextContent()));
        							 //송신일자
        							 receiveerrFileInfo[4] = xmlDoc.getElementsByTagName("date").item(0).getTextContent();
        							 
        							 receiveerrList.add(receiveerrFileInfo);
        							 
        							 receiveerrFileInfo = null;
        							 File fileMove = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receivetemp" + commonUtil.separator + errorfilename));
        							 FileUtils.moveFile(tempFile, fileMove);
        							 xmlDoc = null;
        						 }
        					 }
        					 
        					 receiveTemp = null;
        					 receiveComp = null;
        					 receive = null;
        				 }
        			 }
        		 }
        	 }
    		 
    		 if (config.getProperty("USE_EMAIL_NOTIFICATION").equals("YES")) {
    			 AdminMail.add(receiveerrList);
    		 }
    		 dirFile = null;
         }
         
         //receivetemp 폴더에 쌓인 전송용통합파일(pack.xml)을 풀어 수신처리 한다.
         File receiveDir = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receivetemp"));
         
         logger.debug("receiveDir = " + strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receivetemp");
         
         if (receiveDir.exists()) {
        	 for (File receiveTempFile : receiveDir.listFiles()) {
        		 try {
        			 strFileName = receiveTempFile.getName();
        			 strFilePath = receiveTempFile.getParent() + commonUtil.separator + strFileName;
        			 strFileType =  strFileName.substring(strFileName.indexOf("."), strFileName.length()).toUpperCase();
        			 
        			 if (strFileType.equals(".XML")) {
        				 logger.debug("receiveFile Started");
        				 logger.debug("receiveFileName : " + strFileName + " receiveFilePath : " + strFilePath + " receiveFileType : " + strFileType);
        				 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        				 
        				 strFileDate = sdf.format(receiveTempFile.lastModified()).toString();
        				 strReceiveID = strFileName.substring(7,14);
        				 
        				 if (!TryXMLLoad(strFilePath)) {
        					 String[] xmlParsingErrInfo = new String[2];
        					 xmlParsingErrInfo[0] = strFileName;
        					 xmlParsingErrInfo[1] = TryXMLLoadWithReturnMessage(strFilePath);
        					 xmlparsingerrList.add(xmlParsingErrInfo);
        					 AdminMail.add(xmlparsingerrList);
        					 
        					 File receiveTemp = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receivetemperr"));
        					 
        					 if (!receiveTemp.exists()){
        						 receiveTemp.mkdirs();
        					 }
        					 
        					 File fileMove = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receivetemperr" + commonUtil.separator + strFileName));
        					 FileUtils.moveFile(receiveDir, fileMove);
        					 
        					 logger.debug("비정상적인 XML파일, 수신처리 할 수 없습니다.", "");
        					 logger.debug("파일을 receivetemperr 폴더로 이동 하였습니다.", "");
        					 logger.debug("=============================================>수신종료.", "");
        					 
        					 continue;
        				 }
        				 
        				 Document objXML = commonUtil.xmlLod(strFilePath);
        				 
        				 strSendOrgCode = objXML.getElementsByTagName("send-orgcode").item(0).getTextContent();
        				 logger.debug("#송신기관코드=" + strSendOrgCode);
        				 strSendID = objXML.getElementsByTagName("send-id").item(0).getTextContent();
        				 logger.debug("#송신부서코드=" + strSendID);
        				 
        				 //수신기관코드가 회사ID랑 다를 경우 회사ID로 맞추어 준다.(보정처리)
        				 boolean RecvIDCheck = false;
        				 List <OrganDeptVO> extensionAttr4ID = ezOrganService.getExtensionAttr4ID(strReceiveID);
        				 int listSize = extensionAttr4ID.size();
        				 
        				 if (listSize > 0) {
        					 for (int m = 0; m < listSize; m++) {
        						 strCompanyID = extensionAttr4ID.get(m).getExtensionAttribute2();
        					 }
        				 } else {
        					 strCompanyID = config.getProperty("config.companyNum");
        				 }
        				 
        				 logger.debug("strCompanyID = " + strCompanyID);
        				 
        				 if (listSize > 0) {
        					 for (int m = 0; m < listSize; m++) {
        						 if (strReceiveID.trim().equals(extensionAttr4ID.get(m).getExtensionAttribute4())) {
        							 strReceiveID = extensionAttr4ID.get(m).getCn();
        							 RecvIDCheck = true;
        							 break;
        						 }
        					 }
        				 } else {
        					 if (!strCompanyID.trim().equals("")) {
        						 if (!strReceiveID.trim().equals(strCompanyID.trim())){
        							 strReceiveID = strCompanyID.trim();
        						 }
        						 RecvIDCheck = true;
        					 }
        				 }
        				 
        				 if (RecvIDCheck) {
        					 objXML.getElementsByTagName("receive-id").item(0).setTextContent(strReceiveID);
        					 logger.debug("#수신부서코드=" + strReceiveID);
        					 
        					 if (!objXML.getElementsByTagName("title").item(0).getTextContent().equals("")) {
        						 strTitle = base64DecodeGetBytes(objXML.getElementsByTagName("title").item(0).getTextContent().getBytes("UTF-8"));
        						 
        						 if (strTitle.length() > 125) {
        							 strTitle = strTitle.substring(1, 125);
        						 }
        					 }   
        					 logger.debug("#문서제목=" + strTitle);
        					 strXDocID = objXML.getElementsByTagName("doc-id").item(0).getTextContent();
        					 logger.debug("#문서고유번호=" + strXDocID);
        					 strDocType = objXML.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("type").getTextContent();
        					 logger.debug("#문서종류=" + strDocType);
        					 strWriterName = base64Decode(objXML.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").getTextContent());
        					 
        					 if (strWriterName == null || strWriterName.equals("")) {
        						 strWriterName = "미확인";
        					 }
        					 
        					 logger.debug("#문서작성자이름=" + strWriterName);
        					 strWriterDept = base64Decode(objXML.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").getTextContent());
        					 
        					 if (strWriterDept == null || strWriterDept.equals("")) {
        						 strWriterDept = "미확인";
        					 }
        					 
        					 logger.debug("#문서작성자부서=" + strWriterDept);
        					 strSendName = base64Decode(objXML.getElementsByTagName("send-name").item(0).getTextContent());
        					 logger.debug("#송신기관명=" + strSendName);
        					 strXGW = base64Decode(objXML.getElementsByTagName("send-gw").item(0).getTextContent());
        					 logger.debug("#송신그룹웨어명=" + strXGW);
        					 strXDTDVersion = objXML.getElementsByTagName("dtd-version").item(0).getTextContent().toString();
        					 logger.debug("#DTD버전=" + strXDTDVersion);
        					 strXSLVersion = objXML.getElementsByTagName("xsl-version").item(0).getTextContent();
        					 logger.debug("#XSL버전=" + strXSLVersion);
        					 
        					 if (objXML.getElementsByTagName("date").item(0).getTextContent().length() > 0) {
        						 strRecDate = objXML.getElementsByTagName("date").item(0).getTextContent();
        					 } else {
        						 strRecDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), "235|+09:00", true);
        					 }
        					 
        					 if (!ValidateDateTimeString(strRecDate)) {
        						 strRecDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), "235|+09:00", true);
        					 }
        					 
        					 logger.debug("#날짜=" + strRecDate);
        					 
        					 switch (strDocType.trim()) {
        					 case "send":
        					 case "resend":
        						 bRet = ezApprovalGService.insertRelayDB("", strXDocID, strRecDate, strSendName, strReceiveID, strTitle, "", strSendID, strReceiveID, strXGW, strDocType, strXDTDVersion, strXSLVersion, "", "", "", strFileDate, strCompanyID, tenantID);
        						 logger.debug("#중계문서정보생성=" + bRet, "");
        						 
        						 bGPKI = false;
        						 
        						 if (objXML.getElementsByTagName("content").getLength() == 1) {
        							 strCont_Role = objXML.getElementsByTagName("content").item(0).getAttributes().getNamedItem("content-role").getTextContent();
        							 if (strCont_Role.equals("gpki")) {
        								 bGPKI = true;
        							 }
        						 }
        						 
        						 if (bGPKI) {
        							 // 암호화된 경우 해당 XML 파일을 특정 폴더로 저장한다.
        							 strCont = objXML.getElementsByTagName("content").item(0).getTextContent();                                        
        							 File gpkFile = new File(commonUtil.detectPathTraversal(strAprDocPath + strCompanyID + commonUtil.separator + "exDocMSG" + commonUtil.separator + strXDocID.replace("/", "_").replace("#", "_") + strReceiveID + ".xml"));
        							 
        							 if (gpkFile.exists()) {
        								 gpkFile.delete();
        							 }
        							 
									 // CWE-404 보안 취약점 대응
        							 try (FileOutputStream fop = new FileOutputStream(gpkFile)) {
										// get the content in bytes
										fop.write(commonUtil.convertDocumentToString(objXML).getBytes("UTF-8"));
										fop.flush();
									 }
        							 
        							 ezApprovalGService.fieldUpdate("emlURL", strXDocID.replace("/", "_").replace("#", "_") + strReceiveID + ".xml", strXDocID, strReceiveID, strCompanyID, tenantID);
        							 ezApprovalGService.fieldUpdate("isPKI", "Y", strXDocID, strReceiveID, strCompanyID, tenantID);
        						 } else {
        							 File recFile = new File(commonUtil.detectPathTraversal(strAprDocPath + strCompanyID + commonUtil.separator +"exDocMSG" + commonUtil.separator + strXDocID.replace("/", "_").replace("#", "_") + strReceiveID + ".xml"));
        							 
        							 File recDir = new File(commonUtil.detectPathTraversal(strAprDocPath + strCompanyID + commonUtil.separator +"exDocMSG"));
        							 
        							 if (!recDir.exists()) {
        								 recDir.mkdirs();
        							 }
        							 
        							 if (recFile.exists()) {
        								 recFile.delete();
        							 }
        							 
									 // CWE-404 보안 취약점 대응
        							 try (FileOutputStream fop = new FileOutputStream(recFile)) {
										// get the content in bytes
										fop.write(commonUtil.convertDocumentToString(objXML).getBytes("UTF-8"));
										fop.flush();
									 }
        							 
        							 logger.debug("#pack파일생성= OK");
        							 
        							 ezApprovalGService.fieldUpdate("emlURL", strXDocID.replace("/", "_").replace("#", "_") + strReceiveID + ".xml", strXDocID, strReceiveID, strCompanyID, tenantID);
        							 ezApprovalGService.fieldUpdate("isPKI", "N", strXDocID, strReceiveID, strCompanyID, tenantID);

        							 // 정주환 유통문서 img 태그 src 한글오류 수정
        							 String randomUUID = UUID.randomUUID().toString();
        							 
        							 for (int count = 0; count < objXML.getElementsByTagName("content").getLength(); count++) {
        								 strCont_Role = objXML.getElementsByTagName("content").item(count).getAttributes().getNamedItem("content-role").getTextContent();
        								 strCont = objXML.getElementsByTagName("content").item(count).getTextContent();
        								 strCont_Name = base64Decode(objXML.getElementsByTagName("content").item(count).getAttributes().getNamedItem("filename").getTextContent());
        								 strCont = strCont.replace("\r", "").replace("\n", "").replace("\t", "");
        								 String extension = strCont_Name.substring(strCont_Name.lastIndexOf("."));
        								 
        								 switch (strCont_Role) {
        								 case "pubdoc":
        									 boolean WritePubDoc = WriteXMLFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocXML" , strXDocID.replace("/", "_").replace("#", "_") + strReceiveID + ".xml");
        									 
        									 logger.debug("#pubdoc생성=" + WritePubDoc);
        									 pubdocUpdate(strAprDocPath + strCompanyID + commonUtil.separator + "ExDocXML" + commonUtil.separator + strXDocID.replace("/", "_").replace("#", "_") + strReceiveID + ".xml");
        									 ezApprovalGService.fieldUpdate("xmlURL", strXDocID.replace("/", "_").replace("#", "_") + strReceiveID + ".xml", strXDocID, strReceiveID, strCompanyID, tenantID);
        									 break;
        								 case "attach":
        									 boolean WriteAttache = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocDown" , strXDocID.replace("/", "_").replace("#", "_") + strCont_Name);
        									 logger.debug("#attach생성=" + WriteAttache);
        									 ezApprovalGService.addAttachInfo(strCont_Name, strXDocID.replace("/", "_").replace("#", "_") + strCont_Name, strXDocID, Integer.toString(count), "N", strCompanyID, tenantID);
        									 break;
        								 case "attach_body":
        									 // 이 것 때문에 attach_body에서 오류남 
        									 /* //콘텐트의 내용을 base64로 디코딩
        								 String tempString = new String(Base64.decodeBase64(objXML.getElementsByTagName("content").item(0).getTextContent()), "euc-kr" );
        								 //디코딩된 내용에 nbsp가 있으면 string 에서 xml로 변환되지 않음
        								 tempString = tempString.replaceAll("&nbsp;", "");
        								 //첫부분 3줄의 내용이 xml로 변환되는데 오류가 생김
        								 String[] tempStrLine = tempString.split("\\r?\\n", 4);
        								 
        								 //4번째부터의 내용을 xml로 변환
        								 Document tempXml = commonUtil.convertStringToDocument(tempStrLine[3]);*/
        									 
//        								 if ("true".equals(tempXml.getElementsByTagName("body").item(0).getAttributes().getNamedItem("separate").getTextContent())) {
        									 boolean WriteBodyAttach = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocDown" , strXDocID.replace("/", "_").replace("#", "_") + strCont_Name);
        									 logger.debug("#attach_body생성=" + WriteBodyAttach);
        									 ezApprovalGService.addAttachInfo(strCont_Name, strXDocID.replace("/", "_").replace("#", "_") + strCont_Name, strXDocID, Integer.toString(count), "Y", strCompanyID, tenantID);
//        								 }
        									 break;
        								 case "attach_xml":
        									 boolean WriteXMLFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "exch" , strXDocID.replace("/", "_").replace("#", "_") + strCont_Name);
        									 logger.debug("#attach_xml생성=" + WriteXMLFile, "");
        									 ezApprovalGService.addAttachInfo(strCont_Name, strXDocID.replace("/", "_").replace("#", "_") + strCont_Name, strXDocID, Integer.toString(count), "XML", strCompanyID, tenantID);
        									 break;
        								 case "attach_xsl":
        									 boolean WriteXSLFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "exch" , strCont_Name);
        									 logger.debug("#attach_xsl생성=" + WriteXSLFile, "");
        									 ezApprovalGService.addAttachInfo(strCont_Name, strCont_Name, strXDocID, Integer.toString(count), "XSL", strCompanyID, tenantID);
        									 break;
        								 case "seal":
//        									 boolean WriteSealFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocSign" , strCont_Name);
        									 boolean WriteSealFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocSign" , randomUUID + extension);
        									 logger.debug("#seal생성=" + WriteSealFile, "");
//        									 ezApprovalGService.fieldUpdate("sealURL", strCont_Name, strXDocID, strReceiveID, strCompanyID, tenantID);
        									 ezApprovalGService.fieldUpdate("sealURL", randomUUID + extension, strXDocID, strReceiveID, strCompanyID, tenantID);
        									 break;
        								 case "sign":
        									 randomUUID = UUID.randomUUID().toString();
//        									 boolean WriteSignFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocUserSign" ,  strXDocID.replace("/", "_").replace("#", "_") + strCont_Name);
        									 boolean WriteSignFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocUserSign" ,  randomUUID + extension);
        									 logger.debug("#sign생성=" + WriteSignFile, "");
//        									 ezApprovalGService.addSignInfo(strCont_Name, strXDocID.replace("/", "_").replace("#", "_") + strCont_Name, strXDocID, strCompanyID, tenantID);
        									 ezApprovalGService.addSignInfo(strCont_Name, randomUUID + extension, strXDocID, strCompanyID, tenantID);
        									 break;
        								 case "logo":
//        									 boolean WritetLogoFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocUserSign" ,  strXDocID.replace("/", "_").replace("#", "_") + strCont_Name);
        									 boolean WritetLogoFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocUserSign" ,  randomUUID + "logo" + extension);
        									 logger.debug("#logo생성=" + WritetLogoFile, "");
//        									 ezApprovalGService.addSignInfo(strCont_Name, strXDocID.replace("/", "_").replace("#", "_") + strCont_Name, strXDocID, strCompanyID, tenantID);
        									 ezApprovalGService.addSignInfo(strCont_Name, randomUUID + "logo" + extension, strXDocID, strCompanyID, tenantID);
        									 break;
        								 case "symbol":
//        									 boolean WriteSymbolFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocUserSign" ,  strXDocID.replace("/", "_").replace("#", "_") + strCont_Name);
        									 boolean WriteSymbolFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocUserSign" ,  randomUUID + "symbol" + extension);
        									 logger.debug("#symbol생성=" + WriteSymbolFile, "");
//        									 ezApprovalGService.addSignInfo(strCont_Name, strXDocID.replace("/", "_").replace("#", "_") + strCont_Name, strXDocID, strCompanyID, tenantID);
        									 ezApprovalGService.addSignInfo(strCont_Name, randomUUID + "symbol" + extension, strXDocID, strCompanyID, tenantID);
        									 break;
        								 }
        							 }
        						 }
        						 
        						 // 일단 추석처리함
                                 //System.Xml.XmlDocument extXml = new System.Xml.XmlDocument();
                                 //extXml.LoadXml(strReXml);
                                 //string strFormPath = extXml.InnerText;
                                 //extXml = null;
        						 
        						 //결재진행문서 정보에 수신문서 정보를 입력해 준다.
        						 boolean inputReceiveInfo = ezApprovalGService.createRelayDocInfo(strWriterName, strWriterDept, commonUtil.getRealPath(servletContext), strXDocID, strReceiveID, strCompanyID, tenantID);
        						 logger.debug("#수신문서정보입력=" + inputReceiveInfo);
        						 
        						 //수신된 유통문서에 대해 수신(Receive) ACK 발송
        						 boolean SendReceiveACK = ezApprovalGService.sendAck(strXDocID, strReceiveID, strSendID, strTitle, "receive", "", "", "", strCompanyID, tenantID);
        						 logger.debug("#수신ACK발송=" + SendReceiveACK);
        						 
        						 break;
        						 // 발송 실패에 따른 메시지 Update
        					 case "fail":
        						 String Message = base64Decode(objXML.getElementsByTagName("content").item(0).getTextContent());
        						 boolean UpdateSendDoc_Fail = ezApprovalGService.updateRelaySusinState(strXDocID, strRecDate, strDocType, strSendID, "", strCompanyID, tenantID);
//        					 boolean InsMessage = ezApprovalGService.insFailMessage(strXDocID, strSendID, strSendName, Message, strCompanyID, tenantID);
        						 logger.debug("#발송실패오류=" + Message, "");
        						 logger.debug("#발송문서실패=" + UpdateSendDoc_Fail, "");
        						 break;
        						 // 도달 - 수신기관의 중계모듈이 전송용 통합파일을 임시수신함(receivetemp)에 저장한 후 생성
        					 case "arrive":
        						 boolean UpdateSendDoc_Arrive = ezApprovalGService.updateRelaySusinState(strXDocID, strRecDate, strDocType, strSendID, "", strCompanyID, tenantID);
        						 logger.debug("#발송문서도달=" + UpdateSendDoc_Arrive);
        						 break;
        						 // 수신 - 수신기관의 전자문서시스템이 중계모듈의 임시수신함(receivetemp)에 수신된 문서를 가져가는 작업 완료 후 생성
        					 case "receive":
        						 boolean UpdateSendDoc_Receive = ezApprovalGService.updateRelaySusinState(strXDocID, strRecDate, strDocType, strSendID, "", strCompanyID, tenantID);
        						 logger.debug("#발송문서수신=" + UpdateSendDoc_Receive);
        						 break;
        						 // 접수 - 수신기관에서 문서를 정상적으로 최초 확인
        					 case "accept":
        						 String strAcceptName = base64Decode(objXML.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").getTextContent()) + "(" + base64Decode(objXML.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").getTextContent()) + ")";
        						 boolean UpdateSendDoc_Accept = ezApprovalGService.updateRelaySusinState(strXDocID, strRecDate, strDocType, strSendID, strAcceptName, strCompanyID, tenantID);
        						 logger.debug("#발송문서접수=" + UpdateSendDoc_Accept);
        						 
        						 break;
        						 // 발송 문서에 대한 수신 기관 접수 부서 및 접수자 Update
        					 case "return":                           
        					 case "req-resend":
        						 boolean UpdateSendDoc_ReqResend = ezApprovalGService.updateRelaySusinState(strXDocID, strRecDate, strDocType, strSendID, "", strCompanyID, tenantID);
        						 logger.debug("#발송문서정보갱신=" + UpdateSendDoc_ReqResend);
        						 
        						 NodeList contentNodeList = objXML.getElementsByTagName("content");
        						 Node contentNode = null;
        						 
        						 if(contentNodeList != null && contentNodeList.getLength() > 0) {
        							 contentNode = contentNodeList.item(0);
        						 }
        						 //수신기관에서 재발송 요청시 의견 추가
        						 if (contentNode != null && contentNode.getAttributes().getNamedItem("content-role") != null) {
        							 strCont_Role = contentNode.getAttributes().getNamedItem("content-role").getTextContent();
        						 }
        						 
        						 if (strCont_Role != null && strCont_Role.equals("return")) {
        							 strCont = contentNode.getTextContent();
        							 strCont_Name = "return.txt";
        							 strCont = strCont.replace("\r", "").replace("\n", "").replace("\t", "");
        							 
        							 //인코딩 안풀고 그냥 저장
        							 boolean writeReqResendOpinion = writeReqResendOpinion(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExOpinion", strXDocID + strSendID + strCont_Name);
        							 logger.debug("#재발송요청 의견 생성=" + writeReqResendOpinion);
        						 }
        						 
        						 break;
        					 }
        					 
        					 File di2 = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receiveComp"));
        					 
        					 if (di2.exists()) {
        						 File FI2 = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receiveComp" + commonUtil.separator + strFileName));
        						 if (FI2.exists()) {
        							 receiveTempFile.delete();
        						 } else {
        							 File fileMove = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receiveComp" + commonUtil.separator + strFileName));
        							 receiveTempFile.renameTo(fileMove);
        						 }
        					 } else {
        						 receiveTempFile.delete();
        					 }
        					 logger.debug("=============================================>수신종료.", "");
        				 } else {
        					 logger.debug("#수신부서코드=" + strReceiveID, "해당 수신기관코드가 존재하지 않습니다.");
        				 }
        			 }
					
				} catch (Exception e) {
					logger.debug("#대외문서 접수 중 에러. 파일명 = " + receiveTempFile.getName());
					backupErrorXml(strRelayFolderPath, receiveTempFile);
					logger.error(e.getMessage(), e);
					continue;
				}
        	 }
         }

         File senderr = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "senderr"));
         File [] fileList = senderr.listFiles();
         
         logger.debug("senderrPath = " + strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "senderr");
         
         if (fileList != null) {
    		 for (File tempFile : fileList) {

    			 String errorfilename = tempFile.getName();
    		     String errorfilepath = tempFile.getParent() + commonUtil.separator + errorfilename;
    		     String errorfileextension = errorfilename.substring(errorfilename.indexOf("."), errorfilename.length());
 
                 if (errorfileextension.toLowerCase().equals(".xml")) {
                     String[] senderrInfo = new String[7];
                     Document xmlDoc = commonUtil.xmlLod(errorfilepath);

                     //receiveerr 폴더의 XML 파일명
                     senderrInfo[0] = errorfilename;
                     //송신기관명
                     senderrInfo[1] = base64Decode(xmlDoc.getElementsByTagName("send-name").item(0).getTextContent());
                     //수신기관코드
                     senderrInfo[2] = xmlDoc.getElementsByTagName("receive-id").item(0).getTextContent();
                     //문서제목
                     senderrInfo[3] = MakeDNString(base64Decode(xmlDoc.getElementsByTagName("title").item(0).getTextContent()));
                     
                     senderrInfo[4] = MakeDNString(base64Decode(xmlDoc.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").getTextContent()));
                     senderrInfo[5] = MakeDNString(base64Decode(xmlDoc.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").getTextContent()));
                     //송신일자
                     senderrInfo[6] = xmlDoc.getElementsByTagName("date").item(0).getTextContent();
                     
                     senderrList.add(senderrInfo);
                     
                     File dir3 = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "senderrtemp"));
                     if (!dir3.exists()) {
                    	 dir3.mkdirs();
                     }
                     File fileMove = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "senderrtemp" + commonUtil.separator + errorfilename));

                     dir3.renameTo(fileMove);
                 }
             }
         }
		 if (config.getProperty("USE_EMAIL_NOTIFICATION").equals("YES")) {
			 if (receiveerrList.size() > 0) {
				 AdminMail.add(receiveerrList);
			 }
		 }
         senderr = null;

         //메일 대상자 알면 주석 풀기
//    		 if (config.getProperty("USE_EMAIL_NOTIFICATION").equals("YES")) {
//                 String title = "중계문서 장애 처리 알림 메일";
//                 if (AdminMail.size() > 0) {
//	                 String mailBody = MakeMailContent(AdminMail);
//	                 if (mailBody != "<div></div>" && AdminMail.size() > 0) {
//	//                     base.SendMessage(title, mailBody);
//	                 }
//                 }
//             }
		 logger.debug("receiverSchedulerMain ended");
	}
	
	@RequestMapping(value = "/ezApprovalG/relayTest.do")
	public void receiverMainTest(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("receiverMainTest Started");
		
		String serverName = request.getServerName();
		int tenantID = loginService.getTenantId(serverName);
		
		if(!ezCommonService.getTenantConfig("useRelayTest", tenantID).equals("YES")) {
			return;
		}
				
        String strRelayFolderPath = "";
        String strAprDocPath =  "";
        
		strRelayFolderPath = commonUtil.getRealPath(servletContext) + commonUtil.separator + "fileroot" + commonUtil.separator + tenantID + commonUtil.separator + "files" + config.getProperty("upload_relay.ROOT");
		strAprDocPath = commonUtil.getRealPath(servletContext) + commonUtil.getUploadPath("upload_relay.R_DocPath", tenantID); 
		
		if (!strRelayFolderPath.substring(strRelayFolderPath.length() - 1).equals(commonUtil.separator)) {
			strRelayFolderPath = strRelayFolderPath + commonUtil.separator;
		}
		
		if (!strAprDocPath.substring(strAprDocPath.length() - 1).equals(commonUtil.separator)) {
			strAprDocPath = strAprDocPath + commonUtil.separator;
		}
		
		String strFileName = "";
		String strFilePath = "";
		String strFileType = "";
		File receiveTempDir = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receivetemp"));
		File sendTempDir = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"sendtemp"));
		
		if (sendTempDir.exists()) {
			for (File sendTempFile : sendTempDir.listFiles()) {
				String strReceiveID = "";
				@SuppressWarnings("unused")
				String strSendOrgCode = "";
				String strSendID = "";
				strFileName = sendTempFile.getName();
				strFilePath = sendTempFile.getParent() + commonUtil.separator + strFileName;
				strFileType =  strFileName.substring(strFileName.indexOf("."), strFileName.length()).toUpperCase();
				
				if (strFileType.equals(".XML")) {
					logger.debug("sendFile Started");
					logger.debug("sendFileName : " + strFileName);
					
					Document objXML = commonUtil.xmlLod(strFilePath);
					
					if(objXML.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("type").getTextContent().indexOf("send") == -1) {
						continue;
					}
					
					strReceiveID = objXML.getElementsByTagName("receive-id").item(0).getTextContent().split(";")[0];
					strSendOrgCode = objXML.getElementsByTagName("send-orgcode").item(0).getTextContent();
					strSendID = objXML.getElementsByTagName("send-id").item(0).getTextContent();
					
					objXML.getElementsByTagName("receive-id").item(0).setTextContent(strSendID);
					objXML.getElementsByTagName("send-orgcode").item(0).setTextContent(strReceiveID);
					objXML.getElementsByTagName("send-id").item(0).setTextContent(strReceiveID);
					
					TransformerFactory transfac = TransformerFactory.newInstance();
					Transformer trans = transfac.newTransformer();
					trans.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, "pack.dtd");
					
					StringWriter sw = new StringWriter();
					StreamResult result = new StreamResult(sw);
					DOMSource source = new DOMSource(objXML);
					
					trans.transform(source, result);
					String xmlString = sw.toString();
					
					// CWE-404 보안 취약점 대응
					try (OutputStream fos = new FileOutputStream(sendTempFile)) {
						byte[] buf = xmlString.getBytes();
						
						for (int i = 0; i < buf.length; i++) {
							fos.write(buf[i]);
						}

						buf = null;
					}
					
					String newFileName = strReceiveID + strSendID + strFileName.substring(strFileName.length() - 20, strFileName.length() - 4) + ".xml";
					sendTempFile.renameTo(new File(receiveTempDir.getAbsolutePath() + commonUtil.separator  + newFileName));
				}
			}
		}
		logger.debug("receiverMainTest ended");
		receiverMain();
	}
	
	//수신기관에서 재발송 요청하면 요청의견 텍스트 파일로 떨어뜨리고 발송대장 화면에서 제공하기
	private boolean writeReqResendOpinion(String strCont, String pFilePath, String fileName) {
		logger.debug("writeReqResendOpinion started");

		boolean result = false;
		
		try {
			File dir = new File(commonUtil.detectPathTraversal(pFilePath));
			
			if (!dir.exists()) {
				dir.mkdirs();
			}

			// CWE-404 보안 취약점 대응
	        try (FileOutputStream fos = new FileOutputStream(commonUtil.detectPathTraversal(pFilePath + commonUtil.separator + fileName))) {
				fos.write(strCont.getBytes());
			}

	        result = true;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = false;
		}
		
		logger.debug("writeReqResendOpinion ended");
		
		return result;
	}

	public String MakeMailContent(List<List<String[]>> list) {
		String body = null;
		StringBuilder sb = new StringBuilder(32);
        List<String[]> li1 = list.get(0);
        List<String[]> li2 = list.get(1);
        List<String[]> li3 = list.get(2);
        sb.append("<div>");

        if (li1.size() > 0) {
            //receiverr 폴더 관련 내용
            sb.append("<h1 style='font-family: 'Malgun Gothic','Arial';'>&nbsp;중계문서 장애처리 알림</h1>");
            sb.append("<div id='receiveerrinfo'>");
            sb.append("<table style='border-collapse: collapse; text-align: left; line-height: 1.5;'>");
            sb.append("<thead>");
            sb.append("<tr>");
            sb.append("<th scope='cols' style='padding: 5px; font-weight: bold; vertical-align: top; color: #369; border-bottom: 3px solid #036; font-family: 'Malgun Gothic','Arial';'>처리</th>");
            sb.append("<th scope='cols' style='padding: 5px; font-weight: bold; vertical-align: top; color: #369; border-bottom: 3px solid #036; font-family: 'Malgun Gothic','Arial';'>상태</th>");
            sb.append("<th scope='cols' style='padding: 5px; font-weight: bold; vertical-align: top; color: #369; border-bottom: 3px solid #036; font-family: 'Malgun Gothic','Arial';'>후속조치</th>");
            sb.append("</tr>");
            sb.append("</thead>");
            sb.append("<tbody>");
            sb.append("<tr>");
            sb.append("<td scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc; background: #f3f6f7; text-align: center; font-family: 'Malgun Gothic','Arial';'>중계문서수신</td>");
            sb.append("<td scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc; background: #f3f6f7; text-align: center; font-family: 'Malgun Gothic','Arial';'>중계문서수신 에러</td>");
            sb.append("<td style='width: 500px; padding: 5px; vertical-align: top; border-bottom: 1px solid #ccc; text-align: center; font-family: 'Malgun Gothic','Arial';'>receiveerr → receivetemp 파일 이동 후 접수 진행 </td>");
            sb.append("</tr>");
            sb.append("</tbody>");
            sb.append("</table>");
            sb.append("</div>");
            sb.append("<div id='receiveerrfilelist'>");
            sb.append("<table style='border-collapse: collapse; text-align: left; line-height: 1.5; border-top: 1px solid #ccc; border-left: 3px solid #369; margin: 20px 0px; font-family: 'Malgun Gothic','Arial','Segoe UI';'>");

            for (int i = 0; i < li1.size(); i++) {
                String[] arr1 = li1.get(i);

                sb.append("<tr>");
                sb.append("<th style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; color: #153d73; border-right: 1px solid #ccc; border-bottom: 1px solid #ccc;'>중계문서정보</th>");
                sb.append("<td style='width: 655px; padding: 5px; vertical-align: top; border-right: 1px solid #ccc; border-bottom: 1px solid #ccc;'>");
                sb.append("아래 파일이 receiveerr 폴더에서 receivetemp 폴더로 이동됨<table style='border-collapse: separate; border-spacing: 1px; text-align: left; line-height: 1.5; border-top: 1px solid #ccc; margin: 5px 5px;'>");
                sb.append("<tr><th scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc;'>파일명</th><td style='width: 550px; padding: 10px; vertical-align: top; border-bottom: 1px solid #ccc;'>" + arr1[0] + "</td></tr>");
                sb.append("<tr><th scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc;'>송신기관명</th><td style='width: 550px; padding: 10px; vertical-align: top; border-bottom: 1px solid #ccc;'>" + arr1[1] + "</td></tr>");
                sb.append("<tr><th scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc;'>수신기관명</th><td style='width: 550px; padding: 10px; vertical-align: top; border-bottom: 1px solid #ccc;'>" + arr1[2] + "</td></tr>");
                sb.append("<tr><th scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc;'>문서제목</th><td style='width: 550px; padding: 10px; vertical-align: top; border-bottom: 1px solid #ccc;'>" + arr1[3] + "</td></tr>");
                sb.append("<tr><th scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc;'>송신시간</th><td style='width: 550px; padding: 10px; vertical-align: top; border-bottom: 1px solid #ccc;'>" + arr1[4] + "</td></tr>");
                sb.append("</table></td></tr>");

            }

            sb.append("</table>");
            sb.append("</div>");
        }

        if (li2.size() > 0 && config.getProperty("USE_RECEIVETEMPERR_ALERT").equals("YES")) {

            sb.append("<div>");
            sb.append("<table style='border-collapse: collapse; text-align: left; line-height: 1.5;'>");
            sb.append("<thead>");
            sb.append("<tr>");
            sb.append("<th scope='cols' style='padding: 5px; font-weight: bold; vertical-align: top; color: #369; border-bottom: 3px solid #036; font-family: 'Malgun Gothic','Arial';'>처리</th>");
            sb.append("<th scope='cols' style='padding: 5px; font-weight: bold; vertical-align: top; color: #369; border-bottom: 3px solid #036; font-family: 'Malgun Gothic','Arial';'>상태</th>");
            sb.append("<th scope='cols' style='padding: 5px; font-weight: bold; vertical-align: top; color: #369; border-bottom: 3px solid #036; font-family: 'Malgun Gothic','Arial';'>후속조치</th>");
            sb.append("</tr>");
            sb.append("</thead>");
            sb.append("<tbody>");
            sb.append("<tr>");
            sb.append("<td scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc; background: #f3f6f7; text-align: center; font-family: 'Malgun Gothic','Arial';'>중계문서수신</td>");
            sb.append("<td scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc; background: #f3f6f7; text-align: center; font-family: 'Malgun Gothic','Arial';'>XML 파싱에러</td>");
            sb.append("<td style='width: 500px; padding: 5px; vertical-align: top; border-bottom: 1px solid #ccc; text-align: center; font-family: 'Malgun Gothic','Arial';'>XML로드 실패 접수제외 처리, 파일이동</td>");
            sb.append("</tr>");
            sb.append("</tbody>");
            sb.append("</table>");
            sb.append("</div>");

            sb.append("<div id='XMLLoadFailFileList'>");
            sb.append("<table style='border-collapse: collapse; text-align: left; line-height: 1.5; border-top: 1px solid #ccc; border-left: 3px solid #369; margin: 20px 0px; font-family: 'Malgun Gothic','Arial','Segoe UI';'>");

            for (int k = 0; k < li2.size(); k++) {
                String[] arr2 = li2.get(k);
                sb.append("<tr><th style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; color: #153d73; border-right: 1px solid #ccc; border-bottom: 1px solid #ccc;'>중계문서정보</th><td style='width: 655px; padding: 5px; vertical-align: top; border-right: 1px solid #ccc; border-bottom: 1px solid #ccc;'>다음파일이 receivetemp 폴더에서 receivetemperr 폴더로이동 됨 :<br />" + arr2[0] + "<br /> 에러내용 : " + arr2[1] + "</td></tr>");
            }

            sb.append("</table>");
            sb.append("</div>");

        }

        if (li3.size() > 0) {
            sb.append("<hr />");

            sb.append("<h1 style='font-family: 'Malgun Gothic','Arial';'>&nbsp;중계문서 발송장애 알림</h1>");
            sb.append("<div>");
            sb.append("<table style='border-collapse: collapse; text-align: left; line-height: 1.5;'>");
            sb.append("<thead><tr>");
            sb.append("<th scope='cols' style='padding: 5px; font-weight: bold; vertical-align: top; color: #369; border-bottom: 3px solid #036; font-family: 'Malgun Gothic','Arial';'>처리</th>");
            sb.append("<th scope='cols' style='padding: 5px; font-weight: bold; vertical-align: top; color: #369; border-bottom: 3px solid #036; font-family: 'Malgun Gothic','Arial';'>상태</th>");
            sb.append("<th scope='cols' style='padding: 5px; font-weight: bold; vertical-align: top; color: #369; border-bottom: 3px solid #036; font-family: 'Malgun Gothic','Arial';'>후속조치</th>");
            sb.append("</tr></thead>");
            sb.append("<tbody><tr>");
            sb.append("<td scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc; background: #f3f6f7; text-align: center; font-family: 'Malgun Gothic','Arial';'>중계문서발송</td>");
            sb.append("<td scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc; background: #f3f6f7; text-align: center; font-family: 'Malgun Gothic','Arial';'>중계문서 발송실패</td>");
            sb.append("<td style='width: 500px; padding: 5px; vertical-align: top; border-bottom: 1px solid #ccc; text-align: center; font-family: 'Malgun Gothic','Arial';'>중계모듈에서 그룹웨어로 발송실패 ACK 발송</td>");
            sb.append("</tr></tbody></table></div>");
            sb.append("<div>");
            sb.append("<table style='border-collapse: collapse; text-align: left; line-height: 1.5; border-top: 1px solid #ccc; border-left: 3px solid #369; margin: 20px 0px; font-family: 'Malgun Gothic','Arial','Segoe UI';'>");

            for (int j = 0; j < li3.size(); j++) {
                String[] arr3 = li3.get(j);
                sb.append("<tr>");
                sb.append("<th style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; color: #153d73; border-right: 1px solid #ccc; border-bottom: 1px solid #ccc;'>중계문서정보</th>");
                sb.append("<td style='width: 655px; padding: 5px; vertical-align: top; border-right: 1px solid #ccc; border-bottom: 1px solid #ccc;'>");
                sb.append("아래 파일이 senderr 폴더에서 senderrtemp 폴더로 이동됨<table style='border-collapse: separate; border-spacing: 1px; text-align: left; line-height: 1.5; border-top: 1px solid #ccc; margin: 5px 5px;'>");
                sb.append("<tr><th scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc;'>파일명</th><td style='width: 550px; padding: 10px; vertical-align: top; border-bottom: 1px solid #ccc;'>" + arr3[0] + "</td></tr>");
                sb.append("<tr><th scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc;'>송신기관명</th><td style='width: 550px; padding: 10px; vertical-align: top; border-bottom: 1px solid #ccc;'>" + arr3[1] + "</td></tr>");
                sb.append("<tr><th scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc;'>수신기관코드</th><td style='width: 550px; padding: 10px; vertical-align: top; border-bottom: 1px solid #ccc;'>" + arr3[2] + "</td></tr>");
                sb.append("<tr><th scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc;'>문서제목</th><td style='width: 550px; padding: 10px; vertical-align: top; border-bottom: 1px solid #ccc;'>" + arr3[3] + "</td></tr>");
                sb.append("<tr><th scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc;'>기안부서</th><td style='width: 550px; padding: 10px; vertical-align: top; border-bottom: 1px solid #ccc;'>" + arr3[4] + "</td></tr>");
                sb.append("<tr><th scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc;'>기안자</th><td style='width: 550px; padding: 10px; vertical-align: top; border-bottom: 1px solid #ccc;'>" + arr3[5] + "</td></tr>");
                sb.append("<tr><th scope='row' style='width: 150px; padding: 5px; font-weight: bold; vertical-align: top; border-bottom: 1px solid #ccc;'>송신시간</th><td style='width: 550px; padding: 10px; vertical-align: top; border-bottom: 1px solid #ccc;'>" + arr3[6] + "</td></tr>");
                sb.append("</table></td></tr>");
            }

            sb.append("</table></div>");
            sb.append("<div style='font-family: 'Malgun Gothic','Arial';'>자세한 내용은 아래 로그 폴더 참조<br />송신장애 :<br />중계모듈서버 > C:\relay\\logsender\\ 폴더의 해당날짜(yyyymmdd).log 파일 확인<br />수신장애 :<br />중계모듈서버 > C:\relay\\log\\\receiveerr\\ 폴더의 해당날짜(yyyymmdd).log 파일 확인</div>");
        }

        sb.append("</div>");

        body = sb.toString();
		return body;
	}

	private boolean WriteFileFromBase64(String strCont, String pFilePath, String fileName) {
		boolean result = false;
		strCont = strCont.replaceAll("\\r\\n|\\r|\\n","");
		byte[] content = Base64.getDecoder().decode(strCont);
		try {
			File dir = new File(commonUtil.detectPathTraversal(pFilePath));
			
			if (!dir.exists()) {
				dir.mkdirs();
			}
			
			// CWE-404 보안 취약점 대응
	        try (FileOutputStream fos = new FileOutputStream(commonUtil.detectPathTraversal(pFilePath + commonUtil.separator + fileName))) {
				fos.write(content);
			}

	        result = true;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = false;
		}
		return result;
	}

	//xml 재보정 작업
	private void pubdocUpdate(String pXmlPath) {
		 boolean Step1 = false;
		 boolean Step2 = false;
		 boolean Step3 = false;
		 
		 try {
             if (!TryXMLLoad(pXmlPath)) {
                 //STEP.1 XML Load 오류 처리 -> ':' -> '-' 
                 Step1 = ReplaceFileText(pXmlPath, "xml:stylesheet", "xml-stylesheet", false, "");
                 logger.debug("#XML보정.1:" + Step1);
             }

             if (!TryXMLLoad(pXmlPath)) {
                 //STEP.2 XML Load 오류 처리 -> '&' -> '&amp;' 
                 Step2 = ReplaceFileText(pXmlPath, "&", "$&amp;", true, "\\w&(?!amp;)+(?!gt;)+(?!lt;)+(?!nbsp;)+(?!&quot;)");
                 logger.debug("#XML보정.2:" + Step2);
             }

             if (!TryXMLLoad(pXmlPath)) {
                 //STEP.2 XML Load 오류 처리 -> '<br>' -> '<br/>' 
                 Step3 = ReplaceFileText(pXmlPath, "<br>", "<br/>", false, "");
                 logger.debug("#XML보정.3:" + Step3);
             }

         } catch (Exception ex) {
        	 logger.error(ex.getMessage(), ex);
             logger.debug("ezReceiverMain", "pubdocUpdate", ex.getMessage());
         }
	}

	private boolean ReplaceFileText(String strFilePath, String pTargetText,	String pNewText, boolean pUseRegex, String pRegexPattern) throws Exception {

		// 2023-05-31 이사라 : 시큐어코딩 리소스 close
		try (FileInputStream fis = new FileInputStream(new File(commonUtil.detectPathTraversal(strFilePath)))){

			InputStreamReader isr = new InputStreamReader(fis, "UTF-8");
			String text = "";

			// CWE-404 보안 취약점 대응
			try (BufferedReader br = new BufferedReader(isr)) {
				while (true) {
					if (br.readLine() == null)
						break;
					text += br.readLine();
				}
			}
			try {
				if (pUseRegex) {
					Pattern pattern = Pattern.compile(pRegexPattern);
					Matcher matcher = pattern.matcher(text);

					text = matcher.replaceAll(pNewText);
				} else {
					text = text.replace(pTargetText, pNewText);
				}

				File file = new File(commonUtil.detectPathTraversal(strFilePath));
				// CWE-404 보안 취약점 대응
				try (FileOutputStream fop = new FileOutputStream(file)) {
					// get the content in bytes
					fop.write(text.getBytes("UTF-8"));
					fop.flush();
				}

				return true;
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				return false;
			}
		}
		
	}

	private boolean WriteXMLFileFromBase64(String strCont, String pFilePath, String fileName) throws UnsupportedEncodingException {
		boolean result = false;
		
		String content = base64Decode(strCont);
		try {
			content = content.replace("xml:stylesheet", "xml-stylesheet");
			String replaceStr = content.substring(content.indexOf("<title"), content.indexOf("</title>") + "</title>".length());
			
			replaceStr = "<title>" + replaceStr.replace("<title>", "").replace("</title>", "").replace("<", "&lt").replace(">", "&gt") + "</title>";
			Pattern pattern = Pattern.compile("<title.*?>(.*?)</title>");
			Matcher matcher = pattern.matcher(content);
			
			content = matcher.replaceAll(replaceStr);
			
			File dir = new File( commonUtil.detectPathTraversal(pFilePath));
			
			if (!dir.exists()) {
				dir.mkdirs();
			}
			
			File file = new File(commonUtil.detectPathTraversal(pFilePath + commonUtil.separator + fileName));
			// CWE-404 보안 취약점 대응
			try (FileOutputStream fop = new FileOutputStream(file)) {
				// get the content in bytes
				fop.write(content.getBytes("EUC-KR"));
				fop.flush();
			}

			result = true;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = false;
		}
		return result;
	}

	private boolean ValidateDateTimeString(String strRecDate) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (strRecDate == null) {
			return false;
		}
		
		String format = null;
		try {
		   format = sdf.format(sdf.parse(strRecDate));
		} catch (ParseException e) {
		   logger.error(e.getMessage(), e);
		}
		  return strRecDate.equals(format);
	}

	private String TryXMLLoadWithReturnMessage(String strFilePath) {
		String result = "";
		try {
	       	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
//	       	factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
			factory.setValidating(false);
			factory.setNamespaceAware(true);
			
			DocumentBuilder builder = factory.newDocumentBuilder();
			
			// the "parse" method also validates XML, will throw an exception if misformatted
	    	builder.parse(new InputSource(strFilePath));
	    	
	    	result = "OK";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = e.getMessage();
		}
		return result;
	}
	
	private boolean TryXMLLoad(String pDocPath) throws Exception {
		boolean result = false;
		try {
	       	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
//	       	factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
			factory.setValidating(false);
			factory.setNamespaceAware(true);
	
			DocumentBuilder builder = factory.newDocumentBuilder();
	
			// the "parse" method also validates XML, will throw an exception if misformatted
	    	builder.parse(new InputSource(pDocPath));
	    	
	    	result = true;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = false;
		}
		
		return result;
	}

	private boolean CheckXMLElements(String pDocPath) {
			boolean result = false;
            try {
            	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
//            	factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
        		factory.setValidating(false);
        		factory.setNamespaceAware(true);
        		DocumentBuilder builder = factory.newDocumentBuilder();
        		
        		// the "parse" method also validates XML, will throw an exception if misformatted
            	Document xmlDoc = builder.parse(new InputSource(pDocPath));
            	
                if (xmlDoc.getElementsByTagName("pack") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("header") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("send-orgcode") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("send-id") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("send-name") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("receive-id") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("date") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("title") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("doc-id") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("doc-type") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("send-gw") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("dtd-version") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("xsl-version") != null)
                    result = true;
                if (xmlDoc.getElementsByTagName("contents") != null) {
                    result = true;
                    if (xmlDoc.getElementsByTagName("content") != null) {
                        result = true;
                        if (xmlDoc.getElementsByTagName("content").item(0).getAttributes().getNamedItem("content-role") != null) {
                            if (xmlDoc.getElementsByTagName("content").item(0).getAttributes().getNamedItem("content-role").getTextContent().equals("pubdoc") ||
                            		xmlDoc.getElementsByTagName("content").item(0).getAttributes().getNamedItem("content-role").getTextContent().equals("attach") ||
                            				xmlDoc.getElementsByTagName("content").item(0).getAttributes().getNamedItem("content-role").getTextContent().equals("attach_body") ||
                            						xmlDoc.getElementsByTagName("content").item(0).getAttributes().getNamedItem("content-role").getTextContent().equals("seal") ||
                            								xmlDoc.getElementsByTagName("content").item(0).getAttributes().getNamedItem("content-role").getTextContent().equals("gpki") ||
                            										xmlDoc.getElementsByTagName("content").item(0).getAttributes().getNamedItem("content-role").getTextContent().equals("fail") ||
                            												xmlDoc.getElementsByTagName("content").item(0).getAttributes().getNamedItem("content-role").getTextContent().equals("sign") ||
                                		xmlDoc.getElementsByTagName("content").item(0).getAttributes().getNamedItem("content-role").getTextContent().equals("symbol") ||
                                				xmlDoc.getElementsByTagName("pack/contents/content").item(0).getAttributes().getNamedItem("content-role").getTextContent().equals("logo")) {
                                result = true;
                            } else  {
                                result = false;
                            }
                        } else {
                            result = false;
                        }
                    }
                }

                xmlDoc = null;
            }
            catch (Exception ex)
            {
            	result = false;
            	logger.error(ex.getMessage(), ex);
            }
            return result;
	}
	
    protected String MakeDNString(String pOrgString) {
        try {
            return pOrgString.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("%", "");
        }
        catch (Exception Ex){
        	logger.error(Ex.getMessage(), Ex);
            return null;
        }
    }
    
    //XML은 문제 없지만, 그룹웨어 DB에 데이터 넣을 때 에러가 발생하는 파일은 백업해둔다.
    private void backupErrorXml(String relayPath, File errorfile) {
    	String backupPath = relayPath + commonUtil.separator  + "data" + commonUtil.separator + "receiveerr" + commonUtil.separator + "temp";
    	String strBackupFile = backupPath + commonUtil.separator + errorfile.getName(); 
    	File backupDir = new File(backupPath);
    	if(!backupDir.isDirectory()) {
    		backupDir.mkdirs();
    	}
    	
    	try {
    		FileUtils.moveFile(errorfile, new File(strBackupFile));
    	} catch (IOException e) {
    		logger.error(e.getMessage(), e);
    	}
    }
        
    //수신대상파일 처리
    public void receiveTempFile(ApprGRelayXMLVO relayXML) throws Exception {


        File receiveTempFile = new File(relayXML.getFilePath());

        String strTitle = "";
        String strXDocID = "";
        String strDocType = "";
        String strWriterName = "";
        String strWriterDept = "";
        String strSendName = "";
        String strXGW = "";
        String strXDTDVersion = "";
        String strXSLVersion = "";
        String strRecDate = "";
        String strFileName = receiveTempFile.getName();

        strTitle = relayXML.getTitle();

        logger.debug("#문서제목=" + strTitle);
        strXDocID = relayXML.getxDocID();
        logger.debug("#문서고유번호=" + strXDocID);
        strDocType = relayXML.getDocType();
        logger.debug("#문서종류=" + strDocType);
        strWriterName = relayXML.getWriterName();

        logger.debug("#문서작성자이름=" + strWriterName);
        strWriterDept = relayXML.getWriterDept();

        logger.debug("#문서작성자부서=" + strWriterDept);
        strSendName = relayXML.getSendName();
        logger.debug("#송신기관명=" + strSendName);
        strXGW = relayXML.getxGW();
        logger.debug("#송신그룹웨어명=" + strXGW);
        strXDTDVersion = relayXML.getdTDVersion();
        logger.debug("#DTD버전=" + strXDTDVersion);
        strXSLVersion = relayXML.getxSLVersion();
        logger.debug("#XSL버전=" + strXSLVersion);

        strRecDate = relayXML.getRecDate();

        logger.debug("#날짜=" + strRecDate);

        //분기에 따른 구분 분리
        switchByDocType(relayXML);

        //receiveComp 파일 처리
        excuteDiFile(relayXML.getRelayFolderPath(), strFileName, receiveTempFile);

        logger.debug("=============================================>수신종료.", "");

    }

    //문서 타입에 따른 분기
    public void switchByDocType(ApprGRelayXMLVO relayXML) throws Exception {

        String strSendID = relayXML.getSendID();

        switch (relayXML.getDocType().trim()) {
            case "send":
                sendType(relayXML);
                break;
            case "resend":
                //재전송에 따른 처리
                resendType(relayXML);
                break;
            // 발송 실패에 따른 메시지 Update
            case "fail":
                String Message = relayXML.getMessage();
                boolean UpdateSendDoc_Fail = ezApprovalGService.updateRelaySusinState(relayXML.getxDocID(), relayXML.getRecDate(), relayXML.getDocType(), strSendID, "", relayXML.getCompanyID(), relayXML.getTenantID());
//        					 boolean InsMessage = ezApprovalGService.insFailMessage(strXDocID, strSendID, strSendName, Message, strCompanyID, tenantID);
                logger.debug("#발송실패오류=" + Message, "");
                logger.debug("#발송문서실패=" + UpdateSendDoc_Fail, "");
                break;
            // 도달 - 수신기관의 중계모듈이 전송용 통합파일을 임시수신함(receivetemp)에 저장한 후 생성
            case "arrive":
                boolean UpdateSendDoc_Arrive = ezApprovalGService.updateRelaySusinState(relayXML.getxDocID(), relayXML.getRecDate(), relayXML.getDocType(), strSendID, "", relayXML.getCompanyID(), relayXML.getTenantID());
                logger.debug("#발송문서도달=" + UpdateSendDoc_Arrive);
                break;
            // 수신 - 수신기관의 전자문서시스템이 중계모듈의 임시수신함(receivetemp)에 수신된 문서를 가져가는 작업 완료 후 생성
            case "receive":
                boolean UpdateSendDoc_Receive = ezApprovalGService.updateRelaySusinState(relayXML.getxDocID(), relayXML.getRecDate(), relayXML.getDocType(), strSendID, "", relayXML.getCompanyID(), relayXML.getTenantID());
                logger.debug("#발송문서수신=" + UpdateSendDoc_Receive);
                break;
            // 접수 - 수신기관에서 문서를 정상적으로 최초 확인
            case "accept":
                String strAcceptName = relayXML.getAcceptName();
                boolean UpdateSendDoc_Accept = ezApprovalGService.updateRelaySusinState(relayXML.getxDocID(), relayXML.getRecDate(), relayXML.getDocType(), strSendID, strAcceptName, relayXML.getCompanyID(), relayXML.getTenantID());
                logger.debug("#발송문서접수=" + UpdateSendDoc_Accept);

                break;
            // 발송 문서에 대한 수신 기관 접수 부서 및 접수자 Update
            case "return":
                //기존 표준에도 정의되어 있었으나 실제로 사용되지 않았고, 업무관리시스템에서 재정의하여 사용함(정부전자문서유통_표준(고시)유통모듈 상태값 확인.hwp 에서)
            case "req-resend":
                //재발송 요청에 따른 처리
                reqResendType(relayXML);
                break;
        }

    }

    //전송
    public void sendType(ApprGRelayXMLVO relayXML) throws Exception {

        boolean bRet;
        boolean bGPKI;
        String strCont_Role = "";
        String strCont = "";
        @SuppressWarnings("unused")
		String strCont_Name = "";

        bRet = ezApprovalGService.insertRelayDB("", relayXML.getxDocID(), relayXML.getRecDate(), relayXML.getSendName(), relayXML.getReceiveID(), relayXML.getTitle(), "", relayXML.getSendID(), relayXML.getReceiveID(), relayXML.getxGW(), relayXML.getDocType(), relayXML.getdTDVersion(), relayXML.getxSLVersion(), "", "", "", relayXML.getFileDate(), relayXML.getCompanyID(), relayXML.getTenantID());
        logger.debug("#중계문서정보생성=" + bRet, "");

        bGPKI = false;

        if (relayXML.getContLength() == 1) {
            strCont_Role = relayXML.getContRole(0);
            if (strCont_Role.equals("gpki")) {
                bGPKI = true;
            }
        }

        if (bGPKI) {
            // 암호화된 경우 해당 XML 파일을 특정 폴더로 저장한다.
            File gpkFile = new File(commonUtil.detectPathTraversal(relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "exDocMSG" + commonUtil.separator + relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getReceiveID() + ".xml"));

            if (gpkFile.exists()) {
                gpkFile.delete();
            }

			// CWE-404 보안 취약점 대응
            try (FileOutputStream fop = new FileOutputStream(gpkFile)) {
				// get the content in bytes
				fop.write(commonUtil.convertDocumentToString(relayXML.getXmlDoc()).getBytes("UTF-8"));
				fop.flush();
			}

            ezApprovalGService.fieldUpdate("emlURL", relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getReceiveID() + ".xml", relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getCompanyID(), relayXML.getTenantID());
            ezApprovalGService.fieldUpdate("isPKI", "Y", relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getCompanyID(), relayXML.getTenantID());
        } else {
            File recFile = new File(commonUtil.detectPathTraversal(relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator +"exDocMSG" + commonUtil.separator + relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getReceiveID() + ".xml"));

            File recDir = new File(commonUtil.detectPathTraversal(relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator +"exDocMSG"));

            if (!recDir.exists()) {
                recDir.mkdirs();
            }

            if (recFile.exists()) {
                recFile.delete();
            }

			// CWE-404 보안 취약점 대응
            try (FileOutputStream fop = new FileOutputStream(recFile)) {
				// get the content in bytes
				fop.write(commonUtil.convertDocumentToString(relayXML.getXmlDoc()).getBytes("UTF-8"));
				fop.flush();
			}

            logger.debug("#pack파일생성= OK");

            ezApprovalGService.fieldUpdate("emlURL", relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getReceiveID() + ".xml", relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getCompanyID(), relayXML.getTenantID());
            ezApprovalGService.fieldUpdate("isPKI", "N", relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getCompanyID(), relayXML.getTenantID());

            for (int count = 0; count < relayXML.getContLength(); count++) {
                strCont_Role = relayXML.getContRole(count);
                strCont = relayXML.getCont(count);
                strCont_Name = relayXML.getContName(count);
                strCont = strCont.replace("\r", "").replace("\n", "").replace("\t", "");

                //strCont_Role 타입에 따른 구분
                sendContRoleType(relayXML, count);

            }
        }

        //결재진행문서 정보에 수신문서 정보를 입력해 준다.
        boolean inputReceiveInfo = ezApprovalGService.createRelayDocInfo(relayXML.getWriterName(), relayXML.getWriterDept(), commonUtil.getRealPath(servletContext), relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getCompanyID(), relayXML.getTenantID());
        logger.debug("#수신문서정보입력=" + inputReceiveInfo);

        //수신된 유통문서에 대해 수신(Receive) ACK 발송
        boolean SendReceiveACK = ezApprovalGService.sendAck(relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getSendID(), relayXML.getTitle(), "receive", "", "", "", relayXML.getCompanyID(), relayXML.getTenantID());
        logger.debug("#수신ACK발송=" + SendReceiveACK);

    }

    //재전송
    public void resendType(ApprGRelayXMLVO relayXML) throws Exception {
        boolean bRet;
        boolean bGPKI;
        String strCont_Role = "";
        String strCont = "";
        @SuppressWarnings("unused")
		String strCont_Name = "";

        bRet = ezApprovalGService.insertRelayDB("", relayXML.getxDocID(), relayXML.getRecDate(), relayXML.getSendName(), relayXML.getReceiveID(), relayXML.getTitle(), "", relayXML.getSendID(), relayXML.getReceiveID(), relayXML.getxGW(), relayXML.getDocType(), relayXML.getdTDVersion(), relayXML.getxSLVersion(), "", "", "", relayXML.getFileDate(), relayXML.getCompanyID(), relayXML.getTenantID());
        logger.debug("#중계문서정보생성=" + bRet, "");

        bGPKI = false;

        if (relayXML.getContLength() == 1) {
            strCont_Role = relayXML.getContRole(0);
            if (strCont_Role.equals("gpki")) {
                bGPKI = true;
            }
        }

        if (bGPKI) {
            // 암호화된 경우 해당 XML 파일을 특정 폴더로 저장한다.
            File gpkFile = new File(commonUtil.detectPathTraversal(relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "exDocMSG" + commonUtil.separator + relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getReceiveID() + ".xml"));

            if (gpkFile.exists()) {
                gpkFile.delete();
            }

			// CWE-404 보안 취약점 대응
            try (FileOutputStream fop = new FileOutputStream(gpkFile)) {
				// get the content in bytes
				fop.write(commonUtil.convertDocumentToString(relayXML.getXmlDoc()).getBytes("UTF-8"));
				fop.flush();
			}

            ezApprovalGService.fieldUpdate("emlURL", relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getReceiveID() + ".xml", relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getCompanyID(), relayXML.getTenantID());
            ezApprovalGService.fieldUpdate("isPKI", "Y", relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getCompanyID(), relayXML.getTenantID());
        } else {
            File recFile = new File(commonUtil.detectPathTraversal(relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator +"exDocMSG" + commonUtil.separator + relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getReceiveID() + ".xml"));

            File recDir = new File(commonUtil.detectPathTraversal(relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator +"exDocMSG"));

            if (!recDir.exists()) {
                recDir.mkdirs();
            }

            if (recFile.exists()) {
                recFile.delete();
            }

			// CWE-404 보안 취약점 대응
            try (FileOutputStream fop = new FileOutputStream(recFile)) {
				// get the content in bytes
				fop.write(commonUtil.convertDocumentToString(relayXML.getXmlDoc()).getBytes("UTF-8"));
				fop.flush();
			}

            logger.debug("#pack파일생성= OK");

            ezApprovalGService.fieldUpdate("emlURL", relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getReceiveID() + ".xml", relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getCompanyID(), relayXML.getTenantID());
            ezApprovalGService.fieldUpdate("isPKI", "N", relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getCompanyID(), relayXML.getTenantID());

            for (int count = 0; count < relayXML.getContLength(); count++) {
                strCont_Role = relayXML.getContRole(count);
                strCont = relayXML.getCont(count);
                strCont_Name = relayXML.getContName(count);
                strCont = strCont.replace("\r", "").replace("\n", "").replace("\t", "");

                //strCont_Role 타입에 따른 구분
                sendContRoleType(relayXML, count);

            }
        }

        //결재진행문서 정보에 수신문서 정보를 입력해 준다.
        boolean inputReceiveInfo = ezApprovalGService.createRelayDocInfo(relayXML.getWriterName(), relayXML.getWriterDept(), commonUtil.getRealPath(servletContext), relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getCompanyID(), relayXML.getTenantID());
        logger.debug("#수신문서정보입력=" + inputReceiveInfo);

        //수신된 유통문서에 대해 수신(Receive) ACK 발송
        boolean SendReceiveACK = ezApprovalGService.sendAck(relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getSendID(), relayXML.getTitle(), "receive", "", "", "", relayXML.getCompanyID(), relayXML.getTenantID());
        logger.debug("#수신ACK발송=" + SendReceiveACK);

    }

    //전송시 cont_role에 따른 분기 처리
    public void sendContRoleType(ApprGRelayXMLVO relayXML, int count) throws Exception {

    	String contName = relayXML.getContName(count);
    	String rand = UUID.randomUUID().toString();
    	String fileName = rand + contName.substring(contName.lastIndexOf("."));
    	
        switch (relayXML.getContRole(count)) {
            case "pubdoc":
                boolean WritePubDoc = WriteXMLFileFromBase64(relayXML.getCont(count), relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "ExDocXML" , relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getReceiveID() + ".xml");

                logger.debug("#pubdoc생성=" + WritePubDoc);
                pubdocUpdate(relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "ExDocXML" + commonUtil.separator + relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getReceiveID() + ".xml");
                ezApprovalGService.fieldUpdate("xmlURL", relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getReceiveID() + ".xml", relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getCompanyID(), relayXML.getTenantID());
                break;
            case "attach":
//              boolean WriteAttache = WriteFileFromBase64(relayXML.getCont(count), relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "ExDocDown" , relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getContName(count));
          	// 정주환 파일명 길이제한으로 저장시 파일 count만 저장
              boolean WriteAttache = WriteFileFromBase64(relayXML.getCont(count), relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "ExDocDown" , relayXML.getxDocID().replace("/", "_").replace("#", "_") + count);
              logger.debug("#attach생성=" + WriteAttache);
//              ezApprovalGService.addAttachInfo(relayXML.getContName(count), relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getContName(count), relayXML.getxDocID(), Integer.toString(count), "N", relayXML.getCompanyID(), relayXML.getTenantID());
              ezApprovalGService.addAttachInfo(relayXML.getContName(count), relayXML.getxDocID().replace("/", "_").replace("#", "_") + count, relayXML.getxDocID(), Integer.toString(count), "N", relayXML.getCompanyID(), relayXML.getTenantID());
                break;
            case "attach_body":
                // 이 것 때문에 attach_body에서 오류남
        									 /* //콘텐트의 내용을 base64로 디코딩
        								 String tempString = new String(Base64.decodeBase64(objXML.getElementsByTagName("content").item(0).getTextContent()), "euc-kr" );
        								 //디코딩된 내용에 nbsp가 있으면 string 에서 xml로 변환되지 않음
        								 tempString = tempString.replaceAll("&nbsp;", "");
        								 //첫부분 3줄의 내용이 xml로 변환되는데 오류가 생김
        								 String[] tempStrLine = tempString.split("\\r?\\n", 4);

        								 //4번째부터의 내용을 xml로 변환
        								 Document tempXml = commonUtil.convertStringToDocument(tempStrLine[3]);*/

//        								 if ("true".equals(tempXml.getElementsByTagName("body").item(0).getAttributes().getNamedItem("separate").getTextContent())) {
                boolean WriteBodyAttach = WriteFileFromBase64(relayXML.getCont(count), relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "ExDocDown" , relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getContName(count));
                logger.debug("#attach_body생성=" + WriteBodyAttach);
                ezApprovalGService.addAttachInfo(relayXML.getContName(count), relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getContName(count), relayXML.getxDocID(), Integer.toString(count), "Y", relayXML.getCompanyID(), relayXML.getTenantID());
//        								 }
                break;
            case "attach_xml":
                boolean WriteXMLFile = WriteFileFromBase64(relayXML.getCont(count), relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "exch" , relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getContName(count));
                logger.debug("#attach_xml생성=" + WriteXMLFile, "");
                ezApprovalGService.addAttachInfo(relayXML.getContName(count), relayXML.getxDocID().replace("/", "_").replace("#", "_") + relayXML.getContName(count), relayXML.getxDocID(), Integer.toString(count), "XML", relayXML.getCompanyID(), relayXML.getTenantID());
                break;
            case "attach_xsl":
                boolean WriteXSLFile = WriteFileFromBase64(relayXML.getCont(count), relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "exch" , relayXML.getContName(count));
                logger.debug("#attach_xsl생성=" + WriteXSLFile, "");
                ezApprovalGService.addAttachInfo(relayXML.getContName(count), relayXML.getContName(count), relayXML.getxDocID(), Integer.toString(count), "XSL", relayXML.getCompanyID(), relayXML.getTenantID());
                break;
            case "seal":
            	boolean WriteSealFile = WriteFileFromBase64(relayXML.getCont(count), relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "ExDocSign" , fileName);
                logger.debug("#seal생성=" + WriteSealFile, "");
                ezApprovalGService.fieldUpdate("sealURL", fileName, relayXML.getxDocID(), relayXML.getReceiveID(), relayXML.getCompanyID(), relayXML.getTenantID());
                break;
            case "sign":
            	boolean WriteSignFile = WriteFileFromBase64(relayXML.getCont(count), relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "ExDocUserSign" ,  fileName);
                logger.debug("#sign생성=" + WriteSignFile, "");
                ezApprovalGService.addSignInfo(relayXML.getContName(count), fileName, relayXML.getxDocID(), relayXML.getCompanyID(), relayXML.getTenantID());
                break;
            case "logo":
            	boolean WritetLogoFile = WriteFileFromBase64(relayXML.getCont(count), relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "ExDocUserSign" ,  fileName);
                logger.debug("#logo생성=" + WritetLogoFile, "");
                ezApprovalGService.addSignInfo(relayXML.getContName(count), fileName, relayXML.getxDocID(), relayXML.getCompanyID(), relayXML.getTenantID());
                break;
            case "symbol":
            	boolean WriteSymbolFile = WriteFileFromBase64(relayXML.getCont(count), relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "ExDocUserSign" ,  fileName);
                logger.debug("#symbol생성=" + WriteSymbolFile, "");
                ezApprovalGService.addSignInfo(relayXML.getContName(count), fileName, relayXML.getxDocID(), relayXML.getCompanyID(), relayXML.getTenantID());
                break;
        }

    }

    //재전송 요청
    public void reqResendType(ApprGRelayXMLVO relayXML) throws Exception {

        boolean UpdateSendDoc_ReqResend = ezApprovalGService.updateRelaySusinState(relayXML.getxDocID(), relayXML.getRecDate(), relayXML.getDocType(), relayXML.getSendID(), "", relayXML.getCompanyID(), relayXML.getTenantID());
        logger.debug("#발송문서정보갱신=" + UpdateSendDoc_ReqResend);

        NodeList contentNodeList = relayXML.getContentList();

        if(contentNodeList != null && relayXML.getContLength() > 0) {

            //수신기관에서 재발송 요청시 의견 추가
            if (relayXML.getContRole(0) != null && relayXML.getContRole(0).equals("return")) {

                //인코딩 안풀고 그냥 저장
                boolean writeReqResendOpinion = writeReqResendOpinion(relayXML.getCont(0).replace("\r", "").replace("\n", "").replace("\t", ""), relayXML.getAprDocPath() + relayXML.getCompanyID() + commonUtil.separator + "ExOpinion", relayXML.getxDocID() + relayXML.getSendID() + "return.txt");
                logger.debug("#재발송요청 의견 생성=" + writeReqResendOpinion);
            }

        }

    }

    //외부 수신 파일 receiveComp로  이동 처리
    public void excuteDiFile(String strRelayFolderPath, String strFileName, File receiveTempFile) throws Exception {

        File di2 = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receiveComp"));

        if (di2.exists()) {
            File FI2 = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receiveComp" + commonUtil.separator + strFileName));
            if (FI2.exists()) {
                receiveTempFile.delete();
            } else {
                File fileMove = new File(commonUtil.detectPathTraversal(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receiveComp" + commonUtil.separator + strFileName));
                receiveTempFile.renameTo(fileMove);
            }
        } else {
            receiveTempFile.delete();
        }

    }

    //해당 경로의 xml 파일의 속성을 수정
    public void updateXmlAttr(String pXmlPath) {

        System.out.println("pXmlPath: " + pXmlPath);

        try {

            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setValidating(true);

            DocumentBuilder builder = factory.newDocumentBuilder();
            Document xmlDoc = builder.parse(new InputSource(pXmlPath));


            //body 에 separate="false" 라는 요소가 들어 있어서 이를 제거하는 기능을 추
            Element element = (Element) xmlDoc.getElementsByTagName("body").item(0);

            System.out.println("element.hasAttribute(\"separate\"): " + element.hasAttribute("separate"));
            System.out.println("element.getAttribute(\"separate\"): " + element.getAttribute("separate"));

            element.removeAttribute("separate");

            System.out.println("element.hasAttribute(\"separate\"): " + element.hasAttribute("separate"));
            System.out.println("element.getAttribute(\"separate\"): " + element.getAttribute("separate"));

            //삭제의 경우 별도의 document를 생성해서 처
            Element root = xmlDoc.getDocumentElement();
            Document newDom = builder.newDocument();
            ProcessingInstruction pi = newDom.createProcessingInstruction("xml-stylesheet", "type=\"text/xsl\" href=\"siheng.xsl\"");
            Node importStyle = newDom.importNode(pi, true);
            Node importNode = newDom.importNode(root, true);
            newDom.appendChild(importStyle);
            newDom.appendChild(importNode);

            //standalone="no" 삭제
            newDom.setXmlStandalone(true);
            //String pubdocDTDPath = pXmlPath.substring(0, pXmlPath.lastIndexOf("/")) + commonUtil.separator + "pubdoc.dtd";
            //dtd 경로
            String pubdocDTDPath = "pubdoc.dtd";
            System.out.println("pubdocDTDPath: " + pubdocDTDPath);

            //xml 생성 및 파일 교체
            Transformer transformer = TransformerFactory.newInstance().newTransformer();
            //인코딩
            transformer.setOutputProperty(OutputKeys.ENCODING,"EUC-KR");
            //doctype 추가
            transformer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM,pubdocDTDPath);
            //whitespace 허용여부
            transformer.setOutputProperty(OutputKeys.INDENT,"YES");
            File xmlFile = new File(pXmlPath);
            DOMSource ds = new DOMSource(newDom);
            transformer.transform(ds, new StreamResult(new FileOutputStream(xmlFile)));

            System.out.println("separate prop remove result: " + xmlFile.toString());

        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            logger.debug("ezReceiverMain", "updateXmlAttr", ex.getMessage());
            System.out.println("ezReceiverMain updateXmlAttr" + ex.getMessage());
        }

    }

    public ApprGRelayConfigVO relayConfig() {
    	
    	ApprGRelayConfigVO resultVO = null;
    	
 		try {
 		 
 			//저장된 tenantID들 중에서 첫번째를 조회
 			List<OrganUserVO> list;
 	
 			// 2023-05-11 이사라 : NullPointerException 시큐어코딩
 			list = Optional.ofNullable(ezApprovalGService.getTenantID()).orElse(Collections.emptyList());
 			int tenantID = list.get(0).getTenantId();
 				 			
 			String strCompanyID = config.getProperty("config.companyNum");
				
 			String configRelayRoot = commonUtil.getRealPath(servletContext);
 			String configRelaySchedulerTenant = config.getProperty("RelaySchedulerTenant");
 			String configUloadRelayRoot = config.getProperty("upload_relay.ROOT").trim();
 			String separator = commonUtil.separator;
 			
 			//RelaySchedulerTenant가 빈값이 아니라면 tenantID에 할당
 			//if(!(configRelaySchedulerTenant == null || configRelaySchedulerTenant.equals(""))) {
 			if(StringUtils.isNotBlank(configRelaySchedulerTenant)) {
 				 tenantID = Integer.parseInt(configRelaySchedulerTenant);
 			}
 			
 			String relayUploadPath = commonUtil.getUploadPath("upload_relay.R_DocPath", tenantID).trim();
 			
 			resultVO = new ApprGRelayConfigVO(configRelayRoot, configUloadRelayRoot, relayUploadPath, tenantID, separator);
 			
 		    String configReceiveerrMove = config.getProperty("USE_RECEIVEERR_FILE_MOVE_RECEIVETEMP");
 		    
 		    String configMailNoti = config.getProperty("USE_EMAIL_NOTIFICATION");

 		    resultVO.setStrCompanyID(strCompanyID);
 		    resultVO.setConfigReceiveerrMove(configReceiveerrMove);
 		    resultVO.setConfigMailNoti(configMailNoti);
 		    
 		} catch (Exception e) {
             logger.debug("e.getMessage(): " + e.getMessage());
             logger.debug("e.getStackTrace(): " + e.getStackTrace());
 		}
 		
 		String result = resultVO != null ?  resultVO.toString() : null;
 		
 		logger.debug("resultVO: " + result);
    	return resultVO;
    }
    
	@Scheduled(cron = "0 0/1 * * * *")
    public void receiverMain() throws Exception{
		if (config.getProperty("config.Run_RelayScheduler").equals("NO")) {
			return;
		}
		
		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("receiverMain")) {
			logger.debug("receiverMain scheduler ended.");
			return;
		}
		
		logger.debug("receiverSchedulerMain Started");

		ApprGRelayConfigVO configVO = relayConfig();

		logger.debug("pathVO = " + configVO.toString());

		// receiveerr 폴더에 쌓인 XML 파일들을 접수 처리 한다.
		if (configVO.getConfigReceiveerrMove().equals("YES")) {
			File dirFile = new File(commonUtil.detectPathTraversal(configVO.getReceiveerrPath()));

			logger.debug("receiveerrPath = " + configVO.getReceiveerrPath());

			if (dirFile.exists()) {
				for (File tempFile : dirFile.listFiles()) {
					if (tempFile.isFile()) {
						// receiveerr 폴더의 파일들을 수신처리 하기위해, ReceiveTemp로 이동 한다.
						String errorfilename = tempFile.getName();
						String errorfilepath = tempFile.getPath();
						String errorfileextension = FilenameUtils.getExtension(errorfilename);

						logger.debug("errorfilename = " + errorfilename);
						logger.debug("errorfilepath = " + errorfilepath);
						logger.debug("errorfileextension = " + errorfileextension);

						if (errorfileextension.toLowerCase().equals("xml")) {
							File receiveTemp = new File(
									commonUtil.detectPathTraversal(configVO.getReceivetempPath(errorfilename)));
							File receiveComp = new File(
									commonUtil.detectPathTraversal(configVO.getReceiveCompPath(errorfilename)));
							File receive = new File(
									commonUtil.detectPathTraversal(configVO.getReceivePath(errorfilename)));

							logger.debug("receiveTemp = " + configVO.getReceivetempPath(errorfilename));
							logger.debug("receiveComp = " + configVO.getReceiveCompPath(errorfilename));
							logger.debug("receive = " + configVO.getReceivePath(errorfilename));

							boolean checkresult = CheckXMLElements(errorfilepath);
							boolean XMLLoadTest = TryXMLLoad(errorfilepath);

							if (!receiveTemp.exists() && !receiveComp.exists() && !receive.exists()) {
								if (XMLLoadTest && checkresult) {

									ApprGRelayXMLVO receiveErrXML = new ApprGRelayXMLVO(errorfilepath);

									String[] receiveerrFileInfo = new String[5];
									// receiveerr 폴더의 XML 파일명
									receiveerrFileInfo[0] = errorfilename;
									// 송신기관명
									receiveerrFileInfo[1] = receiveErrXML.getSendName();
									// 수신기관코드
									receiveerrFileInfo[2] = receiveErrXML.getReceiveID();
									// 문서제목
									receiveerrFileInfo[3] = receiveErrXML.getEscapeTitle();
									// 송신일자
									receiveerrFileInfo[4] = receiveErrXML.getRecDate();

									configVO.addReceiveerrList(receiveerrFileInfo);

									receiveerrFileInfo = null;
									File fileMove = new File(commonUtil.detectPathTraversal(configVO.getReceivetempPath(errorfilename)));
									FileUtils.moveFile(tempFile, fileMove);
								}
							}
							receiveTemp = null;
							receiveComp = null;
							receive = null;
						}
					}
				}
			}

			if (configVO.getConfigMailNoti().equals("YES")) {
				if (configVO.getReceiveerrList().size() > 0) {
					configVO.addAdminMail(configVO.getReceiveerrList());
				}
			}
			dirFile = null;
		}

		System.out.println("configVO: " + configVO.toString());

		// receivetemp 폴더에 쌓인 전송용통합파일(pack.xml)을 풀어 수신처리 한다.
		File receiveDir = new File(commonUtil.detectPathTraversal(configVO.getReceivetempPath()));

		logger.debug("receiveDir = " + configVO.getReceivetempPath());

		if (receiveDir.exists()) {
			for (File receiveTempFile : receiveDir.listFiles()) {
				try {
					String strFileName = receiveTempFile.getName();
					String strFilePath = receiveTempFile.getPath();
					String strFileType = FilenameUtils.getExtension(strFileName);

					if (strFileType.toLowerCase().equals("xml")) {
						logger.debug("receiveFile Started");
						logger.debug("receiveFileName : " + strFileName + " receiveFilePath : " + strFilePath
								+ " receiveFileType : " + strFileType);
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

						// 파일생성일
						String strFileDate = sdf.format(receiveTempFile.lastModified()).toString();
						// 수신기관아이디
						String strReceiveID = strFileName.substring(7, 14);

						if (!TryXMLLoad(strFilePath)) {
							String[] xmlParsingErrInfo = new String[2];
							xmlParsingErrInfo[0] = strFileName;
							xmlParsingErrInfo[1] = TryXMLLoadWithReturnMessage(strFilePath);
							configVO.addXmlparsingerrList(xmlParsingErrInfo);
							configVO.addAdminMail(configVO.getXmlparsingerrList());

							File receiveTemp = new File(
									commonUtil.detectPathTraversal(configVO.getReceivetemperrPath()));

							if (!receiveTemp.exists()) {
								receiveTemp.mkdirs();
							}

							File fileMove = new File(commonUtil.detectPathTraversal(configVO.getReceivetemperrPath(strFileName)));
							FileUtils.moveFile(receiveDir, fileMove);

							logger.debug("비정상적인 XML파일, 수신처리 할 수 없습니다.");
							logger.debug("파일을 receivetemperr 폴더로 이동 하였습니다.");
							logger.debug("=============================================>수신종료.");

							continue;
						}

						ApprGRelayXMLVO relayXML = new ApprGRelayXMLVO(strFilePath);

						// 송신기관코드
						String strSendOrgCode = relayXML.getSendOrgCode();
						logger.debug("#송신기관코드=" + strSendOrgCode);

						// 송신부서코드
						String strSendID = relayXML.getSendID();
						logger.debug("#송신부서코드=" + strSendID);

						// 수신기관코드가 회사ID랑 다를 경우 회사ID로 맞추어 준다.(보정처리)
						boolean RecvIDCheck = false;
						List<OrganDeptVO> extensionAttr4ID = ezOrganService.getExtensionAttr4ID(strReceiveID);
						int listSize = extensionAttr4ID.size();

						if (listSize > 0) {
							for (int m = 0; m < listSize; m++) {
								configVO.setStrCompanyID(extensionAttr4ID.get(m).getExtensionAttribute2());
							}
						}

						if (listSize > 0) {
							for (int m = 0; m < listSize; m++) {
								if (strReceiveID.trim().equals(extensionAttr4ID.get(m).getExtensionAttribute4())) {
									strReceiveID = extensionAttr4ID.get(m).getCn();
									RecvIDCheck = true;
									break;
								}
							}
						} else {
							if (!configVO.getStrCompanyID().trim().equals("")) {
								if (!strReceiveID.trim().equals(configVO.getStrCompanyID().trim())) {
									strReceiveID = configVO.getStrCompanyID().trim();
								}
								RecvIDCheck = true;
							}
						}

						relayXML.setReceiveID(strReceiveID);
						relayXML.setCompanyID(configVO.getStrCompanyID());
						relayXML.setTenantID(configVO.getTenantID());
						relayXML.setAprDocPath(configVO.getStrAprDocPath());
						relayXML.setFileDate(strFileDate);
						relayXML.setRelayFolderPath(configVO.getStrRelayFolderPath());

						if (RecvIDCheck) {

							// 대상 파일 이동 처리
							receiveTempFile(relayXML);

						} else {
							logger.debug("#수신부서코드=" + strReceiveID + " 해당 수신기관코드가 존재하지 않습니다.");
						}
					}

				} catch (Exception e) {
					logger.debug("#대외문서 접수 중 에러. 파일명 = " + receiveTempFile.getName());
					backupErrorXml(configVO.getStrRelayFolderPath(), receiveTempFile);
					logger.error(e.getMessage(), e);
					continue;
				}
			}
		}

		// senderr 폴더에 쌓인 XML 파일들을 접수 처리 한다.
		File senderr = new File(commonUtil.detectPathTraversal(configVO.getSenderrPath()));
		File[] fileList = senderr.listFiles();

		logger.debug("senderrPath = " + configVO.getSenderrPath());

		if (fileList != null) {
			for (File tempFile : fileList) {

				String errorfilename = tempFile.getName();
				String errorfilepath = tempFile.getPath();
				String errorfileextension = FilenameUtils.getExtension(errorfilename);

				logger.debug("errorfilename = " + errorfilename);
				logger.debug("errorfilepath = " + errorfilepath);
				logger.debug("errorfileextension = " + errorfileextension);

				if (errorfileextension.toLowerCase().equals("xml")) {
					String[] senderrInfo = new String[7];

					ApprGRelayXMLVO sendErrXML = new ApprGRelayXMLVO(errorfilepath);

					// receiveerr 폴더의 XML 파일명
					senderrInfo[0] = errorfilename;
					// 송신기관명
					senderrInfo[1] = sendErrXML.getSendName();
					// 수신기관코드
					senderrInfo[2] = sendErrXML.getReceiveID();
					// 문서제목
					senderrInfo[3] = sendErrXML.getEscapeTitle();
					// 부서명
					senderrInfo[4] = sendErrXML.getEscapeDept();
					// 사용자명
					senderrInfo[5] = sendErrXML.getEscapeName();
					// 송신일자
					senderrInfo[6] = sendErrXML.getRecDate();

					configVO.addSenderrList(senderrInfo);

					File dir3 = new File(commonUtil.detectPathTraversal(configVO.getSenderrtempPath()));
					if (!dir3.exists()) {
						dir3.mkdirs();
					}
					File fileMove = new File(commonUtil.detectPathTraversal(configVO.getSenderrtempPath(errorfilename)));

					dir3.renameTo(fileMove);
				}
			}
		}
		if (configVO.getConfigMailNoti().equals("YES")) {
			if (configVO.getSenderrList().size() > 0) {
				configVO.addAdminMail(configVO.getSenderrList());
			}
		}
		senderr = null;

		System.out.println("configVO: " + configVO.toString());

		//발송현황 업데이트
		Map<String, Object> sendOutMap = new HashMap<String, Object>();
		sendOutMap.put("V_DATABASE", "jmocha");
		sendOutMap.put("V_TABLE", "TBL_SENDOUTINFO");
		int checkSendOutTable = ezApprovalGAdminDao.checkSendOutInfoTable(sendOutMap);
		
		if(checkSendOutTable > 0) {
			updateSendOutState();
		}
		
		 logger.debug("receiverSchedulerMain ended");
	}
    
	public void updateSendOutState() throws Exception {
		 logger.debug("updateSendOutState started");
		
			boolean sendExist;
			boolean sendtempExist;
			boolean senderrExist;
			boolean senderrtempExist;
			
			Map<String, Object> sendOutMap = new HashMap<String, Object>();
			sendOutMap.put("V_FILESTATE", "success");
			
			//발송 대상 중에서 정상적으로 파일이 생성된 대상의 리스트를 조회
			List<Map<String, Object>> sendOutInfoList = ezApprovalGAdminDao.selectSendOutInfoList(sendOutMap);
			
			logger.debug(sendOutInfoList.toString());
			
			//그룹웨에서 문서유통 모듈의 data 폴더에 접근하는 경로 생성
			String configRelayRoot = commonUtil.getRealPath(servletContext).trim();
			int configRelaySchedulerTenant = 0;
			String configUloadRelayRoot = config.getProperty("upload_relay.ROOT").trim();
			String strRelayFolderPath = configRelayRoot + commonUtil.separator + "fileroot" + commonUtil.separator + configRelaySchedulerTenant + commonUtil.separator + "files" + configUloadRelayRoot;
			 
			logger.debug("relay config path: " + configRelayRoot + " " + configRelaySchedulerTenant + " " + configUloadRelayRoot + " " + strRelayFolderPath);
		
		    String sendPath = strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "send" + commonUtil.separator;
		    String sendtempPath = strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "sendtemp" + commonUtil.separator;
		    String senderrtempPath = strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "senderrtemp" + commonUtil.separator;
		    String senderrPath = strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "senderr" + commonUtil.separator;
			
		    logger.debug("sendPathList: " + sendPath + " " + sendtempPath + " " + senderrtempPath + " " + senderrPath );
		
		    //발송된 문서의 파일 상태를 확인하여 업데이트: 최종 저장된 위치에서 변경 사항이 있을 때에는 해당 위치로 상태값을 변경
		    //발송 관련 대상 폴더에서 조회가 되지 않을 때에는 문서유통 모듈에서 15일이 지나서 삭제한 것으로 보고 대상의 파일 상태값을 삭제됨으로 변경
		    for (Map<String, Object> map : sendOutInfoList) {
				
			      File sendfile = new File(commonUtil.detectPathTraversal(sendPath + map.get("FILENAME")));
			      File sendtempfile = new File(commonUtil.detectPathTraversal(sendPath + map.get("FILENAME")));
			      File senderrfile = new File(commonUtil.detectPathTraversal(sendPath + map.get("FILENAME")));
			      File senderrtempfile = new File(commonUtil.detectPathTraversal(sendPath + map.get("FILENAME")));
			      
			      
			      sendExist = sendfile.exists();
			      sendtempExist = sendtempfile.exists();
			      senderrExist = senderrfile.exists();
			      senderrtempExist = senderrtempfile.exists();
			      
			      logger.debug("sendExist: " + sendExist);
			      logger.debug("sendtempExist: " + sendtempExist);
			      logger.debug("senderrExist: " + senderrExist);
			      logger.debug("senderrtempExist: " + senderrtempExist);
			      
			      Map<String, Object> paramMap = new HashMap<String, Object>();
			      
//					UPDATE TBL_SENDOUTINFO
//					SET 
//					FOLDERNAME = #V_FOLDERNAME#,
//					FILESTATE = #V_FILESTATE#,
//					SENDSTATE = #V_SENDSTATE#,
//					UPDATEDATE = NOW()
//				WHERE 
//					IDEX = (SELECT max(IDEX) from TBL_SENDOUTINFO where DOCID = #V_FILENAME#)
			      
			      String folderName = (String) map.get("FOLDERNAME");
			      
			      String fileState = "success";
			      
			      if(!sendExist && !sendtempExist && !senderrExist && !senderrtempExist) {
				    	  
				    	  paramMap.put("V_FOLDERNAME", map.get("FOLDERNAME"));
				    	  paramMap.put("V_FILESTATE", "removed");
				    	  paramMap.put("V_SENDSTATE", map.get("SENDSTATE"));
				    	  paramMap.put("V_FILENAME", map.get("FILENAME"));
				    	  paramMap.put("V_DOCID", map.get("DOCID"));
				    	  
				    	  logger.debug("removed: " + paramMap);
				    	  
				    	  ezApprovalGAdminDao.updateSendOutInfo(paramMap);

				    	  fileState = "removed";
			      }
			      
			      if(fileState.equals("success")) {
				      if(sendExist) {
				    	  
				    	  folderName = folderName + ">" + "send";
				    	  
				    	  paramMap.put("V_FOLDERNAME", folderName);
				    	  paramMap.put("V_FILESTATE", "success");
				    	  paramMap.put("V_FILENAME", map.get("FILENAME"));
				    	  paramMap.put("V_DOCID", map.get("DOCID"));
				    	  
				    	  logger.debug("send: " + paramMap);
				    	  
				    	  if(!map.get("SENDSTATE").equals("send")) {
				    		  paramMap.put("V_SENDSTATE", "send");
				    		  ezApprovalGAdminDao.updateSendOutInfo(paramMap);
				    	  }
				    	  
				      } else if(sendtempExist) {
				    	  
				    	  folderName = folderName + ">" + "sendtemp";
				    	  
				    	  paramMap.put("V_FOLDERNAME", folderName);
				    	  paramMap.put("V_FILESTATE", "success");
				    	  paramMap.put("V_FILENAME", map.get("FILENAME"));
				    	  paramMap.put("V_DOCID", map.get("DOCID"));
				    	  
				    	  logger.debug("sendtemp: " + paramMap);
				    	  
				    	  if(!map.get("SENDSTATE").equals("sendtemp")) {
				    		  paramMap.put("V_SENDSTATE", "sendtemp");
				    		  ezApprovalGAdminDao.updateSendOutInfo(paramMap);
				    	  }
				    	  
				      } else if(senderrExist) {
				    	  
				    	  folderName = folderName + ">" + "senderr";
				    	  
				    	  paramMap.put("V_FOLDERNAME", folderName);
				    	  paramMap.put("V_FILESTATE", "success");				    	  
				    	  paramMap.put("V_FILENAME", map.get("FILENAME"));
				    	  paramMap.put("V_DOCID", map.get("DOCID"));
				    	  
				    	  logger.debug("senderr: " + paramMap);
				    	  
				    	  if(!map.get("SENDSTATE").equals("senderr")) {
				    		  paramMap.put("V_SENDSTATE", "senderr");
				    		  ezApprovalGAdminDao.updateSendOutInfo(paramMap);
				    	  }
				    	  
				      } else if(senderrtempExist) {
				    	  
				    	  folderName = folderName + ">" + "senderrtemp";
				    	  
				    	  paramMap.put("V_FOLDERNAME", folderName);
				    	  paramMap.put("V_FILESTATE", "success");				    	  
				    	  paramMap.put("V_FILENAME", map.get("FILENAME"));
				    	  paramMap.put("V_DOCID", map.get("DOCID"));
				    	  
				    	  logger.debug("senderrtemp: " + paramMap);
				    	  
				    	  if(!map.get("SENDSTATE").equals("senderrtemp")) {
				    		  paramMap.put("V_SENDSTATE", "senderrtemp");
				    		  ezApprovalGAdminDao.updateSendOutInfo(paramMap);
				    	  }
				    	  
				      }
			      }
			      
			}
		 
		 logger.debug("updateSendOutState ended");
	}
	
	private String base64Decode(String str) throws UnsupportedEncodingException {
		str = str.replaceAll("\\s+", "");
		return new String(Base64.getDecoder().decode(str), "euc-kr");
	}

	private String base64DecodeGetBytes(byte[] bytes) throws UnsupportedEncodingException {
		String str = new String(bytes);
		str = str.replaceAll("\\s+", "");
		return new String(Base64.getDecoder().decode(str), "euc-kr");
	}
}
