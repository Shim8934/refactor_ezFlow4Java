package egovframework.ezMobile.ezOption.web;

import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.sim.service.EgovFileScrty;

@RestController
public class MOptionGWController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(MOptionGWController.class);

	@Autowired
	private Properties config;

	@Resource(name = "loginService")
	private LoginService loginService;

	@Resource(name = "crypto")
	private EgovFileScrty egovFileScrty;

	@Resource(name = "MOptionService")
	private MOptionService mOptionService;

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Resource(name = "EzNewPortalService")
	private EzNewPortalService ezNewPortalService;
	/**
	 * 모바일 G/W 환경설정 [get] 환경설정조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezoption/option/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject optionDetail(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W OPTION [GET /mobile/ezoption/option/users/{userId}] started.");

		JSONObject result = new JSONObject();

		try {

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			MOptionVO opt = mOptionService.optionInfo(userId, tenantId);

			if (opt == null) {
				result.put("status", "ok");
				result.put("code", 1);
				result.put("data", "");
			} else {
				if (StringUtils.isEmpty(opt.getUsePrimaryLangOnly())) {
					String usePrimaryLangOnly = config.getProperty("config.UsePrimaryLangOnly");
					opt.setUsePrimaryLangOnly(usePrimaryLangOnly);
				}

				String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", info.getTenantId());
				String deviceId = (request.getParameter("deviceID") == null) ? "" : request.getParameter("deviceID");

				if (dotNetIntegration.equalsIgnoreCase("NO") && !deviceId.equals("")) {

					String strJson = mOptionService.getDevicePinfInfo(deviceId, userId);

					JSONParser parser = new JSONParser();
					JSONObject pinInfo = (JSONObject) parser.parse(strJson);
					JSONObject data = (JSONObject) pinInfo.get("data");

					String biometric = (data.get("biometric") == null) ? "N" : data.get("biometric").toString();
					String pin = (data.get("pin") == null) ? "" : data.get("pin").toString();
					String pinState = (data.get("pinState") == null) ? "N" : data.get("pinState").toString();

					opt.setBiometric(biometric);
					opt.setPin(pin);
					opt.setPinState(pinState);

				}

				String obj = "";
				Gson gson = new Gson();
				obj = gson.toJson(opt);

				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", obj);
			}

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");

		}
		logger.debug("MOBILE G/W OPTION [GET /mobile/ezoption/option/users/{userId}] ended.");

		return result;
	}

	/**
	 * 모바일 G/W 환경설정 [post] 환경설정 생성
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezoption/option/users/{userId:.+}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject optionCreate(@PathVariable String userId, @RequestBody JSONObject jsonObject,
			HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W OPTION [POST /mobile/ezoption/option/users/{userId}] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);

			int tenantId = info.getTenantId();

			logger.debug("timeZone : " + jsonObject.get("timeZone").toString() + ", lang : "
					+ jsonObject.get("lang").toString() + ", mainType : " + jsonObject.get("mainType").toString()
					+ ", listCnt : " + jsonObject.get("listCnt").toString() + ", useSecurity : "
					+ jsonObject.get("useSecurity").toString());

			mOptionService.insertOption(userId, jsonObject.get("timeZone").toString(),
					jsonObject.get("lang").toString(), jsonObject.get("mainType").toString(),
					jsonObject.get("listCnt").toString(), jsonObject.get("useSecurity").toString(), tenantId);

			MOptionVO opt = mOptionService.optionInfo(userId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", opt);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		logger.debug("MOBILE G/W OPTION [POST /mobile/ezoption/option/users/{userId}] ended.");

		return result;
	}

	/**
	 * 모바일 G/W 환경설정 [put] 환경설정수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezoption/option/users/{userId:.+}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject optionUpdate(@PathVariable String userId, @RequestBody JSONObject jsonObject,
			HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W OPTION [PUT /mobile/ezoption/option/users/{userId}] started.");

		JSONObject result = new JSONObject();

		try {
			// 1. 변수
			// 환경설정
			//String timeZone = jsonObject.get("timeZone").toString();
			String timeZone = jsonObject.get("timeZone") == null ? "" : jsonObject.get("timeZone").toString().trim();
			String lang = jsonObject.get("lang").toString();
			String mainType = jsonObject.get("mainType").toString();
			String listCnt = jsonObject.get("listCnt").toString();
			String useSecurity = "";
			if (jsonObject.get("useSecurity") != null){
				useSecurity = jsonObject.get("useSecurity").toString();
			}

			// 사용자 정보
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();

			// pin, 생체 암호
			String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", tenantId);
			String pin = "", pinState = "", biometric = "";
			if ("NO".equalsIgnoreCase(dotNetIntegration)) {
				pin = jsonObject.get("pin").toString();
				pinState = jsonObject.get("pinState").toString();
				biometric = jsonObject.get("biometric").toString();
				
				// 20210426 조진호 - pin번호 SHA-256으로 암호화 하여 저장
				PrivateKey pk = EgovFileScrty.getPrivateKey(egovFileScrty.getPrm(), egovFileScrty.getPre());
				pin = EgovFileScrty.decryptRsa(pk, pin);
				if (!"".equals(pin)) {
					pin = EgovFileScrty.encryptPassword(pin, userId);
				}
			}

			String deviceId = (request.getParameter("deviceID") == null) ? "" : request.getParameter("deviceID");
			String pinChange = jsonObject.get("pinChange").toString();

			logger.debug("userId : {}, timeZone : {}, lang : {}, mainType : {}, listCnt : {}, useSecurity : {}, tenantId : {}"
					+ ", deviceId : {}, pinState : {}, pin : {}, biometric : {}, pinChange : {}"
					, userId, timeZone, lang, mainType, listCnt, useSecurity, tenantId
					, deviceId, pinState, pin, biometric, pinChange);

			// 2024-08-09 황인경 - 모바일 환경설정 포틀릿 개인 설정 수정
			Object portletVO = new JSONObject();
			portletVO = jsonObject.get("portletVO");
			JSONArray jsonArray = new JSONArray();
			
			int themeId = 4; // 모바일 테마

			if (portletVO instanceof ArrayList) {
				ArrayList<LinkedHashMap<String, Object>> portletJsonList = (ArrayList<LinkedHashMap<String, Object>>) portletVO;

				for (LinkedHashMap<String, Object> map : portletJsonList) {
					JSONObject portletObj = new JSONObject(map);
					jsonArray.add(portletObj);
				}

				String companyID = info.getCompanyId();

				ezNewPortalService.updatePortletOrderUser(userId, companyID, tenantId, jsonArray, info.getLang(), themeId);

				JSONObject portletJObj = new JSONObject();
				portletJObj.put("frameId", 9);
				portletJObj.put("themeId", "4");
				portletJObj.put("portletList", null);
				jsonObject.put("param", portletJObj);

				ezNewPortalService.updateUserUsedFrame(userId, tenantId, companyID, jsonObject);

			}

			// 2. 수행
			mOptionService.updateOption(userId, timeZone, lang, mainType, listCnt, useSecurity, tenantId
					, deviceId, pinState, pin, biometric, pinChange);

			MOptionVO opt = mOptionService.optionInfo(userId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", opt);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");

		}
		logger.debug("MOBILE G/W OPTION [PUT /mobile/ezoption/option/users/{userId}] ended.");

		return result;
	}

	// 2024-08-09 황인경 - 모바일 환경설정 포틀릿 개인 설정 조회
	@RequestMapping(value = "/mobile/ezOption/portlet/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getOptionPortletList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("MOBILE G/W getOptionPortletList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = request.getParameter("companyId");
			String deptId = info.getDeptId();
			String portletLang = info.getLang();

			JSONObject data = new JSONObject();

			int themeId = 4;

			List<PortletInfoVO> portletList = ezNewPortalService.getUserPortletList(themeId, portletLang, userId, tenantId, companyId, deptId, true);

			data.put("portletList", portletList);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("MOBILE G/W getOptionPortletList ended.");
		return result;
	}
}
