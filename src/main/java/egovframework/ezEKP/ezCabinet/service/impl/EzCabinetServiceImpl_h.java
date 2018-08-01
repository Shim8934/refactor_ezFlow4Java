package egovframework.ezEKP.ezCabinet.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.stream.Collectors;
import javax.annotation.Resource;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetDAO;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetDAO_h;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService_h;
import egovframework.ezEKP.ezCabinet.vo.CabinetAttachFileVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetColumnVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetRelationItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetRelationVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service
public class EzCabinetServiceImpl_h implements EzCabinetService_h{
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetServiceImpl_h.class);

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzCabinetDAO")
	private EzCabinetDAO ezCabinetDAO;
	
	@Resource(name = "EzCabinetDAO_h")
	private EzCabinetDAO_h ezCabinetDAO_h;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzCabinetService cabinetService;
	
	@Override
	public List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int startPoint, int listCount, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("startPoint", startPoint);
		map.put("listCount",  listCount);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO_h.getDeptMemberList(map);
	}
	
	@Override
	public List<SimpleUserVO> getShareUserList(String cabinetId, String userId, String sqlQuery, String searchValue, String primary, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cabinetId",   cabinetId);
		map.put("userId",      userId);
		map.put("sqlQuery",    sqlQuery);
		map.put("searchValue", searchValue);
		map.put("primary",     primary);
		map.put("tenantId",    tenantId);
		
		return ezCabinetDAO_h.getShareUserList(map);
	}
	
	@Override
	public int getTotalDeptMembers(String deptId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptId",   deptId);
		map.put("tenantId", tenantId);
		
		return ezCabinetDAO_h.getTotalDeptMembers(map);
	}

	@Override
	public List<SimpleUserVO> getSearchMemberList(String primary, int startPoint, int listCount, String srchOption, String srchValue, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("startPoint", startPoint);
		map.put("listCount",  listCount);
		map.put("srchOption", srchOption);
		map.put("srchValue",  srchValue);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO_h.getSearchMemberList(map);
	}

	@Override
	public int getTotalSearchMembers(String sqlQuery, String srchValue, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("srchOption", sqlQuery);
		map.put("srchValue",  srchValue);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO_h.getTotalSearchMembers(map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public synchronized JSONObject saveShareUserList(JSONArray listUsers, String cabinetId, LoginVO userInfo) throws Exception {
		JSONObject result = new JSONObject();
		String userId     = userInfo.getId();
		int tenantId      = userInfo.getTenantId();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cabinetId",   cabinetId);
		map.put("userId",      userId);
		map.put("tenantId",    tenantId);
		
		//Delete all current shared users
		ezCabinetDAO_h.updateShareList(map);
		
		//Add new shared users
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		String companyId           = userInfo.getCompanyID();
		String primary             = userInfo.getPrimary();
		
		map.put("userName1", userInfo.getDisplayName1());
		map.put("userName2", userInfo.getDisplayName2());
		map.put("company",   companyId);
		map.put("shareDate", timeUTC);
		
		int shareId = ezCabinetDAO_h.getMaximumShareId(map) + 1;
		
		for (int i = 0; i < listUsers.size(); i++, shareId++) {
			JSONObject sharedInfo = (JSONObject)listUsers.get(i);
			String sharedId  = (String)sharedInfo.get("userId");
			String userType  = (String)sharedInfo.get("userType");
			String sharePerm = (String)sharedInfo.get("permis");
			String subPerm   = (String)sharedInfo.get("subPerm");
			
			switch(userType) {
				case "user": 
					LoginVO login = new LoginVO();
					login.setId(sharedId);
					login.setDn("NOPASSWORD");
					login.setTenantId(tenantId);
					LoginVO user = loginService.selectUser(login);
					
					if (user == null) {
						result.put("status", "error");
						result.put("code", 4);
						return result;
					}
					
					map.put("shareType", 2);
					break;
				case "dept":
					OrganDeptVO dept = ezOrganService.getDeptInfo(companyId, primary, tenantId);
					if (dept == null) {
						result.put("status", "error");
						result.put("code", 4);
						return result;
					}
					
					map.put("shareType", 1);
					break;
				case "comp": 
					OrganDeptVO company = ezOrganService.getDeptInfo(companyId, primary, tenantId);
					if (company == null) {
						result.put("status", "error");
						result.put("code", 4);
						return result;
					}
					
					map.put("shareType", 0);
					break;
				default:
						result.put("status", "error");
						result.put("code", 4);
						return result;
			}
			
			map.put("sharedId",        sharedId);
			map.put("permission",      Integer.parseInt(sharePerm));
			map.put("childPermission", Integer.parseInt(subPerm));
			map.put("shareId",         shareId);
			ezCabinetDAO_h.saveShareUserList(map);
		}
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	@Override
	public CabinetItemVO getFileDetail(String itemId, String primary, String offset,int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemId",   itemId);
		map.put("offset",   offset);
		map.put("primary",  primary);
		map.put("tenantId", tenantId);
		
		return ezCabinetDAO_h.getFileDetail(map);
	}

	@Override
	public List<CabinetAttachFileVO> getAttachFileList(String itemId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemId",   itemId);
		map.put("tenantId", tenantId);
		
		return ezCabinetDAO.getAllAttachFilesOfItem(map);
	}

	@Override
	public List<CabinetRelationItemVO> getRelatedFileList(String itemId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemId",   itemId);
		map.put("tenantId", tenantId);
		
		return ezCabinetDAO_h.getRelatedFileList(map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public synchronized JSONObject modifyItem(int itemId, JSONArray attacheFiles, JSONArray relatedFiles, String title, String summary, String realPath, LoginVO userInfo) throws Exception {
		JSONObject result          = new JSONObject();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		Map<String,Object> map     = new HashMap<String, Object>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("itemId",   itemId);
		
		CabinetItemVO itemVO = ezCabinetDAO.getItemById(map);
		
		if (itemVO.getItemType() != 0) {
			logger.debug("Invalid item type!");
			result.put("status", "error");
			result.put("code", 4);
			return result;
		}
		
		itemVO.setTitle(title);
		itemVO.setSummary(summary);
		itemVO.setUpdatedDate(timeUTC);
		itemVO.setUpdateId(userInfo.getId());
		
		ezCabinetDAO_h.modifyItem(itemVO);
		
		//Modify attach files
		modifyAttachList(itemId, attacheFiles, realPath,userInfo);
		
		//Modify related files
		modifyRelatedList(itemId, relatedFiles, userInfo);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject saveBoarditem(String realPath, String mode, int cabinetId, String title, String writer, String attach, String content, String dateTime, Locale locale, LoginVO userInfo) throws Exception {
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
		
		//Save item
		int itemId     = ezCabinetDAO.getMaxItem(map) + 1;
		int moduleType = 3; //board module
		
		if (mode.equals(0)) {
			map.put("userId",   userId);
			map.put("tenantId", tenantId);
			map.put("type",     moduleType);
			
			CabinetVO cabinet = ezCabinetDAO.getRootCabinetByType(map);
			itemCabinetId     = cabinet.getCabinetId();
		}
		else { 
			itemCabinetId = cabinetId;
		}
		
		CabinetItemVO itemVO = new CabinetItemVO();
		itemVO.setCabinetId(itemCabinetId);
		itemVO.setItemId(itemId);
		itemVO.setItemType(moduleType);
		itemVO.setTitle(title);
		itemVO.setCreatorId(userId);
		itemVO.setCreatorName1(userInfo.getDisplayName1());
		itemVO.setCreatorName2(userInfo.getDisplayName2());
		itemVO.setDepartmentId(userInfo.getDeptID());
		itemVO.setDepartmentName1(userInfo.getDeptName1());
		itemVO.setDepartmentName2(userInfo.getDeptName2());
		itemVO.setConentPath(content);
		itemVO.setCreatedDate(timeUTC);
		itemVO.setUpdatedDate(timeUTC);
		itemVO.setUseStatus(1);
		itemVO.setUpdateId(userId);
		itemVO.setDeleterId(null);
		itemVO.setCompanyId(companyId);
		itemVO.setTenantId(tenantId);
		
		saveItem(itemVO);
		
		//Save board columns information
		List<CabinetColumnVO> listColm = new ArrayList<>();
		String writerColName1          = egovMessageSource.getMessage("ezBoard.t223", new Locale(config.getProperty("config.cabinetPrimary")));
		String writerColName2          = egovMessageSource.getMessage("ezBoard.t223", new Locale(config.getProperty("config.cabinetSecondary")));
		CabinetColumnVO writerColumn   = new CabinetColumnVO("writer", itemId, writerColName1, writerColName2, writer, companyId, tenantId);
		listColm.add(writerColumn);
		
		String dateColName1            = egovMessageSource.getMessage("ezBoard.t224", new Locale(config.getProperty("config.cabinetPrimary")));
		String dateColName2            = egovMessageSource.getMessage("ezBoard.t224", new Locale(config.getProperty("config.cabinetSecondary")));
		CabinetColumnVO dateTimeColumn = new CabinetColumnVO("boardTime", itemId, dateColName1, dateColName2, dateTime, companyId, tenantId);
		listColm.add(dateTimeColumn);
		
		saveAllColumns(listColm);
		
		//Save attach files
		String cabinetPath = getCabinetDirPath(tenantId);
		File file          = new File(realPath + cabinetPath);
		
		if (!file.exists()) {
			file.mkdir();
		}
		
		if (!attach.equals("")) {
			JSONArray attachList = (JSONArray) jp.parse(attach);
			int totalCnt         = attachList.size();
			int attachId         = ezCabinetDAO.getMaxAttachId(map) + 1;
			for (int i = 0; i < totalCnt; i++, attachId++) {
				JSONObject attachInf = (JSONObject) attachList.get(i);
				saveBoardAttachFiles(attachInf, attachId, itemId, realPath, cabinetPath, locale, companyId, userId, tenantId);
			}
		}
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	private void saveBoardAttachFiles(JSONObject attachInf, int attachId, int itemId, String realPath, String cabinetPath, Locale locale, String companyId, String userId, int tenantId) {
		String fileName      = attachInf.get("fileName").toString();
		String filePath      = attachInf.get("filePath").toString();
		String newName       = UUID.randomUUID().toString();
		String pDirPath      = realPath + cabinetPath;
		String newFilePath   = pDirPath + File.separator + newName;
		
		logger.debug("file path: " + filePath + " || file name : " + fileName);
		
		File file = new File(realPath + filePath);
		
		try {
			if(!file.exists()) {
				logger.error("file not found.");
			}
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		
		
	}
	
	public synchronized void modifyRelatedList(int itemId, JSONArray relatedFiles, LoginVO userInfo) throws Exception {
		String companyId       = userInfo.getCompanyID();
		int tenantId           = userInfo.getTenantId();
		int relatedSize        = relatedFiles.size();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("itemId",   itemId);
		
		//Modify related files
		List<CabinetRelationItemVO> relatedFileList = ezCabinetDAO_h.getRelatedFileList(map);
		List<Integer> relatedId                     = relatedFileList.stream().map(CabinetRelationItemVO::getRelatedItemId).collect(Collectors.toList());
		
		if (relatedSize > 0) {
			int relationId = ezCabinetDAO.getMaxRelationId(map) + 1;
			
			for (int i = 0; i < relatedSize; i++, relationId++) {
				JSONObject relationObj = (JSONObject)relatedFiles.get(i);
				int relatedItemId = Integer.parseInt(relationObj.get("itemId").toString());
				
				if (relatedId.contains(relatedItemId)) {
					relatedId.removeIf(id -> id.intValue() == relatedItemId);
					continue;
				}
				
				CabinetRelationVO relationFile = new CabinetRelationVO(relationId, itemId, relatedItemId, companyId, tenantId);
				ezCabinetDAO.saveRelationFile(relationFile);
			}
		}
		
		//delete related files
		if(relatedId.size() > 0) {
			map.put("relatedIds", relatedId);
			ezCabinetDAO.deleteRelatedFiles(map);
		}
	}
	
	public synchronized void modifyAttachList(int itemId, JSONArray attacheFiles, String realPath, LoginVO userInfo) throws Exception {
		String companyId       = userInfo.getCompanyID();
		int tenantId           = userInfo.getTenantId();
		int attachSize         = attacheFiles.size();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("itemId",   itemId);
		
		List<CabinetAttachFileVO> attachFileList = ezCabinetDAO.getAllAttachFilesOfItem(map);
		List<String> attachPath                  = attachFileList.stream().map(CabinetAttachFileVO::getFilePath).collect(Collectors.toList());
		
		if (attachSize > 0) {
			int attachId = ezCabinetDAO.getMaxAttachId(map) + 1;
			for (int i = 0; i < attachSize; i++, attachId++) {
				JSONObject fileObj = (JSONObject)attacheFiles.get(i);
				String filePath    = (String)fileObj.get("path");
				
				if (attachPath.contains(filePath)) {
					attachPath.remove(filePath);
					continue;
				}
				
				String fileName    = (String)fileObj.get("name");
				
				File file          = new File(realPath + filePath);
				long fileSize      = file.length();
				
				CabinetAttachFileVO attachFile = new CabinetAttachFileVO(attachId, itemId, filePath, fileName, fileSize, companyId, tenantId);
				ezCabinetDAO.saveAttachFile(attachFile);
			}
		}
		
		//delete attach files
		if (attachPath.size() > 0) {
			List<Integer> attachIds = attachFileList.stream().filter(i -> attachPath.contains(i.getFilePath())).map(CabinetAttachFileVO::getAttachId).collect(Collectors.toList());
			map.put("attachIds", attachIds);
			ezCabinetDAO.deleteAttachFiles(map);
			
			for (String filePath : attachPath) {
				cabinetService.deleteAttachFile(filePath, realPath, tenantId);
			}
		}
	}
	
	private synchronized void saveItem(CabinetItemVO itemVO) {
		ezCabinetDAO.saveItem(itemVO);
	}
	
	private synchronized void saveAllColumns(List<CabinetColumnVO> listColm) {
		for (CabinetColumnVO column : listColm) {
			ezCabinetDAO.saveRelatedColumn(column);
		}
	}
	
	private String getCabinetDirPath(int tenantId) {
		return commonUtil.separator + "fileroot" + commonUtil.separator + tenantId + commonUtil.separator + "cabinet" + commonUtil.separator;
	}
}
