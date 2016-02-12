package egovframework.let.user.login.web;

import java.net.URLEncoder;
import java.security.PrivateKey;
import java.util.Date;

import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.com.cmm.EgovMessageSource;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ibm.icu.util.Calendar;
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

    /** LoginService */
	@Resource(name = "loginService")
    private LoginService loginService;
	
	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;    
        
    /** CRYPTO */
    @Resource(name="crypto") 
    EgovFileScrty egovFileScrty;
    
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
	
    /**
	 * 일반 로그인을 처리한다
	 * @param vo - 아이디, 비밀번호가 담긴 LoginVO
	 * @param request - 세션처리를 위한 HttpServletRequest
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
    @RequestMapping(value="/user/login/actionLogin.do")
    public String actionLogin(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

		String _uid = EgovFileScrty.decryptRsa(pk, loginVO.getEncryptID());
		String _pwd = EgovFileScrty.encryptPassword(EgovFileScrty.decryptRsa(pk, loginVO.getEncryptPass()), _uid);
		
		loginVO.setId(_uid);
		loginVO.setPassword(_pwd);

    	// 1. 일반 로그인 처리
        LoginVO resultVO = loginService.actionLogin(loginVO);

        if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
        	Calendar cal = Calendar.getInstance();
        	cal.add(Calendar.MONTH, -6);
        	
        	Date baseDT = cal.getTime();        	
        	Date lastDT = resultVO.getUpdateDT();
        	//오늘 기준 6개월전 날짜, 마지막 개인정보 수정일자 간 뺄셈
			int diff = EgovDateUtil.getDaysDiff(baseDT, lastDT);
			//0보다 작아지면 패스워드 변경기한 Expired
			if(diff <= 0){
				model.addAttribute("message", egovMessageSource.getMessage("fail.user.passwordExpired"));
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
				
				loginService.insertLog(resultVO);
		
	        	Cookie cookieID = new Cookie("userID", loginVO.getEncryptID());
	        	cookieID.setPath("/");
	        	response.addCookie(cookieID);
	
	        	Cookie cookiePass = new Cookie("userPass", loginVO.getEncryptPass());
	        	cookiePass.setPath("/");
	        	response.addCookie(cookiePass);

	        	Cookie cookieName = new Cookie("userName", URLEncoder.encode(resultVO.getDisplayName1(), "utf-8"));
	        	cookieName.setPath("/");
	        	response.addCookie(cookieName); 

	        	return "redirect:/cmm/main/mainPage.do";
			}
        }else{
        	model.addAttribute("message", egovMessageSource.getMessage("fail.common.login"));
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