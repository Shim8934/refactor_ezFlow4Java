package egovframework.ezEKP.ezJournal.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezJournal.dao.EzJournalDAO;
import egovframework.ezEKP.ezJournal.service.EzJournalService;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezSchedule.service.impl.EzScheduleServiceImpl;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzJournalService")
public class EzJournalServiceImpl implements EzJournalService {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;

	@Autowired
	private Properties globals;
	
	@Autowired
	private EzJournalDAO ezJournalDAO;

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
		//map.put("formDate", commonUtil.getTodayUTCTime(""));
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

	

}
