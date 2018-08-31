package egovframework.ezEKP.ezApprovalG.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.io.FileUtils;
import org.apache.tomcat.util.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzApprovalGRelayScheduler {
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGRelayScheduler.class);

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
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
	
//	@Scheduled(cron = "0 0/5 * * * *")
	@RequestMapping(value = "/ezApprovalG/relay.do")
	public void receiverMain() throws Exception{
		if (config.getProperty("config.Run_RelayScheduler").equals("NO")) {
			return;
		}
		logger.debug("receiverSchedulerMain Started");
		 String strRelayFolderPath = "";
		 String strAprDocPath =  "";

    	 List<OrganUserVO> list = ezApprovalGService.getTenantID();
		 int tenantID = list.get(0).getTenantId();
    	 
         strRelayFolderPath = config.getProperty("relay_root") + commonUtil.separator + "fileroot" + commonUtil.separator + tenantID + commonUtil.separator + "files" + config.getProperty("upload_relay.ROOT");
         strAprDocPath = config.getProperty("relay_root") + commonUtil.getUploadPath("upload_relay.R_DocPath", tenantID); 
         
         if (!strRelayFolderPath.substring(strRelayFolderPath.length() - 1).equals(commonUtil.separator)) {
        	 strRelayFolderPath = strRelayFolderPath + commonUtil.separator;
         }
         
         if (!strAprDocPath.substring(strAprDocPath.length() - 1).equals(commonUtil.separator)) {
        	 strAprDocPath = strAprDocPath + commonUtil.separator;
         }

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
        	 File dirFile = new File(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receiveerr");
        	 
        	 if (dirFile.exists()) {
        		 for (File tempFile : dirFile.listFiles()) {
        			 if (tempFile.isFile()) {
        				 //receiveerr 폴더의 파일들을 수신처리 하기위해, ReceiveTemp로 이동 한다.
        				 String errorfilename = tempFile.getName();
        				 String errorfilepath = tempFile.getParent() + commonUtil.separator + errorfilename;
        				 String errorfileextension = errorfilename.substring(errorfilename.indexOf("."), errorfilename.length());
        				 
        				 if (errorfileextension.toLowerCase().equals(".xml")) {
        					 File receiveTemp = new File(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receivetemp" + commonUtil.separator + errorfilename);
        					 File receiveComp = new File(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receiveComp" + commonUtil.separator + errorfilename);
        					 File receive = new File(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receive" + commonUtil.separator + errorfilename);
        					 
        					 boolean checkresult = CheckXMLElements(errorfilepath);
        					 boolean XMLLoadTest = TryXMLLoad(errorfilepath);
        					 
        					 if (!receiveTemp.exists() && !receiveComp.exists() && !receive.exists()) {
        						 if (XMLLoadTest && checkresult) {
        							 Document xmlDoc = commonUtil.xmlLod(errorfilepath);
        							 
        							 String[] receiveerrFileInfo = new String[5];
        							 //receiveerr 폴더의 XML 파일명
        							 receiveerrFileInfo[0] = errorfilename;
        							 //송신기관명
        							 receiveerrFileInfo[1] = new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("send-name").item(0).getTextContent()), "euc-kr");
        							 //수신기관코드
        							 receiveerrFileInfo[2] = xmlDoc.getElementsByTagName("receive-id").item(0).getTextContent();
        							 //문서제목
        							 receiveerrFileInfo[3] = MakeDNString(new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("title").item(0).getTextContent()), "euc-kr"));
        							 //송신일자
        							 receiveerrFileInfo[4] = xmlDoc.getElementsByTagName("date").item(0).getTextContent();
        							 
        							 receiveerrList.add(receiveerrFileInfo);
        							 
        							 receiveerrFileInfo = null;
        							 File fileMove = new File(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receivetemp" + commonUtil.separator + errorfilename);
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
         File receiveDir = new File(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receivetemp");
         
         if (receiveDir.exists()) {
        	 for (File receiveTempFile : receiveDir.listFiles()) {
        		 strFileName = receiveTempFile.getName();
        		 strFilePath = receiveTempFile.getParent() + commonUtil.separator + strFileName;
        		 strFileType =  strFileName.substring(strFileName.indexOf("."), strFileName.length()).toUpperCase();
        		 
        		 if (strFileType.equals(".XML")) {
        			 logger.debug("receiveFile Started");
        			 logger.debug("receiveFileName : " + strFileName);
        			 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        			 
        			 strFileDate = sdf.format(receiveTempFile.lastModified()).toString();
        			 strReceiveID = strFileName.substring(7,14);
        			 
        			 if (!TryXMLLoad(strFilePath)) {
        				 String[] xmlParsingErrInfo = new String[2];
        				 xmlParsingErrInfo[0] = strFileName;
        				 xmlParsingErrInfo[1] = TryXMLLoadWithReturnMessage(strFilePath);
        				 xmlparsingerrList.add(xmlParsingErrInfo);
        				 AdminMail.add(xmlparsingerrList);
        				 
        				 File receiveTemp = new File(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receivetemperr");
        				 
        				 if (!receiveTemp.exists()){
        					 receiveTemp.mkdirs();
        				 }
        				 
        				 File fileMove = new File(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receivetemperr" + commonUtil.separator + strFileName);
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
        					 strTitle = new String(Base64.decodeBase64(objXML.getElementsByTagName("title").item(0).getTextContent().getBytes("UTF-8")), "euc-kr");

        					 if (strTitle.length() > 125) {
        						 strTitle = strTitle.substring(1, 125);
        					 }
        				 }   
        				 logger.debug("#문서제목=" + strTitle);
        				 strXDocID = objXML.getElementsByTagName("doc-id").item(0).getTextContent();
        				 logger.debug("#문서고유번호=" + strXDocID);
        				 strDocType = objXML.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("type").getTextContent();
        				 logger.debug("#문서종류=" + strDocType);
        				 strWriterName = new String(Base64.decodeBase64(objXML.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").getTextContent()), "euc-kr");
        				 
        				 if (strWriterName == null || strWriterName.equals("")) {
        					 strWriterName = "미확인";
        				 }
        				 
        				 logger.debug("#문서작성자이름=" + strWriterName);
        				 strWriterDept = new String(Base64.decodeBase64(objXML.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").getTextContent()), "euc-kr");
        				 
        				 if (strWriterDept == null || strWriterDept.equals("")) {
        					 strWriterDept = "미확인";
        				 }
        				 
        				 logger.debug("#문서작성자부서=" + strWriterDept);
        				 strSendName = new String(Base64.decodeBase64(objXML.getElementsByTagName("send-name").item(0).getTextContent()), "euc-kr");
        				 logger.debug("#송신기관명=" + strSendName);
        				 strXGW = new String(Base64.decodeBase64(objXML.getElementsByTagName("send-gw").item(0).getTextContent()), "euc-kr");
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
        						 File gpkFile = new File(strAprDocPath + strCompanyID + commonUtil.separator + "exDocMSG" + commonUtil.separator + strXDocID.replace("/", "_").replace("#", "_") + strReceiveID + ".xml");
        						 
        						 if (gpkFile.exists()) {
        							 gpkFile.delete();
        						 }
        						 
        						 FileOutputStream fop = new FileOutputStream(gpkFile);
        						 // get the content in bytes
        						 fop.write(commonUtil.convertDocumentToString(objXML).getBytes("UTF-8"));
        						 fop.flush();
        						 fop.close();
        						 
        						 ezApprovalGService.fieldUpdate("emlURL", strXDocID.replace("/", "_").replace("#", "_") + strReceiveID + ".xml", strXDocID, strReceiveID, strCompanyID, tenantID);
        						 ezApprovalGService.fieldUpdate("isPKI", "Y", strXDocID, strReceiveID, strCompanyID, tenantID);
        					 } else {
        						 File recFile = new File(strAprDocPath + strCompanyID + commonUtil.separator +"exDocMSG" + commonUtil.separator + strXDocID.replace("/", "_").replace("#", "_") + strReceiveID + ".xml");
        						 
        						 File recDir = new File(strAprDocPath + strCompanyID + commonUtil.separator +"exDocMSG");
        						 
        						 if (!recDir.exists()) {
        							 recDir.mkdirs();
        						 }
        						 
        						 if (recFile.exists()) {
        							 recFile.delete();
        						 }
        						 
        						 FileOutputStream fop = new FileOutputStream(recFile);
        						 // get the content in bytes
        						 fop.write(commonUtil.convertDocumentToString(objXML).getBytes("UTF-8"));
        						 fop.flush();
        						 fop.close();
        						 
        						 logger.debug("#pack파일생성= OK");
        						 
        						 ezApprovalGService.fieldUpdate("emlURL", strXDocID.replace("/", "_").replace("#", "_") + strReceiveID + ".xml", strXDocID, strReceiveID, strCompanyID, tenantID);
        						 ezApprovalGService.fieldUpdate("isPKI", "N", strXDocID, strReceiveID, strCompanyID, tenantID);
        						 
        						 for (int count = 0; count < objXML.getElementsByTagName("content").getLength(); count++) {
        							 strCont_Role = objXML.getElementsByTagName("content").item(count).getAttributes().getNamedItem("content-role").getTextContent();
        							 strCont = objXML.getElementsByTagName("content").item(count).getTextContent();
        							 strCont_Name = new String(Base64.decodeBase64(objXML.getElementsByTagName("content").item(count).getAttributes().getNamedItem("filename").getTextContent()), "euc-kr");
        							 strCont = strCont.replace("\r", "").replace("\n", "").replace("\t", "");
        							 
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
        								 boolean WriteBodyAttach = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocDown" , strXDocID.replace("/", "_").replace("#", "_") + strCont_Name);
        								 logger.debug("#attach_body생성=" + WriteBodyAttach);
        								 ezApprovalGService.addAttachInfo(strCont_Name, strXDocID.replace("/", "_").replace("#", "_") + strCont_Name, strXDocID, Integer.toString(count), "Y", strCompanyID, tenantID);
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
        								 boolean WriteSealFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocSign" , strCont_Name);
        								 logger.debug("#seal생성=" + WriteSealFile, "");
        								 ezApprovalGService.fieldUpdate("sealURL", strCont_Name, strXDocID, strReceiveID, strCompanyID, tenantID);
        								 break;
        							 case "sign":
        								 boolean WriteSignFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocUserSign" ,  strXDocID.replace("/", "_").replace("#", "_") + strCont_Name);
        								 logger.debug("#sign생성=" + WriteSignFile, "");
        								 ezApprovalGService.addSignInfo(strCont_Name, strXDocID.replace("/", "_").replace("#", "_") + strCont_Name, strXDocID, strCompanyID, tenantID);
        								 break;
        							 case "logo":
        								 boolean WritetLogoFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocUserSign" ,  strXDocID.replace("/", "_").replace("#", "_") + strCont_Name);
        								 logger.debug("#logo생성=" + WritetLogoFile, "");
        								 ezApprovalGService.addSignInfo(strCont_Name, strXDocID.replace("/", "_").replace("#", "_") + strCont_Name, strXDocID, strCompanyID, tenantID);
        								 break;
        							 case "symbol":
        								 boolean WriteSymbolFile = WriteFileFromBase64(strCont, strAprDocPath + strCompanyID + commonUtil.separator + "ExDocUserSign" ,  strXDocID.replace("/", "_").replace("#", "_") + strCont_Name);
        								 logger.debug("#symbol생성=" + WriteSymbolFile, "");
        								 ezApprovalGService.addSignInfo(strCont_Name, strXDocID.replace("/", "_").replace("#", "_") + strCont_Name, strXDocID, strCompanyID, tenantID);
        								 break;
        							 }
        						 }
        					 }
        					 
        					 //혹시 몰라 주석 일단
//                                      System.Xml.XmlDocument extXml = new System.Xml.XmlDocument();
//                                      extXml.LoadXml(strReXml);
//                                      string strFormPath = extXml.InnerText;
//                                      extXml = null;
        					 
        					 //결재진행문서 정보에 수신문서 정보를 입력해 준다.
        					 boolean inputReceiveInfo = ezApprovalGService.createRelayDocInfo(strWriterName, strWriterDept, config.getProperty("relay_root"), strXDocID, strReceiveID, strCompanyID, tenantID);
        					 logger.debug("#수신문서정보입력=" + inputReceiveInfo);
        					 
        					 //수신된 유통문서에 대해 수신(Receive) ACK 발송
        					 boolean SendReceiveACK = ezApprovalGService.sendAck(config.getProperty("relay_root"), strXDocID, strReceiveID, strSendID, strTitle, "receive", "", "", "", strCompanyID, tenantID);
        					 logger.debug("#수신ACK발송=" + SendReceiveACK);
        					 
        					 break;
        					 // 발송 실패에 따른 메시지 Update
        				 case "fail":
        					 String Message = new String(Base64.decodeBase64(objXML.getElementsByTagName("content").item(0).getTextContent()), "euc-kr");
        					 boolean UpdateSendDoc_Fail = ezApprovalGService.updateRelaySusinState(strXDocID, strRecDate, strDocType, strSendID, "", strCompanyID, tenantID);
        					 boolean InsMessage = ezApprovalGService.insFailMessage(strXDocID, strSendID, strSendName, Message, strCompanyID, tenantID);
        					 logger.debug("#발송실패오류=" + Message, "");
        					 logger.debug("#발송문서정보갱신=" + UpdateSendDoc_Fail, "");
        					 break;
        					 // 도달 - 수신기관의 중계모듈이 전송용 통합파일을 임시수신함(receivetemp)에 저장한 후 생성
        				 case "arrive":
        					 boolean UpdateSendDoc_Arrive = ezApprovalGService.updateRelaySusinState(strXDocID, strRecDate, strDocType, strSendID, "", strCompanyID, tenantID);
        					 break;
        					 // 수신 - 수신기관의 전자문서시스템이 중계모듈의 임시수신함(receivetemp)에 수신된 문서를 가져가는 작업 완료 후 생성
        				 case "receive":
        					 boolean UpdateSendDoc_Receive = ezApprovalGService.updateRelaySusinState(strXDocID, strRecDate, strDocType, strSendID, "", strCompanyID, tenantID);
        					 break;
        					 // 접수 - 수신기관에서 문서를 정상적으로 최초 확인
        				 case "accept":
        					 String strAcceptName = new String(Base64.decodeBase64(objXML.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").getTextContent()), "euc-kr") + "(" + new String(Base64.decodeBase64(objXML.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").getTextContent()), "euc-kr") + ")";
        					 boolean UpdateSendDoc_Accept = ezApprovalGService.updateRelaySusinState(strXDocID, strRecDate, strDocType, strSendID, strAcceptName, strCompanyID, tenantID);
        					 logger.debug("#발송문서정보갱신=" + UpdateSendDoc_Accept);
        					 
        					 break;
        					 // 발송 문서에 대한 수신 기관 접수 부서 및 접수자 Update
        				 case "return":                           
        				 case "req-resend":
        					 boolean UpdateSendDoc_ReqResend = ezApprovalGService.updateRelaySusinState(strXDocID, strRecDate, strDocType, strSendID, "", strCompanyID, tenantID);
        					 logger.debug("#발송문서정보갱신=" + UpdateSendDoc_ReqResend);
        					 break;
        				 }
        				 
        				 File di2 = new File(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receiveComp");
        				 
        				 if (di2.exists()) {
        					 File FI2 = new File(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receiveComp" + commonUtil.separator + strFileName);
        					 if (FI2.exists()) {
        						 receiveTempFile.delete();
        					 } else {
        						 File fileMove = new File(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "receiveComp" + commonUtil.separator + strFileName);
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
        	 }
         }

         File senderr = new File(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "senderr");
         File [] fileList = senderr.listFiles();
         
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
                     senderrInfo[1] = new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("send-name").item(0).getTextContent()), "euc-kr");
                     //수신기관코드
                     senderrInfo[2] = xmlDoc.getElementsByTagName("receive-id").item(0).getTextContent();
                     //문서제목
                     senderrInfo[3] = MakeDNString(new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("title").item(0).getTextContent()), "euc-kr"));
                     
                     senderrInfo[4] = MakeDNString(new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").getTextContent()), "euc-kr"));
                     senderrInfo[5] = MakeDNString(new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").getTextContent()), "euc-kr"));
                     //송신일자
                     senderrInfo[6] = xmlDoc.getElementsByTagName("date").item(0).getTextContent();
                     
                     senderrList.add(senderrInfo);
                     
                     File dir3 = new File(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "senderrtemp");
                     if (!dir3.exists()) {
                    	 dir3.mkdirs();
                     }
                     File fileMove = new File(strRelayFolderPath + commonUtil.separator + "data" + commonUtil.separator + "senderrtemp" + commonUtil.separator + errorfilename);

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
		byte[] content = Base64.decodeBase64(strCont);
		try {
			File dir = new File(pFilePath);
			
			if (!dir.exists()) {
				dir.mkdirs();
			}
			
	        FileOutputStream fos = new FileOutputStream(pFilePath + commonUtil.separator + fileName);
	        fos.write(content);
	        fos.close();

	        result = true;
		} catch (Exception e) {
			e.printStackTrace();
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
        	 ex.printStackTrace();
             logger.debug("ezReceiverMain", "pubdocUpdate", ex.getMessage());
         }
	}

	private boolean ReplaceFileText(String strFilePath, String pTargetText,	String pNewText, boolean pUseRegex, String pRegexPattern) throws Exception {

		FileInputStream fis = new FileInputStream(new File(strFilePath)); 
		InputStreamReader isr = new InputStreamReader(fis,"UTF-8"); 
		BufferedReader br = new BufferedReader(isr);	
		String text = "";
		
		while(true){
			text = br.readLine();
			if(text == null) break;
		}
		br.close();
		try {
			if (pUseRegex) {
				Pattern pattern = Pattern.compile(pRegexPattern);
				Matcher matcher = pattern.matcher(text);
				
				text = matcher.replaceAll(pNewText);
			} else {
				text = text.replace(pTargetText, pNewText);
			}
			
			File file = new File(strFilePath);
			FileOutputStream fop = new FileOutputStream(file);
			// get the content in bytes
			fop.write(text.getBytes("UTF-8"));
			fop.flush();
			fop.close();
			
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
		
	}

	private boolean WriteXMLFileFromBase64(String strCont, String pFilePath, String fileName) throws UnsupportedEncodingException {
		boolean result = false;
		
		String content = new String(Base64.decodeBase64(strCont), "euc-kr");
		try {
			content = content.replace("xml:stylesheet", "xml-stylesheet");
			String replaceStr = content.substring(content.indexOf("<title"), content.indexOf("</title>") + "</title>".length());
			
			replaceStr = "<title>" + replaceStr.replace("<title>", "").replace("</title>", "").replace("<", "&lt").replace(">", "&gt") + "</title>";
			Pattern pattern = Pattern.compile("<title.*?>(.*?)</title>");
			Matcher matcher = pattern.matcher(content);
			
			content = matcher.replaceAll(replaceStr);
			
			File dir = new File( pFilePath);
			
			if (!dir.exists()) {
				dir.mkdirs();
			}
			
			File file = new File(pFilePath + commonUtil.separator + fileName);
			FileOutputStream fop = new FileOutputStream(file);
			// get the content in bytes
			fop.write(content.getBytes("EUC-KR"));
			fop.flush();
			fop.close();

			result = true;
		} catch (Exception e) {
			e.printStackTrace();
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
		   e.printStackTrace();
		}
		  return strRecDate.equals(format);
	}

	private String TryXMLLoadWithReturnMessage(String strFilePath) {
		String result = "";
		try {
	       	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setValidating(false);
			factory.setNamespaceAware(true);
	
			DocumentBuilder builder = factory.newDocumentBuilder();
	
			// the "parse" method also validates XML, will throw an exception if misformatted
	    	builder.parse(new InputSource(strFilePath));
	    	
	    	result = "OK";
		} catch (Exception e) {
			e.printStackTrace();
			result = e.getMessage();
		}
		return result;
	}
	
	private boolean TryXMLLoad(String pDocPath) throws Exception {
		boolean result = false;
		try {
	       	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setValidating(false);
			factory.setNamespaceAware(true);
	
			DocumentBuilder builder = factory.newDocumentBuilder();
	
			// the "parse" method also validates XML, will throw an exception if misformatted
	    	builder.parse(new InputSource(pDocPath));
	    	
	    	result = true;
		} catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
		
		return result;
	}

	private boolean CheckXMLElements(String pDocPath) {
			boolean result = false;
            try {
            	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
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
            	ex.printStackTrace();
            }
            return result;
	}
	
    protected String MakeDNString(String pOrgString) {
        try {
            return pOrgString.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("%", "");
        }
        catch (Exception Ex){
        	Ex.printStackTrace();
            return null;
        }
    }
}