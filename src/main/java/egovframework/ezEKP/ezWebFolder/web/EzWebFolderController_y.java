package egovframework.ezEKP.ezWebFolder.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.JsonObject;
import com.unidocs.cipher.PDFInfoEncrypter;

import egovframework.ezEKP.ezWebFolder.util.EzWebfolderUtil;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.collection.ChainMap;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.rest.Rest;
import egovframework.let.utl.rest.Rest.Module;
import egovframework.let.utl.rest.Result;

@Controller
public class EzWebFolderController_y {

	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderController_y.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private EzWebfolderUtil webfolderUtil;

	@Autowired
	private Rest rest;

	@RequestMapping(value="/ezWebFolder/main.do", method = RequestMethod.GET)
	public String main (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		logger.debug("main started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderType = orElse(request.getParameter("folderType"), "");
		String folderId = request.getParameter("folderId");
		String allFileFlag = orElse(request.getParameter("allFileFlag"),"");
		allFileFlag = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(allFileFlag));
		String parentId = orElse(request.getParameter("parentId"),"");
		boolean usePreview = "1".equalsIgnoreCase(commonUtil.getTenantConfigRest("useImageConvertServer", userInfo.getId(), request));
		boolean useVersionHistory = "YES".equalsIgnoreCase(commonUtil.getTenantConfigRest("useWebfolderVersionHistory", userInfo.getId(), request));
				
		parentId = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(parentId));
		
		logger.debug("folderType : "+ folderType + " folderId : " + request.getParameter("folderId") + "allFileFlag : " + request.getParameter("allFileFlag"));
		
		// 관리자 또는 담당자 flag.
		if (folderType.equals("C")) {
			Result result = rest.gateway(Module.WEBFOLDER, request).url("/rest/ezwebfolder/check-folderManager/" + userInfo.getId()).exchangeResult();
			
			if (result.succeeded()) {
				JsonObject data = result.getDataAsJsonObject();
				model.addAttribute("folderManager", "1");
				model.addAttribute("managedFolderList", data.get("managedFolderList"));
			}
		}

