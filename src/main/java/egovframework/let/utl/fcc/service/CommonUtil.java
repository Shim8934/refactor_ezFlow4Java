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

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.OutputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigInteger;
import java.net.URI;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.DecimalFormat;
import java.text.Normalizer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Objects;
import java.util.Properties;
import java.util.Random;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
//import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.logging.log4j.util.Strings;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.XML;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.i18n.CookieLocaleResolver;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.web.util.WebUtils;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import com.unidocs.workflow.client.WFJob;
import com.unidocs.workflow.common.FileEx;
import com.unidocs.workflow.common.JobResult;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.service.EzCommonService.Device;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.SessionVO;
import egovframework.let.utl.rest.Rest;
import egovframework.let.utl.rest.Rest.Module;
import egovframework.let.utl.rest.Result;
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
	/*
	Copyright (c) 2008-2020, Harald Kuhr
		All rights reserved.

		Redistribution and use in source and binary forms, with or without
		modification, are permitted provided that the following conditions are met:

		o Redistributions of source code must retain the above copyright notice, this
		list of conditions and the following disclaimer.

		o Redistributions in binary form must reproduce the above copyright notice,
		this list of conditions and the following disclaimer in the documentation
		and/or other materials provided with the distribution.

		o Neither the name of the copyright holder nor the names of its
		contributors may be used to endorse or promote products derived from
		this software without specific prior written permission.

		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
		AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
		IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
		DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
		FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
		DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
		SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
		CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
		OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
		OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	*/
@Component
public class CommonUtil {
	
	public static final String PT_MAIL = "mail";
	public static final String PT_BASIC = "basic";
	public static final String PT_STANDARD = "standard";
	public static final int MARIADB = 1;
	public static final int ORACLE = 2;
	
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
	
