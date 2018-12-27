package egovframework.ezEKP.ezAttitude.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAnnualVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeApplicationVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAuthorVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeDeptVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeFormVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeStatisVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.DeptViewVO;
import egovframework.ezEKP.ezAttitude.vo.HolidayVO;
import egovframework.ezEKP.ezAttitude.vo.ModApplHistoryVO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@RestController
public class EzAttitudeGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeGWController.class);
	
	public static final int BUFF_SIZE = 2048;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="crypto")
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzAttitudeService")
	private EzAttitudeService ezAttitudeService;
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name = "EzScheduleService")
	private EzScheduleService ezScheduleService;
	
	/**
	 * G/W 근태관리 [GET] 개인, 부서, 부서+개인 근태조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject attitudeMainList(HttpServletRequest request) {
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String typeId = request.getParameter("typeId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String deptFlag = request.getParameter("deptFlag");
			String selectedDeptID = request.getParameter("selectedDeptID");
			
			List<AttitudeVO> resultList;
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			/*
			 * 선택된 부서가 없는 경우 사용자의 부서의 근태를 보여준다.
			 * */
			
			if (selectedDeptID.equals("")) {
				selectedDeptID = info.getDeptId();
			}

			String offset = info.getOffSet();
			if (deptFlag.equals("false") || deptFlag.equals("")) {
				resultList = ezAttitudeService.getAttitudeList(userId, "", "", typeId, startDate, endDate, offset, deptFlag, info.getPrimary(), info.getTenantId());
			} else {
				// 관리하고 있는 전체 부서 목록을 받아서 dept in iterate를 돌린다.
				resultList = ezAttitudeService.getAttitudeList("", selectedDeptID, "", typeId, startDate, endDate, offset, deptFlag, info.getPrimary(), info.getTenantId());
			}
	         
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resultList);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 근태등록
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId}/attitudes", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject registeAttitude(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId + "/attitudes] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String typeId = request.getParameter("typeId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String region = request.getParameter("region");
			String mobile = request.getParameter("mobile");
			String bizSub = request.getParameter("bizSub");
			String content = request.getParameter("content");
			String dateType = request.getParameter("dateType");
			String mode = request.getParameter("mode");
			String adminId = request.getParameter("adminId");
			String checkAttitude = "";
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String offSet = info.getOffSet();
			
			if (adminId != null && !adminId.equals("")) { //관리자가 등록시 등록하는 사람의 offset이 필요함
				MCommonVO adminInfo = mOptionService.commonInfoWeb(serverName, adminId);
				offSet = adminInfo.getOffSet();
			}
			
			if (typeId.equals("A01") || typeId.equals("A02") || typeId.equals("A03") || typeId.equals("A08")) {
				checkAttitude = ezAttitudeService.getIsAttitude(typeId, userId, startDate, offSet, info.getCompanyId(), info.getTenantId());
			}
			
			if (!checkAttitude.equals("") && !checkAttitude.equals("0")) {
				checkAttitude = "dupl";
			} else {
				ezAttitudeService.insertAttitude(userId, info.getDeptId(), startDate, endDate, region, mobile, bizSub, content, "0", typeId, dateType, offSet, info.getCompanyId(), info.getTenantId(), mode, adminId);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", checkAttitude);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId + "/attitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태 상세조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/{attitudeId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeInfo(@PathVariable String attitudeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/" + attitudeId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			AttitudeVO attitudeVO = ezAttitudeService.getAttitudeInfo(attitudeId, info.getOffSet(), info.getPrimary(), info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", attitudeVO);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/" + attitudeId + "] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 근태수정
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/{attitudeId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateAttitudeInfo(@PathVariable String attitudeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String typeId = request.getParameter("typeId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String region = request.getParameter("region");
			String mobile = request.getParameter("mobile");
			String bizSub = request.getParameter("bizSub");
			String content = request.getParameter("content");
			String dateType = request.getParameter("dateType");
			String mode = request.getParameter("mode");
			String checkAttitude = "";
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			AttitudeVO attitudeVO = ezAttitudeService.getAttitudeInfo(attitudeId, info.getOffSet(), info.getPrimary(), info.getTenantId());
			
			//1. startDate로 attitudeID 끌어와서 기존에 있던건지 검사를 먼저
			//2. 똑같은 attitudeVO를 가져와서 비교할 수 는 없어 시작일 변경??
			// ==> typeId와 startDate를 비교하면
			if (typeId.equals("A08")) {
				checkAttitude = ezAttitudeService.getIsAttitude(typeId, attitudeVO.getWriterId(), startDate, info.getOffSet(), attitudeVO.getCompanyId(), info.getTenantId());
			}
			
			if (!checkAttitude.equals("") && !checkAttitude.equals("0") && !(typeId.equals(attitudeVO.getTypeId()) && startDate.split(" ")[0].equals(attitudeVO.getStartDate().split(" ")[0]))) {
				checkAttitude = "dupl";
			} else {
				MCommonVO userInfo = mOptionService.commonInfoWeb(serverName, attitudeVO.getWriterId());
				ezAttitudeService.updateAttitude(attitudeId, startDate, endDate, region, mobile, bizSub, content, info.getOffSet(), "", typeId, dateType, mode, attitudeVO, userId, info, userInfo, info.getTenantId(), info.getCompanyId());
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", checkAttitude);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [DELETE] 근태삭제
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/{attitudeId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteAttitudeInfo(@PathVariable String attitudeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/attitudes/" + attitudeId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String mode = request.getParameter("mode");
			
			if (mode == null) {
				mode = "";
			}
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			AttitudeVO attitudeVO = ezAttitudeService.getAttitudeInfo(attitudeId, info.getOffSet(), info.getPrimary(), info.getTenantId());
			MCommonVO userInfo = mOptionService.commonInfoWeb(serverName, attitudeVO.getWriterId()); 
			
			ezAttitudeService.deleteAttitude(attitudeId, info.getTenantId(), mode, attitudeVO, info.getOffSet(), info, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/attitudes/" + attitudeId + "] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 수정신청 등록
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/{attitudeId}/modify-applications", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject modifyApplicationList(@PathVariable String attitudeId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="userId", required=true) String userId,
			@RequestParam(value="offset", required=true) String offset,
			@RequestParam(value="content", required=true) String content,
			@RequestParam(value="changeDate", required=true) String changeDate,
			@RequestParam(value="originDate", required=true) String originDate) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "/modify-applications] started.");
		
		JSONObject result = new JSONObject();
		String status = "exception";
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			status = ezAttitudeService.attSaveAppModify(attitudeId, companyId, tenantId, userId, info.getUserName(), 
					info.getUserName2(), info.getTitle(), info.getTitle2(), info.getDeptId(), info.getDeptName(), 
					info.getDeptName2(), changeDate, "0", content, offset, originDate);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", status);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", status);
		}
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "/modify-applications] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 조직도 회사, 부서조회
	 */
	@RequestMapping(value = "/rest/ezattitude/organtree/depts", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject organtreeDepts(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/organtree/depts] started.");
		
		JSONObject result = new JSONObject();
		
		try {
	         String userId = request.getParameter("userId");
	         String serverName = request.getHeader("x-user-host");
	         MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
	         
	         LOGGER.debug("userId : " + userId);
	         String companyId = request.getParameter("companyId");
	         
	         if (companyId == null || companyId.equals("")) {
	            companyId = info.getCompanyId();
	         }
	         List<DeptViewVO> deptList = ezAttitudeService.getDeptViewList(userId, companyId, info.getTenantId(), info.getPrimary());
	         
	         result.put("status", "ok");
	         result.put("code", 0);
	         result.put("data", deptList);
	      } catch (Exception e) {
	         result.put("code", 1);
	         result.put("status", "error");
	         result.put("data", "");
	      }

		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/organtree/depts] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 부서의 사원들 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/organtree/users", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject organtreeUsersOfDept(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/organtree/users] started.");
		JSONObject result = new JSONObject();
		
		try {
			String key = request.getParameter("key");
			String value = request.getParameter("value");
			String companyId = request.getParameter("companyId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			if (companyId.equals("") || companyId == null) {
				companyId = info.getCompanyId();
			}
			
			List<AttitudeAuthorVO> userList = ezAttitudeService.getDeptUserList(info.getTenantId(), key, value, companyId, info.getPrimary());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/organtree/users] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 개인 월별 근태 통계
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId}/attitude-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject userAttitudeCount(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/attitude-count] started.");
		
		JSONObject result = new JSONObject();
		try{
			String serverName = request.getHeader("x-user-host");
			String offset = request.getParameter("offset");
			String date = request.getParameter("date");
			String deptFlag = request.getParameter("deptFlag");
			String selectedDeptID = request.getParameter("selectedDeptID");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			if (selectedDeptID.equals("")) {
				selectedDeptID = info.getDeptId();
			}
			
			Calendar cal = Calendar.getInstance();
			cal.set(Integer.valueOf(date.substring(0, 4)), Integer.valueOf(date.substring(5)) - 1, 1);
			
			String startDate = date + "-01 00:00:00";
			String endDate = date + "-" + cal.getActualMaximum(Calendar.DAY_OF_MONTH) + " 23:59:59";
			
			List<AttitudeStatisVO> resultList;
			
			if (deptFlag.equals("false")){
				resultList = ezAttitudeService.getAttitudeStatisticsList(userId, "", offset, startDate, endDate, info.getTenantId(), deptFlag);
			} else {
				resultList = ezAttitudeService.getAttitudeStatisticsList("", selectedDeptID,offset, startDate, endDate, info.getTenantId(), deptFlag);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resultList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/attitude-count] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 부서 월별 근태 통계
	 */
	@RequestMapping(value = "/rest/ezattitude/depts/{deptId}/attitude-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject deptAttitudeCount(@PathVariable String deptId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/depts/" + deptId + "/attitude-count] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /ezattitude/depts/" + deptId + "/attitude-count] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태규율설정정보 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudereg", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeConfInfo(@PathVariable String companyId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudereg] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String offset = info.getOffSet();
			
			//근태규율설정정보
			AttitudeConfigVO attitudeConfigInfo = ezAttitudeService.getAttitudeConfig(info.getTenantId(), companyId);
			
			//시간 셋팅
			String startDate = commonUtil.getDateStringInUTC(attitudeConfigInfo.getConfSetDate() + " " + attitudeConfigInfo.getWorkStartTime(), offset, false);
			String endDate = commonUtil.getDateStringInUTC(attitudeConfigInfo.getConfSetDate() + " " + attitudeConfigInfo.getWorkEndTime(), offset, false);
			
			int startIdx = startDate.indexOf(" ");
			int endIdx = endDate.indexOf(" ");
			
			attitudeConfigInfo.setWorkStartTime(startDate.substring(startIdx + 1));
			attitudeConfigInfo.setWorkEndTime(endDate.substring(endIdx + 1));
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", attitudeConfigInfo);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudereg] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 근태규율설정정보 수정
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudereg", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateAttitudeConf(@PathVariable String companyId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudereg] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			
			String workStartTime = request.getParameter("workStartTime");
			String workEndTime = request.getParameter("workEndTime");
			String closedDay = request.getParameter("closedDay");
			String attitudeModAppl = request.getParameter("attitudeModAppl");
			String closedDateAttitude = request.getParameter("closedDateAttitude");
			
			String confSetDate =  commonUtil.getTodayUTCTime("yyyy-MM-dd");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			//시간 셋팅
			if (workStartTime.length() == 4) {
				workStartTime = "0" + workStartTime;
			}
			if (workEndTime.length() == 4) {
				workEndTime = "0" + workEndTime;
			}
			
			String startDate = commonUtil.getDateStringInUTC(confSetDate + " " + workStartTime, info.getOffSet(), true);
			String endDate = commonUtil.getDateStringInUTC(confSetDate + " " + workEndTime, info.getOffSet(), true);
			
			workStartTime = startDate.substring(startDate.indexOf(" ") + 1);
			workEndTime = endDate.substring(endDate.indexOf(" ") + 1);
			
			ezAttitudeService.updateAttitudeConfig(workStartTime, workEndTime, closedDay, attitudeModAppl, closedDateAttitude, confSetDate, companyId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudereg] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태유형 리스트 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeTypeList(@PathVariable String companyId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudetypes] started.");

		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String isuse = request.getParameter("isuse");
			String isAdmin = request.getParameter("isAdmin") == null ? "" : request.getParameter("isAdmin");
			String statistics = request.getParameter("statistics") == null ? "" : request.getParameter("statistics");
			
			List<AttitudeTypeVO> attitudeTypeList = ezAttitudeService.getAttitudeTypeList(companyId, isuse, isAdmin, statistics, info.getTenantId(), info.getPrimary());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", attitudeTypeList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudetypes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 근태유형 사용여부 일괄저장
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject attitudeTypeBatchStore(@PathVariable String companyId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudetypes] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String typeConfigList = request.getParameter("typeConfigList");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ezAttitudeService.updateAttitudeTypeConfig(typeConfigList, companyId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudetypes] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 근태유형 추가
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertAttitudeType(@PathVariable String companyId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/attitudetypes] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String typeName = request.getParameter("typeName");
			String typeName2 = request.getParameter("typeName2");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			if (ezAttitudeService.insertAttitudeType(typeName, typeName2, info.getTenantId(), companyId, info.getPrimary())) {
				result.put("status", "ok");
			} else {
				result.put("status", "failed");
			}
			
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/attitudetypes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태유형 상세보기
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes/{attitudetypeId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeTypeInfo(@PathVariable String companyId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			AttitudeTypeVO typeInfo = ezAttitudeService.getAttitudeTypeInfo(info.getTenantId(), companyId, attitudetypeId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", typeInfo);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId + "] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 근태유형 수정
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes/{attitudetypeId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateAttitudeType(@PathVariable String companyId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId+ "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String typeId = request.getParameter("typeId");
			String typeName = request.getParameter("typeName");
			String typeName2 = request.getParameter("typeName2");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ezAttitudeService.updateAttitudeType(typeId, typeName, typeName2, info.getTenantId(), companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId+ "] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [DELETE] 근태유형 삭제
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes/{attitudetypeId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteAttitudeType(@PathVariable String companyId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId+ "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String typeId = request.getParameter("typeId");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			//삭제
			String data = ezAttitudeService.deleteAttitudeType(typeId, info.getTenantId(), companyId);
				
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId+ "] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 회사리스트
	 */
	@RequestMapping(value = "/rest/ezattitude/companies", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject updateAttitudeType(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			//테넌트별 회사리스트
			List<AttitudeDeptVO> list = ezAttitudeService.getCompanyList(info.getPrimary(), info.getTenantId(), userId);
			data.put("list", list);
			//로그인한 관리자의 회사
			data.put("adminCompany", info.getCompanyId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근무시간 리스트 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/user-attitude-confs", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject userAttitudeConfList(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users-attitude-confs] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String searchUserName = request.getParameter("searchUserName");
			String searchDeptName = request.getParameter("searchDeptName");
			String searchTitle = request.getParameter("searchTitle");
			String searchStartTime = request.getParameter("searchStartTime");
			String searchEndTime = request.getParameter("searchEndTime");
			String searchGubun = request.getParameter("searchGubun");
			String pageNum = request.getParameter("pageNum");
			String listSize = request.getParameter("listSize");
			String orderCell = request.getParameter("orderCell");
			String orderOption = request.getParameter("orderOption");
			String offsetMin = request.getParameter("offsetMin");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			
			String totalCount = ezAttitudeService.getAttitudeUserConfigCount(tenantId, companyId, searchUserName, searchDeptName, searchTitle, searchStartTime, searchEndTime, searchGubun, offsetMin);
			List<AttitudeUserConfigVO> list = ezAttitudeService.getAttitudeUserConfigList(tenantId, companyId, searchUserName, searchDeptName, searchTitle, searchStartTime, searchEndTime, searchGubun, pageNum, listSize, orderCell, orderOption, offsetMin, info.getPrimary());
			
			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("totalCount", totalCount);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users-attitude-confs] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근무시간 정보 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/users/users-attitude-confs", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject userAttitudeConfInfo(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/users-attitude-confs] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String selectedUserIdList = request.getParameter("selectedUserIdList");

			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			AttitudeUserConfigVO vo = ezAttitudeService.getAttitudeUserConfigInfo(selectedUserIdList, commonUtil.getMinuteUTC(info.getOffSet()), companyId, info.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", vo);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/users-attitude-confs] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 근무시간 수정
	 */
	@RequestMapping(value = "/rest/users/ezattitude/user-attitude-confs", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertUserAttitudeConf(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/users-attitude-confs] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String selectedUserIdList = request.getParameter("selectedUserIdList");
			String workStartTime = request.getParameter("workStartTime");
			String workEndTime = request.getParameter("workEndTime");
			String gubun = request.getParameter("gubun");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			// insert on duplicate
			ezAttitudeService.editAttitudeUserConfig(selectedUserIdList, workStartTime, workEndTime, gubun, info.getOffSet(), companyId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/users-attitude-confs] ended.");
		return result;
	}
	/**
	 * G/W 근태관리 [POST] 부서 근무시간 수정
	 */
	@RequestMapping(value = "/rest/users/ezattitude/dept-attitude-confs", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertDeptAttitudeConf(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/dept-attitude-confs] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String selectDeptIds = request.getParameter("selectDeptIds");
			String workStartTime = request.getParameter("workStartTime");
			String workEndTime = request.getParameter("workEndTime");
			String gubun = request.getParameter("gubun");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			// insert on duplicate
			ezAttitudeService.editAttitudeDeptConfig(selectDeptIds, workStartTime, workEndTime, gubun, info.getOffSet(), companyId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/dept-attitude-confs] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 수정신청 리스트
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId}/modifyattitudes", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUsersModiyAtt(@PathVariable String userId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			@RequestParam(value="apprUserName", required=false) String apprUserName,
			@RequestParam(value="writerName", required=false) String writerName,
			@RequestParam(value="writerDeptName", required=false) String writerDeptName,
			@RequestParam(value="offset", required=false) String offset,
			@RequestParam(value="startPoint", required=false) String startPoint,
			@RequestParam(value="endPoint", required=false) String endPoint,
			@RequestParam(value="type", required=false) String type,
			@RequestParam(value="orderCell", required=false) String orderCell,
			@RequestParam(value="orderOption", required=false) String orderOption,
			@RequestParam(value="adminFlag", required=false) String adminFlag,
			@RequestParam(value="checkAdmin", required=false) String checkAdmin,
			@RequestParam(value="deptid", required=false) String deptid) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/modifyattitudes] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		JSONObject attJson = new JSONObject();

		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String order = orderCell + " " + orderOption;
			String isAllDept = "";

			if (adminFlag == null) {
				adminFlag = "false";
			}
			
			if (checkAdmin == null) {
				checkAdmin = "false";
			}
			
			if (checkAdmin.equals("true")){
				isAllDept = "Y";
			}
			
			if (orderCell == null || orderOption == null) {
				order = null;
			}
			
			if (type != null) { 
				if (type.equals("all")) {
					type = null;
				}
			}
			if (endPoint != null && startPoint != null) {
				endPoint = Integer.parseInt(endPoint)- Integer.parseInt(startPoint) + "";
			}
			
			List<String> deptIdList = new ArrayList<>();
			
//			if (!checkAdmin.equals("true") && deptid.equals("ALL")) {
//				if (info.getRollInfo().indexOf("c=1") == -1 && info.getRollInfo().indexOf("k=1") == -1 && info.getRollInfo().indexOf("a1=1") == -1) {
//					List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList(info.getTenantId(), companyId, info.getUserId(), "", info.getPrimary());
//					
//					for (AttitudeAuthorVO vo : authDeptlist) {
//						if (vo.getAuthType().equals("M")) {
//							deptIdList.add(vo.getDeptId());
//						}
//					}
//				}
//			}
			
			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, info.getUserId(), info.getRollInfo(), "", "M", "");

			for (AttitudeAuthorVO vo : authDeptlist) {
				if (vo.getAuthType() != null && vo.getAuthType().equals("M")) {
					deptIdList.add(vo.getDeptId());
				}
			}
			
			if (deptid.equals("ALL")) {
				deptid = "";
			}
			
			List<AttitudeApplicationVO> attList = ezAttitudeService.getUsersModiyAtt(companyId, tenantId, userId, startDate, endDate, apprUserName, writerName, writerDeptName, info.getPrimary(), offset, startPoint, endPoint, type, order, adminFlag, checkAdmin, deptid, deptIdList);

			data.put("list", attList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/modifyattitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 수정신청 개수
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId}/modifyattitudes/count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUsersModiyAttCount(@PathVariable String userId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			@RequestParam(value="apprUserName", required=false) String apprUserName,
			@RequestParam(value="writerName", required=false) String writerName,
			@RequestParam(value="writerDeptName", required=false) String writerDeptName,
			@RequestParam(value="offset", required=false) String offset,
			@RequestParam(value="type", required=false) String type,
			@RequestParam(value="adminFlag", required=false) String adminFlag,
			@RequestParam(value="checkAdmin", required=false) String checkAdmin,
			@RequestParam(value="deptid", required=false) String deptid) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/modifyattitudes/count] started.");

		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		JSONObject attJson = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			if (adminFlag == null) {
				adminFlag = "false";
			}
			
			if (checkAdmin == null) {
				checkAdmin = "false";
			}
			
			if (type != null) {
				if (type.equals("all")) {
					type = null;
				}
			}
			
			List<String> deptIdList = new ArrayList<>();
			
//			if (!checkAdmin.equals("true") && deptid.equals("ALL")) {
//				if (info.getRollInfo().indexOf("c=1") == -1 && info.getRollInfo().indexOf("k=1") == -1 && info.getRollInfo().indexOf("a1=1") == -1) {
//					List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList(info.getTenantId(), companyId, info.getUserId(), "", info.getPrimary());
//					
//					for (AttitudeAuthorVO vo : authDeptlist) {
//						if (vo.getAuthType().equals("M")) {
//							deptIdList.add(vo.getDeptId());
//						}
//					}
//				}
//			}
			if (!checkAdmin.equals("true") && deptid.equals("ALL")) {
				List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, info.getUserId(), info.getRollInfo(), "", "M", "");
	
				for (AttitudeAuthorVO vo : authDeptlist) {
					if (vo.getAuthType() != null && vo.getAuthType().equals("M")) {
						deptIdList.add(vo.getDeptId());
					}
				}
			}
			
			if (deptid.equals("ALL")) {
				deptid = "";
			}
			
			int attListCount = ezAttitudeService.getUsersModiyAttCount(companyId, tenantId, userId, startDate, endDate, apprUserName, writerName, writerDeptName, info.getPrimary(), offset, type, deptid, deptIdList, adminFlag, checkAdmin);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", attListCount+"");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/modifyattitudes/count] ended.");
		return result;
	}
	
    /**
	 * G/W 근태관리 [GET] 휴일리스트
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/holidays", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getHolidayList(@PathVariable String companyId, HttpServletRequest request) throws Exception{
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/holidays] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String userId = request.getParameter("userId");
			//isRest = all(휴일모두), rest(휴무일만)
			String isRest = request.getParameter("isRest");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String cID = "VIEW";
			
			List<ScheGetHolidayVO> holidayList = ezScheduleService.getTholiday(cID, companyId, tenantId, isRest);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", holidayList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/holidays] ended.");
		return result;
	}
    
	/**
	 * G/W 근태관리 [DELETE] 수정신청 삭제
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId}/modifyattitudes", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject delUsersModiyAtt(@PathVariable String userId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="idList", required=false) String idList) {
			
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/users/"+userId+"/modifyattitudes] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		JSONObject attJson = new JSONObject();
		
		int status = 0;
		
		try{
			String[] ids = idList.split(",");

			idList = "(";

			for (int i = 0; i < ids.length; i++) {
				idList += ids[i] + ",";
			}
			idList = idList.substring(0, idList.length()-1);
			idList += ")";
			
			status = ezAttitudeService.delUsersModifyAtt(companyId, tenantId, ids);
			
			if (status == 1) {
				result.put("status", "ok");
			} else {
				result.put("status", "error");
			}
			result.put("code", 0);
			result.put("data", status);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", status);
		}
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/users/"+userId+"/modifyattitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 수정신청 승인,반려
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId}/modifyattitudes", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject changeUsersModiyAtt(@PathVariable String userId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="idList", required=true) String idList,
			@RequestParam(value="changeStatus", required=true) String changeStatus) {
			
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/users/"+userId+"/modifyattitudes] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		JSONObject attJson = new JSONObject();
		
		try{
			String[] ids = idList.split(",");
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			for (int i = 0; i < ids.length; i++) {
				ezAttitudeService.changeUsersModifyAtt(companyId, tenantId, ids[i], changeStatus, userId, info.getUserName(), info.getUserName2(), info.getOffSet());
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "fail");
		}
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/users/"+userId+"/modifyattitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태관리 작성양식
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudetypes/{attitudetypeId}/forms/form", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFormBody(@PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudetypes/"+attitudetypeId+"/forms/form] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			
			AttitudeFormVO formVO = ezAttitudeService.getFormBody(attitudetypeId, companyId, tenantId);
			
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", formVO);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudetypes/"+attitudetypeId+"/forms/form] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태 수정 신청 상세
	 */
	@RequestMapping(value = "/rest/ezattitude/modifyattitude/{attModId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attModAppDetail(
			@PathVariable String attModId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="userId", required=true) String userId,
			@RequestParam(value="offset", required=true) String offset,
			@RequestParam(value="applCnt", required=false) String applCnt) throws Exception{
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/modifyattitude/"+attModId+"] started.");
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			AttitudeApplicationVO data = ezAttitudeService.attModAppDetail(attModId, offset, applCnt, info.getPrimary(), companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/modifyattitude/"+attModId+"] ended.");
		return result;
	}

	/**
	 * G/W 근태관리 [POST] 근태수정현황 수정
	 */
	@RequestMapping(value = "/rest/ezattitude/modifyattitude/{attModId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject attModAppModify(
			@PathVariable String attModId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="userId", required=true) String userId,
			@RequestParam(value="offset", required=true) String offset,
			@RequestParam(value="content", required=true) String content,
			@RequestParam(value="changeDate", required=true) String changeDate) throws Exception{
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/modifyattitude/"+attModId+"] started.");
		JSONObject result = new JSONObject();
		int update = 0;
		try {
			update = ezAttitudeService.attModAppModify(companyId, tenantId, userId, attModId, offset, content, changeDate);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", update);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", update);
		}
		
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/modifyattitude/"+attModId+"] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/check", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject attitudeMainList2(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/check] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String searchUserName = request.getParameter("searchUserName");
			String searchDeptName = request.getParameter("searchDeptName");
			String searchDeptId = request.getParameter("searchDeptId") == null ? "" : request.getParameter("searchDeptId");
			String searchTitle = request.getParameter("searchTitle");
			String searchStartDate = request.getParameter("searchStartDate");
			String searchEndDate = request.getParameter("searchEndDate");
			String searchAttitudeType = request.getParameter("searchAttitudeType");
			String pageNum = request.getParameter("pageNum");
			String listSize = request.getParameter("listSize");
			String orderCell = request.getParameter("orderCell");
			String orderOption = request.getParameter("orderOption");
			String offsetMin = request.getParameter("offsetMin");
			String isAdmin = request.getParameter("isAdmin") == null ? "" : request.getParameter("isAdmin");
			String statistics = request.getParameter("statistics");
			String isuse = "1";
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			String offset = info.getOffSet();
			
			List<String> deptIdList = new ArrayList<>();

			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, info.getUserId(), info.getRollInfo(), "", "M", "");

			for (AttitudeAuthorVO vo : authDeptlist) {
				if (vo.getAuthType() != null && vo.getAuthType().equals("M")) {
					deptIdList.add(vo.getDeptId());
				}
			}
			
			if (searchDeptId.equals("ALL")) {
				searchDeptId = "";
			}
			
			if (searchAttitudeType.equals("ALL")) {
				searchAttitudeType = "";
			}
			
			String totalCount = ezAttitudeService.getAttitudeCount2(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, searchAttitudeType, offset, companyId, tenantId, searchDeptId, deptIdList);
			List<AdminAttitudeVO> list = ezAttitudeService.getAttitudeList2(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, searchAttitudeType, orderCell, orderOption, offset, pageNum, listSize, companyId, tenantId, searchDeptId, deptIdList, info.getPrimary());
			
			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("totalCount", totalCount);
			data.put("typeId", searchAttitudeType);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/check] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태조회 미입력자 목록
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/absent", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject attitudeAbsentList(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/absent] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String searchUserName = request.getParameter("searchUserName");
			String searchDeptName = request.getParameter("searchDeptName");
			String searchTitle = request.getParameter("searchTitle");
			String searchDeptId = request.getParameter("searchDeptId");
			String searchStartDate = request.getParameter("searchStartDate");
			String searchEndDate = request.getParameter("searchEndDate");
			String pageNum = request.getParameter("pageNum");
			String listSize = request.getParameter("listSize");
			String orderCell = request.getParameter("orderCell");
			String orderOption = request.getParameter("orderOption");
			String offsetMin = request.getParameter("offsetMin");
			String duplicated = request.getParameter("duplicated");
			String isAdmin = request.getParameter("isAdmin") == null ? "" : request.getParameter("isAdmin");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			List<String> deptIdList = new ArrayList<>();
			
			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, info.getUserId(), info.getRollInfo(), "", "M", "");
			
			for (AttitudeAuthorVO vo : authDeptlist) {
				if (vo.getAuthType() != null && vo.getAuthType().equals("M")) {
					deptIdList.add(vo.getDeptId());
				}
			}
			
			if (searchDeptId.equals("ALL")) {
				searchDeptId = "";
			}
			
			JSONObject data = ezAttitudeService.getAttitudeAbsentedList(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, searchDeptId, pageNum, listSize, orderCell, orderOption, duplicated, info.getLang(), info.getOffSet(), companyId, info.getTenantId(), deptIdList, info.getPrimary());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/absent] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태관리 미입력자 메일발송
	 */
	/* 현재는 메일 작성창을 띄우므로 사용하지 않고 있음.
	@RequestMapping(value = "/rest/ezattitude/attitudes/mail", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject absentedListSendMail(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/mail] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String searchUserName = request.getParameter("searchUserName");
			String searchDeptName = request.getParameter("searchDeptName");
			String searchTitle = request.getParameter("searchTitle");
			String searchDeptId = request.getParameter("searchDeptId");
			String searchStartDate = request.getParameter("searchStartDate");
			String searchEndDate = request.getParameter("searchEndDate");
			String isAdmin = request.getParameter("isAdmin") == null ? "" : request.getParameter("isAdmin");
			String loginCookie = request.getParameter("loginCookie");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantID = info.getTenantId();
			String userLang = info.getLang();
			String offset = info.getOffSet();
			
			List<String> deptIdList = new ArrayList<>();
			
			if (!isAdmin.equals("Y") && searchDeptId.equals("ALL")) {
				if (info.getRollInfo().indexOf("c=1") == -1 && info.getRollInfo().indexOf("k=1") == -1 && info.getRollInfo().indexOf("a1=1") == -1) {
					List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList(info.getTenantId(), companyId, info.getUserId(), "", info.getPrimary());
					
					for (AttitudeAuthorVO vo : authDeptlist) {
						deptIdList.add(vo.getDeptId());
					}
				}
			}
			
			if (searchDeptId.equals("ALL")) {
				searchDeptId = "";
			}
			
			JSONObject duplicatedData = ezAttitudeService.getAttitudeAbsentedList(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, searchDeptId, "", "", "", "", "", userLang, offset, companyId, tenantID, deptIdList, info.getPrimary());
			JSONObject distinctData = ezAttitudeService.getAttitudeAbsentedList(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, searchDeptId, "", "", "", "", "distinct", userLang, offset, companyId, tenantID, deptIdList, info.getPrimary());
			
			List<AdminAttitudeVO> duplicatedList = (List<AdminAttitudeVO>) duplicatedData.get("list");
			List<AdminAttitudeVO> distinctList = (List<AdminAttitudeVO>) distinctData.get("list");
			
			ezAttitudeService.absentedListSendMail(duplicatedList, distinctList, loginCookie, searchStartDate, searchEndDate,info.getUserName(), info.getEmail());
			
			LOGGER.debug("배현상 메일정보 확인 : " + info.getEmail());
			JSONObject data = new JSONObject();
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "success");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "error");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/mail] ended.");
		
		return result;
	}
	*/
	
	/**
	 * G/W 근태관리 [GET] 근태내역리스트
	 * @param attModId
	 * @param request
	 * @param companyId
	 * @param tenantId
	 * @param userId
	 * @param offset
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/rest/ezattitude/modifyattitude/{attModId}/history", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getModAppHistory(
			@PathVariable String attModId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="userId", required=true) String userId,
			@RequestParam(value="offset", required=true) String offset) throws Exception{
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/modifyattitude/" + attModId + "/history started");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<AttitudeApplicationVO> data = ezAttitudeService.attModGetHistory(attModId, userId, offset, info.getPrimary(), companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/modifyattitude/" + attModId + "/history ended.");
		}
		return result;
	}

	/**
	 * G/W 근태관리 [GET] 근태권한자 리스트 조회
	 * @param companyId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitude-auth", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeAuthList(@PathVariable String companyId, HttpServletRequest request) throws Exception{
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitude-auth] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<AttitudeAuthorVO> authorlist = ezAttitudeService.getAttitudeAuthList(info.getTenantId(), companyId, info.getPrimary());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", authorlist);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitude-auth] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 근태권한자 등록
	 * @param companyId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitude-auth", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertAttitudeAuth(@PathVariable String companyId, HttpServletRequest request) throws Exception{
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/attitude-auth] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String selectedUser = request.getParameter("selectedUser");
			String deptIds = request.getParameter("deptIds");
			String authTypes = request.getParameter("authTypes");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ezAttitudeService.saveAttitudeAuthDept(info.getTenantId(), companyId, selectedUser, deptIds, authTypes);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "success");
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/attitude-auth] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [DELETE] 근태권한자 삭제
	 * @param companyId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitude-auth", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteAttitudeAuth(
			@PathVariable String companyId, HttpServletRequest request) throws Exception{
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/companies/" + companyId + "/attitude-auth] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String selectUserId = request.getParameter("selectUserId");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ezAttitudeService.deleteAttitudeAuth(selectUserId, info.getTenantId(), companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/companies/" + companyId + "/attitude-auth] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태권한자 상세 조회(권한있는 부서 체크)
	 * 
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId}/attitude-auth", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeAuthDeptList(@PathVariable String userId, HttpServletRequest request) throws Exception{
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/attitude-auth] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String isAllDept = request.getParameter("isAllDept");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList(info.getTenantId(), companyId, userId, isAllDept, info.getPrimary());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", authDeptlist);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/attitude-auth] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태권한자 상세 조회(권한있는 부서 체크)
	 * userAuthType  all:(회사,전체,근태관리자), dept:,부서관리자, (''/null):일반사용자       전달받은 인자없으면 userInfo체크해서 동작
	 * listAuthType  (''/null/all):전체, M:관리, R:열람
	 * comFlag  회사에 포함된 인원 처리(미사용)
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId}/attitude-auth/hyo", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeAuthDeptListhyo(@PathVariable String userId, HttpServletRequest request) throws Exception{
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/attitude-auth/hyo] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String userAuthType = request.getParameter("userAuthType");
			String listAuthType = request.getParameter("listAuthType");
			String comFlag = request.getParameter("comFlag");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, userId, info.getRollInfo(), userAuthType, listAuthType, comFlag);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", authDeptlist);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/attitude-auth/hyo] ended.");
		return result;
	}
	
	/**
	 * G/W 통계 [GET] 개인 근태 유형별 통계 -----임시
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{selectUserId}/attitudetypes/{attitudetypeId}/attitude-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeUserCount(@PathVariable String selectUserId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + selectUserId + "/attitudetypes/" + attitudetypeId + "/attitude-count] started.");
		
		JSONObject result = new JSONObject();
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String offset = request.getParameter("offset");
			String year = request.getParameter("year");
			String deptId = "";
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			MCommonVO selectUserInfo = mOptionService.commonInfoWeb(serverName, selectUserId);
			
			List<AttitudeStatisVO> resultList = ezAttitudeService.getAttitudeUserStatistics(selectUserId, deptId, offset, year, attitudetypeId, info.getTenantId());
			
			JSONObject data = new JSONObject();
			data.put("list", resultList);
			data.put("companyId", selectUserInfo.getCompanyId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + selectUserId + "/attitudetypes/" + attitudetypeId + "/attitude-count] ended.");
		return result;
	}
	
	/**
	 * G/W 통계 [GET] 부서 근태 유형별 통계 -----임시
	 */
	@RequestMapping(value = "/rest/ezattitude/depts/{deptId}/attitudetypes/{attitudetypeId}/attitude-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeDeptCount(@PathVariable String deptId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/depts/"+deptId+"/attitudetypes/" + attitudetypeId + "/attitude-count] started.");
		
		JSONObject result = new JSONObject();
		try{
			String serverName = request.getHeader("x-user-host");
			String offset = request.getParameter("offset");
			String year = request.getParameter("year");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<AttitudeStatisVO> resultList = ezAttitudeService.getAttitudeUserStatistics("", deptId, offset, year, attitudetypeId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resultList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/depts/"+deptId+"/attitudetypes/" + attitudetypeId + "/attitude-count] ended.");
		return result;
	}
	
	/**
	 * G/W 부서근태현황 [GET] 회사별 부서 리스트 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/depts", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyDeptList(@PathVariable String companyId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/"+companyId+"/depts] started.");
		
		JSONObject result = new JSONObject();
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			userId = "";
			
			List<AttitudeAuthorVO> resultList = ezAttitudeService.getCompanyDeptList(userId, companyId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resultList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/"+companyId+"/depts] ended.");
		return result;
	}
	
	/**
	 * G/W 근태수정관리 > 근태관리 > 관리내역  [GET] 관리내역 리스트 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/manageHistories", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeHistoryList(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/manageHistories] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String searchUserName = request.getParameter("searchUserName");
			String searchDeptName = request.getParameter("searchDeptName");
			String searchDeptId = request.getParameter("searchDeptId");
			String searchTitle = request.getParameter("searchTitle");
			String searchStartDate = request.getParameter("searchStartDate");
			String searchEndDate = request.getParameter("searchEndDate");
			String pageNum = request.getParameter("pageNum");
			String listSize = request.getParameter("listSize");
			String orderCell = request.getParameter("orderCell");
			String orderOption = request.getParameter("orderOption");
			String offsetMin = request.getParameter("offsetMin");
			String isAdmin = request.getParameter("isAdmin") == null ? "" : request.getParameter("isAdmin");
			String statistics = request.getParameter("statistics");
			String isuse = "1";
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantID = info.getTenantId();
			String offset = info.getOffSet();
			
			List<String> deptIdList = new ArrayList<>();
			
			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, info.getUserId(), info.getRollInfo(), "", "M", "");

			for (AttitudeAuthorVO vo : authDeptlist) {
				if (vo.getAuthType() != null && vo.getAuthType().equals("M")) {
					deptIdList.add(vo.getDeptId());
				}
			}
			
			if (searchDeptId.equals("ALL")) {
				searchDeptId = "";
			}
			
			String totalCount = ezAttitudeService.getAttitudeHistoryCount(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, offset, companyId, tenantID, searchDeptId, deptIdList);
			List<ModApplHistoryVO> list = ezAttitudeService.getAttitudeHistoryList(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, orderCell, orderOption, offset, pageNum, listSize, companyId, tenantID, searchDeptId, deptIdList, info.getPrimary());
		
			//구분 리스트
			List<AttitudeTypeVO> typeList = ezAttitudeService.getAttitudeTypeList(companyId, isuse, isAdmin, statistics, info.getTenantId(), info.getPrimary());
			
			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("totalCount", totalCount);
			data.put("typeList", typeList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/manageHistories] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 조직도 부서 및 사원목록 검색
	 */
	@RequestMapping(value = "/rest/ezAttitude/getSearchList.do", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getSearchList(HttpServletRequest request){	    
		LOGGER.debug("G/W EzAttitude [GET /rest/ezAttitude/getSearchList.do] started.");
		
	    JSONObject resultJ = new JSONObject();
	    
	    try {
			String serverName = request.getHeader("x-user-host");
	    	MCommonVO userInfo = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
	        int tenantID = userInfo.getTenantId();        
	        
	        LOGGER.debug("tenantID=" + tenantID);       
			
			String searchlist = request.getParameter("searchlist").trim();
			String celllist = request.getParameter("celllist");
			String proplist = request.getParameter("proplist");
			String listtype = request.getParameter("listtype");
			String companyID = request.getParameter("companyID");
			String lang = userInfo.getPrimary();
			String page = request.getParameter("page");
			String infoXML = "";
			
			LOGGER.debug("searchlist=" + searchlist + ",celllist=" + celllist + ",proplist=" + proplist
			        + ",listtype=" + listtype + ",lang=" + lang + ",page=" + page + ",companyID=" + companyID);
			
			List<String> deptIdList = new ArrayList<>();
			
			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(userInfo.getTenantId(), companyID, userInfo.getUserId(), userInfo.getRollInfo(), "", "M", "");
			
			for (AttitudeAuthorVO vo : authDeptlist) {
				deptIdList.add(vo.getDeptId());
			}
			
			if (page == null) {
				infoXML = ezAttitudeService.getSearchList(searchlist, celllist, proplist, listtype, 100, lang, tenantID);
			} else {
				infoXML = ezAttitudeService.getSearchListPagination(searchlist, celllist, proplist, listtype, 100, lang, page, tenantID, deptIdList);
			}
			
			Document doc = commonUtil.convertStringToDocument(infoXML);
	
			if (celllist.toUpperCase().indexOf("EXTENSIONATTRIBUTE5") > -1) {
	            String[] arryCell = celllist.toUpperCase().split(";");
	            String tooltip = "";
	            int idx = 0;
	            
	            for (int j = 0; j < arryCell.length; j++) {
	                if (arryCell[j].equals("EXTENSIONATTRIBUTE5")) {
	                    idx = j;
	                }
	            }
	            
	            for (int i = 0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
	                Element Nodetip = doc.createElement("TOOLTIP");
	
	                if (!doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).getTextContent().equals("")) {
	                    String[] arry = doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).getTextContent().split(":");
	                    tooltip = arry[3] + " ~ " + arry[4];
	                    
	                    if (arry.length > 5) {
	                        tooltip += " " + arry[5];
	                    }
	                    
	                    Nodetip.setTextContent(tooltip);
	                    
	                    doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).setTextContent("Y");
	                    doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).appendChild(Nodetip);
	                }
	            }
	        }
			
			String result = commonUtil.convertDocumentToString(doc);
			result = result.replaceAll("null", "");
			
			resultJ.put("status", "ok");
			resultJ.put("code", 0);
			resultJ.put("data", result);
			
	    } catch (Exception e) {
	    	e.printStackTrace();
	    	resultJ.put("status", "error");
	    	resultJ.put("code", 1);
	    	resultJ.put("data", "");
		}
	    LOGGER.debug("G/W EzAttitude [GET /rest/ezAttitude/getSearchList.do] ended.");
		return resultJ;
	}
	
	/**
	 * G/W 근태관리 [GET] 당일 근태관리 중복
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/checkIsAttitude", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCheckIsAttitude(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/checkIsAttitude] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String typeId = request.getParameter("typeId");
			String userId = request.getParameter("userId");
			String startDate = request.getParameter("startDate");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			String returnValue = ezAttitudeService.getIsAttitude(typeId, userId, startDate, info.getOffSet(), info.getCompanyId(), info.getTenantId());
						
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", returnValue);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/checkIsAttitude] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/annual", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject getAttitudeAnnualList(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/annual] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String searchUserName = request.getParameter("searchUserName");
			String searchDeptName = request.getParameter("searchDeptName");
			String searchDeptId = request.getParameter("searchDeptId") == null ? "" : request.getParameter("searchDeptId");
			String searchTitle = request.getParameter("searchTitle");
			String searchYear = request.getParameter("searchYear");
			String pageNum = request.getParameter("pageNum");
			String listSize = request.getParameter("listSize");
			String orderCell = request.getParameter("orderCell");
			String orderOption = request.getParameter("orderOption");
			String offsetMin = request.getParameter("offsetMin");
			String isAdmin = request.getParameter("isAdmin") == null ? "" : request.getParameter("isAdmin");
			String statistics = request.getParameter("statistics");
			String isuse = "1";
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			
			String totalCount = ezAttitudeService.getAttitudeAnnualListCount(searchUserName, searchDeptName, searchTitle, searchYear, offsetMin, companyId, tenantId);
			List<AttitudeAnnualVO> list = ezAttitudeService.getAttitudeAnnualList(searchUserName, searchDeptName, searchTitle, searchYear, orderCell, orderOption, offsetMin, pageNum, listSize, companyId, tenantId, info.getPrimary());
			
			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("totalCount", totalCount);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/annual] ended.");
		return result;
	}

	/**
	 * G/W 근태관리 [POST] 연차현황 전체 등록/수정
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/changeAllAnnual", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject changeAllAnnual(@PathVariable String companyId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/changeAllAnnual] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("userId", request.getParameter("userId"));
			map.put("changeReason", request.getParameter("changeReason"));
			map.put("flagCheck", request.getParameter("flagCheck"));
			map.put("annualCnt", request.getParameter("annualCnt"));
			map.put("year", request.getParameter("year"));
			
			ezAttitudeService.changeAllAnnual(map, info.getTenantId(), companyId, info.getPrimary());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/changeAllAnnual] ended.");
		return result;
	}
}