package egovframework.ezEKP.ezCircular.web;

import java.io.File;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import egovframework.let.utl.fcc.service.EgovDateUtil;

/** 
 * @Description [Controller] 사용자 - 회람판 
 * @author 오픈솔루션팀 이효진, 정수현
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.05.17	정수현			신규작성
 *    2017.06.19	이효진			추가작성
 *
 * @see
 */

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
	 */
	@RequestMapping(value="/ezCircular/circularLeft.do")
	public String circularLeft() throws Exception {
		logger.debug("circularLeft started.");

		logger.debug("circularLeft ended.");

		return "/ezCircular/circularLeft";
	}

	/**
	 * 회람문서함 폴더트리 호출 Method
	 */
	@RequestMapping(value="/ezCircular/getCircularFolderList.do")
	public String getCircularFolderList(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("getCircularFolderList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		StringBuilder rootFolderXML = new StringBuilder();

		List<CircularFolderVO> list = ezCircularService.getTopFolder(userInfo.getId(), userInfo.getTenantId());
		
		for (int i=0; i < list.size(); i++) {
			rootFolderXML.append("<node imgidx='1' caption='" + 
					list.get(i).getCircularFolderName() + "' foldername='" + 
					list.get(i).getCircularFolderName() + "' fullcaption='_NONE' href='" + 
					list.get(i).getCircularFolderID() + "'></node>");
		}
		
		model.addAttribute("rootFolderXML", rootFolderXML.toString());
		
		logger.debug("getCircularFolderList ended.");

		return "json";
	}
	
	/**
	 * 회람문서함관리 및 회람판에서 이동 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/getCircularFolderList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getCircularFolderList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
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
	@RequestMapping(value = "/ezCircular/newCircular.do")
	public String newCircular(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("newCircular started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userInfo", userInfo);

		logger.debug("newCircular ended");

		return "/ezCircular/newCircular";
	}
	
	/**
	 * 회람판 미리보기 표출 Method
	 */
	@RequestMapping(value = "/ezCircular/getPreviewItem.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getPreviewItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception{
		logger.debug("getPreviewItem started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String circularID = request.getParameter("pcircularId");

		String retXML = ezCircularService.getItemXML(circularID, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId());
		
		logger.debug("getPreviewItem ended.");
		
		return retXML;	
	}
	
	/**
	 * 회람판 미리보기게시물 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularItemPreviewContent.do")
	public String circularItemPreviewContent() throws Exception{
		logger.debug("circularItemPreviewContent started.");
		
		logger.debug("circularItemPreviewContent ended.");
		
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
	 * 회람판 첨부파일관련 표출 Method 
	 */
	public String getItemAttachmentXML(String pcircularId, int tenantId) throws Exception{
		List<CircularAttachVO> circularAttachVOList = ezCircularService.getAttachList(Integer.parseInt(pcircularId), tenantId);
		
		StringBuilder resultXML = new StringBuilder();
		resultXML.append("<NODES>");

		for (int i = 0; i < circularAttachVOList.size(); i++) {
			resultXML.append("<NODE>");
			resultXML.append("<CircularFileId>" + circularAttachVOList.get(i).getCircularFileID() + "</CircularFileId>");
			resultXML.append("<FileSize>" + commonUtil.byteCalculation(Long.toString(circularAttachVOList.get(i).getFileSize())) + "</FileSize>");
			resultXML.append("<FileName>" + commonUtil.cleanValue(circularAttachVOList.get(i).getFileName()) + "</FileName>");
			resultXML.append("<FilePath>" + commonUtil.cleanValue(circularAttachVOList.get(i).getFilePath()) + "</FilePath>");
			resultXML.append("<FileType>" + commonUtil.cleanValue(circularAttachVOList.get(i).getFilePath().split("\\.")[1]) + "</FileType>");
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

		String circularFileID = "";
		String filePath = "";
		String fileName = "";
		String realPath = commonUtil.getRealPath(request);
		String uploadFilePath = commonUtil.getUploadPath("upload_circular.ROOT", userInfo.getTenantId());
		
		if (request.getParameter("filePath") != null && !request.getParameter("filePath").equals("")) {
			filePath = request.getParameter("filePath"); 
        }
		
		if (request.getParameter("fileName") != null && !request.getParameter("fileName").equals("")) {
			fileName = request.getParameter("fileName"); 
        }

		if (request.getParameter("circularFileID") != null && !request.getParameter("circularFileID").equals("")) {
			circularFileID = request.getParameter("circularFileID"); 
        }

		if (filePath.equals("") && fileName.equals("")) {
			CircularAttachVO result = ezCircularService.getAttachInfo(circularFileID, userInfo.getTenantId());

			filePath = result.getFilePath();
			fileName = result.getFileName();
		}

		logger.debug("filePath : " + filePath + " | fileName : " + fileName);

		String fullFilePath = realPath + uploadFilePath + commonUtil.separator + "uploadFile" + filePath;

		logger.debug("fullFilePath : " + fullFilePath);
		
		downFile(request, response, fullFilePath, fileName);

		logger.debug("downloadAttach ended");
	}

	/**
	 * 받은회람판 회람판 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularComplete.do")
	public String circularComplete(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
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
	public String circularMyCircular(Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
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
	public String circularDelete(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
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
	public String circularSearchView(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO userInfo) throws Exception {
		logger.debug("circularSearchView started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		List<CircularListHeaderVO> headerList = ezCircularService.getListHeader("N", userInfo.getLang(), userInfo.getTenantId());
		
		StringBuffer resultXML = new StringBuffer();

		resultXML.append("<DOCLIST>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        for (CircularListHeaderVO vo : headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }

        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");

		logger.debug("circularSearchView ended");
		
		model.addAttribute("listHeader", resultXML);
		
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
		
		logger.debug("previewMode : " + previewMode + ", list : " + list + ", content : " + content);
		
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
		
		CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		int tempCount = config.getListCnt();

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
    	
    	String searchValue = req.getParameter("searchValue");
    	String orderCell = req.getParameter("orderCell");
    	String orderOption = req.getParameter("orderOption");
    	String sdate = req.getParameter("sdate");
    	String edate = req.getParameter("edate");
    	String searchType = req.getParameter("searchType");
    	String pageNum = req.getParameter("pageNum");
    	String orderOption1 = "";
    	int startRow = 1;
    	int endRow = 0;
    	
        List<CircularListHeaderVO> headerList = ezCircularService.getListHeader("N", userInfo.getLang(), userInfo.getTenantId());

		for (CircularListHeaderVO vo : headerList) {
			if (!orderCell.equals("") && orderCell.equals(vo.getColName())) {
		        if (orderOption.equals("")) {
		            orderOption1 = vo.getColName() + " ";
		        } else {
		            orderOption1 = vo.getColName() + " DESC ";
		        }
		    }
		}
        
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularListCount(userInfo.getId(), searchValue, searchType, sdate, edate, userInfo.getOffset(), userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getCircularList(userInfo.getId(), searchValue, searchType, sdate, edate, startRow, endRow, userInfo.getTenantId(), userInfo.getOffset(), orderCell, orderOption1);
		
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
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }

        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date now = new Date();
        String strDate = sdfDate.format(now);
        String newlyDate = EgovDateUtil.addDay(strDate, -3, "yyyy-MM-dd HH:mm:ss");
        
        logger.debug("newlyDate = " + newlyDate);
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
    		
    		if (vo.getRegDate().compareTo(newlyDate) > 0) {
    			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><NEWLYDATE>1</NEWLYDATE><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			} else {
				resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><NEWLYDATE>0</NEWLYDATE><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			}
			
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmStatus() + "</VALUE></CELL>");
			
			if (vo.getCommentStatus().equals("1")) {
				resultXML.append("<CELL><VALUE>comment</VALUE></CELL>");
			} else if (vo.getShareStatus().equals("1")) {
				resultXML.append("<CELL><VALUE>share</VALUE></CELL>");
			} else {
				resultXML.append("<CELL><VALUE>new</VALUE></CELL>");
			}
			
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + vo.getTitle() + "]]></VALUE><DATA>1</DATA></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberName() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate().substring(0, 16) + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmCount() + "/" + vo.getConfirmTotalCount() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getStatus() + "</VALUE></CELL>");
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

		userInfo = commonUtil.userInfo(loginCookie);
		
		int startRow = 1;
		int endRow = 0;
		String pageNum = req.getParameter("pageNum"); 
		String searchType = req.getParameter("searchType");
		String searchValue = req.getParameter("searchValue");
		String sdate = req.getParameter("sdate");
		String edate = req.getParameter("edate");
		String orderCell = req.getParameter("orderCell");
		String orderOption = req.getParameter("orderOption");
		
		List<CircularListHeaderVO> headerList = ezCircularService.getListHeader("T", userInfo.getLang(), userInfo.getTenantId());
		
		String orderOption1 = "";
    	for (CircularListHeaderVO vo : headerList) {
    		if (!orderCell.equals("") && orderCell.equals(vo.getColName())) {
		        if (orderOption.equals("")) {
		            orderOption1 = vo.getColName() + " ";
		        } else {
		            orderOption1 = vo.getColName() + " DESC ";
		        }
		    }
		}

    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularCompleteListCount(userInfo.getId(), searchValue, searchType, sdate, edate, userInfo.getOffset(), userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getCircularCompleteList(userInfo.getId(), searchValue, searchType, sdate, edate, startRow, endRow, userInfo.getTenantId(), userInfo.getOffset(), orderCell, orderOption1);
		
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
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }
       
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date now = new Date();
        String strDate = sdfDate.format(now);
        String newlyDate = EgovDateUtil.addDay(strDate, -3, "yyyy-MM-dd HH:mm:ss");
        
        logger.debug("newlyDate = " + newlyDate);
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
    		
    		if (vo.getRegDate().compareTo(newlyDate) > 0) {
    			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><NEWLYDATE>1</NEWLYDATE><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			} else {
				resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><NEWLYDATE>0</NEWLYDATE><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			}
        
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmStatus() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + vo.getTitle() + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberName() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate().substring(0, 16) + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmCount() + "/" + vo.getConfirmTotalCount() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getStatus() + "</VALUE></CELL>");
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
    	String pageNum = req.getParameter("pageNum");
    	String searchType = req.getParameter("searchType");
    	String searchValue = req.getParameter("searchValue");
    	String sdate = req.getParameter("sdate");
    	String edate = req.getParameter("edate");
    	String orderCell = req.getParameter("orderCell");
    	String orderOption = req.getParameter("orderOption");
    	int startRow = 1;
    	int endRow = 0;

    	List<CircularListHeaderVO> headerList = ezCircularService.getListHeader("T", userInfo.getLang(), userInfo.getTenantId());
    	
    	String orderOption1 = "";

    	for (CircularListHeaderVO vo : headerList) {
    		if (!orderCell.equals("") && orderCell.equals(vo.getColName())) {
		        if (orderOption.equals("")) {
		            orderOption1 = vo.getColName() + " ";
		        } else {
		            orderOption1 = vo.getColName() + " DESC ";
		        }
		    }
		}

    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularTempListCount(userInfo.getId(), searchValue, searchType, sdate, edate, userInfo.getOffset(), userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getCircularTempList(userInfo.getId(), searchValue, searchType, sdate, edate, startRow, endRow, userInfo.getOffset(), userInfo.getTenantId(), orderCell, orderOption1);
		
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
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }

        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date now = new Date();
        String strDate = sdfDate.format(now);
        String newlyDate = EgovDateUtil.addDay(strDate, -3, "yyyy-MM-dd HH:mm:ss");
        
        logger.debug("newlyDate = " + newlyDate);
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
    		
    		if (vo.getRegDate().compareTo(newlyDate) > 0) {
    			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><NEWLYDATE>1</NEWLYDATE><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			} else {
				resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><NEWLYDATE>0</NEWLYDATE><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			}
    		
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + 1 + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + vo.getTitle() + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberName() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate().substring(0, 16) + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + "" + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getStatus() + "</VALUE></CELL>");
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
    	String pageNum = req.getParameter("pageNum");
    	String searchType = req.getParameter("searchType");
    	String searchValue = req.getParameter("searchValue");
    	String sdate = req.getParameter("sdate");
    	String edate = req.getParameter("edate");
    	String orderCell = req.getParameter("orderCell");
    	String orderOption = req.getParameter("orderOption");
    	int startRow = 1;
        int endRow = 0;
        
    	List<CircularListHeaderVO> headerList = ezCircularService.getListHeader("T", userInfo.getLang(), userInfo.getTenantId());
    	
    	String orderOption1 = "";

    	for (CircularListHeaderVO vo : headerList) {
    		if (!orderCell.equals("") && orderCell.equals(vo.getColName())) {
		        if (orderOption.equals("")) {
		            orderOption1 = vo.getColName() + " ";
		        } else {
		            orderOption1 = vo.getColName() + " DESC ";
		        }
		    }
		}
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getMyCircularListCount(userInfo.getId(), searchValue, searchType, sdate, edate, userInfo.getOffset(), userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getMyCircularList(userInfo.getId(), searchValue, searchType, sdate, edate, startRow, endRow, userInfo.getOffset(), userInfo.getTenantId(), orderCell, orderOption1);
		
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
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }
        
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date now = new Date();
        String strDate = sdfDate.format(now);
        String newlyDate = EgovDateUtil.addDay(strDate, -3, "yyyy-MM-dd HH:mm:ss");
        
        logger.debug("newlyDate = " + newlyDate);
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
    		
    		if (vo.getRegDate().compareTo(newlyDate) > 0) {
    			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><NEWLYDATE>1</NEWLYDATE>" + 
    							 "<STATUS>" + vo.getStatus() + "</STATUS><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			} else {
				resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><NEWLYDATE>0</NEWLYDATE>" +
								 "<STATUS>" + vo.getStatus() + "</STATUS><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			}

			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmStatus() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + vo.getTitle() + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberName() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate().substring(0, 16) + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmCount() + "/" + vo.getConfirmTotalCount() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getStatus() + "</VALUE></CELL>");
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
        String pageNum = req.getParameter("pageNum");
        String searchType = req.getParameter("searchType");
        String searchValue = req.getParameter("searchValue");
        String orderCell = req.getParameter("orderCell");
        String orderOption = req.getParameter("orderOption");

    	List<CircularListHeaderVO> headerList = ezCircularService.getListHeader("T", userInfo.getLang(), userInfo.getTenantId());
    	
    	String orderOption1 = "";

    	for (CircularListHeaderVO vo : headerList) {
    		if (!orderCell.equals("") && orderCell.equals(vo.getColName())) {
		        if (orderOption.equals("")) {
		            orderOption1 = vo.getColName() + " ";
		        } else {
		            orderOption1 = vo.getColName() + " DESC ";
		        }
		    }
		}
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularTDListCount(userInfo.getId(), searchValue, searchType, userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getCircularTDList(userInfo.getId(), searchValue, searchType, startRow, endRow, userInfo.getTenantId(), userInfo.getOffset(), orderCell, orderOption1);
		
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
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }
        
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date now = new Date();
        String strDate = sdfDate.format(now);
        String newlyDate = EgovDateUtil.addDay(strDate, -3, "yyyy-MM-dd HH:mm:ss");
        
        logger.debug("newlyDate = " + newlyDate);
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
    		
    		if (vo.getRegDate().compareTo(newlyDate) > 0) {
    			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><NEWLYDATE>1</NEWLYDATE><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			} else {
				resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><NEWLYDATE>0</NEWLYDATE><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			}
    		
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmStatus() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + vo.getTitle() + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberName() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate().substring(0, 16) + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmCount() + "/" + vo.getConfirmTotalCount() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getStatus() + "</VALUE></CELL>");
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
	public String circularWrite(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req, Model model, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);

		List<CircularListVO> user = ezCircularService.getUserList(userInfo.getId(), userInfo.getTenantId());

		String circularID = "";
		String userID = "";
		String userName = "";
		String userName2 = "";
		String userMyID = "";
		String userMyName = "";
		String userMyName2 = "";
		String mode = req.getParameter("mode");
		CircularListVO result = new CircularListVO();

		if (user.get(0).getMemberID() != "") {	
			userMyID = user.get(0).getMemberID();
			userMyName = user.get(0).getMemberName();
			userMyName2 = user.get(0).getMemberName2();
		}
		
		if (req.getParameter("circularID") != null && !req.getParameter("circularID").equals("")) {
			circularID = req.getParameter("circularID");
			
			List<CircularAttachVO> attachList = ezCircularService.getAttachList(Integer.parseInt(circularID), userInfo.getTenantId());
			
			String pDirPath = "";
			String realPath = req.getServletContext().getRealPath("");
				
			pDirPath = commonUtil.getUploadPath("upload_circular.ROOT", userInfo.getTenantId());

	        pDirPath = realPath + pDirPath;
	    
	        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
	        	pDirPath = pDirPath + commonUtil.separator;
	        }
			
			StringBuilder strAttach = new StringBuilder();
			strAttach.append("<ROOT><NODES>");
			
			for (CircularAttachVO attach : attachList) {				
				strAttach.append("<DATA><![CDATA[" + commonUtil.cleanPropertyValue(attach.getFilePath().split("/")[2]) + "]]></DATA>");
				strAttach.append("<DATA2><![CDATA[" + attach.getFileName() + "]]></DATA2>");
				strAttach.append("<DATA3><![CDATA[" + attach.getFileSize() + "]]></DATA3>");
				strAttach.append("<DATA4><![CDATA[]]></DATA4>");
				strAttach.append("<DATA5><![CDATA[OK]]></DATA5>");

				if (mode.equals("reuse")) {
					ezCircularService.copyFileList(pDirPath, attach.getFilePath().split("/")[2], circularID);
				}
			}

			strAttach.append("</NODES></ROOT>");

			if (mode.equals("modify")) { // 회람수정
				result = ezCircularService.getCircular(circularID, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId(), "modify");
			} else if (mode.equals("reuse")) {
				result = ezCircularService.getCircular(circularID, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId(), "reuse");
			} else { // 임시회람 수정
				result = ezCircularService.getCircular(circularID, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId(), "temp");
			}
			
			List<CircularListVO> list = ezCircularService.getCircularUserList(Integer.parseInt(circularID), "", "", userInfo.getTenantId(), userInfo.getOffset());

			for (CircularListVO vo : list) {
				if (!vo.getMemberID().equals(result.getMemberID())) {
					userID += vo.getMemberID() + ", ";
					userName += vo.getMemberName() + ", ";
					userName2 += vo.getMemberName2() + ", ";
				}
			}
			
			if (list.size() > 0 && list.size() != 1) {
				userID = userID.substring(0, userID.length() - 2);
				userName = userName.substring(0, userName.length() - 2);
				userName2 = userName2.substring(0, userName2.length() - 2);
			}

			model.addAttribute("strAttach", strAttach.toString());
			model.addAttribute("circularID", circularID);
			model.addAttribute("result", result);
			model.addAttribute("listSize", list.size());
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("userID", userID);
		model.addAttribute("userName", userName);
		model.addAttribute("userName2", userName2);
		model.addAttribute("userMyID", userMyID);
		model.addAttribute("userMyName", userMyName);
		model.addAttribute("userMyName2", userMyName2);
		model.addAttribute("mode", mode);

		return "/ezCircular/circularWrite";
	}
	
	/**
	 * 회람판 draganddrop 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/dragAndDrop.do")
	public String dragAndDrop(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "";
		String circularID = "";
		
		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}
		
		if (request.getParameter("circularID") != null && !request.getParameter("circularID").equals("")) {
			circularID = request.getParameter("circularID");
		}
		
		
		model.addAttribute("userInfo",userInfo);
		model.addAttribute("mode", mode);
		model.addAttribute("circularID", circularID);
		
		return "/ezCircular/circularDragAndDrop";
	}
	
	/**
	 * 회람판 회람판 등록 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/saveCircular.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveCircular(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO, LoginSimpleVO loginSimpleVO) throws Exception {
		logger.debug("saveCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		String realPath = request.getServletContext().getRealPath("");
		String fileList = "";
		String pDirPath = "";

		if (request.getParameter("fileList") != null && !request.getParameter("fileList").equals("")) {
			fileList = request.getParameter("fileList");
			
			pDirPath = commonUtil.getUploadPath("upload_circular.ROOT", loginSimpleVO.getTenantId());

	        pDirPath = realPath + pDirPath;
        
	        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
	        	pDirPath = pDirPath + commonUtil.separator;
	        }
		}
		
		logger.debug("fileList : " + fileList);

		int circularUserId = 0;
		int updateStatus = 0;
		circularListVO.setStatus(0);

		String originCircularID = request.getParameter("oldCircularID");
		String mode = request.getParameter("mode");
		String receiverIDs = request.getParameter("receiverID");
		String receiverList = request.getParameter("receiverList");
		String receiverList2 = request.getParameter("receiverList2");
//		String realPath = commonUtil.getRealPath(request);

		logger.debug("receiverIDs : " + receiverIDs);
		logger.debug("receiverList : " + receiverList);
		logger.debug("receiverList2 : " + receiverList2);
		
		int receiverLength = receiverIDs.split(",").length;
		String[] receiverID = receiverIDs.split(",");
		String[] receiverName = receiverList.split(",");
		String[] receiverName2 = receiverList2.split(",");
		
		String regDate = commonUtil.getTodayUTCTime("");
		
		if (mode.equals("reuse")) {
			originCircularID = "";
		}

		//임시회람판에서 회람등록 시 임시회람판에 있는 데이터 update
		if (!originCircularID.equals("") && (mode.equals("temp") || mode.equals("modify"))) {
			ezCircularService.updateCircular(circularListVO.getTitle(),circularListVO.getImportance(),circularListVO.getOption(), originCircularID, userInfo.getTenantId(), userInfo.getId(), 
					receiverLength, circularListVO.getStatus(), loginCookie, userInfo, regDate, circularListVO.getContent(), fileList, userInfo.getOffset(), receiverID, receiverName,
					receiverName2, circularUserId, updateStatus, mode, pDirPath);
		} else {
			ezCircularService.insertCircular(circularListVO.getCircularID(), circularListVO.getTitle(), circularListVO.getImportance(), circularListVO.getOption(), 
					circularListVO.getContent(), circularListVO.getHasFile(), circularListVO.getStatus(), regDate, circularListVO.getEndDate(), 
					receiverLength, receiverID, updateStatus, circularUserId, receiverName, fileList, receiverName2, pDirPath, mode, userInfo, loginCookie);			
		}

		logger.debug("saveCircular ended");
	}
	
	/**
	 * 임시 회람판 등록 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/circularSaveTemp.do", method = RequestMethod.POST)
	@ResponseBody
	public void circularSaveTemp(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO, LoginSimpleVO loginSimpleVO) throws Exception {
		logger.debug("saveCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String realPath = request.getServletContext().getRealPath("");
		String mode = request.getParameter("mode");
		String fileList = "";
		String pDirPath = "";
		
		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}

		if (request.getParameter("fileList") != null && !request.getParameter("fileList").equals("")) {
			fileList = request.getParameter("fileList");

			pDirPath = commonUtil.getUploadPath("upload_circular.ROOT", loginSimpleVO.getTenantId());

	        pDirPath = realPath + pDirPath;

	        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
	        	pDirPath = pDirPath + commonUtil.separator;
	        }
		}

		logger.debug("fileList : " + fileList);
		
		int circularUserId = 0;
		int updateStatus = 0;
		int receiverLength = 0;
		String confirmDate = "";
		
		circularListVO.setStatus(2);
		
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

		String regDate = commonUtil.getTodayUTCTime("");

		if (circularListVO.getCircularID() == 0) {
			ezCircularService.insertCircular(circularListVO.getCircularID(), circularListVO.getTitle(), circularListVO.getImportance(), circularListVO.getOption(), 
					circularListVO.getContent(), circularListVO.getHasFile(), circularListVO.getStatus(), regDate, circularListVO.getEndDate(), 
					receiverLength, receiverID, updateStatus, circularUserId, receiverName, fileList, receiverName2, pDirPath, mode, userInfo, loginCookie);			
		} else {
			ezCircularService.modifyCircular(circularListVO.getTitle(),circularListVO.getImportance(),circularListVO.getOption(),circularListVO.getCircularID(), 
					userInfo.getTenantId(), receiverLength, receiverID, updateStatus, circularUserId, circularListVO.getMemberName(), 
					circularListVO.getMemberName2(), circularListVO.getStatus(), confirmDate, circularListVO.getContent(), 
					fileList, pDirPath, receiverName, receiverName2, userInfo.getOffset());
		}

		logger.debug("saveCircular ended");
	}
	
	/**
	 * 회람판 상세정보 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/circularRead.do")
	public String circularRead(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, HttpServletRequest req, Model model) throws Exception {
		logger.debug("circularRead Start");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularID = req.getParameter("circularID");
		String type = req.getParameter("type");
	 
		CircularListVO result = ezCircularService.getCircular(circularID, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId(), "read");
		int totalCommentCount = ezCircularService.getCommentCount(circularID, userInfo.getId(), "totalComment", userInfo.getTenantId());
		int myCommentCount = ezCircularService.getCommentCount(circularID, userInfo.getId(), "myComment", userInfo.getTenantId());
		
		result.setRegDate(result.getRegDate().substring(0, 16));
		
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
		model.addAttribute("totalCommentCount", totalCommentCount);
		model.addAttribute("myCommentCount", myCommentCount);
		model.addAttribute("type", type);
		
		return "/ezCircular/circularRead";
	}
	
	/**
	 * 회람판 상세화면 의견목록 카운트 조회
	 */
	@RequestMapping(value = "/ezCircular/getCommentCount.do")
	public String getCommentCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getCommentCount started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String circularID = request.getParameter("circularID");
		
		int totalCommentCount = ezCircularService.getCommentCount(circularID, userInfo.getId(), "totalComment", userInfo.getTenantId());
		int myCommentCount = ezCircularService.getCommentCount(circularID, userInfo.getId(), "myComment", userInfo.getTenantId());
		
		model.addAttribute("totalCommentCount", totalCommentCount);
		model.addAttribute("myCommentCount", myCommentCount);
		
		logger.debug("getCommentCount ended.");
		
		return "json";
	}

//	/**
//	 * 회람판 임시 회람판 수정 실행 Method
//	 */
//	@RequestMapping(value = "/ezCircular/saveModifyCircular.do", method = RequestMethod.POST)
//	@ResponseBody
//	public void saveModifyCircular(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
//		logger.debug("saveModifyCircular started");
//		
//		userInfo = commonUtil.userInfo(loginCookie);
//		
//		String fileList = "";
//		if (request.getParameter("fileList") != null && !request.getParameter("fileList").equals("")) {
//			fileList = request.getParameter("fileList");
//		}
//
//		int circularUserId = 0;
//		int updateStatus = 0;
//		String confirmDate = "";
//		int receiverLength = 0;
//		circularListVO.setStatus(0);
//		
//		String receiverIDs = request.getParameter("receiverID");
//		String receiverList = request.getParameter("receiverList");
//		String receiverList2 = request.getParameter("receiverList2");
//		
//		logger.debug("receiverIDs : " + receiverIDs);
//		logger.debug("receiverList : " + receiverList);
//		logger.debug("receiverList2 : " + receiverList2);
//		
//		receiverLength = receiverList.split(",").length;
//		String[] receiverID = receiverIDs.split(", ");
//		String[] receiverName = receiverList.split(", ");
//		String[] receiverName2 = receiverList2.split(", ");
//		
////		if (receiverID.length == 0) {
////			#
////		}
//
//		ezCircularService.modifyCircular(circularListVO.getTitle(),circularListVO.getImportance(),circularListVO.getOption(),circularListVO.getCircularID(), 
//										userInfo.getTenantId(), receiverLength, receiverID, updateStatus, circularUserId, circularListVO.getMemberName(), 
//										circularListVO.getMemberName2(), circularListVO.getStatus(), confirmDate, circularListVO.getContent(), 
//										fileList, receiverName, receiverName2, userInfo.getOffset());
//
//		logger.debug("saveModifyCircular ended");
//	}
	
	/**
	 * 회람판 신규 회람판 클릭했을때, 확인 수 증가 및 확인일 설정 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/circularConfirmStatus.do")
	public String circularConfirmStatus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("confirmStatus started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String circularIDList = request.getParameter("circularIDList");
		
		ezCircularService.circularConfirmStatus(circularIDList, userInfo.getId(), userInfo.getTenantId());
		
		logger.debug("confirmStatus ended");
		
		return "json";
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
        
//      String mode = "";
//		String circularID = "";
//
//		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
//			mode = request.getParameter("mode");
//		}
//		
//		if (request.getParameter("circularID") != null && !request.getParameter("circularID").equals("")) {
//			circularID = request.getParameter("circularID");		
//		}
//
//		logger.debug("mode : " + mode + " | circularID : " + circularID);

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
            pFileName[i] = pFileName[i].replace("%2b", "+");
            pFileName[i] = pFileName[i].replace("%3b", ";");
        }
        
        String pDirPath = commonUtil.getUploadPath("upload_circular.ROOT", loginSimpleVO.getTenantId());

        pDirPath = realPath + pDirPath;
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        File file = new File(pDirPath + "uploadFile");
        File tempFile = new File(pDirPath + "tempUploadFile");

        if (!file.exists()) {
        	file.mkdir();
        }
        
        if (!tempFile.exists()) {
        	tempFile.mkdir();
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
        for (int i = 0; i < cnt; i++) {        	
        	fileSize[i] = multiFile.get(i).getSize();
            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
            String newFileName = pUploadSN[i];
            
            if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1 && !useExtension.equals("*")) {           	
				strXML.append("<DATA><![CDATA[" + newFileName + ";" + pFileName[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[" + pFileName[i] + "]]></DATA2>");
				strXML.append("<DATA3><![CDATA[" + fileSize[i] + "]]></DATA3>");
				strXML.append("<DATA4><![CDATA[]]></DATA4>");
				strXML.append("<DATA5><![CDATA[denied]]></DATA5>");
            } else {
//            	if (mode.equals("temp")) {
//            		writeUploadedFile(multiFile.get(i), newFileName + ";" + pFileName[i], pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile");
//            	} else {
            	writeUploadedFile(multiFile.get(i), newFileName + ";" + pFileName[i], pDirPath + "tempUploadFile");            		
//            	}
            	
				strXML.append("<DATA><![CDATA[" + newFileName + ";" + pFileName[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[" + pFileName[i] + "]]></DATA2>");
				strXML.append("<DATA3><![CDATA[" + fileSize[i] + "]]></DATA3>");
				strXML.append("<DATA4><![CDATA[]]></DATA4>");
				strXML.append("<DATA5><![CDATA[OK]]></DATA5>");
            }
        }
        strXML.append("</NODES></ROOT>");
        
        logger.debug("uploadCircularAttach ended");
        
        return strXML.toString();
    }
	
	/**
	 * 회람판작성 > 닫기 클릭시 임시첨부파일 삭제
	 */
	@RequestMapping(value = "/ezCircular/tempUploadFileDelete.do")
	public String tempUploadFileDelete(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		logger.debug("tempUploadFileDelete started");

		String pDirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_circular.ROOT", loginSimpleVO.getTenantId());
		String fileList = request.getParameter("fileList");
//		String mode = "";
//		String circularID = "";
		String filePath = "";
		
		logger.debug("fileList : " + fileList);
		
//		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
//			mode = request.getParameter("mode");
//		}
//		
//		if (request.getParameter("circularID") != null && !request.getParameter("circularID").equals("")) {
//			circularID = request.getParameter("circularID");
//		}
//
//		if (mode.equals("temp")) {
//			filePath = "uploadFile" + commonUtil.separator + circularID + "_uploadFile";
//		} else {
		filePath = "tempUploadFile";
//		}

		if (fileList.length() != 0) {
			String[] data = fileList.split(","); 
			
			for (int i=0; i<data.length; i++) {
				String sGUID = data[i].split(";")[0];
				String fileName = data[i].split(";")[1];
				
				File file = new File(pDirPath + commonUtil.separator + filePath + commonUtil.separator + sGUID + ";" + fileName);
				
				file.delete();
			}			
		}

        logger.debug("tempUploadFileDelete ended");
        
        return "json";
    }
	
//	/**
//	 * 회람판 첨부관련정보 표출 Method
//	 */
//	@RequestMapping(value = "/ezCircular/getCircularAttachInfo.do")
//	public void getCircularAttachInfo(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception{
//		logger.debug("getCircularAttachInfo started");
//		
//		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
//		
//		String circularFileID = request.getParameter("CircularFileID");
//		String fileName = "";
//		String filePath = "";
//		String realPath = commonUtil.getRealPath(request);
//		String uploadFilePath = commonUtil.getUploadPath("upload_circular.ROOT", userInfo.getTenantId());
//	
//		CircularAttachVO result = ezCircularService.getAttachInfo(circularFileID, userInfo.getTenantId());
//		
//		filePath = result.getFilePath();
//		fileName = result.getFileName();
//
//		logger.debug("filePath : " + filePath + " | fileName : " + fileName);
//
//		String fullFilePath = realPath + uploadFilePath + commonUtil.separator + "uploadFile" + filePath;
//
//		if (filePath != null && !filePath.equals("")) {
//			downFile(request, response, fullFilePath, fileName);
//		}
//
//		logger.debug("getCircularAttachInfo ended");
//	}

	/**
	 * 회람처 목록화면 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDeptConfig.do")
	public String circularDeptConfig(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("circularDeptConfig started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		logger.debug("circularDeptConfig ended");
		
		return "/ezCircular/circularDeptConfig";
	}
	
	/**
	 * 회람처 등록화면 호출 Method
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
	public String circularDeptSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("circularDeptSave started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String circularBMId = request.getParameter("circularBMId");
		String title = request.getParameter("title");
		String[] memberListStr = request.getParameterValues("memberListStr[]");
		
		if (!circularBMId.equals("")) {
			ezCircularService.updateCircularDept(title, userInfo.getId(), memberListStr, circularBMId, userInfo.getTenantId());
		} else {
			ezCircularService.setCircularDeptSave(title, userInfo.getId(), memberListStr, userInfo.getTenantId());
		}

		logger.debug("circularDeptSave ended");
		
		return "json";
	}
	
	/**
	 * 회람처 조직도 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularSelectAttendant.do")
	public String circularSelectAttendant(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("circularSelectAttendant started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		logger.debug("circularSelectAttendant ended");
		
		model.addAttribute("userID", userInfo.getId());
		
		return "/ezCircular/circularSelectAttendant";
	}

	/**
	 * 회람처 목록 수정 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDeptModify.do")
	public String circularDeptModify(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularDeptVO circularDeptVO, Model model) throws Exception {
		logger.debug("circularDeptModify started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		int circularBMId = Integer.parseInt(request.getParameter("id"));
		int tenantId = userInfo.getTenantId();

		List<CircularListVO> list = ezCircularService.getCircularDeptUserList(circularBMId, tenantId);
		
		String userID = "";
		String userName = "";
		String userName2 = "";

		String title = list.get(0).getTitle();
		
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
	 * 회람처 삭제 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDeptDel.do")
	public String circularDeptDel(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("circularDeptDel started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularBMIdList = request.getParameter("circularBMIdList");
		
		ezCircularService.circularDeptDel(circularBMIdList, userInfo.getTenantId());
		
		logger.debug("circularDeptDel ended");
		
		return "json";
	}
	
	/**
	 * 회람판 휴지통 회람 리스트 삭제 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/deleteCircularList.do")
	public String deleteCircularList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
		logger.debug("deleteCircularList started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularIDList = request.getParameter("circularIDList");
		String memberIDList = request.getParameter("memberIDList");
		
		logger.debug("circularIDList : " + circularIDList + " | memberIDList : " + memberIDList);
		
		String pDirPath = "";
		String realPath = request.getServletContext().getRealPath("");
			
		pDirPath = commonUtil.getUploadPath("upload_circular.ROOT", userInfo.getTenantId());

        pDirPath = realPath + pDirPath;
    
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }

		ezCircularService.deleteCircularList(circularIDList, memberIDList, pDirPath, userInfo.getId(), userInfo.getTenantId());

		logger.debug("deleteCircularList ended");
		
		return "json";
	}
	
	/**
	 * 회람판 휴지통 회람 삭제 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/deleteCircular.do")
	public String deleteCircular(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("deleteCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularID = request.getParameter("circularID");
		String memberID = request.getParameter("memberID");
		
		ezCircularService.deleteCircular(circularID, memberID, userInfo.getId(), userInfo.getTenantId());

		logger.debug("deleteCircular ended");
		
		return "json";
	}
	
	/**
	 * 회람판 삭제 시 휴지통으로 이동 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/circularDeleteTemp.do", method = RequestMethod.POST)
	public String circularDeleteTemp(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
		logger.debug("circularDeleteTemp started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularIDList = request.getParameter("circularIDList");
		String memberId = userInfo.getId();
		int tenantId = userInfo.getTenantId(); 
		
		ezCircularService.circularDeleteTemp(circularIDList, memberId, tenantId);

		logger.debug("circularDeleteTemp ended");
		
		return "json";
	}

    /**
	 * 회람판 환경설정 즐겨찾기 회람자목록 화면 호출 Method
	 **/
	@RequestMapping(value = "/ezCircular/circularCheckName.do")
	public String circularCheckName(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("circularCheckName started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String circularBMId = request.getParameter("circularBMId");
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
		
		List<CircularFolderVO> list = ezCircularService.getTopFolder(userInfo.getId(), userInfo.getTenantId());
		String folderNameList = "";

		for (int i=0; i<list.size(); i++) {
			folderNameList += list.get(i).getCircularFolderName() + ";";
		}

		logger.debug("folderNameList : " + folderNameList);
		
		model.addAttribute("folderNameList", folderNameList);
		
		logger.debug("circularInputName ended");
		
		return "/ezCircular/circularInputName";
	}
	
	/**
	 * 회람판 환경설정 저장 Method
	 */
	@RequestMapping(value = "/ezCircular/circularClose.do")
	public String circularClose(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularConfigVO circularConfigVO) throws Exception {
		logger.debug("circularClose started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularIDList = request.getParameter("circularIDList");
		
		ezCircularService.circularClose(circularIDList, userInfo.getTenantId());
		
		logger.debug("circularClose ended");
		
		return "json";
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

        logger.debug("folderID : " + folderId);
        
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

		logger.debug("circularIdList : " + circularIdList);

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

    	String folderId = req.getParameter("folderId");
    	String searchType = req.getParameter("searchType");
    	String searchValue = req.getParameter("searchValue");
    	String sdate = req.getParameter("sdate");
        String edate = req.getParameter("edate");
        String orderCell = req.getParameter("orderCell");
        String orderOption = req.getParameter("orderOption");
        String pageNum = req.getParameter("pageNum");

    	List<CircularListHeaderVO> headerList = ezCircularService.getListHeader("T", userInfo.getLang(), userInfo.getTenantId());
    	
    	String orderOption1 = "";

    	for (CircularListHeaderVO vo : headerList) {
    		if (!orderCell.equals("") && orderCell.equals(vo.getColName())) {
		        if (orderOption.equals("")) {
		            orderOption1 = vo.getColName() + " ";
		        } else {
		            orderOption1 = vo.getColName() + " DESC ";
		        }
		    }
		}

        int startRow = 1;
        int endRow = 0;

    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());

		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getFolderCircularListCount(folderId, userInfo.getId(), searchValue, searchType, sdate, edate, userInfo.getOffset(), userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getFolderCircularList(folderId, userInfo.getId(), startRow, endRow, searchValue, searchType, sdate, edate, userInfo.getOffset(), userInfo.getTenantId(), orderCell, orderOption1);
		
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
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }

        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date now = new Date();
        String strDate = sdfDate.format(now);
        String newlyDate = EgovDateUtil.addDay(strDate, -3, "yyyy-MM-dd HH:mm:ss");
        
        logger.debug("newlyDate = " + newlyDate);
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
    		
    		if (vo.getRegDate().compareTo(newlyDate) > 0) {
    			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><NEWLYDATE>1</NEWLYDATE><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			} else {
				resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><NEWLYDATE>0</NEWLYDATE><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			}
    		
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmStatus() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + vo.getTitle() + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberName() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate().substring(0, 16) + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmCount() + "/" + vo.getConfirmTotalCount() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getStatus() + "</VALUE></CELL>");
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
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	String searchType = request.getParameter("searchType");
    	String searchValue = request.getParameter("searchValue");
    	String commentType = request.getParameter("commentType");
    	
logger.debug("searchType = " + searchType);
    	List<CircularListVO> circularUserList = ezCircularService.getCircularUserList(Integer.parseInt(circularCommentVO.getCircularID()), searchType, searchValue, userInfo.getTenantId(), userInfo.getOffset());
    	List<CircularCommentVO> circularCommentList = ezCircularService.getCircularComment(circularCommentVO, searchType, searchValue, userInfo.getId(), commentType, userInfo.getOffset(), userInfo.getTenantId());
    	
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
    	
    	ezCircularService.editCircularComment(circularCommentVO, userInfo, loginCookie);
    	
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
    	
    	String subject = egovMessageSource.getMessage("ezCircular.t165", userInfo.getLocale());
    	StringBuilder bodyContent = new StringBuilder("");
    	bodyContent.append("<div id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">");
    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('/ezCircular/circularRead.do?circularID=" + circularVO.getCircularID() + "', '', 'width=820, height=900')\">" + circularVO.getTitle() + "</span></br>");
    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t122", userInfo.getLocale()) + " : " + circularVO.getMemberName());
    	bodyContent.append("</div>");
    	
    	InternetAddress from = new InternetAddress();
    	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
    	from.setAddress(userInfo.getEmail());
    	
		for (CircularCommentVO vo : list) {
			if (!vo.getMemberID().equals(userInfo.getId())) {				
				InternetAddress to = new InternetAddress();
				to.setPersonal(vo.getMemberName(), "UTF-8");
				to.setAddress(vo.getMail());
				
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
    	
    	model.addAttribute("userInfo", userInfo);
    	model.addAttribute("vo", vo);
    	
    	logger.debug("circularCommentPopup ended.");
    	
    	return "/ezCircular/circularCommentPopup";
    }

    /**
     * 회람처 추가
     */
    @RequestMapping(value = "/ezCircular/circularDeptListAdd.do")
    public String circularDeptListAdd(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
    	logger.debug("circularDeptListAdd started.");

    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	
		List<CircularDeptVO> result = ezCircularService.getcircularDeptList(userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId());
    	
    	model.addAttribute("userInfo", userInfo);
    	model.addAttribute("result", result);
    	
    	logger.debug("circularDeptListAdd ended.");
    	
    	return "/ezCircular/circularDeptListAdd";
    }
    
    /**
     * 회람판 공유자지정화면 조회
     */
    @RequestMapping(value = "/ezCircular/circularCommentSharePopup.do")
    public String shareUserPopup(@CookieValue("loginCookie") String loginCookie, CircularCommentVO vo, Model model) throws Exception {
    	logger.debug("shareUserPopup started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	
    	model.addAttribute("userInfo", userInfo);
    	model.addAttribute("vo", vo);
    	
    	logger.debug("shareUserPopup ended.");
    	
    	return "/ezCircular/circularCommentSharePopup";
    }
    
    /**
     * 회람판 공유자 조회
     */
    @RequestMapping(value = "/ezCircular/getCommentShareUser.do")
    public String getCommentShareUser(@CookieValue("loginCookie") String loginCookie, CircularCommentVO vo, HttpServletRequest request, Model model) throws Exception {
    	logger.debug("getCommentShareUser started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	
    	String searchType = request.getParameter("searchType");
    	String searchValue = request.getParameter("searchValue");
    	
    	logger.debug("searchValue = " + searchValue.equals("") + " || searchType = " + searchType);
    	
    	List<CircularListVO> shareUserList = ezCircularService.getCircularUserList(Integer.parseInt(vo.getCircularID()), searchType, searchValue, userInfo.getTenantId(), userInfo.getOffset());
    	
    	model.addAttribute("shareUserList", shareUserList);
    	
    	logger.debug("getCommentShareUser ended.");
    	
    	return "json";
    }
    
    /**
     * 회람판 왼쪽메뉴 전체화면 카운트
     */
    @RequestMapping(value = "/ezCircular/getListCount.do")
    public String getListCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
    	logger.debug("getListCount started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	
    	String listType = request.getParameter("listType");
    	
    	int count = ezCircularService.getListCount(listType, userInfo.getId(), userInfo.getTenantId());
    	
    	model.addAttribute("count", count);
    	
    	logger.debug("getListCount ended.");
    	
    	return "json";
    }
    
    /**
     * 회람판 공유자지정 실행함수
     */
    @RequestMapping(value = "/ezCircular/commentShareUser.do")
    public String commentShareUser(@CookieValue("loginCookie") String loginCookie, CircularCommentVO vo, HttpServletRequest request, Model model) throws Exception {
    	logger.debug("commentShareUser started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	
    	String memberIDList = request.getParameter("memberIDList");
    	
    	ezCircularService.commentShareUser(vo.getCircularID(), vo.getCircularCommentID(), memberIDList, userInfo, loginCookie);
    	
    	logger.debug("commentShareUser ended.");
    	
    	return "json";
    }
    /**
	 * 회람작성 시 회람처 List 호출
     *  
	 */
	@RequestMapping(value = "/ezCircular/getcircularDeptList.do")
	public String getcircularDeptList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		logger.debug("getcircularDeptList started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		List<CircularDeptVO> circularDeptList = ezCircularService.getcircularDeptList(userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId());

		logger.debug("getcircularDeptList ended");

		model.addAttribute("circularDeptList", circularDeptList);
		
		return "json";
	}

	/**
	 * 회람자 선택 시 즐겨찾기 목록 호출
     *  
	 */
	@RequestMapping(value = "/ezCircular/getcircularDeptName.do", method = RequestMethod.POST)
	public String getcircularDeptName(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		logger.debug("getcircularDeptName started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		String circularBMId = request.getParameter("circularBMID");
		int tenantId = userInfo.getTenantId();
	
		List<CircularMemberVO> circularDeptNamelist = ezCircularService.getMemberName(circularBMId, tenantId);

		logger.debug("getcircularDeptName ended");

		model.addAttribute("circularDeptNamelist", circularDeptNamelist);
		
		return "json";
	}
	
	/**
	 * 회람판 인쇄상세질문 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularprtQuestion.do")
	public String circularprtQuestion(HttpServletRequest request, Model model) throws Exception{
		logger.debug("circularprtQuestion started");
		
		String attachList = request.getParameter("attachList");
		
		model.addAttribute("attachList", attachList);
		
		logger.debug("circularprtQuestion ended");
		
		return "ezCircular/circularprtQuestion";
	}
	
	/**
	 * 회람확인
	 */
	@RequestMapping(value = "/ezCircular/circularConfirm.do")
	public String circularConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("circularConfirm started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String circularID = request.getParameter("circularID");
		
		ezCircularService.confirmStatus(circularID, userInfo.getId(), userInfo.getTenantId(), "circularConfirm");
		
		logger.debug("circularConfirm ended.");
		
		return "json";
	}
	
	/**
	 * 의견확인(의견, 공유상태 변경)
	 */
	@RequestMapping(value = "/ezCircular/commentConfirm.do")
	public String commentConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("circularConfirm started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String circularID = request.getParameter("circularID");
		
		ezCircularService.confirmStatus(circularID, userInfo.getId(), userInfo.getTenantId(), "commentConfirm");
		
		logger.debug("circularConfirm ended.");
		
		return "json";
	}
	
	/**
	 * 회람판 휴지통 복구 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/restoreCircularList.do")
	public String restoreCircular(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("restoreCircularList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String circularIDList = request.getParameter("circularIDList");
		
		ezCircularService.restoreCircular(circularIDList, userInfo.getId(), userInfo.getTenantId());
		
		logger.debug("restoreCircularList ended.");
		
		return "json";
	}
}