	@Resource(name="EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;
	
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;    
	
	@Resource(name = "jspw")
    private String jspw;

	@Resource(name = "EzNewPortalService")
	private EzNewPortalService ezNewPortalService;
	
	@Autowired
	private EzWebFolderService ezWebFolderService;
	
	@Autowired
	private KlibUtil kilbUtil;
	
	@Autowired
	private Rest rest;

	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;

	Document emptyDocument;

	/* File separator 공통 함수 */
	public String separator = "/";
	
	public final String CRLF = "\r\n";
	
	private static final Logger logger = LoggerFactory.getLogger(CommonUtil.class);
	private static CommonUtil commonUtilInstance;
	
//	private static Map<String, String> loginUsers;
	
    @PostConstruct
	public void init() throws Exception {
    	logger.debug("init started.");

    	commonUtilInstance = this;

		emptyDocument = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
    	
    	logger.debug("init ended.");
    }

    /**
     * Path Traversal 공격을 방지하기 위해 filePath에 ../ 혹은 ..\ 패턴이 있으면
     * 예외를 발생시킨다.  
     * @param filePath
     * @return
     * @throws Exception
     */
    public String detectPathTraversal(String filePath) throws Exception {
    	if (filePath != null && !filePath.isEmpty()) {
	    	String parentFolder1 = "../";
	    	String parentFolder2 = "..\\";
	    	
	    	if (filePath.contains(parentFolder1) || filePath.contains(parentFolder2) || filePath.toUpperCase().contains("WEB-INF")) {
	    		logger.debug("PathTraversal detected. filePath=" + filePath);
	    		
	    		throw new Exception("PathTraversal detected.");
	    	}
    	}
    	
    	return filePath;
    }
    
	/** 
	 * strip <object>,<applet>,<script> tags
	 */	
    public String stripScriptTags(String src) {
		Pattern p = Pattern.compile("<(object|applet|script).*?>|</(object|applet|script).*?>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(src);
		src = m.replaceAll("");
				
		return src;		
	}

    public Matcher getMatcherForStripScriptTagsAndFunctions(String src) {
		// dhlee: 20240420 - ( 뿐 아니라 ` 기호일 때도 alert 함수가 실행되어 ` 문자도 추가함
		// dhlee: 20240718 - (가 &#40;로 변경된 경우가 있어 &#40;와 &#41;에 대한 처리를 추가함
		Pattern p = Pattern.compile("<(object|applet|script).*?>|</(object|applet|script).*?>|alert([ ]*?/\\*.*?\\*/[ ]*?)?[(`].*?[)`]|alert([ ]*?/\\*.*?\\*/[ ]*?)?&#40;.*?&#41;|confirm([ ]*?/\\*.*?\\*/[ ]*?)?[(`].*?[)`]|confirm([ ]*?/\\*.*?\\*/[ ]*?)?&#40;.*?&#41;|prompt([ ]*?/\\*.*?\\*/[ ]*?)?[(`].*?[)`]|prompt([ ]*?/\\*.*?\\*/[ ]*?)?&#40;.*?&#41;|window.*?location",
						Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		return p.matcher(src);
	}
    
	public String stripScriptTagsAndFunctions(String src) {
		if (src != null && !src.isEmpty()) {
			Matcher m = getMatcherForStripScriptTagsAndFunctions(src);
	        src = m.replaceAll("");
    	}

        return src;
    }

    public boolean hasStripScriptTagsAndFunctions(String src) {
		Matcher m = getMatcherForStripScriptTagsAndFunctions(src);
		boolean result = m.matches();

		if (result) {
			logger.debug("src={}", src);
		}

		return result;
	}

	public String stripTagSymbols(String src) {
		if (src != null && !src.isEmpty()) {
			src = src.replaceAll("<", "").replaceAll(">", "");
		}

		return src;
	}

	public String convertTagSymbols(String src) {
		if (src != null && !src.isEmpty()) {
			src = src.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
		}

		return src;
	}

	public byte[] readBytesFromFile(Path path) throws IOException {
		String pathStr = path.toString();

		logger.debug("readBytesFromFile path=" + pathStr);

		File file = new File(pathStr);
		byte[] content = new byte[(int)file.length()];
		FileInputStream fin = null;		

		try {
			fin = new FileInputStream(file);
			fin.read(content);
		} catch (IOException e) {		
			throw e;
		} finally {
			if (fin != null) {
				fin.close();
			}
		}

		logger.debug("readBytesFromFile ended. path=" + pathStr);

		return content;
    }

    public void writeBytesToFile(Path path, byte[] content) throws IOException {
		String pathStr = path.toString();

		logger.debug("writeBytesToFile path=" + pathStr);

		FileOutputStream fout = null;

		try {
			fout = new FileOutputStream(pathStr);
			fout.write(content);
		} catch (IOException e) {		
			throw e;
		} finally {
			if (fout != null) {
				fout.close();
			}
		}

		logger.debug("writeBytesToFile ended. path=" + pathStr);
	}

	public LoginVO userInfo(String loginCookie){
		if (StringUtils.isEmpty(loginCookie)) {
			return new LoginVO();
		}

		try{
			String decData = getDecryptedLoginCookie(loginCookie);

			String[] decDataArray = decData.split("///", -1);
			String serverName = decDataArray[0];
			String userID = decDataArray[1];
			String locale = decDataArray[5];
			String lang = decDataArray[6];
			String timeZone = decDataArray[7];
			
            String tenantIdStr = "0";
            
            String deptID = "";
			String companyID = "";
			String jobID = "";
			String roleID = "";

            if (decDataArray.length >= 9) {
                tenantIdStr = decDataArray[8];	
            }
            if(decDataArray.length >= 10) {
            	deptID = decDataArray[9];
            }
			if(decDataArray.length >= 11) {
				companyID = decDataArray[10];
			}
			if(decDataArray.length >= 12) {
				jobID = decDataArray[11];
			}
			if(decDataArray.length >= 13) {
				roleID = decDataArray[12];
			}
			
			LoginVO login = new LoginVO();
			login.setId(userID);
			login.setDn("NOPASSWORD");
			login.setTenantId(Integer.parseInt(tenantIdStr));
			login.setDeptID(deptID);
			login.setCompanyID(companyID);
			login.setJobId(jobID);
			login.setRoleId(roleID);
			
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
		}catch(Exception e) {
			return new LoginVO();
		}
	}
	
	public LoginSimpleVO userInfoSimple(String loginCookie) {
		try{
			String decData = getDecryptedLoginCookie(loginCookie);

			String[] decDataArray = decData.split("///", -1);
			
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
	
	public String getDecryptedLoginCookie(String loginCookie) {
		String decData = "";

		try {
			if (loginCookie.length() == 36) {
				String ezSessionId = loginCookie;
				SessionVO resultVO = loginService.getSession(ezSessionId);

				decData = egovFileScrty.decryptAES(resultVO.getLoginCookie());

			} else {
				decData = egovFileScrty.decryptAES(loginCookie);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return decData;
	}
	
	public List<Integer> getTenantIdList() {
		try {
			List<Integer> list = loginService.getTenantIdList();
			return list;
		} catch (Exception e) {
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
					user.setDeptID(URLDecoder.decode(cookie[k].getValue(), "utf-8"));
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
					user.setCompanyID(URLDecoder.decode(cookie[k].getValue(), "utf-8"));
					break;
				case "APRUI8":
					user.setJobId(URLDecoder.decode(cookie[k].getValue(), "utf-8"));
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

			// 2023-07-31 전인하 - 겸직/부서 별 권한 설정 기능 옵션 사용 시 권한정보 호출 분기처리
			if (ezCommonService.getTenantConfig("permissionBasisDeptYN", user.getTenantId()).equals("Y") && ezOrganAdminService.isThisAddJob(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId()).equals("Y")) {
				String rollInfo = ezOrganService.getRollInfoBasisDept(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
				if (rollInfo != null && ! rollInfo.equals("")) {
					user.setRollInfo(rollInfo);
				}
			}
			
			logger.debug("aprUserInfo ended");
			
			return user;
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			return new LoginVO();
		}
	}

	public LoginVO checkAdminOld(String loginCookie){
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
	
	public LoginVO checkAdmin(String loginCookie){
		try{
			LoginVO user = userInfo(loginCookie);
			
			// ezSyncServer가 ezFlow를 호출하는 경우엔 loginCookie에 부서 아이디가 없어
			// 이 경우엔 이전 방식으로 관리자 권한을 체크하도록 함
			if (user.getDeptID() == null || user.getDeptID().isEmpty()) {
				return checkAdminOld(loginCookie);
			}
			
			OrganAuth organAuth = makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
	
			if (organAuth.isAuth(AdminAuth.ADMIN_MASTER)) {
				return user;
			} else if (organAuth.isAuth(AdminAuth.COMPANY_MANAGER)){
				return user;
			} else {
				return null;
			}
		}catch(Exception e){
			return null;
		}
	}
	
	public LoginVO aprCheckAdmin(String loginCookie){
		try{
			LoginVO user = aprUserInfo(loginCookie);
	
			if (!isAdmin(user.getId(), user.getTenantId(), user.getRollInfo(), "c;k")){
				return null;
			}else{
				return user;
			}
		}catch(Exception e){
			return null;
		}
	}
	
	// 2022-10-27 이사라 - 로그인 정보 저장
	public void updateLoginInfo(HttpServletRequest request, LoginVO loginVO) {
		logger.debug("updateLoginInfo started.");

		try {
			String sessionCode = request.getSession().getId();
			logger.debug("Login sessionCode = " + sessionCode);

			loginVO.setIp(ClientUtil.getClientIP(request));
			loginVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
			loginVO.setOs(ClientUtil.getClientInfo(request, "os"));
			loginVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));
			loginVO.setStatus("Y");
			loginVO.setSessionCode(sessionCode);

			if (loginVO.getTitle2() == null) {
				loginVO.setTitle2("");
			}

			loginService.updateUser(loginVO); // IP, loginCnt, 시간
			loginService.insertLog(loginVO); // 로그인히스토리 로그 저장

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("updateLoginInfo ended.");
	}

	public List<String> getUserIdAndPassword(String loginCookie) {
		try{
			String decData = getDecryptedLoginCookie(loginCookie);

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
			if (userAgentValue.contains("Trident") || userAgentValue.contains("Edge") || userAgentValue.contains("Chrome")) {
			    // "자동회신:"과 같이 :이 제목에 포함되어 있는 경우 메일 저장하기 시, 한글파일명 깨지는 문제가 있어
			    // :를 %3A로 변경한 후 URI 인코딩을 수행함. 
				filename = filename.replaceAll(":", "%3A");
				URI uri = new URI(null, null, filename, null);
				filename = uri.toASCIIString();
				// %3A에서 %가 %25로 인코딩되므로 다시 %3A로 변경함.
				filename = filename.replaceAll("%253A", "%3A");
				
                if (userAgentValue.contains("Chrome")) {
                    filename = filename + "\"" + "; filename*=UTF-8''\"" + filename;
                }				
			}
			// in case of Chrome, Safari
			// the filename consists of UTF-8 encoded bytes.
			else {
				filename = new String(filename.getBytes("UTF-8"), "ISO-8859-1");
			}
		} catch (Exception e) {			
			logger.error(e.getMessage(), e);
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
	
	public static String addVer(ServletContext application, String filePath) {		
		File fileObj = new File(application.getRealPath(filePath));
		
		if (fileObj.exists()) {
			Date lastDate = new Date(fileObj.lastModified());
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String version = sdf.format(lastDate);
			
			filePath += "?v=" + version;
		}
		
		return filePath;
	}
	
	public static String addVer(ServletContext application, HttpServletRequest request, String filePath) {
		String springMessage = "<spring:message";
		int startOfSpringMessage = filePath.indexOf(springMessage);
		
		if (startOfSpringMessage > -1) {
			String code = "code='";
			int startOfCode = filePath.indexOf(code, startOfSpringMessage + springMessage.length());
			
			if (startOfCode > -1) {
				int endOfCode = filePath.indexOf("'", startOfCode + code.length());
				
				if (endOfCode > -1) {
					String codeValue = filePath.substring(startOfCode + code.length(), endOfCode);					
					String msg = commonUtilInstance.egovMessageSource.getMessage(codeValue, new CookieLocaleResolver().resolveLocale(request));					
					int endOfSpringMessage = filePath.indexOf(">", endOfCode + 1); 
					
					if (endOfSpringMessage > -1) {
						filePath = filePath.substring(0, startOfSpringMessage) + msg
									+ filePath.substring(endOfSpringMessage + 1);
					}
				}
			}
		}
		
		File fileObj = new File(application.getRealPath(filePath));
		
		if (fileObj.exists()) {
			Date lastDate = new Date(fileObj.lastModified());
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String version = sdf.format(lastDate);
			
			filePath += "?v=" + version;
		}
		
		return filePath;
	}
	
	public boolean isLoginCookieExists(HttpServletRequest request, HttpServletResponse response) {
		boolean usingSession = false;

		try {
			String serverName = request.getServerName();
			int tenantID = loginService.getTenantId(serverName);
			String useSessionConfig = ezCommonService.getTenantConfig("useSession", tenantID);

			// 세션 콘피그가 0 이거나 비어있으면 세션 로그인 사용 안 함
			usingSession = !useSessionConfig.isEmpty() && !useSessionConfig.equals("0");
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			return false;
		}

		// 세션 콘피그를 무시하고 로그인 쿠키만으로 사용할 수 있도록 해줌
		boolean usingAsAPI = "yes".equalsIgnoreCase(request.getHeader("Use-As-API"));
		// request 아이피가 127.0.0.1 일 때는 세션 콘피그 무시함 (인사연동)
		boolean isLoopbackRequest = request.getRemoteAddr().equals("127.0.0.1");
		// useDbSession 체크가 이 부분에서 필수 요소는 아니나 예외처리 보강
		boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));

		if (!useDbSession && (!usingSession || usingAsAPI || isLoopbackRequest)) {
			return "0".equals(validLoginCookie(request, response));
		}

		return validSessionLoginCookie(request, response);
	}

	private String validLoginCookie(HttpServletRequest request,  HttpServletResponse response) {
		
		String result = "0"; //  0 : 유효한 쿠키 , 1 : 세션 만료 , 2 :  쿠키 만료 및 예외 , 3 :  부서 및 직위 등 조직도 정보 변경
		
		Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");

		if (loginCookie == null) {
			result = "2";
		}

		try {
			String ip = ClientUtil.getClientIP(request);
			String decryptedLoginCookie = getDecryptedLoginCookie(loginCookie.getValue());

			// 2024-09-02 - db 세션 사용 시에는 ip check 생략 함
			if ("YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"))) {
				return checkDeptId(decryptedLoginCookie) ? "0" : "3"; // 조직도 정보 변경 여부
			}

			// 복호화된 로그인 쿠키는 "///" 구분자로 여러 정보가 담겨있으며 그 중 4번째가 클라이언트의 IP이다.
			if(!decryptedLoginCookie.split("///")[3].equals(ip)){
				result = "2";
			} else {
				result = checkDeptId(decryptedLoginCookie) ? "0" : "3"; // 조직도 정보 변경 여부
			}
		} catch (Exception e) {
			clearAllCookies(request, response); // 오류발생 시 쿠키를 삭제하도록 수정
			logger.error(e.getMessage(), e);
		}

		return result;
	}

	private boolean validSessionLoginCookie(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession(false);
		boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));

		if (!useDbSession && session == null) {
			clearAllCookies(request, response);

			return false;
		}

		return "0".equals(validLoginCookie(request, response));
	}

	private void clearAllCookies(HttpServletRequest request, HttpServletResponse response) {
		Cookie[] cookies = request.getCookies();
		boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));

		if (cookies == null) {
			return;
		}

		for (Cookie cookie : cookies) {
			try {
				if (useDbSession || cookie.getName().equalsIgnoreCase("loginCookie")) {
					loginService.deleteSession(cookie.getValue());
				}
			} catch (Exception e) {
				// 본 오류에 상관없이 쿠키 제거 진행을 위해 try-catch로 묶음
			}

			if (!cookie.getName().equals("saveid") && !cookie.getName().matches("POPUP_.*") && !cookie.getName().matches("SURV_POPUP_.*")) {
				cookie.setMaxAge(0);
				cookie.setPath("/");
				response.addCookie(cookie);

				request.getSession().invalidate();
			}
		}
	}

	public boolean checkDeptId(String cValue){
		String[] decDataArray = cValue.split("///", -1);
		
		String userID = decDataArray[1];
        String tenantId = "0";
        String deptID = "";
		String jobID = "";
		
        if (decDataArray.length >= 9) {
            tenantId = decDataArray[8];	
        }
        if(decDataArray.length >= 10) {
        	deptID = decDataArray[9];
        }
		if(decDataArray.length >= 12) {
			jobID = decDataArray[11];
		}
		
        // ezSyncServer에서 ezFlow를 호출하는 경우에는 쿠키안에 부서 아이디가 포함되어 있지 않으므로
        // 이 경우엔 true를 반환한다.
        if ("".equals(deptID)) {
        	return true;
        }
        
		int isDept = ezCommonService.checkDeptId(userID, deptID, tenantId, jobID);
		
		if(isDept>0){
			return true;
		} else {
			logger.debug("checkDeptId isDept=" + isDept + ",userID=" + userID + ",deptID=" + deptID);
			
			return false;
		}
	}
	
	public Document convertStringToDocument(String xmlStr) {
		String replaceData = xmlStr.trim().replaceFirst("^([\\W]+)<","<");
		replaceData = replaceData.replace("&shy;", "");
		replaceData = replaceData.replace("\uffff", "");
		replaceData = replaceData.replaceAll("[\\u0000-\\u0008\\u000B-\\u000C\\u000E-\\u001F]", "");
		replaceData = replaceData.replace("\ufffe", ""); // 2022-10-25 이사라 - xml 데이터 파싱 오류 수정
		
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();  
        DocumentBuilder builder;
        Document doc = emptyDocument;
        
        try {  
            builder = factory.newDocumentBuilder();  
            doc = builder.parse(new InputSource(new StringReader(replaceData)));
        } catch (Exception e) {
        	logger.error(e.getMessage(), e);
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
			
		} catch(Exception e){logger.debug("e.message=" + e.getMessage());}
		
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
			return "";
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
		if (lang != null && !lang.equals(ezCommonService.getTenantConfig("PrimaryLang", tenantID))) {
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
	
	/**
	 * @param path 파일의 풀경로
	 * 파일의 최종 업데이트 날짜 가져오기
	 */
	public String getLastModifiedDate(String path) {
		Date lastDate = new Date(new File(path).lastModified());
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		
		return sdf.format(lastDate);
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
	
	public String cleanScriptValue(String htmlCode) {
		return stripScriptTagsAndFunctions(htmlCode);
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
		return getRealPath(request.getServletContext());
	}

	public String getRealPath(ServletContext servletContext) {
		String realPath = servletContext.getRealPath("");
		
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
			return "";
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
			} else if (dateStr.indexOf(".") > -1) {
				pattern = "yyyy-MM-dd HH:mm:ss";
			} else{
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
		
		return today;
	}
	
	/**
	 * offset 시간을 분으로 변환하는 함수	 
	 */
	public String getMinuteUTC(String offSet) throws Exception {
		//logger.debug("getMinuteUTC started"); // 로그정리
		
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
		if (langNum == null) {
			logger.error("langNum is null.");
			return null;
		}
		
		return getTwoLetterLangFromLangNum(langNum, "");
	}

	public String getTwoLetterLangFromLangNum(String langNum, String defaultValue) {
		String returnValue = defaultValue;

		if (langNum.equals("1")) {
			returnValue = "ko";
		} else if (langNum.equals("2")) {
			returnValue = "en";
		} else if (langNum.equals("3")) {
			returnValue = "ja";
		} else if (langNum.equals("4")) {
			returnValue = "zh";
		} else if (langNum.equals("5")) {
			returnValue = "vi";
		} else if (langNum.equals("6")) {
			returnValue = "id";
		} else {
			logger.error("Invalid langNum.");
		}
		
		return returnValue;
	}
	
	public String getLangNumFromTwoLetterLang(String twoLetterLang, int tenantId) {
		String returnValue = "";
		
		if (twoLetterLang == null) {
			logger.error("twoLetterLang is null.");
			return null;
		}

		String useJapanese = "";
		String useChinese = "";
		String useVietnamese = "";
		String useIndonesian = "";
		
		try {
			useJapanese = ezCommonService.getTenantConfig("useJapanese", tenantId);
			useChinese = ezCommonService.getTenantConfig("useChinese", tenantId);
			useVietnamese = ezCommonService.getTenantConfig("useVietnamese", tenantId);
			useIndonesian = ezCommonService.getTenantConfig("useIndonesian", tenantId);
		} catch (DataAccessException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		// 2018-02-28 skyblue0o0 : 중국어(zh)는 아직 지원하지 않으므로 주석처리
		// 첫 로그인 시 브라우저의 언어로 사용자 언어가 세팅되기 때문에 문제가 생길 수 있음.
		if (twoLetterLang.equalsIgnoreCase("ko")) {
			returnValue = "1";
		} else if (twoLetterLang.equalsIgnoreCase("en")) {
			returnValue = "2";
		} else if (twoLetterLang.equalsIgnoreCase("ja") && "YES".equalsIgnoreCase(useJapanese)) {
			returnValue = "3";
		} else if (twoLetterLang.equalsIgnoreCase("zh") && "YES".equalsIgnoreCase(useChinese)) {
			returnValue = "4";
		} else if (twoLetterLang.equalsIgnoreCase("vi") && "YES".equalsIgnoreCase(useVietnamese)) {
			returnValue = "5";
		} else if (twoLetterLang.equalsIgnoreCase("id") && "YES".equalsIgnoreCase(useIndonesian)) {
			returnValue = "6"; 
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
		
		//logger.debug("licenseKey=" + licenseKey); // 로그정리
		
		if (!licenseKey.equals("")) {
			try {
				// 라이센스키를 복호화한다.
				licenseKey = egovFileScrty.decryptAES(licenseKey);
				
				//logger.debug("Decrypted licenseKey=" + licenseKey);
				
				String items[] = licenseKey.split(":");

				if (items.length >= 3) {
					packageType = items[2];					
				}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				logger.debug("License Key Decryption failed.");
			}			
		}
		
		logger.debug("packageType={}, licenseKey={}", packageType, licenseKey);
		
		return packageType;
	}
	
	// yy tenantID로 db에 있는것만 복호화하는게 아니고 요청된 licenseKey를 복호화하는 기능
	public String licenseKeyDEC(String licenseKey) throws Exception {
		String packageType = "standard";
		
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
				logger.error(e.getMessage(), e);
				logger.debug("License Key Decryption failed.");
			}			
		}
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
    		logger.error(e.getMessage(), e);
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
	 * 테넌트에 따른 설정정보 얻어오는 메서드
	 */
	public String getTenantConfigRest(String property, String userId, HttpServletRequest request) throws Exception {
		Result result = rest.gateway(Module.JOURNAL, request)
				.url("/rest/ezcommon/configs")
				.queryParam("property", property)
				.queryParam("userId", userId)
				.exchangeResult();

		return result.succeeded() ? result.getData(String.class) : "";
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
		html = html.replace("&#034;", "\"");
		html = html.replace("&#039;", "'");
		
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
		JSONObject resultBody = null;
		
		try{
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
			
			RestTemplate rest = null;
			
			if (methodType.equals("patch")) {
				ClientHttpRequestFactory httpRequestFactory = new HttpComponentsClientHttpRequestFactory();
				rest = new RestTemplate(httpRequestFactory);
			} else {
				rest = new RestTemplate();
			}
			
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
			case "patch":
				method = HttpMethod.PATCH;
				break;
			default:
				method = HttpMethod.GET;
				break;
			}
			ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), method, entity, String.class);
			
			JSONParser jp = new JSONParser();
			
			
			try {
				resultBody = (JSONObject) jp.parse(result.getBody());
			} catch (org.json.simple.parser.ParseException e) {
				logger.error(e.getMessage(), e);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
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
				count = Math.addExact(count, 1);

				if (!fileNameMap.containsKey((fileNameWithoutExt + " (" + count + ")" + ext).toLowerCase())) {
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
			user.setLang(userLang);
			
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
			logger.error(e.getMessage(), e);
			return new LoginVO();
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
			logger.error(e.getMessage(), e);
		}
		logger.debug("getJsonFromWebFolderRestApi ended");
		return resultBody;
	}
	
	public String getMailPassword() {
		String pass = jspw;
		return pass;
	}
	
	/**
	 * 레스트 API에서 제이슨 오브젝트 넘겨 받는 메서드
	 * 
	 * @param resteUrl
	 * @param param
	 * @param request
	 * @return
	 */
	public JSONObject getJsonFromRestApi(String gwServerUrl, String restUrl, Map<String, Object> param, HttpServletRequest request, String methodType, JSONObject jsonParam) {
		return getJsonFromRestApi(gwServerUrl, restUrl, param, request, methodType, jsonParam, -1, -1);
	}

	/**
	 * 레스트 API에서 제이슨 오브젝트 넘겨 받는 메서드
	 * @param resteUrl
	 * @param param
	 * @param request
	 * @return
	 */
	public JSONObject getJsonFromRestApi(String gwServerUrl, String restUrl, Map<String, Object> param, HttpServletRequest request, String methodType, JSONObject jsonParam, int connectionTimeout, int readTimeout) {
		logger.debug("getJsonFromRestApi started.");
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
		
		RestTemplate rest = null;
		
		if (methodType.equals("patch")) {
			ClientHttpRequestFactory httpRequestFactory = new HttpComponentsClientHttpRequestFactory();
			rest = new RestTemplate(httpRequestFactory);
		} else if (connectionTimeout > 0 || readTimeout > 0) {
			HttpComponentsClientHttpRequestFactory httpRequestFactory = new HttpComponentsClientHttpRequestFactory();
			httpRequestFactory.setConnectTimeout(connectionTimeout);
			httpRequestFactory.setReadTimeout(readTimeout);
			rest = new RestTemplate(httpRequestFactory);
		} else {
			rest = new RestTemplate();
		}
		
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
		case "patch":
			method = HttpMethod.PATCH;
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
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("getJsonFromRestApi ended.");
		return resultBody;
	}

	public JSONObject getJsonFromMemoRestApi(String restUrl, Map<String, Object> param, HttpServletRequest request, String methodType, JSONObject jsonParam){
		logger.debug("getJsonFromMemoRestApi started");
		String gwServerUrl = config.getProperty("config.memoGwServerURL");
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
			logger.error(e.getMessage(), e);
		}
		logger.debug("getJsonFromMemoRestApi ended.");
		return resultBody;
	}
	
	public String getWildcardEscapedString(String s, int dbName) {
		if (dbName == ORACLE) {
			if ((s.indexOf('%') == -1) && (s.indexOf('_') == -1) && (s.indexOf('\\') == -1)) {
				return s;
			}
		} else {
			if ((s.indexOf('%') == -1) && (s.indexOf('_') == -1)) {
				return s;
			}
		}
		
		StringBuilder sb = new StringBuilder();
		
		if (dbName == ORACLE) {
			for (int i = 0; i < s.length(); i++) {
				char c = s.charAt(i);

				if (c == '%' || c == '_' || c == '\\') {
					sb.append('\\');
				}

				sb.append(c);
			}
		} else {
			for (int i = 0; i < s.length(); i++) {
				char c = s.charAt(i);

				if (c == '%' || c == '_') {
					sb.append('\\');
				}

				sb.append(c);
			}
		}

		return sb.toString();
	}
	
	public Map<String, Object> transBean2Map(Object obj) {
	    Map<String, Object> map = new HashMap<>();
	    
	    if (obj == null) {
	        return map;
	    }
	    
	    try {
	        BeanInfo beanInfo = Introspector.getBeanInfo(obj.getClass());
	        PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
	        
	        for (PropertyDescriptor property : propertyDescriptors) {
	            String key = property.getName();
	            
	            if (!key.equals("class")) {
	                Method getter = property.getReadMethod();
	                Object value = getter.invoke(obj);
	                map.put(key, value);
	            }
	        }
	    } catch (Exception e) {
	        logger.error("transBean2Map Error " + e);
	    }
	    
	    return map;
	}
	
	/**
	 * returns a string containing size with a size unit(MB or KB or B) 
	 */
	public String getSizeWithUnit(double size) {		
		String strSize;

		if (size > 1024 * 1024) {
			strSize = Math.floor(size / 1024 / 1024 * 10) / 10 + "MB";
		} else if (size > 1024) {
			strSize = (int)(size/1024) + "KB";
		} else {
			strSize = (int)size + "B";
		}

		return strSize;
	}
	
	public void setLoginUsers(int tenantID, String companyId, String userID, String loginTime, Device deviceType) throws Exception {
		ezCommonService.setMultiLoginUser(tenantID, companyId, userID, loginTime, deviceType);
	}
	
	public boolean checkMultiLogin(HttpServletRequest request, HttpServletResponse response) {
		boolean result = true;
		
		Cookie [] cookies = request.getCookies();
		Cookie loginCookie = null;
		Cookie multiLoginCookie = null;
		String useMultiLogin = "YES";
		
		try {
			if(!request.getRequestURI().equals("/user/login/actionLogout.do") && cookies != null) {
				for(Cookie cookie : cookies) {
					if(cookie.getName().equals("loginCookie")) {
						loginCookie = cookie;
					} else if(cookie.getName().equals("multiLoginCookie")) {
						multiLoginCookie = cookie;
					}
				}
				
				if(loginCookie != null) {
					String decryptedLoginCookie = getDecryptedLoginCookie(loginCookie.getValue());

					String[] cookieInfo = decryptedLoginCookie.split("///");

					if(cookieInfo.length <  11) {
						return result;
					}
					
					String userID = cookieInfo[1];
					String companyID = cookieInfo[10];
					int tenantID = Integer.parseInt(cookieInfo[8]);
					
					logger.debug("MultiLogin::: userID = " + userID + ", companyID = " + companyID + ", tenantID = " + tenantID);
					
					if(companyID.equals("")) { 
						return result;
					}
					
					useMultiLogin = ezCommonService.getCompanyConfig(tenantID, companyID, "useMultiLogin");
					
					if(useMultiLogin.equalsIgnoreCase("NO") && !Objects.isNull(multiLoginCookie)) { // 2023-05-17 이사라 : NullPointerException 시큐어코딩
						result = ezCommonService.matchMultiLoginTime(tenantID, companyID, userID, multiLoginCookie.getValue(), Device.PC);
					} 
				} else {
					if(multiLoginCookie != null) {
						result = false;
					}
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			logger.debug("multilogin fail::: loginCookie = " + loginCookie);
		}
		
		return result;
	}
	
	/** 
	 * <p>
	 * 자동 발신 알림 메일 내용 생성<br>
	 * 메일로 보낼 내용을 받아서 에디터 기본 폰트스타일과 감싸는 태그를 붙여 리턴함
	 * </p>
	 * @param content
	 * @param tenantID
	 * @param locale
	 * @return 완성된 html 태그 스트링
	 */
	public String createNotiMailContent(String content, int tenantID, Locale locale) throws Exception {
		String fontFamily = egovMessageSource.getMessage("main.t246", locale);
		String fontSize = "13px";
		
		String fontStyle = ezCommonService.getTenantConfig("editorFontStyle", tenantID);
		if(!ObjectUtils.defaultIfNull(fontStyle, "").isEmpty()) {
			String [] dividedFontStyle = fontStyle.split("\\|");

			fontFamily = dividedFontStyle[0];
			if (dividedFontStyle.length >= 2 ){
				fontSize = dividedFontStyle[1];
			}

		}
		
		return String.format("<DIV id=\"msgBody\" style=\"font-size: %s; font-family: %s;\" name=\"urn:schemas:httpmail:textdescription\">%s</DIV>", fontSize, fontFamily, content);
	}

	/** 
	 * <p>
	 * 자동 발신 알림 메일 내용 생성:승인메일용<br>
	 * 메일로 보낼 내용을 받아서 에디터 기본 폰트스타일과 감싸는 태그를 붙여 리턴함
	 * </p>
	 * @param content
	 * @param tenantID
	 * @param locale
	 * @return 완성된 html 태그 스트링
	 */
	public String createNotiMailContentForApprMail(String content, int tenantID, Locale locale) throws Exception {
		return String.format("<DIV id=\"msgBody\" style=\"padding: 10px 0;margin: 40px 0 20px;background:#E4F2FF;border-radius:5px;color: #004B8E;font-size: 18px;text-align: center;width: 80%%;font-weight: 400;font-family: 'Noto Sans KR','Malgun Gothic', 맑은 고딕, Dotum,돋움, Gulim, 굴림, Arial, Helvetica, sans-serif;\"  name=\"urn:schemas:httpmail:textdescription\">%s</DIV>", content);
	}
	
	public List<CountryVO> getCountryInfo(String ip) throws Exception {
		List<CountryVO> countryInfo = new ArrayList<CountryVO>();
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
    		String[] iparr = ip.split("\\.");
    		
    		long changeIp = (long) Math.pow(256, 3) * Integer.parseInt(iparr[0])
    				+ (long) Math.pow(256, 2) * Integer.parseInt(iparr[1])
    				+ (long) Math.pow(256, 1) * Integer.parseInt(iparr[2])
    				+ (long) Math.pow(256, 0) * Integer.parseInt(iparr[3]);
    		
    		logger.debug("changeIp=" + changeIp);
    		map.put("changeIp", changeIp);
    		
    		countryInfo = ezCommonService.getCountryInfo(map);
		
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return countryInfo;
	}
	
	public Boolean checkLocalIP (String ip) {
		Boolean result = false;
		
		if (ip.startsWith("10.") || ip.startsWith("127.") || ip.startsWith("192.168.") || ip.startsWith("169.254.") || ip.startsWith("0:")) {
			result = true;
		} else {
			String[] iparr = ip.split("\\.");
			long changeIp = 0;
			
			// 172.16.0.0 ~ 172.31.255.255
			changeIp = (long) Math.pow(256, 3) * Integer.parseInt(iparr[0])
    				+ (long) Math.pow(256, 2) * Integer.parseInt(iparr[1])
    				+ (long) Math.pow(256, 1) * Integer.parseInt(iparr[2])
    				+ (long) Math.pow(256, 0) * Integer.parseInt(iparr[3]);
			if (changeIp >= 2886729728L && changeIp <= 2887778303L) {
				result = true;
			}
		}
		
		return result;
	}
	
	/**
	 * 암호 정책관리 체크 : 결과값 ENUM 객체
	 */
	public enum PasswordCheckPolicyResult {
		// OK
		SUCCESS("OK", 0, "you can use it."),
		DISABLE_PASSWORD_POLICY("OK", 1, "The password policy is empty."),
		DISABLE_PASSWORD_POLICY_CONFIG("OK", 2, "usePasswordPatternPolicy config is 'NO'"),
		DISABLE_PASSWORD_POLICY_PATTERN("OK", 3, "The password policy pattern is empty."),
		// ERROR (음수)
		ERROR("ERROR", -1, "This password is not allowed."),
		CAPITAL_LETTERS_NOT_ALLOWED("ERROR", -2, "Capital letters not allowed. (useEngCapitalLetter)"),
		SMALL_LETTERS_NOT_ALLOWED("ERROR", -3, "Small letters not allowed. (useEngSmallLetter)"),
		NUMBERS_NOT_ALLOWED("ERROR", -4, "Numbers not allowed. (useNumber)"),
		SPECIAL_CHARACTERS_NOT_ALLOWED("ERROR", -5, "Special characters not allowed. (useSpecial)"),
		CURRENT_PATTERN_CNT_NOT_ALLOWED("ERROR", -6, "When current patterns are used not available. (NUMBER_OF_CHAR == 0 : not use)"),
		CHARACTERS_NOT_SUFFICIENT("ERROR", -7, "Characters of the required pattern are not sufficient. (NUMBER_OF_CHAR > pwStr)"),
		EASY_NUMBERS_NOT_ALLOWED("ERROR", -8, "NUMBERERROR"),
		PERSONAL_INFO_NUMBERS_NOT_ALLOWED("ERROR", -9, "NUMBERERROR"),
		USE_PREVIOUS_PASSWORD_NOT_ALLOWED("ERROR", -10, "PREVERROR");

		private final String status;
		private final int code;
		private final String message;

		PasswordCheckPolicyResult(String status, int code, String message) {
			this.status = status;
			this.code = code;
			this.message = message;
		}

		public String getStatus() {
			return status;
		}

		public int getCode() {
			return code;
		}

		public String getMessage() {
			return message;
		}

		public boolean succeeded() {
			return "OK".equalsIgnoreCase(status);
		}
	}

	/** 암호 정책관리 체크 : defalut */
	public PasswordCheckPolicyResult checkPwPolicy (String pwStr, String companyId, int tenantId, String userId) throws Exception {
		return checkPwPolicy(pwStr, companyId, tenantId, userId, true, null);
	}

	// 암호 정책관리 체크
	@SuppressWarnings("unchecked")
	public PasswordCheckPolicyResult checkPwPolicy (String pwStr, String companyId, int tenantId, String userId, boolean checkPrevPassword, Stream<String> propParams) throws Exception {
		logger.debug("commonUtil. checkPwPolicy Started.");
		logger.debug("pwStr={}, companyId={}, tenantId={}, userId={}", pwStr, companyId, tenantId, userId);

		PasswordCheckPolicyResult eResult = PasswordCheckPolicyResult.ERROR;
		process : {
			// 0-1. 2021-10-26 이사라 : 새비번이 prev비번과 일치하는지 chk 추가 (ezPersonal에서 → CommonUtil로 이전함)
			boolean useChkPrevPwd = "YES".equalsIgnoreCase(ezCommonService.getCompanyConfig(tenantId, companyId, "useChkPrevPwd"));

			if (checkPrevPassword && useChkPrevPwd && StringUtils.isNotBlank(userId)) {
				// 2024-07-17 김대현 : 가장 최근 암호 사용금지 -> 기억할 암호 수에 따른 사용금지 변경
				String encryptedNewPassword = EgovFileScrty.encryptPassword(pwStr, userId);
				String[] prevPasswords = ezCommonService.getPrevPwd(tenantId, userId).split(":");

				String rememberPWCountConfig = ezCommonService.getCompanyConfig(tenantId, companyId, "RememberPWCount");
				int rememberPWCount = rememberPWCountConfig == null || "".equalsIgnoreCase(rememberPWCountConfig) ? 0 : Integer.parseInt(rememberPWCountConfig);
				int startIdx = Math.max(0, prevPasswords.length - rememberPWCount);

				for (int i = prevPasswords.length - 1; i >= startIdx; i--) {
					String prevPassword = prevPasswords[i];
					
					if (encryptedNewPassword.equals(prevPassword)) {
						logger.debug("checkPrevPassword error - equals. : newDecryptPassword={}, prevPassword={}", pwStr, prevPassword);
						eResult = PasswordCheckPolicyResult.USE_PREVIOUS_PASSWORD_NOT_ALLOWED;
						break process;
					}
				}
//				for (String prevPassword : prevPasswords) {
//					if (encryptedNewPassword.equals(prevPassword)) {
//						logger.debug("checkPrevPassword error - equals. : newDecryptPassword={}, prevPassword={}", pwStr, prevPassword);
//						eResult = PasswordCheckPolicyResult.USE_PREVIOUS_PASSWORD_NOT_ALLOWED;
//						break process;
//					}
//				}
			}

			// 0-2. 2023-06-09 이사라 : 패스워드 설정 시 연속숫자, 생일, 전화번호 방지 기능
			boolean checkPasswordNumber = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("checkPasswordNumber", tenantId));

			if (checkPasswordNumber) {
				// 개인정보 가져오기
				String[] propArr = {"TELEPHONENUMBER", "MOBILE", "HOMEPHONE", "BIRTH"};
				Stream<String> propStream = Stream.of(propArr); // *참고 : 자바 Stream 정리 [Stream, Map, Filtering, Sorted, Collect] https://codenme.tistory.com/55

				// 1) 있으면 우선함.
				if (propParams != null) {
					propStream = propParams;

				// 2) userId가 공유사서함이라도 에러나지 않는다. 빈 값으로 반환함.
				} else if (StringUtils.isNotBlank(userId)) {
					String result = ezOrganService.getPropertyList(userId, String.join(";", propArr), "", tenantId);
					Document xmlDom = convertStringToDocument(result);
					propStream = propStream.map(prop -> xmlDom.getElementsByTagName(prop).item(0).getTextContent());

				// 3) propParams, userId 없으면 스킵
				} else {
					propStream = Stream.empty();
				}

				// 스트림은 한번만 소비할 수 있어서 List로 변환해둠. *참고 https://yeon-kr.tistory.com/192, https://devyoseph.tistory.com/156
				List<String> propList = propStream
						.map(prop -> StringUtils.defaultString(prop.replaceAll("\\D", "").trim()))
						.filter(StringUtils::isNotBlank)
						.collect(Collectors.toList());

				// 휴대폰번호가 "010"으로 시작하는 경우, "010"은 제외하고 비교
				if (propList.size() > 1 && propList.get(1).startsWith("010")) {
					propList.set(1, propList.get(1).substring(3));
				}

				// 패스워드 설정 시 연속숫자, 생일, 전화번호 방지 기능
				for (int i = 0; i < pwStr.length() - 2; i++) {
					if (Character.isDigit(pwStr.charAt(i))
							&& Character.isDigit(pwStr.charAt(i + 1))
							&& Character.isDigit(pwStr.charAt(i + 2))) {

						// 연속된 3자리 이상의 숫자 또는 같은 값이 발견되면 오류로 처리
						int num1 = Character.getNumericValue(pwStr.charAt(i));
						int num2 = Character.getNumericValue(pwStr.charAt(i + 1));
						int num3 = Character.getNumericValue(pwStr.charAt(i + 2));

						if ((num2 - num1 == 1 && num3 - num2 == 1) || (num1 == num2 && num2 == num3)) {
							eResult = PasswordCheckPolicyResult.EASY_NUMBERS_NOT_ALLOWED;
							break process;
						}

						// 전화번호, 생일에 포함되는 숫자가 발견되면 오류로 처리
						String consecutiveNumbers = String.valueOf(num1) + String.valueOf(num2) + String.valueOf(num3);

						if (propList.stream().anyMatch(prop -> prop.contains(consecutiveNumbers))) { // "".contains(str) = false
							eResult = PasswordCheckPolicyResult.PERSONAL_INFO_NUMBERS_NOT_ALLOWED;
							break process;
						}
					}
				}
			}

		// 1. 암호 정책관리 사용 여부 확인
		String usePasswordPatternPolicy = ezCommonService.getCompanyConfig(tenantId, companyId, "UsePasswordPatternPolicy");
		if (!usePasswordPatternPolicy.equals("YES")) {
			logger.debug("commonUtil. checkPwPolicy ended. usePasswordPatternPolicy config is 'NO'");
				eResult = PasswordCheckPolicyResult.DISABLE_PASSWORD_POLICY_CONFIG;
				break process;
		}
		
		Map<String, Object> pwMap = ezSystemAdminService.getPwPolicy(tenantId, companyId);

			// 비밀번호 정책이 사용되지 않은 경우 무조선 통과
			if (pwMap == null) {
				eResult = PasswordCheckPolicyResult.DISABLE_PASSWORD_POLICY;
				break process;
			}

			logger.debug("pwMap=" + pwMap.toString());
			
			Boolean bEngCapitalLetter = false; // 대문자 포함시 true(대소문자 구분 안할 경우 bEngSmallLetter는 무조건 false로 하고 bEngCapitalLetter 만 사용)
			Boolean bEngSmallLetter = false;   // 소문자 포함시 true(대소문자 구분 안할 경우 bEngSmallLetter는 무조건 false)
			Boolean bNumber = false;           // 숫자 포함시 true
			Boolean bSpecialChar = false;      // 특수문자 포함시 true
			
			Map<String, String> pwPolicyMap = (Map<String, String>) pwMap.get("pwPolicy");
			List<Map<String, Object>> pwPolicyPattern = (List<Map<String, Object>>) pwMap.get("pwPolicyPattern");
			
			String engCharType = pwPolicyMap.get("ENG_CHAR_TYPE"); // 영문 (대소문자)  :: Y or N
			String useEngCapitalLetter = pwPolicyMap.get("USE_ENG_CAPITAL_LETTER"); // 대문자 사용여부  :: Y or N
			String useEngSmallLetter = pwPolicyMap.get("USE_ENG_SMALL_LETTER"); // 소문자 사용여부  :: Y or N
			String useNumber = pwPolicyMap.get("USE_NUMBER"); // 숫자 사용여부  :: Y or N
			String useSpecial = pwPolicyMap.get("USE_SPECIAL_CHAR"); // 특수문자 사용여부  :: Y or N
			logger.debug("engCharType=" + engCharType + ", useEngCapitalLetter=" + useEngCapitalLetter + ", useEngSmallLetter=" + useEngSmallLetter
					+ ", useNumber=" + useNumber + ", useSpecial=" + useSpecial);
			
		    // 2. 영문 대소문자 구분 사용 여부 (
			if (engCharType != null) {
				if (engCharType.equalsIgnoreCase("Y")) {
					// 영문 대문자 사용
                	bEngCapitalLetter = Pattern.compile("[A-Z]").matcher(pwStr).find();
	                if (useEngCapitalLetter != null && useEngCapitalLetter.equalsIgnoreCase("N")) {
	                    if (bEngCapitalLetter) {
	            			logger.debug("commonUtil. checkPwPolicy ended. (useEngCapitalLetter)");
	                        eResult = PasswordCheckPolicyResult.CAPITAL_LETTERS_NOT_ALLOWED;
							break process;
	                    }
	                }

	                // 영문 소문자 사용
	                bEngSmallLetter = Pattern.compile("[a-z]").matcher(pwStr).find();
	                if (useEngSmallLetter != null && useEngSmallLetter.equalsIgnoreCase("N")) {
	                    if (bEngSmallLetter) {
	            			logger.debug("commonUtil. checkPwPolicy ended. (useEngSmallLetter)");
	                        eResult = PasswordCheckPolicyResult.SMALL_LETTERS_NOT_ALLOWED;
							break process;
	                    }
	                }
				} else {
					bEngCapitalLetter = Pattern.compile("[a-zA-Z]").matcher(pwStr).find();
        			logger.debug("!!!!! =" + bEngCapitalLetter);
				}
			}
			
            // 3. 숫자 사용
            bNumber = Pattern.compile("[1-9]").matcher(pwStr).find();
            if (useNumber != null && useNumber.equalsIgnoreCase("N")) {
                if (bNumber) {
        			logger.debug("commonUtil. checkPwPolicy ended. (useNumber)");
                    eResult = PasswordCheckPolicyResult.NUMBERS_NOT_ALLOWED;
					break process;
                }
            }

            // 4. 특수문자 사용
            bSpecialChar = Pattern.compile("[~!@#$%^&*()=+|\\/:;?\"<>']").matcher(pwStr).find();
            if (useSpecial != null && useSpecial.equalsIgnoreCase("N")) {
                if (bSpecialChar){
        			logger.debug("commonUtil. checkPwPolicy ended. (useSpecial)");
                    eResult = PasswordCheckPolicyResult.SPECIAL_CHARACTERS_NOT_ALLOWED;
					break process;
                }
            }
            
            int iPatternCnt = 0;
			logger.debug("bEngCapitalLetter=" + bEngCapitalLetter + ", bEngSmallLetter=" + bEngSmallLetter + 
					", bNumber=" + bNumber + ", bSpecialChar=" + bSpecialChar);
            if (bEngCapitalLetter){ iPatternCnt++;} 
            if (bEngSmallLetter){ iPatternCnt++;} 
            if (bNumber){ iPatternCnt++;} 
            if (bSpecialChar){ iPatternCnt++;} 
			
            // 5. 패턴 사용 수, 글자수 확인
            if (pwPolicyPattern == null || pwPolicyPattern.size() < 1) {
				logger.debug("!!!! ");
				eResult = PasswordCheckPolicyResult.DISABLE_PASSWORD_POLICY_PATTERN;
				break process;
			}

            eResult = PasswordCheckPolicyResult.SUCCESS;

            	for (Map<String, Object> pwPattern : pwPolicyPattern) {
            		
            		int patternCnt = Integer.parseInt(String.valueOf(pwPattern.get("USE_PATTERN_COUNT")));
            		int numberOfChar = Integer.parseInt(String.valueOf(pwPattern.get("NUMBER_OF_CHAR")));
            		logger.debug("patternCnt=" + patternCnt + ",iPatternCnt=" + iPatternCnt + ", numberOfChar=" + numberOfChar);

            		if (patternCnt == iPatternCnt) {
            			 if (numberOfChar == 0) { // 사용불가
							eResult = PasswordCheckPolicyResult.CURRENT_PATTERN_CNT_NOT_ALLOWED;
                         } else if (numberOfChar > pwStr.length()){
							eResult = PasswordCheckPolicyResult.CHARACTERS_NOT_SUFFICIENT;
                         } else {
							eResult = PasswordCheckPolicyResult.SUCCESS;
                         }
            		}
            	} // for end.
		}
		
		logger.debug("commonUtil. checkPwPolicy ended. result={}", eResult);
		return eResult;
	}
	
	/**
	 * 암호 정책 패턴 설명 문구
	 * - '패스워드 설정 시 연속숫자, 생일, 전화번호 방지' 기능 추가 되었으므로 설명 추가 고려해야함.
	 * - '가장 최근 암호 사용 금지' 기능 추가 되었으므로 설명 추가 고려해야함.
	 */
	@SuppressWarnings("unchecked")
	public String getPwPolicyExplain (String companyId, int tenantId, Locale locale) throws Exception {
		logger.debug("commonUtil. getPwPolicyExplain Started.");
		logger.debug("companyId={}, tenantId={}, locale={}", companyId, tenantId, locale);
		
		String sResult = "";
		String patternContent = "";
		int patternCount = 0;
		String patternContentTemp = "<div>▒ " + egovMessageSource.getMessage("ezSystem.ksaPwPolicy36", locale) + " : ${str}</div>";
		String patternContentTemp2 = "<span>${str}</span>";
		
		// 1. 암호 정책관리 사용 여부 확인
		String usePasswordPatternPolicy = ezCommonService.getCompanyConfig(tenantId, companyId, "UsePasswordPatternPolicy");
		if (!usePasswordPatternPolicy.equals("YES")) {
			logger.debug("commonUtil. getPwPolicyExplain ended. usePasswordPatternPolicy config is 'NO'");
			return "";
		}
		
		Map<String, Object> pwMap = ezSystemAdminService.getPwPolicy(tenantId, companyId);
		if (pwMap != null) {
			logger.debug("pwMap=" + pwMap.toString());

			Map<String, String> pwPolicyMap = (Map<String, String>) pwMap.get("pwPolicy");
			List<Map<String, Object>> pwPolicyPattern = (List<Map<String, Object>>) pwMap.get("pwPolicyPattern");
			
			String engCharType = pwPolicyMap.get("ENG_CHAR_TYPE"); // 영문 (대소문자)  :: Y or N
			String useEngCapitalLetter = pwPolicyMap.get("USE_ENG_CAPITAL_LETTER"); // 대문자 사용여부  :: Y or N
			String useEngSmallLetter = pwPolicyMap.get("USE_ENG_SMALL_LETTER"); // 소문자 사용여부  :: Y or N
			String useNumber = pwPolicyMap.get("USE_NUMBER"); // 숫자 사용여부  :: Y or N
			String useSpecial = pwPolicyMap.get("USE_SPECIAL_CHAR"); // 특수문자 사용여부  :: Y or N
			logger.debug("engCharType=" + engCharType + ", useEngCapitalLetter=" + useEngCapitalLetter + ", useEngSmallLetter=" + useEngSmallLetter
					+ ", useNumber=" + useNumber + ", useSpecial=" + useSpecial);
			
		    // 2. 영문 대소문자 구분 사용 여부 (
			if (engCharType != null) {
				if (engCharType.equalsIgnoreCase("Y")) {
					// 영문 대문자 사용
	                if (useEngCapitalLetter != null && useEngCapitalLetter.equalsIgnoreCase("Y")) {
	                    patternContent = (patternCount + 1) + ". " + egovMessageSource.getMessage("ezSystem.ksaPwPolicy27", locale);
	                    patternCount += 1;
	                }

	                // 영문 소문자 사용
	                if (useEngSmallLetter != null && useEngSmallLetter.equalsIgnoreCase("Y")) {
	                	if (!patternContent.equals("")) {
	                		patternContent += ", ";
	                    }
	                    patternContent += (patternCount + 1) + ". " + egovMessageSource.getMessage("ezSystem.ksaPwPolicy28", locale);
	                    patternCount += 1;
	                }
				} else {
					patternContent = (patternCount + 1) + ". " + egovMessageSource.getMessage("ezSystem.ksaPwPolicy16", locale);
		            patternCount += 1;
				}
			}
			
            // 3. 숫자 사용
            if (useNumber != null && useNumber.equalsIgnoreCase("Y")) {
            	if (!patternContent.equals("")) {
            		patternContent += ", ";
                }
            	patternContent += (patternCount + 1) + ". " + egovMessageSource.getMessage("ezSystem.ksaPwPolicy17", locale);
            	patternCount += 1;
            }

            // 4. 특수문자 사용
            if (useSpecial != null && useSpecial.equalsIgnoreCase("Y")) {
            	if (!patternContent.equals("")) {
            		patternContent += ", ";
                }
            	patternContent += (patternCount + 1) + ". " + egovMessageSource.getMessage("ezSystem.ksaPwPolicy18", locale);
            	patternCount += 1;
            }
			patternContent += "</div><div style='gap:5px;color:#777'>";
            // 5. 패턴 사용 수, 글자수 확인
            if (pwPolicyPattern != null && pwPolicyPattern.size() > 0) {
        		String patternMsg1 = egovMessageSource.getMessage("ezSystem.ksaPwPolicy19", locale);
				for (int i = 0; i < pwPolicyPattern.size(); i++) {
					int patternCnt = Integer.parseInt(String.valueOf(pwPolicyPattern.get(i).get("USE_PATTERN_COUNT")));
					int numberOfChar = Integer.parseInt(String.valueOf(pwPolicyPattern.get(i).get("NUMBER_OF_CHAR")));

            		String patternMsgTemp = patternMsg1.replace("{0}", Integer.toString(patternCnt)) + " ";
            		
            		if (numberOfChar <= 0) {
            			patternMsgTemp += egovMessageSource.getMessage("ezSystem.ksaPwPolicy21", locale);
            		} else {
            			patternMsgTemp += numberOfChar + " " + egovMessageSource.getMessage("ezSystem.ksaPwPolicy26", locale) + " ";
            		}
            		
            		patternContent += patternContentTemp2.replace("${str}", patternMsgTemp);
					if (i != pwPolicyPattern.size() - 1) {
						patternContent += "<span>&nbsp;/&nbsp;</span>";
					}
            	} // for end.
            }
            
            if (!patternContent.equals("")) {
            	sResult = patternContentTemp.replace("${str}", patternContent);
            }
		}
		
		logger.debug("commonUtil. getPwPolicyExplain ended. result=" + sResult);
		return sResult;
	}
	
	//2020-01-22 유은정 메뉴코드로 메뉴 권한 체크
	public Map<String, Boolean> checkMenuAccess(List<String> menuCodeList, String companyId, int tenantId, String lang, String userId, String deptId) {
		logger.debug("checkMenuAccess started.");
		logger.debug("[checkMenuAccess param] menuCodeList : " + menuCodeList.toString() + ", companyId : " + companyId + ", tenantId : " + tenantId + ", lang : " + lang + ", userId : " + userId + ", deptId : " + deptId);
		Map<String, Boolean> menuAccessList = new LinkedHashMap<String, Boolean>();
		
		try {
			List<MenuInfoVO> menuList = ezNewPortalService.getUserMenuList(companyId, tenantId, lang, userId, deptId);
			
			menuCodeList.forEach(menuCode -> {
				boolean menuAccess = false;
				
				try {
    				if (menuCode.equals("workspace")) {//협업
						String useEzWorkspace = ezNewPortalService.isUseEzWorkspace(companyId, tenantId, userId, deptId);
						
						/* 2025-02-27 홍승비 - 포탈 > 협업 메뉴 사용 여부 판별 시 URL이 아닌 메뉴코드를 사용하도록 수정 (쿼리에서 판별) */
						menuAccess = useEzWorkspace.equals("YES");
    				} else if(menuCode.equals("mail") || menuCode.equals("address")) {		// 메일, 주소록
						String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", tenantId);
						menuAccess = useExternalMailServer.equals("NO");
    				} else if (menuCode.equals("board")) { //게시판
						String useBoard = ezCommonService.getTenantConfig("useBoard", tenantId);
						menuAccess = useBoard.equals("YES");
    				} else if (menuCode.equals("schedule")) { //일정
						String useSchedule = ezCommonService.getTenantConfig("useSchedule", tenantId);
						menuAccess = useSchedule.equals("YES");
    				} else if (menuCode.equals("resource")) { //자원
						String useResource = ezCommonService.getTenantConfig("useResource", tenantId);
						menuAccess = useResource.equals("YES");
    				} else if (menuCode.equals("community")) {
                        String useCommunity = ezCommonService.getTenantConfig("USE_COMMUNITY", tenantId);
                        menuAccess = useCommunity.equals("YES");
    				} else if (menuCode.equals("circular")) {
                        String useCircular = ezCommonService.getTenantConfig("USE_CIRCULAR", tenantId);
                        menuAccess = useCircular.equals("YES");
                    } else if (menuCode.equals("memo")) {
                        String useMemo = ezCommonService.getTenantConfig("useMemo", tenantId);
                        menuAccess = useMemo.equals("YES");
                    } else if (menuCode.equals("survey")) {
                        String useSurvey = ezCommonService.getTenantConfig("useSurvey", tenantId);
                        menuAccess = useSurvey.equals("YES");
                    } else if (menuCode.equals("webfolder")) {
                        String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", tenantId);
                        menuAccess = useWebfolder.equals("YES");
                    } else if (menuCode.equals("journal")) {
                        String useJournal = ezCommonService.getTenantConfig("USE_JOURNAL", tenantId);
                        menuAccess = useJournal.equals("YES");
                    } else if (menuCode.equals("attitude")) {
                        String useAttitude = ezCommonService.getTenantConfig("USE_ATTITUDE", tenantId);
                        menuAccess = useAttitude.equals("YES");
                    } else if (menuCode.equals("task")) {
                        String useToDo = ezCommonService.getTenantConfig("useToDo", tenantId);
                        menuAccess = useToDo.equals("YES");
                    } else if (menuCode.equals("vote")) {
                        String useBallotSystem = ezCommonService.getTenantConfig("useBallotSystem", tenantId);
                        menuAccess = useBallotSystem.equals("YES");
                    } else if (menuCode.equals("ladder")) {
                        String useLadder = ezCommonService.getTenantConfig("useLadder", tenantId);
                        menuAccess = useLadder.equals("YES");
                    } else if (menuCode.equals("pms")) {
                        String usePms = ezCommonService.getTenantConfig("USE_ezPMS", tenantId);
                        menuAccess = usePms.equals("YES");
                    } else if (menuCode.equals("cabinet")) {
                        String useCabinet = ezCommonService.getTenantConfig("useCabinet", tenantId);
                        menuAccess = useCabinet.equals("YES");
                    } else if (menuCode.equals("question")) {
                        String useQuestion = ezCommonService.getTenantConfig("useQuestion", tenantId);
                        menuAccess = useQuestion.equals("YES");
                    } else {
                        menuAccess = true;
                    }
				} catch (Exception e) {
				    logger.error(e.getMessage(), e);
                }
				
				List<MenuInfoVO> menuFilter = menuList.stream().filter(menuInfo -> menuInfo.getMenuCode() != null && menuInfo.getMenuCode().equals(menuCode))
											.collect(Collectors.toList());
				
				menuAccess = menuAccess && menuFilter.size() > 0;
				
				logger.debug("checkMenuAccess : " + menuCode + " -> " + menuAccess);
				
				menuAccessList.put(menuCode, menuAccess);
			});
			
			logger.debug("menuAccessList : " + menuAccessList.toString());
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("checkMenuAccess ended.");
		return menuAccessList;
	}

	public String getDayAfter(String date) throws Exception {
		logger.debug("getDayAfter started");
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		
		if(date == null || date.equals("")){
			throw new Exception("formatter error");
		}else {
			LocalDate dayAfter = LocalDate.parse(date, formatter); 
			dayAfter = dayAfter.plusDays(1);
			
			logger.debug("getDayAfter ended");
			return dayAfter.toString();
		}
	}

	public String getDayBefore(String date) throws Exception {
		logger.debug("getDayBefore started");
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		
		if(date == null || date.equals("")){
			throw new Exception("formatter error");
		}else {
			LocalDate dayBefore = LocalDate.parse(date, formatter); 
			dayBefore = dayBefore.minusDays(1);
			
			logger.debug("getDayBefore ended");
			return dayBefore.toString();
		}
	}
	
	// 2020-07-23 김정언 - 두 날짜의 시간 차이 구하는 메소드
	public long getTimeDifference(String startDate, String endDate) {
		logger.debug("getTimeDifference started");
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		LocalDateTime sd = LocalDateTime.parse(startDate, formatter);
		LocalDateTime ed = LocalDateTime.parse(endDate, formatter);
		
		long minutes = ChronoUnit.MINUTES.between(sd, ed);
		logger.info("##minutes=" + minutes);
		logger.debug("getTimeDifference ended");
		return minutes;
	}
	
	public boolean isIntNumber(String number) {
	    if (!NumberUtils.isNumber(number)) {
	        return false;
	    }
	    
	    BigInteger minNum = BigInteger.valueOf(Integer.MIN_VALUE);
	    BigInteger maxNum = BigInteger.valueOf(Integer.MAX_VALUE);
	    BigInteger num = new BigInteger(number);
	    
	    if (num.compareTo(minNum) > 0 && num.compareTo(maxNum) < 0) {
	        return true;
	    } else {
	        return false;
	    }
	}
	
	public int isIntNumber(String number, int defaultValue) {
	    return isIntNumber(number) ? Integer.parseInt(number) : defaultValue;
	}

	/**
	 * jangsewon
	 * 2020.11.13
	 * listview xml form 으로 변환
	 * @param jo : DB에서 조회된 list + cnt (key:totalCnt,rows)
	 * @param ja : DB에서 조회된 list
	 * @param jaAttr : html tag에 들어갈 속성
	 * @param jaProp : td에 들어갈 text
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public String makeListViewData(int tatalCnt, JSONArray ja, JSONArray jaAttr, JSONArray jaProp, String value) throws Exception {
		
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
		
		result.append("<ROWS>");
		result.append("<TOTALCNT>");
		result.append(tatalCnt);
		result.append("</TOTALCNT>");
        
        for (int i = 0; i < ja.size(); i++) {
        	Map<String, Object> map = new HashMap<String, Object>();
        	
        	map = (Map<String, Object>)ja.get(i);
        	
            result.append("<ROW>");
        	result.append("<CELL>");
        	 // 첫번째 td value
    		for(Entry<String, Object> entry : map.entrySet()) {
    			if(((String)entry.getKey()).equals(value.toUpperCase())) {
    				result.append("<VALUE>" + cleanValue(map.get(entry.getKey()).toString()) + "</VALUE>");
    			}
    		}
            // 첫번째 td 속성
        	for(int j=0; j<jaAttr.size(); j++) {
        		for(Entry<String, Object> entry : map.entrySet()) {
        			if(((String)jaAttr.get(j)).toUpperCase().equals(entry.getKey())) {
        	            result.append("<" + jaAttr.get(j) + ">" + cleanValue(map.get(entry.getKey()).toString()) + "</" + jaAttr.get(j) + ">");
        			}
        		}
    		}
            result.append("</CELL>");
            
            // 나머지 td
        	for(int j=0; j<jaProp.size(); j++) {
        		for(Entry<String, Object> entry : map.entrySet()) {
        			if(((String)jaProp.get(j)).toUpperCase().equals(entry.getKey())) {
        				result.append("<CELL>");
        	            result.append("<VALUE>" + cleanValue(map.get(entry.getKey()).toString()) + "</VALUE>");
        	            result.append("</CELL>");
        			}
        		}
    		}
            result.append("</ROW>");
        }
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
        
        return result.toString();
	}
	
    public String convertXsltToHtml(String xslStr, String xmlStr) throws Exception {
        return convertXsltToHtml(xslStr, xmlStr, true);
    }
    public String convertXsltToHtml(String xslStr, String xmlStr, boolean isEncodingStr) throws Exception {
        logger.debug("convertXsltToHtml started");
        
        if(isEncodingStr) {
            xslStr = htmlUnescape(xslStr);
        }
        
        String outputHtml = "";
        
        TransformerFactory tfFactory = TransformerFactory.newInstance();
        
        StringWriter htmlWriter = new StringWriter();
        
        Source xslSource = new StreamSource(new ByteArrayInputStream(xslStr.getBytes(StandardCharsets.UTF_8))); 
        Source xmlSource = new StreamSource(new ByteArrayInputStream(xmlStr.getBytes(StandardCharsets.UTF_8)));
    
        Transformer transformer = tfFactory.newTransformer(xslSource);
        transformer.transform(xmlSource, new StreamResult(htmlWriter));
        
        outputHtml = htmlWriter.toString();
        
        logger.debug("convertXsltToHtml ended");
        
        return outputHtml;
    }
    
    /**
	 * 유니닥스에서 파일을 내려받고 성공했는지 실패했는지 정보, 새로운 파일 path return 
	 * @param filePath
	 *  ex) /fileroot/0/files/upload_webfolder/file.pdf
	 * @param realPath
	 *  ex) E:/~~~ or /home/jmocha/~~~
	 * @param filePathFlag 
	 *  ex) webfolder
	 * @param tenantId
	 * @return JSON {
	 * 	status : "ERROR" or "OK"
	 *  path : 새로다운받아진 경로 + uuid.pdf
	 * }
	 */
	@SuppressWarnings("unchecked")
	public JSONObject unidocsFileDown(String filePath, String realPath, String filePathFlag, int tenantId){
		InputStream inputStream = null;
		JSONObject result = new JSONObject();
		String status = "ERROR";
		int code = 0;
		logger.debug("filePath=" + filePath + ",realPath=" + realPath + ",filePathFlag=" + filePathFlag + ",tenantId=" + tenantId);
		
		try {
			String unidocsFilerootPath = ezCommonService.getTenantConfig("unidocsFilerootPath", tenantId);
			File file       = new File(realPath + detectPathTraversal(filePath));
			
			MessageDigest md2 = MessageDigest.getInstance("SHA-256");
			md2.update(filePath.getBytes());
			byte mdDate2[] = md2.digest();
			StringBuffer sb2 = new StringBuffer();
			
			for (int i = 0; i < mdDate2.length; i++) {
				sb2.append(Integer.toHexString((int) mdDate2[i] & 0x00ff));
			}
			
			String fileExtension = FilenameUtils.getExtension(file.getName());
			String decryptFileName = sb2.toString() + "." + fileExtension;
			String newFileName = sb2.toString() + ".pdf";
			
			// 전자결재의 경우 .hwp.ezd 형식으로 저장되기 때문에 .ezd 앞 마지막 확장자로 만들어줘야함
			if(filePathFlag.equals("approval") && fileExtension.equals(EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
				String fileName = file.getName();
				fileName = fileName.substring(0, fileName.lastIndexOf('.'));
				String NewFileExtension = FilenameUtils.getExtension(fileName);
				decryptFileName = sb2.toString() + "." + NewFileExtension;
			}
				
			logger.debug("fileExtension=" + fileExtension + ",decryptFileName=" + decryptFileName + ",newFileName=" + newFileName);
			
			String stringPath = "";
			switch (filePathFlag){
				case "webfolder":
					stringPath = "upload_webfolder.ROOT";
					break;
				// 다른 모듈 추가 	
				case "approval":
					stringPath = "upload_approvalG.ROOT";
					break;
				case "board":
					stringPath = "upload_board.ROOT";
					break;	
				default:
					stringPath = "upload_webfolder.ROOT";
			}
			
			String pdfFilePath 	= getUploadPath(stringPath, tenantId) + separator + "unidocs_tempFolder" + separator;
			String pdfFileAllPath 	= detectPathTraversal(pdfFilePath) + newFileName;
			
			File decryptFile 	= new File(realPath + pdfFilePath + "temp" + separator + decryptFileName);
			if(!decryptFile.exists()){
				decryptFile.getParentFile().mkdirs();
			}
				
			File pdfFile 	= new File(realPath + pdfFileAllPath);
			
			if(pdfFile.exists() && !filePathFlag.equals("approval")){
				if(pdfFile.getParentFile().exists()){
					status = "OK";
					result.put("path",  unidocsFilerootPath + pdfFileAllPath);
					result.put("path2", pdfFileAllPath);
					return result;
				}
			} else {
				pdfFile.getParentFile().mkdirs();
			}

			// CWE-404 보안 취약점 대응
			try (OutputStream outputStream = new FileOutputStream(decryptFile)) {			
				// webfolder는 암호화 하는 폴더가 있기 때문에 klib 복호화 코드 추가 
				if ((filePathFlag.equals("webfolder") && ezWebFolderService.isEncryptedFilePath(filePath)) || (filePathFlag.equals("approval") && fileExtension.equals(EzApprovalGKlibService.ENCRYPTED_FILE_EXT))) {
					logger.debug("fileOldPath=" + filePath);
					logger.debug("pdfFilePath=" + pdfFilePath);
					byte[] encryptedBytes = readBytesFromFile(file.toPath());
					byte[] decryptedBytes = kilbUtil.decrypt(encryptedBytes);
					inputStream = new ByteArrayInputStream(decryptedBytes);
					
					FileCopyUtils.copy(inputStream, outputStream);
				} else {
					Files.copy(file.toPath(), outputStream);
				}
			}

			if(fileExtension.equalsIgnoreCase("pdf")){
				FileCopyUtils.copy(decryptFile, pdfFile);
				status = "OK";
			} else {
				JSONObject changePDFResult = changePDF(decryptFile.getPath(), pdfFile.getPath());

				status = changePDFResult.get("status").toString().toUpperCase();
				code = (int) changePDFResult.get("code");
			}
			
			if (status.equalsIgnoreCase("ok")) {
				result.put("path", unidocsFilerootPath + pdfFileAllPath);
				result.put("path2", pdfFileAllPath);
			}
		} catch (Exception e) {
			status = "error";
			logger.error(e.getMessage(), e);
		} finally {
			if (inputStream != null) {
				try {
					inputStream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
			result.put("status", status);
			result.put("code", code);
		}
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject changePDF (String srcFile, String savePath) {
		logger.debug("[=================== Unidocs PDF Job Start ===================]");
		logger.debug("srcFile=" + srcFile + ",savePath=" + savePath);
		JSONObject result = new JSONObject();
		WFJob job= null;
		
		String status = "";
		int code = 0;
		try {
			job = new WFJob();
			
			FileEx srcPath = new FileEx(srcFile);
			job.setJobBatch(true);
			
			JobResult jr = job.generatePDF(srcPath, savePath.substring(savePath.lastIndexOf(File.separator)).substring(1), 0);
	
			if(jr.getStatus() == JobResult.JOB_OK) {
				logger.debug("PDF Convert Success : " + srcFile);
				jr = job.getJobResult(); 
				
				FileEx[] out = jr.getOutFile();	
				
				for(int j=0; j< out.length; j++) {
					out[j].saveToByStream(new File(savePath),true);
				}
				
				status = "ok";
			} else {
				logger.debug("DOC TO PDF Fail");
				status = "error";
				code = jr.getErrCode();
			}
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			status = "error";
		} finally {
			try {
				// 2023-05-17 이사라 : NullPointerException 시큐어코딩
				if (!Objects.isNull(job)) {
					job.clearJobDirectory();
				}

			} catch(Exception ee) {
				logger.error(ee.getMessage(), ee);
			}
		}
		logger.debug("[==================== Unidocs PDF Job End ====================]");
		result.put("status", status);
		result.put("code", code);
		return result;
	}
	
	public String cleanValueUnescape(String pOrgString) {
		String value = ""; 
				
		if (pOrgString != null) {
			value = pOrgString.replaceAll("&amp;", "&").replaceAll("&lt;", "<").replaceAll("&gt;", ">");
	        value = value.replaceAll("&#40;", "\\(").replaceAll("&#41;", "\\)");
	        value = value.replaceAll("&#39;", "'");
	        value = value.replaceAll("&quot;", "\"");
		}

		return value;
	}
	
	public List<String> attachWebFolderFile(JSONArray jsonArr, String downloadDIR, LoginVO userInfo, String realPath) throws Exception {
 		logger.debug("attachWebFolderFile start.");
		
 		JSONObject fileInfo = null;
		String filePath = ""; 
		
		List<String> fileDownPath = new ArrayList<String>();
			
		try {
 			for (int i=0; i <jsonArr.size(); i++){
				fileInfo 	= (JSONObject) jsonArr.get(i);
				filePath 	= fileInfo.get("filePath").toString() ;
				String FileRealName = filePath.split("/")[filePath.split("/").length-1];
				
				String newFilePath = realPath + downloadDIR + FileRealName;
				File newAttachFile = new File(newFilePath); 
				File oldFile = new File(realPath + filePath);
				FileUtils.copyFile(oldFile, newAttachFile);
				fileDownPath.add(downloadDIR + FileRealName);

			}
			logger.debug("attachWebFolderFile copy complete.");
		} catch (Exception e) {
			for (int i = 0 ; i < fileDownPath.size() ; i++){
				File file = new File(fileDownPath.get(i));
				file.delete();
			}
			fileDownPath.clear();
			logger.error(e.getMessage(), e);
		} 
		
		logger.debug("attachWebFolderFile end.");
		return fileDownPath;
	}
	
	public void renameFileForOverwrite(String sourceFile, String destFile) throws Exception{
		try {
			File sFile = new File(sourceFile);
			File dFile = new File(destFile);
			
			dFile.getParentFile().mkdirs();
			logger.debug("renameFileForOverwrite-sFile:" + sourceFile + ",size:" +sFile.length());
			
			sFile.renameTo(dFile);
			logger.debug("renameFileForOverwrite-dFile:" + sourceFile + ",size:" +dFile.length());
		} catch (Exception ex) {
			logger.debug("ex: {}", ex);
		}
	}
	
	/** 2021-12-08 홍승비 - 이미지 파일 확장자 체크용 공통 메서드 추가 */
	public boolean checkImgExtension(String fileExt) {
		boolean result = false;
		String[] imgExts = {"jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw"};
		
		if (fileExt != null && ArrayUtils.contains(imgExts, fileExt)) {
			result = true;
		}
		
		return result;
	}
	
	/** 2021-12-08 홍승비 - HTML5 지원 웹 동영상 파일 확장자 체크용 공통 메서드 추가 */
	public boolean checkMovExtension(String fileExt) {
		boolean result = false;
		String[] movExts = {"mp4", "webm"};
		
		if (fileExt != null && ArrayUtils.contains(movExts, fileExt)) {
			result = true;
		}
		
		return result;
	}

	public Map<String, Object> convertVoToMap(Object voObject) throws IllegalArgumentException, IllegalAccessException {

		Map<String, Object> result = new HashMap<String, Object>();

		for (Field field : voObject.getClass().getDeclaredFields()) {
			field.setAccessible(true);
			Object value = field.get(voObject);
			if (value != null) {
				result.put(field.getName(), value);
			}
		}
		
		return result;
	}

	public JsonObject convertVoToJson(Object VO) throws IllegalArgumentException {
		Gson gson = new Gson();
		JsonParser jsonParser = new JsonParser();
		return jsonParser.parse(gson.toJson(VO)).getAsJsonObject();
	}

	public JsonArray convertVoListToJsonArray(List<?> voList) throws IllegalArgumentException {
		Gson gson = new Gson();
		JsonParser jsonParser = new JsonParser();
		return jsonParser.parse(gson.toJson(voList)).getAsJsonArray();
	}
	
	/**
	 * 2023-02-14 홍승비 - 서버 간 REST 통신으로 XML 문자열을 받은 경우, JSON으로 변환하여 리턴하기 위한 메서드 추가
	 * 레스트 API에서 제이슨 오브젝트 넘겨 받는 메서드 (XML -> org.json.JSONObject -> simpleJSON로 변환하여 리턴)
	 * @param resteUrl
	 * @param param
	 * @param request
	 * @return
	 */
	public JSONObject getXML2JsonFromRestApi(String gwServerUrl, String restUrl, Map<String, Object> param, HttpServletRequest request, String methodType, JSONObject jsonParam, int connectionTimeout, int readTimeout) {
		logger.debug("getXML2JsonFromRestApi started.");
		String url = gwServerUrl + restUrl ;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.TEXT_HTML_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(jsonParam, headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		if (param != null) {
			for (String key : param.keySet()){
				builder.queryParam(key, param.get(key));
			}
		}
		
		RestTemplate rest = null;
		
		if (methodType.equals("patch")) {
			ClientHttpRequestFactory httpRequestFactory = new HttpComponentsClientHttpRequestFactory();
			rest = new RestTemplate(httpRequestFactory);
		} else if (connectionTimeout > 0 || readTimeout > 0) {
			HttpComponentsClientHttpRequestFactory httpRequestFactory = new HttpComponentsClientHttpRequestFactory();
			httpRequestFactory.setConnectTimeout(connectionTimeout);
			httpRequestFactory.setReadTimeout(readTimeout);
			rest = new RestTemplate(httpRequestFactory);
		} else {
			rest = new RestTemplate();
		}
		
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
		case "patch":
			method = HttpMethod.PATCH;
			break;
		default:
			method = HttpMethod.GET;
			break;
		}
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), method, entity, String.class);
		
		JSONObject resultBody = null;
		org.json.JSONObject resultBodyTemp = null;
		JSONParser jp = new JSONParser();
		
		try {
			// XML -> org.json.JSONObject
			resultBodyTemp = XML.toJSONObject(result.getBody());
			
			// org.json.JSONObject -> simpleJSON
			resultBody = (JSONObject) jp.parse(resultBodyTemp.toString());
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("getXML2JsonFromRestApi ended.");
		return resultBody;
	}
	
	public String loginCookieExists(HttpServletRequest request, HttpServletResponse response) {
		boolean usingSession = false;
		String  result = "null"; //  0 : 세션 유지 , 1 : 세션 만료 , 2 :  쿠키 만료 및 예외 , 3 :  부서 및 직위 등 조직도 정보 변경

		try {
			String serverName = request.getServerName();
			int tenantID = loginService.getTenantId(serverName);
			String useSessionConfig = ezCommonService.getTenantConfig("useSession", tenantID);

			// 세션 콘피그가 0 이거나 비어있으면 세션 로그인 사용 안 함
			usingSession = !useSessionConfig.isEmpty() && !useSessionConfig.equals("0");
		} catch (Exception ex) {
			ex.printStackTrace();
			return "2";
		}

		// 세션 콘피그를 무시하고 로그인 쿠키만으로 사용할 수 있도록 해줌
		boolean usingAsAPI = "yes".equalsIgnoreCase(request.getHeader("Use-As-API"));
		// request 아이피가 127.0.0.1 일 때는 세션 콘피그 무시함 (인사연동)
		boolean isLoopbackRequest = request.getRemoteAddr().equals("127.0.0.1");

		if (!usingSession || usingAsAPI || isLoopbackRequest) {
			return validLoginCookie(request, response);
		}

		if(validSessionLoginCookie(request, response)){
			boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));

			if (useDbSession) {
				Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");

				if (loginCookie == null) {
					return "2";
				}

				try {
					String ezSessionId = loginCookie.getValue();
					SessionVO resultVO = loginService.getSession(ezSessionId);

					int maxInactiveInterval = resultVO.getMaxInactiveInterval();
					int timediff = resultVO.getTimeDiff();

					if (maxInactiveInterval > timediff || maxInactiveInterval == 0) { // DB에 저장 당시 세션 사용 안함 (maxInactiveInterval == 0)인 경우도 pass
						String returnCode = "0";

						// MariaDB 클러스터 환경에서 Deadlock Exception이 발생할 수 있어
						// 업데이트 도중 오류가 발생해도 무조건 성공으로 처리한다.
						try {
							loginService.updateSession(ezSessionId, "");
						} catch (DataAccessException e) {
							returnCode = "0";
						} catch (Exception e) {
							returnCode = "0";
						}

						return returnCode;
					} else {
						clearAllCookies(request, response);
						request.getSession().invalidate();
						return "1";
					}

				} catch (Exception e) {
					return "2";
				}
			} else {
				result = "0";
			}

		}else {
			result = "1";
		}

		return result;
	}

	
	// 2023-10-11 전인하 - 특정 권한이 겸직 포함하여 존재하는지 취합하여 확인하는 공통메소드
	// adminCode로 삽입한 문자열은 세미콜론을 구분자로 사용. adminCode중 하나라도 권한이 있을 경우 true 반환
	// 겸직/사용자 별 권한 설정 기능 옵션 사용여부는 서비스단에서 체크함.
	public boolean isAdmin(String userId, int tenantId, String rollInfo, String adminCode) throws Exception {
		String[] adminCodeArr = adminCode.split(";");
		List<String> adminAllCodeList = new ArrayList<String>(Arrays.asList("c", "g", "n", "e", "l")); // 원직/겸직 권한을 취합할 필요가 있는 권한코드를 해당 배열로 관리함
		int adminCount = 0;
		for (String code : adminCodeArr) {
			if (adminAllCodeList.contains(code)) {
				adminCount += ezOrganService.getAllRollInfoForUserBasisDept(userId, tenantId, (code + "=1")).size();
			} else if (rollInfo != null && rollInfo.toLowerCase().contains(code + "=1")) {
				adminCount ++;
			}
		}
		return adminCount > 0;
	}

	private static final String CHARPOOL = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz123456789";
	public String getTempPassword (int length) throws Exception {
		Random random = new SecureRandom();
		StringBuilder rs;
		do {
			rs = new StringBuilder();
			for (int i = 0; i < length; i++) {
				int index = random.nextInt(CHARPOOL.length());
				rs.append(CHARPOOL.charAt(index));
			}
		} while (!hasConsecutiveCharsAndValidFormat(rs.toString(), 3));
		return rs.toString();
	}

	private boolean hasConsecutiveCharsAndValidFormat(String source, int sequenceLength) {
		// 연속된문자 체크 및 대소문자숫자 포함여부
		boolean hasConsecutiveChars = source.matches("(.)\\1{" + (sequenceLength - 1) + "}");
		boolean hasUpperCase = source.matches(".*[A-Z].*");
		boolean hasLowerCase = source.matches(".*[a-z].*");
		boolean hasDigit = source.matches(".*\\d.*");

		return !(hasConsecutiveChars || !hasUpperCase || !hasLowerCase || !hasDigit);
	}

	private static final String INSERTSMS = "insert into em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg , tran_type) values(?, ?, '1', GETDATE(), ? ,4)";

	/**
	 * 2024-07-03 김대현
	 * 	sendSMS 메소드는 SMS로 인증번호와 임시비밀번호를 전송할때 커스터마이징 하기위해 만들어짐.
	 * 	각 프로젝트에서 해당 메소드 바디 부분을 수정하여 사용하면 됨.
	 * @param mobileNo 이동전화 번호
	 * @param randomValue 랜덤값
	 * @param type 인증번호, 임시비밀번호 타입
	 * @return
	 * @throws Exception
	 */
	public Boolean sendSMS (String mobileNo, String randomValue, String type) throws Exception {
		logger.debug("sendSMS Started:mobileNo={},randomValue={},type={}",mobileNo,randomValue,type);
		boolean result = false;
//		String tran_msg = "";
//		String tran_phone = mobileNo; // 받는전화
//		String tran_callback = ""; // 보낸전화
//		String tran_status = "1"; // 1
//		String tran_date = ""; // 발송시간
//
//		if ("authCode".equals(type)) {
//			// 인증번호
//			tran_msg = "인증번호:[" + randomValue + "]'\n그룹웨어에서 보낸 인증번호 입니다.";
//		} else {
//			// 임시 비밀번호
//			tran_msg = "임시비밀번호:[" + randomValue + "]'\n그룹웨어에서 보낸 임시비밀번호 입니다.";
//		}
//
//		tran_callback = "02-000-0000";
//
//		logger.debug("sendSMS Started:randomValue={},tran_phone={},tran_callback{}",randomValue,tran_phone,tran_callback);
//
//		if (StringUtils.isBlank(randomValue) || StringUtils.isBlank(tran_phone) || StringUtils.isBlank(tran_callback) ) {
//			result = false;
//		} else {
//			String smsDriverClassName = globals.getProperty("Globals.SMSDriverClassName");
//			String smsUrl = globals.getProperty("Globals.SMSUrl");
//			String smsUserName = globals.getProperty("Globals.SMSUserName");
//			String smsPassword = globals.getProperty("Globals.SMSPassword");
//
//
//			Connection conn = null;
//			PreparedStatement pstmt = null;
//
//			String sqlQuery = INSERTSMS;
//
//			try {
//				Class.forName(smsDriverClassName);
//				conn = DriverManager.getConnection(smsUrl,smsUserName,smsPassword);
//
//				pstmt = conn.prepareStatement(sqlQuery);
//				pstmt.setObject(1, tran_phone);
//				pstmt.setObject(2, tran_callback);
//				pstmt.setObject(3, tran_msg);
//				int count = pstmt.executeUpdate();
//
//				if (count != 0) {
//					result = true;
//				}
//
//			} catch (Exception e){
//				logger.error(e.getMessage(), e);
//
//			} finally {
//				closeQuietly(pstmt, conn);
//			}
//		}
		result = true;
		logger.debug("sendSMS ended={}",result);
		return result;
	}

	public static void closeQuietly(AutoCloseable... closeables) {
		for (AutoCloseable closeable : closeables) {
			if (closeable == null) {
				continue;
			}

			try {
				closeable.close();
			} catch (Exception ignore) {}
		}
	}

	/**
	 * 테넌트 컨피그 boolean 설정 값 확인용
	 */
	public boolean checkTenantConfigBool(int tenantId, String propertyName, String defaultValue) throws Exception {
		return BooleanUtils.toBoolean(StringUtils.defaultIfBlank(ezCommonService.getTenantConfig(propertyName, tenantId), defaultValue));
	}
	public OrganAuth makeOrganAuth(String userId, int tenantId, String deptId, String jobId) throws Exception {
		List<OrganUserVO> allUserinfo = ezOrganService.getAllUserinfo(userId, tenantId);
		OrganAuth organAuth = new OrganAuth();
		
		// 현재 권한만 체크하도록 변경
		// jobid가 null이거나, 공백인 경우가 있어 같이 공백 or null 이거나 string equal 인 조건으로 변경 
		for (OrganUserVO user : allUserinfo) {
			if (user.getDepartment().equalsIgnoreCase(deptId) &&
					((StringUtils.isBlank(user.getJobID()) && StringUtils.isBlank(jobId)) ||
					user.getJobID().equalsIgnoreCase(jobId))) {
				organAuth.addAuth(user.getRoleInfo(), user.getDepartment(), user.getCompanyId());
				break;
			}
		}
		
        return organAuth;
	}
	
	public String makeLocalDateToUTCDate(int minusYear, boolean isFrom, String offset) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDateTime now = LocalDateTime.now();
		LocalDateTime nowMinusOneYear = now.minusYears(minusYear);
		String timeStr = isFrom ? " 00:00:00" : " 23:59:59";
		String utcDate = getDateStringInUTC(nowMinusOneYear.format(formatter) + timeStr, offset, false);

		return utcDate;
	}

	public String makeUrl(String path, MultiValueMap queryParam) throws Exception {
		UriComponents uriComponents = UriComponentsBuilder.newInstance()
				.path(path)
				.queryParams(queryParam)
				.build();

		return uriComponents.toUriString();
	}

	public String makeSSOUrl(String url, int tenantId) throws Exception {
		if (!"".equals(url) && url != null) {
			String serverUrl = ezCommonService.getTenantConfig("serverName", tenantId);
			url = serverUrl + url;
		}
		return url;
	}
	
	// 이스케이프용 문자 백슬래시(\) 삽입
	// 오라클에서 특수문자 검색을 가능케 할 때 사용함
	public String insertEscapeCharBackslash(String str) {
		if (Strings.isBlank(str)) {
			return str;
		}
		str.replace("%", "\\%")
                    .replace("_", "\\_")
                    .replace("&", "\\&")
                    .replace("|", "\\|")
                    .replace("'", "\\'")
                    .replace("\"", "\\\"")
                    .replace("\\", "\\\\")
                    .replace("#", "\\#")
                    .replace(";", "\\;");
		
		return str;
	}

	/**
	 * PrimaryLang 컨피그에 해당하는 Locale 반환
	 */
	public Locale getPrimaryLocale(int tenantId) throws Exception {
		Locale locale;
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
		
		try {
			switch (primaryLang) {
				case "1":
					locale = Locale.KOREA;
					break;
				case "2":
					locale = Locale.US;
					break;
				case "3":
					locale = Locale.JAPAN;
					break;
				default:
					locale = Locale.getDefault();
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			locale = Locale.KOREA; // 보안 제한 등으로 getDefault() 오류 시 한국으로 세팅
		}
		
		return locale;
	}
}
