package egovframework.ezMobile.ezResource.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResAdminVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
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
	
	private static final Logger logger = LoggerFactory.getLogger(MResourceGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

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
	
	@Resource(name="EzNotificationService")
	private EzNotificationService ezNotificationService;
	
	/**
	 * 모바일 G/W 자원관리 [get] 자원예약리스트조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/main-list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceMainList(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/main-list/users/{userId}] started.");

		JSONObject result = new JSONObject();

		try {
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String langStr = info.getLang();
	    	String listCnt = "10";
	    	
	    	logger.debug("userId : " + userId);
	    	logger.debug("langStr : " + langStr);
	    				
			Map<String, Object> resultMap = mResourceService.getScheduleMainList(info, listCnt, langStr);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultMap);
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/main-list/users/{userId}] ended.");	
		
		return result;
	}
		
	/**
	 * 모바일 G/W 자원관리 [get] 자원예약리스트조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/{type}/list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceList(@PathVariable String type, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/{type}/list] started.");

		JSONObject result = new JSONObject();

		try {
			
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();			
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String companyId = info.getCompanyId();
    	
	    	String ownerId = request.getParameter("ownerId");
	    	String writerDt = info.getDeptId();	    	
	    	String offset = info.getOffSet();
	    	String favoriteYn = "N";
	    	
			String langStr = request.getParameter("langStr");
	    	
			logger.debug("info.getLang() ?? " + info.getLang());
			logger.debug("type : " + type);
			logger.debug("userId : " + userId);
			logger.debug("startDate : " + startDate);
			logger.debug("endDate : " + endDate);
			logger.debug("ownerId : " + ownerId);
			
	    	Map<String, Object> resultMap = mResourceService.getScheduleList(ownerId, companyId, startDate, endDate, writerDt, tenantId, offset, "", "", "", "", "", langStr);
			
	    	if(ownerId != null && !ownerId.equals("")) {
	    		List<MResourceScheduleVO> list = mResourceService.getResFavoriteList(userId, companyId, tenantId, langStr);
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
	    	
	    	String resApproveFlag = "0";
	    	
	    	if(ownerId != null && !ownerId.isEmpty()) {
		    	MResourceScheduleVO resVO = mResourceService.getResBrdDetail(ownerId, companyId, tenantId);
		    	resApproveFlag = resVO.getResApproveFlag();
	    	}
   	

	    	resultMap.put("resApproveFlag", resApproveFlag);
	    	
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultMap);
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/{type}/list] ended.");	
		
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
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/folder-list] started.");
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
			// 2018-10-31 김민성 - 자원관리 개별 자원 관리자 flag 추가
			Map<String, Object> resultMap = new HashMap<String, Object>();
			String adminYn = "N";
			
			logger.debug("userId : " + userId);
			logger.debug("brdId : " + brdId);
			logger.debug("langStr : " + langStr);
			
			/*if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
				authYn = "A";
			}*/
			
			// 2018-11-07 김민성 - 자원 관리자 권한 가진 자원분류 체크
			List<MResourceGetAdmSubClsTreeVO> adminCheckList = mResourceService.getResApprBrdListCheck(brdCompany, userId, userCompany, userDept , tenantId, langStr, authYn, brdId);

			if(adminCheckList.size() > 0) {
				authYn = "U";
				for(int i=0; i<adminCheckList.size(); i++) {
					if(adminCheckList.get(i).getAccessLvl() == 1) {
						authYn = "Y";
					}
				}
			}
			logger.debug("authYn : " + authYn);
			
			// 자원 관리자 권한 가진 자원이 있는지 체크해서 adminYn 값 Y로
			List<String> adminResList = mResourceService.getResAdminAuth(userId, tenantId, brdCompany);
			
			if(adminResList.size() > 0) {
				adminYn = "Y";
			}
			logger.debug("adminYn : " + adminYn);
			
			resultMap.put("authYn", authYn);
			resultMap.put("adminYn", adminYn);
			
			List<MResourceGetAdmSubClsTreeVO> list = mResourceService.getResBrdList(brdId, brdCompany, userId, userCompany, userDept , tenantId, langStr, authYn);
			
			resultMap.put("list", list);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultMap);
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/folder-list] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 즐겨찾기 대상 자원리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/favorite-list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceFavoriteList(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/favorite-list/users/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try {
			

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();
			String langStr = request.getParameter("langStr");
			
			logger.debug("userId : " + userId);
			logger.debug("langStr : " + langStr);
				
			List<MResourceScheduleVO> list = mResourceService.getResFavoriteList(userId, companyId, tenantId, langStr);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", list);
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/favorite-list/users/{userId}] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 자원예약 상세정보 조회 및 자원예약 권한 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/schedules/{scheduleId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceSchDetail(@PathVariable String resourceId, @PathVariable String scheduleId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/schedules/{schuduleId}] started.");
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
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			
			logger.debug("resourceId : " + resourceId);
			logger.debug("scheduleId : " + scheduleId);
			logger.debug("repDate : " + repDate);
			logger.debug("langStr : " + langStr);
			logger.debug("startDate : " + startDate);
			logger.debug("endDate : " + endDate);
 
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
	        
			//String reFlag = resVO.getReFlag();
			
/*			if(reFlag.equals("1")){
				resVO.setStartDate(commonUtil.getDateStringInUTC(repDate + resVO.getStartDate().substring(10), offset, false));
				resVO.setEndDate(commonUtil.getDateStringInUTC(repDate + resVO.getEndDate().substring(10), offset, false));
			} else {
				resVO.setStartDate(commonUtil.getDateStringInUTC(resVO.getStartDate(), offset, false));
				resVO.setEndDate(commonUtil.getDateStringInUTC(resVO.getEndDate(), offset, false));
			}*/
			
	        resVO.setWriteDay(commonUtil.getDateStringInUTC(resVO.getWriteDay(), offset, false));
	        
			resVO.setStartDate(startDate);
			resVO.setEndDate(endDate);

			String authYn = "N";
			
			/*if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
				authYn = "A";
			}*/
			
			List<MResourceGetAdmSubClsTreeVO> list = mResourceService.getResApprBrdList(companyId, userId, companyId, dept , tenantId, langStr, authYn);
			
			String apprAuthYn = "N";
			
			/*for (MResourceGetAdmSubClsTreeVO rVO : list) {
				if(rVO.getBrdId().equals(resourceId)){
					apprAuthYn = "Y";
				}
			}*/
			
			if(list.stream().anyMatch(rVO -> rVO.getBrdId().equals(resourceId))) {
				apprAuthYn = "Y";
			}
			
			resVO.setApprAuthYn(apprAuthYn);
			
			String obj = "";
			
			Gson gson = new Gson();
			
			obj = gson.toJson(resVO);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", obj);
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/schedules/{schuduleId}] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 자원예약중복조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/check-repetition", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceSchCheckRepeat(@PathVariable String resourceId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/check-repetition] started.");
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
			
			logger.debug("resourceId : " + resourceId);
			logger.debug("userId : " + userId);
			logger.debug("startDate : " + startDate);
			logger.debug("endDate : " + endDate);
			logger.debug("ownerId : " + ownerId);
			logger.debug("num : " + num);

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
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/check-repetition] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [post] 자원예약등록
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/schedules", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addResourceSch(@PathVariable String resourceId, @RequestBody JSONObject jsonObject, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [POST /mobile/ezresource/resources/{resourceId}/schedules] started.");
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
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	    	Calendar cal = Calendar.getInstance();
	    	cal.setTime(sdf.parse(endDate));
	    	
	    	if (cal.get(Calendar.HOUR) == 0 && cal.get(Calendar.MINUTE) == 0) {        		
	    		cal.add(Calendar.MINUTE, -1);        		
	    		endDate = sdf.format(cal.getTime());
	    	}
	    	endDate = sdf.format(sdf.parse(endDate));

			writeDay = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
			String utcStartDate = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);//DB저장시 true 조회시 false
	    	String utcEndDate = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true); 
	    	
	    	String approveFlag =  "1";
			MResourceScheduleVO resVO = mResourceService.getResBrdDetail(ownerId, companyId, tenantId);			
			String resApproveFlag = resVO.getResApproveFlag();
			
			logger.debug("resourceId : " + resourceId);
			logger.debug("userId : " + userId);
			logger.debug("startDate : " + startDate);
			logger.debug("endDate : " + endDate);
			logger.debug("importance : " + importance);
			logger.debug("title : " + title);
			logger.debug("content : " + content);
			logger.debug("allDay : " + allDay);
			logger.debug("reFlag : " + reFlag);
			logger.debug("resApproveFlag: " + resApproveFlag);
			
			if(resApproveFlag.equals("1")) {
				approveFlag =  "0";
			}
			
	    	int num = mResourceService.addResSch(ownerId, companyId, tenantId, pNum, writerId, deptNm, ownerNm, title, location, timeDisplay, utcStartDate, utcEndDate, allDay, alterTime, content, importance, writeDay, entryList, attachFlag, approveFlag, reFlag, scheduleId);
	    	
	    	if (startDate.length() == 16) {
	    		startDate += ":00";
	    	}
	    	
	    	if (endDate.length() == 16) {
	    		endDate += ":00";
	    	}
	    	
	    	String linkUrl = "/ezResource/scheduleRead.do?cmd=mod&from=schedule&num=" + num + "&ownerID=" + ownerId + "&type=Master&startDate=" + startDate.substring(0,10) + "&endDate=" + endDate.substring(0,10);
	    	String linkUrlMobile = "/mobile/ezResource/SearchResSchDetail.do?ownerId=" + ownerId + "&num=" + num + "&startDate=" + startDate.substring(0,19) + "&endDate=" + endDate.substring(0,19) + "&type=" + "res";
	    	List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
	    	
	    	String[] managerArray = resVO.getManagerIds().split(",");
	    	
	    	for (String manager : managerArray) {
	    		Map<String, Object> recipientMap = new HashMap<String, Object>();
	    		recipientMap.put("userType", "PERSON");
	    		recipientMap.put("companyId", info.getCompanyId());
	    		recipientMap.put("cn", manager);
	    		notiRecipientList.add(recipientMap);
	    	}
	    	
	    	ezNotificationService.sendNoti(request, userId, info.getUserName(), notiRecipientList, "RESOURCE", "RESERVE", resVO.getBrdNm() + " - " + title, "popup", "760", "750", linkUrl, linkUrlMobile, "notChkSetting");	    	
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");	
			
		} catch (Exception e) {

			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		logger.debug("MOBILE G/W RESOURCE [POST /mobile/ezresource/resources/{resourceId}/schedules] ended.");	
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [put] 자원예약수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/schedules/{scheduleId:.+}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject modResourceSch(@PathVariable String resourceId, @PathVariable String scheduleId, @RequestBody JSONObject jsonObject, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [PUT /mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}] started.");
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
			
			logger.debug("resourceId : " + resourceId);
			logger.debug("scheduleId : " + scheduleId);
			logger.debug("userId : " + userId);
			logger.debug("startDate" + startDate);
			logger.debug("endDate : " + endDate);
			logger.debug("importance : " + importance);
			logger.debug("title : " + title);
			logger.debug("content : " + content);
			logger.debug("reFlag : " + reFlag);
			logger.debug("allDay : " + allDay);
			logger.debug("resApproveFlag: " + resApproveFlag);
			
			if(resApproveFlag.equals("1")) {
				approveFlag =  "0";
			}
			
	    	mResourceService.modifyResSch(title,utcStartDate, utcEndDate, alertTime, content, importance, reFlag, allDay, approveFlag, companyId, num, ownerId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");	
			
		} catch (Exception e) {

			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		logger.debug("MOBILE G/W RESOURCE [PUT /mobile/ezresource/resources/{resourceId}/schedules/{schuduleId}] ended.");	
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [delete] 자원예약삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/schedules/{scheduleId:.+}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject delResourceSch(@PathVariable String resourceId, @PathVariable String scheduleId,  HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [DELETE /mobile/ezresource/resources/{resourceId}/schedules/{schuduleId}] started.");
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
			
			logger.debug("resourceId : " + resourceId);
			logger.debug("scheduleId : " + scheduleId);
			logger.debug("userId : " + userId);
			logger.debug("startDate" + startDate);
			logger.debug("endDate : " + endDate);
			logger.debug("reFlag : " + reFlag);
			
			mResourceService.delResSch(companyId, resourceId, scheduleId, startDate, endDate, offset, reFlag, tenantId);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");	
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		
		logger.debug("MOBILE G/W RESOURCE [DELETE /mobile/ezresource/resources/{resourceId}/schedules/{schuduleId}] ended.");	
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [delete] 즐겨찾기삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/favorite/users/{userId:.+}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject delFavorite(@PathVariable String resourceId, @PathVariable String userId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [DELETE /mobile/ezresource/resources/{resourceId}/favorite/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			
			logger.debug("resourceId : " + resourceId);
			logger.debug("userId : " + userId);

			mResourceService.delResFavor(resourceId, userId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");	
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		
		logger.debug("MOBILE G/W RESOURCE [DELETE /mobile/ezresource/resources/{resourceId}/favorite/{userId}] ended.");	
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [post] 즐겨찾기추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/favorite", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addFavorite(@PathVariable String resourceId, @RequestBody JSONObject jsonObject, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [POST /mobile/ezresource/resources/{resourceId}/favorite] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			String userId = (String) jsonObject.get("userId");
			
			logger.debug("resourceId : " + resourceId);
			logger.debug("userId : " + userId);
			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();

			mResourceService.addResFavor(resourceId, companyId,userId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		logger.debug("MOBILE G/W RESOURCE [POST /mobile/ezresource/resources/{resourceId}/favorite] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [post] 휴일조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/holiday", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getHoliday( HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/holiday] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String cID = request.getParameter("COMPANYID");
			//의미확인후 삭제 또는 변경
			cID = "VIEW";	
			List<ResScheGetHolidayVO> getHoliday = mResourceService.getTholiday(cID.trim(), info.getCompanyId(), info.getTenantId());
			List<ResScheGetHolidayVO> getHoliday2 = mResourceService.getTholiday(cID.trim(), "ALL", info.getTenantId());
			
			logger.debug("userId : " + userId);
			logger.debug("companyID : " + cID);
			
			Map<String, Object> resultMap = new HashMap<String, Object>();
			resultMap.put("getHoliday", getHoliday);
			resultMap.put("memorialDay", getHoliday2);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultMap);
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/holiday] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 자원예약 승인대상 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/approve-list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject approveList( @PathVariable String userId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/approve-list/users/{userId}] started.");
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
			
			/*if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
				authYn = "A";
			}*/
	    	
			logger.debug("userId: " + userId);
	    	logger.debug("serverName: " + serverName);
	    	logger.debug("tenantId: " + tenantId);
	    	logger.debug("startDate: " + startDate);
	    	logger.debug("endDate: " + endDate);
	    	logger.debug("companyId: " + companyId);
	    	logger.debug("ownerId: " + ownerId);
	    	logger.debug("offset: " + offset);
	    	logger.debug("writerName: " + writerName);
	    	logger.debug("approveType: " + approveType);
	    	logger.debug("langStr: " + langStr);

	    	Map<String, Object> resultMap = mResourceService.getScheduleApprList(ownerId, companyId, startDate, endDate, userId, deptId, writerName, approveType, tenantId, offset, "", "", "", "", langStr, authYn);
				    	
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultMap);
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/approve-list/users/{userId}] ended.");
		return result;
	}

	/**
	 * 모바일 G/W 자원관리 [get] 자원예약 승인중복조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/approve-repetition", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject approveRepetition(@PathVariable String resourceId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/approve-repetition] started.");
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
			
			/*if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
				authYn = "A";
			}*/
			
			logger.debug("resourceId: " + resourceId);
			logger.debug("userId: " + userId);
	    	logger.debug("startDate: " + startDate);
	    	logger.debug("endDate: " + endDate);
	    	
	    	Map<String, Object> resultMap = mResourceService.getScheduleApprList(resourceId, companyId, startDate, endDate, userId, deptId, "", "1", tenantId, offset, "Y", "", sDate, eDate, info.getLang(), authYn);
			
			String obj = "";
			
			Gson gson = new Gson();
			
			obj = gson.toJson(resultMap);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", obj);
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/approve-repetition] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [put] 자원예약 승인/미승인 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/approve-flag", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateApproveFlag(@PathVariable String resourceId, @PathVariable String scheduleId, @RequestBody JSONObject jsonObject,  HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [PUT /mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/approve-flag] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			String userId = jsonObject.get("userId").toString();
			String approve = jsonObject.get("approveType").toString();
			String ownerId = jsonObject.get("ownerId").toString();
			String startDate = jsonObject.get("startDate").toString();
			String endDate = jsonObject.get("endDate").toString();
			String num = request.getParameter("num");
			String title = jsonObject.get("title").toString();
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			logger.debug("resourceId: " + resourceId);
			logger.debug("scheduleId: " + scheduleId);
			logger.debug("userId: " + userId);
	    	logger.debug("approve: " + approve);
			
			ezResourceService.updateSchedule(Integer.parseInt(scheduleId), resourceId, info.getCompanyId(), approve, info.getTenantId());
			
			if (startDate.length() == 16) {
	    		startDate += ":00";
	    	}
	    	
	    	if (endDate.length() == 16) {
	    		endDate += ":00";
	    	}
	    	MResourceScheduleVO resVO = mResourceService.getResScheduleDetail(resourceId, scheduleId, info.getCompanyId(), info.getTenantId(), info.getLang());
	    	String linkUrl = "/ezResource/scheduleRead.do?cmd=mod&from=schedule&num=" + num + "&ownerID=" + ownerId + "&type=Master&startDate=" + startDate.substring(0,10) + "&endDate=" + endDate.substring(0,10);
	    	String linkUrlMobile = "/mobile/ezResource/SearchResSchDetail.do?ownerId=" + ownerId + "&num=" + num + "&startDate=" + startDate.substring(0,19) + "&endDate=" + endDate.substring(0,19) + "&type=" + "res";
	    	
	    	String notiSubType = "";
	    	switch (approve) {
			case "0":
				notiSubType = "CANCEL";
				break;
			case "1":
				notiSubType = "APPROVE";
				break;
			case "2":
				notiSubType = "REJECT";
				break;
			}
	    	
	    	List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
			Map<String, Object> recipientMap = new HashMap<String, Object>();
			recipientMap.put("userType", "PERSON");
			recipientMap.put("companyId", info.getCompanyId());
			recipientMap.put("cn", resVO.getWriterId());
			notiRecipientList.add(recipientMap);
			
	    	ezNotificationService.sendNoti(request, userId, info.getUserName(), notiRecipientList, "RESOURCE", notiSubType, resVO.getBrdNm() + " - " + title, "popup", "760", "750", linkUrl, linkUrlMobile, "");	    	
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		logger.debug("MOBILE G/W RESOURCE [PUT /mobile/ezresource/resources/{resourceId}/schedules/{scheduleId}/approve-flag] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [post] 자원예약 승인/미승인 처리결과 메일 전송
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/send-mail/users/{userId:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject sendMailApprove(@PathVariable String userId, @RequestBody JSONObject jsonObject, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [POST /mobile/ezresource/send-mail/users/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String ownerID = (String) jsonObject.get("ownerId");
			String num = (String) jsonObject.get("num");
			String startDateTime = (String) jsonObject.get("startDate");
			String endDateTime = (String) jsonObject.get("endDate");
			String loginCookie = (String) jsonObject.get("loginCookie");
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			logger.debug("userId" + userId);
			logger.debug("ownerID" + ownerID);
			logger.debug("num" + num);
			logger.debug("startDateTime" + startDateTime);
			logger.debug("endDateTime" + endDateTime);
			logger.debug("loginCookie" + loginCookie);
			
			MResourceScheduleVO resVO = mResourceService.getResScheduleDetail(ownerID, num, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLang());
			
			String title = resVO.getTitle();
			
			startDateTime = commonUtil.getDateStringInUTC(startDateTime, userInfo.getOffset(), false);
			endDateTime = commonUtil.getDateStringInUTC(endDateTime, userInfo.getOffset(), false);
			
			logger.debug("ownerID=" + ownerID + ",title=" + title + ",startDateTime=" + startDateTime + ",endDateTime=" + endDateTime);
			
			// 2018-10-29 김민성 - 모바일 자원관리 예약시 관리자들에게 메일 발송 처리
			ResBrdVO resbrd = ezResourceService.getBrd(Integer.parseInt(ownerID), userInfo.getCompanyID(), userInfo.getTenantId());
			String[] ownerList = resbrd.getOwnerID().split(",");
			
			List<ResAdminVO> resInfo = ezResourceService.getResourceAdminInfo(ownerID, userInfo.getTenantId(), ownerList);
	        
	        StringBuilder bodyContent = new StringBuilder();

	        if (userInfo.getPrimary().equals("1")) {
	        	bodyContent.append(userInfo.getDisplayName() +"[" + userInfo.getDeptName() + "] " + egovMessageSource.getMessage("ezResource.t9900002", userInfo.getLocale()));
	        } else {
	        	bodyContent.append(userInfo.getDisplayName2() +"[" + userInfo.getDeptName2() + "] " + egovMessageSource.getMessage("ezResource.t9900002", userInfo.getLocale()));
	        }
	        
	        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezResource.t9900003", userInfo.getLocale()) + " : " +resInfo.get(0).getBrdNm()); 
	        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezResource.t9900004", userInfo.getLocale()) + " : " +startDateTime + "&nbsp;~&nbsp;" + endDateTime);
	        
	        String subject = "[" + egovMessageSource.getMessage("ezResource.t171", userInfo.getLocale()) + resInfo.get(0).getBrdNm() + "] " + title;
	        String content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
	        
	    	InternetAddress from = new InternetAddress();
	    	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
	    	from.setAddress(userInfo.getEmail());
	    	
	    	for(int i=0; i<resInfo.size(); i++) {
		    	String emailAddress = resInfo.get(i).getMailAddress();
		    	String accessName = resInfo.get(i).getOwnerNm();
		    	
		    	InternetAddress to = new InternetAddress();
		    	to.setPersonal(accessName, "UTF-8");
		    	to.setAddress(emailAddress);
		        	
		        
		        ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
		    }
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		logger.debug("MOBILE G/W RESOURCE [POST /mobile/ezresource/send-mail/users/{userId}] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 승인대상 자원리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/apprFolder-list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceApprFolderList(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/apprfolder-list/users/{userId}] started.");
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
			
			/*if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
				authYn = "A";
			}*/
			
			logger.debug("userId" + userId);
			logger.debug("langStr" + langStr);
			
			List<MResourceGetAdmSubClsTreeVO> list = mResourceService.getResApprBrdList(brdCompany, userId, userCompany, userDept , tenantId, langStr, authYn);
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data",list);
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/apprfolder-list/users/{userId}] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 승인대상 자원권한체크
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezresource/auth-check/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject resourceApprFolderListCheck(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/auth-check/users/{userId}] started.");
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
			// 2018-10-31 김민성 - 자원관리 개별 자원 관리자 flag 추가
			String adminYn = "N";
			String ownerId = "";
			if(request.getParameter("ownerId") != null) {
				ownerId = request.getParameter("ownerId");
			}
			
			logger.debug("tenantId: " + tenantId);
			logger.debug("userDept: " + userDept);
			logger.debug("userCompany: " + userCompany);
			logger.debug("brdCompany: " + brdCompany);
			logger.debug("userId: " + userId);
			logger.debug("langStr: " + langStr);
			logger.debug("ownerId: " + ownerId);
			
			String authCheck = "N";
			
			/*if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
				authYn = "A";
				authCheck = "Y";
			}*/
			logger.debug("authYn: " + authYn);
			if(!authYn.equals("A")) {
				
				List<MResourceGetAdmSubClsTreeVO> list = mResourceService.getResApprBrdListCheck(brdCompany, userId, userCompany, userDept , tenantId, langStr, authYn, "");
				if(!ownerId.equals("") && !ownerId.equals("1")) {
					/*for(int i=0; i<list.size(); i++) {
						if(list.get(i).getBrdId().equals(ownerId)) {
							authCheck = "Y";
						}
					}*/
					// 20-03-06 김민성 - ownerId가 자원분류의 값이 아닌 자원ID 값인 경우가 있어 수정함
					String ownerId2 = mResourceService.getResUpperBrdID(ownerId, tenantId, userCompany);
					if(list.stream().anyMatch(res -> res.getBrdId().equals(ownerId2))) {
						authCheck = "Y";
					}
				}
				else {
					if(list.size() > 0) {
						authCheck = "Y";
					}
				}
			}

			logger.debug("authCheck: " + authCheck);
			
			// 2018-10-31 김민성 - 자원 관리자 권한 가진 자원이 있는지 체크
			List<String> adminResList = mResourceService.getResAdminAuth(userId, tenantId, brdCompany);
			if(!ownerId.equals("")) {
				/*for(int i=0; i<adminResList.size(); i++) {
					if(adminResList.get(i).equals(ownerId)) {
						adminYn = "Y";
					}
				}*/
				String ownerId2 = ownerId;
				if(adminResList.stream().anyMatch(res -> res.equals(ownerId2))) {
					adminYn = "Y";
				}
			}
			else {
				if(adminResList.size() > 0) {
					adminYn = "Y";
				}
			}
						
			logger.debug("adminYn: " + adminYn);
			
			Map<String, String> resultMap = new HashMap<String, String>();
			resultMap.put("authCheck", authCheck);
			resultMap.put("adminYn", adminYn);
			
			String obj = "";
			
			Gson gson = new Gson();
			
			obj = gson.toJson(resultMap);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data",obj);
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezresource/auth-check/users/{userId}] ended.");
		return result;
	}
	
}
