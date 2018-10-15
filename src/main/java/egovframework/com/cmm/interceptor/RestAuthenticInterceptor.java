package egovframework.com.cmm.interceptor;

import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;

public class RestAuthenticInterceptor extends WebContentInterceptor {
	
    @Autowired
	private Properties config;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(RestAuthenticInterceptor.class);

	/**
	 * config.restAPIAllowedClientIP와 request의 ip 비교 체크
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
		String ip = ClientUtil.getClientIP(request);
		String restAPIAllowedClientIP = config.getProperty("config.restAPIAllowedClientIP");
		
		logger.debug("ip=" + ip + ",restAPIAllowedClientIP=" + restAPIAllowedClientIP);
	
		if (ip.equals("127.0.0.1")) {
			return true;
		} else if (restAPIAllowedClientIP != null) {
			if (restAPIAllowedClientIP.contains(ip)) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		CommonUtil.addXUACompatibleHeaderToResponse(request, response);
	}
	
}
