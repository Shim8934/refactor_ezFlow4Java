package egovframework.ezEKP.ezJournal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezJournal.vo.DeptInfoVO;
import egovframework.ezEKP.ezJournal.vo.DeptViewVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthCheckVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthorVO;
import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezJournal.vo.JournalEnvVO;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournalReceiverVO;
import egovframework.ezEKP.ezJournal.vo.JournalReplyVO;
import egovframework.ezEKP.ezJournal.vo.JournalVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.ezEKP.ezJournal.vo.ReceiverFavoriteVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("ezJournalDAO")
public class EzJournalDAO extends EgovAbstractDAO{

	/**
	 * 일지함 리스트 세럭트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<JournaltypeVO> getJournaltypeList(Map<String, Object> param) {
		List<JournaltypeVO> list = (List<JournaltypeVO>) list("selectJournalTypeList", param);
		return list;
	}
	
	/**
	 * 일지함 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void insertJournaltype(Map<String, Object> param) {
		try {
			insert("insertJournalType", param);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}
	
	/**
	 * 일지함 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void deleteJournaltypeList(Map<String, Object> param) {
		delete("deleteJournalTypeList", param);
	}
	
	/**
	 * 일지함 사용여부 변경
	 * @param param
	 */
	public void updateJournaltype(Map<String, Object> param){
		update("updateJournalTypeList", param);
	}
	
	/**
	 * 관리자단 양식 리스트
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalFormInfoVO> getFormListAdmin(Map<String, Object> map) {
		return (List<JournalFormInfoVO>) list("getFormListAdmin", map);
	}
	
	/**
	 * 양식 리스트 세럭트 (부서사용가능양식, 기본양식)
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
	public List<JournalCompanyVO> getCompanyList(Map<String, Object> map){
		return (List<JournalCompanyVO>) list("selectCompanyList",map);
	}
	
	/**
	 * 열람권한자 리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalAuthorVO> getAuthorList(Map<String, Object> map){
		return (List<JournalAuthorVO>) list("selectAuthorList",map);
	}
	
	/**
	 * 권한자의 권한부서 리스트
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalAuthorVO> getAuthDeptList(Map<String, Object> map){
		return (List<JournalAuthorVO>) list("selectAuthorDept",map);
	}
	
	/**
	 * 조직도에 쓸 부서리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DeptViewVO> getDeptViewVO(Map<String, Object> map){
		return (List<DeptViewVO>) list("selectDeptList",map);
	}
	
	/**
	 * 해당부서의 사원 리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalAuthorVO> getDeptUserList(Map<String, Object> map){
		return (List<JournalAuthorVO>) list("selectUserList",map);
	}
	
	public int getDeptUserListCount(Map<String, Object> map) {
		return (int) select("getDeptUserListCount", map);
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
		update("deleteJournalForm", map);
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
	public List<JournalReceiverVO> getFavoriteUserList(Map<String, Object> map) {
		return (List<JournalReceiverVO>) list("getFavoriteUserList", map);
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
		try {
			map.put("isUser", select("selectRecvUser",map));
			update("updateRecvDate",map);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
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
	 * 일지 수신자 상태 변경 (수신일지함에서 일지 삭제시 보여주는 상태값 변경)
	 * @param map
	 */
	public void updateJournalStatus(Map<String, Object> map) {
		update("updateJournalStatus", map);
	}

	/**
	 * 수신자 리스트 갯수 가져오기
	 * @param map
	 */
	public String getReceiverCount(Map<String, Object> map) {
		return (String) select("getReceiverCount", map);
	}
	
	/**
	 * 수신자 리스트 가져오기
	 * @param map
	 */
	@SuppressWarnings("unchecked")
	public List<JournalReceiverVO> getReceiverList(Map<String, Object> map) {
		List<JournalReceiverVO> result = null;
		try {
			result= (List<JournalReceiverVO>) list("getReceiverList",map);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return result;
	}
	
	/**
	 * 업무일지 댓글 리스트
	 * @param map
	 */
	@SuppressWarnings("unchecked")
	public List<JournalReplyVO> selectJournalReplyList(Map<String, Object> map) {
		return (List<JournalReplyVO>) list("selectJournalReplyList", map);
	}
	
	/**
	 * 댓글 등록
	 * @param map
	 */
	public String insertJournalReply(Map<String, Object>map) {
		return (String) insert("insertJournalReply",map);
	}
	
	/**
	 * 댓글 삭제 
	 * @param map
	 */
	public void deleteJournalReply(Map<String, Object>map) {
		insert("deleteJournalReply",map);
	}

	/**
	 * 일지 조회자 리스트
	 * @param map
	 * @return 
	 */
	@SuppressWarnings("unchecked")
	public List<JournalReceiverVO> getViewerList(Map<String, Object>map) {
		List<JournalReceiverVO> result = null;
		try {
			result= (List<JournalReceiverVO>) list("getViewerList",map);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return result;
	}
	
	/**
	 * 일지 조회자 명수
	 * @param map
	 * @return 
	 */
	public String getViewerCount(Map<String, Object>map) {
		return (String) select("getViewerCount",map);
	}

	/**
	 * 기본일지삽입
	 * @param map
	 */
	public void insertJournalBasicForm(Map<String, Object> map) {
		try {
			insert("insertJournalBasicForm",map);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}
	
	/**
	 * 열람권한체크
	 * @param map
	 */
	public JournalAuthCheckVO checkJournalAuth(Map<String, Object> map) {
		JournalAuthCheckVO result = null;
		try {
			result =  (JournalAuthCheckVO) select("checkJournalAuth",map);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return result;
	}

	/**
	 * 취합할 일지의 내용들 가져오기
	 * @param param
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<JournalVO> selectSumJournalList(Map<String, Object> param) {
		return (List<JournalVO>) list("selectSumJournalList",param);
	}
	
	/**
	 * 내가 부서장인 부서 리스트
	 * @param param
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DeptViewVO> selectCheifBossList(Map<String, Object> param) {
		List<DeptViewVO> result = null;
		try {
			result = (List<DeptViewVO>) list("selectCheifBossList",param);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return result;
	}
	
	/**
	 * 내가 부서장인 부서들의 하위부서 리스트
	 * @param param
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DeptViewVO> selectCheifBoss(Map<String, Object> param) {
		return (List<DeptViewVO>) list("selectCheifBoss",param);
	}

	/**
	 * 하나의 열람권한 부서만 삭제
	 * @param map
	 */
	public void deleteAuthDeptOne(Map<String, Object> map) {
		delete("deleteAuthDeptOne", map);
	}

	public JournalEnvVO selectJournalMailInfo(Map<String, Object> map) throws Exception {
		return (JournalEnvVO) select("selectJournalMailInfo",map);
	}

}
