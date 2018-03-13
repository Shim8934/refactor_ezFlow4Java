package egovframework.ezEKP.ezJournal.web;

import java.io.File;
import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.google.gson.Gson;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezJournal.vo.JournalInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournalVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.JsonUtil;

@Controller
public class EzJournalJYController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalJYController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	/**
	 * 업무일지 작성 화면 호출
	 */
	@RequestMapping(value="/ezJournal/journalWrite.do")
	public String journalWrite(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("journalWrite started");
		
		// 여기만 우선 userInfo 사용! userName 받아오는 문제때문..
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String offset = userInfo.getOffset();
		String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyyMMdd"), offset, false);
//		nowDate = nowDate.substring(0, 10);
//		nowDate = nowDate.replace("-", "");
		String mode = request.getParameter("mode");
		String typeId = request.getParameter("typeId");
		String useEditor = commonUtil.getTenantConfigRest("EDITOR", userInfo.getId(), request);
		String journalId = "";
		
		if (request.getParameter("journalId") != null && !request.getParameter("journalId").equals("")) {
			journalId = request.getParameter("journalId");
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("userId", userInfo.getId());
		param.put("used", "use");
		
		String restUrl = "/rest/ezjournal/types";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray typeList = (JSONArray) result.get("data");
			model.addAttribute("typeList", typeList);
		}
		
		model.addAttribute("nowDate", nowDate);
		model.addAttribute("typeId", typeId);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("mode", mode);
		model.addAttribute("info", userInfo);
		model.addAttribute("journalId", journalId);
		model.addAttribute("userId", userInfo.getId());
		
		logger.debug("journalWrite ended");
		
		return "/ezJournal/journalWrite";
	}
	
	
	/**
	 * 업무일지 일지함의 양식리스트 가져오기
	 */
	@RequestMapping(value = "/ezJournal/getFormList.do")
	@ResponseBody
	public JSONArray getFormList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("getFormList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String typeId = request.getParameter("typeId");
		if (typeId == null || typeId.equals("")) {
			typeId = "basic";
		}
		String deptId = request.getParameter("deptId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("deptId", deptId);
		
		String restUrl = "/rest/ezjournal/types/" + typeId + "/forms";
		
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
	
		String status = result.get("status").toString();
		
		JSONArray formList = null;
		if (status.equals("ok")) {
			formList = (JSONArray) result.get("data");
			logger.debug("formList : " + formList);
		}
		
		logger.debug("getFormList ended");
		return formList;
	}
	
	/**
	 * 수신자 선택화면 호출
	 */
	@RequestMapping(value = "/ezJournal/selectReceiver.do")
	public String selectReceiver(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("selectReceiver started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject result = commonUtil.getJsonFromRestApi("/rest/ezjournal/depts", param, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray deptList = (JSONArray) result.get("data");
			
			for (int i = 0; i < deptList.size(); i++) {
				JSONObject dept = (JSONObject) deptList.get(i);
				
				if (dept.get("isComp").equals("comp")) {
					dept.put("icon", "icon-company");
				} else {
					dept.put("icon", "icon-dept");
				}
				
				if (dept.get("myDept").equals("yes")) {
					JSONObject state = new JSONObject();
					state.put("selected", "true");
					dept.put("state", state);
				}
			}
			model.addAttribute("deptList", deptList);
			model.addAttribute("userId", userInfo.getId());
		}		
		logger.debug("selectReceiver ended");
		return "/ezJournal/journalSelectReceiver";
	}
	
	/**
	 * 수신자 즐겨찾기 저장 화면 호출 
	 */
	@RequestMapping(value = "/ezJournal/receiverLineName.do")
	public String receiverLineName(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("receiverLineName started");
	
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = userInfo.getId();
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("userId", userId);
		
		logger.debug("receiverLineName ended");
		return "/ezJournal/journalReceiverLineName";
	}
	
	/**
	 * 수신자 즐겨찾기 저장  
	 */
	@RequestMapping(value = "/ezJournal/saveReceiverFavorite.do")
	public String saveReceiverFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("saveReceiverFavorite started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = userInfo.getId();
		
		String receiverList = request.getParameter("receiverLine");
		String favoriteName = request.getParameter("favoriteName");
		String type = request.getParameter("type");
		String favoriteId = request.getParameter("favoriteId");
		logger.debug("receiverLine : " + receiverList + ",favoriteName : " + favoriteName + ",type : " + type + ",favoriteId : " + favoriteId);
		
		JSONObject param = new JSONObject();
		
		param.put("userId", userId);
		param.put("favoriteName", favoriteName);
		param.put("receiverList", receiverList);
		param.put("favoriteId", favoriteId);
		
		String restUrl = "";
		JSONObject result = new JSONObject();
		
		if (type.trim().equals("mod")) {
			restUrl = "/rest/ezjournal/users/" + userId + "/favorites/" + favoriteId;
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "put", param);
		} else {
			restUrl = "/rest/ezjournal/users/" + userId + "/favorites";
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "post", param);
		}
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		
		logger.debug("saveReceiverFavorite ended");
		return "json";
	}
	
	/**
	 * 수신자 즐겨찾기 리스트 가져오기
	 */
	@RequestMapping(value = "/ezJournal/getFavoriteList.do")
	public String getFavoriteList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("getFavoriteList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = request.getParameter("userId");
		if (userId == null || userId.equals("")) {
			userId = userInfo.getId();
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		String restUrl = "/rest/ezjournal/users/" + userId + "/favorites";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray favoriteList = (JSONArray) result.get("data");
			model.addAttribute("favoriteList", favoriteList);
			logger.debug("favoriteList : " + favoriteList);
		}
		
		logger.debug("getFavoriteList started");
		return "/ezJournal/journalFavoriteList";
	}
	
	/**
	 * 즐겨찾기 아이디에 해당하는 수신자 리스트 가져오기
	 */
	@RequestMapping(value = "/ezJournal/getFavoriteUser.do")
	public String getFavoriteUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("getFavoriteUser started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = request.getParameter("userId");
		if (userId == null || userId.equals("")) {
			userId = userInfo.getId();
		}
		String favoriteId = request.getParameter("favoriteId");
		logger.debug("favoriteId : " + favoriteId);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		String restUrl = "/rest/ezjournal/users/" + userId + "/favorites/" + favoriteId + "/users";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray userList = (JSONArray) result.get("data");
			model.addAttribute("userList", userList);
			logger.debug("userList : " + userList);
		}
		logger.debug("getFavoriteUser ended");
		return "/ezJournal/journalFavoriteUser";
	}
	
	/**
	 * 즐겨찾기 수신자 적용
	 */
	@RequestMapping(value = "/ezJournal/applyFavoriteUser.do")
	@ResponseBody
	public String applyFavoriteUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("applyFavoriteUser started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = request.getParameter("userId");
		if (userId == null || userId.equals("")) {
			userId = userInfo.getId();
		}
		String favoriteId = request.getParameter("favoriteId");
		logger.debug("favoriteId : " + favoriteId);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		String restUrl = "/rest/ezjournal/users/" + userId + "/favorites/" + favoriteId + "/users";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray userList = (JSONArray) result.get("data");
			logger.debug("userList : " + userList);
			return JsonUtil.ListToJson(userList);
		}
		logger.debug("applyFavoriteUser ended");
		return JsonUtil.OneStringToJson("json");
	}
	
	/**
	 * 즐겨찾기 삭제
	 */
	@RequestMapping(value = "/ezJournal/deleteFavorite.do")
	@ResponseBody
	public String deleteFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("deleteFavorite started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = request.getParameter("userId");
		if (userId == null || userId.equals("")) {
			userId = userInfo.getId();
		}
		String favoriteId = request.getParameter("favoriteId");
		logger.debug("favoriteId : " + favoriteId);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		String restUrl = "/rest/ezjournal/users/" + userId + "/favorites/" + favoriteId;
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "delete", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		logger.debug("deleteFavorite ended");
		return JsonUtil.OneStringToJson("json");
	}
	
	/**
	 * 업무일지 양식 폼 호출
	 */
	@RequestMapping(value = "/ezJournal/journalGetForm.do", produces="application/json; charset=utf-8")
	@ResponseBody
	public String journalGetForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("journalGetForm started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String formId = request.getParameter("formId");
		String typeId = request.getParameter("typeId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String restUrl = "/rest/ezjournal/types/" + typeId + "/forms/" + formId;
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject jsonResult = (JSONObject) result.get("data");
			param.clear();
			param.put("formName", jsonResult.get("formName"));
			param.put("formContent", jsonResult.get("formContent"));
			param.put("formStatus", jsonResult.get("formStatus"));
			logger.debug("resultparam 확인 : " + param);
			return JsonUtil.MapToJson(param);
		}

		logger.debug("journalGetForm ended");
		return JsonUtil.OneStringToJson("json");
	}
	
	/**
	 * 업무일지 마지막 사용양식 아이디 가져오기
	 */
	@RequestMapping(value = "/ezJournal/journalGetLastForm.do", produces="application/json; charset=utf-8")
	@ResponseBody
	public String journalGetLastForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("journalGetLastForm started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String formId = "last";
		String typeId = request.getParameter("typeId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("isGetForm", "isGetForm");
		
		String restUrl = "/rest/ezjournal/types/" + typeId + "/forms/" + formId;
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			String lastId = result.get("data").toString();
			logger.debug("lastFormId : " + lastId);
			return JsonUtil.OneStringToJson(lastId);
		}
		
		logger.debug("journalGetLastForm ended");
		return JsonUtil.OneStringToJson("json");
	}
	
	/**
	 * 일지작성 > 첨부파일 리스트 호출 
	 */
	@RequestMapping(value = "/ezJournal/dragAndDrop.do")
	public String journalDragAndDrop(@CookieValue("loginCookie") String loginCookie, Model model,  HttpServletRequest request) throws Exception {
		
		logger.debug("journalDragAndDrop started");

        LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
        String attachFileNameMaxLength = commonUtil.getTenantConfigRest("attachFileNameMaxLength", userInfo.getId(), request);
		
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
		String mode = "";
		String journalId = "";
		
		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}
		
		if (request.getParameter("journalId") != null && !request.getParameter("journalId").equals("")) {
			journalId = request.getParameter("journalId");
		}
        
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("mode", mode);
		model.addAttribute("journalId", journalId);
		
		logger.debug("journalDragAndDrop ended");
		return "ezJournal/journalDragAndDrop";
	}	
	
	/**
	 * 일지작성 > 첨부파일 업로드
	 */
	@RequestMapping(value = "/ezJournal/uploadJournalAttach.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadJournalAttach(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		
		logger.debug("uploadJournalAttach started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.journalGWServerURL");
		String url = gwServerUrl + "/rest/ezjournal/attachfiles";
		
		URI uri = URI.create(url);
		
		String typeId = request.getParameter("typeId");
		List<MultipartFile> files = request.getFiles("fileToUpload"); 
		int cnt = files.size();
		int maxSize = 0;
		
//		String realPath = request.getServletContext().getRealPath("");
        Long[] fileSize = new Long[cnt];        
        String[] resultUpload = new String[cnt];
        String[] sGUID = new String[cnt];
        String[] pUploadSN = new String[cnt];
        maxSize = Integer.parseInt(request.getParameter("maxSize"));
        JSONObject jsonObject = new JSONObject();
        JSONArray jsonArray = new JSONArray();
        
        String mode = "";
		String journalId = "";

		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}
		
		if (request.getParameter("journalId") != null && !request.getParameter("journalId").equals("")) {
			journalId = request.getParameter("journalId");		
		}

		logger.debug("mode : " + mode + " | journalId : " + journalId);

        for (int i = 0; i < cnt; i++) {
            resultUpload[i] = "false";
            sGUID[i] = UUID.randomUUID().toString();
            pUploadSN[i] = "{" + sGUID[i] + "}";
        }
        
        HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
        
        if (StringUtils.isNotEmpty(files.get(0).getOriginalFilename()) && StringUtils.isNotBlank(files.get(0).getOriginalFilename())) {        	
            for (int i = 0; i < cnt; i++) {
            	JSONObject fileJson = new JSONObject();
            	
            	byte[] bytes = files.get(i).getBytes();
            	fileSize[i] = files.get(i).getSize();
                String originalFilename = files.get(i).getOriginalFilename();
                fileJson.put("bytes", bytes);
                fileJson.put("fileSize", fileSize[i]);
                fileJson.put("originalFilename", originalFilename);
                fileJson.put("typeId", typeId);
                
                jsonArray.add(fileJson);
            }
        }
        jsonObject.put("fileArray", jsonArray);
		jsonObject.put("cnt", cnt);
		jsonObject.put("maxSize", maxSize);
		jsonObject.put("userId",userInfo.getId());
		jsonObject.put("typeId", typeId);
        
		HttpEntity<JSONObject> entity = new HttpEntity(jsonObject, headers);
		
        RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(uri, HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
	
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		Object data = "";
		
		if (status.equals("ok")) {
			data = resultBody.get("data");
			logger.debug("xml데이터 확인 : " + data);
			model.addAttribute("data", data.toString());
			return data.toString();
		}

		logger.debug("status:"+status);
        logger.debug("uploadJournalAttach ended");
        
        return "json";
    }
	
	/**
	 * 일지작성 > 닫기 클릭시 임시첨부파일 삭제 또는 파일삭제
	 */
	@RequestMapping(value = "/ezJournal/tempUploadFileDelete.do")
	public String tempUploadFileDelete(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		
		logger.debug("tempUploadFileDelete started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
//		String pDirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_journal.ROOT", loginSimpleVO.getTenantId());
		String fileList = request.getParameter("fileList");
		
		String mode = "";
		String typeId = request.getParameter("typeId");
		String journalId = "";
		String filePath = "";
		
		logger.debug("fileList : " + fileList);
		
		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}
		
		if (request.getParameter("journalId") != null && !request.getParameter("journalId").equals("")) {
			journalId = request.getParameter("journalId");
		} else {
			journalId = "temp";
		}

		if (mode.equals("temp")) {
			filePath = "uploadFile" + commonUtil.separator + journalId + "_uploadFile";
		} else {
			filePath = "tempUploadFile";
		}
		
		logger.debug("filePath : " + filePath);

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("mode", mode);
		param.put("filePath", filePath);
		param.put("fileList", fileList);
		
		String restUrl = "/rest/ezjournal/types/" + typeId + "/journals/" + journalId + "/attachfiles";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "delete", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			logger.debug("첨부파일삭제 성공");
		}

        logger.debug("tempUploadFileDelete ended");
        
        return "json";
    }
	
	/**
	 * 업무일지 저장
	 */
	@RequestMapping(value = "/ezJournal/saveJournal.do")
	public void saveCircular(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("saveJournal started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String realPath = commonUtil.getRealPath(request);
		String fileList = "";
		String pDirPath = "";
		
		String restUrl = "";
		String originJournalId = request.getParameter("oldJournalId");
		String mode = request.getParameter("mode");
		String title = request.getParameter("title");
		String isPublic = request.getParameter("isPublic");
		String content = request.getParameter("content");
		String typeId = request.getParameter("typeId");
		String formId = request.getParameter("formId");
		
		if (originJournalId != null && !originJournalId.equals("") && mode.equals("temp")) {
			mode = "tempMod";
		}

		logger.debug("journalId:"+originJournalId+",mode:"+mode+",title:"+title+",isPublic:"+isPublic+",content:"+content+",formId:"+formId+",typeId:"+typeId);
		
		
//		if (request.getParameter("fileList") != null && !request.getParameter("fileList").equals("")) {
//			fileList = request.getParameter("fileList");
//			
//			pDirPath = commonUtil.getUploadPath("upload_journal.ROOT", userInfo.getTenantId());
//
//	        pDirPath = realPath + pDirPath;	        
//        
//	        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
//	        	pDirPath = pDirPath + commonUtil.separator;
//	        }
//		}
		
		fileList = request.getParameter("fileList");
		logger.debug("fileList : " + fileList);
		
		String receiverIDs = request.getParameter("receiverID");
		String receiverList = request.getParameter("receiverList");

		logger.debug("receiverIDs : " + receiverIDs);
		logger.debug("receiverList : " + receiverList);
		
		if (mode.equals("reuse")) {
			originJournalId = "";
		}
		
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("title", title);
		jsonParam.put("content", content);
		jsonParam.put("deptShare", isPublic);
		jsonParam.put("formId", formId);
		jsonParam.put("userId", userInfo.getId());
		jsonParam.put("receiverIDs", receiverIDs);
		jsonParam.put("receiverList", receiverList);
		jsonParam.put("fileList", fileList);
		jsonParam.put("mode", mode);
		
		JSONObject result = new JSONObject();
		
		if (mode != null && mode.equals("modify") || mode.equals("tempMod")) {
			restUrl = "/rest/ezjournal/types/" + typeId + "/journals/" + originJournalId;
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "put", jsonParam);
		} else {
			restUrl = "/rest/ezjournal/types/" + typeId + "/journals";
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "post", jsonParam);
		}

		logger.debug("saveJournal ended");
	}
	
}
