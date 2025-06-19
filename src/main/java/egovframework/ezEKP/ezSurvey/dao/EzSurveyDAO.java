package egovframework.ezEKP.ezSurvey.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezSurvey.vo.ResultViewPermissionVO;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezSurvey.vo.AttachVO;
import egovframework.ezEKP.ezSurvey.vo.OptionVO;
import egovframework.ezEKP.ezSurvey.vo.QuestionVO;
import egovframework.ezEKP.ezSurvey.vo.RespondentVO;
import egovframework.ezEKP.ezSurvey.vo.ResponseVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleUserVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyGeneralVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyItemSearchVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyParticipantVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@SuppressWarnings("unchecked")
@Repository("EzSurveyDAO")
public class EzSurveyDAO extends EgovAbstractDAO {
	public String getDeptPath(Map<String, Object> map) {
		return (String)select("EzSurveyDAO.getDeptPath", map);
	}
	
	public SimpleDeptVO getSimpleCompany(Map<String, Object> map) {
		return (SimpleDeptVO)select("EzSurveyDAO.getSimpleCompany", map);
	}
	
	public SimpleUserVO getSurveyUserInfo(Map<String, Object> map) {
		return (SimpleUserVO)select("EzSurveyDAO.getSurveyUserInfo", map);
	}
	
	public SimpleDeptVO getSurveyDeptInfo(Map<String, Object> map) {
		return (SimpleDeptVO)select("EzSurveyDAO.getSurveyDeptInfo", map);
	}
	
	public List<SimpleDeptVO> getAllSimpleSubDepts(Map<String, Object> map) {
		return (List<SimpleDeptVO>)list("EzSurveyDAO.getAllSimpleSubDepts", map);
	}
	
	public int getTotalDeptMembers(Map<String, Object> map) {
		return (int)select("EzSurveyDAO.getTotalDeptMembers", map);
	}
	
	public List<SimpleUserVO> getDeptMemberList(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzSurveyDAO.getDeptMemberList", map);
	}
	
	/*
	public int getTotalSearchMembers(Map<String, Object> map) {
		return (int)select("EzSurveyDAO.getTotalSearchMembers", map);
	}*/
	
	public SurveyGeneralVO getUserPreviewConfig(Map<String, Object> map) {
		return (SurveyGeneralVO)select("EzSurveyDAO.getUserPreviewConfig", map);
	}
	
	public void saveUserConfig(Map<String, Object> map) {
		insert("EzSurveyDAO.saveUserConfig", map);
	}
	
	/*
	public List<SimpleUserVO> getSearchMemberList(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzSurveyDAO.getSearchMemberList", map);
	}*/

	public List<SimpleUserVO> getSearchMemberListByAttr(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzSurveyDAO.getSearchMemberListByAttr", map);
	}

	public List<SurveyVO> getSurveyListForPermission(Map<String, Object> map) {
		return (List<SurveyVO>)list("EzSurveyDAO.getSurveyListForPermission", map);
	}
	
	public List<String> getUserDepartmentIdList(Map<String, Object> map) {
		return (List<String>)list("EzSurveyDAO.getUserDepartmentIdList", map);
	}
	
	public List<String> getUserAllDepartmentIdList(Map<String, Object> map) {
		return (List<String>)list("EzSurveyDAO.getUserAllDepartmentIdList", map);
	}
	
	public List<Long> getReceivedSurveyList(Map<String, Object> map) {
		return (List<Long>)list("EzSurveyDAO.getReceivedSurveyList", map);
	}
	
	public void saveSurveyItem(SurveyVO survey) {
		insert("EzSurveyDAO.saveSurveyItem", survey);
	}
	
	public void updateSurveyItem(SurveyVO survey) {
		update("EzSurveyDAO.updateSurveyItem", survey);
	}
	
	public long getMaxSurveyId(Map<String, Object> map) {
		return (long)select("EzSurveyDAO.getMaxSurveyId", map);
	}
	
	public long getMaxQuestionId(Map<String, Object> map) {
		return (long)select("EzSurveyDAO.getMaxQuestionId", map);
	}
	
	public void saveQuestionItem(QuestionVO question) {
		insert("EzSurveyDAO.saveQuestionItem", question);
	}
	
	public void saveOptionItem(OptionVO option) {
		insert("EzSurveyDAO.saveOptionItem", option);
	}
	
	public long getMaxOptionId(Map<String, Object> map) {
		return (long)select("EzSurveyDAO.getMaxOptionId", map);
	}
	
