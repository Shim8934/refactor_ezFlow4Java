package egovframework.ezEKP.ezCommon.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;

@RestController
public class EzCommonGWController {

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCommonGWController.class);
	
	/**
	 * ezCommon G/W [GET] 프로퍼티 조회 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezcommon/configs", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public Object getTenantConfig(HttpServletRequest request) throws Exception {
		logger.debug("G/W ezCommon [GET /rest/ezcommon/configs] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String property = request.getParameter("property");
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			String propertyValue = ezCommonService.getTenantConfig(property, info.getTenantId());
	
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", propertyValue);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		logger.debug("G/W ezCommon [GET /rest/ezcommon/configs] ended.");
		
		return result;
	}
	
}
