package egovframework.ezEKP.ezWebFolder.web;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.TrashCanVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.ShareVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzWebFolderGWController_m {

	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderGWController_m.class);
	
	@Resource(name = "EzWebFolderService_m")
	private EzWebFolderService_m ezWebFolderService;
	
	@Autowired
	private EzWebFolderService ezWebFolderService2;
	
	@Autowired
	private MOptionService mOptionService ;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzWebFolderService_m ezWebFolderService_m;
	
	@Autowired
	private EzWebFolderService_y ezWebFolderService_y;
	
	/**
	 * 공유한 폴더 및 파일 조회
	 */
	@RequestMapping(value="/ezwebfolder/users/{userId}/sharing-list", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSharingList(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("getSharingList started.");
		
		String serverName 	= request.getHeader("host-name") 		!= null ? request.getHeader("host-name")		: "";
		String fileType 	= request.getParameter("fileType")		!= null ? request.getParameter("fileType")		: "";
		String pageNum 		= request.getParameter("pageNum")		!= null ? request.getParameter("pageNum")		: "1";
		String pageSize 	= request.getParameter("pageSize")		!= null ? request.getParameter("pageSize")		: "0";
		String fileName 	= request.getParameter("fileName")		!= null ? request.getParameter("fileName")		: "";
		String createName 	= request.getParameter("createName")	!= null ? request.getParameter("createName")	: "";
		String fileExt 		= request.getParameter("fileExt")		!= null ? request.getParameter("fileExt")		: "";
		String startDate 	= request.getParameter("startDate")		!= null ? request.getParameter("startDate")		: "";
		String endDate 		= request.getParameter("endDate")		!= null ? request.getParameter("endDate")		: "";
		
		logger.debug("userId: " + userId + " || serverName: " + serverName);
		logger.debug("fileType: " + fileType + " || pageNum: " + pageNum + " || pageSize: " + pageSize + " || fileName: " + fileName + " || createName: " + createName
				 + " || fileExt: " + fileExt + " || startDate: " + startDate + " || endDate: " + endDate);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (userId.equals("") || serverName.equals("")) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.debug("parameter error. getSharingList ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			String lang = common.getLang();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			
			int pageSizeInt = Integer.parseInt(pageSize);
			int pageNumInt = Integer.parseInt(pageNum);
			
			if (pageSizeInt == 0) {
				pageSizeInt = ezWebFolderService_y.getUsrListCount(tenantId, userId);
			}
			
			int startPoint = (pageNumInt - 1) * pageSizeInt;
			
			List<ShareVO> list = ezWebFolderService_m.getSharingList(userId, userInfo.getPrimary(), offset, startPoint, pageSizeInt, userInfo.getTenantId());
			Map<String, Integer> countInfo = ezWebFolderService_m.getSharingCount(userId, userInfo.getPrimary(), offset, pageSizeInt, userInfo.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", list);
			result.putAll(countInfo);
		} 
		catch (Exception e) {
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("getSharingList ended.");
		return result;
	}
	
	/**
	 * 공유받은 폴더 및 파일 조회
	 */
	@RequestMapping(value="/ezwebfolder/users/{userId}/shared-list", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSharedList(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("getSharedList started.");
		
		String serverName 	= request.getHeader("host-name") 		!= null ? request.getHeader("host-name")		: "";
		String fileType 	= request.getParameter("fileType")		!= null ? request.getParameter("fileType")		: "";
		String pageNum 		= request.getParameter("pageNum")		!= null ? request.getParameter("pageNum")		: "1";
		String pageSize 	= request.getParameter("pageSize")		!= null ? request.getParameter("pageSize")		: "0";
		String fileName 	= request.getParameter("fileName")		!= null ? request.getParameter("fileName")		: "";
		String createName 	= request.getParameter("createName")	!= null ? request.getParameter("createName")	: "";
		String fileExt 		= request.getParameter("fileExt")		!= null ? request.getParameter("fileExt")		: "";
		String startDate 	= request.getParameter("startDate")		!= null ? request.getParameter("startDate")		: "";
		String endDate 		= request.getParameter("endDate")		!= null ? request.getParameter("endDate")		: "";
		
		logger.debug("userId: " + userId + " || serverName: " + serverName);
		logger.debug("fileType: " + fileType + " || pageNum: " + pageNum + " || pageSize: " + pageSize + " || fileName: " + fileName + " || createName: " + createName
				 + " || fileExt: " + fileExt + " || startDate: " + startDate + " || endDate: " + endDate);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (userId.equals("") || serverName.equals("")) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.debug("parameter error. getSharedList ended.");
			return result;
		}
		
		try {
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			String lang = common.getLang();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			
			int pageSizeInt = Integer.parseInt(pageSize);
			int pageNumInt = Integer.parseInt(pageNum);
			
			if (pageSizeInt == 0) {
				pageSizeInt = ezWebFolderService_y.getUsrListCount(tenantId, userId);
			}
			
			int startPoint = (pageNumInt - 1) * pageSizeInt;
			
			List<ShareVO> list = ezWebFolderService_m.getSharedList(userId, userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getPrimary(), offset, startPoint, pageSizeInt, userInfo.getTenantId());
			Map<String, Integer> countInfo = ezWebFolderService_m.getSharedCount(userId, userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getPrimary(), offset, pageSizeInt, userInfo.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", list);
			result.putAll(countInfo);
			
		} 
		catch (Exception e) {
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("getSharedList ended.");
		return result;
	}
	
	/*
	 * 공유 폴더 및 파일 수정
	 * 
	 * @author 강민수79
	 * @date 2018.02.21.
	 * @param tenantId
	 * @param companyId
	 * @param creatId
	 * @param folderFileId
	 * @param folderFileType
	 * @param userList
	 * @return JSONObject
	 */
	@RequestMapping(value="/ezwebfolder/folder-files/{folderFileId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateShareUser(@PathVariable String folderFileId, HttpServletRequest request) throws Exception {
		Map map = new HashMap<String,Object>();
		String companyId = request.getParameter("companyId");
		String createId = request.getParameter("createId");
		String userList = request.getParameter("userList");
		String folderFileType = request.getParameter("folderFileType");
		int tenantId = Integer.parseInt(request.getParameter("tenantId"));
		
		map.put("folderFileId", folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("companyId", companyId);
		map.put("createId", createId);
		map.put("tenantId", tenantId);
		
		JSONParser jparser = new JSONParser();
		Object obj = jparser.parse(userList);
		JSONArray jarray = (JSONArray) obj;
		
		ezWebFolderService_m.delShare(companyId, folderFileId, folderFileType, createId, tenantId);
		
		for (int i = 0; i < jarray.size(); i++) {
			
			JSONObject jobj = (JSONObject) jarray.get(i);
		
			ezWebFolderService_m.insertShare(ezWebFolderService_m.getShareSeq(tenantId), companyId, (String)jobj.get("userId"), (String)jobj.get("userType"), folderFileId, folderFileType, createId, tenantId);
			
		}
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}
	
	/*
	 * 즐겨찾기 대상 조회
	 * 
	 * @author 강민수79
	 * @date 2018.02.22.
	 * @param userId
	 * @param tenantId
	 * @param companyId
	 * @return JSONObject
	 */
	@RequestMapping(value="/ezwebfolder/users/{userId}/favorites", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFavoriteList(@PathVariable String userId, HttpServletRequest request) {	
		
		String companyId = request.getParameter("companyId");
		int tenantId = Integer.parseInt(request.getParameter("tenantId"));	
		
		logger.debug("userId: " + userId);
		
		JSONObject result = new JSONObject();
		
		try {			
			
						
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
			
		} 
		catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		
		}
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/{userId}/getTrashCanList", method=RequestMethod.POST, produces ="application/json;charset=utf-8")
	public JSONObject getTrashCanList (@PathVariable String userId, HttpServletRequest request, Locale locale)  {
		String offset = request.getParameter("offset") !=null ? request.getParameter("offset") : "";
		int tenantId = request.getParameter("tenantId") !=null ? Integer.parseInt(request.getParameter("tenantId")) : 0;
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";

		logger.debug("getTrashCanList Started.");
		logger.debug("userId=" + userId + ",offset=" + offset + ",tenantId=" + tenantId + ",serverName=" + serverName);
		
		JSONObject result = new JSONObject();
		
		if (userId.equals("") || offset.equals("") || userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", "1");
			return result;
		}

		try {
			List<TrashCanVO> trashCanList = null;
			JSONObject trashCanResult = ezWebFolderService.getTrashCanList(userId, offset, tenantId);
			int fileCnt = 0;
			int folderCnt = 0;
			
			if (trashCanResult != null) {
				trashCanList = (List<TrashCanVO>) trashCanResult.get("trashCanList");
				fileCnt = (int) trashCanResult.get("fileCnt");
				folderCnt = (int) trashCanResult.get("folderCnt");
			}
			
			String trashCanPath = "";
			
			if (trashCanList != null) {
				for (TrashCanVO trashCan : trashCanList) {
					trashCanPath = trashCan.getTrashCanPath().substring(1);
					trashCanPath = getFolderPath(trashCanPath.split("\\|"), offset, tenantId);
					
					// is folder
					if ("folder".equalsIgnoreCase(trashCan.getTrashCanExt())) {
						// cut end slash
						trashCanPath = trashCanPath.substring(0, trashCanPath.length() - 1);
					} else {
						trashCanPath += trashCan.getTrashCanName();
					}
					
					trashCan.setTrashCanPath(trashCanPath);
				}
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", trashCanList);
			result.put("fileCnt", fileCnt);
			result.put("folderCnt", folderCnt);
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
	
	private String getFolderPath(String[] paths, String offset, int tenantId) throws Exception {
		StringBuilder result = new StringBuilder("/");
		
		for (String path : paths) {
			FolderVO parentFolder = ezWebFolderService2.getFolderByFolderId(path, offset, tenantId);
			result.append(parentFolder.getFolderName1()).append("/");
		}

		return result.toString();
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezwebfolder/file-permanent-delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject filePermanetDelete(Locale locale, HttpServletRequest request) {
		String offset       = request.getParameter("offset")   != null ? request.getParameter("offset")   : "";
		String fileList   = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String folderList   = request.getParameter("folderList") != null ? request.getParameter("folderList") : "";
		String userId       = request.getParameter("userId")       != null ? request.getParameter("userId")   	  : "";
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String lang         = request.getParameter("lang")     != null ? request.getParameter("lang")     : "";
		
		logger.debug("filePermanetDelete Started.");
		logger.debug("offset=" + offset + ",fileList=" + fileList);
		logger.debug("userId=" + userId + ",serverName=" + serverName);
		logger.debug("lang=" + lang + ",folderList=" + folderList);
		
		String[] fileIDList = fileList.split(",");
		String[] folderIDList = folderList.split(",");
		String realPath = request.getServletContext().getRealPath("");
		JSONObject result   = new JSONObject();
		
		if (fileIDList.length == 0 || serverName.equals("") || offset.equals("") || userId.equals("") || lang.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			ezWebFolderService.permanetDeleteSelectedFiles(fileIDList, folderIDList, userInfo, realPath);
			
			result.put("status", "ok");
			result.put("code", "0");
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("filePermanetDelete ended");
		return result;
	}
}
