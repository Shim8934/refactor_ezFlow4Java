package egovframework.ezEKP.ezApprovalG.util;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Locale;
import java.util.Properties;
import java.util.Base64.Decoder;

import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.LocaleResolver;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;


/**
 * @author mslim8803
 * egovframework.ezEKP.ezConn.util.EzConnUtil에 '거의' 똑같은 기능을 가진 클래스가 존재하지만 
 * EzConnUtil은 일반 Base64를 사용하여 '+'이나 '/'와 같은 문자를 반환하는 경우도 있어 url에 사용할 경우 문제가 생길 수 있음.
 * 따라서 Base64.getEncoder()가 아닌  Base64.getUrlEncoder()를 사용해야하는데, 
 * 이 둘은 상호 호환이 되지 않기 때문에, EzConnUtil을 변경할 수도 없어 부득이하게 신규 생성. 향후 이걸 사용할 것을 권장
 */

@Component
public class EzConnUtil_new {
	private static final Logger logger = LoggerFactory.getLogger(EzConnUtil_new.class);
	
	@Value("#{cryptos['EzConnUtil.apb']}")
	private String apb;
    private static final String iv = "U/XMHTue7XTMrCyASklMKw==";
    
    @Autowired
	private CommonUtil commonUtil;
    
    @Autowired
	private Properties config;
    
    @Autowired
    private LocaleResolver localeResolver;
    
    @Resource(name = "EzCommonService")
   	private EzCommonService ezCommonService;
    
    @Resource(name = "crypto") 
    private EgovFileScrty egovFileScrty;
    
    @Resource(name = "loginService")
    private LoginService loginService;
    
	public String encryptAES(String s) throws Exception {
        SecretKeySpec skeySpec = new SecretKeySpec(Base64.getDecoder().decode(apb), "AES");
        
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, new IvParameterSpec(Base64.getDecoder().decode(iv)));
        
        byte[] encryptedData = cipher.doFinal(s.getBytes("UTF-16LE"));
               