		// 웹폴더 파일 업로드시 1회업로드 제한 체크를 프론트에서도하도록
		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request).url("/rest/ezwebfolder/{0}/upload-limit", userInfo.getId()).exchangeBody();

		if ("ok".equals(resultBody.get("status"))) {
			model.addAttribute("uploadLimit", (double) resultBody.get("uploadLimit"));
		} else {
			model.addAttribute("uploadLimit", -1);
		}

		model.addAttribute("companyId"	, userInfo.getCompanyID());
		
        //Add more function here
		model.addAttribute("folderType"	, folderType);
        model.addAttribute("folderId"	, folderId );
		model.addAttribute("userId"		, userInfo.getId());
        model.addAttribute("lang"		, userInfo.getLang());
        model.addAttribute("allFileFlag", allFileFlag);
        model.addAttribute("parentId"	, parentId);
        model.addAttribute("usePreview"	, usePreview);
        model.addAttribute("useVersionHistory", useVersionHistory);
        
        logger.debug("main ended");
		return "ezWebFolder/webFolderRight";
	}
	
	// getFolderList /ezwebfolder/users/{userId}/folder-tree에 가는 메소드 
	@RequestMapping(value = "/ezWebFolder/folderList.do", method = RequestMethod.POST)
	public @ResponseBody JSONObject getFolderList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFolderList started");

		LoginVO loginVO = commonUtil.userInfo(loginCookie);

		// tenantID, companyId, userId, folderType, folderId
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderType = orElse(request.getParameter("folderType"), "");
		String folderId = orElse(request.getParameter("folderId"), "");
		String isAdmin = orElse(request.getParameter("isAdmin"), "false");

		if ("true".equalsIgnoreCase(isAdmin) && !webfolderUtil.isWebfolderAdmin(loginVO)) {
			isAdmin = "false";
		}

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/users/{0}/folder-tree", userInfo.getId())
				.queryParam("folderType", folderType)
				.queryParam("folderId", folderId)
				.queryParam("isAdmin", isAdmin)
				.exchangeBody();

		logger.debug("getFolderList ended");
		return resultBody;
	}
	
	// 파일 리스트 가져오기 
	@RequestMapping(value = "/ezWebFolder/fileList.do", method = RequestMethod.POST)
	public @ResponseBody Object getFileList (@CookieValue("loginCookie") String loginCookie, @RequestParam String folderId,
			HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		logger.debug("getFileList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String allFileFlag = StringUtils.defaultString(request.getParameter("allFileFlag"));
		
		JSONObject resultBody = null;
		
		Result permissionResult = rest.gateway(Module.WEBFOLDER, request).post()
				.url("/rest/ezwebfolder/users/{0}/checkpermission", userInfo.getId())
				.jsonParam("checkList", Collections.singleton(ChainMap.of("checkId", folderId).add("checkType", "D")))
				.exchangeResult();

		if (permissionResult.failed()) {
			return permissionResult;
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId"		, userInfo.getId());
		
		param.put("totalCount"	, orElse(request.getParameter("totalCount")		, 0));
		param.put("listCount"	, orElse(request.getParameter("listCount")		, 0));
		
		String currPage = request.getParameter("currPage");
		
		if (currPage != null && !currPage.isEmpty()) {
			if (!commonUtil.isIntNumber(currPage)) {
				return new JSONObject();
			}
		}
		
		param.put("currPage"	, orElse(request.getParameter("currPage")		, 0));
		param.put("totalpages"	, orElse(request.getParameter("totalpages")		, 0));
		param.put("pStart"		, orElse(request.getParameter("pStart")			, 0));

		param.put("searchExt"		, orElse(request.getParameter("searchExt")			, ""));
		param.put("searchFileName"	, orElse(request.getParameter("searchFileName")		, ""));
		param.put("searchStartDate"	, orElse(request.getParameter("searchStartDate")	, ""));
		param.put("searchEndDate"	, orElse(request.getParameter("searchEndDate")		, ""));
		param.put("searchCreateName", orElse(request.getParameter("searchCreateName")	, ""));
		param.put("searchFileType"	, orElse(request.getParameter("searchFileType")		, ""));
		param.put("searchPageCount"	, orElse(request.getParameter("searchPageCount")	, ""));
		
		String sortType = orElse(request.getParameter("sortType"), "");
		
		// SQL Injection 방지를 위해 유효한 값을 체크
		if (!sortType.isEmpty() && !sortType.equalsIgnoreCase("DESC") && !sortType.equalsIgnoreCase("ASC")) {
			return new JSONObject();
		}
			
		param.put("sortType"		, sortType);
		param.put("sortColumn"		, orElse(request.getParameter("sortColumn")			, ""));
		
		logger.debug("folderId : " + folderId);
		logger.debug(	"listCount : " + request.getParameter("listCount") 
					+ 	" currPage : " + request.getParameter("currPage")
					+ 	" totalPages"+ request.getParameter("totalpages")  );
		
		if (allFileFlag.equals("all")) {
			resultBody = rest.gateway(Module.WEBFOLDER, request)
					.url("/rest/ezwebfolder/folders/{0}/file-list", folderId)
					.queryParams(param)
					.exchangeBody();
		} else {
			resultBody = rest.gateway(Module.WEBFOLDER, request)
					.url("/rest/ezwebfolder/folders/{0}/file-list2", folderId)
					.queryParams(param)
					.exchangeBody();
		}
		
		logger.debug("getFileList ended");
		return resultBody;
	}
	
	@RequestMapping(value ="/ezWebFolder/folderManage.do", method = RequestMethod.GET)
	public String folderManage(@CookieValue("loginCookie") String loginCookie, @RequestParam String folderType, Model model) throws Exception {
		logger.debug("folderControll started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = userInfo.getId();

		model.addAttribute("userId", userId);
		model.addAttribute("folderType", folderType);

		logger.debug("userId : {}, folderType : {}", userId, folderType);
		logger.debug("folderManage ended");
		return "ezWebFolder/folderManage";
	}
	
	// 새폴더 생성 레이어팝업
	@RequestMapping(value = "/ezWebFolder/inputNameDlg.do", method = RequestMethod.GET)
	public String inputNameDlg() {
		return "ezWebFolder/newFolderInput";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping( value ="/ezWebFolder/insertFolder.do", method = RequestMethod.POST) 
	public @ResponseBody JSONObject insertFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("insertFolder started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderUppId = request.getParameter("folderId");
		String newFolderName1 = request.getParameter("newFolderName1");
		String newFolderName2 = request.getParameter("newFolderName1");
	
		JSONObject jsonObj 	= new JSONObject();
		if ( folderUppId == null || newFolderName1 == null  ) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			logger.debug("must necessary data is not comming. ");
			logger.debug("insertFolder ended");
			return jsonObj;
		}
		
		// checkPermisson 
		// userId, List<map<String, Object>> checkList ( checkId, checkType ) 
		
		JSONObject resultBody = null;
		JSONObject checkPermission = new JSONObject();
		List<Map<String, Object>> checkList = new ArrayList<Map<String,Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("checkId"	, folderUppId);
		map.put("checkType"	, "D");
		
		checkList.add(map);
		checkPermission.put("checkList"	, checkList);
		
		jsonObj.put("userId", userInfo.getId());
		jsonObj.put("folderUppId", folderUppId);
		jsonObj.put("newFolderName1", newFolderName1);
		jsonObj.put("newFolderName2", newFolderName2);
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folders", null, request, "post", jsonObj);
		
		logger.debug("insertFolder ended");
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping( value ="/ezWebFolder/updateFolder.do", method = RequestMethod.POST) 
	public @ResponseBody JSONObject updateFolder (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model ) throws Exception {
		logger.debug("updateFolder started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderId 		= request.getParameter("folderId");
		String newFolderName1 	= request.getParameter("newFolderName1");
		String newFolderName2 	= request.getParameter("newFolderName1");
		
		JSONObject jsonObj 	= new JSONObject();
		if ( folderId == null || newFolderName1 == null || newFolderName2 == null ) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			logger.debug("must necessary data is not comming. ");
			logger.debug("insertFolder ended");
			return jsonObj;
		}
		
		// checkPermisson 
		// userId, List<map<String, Object>> checkList ( checkId, checkType ) 
		
		JSONObject resultBody = null;
		JSONObject checkPermission = new JSONObject();
		List<Map<String, Object>> checkList = new ArrayList<Map<String,Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("checkId"	, folderId);
		map.put("checkType"	, "D");
		
		checkList.add(map);
		checkPermission.put("checkList"	, checkList);
		
		jsonObj.put("userId"		, userInfo.getId());
		jsonObj.put("newFolderName1", newFolderName1);
		jsonObj.put("newFolderName2", newFolderName2);
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folders/"+folderId, 
				null, request, "put", jsonObj);
		
		logger.debug("updateFolder ended");
		return resultBody;
	}
	
	
	@RequestMapping( value ="/ezWebFolder/folderDelete.do", method = RequestMethod.GET) 
	public String folderDelete (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		return "ezWebFolder/folderDelete";
	}
		
	@SuppressWarnings("unchecked")
	@RequestMapping( value ="/ezWebFolder/deleteFolder.do", method=RequestMethod.POST) 
	public @ResponseBody JSONObject deleteFolder (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		logger.debug("deleteFolder started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderId = request.getParameter("folderId");
		
		JSONObject jsonObj 	= new JSONObject();
		if ( folderId == null ) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			logger.debug("must necessary data is not comming. ");
			logger.debug("insertFolder ended");
			return jsonObj;
		}
		
		// checkPermisson 
		// userId, List<map<String, Object>> checkList ( checkId, checkType ) 
		
		JSONObject resultBody = null;
		JSONObject checkPermission = new JSONObject();
		List<Map<String, Object>> checkList = new ArrayList<Map<String,Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("checkId"	, folderId);
		map.put("checkType"	, "D");
		
		checkList.add(map);
		checkPermission.put("checkList"	, checkList);
		
		jsonObj.put("userId", userInfo.getId());
		jsonObj.put("folderId",folderId);
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folder-delete", 
				null, request, "delete", jsonObj);
		
		logger.debug("folderDelete ended");
		return resultBody;
	}
	
	
	@RequestMapping( value ="/ezWebFolder/folderMove.do", method = RequestMethod.GET) 
	public String folderMove (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		return "ezWebFolder/folderMoveJsTree";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping( value ="/ezWebFolder/moveFolder.do", method=RequestMethod.POST) 
	public @ResponseBody JSONObject moveFolder (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		logger.debug("moveFolder started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderId = request.getParameter("folderId");
		String mode		= request.getParameter("mode");
		
		JSONObject jsonObj 	= new JSONObject();
		if (folderId == null || mode == null ) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			logger.debug("must necessary data is not comming. ");
			logger.debug("insertFolder ended");
			return jsonObj;
		}
		
		// checkPermisson 
		// userId, List<map<String, Object>> checkList ( checkId, checkType ) 
		
		JSONObject resultBody = null;
		JSONObject checkPermission = new JSONObject();
		List<Map<String, Object>> checkList = new ArrayList<Map<String,Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("checkId"	, folderId);
		map.put("checkType"	, "D");
		
		checkList.add(map);
		checkPermission.put("checkList"	, checkList);
		
		jsonObj.put("userId", userInfo.getId());
		jsonObj.put("folderId", request.getParameter("folderId"));
		jsonObj.put("uppFolderId", request.getParameter("uppFolderId"));
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folders/"+ folderId + "/"+mode, 
				null, request, "put", jsonObj);
		
		logger.debug("userId : "+ userInfo.getId() + "folderId : "+ request.getParameter("folderId") 
				+ "uppFolderId : "+ request.getParameter("uppFolderId") + "lang : "+ userInfo.getLang());
		
		return resultBody;
	}
	
	private <T> T orElse(T value, T other) {
		if (other == null) {
			throw new IllegalArgumentException("other is null!");
		}
		
		return value != null ? value : other;
	}
	
	/**
	 * 다른 모듈에서 웹폴더의 파일 선택시 선택한 파일의 리스트를 선택할 수 있는 레이어 팝업 호출 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezWebFolder/webfolderFileListPickup.do", method = RequestMethod.GET)
	public String webfolderFileListPickup (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model ) throws Exception {
		logger.debug("webfolderFileListPickup started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String folderType = orElse(request.getParameter("folderType"), "");
		String allFileFlag = orElse(request.getParameter("allFileFlag"),"");
		String parentId = orElse(request.getParameter("parentId"),"");
		String folderId = "";
		
		String mode = orElse(request.getParameter("mode"),"");
		double uploadLimit = -1;

		logger.debug("folderType : {}, allFileFlag : {}, mode : {}", folderType, request.getParameter("allFileFlag"), mode);

		if ("upload".equalsIgnoreCase(mode)) {
			// 웹폴더 파일 업로드시 1회업로드 제한 체크를 프론트에서도하도록
			JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request).url("/rest/ezwebfolder/{0}/upload-limit", userInfo.getId()).exchangeBody();

			if ("ok".equals(resultBody.get("status"))) {
				uploadLimit = (double) resultBody.get("uploadLimit");
			}
		}

		model.addAttribute("mode"	, mode);
		model.addAttribute("uploadLimit", uploadLimit);
		
		JSONObject jsonObj = new JSONObject();
		
		JSONObject existsCheck = null;
		existsCheck = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" +userInfo.getId() + "/checkRootFolder", 
				null, request, "get", jsonObj);
		logger.debug("existsCheck=" + existsCheck);
		if (existsCheck.get("status").equals("error")){
			return "cmm/error/egovError";
		}
		
		jsonObj.put("userId", userInfo.getId());
		jsonObj.put("folderType", folderType);
		jsonObj.put("tenantId", userInfo.getTenantId());
		jsonObj.put("ownerId", userInfo.getDeptID());
		jsonObj.put("comId", userInfo.getCompanyID());
		jsonObj.put("deptId", userInfo.getDeptID());
		jsonObj.put("primary", userInfo.getPrimary());
		
		JSONObject json = null;
		json = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folderidbyuserid-foldertype", 
				null, request, "post", jsonObj);
		logger.debug("json=" + json);
		folderId = json.get("folderId").toString();
		
		List<Map<String,Object>> folderInfo = new ArrayList<Map<String,Object>>();
		folderInfo = (List<Map<String, Object>>) json.get("folderInfo");
	
		model.addAttribute("folderInfo"	, folderInfo);
		model.addAttribute("type", "NEW");
		model.addAttribute("folderType"	, folderType);
        model.addAttribute("folderId"	, folderId);
		model.addAttribute("userId"		, userInfo.getId());
        model.addAttribute("lang"		, userInfo.getLang());
        model.addAttribute("allFileFlag", allFileFlag);
        model.addAttribute("parentId"	, parentId);
        
        logger.debug("webfolderFileListPickup ended");
		return "ezWebFolder/webfolderFileListPickup";
	}
	
	/**
	 * 첨부폴더를 웹폴더에 저장하기 위해서 팝업을 띄우기 어려운 경우
	 * webfolderFileListPickup.jsp로 relay를 해 줄 중간 창을 새창으로 띄운다.
	 */
	@RequestMapping(value="/ezWebFolder/webfolderFileListUploadParent.do", method = RequestMethod.GET)
	public String webfolderFileListUploadParent (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("webfolderFileListUploadParent open.");
		return "ezWebFolder/relay/webfolderFileListUploadParent";
	}

	/**
	 * 다른 모듈에서 웹폴더의 파일 선택시 선택한 파일의 리스트를 선택할 수 있는 레이어 팝업 호출 
	 */
	@RequestMapping(value="/ezWebFolder/webfolderAuthFolderList.do", method = RequestMethod.GET)
	@ResponseBody 
	public JSONObject webfolderAuthFolderList (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp) throws Exception {
		logger.debug("webfolderFileListPickup started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String folderType = orElse(request.getParameter("folderType"), "");
		String allFileFlag = orElse(request.getParameter("allFileFlag"),"");
		String parentId = orElse(request.getParameter("parentId"),"");
		String folderId = "";
		String ownerId = "";
		
		logger.debug("folderType : "+ folderType + ",allFileFlag : " + request.getParameter("allFileFlag"));
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("userId", userInfo.getId());
		jsonObj.put("folderType", folderType);
		jsonObj.put("tenantId", userInfo.getTenantId());
		switch (folderType) {
		case "C":
			ownerId = userInfo.getCompanyID();
			break;
		case "D":
			ownerId = userInfo.getDeptID();
			break;
		case "U":
			ownerId = userInfo.getId();
			break;
		}
		
		jsonObj.put("ownerId", userInfo.getDeptID());
		jsonObj.put("comId", userInfo.getCompanyID());
		jsonObj.put("deptId", userInfo.getDeptID());
		jsonObj.put("primary", userInfo.getPrimary());
		
		JSONObject json = null;
		json = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folderidbyuserid-foldertype", 
				null, request, "post", jsonObj);
		logger.debug("json=" + json);
        logger.debug("webfolderFileListPickup ended");
		return json;
	}
	
	/**
	 * 웹폴더 파일을 다른 모듈로 복사해 갈수 있도록 정보(파일명, 파일경로, 사이즈)전달 
	 * @param loginCookie
	 * @param request
	 * @param response
	 * @return JSONObject 형태로 return 
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/ezWebFolder/selectWebfolderFiletoAnother.do", method = RequestMethod.POST)
	public JSONObject selectWebfolderFiletoAnother (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse response, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("selectWebfolderFiletoAnother started");
		JSONObject result = new JSONObject();
		JSONObject json = new JSONObject();
		
		JSONParser parser = new JSONParser();
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		ArrayList<String> paramJson = (ArrayList<String>) jsonObject.get("fileList");
		String userId = userInfo.getId();
		
		if (paramJson == null || paramJson.size() <= 0){
			return result;
		}
		logger.debug("paramJson=" + paramJson);
		
		json.put("param", paramJson);
		json.put("userId", userId);
		json.put("tenantId", userInfo.getTenantId());
		
		result = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/selectwebfolderfiletoanother", 
				null, request, "post", json);
		
		logger.debug("result=" + result);
		
		
		JSONArray jsonArr = new JSONArray();
		JSONObject fileListData = null;
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		if (result.get("status").toString().equalsIgnoreCase("error")){
			result.clear();
			return result;
		} else {
			list = (ArrayList<Map<String, String>>) result.get("fileList");
			for (int i = 0; i < list.size(); i++){
				fileListData = new JSONObject();
				fileListData.put("fileSize", list.get(i).get("FILE_SIZE"));
				fileListData.put("fileName", list.get(i).get("FILE_NAME"));
				fileListData.put("filePath", list.get(i).get("FILE_PATH"));
				jsonArr.add(fileListData);
			}
		}
		result.clear(); 
		result.put("fileList", jsonArr.toString());
		
		logger.debug("selectWebfolderFiletoAnother end.");
		return result;
	}
	
	@RequestMapping(value = "/ezWebFolder/selectedFolderCheckPermission.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject selectedFolderCheckPermission(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("seletedFolderCheckpermission start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String userId = user.getId();
		String folderId = StringUtils.defaultString(request.getParameter("folderId"));
		String fileId = StringUtils.defaultString(request.getParameter("fileId"));

		logger.debug("userId: {}, folderId: {}, fileId: {}", userId, folderId, fileId);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.post().url("/rest/ezwebfolder/selectedfolder-checkpermission")
				.jsonParam("fileId", fileId)
				.jsonParam("folderId", folderId)
				.jsonParam("userId", userId)
				.exchangeBody();

		logger.debug("seletedFolderCheckpermission end");
		return resultBody;
	}
	
	@RequestMapping(value = "/ezWebFolder/changeUserFileORFolder.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject changeUserFileORFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("seletedFolderCheckpermission start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		
		String currFolderId	  = request.getParameter("currFolderId");
		String targetId       = request.getParameter("targetId");
		String targetType     = request.getParameter("targetType");
		
		String folderUsers    = request.getParameter("folderUsers");
		String addUser     	  = request.getParameter("addUser");
		String deleteUser     = request.getParameter("deleteUser");
		String subFolderType  = request.getParameter("subFolderType");
		
		logger.debug("targetId:" + targetId + ",Folder users:" + folderUsers + ",addUser:" + addUser + ",deleteUser:" + deleteUser 
				+ ",subFolderType:" + subFolderType + "targetType:" + targetType);
		
		JSONObject jsonObject = new JSONObject();
		
		jsonObject.put("currFolderId", currFolderId);
		jsonObject.put("userId", user.getId());
		jsonObject.put("fUsers", folderUsers);
		jsonObject.put("addUser", addUser);
		jsonObject.put("deleteUser", deleteUser);
		jsonObject.put("subFolderType", subFolderType);
		
		logger.debug("jsonObject:{}", jsonObject);
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/changeUserFileORFolder/" + targetId + "/" + targetType, 
				null, request, "post", jsonObject);
		
		logger.debug("seletedFolderCheckpermission end resultBody=" + resultBody);
		return resultBody;
	}
		
	// 카이스트 파일 미리보기시 유니닥스 호출 전 파일을 dec 해서 특정 폴더에 다운받아놓아야함. 
	@ResponseBody
	@RequestMapping(value="/ezWebFolder/webfolderFileDownForUnidocs.do", method = RequestMethod.POST)
	public JSONObject webfolderFileDownForUnidocs (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model, @RequestBody JSONObject jsonObject ) throws Exception {
		logger.debug("webfolderFileDownForUnidocs start.");
		
		JSONObject result = new JSONObject();
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = userInfo.getId();
		
		String folderId 	= jsonObject.get("folderId") 		== null ? "" : jsonObject.get("folderId").toString();
		String fileId 		= jsonObject.get("fileId") 			== null ? "" : jsonObject.get("fileId").toString();
		String version		= jsonObject.get("version") 		== null ? "" : jsonObject.get("version").toString();
		// flag에 따라 모듈들 다운로드 위치 설정
		String filePathFlag	= jsonObject.get("filePathFlag") 	== null ? "" : jsonObject.get("filePathFlag").toString();
		String adminPage	= jsonObject.get("adminPage") 		== null ? "" : jsonObject.get("adminPage").toString();
		
		try {
			if (folderId == "" && fileId == ""){
				throw new Exception();
			}
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("folderId"		, folderId);
			jsonObj.put("fileId"		, fileId);
			jsonObj.put("userId"		, userId);
			jsonObj.put("comId"			, userInfo.getCompanyID());
			jsonObj.put("tenantId"		, userInfo.getTenantId());
			jsonObj.put("filePathFlag"	, filePathFlag);
			jsonObj.put("version", version);
			jsonObj.put("deptId", userInfo.getDeptID());
			jsonObj.put("adminPage", adminPage);
			
			logger.debug("jsonObj=" + jsonObj); 
			JSONObject json = null;
			json = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/webfolderFileDownForUnidocs", 
					null, request, "post", jsonObj);
			logger.debug("json=" + json); 
		
			if (json.get("status").toString().equalsIgnoreCase("OK")){
				String download = "false";
				String print = "false";
				String path = json.get("path").toString();
				String[] param = new String[]{ java.net.URLEncoder.encode( path, "UTF-8" ), download, print};
				String encData = PDFInfoEncrypter.encrypt( param ); 
				result.put("url", json.get("url"));
				result.put("encData", encData);
				result.put("status", "OK");
			} else {
				result.put("status", "ERROR");
				result.put("code", json.get("code"));
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "ERROR");
		}
		
		logger.debug("webfolderFileDownForUnidocs end.");
		return result;
	}

	/**
	 * 2020-12-10 김은실 - (카이스트)회사 폴더별 관리자 지원 기능: 해당폴더가 없음 화면
	 */
	@RequestMapping(value="/ezWebFolder/openWebFolderRightWarning.do", method = RequestMethod.GET)
	public String openWebFolderRightWarning (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model ) throws Exception {
		logger.debug("openWebFolderRightWarning started-end");
		return "ezWebFolder/webFolderRightWarning";
	}
}
