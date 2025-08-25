package egovframework.ezEKP.ezPortal.web;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 스케쥴
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.07.20    지정석    신규작성
 *
 * @see
 */

@Controller
public class EzPortalController extends EzFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EzPortalController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzPortalService")
	private EzPortalService ezPortalService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	/**
	 * 포탈 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/portalMain.do")
	public String portalMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		return "redirect:/ezNewPortal/newPortalMain.do";
	}
	/**
	 * 포탈 - 환경설정 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/environmentMain.do", method = RequestMethod.GET)
	public String environmentMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req) throws Exception {
		logger.debug("environmentMain started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String usePortal = "";
		String url = "";
		String funCode = "";
		String topMenuID = "";
		String leftFrameWidth = "220";
		int width = 0;
		
		usePortal = ezCommonService.getTenantConfig("Use_Portal", userInfo.getTenantId());
		
		if (req.getParameter("funCode") != null && !req.getParameter("funCode").equals("")) {
			funCode = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(req.getParameter("funCode")));
		}
		
		if (req.getParameter("topMenuID") != null && !req.getParameter("topMenuID").equals("")) {
			topMenuID = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(req.getParameter("topMenuID")));
		}
		
		if (funCode.equals("1")) {
			url = "/ezPersonal/leftEnvironment.do?funCode=1&topMenuID="+topMenuID;
		} else {
			url = "/ezPersonal/leftEnvironment.do?topMenuID="+topMenuID;
		}

		if (req.getParameter("__wwidth") != null) {
			String widthParam = req.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}
		
		model.addAttribute("usePortal", usePortal);
		model.addAttribute("url", url);
		model.addAttribute("topMenuID", topMenuID);
		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		logger.debug("environmentMain ended");
		return "/ezPortal/portalEnvironmentMain";
	}
	
	/**
	 * 포탈 - 통합검색기능
	 * */
	@RequestMapping(value="/ezPortal/totalSearch.do")
	public String totalSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, Locale locale, HttpServletRequest req) throws Exception{
		logger.debug("totalSearch is started.");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String keyword = req.getParameter("keyword") != null ? commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(req.getParameter("keyword"))) : "";
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("keyword", commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(keyword)));
		
		logger.debug("totalSearch is ended.");
		return "/ezPortal/totalSearchMain";
	}
	
	/**
	 * 포탈 - 통합검색 왼쪽메뉴
	 * */
	@RequestMapping(value="/ezPortal/totalSearchLeft.do")
	public String totalSearchLeft(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, Locale locale, HttpServletRequest req) throws Exception {
		return "/ezPortal/totalSearchLeft";
	}
	
	/**
	 * 포탈 - 통합검색 오른쪽화면
	 * */
	@RequestMapping(value="/ezPortal/totalSearchRight.do")
	public String totalSearchRight(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, Locale locale, HttpServletRequest req) throws Exception {
		logger.debug("totalSearchRight is started.");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String keyword = req.getParameter("keyword") != null ? commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(req.getParameter("keyword"))) : "";
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("keyword", commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(keyword)));
		model.addAttribute("useWebfolder", ezCommonService.getTenantConfig("useWebfolder", userInfo.getTenantId())); // 20210607 조진호 - 웹폴더 사용유무
		model.addAttribute("totalSearchEngineType", ezCommonService.getTenantConfig("totalSearchEngineType", userInfo.getTenantId())); // 2023-02-10 홍승비 - 통합검색엔진 종류 테넌트 컨피그로 분리
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId())); // 한글 웹기안기 사용여부
		
		logger.debug("totalSearchRight is ended.");
		return "/ezPortal/totalSearchRight";
	}
	
	
	/**
	 * 포탈 - 통합검색 검색리스트 (XTEN)
	 * */
	@RequestMapping(value="/ezPortal/getTotalSearchList_XTEN.do", produces="application/json; charset=utf-8")
	@ResponseBody
	public JSONObject getTotalSearchList_XTEN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo , Locale locale, @RequestBody Map<String, Object> paramData, HttpServletRequest req) throws Exception {
		logger.debug("getTotalSearchList_XTEN is started.");
		logger.debug("paramData : " + paramData.toString());
		
		JSONObject result;
		
		try {
			userInfo = commonUtil.userInfo(loginCookie);
			String totalSearchURL = config.getProperty("config.totalSearchURL");
			totalSearchURL += ezPortalService.getTotalSearchURL_XTEN(userInfo, paramData);
			
			// logger.debug("totalSearchURL (encoded keyword param)   ::   " + totalSearchURL);
			
			try {
				result = commonUtil.getXML2JsonFromRestApi(totalSearchURL, "", null, req, "post", null, 4000, 8000);
			}
			catch (Exception ex) {
				logger.error(ex.getMessage(), ex);
				logger.debug("totalSearch_XTEN retry...");
				result = commonUtil.getXML2JsonFromRestApi(totalSearchURL, "", null, req, "post", null, 4000, 8000);
			}
			
			logger.debug("result : {}", result);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			Map<String, String> resultMap = new HashMap<>();
			resultMap.put("error", "internal server error");
			result = new JSONObject(resultMap);
		}
		
		// logger.debug("result json in getTotalSearchList_XTEN   ::   " + result.toString());
		logger.debug("getTotalSearchList_XTEN is ended.");
		return result;
	}
	
	
	/**
	 * 포탈 - 통합검색 검색리스트
	 * */
	@RequestMapping(value="/ezPortal/getTotalSearchList.do")
	@ResponseBody
	public Object getTotalSearchList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo , Locale locale, @RequestBody Map<String, Object> paramData, HttpServletRequest req) throws Exception {
		logger.debug("getTotalSearchList is started.");
		
		logger.debug("paramData : " + paramData.toString());
		JSONObject result;
		
		try{
			userInfo = commonUtil.userInfo(loginCookie);
			JSONObject searchResult = ezPortalService.callSearchServerForResult2(userInfo, paramData);

			//접속하고자 하는 url.
			String totalSearchURL = config.getProperty("config.totalSearchURL");
			
			try {
				result = commonUtil.getJsonFromRestApi(totalSearchURL, "", null, req, "post", searchResult, 4000, 8000);
			} catch (Exception ex) {
				logger.error(ex.getMessage(), ex);
				logger.debug("totalSearch retry...");
				result = commonUtil.getJsonFromRestApi(totalSearchURL, "", null, req, "post", searchResult, 4000, 8000);
			}
			
			logger.debug("result : {}", result);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			Map<String, String> resultMap = new HashMap<>();
			resultMap.put("error", "internal server error");
			result = new JSONObject(resultMap);
		}
		
		logger.debug("getTotalSearchList is ended.");
		return result;
	}
}
