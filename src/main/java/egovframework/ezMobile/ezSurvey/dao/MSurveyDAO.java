package egovframework.ezMobile.ezSurvey.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezSurvey.vo.AttachVO;
import egovframework.ezEKP.ezSurvey.vo.OptionVO;
import egovframework.ezEKP.ezSurvey.vo.QuestionVO;
import egovframework.ezEKP.ezSurvey.vo.ResponseVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleUserVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyItemSearchVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyParticipantVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyVO;
import egovframework.ezMobile.ezSurvey.vo.MAttachVO;
import egovframework.ezMobile.ezSurvey.vo.MOptionVO;
import egovframework.ezMobile.ezSurvey.vo.MQuestionVO;
import egovframework.ezMobile.ezSurvey.vo.MRespondentVO;
import egovframework.ezMobile.ezSurvey.vo.MResponseVO;
import egovframework.ezMobile.ezSurvey.vo.MSimpleDeptVO;
import egovframework.ezMobile.ezSurvey.vo.MSimpleUserVO;
import egovframework.ezMobile.ezSurvey.vo.MSurveyItemSearchVO;
import egovframework.ezMobile.ezSurvey.vo.MSurveyParticipantVO;
import egovframework.ezMobile.ezSurvey.vo.MSurveyVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@SuppressWarnings("unchecked")
@Repository("MSurveyDAO")
public class MSurveyDAO extends EgovAbstractDAO {
	public List<String> getUserDepartmentIdList(Map<String, Object> map) throws Exception {
		return (List<String>)list("MSurveyDAO.getUserDepartmentIdList", map);
	}
	
	public List<String> getUserAllDepartmentIdList(Map<String, Object> map) throws Exception {
		return (List<String>)list("MSurveyDAO.getUserAllDepartmentIdList", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 대상자로 속한 설문 목록 가져오기 (전체, 지정 포함) */
	public List<Long> getReceivedSurveyList(Map<String, Object> map) throws Exception {
		return (List<Long>)list("MSurveyDAO.getReceivedSurveyList", map);
	}
	
	/** 2023-08-04 한태훈 -모바일 전자설문 > 설문 리스트 페이지 설문 목록 개수 가져오기 */
	public int getTotalReceivedSurveyItemsCnt(MSurveyItemSearchVO searchVO) throws Exception {
		return (int)select("MSurveyDAO.getTotalReceivedSurveyItemsCnt", searchVO);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문 리스트 페이지 설문 목록 가져오기 */
	public List<MSurveyVO> getTotalReceivedSurveyItems(MSurveyItemSearchVO searchVO) throws Exception {
		return (List<MSurveyVO>)list("MSurveyDAO.getTotalReceivedSurveyItems", searchVO);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 허가된 설문 목록 가져오기 */
	public List<MSurveyVO> getSurveyListForPermission(Map<String, Object> map) throws Exception {
		return (List<MSurveyVO>)list("MSurveyDAO.getSurveyListForPermission", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문 정보 가져오기 */
	public MSurveyVO getSurveyInfo(Map<String, Object> map) throws Exception {
		return (MSurveyVO)select("MSurveyDAO.getSurveyInfo", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문 참여자 정보 가져오기 */
	public List<MSurveyParticipantVO> getSurveyUsers(Map<String, Object> map) throws Exception {
		return (List<MSurveyParticipantVO>)list("MSurveyDAO.getUsersForSurvey", map);
	}

	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문 첨부파일 목록 가져오기 */
	public List<MAttachVO> getSurveyAttachList(Map<String, Object> map) throws Exception {
		return (List<MAttachVO>)list("MSurveyDAO.getAttachForSurvey", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문 정보 수정 */
	public void updateSurveyItem(MSurveyVO survey) throws Exception {
		update("MSurveyDAO.updateSurveyItem", survey);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 사용자가 해당 설문에 응답 개수 가져오기 (해당 설문 응답 여부 체크) */
	public int getUserResponseCntForSurvey(Map<String, Object> map) throws Exception {
		return (int)select("MSurveyDAO.getUserResponseCntForSurvey", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 전자설문 유저정보 가져오기 */
	public MSimpleUserVO getSurveyUserInfo(Map<String, Object> map) throws Exception {
		return (MSimpleUserVO)select("MSurveyDAO.getSurveyUserInfo", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 전자설문 유저정보 가져오기 (겸직 정보 추가) */
	public MSimpleUserVO getSurveyUserInfoAddJob(Map<String, Object> map) throws Exception {
		return (MSimpleUserVO)select("MSurveyDAO.getSurveyUserInfoAddJob", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 부서정보 가져오기 */
	public MSimpleDeptVO getSurveyDeptInfo(Map<String, Object> map) throws Exception {
		return (MSimpleDeptVO)select("MSurveyDAO.getSurveyDeptInfo", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문 모든 질문 가져오기 */
	public List<MQuestionVO> getAllQuestionsOfSurvey(Map<String, Object> map) throws Exception {
		return (List<MQuestionVO>)list("MSurveyDAO.getAllQuestionsOfSurvey", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문 모든 보기 가져오기 */
	public List<MOptionVO> getAllOptionsOfSurvey(Map<String, Object> map) throws Exception {
		return (List<MOptionVO>)list("MSurveyDAO.getAllOptionsOfSurvey", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문의 질문과 보기에 첨부된 모든 첨부파일 가져오기 */
	public List<MAttachVO> getAllAttachForQsAndOpt(Map<String, Object> map) throws Exception {
		return (List<MAttachVO>)list("MSurveyDAO.getAllAttachForQsAndOpt", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문의 모든 응답 가져오기 */
	public List<MResponseVO> getAllResponsesForSurvey(Map<String, Object> map) throws Exception {
		return (List<MResponseVO>)list("MSurveyDAO.getAllResponsesForSurvey", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문 응답 아이디의 최댓값 + 1 가져오기 */
	public long getMaxResponseId(Map<String, Object> map) {
		return (long)select("MSurveyDAO.getMaxResponseId", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문 응답자 정보 삭제하기 (응답 수정 시 이전 정보 삭제) */
	public void deleteRespondents(Map<String, Object> map) {
		delete("MSurveyDAO.deleteRespondents", map);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문 응답 정보 삭제하기 (응답 수정 시 이전 정보 삭제) */
	public void deleteResponseItems(Map<String, Object> map) {
		delete("MSurveyDAO.deleteResponseItems", map);
		
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문 응답 정보 저장하기 */
	public void saveResponseItem(MResponseVO response) {
		insert("MSurveyDAO.saveResponseItem", response);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 설문 응답자 정보 저장하기 */
	public void saveRespondent(MRespondentVO respondent) {
		insert("MSurveyDAO.saveRespondent", respondent);
	}
	
	/** 2023-08-04 한태훈 - 모바일 전자설문 > 살믄 참여자 수 가져오기 */
	public int getTotalRespondents(Map<String, Object> map) {
		return (int)select("MSurveyDAO.getTotalRespondents", map);
	}
}
