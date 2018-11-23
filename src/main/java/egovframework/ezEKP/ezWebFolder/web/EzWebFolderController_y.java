package egovframework.ezEKP.ezWebFolder.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderController_y {

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderController_y.class);
	
	@RequestMapping(value="/ezWebFolder/main.do")
	public String main (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		LOGGER.debug("main started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderType = orElse(request.getParameter("folderType"), "");
		String folderId = request.getParameter("folderId");
		String allFileFlag = orElse(request.getParameter("allFileFlag"),"");
		LOGGER.debug("folderType : "+ folderType + " folderId : " + request.getParameter("folderId") + "allFileFlag : " + request.getParameter("allFileFlag"));
		
        //Add more function here
		model.addAttribute("folderType"	, folderType);
        model.addAttribute("folderId"	, folderId );
		model.addAttribute("userId"		, userInfo.getId());
        model.addAttribute("lang"		, userInfo.getLang());
        model.addAttribute("allFileFlag", allFileFlag);
        
        LOGGER.debug("main ended");
		return "ezWebFolder/webFolderRight";
	}
	
	// getFolderList /ezwebfolder/users/{userId}/folder-tree에 가는 메소드 
	@RequestMapping(value = "/ezWebFolder/folderList.do")
	public @ResponseBody String getFolderList (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model ){
		LOGGER.debug("getFolderList started");
		
		// tenantID, companyId, userId, folderType, folderId
		LoginSimpleVO userInfo 	= commonUtil.userInfoSimple(loginCookie);
		String folderType 		= orElse(request.getParameter("folderType")	, "");
		String folderId 		= orElse(request.getParameter("folderId")	, ""); 
		
		JSONObject resultBody = null;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("folderType"	, folderType);
		param.put("folderId"	, folderId);
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" +userInfo.getId() + "/folder-tree", 
				param, request, "get", null);
		
		LOGGER.debug("getFolderList ended");
		return resultBody.toString();
		
	}
	
	// 파일 리스트 가져오기 
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezWebFolder/fileList.do")
	public @ResponseBody String getFileList (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		LOGGER.debug("getFileList started");
		
		LoginSimpleVO userInfo 	= commonUtil.userInfoSimple(loginCookie);
		JSONObject jsonObj 	= new JSONObject();
		String folderId 		= request.getParameter("folderId");
		String allFileFlag  	= orElse(request.getParameter("allFileFlag"),"");
		
		if (folderId == null) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			LOGGER.debug("getFileList ended");
			return jsonObj.toString();
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
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/"+userInfo.getId()+"/checkpermission", 
				null, request, "post", checkPermission);

		if (resultBody.get("status").equals("error")) {
			return resultBody.toString();
		} else {
			resultBody = null;
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId"		, userInfo.getId());
		
		param.put("totalCount"	, orElse(request.getParameter("totalCount")		, 0));
		param.put("listCount"	, orElse(request.getParameter("listCount")		, 0));
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
		
		LOGGER.debug("folderId : " + folderId);
		LOGGER.debug(	"listCount : " + request.getParameter("listCount") 
					+ 	" currPage : " + request.getParameter("currPage")
					+ 	" totalPages"+ request.getParameter("totalpages")  );
		
		if (allFileFlag.equals("all")) {
			resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folders/" + folderId + "/file-list",
					param, request, "get", null);
		} else {
			resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folders/" + folderId + "/file-list2",
					param, request, "get", null);
		}
		
		LOGGER.debug("getFileList ended");
		return resultBody.toString();
	}
	
	@RequestMapping( value ="/ezWebFolder/folderManage.do")
	public String folderManage (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp , Model model ) throws Exception {
		LOGGER.debug("folderControll started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderType = request.getParameter("folderType");
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("folderType", folderType);
		
		LOGGER.debug("userId : " + userInfo.getId() + "folderType : " + folderType);
		
		LOGGER.debug("folderManage ended");
		return "ezWebFolder/folderManage";
		
	}
	
	// 새폴더 생성 레이어팝업
	@RequestMapping( value ="/ezWebFolder/inputNameDlg.do")
	public String inputNameDlg (@CookieValue("loginCookie") String loginCookie, HttpServletRequest requtest,
			HttpServletResponse resp , Model model ) throws Exception {
		return "ezWebFolder/newFolderInput";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping( value ="/ezWebFolder/insertFolder.do") 
	public @ResponseBody String insertFolder (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		LOGGER.debug("insertFolder started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderUppId = request.getParameter("folderId");
		String newFolderName1 = request.getParameter("newFolderName1");
		String newFolderName2 = request.getParameter("newFolderName2");
	
		JSONObject jsonObj 	= new JSONObject();
		if ( folderUppId == null || newFolderName1 == null || newFolderName2 == null ) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			LOGGER.debug("must necessary data is not comming. ");
			LOGGER.debug("insertFolder ended");
			return jsonObj.toString();
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
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/"+userInfo.getId()+"/checkpermission", 
				null, request, "post", checkPermission);

		if (resultBody.get("status").equals("error")) {
			return resultBody.toString();
		} else {
			resultBody = null;
		}
		
		jsonObj.put("userId", userInfo.getId());
		jsonObj.put("folderUppId", folderUppId);
		jsonObj.put("newFolderName1", newFolderName1);
		jsonObj.put("newFolderName2", newFolderName2);
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folders", null, request, "post", jsonObj);
		
		LOGGER.debug("insertFolder ended");
		return resultBody.toString();
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping( value ="/ezWebFolder/updateFolder.do") 
	public @ResponseBody String updateFolder (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		LOGGER.debug("updateFolder started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderId 		= request.getParameter("folderId");
		String newFolderName1 	= request.getParameter("newFolderName1");
		String newFolderName2 	= request.getParameter("newFolderName2");
		
		JSONObject jsonObj 	= new JSONObject();
		if ( folderId == null || newFolderName1 == null || newFolderName2 == null ) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			LOGGER.debug("must necessary data is not comming. ");
			LOGGER.debug("insertFolder ended");
			return jsonObj.toString();
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
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/"+userInfo.getId()+"/checkpermission", 
				null, request, "post", checkPermission);

		if (resultBody.get("status").equals("error")) {
			return resultBody.toString();
		} else {
			resultBody = null;
		}
		
		jsonObj.put("userId"		, userInfo.getId());
		jsonObj.put("newFolderName1", newFolderName1);
		jsonObj.put("newFolderName2", newFolderName2);
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folders/"+folderId, 
				null, request, "put", jsonObj);
		
		LOGGER.debug("updateFolder ended");
		return resultBody.toString();
	}
	
	
	@RequestMapping( value ="/ezWebFolder/folderDelete.do") 
	public String folderDelete (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		return "ezWebFolder/folderDelete";
	}
		
	@SuppressWarnings("unchecked")
	@RequestMapping( value ="/ezWebFolder/deleteFolder.do", method=RequestMethod.POST) 
	public @ResponseBody String deleteFolder (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		LOGGER.debug("deleteFolder started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderId = request.getParameter("folderId");
		
		JSONObject jsonObj 	= new JSONObject();
		if ( folderId == null ) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			LOGGER.debug("must necessary data is not comming. ");
			LOGGER.debug("insertFolder ended");
			return jsonObj.toString();
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
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/"+userInfo.getId()+"/checkpermission", 
				null, request, "post", checkPermission);

		if (resultBody.get("status").equals("error")) {
			return resultBody.toString();
		} else {
			resultBody = null;
		}
		
		jsonObj.put("userId", userInfo.getId());
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folders/"+folderId, 
				null, request, "delete", jsonObj);
		
		LOGGER.debug("folderDelete ended");
		return resultBody.toString();
	}
	
	
	@RequestMapping( value ="/ezWebFolder/folderMove.do") 
	public String folderMove (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		return "ezWebFolder/folderMoveJsTree";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping( value ="/ezWebFolder/moveFolder.do", method=RequestMethod.POST) 
	public @ResponseBody String moveFolder (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		LOGGER.debug("moveFolder started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderId = request.getParameter("folderId");
		String mode		= request.getParameter("mode");
		
		JSONObject jsonObj 	= new JSONObject();
		if (folderId == null || mode == null ) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			LOGGER.debug("must necessary data is not comming. ");
			LOGGER.debug("insertFolder ended");
			return jsonObj.toString();
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
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/"+userInfo.getId()+"/checkpermission", 
				null, request, "post", checkPermission);

		if (resultBody.get("status").equals("error")) {
			return resultBody.toString();
		} else {
			resultBody = null;
		}
		
		jsonObj.put("userId", userInfo.getId());
		jsonObj.put("folderId", request.getParameter("folderId"));
		jsonObj.put("uppFolderId", request.getParameter("uppFolderId"));
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folders/"+ folderId + "/"+mode, 
				null, request, "put", jsonObj);
		
		LOGGER.debug("userId : "+ userInfo.getId() + "folderId : "+ request.getParameter("folderId") 
				+ "uppFolderId : "+ request.getParameter("uppFolderId") + "lang : "+ userInfo.getLang());
		
		return resultBody.toString();
	}
	
	private <T> T orElse(T value, T other) {
		if (other == null) {
			throw new IllegalArgumentException("other is null!");
		}
		
		return value != null ? value : other;
	}
}
