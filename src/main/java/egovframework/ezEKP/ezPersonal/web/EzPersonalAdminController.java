package egovframework.ezEKP.ezPersonal.web;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.lang.reflect.Field;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalAdminService;
import egovframework.ezEKP.ezPersonal.vo.PersonalEmpMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollConfigVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopopConfigVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopupUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalQuickLinkVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/** 
 * @Description [Controller] 관리자 - 초기화면
 * @author 오픈솔루션팀 이효진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.08.30    이효진         신규작성
 * @see
 */

@Controller("EzPersonalAdminController")
public class EzPersonalAdminController extends EgovFileMngUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzPersonalAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzPersonalAdminService ezPersonalAdminService;
	
	@Autowired
	private EzNewPortalService ezNewPortalService;
	/**
	 * 초기화면 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/personalMain.do", method = RequestMethod.GET)
	public String personalMain () throws Exception {
		return "admin/ezPersonal/personalMain";
	}
	
	/**
	 * 초기화면 왼쪽메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/personalLeft.do", method = RequestMethod.GET)
	public String personalLeft (@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("personalLeft started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
        //baonk 추가
        String pollFlag = "";
        if (ezCommonService.getTenantConfig("useBallotSystem", userInfo.getTenantId()).equalsIgnoreCase("YES")) {
        	pollFlag = "YES";
        }
        else {
        	pollFlag = "NO";
        }
        //end		
		
		String usePortal = ezCommonService.getTenantConfig("Use_portal", userInfo.getTenantId());
		
		model.addAttribute("usePortal", usePortal);
		model.addAttribute("pollFlag", pollFlag);

		logger.debug("personalLeft ended");
		return "admin/ezPersonal/personalLeft";
	}
	
	/**
	 * 초기화면 공지사항메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/manageNotice.do", method = RequestMethod.GET)
	public String manageNotice (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("manageNotice started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("list", resultList);

		logger.debug("manageNotice ended");
		return "admin/ezPersonal/personalManageNotice";
	}
	
	/**
	 * 초기화면 공지사항 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/manageNoticeList.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public ResponseEntity<String> manageNoticeList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("manageNoticeList started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("manageNoticeList accessDenied");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}
		
		String companyID = request.getParameter("id");
		int currentPage = Integer.parseInt(request.getParameter("page"));
		
		StringBuilder result = new StringBuilder();
		int pageSize = 12;
		int cnt = 0;
		
		int totalCount = ezPersonalAdminService.getNoticeCount(companyID, userInfo.getTenantId());
		int pageCount = (int)((totalCount + pageSize - 1) / pageSize);
		int iSn = Math.subtractExact(totalCount, Math.multiplyExact(Math.subtractExact(currentPage, 1), 12));
		
		result.append("<LISTVIEWDATA>");
		result.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		result.append("<PAGECNT>" + pageCount + "</PAGECNT>");
		result.append("<CURPAGE>" + currentPage + "</CURPAGE>");
		result.append("<CNT>" + cnt + "</CNT>");
		
		List<PersonalNoticeVO> list = ezPersonalAdminService.getNoticeList(companyID, totalCount, pageSize, Math.multiplyExact(Math.subtractExact(currentPage, 1), pageSize), userInfo.getTenantId());
		
		result.append("<ROWS>");
		
		for (PersonalNoticeVO vo : list) {
			result.append("<ROW><CELL><VALUE>" + iSn + "</VALUE>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1></CELL>");
			
			result.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getTitle()) + "</VALUE></CELL>");
			result.append("<CELL><VALUE>" + commonUtil.getDateStringInUTC(vo.getPostDate(), userInfo.getOffset(), false).substring(0, 10) + "</VALUE></CELL>");
			result.append("<CELL><VALUE>" + egovMessageSource.getMessage("ezPersonal.t169", userInfo.getLocale()) + "</VALUE>");
			result.append("<TYPE>BTN</TYPE>");
			result.append("<FUNC>mod_notice</FUNC>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1></CELL>");
			result.append("<CELL><VALUE>" + egovMessageSource.getMessage("ezPersonal.t99", userInfo.getLocale()) + "</VALUE>");
			result.append("<TYPE>BTN</TYPE>");
			result.append("<FUNC>del_notice</FUNC>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			result.append("<DATA2>" + iSn + "</DATA2></CELL></ROW>");
			
			iSn--;
		}
		
		result.append("</ROWS></LISTVIEWDATA>");
		
		logger.debug("manageNoticeList ended");
		return ResponseEntity.ok().body(result.toString());
	}
	
	/**
	 * 초기화면 공지사항 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/delNotice.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8") 
	@ResponseBody
	public String delNotice(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request) throws Exception {
		logger.debug("delNotice started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemSeq = request.getParameter("itemSeq");
		
		String result = ezPersonalAdminService.deleteNotice(itemSeq, userInfo.getTenantId());

		logger.debug("delNotice ended");
		return result;
	}
	
	/**
	 * 초기화면 공지사항 등록,수정화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/addNoticeCK.do", method = RequestMethod.GET)
	public String addNoticeCK(@CookieValue("loginCookie") String loginCookie, PersonalNoticeVO vo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("addNoticeCK started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		String itemSeq = "";
		
		if (request.getParameter("itemSeq") != null) {
			itemSeq = request.getParameter("itemSeq");
			
			vo = ezPersonalAdminService.getNoticeInfo(itemSeq, userInfo.getTenantId());
			vo.setContent(vo.getContent().replace("\r\n", "").replace("\n", "").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&apos;", "\'"));
		}
		
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("personalNoticeVO", vo);

		logger.debug("addNoticeCK ended");
		return "admin/ezPersonal/personalAddNoticeCK";
	}
	
	/**
	 * 초기화면 공지사항 등록,수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/saveNotice.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveNotice(@CookieValue("loginCookie") String loginCookie,@ModelAttribute PersonalNoticeVO vo) throws Exception {
		logger.debug("saveNotice started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (vo.getTitle2() == null) {
			vo.setTitle2(vo.getTitle());
		}
		
		if (vo.getItemSeq() == null) {
			String result = ezPersonalAdminService.insertNotice(vo.getCompanyID(), vo.getTitle(), vo.getTitle2(), vo.getContent(), userInfo.getTenantId());
			logger.debug("saveNotice ended");
			return result;
		} else {
			String result = ezPersonalAdminService.updateNotice(vo.getCompanyID(), vo.getTitle(), vo.getTitle2(), vo.getContent(), vo.getItemSeq(), userInfo.getTenantId());
			logger.debug("saveNotice ended");
			return result;
		}
	}
	
	/**
	 * 초기화면 공지사항 본문화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/showNotice.do", method = RequestMethod.GET)
	public String showNotice(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("showNotice started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemSeq = request.getParameter("itemSeq");
		
		PersonalNoticeVO vo = ezPersonalAdminService.getNoticeInfo(itemSeq, userInfo.getTenantId());
		
		if (vo.getTitle2() == null) {
			vo.setTitle2(vo.getTitle());
		}
		vo.setContent(vo.getContent().replace("<a ", "<a target='_blank'").replace("<A ", "<A target='_blank'"));
		vo.setPostDate(vo.getPostDate().substring(0, 10));
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("personalNoticeVO", vo);

		logger.debug("showNotice ended");
		return "admin/ezPersonal/personalShowNotice";
	}
	
	/**
	 * 초기화면 QuickLink메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/manageQuickLink.do", method = RequestMethod.GET)
	public String manageQuickLink(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model)  throws Exception {
		logger.debug("manageQuickLink started");

		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		String companyId = "";
		if (request.getParameter("companyId") != null) {
			companyId = request.getParameter("companyId");
		} else {
			companyId = "";
		}

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(auth.getPrimary(), auth.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();

		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (auth.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(auth.getCompanyID())) {
				resultList.add(vo);
			}
		}

		String userLang = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("host", auth.getServerName());
		model.addAttribute("lang", auth.getLang());
		model.addAttribute("list", resultList);
		model.addAttribute("companyId", companyId);
		model.addAttribute("userPrimanryLang", userLang);

		logger.debug("manageQuickLink ended");
		return "admin/ezPersonal/personalManageQuickLink";
	}
	
	/**
	 * 초기화면 QuickLink 목록 호출 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/getQuickLinkList.do", method = RequestMethod.GET, produces = "application/json; charset=utf-8")
	@ResponseBody
	public JSONObject getQuickLinkList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getQuickLinkList started company:" + request.getParameter("companyID"));

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String lang = userInfo.getLang();
		String companyID = Optional.ofNullable(request.getParameter("companyID")).orElse(userInfo.getCompanyID());

		String userLang = "1";
		
		if (primaryLang.equals(lang)) {
			userLang = "1";
		} else {
			userLang = lang;
		}
		
		List<PersonalQuickLinkVO> list = ezPersonalAdminService.getQuickLinkList(userInfo, userInfo.getLang(), userLang, companyID);
		
		JSONObject json = new JSONObject();
		json.put("list", list);
		
		logger.debug("getQuickLinkList ended");
		return json;
	}
	
	/**
	 * 초기화면 QuickLink 등록,수정화면 호출 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/addQuickLink.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject addQuickLink(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("addQuickLink started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = "new";
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		JSONObject json = new JSONObject();
		json.put("strUserLang", commonUtil.getMultiData(userInfo.getLang(),userInfo.getTenantId()));
		json.put("primary", primaryLang);
		json.put("mode", mode);
		json.put("lang", userInfo.getLang());
		
		// 2023-11-23 조소정 - 관리자 > 포탈 > 빠른링크 > 일본어, 중국어 사용 여부에 따라 링크 이름 표출/미표출 구현
		json.put("useJapanese", ezCommonService.getTenantConfig("useJapanese", userInfo.getTenantId()));
		json.put("useChinese", ezCommonService.getTenantConfig("useChinese", userInfo.getTenantId()));
		json.put("useVietnamese", ezCommonService.getTenantConfig("useVietnamese", userInfo.getTenantId()));
		json.put("useIndonesian", ezCommonService.getTenantConfig("useIndonesian", userInfo.getTenantId()));

		logger.debug("addQuickLink ended");
		return json;
	}
	
	/**
	 * 초기화면 QuickLink 수정화면 내용 호출 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/getQuickLink.do", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public JSONObject getQuickLink(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request) throws Exception {
		logger.debug("getQuickLink started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String quickLinkID = request.getParameter("pQuickLinkID");
		
		PersonalQuickLinkVO quickLinkVO = ezPersonalAdminService.getQuickLink(quickLinkID, userInfo.getTenantId());
		
		JSONObject json = new JSONObject();
		json.put("quickLinkVO", quickLinkVO);
		
		logger.debug("getQuickLink ended");
		return json;
	}
	
	/**
	 * 초기화면 QuickLink 권한목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/getQuickLinkACL.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getQuickLinkACL(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request) throws Exception {
		logger.debug("getQuickLinkACL started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String quickLinkID = request.getParameter("pQuickLinkID");
		
		String result = ezPersonalAdminService.getQuickLinkACL(quickLinkID, userInfo.getTenantId());

		logger.debug("getQuickLinkACL ended");
		return result;
	}
	
	/**
	 * 초기화면 QuickLink 권한등록화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/selectTargetQuickLink.do", method = RequestMethod.GET)
	public String selectTarget(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("selectTarget started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String topID = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topID = userInfo.getCompanyID();
		} else {
			topID = "Top";
		}
		
		model.addAttribute("strUserLang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("topID", topID);

		logger.debug("selectTarget ended");
		return "admin/ezPersonal/personalSelectTargetQuickLink";
	}
	
	/**
	 * 초기화면 QuickLink 등록,수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/saveQuickLink.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void  saveQuickLink(@CookieValue("loginCookie") String loginCookie, @RequestBody String data) throws Exception {
		logger.debug("saveQuickLink started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		
		ezPersonalAdminService.saveQuickLink(userInfo, doc);

		logger.debug("saveQuickLink ended");
	}
	
	/**
	 * 초기화면 QuickPoll메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/managePoll.do", method = RequestMethod.GET)
	public String managePoll(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("managePoll started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		logger.debug("managePoll ended");
		return "admin/ezPersonal/personalManagePoll";
	}
	
	/**
	 * 초기화면 QuickPoll 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/managePollList.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String managePollList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("managePollList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int currentPage = 1, pageSize = 15;
		String progressPollFlag = "false";
		String progressSDate = "";
		String progressEDate = "";
		StringBuilder result = new StringBuilder();
		
		String companyID = request.getParameter("companyID");
		
		if (request.getParameter("page") != null) {
			currentPage = Integer.parseInt(request.getParameter("page"));
		}

		// 2023-01-16 전인하 - 빠른설문 > DB에 들어가는 값이 UTC 시간으로 변경됨에 따라 타임존 처리 추가
		String offset = userInfo.getOffset();
		PersonalLightPollVO progressFlagVO = ezNewPortalService.getPollPortlet(userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getId(), offset);
		if(progressFlagVO != null) {
			progressPollFlag = "true";
			progressSDate = commonUtil.getDateStringInUTC(progressFlagVO.getStartDate(), offset, false);
			progressEDate = commonUtil.getDateStringInUTC(progressFlagVO.getEndDate(), offset, false);
		}

		int totalCount = ezPersonalAdminService.getPollCount(companyID, userInfo.getTenantId());
		int pageCount = (int)((totalCount + pageSize - 1) / pageSize);
		List<PersonalLightPollVO> list = ezPersonalAdminService.getPollList(companyID, totalCount, pageSize, Math.multiplyExact(Math.subtractExact(currentPage, 1), pageSize), userInfo.getTenantId());

		result.append("<LISTVIEWDATA>");
		result.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		result.append("<PAGECNT>" + pageCount + "</PAGECNT>");
		result.append("<CURPAGE>" + currentPage + "</CURPAGE>");
		result.append("<ROWS>");

		for (int i = 0; i < list.size(); i++) {
			PersonalLightPollVO vo = list.get(i);
			String startDate = commonUtil.getDateStringInUTC(vo.getStartDate(), offset, false);
			String endDate = commonUtil.getDateStringInUTC(vo.getEndDate(), offset, false);

			result.append("<ROW>");
			result.append("<CELL>"); 
			result.append("<VALUE>" + vo.getItemSeq() +"</VALUE>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");								// itemSeq
			result.append("</CELL>");
			result.append("<CELL>"); 
			result.append("<VALUE>" + Math.subtractExact(totalCount, Math.addExact(Math.multiplyExact(pageSize, Math.subtractExact(currentPage, 1)), i)) + "</VALUE>");	// number
			result.append("</CELL>");
			//2023-08-03 이주원 - 빠른 설문 제목 다국어 표시
			if (userInfo.getLang().equals("2")){
				result.append("<CELL>");
				result.append("<VALUE>" + commonUtil.cleanValue(vo.getPollTitle2()) + "</VALUE>");		// title
				result.append("</CELL>");
			} else {
				result.append("<CELL>");
				result.append("<VALUE>" + commonUtil.cleanValue(vo.getPollTitle()) + "</VALUE>");		// title
				result.append("</CELL>");
			}

			result.append("<CELL>");
			result.append("<VALUE>" + startDate.substring(0, 10) + "</VALUE>");	// startDate
			result.append("</CELL>");
			result.append("<CELL>");
			result.append("<VALUE>" + endDate.substring(0, 10) + "</VALUE>");
			result.append("</CELL>");

			// 진행여부
			result.append("<CELL>");
			if(vo.getProgress() == 1) {
				result.append("<VALUE>" + "1" + "</VALUE>");	// 진행중
				result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			} else {
				result.append("<VALUE>" + "0" + "</VALUE>");	// 삭제
				result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			}
			result.append("</CELL>");
			result.append("</ROW>");
		}

		result.append("</ROWS>");
		result.append("<PROFLAG>" + progressPollFlag + "</PROFLAG>");
		result.append("<PROFLAGSDATE>" + progressSDate + "</PROFLAGSDATE>");
		result.append("<PROFLAGEDATE>" + progressEDate + "</PROFLAGEDATE>");
		result.append("</LISTVIEWDATA>");

		logger.debug("managePollList ended");
		return result.toString();
	}
	
	/**
	 * 초기화면 QuickPoll 등록화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/addPoll.do", method = RequestMethod.GET)
	public String addPoll(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, PersonalLightPollVO infoVO) throws Exception {
		logger.debug("addPoll started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		String flag = "";
		String itemSeq = "";
		if(request.getParameter("flag") != null) {
			flag = request.getParameter("flag");
		}
		if (request.getParameter("itemSeq") != null) {
			itemSeq = request.getParameter("itemSeq");
			infoVO = ezPersonalAdminService.getPollInfo(itemSeq, userInfo.getTenantId());

			/* 2023-01-17 전인하 - 빠른설문 > DB에 들어가는 값이 UTC 시간으로 변경됨에 따라 가져오는 값에 시간대 적용 */
			String offset = userInfo.getOffset();
			String startDate = commonUtil.getDateStringInUTC(infoVO.getStartDate(), offset, false);
			String endDate = commonUtil.getDateStringInUTC(infoVO.getEndDate(), offset, false);

			// commonUtil.getDateStringInUTC()을 사용하여 시간 포맷팅을 먼저 진행 > "." 문자로 자르는 분기 주석처리
			/*
			if (startDate != null && startDate.indexOf(".") > -1) {
				startDate = startDate.substring(0, startDate.indexOf("."));
			}
			
			if (endDate != null && endDate.indexOf(".") > -1) {
				endDate = endDate.substring(0, endDate.indexOf("."));
			}
			*/

			infoVO.setStartDate(startDate);
			infoVO.setStartDate(endDate);

			model.addAttribute("infoVO", infoVO);
		} 
		
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("flag", flag);

		logger.debug("addPoll ended");
		return "admin/ezPersonal/personalAddPoll";
	}
	
	/**
	 * 초기화면 QuickPoll 등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/savePoll.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String savePoll(@CookieValue("loginCookie") String loginCookie,@RequestBody String data) throws Exception {
		logger.debug("savePoll started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		String itemSeq;
		itemSeq = doc.getElementsByTagName("ITEMSEQ").item(0).getTextContent();
		
		String result = "";

		/* 2023-01-17 전인하 - 빠른설문 삽입 및 갱신 시 UTC시간 사용을 위한 Offset 추가 */
		if (itemSeq.equals("")) {
			// 생성
			result = ezPersonalAdminService.insertPoll(doc, userInfo.getOffset(), userInfo.getTenantId());
		} else {
			// 수정
			result = ezPersonalAdminService.updatePoll(doc, userInfo.getOffset(), userInfo.getTenantId());
		}

		logger.debug("savePoll ended");
		return result;
	}
	
	/**
	 * 초기화면 QuickPoll 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/delPoll.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String delPoll(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request) throws Exception {
		logger.debug("delPoll started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pollList = request.getParameter("pollList");
		
		String result = ezPersonalAdminService.deletePoll(pollList, userInfo.getTenantId());

		logger.debug("delPoll ended");
		return result;
	}
	
	/**
	 * 초기화면 QuickPoll 본문화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/pollResult.do", method = RequestMethod.GET)
	public String pollResult(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("pollResult started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String subject = "", title = "";
		
		String itemSeq = request.getParameter("itemSeq");

		PersonalLightPollVO infoVO = ezPersonalAdminService.getPollInfo(itemSeq, userInfo.getTenantId());
		
		if (userInfo.getPrimary().equals("2") && infoVO.getPollTitle2() != null) {
			subject = infoVO.getPollTitle2();
		} else {
			subject = infoVO.getPollTitle();
		}
		
		if (commonUtil.getDateStringInUTC(infoVO.getEndDate(), userInfo.getOffset(), false).indexOf("1990-01-01") > -1) {
			title = commonUtil.getDateStringInUTC(infoVO.getStartDate(), userInfo.getOffset(), false) + " - " + egovMessageSource.getMessage("ezPersonal.t244", userInfo.getLocale());
		} else {
			title = commonUtil.getDateStringInUTC(infoVO.getStartDate(), userInfo.getOffset(), false) + " - " + infoVO.getEndDate();
		}
		
		List<PersonalLightPollVO> list = ezPersonalAdminService.getPollResult(itemSeq, userInfo.getTenantId());
		
		StringBuilder result = new StringBuilder();
		int count = Integer.parseInt(infoVO.getPollSelectionCount());
		double totalCount = 0;
		
		for (PersonalLightPollVO vo : list) {
			totalCount += vo.getCount();
		}
		
		result.append("<DATA>");
		
		for (int i = 1; i <= count; i++) {
			result.append("<ROW>");
			
			String fieldName = "answer" + i;
			String fieldValue = "";
			
			for (Field field : infoVO.getClass().getDeclaredFields()) {
				field.setAccessible(true);
				
				if (field.getName().toUpperCase().equals(fieldName.toUpperCase())) {
					fieldValue = commonUtil.cleanValue(String.valueOf(field.get(infoVO)));
				}
			}
			
			result.append("<TITLE>" + i + ". " + fieldValue + "</TITLE>");
			
			int resultCount = 0;
			int percent = 0;
			
			for (PersonalLightPollVO vo : list) {
				if (vo.getResult() == i) {
					resultCount = vo.getCount();
					percent = (int)(vo.getCount() / totalCount * 100);
				}
			}
			
			result.append("<COUNT>" + resultCount + "</COUNT>");
			result.append("<PERCENT>" + percent + "</PERCENT>");
			result.append("</ROW>");
		}
		
		result.append("</DATA>");
		
		model.addAttribute("subject", subject);
		model.addAttribute("title", title);
		model.addAttribute("result", result.toString());

		logger.debug("pollResult ended");
		return "admin/ezPersonal/personalPollResult";
	}
	
	/**
	 * 초기화면 팝업공지메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/managePopup.do", method = RequestMethod.GET)
	public String managePopup(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("managePopup started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		String noneActiveX = config.getProperty("NONEACTIVEX");
		String useEditor = config.getProperty("EDITOR");
		
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("useEditor", useEditor);

		logger.debug("managePopup ended");
		return "admin/ezPersonal/personalManagePopup";
	}
	
	/**
	 * 초기화면 팝업공지 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/managePopupList.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String managePopupList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("managePopupList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		
		int currentPage = 1, pageSize = 15;
		
		if (request.getParameter("page") != null) {
			currentPage = Integer.parseInt(request.getParameter("page"));
		}

		int totalCount = ezPersonalAdminService.getPopupCount(companyID, userInfo.getTenantId());
		int pageCount = (int)((totalCount + pageSize - 1) / pageSize);
		
		List<PersonalPopupVO> list = ezPersonalAdminService.getPopupList(companyID, totalCount, pageSize, Math.multiplyExact(Math.subtractExact(currentPage, 1), pageSize), userInfo.getTenantId());
		
		StringBuilder result = new StringBuilder();
		
		result.append("<LISTVIEWDATA>");
		result.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		result.append("<PAGECNT>" + pageCount + "</PAGECNT>");
		result.append("<CURPAGE>" + currentPage + "</CURPAGE>");
		result.append("<ROWS>");
		
		//2018-08-08  김보미 - rownumber추가
		int i=0;
		for (PersonalPopupVO vo : list) {
			result.append("<ROW>");
			result.append("<CELL>"); 
			result.append("<VALUE>" + vo.getItemSeq() +"</VALUE>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");								// itemSeq
			result.append("<DATA2>" + vo.getWidth() + "</DATA2>");
			result.append("<DATA3>" + vo.getHeight() + "</DATA3>");
			result.append("<DATA4>" + vo.getPosition() + "</DATA4>");
			result.append("<PROGRESS>" + vo.getProgress() + "</PROGRESS>");
			result.append("<INUSE>" + vo.getInUse() + "</INUSE>");
			result.append("</CELL>");
			result.append("<CELL>");
			//2018-08-08  김보미 - rownumber추가
//			result.append("<VALUE>" + vo.getItemSeq() + "</VALUE>");
			result.append("<VALUE>" + Math.subtractExact(totalCount, Math.addExact(Math.multiplyExact(pageSize, Math.subtractExact(currentPage, 1)), i)) + "</VALUE>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			result.append("</CELL>");
			
			//2023-07-27 이주원 -  pollTitle 다국어_en 적용하기 위해 추가
			if (userInfo.getLang().equals("2") && vo.getTitle2() != null && !vo.getTitle2().equals("")) {
				result.append("<CELL>");
				result.append("<VALUE>" + commonUtil.cleanValue(vo.getTitle2()) + "</VALUE>");
				result.append("</CELL>");
			} else {
				result.append("<CELL>");
				result.append("<VALUE>" + commonUtil.cleanValue(vo.getTitle()) + "</VALUE>");
				result.append("</CELL>");
			}
			
			result.append("<CELL>");
			result.append("<VALUE>" + vo.getStartDate().substring(0, 10) + "</VALUE>");
			result.append("</CELL>");
			
			result.append("<CELL>");
			result.append("<VALUE>" + vo.getEndDate().substring(0, 10) + "</VALUE>");
			result.append("</CELL>");
			
			result.append("<CELL>");
			result.append("<VALUE>" + vo.getProgress() + "</VALUE>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			result.append("</CELL>");
			
			result.append("<CELL>");
			result.append("<VALUE>" + vo.getInUse() + "</VALUE>");
			result.append("</CELL>");
			result.append("</ROW>");
			i++;
		}
		
		result.append("</ROWS>");
		result.append("</LISTVIEWDATA>");

		logger.debug("managePopupList ended");
		return result.toString();
	}
	
	/**
	 * 팝업공지 공지사항등록,수정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/addPopupCK.do", method = RequestMethod.GET)
	public String addPopupCK(@CookieValue("loginCookie") String loginCookie, PersonalPopupVO vo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("addPopupCK started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemSeq = "";
		
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		String companyID = request.getParameter("companyID");
		
		if (companyID == null) {
			return "";
		}
		
		String initDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm"), userInfo.getOffset(), false);
		String flag = request.getParameter("flag");

		if (request.getParameter("itemSeq") != null) {
			itemSeq = request.getParameter("itemSeq");
			
			vo = ezPersonalAdminService.getPopupInfo(itemSeq, userInfo.getTenantId());
			vo.setItemSeq(Integer.parseInt(itemSeq));
			// &quot의 경우 FE에서 string을 감쌀 때 쌍따옴표를 사용하고 있기 때문에 따옴표로 변경
			vo.setContent(vo.getContent().replace("\r\n", "").replace("\n", "")
//					.replace("&lt;", "<").replace("&gt;", ">")
					.replace("&quot;", "\'").replace("&apos;", "\'"));
			
			//
			String startDate = vo.getStartDate();
			String endDate = vo.getEndDate();
			
			if (startDate != null && startDate.indexOf('.') > -1) {
				startDate = startDate.substring(0, startDate.indexOf("."));
				vo.setStartDate(startDate);
			}
			
			if (endDate != null && endDate.indexOf('.') > -1) {
				endDate = endDate.substring(0, endDate.indexOf("."));
				vo.setEndDate(endDate);
			}
			
		} else {
			vo.setWidth(600);
			vo.setHeight(600);
		}
		
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("companyID", companyID);
		model.addAttribute("initDate", initDate);
		model.addAttribute("isoUTFstartDate", commonUtil.getDateStringInUTC(vo.getStartDate(), userInfo.getOffset(), false));
		model.addAttribute("isoUTFEndDate", commonUtil.getDateStringInUTC(vo.getEndDate(), userInfo.getOffset(), false));
		model.addAttribute("personalPopupVO", vo);
		model.addAttribute("flag", flag);

		logger.debug("addPopupCK ended");
		return "admin/ezPersonal/personalAddPopupCK";
	}
	
	/**
	 * 팝업공지 공지사항 등록,수정 실행 함수
	 */
	
	@RequestMapping(value = "/admin/ezPersonal/savePopup.do", method = RequestMethod.POST)
	@ResponseBody
	public String savePopup(@CookieValue("loginCookie") String loginCookie, @RequestBody JSONObject jObj) throws Exception {
		logger.debug("savePopup started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		
		PersonalPopupVO vo = new PersonalPopupVO();
		vo.setCompanyID(jObj.get("companyID").toString());
		
		if (jObj.get("itemSeq") == null || jObj.get("itemSeq").toString().equals("null") || jObj.get("itemSeq").toString().equals("")) {
			vo.setItemSeq(null);
		} else {
			vo.setItemSeq(Integer.parseInt(jObj.get("itemSeq").toString()));
		}
		
		vo.setTitle(jObj.get("title").toString());
		vo.setTitle2(jObj.get("title2").toString());
		vo.setStartDate(jObj.get("startDate").toString());
		vo.setEndDate(jObj.get("endDate").toString());
		vo.setWidth(Integer.parseInt(jObj.get("width").toString()));
		vo.setHeight(Integer.parseInt(jObj.get("height").toString()));
		vo.setPosition(jObj.get("position").toString());
		vo.setContent(jObj.get("content").toString());
		vo.setSkinValue(Integer.parseInt(jObj.get("skinValue").toString()));
		 ObjectMapper mapper = new ObjectMapper();
		List<PersonalPopupUserVO> authList = mapper.convertValue(jObj.get("authList"), new TypeReference<List<PersonalPopupUserVO>>() {});
		
		if (vo.getTitle2().equals("")) {
			vo.setTitle2(vo.getTitle());
		}
		
		if (vo.getItemSeq() == null) {
			int itemSeq = ezPersonalAdminService.insertPopup(vo, userInfo.getTenantId(), userInfo.getOffset());
			
			//update authList
			ezPersonalAdminService.updatePopupUser(authList, tenantId, vo.getCompanyID(), itemSeq);
		} else {
			ezPersonalAdminService.updatePopup(vo, userInfo.getTenantId(), userInfo.getOffset());
			
			//update authList
			ezPersonalAdminService.updatePopupUser(authList, tenantId, vo.getCompanyID(), vo.getItemSeq());
		}
		
		logger.debug("savePopup ended");
		return "OK";
	}
	
	/**
	 * 팝업공지 공지사항 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/delPopup.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String deletePopup(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request) throws Exception {
		logger.debug("deletePopup started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String popupList = request.getParameter("popupList");
		
		ezPersonalAdminService.deletePopup(popupList, userInfo.getTenantId());

		logger.debug("deletePopup ended");
		return "OK";
	}
	
	/**
	 * 팝업공지 공지사항 공지사항 본문화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/showPopup.do", method = RequestMethod.GET)
	public String showPopup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, PersonalPopupVO vo, Model model) throws Exception {
		logger.debug("showPopup started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemSeq = request.getParameter("itemSeq");
		String title = "";
		String flag = "";
		if (request.getParameter("flag") != null) {
			flag = request.getParameter("flag");
		}
		
		vo = ezPersonalAdminService.getPopupInfo(itemSeq, userInfo.getTenantId());
		vo.setStartDate(commonUtil.getDateStringInUTC(vo.getStartDate(), userInfo.getOffset(), false));
		vo.setEndDate(commonUtil.getDateStringInUTC(vo.getEndDate(), userInfo.getOffset(), false));
		String content = vo.getContent().replace("\r\n", "").replace("\n", "")
				//2021-09-09 김성준 <test>같은 문자를 태그로 인식해서, 표출되지 않아 주석처리함
				//.replace("&lt;", "<").replace("&gt;", ">")
				.replace("&quot;", "\"").replace("&apos;", "\'");
		
		if (userInfo.getPrimary().equals("2") && !vo.getTitle2().equals("")) {
			title = vo.getTitle2();
		} else {
			title = vo.getTitle();
		}
		
		model.addAttribute("itemSeq", itemSeq);
		model.addAttribute("title", title);
		model.addAttribute("content", content);
		model.addAttribute("user", userInfo.getId());
		model.addAttribute("flag", flag);
		model.addAttribute("skinValue", vo.getSkinValue());
		model.addAttribute("wHeight", vo.getHeight());
		model.addAttribute("wWidth", vo.getWidth());
		
		logger.debug("showPopup ended");
		return "admin/ezPersonal/personalShowPopup";
	}
	
	/**
	 * 초기화면 이달의우수사원메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/employeeOfMonth.do", method = RequestMethod.GET)
	public String employeeOfMonth(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("employeeOfMonth started");
		logger.debug("employeeOfMonth ended");
		return "admin/ezPersonal/personalEmployeeOfMonth";
	}
	
	/**
	 * 초기화면 이달의우수사원메뉴 리스트 호출 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/getEmployeeOfMonthList.do", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public JSONObject getEmployeeOfMonthList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getEmployeeOfMonthList started");
		
		String year = request.getParameter("year");
		logger.debug("year: " + year);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyID = Optional.ofNullable(request.getParameter("companyID")).orElse(userInfo.getCompanyID());
		String userPrimaryLang = userInfo.getPrimary();
		
		List<PersonalEmpMonthVO> list = ezPersonalAdminService.getEmpMonth(year,companyID , userInfo.getTenantId());
		
		for (PersonalEmpMonthVO vo : list) {
			if (!userPrimaryLang.equals("1")) {
				vo.setDisplayName(vo.getDisplayName2());
				vo.setTitle(vo.getTitle2());
				vo.setDescription(vo.getDescription2());
				vo.setCompany(vo.getCompany2());
			}
			
			if (vo.getFilePath() != null && !vo.getFilePath().equals("")) {
				vo.setFilePath("/ezCommon/downloadAttach.do?&filePath=" + commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator + vo.getFilePath());
			}
			else{
				vo.setFilePath("/images/kr/main/employee_default.png");
			}
		}
		
		JSONObject json = new JSONObject();
		json.put("list", list);
		
		logger.debug("getEmployeeOfMonthList ended");
		return json;
	}
	
	/**
	 * 초기화면 이달의우수사원 등록화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/selectBest.do", method = RequestMethod.GET)
	public String selectBest(Model model) {
		logger.debug("selectBest started");

		model.addAttribute("nowYear", EgovDateUtil.getCurrentDate("").substring(0, 4));
		
		logger.debug("selectBest ended");
		return "admin/ezPersonal/personalSelectBest";
	}
	
	/**
	 * 초기화면 이달의우수사원 등록,수정,삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/setEmployeeMonth.do", method = RequestMethod.POST)
	@ResponseBody
	public String setEmployeeMonth(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("setEmployeeMonth started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = "", deptID = "";
		String type = request.getParameter("type");
		String term = request.getParameter("term");
		String companyID = Optional.ofNullable(request.getParameter("companyID")).orElse(userInfo.getCompanyID());
		String jobName = request.getParameter("jobName"); // 같은 부서에 겸직이 되어있는경우 오류가 발생하여 직위 조건 추가
		
		if (request.getParameter("userID") != null) {
			userID = request.getParameter("userID");
		}
		if (request.getParameter("deptID") != null) {
			deptID = request.getParameter("deptID");
		}
		
		try {
			ezPersonalAdminService.setEmpMonth(type, userID, deptID, term, companyID, userInfo.getTenantId(), jobName);
			logger.debug("setEmployeeMonth ended");
			return "OK";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return "";
		}
	}
	
	/**
	 * 초기화면 슬라이드이미지메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/sliderImages.do", method = RequestMethod.GET)
	public String sliderImages() throws Exception {
		return "admin/ezPersonal/personalSliderImages";
	}
	
	/**
	 * 초기화면 슬라이드이미지 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/getSlider.do", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public List<PersonalSliderImageVO> getSlider(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getSlider started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sliderID = " ";
		
		if (request.getParameter("item") != null) {
			sliderID = request.getParameter("item");
		}
		logger.debug("sliderID="+sliderID);
		
		List<PersonalSliderImageVO> result = ezPersonalAdminService.getSlider(sliderID, userInfo);
		
		logger.debug("getSlider ended");
		return result;
	}
	
	/**
	 * 초기화면 슬라이드이미지 등록화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/selectImage.do", method = RequestMethod.GET)
	public String selectImage(@CookieValue("loginCookie") String loginCookie ,HttpServletRequest request, Model model) throws Exception {
		logger.debug("selectImage started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sliderID = "";
		
		if (request.getParameter("item") != null) {
			sliderID = request.getParameter("item");
		}
		
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		String uploadPortalPath = commonUtil.getUploadPath("upload_portal.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("sliderID", sliderID);
		model.addAttribute("uploadPortalPath", uploadPortalPath);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);

		logger.debug("selectImage ended");
		return "admin/ezPersonal/personalSelectImages";
	}
	
	/**
	 * 초기화면 슬라이드이미지 등록 이미지등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/saveSliderImage.do", method = RequestMethod.POST)
	public String saveSliderImage(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		logger.debug("saveSliderImage started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String dirPath = commonUtil.getUploadPath("upload_portal.ROOT", userInfo.getTenantId());
		String resultUpload = "false";
		String uploadSN = "{" + UUID.randomUUID() + "}";
		String fileLocation = "";
		MultipartFile multiFile = null;
		
		String mode = request.getParameter("mode");
		
		if (request.getFile("file1") != null) {
			multiFile = request.getFile("file1");
		}
		
		// 2023-05-16 이사라 : NullPointerException 시큐어코딩
		if (Objects.isNull(multiFile)) {
			throw new NullPointerException("saveSliderImage multiFile is null");
		}
		
		String realPath = commonUtil.getRealPath(request);
		String serverPath = dirPath + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + mode + commonUtil.separator;
		String uniqueName = uploadSN + multiFile.getOriginalFilename().substring(multiFile.getOriginalFilename().lastIndexOf("."));
		
		File dir = new File(commonUtil.detectPathTraversal(realPath + serverPath));
		
		if (!dir.exists()) {
			dir.mkdirs();
		}
		
		writeUploadedFile(multiFile, uniqueName, realPath + serverPath);
		
		File file = new File(commonUtil.detectPathTraversal(realPath + serverPath + uniqueName));
		
		if (mode.equals("SLIDERIMAGE")) {
			String saveName = UUID.randomUUID() + ".jpg";
			BufferedImage inputImage = ImageIO.read(file);
			BufferedImage outputImage = null;
			Graphics2D saveImage = null;
			
			outputImage= new BufferedImage(280, 450, BufferedImage.TYPE_INT_RGB);
			saveImage = outputImage.createGraphics();
			saveImage.drawImage(inputImage, 0, 0, 280, 450, null);
			saveImage.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
			
			File newFile = new File(commonUtil.detectPathTraversal(realPath + serverPath + saveName));
			
			ImageIO.write(outputImage, "png" , newFile);
			deleteFile(realPath + serverPath + uniqueName);
			
			fileLocation = serverPath + saveName;
		}
		
		resultUpload = "true";
		
		int attachLimit = 10000000;
		
		if (multiFile.getSize() > attachLimit) {
			resultUpload = "overflow";
		}
		
		StringBuilder strXML = new StringBuilder();
		
		strXML.append("<ROOT>");
		strXML.append("<NODES>");
		strXML.append("<NODE>");
		strXML.append("<PUPLOADSN><![CDATA[" + uniqueName + "]]></PUPLOADSN>");
		strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
		strXML.append("<PFILENAME><![CDATA[" + multiFile.getOriginalFilename() + "]]></PFILENAME>");
		strXML.append("<FILESIZE>" + (int) multiFile.getSize() + "</FILESIZE>");
		strXML.append("<FILELOCATION><![CDATA[" + fileLocation + "]]></FILELOCATION>");
		strXML.append("</NODE>");
		strXML.append("</NODES>");
		strXML.append("</ROOT>");
		
		model.addAttribute("strXML", strXML);

		logger.debug("saveSliderImage ended");
		return "/admin/ezPortal/portalPortletImageUpload";
	}
	
	/**
	 * 초기화면 슬라이드이미지 등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/saveSlider.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveSlider(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("saveSlider started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sliderID = request.getParameter("sliderID");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");
		String sliderPath = request.getParameter("sliderImage");
		String fileName = request.getParameter("fileName");
		String mode = request.getParameter("mode");
		// 18-05-10 김민성 - 슬라이드 이미지 등록 URL 컬럼 추가
		String url = request.getParameter("url");
		// 18-11-28 문성업 - 슬라이디 하용여부 파라미터 추가
		String isUse = request.getParameter("isUse");
		
		ezPersonalAdminService.setSliderImage(sliderID, displayName, displayName2, sliderPath, fileName, mode, userInfo, url, isUse);

		logger.debug("saveSlider ended");
		return "OK";
	}
	
	/**
	 * 초기화면 슬라이드이미지 상태,순서 변경 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/statusChangeSlider.do", method = RequestMethod.POST)
	@ResponseBody
	public String statusChangeSlider(@CookieValue("loginCookie") String loginCookie ,HttpServletRequest request) throws Exception {
		logger.debug("statusChangeSlider started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String result = "";
		String mode = request.getParameter("mode");
		
		if (mode.equals("U")) {
			String sliderID = request.getParameter("sliderID");
			String isUse = request.getParameter("isUse");
			
			result = ezPersonalAdminService.statusChangeSlider1(sliderID, isUse, mode, userInfo.getTenantId());
		} else {
			String aRuleID = request.getParameter("aRuleID");
			String aPriority = request.getParameter("aPriority");
			String bRuleID = request.getParameter("bRuleID");
			String bPriority = request.getParameter("bPriority");
			
			result = ezPersonalAdminService.statusChangeSlider2(aRuleID, aPriority, bRuleID, bPriority, mode, userInfo.getTenantId());
		}

		logger.debug("statusChangeSlider ended");
		return result;
	}
	
	@RequestMapping(value = "/admin/ezPersonal/deleteSlider.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteSlider(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request) throws Exception {
		logger.debug("deleteSlider started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sliderID = request.getParameter("sliderID");
		ezPersonalAdminService.deleteSlider(sliderID, userInfo.getTenantId());

		logger.debug("deleteSlider ended");
		return "OK";
	}
	
	/**
	 * 초기화면 QuickLink 삭제 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/delQuickLink.do", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject  delQuickLink(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("delQuickLink started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String pQuickLinkID = request.getParameter("pQuickLinkID");
		ezPersonalAdminService.delQuickLink(pQuickLinkID, userInfo.getTenantId());
		
		JSONObject json = new JSONObject();
		json.put("result", "OK");
		
		logger.debug("delQuickLink ended");
		return json;
	}
	
	/**
	 * 초기화면 QuickLink typeImage 추가
	 */
	@RequestMapping(value = "/admin/ezPersonal/typeImageUpload.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	public String  typeImageUpload(@CookieValue("loginCookie") String loginCookie,  MultipartHttpServletRequest request, Model model ) throws Exception {
		logger.debug("typeImageUpload started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);

		String boardID = "LinkType";
		String qID = request.getParameter("QId");
		String fileName = qID + ".jpg";
		String dirPath = commonUtil.getUploadPath("upload_personal.ROOT", userInfo.getTenantId());
		String serverPath = dirPath + commonUtil.separator  + boardID + commonUtil.separator;
		MultipartFile multiFile = null;
		StringBuilder strXML = new StringBuilder();
		
		if (request.getFile("file1") != null) {
			multiFile = request.getFile("file1");
		}

		writeUploadedFile(multiFile, fileName, realPath + serverPath);

        String pAttachPath = dirPath + commonUtil.separator + boardID + commonUtil.separator + fileName;
       
        File dir = new File(commonUtil.detectPathTraversal(realPath + serverPath));
		
   		if (!dir.exists()) {
   			dir.mkdirs();
   		}
   		
   		/* 2018-08-30 홍승비 - 퀵링크 이미지 등록 시 원래 인코딩(content-type)으로 수정 */
		String contentType = null;
		String extension = null;
        BufferedInputStream bis = null;
   		
        File file = new File(commonUtil.detectPathTraversal(realPath + pAttachPath));
    
        try {
	        bis = new BufferedInputStream(new FileInputStream(file));
	        contentType = URLConnection.guessContentTypeFromStream(bis);
        } catch(Exception e) {
			logger.debug("e.message=" + e.getMessage());
        } finally {
        	if (bis != null) {
        		bis.close();
        	}
        }
        
        if (contentType == null) {
        	contentType = "application/octet-stream";
        	extension = ".jpg"; // 기존 확장자가 .jpg로 고정되어 있었으므로, 디폴트로 사용함
        } else {
        	contentType = contentType.replace("image", "Image");
        	extension = "." + contentType.split("/")[1];
        }
        
        String pSaveName = qID + extension;
        BufferedImage inputImage = ImageIO.read(file);
		BufferedImage outputImage = null;
		Graphics2D saveImage = null;
		
		// png파일의 배경을 검게 만들지 않도록 수정
		if (inputImage.getType() == 0) {
			outputImage= new BufferedImage(100, 50, BufferedImage.TYPE_INT_RGB);
		} else {
			outputImage= new BufferedImage(100, 50, inputImage.getType());
		}
		
		saveImage = outputImage.createGraphics();
		saveImage.drawImage(inputImage, 0, 0, 100, 50, null);
		
		HashMap<RenderingHints.Key,Object> hm = new HashMap<RenderingHints.Key,Object>();
		
		hm.put(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
		hm.put(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
		hm.put(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
		
		saveImage.setRenderingHints(hm);
		
		File newFile = new File(commonUtil.detectPathTraversal(realPath + serverPath + pSaveName));
		
		ImageIO.write(outputImage, extension.replace(".", "") , newFile);
		//deleteFile(dirPath + serverPath + fileName);
		
		String fileLocation = serverPath  + pSaveName;
		
		// 2023-05-16 이사라 : NullPointerException 시큐어코딩
		int fileSize = 0;
		
		if (!Objects.isNull(multiFile)) {
			fileSize = (int) multiFile.getSize();
		}

		strXML.append("<ROOT><NODES>");
		strXML.append("<NODE><PUPLOADSN><![CDATA[" + qID + extension + "]]></PUPLOADSN>");
		strXML.append("<RESULTUPLOADA><![CDATA[true]]></RESULTUPLOADA>");
		strXML.append( "<PFILENAME><![CDATA[" + qID + extension + "]]></PFILENAME>");
		strXML.append( "<FILESIZE>" + fileSize + "</FILESIZE>");
		strXML.append("<FILELOCATION><![CDATA[" + fileLocation + "]]></FILELOCATION>");
		strXML.append( "</NODE>");
		strXML.append("</NODES></ROOT>");
            
		logger.debug("typeImageUpload ended");
		model.addAttribute("strXML", strXML);

		return "/admin/ezPortal/portalPortletImageUpload";
	}


	/** 
	 * 빠른설문 config 조회 함수  
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/getLightPollConfig.do", method = RequestMethod.POST, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject getLightPollConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getLightPollConfig started");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		PersonalLightPollConfigVO configVO = ezPersonalAdminService.getLightPollConfig(userInfo.getId(), userInfo.getTenantId());
		JSONObject json = new JSONObject();
		json.put("configVO", configVO);
		logger.debug("getLightPollConfig ended");
		return json;
	}

	/**
	 * 빠른설문 config 저장 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/setLightPollConfig.do", method = RequestMethod.POST, produces="text/plain; charset=UTF-8")
	@ResponseBody
	public String setLightPollConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam String isPreview) throws Exception {
		logger.debug("setLightPollConfig started");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		ezPersonalAdminService.setLightPollConfig(userInfo.getId(), isPreview, userInfo.getTenantId());
		logger.debug("setLightPollConfig ended");
		return null;
	}


	/** 
	 *빠른설문 itemseq 조회 함수  
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/getPollItem.do", method = RequestMethod.POST, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject getPollItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam String itemseq) throws Exception {
		logger.debug("getPollItem started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		PersonalLightPollVO pollVO = ezPersonalAdminService.getPollInfo(itemseq, userInfo.getTenantId());

		/* 2023-01-17 전인하 - 빠른설문 > DB에 들어가는 값이 UTC 시간으로 변경됨에 따라 비교조건도 UTC 시간으로 수정 */
		String offset = userInfo.getOffset();
		pollVO.setStartDate(commonUtil.getDateStringInUTC(pollVO.getStartDate(), offset, false));
		pollVO.setEndDate(commonUtil.getDateStringInUTC(pollVO.getEndDate(), offset, false));
		
		// 다국어 처리
		if (userInfo.getPrimary().equals("2") && pollVO.getPollTitle2() != null) {
			pollVO.setPollTitle(pollVO.getPollTitle2());
		} 
		List<PersonalLightPollVO> pollResultVO = ezPersonalAdminService.getPollResult(itemseq, userInfo.getTenantId());
		int totalCount = 0;
		for (PersonalLightPollVO vo : pollResultVO) {
			totalCount += vo.getCount();
		}
		for (PersonalLightPollVO vo : pollResultVO) {
			vo.setPercent((int)(vo.getCount() / totalCount * 100));
		}
		
		JSONObject json = new JSONObject();
		json.put("pollVO", pollVO);
		json.put("pollResultVO", pollResultVO);
		json.put("totalCount", totalCount);
		logger.debug("getPollItem ended");
		return json;
	}
	
	/** 
	 * 팝업공지 config 조회 함수  
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/getPopupConfig.do", method = RequestMethod.POST, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject getPopupConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getPopupConfig started");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		PersonalPopopConfigVO configVO = ezPersonalAdminService.getPopupConfig(userInfo.getId(), userInfo.getTenantId());
		JSONObject json = new JSONObject();
		json.put("configVO", configVO);
		logger.debug("getPopupConfig ended");
		return json;
	}


	/**
	 * 팝업공지 config 저장 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/setPopupConfig.do", method = RequestMethod.POST, produces="text/plain; charset=UTF-8")
	@ResponseBody
	public String setPopupConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam String isPreview) throws Exception {
		logger.debug("setPopupConfig started");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String msg = ezPersonalAdminService.setPopupConfig(userInfo.getId(), isPreview, userInfo.getTenantId());
		logger.debug("setPopupConfig ended");
		return msg;
	}


	/**
	 * 팝업공지 사용여저장 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/setPopupUse.do", method = RequestMethod.POST, produces="text/plain; charset=UTF-8")
	@ResponseBody
	public String setPopupUse(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam String itemSeq, @RequestParam String inUse) throws Exception {
		logger.debug("setPopupUse started");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String msg = ezPersonalAdminService.setPopupUse(userInfo.getCompanyID(), userInfo.getTenantId(), itemSeq, inUse);
		logger.debug("setPopupUse ended");
		return msg;
	}
	/**
	 * 초기화면 QuickLink 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/updateQuickLinkOrder.do", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject updateQuickLinkOrder(@CookieValue("loginCookie") String loginCookie, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("updateQuickLinkOrder started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		JSONObject json = new JSONObject();
		JSONParser jp = new JSONParser();
		jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
		
		JSONArray linkOrderList = (JSONArray) jsonParam.get("linkOrderList");
		ezPersonalAdminService.updateQuickLinkOrder(linkOrderList, userInfo.getTenantId());
		
		json.put("result", "OK");
		
		logger.debug("updateQuickLinkOrder ended");
		return json;
	}
	
	/**
	 * 초기화면 슬라이디 이미지 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/updateSliderImageOrder.do", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject updateSliderImageOrder(@CookieValue("loginCookie") String loginCookie, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("updateSliderImageOrder started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		JSONObject json = new JSONObject();
		JSONParser jp = new JSONParser();
		jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
		
		JSONArray sliderImageList = (JSONArray) jsonParam.get("slierImageList");
		ezPersonalAdminService.updateSliderImageOrder(sliderImageList, userInfo.getTenantId());
		json.put("result", "OK");
		
		logger.debug("updateSliderImageOrder end");
		return json;
	}


	/** 
	 * 현재 진행중인 설문조사 get
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/getOnUsePoll.do", method = RequestMethod.POST, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject getOnUsePoll(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getOnUsePoll started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		PersonalLightPollVO progressVO = ezNewPortalService.getPollPortlet(userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getId(), userInfo.getOffset());
		JSONObject json = new JSONObject();
		if(progressVO == null) {
			json.put("progressFlag", "FALSE");
		} else {
			json.put("progressFlag", "OK");
			json.put("progressVO", progressVO);
		}

		logger.debug("getOnUsePoll ended");
		return json;
	}


	/** 
	 * 현재 진행중인 설문조사 get
	 */
	@RequestMapping(value = "/admin/ezPersonal/checkJoinPoll.do", method = RequestMethod.POST, produces="text/plain; charset=UTF-8")
	@ResponseBody
	public String checkJoinPoll(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("checkJoinPoll started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String itemSeq = "";
		if(request.getParameter("itemseq") != null) {
			itemSeq = request.getParameter("itemseq");
		}

		String msg = "OK";
		msg = ezPersonalAdminService.checkJoinPoll(userInfo.getId(), userInfo.getTenantId(), itemSeq);

		logger.debug("checkJoinPoll ended");
		return msg;
	}
	
	/**
	 * 팝업공지 공지사항 공지사항 본문화면 호출 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/showLayerPopup.do", method = RequestMethod.POST, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject showLayerPopup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody JSONObject jsonParam, PersonalPopupVO vo, Model model) throws Exception {
		logger.debug("showLayerPopup started");
		
		JSONObject json = new JSONObject();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemSeq = jsonParam.get("itemSeq").toString();
		String title = "";
		String flag = "";
		
		if (request.getParameter("flag") != null) {
			flag = request.getParameter("flag");
		}
		
		vo = ezPersonalAdminService.getPopupInfo(itemSeq, userInfo.getTenantId());
		vo.setStartDate(commonUtil.getDateStringInUTC(vo.getStartDate(), userInfo.getOffset(), false));
		vo.setEndDate(commonUtil.getDateStringInUTC(vo.getEndDate(), userInfo.getOffset(), false));
		String content = vo.getContent().replace("\r\n", "").replace("\n", "")
				//2021-09-09 김성준 <test>같은 문자를 태그로 인식해서, 표출되지 않아 주석처리함
				//.replace("&lt;", "<").replace("&gt;", ">")
				.replace("&quot;", "\"").replace("&apos;", "\'");
		
		if (userInfo.getPrimary().equals("2") && !vo.getTitle2().equals("")) {
			title = vo.getTitle2();
		} else {
			title = vo.getTitle();
		}
		
		json.put("itemSeq", itemSeq);
		json.put("title", title);
		json.put("content", content);
		json.put("height", jsonParam.get("height"));
		json.put("width", jsonParam.get("width"));
		json.put("vertical", jsonParam.get("vertical"));
		json.put("horizontal", jsonParam.get("horizontal"));
		json.put("flag", flag);
		json.put("skinValue", vo.getSkinValue());
		json.put("userId", userInfo.getId());
		
		logger.debug("showLayerPopup ended");
		return json;
	}
	
	@RequestMapping(value = "/admin/ezPersonal/personalPopupUser.do", method = RequestMethod.GET)
	public String personalPopupUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("personalPopupUser started");
		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String deptID = auth.getDeptID();
		String cn = request.getParameter("cn") == null ? "" : request
				.getParameter("cn");
		String textName = request.getParameter("name") == null ? "" : request
				.getParameter("name");
		String useOcs = config.getProperty("config.USE_OCS");
		String companyId = request.getParameter("companyId");
		String lang = auth.getLang();
		
		model.addAttribute("deptID", deptID);
		model.addAttribute("cn", cn);
		model.addAttribute("textName", textName);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("companyId", companyId);
		model.addAttribute("dept", auth.getDeptID());
		model.addAttribute("lang", lang);
		
		logger.debug("personalPopupUser ended");
		return "/admin/ezPersonal/personalPopupUser";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPersonal/personalPopupGetUserList", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject personalPopupGetUserList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("personalPopupGetUserList started");
		JSONObject json = new JSONObject();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String itemSeq = request.getParameter("itemSeq");
		logger.debug("itemSeq = " + itemSeq);
		
		if (itemSeq != null && !itemSeq.equals("")) {
			int itemId = Integer.parseInt(itemSeq);
			int tenantId = userInfo.getTenantId();
			String companyId = request.getParameter("companyId");
			String lang = commonUtil.getMultiData(userInfo.getLang(), tenantId);
			List<PersonalPopupUserVO> userList = ezPersonalAdminService.getPopupUserList(itemId, tenantId, companyId, lang);
			
			if (userList != null && userList.size() > 0) {
				json.put("status", "ok");
				json.put("userList", userList);
			} else {
				json.put("status", "no");
			}
		} else {
			json.put("status", "no");
		}
		
		logger.debug("personalPopupGetUserList ended");
		return json;
	}
}
