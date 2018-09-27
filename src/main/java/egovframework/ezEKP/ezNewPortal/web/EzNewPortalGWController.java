package egovframework.ezEKP.ezNewPortal.web;

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

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzNewPortalGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzNewPortalGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Resource(name="ezNewPortalService")
	private EzNewPortalService ezNewPortalService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	/**
	 * 포탈개인화  G/W [GET] 사용자별 개인화 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezNewPortal/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getPortalUserSetting(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getPortalUserSetting started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getPortalUserSetting ended.");
		return result;
	}
}
