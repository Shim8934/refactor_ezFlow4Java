package egovframework.let.user.login.web;

import java.security.PrivateKey;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base32;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import de.taimos.totp.TOTP;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.service.EzCommonService.Device;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.AccessIdVO;
import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.Offset;
import egovframework.let.utl.sim.service.EgovFileScrty;
/** 
 * @Description [Controller] 모바일 - 로그인
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 * @
 * @  수정일         		수정자                   수정내용
 * @ -------    	--------    ---------------------------
 * @ 2017.08.02    	장진혁       		 최초 생성
 * @see
 */
@RestController
public class MLoginGWController {

	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
	
    /** LoginService */
	@Resource(name = "loginService")
    private LoginService loginService;
    
    @Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
    
    @Resource(name="EzSystemAdminService")
	private EzSystemAdminService EzSystemAdminService;
        
    /** CRYPTO */
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
    
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
    
	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;  
    
    @Resource(name="EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;
	
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(MLoginGWController.class);
    
    @Autowired
    private EzEmailUtil ezEmailUtil;
    
    @Autowired
	private EzOrganAdminService ezOrganAdminService;
    
    /**
	 * 모바일 G/W 사용자 [GET] 로그인
	 */
    @SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezUser/login/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")    
    public JSONObject login(@PathVariable String userId, HttpServletRequest request, Locale locale) throws Exception {
    	logger.debug("=========================================== G/W login ============================================");
    	
    	JSONObject result = new JSONObject();

    	try {
			// SSO 솔루션없이 기간계와의 모바일 자동 로그인 처리를 위한 SLO(Single Log On) 처리 여부를 나타냄.			
			String SLOParam = request.getParameter("SLO");
			boolean isSLOSupport = "yes".equalsIgnoreCase(SLOParam);
			String uid = "";
			String rpwd = "";
			PrivateKey pk = EgovFileScrty.getPrivateKey(egovFileScrty.getPrm(), egovFileScrty.getPre());			
    	
			if (!isSLOSupport) {				
				uid = EgovFileScrty.decryptRsa(pk, userId);
				
				if (uid == null || uid.equals("")) {
					logger.debug("invalid uid=" + uid);
					
					result.put("status", "error");
					result.put("code", "2");			
					result.put("data", "invalid uid");
					
					return result;
				}
				
				rpwd = EgovFileScrty.decryptRsa(pk, request.getParameter("pw"));
			} else {
				// SLO의 경우엔 암호화하지 않은 아이디가 ezMobile로부터 전달됨.
				// 기간계에서 암호화해서 전달한 아이디를 ezMobile이 복호화한 후 Mobile GW 서버로 전송하는 것임.
				uid = userId;
			}

			logger.debug("isSLOSupport={},uid={}", isSLOSupport, uid);

    		String pwd = "";
    		
    		String serverName = request.getHeader("x-user-host");
    		int tenantId = loginService.getTenantId(serverName);
    		
    		LoginVO loginVO = new LoginVO();
    		
    		loginVO.setId(uid);
    		loginVO.setDn("NOPASSWORD");
    		loginVO.setTenantId(tenantId);
    		
    		LoginVO resultVO = loginService.selectUser(loginVO);
    		String companyId = resultVO.getCompanyID();
    		
    		/* 2019-05-08 홍승비 - LoginCookieSSO를 사용하는지 값을 확인 */
    		String useSSOCookie = ezCommonService.getTenantConfig("useLoginCookieSSO", tenantId);	    	
    		result.put("useLoginCookieSSO", useSSOCookie);
    		
    		int numberOfLoginFailPermit = 0;
    		// 로그인 실패 최대 허용 횟수를 구한다.
    		String maxAllowedCountOfLoginFail = ezCommonService.getCompanyConfig(tenantId, companyId, "MaxAllowedCountOfLoginFail");
    		logger.debug("companyId=" + companyId + ", maxAllowedCountOfLoginFail=" + maxAllowedCountOfLoginFail);
			// String maxAllowedCountOfLoginFail = ezCommonService.getTenantConfig("MaxAllowedCountOfLoginFail", tenantId);
					
			if (!maxAllowedCountOfLoginFail.equals("")) {
				try {
					numberOfLoginFailPermit = Integer.parseInt(maxAllowedCountOfLoginFail);
				} catch (NumberFormatException e) {
					logger.error(e.getMessage(), e);
				}
			}
			
    		if (resultVO == null || resultVO.getId() == null || resultVO.getId().equals("")) {
    			logger.debug("user does not exist :" + uid);
            	
    			result.put("status", "error");
    			result.put("code", "3");			
    			result.put("data", "user does not exist");
    			
    			return result;
    		} else {
				String ip = request.getHeader("ip") == null ? ClientUtil.getClientIP(request) : request.getHeader("ip");
				String agent = request.getHeader("agent") == null ? ClientUtil.getClientInfo(request, "agent") : request.getHeader("agent");
				String os = request.getHeader("os") == null ? ClientUtil.getClientInfo(request, "os") : request.getHeader("os");
				String browser = request.getHeader("browser") == null ? ClientUtil.getClientInfo(request, "browser") : request.getHeader("browser");
				
				resultVO.setIp(ip);

				logger.debug("request.getHeader: {}, ClientUtil.getClientIP: {}, finally ip: {}",
						request.getHeader("ip"), ClientUtil.getClientIP(request), ip);
        		
    			// 로그인 후 IP 주소 체크
				boolean ipAddressChk = ipAccessCheck(resultVO);
				logger.debug("ipAddressChk=" + ipAddressChk);
				
				if (!ipAddressChk) {
					result.put("status", "error");
	    			result.put("code", "7");			
	    			result.put("data", "IPAddress Not Allowed");
	    			
	    			// 2021-12-29 이사라 : ip 주소 check 실패인 경우 접속실패 로그 저장
					resultVO.setAgent(agent);
					resultVO.setOs(os);
					resultVO.setBrowser(browser);
					resultVO.setTenantId(tenantId);
					resultVO.setStatus("N");

					if (resultVO.getTitle2() == null) {
						resultVO.setTitle2("");
					}
					
					loginService.insertLog(resultVO);
					
	    			return result;
				}
    			
    			// 모바일 사용 설정 확인 
    			String useMobileManagemant = ezCommonService.getTenantConfig("useMobileManagemant", tenantId);
    			boolean pinLoginAuth = false;
    			
    			if (useMobileManagemant.equals("YES")) {
    				String notUseAllMobileLogin = ezCommonService.getUserConfigInfo(tenantId, uid, "notUseMobileLogin");
    				String adminOrderNotUsedMobileLogin = ezCommonService.getUserConfigInfo(tenantId, uid, "adminOrderNotUsedMobileLogin");
    				
    				notUseAllMobileLogin = notUseAllMobileLogin.equals("") ? "0" : notUseAllMobileLogin;
    				adminOrderNotUsedMobileLogin = adminOrderNotUsedMobileLogin.equals("") ? "0" : adminOrderNotUsedMobileLogin;
    				
    				if (adminOrderNotUsedMobileLogin.equals("1") || notUseAllMobileLogin.equals("1")) {
    					logger.debug("cannot use mobile login. userId=" + uid);
    					
    					result.put("status", "error");
    					result.put("code", "6");
    					result.put("data", "cannot use mobile login.");
    					
    					// 2021-12-29 이사라 : 접속 실패 로그 저장 - 모바일 사용금지 설정 
    					resultVO.setIp(ip);
    					resultVO.setAgent(agent);
    					resultVO.setOs(os);
    					resultVO.setBrowser(browser);
    					resultVO.setTenantId(tenantId);
    					resultVO.setStatus("N");

    					if (resultVO.getTitle2() == null) {
    						resultVO.setTitle2("");
    					}
    					
    					loginService.insertLog(resultVO);
    					
    					return result;
    				} else {
    					String deviceId = request.getParameter("deviceID") == null ? "" : request.getParameter("deviceID");
    					
    					if (!deviceId.equals("")) {
    						String inputParams = "userId=" + uid + "&deviceId=" + deviceId;
    						logger.debug("userId=" + uid + ",deviceId=" + deviceId);
    						
    						String requestURL = "/ezTalkGate/getUserMobileDeviceUsedInfo";
    						String getResult = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + requestURL, inputParams);
    						logger.debug("getResult=" + getResult);
    						
    						JSONParser parser = new JSONParser();
    						JSONObject resultObj = (JSONObject) parser.parse(getResult);

    						if (Integer.valueOf(String.valueOf(resultObj.get("data"))) > 0) {
    							logger.debug("this device cannot use. userId=" + uid);
    							
    							result.put("status", "error");
    							result.put("code", "6");			
    							result.put("data", "this device cannot use.");
    							
    							// 2021-12-29 이사라 : 접속 실패 로그 저장 - 접속한 디바이스 사용금지
    	    					resultVO.setIp(ip);
    	    					resultVO.setAgent(agent);
    	    					resultVO.setOs(os);
    	    					resultVO.setBrowser(browser);
    	    					resultVO.setTenantId(tenantId);
    	    					resultVO.setStatus("N");

    	    					if (resultVO.getTitle2() == null) {
    	    						resultVO.setTitle2("");
    	    					}
    	    					
    	    					loginService.insertLog(resultVO);
    	    					
    							return result;
    						} else { 
    							// 0이지만 그전 사용자의 config 확인
    							String oldUserId = String.valueOf(resultObj.get("oldUserId"));
    							notUseAllMobileLogin = ezCommonService.getUserConfigInfo(tenantId, oldUserId, "notUseMobileLogin");
    							adminOrderNotUsedMobileLogin = ezCommonService.getUserConfigInfo(tenantId, oldUserId, "adminOrderNotUsedMobileLogin");
    		    				
    		    				notUseAllMobileLogin = notUseAllMobileLogin.equals("") ? "0" : notUseAllMobileLogin;
    		    				adminOrderNotUsedMobileLogin = adminOrderNotUsedMobileLogin.equals("") ? "0" : adminOrderNotUsedMobileLogin;
    						
    		    				if (adminOrderNotUsedMobileLogin.equals("1") || notUseAllMobileLogin.equals("1")) {
    		    					logger.debug("cannot use mobile login. oldUserId=" + oldUserId);
    		    					
    		    					result.put("status", "error");
    		    					result.put("code", "6");
    		    					result.put("data", "cannot use mobile login.");
    		    					
    		    					// 2021-12-29 이사라 : 접속 실패 로그 저장 - 모바일 사용설정 금지 oldUserId
    		    					resultVO.setIp(ip);
    		    					resultVO.setAgent(agent);
    		    					resultVO.setOs(os);
    		    					resultVO.setBrowser(browser);
    		    					resultVO.setTenantId(tenantId);
    		    					resultVO.setStatus("N");

    		    					if (resultVO.getTitle2() == null) {
    		    						resultVO.setTitle2("");
    		    					}
    		    					
    		    					loginService.insertLog(resultVO);
    		    					
    		    					return result;
    		    				}
    		    				
    		    				// 20210426 조진호 - pin login 처리 부분. 사용자가 입력한 pin과 DB에 저장된 pin 값이 일치하면
								// pinLoginAuth를 true로 전환
								String encryptPin = request.getParameter("encryptPin") == null ? "" : request.getParameter("encryptPin");
								if (!"".equals(encryptPin)) {
									String userInputPin = EgovFileScrty.decryptRsa(pk, encryptPin);

									// 20210715 조진호 = input Pin이 OK 인 것은 생체인식에 성공한 것으로 처리
									if (userInputPin.equalsIgnoreCase("OK")) {
										userInputPin = String.valueOf(resultObj.get("pin"));
									} else {
										userInputPin = EgovFileScrty.encryptPassword(userInputPin, uid);
									}

									String authPin = String.valueOf(resultObj.get("pin"));

									if (!userInputPin.equals("") && !authPin.equals("") && authPin.equals(userInputPin)) {
										pinLoginAuth = true;
										logger.debug("pin Login Auth Successed.");
									}
									else {
										logger.debug("pin Login Auth Failed.");
									}
								}
    						}
    					}
    				}
    			}
    			else {
    				String deviceId = request.getParameter("deviceID") == null ? "" : request.getParameter("deviceID");
					
					if (!deviceId.equals("")) {
						String inputParams = "userId=" + uid + "&deviceId=" + deviceId;
						logger.debug("userId=" + uid + ",deviceId=" + deviceId);
						
						String requestURL = "/ezTalkGate/getUserMobileDeviceUsedInfo";
						String getResult = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + requestURL, inputParams);
						logger.debug("getResult=" + getResult);
						
						JSONParser parser = new JSONParser();
						JSONObject resultObj = (JSONObject) parser.parse(getResult);

						// 20210426 조진호 - pin login 처리 부분. 사용자가 입력한 pin과 DB에 저장된 pin 값이 일치하면
						// pinLoginAuth를 true로 전환
						String encryptPin = request.getParameter("encryptPin") == null ? "" : request.getParameter("encryptPin");
						if (!"".equals(encryptPin)) {
							String userInputPin = EgovFileScrty.decryptRsa(pk, encryptPin);

							// 20210715 조진호 = input Pin이 OK 인 것은 생체인식에 성공한 것으로 처리
							if (userInputPin.equalsIgnoreCase("OK")) {
								userInputPin = String.valueOf(resultObj.get("pin"));
							} else {
								userInputPin = EgovFileScrty.encryptPassword(userInputPin, uid);
							}

							String pinState = String.valueOf(resultObj.get("pinState"));
							String authPin = String.valueOf(resultObj.get("pin"));
							
							if (pinState.equalsIgnoreCase("Y")) {
								if (!userInputPin.equals("") && !authPin.equals("") && authPin.equals(userInputPin)) {
									pinLoginAuth = true;
									logger.debug("pin Login Auth Successed.");
								}
								else {
									logger.debug("pin Login Auth Failed.");
								}
							}
							else {
								logger.debug("pin Login not useded.");
							}
						}
					}
    			}
    			
    			
    			// 사용자 ID를 사용해 로그인하는 경우
    			if (uid.equals(resultVO.getId())) {
    				loginVO.setId(uid);
    				if (pinLoginAuth || isSLOSupport) { // pinLogin 인증 통과 혹은 기간계와의 SLO 연동의 경우
    					loginVO.setDn("NOPASSWORD");
    				}
    				else {
    					pwd = EgovFileScrty.encryptPassword(rpwd, uid);
    		        	loginVO.setPassword(pwd);
    		            loginVO.setDn("PASSWORD");
    				}

		            String chkADpass = "";
		            // AD를 사용하는 경우 AD의 암호화 비교한 값을 구한다.
		            if (ezCommonService.getTenantConfig("USE_AD", tenantId).equalsIgnoreCase("YES")) {
		            	// true 이면 그룹웨어 암호 변경
		            	// false 이면 그냥 로그인 금지
		            	chkADpass = loginService.chkADAndUpdatePassword(uid, rpwd, tenantId);	            	
		            	
		            	if (chkADpass.equalsIgnoreCase("false")) {
		            		// vo의 password에 null 값을 넣어서 selectUser에서 무조건 암호가 틀리게 한다.
		            		loginVO.setPassword(null);	            		
		            	}
		            }
		            // 암호가 맞는 지 확인한다.
		            resultVO = loginService.selectUser(loginVO);
    			// 사원번호를 사용해 로그인하는 경우
				} else {
					//Check if his/her tenant allows using employeeID to login				
					String useEmpNumberLogin = ezCommonService.getTenantConfig("UseEmpNumberLogin", tenantId);
					
					// 사원번호를 사용한 로그인을 허용하는 경우
					if (useEmpNumberLogin.equals("YES") && !resultVO.getId().equals("")) {
						// 실제 사용자 ID를 사용해 암호가 맞는 지 확인한다.
						uid = resultVO.getId();
						pwd = EgovFileScrty.encryptPassword(rpwd, uid);
			        	loginVO.setId(uid);
			        	loginVO.setPassword(pwd);
			            loginVO.setDn("PASSWORD");
			            
			            resultVO = loginService.selectUser(loginVO);
			         // 사원번호를 사용한 로그인을 허용하지 않는 경우
					} else {
						//This kind of login is not allowed in his/her tenant
						logger.debug("user does not exist :" + uid);
		            	
		    			result.put("status", "error");
		    			result.put("code", "3");			
		    			result.put("data", "user does not exist");
		    			
		    			return result;
					}
				}
    			if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
    				// 공유사서함 기능을 사용할 경우 공유사서함 계정으로의 로그인을 막는다.
    	    		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
    	    		
    	    		if (useSharedMailbox.equals("YES")) {
    	    			if (resultVO.getDeptID() != null && resultVO.getDeptID().startsWith("shared_mailbox_")) {
    	    				logger.debug("Cannot login with shared mailbox account.");
    	    				
    	    				result.put("status", "error");
    		    			result.put("code", "3");			
    		    			result.put("data", "user does not exist");
    		    			
    	        	        return result;
    	    			}
    	    		}
    	    		
    	    		// 사용자정지 여부를 체크
    	        	String useLoginStop = ezCommonService.getTenantConfig("useLoginStop", tenantId);
    	        	
    	        	if (useLoginStop != null && useLoginStop.equals("YES")) {
    	        		int flag = checkStopUser(tenantId, resultVO.getId());
    	        		if(flag > 0) {
    	        			logger.debug("stopUser");
    	        			result.put("status", "error");
        					result.put("code", "8");			
        					result.put("data", "stopUser");
        					
        					// 2021-12-28 이사라 : 접속로그 실패 저장
    						resultVO.setIp(ip);
    						resultVO.setAgent(agent);
    						resultVO.setOs(os);
    						resultVO.setBrowser(browser);
    						resultVO.setTenantId(tenantId);
    						resultVO.setStatus("N");
    		
    						if (resultVO.getTitle2() == null) {
    							resultVO.setTitle2("");
    						}
    						
    						loginService.insertLog(resultVO);
    						
        					return result;
    	        		}
    	        	}
    				
    				int check = checkState(tenantId, uid, numberOfLoginFailPermit);
                	
                	// 해당 사용자의 로그인이 블록되지 않은 경우
                	if (check != -3) {
                		//비밀번호 변경 팝업 상태 값 초기화
        				int diff = 1;
        				
        				if (resultVO.getLoginCnt() == 0 && !isSLOSupport) { // SLO의 경우에는 First Login도 성공으로 처리한다.
        					logger.debug("isFirstLogin");
        					
        					// 2021-12-28 이사라 : 접속로그 실패 저장
    						resultVO.setIp(ip);
    						resultVO.setAgent(agent);
    						resultVO.setOs(os);
    						resultVO.setBrowser(browser);
    						resultVO.setTenantId(tenantId);
    						resultVO.setStatus("N");
    		
    						if (resultVO.getTitle2() == null) {
    							resultVO.setTitle2("");
    						}
    						
    						loginService.insertLog(resultVO);
        					
        					result.put("status", "error");
        					result.put("code", "4");			
        					result.put("data", "isFirstLogin");
        					
        					return result;
        				} else {
        	        		String expirePassPeriod = ezCommonService.getCompanyConfig(tenantId, companyId, "ExpirePassPeriod");
        					//String expirePassPeriod = ezCommonService.getTenantConfig("ExpirePassPeriod", tenantId);        	
        					
        					if (!expirePassPeriod.trim().equals("0")) {
        						int realPeriod = Integer.parseInt("-" + expirePassPeriod.trim());
        						
        						Calendar cal = Calendar.getInstance();
        						SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        						
        						String baseStr = commonUtil.getTodayUTCTime("");        	
        						Date baseDT = date.parse(baseStr);
        						
        						cal.setTime(baseDT);
        						cal.add(Calendar.DATE, realPeriod);
        						
        						baseDT = cal.getTime();
        						Date passwordUpdateDT = resultVO.getPassword_updatedt();
        						
    							if (passwordUpdateDT == null) {
    								passwordUpdateDT = resultVO.getUpdateDT();
    							}
    		            	
    							logger.debug("passwordUpdateDT=" + passwordUpdateDT);
    							logger.debug("baseDT=" + baseDT);
        						
        						//오늘 기준 6개월전 날짜, 마지막 개인정보 수정일자 간 뺄셈
        						diff = EgovDateUtil.getDaysDiff(baseDT, passwordUpdateDT);	    			
    							logger.debug("diff=" + diff);
        					}	        	
        				}        	        	
        				//0보다 작아지면 패스워드 변경기한 Expired
        				if (diff <= 0) {
        					logger.debug("isExpireDate");
        					
        					// 2021-12-28 이사라 : 접속로그 실패 저장
    						resultVO.setIp(ip);
    						resultVO.setAgent(agent);
    						resultVO.setOs(os);
    						resultVO.setBrowser(browser);
    						resultVO.setTenantId(tenantId);
    						resultVO.setStatus("N");
    		
    						if (resultVO.getTitle2() == null) {
    							resultVO.setTitle2("");
    						}
    						
    						loginService.insertLog(resultVO);
        					
        					result.put("status", "error");
        					result.put("code", "5");			
        					result.put("data", "isExpireDate");
        					
        					return result;    	        	
        				} else {
        				/*// 2023-03-31 이사라 : [TFA] 로그인 성공 처리는 loginTFA.do에서 진행
        			    	String mIp = request.getHeader("ip");
        			    	String mAgent = request.getHeader("agent");
        			    	String mBrowser = request.getHeader("browser");
        			    	String mOs = request.getHeader("os");
        			    	
        			    	if (mIp == null) {
        			    		mIp = ClientUtil.getClientIP(request);
        			    	}
        			    	
        			    	if (mAgent == null) {
        			    		mAgent = ClientUtil.getClientInfo(request, "agent");
        			    	}
        			    	
        			    	if (mBrowser == null) {
        			    		mBrowser = ClientUtil.getClientInfo(request, "browser");
        			    	}
        			    	
        			    	if (mOs == null) {
        			    		mOs = ClientUtil.getClientInfo(request, "os");
        			    	}
        			    	
        					loginVO.setIp(mIp);
        					
        					//IP Address,  마지막 login시간 저장
        					loginService.updateUser(loginVO);
        					
        					// 2021-12-28 이사라 : 세션ID를 세션코드로 입력 
        					String sessionCode = request.getHeader("mSessionId") == null ? ClientUtil.getClientIP(request) : request.getHeader("mSessionId");
        		        	logger.debug("Login sessionCode = " + sessionCode);
        		        	
        					//접속 로그정보 저장
        					resultVO.setIp(mIp);
        					resultVO.setAgent(mAgent);
        					resultVO.setOs(mOs);
        					resultVO.setBrowser(mBrowser);
        					resultVO.setTenantId(tenantId);
        					resultVO.setStatus("Y");
        					resultVO.setSessionCode(sessionCode);
        					
        					if(resultVO.getTitle2() == null){
        						resultVO.setTitle2("");
        					}
        					
        					loginService.insertLog(resultVO);
        					
        					//DB에서 모바일 환경설정 값 가져옴
        					MOptionVO mOptionVO = mOptionService.optionInfo(uid, tenantId);
        					
        					String acceptLanguage = request.getHeader("Accept-Language");    				
        					String lang = "";
        					String timeZone = "";
        					String maintype = "";
        					String listCnt = "";    				
        					String useSecurity = "";					
        					String returnValue = "";
        					
        					String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
        					
        					//userMobileInfo 테이블에 정보가 없을 때 (첫 로그인)
        					if (mOptionVO == null) {    			        
        						
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
        						
        						//브라우저 언어가 한국어/일본어가 아닐 경우 시스템 언어로 설정(영어/중국어 추후 지원)
        						if (lang.equals("")) {						
        							lang = primaryLang;
        						}
        						
        						timeZone = ezCommonService.getTenantConfig("PrimaryTimeZone", tenantId);
        					    
        					    if (timeZone.equals("")) {
        					    	timeZone = "235|+09:00";
        					    }
        					    
        						maintype = "D";
        						listCnt = "10";    				    
        						useSecurity = "N";
        						
        						mOptionService.insertOption(uid, timeZone, lang, maintype, listCnt, useSecurity, tenantId);    					
        					} else {
        						lang = mOptionVO.getLang();
        						timeZone = mOptionVO.getTimeZone();
        						maintype = mOptionVO.getMainType();
        						listCnt = mOptionVO.getListCnt();        				
        						useSecurity = mOptionVO.getUseSecurity();
        						returnValue = commonUtil.getTwoLetterLangFromLangNum(lang);
        					}

							// PC 첫 로그인에서 비밀번호만 변경하고 재로그인을 하지 않았을 때
							// TBL_USERLOCALINFO 테이블에 값이 없어서 모바일 rest 호출시 mOptionService.commonInfoWeb 를 사용하는
							// 모듈들에서 에러가 발생하게 된다. 체크 후 넣어주는 로직!
							if (StringUtils.isEmpty(ezCommonService.selectUserGetLang(uid, tenantId))) {
								//UsePrimaryLangOnly가 YES일 때는 무조건 PrimaryLang 언어로 설정한다.
								if (config.getProperty("config.UsePrimaryLangOnly").equals("YES")) {
									if (primaryLang.equals("1")) {
										acceptLanguage = "ko";
									} else if (primaryLang.equals("3")) {
										acceptLanguage = "ja";
									}
								}

								String pcLang;

								if (acceptLanguage != null) {
									pcLang = acceptLanguage.substring(0, 2);
									//이유는 정확히 알 수 없지만 로그를 확인한 결과 윗 라인에서 acceptLanguage가 null인 경우가 발생하여 추가함.
								} else {
									pcLang = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
								}

								pcLang = commonUtil.getLangNumFromTwoLetterLang(pcLang);

								//브라우저 언어가 한국어/일본어가 아닐 경우 시스템 언어로 설정(영어/중국어 추후 지원)
								if (pcLang.equals("")) {
									pcLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
								}

								String primaryTimeZone = ezCommonService.getTenantConfig("PrimaryTimeZone", tenantId);

								if (primaryTimeZone.equals("")) {
									primaryTimeZone = Offset.KST;
								}

								ezCommonService.insertTblUserLocalInfo(uid, primaryTimeZone, pcLang, tenantId);
							}

        					// 20180711 조진호 - 로그인 성공시 로그인실패 횟수 초기화
        					ezCommonService.updateUserConfigInfo(tenantId, uid, "LoginFailCount", "0");
        					
        					//* 2018-01-08 장진혁 - 모바일에서 메일만 사용할 경우 YES or NO
        					String useMobileMailOnly = ezCommonService.getTenantConfig("useMobileMailOnly", tenantId);
        					//* 2018-11-02 배현상 - 공유결재문서 사용 유무 YES or NO
        					String useShareApproval = ezCommonService.getTenantConfig("useShareApproval", tenantId);
        					//* 2019-08-30 김수아 - 모바일 세션 시간 config - useMobileSession
        					String useSessionMobile = ezCommonService.getTenantConfig("useSessionMobile", tenantId);

							// 모바일 중복로그인 처리
							String useMultiLogin = ezCommonService.getCompanyConfig(tenantId, companyId, "useMultiLogin");
							String multiLoginTime = "";

							if ("NO".equalsIgnoreCase(useMultiLogin)) {
								multiLoginTime = String.valueOf(System.currentTimeMillis());
								commonUtil.setLoginUsers(tenantId, companyId, uid, multiLoginTime, Device.MOBILE);
							}

        					Map<String, Object> map = new HashMap<String, Object>();
        					map.put("uid", uid);
        					map.put("ip", mIp);
        					map.put("locale", returnValue);
        					map.put("lang", lang);
        					map.put("timeZone", timeZone);
        					map.put("tenantId", tenantId+"");
        					map.put("mainType", maintype);
        					map.put("listCnt", listCnt);    				
        					map.put("useSecurity", useSecurity);    		
        					map.put("companyID", resultVO.getCompanyID());
        					map.put("primaryLang", primaryLang);
        					map.put("rollInfo", resultVO.getRollInfo());
        					map.put("useSessionMobile", useSessionMobile);    				
        					map.put("multiLoginTime", multiLoginTime);
        					
        					// LoginCookieSSO는 모바일용 쿠키가 아니라 웹버전 연동 쿠키임
        					Map<String, Object> mapSSO = new HashMap<String, Object>();
        					if (!useSSOCookie.trim().isEmpty() && !"NO".equalsIgnoreCase(useSSOCookie)) {
        						// 20210521 조진호 - loginCookieSSO에서 사용자의 패스워드를 사용 할 이유가 없어 WEB과 동일하게 문자열로 처리
        						//pwd = EgovFileScrty.encryptPassword(rpwd, uid);
        						mapSSO.put("userPw","userPw");
        						mapSSO.put("encryptedUserPw", "encryptedUserPw");
        						mapSSO.put("deptID", resultVO.getDeptID());
        						mapSSO.put("companyID", resultVO.getCompanyID());
        					}
        					
        					if (commonUtil.getPrimaryData(lang, tenantId) == "1") {
        						map.put("userName", resultVO.getDisplayName1());
        					} else {
        						map.put("userName", resultVO.getDisplayName2());
        					}
        					
        					map.put("useMobileMailOnly", useMobileMailOnly);
        					map.put("useShareApproval", useShareApproval);
        					
        					result.put("status", "ok");
        					result.put("code", "0");
        					result.put("data", map);
        					result.put("dataSSO", mapSSO);
        					*/

						boolean useOTP = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useOTP", tenantId)) ? true	: false;
						boolean hasOTP = loginService.searchOtpKey(loginVO);
    						String code = "0";
        					
							if (useOTP && hasOTP) {
								String otpKey = ezCommonService.getUserConfigInfo(tenantId, uid, "otpKey");
								code = "11";

								if (StringUtils.isBlank(otpKey)) {
									logger.debug("has no valid OTP key.");
									hasOTP = false;
									code = "9";
								}

							} else if (useOTP && !hasOTP) {
								logger.debug("hasn't set OTP key.");
								code = "9";
							}

							result.put("status", "ok");
							result.put("code", code);
							result.put("data", "ok");

							logger.debug("==== end, useOTP={}, hasOTP={} ====", useOTP, hasOTP);

        					return result;
        				}
                	} else {
                		// 2021-12-29 이사라 : 접속로그 실패 저장
						resultVO.setIp(ip);
						resultVO.setAgent(agent);
						resultVO.setOs(os);
						resultVO.setBrowser(browser);
						resultVO.setTenantId(tenantId);
						resultVO.setStatus("N");
		
						if (resultVO.getTitle2() == null) {
							resultVO.setTitle2("");
						}
						
						loginService.insertLog(resultVO);
                		result.put("status", "error");
	        			result.put("code", "3");
    					result.put("data", egovMessageSource.getMessageExtend("fail.mobile.common.login.block", new Object[] {numberOfLoginFailPermit}, locale));
    					return result;
                	}
    			} else {
    				// 2021-12-29 이사라 : 접속 실패 로그정보 저장
    				loginVO.setId(uid);
    	    		loginVO.setTenantId(tenantId);
    	        	loginVO.setDn("NOPASSWORD");
    	        	resultVO = loginService.selectUser(loginVO);
    	        	
    				resultVO.setIp(ip);
    				resultVO.setAgent(agent);
    				resultVO.setOs(os);
    				resultVO.setBrowser(browser);
    				resultVO.setStatus("N");

    				if (resultVO.getTitle2() == null) {
    					resultVO.setTitle2("");
    				}
    				
    				loginService.insertLog(resultVO);
    				
    				//Check login state of the user 
    	        	int check = checkState(tenantId, uid, numberOfLoginFailPermit);
    	        	String errorMsg1 = "";
    	        	String errorMsg2 = "";
    	        	String errorMsg3 = "";

    	        	switch (check) {
    					case -3: 
    		    			//Show block message
    						result.put("status", "error");
    	        			result.put("code", "3");
    						result.put("data", egovMessageSource.getMessageExtend("fail.mobile.common.login.block", new Object[] {numberOfLoginFailPermit}, locale));
    						return result;
    	    			case -2:
    		        		//The first time this user login failed
    		        		ezCommonService.insertUserConfigInfo(tenantId,  uid, "LoginFailCount", "1");
    		        		//Show warning message
    		        		/* 2018-05-24 홍승비 - 로그인 실패 시 레이어팝업을 위해 플래그 추가, 메세지 리소스 분리 */
    		        		errorMsg1 = egovMessageSource.getMessage("fail.mobile.common.login.warning1", locale);
    		        		errorMsg1 += egovMessageSource.getMessage("fail.mobile.common.login.warning2", locale);
    		        		errorMsg2 = egovMessageSource.getMessageExtend("fail.mobile.common.login.warning3", new Object[] {1}, locale);
    		        		errorMsg3 = egovMessageSource.getMessage("fail.mobile.common.login.warning4", locale);
    		        		errorMsg3 += "   " + egovMessageSource.getMessageExtend("fail.mobile.common.login.warning5", new Object[] {numberOfLoginFailPermit}, locale);
    		        		result.put("status", "error");
    	        			result.put("code", "3");
    		        		result.put("data", errorMsg1 + errorMsg2 + errorMsg3);
    		        		return result;
    	        		case -1:
    	        			//Show normal login fail message
    	        			result.put("status", "error");
    	        			result.put("code", "3");
    	        			result.put("data", egovMessageSource.getMessage("fail.mobile.common.login", locale));
    	        			return result;
    	        		default:
    	        			//Increase number of attempts in database
    	        			ezCommonService.updateUserConfigInfo(tenantId, uid, "LoginFailCount", Integer.toString(check + 1));
    	        			
    	        			if (check >= numberOfLoginFailPermit - 1) {
    	        				//Show block message
    	        				result.put("status", "error");
    	            			result.put("code", "3");
    	        				result.put("data", egovMessageSource.getMessageExtend("fail.mobile.common.login.block", new Object[] {numberOfLoginFailPermit}, locale));
    	        				return result;
    	        			} else {
    	            			//Show warning message
    	        				errorMsg1 = egovMessageSource.getMessage("fail.mobile.common.login.warning1", locale);
    	    	        		errorMsg1 += egovMessageSource.getMessage("fail.mobile.common.login.warning2", locale);
    	    	        		errorMsg2 = egovMessageSource.getMessageExtend("fail.mobile.common.login.warning3", new Object[] {check + 1}, locale);
    	    	        		errorMsg3 = egovMessageSource.getMessage("fail.mobile.common.login.warning4", locale);
    	    	        		errorMsg3 += "   " + egovMessageSource.getMessageExtend("fail.mobile.common.login.warning5", new Object[] {numberOfLoginFailPermit}, locale);
    	    	        		result.put("status", "error");
    	            			result.put("code", "3");
    	    	        		result.put("data", errorMsg1 + errorMsg2 + errorMsg3);
    	    	        		return result;
    	        			}
    	        	}
    			}
    		}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");			
			result.put("data", "fail");
			
