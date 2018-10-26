package egovframework.ezEKP.ezJournal.web;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.net.URI;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezJournal.vo.JournalPagination;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzJournalController extends EgovFileMngUtil {
	public static final int BUFF_SIZE = 2048;
	
	private static final Logger logger = LoggerFactory.getLogger(EzJournalController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzEmailService")
	private EzEmailService ezEmailService;
	
	/**
	 * 업무일지 메인화면 호출
	 */
	@RequestMapping(value="/ezJournal/journalMain.do")
	public String journalMain(HttpServletRequest req, Model model) {
		logger.debug("journalMain started");
		logger.debug("journalMain ended");
		return "/ezJournal/journalMain";
	}
	
	/**
	 * 업무일지 왼쪽 메뉴 화면
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/journalLeft.do")
	public String journalLeft(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalLeft started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+userInfo.getId()+"/recv-count", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			String recvCount = (String) resultBody.get("data");
			model.addAttribute("recvCount", recvCount);
		//	logger.debug("recvCount = ********" + recvCount);
		}
		
		param.put("companyId",userInfo.getCompanyID());
		param.put("userId",userInfo.getId());
		param.put("used", "use");
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/types", param, request,"get",null);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONArray typeList = (JSONArray) resultBody.get("data");
			model.addAttribute("typeList", typeList);
		//	logger.debug("typeList = ********" + typeList);
		}
		logger.debug("journalLeft ended");
		
		return "/ezJournal/journalLeft";
	}
	
	/**
	 * 업무일지 리스트 화면
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/journalListMain.do")
	public String journalListMain(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalListMain started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String listType = request.getParameter("listType");
		String typeId = request.getParameter("typeId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/" + userInfo.getId() + "/author-depts", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			//셀렉트박스 부서명
			JSONArray deptList = (JSONArray) resultBody.get("data");
			model.addAttribute("deptList", deptList);
			model.addAttribute("listType",listType);
			model.addAttribute("typeId",typeId);
		}
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/" + userInfo.getId() + "/options", param, request, "get", null);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			//업무일지 환경설정
			JSONObject journalEnv =  (JSONObject) ((JSONObject) resultBody.get("data")).get("journalOpt");
			logger.debug("journalEnv: " + journalEnv);
			model.addAttribute("journalEnv", journalEnv);
		}
		logger.debug("journalListMain ended");
		
		return "/ezJournal/journalListMain";
	}
	
	/**
	 * 업무일지 리스트의 양식 리스트 가져오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/getFormList.do")
	@ResponseBody
	public JSONArray journalListMainFormList(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalListMainFormList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String deptId = "";
		if (request.getParameter("deptId")!=null) {
			deptId = request.getParameter("deptId");
		}
		String typeId = request.getParameter("typeId");
		if (typeId == null || typeId.equals("")) {
			typeId = "basic";
		}
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("deptId",deptId);
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/types/" + typeId + "/forms", param, request, "get", null);
		String status = resultBody.get("status").toString();
		JSONArray formList = null;
		if (status.equals("ok")) {			
			formList = (JSONArray) resultBody.get("data");
		}
		
		logger.debug("journalListMainFormList ended");
		
		return formList;
	}
	
	/**
	 * 업무일지 리스트 가져오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value="/ezJournal/journalList.do")
	public String journalList(@RequestBody JSONObject jsonParam, HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		Map<String, Object> param = null;
		try {
			param = new ObjectMapper().readValue(jsonParam.toJSONString(), Map.class);
		} catch (Exception e) {
			e.printStackTrace();
		}
		String listType =(String) param.get("listType");
		int listCnt = Integer.parseInt(param.get("listCnt").toString());
		int currentPage = (int) param.remove("currentPage");
		
		param.put("companyId", userInfo.getCompanyID());
		param.put("userId", userInfo.getId());
		String url = "";
		switch (listType) {
		case "department":
			url = "/ezJournal/journalListDept";
			break;
		case "mine":
			url = "/ezJournal/journalListMine";
			param.remove("deptId");
			param.put("journalWriter", userInfo.getId());
			break;
		case "recv":
			url = "/ezJournal/journalListRecv";
			param.remove("typeId");
			param.remove("deptId");
			param.put("recvUser", userInfo.getId());
			break;
		case "temp":
			url = "/ezJournal/journalListTemp";
			param.put("journalWriter", userInfo.getId());
			param.remove("typeId");
			param.remove("deptId");
			param.put("status", "temp");
			break;
		default:
			break;
		}
		
		Iterator tarKeyIter = new HashSet(param.keySet()).iterator();
		while (tarKeyIter.hasNext()) {
		    Object key = (Object)tarKeyIter.next();
		    if (param.get(key) == null || param.get(key).equals("")) {
		    	param.remove(key);
		    	logger.debug("remove : " + key);
		    }
		}
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals-count", param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		int totalCount =0;
		if (status.equals("ok")) {			
			totalCount = Integer.parseInt((String) resultBody.get("data"));
		}
		
		JournalPagination paging = new JournalPagination(totalCount,listCnt, 10, currentPage);
		model.addAttribute("paging", paging);
		
		param.put("startCount", paging.getStartCount());
		if (param.get("orderNum") == null || param.get("orderNum").equals("")) {
			param.put("orderNum", 3);
		}
		if (param.get("orderHow") == null || param.get("orderHow").equals("")) {
			param.put("orderHow", "desc");
		}
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals", param, request, "get", null);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONArray journalList =  (JSONArray) resultBody.get("data");
//			logger.debug(journalList.toJSONString());
			/*
			for (int i = 0; i < journalList.size(); i++) {
				JSONObject journal = (JSONObject) journalList.get(i);
			//	String journalDate = (String) journal.get("journalDate");
			//	journalDate = commonUtil.getDateStringInUTC(journalDate, userInfo.getOffset(), false);
			//	journal.put("journalDate", journalDate.substring(0, 16));
			}
			*/
			model.addAttribute("journalList", journalList);
			model.addAttribute("totalCount",totalCount);
		}
		model.addAttribute("listType",listType);
		logger.debug("journalList ended");
		
		return url;
	}
	
	/**
	 * 읽지않은 수신일지 갯수 가져오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/leftRecvCount.do")
	@ResponseBody
	public String leftRecvCount(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("leftRecvCount started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+userInfo.getId()+"/recv-count", param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		String recvCount="";
		if (status.equals("ok")) {			
			recvCount= (String) resultBody.get("data");
		//	logger.debug("recvCount = ********" + recvCount);
		}
		logger.debug("leftRecvCount ended");
		
		return recvCount;
	}
	
	/**
	 * 업무일지 작성 화면 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezJournal/journalWrite.do")
	public String journalWrite(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("journalWrite started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
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
				model.addAttribute("journal", journal);
				model.addAttribute("content", journal.get("journalContent").toString().replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " "));
				JSONArray fileList = (JSONArray) journal.get("fileList");
				if (fileList != null && fileList.size() > 0) {
					for (int i = 0; i < fileList.size(); i++) {
						JSONObject file = (JSONObject) fileList.get(i);
						file.put("pFileName", file.get("fileName"));
					//	file.put("fileName", file.get("fileName"));
						String filePath = file.get("filePath").toString();
						filePath = filePath.substring(filePath.indexOf("{"), filePath.indexOf("}") + 1);
						file.put("pUploadSN", filePath);
						file.put("resultUpload", "true");
						fileList.set(i, file);
					}
					model.addAttribute("fileList", URLEncoder.encode(fileList.toString(), "UTF-8").replaceAll("\\+", "%20"));
				}
			}
			
			// 수신자 리스트 가져오기
			restUrl = "/rest/ezjournal/journals/" + journalId + "/receivers";
			result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
			
			status = result.get("status").toString();
			
			if (status.equals("ok")) {
				JSONArray receiver =  (JSONArray) result.get("data");
				if (receiver.size() > 0 && receiver != null) {
					
					for (int i = 0; i < receiver.size(); i++) {
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
	public String selectReceiver(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
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
					state.put("opened", "true");
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
	public String receiverLineName(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
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
	@ResponseBody
	@RequestMapping(value = "/ezJournal/saveReceiverFavorite.do")
	public void saveReceiverFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
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
	public String getFavoriteList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
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
	public String getFavoriteUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
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
	public JSONArray applyFavoriteUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
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
	public void deleteFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
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
	public JSONObject journalGetForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
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
			//	logger.debug("***" + jsonParam.toString());
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
			
			nowDate = commonUtil.getDateStringInUTC(nowDate, userInfo.getOffset(), false);
			String journalTitle = "[" +formName+ "] " + nowDate + " (" + userInfo.getDisplayName() + ")";
			String journalContent = (String) journal.get("formContent");
			// 예약어 부분에 내용 치환
			nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd");
			nowDate = commonUtil.getDateStringInUTC(nowDate, userInfo.getOffset(), false);
			journalContent = journalContent.replaceAll("@journalWriterDept", userInfo.getDeptName());
			journalContent = journalContent.replaceAll("@journalWriterName", userInfo.getDisplayName());
			journalContent = journalContent.replaceAll("@journalWriteDate", nowDate);
			
			resultForm.put("journalTitle", journalTitle);
			resultForm.put("journalContent", journalContent);
			resultForm.put("formStatus", journal.get("formStatus"));
			resultForm.put("formInfo", journal.get("formInfo"));
		//	logger.debug("resultparam 확인 : " + resultForm);
		}

		logger.debug("journalGetForm ended");
		return resultForm;
	}
	
	/**
	 * 업무일지 마지막 사용양식 아이디 가져오기
	 */
	@RequestMapping(value = "/ezJournal/journalGetLastForm.do", produces="application/json; charset=utf-8")
	@ResponseBody
	public String journalGetLastForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
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
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/ezJournal/uploadJournalAttach.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadJournalAttach(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		
		logger.debug("uploadJournalAttach started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.journalGWServerURL");
		String url = gwServerUrl + "/rest/ezjournal/attachfiles";
		
		URI uri = URI.create(url);
		
//		String typeId = request.getParameter("typeId");
		List<MultipartFile> files = request.getFiles("fileToUpload"); 
		int cnt = files.size();
		int maxSize = 0;
		logger.debug("###files : " + files + ", cnt: " + cnt);
		
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
        
        if (StringUtils.isNotEmpty(files.get(0).getOriginalFilename()) && StringUtils.isNotBlank(files.get(0).getOriginalFilename()) && cnt > 0) {        	
            for (int i = 0; i < cnt; i++) {
            	JSONObject fileJson = new JSONObject();
            	
            	byte[] bytes = files.get(i).getBytes();
            	fileSize[i] = files.get(i).getSize();
                String originalFilename = files.get(i).getOriginalFilename();
                fileJson.put("bytes", bytes);
                fileJson.put("fileSize", fileSize[i]);
                fileJson.put("originalFilename", originalFilename);
//              fileJson.put("typeId", typeId);
                
                jsonArray.add(fileJson);
            }
        }
        jsonObject.put("fileArray", jsonArray);
		jsonObject.put("cnt", cnt);
		jsonObject.put("maxSize", maxSize);
		jsonObject.put("userId",userInfo.getId());
//		jsonObject.put("typeId", typeId);
        
		HttpEntity<JSONObject> entity = new HttpEntity(jsonObject, headers);
		
        RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(uri, HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
	
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		Object data = "";
		
		if (status.equals("ok")) {
			data = resultBody.get("data");
			model.addAttribute("data", data.toString());
		//	data = data.toString();
		}

		logger.debug("status: " + status);
        logger.debug("uploadJournalAttach ended");
        
        return data.toString();
    }
	
	/**
	 * 일지작성 > 닫기 클릭시 임시첨부파일 삭제 또는 파일삭제
	 */
	@RequestMapping(value = "/ezJournal/tempUploadFileDelete.do")
	@ResponseBody
	public String tempUploadFileDelete(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		
		logger.debug("tempUploadFileDelete started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
//		String pDirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_journal.ROOT", loginSimpleVO.getTenantId());
		String fileList = request.getParameter("fileList");
		
		String mode = "";
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
		
		String restUrl = "/rest/ezjournal/journals/" + journalId + "/attachfiles";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "delete", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			logger.debug("status : " + status);
		}

        logger.debug("tempUploadFileDelete ended");
        
        return status;
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
		String isSum = request.getParameter("isSum");
		
		logger.debug("journalId:"+originJournalId+",mode:"+mode+",title:"+title+",isPublic:"+isPublic+",formId:"+formId+",typeId:"+typeId+",isSum:"+isSum);
		
		fileList = request.getParameter("fileList");
		logger.debug("fileList : " + fileList);
		
		String receiverIDs = request.getParameter("receiverID");
		String receiverList = request.getParameter("receiverList");

		logger.debug("receiverIDs : " + receiverIDs);
		logger.debug("receiverList : " + receiverList);
		
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
		jsonParam.put("isSum", isSum);
		
		if (mode.equals("temp")) {
			jsonParam.put("isTemp", "N");
		}
		
		if (mode.equals("reuse")) {
			jsonParam.put("originJournalId", originJournalId);
			originJournalId = "";
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
		String isSum = request.getParameter("isSum");
		
		logger.debug("journalId:"+originJournalId+",mode:"+mode+",title:"+title+",isPublic:"+isPublic+",formId:"+formId+",typeId:"+typeId+",isSum:"+isSum);
		
		fileList = request.getParameter("fileList");
//		logger.debug("fileList : " + fileList);
		
		String receiverIDs = request.getParameter("receiverID");
		String receiverList = request.getParameter("receiverList");
		
		logger.debug("receiverIDs : " + receiverIDs);
		logger.debug("receiverList : " + receiverList);
		
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
		jsonParam.put("isSum", isSum);
		jsonParam.put("isTemp", "Y");
		if (mode.equals("reuse")) {
			jsonParam.put("originJournalId", originJournalId);
			originJournalId = "0";
		}
		
		JSONObject result = new JSONObject();
		
		if (originJournalId.trim().equals("0") || mode.trim().equals("new")) {
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
		
		String journalId = request.getParameter("journalId");
		String filePath = request.getParameter("filePath");
		String fileName = request.getParameter("fileName");
				
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("filePath", filePath);
	//	param.put("fileName", fileName);
		
		String restUrl = "/rest/ezjournal/journals/" + journalId + "/attachfiles";
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
	 * 업무일지 상세내용 가져오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/journalDetail.do")
	public String getJournalDetail(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("getJournalDetail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		/*
		String viewDate ="";
		try {
			viewDate = commonUtil.getTodayUTCTime("");
		} catch (Exception e) {
			e.printStackTrace();
		}
		*/
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
//		param.put("viewDate", viewDate);
		
		String journalId = request.getParameter("journalId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/"+journalId, param, request,"get",null);
		
		String status = resultBody.get("status").toString();
		
		JSONObject journal = null;
		if (status.equals("ok")) {			
			journal = (JSONObject) resultBody.get("data");
		//	String journalDate = (String) journal.get("journalDate");
		//	journalDate = commonUtil.getDateStringInUTC(journalDate, userInfo.getOffset(), false);
		//	journal.put("journalDate", journalDate);
			model.addAttribute("journal",journal);
		}
		
		logger.debug("getJournalDetail ended");
		
		return "/ezJournal/journalDetail";
	}
		
		/**
		 * 업무일지 미리보기 내용 가져오기
		 * @param request
		 * @param model
		 * @param loginCookie
		 * @return
		 */
		@RequestMapping(value="/ezJournal/journalPreview.do")
		public String getJournalPreview(HttpServletRequest request,Model model, @CookieValue("loginCookie") String loginCookie) {
			logger.debug("getJournalPreview started");
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("userId", userInfo.getId());
			/*
			try {
				param.put("viewDate",commonUtil.getTodayUTCTime(""));
			} catch (Exception e) {
				e.printStackTrace();
			}
			*/
			
			String journalId = request.getParameter("journalId");
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/"+journalId, param, request,"get",null);
			
			String status = resultBody.get("status").toString();
			
			JSONObject journal = null;
			if (status.equals("ok")) {
				journal = (JSONObject) resultBody.get("data");
			//	String journalDate = (String) journal.get("journalDate");
			//	journalDate = commonUtil.getDateStringInUTC(journalDate, userInfo.getOffset(), false);
			//	journal.put("journalDate", journalDate);
				model.addAttribute("journal",journal);
			}
			
			logger.debug("getJournalPreview ended");
			
			return "/ezJournal/journalPreviewContent";
	}
		

	/**
	 * 업무일지 댓글화면 불러오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/journalReply.do")
	public String journalReply(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalReply started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/" + journalId + "/replies", param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		JSONArray replyList = null;
		if (status.equals("ok")) {			
			replyList=  (JSONArray) resultBody.get("data");
			/*
			for (Object reply : replyList) {
				JSONObject JOReply = (JSONObject)reply;
				String replyDate = (String) JOReply.get("replyDate");
				replyDate = commonUtil.getDateStringInUTC(replyDate, userInfo.getOffset(), false);
				JOReply.put("replyDate", replyDate);
			}
			*/
			model.addAttribute("replyList",replyList);
			model.addAttribute("journalId",journalId);
		}
		logger.debug("journalReply ended");
		
		return "/ezJournal/journalReplyList";
	}
	
	/**
	 * 업무일지 댓글 저장하기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/saveJournalReply.do")
	@ResponseBody
	public String saveJournalReply(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("saveJournalReply started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		String replyContent = request.getParameter("replyContent");
		/*
		String replyDate=null;
		try {
			replyDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		*/
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("replyContent", replyContent);
//		param.put("replyDate", replyDate);
//		param.put("loginCookie", loginCookie);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/" + journalId + "/replies", param, request, "post", null);
		String journalWriter = (String) resultBody.get("data");
		logger.debug("saveJournalReply ended");
		
		return journalWriter;
	}
	
	/**
	 * 업무일지 댓글 삭제하기
	 * @param request
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/removeJournalReply.do")
	@ResponseBody
	public String removeJournalReply(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("saveJournalReply started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		String replyId = request.getParameter("replyId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/" + journalId + "/replies/" + replyId, param, request, "delete", null);
		String status = resultBody.get("status").toString();
		
		logger.debug("saveJournalReply ended");
		
		return status;
	}
	
	/**
	 * 업무일지 조회자 리스트
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/JournalViewerList.do")
	public String getJournalViewerList(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("getJournalViewerList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/" + journalId + "/viewer-count", param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		String currentPageStr = request.getParameter("currentPage");
		if (currentPageStr == null || currentPageStr.equals("")) {
			currentPageStr = "1";
		}
		int currentPage = Integer.parseInt(currentPageStr);
		int totalCount =0;
		if (status.equals("ok")) {			
			totalCount = Integer.parseInt((String) resultBody.get("data"));
		}
		int listCnt = 10;
		JournalPagination paging = new JournalPagination(totalCount, listCnt, 10, currentPage);
		model.addAttribute("paging", paging);
		
		param.put("startCount", paging.getStartCount());
		param.put("listCnt", listCnt);
		
		if (totalCount>0) {
			resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/" + journalId + "/viewer", param, request, "get", null);
			status = resultBody.get("status").toString();
			
			if (status.equals("ok")) {			
				JSONArray viewerList=  (JSONArray) resultBody.get("data");
				/*
				for (Object viewer : viewerList) {
					JSONObject JOViewer = (JSONObject)viewer;
					String viewDate = (String) JOViewer.get("date");
					viewDate = commonUtil.getDateStringInUTC(viewDate, userInfo.getOffset(), false);
					JOViewer.put("date", viewDate);
				}
				*/
				model.addAttribute("viewerList", viewerList);
			}
		}
		
		logger.debug("getJournalViewerList ended");
		
		return "/ezJournal/journalViewerList";
	}
	
	/**
	 * 메일전송된 업무일지 권한 체크
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/ezJournal/checkToMailJournal.do")
	public JSONObject checkToMailJournal(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("checkToMailJournal started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/"+journalId+"/auth", param, request, "get", null);
//		
//		Map<String, String> resultMap = new HashMap<String, String>();
		
		JSONObject journalAuth=  (JSONObject) resultBody.get("data");
//		String status = resultBody.get("status").toString();
		
//		resultMap.put("isLive", "Y");
//		if (status.equals("ok")) {		
//			for (int i = 0; i < viewerList.size(); i++) {
//				JSONObject viewer =(JSONObject) viewerList.get(i);
//				if (viewer.get("userId").equals(userInfo.getId())) {
//					resultMap.put("checkSusin", "Y");
//				}
//			}
//		}
		
		logger.debug("checkToMailJournal ended");
		
		return journalAuth;
	}
	
	/**
	 * 업무일지 수신자 리스트
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/JournalReceiverList.do")
	public String getJournalReveiberList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("getJournalViewerList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/" + journalId + "/receivers-count", param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		String currentPageStr = request.getParameter("currentPage");
		if (currentPageStr == null || currentPageStr.equals("")) {
			currentPageStr = "1";
		}
		int currentPage = Integer.parseInt(currentPageStr);
		int totalCount =0;
		if (status.equals("ok")) {			
			totalCount = Integer.parseInt((String) resultBody.get("data"));
		}
		int listCnt = 10;
		JournalPagination paging = new JournalPagination(totalCount, listCnt, 10, currentPage);
		model.addAttribute("paging", paging);
		
		param.put("startCount", paging.getStartCount());
		param.put("listCnt", listCnt);
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/" + journalId + "/receivers", param, request, "get", null);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONArray viewerList=  (JSONArray) resultBody.get("data");
			/*
			for (Object viewer : viewerList) {
				JSONObject JOViewer = (JSONObject) viewer;
				String viewDate = (String) JOViewer.get("date");
				viewDate = commonUtil.getDateStringInUTC(viewDate, userInfo.getOffset(), false);
				JOViewer.put("date", viewDate);
			}
			*/
			model.addAttribute("viewerList",viewerList);
		}
		
		logger.debug("getJournalViewerList ended");
		
		return "/ezJournal/journalReceiverList";
	}
	
	/**
	 * 다른일지 가져오기 리스트
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/otherJournalList.do")
	public String getOtherJournalList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("getOtherJournalList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String formId = request.getParameter("formId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("journalWriter", userInfo.getId());
		param.put("userId", userInfo.getId());
		param.put("formId", formId);
		param.put("companyId", userInfo.getCompanyID());
		param.put("startCount", 0);
		param.put("listCnt", 10);
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals", param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONArray journalList=  (JSONArray) resultBody.get("data");
			/*
			for (Object journalObject : journalList) {
				JSONObject journal = (JSONObject) journalObject;
				String journalDate = (String) journal.get("journalDate");
				journalDate = commonUtil.getDateStringInUTC(journalDate, userInfo.getOffset(), false);
				journal.put("journalDate", journalDate);
			}
			*/
			model.addAttribute("journalList", journalList);
		}
		
		logger.debug("getOtherJournalList ended");
		
		return "/ezJournal/otherJournalList";
	}
	
	/**
	 * 선택된 다른일지 내용 가져오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/getOtherJournalContent.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getOtherJournal(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("getOtherJournal started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/" + journalId, param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		String result = "";
		
		if (status.equals("ok")) {			
			JSONObject journal=  (JSONObject) resultBody.get("data");
			String journalContent = (String) journal.get("journalContent");
			
			Document journalDoc = Jsoup.parseBodyFragment(journalContent);
//			Element journalBody = journalDoc.body();
//			
//			Element thisElem = journalBody.getElementById("thisJournal");
//			Element nextElem = journalBody.getElementById("nextJournal");
//			String nextContent = nextElem.html();
//			
//			thisElem.html(nextContent);
//			nextElem.html("");
			
			result = journalDoc.toString();
		}
		
		logger.debug("getOtherJournal ended");
		
		return result;
	}
	
	/**
	 * 업무일지 상세내용 JSON 가져오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/ezJournal/journalDetailJSON.do")
	public JSONObject getJournalJSON(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("getJournalJSON started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		/*
		String viewDate ="";
		try {
			viewDate = commonUtil.getTodayUTCTime("");
		} catch (Exception e) {
			e.printStackTrace();
		}
		*/
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
//		param.put("viewDate", viewDate);
		
		String journalId = request.getParameter("journalId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/" + journalId, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		JSONObject journal = null;
		if (status.equals("ok")) {			
			journal = (JSONObject) resultBody.get("data");
		//	String journalDate = (String) journal.get("journalDate");
		//	journalDate = commonUtil.getDateStringInUTC(journalDate, userInfo.getOffset(), false);
			String journalContent = ((String) journal.get("journalContent")).replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " ");
			journal.put("journalContent", journalContent);
		//	journal.put("journalDate", journalDate);
		}
		
		logger.debug("getJournalJSON ended");
		
		return journal;
	}
	
	/**
	 * 업무일지 상세내용 컨텐츠
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/journalDetailContent.do")
	public String getJournalContent(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("getJournalContent started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String journalId = request.getParameter("journalId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/"+journalId, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		JSONObject journal = null;
		if (status.equals("ok")) {			
			journal = (JSONObject) resultBody.get("data");
			model.addAttribute("journalContent",((String) journal.get("journalContent")));
		}
		
		logger.debug("getJournalContent ended");
		
		return "/ezJournal/journalContent";
	}
	
	/**
	 * 일지 조회정보 입력
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/journalViewCheck.do")
	@ResponseBody
	public String journalViewCheck(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalViewCheck started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		/*
		String viewDate ="";
		try {
			viewDate = commonUtil.getTodayUTCTime("");
		} catch (Exception e) {
			e.printStackTrace();
		}
		*/
		Map<String, Object> param = new HashMap<String, Object>();
		
		String journalIdList = request.getParameter("journalIdList");
		String userId = userInfo.getId();
				
		param.put("userId", userId);
