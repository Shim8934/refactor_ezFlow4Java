package egovframework.ezEKP.ezCabinet.service.impl;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.stream.Collectors;
import javax.annotation.Resource;
import org.apache.commons.io.FileUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
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
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService_h;
import egovframework.ezEKP.ezCabinet.vo.CabinetAttachFileVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetColumnVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetRelationItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetRelationVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetShareVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetVO;
import egovframework.ezEKP.ezCabinet.vo.UserCapacityVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service
public class EzCabinetServiceImpl_h extends EgovAbstractServiceImpl implements EzCabinetService_h {
	
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
	
	@Autowired
	private EzCabinetAdminService cabinetAdminService;
	
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
	public List<SimpleUserVO> getShareUserList(String cabinetId, String userId, String sqlQuery, String searchValue, String primary, int tenantId, String searchFlag) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cabinetId",   cabinetId);
		map.put("userId",      userId);
		map.put("sqlQuery",    sqlQuery.toUpperCase());
		map.put("searchValue", searchValue);
		map.put("primary",     primary);
		map.put("tenantId",    tenantId);
		map.put("searchFlag",  searchFlag); // 공유자 검색 Flag
		
		return ezCabinetDAO_h.getShareUserList(map);
	}
	
	@Override
	public List<SimpleUserVO> getAncestorShareUserList(String cabinetId, String userId, String primary, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cabinetId", cabinetId);
		map.put("tenantId",  tenantId);
		CabinetVO cabinet     = ezCabinetDAO.getCabinetById(map);
		String cabinetPath    = cabinet.getCabinetPath();
		cabinetPath           = cabinetPath.substring(1, cabinetPath.length() - 1);
		List<Integer> nodeIds = Arrays.asList(cabinetPath.split("\\|")).stream().map(Integer::parseInt).collect(Collectors.toList());
		nodeIds.remove(nodeIds.size() - 1);
		map.put("userId",    userId);
		map.put("primary",   primary);
		map.put("listNodes", nodeIds);
		
		return ezCabinetDAO_h.getAncestorShareUserList(map);
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
		map.put("srchOption", srchOption.toUpperCase());
		map.put("srchValue",  srchValue);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO_h.getSearchMemberList(map);
	}
	
	@Override
	public int getTotalSearchMembers(String sqlQuery, String srchValue, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("srchOption", sqlQuery.toUpperCase());
		map.put("srchValue",  srchValue);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO_h.getTotalSearchMembers(map);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public synchronized JSONObject saveShareUserList(JSONArray listUsers, String cabinetId, LoginVO userInfo) throws Exception {
		JSONObject result       = new JSONObject();
		String userId           = userInfo.getId();
		int tenantId            = userInfo.getTenantId();
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
			String searchFlag = (String) sharedInfo.get("searchFlag"); // 공유자 검색 Flag
			
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
			map.put("searchFlag",      searchFlag);
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
	@Override
	public JSONObject saveBoardItem(String realPath, String mode, int cabinetId, String title, String summary, String boardTitle,String writer, String attach, String content, String dateTime, Locale locale, LoginVO userInfo) throws Exception {
		JSONObject result          = new JSONObject();
		int tenantId               = userInfo.getTenantId();
		String companyId           = userInfo.getCompanyID();
		JSONParser jp              = new JSONParser();
		Map<String,Object> map     = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		//Save attach files
		if (!attach.equals("")) {
			JSONArray attachList = (JSONArray) jp.parse(attach);
			result               = saveListAttachFiles(attachList, itemId, realPath, "", "", locale, userInfo);
			if (!result.get("status").equals("ok")) {
				return result;
			}
		}
		
		//Save item
		int moduleType = 3; //board module
		addRelatedItem(itemId, moduleType, cabinetId, title, summary, content, mode, userInfo);
		
		//Save board columns information
		List<CabinetColumnVO> listColm = new ArrayList<>();
		listColm.add(createNewRelatedColumn("boardTitle" , itemId, "ezCabinet.t62", boardTitle, companyId, tenantId));
		listColm.add(createNewRelatedColumn("boardWriter", itemId, "ezBoard.t223" , writer    , companyId, tenantId));
		listColm.add(createNewRelatedColumn("boardTime"  , itemId, "ezBoard.t224" , dateTime  , companyId, tenantId));
		listColm.add(createNewRelatedColumn("boardType"  , itemId, "ezBoard.t224" , "normal"  , companyId, tenantId));
		
		saveAllColumns(listColm);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
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
				
				String fileName = (String)fileObj.get("name");
				File file       = new File(realPath + commonUtil.detectPathTraversal(filePath));
				long fileSize   = file.length();
				
				CabinetAttachFileVO attachFile = new CabinetAttachFileVO(attachId, itemId, filePath, fileName, fileSize, "", companyId, tenantId);
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
		return commonUtil.getUploadPath("upload_cabinet.ROOT", tenantId) + commonUtil.separator;
	}
	
	private synchronized void saveAttachFile(CabinetAttachFileVO attachFile) {
		ezCabinetDAO.saveAttachFile(attachFile);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveOptionItem(String realPath, String mode, int cabinetId, String title, String summary, String optionTitle, String writer, String date, String content, String attach, Locale locale, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		JSONParser jp          = new JSONParser();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		//Save attach files
		if (!attach.equals("")) {
			JSONArray attachList  = (JSONArray) jp.parse(attach);
			result                = saveListAttachFiles(attachList, itemId, realPath, "upload_circular.ROOT", "uploadFile", locale, userInfo);
			if (!result.get("status").equals("ok")) {
				return result;
			}
		}
		
		//Add option item
		int moduleType = 6; //option module
		addRelatedItem(itemId, moduleType, cabinetId, title, summary, content, mode, userInfo);
		
		//Save option columns information
		List<CabinetColumnVO> listColm = new ArrayList<>();
		listColm.add(createNewRelatedColumn("optionTitle" , itemId, "ezCabinet.t62"  , optionTitle, companyId, tenantId));
		listColm.add(createNewRelatedColumn("optionWriter", itemId, "ezCircular.t122", writer     , companyId, tenantId));
		listColm.add(createNewRelatedColumn("optionTime"  , itemId, "ezBoard.t5007"  , date       , companyId, tenantId));
		
		saveAllColumns(listColm);
		result.put("status", "ok");
		result.put("code", 0);
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject saveListAttachFiles(JSONArray attachList, int itemId, String realPath, String modulePath, String uploadPath, Locale locale, LoginVO userInfo) throws Exception {
		JSONObject result                  = new JSONObject();
		int tenantId                       = userInfo.getTenantId();
		UserCapacityVO capacity            = cabinetAdminService.getUserCapacity(userInfo.getId(), userInfo.getCompanyID(), userInfo.getPrimary(), tenantId);
		String cabinetPath                 = getCabinetDirPath(tenantId);
		long remainStorage                 = -1;
		long totalAttachSize               = 0;
		List<CabinetAttachFileVO> fileList = new ArrayList<>();
		Map<String,Object> map             = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		int totalCnt                       = attachList.size();
		int attachId                       = ezCabinetDAO.getMaxAttachId(map) + 1;
		File file                          = new File(realPath + commonUtil.detectPathTraversal(cabinetPath));
		
		if (!file.exists() && !file.mkdirs()) {
			throw new IOException();
		}
		
		for (int i = 0; i < totalCnt; i++, attachId++) {
			JSONObject attachInf = (JSONObject) attachList.get(i);
			result = copyRelatedItemAttachFiles(attachInf, attachId, itemId, realPath, cabinetPath, locale, userInfo, modulePath, uploadPath, fileList);
			if (!result.get("status").equals("ok")) {
				return result;
			}
		}
		
		if (capacity.getCapacityType() == 1) {
			long totalUsed  = Long.parseLong(capacity.getTotalUsed());
			long totalCap   = capacity.getTotalCapacity() * 1048576;
			remainStorage   = totalCap - totalUsed;
			totalAttachSize = fileList.stream().mapToLong(CabinetAttachFileVO::getFileSize).sum();
			
			if (totalAttachSize > remainStorage) {
				//Delete temp files
				try {
					for (CabinetAttachFileVO fileAttach : fileList) {
						File tempFile = new File(realPath + commonUtil.detectPathTraversal(fileAttach.getFilePath()));
						if (!tempFile.delete()) {
							throw new IOException();
						}
					}
					
					logger.debug("Not enough storage to upload these files!");
					result.put("status", "error");
					result.put("code", 4);
					return result;
				}
				catch (Exception e) {
					logger.error(e.getMessage(), e);
					logger.debug("Not enough storage to upload these files!");
					result.put("status", "error");
					result.put("code", 4);
					return result;
				}
			}
		}
		
		//Save information to database
		for (CabinetAttachFileVO fileAttach : fileList) {
			saveAttachFile(fileAttach);
		}
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject copyRelatedItemAttachFiles(JSONObject attachInf, int attachId, int itemId, String realPath, String cabinetPath, Locale locale, LoginVO userInfo, String modulePath, String uploadPath, List<CabinetAttachFileVO> attachFileList) throws Exception {
		JSONObject result = new JSONObject();
		String companyId  = userInfo.getCompanyID();
		int tenantId      = userInfo.getTenantId();
		String fileName   = attachInf.get("fileName").toString();
		String folderPath = "";
		
		if (!modulePath.equals("")) {
			folderPath = commonUtil.getUploadPath(modulePath, tenantId) + commonUtil.separator + uploadPath;
		}
		
		String fileDesc      = attachInf.get("fileDesc") != null ? attachInf.get("fileDesc").toString() : "";
		String filePath      = folderPath + attachInf.get("filePath").toString();
		int dotPos           = fileName.lastIndexOf(".");
		String extend        = dotPos == -1 ? ".none" : fileName.substring(dotPos + 1);
		String newName       = UUID.randomUUID().toString() + "." + extend;
		String pDirPath      = realPath + cabinetPath;
		String newFilePath   = pDirPath + File.separator + commonUtil.detectPathTraversal(newName);
		String pfilePath     = cabinetPath + commonUtil.detectPathTraversal(newName);
		
		if (modulePath.equals("upload_circular.ROOT")) {
			filePath = filePath + fileName;
		}
		
		logger.debug("file path: " + filePath + " || file name : " + fileName);
		
		File file = new File(realPath + commonUtil.detectPathTraversal(filePath));
		
		if(!file.exists()) {
			logger.error("File not found.");
			//throw new FileNotFoundException();
			result.put("status", "error");
			result.put("code", 5);
			return result;
		}
		else {
			File newAttachFile = new File(newFilePath);
			try {
				FileUtils.copyFile(file, newAttachFile);
			}
			catch (Exception e) {
				//throw e;
				result.put("status", "error");
				result.put("code", 2);
				return result;
			}
		}
		
		File readfile = new File(newFilePath);
		long fileSize = readfile.length();
		
		CabinetAttachFileVO attachFile = new CabinetAttachFileVO(attachId, itemId, pfilePath, fileName, fileSize, fileDesc, companyId, tenantId);
		attachFileList.add(attachFile);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	public synchronized void addRelatedItem(int itemId, int moduleType, int cabinetId, String title, String summary, String content, String mode, LoginVO userInfo) throws Exception {
		String userId              = userInfo.getId();
		int tenantId               = userInfo.getTenantId();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(new Date()), userInfo.getOffset(), true);
		int itemCabinetId          = -1;
		
		if (mode.equals("0")) {
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("userId",   userId);
			map.put("tenantId", tenantId);
			map.put("type",     moduleType);
			
			CabinetVO cabinet = ezCabinetDAO.getRootCabinetByType(map);
			itemCabinetId     = cabinet.getCabinetId();
		}
		else {
			itemCabinetId = cabinetId;
		}
		
		//Add item
		addNewItem(itemCabinetId, itemId, moduleType, title, summary, content, timeUTC, userInfo);
	}
	
	private void addNewItem(int cabinetId, int itemId, int moduleType, String title, String summary, String content, String timeUTC, LoginVO userInfo) {
		String userId        = userInfo.getId();
		CabinetItemVO itemVO = new CabinetItemVO();
		itemVO.setCabinetId(cabinetId);
		itemVO.setItemId(itemId);
		itemVO.setItemType(moduleType);
		itemVO.setTitle(title);
		itemVO.setSummary(summary);
		itemVO.setCreatorId(userId);
		itemVO.setCreatorName1(userInfo.getDisplayName1());
		itemVO.setCreatorName2(userInfo.getDisplayName2());
		itemVO.setDepartmentId(userInfo.getDeptID());
		itemVO.setDepartmentName1(userInfo.getDeptName1());
		itemVO.setDepartmentName2(userInfo.getDeptName2());
		itemVO.setContentPath(content);
		itemVO.setCreatedDate(timeUTC);
		itemVO.setUpdatedDate(timeUTC);
		itemVO.setUseStatus(1);
		itemVO.setUpdateId(userId);
		itemVO.setDeleterId(null);
		itemVO.setCompanyId(userInfo.getCompanyID());
		itemVO.setTenantId(userInfo.getTenantId());
		
		saveItem(itemVO);
	}
	
	private CabinetColumnVO createNewRelatedColumn(String columnId, int itemId, String messageName, String columnValue, String companyId, int tenantId) {
		String columnName1 = egovMessageSource.getMessage(messageName, new Locale(config.getProperty("config.cabinetPrimary")));
		String columnName2 = egovMessageSource.getMessage(messageName, new Locale(config.getProperty("config.cabinetPrimary")));
		return new CabinetColumnVO(columnId, itemId, columnName1, columnName2, columnValue, companyId, tenantId);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveCommunityItem(String realPath, String mode, int cabinetId, String title, String summary, String commuTitle, String writer, String date, String endDate, String content, String attach, Locale locale, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		JSONParser jp          = new JSONParser();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		//Save attach files
		if (!attach.equals("")) {
			JSONArray attachList  = (JSONArray) jp.parse(attach);
			result                = saveListAttachFiles(attachList, itemId, realPath, "upload_community.ROOT", "", locale, userInfo);
			if (!result.get("status").equals("ok")) {
				return result;
			}
		}
		
		//Add community item
		int moduleType = 7; //community module
		addRelatedItem(itemId, moduleType, cabinetId, title, summary, content, mode, userInfo);
		
		//Save option columns information
		List<CabinetColumnVO> listColm = new ArrayList<>();
		listColm.add(createNewRelatedColumn("commuTitle"  , itemId, "ezCabinet.t62"   , commuTitle, companyId, tenantId));
		listColm.add(createNewRelatedColumn("commuWriter" , itemId, "ezCommunity.t138", writer    , companyId, tenantId));
		listColm.add(createNewRelatedColumn("commuTime"   , itemId, "ezCommunity.t209", date      , companyId, tenantId));
		listColm.add(createNewRelatedColumn("commuEndDate", itemId, "ezCommunity.t931", endDate   , companyId, tenantId));
		listColm.add(createNewRelatedColumn("commuType"   , itemId, "ezCommunity.t931", "normal"  , companyId, tenantId));
		
		saveAllColumns(listColm);
		result.put("status", "ok");
		result.put("code", 0);
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject savePhotoCommunityitem(String realPath, String mode, int cabinetId, String title, String summary, String commuTitle, String writer, String content, Locale locale, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		//Add community item
		int moduleType = 7; //community module
		addRelatedItem(itemId, moduleType, cabinetId, title, summary, content, mode, userInfo);
		
		//Save option columns information
		List<CabinetColumnVO> listColm = new ArrayList<>();
		listColm.add(createNewRelatedColumn("commuTitle" , itemId, "ezCabinet.t62"   , commuTitle, companyId, tenantId));
		listColm.add(createNewRelatedColumn("commuWriter", itemId, "ezCommunity.t138", writer    , companyId, tenantId));
		listColm.add(createNewRelatedColumn("commuType"  , itemId, "ezCommunity.t931", "photo"   , companyId, tenantId));
		
		saveAllColumns(listColm);
		result.put("status", "ok");
		result.put("code", 0);
		
		return result;
	}
	
	@Override
	public int checkItemPermission(int cabinetId, LoginVO userInfo) throws Exception {
		int permission         = 0;
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("cabinetId", cabinetId);
		map.put("tenantId",  userInfo.getTenantId());
		
		CabinetVO cabinet      = ezCabinetDAO.getCabinetById(map);
		
		if (cabinet.getCreatorId().equals(userInfo.getId())) {
			permission = 1;
			return permission;
		}
		
		//Check if user get write permission by sharing
		map.put("primary",   userInfo.getPrimary());
		map.put("deptId",    userInfo.getDeptID());
		map.put("companyId", userInfo.getCompanyID());
		map.put("userId",    userInfo.getId());
		
		String cabinetPath    = cabinet.getCabinetPath();
		cabinetPath           = cabinetPath.substring(1, cabinetPath.length() - 1);
		List<Integer> nodeIds = Arrays.asList(cabinetPath.split("\\|")).stream().map(Integer::parseInt).collect(Collectors.toList());
		nodeIds.remove(nodeIds.size() - 1);
		map.put("listNodes", nodeIds);
		
		List<String> userDeptList = ezCabinetDAO.getUserDepartmentIdList(map);
		map.put("deptList", userDeptList);
		
		List<CabinetShareVO> listShared = ezCabinetDAO.getSharedCabinetListById(map);
		
		if (listShared != null && listShared.size() > 0) {
			for (CabinetShareVO share : listShared) {
				if (share.getPermission() == 1) {
					permission = 1;
					break;
				}
			}
		}
		
		return permission;
	}
	
	@Override
	public JSONObject modifyShareUserList(JSONArray listUsers, String actMode, String cabinetId, LoginVO userInfo) throws Exception {
		if (actMode.equals("delete")) {
			return deleteShareUserList(listUsers, cabinetId, userInfo);
		}
		else {
			return modifyShareUserList(listUsers, cabinetId, userInfo);
		}
	}
	
	@SuppressWarnings("unchecked")
	private synchronized JSONObject modifyShareUserList(JSONArray listUsers, String cabinetId, LoginVO userInfo) throws Exception {
		JSONObject result       = new JSONObject();
		String userId           = userInfo.getId();
		int tenantId            = userInfo.getTenantId();
		String companyId        = userInfo.getCompanyID();
		String primary          = userInfo.getPrimary();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cabinetId",   cabinetId);
		map.put("userId",      userId);
		map.put("tenantId",    tenantId);
		
		//Add new shared users
		for (int i = 0; i < listUsers.size(); i++) {
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
			ezCabinetDAO_h.modifyShareUserList(map);
		}
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	@SuppressWarnings("unchecked")
	private synchronized JSONObject deleteShareUserList(JSONArray listUsers, String cabinetId, LoginVO userInfo) throws Exception {
		JSONObject result       = new JSONObject();
		String userId           = userInfo.getId();
		int tenantId            = userInfo.getTenantId();
		String companyId        = userInfo.getCompanyID();
		String primary          = userInfo.getPrimary();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cabinetId",   cabinetId);
		map.put("userId",      userId);
		map.put("tenantId",    tenantId);
		
		for (int i = 0; i < listUsers.size(); i++) {
			JSONObject sharedInfo = (JSONObject)listUsers.get(i);
			String sharedId  = (String)sharedInfo.get("userId");
			String userType  = (String)sharedInfo.get("userType");
			
			logger.debug("userType: " + userType);
			
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
			
			map.put("sharedId", sharedId);
			ezCabinetDAO_h.deleteShareUserList(map);
		}
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
}
