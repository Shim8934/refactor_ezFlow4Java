package egovframework.ezMobile.ezResource.web;

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

import com.google.gson.Gson;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.ezMobile.ezResource.vo.MResourceScheduleVO;
import egovframework.ezMobile.ezResource.vo.ResScheGetHolidayVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.fcc.service.CommonUtil;

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

@RestController
public class MResourceGWController extends EgovFileMngUtil {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MResourceGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

		
	@Resource(name="MResourceService")
	private MResourceService mResourceService;
		
	@Resource(name="loginService")
	private LoginService loginService;

	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	/**
	 * 모바일 G/W 자원관리 [get] 자원예약리스트조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/main-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceMainList(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/main-list/users/{userId}] started.");

		JSONObject result = new JSONObject();

		try {
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);

	    	String listCnt = "10";
	    				
			Map<String, Object> resultMap = mResourceService.getScheduleMainList(info, listCnt);

			LOGGER.debug("resultMap: " + resultMap);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultMap);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/main-list/users/{userId}] ended.");	
		
		return result;
	}
		
	/**
	 * 모바일 G/W 자원관리 [get] 자원예약리스트조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/{type}/list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceList(@PathVariable String type, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/{type}/list] started.");

		JSONObject result = new JSONObject();

		try {
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();			
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String companyId = info.getCompanyId();
			//String ownerId = request.getParameter("ownerId"); 
			//String utcStartDate = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
	    	//String utcEndDate = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);
	    	
	    	String ownerId = request.getParameter("ownerId");;
	    	
	    	String writerDt = info.getDeptId();
	    	
	    	String offset = info.getOffSet();
	    	
	    	//LOGGER.debug("utcStartDate: " + utcStartDate);
	    	//LOGGER.debug("utcEndDate: " + utcEndDate);
	    	LOGGER.debug("writerDt: " + writerDt);
	    	
	    	Map<String, Object> resultMap = mResourceService.getScheduleList(ownerId, companyId, startDate, endDate, writerDt, tenantId, offset, "");
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultMap);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/{type}/list] ended.");	
		
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 
	 */

