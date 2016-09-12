package egovframework.ezEKP.ezPersonal.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalAdminService;
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
public class EzPersonalAdminController {
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
	 * 초기화면 공지사항 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/manageNotice.do")
	public String manageNotice (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary());
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
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary());
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
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary());
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
	
	@RequestMapping(value = "/admin/ezPersonal/savePopup.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String savePopup(PersonalPopupVO vo) throws Exception {
		if (vo.getTitle2().equals("")) {
			vo.setTitle2(vo.getTitle());
		}
		
		try {
			if (vo.getItemSeq().equals("")) {
				ezPersonalAdminService.insertPopup(vo);
			} else {
				ezPersonalAdminService.updatePopup(vo);
			}
			
			return "OK";
		} catch (Exception e) {
			return "ERROR";
		}
	}
}
