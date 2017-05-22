package egovframework.ezEKP.ezCircular.web;

import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Folder;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

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
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezCircular.service.EzCircularService;
import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCircularController {

	private static final Logger logger = LoggerFactory.getLogger(EzCircularController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Autowired
	private EzCircularService ezCircularService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 회람판 메인화면 호출 Method
	 */
	@RequestMapping(value="/ezCircular/circularIndex.do")
	public String main(HttpServletRequest req, Model model) {
		
		logger.debug("Circularmain started");
		
		String func = "";
		String subFunc = "";

		if (req.getParameter("func") != null && !req.getParameter("func").equals("")) {
			func = req.getParameter("func");	
		}
		if (req.getParameter("subFunc") != null && !req.getParameter("subFunc").equals("")) {
			subFunc = req.getParameter("subFunc");	
		}
		
		model.addAttribute("func", func);
		model.addAttribute("subFunc", subFunc);
		
		logger.debug("Circularmain ended");
		
		return "/ezCircular/circularMain";
	}
	
	/**
	 * 회람판 왼쪽화면 호출 Method
	 * @throws Exception 
	 */
	@RequestMapping(value="/ezCircular/circularLeft.do")
	public String circularLeft(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("showMailLeft started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		StringBuilder rootFolderXML = new StringBuilder();
		StringBuilder rootAddressXML = new StringBuilder();
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			List<Folder> rootMailFolderList = ia.getTopLevelFolders();
			
			for (int i=0,j=0; i<rootMailFolderList.size(); i++) {
				Folder folder = rootMailFolderList.get(i);
				
				String folderName = folder.getName();
				int folderUnreadMessageCount = folder.getUnreadMessageCount();
				
				rootFolderXML.append("<node imgidx='1'");
				
				if (folderUnreadMessageCount > 0) {
					if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
						rootFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025", locale) + "(" + folderUnreadMessageCount + ")'");
					} else {
						rootFolderXML.append(" caption='" + folderName + "(" + folderUnreadMessageCount + ")'");
					}
				} else {
					if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
						rootFolderXML.append(" caption='" + egovMessageSource.getMessage("ezEmail.t99000025", locale) + "'");
					} else {
						rootFolderXML.append(" caption='" + folderName+"'");
					}
				}
				
				if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
					rootFolderXML.append(" foldername='" + egovMessageSource.getMessage("ezEmail.t99000025", locale) + "'");
				} else {
					rootFolderXML.append(" foldername='" + folderName+"'");
				}

				if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
					rootFolderXML.append(" orgBoxName='0'");
					rootFolderXML.append(" fullcaption='_INBOX'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t645", locale))) {
					rootFolderXML.append(" orgBoxName='1'");
					rootFolderXML.append(" fullcaption='_SENT'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t646", locale))) {
					rootFolderXML.append(" orgBoxName='2'");
					rootFolderXML.append(" fullcaption='_DRAFT'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t647", locale))) {
					rootFolderXML.append(" orgBoxName='3'");
					rootFolderXML.append(" fullcaption='_DELETE'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t648", locale))) {
					rootFolderXML.append(" orgBoxName='4'");
					rootFolderXML.append(" fullcaption='_PERSONAL'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000029", locale))) {
					rootFolderXML.append(" orgBoxName='5'");
					rootFolderXML.append(" fullcaption='_JUNK'"); //수정
				} else {
					rootFolderXML.append(" orgBoxName='" + ((j++) + 6) + "'");
					rootFolderXML.append(" fullcaption='_NONE'"); //수정
				}

				rootFolderXML.append(" href='" + folder.getFullName() + "'"); //수정
				
				if (folder.list().length > 0) {
					rootFolderXML.append(" hassub='1'");
				}
				if (folderUnreadMessageCount > 0) {
					rootFolderXML.append(" style='font-weight:bold'");
				}
				
				rootFolderXML.append("></node>");
				
			}
		} catch (Exception e) {
			logger.error("Error get unread message count: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		Map<String, String> map = ezAddressService.getTopFolderSubCount(loginInfo.getTenantId(), loginInfo.getId(), loginInfo.getDeptID(), loginInfo.getCompanyID());
		
		String pHasSub = "";
		String dHasSub = "";
		String cHasSub = "";
		
		if (map != null) {
			if (map.get("P") != null && !map.get("P").equals("0")) {
				pHasSub = "1";
			}
			if (map.get("D") != null && !map.get("D").equals("0")) {
				dHasSub = "1";
			}
			if (map.get("C") != null && !map.get("C").equals("0")) {
				cHasSub = "1";
			}
		}
		
		rootAddressXML.append("<tree>");
		rootAddressXML.append("<nodes>");
        String xmlFormat = "<node imgidx=\"%s\" caption=\"%s\" ownerid=\"%s\" type=\"%s\" folderid=\"%s\" changekey=\"%s\" hassub=\"%s\"></node>";
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000038", locale), user.getId(), "P", "0", "", pHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000039", locale), user.getDeptID(), "D", "0", "", dHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000040", locale), user.getCompanyID(), "C", "0", "", cHasSub));
        rootAddressXML.append("</nodes>");
        rootAddressXML.append("</tree>");
        
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		
		String funCode = "1";
		if (request.getParameter("funCode") != null) {
			funCode = request.getParameter("funCode");
		}
		
		model.addAttribute("mailServerAddress", mailServerAddress);
		model.addAttribute("rootFolderXML", rootFolderXML.toString());
		model.addAttribute("rootAddressXML", rootAddressXML.toString());
		model.addAttribute("funCode", funCode);
		
		logger.debug("showMailLeft ended.");
		
		//return "ezEmail/mailLeft";
		
		return "/ezCircular/circularLeft";
	}
	
	@RequestMapping(value = "/ezcircular/newCircular.do")
	public String newCircular(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("newCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		int page = 1;
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId()); 
        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
        
		if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		List<CircularListVO> list = ezCircularService.getCircularList(userInfo.getId(), userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useRunTime", useRunTime);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("list", list);
		
		logger.debug("newCircular ended");
		return "/ezCircular/newCircular";
	}
	
	/**
	 * 작성분 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circular2.do")
	public String circular2(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular2 started");
		
		
		
		logger.debug("Circular2 ended");
		
		return "/ezCircular/circular2";
	}
	
	/**
	 * 휴지통 화면 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circular3.do")
	public String circular3(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular3 started");
		
		
		
		logger.debug("Circular3 ended");
		
		return "/ezCircular/circular3";
	}
	
	/**
	 * 임시저장 화면 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circular4.do")
	public String circular4(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular4 started");
		
		
		
		logger.debug("Circular4 ended");
		
		return "/ezCircular/circular4";
	}
	
	/**
	 * 확인완료 화면 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circular5.do")
	public String circular5(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular5 started");
		
		
		
		logger.debug("Circular5 ended");
		
		return "/ezCircular/circular5";
	}
	
	/**
	 * 환경설정 화면 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularConfig.do")
	public String circularConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("circularConfig started");
		
		
		
		logger.debug("circularConfig ended");
		
		return "/ezCircular/circularConfig";
	}
	
	@RequestMapping(value = "/ezCircular/circularGeneral.do")
	public String circuralGeneral(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, Model model) throws Exception {
		
		logger.debug("circuralGeneral started");
		
		loginVO = commonUtil.userInfo(loginCookie);
		String memberId = loginVO.getId();
		
		CircularConfigVO circularListConfig = ezCircularService.getCircularList_Config(memberId, loginVO.getTenantId());
		
		if (circularListConfig == null) {
			circularListConfig = new CircularConfigVO();
			circularListConfig.setIsMailReceive(0);
			circularListConfig.setListCnt(10);
			circularListConfig.setIsPreview(0);
			circularListConfig.setPreviewListValue("50");
			circularListConfig.setPreviewContentValue("50");
		}
		
		model.addAttribute("circularListConfig", circularListConfig);
		
		logger.debug("circuralGeneral started");
		
		return "/ezCircular/circularGeneral";
	}
	
	@RequestMapping(value = "/ezCircular/circular_generallist_save.do", method = RequestMethod.POST)
	@ResponseBody
	public void circular_generallist_save(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularConfigVO circularConfigVO) throws Exception {
		
		logger.debug("circular_generallist_save started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		circularConfigVO.setTenantId(userInfo.getTenantId());
		circularConfigVO.setMemberId(userInfo.getId());

		if (request.getParameter("isPreview").equals("0")) {
			circularConfigVO.setPreviewListValue("50");
			circularConfigVO.setPreviewContentValue("50");
		}

		ezCircularService.setCircularList_Config(circularConfigVO);
		
		logger.debug("circular_generallist_save ended");
	}
	
	/**
	 * 회람판 리스트설정셋팅 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/circularGeneralListSave2.do")
	public String boardGeneralListSave2(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String listCount = request.getParameter("listCount");
		String previewMode = request.getParameter("previewMode");
		String list = request.getParameter("list");
		String content = request.getParameter("content");
		
		ezCircularService.setCircularList_Config2(userID, listCount, previewMode, list, content, userInfo.getTenantId());
		
		return "json";
	}
	
	/**
	 * 회람판 게시물설정 표출 Method
	 */
	@RequestMapping(value = "/ezCircular/setCircularConfig.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String setBoardConfig(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		logger.debug("setBoardConfig started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("pUserID");
		String listCount = request.getParameter("pListCount");
		String preView = request.getParameter("pPreView");
		
		logger.debug("userID : "+userID + ", listCount : " + listCount + ", preView : " + preView);
		
		int tempCount = 10;
		
		if (listCount != null) {
			tempCount = Integer.parseInt(listCount);
		}
		
		if (preView != null && preView.equals("OFF")) {
			preView = "0";
		} else if (preView != null && preView.equals("H")) {
			preView = "1";
		} else if (preView != null && preView.equals("W")) {
			preView = "2";
		}
		String result = ezCircularService.setCircularConfig(userID, tempCount, preView, userInfo.getTenantId());

		logger.debug("setBoardConfig ended");
		return result;
	}
	
	/**
	 * 회람판 신규회람판 리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getCircularList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getBoardList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
    	logger.debug("getBoardList started");

    	userInfo = commonUtil.userInfo(loginCookie);
    	
    	List<CircularListVO> list = ezCircularService.getCircularList(userInfo.getId(), userInfo.getTenantId());
    	
    	model.addAttribute("list", list);
    	model.addAttribute("userInfo", userInfo);
    	
		logger.debug("getBoardList ended");
        return "";
    }
}
