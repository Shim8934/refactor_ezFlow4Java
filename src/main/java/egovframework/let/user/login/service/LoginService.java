package egovframework.let.user.login.service;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.let.user.login.vo.FidoAuthenticationVO;
import egovframework.let.user.login.vo.LoginDeviceVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.SessionVO;


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
public interface LoginService {

	/**
	 * 일반 로그인을 처리한다
	 * @return LoginVO
	 * 
	 * @param vo    LoginVO
	 * @exception Exception Exception
	 */
	public LoginVO selectUser(LoginVO vo) throws Exception;
	
	/**
	 * 아이디를 찾는다.
	 * @return LoginVO
	 * 
	 * @param vo    LoginVO
	 * @exception Exception Exception
	 */
	public LoginVO searchId(LoginVO vo) throws Exception;	

	/**
	 * 비밀번호를 찾는다.
	 * @return boolean
	 * 
	 * @param vo    LoginVO
	 * @exception Exception Exception
	 */
	public boolean searchPassword(LoginVO vo) throws Exception;
	
	boolean searchOtpKey(LoginVO vo) throws Exception;

	public void updateUser(LoginVO vo) throws Exception;
	
	void updateUserForReduceLoginCnt(LoginVO vo) throws Exception;

	public void insertLog(LoginVO vo) throws Exception;

	void updateDbSessionLog(HashMap<String, Object> map) throws Exception;

	void insertSession(SessionVO vo) throws Exception;

	void updateSession(String ezSessionId, String loginCookie) throws Exception;

	void deleteSession(String ezSessionId) throws Exception;

	SessionVO getSession(String ezSessionId) throws Exception;

	void deleteDbSessionByTime() throws Exception;

	List<Integer> getTenantIdList() throws Exception;

	public void updateLog(LoginVO vo) throws Exception;
	
	public List<String> getUserIDList() throws Exception;

	public void updatePassword(String userID, String pwd) throws Exception;
	
	public int getTenantId(String serverName) throws Exception;

	public LoginVO selectReceiver(String userID, int tenantID) throws Exception;
	
	public List<LoginVO> selectAllReceivers(String userID, int tenantID) throws Exception;
	
	public List<LoginVO> selectAllMemberOfCompany(String companyID, int tenantID) throws Exception;

	void setFidoSession(FidoAuthenticationVO vo) throws Exception;

	FidoAuthenticationVO getFidoSession(String fidoSessionId) throws Exception;
	
	void updateFidoStatus(FidoAuthenticationVO vo) throws Exception;

	void deleteFidoSessionByTime() throws Exception;

	public String chkADAndUpdatePassword(String uid, String upwd, int tenantId) throws Exception;
	
	public LoginDeviceVO getDeviceInfo(String devId) throws Exception;
	
	public int insertDeviceInfo(String devId, String devType, String subType, String userId, String token, String badge, String tenantId,
			String state, String pushState, String regDate, String isLogin, String startMenu, String loginTime, String loginLock,
			String isPasswordChange, String extension1, String extension2) throws Exception;
	
	public int updateDeviceInfo(String devId, String devType, String subType, String userId, String token, String badge, String tenantId,
			String state, String pushState, String isLogin, String startMenu, String loginTime, String loginLock,
			String isPasswordChange, String extension1, String extension2) throws Exception;

	public CountryVO getLoginIPCountry(long loginIP) throws Exception;
	
	public String sendFindPwd(LoginVO vo, Locale locale) throws Exception;
	
	public LoginVO selectUserForChangePwd(LoginVO vo) throws Exception;
	
	public Map<String, Object> setCertification(String sabun, String certificationNum, Locale locale) throws Exception;
	
	public String setPasswordByCertification(String sabun, String certificationNum, String password, LoginVO loginVO) throws Exception;

	boolean userDeviceCnt(String cn) throws Exception;
	
	public int insertRequestId(String requestId) throws Exception;
	
	public int checktRequestId(String requestId) throws Exception;
	
	public void deleteSamlRequestIdScheduler() throws Exception;
}