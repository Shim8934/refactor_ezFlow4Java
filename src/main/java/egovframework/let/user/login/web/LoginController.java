package egovframework.let.user.login.web;

import java.net.URLEncoder;
import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.AccessIdVO;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
/**
 * 일반 로그인을 처리하는 컨트롤러 클래스
 * @author 공통서비스 개발팀 박지욱
 * @since 2009.03.06
 * @version 1.0
 * @see
 *  
 * <pre>
 * << 개정이력(Modification Information) >>
 * 
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2009.03.06  박지욱          최초 생성 
 *  2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성 
 *  
 *  </pre>
 */
@Controller
public class LoginController {

	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
	
    /** LoginService */
	@Resource(name = "loginService")
    private LoginService loginService;
	
	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;    
    
    @Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
    
    @Resource(name="EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;
        
    /** CRYPTO */
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
    
    @Autowired
    private EzEmailUserAdminService ezEmailUserAdminService;
    
    @Autowired
	private EzOrganAdminService ezOrganAdminService;
    
    @Autowired
    private LocaleResolver localeResolver;
        
	/**
	 * 로그인 화면으로 들어간다
	 * @param vo - 로그인후 이동할 URL이 담긴 LoginVO
	 * @return 로그인 페이지
	 * @exception Exception
	 */
    
    @RequestMapping(value="/user/login/login.do")
	public String loginView(HttpServletRequest request,	HttpServletResponse response, ModelMap model) throws Exception {
        String serverName = request.getServerName();
        int tenantId = loginService.getTenantId(serverName);
        
        logger.debug("serverName=" + serverName + ",tenantId=" + tenantId);
    	
        String ezOffice365Auth = ezCommonService.getTenantConfig("ezOffice365Auth", tenantId);
        
    	logger.debug("ezOffice365Auth=" + ezOffice365Auth);
    	
        if (ezOffice365Auth.equals("YES")) {        	
        	return "redirect:/ezPortal/portalMain.do";
//        	return "redirect:/ezNewPortal/newPortalMain.do";         	
        }
        
    	if (commonUtil.isLoginCookieExists(request, response)) {
        	return "redirect:/ezPortal/portalMain.do";
//        	return "redirect:/ezNewPortal/newPortalMain.do"; 
    	}
        	
    	String pbm = egovFileScrty.getPbm();
    	
    	//2018-11-05 유은정 - 포탈 개인화 관련 logo 추가
    	String logo = "";
    	
    	String companyId = null;
    	String logoUrl = "/rest/admin/ezPortal/logos/companies/" + companyId;
    	JSONObject logoResult = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), logoUrl, null, request, "get", null);
    	String logoStatus = logoResult.get("status").toString();
    	
    	if (logoStatus.equals("ok")) {
    		JSONArray logoList = (JSONArray) logoResult.get("data");
    		int logoListCount = logoList.size();
    		
    		for (int i = 0; i < logoListCount; i++) {
    			JSONObject logoJson = (JSONObject) logoList.get(i);
    			
    			if (logoJson.get("logoType").equals("L")) {
    				logo = logoJson.get("logoUrl").toString();
    				break;
    			}
    		}
    	}
    	
    	logger.debug("logoUrl : " + logo);
    	//유은정 끝
    	
		model.addAttribute("publicModulus", pbm);
		model.addAttribute("publicExponent", "10001");
		model.addAttribute("logoUrl", logo);
		CommonUtil.addXUACompatibleHeaderToResponse(request, response);
		
