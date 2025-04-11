package egovframework.ezEKP.ezAttitude.web;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezAttitude.util.ExcelCellRef;
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
import egovframework.ezEKP.ezAttitude.vo.ModApplHistoryVO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@SuppressWarnings("unchecked")
@RestController
public class EzAttitudeGWController {
	private static final Logger logger = LoggerFactory.getLogger(EzAttitudeGWController.class);
	
	public static final int BUFF_SIZE = 2048;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private ExcelCellRef excelCellRef;
	
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

	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	/**
	 * G/W 근태관리 [GET] 개인, 부서, 부서+개인 근태조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject attitudeMainList(HttpServletRequest request) {
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes] started.");
		
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
				resultList = ezAttitudeService.getAttitudeList(userId, "", "", typeId, startDate, endDate, offset, deptFlag, info.getPrimary(),info.getCompanyId(), info.getTenantId());
			} else {
				// 관리하고 있는 전체 부서 목록을 받아서 dept in iterate를 돌린다.
				resultList = ezAttitudeService.getAttitudeList("", selectedDeptID, "", typeId, startDate, endDate, offset, deptFlag, info.getPrimary(),info.getCompanyId(), info.getTenantId());
			}
	         
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resultList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 근태등록
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/attitudes", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject registeAttitude(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId + "/attitudes] started.");
		
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
			String isOutCheck = "";//퇴근체크 여부
			
			if (adminId != null && !adminId.equals("")) { //관리자가 등록시 등록하는 사람의 offset이 필요함
				MCommonVO adminInfo = mOptionService.commonInfoWeb(serverName, adminId);
				offSet = adminInfo.getOffSet();
			}
			
			if (typeId.equals("A01") || typeId.equals("A02") || typeId.equals("A03") || typeId.equals("A08") || typeId.equals("A25")) {
				if (typeId.equals("A03") || typeId.equals("A25")) {
					isOutCheck = "true";
				}
				checkAttitude = ezAttitudeService.getIsAttitude(typeId, userId, startDate, offSet, info.getCompanyId(), info.getTenantId(), isOutCheck);
				
				if (checkAttitude == null) {
					checkAttitude = "";
				}
			}
			
			if (!checkAttitude.equals("") && !checkAttitude.equals("0") && !typeId.equals("A03")) {
				checkAttitude = "dupl";
			} else {
				if (!checkAttitude.equals("") && !checkAttitude.equals("0") && typeId.equals("A03")) { //이미 퇴근이 있는 경우
					/*result.put("status", "error");
					result.put("message", "error");
					return result;*/
					AttitudeVO attVO = ezAttitudeService.getAttitudeInfo(checkAttitude, info.getOffSet(), info.getPrimary(), info.getCompanyId(), info.getTenantId());
					if (startDate == null || startDate.equals("")) {
						startDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offSet, false);						
					}
					ezAttitudeService.updateAttitude(checkAttitude, startDate, null, region, mobile, bizSub, content, offSet, "", typeId, dateType, mode, attVO, userId, info, info, info.getTenantId(), info.getCompanyId(), "", "");
				} else {
					ezAttitudeService.insertAttitude(userId, info.getDeptId(), startDate, endDate, region, mobile, bizSub, content, "0", typeId, dateType, offSet, info.getCompanyId(), info.getTenantId(), mode, adminId, "0", "", "");					
				}
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", checkAttitude);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
		}
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId + "/attitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태 상세조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/{attitudeId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeInfo(@PathVariable String attitudeId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/" + attitudeId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			AttitudeVO attitudeVO = ezAttitudeService.getAttitudeInfo(attitudeId, info.getOffSet(), info.getPrimary(),info.getCompanyId(), info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", attitudeVO);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/" + attitudeId + "] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 근태수정
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/{attitudeId:.+}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateAttitudeInfo(@PathVariable String attitudeId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "] started.");
		
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
			
			AttitudeVO attitudeVO = ezAttitudeService.getAttitudeInfo(attitudeId, info.getOffSet(), info.getPrimary(), info.getCompanyId(), info.getTenantId());
			
			//1. startDate로 attitudeID 끌어와서 기존에 있던건지 검사를 먼저
			//2. 똑같은 attitudeVO를 가져와서 비교할 수 는 없어 시작일 변경??
			// ==> typeId와 startDate를 비교하면
			if (typeId.equals("A08")) {
				checkAttitude = ezAttitudeService.getIsAttitude(typeId, attitudeVO.getWriterId(), startDate, info.getOffSet(), attitudeVO.getCompanyId(), info.getTenantId(),"");
			}
			
			if (!checkAttitude.equals("") && !checkAttitude.equals("0") && !(typeId.equals(attitudeVO.getTypeId()) && startDate.split(" ")[0].equals(attitudeVO.getStartDate().split(" ")[0]))) {
				checkAttitude = "dupl";
			} else {
				MCommonVO userInfo = mOptionService.commonInfoWeb(serverName, attitudeVO.getWriterId());
				ezAttitudeService.updateAttitude(attitudeId, startDate, endDate, region, mobile, bizSub, content, info.getOffSet(), "", typeId, dateType, mode, attitudeVO, userId, info, userInfo, info.getTenantId(), info.getCompanyId(), "", "");
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", checkAttitude);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
		}
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [DELETE] 근태삭제
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/{attitudeId:.+}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteAttitudeInfo(@PathVariable String attitudeId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [DELETE /rest/ezattitude/attitudes/" + attitudeId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String mode = request.getParameter("mode");
			
			if (mode == null) {
				mode = "";
			}
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			AttitudeVO attitudeVO = ezAttitudeService.getAttitudeInfo(attitudeId, info.getOffSet(), info.getPrimary(), info.getCompanyId(), info.getTenantId());
			MCommonVO userInfo = mOptionService.commonInfoWeb(serverName, attitudeVO.getWriterId()); 
			
			ezAttitudeService.deleteAttitude(attitudeId, info.getTenantId(), mode, attitudeVO, info.getOffSet(), info, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [DELETE /rest/ezattitude/attitudes/" + attitudeId + "] ended.");
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
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "/modify-applications] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", status);
		}
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "/modify-applications] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 조직도 회사, 부서조회
	 */
	@RequestMapping(value = "/rest/ezattitude/organtree/depts", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject organtreeDepts(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/organtree/depts] started.");
		
		JSONObject result = new JSONObject();
		
		try {
	         String userId = request.getParameter("userId");
	         String primary = request.getParameter("primary");
	         String serverName = request.getHeader("x-user-host");
	         MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
	         
	         logger.debug("userId : " + userId);
	         String companyId = request.getParameter("companyId");
	         
	         if (companyId == null || companyId.equals("")) {
	            companyId = info.getCompanyId();
	         }
	         /* 2020-05-29 홍승비 - 권한부서 선택 시, 현재 사용자가 아닌 권한자의 userID가 넘어가기 때문에 primary 값을 전달하지 못하는 오류 수정 */
	         List<DeptViewVO> deptList = ezAttitudeService.getDeptViewList(userId, companyId, info.getTenantId(), primary);
	         
	         result.put("status", "ok");
	         result.put("code", 0);
	         result.put("data", deptList);
	      } catch (Exception e) {
	    	 logger.error(e.getMessage(), e);
	         result.put("code", 1);
	         result.put("status", "error");
	         result.put("data", "");
	      }

		logger.debug("G/W EzAttitude [GET /rest/ezattitude/organtree/depts] ended.");
		return result;
	}
	
	/* 2024-07-29 홍승비 - 해당 URL 호출되지 않음, 현재 /admin/ezJournal/userList.do가 대신 호출됨 */
	/**
	 * G/W 근태관리 [GET] 부서의 사원들 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/organtree/users", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject organtreeUsersOfDept(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/organtree/users] started.");
		JSONObject result = new JSONObject();
		
		try {
			String key = request.getParameter("key");
			String value = request.getParameter("value");
			String companyId = request.getParameter("companyId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			if (companyId == null || companyId.equals("")) {
				companyId = info.getCompanyId();
			}
			
			List<AttitudeAuthorVO> userList = ezAttitudeService.getDeptUserList(info.getTenantId(), key, value, companyId, info.getPrimary());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/organtree/users] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 개인 월별 근태 통계
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/attitude-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject userAttitudeCount(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/attitude-count] started.");
		
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
			cal.set(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(5)) - 1, 1);
			
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/attitude-count] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 부서 월별 근태 통계
	 */
	@RequestMapping(value = "/rest/ezattitude/depts/{deptId}/attitude-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject deptAttitudeCount(@PathVariable String deptId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/depts/" + deptId + "/attitude-count] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /ezattitude/depts/" + deptId + "/attitude-count] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태규율설정정보 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudereg", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeConfInfo(@PathVariable String companyId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudereg] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudereg] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 근태규율설정정보 수정
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudereg", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateAttitudeConf(@PathVariable String companyId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudereg] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudereg] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태유형 리스트 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeTypeList(@PathVariable String companyId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudetypes] started.");

		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String isuse = request.getParameter("isuse") == null ? "" : request.getParameter("isuse");
			String isAdmin = request.getParameter("isAdmin") == null ? "" : request.getParameter("isAdmin");
			String statistics = request.getParameter("statistics") == null ? "" : request.getParameter("statistics");
			String typeIdArr = request.getParameter("typeIdArr") == null ? "" : request.getParameter("typeIdArr");
			String primary = info.getPrimary();
			
			// 관리자의 경우 관리자 언어 세팅에 맞는 데이터 표출 필요.
			// EzAttitudeController 의 attAdminNewItem.do 에서 userId는 로그인 user의 id가 아닌
			// 선택한 유저의 id가 넘어와서 로그인 유저의 primary와 선택한 유저의 primary세팅값이 다름.
			if (request.getParameter("loginId") != null) {
				primary = mOptionService.commonInfoWeb(serverName, request.getParameter("loginId")).getPrimary();
			}
			
			List<AttitudeTypeVO> attitudeTypeList = ezAttitudeService.getAttitudeTypeList(companyId, isuse, isAdmin, statistics, typeIdArr, info.getTenantId(), primary);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", attitudeTypeList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudetypes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 근태유형 사용여부 일괄저장
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject attitudeTypeBatchStore(@PathVariable String companyId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudetypes] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudetypes] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 근태유형 추가
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertAttitudeType(@PathVariable String companyId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/attitudetypes] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/attitudetypes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태유형 상세보기
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes/{attitudetypeId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeTypeInfo(@PathVariable String companyId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			AttitudeTypeVO typeInfo = ezAttitudeService.getAttitudeTypeInfo(info.getTenantId(), companyId, attitudetypeId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", typeInfo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId + "] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 근태유형 수정
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes/{attitudetypeId:.+}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateAttitudeType(@PathVariable String companyId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId+ "] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId+ "] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [DELETE] 근태유형 삭제
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes/{attitudetypeId:.+}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteAttitudeType(@PathVariable String companyId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [DELETE /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId+ "] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [DELETE /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId+ "] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 회사리스트
	 */
	@RequestMapping(value = "/rest/ezattitude/companies", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject updateAttitudeType(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			//테넌트별 회사리스트
//			List<AttitudeDeptVO> list = ezAttitudeService.getCompanyList(info.getPrimary(), info.getTenantId(), userId);
			List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(userId, info.getTenantId(), info.getPrimary(), info.getDeptId(), info.getJobId());
			data.put("list", adminCompanyList);
			//로그인한 관리자의 회사
			data.put("adminCompany", info.getCompanyId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근무시간 리스트 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/user-attitude-confs", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject userAttitudeConfList(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users-attitude-confs] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users-attitude-confs] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근무시간 정보 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/users/users-attitude-confs", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject userAttitudeConfInfo(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/users-attitude-confs] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/users-attitude-confs] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 근무시간 수정
	 */
	@RequestMapping(value = "/rest/users/ezattitude/user-attitude-confs", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertUserAttitudeConf(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/users-attitude-confs] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/users-attitude-confs] ended.");
		return result;
	}
	/**
	 * G/W 근태관리 [POST] 부서 근무시간 수정
	 */
	@RequestMapping(value = "/rest/users/ezattitude/dept-attitude-confs", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertDeptAttitudeConf(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/dept-attitude-confs] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/dept-attitude-confs] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 수정신청 리스트
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/modifyattitudes", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
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
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/modifyattitudes] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();

		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String order = orderCell + " " + orderOption;
			@SuppressWarnings("unused")
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
			
			if (!checkAdmin.equals("true") && deptid.equals("ALL")) {
				List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, info.getUserId(), info.getRollInfo(), "", "M", "", info.getPrimary());
				
				for (AttitudeAuthorVO vo : authDeptlist) {
					if (vo.getAuthType() != null && vo.getAuthType().equals("M")) {
						deptIdList.add(vo.getDeptId());
					}
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/modifyattitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 수정신청 개수
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/modifyattitudes/count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
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
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/modifyattitudes/count] started.");

		JSONObject result = new JSONObject();
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
				List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, info.getUserId(), info.getRollInfo(), "", "M", "", info.getPrimary());
	
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/modifyattitudes/count] ended.");
		return result;
	}
	
    /**
	 * G/W 근태관리 [GET] 휴일리스트
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/holidays", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getHolidayList(@PathVariable String companyId, HttpServletRequest request) throws Exception{
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/holidays] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/holidays] ended.");
		return result;
	}
    
	/**
	 * G/W 근태관리 [DELETE] 수정신청 삭제
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/modifyattitudes", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject delUsersModiyAtt(@PathVariable String userId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="idList", required=false) String idList) {
			
		logger.debug("G/W EzAttitude [DELETE /rest/ezattitude/users/"+userId+"/modifyattitudes] started.");
		
		JSONObject result = new JSONObject();
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", status);
		}
		logger.debug("G/W EzAttitude [DELETE /rest/ezattitude/users/"+userId+"/modifyattitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 수정신청 승인,반려
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/modifyattitudes", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject changeUsersModiyAtt(@PathVariable String userId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="idList", required=true) String idList,
			@RequestParam(value="changeStatus", required=true) String changeStatus) {
			
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/users/"+userId+"/modifyattitudes] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "fail");
		}
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/users/"+userId+"/modifyattitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태관리 작성양식
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudetypes/{attitudetypeId}/forms/form", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFormBody(@PathVariable String attitudetypeId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudetypes/"+attitudetypeId+"/forms/form] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String lang = info.getPrimary();
			
			AttitudeFormVO formVO = ezAttitudeService.getFormBody(attitudetypeId, companyId, tenantId, lang);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", formVO);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudetypes/"+attitudetypeId+"/forms/form] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태 수정 신청 상세
	 */
	@RequestMapping(value = "/rest/ezattitude/modifyattitude/{attModId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attModAppDetail(
			@PathVariable String attModId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="userId", required=true) String userId,
			@RequestParam(value="offset", required=true) String offset,
			@RequestParam(value="applCnt", required=false) String applCnt) throws Exception{
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/modifyattitude/"+attModId+"] started.");
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			AttitudeApplicationVO data = ezAttitudeService.attModAppDetail(attModId, offset, applCnt, info.getPrimary(), companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/modifyattitude/"+attModId+"] ended.");
		return result;
	}

	/**
	 * G/W 근태관리 [POST] 근태수정현황 수정
	 */
	@RequestMapping(value = "/rest/ezattitude/modifyattitude/{attModId:.+}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject attModAppModify(
			@PathVariable String attModId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="userId", required=true) String userId,
			@RequestParam(value="offset", required=true) String offset,
			@RequestParam(value="content", required=true) String content,
			@RequestParam(value="changeDate", required=true) String changeDate) throws Exception{
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/modifyattitude/"+attModId+"] started.");
		JSONObject result = new JSONObject();
		int update = 0;
		try {
			update = ezAttitudeService.attModAppModify(companyId, tenantId, userId, attModId, offset, content, changeDate);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", update);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", update);
		}
		
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/modifyattitude/"+attModId+"] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태입력관리 > 근태조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/check", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject attitudeMainList2(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/check] started.");
		
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
			// String offsetMin = request.getParameter("offsetMin");
			String isAdmin = request.getParameter("isAdmin") == null ? "" : request.getParameter("isAdmin");
			// String statistics = request.getParameter("statistics");
			// String isuse = "1";
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			String offset = info.getOffSet();
			
			List<String> deptIdList = new ArrayList<>();

			if (!isAdmin.equals("Y") && searchDeptId.equals("ALL")) {
				List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, info.getUserId(), info.getRollInfo(), "", "M", "", info.getPrimary());
				
				for (AttitudeAuthorVO vo : authDeptlist) {
					if (vo.getAuthType() != null && vo.getAuthType().equals("M")) {
						deptIdList.add(vo.getDeptId());
					}
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/check] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태조회 미입력자 목록
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/absent", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject attitudeAbsentList(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/absent] started.");
		
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
			// String offsetMin = request.getParameter("offsetMin");
			String duplicated = request.getParameter("duplicated");
			String isAdmin = request.getParameter("isAdmin") == null ? "" : request.getParameter("isAdmin");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			List<String> deptIdList = new ArrayList<>();
			if (!isAdmin.equals("Y") && searchDeptId.equals("ALL")) {
				List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, info.getUserId(), info.getRollInfo(), "", "M", "", info.getPrimary());
				
				for (AttitudeAuthorVO vo : authDeptlist) {
					if (vo.getAuthType() != null && vo.getAuthType().equals("M")) {
						deptIdList.add(vo.getDeptId());
					}
				}				
			}
			
			if (searchDeptId.equals("ALL")) {
				searchDeptId = "";
			}
			
			String lang = "1";
			if (commonUtil.getPrimaryData(info.getLang(), info.getTenantId()) != null) {
				lang = commonUtil.getPrimaryData(info.getLang(), info.getTenantId());
			}
			
			JSONObject data = ezAttitudeService.getAttitudeAbsentedList(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, searchDeptId, pageNum, listSize, orderCell, orderOption, duplicated, lang, info.getOffSet(), companyId, info.getTenantId(), deptIdList, info.getPrimary());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/absent] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태관리 미입력자 메일발송
	 */
	/* 현재는 메일 작성창을 띄우므로 사용하지 않고 있음.
	@RequestMapping(value = "/rest/ezattitude/attitudes/mail", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject absentedListSendMail(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/mail] started.");
		
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
			
			logger.debug("배현상 메일정보 확인 : " + info.getEmail());
			JSONObject data = new JSONObject();
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "success");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "error");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/mail] ended.");
		
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
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/modifyattitude/" + attModId + "/history started");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<AttitudeApplicationVO> data = ezAttitudeService.attModGetHistory(attModId, userId, offset, info.getPrimary(), companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.debug("G/W EzAttitude [GET /rest/ezattitude/modifyattitude/" + attModId + "/history ended.");
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
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitude-auth] started.");
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
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitude-auth] ended.");
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
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/attitude-auth] started.");
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
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/attitude-auth] ended.");
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
		logger.debug("G/W EzAttitude [DELETE /rest/ezattitude/companies/" + companyId + "/attitude-auth] started.");
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
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [DELETE /rest/ezattitude/companies/" + companyId + "/attitude-auth] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태권한자 상세 조회(권한있는 부서 체크)
	 * 
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/attitude-auth", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeAuthDeptList(@PathVariable String userId, HttpServletRequest request) throws Exception{
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/attitude-auth] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String isAllDept = request.getParameter("isAllDept");
			String lang = request.getParameter("lang") == null ? "1" : request.getParameter("lang");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			// 현재 사용자가 아닌 해당 근태권한자의 primary 언어값을 전달하고 있으므로 주의 (수정 필요)
			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList(info.getTenantId(), companyId, userId, isAllDept, lang);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", authDeptlist);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/attitude-auth] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태권한자 상세 조회(권한있는 부서 체크)
	 * userAuthType  all:(회사,전체,근태관리자), dept:,부서관리자, (''/null):일반사용자       전달받은 인자없으면 userInfo체크해서 동작
	 * listAuthType  (''/null/all):전체, M:관리, R:열람
	 * comFlag  회사에 포함된 인원 처리(미사용)
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/attitude-auth/hyo", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeAuthDeptListhyo(@PathVariable String userId, HttpServletRequest request) throws Exception{
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/attitude-auth/hyo] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String userAuthType = request.getParameter("userAuthType");
			String listAuthType = request.getParameter("listAuthType");
			String comFlag = request.getParameter("comFlag");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, userId, info.getRollInfo(), userAuthType, listAuthType, comFlag, info.getPrimary());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", authDeptlist);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/attitude-auth/hyo] ended.");
		return result;
	}
	
	/**
	 * G/W 통계 [GET] 개인 근태 유형별 통계 -----임시
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{selectUserId}/attitudetypes/{attitudetypeId}/attitude-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeUserCount(@PathVariable String selectUserId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + selectUserId + "/attitudetypes/" + attitudetypeId + "/attitude-count] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + selectUserId + "/attitudetypes/" + attitudetypeId + "/attitude-count] ended.");
		return result;
	}
	
	/**
	 * G/W 통계 [GET] 부서 근태 유형별 통계 -----임시
	 */
	@RequestMapping(value = "/rest/ezattitude/depts/{deptId}/attitudetypes/{attitudetypeId}/attitude-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeDeptCount(@PathVariable String deptId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/depts/"+deptId+"/attitudetypes/" + attitudetypeId + "/attitude-count] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/depts/"+deptId+"/attitudetypes/" + attitudetypeId + "/attitude-count] ended.");
		return result;
	}
	
	/**
	 * G/W 부서근태현황 [GET] 회사별 부서 리스트 조회 (2024-07-29 확인 시 해당 URL은 호출되지 않음)
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/depts", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyDeptList(@PathVariable String companyId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/"+companyId+"/depts] started.");
		
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/"+companyId+"/depts] ended.");
		return result;
	}
	
	/**
	 * G/W 근태수정관리 > 근태관리 > 관리내역  [GET] 관리내역 리스트 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/manageHistories", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeHistoryList(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/manageHistories] started.");
		
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
			// String offsetMin = request.getParameter("offsetMin");
			String isAdmin = request.getParameter("isAdmin") == null ? "" : request.getParameter("isAdmin");
			String statistics = request.getParameter("statistics");
			String isuse = "1";
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantID = info.getTenantId();
			String offset = info.getOffSet();
			
			List<String> deptIdList = new ArrayList<>();
			
			if (!isAdmin.equals("Y") && searchDeptId.equals("ALL")) {
				List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, info.getUserId(), info.getRollInfo(), "", "M", "", info.getPrimary());
				
				for (AttitudeAuthorVO vo : authDeptlist) {
					if (vo.getAuthType() != null && vo.getAuthType().equals("M")) {
						deptIdList.add(vo.getDeptId());
					}
				}				
			}
			
			if (searchDeptId.equals("ALL")) {
				searchDeptId = "";
			}
			
			String totalCount = ezAttitudeService.getAttitudeHistoryCount(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, offset, companyId, tenantID, searchDeptId, deptIdList);
			List<ModApplHistoryVO> list = ezAttitudeService.getAttitudeHistoryList(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, orderCell, orderOption, offset, pageNum, listSize, companyId, tenantID, searchDeptId, deptIdList, info.getPrimary());
		
			//구분 리스트
			List<AttitudeTypeVO> typeList = ezAttitudeService.getAttitudeTypeList(companyId, isuse, isAdmin, statistics, "", info.getTenantId(), info.getPrimary());
			
			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("totalCount", totalCount);
			data.put("typeList", typeList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/manageHistories] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 조직도 부서 및 사원목록 검색
	 */
	@RequestMapping(value = "/rest/ezAttitude/getSearchList.do", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getSearchList(HttpServletRequest request){	    
		logger.debug("G/W EzAttitude [GET /rest/ezAttitude/getSearchList.do] started.");
		
	    JSONObject resultJ = new JSONObject();
	    
	    try {
			String serverName = request.getHeader("x-user-host");
	    	MCommonVO userInfo = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
	        int tenantID = userInfo.getTenantId();        
	        
	        logger.debug("tenantID=" + tenantID);       
			
			String searchlist = request.getParameter("searchlist").trim();
			String celllist = request.getParameter("celllist");
			String proplist = request.getParameter("proplist");
			String listtype = request.getParameter("listtype");
			String companyID = request.getParameter("companyID");
			String lang = userInfo.getPrimary();
			String page = request.getParameter("page");
			String infoXML = "";
			
			logger.debug("searchlist=" + searchlist + ",celllist=" + celllist + ",proplist=" + proplist
			        + ",listtype=" + listtype + ",lang=" + lang + ",page=" + page + ",companyID=" + companyID);
			
			List<String> deptIdList = new ArrayList<>();
			
			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(userInfo.getTenantId(), companyID, userInfo.getUserId(), userInfo.getRollInfo(), "", "M", "", userInfo.getPrimary());
			
			for (AttitudeAuthorVO vo : authDeptlist) {
				deptIdList.add(vo.getDeptId());
			}
			
			/* 2024-07-25 홍승비 - 근태입력관리 > 근태입력대상 설정 기능의 조직도 검색 시, 페이지 값은 항상 1의 기본값을 가지므로 미사용 분기 주석처리 */
/*			if (page == null) {
				infoXML = ezAttitudeService.getSearchList(searchlist, celllist, proplist, listtype, 100, lang, tenantID);
			} else {*/
				infoXML = ezAttitudeService.getSearchListPagination(searchlist, celllist, proplist, listtype, 100, lang, page, tenantID, deptIdList);
			//}
			
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
	    	logger.error(e.getMessage(), e);
	    	resultJ.put("status", "error");
	    	resultJ.put("code", 1);
	    	resultJ.put("data", "");
		}
	    logger.debug("G/W EzAttitude [GET /rest/ezAttitude/getSearchList.do] ended.");
		return resultJ;
	}
	
	/**
	 * G/W 근태관리 [GET] 당일 근태관리 중복
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/checkIsAttitude", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCheckIsAttitude(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/checkIsAttitude] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String typeId = request.getParameter("typeId");
			String userId = request.getParameter("userId");
			String startDate = request.getParameter("startDate");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			String returnValue = ezAttitudeService.getIsAttitude(typeId, userId, startDate, info.getOffSet(), info.getCompanyId(), info.getTenantId(), "");
						
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", returnValue);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/checkIsAttitude] ended.");
		return result;
	}
	
	/**
	 * G/W 연차현황관리 [GET] 연차현황조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/companies/{companyId}/annual", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject getAttitudeAnnualList(@PathVariable String companyId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/companies/" + companyId + "/annual] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String searchUserName = request.getParameter("searchUserName");
			String searchDeptName = request.getParameter("searchDeptName");
			// String searchDeptId = request.getParameter("searchDeptId") == null ? "" : request.getParameter("searchDeptId");
			String searchTitle = request.getParameter("searchTitle");
			String pageNum = request.getParameter("pageNum");
			String listSize = request.getParameter("listSize");
			String orderCell = request.getParameter("orderCell");
			String orderOption = request.getParameter("orderOption");
			String offsetMin = request.getParameter("offsetMin");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			
			String totalCount = ezAttitudeService.getAttitudeAnnualListCount(searchUserName, searchDeptName, searchTitle, offsetMin, companyId, tenantId, info.getPrimary());
			List<AttitudeAnnualVO> list = ezAttitudeService.getAttitudeAnnualList(searchUserName, searchDeptName, searchTitle, orderCell, orderOption, offsetMin, pageNum, listSize, companyId, tenantId, info.getPrimary(), startDate, endDate);
			
			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("totalCount", totalCount);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/companies/" + companyId + "/annual] ended.");
		return result;
	}

	/**
	 * G/W 근태관리 [POST] 연차현황 전체 등록/수정
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/changeallannual", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject changeAllAnnual(@PathVariable String companyId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/changeallannual] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("changeUserId"));
			String primary = info.getPrimary();
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("searchUserName", request.getParameter("searchUserName"));
			map.put("searchDeptName", request.getParameter("searchDeptName"));
			map.put("searchTitle", request.getParameter("searchTitle"));
			map.put("changeUserId", request.getParameter("changeUserId"));
			map.put("changeReason", request.getParameter("changeReason"));
			map.put("annualCnt", request.getParameter("annualCnt"));
			map.put("tenantId", info.getTenantId());
			map.put("companyId", companyId);
			
			if (primary.equals("1")) {
				primary = "";
			}
			map.put("primary", primary);
			
			ezAttitudeService.changeAllAnnual(map);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (DataIntegrityViolationException e) {
			logger.error(e.getMessage(), e);
			result.put("status", "dive");
			result.put("code", 1);
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/changeallannual] ended.");
		return result;
	}
	
	@RequestMapping(value="/rest/ezattitude/users/{userId:.+}/{userLang}/annual", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserAnnual(@PathVariable String userId,@PathVariable String userLang, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/annual] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String orderCell = request.getParameter("orderCell");
			String orderOption = request.getParameter("orderOption");
			String secondYear = request.getParameter("secondYear");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			List<AdminAttitudeVO> list = ezAttitudeService.getUserAnnual(userId, userLang, info.getOffSet(), startDate, endDate, orderCell, orderOption, secondYear, companyId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", list);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/annual] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 연차현황 개별 등록/수정
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/changePrsnAnnual", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject changePrsnAnnual(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId + "/changePrsnAnnual] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");

			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("changeUserId"));
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("userId", userId);
			map.put("changeUserId", request.getParameter("changeUserId"));
			map.put("tenantId", info.getTenantId());
			map.put("companyId", request.getParameter("companyId"));
			map.put("flagCheck", request.getParameter("flagCheck"));
			map.put("changeReason", request.getParameter("changeReason"));
			map.put("annualCnt", Float.parseFloat(request.getParameter("annualCnt"))); // 연차, 반차(0.5) 일수 추가를 위해 소수점 float 타입으로 파싱
			
			ezAttitudeService.changeAnnual(map);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId + "/changePrsnAnnual] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 연차현황 엑셀 일괄 등록
	 */
	@RequestMapping(value = "/rest/ezattitude/annualExcelUpload", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject annualExcelUpload(@RequestParam("data") String dataList, @RequestParam("files") List<MultipartFile> multiFileLists, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/annualExcelUpload] started.");
		
		JSONObject result = new JSONObject();
		String resultMsg = "";
		
		try{
			JSONParser jp          = new JSONParser();
			JSONObject jsonObject  = (JSONObject) jp.parse(dataList);
			
			String serverName = request.getHeader("x-user-host");
			String changeUserId = (String) jsonObject.get("changeUserId");
			String companyId = (String) jsonObject.get("companyId");
//			String changeReason = (String) jsonObject.get("changeReason");
			String changeReason = egovMessageSource.getMessage("ezAttitude.t316");
			String flagCheck = (String) jsonObject.get("flagCheck");
			String loginCookie = (String) jsonObject.get("loginCookie");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, changeUserId);
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			MultipartFile tempFile = multiFileLists.get(0);
			
			InputStream is = tempFile.getInputStream();
			
			Workbook wb = new HSSFWorkbook(is);
			
			Sheet sheet = wb.getSheetAt(0);
			
			int numOfRows = sheet.getPhysicalNumberOfRows();
			if(numOfRows < 2) {
				resultMsg = egovMessageSource.getMessage("ezAttitude.t317");
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", resultMsg);
				wb.close();
				return result;
			}
			int numOfCells = 0;
			
			Row row = null;
	        Cell cell = null;
	
	        String cellName = "";
	        
	        Map<String, Object> map = null;
	        List<Map<String, Object>> excelList = new ArrayList<Map<String, Object>>();
	        List<String> outputColumns = new ArrayList<String>();
	        String[] outputColumnsArray = {"A","B","C"};
	        
	        for(String ouputColumn : outputColumnsArray) {
	            outputColumns.add(ouputColumn);
	        }
	        
	        for(int rowIndex = 0; rowIndex < numOfRows; rowIndex++) {
	            row = sheet.getRow(rowIndex);
	            if(row != null) {
	                numOfCells = row.getPhysicalNumberOfCells();
	                map = new HashMap<String, Object>();
	                boolean emptyFlag = true;
	                for(int cellIndex = 0; cellIndex < numOfCells; cellIndex++) {
	                    cell = row.getCell(cellIndex);
	                    cellName = excelCellRef.getName(cell, cellIndex);
	                    if(!outputColumns.contains(cellName) ) {
	                        continue;
	                    }
	                    if(!excelCellRef.getValue(cell).equals("")) {
	                    	emptyFlag = false;
	                    }
	                    map.put(cellName, excelCellRef.getValue(cell));
	                }
	                if(emptyFlag) {
	                	break;
	                }
	                excelList.add(map);
	            }
	        }
	        
	        @SuppressWarnings("unused")
			Map<String, Object> excelTitle = excelList.get(0);
	        
	        wb.close();
	        
	        resultMsg = ezAttitudeService.annualExcelUpload(excelList, changeUserId, companyId, info.getTenantId(), changeReason, flagCheck, userInfo.getLocale());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resultMsg);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/annualExcelUpload] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 연차현황 수정내역확인
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/{userLang}/annualHistoryPop", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject annualHistoryPop(@PathVariable String userId,@PathVariable String userLang, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId +"/"+ userLang +"/annualHistoryPop] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("userId", userId);
			map.put("companyId", request.getParameter("companyId"));
			map.put("tenantId", info.getTenantId());
			
			/* String primary = info.getPrimary();
			if (primary.equals("1")) {
				primary = "";
			}*/
			
			map.put("primary", commonUtil.getMultiData(userLang, info.getTenantId()));
			
			List<Map<String,Object>> resultList = ezAttitudeService.getAnnualHistoryList(map);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resultList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId + "/annualHistoryPop] ended.");
		return result;
	}
	
	
	/**
	 * G/W 근태관리 [GET] 개인 월별 근태 통계
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/monthlyannual", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getMonthlyAnnualList(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/monthlyannual] started.");
		
		JSONObject result = new JSONObject();
		try{
			String serverName = request.getHeader("x-user-host");
			String offset = request.getParameter("offset");
			String year = request.getParameter("year");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>();
			
			for(int i = 1; i <= 12; i++) {
				
				String date = null;
				
				if(i <= 9) {
					date = year + "-0" + i;
				} else {
					date = year + "-" + i;
				}
				
				Calendar cal = Calendar.getInstance();
				cal.set(Integer.valueOf(date.substring(0, 4)), Integer.valueOf(date.substring(5)) - 1, 1);
				
				String startDate = date + "-01 00:00:00";
				String endDate = date + "-" + cal.getActualMaximum(Calendar.DAY_OF_MONTH) + " 23:59:59";
				
				Map<String, Object> resultMap = ezAttitudeService.getMonthlyAnnualList(userId, offset, startDate, endDate, info.getTenantId());
				
				resultList.add(resultMap);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resultList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/monthlyannual] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 연차취소신청 등록
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/{attitudeId}/savecancelannual", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject saveCancelAnnual(@PathVariable String attitudeId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="userId", required=true) String userId,
			@RequestParam(value="offset", required=true) String offset,
			@RequestParam(value="idList", required=false) String idList,
			@RequestParam(value="loginCookie", required=false) String loginCookie,
			@RequestParam(value="content", required=true) String content) {
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "/savecancelannual] started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		JSONObject result = new JSONObject();
		String status = "exception";
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			status = ezAttitudeService.saveCancelAnnual(attitudeId, companyId, tenantId, userId, info.getUserName(), 
					info.getUserName2(), info.getTitle(), info.getTitle2(), info.getDeptId(), info.getDeptName(), 
					info.getDeptName2(), "0", content, offset);
			
			AttitudeVO vo = ezAttitudeService.getAttitudeInfo(attitudeId, info.getOffSet(), info.getPrimary(), companyId, tenantId);
			
			if(idList != null && !idList.equals("")) {
				ezAttitudeService.sendMailToReference(vo, attitudeId, idList, request, loginCookie, userInfo, companyId, tenantId);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", status);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", status);
		}
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "/savecancelannual] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [DELETE] 연차취소신청 삭제
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/deletecancelannual", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteCancelAnnual(@PathVariable String userId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="attitudeId", required=false) String attitudeId) {
			
		logger.debug("G/W EzAttitude [DELETE /rest/ezattitude/users/"+userId+"/deletecancelannual] started.");
		
		JSONObject result = new JSONObject();
		// JSONObject data = new JSONObject();
		// JSONObject attJson = new JSONObject();
		
		int status = 0;
		
		try{
			status = ezAttitudeService.deleteCancelAnnual(companyId, tenantId, attitudeId);
			
			if (status == 1) {
				result.put("status", "ok");
			} else {
				result.put("status", "error");
			}
			result.put("code", 0);
			result.put("data", status);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", status);
		}
		logger.debug("G/W EzAttitude [DELETE /rest/ezattitude/users/"+userId+"/deletecancelannual] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 취소신청 개수
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/cancelannual/count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUsersCancelAnnCount(@PathVariable String userId, HttpServletRequest request,
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
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/cancelannual/count] started.");

		JSONObject result = new JSONObject();
		// JSONObject data = new JSONObject();
		// JSONObject attJson = new JSONObject();
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
				List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, info.getUserId(), info.getRollInfo(), "", "M", "", info.getPrimary());
	
				for (AttitudeAuthorVO vo : authDeptlist) {
					if (vo.getAuthType() != null && vo.getAuthType().equals("M")) {
						deptIdList.add(vo.getDeptId());
					}
				}
			}
			
			if (deptid.equals("ALL")) {
				deptid = "";
			}
			
			int attListCount = ezAttitudeService.getUsersCancelAnnCount(companyId, tenantId, userId, startDate, endDate, apprUserName, writerName, writerDeptName, info.getPrimary(), offset, type, deptid, deptIdList, adminFlag, checkAdmin);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", attListCount+"");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/cancelannual/count] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 수정신청 리스트
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/cancelannual", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUsersCancelAnn(@PathVariable String userId, HttpServletRequest request,
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
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/cancelannual] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		// JSONObject attJson = new JSONObject();

		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String order = orderCell + " " + orderOption;
			@SuppressWarnings("unused")
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
			
			if (!checkAdmin.equals("true") && deptid.equals("ALL")) {
				List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList_hyo(info.getTenantId(), companyId, info.getUserId(), info.getRollInfo(), "", "M", "", info.getPrimary());
				
				for (AttitudeAuthorVO vo : authDeptlist) {
					if (vo.getAuthType() != null && vo.getAuthType().equals("M")) {
						deptIdList.add(vo.getDeptId());
					}
				}
			}
			
			
			if (deptid.equals("ALL")) {
				deptid = "";
			}
			
			List<AttitudeApplicationVO> attList = ezAttitudeService.getUsersCancelAnn(companyId, tenantId, userId, startDate, endDate, apprUserName, writerName, writerDeptName, info.getPrimary(), offset, startPoint, endPoint, type, order, adminFlag, checkAdmin, deptid, deptIdList);

			data.put("list", attList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/cancelannual] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태 수정 신청 상세
	 */
	@RequestMapping(value = "/rest/ezattitude/cancelannual/{attModId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject annCanAppDetail(
			@PathVariable String attModId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="userId", required=true) String userId,
			@RequestParam(value="offset", required=true) String offset,
			@RequestParam(value="applCnt", required=false) String applCnt) throws Exception{
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/cancelannual/"+attModId+"] started.");
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			AttitudeApplicationVO data = ezAttitudeService.annCanAppDetail(attModId, offset, applCnt, info.getPrimary(), companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/cancelannual/"+attModId+"] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 수정신청 승인,반려
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/cancelannual", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject changeUsersCancelAnn(@PathVariable String userId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="idList", required=true) String idList,
			@RequestParam(value="changeStatus", required=true) String changeStatus) {
			
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/users/"+userId+"/cancelannual] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		// JSONObject attJson = new JSONObject();
		
		try{
			String[] ids = idList.split(",");
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			for (int i = 0; i < ids.length; i++) {
				ezAttitudeService.changeUsersCancelAnn(companyId, tenantId, ids[i], changeStatus, userId, info.getUserName(), info.getUserName2(), info.getOffSet());
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "fail");
		}
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/users/"+userId+"/cancelannual] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 연차취소내역리스트
	 */
	@RequestMapping(value = "/rest/ezattitude/cancelannual/{attModId}/history", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAnnCanHistory(
			@PathVariable String attModId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="userId", required=true) String userId,
			@RequestParam(value="offset", required=true) String offset) throws Exception{
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/cancelannual/" + attModId + "/history started");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<AttitudeApplicationVO> data = ezAttitudeService.getAnnCanHistory(attModId, userId, offset, info.getPrimary(), companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.debug("G/W EzAttitude [GET /rest/ezattitude/cancelannual/" + attModId + "/history ended.");
		}
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 입사일 등록
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/joindate", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject saveJoinDate(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId + "/saveJoinDate] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("userId", userId);
			map.put("companyId", request.getParameter("companyId"));
			map.put("date", request.getParameter("date"));
			map.put("mode", request.getParameter("mode"));
			map.put("tenantId", info.getTenantId());
			
			ezAttitudeService.saveJoinDate(map);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId + "/saveJoinDate] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 개인 연차 수 정보(총연차 수 / 사용연차수)
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/annualcnt", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAnnaulCntInfo(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/annualcnt] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("userId", userId);
			map.put("companyId", request.getParameter("companyId"));
			map.put("tenantId", info.getTenantId());
			map.put("offsetMin", commonUtil.getMinuteUTC(info.getOffSet()));
			
			String primary = info.getPrimary();
			if (primary.equals("1")) {
				primary = "";
			}
			map.put("primary", primary);
			
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String secondYear = request.getParameter("secondYear");
			
			String searchStartTime = startDate + " 00:00:00";
			String searchEndTime = endDate + " 23:59:59";
			
			map.put("searchStartTime", searchStartTime);
			map.put("searchEndTime", searchEndTime);
			
			AttitudeAnnualVO vo = ezAttitudeService.getAnnualCnt(map);
			
			if (secondYear.equals("Y") || secondYear.equals("T")) {
				Map<String, Object> map2 = new HashMap<String, Object>();
				map2.put("userId", userId);
				map2.put("companyId", request.getParameter("companyId"));
				map2.put("tenantId", info.getTenantId());
				map2.put("offsetMin", commonUtil.getMinuteUTC(info.getOffSet()));
				
				if (primary.equals("1")) {
					primary = "";
				}
				map2.put("primary", primary);
				
				if (secondYear.equals("Y")) {
					searchStartTime = (Integer.parseInt(startDate.substring(0, 4)) - 1) + startDate.substring(4, 10) + " 00:00:00";
				} else {
					searchStartTime = (Integer.parseInt(startDate.substring(0, 4)) - 2) + startDate.substring(4, 10) + " 00:00:00";
				}
				searchEndTime = (Integer.parseInt(endDate.substring(0, 4)) - 1) + endDate.substring(4, 10) + " 23:59:59";
				
				map2.put("searchStartTime", searchStartTime);
				map2.put("searchEndTime", searchEndTime);
				
				double useAnnualCnt = Double.parseDouble(ezAttitudeService.getAnnualCnt(map2).getUseAnnualCnt());
				if (useAnnualCnt > 11.0) {
					useAnnualCnt = 11.0;
				}
				double totalAnnualCnt = Double.parseDouble(vo.getTotalAnnualCnt());
				vo.setTotalAnnualCnt(totalAnnualCnt - useAnnualCnt + "");
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", vo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/annualcnt] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 전자결재 연동 (휴가계 기안시 해당 휴가 근태 등록)
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/approvalconn", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject approvalGConn(@PathVariable String userId, HttpServletRequest request) {
			
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/users/"+userId+"/approvalconn] started.");
		
		JSONObject result = new JSONObject();
		int status = 0;
				
		try{
			String content = request.getParameter("content");
			String mobile = request.getParameter("mobile");
			String attitudeTypeList = request.getParameter("attitudeTypeList");
			String startDateList = request.getParameter("startDateList");
			String endDateList = request.getParameter("endDateList");
			String startTimeList = request.getParameter("startTimeList");
			String endTimeList = request.getParameter("endTimeList");
			String docId = request.getParameter("docId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			status = ezAttitudeService.approvalGConn(userId, info.getDeptId(), content, mobile, attitudeTypeList, startDateList, endDateList, startTimeList, endTimeList, docId, info.getOffSet(), info.getCompanyId(), info.getTenantId());
			
			if (status == 1) {
				result.put("status", "ok");
			} else {
				result.put("status", "error");
			}
			result.put("code", 0);
			result.put("data", status);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", status);
		}
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/users/"+userId+"/approvalconn] ended.");
		return result;
	}
	/**
	 * G/W 근태관리 [PUT] 전자결재 연동 (수신부서 완료시 결재상태 1로 변경)
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/approvalconn", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateApprovalGConnInfo(@PathVariable String userId, HttpServletRequest request) {
		
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/users/"+userId+"/approvalconn] started.");
		
		JSONObject result = new JSONObject();
		int status = 0;
		
		try{
			String aprStatus = request.getParameter("status");
			String docId = request.getParameter("docId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			status = ezAttitudeService.updateApprovalGConnInfo(aprStatus, userId, docId, info.getCompanyId(), info.getTenantId());
			
			if (status == 1) {
				result.put("status", "ok");
			} else {
				result.put("status", "error");
			}
			result.put("code", 0);
			result.put("data", status);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", status);
		}
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/users/"+userId+"/approvalconn] ended.");
		return result;
	}
	/**
	 * G/W 근태관리 [DELETE] 전자결재 연동 (휴가계 회수/반려시 해당 휴가 근태 삭제)
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/approvalconn", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteApprovalGConnInfo(@PathVariable String userId, HttpServletRequest request) {
		
		logger.debug("G/W EzAttitude [DELETE /rest/ezattitude/users/"+userId+"/approvalconn] started.");
		
		JSONObject result = new JSONObject();
		int status = 0;
		
		try{
			String type = request.getParameter("type");
			String docId = request.getParameter("docId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			status = ezAttitudeService.deleteApprovalGConnInfo(userId, type, docId, info.getCompanyId(), info.getTenantId());
			
			if (status == 1) {
				result.put("status", "ok");
			} else {
				result.put("status", "error");
			}
			result.put("code", 0);
			result.put("data", status);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", status);
		}
		logger.debug("G/W EzAttitude [DELETE /rest/ezattitude/users/"+userId+"/approvalconn] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 연차설정정보 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/annualreg", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeAnnualConfigInfo(@PathVariable String companyId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/annualreg] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			//근태규율설정정보
			Map<String, Object> attitudeAnnualConfigInfo = ezAttitudeService.getAttitudeAnnualConfig(info.getTenantId(), companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", attitudeAnnualConfigInfo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/annualreg] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 연차설정정보 수정
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/annualreg", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateAnnualConf(@PathVariable String companyId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/annualreg] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			
			String annualCancelRule = request.getParameter("annualCancelRule");
			String useAnnualAutoGnrt = request.getParameter("useAnnualAutoGnrt");
			String annualGnrtStd = request.getParameter("annualGnrtStd");
			String initialDate = request.getParameter("initialDate");
			String useMinusAnnual = request.getParameter("useMinusAnnual");
			String useAnnualTmnt = request.getParameter("useAnnualTmnt");
			String roundOffRule = request.getParameter("roundOffRule");
			
			String confSetDate =  commonUtil.getTodayUTCTime("yyyy-MM-dd");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("companyId", companyId);
			map.put("tenantId", info.getTenantId());
			map.put("annualCancelRule", annualCancelRule);
			map.put("useAnnualAutoGnrt", useAnnualAutoGnrt);
			map.put("annualGnrtStd", annualGnrtStd);
			map.put("initialDate", initialDate);
			map.put("useMinusAnnual", useMinusAnnual);
			map.put("useAnnualTmnt", useAnnualTmnt);
			map.put("roundOffRule", roundOffRule);
			map.put("confSetDate", confSetDate);
			
			ezAttitudeService.updateAnnualConfig(map);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/annualreg] ended.");
		
		return result;
	}
	

/**
	 * G/W 근태관리 [GET] 연차설정정보 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/joindate", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getJoinDate(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/joindate] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String companyId = request.getParameter("companyId");
			String joinDate = "";
			
			//근태규율설정정보
			Map<String, Object> map = ezAttitudeService.getJoinDate(info.getTenantId(), companyId, userId);
			if(map == null) {
				joinDate = "0000-01-01";
			} else {
				joinDate = (String) map.get("joinDate");
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", joinDate);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/" + userId + "/joindate] ended.");
		
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태 상세조회 (연차수정(취소)신청)
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/{attitudeId}/aprinfo", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeAprInfo(@PathVariable String attitudeId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/" + attitudeId + "/aprinfo] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<Map<String, Object>> list = ezAttitudeService.getAttitudeAprInfo(attitudeId, info.getPrimary(), info.getTenantId(), info.getCompanyId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", list);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		logger.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/" + attitudeId + "/aprinfo] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 전자결재 연동 (미니캘린더 해당 달의 휴일 + 근태가 잇는날 가져옴)
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/approvalconn/disableddays", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getDisabledDays(@PathVariable String userId, HttpServletRequest request) {
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/approvalconn/disableddays] started.");
		JSONObject result = new JSONObject();
		
		try{
			String year = request.getParameter("year");
			String month = request.getParameter("month") == null ? "" : request.getParameter("month");
			String startDate = request.getParameter("startDate") == null ? "" : request.getParameter("startDate");
			String endDate = request.getParameter("endDate") == null ? "" : request.getParameter("endDate");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<String> list = ezAttitudeService.getDisabledDays(info.getPrimary(), info.getOffSet(), year, month, startDate, endDate, userId, info.getCompanyId(), info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", list);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
			
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/approvalconn/disableddays] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 국가,회사,근태 휴무일
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId:.+}/holidays", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getHoliDays(@PathVariable String userId, HttpServletRequest request) {
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/holidays] started.");
		JSONObject result = new JSONObject();
		
		try{
			String year = request.getParameter("year")== null ? "" : request.getParameter("year");
			String month = request.getParameter("month") == null ? "" : request.getParameter("month");
			String startDate = request.getParameter("startDate") == null ? "" : request.getParameter("startDate");
			String endDate = request.getParameter("endDate") == null ? "" : request.getParameter("endDate");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<String> list = ezAttitudeService.getHoliDays(info.getPrimary(), info.getOffSet(), year, month, startDate, endDate, userId, info.getCompanyId(), info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", list);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("G/W EzAttitude [GET /rest/ezattitude/users/"+userId+"/holidays] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 근태입력관리 스케줄러동작
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/daliyWork", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject setDailyWork() {
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/daliyWork] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			ezAttitudeService.autoSetDailyWork();
			result.put("status", "success");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
		}
		
		logger.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/daliyWork] ended.");
		return result;
	}
}