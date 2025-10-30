package egovframework.let.user.login.dao;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.let.user.login.vo.FidoAuthenticationVO;
import egovframework.let.user.login.vo.FindPwdInfoVO;
import egovframework.let.user.login.vo.LoginDeviceVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.SessionVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
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
@Repository("loginDAO")
public class LoginDAO extends EgovAbstractDAO {

    private static final Logger logger = LoggerFactory.getLogger(LoginDAO.class);
                
    @Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
        
	/**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO selectUser(LoginVO vo) throws Exception {
		String useEmpNumberLogin = ezCommonService.getTenantConfig("UseEmpNumberLogin", vo.getTenantId());
		
		if (useEmpNumberLogin.equals("YES")) {
			logger.debug("calling loginDAO.selectUser");
			
			return (LoginVO)select("loginDAO.selectUser", vo);
		} else { 
			logger.debug("calling loginDAO.selectUserWithCnOnly");
			
			return (LoginVO)select("loginDAO.selectUserWithCnOnly", vo);
		}
    }
    
    /**
	 * 아이디를 찾는다.
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO searchId(LoginVO vo) throws Exception {

    	return (LoginVO)select("loginDAO.searchId", vo);
    }

    /**
	 * 비밀번호를 찾는다.
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO searchPassword(LoginVO vo) throws Exception {

    	return (LoginVO)select("loginDAO.searchPassword", vo);
    }
    
	private int searchOtpKeyForLocal(LoginVO vo) throws Exception {
		return (int) select("loginDAO.searchOtpKey", vo);
	}

	public int searchOtpKey(LoginVO vo) throws Exception {
		return searchOtpKeyForLocal(vo);
	}

    private void updatePasswordForLocal(LoginVO vo) throws Exception {
        update("loginDAO.updatePassword", vo);
    }
    
    /**
	 * 변경된 비밀번호를 저장한다.
	 * @param vo LoginVO
	 * @exception Exception
	 */
    public void updatePassword(LoginVO vo) throws Exception {
    	updatePasswordForLocal(vo);       
    }
        
    private void updateUserForLocal(LoginVO vo) throws Exception {
        update("loginDAO.updateUser", vo);
    }
    
    public void updateUser(LoginVO vo) throws Exception {
    	updateUserForLocal(vo);       
    }
    
    private void updateUserForReduceLoginCntForLocal(LoginVO vo) throws Exception {
        update("loginDAO.updateUserForReduceLoginCnt", vo);
    }

    public void updateUserForReduceLoginCnt(LoginVO vo) throws Exception {
    	updateUserForReduceLoginCntForLocal(vo);
    }

    private void insertLogForLocal(LoginVO vo) throws Exception {
        update("loginDAO.insertLog", vo);
    }
    
    public void insertLog(LoginVO vo) throws Exception {
    	insertLogForLocal(vo);       
    }

	private void updateDbSessionLogForLocal(HashMap<String, Object> map) throws Exception {
		update("loginDAO.updateDbSessionLog", map);
	}

	public void updateDbSessionLog(HashMap<String, Object> map) throws Exception {
		updateDbSessionLogForLocal(map);
	}

	private void insertSessionForLocal(SessionVO vo) throws Exception {
		update("loginDAO.insertSession", vo);
	}

	public void insertSession(SessionVO vo) throws Exception {
		insertSessionForLocal(vo);
	}

	public void updateSession(Map<String, String> map) throws Exception {
		updateSessionForLocal(map);
	}

	private void updateSessionForLocal(Map<String, String> map) throws Exception {
		update("loginDAO.updateSession", map);
	}

	public void deleteSession(String ezSessionId) throws Exception {
		deleteSessionForLocal(ezSessionId);
	}

	private void deleteSessionForLocal(String ezSessionId) throws Exception {
		update("loginDAO.deleteSession", ezSessionId);
	}

	public SessionVO getSession(String ezSessionId) throws Exception {
		return getSessionForLocal(ezSessionId);
	}

	private SessionVO getSessionForLocal(String ezSessionId) throws Exception {
		return (SessionVO) select("loginDAO.getSession", ezSessionId);
	}

	public void deleteDbSessionByTime(int dbSessionStoragePeriod) throws Exception {
		update("loginDAO.deleteDbSessionByTime", dbSessionStoragePeriod);
	}

