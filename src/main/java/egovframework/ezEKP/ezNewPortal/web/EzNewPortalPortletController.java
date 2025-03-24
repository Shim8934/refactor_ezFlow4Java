package egovframework.ezEKP.ezNewPortal.web;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.ChartVO;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPoll.service.EzPollService;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
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
	
	@Resource(name = "EzNewPortalService")
	private EzNewPortalService ezNewPortalService;
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/noticePortlet.do", method=RequestMethod.GET)
	public String portalNoticePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalNoticePortlet Start");
		
		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		return "/ezNewPortal/portlets/noticePortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항 리스트 가져오기
	 */
	@RequestMapping(value = "/ezNewPortal/getNoticePortlet.do", method=RequestMethod.GET)
	public String getPortalNoticePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("getPortalNoticePortlet Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("portletId", req.getParameter("portletId"));
		param.put("currentPage", req.getParameter("currentPage"));
		param.put("listCntSize", req.getParameter("listCntSize"));
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		String url = "/rest/ezPortal/portlets/notice";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			String access = data.get("access").toString();
			
			model.addAttribute("boardId", data.get("boardId")); //게시판 아이디 넘기기
			model.addAttribute("access", access);
			
			if (access.equals("true")) {
				if (data.get("noticeList") != null) {
					JSONArray noticeList = (JSONArray) data.get("noticeList");
					model.addAttribute("noticeList", noticeList);
				} else {
					return "json";
				}
			}
			model.addAttribute("totalCnt", data.get("totalCnt"));
			model.addAttribute("currentPage", data.get("currentPage"));
		}
		
		logger.debug("getPortalNoticePortlet End");		
		return "json";
	}

	/**
	 * 포틀릿 - 받은메일
	 */
	@RequestMapping(value = "/ezNewPortal/receivedMailPortlet.do", method=RequestMethod.GET)
	public String portalReceivedMailPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalReceivedMailPortlet Start");
		
		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		
		logger.debug("portalReceivedMailPortlet End");
		return "/ezNewPortal/portlets/receivedMailPortlet";
	}
	
	/**
	 * 포틀릿 - 받은메일
	 */
	@RequestMapping(value = "/ezNewPortal/receivedMailPortletList.do", method=RequestMethod.GET)
	public String portalReceivedMailPortletList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalReceivedMailPortlet Start");
		userInfo = commonUtil.userInfo(loginCookie);	
		String url = "/rest/ezPortal/portlets/receivedMail";
				
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("portletId", req.getParameter("portletId"));
		param.put("mailCount", req.getParameter("mailCount"));
		param.put("currPage", req.getParameter("currPage"));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String result = resultBody.get("status").toString();
		
		if (result.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			model.addAttribute("mailList", data.get("mailList"));
			model.addAttribute("unreadCount", data.get("unreadCount"));
			model.addAttribute("mailboxQuotaStr", data.get("mailboxQuotaStr"));
			model.addAttribute("mailboxDetail", data.get("mailboxDetail"));
			model.addAttribute("mailPercent", data.get("mailPercent"));
			model.addAttribute("currPage", data.get("currPage"));
			model.addAttribute("totalCount", data.get("totalCount"));
		}
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("portalReceivedMailPortlet End");
		return "json";
	}

	/**
	 * 포틀릿 - 외부받은메일
	 */
	@RequestMapping(value = "/ezNewPortal/receivedMailPortlet2.do", method=RequestMethod.GET)
	public String receivedMailPortlet2(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalReceivedMailPortlet2 Start");

		String MailServerURL2 = config.getProperty("config.MailServerURL2");
		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		model.addAttribute("MailServerURL2", MailServerURL2);


		logger.debug("portalReceivedMailPortlet2 End");
		return "/ezNewPortal/portlets/receivedMailPortlet2";
	}

	/**
	 * 포틀릿 - 외부받은메일
	 */
	@RequestMapping(value = "/ezNewPortal/receivedMailPortletList2.do", method=RequestMethod.GET)
	public String receivedMailPortletList2(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalReceivedMailPortlet2 Start");
		model.addAttribute("userInfo", userInfo);

		try {
			userInfo = commonUtil.userInfo(loginCookie);
			String url = "/rest/ezPortal/portlets/receivedMail";

			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("userId", userInfo.getId());
			param.put("portletId", req.getParameter("portletId"));
			param.put("mailCount", req.getParameter("mailCount"));
			param.put("currPage", req.getParameter("currPage"));
			String MailServerURL2 = config.getProperty("config.MailServerURL2");

			JSONObject resultBody = commonUtil.getJsonFromRestApi(MailServerURL2, url, param, req, "get", null);
			String result = resultBody.get("status").toString();
			if (result.equals("ok")) {
				JSONObject data = (JSONObject) resultBody.get("data");
				model.addAttribute("mailList", data.get("mailList"));
				model.addAttribute("unreadCount", data.get("unreadCount"));
				model.addAttribute("mailboxQuotaStr", data.get("mailboxQuotaStr"));
				model.addAttribute("mailboxDetail", data.get("mailboxDetail"));
				model.addAttribute("mailPercent", data.get("mailPercent"));
				model.addAttribute("currPage", data.get("currPage"));
				model.addAttribute("totalCount", data.get("totalCount"));
				model.addAttribute("MailServerURL2", MailServerURL2);
			}
		} catch (Exception e){
			e.printStackTrace();
		}

		model.addAttribute("userInfo", userInfo);

		logger.debug("portalReceivedMailPortlet2 End");
		return "json";
	}
	
	/**
	 * 포틀릿 - 투표 포틀릿 
	 */
	@RequestMapping(value = "/ezNewPortal/votePortlet.do", method=RequestMethod.GET)
	public String portalVotePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("portalVotePortlet Start");
		
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("portletId", req.getParameter("portletId"));
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		param.put("rollInfo", userInfo.getRollInfo());
		String url = "/rest/ezPortal/portlets/vote";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String status = resultBody.get("status").toString();
		
		logger.debug("vote portlet status : " + status);
		
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
	
	@RequestMapping(value = "/ezNewPortal/getVoteInfo.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject getVoteInfo(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getVoteInfo Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("portletId", req.getParameter("portletId"));
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		param.put("rollInfo", userInfo.getRollInfo());
		String url = "/rest/ezPortal/portlets/vote";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String status = resultBody.get("status").toString();
		JSONObject result = new JSONObject();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			result = data;
		}
		
		logger.debug("getVoteInfo End");
		return result;
	}
	
	/**
	 * 포틀릿 - 설문조사
	 */
	@RequestMapping(value = "/ezNewPortal/pollPortlet.do", method=RequestMethod.GET)
	public String portalPollPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("portalNoticePortlet Start");
		
		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		
		return "/ezNewPortal/portlets/pollPortlet";
	}
	
	@RequestMapping(value = "/ezNewPortal/getPollPortlet.do", method=RequestMethod.GET)
	public String getPortalPollPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getPortalPollPortlet Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
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
	@RequestMapping(value = "/ezNewPortal/schedulePortlet.do", method=RequestMethod.GET)
	public String portalSchedulePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalSchedulePortlet Start");
		
		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		
		logger.debug("portalSchedulePortlet End");
		return "/ezNewPortal/portlets/schedulePortlet";
	}
	
	/**
	 * 포틀릿 - 일정관리 목록 조회
	 */
	@RequestMapping(value = "/ezNewPortal/getScheduleList.do", method=RequestMethod.POST)
	public String getScheduleList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getScheduleList Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("selectDate", request.getParameter("selectDate"));
		param.put("STARTDATE", request.getParameter("STARTDATE"));
		param.put("ENDDATE", request.getParameter("ENDDATE"));
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		
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
	@RequestMapping(value = "/ezNewPortal/approvalListPortlet.do", method=RequestMethod.GET)
	public String portalApprovalListPortlet(HttpServletRequest req, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("portalApprovalListPortlet started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("portletId", req.getParameter("portletId"));
		
		logger.debug("portalApprovalListPortlet ended.");
		
		return "/ezNewPortal/portlets/approvalListPortlet";
	}
	
	/**
	 * 포틀릿 - 전자결재 목록 조회
	 */
	@RequestMapping(value = "/ezNewPortal/getApprovalList.do", method=RequestMethod.POST)
	public String getApprovalList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getApprovalList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("type", paramMap.get("type"));
		param.put("companyId", userInfo.getCompanyID());
		String url = "/rest/ezportal/portlets/approvallist";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			
			JSONParser jp = new JSONParser();
			data = (JSONObject) jp.parse(data.toJSONString());
			
			JSONArray resultList = (JSONArray) data.get("list");
			
			model.addAttribute("resultList", resultList);
			model.addAttribute("imgPath", commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()));
			
			//진행중인 문서일 경우에만 aprLines
			if (data.containsKey("aprLines0")) {
				model.addAttribute("aprLines0", (JSONArray) data.get("aprLines0"));
				model.addAttribute("aprLines1", (JSONArray) data.get("aprLines1"));
				model.addAttribute("aprLines2", (JSONArray) data.get("aprLines2"));
			}
		}
		
		logger.debug("getApprovalList ended.");
		
		return "json";
	}
	

	/**
	 * 포틀릿 - 전자결재 문서함별 포틀릿
	 */
	@RequestMapping(value = "/ezNewPortal/apprPortlet.do", method=RequestMethod.GET)
	public String portalApprPortlet(HttpServletRequest req, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("portalApprovalListPortlet started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = request.getParameter("portletId");
		String portletName = request.getParameter("portletName");
		String cabinetType = request.getParameter("cabinetType");

		model.addAttribute("portletId", portletId);
		model.addAttribute("portletName", portletName);
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("cabinetType", cabinetType);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		logger.debug("portalApprovalListPortlet ended.");
		
		return "/ezNewPortal/portlets/apprPortlet";
	}
	
	
	/**
	 * 포틀릿 - 양식즐겨찾기 포틀릿
	 */
	@RequestMapping(value = "/ezNewPortal/favoriteFormsPortlet.do", method=RequestMethod.GET)
	public String portalFavoriteFormsPortlet(HttpServletRequest req, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("favoriteFormsPortlet started.");
		
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = request.getParameter("portletId");
		String portletName = request.getParameter("portletName");
		
        if (portletName == null) {
            logger.debug("--> portletName is null");
            return "";
        }
        
        portletName = portletName.replaceAll("=", "");
		
		String buJaeInfo = ezOrganService.getPropertyValue(userInfo.getId(), "extensionAttribute5", userInfo.getTenantId());
		
		model.addAttribute("portletId", portletId);
		model.addAttribute("portletName", portletName);
		model.addAttribute("userInfo", userInfo);
//		model.addAttribute("approvalGFlag", ezCommonService.getTenantConfig("approvalGFlag", userInfo.getTenantId()));
		model.addAttribute("buJaeInfo", buJaeInfo);
		model.addAttribute("now", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), "235|+09:00", false));
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		
		logger.debug("favoriteFormsPortlet ended.");
		
		return "/ezNewPortal/portlets/favoriteFormsPortlet";
	}
	
	/**
	 * 포틀릿 - 양식즐겨찾기 리스트 조회
	 */
	@RequestMapping(value = "/ezNewPortal/getFavoriteForms.do", method=RequestMethod.GET)
	public String getFavoriteForms(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getFavoriteForms started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
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
	@RequestMapping(value = "/ezNewPortal/getApprovalStatistics.do", method=RequestMethod.GET)
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
	@RequestMapping(value = "/ezNewPortal/photoBoardPortlet.do", method=RequestMethod.GET)
	public String portalPhotoBoardPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie,HttpServletResponse resp) throws Exception {
		logger.debug("portalPhotoBoardPortlet Start");
		
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = req.getParameter("portletId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("currentPage", 1);
		param.put("photoCount", 6);
		param.put("portletId", portletId);
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
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
				model.addAttribute("totalCnt", data.get("totalCnt"));
			}
		}
		
		model.addAttribute("portletId", portletId);
		logger.debug("phoroBoardPortlet End");
		return "/ezNewPortal/portlets/photoBoardPortlet";
	}
	
	/**
	 * 포틀릿 - 즐겨찾기
	 */
	@RequestMapping(value = "/ezNewPortal/favoriteBoardPortlet.do", method=RequestMethod.GET)
	public String portalFavoriteBoardPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalFavoriteBoardPortlet Start");
		
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("portalFavoriteBoardPortlet ended");
		return "/ezNewPortal/portlets/favoriteBoardPortlet";
	}
	
	/**
	 * 포들릿 - 즐겨찾기 탭 리스트 불러오기
	 */
	@RequestMapping(value="/ezNewPortal/favoriteBoardPortletList.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONArray favoriteBoardPortletList(String mode, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model, Locale locale) throws Exception {
		logger.debug("get_favoriteList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("mode", mode);
		param.put("userId", userId);
		param.put("companyId", userInfo.getCompanyID());

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
	@RequestMapping(value="/ezNewPortal/getFavoriteBoardList.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject getFavoriteBoardList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model, Locale locale) throws Exception {
		logger.debug("get_favoriteList started");

		userInfo = commonUtil.userInfo(loginCookie);
    	String userId = userInfo.getId();
    	String boardId = request.getParameter("boardId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("boardId", boardId);
		param.put("currentPage", request.getParameter("currentPage"));
		param.put("listCnt", request.getParameter("listCnt"));
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPortal/portlets/boardFavorites", param, request, "get", null);		
		
		String status = resultBody.get("status").toString();
		JSONObject json = new JSONObject();
		
		if (status.equals("ok")) {
			json = (JSONObject) resultBody.get("data");
		}

		logger.debug("get_favoriteList ended");
		return json;
	}	
	
	/**
	 * 포틀릿 - 커뮤니티
	 */
	@RequestMapping(value = "/ezNewPortal/communityPortlet.do", method=RequestMethod.GET)
	public String portalCommunityPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalCommunityPortlet Start");
		
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("companyId", userInfo.getCompanyID());
		param.put("currentPage", 1);
		param.put("listSize", 5);
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
	
	@RequestMapping(value = "/ezNewPortal/getCommunityList.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject getCommunityList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("getCommunityList Start");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("companyId", userInfo.getCompanyID());
		param.put("currentPage", req.getParameter("currentPage"));
		param.put("listSize", req.getParameter("listSize"));
		String url = "/rest/ezPortal/portlets/community";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, req, "get", null);
		String result = resultBody.get("status").toString();
		JSONObject json = new JSONObject();
		
		if (result.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			json = data;
		}
		
		logger.debug("getCommunityList End");
		
		return json;
	}
	
	/**
	 * 포들릿 - 커뮤니티 허가여부
	 */
	@RequestMapping(value="/ezNewPortal/getCommunityPermit.do", method=RequestMethod.GET)
	@ResponseBody
	public String communityPermit(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model, Locale locale) throws Exception {
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
	 * 포틀릿 - 도움말
	 */
	@RequestMapping(value = "/ezNewPortal/helpPortlet.do", method=RequestMethod.GET)
	public String portalHelpPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalHelpPortlet Start");
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("usedTheme", Integer.parseInt(req.getParameter("usedTheme")));
		model.addAttribute("lang",userInfo.getLang());
		
		return "/ezNewPortal/portlets/helpPortlet";
	}
	
	/**
	 * 포틀릿 - 환율 포틀릿
	 */
	@RequestMapping(value = "/ezNewPortal/currencyPortlet.do", method=RequestMethod.GET)
	public String portalCurrencyPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("portalCurrencyPortlet Start");
		
		model.addAttribute("usedTheme", Integer.parseInt(req.getParameter("usedTheme")));
		
		RestTemplate restTemplate = new RestTemplate();
		String json = restTemplate.getForObject("http://fx.kebhana.com/FER1101M.web", String.class);
		json = json.replaceAll("var exView = ", "");
		json = json.substring(0, json.lastIndexOf(",")) + json.substring(json.lastIndexOf(",") + 1);

		/*ObjectMapper mapper = new ObjectMapper();
		HashMap<String, Object> map2 = mapper.readValue(json, HashMap.class);
		ArrayList<Map<String, Object>> list = (ArrayList<Map<String, Object>>) map2.get("리스트");
		String exchangeRate = (String) list.get(0).get("송금_전신환보내실때");*/
		
		return "/ezNewPortal/portlets/currencyPortlet";
	}
	
	/**
	 * 포틀릿 - 날씨
	 */
	@RequestMapping(value = "/ezNewPortal/weatherPortlet.do", method=RequestMethod.GET)
	public String portalWeatherePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalWeatherePortlet Start");
		
		model.addAttribute("usedTheme", Integer.parseInt(req.getParameter("usedTheme")));
		model.addAttribute("portletName", req.getParameter("portletName"));
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("tenantId", userInfo.getTenantId());
		String url = "/rest/ezPortal/portlets/weather";

		/*
			한국			-
			미국			- 뉴욕(5128638) 댈러스(5186266) 덴버(5186794) 로스앤젤레스(5368361) 맨해튼(5664535) 보스턴(4930956) 브롱크스(5110253) 브루클린(5110302) 산호세(5392171) 샌디에이고(4726311)
						  샌안토니오(4171771) 시카고(4887398) 애틀랜타(4883772) 오스틴(5016884) 워싱턴 D.C.(4140963) 콜롬버스(4188985) 퀸스(5133268) 피닉스(4905873) 필라델피아(5131095) 휴스턴(5194369)


			일본			- 도쿄 오사카 오카야마 니가타 나고야 나가모 교토 카고시마 히로시마 후쿠오카 마츠야마 후쿠시마 사포로 아오모리 아사이


			중국			- 광저우(1809858) 구이양(1809461) 난닝(1799869) 난징(1799962) 난창(1800163) 란저우(1804430) 베이징(1816670) 상하이(1796236) 선양(2034937) 스자좡(1795268) 지난(1805753) 창사(1815549) 창춘(1815771) 청두(1815286)
			 			  충칭(1814906) 쿤밍(1804651) 푸저우(1810821) 하얼빈(2037013) 항저우(1808926) 허페이(1808722)


			베트남		- 깐토(1586203) 꾸이년(1568574) 냐짱(1572151) 다낭(1905468) 바비(8201616) 비엔호아(1587923) 하노이(1581130) 하이퐁(1581298) 호찌민(1566083) 후에(1580240)


			인도네시아	- 덴파사르(1645528) 드폭(8144495) 마카사르(1622786) 메단(1214520) 바탐(8144723) 반다르람풍(1624917) 반둥(1650357) 반자르마신(1650213) 보고르(7780016) 수라바야(8018250) 스마랑(1627896)
			 			  암본(1651531) 자카르타(1642911) 잠비(1642858) 탕에랑(1625084) 팔렘방(1633070)


			TBL_WEATHER
			  PRIMARYLANG : 날씨 포틀릿에서 현재 selectBox에 선택된 국가에 대한 설정 분기로 사용

			TBL_WEATHER_CITY
			  USERLOCALLANG : 사용자 설정 언어로 해당 국가의 지역 이름을 번역하여 보여주기 위해 사용
		*/

		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, req, "get", null);
		String result = resultBody.get("status").toString();
		
		if (result.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			model.addAttribute("lang", data.get("lang"));
			model.addAttribute("cityList", data.get("cityList"));
			//sn이 아니라 cityCode 가 와야함
			model.addAttribute("cityCode", data.get("cityCode"));
			model.addAttribute("countryCode", data.get("countryCode"));
			model.addAttribute("displayName", data.get("displayName"));
			model.addAttribute("currentWeather", data.get("currentWeather"));
			model.addAttribute("todayWeather", data.get("todayWeather"));
			model.addAttribute("todayHours", data.get("todayHours"));
		}
		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("userInfo", userInfo);

		String useJP = ezCommonService.getTenantConfig("useJapanese", userInfo.getTenantId());
		String useCN = ezCommonService.getTenantConfig("useChinese", userInfo.getTenantId());
		String useVN = ezCommonService.getTenantConfig("useVietnamese", userInfo.getTenantId());
		String useID = ezCommonService.getTenantConfig("useIndonesian", userInfo.getTenantId());

		model.addAttribute("useJP", useJP);
		model.addAttribute("useCN", useCN);
		model.addAttribute("useVN", useVN);
		model.addAttribute("useID", useID);
		model.addAttribute("codeJP", useJP.equals("YES") ? "3" : "");
		model.addAttribute("codeCN", useCN.equals("YES") ? "4" : "");
		model.addAttribute("codeVN", useVN.equals("YES") ? "5" : "");
		model.addAttribute("codeID", useID.equals("YES") ? "6" : "");

		logger.debug("portalWeatherePortlet End");
		
		return "/ezNewPortal/portlets/weatherPortlet";
	}
	
	/**
	 * 포틀릿 - 날씨 변경
	 */
	@RequestMapping(value = "/ezNewPortal/weatherPortletChange.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject portalWeatherePortletChange(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalWeatherePortletChange Start");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		String cityCode = req.getParameter("cityCode");
		String countryCode = req.getParameter("countryCode");
		
		param.put("userId", userInfo.getId());
		param.put("tenantId", userInfo.getTenantId());
		param.put("cityCode", cityCode);
		param.put("countryCode", countryCode);
		String url = "/rest/ezPortal/portlets/weather";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, req, "get", null);
		
		JSONObject data = (JSONObject) resultBody.get("data");
		
		logger.debug("portalWeatherePortletChange End");
		
		return data;
	}
	
	/////포틀릿 정보만 가져오기
	@RequestMapping(value = "/ezNewPortal/getPhotoItemList.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject portalPhotoItemList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie,HttpServletResponse resp) throws Exception {
		logger.debug("portalPhotoItemList Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String url = "/rest/ezPortal/portlets/photoBoard";
		int page = Integer.parseInt(req.getParameter("page"));
		int photoCount = Integer.parseInt(req.getParameter("photoCount"));
		String portletId = req.getParameter("portletId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("photoCount", photoCount);
		param.put("currentPage", page);
		param.put("portletId", portletId);
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String result = resultBody.get("status").toString();
		JSONObject data = new JSONObject();
		
		if (result.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
		}
		
		logger.debug("portalPhotoItemList Ended");
		return data;
	}
	
	/**
	 * 포틀릿 - 생일자
	 */
	@RequestMapping(value = "/ezNewPortal/birthdayPortlet.do", method=RequestMethod.GET)
	public String portalBirthdayPortlet(HttpServletRequest req, Model model) throws Exception {
		logger.debug("portalBirthdayPortlet Start");
		
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		model.addAttribute("portletName", req.getParameter("portletName"));
		
		Calendar cal = Calendar.getInstance();
		String nowMonth = String.valueOf(cal.get(Calendar.MONTH)+1);
		model.addAttribute("nowMonth", nowMonth);
		
		logger.debug("portalBirthdayPortlet End");
		return "/ezNewPortal/portlets/birthdayPortlet";
	}
	
	/**
	 * 포틀릿 - 슬라이드 이미지
	 */
	@RequestMapping(value = "/ezNewPortal/slideImagePortlet.do", method=RequestMethod.GET)
	public String portalSlideImagePortlet(HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("portalSlideImagePortlet Start");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/admin/ezportal/slideimages/companies/" + userInfo.getCompanyID();
		
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
	@RequestMapping(value = "/ezNewPortal/userInfoPortlet.do", method=RequestMethod.GET)
	public String portalUserInfoPortlet(HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("portalUserInfoPortlet Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("deptId", userInfo.getDeptID());
		param.put("companyId", userInfo.getCompanyID());
		param.put("jobId", userInfo.getJobId());
		param.put("lang", userInfo.getLang());
		
		
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
			model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
			
			// 2023-05-16 장혜연 : 사용자 정보 포틀릿에 최종접속IP 표시
			model.addAttribute("lastLoginIP", data.get("lastLoginIP"));
		}
		
		logger.debug("portalUserInfoPortlet End");
		return "/ezNewPortal/portlets/userInfoPortlet";
	}
	
	/**
	 * 2018-11-09 홍승비 - 동영상게시판 포틀릿
	 */
	@RequestMapping(value = "/ezNewPortal/movieBoardPortlet.do", method=RequestMethod.GET)
	public String portalMovieBoardPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie,HttpServletResponse resp) throws Exception {
		logger.debug("portalMovieBoardPortlet Start");
		
		model.addAttribute("usedTheme", Integer.parseInt(req.getParameter("usedTheme")));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = req.getParameter("portletId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("currentPage", 1);
		param.put("photoCount", 1);
		param.put("portletId", portletId);
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
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
				model.addAttribute("movieBoardList", data.get("photoBoardList"));
			}
		}
		
		model.addAttribute("portletId", portletId);
		logger.debug("allValues: " + model);
		logger.debug("portalMovieBoardPortlet End");
		return "/ezNewPortal/portlets/movieBoardPortlet";
	}
	
	
	/**
	 * 포틀릿 - 자원관리
	 */
	@RequestMapping(value = "/ezNewPortal/resourcePortlet.do", method=RequestMethod.GET)
	public String portalResourcePortlet(HttpServletRequest req, Model model) throws Exception {
		logger.debug("portalResourcePortlet Start");
		
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("resPortletId", ezNewPortalService.getResportletId());
		
		logger.debug("portalResourcePortlet End");
		return "/ezNewPortal/portlets/resourcePortlet";
	}
	
	/**
	 * 포틀릿 - 협업 포틀릿
	 */
	@RequestMapping(value="/ezNewPortal/ezWorkspacePortlet.do", method=RequestMethod.GET)
	public String ezWorkspacePortlet(HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("ezWorkspacePortlet Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String workspaceHostUrl = ezCommonService.getTenantConfig("workspaceHostUrl", userInfo.getTenantId());
		String workspaceContextRootUrl = ezCommonService.getTenantConfig("workspaceContextRootUrl", userInfo.getTenantId());
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("usedTheme", Integer.parseInt(req.getParameter("usedTheme")));
		model.addAttribute("workspaceHostUrl", workspaceHostUrl);
		model.addAttribute("workspaceContextRootUrl", workspaceContextRootUrl);
		
		logger.debug("ezWorkspacePortlet End");
		return "/ezNewPortal/portlets/ezWorkspacePortlet";
	}

	/**
	 * 포틀릿 - 협업 디자인용 더미 포틀릿
	 */
	@RequestMapping(value="/ezNewPortal/ezWorkspaceDummy.do", method=RequestMethod.GET)
	public String ezWorkspaceDummy() throws Exception {
		return "/ezNewPortal/portlets/ezWorkspaceDummy";
	}
	
	/**
	 * 포틀릿 - 게시판 포틀릿
	 */
	@RequestMapping(value = "/ezNewPortal/boardPortlet.do", method=RequestMethod.GET)
	public String portalBoardPortlet(HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("portalBoardPortlet Start");
		
		model.addAttribute("usedTheme", Integer.parseInt(req.getParameter("usedTheme")));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = req.getParameter("portletId");
		String type = Optional.ofNullable(req.getParameter("type")).orElse("");
		String fileName = Optional.ofNullable(req.getParameter("fileName")).orElse("");
		HashMap<String, Object> param = new HashMap<>();
		param.put("userId", userInfo.getId());
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		param.put("currentPage", 1);
		param.put("photoCount", 5);
		param.put("portletId", portletId);
		param.put("fileName", fileName);
		String url = "/rest/ezPortal/portlets/board";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String result = resultBody.get("status").toString();
		
		if (result.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			String access = data.get("access").toString();
			model.addAttribute("access", access);
			model.addAttribute("boardId", data.get("boardId"));
			model.addAttribute("portletName", data.get("portletName"));
			
			if (access.equals("true")) {
				model.addAttribute("boardList", data.get("boardList"));
			}
		}
		
		model.addAttribute("portletId", portletId);
		model.addAttribute("type", type);
		model.addAttribute("fileName", fileName);
		logger.debug("portalBoardPortlet End");
		
		return "/ezNewPortal/portlets/boardPortlet";
	}
	
	@RequestMapping(value = "/ezNewPortal/getCustomBoardInfo.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject getCustomBoardInfo(HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getCustomBoardInfo Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = req.getParameter("portletId");
		String fileName = Optional.ofNullable(req.getParameter("fileName")).orElse("");
		Integer photoCount = Optional.ofNullable(req.getParameter("count")).map(Integer::parseInt).orElse(5);
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		param.put("currentPage", req.getParameter("currentPage"));
		param.put("photoCount", photoCount);
		param.put("portletId", portletId);
		param.put("fileName", fileName);
		String url = "/rest/ezPortal/portlets/board";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String result = resultBody.get("status").toString();
		JSONObject data = new JSONObject();
		
		if (result.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
		}
		
		model.addAttribute("portletId", portletId);
		logger.debug("portalBoardPortlet End");
		
		return data;
	}
	
	/**
	 * 포틀릿 - 카운트
	 */
	@RequestMapping(value = "/ezNewPortal/countPortlet.do", method=RequestMethod.GET)
	public String portalCountPortlet(HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("portalCountPortlet Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		
		String url = "/rest/ezportal/portlets/count/"+ userId;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			// model.addAttribute("pollCount", data.get("pollCount"));
			model.addAttribute("unResponseIngSurveyCnt", data.get("surveyCnt"));
			model.addAttribute("circularCount", data.get("circularCount"));
			model.addAttribute("scheduleCount", data.get("scheduleCount"));
			model.addAttribute("approvalCount", data.get("approvalCount"));
			model.addAttribute("approvalProgressingCount", data.get("approvalProgressingCount"));
			model.addAttribute("approvalDraftCount", data.get("approvalDraftCount"));
			model.addAttribute("approvalDeptSusinCount", data.get("approvalDeptSusinCount"));
			model.addAttribute("unreadMailCount", data.get("unreadMailCount"));
			model.addAttribute("useCircular", data.get("useCircular"));
			// model.addAttribute("useQuestion", data.get("useQuestion"));
			model.addAttribute("useSurvey", data.get("useSurvey"));
			model.addAttribute("useMail", data.get("useMail"));
			model.addAttribute("useApproval", data.get("useApproval"));
			model.addAttribute("useSchedule", data.get("useSchedule"));
			model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		}
		
		logger.debug("portalCountPortlet End");
		return "/ezNewPortal/portlets/cntPortlet"; 
	}
	

	@RequestMapping(value = "/ezNewPortal/getCountList.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject getCountList(HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getCountList Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		
		String url = "/rest/ezportal/portlets/count/"+ userId;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		
		String status = resultBody.get("status").toString();
		
		JSONObject result = new JSONObject();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			result = data;
		}
		
		logger.debug("getCountList End");
		return result; 
	}
	
	@RequestMapping(value = "/ezNewPortal/errorPortlet.do", method=RequestMethod.GET)
	public String errorPortlet(HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("errorPortlet Start");
		logger.debug("errorPortlet End");
		return "/ezNewPortal/portlets/errorPortlet"; 
	}
	
	public String specialCharacterToEmptyString(String value) {
		value = value.replaceAll("\'", "");
		value = value.replaceAll("\"", "");
		value = value.replaceAll("\\+", "");
		value = value.replaceAll("@", "");
		value = value.replaceAll("\\$", "");
		value = value.replaceAll("AND ", "");
		value = value.replaceAll("OR ", "");
		value = value.replaceAll("and ", "");
		value = value.replaceAll("or ", "");
		value = value.replaceAll(";", "");
		value = value.replaceAll("%", "");
		value = value.replaceAll("#", "");
		value = value.replaceAll(":", "");
        value = value.replaceAll("<", "& lt;").replaceAll(">", "& gt;");
        value = value.replaceAll("\\(", "& #40;").replaceAll("\\)", "& #41;");
        value = value.replaceAll("'", "& #39;");
        value = value.replaceAll("eval\\((.*)\\)", "");
        value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
        value = value.replaceAll("script", "");
		
		return value;
	}
	
	/**
	 * 포틀릿 - 웹폴더
	 */
	@RequestMapping(value = "/ezNewPortal/webFolderPortlet.do", method=RequestMethod.GET)
	public String webFolderPortlet(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("webFolderPortlet Start");
		
		model.addAttribute("portletId", request.getParameter("portletId"));
		model.addAttribute("portletName", request.getParameter("portletName"));
		model.addAttribute("usedTheme", commonUtil.isIntNumber(request.getParameter("usedTheme"), 1));
		
		logger.debug("webFolderPortlet End");
		return "/ezNewPortal/portlets/webFolderPortlet"; 
	}
	
	/**
	 * 포틀릿 - 웹폴더
	 */
	@RequestMapping(value = "/ezNewPortal/getWebFolderFileList.do", method=RequestMethod.GET)
	public String getWebFolderFileList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getWebFolderFileList Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("currentPage", request.getParameter("currentPage"));
		param.put("listSize",  request.getParameter("listSize"));
		
		String url = "/rest/ezportal/portlets/getWebFolderFileList";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("data", resultBody.get("data"));
		}
		
		logger.debug("getWebFolderFileList End");
		return "json"; 
	}
	
	/**
	 * 포틀릿 - 전자설문
	 */
	@RequestMapping(value = "/ezNewPortal/surveyPortlet.do", method=RequestMethod.GET)
	public String portalSurveyPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("portalSurveyPortlet Start");
		model.addAttribute("portletId", req.getParameter("portletId"));
		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		
		logger.debug("portalSurveyPortlet End");
		return "/ezNewPortal/portlets/surveyPortlet";
	}
	/*
	 * 2020-12-03 탭게시판 포틀릿 - 박기범
	*/
	@RequestMapping(value = "/ezNewPortal/tabBoardPortlet.do", method=RequestMethod.GET)
	public String tabBoardPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("tabBoardPortlet Start");
		
		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		
		logger.debug("tabBoardPortlet End");
		return "/ezNewPortal/portlets/tabBoardPortlet";
	}
	
	// 2020-12-04 탭게시판 리스트 가져오기 - 박기범
	@RequestMapping(value = "/ezNewPortal/getTabBoardPortlet.do", method=RequestMethod.GET)
	public String getTabBoardPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getTabBoardPortlet Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("portletId", req.getParameter("portletId"));
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		String url = "/rest/ezPortal/portlets/tabBoard";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			String existence = data.get("existence").toString();
			
			if (existence.equals("true")) {
				model.addAttribute("tabList", data.get("tabList"));
				model.addAttribute("portletLang", data.get("portletLang").toString());
			}
			model.addAttribute("existence", existence);
		}
		
		logger.debug("getTabBoardPortlet End");
		return "json";
	}

	/**
	 * 포틀릿 - 전자문서 차트 :2021/02/23 박기범
	 */
	@RequestMapping(value = "/ezNewPortal/chartPortlet.do", method=RequestMethod.GET)
	public String elecDocChartPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("ChartPortlet Start");

		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));

		logger.debug("ChartPortlet End");
		return "/ezNewPortal/portlets/chartPortlet";
	}
	
	/**
	 * 2023-06-07 홍승비 - 테마2 > 상단 사용자 정보 영역 좌측 하단 > 회사별 공지사항 게시판 표출
	 * */
	@RequestMapping(value = "/ezNewPortal/getTheme2NotiBoardItemList.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONArray getTheme2NotiBoardItemList(HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getTheme2NotiBoardItemList Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = req.getParameter("boardID"); // 회사별 공지사항 게시판ID
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("boardID", boardID);
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		
		String url = "/rest/ezPortal/portlets/theme2NotiBoardItemList";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String result = resultBody.get("status").toString();
		JSONArray boardList = new JSONArray();
		
		if (result.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			String access = data.get("access").toString();
			
			if (access.equals("true")) {
				boardList = (JSONArray) data.get("boardList");
			}
		}
		
		logger.debug("getTheme2NotiBoardItemList End");
		
		return boardList;
	}

	/**
	 * 차트 포틀릿 - 2023/12/28 박기범
	 * 차트 포틀릿 표출용 샘플 데이터
	 */
	@GetMapping(value = "/ezNewPortal/sampleChartPortlet.do")
	@ResponseBody
	public List<List<ChartVO>> sampleChartPortlet(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("sampleChartPortlet Start");
				
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		int lang = 1;
		if (userInfo.getLang() != null && !"".equals(userInfo.getLang()) && !"1".equals(userInfo.getLang())) {
			lang = Integer.parseInt(userInfo.getLang());
			if (lang > 3) {
				lang = 2; // 영어, 일본어 외 언어 일 경우 추가
			}
		}
		
		String[] calendar = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
		String[][] documentLang = {{"Insend", "Outside"},{"内部文書", "外部文書"}}; // 영어 일본어
		
		List<List<ChartVO>> wholeList = new ArrayList<>();
		List<ChartVO> list = new ArrayList<>();
		SecureRandom random = SecureRandom.getInstanceStrong();
		if (lang == 1) {
			for (int i = 1; i <= 12; i++) {
				ChartVO vo = new ChartVO.ChartVOBuilder(i + "월", random.nextInt(50000))
						.groupTitle("대내문서")
						.build();
				list.add(vo);
			}
			for (int i = 1; i <= 12; i++) {
				ChartVO vo = new ChartVO.ChartVOBuilder(i + "월", random.nextInt(50000))
						.groupTitle("대외문서")
						.build();
				list.add(vo);
			}
			wholeList.add(list);

			List<ChartVO> list2 = new ArrayList<>();
			for (int i = 0; i <= 2; i++) {
				list2.add(new ChartVO.ChartVOBuilder(i + "번", random.nextInt(3000)).build());
			}
			wholeList.add(list2);
		} else {
			String title1 = documentLang[lang-2][0];
			String title2 = documentLang[lang-2][1];
			
			for (int i = 0; i < 12; i++) {
				ChartVO vo = new ChartVO.ChartVOBuilder(calendar[i], random.nextInt(50000))
						.groupTitle(title1)
						.build();
				list.add(vo);
			}
			for (int i = 0; i < 12; i++) {
				ChartVO vo = new ChartVO.ChartVOBuilder(calendar[i], random.nextInt(50000))
						.groupTitle(title2)
						.build();
				list.add(vo);
			}
			wholeList.add(list);

			List<ChartVO> list2 = new ArrayList<>();
			for (int i = 0; i <= 2; i++) {
				list2.add(new ChartVO.ChartVOBuilder(i + "", random.nextInt(3000)).build());
			}
			wholeList.add(list2);
		}
		
		logger.debug("sampleChartPortlet End");
		return wholeList;
	}

	@RequestMapping(value = "/ezNewPortal/iframePortlet.do", method=RequestMethod.GET)
	public String getIframePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getIframePortlet Start");

		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("portletId", req.getParameter("portletId"));
		model.addAttribute("iframeUrl", req.getParameter("iframeUrl"));
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));

		logger.debug("getIframePortlet End");
		return "/ezNewPortal/portlets/iframePortlet";
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezNewPortal/getBoardList.do", method=RequestMethod.GET)
	public JSONObject getBoardList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getBoardList Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		param.put("boardId", req.getParameter("boardId"));
		param.put("currentPage", req.getParameter("currentPage"));
		param.put("listCnt", req.getParameter("listCnt"));
		
		String url = "/rest/ezPortal/portlets/boardList";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String status = resultBody.get("status").toString();
		
		JSONObject data = new JSONObject();
		if (status.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
		}
		
		logger.debug("getBoardList End");
		return data;
	}
	
	@RequestMapping(value = "/ezNewPortal/connectionPortlet.do", method=RequestMethod.GET)
	public String connectionPortlet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("connectionPortlet started");
		
		model.addAttribute("portletId", req.getParameter("portletId"));
		model.addAttribute("portletName", req.getParameter("portletName"));
		model.addAttribute("usedTheme", commonUtil.isIntNumber(req.getParameter("usedTheme"), 1));
		
		logger.debug("connectionPortlet ended");
		
		return "/ezNewPortal/portlets/connectPortlet";
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezNewPortal/getConnectList.do", method=RequestMethod.GET)
	public JSONObject getConnectList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getConnectList Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());
		param.put("portletId", req.getParameter("portletId"));
		param.put("currentPage", req.getParameter("currentPage"));
		param.put("listCnt", req.getParameter("listCnt"));
		
		String url = "/rest/ezPortal/portlets/connect/list";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String status = resultBody.get("status").toString();
		
		JSONObject data = null;
		if (status.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
		}
		
		logger.debug("getConnectList End");
		return data;
	}
	

	@ResponseBody
	@RequestMapping(value = "/rest/testConnectPortletJSON.do", method=RequestMethod.POST)
	public JSONObject testConnectPortletJSON(HttpServletRequest req, @RequestBody Map<String, Object> jsonData) throws Exception {
		logger.debug("testConnectPortletJSON Start");
		
		JSONObject json = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		
		int listCnt = Integer.parseInt(jsonData.get("listCnt").toString());
		int startRow = Integer.parseInt(jsonData.get("startRow").toString());
		
		for (int i = startRow; i < startRow + listCnt && i < 30; i++) {
			JSONObject jsonVO = new JSONObject();
			jsonVO.put("title", i + "번째 글");
			jsonVO.put("writeDate", "2024-08-19 01:12:00");
			jsonVO.put("writeName", i + "번째 사람");
			jsonVO.put("linkUrl", "http://localhost:8080/test" + i);
			jsonVO.put("mobileLinkUrl", "http://localhost:8001/test" + i);
			
			jsonArray.add(jsonVO);
		}
		
		json.put("data", jsonArray);
		json.put("totalCnt", 30);
		
		logger.debug("testConnectPortletJSON End");
		return json;
	}
	
	@ResponseBody
	@RequestMapping(value = "/rest/testConnectPortletJSONtoXML.do", method=RequestMethod.POST, produces = "application/json;charset=utf-8")
	public String testConnectPortletJSONtoXML(HttpServletRequest req, @RequestBody Map<String, Object> jsonData) throws Exception {
		logger.debug("testConnectPortletJSON Start");
		
		String xml = "";
		
		int listCnt = Integer.parseInt(jsonData.get("listCnt").toString());
		int startRow = Integer.parseInt(jsonData.get("startRow").toString());
		xml += "<DATA>";
		xml += "<ROWS>";
		for (int i = startRow; i < startRow + listCnt && i < 30; i++) {
			xml += "<ROW>";
			xml += "<TITLE>" + i + "번째 글" + "</TITLE>";
			xml += "<WRITEDATE>" + "2024-08-19 01:12:00" + "</WRITEDATE>";
			xml += "<WRITENAME>" + i + "번째 사람" + "</WRITENAME>";
			xml += "<LINKURL>" + "http://localhost:8080/test" + i + "</LINKURL>";
			xml += "<MOBILELINKURL>" + "http://localhost:8001/test" + i + "</MOBILELINKURL>";
			xml += "</ROW>";
		}
		xml += "</ROWS>";
		xml += "<TOTALCNT>30</TOTALCNT>";
		xml += "</DATA>";
		
		logger.debug("testConnectPortletJSON End");
		return xml;
	}
	
	@ResponseBody
	@RequestMapping(value = "/rest/testConnectPortletXMLtoXML.do", method=RequestMethod.POST, produces = "application/json;charset=utf-8")
	public String testConnectPortletXMLtoXML(HttpServletRequest req, @RequestBody String xmlData) throws Exception {
		logger.debug("testConnectPortletJSON Start");
		
		String xml = "";
		
		Document doc = commonUtil.convertStringToDocument(xmlData);
		int listCnt = Integer.parseInt(doc.getElementsByTagName("listCnt").item(0).getTextContent());
		int startRow = Integer.parseInt(doc.getElementsByTagName("startRow").item(0).getTextContent());
		
		xml += "<DATA>";
		xml += "<ROWS>";
		for (int i = startRow; i < startRow + listCnt && i < 30; i++) {
			xml += "<ROW>";
			xml += "<TITLE>" + i + "번째 글" + "</TITLE>";
			xml += "<WRITEDATE>" + "2024-08-19 01:12:00" + "</WRITEDATE>";
			xml += "<WRITENAME>" + i + "번째 사람" + "</WRITENAME>";
			xml += "<LINKURL>" + "http://localhost:8080/test" + i + "</LINKURL>";
			xml += "<MOBILELINKURL>" + "http://localhost:8001/test" + i + "</MOBILELINKURL>";
			xml += "</ROW>";
		}
		xml += "</ROWS>";
		xml += "<TOTALCNT>30</TOTALCNT>";
		xml += "</DATA>";
		
		logger.debug("testConnectPortletJSON End");
		return xml;
	}
}
