package egovframework.ezMobile.ezResource.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResAdminVO;
import egovframework.ezEKP.ezResource.vo.ResMakeDupResultVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.ezMobile.ezResource.vo.MResourceScheduleVO;
import egovframework.ezMobile.ezResource.vo.ResScheGetHolidayVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
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

	@Autowired
	private Properties config;	
	
	@Resource(name="MResourceService")
	private MResourceService mResourceService;
		
	@Resource(name="loginService")
	private LoginService loginService;

	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name="EzResourceService")
	private EzResourceService ezResourceService;
	
	@Resource(name="EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
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
			String langStr = request.getParameter("langStr");
	    	String listCnt = "10";
	    				
			Map<String, Object> resultMap = mResourceService.getScheduleMainList(info, listCnt, langStr);

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
    	
	    	String ownerId = request.getParameter("ownerId");;	    	
	    	String writerDt = info.getDeptId();	    	
	    	String offset = info.getOffSet();
	    	String favoriteYn = "N";
	    	
			String langStr = request.getParameter("langStr");
	    	
			LOGGER.debug("info.getLang() ?? " + info.getLang());
			
	    	Map<String, Object> resultMap = mResourceService.getScheduleList(ownerId, companyId, startDate, endDate, writerDt, tenantId, offset, "", "", "", "", "", langStr);
			
	    	if(ownerId != null && !ownerId.equals("")) {
	    		List<MResourceScheduleVO> list = mResourceService.getResFavoriteList(request.getParameter("userId"), companyId, tenantId, langStr);
		    	if(list.size() > 0) {
		    		for (MResourceScheduleVO mResourceScheduleVO : list) {
						if(mResourceScheduleVO.getResId() != null) {
			    			if(mResourceScheduleVO.getResId().equals(ownerId)) {
								favoriteYn = "Y";
							}							
						}

					}
		    	}
	    	}
	    	
	    	resultMap.put("favoriteYn", favoriteYn);
	    	
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
			String userCompany = info.getCompanyId();
			String userDept = info.getDeptId();
			String langStr = request.getParameter("langStr");
			String authYn = "N";
			
			if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
				authYn = "A";
			}
			
			List<MResourceGetAdmSubClsTreeVO> list = mResourceService.getResBrdList(brdId, brdCompany, userId, userCompany, userDept , tenantId, langStr, authYn);
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
			String langStr = request.getParameter("langStr");
				
			List<MResourceScheduleVO> list = mResourceService.getResFavoriteList(userId, companyId, tenantId, langStr);

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
			String repDate = request.getParameter("repDate");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String offset = info.getOffSet();
			String companyId = info.getCompanyId();
			String langStr = request.getParameter("langStr");
			String dept = info.getDeptId();
 
			MResourceScheduleVO resVO = mResourceService.getResScheduleDetail(resourceId, scheduleId, companyId, tenantId, langStr);

			String content = resVO.getContent();
			
			Document doc = Jsoup.parse(content);
			Elements elems = doc.select("[src]");
			
			if(elems.size() > 0) {
				for (Element element : elems) {
					element.attr("src", "/mobile/ezCommon/mFileDown.do?filePath=" + element.attr("src") + "&fileName=*.INLINE.*");
				}
			}
	        content = doc.toString();
			
	        resVO.setContent(content);
			String reFlag = resVO.getReFlag();
			
			if(reFlag.equals("1")){
				resVO.setStartDate(commonUtil.getDateStringInUTC(repDate + resVO.getStartDate().substring(10), offset, false));
				resVO.setEndDate(commonUtil.getDateStringInUTC(repDate + resVO.getEndDate().substring(10), offset, false));
			} else {
				resVO.setStartDate(commonUtil.getDateStringInUTC(resVO.getStartDate(), offset, false));
				resVO.setEndDate(commonUtil.getDateStringInUTC(resVO.getEndDate(), offset, false));
			}

			String authYn = "N";
			
			if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
				authYn = "A";
			}
			
			List<MResourceGetAdmSubClsTreeVO> list = mResourceService.getResApprBrdList(companyId, userId, companyId, dept , tenantId, langStr, authYn);
			
			String apprAuthYn = "N";
			
			for (MResourceGetAdmSubClsTreeVO rVO : list) {
				if(rVO.getBrdId().equals(resourceId) || authYn.equals("A")){
					apprAuthYn = "Y";
				}
			}
			
			resVO.setApprAuthYn(apprAuthYn);
			
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

		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/schedules/{schuduleId}] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 자원예약중복조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/check-repetition", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceSchCheckRepeat(@PathVariable String resourceId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/check-repetition] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();
			String startDate = request.getParameter("startDate");
			String endDate =  request.getParameter("endDate");
			String ownerId = request.getParameter("ownerId");
			String num = request.getParameter("num");
			String offset = info.getOffSet();
			String writerDt = "";
			String sDate = startDate.substring(0, 10);
			String eDate = endDate.substring(0, 10);

			MResourceScheduleVO resVO = mResourceService.getResBrdDetail(ownerId, companyId, tenantId);
			
			Map<String, Object> resultMap = new HashMap<String, Object>();
		

			String resApproveFlag = resVO.getResApproveFlag();
			
			if(resApproveFlag.equals("0")) {
				resultMap = mResourceService.getScheduleList(ownerId, companyId, sDate, eDate, writerDt, tenantId, offset, "", "Y", num, startDate, endDate, info.getLang());
			}
			
			
			String obj = "";
			
			Gson gson = new Gson();
			
			obj = gson.toJson(resultMap);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", obj);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/check-repetition] ended.");
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
			
			String ownerId = resourceId; 
			String pNum = "";
			String endDate = jsonObject.get("endDate").toString();
			String importance = jsonObject.get("importance").toString();
			String title =  jsonObject.get("title").toString(); 
			String deptNm =  info.getDeptName();
			String timeDisplay =  ""; 
			String writeDay = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
			String writerId =  userId;
			String content =  jsonObject.get("content").toString();
			String ownerNm =  info.getUserName();
			String allDay =  jsonObject.get("allDay").toString(); 
			String companyId =  info.getCompanyId();
			String attachFlag =  ""; 
			String entryList =  ""; 
			String location =  ""; 
			String alterTime =  "";
			String startDate =  jsonObject.get("startDate").toString(); 
			String scheduleId =  "";
			String reFlag =  jsonObject.get("reFlag").toString();

			writeDay = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
			String utcStartDate = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);//DB저장시 true 조회시 false
	    	String utcEndDate = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true); 
	    	
	    	String approveFlag =  "1";
			MResourceScheduleVO resVO = mResourceService.getResBrdDetail(ownerId, companyId, tenantId);			
			String resApproveFlag = resVO.getResApproveFlag();			
			if(resApproveFlag.equals("1")) {
				approveFlag =  "0";
			}
			
	    	mResourceService.addResSch(ownerId, companyId, tenantId, pNum, writerId, deptNm, ownerNm, title, location, timeDisplay, utcStartDate, utcEndDate, allDay, alterTime, content, importance, writeDay, entryList, attachFlag, approveFlag, reFlag, scheduleId);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");	
			
		} catch (Exception e) {

			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

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
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			String userId =  jsonObject.get("userId").toString();
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String ownerId = resourceId; 
			String endDate = jsonObject.get("endDate").toString();
			String importance = jsonObject.get("importance").toString();
			String num = scheduleId;
			String title = jsonObject.get("title").toString();
			String content = jsonObject.get("content").toString(); 
			String companyId =  info.getCompanyId();
			String startDate = jsonObject.get("startDate").toString(); 
			String reFlag = jsonObject.get("reFlag").toString(); 
			String alertTime = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"); 
			String utcStartDate = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);//DB저장시 true 조회시 false
	    	String utcEndDate = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);
	    	String allDay = jsonObject.get("allDay").toString(); 
	    	
	    	String approveFlag =  "1";
			MResourceScheduleVO resVO = mResourceService.getResBrdDetail(ownerId, companyId, tenantId);			
			String resApproveFlag = resVO.getResApproveFlag();			
			if(resApproveFlag.equals("1")) {
				approveFlag =  "0";
			}
			
	    	mResourceService.modifyResSch(title,utcStartDate, utcEndDate, alertTime, content, importance, reFlag, allDay, approveFlag, companyId, num, ownerId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");	
			
		} catch (Exception e) {

			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

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
			
			mResourceService.delResSch(companyId, resourceId, scheduleId, startDate, endDate, offset, reFlag, tenantId);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");	
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		
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
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String cID = request.getParameter("COMPANYID");
			//의미확인후 삭제 또는 변경
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
	
	/**
	 * 모바일 G/W 자원관리 [get] 자원예약 승인대상 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/approve-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject approveList( @PathVariable String userId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/approve-list/users/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();			
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String companyId = info.getCompanyId();
			String deptId = info.getDeptId();    	
	    	String ownerId = request.getParameter("ownerId");   	
	    	String offset = info.getOffSet();	    	
	    	String writerName = request.getParameter("writerName");
	    	String approveType = request.getParameter("approveType");
	    	String langStr = request.getParameter("langStr");
	    	
	    	if(langStr == null || langStr.equals("")) {
	    		langStr = "1";
	    	}
	    	
			String authYn = "N";
			
			if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
				authYn = "A";
			}
	    	
	    	LOGGER.debug("serverName: " + serverName);
	    	LOGGER.debug("tenantId: " + tenantId);
	    	LOGGER.debug("startDate: " + startDate);
	    	LOGGER.debug("endDate: " + endDate);
	    	LOGGER.debug("companyId: " + companyId);
	    	LOGGER.debug("ownerId: " + ownerId);
	    	LOGGER.debug("offset: " + offset);
	    	LOGGER.debug("writerName: " + writerName);
	    	LOGGER.debug("approveType: " + approveType);

	    	Map<String, Object> resultMap = mResourceService.getScheduleApprList(ownerId, companyId, startDate, endDate, userId, deptId, writerName, approveType, tenantId, offset, "", "", "", "", langStr, authYn);
				    	
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultMap);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/approve-list/users/{userId}] ended.");
		return result;
	}

	/**
	 * 모바일 G/W 자원관리 [get] 자원예약 승인중복조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/approve-repetition", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject approveRepetition(@PathVariable String resourceId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/approve-repetition] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();			
			String sDate = request.getParameter("startDate");
			String eDate = request.getParameter("endDate");
			String startDate = sDate.substring(0, 10);
			String endDate = eDate.substring(0, 10);
			String companyId = info.getCompanyId();
			String deptId = info.getDeptId();  	
	    	String offset = info.getOffSet();
	    	
			String authYn = "N";
			
			if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
				authYn = "A";
			}
	    	
	    	Map<String, Object> resultMap = mResourceService.getScheduleApprList(resourceId, companyId, startDate, endDate, userId, deptId, "", "1", tenantId, offset, "Y", "", sDate, eDate, info.getLang(), authYn);
			
			String obj = "";
			
			Gson gson = new Gson();
			
			obj = gson.toJson(resultMap);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", obj);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/approve-repetition] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [put] 자원예약 승인/미승인 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/approve-flag", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateApproveFlag(@PathVariable String resourceId, @PathVariable String scheduleId, @RequestBody JSONObject jsonObject,  HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [PUT /mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/approve-flag] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			String userId = jsonObject.get("userId").toString();
			String approve = jsonObject.get("approveType").toString();
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			ezResourceService.updateSchedule(Integer.parseInt(scheduleId), resourceId, info.getCompanyId(), approve, info.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		LOGGER.debug("MOBILE G/W RESOURCE [PUT /mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/approve-flag] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [post] 자원예약 승인/미승인 처리결과 메일 전송
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/send-mail/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject sendMailApprove(@PathVariable String userId, @RequestBody JSONObject jsonObject, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [POST /mobile/ezresource/send-mail/users/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String ownerID = (String) jsonObject.get("ownerId");
			String num = (String) jsonObject.get("num");
			String startDateTime = (String) jsonObject.get("startDate");
			String endDateTime = (String) jsonObject.get("endDate");
			String loginCookie = (String) jsonObject.get("loginCookie");
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			LOGGER.debug("ownerID" + ownerID);
			LOGGER.debug("num" + num);
			LOGGER.debug("startDateTime" + startDateTime);
			LOGGER.debug("endDateTime" + endDateTime);
			LOGGER.debug("loginCookie" + loginCookie);
			
			MResourceScheduleVO resVO = mResourceService.getResScheduleDetail(ownerID, num, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLang());
			
			String title = resVO.getTitle();
			
			startDateTime = commonUtil.getDateStringInUTC(startDateTime, userInfo.getOffset(), false);
			endDateTime = commonUtil.getDateStringInUTC(endDateTime, userInfo.getOffset(), false);
			
			LOGGER.debug("ownerID=" + ownerID + ",title=" + title + ",startDateTime=" + startDateTime + ",endDateTime=" + endDateTime);
			
			ResAdminVO resInfo = ezResourceService.getResourceAdminInfo(ownerID, userInfo.getTenantId());
	        
	        StringBuilder bodyContent = new StringBuilder();

	        bodyContent.append("<DIV id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">");
	        
	        if (userInfo.getPrimary().equals("1")) {
	        	bodyContent.append(userInfo.getDisplayName() +"[" + userInfo.getDeptName() + "] " + egovMessageSource.getMessage("ezResource.t9900002", userInfo.getLocale()));
	        } else {
	        	bodyContent.append(userInfo.getDisplayName2() +"[" + userInfo.getDeptName2() + "] " + egovMessageSource.getMessage("ezResource.t9900002", userInfo.getLocale()));
	        }
	        
	        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezResource.t9900003", userInfo.getLocale()) + " : " +resInfo.getBrdNm()); 
	        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezResource.t9900004", userInfo.getLocale()) + " : " +startDateTime + "&nbsp;~&nbsp;" + endDateTime);
	        bodyContent.append("</DIV>");
	        
	        String subject = "[" + egovMessageSource.getMessage("ezResource.t171", userInfo.getLocale()) + resInfo.getBrdNm() + "] " + title;
	        
	        
	    	InternetAddress from = new InternetAddress();
	    	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
	    	from.setAddress(userInfo.getEmail());
	    	
	    	String emailAddress = resInfo.getMailAddress();
	    	String accessName = resInfo.getOwnerNm();
	    	
	    	if (accessName.indexOf("(") > -1) {
	    		accessName = accessName.split("(")[0];
	    	}
	    	
	    	InternetAddress to = new InternetAddress();
	    	to.setPersonal(accessName, "UTF-8");
	    	to.setAddress(emailAddress);
	        	
	        
	        ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
	       
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		LOGGER.debug("MOBILE G/W RESOURCE [POST /mobile/ezresource/send-mail/users/{userId}] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 승인대상 자원리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/apprFolder-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceApprFolderList(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/apprfolder-list/users/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String brdCompany = info.getCompanyId();
			String userCompany = info.getCompanyId();
			String userDept = info.getDeptId();
			String langStr = request.getParameter("langStr");
			String authYn = "N";
			
			if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
				authYn = "A";
			}
			
			List<MResourceGetAdmSubClsTreeVO> list = mResourceService.getResApprBrdList(brdCompany, userId, userCompany, userDept , tenantId, langStr, authYn);
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data",list);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/apprfolder-list/users/{userId}] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 승인대상 자원권한체크
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/auth-check/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceApprFolderListCheck(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/auth-check/users/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String brdCompany = info.getCompanyId();
			String userCompany = info.getCompanyId();
			String userDept = info.getDeptId();
			String langStr = request.getParameter("langStr");
			String authYn = "N";
			
			LOGGER.debug("tenantId: " + tenantId);
			LOGGER.debug("userDept: " + userDept);
			LOGGER.debug("userCompany: " + userCompany);
			LOGGER.debug("brdCompany: " + brdCompany);
			LOGGER.debug("userId: " + userId);
			
			String authCheck = "N";
			
			if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
				authYn = "A";
				authCheck = "Y";
			}
			LOGGER.debug("authYn: " + authYn);
			
			if(!authYn.equals("A")) {
				
				LOGGER.debug("in authYn check!!!!!");
				List<MResourceGetAdmSubClsTreeVO> list = mResourceService.getResApprBrdListCheck(brdCompany, userId, userCompany, userDept , tenantId, langStr, authYn);					
			
				LOGGER.debug("list: " + list);
				
				if(list.size() > 0) {
					authCheck = "Y";
				}
			}

			LOGGER.debug("authCheck: " + authCheck);
			
			Map<String, String> resultMap = new HashMap<String, String>();
			resultMap.put("authCheck", authCheck);
			
			String obj = "";
			
			Gson gson = new Gson();
			
			obj = gson.toJson(resultMap);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data",obj);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/auth-check/users/{userId}] ended.");
		return result;
	}
	
}
