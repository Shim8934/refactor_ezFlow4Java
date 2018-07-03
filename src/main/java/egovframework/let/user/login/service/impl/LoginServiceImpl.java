package egovframework.let.user.login.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.let.user.login.dao.LoginDAO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginDeviceVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.let.utl.fcc.service.EgovNumberUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.util.ADConnection;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
    private EzEmailUserAdminService ezEmailUserAdminService;
    
    @Autowired
	private EzOrganAdminService ezOrganAdminService;
    
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
        if (loginVO != null && !loginVO.getId().equals("") && !loginVO.getPassword().equals("")) {
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
	public void updateUser(LoginVO vo) throws Exception {
		loginDAO.updateUser(vo);
	}


	@Override
	public void insertLog(LoginVO vo) throws Exception {
		loginDAO.insertLog(vo);
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
        logger.debug("getTenantIdForLocal started. serverName=" + serverName);
        
        int tenantId = -1;
        
        TenantServerNameVO tenantServerNameVO = loginDAO.selectTenantServerName(serverName);
        
        if (tenantServerNameVO != null) {
            tenantId = tenantServerNameVO.getTenantId();
        }
        
        logger.debug("getTenantIdForLocal ended. tenantId=" + tenantId);
        
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
	

}