package egovframework.ezEKP.ezJournal.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezJournal.dao.EzJournalDAO;
import egovframework.ezEKP.ezJournal.service.EzJournalService;
import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;


@Service("EzJournalService")
public class EzJournalServiceImpl implements EzJournalService{

	private static final Logger logger = LoggerFactory.getLogger(EzJournalServiceImpl.class);

	@Autowired
	private EzJournalDAO ezJournalDAO;
	
	@Override
	public List<JournaltypeVO> getJournaltypeList(String companyId,String tenantId,String used) throws Exception {
		logger.debug("getJournaltypeList started");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("companyId", companyId);
		param.put("tenantId", tenantId);
		param.put("used", used);
		
		List<JournaltypeVO> list = ezJournalDAO.getJournaltypeList(param);
		
		logger.debug("getJournaltypeList ended");
		
		return list;
	}

	@Override
	public void updateJournaltype(ArrayList<Map<String, String>> journaltypeList,String companyId, String tenantId) {
		logger.debug("updateJournaltype started");
		for (int i = 0; i < journaltypeList.size(); i++) {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("typeId", journaltypeList.get(i).get("journaltypeId"));
			param.put("used", journaltypeList.get(i).get("journalUse"));
			param.put("companyId", companyId);
			param.put("tenantId", tenantId);
			logger.debug("typeId : "+param.get("typeId"));
			logger.debug("used : "+param.get("used"));
			logger.debug("companyId : "+param.get("companyId"));
			logger.debug("tenantId : "+param.get("tenantId"));
			ezJournalDAO.updateJournaltype(param);
		}
		logger.debug("updateJournaltype ended");
	}

	@Override
	public void insertJournaltype(String companyId, String tenantId,ArrayList<JournaltypeVO> journaltypeList) {
		
	}
	

	@Override
	public List<JournalFormInfoVO> getFormList(String typeId, String companyId, String tenantId) throws Exception {
		logger.debug("getFormList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<JournalFormInfoVO> fList = ezJournalDAO.getFormList(map);
		List<JournalFormInfoVO> resultList = new ArrayList<JournalFormInfoVO>();
		
		for (int i = 0; i < fList.size(); i++) {
			JournalFormInfoVO vo = fList.get(i);
			map.put("formId", vo.getFormId());
			vo.setDepts(ezJournalDAO.getFormUseDeptList(map));
			resultList.add(vo);
		}
		
		logger.debug("getFormList ended");
		return resultList;
	}

	@Override
	public List<JournalFormInfoVO> getDeptUseFormList(String typeId,
			String companyId, String tenantId, String deptId) throws Exception {
		logger.debug("getDeptUseFormList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("deptId", deptId);
		
		List<JournalFormInfoVO> fList = ezJournalDAO.getDeptUseFormList(map);
		
		logger.debug("getDeptUseFormList ended");
		return fList;
	}

	@Override
	public List<JournalFormInfoVO> getBasicFormList(String companyId, String tenantId) throws Exception {
		logger.debug("getBasicFormList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<JournalFormInfoVO> basicList = ezJournalDAO.getBasicFormList(map);
		
		logger.debug("getBasicFormList ended");
		return basicList;
	}

	@Override
	public void insertForm(JSONObject journalFormInfoVO) throws Exception {
		logger.debug("insertForm started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", journalFormInfoVO.get("typeId"));
		map.put("formId", journalFormInfoVO.get("formId"));
		map.put("formName", journalFormInfoVO.get("formName"));
		map.put("formInfo", journalFormInfoVO.get("formInfo"));
		map.put("formContent", journalFormInfoVO.get("content"));
		map.put("formWriter", journalFormInfoVO.get("formWriter"));
		map.put("companyId", journalFormInfoVO.get("companyId"));
		map.put("tenantId", journalFormInfoVO.get("tenantId"));
		
		logger.debug("insertForm map" + map);
		ezJournalDAO.insertForm(map);
		
		List<String> depts = (List<String>) journalFormInfoVO.get("depts");
		for (int i = 0; i < depts.size(); i++) {
			insertUseDept((String) journalFormInfoVO.get("formId"), depts.get(i));
		}
		
		logger.debug("insertForm ended");
	}
	
	public void insertUseDept(String formId, String deptId) throws Exception {
		logger.debug("insertUseDept started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("formId", formId);
		map.put("deptId", deptId);
		
		ezJournalDAO.insertUseDept(map);
		logger.debug("insertUseDept ended");
	}

	@Override
	public List<JournalCompanyVO> getCompanyList(String userId,
			String tenantId) throws Exception {
		logger.debug("getCompanyList started");
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		List<JournalCompanyVO> compList = ezJournalDAO.getCompanyList(param);
		logger.debug("getCompanyList ended");
		return compList;
	}

}
