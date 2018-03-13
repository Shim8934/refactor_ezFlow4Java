package egovframework.ezEKP.ezAttitude.web;

import java.util.List;
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
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezAttitude.vo.AttitudeDeptVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@RestController
public class EzAttitudeGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="crypto")
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzAttitudeService")
	private EzAttitudeService ezAttitudeService;
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	/**
	 * G/W 근태관리 [GET] 개인, 부서, 부서+개인 근태현황조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeMainList(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes] started.");
		
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
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId + "/attitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 유형별 근태현황 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudetypes/{attitudetypeId}/attitudes", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeListType(@PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudetypes/" + attitudetypeId + "/attitudes] started.");
		
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
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudetypes/" + attitudetypeId + "/attitudes] ended.");
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
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
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
	@RequestMapping(value = "/rest/ezattitude/attitudes/{attitudeId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject updateAttitudeInfo(@PathVariable String attitudeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "] started.");
		
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
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/attitudes/" + attitudeId + "] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 수정신청 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/modify-applications", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject modifyApplicationList(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/modify-applications] started.");
		
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
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/modify-applications] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 수정신청 등록
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/{attitudeId}/modify-applications", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject modifyApplicationList(@PathVariable String attitudeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "/modify-applications] started.");
		
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
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/attitudes/" + attitudeId + "/modify-applications] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 수정신청 수정
	 */
	@RequestMapping(value = "/rest/ezattitude/modify-applications/{modapplId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updatemodifyApplication(@PathVariable String modapplId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/modify-applications/" + modapplId + "] started.");
		
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
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/modify-applications/" + modapplId + "] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 수정신청 상세보기
	 */
	@RequestMapping(value = "/rest/ezattitude/modify-applications/{modapplId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject modifyApplicationInfo(@PathVariable String modapplId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/modify-applications/" + modapplId + "] started.");
		
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
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/modify-applications/" + modapplId + "] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 수정신청 일괄처리
	 */
	@RequestMapping(value = "/rest/ezattitude/modify-applications", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateModifyApplicationBatch(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/modify-applications] started.");
		
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
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/modify-applications] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [DELETE] 수정신청 일괄처리
	 */
	@RequestMapping(value = "/rest/ezattitude/modify-applications", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteModifyApplicationBatch(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/modify-applications] started.");
		
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
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/modify-applications] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 조직도 회사, 부서조회
	 */
	@RequestMapping(value = "/rest/ezattitude/organtree/depts", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject organtreeDepts(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/organtree/depts] started.");
		
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
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/organtree/depts] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 부서의 사원들 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/organtree/depts/{deptId}/users", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject organtreeUsersOfDept(@PathVariable String deptId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/organtree/depts/" + deptId + "/users] started.");
		
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
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/organtree/depts/" + deptId + "/users] ended.");
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
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
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
			
			//근태규율설정정보
			AttitudeConfigVO attitudeConfigInfo = ezAttitudeService.getAttitudeConfig(info.getTenantId(), companyId);
			
			//시간 셋팅
			String startDate = commonUtil.getDateStringInUTC(attitudeConfigInfo.getConfSetDate() + " " + attitudeConfigInfo.getWorkStartTime(), info.getOffSet(), false);
			String endDate = commonUtil.getDateStringInUTC(attitudeConfigInfo.getConfSetDate() + " " + attitudeConfigInfo.getWorkEndTime(), info.getOffSet(), false);
			
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
	public JSONObject updateAttitudeConf(@PathVariable String companyId, @RequestBody JSONObject jsonParam, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudereg] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			//테넌트아이디
			jsonParam.put("tenantId", info.getTenantId());
			
			//오늘일자로 설정일자
			String confSetDate =  commonUtil.getTodayUTCTime("yyyy-MM-dd");
			jsonParam.put("confSetDate", confSetDate);
			
			//시간 셋팅
			if (jsonParam.get("workStartTime").toString().length() == 4) {
				jsonParam.put("workStartTime", "0" + jsonParam.get("workStartTime").toString());
			}
			if (jsonParam.get("workEndTime").toString().length() == 4) {
				jsonParam.put("workEndTime", "0" + jsonParam.get("workEndTime").toString());
			}
			String startDate = commonUtil.getDateStringInUTC(confSetDate + " " + jsonParam.get("workStartTime").toString(), info.getOffSet(), true);
			String endDate = commonUtil.getDateStringInUTC(confSetDate + " " + jsonParam.get("workEndTime").toString(), info.getOffSet(), true);
			
			int startIdx = startDate.indexOf(" ");
			int endIdx = endDate.indexOf(" ");
			
			jsonParam.put("workStartTime", startDate.substring(startIdx + 1));
			jsonParam.put("workEndTime", endDate.substring(endIdx + 1));
			
			ezAttitudeService.updateAttitudeConfig(jsonParam);
			
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
	 * G/W 근태관리 [GET] 근태유형 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attitudeTypeList(@PathVariable String companyId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudetypes] started.");

		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			List<AttitudeTypeVO> attitudeTypeList = ezAttitudeService.getAttitudeTypeList(companyId, info.getTenantId());
			
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
	public JSONObject attitudeTypeBatchStore(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/{companyId}/attitudetypes] started.");
		
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
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/{companyId}/attitudetypes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 근태유형 추가
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertAttitudeType(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/companies/{companyId}/attitudetypes] started.");
		
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
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/companies/{companyId}/attitudetypes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 근태유형 수정
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes/{attitudetypeId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateAttitudeType(@PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/{companyId}/attitudetypes/" + attitudetypeId+ "] started.");
		
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
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/{companyId}/attitudetypes/" + attitudetypeId+ "] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 회사리스트
	 */
	@RequestMapping(value = "/rest/ezattitude/companies", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject updateAttitudeType(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			List<AttitudeDeptVO> list = ezAttitudeService.getCompanyList(info.getPrimary(), info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", list);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 사용자별 근태설정 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/user-attitude-confs", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject userAttitudeConfList(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users-attitude-confs] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			String userId = request.getParameter("userId");
			String searchUserName = request.getParameter("searchUserName");
			String searchDeptName = request.getParameter("searchDeptName");
			String pageNum = request.getParameter("pageNum");
			String listSize = request.getParameter("listSize");
			String orderCell = request.getParameter("orderCell");
			String orderOption = request.getParameter("orderOption");
			String order = orderCell + " " + orderOption;
			LOGGER.debug("order : " + order);
			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			List<AttitudeUserConfigVO> list = ezAttitudeService.getAttitudeUserConfigList(info.getTenantId(), companyId, searchUserName, searchDeptName, pageNum, listSize, order);
			String totalCount = ezAttitudeService.getAttitudeUserConfigCount(info.getTenantId(), companyId, searchUserName, searchDeptName);
			
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
	 * G/W 근태관리 [POST] 사용자별 근태설정 등록
	 */
	@RequestMapping(value = "/rest/ezattitude/user-attitude-confs", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertUserAttitudeConf(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/users-attitude-confs] started.");
		
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
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/users-attitude-confs] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [PUT] 사용자별 근태설정 수정
	 */
	@RequestMapping(value = "/rest/ezattitude/user-attitude-confs/{user-attitude-confId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateUserAttitudeConf(@PathVariable String userAttitudeConfId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/users-attitude-confs/" + userAttitudeConfId + "] started.");
		
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
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/users-attitude-confs/" + userAttitudeConfId + "] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [POST] 관리자 권한 추가
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId}/add-authority", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject addAuthority(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId + "/add-authority] started.");
		
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
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/users" + userId + "/add-authority] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 엑셀다운로드
	 */
	@RequestMapping(value = "/rest/ezattitude/exceldown", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject exceldown(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/exceldown] started.");
		
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
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/exceldown] ended.");
		return result;
	}
}