			return result;
		}    	      
    }
    
	// 2023-03-30 이사라 : [TFA] 2중 인증을 추가하면서 로그인 성공 절차를 loginTFA에서 처리하도록 수정
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezUser/loginTFA/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject loginTFA(@PathVariable String userId, HttpServletRequest request, Locale locale)
			throws Exception {
		logger.debug(
				"=========================================== G/W loginTFA ============================================");

		JSONObject result = new JSONObject();

		try {
			String uid = "";
			PrivateKey pk = EgovFileScrty.getPrivateKey(egovFileScrty.getPrm(), egovFileScrty.getPre());

			// SSO 솔루션없이 기간계와의 모바일 자동 로그인 처리를 위한 SLO(Single Log On) 처리 여부를 나타냄.
			String SLOParam = request.getParameter("SLO");
			boolean isSLOSupport = "yes".equalsIgnoreCase(SLOParam);

			if (!isSLOSupport) {
				uid = EgovFileScrty.decryptRsa(pk, userId);

				if (uid == null || uid.equals("")) {
					logger.debug("invalid uid=" + uid);

					result.put("status", "error");
					result.put("code", "2");
					result.put("data", "invalid uid");

					return result;
				}

			} else {
				// SLO의 경우엔 암호화하지 않은 아이디가 ezMobile로부터 전달됨.
				// 기간계에서 암호화해서 전달한 아이디를 ezMobile이 복호화한 후 Mobile GW 서버로 전송하는 것임.
				uid = userId;
			}

			logger.debug("isSLOSupport={}, uid={}", isSLOSupport, uid);

			String serverName = request.getHeader("x-user-host");
			int tenantId = loginService.getTenantId(serverName);

			// 2023-03-31 이사라 : [TFA] 2-factor 인증 사용 체크
			String encLoginOtp = request.getParameter("loginOtp") == null ? "" : request.getParameter("loginOtp");
			String loginOtp = "";
			boolean useOTP = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useOTP", tenantId));
			boolean hasOTP = false;
			boolean isRightOTP = true;

			LoginVO loginVO = new LoginVO();

			loginVO.setId(uid);
			loginVO.setDn("NOPASSWORD");
			loginVO.setTenantId(tenantId);

			LoginVO resultVO = loginService.selectUser(loginVO);
			String companyId = resultVO.getCompanyID();

			/* 2019-05-08 홍승비 - LoginCookieSSO를 사용하는지 값을 확인 */
			String useSSOCookie = ezCommonService.getTenantConfig("useLoginCookieSSO", tenantId);
			result.put("useLoginCookieSSO", useSSOCookie);

			// OTP 체크
			if (useOTP) {
				loginOtp = StringUtils.defaultString(EgovFileScrty.decryptRsa(pk, encLoginOtp));
				logger.debug("OTP use checked. loginOtp={}", loginOtp);
				// OTP를 등록한 사용자인지 체크
				hasOTP = loginService.searchOtpKey(resultVO);
			}

			// OTP Key 유무 확인
			if (hasOTP) {
				String otpKey = ezCommonService.getUserConfigInfo(tenantId, uid, "otpKey");
				String otpCode = "";

				if (StringUtils.isNotBlank(otpKey)) {
					logger.debug("has OTP checked.");
					otpCode = getTOTPCode(otpKey);
					isRightOTP = loginOtp.equals(otpCode) ? true : false;

					logger.debug("OTP correct code={}, submmited code={}, isRightOTP={}", otpCode, loginOtp,
							isRightOTP);
				} else {
					// OTP 키가 null인 경우 예외 처리
					logger.debug("has no valid OTP key.");
					hasOTP = false;
					isRightOTP = false;
				}
			}

			// 로그인 실패 최대 허용 횟수를 구한다.
			int numberOfLoginFailPermit = 0;

			String maxAllowedCountOfLoginFail = ezCommonService.getCompanyConfig(tenantId, companyId,
					"MaxAllowedCountOfLoginFail");
			logger.debug("companyId=" + companyId + ", maxAllowedCountOfLoginFail=" + maxAllowedCountOfLoginFail);

			if (!maxAllowedCountOfLoginFail.equals("")) {
				try {
					numberOfLoginFailPermit = Integer.parseInt(maxAllowedCountOfLoginFail);
				} catch (NumberFormatException e) {
					e.printStackTrace();
				}
			}

			// 로그인 정보 저장을 위한 값 처리
			// 2021-12-28 이사라 : 세션ID를 세션코드로 입력
			String mIp = request.getHeader("ip");
			String mAgent = request.getHeader("agent");
			String mBrowser = request.getHeader("browser");
			String mOs = request.getHeader("os");
			String mSessionCode = request.getHeader("mSessionId");

			if (mIp == null) {
				mIp = ClientUtil.getClientIP(request);
			}

			if (mAgent == null) {
				mAgent = ClientUtil.getClientInfo(request, "agent");
			}

			if (mBrowser == null) {
				mBrowser = ClientUtil.getClientInfo(request, "browser");
			}

			if (mOs == null) {
				mOs = ClientUtil.getClientInfo(request, "os");
			}

			if (mSessionCode == null) {
				mSessionCode = request.getSession().getId();
			}
			
			logger.debug("Login info : mIp={}, mBrowser={}, mOs={}, mSessionCode ={}", mIp, mBrowser, mOs, mSessionCode);

			// 1. OTP 성공 혹은 사용하지 않을 때 로그인 성공
			if (isRightOTP) {
				// IP Address, 마지막 login시간 저장
				resultVO.setIp(mIp);
				loginService.updateUser(resultVO);

				// 접속 로그정보 저장
				resultVO.setIp(mIp);
				resultVO.setAgent(mAgent);
				resultVO.setOs(mOs);
				resultVO.setBrowser(mBrowser);
				resultVO.setTenantId(tenantId);
				resultVO.setStatus("Y");
				resultVO.setSessionCode(mSessionCode);

				if (resultVO.getTitle2() == null) {
					resultVO.setTitle2("");
				}

				loginService.insertLog(resultVO);

				// DB에서 모바일 환경설정 값 가져옴
				MOptionVO mOptionVO = mOptionService.optionInfo(uid, tenantId);

				String acceptLanguage = request.getHeader("Accept-Language");
				String lang = "";
				String timeZone = "";
				String maintype = "";
				String listCnt = "";
				String useSecurity = "";
				String returnValue = "";

				String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

				// userMobileInfo 테이블에 정보가 없을 때 (첫 로그인)
				if (mOptionVO == null) {

					// UsePrimaryLangOnly가 YES일 때는 무조건 PrimaryLang 언어로 설정한다.
					if (config.getProperty("config.UsePrimaryLangOnly").equals("YES")) {
						if (primaryLang.equals("1")) {
							acceptLanguage = "ko";
						} else if (primaryLang.equals("3")) {
							acceptLanguage = "ja";
						}
					}

					if (acceptLanguage != null) {
						returnValue = acceptLanguage.substring(0, 2);
					// 이유는 정확히 알 수 없지만 로그를 확인한 결과 윗 라인에서 acceptLanguage가 null인 경우가 발생하여 추가함.
					} else {
						returnValue = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
					}

					lang = commonUtil.getLangNumFromTwoLetterLang(returnValue);

					// 브라우저 언어가 한국어/일본어가 아닐 경우 시스템 언어로 설정(영어/중국어 추후 지원)
					if (lang.equals("")) {
						lang = primaryLang;
					}

					timeZone = ezCommonService.getTenantConfig("PrimaryTimeZone", tenantId);

					if (timeZone.equals("")) {
						timeZone = "235|+09:00";
					}

					maintype = "D";
					listCnt = "10";
					useSecurity = "N";

					mOptionService.insertOption(uid, timeZone, lang, maintype, listCnt, useSecurity, tenantId);
				} else {
					lang = mOptionVO.getLang();
					timeZone = mOptionVO.getTimeZone();
					maintype = mOptionVO.getMainType();
					listCnt = mOptionVO.getListCnt();
					useSecurity = mOptionVO.getUseSecurity();
					returnValue = commonUtil.getTwoLetterLangFromLangNum(lang);
				}

				// PC 첫 로그인에서 비밀번호만 변경하고 재로그인을 하지 않았을 때
				// TBL_USERLOCALINFO 테이블에 값이 없어서 모바일 rest 호출시 mOptionService.commonInfoWeb 를
				// 사용하는 모듈들에서 에러가 발생하게 된다. 체크 후 넣어주는 로직!
				if (StringUtils.isEmpty(ezCommonService.selectUserGetLang(uid, tenantId))) {
					// UsePrimaryLangOnly가 YES일 때는 무조건 PrimaryLang 언어로 설정한다.
					if (config.getProperty("config.UsePrimaryLangOnly").equals("YES")) {
						if (primaryLang.equals("1")) {
							acceptLanguage = "ko";
						} else if (primaryLang.equals("3")) {
							acceptLanguage = "ja";
						}
					}

					String pcLang;

					if (acceptLanguage != null) {
						pcLang = acceptLanguage.substring(0, 2);
						// 이유는 정확히 알 수 없지만 로그를 확인한 결과 윗 라인에서 acceptLanguage가 null인 경우가 발생하여 추가함.
					} else {
						pcLang = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
					}

					pcLang = commonUtil.getLangNumFromTwoLetterLang(pcLang);

					// 브라우저 언어가 한국어/일본어가 아닐 경우 시스템 언어로 설정(영어/중국어 추후 지원)
					if (pcLang.equals("")) {
						pcLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
					}

					String primaryTimeZone = ezCommonService.getTenantConfig("PrimaryTimeZone", tenantId);

					if (primaryTimeZone.equals("")) {
						primaryTimeZone = Offset.KST;
					}

					ezCommonService.insertTblUserLocalInfo(uid, primaryTimeZone, pcLang, tenantId);
				}

				// 20180711 조진호 - 로그인 성공시 로그인실패 횟수 초기화
				ezCommonService.updateUserConfigInfo(tenantId, uid, "LoginFailCount", "0");

				/* 2018-01-08 장진혁 - 모바일에서 메일만 사용할 경우 YES or NO */
				String useMobileMailOnly = ezCommonService.getTenantConfig("useMobileMailOnly", tenantId);
				/* 2018-11-02 배현상 - 공유결재문서 사용 유무 YES or NO */
				String useShareApproval = ezCommonService.getTenantConfig("useShareApproval", tenantId);
				/* 2019-08-30 김수아 - 모바일 세션 시간 config - useMobileSession */
				String useSessionMobile = ezCommonService.getTenantConfig("useSessionMobile", tenantId);

				// 모바일 중복로그인 처리
				String useMultiLogin = ezCommonService.getCompanyConfig(tenantId, companyId, "useMultiLogin");
				String multiLoginTime = "";

				if ("NO".equalsIgnoreCase(useMultiLogin)) {
					multiLoginTime = String.valueOf(System.currentTimeMillis());
					commonUtil.setLoginUsers(tenantId, companyId, uid, multiLoginTime, Device.MOBILE);
				}

				Map<String, Object> map = new HashMap<String, Object>();
				map.put("uid", uid);
				map.put("ip", mIp);
				map.put("locale", returnValue);
				map.put("lang", lang);
				map.put("timeZone", timeZone);
				map.put("tenantId", tenantId + "");
				map.put("mainType", maintype);
				map.put("listCnt", listCnt);
				map.put("useSecurity", useSecurity);
				map.put("companyID", resultVO.getCompanyID());
				map.put("primaryLang", primaryLang);
				map.put("rollInfo", resultVO.getRollInfo());
				map.put("useSessionMobile", useSessionMobile);
				map.put("multiLoginTime", multiLoginTime);
				map.put("useOTP", useOTP);
				map.put("hasOTP", hasOTP);

				// LoginCookieSSO는 모바일용 쿠키가 아니라 웹버전 연동 쿠키임
				Map<String, Object> mapSSO = new HashMap<String, Object>();
				if (!useSSOCookie.trim().isEmpty() && !"NO".equalsIgnoreCase(useSSOCookie)) {
					// 20210521 조진호 - loginCookieSSO에서 사용자의 패스워드를 사용 할 이유가 없어 WEB과 동일하게 문자열로 처리
					// pwd = EgovFileScrty.encryptPassword(rpwd, uid);
					mapSSO.put("userPw", "userPw");
					mapSSO.put("encryptedUserPw", "encryptedUserPw");
					mapSSO.put("deptID", resultVO.getDeptID());
					mapSSO.put("companyID", resultVO.getCompanyID());
				}

				if ("1".equals(commonUtil.getPrimaryData(lang, tenantId))) {
					map.put("userName", resultVO.getDisplayName1());
				} else {
					map.put("userName", resultVO.getDisplayName2());
				}

				map.put("useMobileMailOnly", useMobileMailOnly);
				map.put("useShareApproval", useShareApproval);

				result.put("status", "ok");
				result.put("code", "0");
				result.put("data", map);
				result.put("dataSSO", mapSSO);

			// 2. OTP 인증을 실패 한 경우
			} else {
				// 2021-12-28 이사라 : 접속로그 실패 저장
				resultVO.setIp(mIp);
				resultVO.setAgent(mAgent);
				resultVO.setOs(mOs);
				resultVO.setBrowser(mBrowser);
				resultVO.setTenantId(tenantId);
				resultVO.setStatus("N");

				if (resultVO.getTitle2() == null) {
					resultVO.setTitle2("");
				}

				loginService.insertLog(resultVO);

				// 로그인 실패 처리
				// Check login state of the user
				int check = checkState(tenantId, uid, numberOfLoginFailPermit);
				String errorMsg1 = "";
				String errorMsg2 = "";
				String errorMsg3 = "";

				switch (check) {
				case -3:
					// Show block message
					result.put("status", "error");
					result.put("code", "3");
					result.put("data", egovMessageSource.getMessageExtend("fail.mobile.common.login.block",
							new Object[] { numberOfLoginFailPermit }, locale));
					break;
				case -2:
					// The first time this user login failed
					ezCommonService.insertUserConfigInfo(tenantId, uid, "LoginFailCount", "1");
					// Show warning message
					/* 2018-05-24 홍승비 - 로그인 실패 시 레이어팝업을 위해 플래그 추가, 메세지 리소스 분리 */
					errorMsg1 = egovMessageSource.getMessage("fail.mobile.common.login", locale);
					errorMsg1 += egovMessageSource.getMessage("fail.mobile.common.login.warning2", locale);
					errorMsg2 = egovMessageSource.getMessageExtend("fail.mobile.common.login.warning3",
							new Object[] { 1 }, locale);
					errorMsg3 = egovMessageSource.getMessage("fail.mobile.common.login.warning4", locale);
					errorMsg3 += "   " + egovMessageSource.getMessageExtend("fail.mobile.common.login.warning5",
							new Object[] { numberOfLoginFailPermit }, locale);
					result.put("status", "error");
					result.put("code", "3");
					result.put("data", errorMsg1 + errorMsg2 + errorMsg3);
					break;
				case -1:
					// Show normal login fail message
					result.put("status", "error");
					result.put("code", "3");
					result.put("data", "fail");
					break;
				default:
					// Increase number of attempts in database
					ezCommonService.updateUserConfigInfo(tenantId, uid, "LoginFailCount", Integer.toString(check + 1));

					if (check >= numberOfLoginFailPermit - 1) {
						// Show block message
						result.put("status", "error");
						result.put("code", "3");
						result.put("data", egovMessageSource.getMessageExtend("fail.mobile.common.login.block",
								new Object[] { numberOfLoginFailPermit }, locale));
					} else {
						// Show warning message
						errorMsg1 = egovMessageSource.getMessage("fail.mobile.common.login.warning2", locale);
						errorMsg2 = egovMessageSource.getMessageExtend("fail.mobile.common.login.warning3",
								new Object[] { check + 1 }, locale);
						errorMsg3 = egovMessageSource.getMessage("fail.mobile.common.login.warning4", locale);
						errorMsg3 += "   " + egovMessageSource.getMessageExtend("fail.mobile.common.login.warning5",
								new Object[] { numberOfLoginFailPermit }, locale);
						result.put("status", "error");
						result.put("code", "3");
						result.put("data", errorMsg1 + errorMsg2 + errorMsg3);
					}
				}

				logger.debug("OTP authentication fail.");
			}

			return result;
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", "1");
			result.put("data", "error");

			return result;
		}
	}

	// 2023-03-31 이사라 : [TFA] OTP 번호 확인을 위해 호출
	public String getTOTPCode(String otpKey) {
		Base32 base32 = new Base32();
		byte[] bytes = base32.decode(otpKey);
		String hexKey = Hex.encodeHexString(bytes);

		return TOTP.getOTP(hexKey);
	}

    /**
  	 * 모바일 G/W 사용자 [GET] 로그아웃
  	 * 2021-12-27 이사라  
  	 */
      @SuppressWarnings("unchecked")
  	  @RequestMapping(value="/mobile/ezUser/logout/sessions/{mSessionId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")    
      public JSONObject logout(@PathVariable String mSessionId, HttpServletRequest request, Locale locale) throws Exception {
      	logger.debug("=========================================== G/W logout ============================================");
      	
      	JSONObject result = new JSONObject();
      	String serverName = request.getHeader("x-user-host");
		int tenantId = loginService.getTenantId(serverName);
		LoginVO loginVO = new LoginVO ();
      	
      	try {
      		if (StringUtils.isBlank(mSessionId)) {
      			logger.debug("invalid mSessionId= " + mSessionId);
      			
      			result.put("status", "error");
      			result.put("code", "2");			
      			result.put("data", "invalid code");
      			
      		    return result;
      		}
      		       	
           	loginVO.setSessionCode(mSessionId);
           	loginVO.setTenantId(tenantId);
           	logger.debug("G/W logout sessionCode : " + mSessionId);
           	
           	loginService.updateLog(loginVO);
      		
           	result.put("status", "ok");
  			result.put("code", "0");			
  			result.put("data", "success");
  			
      		return result;
      		
      	} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");			
			result.put("data", "fail");
			
			return result;
      	}
    }
      
    @SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezUser/loginFromAzure/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")    
    public JSONObject loginFromAzure(@PathVariable String userId, HttpServletRequest request, Locale locale) throws Exception {
    	logger.debug("loginFromAzure started. userId=" + userId);
    	
    	JSONObject result = new JSONObject();
    	
    	try {
    		String uid = userId;
    		
    		if (uid == null || uid.equals("")) {
    			logger.debug("invalid uid=" + uid);
    			
    			result.put("status", "error");
    			result.put("code", "2");			
    			result.put("data", "invalid uid");
    			
    		    return result;
    		}
    		
    		String serverName = request.getHeader("x-user-host");
    		int tenantId = loginService.getTenantId(serverName);
    		
    		LoginVO loginVO = new LoginVO();
    		
    		loginVO.setId(uid);
    		loginVO.setDn("NOPASSWORD");
    		loginVO.setTenantId(tenantId);
    		
    		LoginVO resultVO = loginService.selectUser(loginVO);
    		
    		// 2019-05-08 홍승비 - LoginCookieSSO를 사용하는지 값을 확인
    		String useSSOCookie = ezCommonService.getTenantConfig("useLoginCookieSSO", tenantId);	    	
    		result.put("useLoginCookieSSO", useSSOCookie);
    					
    		if (resultVO == null || resultVO.getId() == null || resultVO.getId().equals("")) {
    			logger.debug("user does not exist :" + uid);
            	
    			result.put("status", "error");
    			result.put("code", "3");			
    			result.put("data", "user does not exist");
    			
    			return result;
    		} else {
				String ip = request.getHeader("ip") == null ? ClientUtil.getClientIP(request) : request.getHeader("ip");
				String agent = request.getHeader("agent") == null ? ClientUtil.getClientInfo(request, "agent") : request.getHeader("agent");
				String os = request.getHeader("os") == null ? ClientUtil.getClientInfo(request, "os") : request.getHeader("os");
				String browser = request.getHeader("browser") == null ? ClientUtil.getClientInfo(request, "browser") : request.getHeader("browser");
				resultVO.setIp(ip);

				logger.debug("request.getHeader: {}, ClientUtil.getClientIP: {}, finally ip: {}",
						request.getHeader("ip"), ClientUtil.getClientIP(request), ip);
        		
    			// 로그인 후 IP 주소 체크
				boolean ipAddressChk = ipAccessCheck(resultVO);
				logger.debug("ipAddressChk=" + ipAddressChk);
				
				if (!ipAddressChk) {
					result.put("status", "error");
	    			result.put("code", "7");			
	    			result.put("data", "user does not exist");
	    			
	    			// 2021-12-29 이사라 : ip 주소 check 실패인 경우 접속실패 로그 저장
					resultVO.setAgent(agent);
					resultVO.setOs(os);
					resultVO.setBrowser(browser);
					resultVO.setTenantId(tenantId);
					resultVO.setStatus("N");

					if (resultVO.getTitle2() == null) {
						resultVO.setTitle2("");
					}
					
					loginService.insertLog(resultVO);
					
	    			return result;
				}
    			
    			// 모바일 사용 설정 확인 
    			String useMobileManagemant = ezCommonService.getTenantConfig("useMobileManagemant", tenantId);
    			
    			if (useMobileManagemant.equals("YES")) {
    				String notUseAllMobileLogin = ezCommonService.getUserConfigInfo(tenantId, uid, "notUseMobileLogin");
    				String adminOrderNotUsedMobileLogin = ezCommonService.getUserConfigInfo(tenantId, uid, "adminOrderNotUsedMobileLogin");
    				
    				notUseAllMobileLogin = notUseAllMobileLogin.equals("") ? "0" : notUseAllMobileLogin;
    				adminOrderNotUsedMobileLogin = adminOrderNotUsedMobileLogin.equals("") ? "0" : adminOrderNotUsedMobileLogin;
    				
    				if (adminOrderNotUsedMobileLogin.equals("1") || notUseAllMobileLogin.equals("1")) {
    					logger.debug("cannot use mobile login. userId=" + uid);
    					
    					result.put("status", "error");
    					result.put("code", "6");
    					result.put("data", "cannot use mobile login.");
    					
    					// 2021-12-29 이사라 : 접속 실패 로그 저장 - 모바일 사용금지 설정 
    					resultVO.setIp(ip);
    					resultVO.setAgent(agent);
    					resultVO.setOs(os);
    					resultVO.setBrowser(browser);
    					resultVO.setTenantId(tenantId);
    					resultVO.setStatus("N");

    					if (resultVO.getTitle2() == null) {
    						resultVO.setTitle2("");
    					}
    					
    					loginService.insertLog(resultVO);
    					
    					return result;
    				} else {
    					String deviceId = request.getParameter("deviceID") == null ? "" : request.getParameter("deviceID");
    					
    					if (!deviceId.equals("")) {
    						String inputParams = "userId=" + uid + "&deviceId=" + deviceId;
    						logger.debug("userId=" + uid + ",deviceId=" + deviceId);
    						
    						String requestURL = "/ezTalkGate/getUserMobileDeviceUsedInfo";
    						String getResult = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + requestURL, inputParams);
    						logger.debug("getResult=" + getResult);
    						
    						JSONParser parser = new JSONParser();
    						JSONObject resultObj = (JSONObject) parser.parse(getResult);

    						if (Integer.valueOf(String.valueOf(resultObj.get("data"))) > 0) {
    							logger.debug("this device cannot use. userId=" + uid);
    							
    							result.put("status", "error");
    							result.put("code", "6");			
    							result.put("data", "this device cannot use.");
    							
    							// 2021-12-29 이사라 : 접속 실패 로그 저장 - 접속한 디바이스 사용금지
    	    					resultVO.setIp(ip);
    	    					resultVO.setAgent(agent);
    	    					resultVO.setOs(os);
    	    					resultVO.setBrowser(browser);
    	    					resultVO.setTenantId(tenantId);
    	    					resultVO.setStatus("N");

    	    					if (resultVO.getTitle2() == null) {
    	    						resultVO.setTitle2("");
    	    					}
    	    					
    	    					loginService.insertLog(resultVO);
    	    					
    							return result;
    						} else { 
    							// 0이지만 그전 사용자의 config 확인
    							String oldUserId = String.valueOf(resultObj.get("oldUserId"));
    							notUseAllMobileLogin = ezCommonService.getUserConfigInfo(tenantId, oldUserId, "notUseMobileLogin");
    							adminOrderNotUsedMobileLogin = ezCommonService.getUserConfigInfo(tenantId, oldUserId, "adminOrderNotUsedMobileLogin");
    		    				
    		    				notUseAllMobileLogin = notUseAllMobileLogin.equals("") ? "0" : notUseAllMobileLogin;
    		    				adminOrderNotUsedMobileLogin = adminOrderNotUsedMobileLogin.equals("") ? "0" : adminOrderNotUsedMobileLogin;
    						
    		    				if (adminOrderNotUsedMobileLogin.equals("1") || notUseAllMobileLogin.equals("1")) {
    		    					logger.debug("cannot use mobile login. oldUserId=" + oldUserId);
    		    					
    		    					result.put("status", "error");
    		    					result.put("code", "6");
    		    					result.put("data", "cannot use mobile login.");
    		    					
    		    					// 2021-12-29 이사라 : 접속 실패 로그 저장 - 모바일 사용설정 금지 oldUserId
    		    					resultVO.setIp(ip);
    		    					resultVO.setAgent(agent);
    		    					resultVO.setOs(os);
    		    					resultVO.setBrowser(browser);
    		    					resultVO.setTenantId(tenantId);
    		    					resultVO.setStatus("N");

    		    					if (resultVO.getTitle2() == null) {
    		    						resultVO.setTitle2("");
    		    					}
    		    					
    		    					loginService.insertLog(resultVO);
    		    					
    		    					return result;
    		    				}
    						}
    					}
    				}
    			}
    			
				// 공유사서함 기능을 사용할 경우 공유사서함 계정으로의 로그인을 막는다.
	    		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
	    		
	    		if (useSharedMailbox.equals("YES")) {
	    			if (resultVO.getDeptID() != null && resultVO.getDeptID().startsWith("shared_mailbox_")) {
	    				logger.debug("Cannot login with shared mailbox account.");
	    				
	    				result.put("status", "error");
		    			result.put("code", "3");			
		    			result.put("data", "user does not exist");
		    			
	        	        return result;
	    			}
	    		}
	    		
	    		// 2021-12-23 이사라 : 접속 로그 저장을 위해 순서 변경
	    		String mIp = request.getHeader("ip");
		    	String mAgent = request.getHeader("agent");
		    	String mBrowser = request.getHeader("browser");
		    	String mOs = request.getHeader("os");
		    	
		    	if (mIp == null) {
		    		mIp = ClientUtil.getClientIP(request);
		    	}
		    	
		    	if (mAgent == null) {
		    		mAgent = ClientUtil.getClientInfo(request, "agent");
		    	}
		    	
		    	if (mBrowser == null) {
		    		mBrowser = ClientUtil.getClientInfo(request, "browser");
		    	}
		    	
		    	if (mOs == null) {
		    		mOs = ClientUtil.getClientInfo(request, "os");
		    	}
		    	
				loginVO.setIp(mIp);
				
	    		// 사용자정지 여부를 체크
	        	String useLoginStop = ezCommonService.getTenantConfig("useLoginStop", tenantId);
	        	
	        	if (useLoginStop != null && useLoginStop.equals("YES")) {
	        		int flag = checkStopUser(tenantId, resultVO.getId());
	        		if(flag > 0) {
	        			logger.debug("stopUser");
	        			result.put("status", "error");
    					result.put("code", "8");			
    					result.put("data", "stopUser");
    					
    					// 2021-12-23 이사라 : 접속 실패 로그정보 저장
    					resultVO.setIp(mIp);
    					resultVO.setAgent(mAgent);
    					resultVO.setOs(mOs);
    					resultVO.setBrowser(mBrowser);
    					resultVO.setTenantId(tenantId);
    					resultVO.setStatus("N");
    					
    					if(resultVO.getTitle2() == null){
    						resultVO.setTitle2("");
    					}
    					
    					loginService.insertLog(resultVO);
    					
    					return result;
	        		}
	        	}
				/*                	
		    	String mIp = request.getHeader("ip");
		    	String mAgent = request.getHeader("agent");
		    	String mBrowser = request.getHeader("browser");
		    	String mOs = request.getHeader("os");
		    	
		    	if (mIp == null) {
		    		mIp = ClientUtil.getClientIP(request);
		    	}
		    	
		    	if (mAgent == null) {
		    		mAgent = ClientUtil.getClientInfo(request, "agent");
		    	}
		    	
		    	if (mBrowser == null) {
		    		mBrowser = ClientUtil.getClientInfo(request, "browser");
		    	}
		    	
		    	if (mOs == null) {
		    		mOs = ClientUtil.getClientInfo(request, "os");
		    	}
		    	
				loginVO.setIp(mIp);
				*/
	        	
				//IP Address,  마지막 login시간 저장
				loginService.updateUser(loginVO);
				
				// 2021-12-28 이사라 : 세션ID를 세션코드로 입력 
				String sessionCode = request.getHeader("mSessionId") == null ? ClientUtil.getClientIP(request) : request.getHeader("mSessionId");
	        	logger.debug("Login sessionCode = " + sessionCode);
	        	
				//접속 로그정보 저장
				resultVO.setIp(mIp);
				resultVO.setAgent(mAgent);
				resultVO.setOs(mOs);
				resultVO.setBrowser(mBrowser);
				resultVO.setTenantId(tenantId);
				resultVO.setStatus("Y");
				resultVO.setSessionCode(sessionCode);
				
				if(resultVO.getTitle2() == null){
					resultVO.setTitle2("");
				}
				
				loginService.insertLog(resultVO);
				
				//DB에서 모바일 환경설정 값 가져옴
				MOptionVO mOptionVO = mOptionService.optionInfo(uid, tenantId);
				
				String acceptLanguage = request.getHeader("Accept-Language");    				
				String lang = "";
				String timeZone = "";
				String maintype = "";
				String listCnt = "";    				
				String useSecurity = "";					
				String returnValue = "";
				
				String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
				
				//userMobileInfo 테이블에 정보가 없을 때 (첫 로그인)
				if (mOptionVO == null) {    			        
					
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
					
					//브라우저 언어가 한국어/일본어가 아닐 경우 시스템 언어로 설정(영어/중국어 추후 지원)
					if (lang.equals("")) {						
						lang = primaryLang;
					}
					
					timeZone = ezCommonService.getTenantConfig("PrimaryTimeZone", tenantId);
				    
				    if (timeZone.equals("")) {
				    	timeZone = "235|+09:00";
				    }
				    
					maintype = "D";
					listCnt = "10";    				    
					useSecurity = "N";
					
					mOptionService.insertOption(uid, timeZone, lang, maintype, listCnt, useSecurity, tenantId);    					
				} else {
					lang = mOptionVO.getLang();
					timeZone = mOptionVO.getTimeZone();
					maintype = mOptionVO.getMainType();
					listCnt = mOptionVO.getListCnt();        				
					useSecurity = mOptionVO.getUseSecurity();
					returnValue = commonUtil.getTwoLetterLangFromLangNum(lang);
				}
				// 20180711 조진호 - 로그인 성공시 로그인실패 횟수 초기화
				ezCommonService.updateUserConfigInfo(tenantId, uid, "LoginFailCount", "0");
				
				// 2018-01-08 장진혁 - 모바일에서 메일만 사용할 경우 YES or NO 
				String useMobileMailOnly = ezCommonService.getTenantConfig("useMobileMailOnly", tenantId);
				// 2018-11-02 배현상 - 공유결재문서 사용 유무 YES or NO 
				String useShareApproval = ezCommonService.getTenantConfig("useShareApproval", tenantId);
				// 2019-08-30 김수아 - 모바일 세션 시간 config - useMobileSession 
				String useSessionMobile = ezCommonService.getTenantConfig("useSessionMobile", tenantId);
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("uid", uid);
				map.put("ip", mIp);
				map.put("locale", returnValue);
				map.put("lang", lang);
				map.put("timeZone", timeZone);
				map.put("tenantId", tenantId+"");
				map.put("mainType", maintype);
				map.put("listCnt", listCnt);    				
				map.put("useSecurity", useSecurity);    		
				map.put("companyID", resultVO.getCompanyID());
				map.put("primaryLang", primaryLang);
				map.put("rollInfo", resultVO.getRollInfo());
				map.put("useSessionMobile", useSessionMobile);    				
				
				// LoginCookieSSO는 모바일용 쿠키가 아니라 웹버전 연동 쿠키임
				Map<String, Object> mapSSO = new HashMap<String, Object>();
				
				if (!useSSOCookie.trim().isEmpty() && !"NO".equalsIgnoreCase(useSSOCookie)) {
					mapSSO.put("userPw", "userPw");
					mapSSO.put("encryptedUserPw", "encryptedUserPw");
					mapSSO.put("deptID", resultVO.getDeptID());
					mapSSO.put("companyID", resultVO.getCompanyID());
				}
				
				if ("1".equals(commonUtil.getPrimaryData(lang, tenantId))) {
					map.put("userName", resultVO.getDisplayName1());
				} else {
					map.put("userName", resultVO.getDisplayName2());
				}
				
				map.put("useMobileMailOnly", useMobileMailOnly);
				map.put("useShareApproval", useShareApproval);
				
				result.put("status", "ok");
				result.put("code", "0");
				result.put("data", map);
				result.put("dataSSO", mapSSO);
				
				logger.debug("loginFromAzure ended.");
				
				return result;
    		}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");			
			result.put("data", "fail");
			
			return result;
		}    	      
    }
    
    /**
     * 하이브리드 앱에 로그인 한 뒤 기기 정보를 업데이트 한다.  
     */
    @SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezUser/login/users/updateLoginDeviceInfo", method=RequestMethod.POST, produces="application/json;charset=utf-8")
    @ResponseBody
    public JSONObject updateLoginDeviceInfo(@RequestBody String bodyData, 
    		HttpServletRequest request, HttpServletResponse response) throws Exception {
    	logger.debug("updateLoginDeviceInfo started.");
    	
    	int resultCnt = -1;
    	String responseObj = null;
    	JSONObject result = new JSONObject();
    	JSONParser jsonParser = new JSONParser();
    	JSONObject jsonObj = (JSONObject) jsonParser.parse(bodyData);
    	
    	try {
    		String serverName = request.getHeader("x-user-host");
    		String tenantId = String.valueOf(loginService.getTenantId(serverName));
    		
    		String devId = "devId=" + (String) jsonObj.get("devId");
    		String devType = "devType=" + (String) jsonObj.get("devType");
    		String subType = "subType=" + (String) jsonObj.get("subType");
    		String userId = "userId=" + (String) jsonObj.get("userId");
    		String token = "token=" + (String) jsonObj.get("token");
    		String badge = "badge=" + (String) jsonObj.get("badge");
    		String state = "state=" + (String) jsonObj.get("state");
    		String pushState = "pushState=" + (String) jsonObj.get("pushState");
    		String isLogin = "isLogin=" + (String) jsonObj.get("isLogin");
    		String startMenu = "startMenu=" + (String) jsonObj.get("startMenu");
    		String loginLock = "loginLock=" + (String) jsonObj.get("loginLock");
    		String isPasswordChange = "isPasswordChange=" + (String) jsonObj.get("isPasswordChange");
    		String extension1 = "extension1=" + (String) jsonObj.get("extension1");
    		String extension2 = "extension2=" + (String) jsonObj.get("extension2");
    		String tenantIdParmas = "tenantId=" + tenantId;
    		String pin = "pin=" + (String) jsonObj.get("pin");
    		String pinState = "pinState=" + (String) jsonObj.get("pinState");
    		String biometric = "biometric=" + (String) jsonObj.get("biometric");
    		
    		String inputParams = devId + "&"+ devType + "&" + subType + "&" + userId + "&" + token +
    				"&" + badge + "&" + state + "&" + pushState + "&" + isLogin + "&" + startMenu + 
    				"&" + loginLock + "&" + isPasswordChange + "&" + extension1 + "&" + extension2 + 
    				"&" + tenantIdParmas + "&" + pin + "&" + pinState + "&" + biometric;
    		logger.debug("inputParams=" + inputParams);
    		
    		String requestURL = "/ezTalkGate/updateLoginDeviceInfo";
    		
    		responseObj = ezEmailUtil.getWebServiceResult(
    							config.getProperty("config.JGwServerURL") + requestURL, inputParams);
    		logger.debug("responseObj=" + responseObj);
    		
    		JSONObject resultObj = (JSONObject) jsonParser.parse(responseObj);
    		resultCnt = Integer.valueOf(String.valueOf(resultObj.get("resultCnt")));
			logger.debug("resultCnt=" + resultCnt);
			
			if (resultCnt > 0 && resultObj.get("resultCode").equals("OK")) {
				result.put("status", "ok");
				result.put("code", "0");
				result.put("data", resultCnt);

				logger.debug("device info updated ok.");
			} else {
				result.put("status", "error");
				result.put("code", "1");
				result.put("data", "device info update fail");

				logger.debug("device info update fail." + userId + ", devId=" + devId);
			}
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "-1");
			result.put("data", "fail");
			
			logger.error(e.getMessage(), e);
		}
    	
    	logger.debug("updateLoginDeviceInfo ended.");

    	return result;
    }
    
	@RequestMapping(value="/mobile/ezUser/login/users/{userId}/multilogin", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject validMultiLogin(@PathVariable String userId, @RequestParam String multiLoginTime, HttpServletRequest request) throws Exception {
		logger.debug("validMultiLogin started.");

		Map<String, String> result = new HashMap<>();

		try {
			String serverName = request.getHeader("x-user-host");
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			String companyId = userInfo.getCompanyID();

			// 중복로그인 자체를 허용하거나 multiLoginTime이 동일하다면 유효함
			boolean allowMultiLogin = "YES".equalsIgnoreCase(ezCommonService.getCompanyConfig(tenantId, companyId, "useMultiLogin"));
			boolean isValid = allowMultiLogin || ezCommonService.matchMultiLoginTime(tenantId, companyId, userId, multiLoginTime, Device.MOBILE);

			result.put("status", isValid ? "ok" : "error");
			result.put("code", "0");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");
			result.put("data", "server error: " + e.getMessage());
		}

		logger.debug("validMultiLogin ended.");

		return new JSONObject(result);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezUser/login/users/{userId}/valid", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject valid(@PathVariable String userId, HttpServletRequest request, Locale locale) throws Exception {
		logger.debug("valid started.");
		JSONObject result = new JSONObject();

		String serverName = request.getHeader("x-user-host");
		int tenantId = loginService.getTenantId(serverName);
		// 모바일 사용 설정 확인
		String useMobileManagemant = ezCommonService.getTenantConfig("useMobileManagemant", tenantId);

		check: if (useMobileManagemant.equals("YES")) {
			String notUseAllMobileLogin = ezCommonService.getUserConfigInfo(tenantId, userId, "notUseMobileLogin");
			String adminOrderNotUsedMobileLogin = ezCommonService.getUserConfigInfo(tenantId, userId, "adminOrderNotUsedMobileLogin");

			notUseAllMobileLogin = notUseAllMobileLogin.equals("") ? "0" : notUseAllMobileLogin;
			adminOrderNotUsedMobileLogin = adminOrderNotUsedMobileLogin.equals("") ? "0" : adminOrderNotUsedMobileLogin;

			if (adminOrderNotUsedMobileLogin.equals("1") || notUseAllMobileLogin.equals("1")) {
				logger.debug("cannot use mobile login. userId={}", userId);

				result.put("status", "error");
				result.put("code", "6");
				result.put("data", "cannot use mobile login.");

				return result;
			}

			String deviceId = request.getParameter("deviceID") == null ? "" : request.getParameter("deviceID");

			if (deviceId.trim().isEmpty()) {
				break check;
			}

			String inputParams = "userId=" + userId + "&deviceId=" + deviceId;
			logger.debug("userId=" + userId + ",deviceId=" + deviceId);

			String requestURL = "/ezTalkGate/getUserMobileDeviceUsedInfo";
			String getResult = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + requestURL, inputParams);
			logger.debug("getResult=" + getResult);

			JSONParser parser = new JSONParser();
			JSONObject resultObj = (JSONObject) parser.parse(getResult);

			if (Integer.valueOf(String.valueOf(resultObj.get("data"))) > 0) {
				logger.debug("this device cannot use. userId=" + userId);

				result.put("status", "error");
				result.put("code", "6");
				result.put("data", "this device cannot use.");

				return result;
			}
			// 0이지만 그전 사용자의 config 확인
			String oldUserId = String.valueOf(resultObj.get("oldUserId"));
			notUseAllMobileLogin = ezCommonService.getUserConfigInfo(tenantId, oldUserId, "notUseMobileLogin");
			adminOrderNotUsedMobileLogin = ezCommonService.getUserConfigInfo(tenantId, oldUserId, "adminOrderNotUsedMobileLogin");

			notUseAllMobileLogin = notUseAllMobileLogin.equals("") ? "0" : notUseAllMobileLogin;
			adminOrderNotUsedMobileLogin = adminOrderNotUsedMobileLogin.equals("") ? "0" : adminOrderNotUsedMobileLogin;

			if (adminOrderNotUsedMobileLogin.equals("1") || notUseAllMobileLogin.equals("1")) {
				logger.debug("cannot use mobile login. oldUserId=" + oldUserId);

				result.put("status", "error");
				result.put("code", "6");
				result.put("data", "cannot use mobile login.");

				return result;
			}
		}

		result.put("status", "ok");
		result.put("code", "0");
		logger.debug("valid ended.");
		return result;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezUser/pinLogin", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPinLoginInfo(HttpServletRequest request, Locale locale) throws Exception {
		logger.debug("pinLogin started.");

		JSONObject result = new JSONObject();
    	String deviceId = request.getParameter("deviceId");
    	
    	try {
    		
    		String strJson = mOptionService.getDevicePinfInfo(deviceId, "");

    		JSONParser parser = new JSONParser();
			JSONObject pinInfo = (JSONObject)parser.parse(strJson);
			JSONObject data = (JSONObject) pinInfo.get("data");
			//String pinState = data.get("pinState").toString();
			
			result.put("status", "ok");
    		result.put("code", "0");
    		result.put("data", data);
    		
    	} catch (Exception e) {
    		result.put("status", "error");
			result.put("code", "-1");
			result.put("data", "fail");
			
			logger.error(e.getMessage(), e);
    	}
    	
    	logger.debug("pinLogin ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezUser/pinLogin/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject pinLogin(@PathVariable String userId, HttpServletRequest request, Locale locale) throws Exception {
		logger.debug("pinLogin started.");

		JSONObject result = new JSONObject();
    	String deviceId = request.getParameter("deviceId");
    	
    	try {
    		
    		PrivateKey pk = EgovFileScrty.getPrivateKey(egovFileScrty.getPrm(), egovFileScrty.getPre());
    		
    		String uid = EgovFileScrty.decryptRsa(pk, userId);
    		
    		if (uid == null || uid.equals("")) {
    			logger.debug("invalid uid=" + uid);
    			
    			result.put("status", "error");
    			result.put("code", "2");			
    			result.put("data", "invalid uid");
    			
    		    return result;
    		}
    		
    		String rpwd = EgovFileScrty.decryptRsa(pk, request.getParameter("pw"));
    		String pwd = "";
    		
    		String serverName = request.getHeader("x-user-host");
    		int tenantId = loginService.getTenantId(serverName);
    		
    		LoginVO loginVO = new LoginVO();
    		
    		loginVO.setId(uid);
    		loginVO.setDn("NOPASSWORD");
    		loginVO.setTenantId(tenantId);
    		
    		LoginVO resultVO = loginService.selectUser(loginVO);
    		String companyId = resultVO.getCompanyID();
    		
    		
    		
    		String strJson = mOptionService.getDevicePinfInfo(deviceId, "");

    		JSONParser parser = new JSONParser();
			JSONObject pinInfo = (JSONObject)parser.parse(strJson);
			JSONObject data = (JSONObject) pinInfo.get("data");
			//String pinState = data.get("pinState").toString();
			
			result.put("status", "ok");
    		result.put("code", "0");
    		result.put("data", data);
    		
    	} catch (Exception e) {
    		result.put("status", "error");
			result.put("code", "-1");
			result.put("data", "fail");
			
			logger.error(e.getMessage(), e);
    	}
    	
    	logger.debug("pinLogin ended.");
		return result;
	}
	
	
    private int checkState(int tenantID, String userId, int numberOfLoginFailPermit) throws Exception {        
        if (numberOfLoginFailPermit <= 0) {        	
        	//Users will never be blocked
        	return -1; 
        }
        
    	String userLoginFailedAttempt = ezCommonService.getUserConfigInfo(tenantID, userId, "LoginFailCount");
        
        if (userLoginFailedAttempt.equals("")) {
        	//This is the first time this user failed to login        	
        	return -2; 
        } else {
        	int currentNumber = 0;
        	
        	try {
        		currentNumber = Integer.parseInt(userLoginFailedAttempt);
        	// Exception이 발생하는 경우엔 LoginFailCount가 0인 경우로 처리한다.
        	} catch (Exception e) {
        		logger.error(e.getMessage(), e);
        	}
        	
        	if (currentNumber >= numberOfLoginFailPermit) {
        		//User has been blocked        		
        		return -3;
        	} else {
        		//User has some remaining times to try to login        		
        		return currentNumber;
        	}
        } 
    }
    
    public boolean ipAccessCheck(LoginVO loginVO) throws Exception {
    	logger.debug("ipAccessCheck start");
    	
    	String useIPAccess = ezCommonService.getTenantConfig("useIPAccess", loginVO.getTenantId());
    	useIPAccess = useIPAccess.equals("") ? "NO" : useIPAccess;
		boolean returnValue = false;
    	
    	if (useIPAccess.equals("NO")) {
    		logger.debug("ipAccessCheck ended.");
    		return true;
    	} else { // uerIPAccess 사용하면 IP, ID 체크
    		String topID = loginVO.getCompanyID();
    		String deptID = loginVO.getDeptID();
    		String primary = loginVO.getPrimary();
    		int tenantID = loginVO.getTenantId();
    		String clientIp[] = loginVO.getIp().split("\\.");
    		List<AccessIdVO> accessIdList = EzSystemAdminService.getAllAccessList(primary, tenantID, topID);
    		List<AccessIdVO> accessDeptList = EzSystemAdminService.getAllAccessListDept(primary, tenantID, topID);
    		List<IPBandVO> ipBandList = EzSystemAdminService.getAllIPBand(tenantID);
    		
    		// ID 먼저 체크
    		if (!(accessIdList == null || accessIdList.size() == 0)) {
    			for (int i = 0; i < accessIdList.size(); i++) {
    				String getListId = accessIdList.get(i).getCn();
    				if (loginVO.getId().equals(getListId)) {
    					logger.debug("id checked");
    					return true;
    				}
    			}
    		}
    		
    		// 부서 체크
    		if (!(accessDeptList == null || accessDeptList.size() == 0)) {
    			for (int i = 0; i < accessDeptList.size(); i++) {
    				String getListDept = accessDeptList.get(i).getCn();
    				if (deptID.equals(getListDept) || topID.equals(getListDept)) {
    					logger.debug("dept checked");
    					return true;
    				}
    			}
    		}
    		
    		// IP 대역 체크
    		String getAccess = "NO";
    		int checkCnt = 0;
    		if (!(ipBandList == null || ipBandList.size() == 0)) {
    			for (int i = 0; i < ipBandList.size(); i++) {
    				getAccess = ipBandList.get(i).getAccess();
    				
    				String ipListIp[] = ipBandList.get(i).getIpAddress().split("\\.");
    				for (int j = 0; j < clientIp.length; j++) {
    					if (ipListIp[j].equals(clientIp[j]) || ipListIp[j].equals("*")) {
    						checkCnt++;
    					}
    				}
    				
    				if (checkCnt == 4 && getAccess.equals("NO")) {
    					return false;
    				} else if (checkCnt == 4) {
    					returnValue = true;
    				}
    				checkCnt = 0;
    			} 
    		} /*else { // 대역이 등록 안되어있으면 무조건 false (userIPAccess컨피그 사용O -> id체크X -> 부서체크X -> 등록된 대역도 없으므로)
    			return false;
    		}*/
    		
    		// 허용 국가 리스트
        	String countryCodeList = ezSystemAdminService.getAccessCountryList(loginVO.getTenantId());
        	if (!countryCodeList.trim().equals("")) {
        		// 1. 사설 아이피인지 확인 후 
        		String loginCountryCode = "";
        		String loginCountryName = "";
        		
        		Boolean localIpChk = commonUtil.checkLocalIP(loginVO.getIp());
        		
        		if (localIpChk) {
        			loginCountryCode = ezCommonService.getTenantConfig("systemCountryCode", loginVO.getTenantId());
        		} else { // 2.아니면 db에서 어떤 국가인지 체크
            		long changeIP = changeIPtoInteger(loginVO.getIp());
            		logger.debug("changeIP=" + changeIP);
            		
            		CountryVO countryVo = loginService.getLoginIPCountry(changeIP);
            		if (countryVo != null){
            			loginCountryCode = countryVo.getCountryCode();
            			loginCountryName = countryVo.getCountryName();
            		}
        		} // localIPChk end

    			logger.debug("countryCodeList=" + countryCodeList);
    			logger.debug("LoginIpCountry=" + loginCountryCode + ":" + loginCountryName);
    			
    			if (countryCodeList.indexOf(loginCountryCode) > -1){
    				returnValue = true;
    			}
        	}
    		
    	}

    	logger.debug("ipAccessCheck ended.");
    	return returnValue;
    }
    
    private int checkStopUser(int tenantID, String userID) throws Exception {
    	int flag = ezOrganAdminService.checkStopUser(userID, tenantID);
    	return flag;
    }   
    
    private long changeIPtoInteger(String changeIP) throws Exception {
    	String[] iparr = changeIP.split("\\.");
    	long returnChangeIp = 0;
    	
		if (iparr.length == 4) {
			returnChangeIp = (long) Math.pow(256, 3) * Integer.parseInt(iparr[0])
					+ (long) Math.pow(256, 2) * Integer.parseInt(iparr[1])
					+ (long) Math.pow(256, 1) * Integer.parseInt(iparr[2])
					+ (long) Math.pow(256, 0) * Integer.parseInt(iparr[3]);
		}
		
		return returnChangeIp;
    }
    
}