    	return "/user/login/login";
    
	}
    
    
    public void setLocaleResolver(LocaleResolver localeResolver) {
    	this.localeResolver = localeResolver;
    }
	
    /**
	 * 일반 로그인을 처리한다
	 * @param vo - 아이디, 비밀번호가 담긴 LoginVO
	 * @param request - 세션처리를 위한 HttpServletRequest
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
    @RequestMapping(value="/user/login/actionLogin.do")
    public String actionLogin(Locale locale, @ModelAttribute("loginVO") LoginVO loginVO, HttpSession session, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	logger.debug("=========================================== login ============================================");
    	
    	String chkADpass = "";
    	String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

		String _uid = EgovFileScrty.decryptRsa(pk, loginVO.getEncryptID());
		
		if (_uid == null || _uid.equals("")) {
		    logger.debug("invalid _uid=" + _uid);		    
		    return "";
		}
		
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        int tenantId = loginService.getTenantId(serverName);
        
        logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);
		
		String rpwd = EgovFileScrty.decryptRsa(pk, loginVO.getEncryptPass());
		String _pwd = EgovFileScrty.encryptPassword(rpwd, _uid);
		
		//Check if this user exists
		loginVO.setId(_uid);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");
		LoginVO resultVO = loginService.selectUser(loginVO);
		
		String deptId = resultVO.getDeptID();
		String companyId = resultVO.getCompanyID();
		
		String useMasteradminLogin = ezCommonService.getTenantConfig("useMasteradminLogin", tenantId);
		boolean masteradminLogin = false;
		String displayName1 = null;
		String useSession = null;
		
		// 사용자 ID & 사원번호 자체가 발견되지 않는 경우
		if (resultVO == null || resultVO.getId() == null || resultVO.getId().equals("")) {
        	model.addAttribute("message", egovMessageSource.getMessage("fail.common.login", locale));
        	return "forward:/user/login/login.do";
        // 사용자 ID 혹은 사원번호가 발견된 경우
		} else {
			
			resultVO.setIp(ClientUtil.getClientIP(request));
			resultVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
			resultVO.setOs(ClientUtil.getClientInfo(request, "os"));
			resultVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));
			resultVO.setTenantId(tenantId);
					
			// 로그인 후 IP 주소 체크
        	boolean ipAddressChk = ipAccessCheck(resultVO);
        	logger.debug("ipAddressChk=" + ipAddressChk);
        	
        	// 2018.10.22 이석화 추가 - useSession row 유무 확인
    		useSession = ezCommonService.getTenantConfig("useSession", tenantId);
        	
        	if (ipAddressChk == true) {
        		// 사용자 ID를 사용해 로그인하는 경우
    			if (_uid.equals(resultVO.getId())) {
    				
    				// useMasteradminLogin이 YES일 경우 masteradmin의 암호로 로그인 가능하도록 한다.
    				if (useMasteradminLogin.equals("YES")) {
    					displayName1 = resultVO.getDisplayName1();
    					_pwd = EgovFileScrty.encryptPassword(rpwd, "masteradmin");
    					
    					loginVO.setId("masteradmin");
    		        	loginVO.setPassword(_pwd);
    		            loginVO.setDn("PASSWORD");
    					
    		            resultVO = loginService.selectUser(loginVO);
    		            
    		            // masteradmin 암호가 맞는 경우
    		            if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
    		            	logger.debug("masteradmin password correct.");
    		            	masteradminLogin = true;
    		            }
    				}
    				
    				if (!masteradminLogin) {
    					//User uses his/her username to login
    					loginVO.setId(_uid);
    					_pwd = EgovFileScrty.encryptPassword(rpwd, _uid);
    		        	loginVO.setPassword(_pwd);
    		            loginVO.setDn("PASSWORD");
    		            
    		            if (!_uid.equalsIgnoreCase("MASTERADMIN")) {
    			            // AD를 사용하는 경우 AD의 암호화 비교한 값을 구한다.
    			            if (ezCommonService.getTenantConfig("USE_AD", tenantId).equalsIgnoreCase("YES")) {
    			            	// true 이면 그룹웨어 암호 변경
    			            	// false 이면 그냥 로그인 금지
    			            	chkADpass = loginService.chkADAndUpdatePassword(_uid, rpwd, tenantId);	            	
    			            	
    			            	if (chkADpass.equalsIgnoreCase("false")) {
    			            		// vo의 password에 null 값을 넣어서 selectUser에서 무조건 암호가 틀리게 한다.
    			            		loginVO.setPassword(null);	            		
    			            	}
    			            }
    		            }
    		            
    		            // 암호가 맞는 지 확인한다.
    		            resultVO = loginService.selectUser(loginVO);
    				}
    				
    	        // 사원번호를 사용해 로그인하는 경우
    			} else {
    				//Check if his/her tenant allows using employeeID to login				
    				String useEmpNumberLogin = ezCommonService.getTenantConfig("UseEmpNumberLogin", tenantId);
    				
    				// 사원번호를 사용한 로그인을 허용하는 경우
    				if (useEmpNumberLogin.equals("YES") && !resultVO.getId().equals("")) {
    					
    					String orgId = resultVO.getId();
    					
    					// useMasteradminLogin이 YES일 경우 masteradmin의 암호로 로그인 가능하도록 한다.
    					if (useMasteradminLogin.equals("YES")) {
    						displayName1 = resultVO.getDisplayName1();
    						_pwd = EgovFileScrty.encryptPassword(rpwd, "masteradmin");
    						
    						loginVO.setId("masteradmin");
    			        	loginVO.setPassword(_pwd);
    			            loginVO.setDn("PASSWORD");
    						
    			            resultVO = loginService.selectUser(loginVO);
    			            
    			            // masteradmin 암호가 맞는 경우
    			            if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
    			            	logger.debug("masteradmin password correct.");
    			            	masteradminLogin = true;
    			            }
    					}
    					
    					if (!masteradminLogin) {
    						// 실제 사용자 ID를 사용해 암호가 맞는 지 확인한다.
    						_uid = orgId;
    						_pwd = EgovFileScrty.encryptPassword(rpwd, _uid);
    			        	loginVO.setId(_uid);
    			        	loginVO.setPassword(_pwd);
    			            loginVO.setDn("PASSWORD");
    			            
    			            resultVO = loginService.selectUser(loginVO);
    					}
    					
    		         // 사원번호를 사용한 로그인을 허용하지 않는 경우
    				} else {
    					//This kind of login is not allowed in his/her tenant
    			        model.addAttribute("message", egovMessageSource.getMessage("fail.common.login", locale));
    			        return "forward:/user/login/login.do";
    				}
    			}
        	} else {
        		actionLogout(request, response, model);
        		return "cmm/error/accessBlock";
        	}
			
		}
		
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
		
		// 사용자가 입력한 암호가 맞는 경우
        if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
        	
        	// masteradmin의 암호로 로그인 가능하여 masteradmin 암호가 맞는 경우
        	// usermaster 테이블의 ip정보/loginCount는 업데이트하지 않고 접속 로그정보만 저장한다.
        	if (masteradminLogin) {
        		//접속 로그정보 저장
        		resultVO.setIp(ClientUtil.getClientIP(request));
    			resultVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
    			resultVO.setOs(ClientUtil.getClientInfo(request, "os"));
    			resultVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));
    			resultVO.setTenantId(tenantId);
				

				if (resultVO.getTitle2() == null) {
					resultVO.setTitle2("");
				}
				
				loginService.insertLog(resultVO);
        		
				//로그인 쿠기 생성
				createLoginCookie(_uid, rpwd, _pwd, tenantId, request, response, deptId, companyId);
				
	        	Cookie cookieName = new Cookie("userName", URLEncoder.encode(displayName1, "utf-8"));
	        	cookieName.setPath("/");
	        	response.addCookie(cookieName);
	        	
	        	// 2018-10-22 이석화 - 세션이 0이면 세션 사용안함
	        	if (!useSession.equals("")) {
	        		int sessionTime = Integer.parseInt(useSession);
	        		
	        		if (sessionTime != 0) {
	        			session = request.getSession(); 
	        			session.setMaxInactiveInterval(sessionTime * 60);	// 세션 유지 시간 설정
	        		}
	        	}
	        	return "redirect:/ezPortal/portalMain.do";
//	        	return "redirect:/ezNewPortal/newPortalMain.do";
        		
        	} else {
        		//Check login state of the user
            	int check = checkState(tenantId, _uid, numberOfLoginFailPermit);
            	
            	// 해당 사용자의 로그인이 블록되지 않은 경우
            	if (check != -3) {
    	        	//비밀번호 변경 팝업 상태 값 초기화
    	        	int diff = 1;
    	        	
    	        	if (resultVO.getLoginCnt() == 0) {
    	        		diff = 0;
    	        		model.addAttribute("isFirstLogin", "Y");
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
    	        		        	
    	        	// 로그인 실패 횟수를 제한하는 경우 
    	        	if (check != -1) {
    		        	// 성공적으로 로그인한 경우 지금까지의 로그인 실패 카운터를 초기화한다.
    		        	//Reset number of login fail attempts
    		        	commonUtil.resetLoginFailAttempts(_uid, tenantId);
    	        	}
    	        	
    	        	//패스워드 변경 이벤트 발생 여부
    	        	String changePassword = ezCommonService.getTenantConfig("changePassword", tenantId);
    	        	
    	        	if (changePassword != null && changePassword.equals("0")) {
    	        		diff = 1;
    	        	}
    	        	
    				//0보다 작아지면 패스워드 변경기한 Expired
    				if (diff <= 0) {				
    					model.addAttribute("isExpireDate", "Y");
    					model.addAttribute("userId", _uid);
    					
    		        	return "forward:/user/login/login.do";
    				} else {			
    					String ip = ClientUtil.getClientIP(request);		
    					loginVO.setIp(ip);
    					
    					//IP Address,  마지막 login시간 저장
    					loginService.updateUser(loginVO);
    					
    					//접속 로그정보 저장
    					resultVO.setIp(ip);
    					resultVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
    					resultVO.setOs(ClientUtil.getClientInfo(request, "os"));
    					resultVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));
    					resultVO.setTenantId(tenantId);
    	
    					if (resultVO.getTitle2() == null) {
    						resultVO.setTitle2("");
    					}
    					
    					loginService.insertLog(resultVO);
    	
    					createLoginCookie(_uid, rpwd, _pwd, tenantId, request, response, deptId, companyId);
    		        	
    		        	Cookie cookieName = new Cookie("userName", URLEncoder.encode(resultVO.getDisplayName1(), "utf-8"));
    		        	cookieName.setPath("/");
    		        	response.addCookie(cookieName);
    		        	
    		        	//세션 생성 - 일시적으로 주석처리 필요할때 사용
    		        	//session = request.getSession();
    		        	
    		        	// 2018-10-22 이석화 - 세션이 0이면 세션 사용안함
    		        	if (!useSession.equals("")) {
    		        		int sessionTime = Integer.parseInt(useSession);
    		        		
	    		        	if (sessionTime != 0) {
	    		        		//세션 생성 - 일시적으로 주석처리 필요할때 사용
		    		        	session = request.getSession();			// 세션 필요로 주석 해제
		    		        	session.setMaxInactiveInterval(sessionTime * 60);		// 세션의 유지 시간 설정
	    		        	}
    		        	}
    		        	return "redirect:/ezPortal/portalMain.do";
//    		        	return "redirect:/ezNewPortal/newPortalMain.do";
    		        	
    				}
    			// 해당 사용자의 로그인이 블록된 경우
                } else {
            		//User has been blocked
        			//Show block message
                	model.addAttribute("message", egovMessageSource.getMessageExtend("fail.common.login.block", new Object[] {numberOfLoginFailPermit}, locale));
                	return "forward:/user/login/login.do";
            	}
        	}
        	
        // 사용자가 입력한 암호가 맞지 않는 경우
        } else {     	
        	//Check login state of the user 
        	int check = checkState(tenantId, _uid, numberOfLoginFailPermit);
        	String errorMsg1 = "";
        	String errorMsg2 = "";
        	String errorMsg3 = "";
        	String errorMsg4 = "";
        	String errorMsg5 = "";
        	String errorMsg6 = "";

        	switch (check) {
				case -3: 
	    			//Show block message
	            	model.addAttribute("message", egovMessageSource.getMessageExtend("fail.common.login.block", new Object[] {numberOfLoginFailPermit}, locale));
	            	return "forward:/user/login/login.do";
    			case -2:
	        		//The first time this user login failed
	        		ezCommonService.insertUserConfigInfo(tenantId,  _uid, "LoginFailCount", "1");
	        		//Show warning message
	        		/* 2018-05-24 홍승비 - 로그인 실패 시 레이어팝업을 위해 플래그 추가, 메세지 리소스 분리 */
	        		errorMsg1 = egovMessageSource.getMessage("fail.common.login.warning1", locale);
	        		errorMsg2 = egovMessageSource.getMessage("fail.common.login.warning2", locale);
	        		errorMsg3 = egovMessageSource.getMessageExtend("fail.common.login.warning3", new Object[] {1}, locale);
	        		errorMsg4 = egovMessageSource.getMessage("fail.common.login.warning4", locale);
	        		errorMsg5 = egovMessageSource.getMessageExtend("fail.common.login.warning5", new Object[] {numberOfLoginFailPermit}, locale);
	        		errorMsg6 = egovMessageSource.getMessage("fail.common.login.warning6", locale);
	        		
	        		model.addAttribute("message1", errorMsg1);
	            	model.addAttribute("message2", errorMsg2);
	            	model.addAttribute("message3", errorMsg3);
	            	model.addAttribute("message4", errorMsg4);
	            	model.addAttribute("message5", errorMsg4);
	            	model.addAttribute("message6", errorMsg4);
	            	model.addAttribute("isWrongPass", "Y");
	            	
	            	return "forward:/user/login/login.do";
        		case -1:
        			//Show normal login fail message
                	model.addAttribute("message", egovMessageSource.getMessage("fail.common.login", locale));
                	return "forward:/user/login/login.do";            	
        		default:
        			//Increase number of attempts in database
        			ezCommonService.updateUserConfigInfo(tenantId, _uid, "LoginFailCount", Integer.toString(check + 1));
        			
        			if (check >= numberOfLoginFailPermit - 1) {
        				//Show block message
                    	model.addAttribute("message", egovMessageSource.getMessageExtend("fail.common.login.block", new Object[] {numberOfLoginFailPermit}, locale));
                    	return "forward:/user/login/login.do";
        			} else {
            			//Show warning message
        				errorMsg1 = egovMessageSource.getMessage("fail.common.login.warning1", locale);
    	        		errorMsg2 = egovMessageSource.getMessage("fail.common.login.warning2", locale);
    	        		errorMsg3 = egovMessageSource.getMessageExtend("fail.common.login.warning3", new Object[] {check + 1}, locale);
    	        		errorMsg4 = egovMessageSource.getMessage("fail.common.login.warning4", locale);
    	        		errorMsg5 = egovMessageSource.getMessageExtend("fail.common.login.warning5", new Object[] {numberOfLoginFailPermit}, locale);
    	        		errorMsg6 = egovMessageSource.getMessage("fail.common.login.warning6", locale);
    	        		
    	        		model.addAttribute("message1", errorMsg1);
    	            	model.addAttribute("message2", errorMsg2);
    	            	model.addAttribute("message3", errorMsg3);
    	            	model.addAttribute("message4", errorMsg4);
    	            	model.addAttribute("message5", errorMsg5);
    	            	model.addAttribute("message6", errorMsg6);
    	            	model.addAttribute("isWrongPass", "Y");
    	            	
    	            	return "forward:/user/login/login.do";
        			}
        	}
        } 
    }
    
    public boolean ipAccessCheck(LoginVO loginVO) throws Exception {
    	logger.debug("ipAccessCheck start");
    	
    	String useIPAccess = ezCommonService.getTenantConfig("useIPAccess", loginVO.getTenantId());
    	
    	if (useIPAccess == null || useIPAccess.equals("")) {
    		useIPAccess = "NO";
    	}
    	
    	if (useIPAccess.equals("NO")) {
    		logger.debug("ipAccessCheck ended");
    		return true;
    	} else { // useIPAccess 사용하면 IP, ID 체크
    		
    		String topID = loginVO.getCompanyID();
    		String deptID = loginVO.getDeptID();
    		//String topID = loginVO.getRollInfo().indexOf("c=1") != -1 ? "Top" : loginVO.getCompanyID();
    		String clientIP[] = loginVO.getIp().split("\\.");
        	List<AccessIdVO> accessIdList = ezSystemAdminService.getAllAccessList(loginVO.getPrimary(), loginVO.getTenantId(), topID);
        	List<AccessIdVO> accessDeptList = ezSystemAdminService.getAllAccessListDept(loginVO.getPrimary(), loginVO.getTenantId(), topID);
        	List<IPBandVO> ipBandList = ezSystemAdminService.getAllIPBand(loginVO.getTenantId());
    		
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
        	boolean returnValue = false;
        	String getAccess = "NO";
        	int checkCnt = 0;
        	if (!(ipBandList == null || ipBandList.size() == 0)) {
        		for (int i = 0; i < ipBandList.size(); i++) {
        			getAccess = ipBandList.get(i).getAccess();
        			
        			if (!getAccess.equals("NO")) {
        				String ipListIp[] = ipBandList.get(i).getIpAddress().split("\\."); // *(대역)이 있을 수도 있으니 하나하나 검사해야됨
            			for (int j = 0; j < clientIP.length; j++) {
            				if (ipListIp[j].equals(clientIP[j]) || ipListIp[j].equals("*")) {
            					checkCnt++;
            				}
            			}
            			
            			if (checkCnt == 4) {
            				returnValue = true;
            			}
            			checkCnt = 0;
        			}
        		}
        		
        	} else { // 대역이 등록 안돼있으면 무조건 false (useIPAccess컨피그 사용O -> id체크X -> 부서체크X -> 등록된 대역도 없으므로)
        		return false;
        	}
        	
        	logger.debug("ipAccessCheck ended");
        	return returnValue;
    	}
    }
    
    public void createLoginCookie(
    				String userId, String userPw, String encryptedUserPw, int tenantId, 
    				HttpServletRequest request, HttpServletResponse response, String deptID, String companyID
    				) throws Exception {
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String ipAddress = ClientUtil.getClientIP(request);
    	
		// DB에서 lang 값 가져옴
		String lang = ezCommonService.selectUserGetLang(userId, tenantId);				
		String acceptLanguage = request.getHeader("Accept-Language");
		String twoLetterLang = commonUtil.getTwoLetterLangFromLangNum(lang);
		
		// userLocalInfo 테이블에 정보가 없을 때 (첫 로그인)				
		if (twoLetterLang == null || twoLetterLang.equals("")) {
	        String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
	        logger.debug("primaryLang=" + primaryLang);					
			
	        //UsePrimaryLangOnly가 YES일 때는 무조건 PrimaryLang 언어로 설정한다.
	        if (config.getProperty("config.UsePrimaryLangOnly").equals("YES")) {
		        if (primaryLang.equals("1")) {
		        	acceptLanguage = "ko";
		        } else if (primaryLang.equals("3")) {
		        	acceptLanguage = "ja";
		        }
	        }
	        
		    if (acceptLanguage != null) {
		    	twoLetterLang = acceptLanguage.substring(0, 2);
		    // 이유는 정확히 알 수 없지만 로그를 확인한 결과 윗 라인에서 acceptLanguage가 null인 경우가 발생하여 추가함.
		    } else {				        
		    	twoLetterLang = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
		    }
			
		    lang = commonUtil.getLangNumFromTwoLetterLang(twoLetterLang);
		    
		    //브라우저 언어가 한국어/일본어가 아닐 경우 시스템 언어로 설정(영어/중국어 추후 지원)
		    if (lang.equals("")) {						
				lang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
			}
			
		    String primaryTimeZone = ezCommonService.getTenantConfig("PrimaryTimeZone", tenantId);
		    
		    if (primaryTimeZone.equals("")) {
		    	primaryTimeZone = "235|+09:00";
		    }
		    
			logger.debug("userID=" + userId + ",lang=" + lang + ",primaryTimeZone=" + primaryTimeZone);
			ezCommonService.insertTblUserLocalInfo(userId, primaryTimeZone, lang, tenantId);
		}
		
		String timeZone = ezCommonService.selectUserGetTimeZone(userId, tenantId);
		
		logger.debug("userId=" + userId + ",ipAddress=" + ipAddress + ",lang=" + lang + ",timeZone=" + timeZone + ",acceptLanguage=" + acceptLanguage);
		
		// CookieLocaleResolver에 DB에서 가져온 lang값을 set해줌
		Locale locale = new Locale(twoLetterLang);
		localeResolver.setLocale(request, response, locale);
		
		// 80 포트가 아닌 경우엔 포트 번호도 포함시킨다.
		if (serverPort != 80) {
		    serverName = serverName + ":" + serverPort;
		}
		
		// Cookie 생성
		String cInfo = serverName + "///" + userId + "///" + encryptedUserPw + "///" + ipAddress + "///" + userPw + "///" + locale + "///" + lang + "///" + timeZone + "///" + tenantId+ "///" + deptID + "///" + companyID;
		String loginCookie = egovFileScrty.encryptAES(cInfo);
		
    	Cookie cookieID = new Cookie("loginCookie", loginCookie);
    	cookieID.setPath("/");
    	response.addCookie(cookieID);
    	
    	// loginCookieSSO 라는 이름으로 쿠키를 추가로 생성할 것인지
    	String useSSOCookie = ezCommonService.getTenantConfig("useLoginCookieSSO", tenantId);
    	
    	if (!useSSOCookie.trim().isEmpty() && !"NO".equalsIgnoreCase(useSSOCookie)) {
    		Cookie ssoLoginCookie = new Cookie("loginCookieSSO", loginCookie);
    		ssoLoginCookie.setPath("/");
    		ssoLoginCookie.setDomain(useSSOCookie);
    		response.addCookie(ssoLoginCookie);
    	}
    }
    
    /**
	 * 로그아웃한다.
	 * @return String
	 * @exception ExceptionactionLogout
	 */
    @RequestMapping(value="/user/login/actionLogout.do")
	public String actionLogout(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String serverName = request.getServerName();
        int tenantId = loginService.getTenantId(serverName);
        
    	Cookie[] cookies = request.getCookies();
    	
    	if (cookies != null) {
    		for (Cookie cookie : cookies) {
    			if (cookie.getName().equals("loginCookieSSO")) {
    				String ssoDomain = ezCommonService.getTenantConfig("useLoginCookieSSO", tenantId);
    				cookie.setDomain(ssoDomain);
    			}
    			
    			if(!cookie.getName().equals("saveid") && !cookie.getName().matches("POPUP_.*")){
    				cookie.setMaxAge(0);
    				cookie.setPath("/");
    				response.addCookie(cookie);
    				// 2018.10.22 이석화 추가 - 세션 제거 
    				request.getSession().invalidate();
    			}
    	    }
    	}
    	
        String ezOffice365Auth = ezCommonService.getTenantConfig("ezOffice365Auth", tenantId);
        
    	logger.debug("actionLogout ezOffice365Auth=" + ezOffice365Auth);
    	
        if (ezOffice365Auth.equals("YES")) {       
			String redirectUri = request.getScheme()
					+ "://"
					+ request.getServerName()
					+ ("http".equals(request.getScheme())
							&& request.getServerPort() == 80
							|| "https".equals(request.getScheme())
							&& request.getServerPort() == 443 ? "" : ":"
							+ request.getServerPort());
        	
			logger.debug("actionLogout redirectUri=" + redirectUri);
			
        	return "redirect:https://login.microsoftonline.com/common/OAuth2/logout?post_logout_redirect_uri=" + redirectUri;         	
        }
        // 2018.10.22 이석화 추가 - 세션 제거 
       	request.getSession().invalidate();

       	return "redirect:/user/login/login.do"; 
    }
    
    @RequestMapping(value="/user/login/actionLogoutWithRedirectUri.do")
	public void actionLogoutWithRedirectUri(
					@RequestParam("redirectUri") String redirectUri,
					HttpServletRequest request,
					HttpServletResponse response
					) throws Exception {
    	logger.debug("redirectUri=" + redirectUri);
    	
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
    	
    	request.getSession().invalidate();
    	response.sendRedirect(redirectUri);
    }
    
    @RequestMapping(value = "/user/login/setPassword.do")
    public void setPassword(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse response) throws Exception{
    	userInfo = commonUtil.userInfo(loginCookie);

    	if (userInfo.getId().equals("masteradmin")) {
    		List<String> userIDList = loginService.getUserIDList();
    		
    		for (int k = 0; k < userIDList.size(); k++) {
    			logger.info("setPassword.do::userID = " + userIDList.get(k) + " :: Set Password Complete");
    			
    			String pwd = EgovFileScrty.encryptPassword(userIDList.get(k) + "1!", userIDList.get(k));
    			
    			loginService.updatePassword(userIDList.get(k), pwd);
    		}
    	}
    }
        
    @RequestMapping(value = "/user/login/changeExPassword.do", produces = "text/html; charset=utf-8")
	@ResponseBody
    public String changeExPassword(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
    	logger.debug("=========================================== changePassword ============================================");
    	
    	String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	String encUserId = request.getParameter("USERID");
    	String encPass = request.getParameter("OLDPASSWORD");
    	String encNewPass = request.getParameter("NEWPASSWORD");
    	
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

		String _uid = EgovFileScrty.decryptRsa(pk, encUserId);
		
		if (_uid == null || _uid.equals("")) {
		    logger.debug("invalid _uid=" + _uid);
		    
		    return "DECRYPTERROR";
		}
		
        String serverName = request.getServerName();        
        int tenantId = loginService.getTenantId(serverName);
		
		String rpwd = EgovFileScrty.decryptRsa(pk, encPass);
		String _pwd = EgovFileScrty.encryptPassword(rpwd, _uid);
		
		loginVO.setId(_uid);
		loginVO.setPassword(_pwd);
		loginVO.setTenantId(tenantId);
		
    	//로그인 정보 확인
        LoginVO resultVO = loginService.selectUser(loginVO);
        
        if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {        	
        	String epwd = EgovFileScrty.decryptRsa(pk, encNewPass);

        	//e-mail 연동
			String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
			String mailAddr = _uid + "@" + domain;
			//이메일 계정의 암호를 새 암호로 설정한다.
			int rc = ezEmailUserAdminService.checkAndUpdateUserPassword(mailAddr, rpwd, epwd);
			//checkAndUpdateUserPassword 성공
			if (rc == 0) {                                                  
			    try {
			        //로컬 시스템에서 해당 User의 암호를 변경한다.
			        ezOrganAdminService.setPassword(_uid, epwd, tenantId);
			        
			        String ip = ClientUtil.getClientIP(request);		
					loginVO.setIp(ip);
			        //IP Address,  마지막 login시간 저장
					loginService.updateUser(loginVO);
			        return "OK";
			    } catch (Exception e) {
			    	//Exception이 발생하면 취소 처리를 한다.
			        ezEmailUserAdminService.checkAndUpdateUserPassword(mailAddr, epwd, rpwd);			        
			        return "UPDATEERROR";
			    }                                       
			} else {
				return "MAILERROR";
			}        	
        } else {
        	return "LOGINERROR";
        }    	
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