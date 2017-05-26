package egovframework.ezEKP.ezCircular.web;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.mail.Folder;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezCircular.service.EzCircularService;
import egovframework.ezEKP.ezCircular.vo.CircularAttachVO;
import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.ezEKP.ezCircular.vo.CircularDeptVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCircularController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzCircularController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Autowired
	private EzCircularService ezCircularService;
	
	@Autowired
	private EzResourceService ezResourceService;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
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
		
		logger.debug("circularLeft started.");
		
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
		
		logger.debug("circularLeft ended.");

		return "/ezCircular/circularLeft";
	}
	
	/**
	 * 신규회람판 호출 Method
	 */
	@RequestMapping(value = "/ezcircular/newCircular.do")
	public String newCircular(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("newCircular started");
		//TODO
		userInfo = commonUtil.userInfo(loginCookie);
		
		int page = 1;
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId()); 
        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
        int startRow = 1;
        int endRow = 0;
        
		if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		CircularConfigVO config = ezCircularService.getPersonalCount(userInfo);
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (page - 1)) + 1;
        endRow = (personalCount * page);
		
        int totalCount = ezCircularService.getCircularListCount(userInfo.getId(), userInfo.getTenantId());
        
        logger.debug("startRow : "+startRow);
        logger.debug("endRow : "+endRow);
        
		List<CircularListVO> list = ezCircularService.getCircularList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
		logger.debug("listSize : "+list.size());
		
		for (CircularListVO result : list) {
			result.setRegDate(commonUtil.getDateStringInUTC(result.getRegDate(), userInfo.getOffset(), false));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useRunTime", useRunTime);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("list", list);
		model.addAttribute("config", config);
		model.addAttribute("totalCount", totalCount);
		
		logger.debug("newCircular ended");
		return "/ezCircular/newCircular";
	}
	
	/**
	 * 확인완료 회람판 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularComplete.do")
	public String circularComplete(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		
		logger.debug("circularComplete started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		int page = 1;
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId()); 
        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
        int startRow = 1;
        int endRow = 0;
        
		if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		CircularConfigVO config = ezCircularService.getPersonalCount(userInfo);
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (page - 1)) + 1;
        endRow = (personalCount * page);
		
        int totalCount = ezCircularService.getCircularListCount(userInfo.getId(), userInfo.getTenantId());
        
        logger.debug("startRow : "+startRow);
        logger.debug("endRow : "+endRow);
        
		List<CircularListVO> list = ezCircularService.getCircularList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
		logger.debug("listSize : "+list.size());
		
		for (CircularListVO result : list) {
			result.setRegDate(commonUtil.getDateStringInUTC(result.getRegDate(), userInfo.getOffset(), false));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useRunTime", useRunTime);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("list", list);
		model.addAttribute("config", config);
		model.addAttribute("totalCount", totalCount);
		
		logger.debug("circularComplete ended");
		
		return "/ezCircular/circularComplete";
	}
	
	/**
	 * 작성한 회람판 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularMyCircular.do")
	public String circularMyCircular(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		
		logger.debug("circularMyCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		int page = 1;
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId()); 
        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
        int startRow = 1;
        int endRow = 0;
        
		if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		CircularConfigVO config = ezCircularService.getPersonalCount(userInfo);
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (page - 1)) + 1;
        endRow = (personalCount * page);
		
        int totalCount = ezCircularService.getCircularListCount(userInfo.getId(), userInfo.getTenantId());
        
        logger.debug("startRow : "+startRow);
        logger.debug("endRow : "+endRow);
        
		List<CircularListVO> list = ezCircularService.getCircularList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
		logger.debug("listSize : "+list.size());
		
		for (CircularListVO result : list) {
			result.setRegDate(commonUtil.getDateStringInUTC(result.getRegDate(), userInfo.getOffset(), false));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useRunTime", useRunTime);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("list", list);
		model.addAttribute("config", config);
		model.addAttribute("totalCount", totalCount);
		
		logger.debug("circularMyCircular ended");
		
		return "/ezCircular/circularMyCircular";
	}
	
	/**
	 * 임시 회람판 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularTemp.do")
	public String circularTemp() {
		
		logger.debug("circularTemp started");
		
		logger.debug("circularTemp ended");
		
		return "/ezCircular/circularTemp";
	}
	
	/**
	 * 휴지통 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDelete.do")
	public String circularDelete() {
		
		logger.debug("circularDelete started");
		
		logger.debug("circularDelete ended");
		
		return "/ezCircular/circularDelete";
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
	
	/**
	 * 회람판 환경설정 Method
	 */
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
	
	/**
	 * 회람판 환경설정 저장 Method
	 */
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
    public String getBoardList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
    	logger.debug("getCircularList started");

    	userInfo = commonUtil.userInfo(loginCookie);
    	//TODO
    	
    	BoardVO boardVO = new BoardVO();
    	
    	boardVO.setBoardType("C");
    	boardVO.setLang(userInfo.getLang());
    	boardVO.setTenantID(userInfo.getTenantId());
    	List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(boardVO);
    	
    	int page = 1;
        int startRow = 1;
        int endRow = 0;
        
        String pageNum = "1";
        if (req.getParameter("pageNum") != null && !req.getParameter("pageNum").equals("")) {
        	pageNum = req.getParameter("pageNum"); 
        }
    	
    	CircularConfigVO config = ezCircularService.getPersonalCount(userInfo);
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularListCount(userInfo.getId(), userInfo.getTenantId());
        
        logger.debug("startRow : "+startRow);
        logger.debug("endRow : "+endRow);
        
		List<CircularListVO> list = ezCircularService.getCircularList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
		List<HashMap<String, Object>> list2 = ezCircularService.getCircularMapList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
		
		for (CircularListVO result : list) {
			result.setRegDate(commonUtil.getDateStringInUTC(result.getRegDate(), userInfo.getOffset(), false));
		}
		
		StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + totalCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + config.getIsPreview() + "</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLIST>" + 0 + "</PREVIEWWLIST>");
        resultXML.append("<PREVIEWWCONTENT>" + 0 + "</PREVIEWWCONTENT>");
        resultXML.append("<PREVIEWHLIST>" + 0 + "</PREVIEWHLIST>");
        resultXML.append("<PREVIEWHCONTENT>" + 0 + "</PREVIEWHCONTENT>");
        resultXML.append("<TITLENUM>" + 0 + "</TITLENUM>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        for (BoardListHeaderVO vo:headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }
       
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        for (int j = 0; j < list.size(); j++) {
        	resultXML.append("<ROW>");
        	String fieldName = "";
        	String fieldValue = "";
            for (int i = 0; i < headerList.size(); i++) {
            	resultXML.append("<CELL>");
                fieldName = headerList.get(i).getColName().toUpperCase();
                
                fieldValue = commonUtil.cleanValue(String.valueOf(list2.get(j).get(fieldName)));

                if (fieldValue == null || fieldValue.equals(null) || fieldValue.equals("null")) {
                	fieldValue = "";
				}
                
                if (fieldName.equals("IMPORTANCE")) {
                	fieldValue = fieldValue.equals("0") ? "일반" : "중요";
                } else if (fieldName.equals("HASFILE")) {
                	//태그안에넣어서 에러나서 추후에 수정
                	//fieldValue = fieldValue.equals("0") ? " " : "<img src=\"/images/newAttach.gif\">";
                	fieldValue = fieldValue.equals("0") ? " " : "O";
                } else if (fieldName.equals("STATUS")) {
                	fieldValue = fieldValue.equals("0") ? "진행중" : "종료";
                } else if (fieldName.equals("CONFIRMSTATUS")) {
                	int firstValue = ezCircularService.getConfirmStatusFirst(list.get(j).getCircularId(), userInfo.getTenantId());
                	int secondValue = ezCircularService.getConfirmStatusSecond(list.get(j).getCircularId(), userInfo.getTenantId());
                	
                	fieldValue = firstValue + "/" + secondValue;
                }
            	
				resultXML.append("<MEMBERID>" + list.get(j).getMemberId() + "</MEMBERID>");
				resultXML.append("<CIRCULARID>" + list.get(j).getCircularId() + "</CIRCULARID>");
				
                resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
                
                if (i == 0) {
					resultXML.append("<TITLE>" + list.get(j).getTitle() + "</TITLE>");
					resultXML.append("<MEMBERID>" + list.get(j).getMemberId() + "</MEMBERID>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");
        
        logger.debug("resultXML : "+resultXML);
		logger.debug("getCircularList ended");
        return resultXML.toString();
    }
    
	/**
	 * 회람판 회람작성창 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/circularWrite.do")
	public String circularWrite(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, HttpServletRequest req, Model model, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		return "/ezCircular/circularWrite";
	}
	
	/**
	 * 회람판 draganddrop 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/dragAndDrop.do")
	public String dragAndDrop(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo",userInfo);
		
		return "/ezCircular/circularDragAndDrop";
	}
	
	/**
	 * 회람판 신규 회람판 등록 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/saveCircular.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveCircular(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
		logger.debug("saveCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String fileList = "";
		if (request.getParameter("fileList") != null && !request.getParameter("fileList").equals("")) {
			fileList = request.getParameter("fileList");
		}
		
		logger.debug("fileList : "+fileList);
		
		
		
		int circularUserId = 0;
		int updateStatus = 0;
		
		String receiverIDs = request.getParameter("receiverID");
		String receiverList = request.getParameter("receiverList");
		
		logger.debug("receiverIDs : "+receiverIDs);
		logger.debug("receiverList : "+receiverList);
		
		int receiverLength = receiverIDs.split(",").length;
		String[] receiverID = receiverIDs.split(",");
		String[] receiverName = receiverList.split(",");
		
		String regDate = commonUtil.getTodayUTCTime("");
		
		ezCircularService.insertCircular(circularListVO.getCircularId(), circularListVO.getTitle(), circularListVO.getImportance(), circularListVO.getOption(), circularListVO.getContent(), circularListVO.getHasFile(), circularListVO.getStatus(), userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), regDate, circularListVO.getEndDate(),userInfo.getTenantId(), receiverLength, receiverID, updateStatus, circularUserId,receiverName,fileList);

		logger.debug("saveCircular ended");
	}
	
	/**
	 * 회람판 상세정보 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/circularRead.do")
	public String circularRead(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, HttpServletRequest req, Model model, Locale locale) throws Exception {
		logger.debug("circularRead Start");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularID = "";
		
		if (req.getParameter("circularID") != null && !req.getParameter("circularID").equals("")) {
			circularID = req.getParameter("circularID");
		}
		 
		//TODO 회람 상세정보 가져옴
		CircularListVO result = ezCircularService.getCircular(circularID, userInfo.getTenantId());
		
		List<CircularListVO> list = ezCircularService.getCircularUserList(Integer.parseInt(circularID), userInfo.getTenantId());
		
		String listUser = "";
		
		for (int i=0; i<list.size(); i++) {
			if (list.size() == 1) {
				listUser = list.get(i).getMemberId();
			} else if (i !=list.size()-1){
				listUser += list.get(i).getMemberId() + ",";
			} else {
				listUser += list.get(i).getMemberId();
			}
		}
		
	    //첨부파일 정보  hasFile이 Y일때
        //if (vo.getHasAttach().equals("Y")) {        
        	
        	List<CircularAttachVO> aList = ezCircularService.getAttachList(Integer.parseInt(circularID), userInfo.getTenantId());
        	
        	for (CircularAttachVO avo : aList) {        		
        		String fileType = avo.getFileName().substring(avo.getFileName().lastIndexOf(".") + 1).toLowerCase();
        		avo.setFileType(fileType);        		
        		avo.setFileEncodeName(URLEncoder.encode(avo.getFileName(),"UTF-8"));
        		
        		String fileSize = commonUtil.byteCalculation(Long.toString(avo.getFileSize()));
        		avo.setFileTranSize(fileSize);
        	}
        	
        	model.addAttribute("attachList", aList);
        //}  
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("result", result);
		model.addAttribute("listUser", listUser);
		
		return "/ezCircular/circularRead";
	}
	
	/**
	 * 회람판 회람수정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/circularModify.do")
	public String circularModify(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, HttpServletRequest req, Model model, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularID = "";
		
		if (req.getParameter("circularID") != null && !req.getParameter("circularID").equals("")) {
			circularID = req.getParameter("circularID");
		}
		
		//TODO 회람 상세정보 가져옴
		CircularListVO result = ezCircularService.getCircular(circularID, userInfo.getTenantId());
				
		List<CircularListVO> list = ezCircularService.getCircularUserList(Integer.parseInt(circularID), userInfo.getTenantId());
		
		String listUser = "";
		
		for (int i=0; i<list.size(); i++) {
			if (list.size() == 1) {
				listUser = list.get(i).getMemberId();
			} else if (i !=list.size()-1){
				listUser += list.get(i).getMemberId() + ",";
			} else {
				listUser += list.get(i).getMemberId();
			}
		}
		
		int hasAttach = 0;
		 //첨부파일 리스트
		hasAttach = result.getHasFile();
		StringBuilder strAttach = new StringBuilder();
        //if (hasAttach == 1) {            	
        	//hasAttach = 1;            	
        	
        	List<CircularAttachVO> attachList = ezCircularService.getAttachList(Integer.parseInt(circularID), userInfo.getTenantId());
        	
        	strAttach.append("<ROOT><NODES>");
        	
            for (CircularAttachVO attach : attachList) {
                strAttach.append("<DATA><![CDATA[" + commonUtil.cleanPropertyValue(attach.getFilePath().split("uploadFile/")[1] + "/" + attach.getFileName() + "/" + attach.getFileSize()) + "]]></DATA>");
                strAttach.append("<DATA2><![CDATA[]]></DATA2>");
                strAttach.append("<DATA3><![CDATA[OK]]></DATA3>");
            }
            strAttach.append("</NODES></ROOT>");            		
        //} else {
        //	hasAttach = 0;
        //}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("circularID", circularID);
		model.addAttribute("result", result);
		model.addAttribute("listUser", listUser);
		model.addAttribute("strAttach", strAttach.toString());
		
		return "/ezCircular/circularModify";
	}
	
	/**
	 * 회람판 신규 회람판 수정 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/saveModifyCircular.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveModifyCircular(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
		logger.debug("saveModifyCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		int circularUserId = 0;
		int updateStatus = 0;
		String confirmDate = "";
		String receiverIDs = request.getParameter("receiverID");
		String receiverList = request.getParameter("receiverList");
		
		logger.debug("receiverIDs : "+receiverIDs);
		logger.debug("receiverList : "+receiverList);
		
		int receiverLength = receiverList.split(",").length;
		String[] receiverID = receiverIDs.split(",");
		
		ezCircularService.modifyCircular(circularListVO.getTitle(),circularListVO.getImportance(),circularListVO.getOption(),circularListVO.getCircularId(), userInfo.getTenantId(), receiverLength, receiverID,updateStatus,circularUserId,circularListVO.getMemberName(),circularListVO.getMemberName2(),circularListVO.getStatus(),confirmDate,circularListVO.getContent());

		logger.debug("saveModifyCircular ended");
	}
	
	/**
	 * 회람판 신규 회람판 클릭했을때, 확인 수 증가 및 확인일 설정 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/confirmStatus.do", method = RequestMethod.POST)
	@ResponseBody
	public void confirmStatus(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
		logger.debug("confirmStatus started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String confirmDate = commonUtil.getTodayUTCTime("");
		logger.debug("cirCularID : "+circularListVO.getCircularId());
		logger.debug("getID : "+userInfo.getId());
		
		ezCircularService.confirmStatus(circularListVO.getCircularId(), userInfo.getId(), userInfo.getTenantId());
		
		int firstValue = ezCircularService.getConfirmStatusFirst(circularListVO.getCircularId(), userInfo.getTenantId());
		
		//status업데이트되는부분 임시 주석
		//ezCircularService.updateStatus(firstValue, circularListVO.getCircularId(), userInfo.getTenantId());
		ezCircularService.updateStatusUser(firstValue, circularListVO.getCircularId(), confirmDate, userInfo.getTenantId());
		
		logger.debug("confirmStatus ended");
	}
	
	/**
	 * 회람판작성 > 첨부파일 업로드
	 */
	@RequestMapping(value = "/ezCircular/uploadItemAttach.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadItemAttach(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO) throws Exception{
		
		logger.debug("============ uploadScheduleAttach started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload"); 
		int cnt = multiFile.size();
		
		String realPath = request.getServletContext().getRealPath("");
		String[] pFileName = new String[cnt];
        Long[] fileSize = new Long[cnt];        
        String[] resultUpload = new String[cnt];
        String[] sGUID = new String[cnt];
        String[] pUploadSN = new String[cnt];
        
        String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", loginSimpleVO.getTenantId());

        for (int i = 0; i < cnt; i++) {
            resultUpload[i] = "false";
            sGUID[i] = UUID.randomUUID().toString();
            pUploadSN[i] = "{" + sGUID[i] + "}";
        }

        if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())) {        	
            for (int i = 0; i < cnt; i++) {
                String _pFileName = multiFile.get(i).getOriginalFilename();
                if (_pFileName.indexOf(commonUtil.separator) > 0) {
                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
                }
                pFileName[i] = _pFileName;
            }
        }

        for (int i = 0; i < cnt; i++) {
            pFileName[i] = pFileName[i].replace("+", "%2b");
            pFileName[i] = pFileName[i].replace(";", "%3b");
        }
        
        String pDirPath = commonUtil.getUploadPath("upload_schedule.ROOT", loginSimpleVO.getTenantId());

        pDirPath = realPath + pDirPath;
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        File file = new File(pDirPath + "uploadFile");

        if (!file.exists()) {
        	file.mkdir();        
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
        for (int i = 0; i < cnt; i++) {        	
        	fileSize[i] = multiFile.get(i).getSize();
            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
            String newFileName = pUploadSN[i] + "." + extend;
            
            if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1 && !useExtension.equals("*")) {           	
				strXML.append("<DATA><![CDATA[" + newFileName + "/" + pFileName[i] + "/" + fileSize[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[]]></DATA2>");
				strXML.append("<DATA3><![CDATA[denied]]></DATA3>");
            } else {
				writeUploadedFile(multiFile.get(i), newFileName, pDirPath + "uploadFile");
				strXML.append("<DATA><![CDATA[" + newFileName + "/" + pFileName[i] + "/" + fileSize[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[]]></DATA2>");
				strXML.append("<DATA3><![CDATA[OK]]></DATA3>");
            }
        }
        strXML.append("</NODES></ROOT>");
        
        return strXML.toString();
    }

	@RequestMapping(value = "/ezCircular/circularDeptConfig.do")
	public String circularDeptConfig(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, CircularDeptVO circularDeptVO, Model model) throws Exception {
		
		logger.debug("circularDeptConfig started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		logger.debug("circularDeptConfig ended");
		
		return "/ezCircular/circularDeptConfig";
	}
	
	/**
	 * 회람처 등록 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDeptadd.do")
	public String circularDeptadd() {
		
		logger.debug("circularDeptadd started");
		
		logger.debug("circularDeptadd ended");
		
		return "/ezCircular/circularDeptadd";
	}
	
	/**
	 * 회람처 저장 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDeptSave.do")
	@ResponseBody
	public void circularDeptSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, CircularDeptVO circularDeptVO, HttpServletRequest request) throws Exception {
		
		logger.debug("circularDeptSave started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		Integer CircularBMId = circularDeptVO.getCircularBMId();
		
		circularDeptVO.setMemberId(userInfo.getId());
		circularDeptVO.setRegDate(commonUtil.getTodayUTCTime(""));
		circularDeptVO.setTenantId(userInfo.getTenantId());
		
		String[] memberListStr = request.getParameterValues("memberListStr[]");
		
		if (CircularBMId != 0) {
			ezCircularService.update_circularDept(circularDeptVO);
		} else {
			ezCircularService.set_circularDeptSave(circularDeptVO, memberListStr);
		}

		logger.debug("circularDeptSave ended");
	}
	
	/**
	 * 회람처 조직도 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularSelectAttendant.do")
	public String circularSelectAttendant(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, CircularDeptVO circularDeptVO, Model model) throws Exception {
		
		logger.debug("circularSelectAttendant started");
		
		
		
		logger.debug("circularSelectAttendant ended");
	
		return "/ezCircular/circularSelectAttendant";
	}
	
	/**
	 * 회람처 목록 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/getcircularDeptList.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getcircularDeptList(@CookieValue("loginCookie") String loginCookie, CircularDeptVO circularDeptVO, LoginVO userInfo) throws Exception {
		
		logger.debug("circularGetList started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		circularDeptVO.setTenantId(userInfo.getTenantId());
		circularDeptVO.setMemberId(userInfo.getId());
		
		String result = ezCircularService.getcircularDeptList(circularDeptVO);
		
		logger.debug("circularGetList ended");
		
		return result;
	}
	
	/**
	 * 회람처 목록 수정 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDeptModify.do")
	public String circularDeptModify(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularDeptVO circularDeptVO, Model model) throws Exception {
		
		logger.debug("circularDeptModify started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String title = request.getParameter("title");
		int circularBMId = Integer.parseInt(request.getParameter("id"));
		int tenantId = userInfo.getTenantId();
		
		String memberList = ezCircularService.circularDeptModify(circularBMId, tenantId);
		
		model.addAttribute("circularBMId", circularBMId);
		model.addAttribute("title", title);
		model.addAttribute("memberList", memberList);
		
		logger.debug("circularDeptModify ended");
	
		return "/ezCircular/circularDeptadd";
	}
	
	/**
	 * 회람처 삭제 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDeptDel.do", method = RequestMethod.POST)
	@ResponseBody
	public void circularDeptDel(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularDeptVO circularDeptVO) throws Exception {
		
		logger.debug("circularDeptDel started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		ezCircularService.circularDeptDel(circularDeptVO);
		
		logger.debug("circularDeptDel ended");
	}
	
}
