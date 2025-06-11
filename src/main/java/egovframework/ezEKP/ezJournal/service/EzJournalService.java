package egovframework.ezEKP.ezJournal.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

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


public interface EzJournalService {

	/**
	 * 양식함 리스트 가져오는 서비스
	 * @param companyId
	 * @param tenantId
	 * @param used 
	 * @return
	 * @throws Exception
	 */
	public List<JournaltypeVO> getJournaltypeList(String companyId, int tenantId, String used) throws Exception;
	
	/**
	 * 양식함 사용여부 변경
	 * @param journaltypeList
	 * @param companyId
	 * @param tenantId
	 */
	public void updateJournaltype(ArrayList<Map<String, String>> journaltypeList,String companyId, int tenantId) throws Exception;
	
	/**
	 * 양식함 초기 등록
	 * @param companyId
	 * @param tenantId
	 * @param journaltypeList
	 */
	public void insertJournaltype(String companyId, int tenantId, ArrayList<String> journaltypeList) throws Exception;

	/**
	 * 양식 리스트 가져오기(관리자용)
	 * @param typeId
	 * @param deptId
	 * @param companyId
	 * @param tenantId
	 * @param offset
	 * @return
	 * @throws Exception
	 */
	public List<JournalFormInfoVO> getFormListAdmin(String typeId, String deptId, String companyId, int tenantId, String offSet,String lang) throws Exception;
	
	/**
	 * 양식 리스트 가져오기
	 * @param typeId
	 * @param deptId
	 * @param companyId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public List<JournalFormInfoVO> getFormList(String typeId, String deptId, String companyId, int tenantId) throws Exception;

	/**
	 * 양식 등록
	 * @param jsonParam
	 * @throws Exception
	 */
	public void insertForm(JSONObject jsonParam) throws Exception;

	/**
	 * 회사 리스트 가져오기
	 * @param userId
	 * @param tenantId
	 * @param companyId 
	 * @return
	 * @throws Exception
	 */
	public List<JournalCompanyVO> getCompanyList (String userId, int tenantId, String companyId,String lang) throws Exception;
	
	/**
	 * 열람 권한 리스트 가져오기
	 * @param companyId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public List<JournalAuthorVO> getAuthorList (String companyId, int tenantId,String lang) throws Exception;
	
	/**
	 * 열람 권한자의 권한 부서 리스트 가져오기
	 * @param tenantId
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public List<JournalAuthorVO> getAuthDeptList (int tenantId, String userId,String lang, String userCompany) throws Exception;
	
	/**
	 * 조직도에 쓸 부서 리스트 가져오기
	 * @param userId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public List<DeptViewVO> getDeptViewList (String userId, String companyId, int tenantId,String lang) throws Exception;
	
	/**
	 * 해당부서의 사원리스트
	 * @param tenantId
	 * @param deptId
	 * @return
	 * @throws Exception
	 */
	public List<JournalAuthorVO> getDeptUserList (int tenantId, String key, String value,String companyId, String lang, String curPage) throws Exception;
	
	/**
	 * 해당부서의 사원수
	 * @param tenantId
	 * @param deptId
	 * @return
	 * @throws Exception
	 */
	public int getDeptUserListCount (int tenantId, String key, String value,String companyId, String lang) throws Exception;
	

	/**
	 * 양식 상세정보
	 * @param formId
	 * @param tenantId
	 * @param companyId
	 * @return
	 * @throws Exception
	 */
	public JournalFormInfoVO getJournalFormInfo(String formId, String companyId, int tenantId,String lang, int formLang) throws Exception;

	/**
	 * 양식 수정
	 * @param jsonParam
	 * @return
	 * @throws Exception
	 */
	public void updateJournalForm(JSONObject jsonParam) throws Exception;

	/**
	 * 양식 삭제
	 * @param formId
	 * @param companyId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public void deleteJournalForm(String formId, String companyId, int tenantId) throws Exception;
	
	/**
	 * 해당사원의 열람권한 리스트를 등록 해줌
	 * @param jsonParam
	 * @throws Exception
	 */
	public void saveAuthDeptList (JSONObject jsonParam) throws Exception;
	
