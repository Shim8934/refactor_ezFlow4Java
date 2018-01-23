package egovframework.ezEKP.ezJournal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzJournalAdminDAO")
public class EzJournalAdminDAO extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<JournaltypeVO> getJournaltypeList(Map<String, Object> map) {
		return  (List<JournaltypeVO>) list("EzJournalAdminDAO.getJournaltypeList", map);
	}
	
	

}
