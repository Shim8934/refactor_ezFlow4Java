package egovframework.let.user.login.dao;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

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

	/**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO selectUser(LoginVO vo) throws Exception {
    	return (LoginVO)select("loginDAO.selectUser", vo);
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

    /**
	 * 변경된 비밀번호를 저장한다.
	 * @param vo LoginVO
	 * @exception Exception
	 */
    public void updatePassword(LoginVO vo) throws Exception {
    	update("loginDAO.updatePassword", vo);
    }
    
    public void updateUser(LoginVO vo) throws Exception {
    	update("loginDAO.updateUser", vo);
    }
    
    public void insertLog(LoginVO vo) throws Exception {
    	update("loginDAO.insertLog", vo);
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
 
	
}
