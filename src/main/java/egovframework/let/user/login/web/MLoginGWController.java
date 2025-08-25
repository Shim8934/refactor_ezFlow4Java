package egovframework.let.user.login.web;

import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
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
import org.springframework.dao.DataAccessException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
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
import egovframework.let.user.login.vo.FidoAuthenticationVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.SessionVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.Offset;
import egovframework.let.utl.fcc.service.CommonUtil.PasswordCheckPolicyResult;
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
	 * 로그인 과정 : 결과값 ENUM 객체
	 * @see {@link https://velog.io/@injoon2019/자바-열거형enums}
	 */
    @SuppressWarnings("unchecked")
	public enum MLoginResult {
		// OK : 로그인 쿠키를 생성함. 아래 '4) 로그인 성공 절차'를 타는 경우에만 status = ok 일 수 있다.
		// SUCCESS("ok", 0, "ok"),

		// ERROR
		ERROR_FAIL("error", 1, "fail"),
		ERROR_INVALID_UID("error", 2, "invalid uid"),
		ERROR_USER_NOTFOUND("error", 3, "user does not exist"),
		ERROR_GOTO_CHANGEPW_FIRSTLOGIN("error", 4, "isFirstLogin"),
		ERROR_GOTO_CHANGEPW_EXPIREDATE("error", 5, "isExpireDate"),
		ERROR_CANNOT_USE_MOBILE_LOGIN("error", 6, "cannot use mobile login."),
		ERROR_CANNOT_USE_DEVICE("error", 6, "this device cannot use."),
		ERROR_IP_NOT_ALLOWED("error", 7, "IPAddress Not Allowed"),
		ERROR_STOPUSER("error", 8, "stopUser"),
		// otp key 문제로 후에 에러처리를 하나 pw 인증이 틀린 것은 아니기 때문에, 실패 카운트 올리지 않음.
		ERROR_NO_VALID_OTP("error", 9, "has no valid OTP key."),
		ERROR_HASNOT_SET_OTP("error", 9, "hasn't set OTP key."),
		// ERROR_WRONG_OTP("error", 10, "fail"), // OTP 번호가 올바르지 않습니다.
		ERROR_GOTO_OTP("error", 11, "use and has OTP key."),

		ERROR_CANNOT_USE_MOBILE_LOGIN_BY_ADMIN("error", 12, "cannot use mobile login.");

		private final String status;
		private final int code;
		private final String data;

		MLoginResult(String status, int code, String data) {
			this.status = status;
			this.code = code;
			this.data = data;
		}

		public String getStatus() {
			return status;
		}

		public int getCode() {
			return code;
		}

		public String getData() {
			return data;
		}

		public JSONObject getResult() {
			JSONObject result = new JSONObject();
			result.put("status", status);
			result.put("code", code);
			result.put("data", data);
			return result;
		}

//		public boolean succeeded() {
//			return "OK".equalsIgnoreCase(status);
//		}

	}

    /**
	 * 모바일 G/W 사용자 [GET] 로그인
	 */
    @SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezUser/login/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")    
    public JSONObject login(@PathVariable String userId, HttpServletRequest request, Locale locale) throws Exception {
    	logger.debug("=========================================== G/W login ============================================");
    	JSONObject result = new JSONObject();

		loginProcess : {
    	try {
			// SSO 솔루션없이 기간계와의 모바일 자동 로그인 처리를 위한 SLO(Single Log On) 처리 여부를 나타냄.			
			String SLOParam = request.getParameter("SLO");
			boolean isSLOSupport = "yes".equalsIgnoreCase(SLOParam);
			String formatedNow = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    	
				// SLO의 경우엔 암호화하지 않은 아이디가 ezMobile로부터 전달됨.
				// 기간계에서 암호화해서 전달한 아이디를 ezMobile이 복호화한 후 Mobile GW 서버로 전송하는 것임.
			PrivateKey pk = EgovFileScrty.getPrivateKey(egovFileScrty.getPrm(), egovFileScrty.getPre());
			String uid = isSLOSupport? userId 	: EgovFileScrty.decryptRsa(pk, userId);
			String rpwd = isSLOSupport? ""		: EgovFileScrty.decryptRsa(pk, request.getParameter("pw"));
			String pwd = "";

			if (StringUtils.isBlank(uid)) {
				logger.debug("invalid uid=" + uid);

				result = MLoginResult.ERROR_INVALID_UID.getResult();
				break loginProcess;
			}

			logger.debug("isSLOSupport={},uid={}", isSLOSupport, uid);
    		
    		String serverName = request.getHeader("x-user-host");
    		int tenantId = loginService.getTenantId(serverName);
    		
    		LoginVO loginVO = new LoginVO();
    		loginVO.setForSelectUser(uid, "NOPASSWORD", tenantId);
    		
    		LoginVO resultVO = loginService.selectUser(loginVO);
    		String companyId = resultVO.getCompanyID();
    		
    		int numberOfLoginFailPermit = 0;
    		// 로그인 실패 최대 허용 횟수를 구한다.
    		String maxAllowedCountOfLoginFail = ezCommonService.getCompanyConfig(tenantId, companyId, "MaxAllowedCountOfLoginFail");
			String loginLockedDuration = ezCommonService.getCompanyConfig(tenantId, companyId, "LoginLockedDuration");
			String loginLockedDate = ezCommonService.getUserConfigInfo(tenantId, uid, "LoginLockedDate");
			
			Map<String, Object> paramMap  = new HashMap<>();
			paramMap .put("formatedNow", formatedNow);
			paramMap .put("loginLockedDuration", loginLockedDuration);
			paramMap .put("loginLockedDate", loginLockedDate);
			logger.debug("companyId : {}, maxAllowedCountOfLoginFail : {}, loginLockedDuration : {}, loginLockedDate : {}", companyId, maxAllowedCountOfLoginFail, loginLockedDuration, loginLockedDate);
			// String maxAllowedCountOfLoginFail = ezCommonService.getTenantConfig("MaxAllowedCountOfLoginFail", tenantId);
					
			if (!StringUtils.isBlank(maxAllowedCountOfLoginFail)) {
				try {
					numberOfLoginFailPermit = Integer.parseInt(maxAllowedCountOfLoginFail);
					// 암호 오류 최대 횟수를 기존에 사용하고 있는 경우 계정 잠금 기간 config를 추가
					if (loginLockedDuration.equals("")){
						ezCommonService.insertCompanyConfig(tenantId, companyId, "LoginLockedDuration", "5");
						loginLockedDuration = ezCommonService.getCompanyConfig(tenantId, companyId, "LoginLockedDuration");
					}
				} catch (NumberFormatException e) {
					logger.error(e.getMessage(), e);
				}
			}

			// 비밀번호 '다음에 변경하기'는 이미 로그인 정보(OTP포함) 인증을 마친 상태에서 나타나기 때문에 verifyingOTP 와 verifyingPWPeriod 를 스킵함.
			String passwordUpdateNextTime = request.getParameter("nextTime");
			boolean nextTime = "yes".equalsIgnoreCase(passwordUpdateNextTime);

			// 로그인 정보 저장을 위한 값 처리
			// 2021-12-28 이사라 : 세션ID를 세션코드로 입력
			String ip = StringUtils.defaultString(request.getHeader("ip"), ClientUtil.getClientIP(request));
			String agent = StringUtils.defaultString(request.getHeader("agent"), ClientUtil.getClientInfo(request, "agent"));
			String browser = StringUtils.defaultString(request.getHeader("browser"), ClientUtil.getClientInfo(request, "browser"));
			String os = StringUtils.defaultString(request.getHeader("os"), ClientUtil.getClientInfo(request, "os"));
			String mSessionCode = StringUtils.defaultString(request.getHeader("mSessionId"), request.getSession().getId());
			logger.debug("Login info : ip={}, agent={}, os={}, browser={}, mSessionCode={}", ip, agent, os, browser, mSessionCode);
			
			if (resultVO == null || StringUtils.isBlank(resultVO.getId())) {
    			logger.debug("user does not exist :" + uid);
            	
				result = MLoginResult.ERROR_USER_NOTFOUND.getResult();
				break loginProcess;
			}

			resultVO.setForInsertLog(ip, agent, os, browser, tenantId, "N");
        		
    			// 로그인 후 IP 주소 체크
				boolean ipAddressChk = ipAccessCheck(resultVO);
				logger.debug("ipAddressChk=" + ipAddressChk);
				
				if (!ipAddressChk) {
	    			// 2021-12-29 이사라 : ip 주소 check 실패인 경우 접속실패 로그 저장
					loginService.insertLog(resultVO);
					
					result = MLoginResult.ERROR_IP_NOT_ALLOWED.getResult();
					break loginProcess;
				}
    			
			/**
			 * 모바일 G/W 로그인 : 1) pw/pin/bio 인증 + 유효한 사용자 확인
			 */
			verifyingUser : {
    			// 모바일 사용 설정 확인 
    			String useMobileManagemant = ezCommonService.getTenantConfig("useMobileManagemant", tenantId);
    			boolean pinLoginAuth = false;
    			
    			if (useMobileManagemant.equals("YES")) {
    				String notUseAllMobileLogin = ezCommonService.getUserConfigInfo(tenantId, uid, "notUseMobileLogin");
    				String adminOrderNotUsedMobileLogin = ezCommonService.getUserConfigInfo(tenantId, uid, "adminOrderNotUsedMobileLogin");
    				
    				notUseAllMobileLogin = notUseAllMobileLogin.equals("") ? "0" : notUseAllMobileLogin;
    				adminOrderNotUsedMobileLogin = adminOrderNotUsedMobileLogin.equals("") ? "0" : adminOrderNotUsedMobileLogin;
    				
    				if (notUseAllMobileLogin.equals("1")) {
						logger.debug("cannot use mobile login. userId=" + uid);

						// 2021-12-29 이사라 : 접속 실패 로그 저장 - 모바일 사용금지 설정 
						resultVO.setForInsertLog(ip, agent, os, browser, tenantId, "N");
						loginService.insertLog(resultVO);

						result = MLoginResult.ERROR_CANNOT_USE_MOBILE_LOGIN.getResult();
						break loginProcess;
					} else if (adminOrderNotUsedMobileLogin.equals("1")) {
							logger.debug("cannot use mobile login by admin. userId=" + uid);
							
							resultVO.setForInsertLog(ip, agent, os, browser, tenantId, "N");
							loginService.insertLog(resultVO);

							result = MLoginResult.ERROR_CANNOT_USE_MOBILE_LOGIN_BY_ADMIN.getResult();
							break loginProcess;
					} else {
    					String deviceId = StringUtils.defaultString(request.getParameter("deviceID"));
    					
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
    							
    							// 2021-12-29 이사라 : 접속 실패 로그 저장 - 접속한 디바이스 사용금지
    							resultVO.setForInsertLog(ip, agent, os, browser, tenantId, "N");
    	    					loginService.insertLog(resultVO);
    	    					
								result = MLoginResult.ERROR_CANNOT_USE_DEVICE.getResult();
								break loginProcess;

    						} else { 
    							// 0이지만 그전 사용자의 config 확인
    							String oldUserId = String.valueOf(resultObj.get("oldUserId"));
    							notUseAllMobileLogin = ezCommonService.getUserConfigInfo(tenantId, oldUserId, "notUseMobileLogin");
    							adminOrderNotUsedMobileLogin = ezCommonService.getUserConfigInfo(tenantId, oldUserId, "adminOrderNotUsedMobileLogin");
    		    				
    		    				notUseAllMobileLogin = notUseAllMobileLogin.equals("") ? "0" : notUseAllMobileLogin;
    		    				adminOrderNotUsedMobileLogin = adminOrderNotUsedMobileLogin.equals("") ? "0" : adminOrderNotUsedMobileLogin;
    						
    		    				if (notUseAllMobileLogin.equals("1")) {
    		    					logger.debug("cannot use mobile login. oldUserId=" + oldUserId);
    		    					
    		    					// 2021-12-29 이사라 : 접속 실패 로그 저장 - 모바일 사용설정 금지 oldUserId
    		    					resultVO.setForInsertLog(ip, agent, os, browser, tenantId, "N");
    		    					loginService.insertLog(resultVO);
    		    					
									result = MLoginResult.ERROR_CANNOT_USE_MOBILE_LOGIN.getResult();
									break loginProcess;
    		    				} else if (adminOrderNotUsedMobileLogin.equals("1")) {
									logger.debug("cannot use mobile login by admin. userId=" + uid);

									resultVO.setForInsertLog(ip, agent, os, browser, tenantId, "N");
									loginService.insertLog(resultVO);

									result = MLoginResult.ERROR_CANNOT_USE_MOBILE_LOGIN_BY_ADMIN.getResult();
									break loginProcess;
								}
    		    				
    		    				// 20210426 조진호 - pin login 처리 부분. 사용자가 입력한 pin과 DB에 저장된 pin 값이 일치하면
								// pinLoginAuth를 true로 전환
								String encryptPin = StringUtils.defaultString(request.getParameter("encryptPin"));
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
    				String deviceId = StringUtils.defaultString(request.getParameter("deviceID"));
					
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
						String encryptPin = StringUtils.defaultString(request.getParameter("encryptPin"));
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
		            	
						result = MLoginResult.ERROR_USER_NOTFOUND.getResult();
						break loginProcess;
					}
				}
    			if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
    				// 공유사서함 기능을 사용할 경우 공유사서함 계정으로의 로그인을 막는다.
    	    		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
    	    		
    	    		if (useSharedMailbox.equals("YES")) {
    	    			if (resultVO.getDeptID() != null && resultVO.getDeptID().startsWith("shared_mailbox_")) {
    	    				logger.debug("Cannot login with shared mailbox account.");
    	    				
							result = MLoginResult.ERROR_USER_NOTFOUND.getResult();
							break loginProcess;
    	    			}
    	    		}
    	    		
    	    		// 사용자정지 여부를 체크
    	        	String useLoginStop = ezCommonService.getTenantConfig("useLoginStop", tenantId);
    	        	
    	        	if (useLoginStop != null && useLoginStop.equals("YES")) {
    	        		int flag = checkStopUser(tenantId, resultVO.getId());
    	        		if(flag > 0) {
    	        			logger.debug("stopUser");
        					
        					// 2021-12-28 이사라 : 접속로그 실패 저장
        					resultVO.setForInsertLog(ip, agent, os, browser, tenantId, "N");
    						loginService.insertLog(resultVO);
    						
							result = MLoginResult.ERROR_STOPUSER.getResult();
							break loginProcess;
    	        		}
    	        	}
    				
    				int check = checkState(tenantId, uid, numberOfLoginFailPermit);
					boolean check1 = false;

					if (!loginLockedDate.equals("") && !loginLockedDate.equals("0")) {
						check1 = checkLockedDate(tenantId, uid, loginLockedDuration, loginLockedDate, formatedNow);

						if (check == -3 && check1) {
							check = 0;
						}
					}
                	
                	// 해당 사용자의 로그인이 블록되지 않은 경우
                	if (check != -3) {
						// diff 는 로그인 과정 3번째 순서로 미룸. 비밀번호 변경 권한을 갖기 위해서는 otp 인증까지 마쳐야하기 때문이다.
						logger.debug("{} User Login : verifyingUser success.", uid);
						break verifyingUser;
                	} else {
                		// 2021-12-29 이사라 : 접속로그 실패 저장
						resultVO.setForInsertLog(ip, agent, os, browser, tenantId, "N");
						
						loginService.insertLog(resultVO);
                		result.put("status", "error");
	        			result.put("code", "3"); // fail.mobile.common.login.block"
    					result.put("data", getErrorMsg(check, numberOfLoginFailPermit, uid, tenantId, locale, false, paramMap));
    					break loginProcess;
                	}
    			} else {
    				// 2021-12-29 이사라 : 접속 실패 로그정보 저장
					loginVO.setForSelectUser(uid, "NOPASSWORD", tenantId);
    	        	resultVO = loginService.selectUser(loginVO);
    	        	
					resultVO.setForInsertLog(ip, agent, os, browser, tenantId, "N");
    				loginService.insertLog(resultVO);
    				
    				//Check login state of the user 
    	        	int check = checkState(tenantId, uid, numberOfLoginFailPermit);

					boolean check1 = false;

					if (!loginLockedDate.equals("") && !loginLockedDate.equals("0")) {
						check1 = checkLockedDate(tenantId, uid, loginLockedDuration, loginLockedDate, formatedNow);

						if (check == -3 && check1) {
							check = 0;
						}
					}
					
					result.put("status", "error");
					result.put("code", "3");
					result.put("data", getErrorMsg(check, numberOfLoginFailPermit, uid, tenantId, locale, false, paramMap));
					
					break loginProcess;
    			}
			}

			/**
			 * 모바일 G/W 로그인 : 2) TFA 이중 인증 : OTP
			 */
			boolean useOTP = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useOTP", tenantId));
			verifyingOTP : if (useOTP && !nextTime) {
				if (!loginService.searchOtpKey(loginVO)) { // OTP Key 유무 확인 : hasOTP
					logger.debug("hasn't set OTP key.");
					result = MLoginResult.ERROR_HASNOT_SET_OTP.getResult();
					break loginProcess;
				}

				String otpKey = ezCommonService.getUserConfigInfo(tenantId, uid, "otpKey");
				if (StringUtils.isBlank(otpKey)) {
					logger.debug("has no valid OTP key.");
					result = MLoginResult.ERROR_NO_VALID_OTP.getResult();
					break loginProcess;
				}

				String encLoginOtp = StringUtils.defaultString(request.getParameter("loginOtp"));
				if (StringUtils.isBlank(encLoginOtp)) {
					// useOTP && hasOTP 이나, 값 받지 못한 상태 (code 11 -> mLoginOTP.jsp)
					result = MLoginResult.ERROR_GOTO_OTP.getResult();
					break loginProcess;
				}

				String otpCode = getTOTPCode(otpKey);
				String loginOtp = EgovFileScrty.decryptRsa(pk, encLoginOtp);
				logger.debug("OTP otpCode={}, loginOtp={}", otpCode, loginOtp);

				// 1. OTP 성공
				if (loginOtp.equals(otpCode)) {
					logger.debug("{} User Login : verifyingOTP success.", uid);
					break verifyingOTP;
				}

				// 2. OTP 인증을 실패 한 경우
				// 2021-12-28 이사라 : 접속로그 실패 저장
				resultVO.setForInsertLog(ip, agent, os, browser, tenantId, "N");
				loginService.insertLog(resultVO);

				// 로그인 실패 처리
				// Check login state of the user
				int check = checkState(tenantId, uid, numberOfLoginFailPermit);
				String errorMsg = getErrorMsg(check, numberOfLoginFailPermit, uid, tenantId, locale, true, paramMap);

				result.put("status", "error");
				result.put("code", "fail".equals(errorMsg)? "10" : "3");
				result.put("data", errorMsg);

				logger.debug("OTP authentication fail.");
				break loginProcess;
			}

			/**
			 * 모바일 G/W 로그인 : 3) 비밀번호 변경기한 체크 (diff < 0 -> mLoginChangePw.jsp)
			 */
			verifyingPWPeriod : if (!nextTime) {
				if (resultVO.getLoginCnt() == 0 && !isSLOSupport) { // SLO의 경우에는 First Login도 성공으로 처리한다.
					logger.debug("isFirstLogin");
					result = MLoginResult.ERROR_GOTO_CHANGEPW_FIRSTLOGIN.getResult();
					result.put("isFirstLogin", "Y");

				} else if (getDiff(resultVO, tenantId, companyId) <= 0) { //0보다 작아지면 패스워드 변경기한 Expired
					logger.debug("isExpireDate");
					result = MLoginResult.ERROR_GOTO_CHANGEPW_EXPIREDATE.getResult();
					result.put("isExpireDate", "Y");

				} else {
					logger.debug("{} User Login : verifyingPWPeriod success.", uid);
					break verifyingPWPeriod;
				}

				// 2021-12-28 이사라 : 접속로그 실패 저장
				resultVO.setForInsertLog(ip, agent, os, browser, tenantId, "N");
				loginService.insertLog(resultVO);

				String pwPolicyExplain = commonUtil.getPwPolicyExplain(companyId, tenantId, locale);
				result.put("pwPolicyExplain", pwPolicyExplain);

				result.put("userId", uid);
				result.put("companyId", companyId);
//				result.put("loginId", loginId);		// 비밀번호 변경 시 보여줄 id가 uid와 다른 경우 추가할 수 있음.
				break loginProcess;
			}

			/**
			 * 모바일 G/W 로그인 : 4) 로그인 성공 절차
			 */
			/* 2019-05-08 홍승비 - LoginCookieSSO를 사용하는지 값을 확인 */
			String useSSOCookie = ezCommonService.getTenantConfig("useLoginCookieSSO", tenantId);
			result.put("useLoginCookieSSO", useSSOCookie);

				// IP Address, 마지막 login시간 저장
				resultVO.setIp(ip);
				loginService.updateUser(resultVO);

				// 접속 로그정보 저장
				resultVO.setForInsertLog(ip, agent, os, browser, tenantId, "Y");
				resultVO.setSessionCode(mSessionCode);
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
						acceptLanguage = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
					}

					if (acceptLanguage != null) {
						returnValue = acceptLanguage.substring(0, 2);
					// 이유는 정확히 알 수 없지만 로그를 확인한 결과 윗 라인에서 acceptLanguage가 null인 경우가 발생하여 추가함.
					} else {
						returnValue = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
					}

					lang = commonUtil.getLangNumFromTwoLetterLang(returnValue, tenantId);

					// 브라우저 언어가 한국어/일본어가 아닐 경우 시스템 언어로 설정(영어/중국어 추후 지원)
					if (lang.equals("")) {
						lang = primaryLang;

						// useSecondaryLang 설정이 YES일 때는 PrimaryLang이 영어가 아닌 경우에도 기본적으로 엉어를 사용하는 환경을
						// 의미하므로 디폴트 언어 설정을 영어로 설정함.
						if ("YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useSecondaryLang", tenantId))) {
							lang = "2";
						}

						returnValue = commonUtil.getTwoLetterLangFromLangNum(lang);						
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
						acceptLanguage = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
					}

					String pcLang;

					if (acceptLanguage != null) {
						pcLang = acceptLanguage.substring(0, 2);
						// 이유는 정확히 알 수 없지만 로그를 확인한 결과 윗 라인에서 acceptLanguage가 null인 경우가 발생하여 추가함.
					} else {
						pcLang = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
					}

					pcLang = commonUtil.getLangNumFromTwoLetterLang(pcLang, tenantId);

					// 브라우저 언어가 한국어/일본어가 아닐 경우 시스템 언어로 설정(영어/중국어 추후 지원)
					if (pcLang.equals("")) {
						pcLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

						// useSecondaryLang 설정이 YES일 때는 PrimaryLang이 영어가 아닌 경우에도 기본적으로 엉어를 사용하는 환경을
						// 의미하므로 디폴트 언어 설정을 영어로 설정함.
						if ("YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useSecondaryLang", tenantId))) {
							pcLang = "2";
						}
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

				String useDbSession = config.getProperty("config.UseDbSession");

				Map<String, Object> map = new HashMap<String, Object>();
				map.put("uid", uid);
				map.put("ip", ip);
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
//				모바일에서 로그인 쿠키 생성 시 data > useOTP, hasOTP 를 사용하지 않아서 주석처리함. 필요하면 그때 셋팅하기로.
//				map.put("useOTP", useOTP);
//				map.put("hasOTP", hasOTP);
				map.put("useDbSession", useDbSession);

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

			} catch (Exception e) {
				logger.error(e.getMessage(), e);

				result = MLoginResult.ERROR_FAIL.getResult();
				break loginProcess;
			}
		}

	    logger.debug("result={}", result);
	    logger.debug("=========================================== G/W login ended. ============================================");
		return result;
	}

    /**
	 * @return errorMsg
	 * @description 로그인 실패 (ERROR_USER_NOTFOUND, code : 3) 시 에러 메세지 출력
	 */
	private String getErrorMsg(int check, int numberOfLoginFailPermit, String uid, int tenantId, Locale locale, boolean isOTP, Map<String, Object> map) throws Exception {
		logger.debug("login fail. getErrorMsg started. check={}", check);
		String errorMsg1 = "";
		String errorMsg2 = "";
		String errorMsg3 = "";
		
		String formatedNow = (String) map.get("formatedNow"); 
		String loginLockedDuration = (String) map.get("loginLockedDuration"); 
		String loginLockedDate = (String) map.get("loginLockedDate"); 

		switch (check) {
			case -3:
				//Show block message
				if(loginLockedDate.equals("")) {
					ezCommonService.insertUserConfigInfo(tenantId, uid, "LoginLockedDate", formatedNow);
				}
				return egovMessageSource.getMessageExtend("fail.mobile.common.login.block", new Object[] {numberOfLoginFailPermit, loginLockedDuration}, locale);
			case -2:
				//The first time this user login failed
				ezCommonService.insertUserConfigInfo(tenantId,  uid, "LoginFailCount", "1");
				//Show warning message
				/* 2018-05-24 홍승비 - 로그인 실패 시 레이어팝업을 위해 플래그 추가, 메세지 리소스 분리 */
				errorMsg1 = egovMessageSource.getMessage("fail.mobile.common.login" + (isOTP? "" : ".warning1"), locale);
				errorMsg1 += egovMessageSource.getMessage("fail.mobile.common.login.warning2", locale);
				errorMsg2 = egovMessageSource.getMessageExtend("fail.mobile.common.login.warning3", new Object[] {1}, locale);
				errorMsg3 = egovMessageSource.getMessage("fail.mobile.common.login.warning4", locale);
				errorMsg3 += "   " + egovMessageSource.getMessageExtend("fail.mobile.common.login.warning5", new Object[] {numberOfLoginFailPermit, loginLockedDuration}, locale);
				return errorMsg1 + errorMsg2 + errorMsg3;
			case -1:
				//Show normal login fail message
				return isOTP? "fail" : egovMessageSource.getMessage("fail.mobile.common.login", locale);
			default:
				//Increase number of attempts in database
				ezCommonService.updateUserConfigInfo(tenantId, uid, "LoginFailCount", Integer.toString(check + 1));

				if (check >= numberOfLoginFailPermit - 1) {
					//Show block message
					if(loginLockedDate.equals("")) {
						ezCommonService.insertUserConfigInfo(tenantId, uid, "LoginLockedDate", formatedNow);
					} else {
						ezCommonService.updateUserConfigInfo(tenantId, uid, "LoginLockedDate", formatedNow);
					}
					return egovMessageSource.getMessageExtend("fail.mobile.common.login.block", new Object[] {numberOfLoginFailPermit, loginLockedDuration}, locale);
				} else {
					//Show warning message
					errorMsg1 = isOTP? "" : egovMessageSource.getMessage("fail.mobile.common.login.warning1", locale);
					errorMsg1 += egovMessageSource.getMessage("fail.mobile.common.login.warning2", locale);
					errorMsg2 = egovMessageSource.getMessageExtend("fail.mobile.common.login.warning3", new Object[] {check + 1}, locale);
					errorMsg3 = egovMessageSource.getMessage("fail.mobile.common.login.warning4", locale);
					errorMsg3 += "   " + egovMessageSource.getMessageExtend("fail.mobile.common.login.warning5", new Object[] {numberOfLoginFailPermit, loginLockedDuration}, locale);
					return errorMsg1 + errorMsg2 + errorMsg3;
				}
		}
	}

	// 2023-03-31 이사라 : [TFA] OTP 번호 확인을 위해 호출
	public String getTOTPCode(String otpKey) {
		Base32 base32 = new Base32();
		byte[] bytes = base32.decode(otpKey);
		String hexKey = Hex.encodeHexString(bytes);

		return TOTP.getOTP(hexKey);
	}

	private int getDiff(LoginVO resultVO, int tenantId, String companyId) throws Exception {
		//비밀번호 변경 팝업 상태 값 초기화
		int diff = 1;

		String expirePassPeriod = ezCommonService.getCompanyConfig(tenantId, companyId, "ExpirePassPeriod");

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

		return diff;
	}
	
	@SuppressWarnings("unchecked")
	@GetMapping(value = "/mobile/ezUser/dbSession/tenantId/{tenantId}")
	public JSONObject setDbSession(@PathVariable int tenantId, @RequestHeader("mSessionId") String mSessionId,
			@RequestHeader("mEzSessionId") String mEzSessionId, @RequestHeader("mLoginCookie") String mLoginCookie)
			throws Exception {
		logger.debug("mobile setDbSession : mSessionId={}, mEzSessionId={}, mLoginCookie={}, tenantId={}", mSessionId,
				mEzSessionId, mLoginCookie, tenantId);

		JSONObject result = new JSONObject();

		SessionVO sessionVO = new SessionVO();
		sessionVO.setEzSessionId(mEzSessionId);
		sessionVO.setLoginCookie(mLoginCookie);
		sessionVO.setTenantId(tenantId);
		sessionVO.setType("useSessionMobile");

		HashMap<String, Object> map = new HashMap<>();
		map.put("mSessionId", mSessionId);
		map.put("mEzSessionId", mEzSessionId);
		map.put("tenantId", tenantId);

		try {
			// insert db session
			loginService.insertSession(sessionVO);

			// mEzSessionId 으로 sessionCode update
			loginService.updateDbSessionLog(map);

			result.put("status", "ok");
			return result;

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			return result;
		}
	}

	@SuppressWarnings("unchecked")
	@GetMapping(value = "/mobile/ezUser/fidoAuthentication/fidoSession/{fidoSessionId}", produces = "application/json;charset=utf-8")
	public JSONObject fidoAuthentication(HttpServletRequest request, @PathVariable String fidoSessionId, Locale locale) throws Exception {
		logger.debug("============= Fido Authenticate : {} =============", fidoSessionId);
		JSONObject result = new JSONObject();
      	String serverName = request.getHeader("x-user-host");
		int tenantId = loginService.getTenantId(serverName);
		

		try {
			FidoAuthenticationVO vo = loginService.getFidoSession(fidoSessionId);

			String fidoStatus = vo.getStatus();
			String createTime = vo.getCreatTime().split("\\.")[0];
			String ip = vo.getIp();
			int timeLimit = Integer.parseInt(ezCommonService.getTenantConfig("FidoTimeLimit", tenantId));

			if ("requesting".equalsIgnoreCase(fidoStatus)) { // requesting 밖에 값이 올 수 없음
				// 유효한 요청인지 확인
				ZonedDateTime utcNow = ZonedDateTime.now(ZoneOffset.UTC); // 현재 UTC 시간
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
				ZonedDateTime createTimePlusTimeLimit = ZonedDateTime.parse(createTime, formatter.withZone(ZoneOffset.UTC)).plus(timeLimit, ChronoUnit.MINUTES);

				if (!createTimePlusTimeLimit.isAfter(utcNow)) { // 만료 됨
					logger.debug("fidoAuthentication 만료된 시간 입니다.");
					fidoStatus = "expired";
				}

			} else { // requesting 이외의 값이 올 수 없으나 예외 처리 함
				ip = ""; // ip or time이 빈 값으로 넘어오면 데스트탑에서 다시 요청해달라고 toast를 띄우기 때문에 ip를 빈문자열로 처리
			}

			result.put("status", "ok");
			result.put("ip", ip);
			result.put("time", createTime);
			result.put("fidoStatus", fidoStatus);

			logger.debug("ip : {}, time : {}", ip, vo.getCreatTime());

			return result;

		} catch (Exception e) {
			logger.debug(e.getMessage(), e);
			result.put("status", "error");

			return result;
		}
	}

	@SuppressWarnings("unchecked")
	@GetMapping("/mobile/ezUser/fidoAuthentication/fidoSession/{fidoSessionId}/status/{fidoStatus}")
	public JSONObject setfidoAuthenticationStatus(@PathVariable String fidoSessionId, @PathVariable String fidoStatus) throws Exception {
		logger.debug("setfidoAuthenticationStatus  fidoSessionId:{}, fidoStatus:{}", fidoSessionId, fidoStatus); // fidoStatus : approved, rejected, failed

		JSONObject result = new JSONObject();

		try {
			FidoAuthenticationVO resultVO = loginService.getFidoSession(fidoSessionId);

			if ("requesting".equalsIgnoreCase(resultVO.getStatus())) {
				FidoAuthenticationVO vo = new FidoAuthenticationVO();
				vo.setFidoSessionId(fidoSessionId);
				vo.setStatus(fidoStatus);

				// fidoSessionId에 해당하는 status를 반영
				loginService.updateFidoStatus(vo); 
				// DB에 저장된 status를 리턴해주기 위해 resultVO에 set
				resultVO.setStatus(fidoStatus);
			}

			result.put("status", resultVO.getStatus());
			return result;

		} catch (Exception e) {
			logger.debug(e.getMessage(), e);
			result.put("status", "error");
			return result;
		}
	}

	// gson json 사용 시 유니코드 깨지는 현상이 발생되어 String으로 전달하는 코드 추가
	@PostMapping(value = "/mobile/ezUser/login/mEzSessionId/{mEzSessionId}")
	public String getLoginCookie(@PathVariable String mEzSessionId) throws Exception {
		return loginService.getSession(mEzSessionId).getLoginCookie();
	}

	@SuppressWarnings("unchecked")
	@GetMapping(value = "/mobile/ezUser/get/session/mEzSessionId/{mEzSessionId}")
	public JSONObject getSession(@PathVariable String mEzSessionId) throws Exception {
		logger.debug("getSession start mEzSessionId : {}", mEzSessionId);

		JSONObject result = new JSONObject();
		SessionVO vo = loginService.getSession(mEzSessionId);

		result.put("maxInactiveInterval", vo.getMaxInactiveInterval());
		result.put("timeDiff", vo.getTimeDiff());

		return result;
	}

	@PostMapping(value = "/mobile/ezUser/update/session/mEzSessionId/{mEzSessionId}")
	public void updateSession(@PathVariable String mEzSessionId, String mloginCookie) throws Exception {
		// MariaDB 클러스터 환경에서 Deadlock Exception이 발생할 수 있어
		// 업데이트 도중 오류가 발생해도 무조건 성공으로 처리한다.
		try {
			loginService.updateSession(mEzSessionId, mloginCookie);
		} catch (DataAccessException e) {
			logger.error("updateSession mEzSessionId : {}", mEzSessionId);
		} catch (Exception e) {
			logger.error("updateSession mEzSessionId : {}", mEzSessionId);
		}
	}

	@PostMapping(value = "/mobile/ezUser/delete/session/mEzSessionId/{mEzSessionId}")
	public void deleteSession(@PathVariable String mEzSessionId) throws Exception {
		loginService.deleteSession(mEzSessionId);
	}

	@PostMapping(value = "/mobile/ezUser/check/session")
	public String checkDBSession() throws Exception {
		return config.getProperty("config.UseDbSession");
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
      	
		// mEzSession 체크 부터
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
						acceptLanguage = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
					}
					
					if (acceptLanguage != null) {
						returnValue = acceptLanguage.substring(0, 2);
						//이유는 정확히 알 수 없지만 로그를 확인한 결과 윗 라인에서 acceptLanguage가 null인 경우가 발생하여 추가함.
					} else {				        
						returnValue = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
					}
					
					lang = commonUtil.getLangNumFromTwoLetterLang(returnValue, tenantId);
					
					//브라우저 언어가 한국어/일본어가 아닐 경우 시스템 언어로 설정(영어/중국어 추후 지원)
					if (lang.equals("")) {						
						lang = primaryLang;

						// useSecondaryLang 설정이 YES일 때는 PrimaryLang이 영어가 아닌 경우에도 기본적으로 엉어를 사용하는 환경을
						// 의미하므로 디폴트 언어 설정을 영어로 설정함.
						if ("YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useSecondaryLang", tenantId))) {
							lang = "2";
						}
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
    		String appVersion = "appVersion=" + (String) jsonObj.get("appVersion");
    		
    		String inputParams = devId + "&"+ devType + "&" + subType + "&" + userId + "&" + token +
    				"&" + badge + "&" + state + "&" + pushState + "&" + isLogin + "&" + startMenu + 
    				"&" + loginLock + "&" + isPasswordChange + "&" + extension1 + "&" + extension2 + 
    				"&" + tenantIdParmas + "&" + pin + "&" + pinState + "&" + biometric + "&" + appVersion;
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
    
	@RequestMapping(value="/mobile/ezUser/login/users/{userId:.+}/multilogin", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
	@RequestMapping(value = "/mobile/ezUser/login/users/{userId:.+}/valid", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
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

	/**
	 * 암호 정책 패턴 설명 문구 API
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezUser/login/companies/{companyId:.+}/getPwPolicyExplain", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPwPolicyExplain(@PathVariable String companyId, HttpServletRequest request, Locale locale) throws Exception {
		logger.debug("MOBILE G/W ORGAN [GET /mobile/ezUser/login/companies/{}/getPwPolicyExplain] started.", companyId);
		JSONObject resultJSON = new JSONObject();

		String serverName = request.getHeader("x-user-host");
		int tenantId = loginService.getTenantId(serverName);

		String pwPolicyExplain = commonUtil.getPwPolicyExplain(companyId, tenantId, locale);

		resultJSON.put("status", "ok");
		resultJSON.put("code", 0);
		resultJSON.put("data", pwPolicyExplain);

		logger.debug("MOBILE G/W ORGAN [GET /mobile/ezUser/login/companies/{}/getPwPolicyExplain] ended.", companyId);
		return resultJSON;
	}

	/**
	 * 암호 정책 확인 API
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezUser/login/companies/{companyId:.+}/checkPasswordPolicy", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject checkPasswordPolicy(@PathVariable String companyId, HttpServletRequest request, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W LOGIN [PUT /mobile/ezUser/login/companies/{}/checkPasswordPolicy] started.", companyId);
		JSONObject resultJSON = new JSONObject();

		process : {
			String password = jsonObject.get("password").toString();
			if (password == null) {
				resultJSON.put("status", "error");
				resultJSON.put("code", -1);
				resultJSON.put("data", "EMPTY PASSWORDS");
				break process;
			}

			String serverName = request.getHeader("x-user-host");
			int tenantId = loginService.getTenantId(serverName);
			String userId = jsonObject.get("userId").toString();

			PasswordCheckPolicyResult result = commonUtil.checkPwPolicy(password, companyId, tenantId, userId);

			resultJSON.put("status", result.getStatus());
			resultJSON.put("code", result.getCode());
			resultJSON.put("data", result.getMessage());
		}

		logger.debug("MOBILE G/W LOGIN [PUT /mobile/ezUser/login/companies/{}/checkPasswordPolicy] ended.", companyId);
		return resultJSON;
	}

	/**
	 * 암호 변경 API
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezUser/login/users/{userId:.+}/changePassword", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject changePassword(@PathVariable String userId, HttpServletRequest request, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W LOGIN [PUT /mobile/ezUser/login/users/{}/changePassword] started.", userId);

		JSONObject result = new JSONObject();
		String status = "ERROR";
		int code = -1;
		String data = "";

		process : {
			// 유효성 체크
			String oldPassword = jsonObject.get("oldPassword").toString();
			String newPassword = jsonObject.get("newPassword").toString();

			if ("".equals(oldPassword) || "".equals(newPassword)) {
				data = "EMPTY PASSWORDS";
				break process;
			}

			// 1. 주 수행 변수 oldPw, newPw
			String prm = egovFileScrty.getPrm();
			String pre = egovFileScrty.getPre();
			PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

			String decryptedOldPassword = EgovFileScrty.decryptRsa(pk, oldPassword);
			String decryptedNewPassword = EgovFileScrty.decryptRsa(pk, newPassword);

			// 2. 사용자 정보 : 로그인 정보 확인
			String serverName = request.getHeader("x-user-host");
			int tenantId = loginService.getTenantId(serverName);
			String _pwd = EgovFileScrty.encryptPassword(decryptedOldPassword, userId);

			LoginVO loginVO = new LoginVO();

			loginVO.setId(userId);
			loginVO.setPassword(_pwd);
			loginVO.setTenantId(tenantId);
			LoginVO resultVO = loginService.selectUser(loginVO);

			if (resultVO == null || resultVO.getId() == null || "".equals(resultVO.getId())) {
				data = "LOGINERROR";
				break process;
			}

			String companyID = resultVO.getCompanyID();
			logger.debug("loginVO : userId={}, tenantId={}, companyID={}", userId, tenantId, companyID);

			// 3. 암호 정책 확인 (프론트에서 체크했어도, API 이기 때문에 보안상 비밀번호 변경 수행 직전 한번 더 체크하여 에러낼 수 있도록 하였음.)
			PasswordCheckPolicyResult chkResult = commonUtil.checkPwPolicy(decryptedNewPassword, companyID, tenantId, userId);
			if (!chkResult.succeeded()) {
				status = chkResult.getStatus();
				code = chkResult.getCode();
				data = chkResult.getMessage();
				break process;
			}

			// 4. 비밀번호 변경 수행
			data = ezOrganAdminService.changePasswordWithEmailSystem(userId, tenantId, decryptedOldPassword, decryptedNewPassword);

			if (!"OK".equalsIgnoreCase(data)) {
				break process;
			}

			// 5. IP Address,  마지막 login시간 저장
			if (resultVO.getLoginCnt() == 0) {
				logger.debug("{}'s LoginCnt is {}, isFirstLogin.", userId, resultVO.getLoginCnt());

				String ip = (request.getHeader("ip")!= null)? request.getHeader("ip") : ClientUtil.getClientIP(request);
				loginVO.setIp(ip);
				loginService.updateUser(loginVO);
			}

			status = "OK";
			code = 0;
		}

		result.put("status", status);
		result.put("code", code);
		result.put("data", data);

		logger.debug("MOBILE G/W LOGIN [PUT /mobile/ezUser/login/users/{}/changePassword] ended. result={}", userId, result);
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

	private boolean checkLockedDate(int tenantID, String userId, String loginLockedDuration, String loginLockedDate, String nowDate) throws Exception {
		String diff = String.valueOf(commonUtil.getTimeDifference(loginLockedDate, nowDate));

		int remainTime = Integer.parseInt(loginLockedDuration) - Integer.parseInt(diff);

		try {
			if (!"0".equalsIgnoreCase(loginLockedDuration) && remainTime <= 0) {
				// 잠금 잔여 시간이 지난 이후 로그인 실패 카운터 초기화 및 시간 초기화 
				commonUtil.resetLoginFailAttempts(userId, tenantID);
				ezCommonService.updateUserConfigInfo(tenantID, userId, "LoginLockedDate", "0");
				return true;
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return false;
	}
    
}