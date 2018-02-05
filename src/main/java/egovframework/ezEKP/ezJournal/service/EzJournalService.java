package egovframework.ezEKP.ezJournal.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
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
	 * @return
	 * @throws Exception
	 */
	public List<JournalCompanyVO> getCompanyList (String userId,String tenantId) throws Exception;
}
