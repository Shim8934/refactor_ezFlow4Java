package egovframework.let.user.login.web;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.PrivateKey;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Random;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import net.shibboleth.utilities.java.support.xml.BasicParserPool;
import org.apache.commons.codec.binary.Base32;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.opensaml.core.xml.XMLObject;
import org.opensaml.core.xml.config.XMLObjectProviderRegistrySupport;
import org.opensaml.core.xml.io.Unmarshaller;
import org.opensaml.saml.saml2.core.NameID;
import org.opensaml.saml.saml2.core.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.WebUtils;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

import de.taimos.totp.TOTP;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.service.EzCommonService.Device;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.AccessIdVO;
import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.FidoAuthenticationVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.SessionVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.CommonUtil.PasswordCheckPolicyResult;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import org.w3c.dom.Element;

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

    @Autowired
	private EzEmailService ezEmailService;
        
    /** CRYPTO */
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;

	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
    
    @Autowired
    private EzEmailUserAdminService ezEmailUserAdminService;
    
    @Autowired
	private EzOrganAdminService ezOrganAdminService;
    
    @Autowired
    private LocaleResolver localeResolver;
    
    @Autowired
    private EzNewPortalService ezNewPortalService;
    
	/**
	 * 로그인 화면으로 들어간다
	 * @param vo - 로그인후 이동할 URL이 담긴 LoginVO
	 * @return 로그인 페이지
	 * @exception Exception
	 */
    
    @RequestMapping(value="/user/login/login.do", method={RequestMethod.GET, RequestMethod.POST})
	public String loginView(HttpServletRequest request,	HttpServletResponse response, ModelMap model, Locale locale, @RequestParam(required = false) String usefidoforce) throws Exception {
        String serverName = request.getServerName();
        int tenantId = loginService.getTenantId(serverName);
        // 2023-03-27 이사라 : [TFA] 2-factor 인증 사용 여부 체크하여, otp입력란 표출 여부 결정
        boolean useOTP = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useOTP", tenantId));
		model.addAttribute("useOTP", useOTP);
        
        logger.debug("serverName=" + serverName + ",tenantId=" + tenantId + ",useOTP=" + useOTP);
    	String mobileRedirection = ezCommonService.getTenantConfig("mobileRedirection", tenantId);
    	String userOs = ClientUtil.getClientInfo(request, "os");
    	
    	if (userOs.equals("iOS") || userOs.equals("Android") || userOs.equals("BlackBerry") || userOs.equals("iPod")) {
    		logger.debug("mobileRedirection : " + mobileRedirection);
    		if (!mobileRedirection.equals("") && !mobileRedirection.equals("*")) {
    			response.sendRedirect(mobileRedirection);
    			return null;
    		}
    	}
    	
        String ezOffice365Auth = ezCommonService.getTenantConfig("ezOffice365Auth", tenantId);
        
    	logger.debug("ezOffice365Auth=" + ezOffice365Auth);
    	
        if (ezOffice365Auth.equals("YES")) {        	
//        	return "redirect:/ezPortal/portalMain.do";
        	return "redirect:/ezNewPortal/newPortalMain.do";         	
        }
        
    	if (commonUtil.isLoginCookieExists(request, response)) {
//        	return "redirect:/ezPortal/portalMain.do";
        	return "redirect:/ezNewPortal/newPortalMain.do"; 
    	}
    	
    	if(model.get("multiLoginFlag") != null || request.getParameter("multiLoginFlag") != null) {
    		model.addAttribute("message", "multiLoginNoti");
    		
    		if(model.get("multiLoginFlag") == null) {
    			Cookie tempMLCookie = new Cookie("multiLoginCookie", null);
        		tempMLCookie.setMaxAge(0);
        		tempMLCookie.setPath("/");
        		response.addCookie(tempMLCookie);
    		}
    	}

		if(StringUtils.isNotEmpty(request.getParameter("loginSessionFlag"))){
			model.addAttribute("message", "loginSessionFlag");
		}

		if(StringUtils.isNotEmpty(request.getParameter("organInfoChangedFlag"))){
			model.addAttribute("message", "organInfoChangedFlag");
		}
    	
    	String pbm = egovFileScrty.getPbm();
    	
    	//2018-11-05 유은정 - 포탈 개인화 관련 logo 추가
    	String logo = null;
		String banner = null;
    	
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
    			}
				if (logoJson.get("logoType").equals("B")) {
					banner = logoJson.get("logoUrl").toString();
				}

				if (logo != null && banner != null) {
					break;
				}
    		}
    	}
    	
    	logger.debug("logoUrl : " + logo);
    	//유은정 끝
    	
    	String usePasswordReset = ezCommonService.getTenantConfig("usePasswordReset", tenantId);
    	
		// fido test
		model.addAttribute("usefidoforce", "false");

		if (StringUtils.isNotBlank(usefidoforce)) {
			model.addAttribute("usefidoforce", "true");
		}

		model.addAttribute("publicModulus", pbm);
		model.addAttribute("publicExponent", "10001");
		model.addAttribute("logoUrl", logo);
		model.addAttribute("banner", banner);
		model.addAttribute("usePasswordReset", usePasswordReset);
		CommonUtil.addXUACompatibleHeaderToResponse(request, response);
		response.setHeader("Cache-Control", "no-store");
		response.setHeader("Pragma", "no-cache");

		/* 비회원 읽기 게시판 start */
		String guestPermitYN = ezCommonService.getTenantConfig("useBoardGuestPermit", tenantId);
		String showGuestBoardYN = ezCommonService.getTenantConfig("showGuestBoardListOnLogin", tenantId);
		if ("YES".equals(guestPermitYN) && "YES".equals(showGuestBoardYN)) {
			String guestBoardID = ezCommonService.getTenantConfig("guestBoardId", tenantId);
			// 비회원 권한이 있는 게시판인 경우에만 리스트를 가져옴
			if (guestBoardID != null && !guestBoardID.isEmpty() && ezBoardService.checkGuestPerm(guestBoardID, tenantId, "B")) {
				BoardPropertyVO boardInfo = ezBoardService.getBoardProperty(guestBoardID, tenantId);

				String guestOffset = ezCommonService.getTenantConfig("guestOffset", tenantId);
				int offset = Integer.parseInt(((commonUtil.getMinuteUTC(guestOffset)).trim()));

				List<BoardListVO> boardList = ezBoardService.getGuestBoardList(guestBoardID, tenantId, offset);
				for (BoardListVO bVO : boardList) {
					bVO.setTitle(commonUtil.cleanValue(bVO.getTitle()));
				}

				String pastDate = commonUtil.getTodayUTCTime("");
				pastDate = EgovDateUtil.addDay(pastDate, -1, "yyyy-MM-dd HH:mm:ss");
				pastDate = EgovDateUtil.addYMDtoDayTime(pastDate.substring(0, 10), pastDate.substring(11, 16), 0, 0, 0, 0, offset, "yyyy-MM-dd HH:mm:");
				pastDate = pastDate.concat(commonUtil.getTodayUTCTime("").substring(17, 19));

				model.addAttribute("gBoardList", boardList);
				model.addAttribute("boardInfo", boardInfo);
				model.addAttribute("pastDate", pastDate);
			}
		}
		model.addAttribute("guestPermitYN", guestPermitYN);
		model.addAttribute("showGuestBoardYN", showGuestBoardYN);
		/* 비회원 읽기 게시판 end */
		
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
    @RequestMapping(value="/user/login/actionLogin.do", method=RequestMethod.POST)
    public String actionLogin(Locale locale, @ModelAttribute("loginVO") LoginVO loginVO, HttpSession session, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	logger.debug("=========================================== login ============================================");
    	
    	String chkADpass = "";
    	String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
		String formatedNow = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

		String _uid = EgovFileScrty.decryptRsa(pk, loginVO.getEncryptID());
		if (_uid == null || _uid.equals("")) {
		    logger.debug("invalid _uid=" + _uid);		    
		    return "";
		}
		
		String loginId = _uid;
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        int tenantId = loginService.getTenantId(serverName);
        
        logger.debug("_uid=" + _uid + ",serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);
		
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

		// 2023-03-22 이사라 : [TFA] 2-factor 인증 사용 체크
		String loginOtp = "";
		boolean useOTP = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useOTP", tenantId));
		boolean hasOTP = false;
		boolean isRightOTP = true;
		
		// 비밀번호 '다음에 변경하기'는 이미 로그인 정보(OTP포함) 인증을 마친 상태에서 나타나기 때문에
		// useOTP를 false로 하여 Id와 password로 로그인 되도록 함
		String passwordUpdateNextTime = request.getParameter("nextTime") != null ? request.getParameter("nextTime") : "";
		useOTP = "YES".equalsIgnoreCase(passwordUpdateNextTime) ? false : useOTP;

		if (useOTP) {
			loginOtp = StringUtils.defaultString(EgovFileScrty.decryptRsa(pk, loginVO.getEncryptOTP()));
			loginVO.setOtp(loginOtp);
			logger.debug("OTP use checked. loginOtp={}", loginOtp);
			// OTP를 등록한 사용자인지 체크
			hasOTP = loginService.searchOtpKey(loginVO);
		}

		// 2023-11-21 이사라 : [TFA] FIDO 인증
		//boolean useFido = "YES".equalsIgnoreCase(ezCommonService.getCompanyConfig(tenantId, companyId, "useFidoSession"));
		boolean useFido = false;
		boolean isFidoAuth = StringUtils.isNotBlank(loginVO.getFidoSessionId()); // fido인증을 완료한 후 로그인 진행하는 경우를 구분하기 위함
		boolean passedFidoAuthentication =  false;
		boolean userDeviceChk = loginService.userDeviceCnt(loginVO.getId());

		if (isFidoAuth) {
			FidoAuthenticationVO fidoVo = loginService.getFidoSession(loginVO.getFidoSessionId());
			passedFidoAuthentication = loginVO.getId().equals(fidoVo.getId()); // 대소문자까지 일치
		}

		logger.debug("passedFidoAuthentication : {}", passedFidoAuthentication);

		// 사용자 ID & 사원번호 자체가 발견되지 않는 경우
		if (resultVO == null || resultVO.getId() == null || resultVO.getId().equals("")) {
			logger.debug("_uid is not found.");
					
        	model.addAttribute("message", egovMessageSource.getMessage("fail.common.login", locale));
        	return "forward:/user/login/login.do";
		}

        // 사용자 ID 혹은 사원번호가 발견된 경우
		// OTP Key 유무 확인
		if (useOTP && hasOTP) {
			String otpKey = ezCommonService.getUserConfigInfo(tenantId, _uid, "otpKey");
			String otpCode = "";

			if (StringUtils.isNotBlank(otpKey)) {
				logger.debug("has OTP checked.");
				otpCode = getTOTPCode(otpKey);
				isRightOTP = loginVO.getOtp().equals(otpCode) ? true : false;

				logger.debug("OTP correct code={}, submmited code={}, isRightOTP={}", otpCode, loginVO.getOtp(), isRightOTP);
			} else {
				// otp 키가 null인 경우 예외 처리
				logger.debug("has no valid OTP key.");
				hasOTP = false;
				model.addAttribute("message", "setflagTFA:" + _uid);
				return "forward:/user/login/login.do";
			}
		// OTP 초기화한 사용자는 설정화면을 제공, masteradmin 계정은 OTP 인증을 제외 함
		} else if (useOTP && !hasOTP && resultVO.getLoginCnt() > 0 && !resultVO.getId().equalsIgnoreCase("masteradmin")) {
			logger.debug("hasn't set OTP key.");
			model.addAttribute("message", "setflagTFA:" + _uid);
			return "forward:/user/login/login.do";
		}

		// 로그인 후 IP 주소 체크
		resultVO.setIp(ClientUtil.getClientIP(request));
		resultVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
		resultVO.setOs(ClientUtil.getClientInfo(request, "os"));
		resultVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));
		resultVO.setTenantId(tenantId);
		boolean ipAddressChk = ipAccessCheck(resultVO);
		logger.debug("ipAddressChk : {}", ipAddressChk);

		if (!ipAddressChk) {
			actionLogout(request, response, model);

			// 2021-12-29 이사라 : ip 주소 check 실패인 경우 접속실패 로그 저장
			resultVO.setStatus("N");

			if (resultVO.getTitle2() == null) {
				resultVO.setTitle2("");
			}

			loginService.insertLog(resultVO);

			return "cmm/error/accessBlock";
		}

		// 사원번호를 사용한 로그인을 허용하지 않는 경우
		if (!_uid.equals(resultVO.getId())) {
			_uid = resultVO.getId(); // orgId

			if (!"YES".equalsIgnoreCase(ezCommonService.getTenantConfig("UseEmpNumberLogin", tenantId))) {
				//This kind of login is not allowed in his/her tenant
				model.addAttribute("message", egovMessageSource.getMessage("fail.common.login", locale));
				return "forward:/user/login/login.do";
			}
		}

		useFido = fidoNotAccessIpCheck(resultVO);
		if (!useFido && "usefidoforce".equalsIgnoreCase(loginVO.getPassword())) { // fido test를 위한 코드 - useFido가 이미 true라면 if문을 굳이 실행할 이유가 없기때문에 !useFido로 한정 함
			useFido = true;
		}
		logger.debug("useFido : {}", useFido);

		// useMasteradminLogin이 YES일 경우 masteradmin의 암호로 로그인 가능하도록 한다.
		if ("YES".equalsIgnoreCase(useMasteradminLogin)) {
			_pwd = EgovFileScrty.encryptPassword(rpwd, "masteradmin");
			loginVO.setId("masteradmin");
			loginVO.setPassword(_pwd);
			loginVO.setDn("PASSWORD");

			resultVO = loginService.selectUser(loginVO);

			// masteradmin 암호가 맞는 경우
			if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
				logger.debug("masteradmin password correct.");
				masteradminLogin = true;
				isRightOTP = true; // OTP 체크 없이 로그인 가능하도록 함
			}
		}

		// 사용자의 암호가 맞는 지 확인한다.
		if (!masteradminLogin) {
			// 2023-03-22 이사라 : [TFA] 사용자 ID or 사원번호가 발견되었으나 첫번째 로그인 혹은 초기화된 사용자가 아닌데 OTP를 입력하지 않은 경우
			if (useOTP && "".equals(loginOtp) && (resultVO.getLoginCnt() > 0 || hasOTP)) {
				logger.debug("It isn't the first login and otpKey hasn't been reset either, but otp is not submitted.");
				model.addAttribute("message", "emptyOtp");

				return "forward:/user/login/login.do";
			}

			loginVO.setId(_uid);
			loginVO.setDn("PASSWORD");
			_pwd = EgovFileScrty.encryptPassword(rpwd, _uid);
			loginVO.setPassword(_pwd);
			
			if (!"MASTERADMIN".equalsIgnoreCase(_uid)) { // 기존 코드> '사원번호 로그인' 시에는 해당 조건문이 없었음. 단순 누락인건지?
				// AD를 사용하는 경우 AD의 암호화 비교한 값을 구한다.
				if ("YES".equalsIgnoreCase(ezCommonService.getTenantConfig("USE_AD", tenantId))) {
					// true 이면 그룹웨어 암호 변경
					// false 이면 그냥 로그인 금지
					chkADpass = loginService.chkADAndUpdatePassword(_uid, rpwd, tenantId);
					
					if ("false".equalsIgnoreCase(chkADpass)) {
						// vo의 password에 null 값을 넣어서 selectUser에서 무조건 암호가 틀리게 한다.
						loginVO.setPassword(null);
					}
				}
			}

			resultVO = loginService.selectUser(loginVO);
		}
		
		int numberOfLoginFailPermit = 0;
		
		// 로그인 실패 최대 허용 횟수를 구한다.
		String maxAllowedCountOfLoginFail = ezCommonService.getCompanyConfig(tenantId, companyId, "MaxAllowedCountOfLoginFail");
		String loginLockedDuration = ezCommonService.getCompanyConfig(tenantId, companyId, "LoginLockedDuration");
		String loginLockedDate = ezCommonService.getUserConfigInfo(tenantId, _uid, "LoginLockedDate");
		logger.debug("companyId : {}, maxAllowedCountOfLoginFail : {}, loginLockedDuration : {}, loginLockedDate : {}", companyId, maxAllowedCountOfLoginFail, loginLockedDuration, loginLockedDate);
		// String maxAllowedCountOfLoginFail = ezCommonService.getTenantConfig("MaxAllowedCountOfLoginFail", tenantId);
				
		if (!maxAllowedCountOfLoginFail.equals("")) {
			try {
				numberOfLoginFailPermit = Integer.parseInt(maxAllowedCountOfLoginFail);
				// 암호 오류 최대 횟수를 기존에 사용하고 있는 경우 계정 잠금 처리 config를 추가
				if (loginLockedDuration.equals("")){
					ezCommonService.insertCompanyConfig(tenantId, companyId, "LoginLockedDuration", "5");
					loginLockedDuration = ezCommonService.getCompanyConfig(tenantId, companyId, "LoginLockedDuration");
				}
			} catch (NumberFormatException e) {
				logger.error(e.getMessage(), e);
			}
		}
		
		// 사용자가 입력한 암호가 맞는 경우
        if (isRightOTP && resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
        	// 공유사서함 기능을 사용할 경우 공유사서함 계정으로의 로그인을 막는다.
    		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
    		
    		if (useSharedMailbox.equals("YES")) {
    			if (deptId != null && deptId.startsWith("shared_mailbox_")) {
    				logger.debug("Cannot login with shared mailbox account.");
    				model.addAttribute("message", egovMessageSource.getMessage("fail.common.login", locale));
        	        return "forward:/user/login/login.do";
    			}
    		}
        	
			// 사용자 이메일 alias 설정 페이지
			String useMailAliasSettingOnLogin = ezCommonService.getTenantConfig("useMailAliasSettingOnLogin", tenantId);

			if ("YES".equals(useMailAliasSettingOnLogin)
					&& ezCommonService.getUserConfigInfo(tenantId, _uid, "userFriendlyEmailAddress").isEmpty()) {
				Cookie loginIdCookie = new Cookie("loginId", loginId);
				loginIdCookie.setPath("/");
				response.addCookie(loginIdCookie);
			}

        	// masteradmin의 암호로 로그인 가능하여 masteradmin 암호가 맞는 경우
        	// usermaster 테이블의 ip정보/loginCount는 업데이트하지 않고 접속 로그정보만 저장한다.
			if (masteradminLogin) {
				// 로그인 쿠기 생성 & ezSessionId (uuid) 값을 리턴 받아 로그정보로 사용
				String ezSessionId = createLoginCookie(_uid, rpwd, _pwd, tenantId, request, response, deptId, companyId);

				String sessionCode = getSessionId(request, ezSessionId);
				logger.debug("Login sessionCode : {} masteradminLogin : {}", _uid, sessionCode);
	        	
        		//접속 로그정보 저장
        		resultVO.setIp(ClientUtil.getClientIP(request));
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
        		
	        	return "redirect:/ezNewPortal/newPortalMain.do";
        		
        	} else {
        		//Check login state of the user
            	int check = checkState(tenantId, _uid, numberOfLoginFailPermit);
				boolean check1 = false;

				if (!loginLockedDate.equals("") && !loginLockedDate.equals("0")) {
					check1 = checkLockedDate(tenantId, _uid, loginLockedDuration, loginLockedDate, formatedNow);

					if (check == -3 && check1) {
						check = 0;
					}
				}
            	
            	// 해당 사용자의 로그인이 블록되지 않은 경우
            	if (check != -3) {
    	        	//비밀번호 변경 팝업 상태 값 초기화
    	        	int diff = 1;

					String changePassword = ezCommonService.getTenantConfig("changePassword", tenantId);

//					if (!"N".equalsIgnoreCase(resultVO.getManualFlag()) // 인사연동 사용자의 경우 비밀번호 첫로그인 및 만료 시 예외 필요 사이트 시 주석을 해제하여 사용
					if (!(changePassword != null && changePassword.equals("0"))) { // 패스워드 변경 이벤트 발생 여부

						if (resultVO.getLoginCnt() == 0) {
							diff = 0;

							String pwPolicyExplain = commonUtil.getPwPolicyExplain(companyId, tenantId, locale);
							model.addAttribute("isFirstLogin", "Y");
							model.addAttribute("companyId", companyId);
							model.addAttribute("pwPolicyExplain", pwPolicyExplain);
						} else {
							String expirePassPeriod = ezCommonService.getCompanyConfig(tenantId, companyId, "ExpirePassPeriod");
							expirePassPeriod = expirePassPeriod.trim().equals("") ? "0" : expirePassPeriod;
							logger.debug("companyId=" + companyId + ", ExpirePassPeriod=" + expirePassPeriod);
							// String expirePassPeriod = ezCommonService.getTenantConfig("ExpirePassPeriod", tenantId);

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
					}

    	        	// 로그인 실패 횟수를 제한하는 경우 
    	        	if (check != -1) {
    		        	// 성공적으로 로그인한 경우 지금까지의 로그인 실패 카운터를 초기화한다.
    		        	//Reset number of login fail attempts
    		        	commonUtil.resetLoginFailAttempts(_uid, tenantId);
    	        	}
    	        	
    	        	// 사용자정지 여부를 체크
    	        	String useLoginStop = ezCommonService.getTenantConfig("useLoginStop", tenantId);
    	        	
    	        	if (useLoginStop != null && useLoginStop.equals("YES")) {
    	        		int flag = checkStopUser(tenantId, resultVO.getId());
    	        		if(flag > 0) {
    	        			// 2021-12-21 이사라 : 접속 실패 로그정보 저장
    						resultVO.setIp(ClientUtil.getClientIP(request));
    						resultVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
    						resultVO.setOs(ClientUtil.getClientInfo(request, "os"));
    						resultVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));
    						resultVO.setTenantId(tenantId);
    						resultVO.setStatus("N");
    		
    						if (resultVO.getTitle2() == null) {
    							resultVO.setTitle2("");
    						}
    						
    						loginService.insertLog(resultVO);
    						
    	        			model.addAttribute("message", "stopUser");
    	        			return "forward:/user/login/login.do";
    	        		}
    	        	}

					// 비밀번호 초기화한 사용자 분기 처리
					String resetPassword = ezCommonService.getUserConfigInfo(tenantId,resultVO.getId(),"resetPassword");
					if ( resetPassword != null && "Y".equals(resetPassword)) {
						String pwPolicyExplain = commonUtil.getPwPolicyExplain(companyId, tenantId, locale);

						model.addAttribute("isExpireDate", "Y");
						model.addAttribute("userId", _uid);
						model.addAttribute("encryptID", loginVO.getEncryptID());
						model.addAttribute("encryptPass", loginVO.getEncryptPass());
						model.addAttribute("loginId", loginId);
						model.addAttribute("companyId", companyId);
						model.addAttribute("pwPolicyExplain", pwPolicyExplain);
						model.addAttribute("resetPassword", resetPassword);

						return "forward:/user/login/login.do";
					}
    	        	
    				//0보다 작아지면 패스워드 변경기한 Expired
    	        	//패스워드 다음에 변경 기능 추가. 2019-09-17 홍대표
    	        	//String passwordUpdateNextTime = request.getParameter("nextTime") != null ? request.getParameter("nextTime") : "";
    				if (diff <= 0 && !passwordUpdateNextTime.equals("YES")) {				
    					String pwPolicyExplain = commonUtil.getPwPolicyExplain(companyId, tenantId, locale);
    					
    					// 2021-12-29 이사라 : 접속 실패 로그정보 저장
						resultVO.setIp(ClientUtil.getClientIP(request));
						resultVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
						resultVO.setOs(ClientUtil.getClientInfo(request, "os"));
						resultVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));
						resultVO.setTenantId(tenantId);
						resultVO.setStatus("N");
		
						if (resultVO.getTitle2() == null) {
							resultVO.setTitle2("");
						}
						
						loginService.insertLog(resultVO);
						
    					model.addAttribute("isExpireDate", "Y");
    					model.addAttribute("userId", _uid);
    					model.addAttribute("encryptID", loginVO.getEncryptID());
    					model.addAttribute("encryptPass", loginVO.getEncryptPass());
    					model.addAttribute("loginId", loginId);
    					model.addAttribute("companyId", companyId);
    	        		model.addAttribute("pwPolicyExplain", pwPolicyExplain);
    					
    		        	return "forward:/user/login/login.do";
					} else if (useFido && !passedFidoAuthentication) {
						//logger.debug("useFido in : {}", useFido); // 운영시 주석 처리

						if (userDeviceChk) {
							// fido session 생성하여 tbl에 넣기
							String fidoSessionId = UUID.randomUUID().toString();
							FidoAuthenticationVO fidoVO = new FidoAuthenticationVO();
	
							fidoVO.setFidoSessionId(fidoSessionId);
							fidoVO.setId(loginVO.getId());
							fidoVO.setIp(ClientUtil.getClientIP(request));
							fidoVO.setStatus("requesting");
	
							loginService.setFidoSession(fidoVO);
	
							// jgw-server 에 talk_tblnotification 넣어서 push 메시지 전달
							String linkUrl = "/mobile/user/login/mFidoAuthentication.do?" + "fidoSessionId=" + fidoSessionId + "&encryptId=" + loginVO.getEncryptID() + "&encryptPass=" + loginVO.getEncryptPass();

							String userId = loginVO.getId();
							String useSaas = ezCommonService.getTenantConfig("useSaas", tenantId);
							if ("Y".equalsIgnoreCase(useSaas)){
								String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
								userId = new StringBuilder(loginVO.getId()).append("@").append(domainName).toString();
							}

							boolean insertTalkNotification = ezEmailService.addEzTalkNotification(
									userId,
									egovMessageSource.getMessage("main.fido010", locale),
									egovMessageSource.getMessage("main.fido011", locale),
									"23", "", linkUrl);
	
							if (!insertTalkNotification) {
								logger.debug("useFido but insertTalkNotification failed, id={}", loginVO.getId());
								return "forward:/user/login/login.do";
							}
	
							// Fido 인증요청 화면 호출 + 필요한 parameter 전달
							String timeLimit = ezCommonService.getTenantConfig("FidoTimeLimit", tenantId);
	
							model.addAttribute("timeLimit", timeLimit);
							model.addAttribute("fidoSessionId", fidoSessionId);
							model.addAttribute("encryptId", loginVO.getEncryptID());
							model.addAttribute("encryptPassword", loginVO.getEncryptPass());
	
							return "user/login/fidoAuthentication";
						} else {
							// 모바일 기기 등록 안내 화면 호출
							return "user/login/deviceRegisterNotice";
						}
					} else {
    					String ip = ClientUtil.getClientIP(request);		
    					loginVO.setIp(ip);
    					
    					//IP Address,  마지막 login시간 저장
    					loginService.updateUser(loginVO);
    					
						// 로그인 쿠기 생성 & ezSessionId (uuid) 값을 리턴 받아 로그정보로 사용
						String ezSessionId = createLoginCookie(_uid, rpwd, _pwd, tenantId, request, response, deptId, companyId);

						String sessionCode = getSessionId(request, ezSessionId);
						logger.debug("Login sessionCode : {} user : {} ", _uid, sessionCode);
    		        	
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
    		        	
    		        	//세션 생성 - 일시적으로 주석처리 필요할때 사용
    		        	//session = request.getSession();

						boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));

						// 2018.10.22 이석화 추가 - useSession row 유무 확인
						String useSession = ezCommonService.getTenantConfig("useSession", tenantId);
    		        	
    		        	// 2018-10-22 이석화 - 세션이 0이면 세션 사용안함
						if (StringUtils.isNotBlank(useSession) && !useDbSession) { // DB 세션을 사용하면 세션 유지 시간 설정이 불필요 함
    		        		int sessionTime = Integer.parseInt(useSession);
    		        		
	    		        	if (sessionTime != 0) {
	    		        		//세션 생성 - 일시적으로 주석처리 필요할때 사용
		    		        	session = request.getSession();			// 세션 필요로 주석 해제
		    		        	session.setMaxInactiveInterval(sessionTime * 60);		// 세션의 유지 시간 설정
	    		        	}
    		        	}
