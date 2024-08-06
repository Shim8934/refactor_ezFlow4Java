package egovframework.ezEKP.ezWebFolder.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.util.EzWebfolderUtil;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO;
import egovframework.ezEKP.ezWebFolder.vo.FavoriteVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SearchVO;
import egovframework.ezEKP.ezWebFolder.vo.ShareVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleShareVO;
import egovframework.ezEKP.ezWebFolder.vo.TrashCanVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
@SuppressWarnings(value="unchecked")
public class EzWebFolderGWController_m {

	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderGWController_m.class);
	
	@Autowired
	private MOptionService mOptionService ;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzWebFolderService ezWebFolderService;
	
	@Autowired
	private EzWebFolderService_m ezWebFolderService_m;
	
	@Autowired
	private EzWebFolderService_y ezWebFolderService_y;
	
	@Autowired
	private EzWebFolderAdminService ezWebFolderAdminService;

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzWebfolderUtil webfolderUtil;
	
	@Autowired
	private Properties globals;
	
	/**
	 * 공유한 리스트 조회
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/sharing", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSharingList(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("getSharingList started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		String pageNum = orElse(request.getParameter("pageNum"), "1");
		String pageSize = orElse(request.getParameter("pageSize"), "0");
		String subSearchFlag = orElse(request.getParameter("subSearchFlag"), "N");
		
		String searchExt = orElse(request.getParameter("searchExt"), "");
		String searchFileName = orElse(request.getParameter("searchFileName"), "");
		String searchCreatorName = orElse(request.getParameter("searchCreatorName"), "");
		String sortColumn = orElse(request.getParameter("sortColumn"), "");
		String sortType = orElse(request.getParameter("sortType"), "");
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		searchExt = commonUtil.getWildcardEscapedString(searchExt, dbName);
   		searchFileName = commonUtil.getWildcardEscapedString(searchFileName, dbName);
   		searchCreatorName = commonUtil.getWildcardEscapedString(searchCreatorName, dbName);
		
   		SearchVO searchInfo = new SearchVO();
		searchInfo.setSearchExt(searchExt);
		searchInfo.setSearchFileName(searchFileName);
		searchInfo.setSearchCreateName(searchCreatorName);
		searchInfo.setSearchFileType(orElse(request.getParameter("searchFileType"), ""));
		searchInfo.setSearchStartDate(orElse(request.getParameter("searchStartDate"), ""));
		searchInfo.setSearchEndDate(orElse(request.getParameter("searchEndDate"), ""));
		
		logger.debug("serverName : " + serverName + " || userId : " + userId + " || pageNum : " + pageNum + " || pageSize : " + pageSize);
		logger.debug("searchInfo : " + searchInfo);
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (containsNull(serverName, userId)) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("parameter error. getSharingList ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			int pageSizeInt  = Integer.parseInt(pageSize);
			int pageNumInt   = Integer.parseInt(pageNum);
			
			//set pageSize
			int userListCount = ezWebFolderService_y.getUsrListCount(tenantId, userId);
			
			if (pageSizeInt == 0) {
				pageSizeInt = userListCount;
			}
			
			ezWebFolderService_y.insertEnv(userId, tenantId, pageSizeInt);
			
			int startPoint = (pageNumInt - 1) * pageSizeInt;
			
			List<ShareVO> list = ezWebFolderService_m.getSharingList(subSearchFlag, userId, userInfo.getPrimary(), offset, 
					startPoint, pageSizeInt, searchInfo, tenantId, sortColumn, sortType );
			Map<String, Long> countInfo = ezWebFolderService_m.getSharingCount(subSearchFlag, userId, userInfo.getPrimary(), offset, pageSizeInt, searchInfo, tenantId);
			
			data.put("list", list);
			data.putAll(countInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getSharingList ended.");
		return result;
	}
	
	/**
	 * 특정 폴더 또는 파일에 대한 공유 정보 조회
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/sharing/{folderFileId:.+}/{folderFileType:.+}/all", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSharingInfo(@PathVariable String userId, @PathVariable String folderFileId, @PathVariable String folderFileType, HttpServletRequest request) {
		logger.debug("getSharingInfo started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		
		logger.debug("serverName : " + serverName + " || userId : " + userId + " || folderFileId : " + folderFileId + " || folderFileType : " + folderFileType);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (containsNull(serverName, userId, folderFileId, folderFileType)) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("parameter error. getSharingInfo ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			String permissionResult = ezWebFolderService_y.checkPermission(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderFileId, folderFileType, tenantId);
			
			if (!permissionResult.equals("ok")) {
				result.put("status", "error");
				result.put("code", 3);
				
				logger.debug("checkPermission fail.");
				logger.debug("getSharingInfo ended.");
				return result;
			}
			
			List<SimpleShareVO> list = ezWebFolderService_m.getShareInfo("", folderFileId, folderFileType, userInfo.getCompanyID(), userInfo.getPrimary(), offset, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", list);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getSharingInfo ended.");
		return result;
	}
	
	/**
	 * 특정 폴더 또는 파일에 대해 특정 사용자가 공유한 정보 조회
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/sharing/{folderFileId:.+}/{folderFileType:.+}", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserSharingInfo(@PathVariable String userId, @PathVariable String folderFileId, @PathVariable String folderFileType, HttpServletRequest request) {
		logger.debug("getUserSharingInfo started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		
		logger.debug("serverName : " + serverName + " || userId : " + userId + " || folderFileId : " + folderFileId + " || folderFileType : " + folderFileType);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (containsNull(serverName, userId, folderFileId, folderFileType)) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("parameter error. getUserSharingInfo ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			String permissionResult = ezWebFolderService_y.checkPermission(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderFileId, folderFileType, tenantId);
			
			if (permissionResult.equals("fail")) {
				result.put("status", "error");
				result.put("code", 3);
				
				logger.debug("checkPermission fail.");
				logger.debug("getUserSharingInfo ended.");
				return result;
			}
			
			List<SimpleShareVO> list = ezWebFolderService_m.getShareInfo(userId, folderFileId, folderFileType,  userInfo.getCompanyID(), userInfo.getPrimary(),offset, tenantId);
			
			SimpleShareVO shareInfo = null;
			
			if (list.size() > 0) {
				shareInfo = list.get(0);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", shareInfo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getUserSharingInfo ended.");
		return result;
	}
	
	/**
	 * 공유받은 리스트 조회
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/shared", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSharedList(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("getSharedList started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		String pageNum = orElse(request.getParameter("pageNum"), "1");
		String pageSize = orElse(request.getParameter("pageSize"), "0");
		String subSearchFlag = orElse(request.getParameter("subSearchFlag"), "N");
		
		String searchExt = orElse(request.getParameter("searchExt"), "");
		String searchFileName = orElse(request.getParameter("searchFileName"), "");
		String searchCreatorName = orElse(request.getParameter("searchCreatorName"), "");
		String sortColumn = orElse(request.getParameter("sortColumn"), "");
		String sortType = orElse(request.getParameter("sortType"), "");
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		searchExt = commonUtil.getWildcardEscapedString(searchExt, dbName);
   		searchFileName = commonUtil.getWildcardEscapedString(searchFileName, dbName);
   		searchCreatorName = commonUtil.getWildcardEscapedString(searchCreatorName, dbName);
		
		SearchVO searchInfo = new SearchVO();
		searchInfo.setSearchExt(searchExt);
		searchInfo.setSearchFileName(searchFileName);
		searchInfo.setSearchCreateName(searchCreatorName);
		searchInfo.setSearchFileType(orElse(request.getParameter("searchFileType"), ""));
		searchInfo.setSearchStartDate(orElse(request.getParameter("searchStartDate"), ""));
		searchInfo.setSearchEndDate(orElse(request.getParameter("searchEndDate"), ""));
		
		logger.debug("serverName : " + serverName + " || userId: " + userId);
        logger.debug("pageNum : " + pageNum + " || pageSize: " + pageSize);
        logger.debug("subSearchFlag : " + subSearchFlag + " || searchInfo : " + searchInfo);
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (containsNull(serverName, userId)) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("parameter error. getSharedList ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			int pageSizeInt  = Integer.parseInt(pageSize);
			int pageNumInt   = Integer.parseInt(pageNum);
			
			//set pageSize
			int userListCount = ezWebFolderService_y.getUsrListCount(tenantId, userId);
			
			if (pageSizeInt == 0) {
				pageSizeInt = userListCount;
			}
			
			ezWebFolderService_y.insertEnv(userId, tenantId, pageSizeInt);
			
			int startPoint = (pageNumInt - 1) * pageSizeInt;
			
			List<ShareVO> list = ezWebFolderService_m.getSharedList(subSearchFlag, userId, userInfo.getDeptID(), userInfo.getCompanyID(), 
					userInfo.getPrimary(), offset, startPoint, pageSizeInt, searchInfo, tenantId, sortColumn, sortType);
			Map<String, Long> countInfo = ezWebFolderService_m.getSharedCount(subSearchFlag, userId, userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getPrimary(), offset, pageSizeInt, searchInfo, tenantId);
			
			data.put("list", list);
			data.put("listCount", userListCount);
			data.putAll(countInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getSharedList ended.");
		return result;
	}
	
	/**
	 * 공유 추가
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/sharing/{folderFileId:.+}/{folderFileType:.+}", method=RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addShare(@PathVariable String userId, @PathVariable String folderFileId, @PathVariable String folderFileType, HttpServletRequest request) throws Exception {
		logger.debug("addShare started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		String deptList = orElse(request.getParameter("deptList"), "");
		String userList = orElse(request.getParameter("userList"), "");
		
		logger.debug("serverName : " + serverName + " || userId : " + userId + " || folderFileId : " + folderFileId + " || folderFileType : " + folderFileType);
		logger.debug("deptList :" + deptList);
		logger.debug("userList :" + userList);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (containsNull(serverName, userId, folderFileId, folderFileType) || (deptList.isEmpty() && userList.isEmpty())) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("parameter error. addShare ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			String permissionResult = ezWebFolderService_y.checkPermission(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderFileId, folderFileType, tenantId);
			
			if (!permissionResult.equals("ok")) {
				result.put("status", "error");
				result.put("code", 3);
				
				logger.debug("checkPermission fail.");
				logger.debug("addShare ended.");
				return result;
			}
			
			ezWebFolderService_m.insertShare(userId, folderFileId, folderFileType, deptList, userList, offset, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("addShare ended.");
		return result;
	}
	
	/**
	 * 공유 수정
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/sharing/{folderFileId:.+}/{folderFileType:.+}", method=RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateShare(@PathVariable String userId, @PathVariable String folderFileId, @PathVariable String folderFileType, HttpServletRequest request) throws Exception {
		logger.debug("updateShare started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		String deptList = orElse(request.getParameter("deptList"), "");
		String userList = orElse(request.getParameter("userList"), "");
		
		logger.debug("serverName : " + serverName + " || userId : " + userId + " || folderFileId : " + folderFileId + " || folderFileType : " + folderFileType);
		logger.debug("deptList :" + deptList);
		logger.debug("userList :" + userList);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (containsNull(serverName, userId, folderFileId, folderFileType) || (deptList.isEmpty() && userList.isEmpty())) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("parameter error. updateShare ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			String permissionResult = ezWebFolderService_y.checkPermission(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderFileId, folderFileType, tenantId);
			
			if (!permissionResult.equals("ok")) {
				result.put("status", "error");
				result.put("code", 3);
				
				logger.debug("checkPermission fail.");
				logger.debug("updateShare ended.");
				return result;
			}
			
			ezWebFolderService_m.updateShare(folderFileId, folderFileType, userId, deptList, userList, offset, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("updateShare ended.");
		return result;
	}
	
	/**
	 * 공유 삭제
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/sharing", method=RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteShare(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("deleteShare started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		String fileListStr = orElse(request.getParameter("fileList"), "");
		String folderListStr = orElse(request.getParameter("folderList"), "");
		
		logger.debug("serverName : " + serverName + " || userId : " + userId + " || fileListStr : " + fileListStr + " || folderListStr : " + folderListStr);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (containsNull(serverName, userId) || (fileListStr.isEmpty() && folderListStr.isEmpty())) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("parameter error. deleteShare ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			
			JSONObject permissionResult = ezWebFolderService_y.checkPermissions(userId, common.getDeptId(), common.getCompanyId(), folderListStr, fileListStr, tenantId);
			
			if ("error".equals(permissionResult.get("status"))) {
				logger.debug("deleteShare ended.");
				return permissionResult;
			}
			
			String[] fileList = fileListStr.split(",");
			String[] folderList = folderListStr.split(",");
			
			for (String fileId : fileList) {
				if (fileId.isEmpty()) {
					continue;
				}
				
				ezWebFolderService_m.deleteShare(fileId, "F", userId, tenantId);
			}
			
			for (String folderId : folderList) {
				if (folderId.isEmpty()) {
					continue;
				}
				
				ezWebFolderService_m.deleteShare(folderId, "D", userId, tenantId);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("deleteShare ended.");
		return result;
	}
	
	/**
	 * 공유 숨김 리스트 조회
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/shared-hide", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getHiddenSharedList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("getHiddenSharedList started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		String pageNum 		= orElse(request.getParameter("pageNum"), "1");
		String pageSize 	= orElse(request.getParameter("pageSize"), "0");
		String sortType 	= orElse(request.getParameter("sortType"), "");
		String sortColumn 	= orElse(request.getParameter("sortColumn"), "");

		logger.debug("serverName : " + serverName + " || userId : " + userId + " || pageNum : " + pageNum + " || pageSize : " + pageSize);
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (containsNull(userId, serverName)) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("parameter error. getHiddenSharedList ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			int pageSizeInt  = Integer.parseInt(pageSize);
			int pageNumInt   = Integer.parseInt(pageNum);
			
			//set pageSize
			int userListCount = ezWebFolderService_y.getUsrListCount(tenantId, userId);
			
			if (pageSizeInt == 0) {
				pageSizeInt = userListCount;
			}
			
			ezWebFolderService_y.insertEnv(userId, tenantId, pageSizeInt);
			
			int startPoint = (pageNumInt - 1) * pageSizeInt;
			
			List<ShareVO> list = ezWebFolderService_m.getHiddenSharedList(userId, userInfo.getDeptID(), userInfo.getCompanyID(), 
					userInfo.getPrimary(), offset, startPoint, pageSizeInt, tenantId, sortType, sortColumn);
			Map<String, Long> countInfo = ezWebFolderService_m.getHiddenSharedCount(userId, userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getPrimary(), offset, pageSizeInt, tenantId);
			
			data.put("list", list);
			data.putAll(countInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getHiddenSharedList ended.");
		return result;
	}
	
	/**
	 * 공유 숨김
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/shared-hide", method=RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject hideShare(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("hideShare started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		String fileListStr = orElse(request.getParameter("fileList"), "");
		String folderListStr = orElse(request.getParameter("folderList"), "");
		
		logger.debug("serverName : " + serverName + " || userId : " + userId + " || fileListStr : " + fileListStr + " || folderListStr : " + folderListStr);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (containsNull(serverName, userId) || (fileListStr.isEmpty() && folderListStr.isEmpty())) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("parameter error. hideShare ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONObject permissionCheckResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderListStr, fileListStr, userInfo.getTenantId());
			
			if ("error".equals(permissionCheckResult.get("status"))) {
				logger.debug("hideShare ended.");
				return permissionCheckResult;
			}
			
			String[] fileList = fileListStr.split(",");
			String[] folderList = folderListStr.split(",");
			
			for (String fileId : fileList) {
				if (fileId.isEmpty()) {
					continue;
				}
				
				ezWebFolderService_m.hideShare(fileId, "F", userId, userInfo.getDeptID(), userInfo.getCompanyID(), offset, tenantId);
			}
			
			for (String folderId : folderList) {
				if (folderId.isEmpty()) {
					continue;
				}
				
				ezWebFolderService_m.hideShare(folderId, "D", userId, userInfo.getDeptID(), userInfo.getCompanyID(), offset, tenantId);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("hideShare ended.");
		return result;
	}
	
	/**
	 * 공유 숨김 취소
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/shared-hide", method=RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject showShare(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("showShare started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		String fileListStr = orElse(request.getParameter("fileList"), "");
		String folderListStr = orElse(request.getParameter("folderList"), "");
		
		logger.debug("serverName : " + serverName + " || userId : " + userId + " || fileListStr : " + fileListStr + " || folderListStr : " + folderListStr);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (containsNull(serverName, userId) || (fileListStr.isEmpty() && folderListStr.isEmpty())) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("parameter error. showShare ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONObject permissionCheckResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderListStr, fileListStr, userInfo.getTenantId());
			
			if ("error".equals(permissionCheckResult.get("status"))) {
				logger.debug("showShare ended.");
				return permissionCheckResult;
			}
			
			String[] fileList = fileListStr.split(",");
			String[] folderList = folderListStr.split(",");
			
			for (String fileId : fileList) {
				if (fileId.isEmpty()) {
					continue;
				}
				
				ezWebFolderService_m.showShare(fileId, "F", userId, userInfo.getDeptID(), userInfo.getCompanyID(), offset, tenantId);
			}
			
			for (String folderId : folderList) {
				if (folderId.isEmpty()) {
					continue;
				}
				
				ezWebFolderService_m.showShare(folderId, "D", userId, userInfo.getDeptID(), userInfo.getCompanyID(), offset, tenantId);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("showShare ended.");
		return result;
	}
	
	/**
	 * 즐겨찾기 대상 조회
	 * 
	 * @author 강민수79, 서재원
	 * @date 2018.02.22.
	 * 
	 * @param userId
	 * @param offset
	 * @param primary
	 * @param tenantId
	 * @param startIndex
	 * @param endIndex
	 * 
	 * @return JSONObject
	 */
	@RequestMapping(value = "/rest/ezwebfolder/users/{userId:.+}/favorites", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFavoriteList(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W WEBFOLDER [GET /rest/ezwebfolder/users/{userId}/favorites] started.");
		
		String serverName = request.getHeader("x-user-host");
		int startIndex = Integer.parseInt(orElse(request.getParameter("startIndex"), "0"));
		int listCount = Integer.parseInt(orElse(request.getParameter("listCount"), "0"));
		
		String searchExt = orElse(request.getParameter("searchExt"), "");
		String searchFileName = orElse(request.getParameter("searchFileName"), "");
		String searchCreatorName = orElse(request.getParameter("searchCreatorName"), "");
		String sortType = orElse(request.getParameter("sortType"), "");
		String sortColumn = orElse(request.getParameter("sortColumn"), "");
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		searchExt = commonUtil.getWildcardEscapedString(searchExt, dbName);
   		searchFileName = commonUtil.getWildcardEscapedString(searchFileName, dbName);
   		searchCreatorName = commonUtil.getWildcardEscapedString(searchCreatorName, dbName);
		
		SearchVO searchInfo = new SearchVO();
		searchInfo.setSearchExt(searchExt);
		searchInfo.setSearchFileName(searchFileName);
		searchInfo.setSearchCreateName(searchCreatorName);
		searchInfo.setSearchFileType(orElse(request.getParameter("searchFileType"), ""));
		searchInfo.setSearchStartDate(orElse(request.getParameter("searchStartDate"), ""));
		searchInfo.setSearchEndDate(orElse(request.getParameter("searchEndDate"), ""));
		
		JSONObject result = new JSONObject();
		
		if (containsNull(serverName, userId)) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("G/W WEBFOLDER parameter error. [GET /rest/ezwebfolder/users/{userId}/favorites] ended.");
			return result;
		}
		
		try {
			MCommonVO userInfo = mOptionService.commonInfoWeb(serverName, userId);
			
			int tenantId = userInfo.getTenantId();
			String primary = userInfo.getPrimary();
			String offset = userInfo.getOffSet();
			String deptId = userInfo.getDeptId();
			String companyId = userInfo.getCompanyId();
			
			// setup list count
			{
				// list count
				int userListCount = ezWebFolderService_y.getUsrListCount(tenantId, userId);
				
				if (listCount == 0) {
					listCount = userListCount;
				}
				
				ezWebFolderService_y.insertEnv(userId, tenantId, listCount);
			}
			
			Map<String, Long> favoriteCountMap = ezWebFolderService_m.getFavoritesCount(userId, primary, offset, tenantId, listCount, searchInfo);
			long totalCount = favoriteCountMap.get("totalCount");
			long folderCount = favoriteCountMap.get("folderCount");
			long fileCount = favoriteCountMap.get("fileCount");
			
			if (startIndex >= totalCount) {
				startIndex = (int) (totalCount - 1) / listCount * listCount;
			}
			
			List<FavoriteVO> favoriteFiles = ezWebFolderService_m.getFavorites(userId, primary, offset, tenantId, searchInfo, 
					startIndex, listCount, sortType, sortColumn);

			List<String> containsReplyFiles = ezWebFolderService.getContainsReplyFiles(
					favoriteFiles.stream()
							.filter(FavoriteVO::isFile)
							.map(FavoriteVO::getTargetId)
							.collect(Collectors.toList()),
					tenantId);
			
			List<String> managedList = new ArrayList<>();
			Map<String, Boolean> folderManagedCache = new HashMap<>();

			for (FavoriteVO favorite : favoriteFiles) {
				String folderId = favorite.isFile() ? favorite.getFolderId() : favorite.getTargetId();

				boolean isManaged = folderManagedCache.computeIfAbsent(folderId, fldId -> {
					try {
						return ezWebFolderAdminService.getFolderIdsByManagerUserId(userId, fldId, companyId, tenantId).size() > 0;
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
						return false;
					}
				});

				if (isManaged) {
					managedList.add(favorite.getTargetId());
				}
			}

			JSONObject data = new JSONObject();
			data.put("totalCount", totalCount);
			data.put("folderCount", folderCount);
			data.put("fileCount", fileCount);
			data.put("listCount", listCount);
			data.put("targetList", favoriteFiles);
			data.put("containsReplyFiles", containsReplyFiles);
			data.put("managedList", managedList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug(String.format("result: %s", result.toJSONString()));
		logger.debug("G/W WEBFOLDER [GET /rest/ezwebfolder/users/{userId}/favorites] ended.");
		return result;
	}

	/**
	 * 즐겨찾기 대상 추가
	 * 
	 * @author 서재원
	 * @date 2018.04.12.
	 * 
	 * @param targetId
	 * @param userId
	 * @param targetType
	 * @param tenantId
	 * 
	 * @return JSONObject
	 */
	@RequestMapping(value = "/rest/ezwebfolder/users/{userId:.+}/favorite", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addFavorite(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W WEBFOLDER [POST /rest/ezwebfolder/users/{userId}/favorite] started.");
		
		String serverName = request.getHeader("x-user-host");
		String fileListStr = orElse(request.getParameter("fileList"), "");
		String folderListStr = orElse(request.getParameter("folderList"), "");
		
		JSONObject result = new JSONObject();

		if (containsNull(serverName, userId) || (containsNull(fileListStr) && containsNull(folderListStr))) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("G/W WEBFOLDER parameter error. [POST /rest/ezwebfolder/users/{userId}/favorite] ended.");
			return result;
		}

		try {
			String[] fileList = fileListStr.split(",");
			String[] folderList = folderListStr.split(",");
			
			MCommonVO userInfo = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = userInfo.getTenantId();
			String offset = userInfo.getOffSet();
			
			/* JSONObject permissionCheckResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptId(), userInfo.getCompanyId(), folderListStr, fileListStr, tenantId);
			
			if ("error".equals(permissionCheckResult.get("status"))) {
				return permissionCheckResult;
			} */
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String createDate = commonUtil.getDateStringInUTC(format.format(new Date()), offset, true);
			
			for (String fileId : fileList) {
				if (fileId.isEmpty() || ezWebFolderService_m.isExistsFavorite(userId, fileId, "F", tenantId)) {
					continue;
				}
				
				ezWebFolderService_m.addFavorite(userId, fileId, "F", createDate, tenantId);
			}
			
			for (String folderId : folderList) {
				if (folderId.isEmpty() || ezWebFolderService_m.isExistsFavorite(userId, folderId, "D", tenantId)) {
					continue;
				}
				
				ezWebFolderService_m.addFavorite(userId, folderId, "D", createDate, tenantId);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug(String.format("result: %s", result.toJSONString()));
		logger.debug("G/W WEBFOLDER [POST /rest/ezwebfolder/users/{userId}/favorite] ended.");
		return result;
	}
	
	/**
	 * 즐겨찾기 대상 삭제
	 * 
	 * @author 서재원
	 * @date 2018.04.12.
	 * 
	 * @param targetId
	 * @param userId
	 * @param targetType
	 * @param tenantId
	 * 
	 * @return JSONObject
	 */
	@RequestMapping(value = "/rest/ezwebfolder/users/{userId:.+}/favorite", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteFavorite(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W WEBFOLDER [DELETE /rest/ezwebfolder/users/{userId}/favorite] started.");

		String serverName = request.getHeader("x-user-host");
		String fileListStr = orElse(request.getParameter("fileList"), "");
		String folderListStr = orElse(request.getParameter("folderList"), "");
		JSONObject result = new JSONObject();

		if (containsNull(serverName, userId) || (containsNull(fileListStr) && containsNull(folderListStr))) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("G/W WEBFOLDER parameter error. [DELETE /rest/ezwebfolder/users/{userId}/favorite] ended.");
			return result;
		}
		
		try {
			String[] fileList = fileListStr.split(",");
			String[] folderList = folderListStr.split(",");
			
			MCommonVO userInfo = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = userInfo.getTenantId();
			
			for (String fileId : fileList) {
				if (fileId.isEmpty() || !ezWebFolderService_m.isExistsFavorite(userId, fileId, "F", tenantId)) {
					continue;
				}
				
				ezWebFolderService_m.deleteFavorite(userId, fileId, "F", tenantId);
			}
			
			for (String folderId : folderList) {
				if (folderId.isEmpty() || !ezWebFolderService_m.isExistsFavorite(userId, folderId, "D", tenantId)) {
					continue;
				}
				
				ezWebFolderService_m.deleteFavorite(userId, folderId, "D", tenantId);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("result: {}", result);
		logger.debug("G/W WEBFOLDER [DELETE /rest/ezwebfolder/users/{userId}/favorite] ended.");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/{userId:.+}/getTrashCanList", method=RequestMethod.POST, produces ="application/json;charset=utf-8")
	public JSONObject getTrashCanList (@PathVariable String userId, HttpServletRequest request, Locale locale) {
		String serverName =  orElse(request.getHeader("x-user-host"), "");
		
		int listCount 	        = Integer.parseInt(orElse(request.getParameter("listCount"), "10"));
		int currPage 	        = Integer.parseInt(orElse(request.getParameter("currPage"), "1"));
		
		
		String searchExt 		= orElse(request.getParameter("searchExt"), "" );
		String searchFileName 	= orElse(request.getParameter("searchFileName"), "");
		String searchCreateName = orElse(request.getParameter("searchCreateName"), "");
		String searchFileType   = orElse(request.getParameter("searchFileType"), "");
		String enrollStartDate = orElse(request.getParameter("enrollStartDate"), "");
		String enrollEndDate 	= orElse(request.getParameter("enrollEndDate"), "");
		String delStartDate 	= orElse(request.getParameter("delStartDate"), "");
		String delEndDate 		= orElse(request.getParameter("delEndDate"), "");
		String column           = orElse(request.getParameter("column"), "");
		String order            = orElse(request.getParameter("order"), "");
		String mode 		    = orElse(request.getParameter("mode"), "");
		String sortType 		= orElse(request.getParameter("sortType"), "");
		String sortColumn 		= orElse(request.getParameter("sortColumn"), "");
		String realColumn        = "";
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		searchExt = commonUtil.getWildcardEscapedString(searchExt, dbName);
   		searchFileName = commonUtil.getWildcardEscapedString(searchFileName, dbName);
   		searchCreateName = commonUtil.getWildcardEscapedString(searchCreateName, dbName);
		
		// TODO primary 수정
		LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
		String primary = userInfo.getPrimary();
   		
		/*String primary;
		
		try {
			primary = mOptionService.commonInfo(serverName, userId).getPrimary();
		} catch (Exception ex) {
			primary = "1";
		}*/

		logger.debug("getTrashCanList Started.");
		logger.debug("userId : " + userId +  " || serverName : " + serverName);
		logger.debug("currPage : " + currPage + " || listCount : " + listCount);
		logger.debug("searchExt : " + searchExt + " || searchFileName : " + searchFileName + " || searchCreateName : " + searchCreateName + " || searchFileType : " + searchFileType);
		logger.debug("enrollStartDate : " + enrollStartDate + " || enrollEndDate : " + enrollEndDate + " || delStartDate : " + delStartDate + " || delEndDate : " + delEndDate);
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		if (userId.equals("")  || userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		if (!column.equals("") && !order.equals("")) {
			switch(column) {
				case "ft": realColumn = "TRASHCAN_EXT"                                         ; break;
				case "fn": realColumn = "TRASHCAN_NAME"                                        ; break;
				case "fs": realColumn = "TRASHCAN_SIZE"                                        ; break;
				case "un": realColumn = primary.equals("1") ? "CREATE_NAME1" : "CREATE_NAME2"  ; break;
				case "cd": realColumn = "CREATE_DATE"                                          ; break;
				case "dd": realColumn = "UPDATE_DATE"                                          ; break;
				default  : realColumn = "TRASHCAN_NAME"                                        ; break;
			}
		}
		
		logger.debug("Column: " + realColumn + " || order: " + order);
		
		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			
			List<TrashCanVO> trashCanList = null;
			JSONObject resultList = ezWebFolderService_m.getTrashCanList(realColumn, order.toUpperCase(), userId, offset, tenantId, currPage, listCount,
										searchExt, searchFileName, searchCreateName, searchFileType, enrollStartDate, enrollEndDate, delStartDate, 
										delEndDate, mode, sortType, sortColumn);
			int fileCnt = 0;
			int folderCnt = 0;
			int totalCount = 0;
			int currentPage = 0;
			int totalPages = 0;
			
			if (result != null) {
				trashCanList = (List<TrashCanVO>) resultList.get("trashCanList");
				fileCnt = (int) resultList.get("fileCnt");
				folderCnt = (int) resultList.get("folderCnt");
				totalCount = (int) resultList.get("totalRows");
				currentPage = (int) resultList.get("currentPage");
				totalPages = (int) resultList.get("totalPages");
			}
			
			String trashCanPath = "";
			
			if (trashCanList != null) {
				for (TrashCanVO trashCan : trashCanList) {
					
					if(trashCan.getTrashCanPath() != null) {
						trashCanPath = trashCan.getTrashCanPath().substring(1);
						trashCanPath = ezWebFolderService.getFolderPath(trashCanPath.split("\\|"), primary, tenantId);
						trashCanPath = trashCanPath.substring(0, trashCanPath.length() - 1);
						
//						if (trashCan.getTrashCanExt().equals("folder")) {
//							trashCanPath = trashCanPath.substring(0, trashCanPath.lastIndexOf("/"));
//						}
						
						trashCan.setTrashCanPath(trashCanPath);
					} else {
						trashCan.setTrashCanPath("");
					}
				}
			}

			data.put("trashCanList", trashCanList);
			data.put("fileCnt", fileCnt);
			data.put("folderCnt", folderCnt);
			data.put("totalRows", totalCount);
			data.put("totalPages", totalPages);
			data.put("currPage", currentPage);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("result=" + result);
		logger.debug("getTrashCanList ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezwebfolder/file-permanent-delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject filePermanetDelete(Locale locale, HttpServletRequest request) {
		String fileList     = orElse(request.getParameter("fileList"), "");
		String folderList   = orElse(request.getParameter("folderList"), "");
		String versionList  = orElse(request.getParameter("versionList"), "");
		String userId       = orElse(request.getParameter("userId"), "");
		String serverName   = orElse(request.getHeader("x-user-host"), "");
		
		logger.debug("filePermanetDelete Started.");
		logger.debug("userId : " + userId  + " || serverName : " + serverName);
		logger.debug("fileList : " + fileList);
		logger.debug("folderList : " + folderList);
		
		String[] fileIDList = fileList.split(",");
		String[] folderIDList = folderList.split(",");
		// 파일아이디:버전 으로 되어있음
		String[] versionTokens = versionList.split(",");
		String realPath = request.getServletContext().getRealPath("");
		JSONObject result   = new JSONObject();
		
		if (fileIDList.length == 0 && folderIDList.length == 0|| serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			// 휴지통 복원, 이동, 영구삭제는 일단 권한 체크 뺌
			/* if (!webfolderUtil.isWebfolderAdmin(userInfo)) {
				JSONObject permissionCheckResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderList, fileList, userInfo.getTenantId());
				
				if ("error".equals(permissionCheckResult.get("status"))) {
					return permissionCheckResult;
				}
			} */
			
			ezWebFolderService_m.permanetDeleteSelectedFiles(fileIDList, folderIDList, userInfo, realPath, "");
			ezWebFolderService_m.permanetDeleteSelectedVersions(versionTokens, userInfo.getTenantId(), userInfo);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("filePermanetDelete ended");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/restore-trashCan", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject restoreTrashCan(Locale locale, HttpServletRequest request) {
		String companyId = orElse(request.getParameter("companyId"), "");
		String userId = orElse(request.getParameter("userId"), "");
		String serverName   = orElse(request.getHeader("x-user-host"), "");
		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");
		String versionList  = orElse(request.getParameter("versionList"), "");

		logger.debug("restoreTrashCan Started.");
		logger.debug("userId : " + userId + " || serverName : " + serverName + " || companyId : " + companyId);
		logger.debug("fileList : " + fileList);
		logger.debug("folderList : " + folderList);
		logger.debug("versionList : " + versionList);
		
		String[] fileIDList = fileList.split(",");
		String[] folderIDList = folderList.split(",");
		String[] versionTokens = versionList.split(",");
		JSONObject result = new JSONObject();
		
		
		if (fileIDList.length == 0 && folderIDList.length == 0 && versionTokens.length == 0 || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             =  commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			
			// 휴지통 복원, 이동, 영구삭제는 일단 권한 체크 뺌
			/* if (!webfolderUtil.isWebfolderAdmin(userInfo)) {
				JSONObject permissionCheckResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderList, fileList, userInfo.getTenantId());
				
				if ("error".equals(permissionCheckResult.get("status"))) {
					return permissionCheckResult;
				}
			} */
			
			Map<String, Object> resultMap = ezWebFolderService_m.restoreTrashCan(fileIDList, folderIDList, tenantId,
					userId, offset, companyId, timeUTC, userInfo.getDisplayName1(), userInfo.getDisplayName2(), userInfo.getPrimary());

			Set<String> errorVersions = new HashSet<>();

			// 버전을 복원합니다.
			// 버전 토큰은 "파일아이디:버전" 이렇게 되어있습니다.
			for (String versionToken : versionTokens) {
				if (versionToken.isEmpty()) {
					continue;
				}

				String[] fileAndVersion = versionToken.split(":");
				String fileId = fileAndVersion[0];
				int version = Integer.parseInt(fileAndVersion[1]);

				if (errorVersions.contains(fileId)) {
					continue;
				}

				boolean isError = !ezWebFolderService.restoreFileVersionFromTrash(userInfo, fileId, version);

				if (isError) {
					// 실패 했다면 원본 파일이 휴지통에 있는겁니다.
					// 에러 목록에 파일 아이디를 추가합니다.
					errorVersions.add(fileId);
				}
			}
			
			result.putAll(resultMap);
			result.put("errorVersions", errorVersions);
			result.put("status", "ok");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("result=" + result);
		logger.debug("restoreTrashCan ended");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/move-TrashCan", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject moveTrashCan(Locale locale, HttpServletRequest request) {
		String userId = orElse(request.getParameter("userId"), "");
		String folderId = orElse(request.getParameter("folderId"), "");
		String serverName   = orElse(request.getHeader("x-user-host"), "");
		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");
		String fileNameList = orElse(request.getParameter("fileNameList"), "");
		
		boolean isOverwritable = request.getParameter("overwritable") != null;
		boolean hasNameList = fileNameList.trim().length() > 0;
		// 폴더는 덮어쓰기, 이름변경 둘 다 지원하지 않음
		// String folderNameList = orElse(request.getParameter("folderNameList"), "");
		
		logger.debug("moveTrashCan Started.");
		logger.debug("userId : " + userId + " || folderId : " + folderId + " || serverName : " + serverName);
		logger.debug("fileList : " + fileList);
		logger.debug("folderList : " + folderList);
		
		String[] fileIDList = fileList.split(",");
		String[] folderIDList = folderList.split(",");
		String[] fileNameArray = hasNameList ? fileNameList.split(",") : null;
		JSONObject result = new JSONObject();
		
		if (fileIDList.length == 0 & folderIDList.length == 0|| serverName.equals("") || userId.equals("") || folderId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		if (hasNameList && (fileNameArray == null || fileNameArray.length != fileIDList.length)) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO user = commonUtil.getUserForGw(userId, serverName);
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             =  commonUtil.getDateStringInUTC(formatter.format(date), user.getOffset(), true);
		
			// 휴지통 복원, 이동, 영구삭제는 일단 권한 체크 뺌
			/* if (!webfolderUtil.isWebfolderAdmin(user.getRollInfo())) {
				JSONObject permissionCheckResult = ezWebFolderService_y.checkPermissions(userId, user.getDeptID(), user.getCompanyID(), folderList, fileList, user.getTenantId());
				
				if ("error".equals(permissionCheckResult.get("status"))) {
					return permissionCheckResult;
				}
			} */
			
			Map<String, Object> resultMap;
			List<DuplicateInfoVO> duplicateList;
			boolean hasExceededCapacities;
			
			if (isOverwritable || hasNameList) {
				resultMap = ezWebFolderService_m.moveTrashCan(fileIDList, folderIDList, fileNameArray, folderId, timeUTC, user, isOverwritable);
			} else {
				resultMap = ezWebFolderService_m.moveTrashCan(fileIDList, folderIDList, folderId, timeUTC, user);
			}
			
			duplicateList = (List<DuplicateInfoVO>) resultMap.get("duplicateList");
			hasExceededCapacities = (boolean) Optional.ofNullable(resultMap.get("hasExceededCapacities")).orElse(false);
			result.put("status", "ok");
			
			if (hasExceededCapacities) {
				logger.debug("Not enough storage to move/copy these files!");
				result.put("code", 4);
				result.put("status", "error");
			} else if (duplicateList.isEmpty()) {
				result.put("code", 0);
			} else {
				result.put("code", 8);
				result.put("duplicateInfoArray", duplicateList);
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("moveTrashCan ended");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/getUserListCount", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject getUserListCount (HttpServletRequest request) {
		int tenantId = Integer.parseInt(orElse(request.getParameter("tenantId"), "0"));
		String userId = orElse(request.getParameter("userId"), "");
		
		logger.debug("getUserListCount Started.");
		logger.debug("tenantId : " + tenantId + " || userId : " + userId);

		JSONObject result = new JSONObject();
		
		try {
			
			int listCount = ezWebFolderService_y.getUsrListCount(tenantId, userId);
			
			result.put("listCount", listCount);
		} catch (Exception e) {
			result.put("listCount", "10");
		}
		
		logger.debug("getUserListCount ended");
		
		return result;
	}
	
	private <T> T orElse(T value, T other) {
		if (other == null) {
			throw new IllegalArgumentException("other is null!");
		}
		
		return value != null ? value : other;
	}
	
	private boolean containsNull(Object... elements) {
		for(Object e : elements) {
			if (e == null) {
				return true;
			}
			
			// string is ""
			if (e.toString().isEmpty()) {
				return true;
			}
		}
		
		return false;
	}	
	
	/**
	 * 웹폴더 개설 신청
	 * - 웹폴더 개설 신청 정보, 개설 신청 당시의 구성원, 담당자 목록 저장
	 * param : folderName, content, memberList
	 */
	@RequestMapping(value="/rest/ezwebfolder/{userId:.+}/setApplyHistory", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject setApplyHistory (@PathVariable String userId, HttpServletRequest request, @RequestBody JSONObject bodyObj) throws Exception {
		logger.debug("setApplyHistory Started.");
		
		JSONObject result = new JSONObject();
		String status = "OK";
		String applyId = "";

		String serverName = orElse(request.getHeader("x-user-host"), "");
		
		logger.debug("bodyObj=" + bodyObj.toString());
		String folderName = commonUtil.cleanValue(orElse((String) bodyObj.get("folderName"), ""));
		String content = commonUtil.cleanValue(orElse((String) bodyObj.get("content"), ""));
		String memberList = orElse((String) bodyObj.get("memberList"), "[]");
		String usingS = orElse((String) bodyObj.get("usingS"), "");
		String usingE = orElse((String) bodyObj.get("usingE"), "");
		
		LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
		int tenantId = userInfo.getTenantId();
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		String companyId = userInfo.getCompanyID();

		String timeUTC =  commonUtil.getTodayUTCTime("");

		logger.debug("userId=" + userId + ", serverName=" + serverName + ", tenantId=" + tenantId + ", primary=" + primary + ", companyId=" + companyId
				+ ", folderName=" + folderName + ", content=" + content + ", usingS=" + usingS + ", usingE=" + usingE+". timeUTC="+timeUTC);

		try {
			// 이름 중복 체크
			FolderVO folderVO = ezWebFolderService.getRootFolderId(companyId, "C", offset, tenantId);
			String pFolderId = folderVO.getFolderId();
			logger.debug("pFolderId=" + pFolderId);

			List<DuplicateInfoVO> dupliList = ezWebFolderService.getAllDuplicateInfo(folderName, pFolderId, offset, tenantId);
			if (dupliList.size() > 0) {
				throw new Exception("DUPLICATE_NAME");
			}
			
			JSONParser parser = new JSONParser();
			JSONArray jsonArr = (JSONArray) parser.parse(memberList);
			
			ObjectMapper objMapper = new ObjectMapper();
			List<Map<String, String>> memList = objMapper.readValue(jsonArr.toString(), objMapper.getTypeFactory().constructCollectionType(List.class, Map.class));

			applyId = ezWebFolderService_m.setWebFolderApplyHistory(primary, tenantId, companyId, folderName, content, memList, usingS, usingE, timeUTC);
		} catch (Exception e) {
			String errorMsg = orElse(e.getMessage(), "");
			if (errorMsg.equals("HISTORY_ERROR") || errorMsg.equals("HISTORY_MEMBER_ERROR") || errorMsg.equals("DUPLICATE_NAME")) {
				status = errorMsg;
			} else {
				status = "ERROR";
				logger.error(e.getMessage(), e);
			}
		}

		result.put("status", status);
		result.put("applyId", applyId);
		logger.debug("result=" + result.toJSONString());
		logger.debug("setApplyHistory ended.");
		
		return result;
	}
	
	/**
	 * 웹폴더 개설 신청 리스트
	 * param : companyId, tenantId, pageNum, pageListSize
	 * return : total size(전체 신청 개수), list<map<>>(개설신청리스트)
	 */
	@RequestMapping(value="/rest/ezwebfolder/getApplyHistoryList", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject getApplyHistoryList (HttpServletRequest request) {
		logger.debug("getApplyHistoryList Started.");
		
		JSONObject result = new JSONObject();
		String status = "OK";
		
		int totalSize = 0;
		JSONArray applicationHistoryArr = new JSONArray();

		String companyId = orElse(request.getParameter("companyId"), "");
		String offset = orElse(request.getParameter("offset"), "");
		int tenantId = Integer.parseInt(orElse(request.getParameter("tenantId"), "0"));
		int pageNum = Integer.parseInt(orElse(request.getParameter("pageNum"), "0")); // 현재 페이지 번호
		int pageListSize = Integer.parseInt(orElse(request.getParameter("pageListSize"), "0")); // 보여줄 리스트 개수
		logger.debug("tenantId=" + tenantId + ", companyId=" + companyId + ", pageNum=" + pageNum + ", pageListSize=" + pageListSize);

		try {
			totalSize = ezWebFolderService_m.getWebFolderApplyHistoryListCount(tenantId, companyId);
			
			int startList = (pageNum-1) * pageListSize;
			int endList = pageNum * pageListSize;
			logger.debug("startList=" + startList + ", endList=" + endList);
			
			List<Map<String, String>> historyListMap = ezWebFolderService_m.getWebFolderApplyHistoryList(tenantId, companyId, startList, endList,offset);
			for (Map<String, String> mm : historyListMap) {
				applicationHistoryArr.add(new JSONObject(mm));
			}
		} catch (Exception e) {
			status = "ERROR";
			logger.error(e.getMessage(), e);
		}

		result.put("status", status);
		result.put("totalSize", totalSize);
		result.put("historyList", applicationHistoryArr.toString());
		logger.debug("result=" + result.toJSONString());
		logger.debug("getApplyHistoryList ended.");
		
		return result;
	}
	
	/**
	 * 웹폴더 개설 신청 개별 조회
	 * param : applyId
	 * return : applyHistory(웹폴더명, 폴더타입, 개설사유, 신청일), applyHistoryMemberList(당시의 구성원이름+부서명, 구성원종류(user|dept..), 구성원 항목(신청자|담당자|구성원)
	 */
	@RequestMapping(value="/rest/ezwebfolder/getApplyHistory", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject getApplyHistory (HttpServletRequest request) {
		logger.debug("getApplyHistory Started.");
		
		JSONObject result = new JSONObject();
		String status = "OK";
		JSONObject appHistory = new JSONObject();
		JSONArray appHistoryMemberList = new JSONArray();
		
		String applyId = orElse(request.getParameter("applyId"), "");
		logger.debug("applyId=" + applyId);

		String offset = orElse(request.getParameter("offset"), "");

		try {
			Map<String, String> historyMap = ezWebFolderService_m.getWebFolderApplyHistory(applyId,offset);
			List<Map<String, String>> historyMemberListMap = ezWebFolderService_m.getWebFolderApplyHistoryMember(applyId);
			
			appHistory = historyMap == null ? appHistory : new JSONObject(historyMap);
			for (Map<String, String> mm : historyMemberListMap) {
				appHistoryMemberList.add(new JSONObject(mm));
			}
		} catch (Exception e) {
			status = "ERROR";
			logger.error(e.getMessage(), e);
		}

		result.put("status", status);
		result.put("appHistory", appHistory.toString());
		result.put("appHistoryMemberList", appHistoryMemberList.toString());
		logger.debug("result=" + result.toJSONString());
		logger.debug("getApplyHistory ended.");
		
		return result;
	}
	
	/**
	 * 웹폴더 개설 신청 승인
	 * param : applyId
	 * return : applicantId, folderName
	 */
	@RequestMapping(value="/rest/ezwebfolder/approvalToApplyForOpening", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject approvalToApplyForOpening (HttpServletRequest request) {
		logger.debug("approvalToApplyForOpening Started.");
		
		JSONObject result = new JSONObject();
		String status = "OK";
		String folderName = "";
		String applicantId = "";

		String serverName = orElse(request.getHeader("x-user-host"), "");
		String applyId = orElse(request.getParameter("applyId"), "");
		String userId = orElse(request.getParameter("userId"), "");
		logger.debug("applyId=" + applyId, ", userId=" + userId + ", serverName=" + serverName);

		LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
		int tenantId = userInfo.getTenantId();
		String userCompanyId = userInfo.getCompanyID();
		String offset = userInfo.getOffset();

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             =  commonUtil.getDateStringInUTC(formatter.format(date), offset, true);

		String companyId = "";
		
		try {
			Map<String, String> historyMap = ezWebFolderService_m.getWebFolderApplyHistory(applyId,offset);
			List<Map<String, String>> historyMemberListMap = ezWebFolderService_m.getWebFolderApplyHistoryMember(applyId);
			
			if (historyMap != null) {
				// 웹폴더 생성 정보
				folderName = commonUtil.cleanValueUnescape(historyMap.get("folderName"));
				companyId = historyMap.get("companyId");
				companyId = companyId.equals("") ? userCompanyId : companyId;
				
				// 관리자, 구성원 정보
				JSONArray memberListArr = new JSONArray();
				int msCnt = 0;
				int mCnt = 0;
				int cntTemp = 0;
				boolean folderMangerTemp = false;
				for (Map<String, String> mm : historyMemberListMap) {
					String memItem = mm.get("memberItem");
					
					if ("a".equalsIgnoreCase(memItem) ) {
						applicantId = mm.get("memberId");
					} else {
						if ("ms".equals(memItem)) {
							folderMangerTemp = true;
							cntTemp = msCnt;
							msCnt++;
						} else {
							folderMangerTemp = false;
							cntTemp = mCnt;
							mCnt++;
						}
						
						JSONObject obj = new JSONObject();
						obj.put("userId", mm.get("memberId"));
						obj.put("userName", mm.get("memberName"));
						obj.put("userType", mm.get("memberType"));
						obj.put("subdeptPermitted", false);
						obj.put("folderManager", folderMangerTemp);
						obj.put("sn", cntTemp);
						
						memberListArr.add(obj);
					}
				}
				
				// 웹폴더 생성
				FolderVO folderVO = ezWebFolderService.getRootFolderId(companyId, "C", offset, tenantId);
				String pFolderId = folderVO.getFolderId();
				logger.debug("pFolderId=" + pFolderId);
				
				Map<String, Object> serviceResult =
						ezWebFolderAdminService.addCompanyFolder(pFolderId, memberListArr.toString(), folderName, folderName, userInfo);
				String addFolderStatus = (String) serviceResult.get("status");
				int addFolderCode = (int) serviceResult.get("code");
				logger.debug("addFolderStatus=" + addFolderStatus + ", addFolderCode=" + addFolderCode);
				
				if (addFolderStatus.equalsIgnoreCase("OK") && addFolderCode == 0) {
					// 승인
					ezWebFolderService_m.changeWebFolderAppliApprovalStatus(applyId, "Y",timeUTC);
				} else {
					status = addFolderCode == 8 ? "DUPLICATE_FOLDER_NAME" : "ADD_ERROR";
				}
			}
		} catch (Exception e) {
			status = "ERROR";
			logger.error(e.getMessage(), e);
		}

		result.put("status", status);
		result.put("applicantId", applicantId);
		result.put("folderName", folderName);
		logger.debug("result=" + result.toJSONString());
		logger.debug("approvalToApplyForOpening ended.");
		
		return result;
	}
	
	/**
	 * 웹폴더 개설 신청 거부
	 * param : applyId
	 * return : applicantId, folderName
	 */
	@RequestMapping(value="/rest/ezwebfolder/RefuseToApplyForOpening", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject RefuseToApplyForOpening (HttpServletRequest request) {
		logger.debug("RefuseToApplyForOpening Started.");
		
		JSONObject result = new JSONObject();
		String status = "OK";
		String folderName = "";
		String applicantId = "";

		String applyId = orElse(request.getParameter("applyId"), "");
		logger.debug("applyId=" + applyId);

		String offset = orElse(request.getParameter("offset"), "");

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             =  commonUtil.getDateStringInUTC(formatter.format(date), offset, true);

		try {
			Map<String, String> historyMap = ezWebFolderService_m.getWebFolderApplyHistory(applyId,offset);
			List<Map<String, String>> historyMemberListMap = ezWebFolderService_m.getWebFolderApplyHistoryMember(applyId);
			
			if (historyMap != null) {
				folderName = historyMap.get("folderName");
				
				for (Map<String, String> mm : historyMemberListMap) {
					if ("a".equalsIgnoreCase(mm.get("memberItem")) ) {
						applicantId = mm.get("memberId");
						break;
					}
				}
				
				// 승인 거부
				ezWebFolderService_m.changeWebFolderAppliApprovalStatus(applyId, "N", timeUTC);
			}
		} catch (Exception e) {
			status = "ERROR";
			logger.error(e.getMessage(), e);
		}

		result.put("status", status);
		result.put("applicantId", applicantId);
		result.put("folderName", folderName);
		logger.debug("result=" + result.toJSONString());
		logger.debug("RefuseToApplyForOpening ended.");
		
		return result;
	}
	
}
