package egovframework.ezEKP.ezWebFolder.web;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
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

import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;


@RestController
public class EzWebFolderGWController_y {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderGWController_y.class);
	@Resource(name = "EzWebFolderService")
	private EzWebFolderService ezWebFolderService;
	
	@Autowired
	private EzWebFolderService_y service ;
	
	@Autowired
	private MOptionService mOptionService ;
	
	@Autowired
	private CommonUtil commonutil;
	
	
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
			folderList = service.getFolderList(admin,userId,deptId,comId, folderId, folderType, tenantId);
			data.put("status", "ok");
			data.put("code", 0);
			data.put("data", folderList);
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.debug("common is not comming");
			data.put("status", "ok");
			data.put("code", 1);
			data.put("data", "");
			e.printStackTrace();
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
		
		// foldervo 가지고 와서 상위의 폴더의 vo를 추린다. 
		FolderVO foldervo= service.getFolderDetail(folderUppId, userId ,tenantId,comId);
		System.out.println(foldervo.getFolderId());
		
		// insert후 return 값 성공 : ok 실패 : fail
		String result = service.insertFolder(tenantId, comId , userId,  newFolderName1, newFolderName2, foldervo);
		

		System.out.println("여기는 GW입니다.");
		
		if (result.equals("ok")) {
			data.put("status", "ok");
			data.put("code", 0);
			data.put("data", "");
		}else {
			data.put("status", "fail");
			data.put("code", 1);
			data.put("data", "");
		}
		
		return data;
		
	}
	
	// 폴더 수정 
	@RequestMapping (value = "/rest/ezwebfolder/folders/{folderId}", method = RequestMethod.PUT , produces = "application/json;charset=utf-8")
	public JSONObject folderUpdate (@PathVariable String folderId, HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		
		return jsonObj;
	}
	
	// 폴더 이동 
	@RequestMapping (value="/rest/ezwebfolderfolders/{folderId}/folder-move", method = RequestMethod.PUT, produces = "application/json;charset=utf-8" )
	public JSONObject folderMove (@PathVariable String folderId, HttpServletRequest request ) {
		JSONObject jsonObj = new JSONObject();
		
		return jsonObj;
		
	}
	
	// 폴더 복사 
	@RequestMapping ( value = "/rest/ezwebfolder/folders/{folderId}/folder-copy" , method = RequestMethod.PUT , produces ="application/json;charset=utf-8")
	public JSONObject folderCopy (@PathVariable String folderId, HttpServletRequest request ) {
		JSONObject jsonObj = new JSONObject();
		
		
		return jsonObj;
	}
	
	// 폴더 삭제 
	@RequestMapping(value ="/rest/ezwebfolder/folders/{folderId}", method = RequestMethod.DELETE , produces = "application/json;charset=utf-8")
	public JSONObject folderDelete (@PathVariable String folderId , HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		
		return jsonObj;
	}
	
	// 파일리스트 조회 
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezwebfolder/folders/{folderId}/file-list", method=RequestMethod.GET, produces ="application/json;charset=utf-8")
	public JSONObject fileList (@PathVariable String folderId, HttpServletRequest request) {
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
		try {
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = common.getTenantId();
			String offset = common.getOffSet();
			fileList = service.getFileList(folderId,folderType, tenantId , common.getCompanyId(),
					searchExt, searchFileName, searchStartDate, searchEndDate, searchCreateName, searchFileType,
					searchPageCount, searchListCount, pStart, pEnd);
			totalCount = service.getFileToTalCount(folderId,folderType,tenantId , common.getCompanyId(),
					searchExt, searchFileName, searchStartDate, searchEndDate, searchCreateName, searchFileType,
					searchPageCount, searchListCount, pStart, pEnd);
			totalpages = (totalCount/listCount)+1;
			
			
			FolderVO folder       = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			String folderPath     = folder.getFolderPath();
			folderPath            = folderPath.substring(1, folderPath.length() - 1);
			String originalPath   = getFolderPath(folderPath.split("\\|"), offset, tenantId) + folder.getFolderName1() + "/";
			String []rootPath     = folderPath.split("\\|");
			Map<String, String> filePathMap = new LinkedHashMap<String, String>();
			for (FileVO file : fileList) {
//				folderPath     = folder.getFolderPath();
//				if (folder.getFolderUpper().equals("root")) {
	//				if (file.getFilePosition().equals("")) {
						String file_path    = originalPath;
						String fldPath      = file.getFolderPath().substring(1, file.getFolderPath().length() - 1);
						String[] fldPathArr = fldPath.split("\\|");
						
						for (int i = rootPath.length; i < fldPathArr.length - 1; i++) {
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
	//				}
//				}else {
//					folderPath            = folderPath.substring(1, folderPath.length() - 1);
//					originalPath   = getFolderPath(folderPath.split("\\|"), offset, tenantId) + folder.getFolderName1() + "/";
//				}
			}
			//
			
			data.put("fileList", fileList);
			data.put("totalCount", totalCount);
			data.put("totalPages", totalpages );
			data.put("listCount", listCount );
			data.put("currPage", currPage );
			
			
			
			
			jsonObj.put("status", "ok");
			jsonObj.put("code", 0);
			jsonObj.put("data", data);
		} catch (Exception e) {			
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			jsonObj.put("data", "");
		}

		
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
