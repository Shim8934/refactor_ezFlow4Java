package egovframework.ezMobile.ezSchedule.web;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.service.impl.EzScheduleCompareUtil;
import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezSchedule.service.MScheduleService;
import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
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

	@Autowired
	private Properties config;
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;
		
	@Resource(name="MScheduleService")
	private MScheduleService mScheduleService;
		
	@Resource(name="loginService")
	private LoginService loginService;

	/*@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;*/
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	/*@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;*/
	
    /////////////////////////////////////////////// sample start ///////////////////////////////////////////////////
		
	/**
	 * 모바일 G/W 일정관리 [get] method sample
	 */
	@RequestMapping(value="/ezschedule/{scheduleid}/gw-testList/{id}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public LoginVO testList(@PathVariable String scheduleid, @PathVariable String id, @RequestParam(value="name", required=false) String name) throws Exception {		
		LOGGER.debug("gw-testList started.");
		
System.out.println(scheduleid);
System.out.println(id);
System.out.println(name);

		LoginVO vo = new LoginVO();
		vo.setTenantId(0);
		vo.setId(id);
		vo.setDn("NOPASSWORD");

		LoginVO user = loginService.selectUser(vo);

		LOGGER.debug("gw-testList ended.");
		return user;
	}
	
	/**
	 * 모바일 G/W 일정관리 [put] method sample
	 */
	@RequestMapping(value="/ezschedule/{scheduleid}/gw-testUpdate/{id}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public void testUpdate(@PathVariable String scheduleid, @PathVariable String id, @RequestBody LoginVO loginVO) throws Exception {		
		LOGGER.debug("gw-testUpdate started.");
		
		System.out.println(loginVO.getIp());
				
		LoginVO vo = new LoginVO();
		vo.setTenantId(0);
		vo.setId(id);
		vo.setIp(loginVO.getIp());
		
		loginService.updateUser(vo);
		
		LOGGER.debug("gw-testUpdate ended.");		
	}
	
    ///////////////////////////////////////////////// sample end /////////////////////////////////////////////////////
	
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 리스트 (월간,주간,일정검색)
	 */	
	@RequestMapping(value="/ezschedule/list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleList(@PathVariable String userId, HttpServletRequest request){
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			
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
			
			String utcStartTime = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
			String utcEndTime = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);
			String pidList = "'" + userId + "'," + "'" + info.getDeptId() + "'," + "'" + info.getCompanyId() + "'";
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			
			List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, info.getTenantId());
			
			for (int i = 0; i < gList.size(); i++) {
				if (i == 0) {
					pidList += ",";
				}
				ScheduleGroupListVO data = gList.get(i);
				pidList += "'" + data.getGroupId() + "'";
				
				if (i != gList.size()-1) {
					pidList += ",";
				}	
			}
	
			List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(pidList, "", utcStartTime, utcEndTime, startDate, endDate, "", offSetMin, info.getTenantId());
			
			Collections.sort(sList, new EzScheduleCompareUtil());
						
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
	@RequestMapping(value="/ezschedule/list-count/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleListCount(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list-count/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			
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
			
			String utcStartTime = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
			String utcEndTime = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);
			String pidList = "'" + userId + "'," + "'" + info.getDeptId() + "'," + "'" + info.getCompanyId() + "'";
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			
			List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, info.getTenantId());
			
			for (int i = 0; i < gList.size(); i++) {
				if (i == 0) {
					pidList += ",";
				}
				ScheduleGroupListVO data = gList.get(i);
				pidList += "'" + data.getGroupId() + "'";
				
				if (i != gList.size()-1) {
					pidList += ",";
				}	
			}
	
			List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(pidList, "", utcStartTime, utcEndTime, startDate, endDate, "", offSetMin, info.getTenantId());
						
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
	@RequestMapping(value="/ezschedule/schedules/{scheduleId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleDetail(@PathVariable String scheduleId, HttpServletRequest request) throws Exception {
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
	        		
	        		String fileSize = commonUtil.byteCalculation(Long.toString(avo.getFileSize()));
	        		avo.setFileTranSize(fileSize);
	        	}
	        	
	        	dataObject.put("attachList", aList);	
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
	@RequestMapping(value="/ezschedule/schedules/{scheduleId}/attach-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
	@RequestMapping(value="/ezschedule/type-List/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleTypeList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/type-List] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			String lang = info.getLang();			
			String primary = commonUtil.getPrimaryData(lang, info.getTenantId());
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
			StringBuilder sb = new StringBuilder();

			if (primary.equals("1")) {
				//개인일정
				sb.append("<option value='1;;" + userId + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t372", locale) + " " + info.getUserName() + "</option>");				
				//부서일정
				sb.append("<option value='2;;" + info.getDeptId() + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t373", locale) + " " + info.getDeptName() + "</option>");			
				//회사일정
				sb.append("<option value='3;;" + info.getCompanyId() + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t374", locale) + " " + info.getCompanyName() + "</option>");			
			} else {
				//개인일정
				sb.append("<option value='1;;" + userId + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t372", locale) + " " + info.getUserName2() + "</option>");				
				//부서일정
				sb.append("<option value='2;;" + info.getDeptId() + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t373", locale) + " " + info.getDeptName2() + "</option>");				
				//회사일정
				sb.append("<option value='3;;" + info.getCompanyId() + "'" + ">" + egovMessageSource.getMessage("ezSchedule.t374", locale) + " " + info.getCompanyName2() + "</option>");			
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
	@RequestMapping(value="/ezschedule/schedules/{scheduleId}/attendance-List", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
	@RequestMapping(value="/ezschedule/schedules", method= RequestMethod.POST, produces="application/json;charset=utf-8")
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
	        String defaultPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_schedule.ROOT", info.getTenantId());
	        	        
	        int resultScheduleID = mScheduleService.insertSchedule(jsonParam, utcStartDate, utcEndDate, defaultPath, info.getTenantId()); 
	        
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
	@RequestMapping(value="/ezschedule/schedules/{scheduleId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
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
	    	String defaultPath = commonUtil.getRealPath(request) + contentPath;
    	
	        mScheduleService.updateSchedule(jsonParam, utcStartDate, utcEndDate, defaultPath, info.getTenantId());
	        
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
	@RequestMapping(value="/ezschedule/schedules/{scheduleId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject mScheduleDelete(@PathVariable String scheduleId, HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W SCHEDULE [DELETE /ezschedule/schedules/{scheduleId}] started.");
		
		JSONObject result = new JSONObject();
						
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, request.getParameter("userId"));
						
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
	
}


