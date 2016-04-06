/**
 * @Class Name  : EgovStringUtil.java
 * @Description : 문자열 데이터 처리 관련 유틸리티
 * @Modification Information
 *
 *     수정일         수정자                   수정내용
 *     -------          --------        ---------------------------
 *   2009.01.13     박정규          최초 생성
 *   2009.02.13     이삼섭          내용 추가
 *
 * @author 공통 서비스 개발팀 박정규
 * @since 2009. 01. 13
 * @version 1.0
 * @see
 *
 */

package egovframework.let.utl.fcc.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.swing.text.StyledEditorKit.BoldAction;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.sim.service.EgovFileScrty;

/*
 * Copyright 2001-2006 The Apache Software Foundation.
 *
 * Licensed under the Apache License, Version 2.0 (the ";License&quot;);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS"; BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
@Component
public class CommonUtil {
	
	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;
	
	@Autowired
	private EgovMessageSource egovMessageSource;
	
	public LoginVO userInfo(String loginCookie){
		try{
			String decData = egovFileScrty.decryptAES(loginCookie);
			String userID = decData.split("///")[1];
			
			LoginVO login = new LoginVO();
			login.setId(userID);
			login.setDn("NOPASSWORD");
	
			LoginVO user = loginService.selectUser(login);
	
			user.setDeptPathCode(userID+ "," + ezOrganService.getDeptFullPath(user.getDeptID()));
			user.setLang(config.getProperty("config.primary"));
			
			return user;
		}catch(Exception e){
			return null;
		}
	}
	
	public boolean checkAdmin(String loginCookie){
		try{
			String decData = egovFileScrty.decryptAES(loginCookie);
			String userID = decData.split("///")[1];
			
			LoginVO login = new LoginVO();
			login.setId(userID);
			login.setDn("NOPASSWORD");
	
			LoginVO user = loginService.selectUser(login);
	
			if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1){
				return false;
			}else{
				return true;
			}
		}catch(Exception e){
			return false;
		}
	}
	
	public List<String> getUserIdAndPassword(String loginCookie) {
		try{
			String decData = egovFileScrty.decryptAES(loginCookie);
			List<String> returnObject = new ArrayList<String>();
			
			String userId = decData.split("///")[1];
			String pass = decData.split("///")[4];
			returnObject.add(userId);
			returnObject.add(pass);
	
			return returnObject;
		}catch(Exception e){
			return null;
		}
	}	
		
	public Document convertStringToDocument(String xmlStr) {		
		String replaceData = xmlStr.trim().replaceFirst("^([\\W]+)<","<");
		
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();  
        DocumentBuilder builder;
        Document doc = null;
        
        try {  
            builder = factory.newDocumentBuilder();  
            doc = builder.parse(new InputSource(new StringReader(replaceData)));            
        } catch (Exception e) {}
        
        return doc;        
	}
	
	public Document convertRequestToDocument(HttpServletRequest request) {
		StringBuilder sb = new StringBuilder();		
        String readData = "";
        BufferedReader br;
        Document doc = null;
        
		try {
			br = new BufferedReader(new InputStreamReader(request.getInputStream(), "UTF-8"));
			
			while ((readData = br.readLine()) != null ) {
	            sb.append(readData);
	        }
			doc = convertStringToDocument(sb.toString());
			
		} catch(Exception e){}
		
		return doc;		
	}
	
	public String convertDocumentToString(Document doc){
		try{
			TransformerFactory tf = TransformerFactory.newInstance();
		    Transformer transformer = tf.newTransformer();
		    transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
		    StringWriter writer = new StringWriter();
		    transformer.transform(new DOMSource(doc), new StreamResult(writer));
		    String output = writer.getBuffer().toString();	    
			
			return output;
		}catch(Exception e){
			return null;
		}
	}
	
	public String getQueryResult(Object vo){
		StringBuilder stb = new StringBuilder();		
		
		try{
			stb.append("<ROW>");
			
			for(Field field : vo.getClass().getDeclaredFields()){
		        field.setAccessible(true);
		        
		        stb.append("<" + field.getName().toUpperCase() + ">");
		        stb.append(field.get(vo));
		        stb.append("</" + field.getName().toUpperCase() + ">");		        
		    }
			stb.append("</ROW>");
			
			return stb.toString();
		}catch(Exception e){
			return null;
		}		
	}
	
	public String convertLangCode(String pLangCode){   
		if (pLangCode != "2"){
            return "1";
        }else{
            return "2";
        }        
    }
	
	public String getMultiData(String lang){
		if(!lang.equals(config.getProperty("config.primary"))){
			return "2";
		}else{
			return "";
		}
	}
	
	public String convertAddandConvert(String pClass, String pProvValue) {
		String[] arraryProvValue = pProvValue.split(";");
		String returnValue = "";
		String addPopList = pProvValue;
		for(int i=0; i<arraryProvValue.length; i++) {
			returnValue = "";
			returnValue = addPropList(pClass, arraryProvValue[i]);
			if(returnValue != "") {
				addPopList = addPopList + ";" + returnValue;
			}
		}
		return addPopList;
	}
	
	public String addPropList(String pType, String pAttribute) {
		String strRet = "";
		//부서
		if(pType != "user") {
			switch (pAttribute.toUpperCase()) {
			case "DISPLAYNAME": strRet = "DISPLAYNAME1;DISPLAYNAME2".toUpperCase();
				break;
			case "DESCRIPTION": strRet = "DESCRIPTION1;DESCRIPTION2".toUpperCase();
				break;
			case "COMPANY": strRet = "COMPANY1;COMPANY2".toUpperCase();
				break;
			default: strRet = "";
				break;
			}
		//사용자
		} else {
			switch (pAttribute.toUpperCase()) {
			case "DISPLAYNAME": strRet = "DISPLAYNAME1;DISPLAYNAME2".toUpperCase();
				break;
			case "DESCRIPTION": strRet = "DESCRIPTION1;DESCRIPTION2".toUpperCase();
				break;
			case "COMPANY": strRet = "COMPANY1;COMPANY2".toUpperCase();
				break;
			case "TITLE": strRet = "TITLE1;TITLE2".toUpperCase();
				break;
			case "EXTENSIONATTRIBUTE10": strRet = "EXTENSIONATTRIBUTE101;EXTENSIONATTRIBUTE102".toUpperCase();
				break;
			case "UPNNAME": strRet = "UPNNAME";
				break;
			default: strRet = "";
				break;
			}
		}
		return strRet;
	}
	
	public boolean checkDBColum(String pProvValue) {
		boolean bRet = false;
		switch (pProvValue.toUpperCase()) {
		case "CN":
            bRet = true;
            break;
        case "DISPLAYNAME":
            bRet = true;
            break;
        case "DISPLAYNAME1":
            bRet = true;
            break;
        case "DISPLAYNAME2":
            bRet = true;
            break;
        case "MAIL":
            bRet = true;
            break;
        case "MAILNICKNAME":
            bRet = true;
            break;
        case "UPNNAME":
            bRet = true;
            break;
        case "DEPARTMENT":
            bRet = true;
            break;
        case "DESCRIPTION":
            bRet = true;
            break;
        case "DESCRIPTION1":
            bRet = true;
            break;
        case "DESCRIPTION2":
            bRet = true;
            break;
        case "PHYSICALDELIVERYOFFICENAME":
            bRet = true;
            break;
        case "COMPANY":
            bRet = true;
            break;
        case "COMPANY1":
            bRet = true;
            break;
        case "COMPANY2":
            bRet = true;
            break;
        case "TITLE":
            bRet = true;
            break;
        case "TITLE1":
            bRet = true;
            break;
        case "TITLE2":
            bRet = true;
            break;
        case "TELEPHONENUMBER":
            bRet = true;
            break;
        case "HOMEPHONE":
            bRet = true;
            break;
        case "FACSIMILETELEPHONENUMBER":
            bRet = true;
            break;
        case "MOBILE":
            bRet = true;
            break;
        case "POSTALCODE":
            bRet = true;
            break;
        case "STREETADDRESS":
            bRet = true;
            break;
        case "INFO":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE1":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE2":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE3":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE4":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE5":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE6":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE7":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE8":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE9":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE10":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE101":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE102":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE11":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE12":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE13":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE14":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE15":
            bRet = true;
            break;
        case "ADSPATH":
            bRet = true;
            break;
        case "UPDATEDT":
            bRet = true;
            break;
        case "SIPURI":
            bRet = true;
            break;
        case "BIRTH":
            bRet = true;
            break;
        case "BIRTHTYPE":
            bRet = true;
            break;
		
		}
		switch (pProvValue.toUpperCase()) {
		case "CN":
            bRet = true;
            break;
        case "DISPLAYNAME":
            bRet = true;
            break;
        case "DISPLAYNAME1":
            bRet = true;
            break;
        case "DISPLAYNAME2":
            bRet = true;
            break;
        case "USEFLAG":
            bRet = true;
            break;
        case "COMPANY":
            bRet = true;
            break;
        case "COMPANY1":
            bRet = true;
            break;
        case "COMPANY2":
            bRet = true;
            break;
        case "DEPTLEVEL":
            bRet = true;
            break;
        case "DEPT_CD_PATH":
            bRet = true;
            break;
        case "DEPT_NM_PATH":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE1":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE2":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE3":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE4":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE5":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE6":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE7":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE8":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE9":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE10":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE11":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE12":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE13":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE14":
            bRet = true;
            break;
        case "EXTENSIONATTRIBUTE15":
            bRet = true;
            break;
        case "ADFLAG":
            bRet = true;
            break;
        case "ADSPATH":
            bRet = true;
            break;
        case "UPDATEDT":
            bRet = true;
            break;
		}
	 return bRet;
	}
	
	public String makeXMLString(String pOrgString) {
		return pOrgString.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
	}
	
}


