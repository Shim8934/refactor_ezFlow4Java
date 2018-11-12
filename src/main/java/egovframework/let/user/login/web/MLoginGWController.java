package egovframework.let.user.login.web;

import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;


import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
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
        
    /** CRYPTO */
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
    
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
    
	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;   
	
    /** Logger */
    private static final Logger LOGGER = LoggerFactory.getLogger(MLoginGWController.class);
    
    @Autowired
    private EzEmailUtil ezEmailUtil;
    
    /**
	 * 모바일 G/W 사용자 [GET] 로그인
	 */
    @SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezUser/login/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")    
    public JSONObject login(@PathVariable String userId, HttpServletRequest request, Locale locale) throws Exception {
    	LOGGER.debug("=========================================== G/W login ============================================");
    	
    	JSONObject result = new JSONObject();
    	
    	try {
    		PrivateKey pk = EgovFileScrty.getPrivateKey(egovFileScrty.getPrm(), egovFileScrty.getPre());
    		
    		String uid = EgovFileScrty.decryptRsa(pk, userId);
    		
    		if (uid == null || uid.equals("")) {
    			LOGGER.debug("invalid uid=" + uid);
    			
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
    		
    		int numberOfLoginFailPermit = 0;
    		// 로그인 실패 최대 허용 횟수를 구한다.
			String maxAllowedCountOfLoginFail = ezCommonService.getTenantConfig("MaxAllowedCountOfLoginFail", tenantId);
					
			if (!maxAllowedCountOfLoginFail.equals("")) {
				try {
					numberOfLoginFailPermit = Integer.parseInt(maxAllowedCountOfLoginFail);
				} catch (NumberFormatException e) {
					e.printStackTrace();
				}
			}
			
    		if (resultVO == null || resultVO.getId() == null || resultVO.getId().equals("")) {
    			LOGGER.debug("user does not exist :" + uid);
            	
    			result.put("status", "error");
    			result.put("code", "3");			
    			result.put("data", "user does not exist");
    			
    			return result;
    		} else {
    			// 모바일 사용 설정 확인 
    			String useMobileManagemant = ezCommonService.getTenantConfig("useMobileManagemant", tenantId);
    			
    			if (useMobileManagemant.equals("YES")) {
    				String notUseAllMobileLogin = ezCommonService.getUserConfigInfo(tenantId, uid, "notUseMobileLogin");
    				String adminOrderNotUsedMobileLogin = ezCommonService.getUserConfigInfo(tenantId, uid, "adminOrderNotUsedMobileLogin");
    				
    				if (adminOrderNotUsedMobileLogin.equals("1") || notUseAllMobileLogin.equals("1")) {
    					LOGGER.debug("cannot use mobile login. userId=" + uid);
    					
    					result.put("status", "error");
    					result.put("code", "6");			
    					result.put("data", "cannot use mobile login.");
    					
    					return result;
    				} else {
    					String deviceId = request.getParameter("deviceID") == null ? "" : request.getParameter("deviceID");
    					
    					if (!deviceId.equals("")) {
    						String inputParams = "userId=" + uid + "&deviceId=" + deviceId;
    						LOGGER.debug("userId=" + uid + ",deviceId=" + deviceId);
    						
    						String requestURL = "/ezTalkGate/getUserMobileDeviceInfo";
    						String getResult = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + requestURL, inputParams);
    						LOGGER.debug("getResult=" + getResult);
    						
    						JSONParser parser = new JSONParser();
    						JSONObject resultObj = (JSONObject) parser.parse(getResult);
    						
    						if (resultObj.get("data").equals("1")) {
    							LOGGER.debug("this device cannot use. userId=" + uid);
    							
    							result.put("status", "error");
    							result.put("code", "6");			
    							result.put("data", "this device cannot use.");
    							
    							return result;
    						}
    					}
    				}
    			}
    			
    			// 사용자 ID를 사용해 로그인하는 경우
    			if (uid.equals(resultVO.getId())) {
    				loginVO.setId(uid);
					pwd = EgovFileScrty.encryptPassword(rpwd, uid);
		        	loginVO.setPassword(pwd);
		            loginVO.setDn("PASSWORD");
		            
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
						LOGGER.debug("user does not exist :" + uid);
		            	
		    			result.put("status", "error");
		    			result.put("code", "3");			
		    			result.put("data", "user does not exist");
		    			
		    			return result;
					}
				}
    			if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {

    				int check = checkState(tenantId, uid, numberOfLoginFailPermit);
                	
                	// 해당 사용자의 로그인이 블록되지 않은 경우
                	if (check != -3) {
                		//비밀번호 변경 팝업 상태 값 초기화
        				int diff = 1;
        				
        				if (resultVO.getLoginCnt() == 0) {
        					LOGGER.debug("isFirstLogin");
        					
        					result.put("status", "error");
        					result.put("code", "4");			
        					result.put("data", "isFirstLogin");
        					
        					return result;
        				} else {
        					String expirePassPeriod = ezCommonService.getTenantConfig("ExpirePassPeriod", tenantId);        	
        					
        					if (!expirePassPeriod.trim().equals("0")) {
        						int realPeriod = Integer.parseInt("-" + expirePassPeriod.trim());
        						
        						Calendar cal = Calendar.getInstance();
        						SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        						
        						String baseStr = commonUtil.getTodayUTCTime("");        	
        						Date baseDT = date.parse(baseStr);
        						
        						cal.setTime(baseDT);
        						cal.add(Calendar.DATE, realPeriod);
        						
        						baseDT = cal.getTime();
        						Date lastDT = resultVO.getUpdateDT();
        						//오늘 기준 6개월전 날짜, 마지막 개인정보 수정일자 간 뺄셈
        						diff = EgovDateUtil.getDaysDiff(baseDT, lastDT);	    			
        					}	        	
        				}        	        	
        				//0보다 작아지면 패스워드 변경기한 Expired
        				if (diff <= 0) {
        					LOGGER.debug("isExpireDate");
        					
        					result.put("status", "error");
        					result.put("code", "5");			
        					result.put("data", "isExpireDate");
        					
        					return result;    	        	
        				} else {			
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
        					
        					//접속 로그정보 저장
        					resultVO.setIp(mIp);
        					resultVO.setAgent(mAgent);
        					resultVO.setOs(mOs);
        					resultVO.setBrowser(mBrowser);
        					resultVO.setTenantId(tenantId);
        					
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
        					
        					/* 2018-01-08 장진혁 - 모바일에서 메일만 사용할 경우 YES or NO */
        					String useMobileMailOnly = ezCommonService.getTenantConfig("useMobileMailOnly", tenantId);
        					/* 2018-11-02 배현상 - 공유결재문서 사용 유무 YES or NO */
        					String useShareApproval = ezCommonService.getTenantConfig("useShareApproval", tenantId);
        					
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
        					
        					return result;
        				}
                	} else {
                		result.put("status", "error");
	        			result.put("code", "3");
    					result.put("data", egovMessageSource.getMessageExtend("fail.mobile.common.login.block", new Object[] {numberOfLoginFailPermit}, locale));
    					return result;
                	}
    			} else {
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
    	LOGGER.debug("updateLoginDeviceInfo started.");
    	
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
    		
    		String inputParams = devId + "&"+ devType + "&" + subType + "&" + userId + "&" + token +
    				"&" + badge + "&" + state + "&" + pushState + "&" + isLogin + "&" + startMenu + 
    				"&" + loginLock + "&" + isPasswordChange + "&" + extension1 + "&" + extension2 + 
    				"&" + tenantIdParmas;
    		LOGGER.debug("inputParams=" + inputParams);
    		
    		String requestURL = "/ezTalkGate/updateLoginDeviceInfo";
    		
    		responseObj = ezEmailUtil.getWebServiceResult(
    							config.getProperty("config.JGwServerURL") + requestURL, inputParams);
    		LOGGER.debug("responseObj=" + responseObj);
    		
    		JSONObject resultObj = (JSONObject) jsonParser.parse(responseObj);
    		resultCnt = Integer.valueOf(String.valueOf(resultObj.get("resultCnt")));
			LOGGER.debug("resultCnt=" + resultCnt);
			
			if (resultCnt > 0 && resultObj.get("resultCode").equals("OK")) {
				result.put("status", "ok");
				result.put("code", "0");
				result.put("data", resultCnt);

				LOGGER.debug("device info updated ok.");
			} else {
				result.put("status", "error");
				result.put("code", "1");
				result.put("data", "device info update fail");

				LOGGER.debug("device info update fail devId=" + devId);
			}
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "-1");
			result.put("data", "fail");
			
			e.printStackTrace();
		}
    	
    	LOGGER.debug("updateLoginDeviceInfo ended.");

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
        		e.printStackTrace();
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
    
}