	/**
	 * 모바일 G/W 자원관리 [get] 자원리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/folder-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceFolderList(HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/folder-list] started.");
		JSONObject result = new JSONObject();
		
		try {
			

			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String brdId = request.getParameter("brdId");
			String brdCompany = info.getCompanyId();
			
			LOGGER.debug("brdId: " + brdId);
			LOGGER.debug("brdCompany: " + brdCompany);
			LOGGER.debug("tenantId: " + tenantId);
			

			List<MResourceGetAdmSubClsTreeVO> list = mResourceService.getResBrdList(brdId, brdCompany, tenantId);
			
			LOGGER.debug("size of result: " + list.size());
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data",list);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/folder-list] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 즐겨찾기 대상 자원리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/favorite-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceFavoriteList(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/favorite-list/users/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try {
			

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();

			List<MResourceScheduleVO> list = mResourceService.getResFavoriteList(userId, companyId,tenantId);

			LOGGER.debug("size of list: " + list);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", list);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/favorite-list/users/{userId}] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 자원예약 상세정보 조회 및 자원예약 권한 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceSchDetail(@PathVariable String resourceId, @PathVariable String scheduleId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/schedules/{schuduleId}] started.");
		JSONObject result = new JSONObject();
		
		try {
			

			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();
			
			LOGGER.debug("resourceId: " + resourceId);
			LOGGER.debug("scheduleId: " + scheduleId);
			LOGGER.debug("companyId: " + companyId);
			LOGGER.debug("tenantId: " + tenantId);
 
			MResourceScheduleVO resVO = mResourceService.getResScheduleDetail(resourceId, scheduleId, companyId, tenantId);

			resVO.setStartDate(startDate);
			resVO.setEndDate(endDate);
			
			String obj = "";
			
			Gson gson = new Gson();
			
			obj = gson.toJson(resVO);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", obj);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("resourceId: " + resourceId);
		LOGGER.debug("scheduleId: " + scheduleId);
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/schedules/{schuduleId}] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 자원예약중복조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/check-repetition", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceSchCheckRepeat(@PathVariable String resourceId, @PathVariable String scheduleId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/check-repetition] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = request.getParameter("companyId");
			
			LOGGER.debug("resourceId: " + resourceId);
			LOGGER.debug("scheduleId: " + scheduleId);
			LOGGER.debug("companyId: " + companyId);
			LOGGER.debug("tenantId: " + tenantId);
 
			MResourceScheduleVO resVO = mResourceService.getResScheduleDetail(resourceId, scheduleId, companyId, tenantId);

			String obj = "";
			
			Gson gson = new Gson();
			
			obj = gson.toJson(resVO);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", obj);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		
		LOGGER.debug("resourceId: " + resourceId);
		LOGGER.debug("scheduleId: " + scheduleId);
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/check-repetition] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [post] 자원예약등록
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/schedules", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addResourceSch(@PathVariable String resourceId, @RequestBody JSONObject jsonObject, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [POST /mobile/ezresource/resources/{resourceId}/schedules] started.");
		JSONObject result = new JSONObject();

		try {
			

			String serverName = request.getHeader("x-user-host");
			String userId =  jsonObject.get("userId").toString();
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			
			LOGGER.debug("tenantId: " + tenantId);
			
			String ownerId = resourceId; 
			String pNum = "";
			String endDate =  "";
			String importance =  "";
			String title =  ""; 
			String deptNm =  "";
			String timeDisplay =  ""; 
			String writeDay = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
			String writerId =  "";
			String content =  "";
			String ownerNm =  "";
			String allDay =  "0"; 
			String companyId =  "";
			String attachFlag =  ""; 
			String entryList =  ""; 
			String location =  ""; 
			String alterTime =  "";
			String startDate =  ""; 
			String scheduleId =  "";
			
			ownerId = resourceId; 
			
			if(jsonObject.containsKey("pNum")){
				pNum = jsonObject.get("pNum").toString();
			}
			
			if(jsonObject.containsKey("startDate")){
				startDate = jsonObject.get("startDate").toString();
			}
			
			if(jsonObject.containsKey("endDate")){
				endDate = jsonObject.get("endDate").toString();
			}
			
			if(jsonObject.containsKey("importance")){
				importance = jsonObject.get("importance").toString();
			}
			
			
			if(jsonObject.containsKey("title")){
				title = jsonObject.get("title").toString();
			}
			
			if(jsonObject.containsKey("deptNm")){
				deptNm = jsonObject.get("deptNm").toString();
			}
			
			if(jsonObject.containsKey("timeDisplay")){
				timeDisplay = jsonObject.get("timeDisplay").toString();
			}
			
			if(jsonObject.containsKey("userId")){
				writerId = jsonObject.get("userId").toString();
			}
			
			if(jsonObject.containsKey("content")){
				content = jsonObject.get("content").toString();
			}
			
			if(jsonObject.containsKey("writerName")){
				ownerNm = jsonObject.get("writerName").toString();
			}
			
			if(jsonObject.containsKey("companyId")){
				companyId = jsonObject.get("companyId").toString();
			}
			
			
			if(jsonObject.containsKey("attachFlag")){
				attachFlag = jsonObject.get("attachFlag").toString();
			}
			
			if(jsonObject.containsKey("entryList")){
				entryList = jsonObject.get("entryList").toString();
			}
			
			if(jsonObject.containsKey("location")){
				location = jsonObject.get("location").toString();
			}
			
			if(jsonObject.containsKey("alterTime")){
				alterTime = jsonObject.get("alterTime").toString();
			}
			
			if(jsonObject.containsKey("scheduleId")){
				scheduleId = jsonObject.get("scheduleId").toString();
			}

			writeDay = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
			allDay =  "0"; 
			String utcStartDate = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);//DB저장시 true 조회시 false
	    	String utcEndDate = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true); 
			String approveFlag =  "";
			

	    	LOGGER.debug("ownerId: " + ownerId);
	    	LOGGER.debug("companyId: " + companyId);	    	
	    	LOGGER.debug("pNum: " + pNum);
	    	LOGGER.debug("writerId: " + writerId);
	    	LOGGER.debug("deptNm: " + deptNm);
	    	LOGGER.debug("ownerNm: " + ownerNm);
	    	LOGGER.debug("title: " + title);
	    	LOGGER.debug("location: " + location);
	    	LOGGER.debug("timeDisplay: " + timeDisplay);
	    	LOGGER.debug("allDay: " + allDay);
	    	LOGGER.debug("alterTime: " + alterTime);
	    	LOGGER.debug("content: " + content);
	    	LOGGER.debug("importance: " + importance);
	    	LOGGER.debug("writeDay: " + writeDay);
	    	LOGGER.debug("entryList: " + entryList);
	    	LOGGER.debug("attachFlag: " + attachFlag);
	    	LOGGER.debug("scheduleId: " + scheduleId);
	    	LOGGER.debug("startDate: " + utcStartDate);
	    	LOGGER.debug("endDate: " + utcEndDate);
	    	LOGGER.debug("tenantId: " + tenantId);
	    	LOGGER.debug("approveFlag: " + approveFlag);

	    	mResourceService.addResSch(ownerId, companyId, tenantId, pNum, writerId, deptNm, ownerNm, title, location, timeDisplay, utcStartDate, utcEndDate, allDay, alterTime, content, importance, writeDay, entryList, attachFlag, approveFlag, scheduleId);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");	
			
		} catch (Exception e) {

			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("resourceId: " + resourceId);
		LOGGER.debug("jsonObject: " + jsonObject);
		LOGGER.debug("MOBILE G/W RESOURCE [POST /mobile/ezresource/resources/{resourceId}/schedules] ended.");	
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [put] 자원예약수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject modResourceSch(@PathVariable String resourceId, @PathVariable String scheduleId, @RequestBody JSONObject jsonObject, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [PUT /mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}] started.");
			JSONObject result = new JSONObject();
		
		String test = (String) jsonObject.get("userId");
		LOGGER.debug("test: " + test);
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			String userId =  jsonObject.get("userId").toString();
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			
			LOGGER.debug("tenantId: " + tenantId);
			
			String ownerId = resourceId; 
			String pNum = "";
			String endDate =  "";
			String importance =  "";
			String num = scheduleId;
			String title =  ""; 
			String deptNm =  "";
			String timeDisplay =  ""; 
			String writeDay = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
			String writerId =  "";
			String content =  "";
			String ownerNm =  "";
			String allDay =  "0"; 
			String companyId =  "";
			String attachFlag =  ""; 
			String entryList =  ""; 
			String location =  ""; 
			String alterTime =  "";
			String startDate =  ""; 

			
			ownerId = resourceId; 
			
			if(jsonObject.containsKey("pNum")){
				pNum = jsonObject.get("pNum").toString();
			}
			
			if(jsonObject.containsKey("startDate")){
				startDate = jsonObject.get("startDate").toString();
			}
			
			if(jsonObject.containsKey("endDate")){
				endDate = jsonObject.get("endDate").toString();
			}
			
			if(jsonObject.containsKey("importance")){
				importance = jsonObject.get("importance").toString();
			}
			
			
			if(jsonObject.containsKey("title")){
				title = jsonObject.get("title").toString();
			}
			
			if(jsonObject.containsKey("deptNm")){
				deptNm = jsonObject.get("deptNm").toString();
			}
			
			if(jsonObject.containsKey("timeDisplay")){
				timeDisplay = jsonObject.get("timeDisplay").toString();
			}
			
			if(jsonObject.containsKey("userId")){
				writerId = jsonObject.get("userId").toString();
			}
			
			if(jsonObject.containsKey("content")){
				content = jsonObject.get("content").toString();
			}
			
			if(jsonObject.containsKey("writerName")){
				ownerNm = jsonObject.get("writerName").toString();
			}
			
			if(jsonObject.containsKey("companyId")){
				companyId = jsonObject.get("companyId").toString();
			}
			
			if(jsonObject.containsKey("attachFlag")){
				attachFlag = jsonObject.get("attachFlag").toString();
			}
			
			if(jsonObject.containsKey("entryList")){
				entryList = jsonObject.get("entryList").toString();
			}
			
			if(jsonObject.containsKey("location")){
				location = jsonObject.get("location").toString();
			}
			
			if(jsonObject.containsKey("alterTime")){
				alterTime = jsonObject.get("alterTime").toString();
			}
			
			if(jsonObject.containsKey("scheduleId")){
				scheduleId = jsonObject.get("scheduleId").toString();
			}

			writeDay = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
			allDay =  "0"; 
			String utcStartDate = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);//DB저장시 true 조회시 false
	    	String utcEndDate = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true); 
			String approveFlag =  "";
			
			String alertTime = "";
			String reFlag = "0";
			String gresFlag = "";
			String characterId = "0";

	    	LOGGER.debug("ownerId: " + ownerId);
	    	LOGGER.debug("companyId: " + companyId);	    	
	    	LOGGER.debug("pNum: " + pNum);
	    	LOGGER.debug("writerId: " + writerId);
	    	LOGGER.debug("deptNm: " + deptNm);
	    	LOGGER.debug("ownerNm: " + ownerNm);
	    	LOGGER.debug("title: " + title);
	    	LOGGER.debug("location: " + location);
	    	LOGGER.debug("timeDisplay: " + timeDisplay);
	    	LOGGER.debug("allDay: " + allDay);
	    	LOGGER.debug("alterTime: " + alterTime);
	    	LOGGER.debug("content: " + content);
	    	LOGGER.debug("importance: " + importance);
	    	LOGGER.debug("writeDay: " + writeDay);
	    	LOGGER.debug("entryList: " + entryList);
	    	LOGGER.debug("attachFlag: " + attachFlag);
	    	LOGGER.debug("scheduleId: " + scheduleId);
	    	LOGGER.debug("startDate: " + utcStartDate);
	    	LOGGER.debug("endDate: " + utcEndDate);
	    	LOGGER.debug("tenantId: " + tenantId);
	    	LOGGER.debug("approveFlag: " + approveFlag);
	    	LOGGER.debug("alertTime: " + alertTime);
	    	LOGGER.debug("reFlag: " + reFlag);
	    	LOGGER.debug("gresFlag: " + gresFlag);
	    	LOGGER.debug("characterId: " + characterId);
	    	
	    	mResourceService.modifyResSch(title, location, timeDisplay, startDate, endDate, alertTime, content, importance, reFlag, gresFlag, allDay, writeDay, entryList, attachFlag, characterId, companyId, num, ownerId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");	
			
		} catch (Exception e) {

			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("resourceId: " + resourceId);
		LOGGER.debug("jsonObject: " + jsonObject);
		LOGGER.debug("MOBILE G/W RESOURCE [PUT /mobile/ezresource/resources/{resourceId}/schedules/{schuduleId}] ended.");	
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [delete] 자원예약삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject delResourceSch(@PathVariable String resourceId, @PathVariable String scheduleId,  HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [DELETE /mobile/ezresource/resources/{resourceId}/schedules/{schuduleId}] started.");
		JSONObject result = new JSONObject();
		
		
		try {
			

			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String reFlag = request.getParameter("reFlag");
			String offset = info.getOffSet();
			
			LOGGER.debug("companyId: " + companyId);
			LOGGER.debug("resourceId: " + resourceId);
			LOGGER.debug("scheduleId: " + scheduleId);
			LOGGER.debug("tenantId: " + tenantId);
			LOGGER.debug("startDate: " + startDate);
			LOGGER.debug("endDate: " + endDate); 
			LOGGER.debug("reFlag: " + reFlag); 
			
			mResourceService.delResSch(companyId, resourceId, scheduleId, startDate, endDate, offset, reFlag, tenantId);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");	
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("resourceId: " + resourceId);
		LOGGER.debug("schuduleId: " + scheduleId);
		LOGGER.debug("MOBILE G/W RESOURCE [DELETE /mobile/ezresource/resources/{resourceId}/schedules/{schuduleId}] ended.");	
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [delete] 즐겨찾기삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/favorite/users/{userId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject delFavorite(@PathVariable String resourceId, @PathVariable String userId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [DELETE /mobile/ezresource/resources/{resourceId}/favorite/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();

			mResourceService.delResFavor(resourceId, userId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");	
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("resourceId: " + resourceId);
		LOGGER.debug("userId: " + userId);
		LOGGER.debug("MOBILE G/W RESOURCE [DELETE /mobile/ezresource/resources/{resourceId}/favorite/{userId}] ended.");	
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [post] 즐겨찾기추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/favorite", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addFavorite(@PathVariable String resourceId, @RequestBody JSONObject jsonObject, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [POST /mobile/ezresource/resources/{resourceId}/favorite] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			String userId = (String) jsonObject.get("userId");
			
			LOGGER.debug("userId: " + userId);
			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();

			mResourceService.addResFavor(resourceId, companyId,userId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("resourceId: " + resourceId);
		LOGGER.debug("jsonObject: " + jsonObject);
		LOGGER.debug("MOBILE G/W RESOURCE [POST /mobile/ezresource/resources/{resourceId}/favorite] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [post] 휴일조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/holiday", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getHoliday( HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/holiday] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LOGGER.debug("userId: " + userId);		
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String cID = request.getParameter("COMPANYID");
			LOGGER.debug("cID: " + cID);
			//의미확인후 삭제
			cID = "VIEW";	
			List<ResScheGetHolidayVO> getHoliday = mResourceService.getTholiday(cID.trim(), info.getCompanyId(), info.getTenantId());
			

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", getHoliday);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/holiday] ended.");
		return result;
	}

}
