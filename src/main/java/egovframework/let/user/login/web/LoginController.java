package egovframework.let.user.login.web;

import java.net.URLEncoder;
import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
/**
 * 일반 로그인을 처리하는 컨트롤러 클래스
 * @author 공통서비스 개발팀 박지욱
 * @since 2009.03.06
 * @version 1.0
 * @see
 *  
 * <pre>
 * << 개정이력(Modification Information) >>
 * 
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2009.03.06  박지욱          최초 생성 
 *  2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성 
 *  
 *  </pre>
 */
@Controller
public class LoginController {

	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
	
    /** LoginService */
	@Resource(name = "loginService")
    private LoginService loginService;
	
	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;    
    
    @Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
        
    /** CRYPTO */
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
    
    @Autowired
    private EzEmailUserAdminService ezEmailUserAdminService;
    
    @Autowired
	private EzOrganAdminService ezOrganAdminService;
    
    @Autowired
    private LocaleResolver localeResolver;
        
	/**
	 * 로그인 화면으로 들어간다
	 * @param vo - 로그인후 이동할 URL이 담긴 LoginVO
	 * @return 로그인 페이지
	 * @exception Exception
	 */
    
    @RequestMapping(value="/user/login/login.do")
	public String loginView(HttpServletRequest request,	HttpServletResponse response, ModelMap model) throws Exception {
    	if (commonUtil.isLoginCookieExists(request, response)) {
    	    return "redirect:/ezPortal/portalMain.do"; 
    	}
        	
    	String pbm = egovFileScrty.getPbm();
    	
		model.addAttribute("publicModulus", pbm);
		model.addAttribute("publicExponent", "10001");
    
		CommonUtil.addXUACompatibleHeaderToResponse(request, response);
		
    	return "/user/login/login";
    
	}
    
    
    public void setLocaleResolver(LocaleResolver localeResolver) {
    	this.localeResolver = localeResolver;
    }
	
