package egovframework.com.cmm.interceptor;

import java.util.Properties;

import javax.annotation.Resource;
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

public class MAuthenticInterceptor extends WebContentInterceptor {
	
	/** CRYPTO */
    @Resource(name="crypto")
    private EgovFileScrty egovFileScrty;
    
    @Autowired
    private CommonUtil commonUtil;
    
    @Autowired
	private Properties config;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(MAuthenticInterceptor.class);

	/**
	 * config.mobileClientServerURL과 request의 ip 비교 체크
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
		String ip = ClientUtil.getClientIP(request);
		String mobileClientServerURL = config.getProperty("config.mobileClientServerURL");
		
		logger.debug("ip=" + ip + ",mobileClientServerURL=" + mobileClientServerURL);
	
		if (ip.equals("127.0.0.1")) {			
			return true;
		} else if (mobileClientServerURL != null){			
			if (mobileClientServerURL.contains(ip)) {				
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
