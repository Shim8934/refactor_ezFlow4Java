package egovframework.ezEKP.ezJournal.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;


public interface EzJournalService {

	//양식함리스트 가져오는 메서드
	public List<JournaltypeVO> getJournaltypeList(String companyId, String tenantId) throws Exception;
	
	//양식함 사용여부 바꾸는 메서드
	public void updateJournaltype(ArrayList<Map<String, String>> journaltypeList,String companyId,String tenantId);
	
	//회사 생성시 양식함 초기 입력 메서드
	public void insertJournaltype(String companyId, String tenantId, ArrayList<JournaltypeVO> journaltypeList);

	public List<JournalFormInfoVO> getFormList(String typeId, String companyId, String tenantId) throws Exception;

	public List<JournalFormInfoVO> getDeptUseFormList(String typeId, String companyId, String tenantId, String deptId) throws Exception;

	public List<JournalFormInfoVO> getBasicFormList(String companyId, String tenantId) throws Exception;

	public void insertForm(JSONObject jsonParam) throws Exception;

}
