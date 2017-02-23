package egovframework.ezEKP.ezCommunity.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.web.EzCommonController;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemReadVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardPropertyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCCategoryVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubGuestVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubUserVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollManagerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollQuestionVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollResponseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityOneLineReplyVO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 커뮤니티
 * @author 오픈솔루션팀 이효진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.19    이효진    신규작성
 *
 * @see
 */

@Controller
public class EzCommunityController extends EgovFileMngUtil{
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private Properties globals;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="EzCommunityService")
	private EzCommunityService ezCommunityService;
	
	@Resource(name="EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzCommonController ezCommonController;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCommunityController.class);
	
	/**
	 * 커뮤니티 메인화면 호출함수
	 */
	@RequestMapping(value="/ezCommunity/communityMain.do")
	public String  main() {
		return "ezCommunity/communityMain";
	}
	
	/**
	 * 왼쪽 메뉴화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/communityLeftCommunity.do")
	public String communityLeftCommunity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("communityLeftCommunity started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = "", userLevel = "";
		int newMemberConfirmtype = 0;
        boolean checkSysop = false;
        String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
        if (request.getParameter("communityCD") != null) {
            code = request.getParameter("communityCD");
        }
        if (request.getParameter("userLevel") != null) {
            userLevel = request.getParameter("userLevel");
        }
        
        if (code.equals("")) {
        	String vPermit = ezCommunityService.leftCommunityGet1(code, userInfo.getId(), userInfo.getTenantId());
        	
        	if (vPermit==null) {
        		userLevel = "0";
        	} else {
        		userLevel = vPermit;
        	}
        	
        	String clubConfirmType = ezCommunityService.leftCommunityGet2(code, userInfo.getTenantId());
        	
        	if (clubConfirmType != null) {
        		newMemberConfirmtype = Integer.parseInt(clubConfirmType);
        	}
        	
        	CommunityClubVO club = ezCommunityService.leftCommunityGet4(code, userInfo.getTenantId());
        	
        	if(club != null) {
        		if (userInfo.getId().equals(club.getC_SysopID().trim())) {
            		checkSysop = true;
            	}
        	}
        }
		
		model.addAttribute("userLevel",userLevel);
		model.addAttribute("newmemberConfirmType",newMemberConfirmtype);
		model.addAttribute("checkSysop",checkSysop);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("code", code);
		model.addAttribute("lang",userInfo.getLang());
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		logger.debug("communityLeftCommunity ended.");
		
		return "ezCommunity/communityLeftCommunity";
	}

	/**
	 * 커뮤니티목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getLeftCommunity.do")
	public String getLeftCommunity(@CookieValue("loginCookie")String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		List<CommunityClubVO> list = ezCommunityService.getLeftCommunity(userInfo);
		
		model.addAttribute("list", list);
		
        return "json"; 
	}
	
	/**
	 * 알림마당목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getLeftBoardList.do")
	public String getLeftBoardList(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<CommunityCBoardVO> list = ezCommunityService.getLeftBoardList(userInfo.getTenantId());
		
		model.addAttribute("list", list);
		
		return "json";
	}
	
	/**
	 * 커뮤니티 이미지 출력함수(ezCommon_Interface)
	 */
	@RequestMapping(value="/ezCommunity/getCommunityThumInfo.do")
	public void getCommunityThumInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
        String pType = request.getParameter("type");
		String pFileName = request.getParameter("fileName");
		String pFilePath = "", pBoardID = "";
		
		if (request.getParameter("boardID") != null) {
			pBoardID = request.getParameter("boardID");
		}

		if (pType.toUpperCase().equals("COMMUNITYLOGO")) {
			pFilePath = ezCommunityService.getCommunityThumInfo(pBoardID, pFileName, "LOGO", userInfo.getTenantId());
			
	        if (pFilePath != null && !pFilePath.equals("")) {
	            ezCommonService.responseAttach(pFilePath, pFileName, true, request, response);
	        }
		}
		
		if (pType.toUpperCase().equals("COMMUNITYTHUM")) {
			pFilePath = ezCommunityService.getCommunityThumInfo(pBoardID, pFileName, "COMMUNITYTHUM", userInfo.getTenantId());
			
	        if (pFilePath != null && !pFilePath.equals("")) {
	            ezCommonService.responseAttach(pFilePath, pFileName, true, request, response);
	        }
		}
	}

	/**
	 * 커뮤니티 만들기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/commMake.do")
	public String commMake(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		String langPrimary="", langSecondary="", userInfoDisplayName = "";
		
		langPrimary = ezCommonService.getTenantConfig("LangPrimary"+userInfo.getLang(), userInfo.getTenantId());
		langSecondary = ezCommonService.getTenantConfig("LangSecondary"+userInfo.getLang(), userInfo.getTenantId());
		
		if (userInfo.getLang().equals("2")) {
			userInfoDisplayName = userInfo.getDisplayName2();
		} else {
			userInfoDisplayName = userInfo.getDisplayName1();
		}

		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("userInfoDisplayName", userInfoDisplayName);
//		model.addAttribute("flag", flag);		
		model.addAttribute("idSpanValue", ezCommunityService.getCategory("", "", "", userInfo));
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		return "ezCommunity/communityCommMake";
	}
	
	/**
	 * 커뮤니티만들기 싱청 함수
	 */
	@RequestMapping(value = "/ezCommunity/commMakeOk.do", method = RequestMethod.POST)
	@ResponseBody
	public void commMakeOk(@CookieValue("loginCookie")String loginCookie, CommunityClubVO clubVO, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		ezCommunityService.commMakeOk(userInfo, clubVO, request, response);
	}
	
	/**
	 * 커뮤니티만들기 IE9 로고 업로드
	 */
	@RequestMapping(value = "/ezCommunity/commMakeUpload.do")
	public String commMakeUpload(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) {
		logger.debug("commMakeUpload started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String logoPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.LOGO", userInfo.getTenantId()) + commonUtil.separator;
		String mode = request.getParameter("mode");
		String fileName = request.getParameter("fileName");
		String fileData = request.getParameter("fileData");
		boolean result = false;
		
		try {
			ezCommunityService.commMakeUpload(mode, fileName, fileData, logoPath, userInfo.getTenantId());
			
			result = true;
		} catch (Exception e) {
			result = false;
		}
		
		logger.debug("commMakeUpload ended.");
		
		model.addAttribute("result", result);
		
		return "json";
	}
	
	/**
	 * 게시판Tree 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getSubBoards.do")
	public String getSubBoards(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("getSubBoards started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pClubID = "", pRootBoardID = "", pSubFlag = "0", pExcludeBoardID = " ";
		int pSelectBy = 0, pMode = 0;
		
		pClubID = request.getParameter("classID");
		pRootBoardID = request.getParameter("rootBoardID");
		
		if (request.getParameter("subFlag") != null) {
			pSubFlag = request.getParameter("subFlag");
		}
		
		if (request.getParameter("excludeBoardID") != null) {
			pExcludeBoardID = request.getParameter("excludeBoardID");
		}
		if ( request.getParameter("selectFlag") != null) {
			pSelectBy = Integer.parseInt(request.getParameter("selectFlag"));
		}
		
		String boardGroupAdminFG = ezCommunityService.checkIfBoardGroupAdmin(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId());

//		if (boardGroupAdminFG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
		if (boardGroupAdminFG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1) {
			pMode = 0;
		} else {
			pMode = 1;
		}
		
		String result = ezCommunityService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, pClubID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		model.addAttribute("result", result);
		
		logger.debug(result);
		logger.debug("getSubBoards ended.");
		
		return "json";
	}
	
	/**
	 * 관리자권한 확인 함수
	 */
	@RequestMapping(value = "/ezCommunity/goAdminOk.do")
	@ResponseBody
	public String goAdminOk(@RequestBody String data, @CookieValue("loginCookie") String loginCookie, CommunityClubVO communityClubVO) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		StringBuilder resultXML = new StringBuilder();
		
		String masterXML = ezCommunityService.goAdminOkGet2(data, userInfo);
		
		resultXML.append("<COMMUNITY>");
		resultXML.append("<ASP></ASP>");
		resultXML.append("<SITE><VALUE></VALUE></SITE>");
		resultXML.append(masterXML);
		resultXML.append("</COMMUNITY>");
		
		return resultXML.toString();
	}
	
	/**
	 * 커뮤니티 권한 및 승인여부 확인 함수
	 */
	@RequestMapping(value = "/ezCommunity/checkCommHome.do")
	public String checkCommHome(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("checkCommHome started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("communityCD");
		String userLevel = "";
		
		if (!code.equals("")) {
			String vPermit = ezCommunityService.leftCommunityGet1(code, userInfo.getId(), userInfo.getTenantId());
        	
        	if (vPermit == null) {
        		userLevel = "0";
        	} else {
        		userLevel = vPermit;
        	}
		}
		
		model.addAttribute("code", code);
		model.addAttribute("userLevel", userLevel);
		
		logger.debug("userLevel = " + userLevel);
		logger.debug("checkCommHome ended.");
		
		return "ezCommunity/communityCheckCommHome";
	}
	
	/**
	 * 커뮤니티팝업화면 출력 함수
	 */
	@RequestMapping(value = "/ezCommunity/commHome/popupCommHome.do")
	public String popupCommHome(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("popupCommHome started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean joinFlag = false, checkSysop = false;
		int newMemberConfirmType = 0;
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		String code = request.getParameter("code");
		String userLevel = request.getParameter("userLevel");
		
		// 20100119 보안처리 관련 추가작업(권한체크)
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response, userInfo)) {
			return "cmm/error/egovError";
		}
		
		String strVisit = ezCommunityService.commHomeGet1(userInfo.getId(), code, userInfo.getTenantId());
		
		if (strVisit == null || !strVisit.substring(0, 10).equals(commonUtil.getTodayUTCTime(""))) {
			ezCommunityService.updateLastDate(commonUtil.getTodayUTCTime(""), code, userInfo.getId(), userInfo.getTenantId());
		}
		
		String copType = ezCommunityService.commHomeGet4(code, userInfo.getTenantId());
		
		if (copType == null) {
			copType = "type1";
		}
		
		//사용하는곳이 없다
//		int memberCount = commHomeGet2(code);
		
		String boardGroupAdminFG = ezCommunityService.checkIfBoardGroupAdmin("top", userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId());
		int mode = 0;
		
//		if (boardGroupAdminFG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 ||  userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 ||  userInfo.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
		if (boardGroupAdminFG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 ||  userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1) {
			mode = 0;
		} else {
			mode = 1;
		}
		
		logger.debug("mode : " + mode);
		
		String retXML = ezCommunityService.getBoardTree("top", userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), mode, 0, 0, " ", code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		if (retXML.substring(0, 5).toUpperCase().equals("ERROR")) {
			retXML = "<RESULT>ERROR</RESULT>";
		}
		
		String permit = ezCommunityService.leftCommunityGet1(code, userInfo.getId(), userInfo.getTenantId());

		if (permit != null) {
			userLevel = permit;
			joinFlag = true;
		} else {
			userLevel = "0";
		}
		
		String confirmType = ezCommunityService.leftCommunityGet2(code, userInfo.getTenantId());
		
		if (confirmType != null) {
			newMemberConfirmType = Integer.parseInt(confirmType);
		}
		
		CommunityClubVO clubVO = ezCommunityService.leftCommunityGet4(code, userInfo.getTenantId());
		
		if (clubVO.getC_SysopID().trim().equals(userInfo.getId()) && !checkSysop) {
			checkSysop = true;
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("code", code);
		model.addAttribute("copType", copType);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("joinFlag", joinFlag);
		model.addAttribute("newMemberConfirmType", newMemberConfirmType);
		model.addAttribute("checkSysop", checkSysop);
		model.addAttribute("retXML", retXML);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		logger.debug("popupCommHome ended.");
		
		return "ezCommunity/communityPopupCommHome";
	}
	
	/**
	 * 커뮤니티 메인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/commHome/commHomeInfo.do", method = RequestMethod.POST, produces = "text/xml; charset=UTF-8")
	@ResponseBody
	public String commHomeInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		return ezCommunityService.commHomeInfo(userInfo, code, request);
	}
	
	/**
	 * 커뮤니티 메인 오른쪽화면 게시판 목록 조회 함수
	 */
	@RequestMapping(value = "/ezCommunity/commHome/commHomeBoardInfo.do")
	public String commHomeBoardInfo(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		
		logger.debug("commHomeBoardInfo started. code : " + code);
		
		List<CommunityBoardInfoVO> list = ezCommunityService.commHomeBoardInfo(code, userInfo.getTenantId());
		
		model.addAttribute("boardInfoList", list);
		
		logger.debug("commHomeBoardInfo ended.");
		
		return "json";
	}
	
	/** 
	 * 커뮤니티 메인 오른쪽화면 게시판 목록 조회 함수
	 */
	@RequestMapping(value = "/ezCommunity/commHome/commHomeBoardItemList.do")
	public String commHomeBoardItemList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		
		List<CommunityBoardItemVO> list = ezCommunityService.commHomeBoardItemList(boardID, userInfo.getTenantId());
		
		model.addAttribute("boardItemList", list);
		
		return "json";
	}
	/**
	 * 커뮤니티 게시판 목록화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemList.do")
	public String boardItemList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String boardID = request.getParameter("boardID");
		String boardName = request.getParameter("boardName");
		String userLevel = "";
		
		logger.debug("boarditemList started.");
		logger.debug("code : " + code + ", boardID : " + boardID + ", boardName : " + boardName);
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response, userInfo)) {
			return "cmm/error/egovError";
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		CommunityBoardListVO boardList = ezCommunityService.boardItemListGet1(boardID, userInfo.getId(), userInfo.getTenantId());
		ezCommunityService.boardItemList(userInfo, model, request, response, boardInfo, boardList);
		
		if (!boardInfo.getListView_FG().equals("true")) {
			return "cmm/error/egovError";
		}
		
		if (boardList == null) {
			userLevel = "0";
		} else {
			if (boardList.getPermit().equals("0")) {
				userLevel = "9";
			} else {
				userLevel = boardList.getPermit();
			}
		}
		
		model.addAttribute("code", code);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pBoardName", boardName);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		
		logger.debug("boarditemList ended.");
		
		return "ezCommunity/communityBoardItemList";
	}
	
	/**
	 * 커뮤니티 검색화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/searchBoardItem.do")
	public String searchBoardItem(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String orgBoardParameters = request.getParameter("orgBoardParameters");
		String code = request.getParameter("code");
		
		int pPage = 1, totalPage = 1, totalCount = 0;
		String title = "", writerName = "", abstracts = "", searchStart = "", searchEnd = "", pSortBy = "";
		String strXML="";
		
		if (request.getParameter("page") != null) {
			pPage = Integer.parseInt(request.getParameter("page"));
		}
		if (request.getParameter("title") != null) {
			title = request.getParameter("title");
		}
		if (request.getParameter("writerName") != null) {
			writerName = request.getParameter("writerName");
		}
		if (request.getParameter("abstract") != null) {
			abstracts = request.getParameter("abstract");
		}
		if (request.getParameter("searchStart") != null) {
			searchStart = request.getParameter("searchStart");
		}
		if (request.getParameter("searchEnd") != null) {
			searchEnd = request.getParameter("searchEnd");
		}
		if (request.getParameter("pSortBy") != null) {
			pSortBy = request.getParameter("pSortBy");
		}

		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		// 20100119 보안처리 관련 추가작업(권한체크)
        if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, boardID, userInfo.getRollInfo(), 0, response, userInfo)) {
        	return "cmm/error/egovError";
        }
        
        int pStartRow = (pPage - 1) * boardInfo.getSs_SearchBoard_MaxRows() + 1;
        int pEndRow = pPage * boardInfo.getSs_SearchBoard_MaxRows();
        String startDateTime = "";
        String endDateTime = "";
        
        if (!searchStart.equals("")) {
        	startDateTime = searchStart + " 00:00:00";
        	endDateTime = searchEnd + " 23:59:59";
        }

        if (!title.equals("") || !writerName.equals("") || !abstracts.equals("") || !searchStart.equals("")) {
        	totalCount = ezCommunityService.searchItemCount(userInfo, boardID, title, writerName, abstracts, startDateTime, endDateTime);
            strXML = ezCommunityService.searchItemXML(userInfo, boardID, title, writerName, abstracts, startDateTime, endDateTime, pStartRow, pEndRow);
            
            if (totalCount > 0) {
				if (totalCount > boardInfo.getSs_SearchBoard_MaxRows()) {
					if(totalCount % boardInfo.getSs_SearchBoard_MaxRows() > 0) {
						totalPage = totalCount / boardInfo.getSs_SearchBoard_MaxRows() + 1;
					} else {
						totalPage = totalCount / boardInfo.getSs_SearchBoard_MaxRows();
					}
				} else {
					totalPage = 1;
				}
			} else {
				totalPage = 1;
			}
        }

        model.addAttribute("userInfo", userInfo);
        model.addAttribute("boardInfo", boardInfo);
        model.addAttribute("orgBoardParameters", orgBoardParameters);
        model.addAttribute("startDateTime", startDateTime);
        model.addAttribute("endDateTime", endDateTime);
        model.addAttribute("pSortBy", pSortBy);
        model.addAttribute("strXML", strXML);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("boardName", boardInfo.getBoardName());
        model.addAttribute("title", title);
        model.addAttribute("writerName", writerName);
        model.addAttribute("abstract", abstracts);
        model.addAttribute("searchStart", searchStart);
        model.addAttribute("searchEnd", searchEnd);
        model.addAttribute("pPage", pPage);
        
		return "ezCommunity/communitySearchBoardItem";
	}
	
	/**
	 * 커뮤니티 검색화면 인쇄화면 호출 함수
	 */
	@RequestMapping(value = "/ezCommunity/searchBoardItemPrint.do")
	public String searchBoardItemPrint(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("searchBoardItemPrint started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String title = request.getParameter("title");
		String writerName = request.getParameter("writerName");
		String strAbstract = request.getParameter("strAbstract");
		String searchStart = request.getParameter("searchStart");
		String searchEnd = request.getParameter("searchEnd");
		String searchConfig = "";
		
		logger.debug("title : " + title + ", writerName : " + writerName + ", strAbstract : " + strAbstract + ", searchStart : " + searchStart + ", searchEnd : " + searchEnd);
		
		if (!title.equals("")) {
			searchConfig += egovMessageSource.getMessage("ezCommunity.t1467", userInfo.getLocale()) + "'" + title + "' " + egovMessageSource.getMessage("ezCommunity.t1468", userInfo.getLocale());
		}
		
		if (!writerName.equals("")) {
			searchConfig += egovMessageSource.getMessage("ezCommunity.t1469", userInfo.getLocale()) + "'" + writerName + "' " + egovMessageSource.getMessage("ezCommunity.t1468", userInfo.getLocale());
		}

		if (!strAbstract.equals("")) {
			searchConfig += egovMessageSource.getMessage("ezCommunity.t1470", userInfo.getLocale()) + "'" + strAbstract + "' " + egovMessageSource.getMessage("ezCommunity.t1468", userInfo.getLocale());
		}
		
		if (!searchStart.equals("")) {
			searchConfig += egovMessageSource.getMessage("ezCommunity.t1471", userInfo.getLocale()) + "'" + searchStart.substring(0, 10) + "' " + egovMessageSource.getMessage("ezCommunity.t1472", userInfo.getLocale());
		}
		
		if (!searchEnd.equals("")) {
			searchConfig += egovMessageSource.getMessage("ezCommunity.t1471", userInfo.getLocale()) + "'" + searchEnd.substring(0, 10) + "' " + egovMessageSource.getMessage("ezCommunity.t1473", userInfo.getLocale());
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);

        String strXML = "";
		
        if (!title.equals("") || !writerName.equals("") || !strAbstract.equals("") || !searchStart.equals("")) {
            strXML = ezCommunityService.searchItemXML(userInfo, boardID, title, writerName, strAbstract, searchStart, searchEnd, 1, 1000);
        }
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("strAbstract", strAbstract);
		model.addAttribute("strNow", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		model.addAttribute("searchConfig", searchConfig);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("strXML", strXML);
		
		logger.debug("searchBoardItemPrint ended");
		
		return "ezCommunity/communitySearchBoardItemPrint";
	}
	/**
	 * 게시물 읽음표시 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/setRead.do", method = RequestMethod.POST)
	@ResponseBody
	public String setRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String itemIDList = request.getParameter("itemIDList");

		return ezCommunityService.setAsRead(userInfo, boardID, itemIDList);
	}
	
	/**
	 * 게시물 답변 여부 체크 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/checkIfHasReply.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkIfHasReply (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemList = request.getParameter("itemList");
		
		return ezCommunityService.checkIfHasReply(itemList, userInfo.getTenantId());
	}
	
	/**
	 * 게시물 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/deleteItem.do", method = RequestMethod.POST)
	@ResponseBody
	public void deleteItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemList = request.getParameter("itemList");
		
		ezCommunityService.deleteItem(itemList, userInfo.getTenantId());
	}
	
	/**
	 * 게시물 등록/수정/답변 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/newBoardItem.do")
	public String newBoardItem(@CookieValue("loginCookie") String loginCookie, Model model, CommunityBoardItemVO item, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pBoardID = request.getParameter("boardID");
		String pMode = request.getParameter("mode");
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		String pItemID = "", pReservedItem = "", pUrl = "", pDocID = "", expireDays = "";
		String hasAttach = "NO";
		String uploadFilePath = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		if (request.getParameter("itemID") != null) {
			pItemID = request.getParameter("itemID");
		}
		if (request.getParameter("reservedItem") != null) {
			pReservedItem = request.getParameter("reservedItem");
		}
		if (request.getParameter("url") != null) {
			pUrl = request.getParameter("url");
		}
		if (request.getParameter("docID") != null) {
			pDocID = request.getParameter("docID");
		}
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), "", pBoardID, userInfo.getRollInfo(), 1, response, userInfo)) {
			return "cmm/error/egovError";
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID);
		
		ezCommunityService.newBoardItem(item, boardInfo, userInfo, pItemID, pBoardID, pUrl, pMode, expireDays, hasAttach, model);
		
		model.addAttribute("editor", ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId()));
		model.addAttribute("pUploadFilePath", uploadFilePath);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pReservedItem", pReservedItem);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("pDocID", pDocID);
		model.addAttribute("strNow", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		model.addAttribute("pUrl", pUrl);
		model.addAttribute("pMode", pMode);
		model.addAttribute("hasAttach", hasAttach);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		return "ezCommunity/communityNewBoardItem";
	}
	
	/**
	 * 게시판 쓰기/수정/답변 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/saveItem.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveItem (@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlStr, CommunityBoardItemVO item, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlData = commonUtil.convertStringToDocument(xmlStr);
		String pMode = request.getParameter("mode");

		String ret = ezCommunityService.newItem(xmlData, pMode, commonUtil.getRealPath(request), userInfo);
		
		return ret;
	}
	
	/**
	 * 게시판 파일업로드 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/upload.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String upload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		return ezCommunityService.upload(request, response, userInfo);
	}
	
	/**
	 * 게시판 파일업로드(IE9) 실행함수 
	 */
	@RequestMapping(value = "/ezCommunity/itemAttachFile.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String itemAttachFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String returnVal = "";
		String guid = "";
		String fileTitle = "";
		String ext = "";
		String prefix = "";
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		
		if (request.getParameter("guid") != null) {
			guid = request.getParameter("guid");
		}
		if (request.getParameter("name") != null) {
			fileTitle = request.getParameter("name");
		}
		if (request.getParameter("ext") != null) {
			ext = request.getParameter("ext");
		}
		if (request.getParameter("prefix") != null) {
			prefix = request.getParameter("prefix");
		}
		
		String boardID = prefix;
		String uploadSN = "{" + guid + "}";
		String fileName = fileTitle + "." + ext;
		
		if (request.getParameter("filename") != null) {
			fileName = request.getParameter("filename");
		}
		
		fileName = fileName.replace("+", "%2b");
        fileName = fileName.replace(";", "%3b");
        fileName = fileName.replace("~", "%7e");
        fileName = fileName.replace("=", "%3d");
        
        String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator;
        
        if (useExtension.toLowerCase().indexOf(fileName.substring(fileName.lastIndexOf(".") + 1).toString().toLowerCase()) == -1 && !useExtension.equals("*")) {
        	returnVal = "denied";
        } else {
        	if (!new File(dirPath + "tempUploadFile").exists()) {
        		new File(dirPath + "tempUploadFile").mkdirs();
        	}
        	
        	if (!new File(dirPath + boardID).exists()) {
        		new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
        		new File(dirPath + boardID + commonUtil.separator + "doc").mkdirs();
        	} else if (!new File(dirPath + boardID + commonUtil.separator + "uploadFile").exists()) {
        		new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
        	}
        	
        	String attachPath = dirPath + "tempUploadFile" + commonUtil.separator + uploadSN + "_" + fileName;
        	
            InputStream stream = null;
            OutputStream bos = null;         
            
            try {
                stream = request.getInputStream();
                bos = new FileOutputStream(attachPath);
//                long fileSize = 0;
                int bytesRead = 0;
                byte[] buffer = new byte[BUFF_SIZE];
        
                while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
                    bos.write(buffer, 0, bytesRead);
//                    fileSize += bytesRead;
                }
            } catch (FileNotFoundException fnfe) {
    			logger.debug("fnfe: {}", fnfe);
    		} catch (IOException ioe) {
    			logger.debug("ioe: {}", ioe);
    		} catch (Exception e) {
    			logger.debug("e: {}", e);
    		} finally {
    		    if (bos != null) {
    				try {
    				    bos.close();
    				} catch (Exception ignore) {
    					logger.debug("IGNORED: {}", ignore.getMessage());
    				}
    		    }
    		    if (stream != null) {
    				try {
    				    stream.close();
    				} catch (Exception ignore) {
    					logger.debug("IGNORED: {}", ignore.getMessage());
    				}
    		    }
    		}
            returnVal = "OK_" + uploadSN + "_" + fileName;
        }
        
		return returnVal;
	}
	
	/**
	 * 포토게시판 파일업로드(IE9) 실행함수 
	 */
	@RequestMapping(value = "/ezCommunity/itemAttachFilePhoto.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String itemAttachFilePhoto(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String returnVal = "";
		String guid = "";
		String ext = "";
		String prefix = "";
		
		if (request.getParameter("guid") != null) {
			guid = request.getParameter("guid");
		}
		if (request.getParameter("ext") != null) {
			ext = request.getParameter("ext");
		}
		if (request.getParameter("prefix") != null) {
			prefix = request.getParameter("prefix");
		}
		
		String boardID = prefix;
		String uploadSN = "{" + guid + "}";
		String fileName = "." + ext;
		
		fileName = fileName.replace("+", "%2b");
		fileName = fileName.replace(";", "%3b");
		fileName = fileName.replace("~", "%7e");
		fileName = fileName.replace("=", "%3d");
		
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		if (!new File(dirPath + "tempUploadFile").exists()) {
			new File(dirPath + "tempUploadFile").mkdirs();
		}
		
		if (!new File(dirPath + boardID).exists()) {
			new File(dirPath + boardID).mkdir();
			new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
			new File(dirPath + boardID + commonUtil.separator + "doc").mkdirs();
		} else if (!new File(dirPath + boardID + commonUtil.separator + "uploadFile").exists()) {
			new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
		}
		
		String attachPath = dirPath + "tempUploadFile" + commonUtil.separator + uploadSN + fileName;
		String mapPath = dirPath + "tempUploadFile" + commonUtil.separator;
		
		InputStream stream = null;
		OutputStream bos = null;         
		
		try {
			stream = request.getInputStream();
			bos = new FileOutputStream(attachPath);
//			long fileSize = 0;
			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];
			
			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
//				fileSize += bytesRead;
			}
		} catch (FileNotFoundException fnfe) {
			logger.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			logger.debug("ioe: {}", ioe);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		} finally {
		    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
		
		File imageFile = new File(attachPath);	
		
		int nImgWidth = 0;
		int nImgHeight = 0;
		
		if (imageFile.exists()) {			
			BufferedImage bi = ImageIO.read(imageFile);			    
			nImgWidth = bi.getWidth();
			nImgHeight = bi.getHeight();
			int nWidth = 0, nHeight = 0;
			
            if (nImgWidth > nImgHeight) {
                nWidth = 200;
                nHeight = (bi.getHeight() * nWidth) / bi.getWidth();
            } else {
                nHeight = 200;
                nWidth = (bi.getWidth() * nHeight) / bi.getHeight();
            }
            
            BufferedImage bufferedImage = new BufferedImage(nWidth, nHeight, bi.getType());
            bufferedImage.createGraphics().drawImage(bi, 0, 0, nWidth, nHeight, null);
            ImageIO.write(bufferedImage, ext, new File(mapPath + "s_" + uploadSN + fileName));
		}
		
		returnVal = "OK_" + uploadSN + fileName;
		
		return returnVal;
	}
	
	/**
	 * 게시판 읽기 화면호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemView.do")
	public String boardItemView(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("boardItemView started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pReservedItem = "";
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String oneLineReplyFlag = ezCommonService.getTenantConfig("ONELINE_REPLY_ENABLE", userInfo.getTenantId());
        String adjacentItemsEnableFlag = ezCommonService.getTenantConfig("ADJACENT_ITEMS_ENABLE", userInfo.getTenantId());
        String publicModulus = egovFileScrty.getPbm();
        String publicExponent = "10001";
        
		String pItemID = request.getParameter("itemID");
		String pBoardID = request.getParameter("boardID");
		String code = request.getParameter("code");
		String showAdjacent = request.getParameter("showAdjacent");
		
		if (showAdjacent == null) {
			showAdjacent = ezCommonService.getTenantConfig("ADJACENT_ITEMS_ENABLE", userInfo.getTenantId());
		}
		if (request.getParameter("pReservedItem") != null) {
			pReservedItem = request.getParameter("pReservedItem");
		}
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), "", pBoardID, userInfo.getRollInfo(), 1, response, userInfo)) {
			return "cmm/error/egovError";
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID);
		CommunityBoardItemVO item = ezCommunityService.getItemXML(pBoardID, pItemID, userInfo);
		ezCommunityService.setAsRead(userInfo, pBoardID, pItemID);		
		ezCommunityService.boardItemView(userInfo, boardInfo, item, pItemID, pBoardID, showAdjacent, adjacentItemsEnableFlag, model);

//		item.setWriteDate(commonUtil.getDateStringInUTC(item.getWriteDate(), userInfo.getOffset(), false));
		
		model.addAttribute("itemID", pItemID);
		model.addAttribute("boardID", pBoardID);
		model.addAttribute("code", code);
		model.addAttribute("pReservedItem", pReservedItem);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("oneLineReplyFlag", oneLineReplyFlag);
		model.addAttribute("adjacentItemsEnableFlag", adjacentItemsEnableFlag);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("strUserLang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("boardInfo", boardInfo);
//		model.addAttribute("ch_CommunityAdmin", userInfo.getRollInfo().indexOf("t=1"));
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		
		logger.debug("boardItemView ended.");
		
		return "ezCommunity/communityBoardItemView";
	}
	
	/**
	 * 암호확인화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/checkPassword.do")
	public String checkPassword(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("checkPassword started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		String pItemID = request.getParameter("itemID");
		
		String password = ezCommunityService.checkPassword(pItemID, userInfo.getTenantId()).trim();

		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("itemID", pItemID);
		model.addAttribute("password", password);
		
		logger.debug("checkPassword ended.");
		
		return "ezCommunity/communityCheckPassword";
	}
	
	/**
	 * 암호확인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/confirmPassword.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String confirmPassword(HttpServletRequest request) throws Exception {
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	
		String newPassword = request.getParameter("newPassword");
		String oldPassword = request.getParameter("oldPassword");
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		String rpwd = EgovFileScrty.decryptRsa(pk, newPassword);
		
		if (EgovFileScrty.encryptPassword(rpwd, "unknown").equals(oldPassword)) {
			return "OK";
		} else {
			return "FALSE";
		}
	}
	
	/**
	 * 한줄답변 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/readOneLineReply.do", method = RequestMethod.POST)
	public String readOneLineReply(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pBoardID = request.getParameter("boardID");
		String pItemID = request.getParameter("itemID");
		
		List<CommunityOneLineReplyVO> oneLineReplyList = ezCommunityService.readOneLineReply(commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), pBoardID, pItemID, userInfo.getTenantId(), userInfo.getOffset());
		
		model.addAttribute("oneLineReplyList", oneLineReplyList);
		
		return "json";
	}
	
	/**
	 * 한줄답변 등록 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/saveOneLineReply.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void saveOneLineReply(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDoc = commonUtil.convertStringToDocument(request.getParameter("strXML"));
		
		ezCommunityService.saveOneLineReply(xmlDoc, userInfo);
	}
	
	/**
	 * 한줄답변 삭제시 작성자본인확인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/checkOneLineOwner.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String checkOneLineOwner(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pReplyID = request.getParameter("replyID");
		
		return ezCommunityService.checkOneLineOwner(pReplyID, userInfo.getId(), userInfo.getTenantId());
	}
	
	/**
	 * 한줄답변 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/deleteOneLineReply.do", method = RequestMethod.POST)
	public void deleteOneLineReply(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pReplyID = request.getParameter("replyID");
		String gubun = request.getParameter("gubun");
		
		ezCommunityService.deleteOneLineReply(userInfo.getId(), pReplyID, gubun, userInfo.getTenantId());
	}
	
	/**
	 * 익명게시판일때 checkReplyPassword
	 */
	@RequestMapping(value = "/ezCommunity/checkReplyPassword.do")
	public String checkReplyPassword(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		String pItemID = request.getParameter("itemID");
		String pReplyID = request.getParameter("replyID");
		
		String password = ezCommunityService.checkReplyPassword(pItemID, pReplyID, userInfo.getTenantId()).trim();
		
		model.addAttribute("pReplyID", pReplyID);
		model.addAttribute("password", password);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		
		return "ezCommunity/communityCheckReplyPassword";
	}
	
	/**
	 * 게시판 첨부파일 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getItemAttachments.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getItemAttachments(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemID = request.getParameter("itemID");
		
		String strXML = ezCommunityService.getItemAttachmentXML(itemID, userInfo.getTenantId());
		
		if (strXML.substring(0, 5).equals("ERROR")) {
			strXML = "<RESULT>" + strXML + "</RESULT>";
		}
		
		return strXML;
	}
	
	/**
	 * 게시판 예약게시목록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardReservedItemList.do")
	public String boardReservedItemList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pSortBy = "";
		int pPage = 1, totalPage = 1;
		
		String pOrgBoardParameters = request.getParameter("orgBoardParameters");
		
		if (request.getParameter("page") != null) {
			pPage = Integer.parseInt(request.getParameter("page"));
		}
		if (request.getParameter("sortBy") != null) {
			pSortBy = request.getParameter("sortBy");
		}
		
		String boardName = egovMessageSource.getMessage("ezCommunity.t91", userInfo.getLocale());
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, "");
		
		boardInfo.setSs_Board_MaxRows(10);
		
		int pStartRow =  (pPage - 1) * boardInfo.getSs_Board_MaxRows() + 1;
		int pEndRow = pPage * boardInfo.getSs_Board_MaxRows();

		String strXML = ezCommunityService.getReservedItemListXML(userInfo.getId(), pStartRow, pEndRow, pSortBy, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		int totalCount = ezCommunityService.getReservedItemListCount(userInfo.getId(), userInfo.getTenantId());
		
		if (totalCount > 0) {
			if (totalCount > boardInfo.getSs_Board_MaxRows()) {
				if(totalCount % boardInfo.getSs_Board_MaxRows() > 0) {
					totalPage = totalCount / boardInfo.getSs_Board_MaxRows() + 1;
				} else {
					totalPage = totalCount / boardInfo.getSs_Board_MaxRows();
				}
			} else {
				totalPage = 1;
			}
		} else {
			totalPage = 1;
		}
		
		model.addAttribute("pOrgBoardParameters", pOrgBoardParameters);
		model.addAttribute("boardName", boardName);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("pPage", pPage);
		model.addAttribute("pSortBy", pSortBy);
		model.addAttribute("strXML", strXML);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPage", totalPage);
		
		return "ezCommunity/communityBoardReservedItemList";
	}
	
	/**
	 * 게시판 첨부파일 다운로드 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/getCommunityAttachInfo.do")
	public void getCommunityAttachInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getCommunityAttachInfo started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pFileName = request.getParameter("fileName");
		String pFilePath = request.getParameter("filePath");
		pFilePath = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator + pFilePath;
		String realPath = commonUtil.getRealPath(request);
		logger.debug("fileName : " + pFileName);
		logger.debug("filePath : " + pFilePath);
		
		downFile(request, response, realPath + pFilePath, pFileName);
		
		logger.debug("getCommunityAttachInfo ended.");
	}
	
	/**
	 * 게시판 조회자정보 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/itemReadList.do")
	public String itemReadList(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String pBoardID = request.getParameter("boardID");
		String pItemID = request.getParameter("itemID");
		String offset = commonUtil.getMinuteUTC(userInfo.getOffset());
		
		List<CommunityBoardItemReadVO> readList = ezCommunityService.getReaderList(pBoardID, pItemID, userInfo.getTenantId(), offset);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("readList", readList);
		
		return "ezCommunity/communityItemReadList";
	}
	
	/**
	 * 게시글 미리보기 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemPreview.do")
	public String boardItemPreView(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String useIE11Browser = "";
		String gubun = request.getParameter("gubun");
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String strLang = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		
		if (commonUtil.checkIE(request) && ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId()).equals("CK")) {
                useIE11Browser = "CK";
		}
		
		model.addAttribute("displayName", strLang.equals("2") ? userInfo.getDisplayName2() : userInfo.getDisplayName());
		model.addAttribute("deptName", strLang.equals("2") ? userInfo.getDeptName2() : userInfo.getDeptName());
		model.addAttribute("title", strLang.equals("2") ? userInfo.getTitle2() : userInfo.getTitle());
		model.addAttribute("phone", userInfo.getPhone());
		model.addAttribute("gubun", gubun);
		model.addAttribute("strNow", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		model.addAttribute("Use_Editor", useEditor);
		model.addAttribute("Use_IE11Browser", useIE11Browser);
		
		return "ezCommunity/communityBoardItemPreview";
	}
	
	/**
	 * 게시판 복사화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/copyBoardItem.do")
	public String copyBoardItem(Model model, HttpServletRequest request) {
		String pItemIDList = request.getParameter("itemIDList");
		String pBoardID = request.getParameter("boardID");
		String code = request.getParameter("code");
		
		model.addAttribute("itemIDList", pItemIDList);
		model.addAttribute("boardID", pBoardID);
		model.addAttribute("code", code);
		return "ezCommunity/communityCopyBoardItem";
	}
	
	/**
	 * 게시판 복사 권한 검사
	 */
	@RequestMapping(value = "/ezCommunity/getACL.do", method = RequestMethod.POST)
	public String getACL(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		CommunityBoardPropertyVO boardInfo;
		
		if(request.getParameter("comID") != null) {
			String pComID = request.getParameter("comID");
			String strACLXML = ezCommunityService.getACL(userInfo.getId(), pComID, userInfo.getTenantId());
			
			model.addAttribute("WRITE", strACLXML);
		} else if (request.getParameter("boardID") != null) {
			String pBoardID = request.getParameter("boardID");
			String userDeptPath = userInfo.getDeptPathCode();
			
			logger.debug("pBoardID = " + pBoardID);
			logger.debug("userDeptPath = " + userDeptPath);
			
			for(String pAccessID : userDeptPath.split(",")) {
				boardInfo = ezCommunityService.brdGetACL(pBoardID, pAccessID, userInfo.getTenantId());
				
				if (boardInfo != null) {
					model.addAttribute("boardInfo", boardInfo);
					break;
				}
			}
		}
		
		return "json";
	}
	
	/**
	 * 게시판 복사 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/copyItem.do", method = RequestMethod.POST)
	public String copyItem(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("copyItem started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pOrgItemIDList = request.getParameter("orgItemIDList");
		String pOrgBoardID = request.getParameter("orgBoardID");
		String pDestItemIDList = request.getParameter("destItemIDList");
		String pDestBoardID = request.getParameter("destBoardID");
		String realPath = commonUtil.getRealPath(request);
		String ret = "";
		
		int i = 0;
		for(String pOrgItemID : pOrgItemIDList.split(";")) {
			ret = ezCommunityService.copyItem(pOrgItemID, pOrgBoardID, pDestItemIDList.split(";")[i], pDestBoardID, realPath, userInfo);
		}
		
		model.addAttribute("ret", "<RESULT>" + ret + "</RESULT>");
		
		logger.debug("copyItem ended.");
		
		return "json";
	}
	
	/**
	 * 복사시 일반/포토/익명 게시판 검사 실행 함수
	 */
	@RequestMapping(value = "/ezCommunity/checkIfAnonyBoard.do", method = RequestMethod.POST)
	public String checkIfAnonyBoard(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("checkIfAnonyBoard started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pBoardID = request.getParameter("boardID");
		String ret = "";
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID);
		if (boardInfo.getGubun() != null) {
			if (boardInfo.getGubun().equals("2") || boardInfo.getUrl() != null || boardInfo.getGubun().equals("3")){
				ret = "anonyboard";
			} else {
				ret = "normalboard";
			}
		} else {
			ret = "normalboard";
		}
		
		model.addAttribute("result", ret);
		
		logger.debug("checkIfAnonyBoard ended. result : " + ret);
		
		return "json";
	}
	
	/**
	 * 알림마당 목록화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsList.do")
	public String bbsList(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("bbsList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String bName = "tbl_c_board", sRadio = "", code = "", keyword = "";
		String titleName = "";
		int curPage = 0, totalPage = 0, nowBlock = 0, keywordCount = 0;
		int comNoPerPage = 17;
		
		bName = request.getParameter("bName").toLowerCase();
		
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio");
		}
		if (request.getParameter("code") != null) {
			code = request.getParameter("code");
		}
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
		}
		if (request.getParameter("goToPage") != null) {
			curPage = Integer.parseInt(request.getParameter("goToPage"));
		}
		if (request.getParameter("block") != null && !request.getParameter("block").equals("")) {
			nowBlock = Integer.parseInt(request.getParameter("block"));
		}
		
		if (!code.equals("")) {
			titleName = ezCommunityService.getBoardTitleName(bName, code, userInfo.getTenantId());
		}

		keywordCount = ezCommunityService.bbsListGet1(bName, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), keyword, sRadio, userInfo.getTenantId());
		totalPage = keywordCount / comNoPerPage;
		
		if (keywordCount % comNoPerPage != 0) {
			totalPage = totalPage + 1;
		}
		
		curPage = Math.min(curPage, totalPage);
		List<CommunityCBoardVO> cBoardList = ezCommunityService.bbsListGet2(bName, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), keyword, sRadio, userInfo.getTenantId());
		
		String strHTML = ezCommunityService.bbsList(userInfo, cBoardList, code, curPage, bName, comNoPerPage);

		model.addAttribute("idSpanVal", strHTML);
		model.addAttribute("keyword", keyword);
		model.addAttribute("sRadio", sRadio);
		model.addAttribute("curPage", curPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("titleName", titleName);
		model.addAttribute("bName", bName);
		model.addAttribute("block", nowBlock);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("code", code);
		
		logger.debug("bbsList ended.");
		
		return "ezCommunity/communityBbsList";
	}
	
	/**
	 * 알림마당 읽기 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsViewNew.do")
	public String bbsNewViewNew(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("bbsViewNew started.");
		
		String pagec = "1";
		String strTitle = "", strWriteName = "", strWriterID = "";
		int myStep = 0, myLevel = 0, grsRef = 0, readNo = 0, grsNo = 0;	
		String previousItemID = "", nextItemID = "";
		String strWriteDate = "";
		int nowBlock = 0;
	
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String bName = request.getParameter("bName").toLowerCase();
		/*String mode = request.getParameter("mode");*/
		String no = request.getParameter("no");

		if (request.getParameter("block") != null && !request.getParameter("block").equals("")) {
			nowBlock = Integer.parseInt(request.getParameter("block"));
		}
		if (request.getParameter("pagec") != null) {
			pagec = request.getParameter("pagec");
		}
		
		/*String fileName = ezCommunityService.bbsEditGet1(bName, no, userInfo.getTenantId());*/
		CommunityCBoardVO cBoardGet1 = ezCommunityService.bbsViewNewGet1(bName, no, userInfo.getTenantId(), userInfo.getOffset());
		
		if (cBoardGet1 != null) {
			strTitle = cBoardGet1.getTitle().trim().replaceAll("&quot;", "'").replaceAll("&dquot;", "\"");
			
			if (!bName.equals("tbl_c_clubnotice") && !bName.equals("tbl_c_notice")) {
				myStep = cBoardGet1.getStep();
				myLevel = cBoardGet1.getRe_Level();
				grsRef = cBoardGet1.getRef(); 
			}
			
			readNo = cBoardGet1.getReadNum();
			strWriteDate = cBoardGet1.getWriteDay().trim();
			
			if (commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()).equals("2")) {
				strWriteName = cBoardGet1.getUserName2();
			} else {
				strWriteName = cBoardGet1.getUserName();
			}
			
			strWriterID = cBoardGet1.getId().toLowerCase().trim();
			grsNo = cBoardGet1.getNo();
			
		} else {
			response.encodeRedirectURL("/error.do");
		}
		
		String previousTitle = egovMessageSource.getMessage("ezCommunity.t191", userInfo.getLocale());
		String nextTitle = egovMessageSource.getMessage("ezCommunity.t193", userInfo.getLocale());
		
		List<CommunityCBoardVO> cBoardList = ezCommunityService.bbsViewNewGet2(bName, userInfo.getTenantId());
		
		for (int i = 0; i < cBoardList.size(); i++) {
			if (cBoardList.get(i).getNo() == grsNo) {
				if (i >= 1) {
					previousItemID = Integer.toString(cBoardList.get(i-1).getNo());
					previousTitle = cBoardList.get(i-1).getTitle();
				}
			}
		}
		
		for (int i = 0; i < cBoardList.size(); i++) {
			if (cBoardList.get(i).getNo() == grsNo) {
				if (i < cBoardList.size()-1) {
					nextItemID = Integer.toString(cBoardList.get(i+1).getNo());
					nextTitle = cBoardList.get(i+1).getTitle();
				}
			}
		} 
		
		model.addAttribute("bName", bName);
		model.addAttribute("no", no);
		model.addAttribute("nowBlock", nowBlock);
		model.addAttribute("strTitle", strTitle);
		model.addAttribute("myStep", myStep);
		model.addAttribute("myLevel", myLevel);
		model.addAttribute("grsRef", grsRef);
		model.addAttribute("readNo", readNo);
		model.addAttribute("grsNo", grsNo);
		model.addAttribute("pagec", pagec);		
		model.addAttribute("strWriteDate", strWriteDate);
		model.addAttribute("strWriteName", strWriteName);
		model.addAttribute("strWriterID", strWriterID);
		model.addAttribute("previousTitle", previousTitle);
		model.addAttribute("nextTitle", nextTitle);
		model.addAttribute("nextItemID", nextItemID);
		model.addAttribute("previousItemID", previousItemID);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("strContentLocation", cBoardGet1.getFileName());
		
		logger.debug("bbsViewNew ended.");
		
		return "ezCommunity/communityBbsViewNew";
	}
	
	/**
	 * 알림마당 쓰기/수정 화면 호출함수 
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsEditNew.do")
	public String bbsEditNew(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		logger.debug("bbsEditNew started.");
		
		String code = "", sRadio = "", keyword = "", no = "", fileName = "", grsUserName = "", writerFakeName = "";
		int pagec = 0, block = 0;
		String step = "", level = "", ref = "";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String mode = request.getParameter("mode");
		String bName = request.getParameter("bName");
		
		if (request.getParameter("code") != null) {
			code = request.getParameter("code");
		}
		
		if (mode.equals("edit")) {
			sRadio = request.getParameter("sRadio");
			keyword = request.getParameter("keyword");
			no = request.getParameter("no");
			pagec = Integer.parseInt(request.getParameter("pagec"));
			block = Integer.parseInt(request.getParameter("block"));
		} else {
			step = request.getParameter("step");
			level = request.getParameter("level");
			ref = request.getParameter("ref");
			
			if (request.getParameter("no") != null) {
				no = request.getParameter("no");
			}
			if (request.getParameter("pagec") != null) {
				pagec = Integer.parseInt(request.getParameter("pagec"));
			}
		}
		
		//TODO 2016-04-27 이효진 사용하는곳 없음
		/*if (!code.equals("")){
			String titleName = ezCommunityService.getBoardTitleName(bName, code);
		}
		
		int adminCheck = ezCommunityService.bbsAdminCheck(userInfo.getId(), userInfo.getRollInfo());*/
		String serverName = request.getServerName();
		CommunityCBoardVO cBoardVO = null;
		
		if (!no.equals("")) { //  수정(mode :  "edit")  또는 답변(mode :  "write")

			fileName = ezCommunityService.bbsEditGet1(bName, no, userInfo.getTenantId());
			cBoardVO = ezCommunityService.bbsEditNew(bName, no, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
			
			 if (!no.equals("")) { // 수정(mode : "edit") 답변 (mode : "write")
				 if (userInfo.getLang().equals("2")) {
					 grsUserName = userInfo.getDisplayName2();
				 } else {
					 grsUserName = userInfo.getDisplayName1();
				 }
			 } else {
				 if (commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()).equals("2")) {
					 grsUserName = cBoardVO.getUserName2();
				 } else {
					 grsUserName = cBoardVO.getUserName();
				 }
			 }
			 
			 if (commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()).equals("2")) {
				 writerFakeName = cBoardVO.getUserName2();
			 } else {
				 writerFakeName = cBoardVO.getUserName();
			 }
		} else { // 쓰기(mode :  "write")
			if (userInfo.getLang().equals("2")) {
				grsUserName = userInfo.getDisplayName2();
			} else {
				grsUserName = userInfo.getDisplayName1();
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("mode", mode);
		model.addAttribute("no", no);
		model.addAttribute("pagec", pagec);
		model.addAttribute("sRadio", sRadio);
		model.addAttribute("keyword", keyword);
		model.addAttribute("block", block);
		model.addAttribute("code", code);
		model.addAttribute("bName", bName);
		model.addAttribute("grsUserName", grsUserName);
		model.addAttribute("writerFakeName", writerFakeName);
		model.addAttribute("fileName", fileName);
		model.addAttribute("serverName", serverName);
		model.addAttribute("cBoard", cBoardVO);
		model.addAttribute("step", step);
		model.addAttribute("level", level);
		model.addAttribute("gref", ref);
		model.addAttribute("dirPath", commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()));
		
		logger.debug("bbsEditNew ended.");
		
		return "ezCommunity/communityBbsEditNew";
	}
	
	/**
	 * 알림마당 쓰기/수정 실행함수 
	 */
	@RequestMapping(value = "/ezCommunity/bbsEditOk.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String bbsEditOk(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		return ezCommunityService.bbsEditOk(userInfo, request);
	}
	
	/**
	 * ckeditor 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/ckEditor.do")
	public String ckEditor(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		String pMode = "";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if(request.getParameter("DraftFlag") != null){
			pMode = request.getParameter("DraftFlag");
		}

		model.addAttribute("userInfo",userInfo);
		model.addAttribute("pMode", pMode);
		
		return "ezCommunity/CKEditor";
	}
	
	/**
	 * 알림마당 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/bbsDelOk.do", method = RequestMethod.POST, produces = "text/xml; charset=UTF-8")
	@ResponseBody
	public String bbsDelOk(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("bbsDelOk started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = "";
		int adminCheck = 0;
		
		String itemNo = request.getParameter("itemNo");
		String goToPage = request.getParameter("goToPage");
		String bName = request.getParameter("bName");

		if (userInfo.getRollInfo().indexOf("c=1") >= 0) {
			adminCheck = 1;
		}
		
		CommunityCBoardVO board = ezCommunityService.bbsDelOkGet(bName, itemNo, code, userInfo.getTenantId());
		
//		if (board.getId().trim().equals(userInfo.getId()) || adminCheck == 1 || userInfo.getRollInfo().indexOf("t=1") > -1 || userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
		if (board.getId().trim().equals(userInfo.getId()) || adminCheck == 1 || userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
			logger.debug("bbsDelOk ended.");
			
			return ezCommunityService.bbsDelOk(userInfo, request, board, itemNo, goToPage, bName, adminCheck, userInfo.getTenantId());
		} else {
			logger.debug("bbsDelOk error.");
			
			return "ERROR";
		}
	}
	
	/**
	 * 방명록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/guestOne.do")
	public String guestOne(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("guestOne started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "", keyword = "", sRadio = "";
		int totalPage = 0, curPage = 0, nowBlock = 0, comNoPerPage = 5;
		
		String code = request.getParameter("code");
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
		}
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio").toUpperCase();
		}
		if (request.getParameter("gotoPage") != null) {
			curPage = Integer.parseInt(request.getParameter("gotoPage"));
		} else {
			curPage = 1;
		}
		if (request.getParameter("block") != null) {
			nowBlock = Integer.parseInt(request.getParameter("block"));
		}
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response, userInfo)) {
			return "cmm/error/egovError";
		}
		
		int keywordCount = ezCommunityService.guestOneGet1(sRadio, keyword, code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		totalPage = keywordCount / comNoPerPage;

        if ((totalPage * comNoPerPage) != keywordCount && (keywordCount % comNoPerPage) != 0) {
            totalPage = totalPage + 1;
        }
        
        String strXML = ezCommunityService.guestOne(userInfo, sRadio, keyword, code, comNoPerPage, curPage);
        
		model.addAttribute("code", code);
		model.addAttribute("mode", mode);
		model.addAttribute("keyword", keyword);
		model.addAttribute("sRadio", sRadio);
		model.addAttribute("curPage", curPage);
		model.addAttribute("nowBlock", nowBlock);
		model.addAttribute("totalPage", totalPage);
		
		logger.debug("totalPage="+totalPage);
		
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("strXML" , strXML);
		model.addAttribute("disable" , false);
		
		logger.debug("guestOne ended.");
		
		return "ezCommunity/communityGuestOne";
	}
	
	/**
	 * 방명록 수정화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/guestEdit.do")
	public String guestEdit(@CookieValue("loginCookie") String loginCookie, CommunityCClubGuestVO item, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String no = request.getParameter("no");
		
		boolean bIsMyContent = false;
		
		item.setId(userInfo.getId());
		item.setUserName(userInfo.getDisplayName1());
		item.setUserName2(userInfo.getDisplayName2());
		
		if (mode.equals("edit")) {
			item = ezCommunityService.guestEditGet(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), no, userInfo.getId(), userInfo.getTenantId());
			
			if (item != null) {
				bIsMyContent = true;
				item.setContent(item.getContent().replaceAll("<br>", "\n"));
			}
		}
		
		model.addAttribute("code", code);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("mode", mode);
		model.addAttribute("no", no);
		model.addAttribute("item", item);
		model.addAttribute("bIsMyContent", bIsMyContent);
		
		return "ezCommunity/communityGuestEdit";
	}
	
	/**
	 * 방명록 쓰기/수정/삭제 실행함수 
	 */
	@RequestMapping(value = "/ezCommunity/guestEditOk.do")
	public String guestEditOk(@CookieValue("loginCookie") String loginCookie, Model model, CommunityCClubGuestVO item, HttpServletRequest request) throws Exception {
		logger.debug("guestEditOk started. ");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean bIsMyContent = false;
		String[] cNo = request.getParameterValues("c_no");
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String memo = request.getParameter("memo");
		
		logger.debug("code : " + code + ", mode : " + mode + ", memo : " + memo);
		
		bIsMyContent = ezCommunityService.guestEditOk(userInfo, item, code, mode, memo, cNo, bIsMyContent);
		
		model.addAttribute("mode", mode);
		model.addAttribute("code", code);
		model.addAttribute("bIsMyContent", bIsMyContent);
		
		logger.debug("guestEditOk ended. ");
		
		return "ezCommunity/communityGuestEditOk";
	}

	/**
	 * 설문조사 목록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollMain.do")
	public String pollMain(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int guest = 0;
		boolean disable = false;
		
		String code = request.getParameter("code");
		String userLevel = request.getParameter("userLevel");
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response, userInfo)) {
			return "cmm/error/egovError";
		}
		
		userLevel = ezCommunityService.pollMainGet1(userInfo.getId(), code, userInfo.getTenantId());
		
		if (userLevel == null) {
			userLevel = "0";
		}
		
		String strXML = ezCommunityService.pollMain(userInfo, code);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("guest", guest);
		model.addAttribute("code", code);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("disable", disable);
		model.addAttribute("strXML", strXML);
//		model.addAttribute("chCommunityAdmin", userInfo.getRollInfo().indexOf("t=1"));
		
		return "ezCommunity/communityPollMain";
	}
	
	/**
	 * 설문조사 등록 화면1 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollAdd.do")
	public String pollAdd(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pState = "", pSubject = "", pStartDate = "", pEndDate = "", pSelType = "", pSelRes1 = "", pSelRes2 = "", expireDays = "-1";
		
		String code = request.getParameter("code");
		
		if (request.getParameter("state") != null) {
			pState = request.getParameter("state");
		}
		
		if (pState.equals("PREV")) {
			if (request.getParameter("subject") != null) {
				pSubject = request.getParameter("subject");
			}
			
			if (request.getParameter("startDate") != null){
				pStartDate = request.getParameter("startDate");
			}
			
			if (request.getParameter("endDate") != null) {
				pEndDate = request.getParameter("endDate");
			}
			
			if (request.getParameter("selType") != null) {
				pSelType = request.getParameter("selType");
			}
			
			if (request.getParameter("selRes1") != null) {
				pSelRes1 = request.getParameter("selRes1");
			}
			
			if (request.getParameter("selRes2") != null) {
				pSelRes2 = request.getParameter("selRes2");
			}
		} else {
			pStartDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
			pEndDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		}
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 1, response, userInfo)) {
			return "cmm/error/egovError";
		}
		
		model.addAttribute("code", code);
		model.addAttribute("expireDays", expireDays);
		model.addAttribute("pState", pState);
		model.addAttribute("pSelType", pSelType);
		model.addAttribute("pSelRes1", pSelRes1);
		model.addAttribute("pSelRes2", pSelRes2);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("startDate", pStartDate);
		model.addAttribute("endDate", pEndDate);
		model.addAttribute("pSubject", pSubject);
		
		return "ezCommunity/communityPollAdd";
	}
	
	/**
	 * 설문조사 등록 화면2 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollAddOk.do")
	public String pollAddOk (@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String selRes = "", answerViewType = "", selRes1="0";
		int sel = 0, answerCount = 0, selectedNo = 0;
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String startDate = request.getParameter("startPollYear") + "-" + request.getParameter("startPollMonth") + "-" + request.getParameter("startPollDay");
		String endDate = request.getParameter("endPollYear") + "-" + request.getParameter("endPollMonth") + "-" + request.getParameter("endPollDay");
		String subject = request.getParameter("pollSubject");
		String selType = request.getParameter("selType");
		String selRes2 = request.getParameter("selRes2");
		
		if (request.getParameter("selRes1") != null) {
			selRes1 = request.getParameter("selRes1");
		}
		
		if (subject != null) {
			if (selRes1.equals("0")) {
				selRes = selRes2;
				answerViewType = "0";
				sel = 1;
			} else {
				selRes = selRes1;
				answerViewType = selRes;
				sel = 0;
			}
		}
		
		String strXML = ezCommunityService.pollAddOk(sel, selType, selRes, selectedNo, answerCount, model, userInfo);
		
		model.addAttribute("mode", mode);
		model.addAttribute("code", code);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("selRes", selRes);
		model.addAttribute("sel", sel);
		model.addAttribute("selType", selType);
		model.addAttribute("selJU", 0);
		model.addAttribute("answerViewType", answerViewType);
		model.addAttribute("subject", subject);
		model.addAttribute("idSpanValue", strXML);
		
		return "ezCommunity/communityPollAddOk";
	}
	
	/**
	 * 설문조사 등록 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/pollAddOkGo.do", method=RequestMethod.POST)
	public void pollAddOkGo(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		ezCommunityService.pollAddGo(userInfo, request, response);
	}
	
	/**
	 * 설문조사 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/pollDelete.do")
	public void pollDelete(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		ezCommunityService.pollDelete(userInfo, request, response);
	}
	
	/**
	 * 설문조사 읽기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollRes.do")
	public String poll(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String pollManagerID = request.getParameter("pollManagerID");
		String pollState = request.getParameter("pollState");
		
		//TODO 2016-12-15 이효진 사용되지 않음
//		int userLevel = ezCommunityService.pollResGet1(userInfo.getId(), code, tenantID);
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 1, response, userInfo)) {
			return "cmm/error/egovError";
		}
		
		ezCommunityService.pollRes(userInfo, model, pollManagerID, pollState, response);
		
		model.addAttribute("code", code);
		model.addAttribute("pollState", pollState);
		
		return "ezCommunity/communityPollRes";
	}
	
	/**
	 * 설문조사 응답 실행 함수
	 */
	@RequestMapping(value = "/ezCommunity/pollResOk.do", method = RequestMethod.POST)
	public void pollResOk(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String answerType = request.getParameter("answerType_1");
		String answerETC = request.getParameter("answerETC");
		String pollSelect = request.getParameter("pollSelect_1");
		String answerCount = request.getParameter("answerCount_1");
		String isSave = request.getParameter("isSave");
		String questionID = request.getParameter("questionID_1");
		
		ezCommunityService.pollResOk(userInfo, code, questionID, pollSelect, answerETC, isSave, answerType, answerCount, response);
	}
	
	/**
	 * 설문조사 날짜변경화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollEdit.do")
	public String pollEdit(@CookieValue("loginCookie") String loginCookie, Model model,HttpServletRequest request) throws Exception {
		logger.debug("pollEdit started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pClubNo = request.getParameter("pClubNo");
		String managerID = request.getParameter("managerID");
		String offset = userInfo.getOffset();
		int tenantID = userInfo.getTenantId();
		
		CommunityCPollManagerVO managerVO = ezCommunityService.pollEditGet1(managerID, tenantID);
		
		String pStartDate = commonUtil.getDateStringInUTC(managerVO.getPollStartDate(), offset, false).substring(0, 10);
		String pEndDate = commonUtil.getDateStringInUTC(managerVO.getPollEndDate(), offset, false).substring(0, 10);
		
		CommunityCPollQuestionVO questionVO = ezCommunityService.pollEditGet2(managerID, tenantID);
		
		model.addAttribute("pClubNo", pClubNo);
		model.addAttribute("managerID", managerID);
		model.addAttribute("managerVO", managerVO);
		model.addAttribute("pStartDate", pStartDate);
		model.addAttribute("pEndDate", pEndDate);
		model.addAttribute("questionVO", questionVO);
		
		logger.debug("pollEdit ended.");
		
		return "ezCommunity/communityPollEdit";
	}
	
	/**
	 * 설문조사 날짜변경 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/pollEditOk.do")
	public void pollEditOk(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		String pClubNo = request.getParameter("pClubNo");
		String managerID = request.getParameter("managerID");
		String subject = request.getParameter("pollSubject");
		String startDate = request.getParameter("startPollYear") + "-" + request.getParameter("startPollMonth") + "-" + request.getParameter("startPollDay") + " 00:00:00";
		String endDate = request.getParameter("endPollYear") + "-" + request.getParameter("endPollMonth") + "-" + request.getParameter("endPollDay") + " 23:59:59";
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		ezCommunityService.pollEditOk(pClubNo, subject, startDate, endDate, managerID, userInfo.getTenantId(), response);
	}
	
	/**
	 * 설문조사 답변 응답보기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollETCView.do")
	public String pollETCView(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("pollETCView started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String questionID = request.getParameter("questionID");
		String etc = request.getParameter("etc");
		
		int etcTotal = ezCommunityService.pollETCViewGet(questionID, userInfo.getTenantId());
		
		model.addAttribute("questionID", questionID);
		model.addAttribute("etc", etc);
		model.addAttribute("ETCTotal", etcTotal);
		
		logger.debug("pollETCView ended.");
		
		return "ezCommunity/communityPollETCView";
	}
	
	/**
	 * 설문조사 응답 테이블 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollETCTable.do")
	public String pollETCTable(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("pollETCTableGet started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String questionID = request.getParameter("questionID");
		String etc = request.getParameter("etc");
		
		List<CommunityCPollResponseVO> responseList = ezCommunityService.pollETCTableGet(questionID, userInfo.getTenantId());
		
		model.addAttribute("questionID", questionID);
		model.addAttribute("etc", etc);
		model.addAttribute("responseList", responseList);
		
		logger.debug("pollETCTableGet ended.");
		
		return "ezCommunity/communityPollETCTable";
	}
	
	/**
	 * 회원목록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/commViewMember.do")
	public String commViewMember(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String keyword = "", sRadio = "", block = "";
		int curPage = 1;
		
		String code = request.getParameter("code");
		
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
		}
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio");
		}
		if (request.getParameter("goToPage") != null) {
			curPage = Integer.parseInt(request.getParameter("goToPage"));
		}
		if (request.getParameter("block") != null) {
			block = request.getParameter("block");
		}
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 1, response, userInfo)) {
			return "cmm/error/egovError";
		}
		
		int keywordCount = ezCommunityService.commViewMemberGet2(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), keyword, sRadio, userInfo.getTenantId());
		
		int comNoPerPage = 10;
        int totalPage = keywordCount / comNoPerPage;

        if ((totalPage * comNoPerPage) != keywordCount && (keywordCount % comNoPerPage) != 0){
        	totalPage = totalPage + 1;
        }
        
		String strSysopID = ezCommunityService.adminMemberListGet2(code, userInfo.getTenantId()).trim();
		String strXML = ezCommunityService.commViewMember(userInfo, code, strSysopID, keyword, sRadio, comNoPerPage, curPage);
		
		model.addAttribute("curPage", curPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("code", code);
		model.addAttribute("sRadio", sRadio);
		model.addAttribute("keyword", keyword);
		model.addAttribute("nowBlock", block);
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("strSysopID", strSysopID);
		model.addAttribute("strXML", strXML);
		
		logger.debug("strXML = " + strXML);
		
		return "ezCommunity/communityCommViewMember";
	}
	
	/**
	 * 회원탈퇴 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/commOut.do")
	public String commOut(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		CommunityClubVO club = ezCommunityService.aspCommInfoGet1(code, userInfo.getTenantId());
		CommunityMemberInfoVO member = ezCommunityService.commOutGet(club.getC_SysopID().trim(), club.getCompanyID(), commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		String sysopName = member.getUserName();
		
		if (sysopName.equals("")) {
			sysopName = egovMessageSource.getMessage("ezCommunity.t398", userInfo.getLocale());
		}
		
		if(commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()).equals("2")) {
			club.setC_ClubName(club.getC_ClubName2());
		}
		
		String strCategoryPrint = ezCommunityService.categoryPrint(club.getC_Cate_A().trim(), club.getC_Cate_B().trim(), club.getC_Cate_C().trim(), userInfo);
	
		model.addAttribute("code", code);
		model.addAttribute("club", club);
		model.addAttribute("sysopName", sysopName);
		model.addAttribute("str_category_print", strCategoryPrint);
		
		return "ezCommunity/communityCommOut";
	}
	
	/**
	 * 회원탈퇴 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/commOutOk.do")
	@ResponseBody
	public String commOutOk(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData) throws Exception{
		Document xmlDoc = commonUtil.convertStringToDocument(xmlData);
		
		String code = xmlDoc.getElementsByTagName("CODE").item(0).getTextContent();
		String reason = xmlDoc.getElementsByTagName("REASON").item(0).getTextContent();
		
		String retValue = ezCommunityService.commOutOk(loginCookie, code, reason);
		
		return retValue;
	}
	
	/**
	 * 관리메뉴 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/admin/index.do")
	public String adminIndex(HttpServletRequest request, Model model) {
		logger.debug("adminIndex started.");
		
		String flag = "", num = "";
		String code = request.getParameter("code");
		
		if (request.getParameter("flag") != null) {
			flag = request.getParameter("flag");
		}
		if (request.getParameter("num") != null) {
			num = request.getParameter("num");
		}
		
		model.addAttribute("code", code);
		model.addAttribute("flag", flag);
		model.addAttribute("num", num);
		
		logger.debug("adminIndex ended.");
		
		return "ezCommunity/communityAdminIndex";
	}
	
	/**
	 * 관리메뉴 왼쪽화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminLeft.do")
	public String adminLeft(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("adminLeft started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String num = "", pExcludeBoardID = " ", flag = "", clickBoard = "", boardID = "";
		String pRootBoardID = "top", pSubFlag = "0";
		int pSelectBy = 0, pMode = 0;
		
		String code = request.getParameter("code");
		
		if (request.getParameter("num") != null) {
			num = request.getParameter("num");
		}
		if (request.getParameter("flag") != null) {
			flag = request.getParameter("flag");
		}
		if (request.getParameter("clickBoard ") != null) {
			clickBoard  = request.getParameter("clickBoard ");
		}
		if (request.getParameter("boardID ") != null) {
			boardID  = request.getParameter("boardID ");
		}
		
		CommunityClubVO club = ezCommunityService.adminLeftGet(code, userInfo.getTenantId());
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		String boardGroupAdmin_FG = ezCommunityService.checkIfBoardGroupAdmin(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (boardGroupAdmin_FG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1) {
			pMode = 0;
		} else {
			pMode = 1;
		}

		String retXML = ezCommunityService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		logger.debug("xmlret = " + retXML);
		
		if (retXML.substring(0, 5).toUpperCase().equals("ERROR")){
            retXML = "<RESULT>ERROR</RESULT>";
		}
		
		model.addAttribute("code", code);
		model.addAttribute("num", num);
		model.addAttribute("clickBoard", clickBoard);
		model.addAttribute("boardID", boardID);
		model.addAttribute("flag", flag);
		model.addAttribute("club", club);
		model.addAttribute("xmlret", retXML);
		
		logger.debug("adminLeft ended.");
		
		return "ezCommunity/communityAdminLeft";
	}
	
	/**
	 * 관리메뉴 기본정보수정화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminBasic.do")
	public String adminBasic(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("adminBasic started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String name1 = "";
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary"+userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary"+userInfo.getLang(), userInfo.getTenantId());
		
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		CommunityClubVO club = ezCommunityService.aspCommInfoGet1(code, userInfo.getTenantId());
		
		if (club != null) {
			CommunityMemberInfoVO member = ezCommunityService.aspCommInfoGet2(commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), club.getC_SysopID().trim(), userInfo.getTenantId());
			
			if (userInfo.getLang().equals("2")) {
				member.setUserName(member.getUserName2());
			}
			
			name1 = member.getUserName();
		}

		int pPermitCount = ezCommunityService.adminMemPermitGet1(code, userInfo.getTenantId());
		String cCateA = ezCommunityService.adminBasicGet1(code, userInfo.getTenantId());
		String cCateB = ezCommunityService.adminBasicGet2(code, userInfo.getTenantId());
		
		model.addAttribute("code", code);
		model.addAttribute("club", club);
		model.addAttribute("name1", name1);
		model.addAttribute("pPermitCount", pPermitCount);
		model.addAttribute("c_cate_a", (cCateA == null) ? "" : egovMessageSource.getMessage("ezCommunity."+cCateA, userInfo.getLocale()));
		model.addAttribute("c_cate_b", (cCateB == null) ? "" : egovMessageSource.getMessage("ezCommunity."+cCateB, userInfo.getLocale()));
		model.addAttribute("lang_Primary", langPrimary);
		model.addAttribute("lang_Secondary", langSecondary);
		
		logger.debug("adminBasic ended.");
		
		return "ezCommunity/communityAdminBasic";
	}
	
	/**
	 * 관리메뉴 기본정보수정 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminBasicOk.do")
	public String adminBasicOk(@CookieValue("loginCookie")String loginCookie, CommunityClubVO clubVO, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");

		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		ezCommunityService.adminBasicOkUpdate(clubVO, code, userInfo.getTenantId());
		
		model.addAttribute("code", code);
		
		return "ezCommunity/communityAdminBasicOk";
	}
	
	/**
	 * 커뮤니티 환경설정화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminLogo.do")
	public String adminLogo(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		CommunityClubVO clubVO = ezCommunityService.adminLogoGet(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		String copType = ezCommunityService.commHomeGet4(code, userInfo.getTenantId());
		
		clubVO.setC_Type(copType);
		
		if (userInfo.getLang().equals("2")) {
			clubVO.setC_ClubName(clubVO.getC_ClubName2());
		}
		
		model.addAttribute("code", code);
		model.addAttribute("clubVO", clubVO);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		return "ezCommunity/communityAdminLogo";
	}
	
	/**
	 * 커뮤니티 환경설정화면 로고 temp파일 저장 실행함수
	 */
	@RequestMapping(value = "ezCommunity/adminLogoUpload.do")
	public String adminLogoUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		logger.debug("adminLogoUpload started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		String logoPath = commonUtil.getUploadPath("upload_community.LOGO", userInfo.getTenantId());
		MultipartFile logoFile = request.getFile("logoFile");
		String code = request.getParameter("code");
		String result = "";
		
		if (!logoFile.isEmpty()) {
			result = logoPath + commonUtil.separator + ezCommunityService.adminLogoUpload(code, realPath, logoPath, logoFile, userInfo.getTenantId());
		}
		
		//cache 문제로 인한 ? 랜덤값 추가
		result = result + "?" + new Random().nextInt(50);

		model.addAttribute("tempLogoPath", result);
		logger.debug("adminLogoUpload ended.");
		logger.debug("result======" + result);
		return "json";
	}
	
	
	/**
	 * 커뮤니티 환경설정화면 IE9 로고 업테이트 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminLogoUploadIE9.do")
	public String adminLogoUploadIE9(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("adminLogoUploadIE9 started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String logoPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.LOGO", userInfo.getTenantId()) + commonUtil.separator;
		String fileName = request.getParameter("fileName");
		String fileData = request.getParameter("fileData");
		String code = request.getParameter("code");
		String type = request.getParameter("type");
		String imageSrc = request.getParameter("imageSrc");
		
		logger.debug("fileName : " + fileName + ", code : " + code + ", type : " + type);
		
		try {
			ezCommunityService.adminLogoUploadIE9(code, type, imageSrc, logoPath, fileName, fileData, userInfo.getTenantId());
			model.addAttribute("result", true);
		} catch (Exception e) {
			model.addAttribute("result", false);
			throw e;
		}
		
		logger.debug("adminLogoUploadIE9 ended.");
		return "json";
	}
	
	/**
	 * 커뮤니티 환경설정화면 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminLogoOk.do")
	public String adminLogoOk(@CookieValue("loginCookie")String loginCookie, Model model, MultipartHttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");

		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		ezCommunityService.adminLogoOk(request, userInfo.getTenantId());
		
		model.addAttribute("code", code);
		
		return "ezCommunity/communityAdminLogoOk";
	}
	
	/**
	 * 커뮤니티 환경설정화면 실행함수 IE9
	 */
	@RequestMapping(value = "/ezCommunity/adminLogoIE9Ok.do")
	public String adminLogoOkIE9(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = request.getParameter("code");

		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		model.addAttribute("code", code);
		
		return "ezCommunity/communityAdminLogoOk";
	}
	
	/**
	 * 홈 화면관리화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminHomeBoard.do")
	public String adminHomeBoard(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		String listHeader = "<HEADERS><HEADER><NAME>" + egovMessageSource.getMessage("ezCommunity.t1168", userInfo.getLocale()) + "</NAME><WIDTH>70</WIDTH></HEADER></HEADERS>";
		String listHeader2 = "<HEADERS><HEADER><NAME>" + egovMessageSource.getMessage("ezCommunity.t2015", userInfo.getLocale()) + "</NAME><WIDTH>70</WIDTH></HEADER></HEADERS>";
		String listHeader3 = "<HEADERS><HEADER><NAME>" + egovMessageSource.getMessage("ezCommunity.t2016", userInfo.getLocale()) + "</NAME><WIDTH>70</WIDTH></HEADER></HEADERS>";
		
		String returnVal = ezCommunityService.adminHomeBoard1(userInfo, code);
		String returnVal2 = ezCommunityService.adminHomeBoard2(userInfo, code);
		String returnVal3 = ezCommunityService.adminHomeBoard3(userInfo, code);

		returnVal = "<LISTVIEWDATA>" + listHeader + "<ROWS>" + returnVal + "</ROWS></LISTVIEWDATA>";
		returnVal2 = "<LISTVIEWDATA>" + listHeader2 + "<ROWS>" + returnVal2 + "</ROWS></LISTVIEWDATA>";
		returnVal3 = "<LISTVIEWDATA>" + listHeader3 + "<ROWS>" + returnVal3 + "</ROWS></LISTVIEWDATA>";
		
		model.addAttribute("code", code);
		model.addAttribute("returnVal", returnVal);
		model.addAttribute("returnVal2", returnVal2);
		model.addAttribute("returnVal3", returnVal3);
		model.addAttribute("listHeader", listHeader);
		model.addAttribute("listHeader2", listHeader2);
		model.addAttribute("listHeader3", listHeader3);
		
		
		return "ezCommunity/communityAdminHomeBoard";
	}
	
	/**
	 * 홈 화면관리 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/saveHomeBoard.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveHomeBoard (@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlData);
		
		String code = xmlDom.getElementsByTagName("CODE").item(0).getTextContent();
        String left = xmlDom.getElementsByTagName("LEFT").item(0).getTextContent();
        String right = xmlDom.getElementsByTagName("RIGHT").item(0).getTextContent();
        int tenantID = userInfo.getTenantId();
        
		try{
	        ezCommunityService.adminHomeBoardSet("true", "", 0, code, "", tenantID);
	        
	        if (!left.equals("")) {
	        	int i = 1;
	        	
	        	for (String splitLeft : left.split(";")) {
	        		ezCommunityService.adminHomeBoardSet("false", "1", i, code, splitLeft, tenantID);
	        		i++;
	        	}
	        }
	        
	        if (!right.equals("")){
	        	int i = 1;
	        	
	        	for (String splitRight : right.split(";")) {
	        		ezCommunityService.adminHomeBoardSet("false", "2", i, code, splitRight, tenantID);
	        		i++;
	        	}
	        }
	        
	        return "OK";
		} catch (Exception e) {
			return "ERROR";
		}
	}
	
	/**
	 * 게시판 관리화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardProperty.do")
	public String adminBoardProperty (@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("adminBoardProperty started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String style = "";
		String useMultiData = ezCommonService.getTenantConfig("Use_MultiData"+userInfo.getLang(), userInfo.getTenantId());
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary"+userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary"+userInfo.getLang(), userInfo.getTenantId());
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		CommunityBoardPropertyVO boardProp = ezCommunityService.getBoardProperty(boardID, userInfo.getTenantId());
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName2());
		}
		
		if (boardProp.getDeleteAfter() == null) {
			boardProp.setDeleteAfter("-1");
		}
		
		if (boardProp.getBoardColor() == null) {
			boardProp.setBoardColor("#000000");
		}
		
		if (ezCommunityService.boardPropertyGet(boardID, userInfo.getTenantId()) > 0) {
			style = "display:none";
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("useMultiData", useMultiData);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("boardProp", boardProp);
		model.addAttribute("_style", style);
		
		logger.debug("adminBoardProperty ended.");
		
		return "ezCommunity/communityAdminBoardProperty";
	}
	
	/**
	 * 게시판 관리메뉴 일반설정 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/saveBoardProperty.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveBoardProperty(@RequestBody String xmlData, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String ret = ezCommunityService.saveBoardProperty(userInfo, xmlData);
		
		return "<RESULT>" + ret + "</RESULT>";
	}
	
	/**
	 * 그룹생성화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardGroupCreate.do")
	public String boardGroupCreate(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary"+userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary"+userInfo.getLang(), userInfo.getTenantId());
		
		String code = request.getParameter("code");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String boardID = request.getParameter("boardID");
		
		model.addAttribute("code", code);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("lang_Primary", langPrimary);
		model.addAttribute("lang_Secondary", langSecondary);
		
		return "ezCommunity/communityAdminBoardGroupCreate";
	}
	
	/**
	 * 그룹생성화면 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/createBoardGroup.do")
	public void createBoardGroup(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardGroupID = request.getParameter("boardGroupID");
		String boardGroupName = request.getParameter("boardGroupName");
		String boardGroupName2 = request.getParameter("boardGroupName2");
		String code = request.getParameter("code");
		
		ezCommunityService.createBoardGroup(code, boardGroupID, boardGroupName, boardGroupName2, userInfo);
	}
	
	/**
	 * 순서변경화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardOrder.do")
	public String boardOrder(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String boardID = request.getParameter("boardID");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName2());
		}
		
		model.addAttribute("code", code);
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("upperBoardID", parentBoardID);
		model.addAttribute("boardName", boardInfo.getBoardName());

		return "ezCommunity/communityAdminBoardOrder";
	}
	
	/**
	 * 게시판관리 Tree 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminGetSubBoards.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String adminGetSubBoards(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("adminGetSubBoards started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pExcludeBoardID = " ";
		int pMode = 0;
		
		String upperBoardID = request.getParameter("upperBoardID");
		String code = request.getParameter("code");
		
		if (request.getParameter("pExcludeBoardID") != null) {
			pExcludeBoardID = request.getParameter("pExcludeBoardID");
		}
		
		String strXML = ezCommunityService.getBoardTree(upperBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, 1, 0, pExcludeBoardID, code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		logger.debug("adminGetSubBoards ended.");
		
		return strXML;
	}
	
	/**
	 * 순서변경 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/saveBoardOrder.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveBoardOrder(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData, HttpServletRequest request) throws Exception {
		logger.debug("saveBoardOrder started.");
		logger.debug("xmlData = " + xmlData);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String ret = ezCommunityService.saveBoardOrder(xmlData, userInfo.getTenantId());
		
		ezCommunityService.deleteBoard(userInfo.getTenantId());
		
		ret = "<RESULT>" + ret + "</RESULT>";

		logger.debug("saveBoardOrder started.");
		
		return ret;
	}
	
	/**
	 * 하위게시판 생성화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardCreate.do")
	public String boardCreate(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary"+userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary"+userInfo.getLang(), userInfo.getTenantId());
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName2());
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("lang_Primary", langPrimary);
		model.addAttribute("lang_Secondary", langSecondary);
		model.addAttribute("parentBoardName", boardInfo.getBoardName());
		
		return "ezCommunity/communityAdminBoardCreate";
	}
	
	/**
	 * 하위게시판 생성 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/createBoard.do", method = RequestMethod.POST)
	public void createBoard(@CookieValue("loginCookie") String loginCookie , HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String boardName = request.getParameter("boardName");
		String boardName2 = request.getParameter("boardName2");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		//첨부 용량 제한 [이성우]
		String comatt = "10";
		
		ezCommunityService.createBoardInsert(code, boardID, boardName, boardName2, parentBoardID, boardGroupID, comatt, userInfo);
	}
	
	/**
	 * 게시판이동화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardMove.do")
	public String boardMove(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName2());
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("boardName", boardInfo.getBoardName());
		
		return "ezCommunity/communityAdminBoardMove";
	}
	
	/**
	 * 대상게시판선택화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardMoveSelect.do")
	public String boardMoveSelect() throws Exception {
		return "ezCommunity/communityAdminBoardMoveSelect";
	}
	
	/**
	 * 게시판이동 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/moveBoard.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String moveBoard(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("moveBoard started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String orgBoardID = request.getParameter("orgBoardID");
		String newParentBoardID = request.getParameter("newParentBoardID");
		String newBoardGroupID = request.getParameter("newBoardGroupID");
		
		String ret = ezCommunityService.moveBoard(orgBoardID, newParentBoardID, newBoardGroupID, userInfo.getTenantId());
		
		logger.debug("moveBoard ended.");
		
		return "<RESULT>" + ret + "</RESULT>";
	}
	
	/**
	 * 게시판삭제화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardDelete.do")
	public String boardDelete(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName2());
		}
		
		String strXML = ezCommunityService.getBoardTree(boardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), 0, 1, 0, " ", code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("boardName", boardInfo.getBoardName());
		model.addAttribute("xmlret", strXML);
		
		return "ezCommunity/communityAdminBoardDelete";
	}
	
	/**
	 * 게시판삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/deleteBoard.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String delete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		
		String ret = ezCommunityService.brdDeleteBoard(boardID, userInfo.getTenantId());
		
		ret = "<RESULT>" + ret + "</RESULT>";
		
		return ret;
	}

	/**
	 * 관리메뉴 게시판검색화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminSearchBoardItem.do")
	public String adminSearchBoardItem(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String title = "", writerName = "", abstracts = "", searchStart = "", searchEnd = "", startDateTime = "", endDateTime = "";
		int pPage = 1, totalCount = 0, totalPage = 0;
		String strXML = "";
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		String orgBoardParameters = request.getParameter("orgBoardParameters");
		
		if (request.getParameter("page") != null) {
			pPage = Integer.parseInt(request.getParameter("page"));
		}
		if (request.getParameter("title") != null) {
			title = request.getParameter("title");
		}
		if (request.getParameter("writerName") != null) {
			writerName = request.getParameter("writerName");
		}
		if (request.getParameter("abstract") != null) {
			abstracts = request.getParameter("abstract");
		}
		if (request.getParameter("searchStart") != null) {
			searchStart = request.getParameter("searchStart");
		}
		if (request.getParameter("searchEnd") != null) {
			searchEnd = request.getParameter("searchEnd");
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName());
		}
		
		int pStartRow = (pPage - 1) * boardInfo.getSs_SearchBoard_MaxRows() + 1;
        int pEndRow = pPage * boardInfo.getSs_SearchBoard_MaxRows();

        if (!searchStart.equals("")) {
        	startDateTime = searchStart + " 00:00:00";
        	endDateTime = searchEnd + " 23:59:59";
        }

        if (!title.equals("") || !writerName.equals("") || !abstracts.equals("") || !searchStart.equals("")) {
        	totalCount = ezCommunityService.adminSearchItemCount(userInfo, boardID, title, writerName, abstracts, startDateTime, endDateTime);
            strXML = ezCommunityService.adminSearchItemXML(userInfo, boardID, title, writerName, abstracts, startDateTime, endDateTime, pStartRow, pEndRow);
            
            if (totalCount > 0) {
				if (totalCount > boardInfo.getSs_SearchBoard_MaxRows()) {
					if(totalCount % boardInfo.getSs_SearchBoard_MaxRows() > 0) {
						totalPage = totalCount / boardInfo.getSs_SearchBoard_MaxRows() + 1;
					} else {
						totalPage = totalCount / boardInfo.getSs_SearchBoard_MaxRows();
					}
				} else {
					totalPage = 1;
				}
			} else {
				totalPage = 1;
			}
        }
        
        model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("boardName", boardInfo.getBoardName());
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("boardInfo", boardInfo);
        model.addAttribute("orgBoardParameters", orgBoardParameters);
        model.addAttribute("searchStart", startDateTime);
        model.addAttribute("searchEnd", endDateTime);
        model.addAttribute("strXML", strXML);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("title", title);
        model.addAttribute("writerName", writerName);
        model.addAttribute("abstract", abstracts);
        
		return "ezCommunity/communityAdminSearchBoardItem";
	}
	
	/**
	 * 검색 대상게시판 선택화면 호출
	 */
	@RequestMapping(value = "/ezCommunity/boardSelect.do")
	public String boardSelect(Model model, HttpServletRequest request) {
		String code = request.getParameter("code");
		
		model.addAttribute("code", code);
		
		return "ezCommunity/communityBoardSelect";
	}
	
	/**
	 * 탈퇴희망자 승인화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminOuterList.do")
	public String adminOuterList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		int postCount = ezCommunityService.adminOuterListGet1(code, userInfo.getTenantId());
		
		String idSpanValue = ezCommunityService.adminOuterList(userInfo, code);

		model.addAttribute("code", code);
		model.addAttribute("postCount", postCount);
		model.addAttribute("idSpanValue", idSpanValue);
		
		return "ezCommunity/communityAdminOuterList";
	}
	
	/**
	 * 탈퇴희망자 승인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminOuterOkNo.do")
	public String adminOuterOkNo(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String flag = request.getParameter("flag");
		String userID = request.getParameter("userID");
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		ezCommunityService.adminOuterOkNoSet(flag.toUpperCase(), userID, code, userInfo.getTenantId());
		
		model.addAttribute("code", code);
		
		return "ezCommunity/communityAdminOuterOkNo";
	}
	
	/**
	 * 회원 탈퇴처리화면/마스터이취임화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminMemberList.do")
	public String adminMemberList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("adminMemberList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String flag = "", ser = "";
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		
		if (request.getParameter("flag") != null) {
			flag = request.getParameter("flag");
		}
		
		if (request.getParameter("ser") != null) {
			ser = request.getParameter("ser");
		}
		
		ser = ser.replace("'", "''");		
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		int postCount = ezCommunityService.adminMemberListGet1(code, userInfo.getTenantId());
		String strSysopID = ezCommunityService.adminMemberListGet2(code, userInfo.getTenantId());
		String idSpanValue = ezCommunityService.adminMemberList(userInfo, code, flag, ser, strSysopID, mode);
		
		model.addAttribute("code", code);
		model.addAttribute("mode", mode);
		model.addAttribute("postCount", postCount);
		model.addAttribute("strSysopID", strSysopID);
		model.addAttribute("idSpanValue", idSpanValue);
		
		logger.debug("adminMemberList ended.");
		
		return "ezCommunity/communityAdminMemberList";
	}
	
	/** 
	 * 회원 탈퇴처리화면/마스터이취임화면 실행함수
	 */
	@RequestMapping( value = "/ezCommunity/adminMemberListOk.do")
	String adminMemberListOk(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		CommunityCClubUserVO clubUser = null;
		String propList = "extensionAttribute2;company;description;displayName;title;mail;telephoneNumber;mobile;info;homePhone;facsimileTelephoneNumber;postalCode;streetAddress";
		int userMode = 0;
		boolean existOutList = false;
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String cID = request.getParameter("cID");
		String cNM = request.getParameter("cNM");
		String companyID = request.getParameter("companyID");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		String infoXML = ezOrganAdminService.getPropertyList(cID, propList, userInfo.getPrimary(), userInfo.getTenantId());
		
		Document xmldom = commonUtil.convertStringToDocument(infoXML);
		
		CommunityMemberInfoVO memberInfo = new CommunityMemberInfoVO();
		memberInfo.setDeptName(xmldom.getElementsByTagName("DESCRIPTION").item(0).getTextContent());
		memberInfo.setHandPhone(xmldom.getElementsByTagName("MOBILE").item(0).getTextContent());
		memberInfo.setCompanyFax(xmldom.getElementsByTagName("FACSIMILETELEPHONENUMBER").item(0).getTextContent());
		memberInfo.setCompanyZip(xmldom.getElementsByTagName("POSTALCODE").item(0).getTextContent());
		memberInfo.setCompanyAddress(xmldom.getElementsByTagName("STREETADDRESS").item(0).getTextContent());
		memberInfo.setUserName(xmldom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent());
		memberInfo.setCompanyTel(xmldom.getElementsByTagName("TELEPHONENUMBER").item(0).getTextContent());
		
		logger.debug("getMemberInfo(" + companyID + ", " + cID + ", " + userInfo.getTenantId() + ")");
		CommunityMemberInfoVO memberInfoVO = ezCommunityService.getMemberInfo(companyID, cID, userInfo.getTenantId());
		
		if (memberInfoVO != null) {
			logger.debug("adminMemberListOkGet(" + code + ", " + companyID + ", " + cID + ", " + userInfo.getTenantId() + ")");
			clubUser = ezCommunityService.adminMemberListOkGet(code, cID, companyID, userInfo.getTenantId());
			
			if (clubUser != null) {
				if (clubUser.getC_birth() != 0 && memberInfoVO.getBirthDay() != null) {
					if (memberInfoVO.getBirthDay().trim().substring(0, 1).equals("-")) {
						memberInfoVO.setBirthDay("(" + egovMessageSource.getMessage("ezCommunity.t538", userInfo.getLocale()) + memberInfoVO.getBirthDay().trim().substring(1, memberInfoVO.getBirthDay().trim().length() - 1));
					} else {
						memberInfoVO.setBirthDay("(" + egovMessageSource.getMessage("ezCommunity.t539", userInfo.getLocale()) + memberInfoVO.getBirthDay().trim().substring(1, memberInfoVO.getBirthDay().trim().length() - 1));
					}
				}
			} else {
				userMode = 1;
			}
		} else {
			userMode = 1;
		}
		
		Integer result = ezCommunityService.adminMemberListOkGetE(code, cID, userInfo.getTenantId());
		
		if (result != null) {
			if (result > 0) {
				existOutList = true;
			}
		}

		model.addAttribute("code", code);
		model.addAttribute("mode", mode);
		model.addAttribute("cID", cID);
		model.addAttribute("cNM", cNM);
		model.addAttribute("memberInfo", memberInfo);
		model.addAttribute("memberInfoVO", memberInfoVO);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("clubUser", clubUser);
		model.addAttribute("userMode", userMode);
		model.addAttribute("existOutList", existOutList);
		
		return "ezCommunity/communityAdminMemberListOk";
	}
	
	/** 
	 * 회원 탈퇴처리화면/마스터이취임화면 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminMemberListOkGo.do")
	public String adminMemberListOkGo(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String cID = request.getParameter("cID");
		String userName = request.getParameter("userName");
		String cNm = request.getParameter("cNm");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		ezCommunityService.adminMemberListOkGoSe(mode.toUpperCase(), code, cID, cNm, userInfo.getTenantId());
		
		model.addAttribute("code", code);
		model.addAttribute("mode", mode);
		model.addAttribute("userName", userName);
		
		return "ezCommunity/communityAdminMemberListOkGo";
	}
	
	/**
	 * Cop 폐쇄신청화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminCommClose.do")
	public String adminCommClose(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("adminCommClose started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		CommunityClubVO club = ezCommunityService.aspCommInfoGet1(code, userInfo.getTenantId());
		CommunityMemberInfoVO member = ezCommunityService.aspCommInfoGet2(commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), club.getC_SysopID().trim(), userInfo.getTenantId());
		
		String sysopName = member.getUserName();
		
		if (sysopName.equals("")) {
			sysopName = egovMessageSource.getMessage("ezCommunity.t398", userInfo.getLocale());
		}
		
		String strCategoryPrint = ezCommunityService.categoryPrint(club.getC_Cate_A().trim(), club.getC_Cate_B().trim(), club.getC_Cate_C().trim(), userInfo);
				
		model.addAttribute("code", code);
		model.addAttribute("sysopName", sysopName);
		model.addAttribute("club", club);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("strCategoryPrint", strCategoryPrint);
		
		logger.debug("adminCommClose ended.");
		
		return "ezCommunity/communityAdminCommClose";
	}
	
	/**
	 * Cop 폐쇄신청 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminCommCloseOk.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String adminCommCloseOk(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("adminCommCloseOk started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String strXML = "";
		
		String code = request.getParameter("code");
		String reason = request.getParameter("reason");
		reason = reason.replace("'", "''");
		
		CommunityCComCloseVO closeVO = ezCommunityService.adminCommCloseOkGet1(code, userInfo.getTenantId());
		
		if (closeVO != null) {
			strXML = "<RETURN><VALUE>ExistApplication</VALUE></RETURN>";
		} else {
			CommunityClubVO clubVO = ezCommunityService.adminCommCloseOkGet2(code, userInfo.getTenantId());
			
			if (clubVO != null) {
				 String commName = clubVO.getC_ClubName().trim();
                 commName = commName.replace("'", "''");
                 // 20100108 : 폐쇄신청 \" -> "로 나오도록 수정
                 //commName = commName.Replace("\"", "\\\"");

                 String commName2 = clubVO.getC_ClubName2().trim();
                 commName2 = commName2.replace("'", "''");
                 // 20100108 : 폐쇄신청 \" -> "로 나오도록 수정
                 //commName2 = commName2.Replace("\"", "\\\"");

                 String sysopID = clubVO.getC_SysopID().trim();
                 String companyName = userInfo.getCompanyName1();
                 
                 ezCommunityService.adminCommCloseOkInsert(code, commName, commName2, sysopID, companyName, commonUtil.getTodayUTCTime(""), reason, egovMessageSource.getMessage("ezCommunity.t483", userInfo.getLocale()), userInfo.getTenantId());
                 
                 strXML = "<RETURN><VALUE>SuccessApplication</VALUE></RETURN>";
			}
		}
		
		logger.debug("adminCommCloseOk ended.");
		
		return strXML;
	}
	
	/**
	 * 메인페이지화면 호출 함수
	 */
	@RequestMapping(value = "/ezCommunity/mainPage.do")
	public String mainPage(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("mainPage started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useIE11Browser = ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId());
		
		int totalPage = ezCommunityService.mainPage(userInfo);
		
		model.addAttribute("useIE11Brower", useIE11Browser);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("totalPage", totalPage);
		
		logger.debug("mainPage ended.");
		
		return "ezCommunity/communityMainPage";
	}
	
	/**
	 * My 커뮤니티 새글 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/myCopNewBoardItem.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String myCopNewBoardItem (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("myCopNewBoardItem started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int page = Integer.parseInt(request.getParameter("page"));
		int startRow = (3 * (page - 1)) + 1;
		int endRow = 3 * page;
		
		logger.debug("page : " + page + ", startRow : " + startRow + ", endRow : " + endRow);
		
		String result = ezCommunityService.myCopNewBoardItem(userInfo, startRow, endRow);
		
		logger.debug("result : " + result);
		logger.debug("myCopNewBoardItem ended.");
		
		return result;
	}
	
	/**
	 * 우수커뮤니티/ 신규커뮤니티 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getBestNewCommunity.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getBestNewCommunity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getBestNewCommunity started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = request.getParameter("mode");
		
		logger.debug("getBestNewCommunity ended.");
		
		return ezCommunityService.getBestNewCommunity(userInfo, mode);
	}
	
	/**
	 * 회원가입화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/join1.do")
	public String join1(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("join1 started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String no = request.getParameter("no");
		
		String clubName = ezCommunityService.join1Get(no, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		model.addAttribute("clubName", clubName);
		model.addAttribute("no", no);
		
		logger.debug("join1 ended.");
		
		return "ezCommunity/communityJoin1";
	}
	
	/**
	 * 회원가입화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/join2.do")
	public String join2(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("join2 started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String no = request.getParameter("no");
		
		String clubName = ezCommunityService.join1Get(no, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		model.addAttribute("clubName", clubName);
		model.addAttribute("no", no);
		
		logger.debug("join2 ended.");
		
		return "ezCommunity/communityJoin2";
	}
	
	/**
	 * 회원가입화면 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/agreeOk.do")
	public String agreeOk(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("agreeOk started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean bCanJoin = true;
		
		String code = request.getParameter("code");
		
		String userLevel = ezCommunityService.pollMainGet1(userInfo.getId(), code, userInfo.getTenantId());
		
		if (userLevel != null) {
			bCanJoin = false;
		}
		
		model.addAttribute("code", code);
		model.addAttribute("bCanJoin", bCanJoin);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("userLevel", userLevel);
		
		logger.debug("agreeOk ended.");
		
		return "ezCommunity/communityAgreeOk";
	}
	
	/**
	 * 회원가입 정보입력화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/join.do")
	public String join(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("join started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		int tenantID = userInfo.getTenantId();

		CommunityClubVO clubVO = ezCommunityService.adminNoticeMailOkGet1(code, tenantID);
		String clubName = ezCommunityService.joinGet1(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), tenantID);
		String sysUserName = ezCommunityService.joinGet2(clubVO.getC_SysopID().trim(), clubVO.getCompanyID(), commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), tenantID);
		
		clubVO.setC_ClubName(clubName);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("code", code);
		model.addAttribute("clubVO", clubVO);
		model.addAttribute("sysUserName", sysUserName);

		logger.debug("join ended.");
		
		return "ezCommunity/communityJoin";
	}
	
	/**
	 * 회원가입 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/joinOk.do")
	public String joinOk(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("joinOk started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String id = userInfo.getId();
		int tenantID = userInfo.getTenantId();
		boolean bCanJoin = true;
		String openJob = "0", openBirth = "0";
		
		String code = request.getParameter("code");
		String cIntro = request.getParameter("cIntro");
		String birthType = request.getParameter("birthType");
		String birthYear = request.getParameter("birthYear");
		String openEmail = request.getParameter("openEmail");
		String openHp = request.getParameter("openHp");
		String openComp = request.getParameter("openComp");
		String openHouse = request.getParameter("openHouse");
		String openSex = request.getParameter("openSex");
		String birthDay = request.getParameter("birthDay ");
		String birthMonth = request.getParameter("birthMonth");
		String gender = request.getParameter("gender");
		
		if(request.getParameter("openBirth") != null) {
			openBirth = request.getParameter("openBirth");
		}
		
		String userLevel = ezCommunityService.joinOkGet1(code, id, tenantID);
		
		if (userLevel != null) {
			bCanJoin = false;
		}
		
		ezCommunityService.joinOkSet1(code, id, commonUtil.getTodayUTCTime(""), userInfo.getCompanyID(), tenantID);
		
		String cID = ezCommunityService.joinOkGet2(code, id, tenantID);
		CommunityClubVO clubVO = ezCommunityService.joinOkGet3(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), tenantID);

		if(clubVO.getC_ClubConfirmType().equals("1") || clubVO.getC_ClubConfirmType().equals("2")) {
			if (openBirth.equals("1")) {
				birthDay = birthType + birthYear + "-" + birthMonth + "-" + birthDay;
			} else {
				birthDay = "";
			}
			
			ezCommunityService.joinOkUpdate1(id, code, cIntro, openEmail, openHp, openComp, openBirth, openSex, openHouse, tenantID);
			CommunityMemberInfoVO memberInfoVO = ezCommunityService.joinOkGet4(userInfo.getCompanyID(), id, tenantID);
			
			if (memberInfoVO != null) {
				ezCommunityService.joinOkUpdate3(userInfo.getCompanyID(), id, birthDay, tenantID);
			} else {
				ezCommunityService.joinOkInsert(userInfo.getCompanyID(), id, userInfo.getDisplayName1(), userInfo.getDisplayName2(), userInfo.getCompanyName1(), userInfo.getCompanyName2(), "", "", userInfo.getDeptName1(), userInfo.getDeptName2(), "", "", "", userInfo.getPhone(), userInfo.getEmail(), birthDay, gender, tenantID);
			}
			
			
		} else {
			if (clubVO.getC_ClubConfirmType().equals("3")) {
				ezCommunityService.joinOkUpdate2(id, code, cIntro, openEmail, openHp, openComp, openHouse, openJob, openBirth, openSex, tenantID);

				if (openBirth.equals("1")) {
					birthDay = birthType + birthYear + "-" + birthMonth + "-" + birthDay;
				} else {
					birthDay = "";
				}
				
				ezCommunityService.joinOkUpdate1(id, code, cIntro, openEmail, openHp, openComp, openBirth, openSex, openHouse, tenantID);
				CommunityMemberInfoVO memberInfoVO = ezCommunityService.joinOkGet4(userInfo.getCompanyID(), id, tenantID);
				
				if (memberInfoVO != null) {
					ezCommunityService.joinOkUpdate3(userInfo.getCompanyID(), id, birthDay, tenantID);
				} else {
					ezCommunityService.joinOkInsert(userInfo.getCompanyID(), id, userInfo.getDisplayName1(), userInfo.getDisplayName2(), userInfo.getCompanyName1(), userInfo.getCompanyName2(), "", "", userInfo.getDeptName1(), userInfo.getDeptName2(), "", "", "", userInfo.getPhone(), userInfo.getEmail(), birthDay, gender, tenantID);
				}
			}
		}
		
		clubVO.setC_ClubNo(code);
		ezCommunityService.joinOkSendMail(loginCookie, userInfo, clubVO);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("code", code);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("bCanJoin", bCanJoin);
		model.addAttribute("cID", cID);
		model.addAttribute("clubVO", clubVO);
		
		logger.debug("joinOk ended.");
		
		return "ezCommunity/communityJoinOk";
	}
	
	/**
	 * 승인필요한 커뮤니티 가입시 검사 실행 함수
	 */
	@RequestMapping(value = "/ezCommunity/remote/getACL.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String remoteGetACL (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("remoteGetACL started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String cID = request.getParameter("cID");
		String uID = request.getParameter("uID");

		String gClubG = ezCommunityService.getACLGet1(cID, userInfo.getTenantId());
		String cPermit = ezCommunityService.getACLGet2(uID, cID, userInfo.getTenantId());
		logger.debug("gClubG=" + gClubG + " || cPermit=" + cPermit);
		
		if (cPermit == null || cPermit.equals("0")) {
			if (gClubG.trim().equals("3")) {
				logger.debug("remoteGetACL ended. if if");
				return "ERR";
			} else if (gClubG.trim().equals("2")) {
				logger.debug("remoteGetACL ended. if elseif");
				return "OK";
			} else {
				logger.debug("remoteGetACL ended. if else");
				return "";
			}
		} else {
			logger.debug("remoteGetACL ended. else ");
			return "OK";
		}
	}
	
	/**
	 * OpenAlertUI 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/ezAprAlert.do")
	public String ezAprAlert () {
		return "ezCommunity/communityAprAlert";
	}
	
	/**
	 * OpenInformationUI 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/ezAPROPINION.do")
	public String ezAPROPINION () throws Exception {
		logger.debug("ezAPROPINION started.");
		logger.debug("ezAPROPINION ended.");
		return "ezCommunity/communityAprOption";
	}
	
	/**
	 * 비공개 커뮤니티 가입/미가입 체크 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/getIsJoin.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getIsJoin (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getIsJoin started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		String cPermit = ezCommunityService.leftCommunityGet1(code, userInfo.getId(), userInfo.getTenantId());
		
		if (cPermit != null) {
			logger.debug("getIsJoin ended. true");
			
			return "TRUE";
		} else {
			logger.debug("getIsJoin ended. false");
			
			return "FALSE";
		}
	}
	
	/**
	 * 커뮤니티 가입희망자 승인화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminMemPermit.do")
	public String adminMemPermit(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");

		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		int postCount = ezCommunityService.adminMemPermitGet1(code, userInfo.getTenantId());		
		String idSpanValue = ezCommunityService.adminMemPermit(userInfo, code);
		
		model.addAttribute("code", code);
		model.addAttribute("postCount", postCount);
		model.addAttribute("idSpanValue", idSpanValue);
		return "ezCommunity/communityAdminMemPermit";
	}
	
	/**
	 * 커뮤니티 가입희망자 승인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminOkNo.do")
	public String adminOkNo(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("adminOkNo started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String flag = request.getParameter("flag");
		String cID = request.getParameter("cID");
		String result = "";
		
		logger.debug("code : " + code + ", flag : " + flag + ", cID : " + cID);
		
		int postCount = ezCommunityService.adminMemPermitGet1(code, userInfo.getTenantId());		
		String idSpanValue = ezCommunityService.adminMemPermit(userInfo, code);
		
		try {
			ezCommunityService.okNoSet(flag.toUpperCase(), code, cID, userInfo.getTenantId());
			ezCommunityService.okNoSetSendMail(loginCookie, userInfo, flag.toUpperCase(), code, cID);
			
			result = "true";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			
			result = "false";
		}
		
		model.addAttribute("result", result);
		model.addAttribute("postCount", postCount);
		model.addAttribute("idSpanValue", idSpanValue);
		logger.debug("adminOkNo ended.");
		
		return "json";
	}
	
	/**
	 * 오늘의 커뮤니티 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/todayCop.do", method = RequestMethod.POST)
	public String todayCop(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("todayCop started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		int num = 0, itemCnt = 0;
		String cCatecAName = "", cCatecBName = "";
		
		Calendar calendar = Calendar.getInstance();
		int dayOfYear = calendar.get(Calendar.DAY_OF_YEAR);
		
		int rtnVal = ezCommunityService.todayCopGet1(userInfo.getTenantId());
		
		if (rtnVal == 0) {
			num = 1;
		} else {
			num = (dayOfYear % rtnVal) + 1;
		}
		
		CommunityClubVO club = ezCommunityService.todayCopGet2(num, userInfo.getTenantId());
		
		if (club != null) {
			if (!club.getC_Cate_A().equals("0")){
				cCatecAName = ezCommunityService.todayCopGet3(club.getC_Cate_A(), "A", userInfo.getTenantId());
			}
			
			if (!club.getC_Cate_B().equals("0")){
				cCatecBName = ezCommunityService.todayCopGet3(club.getC_Cate_B(), "B", userInfo.getTenantId());
			}
			
			itemCnt = ezCommunityService.categoryListItemCntGet(club.getC_ClubNo(), userInfo.getTenantId());
		}
		
		model.addAttribute("clubVO", club);
		model.addAttribute("cCateAName", cCatecAName);
		model.addAttribute("cCateBName", cCatecBName);
		model.addAttribute("itemCnt", itemCnt);
		
		logger.debug("todayCop ended.");
		
		return "json";
	}
	
	/**
	 * 카테고리별 커뮤니티화면 업무별/종류별 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/myCategoryCop.do")
	public String myCategoryCop (@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("mainPageCategory started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = request.getParameter("mode");
		
		List<CommunityCCategoryVO> list = new ArrayList<CommunityCCategoryVO>();
		
		if (mode.equals("A")) {
			List<CommunityCCategoryVO> categoryList= ezCommunityService.mainPageGet4("a", userInfo.getTenantId());
			for(CommunityCCategoryVO category : categoryList) {
				CommunityCCategoryVO vo = ezCommunityService.mainPageCategory(category.getC_Code(), "a", userInfo.getTenantId());
				if (vo != null) {
					list.add(vo);
				}
			}
		} else {
			List<CommunityCCategoryVO> categoryList= ezCommunityService.mainPageGet4("b", userInfo.getTenantId());
			
			for(CommunityCCategoryVO category : categoryList) {
				CommunityCCategoryVO vo = ezCommunityService.mainPageCategory(category.getC_Code(), "b", userInfo.getTenantId());
				if (vo != null) {
					list.add(vo);
				}
			}
		}
		
		logger.debug("mainPageCategory ended.");
		
		model.addAttribute("list", list);
		
		return "json";
	}
	
	/**
	 * 카테고리별 커뮤니티화면 업무별/종류에 따른 커뮤니티목록  호출함수
	 */
	@RequestMapping(value = "/ezCommunity/categoryCopList.do")
	public String categoryCopList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = request.getParameter("mode");
		String type = request.getParameter("type");
		int page = Integer.parseInt(request.getParameter("page"));
		
		int startRow = (5 * (page - 1)) + 1;
		int endRow = 5 * page;
		
		List<CommunityClubVO> clubList = ezCommunityService.categoryListGet(type, mode, startRow, endRow, userInfo.getTenantId());
		
		for (CommunityClubVO club : clubList) {
			club.setItemCnt(ezCommunityService.categoryListItemCntGet(club.getC_ClubNo(), userInfo.getTenantId()));
		}
		
		model.addAttribute("list", clubList);
		
		return "json";
	}
	
	/**
	 * 카테고리별 커뮤니티 검색기능 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/searchCop.do")
	public String searchCop(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("searchCop started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String search = "";
		
		String option = request.getParameter("option");
		String keyword = request.getParameter("keyword");
		int page = Integer.parseInt(request.getParameter("page"));
		
		int startRow = (5 * (page - 1)) + 1;
		int endRow = 5 * page;
		
		if (option.equals("NAME")) {
			if (commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()).equals("")) {
				search = "C_CLUBNAME";
			} else {
				search = "C_CLUBNAME2";
			}
		} else {
			search = "C_CLUBDESC";
		}
		
		List<CommunityClubVO> clubList = ezCommunityService.searchCop(search, keyword, startRow, endRow, "SEA", userInfo.getTenantId());
		List<CommunityClubVO> clubCopCnt = ezCommunityService.searchCop(search, keyword, startRow, endRow, "CNT", userInfo.getTenantId());
		
		for (CommunityClubVO club : clubList) {
			if (clubList.indexOf(club) == 0 ) { 
				clubList.get(0).setCopCnt(clubCopCnt.get(0).getCopCnt());
			}
			
			club.setItemCnt(ezCommunityService.categoryListItemCntGet(club.getC_ClubNo(), userInfo.getTenantId()));
		}
		
		model.addAttribute("list", clubList);
		
		logger.debug("searchCop ended.");
		
		return "json";
	}
	
	/**
	 * 포토게시판 목록화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemListPhoto.do")
	public String boardItemListPhoto(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		String useIE11Browser = "";
		String userLevel = "0", pSortBy = "", showAdjacent = "", strXML = "";
		int pPage = 1, totalPage = 1, totalCount = 0;
		
		if (commonUtil.checkIE(request) && ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId()).equals("CK")) {
            useIE11Browser = "CK";
		}
		
		if (request.getParameter("sortBy") != null) {
			pSortBy = request.getParameter("sortBy");
		}
		if (request.getParameter("page") != null) {
			pPage = Integer.parseInt(request.getParameter("page"));
		}
		
		String boardID = request.getParameter("boardID");
		String code = request.getParameter("code");
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), "", boardID, userInfo.getRollInfo(), 0, response, userInfo)) {
			return "cmm/error/egovError";
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		
		
		CommunityClubVO club = ezCommunityService.boardItemListPhotoGet1(userInfo.getId(), boardID, userInfo.getTenantId());
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName2());
			userInfo.setDisplayName1(userInfo.getDisplayName2());
		}
		
		if (club == null) {
			userLevel = "0";
		} else {
			if (club.getPermit().equals("0")) {
				userLevel = "9";
			} else {
				userLevel = club.getPermit();
			}
		}
		
		int pStartRow = (pPage - 1) * boardInfo.getSs_SearchBoard_MaxRows() + 1;
	    int pEndRow = pPage * boardInfo.getSs_SearchBoard_MaxRows();
	    
	    if (boardInfo.getBoardID().equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
	    	strXML = ezCommunityService.getNewItemListXML(userInfo, pStartRow, pEndRow, pSortBy);
	    	totalCount = ezCommunityService.getNewItemListCount(userInfo.getId(), userInfo.getTenantId());
	    } else {
	    	showAdjacent = "1";
	    	strXML = ezCommunityService.getBoardListItemPhotoXML(userInfo, boardInfo.getBoardID(), pStartRow, pEndRow, pSortBy);
	    	totalCount = ezCommunityService.getBoardTotalItemCount(boardInfo.getBoardID(), userInfo.getTenantId());
	    }
	    
	    if (totalCount > 0) {
			if (totalCount > boardInfo.getSs_Board_MaxRows()) {
				if(totalCount % boardInfo.getSs_Board_MaxRows() > 0) {
					totalPage = totalCount / boardInfo.getSs_Board_MaxRows() + 1;
				} else {
					totalPage = totalCount / boardInfo.getSs_Board_MaxRows();
				}
			} else {
				totalPage = 1;
			}
		} else {
			totalPage = 1;
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("code", code);
		model.addAttribute("pSortBy", pSortBy);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("strXML", strXML);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("page", pPage);
		
		return "ezCommunity/communityBoardItemListPhoto";
	}
	
	/**
	 * 포토게시판 쓰기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/newBoardItemPhoto")
	public String newBoardItemPhoto (@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String pUploadFilePath = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		CommunityBoardItemVO item = null;
		CommunityBoardPropertyVO boardInfo = null;
		String url = "", startDateTime = "", endDateTime = "", expireDays = "", itemID = "";
		/*String strAbstract = "";*/
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		String boardID = request.getParameter("boardID");
		String mode = request.getParameter("mode");
		
		if (request.getParameter("itemID") != null) {
			itemID = request.getParameter("itemID");
		}
		if (request.getParameter("url") != null) {
			url = request.getParameter("url");
		}
		
		// 20100119 보안처리 관련 추가작업(권한체크)
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), "", boardID, userInfo.getRollInfo(), 1, response, userInfo)) {
			return "cmm/error/egovError";
		}
		
		if (!url.equals("")) {
			startDateTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false);
			endDateTime = EgovDateUtil.addDay(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false), 30, "yyyy-MM-dd");
			expireDays = "-1";
		} else {
			boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
			
			if (userInfo.getLang().equals("2")) {
				boardInfo.setBoardName(boardInfo.getBoardName2());
			}
			
			expireDays = boardInfo.getExpireDays();
			
			if (!mode.equals("new")) {
				item = ezCommunityService.getItemXML(boardID, itemID, userInfo);
				
				if (mode.equals("reply")) {
					item.setTitle("[" + egovMessageSource.getMessage("ezCommunity.t1179", userInfo.getLocale()) + item.getTitle());
					item.setItemLevel(item.getItemLevel() + 1);
				} 
				/*else {
					strAbstract = item.getAbsTract();
				}*/				
			}
			
			startDateTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false);
			
			//만료일을 설정하는 부분
			if (mode.equals("modify")) { // 수정인 경우
				if (item.getEndDate().substring(0, 4).equals("9999")) { //영구게시인 경우
					if (expireDays.equals("-1")) { // 게시판 설정이 영구게시인 경우 만료일 컨트롤 값을 30일 뒤로 자동세팅
						endDateTime = EgovDateUtil.addDay(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false), 30, "yyyy-MM-dd");
					} else { // 게시판 설정이 영구게시가 아니면 설정된 만료일 만큼 뒤로 세팅
						endDateTime = EgovDateUtil.addDay(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false), Integer.parseInt(expireDays), "yyyy-MM-dd");
					}
				} else { // 수정 전에 설정되었던 만료일로 세팅함
					endDateTime = item.getEndDate().split(" ")[0];
				}
			} else { //새 게시나 답변인 경우
				if (expireDays.equals("-1")) {
					endDateTime = EgovDateUtil.addDay(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false), 30, "yyyy-MM-dd"); 
				} else {
					endDateTime = EgovDateUtil.addDay(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false), Integer.parseInt(expireDays), "yyyy-MM-dd");
				}
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("editor", editor);
		model.addAttribute("pUploadPath", pUploadFilePath);
		model.addAttribute("pMode", mode);
		model.addAttribute("pUrl", url);
		model.addAttribute("strNow", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("item", item);
		model.addAttribute("expireDays", expireDays);
		model.addAttribute("startDateTime", startDateTime);
		model.addAttribute("endDateTime", endDateTime);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		return "ezCommunity/communityNewBoardItemPhoto";
	}
	
	/**
	 * 포토게시판 쓰기 실행함수
	 */
	@RequestMapping(value ="/ezCommunity/saveItemPhoto.do")
	@ResponseBody
	public String saveItemPhoto (@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData, Model model, HttpServletRequest request) throws Exception {
		logger.debug("saveItemPhoto started.");
		logger.debug(xmlData);
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlData);
		String mode = request.getParameter("mode");
		
		String ret = "";
		
		String attachList = xmlDom.getElementsByTagName("ATTACHMENTS").item(0).getTextContent();
		String smallName = xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
		String fileName = xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent();
		String title = xmlDom.getElementsByTagName("TITLE").item(0).getTextContent();
		String itemID = xmlDom.getElementsByTagName("ITEMID").item(0).getTextContent();
		
		logger.debug("attachList : " + attachList + ", smallName : " + smallName + ", fileName : " + fileName + ", title : " + title + ", itemID : " + itemID);
		
		String[] attachArray = attachList.split(";");
        String[] smallArray = smallName.split(";");
        String[] itemIDArray = itemID.split(";");
        String[] fileNameArray = fileName.split(";");

        if (attachArray.length == smallArray.length) {
        	for (int i = 0; i < attachArray.length; i++) {
        		xmlDom.getElementsByTagName("ATTACHMENTS").item(0).setTextContent(attachArray[i] + ";");
        		xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).setTextContent(smallArray[i]);
        		xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).setTextContent(fileNameArray[i]);
        		xmlDom.getElementsByTagName("ITEMID").item(0).setTextContent(itemIDArray[i]);
        		xmlDom.getElementsByTagName("UPPERITEMIDTREE").item(0).setTextContent(itemIDArray[i]);
        		
        		if (attachArray.length > 2) {
        			xmlDom.getElementsByTagName("TITLE").item(0).setTextContent(title + "_" + Integer.toString(i + 1));
        		}
        		
        		if (i > 0) {
        			mode = "New";
        			xmlDom.getElementsByTagName("STARTDATE").item(0).setTextContent(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
        		}
        		
        		ret = ezCommunityService.newItem(xmlDom, mode, commonUtil.getRealPath(request), userInfo);
        	}
        }
        
        logger.debug("saveItemPhoto ended.");
        
		return ret;
	}
	
	/**
	 * 포토게시판 앍기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemViewPhoto.do")
	public String boardItemViewPhoto(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String oneLineReplyFlag = ezCommonService.getTenantConfig("ONELINE_REPLY_ENABLE", userInfo.getTenantId());
        String adjacentItemsEnableFlag = ezCommonService.getTenantConfig("ADJACENT_ITEMS_ENABLE", userInfo.getTenantId());
        
        String useIE11Browser = "", showAdjacent = "", pReservedItem = "", itemID = "";
        String previousItemID = "", previousTitle = "", nextItemID = "", nextTitle = "";
        String gImageUrl = "", gWidth = "", gHeight = "";
        
		String boardID = request.getParameter("boardID");
		
		if (commonUtil.checkIE(request) && ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId()).equals("CK")) {
            useIE11Browser = "CK";
		}
		
		if (request.getParameter("itemID") != null) {
			itemID = request.getParameter("itemID");
		}
		if (request.getParameter("pReservedItem") != null) {
			pReservedItem = request.getParameter("pReservedItem");
		}
		if (request.getParameter("showAdjacent") != null) {
			showAdjacent = request.getParameter("showAdjacent");
		}
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), "", boardID, userInfo.getRollInfo(), 0, response, userInfo)) {
			return "cmm/error/egovError";
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		
		if (!boardInfo.getRead_FG().equals("true")) {
			response.getWriter().print("<html><head><title>" + egovMessageSource.getMessage("ezCommunity.t175", userInfo.getLocale()) + "</title></head><body><table border=0 width=100% height=100%><tr><td align=center valign=center>" + egovMessageSource.getMessage("ezCommunity.t980", userInfo.getLocale()) + "</td></tr></table></body></html>");
			response.getWriter().flush();
		}
		
		CommunityBoardItemVO item = ezCommunityService.getItemXML(boardID, itemID, userInfo);
		ezCommunityService.setAsRead(userInfo, boardID, itemID);
		
		if (item == null) {
			return response.encodeRedirectURL("/error.do");
		}
		
		if (EgovDateUtil.getDaysDiff(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("YYYY-MM-DD"), userInfo.getOffset(), false), item.getParentWriteDate().substring(0, 10)) > 0) {
			pReservedItem = "true";
		}
		
		if (EgovDateUtil.getDaysDiff(item.getParentWriteDate().substring(0, 10), item.getWriteDate().substring(0, 10)) > 0) {
			item.setWriteDate(item.getParentWriteDate());
		}
		
		if (item.getEndDate().substring(0, 4).equals("9999")) {
			item.setEndDate(egovMessageSource.getMessage("ezCommunity.t930", userInfo.getLocale()));
		}
		
		if (adjacentItemsEnableFlag.equals("1") && showAdjacent.equals("1")) {
			Map<String, String> map = ezCommunityService.getAdjacentItemsPhoto(boardID, item, userInfo.getTenantId(), userInfo.getOffset());
			
            previousItemID = map.get("previousItemID");
            previousTitle = map.get("previousTitle");
            nextItemID = map.get("nextItemID");
            nextTitle = map.get("nextTitle");

			if (previousTitle.equals("")) {
				previousTitle = egovMessageSource.getMessage("ezCommunity.t193", userInfo.getLocale());
			}
			
			if (nextTitle.equals("")) {
				nextTitle = egovMessageSource.getMessage("ezCommunity.t191", userInfo.getLocale());
			}
		}
		
		if (item.getExtensionAttribute5().length() > 0) {
			item.setExtensionAttribute5(item.getExtensionAttribute5().replace("/uploadFile//s_", "/uploadFile/"));
			item.setExtensionAttribute5(item.getExtensionAttribute5().replace("/uploadFile/s_", "/uploadFile/"));
			String pFilePath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator + item.getExtensionAttribute5();
			gImageUrl = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&boardID=" + boardID + "&fileName=" + item.getExtensionAttribute5();
			
			File file = new File(pFilePath);
			
			if (file.exists()) {
				BufferedImage image = ImageIO.read(file);
				
				if (image.getWidth() > 600) {
					gWidth = "600";
					gHeight = Integer.toString(image.getHeight() * Integer.parseInt(gWidth) / image.getWidth());
				} else {
					gWidth = Integer.toString(image.getWidth());
					gHeight = Integer.toString(image.getHeight());
				}
			} else {
				gWidth = "600";
				gHeight = "450";
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("oneLineReplyFlag", oneLineReplyFlag);
		model.addAttribute("adjacentItemsEnableFlag", adjacentItemsEnableFlag);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("pReservedItem", pReservedItem);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("item", item);
		model.addAttribute("previousItemID", previousItemID);
		model.addAttribute("previousTitle", previousTitle);
		model.addAttribute("nextItemID", nextItemID);
		model.addAttribute("nextTitle", nextTitle);
		model.addAttribute("gImageUrl", gImageUrl);
		model.addAttribute("gWidth", gWidth);
		model.addAttribute("gHeight", gHeight);
		
		return "ezCommunity/communityBoardItemViewPhoto";
	}
	
	/**
	 * 포토게시판 인쇄화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemViewPrint.do")
	public String boardItemViewPrint(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String oneLineReplyFlag = ezCommonService.getTenantConfig("ONELINE_REPLY_ENABLE", userInfo.getTenantId());
		String pReservedItem = "";
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		
		if (request.getParameter("pReservedItem") != null) {
			pReservedItem = request.getParameter("pReservedItem");
		}

		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		CommunityBoardItemVO item = ezCommunityService.getItemXML(boardID, itemID, userInfo);
		
		if (EgovDateUtil.getDaysDiff(item.getParentWriteDate().substring(0, 10), item.getWriteDate().substring(0, 10)) > 0) {
//			item.setWriteDate(commonUtil.getDateStringInUTC(item.getParentWriteDate(), userInfo.getOffset(), false));
			item.setWriteDate(item.getParentWriteDate());
		}
		
		if (item.getEndDate().substring(0, 4).equals("9999")) {
			item.setEndDate(egovMessageSource.getMessage("ezCommunity.t930", userInfo.getLocale()));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("oneLineReplyFlag", oneLineReplyFlag);
		model.addAttribute("pBoardID", boardID);
		model.addAttribute("pItemID", itemID);
		model.addAttribute("pReservedItem", pReservedItem);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("item", item);
		
		return "ezCommunity/communityBoardItemViewPrint";
	}

	/**
	 * 
	 */
	@RequestMapping(value = "/ezCommunity/colorPicker.do")
	public String colorPicker() {
		return "ezCommunity/communityColorPicker";
	}
	
	/**
	 * Email관련
	 */
	@RequestMapping(value = "/ezCommunity/getItemInfo.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getItemInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getItemInfo started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pBoardID = request.getParameter("boardID");
		String pItemID = request.getParameter("itemID");
		
		StringBuilder sb = new StringBuilder();
		sb.append("<NODES>");
		
		try {
			CommunityBoardItemVO itemVO = ezCommunityService.getItemXML(pBoardID, pItemID, userInfo);
//			itemVO.setWriteDate(commonUtil.getDateStringInUTC(itemVO.getWriteDate(), userInfo.getOffset(), false));
			
			if (itemVO != null) {
				sb.append("<NODE>");
				sb.append("<ItemID>" + itemVO.getItemID() + "</ItemID>");
				sb.append("<WriterID>" + ( itemVO.getWriterID() == null ? "" : itemVO.getWriterID() ) + "</WriterID>");
				sb.append("<WriterName>" + itemVO.getWriterName() + "</WriterName>");
				sb.append("<WriterDeptName>" + ( itemVO.getWriterDeptName() == null ? "" : itemVO.getWriterDeptName() ) + "</WriterDeptName>");
				sb.append("<WriterCompanyName>" + ( itemVO.getWriterCompanyName() == null ? "" : itemVO.getWriterCompanyName() ) + "</WriterCompanyName>");
				sb.append("<WriteDate>" + itemVO.getWriteDate() + "</WriteDate>");
				sb.append("<ParentWriteDate>" + itemVO.getParentWriteDate() + "</ParentWriteDate>");
				sb.append("<Importance>" + itemVO.getImportance() + "</Importance>");
				sb.append("<Title>" + itemVO.getTitle() + "</Title>");
				sb.append("<ContentLocation>" + itemVO.getContentLocation() + "</ContentLocation>");
				sb.append("<StartDate>" + itemVO.getStartDate() + "</StartDate>");
				sb.append("<EndDate>" + itemVO.getEndDate() + "</EndDate>");
				sb.append("<Abstract>" + itemVO.getAbsTract() + "</Abstract>");
				sb.append("<Attachments>" + itemVO.getAttachments() + "</Attachments>");
				sb.append("<UpperItemIDTree>" + itemVO.getUpperItemIDTree() + "</UpperItemIDTree>");
				sb.append("<ItemLevel>" + itemVO.getItemLevel() + "</ItemLevel>");
				sb.append("<copiedItem>" + itemVO.getCopiedItem() + "</copiedItem>");
				sb.append("<ExtensionAttribute1>" + itemVO.getExtensionAttribute1() + "</ExtensionAttribute1>");
				sb.append("<ExtensionAttribute2>" + itemVO.getExtensionAttribute2() + "</ExtensionAttribute2>");
				sb.append("<ExtensionAttribute3>" + ( itemVO.getExtensionAttribute3() == null ? "" : itemVO.getExtensionAttribute3() ) + "</ExtensionAttribute3>");
				sb.append("<ExtensionAttribute4>" + itemVO.getExtensionAttribute4() + "</ExtensionAttribute4>");
				sb.append("<ExtensionAttribute5>" + itemVO.getExtensionAttribute5() + "</ExtensionAttribute5>");
				sb.append("</NODE>");
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		sb.append("</NODES>");
		
		logger.debug("getItemInfo ended.");
		
		return sb.toString();
	}
	
	/*
	 * 커뮤니티 관리메뉴 전체메일보내기 화면 조회
	 */
	@RequestMapping(value = "/ezCommunity/adminNoticeMail.do")
	public String adminNoticeMail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("adminNoticeMail started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		model.addAttribute("code", code);
		
		logger.debug("adminNoticeMail ended.");
		
		return "ezCommunity/communityAdminNoticeMail";
	}
	
	/*
	 * 커뮤니티 관리메뉴 전체메일보내기 화면 조회
	 */
	@RequestMapping(value = "/ezCommunity/adminNoticeMailOk.do")
	public String adminNoticeMailOk(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("adminNoticeMailOk started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String subject = request.getParameter("subject");
		String memo = request.getParameter("memo");
		int tenantID = userInfo.getTenantId();
		
		CommunityClubVO clubVO = ezCommunityService.adminNoticeMailOkGet1(code, tenantID);
		
		if (clubVO.getC_SysopID() != null) {
			List<CommunityClubVO> list = ezCommunityService.adminNoticeMailOkGet2(code, tenantID);
			
			InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
        	
        	logger.debug("from = " + userInfo.getEmail());
        	
        	List<InternetAddress> to = new ArrayList<InternetAddress>();
        	
			for(CommunityClubVO vo : list) {
				if (vo.getEmail() != null) {
		        	InternetAddress to1 = new InternetAddress();
		        	to1.setPersonal(vo.getDisplayName(), "UTF-8");
		        	to1.setAddress(vo.getEmail());
		        	
		        	to.add(to1);
		        	
		        	logger.debug("to = " + vo.getEmail());
		        }
			}
			
			ezEmailService.sendMail(loginCookie, from, to.toArray(new InternetAddress[to.size()]), null, null, subject, memo, false);
			
			model.addAttribute("result", "OK");
		}
		
		logger.debug("adminNoticeMailOk ended.");
		
		return "json";
	}
}

