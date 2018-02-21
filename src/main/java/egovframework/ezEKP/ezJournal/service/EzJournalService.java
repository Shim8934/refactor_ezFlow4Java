package egovframework.ezEKP.ezJournal.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezJournal.vo.DeptViewVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthorVO;
import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezJournal.vo.JournalEnvVO;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;


public interface EzJournalService {

	/**
	 * 양식함 리스트 가져오는 서비스
	 * @param companyId
	 * @param tenantId
	 * @param used 
	 * @return
	 * @throws Exception
	 */
	public List<JournaltypeVO> getJournaltypeList(String companyId, String tenantId, String used) throws Exception;
	
	/**
	 * 양식함 사용여부 변경
	 * @param journaltypeList
	 * @param companyId
	 * @param tenantId
	 */
	public void updateJournaltype(ArrayList<Map<String, String>> journaltypeList,String companyId,String tenantId);
	
	/**
	 * 양식함 초기 등록
	 * @param companyId
	 * @param tenantId
	 * @param journaltypeList
	 */
	public void insertJournaltype(String companyId, String tenantId, ArrayList<JournaltypeVO> journaltypeList);

	/**
	 * 양식 리스트 가져오기
	 * @param typeId
	 * @param companyId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public List<JournalFormInfoVO> getFormList(String typeId, String companyId, String tenantId) throws Exception;

	/**
	 * 부서에서 사용가능한 양식 리스트
	 * @param typeId
	 * @param companyId
	 * @param tenantId
	 * @param deptId
	 * @return
	 * @throws Exception
	 */
	public List<JournalFormInfoVO> getDeptUseFormList(String typeId, String companyId, String tenantId, String deptId) throws Exception;

	/**
	 * 기본양식 리스트
	 * @param companyId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public List<JournalFormInfoVO> getBasicFormList(String companyId, String tenantId) throws Exception;

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
	public List<JournalCompanyVO> getCompanyList (String userId,String tenantId, String companyId) throws Exception;
	
	/**
	 * 열람 권한 리스트 가져오기
	 * @param companyId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public List<JournalAuthorVO> getAuthorList (String companyId, String tenantId) throws Exception;
	
	/**
	 * 열람 권한자의 권한 부서 리스트 가져오기
	 * @param tenantId
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public List<JournalAuthorVO> getAuthDeptList (String tenantId, String userId) throws Exception;
	
	/**
	 * 조직도에 쓸 부서 리스트 가져오기
	 * @param userId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public List<DeptViewVO> getDeptViewList (String userId,String companyId,String tenantId) throws Exception;
	
	/**
	 * 해당부서의 사원리스트
	 * @param tenantId
	 * @param deptId
	 * @return
	 * @throws Exception
	 */
	public List<JournalAuthorVO> getDeptUserList (String tenantId, String key,String value) throws Exception;

	/**
	 * 양식 상세정보
	 * @param formId
	 * @param tenantId
	 * @param companyId
	 * @return
	 * @throws Exception
	 */
	public JournalFormInfoVO getJournalFormInfo(String formId, String companyId, String tenantId);

	/**
	 * 양식 수정
	 * @param jsonParam
	 * @return
	 * @throws Exception
	 */
	public void updateJournalForm(JSONObject jsonParam);

	/**
	 * 양식 삭제
	 * @param formId
	 * @param companyId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public void deleteJournalForm(String formId, String companyId, String tenantId);
	
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
	public void deleteAuthor(String userId,String tenantId) throws Exception;

	/**
	 * 해당사원의 수신일지 개수
	 * @param userId
	 * @param tenantId
	 * @return
	 */
	public String getRecvJournalCount(String userId, String tenantId);
	
	/**
	 * 해당사원의 업무일지 환경설정
	 * @param userId
	 * @param tenantId
	 * @return
	 */
	public JournalEnvVO getUserJournalEnv(String userId, String tenantId);
}
