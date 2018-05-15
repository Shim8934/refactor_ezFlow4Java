package egovframework.ezEKP.ezAttitude.web;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.awt.image.PixelGrabber;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Base64;
import java.util.Base64.Decoder;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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
import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO;
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
			if (deptFlag.equals("false")) {
				resultList = ezAttitudeService.getAttitudeList(userId, "", "", typeId, startDate, endDate, offset, info.getTenantId(), deptFlag);
			} else {
				// 관리하고 있는 전체 부서 목록을 받아서 dept in iterate를 돌린다.
				resultList = ezAttitudeService.getAttitudeList("", selectedDeptID, "", typeId, startDate, endDate, offset, info.getTenantId(), deptFlag);
			}
			
			//imgPath 셋팅
//			for (int i = 0; i < resultList.size(); i++) {
//				String imgPath = resultList.get(i).getImgPath();
//				if (imgPath != null && !imgPath.equals("")) {
//					imgPath = "/ezCommon/downloadAttach.do?filePath=" + commonUtil.getUploadPath("upload_attitude.ROOT", info.getTenantId()) + commonUtil.separator + info.getCompanyId() + commonUtil.separator + "uploadIconFile" + commonUtil.separator + imgPath;
//					resultList.get(i).setImgPath(imgPath);
//				}
//			}
	         
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
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			LOGGER.debug(startDate + "관리자 근태등록 기록@#$@(%!#*(%!#*$^%#(!$^(#$^(!#(%(#@!%(#!(%!@(%!(%");
			ezAttitudeService.insertAttitude(userId, info.getDeptId(), startDate, endDate, region, mobile, bizSub, content, "0", typeId, dateType, info.getOffSet(), info.getCompanyId(), info.getTenantId(), mode);
			
			if (mode.equals("admin")) {
				//관리자 근태등록 기록.
				LOGGER.debug(adminId + "관리자 근태등록 기록@#$@(%!#*(%!#*$^%#(!$^(#$^(!#(%(#@!%(#!(%!@(%!(%");
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/users/" + userId + "/attitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 유형별 근태 조회
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
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			AttitudeVO attitudeVO = ezAttitudeService.getAttitudeInfo(attitudeId, info.getOffSet(), info.getTenantId());
			
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
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			AttitudeVO attitudeVO = ezAttitudeService.getAttitudeInfo(attitudeId, info.getOffSet(), info.getTenantId());
			
			String originUserId = attitudeVO.getWriterId();
			String originTypeId = attitudeVO.getTypeId();
			String originStartDate = attitudeVO.getStartDate();
			String originEndDate = attitudeVO.getEndDate();
			String originRegion = attitudeVO.getRegion();
			String originMobile = attitudeVO.getMobile();
			String originBizSub = attitudeVO.getBizSub();
			String originContent = attitudeVO.getContent();
			String originDateType = attitudeVO.getDateType();
			
			ezAttitudeService.updateAttitude(attitudeId, startDate, endDate, region, mobile, bizSub, content, info.getOffSet(), "", typeId, dateType, info.getTenantId());
			
			//관리자에서 수정 했을 경우 테이블에 기록을 남긴다.
			if (mode.equals("admin")) {
				//userId 수정한 사람 아이디
				LOGGER.debug(userId + "관리자에서 수정 했을 경우 테이블에 기록을 남긴다$%*!#$%*!#$*%!*&#@%*!#$%*!#@$%*!*$%!*%*!*%*!@#%*");
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			e.printStackTrace();
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
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ezAttitudeService.deleteAttitude(attitudeId, info.getTenantId());
			
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
		
		try {
	         String userId = request.getParameter("userId");
	         String serverName = request.getHeader("x-user-host");
	         MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
	         
	         LOGGER.debug("userId : " + userId);
	         String companyId = request.getParameter("companyId");
	         
	         if (companyId ==null||companyId.equals("")) {
	            companyId = info.getCompanyId();
	         }
	         List<DeptViewVO> deptList = ezAttitudeService.getDeptViewList(userId, companyId, info.getTenantId() + "");
	         
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
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			List<AttitudeAuthorVO> userList = ezAttitudeService.getDeptUserList(info.getTenantId() + "", key, value);
			
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
	public JSONObject updateAttitudeConf(@PathVariable String companyId, @RequestBody JSONObject jsonParam, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudereg] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			//테넌트아이디
			jsonParam.put("tenantId", info.getTenantId());
			
			//오늘일자로 근태규율 설정일자
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
			String isAdmin = request.getParameter("isAdmin");
			String statistics = request.getParameter("statistics");
			
			List<AttitudeTypeVO> attitudeTypeList = ezAttitudeService.getAttitudeTypeList(companyId, isuse, isAdmin, statistics, info.getTenantId());
			
//			//imgPath 셋팅
//			for (AttitudeTypeVO typeInfo : attitudeTypeList) {
//				String imgPath = typeInfo.getImgPath();
//				if (!imgPath.equals("")) {
//					imgPath = "/ezCommon/downloadAttach.do?filePath=" + commonUtil.getUploadPath("upload_attitude.ROOT", info.getTenantId()) + commonUtil.separator + companyId + commonUtil.separator + "uploadIconFile" + commonUtil.separator + imgPath;
//					typeInfo.setImgPath(imgPath);
//				}
//			}
			
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
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ezAttitudeService.updateAttitudeTypeConfig(request.getParameter("typeConfigList"), companyId, info.getTenantId());
			
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
	 * G/W 근태관리 [GET] 근태유형 추가팝업에 필요한 데이터 조회
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes/info", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getSaveAttitudeTypePopupInfo(@PathVariable String companyId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/companies/{companyId}/attitudetypes/info] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			//typeId 구하기
			String MaxTypeId = ezAttitudeService.getAttitudeTypeMaxTypeId(companyId, info.getTenantId());
			String typeId = "";
			if (MaxTypeId.length() == 1) {
				typeId = "A0" + MaxTypeId;
			} else {
				typeId = "A" + MaxTypeId;
			}
			
			data.put("typeId", typeId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/companies/{companyId}/attitudetypes/info] ended.");
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
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			String typeId = request.getParameter("typeId");
			String typeName = request.getParameter("typeName");
			String typeName2 = request.getParameter("typeName2");
			
			ezAttitudeService.insertAttitudeType(typeId, typeName, typeName2, info.getTenantId(), companyId);
			
			result.put("status", "ok");
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
			//imgPath 셋팅
//			String imgPath = typeInfo.getImgPath();
//			if (!imgPath.equals("")) {
//				imgPath = "/ezCommon/downloadAttach.do?filePath=" + commonUtil.getUploadPath("upload_attitude.ROOT", info.getTenantId()) + commonUtil.separator + companyId + commonUtil.separator + "uploadIconFile" + commonUtil.separator + imgPath;
//				typeInfo.setImgPath(imgPath);
//			} else {
//				typeInfo.setImgPath("/images/default_pic.jpg");
//			}
			
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
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String typeId = request.getParameter("typeId");
			String typeName = request.getParameter("typeName");
			String typeName2 = request.getParameter("typeName2");
			
			ezAttitudeService.updateAttitudeType(typeId, typeName, typeName2, info.getTenantId(), companyId);
			
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
	 * G/W 근태관리 [PUT] 근태유형 삭제
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes/{attitudetypeId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteAttitudeType(@PathVariable String companyId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId+ "] started.");
		
		JSONObject result = new JSONObject();
		String isUse = "";
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String typeId = request.getParameter("typeId");
			
			//사용하고 있는지 확인
			int useCount = ezAttitudeService.checkUseAttitudeType(typeId, info.getTenantId(), companyId);
			//삭제
			if (useCount == 0) {
				isUse = "true";
				ezAttitudeService.deleteAttitudeType(typeId, info.getTenantId(), companyId);
			} else {
				isUse = "false";
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", isUse);
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
			List<AttitudeUserConfigVO> list = ezAttitudeService.getAttitudeUserConfigList(tenantId, companyId, searchUserName, searchDeptName, searchTitle, searchStartTime, searchEndTime, searchGubun, pageNum, listSize, orderCell, orderOption, offsetMin);
			
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
			@RequestParam(value="sysLang", required=false) String sysLang,
			@RequestParam(value="offset", required=false) String offset,
			@RequestParam(value="startPoint", required=false) String startPoint,
			@RequestParam(value="endPoint", required=false) String endPoint,
			@RequestParam(value="type", required=false) String type,
			@RequestParam(value="orderCell", required=false) String orderCell,
			@RequestParam(value="orderOption", required=false) String orderOption,
			@RequestParam(value="adminFlag", required=false) String adminFlag,
			@RequestParam(value="checkAdmin", required=false) String checkAdmin,
			@RequestParam(value="deptid", required=false) String deptid) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/{userId}/modifyattitudes] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		JSONObject attJson = new JSONObject();
		String[] deptIdList;

		try{
			
			String order = orderCell + " " + orderOption;
			String isAllDept = "";
			

			if (adminFlag == null) {
				adminFlag = "false";
			}
			
			if (checkAdmin == null) {
				checkAdmin = "false";
			}
			
			if (adminFlag.equals("true") || checkAdmin.equals("true")){
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
			
			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList(tenantId, companyId, userId, isAllDept);

			deptIdList = new String[authDeptlist.size()];
			
			for (int i = 0; i < authDeptlist.size(); i++) {
				deptIdList[i] = authDeptlist.get(i).getDeptId();
			}
			
			if (deptid != null) {
				deptIdList = new String[1];
				deptIdList[0] = deptid;
			}
			
			List<AttitudeApplicationVO> attList = ezAttitudeService.getUsersModiyAtt(companyId, tenantId, userId, startDate, endDate, apprUserName, writerName, writerDeptName, sysLang, offset, startPoint, endPoint, type, order, adminFlag, checkAdmin, deptIdList);
			for (int i = 0 ; i < attList.size(); i++ ) {
				LOGGER.debug(attList.get(i).toString());
			}
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
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/{userId}/modifyattitudes] ended.");
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
			@RequestParam(value="sysLang", required=false) String sysLang,
			@RequestParam(value="offset", required=false) String offset,
			@RequestParam(value="type", required=false) String type,
			@RequestParam(value="adminFlag", required=false) String adminFlag,
			@RequestParam(value="checkAdmin", required=false) String checkAdmin,
			@RequestParam(value="deptid", required=false) String deptid) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/{userId}/modifyattitudes/count] started.");

		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		JSONObject attJson = new JSONObject();
		String[] deptIdList;
		try{
			
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
			String isAllDept = "";
			
			if (adminFlag.equals("true") || checkAdmin.equals("true")){
				isAllDept = "Y";
			}
			
			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList(tenantId, companyId, userId, isAllDept);
			
			deptIdList = new String[authDeptlist.size()];
			
			for (int i = 0; i < authDeptlist.size(); i++) {
				deptIdList[i] = authDeptlist.get(i).getDeptId();
			}
			
			if (deptid != null) {
				deptIdList = new String[1];
				deptIdList[0] = deptid;
			}
			
			int attListCount = ezAttitudeService.getUsersModiyAttCount(companyId, tenantId, userId, startDate, endDate, apprUserName, writerName, writerDeptName, sysLang, offset, type, deptIdList, adminFlag, checkAdmin);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", attListCount+"");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/{userId}/modifyattitudes/count] ended.");
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
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			List<HolidayVO> holidayList = ezAttitudeService.getHolidayList("", companyId, tenantId);
			
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
			
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/users/{userId}/modifyattitudes] started.");
		
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

			LOGGER.debug("companyId : " + companyId + ", tenantId : " + tenantId + ", idList : " + idList);
			
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
		LOGGER.debug("G/W EzAttitude [DELETE /rest/ezattitude/users/{userId}/modifyattitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [DELETE] 수정신청 승인,반려
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{userId}/modifyattitudes", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject changeUsersModiyAtt(@PathVariable String userId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="idList", required=true) String idList,
			@RequestParam(value="changeStatus", required=true) String changeStatus) {
			
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/users/{userId}/modifyattitudes] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		JSONObject attJson = new JSONObject();
		
		try{
			String[] ids = idList.split(",");

			LOGGER.debug("companyId : " + companyId + ", tenantId : " + tenantId 
					+ ", idList : " + idList + ", changeStatus : " + changeStatus);
			
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
		LOGGER.debug("G/W EzAttitude [PUT /rest/ezattitude/users/{userId}/modifyattitudes] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 작성양식
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudetypes/{attitudetypeId}/forms/form", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFormBody(@PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudetypes/{attitudetypeId}/forms/form] started.");
		
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
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudetypes/{attitudetypeId}/forms/form] ended.");
		
		return result;
	}
	
	@RequestMapping(value = "/rest/ezattitude/modifyattitude/{attModId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject attModAppDetail(
			@PathVariable String attModId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="userId", required=true) String userId,
			@RequestParam(value="offset", required=true) String offset,
			@RequestParam(value="applCnt", required=false) String applCnt) throws Exception{
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/modifyattitude/{attModId}] started.");
		JSONObject result = new JSONObject();
		try {
			AttitudeApplicationVO data = ezAttitudeService.attModAppDetail(companyId, tenantId, userId, attModId, offset, applCnt);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/modifyattitude/{attModId}] ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezattitude/modifyattitude/{attModId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject attModAppModify(
			@PathVariable String attModId, HttpServletRequest request,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) int tenantId,
			@RequestParam(value="userId", required=true) String userId,
			@RequestParam(value="offset", required=true) String offset,
			@RequestParam(value="content", required=true) String content,
			@RequestParam(value="changeDate", required=true) String changeDate) throws Exception{
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/modifyattitude/{attModId}] started.");
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
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/modifyattitude/{attModId}] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태조회 --임시
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes/bombom", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject attitudeMainList2(HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/bombom] started.");
		
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
			String searchAttitudeType = request.getParameter("searchAttitudeType");
			String pageNum = request.getParameter("pageNum");
			String listSize = request.getParameter("listSize");
			String orderCell = request.getParameter("orderCell");
			String orderOption = request.getParameter("orderOption");
			String offsetMin = request.getParameter("offsetMin");
			String isAdmin = request.getParameter("isAdmin");
			String statistics = request.getParameter("statistics");
			String isuse = "1";
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantID = info.getTenantId();
			String offset = info.getOffSet();
			
			String totalCount = ezAttitudeService.getAttitudeCount2(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, searchAttitudeType, offset, companyId, tenantID, searchDeptId);
			List<AdminAttitudeVO> list = ezAttitudeService.getAttitudeList2(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, searchAttitudeType, orderCell, orderOption, offset, pageNum, listSize, companyId, tenantID, searchDeptId);
			
			//구분 리스트
			List<AttitudeTypeVO> typeList = ezAttitudeService.getAttitudeTypeList(companyId, isuse, isAdmin, statistics, info.getTenantId());
			
			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("totalCount", totalCount);
			data.put("typeList", typeList);
			data.put("typeId", searchAttitudeType);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/bombom] ended.");
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
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			JSONObject data = ezAttitudeService.getAttitudeAbsentedList(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, searchDeptId, pageNum, listSize, orderCell, orderOption, duplicated, info.getLang(), info.getOffSet(), companyId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes/absent] ended.");
		
		return result;
	}
	
	/**
	 * 근태관리 미입력자 메일발송
	 */
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
			String loginCookie = request.getParameter("loginCookie");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantID = info.getTenantId();
			String userLang = info.getLang();
			String offset = info.getOffSet();
			
			JSONObject duplicatedData = ezAttitudeService.getAttitudeAbsentedList(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, searchDeptId, "", "", "", "", "", userLang, offset, companyId, tenantID);
			JSONObject distinctData = ezAttitudeService.getAttitudeAbsentedList(searchUserName, searchDeptName, searchTitle, searchStartDate, searchEndDate, searchDeptId, "", "", "", "", "distinct", userLang, offset, companyId, tenantID);
			
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
			List<AttitudeApplicationVO> data = ezAttitudeService.attModGetHistory(companyId, tenantId, userId, attModId, offset);
			
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
			
			List<AttitudeAuthorVO> authorlist = ezAttitudeService.getAttitudeAuthList(info.getTenantId(), companyId);
			
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
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitude-auth] started.");
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
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitude-auth] ended.");
		return result;
	}
	
	/**
	 * G/W 근태관리 [GET] 근태권한자 상세 조회(권한있는 부서 체크)
	 * @param companyId
	 * @param request
	 * @return
	 * @throws Exception
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
		
			List<AttitudeAuthorVO> authDeptlist = ezAttitudeService.getAttitudeAuthDeptList(info.getTenantId(), companyId, userId, isAllDept);
			
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
	 * G/W 통계 [GET] 개인 근태 유형별 통계 -----임시
	 */
	@RequestMapping(value = "/rest/ezattitude/users/{selectUserId}/attitudetypes/{attitudetypeId}/attitude-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeUserCount(@PathVariable String selectUserId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/{userId}/attitudetypes/{attitudetypeId}/attitude-count] started.");
		
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
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/{userId}/attitudetypes/{attitudetypeId}/attitude-count] ended.");
		return result;
	}
	
	/**
	 * G/W 통계 [GET] 부서 근태 유형별 통계 -----임시
	 */
	@RequestMapping(value = "/rest/ezattitude/depts/{deptId}/attitudetypes/{attitudetypeId}/attitude-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeDeptCount(@PathVariable String deptId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/depts/"+deptId+"/attitudetypes/{attitudetypeId}/attitude-count] started.");
		
		JSONObject result = new JSONObject();
		try{
			String serverName = request.getHeader("x-user-host");
			String offset = request.getParameter("offset");
			String year = request.getParameter("year");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			userId = "";
			
			List<AttitudeStatisVO> resultList = ezAttitudeService.getAttitudeUserStatistics(userId, deptId, offset, year, attitudetypeId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resultList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/depts/"+deptId+"/attitudetypes/{attitudetypeId}/attitude-count] ended.");
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
}