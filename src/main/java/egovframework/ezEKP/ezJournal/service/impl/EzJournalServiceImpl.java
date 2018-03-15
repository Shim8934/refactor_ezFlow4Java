package egovframework.ezEKP.ezJournal.service.impl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.io.FileUtils;
import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
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
import egovframework.ezEKP.ezJournal.vo.JournalAttachVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthorVO;
import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezJournal.vo.JournalEnvVO;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournalVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.ezEKP.ezJournal.vo.ReceiverFavoriteVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.JsonUtil;


@Service("ezJournalService")
public class EzJournalServiceImpl implements EzJournalService{

	private static final Logger logger = LoggerFactory.getLogger(EzJournalServiceImpl.class);

	@Resource(name="ezJournalDAO")
	private EzJournalDAO ezJournalDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
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
	public void updateJournaltype(ArrayList<Map<String, String>> journaltypeList,String companyId, String tenantId) throws Exception {
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
	public List<JournalFormInfoVO> getFormList(String typeId, String deptId, String companyId, String companyName, String tenantId, String offset) throws Exception {
		logger.debug("getFormList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("deptId", deptId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
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
						deptVO.setDeptName(companyName);	
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
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
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
	public JournalFormInfoVO getJournalFormInfo(String formId, String companyId, String tenantId) throws Exception {
		logger.debug("getJournalFormInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("formId", formId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		JournalFormInfoVO journalFormInfoVO = ezJournalDAO.getJournalFormInfo(map);
		logger.debug("정보확인용 : " + journalFormInfoVO.getFormStatus());
		
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
	public void deleteJournalForm(String formId, String companyId, String tenantId) throws Exception {
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
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
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
	public List<ReceiverFavoriteVO> getFavoriteList(String userId, String tenantId, String offset) throws Exception {
		logger.debug("getFavoriteList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		List<ReceiverFavoriteVO> favoriteList = ezJournalDAO.getFavoriteList(map);
		logger.debug("즐겨찾기 : " + favoriteList);
		
		logger.debug("getFavoriteList ended");
		return favoriteList;
	}

	@Override
	public List<JournalAuthorVO> getFavoriteUserList(String favoriteId, String tenantId) throws Exception { 
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
	public void modifyFavorite(JSONObject jsonParam) throws Exception {
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
	public void deleteFavorite(String favoriteId, String userId, String tenantId) throws Exception {
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
	public String getRecvJournalCount(String userId, String tenantId) throws Exception {
		logger.debug("getRecvJournalCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId",tenantId);
		String result =ezJournalDAO.selectRecvCount(map);
		
		logger.debug("getRecvJournalCount ended");
		return result;
	}

	@Override
	public JournalEnvVO getUserJournalEnv(String userId, String tenantId) throws Exception {
		logger.debug("getUserJournalEnv started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId",tenantId);
		JournalEnvVO result =ezJournalDAO.selectUserEnv(map);
		
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
	public String getJournalLastFormId(String typeId, String formId, String userId, String companyId, String tenantId) throws Exception {
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

	@Override
	public JournalVO getJournal(String journalId,String userId, String viewDate, String tenantId) throws Exception {
		logger.debug("getJournal started");
		
		logger.debug("journalId : "+journalId);
		logger.debug("tenantId : "+tenantId);
		logger.debug("userId : "+userId);
		logger.debug("viewDate : "+viewDate);
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("journalId", journalId);
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		param.put("viewDate", viewDate);
		
		ezJournalDAO.insertViewInfo(param);
		logger.debug("열람정보는 들어가나요?");
		JournalVO result = ezJournalDAO.selectJournal(param);
		
		logger.debug("getJournal ended");
		
		return result;
	}

	@Override
	public List<JournalAttachVO> getAttachList(String journalId, int tenantId) throws Exception {
		logger.debug("getAttachList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("journalId", journalId);
		map.put("tenantID", tenantId);
		logger.debug("getAttachList ended");
		
		return ezJournalDAO.getAttachList(map);
	}

	@Override
	public void insertJournal(JSONObject jsonParam, String deptId, int tenantId, String realPath) throws Exception {
		logger.debug("insertJournal started");
		
		String mode = jsonParam.get("mode").toString();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("writerId", jsonParam.get("userId"));
		map.put("tenantId", tenantId);
		map.put("title", jsonParam.get("title"));
		map.put("content", jsonParam.get("content"));
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
		map.put("deptId", deptId);
		map.put("formId", jsonParam.get("formId"));
		map.put("deptShare", jsonParam.get("deptShare"));
		if (mode != null && mode.equals("temp")) {
			map.put("journalStatus", mode);
		}
		
		logger.debug("insertJournal map" + map);
		
		String journalId = ezJournalDAO.insertJournal(map) + "";
		
		String fileList = jsonParam.get("fileList").toString();
		logger.debug("fileList정보 : " + fileList.toString());
	
		// 첨부파일 저장
		Map<String, Object> attachMap = new HashMap<String, Object>();
		String pDirPath = "";
		
		if (fileList != null && !fileList.equals("")) {
			
			pDirPath = commonUtil.getUploadPath("upload_journal.ROOT", tenantId);
			pDirPath = realPath + pDirPath;
			
			logger.debug("pDirPath : " + pDirPath + ",reapPath : " + realPath);
			
			
			if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
				pDirPath = pDirPath + commonUtil.separator;
			}
			
			File file = new File(pDirPath + "uploadFile" + commonUtil.separator + journalId + "_uploadFile");
			
			if (!file.exists()) {
				file.mkdir();
			}
			
			String[] attach = fileList.split(",");
			
			attachMap.put("journalId", journalId);
			attachMap.put("tenantId", tenantId);
			
			for (int i = 0; i < attach.length; i++) {
				String[] files = attach[i].split(";");
				String filePath = files[0];
				String fileName = files[1];
				String fileSize = files[2];
				
				logger.debug("filePath : " + filePath + " | fileName : " + fileName + " | fileSize : " + fileSize);
				
				String uploadFilePath = commonUtil.separator + journalId + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + ";" + fileName;
				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + journalId + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
			
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFilePath);
				
				logger.debug("uploadFilePath : " + uploadFilePath);
				
				ezJournalDAO.insertJournalAttach(attachMap);
				
				fileMove(beforeFilePath, afterFilePath);	// Temp 폴더에서 첨부파일 이동
			}
			
		}
		
		// 수신자 정보 저장
		String receiverIDs = jsonParam.get("receiverIDs").toString();
		String receiverList = jsonParam.get("receiverList").toString();
		
		logger.debug("receiverIDs : " + receiverIDs + " | receiverList : " + receiverList);
		
		if (receiverIDs != null && !receiverIDs.equals("")) {
			
			Map<String, Object> receiverMap = new HashMap<String, Object>();
			
			String[] receiverID = receiverIDs.split(",");
//			String[] receiverName = receiverList.split(",");
			
			receiverMap.put("journalId", journalId);
			receiverMap.put("tenantId", tenantId);

			for (int i = 0; i < receiverID.length; i++) {
				receiverMap.put("receiverId", receiverID[i]);
				
				ezJournalDAO.insertReceiver(receiverMap);
			}
		}
		
		logger.debug("insertJournal ended");
	}
	
	private void fileMove(String beforeFilePath, String afterFilePath) throws Exception {
		logger.debug("fileMove started.");
		logger.debug("beforeFilePath = " + beforeFilePath + " || afterFilePath = " + afterFilePath);
		
		File srcFile = new File(beforeFilePath);
		File destFile = new File(afterFilePath);
		
		try {
			boolean rename = srcFile.renameTo(destFile);
			if (!rename) {
				FileUtils.copyFile(srcFile, destFile);
				if (!srcFile.delete()) {
					FileUtils.deleteQuietly(destFile);
					throw new IOException("Failed to delete original file '" + srcFile +
							"' after copy to '" + destFile + "'");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("fileMove ended.");
	}

	@Override
	public JournalFormInfoVO getJournalDivideThisNext(List<String> journalIdList,String formId, String companyId, int tenantId) throws Exception {
		logger.debug("getJournalDivideThisNext started.");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("formId", formId);
		param.put("companyId", companyId);
		
		JournalFormInfoVO form = ezJournalDAO.getJournalFormInfo(param);
		String formContent = form.getFormContent();
		Document formDoc = Jsoup.parseBodyFragment(formContent);
		Element formBody = formDoc.body();
		Element formThis = formBody.getElementById("this");
		Element formNext = formBody.getElementById("next");
		
		for (int i = 0; i < journalIdList.size(); i++) {
			param.put("journalId", journalIdList.get(i));
			
			JournalVO journal = ezJournalDAO.selectJournal(param);
			
			String journalContent = journal.getJournalContent();
			Document journalDoc = Jsoup.parseBodyFragment(journalContent);
			Element journalBody = journalDoc.body();
			
			Element thisElem = journalBody.getElementById("this");
			String thisContent = thisElem.html();
			Element nextElem = journalBody.getElementById("this");
			String nextContent = nextElem.html();
			
			String title = "<p>"+journal.getJournalTitle()+"</p>";
			
			formThis.append(title);
			formNext.append(title);
			
			formThis.append(thisContent);
			formNext.append(nextContent);
		}
		
		form.setFormContent(formDoc.toString());
		
		logger.debug("getJournalDivideThisNext ended.");
		return form;
	}
	
	@Override
	public void updateJournal(String journalId, JSONObject jsonParam, int tenantId, String realPath) throws Exception {

		String mode = jsonParam.get("mode").toString();
		String isTemp = jsonParam.get("isTemp").toString().trim();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("title", jsonParam.get("title"));
		map.put("content", jsonParam.get("content"));
		map.put("deptShare", jsonParam.get("deptShare"));
		map.put("journalId", journalId);
		map.put("tenantId", tenantId);
		
		if (isTemp != null && !isTemp.equals("Y")) {
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
			logger.debug("updateJournal fileList : " + fileList);
			
			String[] attach = fileList.split(",");
			
			attachMap.put("journalId", journalId);
			attachMap.put("tenantId", tenantId);
			
			for (int i = 0; i < attach.length; i++) {
				String[] files = attach[i].split(";");
				String filePath = files[0];
				String fileName = files[1];
				String fileSize = files[2];
				
				logger.debug("filePath : " + filePath + " | fileName : " + fileName + " | fileSize : " + fileSize);
				
				String uploadFilePath = commonUtil.separator + journalId + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
				
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFilePath);
				
				logger.debug("uploadFilePath : " + uploadFilePath);
				
				ezJournalDAO.insertJournalAttach(attachMap);
				
				// mode 가 수정일때?? Temp폴더에서 첨부파일 이동
				String pDirPath = "";
				pDirPath = commonUtil.getUploadPath("upload_journal.ROOT", tenantId);
				pDirPath = realPath + pDirPath;
						
				if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
					pDirPath = pDirPath + commonUtil.separator;
				}
						
				File file = new File(pDirPath + "uploadFile" + commonUtil.separator + journalId + "_uploadFile");
						
				if (!file.exists()) {
					file.mkdir();
				}
				
				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + ";" + fileName;
				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + journalId + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
				
				fileMove(beforeFilePath, afterFilePath);	// Temp 폴더에서 첨부파일 이동
					
			}
		}
		
		// 수신자 삭제 후 저장
		ezJournalDAO.deleteReceiver(map);
		
		String receiverIDs = jsonParam.get("receiverIDs").toString();
		logger.debug("receiverIDs : " + receiverIDs);

		if (receiverIDs != null && !receiverIDs.equals("")) {
			
			Map<String, Object> receiverMap = new HashMap<String, Object>();
			
			String[] receiverID = receiverIDs.split(",");
			
			receiverMap.put("journalId", journalId);
			receiverMap.put("tenantId", tenantId);
			
			for (int i = 0; i < receiverID.length; i++) {
				receiverMap.put("receiverId", receiverID[i]);
				ezJournalDAO.insertReceiver(receiverMap);
			}
		}
	}

	@Override
	public void deleteJournalList(List<String> journalIdList, String pDirPath, int tenantId) throws Exception {

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
		
	}
	
	private void deleteDirectory (String journalId, String pDirpath, int tenantID) throws Exception {
		logger.debug("deleteDirectory ended.");
		
		File directoryFile = new File(pDirpath + "uploadFile" + commonUtil.separator + journalId + "_uploadFile");
		File[] deleteFileList = directoryFile.listFiles();

		if (directoryFile.exists()) {
			// 디렉토리 하위의 파일을 모두 삭제 한뒤 디렉토리 삭제
			if (deleteFileList.length >0) {
				for (int i=0; i<deleteFileList.length; i++) {
					if (deleteFileList[i].isFile()) {
						deleteFileList[i].delete();
					} else {
						deleteDirectory(journalId, pDirpath, tenantID);
					}
				}
			}
			directoryFile.delete();
		}

		logger.debug("deleteDirectory ended.");
	}
}
