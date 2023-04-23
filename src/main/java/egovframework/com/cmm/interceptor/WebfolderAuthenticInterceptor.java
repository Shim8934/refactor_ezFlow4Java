package egovframework.com.cmm.interceptor;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

public class WebfolderAuthenticInterceptor extends WebContentInterceptor {
	
	/** CRYPTO */
    @Resource(name="crypto")
    private EgovFileScrty egovFileScrty;
    
    @Autowired
	private Properties config;
    
    @Autowired
    private EzWebFolderService_y webfolder;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(WebfolderAuthenticInterceptor.class);

	/**
	 * config.mobileClientServerURL과 request의 ip 비교 체크
	 */
	@SuppressWarnings("unchecked")
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
		String ip = ClientUtil.getClientIP(request);
		String mobileClientServerURL = config.getProperty("config.mobileClientServerURL");
		
		
		// request가 String으로 온다고 가정했을때 
		// 위와같이 가정을 한다면 request에 id:pw 이런식으로 들어오게 될것 
		// 그렇게 되면 :로 끊어서 처리해야함
		// 그렇게 처리하면 지금 jsonObject로 해놓은 것들을 다시 처리해야함 ( loginAPI ) 
		
		// request가 JsonObject로 온다고 가정한다면 request로 오는것을 처리해야함
		// 어떻게 하면 request에서 json을 뽑아낼수 있을지 찾아내야함
		// 위와같이 하게 되면 바꿀내용은 없고 추가할 내용만 존재하게 됨
		
		logger.debug("ip=" + ip + ",mobileClientServerURL=" + mobileClientServerURL);
	
		if (ip.equals("127.0.0.1")) {			
			return true;
		} else if (mobileClientServerURL != null){			
			if (mobileClientServerURL.contains(ip)) {				
				return true;
			} 

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

			boolean result = false; 
			
			try {
				JSONObject requestObject = new JSONObject();
				String key = request.getHeader("key");
				JSONParser parser = new JSONParser();
				requestObject = (JSONObject)parser.parse(key);
				
				String userId = requestObject.get("userid") != null ? (String)requestObject.get("userid") : "";
				String token = requestObject.get("token") != null ? (String)requestObject.get("token") : "";
				int tenantId = 0;
				
				if (token.equals("")) {
					try (PrintWriter writer = response.getWriter();) {
						JSONObject obj = new JSONObject();
						obj.put("status", "no-token");
						writer.println(obj.toString());
						response.setContentType("application/json;charset=utf-8");
					} catch (IOException e1) {
						logger.error(e1.getMessage(), e1);
					}
					return result;
				}
				
				int count = webfolder.existsTokenCheck(userId, token, tenantId);
				
				if (count > 0) {
					result =  true;
				} else {
					try (PrintWriter writer = response.getWriter();) {
						JSONObject obj = new JSONObject();
						obj.put("status", "auth-fail");
						writer.println(obj.toString());
						response.setContentType("application/json;charset=utf-8");
					} catch (IOException e1) {
						logger.error(e1.getMessage(), e1);
					}
				}
			} catch (Exception e) {
				try (PrintWriter writer = response.getWriter();) {
					JSONObject obj = new JSONObject();
					obj.put("status", "error");
					writer.println(obj.toString());
					response.setContentType("application/json;charset=utf-8");
				} catch (IOException e1) {
					logger.error(e1.getMessage(), e1);
				}
			}
			
			return result;
		} else {			
			return false;
		}
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		CommonUtil.addXUACompatibleHeaderToResponse(request, response);
	}
}
