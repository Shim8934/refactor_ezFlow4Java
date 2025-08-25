package egovframework.ezMobile.ezAttitude.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.ResScheGetHolidayVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 근태관리 모바일
 * @author 솔루션2팀 김민성
 * @Modification Information
 *
 *    수정일			수정자		수정내용
 *    -----------	    --------		----------
 *    2020.04.17	김민성		신규작성
 *
 * @see
 */

@RestController
public class MAttitudeGWController extends EgovFileMngUtil {


	private static final Logger logger = LoggerFactory.getLogger(MAttitudeGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name="MResourceService")
	private MResourceService mResourceService;
	
	@Resource(name="EzAttitudeService")
	private EzAttitudeService ezAttitudeService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 모바일 근태관리 회사 휴일정보
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezattitude/companies/{companyId}/holidays", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getHolidayList(@PathVariable String companyId, HttpServletRequest request) throws Exception{
		logger.debug("G/W EzAttitude [GET /mobile/ezattitude/companies/" + companyId + "/holidays] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String userId = request.getParameter("userId");
			//isRest = all(휴일모두), rest(휴무일만)
			// String isRest = request.getParameter("isRest");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			// int tenantId = info.getTenantId();
			String cID = "VIEW";
			
			List<ResScheGetHolidayVO> holiday = mResourceService.getTholiday(cID.trim(), info.getCompanyId(), info.getTenantId());
			List<ResScheGetHolidayVO> memorialDay = mResourceService.getTholiday(cID.trim(), "ALL", info.getTenantId());
			
			//근태규율설정정보
			AttitudeConfigVO attitudeConfigInfo = ezAttitudeService.getAttitudeConfig(info.getTenantId(), companyId);
			
			//시간 셋팅
			String startDate = commonUtil.getDateStringInUTC(attitudeConfigInfo.getConfSetDate() + " " + attitudeConfigInfo.getWorkStartTime(), info.getOffSet(), false);
			String endDate = commonUtil.getDateStringInUTC(attitudeConfigInfo.getConfSetDate() + " " + attitudeConfigInfo.getWorkEndTime(), info.getOffSet(), false);
			
			int startIdx = startDate.indexOf(" ");
			int endIdx = endDate.indexOf(" ");
			
			attitudeConfigInfo.setWorkStartTime(startDate.substring(startIdx + 1));
			attitudeConfigInfo.setWorkEndTime(endDate.substring(endIdx + 1));
			
			Map<String, Object> resultMap = new HashMap<String, Object>();
			resultMap.put("holiday", holiday);
			resultMap.put("memorialDay", memorialDay);
			resultMap.put("attitudeConfig", attitudeConfigInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resultMap);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("G/W EzAttitude [GET /mobile/ezattitude/companies/" + companyId + "/holidays] ended.");
		return result;
	}

	/**
	 * G/W 근태관리 [GET] 당일 근태관리 중복체크
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezattitude/attitudes/checkIsAttitude", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCheckIsAttitude(HttpServletRequest request) {
		logger.debug("G/W EzAttitude [GET /mobile/ezattitude/attitudes/checkIsAttitude] started.");
		
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
		logger.debug("G/W EzAttitude [GET /mobile/ezattitude/attitudes/checkIsAttitude] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 근태등록
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezattitude/users/{userId:.+}/attitudes", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject registeAttitude(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("G/W EzAttitude [POST /mobile/ezattitude/users/" + userId + "/attitudes] started.");

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
			String attendType = request.getParameter("attendType");
			String latitude = request.getParameter("latitude");
			String longitude = request.getParameter("longitude");
			String checkAttitude = "";
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String offSet = info.getOffSet();
			String isOutCheck = "";//퇴근체크 여부
			
			/*if (adminId != null && !adminId.equals("")) { //관리자가 등록시 등록하는 사람의 offset이 필요함
				MCommonVO adminInfo = mOptionService.commonInfoWeb(serverName, adminId);
				offSet = adminInfo.getOffSet();
			}*/
			
			if (typeId.equals("A01") || typeId.equals("A02") || typeId.equals("A03") || typeId.equals("A08")) {
				if (typeId.equals("A03")) {
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
					AttitudeVO attVO = ezAttitudeService.getAttitudeInfo(checkAttitude, info.getOffSet(), info.getPrimary(), info.getCompanyId(), info.getTenantId());
					if (startDate == null || startDate.equals("")) {
						startDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), info.getOffSet(), false);						
					}
					ezAttitudeService.updateAttitude(checkAttitude, startDate, null, region, mobile, bizSub, content, info.getOffSet(), "", typeId, dateType, mode, attVO, userId, info, info, info.getTenantId(), info.getCompanyId(), latitude, longitude);
				} else {
					ezAttitudeService.insertAttitude(userId, info.getDeptId(), startDate, endDate, region, mobile, bizSub, content, "0", typeId, dateType, offSet, info.getCompanyId(), info.getTenantId(), mode, adminId, attendType, latitude, longitude);	
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
		logger.debug("G/W EzAttitude [POST /mobile/ezattitude/users/" + userId + "/attitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 모바일 근태관리 [GET] 개인, 부서, 부서+개인 근태조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezattitude/attitudes", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject attitudeMainList(HttpServletRequest request) {
		
		logger.debug("G/W EzAttitude [GET /mobile/ezattitude/attitudes] started.");
		
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
		logger.debug("G/W EzAttitude [GET /mobile/ezattitude/attitudes] ended.");
		return result;
	}

}
