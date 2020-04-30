package egovframework.com.cmm.interceptor;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Properties;
import java.util.Set;

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
		} else if (mobileClientServerURL != null) {			
            String[] allowedIPAddresses = mobileClientServerURL.split(",");
            Set<String> allowedIPAddressSet = new HashSet<String>();
            Set<String> rejectedIPAddressSet = new HashSet<String>();
            
            for (int i = 0; i < allowedIPAddresses.length; i++) {
            	String ipAddress = allowedIPAddresses[i].trim();
            	
            	// -10.0.1.1 과 같이 -로 시작하는 IP 주소는 거부한다.
            	// 10.0과 같이 IP 대역으로 허용할 때 그 중 예외로 하고 싶은 IP 주소를 지정한다.
            	// 쿠버네티스 환경에서 Pod로부터 접속하는 것이 아니라 Pod가 실행 중인 Node로부터
            	// 접근할 때 클라이언트 주소가 gateway 주소로 나타나는 경우가 있어 이를 제외하기 위해 추가함
            	if (ipAddress.startsWith("-")) {
            		rejectedIPAddressSet.add(ipAddress.substring(1));
            	} else {
            		allowedIPAddressSet.add(ipAddress);
            	}
            }
			                        
            if (rejectedIPAddressSet.contains(ip)) {
            	logger.debug("rejectedIPAddressSet=" + rejectedIPAddressSet + ",ip=" + ip + " rejected");
            	 
            	return false;
            }
            
        	boolean isRemoteIpBelongToIpRange = false;
        	Iterator<String> iter = allowedIPAddressSet.iterator();
        	
        	while (iter.hasNext()) {
        		if (ip.startsWith(iter.next())) {
        			isRemoteIpBelongToIpRange = true;
        			break;
        		}
        	}
            
        	if (isRemoteIpBelongToIpRange) {
        		return true;
        	}        	
		}
		
		return false;		
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		CommonUtil.addXUACompatibleHeaderToResponse(request, response);
	}
	
}
