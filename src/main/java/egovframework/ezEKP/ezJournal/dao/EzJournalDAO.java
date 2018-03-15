package egovframework.ezEKP.ezJournal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezJournal.vo.DeptInfoVO;
import egovframework.ezEKP.ezJournal.vo.DeptViewVO;
import egovframework.ezEKP.ezJournal.vo.JournalAttachVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthorVO;
import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezJournal.vo.JournalEnvVO;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournalVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.ezEKP.ezJournal.vo.ReceiverFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardAttachVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("ezJournalDAO")
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
	public List<DeptInfoVO> getFormUseDeptList(Map<String, Object> map) {
		return (List<DeptInfoVO>) list("getFormUseDeptList", map);
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
	public int insertForm(Map<String, Object> map) {
		return (int) insert("insertJournalForm", map);
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

	/**
	 * 양식 상세정보 가져오기
	 * @param map
	 * @return
	 */
	public JournalFormInfoVO getJournalFormInfo(Map<String, Object> map) {
		return (JournalFormInfoVO) select("getJournalFormInfo", map);
	}

	/**
	 * 양식 수정
	 * @param map
	 * @return
	 */
	public void updateJournalForm(Map<String, Object> map) {
		update("updateJournalForm", map);
	}

	/**
	 * 양식 사용부서 삭제
	 * @param map
	 * @return
	 */
	public void deleteFormUseDept(Map<String, Object> map) {
		delete("deleteFormUseDept", map);
	}

	/**
	 * 양식 삭제
	 * @param map
	 * @return
	 */
	public void deleteJournalForm(Map<String, Object> map) {
		delete("deleteJournalForm", map);
	}

	/**
	 * 해당사원에게 열람권한 부서를 등록
	 * @param insertMap
	 */
	public void insertAuthDept(Map<String, Object> insertMap){
		insert("insertAuthDept",insertMap);
	}
	
	/**
	 * 해당사원의 열람권한 부서 리스트를 삭제
	 * @param map
	 */
	public void deleteAuthDept(Map<String, Object> map){
		delete("deleteAuthDept", map);
	}

	/**
	 * 수신자 즐겨찾기 추가
	 * @param map
	 */
	public int saveReceiverFavorite(Map<String, Object> map) {
		return (int) insert("saveReceiverFavorite", map);
	}

	/**
	 * 수신자 즐겨찾기에 수신자리스트 추가
	 * @param map
	 */
	public void insertFavoriteUser(Map<String, Object> map) {
		insert("insertFavoriteUser", map);
	}

	/**
	 * 즐겨찾기 리스트 가져오기
	 * @param map
	 */
	@SuppressWarnings("unchecked")
	public List<ReceiverFavoriteVO> getFavoriteList(Map<String, Object> map) {
		return (List<ReceiverFavoriteVO>) list("getReceiverFavoriteList", map);
	}

	/**
	 * 즐겨찾기아이디에 해당하는 수신자 리스트 가져오기
	 * @param map
	 */
	@SuppressWarnings("unchecked")
	public List<JournalAuthorVO> getFavoriteUserList(Map<String, Object> map) {
		return (List<JournalAuthorVO>) list("getFavoriteUserList", map);
	}

	/**
	 * 즐겨찾기 수신자 리스트 유저 삭제
	 * @param map
	 */
	public void deleteFavoriteUser(Map<String, Object> map) {
		delete("deleteFavoriteUser", map);
	}

	/**
	 * 즐겨찾기 이름 수정
	 * @param map
	 */
	public void updateFavoriteName(Map<String, Object> map) {
		update("updateFavoriteName", map);
	}

	/**
	 * 즐겨찾기 삭제
	 * @param map
	 */
	public void deleteFavorite(Map<String, Object> map) {
		delete("deleteFavorite", map);
	}

	/**
	 * 양식내용 가져오기
	 * @param map
	 */
	public String getJournalLastFormId(Map<String, Object> map) {
		return (String) select("getJournalLastFormId", map);
	}
	
	/**
	 * 해당사원의 수신일지 갯수
	 * @param map
	 */
	public String selectRecvCount(Map<String, Object> map) {
		return (String) select("selectRecvJournalCount",map);
	}
	
	/**
	 * 해당사원의 업무일지 환경설정
	 * @param map
	 * @return
	 */
	public JournalEnvVO selectUserEnv(Map<String, Object> map){
		return (JournalEnvVO) select("selectUserEnv",map);
	}
	
	/**
	 * 해당 업무일지 리스트 화면의 총 게시물 수
	 * @param map
	 * @return
	 */
	public String selectTotalListCount(Map<String, Object> map){
		return (String) select("selectJournalListCount",map);
	}
	
	/**
	 * 해당 페이지의 업무일지 리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalVO> selectJournalList(Map<String, Object> map){
		return (List<JournalVO>) list("selectJournalList" ,map);
	}
	
	/**
	 * 환경설정을 저장하거나 업데이트하기
	 * @param map
	 */
	public void insertUpdateJournalEnv(Map<String, Object> map){
		insert("insertUpdateJournalEnv",map);
	}
	
	/**
	 * 해당 일지 상세 내용 가져오기
	 * @param map
	 * @return
	 */
	public JournalVO selectJournal(Map<String, Object> map){
		return (JournalVO) select("getJournal",map);
	}
	
	/**
	 * 일지 열람 정보 인서트
	 * @param map
	 */
	public void insertViewInfo(Map<String, Object> map){
		insert("insertViewDate",map);
	}

	/**
	 * 첨부파일 리스트
	 * @param map
	 */
	public List<JournalAttachVO> getAttachList(Map<String, Object> map) {
		return (List<JournalAttachVO>) list("getAttachList", map);
	}

	/**
	 * 일지저장
	 * @param map
	 */
	public int insertJournal(Map<String, Object> map) {
		return (int) insert("insertJournal", map);
	}

	/**
	 * 첨부파일 정보 저장
	 * @param map
	 */
	public void insertJournalAttach(Map<String, Object> map) {
		insert("insertJournalAttach", map);
	}

	/**
	 * 수신자 정보 저장
	 * @param map
	 */
	public void insertReceiver(Map<String, Object> map) {
		insert("insertReceiver", map);
	}

	/**
	 * 일지 수정
	 * @param map
	 */
	public void updateJournal(Map<String, Object> map) {
		update("updateJournal", map);
	}

	/**
	 * 첨부파일 정보 삭제
	 * @param map
	 */
	public void deleteJournalAttach(Map<String, Object> map) {
		delete("deleteJournalAttach", map);
	}

	/**
	 * 수신자 정보 삭제
	 * @param map
	 */
	public void deleteReceiver(Map<String, Object> map) {
		delete("deleteReceiver", map);
	}

	/**
	 * 일지 삭제
	 * @param map
	 */
	public void deleteJournal(Map<String, Object> map) {
		delete("deleteJournal", map);
	}

	/**
	 * 일지 수신자 삭제 (수신일지함의 일지를 삭제했을 때)
	 * @param map
	 */
	public void deleteJournalReceiver(Map<String, Object> map) {
		delete("deleteJournalReceiver", map);
	}
}
