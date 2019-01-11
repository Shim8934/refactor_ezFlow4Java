package egovframework.com.cmm.interceptor;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import javax.annotation.Resource;
import javax.naming.ServiceUnavailableException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import com.microsoft.aad.adal4j.AuthenticationContext;
import com.microsoft.aad.adal4j.AuthenticationResult;
import com.microsoft.aad.adal4j.ClientCredential;
import com.nimbusds.oauth2.sdk.AuthorizationCode;
import com.nimbusds.openid.connect.sdk.AuthenticationResponse;
import com.nimbusds.openid.connect.sdk.AuthenticationResponseParser;
import com.nimbusds.openid.connect.sdk.AuthenticationSuccessResponse;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.web.LoginController;
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

public class AuthenticInterceptor extends WebContentInterceptor {
	
	/** CRYPTO */
    @Resource(name="crypto")
    private EgovFileScrty egovFileScrty;
    
    @Autowired
    private CommonUtil commonUtil;
    
	@Resource(name = "loginService")
    private LoginService loginService;

    @Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private LoginController loginController;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(AuthenticInterceptor.class);

    private static final String authority = "https://login.windows.net";
    
	/**
	 * 세션에 계정정보(LoginVO)가 있는지 여부로 인증 여부를 체크한다.
	 * 계정정보(LoginVO)가 없다면, 로그인 페이지로 이동한다.
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
		try {
			String ChkOldBrowser = ezCommonService.getTenantConfig("ChkOldBrowser", loginService.getTenantId(request.getServerName().toString()));
			//IE 계열이면서 IE10이나 IE11이 아닌 경우에 로그아웃 시키면서 경고창을 띄운다.
			String agent = request.getHeader("User-Agent");
			agent = agent != null ? agent : "";
			if (ChkOldBrowser != null && ChkOldBrowser.equals("YES") && ((agent.indexOf("Trident") > 0 || agent.toLowerCase().indexOf("msie") > 0) && !(agent.indexOf("Trident/6.0") > 0 || agent.indexOf("Trident/7.0") > 0))){
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
				
				// 2018.10.22 이석화 추가 - 세션 제거 
				request.getSession().invalidate();
				
				request.setAttribute("message", "oldBrowser");
				RequestDispatcher dispatcher = request.getRequestDispatcher("/user/login/login.do");
				dispatcher.forward(request, response);
			}
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		if(!commonUtil.checkMultiLogin(request, response)) {
			try {
//				RequestDispatcher dispatcher = request.getRequestDispatcher("/user/login/actionLogoutWithRedirectUri.do?redirectUri=" + "/user/login/login.do&message=multiLoginNoti");
				RequestDispatcher dispatcher = request.getRequestDispatcher("/user/login/actionLogoutWithRedirectUri.do?redirectUri=" + "/user/login/login.do&multiLoginFlag=y");
				dispatcher.forward(request, response);
				
				return false;
			} catch (Exception e) { 
				e.printStackTrace();
			}
		} 
		
		if (commonUtil.isLoginCookieExists(request, response)) {
			return true;
		} else {
			String ezOffice365Auth = "";			
			int tenantId = -1;
			
			try {
		        String serverName = request.getServerName();
		        tenantId = loginService.getTenantId(serverName);
		        
		        logger.debug("serverName=" + serverName + ",tenantId=" + tenantId);
		    	
		        ezOffice365Auth = ezCommonService.getTenantConfig("ezOffice365Auth", tenantId);
		        
		    	logger.debug("ezOffice365Auth=" + ezOffice365Auth);
			} catch (Exception e) {
				e.printStackTrace();
				
				return false;
			}
    	
	        if (ezOffice365Auth.equals("YES")) {
				String ezOffice365ClientId = "";
				String ezOffice365ClientSecret = "";
	        	
	        	try {
		        	ezOffice365ClientId = ezCommonService.getTenantConfig("ezOffice365ClientId", tenantId);
		        	ezOffice365ClientSecret = ezCommonService.getTenantConfig("ezOffice365ClientSecret", tenantId);
	        	} catch (Exception e) {
	        		e.printStackTrace();
	        		
	        		return false;
	        	}
	        	
				String currentUri = request.getScheme()
						+ "://"
						+ request.getServerName()
						+ ("http".equals(request.getScheme())
								&& request.getServerPort() == 80
								|| "https".equals(request.getScheme())
								&& request.getServerPort() == 443 ? "" : ":"
								+ request.getServerPort())
						+ request.getRequestURI();
				String fullUrl = currentUri
						+ (request.getQueryString() != null ? "?"
								+ request.getQueryString() : "");
				
				logger.debug("fullUrl=" + fullUrl);
				
				if (containsAuthenticationData(request)) {
					Map<String, String> params = new HashMap<String, String>();
					
					for (String key : request.getParameterMap().keySet()) {
						params.put(key, request.getParameterMap().get(key)[0]);
					}
					
					try {
						AuthenticationResponse authResponse = AuthenticationResponseParser.parse(new URI(fullUrl), params);
						
						if (authResponse instanceof AuthenticationSuccessResponse) {
							AuthenticationSuccessResponse oidcResponse = (AuthenticationSuccessResponse)authResponse;
							
							AuthenticationResult result = getAccessToken(
															"common",
															ezOffice365ClientId,
															ezOffice365ClientSecret,
															oidcResponse.getAuthorizationCode(),
															currentUri);
							
							String userId = result.getUserInfo().getDisplayableId();
							
							logger.debug("userId=" + userId);
							
							if (userId != null && !userId.isEmpty()) {	
								int atSignPos = userId.indexOf("@");
								String domainName = "";
								
								if (atSignPos != -1) {
									domainName = userId.substring(atSignPos + 1);									
									userId = userId.substring(0, atSignPos);
									
									logger.debug("split userId=" + userId + ",domainName=" + domainName);
									
									// Full 이메일 주소로 구성된 아이디로부터 추출한 도메인명으로 Tenant ID를 다시 구한다.
									tenantId = loginService.getTenantId(domainName);
									
									logger.debug("new tenantId=" + tenantId);
								}
								
								loginController.createLoginCookie(userId, " ", " ", tenantId, request, response,"","");
								
								response.sendRedirect(request.getRequestURI());
							}														
						}
					} catch (Throwable e) {
						e.printStackTrace();												
					}
					
					return false;
				} else {
		        	logger.debug("No authentication data exists. Redirecting to Azure login page...");
		        	
					try {					
						response.sendRedirect(getRedirectUrl("common", ezOffice365ClientId, currentUri));
					} catch (IOException e) {
						e.printStackTrace();
					}
					
					return false;					
				}
	        } else {
	        	logger.debug("No login cookie exists. Redirecting to login page...");
	        		        	
				try {
		        	String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", tenantId);
					
		        	if (!dotNetIntegration.equals("YES")) {
		        		response.sendRedirect("/user/login/login.do");
		        	}
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				return false;
	        }
		}
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		CommonUtil.addXUACompatibleHeaderToResponse(request, response);
	}
	
	private String getRedirectUrl(String tenantName, String clientId, String currentUri) {
        String redirectUrl = "";
        		
        try {
			redirectUrl = authority + "/" + tenantName
			        + "/oauth2/authorize?response_type=code%20id_token&scope=openid&response_mode=form_post&redirect_uri="
			        + URLEncoder.encode(currentUri, "UTF-8") + "&client_id=" + clientId
			        + "&nonce=" + UUID.randomUUID();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
        
        return redirectUrl;
	}
	   
    private boolean containsAuthenticationData(HttpServletRequest httpRequest) {
        return httpRequest.getMethod().equalsIgnoreCase("POST")
        		&& (httpRequest.getParameterMap().containsKey("error")
                        || httpRequest.getParameterMap().containsKey("id_token")
                        || httpRequest.getParameterMap().containsKey("code"));
    }
    
    private AuthenticationResult getAccessToken(
    								String tenantName,
    								String clientId,
    								String clientSecret,
    								AuthorizationCode authorizationCode,  
    								String currentUri) throws Throwable {
        String authCode = authorizationCode.getValue();
        ClientCredential credential = new ClientCredential(clientId, clientSecret);
        AuthenticationContext context = null;
        AuthenticationResult result = null;
        ExecutorService service = null;
        
        try {
            service = Executors.newFixedThreadPool(1);
            context = new AuthenticationContext(authority + "/" + tenantName + "/", true,
                    service);
            Future<AuthenticationResult> future = context
                    .acquireTokenByAuthorizationCode(authCode, new URI(
                            currentUri), credential, null);
            result = future.get();
        } catch (ExecutionException e) {
            throw e.getCause();
        } finally {
            service.shutdown();
        }

        if (result == null) {
            throw new ServiceUnavailableException(
                    "authentication result was null");
        }
        
        return result;
    }
    
}
