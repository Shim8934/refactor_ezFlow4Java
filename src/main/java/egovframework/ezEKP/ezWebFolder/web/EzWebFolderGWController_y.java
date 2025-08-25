package egovframework.ezEKP.ezWebFolder.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.tomcat.util.codec.binary.Base64;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.util.EzWebfolderUtil;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO;
import egovframework.ezEKP.ezWebFolder.vo.FileHistoryVO;
import egovframework.ezEKP.ezWebFolder.vo.FileUploadVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderTreeVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;


@RestController
public class EzWebFolderGWController_y extends EzFileMngUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderGWController_y.class);
	
	@Autowired
	private EzWebFolderAdminService ezWebFolderAdminService;
	
	@Autowired
	private EzWebFolderService ezWebFolderService;
	
	@Autowired
	private EzWebFolderService_y service;
	
	@Autowired
	private MOptionService mOptionService;
	
	@Autowired
	private EzWebFolderService_m ezWebFolderService_m;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties globals;
	
	@Autowired
	private EzWebfolderUtil webfolderUtil;
	
	@Autowired
	private LoginService loginService;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	/**
	 * root 폴더 존재 여부 확인 - 존재하지 않을 경우 생성
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/checkRootFolder", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkRootFolder(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("checkRootFolder started.");
		
		String serverName = orElse(request.getHeader("x-user-host"), "");
		logger.debug("userId: " + userId + " || serverName: " + serverName);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (userId.equals("") || serverName.equals("")) {
			result.put("status", "error");
			result.put("code", 1);
			
			logger.debug("parameter error. checkRootFolder ended.");
			return result;
		}
		
		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			List<Map<String, String>> permissionIdList = ezWebFolderService_m.getPermissionIdMapList(userId, userInfo.getDeptID(), userInfo.getCompanyID(), tenantId);
			service.insertIfNotExistRootForder(userId, userInfo.getDisplayName1(), userInfo.getDisplayName2(), userInfo.getCompanyID(), permissionIdList, offset, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("checkRootFolder ended.");
		return result;
	}
	
	/**
	 * 폴더 트리 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/folder-tree", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFolderTree(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("getFolderTree started.");
		
		String serverName 	= orElse(request.getHeader("x-user-host"), "");
		String folderType 	= orElse(request.getParameter("folderType"), "");
		boolean isAdmin 	= Boolean.valueOf(orElse(request.getParameter("isAdmin"), "false"));
		logger.debug("userId: " + userId + " || serverName: " + serverName + "|| folderType: " + folderType + "|| isAdmin: " + isAdmin);

		JSONObject jsonObj = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (userId.equals("") || serverName.equals("")) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			jsonObj.put("data", "");
			
			logger.debug("parameter error. getFolderTree ended.");
			return jsonObj;
		}
		
		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			String deptId    = common.getDeptId();
			String compId    = common.getCompanyId();
			String primary   = common.getPrimary();
			int tenantId     = common.getTenantId();

			List<FolderTreeVO> folderList = service.getFolderTree(userId, deptId, compId, folderType, primary, tenantId, "", isAdmin);

			jsonObj.put("status", "ok");
			jsonObj.put("code", 0);
			jsonObj.put("data", folderList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
			jsonObj.put("data", "");
		}
		
		logger.debug("getFolderTree ended.");
		return jsonObj;
	}
	
	// 폴더 생성 
	@SuppressWarnings("unchecked")
	@RequestMapping ( value="/rest/ezwebfolder/folders" , method= RequestMethod.POST , produces = "application/json;charset=utf-8")
	public JSONObject folderInsert (HttpServletRequest request,@RequestBody JSONObject jsonObject) {
		logger.debug("folderInsert started");
		JSONObject jsonObj = new JSONObject();
		String serverName 			= request.getHeader("x-user-host")      != null ? request.getHeader("x-user-host") : "";
		String userId 				= (String) jsonObject.get("userId");

		MCommonVO common;
		process: try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			String folderUppId 			= (String) jsonObject.get("folderUppId");
			String newFolderName1 		= (String) jsonObject.get("newFolderName1");
			String newFolderName2 		= (String) jsonObject.get("newFolderName2");
			int tenantId 				= common.getTenantId();
			String comId 				= common.getCompanyId();
			String deptId 				= common.getDeptId();
			String offset 				= common.getOffSet();
			SimpleDateFormat formatter 	= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  	= new Date();
			String timeUTC             	= commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			logger.debug("timeUTC"+ timeUTC);
			
			String checkPermission = service.checkPermission(userId, deptId, comId, folderUppId, "D", tenantId);
			
			if ( checkPermission.equals("fail")) {
				logger.debug("checkPermission is fail. ");
				jsonObj.put("status", "error");
				jsonObj.put("code"	, 3);
				logger.debug("folderInsert method ended");
				return jsonObj;
			}
			
			// 추가되는 이름으로 중복되는 게 있는지 확인
			List<DuplicateInfoVO> duplicateInfoList = ezWebFolderService.getAllDuplicateInfo(newFolderName1, folderUppId, offset, tenantId);
			
			if (duplicateInfoList.size() > 0) {
				logger.debug("Duplicate folder name: {}", newFolderName1);
				
				jsonObj.put("status", "error");
				jsonObj.put("duplicateInfoArray", duplicateInfoList);
				jsonObj.put("code", 8);
				
				break process;
			}
			
			// foldervo 가지고 와서 상위의 폴더의 vo를 추린다. 
			FolderVO foldervo= service.getFolderDetail(folderUppId, userId ,tenantId,comId);
			
			// insert후 return 값 성공 : ok 실패 : fail
			String result = service.insertFolder(tenantId, comId , deptId, userId, foldervo.getFolderType(),newFolderName1, newFolderName2, foldervo, timeUTC);
			
			if (result.equals("fail")) {
				jsonObj.put("status", "fail");
				jsonObj.put("code", 2);
				jsonObj.put("data", "");
			}else {
				jsonObj.put("status", "ok");
				jsonObj.put("code", 0);
				jsonObj.put("data", result);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			jsonObj.put("status", "fail");
			jsonObj.put("code", 2);
			jsonObj.put("data", "");
		}
		
		logger.debug("folderInsert ended");
		return jsonObj;
	}
	
	// 폴더 수정 
	@SuppressWarnings("unchecked")
	@RequestMapping (value = "/rest/ezwebfolder/folders/{folderId:.+}", method = RequestMethod.PUT , produces = "application/json;charset=utf-8")
	public JSONObject folderUpdate (@PathVariable String folderId, HttpServletRequest request,@RequestBody JSONObject jsonObject)  {
		logger.debug("folderUpdate started");
		JSONObject jsonObj = new JSONObject();
		String serverName 	= request.getHeader("x-user-host")      != null ? request.getHeader("x-user-host") : "";
		String userId 		= (String) jsonObject.get("userId");
		MCommonVO common;

		process: try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			String newFolderName1 		= (String) jsonObject.get("newFolderName1");
			String newFolderName2 		= (String) jsonObject.get("newFolderName2");
			int tenantId 				= common.getTenantId();
			String comId 				= common.getCompanyId();
			String deptId				= common.getDeptId();
			String offset 				= common.getOffSet();
			SimpleDateFormat formatter 	= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  	= new Date();
			String timeUTC             	= commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			// 이름 변경은 관리자, 담당자, 만든이만 가능 (구성원 불가)
			boolean isPermitted = webfolderUtil.isWebfolderAdmin(common.getRollInfo())
					|| service.checkCreator(folderId, tenantId, comId, userId) == 1;
			
			if (!isPermitted) {
				logger.debug("checkPermission is fail. ");
				jsonObj.put("status", "error");
				jsonObj.put("code"	, 3);
				logger.debug("folderUpdate method ended");
				return jsonObj;
			}
			
			// 새 이름으로 중복되는 게 있는지 확인
			FolderVO targetFolderVO = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			List<DuplicateInfoVO> duplicateInfoList = ezWebFolderService.getAllDuplicateInfo(newFolderName1, targetFolderVO.getFolderUpper(), offset, tenantId);
			
			if (duplicateInfoList.size() > 0) {
				logger.debug("Duplicate folder name: {}", newFolderName1);
				
				jsonObj.put("status", "error");
				jsonObj.put("duplicateInfoArray", duplicateInfoList);
				jsonObj.put("code", 8);
				
				break process;
			}
			
			service.updateFolder(folderId, tenantId, userId, comId, newFolderName1, newFolderName2, timeUTC);
			jsonObj.put("status", "ok");
			jsonObj.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
		}

		logger.debug("folderUpdate ended");
		return jsonObj;
	}
	
	// 폴더 이동, 복사
	@SuppressWarnings("unchecked")
	@RequestMapping ( value = "/rest/ezwebfolder/folders/{folderId}/{mode:.+}" , method = RequestMethod.PUT , produces ="application/json;charset=utf-8")
	public JSONObject folderCopy (@PathVariable String folderId,@PathVariable String mode, HttpServletRequest request ,Locale locale ,@RequestBody JSONObject jsonObject ) {
		logger.debug("folderCopy started");
		String serverName	= request.getHeader("x-user-host")      != null ?	request.getHeader("x-user-host") 		: "";
		String userId		= (String) jsonObject.get("userId") 	!= null ?	(String) jsonObject.get("userId")		: "";
		String uppId		= (String) jsonObject.get("uppFolderId")!= null ?	(String) jsonObject.get("uppFolderId") 	: "";
		String resmode  	= "";
		JSONObject result   = new JSONObject();
		MCommonVO common;
		try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = common.getTenantId();
			String comId = common.getCompanyId();
			String offset = common.getOffSet();
			String deptId = common.getDeptId();
			logger.debug("folderId :" + folderId + ", serverName : "+ serverName + ", userId : " +userId + ", tenantId : " + tenantId
					+ ", comId : " + comId + ", offset" + offset);
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			if (folderId.equals("") || serverName.equals("") || uppId.equals("") || offset.equals("") || mode.equals("") ) {
				logger.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}
			
			String checkPermission = service.checkPermission(userId, deptId, comId, folderId, "D", tenantId);
			
			if ( checkPermission.equals("fail")) {
				logger.debug("checkPermission is fail. ");
				result.put("status", "error");
				result.put("code"	, 3);
				logger.debug("folderCopy method ended");
				return result;
			}
			
			FolderVO folder     = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			FolderVO destFolder = ezWebFolderService.getFolderByFolderId(uppId, offset, tenantId);
			int checkSbCreater = 0;
			logger.debug("mode : " + mode + ", folderId : " + folderId + ", destFolder.getFolderPath() : " + destFolder.getFolderPath());
			
			if (mode.equals("folder-move")) {
				
				// 하위의 있는 폴더가 모두 자신의 것이 아닐때
				checkSbCreater = service.checkCreator(folderId, tenantId, comId, userId);
				if (checkSbCreater != 1) {
					logger.debug("subFolder or SubFile is not mine!");
					result.put("status", "ok");
					result.put("code", 4);
					return result;
				}
				
				//Check 같은 위치로 이동하려고 할때 
				if (folder.getFolderUpper().equals(uppId)) {
					result.put("status", "ok");
					result.put("code", 5);
					return result;
				}
				
				// 상위의 폴더를 하위의 폴더로 이동하려는 경우 
				if ( destFolder.getFolderPath().contains("|"+folderId+"|") ) {
					result.put("status",  "ok");
					result.put("code", 6);
					return result;
				}
			}
			
			int pos = destFolder.getFolderPath().indexOf(folder.getFolderPath());
			
			if (pos != -1) {
				result.put("status", "error");
				result.put("code", 2);
				return result;
			}
			if (mode.equals("folder-move")){
				resmode = "move";
			}else {
				resmode = "copy";
			}
			
			if (resmode.equals("copy")) {
				double folderSize       = ezWebFolderAdminService.getFolderSize(folder.getFolderPath(), tenantId);
				UserCapacityVO userCapacity = ezWebFolderAdminService.getCapacity(uppId, userInfo.getPrimary(), userInfo.getTenantId());
				
				double totalUsed = Double.parseDouble(userCapacity.getTotalUsed());
				double totalCapa = Double.parseDouble(userCapacity.getTotalCapacity()) * 1073741824;
				
				if (folderSize > (totalCapa - totalUsed)) {
					logger.debug("Not enough storage to move/copy this folder!");
					result.put("status", "error");
					result.put("code", 7);
					result.put("data", "");
					return result;
				}
			}
			
			String realPath = request.getServletContext().getRealPath("");
			List<DuplicateInfoVO> duplicateList = ezWebFolderAdminService.moveCompanyFolder(folder, destFolder, resmode, realPath, userInfo, "user");
			
			if (duplicateList == null){
				result.put("status", "error");
				result.put("code", 3);
			} else if (duplicateList.isEmpty()) {
				result.put("status", "ok");
				result.put("code", 0);
			} else {
				result.put("status", "ok");
				result.put("code", 8);
				result.put("duplicateInfoArray", duplicateList);
			}
		}catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		logger.debug("folderCopy ended");
		return result;
	}
	
	// 폴더 삭제 
	@SuppressWarnings("unchecked")
	@RequestMapping(value ="/rest/ezwebfolder/folders/{folderId:.+}", method = RequestMethod.DELETE , produces = "application/json;charset=utf-8")
	public JSONObject folderDelete (@PathVariable String folderId , HttpServletRequest request,@RequestBody JSONObject jsonObject) {
		logger.debug("folderDelete started");
		JSONObject jsonObj = new JSONObject();
		String serverName = request.getHeader("x-user-host")      != null ? request.getHeader("x-user-host") : "";
//		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String userId = (String) jsonObject.get("userId");
		logger.debug((String)jsonObject.get("userId"));
		MCommonVO common;
		try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId 	= common.getTenantId();
			
			if (ezWebFolderService.canDelete(null, new String[] { folderId }, userId, tenantId)) {
				String comId 	= common.getCompanyId();
				String offset 	= common.getOffSet();
				String timeUTC  = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
				int result = service.deleteSubFldAFile(folderId, tenantId, comId, userId, timeUTC, common.getRollInfo());
				if (result == 1) {
					jsonObj.put("status", "ok");
					jsonObj.put("code", 0);
				} else if (result == 2) {
					jsonObj.put("status", "error");
					jsonObj.put("code", 4);
				}
			} else {
				jsonObj.put("status", "error");
				jsonObj.put("code", 5);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
		}
		logger.debug("folderDelete ended");
		return jsonObj;
	}
	
	// 폴더 삭제 
	@SuppressWarnings("unchecked")
	@RequestMapping(value ="/rest/ezwebfolder/folder-delete", method = RequestMethod.DELETE , produces = "application/json;charset=utf-8")
	public JSONObject folderDelete2 ( HttpServletRequest request,@RequestBody JSONObject jsonObject) {
		logger.debug("folderDelete started");
		JSONObject jsonObj 			= new JSONObject();
		String serverName 			= request.getHeader("x-user-host")      != null ? request.getHeader("x-user-host") : "";
		SimpleDateFormat formatter 	= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  	= new Date();
		String userId 				= (String) jsonObject.get("userId");
		String listFolderId   		= (String) jsonObject.get("folderId") != null ? (String) jsonObject.get("folderId") : "";
		String[] folderIDList 		= listFolderId.split(",");
		
		logger.debug((String)jsonObject.get("userId"));
		MCommonVO common;
		try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId 	= common.getTenantId();
			String comId 	= common.getCompanyId();
			String offset 	= common.getOffSet();
			String deptId 	= common.getDeptId();
			String timeUTC  = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			String checkPermission = "";
			
			for ( int i = 0; i < folderIDList.length; i++ ) {
				checkPermission = service.checkPermission(userId, deptId, comId, folderIDList[i], "D", tenantId);
				
				if ( checkPermission.equals("fail")) {
					logger.debug("checkPermission is fail. ");
					jsonObj.put("status", "error");
					jsonObj.put("code"	, 3);
					logger.debug("fileList method ended");
					return jsonObj;
				}
			}
			
			for ( int i = 0; i < folderIDList.length; i++ ) {
				int result = service.deleteSubFldAFile(folderIDList[i], tenantId, comId, userId, timeUTC, common.getRollInfo());
				if (result == 1) {
					jsonObj.put("status", "ok");
					jsonObj.put("code", 0);
				} else if (result == 2) {
					jsonObj.put("status", "error");
					jsonObj.put("code", 4);
				}
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
		}
		logger.debug("folderDelete ended");
		return jsonObj;
	}
	
	// 파일리스트 조회 
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/folders/{folderId}/file-list", method=RequestMethod.GET, produces ="application/json;charset=utf-8")
	public JSONObject fileList (@PathVariable String folderId, HttpServletRequest request)  {
		logger.debug("fileList method started");
		
		JSONObject jsonObj = new JSONObject();
		String serverName = request.getHeader("x-user-host")      			!= null ? request.getHeader("x-user-host") 			: "" ;
		String userId = request.getParameter("userId");
		String searchExt = request.getParameter("searchExt")			 	!= null ? request.getParameter("searchExt") 		: "" ;
		String searchFileName = request.getParameter("searchFileName") 		!= null ? request.getParameter("searchFileName")	: "" ;
		String searchFileType = request.getParameter("searchFileType") 		!= null ? request.getParameter("searchFileType") 	: "" ;
		String searchCreateName = request.getParameter("searchCreateName") 	!= null ? request.getParameter("searchCreateName") 	: "" ;
		String searchStartDate = request.getParameter("searchStartDate")	!= null ? request.getParameter("searchStartDate") 	: "" ;
		String searchEndDate = request.getParameter("searchEndDate") 		!= null ? request.getParameter("searchEndDate") 	: "" ;
		String searchPageCount = request.getParameter("searchPageCount") 	!= null ? request.getParameter("searchPageCount") 	: "" ;
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		searchExt = commonUtil.getWildcardEscapedString(searchExt, dbName);
   		searchFileName = commonUtil.getWildcardEscapedString(searchFileName, dbName);
   		searchCreateName = commonUtil.getWildcardEscapedString(searchCreateName, dbName);
		
		logger.debug("searchExt : " + searchExt + " || searchFileName : " + searchFileName);
		logger.debug("searchFileType : " + searchFileType + " || searchCreateName : " + searchCreateName);
		
		int totalCount = request.getParameter("totalCount") 				!= null ? Integer.parseInt(request.getParameter("totalCount"))	: 0;
		int currPage = request.getParameter("currPage") 					!= null ? Integer.parseInt(request.getParameter("currPage")) 	: 1;
		int totalpages = request.getParameter("totalpages") 				!= null ? Integer.parseInt(request.getParameter("totalpages"))	: 1;
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		JSONObject data = new JSONObject();
		
		if (folderId.equals("") || userId.equals("") ) {
			logger.debug("Parameter error!");
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			
			logger.debug("fileList method ended");
			return jsonObj;
		}
		
		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = common.getTenantId();
			String deptId = common.getDeptId();
			String offset = common.getOffSet();
			String primary = common.getPrimary();
			String comId = common.getCompanyId();
			
			String checkPermission = service.checkPermission(userId, deptId, comId, folderId, "D", tenantId);
			
			if ( checkPermission.equals("fail")) {
				logger.debug("checkPermission is fail. ");
				jsonObj.put("status", "error");
				jsonObj.put("code"	, 3);
				logger.debug("fileList method ended");
				return jsonObj;
			}
			
			// 자신이 환경설정에 설정해놓은 listCount개수를 가져옴
			int usrListCnt = service.getUsrListCount(tenantId, userId);
			
			logger.debug("offset : " + commonUtil.getMinuteUTC(offset));
			logger.debug("usrListCnt : " + usrListCnt + " ||  tenantId : " +tenantId + " || userId : " + userId);
			
			int listCount = request.getParameter("listCount") 	!= null ? Integer.parseInt(request.getParameter("listCount")) 	: usrListCnt;
			
			if (listCount == 0) {
				listCount = usrListCnt ;
			}
			
			int pStart = request.getParameter("pStart")			!= null ? Integer.parseInt(request.getParameter("pStart"))		: 0;
			int pEnd = listCount;
			
			if (usrListCnt != listCount) {
				service.insertEnv(userId, tenantId, listCount);
			}
			
			logger.debug("listCount : " + listCount + " || currPage : " + currPage+ " || totalpages : "+ totalpages + " || pEnd : " + pEnd );
			logger.debug("folderId : " + folderId + " || deptId : "+ deptId + " || offset : " + offset );
			logger.debug("pStart : " + pStart + " || pEnd : " + pEnd);
			
			// fileCnt : 파일 개수 , fldCnt : 폴더 개수 , totalCount : 파일, 폴더 둘다 합한 개수 ( 페이징 하기 위해 필요 ) 
			Map<String, Integer> cnt = service.getFileToTalCount(folderId, userId, deptId, tenantId, comId,
					searchExt, searchFileName, searchStartDate, searchEndDate, searchCreateName, searchFileType,
					searchPageCount, pStart, pEnd, offset , primary);
			
			logger.debug("fileListSize : " + cnt + " || searchStartDate : " + searchStartDate + " || searchEndDate : " + searchEndDate );
			
			int fileCnt = cnt.get("fileTotalCnt");
			int fldCnt  = cnt.get("fldTotalCnt");
			totalCount  = cnt.get("totalCount");
			
			if (totalCount % listCount == 0) {
				totalpages = (totalCount / listCount);
			} else {
				totalpages = (totalCount / listCount) + 1;
			}
			
			if (currPage > totalpages & totalCount != 0) {
				currPage = totalpages;
				pStart = (currPage -1 )* listCount;
			}
			pEnd = listCount;
			
			
			fileList = service.getFileList(folderId, userId, deptId, tenantId , comId,
					searchExt, searchFileName, searchStartDate, searchEndDate, searchCreateName, searchFileType,
					searchPageCount, pStart, pEnd, offset, primary);
			
			logger.debug("fileListSize : " + fileList.size()+ " || searchStartDate : " +searchStartDate+" || searchEndDate : "+searchEndDate );
			
			
			FolderVO folder       = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			String folderPath     = folder.getFolderPath();
			String folderPath2    = folder.getFolderPath();
			folderPath            = folderPath.substring(1, folderPath.length() - 1);
			String originalPath   = ezWebFolderService.getFolderPath(folderPath.split("\\|"), primary, tenantId);
			
			logger.debug("OriginalPath: " + originalPath);
					
			Map<String, String> filePathMap = new LinkedHashMap<String, String>();

			if (fileList.size() > 0) {
				String [] rootPath  = folderPath.split("\\|");
				Set<String> testbnk = new HashSet<String>();
				
				for (FileVO file : fileList ) {
					String fldPath      = file.getFolderPath().substring(1, file.getFolderPath().length() - 1);
					String[] fldPathArr = fldPath.split("\\|");
					testbnk.addAll(Arrays.asList(fldPathArr));
				}
				
				List<String> listName = new ArrayList<String>(testbnk);
				filePathMap           = ezWebFolderService.getAllFolderNameMap(listName, primary, tenantId);
				
				for (FileVO file : fileList) {
					
					if (file.getFilePosition() == null || file.getFilePosition().equals("")) {
						String file_path    = originalPath;
						String fldPath      = file.getFolderPath().substring(1, file.getFolderPath().length() - 1);
						String[] fldPathArr = fldPath.split("\\|");
						
						if (file.getFileTypeName().equals("folder")) {
							for (int i = rootPath.length; i < fldPathArr.length-1; i++) {
								file_path += filePathMap.get(fldPathArr[i]) + "/";
							}
						} else {
							for (int i = rootPath.length; i < fldPathArr.length; i++) {
								file_path += filePathMap.get(fldPathArr[i]) + "/";
							}
						}
						
						file_path = file_path.substring(0, file_path.length()-1);
						file.setFilePosition(file_path);
					}
				}
			}
			
			FolderVO fldDetail = service.getFolderDetail(folderId, userId, tenantId, comId);
			
			logger.debug("-------folderUpp" + fldDetail.getFolderUpper());
			
			data.put("folderUpp", fldDetail.getFolderUpper());
			data.put("createDate", fldDetail.getCreateDate());
			data.put("updateDate", fldDetail.getUpdateDate());
			data.put("folderName", fldDetail.getFolderName1());
			// 2020-12-08 김은실 - [카이스트] 
			data.put("folderName2", fldDetail.getFolderName2());
			data.put("userId", userId);
			data.put("folderPath", folderPath2);
			data.put("originalPath", originalPath);
			data.put("fileList", fileList);
			data.put("fileCnt", fileCnt);
			data.put("fldCnt", fldCnt);
			data.put("totalRows", fileCnt+fldCnt);
			data.put("totalPages", totalpages );
			data.put("listCount", listCount );
			data.put("currPage", currPage );
			data.put("folderLevel", fldDetail.getFolderLevel());

			List<String> containsReplyFiles = ezWebFolderService.getContainsReplyFiles(folderId, tenantId);
			data.put("containsReplyFiles", containsReplyFiles);

			List<String> managedFolderList;

			if (fldDetail.getFolderLevel() == 0) {
				managedFolderList = ezWebFolderAdminService.getTopFoldersByManagerUserId(userId, tenantId);
			} else {
				managedFolderList = ezWebFolderAdminService.getFolderIdsByManagerUserId(userId,
						folderId, common.getCompanyId(), tenantId);
			}

			data.put("managedFolderList", managedFolderList);

			// 폴더 권한 비상속
			data.put("isNotInherit", ezWebFolderService.isNotInheritFolder(folderId, tenantId));

			jsonObj.put("status", "ok");
			jsonObj.put("code", 0);
			jsonObj.put("data", data);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			logger.debug(" fail ");
			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
			jsonObj.put("data", "");
		}
		
		logger.debug("fileList method ended");
		return jsonObj;
	}

	// 파일리스트 조회 
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/folders/{folderId}/file-list2", method=RequestMethod.GET, produces ="application/json;charset=utf-8")
	public JSONObject fileList2 (@PathVariable String folderId, HttpServletRequest request)  {
		logger.debug("fileList method started");
		
		JSONObject jsonObj = new JSONObject();
		String serverName = request.getHeader("x-user-host")      			!= null ? request.getHeader("x-user-host") 			: "" ;
		String userId = request.getParameter("userId");
		String searchExt = request.getParameter("searchExt")			 	!= null ? request.getParameter("searchExt") 		: "" ;
		String searchFileName = request.getParameter("searchFileName") 		!= null ? request.getParameter("searchFileName")	: "" ;
		String searchFileType = request.getParameter("searchFileType") 		!= null ? request.getParameter("searchFileType") 	: "" ;
		String searchCreateName = request.getParameter("searchCreateName") 	!= null ? request.getParameter("searchCreateName") 	: "" ;
		String searchStartDate = request.getParameter("searchStartDate")	!= null ? request.getParameter("searchStartDate") 	: "" ;
		String searchEndDate = request.getParameter("searchEndDate") 		!= null ? request.getParameter("searchEndDate") 	: "" ;
		String searchPageCount = request.getParameter("searchPageCount") 	!= null ? request.getParameter("searchPageCount") 	: "" ;
		String isExplorer = request.getParameter("isExplorer") 				!= null ? request.getParameter("isExplorer") 		: "" ;
		String sortType 		= request.getParameter("sortType") 			!= null ? request.getParameter("sortType") 			: "" ;
		String sortColumn 		= request.getParameter("sortColumn") 		!= null ? request.getParameter("sortColumn") 		: "" ;
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
		searchExt = commonUtil.getWildcardEscapedString(searchExt, dbName);
		searchFileName = commonUtil.getWildcardEscapedString(searchFileName, dbName);
		searchCreateName = commonUtil.getWildcardEscapedString(searchCreateName, dbName);
		
		logger.debug("searchExt : " + searchExt + " || searchFileName : " + searchFileName);
		logger.debug("searchFileType : " + searchFileType + " || searchCreateName : " + searchCreateName);
		
		int totalCount = request.getParameter("totalCount") 				!= null ? Integer.parseInt(request.getParameter("totalCount"))	: 0;
		int currPage = request.getParameter("currPage") 					!= null ? Integer.parseInt(request.getParameter("currPage")) 	: 1;
		int totalpages = request.getParameter("totalpages") 				!= null ? Integer.parseInt(request.getParameter("totalpages"))	: 1;
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		JSONObject data = new JSONObject();
		
		if (folderId.equals("") || userId.equals("") ) {
			logger.debug("Parameter error!");
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
		}
		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = common.getTenantId();
			String deptId = common.getDeptId();
			String offset = common.getOffSet();
			String primary = common.getPrimary();
			String comId = common.getCompanyId();
			
			String checkPermission = service.checkPermission(userId, deptId, comId, folderId, "D", tenantId);
			
			if ( checkPermission.equals("fail")) {
				logger.debug("checkPermission is fail. ");
				jsonObj.put("status", "error");
				jsonObj.put("code"	, 3);
				logger.debug("fileList2 method ended");
				return jsonObj;
			}
			
			// isExplorer 탐색기가 호출한 내용이면 listCount를 가져오지 않음
			int usrListCnt = 0;
			if (!isExplorer.equals("YES")) {
				// 자신이 환경설정에 설정해놓은 listCount개수를 가져옴
				usrListCnt = service.getUsrListCount(tenantId, userId);
			} else {
				usrListCnt = 10000;
			}
			
			logger.debug("offset : " + commonUtil.getMinuteUTC(offset));
			logger.debug("usrListCnt : " + usrListCnt + " ||  tenantId : " +tenantId + " || userId : " + userId);
			
			int listCount = request.getParameter("listCount") 	!= null ? Integer.parseInt(request.getParameter("listCount")) 	: usrListCnt;
			int pStart = request.getParameter("pStart")			!= null ? Integer.parseInt(request.getParameter("pStart"))		: 0;
			
			if (listCount == 0) {
				listCount = usrListCnt ;
			}
			
			int pEnd = listCount;
			
			if (!isExplorer.equals("YES")) {
				if (usrListCnt != listCount) {
					service.insertEnv(userId, tenantId, listCount);
				}
			}
			
			logger.debug("listCount : " + listCount + " || currPage : " + currPage+ " || totalpages : "+ totalpages + " || pEnd : " + pEnd );
			logger.debug("folderId : " + folderId + " || deptId : "+ deptId + " || offset : " + offset );
			logger.debug("pStart : " + pStart + " || pEnd : " + pEnd);
			
			// fileCnt : 파일 개수 , fldCnt : 폴더 개수 , totalCount : 파일, 폴더 둘다 합한 개수 ( 페이징 하기 위해 필요 ) 
			Map<String, Integer> cnt = service.getFileToTalCount2(folderId, userId, deptId, tenantId, comId,
					searchExt, searchFileName, searchStartDate, searchEndDate, searchCreateName, searchFileType,
					searchPageCount, pStart, pEnd, offset , primary);
			
			logger.debug("fileListSize : " + cnt + " || searchStartDate : " + searchStartDate + " || searchEndDate : " + searchEndDate );
			
			int fileCnt = cnt.get("fileTotalCnt");
			int fldCnt  = cnt.get("fldTotalCnt");
			totalCount  = cnt.get("totalCount");
			
			if (totalCount % listCount == 0) {
				totalpages = (totalCount / listCount);
			} else {
				totalpages = (totalCount / listCount) + 1;
			}
			
			if (currPage > totalpages & totalCount != 0) {
				currPage = totalpages;
				pStart = (currPage -1 )* listCount;
			}
			pEnd = listCount;
			
			fileList = service.getFileList2(folderId, userId, deptId, tenantId , comId,
					searchExt, searchFileName, searchStartDate, searchEndDate, searchCreateName, searchFileType,
					searchPageCount, pStart, pEnd, offset, primary, sortType, sortColumn);
			
			logger.debug("fileListSize : " + fileList.size()+ " || searchStartDate : " +searchStartDate+" || searchEndDate : "+searchEndDate );
			
			
			FolderVO folder       = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			String folderPath     = folder.getFolderPath();
			String folderPath2    = folder.getFolderPath();
			folderPath            = folderPath.substring(1, folderPath.length() - 1);
			String originalPath   = ezWebFolderService.getFolderPath(folderPath.split("\\|"), primary, tenantId);
			
			logger.debug("OriginalPath: " + originalPath);
			
			Map<String, String> filePathMap = new LinkedHashMap<String, String>();
			
			if (fileList.size() > 0) {
				String [] rootPath  = folderPath.split("\\|");
				Set<String> testbnk = new HashSet<String>();
				
				for (FileVO file : fileList ) {
					String fldPath      = file.getFolderPath().substring(1, file.getFolderPath().length() - 1);
					String[] fldPathArr = fldPath.split("\\|");
					testbnk.addAll(Arrays.asList(fldPathArr));
				}
				
				List<String> listName = new ArrayList<String>(testbnk);
				filePathMap           = ezWebFolderService.getAllFolderNameMap(listName, primary, tenantId);
				
				for (FileVO file : fileList) {
					
					if (file.getFilePosition() == null || file.getFilePosition().equals("")) {
						String file_path    = originalPath;
						String fldPath      = file.getFolderPath().substring(1, file.getFolderPath().length() - 1);
						String[] fldPathArr = fldPath.split("\\|");
						
						if (file.getFileTypeName().equals("folder")) {
							for (int i = rootPath.length; i < fldPathArr.length-1; i++) {
								file_path += filePathMap.get(fldPathArr[i]) + "/";
							}
						} else {
							for (int i = rootPath.length; i < fldPathArr.length; i++) {
								file_path += filePathMap.get(fldPathArr[i]) + "/";
							}
						}
						file_path = file_path.substring(0, file_path.length() - 1);
						file.setFilePosition(file_path );
					}
				}
			}
			
			FolderVO fldDetail = service.getFolderDetail(folderId, userId, tenantId, comId);
			
			logger.debug("-------folderUpp" + fldDetail.getFolderUpper());
			
			data.put("folderUpp", fldDetail.getFolderUpper());
			data.put("createDate", fldDetail.getCreateDate());
			data.put("updateDate", fldDetail.getUpdateDate());
			data.put("folderName", fldDetail.getFolderName1());
			// 2020-12-08 김은실 - [카이스트] 
			data.put("folderName2", fldDetail.getFolderName2());
			data.put("folderPath", folderPath2);
			data.put("originalPath", originalPath);
			data.put("fileList", fileList);
			data.put("fileCnt", fileCnt);
			data.put("fldCnt", fldCnt);
			data.put("totalRows", fileCnt+fldCnt);
			data.put("totalPages", totalpages );
			data.put("listCount", listCount );
			data.put("currPage", currPage );
			data.put("userId", userId);
			data.put("folderLevel", fldDetail.getFolderLevel());

			List<String> containsReplyFiles = ezWebFolderService.getContainsReplyFiles(folderId, tenantId);
			data.put("containsReplyFiles", containsReplyFiles);

			List<String> managedFolderList;

			if (fldDetail.getFolderLevel() == 0) {
				managedFolderList = ezWebFolderAdminService.getTopFoldersByManagerUserId(userId, tenantId);
			} else {
				managedFolderList = ezWebFolderAdminService.getFolderIdsByManagerUserId(userId,
						folderId, common.getCompanyId(), tenantId);
			}

			data.put("managedFolderList", managedFolderList);

			// 폴더 권한 비상속
			data.put("isNotInherit", ezWebFolderService.isNotInheritFolder(folderId, tenantId));

			jsonObj.put("status", "ok");
			jsonObj.put("code", 0);
			jsonObj.put("data", data);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			logger.debug(" fail ");
			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
			jsonObj.put("data", "");
		}
		
		logger.debug("fileList method ended");
		return jsonObj;
	}
	
	private <T> T orElse(T value, T other) {
		if (other == null) {
			throw new IllegalArgumentException("other is null!");
		}
		
		return value != null ? value : other;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/checkpermission", method=RequestMethod.POST, produces ="application/json;charset=utf-8")
	public JSONObject checkPermission (@PathVariable String userId, @RequestBody JSONObject jsonObject, HttpServletRequest request)  {
		logger.debug("checkPermission started.");
		
		String serverName 	= orElse(request.getHeader("x-user-host"), "");
		
		List<Map<String, Object>> checkList = (List<Map<String, Object>>) jsonObject.get("checkList");
		
		logger.debug("userId: " + userId + " || serverName: " + serverName);
		
		JSONObject jsonObj = new JSONObject();
		
		if (userId.equals("") || serverName.equals("")) {
			jsonObj.put("status"	, "error");
			jsonObj.put("code"		, 1);
			jsonObj.put("data"		, "");
			logger.debug("parameter error. checkPermission ended.");
			return jsonObj;
		}
		
		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			String deptId    = common.getDeptId();
			String comId     = common.getCompanyId();
			int tenantId     = common.getTenantId();

			String checkId 		= "";
			String checkType 	= "";
			String checkResult 	= "";
			for (int i = 0; i < checkList.size(); i++) {
				checkId	 	= (String) checkList.get(i).get("checkId");
				checkType	= (String) checkList.get(i).get("checkType");
				checkResult = service.checkPermission(userId, deptId, comId, checkId, checkType, tenantId);
				
				if (checkResult.equals("fail")) {
					logger.debug("this folder conection is not permission ");
					jsonObj.put("status", "error");
					jsonObj.put("code"	, 3);
					logger.debug("checkPermission method Ended ");
					return jsonObj;
				}
				logger.debug(checkResult);
				
			}
			
			jsonObj.put("status"	, "ok");
			jsonObj.put("code"		, 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			jsonObj.put("status"	, "error");
			jsonObj.put("code"		, 2);
		}
		
		logger.debug("checkPermission ended.");
		return jsonObj;

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/checkpermissions", method=RequestMethod.POST, produces ="application/json;charset=utf-8")
	public JSONObject checkPermissions(@PathVariable String userId, @RequestBody JSONObject jsonObject, HttpServletRequest request) {
		logger.debug("checkPermissions started.");

		String serverName = orElse(request.getHeader("x-user-host"), "");

		String fileList = jsonObject.get("fileList").toString();
		String folderList = jsonObject.get("folderList").toString();
		boolean isAdminCheck = jsonObject.get("adminCheck") != null;

		logger.debug("userId: " + userId + " || serverName: " + serverName);

		JSONObject jsonObj = new JSONObject();

		if (userId.equals("") || serverName.equals("")) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			jsonObj.put("data", "");
			logger.debug("parameter error. checkPermissions ended.");
			return jsonObj;
		}

		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			String deptId = common.getDeptId();
			String comId = common.getCompanyId();
			int tenantId = common.getTenantId();

			if (isAdminCheck && webfolderUtil.isWebfolderAdmin(common.getRollInfo())) {
				jsonObj.put("status", "ok");
				jsonObj.put("code", 0);
			} else {
				jsonObj = service.checkPermissions(userId, deptId, comId, folderList, fileList, tenantId);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
		}

		logger.debug("checkPermissions ended.");
		return jsonObj;
	}

	/**
	 * 탐색기 연동위한 folder file과 id를 전송시 상세 정보 출력해주는 메서드 추가 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/fldfile/{fldfile}/fldfile-detail", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFldFileDetail(@PathVariable String fldfile, HttpServletRequest request) {
		logger.debug("getFldFileDetail started.");
		
		JSONObject jsonObj = new JSONObject();
		String serverName 	= request.getHeader("x-user-host")      			!= null ? request.getHeader("x-user-host") 			: "" ;
		String userId 		= request.getParameter("userId");
		String fldFileId 	= request.getParameter("fldFileId");

		FileVO fldFileDetail = new FileVO();
		JSONObject data = new JSONObject();
		
		if (fldfile.equals("") || userId.equals("") || fldFileId.equals("")) {
			logger.debug("Parameter error!");
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			
			logger.debug("getFldFileDetail method ended");
			return jsonObj;
		}
		
		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = common.getTenantId();
			String offset = common.getOffSet();
			String primary = common.getPrimary();
			String comId = common.getCompanyId();
			
			fldFileDetail = service.getFolderFileDetailForExplorer(fldfile, fldFileId, userId, tenantId, comId, offset, primary);
			
			data.put("fileList", fldFileDetail);
			
			jsonObj.put("status", "ok");
			jsonObj.put("code", 0);
			jsonObj.put("data", data);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			logger.debug(" fail ");
			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
			jsonObj.put("data", "");
		}
		
		logger.debug("getFldFileDetail method ended");
		return jsonObj;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/filemanage/file-upload-overwrite", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postFileUploadOverWrite(@RequestParam("data") String dataList, @RequestParam("files") List<MultipartFile> multiPartFileLists, Locale locale, HttpServletRequest request) {
		logger.debug("postFileUploadOverWrite start");
		JSONParser jp          = new JSONParser();
		JSONObject jsonObject;
		JSONObject result      = new JSONObject();
		try {
			jsonObject = (JSONObject) jp.parse(dataList);
		
			String serverName      = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host")          : "";
			JSONArray nameArray    = jsonObject.get("nameArray")    != null ? (JSONArray) jsonObject.get("nameArray") : null;
			String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId")       : "";
			String folderId        = jsonObject.get("folderId")     != null ? (String) jsonObject.get("folderId")     : "";
			JSONArray fileIdArray  = jsonObject.get("fileIdArray")   	!= null ? (JSONArray) jsonObject.get("fileIdArray")	  : null;
			String[] mailAttachArray = Optional.ofNullable(request.getParameterValues("filesMailAttach")).orElse(new String[0]);
			
			logger.debug("Servername: " + serverName + " || UserId: " + userId + " || FolderId: " + folderId ); 
			
			if (nameArray == null || serverName.equals("") || userId.equals("") || folderId.equals("") || fileIdArray == null ) {
				logger.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			String realPath  = request.getServletContext().getRealPath("");

			List<FileUploadVO> multiFileLists = webfolderUtil.convertFileUploadVOFromRequest(multiPartFileLists, mailAttachArray, userId, tenantId, locale);

			if ((nameArray != null ? nameArray.size() : 0) != multiFileLists.size() || (fileIdArray != null ? fileIdArray.size() : 0) != multiFileLists.size()) {
				System.out.println(fileIdArray != null ? fileIdArray.size() : 0);
				System.out.println(nameArray != null ? nameArray.size() : 0);
				System.out.println(multiFileLists.size());
				logger.debug("Some files upload failed!");
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}
			
			if (!webfolderUtil.isWebfolderAdmin(userInfo)){
				JSONObject permissionResult = service.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderId, null, userInfo.getTenantId());
				
				if ("error".equals(permissionResult.get("status"))) {
					result.put("status", "error");
					result.put("code", 2);
					return result;
				}
			}
			
			WebfolderConfigVO webfolderConfig   = ezWebFolderAdminService.getWebfolderConfig(userInfo.getCompanyID(), userInfo.getTenantId());
			double limitUploadValue             = webfolderConfig.getUploadLimit().equals("") ? 0 : Double.parseDouble(webfolderConfig.getUploadLimit());
			double totalUploadSize              = 0;
			
			for (int i = 0; i < multiFileLists.size(); i++) {
				totalUploadSize += multiFileLists.get(i).getSize();
			}
			
			if (limitUploadValue * 1073741824 < totalUploadSize) {
				result.put("status", "error");
				result.put("code", 4);
				return result;
			}
			
			UserCapacityVO userCapacity = ezWebFolderAdminService.getCapacity(folderId, userInfo.getPrimary(), userInfo.getTenantId());
			logger.debug("userCapacity!");
			
			double totalUsed = Double.parseDouble(userCapacity.getTotalUsed());
			double totalCapa = Double.parseDouble(userCapacity.getTotalCapacity()) * 1073741824;
			
			if (totalUploadSize > (totalCapa - totalUsed)) {
				logger.debug("Not enough storage to upload these files!");
				result.put("status", "error");
				result.put("code", 5);
				return result;
			}
			
			JSONObject returnData = service.fileUpdateOverwrite( multiFileLists, nameArray, userInfo, folderId, fileIdArray, realPath, tenantId);
			if (returnData.get("status").equals("ok")) {
				result.put("status", "ok");
				result.put("code", 0);
			} else {
				result.put("status", "error");
				result.put("code", 3);
			}
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("postFileUploadOverWrite end");
		return result;
	}
	
	public String getWebFolderDirPath(int tenantId) {
		return commonUtil.getUploadPath("upload_webfolder.ROOT", tenantId) + commonUtil.separator;
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/rest/ezwebfolder/login", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public JSONObject webfolderLogin(HttpServletRequest request, @RequestBody String requestBody) {
		JSONObject result = new JSONObject();
		logger.debug("webfolderLogin start.");
		logger.debug("requestBody=" + requestBody);
		
		try {
			JSONObject requestObject = new JSONObject();
	    	JSONParser parser = new JSONParser();
			requestObject = (JSONObject)parser.parse(requestBody);
	    	
	    	String userId = requestObject.get("userid") != null ? (String)requestObject.get("userid") : "";
	    	String pw = requestObject.get("pw") != null ? (String)requestObject.get("pw") : "";
	    	// String userIde = requestObject.get("useride") != null ? (String)requestObject.get("useride") : "";
	    	// String pwe = requestObject.get("pwe") != null ? (String)requestObject.get("pwe") : "";
	    	int tenantId = 0;
	    	
	    	// postMan으로 원하는 encrypt를 원할시 테스트하기 위함.  
	    	// logger.debug(webfolderUtil.encryptAES(userIde));
	    	// logger.debug(webfolderUtil.encryptAES(pwe));
	    	
	    	userId = webfolderUtil.decryptAES(userId);
			pw = webfolderUtil.decryptAES(pw);
			logger.debug("userId=" + userId + ",pw=" + pw);
		
			String encryptedPw = EgovFileScrty.encryptPassword(pw, userId);
			
			LoginVO vo = new LoginVO();
			vo.setId(userId);
			vo.setPassword(encryptedPw);
			vo.setTenantId(tenantId);
			LoginVO returnVo = new LoginVO();
			returnVo = loginService.selectUser(vo);

			if (returnVo.getTenantId() == -1) {
				throw new Exception("not exists user.");
			}
			SimpleDateFormat sdf = new SimpleDateFormat("M/d/yyyy");
			String createdToken = UUID.randomUUID().toString() + userId + sdf.format(new Date());
			createdToken = Base64.encodeBase64String(createdToken.getBytes());
			logger.debug("createdToken=" + createdToken);
			
			// table은 tbl_webfolder_token
			// table에 insert할 데이터 : userId, 토큰, 등록날짜(디비에 있는 서버 utc사용 ), companyId, tenantId(PK), divice 
			
			String resultToken = service.setAuthLoginTokenSql(userId, createdToken, tenantId, 0);
			logger.debug("resultToken=" + resultToken);
			
			if (resultToken == null) {
				throw new Exception("resultToken is null");
			} else {
				// 웹폴더로 로그인을 시도할 시 토큰값을 return 해주면서 권한이 있는 개인, 부서, 회사 폴더를 생성하도록한다. 
				// 단, 폴더 생성시는 웹으로 접근한적이 한번도 없을때, 폴더가 존재 하지 않을때 사용하기 위함.
				if(checkRootFolder(userId, request).get("status").equals("ok")){
					result.put("status", "ok");
					result.put("code", 0);
					result.put("ltoken", createdToken);
				} else {
					// 개인, 부서, 회사 폴더가 존재하지 않으면 
					result.put("status", "error");
					result.put("code", 3);
				}
			}
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("webfolderLogin end.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/delete-user-alldata", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public JSONObject deleteUserAllFileAndFolder(HttpServletRequest request, @RequestBody JSONObject jsonObject) {
		JSONObject result = new JSONObject();
		String serverName 	= orElse(request.getHeader("x-user-host"),"");
		String fileList     = (String) orElse(jsonObject.get("fileList"), "");
		String folderList   = (String) orElse(jsonObject.get("folderList"), "");
		String userId       = (String) orElse(jsonObject.get("userId"), "");
		String adminId   	= (String) orElse(jsonObject.get("adminId"), "");
		
		logger.debug("deleteUserAllFileAndFolder Started.");
		logger.debug("userId : " + userId  + " || serverName : " + serverName);
		String[] fileIDList = fileList.split(",");
		String[] folderIDList = folderList.split(",");
		String realPath = request.getServletContext().getRealPath("");
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			LoginVO userInfoAdmin = commonUtil.getUserForGw(adminId, serverName);
			
			String folderIdTypeU = service.folderIdByUserIdAndFolderType(userId, userInfo.getTenantId(), "");
			
			/* 2020-10-27 김은실 - 사용자 삭제 시 웹폴더 구성원 삭제 동작 추가 */
			ezWebFolderAdminService.deleteFolderUsersByUserId(userId, "USER", userInfo.getCompanyID(), userInfo.getTenantId());
			if (folderIdTypeU == null){
	            logger.debug("The user folder does not exist.");
	            result.put("status", "ok");
	            result.put("code", 3);
	            return result;
	         }
	         folderIDList[0] = folderIdTypeU;
			
			if (!webfolderUtil.isWebfolderAdmin(userInfoAdmin)) {
				result.put("status", "error");
				result.put("code", 2);	
				return result;
			}
			ezWebFolderService_m.permanetDeleteSelectedFiles(fileIDList, folderIDList, userInfo, realPath, "delete");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("filePermanetDelete ended");
		
		result.put("status", "ok");
		result.put("code", 0);
		
		return result ;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/folderidbyuserid-foldertype", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public JSONObject folderIdByUserIdAndFolderType(HttpServletRequest request, @RequestBody JSONObject jsonObject) throws Exception{
		
		logger.debug("folderIdByUserIdAndFolderType start.");
		JSONParser parser  = new JSONParser();
		JSONObject json = new JSONObject();
		String folderId = "";
		List<Map<String,Object>> folderInfo = new ArrayList<Map<String,Object>>();
		String folderType = (String) jsonObject.get("folderType");
		
		try {
			logger.debug("userId=" + jsonObject.get("ownerId").toString() + ",tenantId=" + jsonObject.get("tenantId").toString() 
					+ ",folderType=" + jsonObject.get("folderType").toString());
//			folderId = service.folderIdByUserIdAndFolderType(jsonObject.get("ownerId").toString(), Integer.parseInt(jsonObject.get("tenantId").toString())
//					, jsonObject.get("folderType").toString());
			List<Map<String, String>> permissionIdList 
				= ezWebFolderService_m.getPermissionIdMapList((String)jsonObject.get("userId"), (String)jsonObject.get("deptId"), 
						(String)jsonObject.get("comId"), (Integer)jsonObject.get("tenantId"));
			
			jsonObject.put("idList", permissionIdList);
			
			folderInfo = service.getRootFolderListInfo(jsonObject); 
			if (folderInfo.size() > 0) {
				folderId = folderInfo.get(0).get("FOLDER_ID").toString();
			}
		} catch (Exception e1) {
			logger.error(e1.getMessage(), e1);
			json.put("status", "error");
			json.put("code", 2);
			return json;
		}
		
		logger.debug("folderId=" + folderId);
		json.put("folderInfo", folderInfo);
		json.put("folderId", folderId);
		json.put("status", "ok");
		json.put("code", 0);
		logger.debug("folderIdByUserIdAndFolderType end.");
		return json ;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/selectwebfolderfiletoanother", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public JSONObject selectWebfolderFiletoAnother(HttpServletRequest request, @RequestBody JSONObject jsonObject) throws Exception{
		
		logger.debug("folderIdByUserIdAndFolderType start.");
		ArrayList<Map<String, Object>> fileList = new ArrayList<Map<String,Object>>();
		JSONObject result = new JSONObject();
		
		ArrayList<String> list = new ArrayList<String>();
		list = (ArrayList<String>) jsonObject.get("param");
		
		String userId = jsonObject.get("userId").toString();
		int tenantId = (int) jsonObject.get("tenantId");
		
		// 퍼미션 체크 해야함 
		try {
			logger.debug("userId=" + userId + ",list=" + list + ",tenantId=" + tenantId);
			
			fileList = service.selectWebfolderFiletoAnother(userId, list, tenantId);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
			return result;
		}
		
		result.put("fileList", fileList);
		result.put("status", "ok");
		result.put("code", 0);
		logger.debug("folderIdByUserIdAndFolderType end.");
		return result ;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/selectedfolder-checkpermission", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public JSONObject selectFolderCheckPermission(HttpServletRequest request, @RequestBody JSONObject jsonObject) throws Exception{
		
		logger.debug("selectFolderCheckPermission start.");
		JSONObject jsonObj = new JSONObject();
		
		LoginVO user = commonUtil.getUserForGw(jsonObject.get("userId").toString(), request.getHeader("x-user-host"));
		String folderId = jsonObject.get("folderId").toString();
		String fileId = jsonObject.get("fileId").toString();
		
		if(StringUtils.isEmpty(folderId) && StringUtils.isEmpty(fileId)){
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
		}
		
		// 퍼미션 체크 해야함 
		try {
			String userId = user.getId();
			String deptId = user.getDeptID();
			String comId = user.getCompanyID();
			int tenantId = user.getTenantId();	
			String fileFolderType = "";
			if (StringUtils.isNotEmpty(folderId)){
				fileFolderType = "D";
			} else {
				folderId = fileId;
				fileFolderType = "F";
			}
			String checkPermission = service.checkPermission(userId, deptId, comId, folderId, fileFolderType, tenantId);
			
			if ( checkPermission.equals("fail")) {
				logger.debug("checkPermission is fail. ");
				jsonObj.put("status", "error");
				jsonObj.put("code"	, 3);
				return jsonObj;
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
			return jsonObj;
		}
		
		jsonObj.put("status", "ok");
		jsonObj.put("code", 0);
		logger.debug("selectFolderCheckPermission end.");
		return jsonObj;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/changeUserFileORFolder/{targetId}/{targetType}", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public JSONObject changeUserFileORFolder(HttpServletRequest request, @PathVariable(value="targetId") String targetId,
			@PathVariable(value="targetType") String targetType, @RequestBody JSONObject jsonObject) throws Exception{
		
		logger.debug("changeUserFileORFolder start.");
		JSONObject jsonObj = new JSONObject();
		LoginVO user = commonUtil.getUserForGw(jsonObject.get("userId").toString(), request.getHeader("x-user-host"));
		
		JSONParser parser      = new JSONParser();
		JSONObject result      = new JSONObject();
		try {
			jsonObject             = (JSONObject) parser.parse(jsonObject.toJSONString());
		} catch (ParseException e1) {
			logger.error(e1.getMessage(), e1);
			result.put("status", "error");
			result.put("code", 2);
			return result;
		}
		String serverName      = request.getHeader("x-user-host") 			!= null ? request.getHeader("x-user-host")    	: "";
		String userId          = jsonObject.get("userId")       			!= null ? (String) jsonObject.get("userId") 	: "";
		String folderUsers     = jsonObject.get("fUsers")       			!= null ? (String) jsonObject.get("fUsers") 	: "";
		String currFolderId    = jsonObject.get("currFolderId")       		!= null ? (String) jsonObject.get("currFolderId") 	: "";
		String subFolderType   	=  (String)jsonObject.get("subFolderType") 	!= null ? (String) jsonObject.get("subFolderType") 	: "0";	// 0 or 1
		
		JSONArray addUserJSON = new JSONArray();
		JSONArray deleteUserJSON = new JSONArray();
		try {
			addUserJSON = (JSONArray) parser.parse((String) jsonObject.get("addUser"));
			deleteUserJSON = (JSONArray) parser.parse((String) jsonObject.get("deleteUser"));
		} catch (ParseException e1) {
			logger.error(e1.getMessage(), e1);
		}
		
		List<String> addUser = new ArrayList<String>();
		List<String> deleteUser = new ArrayList<String>();
		
		for(int i =0; i <addUserJSON.size();i++){
			addUser.add(addUserJSON.get(i).toString());
		}
		for(int i =0; i <deleteUserJSON.size();i++){
			deleteUser.add(deleteUserJSON.get(i).toString());
		}
		
		logger.debug("serverName: {}, userId: {}, folderUsers: {}, deleteUser: {}, addUser: {}",
				serverName, userId, folderUsers, deleteUser, addUser);
		
		if (targetId.equals("") || userId.equals("") || folderUsers.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();

			if (targetType.equalsIgnoreCase("F")) {
				FileVO file = ezWebFolderService.getFileByFileId(targetId, "000|+00:00", tenantId);

				if (file.isReply()) {
					throw new IllegalArgumentException("reply file is not allowed");
				}
			}

			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			String offset = common.getOffSet();
			
			String updateResult = service.changeUserFileORFolder(currFolderId, userId, targetId, folderUsers, targetType, offset, tenantId, 
					(ArrayList<String>)addUser, (ArrayList<String>)deleteUser, subFolderType, userInfo);
	
			if (updateResult.equalsIgnoreCase("OK")){
				result.put("status", "ok");
				result.put("code", "0");
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		logger.debug("changeUserFileORFolder end.");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/webfolderFileDownForUnidocs", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public JSONObject webfolderFileDownForUnidocs(HttpServletRequest request, @RequestBody JSONObject jsonObject) throws Exception{
		
		logger.debug("webfolderFileDownForUnidocs start.");
		
		JSONObject result = new JSONObject();
		String userId = jsonObject.get("userId").toString();
		String version = (String) jsonObject.get("version");
		boolean isVersionFile = version != null && !version.isEmpty();
		String comId = (String) jsonObject.get("comId");
		String serverName = orElse(request.getHeader("x-user-host"), "");
		LoginVO userInfo      = commonUtil.getUserForGw(userId, serverName);
		String offset = userInfo.getOffset();
		
		try {
			logger.debug("userId=" + userId );
			LoginVO user = commonUtil.getUserForGw(userId, request.getHeader("x-user-host"));
			int tenantId = user.getTenantId();
			String fileId = jsonObject.get("fileId").toString();
			
			String adminPage = (String) jsonObject.get("adminPage");
			if(!"admin".equalsIgnoreCase(adminPage)){
				String checkPermission = service.checkPermission(userId, user.getDeptID(), user.getCompanyID(), fileId, "F", tenantId);
				if ("fail".equals(checkPermission)) {
					logger.debug("checkPermission is fail. ");
					result.put("status", "error");
					result.put("code"	, 3);
					return result;
				}
			}
			
			String filePath;
			FileVO filevo = ezWebFolderService.getFileByFileId(fileId, offset, tenantId);
			if (isVersionFile) {
				FileHistoryVO history = ezWebFolderService.getFileHistory(fileId, Integer.parseInt(version), offset, tenantId);
				filePath = history.getFilePath();
				filevo.setFileName(filevo.getFileName() + " ("+ version + ".0)");
				filevo.setFileSize(history.getFileSize());
				history.getFileId();
			} else {
				filePath = filevo.getFilePath();
			}
			
			logger.debug("filevo.setFileName:" + filevo.getFileName());
			String realPath  = request.getServletContext().getRealPath("");
			JSONObject fileDownStatus = commonUtil.unidocsFileDown(filePath, realPath, "webfolder", tenantId);
			String status = fileDownStatus.get("status").toString().toLowerCase();
			int code = (int) fileDownStatus.get("code");
			
			ezWebFolderService.saveLog("V", comId, offset, userId, userInfo.getDisplayName1(), userInfo.getDisplayName2(), 
					tenantId, filevo, version, userInfo.getPrimary());

			if (status.equalsIgnoreCase("OK")) {
				result.put("url", ezCommonService.getTenantConfig("unidocsDomain", tenantId) + "/ezpdf/customLayout.jsp?encdata=");
				result.put("path", fileDownStatus.get("path").toString());
			}
			result.put("status", status);
			result.put("code", code);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
			return result;
		}
		
		logger.debug("webfolderFileDownForUnidocs end.");
		return result ;
	}
}
