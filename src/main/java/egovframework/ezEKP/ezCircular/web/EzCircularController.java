package egovframework.ezEKP.ezCircular.web;

import java.io.File;
import java.net.URLEncoder;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCircular.service.EzCircularService;
import egovframework.ezEKP.ezCircular.vo.CircularAttachVO;
import egovframework.ezEKP.ezCircular.vo.CircularCommentVO;
import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularDeptVO;
import egovframework.ezEKP.ezCircular.vo.CircularFolderVO;
import egovframework.ezEKP.ezCircular.vo.CircularListHeaderVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.ezEKP.ezCircular.vo.CircularMemberVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
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
	private EzCircularService ezCircularService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
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
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		StringBuilder rootFolderXML = new StringBuilder();

		List<CircularFolderVO> list = ezCircularService.getTopFolder(userInfo.getId(), userInfo.getTenantId());
		
		for (int i=0; i < list.size(); i++) {
			rootFolderXML.append("<node imgidx='1' caption='" + 
					list.get(i).getCircularFolderName() + "' foldername='" + 
					list.get(i).getCircularFolderName() + "' fullcaption='_NONE' href='" + 
					list.get(i).getCircularFolderID() + "'></node>");
		}
		
		String funCode = "1";
		if (request.getParameter("funCode") != null) {
			funCode = request.getParameter("funCode");
		}
		
		model.addAttribute("rootFolderXML", rootFolderXML.toString());
		model.addAttribute("funCode", funCode);
		
		logger.debug("circularLeft ended.");

		return "/ezCircular/circularLeft";
	}
	
	/**
	 * 회람문서함관리 및 회람판에서 이동 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/getCircularFolderList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getCircularFolderList(HttpServletRequest request, HttpServletResponse response, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		
		logger.debug("getCircularFolderList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<CircularFolderVO> list = ezCircularService.getTopFolder(userInfo.getId(), userInfo.getTenantId());

		StringBuilder subFolderXML = new StringBuilder();
		
		for (int i=0; i<list.size(); i++) {
			subFolderXML.append("<node imgidx='1'");
			subFolderXML.append(" caption='" + list.get(i).getCircularFolderName() + "'");
			subFolderXML.append(" foldername='" + list.get(i).getCircularFolderName() + "'");
			subFolderXML.append(" fullcaption='_NONE'");
			subFolderXML.append(" href='" + list.get(i).getCircularFolderID() + "'");
			subFolderXML.append("></node>");			
		}

		logger.debug("getCircularFolderList ended.");
		
		return subFolderXML.toString();
	}

	/**
	 * 신규회람판 호출 Method
	 */
	@RequestMapping(value = "/ezcircular/newCircular.do")
	public String newCircular(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("newCircular started");

		userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userInfo", userInfo);

		logger.debug("newCircular ended");

		return "/ezCircular/newCircular";
	}
	
	/**
	 * 회람판 미리보기 표출 Method
	 */
	@RequestMapping(value = "/ezCircular/getPreviewItem.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getPreviewItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		logger.debug("getPreviewItem started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularID = request.getParameter("pcircularId"); 		
		String memberID = request.getParameter("pmemberId"); 		

		String retXML = ezCircularService.getItemXML(circularID, memberID, userInfo.getOffset(), userInfo.getTenantId());
		
		logger.debug("getPreviewItem ended.");
		
		return retXML;	
	}
	
	/**
	 * 회람판 미리보기게시물 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularItemPreviewContent.do")
	public String circularItemPreviewContent() throws Exception{
		return "/ezCircular/circularItemPreviewContent";
	}
	
	/**
	 * 회람판 첨부파일가져오기 표출 Method
	 */
	@RequestMapping(value = "/ezCircular/getItemAttachments.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String getItemAttachments(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String pcircularId = "";
		String strXML = "";
        
        pcircularId = request.getParameter("pcircularId");

       	strXML = getItemAttachmentXML(pcircularId, userInfo.getTenantId());
        
        return strXML;
	}
	
	/**
	 * 
	 * 회람판 첨부파일관련 표출 Method 
	 */
	public String getItemAttachmentXML(String pcircularId, int tenantId) throws Exception{
		List<CircularAttachVO> circularAttachVOList = ezCircularService.getAttachList(Integer.parseInt(pcircularId), tenantId);
		
		StringBuilder resultXML = new StringBuilder();
		resultXML.append("<NODES>");
		
		for (int i = 0; i < circularAttachVOList.size(); i++) {
			resultXML.append("<NODE>");
			resultXML.append("<CircularFileId>" + circularAttachVOList.get(i).getCircularFileID() + "</CircularFileId>");
			resultXML.append("<FileSize>" + circularAttachVOList.get(i).getFileSize() + "</FileSize>");
			resultXML.append("<FileName>" + commonUtil.cleanValue(circularAttachVOList.get(i).getFileName()) + "</FileName>");
			resultXML.append("<FilePath>" + commonUtil.cleanValue(circularAttachVOList.get(i).getFilePath()) + "</FilePath>");
			resultXML.append("</NODE>");
		}
		resultXML.append("</NODES>");
		
		return resultXML.toString();
	}
	
	/**
	 * 회람판 첨부파일 다운로드
	 */
	@RequestMapping(value = "/ezCircular/downloadAttach.do")
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadAttach started");
		
		userInfo = commonUtil.userInfoSimple(loginCookie);		

		String filePath = request.getParameter("filePath");		
		String fileName = request.getParameter("fileName");
		String realPath = commonUtil.getRealPath(request);
		String uploadFilePath = commonUtil.getUploadPath("upload_circular.ROOT", userInfo.getTenantId());
		
		if (fileName == null || fileName.equals("")) {
			fileName = filePath; 
		}
		
		String fullFilePath = realPath + uploadFilePath + commonUtil.separator + commonUtil.separator + filePath;

		downFile(request, response, fullFilePath, fileName);
		
		logger.debug("downloadAttach ended");
	}
	
	/**
	 * 받은회람판 회람판 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularComplete.do")
	public String circularComplete(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("circularComplete started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
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

		model.addAttribute("userInfo", userInfo);

		logger.debug("circularMyCircular ended");

		return "/ezCircular/circularMyCircular";
	}
	
	/**
	 * 임시 회람판 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularTemp.do")
	public String circularTemp(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		
		logger.debug("circularTemp started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userInfo", userInfo);

		logger.debug("circularTemp ended");

		return "/ezCircular/circularTemp";
	}
	
	/**
	 * 휴지통 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDelete.do")
	public String circularDelete(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		
		logger.debug("circularDelete started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userInfo", userInfo);

		logger.debug("circularDelete ended");

		return "/ezCircular/circularDelete";
	}
	
	/**
	 * 회람판 검색 화면 호출 Method
	 */
	@RequestMapping("/ezCircular/circularSearchView.do")
	public String circularSearchView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO userInfo) throws Exception {
		logger.debug("circularSearchView started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		String type = "";
		String filter = request.getParameter("filter");
		String keyword = request.getParameter("keyword");
		String startDate = request.getParameter("sdate");
		String endDate = request.getParameter("edate");
		String offSetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
	
		if (filter != null && !filter.equals("")) {			
//			String utcStartTime = "";
//			String utcEndTime = "";
			int filterVal = 0;

			if (filter.equals("circularNew")) {
				filterVal = 1;
				type = "N";
			} else if (filter.equals("circularComplete")) {
				filterVal = 2;
			} else if (filter.equals("circularMy")) {
				filterVal = 3;
			} else if (filter.equals("circularTemp")) {
				filterVal = 4;
			} else {
				filterVal = 5;
			}
			
			if (keyword == null) keyword = "";
			if (startDate == null) startDate = "";
			if (endDate == null) endDate = "";
			
			if (startDate != "" && endDate != "") {
				startDate = startDate + " 00:00:00";
				endDate = endDate + " 23:59:59";				
			}

	        int startRow = 1;
	        int endRow = 0;
	        
	        String pageNum = "1";
	        
	        if (request.getParameter("pageNum") != null && !request.getParameter("pageNum").equals("")) {
	        	pageNum = request.getParameter("pageNum"); 
	        }
	    	
	    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
			
			int personalCount = config.getListCnt();
			startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
	        endRow = (personalCount * Integer.parseInt(pageNum));

	        int totalCount = ezCircularService.getSearchAllCircularListCount(userInfo.getId(), userInfo.getTenantId(), keyword, filterVal, startDate, endDate);
        
			List<CircularListVO> list = ezCircularService.getSearchAllCircularList(userInfo.getId(), startRow, endRow, userInfo.getTenantId(), keyword, filterVal, startDate, endDate);

			model.addAttribute("totalCount", totalCount);
	        model.addAttribute("list", list);		
		}
		
		model.addAttribute("type", type);
		model.addAttribute("offSetMin", offSetMin);
		model.addAttribute("filter", filter);
		model.addAttribute("keyword", keyword);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("primary", userInfo.getPrimary());
//		model.addAttribute("resultXML", resultXML.toString());
		
		logger.debug("circularSearchView ended");
		
		return "/ezCircular/circularSearchView";		
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
		
		circularConfigVO.setTenantID(userInfo.getTenantId());
		circularConfigVO.setMemberID(userInfo.getId());

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
	public String setCircularConfig(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		logger.debug("setCircularConfig started");

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

		logger.debug("setCircularConfig ended");
		return result;
	}
	
	/**
	 * 회람판 신규회람판 리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getCircularList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getCircularList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
    	logger.debug("getCircularList started");

    	userInfo = commonUtil.userInfo(loginCookie);
    	
    	CircularListHeaderVO headerVO = new CircularListHeaderVO();
    	
    	headerVO.setListType("N");
    	headerVO.setTenantID(userInfo.getTenantId());
    	
    	List<CircularListHeaderVO> headerList = ezCircularService.getListHeader(headerVO);
    	
        int startRow = 1;
        int endRow = 0;
        String pageNum = "1";
        String searchValue = req.getParameter("searchValue");
        
        if (req.getParameter("pageNum") != null && !req.getParameter("pageNum").equals("")) {
        	pageNum = req.getParameter("pageNum"); 
        }
        
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularListCount(userInfo.getId(), searchValue, userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getCircularList(userInfo.getId(), searchValue, startRow, endRow, userInfo.getTenantId(), userInfo.getOffset());
		
		StringBuffer resultXML = new StringBuffer();

		resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + totalCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + config.getIsPreview() + "</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLISTVALUE>" + config.getPreviewListValue() + "</PREVIEWWLISTVALUE>");
        resultXML.append("<PREVIEWWCONTENTVALUE>" + config.getPreviewContentValue() + "</PREVIEWWCONTENTVALUE>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        for (CircularListHeaderVO vo : headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName1() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }

        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getUpdateStatus() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + (vo.getStatus() == 0 ? "진행중" : "종료") + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getTitle() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberName() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmCount() + "/" + vo.getConfirmTotalCount() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmDate() + "</VALUE></CELL>");
//			resultXML.append("<CELL><VALUE>" + vo.getUpdateDate() + "</VALUE></CELL>");
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
	 * 회람판 받은회람판 리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getCircularCompleteList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getCircularCompleteList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
    	logger.debug("getCircularCompleteList started");

    	int startRow = 1;
    	int endRow = 0;
    	String pageNum = "1";
    	
    	if (req.getParameter("pageNum") != null && !req.getParameter("pageNum").equals("")) {
    		pageNum = req.getParameter("pageNum"); 
    	}
    	
    	String searchValue = req.getParameter("searchValue");
    	
    	userInfo = commonUtil.userInfo(loginCookie);

    	CircularListHeaderVO headerVO = new CircularListHeaderVO();
    	
    	headerVO.setListType("I");
    	headerVO.setTenantID(userInfo.getTenantId());
    	
    	List<CircularListHeaderVO> headerList = ezCircularService.getListHeader(headerVO);
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularCompleteListCount(userInfo.getId(), searchValue, userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getCircularCompleteList(userInfo.getId(), searchValue, startRow, endRow, userInfo.getTenantId(), userInfo.getOffset());
		
		StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + totalCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + config.getIsPreview() + "</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLISTVALUE>" + config.getPreviewListValue() + "</PREVIEWWLISTVALUE>");
        resultXML.append("<PREVIEWWCONTENTVALUE>" + config.getPreviewContentValue() + "</PREVIEWWCONTENTVALUE>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        for (CircularListHeaderVO vo : headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName1() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }
       
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmStatus() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + (vo.getStatus() == 0 ? "진행중" : "종료") + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getTitle() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberName() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmCount() + "/" + vo.getConfirmTotalCount() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmDate() + "</VALUE></CELL>");
//			resultXML.append("<CELL><VALUE>" + vo.getUpdateDate() + "</VALUE></CELL>");
			resultXML.append("</ROW>");
        }
        
		resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");
        
        logger.debug("resultXML : "+resultXML);
		logger.debug("getCircularCompleteList ended");
		
        return resultXML.toString();
    }
    
    /**
	 * 회람판 임시회람판 리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getCircularTempList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getCircularTempList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
    	logger.debug("getCircularList started");
    	
    	userInfo = commonUtil.userInfo(loginCookie);
    	int startRow = 1;
    	int endRow = 0;
    	String pageNum = "1";
    	
    	String searchValue = req.getParameter("searchValue");
    	
    	if (req.getParameter("pageNum") != null && !req.getParameter("pageNum").equals("")) {
    		pageNum = req.getParameter("pageNum"); 
    	}

    	CircularListHeaderVO headerVO = new CircularListHeaderVO();

    	headerVO.setListType("C");
    	headerVO.setTenantID(userInfo.getTenantId());

    	List<CircularListHeaderVO> headerList = ezCircularService.getListHeader(headerVO);
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularTempListCount(userInfo.getId(), searchValue, userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getCircularTempList(userInfo.getId(), searchValue, startRow, endRow, userInfo.getOffset(), userInfo.getTenantId());
		
		StringBuffer resultXML = new StringBuffer();

		resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + totalCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + config.getIsPreview() + "</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLISTVALUE>" + config.getPreviewListValue() + "</PREVIEWWLISTVALUE>");
        resultXML.append("<PREVIEWWCONTENTVALUE>" + config.getPreviewContentValue() + "</PREVIEWWCONTENTVALUE>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");

        for (CircularListHeaderVO vo : headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName1() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }

        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + "임시" + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getTitle() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberName() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + "" + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + "" + "</VALUE></CELL>");
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
	 * 회람판 작성한회람판 리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getMyCircularList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getMyCircularList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
    	logger.debug("getMyCircularList started");

    	userInfo = commonUtil.userInfo(loginCookie);
    	int startRow = 1;
        int endRow = 0;
        
        String pageNum = "1";
        if (req.getParameter("pageNum") != null && !req.getParameter("pageNum").equals("")) {
        	pageNum = req.getParameter("pageNum"); 
    	}
        
        String searchValue = req.getParameter("searchValue");
        
    	CircularListHeaderVO headerVO = new CircularListHeaderVO();
    	
    	headerVO.setListType("C");
    	headerVO.setTenantID(userInfo.getTenantId());
    	
    	List<CircularListHeaderVO> headerList = ezCircularService.getListHeader(headerVO);
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getMyCircularListCount(userInfo.getId(), searchValue, userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getMyCircularList(userInfo.getId(), searchValue, startRow, endRow,	userInfo.getOffset(), userInfo.getTenantId());
		
		StringBuffer resultXML = new StringBuffer();

		resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + totalCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + config.getIsPreview() + "</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLISTVALUE>" + config.getPreviewListValue() + "</PREVIEWWLISTVALUE>");
        resultXML.append("<PREVIEWWCONTENTVALUE>" + config.getPreviewContentValue() + "</PREVIEWWCONTENTVALUE>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        for (CircularListHeaderVO vo : headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName1() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }
        
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + (vo.getStatus() == 0 ? "진행중" : "종료") + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getTitle() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberName() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmCount() + "/" + vo.getConfirmTotalCount() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmDate() + "</VALUE></CELL>");
//			resultXML.append("<CELL><VALUE>" + vo.getUpdateDate() + "</VALUE></CELL>");
			resultXML.append("</ROW>");
        }
        
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
        
        logger.debug("resultXML : "+resultXML);
		logger.debug("getMyCircularList ended");
		
        return resultXML.toString();
    }
    
    /**
	 * 휴지통 리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getTDCircularList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getTDCircularList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
    	logger.debug("getTDCircularList started");

    	userInfo = commonUtil.userInfo(loginCookie);
    	int startRow = 1;
        int endRow = 0;
        
        String pageNum = "1";
        if (req.getParameter("pageNum") != null && !req.getParameter("pageNum").equals("")) {
        	pageNum = req.getParameter("pageNum"); 
        }

        String searchValue = req.getParameter("searchValue");
        
    	CircularListHeaderVO headerVO = new CircularListHeaderVO();

    	headerVO.setListType("C");
    	headerVO.setTenantID(userInfo.getTenantId());

    	List<CircularListHeaderVO> headerList = ezCircularService.getListHeader(headerVO);
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularTDListCount(userInfo.getId(), searchValue, userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getCircularTDList(userInfo.getId(), searchValue, startRow, endRow, userInfo.getTenantId(), userInfo.getOffset());
		
		StringBuffer resultXML = new StringBuffer();

		resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + totalCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + config.getIsPreview() + "</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLISTVALUE>" + config.getPreviewListValue() + "</PREVIEWWLISTVALUE>");
        resultXML.append("<PREVIEWWCONTENTVALUE>" + config.getPreviewContentValue() + "</PREVIEWWCONTENTVALUE>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        for (CircularListHeaderVO vo : headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName1() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }
        
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + (vo.getStatus() == 0 ? "진행중" : "종료") + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getTitle() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberName() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmCount() + "/" + vo.getConfirmTotalCount() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmDate() + "</VALUE></CELL>");
//			resultXML.append("<CELL><VALUE>" + vo.getUpdateDate() + "</VALUE></CELL>");
			resultXML.append("</ROW>");
        }
        
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
        
        logger.debug("resultXML : "+resultXML);
		logger.debug("getTDCircularList ended");
		
        return resultXML.toString();
    }
    
	/**
	 * 회람판 회람작성창 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/circularWrite.do")
	public String circularWrite(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, HttpServletRequest req, Model model, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);

		List<CircularListVO> list = ezCircularService.getUserList(userInfo.getId(), userInfo.getTenantId());
		
		String userID = "";
		String userName = "";
		String userName2 = "";

		if (list.get(0).getMemberID() != "") {	
			userID = list.get(0).getMemberID();
			userName = list.get(0).getMemberName();
			userName2 = list.get(0).getMemberName2();
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("userID", userID);
		model.addAttribute("userName", userName);
		model.addAttribute("userName2", userName2);
		
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
	 * 회람판 회람판 등록 실행 Method
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
		
		logger.debug("fileList : " + fileList);
		
		int circularUserId = 0;
		int updateStatus = 0;
		circularListVO.setStatus(0);
		
		String oldCircularId = request.getParameter("oldCircularId");
		String receiverIDs = request.getParameter("receiverID");
		String receiverList = request.getParameter("receiverList");
		String receiverList2 = request.getParameter("receiverList2");
		String realPath = commonUtil.getRealPath(request);

		logger.debug("receiverIDs : " + receiverIDs);
		logger.debug("receiverList : " + receiverList);
		logger.debug("receiverList2 : " + receiverList2);
		
		int receiverLength = receiverIDs.split(",").length;
		String[] receiverID = receiverIDs.split(",");
		String[] receiverName = receiverList.split(",");
		String[] receiverName2 = receiverList2.split(",");
		
		String regDate = commonUtil.getTodayUTCTime("");
		
		//임시회람판에서 회람등록 시 임시회람판에 있는 데이터 삭제
		if (oldCircularId != null) {
			ezCircularService.circularDeleteItem(oldCircularId, userInfo.getTenantId());
		}

		ezCircularService.insertCircular(circularListVO.getCircularID(), circularListVO.getTitle(), circularListVO.getImportance(), circularListVO.getOption(), 
										 circularListVO.getContent(), circularListVO.getHasFile(), circularListVO.getStatus(), regDate, circularListVO.getEndDate(), 
										 receiverLength, receiverID, updateStatus, circularUserId, receiverName, fileList, receiverName2, realPath, userInfo, loginCookie);

		logger.debug("saveCircular ended");
	}
	
	/**
	 * 임시 회람판 등록 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/circularSaveTemp.do", method = RequestMethod.POST)
	@ResponseBody
	public void circularSaveTemp(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
		logger.debug("saveCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String fileList = "";
		if (request.getParameter("fileList") != null && !request.getParameter("fileList").equals("")) {
			fileList = request.getParameter("fileList");
		}
		
		logger.debug("fileList : "+fileList);
		
		int circularUserId = 0;
		int updateStatus = 0;
		int receiverLength = 0;
		
		circularListVO.setStatus(2);
		
		String receiverIDs = request.getParameter("receiverID");
		String receiverList = request.getParameter("receiverList");
		String receiverList2 = request.getParameter("receiverList2");
		String realPath = commonUtil.getRealPath(request);
		
		logger.debug("receiverIDs : " + receiverIDs);
		logger.debug("receiverList : " + receiverList);
		logger.debug("receiverList2 : " + receiverList2);
		
		receiverLength = receiverList.split(",").length;
		String[] receiverID = receiverIDs.split(", ");
		String[] receiverName = receiverList.split(", ");
		String[] receiverName2 = receiverList2.split(", ");
		
		String regDate = commonUtil.getTodayUTCTime("");

		ezCircularService.insertCircular(circularListVO.getCircularID(), circularListVO.getTitle(), circularListVO.getImportance(), circularListVO.getOption(), 
										 circularListVO.getContent(), circularListVO.getHasFile(), circularListVO.getStatus(), regDate, circularListVO.getEndDate(), 
										 receiverLength, receiverID, updateStatus, circularUserId, receiverName, fileList, receiverName2, realPath, userInfo, loginCookie);

		logger.debug("saveCircular ended");
	}
	
	/**
	 * 회람판 상세정보 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/circularRead.do")
	public String circularRead(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, HttpServletRequest req, Model model) throws Exception {
		logger.debug("circularRead Start");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularID = "";
		
		if (req.getParameter("circularID") != null && !req.getParameter("circularID").equals("")) {
			circularID = req.getParameter("circularID");
		}
	 
		//TODO 회람 상세정보 가져옴
		CircularListVO result = ezCircularService.getCircular(circularID, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId(), "read");
		
		List<CircularListVO> list = ezCircularService.getCircularUserList(Integer.parseInt(circularID), "", userInfo.getTenantId());

		String listUser = "";
		
		for (CircularListVO vo : list) {
			if (!vo.getMemberID().equals(result.getMemberID())) {
				listUser += vo.getMemberName() + ", ";
			}
		}
		
		if (list.size() > 0 && list.size() != 1) {
			listUser = listUser.substring(0, listUser.length() - 2);
		}

	    //첨부파일 정보  hasFile이 Y일때
        if (result.getHasFile() == 1) {        
        	List<CircularAttachVO> aList = ezCircularService.getAttachList(Integer.parseInt(circularID), userInfo.getTenantId());
        	
        	for (CircularAttachVO avo : aList) {        		
        		String fileType = avo.getFileName().substring(avo.getFileName().lastIndexOf(".") + 1).toLowerCase();
        		avo.setFileType(fileType);        		
        		avo.setFileEncodeName(URLEncoder.encode(avo.getFileName(),"UTF-8"));
        		
        		String fileSize = commonUtil.byteCalculation(Long.toString(avo.getFileSize()));
        		avo.setFileTranSize(fileSize);
        	}
        	model.addAttribute("attachList", aList);
        }  

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("result", result);
		model.addAttribute("listUser", listUser);
		
		return "/ezCircular/circularRead";
	}
	
	/**
	 * 회람판 회람수정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/circularModify.do")
	public String circularModify(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, HttpServletRequest req, Model model) throws Exception {
		logger.debug("circularModify started.");
		
		String circularID = "";
		String userID = "";
		String userName = "";
		String userName2 = "";
		
		if (req.getParameter("circularID") != null && !req.getParameter("circularID").equals("")) {
			circularID = req.getParameter("circularID");
		}
		
		userInfo = commonUtil.userInfo(loginCookie);
		//TODO 회람 상세정보 가져옴
		CircularListVO result = ezCircularService.getCircular(circularID, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId(), "modify");
		List<CircularListVO> list = ezCircularService.getCircularUserList(Integer.parseInt(circularID), "", userInfo.getTenantId());

		for (CircularListVO vo : list) {
			if (!vo.getMemberID().equals(result.getMemberID())) {
				if (list.indexOf(vo) < list.size() - 1) {
					userID += vo.getMemberID() + ", ";
					userName += vo.getMemberName() + ", ";
					userName2 += vo.getMemberName2() + ", ";
				} else {
					userID += vo.getMemberID();
					userName += vo.getMemberName();
					userName2 += vo.getMemberName2();
				}
			}
		}
		
		if (userID.equals("")) {
			List<CircularListVO> user = ezCircularService.getUserList(userInfo.getId(), userInfo.getTenantId());
			
			userID = user.get(0).getMemberID();
			userName = user.get(0).getMemberName();
			userName2 = user.get(0).getMemberName2();
		}

		List<CircularAttachVO> attachList = ezCircularService.getAttachList(Integer.parseInt(circularID), userInfo.getTenantId());
		
		StringBuilder strAttach = new StringBuilder();
    	strAttach.append("<ROOT><NODES>");
    	
        for (CircularAttachVO attach : attachList) {
            strAttach.append("<DATA><![CDATA[" + commonUtil.cleanPropertyValue(attach.getFilePath().split("uploadFile/")[1] + "/" + attach.getFileName() + "/" + attach.getFileSize()) + "]]></DATA>");
            strAttach.append("<DATA2><![CDATA[]]></DATA2>");
            strAttach.append("<DATA3><![CDATA[OK]]></DATA3>");
        }
        
        strAttach.append("</NODES></ROOT>");

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("circularID", circularID);
		model.addAttribute("result", result);
		model.addAttribute("userID", userID);
		model.addAttribute("userName", userName);
		model.addAttribute("userName2", userName2);
		model.addAttribute("listSize", list.size());
		model.addAttribute("strAttach", strAttach.toString());
		
		logger.debug("circularModify ended.");
		
		return "/ezCircular/circularModify";
	}
	
	/**
	 * 회람판 임시 회람판 수정 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/saveModifyCircular.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveModifyCircular(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
		logger.debug("saveModifyCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String fileList = "";
		if (request.getParameter("fileList") != null && !request.getParameter("fileList").equals("")) {
			fileList = request.getParameter("fileList");
		}

		int circularUserId = 0;
		int updateStatus = 0;
		String confirmDate = "";
		int receiverLength = 0;
		circularListVO.setStatus(0);
		
		String receiverIDs = request.getParameter("receiverID");
		String receiverList = request.getParameter("receiverList");
		String receiverList2 = request.getParameter("receiverList2");
		
		logger.debug("receiverIDs : " + receiverIDs);
		logger.debug("receiverList : " + receiverList);
		logger.debug("receiverList2 : " + receiverList2);
		
		receiverLength = receiverList.split(",").length;
		String[] receiverID = receiverIDs.split(", ");
		String[] receiverName = receiverList.split(", ");
		String[] receiverName2 = receiverList2.split(", ");

		ezCircularService.modifyCircular(circularListVO.getTitle(),circularListVO.getImportance(),circularListVO.getOption(),circularListVO.getCircularID(), userInfo.getTenantId(), receiverLength, receiverID, updateStatus, circularUserId, circularListVO.getMemberName(), circularListVO.getMemberName2(), circularListVO.getStatus(), confirmDate, circularListVO.getContent(), fileList, receiverName, receiverName2);

		logger.debug("saveModifyCircular ended");
	}
	
	/**
	 * 회람판 신규 회람판 클릭했을때, 확인 수 증가 및 확인일 설정 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/circularConfirmStatus.do", method = RequestMethod.POST)
	@ResponseBody
	public void circularConfirmStatus(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
		logger.debug("confirmStatus started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String[] circularIDList = request.getParameter("circularIDList").split(";");
		
		ezCircularService.circularConfirmStatus(circularIDList, userInfo.getId(), userInfo.getTenantId());
		
		logger.debug("confirmStatus ended");
	}
	
	/**
	 * 회람판작성 > 첨부파일 업로드
	 */
	@RequestMapping(value = "/ezCircular/uploadItemAttach.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadItemAttach(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO) throws Exception{
		
		logger.debug("uploadCircularAttach started");
		
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
        
        String pDirPath = commonUtil.getUploadPath("upload_circular.ROOT", loginSimpleVO.getTenantId());

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
        
        logger.debug("uploadCircularAttach ended");
        
        return strXML.toString();
    }
	
	/**
	 * 회람판 첨부관련정보 표출 Method
	 */
	@RequestMapping(value = "/ezCircular/getCircularAttachInfo.do")
	public void getCircularAttachInfo(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception{
		logger.debug("getCircularAttachInfo started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String circularFileID = request.getParameter("CircularFileID");
		String fileName = "";
		String filePath = "";
//		String realPath = commonUtil.getRealPath(request);
	
		CircularAttachVO result = ezCircularService.getAttachInfo(circularFileID, userInfo.getTenantId());
		
		filePath = result.getFilePath();
		fileName = result.getFileName();
		
		if (filePath != null && !filePath.equals("")) {
			downFile(request, response, filePath, fileName);
		}
		
		logger.debug("getCircularAttachInfo ended");
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
		int circularBMId = circularDeptVO.getCircularBMID();
		
		circularDeptVO.setMemberID(userInfo.getId());
		circularDeptVO.setRegDate(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		circularDeptVO.setTenantID(userInfo.getTenantId());
		
		String[] memberListStr = request.getParameterValues("memberListStr[]");

		if (circularBMId != 0) {
			ezCircularService.update_circularDept(circularDeptVO, memberListStr, circularBMId);
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
		
		circularDeptVO.setTenantID(userInfo.getTenantId());
		circularDeptVO.setMemberID(userInfo.getId());
		
		String result = ezCircularService.getcircularDeptList(circularDeptVO, userInfo);
		
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
		
		List<CircularListVO> list = ezCircularService.getCircularDeptUserList(circularBMId, tenantId);
		
		String userID = "";
		String userName = "";
		String userName2 = "";

		for (int i=0; i<list.size(); i++) {
			if (list.size() == 1) {
				userID = list.get(i).getMemberID();
				userName = list.get(i).getMemberName();
				userName2 = list.get(i).getMemberName2();
			} else if (i != list.size()-1) {
				userID += list.get(i).getMemberID() + ", ";
				userName += list.get(i).getMemberName() + ", ";
				userName2 += list.get(i).getMemberName2() + ", ";
			} else {
				userID += list.get(i).getMemberID();
				userName += list.get(i).getMemberName();
				userName2 += list.get(i).getMemberName2();
			} 
		}
		
		model.addAttribute("circularBMId", circularBMId);
		model.addAttribute("title", title);
		model.addAttribute("userID", userID);
		model.addAttribute("userName", userName);
		model.addAttribute("userName2", userName2);
		model.addAttribute("listSize", list.size());
		
		logger.debug("circularDeptModify ended");
	
		return "/ezCircular/circularDeptModify";
	}
	
	/**
	 * 회람처 삭제 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDeptDel.do", method = RequestMethod.POST)
	@ResponseBody
	public void circularDeptDel(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularDeptVO circularDeptVO) throws Exception {
		
		logger.debug("circularDeptDel started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		int tenantId = userInfo.getTenantId();
		String[] deleteList = request.getParameter("deleteList").split(",");
		
		ezCircularService.circularDeptDel(deleteList, tenantId);
		
		logger.debug("circularDeptDel ended");
	}
	
	/**
	 * 회람판 삭제 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDeleteItem.do", method = RequestMethod.POST)
	@ResponseBody
	public void circularDelete(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
		logger.debug("circularDeleteItem started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularIDList = request.getParameter("circularIDList");
		
		ezCircularService.circularDeleteItem(circularIDList, userInfo.getTenantId());

		logger.debug("circularDeleteItem ended");
	}
	
	/**
	 * 회람판 삭제 시 휴지통으로 이동 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDeleteTemp.do", method = RequestMethod.POST)
	@ResponseBody
	public void circularDeleteTemp(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
		logger.debug("circularDeleteTemp started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularIDList = request.getParameter("circularIDList");
		String memberId = userInfo.getId();
		int tenantId = userInfo.getTenantId(); 
		
		ezCircularService.circularDeleteTemp(circularIDList, memberId, tenantId);

		logger.debug("circularDeleteTemp ended");
	}

    /**
	 * 회람처 설정 이름 확인 Method
	 **/
	@RequestMapping(value = "/ezCircular/circularCheckName.do")
	public String circularCheckName(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		
		logger.debug("circularCheckName started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		int circularBMId = Integer.parseInt(request.getParameter("id"));
		int tenantId = userInfo.getTenantId();
	
		List<CircularMemberVO> list = ezCircularService.getMemberName(circularBMId, tenantId);
		
		model.addAttribute("list", list);
		
		logger.debug("circularCheckName ended");
		
		return "/ezCircular/circularCheckName";
	}
	
	/**
	 * 회람문서함 관리 호출 Method
	 **/
	@RequestMapping(value = "/ezCircular/circularFolderManage.do")
	public String circularFolderManage(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		
		logger.debug("circularFolderManage started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		
		logger.debug("circularFolderManage ended");
		
		return "/ezCircular/circularFolderManage";
	}
	
	/**
	 * 회람문서함 추가 호출 Method
	 **/
	@RequestMapping(value = "/ezCircular/circularInputName.do")
	public String circularInputName(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		
		logger.debug("circularInputName started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		
		logger.debug("circularInputName ended");
		
		return "/ezCircular/circularInputName";
	}
	
	/**
	 * 회람판 환경설정 저장 Method
	 */
	@RequestMapping(value = "/ezCircular/circularClose.do", method = RequestMethod.POST)
	@ResponseBody
	public void circularClose(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularConfigVO circularConfigVO) throws Exception {
		
		logger.debug("circularClose started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String[] circularIDList = request.getParameter("circularIDList").split(";");
		
		ezCircularService.circularClose(circularIDList, userInfo.getTenantId());
		
		logger.debug("circularClose ended");
	}
	
	/**
	 * 회람처 폴더추가 Method
	 */
	@RequestMapping(value = "/ezCircular/circularFolderAdd.do")
	@ResponseBody
	public void circularFolderAdd(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, CircularDeptVO circularDeptVO, HttpServletRequest request) throws Exception {
		
		logger.debug("circularFolderAdd started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String memberId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		String folderName = request.getParameter("folderName");
		String regDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		ezCircularService.circularFolderAdd(folderName, memberId, regDate, tenantId);
		
		logger.debug("circularFolderAdd ended");
	}
	
	/**
	 * 회람처 폴더수정 Method
	 */
	@RequestMapping(value = "/ezCircular/circularFolderModify.do")
	@ResponseBody
	public void circularFolderModify(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, CircularDeptVO circularDeptVO, HttpServletRequest request) throws Exception {
		
		logger.debug("circularFolderModify started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String memberId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		String folderName = request.getParameter("folderName");
		String folderId = request.getParameter("FolderId");
		String regDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		ezCircularService.circularFolderModify(folderId, folderName, memberId, regDate, tenantId);
		
		logger.debug("circularFolderModify ended");
	}
	
	/**
	 * 회람문서함 관리 폴더 삭제 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDeleteFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public void circularDeleteFolder(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularConfigVO circularConfigVO) throws Exception {
		
		logger.debug("circularDeleteFolder started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		String deleteFolderId = request.getParameter("deleteFolder");
		String memberId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		
		ezCircularService.circularDeleteFolder(deleteFolderId, memberId, tenantId);
		
		logger.debug("circularDeleteFolder ended");
	}
	
	/**
	 * 회람문서함 폴더의 회람판 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularFolderDoc.do")
	public String circularFolderDoc(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {		
		logger.debug("circularFolderDoc started");

		userInfo = commonUtil.userInfo(loginCookie);

        int folderId = Integer.parseInt(request.getParameter("folderId"));

		String folderName = ezCircularService.getFolderInfo(folderId, userInfo.getId(), userInfo.getTenantId());

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("folderId", folderId);
		model.addAttribute("folderName", folderName);
		
		logger.debug("circularFolderDoc ended");
		
		return "/ezCircular/circularFolderDoc";
	}
	
	/**
	 * 회람판 이동 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/circularMove.do")
	public String circularMove(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		logger.debug("circularMove started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		String circularIdList = request.getParameter("circularIdList");
		String folderId = request.getParameter("folderId");

		if (folderId != null) {	
			model.addAttribute("folderId", folderId);
		}

		model.addAttribute("circularIdList", circularIdList);

		logger.debug("circularMove ended");
		
		return "/ezCircular/circularMove";
	}
	
	/**
	 * 회람문서 되돌리기 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/circularReturn.do", method = RequestMethod.POST)
	@ResponseBody
	public void circularReturn(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		logger.debug("circularReturn started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		String circularIdList = request.getParameter("circularIDList");
		String folderId = request.getParameter("folderId");

		ezCircularService.circularReturn(circularIdList, folderId, userInfo.getId(), userInfo.getTenantId());

		logger.debug("circularReturn ended");
	}
	
	/**
	 * 회람판 이동 함수 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/moveCircular.do", method = RequestMethod.POST)
	@ResponseBody
	public void moveCircular(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularConfigVO circularConfigVO) throws Exception {
		
		logger.debug("moveCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		String updateStatus = "";
		String circularIdList = request.getParameter("circularIdList");
		String folderId = request.getParameter("folderId");
		String oldFolderId = request.getParameter("oldFolderId");
		String originLoc = request.getParameter("originLoc");
		String memberId = userInfo.getId();
		int tenantId = userInfo.getTenantId();

		if (oldFolderId.equals("")) { // 확인완료 및 작성한 회람판에서 폴더로 이동 시
			updateStatus = "3";
			ezCircularService.moveCircular(folderId, circularIdList, memberId, updateStatus, originLoc, tenantId);
		}
		
		if (oldFolderId != null && folderId != "") { // 폴더에서 폴더로 이동 시
			ezCircularService.updateFolderId(folderId, circularIdList, memberId, tenantId);
		}

		logger.debug("moveCircular ended");
	}
	
	/**
	 * 개인폴더 회람판 리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getFolderCircularList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getFolderCircularList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
    	logger.debug("getFolderCircularList started");

    	userInfo = commonUtil.userInfo(loginCookie);

    	CircularListHeaderVO headerVO = new CircularListHeaderVO();

    	headerVO.setListType("C");
    	headerVO.setTenantID(userInfo.getTenantId());
    	String searchValue = req.getParameter("searchValue");
    	
    	List<CircularListHeaderVO> headerList = ezCircularService.getListHeader(headerVO);

        int startRow = 1;
        int endRow = 0;
        
        String pageNum = "1";
        if (req.getParameter("pageNum") != null && !req.getParameter("pageNum").equals("")) {
        	pageNum = req.getParameter("pageNum"); 
        }
        
        int folderId = Integer.parseInt(req.getParameter("folderId"));
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getFolderCircularListCount(folderId, userInfo.getId(), searchValue, userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getFolderCircularList(folderId, userInfo.getId(), startRow, endRow, searchValue, userInfo.getOffset(), userInfo.getTenantId());
		
		StringBuffer resultXML = new StringBuffer();

		resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + totalCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + config.getIsPreview() + "</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLISTVALUE>" + config.getPreviewListValue() + "</PREVIEWWLISTVALUE>");
        resultXML.append("<PREVIEWWCONTENTVALUE>" + config.getPreviewContentValue() + "</PREVIEWWCONTENTVALUE>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");

        for (CircularListHeaderVO vo : headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName1() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }

        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + (vo.getStatus() == 0 ? "진행중" : "종료") + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getTitle() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberName() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmCount() + "/" + vo.getConfirmTotalCount() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmDate() + "</VALUE></CELL>");
//			resultXML.append("<CELL><VALUE>" + vo.getUpdateDate() + "</VALUE></CELL>");
			resultXML.append("</ROW>");
        }
        
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
        
        logger.debug("resultXML : "+resultXML);
		logger.debug("getFolderCircularList ended");
		
        return resultXML.toString();
    }
    
    /**
     * 해당회람자 댓글 목록 조회
     * 회람판ID, 회람자ID
     */
    @RequestMapping(value = "/ezCircular/getCircularComment.do")
    public String getCircularComment(@CookieValue("loginCookie") String loginCookie, CircularCommentVO circularCommentVO, HttpServletRequest request, Model model) throws Exception {
    	logger.debug("getCircularComment started.");
    	logger.debug("circularID = " + circularCommentVO.getCircularID());
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	String searchValue = request.getParameter("searchValue");
    	
    	List<CircularListVO> circularUserList = ezCircularService.getCircularUserList(Integer.parseInt(circularCommentVO.getCircularID()), searchValue, userInfo.getTenantId());
    	List<CircularCommentVO> circularCommentList = ezCircularService.getCircularComment(circularCommentVO, searchValue, userInfo.getOffset(), userInfo.getTenantId());
    	
    	logger.debug("getCircularComment ended.");
    	
    	model.addAttribute("circularUserList", circularUserList);
    	model.addAttribute("circularCommentList", circularCommentList);
    	model.addAttribute("userInfo", userInfo);
    	
    	return "json";
    }
    
    /**
     * 회람판 의견 저장
     * 회람판ID, 회람자ID, 댓글작성자ID, 글내용
     * 저장할때 
     */
    @RequestMapping(value = "/ezCircular/editCircularComment.do")
    public String editCircularComment(@CookieValue("loginCookie") String loginCookie, CircularCommentVO circularCommentVO) throws Exception {
    	logger.debug("editCircularComment started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	
    	ezCircularService.editCircularComment(circularCommentVO, userInfo);
    	
    	CircularListVO circularVO = ezCircularService.getCircular(circularCommentVO.getCircularID(), userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId(), "comment");
    	List<CircularCommentVO> list = ezCircularService.getCircularCommentUserList(circularCommentVO.getCircularID(), circularCommentVO.getCircularUserID(), userInfo.getTenantId(), "circularComment");
    	
    	String subject = "[신규의견알림] 새로운 의견이 등록되었습니다.";
    	StringBuilder bodyContent = new StringBuilder("");
    	bodyContent.append(" 제목 : " + circularVO.getTitle() + "</br>");
    	bodyContent.append(" 의견 작성자 : " + userInfo.getDisplayName());
    	
    	InternetAddress from = new InternetAddress();
		from.setPersonal(userInfo.getDisplayName(), "UTF-8");
		from.setAddress(userInfo.getEmail());
		
    	for (CircularCommentVO vo : list) {
			if (circularCommentVO.getCircularUserID().equals(vo.getMemberID())) {
				InternetAddress to = new InternetAddress();
				to.setPersonal(vo.getMemberName(), "UTF-8");
				to.setAddress(vo.getMemberID());
				
				ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
			}
		}
    	
    	logger.debug("editCircularComment ended.");
    	
    	return "json";
    }
    
    /**
     * 회람판 의견 삭제
     */
    @RequestMapping(value = "/ezCircular/deleteCircularComment.do")
    public String deleteCircularComment(@CookieValue("loginCookie") String loginCookie, CircularCommentVO circularCommentVO) throws Exception {
    	logger.debug("deleteCircularComment started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	
    	ezCircularService.deleteCircularComment(circularCommentVO, userInfo);
    	
    	logger.debug("deleteCircularComment ended.");
    	
    	return "json";
    }

    /**
     * 회람 확인요청메일 (회람 미확인자)
     */
    @RequestMapping(value = "/ezCircular/commentSendMail.do")
    public String commentSendMail(@CookieValue("loginCookie") String loginCookie, CircularCommentVO circularCommentVO) throws Exception {
    	logger.debug("commentSendMail started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	
    	CircularListVO circularVO = ezCircularService.getCircular(circularCommentVO.getCircularID(), userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId(), "comment");
    	List<CircularCommentVO> list = ezCircularService.getCircularCommentUserList(circularCommentVO.getCircularID(), circularCommentVO.getCircularUserID(), userInfo.getTenantId(), "circularUser");
    	
    	String subject = "[회람확인요청] 회람확인요청이 도착했습니다.";
    	StringBuilder bodyContent = new StringBuilder("");
    	bodyContent.append(" 제목 : " + circularVO.getTitle() + " </br>");
    	bodyContent.append(" 내용 : " + circularVO.getContent());
    	
    	InternetAddress from = new InternetAddress();
    	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
    	from.setAddress(userInfo.getEmail());
    	
		for (CircularCommentVO vo : list) {
			if (!vo.getMemberID().equals(userInfo.getId())) {				
				InternetAddress to = new InternetAddress();
				to.setPersonal(vo.getMemberName(), "UTF-8");
				to.setAddress(vo.getMemberID());
				
				ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
			}
		}
		
    	logger.debug("commentSendMail ended.");
    	
    	return "json";
    }
    
    /**
     * 회람 의견목록 팝업화면조회
     */
    @RequestMapping(value = "/ezCircular/circularCommentPopup.do")
    public String circularCommentPopup(@CookieValue("loginCookie") String loginCookie, CircularCommentVO circularCommentVO, Model model) throws Exception {
    	logger.debug("circularCommentPopup started.");
    	logger.debug("circularID = " + circularCommentVO.getCircularID());
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	CircularListVO vo = ezCircularService.getCircular(circularCommentVO.getCircularID(), userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId(), "read");
    	
    	logger.debug("circularCommentPopup ended.");
    	
    	model.addAttribute("userInfo", userInfo);
    	model.addAttribute("vo", vo);
    	
    	return "/ezCircular/circularCommentPopup";
    }
}
