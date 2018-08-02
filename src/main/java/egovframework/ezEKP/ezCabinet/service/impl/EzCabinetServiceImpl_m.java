package egovframework.ezEKP.ezCabinet.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibatis.sqlmap.engine.type.SimpleDateFormatter;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetAdminDAO;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetDAO;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService_m;
import egovframework.ezEKP.ezCabinet.vo.CabinetAttachFileVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezApprovalG.*;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service
public class EzCabinetServiceImpl_m implements EzCabinetService_m{
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetServiceImpl_m.class);
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzCabinetDAO")
	private EzCabinetDAO ezCabinetDAO;
	
	@Resource(name = "EzCabinetAdminDAO")
	private EzCabinetAdminDAO ezCabinetAdminDAO;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Override
	public JSONObject saveApprovalItem(String realPath, int cabinetId, String approvalContent, String mode, String doctitle, String lstAttachLink, String otherAttachLk, Locale locale, LoginVO userInfo)throws Exception {
		JSONObject result          = new JSONObject();
		String userId              = userInfo.getId();
		int tenantId               = userInfo.getTenantId();
		String companyId           = userInfo.getCompanyID();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(new Date()), userInfo.getOffset(), true);
		JSONParser jp              = new JSONParser();
		int itemCabinetId          = -1;
		Map<String,Object> map     = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Save Item
		int itemId     = ezCabinetDAO.getMaxItem(map) + 1;
		int moduleType = 2; //Approval module
		
		if(mode.equals("0")){
			map.put("userId",   userId);
			map.put("tenantId", tenantId);
			map.put("type",     moduleType);
			
			CabinetVO cabinet = ezCabinetDAO.getRootCabinetByType(map);
			itemCabinetId     = cabinet.getCabinetId();
		}
		else{
			itemCabinetId = cabinetId;
		}
		
		CabinetItemVO itemVO = new CabinetItemVO();
		itemVO.setCabinetId(itemCabinetId);
		itemVO.setItemId(itemId);
		itemVO.setItemType(moduleType);
		itemVO.setTitle(doctitle);
		itemVO.setCreatorId(userId);
		itemVO.setCreatorName1(userInfo.getDisplayName1());
		itemVO.setCreatorName2(userInfo.getDisplayName2());
		itemVO.setDepartmentId(userInfo.getDeptID());
		itemVO.setDepartmentName1(userInfo.getDeptName1());
		itemVO.setDepartmentName2(userInfo.getDeptName2());
		itemVO.setConentPath(approvalContent);
		itemVO.setCreatedDate(timeUTC);
		itemVO.setUpdatedDate(timeUTC);
		itemVO.setUseStatus(1);
		itemVO.setUpdateId(userId);
		itemVO.setDeleterId(null);
		itemVO.setCompanyId(companyId);
		itemVO.setTenantId(tenantId);
		
		saveItem(itemVO);
		
		//Save Approval attach files
		
		String cabinetPath = getCabinetDirPath(tenantId);
		File file          = new File(realPath + cabinetPath);
		
		if(!file.exists()){
			file.mkdir();
		}
		
		if(!lstAttachLink.equals("")){
			JSONArray lstAttachLinkList = (JSONArray) jp.parse(lstAttachLink);
			int totalCnt                = lstAttachLinkList.size();
			int lstAttachLinkId         = ezCabinetDAO.getMaxAttachId(map) + 1;
			
			for(int i = 0; i < totalCnt; i++, lstAttachLinkId++){
				JSONObject lstAttachLinkInf = (JSONObject) lstAttachLinkList.get(i);
				saveApprovalFiles(lstAttachLinkInf, lstAttachLinkId, itemId, realPath, cabinetPath, locale, companyId, userId, tenantId);
			}
		}
		
		if(!otherAttachLk.equals("")){
			JSONArray otherAttachList   = (JSONArray) jp.parse(otherAttachLk);
			int totalCnt                = otherAttachList.size();
			int otherAttachId           = ezCabinetDAO.getMaxAttachId(map) + 1;
			
			for(int i = 0; i < totalCnt; i++, otherAttachId++){
				JSONObject otherAttachLinkInf = (JSONObject) otherAttachList.get(i);
				saveApprovalOtherFiles(otherAttachLinkInf, otherAttachId, itemId, realPath, cabinetPath, locale, companyId, userId, tenantId);
			}
		}
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	private void saveApprovalFiles(JSONObject lstAttachLinkInf, int lstAttachLinkId, int itemId, String realPath, String cabinetPath, Locale locale, String companyId, String userId, int tenantId) {
		String fileName = lstAttachLinkInf.get("fileName").toString();
		String filePath = lstAttachLinkInf.get("filePath").toString();
		
		logger.debug("fileName: " + fileName + " || filePath: " + filePath);
		
		File file = new File(filePath + fileName);
		
		try{
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
	
	private void saveApprovalOtherFiles(JSONObject otherAttachLinkInf, int otherAttachId, int itemId, String realPath, String cabinetPath, Locale locale, String companyId, String userId, int tenantId){
		String otherAttachLinkInfList = otherAttachLinkInf.toString();
		logger.debug("otherAttachLinkInf : " + otherAttachLinkInf);
		
		File file     = new File(otherAttachLinkInfList);
		long fileSize = file.length();
		
		//CabinetAttachFileVO attachFile = new CabinetAttachFileVO(otherAttachId, itemId, realPath, name, size, companyId, tenantId);
	}

	private synchronized void saveItem(CabinetItemVO itemVO) {
		ezCabinetDAO.saveItem(itemVO);
	}

	@Override
	public void saveItem(int cabinetId, JSONArray attacheFiles, JSONArray relatedFiles, String doctitle, String realPath, LoginVO userInfo) throws Exception {
		String companyId           = userInfo.getCompanyID();
		String userId              = userInfo.getId();
		int tenantId               = userInfo.getTenantId();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		Map<String,Object> map     = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Save Approval item
		int itemId           = ezCabinetDAO.getMaxItem(map) + 1;
		CabinetItemVO itemVO = new CabinetItemVO();
		itemVO.setCabinetId(cabinetId);
		itemVO.setItemId(itemId);
		itemVO.setItemType(0);
		itemVO.setTitle(doctitle);
		itemVO.setCreatorId(userId);
		itemVO.setCreatorName1(userInfo.getDisplayName1());
		itemVO.setCreatorName2(userInfo.getDisplayName2());
		itemVO.setDepartmentId(userInfo.getDeptID());
		itemVO.setDepartmentName1(userInfo.getDeptName1());
		itemVO.setDepartmentName2(userInfo.getDeptName2());
		itemVO.setConentPath(null);
		itemVO.setCreatedDate(timeUTC);
		itemVO.setUpdatedDate(timeUTC);
		itemVO.setUseStatus(1);
		itemVO.setUpdateId(userId);
		itemVO.setDeleterId(null);
		itemVO.setCompanyId(companyId);
		itemVO.setTenantId(tenantId);
		
        saveItem(itemVO);
		
		int attachSize  = attacheFiles.size();
		int relatedSize = relatedFiles.size();
	}
	
	private String getCabinetDirPath(int tenantId) {
		return commonUtil.separator + "fileroot" + commonUtil.separator + tenantId + commonUtil.separator + "cabinet" + commonUtil.separator;
	}
	
	
}
