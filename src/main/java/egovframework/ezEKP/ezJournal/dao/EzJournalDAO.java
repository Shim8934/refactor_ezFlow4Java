package egovframework.ezEKP.ezJournal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
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
		insert("insertForm", map);
	}

	public void insertUseDept(Map<String, Object> map) {
		insert("insertUseDept", map);
	}
}