	public void saveAttachItem(AttachVO attach) {
		insert("EzSurveyDAO.saveAttachItem", attach);
	}
	
	public void saveSurveyUsers(SurveyParticipantVO surveyUser) {
		insert("EzSurveyDAO.saveSurveyUsers", surveyUser);
	}
	
	public int getTotalReceivedSurveyItemsCnt(SurveyItemSearchVO searchVO) {
		return (int)select("EzSurveyDAO.getTotalReceivedSurveyItemsCnt", searchVO);
	}
	
	public List<SurveyVO> getTotalReceivedSurveyItems(SurveyItemSearchVO searchVO) {
		return (List<SurveyVO>)list("EzSurveyDAO.getTotalReceivedSurveyItems", searchVO);
	}
	
	public List<SurveyVO> getTotalPopupSurveyItems(Map<String, Object> map) {
		return (List<SurveyVO>)list("EzSurveyDAO.getTotalPopupSurveyItems", map);
	}

	public void deleteItems(Map<String, Object> map) {
		update("EzSurveyDAO.deleteItems", map);
	}
	
	public SurveyVO getSurveyInfo(Map<String, Object> map) {
		return (SurveyVO)select("EzSurveyDAO.getSurveyInfo", map);
	}
	
	public List<SurveyParticipantVO> getSurveyUsers(Map<String, Object> map) {
		return (List<SurveyParticipantVO>)list("EzSurveyDAO.getUsersForSurvey", map);
	}
	
	public List<AttachVO> getSurveyAttachList(Map<String, Object> map) {
		return (List<AttachVO>)list("EzSurveyDAO.getAttachForSurvey", map);
	}
	
	public List<QuestionVO> getAllQuestionsOfSurvey(Map<String, Object> map) {
		return (List<QuestionVO>)list("EzSurveyDAO.getAllQuestionsOfSurvey", map);
	}
	
	public List<OptionVO> getAllOptionsOfSurvey(Map<String, Object> map) {
		return (List<OptionVO>)list("EzSurveyDAO.getAllOptionsOfSurvey", map);
	}
	
	public List<AttachVO> getAllAttachForQsAndOpt(Map<String, Object> map) {
		return (List<AttachVO>)list("EzSurveyDAO.getAllAttachForQsAndOpt", map);
	}
	
	public void deleteSurveyQuestions(SurveyVO survey) {
		delete("EzSurveyDAO.deleteSurveyQuestions", survey);
	}
	
	public void deleteSurveyOptions(SurveyVO survey) {
		delete("EzSurveyDAO.deleteSurveyOptions", survey);
	}
	
	public void deleteSurveyAttach(SurveyVO survey) {
		delete("EzSurveyDAO.deleteSurveyAttach", survey);
	}
	
	public void deleteSurveyUsers(SurveyVO survey) {
		delete("EzSurveyDAO.deleteSurveyUsers", survey);
	}
	
	public long getMaxResponseId(Map<String, Object> map) {
		return (long)select("EzSurveyDAO.getMaxResponseId", map);
	}
	
	public void saveResponseItem(ResponseVO response) {
		insert("EzSurveyDAO.saveResponseItem", response);
	}
	
	public void saveRespondent(RespondentVO respondent) {
		insert("EzSurveyDAO.saveRespondent", respondent);
	}
	
	public int getTotalRespondents(Map<String, Object> map) {
		return (int)select("EzSurveyDAO.getTotalRespondents", map);
	}
	
	public List<SimpleUserVO> getAllMembersOfCompany(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzSurveyDAO.getAllMembersOfCompany", map);
	}
	
	public List<ResponseVO> getAllResponsesForSurvey(Map<String, Object> map) {
		return (List<ResponseVO>)list("EzSurveyDAO.getAllResponsesForSurvey", map);
	}
	
	public int getUserResponseCntForSurvey(Map<String, Object> map) {
		return (int)select("EzSurveyDAO.getUserResponseCntForSurvey", map);
	}

