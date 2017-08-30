package egovframework.ezEKP.ezApprovalG.web;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.tomcat.util.codec.binary.Base64;
import org.apache.tools.ant.taskdefs.Mkdir;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.w3c.dom.Document;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.service.impl.EzApprovalGServiceImpl.SimpleErrorHandler;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzApprovalGRelayScheduler {
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGController.class);

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private Properties globals;
	
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
	
	@Autowired
	private EgovMessageSource messageSource;
	
	@Scheduled(cron = "00 05 * * * *")
	public void receiverMain(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		logger.debug("receiverMain Started");
		userInfo = commonUtil.aprUserInfo(loginCookie);

		 String strRelayFolderPath = "";
		 String strAprDocPath =  "";

         try {
        	 logger.debug("receiveProcess Started");
             strRelayFolderPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_relay.ROOT", userInfo.getTenantId());
             strAprDocPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_relay.R_DocPath", userInfo.getTenantId()); 
             
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

             boolean bRet;
             boolean bGPKI;

             List<List<String[]>> AdminMail = new ArrayList<List<String[]>>();
             List<String[]> receiveerrList = new ArrayList<String[]>();
             List<String[]> xmlparsingerrList = new ArrayList<String[]>();
             List<String[]> senderrList = new ArrayList<String[]>();
             
            		
             //receiveerr 폴더에 쌓인 XML 파일들을 접수 처리 한다.
             if (ezCommonService.getTenantConfig("USE_RECEIVEERR_FILE_MOVE_RECEIVETEMP", userInfo.getTenantId()).equals("YES")) {
            	 File dirFile = new File(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receiveerr");
        		 File [] fileList= dirFile.listFiles();
        		 for (File tempFile : fileList) {
        		   if (tempFile.isFile()) {
        		     //receiveerr 폴더의 파일들을 수신처리 하기위해, ReceiveTemp로 이동 한다.
        		     String errorfilename = tempFile.getName();
        		     String errorfilepath = tempFile.getParent();
        		     String errorfileextension = errorfilename.substring(errorfilename.indexOf("."), errorfilename.length());
 
        		     if (errorfileextension.toLowerCase().equals(".xml")) {
        		    	 File receiveTemp = new File(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receivetemp" + errorfilename);
        		    	 File receiveComp = new File(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receiveComp" + errorfilename);
        		    	 File receive = new File(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receive" + errorfilename);
        		    			
        		    	 boolean checkresult = CheckXMLElements(errorfilepath);
                         boolean XMLLoadTest = TryXMLLoad(errorfilepath);
                         
                         if (!receiveTemp.exists() && !receiveComp.exists() && !receive.exists()) {
                             if (XMLLoadTest && checkresult) {
                            	 Document xmlDoc = xmlLod(errorfilepath);

                                 String[] receiveerrFileInfo = new String[5];
                                 //receiveerr 폴더의 XML 파일명
                                 receiveerrFileInfo[0] = errorfilename;
                                 //송신기관명
                                 receiveerrFileInfo[1] = Base64.decodeBase64(xmlDoc.getElementsByTagName("send-name").item(0).getTextContent()).toString();
                                 //수신기관코드
                                 receiveerrFileInfo[2] = xmlDoc.getElementsByTagName("receive-id").item(0).getTextContent();
                                 //문서제목
                                 receiveerrFileInfo[3] = MakeDNString(Base64.decodeBase64(xmlDoc.getElementsByTagName("title").item(0).getTextContent()).toString());
                                 //송신일자
                                 receiveerrFileInfo[4] = xmlDoc.getElementsByTagName("date").item(0).getTextContent();

                                 receiveerrList.add(receiveerrFileInfo);

                                 receiveerrFileInfo = null;
                                 File fileMove = new File(strRelayFolderPath + "data" + commonUtil.separator + "receivetemp" + commonUtil.separator + errorfilename);
                                 tempFile.renameTo(fileMove);
                                 xmlDoc = null;
                             }
                         }
                         
                         receiveTemp = null;
                         receiveComp = null;
                         receive = null;
        		     }
                     }
                 }
        		 
        		 if (ezCommonService.getTenantConfig("USE_EMAIL_NOTIFICATION", userInfo.getTenantId()).equals("YES")) {
        			 AdminMail.add(receiveerrList);
        		 }
             }
             
             //receivetemp 폴더에 쌓인 전송용통합파일(pack.xml)을 풀어 수신처리 한다.
             File receiveDir = new File(strRelayFolderPath + commonUtil.separator  + "data" + commonUtil.separator +"receivetemp");
    		 File [] recevieFileList = receiveDir.listFiles();
    		 for (File receiveTempFile : recevieFileList) {
    			  strFileName = receiveTempFile.getName();
                  strFilePath = receiveTempFile.getParent();
                  strFileType =  strFileName.substring(strFileName.indexOf("."), strFileName.length()).toUpperCase();
                  
                  if (strFileType.equals(".XML")) {
                	  strFileDate = Long.toString(receiveTempFile.lastModified());
                	  strReceiveID = strFileName.substring(7,7);
                	  
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
                          
                          File fileMove = new File(strRelayFolderPath + "data" + commonUtil.separator + "receivetemperr" + commonUtil.separator + strFileName);
                          receiveTemp.renameTo(fileMove);
                          continue;
                	  }
                	  
                	  Document objXML = xmlLod(strFilePath);
                	  
                	  strSendOrgCode = objXML.getElementsByTagName("send-orgcode").item(0).getTextContent();
                	  strSendID = objXML.getElementsByTagName("send-id").item(0).getTextContent();
                	  
                	  strCompanyID = ezOrganService.getPropertyValue(strReceiveID, "EXTENSIONATTRIBUTE2", userInfo.getTenantId());
                	  
                	  if (strReceiveID.equals("")) {
                          strReceiveID = strFileName.substring(7, 7);
                	  }

                      //수신기관코드가 회사ID랑 다를 경우 회사ID로 맞추어 준다.(보정처리)
                      boolean RecvIDCheck = false;
//                      if (GetSystemConfigValue("CompanyID").IndexOf(';') > -1)
//                      {
//                          string[] RecvIDs = GetSystemConfigValue("CompanyID").Split(';');
//                          for (int i = 0; i < RecvIDs.Length; i++)
//                          {
//                              if (strReceiveID.Trim() == RecvIDs[i].ToString().Trim())
//                              {
//                                  RecvIDCheck = true;
//                                  break;
//                              }
//                          }
//                      }
                  }
    		 }
         } catch (Exception e){
        	 
         }
         

	}

	private String TryXMLLoadWithReturnMessage(String strFilePath) {
		String result = "";
		try {
	       	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setValidating(false);
			factory.setNamespaceAware(true);
	
			DocumentBuilder builder = factory.newDocumentBuilder();
	
			builder.setErrorHandler(new SimpleErrorHandler());    
			// the "parse" method also validates XML, will throw an exception if misformatted
	    	Document xmlDoc = builder.parse(new InputSource(strFilePath));
	    	
	    	result = "OK";
		} catch (Exception e) {
			result = e.getMessage();
		}
		return result;
	}

	private Document xmlLod(String pDocPath) throws Exception {
		Document xmlDoc = null;
		try {
	       	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setValidating(false);
			factory.setNamespaceAware(true);
	
			DocumentBuilder builder = factory.newDocumentBuilder();
	
			builder.setErrorHandler(new SimpleErrorHandler());    
			// the "parse" method also validates XML, will throw an exception if misformatted
			xmlDoc = builder.parse(new InputSource(pDocPath));
	    	
		} catch (Exception e) {
		}
		
		return xmlDoc;
	}
	
	private boolean TryXMLLoad(String pDocPath) throws Exception {
		boolean result = false;
		try {
	       	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setValidating(false);
			factory.setNamespaceAware(true);
	
			DocumentBuilder builder = factory.newDocumentBuilder();
	
			builder.setErrorHandler(new SimpleErrorHandler());    
			// the "parse" method also validates XML, will throw an exception if misformatted
	    	Document xmlDoc = builder.parse(new InputSource(pDocPath));
	    	
	    	result = true;
		} catch (Exception e) {
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

        		builder.setErrorHandler(new SimpleErrorHandler());    
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
            }
            return result;
	}
	
	public class SimpleErrorHandler implements ErrorHandler {
	    public void warning(SAXParseException e) throws SAXException {
	        System.out.println(e.getMessage());
	    }

	    public void error(SAXParseException e) throws SAXException {
	        System.out.println(e.getMessage());
	    }

	    public void fatalError(SAXParseException e) throws SAXException {
	        System.out.println(e.getMessage());
	    }
	}
	
    protected String MakeDNString(String pOrgString) {
        try {
            return pOrgString.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("%", "");
        }
        catch (Exception Ex){
            return null;
        }
    }
}
