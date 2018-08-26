package egovframework.ezMobile.ezSchedule.web;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
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

import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezSchedule.service.MScheduleService;
import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 모바일 G/W 일정관리
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.07.24         장진혁   	     신규작성
 *
 * @see
 */
@SuppressWarnings("unchecked")
@RestController
public class MScheduleGWController extends EgovFileMngUtil {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MScheduleGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;
		
	@Resource(name="MScheduleService")
	private MScheduleService mScheduleService;
		
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
		
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 리스트 (월간,주간,일정검색)
	 */	
	@RequestMapping(value="/mobile/ezschedule/list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleList(@PathVariable String userId, HttpServletRequest request){
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String searchTitle = request.getParameter("searchTitle");
			
			/* 2018-02-01 장진혁 모바일에서 검색을 다양하게 하기 위한 요소 추가 */ 
			String searchColumn = request.getParameter("searchColumn");
			String searchData = request.getParameter("searchData");
			
			LOGGER.debug("searchTitle: " + searchTitle);
			
			if (startDate != null && !startDate.equals("")) {
				String[] sDate = startDate.split("-");
				String sMon = (sDate[1].length() == 1 ? "0" + sDate[1] : sDate[1]);
				String sDay = (sDate[2].length() == 1 ? "0" + sDate[2] : sDate[2]);
				
				startDate = sDate[0] + "-" + sMon + "-" + sDay + " 00:00:00";
			} else {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar cal = Calendar.getInstance();
				
				startDate = sdf.format(cal.getTime()) + " 00:00:00";
			}
			
			if (endDate != null && !endDate.equals("")) {
				String[] eDate = endDate.split("-");
				String eMon = (eDate[1].length() == 1 ? "0" + eDate[1] : eDate[1]);
				String eDay = (eDate[2].length() == 1 ? "0" + eDate[2] : eDate[2]);
				
				endDate = eDate[0] + "-" + eMon + "-" + eDay  + " 23:59:59";
			} else {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar cal = Calendar.getInstance();
				
				endDate = sdf.format(cal.getTime()) + " 23:59:59";
			}
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			/* 2018-02-01 장진혁 모바일에서 검색을 다양하게 하기 위한 요소 추가 */
			List<ScheduleInfoVO> sList = mScheduleService.scheduleList(info, startDate, endDate, searchTitle, searchColumn, searchData);
						
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", sList);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list/users/{userId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 카운트 (월간,주간,일정검색)
	 */
	@RequestMapping(value="/mobile/ezschedule/list-count/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleListCount(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list-count/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String searchTitle = request.getParameter("searchTitle");
			
			/* 2018-02-01 장진혁 모바일에서 검색을 다양하게 하기 위한 요소 추가 */
			String searchColumn = request.getParameter("searchColumn");
			String searchData = request.getParameter("searchData");
			
			if (startDate != null && !startDate.equals("")) {
				String[] sDate = startDate.split("-");
				String sMon = (sDate[1].length() == 1 ? "0" + sDate[1] : sDate[1]);
				String sDay = (sDate[2].length() == 1 ? "0" + sDate[2] : sDate[2]);
				
				startDate = sDate[0] + "-" + sMon + "-" + sDay + " 00:00:00";
			} else {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar cal = Calendar.getInstance();
				
				startDate = sdf.format(cal.getTime()) + " 00:00:00";
			}
			
			if (endDate != null && !endDate.equals("")) {
				String[] eDate = endDate.split("-");
				String eMon = (eDate[1].length() == 1 ? "0" + eDate[1] : eDate[1]);
				String eDay = (eDate[2].length() == 1 ? "0" + eDate[2] : eDate[2]);
				
				endDate = eDate[0] + "-" + eMon + "-" + eDay  + " 23:59:59";
			} else {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar cal = Calendar.getInstance();
				
				endDate = sdf.format(cal.getTime()) + " 23:59:59";
			}
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			/* 2018-02-01 장진혁 모바일에서 검색을 다양하게 하기 위한 요소 추가 */
			List<ScheduleInfoVO> sList = mScheduleService.scheduleList(info, startDate, endDate, searchTitle, searchColumn, searchData);
						
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", sList.size());
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list-count/users/{userId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 상세데이터
	 */
	@RequestMapping(value="/mobile/ezschedule/schedules/{scheduleId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleDetail(@PathVariable String scheduleId, HttpServletRequest request, Locale locale) throws Exception {
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			JSONObject dataObject = new JSONObject();
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, request.getParameter("userId"));
			
			int tenantId = info.getTenantId();
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			
			//일정 정보
			MScheduleInfoVO vo = mScheduleService.scheduleInfo(scheduleId, offSetMin, tenantId);
			dataObject.put("scheduleInfo", vo);
		
			String itemID = vo.getContentPath();
			LOGGER.debug("itemID: " + itemID);
			String type = "SCHEDULECONTENT";
			String realPath = commonUtil.getRealPath(request);
	        String scheme = "http://";
			
	    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
	    		scheme = "https://";
	    	}
	
			String mhtToHtml = ezCommonService.getMHTtoHTML(type, itemID, info.getTenantId(), realPath, request, locale, scheme);
			LOGGER.debug("mhtToHtml: " + mhtToHtml);			
	        Document doc = Jsoup.parse(mhtToHtml);	        
	        Elements elems = doc.select("[src]");
			
			if (elems.size() > 0) {
				for (Element element : elems) {
					element.attr("src", "/mobile/ezCommon/mFileDown.do?filePath=" + element.attr("src") + "&fileName=*.INLINE.*");
				}
			}
	        String bodyHTML = doc.getElementsByTag("BODY").html();
			vo.setContent(bodyHTML);
			
			
			//자원예약 정보
	        int resourceCnt = ezScheduleService.getResourceCount(scheduleId, tenantId);
	        
	        if (resourceCnt != 0) {
	        	dataObject.put("resourceCnt", resourceCnt + "");
	        } 
	        
	        //참석자 정보
	        if (vo.getHasAttendant().equals("Y")) {
	        	String parentID = (vo.getParentId().equals("0") ? scheduleId : vo.getParentId());
	        	List<AttendantListVO> aList = ezScheduleService.getAttendantList(parentID, offSetMin, tenantId);
	        	
	        	dataObject.put("attendantList", aList);	        	
	        }

	        //참부파일 정보
	        if (vo.getHasAttach().equals("Y")) {        
	        	String parentID = (vo.getParentId().equals("0") ? scheduleId : vo.getParentId());
	        	List<AttachListVO> aList = ezScheduleService.getAttachList(parentID, tenantId);
	        	
	        	for (AttachListVO avo : aList) {        		
	        		String fileType = avo.getFileName().substring(avo.getFileName().lastIndexOf(".") + 1).toLowerCase();
	        		avo.setFileType(fileType);        		
	        		avo.setFileEncodeName(URLEncoder.encode(avo.getFileName(),"UTF-8"));
	        		
	        		String filePath = commonUtil.getUploadPath("upload_schedule.ROOT", info.getTenantId()) + avo.getFilePath();
	        		avo.setFilePath(URLEncoder.encode(filePath, "UTF-8"));
	        		String fileSize = commonUtil.byteCalculation(Long.toString(avo.getFileSize()));
	        		avo.setFileTranSize(fileSize);
	        	}
	        	
	        	dataObject.put("attachList", aList);
	        	
	        	// 20180824 조진호 - 모바일 viewerflag 값 추가
	        	String useMobileViewer = ezCommonService.getTenantConfig("useMobileViewer", info.getTenantId());
		        dataObject.put("useMobileViewer", useMobileViewer);
	        }
	        

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", dataObject);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}				
		
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 첨부파일 리스트
	 */
	@RequestMapping(value="/mobile/ezschedule/schedules/{scheduleId}/attach-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleAttachList(@PathVariable String scheduleId, HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/attach-list] started.");
		
		JSONObject result = new JSONObject();
		
		try {			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, request.getParameter("userId"));
			
			List<AttachListVO> aList = ezScheduleService.getAttachList(scheduleId, info.getTenantId());
        	
        	for (AttachListVO avo : aList) {        		
        		String fileType = avo.getFileName().substring(avo.getFileName().lastIndexOf(".") + 1).toLowerCase();
        		avo.setFileType(fileType);        		
        		avo.setFileEncodeName(URLEncoder.encode(avo.getFileName(),"UTF-8"));
        		
        		String filePath = commonUtil.getUploadPath("upload_schedule.ROOT", info.getTenantId());
        		avo.setFilePath(URLEncoder.encode(filePath, "UTF-8"));
        		
        		String fileSize = commonUtil.byteCalculation(Long.toString(avo.getFileSize()));
        		avo.setFileTranSize(fileSize);
        	}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", aList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		} 
		
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/attach-list] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 종류 리스트 (개인/부서/회사)
	 */
	@RequestMapping(value="/mobile/ezschedule/type-List/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleTypeList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/type-List] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			//String lang = info.getLang();	
			String lang = request.getParameter("langStr");
			
			String primary = commonUtil.getPrimaryData(lang, info.getTenantId());
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
			StringBuilder sb = new StringBuilder();
			
			String pCompanyAdmin = "";
			String pDeptAdmin = "";
			
			if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
	        	pCompanyAdmin = "Y";
	        	pDeptAdmin = "Y";
	        } else if (info.getRollInfo().contains("g=1")) {
	        	pDeptAdmin = "Y";
	        } 

			if (primary.equals("1")) {
				//개인일정
				sb.append("<option value='1;;" + userId + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t372", locale) + " " + info.getUserName() + "</option>");
				
				if (pCompanyAdmin.equals("Y") || pDeptAdmin.equals("Y")) {
					//부서일정				
					sb.append("<option value='2;;" + info.getDeptId() + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t373", locale) + " " + info.getDeptName() + "</option>");
				}
				
				if (pCompanyAdmin.equals("Y")) {
					//회사일정
					sb.append("<option value='3;;" + info.getCompanyId() + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t374", locale) + " " + info.getCompanyName() + "</option>");
				}
			} else {
				//개인일정
				sb.append("<option value='1;;" + userId + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t372", locale) + " " + info.getUserName2() + "</option>");
				
				if (pCompanyAdmin.equals("Y") || pDeptAdmin.equals("Y")) {
					//부서일정
					sb.append("<option value='2;;" + info.getDeptId() + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t373", locale) + " " + info.getDeptName2() + "</option>");
				}
				
				if (pCompanyAdmin.equals("Y")) {
					//회사일정
					sb.append("<option value='3;;" + info.getCompanyId() + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t374", locale) + " " + info.getCompanyName2() + "</option>");
				}
			}
			
			List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, info.getTenantId());
			
			for (ScheduleGroupListVO vo : gList) {
        		//그룹 일정
				sb.append("<option value='7;;" + vo.getGroupId() + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t375", locale) + " " + vo.getGroupName() + "</option>");        		
        	}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", sb);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}    	
		
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/type-List] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 참석자 리스트
	 */
	@RequestMapping(value="/mobile/ezschedule/schedules/{scheduleId}/attendance-List", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleAttendanceList(@PathVariable String scheduleId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/attendance-List] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, request.getParameter("userId"));
			
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			
			List<AttendantListVO> aList = ezScheduleService.getAttendantList(scheduleId, offSetMin, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", aList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/attendance-List] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 등록
	 */	
	@RequestMapping(value="/mobile/ezschedule/schedules", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject mScheduleInsert(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W SCHEDULE [POST /ezschedule/schedules] started.");
		
		JSONObject result = new JSONObject();
		
		try {
		
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, jsonParam.get("creatorId").toString());
						
			jsonParam.put("creatorName", info.getUserName());
			jsonParam.put("creatorName2", info.getUserName2());
			
			String startDate = jsonParam.get("startDate").toString();
			String endDate = jsonParam.get("endDate").toString();
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	    	Calendar cal = Calendar.getInstance();
	    	cal.setTime(sdf.parse(endDate));
	    	
	    	if (cal.get(Calendar.HOUR) == 0 && cal.get(Calendar.MINUTE) == 0) {        		
	    		cal.add(Calendar.MINUTE, -1);        		
	    		endDate = sdf.format(cal.getTime());
	    	}
	
	    	startDate = sdf.format(sdf.parse(startDate));
	    	endDate = sdf.format(sdf.parse(endDate));
	    	
	    	String utcStartDate = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
	    	String utcEndDate = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);	        
	        
	        String realPath = commonUtil.getRealPath(request);
	        Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
	        
			String content = jsonParam.get("content").toString();
			content = content.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
			content = content.replaceAll("\\+", "%2B");
			content = URLDecoder.decode(content, "utf-8");
			
			String scheme = "http://";
			if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
				scheme = "https://";
			}
			
			content = content.replace("replace_" + scheme, scheme);
	        
			jsonParam.put("content", content);
	        
	        int resultScheduleID = mScheduleService.insertSchedule(jsonParam, utcStartDate, utcEndDate, info.getTenantId(), realPath, locale); 
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultScheduleID);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}	   			

		LOGGER.debug("MOBILE G/W SCHEDULE [POST /ezschedule/schedules] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 수정
	 */
	@RequestMapping(value="/mobile/ezschedule/schedules/{scheduleId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject mScheduleUpdate(@PathVariable String scheduleId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W SCHEDULE [PUT /ezschedule/schedules/{scheduleId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
		
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, jsonParam.get("modifierId").toString());
			
			jsonParam.put("modifierName", info.getUserName());
			jsonParam.put("modifierName2", info.getUserName2());
			
			String startDate = jsonParam.get("startDate").toString();
			String endDate = jsonParam.get("endDate").toString();
				
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	    	Calendar cal = Calendar.getInstance();
	    	cal.setTime(sdf.parse(endDate));
	    	
	    	if (cal.get(Calendar.HOUR) == 0 && cal.get(Calendar.MINUTE) == 0) {        		
	    		cal.add(Calendar.MINUTE, -1);        		
	    		endDate = sdf.format(cal.getTime());
	    	}

	    	startDate = sdf.format(sdf.parse(startDate));
	    	endDate = sdf.format(sdf.parse(endDate));

	    	String contentPath = mScheduleService.scheduleContentPath(scheduleId, info.getTenantId());
	    	String utcStartDate = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
	    	String utcEndDate = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);
	    	String defaultPath = commonUtil.getRealPath(request)+ commonUtil.getUploadPath("upload_schedule.ROOT", info.getTenantId()) + contentPath;
    	
	        String realPath = commonUtil.getRealPath(request);
	        Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
	    	
	        LOGGER.debug("contentPath: " + contentPath);
	        
	        List<AttachListVO> aList = ezScheduleService.getAttachList(scheduleId, info.getTenantId());
	        
	        LOGGER.debug("aList.size: " + aList.size());
	        
	        if(aList.size() > 0) {
	        	jsonParam.put("hasAttach", "Y");
	        } else {
	        	jsonParam.put("hasAttach", "N");
	        }
	        
			String content = jsonParam.get("content").toString();
			content = content.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
			content = content.replaceAll("\\+", "%2B");
			content = URLDecoder.decode(content, "utf-8");
			
			String scheme = "http://";
			if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
				scheme = "https://";
			}
			
			content = content.replace("replace_" + scheme, scheme);
	        
			jsonParam.put("content", content);
	        
	        mScheduleService.updateSchedule(jsonParam, utcStartDate, utcEndDate, defaultPath, info.getTenantId(), realPath, locale);
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		LOGGER.debug("MOBILE G/W SCHEDULE [PUT /ezschedule/schedules/{scheduleId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 삭제
	 */	
	@RequestMapping(value="/mobile/ezschedule/schedules/{scheduleId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject mScheduleDelete(@PathVariable String scheduleId, HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W SCHEDULE [DELETE /ezschedule/schedules/{scheduleId}] started.");
		
		JSONObject result = new JSONObject();
						
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, request.getParameter("userId"));
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String dateType = request.getParameter("dateType");
			
/*			if(dateType.equals("3")) {
				mScheduleService.insertScheduleRepeDel(scheduleId, startDate, info.getTenantId());
			} else {
				mScheduleService.deleteSchedule(scheduleId, info.getTenantId());
			}*/
			
			//모바일 반복일정삭제 기능변경(단일삭제 -> 전체삭제)2018.02.22
			mScheduleService.deleteSchedule(scheduleId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		LOGGER.debug("MOBILE G/W SCHEDULE [DELETE /ezschedule/schedules/{scheduleId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 리스트 (주간)
	 */
	@RequestMapping(value="/mobile/ezschedule/week-list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleWeekList(@PathVariable String userId, HttpServletRequest request, Locale locale){
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/week-list/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			String targetDate =  request.getParameter("targetDate");
			String langStr =  request.getParameter("langStr");
			String startDate = "";
			String endDate = "";
			String searchTitle = "";
			
			Calendar calForWeek = Calendar.getInstance();
			int toYear = 0;
			int toMonth = 0;
			int toDay = 0;
			 
			if(targetDate == null || targetDate.equals("")){   //파라메타값이 없을경우 오늘날짜
			 
				toYear = calForWeek.get(calForWeek.YEAR);  
				toMonth = calForWeek.get(calForWeek.MONTH)+1;
				toDay = calForWeek.get(calForWeek.DAY_OF_MONTH);
				int yoil = calForWeek.get(calForWeek.DAY_OF_WEEK); //요일나오게하기(숫자로)

			if(yoil != 1){   //해당요일이 일요일이 아닌경우
				
				yoil = yoil-2;
			
			}else{           //해당요일이 일요일인경우
			
				yoil = 7;
			
			}
			
			calForWeek.set(toYear, toMonth-1, toDay-yoil);  //해당주월요일로 세팅
			 
			}else{
			 
			int yy =Integer.parseInt(targetDate.substring(0, 4));
			int mm =Integer.parseInt(targetDate.substring(5, 7))-1;
			int dd =Integer.parseInt(targetDate.substring(8, 10));
			calForWeek.set(yy, mm,dd);
			
			}
			
			String[] arrYMD = new String[7];
			  
			int inYear = calForWeek.get(calForWeek.YEAR);  
			int inMonth = calForWeek.get(calForWeek.MONTH);
			int inDay = calForWeek.get(calForWeek.DAY_OF_MONTH);
			int yoil = calForWeek.get(calForWeek.DAY_OF_WEEK); //요일나오게하기(숫자로)
			
			yoil = yoil-1;
			
			inDay = inDay-yoil;
			
			for(int i = 0; i < 7;i++){
			
				calForWeek.set(inYear, inMonth, inDay+i);  //
				String y = Integer.toString(calForWeek.get(calForWeek.YEAR));  
				String m = Integer.toString(calForWeek.get(calForWeek.MONTH)+1);
				String d = Integer.toString(calForWeek.get(calForWeek.DAY_OF_MONTH));
				
				if(m.length() == 1) m = "0" + m; 
				
				if(d.length() == 1) d = "0" + d; 
			   
				arrYMD[i] = y + "-" + m + "-" +d;
				LOGGER.debug("ymd = "+ y + "-" + m + "-" +d);
			   
			}
			
			List<Map> resultList = new ArrayList<Map>();
					
			for (int i = 0; i < arrYMD.length; i++) {
				
				startDate = arrYMD[i];
				endDate = arrYMD[i];
				
				if (startDate != null && !startDate.equals("")) {
					String[] sDate = startDate.split("-");
					String sMon = (sDate[1].length() == 1 ? "0" + sDate[1] : sDate[1]);
					String sDay = (sDate[2].length() == 1 ? "0" + sDate[2] : sDate[2]);
					
					startDate = sDate[0] + "-" + sMon + "-" + sDay + " 00:00:00";
				} else {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					Calendar cal = Calendar.getInstance();
					
					startDate = sdf.format(cal.getTime()) + " 00:00:00";
				}
				
				if (endDate != null && !endDate.equals("")) {
					String[] eDate = endDate.split("-");
					String eMon = (eDate[1].length() == 1 ? "0" + eDate[1] : eDate[1]);
					String eDay = (eDate[2].length() == 1 ? "0" + eDate[2] : eDate[2]);
					
					endDate = eDate[0] + "-" + eMon + "-" + eDay  + " 23:59:59";
				} else {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					Calendar cal = Calendar.getInstance();
					
					endDate = sdf.format(cal.getTime()) + " 23:59:59";
				}
				
				String serverName = request.getHeader("x-user-host");
				MCommonVO info = mOptionService.commonInfo(serverName, userId);
				info.setLang(langStr);
				
				List<ScheduleInfoVO> sList = mScheduleService.scheduleList(info, startDate, endDate, searchTitle, "", "");
					
				Map<String, Object> dayMap = new HashMap<String, Object>();
				
				if(i == 0) {
					dayMap.put("weekDay", "sun");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990008", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[0]);
					resultList.add(dayMap);
				} else if(i == 1) {
					dayMap.put("weekDay", "mon");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990009", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[1]);
					resultList.add(dayMap);
				} else if(i == 2) {
					dayMap.put("weekDay", "tues");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990010", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[2]);
					resultList.add(dayMap);
				} else if(i == 3) {
					dayMap.put("weekDay", "wed");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990011", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[3]);
					resultList.add(dayMap);
				} else if(i == 4) {
					dayMap.put("weekDay", "thur");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990012", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[4]);
					resultList.add(dayMap);
				} else if(i == 5) {
					dayMap.put("weekDay", "fri");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990013", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[5]);
					resultList.add(dayMap);
				} else if(i == 6) {
					dayMap.put("weekDay", "sat");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990014", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[6]);
					resultList.add(dayMap);
				}
							
			}
								
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultList);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/week-list/users/{userId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [POST] 게시판-일정 연동 등록
	 */	
	@RequestMapping(value="/mobile/ezschedule/board-schedules", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject mBoardScheduleInsert(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W SCHEDULE [POST /mobile/ezschedule/board-schedules] started.");
		
		JSONObject result = new JSONObject();
						
		try {
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, jsonParam.get("creatorId").toString());
						
			jsonParam.put("creatorName", info.getUserName());
			jsonParam.put("creatorName2", info.getUserName2());			
			
			String startDate = jsonParam.get("startDate").toString();
			String endDate = jsonParam.get("endDate").toString();
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	    	Calendar cal = Calendar.getInstance();
	    	cal.setTime(sdf.parse(endDate));
	    	
	    	if (cal.get(Calendar.HOUR) == 0 && cal.get(Calendar.MINUTE) == 0) {        		
	    		cal.add(Calendar.MINUTE, -1);        		
	    		endDate = sdf.format(cal.getTime());
	    	}
	
	    	startDate = sdf.format(sdf.parse(startDate));
	    	endDate = sdf.format(sdf.parse(endDate));
	    	
	    	String utcStartDate = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
	    	String utcEndDate = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);	        
	        
	        String realPath = commonUtil.getRealPath(request);
	        Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
	        
	        int resultScheduleID = mScheduleService.insertBoardSchedule(jsonParam, utcStartDate, utcEndDate, info.getTenantId(), realPath, locale); 
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultScheduleID);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		LOGGER.debug("MOBILE G/W SCHEDULE [POST /mobile/ezschedule/board-schedules] ended.");
		
		return result;
	}
	
}


