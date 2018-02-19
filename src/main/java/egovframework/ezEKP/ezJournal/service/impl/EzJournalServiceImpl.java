package egovframework.ezEKP.ezJournal.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezJournal.dao.EzJournalDAO;
import egovframework.ezEKP.ezJournal.service.EzJournalService;
import egovframework.ezEKP.ezJournal.vo.DeptInfoVO;
import egovframework.ezEKP.ezJournal.vo.DeptViewVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthorVO;
import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.let.utl.fcc.service.JsonUtil;


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
			param.put("typeId", journaltypeList.get(i).get("typeId"));
			param.put("used", journaltypeList.get(i).get("used"));
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
			
			List<DeptInfoVO> useDept = ezJournalDAO.getFormUseDeptList(map);
			
			if (useDept.size() < 1) {
				useDept.clear();
				DeptInfoVO deptVO = new DeptInfoVO();
				deptVO.setDeptName("전체");
				useDept.add(deptVO);
			}
			vo.setDepts(useDept);
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
	public void insertForm(JSONObject jsonParam) throws Exception {
		logger.debug("insertForm started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", jsonParam.get("typeId"));
		map.put("formName", jsonParam.get("formName"));
		map.put("formDescript", jsonParam.get("formDescript"));
		map.put("formContent", jsonParam.get("formContent"));
		map.put("formWriter", jsonParam.get("formWriter"));
		map.put("companyId", jsonParam.get("companyId"));
		map.put("tenantId", jsonParam.get("tenantId"));
		
		logger.debug("insertForm map" + map);
		
		String tenantId = jsonParam.get("tenantId").toString();
		String formId = ezJournalDAO.insertForm(map) + "";
		String isDeptChanged = (String) jsonParam.get("isDeptChanged");
		
		if (isDeptChanged.equals("Y")) {
			logger.debug((String)jsonParam.get("useDept"));
			
			List<Map<String, Object>> depts = JsonUtil.JsonToList((String) jsonParam.get("useDept")); 
			
			if (depts != null) {
				for (int i = 0; i < depts.size(); i++) {
					try {
						insertUseDept(formId, depts.get(i).get("deptId").toString(), tenantId);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}
		
		logger.debug("insertForm ended");
	}
	
	public void insertUseDept(String formId, String deptId, String tenantId) throws Exception {
		logger.debug("insertUseDept started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("formId", formId);
		map.put("deptId", deptId);
		map.put("tenantId", tenantId);
		
		ezJournalDAO.insertUseDept(map);
		logger.debug("insertUseDept ended");
	}

	@Override
	public List<JournalCompanyVO> getCompanyList(String userId,
			String tenantId,String companyId) throws Exception {
		logger.debug("getCompanyList started");
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		param.put("companyId", companyId);
		List<JournalCompanyVO> compList = ezJournalDAO.getCompanyList(param);
		logger.debug("getCompanyList ended");
		return compList;
	}

	@Override
	public List<JournalAuthorVO> getAuthorList(String companyId, String tenantId)throws Exception {
		logger.debug("getAuthorList started");
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("tenantId", tenantId);
		param.put("companyId", companyId);
		List<JournalAuthorVO> authList = ezJournalDAO.getAuthorList(param);
		logger.debug("getAuthorList ended");
		return authList;
	}

	@Override
	public List<DeptViewVO> getDeptViewList(String userId,String companyId, String tenantId) throws Exception {
		logger.debug("getDeptViewList started");
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		param.put("companyId", companyId);
		List<DeptViewVO> deptList = ezJournalDAO.getDeptViewVO(param);
		logger.debug("getDeptViewList ended");
		return deptList;
	}

	@Override
	public List<JournalAuthorVO> getAuthDeptList(String tenantId, String userId) throws Exception {
		logger.debug("getAuthDeptList started");
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		List<JournalAuthorVO> deptList = ezJournalDAO.getAuthDeptList(param);
		logger.debug("getAuthDeptList ended");
		return deptList;
	}
	
	@Override
	public List<JournalAuthorVO> getDeptUserList (String tenantId, String key ,String value) throws Exception{
		logger.debug("getDeptUserList started");
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("tenantId", tenantId);
		param.put("key", key);
		param.put("value", value);
		List<JournalAuthorVO> userList = ezJournalDAO.getDeptUserList(param);
		logger.debug("getDeptUserList ended");
		return userList;
	}

	@Override
	public JournalFormInfoVO getJournalFormInfo(String formId, String companyId, String tenantId) {
		logger.debug("getJournalFormInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("formId", formId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		JournalFormInfoVO journalFormInfoVO = ezJournalDAO.getJournalFormInfo(map);
		
		List<DeptInfoVO> deptList = ezJournalDAO.getFormUseDeptList(map);
		if (deptList.size() > 0) {
			journalFormInfoVO.setDepts(deptList);
		}
		
		logger.debug("getJournalFormInfo ended");
		return journalFormInfoVO;
	}

	@Override
	public void updateJournalForm(JSONObject jsonParam) {
		logger.debug("updateJournalForm started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", jsonParam.get("typeId"));
		map.put("formId", jsonParam.get("formId"));
		map.put("formName", jsonParam.get("formName"));
		map.put("formDescript", jsonParam.get("formDescript"));
		map.put("formContent", jsonParam.get("formContent"));
		map.put("formWriter", jsonParam.get("formWriter"));
		map.put("companyId", jsonParam.get("companyId"));
		map.put("tenantId", jsonParam.get("tenantId"));
		
		logger.debug("updateForm map" + map);
		String tenantId = jsonParam.get("tenantId").toString();
		String isDeptChanged = (String) jsonParam.get("isDeptChanged");
		
		logger.debug("isDeptChanged : " + isDeptChanged);
		ezJournalDAO.updateJournalForm(map);
		
		if (isDeptChanged.equals("Y")) {
			logger.debug((String)jsonParam.get("useDept"));
			
			ezJournalDAO.deleteFormUseDept(map);
			List<Map<String, Object>> depts = JsonUtil.JsonToList((String) jsonParam.get("useDept")); 
			
			if (depts != null) {
				for (int i = 0; i < depts.size(); i++) {
					try {
						insertUseDept(jsonParam.get("formId").toString(), depts.get(i).get("deptId").toString(), tenantId);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}
		
		logger.debug("updateJournalForm ended");
	}

	@Override
	public void deleteJournalForm(String formId, String companyId, String tenantId) {
		logger.debug("deleteJournalForm started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("formId", formId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezJournalDAO.deleteJournalForm(map);
		ezJournalDAO.deleteFormUseDept(map);
		
		logger.debug("deleteJournalForm ended");
		
	}
}