	/**
	 * 해당사원의 열람권한 리스트 삭제
	 * @param userId
	 * @param tenantId
	 * @throws Exception
	 */
	public void deleteAuthor(String userId, int tenantId) throws Exception;

	/**
	 * 수신자 즐겨찾기 저장
	 * @param jsonParam
	 * @throws Exception
	 */
	public void saveFavorite(JSONObject jsonParam) throws Exception;

	/**
	 * 수신자 즐겨찾기 리스트 가져오기
	 * @param userId
	 * @param tenantId
	 * @param offset
	 * @throws Exception
	 */
	public List<ReceiverFavoriteVO> getFavoriteList(String userId, int tenantId, String offset) throws Exception;

	/**
	 * 수신자 즐겨찾기 유저리스트 가져오기
	 * @param favoriteId
	 * @param tenantId
	 * @throws Exception
	 */
	public List<JournalReceiverVO> getFavoriteUserList(String favoriteId, int tenantId,String lang) throws Exception;

	/**
	 * 수신자 즐겨찾기 수정
	 * @param jsonParam
	 * @throws Exception
	 */
	public void modifyFavorite(JSONObject jsonParam) throws Exception;

	/**
	 * 수신자 즐겨찾기 삭제
	 * @param favoriteId
	 * @param userId
	 * @param tenantId
	 * @throws Exception
	 */
	public void deleteFavorite(String favoriteId, String userId, int tenantId) throws Exception;

	/**
	 * 해당사원의 수신일지 개수
	 * @param userId
	 * @param tenantId
	 * @return
	 */
	public String getRecvJournalCount(String userId, int tenantId) throws Exception;
	
	/**
	 * 해당사원의 업무일지 환경설정
	 * @param userId
	 * @param tenantId
	 * @param lang
	 * @return
	 */
	public JournalEnvVO getUserJournalEnv(String userId, String lang, int tenantId) throws Exception;
	
	/**
	 * 마지막 사용양식 아이디 가져오기
	 * @param typeId
	 * @param formId
	 * @param userId
	 * @param companyId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public String getJournalLastFormId(String typeId, String formId, String userId, String companyId, int tenantId) throws Exception;
	
	/**
	 * 현재 업무일지 리스트의 전체 게시물 수
	 * @param map
	 * @return
	 */
	public String getTotalListCount(Map<String, Object> map) throws Exception;
	
	/**
	 * 현재 페이지의 업무일지 리스트를 가져오기
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<JournalVO> getJournalList(Map<String, Object> map) throws Exception;
	
	/**
	 * 업무일지 환경설정을 저장하거나 업데이트
	 * @param map
	 * @throws Exception
	 */
	public void saveJournalEnv(Map<String, Object> map) throws Exception;
	
	/**
	 * 해당 아이디의 업무일지 상세내용 가져오기
	 * @param journalId
	 * @param userId 
	 * @param tenantId
	 * @param offset 
	 * @param pPreviewShow_HOW 
	 * @return
	 * @throws Exception
	 */
	public JournalVO getJournal(String journalId, String userId, int tenantId,String lang, String offset, String pPreviewShow_HOW) throws Exception;

	/**
	 * 일지 저장하기
	 * @param jsonParam
	 * @param deptId
	 * @param tenantId
	 * @param realPath
	 * @return
	 * @throws Exception
	 */
	public String insertJournal(JSONObject jsonParam, String deptId, int tenantId, String realPath) throws Exception;

	/**
	 * 일지 수정하기
	 * @param journalId
	 * @param jsonParam
	 * @param tenantId
	 * @param realPath
	 * @return
	 * @throws Exception
	 */
	 public void updateJournal(String journalId, JSONObject jsonParam, int tenantId, String realPath) throws Exception;
	
