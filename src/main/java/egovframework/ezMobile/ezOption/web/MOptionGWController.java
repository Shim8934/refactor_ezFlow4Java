package egovframework.ezMobile.ezOption.web;

import java.util.Map;
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

import com.google.gson.Gson;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@RestController
public class MOptionGWController extends EgovFileMngUtil{

private static final Logger LOGGER = LoggerFactory.getLogger(MOptionGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
    @Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	/**
	 * 모바일 G/W 환경설정 [get] 환경설정조회
	 */
	@RequestMapping(value="/mobile/ezoption/option/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject optionDetail(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W OPTION [GET /mobile/ezoption/option/users/{userId}] started.");

		JSONObject result = new JSONObject();

		try {
			
			String serverName = request.getHeader("x-user-host");
			//String serverName = "http://localhost:8080";
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			LOGGER.debug("userId: " + userId);
			LOGGER.debug("tenantId: " + tenantId);
			MOptionVO opt = mOptionService.optionInfo(userId, tenantId);
			
			LOGGER.debug("opt: " + opt.toString());
			
			String obj = "";
			
			Gson gson = new Gson();
			
			obj = gson.toJson(opt);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", obj);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("MOBILE G/W OPTION [GET /mobile/ezoption/option/users/{userId}] ended.");	
		
		return result;
	}
	
	/**
	 * 모바일 G/W 환경설정 [put] 환경설정수정
	 */
	@RequestMapping(value="/mobile/ezoption/option/users/{userId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject optionUpdate(@PathVariable String userId, @RequestBody JSONObject jsonObject, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W OPTION [PUT /mobile/ezoption/option/users/{userId}] started.");

		JSONObject result = new JSONObject();
		
		String test = (String) jsonObject.get("lang");
		
		LOGGER.debug("lang: " + test);

		try {
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			String timeZone = "235|+09:00";
			String lang = "1";
			String mainType = "P";
			String listCnt = "10";
			String useSearch = "Y";
			String useSecurity = "N";
			int tenantId = 0;
			
			if(jsonObject.containsKey("timeZone")){
				timeZone = jsonObject.get("timeZone").toString();
			}
			
			if(jsonObject.containsKey("lang")){
				lang = jsonObject.get("lang").toString();
			}
			
			if(jsonObject.containsKey("listCnt")){
				listCnt = jsonObject.get("listCnt").toString();
			}
			
			if(jsonObject.containsKey("useSearch")){
				useSearch = jsonObject.get("useSearch").toString();
			}
			
			if(jsonObject.containsKey("useSecurity")){
				useSecurity = jsonObject.get("useSecurity").toString();
			}

			if(jsonObject.containsKey("mainType")){
				mainType = jsonObject.get("mainType").toString();
			}
			
			tenantId = info.getTenantId();
			
			LOGGER.debug("userId: " + userId);
			LOGGER.debug("timeZone: " + timeZone);
			LOGGER.debug("lang: " + lang);
			LOGGER.debug("mainType: " + mainType);
			LOGGER.debug("listCnt: " + listCnt);
			LOGGER.debug("useSearch: " + useSearch);
			LOGGER.debug("useSecurity: " + useSecurity);
			LOGGER.debug("tenantId: " + tenantId);
			
			mOptionService.updateOption(userId, timeZone, lang, mainType, listCnt, useSearch, useSecurity, tenantId);
			
			MOptionVO opt = mOptionService.optionInfo(userId, tenantId);
			
	        String ip = ClientUtil.getClientIP(request);
	        
	        String acceptLanguage = request.getHeader("Accept-Language"); 
	        
	        String returnValue = "";
	        
	        String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
	        
		    if (acceptLanguage != null) {
		        returnValue = acceptLanguage.substring(0, 2);
		    //이유는 정확히 알 수 없지만 로그를 확인한 결과 윗 라인에서 acceptLanguage가 null인 경우가 발생하여 추가함.
		    } else {				        
		        returnValue = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
		    }
	        
		    StringBuilder cookieInfo = new StringBuilder();
		   
			cookieInfo.append("{\"uid\" : \"" + userId + "\", \"ip\" : \"" + ip + "\", \"locale\" : \"" + returnValue + "\", \"lang\" : \"" + lang + "\", \"timeZone\" : \"" + timeZone + "\", \"tenantId\" : " + tenantId);
			cookieInfo.append("\"mainType\" : \"" + mainType + "\", \"listCnt\" : \"" + listCnt + "\" }");
		    
			LOGGER.debug("opt: " + opt.toString());
			
			String obj = "";
			
			Gson gson = new Gson();
			
			obj = gson.toJson(opt);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", cookieInfo.toString());
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}
		LOGGER.debug("MOBILE G/W OPTION [PUT /mobile/ezoption/option/users/{userId}] ended.");	
		
		return result;
	}
	
}