        return Base64.getUrlEncoder().encodeToString(encryptedData);
    }

	public String decryptAES(String s) throws Exception {
		logger.debug("decryptAES started");
		logger.debug("s = " + s);
		SecretKeySpec skeySpec = new SecretKeySpec(Base64.getDecoder().decode(apb), "AES");            

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.DECRYPT_MODE, skeySpec, new IvParameterSpec(Base64.getDecoder().decode(iv)));

        byte[] byteData = Base64.getDecoder().decode(s);
        
        byte[] decryptedData = cipher.doFinal(byteData);
                                
        logger.debug("decryptAES ended");
        return new String(decryptedData, "UTF-16LE");
    }
	
	public void createLoginCookie(String userId, String userPw, String encryptedUserPw, int tenantId, 
			  HttpServletRequest request, HttpServletResponse response, String deptID, String companyID) throws Exception {

		String serverName = request.getServerName();
		int serverPort = request.getServerPort();
		String ipAddress = ClientUtil.getClientIP(request);
		
		// DB에서 lang 값 가져옴
		String lang = ezCommonService.selectUserGetLang(userId, tenantId);				
		String acceptLanguage = request.getHeader("Accept-Language");
		String twoLetterLang = commonUtil.getTwoLetterLangFromLangNum(lang);

		// userLocalInfo 테이블에 정보가 없을 때 (첫 로그인)				
		if (twoLetterLang == null || twoLetterLang.equals("")) {
			String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
			logger.debug("primaryLang=" + primaryLang);					

			//UsePrimaryLangOnly가 YES일 때는 무조건 PrimaryLang 언어로 설정한다.
			if (config.getProperty("config.UsePrimaryLangOnly").equals("YES")) {
				if (primaryLang.equals("1")) {
					acceptLanguage = "ko";
				} else if (primaryLang.equals("3")) {
					acceptLanguage = "ja";
				}
			}

			if (acceptLanguage != null) {
				twoLetterLang = acceptLanguage.substring(0, 2);
				// 이유는 정확히 알 수 없지만 로그를 확인한 결과 윗 라인에서 acceptLanguage가 null인 경우가 발생하여 추가함.
			} else {				        
				twoLetterLang = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
			}
	
			lang = commonUtil.getLangNumFromTwoLetterLang(twoLetterLang);
	
			//브라우저 언어가 한국어/일본어가 아닐 경우 시스템 언어로 설정(영어/중국어 추후 지원)
			if (lang.equals("")) {						
				lang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
			}
	
			String primaryTimeZone = ezCommonService.getTenantConfig("PrimaryTimeZone", tenantId);
	
			if (primaryTimeZone.equals("")) {
				primaryTimeZone = "235|+09:00";
			}
	
			logger.debug("userID=" + userId + ",lang=" + lang + ",primaryTimeZone=" + primaryTimeZone);
			ezCommonService.insertTblUserLocalInfo(userId, primaryTimeZone, lang, tenantId);
		}

		String timeZone = ezCommonService.selectUserGetTimeZone(userId, tenantId);

		logger.debug("userId=" + userId + ",ipAddress=" + ipAddress + ",lang=" + lang + ",timeZone=" + timeZone + ",acceptLanguage=" + acceptLanguage);

		// CookieLocaleResolver에 DB에서 가져온 lang값을 set해줌
		Locale locale = new Locale(twoLetterLang);
		localeResolver.setLocale(request, response, locale);

		// 80 포트가 아닌 경우엔 포트 번호도 포함시킨다.
		if (serverPort != 80) {
			serverName = serverName + ":" + serverPort;
		}

		// Cookie 생성
		String cInfo = serverName + "///" + userId + "///" + encryptedUserPw + "///" + ipAddress + "///" + userPw + "///" + locale + "///" + lang + "///" + timeZone + "///" + tenantId+ "///" + deptID + "///" + companyID;
		String loginCookie = egovFileScrty.encryptAES(cInfo);

		Cookie cookieID = new Cookie("loginCookie", loginCookie);
		cookieID.setPath("/");
		response.addCookie(cookieID);

		String useSSOCookie = ezCommonService.getTenantConfig("useLoginCookieSSO", tenantId);

		if (!("NO".equalsIgnoreCase(useSSOCookie) || "".equals(useSSOCookie))) {
			Cookie ssoLoginCookie = new Cookie("loginCookieSSO", loginCookie);
			ssoLoginCookie.setPath("/");
			ssoLoginCookie.setDomain(useSSOCookie);
			response.addCookie(ssoLoginCookie);
		}
	}	
	

	public LoginVO getUserInfo(String id, int tenantId) throws Exception {
		logger.debug("getUserInfo started. id=" + id + ",tenantId=" + tenantId);
				
		LoginVO loginVO = new LoginVO();	
		
		loginVO.setId(id);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");		
		
		LoginVO	resultVO = loginService.selectUser(loginVO);			
		
		logger.debug("resultVO=" + resultVO);
				
		logger.debug("getUserInfo ended.");
		
		return resultVO;
	}
	
	public String convertXsltToHtml(String xmlStr, String xslStr) throws Exception {
		logger.debug("convertXsltToHtml started");
		
		TransformerFactory tfFactory = TransformerFactory.newInstance();
		
		StringWriter htmlWriter = new StringWriter();
		
		Source xslSource = new StreamSource(new ByteArrayInputStream(xslStr.getBytes(StandardCharsets.UTF_8))); 
		Source xmlSource = new StreamSource(new ByteArrayInputStream(xmlStr.getBytes(StandardCharsets.UTF_8)));
	
		Transformer transformer = tfFactory.newTransformer(xslSource);
		transformer.transform(xmlSource, new StreamResult(htmlWriter));
		
		String outputHtml = htmlWriter.toString();
			
		logger.debug("convertXsltToHtml ended");
		
		return outputHtml;
	}
	
	/** 전자결재 일괄결재 시 서버측 연동동작 
	 *  필요한 method 만들어두고 reflection써서 사용
	 *  
	 * */
	
	private String docID;
    private String userID;
    private String companyID;
    private int tenantID;
    
    public void connTest() throws Exception {
    	logger.debug("connTest started.");
    	
    	logger.debug("docID = " + docID + " || userID = " + userID + " || companyID = " + companyID + " || tenantID = " + tenantID);
    	
    	logger.debug("connTest ended.");
    }

	public String getDocID() {
		return docID;
	}

	public void setDocID(String docID) {
		this.docID = docID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getCompanyID() {
		return companyID;
	}

	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}

	public int getTenantID() {
		return tenantID;
	}

	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}

	public String getApb() {
		return apb;
	}

	public void setApb(String apb) {
		this.apb = apb;
	}
}
