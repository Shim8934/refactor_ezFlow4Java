package egovframework.ezEKP.ezWebFolder.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.FavoriteVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SearchVO;
import egovframework.ezEKP.ezWebFolder.vo.ShareVO;
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
	private CommonUtil commonUtil;
	
	/**
	 * 공유한 리스트 조회
	 *
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId}/sharing", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSharingList(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("getSharingList started.");
		
		String serverName 	= orElse(request.getHeader("x-user-host"), "");
		String pageNum 		= orElse(request.getHeader("pageNum"), "1");
		String pageSize 	= orElse(request.getHeader("pageSize"), "0");
		
		SearchVO searchInfo = new SearchVO();
		searchInfo.setSearchExt(orElse(request.getParameter("searchExt"), ""));
		searchInfo.setSearchFileName(orElse(request.getParameter("searchFileName"), ""));
		searchInfo.setSearchCreateName(orElse(request.getParameter("searchCreatorName"), ""));
		searchInfo.setSearchFileType(orElse(request.getParameter("searchFileType"), ""));
		searchInfo.setSearchStartDate(orElse(request.getParameter("searchStartDate"), ""));
		searchInfo.setSearchEndDate(orElse(request.getParameter("searchEndDate"), ""));
		
		logger.debug("serverName: " + serverName + " || userId: " + userId + " || pageNum: " + pageNum + " || pageSize: " + pageSize);
		logger.debug("searchInfo: " + searchInfo);
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (serverName.equals("") || userId.equals("")) {
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
			String lang   = common.getLang();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			
			int pageSizeInt  = Integer.parseInt(pageSize);
			int pageNumInt   = Integer.parseInt(pageNum);
			
			if (pageSizeInt == 0) {
				pageSizeInt = ezWebFolderService_y.getUsrListCount(tenantId, userId);
			}
			
			int startPoint = (pageNumInt - 1) * pageSizeInt;
			
			List<ShareVO> list = ezWebFolderService_m.getSharingList(userId, userInfo.getPrimary(), offset, startPoint, pageSizeInt, searchInfo, tenantId);
			Map<String, Long> countInfo = ezWebFolderService_m.getSharingCount(userId, userInfo.getPrimary(), offset, pageSizeInt, searchInfo, tenantId);
			
			data.put("list", list);
			data.putAll(countInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} 
		catch (Exception e) {
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getSharingList ended.");
		return result;
	}
	
	/**
	 * 공유받은 리스트 조회
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId}/shared", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSharedList(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("getSharedList started.");
		
		String serverName 	= orElse(request.getHeader("x-user-host"), "");
		String pageNum 		= orElse(request.getHeader("pageNum"), "1");
		String pageSize 	= orElse(request.getHeader("pageSize"), "0");
		
		SearchVO searchInfo = new SearchVO();
		searchInfo.setSearchExt(orElse(request.getParameter("searchExt"), ""));
		searchInfo.setSearchFileName(orElse(request.getParameter("searchFileName"), ""));
		searchInfo.setSearchCreateName(orElse(request.getParameter("searchCreatorName"), ""));
		searchInfo.setSearchFileType(orElse(request.getParameter("searchFileType"), ""));
		searchInfo.setSearchStartDate(orElse(request.getParameter("searchStartDate"), ""));
		searchInfo.setSearchEndDate(orElse(request.getParameter("searchEndDate"), ""));
		
		logger.debug("serverName: " + serverName + " || userId: " + userId + " || pageNum: " + pageNum + " || pageSize: " + pageSize);
		logger.debug("searchInfo: " + searchInfo);
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (serverName.equals("") || userId.equals("")) {
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
			String lang   = common.getLang();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			
			int pageSizeInt  = Integer.parseInt(pageSize);
			int pageNumInt   = Integer.parseInt(pageNum);
			
			if (pageSizeInt == 0) {
				pageSizeInt = ezWebFolderService_y.getUsrListCount(tenantId, userId);
			}
			
			int startPoint = (pageNumInt - 1) * pageSizeInt;
			
			List<ShareVO> list = ezWebFolderService_m.getSharedList(userId, userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getPrimary(), offset, startPoint, pageSizeInt, searchInfo, tenantId);
			Map<String, Long> countInfo = ezWebFolderService_m.getSharedCount(userId, userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getPrimary(), offset, pageSizeInt, searchInfo, tenantId);
			
			data.put("list", list);
			data.putAll(countInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} 
		catch (Exception e) {
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getSharedList ended.");
		return result;
	}
	
	/**
	 * 공유 추가
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId}/sharing", method=RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addShare(@PathVariable String userId, HttpServletRequest request, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("addShare started.");
		
		String serverName     = orElse(request.getHeader("x-user-host"), "");
		String folderFileId   = orElse((String) jsonObject.get("folderFileId"), "");
		String folderFileType = orElse((String) jsonObject.get("folderFileType"), "");
		List<Map<String, String>> userList = (List<Map<String, String>>) jsonObject.get("userList");
		
		logger.debug("serverName: " + serverName + " || userId: " + userId + " || folderFileId: " + folderFileId + " || folderFileType: " + folderFileType);
		logger.debug("userList:" + userList);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (serverName.equals("") || userId.equals("") || folderFileId.equals("") || folderFileType.equals("") || userList == null || userList.size() == 0) {
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
			
			ezWebFolderService_m.insertShare(userId, folderFileId, folderFileType, userList, offset, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("addShare ended.");
		return result;
	}
	
	/**
	 * 공유 수정
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId}/sharing/{shareId}", method=RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateShare(@PathVariable String userId, @PathVariable String shareId, HttpServletRequest request, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("updateShare started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		List<Map<String, String>> userList = (List<Map<String, String>>) jsonObject.get("userList");
		logger.debug("serverName: " + serverName + " || userId: " + userId + " || shareId: " + shareId);
		logger.debug("userList:" + userList);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (serverName.equals("") || userId.equals("") || shareId.equals("") || userList == null || userList.size() == 0) {
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
			
			ezWebFolderService_m.updateShare(shareId, userId, userList, offset, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("updateShare ended.");
		return result;
	}
	
	/**
	 * 공유 삭제
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId}/sharing/{shareId}", method=RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteShare(@PathVariable String userId, @PathVariable String shareId, HttpServletRequest request) throws Exception {
		logger.debug("deleteShare started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		logger.debug("serverName: " + serverName + " || userId: " + userId + " || shareId: " + shareId);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (serverName.equals("") || userId.equals("") || shareId.equals("")) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("parameter error. deleteShare ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			
			ezWebFolderService_m.deleteShare(shareId, userId, offset, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("deleteShare ended.");
		return result;
	}
	
	/**
	 * 공유 숨김 리스트 조회
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId}/shared-hide", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getHiddenSharedList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("getHiddenSharedList started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		String pageNum 		= orElse(request.getHeader("pageNum"), "1");
		String pageSize 	= orElse(request.getHeader("pageSize"), "0");
		logger.debug("serverName: " + serverName + " || userId: " + userId + " || pageNum: " + pageNum + " || pageSize: " + pageSize);
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (userId.equals("") || serverName.equals("")) {
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
			String lang   = common.getLang();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			
			int pageSizeInt  = Integer.parseInt(pageSize);
			int pageNumInt   = Integer.parseInt(pageNum);
			
			if (pageSizeInt == 0) {
				pageSizeInt = ezWebFolderService_y.getUsrListCount(tenantId, userId);
			}
			
			int startPoint = (pageNumInt - 1) * pageSizeInt;
			
			List<ShareVO> list = ezWebFolderService_m.getHiddenSharedList(userId, userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getPrimary(), offset, startPoint, pageSizeInt, tenantId);
			Map<String, Long> countInfo = ezWebFolderService_m.getHiddenSharedCount(userId, userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getPrimary(), offset, pageSizeInt, tenantId);
			
			data.put("list", list);
			data.putAll(countInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} 
		catch (Exception e) {
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getHiddenSharedList ended.");
		return result;
	}
	
	/**
	 * 공유 숨김
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId}/shared-hide/{shareId}", method=RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject hideShare(@PathVariable String userId, @PathVariable String shareId, HttpServletRequest request) throws Exception {
		logger.debug("hideShare started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		logger.debug("serverName: " + serverName + " || userId: " + userId + " || shareId: " + shareId);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (serverName.equals("") || userId.equals("") || shareId.equals("")) {
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
			
			ezWebFolderService_m.hideShare(shareId, userId, offset, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("hideShare ended.");
		return result;
	}
	
	/**
	 * 공유 숨김 취소
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId}/shared-hide/{shareId}", method=RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject showShare(@PathVariable String userId, @PathVariable String shareId, HttpServletRequest request) throws Exception {
		logger.debug("showShare started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		logger.debug("serverName: " + serverName + " || userId: " + userId + " || shareId: " + shareId);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (serverName.equals("") || userId.equals("") || shareId.equals("")) {
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
			
			ezWebFolderService_m.showShare(shareId, userId, offset, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			
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
	@RequestMapping(value = "/rest/ezwebfolder/users/{userId}/favorites", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFavoriteList(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W WEBFOLDER [GET /rest/ezwebfolder/users/{userId}/favorites] started.");
		
		String serverName = request.getHeader("x-user-host");
		int startIndex = Integer.parseInt(orElse(request.getParameter("startIndex"), "0"));
		int listCount = Integer.parseInt(orElse(request.getParameter("listCount"), "0"));
		
		SearchVO searchInfo = new SearchVO();
		searchInfo.setSearchExt(orElse(request.getParameter("searchExt"), ""));
		searchInfo.setSearchFileName(orElse(request.getParameter("searchFileName"), ""));
		searchInfo.setSearchCreateName(orElse(request.getParameter("searchCreatorName"), ""));
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
			
			// setup list count
			{
				// list count
				int userListCount = ezWebFolderService_y.getUsrListCount(tenantId, userId);
				
				if (listCount == 0) {
					listCount = userListCount;
				}
				
				ezWebFolderService_y.insertEnv(userId, tenantId, listCount);
			}
			
			List<FavoriteVO> favoriteFiles = ezWebFolderService_m.getFavorites(userId, primary, offset, tenantId, searchInfo, startIndex, listCount);
			String targetPath;
			
			for (FavoriteVO favoriteFile : favoriteFiles) {
				targetPath = favoriteFile.getTargetPath().substring(1);
				targetPath = getFolderPath(targetPath.split("\\|"), offset, primary, tenantId);
				
				// is folder
				if ("D".equalsIgnoreCase(favoriteFile.getTargetType())) {
					// cut end slash
					targetPath = targetPath.substring(0, targetPath.length() - 1);
				} else {
					targetPath += favoriteFile.getTargetName();
				}
				
				favoriteFile.setTargetPath(targetPath);
			}
			
			Map<String, Integer> favoriteCountMap = ezWebFolderService_m.getFavoriteCount(userId, offset, tenantId, searchInfo);
			JSONObject data = new JSONObject();
			
			data.put("totalCount", favoriteCountMap.get("totalCount"));
			data.put("folderCount", favoriteCountMap.get("folderCount"));
			data.put("fileCount", favoriteCountMap.get("fileCount"));
			data.put("listCount", listCount);
			
			data.put("targetList", favoriteFiles);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
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
	@RequestMapping(value = "/rest/ezwebfolder/users/{userId}/favorite", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addFavorite(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W WEBFOLDER [POST /rest/ezwebfolder/users/{userId}/favorite] started.");
		
		String serverName = request.getHeader("x-user-host");
		String targetId = request.getParameter("targetId");
		String targetType = request.getParameter("targetType");
		
		JSONObject result = new JSONObject();

		
		if (containsNull(serverName, userId)) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("G/W WEBFOLDER parameter error. [POST /rest/ezwebfolder/users/{userId}/favorite] ended.");
			return result;
		}

		try {
			MCommonVO userInfo = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = userInfo.getTenantId();
			String offset = userInfo.getOffSet();
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String createDate = commonUtil.getDateStringInUTC(format.format(new Date()), offset, true);
			
			if(ezWebFolderService_m.isExistsFavorite(userId, targetId, targetType, tenantId)) {
				result.put("status", "error");
				result.put("code", 2);
			} else {
				ezWebFolderService_m.addFavorite(userId, targetId, targetType, createDate, tenantId);
				result.put("status", "ok");
				result.put("code", 0);
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
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
	@RequestMapping(value = "/rest/ezwebfolder/users/{userId}/favorite", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteFavorite(@PathVariable String userId, HttpServletRequest request, @RequestBody JSONObject jsonObject) {
		logger.debug("G/W WEBFOLDER [DELETE /rest/ezwebfolder/users/{userId}/favorite] started.");

		String serverName = request.getHeader("x-user-host");
		String targetId = (String) jsonObject.get("targetId");
		String targetType = (String) jsonObject.get("targetType");

		JSONObject result = new JSONObject();

		if (containsNull(serverName, userId)) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("G/W WEBFOLDER parameter error. [DELETE /rest/ezwebfolder/users/{userId}/favorite] ended.");
			return result;
		}
		
		try {
			MCommonVO userInfo = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = userInfo.getTenantId();
			
			if(ezWebFolderService_m.isExistsFavorite(userId, targetId, targetType, tenantId)) {
				ezWebFolderService_m.deleteFavorite(userId, targetId, targetType, tenantId);
				result.put("status", "ok");
				result.put("code", 0);
			} else {
				result.put("status", "error");
				result.put("code", 2);
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}

		logger.debug(String.format("result: %s", result.toJSONString()));
		logger.debug("G/W WEBFOLDER [DELETE /rest/ezwebfolder/users/{userId}/favorite] ended.");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/{userId}/getTrashCanList", method=RequestMethod.POST, produces ="application/json;charset=utf-8")
	public JSONObject getTrashCanList (@PathVariable String userId, HttpServletRequest request, Locale locale) {
		String offset =  orElse(request.getParameter("offset"), "");
		int tenantId = Integer.parseInt(orElse(request.getParameter("tenantId"), "0"));
		String serverName =  orElse(request.getHeader("host-name"), "");
		
		int listCount 	        = Integer.parseInt(orElse(request.getParameter("listCount"), "10"));
		int currPage 	        = Integer.parseInt(orElse(request.getParameter("currPage"), "1"));
		
		
		String searchExt 		= orElse(request.getParameter("searchExt"), "" );
		String searchFileName 	= orElse(request.getParameter("searchFileName"), "");
		String searchCreateName = orElse(request.getParameter("searchCreateName"), "");
		String searchFileType   = orElse(request.getParameter("searchFileType"), "");
		String endrollStartDate = orElse(request.getParameter("enrollStartDate"), "");
		String endrollEndDate 	= orElse(request.getParameter("enrollEndDate"), "");
		String delStartDate 	= orElse(request.getParameter("delStartDate"), "");
		String delEndDate 		= orElse(request.getParameter("delEndDate"), "");
		
		// TODO primary 수정
		String primary;
		
		try {
			primary = mOptionService.commonInfo(serverName, userId).getPrimary();
		} catch (Exception ex) {
			primary = "1";
		}

		logger.debug("getTrashCanList Started.");
		logger.debug("userId=" + userId + ",offset=" + offset + ",tenantId=" + tenantId + ",serverName=" + serverName);
		logger.debug("currPage=" + currPage);
		logger.debug("listCount=" + listCount);
		logger.debug("searchExt=" + searchExt + ",searchFileName=" + searchFileName + ",searchCreateName=" + searchCreateName + ",searchFileType=" + searchFileType);
		logger.debug("endrollStartDate=" + endrollStartDate + ",endrollEndDate=" + delStartDate + ",delStartDate=" + delStartDate + ",delEndDate=" + delEndDate);
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		if (userId.equals("") || offset.equals("") || userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", "1");
			return result;
		}

		try {
			List<TrashCanVO> trashCanList = null;
			JSONObject resultList = ezWebFolderService_m.getTrashCanList(userId, offset, tenantId, currPage, listCount,
										searchExt, searchFileName, searchCreateName, searchFileType, endrollStartDate, endrollEndDate, delStartDate, delEndDate);
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
					trashCanPath = trashCan.getTrashCanPath().substring(1);
					
					trashCanPath = getFolderPath(trashCanPath.split("\\|"), offset, primary, tenantId);
					
					// is folder
					if ("folder".equalsIgnoreCase(trashCan.getTrashCanExt())) {
						trashCanPath = trashCanPath.substring(0, trashCanPath.length() - 1);
					} else {
						trashCanPath += trashCan.getTrashCanName();
					}
					
					trashCan.setTrashCanPath(trashCanPath);
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("result=" + result);
		logger.debug("getTrashCanList ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezwebfolder/file-permanent-delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject filePermanetDelete(Locale locale, HttpServletRequest request) {
		String offset       = orElse(request.getParameter("offset"), "");
		String fileList     = orElse(request.getParameter("fileList"), "");
		String folderList   = orElse(request.getParameter("folderList"), "");
		String userId       = orElse(request.getParameter("userId"), "");
		String serverName   = orElse(request.getHeader("host-name"), "");
		String lang         = orElse(request.getParameter("lang"), "");
		
		logger.debug("filePermanetDelete Started.");
		logger.debug("userId=" + userId  + ",offset=" + offset + ",lang=" + lang + ",offset=" + offset + ",serverName=" + serverName);
		logger.debug("fileList=" + fileList + ",folderList=" + folderList);
		
		String[] fileIDList = fileList.split(",");
		String[] folderIDList = folderList.split(",");
		String realPath = request.getServletContext().getRealPath("");
		JSONObject result   = new JSONObject();
		
		if (fileIDList.length == 0 & folderIDList.length == 0|| serverName.equals("") || offset.equals("") || userId.equals("") || lang.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			ezWebFolderService_m.permanetDeleteSelectedFiles(fileIDList, folderIDList, userInfo, realPath);
			
			result.put("status", "ok");
			result.put("code", "0");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("filePermanetDelete ended");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/restore-trashCan", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject restoreTrashCan(Locale locale, HttpServletRequest request) {
		int tenantId = Integer.parseInt(orElse(request.getParameter("tenantId"), "0"));
		String offset= orElse(request.getParameter("offset"), "");
		String companyId = orElse(request.getParameter("companyId"), "");
		String userId = orElse(request.getParameter("userId"), "");
		String serverName   = orElse(request.getHeader("host-name"), "");
		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");

		logger.debug("restoreTrashCan Started.");
		logger.debug("tenantId=" + tenantId + ",userId=" + userId + ",serverName=" + serverName);
		logger.debug("offset=" + offset + ",companyId=" + companyId);
		logger.debug("fileList=" + fileList + ",folderList=" + folderList);
		
		String[] fileIDList = fileList.split(",");
		String[] folderIDList = folderList.split(",");
		int retoreSize = fileIDList.length + folderIDList.length;
		JSONObject result = new JSONObject();
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             =  commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		if (fileIDList.length == 0 & folderIDList.length == 0|| serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", "1");
			return result;
		}
		
		for (int i = 0 ; i< retoreSize ; i++) {
			try {
				
				ezWebFolderService_m.restoreTrashCan(fileIDList, folderIDList, tenantId, userId, offset, companyId, timeUTC);
				
				result.put("status", "ok");
				result.put("code", "0");
			} catch (Exception e) {
				e.printStackTrace();
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t314", locale));
				result.put("status", "error");
				result.put("code", "1");
			}
		}
		
		logger.debug("restoreTrashCan ended");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/move-TrashCan", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject moveTrashCan(Locale locale, HttpServletRequest request) {
		int tenantId = Integer.parseInt(orElse(request.getParameter("tenantId"), "0"));
		String offset= orElse(request.getParameter("offset"), "");
		String lang = orElse(request.getParameter("lang"), "");
		String userId = orElse(request.getParameter("userId"), "");
		String folderId = orElse(request.getParameter("folderId"), "");
		String serverName   = orElse(request.getHeader("host-name"), "");
		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");
		
		logger.debug("moveTrashCan Started.");
		logger.debug("tenantId=" + tenantId + ",userId=" + userId + ",folderId=" + folderId);
		logger.debug("serverName=" + serverName + ",offset=" + offset + ",companyId=" + lang);
		logger.debug("fileList=" + fileList + ",folderList=" + folderList);
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             =  commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		String[] fileIDList = fileList.split(",");
		String[] folderIDList = folderList.split(",");
		JSONObject result = new JSONObject();
		
		if (fileIDList.length == 0 & folderIDList.length == 0|| serverName.equals("") || userId.equals("") || folderId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", "1");
			return result;
		}
		
		try {
			MCommonVO user = mOptionService.commonInfoWeb(serverName, userId);
			ezWebFolderService_m.moveTrashCan(fileIDList, folderIDList, folderId ,tenantId, userId, offset, user.getCompanyId(), user.getUserName(), user.getUserName2(), timeUTC);
			
			result.put("status", "ok");
			result.put("code", "0");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t314", locale));
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("moveTrashCan ended");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/getUserListCount", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject getUserListCount (HttpServletRequest request) {
		int tenantId = Integer.parseInt(orElse(request.getParameter("tenantId"), "0"));
		String userId = orElse(request.getParameter("userId"), "");
		
		logger.debug("getUserListCount Started.");
		logger.debug("tenantId=" + tenantId + ",userId=" + userId);

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
	
	private String getFolderPath(String[] paths, String offset, String primaryLang, int tenantId) throws Exception {
		StringBuilder result = new StringBuilder();
		String folderName;
		
		for (String path : paths) {
			FolderVO parentFolder = ezWebFolderService.getFolderByFolderId(path, offset, tenantId);
			folderName = primaryLang.equals("2") ? parentFolder.getFolderName2() : parentFolder.getFolderName1();
			
			result.append(folderName).append("/");
		}

		return result.toString();
	}
}
