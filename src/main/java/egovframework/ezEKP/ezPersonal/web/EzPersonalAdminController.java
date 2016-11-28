package egovframework.ezEKP.ezPersonal.web;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.File;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

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
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
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
	public String personalLeft (Model model) throws Exception {
		String usePortal = config.getProperty("config.Use_Portal");
		String useKMS = config.getProperty("config.Use_ezKMS");
		
		model.addAttribute("usePortal", usePortal);
		model.addAttribute("useKMS", useKMS);
		
		return "admin/ezPersonal/personalLeft";
	}
	
	/**
	 * 초기화면 공지사항메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/manageNotice.do")
	public String manageNotice (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
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
		
		return "admin/ezPersonal/personalManageNotice";
	}
	
	/**
	 * 초기화면 공지사항 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/manageNoticeList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String manageNoticeList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean auth = commonUtil.checkAdmin(loginCookie);
		String companyID = request.getParameter("id");
		int currentPage = Integer.parseInt(request.getParameter("page"));
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		
		StringBuilder result = new StringBuilder();
		int pageSize = 12;
		int cnt = 0;
		
		int totalCount = ezPersonalAdminService.getNoticeCount(companyID);
		int pageCount = (int)((totalCount + pageSize - 1) / pageSize);
		int iSn = totalCount - ((currentPage -1 ) * 12);
		
		result.append("<LISTVIEWDATA>");
		result.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		result.append("<PAGECNT>" + pageCount + "</PAGECNT>");
		result.append("<CURPAGE>" + currentPage + "</CURPAGE>");
		result.append("<CNT>" + cnt + "</CNT>");
		
		List<PersonalNoticeVO> list = ezPersonalAdminService.getNoticeList(companyID, totalCount, pageSize, (currentPage-1) * pageSize);
		
		result.append("<ROWS>");
		
		for (PersonalNoticeVO vo : list) {
			result.append("<ROW><CELL><VALUE>" + iSn + "</VALUE>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1></CELL>");
			
			result.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getTitle()) + "</VALUE></CELL>");
			result.append("<CELL><VALUE>" + vo.getPostDate().substring(0, 10) + "</VALUE></CELL>");
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
		
		return result.toString();
	}
	
	/**
	 * 초기화면 공지사항 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/delNotice.do", produces = "text/xml; charset=utf-8") 
	@ResponseBody
	public String delNotice(HttpServletRequest request) throws Exception {
		String itemSeq = request.getParameter("itemSeq");
		
		String result = ezPersonalAdminService.deleteNotice(itemSeq);
		
		return result;
	}
	
	/**
	 * 초기화면 공지사항 등록,수정화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/addNoticeCK.do")
	public String addNoticeCK(@CookieValue("loginCookie") String loginCookie, PersonalNoticeVO vo, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String langPrimary = config.getProperty("config.lang_Primary" + userInfo.getLang());
		String langSecondary = config.getProperty("config.lang_Secondary" + userInfo.getLang());
		String itemSeq = "";
		
		if (request.getParameter("itemSeq") != null) {
			itemSeq = request.getParameter("itemSeq");
			
			vo = ezPersonalAdminService.getNoticeInfo(itemSeq);
			vo.setContent(vo.getContent().replace("\r\n", "").replace("\n", "").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&apos;", "\'"));
		}
		
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("personalNoticeVO", vo);
		
		return "admin/ezPersonal/personalAddNoticeCK";
	}
	
	/**
	 * 초기화면 공지사항 등록,수정 본문화면 CK에디터 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/addNoticeCKContent.do")
	public String addNoticeCKContent(@CookieValue("loginCookie") String loginCookie, Model model) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
				
		return "admin/ezPersonal/personalAddNoticeCKContent";
	}
	
	/**
	 * 초기화면 공지사항 등록,수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/saveNotice.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveNotice(@ModelAttribute PersonalNoticeVO vo) throws Exception {
		if (vo.getTitle2() == null) {
			vo.setTitle2(vo.getTitle());
		}
		
		if (vo.getItemSeq() == null) {
			String result = ezPersonalAdminService.insertNotice(vo.getCompanyID(), vo.getTitle(), vo.getTitle2(), vo.getContent());
			return result;
		} else {
			String result = ezPersonalAdminService.updateNotice(vo.getCompanyID(), vo.getTitle(), vo.getTitle2(), vo.getContent(), vo.getItemSeq());
			return result;
		}
	}
	
	/**
	 * 초기화면 공지사항 본문화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/showNotice.do")
	public String showNotice(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemSeq = request.getParameter("itemSeq");
		
		PersonalNoticeVO vo = ezPersonalAdminService.getNoticeInfo(itemSeq);

		if (vo.getTitle2() == null) {
			vo.setTitle2(vo.getTitle());
		}
		vo.setContent(vo.getContent().replace("<a ", "<a target='_blank'").replace("<A ", "<A target='_blank'"));
		vo.setPostDate(vo.getPostDate().substring(0, 10));
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("personalNoticeVO", vo);
		
		return "admin/ezPersonal/personalShowNotice";
	}
	
	/**
	 * 초기화면 QuickLink메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/manageQuickLink.do")
	public String manageQuickLink(@CookieValue("loginCookie") String loginCookie) {
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		
		return "admin/ezPersonal/personalManageQuickLink";
	}
	
	/**
	 * 초기화면 QuickLink 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/getQuickLinkList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getQuickLinkList() throws Exception {
		String result = ezPersonalAdminService.getQuickLinkList();
		return result;
	}
	
	/**
	 * 초기화면 QuickLink 등록,수정화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/addQuickLink.do")
	public String addQuickLink(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = "new";
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		
		model.addAttribute("strUserLang", commonUtil.getMultiData(userInfo.getLang()));
		model.addAttribute("primary", userInfo.getPrimary());
		model.addAttribute("mode", mode);
		
		return "admin/ezPersonal/personalAddQuickLink";
	}
	
	/**
	 * 초기화면 QuickLink 수정화면 내용 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/getQuickLink.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getQuickLink(HttpServletRequest request) throws Exception {
		String quickLinkID = request.getParameter("pQuickLinkID");
		
		String result = ezPersonalAdminService.getQuickLink(quickLinkID);
		
		return result;
	}
	
	/**
	 * 초기화면 QuickLink 권한목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/getQuickLinkACL.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getQuickLinkACL(HttpServletRequest request) throws Exception {
		String quickLinkID = request.getParameter("pQuickLinkID");
		
		String result = ezPersonalAdminService.getQuickLinkACL(quickLinkID);
		
		return result;
	}
	
	/**
	 * 초기화면 QuickLink 권한등록화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/selectTarget.do")
	public String selectTarget(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String topID = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topID = userInfo.getCompanyID();
		} else {
			topID = "Top";
		}
		
		model.addAttribute("strUserLang", commonUtil.getMultiData(userInfo.getLang()));
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("topID", topID);
		
		return "admin/ezPersonal/personalSelectTarget";
	}
	
	/**
	 * 초기화면 QuickLink 등록,수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/saveQuickLink.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void  saveQuickLink(@CookieValue("loginCookie") String loginCookie, @RequestBody String data) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		
		ezPersonalAdminService.saveQuickLink(userInfo, doc);
	}
	
	/**
	 * 초기화면 QuickPoll메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/managePoll.do")
	public String managePoll(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
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
		
		return "admin/ezPersonal/personalManagePoll";
	}
	
	/**
	 * 초기화면 QuickPoll 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/managePollList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String managePollList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int currentPage = 1, pageSize = 12;
		String progressPollFlag = "false";
		StringBuilder result = new StringBuilder();
		
		String companyID = request.getParameter("companyID");
		
		if (request.getParameter("page") != null) {
			currentPage = Integer.parseInt(request.getParameter("page"));
		}
		
		int totalCount = ezPersonalAdminService.getPollCount(companyID);
		int pageCount = (int)((totalCount + pageSize - 1) / pageSize);
		List<PersonalLightPollVO> list = ezPersonalAdminService.getPollList(companyID, totalCount, pageSize, (currentPage - 1) * pageSize);
		
		result.append("<LISTVIEWDATA>");
		result.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		result.append("<PAGECNT>" + pageCount + "</PAGECNT>");
		result.append("<CURPAGE>" + currentPage + "</CURPAGE>");
		result.append("<ROWS>");
		
		for (PersonalLightPollVO vo : list) {
			result.append("<ROW>");
			result.append("<CELL>");
			result.append("<VALUE>" + vo.getItemSeq() + "</VALUE>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			result.append("</CELL>");
			result.append("<CELL>");
			result.append("<VALUE>" + vo.getPollTitle() + "</VALUE>");
			result.append("</CELL>");
			result.append("<CELL>");
			result.append("<VALUE>" + vo.getStartDate().substring(0, 10) + "</VALUE>");
			result.append("</CELL>");
			result.append("<CELL>");
			
			if (vo.getEndDate().indexOf("1900-01-01") > -1) {
				result.append("<VALUE>" + egovMessageSource.getMessage("ezPersonal.t244", userInfo.getLocale()) + "</VALUE>");
				progressPollFlag = "true";
			} else {
				result.append("<VALUE>" + vo.getEndDate().substring(0, 10) + "</VALUE>");
			}
			
			result.append("</CELL>");
			result.append("<CELL>");
			result.append("<VALUE>" + egovMessageSource.getMessage("ezPersonal.t99", userInfo.getLocale()) + "</VALUE>");
			result.append("<TYPE>" + "BTN" + "</TYPE>");
			result.append("<FUNC>" + "del_poll" + "</FUNC>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			result.append("</CELL>");
			result.append("</ROW>");
		}

		result.append("</ROWS>");
		result.append("<PROFLAG>" + progressPollFlag + "</PROFLAG>");
		result.append("</LISTVIEWDATA>");
		
		return result.toString();
	}
	
	/**
	 * 초기화면 QuickPoll 등록화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/addPoll.do")
	public String addPoll(@CookieValue("loginCookie") String loginCookie, Model model) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String langPrimary = config.getProperty("config.lang_Primary" + userInfo.getLang());
		String langSecondary = config.getProperty("config.lang_Secondary" + userInfo.getLang());
		
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		
		return "admin/ezPersonal/personalAddPoll";
	}
	
	/**
	 * 초기화면 QuickPoll 등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/savePoll.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String savePoll(@RequestBody String data) throws Exception {
		Document doc = commonUtil.convertStringToDocument(data);
		
		String result = ezPersonalAdminService.insertPoll(doc);
		
		return result;
	}
	
	/**
	 * 초기화면 QuickPoll 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/delPoll.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String delPoll(HttpServletRequest request) throws Exception {
		String itemSeq = request.getParameter("itemSeq");
		
		String result = ezPersonalAdminService.deletePoll(itemSeq);
		
		return result;
	}
	
	/**
	 * 초기화면 QuickPoll 본문화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/pollResult.do")
	public String pollResult(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String subject = "", title = "";
		
		String itemSeq = request.getParameter("itemSeq");
		
		
		
		PersonalLightPollVO infoVO = ezPersonalAdminService.getPollInfo(itemSeq);
		
		if (userInfo.getPrimary().equals("2") && infoVO.getPollTitle2() != null) {
			subject = infoVO.getPollTitle2();
		} else {
			subject = infoVO.getPollTitle();
		}
		
		if (infoVO.getEndDate().indexOf("1990-01-01") > -1) {
			title = infoVO.getStartDate() + " - " + egovMessageSource.getMessage("ezPersonal.t244", userInfo.getLocale());
		} else {
			title = infoVO.getStartDate() + " - " + infoVO.getEndDate();
		}
		
		List<PersonalLightPollVO> list = ezPersonalAdminService.getPollResult(itemSeq);

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
					fieldValue = String.valueOf(field.get(infoVO));
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
		
		return "admin/ezPersonal/personalPollResult";
	}
	
	/**
	 * 초기화면 팝업공지메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/managePopup.do")
	public String managePopup(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String noneActiveX = config.getProperty("NONEACTIVEX");
		String useEditor = config.getProperty("EDITOR");
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
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
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("useEditor", useEditor);
		
		return "admin/ezPersonal/personalManagePopup";
	}
	
	/**
	 * 초기화면 팝업공지 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/managePopupList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String managePopupList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		

		List<PersonalPopupVO> list = ezPersonalAdminService.getPopupList(companyID);
		
		StringBuilder result = new StringBuilder();
		
		result.append("<LISTVIEWDATA>");
		result.append("<ROWS>");
		
		for (PersonalPopupVO vo : list) {
			result.append("<ROW>");
			result.append("<CELL>");
			result.append("<VALUE>" + vo.getItemSeq() + "</VALUE>");
			result.append("<DATA1>" + vo.getItemSeq() + "</DATA1>");
			result.append("<DATA2>" + vo.getWidth() + "</DATA2>");
			result.append("<DATA3>" + vo.getHeight() + "</DATA3>");
			result.append("<DATA4>" + vo.getPosition() + "</DATA4>");
			result.append("</CELL>");
			
			result.append("<CELL>");
			result.append("<VALUE>" + vo.getTitle() + "</VALUE>");
			result.append("</CELL>");
			
			result.append("<CELL>");
			result.append("<VALUE>" + vo.getStartDate().substring(0, 10) + "</VALUE>");
			result.append("</CELL>");
			
			result.append("<CELL>");
			result.append("<VALUE>" + vo.getEndDate().substring(0, 10) + "</VALUE>");
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
		}

		result.append("</ROWS>");
		result.append("</LISTVIEWDATA>");
		
		return result.toString();
	}
	
	/**
	 * 팝업공지 공지사항등록,수정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/addPopupCK.do")
	public String addPopupCK(@CookieValue("loginCookie") String loginCookie, PersonalPopupVO vo, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemSeq = "";
		String langPrimary = config.getProperty("config.lang_Primary" + userInfo.getLang());
		String langSecondary = config.getProperty("config.lang_Secondary" + userInfo.getLang());
		String companyID = request.getParameter("companyID");
		
		String initDate = ezResourceService.getLocalTime(EgovDateUtil.getTodayTime());
		
		if (request.getParameter("itemSeq") != null) {
			itemSeq = request.getParameter("itemSeq");
			
			vo = ezPersonalAdminService.getPopupInfo(itemSeq);
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
		model.addAttribute("isoUTFstartDate", commonUtil.isoUTFDate(vo.getStartDate()));
		model.addAttribute("isoUTFEndDate", commonUtil.isoUTFDate(vo.getEndDate()));
		model.addAttribute("personalPopupVO", vo);
		
		return "admin/ezPersonal/personalAddPopupCK";
	}
	
	/**
	 * 팝업공지 공지사항 수정 본문화면 CK에디터 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/addPopupCKContent.do")
	public String addPopupCKContent(@CookieValue("loginCookie") String loginCookie, Model model) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		return "admin/ezPersonal/personalAddPopupCKContent";
	}
	
	/**
	 * 팝업공지 공지사항 등록,수정 실행 함수
	 */
	
	@RequestMapping(value = "/admin/ezPersonal/savePopup.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String savePopup(PersonalPopupVO vo) throws Exception {
		if (vo.getTitle2().equals("")) {
			vo.setTitle2(vo.getTitle());
		}
		
		try {
			if (vo.getItemSeq() == null) {
				ezPersonalAdminService.insertPopup(vo);
			} else {
				ezPersonalAdminService.updatePopup(vo);
			}
			
			return "OK";
		} catch (Exception e) {
			return "ERROR";
		}
	}
	
	/**
	 * 팝업공지 공지사항 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/delPopup.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String deletePopup(HttpServletRequest request) throws Exception {
		String itemSeq = request.getParameter("itemSeq");
		
		try {
			ezPersonalAdminService.deletePopup(itemSeq);
			
			return "OK";
		} catch (Exception e) {
			return "ERROE";
		}
	}
	
	/**
	 * 팝업공지 공지사항 공지사항 본문화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/showPopup.do")
	public String showPopup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, PersonalPopupVO vo, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemSeq = request.getParameter("itemSeq");
		String title = "";
		
		vo = ezPersonalAdminService.getPopupInfo(itemSeq);

		String content = vo.getContent().replace("\r\n", "").replace("\n", "").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&apos;", "\'");
		
		if (userInfo.getPrimary().equals("2") && !vo.getTitle2().equals("")) {
			title = vo.getTitle2();
		} else {
			title = vo.getTitle();
		}
		
		model.addAttribute("itemSeq", itemSeq);
		model.addAttribute("title", title);
		model.addAttribute("content", content);
		
		return "admin/ezPersonal/personalShowPopup";
	}
	
	/**
	 * 초기화면 이달의우수사원메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/employeeOfMonth.do")
	public String employeeOfMonth(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<PersonalEmpMonthVO> list = ezPersonalAdminService.getEmpMonth(userInfo.getCompanyID());
		
		for (PersonalEmpMonthVO vo : list) {
			if (userInfo.getPrimary().equals("2")) {
				vo.setDisplayName(vo.getDisplayName2());
				vo.setTitle(vo.getTitle2());
				vo.setDescription(vo.getDescription2());
				vo.setCompany(vo.getCompany2());
			}
		}
		
		model.addAttribute("list", list);
		
		return "admin/ezPersonal/personalEmployeeOfMonth";
	}
	
	/**
	 * 초기화면 이달의우수사원 등록화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/selectBest.do")
	public String selectBest() {
		return "admin/ezPersonal/personalSelectBest";
	}
	
	/**
	 * 초기화면 이달의우수사원 등록,삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/setEmployeeMonth.do")
	@ResponseBody
	public String setEmployeeMonth(HttpServletRequest request) throws Exception {
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
			ezPersonalAdminService.setEmpMonth(type, userID, deptID, term);
			
			return "OK";
		} catch (Exception e) {
			return "ERROR";
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
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sliderID = " ";
		
		if (request.getParameter("item") != null) {
			sliderID = request.getParameter("item");
		}
		
		String result = ezPersonalAdminService.getSlider(sliderID, userInfo);
		
		return result;
	}
	
	/**
	 * 초기화면 슬라이드이미지 등록화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/selectImage.do")
	public String selectImage(HttpServletRequest request, Model model) throws Exception {
		String sliderID = "";
		
		if (request.getParameter("item") != null) {
			sliderID = request.getParameter("item");
		}
		
		model.addAttribute("sliderID", sliderID);
		
		return "admin/ezPersonal/personalSelectImage";
	}
	
	/**
	 * 초기화면 슬라이드이미지 등혹 이미지등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/saveSliderImage.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveSliderImage(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String dirPath = config.getProperty("upload_portal.ROOT");
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
		
		if (mode.equals("sliderImage")) {
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
		
		StringBuilder result = new StringBuilder();
		
		result.append("<ROOT>");
		result.append("<NODES>");
		result.append("<NODE>");
		result.append("<PUPLOADSN><![CDATA[" + uniqueName + "]]></PUPLOADSN>");
		result.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
		result.append("<PFILENAME><![CDATA[" + multiFile.getOriginalFilename() + "]]></PFILENAME>");
		result.append("<FILESIZE>" + (int) multiFile.getSize() + "</FILESIZE>");
		result.append("<FILELOCATION><![CDATA[" + fileLocation + "]]></FILELOCATION>");
		result.append("</NODE>");
		result.append("</NODES>");
		result.append("</ROOT>");
		
		return result.toString();
	}
	
	/**
	 * 초기화면 슬라이드이미지 등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/saveSlider.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveSlider(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sliderID = request.getParameter("sliderID");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");
		String sliderPath = request.getParameter("sliderImage");
		String fileName = request.getParameter("fileName");
		String mode = request.getParameter("mode");
		
		try {
			ezPersonalAdminService.setSliderImage(sliderID, displayName, displayName2, sliderPath, fileName, mode, userInfo);
			
			return "OK";
		} catch (Exception e) {
			return "ERROR";
		}
	}
	
	/**
	 * 초기화면 슬라이드이미지 상태,순서 변경 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/statusChangeSlider.do")
	@ResponseBody
	public String statusChangeSlider(HttpServletRequest request) throws Exception {
		String result = "";
		String mode = request.getParameter("mode");
		
		if (mode.equals("U")) {
			String sliderID = request.getParameter("sliderID");
			String isUse = request.getParameter("isUse");
			
			result = ezPersonalAdminService.statusChangeSlider1(sliderID, isUse, mode);
		} else {
			String aRuleID = request.getParameter("aRuleID");
			String aPriority = request.getParameter("aPriority");
			String bRuleID = request.getParameter("bRuleID");
			String bPriority = request.getParameter("bPriority");
			
			result = ezPersonalAdminService.statusChangeSlider2(aRuleID, aPriority, bRuleID, bPriority, mode);
		}
		
		return result;
	}
	
	@RequestMapping(value = "/admin/ezPersonal/deleteSlider.do")
	@ResponseBody
	public String deleteSlider(HttpServletRequest request) throws Exception {
		String sliderID = request.getParameter("sliderID");
		
		try {
			ezPersonalAdminService.deleteSlider(sliderID);
			
			return "OK";
		} catch (Exception e) {
			return "ERROR";
		}
	}
	
	/**
	 * 초기화면 QuickLink 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/delQuickLink.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String  delQuickLink(@CookieValue("loginCookie") String loginCookie, @RequestBody String data) throws Exception {
		Document doc = commonUtil.convertStringToDocument(data);
System.out.println("quickLinkID:"+doc.getElementsByTagName("pQuickLinkID").item(0).getTextContent());
		ezPersonalAdminService.delQuickLink(doc.getElementsByTagName("pQuickLinkID").item(0).getTextContent());
		return "OK";
	}
}
