package egovframework.ezEKP.ezJournal.dao;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezJournal.service.impl.EzJournalServiceImpl;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzJournalDAO")
public class EzJournalDAO extends EgovAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<JournaltypeVO> getJournaltypeList(Map<String, Object> param) throws Exception {
		List<JournaltypeVO> list = (List<JournaltypeVO>) list("selectJournalTypeList", param);
		return list;
	}
	
	public void updateJournaltype(Map<String, Object> param){
		update("updateJournalTypeList", param);
	}
	
	public void insertJournalAuthor(Map<String, Object> param){
		insert("insertJournalAuthor",param);
	}
}