	public boolean getSurveyPopupPermitYN(Map<String, Object> map) {
		try {
			int count = (int) select("EzPersonalDAO.getSurveyPopupPermitYN", map);
			
			if (count > 0) {
				return true;
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		return false;
	}

	public List<String> getSurveyGroupList(Map<String, Object> map) {
		return (List<String>) list("EzPersonalDAO.getSurveyGroupList", map);
	}

	
	public List<SurveyVO> getTodaySurveyList(Map<String, Object> map) {
		return (List<SurveyVO>) list("EzSurveyDAO.getTodaySurveyList", map);
	}
	
	public List<SurveyParticipantVO> getSurveyParticipantListForMail(Map<String, Object> map) {
		return (List<SurveyParticipantVO>) list("EzSurveyDAO.getSurveyParticipantListForMail", map);
	}
	
	/* 2021-11-18 홍승비 - 대상자가 부서/회사인 경우, 하위부서 허용여부가 Y인 부서/회사ID를 리턴 */
	public List<String> getSurveySubDeptListForMail(Map<String, Object> map) {
		return (List<String>) list("EzSurveyDAO.getSurveySubDeptListForMail", map);
	}
	
	/* 2021-11-18 홍승비 - 전달받은 부서/회사ID를 상위부서로 가지는 하위부서 소속원들을 리턴 */
	public List<SurveyParticipantVO> getSurveyLowerDeptUsersForMail(Map<String, Object> map) {
		return (List<SurveyParticipantVO>) list("EzSurveyDAO.getSurveyLowerDeptUsersForMail", map);
	}
	
	public int getMailSentFlag(SurveyVO survey) {
		return (int) select("EzSurveyDAO.getMailSentFlag", survey);
	}
	
	public int getTotalNotiSentFlag(SurveyVO survey) {
		return (int) select("EzSurveyDAO.getTotalNotiSentFlag", survey);
	}
	
	public void updateMailSentFlag(Map<String, Object> map) {
		update("EzSurveyDAO.updateMailSentFlag", map);
	}
	
	public void updateTotalNotiSentFlag(Map<String, Object> map) {
		update("EzSurveyDAO.updateTotalNotiSentFlag", map);
	}
	
	public long checkRespondent(Map<String, Object> map) {
		return (long)select("EzSurveyDAO.checkRespondent", map);
	}

	public int getNoAnsweredIngSurveyList(Map<String, Object> map) {
		return (int)select("EzSurveyDAO.getNoAnsweredIngSurveyList", map);
	}

	public void deleteResponseItems(Map<String, Object> map) {
		delete("EzSurveyDAO.deleteResponseItems", map);
	}
	
	public void deleteRespondents(Map<String, Object> map) {
		delete("EzSurveyDAO.deleteRespondents", map);
	}

	/* 2021-08-30 홍승비 - 전자설문 대상자가 사간겸직자인 경우, 해당 부서ID를 조건으로 레코드를 리턴 */
	public SimpleUserVO getSurveyUserInfoAddJob(Map<String, Object> map) {
		return (SimpleUserVO)select("EzSurveyDAO.getSurveyUserInfoAddJob", map);
	}

	public String checkTenantConfig(Map<String, Object> map) throws Exception{
		return (String) select("EzSurveyDAO.checkTenantConfig", map);
	}
	
	public void setPreviewFlag(Map<String, Object> map) {
		update("EzSurveyDAO.setPreviewFlag", map);
	}

	public boolean comfirmSurveyDeletion(Map<String, Object> map) throws Exception {
		boolean isDeletedSurvey = (boolean) select("EzSurveyDAO.comfirmSurveyDeletion", map);
		
		return isDeletedSurvey;
	}

	// 2024-07-12 전인하 - 설문 > 설문결과 지정공개 대상자 저장
	public void saveSurveyResultViewTarget(Map<String, Object> map) {
		insert("EzSurveyDAO.saveSurveyResultViewTarget", map);
	}

	// 2024-07-12 전인하 - 설문 > 설문결과 지정공개 대상자 리스트 조회
	public List<ResultViewPermissionVO> selectResultViewPermission(Map<String, Object> map) {
		return (List<ResultViewPermissionVO>) list("EzSurveyDAO.selectResultViewPermission", map);
	}

	// 2024-07-12 전인하 - 설문 > 설문결과 지정공개 대상자 삭제
	public void deleteResultViewPermission(Map<String, Object> map) {
		delete("EzSurveyDAO.deleteResultViewPermission", map);
	}

	// 2024-07-12 전인하 - 설문 > 사용자가 결과조회 가능한 설문 id 조회
	public List<Long> getReceivedSurveyResultList(Map<String, Object> map) {
		return (List<Long>)list("EzSurveyDAO.getReceivedSurveyResultList", map);
	}

	public HashMap<String, Object> checkEditingState(Map<String, Object> map) throws Exception {
		return (HashMap<String, Object>) select("EzSurveyDAO.checkEditingState", map);
	}
}