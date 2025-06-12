package egovframework.ezEKP.ezJournal.service.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.*;

import javax.annotation.Resource;

import egovframework.let.utl.fcc.service.EzFAL;
import org.apache.commons.io.FileUtils;
import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import egovframework.ezEKP.ezJournal.dao.EzJournalDAO;
import egovframework.ezEKP.ezJournal.service.EzJournalService;
import egovframework.ezEKP.ezJournal.vo.DeptInfoVO;
import egovframework.ezEKP.ezJournal.vo.DeptViewVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthCheckVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthorVO;
import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezJournal.vo.JournalEnvVO;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournalReceiverVO;
import egovframework.ezEKP.ezJournal.vo.JournalReplyVO;
import egovframework.ezEKP.ezJournal.vo.JournalVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.ezEKP.ezJournal.vo.ReceiverFavoriteVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("ezJournalService")
public class EzJournalServiceImpl implements EzJournalService {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalServiceImpl.class);

	@Resource(name="ezJournalDAO")
	private EzJournalDAO ezJournalDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public List<JournaltypeVO> getJournaltypeList(String companyId, int tenantId, String used) throws Exception {
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
	public void updateJournaltype(ArrayList<Map<String, String>> journaltypeList, String companyId, int tenantId) throws Exception {
		logger.debug("updateJournaltype started");
		
		for (int i = 0; i < journaltypeList.size(); i++) {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("typeId", journaltypeList.get(i).get("typeId"));
			param.put("used", journaltypeList.get(i).get("used"));
			param.put("companyId", companyId);
			param.put("tenantId", tenantId);
			logger.debug("parammap" + param);
			ezJournalDAO.updateJournaltype(param);
		}
		
		logger.debug("updateJournaltype ended");
	}

	@Override
	public void insertJournaltype(String companyId, int tenantId, ArrayList<String> journaltypeList) throws Exception {
		logger.debug("insertJournaltype started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		for (int i = 0; i < journaltypeList.size(); i++) {
			map.put("typeId", journaltypeList.get(i));
			ezJournalDAO.insertJournaltype(map);
			ezJournalDAO.insertJournalBasicForm(map);
		}

		logger.debug("insertJournaltype ended");
	}
	
	@Override
	public void deleteJournaltype(String companyId, int tenantId) throws Exception {
		logger.debug("deleteJournaltype started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		ezJournalDAO.deleteJournaltypeList(map);
		
		logger.debug("deleteJournaltype ended");
	}

	@Override
	public List<JournalFormInfoVO> getFormListAdmin(String typeId, String deptId, String companyId, int tenantId, String offset, String lang) throws Exception {
		logger.debug("getFormListAdmin started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("deptId", deptId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("lang", lang);
		
		List<JournalFormInfoVO> formList = ezJournalDAO.getFormListAdmin(map);

		logger.debug("getFormListAdmin ended");
		return formList;
	}
	
	@Override
	public List<JournalFormInfoVO> getFormList(String typeId, String deptId, String companyId, int tenantId) throws Exception {
		logger.debug("getFormList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("deptId", deptId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<JournalFormInfoVO> formList = ezJournalDAO.getFormList(map);
		
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
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
		map.put("companyId", jsonParam.get("companyId"));
		map.put("tenantId", jsonParam.get("tenantId"));
		
//		logger.debug("insertForm map" + map);
		
		String tenantId = jsonParam.get("tenantId").toString();
		String formId = ezJournalDAO.insertForm(map) + "";
		String isDeptChanged = (String) jsonParam.get("isDeptChanged");
		
		if (isDeptChanged.equals("Y")) {
		//	logger.debug("****" + (String)jsonParam.get("useDept"));
			
			if (jsonParam.get("useDept") != null) {
				Gson gson = new Gson();
				List<Map<String, Object>> depts = gson.fromJson(jsonParam.get("useDept").toString(), new TypeToken<List<Map<String, Object>>>(){}.getType());
				
				if (depts != null) {
					for (int i = 0; i < depts.size(); i++) {
						try {
							insertUseDept(formId, depts.get(i).get("deptId").toString(), tenantId);
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
						}
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
	public List<JournalCompanyVO> getCompanyList(String userId, int tenantId, String companyId,String lang) throws Exception {
		logger.debug("getCompanyList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		param.put("companyId", companyId);
		param.put("lang", lang);
		List<JournalCompanyVO> compList = ezJournalDAO.getCompanyList(param);
		
		logger.debug("getCompanyList ended");
		return compList;
	}

	@Override
	public List<JournalAuthorVO> getAuthorList(String companyId, int tenantId,String lang) throws Exception {
		logger.debug("getAuthorList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("companyId", companyId);
		param.put("lang", lang);
		List<JournalAuthorVO> authList = ezJournalDAO.getAuthorList(param);
		
		logger.debug("getAuthorList ended");
		return authList;
	}

	@Override
	public List<DeptViewVO> getDeptViewList(String userId,String companyId, int tenantId,String lang) throws Exception {
		logger.debug("getDeptViewList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		param.put("companyId", companyId);
		param.put("lang", lang);
		List<DeptViewVO> deptList = ezJournalDAO.getDeptViewVO(param);
		for(int i=0; i < deptList.size(); i++) {
			deptList.get(i).setText(commonUtil.cleanValue(deptList.get(i).getText())); 
		}
		
		logger.debug("getDeptViewList ended");
		return deptList;
	}

	@Override
	public List<JournalAuthorVO> getAuthDeptList(int tenantId, String userId, String lang, String userCompany) throws Exception {
		logger.debug("getAuthDeptList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		param.put("userCompany", userCompany);
		param.put("lang", lang);
		List<JournalAuthorVO> deptList = ezJournalDAO.getAuthDeptList(param);
		for(int i=0; i < deptList.size(); i++) {
			deptList.get(i).setDeptName(commonUtil.cleanValue(deptList.get(i).getDeptName())); 
		}
		
		logger.debug("getAuthDeptList ended");
		return deptList;
	}
	
	@Override
	public List<JournalAuthorVO> getDeptUserList(int tenantId, String key ,String value, String companyId, String lang, String curPage) throws Exception{
		logger.debug("getDeptUserList started");
		// 페이징 설정
		int pageSize = 50;
		int page = pageSize * (Integer.parseInt(curPage)-1);
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("key", key.toUpperCase());
		param.put("value", value);
		param.put("companyId", companyId);
		param.put("lang", lang);
		param.put("curPage", page);
		param.put("pageSize", pageSize);
		List<JournalAuthorVO> userList = ezJournalDAO.getDeptUserList(param);
		
		logger.debug("getDeptUserList ended");
		return userList;
	}
	
	public int getDeptUserListCount(int tenantId, String key ,String value, String companyId, String lang) throws Exception{
		logger.debug("getDeptUserListCount started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("key", key.toUpperCase());
		param.put("value", value);
		param.put("companyId", companyId);
		param.put("lang", lang);
		
		int userListCount = ezJournalDAO.getDeptUserListCount(param);
		
		return userListCount;
	}

	@Override
	public JournalFormInfoVO getJournalFormInfo(String formId, String companyId, int tenantId, String lang) throws Exception {
		logger.debug("getJournalFormInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("formId", formId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		
		JournalFormInfoVO journalFormInfoVO = ezJournalDAO.getJournalFormInfo(map);
		
		List<DeptInfoVO> deptList = ezJournalDAO.getFormUseDeptList(map);
		if (deptList.size() > 0) {
			journalFormInfoVO.setDepts(deptList);
		}
		
		logger.debug("getJournalFormInfo ended");
		return journalFormInfoVO;
	}

	@Override
	public void updateJournalForm(JSONObject jsonParam) throws Exception {
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
		
//		logger.debug("updateForm map" + map);
		String tenantId = jsonParam.get("tenantId").toString();
		String isDeptChanged = (String) jsonParam.get("isDeptChanged");
		
//		logger.debug("isDeptChanged : " + isDeptChanged);
		ezJournalDAO.updateJournalForm(map);
		
		if (isDeptChanged.equals("Y")) {
			
			ezJournalDAO.deleteFormUseDept(map);
			
			if (jsonParam.get("useDept") != null) {
				Gson gson = new Gson();
				List<Map<String, Object>> depts = gson.fromJson(jsonParam.get("useDept").toString(), new TypeToken<List<Map<String, Object>>>(){}.getType());
				
				if (depts != null) {
					for (int i = 0; i < depts.size(); i++) {
						try {
							insertUseDept(jsonParam.get("formId").toString(), depts.get(i).get("deptId").toString(), tenantId);
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
						}
					}
				}
			}
		}
		
		logger.debug("updateJournalForm ended");
	}

	@Override
	public void deleteJournalForm(String formId, String companyId, int tenantId) throws Exception {
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
		if (jsonParam.get("admin").equals("Y")){
			ezJournalDAO.deleteAuthDept(map);
		} else {
			List<DeptViewVO> cheifDeptList = ezJournalDAO.selectCheifBossList(map);
			List<DeptViewVO> addCheifDeptList = new ArrayList<DeptViewVO>();
			
			for (DeptViewVO deptViewVO : cheifDeptList) {
				map.put("deptId", deptViewVO.getId());
				addCheifDeptList.addAll(ezJournalDAO.selectCheifBoss(map));
			}
			cheifDeptList.addAll(addCheifDeptList);
			for (DeptViewVO deptViewVO : cheifDeptList) {
				map.put("deptId", deptViewVO.getId());
				ezJournalDAO.deleteAuthDeptOne(map);
			}
		}
		Gson gson = new Gson();
		
		List<String> deptList = gson.fromJson(jsonParam.get("depts").toString(), new TypeToken<List<String>>(){}.getType());
		for (int i = 0; i < deptList.size(); i++) {
			try {
			//	logger.debug("****" + deptList.get(i));
				Map<String, Object> insertMap = new HashMap<String, Object>();
				insertMap.put("tenantId", jsonParam.get("tenantId"));
				insertMap.put("userId", ((String) jsonParam.get("userId")).trim());
				insertMap.put("deptId", ((String) deptList.get(i)).trim());
				ezJournalDAO.insertAuthDept(insertMap);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
		
		logger.debug("saveAuthDeptList ended");
	}

	@Override
	public void deleteAuthor(String userId, int tenantId) throws Exception {
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
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
//		logger.debug("saveFavorite map" + map);
		
		String tenantId = jsonParam.get("tenantId").toString();
		
//		logger.debug((String)jsonParam.get("receiverList"));
		
//		List<Map<String, Object>> receivers = JsonUtil.JsonToList((String) jsonParam.get("receiverList")); 
		Gson gson = new Gson();
		List<Map<String, Object>> receivers = gson.fromJson(jsonParam.get("receiverList").toString(), new TypeToken<List<Map<String, Object>>>(){}.getType());
		
		if (receivers != null) {
			String favoriteId = ezJournalDAO.saveReceiverFavorite(map) + "";
			for (int i = 0; i < receivers.size(); i++) {
				try {
					insertFavoriteUserList(favoriteId, receivers.get(i).get("userId").toString(), tenantId);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		logger.debug("saveFavorite ended");
	}

	private void insertFavoriteUserList(String favoriteId, String receiver, String tenantId) throws Exception {
		logger.debug("insertFavoriteUserList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("favoriteId", favoriteId);
		map.put("userId", receiver);
		map.put("tenantId", tenantId);
		
		ezJournalDAO.insertFavoriteUser(map);
		
		logger.debug("insertFavoriteUserList ended");
	}

	@Override
	public List<ReceiverFavoriteVO> getFavoriteList(String userId, int tenantId, String offset) throws Exception {
		logger.debug("getFavoriteList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		List<ReceiverFavoriteVO> favoriteList = ezJournalDAO.getFavoriteList(map);
		
		logger.debug("getFavoriteList ended");
		return favoriteList;
	}

	@Override
	public List<JournalReceiverVO> getFavoriteUserList(String favoriteId, int tenantId, String lang) throws Exception { 
		logger.debug("getFavoriteUserList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("favoriteId", favoriteId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		
		List<JournalReceiverVO> userList = ezJournalDAO.getFavoriteUserList(map);
		
		logger.debug("getFavoriteUserList ended");
		return userList;
	}

	@Override
	public void modifyFavorite(JSONObject jsonParam) throws Exception {
		logger.debug("modifyFavorite started");

		String favoriteId = jsonParam.get("favoriteId").toString();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", jsonParam.get("userId"));
		map.put("tenantId", jsonParam.get("tenantId"));
		map.put("favoriteName", jsonParam.get("favoriteName"));
		map.put("favoriteId", favoriteId);
		
//		logger.debug("modifyFavorite map" + map);
		
		String tenantId = jsonParam.get("tenantId").toString();
		
//		logger.debug((String)jsonParam.get("receiverList"));
		
	//	List<Map<String, Object>> receivers = JsonUtil.JsonToList((String) jsonParam.get("receiverList")); 
		Gson gson = new Gson();
		List<Map<String, Object>> receivers = gson.fromJson(jsonParam.get("receiverList").toString(), new TypeToken<List<Map<String, Object>>>(){}.getType());
		
//		logger.debug("receivers : " + receivers);
		if (receivers != null) {
			ezJournalDAO.deleteFavoriteUser(map);
			ezJournalDAO.updateFavoriteName(map);
			for (int i = 0; i < receivers.size(); i++) {
				try {
					insertFavoriteUserList(favoriteId, receivers.get(i).get("userId").toString(), tenantId);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		logger.debug("modifyFavorite ended");
	}

	@Override
	public void deleteFavorite(String favoriteId, String userId, int tenantId) throws Exception {
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
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("deleteFavorite ended");
	}
	
	@Override
	public String getRecvJournalCount(String userId, int tenantId) throws Exception {
		logger.debug("getRecvJournalCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		String result = ezJournalDAO.selectRecvCount(map);
		
		logger.debug("getRecvJournalCount ended");
		return result;
	}

	/* 2024-07-17 홍승비 - SQL Injection 수정 > 알림 메일 발송을 위한 사용자명 다국어 처리 정상 동작하도록 lang 파라미터 추가 */
	@Override
	public JournalEnvVO getUserJournalEnv(String userId, String lang, int tenantId) throws Exception {
		logger.debug("getUserJournalEnv started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		
		JournalEnvVO result = ezJournalDAO.selectUserEnv(map);
		
		logger.debug("getUserJournalEnv ended");
		
		return result;
	}

	@Override
	public String getTotalListCount(Map<String, Object> map) throws Exception {
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
	public String getJournalLastFormId(String typeId, String formId, String userId, String companyId, int tenantId) throws Exception {
		logger.debug("getJournalLastFormId started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("formId", formId);
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
//		logger.debug("getJournalFormContent map : " + map);
		
		String lastFormId = ezJournalDAO.getJournalLastFormId(map);
		
		if (lastFormId == null) {
			lastFormId = "";
		}
		
		logger.debug("getJournalLastFormId ended");
		return lastFormId;
	}

	@Override
	public JournalVO getJournal(String journalId,String userId, int tenantId, String lang, String offset, String pPreviewShow_HOW) throws Exception {
		logger.debug("getJournal started");
		logger.debug("journalId: " + journalId + ", tenantId: " + tenantId + ", userId: " + userId);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("journalId", journalId);
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		param.put("viewDate", commonUtil.getTodayUTCTime(""));
		param.put("lang", lang);
		param.put("offset", commonUtil.getMinuteUTC(offset));
		
		if (pPreviewShow_HOW != null && (pPreviewShow_HOW.equals("H") || pPreviewShow_HOW.equals("W") || pPreviewShow_HOW.equals("D"))) {
			ezJournalDAO.insertViewInfo(param);
		}
		JournalVO result = ezJournalDAO.selectJournal(param);
		logger.debug("getJournal ended");
		
		return result;
	}

	@Override
	public String insertJournal(JSONObject jsonParam, String deptId, int tenantId, String realPath) throws Exception {
		logger.debug("insertJournal started");
		
		String mode = jsonParam.get("mode").toString();
		String journalContent = jsonParam.get("content").toString();
		String isTemp = "";
		String originJournalId = "";
		if (jsonParam.get("isTemp") != null) {
			isTemp = jsonParam.get("isTemp").toString();
		}
		logger.debug("isTemp : " + isTemp + ",mode : " + mode);
		
		Document journalDoc = Jsoup.parseBodyFragment(journalContent);
		Element journalBody = journalDoc.body();
		String journalText = journalBody.text();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("writerId", jsonParam.get("userId"));
		map.put("tenantId", tenantId);
		map.put("title", jsonParam.get("title"));
		map.put("content", journalContent);
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
		map.put("deptId", deptId);
		map.put("formId", jsonParam.get("formId"));
		map.put("deptShare", jsonParam.get("deptShare"));
		map.put("journalText", journalText);
		map.put("isSum", jsonParam.get("isSum"));
		if ((mode != null && mode.equals("temp")) || !isTemp.equals("")) {
			map.put("journalStatus", "temp");
		}
		if (mode != null && mode.equals("reuse")) {
			originJournalId = (String) jsonParam.get("originJournalId");
		}
		
//		logger.debug("insertJournal map" + map);
		
		String journalId = commonUtil.detectPathTraversal(ezJournalDAO.insertJournal(map) + "");
		
		String fileList = jsonParam.get("fileList").toString();
//		logger.debug("fileList정보 : " + fileList.toString());
	
		// 첨부파일 저장
		Map<String, Object> attachMap = new HashMap<String, Object>();
		String pDirPath = "";
		
		if (fileList != null && !fileList.equals("")) {
			
			pDirPath = commonUtil.getUploadPath("upload_journal.ROOT", tenantId);
			pDirPath = realPath + pDirPath;
			
//			logger.debug("pDirPath : " + pDirPath + ",reapPath : " + realPath);
			
			if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
				pDirPath = pDirPath + commonUtil.separator;
			}
			
			EzFAL.EzFile file = new EzFAL.EzFile(pDirPath + "uploadFile" + commonUtil.separator + journalId + "_uploadFile");
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			String[] attach = fileList.split("/");
			
			attachMap.put("journalId", journalId);
			attachMap.put("tenantId", tenantId);
			
			for (int i = 0; i < attach.length; i++) {
				String[] files = attach[i].split(":");
				String filePath = commonUtil.detectPathTraversal(files[0]);
				String fileName = commonUtil.detectPathTraversal(files[1]);
				String fileSize = files[2];
				String extension = fileName.substring(fileName.lastIndexOf(".") + 1);
				
				logger.debug("filePath : " + filePath + " | fileName : " + fileName + " | fileSize : " + fileSize);
				
				String uploadFilePath = commonUtil.separator + journalId + "_uploadFile" + commonUtil.separator + filePath + "." + extension;
				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + "." + extension;
				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + journalId + "_uploadFile" + commonUtil.separator + filePath + "." + extension;
			
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFilePath);
				
//				logger.debug("uploadFilePath : " + uploadFilePath);
				
				ezJournalDAO.insertJournalAttach(attachMap);
			
				if (mode.equals("reuse")) {
					
					String orgFilePath = "";
					String destFilePath = "";
					String reuseFileName = "";
					
					try {
						orgFilePath = commonUtil.detectPathTraversal(pDirPath + "uploadFile" + commonUtil.separator + originJournalId + "_uploadFile" + commonUtil.separator + filePath + "." + extension);
					//	filePath = "{" + UUID.randomUUID() + "}";
						reuseFileName = filePath + "." + extension;
						destFilePath = commonUtil.detectPathTraversal(pDirPath + "uploadFile" + commonUtil.separator + journalId + "_uploadFile" + commonUtil.separator + reuseFileName);

						EzFAL.copyFile(orgFilePath, destFilePath);
					} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
				}
			
				try {
					EzFAL.moveFile(beforeFilePath, afterFilePath);	// Temp 폴더에서 첨부파일 이동
				} catch (FileNotFoundException e) {logger.debug("e.message=" + e.getMessage());}
			}
			
		}
		
		// 수신자 정보 저장
		String receiverIDs = jsonParam.get("receiverIDs").toString();
//		String receiverList = jsonParam.get("receiverList").toString();
		
//		logger.debug("receiverIDs : " + receiverIDs);
		
		if (receiverIDs != null && !receiverIDs.equals("")) {
			
			Map<String, Object> receiverMap = new HashMap<String, Object>();
			
			String[] receiverID = receiverIDs.split(",");
//			String[] receiverName = receiverList.split(",");
			
			receiverMap.put("journalId", journalId);
			receiverMap.put("tenantId", tenantId);

			for (int i = 0; i < receiverID.length; i++) {
				receiverMap.put("receiverId", receiverID[i].trim());
				ezJournalDAO.insertReceiver(receiverMap);
			}
		}
		
		logger.debug("insertJournal ended");
		return journalId;
	}
	
	private void fileMove(String beforeFilePath, String afterFilePath) throws Exception {
		logger.debug("fileMove started.");
		logger.debug("beforeFilePath = " + beforeFilePath + " || afterFilePath = " + afterFilePath);
		
		EzFAL.EzFile srcFile = new EzFAL.EzFile(commonUtil.detectPathTraversal(beforeFilePath));
		EzFAL.EzFile destFile = new EzFAL.EzFile(commonUtil.detectPathTraversal(afterFilePath));
		
		try {
			boolean rename = srcFile.renameTo(destFile);
			if (!rename) {
				EzFAL.copyFile(srcFile, destFile);
				if (!srcFile.delete()) {
					destFile.delete();
					throw new IOException("Failed to delete original file '" + srcFile + "' after copy to '" + destFile + "'");
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("fileMove ended.");
	}

	@Override
	public JournalFormInfoVO getJournalDivideThisNext(List<String> journalIdList, String formId, String companyId, String userId, int tenantId) throws Exception {
		logger.debug("getJournalDivideThisNext started.");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("formId", formId);
		param.put("companyId", companyId);
		param.put("userId", userId);
		
		JournalFormInfoVO form = ezJournalDAO.getJournalFormInfo(param);
		String formContent = form.getFormContent();
		Document formDoc = Jsoup.parseBodyFragment(formContent);
		Element formBody = formDoc.body();
		Element formThis = formBody.getElementById("thisJournal");
		Element formNext = formBody.getElementById("nextJournal");
		StringBuilder formThisHtml = new StringBuilder();
		StringBuilder formNextHtml = new StringBuilder();
		
		/* 2024-07-17 홍승비 - SQL Injection 수정 > 문자열이 아닌 리스트를 파라미터로 전달 */
		param.put("journalIdS", journalIdList);
		
		List<JournalVO> journalList = ezJournalDAO.selectSumJournalList(param);
		
		try {	
		for (JournalVO journal : journalList) {
			String journalContent = journal.getJournalContent();
			Elements thisElems = Jsoup.parseBodyFragment(journalContent).body().getElementById("thisJournal").children();

			Iterator<Element> it = thisElems.iterator();
			while (it.hasNext()) {
				String elemHtml = it.next().html().replaceAll("&nbsp;", "");
				String elemText =Jsoup.parseBodyFragment(elemHtml).text().trim();
				if (elemText.equals("")) {
					it.remove();
				} else {
					break;
				}
			}
			String thisContent = thisElems.toString();
			
			Elements nextElems = Jsoup.parseBodyFragment(journalContent).body().getElementById("nextJournal").children();

			it = nextElems.iterator();
			while (it.hasNext()) {
				String elemHtml = it.next().html().replaceAll("&nbsp;", "");
				String elemText =Jsoup.parseBodyFragment(elemHtml).text().trim();
				if (elemText.equals("")) {
					it.remove();
				} else {
					break;
				}
			}
			String nextContent = nextElems.toString();
			
			// #146bb8 rgb(0, 144, 208)
//			formThisHtml.append("<p><span style='color: #004a87'>" + journal.getJournalTitle().trim() + "</span></p>");
//			formThisHtml.append("<p><img style='width:16px;height:16px;vertical-align:bottom;' src='/images/ImgIcon/icon_partapproval.gif'>" + journal.getJournalTitle().trim() + "</span></p>");
			formThisHtml.append("<p><img style='width:14px;height:14px;vertical-align:middle;margin-left:5px' src='/images/ImgIcon/addon.png'>&nbsp;<span style='color: #58ACFA; font-family: Malgun Gothic; font-size: 13px;'>" + commonUtil.cleanValue(journal.getJournalTitle().trim()) + "</span></p>");
			formThisHtml.append("<p><br/></p>" + thisContent.trim() + "<p><br/></p>");
			
//			formNextHtml.append("<p><span style='color: #004a87'>" + journal.getJournalTitle().trim() + "</span></p>");   
//			formNextHtml.append("<p><img style='width:16px;height:16px;vertical-align:bottom;' src='/images/ImgIcon/icon_partapproval.gif'>" + journal.getJournalTitle().trim() + "</span></p>");
			formNextHtml.append("<p><img style='width:14px;height:14px;vertical-align:middle;margin-left:5px' src='/images/ImgIcon/addon.png'>&nbsp;<span style='color: #58ACFA; font-family: Malgun Gothic; font-size: 13px;'>" + commonUtil.cleanValue(journal.getJournalTitle().trim()) + "</span></p>");
			formNextHtml.append("<p><br/></p>" + nextContent.trim() + "<p><br/></p>");
		}
		
		formThis.append(formThisHtml.toString());
		formNext.append(formNextHtml.toString());
		form.setFormContent(formDoc.toString());
		} catch (Exception e) {
			logger.debug("journal sum is fail");
			form.setFormInfo("fail");
		}
		logger.debug("getJournalDivideThisNext ended.");
		return form;
	}
	
	@Override
	public void updateJournal(String journalId, JSONObject jsonParam, int tenantId, String realPath) throws Exception {
		logger.debug("updateJournal started.");
		
	//	String mode = jsonParam.get("mode").toString();
		String journalContent = jsonParam.get("content").toString();
		String isTemp = "";
		
		Document journalDoc = Jsoup.parseBodyFragment(journalContent);
		Element journalBody = journalDoc.body();
		String journalText = journalBody.text();
		
		if (jsonParam.get("isTemp") != null) {
			isTemp = jsonParam.get("isTemp").toString().trim();
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("title", jsonParam.get("title"));
		map.put("formId", jsonParam.get("formId"));
		map.put("content", journalContent);
		map.put("deptShare", jsonParam.get("deptShare"));
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
		map.put("journalId", journalId);
		map.put("tenantId", tenantId);
		map.put("journalText", journalText);
		
		if (isTemp != null) {
			map.put("deptId", jsonParam.get("deptId"));
			map.put("isTemp", isTemp);
			map.put("journalStatus", "");
		}
		
		logger.debug("updateJournal map" + map);
		
		ezJournalDAO.updateJournal(map);

		
		// 첨부파일 삭제 후 저장
		ezJournalDAO.deleteJournalAttach(map);
		
		String fileList = jsonParam.get("fileList").toString();
		
		Map<String, Object> attachMap = new HashMap<String, Object>();
		
		if (fileList != null && !fileList.equals("")) {
//			logger.debug("updateJournal fileList : " + fileList);
			
			String[] attach = fileList.split("/");
			
			attachMap.put("journalId", journalId);
			attachMap.put("tenantId", tenantId);
			
			for (int i = 0; i < attach.length; i++) {
				String[] files = attach[i].split(":");
				String filePath = commonUtil.detectPathTraversal(files[0]);
				String fileName = commonUtil.detectPathTraversal(files[1]);
				String fileSize = files[2];
				String extension = fileName.substring(fileName.lastIndexOf(".") + 1);
				
				logger.debug("filePath : " + filePath + " | fileName : " + fileName + " | fileSize : " + fileSize);
				
				String uploadFilePath = commonUtil.separator + journalId + "_uploadFile" + commonUtil.separator + filePath + "." + extension;
				
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFilePath);
				
//				logger.debug("uploadFilePath : " + uploadFilePath);
				
				ezJournalDAO.insertJournalAttach(attachMap);
				
				// mode 가 수정일때?? Temp폴더에서 첨부파일 이동
				String pDirPath = "";
				pDirPath = commonUtil.getUploadPath("upload_journal.ROOT", tenantId);
				pDirPath = realPath + pDirPath;
						
				if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
					pDirPath = pDirPath + commonUtil.separator;
				}
						
				EzFAL.EzFile file = new EzFAL.EzFile(pDirPath + "uploadFile" + commonUtil.separator + journalId + "_uploadFile");
						
				if (!file.exists()) {
					file.mkdirs();
				}
				
				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + "." + extension;
				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + journalId + "_uploadFile" + commonUtil.separator + filePath + "." + extension;
				
				try {
					EzFAL.moveFile(beforeFilePath, afterFilePath);	// Temp 폴더에서 첨부파일 이동
				} catch (FileNotFoundException e) {logger.debug("e.message=" + e.getMessage());}
			}
		}
		
		// 수신자 삭제 후 저장
		ezJournalDAO.deleteReceiver(map);
		
		String receiverIDs = jsonParam.get("receiverIDs").toString();
//		logger.debug("receiverIDs : " + receiverIDs);

		if (receiverIDs != null && !receiverIDs.equals("")) {
			
			Map<String, Object> receiverMap = new HashMap<String, Object>();
			
			String[] receiverID = receiverIDs.split(",");
			
			receiverMap.put("journalId", journalId);
			receiverMap.put("tenantId", tenantId);
			
			for (int i = 0; i < receiverID.length; i++) {
				receiverMap.put("receiverId", receiverID[i].trim());
				ezJournalDAO.insertReceiver(receiverMap);
			}
		}
		logger.debug("updateJournal ended.");
	}

	@Override
	public void deleteJournalList(List<String> journalIdList, String pDirPath, int tenantId) throws Exception {
		logger.debug("deleteJournalList started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		for (int i = 0; i < journalIdList.size(); i++) {
			String journalId = journalIdList.get(i);
			map.put("journalId", journalId);
			
			ezJournalDAO.deleteJournal(map);
			ezJournalDAO.deleteReceiver(map);
			ezJournalDAO.deleteJournalAttach(map);
			deleteDirectory(journalId, pDirPath, tenantId);
		}
		
		logger.debug("deleteJournalList ended.");
	}
	
	private void deleteDirectory (String journalId, String pDirpath, int tenantId) throws Exception {
		logger.debug("deleteDirectory started.");
		
		EzFAL.EzFile directoryFile = new EzFAL.EzFile(commonUtil.detectPathTraversal(pDirpath + "uploadFile" + commonUtil.separator + journalId + "_uploadFile"));
		EzFAL.EzFile[] deleteFileList = directoryFile.listFiles();

		if (directoryFile.exists()) {
			// 디렉토리 하위의 파일을 모두 삭제 한뒤 디렉토리 삭제
			if (deleteFileList.length >0) {
				for (int i=0; i<deleteFileList.length; i++) {
					if (deleteFileList[i].isFile()) {
						deleteFileList[i].delete();
					} else {
						deleteDirectory(journalId, pDirpath, tenantId);
					}
				}
			}
			directoryFile.delete();
		}

		logger.debug("deleteDirectory ended.");
	}

	@Override
	public void updateJournalStatus(List<String> journalIdList, String userId, int tenantId) throws Exception {
		logger.debug("updateJournalStatus started.");
	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		for (int i = 0; i < journalIdList.size(); i++) {
			String journalId = journalIdList.get(i);
			map.put("journalId", journalId);
			
			ezJournalDAO.updateJournalStatus(map);
		}
		logger.debug("updateJournalStatus ended.");
	}

	@Override
	public List<JournalReplyVO> getJournalReplyList(String journalId, String userId, int tenantId, String lang, String offset) throws Exception {
		logger.debug("getJournalReplyList started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("journalId", journalId);
		map.put("lang", lang);
		map.put("offset", commonUtil.getMinuteUTC(offset));

		List<JournalReplyVO> replyList = ezJournalDAO.selectJournalReplyList(map);
		
		logger.debug("getJournalReplyList ended.");
		return replyList;
	}

	@Override
	public String saveJorunalReply(String journalId, String userId, String replyContent, int tenantId)throws Exception {
		logger.debug("saveJorunalReply started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("replyContent", replyContent);
		map.put("replyDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantId", tenantId);
		map.put("journalId", journalId);
		
		String journalWriter = ezJournalDAO.insertJournalReply(map);
		
		logger.debug("saveJorunalReply ended.");
		return journalWriter;
	}

	@Override
	public void removeJorunalReply(String journalId, String replyId, String userId, int tenantId) throws Exception {
		logger.debug("removeJorunalReply started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("replyId", replyId);
		map.put("journalId", journalId);
		
		ezJournalDAO.deleteJournalReply(map);
		
		logger.debug("removeJorunalReply ended.");
	}
	
	@Override
	public List<JournalReceiverVO> getReceiverList(String journalId, String startCount, String listCnt, int tenantId, String lang, String offset) throws Exception {
		logger.debug("getReceiverList started.");
	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("journalId", journalId);
		map.put("tenantId", tenantId);
		if (startCount != null && !startCount.equals("") && listCnt != null && !listCnt.equals("")) {
			map.put("startCount", Integer.parseInt(startCount));
			map.put("listCnt", Integer.parseInt(listCnt));
		}
		map.put("lang", lang);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		List<JournalReceiverVO> receiverList = ezJournalDAO.getReceiverList(map);
		logger.debug("getReceiverList ended.");
		return receiverList;
	}

	@Override
	public List<JournalReceiverVO> getJournalViewerList(String journalId,String startCount, String listCnt, int tenantId, String lang, String offset) throws Exception {
		logger.debug("getJournalViewerList started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("journalId", journalId);
		map.put("tenantId", tenantId);
		map.put("startCount", Integer.parseInt(startCount));
		map.put("listCnt", Integer.parseInt(listCnt));
		map.put("lang", lang);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		List<JournalReceiverVO> viewerList = ezJournalDAO.getViewerList(map);
		logger.debug("getJournalViewerList ended.");
		return viewerList;
	}

	@Override
	public String getJournalViewerCount(String journalId ,int tenantId) throws Exception {
		logger.debug("getJournalViewerCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("journalId", journalId);
		map.put("tenantId", tenantId);
		
		String viewerCount = ezJournalDAO.getViewerCount(map);
//		logger.debug("조회자몇명 ? : " + viewerCount);
		logger.debug("getJournalViewerCount ended.");
		return viewerCount;
	}

	@Override
	public String getReceiverCount(String journalId, int tenantId) throws Exception {
		logger.debug("getReceiverCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("journalId", journalId);
		map.put("tenantId", tenantId);
		
		String viewerCount = ezJournalDAO.getReceiverCount(map);
//		logger.debug("수신자몇명 ? : " + viewerCount);
		logger.debug("getReceiverCount ended.");
		return viewerCount;
	}

	@Override
	public void saveJournalViewInfo(List<String> journalIdList, String userId, int tenantId) throws Exception {
		logger.debug("saveJournalViewInfo started");
		
		logger.debug("tenantId : "+tenantId);
		logger.debug("userId : "+userId);
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		param.put("viewDate", commonUtil.getTodayUTCTime(""));
		
		for (int i = 0; i < journalIdList.size(); i++) {
			param.put("journalId", journalIdList.get(i));
			ezJournalDAO.insertViewInfo(param);
		}
			
		logger.debug("saveJournalViewInfo ended");
	}

	@Override
	public JournalAuthCheckVO checkJournalAuth(String userId, String journalId, int tenantId) throws Exception {
		logger.debug("checkJournalAuth started");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		param.put("journalId", journalId);
		
		logger.debug("checkJournalAuth ended");
		return ezJournalDAO.checkJournalAuth(param);
	}

	@Override
	public List<DeptViewVO> getCheifBoss(String userId, String lang, int tenantId) throws Exception {
		logger.debug("getCheifBoss started");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		param.put("lang", lang);
		
		List<DeptViewVO> cheifDeptList = ezJournalDAO.selectCheifBossList(param); // 부서장인 부서 리스트
		List<DeptViewVO> subCheifDeptList = new ArrayList<DeptViewVO>();
		
		for (DeptViewVO deptViewVO : cheifDeptList) {
			param.put("deptId", deptViewVO.getId());
			subCheifDeptList.addAll(ezJournalDAO.selectCheifBoss(param)); // 부서장인 부서의 하위부서 리스트
		}
		
		Set<String> tempIds = new HashSet<>();
		List<DeptViewVO> filteredList = new ArrayList<>();
		// 하위부서 리스트에 중복값이 존재할 경우 제거
		for (DeptViewVO deptViewVO : subCheifDeptList) {
			if (tempIds.add(deptViewVO.getId())) {
				filteredList.add(deptViewVO);
			}
		}

		subCheifDeptList = filteredList;
		List<DeptViewVO> toBeRemoved = new ArrayList<>();
		// 부서장인 부서 리스트와 하위부서 리스트에 중복값이 존재할 경우 제거
		for (DeptViewVO cheifDept : cheifDeptList) {
			for (DeptViewVO subCheifDept : subCheifDeptList) {
				if (cheifDept.getId().equals(subCheifDept.getId())) {
					toBeRemoved.add(cheifDept);
				}
			}
		}
		
		cheifDeptList.removeAll(toBeRemoved);
		cheifDeptList.addAll(subCheifDeptList);
		
		logger.debug("getCheifBoss ended");
		return cheifDeptList;
	}

	@Override
	public JournalEnvVO getUserJournalMailInfo(String userId, int tenantId, String lang) throws Exception {
		logger.debug("getUserJournalMailInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId",tenantId);
		map.put("lang",lang);
		JournalEnvVO result =ezJournalDAO.selectJournalMailInfo(map);
		
		logger.debug("getUserJournalMailInfo ended");
		
		return result;
	}
	
}
