package egovframework.ezEKP.ezJournal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezJournal.vo.DeptViewVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthorVO;
import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzJournalDAO")
public class EzJournalDAO extends EgovAbstractDAO{

	/**
	 * 일지함 리스트 세럭트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<JournaltypeVO> getJournaltypeList(Map<String, Object> param) throws Exception {
		List<JournaltypeVO> list = (List<JournaltypeVO>) list("selectJournalTypeList", param);
		return list;
	}
	
	/**
	 * 일지함 사용여부 변경
	 * @param param
	 */
	public void updateJournaltype(Map<String, Object> param){
		update("updateJournalTypeList", param);
	}
	
	/**
	 * 열람권한 등록
	 * @param param
	 */
	public void insertJournalAuthor(Map<String, Object> param){
		insert("insertJournalAuthor",param);
	}

	/**
	 * 양식 리스트 세럭트
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalFormInfoVO> getFormList(Map<String, Object> map) {
		return (List<JournalFormInfoVO>) list("getFormList", map);
	}

	/**
	 * 양식 사용가능 부서 리스트
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<String> getFormUseDeptList(Map<String, Object> map) {
		return (List<String>) list("getFormUseDeptList", map);
	}

	/**
	 * 부서에서 쓸 수 있는 양식 리스트
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalFormInfoVO> getDeptUseFormList(Map<String, Object> map) {
		return (List<JournalFormInfoVO>) list("getDeptUseFormList", map);
	}

	/**
	 * 기본양식 리스트
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalFormInfoVO> getBasicFormList(Map<String, Object> map) {
		return (List<JournalFormInfoVO>) list("getBasicFormList", map);
	}

	/**
	 * 양식 등록
	 * @param map
	 */
	public void insertForm(Map<String, Object> map) {
		insert("insertJournalForm", map);
	}

	/**
	 * 양식 사용 부서 등록
	 * @param map
	 */
	public void insertUseDept(Map<String, Object> map) {
		insert("insertUseDept", map);
	}
	
	/**
	 * 회사 리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalCompanyVO> getCompanyList(Map<String, String> map){
		return (List<JournalCompanyVO>) list("selectCompanyList",map);
	}
	
	/**
	 * 열람권한자 리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalAuthorVO> getAuthorList(Map<String, String> map){
		return (List<JournalAuthorVO>) list("selectAuthorList",map);
	}
	
	/**
	 * 권한자의 권한부서 리스트
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalAuthorVO> getAuthDeptList(Map<String, String> map){
		return (List<JournalAuthorVO>) list("selectAuthorDept",map);
	}
	
	/**
	 * 조직도에 쓸 부서리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DeptViewVO> getDeptViewVO(Map<String, String> map){
		return (List<DeptViewVO>) list("selectDeptList",map);
	}
	
	/**
	 * 해당부서의 사원 리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalAuthorVO> getDeptUserList(Map<String, String> map){
		return (List<JournalAuthorVO>) list("selectUserList",map);
	}
}
