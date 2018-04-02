package egovframework.ezEKP.ezWebFolder.web;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

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
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
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
	private EzWebFolderService_y service ;
	
	@Autowired
	private MOptionService mOptionService ;
	
	@Autowired
	private CommonUtil commonutil;
	
	@Autowired
	private EgovMessageSource egovMessageSource;
	
	// 전체 폴더 조회
	@SuppressWarnings("unchecked")
	@RequestMapping ( value="/rest/ezwebfolder/users/{userId}/folder-list" , method=RequestMethod.GET , produces="application/json;charset=utf-8")
	public JSONObject folderList (@PathVariable String userId ,HttpServletRequest request) {
		JSONObject data = new JSONObject();
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name") : "";
		String admin = request.getParameter("admin") != null ? request.getParameter("admin") : "" ;
		String folderId = request.getParameter("folderId") != null ? request.getParameter("folderId") : "";
		String folderType = request.getParameter("folderType") != null ? request.getParameter("folderType") : "";
		
		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			String comId = common.getCompanyId();
			String deptId = common.getDeptId();
			int tenantId = common.getTenantId();
			List<Map<String, Object>> folderList = new ArrayList< Map<String,Object>>();
			List<Map<String, Object>> deptFolder = new ArrayList< Map<String,Object>>();
			List<Map<String, Object>> addJob = new ArrayList< Map<String,Object>>();
			FolderVO vo = null;
			String createName1 = "";
			String createName2 = "";
			
			// 회사, 부서 , 개인 폴더 본인의 권한을 먼저 조사한 뒤 그것에 맞는 폴더들이 다 있는지 판단 
			// 회사는 회사폴더가 존재해야함 
			// 부서는 겸직부서, 부서장을 판단한뒤 하위 부서, 본인부서, 부서장을 판단한뒤 본인의 하위 부서 
			// 개인은 개인부서가 존재해야함
			
			if ( folderType.equals("D")) {
				createName1 = common.getDeptName();
				createName2 = common.getDeptId();
				// 부서폴더 폴더 존재하는지 판단
				// 부서폴더 존재하는지 판단 위해서는 
				String chk = service.existFolderChk_D(userId, deptId, comId, folderType, tenantId);
				
				if (chk.equals("ok")) {
					System.out.println("성공적으로 insert");
				}else {
					System.out.println("부서폴더 insert하다가 문제가 생겼다구 ");
					LOGGER.debug("common is not comming");
					data.put("status", "fail");
					data.put("code", 1);
					data.put("data", "");
				}
			} else if(folderType.equals("")){
				
			}else {
				// 회사폴더, 개인폴더 
				int chk = service.existFolderChk(userId, deptId, comId, folderType, tenantId);
				// 존재한다.
				if (chk != 0 ) {
					System.out.println("폴더가 존재합니다.");
				}else {
					//폴더가 존재하지 않아 만들어야합니다.
					if (folderType.equals("C")) {
						createName1 = common.getCompanyName();
						createName2 = common.getCompanyName2();
					}else if (folderType.equals("U")) {
						createName1 = common.getUserName();
						createName2 = common.getUserId();
						
					}
					System.out.println("여기는 U");
					System.out.println("createNaem1: "+ createName1);
					System.out.println("createNaem2: "+ createName2);
					String rtFolder = service.insertFolder(tenantId, comId, deptId,userId, folderType,createName1,createName2, vo);
				}
				
			}
			folderList = service.getFolderList(admin,userId,deptId,comId, folderId, folderType, tenantId);
			
			
			
			// 부서폴더 따로 판단하기
//			folderList = service.getFolderList(admin,userId,deptId,comId, folderId, folderType, tenantId);
			
			
//			if ( folderList.size() == 0 ) {
//				if ( folderType.equals("U") ) {
//					createName1 = common.getUserName();
//					createName2 = common.getUserId();
//					System.out.println("여기는 U");
//				}else if (folderType.equals("D") ) {
//					
//					createName1 = common.getDeptName();
//					createName2 = common.getDeptId();
//					System.out.println("여기는 D");
//				}
//				System.out.println("createNaem1: "+ createName1);
//				System.out.println("createNaem2: "+ createName2);
//				String rtFolder = service.insertFolder(tenantId, comId, userId, folderType,createName1,createName2, vo);
//				folderList = service.getFolderList(admin,userId,deptId,comId, folderId, folderType, tenantId);
//			}
			
			
			
			
			data.put("status", "ok");
			data.put("code", 0);
			data.put("data", folderList);
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.debug("common is not comming");
			data.put("status", "fail");
			data.put("code", 1);
			data.put("data", "");
		}