//    		        	return "redirect:/ezPortal/portalMain.do";
    		        	return "redirect:/ezNewPortal/newPortalMain.do";
    		        	
    				}
    			// 해당 사용자의 로그인이 블록된 경우
                } else {
            		//User has been blocked
        			//Show block message
					// model.addAttribute("message", egovMessageSource.getMessageExtend("fail.common.login.block", new Object[] {numberOfLoginFailPermit}, locale));

					if (!"0".equalsIgnoreCase(loginLockedDuration)) {
						model.addAttribute("message1", egovMessageSource.getMessageExtend("fail.common.login.block", new Object[] { numberOfLoginFailPermit, loginLockedDuration }, locale));
						model.addAttribute("message2", egovMessageSource.getMessageExtend("fail.common.login.block1", new Object[] { loginLockedDuration }, locale));
					} else {
						model.addAttribute("message1", egovMessageSource.getMessageExtend("fail.common.login.blockNoDur", new Object[] { numberOfLoginFailPermit}, locale));
					}

					model.addAttribute("message", "loginBlock");
                	
                	// 2021-12-21 이사라 : 접속 로그정보 저장 (실패)
                	resultVO.setIp(ClientUtil.getClientIP(request));
					resultVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
					resultVO.setOs(ClientUtil.getClientInfo(request, "os"));
					resultVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));
					resultVO.setTenantId(tenantId);
					resultVO.setStatus("N");
	
					if (resultVO.getTitle2() == null) {
						resultVO.setTitle2("");
					}
					
					loginService.insertLog(resultVO);
					
                	return "forward:/user/login/login.do";
            	}
        	}
        	
        } else {
			String MsgCodeifWrongOTP = "";

			// 사용자가 입력한 암호가 맞지 않는 경우
			if (resultVO == null || StringUtils.isBlank(resultVO.getId())) {
				logger.debug("_uid=" + _uid + ",password is wrong.");
			// 2023-03-22 이사라 : [TFA] 사용자가 입력한 OTP가 맞지 않는 경우
			} else {
				logger.debug("Wrong OTP, _uid={}, submitted={}", _uid, loginOtp);
				MsgCodeifWrongOTP = ".otp";
			}
        			
        	// 2021-12-21 이사라 : 접속 로그정보 저장 (실패)
        	loginVO.setId(_uid);
    		loginVO.setTenantId(tenantId);
        	loginVO.setDn("NOPASSWORD");
        	resultVO = loginService.selectUser(loginVO);
        	
			resultVO.setIp(ClientUtil.getClientIP(request));
			resultVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
			resultVO.setOs(ClientUtil.getClientInfo(request, "os"));
			resultVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));
			resultVO.setTenantId(tenantId);
			resultVO.setStatus("N");

			if (resultVO.getTitle2() == null) {
				resultVO.setTitle2("");
			}
			
			loginService.insertLog(resultVO);
        	
        	//Check login state of the user 
        	int check = checkState(tenantId, _uid, numberOfLoginFailPermit);
			boolean check1 = false;

			if(!loginLockedDate.equals("") && !loginLockedDate.equals("0")) {
				check1 = checkLockedDate(tenantId, _uid, loginLockedDuration, loginLockedDate, formatedNow);
				
				if (check == -3 && check1) {
					check = 0;
				}
			}
			
        	String errorMsg1 = "";
        	String errorMsg2 = "";
        	String errorMsg3 = "";
        	String errorMsg4 = "";
        	String errorMsg5 = "";
        	//String errorMsg6 = "";

        	switch (check) {
				case -3: 
	    			//Show block message
	            	//model.addAttribute("message", egovMessageSource.getMessageExtend("fail.common.login.block", new Object[] {numberOfLoginFailPermit}, locale));
					if(loginLockedDate.equals("")) {
						ezCommonService.insertUserConfigInfo(tenantId, _uid, "LoginLockedDate", formatedNow);
					}

					if (!"0".equalsIgnoreCase(loginLockedDuration)) {
						model.addAttribute("message1", egovMessageSource.getMessageExtend("fail.common.login.block", new Object[] { numberOfLoginFailPermit, loginLockedDuration }, locale));
						model.addAttribute("message2", egovMessageSource.getMessageExtend("fail.common.login.block1", new Object[] { loginLockedDuration }, locale));
					} else {
						model.addAttribute("message1", egovMessageSource.getMessageExtend("fail.common.login.blockNoDur", new Object[] { numberOfLoginFailPermit}, locale));
					}

					model.addAttribute("message", "loginBlock");

	            	return "forward:/user/login/login.do";
    			case -2:
	        		//The first time this user login failed
	        		ezCommonService.insertUserConfigInfo(tenantId,  _uid, "LoginFailCount", "1");
	        		//Show warning message
	        		/* 2018-05-24 홍승비 - 로그인 실패 시 레이어팝업을 위해 플래그 추가, 메세지 리소스 분리 */
	        		errorMsg1 = egovMessageSource.getMessage("fail.common.login", locale);
	        		errorMsg2 = egovMessageSource.getMessage("fail.common.login.warning2", locale);
	        		errorMsg3 = egovMessageSource.getMessageExtend("fail.common.login.warning3", new Object[] {1}, locale);
	        		errorMsg4 = egovMessageSource.getMessage("fail.common.login.warning4", locale);
	        		errorMsg5 = egovMessageSource.getMessageExtend("fail.common.login.warning5", new Object[] {numberOfLoginFailPermit, loginLockedDuration}, locale);
	        		
	        		model.addAttribute("message1", errorMsg1);
	            	model.addAttribute("message2", errorMsg2);
	            	model.addAttribute("message3", errorMsg3);
	            	model.addAttribute("message4", errorMsg4);
	            	model.addAttribute("message5", errorMsg5);
	            	//model.addAttribute("message6", errorMsg6);
	            	model.addAttribute("isWrongPass", "Y");
	            	
	            	return "forward:/user/login/login.do";
        		case -1:
        			//Show normal login fail message
                	model.addAttribute("message", egovMessageSource.getMessage("fail.common.login" + MsgCodeifWrongOTP, locale));
                	return "forward:/user/login/login.do";            	
        		default:
        			//Increase number of attempts in database
        			ezCommonService.updateUserConfigInfo(tenantId, _uid, "LoginFailCount", Integer.toString(check + 1));
        			
        			if (check >= numberOfLoginFailPermit - 1) {
        				//Show block message
						// model.addAttribute("message", egovMessageSource.getMessageExtend("fail.common.login.block", new Object[] {numberOfLoginFailPermit}, locale));
						
						if(loginLockedDate.equals("")) {
							ezCommonService.insertUserConfigInfo(tenantId, _uid, "LoginLockedDate", formatedNow);
						} else {
							ezCommonService.updateUserConfigInfo(tenantId, _uid, "LoginLockedDate", formatedNow);
						}

						if (!"0".equalsIgnoreCase(loginLockedDuration)) {
							model.addAttribute("message1", egovMessageSource.getMessageExtend("fail.common.login.block", new Object[] { numberOfLoginFailPermit, loginLockedDuration }, locale));
							model.addAttribute("message2", egovMessageSource.getMessageExtend("fail.common.login.block1", new Object[] { loginLockedDuration }, locale));
						} else {
							model.addAttribute("message1", egovMessageSource.getMessageExtend("fail.common.login.blockNoDur", new Object[] { numberOfLoginFailPermit}, locale));
						}
						model.addAttribute("message", "loginBlock");

                    	return "forward:/user/login/login.do";
        			} else {
            			//Show warning message
						errorMsg1 = egovMessageSource.getMessage("fail.common.login", locale);
    	        		errorMsg2 = egovMessageSource.getMessage("fail.common.login.warning2", locale);
    	        		errorMsg3 = egovMessageSource.getMessageExtend("fail.common.login.warning3", new Object[] {check + 1}, locale);
    	        		errorMsg4 = egovMessageSource.getMessage("fail.common.login.warning4", locale);
    	        		errorMsg5 = egovMessageSource.getMessageExtend("fail.common.login.warning5", new Object[] {numberOfLoginFailPermit, loginLockedDuration}, locale);
    	        		
    	        		model.addAttribute("message1", errorMsg1);
    	            	model.addAttribute("message2", errorMsg2);
    	            	model.addAttribute("message3", errorMsg3);
    	            	model.addAttribute("message4", errorMsg4);
    	            	model.addAttribute("message5", errorMsg5);
    	            	//model.addAttribute("message6", errorMsg6);
    	            	model.addAttribute("isWrongPass", "Y");
    	            	
    	            	return "forward:/user/login/login.do";
        			}
        	}
		}
    }
    
	private String getSessionId(HttpServletRequest request, String ezSessionId) {
		boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));
		Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
		String sessionCode = "";

		try {
			if (useDbSession && StringUtils.isNotBlank(ezSessionId)) { // 로그인
				sessionCode = ezSessionId;
			} else if (useDbSession && StringUtils.isBlank(ezSessionId)) { // 로그아웃
				sessionCode = loginCookie.getValue() != null ? loginCookie.getValue() : "";
			} else {
				sessionCode = request.getSession().getId();
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return sessionCode;
	}

    public boolean ipAccessCheck(LoginVO loginVO) throws Exception {
    	logger.debug("ipAccessCheck start");
    	logger.debug("userIP=" + loginVO.getIp());
    	
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
        			
    				String ipListIp[] = ipBandList.get(i).getIpAddress().split("\\."); // *(대역)이 있을 수도 있으니 하나하나 검사해야됨
        			for (int j = 0; j < clientIP.length; j++) {
        				if (ipListIp[j].equals(clientIP[j]) || ipListIp[j].equals("*")) {
        					checkCnt++;
        				}
        			}
        			
        			if (checkCnt == 4 && getAccess.equals("NO")) {
        				return false;
        			} else if (checkCnt == 4){
        				returnValue = true;
        			}
        			checkCnt = 0;
        		}
        		
        	} /*else { // 대역이 등록 안돼있으면 무조건 false (useIPAccess컨피그 사용O -> id체크X -> 부서체크X -> 등록된 대역도 없으므로)
        		return false;
        	}*/
        	
        	// 허용 국가 리스트
        	String countryCodeList = ezSystemAdminService.getAccessCountryList(loginVO.getTenantId());
        	if (!countryCodeList.trim().equals("")) {
        		String loginCountryCode = "";
        		String loginCountryName = "";
        		Boolean localIpChk = commonUtil.checkLocalIP(loginVO.getIp());
        		
        		if (localIpChk) {
        			loginCountryCode = ezCommonService.getTenantConfig("systemCountryCode", loginVO.getTenantId());
        		} else { 
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
        	
        	logger.debug("ipAccessCheck ended");
        	return returnValue;
    	}
    }
	
	public boolean fidoNotAccessIpCheck(LoginVO loginVO) throws Exception {
		logger.debug("ipAccessCheck start");
		try {
			boolean returnValue = false;

			int tenantId = loginVO.getTenantId();
			String companyId = loginVO.getCompanyID();
			String useFido = Optional.ofNullable(ezCommonService.getCompanyConfig(tenantId, companyId, "useFidoSession")).orElseGet(() -> "NO");
			
			logger.debug("useFido=" + useFido);

			if (useFido.equalsIgnoreCase("NO")) {
				return false;
			} else if (useFido.equalsIgnoreCase("YES")) {
				String clientIP[] = loginVO.getIp().split("\\.");

				List<IPBandVO> notAccessFidoIpList = ezSystemAdminService.getFidoAuthenticList(tenantId, companyId);

				if (notAccessFidoIpList != null && notAccessFidoIpList.size() != 0) {
					String ipBandAddr = "";
					String getAccess = "NO";
					int checkCnt = 0;
					boolean checkIp = ezSystemAdminService.getFidoAuthenticInfo(tenantId, companyId, loginVO.getIp()) > 0;
					
					for (IPBandVO ipBandVo : notAccessFidoIpList) {
						ipBandAddr = ipBandVo.getIpAddress();
						getAccess = ipBandVo.getAccess();
						logger.debug("ipBandAddr=" + ipBandAddr + ", getAccess=" + getAccess);

						String ipListIp[] = ipBandAddr.split("\\."); // *(대역)이 있을 수도 있으니 하나하나 검사해야됨
						for (int j = 0; j < clientIP.length; j++) {
							if (ipListIp[j].equals("*") || ipListIp[j].equals(clientIP[j])) {
								checkCnt++;
							}
						}

						logger.debug("checkCnt : {}, checkIp : {} ", checkCnt, checkIp);
						if (checkCnt == 4) {
							if (checkIp && getAccess.equals("YES")) {
								returnValue = false;
								break;
							} else if (!checkIp) {
								returnValue = true;
								break;
							}
						}	else if (checkCnt < 4) {
							returnValue = true;
						} 
						checkCnt = 0;
					} // for_end
				} else {
					returnValue = true;
				} // notAccessFidoIpList if_end
			}

			logger.debug("returnValue=" + returnValue);
			return returnValue;
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			return false;
		}
	}
	
	@ResponseBody
	@PostMapping(value = "/user/login/getFidoSessionStatus.do")
	public String getFidoSessionStatus(@RequestParam String fidoSessionId) throws Exception {
		logger.debug("checkFidoAuthentication started");

		FidoAuthenticationVO vo = loginService.getFidoSession(fidoSessionId);

		logger.debug("checkFidoAuthentication ended : {}", vo.getStatus());

		return vo.getStatus();
	}

	@ResponseBody
	@PostMapping(value = "/user/login/expireFidoSession.do")
	public String expireFidoSession(@RequestParam String fidoSessionId) throws Exception {
		logger.debug("expireFidoSession started");

		FidoAuthenticationVO vo = new FidoAuthenticationVO();
		vo.setFidoSessionId(fidoSessionId);
		vo.setStatus("expired");

		loginService.updateFidoStatus(vo);

		logger.debug("expireFidoSession ended : {}", vo.getStatus());

		return vo.getStatus();
	}

    // 2023-03-22 이사라 : [TFA] OTP 번호 확인을 위해 호출
	public String getTOTPCode(String otpKey) {
		Base32 base32 = new Base32();
		byte[] bytes = base32.decode(otpKey);
		String hexKey = Hex.encodeHexString(bytes);

		return TOTP.getOTP(hexKey);
	}

	// 2023-03-22 이사라 : [TFA] OTP key 생성
	public String generateSecretKey() {
		SecureRandom random = new SecureRandom();
		byte[] bytes = new byte[20];
		random.nextBytes(bytes);
		Base32 base32 = new Base32();

		logger.debug("generateSecretKey=" + base32.encodeToString(bytes));

		return base32.encodeToString(bytes);
	}

	// 2023-04-10 이사라 : [TFA] OTP QR코드 생성을 위한 구글바코드 생성
	public String getGoogleAuthenticatorBarCode(String otpKey, String mail, String companyId) {
	    try {
	        return "otpauth://totp/"
	                + URLEncoder.encode(companyId + ":" + mail, "UTF-8").replace("+", "%20")
	                + "?secret=" + URLEncoder.encode(otpKey, "UTF-8").replace("+", "%20")
	                + "&issuer=" + URLEncoder.encode(companyId, "UTF-8").replace("+", "%20");
	    } catch (UnsupportedEncodingException e) {
	    	logger.error("getGoogleAuthenticatorBarCode Encoding Exception : ", e);
	    	return "";
	    }
	}

	// 2023-04-10 이사라 : [TFA] OTP QR코드 생성
	public void createQRCode(String id, int tenantId, HttpServletRequest request, String barCodeData) throws Exception {

		// QR을 저장할 위치
		String filePath = commonUtil.getRealPath(request)+ commonUtil.getUploadPath("upload_common.ROOT", tenantId) + commonUtil.separator + "qr";//commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(0,10).replace("-", "") ;
		File file = new File(commonUtil.detectPathTraversal(filePath));
		
		if (!file.exists()) {
			file.mkdirs();
		}
			
		// QR 생성 및 저장
	    BitMatrix matrix = new MultiFormatWriter().encode(barCodeData, BarcodeFormat.QR_CODE, 200, 200);
	    filePath += commonUtil.separator.concat(id).concat(".png");

	    try (FileOutputStream out = new FileOutputStream(filePath)) {
	        MatrixToImageWriter.writeToStream(matrix, "png", out);
	    }
	}

    public String createLoginCookie(
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
				acceptLanguage = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
	        }
	        
		    if (acceptLanguage != null) {
		    	twoLetterLang = acceptLanguage.substring(0, 2);
		    // 이유는 정확히 알 수 없지만 로그를 확인한 결과 윗 라인에서 acceptLanguage가 null인 경우가 발생하여 추가함.
		    } else {				        
		    	twoLetterLang = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
		    }
			
		    lang = commonUtil.getLangNumFromTwoLetterLang(twoLetterLang, tenantId);
		    
		    //브라우저 언어가 한국어/영어/일본어/인도네시아어가 아닐 경우 시스템 언어로 설정
		    if (lang.equals("")) {						
				lang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

				// useSecondaryLang 설정이 YES일 때는 PrimaryLang이 영어가 아닌 경우에도 기본적으로 엉어를 사용하는 환경을
				// 의미하므로 디폴트 언어 설정을 영어로 설정함.
				if ("YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useSecondaryLang", tenantId))) {
					lang = "2";
				}
				
				twoLetterLang = commonUtil.getTwoLetterLangFromLangNum(lang);
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
		//2019-09-16 김보미 - 사용하지 않으므로 패스워드 부분 주석 : userPw 값이 '/'로 끝나면 나중에 "///"으로 split할때 locale앞에 '/'가 붙어 문제 발생
		String jobId = ezOrganAdminService.getJobIdForFirstUser(userId, tenantId).orElse("");
		String cInfo = serverName + "///" + userId + "///" + "encryptedUserPw" + "///" + ipAddress + "///" + "userPw" + "///" + locale + "///" + lang + "///" + timeZone + "///" + tenantId+ "///" + deptID + "///" + companyID + "///" + jobId;
		String loginCookie = egovFileScrty.encryptAES(cInfo);
		
		// DB 기반 세션 방식 적용하는 경우
		// 2023-10-31 이사라 - ezSessionId를 생성하여 loginCookie에 담는다. 실제 로그인쿠키는 DB에 저장
		boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));
		String ezSessionId = "";

		if (useDbSession) {
			ezSessionId = UUID.randomUUID().toString();

			SessionVO vo = new SessionVO();
			vo.setEzSessionId(ezSessionId);
			vo.setLoginCookie(loginCookie);
			vo.setTenantId(tenantId);
			vo.setType("useSession");

			loginService.insertSession(vo);

			// 생성한 SessionId를 로그인쿠키에 담아 사용하여 기존의 loginCookie를 param으로 사용하는 controller 코드를 그대로 이용
			loginCookie = ezSessionId;
		}

    	Cookie cookieID = new Cookie("loginCookie", loginCookie);
    	cookieID.setPath("/");
        if (request.isSecure() || "https".equalsIgnoreCase(request.getHeader("X-Forwarded-Proto"))) {
            response.addHeader("Set-Cookie", "loginCookie=" + loginCookie + "; Path=/; SameSite=None; Secure");
        } else {
            response.addCookie(cookieID);
        }

    	// loginCookieSSO 라는 이름으로 쿠키를 추가로 생성할 것인지
		/* 더 이상 사용되지 않는 코드로 보여 보안 취약점 조치를 위해 제거하였으나 가온누리에서 닷넷 버전 협업과의 연동에 사용중이어서 다시 복원함. */
    	String useSSOCookie = ezCommonService.getTenantConfig("useLoginCookieSSO", tenantId);
    	
    	if (!useSSOCookie.trim().isEmpty() && !"NO".equalsIgnoreCase(useSSOCookie)) {
    		Cookie ssoLoginCookie = new Cookie("loginCookieSSO", loginCookie);
    		ssoLoginCookie.setPath("/");
    		ssoLoginCookie.setDomain(useSSOCookie);
    		response.addCookie(ssoLoginCookie);
    	}

    	String multiLoginTime = "";
    	if(!request.getRequestURI().matches("(/ezConn|/ezTalkGate|/ezUCMessenger).+")) { // 외부 로그인으로 접근시에는 멀티로그인 옵션 무시
    		// 멀티로그인 옵션 관련 쿠키 (default : YES)
    		multiLoginTime = String.valueOf(System.currentTimeMillis());
    		
    		String useMultiLogin = ezCommonService.getCompanyConfig(tenantId, companyID, "useMultiLogin");
    		if(useMultiLogin.equalsIgnoreCase("NO")) {
    			commonUtil.setLoginUsers(tenantId, companyID, userId, multiLoginTime, Device.PC);
    		}
    	} else {
    		// 멀티로그인 쿠키 셀렉트해서 넣어주기 
    		multiLoginTime = ezCommonService.selectMultiLoginTime(tenantId, companyID, userId, Device.PC);
    	}
    	
    	Cookie multiLoginCookieID = new Cookie("multiLoginCookie", multiLoginTime);
    	multiLoginCookieID.setPath("/");
    	response.addCookie(multiLoginCookieID);

		String useSession = ezCommonService.getTenantConfig("useSession", tenantId);
		
    	if (!useSession.isEmpty() && !useDbSession) {
    		int sessionTime = 0;
    		
    		try {
    			sessionTime = Integer.parseInt(useSession);
    		} catch (NumberFormatException nfe) {  
    			logger.error(nfe.getMessage(), nfe);
    		}
    		
        	if (sessionTime != 0) {
        		HttpSession session = request.getSession();
	        	session.setMaxInactiveInterval(sessionTime*60); // 세션의 유지 시간 설정
        	}
    	}    	
		
		// 2024-08-28 조수빈 - 유저 색상 테마 정보
		Cookie useColor = new Cookie("useColor", Integer.toString(ezNewPortalService.getUserColor(userId, companyID, tenantId)));
		useColor.setPath("/");
		response.addCookie(useColor);
		
		return ezSessionId;
    }
    
	// 2023-03-22 이사라 : [TFA] 2-factor 설정화면
	@RequestMapping(value = "/user/login/setTFA.do", method = RequestMethod.POST)
	@ResponseBody
	public String setTFA(HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) throws Exception {
		logger.debug("setTFA started.");

		boolean hasOTP = false;
		String otpKey = "";
		String qrImagePath = "";
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		String encUserId = request.getParameter("userId");

		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		String userId = EgovFileScrty.decryptRsa(pk, encUserId);

		String serverName = request.getServerName();
		int tenantId = loginService.getTenantId(serverName);

		LoginVO loginVO = new LoginVO();
		loginVO.setId(userId);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");
		LoginVO resultVO = loginService.selectUser(loginVO);

		try {
			// otp를 등록한 사용자인지 체크
			hasOTP = loginService.searchOtpKey(resultVO);
			otpKey = generateSecretKey();
			logger.debug("setTFA userId={}, tenantId={}, otpKey={}, hasOTP={}", userId, tenantId, otpKey, hasOTP);

			if (hasOTP) {
				logger.debug("updateUserConfigInfo otpKey");
				ezCommonService.updateUserConfigInfo(tenantId, userId, "otpKey", otpKey);
			} else {
				logger.debug("insertUserConfigInfo otpKey");
				ezCommonService.insertUserConfigInfo(tenantId, userId, "otpKey", otpKey);
			}

			// QR 코드 생성
			String barCodeUrl = getGoogleAuthenticatorBarCode(otpKey, resultVO.getEmail(), resultVO.getCompanyID());
			qrImagePath = commonUtil.getUploadPath("upload_common.ROOT", tenantId).concat(commonUtil.separator).concat("qr").concat(commonUtil.separator).concat(userId).concat(".png");

			createQRCode(userId, tenantId, request, barCodeUrl);
			
		} catch (Exception e) {
			logger.debug("setTFA error. otpKey={}", otpKey);
			// 오류가 발생한 경우 otpKey 비워 줌
			ezCommonService.updateUserConfigInfo(tenantId, userId, "otpKey", "");

			logger.error(e.getMessage(), e);
			return "fail";
		}

		logger.debug("setTFA ended. otpKey={}", otpKey);
		return otpKey.concat("::").concat(qrImagePath);
	}

    /**
	 * 로그아웃한다.
	 * @return String
	 * @exception ExceptionactionLogout
	 */
    @RequestMapping(value="/user/login/actionLogout.do", method=RequestMethod.GET)
	public String actionLogout(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String serverName = request.getServerName();
        int tenantId = loginService.getTenantId(serverName);
		LoginVO loginVO = new LoginVO();
        
    	Cookie[] cookies = request.getCookies();
    	boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));
    	
    	if (cookies != null) {
    		for (Cookie cookie : cookies) {
				/* 더 이상 사용되지 않는 코드로 보여 보안 취약점 조치를 위해 제거하였으나 가온누리에서 닷넷 버전 협업과의 연동에 사용중이어서 다시 복원함. */
    			if (cookie.getName().equals("loginCookieSSO")) {
    				String ssoDomain = ezCommonService.getTenantConfig("useLoginCookieSSO", tenantId);
    				cookie.setDomain(ssoDomain);
    			}
    			
				if (useDbSession && cookie.getName().equalsIgnoreCase("loginCookie")) {
					loginService.deleteSession(cookie.getValue());
				}

    			if (!cookie.getName().equals("saveid") && !cookie.getName().matches("POPUP_.*") && !cookie.getName().matches("SURV_POPUP_.*")) {
    				cookie.setMaxAge(0);
    				cookie.setPath("/");
    				response.addCookie(cookie);
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
			
        	return "redirect:https://login.microsoftonline.com/common/oauth2/v2.0/logout?post_logout_redirect_uri=" + redirectUri;         	
        }
        
        // 2021-12-23 이사라 : 세션ID를 세션코드로 입력
        String sessionCode = getSessionId(request, "");
    	logger.debug("Logout sessionCode = " + sessionCode);
    	
        // 2018.10.22 이석화 추가 - 세션 제거 
       	request.getSession().invalidate();

       	// 2021-12-23 이사라 : 로그아웃시간 기록
       	loginVO.setTenantId(tenantId);
       	loginVO.setSessionCode(sessionCode);
       	loginService.updateLog(loginVO);
       	
       	return "redirect:/user/login/login.do"; 
    }
    
    @RequestMapping(value="/user/login/actionLogoutWithRedirectUri.do", method=RequestMethod.GET)
	public String actionLogoutWithRedirectUri(
//	public void actionLogoutWithRedirectUri(
					@RequestParam("redirectUri") String redirectUri,
					HttpServletRequest request,
					HttpServletResponse response,
					RedirectAttributes rttr
					) throws Exception {
    	logger.debug("redirectUri=" + redirectUri);
    	
    	String serverName = request.getServerName();         
        int tenantId = loginService.getTenantId(serverName);
        LoginVO loginVO = new LoginVO();
        
        // 2021-12-23 이사라 : 세션ID를 세션코드로 입력
        String sessionCode =  request.getSession().getId();
        logger.debug("Login sessionCode = " + sessionCode);
		
    	Cookie[] cookies = request.getCookies();
    	boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));
    	
    	if (cookies != null) {
    		for (Cookie cookie : cookies) {

				if (useDbSession || cookie.getName().equalsIgnoreCase("loginCookie")) {
					loginService.deleteSession(cookie.getValue());
				}

    			if (!cookie.getName().equals("saveid") && !cookie.getName().matches("POPUP_.*") && !cookie.getName().matches("SURV_POPUP_.*") && !cookie.getName().equals("multiLoginCookie")) {
    				cookie.setMaxAge(0);
    				cookie.setPath("/");
    				response.addCookie(cookie);
    			}
    	    }
    	}
    	
