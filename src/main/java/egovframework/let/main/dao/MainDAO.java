package egovframework.let.main.dao;

import egovframework.let.main.vo.MainVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

@Repository("mainDAO")
public class MainDAO extends EgovAbstractDAO {

    private static final Logger logger = LoggerFactory.getLogger(MainDAO.class);
        
	/**
	 * 관리자 접속 로그를 입력한다
	 * @param vo MainVO
	 * @exception Exception
	 */
    
    private void insertAdminLogForLocal(MainVO vo) throws Exception {
        update("mainDAO.insertAdminLog", vo);
    }
    
    public void insertAdminLog(MainVO vo) throws Exception {
    	insertAdminLogForLocal(vo);       
    }
}
