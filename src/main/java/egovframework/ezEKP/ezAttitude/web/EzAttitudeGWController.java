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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezAttitude.vo.AttitudeApplicationVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeDeptVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeFormVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeVO;
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
	 * G/W 근태관리 [GET] 개인, 부서, 부서+개인 근태현황조회
	 */
	@RequestMapping(value = "/rest/ezattitude/attitudes", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	 public JSONObject attitudeMainList(HttpServletRequest request) {
		
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/attitudes] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String typeId = request.getParameter("typeId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			String UTCDate = commonUtil.getTodayUTCTime("");
			String offset = info.getOffSet();
			
			List<AttitudeVO> resultList = ezAttitudeService.getAttitudeList(userId, "", typeId, UTCDate, offset, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultList);
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
			String serverName = request.getHeader("x-user-host");
			String typeId = request.getParameter("typeId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String region = request.getParameter("region");
			String mobile = request.getParameter("mobile");
			String bizSub = request.getParameter("bizSub");
			String content = request.getParameter("content");
			String dateType = request.getParameter("dateType");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ezAttitudeService.insertAttitude(userId, info.getDeptId(), startDate, endDate, region, mobile, bizSub, content, "0", typeId, dateType, info.getCompanyId(), info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
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
			
			List<AttitudeTypeVO> attitudeTypeList = ezAttitudeService.getAttitudeTypeList(companyId, isuse, info.getTenantId());
			
			//imgPath 셋팅
			for (AttitudeTypeVO typeInfo : attitudeTypeList) {
				String imgPath = typeInfo.getImgPath();
				if (!imgPath.equals("")) {
					imgPath = "/ezCommon/downloadAttach.do?filePath=" + commonUtil.getUploadPath("upload_attitude.ROOT", info.getTenantId()) + commonUtil.separator + companyId + commonUtil.separator + "uploadIconFile" + commonUtil.separator + imgPath;
					typeInfo.setImgPath(imgPath);
				}
			}
			
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
			//formList 구하기
			List<AttitudeFormVO> formList = ezAttitudeService.getAttitudeFormList(info.getTenantId());
			
			data.put("typeId", typeId);
			data.put("formList", formList);
			
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
	 * G/W 근태관리 [GET] 근태유형 상세보기
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes/{attitudetypeId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAttitudeTypeInfo(@PathVariable String companyId, @PathVariable String attitudetypeId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId + "] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			AttitudeTypeVO typeInfo = ezAttitudeService.getAttitudeTypeInfo(info.getTenantId(), companyId, attitudetypeId);
			//imgPath 셋팅
			String imgPath = typeInfo.getImgPath();
			if (!imgPath.equals("")) {
				imgPath = "/ezCommon/downloadAttach.do?filePath=" + commonUtil.getUploadPath("upload_attitude.ROOT", info.getTenantId()) + commonUtil.separator + companyId + commonUtil.separator + "uploadIconFile" + commonUtil.separator + imgPath;
				typeInfo.setImgPath(imgPath);
			} else {
				typeInfo.setImgPath("/images/default_pic.jpg");
			}

			//formList 구하기
			List<AttitudeFormVO> formList = ezAttitudeService.getAttitudeFormList(info.getTenantId());
			
			data.put("typeInfo", typeInfo);
			data.put("formList", formList);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
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
		//TODO
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			String typeId = request.getParameter("typeId");
			String typeName = request.getParameter("typeName");
			String typeName2 = request.getParameter("typeName2");
			String imgPath = request.getParameter("imgPath");
			
			ezAttitudeService.updateAttitudeType(typeId, typeName, typeName2, imgPath, info.getTenantId(), companyId);
			
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
			@RequestParam(value="sysLang", required=false) String sysLang,
			@RequestParam(value="offset", required=false) String offset,
			@RequestParam(value="startPoint", required=false) String startPoint,
			@RequestParam(value="endPoint", required=false) String endPoint) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/{userId}/modifyattitudes] started.");

		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		JSONObject attJson = new JSONObject();
		
		try{
			List<AttitudeApplicationVO> attList = ezAttitudeService.getUsersModiyAtt(companyId, tenantId, userId, startDate, endDate, apprUserName, sysLang, offset, startPoint, endPoint);
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
			@RequestParam(value="sysLang", required=false) String sysLang,
			@RequestParam(value="offset", required=false) String offset) {
		LOGGER.debug("G/W EzAttitude [GET /rest/ezattitude/users/{userId}/modifyattitudes/count] started.");

		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		JSONObject attJson = new JSONObject();
		
		try{
			int attListCount = ezAttitudeService.getUsersModiyAttCount(companyId, tenantId, userId, startDate, endDate, apprUserName, sysLang, offset);

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
	 * G/W 근태관리 [GET] 근태유형관리 아이콘 업로드
	 */
	@RequestMapping(value = "/rest/ezattitude/companies/{companyId}/attitudetypes/{typeId}/iconupload", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject iconUpload(@PathVariable String companyId, @PathVariable String typeId, @RequestBody JSONObject jsonObject, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/attitudetype/" + typeId + "/iconupload] started.");
		
		JSONObject result = new JSONObject();
		
		try{			
			JSONParser jp = new JSONParser();
			jsonObject = (JSONObject) jp.parse(jsonObject.toJSONString());
			
			JSONObject fileObject = new JSONObject();
			
			String userId = "";
			int maxSize = 0;
			
			if (jsonObject.get("fileObject") != null) {
				fileObject = (JSONObject) jsonObject.get("fileObject");
			}
			
			if (jsonObject.get("userID") != null) {
				userId = (String) jsonObject.get("userID");
			}
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			
			String fileName = "";
			String realPath = commonUtil.getRealPath(request);
			Long fileSize = (Long) fileObject.get("fileSize");
			String resultUpload = "";
			String fileLocation = "";
			String filePath = "";
			String filePath2 = "";
			String tempFilePath = "";
			
	        if (fileObject.get("originalFilename") != null && StringUtils.isNotBlank((String) fileObject.get("originalFilename"))) {
	            fileName = (String) fileObject.get("originalFilename");
	            
	            if (fileName.indexOf(".") != -1) {
	    			fileName = fileName.substring(fileName.lastIndexOf(".")+1);
	    		} else {
	    			fileName = "";
	    		}
	            fileName = typeId + "." + fileName;
	        }
	        
	        filePath = commonUtil.getUploadPath("upload_attitude.ROOT", info.getTenantId());// /files/upload_attitude
			if (!filePath.substring(filePath.length() - 1).equals(commonUtil.separator)) { 
				filePath = filePath + commonUtil.separator;
			}
			
			filePath = filePath + companyId + commonUtil.separator + "uploadIconFile";//  /files/upload_attitude/companyId/uploadIconFile
			filePath2 = "/ezCommon/downloadAttach.do?filePath=" + filePath + commonUtil.separator + fileName;
			
			tempFilePath = commonUtil.getUploadPath("upload_attitude.TEMPUPLOADICON", info.getTenantId());//  /files/upload_attitude/tempUploadIcon
			if (!tempFilePath.substring(tempFilePath.length() - 1).equals(commonUtil.separator)) { 
				tempFilePath = tempFilePath + commonUtil.separator;
			}
			
			tempFilePath = tempFilePath + companyId + commonUtil.separator + "uploadIconFile";//  /files/upload_attitude/tempUploadIcon/companyId/uploadIconFile
			
			File file = new File(realPath + filePath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			// file -> 임시저장할 폴더 생성.
			File tempFile = new File(realPath + tempFilePath);
			
			if (!tempFile.exists()) {
				tempFile.mkdirs();
			}
			          
            attitudeWriteUploadedFile((String) fileObject.get("bytes"), fileName, realPath + tempFilePath);
			
            File imageFile = new File(realPath + tempFilePath + commonUtil.separator + fileName); 
            
    		if (imageFile.exists()) {
    			BufferedImage bi = ImageIO.read(imageFile);	
    			//화질 개선 코드			
    			Image imgTarget = bi.getScaledInstance(119, 128, Image.SCALE_SMOOTH);
    			int pixels[] = new int[119 * 128]; 
    			PixelGrabber pg = new PixelGrabber(imgTarget, 0, 0, 119, 128, pixels, 0, 119); 
    			try {
    				pg.grabPixels(); // JEPG 포맷의 경우 오랜 시간이 걸린다.
    			} catch (InterruptedException e) {
    				throw new IOException(e.getMessage());
    			} 
    			BufferedImage destImg = new BufferedImage(119, 128, BufferedImage.TYPE_INT_RGB); 
    			destImg.setRGB(0, 0, 119, 128, pixels, 0, 119); 
    			//기존코드	
//    			BufferedImage bufferedImage = new BufferedImage(119, 128, bi.getType());
//    			bufferedImage.createGraphics().drawImage(bi, 0, 0, 119, 128, null);
    			
    			File iconImageFile = new File(realPath + filePath + commonUtil.separator + fileName);
    			if (iconImageFile.exists()) {
    				FileUtils.deleteQuietly(iconImageFile);
    			}
    			
    			ImageIO.write(destImg, "png", iconImageFile);
    			
    			if (imageFile.exists()) {
    				FileUtils.deleteQuietly(imageFile);
    			}
    		}
			
    		//filePath, filePath2만 가져가면 된다
    		JSONObject data = new JSONObject();
			data.put("filePath", filePath + commonUtil.separator + fileName);
			data.put("filePath2", filePath2);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		LOGGER.debug("G/W EzAttitude [POST /rest/ezattitude/companies/" + companyId + "/attitudetype/" + typeId + "/iconupload] ended.");
		return result;
	}
	
	/**
     * 첨부파일을 서버에 저장한다.
     *
     * @param file
     * @param newName
     * @param stordFilePath
     * @throws Exception
     */
    public void attitudeWriteUploadedFile(String bytearray, String newName, String stordFilePath) throws Exception {
    	
    	LOGGER.debug("attitudeWriteUploadedFile statarted");
    	
		InputStream stream = null;
		OutputStream bos = null;
		String stordFilePathReal = (stordFilePath==null?"":stordFilePath);
		
		try {
		    File cFile = new File(stordFilePathReal);
	
		    if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }
	
		    bos = new FileOutputStream(stordFilePathReal + File.separator + newName);
		    LOGGER.debug("###" + stordFilePathReal + File.separator + newName + "###");
		    int bytesRead = 0;
		    byte[] buffer = new byte[BUFF_SIZE];
		    Decoder decoder = Base64.getDecoder();

		    bos.write(decoder.decode(bytearray));

		} catch (FileNotFoundException fnfe) {
			LOGGER.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			LOGGER.debug("ioe: {}", ioe);
		} catch (Exception e) {
			LOGGER.debug("e: {}", e);
		} finally {
		    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
		LOGGER.debug("attitudeWriteUploadedFile ended");
    } 
	
}
