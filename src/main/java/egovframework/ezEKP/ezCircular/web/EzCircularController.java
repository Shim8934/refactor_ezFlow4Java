package egovframework.ezEKP.ezCircular.web;

import java.io.File;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
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

import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezCircular.service.EzCircularService;
import egovframework.ezEKP.ezCircular.vo.CircularAttachVO;
import egovframework.ezEKP.ezCircular.vo.CircularCommentVO;
import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularDeptVO;
import egovframework.ezEKP.ezCircular.vo.CircularFolderVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.ezEKP.ezCircular.vo.CircularMemberVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.let.user.login.service.LoginService;
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
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;
	
	@Autowired
	private LoginService loginService;
	
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
	 * 회람문서함 폴더 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/getCircularFolderList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getCircularFolderList(HttpServletRequest request, HttpServletResponse response, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		
		logger.debug("getCircularFolderList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<CircularFolderVO> list = ezCircularService.getTopFolder(userInfo.getId(), userInfo.getTenantId());

		StringBuilder subFolderXML = new StringBuilder();
		
		for (int i=0; i<list.size(); i++) {
			if (i == 0) {
				subFolderXML.append("<node imgidx='1'");
				subFolderXML.append(" caption='" + "확인완료회람판" + "'");
				subFolderXML.append(" foldername='" + "확인완료회람판" + "'");
				subFolderXML.append(" fullcaption='_NONE'");
				subFolderXML.append(" href='" + "'");
				subFolderXML.append("></node>");
			}
			
			subFolderXML.append("<node imgidx='1'");
			subFolderXML.append(" caption='" + list.get(i).getCircularFolderName() + "'");
			subFolderXML.append(" foldername='" + list.get(i).getCircularFolderName() + "'");
			subFolderXML.append(" fullcaption='_NONE'");
			subFolderXML.append(" href='" + list.get(i).getCircularFolderID() + "'");
			subFolderXML.append("></node>");			
		}

		logger.debug("getFolderList ended.");
		
		return subFolderXML.toString();
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
        
        int startRow = 1;
        int endRow = 0;
        
		if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (page - 1)) + 1;
        endRow = (personalCount * page);
		
        int totalCount = ezCircularService.getCircularListCount(userInfo.getId(), userInfo.getTenantId());
        
        logger.debug("startRow : " + startRow);
        logger.debug("endRow : " + endRow);
        
		List<CircularListVO> list = ezCircularService.getCircularList(userInfo.getId(), startRow, endRow, userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("listSize : " + list.size());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("list", list);
		model.addAttribute("config", config);
		model.addAttribute("totalCount", totalCount);
		
		logger.debug("newCircular ended");
		return "/ezCircular/newCircular";
	}
	
	/**
	 * 회람판 미리보기 표출 Method
	 */
	@RequestMapping(value = "/ezCircular/getPreviewItem.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getPreviewItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String pcircularId = "";
		String pmemberId = "";
 		
		pcircularId = request.getParameter("pcircularId"); 		
		pmemberId = request.getParameter("pmemberId"); 		

		String retXML = "";
		
		ezCircularService.confirmStatus(Integer.parseInt(pcircularId), userInfo.getId(), userInfo.getTenantId());
		
		retXML = ezCircularService.getItemXML(pcircularId, pmemberId, userInfo.getOffset(), userInfo.getTenantId());
	
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
		
		String fullFilePath = realPath + uploadFilePath + commonUtil.separator + "uploadFile" + commonUtil.separator + filePath;

		downFile(request, response, fullFilePath, fileName);
		
		logger.debug("downloadAttach ended");
	}
	
	/**
	 * 확인완료 회람판 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularComplete.do")
	public String circularComplete(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("circularComplete started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		int page = 1;
//        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
//        String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
        int startRow = 1;
        int endRow = 0;

		if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (page - 1)) + 1;
        endRow = (personalCount * page);
		
        int totalCount = ezCircularService.getCircularCompleteListCount(userInfo.getId(), userInfo.getTenantId());
        
        logger.debug("startRow : " + startRow);
        logger.debug("endRow : " + endRow);
        
		List<CircularListVO> list = ezCircularService.getCircularCompleteList(userInfo.getId(), startRow, endRow, userInfo.getTenantId(), userInfo.getOffset());
		
		logger.debug("listSize : " + list.size());
		
		for (CircularListVO result : list) {
			result.setRegDate(commonUtil.getDateStringInUTC(result.getRegDate(), userInfo.getOffset(), false));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
//		model.addAttribute("useRunTime", useRunTime);
//		model.addAttribute("useEditor", useEditor);
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
		
		CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (page - 1)) + 1;
        endRow = (personalCount * page);
		
        int totalCount = ezCircularService.getMyCircularListCount(userInfo.getId(), userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getMyCircularList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
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
	public String circularTemp(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		
		logger.debug("circularTemp started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		int page = 1;
//		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId()); 
//        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
//        String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
        int startRow = 1;
        int endRow = 0;
        
		if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (page - 1)) + 1;
        endRow = (personalCount * page);
		
        int totalCount = ezCircularService.getCircularTempListCount(userInfo.getId(), userInfo.getTenantId());

        logger.debug("startRow : " + startRow);
        logger.debug("endRow : " + endRow);
        
		List<CircularListVO> list = ezCircularService.getCircularTempList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
		logger.debug("listSize : " + list.size());
		
		for (CircularListVO result : list) {
			result.setRegDate(commonUtil.getDateStringInUTC(result.getRegDate(), userInfo.getOffset(), false));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
//		model.addAttribute("useOcs", useOcs);
//		model.addAttribute("useRunTime", useRunTime);
//		model.addAttribute("useEditor", useEditor);
		model.addAttribute("list", list);
		model.addAttribute("config", config);
		model.addAttribute("totalCount", totalCount);
		
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
		
		int page = 1;
//		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId()); 
//        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
//        String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
        int startRow = 1;
        int endRow = 0;
        
		if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (page - 1)) + 1;
        endRow = (personalCount * page);
		
        int totalCount = ezCircularService.getCircularTDListCount(userInfo.getId(), userInfo.getTenantId());
        
        logger.debug("startRow : " + startRow);
        logger.debug("endRow : " + endRow);
        
		List<CircularListVO> list = ezCircularService.getCircularTDList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
		logger.debug("listSize : " + list.size());
		
		for (CircularListVO result : list) {
			result.setRegDate(commonUtil.getDateStringInUTC(result.getRegDate(), userInfo.getOffset(), false));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
//		model.addAttribute("useOcs", useOcs);
//		model.addAttribute("useRunTime", useRunTime);
//		model.addAttribute("useEditor", useEditor);
		model.addAttribute("list", list);
		model.addAttribute("config", config);
		model.addAttribute("totalCount", totalCount);
		
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

//			utcStartTime = commonUtil.getDateStringInUTC(startDate, userInfo.getOffset(), true);
//			utcEndTime = commonUtil.getDateStringInUTC(endDate, userInfo.getOffset(), true);
			
//			startDate = startDate.substring(0,10);
//			endDate = endDate.substring(0,10);
		
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

	        int totalCount = ezCircularService.getCircularAllListCount(userInfo.getId(), userInfo.getTenantId(), keyword, filterVal, startDate, endDate);
        
			List<CircularListVO> list = ezCircularService.getSearchAllCircularList(userInfo.getId(), startRow, endRow, userInfo.getTenantId(), keyword, filterVal, startDate, endDate);

			model.addAttribute("totalCount", totalCount);
	        model.addAttribute("list", list);
		}
		
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
		
//		if (circularListConfig == null) {
//			circularListConfig = new CircularConfigVO();
//			circularListConfig.setIsMailReceive(0);
//			circularListConfig.setListCnt(10);
//			circularListConfig.setIsPreview(0);
//			circularListConfig.setPreviewListValue("50");
//			circularListConfig.setPreviewContentValue("50");
//		}
		
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
System.out.println(userID + " / " + listCount + " / " + previewMode + " / " + list + " / " + content);		
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
    public String getCircularList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
    	logger.debug("getCircularList started");

    	userInfo = commonUtil.userInfo(loginCookie);
    	
    	BoardVO boardVO = new BoardVO();
    	
    	boardVO.setBoardType("C");
    	boardVO.setLang(userInfo.getLang());
    	boardVO.setTenantID(userInfo.getTenantId());
    	List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(boardVO);
    	
        int startRow = 1;
        int endRow = 0;
        
        String pageNum = "1";
        
        if (req.getParameter("pageNum") != null && !req.getParameter("pageNum").equals("")) {
        	pageNum = req.getParameter("pageNum"); 
        }
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularListCount(userInfo.getId(), userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getCircularList(userInfo.getId(), startRow, endRow, userInfo.getTenantId(), userInfo.getOffset());
		
		StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + totalCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + config.getIsPreview() + "</PREVIEWTYPE>");
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
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + (vo.getUpdateStatus() == 0 ? "진행중" : "댓글") + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getTitle() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberID() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + ezCircularService.getConfirmStatusFirst(vo.getCircularID(), userInfo.getTenantId()) + "/" + ezCircularService.getConfirmStatusSecond(vo.getCircularID(), userInfo.getTenantId()) + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmDate() + "</VALUE></CELL>");
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
	 * 회람판 확인완료회람판 리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getCircularCompleteList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getCircularCompleteList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
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
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularCompleteListCount(userInfo.getId(), userInfo.getTenantId());
        
        logger.debug("startRow : "+startRow);
        logger.debug("endRow : "+endRow);
        
		List<CircularListVO> list = ezCircularService.getCircularCompleteList(userInfo.getId(), startRow, endRow, userInfo.getTenantId(), userInfo.getOffset());
		
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
        
        for (CircularListVO vo : list) {
    		resultXML.append("<ROW>");
			resultXML.append("<CELL><MEMBERID>" + vo.getMemberID() + "</MEMBERID><CIRCULARID>" + vo.getCircularID() + "</CIRCULARID><VALUE>" + vo.getCircularID() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getImportance() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getHasFile() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + (vo.getUpdateStatus() == 0 ? "진행중" : "댓글") + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getTitle() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getMemberID() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getRegDate() + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + ezCircularService.getConfirmStatusFirst(vo.getCircularID(), userInfo.getTenantId()) + "/" + ezCircularService.getConfirmStatusSecond(vo.getCircularID(), userInfo.getTenantId()) + "</VALUE></CELL>");
			resultXML.append("<CELL><VALUE>" + vo.getConfirmDate() + "</VALUE></CELL>");
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
	 * 회람판 임시회람판 리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getCircularTempList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getCircularTempList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
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
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularTempListCount(userInfo.getId(), userInfo.getTenantId());
        
        logger.debug("startRow : "+startRow);
        logger.debug("endRow : "+endRow);
        
		List<CircularListVO> list = ezCircularService.getCircularTempList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
		List<HashMap<String, Object>> list2 = ezCircularService.getCircularTempMapList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
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
    				fieldValue = fieldValue.equals("0") ? "0" : "1";
    			} else if (fieldName.equals("HASFILE")) {
    				fieldValue = fieldValue.equals("0") ? "0" : "1";
    			} else if (fieldName.equals("STATUS")) {
    				if (fieldValue.equals("0")) {
    					fieldValue = "진행중";
    				} else if (fieldValue.equals("1")) {
    					fieldValue = "종료";
    				} else {
    					fieldValue = "임시";
    				}
    			} else if (fieldName.equals("CONFIRMSTATUS")) {
    				int firstValue = ezCircularService.getConfirmStatusFirst(list.get(j).getCircularID(), userInfo.getTenantId());
    				int secondValue = ezCircularService.getConfirmStatusSecond(list.get(j).getCircularID(), userInfo.getTenantId());
    				
    				fieldValue = firstValue + "/" + secondValue;
    			} else if (fieldName.equals("REGDATE")) {
    				fieldValue = commonUtil.getDateStringInUTC(fieldValue, userInfo.getOffset(), false); 
    			} else if (fieldName.equals("CONFIRMDATE")) {
    				fieldValue = commonUtil.getDateStringInUTC(fieldValue, userInfo.getOffset(), false);
    			}
    			
    			resultXML.append("<MEMBERID>" + list.get(j).getMemberID() + "</MEMBERID>");
    			resultXML.append("<CIRCULARID>" + list.get(j).getCircularID() + "</CIRCULARID>");
    			
    			resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
    			
    			if (i == 0) {
    				resultXML.append("<TITLE>" + list.get(j).getTitle() + "</TITLE>");
    				resultXML.append("<MEMBERID>" + list.get(j).getMemberID() + "</MEMBERID>");
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
	 * 회람판 작성한회람판 리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getMyCircularList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getMyCircularList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
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
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getMyCircularListCount(userInfo.getId(), userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getMyCircularList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
		List<HashMap<String, Object>> list2 = ezCircularService.getMyCircularMapList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
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
    				fieldValue = fieldValue.equals("0") ? "0" : "1";
    			} else if (fieldName.equals("HASFILE")) {
    				fieldValue = fieldValue.equals("0") ? "0" : "1";
    			} else if (fieldName.equals("STATUS")) {
    				if (fieldValue.equals("0")) {
    					fieldValue = "진행중";
    				} else if (fieldValue.equals("1")) {
    					fieldValue = "종료";
    				} else {
    					fieldValue = "임시";
    				}
    			} else if (fieldName.equals("CONFIRMSTATUS")) {
    				int firstValue = ezCircularService.getConfirmStatusFirst(list.get(j).getCircularID(), userInfo.getTenantId());
    				int secondValue = ezCircularService.getConfirmStatusSecond(list.get(j).getCircularID(), userInfo.getTenantId());
    				
    				fieldValue = firstValue + "/" + secondValue;
    			} else if (fieldName.equals("REGDATE")) {
    				fieldValue = commonUtil.getDateStringInUTC(fieldValue, userInfo.getOffset(), false); 
    			} else if (fieldName.equals("CONFIRMDATE")) {
    				fieldValue = commonUtil.getDateStringInUTC(fieldValue, userInfo.getOffset(), false);
    			}
    			
    			resultXML.append("<MEMBERID>" + list.get(j).getMemberID() + "</MEMBERID>");
    			resultXML.append("<CIRCULARID>" + list.get(j).getCircularID() + "</CIRCULARID>");
    			
    			resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
    			
    			if (i == 0) {
    				resultXML.append("<TITLE>" + list.get(j).getTitle() + "</TITLE>");
    				resultXML.append("<MEMBERID>" + list.get(j).getMemberID() + "</MEMBERID>");
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
	 * 휴지통 리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getTDCircularList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getTDCircularList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
    	logger.debug("getTDCircularList started");

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
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularTDListCount(userInfo.getId(), userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getCircularTDList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
		List<HashMap<String, Object>> list2 = ezCircularService.getCircularTDMapList(userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
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
    				fieldValue = fieldValue.equals("0") ? "0" : "1";
    			} else if (fieldName.equals("HASFILE")) {
    				fieldValue = fieldValue.equals("0") ? "0" : "1";
    			} else if (fieldName.equals("STATUS")) {
    				if (fieldValue.equals("0")) {
    					fieldValue = "진행중";
    				} else if (fieldValue.equals("1")) {
    					fieldValue = "종료";
    				} else {
    					fieldValue = "임시";
    				}
    			} else if (fieldName.equals("CONFIRMSTATUS")) {
    				int firstValue = ezCircularService.getConfirmStatusFirst(list.get(j).getCircularID(), userInfo.getTenantId());
    				int secondValue = ezCircularService.getConfirmStatusSecond(list.get(j).getCircularID(), userInfo.getTenantId());
    				
    				fieldValue = firstValue + "/" + secondValue;
    			} else if (fieldName.equals("REGDATE")) {
    				fieldValue = commonUtil.getDateStringInUTC(fieldValue, userInfo.getOffset(), false); 
    			} else if (fieldName.equals("CONFIRMDATE")) {
    				fieldValue = commonUtil.getDateStringInUTC(fieldValue, userInfo.getOffset(), false);
    			}
    			
    			resultXML.append("<MEMBERID>" + list.get(j).getMemberID() + "</MEMBERID>");
    			resultXML.append("<CIRCULARID>" + list.get(j).getCircularID() + "</CIRCULARID>");
    			
    			resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
    			
    			if (i == 0) {
    				resultXML.append("<TITLE>" + list.get(j).getTitle() + "</TITLE>");
    				resultXML.append("<MEMBERID>" + list.get(j).getMemberID() + "</MEMBERID>");
    			}
    			resultXML.append("</CELL>");
    		}
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

		ezCircularService.insertCircular(circularListVO.getCircularID(), circularListVO.getTitle(), circularListVO.getImportance(), circularListVO.getOption(), circularListVO.getContent(), circularListVO.getHasFile(), circularListVO.getStatus(), userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), regDate, circularListVO.getEndDate(),userInfo.getTenantId(), receiverLength, receiverID, updateStatus, circularUserId,receiverName,fileList,receiverName2, realPath);

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

		ezCircularService.insertCircular(circularListVO.getCircularID(), circularListVO.getTitle(), circularListVO.getImportance(), circularListVO.getOption(), circularListVO.getContent(), circularListVO.getHasFile(), circularListVO.getStatus(), userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), regDate, circularListVO.getEndDate(),userInfo.getTenantId(), receiverLength, receiverID, updateStatus, circularUserId,receiverName,fileList,receiverName2, realPath);

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
				listUser = list.get(i).getMemberName();
			} else if (i !=list.size()-1){
				listUser += list.get(i).getMemberName() + ", ";
			} else {
				listUser += list.get(i).getMemberName();
			}
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
	public String circularModify(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, HttpServletRequest req, Model model, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String circularID = "";
		
		if (req.getParameter("circularID") != null && !req.getParameter("circularID").equals("")) {
			circularID = req.getParameter("circularID");
		}
		
		//TODO 회람 상세정보 가져옴
		CircularListVO result = ezCircularService.getCircular(circularID, userInfo.getTenantId());
				
		List<CircularListVO> list = ezCircularService.getCircularUserList(Integer.parseInt(circularID), userInfo.getTenantId());
		
		String userID = "";
		String userName = "";
		String userName2 = "";

		for (int i=0; i<list.size(); i++) {	
			if (list.get(i).getMemberID() != "") {
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
		model.addAttribute("userID", userID);
		model.addAttribute("userName", userName);
		model.addAttribute("userName2", userName2);
		model.addAttribute("listSize", list.size());
		model.addAttribute("strAttach", strAttach.toString());
		
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
	@RequestMapping(value = "/ezCircular/confirmStatus.do", method = RequestMethod.POST)
	@ResponseBody
	public void confirmStatus(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
		logger.debug("confirmStatus started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		logger.debug("cirCularID : " + circularListVO.getCircularID());
		
		ezCircularService.confirmStatus(circularListVO.getCircularID(), userInfo.getId(), userInfo.getTenantId());
		
		logger.debug("confirmStatus ended");
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
		String realPath = commonUtil.getRealPath(request);
	
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
	 * 회람판 신규회람판 검색리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getSearchCircularList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getSearchCircularList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
    	logger.debug("getSearchCircularList started");

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
        
        String keyword = "";
        if (req.getParameter("keyword") != null && !req.getParameter("keyword").equals("")) {
        	keyword = req.getParameter("keyword"); 
        }
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getCircularListCount(userInfo.getId(), userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getSearchCircularList(userInfo.getId(), startRow, endRow, userInfo.getTenantId(), keyword);
		
		List<HashMap<String, Object>> list2 = ezCircularService.getSearchCircularMapList(userInfo.getId(), startRow, endRow, userInfo.getTenantId(),keyword);
		
		for (CircularListVO result : list) {
			result.setRegDate(commonUtil.getDateStringInUTC(result.getRegDate(), userInfo.getOffset(), false));
		}
		
		StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + totalCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + config.getIsPreview() + "</PREVIEWTYPE>");
//        resultXML.append("<PREVIEWWLIST>" + 0 + "</PREVIEWWLIST>");
//        resultXML.append("<PREVIEWWCONTENT>" + 0 + "</PREVIEWWCONTENT>");
//        resultXML.append("<PREVIEWHLIST>" + 0 + "</PREVIEWHLIST>");
//        resultXML.append("<PREVIEWHCONTENT>" + 0 + "</PREVIEWHCONTENT>");
//        resultXML.append("<TITLENUM>" + 0 + "</TITLENUM>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
//        
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
                	fieldValue = fieldValue.equals("0") ? "0" : "1";
                } else if (fieldName.equals("STATUS")) {
    				if (fieldValue.equals("0")) {
    					fieldValue = "진행중";
    				} else if (fieldValue.equals("1")) {
    					fieldValue = "종료";
    				} else {
    					fieldValue = "임시";
    				}
    			} else if (fieldName.equals("CONFIRMSTATUS")) {
                	int firstValue = ezCircularService.getConfirmStatusFirst(list.get(j).getCircularID(), userInfo.getTenantId());
                	int secondValue = ezCircularService.getConfirmStatusSecond(list.get(j).getCircularID(), userInfo.getTenantId());
                	
                	fieldValue = firstValue + "/" + secondValue;
                } else if (fieldName.equals("REGDATE")) {
                	fieldValue = commonUtil.getDateStringInUTC(fieldValue, userInfo.getOffset(), false); 
                } else if (fieldName.equals("CONFIRMDATE")) {
                	fieldValue = commonUtil.getDateStringInUTC(fieldValue, userInfo.getOffset(), false);
                }
            	
				resultXML.append("<MEMBERID>" + list.get(j).getMemberID() + "</MEMBERID>");
				resultXML.append("<CIRCULARID>" + list.get(j).getCircularID() + "</CIRCULARID>");
				
                resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
                
                if (i == 0) {
					resultXML.append("<TITLE>" + list.get(j).getTitle() + "</TITLE>");
					resultXML.append("<MEMBERID>" + list.get(j).getMemberID() + "</MEMBERID>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");

        logger.debug("resultXML : "+resultXML);
		logger.debug("getSearchCircularList ended");
        return resultXML.toString();
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
	 * 회람처 저장 Method
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
	 * 회람처 저장 Method
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
		
		int page = 1;
        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        int folderId = Integer.parseInt(request.getParameter("folderId"));
        int startRow = 1;
        int endRow = 0;
        
		if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (page - 1)) + 1;
        endRow = (personalCount * page);
		
        int totalCount = ezCircularService.getFolderCircularListCount(folderId, userInfo.getId(), userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getFolderCircularList(folderId, userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
		for (CircularListVO result : list) {
			result.setRegDate(commonUtil.getDateStringInUTC(result.getRegDate(), userInfo.getOffset(), false));
		}
		
		String folderName = ezCircularService.getFolderInfo(folderId, userInfo.getId(), userInfo.getTenantId());

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("list", list);
		model.addAttribute("config", config);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("folderId", folderId);
		model.addAttribute("folderName", folderName);
		
		logger.debug("circularMyCircular ended");
		
		return "/ezCircular/circularFolderDoc";
	}
	
	/**
	 * 회람판 이동 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/circularMove.do")
	public String mailMoveCopy(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		logger.debug("circularMove started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		String circularIdList = request.getParameter("circularIdList");
		String folderId = request.getParameter("folderId");

		if (folderId != null) {
			String updateStatus = ezCircularService.getUpdateStatus(circularIdList, userInfo.getId(), userInfo.getTenantId());
			
			model.addAttribute("folderId", folderId);
			model.addAttribute("updateStatus", updateStatus);
		}

		model.addAttribute("circularIdList", circularIdList);

		logger.debug("circularMove ended");
		
		return "/ezCircular/circularMove";
	}
	
	/**
	 * 회람판 이동 함수 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/moveCircular.do", method = RequestMethod.POST)
	@ResponseBody
	public void moveCircular(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularConfigVO circularConfigVO) throws Exception {
		
		logger.debug("moveCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);

		String circularIdList = request.getParameter("circularIdList");
		String folderId = request.getParameter("folderId");
		String oldFolderId = request.getParameter("oldFolderId");
		String updateStatus = request.getParameter("updateStatus");
		String memberId = userInfo.getId();
		int tenantId = userInfo.getTenantId();

		if (oldFolderId.equals("")) { // 확인완료 및 작성한 회람판에서 폴더로 이동 시
			updateStatus = "3";
			ezCircularService.moveCircular(folderId, circularIdList, memberId, updateStatus, tenantId);
		}
		
		if (oldFolderId != null && folderId != "") { // 폴더에서 폴더로 이동 시
			ezCircularService.updateFolderId(folderId, circularIdList, memberId, tenantId);
		}
		
		if (oldFolderId != null && folderId == "") { // 폴더에서 확인완료 회람판으로 이동 시
			updateStatus = "1";
			ezCircularService.moveCircular(folderId, circularIdList, memberId, updateStatus, tenantId);
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
        
        int folderId = Integer.parseInt(req.getParameter("folderId"));
    	
    	CircularConfigVO config = ezCircularService.getCircularList_Config(userInfo.getId(), userInfo.getTenantId());
		
		int personalCount = config.getListCnt();
		startRow = (personalCount * (Integer.parseInt(pageNum) - 1)) + 1;
        endRow = (personalCount * Integer.parseInt(pageNum));
		
        int totalCount = ezCircularService.getFolderCircularListCount(folderId, userInfo.getId(), userInfo.getTenantId());
        
		List<CircularListVO> list = ezCircularService.getFolderCircularList(folderId, userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
		List<HashMap<String, Object>> list2 = ezCircularService.getFolderCircularMapList(folderId, userInfo.getId(), startRow, endRow, userInfo.getTenantId());
		
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
    				fieldValue = fieldValue.equals("0") ? "0" : "1";
    			} else if (fieldName.equals("HASFILE")) {
    				fieldValue = fieldValue.equals("0") ? "0" : "1";
    			} else if (fieldName.equals("STATUS")) {
    				if (fieldValue.equals("0")) {
    					fieldValue = "진행중";
    				} else if (fieldValue.equals("1")) {
    					fieldValue = "종료";
    				} else if (fieldValue.equals("2")){
    					fieldValue = "임시";
    				}
    			} else if (fieldName.equals("CONFIRMSTATUS")) {
    				int firstValue = ezCircularService.getConfirmStatusFirst(list.get(j).getCircularID(), userInfo.getTenantId());
    				int secondValue = ezCircularService.getConfirmStatusSecond(list.get(j).getCircularID(), userInfo.getTenantId());
    				
    				fieldValue = firstValue + "/" + secondValue;
    			} else if (fieldName.equals("REGDATE")) {
    				fieldValue = commonUtil.getDateStringInUTC(fieldValue, userInfo.getOffset(), false); 
    			} else if (fieldName.equals("CONFIRMDATE")) {
    				fieldValue = commonUtil.getDateStringInUTC(fieldValue, userInfo.getOffset(), false);
    			}
    			
    			resultXML.append("<MEMBERID>" + list.get(j).getMemberID() + "</MEMBERID>");
    			resultXML.append("<CIRCULARID>" + list.get(j).getCircularID() + "</CIRCULARID>");
    			
    			resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
    			
    			if (i == 0) {
    				resultXML.append("<TITLE>" + list.get(j).getTitle() + "</TITLE>");
    				resultXML.append("<MEMBERID>" + list.get(j).getMemberID() + "</MEMBERID>");
    			}
    			resultXML.append("</CELL>");
    		}
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
    	
    	List<CircularListVO> userList = ezCircularService.getCircularUserList(Integer.parseInt(circularCommentVO.getCircularID()), userInfo.getTenantId());
    	List<CircularCommentVO> commentList = ezCircularService.getCircularComment(circularCommentVO, userInfo.getOffset(), userInfo.getTenantId());
    	
    	logger.debug("getCircularComment ended.");
    	
    	model.addAttribute("userList", userList);
    	model.addAttribute("commentList", commentList);
    	model.addAttribute("userInfo", userInfo);
    	
    	return "json";
    }
    
    /**
     * comment 저장
     * 회람판ID, 회람자ID, 댓글작성자ID, 글내용
     * 저장할때 
     */
    @RequestMapping(value = "/ezCircular/editCircularComment.do")
    public String editCircularComment(@CookieValue("loginCookie") String loginCookie, CircularCommentVO circularCommentVO, HttpServletRequest request) throws Exception {
    	logger.debug("editCircularComment started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	
    	ezCircularService.editCircularComment(circularCommentVO, userInfo);
    	
    	logger.debug("editCircularComment ended.");
    	
    	return "json";
    }
}
