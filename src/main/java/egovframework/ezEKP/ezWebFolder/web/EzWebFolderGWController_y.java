package egovframework.ezEKP.ezWebFolder.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
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
			// TODO: commonInfoWeb 안타도록 수정
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String offset = common.getOffSet();
			String lang = common.getLang();
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			
			List<Map<String, String>> permossionIdList = ezWebFolderService_m.getPermissionIdList(userId, userInfo.getDeptID(), userInfo.getCompanyID(), tenantId);
			ezWebFolderService_m.insertIfNotExistRootForder(userId, userInfo.getDisplayName1(), userInfo.getDisplayName2(), userInfo.getCompanyID(), permossionIdList, offset, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 1);
		}
		
		LOGGER.debug("checkRootFolder ended.");
		return result;
	}
	
	/**
	 * 전체 폴더 조회
	 */
	@RequestMapping(value="/rest/ezwebfolder/users/{userId}/folder-list", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject folderList(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("folderList started.");
		
		String serverName 	= orElse(request.getHeader("host-name"), "");
		String admin 		= orElse(request.getHeader("admin"), "");
		String folderId 	= orElse(request.getHeader("folderId"), "");
		String folderType 	= orElse(request.getHeader("folderType"), "");
		LOGGER.debug("userId: " + userId + " || serverName: " + serverName + " || admin: " + admin + " || folderId: " + folderId + "|| folderType: " + folderType);
		
		JSONObject result = new JSONObject();
		
		// 요청  파라미터 비어있을 경우 에러 리턴
		if (userId.equals("") || serverName.equals("")) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			LOGGER.debug("parameter error. folderList ended.");
			return result;
		}
		
		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			String comId     = common.getCompanyId();
			String deptId    = common.getDeptId();
			int tenantId     = common.getTenantId();
			String offset    = common.getOffSet();
			String primary   = common.getPrimary();
			
			List<Map<String, Object>> folderList = service.getFolderList(admin, userId, deptId, comId, folderId, folderType, tenantId, primary);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", folderList);
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.debug("common is not comming");
			result.put("status", "fail");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("folderList ended.");
		return result;
	}
	
	// 폴더 하나를 선택했을때 세부 정보 조회
	@RequestMapping ( value="/rest/ezwebfolder/folders/{folderId}", method = RequestMethod.GET ,produces = "application/json;charset=utf-8" )
	public JSONObject folderListDetail (@PathVariable String folderId , HttpServletRequest request ) {
		JSONObject jsonObj = new JSONObject();
		
		return jsonObj;
		
	}
	
	// 폴더 생성 
	@SuppressWarnings("unchecked")
	@RequestMapping ( value="/rest/ezwebfolder/folders" , method= RequestMethod.POST , produces = "application/json;charset=utf-8")
	public JSONObject folderInsert (HttpServletRequest request,@RequestBody JSONObject jsonObject) throws Exception {
		JSONObject data = new JSONObject();
		// tenantId, upperId, upperId_path, upper_step, upper_level, 
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name") : "";
//		
		String userId = (String) jsonObject.get("id");
		MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
		String folderUppId = (String) jsonObject.get("folderUppId");
		String newFolderName1 = (String) jsonObject.get("newFolderName1");
		String newFolderName2 = (String) jsonObject.get("newFolderName2");
		int tenantId = common.getTenantId();
		String comId = common.getCompanyId();
		String deptId = common.getDeptId();
		String offset = common.getOffSet();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		LOGGER.debug("timeUTC"+ timeUTC);
		// foldervo 가지고 와서 상위의 폴더의 vo를 추린다. 
		FolderVO foldervo= service.getFolderDetail(folderUppId, userId ,tenantId,comId);
		
		// insert후 return 값 성공 : ok 실패 : fail
		String result = service.insertFolder(tenantId, comId , deptId, userId, foldervo.getFolderType(),newFolderName1, newFolderName2, foldervo, timeUTC);
		
		if (result.equals("ok")) {
			data.put("status", "ok");
			data.put("code", 0);
			data.put("data", result);
		}else {
			data.put("status", "fail");
			data.put("code", 1);
			data.put("data", "");
		}
		
		return data;
		
	}
	
	// 폴더 수정 
	@RequestMapping (value = "/rest/ezwebfolder/folders/{folderId}", method = RequestMethod.PUT , produces = "application/json;charset=utf-8")
	public JSONObject folderUpdate (@PathVariable String folderId, HttpServletRequest request,@RequestBody JSONObject jsonObject) throws Exception {
		JSONObject data = new JSONObject();
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name") : "";
		String userId = (String) jsonObject.get("id");
		MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
		
		String newFolderName1 		= (String) jsonObject.get("newFolderName1");
		String newFolderName2 		= (String) jsonObject.get("newFolderName2");
		int tenantId 				= common.getTenantId();
		String comId 				= common.getCompanyId();
		String offset 				= common.getOffSet();
		SimpleDateFormat formatter 	= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  	= new Date();
		String timeUTC             	= commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		service.updateFolder(folderId, tenantId, userId, comId, newFolderName1, newFolderName2, timeUTC);
		return data;
	}
	// 폴더 복사 
	@SuppressWarnings("unchecked")
	@RequestMapping ( value = "/rest/ezwebfolder/folders/{folderId}/{mode}" , method = RequestMethod.PUT , produces ="application/json;charset=utf-8")
	public JSONObject folderCopy (@PathVariable String folderId,@PathVariable String mode, HttpServletRequest request ,Locale locale ,@RequestBody JSONObject jsonObject ) throws Exception  {
		String serverName	= request.getHeader("host-name")      	!= null ?	request.getHeader("host-name") 			: "";
		String lang  		= (String) jsonObject.get("lang")   	!= null ?	(String) jsonObject.get("lang") 		: "";
		String userId		= (String) jsonObject.get("id") 		!= null ?	(String) jsonObject.get("id")			: "";
		String uppId		= (String) jsonObject.get("uppFolderId")!= null ?	(String) jsonObject.get("uppFolderId") 	: "";
		String resmode  	= "";
		JSONObject result   = new JSONObject();
		MCommonVO common;
		try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = common.getTenantId();
			String comId = common.getCompanyId();
			String offset = common.getOffSet();
			LOGGER.debug("folderId :"+folderId + "serverName : "+serverName + "lang : " + lang + "userId : "+userId + "tenantId : "+ tenantId
					+ "comId : " + comId + "offset" + offset);
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			
			if (folderId.equals("") || serverName.equals("") || uppId.equals("") || offset.equals("") || mode.equals("") ) {
				LOGGER.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", "1");
				return result;
			}
			
			int checkSbCreater = 0;
			if (mode.equals("folder-move")) {
				checkSbCreater = service.checkCreater(folderId, tenantId, comId, userId);
				if (checkSbCreater != 1) {
					LOGGER.debug("subFolder or SubFile is not mine!");
					result.put("status", "error");
					result.put("code", "1");
					return result;
			
				}
			}
			FolderVO folder     = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			FolderVO destFolder = ezWebFolderService.getFolderByFolderId(uppId, offset, tenantId);
			//Check copy/move conditions
			if (folder.getFolderUpper().equals(uppId)) {
				result.put("status", "error");
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t224", locale));
				result.put("code", 1);
				return result;
			}
			
			int pos = destFolder.getFolderPath().indexOf(folder.getFolderPath());
		
			if (pos != -1) {
				result.put("status", "error");
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t245", locale));
				result.put("code", 1);
				return result;
			}
			if (mode.equals("folder-move")){
				resmode = "move";
			}else {
				resmode = "copy";
			}
			ezWebFolderAdminService.moveCompanyFolder(folder, destFolder, resmode, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
		
	}
	// 폴더 이동 			
	@SuppressWarnings("unchecked")
	@RequestMapping (value="/rest/ezwebfolder/folders2/{folderId}/folder-move", method = RequestMethod.PUT , produces = "application/json;charset=utf-8" )
	public JSONObject folderMove (@PathVariable String folderId, HttpServletRequest request,@RequestBody JSONObject jsonObject ,Locale locale  )  {
		JSONObject jsonObj = new JSONObject();
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name") 			: "";
		String lang  = (String) jsonObject.get("lang")   		!= null ? (String) jsonObject.get("lang") 		 	: "";
		String userId	= (String) jsonObject.get("id") 		!= null ? (String) jsonObject.get("id")				: "";
		String uppId	= (String) jsonObject.get("uppFolderId")!= null ? (String) jsonObject.get("uppFolderId") 	: "";
		JSONObject result   = new JSONObject();
		MCommonVO common;
		try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId  = common.getTenantId();
			String comId  = common.getCompanyId();
			String offset = common.getOffSet();
			String mode ="move";
			LOGGER.debug("folderId :"+folderId + "serverName : "+serverName + "lang : " + lang + "userId : "+userId + "tenantId : "+ tenantId
					+ "comId : " + comId + "offset" + offset);
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			
			if (folderId.equals("") || serverName.equals("") || uppId.equals("") || offset.equals("") || mode.equals("") || uppId.equals("")) {
				LOGGER.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", "1");
				return result;
			}
			int checkSbCreater = 0;
			checkSbCreater = service.checkCreater(folderId, tenantId, comId, userId);
			
			if (checkSbCreater == 1) {
				FolderVO folder     = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
				FolderVO destFolder = ezWebFolderService.getFolderByFolderId(uppId, offset, tenantId);
				//Check copy/move conditions
				if (folder.getFolderUpper().equals(uppId)) {
					result.put("status", "error");
					result.put("reason", egovMessageSource.getMessage("ezWebFolder.t224", locale));
					result.put("code", 1);
					return result;
				}
				
				int pos = destFolder.getFolderPath().indexOf(folder.getFolderPath());
			
				if (pos != -1) {
					result.put("status", "error");
					result.put("reason", egovMessageSource.getMessage("ezWebFolder.t245", locale));
					result.put("code", 1);
					return result;
				}
				
				ezWebFolderAdminService.moveCompanyFolder(folder, destFolder, mode, userInfo);
				
			result.put("status", "ok");
			result.put("data", "");
			result.put("code", 0);
		
			}else{
				LOGGER.debug("subFolder or SubFile is not mine!");
				result.put("status", "error");
				result.put("code", "1");
				result.put("data", "");
				return result;
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		return result;
	}
	
	// 폴더 삭제 
	@SuppressWarnings("unchecked")
	@RequestMapping(value ="/rest/ezwebfolder/folders2/{folderId}", method = RequestMethod.DELETE , produces = "application/json;charset=utf-8")
	public JSONObject folderDelete (@PathVariable String folderId , HttpServletRequest request,@RequestBody JSONObject jsonObject) {
		JSONObject jsonObj = new JSONObject();
		JSONObject data = new JSONObject();
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name") : "";
//		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String userId = (String) jsonObject.get("id");
		MCommonVO common;
		try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = common.getTenantId();
			String comId = common.getCompanyId();
			String offset = common.getOffSet();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			service.deleteSubFldAFile(folderId, tenantId, comId, userId, timeUTC);
			jsonObj.put("status", "ok");
			jsonObj.put("code", 0);
			jsonObj.put("data", "");
		} catch (Exception e) {
			e.printStackTrace();
			jsonObj.put("status", "fail");
			jsonObj.put("code", 1);
			jsonObj.put("data", "");
		}
		return jsonObj;
	}
	
	// 파일리스트 조회 
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/folders/{folderId}/file-list", method=RequestMethod.GET, produces ="application/json;charset=utf-8")
	public JSONObject fileList (@PathVariable String folderId, HttpServletRequest request)  {
		JSONObject jsonObj = new JSONObject();
		String serverName = request.getHeader("host-name")      			!= null ? request.getHeader("host-name") 			: "";
		String userId = request.getParameter("userId");
		String folderType = request.getParameter("folderType") 				!= null ? request.getParameter("folderType") 		: "" ;
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
		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			String deptId = common.getDeptId();
			int tenantId = common.getTenantId();
			String offset = common.getOffSet();
			String primary = common.getPrimary();
			String comId = common.getCompanyId();
			
			// 자신이 환경설정에 설정해놓은 listCount개수를 가져옴
			int usrListCnt = service.getUsrListCount(tenantId, userId);
			LOGGER.debug(" usrListCnt : " + usrListCnt + "tenantId : " +tenantId + "userId : " + userId);
			int listCount = request.getParameter("listCount") 	!= null ? Integer.parseInt(request.getParameter("listCount")) 	: usrListCnt;
			if ( Integer.parseInt(request.getParameter("listCount")) == 0 ) {
				listCount = usrListCnt ;
			}
			int pStart  =request.getParameter("pStart")			!= null ? Integer.parseInt(request.getParameter("pStart"))		: 0;
			int pEnd = listCount;
			
			if (usrListCnt != listCount) {
				service.insertEnv(userId, tenantId, listCount);
			}
			
			LOGGER.debug("listCount : " + listCount + ", currPage" + currPage+ ", totalpages"+ totalpages + ", pEnd" + pEnd );
			LOGGER.debug("folderId : " + folderId + ", folderType : " + folderType + ", deptId : "+ deptId + ", offset" + offset );
			LOGGER.debug("pStart : " + pStart + ", pEnd : " + pEnd);
			
			// fileCnt : 파일 개수 , fldCnt : 폴더 개수 , totalCount : 파일, 폴더 둘다 합한 개수 ( 페이징 하기 위해 필요 ) 
			Map<String, Integer> cnt = service.getFileToTalCount(folderId,folderType,userId,deptId,tenantId , comId,
					searchExt, searchFileName, searchStartDate, searchEndDate, searchCreateName, searchFileType,
					searchPageCount, pStart, pEnd, offset , primary);
			
			LOGGER.debug("fileListSize : " + cnt + ", searchStartDate" +searchStartDate+", searchEndDate"+searchEndDate );
			
			int fileCnt = cnt.get("fileTotalCnt");
			int fldCnt  = cnt.get("fldTotalCnt");
			totalCount  = cnt.get("totalCount");
			
			if (totalCount%listCount == 0) {
				totalpages = (totalCount/listCount);
			} else {
				totalpages = (totalCount/listCount)+1;
			}
			if ( currPage > totalpages ) {
				currPage = totalpages;
				pStart = (listCount*currPage )-listCount;
				pEnd = listCount;
			}else {
				currPage = currPage;
				pStart = (listCount*currPage )-listCount;
				pEnd = listCount;
			}
			
			
			fileList = service.getFileList(folderId, folderType, userId, deptId, tenantId , comId,
					searchExt, searchFileName, searchStartDate, searchEndDate, searchCreateName, searchFileType,
					searchPageCount, pStart, pEnd, offset, primary);
			LOGGER.debug("fileListSize : " + fileList.size()+ ", searchStartDate : " +searchStartDate+", searchEndDate : "+searchEndDate );
			
			
			FolderVO folder       = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			String folderPath     = folder.getFolderPath();
			String folderPath2     = folder.getFolderPath();
			folderPath            = folderPath.substring(1, folderPath.length() - 1);
			String originalPath   = ezWebFolderService.getFolderPath(folderPath.split("\\|"), primary, tenantId);
			
			LOGGER.debug("OriginalPath: " + originalPath);
					
			Map<String, String> filePathMap = new LinkedHashMap<String, String>();

			if (fileList.size() > 0) {
				String [] rootPath  = folderPath.split("\\|");
				Set<String> testbnk = new HashSet<String>();
				
				for (FileVO file : fileList) {
					String fldPath      = file.getFolderPath().substring(1, file.getFolderPath().length() - 1);
					String[] fldPathArr = fldPath.split("\\|");
					testbnk.addAll(Arrays.asList(fldPathArr));
				}
				
				List<String> listName = new ArrayList<String>(testbnk);
				filePathMap           = ezWebFolderService.getAllFolderNameMap(listName, primary, tenantId);
				
				for (FileVO file : fileList) {
//					LOGGER.debug("--------------------------------");
//					LOGGER.debug("File Id  : " + file.getFileId());
//					LOGGER.debug("File Name: " + file.getFileName());
					
					if (file.getFilePosition() == null || file.getFilePosition().equals("")) {
						String file_path    = originalPath;
						String fldPath      = file.getFolderPath().substring(1, file.getFolderPath().length() - 1);
						String[] fldPathArr = fldPath.split("\\|");
						
						for (int i = rootPath.length; i < fldPathArr.length; i++) {
							file_path += filePathMap.get(fldPathArr[i]) + "/";
						}
						if ( !file.getTypeId().equals("folder") ){
							file_path = file_path.substring(1, file_path.length());
							file.setFilePosition(file_path + file.getFileName());
						}else {
							file_path = file_path.substring(1, file_path.length() - 1);
							file.setFilePosition(file_path );
						}
//							file.setFilePosition(file_path + file.getFileName());
//						LOGGER.debug("Final: " + file_path);
					}
//					LOGGER.debug("--------------------------------");
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
			jsonObj.put("code", 1);
			jsonObj.put("data", "");
		}

		
		return jsonObj;
	}
	
	private <T> T orElse(T value, T other) {
		if (other == null) {
			throw new IllegalArgumentException("other is null!");
		}
		
		return value != null ? value : other;
	}
}