	public List<Integer> getTenantIdList() throws Exception {
		return (List<Integer>) list("loginDAO.getTenantIdList");
	}

    private void updateLogForLocal(LoginVO vo) throws Exception {
        update("loginDAO.updateLog", vo);
    }
    
    public void updateLog(LoginVO vo) throws Exception {
    	updateLogForLocal(vo);
    }
    
	@SuppressWarnings("unchecked")
	public List<String> getUserIDList() throws Exception{
		return (List<String>) list("loginDAO.getUserIDList");
	}
	
    public TenantServerNameVO selectTenantServerName(String serverName) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();        
        map.put("serverName", serverName);
        
        return (TenantServerNameVO)select("loginDAO.selectTenantServerName", map);
    }
 
	public LoginVO selectReceiver(Map<String, Object> map) throws Exception {
        return (LoginVO) select("loginDAO.selectReceiver", map);
    }
	
    @SuppressWarnings("unchecked")
	public List<LoginVO> selectAllReceivers(Map<String, Object> map) throws Exception {
        return (List<LoginVO>) list("loginDAO.selectAllReceivers", map);
    }
    
	@SuppressWarnings("unchecked")
	public List<LoginVO> selectAllMemberOfCompany(Map<String, Object> map) throws Exception {
        return (List<LoginVO>) list("loginDAO.selectAllMemberOfCompany", map);
    }
	
	public void setFidoSession(FidoAuthenticationVO vo) throws Exception {
		update("loginDAO.setFidoSession", vo);
	}

	public FidoAuthenticationVO getFidoSession(String fidoSessionId) throws Exception {
		logger.debug("getFidoSession DAO : {}", fidoSessionId);
		return (FidoAuthenticationVO) select ("loginDAO.getFidoSession", fidoSessionId);
	}

	public void updateFidoStatus(FidoAuthenticationVO vo) throws Exception {
		update("loginDAO.updateFidoStatus", vo);
	}

	public void deleteFidoSessionByTime(int fidoStoragePeriod) throws Exception {
		update("loginDAO.deleteFidoSessionByTime", fidoStoragePeriod);
	}

	public LoginDeviceVO getDeviceInfo (Map<String, Object> map) throws Exception {
		return (LoginDeviceVO) select("loginDAO.getDeviceInfo", map);
	}

	public int insertDeviceInfo (Map<String, Object> map) throws Exception {
		return update("loginDAO.insertDeviceInfo", map);
	}
	
	public int updateDeviceInfo (Map<String, Object> map) throws Exception {
		return update("loginDAO.updateDeviceInfo", map);
	}
	
	public CountryVO getLoginIPCountry(Map<String, Object> paramMap) throws Exception {
		return (CountryVO) select("loginDAO.getLoginIPCountry", paramMap);
	}
	
	public LoginVO selectUserForChangePwd(LoginVO vo) throws Exception {
		logger.debug("calling loginDAO.selectUserForChangePwd");
		
		return (LoginVO)select("loginDAO.selectUserForChangePwd", vo);
	}
	
	public FindPwdInfoVO getFindPwdInfo(Map<String, Object> paramMap) throws Exception {
		return (FindPwdInfoVO) select("loginDAO.getFindPwdInfo", paramMap);
	}
	
	public int updateTblFindPwd (Map<String, Object> map) throws Exception {
		return update("loginDAO.updateTblFindPwd", map);
	}
	
	public int insertTblFindPwd (Map<String, Object> map) throws Exception {
		return update("loginDAO.insertTblFindPwd", map);
	}
	
	public int updateLogincnt (LoginVO vo) throws Exception {
		return update("loginDAO.updateLogincnt", vo);
	}
	public int userDeviceCnt(Map<String, Object> map) throws Exception {
		return (int)select("loginDAO.userDeviceCnt", map);
	}
	
	public int insertRequestId(String requestId) throws Exception {
		return update("loginDAO.insertRequestId", requestId);
	}
	
	public int selectRequestId(String requestId) throws Exception {
		return (int) select("loginDAO.selectRequestId", requestId);
	}

	public int deleteRequestId(String requestId) throws Exception {
		return update("loginDAO.deleteRequestId", requestId);
	}
	
	public void deleteSamlRequestIdScheduler() throws Exception {
		update("loginDAO.deleteSamlRequestIdScheduler");
	}
}
