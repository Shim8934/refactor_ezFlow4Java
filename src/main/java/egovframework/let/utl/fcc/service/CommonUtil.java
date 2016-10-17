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
import java.net.URI;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.dao.EzCommonDAO;
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
	
	@Autowired
	private Properties globals;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name="EzCommonDAO")
	private EzCommonDAO ezCommonDAO;
	
	@Autowired
	private EgovMessageSource egovMessageSource;
	
	/* File separator 공통 함수 */
	public String separator = "/";
	
	private static final Logger logger = LoggerFactory.getLogger(CommonUtil.class);
	
	public LoginVO userInfo(String loginCookie){
		try{
			String decData = egovFileScrty.decryptAES(loginCookie);

			String userID = decData.split("///")[1];
			String locale = decData.split("///")[5];
			String lang = decData.split("///")[6];
			String timeZone = decData.split("///")[7];
			
			
			LoginVO login = new LoginVO();
			login.setId(userID);
			login.setDn("NOPASSWORD");
			
			LoginVO user = loginService.selectUser(login);
	
			user.setDeptPathCode(userID+ "," + ezOrganService.getDeptFullPath(user.getDeptID()));
			
			user.setLang(lang);
			user.setTheme("BASIC");
			user.setTableViewOption("D");
			user.setSkinNum("1");
			user.setRootPage(false);
			
			if (config.getProperty("config.primary").equals(lang)) {
				user.setPrimary("1");
			} else {
				user.setPrimary("2");
			}
			
			if (user.getPrimary().equals("1")) {
				user.setTitle(user.getTitle1());
				user.setDeptName(user.getDeptName1());
				user.setDisplayName(user.getDisplayName1());
				user.setCompanyName(user.getCompanyName1());
			} else {
				user.setTitle(user.getTitle2());
				user.setDeptName(user.getDeptName2());
				user.setDisplayName(user.getDisplayName2());
				user.setCompanyName(user.getCompanyName2());
			}
			
			user.setLocale(new Locale(locale));
			user.setOffset(timeZone);
			
			return user;
		}catch(Exception e){
			return null;
		}
	}
	
	public LoginVO aprUserInfo(String loginCookie){
		try{
			LoginVO user = userInfo(loginCookie);
			
			ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
			
			HttpServletRequest request = sra.getRequest();
			
			Cookie[] cookie = request.getCookies();
			
			for (int k = 0; k < cookie.length; k++) {
				switch (cookie[k].getName()) {
				case "APRUI0":
					user.setDeptID(cookie[k].getValue());
					break;
				case "APRUI1":
					user.setDeptName1(URLDecoder.decode(cookie[k].getValue(), "utf-8"));
					break;
				case "APRUI2":
					user.setTitle1(URLDecoder.decode(cookie[k].getValue(), "utf-8"));
					break;
				case "APRUI4":
					user.setDeptName2(URLDecoder.decode(cookie[k].getValue(), "utf-8"));
					break;
				case "APRUI6":
					user.setTitle2(URLDecoder.decode(cookie[k].getValue(), "utf-8"));
					break;
				}
			}
			
			if (user.getPrimary().equals("1")) {
				user.setTitle(user.getTitle1());
				user.setDeptName(user.getDeptName1());
				user.setDisplayName(user.getDisplayName1());
				user.setCompanyName(user.getCompanyName1());
			} else {
				user.setTitle(user.getTitle2());
				user.setDeptName(user.getDeptName2());
				user.setDisplayName(user.getDisplayName2());
				user.setCompanyName(user.getCompanyName2());
			}
			
			return user;
		}catch(Exception e){
			logger.debug("[Exception]aprUserInfo : " + e.getStackTrace());
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
		
	public static String getEncodedFileNameForDownload(String userAgentValue, String filename) {
		try {
			// in case of IE & Edge
			// the filename needs to be UTF-8 and URL-encoded.
			// URI class is more appropriate than URLEncoder class for this purpose.
			if (userAgentValue.contains("Trident") || userAgentValue.contains("Edge")) {
			    // "자동회신:"과 같이 :이 제목에 포함되어 있는 경우 메일 저장하기 시, 한글파일명 깨지는 문제가 있어
			    // :를 %3A로 변경한 후 URI 인코딩을 수행함. 
				filename = filename.replaceAll(":", "%3A");
				URI uri = new URI(null, null, filename, null);
				filename = uri.toASCIIString();
				// %3A에서 %가 %25로 인코딩되므로 다시 %3A로 변경함.
				filename = filename.replaceAll("%253A", "%3A");
			}
			// in case of Chrome, Safari
			// the filename consists of UTF-8 encoded bytes.
			else {
				filename = new String(filename.getBytes("UTF-8"), "ISO-8859-1");
			}
		} catch (Exception e) {			
			e.printStackTrace();
		}

		return filename;
	}
	
	public static void addXUACompatibleHeaderToResponse(HttpServletRequest request, HttpServletResponse response) {
		String browser = ClientUtil.getClientInfo(request, "browser");
		String compatibleValue = null;
		
		if (browser.equals("Edge") || browser.equals("IE11")) {
			compatibleValue = "IE=edge";
		} else if (browser.equals("IE10")) {
			compatibleValue = "IE=10";
        } else if (browser.equals("IE9")) {
            compatibleValue = "IE=9";
		} else if (browser.equals("IE8")) {
			compatibleValue = "IE=8";
		}
		
		if (compatibleValue != null) {
			response.setHeader("X-UA-Compatible", compatibleValue);
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
	
	public String getQueryResult(Object vo) throws Exception{
		StringBuilder stb = new StringBuilder();		
		
		if(vo != null){		
			stb.append("<ROW>");
			
			for(Field field : vo.getClass().getDeclaredFields()){
		        field.setAccessible(true);
				String data = String.valueOf(field.get(vo));
	
				if(data == null || data.equals(null) || data.equals("null")){
					data = "";
				}				
		        stb.append("<" + field.getName().toUpperCase() + ">");
		        stb.append(cleanValue(data));
		        stb.append("</" + field.getName().toUpperCase() + ">");		        
		    }
			stb.append("</ROW>");
		}else{
			stb.append("");
		}		
		return stb.toString();
	}
	
	/*
	 * 행이 여러 개일 때 여러 행이 포함된 XML String 생성
	 * xmlTag: "<DATA>" 또는 다름 Tag
	 */
	public String getQueryResult(List<Object> vo, String xmlTag) throws Exception{
		StringBuilder stb = new StringBuilder();		
		
		if (vo == null) {
			stb.append("");
			return stb.toString();
		}
		
	    stb.append("<DATA>");
	    
	    for (int i = 0; i < vo.size(); i++) {
			stb.append("<ROW>");
			
			for(Field field : vo.get(i).getClass().getDeclaredFields()){
		        field.setAccessible(true);
				String data = String.valueOf(field.get(vo.get(i)));
	
				if(data == null || data.equals(null) || data.equals("null")){
					data = "";
				}				
		        stb.append("<" + field.getName().toUpperCase() + ">");
		        stb.append(cleanValue(data));
		        stb.append("</" + field.getName().toUpperCase() + ">");		        
		    }
			stb.append("</ROW>");
		}
		stb.append("</DATA>");
		
		return stb.toString();
	}
	
	public String convertLangCode(String lang){   
		if (lang != "2"){
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
	
	public String getPrimaryData(String lang){
		if(lang.equals(config.getProperty("config.primary"))){
			return "1";
		}else{
			return "2";
		}
	}
	
	public String getLangData(String lang){
		if(lang.equals("1")){
			return "";
		}else{
			return lang;
		}
	}	
	
	public String cleanValue(String pOrgString) {
		String value = ""; 
				
		if(pOrgString != null){
			value = pOrgString.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	        value = value.replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");
	        value = value.replaceAll("'", "&#39;");
	        value = value.replaceAll("eval\\((.*)\\)", "");
	        value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");        
	        //value = value.replaceAll("script", "");
		}

		return value;
	}
	
	// 2016.09.06 by kgs: Property value의 값을 변환
	public String cleanPropertyValue(String pOrgString) {
		String value = ""; 
				
		if(pOrgString != null){
			value = pOrgString.replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}

		return value;
	}
	
	public String trimDoubleQuotes(String src) {
		if (src.startsWith("\"") && src.endsWith("\"")) {
			src = src.substring(1, src.length() - 1);
		}		
		
		return src;
	}
	
	public boolean checkIE(HttpServletRequest request) {
		if (request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) {
			return true;
		} else if ( request.getHeader("User-Agent").indexOf("Chrome") > 0) {
			return false;
		} else {
			return false;
		}
	}
	
	public String isoUTFDate(String dateTimeStr) throws Exception {
        String resultStr = "";

        if (dateTimeStr != null && !dateTimeStr.trim().equals("")){
            if (dateTimeStr.indexOf(" ") != -1){
                resultStr = dateTimeStr.split(" ")[0] + "T" + dateTimeStr.split(" ")[1] + ".000Z";
            } else{
                resultStr = dateTimeStr + "T00:00:00.000Z";
            }
        } else{
            resultStr = "";
        }
        
        return resultStr;
    }
	
	public String getRealPath(HttpServletRequest request) {
		String realPath = request.getServletContext().getRealPath("");
		
		if (realPath.substring(realPath.length() - 1).equals(separator)) {
			realPath = realPath.substring(0, realPath.length() - 1);
		} 
		
		return realPath;
	}
}