    /**
	 * 일반 로그인을 처리한다
	 * @param vo - 아이디, 비밀번호가 담긴 LoginVO
	 * @param request - 세션처리를 위한 HttpServletRequest
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
    @RequestMapping(value="/user/login/actionLogin.do")
    public String actionLogin(Locale locale, @ModelAttribute("loginVO") LoginVO loginVO, HttpSession session, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	logger.debug("=========================================== login ============================================");
    	
    	String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

		String _uid = EgovFileScrty.decryptRsa(pk, loginVO.getEncryptID());
		
		if (_uid == null || _uid.equals("")) {
		    logger.debug("invalid _uid=" + _uid);		    
		    return "";
		}
		
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        int tenantId = loginService.getTenantId(serverName);
        
        logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);
		
		String rpwd = EgovFileScrty.decryptRsa(pk, loginVO.getEncryptPass());
		String _pwd = EgovFileScrty.encryptPassword(rpwd, _uid);
		
		loginVO.setId(_uid);
		loginVO.setPassword(_pwd);
		loginVO.setTenantId(tenantId);
		
    	//일반 로그인 처리
        LoginVO resultVO = loginService.selectUser(loginVO);
        
        if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {        	
        	//비밀번호 변경 팝업 상태 값 초기화
        	int diff = 1;
        	
        	if (resultVO.getLoginCnt() == 0) {
        		diff = 0;
        		model.addAttribute("isFirstLogin", "Y");
        	} else {
	        	String expirePassPeriod = ezCommonService.getTenantConfig("ExpirePassPeriod", tenantId);        	
	        	
	        	if (!expirePassPeriod.trim().equals("0")) {
	        		int realPeriod = Integer.parseInt("-" + expirePassPeriod.trim());
	        		
	        		Calendar cal = Calendar.getInstance();
	        		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	            	
	            	String baseStr = commonUtil.getTodayUTCTime("");        	
	            	Date baseDT = date.parse(baseStr);
	            	            	
	            	cal.setTime(baseDT);
	            	cal.add(Calendar.DATE, realPeriod);
	            	
	            	baseDT = cal.getTime();
	            	Date lastDT = resultVO.getUpdateDT();
	            	//오늘 기준 6개월전 날짜, 마지막 개인정보 수정일자 간 뺄셈
	    			diff = EgovDateUtil.getDaysDiff(baseDT, lastDT);	    			
	        	}	        	
        	}        	        	
			//0보다 작아지면 패스워드 변경기한 Expired
			if (diff <= 0) {				
				model.addAttribute("isExpireDate", "Y");
				model.addAttribute("userId", _uid);
				
	        	return "forward:/user/login/login.do";
			} else {			
				String ip = ClientUtil.getClientIP(request);		
				loginVO.setIp(ip);
				
				//IP Address,  마지막 login시간 저장
				loginService.updateUser(loginVO);
				
				//접속 로그정보 저장
				resultVO.setIp(ip);
				resultVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
				resultVO.setOs(ClientUtil.getClientInfo(request, "os"));
				resultVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));
				resultVO.setTenantId(tenantId);

				if(resultVO.getTitle2() == null){
					resultVO.setTitle2("");
				}
				
				loginService.insertLog(resultVO);

				//DB에서 lang 값 가져옴
				String lang = ezCommonService.selectUserGetLang(_uid, tenantId);				
				String acceptLanguage = request.getHeader("Accept-Language");
				String returnValue = "";
				
				returnValue = commonUtil.getTwoLetterLangFromLangNum(lang);
				
				//userLocalInfo 테이블에 정보가 없을 때 (첫 로그인)				
				if (returnValue == null || returnValue.equals("")) {
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
				        returnValue = acceptLanguage.substring(0, 2);
				    //이유는 정확히 알 수 없지만 로그를 확인한 결과 윗 라인에서 acceptLanguage가 null인 경우가 발생하여 추가함.
				    } else {				        
				        returnValue = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
				    }
					
				    lang = commonUtil.getLangNumFromTwoLetterLang(returnValue);
				    
				    //브라우저 언어가 한국어,영어,일본어,중국어가 아닐 때 config의 primary 언어를 가져옴.
				    if (lang.equals("")) {						
						lang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
					}
					
					logger.debug("userID="+_uid);
					logger.debug("lang="+lang);
					
					ezCommonService.insertTblUserLocalInfo(_uid, "235|+09:00", lang, tenantId);
				}
				
				String timeZone = ezCommonService.selectUserGetTimeZone(_uid, tenantId);
				
				logger.debug("_uid=" + _uid + ",lang=" + lang + ",timeZone=" + timeZone + ",acceptLanguage=" + acceptLanguage);
				
				//CookieLocaleResolver에 DB에서 가져온 lang값을 set해줌
				locale = new Locale(returnValue);
				localeResolver.setLocale(request, response, locale);
				
				//80 포트가 아닌 경우엔 포트 번호도 포함시킨다.
				if (serverPort != 80) {
				    serverName = serverName + ":" + serverPort;
				}
				
				//Cookie 생성
				String cInfo = serverName + "///" + _uid + "///" + _pwd + "///" + ip + "///" + rpwd + "///" + locale + "///" + lang + "///" + timeZone + "///" + tenantId;
				String loginCookie = egovFileScrty.encryptAES(cInfo);
				
	        	Cookie cookieID = new Cookie("loginCookie", loginCookie);
	        	cookieID.setPath("/");
	        	response.addCookie(cookieID);
	        	
	        	Cookie cookieName = new Cookie("userName", URLEncoder.encode(resultVO.getDisplayName1(), "utf-8"));
	        	cookieName.setPath("/");
	        	response.addCookie(cookieName);
	        	
	        	//세션 생성 - 일시적으로 주석처리 필요할때 사용
	        	//session = request.getSession();	        	
	        	
	        	if (config.getProperty("config.IsJMochaStandAlone").equals("YES")) {
	        	    return "redirect:/ezEmail/mailAloneMain.do";
	        	} else {
	        	    return "redirect:/ezPortal/portalMain.do";
	        	}
			}			
        } else {
        	model.addAttribute("message", egovMessageSource.getMessage("fail.common.login", locale));
        	return "forward:/user/login/login.do";
        }        
    }
    
    /**
	 * 로그아웃한다.
	 * @return String
	 * @exception Exception
	 */
    @RequestMapping(value="/user/login/actionLogout.do")
	public String actionLogout(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	Cookie[] cookies = request.getCookies();
    	
    	if (cookies != null) {
    		for (Cookie cookie : cookies) {
    			if(!cookie.getName().equals("saveid") && !cookie.getName().matches("POPUP_.*")){
    				cookie.setMaxAge(0);
    				cookie.setPath("/");
    				response.addCookie(cookie);
    			}
    	    }
    	}
    	
    	return "redirect:/user/login/login.do"; 
    }
    
