package egovframework.ezEKP.ezNewPortal.web;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hsqldb.types.Type;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPoll.service.EzPollService;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzNewPortalPortletController {
private static final Logger logger = LoggerFactory.getLogger(EzNewPortalPortletController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzPortalService")
	private EzPortalService ezPortalService;
	
	@Resource(name="EzPortalAdminService")
	private EzPortalAdminService ezPortalAdminService;
	
	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;
	
	@Resource(name = "EzQuestionService")
	private EzQuestionService ezQuestionService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzPollService")
	private EzPollService ezPollService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/noticePortlet.do")
	public String portalNoticePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalNoticePortlet Start");
		String usedTheme = req.getParameter("usedTheme");
		
		model.addAttribute("usedTheme", usedTheme);
		return "/ezNewPortal/portlets/noticePortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항 리스트 가져오기
	 */
	@RequestMapping(value = "/ezNewPortal/getNoticePortlet.do")
	public String getPortalNoticePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("getPortalNoticePortlet Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		String url = "/rest/ezPortal/portlets/notice";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			JSONArray noticeList = (JSONArray) data.get("noticeList");
			model.addAttribute("noticeList", noticeList);
		}
		logger.debug("getPortalNoticePortlet End");		
		return "json";
	}

	/**
	 * 포틀릿 - 받은메일
	 */
	@RequestMapping(value = "/ezNewPortal/receivedMailPortlet.do")
	public String portalReceivedMailPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalReceivedMailPortlet Start");
		
		String usedTheme = req.getParameter("usedTheme");
		
		model.addAttribute("usedTheme", usedTheme);
		
		logger.debug("portalReceivedMailPortlet End");
		return "/ezNewPortal/portlets/receivedMailPortlet";
	}
	
	/**
	 * 포틀릿 - 받은메일
	 */
	@RequestMapping(value = "/ezNewPortal/receivedMailPortletList.do")
	public String portalReceivedMailPortletList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalReceivedMailPortlet Start");
		userInfo = commonUtil.userInfo(loginCookie);
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);	
		String url = "/rest/ezPortal/portlets/receivedMail";
		
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("password", password);
		param.put("portletId", req.getParameter("portletId"));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String result = resultBody.get("status").toString();
		
		if (result.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			model.addAttribute("mailList", data.get("mailList"));
			model.addAttribute("unreadCount", data.get("unreadCount"));
			model.addAttribute("mailboxQuotaStr", data.get("mailboxQuotaStr"));
			model.addAttribute("mailboxDetail", data.get("mailboxDetail"));
			model.addAttribute("mailPercent", data.get("mailPercent"));
		}
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("portalReceivedMailPortlet End");
		return "json";
	}
	
	
	/**
	 * 포틀릿 - 투표 포틀릿 
	 */
	@RequestMapping(value = "/ezNewPortal/votePortlet.do")
	public String portalVotePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("portalVotePortlet Start");
		String usedTheme = req.getParameter("usedTheme");
		
		model.addAttribute("usedTheme", usedTheme);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("portletId", req.getParameter("portletId"));
		String url = "/rest/ezPortal/portlets/vote";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			model.addAttribute("voteCount", data.get("voteCount"));
			model.addAttribute("title", data.get("title"));
			model.addAttribute("qstId", data.get("qstId"));
			model.addAttribute("pollAnswer", data.get("pollAnswer"));
			model.addAttribute("pollAnswerCount", data.get("pollAnswerCount"));
		}
		
		model.addAttribute("portletName", req.getParameter("portletName"));
		
		logger.debug("portalVotePortlet End");
		return "/ezNewPortal/portlets/votePortlet";
	}
	
	/**
	 * 포틀릿 - 설문조사
	 */
	@RequestMapping(value = "/ezNewPortal/pollPortlet.do")
	public String portalPollPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("portalNoticePortlet Start");
		
		String usedTheme = req.getParameter("usedTheme");
		
		model.addAttribute("usedTheme", usedTheme);
		
		return "/ezNewPortal/portlets/pollPortlet";
	}
	
	@RequestMapping(value = "/ezNewPortal/getPollPortlet.do")
	public String getPortalPollPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getPortalPollPortlet Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		String url = "/rest/ezPortal/portlets/poll";

		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONObject poll = (JSONObject) resultBody.get("data");
			model.addAttribute("poll", poll);
		} 		
		return "json";
	}
	/**
	 * 포틀릿 - 일정관리 
	 */
	@RequestMapping(value = "/ezNewPortal/schedulePortlet.do")
	public String portalSchedulePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalSchedulePortlet Start");
		
		String usedTheme = req.getParameter("usedTheme");
		
		model.addAttribute("usedTheme", usedTheme);
		
		logger.debug("portalSchedulePortlet End");
		return "/ezNewPortal/portlets/schedulePortlet";
	}
	
	/**
	 * 포틀릿 - 일정관리 목록 조회
	 */
	@RequestMapping(value = "/ezNewPortal/getScheduleList.do")
	public String getScheduleList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getScheduleList Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("selectDate", request.getParameter("selectDate"));
		param.put("STARTDATE", request.getParameter("STARTDATE"));
		param.put("ENDDATE", request.getParameter("ENDDATE"));
		
		String url = "/rest/ezportal/portlets/schedulelist";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray resultList = (JSONArray) resultBody.get("data");
			
			model.addAttribute("resultList", resultList);
		}
		
		logger.debug("getScheduleList End");
		return "json";
	} 
	
	
	/**
	 * 포틀릿 - 전자결재 목록 포틀릿
	 */
	@RequestMapping(value = "/ezNewPortal/approvalListPortlet.do")
	public String portalApprovalListPortlet(HttpServletRequest req, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("portalApprovalListPortlet started.");
		
		String usedTheme = req.getParameter("usedTheme");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("usedTheme", usedTheme);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("portalApprovalListPortlet ended.");
		
		return "/ezNewPortal/portlets/approvalListPortlet";
	}
	
	/**
	 * 포틀릿 - 전자결재 목록 조회
	 */
	@RequestMapping(value = "/ezNewPortal/getApprovalList.do")
	public String getApprovalList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getApprovalList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("type", paramMap.get("type"));
		String url = "/rest/ezportal/portlets/approvallist";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			
			JSONParser jp = new JSONParser();
			data = (JSONObject) jp.parse(data.toJSONString());
			
			JSONArray resultList = (JSONArray) data.get("list");
			
			model.addAttribute("resultList", resultList);
			model.addAttribute("imgPath", commonUtil.getUploadPath("upload_personal.PHOTOTHUMBNAIL", userInfo.getTenantId()));
			
			//진행중인 문서일 경우에만 aprLines
			if (data.containsKey("aprLines")) {
				model.addAttribute("aprLines", (JSONArray) data.get("aprLines"));
			}
		}
		
		logger.debug("getApprovalList ended.");
		
		return "json";
	}
	
	/**
	 * 포틀릿 - 양식즐겨찾기 포틀릿
	 */
	@RequestMapping(value = "/ezNewPortal/favoriteFormsPortlet.do")
	public String portalFavoriteFormsPortlet(HttpServletRequest req, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("favoriteFormsPortlet started.");
		
		String usedTheme = req.getParameter("usedTheme");
		
		model.addAttribute("usedTheme", usedTheme);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = request.getParameter("portletId");
		String portletName = request.getParameter("portletName");
		
		String buJaeInfo = ezOrganService.getPropertyValue(userInfo.getId(), "extensionAttribute5", userInfo.getTenantId());
		
		model.addAttribute("portletId", portletId);
		model.addAttribute("portletName", portletName);
		model.addAttribute("userInfo", userInfo);
//		model.addAttribute("approvalGFlag", ezCommonService.getTenantConfig("approvalGFlag", userInfo.getTenantId()));
		model.addAttribute("buJaeInfo", buJaeInfo);
		model.addAttribute("now", commonUtil.getTodayUTCTime(""));
		
		logger.debug("favoriteFormsPortlet ended.");
		
		return "/ezNewPortal/portlets/favoriteFormsPortlet";
	}
	
	/**
	 * 포틀릿 - 양식즐겨찾기 리스트 조회
	 */
	@RequestMapping(value = "/ezNewPortal/getFavoriteForms.do")
	public String getFavoriteForms(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getFavoriteForms started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		String url = "/rest/ezportal/portlets/favoriteforms";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			JSONArray resultList = (JSONArray) data.get("resultList");
			
			model.addAttribute("resultList", resultList);
		}
		
		logger.debug("getFavoriteForms ended.");
		
		return "json";
	}
	
	/**
	 * 포틀릿 - 양식즐겨찾기 통계 조회
	 */
	@RequestMapping(value = "/ezNewPortal/getApprovalStatistics.do")
	public String getApprovalStatistics(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getFavoriteForms started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		String url = "/rest/ezportal/portlets/approvalstatistics";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			
			model.addAttribute("hour", data.get("hour"));
			model.addAttribute("day", data.get("day"));
			model.addAttribute("week", data.get("week"));
			model.addAttribute("month", data.get("month"));
			model.addAttribute("other", data.get("other"));
		}
		
		logger.debug("getFavoriteForms ended.");
		
		return "json";
	}
	
	/**
	 * 포틀릿 - 포토게시판 포틀릿
	 */
	@RequestMapping(value = "/ezNewPortal/photoBoardPortlet.do")
	public String portalPhotoBoardPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie,HttpServletResponse resp) throws Exception {
		logger.debug("portalPhotoBoardPortlet Start");
		
		String usedTheme = req.getParameter("usedTheme");
		
		model.addAttribute("usedTheme", usedTheme);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = req.getParameter("portletId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("startRow", 0);
		param.put("photoCount", 4);
		param.put("portletId", portletId);
		String url = "/rest/ezPortal/portlets/photoBoard";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String result = resultBody.get("status").toString();
		
		if (result.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			String access = data.get("access").toString();
			model.addAttribute("access", access);
			model.addAttribute("boardId", data.get("boardId"));
			model.addAttribute("portletName", data.get("portletName"));
			
			if (access.equals("true")) {
				model.addAttribute("photoBoardList", data.get("photoBoardList"));
			}
		}
		
		model.addAttribute("portletId", portletId);
		logger.debug("phoroBoardPortlet End");
		return "/ezNewPortal/portlets/photoBoardPortlet";
	}
	
	/**
	 * 포틀릿 - 즐겨찾기
	 */
	@RequestMapping(value = "/ezNewPortal/favoriteBoardPortlet.do")
	public String portalFavoriteBoardPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalFavoriteBoardPortlet Start");
		
		String usedTheme = req.getParameter("usedTheme");
		
		model.addAttribute("usedTheme", usedTheme);

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("portalFavoriteBoardPortlet ended");
		return "/ezNewPortal/portlets/favoriteBoardPortlet";
	}
	
	/**
	 * 포들릿 - 즐겨찾기 탭 리스트 불러오기
	 */
	@RequestMapping(value="/ezNewPortal/favoriteBoardPortletList.do")
	@ResponseBody
	public JSONArray favoriteBoardPortletList(String mode, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model, Locale locale) throws Exception {
		logger.debug("get_favoriteList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("mode", mode);
		param.put("userId", userId);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPortal/portlets/boardFavorites/lists", param, request, "get", null);		
		
		String status = resultBody.get("status").toString();
		JSONArray json = new JSONArray();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			
			if (data.get("resultList") != null) {
				json = (JSONArray) data.get("resultList");
			} else {
				json = null;
			}
			
		}

		logger.debug("get_favoriteList ended");
		return json;
	}
	
	/**
	 * 포들릿 - 즐겨찾기 리스트 불러오기
	 */
	@RequestMapping(value="/ezNewPortal/getFavoriteBoardList.do")
	@ResponseBody
	public JSONArray getFavoriteBoardList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model, Locale locale) throws Exception {
		logger.debug("get_favoriteList started");

		userInfo = commonUtil.userInfo(loginCookie);
    	
    	String userId = userInfo.getId();
    	String boardId = request.getParameter("boardId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("boardId", boardId);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPortal/portlets/boardFavorites", param, request, "get", null);		
		
		String status = resultBody.get("status").toString();
		JSONArray json = new JSONArray();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			
			if (data.get("favList") != null) {
					json = (JSONArray) data.get("favList");
			} else {
				json = null;
			}
		}

		logger.debug("get_favoriteList ended");
		return json;
	}	
	
	/**
	 * 포틀릿 - 커뮤니티
	 */
	@RequestMapping(value = "/ezNewPortal/communityPortlet.do")
	public String portalCommunityPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalCommunityPortlet Start");
		
		String usedTheme = req.getParameter("usedTheme");
		
		model.addAttribute("usedTheme", usedTheme);
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		String url = "/rest/ezPortal/portlets/community";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, req, "get", null);
		String result = resultBody.get("status").toString();
		
		if (result.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			
			model.addAttribute("CommunityList", data.get("CommunityList"));
			model.addAttribute("CommuSize", data.get("CommuSize"));
			model.addAttribute("commuPath", data.get("commuPath"));
		}
		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("userInfo", userInfo);
		
		
		logger.debug("phoroBoardPortlet End");
		
		return "/ezNewPortal/portlets/communityPortlet";
	}
	
	/**
	 * 포들릿 - 커뮤니티 허가여부
	 */
	@RequestMapping(value="/ezNewPortal/getCommunityPermit.do")
	@ResponseBody
	public String CommunityPermit(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model, Locale locale) throws Exception {
		logger.debug("get_favoriteList started");

		userInfo = commonUtil.userInfo(loginCookie);
		String url = "/rest/ezPortal/portlets/community/permits";
    	
    	String userId = userInfo.getId();
    	String clubNo = request.getParameter("clubNo");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("clubNo", clubNo);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);		
		
		String status = resultBody.get("status").toString();
		String result = "";
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			result = (String) data.get("memberChk");			
		}

		logger.debug("get_favoriteList ended");
		return result;
	}	
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/helpPortlet.do")
	public String portalHelpPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalHelpPortlet Start");
		
		String usedTheme = req.getParameter("usedTheme");
		
		model.addAttribute("usedTheme", usedTheme);
		
		return "/ezNewPortal/portlets/helpPortlet";
	}
	
	/**
	 * 포틀릿 - 환율 포틀릿
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/currencyPortlet.do")
	public String portalCurrencyPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("portalCurrencyPortlet Start");
		
		String usedTheme = req.getParameter("usedTheme");
		
		model.addAttribute("usedTheme", usedTheme);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		RestTemplate restTemplate = new RestTemplate();
		String json = restTemplate.getForObject("http://fx.kebhana.com/FER1101M.web", String.class);
		json = json.replaceAll("var exView = ", "");
		json = json.substring(0, json.lastIndexOf(",")) + json.substring(json.lastIndexOf(",") + 1);

		ObjectMapper mapper = new ObjectMapper();
		HashMap<String, Object> map2 = mapper.readValue(json, HashMap.class);
		ArrayList<Map<String, Object>> list = (ArrayList<Map<String, Object>>) map2.get("리스트");
		String exchangeRate = (String) list.get(0).get("송금_전신환보내실때");
		
		return "/ezNewPortal/portlets/currencyPortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/weatherPortlet.do")
	public String portalWeatherePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalWeatherePortlet Start");
		
		String usedTheme = req.getParameter("usedTheme");
		
		model.addAttribute("usedTheme", usedTheme);
		
		return "/ezNewPortal/portlets/weatherPortlet";
	}
	
	/////포틀릿 정보만 가져오기
	@RequestMapping(value = "/ezNewPortal/getPhotoItemList.do")
	@ResponseBody
	public JSONArray portalPhotoItemList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie,HttpServletResponse resp) throws Exception {
		logger.debug("portalPhotoItemList Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String url = "/rest/ezPortal/portlets/photoBoard";
		int page = Integer.parseInt(req.getParameter("page"));
		int photoCount = Integer.parseInt(req.getParameter("photoCount"));
		int startRow = (page - 1) * photoCount;
		String portletId = req.getParameter("portletId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("photoCount", photoCount);
		param.put("startRow", startRow);
		param.put("portletId", portletId);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String result = resultBody.get("status").toString();
		JSONArray json = new JSONArray();
		
		if (result.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			String access = data.get("access").toString();
			
			if (access.equals("true")) {
				if (data.get("photoBoardList") != null) {
					json = (JSONArray) data.get("photoBoardList");
				} else {
					json = null;
				}
			}
		}
		
		logger.debug("portalPhotoItemList Ended");
		return json;
	}
	
	/**
	 * 포틀릿 - 생일자
	 */
	@RequestMapping(value = "/ezNewPortal/birthdayPortlet.do")
	public String portalBirthdayPortlet(HttpServletRequest req, Model model) throws Exception {
		logger.debug("portalBirthdayPortlet Start");
		
		Calendar cal = Calendar.getInstance();
		String nowMonth = String.valueOf(cal.get(Calendar.MONTH)+1);
		model.addAttribute("nowMonth", nowMonth);
		
		logger.debug("portalBirthdayPortlet End");
		return "/ezNewPortal/portlets/birthdayPortlet";
	}
	
	/**
	 * 포틀릿 - 슬라이드 이미지
	 */
	@RequestMapping(value = "/ezNewPortal/slideImagePortlet.do")
	public String portalSlideImagePortlet(HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("portalSlideImagePortlet Start");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/ezportal/portlets/slideimages";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("sliderList", resultBody.get("data"));
		}
		
		logger.debug("portalSlideImagePortlet End");
		return "/ezNewPortal/portlets/slideImagePortlet";
	}
	
	/**
	 * 포틀릿 - 유저정보
	 */
	@RequestMapping(value = "/ezNewPortal/userInfoPortlet.do")
	public String portalUserInfoPortlet(HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("portalUserInfoPortlet Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/ezportal/portlets/userinfomations";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			
			model.addAttribute("useAttitude", data.get("useAttitude"));
			model.addAttribute("userName", data.get("userName"));
			model.addAttribute("userTitle", data.get("userTitle"));
			model.addAttribute("deptName", data.get("deptName"));
			model.addAttribute("userPhoto", data.get("userPhoto"));
			model.addAttribute("userEmail", data.get("userEmail"));
			model.addAttribute("lastLogin", data.get("lastLogin"));
		}
		
		logger.debug("portalUserInfoPortlet End");
		return "/ezNewPortal/portlets/userInfoPortlet";
	}
}
