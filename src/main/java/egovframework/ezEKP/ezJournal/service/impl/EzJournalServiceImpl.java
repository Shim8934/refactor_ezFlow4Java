package egovframework.ezEKP.ezJournal.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import egovframework.ezEKP.ezJournal.dao.EzJournalDAO;
import egovframework.ezEKP.ezJournal.service.EzJournalService;
import egovframework.ezEKP.ezJournal.vo.DeptInfoVO;
import egovframework.ezEKP.ezJournal.vo.DeptViewVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthorVO;
import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezJournal.vo.JournalEnvVO;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournalVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.ezEKP.ezJournal.vo.ReceiverFavoriteVO;
import egovframework.let.utl.fcc.service.JsonUtil;


@Service("ezJournalService")
public class EzJournalServiceImpl implements EzJournalService{

	private static final Logger logger = LoggerFactory.getLogger(EzJournalServiceImpl.class);

	@Resource(name="ezJournalDAO")
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
	public List<JournalFormInfoVO> getFormList(String typeId, String deptId, String companyId, String tenantId) throws Exception {
		logger.debug("getFormList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
	//	map.put("listType", listType);
		map.put("typeId", typeId);
		map.put("deptId", deptId);
		logger.debug("deptId확인:" + deptId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<JournalFormInfoVO> formList = ezJournalDAO.getFormList(map);
		
		if ((deptId == null || deptId.equals("")) && !typeId.equals("basic")) {
			List<JournalFormInfoVO> resultList = new ArrayList<JournalFormInfoVO>();
			
			for (int i = 0; i < formList.size(); i++) {
				JournalFormInfoVO vo = formList.get(i);
				map.put("formId", vo.getFormId());
				
				try {
					List<DeptInfoVO> useDept = ezJournalDAO.getFormUseDeptList(map);
	
					if (useDept.size() < 1) {
						useDept.clear();
						DeptInfoVO deptVO = new DeptInfoVO();
						deptVO.setDeptName(companyId);	// 회사이름 들어가게 수정하기
						useDept.add(deptVO);
					}
					vo.setDepts(useDept);
					resultList.add(vo);
					
				} catch (Exception e) { 
					e.printStackTrace();
				}
				
			}
			return resultList;
		}
		logger.debug("getFormList ended");
		return formList;
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
		
	@Override
	public void saveAuthDeptList(JSONObject jsonParam) throws Exception {
		logger.debug("saveAuthDeptList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", jsonParam.get("userId"));
		map.put("tenantId", jsonParam.get("tenantId"));
		ezJournalDAO.deleteAuthDept(map);
		Gson gson = new Gson();
		
		List<String> deptList = gson.fromJson(jsonParam.get("depts").toString(), new TypeToken<List<String>>(){}.getType());
		for (int i = 0; i < deptList.size(); i++) {
			try {
				logger.debug(deptList.get(i));
				Map<String, Object> insertMap = new HashMap<String, Object>();
				insertMap.put("tenantId", ((String) jsonParam.get("tenantId")).trim());
				insertMap.put("userId", ((String) jsonParam.get("userId")).trim());
				insertMap.put("deptId", ((String) deptList.get(i)).trim());
				ezJournalDAO.insertAuthDept(insertMap);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		logger.debug("saveAuthDeptList ended");
	}

	@Override
	public void deleteAuthor(String userId, String tenantId) throws Exception {
		logger.debug("deleteAuthor started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId",tenantId);
		ezJournalDAO.deleteAuthDept(map);
		
		logger.debug("deleteAuthor ended");
	}

	@Override
	public void saveFavorite(JSONObject jsonParam) throws Exception {
		logger.debug("saveFavorite started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", jsonParam.get("userId"));
		map.put("tenantId", jsonParam.get("tenantId"));
		map.put("favoriteName", jsonParam.get("favoriteName"));
		
		logger.debug("saveFavorite map" + map);
		
		String tenantId = jsonParam.get("tenantId").toString();
		
		logger.debug((String)jsonParam.get("receiverList"));
		
		List<Map<String, Object>> receivers = JsonUtil.JsonToList((String) jsonParam.get("receiverList")); 
		if (receivers != null) {
			String favoriteId = ezJournalDAO.saveReceiverFavorite(map) + "";
			for (int i = 0; i < receivers.size(); i++) {
				try {
					insertFavoriteUserList(favoriteId, receivers.get(i).get("userId").toString(), tenantId);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		logger.debug("saveFavorite ended");
	}

	private void insertFavoriteUserList(String favoriteId, String receiver, String tenantId) {
		logger.debug("insertFavoriteUserList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("favoriteId", favoriteId);
		map.put("userId", receiver);
		map.put("tenantId", tenantId);
		
		ezJournalDAO.insertFavoriteUser(map);
		
		logger.debug("insertFavoriteUserList ended");
	}

	@Override
	public List<ReceiverFavoriteVO> getFavoriteList(String userId, String tenantId) {
		logger.debug("getFavoriteList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		List<ReceiverFavoriteVO> favoriteList = ezJournalDAO.getFavoriteList(map);
		logger.debug("즐겨찾기 : " + favoriteList);
		
		logger.debug("getFavoriteList ended");
		return favoriteList;
	}

	@Override
	public List<JournalAuthorVO> getFavoriteUserList(String favoriteId, String tenantId) { 
		logger.debug("getFavoriteUserList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("favoriteId", favoriteId);
		map.put("tenantId", tenantId);
		
		List<JournalAuthorVO> userList = ezJournalDAO.getFavoriteUserList(map);
		logger.debug("유저리스트 : " + userList);
		
		logger.debug("getFavoriteUserList ended");
		return userList;
	}

	@Override
	public void modifyFavorite(JSONObject jsonParam) {
		logger.debug("modifyFavorite started");

		String favoriteId = jsonParam.get("favoriteId").toString();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", jsonParam.get("userId"));
		map.put("tenantId", jsonParam.get("tenantId"));
		map.put("favoriteName", jsonParam.get("favoriteName"));
		map.put("favoriteId", favoriteId);
		
		logger.debug("modifyFavorite map" + map);
		
		String tenantId = jsonParam.get("tenantId").toString();
		
		logger.debug((String)jsonParam.get("receiverList"));
		
		List<Map<String, Object>> receivers = JsonUtil.JsonToList((String) jsonParam.get("receiverList")); 
		if (receivers != null) {
			ezJournalDAO.deleteFavoriteUser(map);
			ezJournalDAO.updateFavoriteName(map);
			for (int i = 0; i < receivers.size(); i++) {
				try {
					insertFavoriteUserList(favoriteId, receivers.get(i).get("userId").toString(), tenantId);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		logger.debug("modifyFavorite ended");
	}

	@Override
	public void deleteFavorite(String favoriteId, String userId, String tenantId) {
		logger.debug("deleteFavorite started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("favoriteId", favoriteId);
		
		logger.debug("deleteFavorite map" + map);
		
		try {
			ezJournalDAO.deleteFavoriteUser(map);
			ezJournalDAO.deleteFavorite(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("deleteFavorite ended");
	}
	
	@Override
	public String getRecvJournalCount(String userId, String tenantId) {
		logger.debug("getRecvJournalCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId",tenantId);
		String result =ezJournalDAO.selectRecvCount(map);
		
		logger.debug("getRecvJournalCount ended");
		return result;
	}

	@Override
	public JournalEnvVO getUserJournalEnv(String userId, String tenantId) {
		logger.debug("getUserJournalEnv started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId",tenantId);
		JournalEnvVO result =ezJournalDAO.selectUserEnv(map);
		
		logger.debug("getUserJournalEnv ended");
		
		return result;
	}

	@Override
	public String getTotalListCount(Map<String, Object> map) {
		logger.debug("getTotalListCount started");
		String result = ezJournalDAO.selectTotalListCount(map);
		logger.debug("getTotalListCount ended");
		return result;
	}

	@Override
	public List<JournalVO> getJournalList(Map<String, Object> map) throws Exception {
		logger.debug("getJournalList started");
		List<JournalVO> result = ezJournalDAO.selectJournalList(map);
		logger.debug("getJournalList ended");
		return result;
	}

	@Override
	public void saveJournalEnv(Map<String, Object> map) throws Exception {
		logger.debug("saveJournalEnv started");
		ezJournalDAO.insertUpdateJournalEnv(map);
		logger.debug("saveJournalEnv ended");
	}
		
	@Override
	public String getJournalLastFormId(String typeId, String formId, String userId, String companyId, String tenantId) {
		logger.debug("getJournalLastFormId started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("formId", formId);
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		logger.debug("getJournalFormContent map : " + map);
		
		String lastFormId = ezJournalDAO.getJournalLastFormId(map);
		
		if (lastFormId == null) {
			lastFormId = "";
		}
		
		logger.debug("getJournalLastFormId ended");
		return lastFormId;
	}
}
