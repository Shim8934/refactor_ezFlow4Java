package egovframework.ezEKP.ezWebFolder.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;

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
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;


@RestController
public class EzWebFolderGWController_y {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderGWController_y.class);
	
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
	private EgovMessageSource egovMessageSource;
	
	/**
	 * root 폴더 존재 여부 확인 - 존재하지 않을 경우 생성
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId}/checkRootFolder", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkRootFolder(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("checkRootFolder started.");
		
		String serverName = orElse(request.getHeader("host-name"), "");
		LOGGER.debug("userId: " + userId + " || serverName: " + serverName);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (userId.equals("") || serverName.equals("")) {
			result.put("status", "error");
			result.put("code", 1);
			
			LOGGER.debug("parameter error. checkRootFolder ended.");
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
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 2);
		}
		
		LOGGER.debug("checkRootFolder ended.");
		return result;
	}
	
	/**
	 * 폴더 트리 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/users/{userId}/folder-tree", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFolderTree(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("getFolderTree started.");
		
		String serverName 	= orElse(request.getHeader("x-user-host"), "");
		String folderType 	= orElse(request.getParameter("folderType"), "");
		LOGGER.debug("userId: " + userId + " || serverName: " + serverName + "|| folderType: " + folderType);
		
		JSONObject jsonObj = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (userId.equals("") || serverName.equals("")) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			jsonObj.put("data", "");
			
			LOGGER.debug("parameter error. getFolderTree ended.");
			return jsonObj;
		}
		
		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			String deptId    = common.getDeptId();
			String compId    = common.getCompanyId();
			String primary   = common.getPrimary();
			int tenantId     = common.getTenantId();

			List<Map<String, Object>> folderList = service.getFolderTree(userId, deptId, compId, folderType, primary, tenantId);

			jsonObj.put("status", "ok");
			jsonObj.put("code", 0);
			jsonObj.put("data", folderList);
		} catch (Exception e) {
			e.printStackTrace();
			
			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
			jsonObj.put("data", "");
		}
		
		LOGGER.debug("getFolderTree ended.");
		return jsonObj;
	}
	
	// 폴더 생성 
	@SuppressWarnings("unchecked")
	@RequestMapping ( value="/rest/ezwebfolder/folders" , method= RequestMethod.POST , produces = "application/json;charset=utf-8")
	public JSONObject folderInsert (HttpServletRequest request,@RequestBody JSONObject jsonObject) {
		LOGGER.debug("folderInsert started");
		JSONObject jsonObj = new JSONObject();
		String serverName 			= request.getHeader("x-user-host")      != null ? request.getHeader("x-user-host") : "";
		String userId 				= (String) jsonObject.get("userId");

		MCommonVO common;
		try {
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
			LOGGER.debug("timeUTC"+ timeUTC);
			// foldervo 가지고 와서 상위의 폴더의 vo를 추린다. 
			FolderVO foldervo= service.getFolderDetail(folderUppId, userId ,tenantId,comId);
			
			// insert후 return 값 성공 : ok 실패 : fail
			String result = service.insertFolder(tenantId, comId , deptId, userId, foldervo.getFolderType(),newFolderName1, newFolderName2, foldervo, timeUTC);
			
			if (result.equals("ok")) {
				jsonObj.put("status", "ok");
				jsonObj.put("code", 0);
				jsonObj.put("data", result);
			}else {
				jsonObj.put("status", "fail");
				jsonObj.put("code", 2);
				jsonObj.put("data", "");
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObj.put("status", "fail");
			jsonObj.put("code", 2);
			jsonObj.put("data", "");
		}
		
		LOGGER.debug("folderInsert ended");
		return jsonObj;
	}
	
	// 폴더 수정 
	@SuppressWarnings("unchecked")
	@RequestMapping (value = "/rest/ezwebfolder/folders/{folderId}", method = RequestMethod.PUT , produces = "application/json;charset=utf-8")
	public JSONObject folderUpdate (@PathVariable String folderId, HttpServletRequest request,@RequestBody JSONObject jsonObject)  {
		LOGGER.debug("folderUpdate started");
		JSONObject jsonObj = new JSONObject();
		String serverName 	= request.getHeader("x-user-host")      != null ? request.getHeader("x-user-host") : "";
		String userId 		= (String) jsonObject.get("userId");
		MCommonVO common;
		try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			String newFolderName1 		= (String) jsonObject.get("newFolderName1");
			String newFolderName2 		= (String) jsonObject.get("newFolderName2");
			int tenantId 				= common.getTenantId();
			String comId 				= common.getCompanyId();
			String offset 				= common.getOffSet();
			SimpleDateFormat formatter 	= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  	= new Date();
			String timeUTC             	= commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			service.updateFolder(folderId, tenantId, userId, comId, newFolderName1, newFolderName2, timeUTC);
			jsonObj.put("status", "ok");
			jsonObj.put("code", 0);
		} catch (Exception e) {
			e.printStackTrace();
			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
		}
		LOGGER.debug("folderUpdate ended");
		return jsonObj;
	}
	// 폴더 이동, 복사
	@SuppressWarnings("unchecked")
	@RequestMapping ( value = "/rest/ezwebfolder/folders/{folderId}/{mode}" , method = RequestMethod.PUT , produces ="application/json;charset=utf-8")
	public JSONObject folderCopy (@PathVariable String folderId,@PathVariable String mode, HttpServletRequest request ,Locale locale ,@RequestBody JSONObject jsonObject ) {
		LOGGER.debug("folderCopy started");
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
			LOGGER.debug("folderId :" + folderId + ", serverName : "+ serverName + ", userId : " +userId + ", tenantId : " + tenantId
					+ ", comId : " + comId + ", offset" + offset);
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			if (folderId.equals("") || serverName.equals("") || uppId.equals("") || offset.equals("") || mode.equals("") ) {
				LOGGER.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}
			
			FolderVO folder     = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			FolderVO destFolder = ezWebFolderService.getFolderByFolderId(uppId, offset, tenantId);
			int checkSbCreater = 0;
			LOGGER.debug("mode : " + mode + ", folderId : " + folderId + ", destFolder.getFolderPath() : " + destFolder.getFolderPath());
			
			if (mode.equals("folder-move")) {
				
				// 하위의 있는 폴더가 모두 자신의 것이 아닐때
				checkSbCreater = service.checkCreater(folderId, tenantId, comId, userId);
				if (checkSbCreater != 1) {
					LOGGER.debug("subFolder or SubFile is not mine!");
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
				double folderSize           = ezWebFolderAdminService.getFolderSize(folder.getFolderPath(), tenantId);
				UserCapacityVO userCapacity = ezWebFolderAdminService.getUserCapacity(userInfo.getId(), userInfo.getPrimary(), userInfo.getTenantId());
				
				double totalUsed = Double.parseDouble(userCapacity.getTotalUsed());
				double totalCapa = Double.parseDouble(userCapacity.getTotalCapacity()) * 1073741824;
				
				if (folderSize > (totalCapa - totalUsed)) {
					LOGGER.debug("Not enough storage to move/copy this folder!");
					result.put("status", "error");
					result.put("code", 7);
					result.put("data", "");
					return result;
				}
			}
			
			String realPath = request.getServletContext().getRealPath("");
			ezWebFolderAdminService.moveCompanyFolder(folder, destFolder, resmode, realPath, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		LOGGER.debug("folderCopy ended");
		return result;
	}
	
	// 폴더 삭제 
	@SuppressWarnings("unchecked")
	@RequestMapping(value ="/rest/ezwebfolder/folders/{folderId}", method = RequestMethod.DELETE , produces = "application/json;charset=utf-8")
	public JSONObject folderDelete (@PathVariable String folderId , HttpServletRequest request,@RequestBody JSONObject jsonObject) {
		LOGGER.debug("folderDelete started");
		JSONObject jsonObj = new JSONObject();
		JSONObject data = new JSONObject();
		String serverName = request.getHeader("x-user-host")      != null ? request.getHeader("x-user-host") : "";
//		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String userId = (String) jsonObject.get("userId");
		LOGGER.debug((String)jsonObject.get("userId"));
		MCommonVO common;
		try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId 	= common.getTenantId();
			String comId 	= common.getCompanyId();
			String offset 	= common.getOffSet();
			String timeUTC  = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			int result = service.deleteSubFldAFile(folderId, tenantId, comId, userId, timeUTC);
			if (result == 1) {
				jsonObj.put("status", "ok");
				jsonObj.put("code", 0);
			} else if (result == 2) {
				jsonObj.put("status", "error");
				jsonObj.put("code", 4);
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
		}
		LOGGER.debug("folderDelete ended");
		return jsonObj;
	}
	
	// 파일리스트 조회 
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/folders/{folderId}/file-list", method=RequestMethod.GET, produces ="application/json;charset=utf-8")
	public JSONObject fileList (@PathVariable String folderId, HttpServletRequest request)  {
		LOGGER.debug("fileList method start ");
		JSONObject jsonObj = new JSONObject();
		String serverName = request.getHeader("x-user-host")      			!= null ? request.getHeader("x-user-host") 			: "" ;
		String userId = request.getParameter("userId");
		String searchExt = request.getParameter("searchExt")			 	!= null ? request.getParameter("searchExt") 		: "" ;
		String searchFileName = request.getParameter("searchFileName") 		!= null ? request.getParameter("searchFileName")	: "" ;
		String searchStartDate = request.getParameter("searchStartDate")	!= null ? request.getParameter("searchStartDate") 	: "" ;
		String searchEndDate = request.getParameter("searchEndDate") 		!= null ? request.getParameter("searchEndDate") 	: "" ;
		String searchCreateName = request.getParameter("searchCreateName") 	!= null ? request.getParameter("searchCreateName") 	: "" ;
		String searchFileType = request.getParameter("searchFileType") 		!= null ? request.getParameter("searchFileType") 	: "" ;
		String searchPageCount = request.getParameter("searchPageCount") 	!= null ? request.getParameter("searchPageCount") 	: "" ;
		
		int totalCount = request.getParameter("totalCount") 				!= null ? Integer.parseInt(request.getParameter("totalCount"))	: 0;
		int currPage = request.getParameter("currPage") 					!= null ? Integer.parseInt(request.getParameter("currPage")) 	: 1;
		int totalpages = request.getParameter("totalpages") 				!= null ? Integer.parseInt(request.getParameter("totalpages"))	: 1;
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		JSONObject data = new JSONObject();
		if (folderId.equals("") || userId.equals("") ) {
			LOGGER.debug("Parameter error!");
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
			
			// 자신이 환경설정에 설정해놓은 listCount개수를 가져옴
			int usrListCnt = service.getUsrListCount(tenantId, userId);
			
			LOGGER.debug("offset : " + commonUtil.getMinuteUTC(offset));
			LOGGER.debug("usrListCnt : " + usrListCnt + " ||  tenantId : " +tenantId + " || userId : " + userId);
			
			int listCount = request.getParameter("listCount") 	!= null ? Integer.parseInt(request.getParameter("listCount")) 	: usrListCnt;
			if ( Integer.parseInt(request.getParameter("listCount")) == 0 ) {
				listCount = usrListCnt ;
			}
			int pStart = request.getParameter("pStart")			!= null ? Integer.parseInt(request.getParameter("pStart"))		: 0;
			int pEnd = listCount;
			
			if (usrListCnt != listCount) {
				service.insertEnv(userId, tenantId, listCount);
			}
			
			LOGGER.debug("listCount : " + listCount + " || currPage : " + currPage+ " || totalpages : "+ totalpages + " || pEnd : " + pEnd );
			LOGGER.debug("folderId : " + folderId + " || deptId : "+ deptId + " || offset : " + offset );
			LOGGER.debug("pStart : " + pStart + " || pEnd : " + pEnd);
			
			// fileCnt : 파일 개수 , fldCnt : 폴더 개수 , totalCount : 파일, 폴더 둘다 합한 개수 ( 페이징 하기 위해 필요 ) 
			Map<String, Integer> cnt = service.getFileToTalCount(folderId, userId, deptId, tenantId, comId,
					searchExt, searchFileName, searchStartDate, searchEndDate, searchCreateName, searchFileType,
					searchPageCount, pStart, pEnd, offset , primary);
			
			LOGGER.debug("fileListSize : " + cnt + ", searchStartDate" +searchStartDate+", searchEndDate"+searchEndDate );
			
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
			LOGGER.debug("fileListSize : " + fileList.size()+ " || searchStartDate : " +searchStartDate+" || searchEndDate : "+searchEndDate );
			
			
			FolderVO folder       = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			String folderPath     = folder.getFolderPath();
			String folderPath2    = folder.getFolderPath();
			folderPath            = folderPath.substring(1, folderPath.length() - 1);
			String originalPath   = ezWebFolderService.getFolderPath(folderPath.split("\\|"), primary, tenantId);
			
			LOGGER.debug("OriginalPath: " + originalPath);
					
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
						
						if (folder.getFolderUpper().equals("root")) {
							for (int i = rootPath.length; i < fldPathArr.length; i++) {
								file_path += filePathMap.get(fldPathArr[i]) + "/";
							}
						} else {
							for (int i = rootPath.length; i < fldPathArr.length-1; i++) {
								file_path += filePathMap.get(fldPathArr[i]) + "/";
							}
						}
						file_path = file_path.substring(0, file_path.length() - 1);
						file.setFilePosition(file_path );
					}
				}
			}
			FolderVO fldDetail = service.getFolderDetail(folderId, userId, tenantId, comId);
			LOGGER.debug("-------folderUpp" + fldDetail.getFolderUpper());
			data.put("folderUpp", fldDetail.getFolderUpper());
			data.put("folderPath", folderPath2);
			data.put("originalPath", originalPath);
			data.put("fileList", fileList);
			data.put("fileCnt", fileCnt);
			data.put("fldCnt", fldCnt);
			data.put("totalRows", fileCnt+fldCnt);
			data.put("totalPages", totalpages );
			data.put("listCount", listCount );
			data.put("currPage", currPage );
			
			jsonObj.put("status", "ok");
			jsonObj.put("code", 0);
			jsonObj.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.debug(" fail ");
			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
			jsonObj.put("data", "");
		}
		LOGGER.debug("fileList method start ");
		return jsonObj;
	}
	
	private <T> T orElse(T value, T other) {
		if (other == null) {
			throw new IllegalArgumentException("other is null!");
		}
		
		return value != null ? value : other;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/users/{userId}/checkpermission", method=RequestMethod.POST, produces ="application/json;charset=utf-8")
	public JSONObject checkPermission (@PathVariable String userId, @RequestBody JSONObject jsonObject, HttpServletRequest request)  {
		LOGGER.debug("checkPermission started.");
		
		String serverName 	= orElse(request.getHeader("x-user-host"), "");
		
		List<Map<String, Object>> checkList = (List<Map<String, Object>>) jsonObject.get("checkList");
		
		LOGGER.debug("userId: " + userId + " || serverName: " + serverName);
		
		JSONObject jsonObj = new JSONObject();
		
		if (userId.equals("") || serverName.equals("")) {
			jsonObj.put("status"	, "error");
			jsonObj.put("code"		, 1);
			jsonObj.put("data"		, "");
			LOGGER.debug("parameter error. checkPermission ended.");
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
				
				if (checkResult == "fail") {
					LOGGER.debug("this folder conection is not permission ");
					jsonObj.put("status", "error");
					jsonObj.put("code"	, 3);
					LOGGER.debug("fileList method Ended ");
					return jsonObj;
				}
				LOGGER.debug(checkResult);
				
			}
			
			jsonObj.put("status"	, "ok");
			jsonObj.put("code"		, 0);
		} catch (Exception e) {
			e.printStackTrace();
			
			jsonObj.put("status"	, "error");
			jsonObj.put("code"		, 2);
		}
		
		LOGGER.debug("checkPermission ended.");
		return jsonObj;

	}
	
}
