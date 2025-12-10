package egovframework.let.user.login.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import egovframework.com.cmm.EgovMessageSource;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.util.ADConnection;
import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.let.user.login.dao.LoginDAO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.FidoAuthenticationVO;
import egovframework.let.user.login.vo.FindPwdInfoVO;
import egovframework.let.user.login.vo.LoginDeviceVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.SessionVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovNumberUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 일반 로그인을 처리하는 비즈니스 구현 클래스
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
@Service("loginService")
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService {

    private static final Logger logger = LoggerFactory.getLogger(LoginServiceImpl.class);
            
    @Resource(name="loginDAO")
    private LoginDAO loginDAO;

    @Autowired
    private Properties config;
            
    @Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
    
    @Autowired
	private CommonUtil commonUtil;

	@Autowired
    private EzEmailUserAdminService ezEmailUserAdminService;
    
    @Autowired
	private EzOrganAdminService ezOrganAdminService;
    
    /** EgovMessageSource */
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource; 
    
    /**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    @Override
	public LoginVO selectUser(LoginVO vo) throws Exception {
        // 1. 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
        LoginVO loginVO = loginDAO.selectUser(vo);
        // 2. 결과를 리턴한다.
        if (loginVO != null && !loginVO.getId().equals("")) {
            return loginVO;
        } else {
            loginVO = new LoginVO();
        }

        return loginVO;        
    }

    /**
	 * 아이디를 찾는다.
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    @Override
	public LoginVO searchId(LoginVO vo) throws Exception {

    	// 1. 이름, 이메일주소가 DB와 일치하는 사용자 ID를 조회한다.
    	LoginVO loginVO = loginDAO.searchId(vo);

    	// 2. 결과를 리턴한다.
    	if (loginVO != null && !loginVO.getId().equals("")) {
    		return loginVO;
    	} else {
    		loginVO = new LoginVO();
    	}

    	return loginVO;
    }
    
    /**
     * 일반 로그인을 처리한다
     * @param vo LoginVO
     * @return LoginVO
     * @exception Exception
     */
    @Override
    public LoginVO selectUserForChangePwd(LoginVO vo) throws Exception {
    	// 1. 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
    	LoginVO loginVO = loginDAO.selectUserForChangePwd(vo);
    	// 2. 결과를 리턴한다.
    	if (loginVO != null && !loginVO.getId().equals("") && !loginVO.getPassword().equals("")) {
    		return loginVO;
    	} else {
    		loginVO = new LoginVO();
    	}
    	
    	return loginVO;        
    }

    /**
	 * 비밀번호를 찾는다.
	 * @param vo LoginVO
	 * @return boolean
	 * @exception Exception
	 */
    @Override
	public boolean searchPassword(LoginVO vo) throws Exception {

    	boolean result = true;

    	// 1. 아이디, 이름, 이메일주소, 비밀번호 힌트, 비밀번호 정답이 DB와 일치하는 사용자 Password를 조회한다.
    	LoginVO loginVO = loginDAO.searchPassword(vo);
    	if (loginVO == null || loginVO.getPassword() == null || loginVO.getPassword().equals("")) {
    		return false;
    	}

    	// 2. 임시 비밀번호를 생성한다.(영+영+숫+영+영+숫=6자리)
    	String newpassword = "";
    	for (int i = 1; i <= 6; i++) {
    		// 영자
    		if (i % 3 != 0) {
    			newpassword += EgovStringUtil.getRandomStr('a', 'z');
    		// 숫자
    		} else {
    			newpassword += EgovNumberUtil.getRandomNum(0, 9);
    		}
    	}

    	// 3. 임시 비밀번호를 암호화하여 DB에 저장한다.
    	LoginVO pwVO = new LoginVO();
    	String enpassword = EgovFileScrty.encryptPassword(newpassword, vo.getId());
    	pwVO.setId(vo.getId());
    	pwVO.setPassword(enpassword);
    	pwVO.setUserSe(vo.getUserSe());
    	loginDAO.updatePassword(pwVO);


    	return result;
    }

	@Override
	public boolean searchOtpKey(LoginVO vo) throws Exception {
		return loginDAO.searchOtpKey(vo) > 0;
	}

	@Override
	public void updateUser(LoginVO vo) throws Exception {
		loginDAO.updateUser(vo);
	}

	@Override
	public void updateUserForReduceLoginCnt(LoginVO vo) throws Exception {
		loginDAO.updateUserForReduceLoginCnt(vo);
	}

	@Override
	public void insertLog(LoginVO vo) throws Exception {
		loginDAO.insertLog(vo);
	}

	@Override
	public void updateDbSessionLog(HashMap<String, Object> map) throws Exception {
		loginDAO.updateDbSessionLog(map);
	}

	@Override
	public void insertSession(SessionVO vo) throws Exception {
		loginDAO.insertSession(vo);
	}

	@Override
	public void updateSession(String ezSessionId, String loginCookie) throws Exception {
		Map<String, String> map = new HashMap<>();
		map.put("ezSessionId", ezSessionId);
		map.put("loginCookie", loginCookie);
		
		loginDAO.updateSession(map);
	}

	@Override
	public void deleteSession(String ezSessionId) throws Exception {
		loginDAO.deleteSession(ezSessionId);
	}

	@Override
	public SessionVO getSession(String ezSessionId) throws Exception {
		return loginDAO.getSession(ezSessionId);
	}

	@Override
	public void deleteDbSessionByTime() throws Exception {
		String deSessionStoragePeriodStr = ezCommonService.getTenantConfig("dbSessionStoragePeriod", 0); // DB에서 컨트롤 하기 위해 tenant 컨피그를 사용하며, 0번을 default로 사용 함

		if (StringUtils.isNotBlank(deSessionStoragePeriodStr)) {
			int dbSessionStoragePeriod = Integer.parseInt(deSessionStoragePeriodStr);
			loginDAO.deleteDbSessionByTime(dbSessionStoragePeriod);
		}
	}

	@Override
	public List<Integer> getTenantIdList() throws Exception {
		List<Integer> tenantIdList = loginDAO.getTenantIdList();
		return tenantIdList;
	}

	@Override
	public void updateLog(LoginVO vo) throws Exception {
		loginDAO.updateLog(vo);		
	}
	
	
	@Override
	public List<String> getUserIDList() throws Exception {
		return loginDAO.getUserIDList();
	}


	@Override
	public void updatePassword(String userID, String pwd) throws Exception {
		LoginVO pwVO = new LoginVO();
		
		pwVO.setId(userID);
		pwVO.setPassword(pwd);
		
		loginDAO.updatePassword(pwVO);
	}
	
    private int getTenantIdForLocal(String serverName) throws Exception {
        //logger.debug("getTenantIdForLocal started. serverName=" + serverName); // 로그정리
        
        int tenantId = -1;
        
        TenantServerNameVO tenantServerNameVO = loginDAO.selectTenantServerName(serverName);
        
        if (tenantServerNameVO != null) {
            tenantId = tenantServerNameVO.getTenantId();
        }
        
        //logger.debug("getTenantIdForLocal ended. tenantId=" + tenantId); // 로그정리 : 상하 로그에서 tenantId 값을 확인가능
        
        return tenantId;
    }
	
    @Override
    public int getTenantId(String serverName) throws Exception {
    	return getTenantIdForLocal(serverName);
    }

	@Override
	public LoginVO selectReceiver(String userID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("id", userID);
		map.put("tenantId", tenantID);
		return loginDAO.selectReceiver(map);
	}
	
	@Override
	public List<LoginVO> selectAllReceivers(String userID, int tenantID) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("id", userID);
		map.put("tenantId", tenantID);
		return loginDAO.selectAllReceivers(map);
	}
	
	@Override
	public List<LoginVO> selectAllMemberOfCompany(String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("company_id", companyID);
		map.put("tenantId", tenantID);
		return loginDAO.selectAllMemberOfCompany(map);		
	}

	@Override
	public void setFidoSession(FidoAuthenticationVO vo) throws Exception {
		loginDAO.setFidoSession(vo);
	}

	@Override
	public FidoAuthenticationVO getFidoSession(String fidoSessionId) throws Exception {
		return loginDAO.getFidoSession(fidoSessionId);
	}

	@Override
	public void updateFidoStatus(FidoAuthenticationVO vo) throws Exception {
		loginDAO.updateFidoStatus(vo);
	}

	@Override
	public void deleteFidoSessionByTime() throws Exception {
		int fidoStoragePeriod = Integer.parseInt(ezCommonService.getTenantConfig("FidoStoragePeriod", 0)); // fidoStoragePeriod는 일 기준
		loginDAO.deleteFidoSessionByTime(fidoStoragePeriod);
	}

	/**
     * Active Directory
     * - AD 암호로 그룹웨어 암호 변경
     * */
    public String chkADAndUpdatePassword(String uid, String rpwd, int tenantId) throws Exception {
    	
    	ADConnection conn = new ADConnection();
    	
    	String address = config.getProperty("config.PROVIDER_URL");   	
     	String security = uid + "@" + config.getProperty("config.Domain_Name");
    	
    	String chk = conn.setConnection(address, security, rpwd);
    	
    	if (chk.equalsIgnoreCase("TRUE")) {
    		/**
    		 * 비밀 번호를 변경해야할 것들
    		 * 1. 그룹웨어 비밀번호
    		 * 2. 이메일 비밀번호 
    		 * */
    		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
    		String mailAddr = uid + "@" + domain;

    		ezEmailUserAdminService.updateUserPassword(mailAddr, rpwd);
    		ezOrganAdminService.setPasswordExceptAD(uid, rpwd, tenantId);
    		
//    		//email 비밀번호 변경 확인
//    		IMAPAccess ia = null;
//    		ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
//    				mailAddr, rpwd, egovMessageSource, locale);
//    		ia.getTopLevelFolders();    		
    	}		

    	return chk;
    }
    

	@Override
	public LoginDeviceVO getDeviceInfo(String devId) throws Exception {
		logger.debug("getDeviceInfo started.");
		
		Map<String , Object> map = new HashMap<String, Object>();
		
		map.put("devId", devId);
		
		LoginDeviceVO info = loginDAO.getDeviceInfo(map);
		
		if (info != null) {
			logger.debug("userId=" + info.getUserId());
			logger.debug("devId=" + info.getDevId());
		}
		
		logger.debug("getDeviceInfo ended.");
		
		return info;
	}

	@Override
	public int insertDeviceInfo(String devId, String devType, String subType, String userId, String token, String badge,
			String tenantId, String state, String pushState, String regDate, String isLogin, String startMenu,
			String loginTime, String loginLock, String isPasswordChange, String extension1, String extesion2) throws Exception {
		logger.debug("insertDeviceInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("devId", devId);
		map.put("devType", devType);
		map.put("subType", subType);
		map.put("userId", userId);
		map.put("token", token);
		map.put("badge", badge);
		map.put("tenantId", tenantId);
		map.put("state", state);
		map.put("pushState", pushState);
		map.put("regDate", regDate);
		map.put("isLogin", isLogin);
		map.put("startMenu", startMenu);
		map.put("loginTime", loginTime);
		map.put("loginLock", loginLock);
		map.put("isPasswordChange", isPasswordChange);
		map.put("extension1", extension1);
		map.put("extesion2", extesion2);
		
		int result = loginDAO.insertDeviceInfo(map);
		
		if (result <= 0) {
			logger.debug("fail! updateDeviceInfo.");
		}
		
		logger.debug("insertDeviceInfo ended.");
		
		return result;
	}

	@Override
	public int updateDeviceInfo(String devId, String devType, String subType, String userId, String token, String badge,
			String tenantId, String state, String pushState, String isLogin, String startMenu,
			String loginTime, String loginLock, String isPasswordChange, String extension1, String extension2) throws Exception {
		logger.debug("updateDeviceInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("devId", devId);
		map.put("devType", devType);
		map.put("subType", subType);
		map.put("userId", userId);
		map.put("token", token);
		map.put("badge", badge);
		map.put("tenantId", tenantId);
		map.put("state", state);
		map.put("pushState", pushState);
		map.put("isLogin", isLogin);
		map.put("startMenu", startMenu);
		map.put("loginTime", loginTime);
		map.put("loginLock", loginLock);
		map.put("isPasswordChange", isPasswordChange);
		map.put("extension1", extension1);
		map.put("extension2", extension2);
		
		int result = loginDAO.updateDeviceInfo(map);
		
		if (result <= 0) {
			logger.debug("fail! updateDeviceInfo.");
		}
		
		logger.debug("updateDeviceInfo ended.");

		return result;
	}
	
	/**
	 *
	 */
	@Override
	public CountryVO getLoginIPCountry(long loginIP) throws Exception {
		logger.debug("getLoginIPCountry started.");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("loginIP", loginIP);
		
		CountryVO result = loginDAO.getLoginIPCountry(paramMap);
		
		
		logger.debug("getLoginIPCountry ended.");
		return result;
	}
	
	@Override
	public String sendFindPwd(LoginVO vo, Locale locale) throws Exception {
		logger.debug("sendFindPwd started.");
		String result = "";
		String randomNumber = getAutoNumber();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH-mm");
		String now = sdf.format(System.currentTimeMillis());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("certificationNum", randomNumber);
		map.put("sabun", vo.getSabun());
		map.put("certification", "N");
		map.put("phoneNum", vo.getMobile());
		map.put("nowDate", now);
		
		int fidPwd = loginDAO.insertTblFindPwd(map);
		
		if(fidPwd > 0){
			try {
				String smsSolutionURL = ezCommonService.getTenantConfig("smsSolutionURL", vo.getTenantId());
				
				String sGubun = "sGubun=GETQUERY";
				String sParam = "sParam=<Table>"
						+ "<QID><![CDATA[PK_HOMEPAGE_S19]]></QID>"	// 고정값
						+ "<QTYPE><![CDATA[Package]]></QTYPE>"		// 고정값
						+ "<USERID><![CDATA[SUA]]></USERID>"		// 고정값
						+ "<EXECTYPE><![CDATA[FILL]]></EXECTYPE>"	// 고정값
						+ "<TABLENAME><![CDATA[]]></TABLENAME>"		// 고정값
						+ "<P0><![CDATA[" + "MsgTitle" + "]]></P0>"				// 문자제목
						// 인증번호는 Random 메소드를 이용하여 6자리 생성하여 보냄
						+ "<P1><![CDATA[" + egovMessageSource.getMessage("login.zno002", locale) + " " + randomNumber  + egovMessageSource.getMessage("login.zno003", locale) + "]]></P1>"		// 문자내용
						+ "<P2><![CDATA[" + vo.getMobile() + "]]></P2>"		// 문자 보내는 사람 번호
						+ "<P3><![CDATA[" + vo.getMobile() + "]]></P3>"		// 문자 받는 사람 번호
						+ "</Table>";
				
				String inputParams = sGubun + "&" + sParam;
				logger.debug("inputParams=" + inputParams);
				
				String strJson = getWebServiceResult(smsSolutionURL, inputParams);
				logger.debug("strJson=" + strJson);

				result = vo.getMobile() + " " + egovMessageSource.getMessage("login.zno004", locale);
			} catch (Exception e) {
				result = egovMessageSource.getMessage("login.zno005", locale);
				logger.error(e.getMessage(), e);
			}
		} else {
			result = egovMessageSource.getMessage("login.zno005", locale);
		}
		
		logger.debug("sendFindPwd ended.");
		return result;
	}
	
	@Override
	public Map<String, Object> setCertification(String sabun, String certificationNum, Locale locale) throws Exception {
		logger.debug("setCertification ended.");
		logger.debug("sabun = " + sabun + ", certificationNum = " + certificationNum);
		int resultKey = 0; // 1:인증성공, -1:잘못된인증번호
		String result = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("certificationNum", certificationNum);
		map.put("sabun", sabun);
		
		FindPwdInfoVO findPwdInfo = loginDAO.getFindPwdInfo(map);
		
		if(findPwdInfo == null){
			result = egovMessageSource.getMessage("login.zno016", locale);
		} else if(!findPwdInfo.getCertification_Num().equals(certificationNum)) {
			result = egovMessageSource.getMessage("login.zno017", locale);
			resultKey = -1;
		} else {
			Calendar nowCal = Calendar.getInstance();
			nowCal.setTime(new Date());
			nowCal.add(Calendar.MINUTE, -3);
			
			Calendar reqCal = Calendar.getInstance();
			reqCal.setTime(findPwdInfo.getReq_Date());
			
			if(nowCal.compareTo(reqCal) > 0){
				result = egovMessageSource.getMessage("login.zno018", locale);
			} else if(findPwdInfo.getCertification().equals("Y")){
				result = egovMessageSource.getMessage("login.zno019", locale);
			} else {
				map.put("certification", "Y");
				
				int fidPwd = loginDAO.updateTblFindPwd(map);
				
				if(fidPwd > 0){
					result = egovMessageSource.getMessage("login.zno020", locale);
					resultKey = 1;
				} else {
					result = egovMessageSource.getMessage("login.zno017", locale);
				}
			}
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultMsg", result);
		resultMap.put("resultKey", resultKey);
		
		logger.debug("setCertification ended.");
		return resultMap;
	}
	
	@Override
	public String setPasswordByCertification(String sabun, String certificationNum, String password, LoginVO loginVO) throws Exception {
		logger.debug("setPasswordByCertification started.");
		String result = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("certificationNum", certificationNum);
		map.put("sabun", sabun);
		
		FindPwdInfoVO findPwdInfo = loginDAO.getFindPwdInfo(map);
		
		String domain = ezCommonService.getTenantConfig("DomainName", loginVO.getTenantId());
		
		if(findPwdInfo == null){
			result = "fail|" + egovMessageSource.getMessage("login.zno021", loginVO.getLocale());
		} else {
			if(findPwdInfo.getCertification().equals("N") || !findPwdInfo.getCertification_Num().equals(certificationNum)){
				result = "fail|" + egovMessageSource.getMessage("login.zno022", loginVO.getLocale());
			} else if(findPwdInfo.getCertification().equals("C")){
				result = "fail|" + egovMessageSource.getMessage("login.zno021", loginVO.getLocale());
			} else {
				try {
					ezOrganAdminService.setPasswordWithEmailSystem(loginVO.getId(), domain, password, loginVO.getTenantId());
					
					map.put("certification", "C");
					int fidPwd = loginDAO.updateTblFindPwd(map);
					
					if(fidPwd > 0){
						loginDAO.updateLogincnt(loginVO);
						result = "success|" + egovMessageSource.getMessage("login.zno023", loginVO.getLocale());
					} else {
						result = "fail|" + egovMessageSource.getMessage("login.zno024", loginVO.getLocale());
					}
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
					result = "fail|" + egovMessageSource.getMessage("login.zno024", loginVO.getLocale());
				}
			}
		}
		
		logger.debug("setPasswordByCertification ended.");
		return result;
	}
	
	public String getWebServiceResult(String urlString, String inputParams) throws Exception {
		logger.debug("urlString=" + urlString);
		
		String result = null;
		
		URL url = new URL(urlString);
		HttpURLConnection conn = null;
				
		try {
			conn = (HttpURLConnection) url.openConnection();
			
			// POST 방식으로 요청한다.
			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");	
			
			// 입력 패러메터값이 있는 경우엔 HTTP Body로 출력한다.
			if (inputParams != null) {
				OutputStream os = conn.getOutputStream();
				// UTF-8로 인코딩한다.
				os.write(inputParams.getBytes("UTF-8"));
				os.flush();
			}
			
			if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
				// Response Body를 UTF-8로서 디코딩한다.			
				BufferedReader br = new BufferedReader(
											new InputStreamReader(conn.getInputStream(),"UTF-8")
											);
	
				StringBuilder sb = new StringBuilder();
				String output;
				
				while ((output = br.readLine()) != null) {
					sb.append(output);
				}
				
				result = sb.toString();
				
				conn.disconnect();		
				conn = null;
			} else {
				Exception e = new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());			
				
				throw e;
			} 
		} finally {
			if (conn != null) {
				conn.disconnect();
				conn = null;
			}
		}
		
		return result;
	} 
    
    // 20200424 조진호 - SMS 솔루션 6자리 인증번호 생성
    public String getAutoNumber() throws Exception {
    	Random random = new SecureRandom();
    	
    	int certNumLength = 6;
    	
        int range = (int)Math.pow(10,certNumLength);
        int trim = (int)Math.pow(10, certNumLength-1);
        int result = random.nextInt(range)+trim;
         
        if(result>range){
            result = result - trim;
        }
        
        return String.valueOf(result);

    }

	@Override
	public boolean userDeviceCnt(String cn) throws Exception {
		logger.debug("userDeviceChk started");
		
		Map<String, Object> map = new HashMap<>();
		map.put("CN", cn);
		
		boolean result = loginDAO.userDeviceCnt(map) > 0;
		return result;
	}

	@Override
	public int insertRequestId(String requestId) throws Exception {
		
		return loginDAO.insertRequestId(requestId);
	}

	@Override
	public int checktRequestId(String requestId) throws Exception {
		
		int checkResult = loginDAO.selectRequestId(requestId);
		
		if(checkResult == 1) {
			loginDAO.deleteRequestId(requestId);
		}
		return checkResult;
	}
	
	@Override
	@Scheduled(cron = "00 00 05 * * *")
	public void deleteSamlRequestIdScheduler() throws Exception {
		logger.debug("deleteSamlRequestId scheduler started.");
		
		loginDAO.deleteSamlRequestIdScheduler();
		
		logger.debug("deleteSamlRequestId scheduler ended");
	}
}