//			LOGGER.debug(folderList.get(0).get("id").toString());
//			data.put ("listTest",folderList.size());
//			data.put("id", userId);
//			data.put("folderId", folderId);
//			data.put("folderType", folderType);
//			data.put("tenantId", tenantId);
		return data;
	}
	
	// 폴더 하나를 선택했을때 세부 정보 조회
	@RequestMapping ( value="/rest/ezwebfolder/folders/{folderId}", method = RequestMethod.GET ,produces = "application/json;charset=utf-8" )
	public JSONObject folderListDetail (@PathVariable String folderId , HttpServletRequest request ) {
		JSONObject jsonObj = new JSONObject();
		
		return jsonObj;
		
	}
	
	// 폴더 생성 
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
		
		// foldervo 가지고 와서 상위의 폴더의 vo를 추린다. 
		FolderVO foldervo= service.getFolderDetail(folderUppId, userId ,tenantId,comId);
		System.out.println(foldervo.getFolderId());
		
		// insert후 return 값 성공 : ok 실패 : fail
		String result = service.insertFolder(tenantId, comId , deptId, userId, foldervo.getFolderType(),newFolderName1, newFolderName2, foldervo);
		

		System.out.println("여기는 GW입니다.");
		
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
//		
		// folderId로 이 폴더create가 나인지 확인해야함
		
		String userId = (String) jsonObject.get("id");
		MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
		
		String newFolderName1 = (String) jsonObject.get("newFolderName1");
		String newFolderName2 = (String) jsonObject.get("newFolderName2");
		int tenantId = common.getTenantId();
		String comId = common.getCompanyId();
		
		service.updateFolder(folderId, tenantId, userId, comId, newFolderName1, newFolderName2);
		return data;
	}
	// 폴더 복사 
	@RequestMapping ( value = "/rest/ezwebfolder/folders/{folderId}/{mode}" , method = RequestMethod.PUT , produces ="application/json;charset=utf-8")
	public JSONObject folderCopy (@PathVariable String folderId,@PathVariable String mode, HttpServletRequest request ,Locale locale ,@RequestBody JSONObject jsonObject ) throws Exception  {
		JSONObject jsonObj = new JSONObject();
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name") : "";
		// folderCopy를 하기 위해서 받아와야 하는거 
		// 1. before folderId,
		// 2. after folderId
		// 폴더 아이디, uppFolder 
		String primary  = (String) jsonObject.get("primary")   != null ? 		(String) jsonObject.get("primary") 		 : "";
		String userId	= (String) jsonObject.get("id") 		!= null ? 		(String) jsonObject.get("id")			 : "";
		String uppId	= (String) jsonObject.get("uppFolderId") != null ?  (String) jsonObject.get("uppFolderId") 	 : "";
		String resmode  = "";
		JSONObject result   = new JSONObject();
		MCommonVO common;
		try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			System.out.println("folderId : "+folderId);
			System.out.println("serverName : "+serverName);
			System.out.println("primary : "+primary);
			System.out.println("userId : "+userId);
			System.out.println("tenantId : "+ common.getTenantId());
			System.out.println("comId : "+common.getCompanyId());
			System.out.println("offset"+common.getOffSet());
			int tenantId = common.getTenantId();
			String comId = common.getCompanyId();
			String offset = common.getOffSet();
			LoginVO userInfo = commonutil.getUserForGw(userId, serverName, primary, offset);
			
			if (folderId.equals("") || serverName.equals("") || uppId.equals("") || offset.equals("") || mode.equals("") || uppId.equals("")) {
				LOGGER.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", "1");
				return result;
			}
			int checkSbCreater = 0;
			if (mode.equals("folder-move")) {
				checkSbCreater = service.checkCreater(folderId, tenantId, comId, userId);
				if (checkSbCreater != 1) {
					System.out.println("실패");
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
	@RequestMapping (value="/rest/ezwebfolder/folders2/{folderId}/folder-move", method = RequestMethod.PUT , produces = "application/json;charset=utf-8" )
	public JSONObject folderMove (@PathVariable String folderId, HttpServletRequest request,@RequestBody JSONObject jsonObject ,Locale locale  )  {
		JSONObject jsonObj = new JSONObject();
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name") : "";
		// folderCopy를 하기 위해서 받아와야 하는거 
		// 1. before folderId,
		// 2. after folderId
		// 폴더 아이디, uppFolder 
		String primary  = (String) jsonObject.get("primary")   != null ? 		(String) jsonObject.get("primary") 		 : "";
		String userId	= (String) jsonObject.get("id") 		!= null ? 		(String) jsonObject.get("id")			 : "";
		String uppId	= (String) jsonObject.get("uppFolderId") != null ?  (String) jsonObject.get("uppFolderId") 	 : "";
		JSONObject result   = new JSONObject();
		MCommonVO common;
		try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			System.out.println("folderId : "+folderId);
			System.out.println("serverName : "+serverName);
			System.out.println("primary : "+primary);
			System.out.println("userId : "+userId);
			System.out.println("tenantId : "+ common.getTenantId());
			System.out.println("comId : "+common.getCompanyId());
			System.out.println("offset"+common.getOffSet());
			int tenantId = common.getTenantId();
			String comId = common.getCompanyId();
			String offset = common.getOffSet();
			String mode ="move";
			LoginVO userInfo = commonutil.getUserForGw(userId, serverName, primary, offset);
			
			if (folderId.equals("") || serverName.equals("") || uppId.equals("") || offset.equals("") || mode.equals("") || uppId.equals("")) {
				LOGGER.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", "1");
				return result;
			}
			int checkSbCreater = 0;
			checkSbCreater = service.checkCreater(folderId, tenantId, comId, userId);
			
			if (checkSbCreater == 1) {
				// result 1이면 creater가 모두 자신이라는 의미 
//				FolderVO folder  = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
				
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
			result.put("code", 0);
		
			}else{
				System.out.println("실패");
				LOGGER.debug("subFolder or SubFile is not mine!");
				result.put("status", "error");
				result.put("code", "1");
				return result;
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
			
		
		return result;
	}
	
	// 폴더 삭제 
	@RequestMapping(value ="/rest/ezwebfolder/folders2/{folderId}", method = RequestMethod.DELETE , produces = "application/json;charset=utf-8")
	public JSONObject folderDelete (@PathVariable String folderId , HttpServletRequest request,@RequestBody JSONObject jsonObject) throws Exception {
		JSONObject jsonObj = new JSONObject();
		JSONObject data = new JSONObject();
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name") : "";
//		
		String userId = (String) jsonObject.get("id");
		MCommonVO common;
//		try {
			common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = common.getTenantId();
			String comId = common.getCompanyId();
			service.deleteSubFldAFile(folderId, tenantId, comId, userId);
//			data.put("result", "delete성공");
			jsonObj.put("data", "ok");
//		} catch (Exception e) {
			// TODO Auto-generated catch block
//			e.printStackTrace();
//			data.put("result", "실패");
//			jsonObj.put("data", "fail");
//		}
		
		
		
		
		return jsonObj;
	}
	
	// 파일리스트 조회 
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/folders/{folderId}/file-list", method=RequestMethod.GET, produces ="application/json;charset=utf-8")
	public JSONObject fileList (@PathVariable String folderId, HttpServletRequest request) throws Exception {
		JSONObject jsonObj = new JSONObject();
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name") : "";
		String userId = request.getParameter("userId");
		String folderType = request.getParameter("folderType") != null ? request.getParameter("folderType") : "" ;
		String searchExt = request.getParameter("searchExt") != null ? request.getParameter("searchExt") : "" ;
		String searchFileName = request.getParameter("searchFileName") != null ? request.getParameter("searchFileName") : "" ;
		String searchStartDate = request.getParameter("searchStartDate") != null ? request.getParameter("searchStartDate") : "" ;
		String searchEndDate = request.getParameter("searchEndDate") != null ? request.getParameter("searchEndDate") : "" ;
		String searchCreateName = request.getParameter("searchCreateName") != null ? request.getParameter("searchCreateName") : "" ;
		String searchFileType = request.getParameter("searchFileType") != null ? request.getParameter("searchFileType") : "" ;
		String searchPageCount = request.getParameter("searchPageCount") != null ? request.getParameter("searchPageCount") : "" ;
		String searchListCount = request.getParameter("searchListCount") != null ? request.getParameter("searchListCount") : "" ;
		
		int totalCount = request.getParameter("totalCount") != null ? Integer.parseInt(request.getParameter("totalCount")) : 0;
		int listCount = request.getParameter("listCount") != null ? Integer.parseInt(request.getParameter("listCount")) : 10;
		int currPage = request.getParameter("currPage") != null ? Integer.parseInt(request.getParameter("currPage")) : 1;
		int totalpages = request.getParameter("totalpages") != null ? Integer.parseInt(request.getParameter("totalpages")) : 1;
		
		int pEnd = Integer.parseInt(request.getParameter("pEnd"));
		int pStart  = Integer.parseInt(request.getParameter("pStart"));
		
		System.out.println("folderType " + folderType);
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		JSONObject data = new JSONObject();
//		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			String deptId = common.getDeptId();
			int tenantId = common.getTenantId();
			String offset = common.getOffSet();
			fileList = service.getFileList(folderId, folderType, userId, deptId, tenantId , common.getCompanyId(),
					searchExt, searchFileName, searchStartDate, searchEndDate, searchCreateName, searchFileType,
					searchPageCount, searchListCount, pStart, pEnd);
			Map<String, Integer> cnt = service.getFileToTalCount(folderId,folderType,userId,deptId,tenantId , common.getCompanyId(),
					searchExt, searchFileName, searchStartDate, searchEndDate, searchCreateName, searchFileType,
					searchPageCount, searchListCount, pStart, pEnd);
			int fileCnt = cnt.get("fileTotalCnt");
			int fldCnt = cnt.get("fldTotalCnt");
			totalCount = cnt.get("totalCount");
			if (totalCount%listCount == 0) {
				totalpages = (totalCount/listCount);
			}else {
				totalpages = (totalCount/listCount)+1;
			}
			
			
			FolderVO folder       = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			String folderPath     = folder.getFolderPath();
			String folderPath2     = folder.getFolderPath();
			folderPath            = folderPath.substring(1, folderPath.length() - 1);
			String originalPath   = getFolderPath(folderPath.split("\\|"), offset, tenantId) + folder.getFolderName1() + "/";
			String []rootPath     = folderPath.split("\\|");
			Map<String, String> filePathMap = new LinkedHashMap<String, String>();
			if (folder.getFolderUpper().equals("root")) {
				for (FileVO file : fileList) {
						String file_path    = originalPath;
						String fldPath      = file.getFolderPath().substring(1, file.getFolderPath().length() - 1);
						String[] fldPathArr = fldPath.split("\\|");
						System.out.println("rootPath.lengh = "+rootPath.length);
						for (int i = rootPath.length; i < fldPathArr.length ; i++) {
							if (filePathMap.containsKey(fldPathArr[i])) {
								file_path += filePathMap.get(fldPathArr[i]) + "/";
							}
							else {
								FolderVO _folder = ezWebFolderService.getFolderByFolderId(fldPathArr[i], offset, tenantId);
								file_path       += _folder.getFolderName1() + "/";
								filePathMap.put(fldPathArr[i], _folder.getFolderName1());
							}
						}
						
						file.setFilePosition(file_path + file.getFileName());
				}
			} else {
//				folderPath            = folderPath.substring(1, folderPath.length() - 1);
//				originalPath   = getFolderPath(folderPath.split("\\|"), offset, tenantId) + folder.getFolderName1() + "/";
			}
			//
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
//		} catch (Exception e) {			
//			System.out.println("GW에서 나는 에러라구");
//			jsonObj.put("status", "error");
//			jsonObj.put("code", 1);
//			jsonObj.put("data", "");
//		}

		
		return jsonObj;
	}
	
	private String getFolderPath(String[] path, String offset, int tenantId) throws Exception {
		String result = "/";
		
		for (int i = 0; i < path.length - 1; i++) {
			FolderVO parentFolder = ezWebFolderService.getFolderByFolderId(path[i], offset, tenantId);
			result               += parentFolder.getFolderName1() + "/";
		}
		
		return result;
	}
	
}
