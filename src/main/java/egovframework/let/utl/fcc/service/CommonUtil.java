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
import java.io.File;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.lang.reflect.Field;
import java.net.URI;
import java.net.URLDecoder;
import java.text.DecimalFormat;
import java.text.Normalizer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.web.servlet.i18n.CookieLocaleResolver;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
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
	
	public static final String PT_MAIL = "mail";
	public static final String PT_BASIC = "basic";
	public static final String PT_STANDARD = "standard";
	
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
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;    
	
	@Resource(name = "jspw")
    private String jspw;
	
	/* File separator 공통 함수 */
	public String separator = "/";
	
	public final String CRLF = "\r\n";
	
	private static final Logger logger = LoggerFactory.getLogger(CommonUtil.class);
	private static CommonUtil commonUtilInstance;
	
    @PostConstruct
	public void init() throws Exception {
    	logger.debug("init started.");

    	commonUtilInstance = this;
    	
    	logger.debug("init ended.");
    }
	
	public LoginVO userInfo(String loginCookie){
		try{
			String decData = egovFileScrty.decryptAES(loginCookie);

			String[] decDataArray = decData.split("///");
			
			String serverName = decDataArray[0];
			String userID = decDataArray[1];
			String locale = decDataArray[5];
			String lang = decDataArray[6];
			String timeZone = decDataArray[7];
			
            String tenantIdStr = "0";
            
            String deptID = "";
            
            if (decDataArray.length >= 9) {
                tenantIdStr = decDataArray[8];	
            }
            if(decDataArray.length >= 10) {
            	deptID = decDataArray[9];
            }
			
			LoginVO login = new LoginVO();
			login.setId(userID);
			login.setDn("NOPASSWORD");
			login.setTenantId(Integer.parseInt(tenantIdStr));
			login.setDeptID(deptID);
			
			LoginVO user = loginService.selectUser(login);
	
			user.setDeptPathCode(userID+ "," + user.getDeptPathCode());
			user.setLang(lang);
			user.setTheme("BASIC");
			user.setTableViewOption("D");
			user.setSkinNum("1");
			user.setRootPage(false);
			
			if (user.getPrimary().equals(lang)) {
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
			
			user.setServerName(serverName);
			
			return user;
		}catch(Exception e){
			return null;
		}
	}
	
	public LoginSimpleVO userInfoSimple(String loginCookie) {
		try{
			String decData = egovFileScrty.decryptAES(loginCookie);

			String[] decDataArray = decData.split("///");
			
			String serverName = decDataArray[0];
			String userID = decDataArray[1];
			String locale = decDataArray[5];
			String lang = decDataArray[6];
			String timeZone = decDataArray[7];
			String deptID = decDataArray[9];
			String companyID = decDataArray[10];
			
            String tenantIdStr = "0";
            
            if (decDataArray.length >= 9) {
                tenantIdStr = decDataArray[8];	
            }
            
            LoginSimpleVO user = new LoginSimpleVO();
            user.setId(userID);
            user.setTenantId(Integer.parseInt(tenantIdStr));
            user.setLang(lang);
            user.setLocale(new Locale(locale));
			user.setOffset(timeZone);			
			user.setServerName(serverName);
			user.setDeptID(deptID);
			user.setCompanyID(companyID);
			
			return user;
		}catch(Exception e){
			return null;
		}
	}
	
	public LoginVO aprUserInfo(String loginCookie) {
		try{
			logger.debug("aprUserInfo started");
			
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
					user.setDeptName2(URLDecoder.decode(cookie[k].getValue(), "utf-8"));
					break;
				case "APRUI3":
					user.setCompanyName1(URLDecoder.decode(cookie[k].getValue(), "utf-8"));
					break;
				case "APRUI4":
					user.setCompanyName2(URLDecoder.decode(cookie[k].getValue(), "utf-8"));
					break;
				case "APRUI5":
					user.setTitle1(URLDecoder.decode(cookie[k].getValue(), "utf-8"));
					break;
				case "APRUI6":
					user.setTitle2(URLDecoder.decode(cookie[k].getValue(), "utf-8"));
					break;
				case "APRUI7":
					user.setCompanyID(cookie[k].getValue());
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
			
			logger.debug("aprUserInfo ended");
			
			return user;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	public LoginVO checkAdmin(String loginCookie){
		try{
			LoginVO user = userInfo(loginCookie);
	
			if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1){
				return null;
			}else{
				return user;
			}
		}catch(Exception e){
			return null;
		}
	}
	
	public LoginVO aprCheckAdmin(String loginCookie){
		try{
			LoginVO user = aprUserInfo(loginCookie);
	
			if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1){
				return null;
			}else{
				return user;
			}
		}catch(Exception e){
			return null;
		}
	}
	
	public List<String> getUserIdAndPassword(String loginCookie) {
		try{
			String decData = egovFileScrty.decryptAES(loginCookie);
			List<String> returnObject = new ArrayList<String>();
			
			String userId = decData.split("///")[1];
			String pass = jspw;
			returnObject.add(userId);
			returnObject.add(pass);
	
			return returnObject;
		}catch(Exception e){
			return null;
		}
	}
	
	public List<String> getUserIdAndRealPassword(String loginCookie) {
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
	
	public boolean isLoginCookieExists(HttpServletRequest request, HttpServletResponse response) {
        boolean isCookie = false;     
        Cookie[] cookies = request.getCookies();
        /* session time을 위한 처리 주석 */
        //HttpSession session = request.getSession(false);
        
        //if (session != null) {
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if("loginCookie".equals(cookie.getName())){
	                    //접속한 클라이언트 IP
	                    String ip = ClientUtil.getClientIP(request);
	                    String cValue = "";
	                    try {
	                        //쿠기에 저장되어 있는 IP
	                        cValue = egovFileScrty.decryptAES(cookie.getValue());
	
	                        if(cValue.split("///")[3].equals(ip)){                  
	                            isCookie = true;
	                        }
	                    } catch (Exception e) {
	                        //e.printStackTrace();
	                    }
	                }
	            }
	        }
        /*} else {
        	if (cookies != null) {
        		for (Cookie cookie : cookies) {
        			if(!cookie.getName().equals("saveid") && !cookie.getName().matches("POPUP_.*")){
        				cookie.setMaxAge(0);
        				cookie.setPath("/");
        				response.addCookie(cookie);
        			}
        	    }
        	}
        }     */   
        return isCookie;
	}
	
	public Document convertStringToDocument(String xmlStr) {
		String replaceData = xmlStr.trim().replaceFirst("^([\\W]+)<","<");
		replaceData = replaceData.replace("&shy;", "");
		
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();  
        DocumentBuilder builder;
        Document doc = null;
        
        try {  
            builder = factory.newDocumentBuilder();  
            doc = builder.parse(new InputSource(new StringReader(replaceData)));
        } catch (Exception e) {
        	e.printStackTrace();
        }
        
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
	
	// 객체의 필드 목록을 XML 형식으로 반환한다.
	// 필드명을 태그명으로 필드값을 태그 사이의 값으로 구성한다.
	public String getQueryResult(Object vo) throws Exception {
		StringBuilder stb = new StringBuilder();		
		
		if (vo != null) {
			stb.append("<ROW>");
			
			for (Field field : vo.getClass().getDeclaredFields()) {
		        field.setAccessible(true);
				String data = String.valueOf(field.get(vo));
	
				if (data == null || data.equals(null) || data.equals("null")) {
					data = "";
				}		
				
		        stb.append("<" + field.getName().toUpperCase() + ">");
		        stb.append(cleanValue(data));
		        stb.append("</" + field.getName().toUpperCase() + ">");		        
		    }
			
			stb.append("</ROW>");
		} else {
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
		
	public String getMultiData(String lang, int tenantID) throws Exception{
		if (!lang.equals(ezCommonService.getTenantConfig("PrimaryLang", tenantID))) {
			return "2";
		} else {
			return "";
		}
	}
	
	public String getPrimaryData(String lang, int tenantID) throws Exception {
		if (lang.equals(ezCommonService.getTenantConfig("PrimaryLang", tenantID))) {
			return "1";
		} else {
			return "2";
		}
	}
	
	public String getLangData(String lang){
		if (lang.equals("1")) {
			return "";
		} else {
			return lang;
		}
	}	
	
	public String cleanValue(String pOrgString) {
		String value = ""; 
				
		if (pOrgString != null) {
			value = pOrgString.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	        value = value.replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");
	        value = value.replaceAll("'", "&#39;");
	        value = value.replaceAll("\"", "&quot;");
	        value = value.replaceAll("eval\\((.*)\\)", "");
	        value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");        
	        //value = value.replaceAll("script", "");
		}

		return value;
	}
	
	public String cleanScriptValue(String htmlCode, String type) {
        if("clean".equals(type)){
        	htmlCode = htmlCode.replaceAll("</?script>", "&lt;sciprt&gt;");
        }
		
		return htmlCode;
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
		} else if (realPath.substring(realPath.length() - 1).equals("\\")) {
			realPath = realPath.substring(0, realPath.length() - 1);
		}
		
		return realPath;
	}
	
	public String getUploadPath(String property, int tenantId) {
		return separator + "fileroot" + separator + tenantId + config.getProperty(property);
	}
	
	/**
	 * <pre>
	 * timeZoneToUTC가 true면 TimeZone Date 문자열을 UTC타임 Date 문자열로 바꿔서 반환한다.
	 * timeZoneToUTC가 false면 UTC타임 Date 문자열을 TimeZone Date 문자열로 바꿔서 반환한다.
	 * - dateStr 형식 : yyyy-MM-dd HH:mm:ss, yyyy-MM-dd HH:mm, yyyy-MM-dd
	 * 				   yyyy/MM/dd HH:mm:ss, yyyy/MM/dd HH:mm, yyyy/MM/dd, yyMMdd
	 * - offset 형식 : ex) 235|+09:00
	 * </pre>
	 */
	public String getDateStringInUTC(String dateStr, String offset, boolean timeZoneToUTC) {
//		logger.debug("dateStr=" + dateStr + ", offset=" + offset + ", timeZoneToUTC=" + timeZoneToUTC);
		
		if (dateStr == null) {
			logger.error("dateStr is null.");
			return null;
		}
		
		if (dateStr.equals("0")) {			
			return dateStr;
		}
		
		if (offset == null || offset.indexOf("|") == -1) {
			logger.error("offset is null or offset format is wrong.");
			return dateStr;
		}
		
		String pattern = "";
		if (dateStr.length() == 8) {
			pattern = "yyyyMMdd";
		} else if (dateStr.length() == 10) {
			if (dateStr.indexOf("/") > -1) {
				pattern = "yyyy/MM/dd";
			} else {
				pattern = "yyyy-MM-dd";
			}
		} else if (dateStr.length() == 14) {
			pattern = "yyyyMMddHHmmss";
		} else if (dateStr.length() == 16) {
			if (dateStr.indexOf("/") > -1) {
				pattern = "yyyy/MM/dd HH:mm";
			} else {
				pattern = "yyyy-MM-dd HH:mm";
			}
		} else if (dateStr.length() == 21) {
			if (dateStr.indexOf("/") > -1) {
				pattern = "yyyy/MM/dd aa h:mm:ss";
			} else {
				pattern = "yyyy-MM-dd aa h:mm:ss";
			}
		} else {
			if (dateStr.indexOf("/") > -1) {
				pattern = "yyyy/MM/dd HH:mm:ss";
			} else {
				pattern = "yyyy-MM-dd HH:mm:ss";
			}
		}
//		logger.debug("pattern=" + pattern);
		
		String[] offsetArr = offset.split("\\|");
		
		SimpleDateFormat userFormat = new SimpleDateFormat(pattern);
		userFormat.setTimeZone(TimeZone.getTimeZone("GMT" + offsetArr[1]));
		
		SimpleDateFormat utcFormat = new SimpleDateFormat(pattern);
		utcFormat.setTimeZone(TimeZone.getTimeZone("GMT"));
		
		String resultDateStr = "";
		try {
			if (timeZoneToUTC) {
				resultDateStr = utcFormat.format(userFormat.parse(dateStr));
			} else {
				resultDateStr = userFormat.format(utcFormat.parse(dateStr));
			}
		} catch (ParseException e) {
			logger.error("Check the dateStr format.");
			return dateStr;
		}
		
//		logger.debug("resultDateStr=" + resultDateStr);
		return resultDateStr;
	}
	
	/**
	 * 현재시간 UTC로 가져오기
	 * @param format 공백이면 기본 "yyyy-MM-dd HH:mm:ss" 형식
	 * @return 포맷팅된 UTC 현재시간 가져옴
	 * @throws Exception
	 */
	public String getTodayUTCTime(String format) throws Exception {
		logger.debug("getTodayUTCTime started");
		
		ZoneId utc = ZoneId.of("UTC");
		ZonedDateTime getTime = ZonedDateTime.of(LocalDateTime.now(utc), utc);
		
		DateTimeFormatter formatter = null;
		
		if (format == null || format.equals("")) {
			formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		} else {
			try {
				formatter = DateTimeFormatter.ofPattern(format);
			} catch (Exception e) {
				logger.error("formatter error :: " + e.getMessage());
				formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			}
		}
		
		String today = getTime.format(formatter);
		
		logger.debug("getTodayUTCTime ended");
		
		return today;
	}
	
	/**
	 * offset 시간을 분으로 변환하는 함수	 
	 */
	public String getMinuteUTC(String offSet) throws Exception {
		logger.debug("getMinuteUTC started");
		
		String format = offSet.split("\\|")[1];
		String cal = format.substring(0,1);
		int min = Integer.parseInt(format.substring(1,3)) * 60 + Integer.parseInt(format.substring(4,6));
		String time = cal + min;	
		
		return time;
	}
	
	public String makeDate (String year, String month, String day, boolean startFlag) {
		String result = "";
		
		if (month.length() == 1) {
			month = "0" + month;
		}
		
		if (!year.equals("") && !month.equals("") && !day.equals("")) {
			result = year + "-" + month + "-" + day;
			
			if (startFlag) {
				result += " 00:00:00";
			} else {
				result += " 23:59:59";
			}
		}
		return result;
	}
	
	public String getTwoLetterLangFromLangNum(String langNum) {
		String returnValue = "";
		
		if (langNum == null) {
			logger.error("langNum is null.");
			return null;
		}
		
		if (langNum.equals("1")) {
			returnValue = "ko";
		} else if (langNum.equals("2")) {
			returnValue = "en";
		} else if (langNum.equals("3")) {
			returnValue = "ja";
		} else if (langNum.equals("4")) {
			returnValue = "zh";
		} else {
			logger.error("Invalid langNum.");
		}
		
		return returnValue;
	}
	
	public String getLangNumFromTwoLetterLang(String twoLetterLang) {
		String returnValue = "";
		
		if (twoLetterLang == null) {
			logger.error("twoLetterLang is null.");
			return null;
		}
		
		// 2018-02-28 skyblue0o0 : 영어(en)와 중국어(zh)는 아직 지원하지 않으므로 주석처리
		// 첫 로그인 시 브라우저의 언어로 사용자 언어가 세팅되기 때문에 문제가 생길 수 있음.
		// TODO: 영어/중국어 지원 시 주석 풀기
		if (twoLetterLang.equalsIgnoreCase("ko")) {
			returnValue = "1";
//		} else if (twoLetterLang.equalsIgnoreCase("en")) {
//			returnValue = "2";
		} else if (twoLetterLang.equalsIgnoreCase("ja")) {
			returnValue = "3";
//		} else if (twoLetterLang.equalsIgnoreCase("zh")) {
//			returnValue = "4";
		} else {
			logger.error("Invalid twoLetterLang.");
		}
		
		return returnValue;
	}
	
	public String makeListField(String orgStr) {
		if (orgStr == null || orgStr.equals("NULL") || orgStr.equals("null")) {
			return "";
		} else {
			return orgStr;
		}
	}
	
	public String byteCalculation(String bytes) {
        String retFormat = "0";
        Double size = Double.parseDouble(bytes);

        String[] s = { "bytes", "KB", "MB", "GB", "TB", "PB" };       

        if (!bytes.equals("0")) {
              int idx = (int) Math.floor(Math.log(size) / Math.log(1024));
              DecimalFormat df = new DecimalFormat("#,###.##");
              double ret = ((size / Math.pow(1024, Math.floor(idx))));
              retFormat = df.format(ret) + " " + s[idx];
         } else {
              retFormat += " " + s[0];
         }

         return retFormat;
	}

	/**
	 * Package Type을 반환
	 *   - standard : 모든 모듈 포함
	 *   - basic : 메일, 주소록, 일정, 게시판, 직원조회만 포함
	 *   - mail : 메일, 주소록만 포함
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public String getPackageType(int tenantId) throws Exception {
		String packageType = "standard";
		
		String licenseKey = ezCommonService.getTenantConfig("LicenseKey", tenantId);
		
		logger.debug("licenseKey=" + licenseKey);
		
		if (!licenseKey.equals("")) {
			try {
				// 라이센스키를 복호화한다.
				licenseKey = egovFileScrty.decryptAES(licenseKey);
				
				logger.debug("Decrypted licenseKey=" + licenseKey);
				
				String items[] = licenseKey.split(":");

				if (items.length >= 3) {
					packageType = items[2];					
				}
			} catch (Exception e) {
				logger.debug("License Key Decryption failed.");
			}			
		}
		
		logger.debug("packageType=" + packageType);
		
		return packageType;
	}
	
    public void resetLoginFailAttempts(String userID, int tenantID) {
    	try {
	    	String userLoginFailedAttempt = ezCommonService.getUserConfigInfo(tenantID, userID, "LoginFailCount"); 
	    	
			if (userLoginFailedAttempt.equals("")) {
				//User hasn't logged in fail yet
				return;
			} else {
				// LoginFailCount 가 0이 아닌 경우 0으로 초기화한다.
				if (!userLoginFailedAttempt.equals("0")) {
					//Reset the number to 0
					ezCommonService.updateUserConfigInfo(tenantID, userID, "LoginFailCount", "0");
				}
			}
		// Exception이 발생하는 경우엔 로그를 출력한다.
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }

	//파일 경로로 xmlDocument 읽어오
	public Document xmlLod(String pDocPath) throws Exception {
		Document xmlDoc = null;
		try {
	       	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setValidating(false);
			factory.setNamespaceAware(true);
	
			DocumentBuilder builder = factory.newDocumentBuilder();
			xmlDoc = builder.parse(new InputSource(pDocPath));
	    	
		} catch (Exception e) {
			System.out.println(e.getMessage());
			System.out.println(e.getStackTrace());
		}
		return xmlDoc;
	}
	
	/**
	 * globals.properties에 있는 
	 * DataBaseType을 반환
	 * */
	public String getDatabaseType() throws Exception {
		
		String props = "Globals.DbType";
		String dbType;
		
		dbType = globals.getProperty(props);
		
		logger.debug("getDatabase Type = " + dbType);
		
		return dbType;
	}

	/**
	/*
	 * 테넌트에 따른 설정정보 얻어오는 메서드
	 */
	public String getTenantConfigRest(String property, String userId, HttpServletRequest request) throws Exception {

		String gwServerUrl = config.getProperty("config.journalGWServerURL");
		String url = gwServerUrl + "/rest/ezcommon/configs";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("property", property)
		        .queryParam("userId", userId);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
				
		String status = resultBody.get("status").toString();
		
		String propertyValue = "";
		if (status.equals("ok")) {
			propertyValue = (String) resultBody.get("data");
		}
        
        return propertyValue;
    }
	
	//html entity unescape 메서드 2018-04-06 강민수92
	public String htmlUnescape(String html) throws Exception {
		logger.debug("htmlUnescape started");
		
		html = html.replace("&nbsp;", " ");
		html = html.replace("&quot;", "\"");
		html = html.replace("&#39;", "'");
		html = html.replace("&lt;", "<");
		html = html.replace("&gt;", ">");
		html = html.replace("&iexcl;", "¡");
		html = html.replace("&curren;", "¤");
		html = html.replace("&sect;", "§");
		html = html.replace("&ordf;", "ª");
		html = html.replace("&deg;", "°");
		html = html.replace("&plusmn;", "±");
		html = html.replace("&sup2;", "²");
		html = html.replace("&sup3;", "³");
		html = html.replace("&acute;", "´");
		html = html.replace("&mu;", "μ");
		html = html.replace("&para;", "¶");
		html = html.replace("&middot;", "·");
		html = html.replace("&cedil;", "¸");
		html = html.replace("&sup1;", "¹");
		html = html.replace("&ordm;", "º");
		html = html.replace("&frac14;", "¼");
		html = html.replace("&frac12;", "½");
		html = html.replace("&frac34;", "¾");
		html = html.replace("&iquest;", "¿");
		html = html.replace("&AElig;", "Æ");
		html = html.replace("&ETH;", "Ð");
		html = html.replace("&times;", "×");
		html = html.replace("&Oslash;", "Ø");
		html = html.replace("&THORN;", "Þ");
		html = html.replace("&szlig;", "ß");
		html = html.replace("&aelig;", "æ");
		html = html.replace("&eth;", "ð");
		html = html.replace("&divide;", "÷");
		html = html.replace("&oslash;", "ø");
		html = html.replace("&thorn;", "þ");
		html = html.replace("&amp;", "&");
		
		String result = html;
		
		logger.debug("html result : " + result); 
		logger.debug("htmlUnescape ended");
		return result;
		
	}
	
	/**
	 * 레스트 API에서 제이슨 오브젝트 넘겨 받는 메서드
	 * @param resteUrl
	 * @param param
	 * @param request
	 * @return
	 */
	public JSONObject getJsonFromRestApi(String restUrl, Map<String, Object> param, HttpServletRequest request, String methodType, JSONObject jsonParam){
		logger.debug("getJsonFromRestApi started");
		String gwServerUrl = config.getProperty("config.journalGWServerURL");
		String url = gwServerUrl + restUrl ;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(jsonParam, headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		if (param != null) {
			for(String key : param.keySet()){
				builder.queryParam(key, param.get(key));
			}
		}
		
		RestTemplate rest = new RestTemplate();
		
		HttpMethod method = null;
		switch (methodType) {
		case "get":
			method = HttpMethod.GET;
			break;
		case "put":
			method = HttpMethod.PUT;
			break;
		case "post":
			method = HttpMethod.POST;
			break;
		case "delete":
			method = HttpMethod.DELETE;
			break;
		default:
			method = HttpMethod.GET;
			break;
		}
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), method, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = null;
		
		try {
			resultBody = (JSONObject) jp.parse(result.getBody());
		} catch (org.json.simple.parser.ParseException e) {
			e.printStackTrace();
		}
		logger.debug("getJsonFromRestApi ended");
		return resultBody;
	}
	
	/**
	 * 첨부파일명이 자소분리된 형태로 나올경우, 자소결합
	 * @param filename
	 * @return String
	 */
	public String normalizeFileName (String filename) {
		logger.debug("normalizeFileName started");
		logger.debug("filename=" + filename);
		
		String nfcFilename =  Normalizer.normalize(filename, Normalizer.Form.NFC);
		
		logger.debug("nfcFilename=" + nfcFilename);
		logger.debug("normalizeFileName ended");
		return nfcFilename;
	}
	
	public String getUniqueFileName(String fileName, Map<String, Integer> fileNameMap) {
		String fileNameLowerCase = fileName.toLowerCase();
		String fileNameWithoutExt = null;
		String ext = null;
		int extIndex = fileName.lastIndexOf(".");
		
		if (extIndex > 0) {
			fileNameWithoutExt = fileName.substring(0, extIndex);
			ext = fileName.substring(extIndex);
		} else {
			fileNameWithoutExt = fileName;
			ext = "";
		}
		
		if (fileNameMap.containsKey(fileNameLowerCase)) {
			int count = fileNameMap.get(fileNameLowerCase);
			
			while (true) {
				if (!fileNameMap.containsKey((fileNameWithoutExt + " (" + ++count + ")" + ext).toLowerCase())) {
					break;
				}
			}
			
			fileNameMap.put(fileNameLowerCase, count);
			fileName = fileNameWithoutExt + " (" + count + ")" + ext;
			fileNameMap.put(fileName.toLowerCase(), 0);
		} else {
			fileNameMap.put(fileNameLowerCase, 0);
		}
		
		return fileName;
	}
	
	//Baonk: Get user's infor from parameters
	public LoginVO getUserForGw(String userId, String serverName) {
		try{
			int tenantId  = loginService.getTenantId(serverName);
			LoginVO login = new LoginVO();
			login.setId(userId);
			login.setDn("NOPASSWORD");
			login.setTenantId(tenantId);
			
			LoginVO user    = loginService.selectUser(login);
			String userLang = ezCommonService.selectUserGetLang(userId, tenantId);
			String timeZone = ezCommonService.selectUserGetTimeZone(userId, tenantId);
			user.setOffset(timeZone);
			
			if (userLang != null) {
				if (user.getPrimary().equals(userLang)) {
					user.setPrimary("1");
				}
				else {
					user.setPrimary("2");
				}
			}
			
			return user;
		}
		catch(Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * 레스트 API에서 제이슨 오브젝트 넘겨 받는 메서드
	 * @param resteUrl
	 * @param param
	 * @param request
	 * @return
	 */
	public JSONObject getJsonFromWebFolderRestApi(String restUrl, Map<String, Object> param, HttpServletRequest request, String methodType, JSONObject jsonParam){
		logger.debug("getJsonFromWebFolderRestApi started");
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + restUrl ;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(jsonParam, headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		if (param != null) {
			for(String key : param.keySet()){
				builder.queryParam(key, param.get(key));
			}
		}
		
		RestTemplate rest = new RestTemplate();
		
		HttpMethod method = null;
		switch (methodType) {
		case "get":
			method = HttpMethod.GET;
			break;
		case "put":
			method = HttpMethod.PUT;
			break;
		case "post":
			method = HttpMethod.POST;
			break;
		case "delete":
			method = HttpMethod.DELETE;
			break;
		default:
			method = HttpMethod.GET;
			break;
		}
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), method, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = null;
		
		try {
			resultBody = (JSONObject) jp.parse(result.getBody());
		} catch (org.json.simple.parser.ParseException e) {
			e.printStackTrace();
		}
		logger.debug("getJsonFromWebFolderRestApi ended");
		return resultBody;
	}
}
