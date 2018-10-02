package egovframework.ezEKP.ezPortal.web;

import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPoll.service.EzPollService;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPortalPortletController {
private static final Logger logger = LoggerFactory.getLogger(EzPortalPortletController.class);
	
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
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/noticePortlet.do")
	public String portalNoticePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalNoticePortlet Start");
		
		return "/ezNewPortal/noticePortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/receivedMailPortlet.do")
	public String portalReceivedMailPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalReceivedMailPortlet Start");
		
		return "/ezNewPortal/receivedMailPortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/votePortlet.do")
	public String portalVotePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalVotePortlet Start");
		
		return "/ezNewPortal/votePortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/pollPortlet.do")
	public String portalPollPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalNoticePortlet Start");
		
		return "/ezNewPortal/pollPortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/schedulePortlet.do")
	public String portalSchedulePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalSchedulePortlet Start");
		
		return "/ezNewPortal/schedulePortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/approvalListPortlet.do")
	public String portalApprovalListPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalApprovalListPortlet Start");
		
		return "/ezNewPortal/approvalListPortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/approvalFavoritePortlet.do")
	public String portalApprovalFavoritePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalApprovalFavoritePortlet Start");
		
		return "/ezNewPortal/approvalFavoritePortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/photoBoardPortlet.do")
	public String portalPhotoBoardPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalPhotoBoardPortlet Start");
		
		return "/ezNewPortal/photoBoardPortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/favoriteBoardPortlet.do")
	public String portalFavoriteBoardPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalFavoriteBoardPortlet Start");
		
		return "/ezNewPortal/favoriteBoardPortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/communityPortlet.do")
	public String portalCommunityPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalCommunityPortlet Start");
		
		return "/ezNewPortal/communityPortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/helpPortlet.do")
	public String portalHelpPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalHelpPortlet Start");
		
		return "/ezNewPortal/helpPortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/currencyPortlet.do")
	public String portalCurrencyPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalCurrencyPortlet Start");
		
		return "/ezNewPortal/currencyPortlet";
	}
	
	/**
	 * 포틀릿 - 공지사항
	 */
	@RequestMapping(value = "/ezNewPortal/weatherPortlet.do")
	public String portalWeatherePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalWeatherePortlet Start");
		
		return "/ezNewPortal/weatherPortlet";
	}
	
	
}