	/**
	 * 일지내용을 this와 next로 나누기
	 * @param journalIdList
	 * @param formId
	 * @param companyId
	 * @param userId 
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public JournalFormInfoVO getJournalDivideThisNext(List<String> journalIdList,String formId, String companyId, String userId, int tenantId) throws Exception;

	/**
	 * 일지삭제
	 * @param journalIdList
	 * @param pDirPath
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public void deleteJournalList(List<String> journalIdList, String pDirPath, int tenantId) throws Exception;

	/**
	 * 수신일지 상태 변경
	 * @param journalIdList
	 * @param userId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public void updateJournalStatus(List<String> journalIdList, String userId, int tenantId) throws Exception;

	/**
	 * 수신자 리스트 가져오기
	 * @param journalId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public String getReceiverCount(String journalId, int tenantId) throws Exception;
	
	/**
	 * 수신자 리스트 가져오기
	 * @param journalId
	 * @param tenantId
	 * @param offset 
	 * @return
	 * @throws Exception
	 */
	public List<JournalReceiverVO> getReceiverList(String journalId, String startCount, String listCnt, int tenantId,String lang, String offset) throws Exception;

	/**
	 * 업무일지 댓글 리스트
	 * @param journalId
	 * @param userId
	 * @param tenantId
	 * @param offset 
	 * @return
	 * @throws Exception
	 */
	public List<JournalReplyVO> getJournalReplyList(String journalId, String userId, int tenantId,String lang, String offset) throws Exception;
	
	/**
	 * 업무일지 댓글 저장
	 * @param journalId
	 * @param userId
	 * @param replyContent
	 * @param tenantId
	 * @return 
	 * @throws Exception
	 */
	public String saveJorunalReply(String journalId, String userId, String replyContent, int tenantId) throws Exception;
	
	/**
	 * 업무일지 댓글 삭제
	 * @param journalId
	 * @param userId
	 * @param userId2 
	 * @param replyContent
	 * @param replyDate
	 * @param tenantId
	 * @throws Exception
	 */
	public void removeJorunalReply(String journalId, String replyId, String userId, int tenantId) throws Exception;
	
	/**
	 * 일지 조회자 리스트
	 * @param journalId
	 * @param listCnt 
	 * @param startCount 
	 * @param tenantId
	 * @param offset 
	 * @return 
	 * @throws Exception
	 */
	public List<JournalReceiverVO> getJournalViewerList(String journalId, String startCount, String listCnt, int tenantId,String lang, String offset) throws Exception;
	
	/**
	 * 일지 조회자 몇명?
	 * @param journalId
	 * @param tenantId
	 * @return 
	 * @throws Exception
	 */
	public String getJournalViewerCount(String journalId, int tenantId) throws Exception;

	/**
	 * 일지 조회정보 입력
	 * @param journalIdList
	 * @param userId
	 * @param tenantId
	 */
	public void saveJournalViewInfo(List<String> journalIdList, String userId, int tenantId) throws Exception;

	/**
	 * 일지함 삭제
	 * @param companyId
	 * @param tenantId
	 * @throws Exception 
	 */
	public void deleteJournaltype(String companyId, int tenantId) throws Exception;

	/**
	 * 일지 열람 권한 체크
	 * @param userId
	 * @param journalId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public JournalAuthCheckVO checkJournalAuth(String userId, String journalId, int tenantId) throws Exception; 
	
	/**
	 * 내가 부서장인 부서들과 그 하위 부서 리스트
	 * @param userId
	 * @param lang
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public List<DeptViewVO> getCheifBoss(String userId, String lang, int tenantId) throws Exception; 
	
	public JournalEnvVO getUserJournalMailInfo(String userId, int tenantId, String lang) throws Exception;
	
	public String updateJournulListLangChanege(String companyId, int tenantId, String form_lang) throws Exception;
	
	public int getFormLang(String formId, String companyId, int tenantId) throws Exception;
	
	public int getFormLang2(String companyId, int tenantId) throws Exception;
}