//		param.put("viewDate", viewDate);
		param.put("journalIdList", journalIdList);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/viewers/" + userId, param, request, "put", null);
		
		String status = resultBody.get("status").toString();
		
		logger.debug("journalViewCheck ended");
		
		return status;
	}
	
	/**
	 * 일지작성자에게 댓글알림
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/sendJournalReplyMail.do")
	public String sendJournalReplyMail(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("sendJournalReplyMail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String replyContent = request.getParameter("replyContent");
		String journalTitle = request.getParameter("journalTitle");
		String journalWriter = request.getParameter("journalWriter");
		String journalId = request.getParameter("journalId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/" + journalWriter + "/options", param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONObject journalEnv = (JSONObject) ((JSONObject) resultBody.get("data")).get("journalOpt");
			
			String replyAlert = (String) journalEnv.get("replyAlert");
			
			if (replyAlert.equals("Y")) {
				try {
				InternetAddress[] toArr = new InternetAddress[1];
				toArr[0] = new InternetAddress((String) journalEnv.get("mail"));
				toArr[0].setPersonal((String) journalEnv.get("name"));
				
				String subject = egovMessageSource.getMessage("ezJournal.t151") + journalTitle;
				
				String content = "<p>" + egovMessageSource.getMessage("ezJournal.t152") + "</p>";
				
				content += "<p></p>";
				content += "<a href='#' target='' onclick='journalMailLink(" + journalId + ",1);'>" + journalTitle + "</a>";
				content += "<p>" + egovMessageSource.getMessage("ezJournal.t153") + userInfo.getDisplayName() + "</p>";
				content += "<p>" + egovMessageSource.getMessage("ezJournal.t154") + journalTitle + "</p>";
				content += "<p>" + replyContent + "</p>";
				
				InternetAddress from = new InternetAddress(userInfo.getEmail());
				from.setPersonal(userInfo.getDisplayName());
				ezEmailService.sendMail(loginCookie , from, toArr, null, null, subject, content, false);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		logger.debug("sendJournalReplyMail ended");
		
		return status;
	}
	
	/**
	 * 수신자에게 알림메일
	 * @param request
	 * @param model
	 * @param loginCookie
	 */
	@RequestMapping(value="/ezJournal/sendJournalRecvMail.do")
	public void sendJournalRecvMail(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("sendJournalRecvMail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String journalTitle = request.getParameter("journalTitle");
		String recvIds = request.getParameter("recvIds");
		String journalId = request.getParameter("journalId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		String userId = userInfo.getId();
		param.put("userId", userId);
		
		ArrayList<InternetAddress> toArrList = new ArrayList<InternetAddress>(); 
		if (recvIds != null && !recvIds.equals("")) {
			String[] receiverID = recvIds.split(",");
			
			for (int i = 0; i < receiverID.length; i++) {
				String recvId = receiverID[i];
				
				JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+recvId+"/options", param, request, "get", null);
				String status = resultBody.get("status").toString();
				
				if (status.equals("ok")) {			
					JSONObject journalEnv = (JSONObject) ((JSONObject) resultBody.get("data")).get("journalOpt");
					
					String recvAlert = (String) journalEnv.get("recvAlert");
					
					if (recvAlert.equals("Y")) {
						try {
							InternetAddress recvMail = new InternetAddress();
							recvMail.setAddress((String) journalEnv.get("mail"));
							recvMail.setPersonal((String) journalEnv.get("name"));
							toArrList.add(recvMail);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
			}
			try {
				InternetAddress[] toArr = new InternetAddress[toArrList.size()];
				for (int i = 0; i < toArrList.size(); i++) {
					toArr[i] = toArrList.get(i);
				}
				
				String subject = egovMessageSource.getMessage("ezJournal.t155") +journalTitle;
				
				String content = "<p>" + egovMessageSource.getMessage("ezJournal.t156") + "</p>";
				content += "<p></p>";
				content += "<a href='#' target='' onclick='journalMailLink(" + journalId + ");'>" + journalTitle + "</a>";
				content += "<p>" + egovMessageSource.getMessage("ezJournal.t157") + userInfo.getDisplayName() + "</p>";
				content += "<p>" + egovMessageSource.getMessage("ezJournal.t154") + journalTitle + "</p>";
				
				InternetAddress from;
				from = new InternetAddress(userInfo.getEmail());
				from.setPersonal(userInfo.getDisplayName());
				ezEmailService.sendMail(loginCookie , from, toArr, null, null, subject, content, false);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		logger.debug("sendJournalRecvMail ended");
	}
	
	/**
	 * 업무일지 환경설정 저장
	 * @param param
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/saveJournalEnv.do")
	@ResponseBody
	public JSONObject saveJournalEnv(@RequestParam Map<String,Object> param,HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("saveJournalEnv started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/" + userInfo.getId() + "/options", param, request, "post", null);
		
		logger.debug("saveJournalEnv ended");
		
		return resultBody;
	}
	
	/**
	 * 환경설정 화면 호출
	 */
	@SuppressWarnings("unchecked")
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
			JSONObject journalEnv = (JSONObject) ((JSONObject) result.get("data")).get("journalOpt");
			JSONArray deptList = (JSONArray) ((JSONObject) result.get("data")).get("deptList");
			logger.debug("journalEnv:" + journalEnv);
			logger.debug("deptList:" + deptList);
			
			for (int i = 0; i < deptList.size(); i++) {
				JSONObject dept = (JSONObject) deptList.get(i);
				dept.put("icon", "icon-dept");
				
				if (dept.get("myDept").equals("yes")) {
					JSONObject state = new JSONObject();
					state.put("selected", "true");
					state.put("opened", "true");
					dept.put("state", state);
				}
			}
			
			model.addAttribute("journalEnv", journalEnv);
			model.addAttribute("deptList", deptList);
		}
		
		logger.debug("journalConfig ended");
		
		return "/ezJournal/journalConfig";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezJournal/saveChiefAuthDept.do")
	@ResponseBody
	public String saveChiefAuthDept(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie){
		logger.debug("saveChiefAuthDept started");
		
		JSONObject jsonString = new JSONObject();
		String userId= ((LoginVO)commonUtil.userInfo(loginCookie)).getId();
		
		String depts = request.getParameter("depts");
		jsonString.put("userId", userId);
		jsonString.put("depts", depts);
		jsonString.put("admin", "N");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/authors", null, request, "post", jsonString);
		
		String status = resultBody.get("status").toString();
		
		logger.debug("saveChiefAuthDept ended");
		return status;
	}
	
}
