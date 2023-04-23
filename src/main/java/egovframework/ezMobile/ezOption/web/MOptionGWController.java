package egovframework.ezMobile.ezOption.web;

import java.security.PrivateKey;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
				if (opt.getUsePrimaryLangOnly() == null || opt.getUsePrimaryLangOnly().toString() == "") {
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
			e.printStackTrace();
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
			e.printStackTrace();
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

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);

			int tenantId = info.getTenantId();

			
			String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", tenantId);
			String pin = "", pinState = "", biometric = "";
			if (dotNetIntegration.equalsIgnoreCase("NO")) {
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

			logger.debug("timeZone : " + jsonObject.get("timeZone").toString() + ", lang : "
					+ jsonObject.get("lang").toString() + ", mainType : " + jsonObject.get("mainType").toString()
					+ ", listCnt : " + jsonObject.get("listCnt").toString() + ", useSecurity : "
					+ jsonObject.get("useSecurity").toString() + ", deviceId : " + deviceId
					+ ", pinState : " + pinState + ", biometric : " + biometric + ", pin : " + pin);

			mOptionService.updateOption(userId, jsonObject.get("timeZone").toString(),
					jsonObject.get("lang").toString(), jsonObject.get("mainType").toString(),
					jsonObject.get("listCnt").toString(), jsonObject.get("useSecurity").toString(), 
					tenantId, deviceId, pinState, pin, biometric);

			MOptionVO opt = mOptionService.optionInfo(userId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", opt);

		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");

		}
		logger.debug("MOBILE G/W OPTION [PUT /mobile/ezoption/option/users/{userId}] ended.");

		return result;
	}

}
