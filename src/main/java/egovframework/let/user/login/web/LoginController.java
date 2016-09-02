package egovframework.let.user.login.web;

import java.net.URLEncoder;
import java.security.PrivateKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.LocaleResolver;

import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.dao.EzCommonDAO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
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
	
    /** LoginService */
	@Resource(name = "loginService")
    private LoginService loginService;
	
	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;    
    
    @Resource(name="EzCommonDAO")
	private EzCommonDAO ezCommonDAO;
        
    /** CRYPTO */
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
    
    @Autowired
    private LocaleResolver localeResolver;
    
	/**
	 * 로그인 화면으로 들어간다
	 * @param vo - 로그인후 이동할 URL이 담긴 LoginVO
	 * @return 로그인 페이지
	 * @exception Exception
	 */
    
    @RequestMapping(value="/user/login/login.do")
	public String loginView(@ModelAttribute("loginVO") LoginVO loginVO,	HttpServletRequest request,	HttpServletResponse response, ModelMap model) throws Exception {
    	String pbm = egovFileScrty.getPbm();
 	
		model.addAttribute("publicModulus", pbm);
		model.addAttribute("publicExponent", "10001");
    	
    	return "user/login/login";
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
    public String actionLogin(Locale locale, @ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	logger.debug("=========================================== 로그인 ============================================");
    	
    	String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

		String _uid = EgovFileScrty.decryptRsa(pk, loginVO.getEncryptID());
		String rpwd = EgovFileScrty.decryptRsa(pk, loginVO.getEncryptPass());
		String _pwd = EgovFileScrty.encryptPassword(rpwd, _uid);
		
		//DB에서 lang 값 가져옴
		String lang = ezCommonDAO.selectUserGetLang(EgovFileScrty.decryptRsa(pk, loginVO.getEncryptID()));
		String acceptLanguage = request.getHeader("Accept-Language");
		String returnValue = "";
		
		if (lang != null &&lang.equals("1")) {
			returnValue = "ko";
		} else if (lang != null && lang.equals("2")) {
			returnValue = "en";
		} else if (lang != null && lang.equals("3")) {
			returnValue = "ja";
		} else if (lang != null && lang.equals("4")) {
			returnValue = "zh";
		} else {
			// userLocalInfo 테이블에 정보가 없을 때 (첫 로그인)
			returnValue = acceptLanguage.substring(0, 2);
			
			if (acceptLanguage.substring(0, 2).equals("ko")) {
				lang = "1";
			} else if (acceptLanguage.substring(0, 2).equals("en")) {
				lang = "2";
			} else if (acceptLanguage.substring(0, 2).equals("ja")) {
				lang = "3";
			} else {
				lang = "4";
			}
			
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("userID", _uid);
			map.put("timeZone", "235|+09:00");
			map.put("lang", lang);
			ezCommonDAO.insertTblUserLocalInfo(map);
		}
		//CookieLocaleResolver에 DB에서 가져온 lang값을 set해줌
		locale = new Locale(returnValue);
		localeResolver.setLocale(request, response, locale);
		
		loginVO.setId(_uid);
		loginVO.setPassword(_pwd);
    	// 1. 일반 로그인 처리
        LoginVO resultVO = loginService.selectUser(loginVO);
        
        if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {        	
        	Calendar cal = Calendar.getInstance();
        	cal.add(Calendar.MONTH, -6);
        	
        	Date baseDT = cal.getTime();        	
        	Date lastDT = resultVO.getUpdateDT();
        	//오늘 기준 6개월전 날짜, 마지막 개인정보 수정일자 간 뺄셈
			int diff = EgovDateUtil.getDaysDiff(baseDT, lastDT);
			//0보다 작아지면 패스워드 변경기한 Expired
			if(diff <= 0){
				model.addAttribute("message", egovMessageSource.getMessage("fail.user.passwordExpired", locale));
	        	return "forward:/user/login/login.do";
			}else{
				String ip = ClientUtil.getClientIP(request);		
				loginVO.setIp(ip);
				//IP Address,  마지막 login시간 저장
				loginService.updateUser(loginVO);
				//접속 로그정보 저장
				resultVO.setIp(ip);
				resultVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
				resultVO.setOs(ClientUtil.getClientInfo(request, "os"));
				resultVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));

				if(resultVO.getTitle2() == null){
					resultVO.setTitle2("");
				}
				loginService.insertLog(resultVO);
				
				String cInfo = config.getProperty("config.ServerName")+ "///" + _uid + "///" + _pwd + "///" + ip + "///" + rpwd + "///" + locale + "///" + lang;
				String loginCookie = egovFileScrty.encryptAES(cInfo);
				
	        	Cookie cookieID = new Cookie("loginCookie", loginCookie);
	        	cookieID.setPath("/");
	        	response.addCookie(cookieID);
	        	
	        	Cookie cookieName = new Cookie("userName", URLEncoder.encode(resultVO.getDisplayName1(), "utf-8"));
	        	cookieName.setPath("/");
	        	response.addCookie(cookieName);
	        	
	        	//return "redirect:/cmm/main/mainPage.do";
	        	return "redirect:/ezPortal/portalMain.do";
			}
        }else{
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
    			if(!cookie.getName().equals("saveid")){
    				cookie.setMaxAge(0);
    				cookie.setPath("/");
    				response.addCookie(cookie);
    			}
    	    }
    	}
    	
    	return "redirect:/user/login/login.do"; 
    }
    
}