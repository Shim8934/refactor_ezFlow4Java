package egovframework.ezEKP.ezJournal.web;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.net.URI;
import java.util.Base64;
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
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzJournalJYController extends EgovFileMngUtil {
	public static final int BUFF_SIZE = 2048;
	
	private static final Logger logger = LoggerFactory.getLogger(EzJournalJYController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	/**
	 * 업무일지 작성 화면 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezJournal/journalWrite.do")
	public String journalWrite(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("journalWrite started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
//		String offset = userInfo.getOffset();
		String mode = request.getParameter("mode");
		String typeId = request.getParameter("typeId");
		String useEditor = commonUtil.getTenantConfigRest("EDITOR", userInfo.getId(), request);
		String journalId = "";
		String receiverIds = "";
		String receiverNames = "";
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("userId", userInfo.getId());
		param.put("used", "use");
	
		String restUrl = "";
		JSONObject result = new JSONObject();
		String status = "";

		if (request.getParameter("journalId") != null && !request.getParameter("journalId").equals("")) {
			journalId = request.getParameter("journalId");
			
			// 일지 내용 및 정보 가져오기
			restUrl = "/rest/ezjournal/journals/" + journalId;
			result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
			
			status = result.get("status").toString();
			
			if (status.equals("ok")) {
				JSONObject journal = (JSONObject) result.get("data");
				logger.debug("journal확인 : " + journal.toString());
				model.addAttribute("journal", journal);
				model.addAttribute("content", journal.get("journalContent").toString().replaceAll("\'", "\""));
//				model.addAttribute("formId", journal.get("formId").toString());
//				model.addAttribute("deptShare", journal.get("deptShare").toString());
				JSONArray fileList = (JSONArray) journal.get("fileList");
				if (fileList != null && fileList.size() > 0) {
					for (int i = 0; i < fileList.size(); i++) {
						JSONObject file = (JSONObject) fileList.get(i);
						file.put("pFileName", file.get("fileName"));
						String filePath = file.get("filePath").toString();
						filePath = filePath.substring(filePath.indexOf("{"), filePath.indexOf("}") + 1);
						file.put("pUploadSN", filePath);
	//					file.put("fileSize", file.get("fileSize"));
						file.put("resultUpload", "true");
						fileList.set(i, file);
					}
					model.addAttribute("fileList", fileList.toString());
				}
			}
			
			// 수신자 리스트 가져오기
			restUrl = "/rest/ezjournal/types/" + typeId + "/journals/" + journalId + "/receivers";
			result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
			
			status = result.get("status").toString();
			
			if (status.equals("ok")) {
				JSONArray receiver =  (JSONArray) result.get("data");
				logger.debug("처음 receiver확인용 : " + receiver);
				if (receiver.size() > 0 && receiver != null) {
					
					for (int i = 0; i < receiver.size(); i++) {
						
						logger.debug("receiver확인용 : " + receiver.get(i));
						JSONObject obj = (JSONObject) receiver.get(i);
						
						receiverIds += obj.get("userId") + ", ";
						receiverNames += obj.get("userName") + ", ";
					}
					
					model.addAttribute("receiverIds", receiverIds);
					model.addAttribute("receiverNames", receiverNames);
				}
			}
			
		}
		
		restUrl = "/rest/ezjournal/types";
		result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray typeList = (JSONArray) result.get("data");
			model.addAttribute("typeList", typeList);
		}
		
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
	 * 수신자 선택화면 호출
	 */
	@SuppressWarnings("unchecked")
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
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezJournal/saveReceiverFavorite.do")
	public void saveReceiverFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
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
	public JSONArray applyFavoriteUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
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
		JSONArray userList = new JSONArray();
		
		if (status.equals("ok")) {
			userList = (JSONArray) result.get("data");
			logger.debug("userList : " + userList);
		}
		logger.debug("applyFavoriteUser ended");
		return userList;
	}
	
	/**
	 * 즐겨찾기 삭제
	 */
	@RequestMapping(value = "/ezJournal/deleteFavorite.do")
	@ResponseBody
	public void deleteFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
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
	}
	
	/**
	 * 업무일지 양식 폼 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezJournal/journalGetForm.do", produces="application/json; charset=utf-8")
	@ResponseBody
	public JSONObject journalGetForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("journalGetForm started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = (String) request.getParameter("mode");
		String formId = (String) (request.getParameter("formId")+"");
		String typeId = (String) request.getParameter("typeId");
		String journalIdList = (String) request.getParameter("journalIdList");
		String userId = userInfo.getId();
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("mode", mode);
		jsonParam.put("formId", formId);
		jsonParam.put("typeId", typeId);
		jsonParam.put("journalIdList", journalIdList);
		
		String restUrl="";
		JSONObject result=null;
		switch (mode) {
			case "new":
				param.put("userId", userId);
				restUrl = "/rest/ezjournal/types/" + typeId + "/forms/" + formId;
				result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
				break;
			case "sum":
				jsonParam.put("userId", userId);
				restUrl = "/rest/ezjournal/journals-sum" ;
				logger.debug(jsonParam.toString());
				result = commonUtil.getJsonFromRestApi(restUrl, null, request, "post", jsonParam);
				break;
			default:
				param.put("userId", userId);
				restUrl = "/rest/ezjournal/types/" + typeId + "/forms/" + formId;
				result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
				break;
		}
		
		JSONObject resultForm = new JSONObject();
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			String nowDate = commonUtil.getTodayUTCTime("yyyyMMdd");
			JSONObject journal = (JSONObject) result.get("data");
			String formName = (String) journal.get("formName");
			
			String journalTitle = "[" +formName+ "] " + nowDate + " (" + userInfo.getDisplayName() + ")";
			String journalContent = (String) journal.get("formContent");
			// 예약어 부분에 내용 치환
			nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd");
			journalContent = journalContent.replaceAll("@journalWriterDept", userInfo.getDeptName());
			journalContent = journalContent.replaceAll("@journalWriterName", userInfo.getDisplayName());
			journalContent = journalContent.replaceAll("@journalWriteDate", nowDate);
			
			resultForm.put("journalTitle", journalTitle);
			resultForm.put("journalContent", journalContent);
			resultForm.put("formStatus", journal.get("formStatus"));
			logger.debug("resultparam 확인 : " + resultForm);
		}

		logger.debug("journalGetForm ended");
		return resultForm;
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
		String lastId = "";
		
		if (status.equals("ok")) {
			lastId = result.get("data").toString();
			logger.debug("lastFormId : " + lastId);
		}
		
		logger.debug("journalGetLastForm ended");
		return lastId;
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
	@SuppressWarnings("unchecked")
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
			data = data.toString();
		}

		logger.debug("status:"+status);
        logger.debug("uploadJournalAttach ended");
        
        return data.toString();
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

		if (mode.equals("temp") || mode.equals("modify")) {
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
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezJournal/saveJournal.do")
	@ResponseBody
	public String saveJournal(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("saveJournal started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String fileList = "";
		String restUrl = "";
		String originJournalId = request.getParameter("oldJournalId");
		String mode = request.getParameter("mode");
		String title = request.getParameter("title");
		String isPublic = request.getParameter("isPublic");
		String content = request.getParameter("content");
		String typeId = request.getParameter("typeId");
		String formId = request.getParameter("formId");
		
		logger.debug("journalId:"+originJournalId+",mode:"+mode+",title:"+title+",isPublic:"+isPublic+",formId:"+formId+",typeId:"+typeId);
		
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
		if (mode.equals("temp")) {
			jsonParam.put("isTemp", "N");
		}
		
		JSONObject result = new JSONObject();
		
		if (!originJournalId.equals("") && mode.equals("temp") || mode.equals("modify")) {
			restUrl = "/rest/ezjournal/types/" + typeId + "/journals/" + originJournalId;
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "put", jsonParam);
		} else {
			restUrl = "/rest/ezjournal/types/" + typeId + "/journals";
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "post", jsonParam);
		}
		
		String status = (String) result.get("status");
		String journalId = "";
		
		if (status.equals("ok")) {
			journalId = (String) result.get("data");
		}

		logger.debug("saveJournal ended");
		
		return journalId;
	}
	
	/**
	 * 업무일지 임시저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezJournal/saveTempJournal.do")
	@ResponseBody
	public String saveTempJournal(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("saveTempJournal started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String fileList = "";
		
		String restUrl = "";
		String originJournalId = request.getParameter("oldJournalId");
		String mode = request.getParameter("mode");
		String title = request.getParameter("title");
		String isPublic = request.getParameter("isPublic");
		String content = request.getParameter("content");
		String typeId = request.getParameter("typeId");
		String formId = request.getParameter("formId");
		
		logger.debug("journalId:"+originJournalId+",mode:"+mode+",title:"+title+",isPublic:"+isPublic+",content:"+content+",formId:"+formId+",typeId:"+typeId);
		
		fileList = request.getParameter("fileList");
		logger.debug("fileList : " + fileList);
		
		String receiverIDs = request.getParameter("receiverID");
		String receiverList = request.getParameter("receiverList");
		
		logger.debug("receiverIDs : " + receiverIDs);
		logger.debug("receiverList : " + receiverList);
		
		if (mode.equals("reuse")) {
			originJournalId = "0";
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
		jsonParam.put("isTemp", "Y");
		
		JSONObject result = new JSONObject();
		
		if (originJournalId.trim().equals("0") || mode.trim().equals("reuse")) {
			restUrl = "/rest/ezjournal/types/" + typeId + "/journals";
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "post", jsonParam);
		} else {
			restUrl = "/rest/ezjournal/types/" + typeId + "/journals/" + originJournalId;
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "put", jsonParam);
		}
		
		String status = (String) result.get("status");
		
		logger.debug("saveTempJournal ended");
		return status;
	}
	
	/**
	 * 다른일지 가져오기 호출
	 */
	/*
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezJournal/getOtherJournal.do")
	@ResponseBody
	public String getOtherJournal(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getOtherJournal started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String userId = request.getParameter("userId");
		String typeId = request.getParameter("typeId");
		String formId = request.getParameter("formId");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("typeId", typeId);
		map.put("formId", formId);
		map.put("startCount", 1);
		map.put("listCnt", 10);
		map.put("orderNum", 3);
		map.put("orderHow", "desc");
		
		String restUrl = "/rest/ezjournal/journals";
		JSONObject result = new JSONObject();
		
		result = commonUtil.getJsonFromRestApi(restUrl, map, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray journalList = (JSONArray) result.get("data");
			logger.debug("journalList 확인 : " + journalList);
			for (int i = 0; i < journalList.size(); i++) {
				JSONObject journal = (JSONObject) journalList.get(i);
				String journalDate = (String) journal.get("journalDate");
				journalDate = commonUtil.getDateStringInUTC(journalDate, userInfo.getOffset(), false);
				journal.put("journalDate", journalDate);
			}
			model.addAttribute("journalList", journalList);
		}
		
		logger.debug("getOtherJournal ended");
		return "ezJournal/journalGetOther";
	}
	*/
	
	/**
	 * 업무일지 삭제 (한건 또는 여러건)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezJournal/journalDelete.do")
	@ResponseBody
	public void journalDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("journalDelete started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String journalId = request.getParameter("journalId");
		String listType = "";
		
		if (request.getParameter("listType") != null) {
			listType = request.getParameter("listType");
		}
		logger.debug("journalId : " + journalId + ", listType : " + listType);
		
		JSONObject param = new JSONObject();
		param.put("userId", userInfo.getId());
		param.put("listType", listType);
		param.put("journalId", journalId);
		
		String restUrl = "/rest/ezjournal/journals";
		JSONObject result = new JSONObject();
		
		result = commonUtil.getJsonFromRestApi(restUrl, null, request, "delete", param);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		
		logger.debug("journalDelete ended");
	}
	
	/**
	 * 업무일지 첨부파일 다운로드
	 */
	@RequestMapping(value = "/ezJournal/journalAttachDown.do")
	public void journalAttachDown(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("journalAttachDown started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String typeId = request.getParameter("typeId");
		String journalId = request.getParameter("journalId");
		String filePath = request.getParameter("filePath");
		String fileName = request.getParameter("fileName");
				
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("filePath", filePath);
		param.put("fileName", fileName);
		
		String restUrl = "/rest/ezjournal/types/" + typeId + "/journals/" + journalId + "/attachfiles";
		JSONObject result = new JSONObject();
		
		result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) result.get("data");
			String bytes = (String) data.get("bytes");
			int fileSize = ((Number) data.get("fileSize")).intValue();
			
			String mimetype = "application/octet-stream";
		    byte[] tempBytes = Base64.getDecoder().decode(bytes);
		    
		    fileName = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), fileName);
		    
		    try (InputStream is = new ByteArrayInputStream(tempBytes)) {
		    	response.setBufferSize(BUFF_SIZE);
		    	response.setContentType(mimetype);
		    	response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
		    	response.setContentLength(fileSize);
		    	
		    	FileCopyUtils.copy(is, response.getOutputStream());
		    	
		    	response.getOutputStream().flush();
		    	response.getOutputStream().close();
			} catch (Exception e) {
				logger.debug("error");
			}
		}
		
		logger.debug("journalAttachDown ended");
	}
	
	/**
	 * 환경설정 화면 호출
	 */
	@RequestMapping(value = "/ezJournal/journalConfig.do")
	public String journalConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("journalConfig started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = userInfo.getId();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String restUrl = "/rest/ezjournal/users/" + userId + "/options";
		JSONObject result = new JSONObject();
		
		result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject journalEnv = (JSONObject) result.get("data");
			logger.debug("journalEnv:" + journalEnv);
			model.addAttribute("journalEnv", journalEnv);
		}
		
		logger.debug("journalConfig ended");
		
		return "/ezJournal/journalConfig";
	}
	
	
	/**
	 * 환경설정 저장 (사용안함)
	 */
	/*
	@RequestMapping(value = "/ezJournal/saveJournalConfig.do")
	@ResponseBody
	public void saveJournalConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("saveJournalConfig started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = userInfo.getId();
		
		String listCnt = request.getParameter("listCnt");
		String viewEnv = request.getParameter("viewenv");
		String previewHContent = request.getParameter("previewHContent");
		String previewWContent = request.getParameter("previewWContent");
		String recvAlert = request.getParameter("recvAlert");
		String replyAlert = request.getParameter("replyAlert");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("listCnt", listCnt);
		param.put("viewenv", viewEnv);
		param.put("previewHcontent", previewHContent);
		param.put("previewWcontent", previewWContent);
		param.put("recvAlert", recvAlert);
		param.put("replyAlert", replyAlert);
		
		String restUrl = "/rest/ezjournal/users/" + userId + "/options";
		JSONObject result = new JSONObject();
		
		result = commonUtil.getJsonFromRestApi(restUrl, param, request, "post", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		
		logger.debug("saveJournalConfig ended");
	}
	*/
	
}
