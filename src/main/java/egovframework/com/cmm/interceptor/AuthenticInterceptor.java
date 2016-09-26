package egovframework.com.cmm.interceptor;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/**
 * 인증여부 체크 인터셉터
 * @author 공통서비스 개발팀 서준식
 * @since 2011.07.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2011.07.01  서준식          최초 생성
 *  2011.09.07  서준식          인증이 필요없는 URL을 패스하는 로직 추가
 *  2014.06.11  이기하          인증이 필요없는 URL을 패스하는 로직 삭제(xml로 대체)
 *  </pre>
 */

public class AuthenticInterceptor extends WebContentInterceptor {
	
	/** CRYPTO */
    @Resource(name="crypto")
    private EgovFileScrty egovFileScrty;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(AuthenticInterceptor.class);

	/**
	 * 세션에 계정정보(LoginVO)가 있는지 여부로 인증 여부를 체크한다.
	 * 계정정보(LoginVO)가 없다면, 로그인 페이지로 이동한다.
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
		String isCookie = null;		
		Cookie[] cookies = request.getCookies();
		
		logger.debug("=========================================== Interface Check ============================================");

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
	    					isCookie = "Y";
	    				}
					} catch (Exception e) {
						// TODO Auto-generated catch block
						//e.printStackTrace();
					}
    	        }
    	    }
    	}
		
		if (isCookie != null) {
			return true;
		} else {
			ModelAndView modelAndView = new ModelAndView("redirect:/user/login/login.do");
			throw new ModelAndViewDefiningException(modelAndView);
		}
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		String browser = ClientUtil.getClientInfo(request, "browser");
		String compatibleValue = null;
		
		if (browser.equals("Edge") || browser.equals("IE11")) {
			compatibleValue = "IE=edge";
		} else if (browser.equals("IE10") || browser.equals("IE9")) {
			compatibleValue = "IE=9";
		} else if (browser.equals("IE8")) {
			compatibleValue = "IE=8";
		}
		
		if (compatibleValue != null) {
			response.setHeader("X-UA-Compatible", compatibleValue);
		}
	}
	
}
