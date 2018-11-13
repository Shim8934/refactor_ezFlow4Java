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
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalAdminService;
import egovframework.ezEKP.ezPersonal.vo.PersonalEmpMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopupVO;
import egovframework.ezEKP.ezResource.service.EzResourceService;
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
	
	//TODO getLocalTime, 추후 commonUtil 로 이동시 삭제
	@Autowired
	private EzResourceService ezResourceService;
	
	@Autowired
	private EzPersonalAdminService ezPersonalAdminService;
	
	/**
	 * 초기화면 메인화면 호출 함수
	 */
	@RequestMapping("/admin/ezPersonal/personalMain.do")
	public String personalMain () throws Exception {
		return "admin/ezPersonal/personalMain";
	}
	
	/**
	 * 초기화면 왼쪽메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/personalLeft.do")
	public String personalLeft (@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("personalLeft started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
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
	@RequestMapping(value = "/admin/ezPersonal/manageNotice.do")
	public String manageNotice (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("manageNotice started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
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
	@RequestMapping(value = "/admin/ezPersonal/manageNoticeList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String manageNoticeList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("manageNoticeList started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		String companyID = request.getParameter("id");
		int currentPage = Integer.parseInt(request.getParameter("page"));
		
		StringBuilder result = new StringBuilder();
		int pageSize = 12;
		int cnt = 0;
		
		int totalCount = ezPersonalAdminService.getNoticeCount(companyID, userInfo.getTenantId());
		int pageCount = (int)((totalCount + pageSize - 1) / pageSize);
		int iSn = totalCount - ((currentPage -1 ) * 12);
		
		result.append("<LISTVIEWDATA>");
		result.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		result.append("<PAGECNT>" + pageCount + "</PAGECNT>");
		result.append("<CURPAGE>" + currentPage + "</CURPAGE>");
		result.append("<CNT>" + cnt + "</CNT>");
		
		List<PersonalNoticeVO> list = ezPersonalAdminService.getNoticeList(companyID, totalCount, pageSize, (currentPage-1) * pageSize, userInfo.getTenantId());
		
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
		return result.toString();
	}
	
	/**
	 * 초기화면 공지사항 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/delNotice.do", produces = "text/xml; charset=utf-8") 
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
	@RequestMapping(value = "/admin/ezPersonal/addNoticeCK.do")
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
	@RequestMapping(value = "/admin/ezPersonal/saveNotice.do", produces = "text/xml; charset=utf-8")
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
	@RequestMapping(value = "/admin/ezPersonal/showNotice.do")
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
	@RequestMapping(value = "/admin/ezPersonal/manageQuickLink.do")
	public String manageQuickLink(@CookieValue("loginCookie") String loginCookie, Model model) {
		logger.debug("manageQuickLink started");

		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		model.addAttribute("host", auth.getServerName());
		model.addAttribute("lang", auth.getLang());
		
		logger.debug("manageQuickLink ended");
		return "admin/ezPersonal/personalManageQuickLink";
	}
	
	/**
	 * 초기화면 QuickLink 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/getQuickLinkList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getQuickLinkList(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getQuickLinkList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String result = ezPersonalAdminService.getQuickLinkList(userInfo, userInfo.getLang());

		logger.debug("getQuickLinkList ended");
		return result;
	}
	
	/**
	 * 초기화면 QuickLink 등록,수정화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/addQuickLink.do")
	public String addQuickLink(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("addQuickLink started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = "new";
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		
		model.addAttribute("strUserLang", commonUtil.getMultiData(userInfo.getLang(),userInfo.getTenantId()));
		model.addAttribute("primary", userInfo.getPrimary());
		model.addAttribute("mode", mode);
		model.addAttribute("host", userInfo.getServerName());
		model.addAttribute("lang", userInfo.getLang());
		
		logger.debug("addQuickLink ended");
		return "admin/ezPersonal/personalAddQuickLink";
	}
	
	/**
	 * 초기화면 QuickLink 수정화면 내용 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/getQuickLink.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getQuickLink(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request) throws Exception {
		logger.debug("getQuickLink started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String quickLinkID = request.getParameter("pQuickLinkID");
		
		String result = ezPersonalAdminService.getQuickLink(quickLinkID, userInfo.getTenantId());

		logger.debug("getQuickLink ended");
		return result;
	}
	
	/**
	 * 초기화면 QuickLink 권한목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/getQuickLinkACL.do", produces = "text/xml; charset=utf-8")
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
	@RequestMapping(value = "/admin/ezPersonal/selectTarget.do")
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
		return "admin/ezPersonal/personalSelectTarget";
	}
	
	/**
	 * 초기화면 QuickLink 등록,수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/saveQuickLink.do", produces = "text/xml; charset=utf-8")
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
	@RequestMapping(value = "/admin/ezPersonal/managePoll.do")
	public String managePoll(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("managePoll started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		String companyId = userInfo.getCompanyID();
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("list", resultList);
		model.addAttribute("companyId", companyId);

		logger.debug("managePoll ended");
		return "admin/ezPersonal/personalManagePoll";
	}
	
	/**
	 * 초기화면 QuickPoll 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/managePollList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String managePollList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("managePollList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int currentPage = 1, pageSize = 15;
		String progressPollFlag = "false";
		StringBuilder result = new StringBuilder();
		
		String companyID = request.getParameter("companyID");
		
		if (request.getParameter("page") != null) {
			currentPage = Integer.parseInt(request.getParameter("page"));
		}
		
		int totalCount = ezPersonalAdminService.getPollCount(companyID, userInfo.getTenantId());
		int pageCount = (int)((totalCount + pageSize - 1) / pageSize);
		List<PersonalLightPollVO> list = ezPersonalAdminService.getPollList(companyID, totalCount, pageSize, (currentPage - 1) * pageSize, userInfo.getTenantId());
		
		result.append("<LISTVIEWDATA>");
		result.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		result.append("<PAGECNT>" + pageCount + "</PAGECNT>");
		result.append("<CURPAGE>" + currentPage + "</CURPAGE>");
		result.append("<ROWS>");
		
		for (int i = 0; i < list.size(); i++) {
			PersonalLightPollVO vo = list.get(i);
			result.append("<ROW>");
			result.append("<CELL>"); 
			result.append("<VALUE>" + vo.getItemSeq() +"</VALUE>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");								// itemSeq
			result.append("</CELL>");
			result.append("<CELL>"); 
			result.append("<VALUE>" + (totalCount - (pageSize * (currentPage-1)+i)) + "</VALUE>");	// number
			result.append("</CELL>");
			result.append("<CELL>");
			result.append("<VALUE>" + commonUtil.cleanValue(vo.getPollTitle()) + "</VALUE>");		// title
			result.append("</CELL>");
			result.append("<CELL>");
			result.append("<VALUE>" + commonUtil.getDateStringInUTC(vo.getStartDate(), userInfo.getOffset(), false).substring(0, 10) + "</VALUE>");	// startDate
			result.append("</CELL>");
			result.append("<CELL>");
			
			// 진행여부 헤더 임시
			boolean jinhang = false;
			// endDate
			if (commonUtil.getDateStringInUTC(vo.getEndDate(), userInfo.getOffset(), false).indexOf("1900-01-01") > -1) {
				result.append("<VALUE>" + egovMessageSource.getMessage("ezPersonal.t244", userInfo.getLocale()) + "</VALUE>");	// 진행중
				progressPollFlag = "true";
				jinhang = true;
			} else {
				result.append("<VALUE>" + commonUtil.getDateStringInUTC(vo.getEndDate(), userInfo.getOffset(), false).substring(0, 10) + "</VALUE>");
			}
			
			// 진행여부
			result.append("</CELL>");
			result.append("<CELL>");
			if(jinhang) {
				result.append("<VALUE>" + "진행중" + "</VALUE>");	// 삭제
				result.append("<TYPE>" + "BTN" + "</TYPE>");
				result.append("<FUNC>" + "del_poll" + "</FUNC>");
				result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			} else {
				result.append("<VALUE>" + "종료" + "</VALUE>");	// 삭제
				result.append("<TYPE>" + "BTN" + "</TYPE>");
				result.append("<FUNC>" + "del_poll" + "</FUNC>");
				result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			}
			
			
			result.append("</CELL>");
			result.append("</ROW>");
		}
		
		result.append("</ROWS>");
		result.append("<PROFLAG>" + progressPollFlag + "</PROFLAG>");
		result.append("</LISTVIEWDATA>");
		
		logger.debug("managePollList ended");
		return result.toString();
	}
	
	/**
	 * 초기화면 QuickPoll 등록화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/addPoll.do")
	public String addPoll(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("addPoll started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);

		logger.debug("addPoll ended");
		return "admin/ezPersonal/personalAddPoll";
	}
	
	/**
	 * 초기화면 QuickPoll 등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/savePoll.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String savePoll(@CookieValue("loginCookie") String loginCookie,@RequestBody String data) throws Exception {
		logger.debug("savePoll started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		
		String result = ezPersonalAdminService.insertPoll(doc, userInfo.getTenantId());

		logger.debug("savePoll ended");
		return result;
	}
	
	/**
	 * 초기화면 QuickPoll 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/delPoll.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String delPoll(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request) throws Exception {
		logger.debug("delPoll started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemSeq = request.getParameter("itemSeq");
		
		String result = ezPersonalAdminService.deletePoll(itemSeq, userInfo.getTenantId());

		logger.debug("delPoll ended");
		return result;
	}
	
	/**
	 * 초기화면 QuickPoll 본문화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/pollResult.do")
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
	@RequestMapping(value = "/admin/ezPersonal/managePopup.do")
	public String managePopup(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("managePopup started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		String noneActiveX = config.getProperty("NONEACTIVEX");
		String useEditor = config.getProperty("EDITOR");
		String companyId = userInfo.getCompanyID();
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("companyId", companyId);
		model.addAttribute("list", resultList);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("useEditor", useEditor);

		logger.debug("managePopup ended");
		return "admin/ezPersonal/personalManagePopup";
	}
	
	/**
	 * 초기화면 팝업공지 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/managePopupList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String managePopupList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("managePopupList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		
		
		List<PersonalPopupVO> list = ezPersonalAdminService.getPopupList(companyID, userInfo.getTenantId());
		
		StringBuilder result = new StringBuilder();
		
		result.append("<LISTVIEWDATA>");
		result.append("<ROWS>");
		
		//2018-08-08  김보미 - rownumber추가
		int i = list.size();
		for (PersonalPopupVO vo : list) {
			result.append("<ROW>");
			result.append("<CELL>");
			//2018-08-08  김보미 - rownumber추가
//			result.append("<VALUE>" + vo.getItemSeq() + "</VALUE>");
			result.append("<VALUE>" + i + "</VALUE>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			result.append("<DATA2>" + vo.getWidth() + "</DATA2>");
			result.append("<DATA3>" + vo.getHeight() + "</DATA3>");
			result.append("<DATA4>" + vo.getPosition() + "</DATA4>");
			result.append("</CELL>");
			
			result.append("<CELL>");
			result.append("<VALUE>" + commonUtil.cleanValue(vo.getTitle()) + "</VALUE>");
			result.append("</CELL>");
			
			result.append("<CELL>");
			result.append("<VALUE>" + commonUtil.getDateStringInUTC(vo.getStartDate(), userInfo.getOffset(), false).substring(0, 10) + "</VALUE>");
			result.append("</CELL>");
			
			result.append("<CELL>");
			result.append("<VALUE>" + commonUtil.getDateStringInUTC(vo.getEndDate(), userInfo.getOffset(), false).substring(0, 10) + "</VALUE>");
			result.append("</CELL>");
			
			result.append("<CELL>");
			result.append("<VALUE>" + egovMessageSource.getMessage("ezPersonal.t169", userInfo.getLocale()) + "</VALUE>");
			result.append("<TYPE>" + "BTN" + "</TYPE>");
			result.append("<FUNC>" + "mod_popup" + "</FUNC>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			result.append("</CELL>");
			
			result.append("<CELL>");
			result.append("<VALUE>" + egovMessageSource.getMessage("ezPersonal.t99", userInfo.getLocale()) + "</VALUE>");
			result.append("<TYPE>" + "BTN" + "</TYPE>");
			result.append("<FUNC>" + "del_popup" + "</FUNC>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			result.append("</CELL>");
			result.append("</ROW>");
			i--;
		}
		
		result.append("</ROWS>");
		result.append("</LISTVIEWDATA>");

		logger.debug("managePopupList ended");
		return result.toString();
	}
	
	/**
	 * 팝업공지 공지사항등록,수정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/addPopupCK.do")
	public String addPopupCK(@CookieValue("loginCookie") String loginCookie, PersonalPopupVO vo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("addPopupCK started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemSeq = "";
		
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		String companyID = request.getParameter("companyID");
		
		String initDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm"), userInfo.getOffset(), false);
		
		if (request.getParameter("itemSeq") != null) {
			itemSeq = request.getParameter("itemSeq");
			
			vo = ezPersonalAdminService.getPopupInfo(itemSeq, userInfo.getTenantId());
			vo.setItemSeq(Integer.parseInt(itemSeq));
			vo.setContent(vo.getContent().replace("\r\n", "").replace("\n", "").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&apos;", "\'"));
		} else {
			vo.setWidth(300);
			vo.setHeight(350);
		}
		
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("companyID", companyID);
		model.addAttribute("initDate", initDate);
		model.addAttribute("isoUTFstartDate", commonUtil.getDateStringInUTC(vo.getStartDate(), userInfo.getOffset(), false));
		model.addAttribute("isoUTFEndDate", commonUtil.getDateStringInUTC(vo.getEndDate(), userInfo.getOffset(), false));
		model.addAttribute("personalPopupVO", vo);

		logger.debug("addPopupCK ended");
		return "admin/ezPersonal/personalAddPopupCK";
	}
	
	/**
	 * 팝업공지 공지사항 등록,수정 실행 함수
	 */
	
	@RequestMapping(value = "/admin/ezPersonal/savePopup.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String savePopup(@CookieValue("loginCookie") String loginCookie,PersonalPopupVO vo) throws Exception {
		logger.debug("savePopup started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (vo.getTitle2().equals("")) {
			vo.setTitle2(vo.getTitle());
		}
		
		if (vo.getItemSeq() == null) {
			ezPersonalAdminService.insertPopup(vo, userInfo.getTenantId(), userInfo.getOffset());
		} else {
			ezPersonalAdminService.updatePopup(vo, userInfo.getTenantId(), userInfo.getOffset());
		}

		logger.debug("savePopup ended");
		return "OK";
	}
	
	/**
	 * 팝업공지 공지사항 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/delPopup.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String deletePopup(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request) throws Exception {
		logger.debug("deletePopup started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemSeq = request.getParameter("itemSeq");
		
		ezPersonalAdminService.deletePopup(itemSeq, userInfo.getTenantId());

		logger.debug("deletePopup ended");
		return "OK";
	}
	
	/**
	 * 팝업공지 공지사항 공지사항 본문화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/showPopup.do")
	public String showPopup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, PersonalPopupVO vo, Model model) throws Exception {
		logger.debug("showPopup started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemSeq = request.getParameter("itemSeq");
		String title = "";
		
		vo = ezPersonalAdminService.getPopupInfo(itemSeq, userInfo.getTenantId());
		vo.setStartDate(commonUtil.getDateStringInUTC(vo.getStartDate(), userInfo.getOffset(), false));
		vo.setEndDate(commonUtil.getDateStringInUTC(vo.getEndDate(), userInfo.getOffset(), false));
		String content = vo.getContent().replace("\r\n", "").replace("\n", "").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&apos;", "\'");
		
		
		if (userInfo.getPrimary().equals("2") && !vo.getTitle2().equals("")) {
			title = vo.getTitle2();
		} else {
			title = vo.getTitle();
		}
		
		model.addAttribute("itemSeq", itemSeq);
		model.addAttribute("title", title);
		model.addAttribute("content", content);
		model.addAttribute("user", userInfo.getId());
		
		logger.debug("showPopup ended");
		return "admin/ezPersonal/personalShowPopup";
	}
	
	/**
	 * 초기화면 이달의우수사원메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/employeeOfMonth.do")
	public String employeeOfMonth(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("employeeOfMonth started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<PersonalEmpMonthVO> list = ezPersonalAdminService.getEmpMonth(userInfo.getCompanyID(), userInfo.getTenantId());
		
		for (PersonalEmpMonthVO vo : list) {
			if (userInfo.getPrimary().equals("2")) {
				vo.setDisplayName(vo.getDisplayName2());
				vo.setTitle(vo.getTitle2());
				vo.setDescription(vo.getDescription2());
				vo.setCompany(vo.getCompany2());
			}
		}
		
		model.addAttribute("list", list);

		logger.debug("employeeOfMonth ended");
		return "admin/ezPersonal/personalEmployeeOfMonth";
	}
	
	/**
	 * 초기화면 이달의우수사원 등록화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/selectBest.do")
	public String selectBest(Model model) {
		logger.debug("selectBest started");

		model.addAttribute("nowYear", EgovDateUtil.getCurrentDate("").substring(0, 4));
		
		logger.debug("selectBest ended");
		return "admin/ezPersonal/personalSelectBest";
	}
	
	/**
	 * 초기화면 이달의우수사원 등록,삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/setEmployeeMonth.do")
	@ResponseBody
	public String setEmployeeMonth(HttpServletRequest request, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("setEmployeeMonth started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = "", deptID = "";
		String type = request.getParameter("type");
		String term = request.getParameter("term");
		
		if (request.getParameter("userID") != null) {
			userID = request.getParameter("userID");
		}
		if (request.getParameter("deptID") != null) {
			deptID = request.getParameter("deptID");
		}
		
		try {
			ezPersonalAdminService.setEmpMonth(type, userID, deptID, term, userInfo);
			logger.debug("setEmployeeMonth ended");
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * 초기화면 슬라이드이미지메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/sliderImages.do")
	public String sliderImages() throws Exception {
		return "admin/ezPersonal/personalSliderImages";
	}
	
	/**
	 * 초기화면 슬라이드이미지 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/getSlider.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getSlider(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getSlider started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sliderID = " ";
		
		if (request.getParameter("item") != null) {
			sliderID = request.getParameter("item");
		}
		logger.debug("sliderID="+sliderID);
		
		String result = ezPersonalAdminService.getSlider(sliderID, userInfo);

		logger.debug("getSlider ended");
		return result;
	}
	
	/**
	 * 초기화면 슬라이드이미지 등록화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/selectImage.do")
	public String selectImage(@CookieValue("loginCookie") String loginCookie ,HttpServletRequest request, Model model) throws Exception {
		logger.debug("selectImage started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sliderID = "";
		
		if (request.getParameter("item") != null) {
			sliderID = request.getParameter("item");
		}
		
		String uploadPortalPath = commonUtil.getUploadPath("upload_portal.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		model.addAttribute("sliderID", sliderID);
		model.addAttribute("uploadPortalPath", uploadPortalPath);

		logger.debug("selectImage ended");
		return "admin/ezPersonal/personalSelectImage";
	}
	
	/**
	 * 초기화면 슬라이드이미지 등록 이미지등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/saveSliderImage.do")
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
		
		String realPath = commonUtil.getRealPath(request);
		String serverPath = dirPath + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + mode + commonUtil.separator;
		String uniqueName = uploadSN + multiFile.getOriginalFilename().substring(multiFile.getOriginalFilename().lastIndexOf("."));
		
		File dir = new File(realPath + serverPath);
		
		if (!dir.exists()) {
			dir.mkdirs();
		}
		
		writeUploadedFile(multiFile, uniqueName, realPath + serverPath);
		
		File file = new File(realPath + serverPath + uniqueName);
		
		if (mode.equals("SLIDERIMAGE")) {
			String saveName = UUID.randomUUID() + ".jpg";
			BufferedImage inputImage = ImageIO.read(file);
			BufferedImage outputImage = null;
			Graphics2D saveImage = null;
			
			outputImage= new BufferedImage(467, 200, BufferedImage.TYPE_INT_RGB);
			saveImage = outputImage.createGraphics();
			saveImage.drawImage(inputImage, 0, 0, 467, 200, null);
			saveImage.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
			
			File newFile = new File(realPath + serverPath + saveName);
			
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
	@RequestMapping(value = "/admin/ezPersonal/saveSlider.do", produces = "text/xml; charset=utf-8")
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
		
		ezPersonalAdminService.setSliderImage(sliderID, displayName, displayName2, sliderPath, fileName, mode, userInfo, url);

		logger.debug("saveSlider ended");
		return "OK";
	}
	
	/**
	 * 초기화면 슬라이드이미지 상태,순서 변경 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/statusChangeSlider.do")
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
	
	@RequestMapping(value = "/admin/ezPersonal/deleteSlider.do")
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
	@RequestMapping(value = "/admin/ezPersonal/delQuickLink.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String  delQuickLink(@CookieValue("loginCookie") String loginCookie, @RequestBody String data) throws Exception {
		logger.debug("delQuickLink started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		ezPersonalAdminService.delQuickLink(doc.getElementsByTagName("pQuickLinkID").item(0).getTextContent(), userInfo.getTenantId());

		logger.debug("delQuickLink ended");
		return "OK";
	}
	
	/**
	 * 초기화면 QuickLink typeImage 추가
	 */
	@RequestMapping(value = "/admin/ezPersonal/typeImageUpload.do", produces = "text/xml; charset=utf-8")
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
       
        File dir = new File(realPath + serverPath);
		
   		if (!dir.exists()) {
   			dir.mkdirs();
   		}
   		
   		/* 2018-08-30 홍승비 - 퀵링크 이미지 등록 시 원래 인코딩(content-type)으로 수정 */
		String contentType = null;
		String extension = null;
        BufferedInputStream bis = null;
   		
        File file = new File(realPath + pAttachPath);
    
        try {
	        bis = new BufferedInputStream(new FileInputStream(file));
	        contentType = URLConnection.guessContentTypeFromStream(bis);
        } catch(Exception e) {
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
			outputImage= new BufferedImage(40, 39, BufferedImage.TYPE_INT_RGB);
		} else {
			outputImage= new BufferedImage(40, 39, inputImage.getType());
		}
		
		saveImage = outputImage.createGraphics();
		saveImage.drawImage(inputImage, 0, 0, 40, 39, null);
		
		HashMap<RenderingHints.Key,Object> hm = new HashMap<RenderingHints.Key,Object>();
		
		hm.put(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
		hm.put(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
		hm.put(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
		
		saveImage.setRenderingHints(hm);
		
		File newFile = new File(realPath + serverPath + pSaveName);
		
		ImageIO.write(outputImage, extension.replace(".", "") , newFile);
		//deleteFile(dirPath + serverPath + fileName);
		
		String fileLocation = serverPath  + pSaveName;
	
		strXML.append("<ROOT><NODES>");
		strXML.append("<NODE><PUPLOADSN><![CDATA[" + qID + extension + "]]></PUPLOADSN>");
		strXML.append("<RESULTUPLOADA><![CDATA[true]]></RESULTUPLOADA>");
		strXML.append( "<PFILENAME><![CDATA[" + qID + extension + "]]></PFILENAME>");
		strXML.append( "<FILESIZE>" + (int) multiFile.getSize() + "</FILESIZE>");
		strXML.append("<FILELOCATION><![CDATA[" + fileLocation + "]]></FILELOCATION>");
		strXML.append( "</NODE>");
		strXML.append("</NODES></ROOT>");
            
		logger.debug("typeImageUpload ended");
		model.addAttribute("strXML", strXML);

		return "/admin/ezPortal/portalPortletImageUpload";
	}
}
