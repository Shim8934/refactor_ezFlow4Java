package egovframework.ezEKP.ezCommunity.web;

import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.Charset;
import java.security.PrivateKey;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
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
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardInfoVO;
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
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberGradeVO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.ezEKP.ezConn.util.EzConnUtil;
import org.w3c.dom.Node;

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
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="EzCommunityService")
	private EzCommunityService ezCommunityService;
	
	@Resource(name="EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCabinetAdminService")
	private EzCabinetAdminService cabinetAdminService;
	
	@Resource(name="EzNotificationService")
	private EzNotificationService ezNotificationService;
	
	@Autowired
	EzPersonalService ezPersonalService;
	
	@Autowired
	EzConnUtil ezConnUtil;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCommunityController.class);
	
	/**
	 * 커뮤니티 메인화면 호출함수
	 */
	@RequestMapping(value="/ezCommunity/communityMain.do", method = RequestMethod.GET)
	public String  main(HttpServletRequest request, Model model) {
		
		logger.debug("communityMain started.");

		String leftFrameWidth = "220";
		int width = 0;

		if (request.getParameter("__wwidth") != null) {
			String widthParam = request.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}

		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		logger.debug("communityMain ended.");
		
		return "ezCommunity/communityMain";
	}
	
	/**
	 * 왼쪽 메뉴화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/communityLeftCommunity.do", method = RequestMethod.GET)
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
        	
        	/* 2018-06-21 홍승비 - 자신이 가입한 커뮤니티 리스트 좌측표출 companyID 조건 추가 */
        	String vPermit = ezCommunityService.leftCommunityGet1(code, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
        	
        	if (vPermit==null) {
        		userLevel = "0";
        	} else {
        		userLevel = vPermit;
        	}
        	/* 2018-06-21 홍승비 - 자신이 가입한 커뮤니티 리스트 좌측표출 companyID 조건 추가 */
        	String clubConfirmType = ezCommunityService.leftCommunityGet2(code, userInfo.getCompanyID(), userInfo.getTenantId());
        	
        	if (clubConfirmType != null) {
        		newMemberConfirmtype = Integer.parseInt(clubConfirmType);
        	}
        	/* 2018-06-21 홍승비 - 자신이 가입한 커뮤니티 리스트 좌측표출 companyID 조건 추가 */
        	CommunityClubVO club = ezCommunityService.leftCommunityGet4(code, userInfo.getCompanyID(), userInfo.getTenantId());
        	
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
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		logger.debug("communityLeftCommunity ended.");
		
		return "ezCommunity/communityLeftCommunity";
	}

	/**
	 * 커뮤니티목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getLeftCommunity.do", method = RequestMethod.GET)
	public String getLeftCommunity(@CookieValue("loginCookie")String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		/* 2018-06-21 홍승비 - 자신이 가입한 커뮤니티 리스트 좌측표출 companyID 조건 추가 */
		List<CommunityClubVO> list = ezCommunityService.getLeftCommunity(userInfo, "");
		
		model.addAttribute("list", list);
		
        return "json"; 
	}
	
	/**
	 * 알림마당목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getLeftBoardList.do", method = RequestMethod.GET)
	public String getLeftBoardList(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<CommunityCBoardVO> list = ezCommunityService.getLeftBoardList(userInfo.getTenantId());
		
		model.addAttribute("list", list);
		
		return "json";
	}
	
	/**
	 * 커뮤니티 이미지 출력함수(ezCommon_Interface)
	 */
	@RequestMapping(value="/ezCommunity/getCommunityThumInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getCommunityThumInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
        String pType = request.getParameter("type");
        String imgUrl = request.getParameter("imgUrl");
		String pfileName = request.getParameter("fileName");
		String pFilePath = "", pBoardID = "";
		
		if (imgUrl == null) {
			imgUrl = pfileName;
		}
		
		if (request.getParameter("boardID") != null) {
			pBoardID = request.getParameter("boardID");
		}

		/* 2018-05-02 홍승비 - 커뮤니티 썸네일과 포토게시판 썸네일 경로 다르게 수정 */
		if (pType.toUpperCase().equals("COMMUNITYLOGO")) {
			pFilePath = ezCommunityService.getCommunityThumInfo(pBoardID, imgUrl, "LOGO", userInfo.getTenantId());			
		}
		else if (pType.toUpperCase().equals("COMMUNITYTHUM")) {			
			pFilePath = ezCommunityService.getCommunityThumInfo(pBoardID, imgUrl, "COMMUNITYTHUM", userInfo.getTenantId());				
		}
		else if (pType.toUpperCase().equals("COMMUNITYBOARD")) {
			pFilePath = ezCommunityService.getCommunityThumInfo(pBoardID, imgUrl, "COMMUNITYBOARD", userInfo.getTenantId());				
		}
		
		if (pFilePath != null && !pFilePath.equals("")) {
			downImage(pFilePath, request, response);
		}
	}

	/**
	 * 커뮤니티 만들기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/commMake.do", method = RequestMethod.GET)
	public String commMake(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		String langPrimary="", langSecondary="";
		
		langPrimary = ezCommonService.getTenantConfig("LangPrimary"+userInfo.getLang(), userInfo.getTenantId());
		langSecondary = ezCommonService.getTenantConfig("LangSecondary"+userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("userInfoDisplayName", userInfo.getLang().equals("1") ?  userInfo.getDisplayName1() : userInfo.getDisplayName2());
		model.addAttribute("idSpanValue", ezCommunityService.getCategory("", "", "", userInfo));
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		return "ezCommunity/communityCommMake";
	}
	
	/**
	 * 커뮤니티만들기 신청 함수
	 */
	@RequestMapping(value = "/ezCommunity/commMakeOk.do", method = RequestMethod.POST)
	@ResponseBody
	public void commMakeOk(@CookieValue("loginCookie")String loginCookie, CommunityClubVO clubVO, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		ezCommunityService.commMakeOk(userInfo, clubVO, request, response);
	}
	
	/**
	 * 게시판Tree 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getSubBoards.do", method = RequestMethod.POST)
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
		
		String result = ezCommunityService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, pClubID, userInfo.getPrimary(), userInfo.getTenantId());
		
		model.addAttribute("result", result);
		
		//logger.debug(result);
		logger.debug("getSubBoards ended.");
		
		return "json";
	}
	
	/**
	 * 관리자권한 확인 함수
	 */
	@RequestMapping(value = "/ezCommunity/goAdminOk.do", method = RequestMethod.POST)
	@ResponseBody
	public String goAdminOk(@CookieValue("loginCookie") String loginCookie, CommunityClubVO communityClubVO, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		StringBuilder resultXML = new StringBuilder();
		String data = request.getParameter("code");
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
	@RequestMapping(value = "/ezCommunity/checkCommHome.do", method = RequestMethod.GET)
	public String checkCommHome(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("checkCommHome started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("communityCD");
		String userLevel = "";
		
		if (!code.equals("")) {
			String vPermit = ezCommunityService.leftCommunityGet1(code, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
        	
        	if (vPermit == null) {
        		userLevel = "0";
        	} else {
        		userLevel = vPermit;
        	}
		}
		
		model.addAttribute("code", code);
		model.addAttribute("userLevel", userLevel);
		
		//logger.debug("userLevel = " + userLevel);
		logger.debug("checkCommHome ended.");
		
		return "ezCommunity/communityCheckCommHome";
	}
	
	/**
	 * 커뮤니티팝업화면 출력 함수
	 */
	@RequestMapping(value = "/ezCommunity/commHome/popupCommHome.do", method = RequestMethod.GET)
	public String popupCommHome(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("popupCommHome started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean joinFlag = false, checkSysop = false, memListFlag = false, chkOperator = false;
		int newMemberConfirmType = 0;
		String pastDate = "";
		
		String code = request.getParameter("code");
		String userLevel = request.getParameter("userLevel");
		String inviteFlag = request.getParameter("inviteFlag");

		// 20100119 보안처리 관련 추가작업(권한체크)
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response, userInfo, "", inviteFlag)) {
			return "cmm/error/egovError";
		}
		
		String strVisit = ezCommunityService.commHomeGet1(userInfo.getId(), code, userInfo.getTenantId());
		
		if (strVisit == null || !strVisit.substring(0, 10).equals(commonUtil.getTodayUTCTime(""))) {
			ezCommunityService.updateLastDate(commonUtil.getTodayUTCTime(""), code, userInfo.getId(), userInfo.getTenantId());
		}
		
		String copType = ezCommunityService.commHomeGet4(code, userInfo.getTenantId());
		
		if (copType == null) {
			copType = "type5";
		}

		/* 게시판 관련 작업 시작 */
		String boardGroupAdminFG = ezCommunityService.checkIfBoardGroupAdmin("top", userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId());
		int mode = 0;

		if (boardGroupAdminFG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 ||  userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1) {
			mode = 0;
		} else {
			mode = 1;
		}
		
		//logger.debug("mode : " + mode);
		String primary = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());
		String retXML = ezCommunityService.getBoardTree("top", userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), mode, 0, 0, " ", code, primary, userInfo.getTenantId());
		
		if (retXML.substring(0, 5).toUpperCase().equals("ERROR")) {
			retXML = "<RESULT>ERROR</RESULT>";
		}
		
		String permit = ezCommunityService.leftCommunityGet1(code, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());

		if (permit != null) {
			userLevel = permit;
			joinFlag = true;
		} else {
			userLevel = "0";
		}
		
		String confirmType = ezCommunityService.leftCommunityGet2(code, userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (confirmType != null) {
			newMemberConfirmType = Integer.parseInt(confirmType);
		}
		
		CommunityClubVO clubVO = ezCommunityService.leftCommunityGet4(code, userInfo.getCompanyID(), userInfo.getTenantId());

		if(clubVO != null) {
			if (userInfo.getId().equals(clubVO.getC_SysopID().trim())) {
				checkSysop = true;
			}
		}
		
		/* 2018-05-18 홍승비 - 새 글에 new 표시 추가 */
		pastDate = commonUtil.getTodayUTCTime("");
		pastDate = EgovDateUtil.addDay(pastDate, -1, "yyyy-MM-dd HH:mm:ss");
		pastDate = EgovDateUtil.addYMDtoDayTime(pastDate.substring(0, 10), pastDate.substring(11, 16), 0, 0, 0, 0, Integer.parseInt(commonUtil.getMinuteUTC(userInfo.getOffset())), "yyyy-MM-dd HH:mm:");
		pastDate = pastDate.concat(commonUtil.getTodayUTCTime("").substring(17,19));

		// 회원목록 조회가능 등급
		String readGrade = ezCommunityService.getMemListReadGrade(code, userInfo.getCompanyID(), userInfo.getTenantId());
		// 회원등급
		String userGrade = ezCommunityService.getUserGrade(code, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId()) != null ? ezCommunityService.getUserGrade(code, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId()) : "10";

		if (Integer.parseInt(userGrade) <= Integer.parseInt(readGrade)) {
			memListFlag = true;
		}

		// 운영자 권한정보
		List<CommunityCClubUserVO> operatorList = ezCommunityService.getClubOperatorList(userInfo.getCompanyID(), userInfo.getTenantId(), code, userInfo.getId());

		if (operatorList != null && !operatorList.isEmpty()) {
			if (operatorList.get(0).getAdmin_Auth() != null && !operatorList.get(0).getAdmin_Auth().equals("B")) {
				chkOperator = true;
			}
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("primary", primary);
		model.addAttribute("code", code);
		model.addAttribute("copType", copType);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("joinFlag", joinFlag);
		model.addAttribute("newMemberConfirmType", newMemberConfirmType);
		model.addAttribute("checkSysop", checkSysop);
		model.addAttribute("retXML", retXML);
		model.addAttribute("pastDate", pastDate);
		model.addAttribute("lang", userInfo.getLang()); // 2019-07-11 홍승비 - 다국어 지원용 lang 초가
		model.addAttribute("memListFlag", memListFlag);
		model.addAttribute("chkOperator", chkOperator);
		model.addAttribute("inviteFlag", inviteFlag);

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
	 * 커뮤니티 메인 오른쪽화면 게시판 조회 함수
	 */
	@RequestMapping(value = "/ezCommunity/commHome/commHomeBoardInfo.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/commHome/commHomeBoardItemList.do", method = RequestMethod.GET)
	public String commHomeBoardItemList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");

		/* 2018-05-18 홍승비 - UTC시간에 offset을 적용한 writeDate를 가져오기 위해 offset 추가*/
		List<CommunityBoardItemVO> list = ezCommunityService.commHomeBoardItemList(boardID, userInfo.getTenantId(), commonUtil.getMinuteUTC(userInfo.getOffset()));
		
		model.addAttribute("boardItemList", list);
		
		return "json";
	}
	/**
	 * 커뮤니티 게시판 목록화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemList.do", method = RequestMethod.GET)
	public String boardItemList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		//2018-07-13 김보미 - 파라메터 추가
		String treeCtrl = request.getParameter("treeCtrl");
		String code = request.getParameter("code");
		String boardID = request.getParameter("boardID");
		String boardName = request.getParameter("boardName");
		String inviteFlag = request.getParameter("inviteFlag");
		String userLevel = "";
		String pastDate = "";
		
		logger.debug("boarditemList started.");
		//logger.debug("code : " + code + ", boardID : " + boardID + ", boardName : " + boardName);
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response, userInfo, "", inviteFlag)) {
			return "cmm/error/egovError";
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, code);
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
		
		/* 2018-05-17 홍승비 - 새 글에 new 표시 추가 */
		pastDate = commonUtil.getTodayUTCTime("");
		pastDate = EgovDateUtil.addDay(pastDate, -1, "yyyy-MM-dd HH:mm:ss");
		pastDate = EgovDateUtil.addYMDtoDayTime(pastDate.substring(0, 10), pastDate.substring(11, 16), 0, 0, 0, 0, Integer.parseInt(commonUtil.getMinuteUTC(userInfo.getOffset())), "yyyy-MM-dd HH:mm:");
		pastDate = pastDate.concat(commonUtil.getTodayUTCTime("").substring(17,19));
		
		/* 2020-06-24 홍승비 - 커뮤니티 게시판명에 다국어 기본언어, 멀티언어 적용 */
		String multiBoardName = "";
		if (commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			multiBoardName = boardInfo.getBoardName();
		} else {
			multiBoardName = boardInfo.getBoardName2();
		}
		
		model.addAttribute("treeCtrl", treeCtrl);
		model.addAttribute("code", code);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pBoardName", boardName);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("pastDate", pastDate);
		model.addAttribute("multiBoardName", multiBoardName);
		model.addAttribute("inviteFlag", inviteFlag);

		logger.debug("boarditemList ended.");
		
		return "ezCommunity/communityBoardItemList";
	}
	
	/**
	 * 커뮤니티 검색화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/searchBoardItem.do", method = RequestMethod.GET)
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
		String inviteFlag = request.getParameter("inviteFlag");

		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, code);
		// 20100119 보안처리 관련 추가작업(권한체크)
        if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, boardID, userInfo.getRollInfo(), 0, response, userInfo, "", inviteFlag)) {
        	return "cmm/error/egovError";
        }
        
        int pStartRow = Math.addExact(Math.multiplyExact(Math.subtractExact(pPage, 1), boardInfo.getSs_SearchBoard_MaxRows()), 1);
        int pEndRow = Math.multiplyExact(pPage, boardInfo.getSs_SearchBoard_MaxRows());
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
        model.addAttribute("boardName", userInfo.getLang().equals("1") ? boardInfo.getBoardName() : boardInfo.getBoardName2());
        model.addAttribute("title", title);
        model.addAttribute("writerName", writerName);
        model.addAttribute("abstracts", abstracts);
        model.addAttribute("searchStart", searchStart);
        model.addAttribute("searchEnd", searchEnd);
        model.addAttribute("pPage", pPage);
        model.addAttribute("code", code);
        model.addAttribute("inviteFlag", inviteFlag);

		return "ezCommunity/communitySearchBoardItem";
	}
	
	/**
	 * 커뮤니티 검색화면 인쇄화면 호출 함수
	 */
	@RequestMapping(value = "/ezCommunity/searchBoardItemPrint.do", method = RequestMethod.GET)
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
		
		//logger.debug("title : " + title + ", writerName : " + writerName + ", strAbstract : " + strAbstract + ", searchStart : " + searchStart + ", searchEnd : " + searchEnd);
		
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
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, "");

        String strXML = "";
		
        if (!title.equals("") || !writerName.equals("") || !strAbstract.equals("") || !searchStart.equals("")) {
            strXML = ezCommunityService.searchItemXML(userInfo, boardID, title, writerName, strAbstract, searchStart, searchEnd, 1, 1000);
        }
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("strAbstract", strAbstract);
		model.addAttribute("strNow", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		model.addAttribute("searchConfig", searchConfig.substring(0, searchConfig.length() - 2));
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
	@RequestMapping(value = "/ezCommunity/checkIfHasReply.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/newBoardItem.do", method = RequestMethod.GET)
	public String newBoardItem(@CookieValue("loginCookie") String loginCookie, Model model, CommunityBoardItemVO item, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pBoardID = request.getParameter("boardID");
		String pMode = request.getParameter("mode");
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		String pItemID = "", pReservedItem = "", pUrl = "", pDocID = "", expireDays = "";
		String uploadFilePath = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		if (request.getParameter("itemID") != null) {
			pItemID = request.getParameter("itemID");
			item = ezCommunityService.getItemXML(pBoardID, pItemID, userInfo);
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
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), "", pBoardID, userInfo.getRollInfo(), 1, response, userInfo, "", "")) {
			return "cmm/error/egovError";
		}
		
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
		String defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", userInfo.getLocale()) + "'";
		
		//사용자 언어가 한국어이고 editorFontStyle값이 있을 경우 editorFontStyle값 적용
		if (userInfo.getLang().equals("1")) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
			
			if (!editorFontStyle.equals("")) {
				String fontFamily = editorFontStyle.split("\\|")[0];
				String fontSize = editorFontStyle.split("\\|")[1];
				
				defaultFontAndSize = "style='font-size:" + fontSize + ";font-family:" + fontFamily + "'";
			}
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID, "");
		/* 2020-06-24 홍승비 - 게시판명 다국어, 기본언어("1")와 멀티언어("2") 처리 */
		String multiBoardName = "";
		if (commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			multiBoardName = boardInfo.getBoardName();
		} else {
			multiBoardName = boardInfo.getBoardName2();
		}
		
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			model.addAttribute("mailShareId", request.getParameter("mailShareId"));
		}
		
		ezCommunityService.newBoardItem(item, boardInfo, userInfo, pItemID, pBoardID, pUrl, pMode, expireDays, model);
		
		model.addAttribute("editor", ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId()));
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
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("endDate", item.getEndDate());
		model.addAttribute("defaultFontAndSize", defaultFontAndSize);
		model.addAttribute("multiBoardName", multiBoardName);
		
		//logger.debug("item.endDate: " + item.getEndDate());
		
		return "ezCommunity/communityNewBoardItem";
	}
	
	/**
	 * 게시판 쓰기/수정/답변 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/saveItem.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveItem(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlStr, CommunityBoardItemVO item, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlData = commonUtil.convertStringToDocument(xmlStr);
		String pMode = request.getParameter("mode");
		
		//logger.debug("xmlStr: " + xmlStr);
		
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
		
		String boardID = commonUtil.detectPathTraversal(prefix);
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
        dirPath = commonUtil.detectPathTraversal(dirPath);
        
        if (useExtension.toLowerCase().indexOf(fileName.substring(fileName.lastIndexOf(".") + 1).toString().toLowerCase()) == -1 && !useExtension.equals("*")) {
        	returnVal = "denied";
        } else {
        	if (!new File(dirPath + "tempUploadFile").exists()) {
        		new File(dirPath + "tempUploadFile").mkdirs();
        	}
        	
        	if (!new File(commonUtil.detectPathTraversal(dirPath + boardID)).exists()) {
        		new File(commonUtil.detectPathTraversal(dirPath + boardID + commonUtil.separator + "uploadFile")).mkdirs();
        		new File(commonUtil.detectPathTraversal(dirPath + boardID + commonUtil.separator + "doc")).mkdirs();
        	} else if (!new File(commonUtil.detectPathTraversal(dirPath + boardID + commonUtil.separator + "uploadFile")).exists()) {
        		new File(commonUtil.detectPathTraversal(dirPath + boardID + commonUtil.separator + "uploadFile")).mkdirs();
        	}
        	
        	String attachPath = dirPath + "tempUploadFile" + commonUtil.separator + uploadSN + "_" + fileName;
        	attachPath = commonUtil.detectPathTraversal(attachPath);
        	
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
	@RequestMapping(value = "/ezCommunity/itemAttachFilePhoto.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
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
		dirPath = commonUtil.detectPathTraversal(dirPath);
		
		if (!new File(dirPath + "tempUploadFile").exists()) {
			new File(dirPath + "tempUploadFile").mkdirs();
		}
		
		if (!new File(commonUtil.detectPathTraversal(dirPath + boardID)).exists()) {
			new File(commonUtil.detectPathTraversal(dirPath + boardID)).mkdirs();
			new File(commonUtil.detectPathTraversal(dirPath + boardID + commonUtil.separator + "uploadFile")).mkdirs();
			new File(commonUtil.detectPathTraversal(dirPath + boardID + commonUtil.separator + "doc")).mkdirs();
		} else if (!new File(commonUtil.detectPathTraversal(dirPath + boardID + commonUtil.separator + "uploadFile")).exists()) {
			String newFilePath = dirPath + boardID + commonUtil.separator + "uploadFile";
			newFilePath = commonUtil.detectPathTraversal(newFilePath);
			
			new File(newFilePath).mkdirs();
		}
		
		String attachPath = dirPath + "tempUploadFile" + commonUtil.separator + uploadSN + fileName;
		String mapPath = dirPath + "tempUploadFile" + commonUtil.separator;
		attachPath = commonUtil.detectPathTraversal(attachPath);
		
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
            
            String imgFilePath = mapPath + "s_" + uploadSN + fileName;
            imgFilePath = commonUtil.detectPathTraversal(imgFilePath);
            
            ImageIO.write(bufferedImage, ext, new File(imgFilePath));
		}
		
		returnVal = "OK_" + uploadSN + fileName;
		
		return returnVal;
	}
	
	/**
	 * 게시판 읽기 화면호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemView.do", method = RequestMethod.GET)
	public String boardItemView(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("boardItemView started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pReservedItem = "";
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String oneLineReplyFlag = ezCommonService.getTenantConfig("ONELINE_REPLY_ENABLE", userInfo.getTenantId());
        String adjacentItemsEnableFlag = ezCommonService.getTenantConfig("ADJACENT_ITEMS_ENABLE", userInfo.getTenantId());
        String publicModulus = egovFileScrty.getPbm();
        String publicExponent = "10001";
        
		String pItemID = request.getParameter("itemID");
		String pBoardID = request.getParameter("boardID");
		String code = request.getParameter("code");
		String showAdjacent = request.getParameter("showAdjacent");
		//2018-07-13 김보미
		String treeCtrl = request.getParameter("treeCtrl");
		String inviteFlag = request.getParameter("inviteFlag");
		String type = "";
		
		if (request.getParameter("type") != null && !request.getParameter("type").isEmpty()) {
			type = request.getParameter("type");
		}
		
		if (showAdjacent == null) {
			showAdjacent = ezCommonService.getTenantConfig("ADJACENT_ITEMS_ENABLE", userInfo.getTenantId());
		}
		if (request.getParameter("pReservedItem") != null) {
			pReservedItem = request.getParameter("pReservedItem");
		}

		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID, code);

		if (!ezCommunityService.communityConnCHK(userInfo.getId(), "", pBoardID, userInfo.getRollInfo(), 1, response, userInfo, type, inviteFlag) && boardInfo.getRead_FG().equals("false")) {
			if (type.equals("pop")) {
				response.setContentType("application/json; charset=UTF-8");
				response.getWriter().write("{\"result\": false}");
				response.getWriter().flush();
				return null;
			}
			return "cmm/error/egovError";
		}

		CommunityBoardItemVO item = ezCommunityService.getItemXML(pBoardID, pItemID, userInfo);
		
		ezCommunityService.setAsRead(userInfo, pBoardID, pItemID);		
		ezCommunityService.boardItemView(userInfo, boardInfo, item, pItemID, pBoardID, showAdjacent, adjacentItemsEnableFlag, model);
		String commentCount = ezCommunityService.getOneLineReplyCount(pBoardID, pItemID, userInfo.getTenantId()); // 2018-01-10 강민수92 댓글 카운트 세기
		//2018.08.08 캐비넷 추가
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
		if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("commu", userInfo);
		}
		
		model.addAttribute("commentCount", commentCount);
		model.addAttribute("item", item);
		model.addAttribute("itemID", pItemID);
		model.addAttribute("boardID", pBoardID);
		model.addAttribute("code", code);
		model.addAttribute("pReservedItem", pReservedItem);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("oneLineReplyFlag", oneLineReplyFlag);
		model.addAttribute("adjacentItemsEnableFlag", adjacentItemsEnableFlag);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("treeCtrl", treeCtrl);
		model.addAttribute("useCabinet", use_cabinet);
		
		logger.debug("boardItemView ended.");
		
		return "ezCommunity/communityBoardItemView";
	}
	
	/**
	 * 암호확인화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/checkPassword.do", method = RequestMethod.GET)
	public String checkPassword(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("checkPassword started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		String pItemID = request.getParameter("itemID");
		
		String replyID = request.getParameter("replyID");
		String replyFlag = request.getParameter("replyFlag");
		
		String password = ezCommunityService.checkPassword(pItemID, userInfo.getTenantId()).trim();
		
		model.addAttribute("replyID", replyID);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("itemID", pItemID);
		model.addAttribute("password", password);
		
		logger.debug("checkPassword ended.");
		
		if (replyFlag != null && replyFlag.equals("true")) { // 강민수92 한줄댓글 삭제시 or 비번 체크시
			return "ezCommunity/deleteCommentPopup";
		} else {
			return "ezCommunity/communityCheckPassword";
		}
	}
	
	/**
	 * 암호확인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/confirmPassword.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String confirmPassword(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("confirmPassword started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	
    	/* 2020-01-17 홍승비 - 커뮤니티 익명게시물 또는 익명게시물의 댓글 삭제 시 암호 확인 분기 추가 */
		String newPassword = request.getParameter("newPassword");
		String oldPassword = request.getParameter("oldPassword"); // 기본적으로 익명게시물의 암호임
		String replyID = request.getParameter("replyID");
		String itemID = request.getParameter("itemID");
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		String rpwd = EgovFileScrty.decryptRsa(pk, newPassword);
		
		if (replyID != null && !replyID.equals(""))	{
			oldPassword = ezCommunityService.checkReplyPassword(itemID, replyID, userInfo.getTenantId()).trim();
		}
		
		logger.debug("confirmPassword ended.");
		
		if (EgovFileScrty.encryptPassword(rpwd, "unknown").equals(oldPassword)) {
			return "OK";
		} else {
			return "FALSE";
		}
	}
	
	/**
	 * 한줄답변 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/readOneLineReply.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	public String readOneLineReply(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pBoardID = request.getParameter("boardID");
		String pItemID = request.getParameter("itemID");
		
		/* 2024-01-22 홍승비 - 커뮤니티 게시판 댓글 표출 시 게시판 구분값 분기 추가 */
		CommunityBoardPropertyVO boardProperty = ezCommunityService.getBoardProperty(pBoardID, userInfo.getTenantId());
		String pGubun = boardProperty != null && boardProperty.getGubun() != null ? boardProperty.getGubun() : "0";
		
		/* 2018-07-02 홍승비 - CompanyID 조건 추가, 댓글쓴 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
		List<CommunityOneLineReplyVO> oneLineReplyList = ezCommunityService.readOneLineReply(userInfo.getPrimary(), pBoardID, pItemID, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getOffset(), pGubun);
		
		String totalCommentCount = String.valueOf(oneLineReplyList.size());
		model.addAttribute("totalCommentCount", totalCommentCount);
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
	@RequestMapping(value = "/ezCommunity/checkOneLineOwner.do", method = RequestMethod.GET, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String checkOneLineOwner(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pReplyID = request.getParameter("replyID");
		
		return ezCommunityService.checkOneLineOwner(pReplyID, userInfo.getId(), userInfo.getTenantId());
	}
	
	/**
	 * 한줄답변 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/deleteOneLineReply.do", method = RequestMethod.POST, produces="text/plain; charset=utf-8")
	@ResponseBody
	public String deleteOneLineReply(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		 
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pReplyID = request.getParameter("replyID");
		String gubun = request.getParameter("gubun");
		
		ezCommunityService.deleteOneLineReply(userInfo.getId(), pReplyID, gubun, userInfo.getTenantId());
		return "json";
	}
	
	/**
	 * 익명게시판일때 checkReplyPassword
	 */
	@RequestMapping(value = "/ezCommunity/checkReplyPassword.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/getItemAttachments.do", method = RequestMethod.GET, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getItemAttachments(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemID = request.getParameter("itemID");
		String realPath = commonUtil.getRealPath(request);
		String pMode = request.getParameter("mode") != null ? request.getParameter("mode") : "";
		
		String strXML = ezCommunityService.getItemAttachmentXML(itemID, userInfo.getTenantId(), realPath, pMode);
		
		if (strXML.substring(0, 5).equals("ERROR")) {
			strXML = "<RESULT>" + strXML + "</RESULT>";
		}
		
		return strXML;
	}
	
	/**
	 * 게시판 예약게시목록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardReservedItemList.do", method = RequestMethod.GET)
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
		
		String code = request.getParameter("code");
		String boardID = request.getParameter("boardID");
		
		String boardName = egovMessageSource.getMessage("ezCommunity.t91", userInfo.getLocale());
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, "");
		
		boardInfo.setSs_Board_MaxRows(10);
		
		int pStartRow = Math.addExact(Math.multiplyExact(Math.subtractExact(pPage, 1), boardInfo.getSs_Board_MaxRows()), 1);
		int pEndRow = Math.multiplyExact(pPage, boardInfo.getSs_Board_MaxRows());

		String strXML = ezCommunityService.getReservedItemListXML(userInfo.getId(), pStartRow, pEndRow, pSortBy, userInfo.getPrimary(), userInfo.getTenantId(), userInfo.getOffset());
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
		model.addAttribute("code", code);
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
	@RequestMapping(value = "/ezCommunity/getCommunityAttachInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getCommunityAttachInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getCommunityAttachInfo started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pFileName = request.getParameter("fileName");
		String pFilePath = request.getParameter("filePath");
		pFilePath = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator + pFilePath;
		String realPath = commonUtil.getRealPath(request);
		//logger.debug("fileName : " + pFileName);
		//logger.debug("filePath : " + pFilePath);
		
		downFile(request, response, realPath + pFilePath, pFileName);
		
		logger.debug("getCommunityAttachInfo ended.");
	}
	
	/**
	 * 게시판 조회자정보 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/itemReadList.do", method = RequestMethod.GET)
	public String itemReadList(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("itemReadList started");
//		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
//		String pBoardID = request.getParameter("boardID");
//		String pItemID = request.getParameter("itemID");
//		String offset = commonUtil.getMinuteUTC(userInfo.getOffset());
		
//		List<CommunityBoardItemReadVO> readList = ezCommunityService.getReaderList(pBoardID, pItemID, userInfo.getTenantId(), offset);
		
//		model.addAttribute("userInfo", userInfo);
//		model.addAttribute("readList", readList);
		
		//2018-02-06 김보미
		String pBoardID = request.getParameter("boardID");
		String pItemID = request.getParameter("itemID");
		
		model.addAttribute("boardID", pBoardID);
		model.addAttribute("itemID", pItemID);
		
		logger.debug("itemReadList ended");
		return "ezCommunity/communityItemReadList";
	}
	
	/**
	 * 게시글 미리보기 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemPreview.do", method = RequestMethod.GET)
	public String boardItemPreView(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gubun = request.getParameter("gubun");
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String primary = userInfo.getPrimary();
		
		model.addAttribute("displayName", primary.equals("2") ? userInfo.getDisplayName2() : userInfo.getDisplayName());
		model.addAttribute("deptName", primary.equals("2") ? userInfo.getDeptName2() : userInfo.getDeptName());
		model.addAttribute("title", primary.equals("2") ? userInfo.getTitle2() : userInfo.getTitle());
		model.addAttribute("phone", userInfo.getPhone());
		model.addAttribute("gubun", gubun);
		model.addAttribute("strNow", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		model.addAttribute("Use_Editor", useEditor);
		
		return "ezCommunity/communityBoardItemPreview";
	}
	
	/**
	 * 게시판 복사화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/copyBoardItem.do", method = RequestMethod.GET)
	public String copyBoardItem(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pItemIDList = request.getParameter("itemIDList");
		String pBoardID = request.getParameter("boardID");
		String code = request.getParameter("code");
		//2018-07-13 김보미 - 파라메터 추가
		String treeCtrl = request.getParameter("treeCtrl");
		
		CommunityBoardPropertyVO boardProperty = ezCommunityService.getBoardProperty(pBoardID, userInfo.getTenantId());
		
		model.addAttribute("itemIDList", pItemIDList);
		model.addAttribute("boardID", pBoardID);
		model.addAttribute("code", code);
		model.addAttribute("treeCtrl", treeCtrl);
		model.addAttribute("mailFG_Post", boardProperty.getMailFG_Post()); // 복사 시 게시알림메일 플래그 체크
		return "ezCommunity/communityCopyBoardItem";
	}
	
	/**
	 * 게시판 복사 권한 검사
	 */
	@RequestMapping(value = "/ezCommunity/getACL.do", method = RequestMethod.GET)
	public String getACL(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		CommunityBoardPropertyVO boardInfo;
		
		if (request.getParameter("comID") != null) {
			String pComID = request.getParameter("comID");
			String strACLXML = ezCommunityService.getACL(userInfo.getId(), pComID, userInfo.getTenantId());
			
			model.addAttribute("WRITE", strACLXML);
		} else if (request.getParameter("boardID") != null) {
			String pBoardID = request.getParameter("boardID");
			String userDeptPath = userInfo.getDeptPathCode() + ",everyone"; // everyone 권한 포함하여 체크하도록 수정
			
			//logger.debug("pBoardID = " + pBoardID);
			//logger.debug("userDeptPath = " + userDeptPath);
			
			for (String pAccessID : userDeptPath.split(",")) {
				boardInfo = ezCommunityService.brdGetACL(pBoardID, pAccessID, userInfo.getTenantId());
				
				if (boardInfo != null) {
					/* 2021-12-27 홍승비 - 커뮤니티 게시물 복사, 메일을 커뮤니티 게시물로 게시 등 권한 체크 시 사용자 개인에 부여된 전체관리자/회사관리자권한을 체크하도록 수정 */
					if (userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1) {
						boardInfo.setAccess_FG("1");
						boardInfo.setBoardAdmin_FG("true");
						boardInfo.setListView_FG("true");
						boardInfo.setRead_FG("true");
						boardInfo.setWrite_FG("true");
						boardInfo.setReply_FG("true");
						boardInfo.setDelete_FG("true");
					}
					
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
		String[] pOrgItemIDList = request.getParameter("orgItemIDList").split(";");
		String pOrgBoardID = request.getParameter("orgBoardID");
		String[] pDestItemIDList = request.getParameter("destItemIDList").split(";");
		String pDestBoardID = request.getParameter("destBoardID");
		String realPath = commonUtil.getRealPath(request);
		String ret = "";
		
		for(int i=0; i < pOrgItemIDList.length; i++) {
			ret = ezCommunityService.copyItem(pOrgItemIDList[i], pOrgBoardID, pDestItemIDList[i], pDestBoardID, realPath, userInfo);
		}
		
		model.addAttribute("ret", "<RESULT>" + ret + "</RESULT>");
		
		logger.debug("copyItem ended.");
		
		return "json";
	}
	
	/**
	 * 복사시 일반/포토/익명 게시판 검사 실행 함수
	 */
	@RequestMapping(value = "/ezCommunity/checkIfAnonyBoard.do", method = RequestMethod.GET)
	public String checkIfAnonyBoard(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("checkIfAnonyBoard started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pBoardID = request.getParameter("boardID");
		String ret = "";
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID, "");

		if (StringUtils.isNotBlank(boardInfo.getUrl()) || "2".equals(boardInfo.getGubun()) || "3".equals(boardInfo.getGubun())) {
			ret = "anonyboard";
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
	@RequestMapping(value = "/ezCommunity/board/bbsList.do", method = RequestMethod.GET)
	public String bbsList(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("bbsList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String bName = "tbl_c_board", sRadio = "", code = "", keyword = "";
		String titleName = "";
		int curPage = 0, totalPage = 0, nowBlock = 0, keywordCount = 0;
		int comNoPerPage = 17;
		
		bName = request.getParameter("bName").toLowerCase() != null ? request.getParameter("bName") : "";
		
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio");
		}
		if (request.getParameter("code") != null) {
			code = request.getParameter("code");
		} else {
			code = "";
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

		keywordCount = ezCommunityService.bbsListGet1(bName, userInfo.getPrimary(), keyword, sRadio, userInfo.getCompanyID(), userInfo.getTenantId());
		totalPage = keywordCount / comNoPerPage;
		
		if (keywordCount % comNoPerPage != 0) {
			totalPage = totalPage + 1;
		}
		
		curPage = Math.min(curPage, totalPage);
		List<CommunityCBoardVO> cBoardList = ezCommunityService.bbsListGet2(bName, userInfo.getPrimary(), keyword, sRadio, userInfo.getTenantId(), userInfo.getCompanyID());
		
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
	@RequestMapping(value = "/ezCommunity/board/bbsViewNew.do", method = RequestMethod.GET)
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
			strWriteDate = cBoardGet1.getWriteDay().trim().substring(0, 16);
			
			if (userInfo.getPrimary().equals("1")) {
				strWriteName = cBoardGet1.getUserName();
			} else {
				strWriteName = cBoardGet1.getUserName2();
			}
			
			strWriterID = cBoardGet1.getId().toLowerCase().trim();
			grsNo = cBoardGet1.getNo();
			
		} else {
			throw new Exception();
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
		
		/* 2019-10-28 홍승비 - 기본 폰트 스타일값 적용 */
		String defaultFont = egovMessageSource.getMessage("main.t246", userInfo.getLocale());
		String defaultSize = "13px";
		//사용자 언어가 한국어이고 editorFontStyle값이 있을 경우 editorFontStyle값 적용
		if (userInfo.getLang().equals("1")) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
			
			if (!editorFontStyle.equals("")) {
				defaultFont = editorFontStyle.split("\\|")[0];
				defaultSize = editorFontStyle.split("\\|")[1];
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
		model.addAttribute("defaultFont", defaultFont);
		model.addAttribute("defaultSize", defaultSize);
		model.addAttribute("useEditor", ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId()));
		model.addAttribute("realPath", commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()));
		
		logger.debug("bbsViewNew ended.");
		
		return "ezCommunity/communityBbsViewNew";
	}
	
	/**
	 * 알림마당 쓰기/수정 화면 호출함수 
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsEditNew.do", method = RequestMethod.GET)
	public String bbsEditNew(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		logger.debug("bbsEditNew started.");
		
		String code = "", sRadio = "", keyword = "", no = "", fileName = "", grsUserName = "", writerFakeName = "";
		int pagec = 0, block = 0;
		String step = "", level = "", ref = "";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "";
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
			
			if (request.getParameter("no") != null) { // mode = write인 경우, 답변 작성일때 no가 존재함
				no = request.getParameter("no");
			}
			if (request.getParameter("pagec") != null) {
				pagec = Integer.parseInt(request.getParameter("pagec"));
			}
		}
		
		String primary = userInfo.getPrimary();
		String serverName = request.getServerName();
		CommunityCBoardVO cBoardVO = null;
		
		if (!no.equals("")) { //  수정(mode :  "edit")  또는 답변(mode :  "write")

			fileName = ezCommunityService.bbsEditGet1(bName, no, userInfo.getTenantId());
			cBoardVO = ezCommunityService.bbsEditNew(bName, no, primary, userInfo.getTenantId());
			
			 if (!no.equals("")) { // 수정(mode : "edit") 답변 (mode : "write")
				 if (userInfo.getPrimary().equals("2")) {
					 grsUserName = userInfo.getDisplayName2();
				 } else {
					 grsUserName = userInfo.getDisplayName1();
				 }
			 } else {
				 if (primary.equals("2")) {
					 grsUserName = cBoardVO.getUserName2();
				 } else {
					 grsUserName = cBoardVO.getUserName();
				 }
			 }
			 
			 if (primary.equals("2")) {
				 writerFakeName = cBoardVO.getUserName2();
			 } else {
				 writerFakeName = cBoardVO.getUserName();
			 }
			 
			 cBoardVO.setWriteDay(commonUtil.getDateStringInUTC(cBoardVO.getWriteDay(), userInfo.getOffset(), false));
			 
		} else { // 쓰기(mode :  "write")
			if (userInfo.getLang().equals("2")) {
				grsUserName = userInfo.getDisplayName2();
			} else {
				grsUserName = userInfo.getDisplayName1();
			}
		}
		
		/* 2019-10-28 홍승비 - 기본 폰트 스타일값 적용 */
		String defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", userInfo.getLocale()) + "'";
		//사용자 언어가 한국어이고 editorFontStyle값이 있을 경우 editorFontStyle값 적용
		if (userInfo.getLang().equals("1")) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
			
			if (!editorFontStyle.equals("")) {
				String fontFamily = editorFontStyle.split("\\|")[0];
				String fontSize = editorFontStyle.split("\\|")[1];
				
				defaultFontAndSize = "style='font-size:" + fontSize + ";font-family:" + fontFamily + "'";
			}
		}
		String companyID = Optional.ofNullable(request.getParameter("companyID")).orElse(userInfo.getCompanyID());
		
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		
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
		model.addAttribute("defaultFontAndSize", defaultFontAndSize);
		model.addAttribute("companyID", companyID);
		model.addAttribute("useEditor", ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId()));
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);

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
	 * 알림마당 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/bbsDelOk.do", method = RequestMethod.POST, produces = "text/xml; charset=UTF-8")
	@ResponseBody
	public String bbsDelOk(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("bbsDelOk started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = ""; // 사실상 전달되지 않는 파라미터
		int adminCheck = 0;
		int replyItemCnt = 0;
		
		String itemNo = request.getParameter("itemNo");
		String goToPage = request.getParameter("goToPage");
		String bName = request.getParameter("bName");

		if (userInfo.getRollInfo().indexOf("c=1") >= 0) {
			adminCheck = 1;
		}
		
		CommunityCBoardVO board = ezCommunityService.bbsDelOkGet(bName, itemNo, code, userInfo.getTenantId());
		
		/* 2021-06-25 홍승비 - 커뮤니티 공지사항 삭제 시, 답변이 존재한다면 삭제하지 못하도록 수정 */
		if (bName.toUpperCase().equals("TBL_C_BOARD")) {
			replyItemCnt = ezCommunityService.bbsGetReplyItemCnt(itemNo, userInfo.getTenantId());
		}
		
		if (replyItemCnt > 0) { // 답변이 존재하는 경우
			logger.debug("bbsDelOk reply exists.");
			
			return "REPLYCNT";
		} else if (board.getId().trim().equals(userInfo.getId()) || adminCheck == 1 || userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
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
	@RequestMapping(value = "/ezCommunity/guestOne.do", method = RequestMethod.GET)
	public String guestOne(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("guestOne started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "", keyword = "", sRadio = "";
		int totalPage = 0, curPage = 0, nowBlock = 0, comNoPerPage = 3;
		
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
		String inviteFlag = request.getParameter("inviteFlag");

		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response, userInfo, "", inviteFlag)) {
			return "cmm/error/egovError";
		}
		
		int keywordCount = ezCommunityService.guestOneGet1(sRadio, keyword, code, userInfo.getPrimary(), userInfo.getTenantId());
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
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("strXML" , strXML);
		model.addAttribute("disable" , false);
		model.addAttribute("multiData", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("chkId" ,  ezConnUtil.encryptAES(userInfo.getId()));
		model.addAttribute("inviteFlag" ,  inviteFlag);

		logger.debug("guestOne ended.");
		
		return "ezCommunity/communityGuestOne";
	}
	
	/**
	 * 방명록 수정화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/guestEdit.do", method = RequestMethod.GET)
	public String guestEdit(@CookieValue("loginCookie") String loginCookie, CommunityCClubGuestVO item, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String no = request.getParameter("no");
		String inviteFlag = request.getParameter("inviteFlag");

		boolean bIsMyContent = false;
		
		item.setId(userInfo.getId());
		item.setUserName(userInfo.getDisplayName1());
		item.setUserName2(userInfo.getDisplayName2());
		
		if (mode.equals("edit")) {
			item = ezCommunityService.guestEditGet(code, userInfo.getPrimary(), no, userInfo.getId(), userInfo.getTenantId());
			
			if (item != null) {
				bIsMyContent = true;
				//2018-07-02 김보미 - 화면에서 처리하기 위해 주석.
//				item.setContent(item.getContent().replaceAll("<br>", "\n"));
//				2018-07-16 김보미 - 특수문자 처리
//				item.setContent(commonUtil.cleanValue(item.getContent().trim()));
			}
		}
		model.addAttribute("code", code);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("mode", mode);
		model.addAttribute("no", no);
		model.addAttribute("item", item);
		model.addAttribute("bIsMyContent", bIsMyContent);
		model.addAttribute("inviteFlag", inviteFlag);

		return "ezCommunity/communityGuestEdit";
	}
	
	/**
	 * 방명록 쓰기/수정/삭제 실행함수 
	 */
	@RequestMapping(value = "/ezCommunity/guestEditOk.do", method = RequestMethod.POST)
	public String guestEditOk(@CookieValue("loginCookie") String loginCookie, Model model, CommunityCClubGuestVO item, HttpServletRequest request) throws Exception {
		logger.debug("guestEditOk started. ");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean bIsMyContent = false;
		String[] cNo = request.getParameterValues("c_no");
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String inviteFlag = request.getParameter("inviteFlag");
		String memo = URLDecoder.decode(request.getParameter("memo"), "utf-8");
		//String memo = request.getParameter("memo");
		//logger.debug("code : " + code + ", mode : " + mode + ", memo : " + memo);
		
		bIsMyContent = ezCommunityService.guestEditOk(userInfo, item, code, mode, memo, cNo, bIsMyContent);
		
		model.addAttribute("mode", mode);
		model.addAttribute("code", code);
		model.addAttribute("bIsMyContent", bIsMyContent);
		model.addAttribute("inviteFlag", inviteFlag);

		logger.debug("guestEditOk ended. ");
		
		return "ezCommunity/communityGuestEditOk";
	}

	/**
	 * 설문조사 목록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollMain.do", method = RequestMethod.GET)
	public String pollMain(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int guest = 0;
		boolean disable = false;
		
		String code = request.getParameter("code");
		String userLevel = request.getParameter("userLevel");
		String inviteFlag = request.getParameter("inviteFlag");
		String pollAdmin = "false";

		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response, userInfo, "", inviteFlag)) {
			return "cmm/error/egovError";
		}
		
		userLevel = ezCommunityService.pollMainGet1(userInfo.getId(), code, userInfo.getTenantId());
		
		if (userLevel == null) {
			userLevel = "0";
		}

		// 운영자 권한정보
		List<CommunityCClubUserVO> operatorList = ezCommunityService.getClubOperatorList(userInfo.getCompanyID(), userInfo.getTenantId(), code, userInfo.getId());

		if (operatorList != null && !operatorList.isEmpty()) {
			if (operatorList.get(0).getAdmin_Auth() != null && operatorList.get(0).getAdmin_Auth().contains("B")) {
				pollAdmin = "true";
			}
		}

		String strXML = ezCommunityService.pollMain(userInfo, code, pollAdmin);

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("guest", guest);
		model.addAttribute("code", code);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("disable", disable);
		model.addAttribute("strXML", strXML.replaceAll("(\r\n|\r|\n|\n\r)", " ")); //.replaceAll("&lt;br&gt;", "&nbsp"));
		model.addAttribute("pollAdmin", pollAdmin);
		model.addAttribute("inviteFlag", inviteFlag);
//		model.addAttribute("chCommunityAdmin", userInfo.getRollInfo().indexOf("t=1"));
		
		return "ezCommunity/communityPollMain";
	}
	
	/**
	 * 설문조사 등록 화면1 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollAdd.do", method = RequestMethod.POST)
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
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 1, response, userInfo, "" , "")) {
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
		model.addAttribute("lang", userInfo.getLang());
		
		return "ezCommunity/communityPollAdd";
	}
	
	/**
	 * 설문조사 등록 화면2 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollAddOk.do", method = RequestMethod.POST)
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
		model.addAttribute("selRes1", selRes1);
		model.addAttribute("selRes2", selRes2);
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
	@RequestMapping(value = "/ezCommunity/pollAddOkGo.do", method = RequestMethod.POST)
	@ResponseBody
	public void pollAddOkGo(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		ezCommunityService.pollAddGo(userInfo, request, response);
	}
	
	/**
	 * 설문조사 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/pollDelete.do", method = RequestMethod.GET)
	@ResponseBody
	public void pollDelete(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		ezCommunityService.pollDelete(userInfo, request, response);
	}
	
	/**
	 * 설문조사 읽기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollRes.do", method = RequestMethod.GET)
	public String poll(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String pollManagerID = request.getParameter("pollManagerID");
		String pollState = URLDecoder.decode(request.getParameter("pollState"), "utf-8");
		
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 1, response, userInfo, "", "")) {
			return "cmm/error/egovError";
		}
		
		ezCommunityService.pollRes(userInfo, model, pollManagerID, pollState, response);
		
		model.addAttribute("code", code);
		model.addAttribute("pollManagerID", pollManagerID);
		model.addAttribute("pollState", pollState);
		
		return "ezCommunity/communityPollRes";
	}
	
	/**
	 * 설문조사 응답 실행 함수
	 */
	@RequestMapping(value = "/ezCommunity/pollResOk.do", method = RequestMethod.POST)
	@ResponseBody
	public void pollResOk(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String answerType = request.getParameter("answerType_1");
		String answerETC = request.getParameter("answerETC");
		String pollSelect = request.getParameter("pollSelect_1");
		String answerCount = request.getParameter("answerCount_1");
		String isSave = request.getParameter("isSave");
		String questionID = request.getParameter("questionID_1");
		String pollManagerID = request.getParameter("pollManagerID");
		String pollState = request.getParameter("pollState");
		
		/* 2018-10-01 홍승비 - 설문조사 응답 후 리스트로 이동하지 않고 해당 설문조사를 유지하도록 수정 */
		ezCommunityService.pollResOk(userInfo, code, questionID, pollSelect, answerETC, isSave, answerType, answerCount, pollManagerID, pollState, response);
	}
	
	/**
	 * 설문조사 날짜변경화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollEdit.do", method = RequestMethod.GET)
	public String pollEdit(@CookieValue("loginCookie") String loginCookie, Model model,HttpServletRequest request) throws Exception {
		logger.debug("pollEdit started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pClubNo = request.getParameter("pClubNo");
		String managerID = request.getParameter("managerID");
		String offset = userInfo.getOffset();
		int tenantID = userInfo.getTenantId();
		
		CommunityCPollManagerVO managerVO = ezCommunityService.pollEditGet1(managerID, tenantID);
		
		String pStartDate = commonUtil.getDateStringInUTC(managerVO.getPollStartDate().substring(0,19), offset, false).substring(0, 10);
		String pEndDate = commonUtil.getDateStringInUTC(managerVO.getPollEndDate().substring(0,19), offset, false).substring(0, 10);
		
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
	@RequestMapping(value = "/ezCommunity/pollEditOk.do", method = RequestMethod.POST)
	@ResponseBody
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
	@RequestMapping(value = "/ezCommunity/pollETCView.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/pollETCTable.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/commViewMember.do", method = RequestMethod.GET)
	public String commViewMember(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");

		if (!ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 1, response, userInfo, "", "")) {
			return "cmm/error/egovError";
		}

		String strSysopID = ezCommunityService.adminMemberListGet2(code, userInfo.getTenantId()).trim();

		if (strSysopID.equals(userInfo.getId())) {
			model.addAttribute("chkSysop", "1");
		}

		// 운영자 권한정보
		List<CommunityCClubUserVO> operatorList = ezCommunityService.getClubOperatorList(userInfo.getCompanyID(), userInfo.getTenantId(), code, userInfo.getId());

		if (operatorList != null && !operatorList.isEmpty()) {
			String adminAuth = operatorList.get(0).getAdmin_Auth();
			model.addAttribute("adminAuth", adminAuth);
		}

		CommunityClubVO clubCntInfo = ezCommunityService.getClubUserCountInfo(code, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getOffset());
		int totalUserCnt = clubCntInfo.getTotalUserCnt(); // 총 회원수
		int todayJoinCnt = clubCntInfo.getTodayJoinCnt(); // 오늘 가입수
		int todayLeaveCnt = clubCntInfo.getTodayLeaveCnt(); // 오늘 탈퇴수
		int waitApprCount = ezCommunityService.adminMemPermitGet1(code, userInfo.getTenantId()); // 가입승인대기 회원수

		model.addAttribute("code", code);
		model.addAttribute("strSysopID", strSysopID);
		model.addAttribute("totalUserCnt", totalUserCnt);
		model.addAttribute("todayJoinCnt", todayJoinCnt);
		model.addAttribute("todayLeaveCnt", todayLeaveCnt);
		model.addAttribute("waitApprCount", waitApprCount);
		
		return "ezCommunity/communityCommViewMember";
	}

	@RequestMapping(value = "/ezCommunity/commViewMemberList.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String commViewMemberList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String keyword = "", sRadio = "", block = "", selectGrade = "", orderCell = "",  orderOption = "", selectMonth = "", startdate = "", enddate = "";
		int curPage = 1;
		
		String code = request.getParameter("code");
		
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
		}
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio");
		}
		if (request.getParameter("goToPage") != null && request.getParameter("goToPage") != "") {
			curPage = Integer.parseInt(request.getParameter("goToPage"));
		}
		if (request.getParameter("block") != null) {
			block = request.getParameter("block");
		}
		if (request.getParameter("selectGrade") != null && !request.getParameter("selectGrade").equals("0")) {
			selectGrade = request.getParameter("selectGrade");
		}
		if (request.getParameter("selectMonth") != null && !request.getParameter("selectMonth").equals("0")) {
			selectMonth = request.getParameter("selectMonth");
		}
		if (request.getParameter("orderCell") != null) {
			orderCell = request.getParameter("orderCell");
		}
		if (request.getParameter("orderOption") != null) {
			orderOption = request.getParameter("orderOption");
		}
		if (request.getParameter("startdate") != null) {
			startdate = request.getParameter("startdate");
		}
		if (request.getParameter("enddate") != null) {
			enddate = request.getParameter("enddate");
		}

		int keywordCount = ezCommunityService.commViewMemberGet2(code, userInfo.getPrimary(), keyword, sRadio, userInfo.getCompanyID(), userInfo.getTenantId(), selectGrade, selectMonth, userInfo.getOffset());

		int comNoPerPage = 10;
		int totalPage = keywordCount / comNoPerPage;

		if ((totalPage * comNoPerPage) != keywordCount && (keywordCount % comNoPerPage) != 0) {
			totalPage = totalPage + 1;
		}

		String strSysopID = ezCommunityService.adminMemberListGet2(code, userInfo.getTenantId()).trim();
		// 여기에서 해당 회원의 deptID, deptname을 xml 내부에 받아온다.
		String strXML = ezCommunityService.commViewMember(userInfo, code, strSysopID, keyword, sRadio, comNoPerPage, curPage, keywordCount, totalPage, block, selectGrade, orderCell, orderOption, selectMonth, startdate, enddate);

		return strXML;
	}
	
	/**
	 * 회원탈퇴 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/commOut.do", method = RequestMethod.GET)
	public String commOut(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		CommunityClubVO club = ezCommunityService.aspCommInfoGet1(code, userInfo.getTenantId());
		// 2018-06-29 김보미 - 커뮤니티 회원수 수정
		club.setC_MemberCnt(ezCommunityService.commViewMemberGet2(club.getC_ClubNo().trim(), userInfo.getPrimary(), "", "", userInfo.getCompanyID(), userInfo.getTenantId(), "", "", userInfo.getOffset()));
		CommunityMemberInfoVO member = ezCommunityService.commOutGet(club.getC_SysopID().trim(), club.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
		
		String sysopName = member.getUserName();
		
		if (sysopName.equals("")) {
			sysopName = egovMessageSource.getMessage("ezCommunity.t398", userInfo.getLocale());
		}
		
		if(userInfo.getPrimary().equals("2")) {
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
	@RequestMapping(value = "/ezCommunity/commOutOk.do", method = RequestMethod.POST)
	@ResponseBody
	public String commOutOk(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData, HttpServletRequest request) throws Exception{
		Document xmlDoc = commonUtil.convertStringToDocument(xmlData);
		
		String code = xmlDoc.getElementsByTagName("CODE").item(0).getTextContent();
		String reason = xmlDoc.getElementsByTagName("REASON").item(0).getTextContent();
		
		String retValue = ezCommunityService.commOutOk(request, loginCookie, code, reason);
		
		return retValue;
	}
	
	/**
	 * 관리메뉴 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/admin/index.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/adminLeft.do", method = RequestMethod.GET)
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

		String retXML = ezCommunityService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, code, userInfo.getPrimary(), userInfo.getTenantId());
		
		//logger.debug("xmlret = " + retXML);
		
		if (retXML.substring(0, 5).toUpperCase().equals("ERROR")){
            retXML = "<RESULT>ERROR</RESULT>";
		}

		// 운영자 권한정보
		List<CommunityCClubUserVO> operatorList = ezCommunityService.getClubOperatorList(userInfo.getCompanyID(), userInfo.getTenantId(), code, userInfo.getId());

		if (operatorList != null && !operatorList.isEmpty()) {
			String adminAuth = operatorList.get(0).getAdmin_Auth();
			sysopCheck = 2;
			model.addAttribute("adminAuth", adminAuth);
		}

		model.addAttribute("code", code);
		model.addAttribute("num", num);
		model.addAttribute("clickBoard", clickBoard);
		model.addAttribute("boardID", boardID);
		model.addAttribute("flag", flag);
		model.addAttribute("club", club);
		model.addAttribute("xmlret", retXML);
		model.addAttribute("sysopCheck", sysopCheck);

		logger.debug("adminLeft ended.");
		
		return "ezCommunity/communityAdminLeft";
	}

	/**
	 * 커뮤니티 관리메뉴 메인 초기화면
	 */
	@RequestMapping(value = "/ezCommunity/adminRight.do", method = RequestMethod.GET)
	public String adminHome(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");

		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());

		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}

		return "ezCommunity/communityAdminRight";
	}

	/**
	 * 관리메뉴 기본정보수정화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminBasic.do", method = RequestMethod.GET)
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
			//커뮤니티 소개글 수정할 때 br태그 안나오게 \r\n으로 치환
			club.setC_ClubDesc(club.getC_ClubDesc().replaceAll("<br>", "\r\n")); 
			CommunityMemberInfoVO member = ezCommunityService.aspCommInfoGet2(userInfo.getPrimary(), club.getC_SysopID().trim(), userInfo.getCompanyID(), userInfo.getTenantId());
			
			/*if (userInfo.getLang().equals("2")) {
				member.setUserName(member.getUserName2());
			}*/
			
			name1 = member.getUserName();
		}

		// 2018-11-12 김민성 - 안쓰는 카테고리 주석처리
		int pPermitCount = ezCommunityService.adminMemPermitGet1(code, userInfo.getTenantId());
		String cCateA = ezCommunityService.adminBasicGet1(code, userInfo.getTenantId());
		//String cCateB = ezCommunityService.adminBasicGet2(code, userInfo.getTenantId());
		String readGrade = ezCommunityService.getMemListReadGrade(code, userInfo.getCompanyID() ,userInfo.getTenantId());

		model.addAttribute("code", code);
		model.addAttribute("club", club);
		model.addAttribute("name1", name1);
		model.addAttribute("pPermitCount", pPermitCount);
		model.addAttribute("c_cate_a", (cCateA == null) ? "" : egovMessageSource.getMessage("ezCommunity."+cCateA, userInfo.getLocale()));
		//model.addAttribute("c_cate_b", (cCateB == null) ? "" : egovMessageSource.getMessage("ezCommunity."+cCateB, userInfo.getLocale()));
		model.addAttribute("lang_Primary", langPrimary);
		model.addAttribute("lang_Secondary", langSecondary);
		model.addAttribute("readGrade", readGrade);

		logger.debug("adminBasic ended.");
		
		return "ezCommunity/communityAdminBasic";
	}
	
	/**
	 * 관리메뉴 기본정보수정 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminBasicOk.do", method = RequestMethod.POST)
	public String adminBasicOk(@CookieValue("loginCookie")String loginCookie, CommunityClubVO clubVO, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");

		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		/* 2019-01-29 홍승비 - 개행문자 <br>태그로 치환하는 부분 제거 */
		ezCommunityService.adminBasicOkUpdate(clubVO, code, userInfo.getTenantId());
		
		model.addAttribute("code", code);
		
		return "ezCommunity/communityAdminBasicOk";
	}
	
	/**
	 * 커뮤니티 환경설정화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminLogo.do", method = RequestMethod.GET)
	public String adminLogo(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		CommunityClubVO clubVO = ezCommunityService.adminLogoGet(code, userInfo.getPrimary(), userInfo.getTenantId());
		CommunityClubVO clubVO2 = ezCommunityService.adminLogoGet2(code, userInfo.getTenantId());
		String copType = ezCommunityService.commHomeGet4(code, userInfo.getTenantId());
		
		clubVO.setC_Type(copType);
		
		if (userInfo.getLang().equals("2")) {
			clubVO.setC_ClubName(clubVO.getC_ClubName2());
		}
		
		model.addAttribute("code", code);
		model.addAttribute("clubVO", clubVO);
		model.addAttribute("clubVO2", clubVO2);
		
		return "ezCommunity/communityAdminLogo";
	}
	
	/**
	 * 커뮤니티 환경설정화면 로고 temp파일 저장 실행함수
	 */
	@RequestMapping(value = "ezCommunity/adminLogoUpload.do", method = RequestMethod.POST)
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
		result = result + "?" + new SecureRandom().nextInt(50);
		
		model.addAttribute("tempLogoPath", result);
		logger.debug("adminLogoUpload ended.");
		//logger.debug("result======" + result);
		return "json";
	}
		
	
	/**
	 * 커뮤니티 환경설정화면 썸네일 temp파일 저장 실행함수
	 */
	@RequestMapping(value = "ezCommunity/adminThumbUpload.do", method = RequestMethod.POST)
	public String adminThumbUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		logger.debug("adminThumbUpload started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		String thumbPath = commonUtil.getUploadPath("upload_community.LOGO", userInfo.getTenantId());
		MultipartFile thumbFile = request.getFile("thumbFile");
		String code = request.getParameter("code");
		String result = "";
		
		if (!thumbFile.isEmpty()) {
			result = thumbPath + commonUtil.separator + ezCommunityService.adminThumbUpload(code, realPath, thumbPath, thumbFile, userInfo.getTenantId());
		}
		
		//cache 문제로 인한 ? 랜덤값 추가
		result = result + "?" + new SecureRandom().nextInt(50);

		model.addAttribute("tempThumbPath", result);
		logger.debug("adminThumbUpload ended.");
		//logger.debug("result======" + result);
		return "json";
	}
	
	/**
	 * 커뮤니티 환경설정화면 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminLogoOk.do", method = RequestMethod.POST)
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
	@RequestMapping(value = "/ezCommunity/adminLogoIE9Ok.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/adminHomeBoard.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/boardProperty.do", method = RequestMethod.GET)
	public String adminBoardProperty (@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("adminBoardProperty started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String style = "";
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
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, "");
		CommunityBoardPropertyVO boardProp = ezCommunityService.getBoardProperty(boardID, userInfo.getTenantId());
		
		if (boardProp.getDeleteAfter() == null) {
			boardProp.setDeleteAfter("-1");
		}
		
		if (boardProp.getBoardColor() == null) {
			boardProp.setBoardColor("#000000");
		}
		
		if (ezCommunityService.boardPropertyGet(boardID, userInfo.getTenantId()) > 0) {
			style = "display:none";
		}
		
		/* 2020-06-24 홍승비 - 커뮤니티 게시판명에 다국어 기본언어, 멀티언어 적용 */
		String multiBoardName = "";
		if (commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			multiBoardName = boardInfo.getBoardName();
		} else {
			multiBoardName = boardInfo.getBoardName2();
		}

		CommunityBoardPropertyVO boardGradeInfo = ezCommunityService.brdGetACL(boardID, "everyone", userInfo.getTenantId());
		String readGrade = boardGradeInfo.getRead_FG();
		String writeGrade = boardGradeInfo.getWrite_FG();

		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("boardProp", boardProp);
		model.addAttribute("_style", style);
		model.addAttribute("userInfo",userInfo);
		model.addAttribute("multiBoardName", multiBoardName);
		model.addAttribute("readGrade", readGrade);
		model.addAttribute("writeGrade", writeGrade);

		logger.debug("adminBoardProperty ended.");
		
		return "ezCommunity/communityAdminBoardProperty";
	}
	
	/**
	 * 게시판 관리메뉴 일반설정 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/saveBoardProperty.do", method = RequestMethod.POST)
	public String saveBoardProperty(@CookieValue("loginCookie") String loginCookie, CommunityBoardInfoVO vo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("saveBoardProperty started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String readGrade = request.getParameter("readGrade");
		String writeGrade = request.getParameter("writeGrade");

		String ret = ezCommunityService.saveBoardProperty(userInfo, vo);
		ezCommunityService.updateBoardManageGrade(vo.getBoardID(), readGrade, writeGrade, userInfo.getTenantId());

		model.addAttribute("result", ret);
		
		logger.debug("saveBoardProperty ended. ret = " + ret);
		
		return "json";
	}
	
	/**
	 * 그룹생성화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardGroupCreate.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/createBoardGroup.do", method = RequestMethod.POST)
	@ResponseBody
	public void createBoardGroup(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardGroupID = request.getParameter("boardGroupID");
		String boardGroupName = request.getParameter("boardGroupName");
		String boardGroupName2 = request.getParameter("boardGroupName2");
		String code = request.getParameter("code");
		
		ezCommunityService.createBoardGroup(code, commonUtil.stripScriptTags(boardGroupID), boardGroupName, boardGroupName2, userInfo);
	}
	
	/**
	 * 순서변경화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardOrder.do", method = RequestMethod.GET)
	public String boardOrder(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String boardID = request.getParameter("boardID");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, "");
		
		/* 2020-06-24 홍승비 - 커뮤니티 게시판명에 다국어 기본언어, 멀티언어 적용 */
		String multiBoardName = "";
		if (commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			multiBoardName = boardInfo.getBoardName();
		} else {
			multiBoardName = boardInfo.getBoardName2();
		}
		
		model.addAttribute("code", code);
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("upperBoardID", parentBoardID);
		model.addAttribute("boardName", multiBoardName);

		return "ezCommunity/communityAdminBoardOrder";
	}
	
	/**
	 * 게시판관리 Tree 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminGetSubBoards.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
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
		
		String strXML = ezCommunityService.getBoardTree(upperBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, 1, 0, pExcludeBoardID, code, userInfo.getPrimary(), userInfo.getTenantId());
		
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
		//logger.debug("xmlData = " + xmlData);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String ret = ezCommunityService.saveBoardOrder(xmlData, userInfo.getTenantId());
		
		ezCommunityService.deleteBoard(userInfo.getTenantId());
		
		ret = "<RESULT>" + ret + "</RESULT>";

		logger.debug("saveBoardOrder ended.");
		
		return ret;
	}
	
	/**
	 * 하위게시판 생성화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardCreate.do", method = RequestMethod.GET)
	public String boardCreate(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary"+userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary"+userInfo.getLang(), userInfo.getTenantId());
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, "");
		
		/* 2020-06-24 홍승비 - 커뮤니티 게시판명에 다국어 기본언어, 멀티언어 적용 */
		String multiBoardName = "";
		if (commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			multiBoardName = boardInfo.getBoardName();
		} else {
			multiBoardName = boardInfo.getBoardName2();
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("lang_Primary", langPrimary);
		model.addAttribute("lang_Secondary", langSecondary);
		model.addAttribute("parentBoardName", multiBoardName);
		
		return "ezCommunity/communityAdminBoardCreate";
	}
	
	/**
	 * 하위게시판 생성 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/createBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public void createBoard(@CookieValue("loginCookie") String loginCookie , HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String boardName = request.getParameter("boardName");
		String boardName2 = request.getParameter("boardName2");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		String readGrade = request.getParameter("readGrade");
		String writeGrade = request.getParameter("writeGrade");

		//첨부 용량 제한 [이성우]
		String comatt = "10";
		
		ezCommunityService.createBoardInsert(code, commonUtil.stripScriptTags(boardID), boardName, boardName2, parentBoardID, boardGroupID, comatt, userInfo, readGrade, writeGrade);
	}
	
	/**
	 * 게시판이동화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardMove.do", method = RequestMethod.GET)
	public String boardMove(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, "");
		
		/* 2020-06-24 홍승비 - 커뮤니티 게시판명에 다국어 기본언어, 멀티언어 적용 */
		String multiBoardName = "";
		if (commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			multiBoardName = boardInfo.getBoardName();
		} else {
			multiBoardName = boardInfo.getBoardName2();
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("boardName", multiBoardName);
		
		return "ezCommunity/communityAdminBoardMove";
	}
	
	/**
	 * 대상게시판선택화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardMoveSelect.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/boardDelete.do", method = RequestMethod.GET)
	public String boardDelete(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, "");
		
		/* 2020-06-24 홍승비 - 커뮤니티 게시판명에 다국어 기본언어, 멀티언어 적용 */
		String multiBoardName = "";
		if (commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			multiBoardName = boardInfo.getBoardName();
		} else {
			multiBoardName = boardInfo.getBoardName2();
		}
		
		String strXML = ezCommunityService.getBoardTree(boardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), 0, 1, 0, " ", code, userInfo.getPrimary(), userInfo.getTenantId());
		
		if (strXML.trim().equals("<NODES></NODES>")) {
			model.addAttribute("hasSubBoard", 0);
		} else {
			model.addAttribute("hasSubBoard", 1);
		}

		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("boardName", multiBoardName);
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
	@RequestMapping(value = "/ezCommunity/adminSearchBoardItem.do", method = RequestMethod.GET)
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
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, code);
		
		/* 2020-06-24 홍승비 - 커뮤니티 게시판명에 다국어 기본언어, 멀티언어 적용 */
		String multiBoardName = "";
		if (commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			multiBoardName = boardInfo.getBoardName();
		} else {
			multiBoardName = boardInfo.getBoardName2();
		}
		
		int pStartRow = Math.addExact(Math.multiplyExact(Math.subtractExact(pPage, 1), boardInfo.getSs_SearchBoard_MaxRows()), 1);
        int pEndRow = Math.multiplyExact(pPage, boardInfo.getSs_SearchBoard_MaxRows());

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
		model.addAttribute("boardName", multiBoardName);
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
        model.addAttribute("abstracts", abstracts);
        model.addAttribute("pPage", pPage);
        
		return "ezCommunity/communityAdminSearchBoardItem";
	}
	
	/**
	 * 검색 대상게시판 선택화면 호출
	 */
	@RequestMapping(value = "/ezCommunity/boardSelect.do", method = RequestMethod.GET)
	public String boardSelect(Model model, HttpServletRequest request) {
		String code = request.getParameter("code");
		
		model.addAttribute("code", code);
		
		return "ezCommunity/communityBoardSelect";
	}
	
	/**
	 * 탈퇴희망자 승인화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminOuterList.do", method = RequestMethod.GET)
	public String adminOuterList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		int postCount = ezCommunityService.adminOuterListGet1(code, userInfo.getTenantId());
		
		/* 2018-06-22 홍승비 - 사간겸직 탈퇴희망자 companyID로 중복레코드 제거 */
		String idSpanValue = ezCommunityService.adminOuterList(userInfo, code);

		model.addAttribute("code", code);
		model.addAttribute("postCount", postCount);
		model.addAttribute("idSpanValue", idSpanValue);
		
		return "ezCommunity/communityAdminOuterList";
	}
	
	/**
	 * 탈퇴희망자 승인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminOuterOkNo.do",  method = RequestMethod.GET)
	public String adminOuterOkNo(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String flag = request.getParameter("flag");
		String userID = request.getParameter("userID");
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		ezCommunityService.adminOuterOkNoSet(flag.toUpperCase(), userID, code, userInfo.getTenantId(), userInfo.getCompanyID());
		
		model.addAttribute("code", code);
		
		return "ezCommunity/communityAdminOuterOkNo";
	}
	
	/**
	 * 회원 탈퇴처리화면/마스터이취임화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminMemberList.do", method = RequestMethod.GET)
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
		
		/* 2018-07-18 홍승비 - 회원탈퇴/마스터이취임 화면 회원 검색 시 카운트 변하도록 수정 */
		int postCount = ezCommunityService.adminMemberListGet1(code, flag.toUpperCase(), ser, userInfo.getPrimary(), userInfo.getTenantId());
		String strSysopID = ezCommunityService.adminMemberListGet2(code, userInfo.getTenantId());
		String idSpanValue = ezCommunityService.adminMemberList(userInfo, code, flag.toUpperCase(), ser, strSysopID, mode);
		
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
	@RequestMapping( value = "/ezCommunity/adminMemberListOk.do", method = RequestMethod.GET)
	String adminMemberListOk(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		CommunityCClubUserVO clubUser = null;
		
		/* 2018-12-03 홍승비 - 카뮤니티 멤버의 부서명 Prop으로 가져오도록 수정, 사용하지 않는 prop 제거 */
		String propList = "displayName;telephoneNumber;mobile;facsimileTelephoneNumber;postalCode;streetAddress;description";
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
		memberInfo.setHandPhone(xmldom.getElementsByTagName("MOBILE").item(0).getTextContent());
		memberInfo.setCompanyFax(xmldom.getElementsByTagName("FACSIMILETELEPHONENUMBER").item(0).getTextContent());
		memberInfo.setCompanyZip(xmldom.getElementsByTagName("POSTALCODE").item(0).getTextContent());
		memberInfo.setCompanyAddress(xmldom.getElementsByTagName("STREETADDRESS").item(0).getTextContent());
		memberInfo.setUserName(xmldom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent());
		memberInfo.setCompanyTel(xmldom.getElementsByTagName("TELEPHONENUMBER").item(0).getTextContent());
		//memberInfo.setDeptName(xmldom.getElementsByTagName("DESCRIPTION").item(0).getTextContent());
		
		/* 2019-03-05 홍승비 - 커뮤니티 팝업홈 > 관리메뉴 > 회원정보가 사간겸직에 대응하도록 수정 */
		//logger.debug("getMemberInfo(" + companyID + ", " + cID + ", " + userInfo.getTenantId() + ")");
		CommunityMemberInfoVO memberInfoVO = ezCommunityService.getMemberInfo(companyID, cID, userInfo.getTenantId());
		
		if (memberInfoVO != null) {
			if (userInfo.getPrimary().equals("1")) {
				memberInfo.setDeptName(memberInfoVO.getDeptName());
			} else {
				memberInfo.setDeptName(memberInfoVO.getDeptName2());
			}
			
			//logger.debug("adminMemberListOkGet(" + code + ", " + companyID + ", " + cID + ", " + userInfo.getTenantId() + ")");
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
	@RequestMapping(value = "/ezCommunity/adminMemberListOkGo.do", method = RequestMethod.POST)
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
		
		ezCommunityService.adminMemberListOkGoSe(mode.toUpperCase(), code, cID, cNm, userInfo);
		
		model.addAttribute("code", code);
		model.addAttribute("mode", mode);
		model.addAttribute("userName", userName);
		
		return "ezCommunity/communityAdminMemberListOkGo";
	}
	
	/**
	 * Cop 폐쇄신청화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminCommClose.do", method = RequestMethod.GET)
	public String adminCommClose(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("adminCommClose started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		CommunityClubVO club = ezCommunityService.aspCommInfoGet1(code, userInfo.getTenantId());
		
		// 2018-07-03 김보미 - 커뮤니티 회원수 수정
		club.setC_MemberCnt(ezCommunityService.commViewMemberGet2(club.getC_ClubNo().trim(), userInfo.getPrimary(), "", "", userInfo.getCompanyID(), userInfo.getTenantId(),"", "", userInfo.getOffset()));
		
		/* 겸직사원의 커뮤니티 선택 시 companyID로 조건 추가 */
		CommunityMemberInfoVO member = ezCommunityService.aspCommInfoGet2(userInfo.getPrimary(), club.getC_SysopID().trim(), userInfo.getCompanyID(), userInfo.getTenantId());
		
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
		
		CommunityCComCloseVO closeVO = ezCommunityService.adminCommCloseOkGet1(code, userInfo.getTenantId());
		
		if (closeVO != null) {
			strXML = "<RETURN><VALUE>ExistApplication</VALUE></RETURN>";
		} else {
			CommunityClubVO clubVO = ezCommunityService.adminCommCloseOkGet2(code, userInfo.getTenantId());
			
			if (clubVO != null) {
				 String commName = clubVO.getC_ClubName().trim();
                 String commName2 = clubVO.getC_ClubName2().trim();
                 String sysopID = clubVO.getC_SysopID().trim();
                 // 2019-01-16 김헤정 companyId 추가
                 String companyName = userInfo.getCompanyName1();
                 String companyId = userInfo.getCompanyID();
                 
                 ezCommunityService.adminCommCloseOkInsert(code, commName, commName2, sysopID, companyName, companyId, commonUtil.getTodayUTCTime(""), reason, "0", userInfo.getTenantId());
                 
                 strXML = "<RETURN><VALUE>SuccessApplication</VALUE></RETURN>";
			}
		}
		
		logger.debug("adminCommCloseOk ended.");
		
		return strXML;
	}
	
	/**
	 * 메인페이지화면 호출 함수
	 */
	@RequestMapping(value = "/ezCommunity/mainPage.do", method = RequestMethod.GET)
	public String mainPage(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("mainPage started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		int totalPage = ezCommunityService.mainPage(userInfo);
		String bName = "tbl_c_board";
		String userName = userInfo.getDisplayName1();
		
		/* 2020-08-10 홍승비 - 커뮤니티 가입 승인대기 메세지에 필요한 이름 추가 */
		if (!commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			userName = userInfo.getDisplayName2();
		}
		
		/* 2018-05-17 홍승비 - 새 글에 new 표시 추가 */
		String pastDate = commonUtil.getTodayUTCTime("");
		pastDate = EgovDateUtil.addDay(pastDate, -1, "yyyy-MM-dd HH:mm:ss");
		// addYMDtoDayTime 메서드는 시:분 까지만 다룰 수 있다. offset으로 분을 더한 뒤, 잘려나간 초 단위는 붙인다.
		pastDate = EgovDateUtil.addYMDtoDayTime(pastDate.substring(0, 10), pastDate.substring(11, 16), 0, 0, 0, 0, Integer.parseInt(commonUtil.getMinuteUTC(userInfo.getOffset())), "yyyy-MM-dd HH:mm:");
		pastDate = pastDate.concat(commonUtil.getTodayUTCTime("").substring(17,19));
		
		/* 2018-11-12 김민성 - 커뮤니티 공지사항 추가 */
		List<CommunityCBoardVO> cNoticeList = ezCommunityService.bbsListGet2(bName, userInfo.getPrimary(), "", "", userInfo.getTenantId(), userInfo.getCompanyID());
		
		for(CommunityCBoardVO noticeList : cNoticeList) {
			noticeList.setTitle(commonUtil.cleanValue(noticeList.getTitle()));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("primary", commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("pastDate", pastDate);
		model.addAttribute("cNoticeList", cNoticeList);
		model.addAttribute("userName", userName);
		
		logger.debug("mainPage ended.");
		
		return "ezCommunity/communityMainPage";
	}
	
	/**
	 * My 커뮤니티 새글 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/myCopNewBoardItem.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String myCopNewBoardItem (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("myCopNewBoardItem started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		/* 2020-11-11 홍승비 - 오버플로우 대응 (페이지 기본값 1) */
		int page = commonUtil.isIntNumber(request.getParameter("page"), 1);
		int startRow = Math.multiplyExact(2, Math.subtractExact(page, 1));
		int endRow = 2;
		
		//logger.debug("page : " + page + ", startRow : " + startRow + ", endRow : " + endRow);
		
		/* 2018-06-21 홍승비 - MY커뮤니티 새글 표출 시 현재 companyID로 자신이 가입한 모든 CLUBNO 가져오도록 수정 */
		String result = ezCommunityService.myCopNewBoardItem(userInfo, startRow, endRow);
		
		//logger.debug("result : " + result);
		logger.debug("myCopNewBoardItem ended.");
		
		return result;
	}
	
	/**
	 * 우수커뮤니티/ 신규커뮤니티 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getBestNewCommunity.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getBestNewCommunity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getBestNewCommunity started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "";
		
		logger.debug("getBestNewCommunity ended.");
		
		/* 2018-06-21 홍승비 - 메인홈 우측 우수+신규 커뮤니티 표출 companyID 조건 추가 */
		return ezCommunityService.getBestNewCommunity(userInfo, mode);
	}
	
	/**
	 * 회원가입화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/join1.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/join2.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/agreeOk.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/join.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezCommunity/joinOk.do", method = RequestMethod.POST)
	public String joinOk(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("joinOk started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String id = userInfo.getId();
		int tenantID = userInfo.getTenantId();
		boolean bCanJoin = true;
		String openJob = "0", openBirth = "0";
		
		String code = request.getParameter("code");
		String cIntro = "0";
		String openEmail = "0";
		String openHp = "0";
		String openComp = "0";
		String openHouse = "0";
		String openSex = "0";
		String birthDay = "0";
		String gender = "0";
		
		String userLevel = ezCommunityService.joinOkGet1(code, id, tenantID);
		
		if (userLevel != null) {
			bCanJoin = false;
		}
		
		String joinGrade = ezCommunityService.getCommunityJoinGrade(code, userInfo.getCompanyID(), tenantID);
		/* 겸직 시 현재 선택한 companyID가 userInfo에 제대로 반영되는지 확인 필요  */
		ezCommunityService.joinOkSet1(code, id, commonUtil.getTodayUTCTime(""), userInfo.getCompanyID(), tenantID, joinGrade);
		
		String cID = ezCommunityService.joinOkGet2(code, id, tenantID);
		CommunityClubVO clubVO = ezCommunityService.joinOkGet3(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), tenantID);

		if(clubVO.getC_ClubConfirmType().equals("1") || clubVO.getC_ClubConfirmType().equals("2")) {
			
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
		ezCommunityService.joinOkSendMail(request, loginCookie, userInfo, clubVO);
		
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
		//logger.debug("gClubG=" + gClubG + " || cPermit=" + cPermit);
		
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
	@RequestMapping(value = "/ezCommunity/ezAprAlert.do", method = RequestMethod.GET)
	public String ezAprAlert () {
		return "ezCommunity/communityAprAlert";
	}
	
	/**
	 * OpenInformationUI 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/ezAPROPINION.do", method = RequestMethod.GET)
	public String ezAPROPINION () throws Exception {
		logger.debug("ezAPROPINION started.");
		logger.debug("ezAPROPINION ended.");
		return "ezCommunity/communityAprOption";
	}
	
	/**
	 * 비공개 커뮤니티 가입/미가입 체크 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/getIsJoin.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getIsJoin (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getIsJoin started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		String cPermit = ezCommunityService.leftCommunityGet1(code, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		// 가입 또는 가입 신청된 상태로, 미승인 시의 permit 값은 0이다.
		if (cPermit != null) {
			logger.debug("getIsJoin ended. true");
			
			return "TRUE";
		} else { // 미가입
			logger.debug("getIsJoin ended. false");
			
			return "FALSE";
		}
	}
	
	/**
	 * 커뮤니티 가입희망자 승인화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminMemPermit.do", method = RequestMethod.GET)
	public String adminMemPermit(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		
		//logger.debug("code = " + code);

		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}
		
		int postCount = ezCommunityService.adminMemPermitGet1(code, userInfo.getTenantId());

		/* 승인대기 회원 표시 companyID 조건 추가 */
		String idSpanValue = ezCommunityService.adminMemPermit(userInfo, code);
		
		model.addAttribute("code", code);
		model.addAttribute("postCount", postCount);
		model.addAttribute("idSpanValue", idSpanValue);
		return "ezCommunity/communityAdminMemPermit";
	}
	
	/**
	 * 커뮤니티 가입희망자 승인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminOkNo.do", method = RequestMethod.POST)
	public String adminOkNo(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("adminOkNo started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String flag = request.getParameter("flag");
		String cID = request.getParameter("cID");
		String result = "";
		
		//logger.debug("code : " + code + ", flag : " + flag + ", cID : " + cID);
		
		int postCount = ezCommunityService.adminMemPermitGet1(code, userInfo.getTenantId());		
		String idSpanValue = ezCommunityService.adminMemPermit(userInfo, code);
		String joinGrade = ezCommunityService.getCommunityJoinGrade(code, userInfo.getCompanyID(), userInfo.getTenantId());
		try {
			ezCommunityService.okNoSet(flag.toUpperCase(), code, cID, userInfo.getTenantId(), joinGrade);
			ezCommunityService.okNoSetSendMail(request, loginCookie, userInfo, flag.toUpperCase(), code, cID);
			
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
	@RequestMapping(value = "/ezCommunity/todayCop.do", method = RequestMethod.GET)
	public String todayCop(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("todayCop started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		int num = 0, itemCnt = 0;
		String cCatecAName = "", cCatecBName = "";
		
		Calendar calendar = Calendar.getInstance();
		int dayOfYear = calendar.get(Calendar.DAY_OF_YEAR);
		
		/* 2018-06-21 홍승비 - 오늘의 커뮤니티 표출 companyID 조건 추가 */
		int rtnVal = ezCommunityService.todayCopGet1(userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (rtnVal == 0) {
			num = 1;
		} else {
			num = (dayOfYear % rtnVal) + 1;
		}
		
		/* 2018-06-21 홍승비 - 오늘의 커뮤니티 표출 companyID 조건 추가 */
		// 18-05-08 김민성 - 커뮤니티 회원수 수정
		CommunityClubVO club = ezCommunityService.todayCopGet2(num, userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (club != null) {
			club.setC_MemberCnt(ezCommunityService.commViewMemberGet2(club.getC_ClubNo(), userInfo.getPrimary(), "", "", userInfo.getCompanyID(), userInfo.getTenantId(), "", "", userInfo.getOffset()));
			
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
	@RequestMapping(value = "/ezCommunity/myCategoryCop.do", method = RequestMethod.GET)
	public String myCategoryCop (@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("mainPageCategory started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "";
		
		List<CommunityCCategoryVO> list = new ArrayList<CommunityCCategoryVO>();
		
		/* 2018-06-21 홍승비 - 커뮤니티 메인홈 하단 카테고리별 커뮤니티 표출 companyID 조건 추가 */
		if (mode.equals("A")) {
			List<CommunityCCategoryVO> categoryList= ezCommunityService.mainPageGet4("a", userInfo.getTenantId());
			for(CommunityCCategoryVO category : categoryList) {
				CommunityCCategoryVO vo = ezCommunityService.mainPageCategory(category.getC_Code(), "a", userInfo.getCompanyID(), userInfo.getTenantId());
				if (vo != null) {
					//logger.debug("code = " + category.getC_Code() + " || cat = a");
					//logger.debug(vo.getC_Name() + " : " + vo.getCnt());
					list.add(vo);
				}
			}
		} else {
			List<CommunityCCategoryVO> categoryList= ezCommunityService.mainPageGet4("b", userInfo.getTenantId());
			
			for(CommunityCCategoryVO category : categoryList) {
				CommunityCCategoryVO vo = ezCommunityService.mainPageCategory(category.getC_Code(), "b", userInfo.getCompanyID(), userInfo.getTenantId());
				if (vo != null) {
					//logger.debug("code = " + category.getC_Code() + " || cat = b");
					//logger.debug(vo.getC_Name() + " : " + vo.getCnt());
					list.add(vo);
				}
			}
		}
		
		logger.debug("mainPageCategory ended. listSize = " + list.size());
		
		model.addAttribute("list", list);
		
		return "json";
	}
	
	/**
	 * 카테고리별 커뮤니티화면 업무별/종류에 따른 커뮤니티목록  호출함수
	 */
	@RequestMapping(value = "/ezCommunity/categoryCopList.do", method = RequestMethod.GET)
	public String categoryCopList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("categoryCopList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = request.getParameter("mode");
		String type = request.getParameter("type");
		int page = Integer.parseInt(request.getParameter("page"));
		
		//logger.debug("type = " + type + " || mode = " + mode + " || page = " + page);
		
		int startRow = Math.addExact(Math.multiplyExact(5, Math.subtractExact(page, 1)), 1);
		int endRow = Math.multiplyExact(5, page);
		int mariaStart = Math.multiplyExact(5, Math.subtractExact(page, 1));
		int mariaEnd = 5;
		
		/* 2018-06-21 홍승비 - 커뮤니티 메인홈 하단 카테고리별 커뮤니티 표출 companyID 조건 추가 */
		List<CommunityClubVO> clubList = ezCommunityService.categoryListGet(type, mode, startRow, endRow, mariaStart, mariaEnd, userInfo.getCompanyID(), userInfo.getTenantId());
		
		// 18-05-08 김민성 - 커뮤니티 회원수 수정
		for (CommunityClubVO club : clubList) {
			club.setC_MemberCnt(ezCommunityService.commViewMemberGet2(club.getC_ClubNo(), userInfo.getPrimary(), "", "", userInfo.getCompanyID(), userInfo.getTenantId(),"", "", userInfo.getOffset()));
			club.setItemCnt(ezCommunityService.categoryListItemCntGet(club.getC_ClubNo(), userInfo.getTenantId()));
		}
		
		model.addAttribute("list", clubList);
		
		logger.debug("categoryCopList ended.");
		
		return "json";
	}
	
	/**
	 * 카테고리별 커뮤니티 검색기능 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/searchCop.do", method = RequestMethod.GET)
	public String searchCop(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("searchCop started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String search = "";
		
		String option = request.getParameter("option") != null ? request.getParameter("option") : "";
		String keyword = request.getParameter("keyword");
		/* 2020-11-11 홍승비 - 오버플로우 대응 (페이지 기본값 1) */
		int page = commonUtil.isIntNumber(request.getParameter("page"), 1);
		
		int startRow = Math.addExact(Math.multiplyExact(5, Math.subtractExact(page, 1)), 1);
		int endRow = Math.multiplyExact(5, page);
		
		if (option.equals("NAME")) {
			if (userInfo.getPrimary().equals("1")) {
				search = "C_CLUBNAME";
			} else {
				search = "C_CLUBNAME2";
			}
		} else {
			search = "C_CLUBDESC";
		}
		
		/* 2018-06-21 홍승비 - 커뮤니티 메인홈 하단 카테고리별 커뮤니티 검색 companyID 조건 추가 */
		List<CommunityClubVO> clubList = ezCommunityService.searchCop(search, keyword, startRow, endRow, "SEA", userInfo.getCompanyID(), userInfo.getTenantId());
		List<CommunityClubVO> clubCopCnt = ezCommunityService.searchCop(search, keyword, startRow, endRow, "CNT", userInfo.getCompanyID(), userInfo.getTenantId());
		
		for (CommunityClubVO club : clubList) {
			if (clubList.indexOf(club) == 0 ) { 
				clubList.get(0).setCopCnt(clubCopCnt.get(0).getCopCnt());
			}
			
			// 18-05-08 김민성 - 커뮤니티 회원수 수정
			club.setC_MemberCnt(ezCommunityService.commViewMemberGet2(club.getC_ClubNo(), userInfo.getPrimary(), "", "", userInfo.getCompanyID(), userInfo.getTenantId(),"", "", userInfo.getOffset()));
			club.setItemCnt(ezCommunityService.categoryListItemCntGet(club.getC_ClubNo(), userInfo.getTenantId()));
		}
		
		model.addAttribute("list", clubList);
		
		logger.debug("searchCop ended.");
		
		return "json";
	}
	
	/**
	 * 포토게시판 목록화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemListPhoto.do", method = RequestMethod.GET)
	public String boardItemListPhoto(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		
		String userLevel = "0", pSortBy = "", showAdjacent = "", strXML = "";
		int pPage = 1, totalPage = 1, totalCount = 0;
		String pastDate = "";
		
		if (request.getParameter("sortBy") != null) {
			pSortBy = request.getParameter("sortBy");
		}
		if (request.getParameter("page") != null) {
			pPage = Integer.parseInt(request.getParameter("page"));
		}
		
		String boardID = request.getParameter("boardID");
		String code = request.getParameter("code");
		String inviteFlag = request.getParameter("inviteFlag");

		if (!ezCommunityService.communityConnCHK(userInfo.getId(), "", boardID, userInfo.getRollInfo(), 0, response, userInfo, "", inviteFlag)) {
			return "cmm/error/egovError";
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, code);
		
		
		CommunityClubVO club = ezCommunityService.boardItemListPhotoGet1(userInfo.getId(), boardID, userInfo.getTenantId());
		
		/* 2020-06-24 홍승비 - 커뮤니티 게시판명에 다국어 기본언어, 멀티언어 적용 */
		String multiBoardName = "";
		if (commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			multiBoardName = boardInfo.getBoardName();
		} else {
			multiBoardName = boardInfo.getBoardName2();
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
		
		int pStartRow = Math.addExact(Math.multiplyExact(Math.subtractExact(pPage, 1), boardInfo.getSs_SearchBoard_MaxRows()), 1);
	    int pEndRow = Math.multiplyExact(pPage, boardInfo.getSs_SearchBoard_MaxRows());
	    
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
	    
	    /* 2018-05-18 홍승비 - 새 글에 new 표시 추가 */
		pastDate = commonUtil.getTodayUTCTime("");
		pastDate = EgovDateUtil.addDay(pastDate, -1, "yyyy-MM-dd HH:mm:ss");
		pastDate = EgovDateUtil.addYMDtoDayTime(pastDate.substring(0, 10), pastDate.substring(11, 16), 0, 0, 0, 0, Integer.parseInt(commonUtil.getMinuteUTC(userInfo.getOffset())), "yyyy-MM-dd HH:mm:");
		pastDate = pastDate.concat(commonUtil.getTodayUTCTime("").substring(17,19));

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("code", code);
		model.addAttribute("pSortBy", pSortBy);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("strXML", strXML);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("page", pPage);
		model.addAttribute("pastDate", pastDate);
		model.addAttribute("multiBoardName", multiBoardName);
		model.addAttribute("inviteFlag", inviteFlag);

		return "ezCommunity/communityBoardItemListPhoto";
	}
	
	/**
	 * 포토게시판 쓰기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/newBoardItemPhoto.do", method = RequestMethod.GET)
	public String newBoardItemPhoto (@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String editor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String pUploadFilePath = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		CommunityBoardItemVO item = null;
		CommunityBoardPropertyVO boardInfo = null;
		String startDateTime = "", endDateTime = "", expireDays = "", itemID = "";
//		String browser = ClientUtil.getClientInfo(request, "browser");		
		String boardID = request.getParameter("boardID");
		String mode = request.getParameter("mode");
		
		/* 2018-05-14 홍승비 - 포토게시판에서 의미를 가지지 않는 파라미터 제거(url, isCrossBrowser) */
		if (request.getParameter("itemID") != null) {
			itemID = request.getParameter("itemID");
		}
		
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
		// 20100119 보안처리 관련 추가작업(권한체크)
		if (!ezCommunityService.communityConnCHK(userInfo.getId(), "", boardID, userInfo.getRollInfo(), 1, response, userInfo, "", "")) {
			return "cmm/error/egovError";
		}

		boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, "");
		
		/* 2020-06-24 홍승비 - 커뮤니티 게시판명에 다국어 기본언어, 멀티언어 적용 */
		String multiBoardName = "";
		if (commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			multiBoardName = boardInfo.getBoardName();
		} else {
			multiBoardName = boardInfo.getBoardName2();
		}
		
		expireDays = boardInfo.getExpireDays();
		
		if (!mode.equals("new")) {
			item = ezCommunityService.getItemXML(boardID, itemID, userInfo);
		}
		
		startDateTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false);
		
		// 만료일을 설정하는 부분
		// 2023-05-15 이사라 : NullPointerException 시큐어코딩 - !Objects.isNull(item)
		if (mode.equals("modify") && !Objects.isNull(item)) { // 수정인 경우
			if (item.getEndDate().substring(0, 4).equals("9999")) { //영구게시인 경우
				if (expireDays.equals("-1")) { // 게시판 설정이 영구게시인 경우 만료일 컨트롤 값을 30일 뒤로 자동세팅
					endDateTime = EgovDateUtil.addDay(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false), 30, "yyyy-MM-dd");
				} else { // 게시판 설정이 영구게시가 아니면 설정된 만료일 만큼 뒤로 세팅
					endDateTime = EgovDateUtil.addDay(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false), Integer.parseInt(expireDays), "yyyy-MM-dd");
				}
			} else { // 수정 전에 설정되었던 만료일로 세팅함
				endDateTime = item.getEndDate().split(" ")[0];
			}
			
			item.setExtensionAttribute4(item.getExtensionAttribute4().replace("&amp;", "&"));
		} else if (!Objects.isNull(item)){ //새 게시나 답변인 경우
			if (expireDays.equals("-1")) {
				endDateTime = EgovDateUtil.addDay(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false), 30, "yyyy-MM-dd"); 
			} else {
				endDateTime = EgovDateUtil.addDay(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false), Integer.parseInt(expireDays), "yyyy-MM-dd");
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("editor", editor);
		model.addAttribute("pUploadPath", pUploadFilePath);
		model.addAttribute("pMode", mode);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("item", item);
		model.addAttribute("expireDays", expireDays);
		model.addAttribute("startDateTime", startDateTime);
		model.addAttribute("endDateTime", endDateTime);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("multiBoardName", multiBoardName);
		
		return "ezCommunity/communityNewBoardItemPhoto";
	}
	
	/**
	 * 포토게시판 쓰기 실행함수
	 */
	@RequestMapping(value ="/ezCommunity/saveItemPhoto.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveItemPhoto (@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData, Model model, HttpServletRequest request) throws Exception {
		logger.debug("saveItemPhoto started.");
		//logger.debug(xmlData);
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlData);
		String mode = request.getParameter("mode");
		
		String ret = "";
		
		String attachList = xmlDom.getElementsByTagName("ATTACHMENTS").item(0).getTextContent();
		String smallName = xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
		String fileName = xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent();
		String title = xmlDom.getElementsByTagName("TITLE").item(0).getTextContent();
		String itemID = xmlDom.getElementsByTagName("ITEMID").item(0).getTextContent();
		
		if (mode.equals("New")) {
			xmlDom.getElementsByTagName("STARTDATE").item(0).setTextContent(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		}
		
		//logger.debug("attachList : " + attachList + ", smallName : " + smallName + ", fileName : " + fileName + ", title : " + title + ", itemID : " + itemID);
		
        xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).setTextContent(fileName);
		xmlDom.getElementsByTagName("UPPERITEMIDTREE").item(0).setTextContent(itemID);
		xmlDom.getElementsByTagName("ATTACHMENTS").item(0).setTextContent(attachList);
		xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).setTextContent(smallName);
    		
		ret = ezCommunityService.newItem(xmlDom, mode, commonUtil.getRealPath(request), userInfo);
        
        logger.debug("saveItemPhoto ended.");
        
		return ret;
	}
	
	/**
	 * 포토게시판 읽기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemViewPhoto.do", method = RequestMethod.GET)
	public String boardItemViewPhoto(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String oneLineReplyFlag = ezCommonService.getTenantConfig("ONELINE_REPLY_ENABLE", userInfo.getTenantId());
        String adjacentItemsEnableFlag = ezCommonService.getTenantConfig("ADJACENT_ITEMS_ENABLE", userInfo.getTenantId());
        
        String showAdjacent = "", pReservedItem = "", itemID = "";
        String previousItemID = "", previousTitle = "", nextItemID = "", nextTitle = "";
        String gImageUrl = "", gWidth = "", gHeight = "";
		String code = "";

		String boardID = request.getParameter("boardID");
		String type = "";

		if (request.getParameter("type") != null && !request.getParameter("type").isEmpty()) {
			type = request.getParameter("type");
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
		if (request.getParameter("code") != null) {
			code = request.getParameter("code");
		}
		String inviteFlag = request.getParameter("inviteFlag");

		if (!ezCommunityService.communityConnCHK(userInfo.getId(), "", boardID, userInfo.getRollInfo(), 0, response, userInfo, type, inviteFlag)) {
			if (type.equals("pop")) {
				response.setContentType("application/json; charset=UTF-8");
				response.getWriter().write("{\"result\": false}");
				response.getWriter().flush();
				return null;
			}
			return "cmm/error/egovError";
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, code);
		
		if (!boardInfo.getRead_FG().equals("true")) {
			response.getWriter().print("<html><head><title>" + egovMessageSource.getMessage("ezCommunity.t175", userInfo.getLocale()) + "</title></head><body><table border=0 width=100% height=100%><tr><td align=center valign=center>" + egovMessageSource.getMessage("ezCommunity.t980", userInfo.getLocale()) + "</td></tr></table></body></html>");
			response.getWriter().flush();
		}
		
		CommunityBoardItemVO item = ezCommunityService.getItemXML(boardID, itemID, userInfo);
		ezCommunityService.setAsRead(userInfo, boardID, itemID);
		
		if (item == null) {
			throw new Exception();
		}
		
		if (EgovDateUtil.getDaysDiff(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd"), userInfo.getOffset(), false), item.getParentWriteDate().substring(0, 10)) > 0) {
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
			gImageUrl = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYBOARD&boardID=" + boardID + "&imgUrl=" + item.getExtensionAttribute5() + "&fileName=" + URLEncoder.encode((item.getExtensionAttribute4()).replace("+", "%20").replace("&amp;", "&"),"UTF-8");
			pFilePath = commonUtil.detectPathTraversal(pFilePath);
			
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
		
		String commentCount = ezCommunityService.getOneLineReplyCount(boardID, itemID, userInfo.getTenantId()); // 2018-01-10 강민수92 댓글 카운트 세기
		//2018.08.08 캐비넷 추가
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
		if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("commu", userInfo);
		}
		
		model.addAttribute("commentCount", commentCount);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("oneLineReplyFlag", oneLineReplyFlag);
		model.addAttribute("adjacentItemsEnableFlag", adjacentItemsEnableFlag);
		model.addAttribute("showAdjacent", showAdjacent);
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
		model.addAttribute("useCabinet", use_cabinet);
		model.addAttribute("code", code);

		return "ezCommunity/communityBoardItemViewPhoto";
	}
	
	/**
	 * 포토게시판 인쇄화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemViewPrint.do", method = RequestMethod.GET)
	public String boardItemViewPrint(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String oneLineReplyFlag = ezCommonService.getTenantConfig("ONELINE_REPLY_ENABLE", userInfo.getTenantId());
		String pReservedItem = "";
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		
		if (request.getParameter("pReservedItem") != null) {
			pReservedItem = request.getParameter("pReservedItem");
		}

		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, "");
		CommunityBoardItemVO item = ezCommunityService.getItemXML(boardID, itemID, userInfo);
		
		if (item.getParentWriteDate().compareTo(item.getWriteDate()) > 0) {
			item.setWriteDate(item.getParentWriteDate());
		}
		
		if (item.getEndDate().substring(0, 4).equals("9999")) {
			item.setEndDate(egovMessageSource.getMessage("ezCommunity.t930", userInfo.getLocale()));
		}
		
		String use_Editor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("oneLineReplyFlag", oneLineReplyFlag);
		model.addAttribute("pBoardID", boardID);
		model.addAttribute("pItemID", itemID);
		model.addAttribute("pReservedItem", pReservedItem);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("item", item);
		model.addAttribute("use_Editor", use_Editor);
		
		return "ezCommunity/communityBoardItemViewPrint";
	}

	/**
	 * 
	 */
	@RequestMapping(value = "/ezCommunity/colorPicker.do", method = RequestMethod.GET)
	public String colorPicker() {
		return "ezCommunity/communityColorPicker";
	}
	
	/**
	 * Email관련
	 */
	@RequestMapping(value = "/ezCommunity/getItemInfo.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
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
				sb.append("<WriterName>" + commonUtil.cleanValue(itemVO.getWriterName()) + "</WriterName>");
				sb.append("<WriterDeptName>" + ( itemVO.getWriterDeptName() == null ? "" : commonUtil.cleanValue(itemVO.getWriterDeptName()) ) + "</WriterDeptName>");
				sb.append("<WriterCompanyName>" + ( itemVO.getWriterCompanyName() == null ? "" : commonUtil.cleanValue(itemVO.getWriterCompanyName()) ) + "</WriterCompanyName>");
				sb.append("<WriteDate>" + itemVO.getWriteDate() + "</WriteDate>");
				sb.append("<ParentWriteDate>" + itemVO.getParentWriteDate() + "</ParentWriteDate>");
				sb.append("<Importance>" + itemVO.getImportance() + "</Importance>");
				sb.append("<Title>" + commonUtil.cleanValue(itemVO.getTitle()) + "</Title>");
				sb.append("<ContentLocation>" + itemVO.getContentLocation() + "</ContentLocation>");
				sb.append("<StartDate>" + itemVO.getStartDate() + "</StartDate>");
				sb.append("<EndDate>" + itemVO.getEndDate() + "</EndDate>");
				sb.append("<Abstract>" + itemVO.getAbsTract() + "</Abstract>");
				sb.append("<Attachments>" + commonUtil.cleanValue(itemVO.getAttachments()) + "</Attachments>");
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
			logger.error(e.getMessage(), e);
		}
		
		sb.append("</NODES>");
		
		logger.debug("getItemInfo ended.");
		
		return sb.toString();
	}
	
	/**
	 * 커뮤니티 관리메뉴 전체메일보내기 화면 조회
	 */
	@RequestMapping(value = "/ezCommunity/adminNoticeMail.do", method = RequestMethod.GET)
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
	
	/**
	 * 커뮤니티 관리메뉴 전체메일보내기 화면 조회
	 */
	@RequestMapping(value = "/ezCommunity/adminNoticeMailOk.do", method = RequestMethod.POST)
	public String adminNoticeMailOk(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("adminNoticeMailOk started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String subject = request.getParameter("subject");
		String memo = request.getParameter("memo");
		int tenantID = userInfo.getTenantId();
		
		CommunityClubVO clubVO = ezCommunityService.adminNoticeMailOkGet1(code, tenantID);
		String clubName = ezCommunityService.getClubNameLocalization(userInfo.getLang(), clubVO);
		
		if (clubVO.getC_SysopID() != null) {
			List<CommunityClubVO> list = ezCommunityService.adminNoticeMailOkGet2(code, tenantID);
			
			InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
        	
        	//logger.debug("from = " + userInfo.getEmail());
        	
        	List<InternetAddress> to = new ArrayList<InternetAddress>();
        	
        	List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
			for(CommunityClubVO vo : list) {
				if (vo.getEmail() != null) {
		        	InternetAddress to1 = new InternetAddress();
		        	to1.setPersonal(vo.getUserName(), "UTF-8");
		        	to1.setAddress(vo.getEmail());
		        	
		        	if (ezPersonalService.hasNotiDiableItem(vo.getUserId(), NotiType.fromString("COMMUNITY_NOTICE"), NotiPlatform.MAIL, userInfo.getTenantId())) {
						continue;
					}
		        	
		        	to.add(to1);
		        	
		        	Map<String, Object> recipientMap = new HashMap<String, Object>();
		        	recipientMap.put("userType", "PERSON");
		        	recipientMap.put("companyId", userInfo.getCompanyID());
		        	recipientMap.put("cn", vo.getUserId());
		        	notiRecipientList.add(recipientMap);
		        	//logger.debug("to = " + vo.getEmail());
		        }
			}
			
			String content = commonUtil.createNotiMailContent(memo, tenantID, userInfo.getLocale());
			
			if (to != null && to.size() > 0) {
				ezEmailService.sendMail(loginCookie, from, to.toArray(new InternetAddress[to.size()]), null, null, subject, content, false);
			}
			
			if (notiRecipientList != null && notiRecipientList.size() > 0) {
				String linkUrl = "/ezCommunity/checkCommHome.do?communityCD=" + code;
	        	String linkUrlMobile = "";
	        	String notiSubType = "NOTICE";
				String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "COMMUNITY", notiSubType, clubName + " - " + egovMessageSource.getMessage("ezCommunity.noti01", userInfo.getLocale()), "popup", "1300", "900", linkUrl, linkUrlMobile, "");
				logger.debug("community " +  notiSubType + " noti status : " + notiStatus);
			}
			
			model.addAttribute("result", "OK");
		}
		
		logger.debug("adminNoticeMailOk ended.");
		
		return "json";
	}
	
	/**
	 * 테마1 My 커뮤니티 새글 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getMyCoummunityBoardList.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getMyCoummunityBoardList (@RequestBody String xmlStr,@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getMyCoummunityBoardList started.");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		String clubNo = xmlDom.getElementsByTagName("C_CLUBNO").item(0).getTextContent();
		String result = ezCommunityService.getMyCoummunityBoardList(userInfo, clubNo);
		
		logger.debug("getMyCoummunityBoardList ended.");
		return result;
	}
	
	/**
	 * 커뮤니티 답변메일발송
	 */
	@RequestMapping(value = "/ezCommunity/sendReplyNoticeMail.do", method = RequestMethod.POST)
	@ResponseBody
	public void sendReplyNoticeMail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("sendReplyNoticeMail started.");
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String itemTreeID = request.getParameter("itemTreeID");
		
		ezCommunityService.sendReplyNoticeMail(request, boardID, itemID, itemTreeID, loginCookie);
		
		logger.debug("sendReplyNoticeMail ended.");
	}
	
    /**
     * 댓글 팝업화면 조회
     * 강민수92
     */
    @RequestMapping(value = "/ezCommunity/communityCommentPopup.do", method = RequestMethod.GET)
    public String communityCommentPopup(@CookieValue("loginCookie") String loginCookie, CommunityBoardItemVO boardItemVO, Model model) throws Exception {
    	logger.debug("comunnityCommentPopup started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    		
		String pBoardID = boardItemVO.getBoardID();
		String pItemID = boardItemVO.getItemID();
		String gubun  = boardItemVO.getGubun();
		String code  = boardItemVO.getCode();
		String publicModulus = egovFileScrty.getPbm();
        String publicExponent = "10001";
		
        // 댓글 작성자의 deptID를 가져온다. companyID 조건 추가.
		List<CommunityOneLineReplyVO> oneLineReplyList = ezCommunityService.readOneLineReply(userInfo.getPrimary(), pBoardID, pItemID, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getOffset(), gubun);
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID, code);
		
    	model.addAttribute("gubun", gubun);
    	model.addAttribute("boardInfo", boardInfo);
    	model.addAttribute("publicModulus", publicModulus);
    	model.addAttribute("publicExponent", publicExponent);
    	model.addAttribute("boardItemVo", boardItemVO);
    	model.addAttribute("userInfo", userInfo);
    	model.addAttribute("boardLineReplyVOList", oneLineReplyList);
    	
    	logger.debug("communityCommentPopup ended.");
    	
    	return "/ezCommunity/communityCommentPopup";
    }
    /**
     * 2018-02-06 김보미 - 리스트 페이징 처리
     */
	@RequestMapping(value = "/ezCommunity/itemReadPagingList.do", method = RequestMethod.GET, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String itemReadPagingList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, String boardID, String itemID, int pageNum, int perCount) throws Exception {
		logger.debug("itemReadPagingList started");

		userInfo = commonUtil.userInfo(loginCookie);

		/* 커뮤니티 게시물 조회자 정보 가져올 때 deptID도 함께 가져오도록 수정(companyID 조건 추가) */
		StringBuffer resultXML = ezCommunityService.getReaderList(boardID,itemID,userInfo.getId(),commonUtil.getMultiData(userInfo.getLang(),userInfo.getTenantId()), userInfo.getCompanyID(), userInfo.getTenantId(), pageNum, perCount, userInfo.getOffset());

		logger.debug("itemReadPagingList ended");
		return resultXML.toString();
	}
	
	/**
	 * 2018-07-03 홍승비 - 커뮤니티 답변알림메일 사용 시 companyID 비교 부분 추가
	 */
	@RequestMapping(value = "/ezCommunity/getItemViewNew.do", method = RequestMethod.GET, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getItemViewNew(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getItemViewNew started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");		
		String result = "OK";
		
		// 답변메일의 게시물 정보를 가져온다.
		CommunityBoardItemVO item = ezCommunityService.getItemXML(boardID, itemID, userInfo);
		
		// 회사가 다르면 result를 FAIL로 반환한다. 사용자의 lang에 따라 회사이름을 다국어로 보낸다.
		if (!item.getWriterCompanyID().equals(userInfo.getCompanyID())) {
			return "<DATA><DATA1>FAIL</DATA1><DATA2>" + item.getWriterCompanyName() + "</DATA2></DATA>";
		}
		
		logger.debug("getItemViewNew ended.");
		
		return "<DATA>" + result + "</DATA>";
	}
	
	/**
	 * 2019-01-10 홍승비 - 커뮤니티 게시판 > 부모게시판ID 리턴하는 함수 추가
	 */
	@RequestMapping(value = "/ezCommunity/getParentBoardID.do", method = RequestMethod.GET, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getParentBoardID(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getParentBoardID started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String boardID = request.getParameter("boardID");
		String result = "";
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, "");
		
		if(boardInfo != null) {
			if (boardInfo.getParentBoardID() != null && !boardInfo.getParentBoardID().equals("")) {
				result = boardInfo.getParentBoardID();
			}
		}
		
		logger.debug("getParentBoardID ended.");
		
		return result;
	}
	
	/**
	 * 2020-08-31 홍승비 - 자신이 가입한 커뮤니티의 게시판을 표출하는 UI 호출 메서드
	 * */
    @RequestMapping(value = "/ezCommunity/communityBoardSelectForMail.do", method = RequestMethod.GET)
    public String communityBoardSelectForMail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
    	logger.debug("communityBoardSelectForMail started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	List<CommunityClubVO> clubList = ezCommunityService.getLeftCommunity(userInfo, "Y");
		
		model.addAttribute("clubList", clubList);
		model.addAttribute("clubListSize", clubList.size());
		model.addAttribute("lang", commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId())); // 기본언어 1, 다국어 설정이라면 2
    	model.addAttribute("userInfo", userInfo);
    	
    	logger.debug("communityBoardSelectForMail ended.");
    	return "/ezCommunity/communityBoardSelectForMail";
    }
    
	/**
	 * 2021-05-03 홍승비 - 해당 커뮤니티의 전체 게시물 개수를 가져오는 함수 (ajax용)
	 */
	@RequestMapping(value = "/ezCommunity/getCommunityBoardItemCnt.do", method = RequestMethod.GET)
	@ResponseBody
	public int getCommunityBoardItemCnt(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getCommunityBoardItemCnt started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		int result = 0;
		
		result = ezCommunityService.categoryListItemCntGet(code, userInfo.getTenantId());
		
		logger.debug("getCommunityBoardItemCnt ended, result = " + result);
		return result;
	}
	
	/**
	 * 2021-05-03 홍승비 - 해당 커뮤니티의 유형(승인여부)을 가져오는 함수 (ajax용)
	 */
	@RequestMapping(value = "/ezCommunity/getClubConfirmType.do", method = RequestMethod.GET)
	@ResponseBody
	public String getClubConfirmType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getClubConfirmType started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String result = "";
		
		result = ezCommunityService.getClubConfirmType(code, userInfo.getTenantId());
		
		logger.debug("getClubConfirmType ended, result = " + result);
		return result;
	}
	
	/**
	 * 2021-11-09 홍승비 - 커뮤니티 게시판에 자신이 읽지 않은 신규 게시물 존재 여부를 표출 (ajax)
	 * */
	@RequestMapping(value = "/ezCommunity/getIsNewItemExists.do", method = RequestMethod.GET)
	@ResponseBody
	public String getIsNewItemExists(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getIsNewItemExists started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String result = "";
		
		result = ezCommunityService.getIsNewItemExists(boardID, userInfo.getId(), userInfo.getTenantId());
		
		logger.debug("getIsNewItemExists ended, result = " + result);
		return result;
	}
	
	/**
	 * 2021-11-15 홍승비 - 커뮤니티 게시판 메일알림 메일 발송 컨트롤러 (게시알림, 수정알림, 댓글알림)
	 * */
	@RequestMapping(value = "/ezCommunity/sendCommBoardAlertMail.do", method = RequestMethod.POST)
	@ResponseBody
	public void sendCommBoardAlertMail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("sendCommBoardAlertMail started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String pMode = request.getParameter("mode");
		List<InternetAddress> to = new ArrayList<InternetAddress>();
		
		// 커뮤니티 게시판 옵션에서 메일알림을 사용하는 경우에만 발송한다.
		CommunityBoardPropertyVO boardProperty = ezCommunityService.getBoardProperty(boardID, userInfo.getTenantId());
		CommunityBoardItemVO itemVO = ezCommunityService.getItemXML(boardID, itemID, userInfo);
		
		// 2024-04-29 한태훈 > 커뮤니티 통합알림 추가
		List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();		
		// 신규 게시물 등록, 수정 알림에 대한 수신인 ID 리턴 (커뮤니티에 가입승인된 모든 사용자들)
		if ((pMode.equals("new") && boardProperty.getMailFG_Post() != null && boardProperty.getMailFG_Post().equals("Y")) || (pMode.equals("modify") && boardProperty.getMailFG_Mod() != null && boardProperty.getMailFG_Mod().equals("Y"))) {
			List<CommunityClubVO> list = ezCommunityService.adminNoticeMailOkGet2(boardProperty.getC_ClubNo(), userInfo.getTenantId());
			
				for (CommunityClubVO vo : list) {
					if (vo.getEmail() != null) {
			        	InternetAddress to1 = new InternetAddress();
			        	to1.setPersonal(vo.getUserName(), "UTF-8");
			        	to1.setAddress(vo.getEmail());
			        	
						Map<String, Object> recipientMap = new HashMap<String, Object>();
						recipientMap.put("userType", "PERSON");
						recipientMap.put("companyId", userInfo.getCompanyID());
						recipientMap.put("cn", vo.getUserId());
						notiRecipientList.add(recipientMap);
						
			        	if (ezPersonalService.hasNotiDiableItem(vo.getUserId(), NotiType.fromString("COMMUNITY_" + pMode.toString()), NotiPlatform.MAIL, userInfo.getTenantId())) {
							continue;
						}
			        	
			        	to.add(to1);
			        	
			        }
				}
		}
		// 게시물 댓글 알림에 대한 수신인 ID 리턴 (댓글이 달린 게시물의 작성자)
		else if (pMode.equals("comment") && boardProperty.getMailFG_Comment() != null && boardProperty.getMailFG_Comment().equals("Y")) {
			OrganUserVO uvo = ezOrganAdminService.getUserInfo(itemVO.getWriterID(), userInfo.getPrimary(), userInfo.getTenantId());
			
			// 가입승인된 사용자에게만 메일을 발송하도록 작성자의 이메일로 체크 (커뮤니티 탈퇴했다면 메일 발송 안함)
        	boolean chkUser = ezCommunityService.checkUserInCommunity(boardProperty.getC_ClubNo(), uvo.getCn(), userInfo.getTenantId());
			if (chkUser == true) {
				InternetAddress to1 = new InternetAddress();
				to1.setPersonal(uvo.getDisplayName(), "UTF-8");
	        	to1.setAddress(uvo.getMail());
	        	
	        	Map<String, Object> recipientMap = new HashMap<String, Object>();
				recipientMap.put("userType", "PERSON");
				recipientMap.put("companyId", userInfo.getCompanyID());
				recipientMap.put("cn", itemVO.getWriterID());
				notiRecipientList.add(recipientMap);
	        	
	        	if (!ezPersonalService.hasNotiDiableItem(itemVO.getWriterID(), NotiType.fromString("COMMUNITY_COMMENT"), NotiPlatform.MAIL, userInfo.getTenantId())) {
	        		to.add(to1);
				}
	        } else {
	        	return;
	        }
		}
		// 메일발송 하지 않는 경우, 바로 리턴
		else {
			logger.debug("sendCommBoardAlertMail ended. (mail alert is not used for mode [" + pMode + "])");
			return;
		}
        
		// 메일 본문 생성 (게시물 링크, 게시일 정보 등 포함)
		StringBuilder bodyContent = new StringBuilder();
		String content = "";
		String subject = "";
		String strURL = "";
		CommunityClubVO clubVO = ezCommunityService.aspCommInfoGet1(boardProperty.getC_ClubNo(), userInfo.getTenantId());
		String boardName = ezCommunityService.getClubBoardNameLocalization(userInfo.getLang(), boardProperty);
		
		// 포토게시물과 일반(그룹, 익명) 게시물 링크 분기처리
		if (boardProperty.getGubun().equals("3")) {
			strURL = "<a id='community_a' style='color:blue;text-decoration:underline;cursor:pointer;' onclick=\"" + "item_ViewPhoto_New_Community('" + boardID + "', '" + itemID + "', '" + boardProperty.getC_ClubNo() + "'); return false;" + "\" href=\"_blank\" target=\"_blank\">";
		} else {
			strURL = "<a id='community_a' style='color:blue;text-decoration:underline;cursor:pointer;' onclick=\"" + "item_View_New_Community('" + boardID + "', '" + itemID + "', '" + boardProperty.getC_ClubNo() + "'); return false;" + "\" href=\"_blank\" target=\"_blank\">";
		}
		
		/* 2021-12-28 홍승비 - 커뮤니티 게시물 관련 알림메일에 커뮤니티명을 표출 */
		if (pMode.equals("new")) { // 게시판 게시알림 (아래 게시판에 새 게시글이 게시되었습니다.)
			bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.t250", userInfo.getLocale()) + "<br><br>");
			bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("main.t1006", userInfo.getLocale()) + " : " + commonUtil.cleanValue(boardProperty.getC_ClubName()));
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t117", userInfo.getLocale()) + commonUtil.cleanValue(boardProperty.getBoardName()));
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t118", userInfo.getLocale()) + itemVO.getWriteDate());
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t119", userInfo.getLocale()) + userInfo.getDisplayName() + "(" + (userInfo.getTitle() == null || "null".equals(userInfo.getTitle()) ? "" : userInfo.getTitle()) + ", " + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t120", userInfo.getLocale()) + strURL + commonUtil.cleanValue(itemVO.getTitle()) + "</a>");
	        
	        content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
	        subject = "[Community " + egovMessageSource.getMessage("ezBoard.HSBMail01", userInfo.getLocale()) + "-" + boardName + "] " + itemVO.getTitle();
		}
		else if (pMode.equals("modify")) { // 게시판 수정알림 (아래 게시판의 게시물이 수정되었습니다.)
			bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.HSBMail05", userInfo.getLocale()) + "<br><br>");
			bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("main.t1006", userInfo.getLocale()) + " : " + commonUtil.cleanValue(boardProperty.getC_ClubName()));
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t117", userInfo.getLocale()) + commonUtil.cleanValue(boardProperty.getBoardName()));
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t118", userInfo.getLocale()) + itemVO.getWriteDate());
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t119", userInfo.getLocale()) + userInfo.getDisplayName() + "(" + (userInfo.getTitle() == null || "null".equals(userInfo.getTitle()) ? "" : userInfo.getTitle()) + ", " + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t120", userInfo.getLocale()) + strURL + commonUtil.cleanValue(itemVO.getTitle()) + "</a>");
	        
	        content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
	        subject = "[Community " + egovMessageSource.getMessage("ezBoard.HSBMail02", userInfo.getLocale()) + "-" + boardName + "] " + itemVO.getTitle();
		}
		else if (pMode.equals("comment")) { // 게시판 댓글알림 (아래 게시판의 게시물에 댓글이 등록되었습니다.)
			bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.HSBMail06", userInfo.getLocale()) + "<br><br>");
			bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("main.t1006", userInfo.getLocale()) + " : " + commonUtil.cleanValue(boardProperty.getC_ClubName()));
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t117", userInfo.getLocale()) + commonUtil.cleanValue(boardProperty.getBoardName()));
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t118", userInfo.getLocale()) + itemVO.getWriteDate());
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t119", userInfo.getLocale()) + userInfo.getDisplayName() + "(" + (userInfo.getTitle() == null || "null".equals(userInfo.getTitle()) ? "" : userInfo.getTitle()) + ", " + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t120", userInfo.getLocale()) + strURL + commonUtil.cleanValue(itemVO.getTitle()) + "</a>");
	        
	        content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
	        subject = "[Community " + egovMessageSource.getMessage("ezBoard.HSBMail03", userInfo.getLocale()) + "-" + boardName + "] " + itemVO.getTitle();
		}
		else {
			return;
		}
		
		// 수신인 ID에 대해 전체 메일발송 실행
		InternetAddress from = new InternetAddress();
    	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
    	from.setAddress(userInfo.getEmail());
    	
    	if (to != null && to.size() > 0) {
    		ezEmailService.sendMail(loginCookie, from, to.toArray(new InternetAddress[to.size()]), null, null, subject, content, false);
    	}
		
		// 2024-04-29 한태훈 - 커뮤니티 > 게시판 통합 알림 추가 
		String boardType = boardProperty.getGubun();
		String linkUrl = "";
		String linkUrlMobile = "";
		
		String tempItemID = ezCommunityService.encodeURIComponent(itemID);
		String tempBoardID = ezCommunityService.encodeURIComponent(boardID);
		
		switch (boardType) {
		case "3":
		case "4":
			linkUrl += "/ezCommunity/boardItemViewPhoto.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardID);
			break;
		case "7":
			linkUrl += "/ezCommunity/boardItemViewMovie.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardID);
			break;
		default:
			linkUrl += "/ezCommunity/boardItemView.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardID) + "&code=" + boardProperty.getC_ClubNo();
			break;
		}
		
    	String notiSubType = pMode.toUpperCase();
		
    	if (notiRecipientList != null && notiRecipientList.size() > 0) {
			String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "community", notiSubType, boardName + " - " + itemVO.getTitle(), "popup", "750", "721", linkUrl, linkUrlMobile, "");
			logger.debug("community " +  notiSubType + " noti status : " + notiStatus);
    	}
    	
		logger.debug("sendCommBoardAlertMail ended.");
	}

	@RequestMapping(value = "/ezCommunity/popularBoardItem.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String popularBoardItem (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("popularBoardItem started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String result = ezCommunityService.popularBoardItem(userInfo);

		logger.debug("popularBoardItem ended.");
		return result;
	}

	@RequestMapping(value = "/ezCommunity/communityMainPopBoardAlert.do", method = RequestMethod.GET)
	public String communityPopBoardAlert () throws Exception {
		logger.debug("communityPopBoardAlert started.");
		logger.debug("communityPopBoardAlert ended.");
		
		return "ezCommunity/communityMainPopBoardAlert";
	}
	
	@RequestMapping(value="/ezCommunity/WHWPEditor.do", method = RequestMethod.GET)
	public String WHWPEditor(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("WHWPEditor started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String type = request.getParameter("type");
		
		model.addAttribute("webHWPUrl", ezCommonService.getTenantConfig("webHWPUrl", userInfo.getTenantId()));
		model.addAttribute("type", type);
		
		logger.debug("WHWPEditor ended.");
		return "/ezCommunity/communityWHWPEditor";
	}

	@RequestMapping(value="/ezCommunity/downloadAttachAll.do", method = RequestMethod.POST, produces="text/plain; charset=UTF-8")
	@ResponseBody
	public void downloadAttachAll(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttachAll started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String fileNames = request.getParameter("fileNames");
		String fileNamesUID = request.getParameter("fileNamesUID");
		String realPath = commonUtil.getRealPath(request);
		String filePath = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator + request.getParameter("filePath");
		String uploadFilePath = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId());
		String tempFileUploadPath = realPath + uploadFilePath + commonUtil.separator + "tempUploadFile";
		String guid = UUID.randomUUID().toString();
		String pDirTempPath = tempFileUploadPath + commonUtil.separator + guid;
		String fullFilePath = realPath + filePath;

		ZipOutputStream zos = null;
		String downFileName = "";

		try {
			File tempFile = new File(pDirTempPath + commonUtil.separator + ".zip");

			if (tempFile.exists()) {
				tempFile.delete();
			}

			tempFile = new File(tempFileUploadPath);

			if (!tempFile.exists()) {
				tempFile.mkdirs();
			}

			zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"), Charset.forName("utf-8"));

			String[] fileNamesArr = fileNames.split(":");
			String[] fileNamesUIDArr = fileNamesUID.split(":");

			downFileName = fileNamesArr[0] + " " + egovMessageSource.getMessage("ezCircular.t50", userInfo.getLocale()) + " " + (fileNamesArr.length-1) + egovMessageSource.getMessage("ezStatistics.t1067", userInfo.getLocale()) + ".zip";

			Map<String, Integer> fileNameMap = new HashMap<String, Integer>();

			if (fileNamesArr.length != 0) {
				for (int i = 0; i < fileNamesArr.length; i++) {
					BufferedInputStream bis = null;

					try {
						File sourceFile = new File(commonUtil.detectPathTraversal(fullFilePath + fileNamesUIDArr[i]));
						byte[] fileBytes = commonUtil.readBytesFromFile(sourceFile.toPath());

						if (fileNamesUIDArr[i].endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
							fileBytes = klibUtil.decrypt(fileBytes);
						}

						fileNamesArr[i] = commonUtil.getUniqueFileName(fileNamesArr[i], fileNameMap);
						ZipEntry zentry = new ZipEntry(fileNamesArr[i]);
						zos.putNextEntry(zentry);
						zos.write(fileBytes);
						zos.closeEntry();
					} catch (IOException e) {
						logger.error(e.getMessage(), e);
					} finally {
						if (bis != null) {
							try {
								bis.close();
							} catch (Exception e) {
								logger.error(e.getMessage(), e);
							}
						}
					}
				}
				zos.flush();
				zos.close();
				zos = null;

				File file = new File(pDirTempPath + ".zip");

				if (file.exists()) {
					downFile(request, response, pDirTempPath + ".zip", downFileName);
					file.delete();
				}
			}
		} catch (Exception e) {
			File file = new File(pDirTempPath + ".zip");

			if (file.exists()) {
				file.delete();
			}
		} finally {
			if (zos != null) {
				try {
					zos.close();
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		logger.debug("downloadAttachAll ended.");
	}
	
    // 2024-10-30 황인경 - 커뮤니티 > 방명록 > 댓글 추가
    @RequestMapping(value = "/ezCommunity/guestOneLineReply.do", method = RequestMethod.POST)
    @ResponseBody
    public String guestOneLineReply(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
        logger.debug("guestOneLineReply started.");

        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        String result = "error";
        try {
            String cNoStr = request.getParameter("c_no");
            int cNo = Integer.parseInt(cNoStr);

            String code = request.getParameter("code");
            String memo = URLDecoder.decode(request.getParameter("memo"), "utf-8");

            ezCommunityService.insertGuestOneLineReply(cNo, code, userInfo.getCompanyID(), userInfo.getTenantId(), memo, userInfo);

            result = "success";
        } catch (Exception e) {
            logger.debug("e: {}", e);
        }

        logger.debug("guestOneLineReply ended.");

        return result;
    }

    // 2024-10-30 황인경 - 커뮤니티 > 방명록 > 댓글 삭제
    @RequestMapping(value = "/ezCommunity/deleteGuestOneLineReply.do", method = RequestMethod.POST)
    @ResponseBody
    public void deleteGuestOneLineReply(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
        logger.debug("deleteGuestOneLineReply started.");
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        String replyNo = request.getParameter("replyNo");

        ezCommunityService.deleteGuestOneLineReply(replyNo, userInfo.getTenantId());
        logger.debug("deleteGuestOneLineReply ended.");
    }

    // 2024-10-30 황인경 - 커뮤니티 > 방명록 > 댓글 수정
    @RequestMapping(value = "/ezCommunity/modifyGuestOneLineReply.do", method = RequestMethod.POST)
    @ResponseBody
    public void modifyGuestOneLineReply(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
        logger.debug("modifyGuestOneLineReply started.");
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        String replyNo = request.getParameter("replyNo");
        String content = URLDecoder.decode(request.getParameter("content"), "utf-8");

        ezCommunityService.modifyGuestOneLineReply(replyNo, content, userInfo.getTenantId());
        logger.debug("modifyGuestOneLineReply ended.");
    }
    
	@RequestMapping(value = "/ezCommunity/communitySearchResult.do", method = RequestMethod.POST)
	public String getSearchResult(@CookieValue("loginCookie") String loginCookie, String code, String searchWord, String sortBy, String pageNum, Model model, HttpServletRequest request) throws Exception {
		logger.debug("getSearchResult started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String[] beforeSearchTypeArray = request.getParameterValues("beforeSearchType");
		String[] beforeKeywordArray = request.getParameterValues("beforeKeyword");
		String refineInResult = request.getParameter("refineInResult");
		String searchType = request.getParameter("searchType");
		List<String> beforeSearchType = beforeSearchTypeArray != null ? new ArrayList<>(Arrays.asList(beforeSearchTypeArray)) : new ArrayList<>();
		List<String> beforeKeyword = beforeKeywordArray != null ? new ArrayList<>(Arrays.asList(beforeKeywordArray)) : new ArrayList<>();
		List<Map<String,String>> searchMaps = new ArrayList<Map<String,String>>();
		
		if (null != refineInResult && "on".equals(refineInResult)) {
			beforeSearchType.add(searchType);
			beforeKeyword.add(searchWord);
			refineInResult = "checked";
			
			for (int i = 0; i < beforeSearchType.size(); i++) {
				HashMap<String, String> searchMap = new HashMap<>();
				searchMap.put("searchType", beforeSearchType.get(i));
				searchMap.put("searchWord", beforeKeyword.get(i));
				
				searchMaps.add(searchMap);
			}
		} else {
			beforeSearchType.clear();
			beforeKeyword.clear();
			
			beforeSearchType.add(searchType);
			beforeKeyword.add(searchWord);
			
			HashMap<String, String> searchMap = new HashMap<>();
			searchMap.put("searchType", searchType);
			searchMap.put("searchWord", searchWord);
			
			searchMaps.add(searchMap);
		}
		
		String resList = ezCommunityService.commBoardTotalSearchList(searchMaps, userInfo, sortBy, pageNum, code);
		int totalCount = ezCommunityService.commuTotalSearchCount(searchMaps, userInfo, sortBy, pageNum, code);
		String pastDate = commonUtil.getTodayUTCTime("");
		pastDate = EgovDateUtil.addDay(pastDate, -1, "yyyy-MM-dd HH:mm:ss");
		pastDate = EgovDateUtil.addYMDtoDayTime(pastDate.substring(0, 10), pastDate.substring(11, 16), 0, 0, 0, 0, Integer.parseInt(commonUtil.getMinuteUTC(userInfo.getOffset())), "yyyy-MM-dd HH:mm:");
		pastDate = pastDate.concat(commonUtil.getTodayUTCTime("").substring(17,19));
		
		model.addAttribute("searchWord", searchWord);
		model.addAttribute("beforeSearchType", beforeSearchType);
		model.addAttribute("beforeKeyword", beforeKeyword);
		model.addAttribute("refineInResult", refineInResult);
		model.addAttribute("searchType", searchType);
		model.addAttribute("resList", resList);
		model.addAttribute("pastDate", pastDate);
		model.addAttribute("code", code);
		model.addAttribute("pSortBy", sortBy);
		model.addAttribute("pageNum", pageNum == null || "".equals(pageNum) ? 1 : pageNum);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPage", totalCount % 10 == 0 ? totalCount / 10 : totalCount / 10 + 1);
		
		logger.debug("getSearchResult ended.");
		
		return "/ezCommunity/communitySearchResult";
	}
	
	@RequestMapping(value = "/ezCommunity/selectToDownloadFiles.do", method = RequestMethod.GET)
	public String selectToDownloadFiles(@CookieValue("loginCookie") String loginCookie, String itemID, String boardID, String code, Model model, HttpServletRequest request) throws Exception {
		logger.debug("selectToDownloadFiles started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, code);
		
		if (!boardInfo.getRead_FG().equalsIgnoreCase("true")) {
			return "main/warning";
		}
		
		model.addAttribute("attachList", ezCommunityService.getItemAttachmentInfo(itemID, userInfo.getTenantId()));
		logger.debug("selectToDownloadFiles ended.");
		
		return "/ezCommunity/selectToDownloadFiles";
	}
	
	@RequestMapping(value = "/ezCommunity/checkPollPeriod.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String checkPollPeriod(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("checkPollPeriod started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = request.getParameter("code");
		String pollManagerID = request.getParameter("pollManagerID");
		
		int result = ezCommunityService.checkPollPeriod(code, pollManagerID, userInfo);

		logger.debug("checkPollPeriod ended.");
		return -1 != result ? (1 == result ? "ok" : "Inactive") : "deleted";
	}

	/**
	 * 회원등급 관리 화면
	 */
	@RequestMapping(value = "/ezCommunity/adminMemberGrade.do", method = RequestMethod.GET)
	public String adminMemberGrade(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("adminMemberGrade started.");

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

		model.addAttribute("code", code);
		model.addAttribute("mode", mode);

		logger.debug("adminMemberGrade ended.");

		return "ezCommunity/communityAdminMemberGrade";
	}

	/**
	 * 회원등급 관리 저장
	 */
	@RequestMapping(value = "/ezCommunity/adminMemberGradeSave.do", method = RequestMethod.POST)
	@ResponseBody
	public String adminMemberGradeSave(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param) throws Exception {
		logger.debug("adminMemberGradeSave started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = param.get("code").toString(); // 커뮤니티 아이디
		String joinGrade = param.get("joinGrade").toString(); // 회원가입시 최초등급
		List<String> gradeList = (List<String>) param.get("gradeName"); // 회원등급 리스트
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();

		ezCommunityService.updateJoinGrade(code, joinGrade, companyID, tenantID);
		ezCommunityService.deleteGradeList(code, companyID, tenantID);

		String result = ezCommunityService.saveGradeList(code, gradeList, companyID, tenantID);

		logger.debug("adminMemberGradeSave ended.");
		return result;
	}

	/**
	 * 회원등급 관리 조회
	 */
	@RequestMapping(value = "/ezCommunity/getAdminMemberGrade.do", method = RequestMethod.GET)
	@ResponseBody
	public List<CommunityMemberGradeVO> getAdminMemberGrade(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("getAdminMemberGrade started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();

		List<CommunityMemberGradeVO> memberGrade = ezCommunityService.getMemberGrade(code, companyID, tenantID);

		logger.debug("getAdminMemberGrade ended.");

		return memberGrade;
	}

	/**
	 * 회원목록 > 회원등급 변경
	 */
	@RequestMapping(value = "/ezCommunity/adminMemberGradeUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public String adminMemberGradeUpdate(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param) throws Exception {
		logger.debug("adminMemberGradeUpdate started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = param.get("code").toString();
		String grade = param.get("grade").toString();
		List<String> userIds = (List<String>) param.get("userIds");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();

		ezCommunityService.updateMemberGrade(code, grade, userIds, companyID, tenantID);

		logger.debug("adminMemberGradeUpdate ended.");
		return "true";
	}

	/**
	 * 회원목록 > 회원등급 삭제시 회원존재여부 체크
	 */
	@RequestMapping(value = "/ezCommunity/adminMemberGradeCount.do", method = RequestMethod.POST)
	@ResponseBody
	public int adminMemberGradeCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("adminMemberGradeCount started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = request.getParameter("code");
		String grade = request.getParameter("grade");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();

		int gradeCount = ezCommunityService.getGradeCount(code, grade, companyID, tenantID);

		logger.debug("adminMemberGradeCount ended.");
		return gradeCount;
	}

	/**
	 * 운영진 관리 화면
	 */
	@RequestMapping(value = "/ezCommunity/adminOperatorManage.do", method = RequestMethod.GET)
	public String adminOperatorManage(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = request.getParameter("code");

		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());

		if (sysopCheck != 1) {
			return "cmm/error/egovError";
		}

		int postCount = ezCommunityService.adminOperatorListCount(userInfo, code);

		String idSpanValue = ezCommunityService.adminOperatorList(userInfo, code);

		model.addAttribute("code", code);
		model.addAttribute("postCount", postCount);
		model.addAttribute("idSpanValue", idSpanValue);

		return "ezCommunity/communityAdminOperatorManage";
	}

	/**
	 * 운영진 관리 > 운영자 삭제
	 */
	@RequestMapping(value = "/ezCommunity/adminDeleteOperator.do", method = RequestMethod.POST)
	@ResponseBody
	public String adminDeleteOperator(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param) throws Exception {
		logger.debug("adminDeleteOperator started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = param.get("code").toString();
		List<String> userIds = (List<String>) param.get("userIds");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();

		ezCommunityService.deleteClubOperator(code, userIds, companyID, tenantID);

		logger.debug("adminDeleteOperator ended.");
		return "true";
	}

	/**
	 * 운영진 관리 > 관리권한 저장
	 */
	@RequestMapping(value = "/ezCommunity/adminOperatorManageSave.do", method = RequestMethod.POST)
	@ResponseBody
	public String adminOperatorManageSave(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param) throws Exception {
		logger.debug("adminOperatorManageSave started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = param.get("code").toString();
		List<String> manages = (List<String>) param.get("manages");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();

		ezCommunityService.updateClubOperatorAuth(code, manages, companyID, tenantID);

		logger.debug("adminOperatorManageSave ended.");
		return "true";
	}

	/**
	 * 운영진 관리 > 운영자 추가
	 */
	@RequestMapping(value = "/ezCommunity/adminAddOperator.do", method = RequestMethod.GET)
	public String adminAddOperator(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("adminAddOperator started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int curPage = 1;
		String block = "";
		String code = request.getParameter("code");
		String keyword = request.getParameter("keyword");
		String type = request.getParameter("type");
		if (request.getParameter("goToPage") != null) {
			curPage = Integer.parseInt(request.getParameter("goToPage"));
		}
		if (request.getParameter("block") != null) {
			block = request.getParameter("block");
		}

		int comNoPerPage = 7;

		int keywordCount = ezCommunityService.getNoOperatorListCount(userInfo.getCompanyID(), userInfo.getTenantId(), code, keyword, type);

		int totalPage = keywordCount / comNoPerPage;

		if ((totalPage * comNoPerPage) != keywordCount && (keywordCount % comNoPerPage) != 0){
			totalPage = totalPage + 1;
		}

		String idSpanValue = ezCommunityService.adminOperatorAddList(userInfo, code, keyword, type, comNoPerPage, curPage);

		int postCount = ezCommunityService.adminOperatorListCount(userInfo, code);

		model.addAttribute("code", code);
		model.addAttribute("idSpanValue", idSpanValue);
		model.addAttribute("postCount", postCount);
		model.addAttribute("curPage", curPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("nowBlock", block);
		model.addAttribute("keyword", keyword);
		model.addAttribute("type", type);

		logger.debug("adminAddOperator ended");
		return "ezCommunity/communityAdminOperatorAdd";
	}

	@RequestMapping(value = "/ezCommunity/adminOperatorGradeUpdate.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String adminOperatorGradeUpdate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("adminOperatorGradeUpdate started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = request.getParameter("code");
		String userId = request.getParameter("userId");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();

		ezCommunityService.updateOperatorGrade(code, userId, companyID, tenantID);

		logger.debug("adminOperatorGradeUpdate ended.");
		return "true";
	}

	/**
	 * 커뮤니티 메인화면 > 게시판 게시물 읽기권한 체크
	 * */
	@RequestMapping(value = "/ezCommunity/getBoardReadFG.do", method = RequestMethod.GET)
	@ResponseBody
	public String getBoardReadFG(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getBoardReadFG started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String code = request.getParameter("code");
		String result = "";

		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID, code);

		result = boardInfo.getRead_FG();

		logger.debug("getBoardReadFG ended, result = " + result);
		return result;
	}

	/**
	 * 회원목록 > 등급변경 팝업
	 */
	@RequestMapping(value = "/ezCommunity/changeGradePopup.do", method = RequestMethod.GET)
	public String changeGradePopup(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("changeGradePopup started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = request.getParameter("code");

		model.addAttribute("code", code);

		logger.debug("changeGradePopup ended");
		return "ezCommunity/communityChangeGradePopup";
	}

	/**
	 * 커뮤니티 > 회원목록 > 엑셀 다운로드
	 */
	@RequestMapping(value = "/ezCommunity/excelExportOut.do", method = RequestMethod.GET)
	@ResponseBody
	public void excelExportOut(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("excelExportOut started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		StringBuilder resultExcel = new StringBuilder();
		String excelValue = "";
		String selectGrade = "";
		String selectMonth = "";
		String code = request.getParameter("code");
		String sRadio = request.getParameter("sRadio") != null ? request.getParameter("sRadio") : "";
		String keyword = request.getParameter("keyword");
		if (request.getParameter("selectGrade") != null && !request.getParameter("selectGrade").equals("0")) {
			selectGrade = request.getParameter("selectGrade");
		}
		if (request.getParameter("selectMonth") != null && !request.getParameter("selectMonth").equals("0")) {
			selectMonth = request.getParameter("selectMonth");
		}
		String startdate = request.getParameter("startdate");
		String enddate = request.getParameter("enddate");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");

		String strSysopID = ezCommunityService.adminMemberListGet2(code, userInfo.getTenantId()).trim();
		excelValue = ezCommunityService.commViewMember(userInfo, code, strSysopID, keyword, sRadio, 0, 0, 0, 0, "0", selectGrade, orderCell, orderOption, selectMonth, startdate, enddate);

		resultExcel.append("\uFEFF");
		resultExcel.append("<table><tbody>");
		resultExcel.append("<tr><th style='width:40px'>" + egovMessageSource.getMessage("ezCommunity.t32", userInfo.getLocale()) + "</th>");
		resultExcel.append("<th style='width:110px'>" + egovMessageSource.getMessage("ezCommunity.t10", userInfo.getLocale()) + "</th>");
		resultExcel.append("<th style='width:100px'>" + egovMessageSource.getMessage("ezCommunity.lyj16", userInfo.getLocale()) + "</th>");
		resultExcel.append("<th style='width:60px'>" + egovMessageSource.getMessage("ezCommunity.t241", userInfo.getLocale()) + "</th>");
		resultExcel.append("<th style='width:60px'>" + egovMessageSource.getMessage("ezCommunity.t512", userInfo.getLocale()) + "</th>");
		resultExcel.append("<th style='width:60px'>" + egovMessageSource.getMessage("ezCommunity.lyj66", userInfo.getLocale()) + "</th>");
		resultExcel.append("<th style='width:80px'>" + egovMessageSource.getMessage("ezCommunity.lyj67", userInfo.getLocale()) + "</th>");
		resultExcel.append("<th style='width:80px'>" + egovMessageSource.getMessage("ezCommunity.t727", userInfo.getLocale()) + "</th>");
		resultExcel.append("<th style='width:80px'>" + egovMessageSource.getMessage("ezCommunity.t725", userInfo.getLocale()) + "</th>");
		resultExcel.append("<th style='width:80px'>" + egovMessageSource.getMessage("ezCommunity.t726", userInfo.getLocale()) + "</th></tr>");
		resultExcel.append(excelValue);
		resultExcel.append("</tbody></table>");

		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
			HSSFSheet sheet;

			HSSFCellStyle headerStyle = workbook.createCellStyle();
			headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);

			HSSFCellStyle bodyStyle = workbook.createCellStyle();
			bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);

			Row row;
			Cell cell;

			String pFileName = "";
			pFileName = EgovDateUtil.getTodayTime().substring(0, 10) + "_comm_memList";
			sheet = workbook.createSheet("memList");

			String StrAnalysisDate = resultExcel.toString().trim().replaceAll("&nbsp;", "").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\t", "");

			Document analysisData = commonUtil.convertStringToDocument(StrAnalysisDate);

			Node tableNode = analysisData.getElementsByTagName("table").item(0);
			Node tableHeadNode;
			Node tableBodyNode;

			tableHeadNode = tableNode.getChildNodes().item(0).getChildNodes().item(0);
			tableBodyNode = tableNode.getChildNodes().item(0);

			row = sheet.createRow(0);

			for (int i=0; i<tableHeadNode.getChildNodes().getLength(); i++) {
				cell = row.createCell(i);
				cell.setCellValue(tableHeadNode.getChildNodes().item(i).getTextContent());
				cell.setCellStyle(headerStyle);

				sheet.autoSizeColumn(i);
				sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+1024); //너비 더 넓게
			}

			for (int i=0; i<tableBodyNode.getChildNodes().getLength()-1; i++) {
				row = sheet.createRow(i+1);
				Node tr = tableBodyNode.getChildNodes().item(i+1);

				for (int j=0; j<tr.getChildNodes().getLength(); j++) {
					cell = row.createCell(j);
					cell.setCellValue(tr.getChildNodes().item(j).getTextContent());
					cell.setCellStyle(bodyStyle);

					sheet.autoSizeColumn(j);
					sheet.setColumnWidth(j, (sheet.getColumnWidth(j))+1024); //너비 더 넓게
				}
			}
			response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
			workbook.write(response.getOutputStream());

		}
	}

	/**
	 * 커뮤니티 > 초대하기 화면
	 */
	@RequestMapping(value = "/ezCommunity/communityInviteMember.do", method = RequestMethod.GET)
	public String communityInviteMember(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("communityInviteMember started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = request.getParameter("code");
		String userLevel = request.getParameter("userLevel");

		List<CommunityCClubUserVO> clubUserListVO = ezCommunityService.adminMemberListGet3(code, "", userInfo.getPrimary(), "", userInfo.getCompanyID(), userInfo.getTenantId());

		model.addAttribute("userid", userInfo.getId());
		model.addAttribute("code", code);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("clubUserListVO", clubUserListVO);

		logger.debug("communityInviteMember ended.");
		return "ezCommunity/communityInviteMember";
	}

	/**
	 * 초대하기 > 사용자선택 팝업창
	 */
	@RequestMapping(value = "/ezCommunity/communitySelectMember.do", method = RequestMethod.GET)
	public String communitySelectMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {

		logger.debug("============ communitySelectMember started ============");

		String title = request.getParameter("title");
		String code = request.getParameter("code");

		if (title == null) title = "";

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String use_ocs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		List<CommunityCClubUserVO> clubUserListVO = ezCommunityService.adminMemberListGet3(code, "", primaryLang, "", userInfo.getCompanyID(), userInfo.getTenantId());

		model.addAttribute("title", title);
		model.addAttribute("use_ocs", use_ocs);
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("lang", userInfo.getPrimary());
		model.addAttribute("clubUserListVO", clubUserListVO);

		return "ezCommunity/communitySelectMember";
	}

	/**
	 * 초대하기 > 이름확인 조회
	 */
	@RequestMapping(value = "/ezCommunity/checkName.do", method = RequestMethod.GET)
	public String checkName() throws Exception {

		logger.debug("============ checkName started ============");

		return "ezCommunity/communityCheckName";
	}

	/**
	 * 초대하기 > 알림발송
	 */
	@RequestMapping(value = "/ezCommunity/communityInviteSend.do", method = RequestMethod.POST)
	public String communityInviteSend(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = param.get("code").toString();
		Map<String, Object> inviteUserList = (Map<String, Object>) param.get("inviteUserList");

		List<String> userIds = (List<String>) inviteUserList.get("id");

		String clubName = ezCommunityService.join1Get(code, userInfo.getLang(), userInfo.getTenantId());

		String linkUrl = "/ezCommunity/commHome/popupCommHome.do?code=" + code + "&userLevel=0&inviteFlag=true";

		List<InternetAddress> to = new ArrayList<InternetAddress>();

		for (int i = 0; i < userIds.size(); i++) {
			OrganUserVO uvo = ezOrganAdminService.getUserInfo(userIds.get(i), userInfo.getPrimary(), userInfo.getTenantId());

			InternetAddress to1 = new InternetAddress();
			to1.setPersonal(uvo.getDisplayName(), "UTF-8");
			to1.setAddress(uvo.getMail());
			to.add(to1);

			List<Map<String, Object>> notiRecipientList = new ArrayList<Map<String, Object>>();

			Map<String, Object> recipientMap = new HashMap<String, Object>();
			recipientMap.put("userType", "PERSON");
			recipientMap.put("companyId", userInfo.getCompanyID());
			recipientMap.put("cn", userIds.get(i));
			notiRecipientList.add(recipientMap);

			// 통합알림
			ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "COMMUNITY", "INVITE", clubName, "popup", "1300", "900", linkUrl, "", "");
		}

		InternetAddress from = new InternetAddress();
		from.setPersonal(userInfo.getDisplayName(), "UTF-8");
		from.setAddress(userInfo.getEmail());

		StringBuilder bodyContent = new StringBuilder();
		String content = "";
		String subject = "";
		String strURL = "";

		strURL = "<a id='community_a' style='color:blue;text-decoration:underline;cursor:pointer;' href=\"" + linkUrl + "\" target=\"_blank\">";

		bodyContent.append("<br>" + egovMessageSource.getMessage("ezNotification.lyj85", userInfo.getLocale()) + "<br><br>");
		bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("main.t1006", userInfo.getLocale()) + " : " + strURL + commonUtil.cleanValue(clubName));
		bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.lyj86", userInfo.getLocale()) + " : " + userInfo.getDisplayName() + "</a>");

		content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
		subject = "[" + egovMessageSource.getMessage("ezNotification.lyj97", userInfo.getLocale()) + "] " + clubName;

		// 메일알림
		if (to != null && to.size() > 0) {
			ezEmailService.sendMail(loginCookie, from, to.toArray(new InternetAddress[to.size()]), null, null, subject, content, false);
		}

		return "json";
	}
}

