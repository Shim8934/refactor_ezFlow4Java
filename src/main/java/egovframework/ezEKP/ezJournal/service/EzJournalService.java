package egovframework.ezEKP.ezJournal.service;

import java.util.List;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;


public interface EzJournalService {

	List<JournalFormInfoVO> getFormList(String typeId, String companyId, String tenantId) throws Exception;

	List<JournalFormInfoVO> getDeptUseFormList(String typeId, String companyId,
			String tenantId, String deptId) throws Exception;

	List<JournalFormInfoVO> getBasicFormList(String companyId, String tenantId) throws Exception;

	void insertForm(JSONObject jsonParam) throws Exception;


	

}
