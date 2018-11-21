package egovframework.ezMobile.ezResource.web;

import java.lang.reflect.Field;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.json.Json;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.ezMobile.ezResource.vo.MResourceGetScheduleVO;
import egovframework.ezMobile.ezResource.vo.MResourceSearchVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 자원관리
 * @author 오픈솔루션팀 강민수
 * @Modification Information
 * @
 * @  수정일         수정자                   수정내용
 * @ -------    --------    ---------------------------
 * @ 2017.07.24    강민수         최초 생성
 * @see
 */

@Controller
public class MResourceController extends EgovFileMngUtil {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MResourceController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name = "MResourceService")
	private MResourceService mResourceService;
	
	/**
	 * 모바일 자원관리 sub 리스트 가져오기 실행 함수
	 */
	@RequestMapping(value="/mobile/ezResource/getSubList.do")
	public String getSubList(HttpServletRequest req, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse resp) throws Exception {
		LOGGER.debug("getSubList started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String brdId = "";
		
		if (req.getParameter("brdId") != null && !req.getParameter("brdId").equals("")) {
			brdId = req.getParameter("brdId");
		}
		
		List<MResourceGetAdmSubClsTreeVO> resSubList = new ArrayList<MResourceGetAdmSubClsTreeVO>();
		resSubList = mResourceService.getAdmSubClsTree(brdId, userInfo.getCompanyID(), "0", userInfo.getTenantId());
		
		model.addAttribute("subList", resSubList);
		
		LOGGER.debug("getSubList ended.");
		return "json";
	}
	
	/**
	 * 모바일 자원관리 자원예약리스트 조회
	 */
	@RequestMapping(value="/mobile/resource/SearchResMainList.do")
	public String getResMainList(HttpServletRequest request, LoginVO userInfo, MResourceSearchVO searchVO,@CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		LOGGER.debug("getResSchList started.");
		
		Gson gson = new Gson();
		userInfo = commonUtil.userInfo(loginCookie);
		String serverName = request.getServerName();
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String userId = "";
		String companyId = "";
		
		
		
		if(userInfo != null){
			userId = userInfo.getId();			
			companyId = userInfo.getCompanyID();
		}
		//로컬테스트용
		//gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezresource/main-list/users/" + userId;
				
		RestTemplate rest = new RestTemplate();	
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<String> entity = null;		
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<String>(headers);	
		builder = builder.queryParam("companyId", companyId); 
						
	     
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		LOGGER.debug("result: " + result);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
				
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONObject dataObject = (JSONObject) resultBody.get("data");
			
			List<ResGetScheduleVO> getScheduleList = (List<ResGetScheduleVO>) dataObject.get("getScheduleList");
			String count = dataObject.get("count").toString();
			model.addAttribute("getScheduleList", getScheduleList);
			model.addAttribute("count", count);
		}
		
		LOGGER.debug("getResSchList ended.");
		return "json";
	}
	
	/**
	 * 모바일 자원관리 자원예약리스트 조회
	 */
	@RequestMapping(value="/mobile/resource/SearchResSchList.do")
	public String getResSchList(HttpServletRequest request, LoginVO userInfo, MResourceSearchVO searchVO,@CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		LOGGER.debug("getResSchList started.");
		
		Gson gson = new Gson();
		userInfo = commonUtil.userInfo(loginCookie);
		String serverName = request.getServerName();		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String startDate = searchVO.getStartDate();
		String endDate = searchVO.getEndDate();
		String type = searchVO.getType();
		startDate = "2017-07-01 09:00";
		endDate = "2017-07-03 10:00";
		//로컬테스트용
		//gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezresource/" + type + "/list";
		String userId = "";
		String companyId = "";
		String writerDept = "";
		String writerName = "";
		
		if(userInfo != null){
			userId = userInfo.getId();			
			companyId = userInfo.getCompanyID();
			writerDept = userInfo.getDeptID();
			writerName = userInfo.getDisplayName();
		}
		
		String ownerId = searchVO.getOwnerId();
				
		RestTemplate rest = new RestTemplate();	
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;		
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<Object>(headers);	
		builder = builder.queryParam("startDate", startDate)
						 .queryParam("endDate", endDate)
						 .queryParam("userId", userId)
						 .queryParam("companyId", companyId)
						 .queryParam("ownerId", ownerId); 
						
	     
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);

		LOGGER.debug("result: " + result);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();
		JSONArray scheduleList = new JSONArray();
		

	
			scheduleList = gson.fromJson(gson.toJson(resultBody.get("data")), JSONArray.class);
			
			LOGGER.debug("scheduleList" + scheduleList);
			
			model.addAttribute("scheduleListCnt", scheduleList.size());
			model.addAttribute("scheduleList", scheduleList);

		
		LOGGER.debug("getResSchList ended.");
		return "json";
	}
	
	/**
	 * 모바일 자원관리 자원폴더 조회
	 */
	@RequestMapping(value="/mobile/resource/SearchResFolderList.do")
	public String getResFolderList(HttpServletRequest request, LoginVO userInfo, MResourceSearchVO searchVO,@CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		LOGGER.debug("getResFolderList started.");
		Gson gson = new Gson();
		userInfo = commonUtil.userInfo(loginCookie);
		String serverName = request.getServerName();		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String brdId = "1";
		String brdCompany = searchVO.getCompanyId();
		//로컬테스트용
		//gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezresource/folder-list";
		String userId = "";
		String companyId = "";
		
		if(userInfo != null){
			userId = userInfo.getId();			
			companyId = userInfo.getCompanyID();
			brdCompany = userInfo.getCompanyID();
		}
		
		String ownerId = searchVO.getOwnerId();				
		RestTemplate rest = new RestTemplate();	
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;		
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<Object>(headers);	
		builder = builder.queryParam("userId", userId)
						 .queryParam("brdId", brdId)
						 .queryParam("brdCompany", brdCompany); 
							     
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);

		LOGGER.debug("result: " + result);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();
		JSONArray folderList = new JSONArray();
		

		Map<String, Object> resultMap = (Map<String, Object>) resultBody.get("data");	
		folderList = gson.fromJson(gson.toJson(resultMap.get("list")), JSONArray.class);
			
			LOGGER.debug("folderList" + folderList);
			
			model.addAttribute("folderListCnt", folderList.size());
			model.addAttribute("folderList", folderList);
			
			model.addAttribute("adminYn", resultMap.get("adminYn"));
			model.addAttribute("authYn", resultMap.get("authYn"));
			
		LOGGER.debug("getResFolderList ended.");
		return "json";
	}
	
	/**
	 * 모바일 자원관리 자원즐겨찾기 리스트 조회
	 */
	@RequestMapping(value="/mobile/resource/SearchResFavoriteList.do")
	public String getResFavoriteList(HttpServletRequest request, LoginVO userInfo, MResourceSearchVO searchVO,@CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		LOGGER.debug("getResFavoriteList started.");
		Gson gson = new Gson();
		userInfo = commonUtil.userInfo(loginCookie);
		String serverName = request.getServerName();		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String userId = "";
		
		if(userInfo != null){
			userId = userInfo.getId();			
		}
		//로컬테스트용
		//gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezresource/favorite-list/users/" + userId;

		String ownerId = searchVO.getOwnerId();
				
		RestTemplate rest = new RestTemplate();	
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;		
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<Object>(headers);	
						
	     
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);

		LOGGER.debug("result: " + result);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();
		JSONArray favoriteList = new JSONArray();
		

	
		favoriteList = gson.fromJson(gson.toJson(resultBody.get("data")), JSONArray.class);
			
			LOGGER.debug("favoriteList" + favoriteList);
			
			model.addAttribute("favoriteListCnt", favoriteList.size());
			model.addAttribute("favoriteList", favoriteList);
		
		LOGGER.debug("getResFavoriteList ended.");
		return "json";
	}
	
	/**
	 * 모바일 자원관리 자원예약상세 조회
	 */
	@RequestMapping(value="/mobile/resource/SearchResSchDetail.do")
	public String getResSchDetail(HttpServletRequest request, LoginVO userInfo, MResourceSearchVO searchVO,@CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		LOGGER.debug("getResSchDetail started.");
		Gson gson = new Gson();
		userInfo = commonUtil.userInfo(loginCookie);
		String serverName = request.getServerName();		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String companyId = "";
		String userId = "";

		
		if(userInfo != null){		
			companyId = userInfo.getCompanyID();
			userId = userInfo.getId();
		}
		
		String ownerId = searchVO.getOwnerId();
		int scheduleId = searchVO.getNum();
		ownerId = "11";
		scheduleId = 22;
		//로컬테스트용
		//gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezresource/resources/" + ownerId + "/schedules/" + scheduleId;
		LOGGER.debug("userId: " + userId);
		
		RestTemplate rest = new RestTemplate();	
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;		
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<Object>(headers);	
		builder = builder.queryParam("userId", userId)
						 .queryParam("companyId", companyId);

						
	     
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);

		LOGGER.debug("result: " + result);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();
		//Map<String, Object> scheduleDetail = (Map<String, Object>) resultBody.get("data");
        JSONObject scheduleDetail = gson.fromJson((String)resultBody.get("data"), JSONObject.class);
			LOGGER.debug("scheduleDetail" + scheduleDetail);
			//jsonobject ???
			model.addAttribute("scheduleDetail", scheduleDetail);
		LOGGER.debug("getResSchDetail ended.");
		return "json";
	}
	
	/**
	 * 모바일 자원관리 자원예약중복체크
	 */
	@RequestMapping(value="/mobile/resource/CheckResSchRepeat.do")
	public String checkResSchRepeat(HttpServletRequest request, LoginVO userInfo, MResourceSearchVO searchVO,@CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		LOGGER.debug("checkResSchRepeat started.");
		Gson gson = new Gson();
		userInfo = commonUtil.userInfo(loginCookie);
		String serverName = request.getServerName();		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String companyId = "";
		String userId = "";

		
		if(userInfo != null){		
			companyId = userInfo.getCompanyID();
			userId = userInfo.getId();
		}
		
		String ownerId = searchVO.getOwnerId();
		int scheduleId = searchVO.getNum();
		ownerId = "11";
		scheduleId = 22;
		//로컬테스트용
		//gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezresource/resources/" + ownerId + "/schedules/" + scheduleId + "/check-repetition";
		LOGGER.debug("userId: " + userId);
		
		RestTemplate rest = new RestTemplate();	
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;		
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<Object>(headers);	
		builder = builder.queryParam("userId", userId)
						 .queryParam("companyId", companyId);

						
	     
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);

		LOGGER.debug("result: " + result);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();
		//Map<String, Object> scheduleDetail = (Map<String, Object>) resultBody.get("data");
        JSONObject scheduleDetail = gson.fromJson((String)resultBody.get("data"), JSONObject.class);
			LOGGER.debug("scheduleDetail" + scheduleDetail);
			//jsonobject ???
			model.addAttribute("scheduleDetail", scheduleDetail);
		LOGGER.debug("checkResSchRepeat ended.");
		return "json";
	}
	
	/**
	 * 모바일 자원관리 자원예약 등록
	 */
	@RequestMapping(value="/mobile/resource/InsertResSchedule.do")
	public String addResSchedule(HttpServletRequest request, LoginVO userInfo, MResourceSearchVO searchVO,@CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		LOGGER.debug("addResSchedule started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String resourceId = "11";
		String serverName = request.getServerName();
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		//로컬테스트용
		//gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezresource/resources/" + resourceId + "/schedules";
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String type = request.getParameter("type");
		startDate = "2017-07-01 09:00";
		endDate = "2017-07-03 10:00";
		
		String userId = "";
		String companyId = "";
		String writerDept = "";
		String writerName = "";
		
		if(userInfo != null){
			userId = userInfo.getId();			
			companyId = userInfo.getCompanyID();
			writerDept = userInfo.getDeptID();
			writerName = userInfo.getDisplayName();
		}
		
		
		
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;		
		Gson gson = new Gson();
		
		searchVO.setStartDate(startDate);
		searchVO.setEndDate(endDate);
		searchVO.setWriterName(writerName);
		searchVO.setWriterDept(writerDept);
		searchVO.setType(type);
		searchVO.setUserId(userId);
		searchVO.setCompanyId(companyId);
		searchVO.setDeptNm("");
		searchVO.setOwnerNm("");
		searchVO.setTitle("");
		searchVO.setLocation("");
		searchVO.setTimeDisplay("");
		searchVO.setAllDay("");
		searchVO.setAlertTime("");
		searchVO.setContent("");
		searchVO.setImportance("");
		searchVO.setEntryList("");
		searchVO.setAttachFlag("");
		searchVO.setScheduleId("");
		
		String jsonString = gson.toJson(searchVO);
		 JSONObject jsonObject = gson.fromJson(jsonString, JSONObject.class);
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<Object>(jsonObject, headers);	
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, JSONObject.class);

		LOGGER.debug("result: " + result);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();
		JSONArray scheduleList = new JSONArray();
		
/*		if (status.equals("ok")) {
			
			scheduleList = gson.fromJson(gson.toJson(resultBody.get("data")), JSONArray.class);
			
			LOGGER.debug("scheduleList" + scheduleList);
			
			model.addAttribute("scheduleListCnt", scheduleList.size());
			model.addAttribute("scheduleList", scheduleList);
		}*/
		
		
		List<MResourceGetScheduleVO> resSchList = new ArrayList<MResourceGetScheduleVO>();

		model.addAttribute("result", result);
		
		LOGGER.debug("addResSchedule ended.");
		return "json";
	}
	
	/**
	 * 모바일 자원관리 자원예약 수정
	 */
	@RequestMapping(value="/mobile/resource/UpdateResSchedule.do")
	public String modResSchdule(HttpServletRequest request, LoginVO userInfo, MResourceSearchVO searchVO,@CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		LOGGER.debug("modResSchdule started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String resourceId = "11";
		String serverName = request.getServerName();
		String scheduleId = "23";
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		//로컬테스트용
		//gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezresource/resources/" + resourceId + "/schedules/" + scheduleId;
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String type = request.getParameter("type");
		startDate = "2017-07-01 09:00";
		endDate = "2017-07-03 10:00";
		
		String userId = "";
		String companyId = "";
		String writerDept = "";
		String writerName = "";
		
		if(userInfo != null){
			userId = userInfo.getId();			
			companyId = userInfo.getCompanyID();
			writerDept = userInfo.getDeptID();
			writerName = userInfo.getDisplayName();
		}
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;		
		Gson gson = new Gson();
		
		searchVO.setStartDate(startDate);
		searchVO.setEndDate(endDate);
		searchVO.setWriterName(writerName);
		searchVO.setWriterDept(writerDept);
		searchVO.setType(type);
		searchVO.setUserId(userId);
		searchVO.setCompanyId(companyId);
		searchVO.setDeptNm("");
		searchVO.setOwnerNm("");
		searchVO.setTitle("내용수정");
		searchVO.setLocation("");
		searchVO.setTimeDisplay("");
		searchVO.setAllDay("");
		searchVO.setAlertTime("");
		searchVO.setContent("");
		searchVO.setImportance("");
		searchVO.setEntryList("");
		searchVO.setAttachFlag("");
		searchVO.setScheduleId("");
		
		String jsonString = gson.toJson(searchVO);
		 JSONObject jsonObject = gson.fromJson(jsonString, JSONObject.class);
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<Object>(jsonObject, headers);	
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);

		LOGGER.debug("result: " + result);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();
		JSONArray scheduleList = new JSONArray();
		
/*		if (status.equals("ok")) {
			
			scheduleList = gson.fromJson(gson.toJson(resultBody.get("data")), JSONArray.class);
			
			LOGGER.debug("scheduleList" + scheduleList);
			
			model.addAttribute("scheduleListCnt", scheduleList.size());
			model.addAttribute("scheduleList", scheduleList);
		}*/
		
		
		List<MResourceGetScheduleVO> resSchList = new ArrayList<MResourceGetScheduleVO>();
		
		
		model.addAttribute("result", result);
		
		LOGGER.debug("modResSchdule ended.");
		return "json";
	}
	
	/**
	 * 모바일 자원관리 자원예약 삭제
	 */
	@RequestMapping(value="/mobile/resource/DeleteResSchedule.do")
	public String delResSchedule(HttpServletRequest request, LoginVO userInfo, MResourceSearchVO searchVO,@CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		LOGGER.debug("delResSchedule started.");
		Gson gson = new Gson();
		userInfo = commonUtil.userInfo(loginCookie);
		String serverName = request.getServerName();		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		//클라이언트 변수 또는 사용자 변수???
		String companyId = "";
		String userId = "";

		
		if(userInfo != null){		
			companyId = userInfo.getCompanyID();
			userId = userInfo.getId();
		}
		
		String ownerId = searchVO.getOwnerId();
		int scheduleId = searchVO.getNum();
		ownerId = "11";
		scheduleId = 23;
		//로컬테스트용
		//gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezresource/resources/" + ownerId + "/schedules/" + scheduleId;
		LOGGER.debug("userId: " + userId);
		
		RestTemplate rest = new RestTemplate();	
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;		
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<Object>(headers);	
		builder = builder.queryParam("userId", userId)
						 .queryParam("companyId", companyId);

		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, JSONObject.class);

		LOGGER.debug("result: " + result);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();
		
		LOGGER.debug("delResSchedule ended.");
		return "json";
	}
	
	/**
	 * 모바일 자원관리 자원즐겨찾기 등록
	 */
	@RequestMapping(value="/mobile/resource/InsertResFavorite.do")
	public String addResFavorite(HttpServletRequest request, LoginVO userInfo, MResourceSearchVO searchVO,@CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		LOGGER.debug("addResFavorite started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
	
		String serverName = request.getServerName();
		String userId = "";
		String companyId = "";
		String writerDept = "";
		String writerName = "";
		String resourceId = searchVO.getOwnerId();
		
		if(userInfo != null){
			userId = userInfo.getId();			
			companyId = userInfo.getCompanyID();
			writerDept = userInfo.getDeptID();
			writerName = userInfo.getDisplayName();
		}
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		
	    resourceId = "5";
	    //로컬테스트용
	    //gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezresource/resources/" + resourceId + "/favorite";
		
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;		
		Gson gson = new Gson();
		
		searchVO.setUserId(userId);
		
		String jsonString = gson.toJson(searchVO);
		 JSONObject jsonObject = gson.fromJson(jsonString, JSONObject.class);
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<Object>(jsonObject, headers);	
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, JSONObject.class);

		LOGGER.debug("result: " + result);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();
		JSONArray scheduleList = new JSONArray();
		
/*		if (status.equals("ok")) {
			
			scheduleList = gson.fromJson(gson.toJson(resultBody.get("data")), JSONArray.class);
			
			LOGGER.debug("scheduleList" + scheduleList);
			
			model.addAttribute("scheduleListCnt", scheduleList.size());
			model.addAttribute("scheduleList", scheduleList);
		}*/
		
		
		List<MResourceGetScheduleVO> resSchList = new ArrayList<MResourceGetScheduleVO>();
		
		
		model.addAttribute("resSchList", resSchList);
		
		LOGGER.debug("addResFavorite ended.");
		return "json";
	}
	
	/**
	 * 모바일 자원관리 자원즐겨찾기 삭제
	 */
	@RequestMapping(value="/mobile/resource/DeleteResFavorite.do")
	public String delResFavorite(HttpServletRequest request, LoginVO userInfo, MResourceSearchVO searchVO,@CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		LOGGER.debug("delResFavorite started.");
		Gson gson = new Gson();
		userInfo = commonUtil.userInfo(loginCookie);
		String serverName = request.getServerName();		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String companyId = "";
		String userId = "";

		
		if(userInfo != null){		
			companyId = userInfo.getCompanyID();
			userId = userInfo.getId();
		}
		
		String ownerId = searchVO.getOwnerId();

		ownerId = "1";
		//로컬테스트용
		//gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezresource/resources/" + ownerId + "/favorite/users/" + userId;
		LOGGER.debug("userId: " + userId);
		
		RestTemplate rest = new RestTemplate();	
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;		
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<Object>(headers);	

		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, JSONObject.class);

		LOGGER.debug("result: " + result);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();

		LOGGER.debug("delResFavorite ended.");
		return "json";
	}
	
	
	/**
	 * 모바일 자원관리 자원예약리스트 화면 호출 함수
	 */
	@RequestMapping(value = "/mobile/sample/sampleResourceList.do")
	public String sampleResourceList(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, MResourceSearchVO searchVO, HttpServletResponse response, Locale locale) throws Exception {
		LOGGER.debug("sampleResourceList Start");

//		String title = "3층 소회의실";		
//		
//		model.addAttribute("title", title);		
//		
//		LOGGER.debug("loginCookie: " + loginCookie);
//		
//		LoginVO userInfo = commonUtil.userInfo(loginCookie);	
//		
//		String userId = "";
//		String companyId = "";
//		String writerDept = "";
//		String writerName = "";
//		
//		if(userInfo != null){
//			userId = userInfo.getId();			
//			companyId = userInfo.getCompanyID();
//			writerDept = userInfo.getDeptID();
//			writerName = userInfo.getDisplayName();
//		}
//		
//		LOGGER.debug("userId: " + userId);
//		LOGGER.debug("companyId: " + companyId);
//		LOGGER.debug("writerDept: " + writerDept);
//		LOGGER.debug("writerName: " + writerName);
		
		//오늘의 자원예약리스트조회
		//수정전
/*		LOGGER.debug("testList started.");		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		LOGGER.debug("userInfo: " + userInfo);
		LOGGER.debug("gwServerUrl: " + gwServerUrl);
		String serverName = userInfo.getServerName();
		userId = userInfo.getUserSe();
		String url = gwServerUrl + "/mobile/ezresource/1/list";				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);	
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("serverName", serverName)
		        .queryParam("resourceId", "1")
		        .queryParam("userId", userId)
		        .queryParam("startDate", "2017-05-05")
		        .queryParam("endDate", "2017-05-01");		
		RestTemplate rest = new RestTemplate();		
		String sample = rest.getForObject(builder.build().encode().toUri(), String.class);
		LOGGER.debug("testList ended.");*/
		//수정후
//		String startDate = request.getParameter("startDate");
//		String endDate = request.getParameter("endDate");
//		String type = request.getParameter("type");
//		startDate = "2017-07-01 09:00";
//		endDate = "2017-07-03 10:00";
//	
//		String serverName = request.getServerName();		
		
		//String url =  "/mobile/ezresource/resources/date/favorite";
		/*Map<String,Object> param = new HashMap<String,Object>();
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		param.put("type", type);
		param.put("userId", userId);
		param.put("companyId", companyId);
		param.put("writerDept", writerDept);
		param.put("writerName", writerName);
		*/
		
		/*String companyId = (String) jsonObject.get("companyId"); 
		String pNum = (String) jsonObject.get("pNum"); 
		String writerId = (String) jsonObject.get("userId");
		String deptNm = (String) jsonObject.get("deptNm"); 
		String ownerNm = (String) jsonObject.get("ownerNm"); 
		String title = (String) jsonObject.get("title"); 
		String location = (String) jsonObject.get("location"); 
		String timeDisplay = (String) jsonObject.get("timeDisplay"); 
		String startDate = (String) jsonObject.get("startDate"); 
		String endDate = (String) jsonObject.get("endDate"); 
		String allDay = (String) jsonObject.get("allDay"); 
		String alterTime = (String) jsonObject.get("alterTime"); 
		String content = (String) jsonObject.get("content"); 
		String importance = (String) jsonObject.get("importance"); 
		String writeDay = (String) jsonObject.get("writeDay"); 
		String entryList = (String) jsonObject.get("entryList"); 
		String attachFlag = (String) jsonObject.get("attachFlag"); 
		String approve = (String) jsonObject.get("approve");
		String scheduleId = (String) jsonObject.get("scheduleId");*/
		
//		searchVO.setStartDate(startDate);
//		searchVO.setEndDate(endDate);
//		searchVO.setWriterName(writerName);
//		searchVO.setWriterDept(writerDept);
//		searchVO.setType(type);
//		searchVO.setUserId(userId);
//		searchVO.setCompanyId(companyId);
//		searchVO.setDeptNm("");
//		searchVO.setOwnerNm("");
//		searchVO.setTitle("");
//		searchVO.setLocation("");
//		searchVO.setTimeDisplay("");
//		searchVO.setAllDay("");
//		searchVO.setAlertTime("");
//		searchVO.setContent("");
//		searchVO.setImportance("");
//		searchVO.setEntryList("");
//		searchVO.setAttachFlag("");
//		searchVO.setScheduleId("");
		

		
		
		//String restType = "GET";
		//String url =  "/mobile/ezresource/" + type + "/list";
//		String restType = "POST";
//		String resourceId = "11";
//		String url =  "/mobile/ezresource/resources/" + resourceId + "/schedules";
//		type = "all";
//		
//		ResponseEntity<JSONObject> result = toRestAPI(url, searchVO, serverName, restType);
//
//		LOGGER.debug("result: " + result);
//		
//		JSONObject resultBody = result.getBody();
//				
//		String status = resultBody.get("status").toString();
//		JSONArray scheduleList = new JSONArray();
//		
//		if (status.equals("ok")) {
//			Gson gson = new Gson();
//			scheduleList = gson.fromJson(gson.toJson(resultBody.get("data")), JSONArray.class);
//			
//			LOGGER.debug("scheduleList" + scheduleList);
//			
//			model.addAttribute("scheduleListCnt", scheduleList.size());
//			model.addAttribute("scheduleList", scheduleList);
//		}
		
		
		//자원예약카운트조회
/*		LOGGER.debug("testList count started.");		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		LOGGER.debug("gwServerUrl: " + gwServerUrl);		
		String url = gwServerUrl + "/mobile/ezresource/1/list-count";				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);	
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("tenantId", "0");		
		RestTemplate rest = new RestTemplate();		
		String sample = rest.getForObject(builder.build().encode().toUri(), String.class);
		LOGGER.debug("testList count ended.");*/
		
		//자원리스트 조회
/*		LOGGER.debug("resource favorite list get started.");		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		LOGGER.debug("gwServerUrl: " + gwServerUrl);		
		String url = gwServerUrl + "/mobile/ezresource/folder-list";				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);	
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("tenantId", "0");		
		RestTemplate rest = new RestTemplate();		
		String sample = rest.getForObject(builder.build().encode().toUri(), String.class);
		LOGGER.debug("resource favorite list get ended.");*/
		
		//즐겨찾기 대상 자원리스트 조회
/*		LOGGER.debug("resource favorite list get started.");		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		LOGGER.debug("gwServerUrl: " + gwServerUrl);		
		String url = gwServerUrl + "/mobile/ezresource/favorite-list/users/1";				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);	
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("tenantId", "0");		
		RestTemplate rest = new RestTemplate();		
		String sample = rest.getForObject(builder.build().encode().toUri(), String.class);
		LOGGER.debug("resource favorite list get ended.");*/
		
		//자원예약 상세정보 조회 및 자원예약 권한 조회
/*		LOGGER.debug("resource schedule detail get started.");		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		LOGGER.debug("gwServerUrl: " + gwServerUrl);		
		String url = gwServerUrl + "/mobile/ezresource/resources/1/schedules/1";				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);	
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("userId", "1")
		        .queryParam("startDate", "2017-05-05")
		        .queryParam("endDate", "2017-05-01");		
		RestTemplate rest = new RestTemplate();		
		String sample = rest.getForObject(builder.build().encode().toUri(), String.class);
		LOGGER.debug("resource schedule detail get ended.");*/
		
		//자원예약중복조회
/*		LOGGER.debug("resource schedule check get started.");		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		LOGGER.debug("gwServerUrl: " + gwServerUrl);		
		String url = gwServerUrl + "/mobile/ezresource/resources/1/schedules/1/check-repetition";				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);	
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("userId", "1")
		        .queryParam("startDate", "2017-05-05")
		        .queryParam("endDate", "2017-05-01");		
		RestTemplate rest = new RestTemplate();		
		String sample = rest.getForObject(builder.build().encode().toUri(), String.class);
		LOGGER.debug("resource schedule check get ended.");*/
		
		//자원예약등록
/*		LOGGER.debug("resource schedule post start.");
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezresource/resources/1/schedules";
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("title", title);		
		String jsonString = JSONObject.toJSONString(map);		
	    HttpHeaders headers = new HttpHeaders();	
		RestTemplate rest = new RestTemplate();	
	    headers.setContentType(MediaType.APPLICATION_JSON);
	    HttpEntity<Object> param= new HttpEntity<Object>(jsonString, headers);
	    rest.getMessageConverters().add(0, (HttpMessageConverter<?>) new StringHttpMessageConverter(Charset.forName("UTF-8")));
		rest.postForObject(url, param, String.class);    
	    LOGGER.debug("resource schedule post end.");*/
		
		//자원예약수정
/*		LOGGER.debug("resource schedule put start.");
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezresource/resources/1/schedules/1";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("title", title);		
		RestTemplate rest = new RestTemplate();	
	    rest.put(url, map);	    
	    LOGGER.debug("resource schedule put end.");*/
		
	    
		//자원예약삭제
/*		LOGGER.debug("resource schedule delete start.");
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezresource/resources/1/schedules/1";
		Map<String, Object> map = new HashMap<String, Object>();
		RestTemplate rest = new RestTemplate();	
	    rest.delete(url);	    
	    LOGGER.debug("resource schedule delete end.");*/
		
		//즐겨찾기추가
/*		LOGGER.debug("favorite start.");
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezresource/resources/1/favorite";
		String useYn = "Y";
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("userId", "1");
		map.put("useYn", useYn);		
		String jsonString = JSONObject.toJSONString(map);		
	    HttpHeaders headers = new HttpHeaders();	
		RestTemplate rest = new RestTemplate();	
	    headers.setContentType(MediaType.APPLICATION_JSON);
	    HttpEntity<Object> param= new HttpEntity<Object>(jsonString, headers);	
		rest.postForObject(url, param, String.class);
	    LOGGER.debug("favorite end.");*/
		
		//즐겨찾기삭제
//		LOGGER.debug("favorite start.");
//		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
//		String url = gwServerUrl + "/mobile/ezresource/resources/1/favorite/users/{userId}";
//		Map<String, Object> map = new HashMap<String, Object>();
//		
//		map.put("userId", "1");
//
//		RestTemplate rest = new RestTemplate();
//	
//	    rest.delete(url, map);
	    
	    LOGGER.debug("sampleResourceList end.");

	    
		return "/mobile/ezResource/mResourceList";
	}
	
	//자원관리 Rest API 테스트용
	public ResponseEntity<JSONObject> toRestAPI(String url, MResourceSearchVO searchVO, String serverName, String restType){
		
		LOGGER.debug("url: " + url);
		LOGGER.debug("searchVO: " + searchVO);
		LOGGER.debug("serverName: " + serverName);
		LOGGER.debug("restType: " + restType);
		
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		url = gwServerUrl + url;
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;
		
		if(restType.equals("POST")||restType.equals("PUT")){			
			Gson gson = new Gson();
			String jsonString = gson.toJson(searchVO);
			 JSONObject jsonObject = gson.fromJson(jsonString, JSONObject.class);
				headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
				headers.set("x-user-host", serverName);
		     entity = new HttpEntity<Object>(jsonObject, headers);		    
		   
		}else{
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
			 entity = new HttpEntity<>(headers);
	        Object obj= searchVO;
	        for (Field field : obj.getClass().getDeclaredFields()){
	            field.setAccessible(true);
	            Object value;
	            
				try {
					value = field.get(obj);
					 builder = builder.queryParam(field.getName(), value);
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
	            
	        }
					
		}
		
		switch(restType){
		
		case "GET" : result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
					 break;
		case "POST" : result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, JSONObject.class);
		 			 break;			 
		case "PUT" : result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);
					 break;
		case "DELETE" : result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, JSONObject.class);
					 break;
		default : result = null;
					 break;		 			
		}
			
		return result;
	}
	
	
}
