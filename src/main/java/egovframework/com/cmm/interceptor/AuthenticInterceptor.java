package egovframework.com.cmm.interceptor;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.naming.ServiceUnavailableException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import com.microsoft.aad.msal4j.AuthorizationCodeParameters;
import com.microsoft.aad.msal4j.ClientCredentialFactory;
import com.microsoft.aad.msal4j.ConfidentialClientApplication;
import com.microsoft.aad.msal4j.IAuthenticationResult;
import com.nimbusds.oauth2.sdk.AuthorizationCode;
import com.nimbusds.openid.connect.sdk.AuthenticationErrorResponse;
import com.nimbusds.openid.connect.sdk.AuthenticationResponse;
import com.nimbusds.openid.connect.sdk.AuthenticationResponseParser;
import com.nimbusds.openid.connect.sdk.AuthenticationSuccessResponse;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.web.LoginController;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.ezEKP.ezBoard.service.EzBoardService;

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

	@Autowired
	private EzBoardService ezBoardService;

	@Autowired
	private Properties config;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(AuthenticInterceptor.class);

    private static final String authority = "https://login.microsoftonline.com";
	
	private Set<String> guestAccessibleUris = Collections.emptySet();
	
	@PostConstruct
	public void initGuestAccessibleUris() throws Exception {
		String tenantID = config.getProperty("config.guestDefaultTenantId");
		String uriString = ezCommonService.getTenantConfig("guestAccessibleUris", Integer.parseInt(tenantID));
		if (uriString != null) {
			guestAccessibleUris = Arrays.stream(uriString.split(","))
					.map(String::trim)
					.collect(Collectors.toSet());
		}
	}
    
	/**
	 * 세션에 계정정보(LoginVO)가 있는지 여부로 인증 여부를 체크한다.
	 * 계정정보(LoginVO)가 없다면, 로그인 페이지로 이동한다.
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {		
		String loginCookieExists =  commonUtil.loginCookieExists(request, response);
		if(!commonUtil.checkMultiLogin(request, response)) {
			try {
//				RequestDispatcher dispatcher = request.getRequestDispatcher("/user/login/actionLogoutWithRedirectUri.do?redirectUri=" + "/user/login/login.do&message=multiLoginNoti");
				RequestDispatcher dispatcher = request.getRequestDispatcher("/user/login/actionLogoutWithRedirectUri.do?redirectUri=" + "/user/login/login.do&multiLoginFlag=y");
				dispatcher.forward(request, response);
				
				return false;
			} catch (Exception e) { 
				logger.error(e.getMessage(), e);
			}
		}

		if ("0".equals(loginCookieExists)) {
			try {
		        String serverName = request.getServerName();
		        int tenantId = loginService.getTenantId(serverName);
	        	String mobileRedirection = ezCommonService.getTenantConfig("mobileRedirection", tenantId);
	        	String userOs = ClientUtil.getClientInfo(request, "os");
	        	
	        	if (userOs.equals("iOS") || userOs.equals("Android") || userOs.equals("BlackBerry") || userOs.equals("iPod")) {
	        		if (!mobileRedirection.equals("") && !mobileRedirection.equals("*")) {
	        			response.sendRedirect(mobileRedirection);
	        			
	    				return true;	        			
	        		}
	        	}	        	
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}

			String referer = request.getHeader("REFERER");
			
			logger.debug("referer=" + referer);
			
			// CSRF related security code
			// only allows requests from the same host name or domain name
			// in order to prevent the request forgery from a different site.
			// referer is null when a user directly enters the url in the browser location bar, in which case
			// the access is allowed.
			if (referer != null && !referer.isEmpty()) {
				String hostName = request.getHeader("HOST");
				
				logger.debug("hostName=" + hostName);
				
				String hostDomainName = getDomainName(hostName);
				
				//logger.debug("hostDomainName=" + hostDomainName); // 로그정리 : hostName 으로 확인 가능
								
				String refererDomainName = getDomainName(referer);
				
				logger.debug("refererDomainName=" + refererDomainName); // 로그정리 : referer 로 확인 가능
				
				// 도로명주소 open api 예외 처리
				if (!"juso.go.kr".equalsIgnoreCase(refererDomainName)
						&& !"microsoftonline.com".equalsIgnoreCase(refererDomainName)
						&& !"google.com".equalsIgnoreCase(refererDomainName)
						&& !refererDomainName.equalsIgnoreCase(hostDomainName)) {
//					logger.debug("hostDomainName and refererDomainName are different.");
					
//					return false;
				}				
			}
			
			return true;
		} else if ("1".equals(loginCookieExists)) {
			try {
				response.sendRedirect("/user/login/login.do?loginSessionFlag=1");
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			} finally {
				return false;
			}
		} else if ("3".equals(loginCookieExists)) {
			try {
				response.sendRedirect("/user/login/login.do?organInfoChangedFlag=1");
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			} finally {
				return false;
			}
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
				logger.error(e.getMessage(), e);
				
				return false;
			}

			// 2025-08-11 비회원 권한 사용 + 비회원 허용 게시판 > 로그인 쿠키를 생성하지 않고 통과
			try {
				String guestPermitYN = ezCommonService.getTenantConfig("useBoardGuestPermit", tenantId);
				if ("YES".equals(guestPermitYN)) {
					String reqURI = request.getRequestURI();
					
					if (guestAccessibleUris.contains(reqURI)) { // 비회원 허용 URI 해당하는 경우에만 체크
						// 다운로드 관련의 경우 경로에서 boardID를 추출하여 사용
						if ("/ezBoard/boardAttachDown.do".equals(reqURI) || "/ezBoard/downloadAttachAll.do".equals(reqURI)) {
							String[] tmp = request.getParameter("filePath").split("/");
							String boardID = tmp[5];
							
							if (!"".equals(boardID) && ezBoardService.checkGuestPerm(boardID, tenantId, "B")) {
								return true;
							}
						} else if (reqURI.contains("List.do") || reqURI.contains("list.do")) {
							String boardID = request.getParameter("boardID") == null ? (request.getParameter("boardId") == null ? "" : request.getParameter("boardId")) : request.getParameter("boardID");

							if (!"".equals(boardID) && ezBoardService.checkGuestPerm(boardID, tenantId, "B")) {
								return true;
							}
						} else {
							String itemID = request.getParameter("itemID") == null ? "" : request.getParameter("itemID");
							
							if (!"".equals(itemID) && ezBoardService.checkGuestPerm(itemID, tenantId, "I")) {
								return true;
							}
						}
					}
				}
			} catch (Exception e) {
				throw new RuntimeException("Error during guest permission validation : " + e.getMessage(), e);
			}
			
	        if (ezOffice365Auth.equals("YES")) {
	        	performEzOffice365Auth(request, response, tenantId);
	        	
	        	return false;
	        } else {
	        	logger.debug("No login cookie exists. Redirecting to login page...");
	        		        	
				try {
		        	String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", tenantId);
		        	
		        	String mobileRedirection = ezCommonService.getTenantConfig("mobileRedirection", tenantId);
		        	String userOs = ClientUtil.getClientInfo(request, "os");
		        	
		        	if (userOs.equals("iOS") || userOs.equals("Android") || userOs.equals("BlackBerry") || userOs.equals("iPod")) {
		        		if (!mobileRedirection.equals("") && !mobileRedirection.equals("*")) {
		        			response.sendRedirect(mobileRedirection);
		        		}
		        	}
		        	
		        	if (!dotNetIntegration.equals("YES")) {
		        		response.sendRedirect("/user/login/login.do");
		        	}
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
				
				return false;
	        }
		}
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		CommonUtil.addXUACompatibleHeaderToResponse(request, response);
		
		response.setHeader("Cache-Control", "no-store");
		response.setHeader("Pragma", "no-cache");
	}
	
	/**
	 * performs an Office365(Azure AD) authentication
	 * @param request
	 * @param response
	 * @param tenantId
	 * @return
	 */
	private void performEzOffice365Auth(HttpServletRequest request, HttpServletResponse response, int tenantId) {
		String ezOffice365ClientId = "";
		String ezOffice365ClientSecret = "";
    	
    	try {
        	ezOffice365ClientId = ezCommonService.getTenantConfig("ezOffice365ClientId", tenantId);
        	ezOffice365ClientSecret = ezCommonService.getTenantConfig("ezOffice365ClientSecret", tenantId);
    	} catch (Exception e) {
    		logger.error(e.getMessage(), e);
    		
    		return;
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
		
		// in case the browser is returned back from the Azure AD login page with authentication data
		if (containsAuthenticationData(request)) {
	        Map<String, List<String>> params = new HashMap<>();

			// extracts the authentication data	        
	        for (String key : request.getParameterMap().keySet()) {
	            params.put(key, Collections.singletonList(request.getParameterMap().get(key)[0]));
	        }
			
			try {
				AuthenticationResponse authResponse = AuthenticationResponseParser.parse(new URI(fullUrl), params);
				
				if (authResponse instanceof AuthenticationSuccessResponse) {
					AuthenticationSuccessResponse oidcResponse = (AuthenticationSuccessResponse)authResponse;
					
		            IAuthenticationResult result = getAuthResultByAuthCode(
		            		"common",
		            		request,
		                    oidcResponse.getAuthorizationCode(),
		                    currentUri,
		                    ezOffice365ClientId,
		                    ezOffice365ClientSecret);
										
					String userId = result.account().username();
					
					logger.debug("userId=" + userId);
					
					if (userId != null && !userId.isEmpty()) {	
						int atSignPos = userId.indexOf("@");
						String domainName = "";
						
						if (atSignPos != -1) {
							domainName = userId.substring(atSignPos + 1);									
							userId = userId.substring(0, atSignPos);
							
							logger.debug("split userId=" + userId + ",domainName=" + domainName);
														
							LoginVO loginVO = new LoginVO();	
							
							loginVO.setId(userId);
							loginVO.setTenantId(tenantId);
							loginVO.setDn("NOPASSWORD");		
							
							LoginVO	resultVO = loginService.selectUser(loginVO);			
							
							if (resultVO.getId() != null) {							
		    					String ip = ClientUtil.getClientIP(request);		
		    					loginVO.setIp(ip);
		    					
		    					//IP Address,  마지막 login시간 저장
		    					loginService.updateUser(loginVO);
		    					
		    					// 2021-12-28 이사라 : 세션ID를 세션코드로 입력 
		    		        	String sessionId =  request.getSession().getId();
		    		        	String sessionCode = sessionId;
		    		        	logger.debug("Login sessionCode = " + sessionCode);
		    		        	
		    					//접속 로그정보 저장
		    					resultVO.setIp(ip);
		    					resultVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
		    					resultVO.setOs(ClientUtil.getClientInfo(request, "os"));
		    					resultVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));
		    					resultVO.setTenantId(tenantId);
		    					resultVO.setStatus("Y");
		    					resultVO.setSessionCode(sessionCode);
		    	
		    					if (resultVO.getTitle2() == null) {
		    						resultVO.setTitle2("");
		    					}
		    					
		    					loginService.insertLog(resultVO);	    					
								loginController.createLoginCookie(userId, " ", " ", tenantId, request, response, resultVO.getDeptID(), resultVO.getCompanyID());
								
								// CWE-113 보안 취약점 대응
								/* 더 이상 사용되지 않는 코드로 보여 보안 취약점 조치를 위해 제거함
		    		        	Cookie cookieName = new Cookie("userName", URLEncoder.encode(resultVO.getDisplayName1().replaceAll("\r", "").replaceAll("\n", ""), "utf-8"));
		    		        	cookieName.setPath("/");
		    		        	response.addCookie(cookieName);
								*/
								
								response.sendRedirect(request.getRequestURI());	
							} else {
								logger.debug("resultVO.getId is null");
							}
						}						
					}														
				} else {
					AuthenticationErrorResponse oidcResponse = (AuthenticationErrorResponse) authResponse;
					
					logger.debug(String.format("Request for auth code failed: %s - %s",
							oidcResponse.getErrorObject().getCode(),
							oidcResponse.getErrorObject().getDescription()));
				}
			} catch (Throwable e) {
				logger.error(e.getMessage(), e);												
			}
			
			return;
		} else {
        	logger.debug("No authentication data exists. Redirecting to Azure login page...");
        	
			try {					
				String redirectUri = request.getScheme()
						+ "://"
						+ request.getServerName()
						+ ("http".equals(request.getScheme())
								&& request.getServerPort() == 80
								|| "https".equals(request.getScheme())
								&& request.getServerPort() == 443 ? "" : ":"
								+ request.getServerPort())
						+ "/ezNewPortal/newPortalMain.do";
				
				response.sendRedirect(getRedirectUrl("common", ezOffice365ClientId, redirectUri));
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			}
			
			return;					
		}		
	}
	
	private String getRedirectUrl(String tenantName, String clientId, String currentUri) {
        String redirectUrl = "";
        		
        try {
            // state parameter to validate response from Authorization server and nonce parameter to validate idToken
            String state = UUID.randomUUID().toString();
            String nonce = UUID.randomUUID().toString();

            String urlEncodedScopes = URLEncoder.encode("openid offline_access profile", "UTF-8");
            
            redirectUrl = authority + "/" + tenantName + "/oauth2/v2.0/authorize?" +
                    "response_type=code&" +
                    "response_mode=form_post&" +
                    "redirect_uri=" +  URLEncoder.encode(currentUri, "UTF-8") +
                    "&client_id=" + clientId +
                    "&scope=" + urlEncodedScopes +
                    "&prompt=select_account" +
                    "&state=" + state
                    + "&nonce=" + nonce;            
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		}
        
        return redirectUrl;
	}
	   
    private boolean containsAuthenticationData(HttpServletRequest httpRequest) {
        Map<String, String[]> httpParameters = httpRequest.getParameterMap();

        boolean isPostRequest = httpRequest.getMethod().equalsIgnoreCase("POST");
        boolean containsErrorData = httpParameters.containsKey("error");
        boolean containIdToken = httpParameters.containsKey("id_token");
        boolean containsCode = httpParameters.containsKey("code");

        return isPostRequest && containsErrorData || containsCode || containIdToken;
    }
    
    private IAuthenticationResult getAuthResultByAuthCode(
    		String tenantName,
            HttpServletRequest httpServletRequest,
            AuthorizationCode authorizationCode,
            String currentUri,
            String clientId,
            String clientSecret) throws Throwable {

        IAuthenticationResult result;
        ConfidentialClientApplication app;
        try {
            app = createClientApplication(tenantName, clientId, clientSecret);

            String authCode = authorizationCode.getValue();
            AuthorizationCodeParameters parameters = AuthorizationCodeParameters.builder(
                    authCode,
                    new URI(currentUri)).
                    build();

            Future<IAuthenticationResult> future = app.acquireToken(parameters);

            result = future.get();
        } catch (ExecutionException e) {
            throw e.getCause();
        }

        if (result == null) {
            throw new ServiceUnavailableException("authentication result was null");
        }

        return result;
    }    
    
    private ConfidentialClientApplication createClientApplication(
    		String tenantName, String clientId, String clientSecret) throws MalformedURLException {
        return ConfidentialClientApplication.builder(clientId, ClientCredentialFactory.createFromSecret(clientSecret)).
                authority(authority + "/" + tenantName + "/").
                build();
    }
    
    /**
     * tries to get the domain name if possible from the passed in parameter.
     * may just return the host name.
     * @param url
     * @return
     */
	public String getDomainName(String url) {
		try {
			if (!url.contains("http://") && !url.contains("https://")) {
				// get the host name only by removing the port number if it exists
				if (url.indexOf(":") > -1) {
					url = url.substring(0, url.indexOf(":"));
				}
			} else {
				URL hostNameURL = new URL(url);
				// get the host name from the url
				url = hostNameURL.getHost();
			}

			String topLevelDomain = url.substring(url.lastIndexOf(".") + 1);
			String[] urlSplit = url.split("\\.");
			
			// if the number of name components is one or two(such as vertx.io, google.com) 
			// just return the name itself
			// else try to extract the domain part of the name
			if (urlSplit.length > 2) {
				String secondLevelDomain = urlSplit[urlSplit.length - 2];
				
				// such as www.name.co.kr, www.vertx.io
				if (topLevelDomain.length() == 2) {
					// such as www.vertx.io
					if (secondLevelDomain.length() > 2) {
						url = secondLevelDomain + "." + topLevelDomain;
					// such as www.name.co.kr
					} else {
						url = urlSplit[urlSplit.length - 3] + "." + secondLevelDomain + "."
								+ topLevelDomain;
					}
				// such as www.google.com, www.apache.org
				} else if (topLevelDomain.length() == 3) {
					url = secondLevelDomain + "." + topLevelDomain;
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
    	
    	return url;
    }
}