    @RequestMapping(value = "/user/login/setPassword.do")
    public void setPassword(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse response) throws Exception{
    	userInfo = commonUtil.userInfo(loginCookie);

    	if (userInfo.getId().equals("masteradmin")) {
    		List<String> userIDList = loginService.getUserIDList();
    		
    		for (int k = 0; k < userIDList.size(); k++) {
    			logger.info("setPassword.do::userID = " + userIDList.get(k) + " :: Set Password Complete");
    			
    			String pwd = EgovFileScrty.encryptPassword(userIDList.get(k) + "1!", userIDList.get(k));
    			
    			loginService.updatePassword(userIDList.get(k), pwd);
    		}
    	}
    }
        
    @RequestMapping(value = "/user/login/changeExPassword.do", produces = "text/html; charset=utf-8")
	@ResponseBody
    public String changeExPassword(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
    	logger.debug("=========================================== changePassword ============================================");
    	
    	String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	String encUserId = request.getParameter("USERID");
    	String encPass = request.getParameter("OLDPASSWORD");
    	String encNewPass = request.getParameter("NEWPASSWORD");
    	
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

		String _uid = EgovFileScrty.decryptRsa(pk, encUserId);
		
		if (_uid == null || _uid.equals("")) {
		    logger.debug("invalid _uid=" + _uid);
		    
		    return "DECRYPTERROR";
		}
		
        String serverName = request.getServerName();        
        int tenantId = loginService.getTenantId(serverName);
		
		String rpwd = EgovFileScrty.decryptRsa(pk, encPass);
		String _pwd = EgovFileScrty.encryptPassword(rpwd, _uid);
		
		loginVO.setId(_uid);
		loginVO.setPassword(_pwd);
		loginVO.setTenantId(tenantId);
		
    	//로그인 정보 확인
        LoginVO resultVO = loginService.selectUser(loginVO);
        
        if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {        	
        	String epwd = EgovFileScrty.decryptRsa(pk, encNewPass);

        	//e-mail 연동
			String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
			String mailAddr = _uid + "@" + domain;
			//이메일 계정의 암호를 새 암호로 설정한다.
			int rc = ezEmailUserAdminService.checkAndUpdateUserPassword(mailAddr, rpwd, epwd);
			//checkAndUpdateUserPassword 성공
			if (rc == 0) {                                                  
			    try {
			        //로컬 시스템에서 해당 User의 암호를 변경한다.
			        ezOrganAdminService.setPassword(_uid, epwd, tenantId);
			        
			        String ip = ClientUtil.getClientIP(request);		
					loginVO.setIp(ip);
			        //IP Address,  마지막 login시간 저장
					loginService.updateUser(loginVO);
			        return "OK";
			    } catch (Exception e) {
			    	//Exception이 발생하면 취소 처리를 한다.
			        ezEmailUserAdminService.checkAndUpdateUserPassword(mailAddr, epwd, rpwd);			        
			        return "UPDATEERROR";
			    }                                       
			} else {
				return "MAILERROR";
			}        	
        } else {
        	return "LOGINERROR";
        }    	
    }
    
}