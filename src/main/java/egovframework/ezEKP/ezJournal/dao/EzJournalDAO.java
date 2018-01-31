package egovframework.ezEKP.ezJournal.dao;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezJournal.service.impl.EzJournalServiceImpl;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzJournalDAO")
public class EzJournalDAO extends EgovAbstractDAO {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalDAO.class);
	
	@SuppressWarnings("unchecked")
	public List<JournalFormInfoVO> getFormList(Map<String, Object> map) {
		return (List<JournalFormInfoVO>) list("getFormList", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getFormUseDeptList(Map<String, Object> map) {
		return (List<String>) list("getFormUseDeptList", map);
	}

	@SuppressWarnings("unchecked")
	public List<JournalFormInfoVO> getDeptUseFormList(Map<String, Object> map) {
		return (List<JournalFormInfoVO>) list("getDeptUseFormList", map);
	}

	@SuppressWarnings("unchecked")
	public List<JournalFormInfoVO> getBasicFormList(Map<String, Object> map) {
		return (List<JournalFormInfoVO>) list("getBasicFormList", map);
	}

	public void insertForm(Map<String, Object> map) {
		System.out.println("DAO오는지");
		insert("insertForm", map);
		System.out.println("DAO insert확인");
	}

	public void insertUseDept(Map<String, Object> map) {
		System.out.println("DAO 부서 오는지");
		insert("insertUseDept", map);
		System.out.println("DAO 부서 확인");
	}


	
	

}