//    	response.sendRedirect(redirectUri);
    	
    	request.getSession().invalidate();
    	
    	// 2021-12-23 이사라 : 로그아웃시간 기록
    	loginVO.setTenantId(tenantId);
       	loginVO.setSessionCode(sessionCode);
       	loginService.updateLog(loginVO);
       	
    	if (request.getParameter("multiLoginFlag") != null) {
//    		rttr.addFlashAttribute("message", message);
    		rttr.addFlashAttribute("multiLoginFlag", request.getParameter("multiLoginFlag"));
    	}
    	
    	return "redirect:" + redirectUri;
    }
    
    @RequestMapping(value = "/user/login/setPassword.do", method=RequestMethod.POST)
	@ResponseBody
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
        
    @RequestMapping(value = "/user/login/changePassword.do", produces = "text/html; charset=utf-8", method=RequestMethod.POST)
	@ResponseBody
    public String changeExPassword(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
    	logger.debug("=========================================== changePassword ============================================");
    	
		// 1. 주 수행 변수 oldPw, newPw
    	String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

		String encUserId = request.getParameter("USERID");
		String _uid = EgovFileScrty.decryptRsa(pk, encUserId);
		
		if (StringUtils.isBlank(_uid)) {
		    logger.debug("invalid _uid=" + _uid);
		    
		    return "DECRYPTERROR";
		}

		String encPass = request.getParameter("OLDPASSWORD");
		String encNewPass = request.getParameter("NEWPASSWORD");
		String resetPasswordFlag = request.getParameter("RESETPASSWORDFLAG");
		
		String rpwd = EgovFileScrty.decryptRsa(pk, encPass);
		String epwd = EgovFileScrty.decryptRsa(pk, encNewPass);

		// 2. 사용자 정보 : 로그인 정보 확인
        String serverName = request.getServerName();
        int tenantId = loginService.getTenantId(serverName);
		String _pwd = EgovFileScrty.encryptPassword(rpwd, _uid);
		
		loginVO.setId(_uid);
		loginVO.setPassword(_pwd);
		loginVO.setTenantId(tenantId);
        LoginVO resultVO = loginService.selectUser(loginVO);
        
        if (resultVO == null || StringUtils.isBlank(resultVO.getId())) {
			return "LOGINERROR";
        }

		String companyID = resultVO.getCompanyID();
		logger.debug("loginVO : _uid={}, tenantId={}, companyID={}", _uid, tenantId, companyID);

			// 2023-03-27 이사라 : [TFA] 2-factor 인증 사용 여부 체크하여, otp설정 레이어팝업 표출 여부 결정
			boolean useOTP = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useOTP", tenantId));
			model.addAttribute("useOTP", useOTP);

		// 3. 비밀번호 변경 수행
		String result = ezOrganAdminService.changePasswordWithEmailSystem(_uid, tenantId, rpwd, epwd);

		if (!"OK".equalsIgnoreCase(result)) {
			return result;
		}

		// 4. IP Address,  마지막 login시간 저장
		String ip = ClientUtil.getClientIP(request);
		loginVO.setIp(ip);
		loginService.updateUser(loginVO);
		if ("Y".equals(resetPasswordFlag)) {
			ezCommonService.deleteUserConfigInfo(tenantId,_uid,"resetPassword");
		}

		logger.debug("=========================================== changePassword ended ============================================");
		return "OK";
    }
    
	@RequestMapping(value = "/user/login/email.do", produces = "text/html; charset=utf-8", method = RequestMethod.GET)
	public String emailSetting(@CookieValue("loginCookie") String loginCookie, @CookieValue("loginId") Optional<String> loginId, Model model) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);

		String domainName = ezCommonService.getTenantConfig("DomainName", loginVO.getTenantId());
		model.addAttribute("domainName", domainName);
		model.addAttribute("loginId", loginId.orElse(loginVO.getId()));

		return "/user/login/email";
	}
	
	/*
	 * 암호 정책 확인 (로그인 페이지)
	 */
 	@RequestMapping(value = "/user/login/checkPasswordPolicy.do", method = RequestMethod.POST)
 	@ResponseBody
 	public String checkPasswordPolicy(HttpServletRequest request, Model model) throws Exception{
 		logger.debug("checkPasswordPolicy started.");
 		
 		String serverName = request.getServerName();        
        int tenantId = loginService.getTenantId(serverName);

 		String chkPwPolicy = "";
 		
 		String pwStr = request.getParameter("pw");
 		String companyId = request.getParameter("chkCompanyId");
		String userId = request.getParameter("userId");

		PasswordCheckPolicyResult result = commonUtil.checkPwPolicy(pwStr, companyId, tenantId, userId);
		chkPwPolicy = result.succeeded() ? "OK" : result.getMessage();

		if ("PREVERROR". equals(chkPwPolicy)) {
			String rememberPWCountConfig = ezCommonService.getCompanyConfig(tenantId, companyId, "RememberPWCount");
			int rememberPWCount = rememberPWCountConfig == null || "".equalsIgnoreCase(rememberPWCountConfig) ? 0 : Integer.parseInt(rememberPWCountConfig);
			chkPwPolicy += "|"+rememberPWCount;
		}
 		
 		logger.debug("checkPasswordPolicy ended. chkPwPolicy=" + chkPwPolicy);
 		return chkPwPolicy;
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
    
  //모바일 인증번호 발급
    @RequestMapping(value = "/user/login/sendFindPwd.do", produces = "text/html; charset=utf-8", method=RequestMethod.POST)
    @ResponseBody
    public String sendFindPwd(Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
    	logger.debug("=========================================== sendFindPwd ============================================");
    	
    	String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	String encSabun = request.getParameter("sabun");
    	
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

		String _uid = EgovFileScrty.decryptRsa(pk, encSabun);
		if (_uid == null || _uid.equals("")) {
		    logger.debug("invalid _uid=" + _uid);		    
		    return "";
		}
		
        String serverName = request.getServerName();
        int tenantId = loginService.getTenantId(serverName);
        
        LoginVO loginVO = new LoginVO();
    	
    	loginVO.setId(_uid);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");
		LoginVO resultVO = loginService.selectUserForChangePwd(loginVO);
		String result = "";
		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
			if(resultVO.getMobile() == null || resultVO.getMobile().equals("")){
				result = egovMessageSource.getMessage("login.zno000", locale);
			} else {
				/* 	SMS 솔루션 사용하는 방법은 업체별로 다르겠지만 대체로 상대 DB에 내용을 밀어주는 방법과 API를 사용하는 방법이 있다.
					가천대 길병원은 DB에 INSERT 해주는 방식을 사용하였다.
					통합 DB인 경우는 ezFlow에서 직접 해주면 되겠지만, 통합 DB가 아닌 경우에는 따로 API를 생성하여야 된다.
					
					제주대학교병원도 동일하게 DB에 INSERT를 해주는 방식을 사용한다.
					다만 웹메일이 DMZ존에 위치하여 내부망(SMS 솔루션은 내부망에 위치)에 직접 접근이 되지 않아, SMS 솔루션측에서 DMZ에서도 호출 할 수 있는 웹서비스 형태의 API를 제공하였다.
					
					두가지 방법 중 현재 본사에서 테스트 및 개발을 진행 할 수 있는 웹서비스 API 사용 방식을 우선적으로 표준에 적용
				*/
				 
				result = loginService.sendFindPwd(resultVO, locale);
				
			}
		} else {
			result = egovMessageSource.getMessage("login.zno001", locale);;
		}
		
    	logger.debug("=========================================== sendFindPwd ended ============================================");
    	return result;
    }
    
  //모바일 인증
    @RequestMapping(value = "/user/login/checkCertification.do", produces = "application/json; charset=utf-8", method=RequestMethod.POST)
    @ResponseBody
    public Object checkCertification(Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
    	logger.debug("=========================================== checkCertification ============================================");
    	
    	String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	String encCertificationNum = request.getParameter("certificationNum");
    	String encSabun = request.getParameter("sabun");
    	
    	PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
    	
    	String certificationNum = EgovFileScrty.decryptRsa(pk, encCertificationNum);
    	String sabun = EgovFileScrty.decryptRsa(pk, encSabun);
    	
    	String serverName = request.getServerName();
        int tenantId = loginService.getTenantId(serverName);
    	
    	LoginVO loginVO = new LoginVO();
    	
    	loginVO.setId(sabun);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");
		LoginVO resultVO = loginService.selectUser(loginVO);
    	
		Map<String, Object> resultMap = loginService.setCertification(resultVO.getSabun(), certificationNum, resultVO.getLocale());
		int resultKey = (Integer) resultMap.get("resultKey");
		String pwPolicyExplain = "";
		
		if (resultKey == 1) {
			String companyId = resultVO.getCompanyID();
			String usePwPatternPolicy = ezCommonService.getCompanyConfig(tenantId, companyId, "UsePasswordPatternPolicy");
			logger.debug("usePwPatternPolicy=" + usePwPatternPolicy);
			
			if (usePwPatternPolicy.equalsIgnoreCase("yes")) {
				logger.debug("certification success. get PwPolicyExplain.");
				pwPolicyExplain = commonUtil.getPwPolicyExplain(companyId, tenantId, locale);
			}
		}
		resultMap.put("pwPolicyExplain", pwPolicyExplain);

		// String result = loginService.setCertification(resultVO.getSabun(), certificationNum, resultVO.getLocale());
    	
    	logger.debug("=========================================== checkCertification ended ============================================");
    	return resultMap;
    }
    
  //모바일 인증 후 비밀번호 재설정
    @RequestMapping(value = "/user/login/changePasswordByCertification.do", produces = "text/html; charset=utf-8", method=RequestMethod.POST)
    @ResponseBody
    public String changePasswordByCertification(HttpServletRequest request, HttpServletResponse response, Locale locale) throws Exception{
    	logger.debug("=========================================== changePasswordByCertification ============================================");
    	
    	String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	String encCertificationNum = request.getParameter("certificationNum");
    	String encSabun = request.getParameter("sabun");
    	String encPwd = request.getParameter("certificationPwd");
    	String encPwdRe = request.getParameter("certificationPwdRe");
    	
    	PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
    	
    	String certificationNum = EgovFileScrty.decryptRsa(pk, encCertificationNum);
    	String sabun = EgovFileScrty.decryptRsa(pk, encSabun);
    	String pwd = EgovFileScrty.decryptRsa(pk, encPwd);
    	String pwdRe = EgovFileScrty.decryptRsa(pk, encPwdRe);
    	
    	logger.debug(sabun + "change password by certification");		    
    	
    	if (sabun == null || sabun.equals("")) {
		    logger.debug("invalid _uid=" + sabun);		    
		    return "";
		}
		
        String serverName = request.getServerName();
        int tenantId = loginService.getTenantId(serverName);
        
        LoginVO loginVO = new LoginVO();
    	
    	loginVO.setId(sabun);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");
		LoginVO resultVO = loginService.selectUser(loginVO);
    	
    	String result = "";
    	
    	if(pwd.equals("")){
    		result = "fail|비밀번호를 입력해주십시오";
    	} else{
    		String companyId = resultVO.getCompanyID();
			String userId = resultVO.getId();

			int chkPwCode = commonUtil.checkPwPolicy(pwd, companyId, tenantId, userId, false, null).getCode();
    		 if(chkPwCode > -1) {
    			 if(!pwd.equals(pwdRe)){
    				 result = "fail|변경할 비밀번호/비밀번호 확인이 일치하지 않습니다.";
    			 } else {
    				 result = loginService.setPasswordByCertification(resultVO.getSabun(), certificationNum, pwd, resultVO);
    			 }
    		 } else {
    			 String errMsg = (chkPwCode == -8 || chkPwCode == -9)? "ezOrgan.ls008" : "ezSystem.ksaPwPolicy35";
    			 result = "fail|" + egovMessageSource.getMessage(errMsg, locale);
    		 }
    	}
    	
    	logger.debug("=========================================== changePasswordByCertification ended ============================================");
    	return result;
    }
    
  //비밀번호 검증
    public boolean CheckPassword(String pwd){
    	String pwPattern = "^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,50}$";
    	Matcher matcher = Pattern.compile(pwPattern).matcher(pwd);

    	return matcher.matches();
    }
	
	//2024-07-01 김대현 비밀번호 초기화 기능
	@RequestMapping(value="/user/login/resetPw/resetPwInfo.do", method = RequestMethod.GET)
	public String resetPassword (HttpServletRequest request, HttpServletResponse response) {
		logger.debug("resetPassword");

		return "/user/login/resetPwInfo";
	}


	@ResponseBody
	@RequestMapping(value = "/user/login/resetPw/checkUserInfo.do", method = RequestMethod.POST)
	public String checkUserInfo (HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("checkUserInfo started");
		String result = "NOEXIST";

		String cn = request.getParameter("cn");
		String serverName = request.getServerName();
		int tenantId = loginService.getTenantId(serverName);

		LoginVO loginVO = new LoginVO();
		loginVO.setId(cn);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");

		LoginVO resultVO = loginService.selectUser(loginVO);

		if (resultVO != null && resultVO.getId()!= null && !"".equals(resultVO.getId())) {
			// 사용자가 존재할때
			String userName = request.getParameter("userName");

			result = userName != null && userName.equals(resultVO.getDisplayName()) ? "OK" : "DIFFNAME";
		}

		logger.debug("checkUserInfo ended");
		return result;
	}

	@RequestMapping(value = "/user/login/resetPw/authNumberPage.do", method = RequestMethod.GET)
	public String authNumberPage (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		logger.debug("authNumberPage started");
		String cn = request.getParameter("cn");
		String userName = request.getParameter("userName");

		String serverName = request.getServerName();
		int tenantId = loginService.getTenantId(serverName);

		LoginVO loginVO = new LoginVO();
		loginVO.setId(cn);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");

		LoginVO resultVO = loginService.selectUser(loginVO);

		String mobileNo = resultVO.getMobile();

		boolean useShowAuthCode = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useShowAuthCode", tenantId));
		model.addAttribute("useShowAuthCode", useShowAuthCode);

		model.addAttribute("mobileNo", mobileNo);
		model.addAttribute("cn", cn);
		model.addAttribute("userName", userName);

		logger.debug("authNumberPage ended");
		return "/user/login/authNumberPage";
	}

	// 이 URL을 호출하면 지정된 사용자의 비밀번호를 임시 비밀번호로 변경하기 때문에 필요한 사이트가 있는 경우 주석을 풀어서 사용
	/*
	@ResponseBody
	@RequestMapping(value = "/user/login/resetPw/sendAuthCodeBySMS.do")
	public String sendAuthCodeBySMS (HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {
		logger.debug("sendAuthCodeBySMS started");
		String result = "ERROR";

		String serverName = request.getServerName();
		int tenantId = loginService.getTenantId(serverName);
		String cn = request.getParameter("cn");

		String type = request.getParameter("type");
		String mobileNo = request.getParameter("mobileNo");
		mobileNo = mobileNo.replaceAll("-", "");

		Random random = new Random();
		String randomValue = "";
		// 화면에 인증코드와 임시비밀번호를 표시해주는 Flag값
		boolean useShowAuthCode = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useShowAuthCode", tenantId));

		if ("authCode".equals(type)) {
			// 인증코드
			randomValue = Integer.toString(random.nextInt(888888) + 111111);
			result = commonUtil.sendSMS(mobileNo,randomValue,type) ? "" : "FAIL";
			result = useShowAuthCode? randomValue : result;
		} else {
			// 임시비밀번호
			String tempPassword = commonUtil.getTempPassword(8);

			try {
				String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
				logger.debug("domain=" + domain);
				
				ezOrganAdminService.setPasswordWithEmailSystem(cn, domain, tempPassword, tenantId);
				// 비밀번호 초기화 컨피그
				String getPropertyValue = ezCommonService.getUserConfigInfo(tenantId, cn, "resetPassword");

				if (!getPropertyValue.equals("")) {
					ezCommonService.updateUserConfigInfo(tenantId, cn, "resetPassword", "Y");
				} else {
					ezCommonService.insertUserConfigInfo(tenantId, cn, "resetPassword", "Y");
				}

				result = commonUtil.sendSMS(mobileNo,tempPassword,type) ? "" : "FAILSMS";
				result = useShowAuthCode? tempPassword : result;

			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}

		}

		logger.debug("sendAuthCodeBySMS ended={}",result);
		return result;
	}	
	 */
	
	@PostMapping(value = "/user/login/samlAuth.do")
	public String samlAuth(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		String encodedResponse = request.getParameter("SAMLResponse");
		 
		String serverName = request.getServerName();
		int tenantId = loginService.getTenantId(serverName);
		 
		Map<String, String> samlResponse = getSamlResponse(encodedResponse);
		 
		String fullUserId = samlResponse.get("userId");
		String inResponseTo = samlResponse.get("inResponseTo");
		 
		int checkResponse = loginService.checktRequestId(inResponseTo);
		
		if (checkResponse != 1) {
			model.addAttribute("mainContent", "requestId " + inResponseTo + " not found!");
			return "ezCommon/error";
		}
		 
		if (fullUserId != null && !fullUserId.isEmpty()) {
			int atSignIndex = fullUserId.indexOf("@");

			if (atSignIndex != -1) {
				String userId = fullUserId.substring(0, atSignIndex);
				String domain = fullUserId.substring(atSignIndex + 1);

				logger.debug("samlAuth userId={},domain={}", userId, domain);

				LoginVO loginVO = new LoginVO();

				loginVO.setId(userId);
				loginVO.setTenantId(tenantId);
				;
				loginVO.setDn("NOPASSWORD");

				LoginVO resultVO = loginService.selectUser(loginVO);

				if (resultVO.getId() != null) {
					String ip = ClientUtil.getClientIP(request);
					loginVO.setIp(ip);

					loginService.updateUser(loginVO);

					String ezSessionId = createLoginCookie(userId, " ", " ", tenantId, request, response, resultVO.getDeptID(), resultVO.getCompanyID());
					String sessionCode = getSessionId(request, ezSessionId);

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

					response.sendRedirect("/ezNewPortal/newPortalMain.do");
					return null;
				}
			}
		}

		model.addAttribute("mainContent", "userId " + fullUserId + " not found!"); 
		return "ezCommon/error";
	}
	
	private Map<String, String> getSamlResponse(String encodedResponse) throws Exception {

		Map<String, String> result = new HashMap<>();
		result.put("userId", "");
		result.put("inResponseTo", "");

		try{
			byte[] decoded = Base64.getDecoder().decode(encodedResponse);

			BasicParserPool parserPool = new BasicParserPool();
			parserPool.setNamespaceAware(true);
			parserPool.initialize();

			Element element = parserPool.parse(new ByteArrayInputStream(decoded)).getDocumentElement();

			Unmarshaller unmarshaller = XMLObjectProviderRegistrySupport
					.getUnmarshallerFactory()
					.getUnmarshaller(element);

			if (unmarshaller == null) {
				return result;
			}

			XMLObject xmlObj = unmarshaller.unmarshall(element);
			Response samlResponse = (Response) xmlObj;

			NameID nameId  = samlResponse.getAssertions().get(0).getSubject().getNameID();

			if (nameId != null) {
				result.put("userId", nameId.getValue());
			}

			result.put("inResponseTo", samlResponse.getInResponseTo());

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return result;
	}
	
	private boolean checkLockedDate(int tenantID, String userId, String loginLockedDuration, String lockedDate, String nowDate) throws Exception {
		String diff = String.valueOf(commonUtil.getTimeDifference(lockedDate, nowDate));

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
