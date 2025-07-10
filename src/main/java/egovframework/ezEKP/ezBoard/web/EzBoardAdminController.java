package egovframework.ezEKP.ezBoard.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URLDecoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.StringJoiner;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
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
import org.w3c.dom.NodeList;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardAttributeVO;
import egovframework.ezEKP.ezBoard.vo.BoardBackgroundVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 관리자 - 게시판관리 
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    장진혁    신규작성
 *
 * @see
 */

@Controller
public class EzBoardAdminController extends EgovFileMngUtil {

	@Autowired
	private CommonUtil commonUtil;

	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;

	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzBoardAdminController.class);

	/**
	 * 게시판관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardMain.do", method = RequestMethod.GET)
	public String boardMain(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("boardMain started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		logger.debug("boardMain ended");
		
		return "admin/ezBoard/boardMain";
	}
	
	/**
	 * 게시판관리 왼쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardLeft.do", method = RequestMethod.GET)
	public String boardLeft(@CookieValue("loginCookie") String loginCookie,	HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardLeft started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String serverName = request.getServerName();
		String redirectBoardID = "";
		String redirectBoardGroupID = "";
		String companyID = Optional.ofNullable(request.getParameter("company")).orElse(user.getCompanyID());

		if (request.getParameter("boardID") != null) {
			redirectBoardID = request.getParameter("boardID");
			List<BoardVO> leftBoardList = ezBoardService.getLeft_BoardSTD(redirectBoardID, user.getTenantId());
			
			redirectBoardGroupID = leftBoardList.get(0).getBoardGroupId();
		}

//		List<OrganDeptVO> listCompanyBoard = ezBoardAdminService.getListCompanyInBoard(user.getId(), user.getPrimary(), user.getTenantId());

		/* 2019-07-09 홍승비 - 게시판 좌측메뉴 게시물 개수 표출 사용여부 플래그 추가 */
        String useLeftCnt = "";
        if (ezCommonService.getTenantConfig("USE_BOARD_LEFTMENU_COUNT", user.getTenantId()) != null) {
        	useLeftCnt = ezCommonService.getTenantConfig("USE_BOARD_LEFTMENU_COUNT", user.getTenantId());
        }
		
		model.addAttribute("redirectBoardID", redirectBoardID);
		model.addAttribute("redirectBoardGroupID", redirectBoardGroupID);
		model.addAttribute("user", user);
		model.addAttribute("serverName", serverName);
		model.addAttribute("useLeftCnt", useLeftCnt);
		model.addAttribute("userCompany", companyID);
//		model.addAttribute("listCompany", listCompanyBoard);
		model.addAttribute("useMealPlan", ezCommonService.getTenantConfig("useMealPlan", user.getTenantId()));

		logger.debug("boardLeft ended");
		return "admin/ezBoard/boardLeft";
	}

	/**
	 * 게시판관리 오른쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardRight.do", method = RequestMethod.GET)
	public String boardRight() throws Exception {
		return "admin/ezBoard/boardRight";
	}
	
	/**
	 * 게시판관리 상단메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/get_Admin_TopBoardList.do", method = RequestMethod.POST)
	public String get_Admin_TopBoardList(HttpServletRequest request, HttpServletResponse response, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("get_Admin_TopBoardList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String parentBoardID = request.getParameter("boardType");
		String companyID = Optional.ofNullable(request.getParameter("company")).orElse(userInfo.getCompanyID());

		String rollInfo = userInfo.getRollInfo(); // 전체관리자 권한 확인용
		boolean isCompanyAdmin = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), rollInfo, "c");
		
		/* 2018-06-25 홍승비 - 게시판 > 관리자 > 좌측 게시판리스트(그룹) 표출 시 companyID 조건 추가 */
		List<BoardTreeVO> list = ezBoardAdminService.get_Admin_TopBoardList(parentBoardID, commonUtil.getLangData(userInfo.getLang()), companyID, userInfo.getTenantId(), isCompanyAdmin);
		
		for (int i = 0; i < list.size(); i++) {
			BoardTreeVO vo = list.get(i);
			String cleanValue = commonUtil.cleanValue(vo.getBoardName());
			vo.setBoardName(cleanValue);
		}
		
		model.addAttribute("topBoardList", list);

		logger.debug("get_Admin_TopBoardList ended");
		return "json";
	}

	/**
	 * 게시판관리 게시판그룹생성 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardGroupCreate.do", method = RequestMethod.GET)
	public String boardGroupCreate(Model model, @CookieValue("loginCookie") String loginCookie,	LoginVO userInfo) throws Exception {
		logger.debug("boardGroupCreate started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String lang = userInfo.getLang();
		String use_multiData = ezCommonService.getTenantConfig("Use_MultiData", userInfo.getTenantId());
		String lang_primary = ezCommonService.getTenantConfig("LangPrimary" + lang, userInfo.getTenantId());
		String lang_secondary = ezCommonService.getTenantConfig("LangSecondary" + lang, userInfo.getTenantId());
		String rollInfo = userInfo.getRollInfo();

		// 2023-11-27 조소정 - 관리자 > 게시판 > 그룹생성 > 일본어, 중국어 사용 여부에 따라 게시판 그룹이름 표출/미표출 구현
		String lang_tertiary = ezCommonService.getTenantConfig("LangTertiary" + lang, userInfo.getTenantId());
		String lang_quaternary = ezCommonService.getTenantConfig("LangQuaternary" + lang, userInfo.getTenantId());
		String useJapanese = ezCommonService.getTenantConfig("useJapanese", userInfo.getTenantId());
		String useChinese = ezCommonService.getTenantConfig("useChinese", userInfo.getTenantId());
		
		/* 2018-10-15 홍승비 - 관리자단 게시판그룹생성 진입 시 전체관리자 여부 확인 */
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), rollInfo, "c")) {
			model.addAttribute("isCompanyAdmin", true);
		}
		model.addAttribute("use_multiData", use_multiData);
		model.addAttribute("lang_primary", lang_primary);
		model.addAttribute("lang_secondary", lang_secondary);
		model.addAttribute("lang_tertiary", lang_tertiary);
		model.addAttribute("lang_quaternary", lang_quaternary);
		model.addAttribute("useJapanese", useJapanese);
		model.addAttribute("useChinese", useChinese);

		logger.debug("boardGroupCreate ended");
		return "admin/ezBoard/boardGroupCreate";
	}

	/**
	 * 게시판관리 게시판그룹생성 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/createBoardGroup.do", method = RequestMethod.POST)
	@ResponseBody
	public void createBoardGroup(@CookieValue("loginCookie") String loginCookie, HttpServletResponse response, BoardPropertyVO boardPropertyVO)	throws Exception {
		logger.debug("createBoardGroup started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String groupName1 = URLDecoder.decode(boardPropertyVO.getBoardGroupName(), "utf-8");
		String groupName2 = URLDecoder.decode(boardPropertyVO.getBoardGroupName2(), "utf-8");
		String groupName3 = URLDecoder.decode(boardPropertyVO.getBoardGroupName3(), "utf-8");
		String groupName4 = URLDecoder.decode(boardPropertyVO.getBoardGroupName4(), "utf-8");
		String accessName1 = user.getDeptName1() + "(" + user.getCompanyName1()	+ ", " + user.getDeptName1() + ")";
		String accessName2 = user.getDeptName2() + "(" + user.getCompanyName2()	+ ", " + user.getDeptName2() + ")";
		String uID = user.getId();
		String boardGroupId = boardPropertyVO.getBoardGroupID();
		String companyID = Optional.ofNullable(boardPropertyVO.getCompanyID()).orElse(user.getCompanyID());
		
		boardPropertyVO.setBoardGroupName(groupName1);
		boardPropertyVO.setBoardGroupName2(groupName2);
		boardPropertyVO.setBoardGroupName3(groupName3);
		boardPropertyVO.setBoardGroupName4(groupName4);
		boardPropertyVO.setAccessID(uID);
		boardPropertyVO.setAccessName(accessName1);
		boardPropertyVO.setAccessName2(accessName2);
		boardPropertyVO.setCompanyID(companyID);
		boardPropertyVO.setTenantID(user.getTenantId());
		boardPropertyVO.setLoginVO(user);
		boardPropertyVO.setBoardGroupID(commonUtil.stripScriptTags(boardGroupId));

		logger.debug("createBoardGroup ended");
		
		ezBoardAdminService.createBoardGroup(boardPropertyVO);
	}

	/**
	 * 게시판관리 하위게시판등록 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardCreate.do", method = RequestMethod.GET)
	public String boardCreate(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardCreate started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String lang = userInfo.getLang();
		String use_multiData = ezCommonService.getTenantConfig("Use_MultiData", userInfo.getTenantId());
		String lang_primary = ezCommonService.getTenantConfig("LangPrimary" + lang, userInfo.getTenantId());
		String lang_secondary = ezCommonService.getTenantConfig("LangSecondary" + lang, userInfo.getTenantId());
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String parentBoardName = "";
		
		// 2023-11-27 조소정 - 관리자 > 게시판 > 게시판등록 > 일본어, 중국어 사용 여부에 따라 게시판이름 표출/미표출 구현
		String lang_tertiary = ezCommonService.getTenantConfig("LangTertiary" + lang, userInfo.getTenantId());
		String lang_quaternary = ezCommonService.getTenantConfig("LangQuaternary" + lang, userInfo.getTenantId());
		String useJapanese = ezCommonService.getTenantConfig("useJapanese", userInfo.getTenantId());
		String useChinese = ezCommonService.getTenantConfig("useChinese", userInfo.getTenantId());

		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(parentBoardID, userInfo.getTenantId());
		
		switch (lang) {
			case "1":
				parentBoardName = boardPropertyVO.getBoardName();
				break;
			case "2":
				parentBoardName = boardPropertyVO.getBoardName2();
				break;
			case "3":
				parentBoardName = boardPropertyVO.getBoardName3();
				break;
			case "4":
				parentBoardName = boardPropertyVO.getBoardName4();
				break;
			default:
				parentBoardName = boardPropertyVO.getBoardName();
		}
		
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("parentBoardName", parentBoardName);
		model.addAttribute("use_multiData", use_multiData);
		model.addAttribute("lang_primary", lang_primary);
		model.addAttribute("lang_secondary", lang_secondary);
		model.addAttribute("lang_tertiary", lang_tertiary);
		model.addAttribute("lang_quaternary", lang_quaternary);
		model.addAttribute("useJapanese", useJapanese);
		model.addAttribute("useChinese", useChinese);

		logger.debug("boardCreate ended");
		return "admin/ezBoard/boardCreate";
	}

	/**
	 * 게시판관리 하위게시판등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/createBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public void createBoard(@CookieValue("loginCookie") String loginCookie,	HttpServletResponse response, BoardPropertyVO boardPropertyVO) throws Exception {
		logger.debug("createBoard started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String boardName1 = URLDecoder.decode(boardPropertyVO.getBoardName(), "utf-8");
		String boardName2 = URLDecoder.decode(boardPropertyVO.getBoardName2(), "utf-8");
		String boardName3 = URLDecoder.decode(boardPropertyVO.getBoardName3(), "utf-8");
		String boardName4 = URLDecoder.decode(boardPropertyVO.getBoardName4(), "utf-8");
		String boardGroupID = boardPropertyVO.getBoardGroupID();
		String accessName1 = user.getDeptName1() + "(" + user.getCompanyName1()	+ ", " + user.getDeptName1() + ")";
		String accessName2 = user.getDeptName2() + "(" + user.getCompanyName2()	+ ", " + user.getDeptName2() + ")";
		String uID = user.getId();
		
		BoardPropertyVO boardGroupPropertyVO = ezBoardService.getBoardProperty(boardGroupID, user.getTenantId());
		
		// 해당 게시판이 속하게 될 게시판그룹의 구분이 99라면, 그룹사게시판이다.
		if (boardGroupPropertyVO.getGuBun() != null && boardGroupPropertyVO.getGuBun().equals("99")) {
			boardPropertyVO.setIsAllGroupBoard("Y");
		} else {
			boardPropertyVO.setIsAllGroupBoard("");
		}
		
		boardPropertyVO.setBoardName(boardName1);
		boardPropertyVO.setBoardName2(boardName2);
		boardPropertyVO.setBoardName3(boardName3);
		boardPropertyVO.setBoardName4(boardName4);
		boardPropertyVO.setAccessID(uID);
		boardPropertyVO.setAccessName(accessName1);
		boardPropertyVO.setAccessName2(accessName2);
		boardPropertyVO.setCompanyID(boardGroupPropertyVO.getCompanyID());
		boardPropertyVO.setTenantID(user.getTenantId());
		
		ezBoardAdminService.createBoard(boardPropertyVO);

		logger.debug("createBoard ended");
	}

	/**
	 * 게시판관리 게시판순서조정 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardOrder.do", method = RequestMethod.GET)
	public String boardOrder(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardOrder started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String parentBoardID = request.getParameter("parentBoardID");
		String boardID = request.getParameter("boardID");
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());

		String multiBoardName = "";
		switch (userInfo.getLang()) {
			case "1":
				multiBoardName = boardPropertyVO.getBoardName();
				break;
			case "2":
				multiBoardName = boardPropertyVO.getBoardName2();
				break;
			case "3":
				multiBoardName = boardPropertyVO.getBoardName3();
				break;
			case "4":
				multiBoardName = boardPropertyVO.getBoardName4();
				break;
			default:
				multiBoardName = boardPropertyVO.getBoardName();
		}

		model.addAttribute("upperBoardID", parentBoardID);
		model.addAttribute("boardName", multiBoardName);

		logger.debug("boardOrder ended");
		return "admin/ezBoard/boardOrder";
	}

	/**
	 * 게시판관리 게시판순서조정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveBoardOrder.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveBoardOrder(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("saveBoardOrder started");

		userInfo = commonUtil.userInfo(loginCookie);		
		String pBoardIDList = request.getParameter("boardList");
		
		ezBoardAdminService.saveBoardOrder(pBoardIDList, userInfo.getTenantId());

		logger.debug("saveBoardOrder ended");
	}
	
	/**
	 * 게시판관리 게시판 서브트리 표출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getSubBoards.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getSubBoards(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getSubBoards started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		String upperBoardID = request.getParameter("upperBoardID");
		String isAdminLeft = "Y";
		boolean isCompanyAdmin = commonUtil.isAdmin(user.getId(), user.getTenantId(), user.getRollInfo(), "c");
		
		// 2023-11-28 조소정 - 게시판명 사용자 설정 언어로 표출하도록 수정
		String lang = commonUtil.getLangData(user.getLang());

		/* 2023-08-07 이주원 - 게시판명에 다국어 기본언어, 멀티언어 적용 
		String multiBoardName = "";
		if (commonUtil.getPrimaryData(user.getLang(), user.getTenantId()).equals("1")) {
			lang = "";
		} else {
			lang = "2";
		}
		*/
		
		// 자신의 회사에 속한 게시판만 표출하도록 compamyID 조건 추가
		String boardTree = ezBoardService.getBoardTree(upperBoardID, user.getId(), user.getDeptID(), user.getCompanyID(), 0, 1, 0, " ", lang, isAdminLeft, isCompanyAdmin, "", user.getRollInfo(), user.getTenantId());

		logger.debug("getSubBoards ended");
		return boardTree;
	}

	/**
	 * 게시판관리 그룹 및 게시판삭제 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardDelete.do", method = RequestMethod.GET)
	public String boardDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardDelete started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String isAdminLeft = "Y";
		boolean isCompanyAdmin = commonUtil.isAdmin(user.getId(), user.getTenantId(), user.getRollInfo(), "c");
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, user.getTenantId());
		
		String boardTree = ezBoardService.getBoardTree(boardID, user.getId(), user.getDeptID(), user.getCompanyID(), 0, 1, 0, " ", "", isAdminLeft, isCompanyAdmin, "", user.getRollInfo(), user.getTenantId());
		if (boardTree.trim().equals("<NODES></NODES>")) {
			model.addAttribute("hasSubBoard", 0);
		} else {
			model.addAttribute("hasSubBoard", 1);
		}
		
		if (boardPropertyVO == null) {
			logger.debug("boardDelete ended");
			return "admin/ezBoard/boardRight";
		} else {

			String boardName = "";
			switch (user.getLang()) {
				case "1":
					boardName = boardPropertyVO.getBoardName();
					break;
				case "2":
					boardName = boardPropertyVO.getBoardName2();
					break;
				case "3":
					boardName = boardPropertyVO.getBoardName3();
					break;
				case "4":
					boardName = boardPropertyVO.getBoardName4();
					break;
				default:
					boardName = boardPropertyVO.getBoardName();
			}
			
			model.addAttribute("boardID", boardID);
			model.addAttribute("boardGroupID", boardGroupID);
			model.addAttribute("boardName", boardName);
			
			logger.debug("boardDelete ended");
			return "admin/ezBoard/boardDelete";
		}
	}

	/**
	 * 게시판관리 그룹 및 게시판삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/deleteBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public void deleteBoard(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("deleteBoard started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		
		ezBoardAdminService.deleteBoard(boardID, userInfo.getTenantId());
		
		/* 2019-10-14 홍승비 - 게시판 삭제 시 회사의 공지사항 게시판 레코드도 함께 삭제 */
		String noticeBoardID = ezBoardService.getCompanyNoticeBoardID(userInfo.getCompanyID(), userInfo.getTenantId());
		if (boardID.equals(noticeBoardID)) { // 삭제할 게시판과 현재 회사의 공지사항 게시판 ID가 동일하다면 함께 삭제 
			ezBoardAdminService.deleteNoticeBoard(userInfo.getTenantId(), userInfo.getCompanyID());
		}
		
		/* 스크랩 게시물 삭제 */
		ezBoardAdminService.deleteScrapBoard(boardID);

		/* 스크랩함 게시물 삭제 */
		ezBoardAdminService.deleteScrapContBoard(boardID);
		
		logger.debug("deleteBoard ended");
	}

	/**
	 * 게시판관리 배경이미지 관리 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardBackGround.do", method = RequestMethod.GET)
	public String boardBackGround(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("boardBackGround started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		model.addAttribute("tenantID", userInfo.getTenantId());
		model.addAttribute("companyID",
				Optional.ofNullable(request.getParameter("companyID")).orElse(userInfo.getCompanyID()));

		logger.debug("boardBackGround ended");
		
		return "admin/ezBoard/boardBackGround";
	}

	/**
	 * 게시판관리 현재 배경이미지 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getBackGroundImage.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getBackGroundImage(HttpServletResponse response, BoardBackgroundVO boardBackgroundVO, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getBackGroundImage started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boardBackgroundVO.setCompanyID(Optional.ofNullable(boardBackgroundVO.getCompanyID()).orElse(userInfo.getCompanyID()));
		boardBackgroundVO.setTenantID(userInfo.getTenantId());

		/* 2018-06-26 홍승비 - companyID 조건 추가 */
		List<BoardBackgroundVO> list = ezBoardAdminService.getBackGroundImage(boardBackgroundVO);
		
		StringBuffer xmlStr = new StringBuffer();
		
		if (list.size() > 0) {
			xmlStr.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
			xmlStr.append("<DATA>");
			
			for (int i = 0; i < list.size(); i++) {
				xmlStr.append("<ROW>");
				xmlStr.append("<BACKGROUNDID>" + list.get(i).getBackgroundID() + "</BACKGROUNDID>");
				xmlStr.append("<ORGFILENAME>" + commonUtil.cleanValue(list.get(i).getOrgFileName()) + "</ORGFILENAME>");
				xmlStr.append("<SAVEFILENAME>" + commonUtil.cleanValue(list.get(i).getSaveFileName()) + "</SAVEFILENAME>");
				xmlStr.append("<REGUSERID>" + list.get(i).getRegUserID() + "</REGUSERID>");
				xmlStr.append("<REGDATE>" + commonUtil.getDateStringInUTC(list.get(i).getRegDate(), userInfo.getOffset(), false) + "</REGDATE>");
				xmlStr.append("<ISUSE>" + list.get(i).getIsUse() + "</ISUSE>");
				xmlStr.append("<SN>" + list.get(i).getSn() + "</SN>");
				xmlStr.append("<WIDTH>" + list.get(i).getWidth() + "</WIDTH>");
				xmlStr.append("<HEIGHT>" + list.get(i).getHeight() + "</HEIGHT>");
				xmlStr.append("</ROW>");
			}
			
			xmlStr.append("</DATA>");
		}

		logger.debug("getBackGroundImage ended");
		return xmlStr.toString();
	}

	/**
	 * 게시판관리 배경이미지 상태값 변경 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/statusChangeBackGroundImage.do", method = RequestMethod.POST)
	@ResponseBody
	public void statusChangeBackGroundImage(HttpServletRequest request,	HttpServletResponse response, BoardBackgroundVO boardBackgroundVO, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("statusChangeBackGroundImage started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = request.getParameter("mode");
		
		boardBackgroundVO.setTenantID(userInfo.getTenantId());
		boardBackgroundVO.setType(mode);
		
		if (mode.equals("U")) {
			ezBoardAdminService.statusChangeBackGroundImage(boardBackgroundVO);
		} else {
			String[] bIDs = boardBackgroundVO.getBackgroundID().split("/");
			String[] isUses = boardBackgroundVO.getIsUse().split("/");
			
			for (int i = 0; i < bIDs.length; i++) {
				boardBackgroundVO.setBackgroundID(bIDs[i]);
				boardBackgroundVO.setIsUse(isUses[i]);
				
				ezBoardAdminService.statusChangeBackGroundImage(boardBackgroundVO);
			}
		}

		logger.debug("statusChangeBackGroundImage ended");
	}

	/**
	 * 게시판관리 선택한 배경이미지 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/selectBackGroundImage.do", method = RequestMethod.GET)
	public String selectBackGroundImage(BoardBackgroundVO boardBackgroundVO, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("selectBackGroundImage started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String type = boardBackgroundVO.getType() != null ? boardBackgroundVO.getType() : "NEW";
		
		boardBackgroundVO.setTenantID(userInfo.getTenantId());
		boardBackgroundVO.setCompanyID(userInfo.getCompanyID());
		
		if (type.equals("UPT")) {
			List<BoardBackgroundVO> list = ezBoardAdminService.getBackGroundImage(boardBackgroundVO);
			
			if (list.size() > 0) {
				String filePath = commonUtil.getUploadPath("upload_board.BOARDBACKGROUND", userInfo.getTenantId());
				String fileName = ((BoardBackgroundVO) list.get(0)).getSaveFileName() != null ? ((BoardBackgroundVO) list.get(0)).getSaveFileName() : "";
				
				model.addAttribute("width", boardBackgroundVO.getWidth() != null ? boardBackgroundVO.getWidth() : 100);
				model.addAttribute("height", boardBackgroundVO.getHeight() != null ? boardBackgroundVO.getHeight() : 100);
				model.addAttribute("backgroundID", boardBackgroundVO.getBackgroundID() != null ? boardBackgroundVO.getBackgroundID() : "");
				model.addAttribute("filePath", filePath);
				model.addAttribute("fileName", fileName);
			} else {
				model.addAttribute("fileName", "");
			}
		} else {
			model.addAttribute("fileName", "");
		}
		
		model.addAttribute("type", type);

		logger.debug("selectBackGroundImage ended");
		return "admin/ezBoard/selectBackGroundImage";
	}

	/**
	 * 게시판관리 배경이미지 파일 업로드 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/uploadBackGroundImage.do", method = RequestMethod.POST)
	@ResponseBody
	public void uploadBackGroundImage(MultipartHttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("uploadBackGroundImage started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		MultipartFile file = request.getFile("file1");
		
		String fileType = file.getContentType().split("/")[1];
		String fileName = request.getParameter("guid") + "." + fileType;
		String filePath = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String realFullPath = realPath + filePath + commonUtil.separator + "S_" + fileName;
		
		int width = 0;
		int height = 0;
		
		writeUploadedFile(file, "S_" + fileName, realPath + filePath);
		
		try {
			File imageFile = new File(commonUtil.detectPathTraversal(realFullPath));
			
			if (imageFile.exists()) {
				BufferedImage bi = ImageIO.read(new File(commonUtil.detectPathTraversal(realFullPath)));
				width = bi.getWidth();
				height = bi.getHeight();
				
				response.getWriter().write(commonUtil.stripScriptTags(filePath + "," + fileName + "," + width + "/" + height));
			}
		} catch (Exception e) {
			logger.debug("uploadBackGroundImage error");
		}

		logger.debug("uploadBackGroundImage ended");
	}

	/**
	 * 게시판관리 배경이미지 정보 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveBackGroundImage.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveBackGroundImage(@CookieValue("loginCookie") String loginCookie,	HttpServletResponse response, MultipartHttpServletRequest request, BoardBackgroundVO boardBackgroundVO) throws Exception {
		logger.debug("saveBackGroundImage started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		
		boardBackgroundVO.setRegUserID(user.getId());
		boardBackgroundVO.setCompanyID(user.getCompanyID());
		boardBackgroundVO.setTenantID(user.getTenantId());
		
		MultipartFile file = request.getFile("file1");
		
		if (file != null) {
			String fileName = boardBackgroundVO.getSaveFileName();
			String filePath = commonUtil.getUploadPath("upload_board.BOARDBACKGROUND", user.getTenantId());
			String tempFilePath = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", user.getTenantId());
			String realPath = commonUtil.getRealPath(request);
			
			writeUploadedFile(file, "S_" + fileName, realPath + filePath);
			
			try {
				File tempFile = new File(realPath + tempFilePath + commonUtil.separator + "S_" + commonUtil.detectPathTraversal(fileName));
				
				if (tempFile.exists()) {
					tempFile.delete();
				}
				
				boardBackgroundVO.setOrgFileName(file.getOriginalFilename());
				boardBackgroundVO.setSaveFileName(fileName);
				boardBackgroundVO.setWidth(request.getParameter("pWidth"));
				boardBackgroundVO.setHeight(request.getParameter("pHeight"));
				boardBackgroundVO.setBackgroundID(request.getParameter("pBackgroundID"));
			} catch (Exception e) {
				logger.error("EzBoardAdmin :: saveBackGroungImage");
			}
		}
		
		/* 2018-06-26 홍승비 - 배경이미지 저장 시  companyID 삽입 */
		ezBoardAdminService.saveBackGroundImage(boardBackgroundVO);

		logger.debug("saveBackGroundImage ended");
	}

	/**
	 * 게시판관리 배경이미지 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/deleteBackGroundImage.do", method = RequestMethod.POST)
	@ResponseBody
	public void deleteBackGroundImage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, BoardBackgroundVO boardBackgroundVO) throws Exception {
		logger.debug("deleteBackGroundImage started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String fileName = boardBackgroundVO.getSaveFileName();
		String filePath = commonUtil.getUploadPath("upload_board.BOARDBACKGROUND", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		
		boardBackgroundVO.setTenantID(userInfo.getTenantId());
		
		try {
			File tempFile = new File(realPath + filePath + commonUtil.separator +"S_" + commonUtil.detectPathTraversal(fileName));
			
			if (tempFile != null) {
				tempFile.delete();
			}
			
			ezBoardAdminService.deleteBackGroundImage(boardBackgroundVO);
			
		} catch (Exception e) {
			logger.error("EzBoardAdmin :: deleteBackGroundImage");
		}

		logger.debug("deleteBackGroundImage ended");
	}

	/**
	 * 게시판관리 게시판이동 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardMove.do", method = RequestMethod.GET)
	public String boardMove(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardMove started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String hasSubBoard = "";
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		if (boardID.equals(boardGroupID)) {
			hasSubBoard = "1";
		} else {
			hasSubBoard = "0";
		}
		
		// 2023-08-22 황인경 - 관리자 > 게시판 > 게시판 이동 > 게시판명 다국어 처리
		if (!userInfo.getLang().equals("1")) {
			boardPropertyVO.setBoardName(boardPropertyVO.getBoardName2());
		}

		String boardName = "";
		switch (userInfo.getLang()) {
			case "1":
				boardName = boardPropertyVO.getBoardName();
				break;
			case "2":
				boardName = boardPropertyVO.getBoardName2();
				break;
			case "3":
				boardName = boardPropertyVO.getBoardName3();
				break;
			case "4":
				boardName = boardPropertyVO.getBoardName4();
				break;
			default:
				boardName = boardPropertyVO.getBoardName();
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("boardName", boardName);
		model.addAttribute("hasSubBoard", hasSubBoard);

		logger.debug("boardMove ended");
		return "admin/ezBoard/boardMove";
	}

	/**
	 * 게시판관리 이동할 게시판 선택화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardMoveSelect.do", method = RequestMethod.GET)
	public String boardMoveSelect(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("boardMoveSelect started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String serverName = userInfo.getServerName();
		
		model.addAttribute("serverName", serverName);

		logger.debug("boardMoveSelect ended");
		return "admin/ezBoard/boardMoveSelect";
	}

	/**
	 * 게시판관리 게시판 이동 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/moveBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public void moveBoard(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("moveBoard started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String orgBoardID = request.getParameter("orgBoardID");
		String newParentBoardID = request.getParameter("newParentBoardID");
		String newBoardGroupID = request.getParameter("newBoardGroupID");
		String isAllGroupBoardORG = "";
		String isAllGroupBoardNEW = "";
		
		/* 2018-10-18 홍승비 - 그룹사게시판과 일반 게시판(그룹)과는 서로 게시판 이동 불가능함 */
		BoardPropertyVO orgBoardProp = ezBoardService.getBoardProperty(orgBoardID, userInfo.getTenantId());
		
		if (orgBoardProp.getBoardGroupID() != null) {
			String orgBoardGroupID = orgBoardProp.getBoardGroupID();
			BoardPropertyVO orgBoardGroupProp = ezBoardService.getBoardProperty(orgBoardGroupID, userInfo.getTenantId());
			
			if (orgBoardGroupProp.getGuBun() != null && orgBoardGroupProp.getGuBun().equals("99")) {
				isAllGroupBoardORG = "Y";
			}
		}
		
		BoardPropertyVO newBoardGroupProp = ezBoardService.getBoardProperty(newBoardGroupID, userInfo.getTenantId());
		
		// 하위게시판 아래로 이동하는 경우
		if (StringUtils.isNoneBlank(newBoardGroupProp.getBoardGroupID())) {
			newBoardGroupID = newBoardGroupProp.getBoardGroupID();
			BoardPropertyVO newBoardGroupProp2 = ezBoardService.getBoardProperty(newBoardGroupID, userInfo.getTenantId());
			
			if (newBoardGroupProp2.getGuBun() != null && newBoardGroupProp2.getGuBun().equals("99")) {
				isAllGroupBoardNEW = "Y";
			}
		} // 게시판그룹의 바로 아래로 이동하는 경우
		else {
			if (newBoardGroupProp.getGuBun() != null && newBoardGroupProp.getGuBun().equals("99")) {
				isAllGroupBoardNEW = "Y";
			}
		}
		
		/* 2019-11-08 홍승비 - 상위게시판을 자신의 하위게시판 아래로 이동하지 못하도록 수정 */
		boolean canMove = true;
		BoardPropertyVO newParentBoardProperty = ezBoardService.getBoardProperty(newParentBoardID, userInfo.getTenantId());
		if (newParentBoardProperty != null && newParentBoardProperty.getBoardTreePath() != null && newParentBoardProperty.getBoardTreePath().indexOf(orgBoardID) > -1) {
			canMove = false; // 이동할 목표 게시판의 boardtreepath에 이동할 대상이 되는 게시판ID가 포함된다면, 상위게시판을 자신의 하위로 이동시키는 것임
		}
		
		if (isAllGroupBoardORG.equals(isAllGroupBoardNEW)) {
			if (canMove == true) {
				ezBoardAdminService.moveBoard(orgBoardID, newParentBoardID,	newBoardGroupID, userInfo.getTenantId());
				
				/* 2019-11-08 홍승비 - 게시판 이동 시 BOARDTREEPATH 업데이트되지 않는 오류 수정 */
				List<BoardPropertyVO> allSubBoardProperty = ezBoardService.getAllSubBoardProperty(orgBoardID, userInfo.getTenantId());
				
				int subBoardSize = allSubBoardProperty.size();
				for (int i = 0; i < subBoardSize; i++) {
					String subBoardID = allSubBoardProperty.get(i).getBoardID();
					String subNewBoardTreePath= ezBoardService.getNewBoardTreePath(subBoardID, userInfo.getTenantId());
					ezBoardAdminService.updateBoardTreePath(subBoardID, subNewBoardTreePath, userInfo.getTenantId());
					/* 2020-01-16 홍승비 - 하위게시판을 가지는 상위게시판을 이동하는 경우, 하위게시판들의 BoardGroupID가 갱신되지 않는 오류 수정 */
					ezBoardAdminService.updateBoardGroupID(subBoardID, newBoardGroupID, userInfo.getTenantId());
				}
			} else {
				response.sendError(600);
			}
		}
		else {
			response.sendError(601); // 그룹사게시판과 일반게시판 간의 이동 예외처리 수정
		}

		logger.debug("moveBoard ended");
	}

	/**
	 * 게시판관리 게시판그룹이름변경 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardProperty.do", method = RequestMethod.GET)
	public String boardProperty(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request,	HttpServletResponse response, Model model) throws Exception {
		logger.debug("boardProperty started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String lang = userInfo.getLang();
		String use_multiData = ezCommonService.getTenantConfig("Use_MultiData", userInfo.getTenantId());
		String lang_primary = ezCommonService.getTenantConfig("LangPrimary" + lang, userInfo.getTenantId());
		String lang_secondary = ezCommonService.getTenantConfig("LangSecondary" + lang, userInfo.getTenantId());
		String use_portal = ezCommonService.getTenantConfig("Use_Portal", userInfo.getTenantId());
		String boardID = request.getParameter("boardID");
		String adminType = request.getParameter("adminType");
		String style = "";
		String style2 = "";
		String isAllGroupBoard = "";

		// 2023-11-27 조소정 - 관리자 > 게시판 > 그룹 선택 후 일반설정 > 일본어, 중국어 사용 여부에 따라 게시판 그룹이름 표출/미표출 구현
		String lang_tertiary = ezCommonService.getTenantConfig("LangTertiary" + lang, userInfo.getTenantId());
		String lang_quaternary = ezCommonService.getTenantConfig("LangQuaternary" + lang, userInfo.getTenantId());
		String useJapanese = ezCommonService.getTenantConfig("useJapanese", userInfo.getTenantId());
		String useChinese = ezCommonService.getTenantConfig("useChinese", userInfo.getTenantId());

		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		if (boardPropertyVO.getBoardName2() == null	|| boardPropertyVO.getBoardName2().equals("")) {
			boardPropertyVO.setBoardName2(boardPropertyVO.getBoardName());
		}

		if (boardPropertyVO.getBoardName3() == null	|| boardPropertyVO.getBoardName3().equals("")) {
			boardPropertyVO.setBoardName3(boardPropertyVO.getBoardName());
		}

		if (boardPropertyVO.getBoardName4() == null	|| boardPropertyVO.getBoardName4().equals("")) {
			boardPropertyVO.setBoardName4(boardPropertyVO.getBoardName());
		}

		if (boardPropertyVO.getDeleteAfter() == null || boardPropertyVO.getDeleteAfter().equals("")) {
			boardPropertyVO.setDeleteAfter("-1");
		}
		
		if (boardPropertyVO.getBoardColor() == null	|| boardPropertyVO.getBoardColor().equals("")) {
			boardPropertyVO.setBoardColor("#000000");
		}
		
		if (boardPropertyVO.getParentBoardID().equals("top")) {
			style = "display:none";			
		}
		
		/* 2018-07-12 홍승비 - 모든 URL게시판은 임시 구분값(실제로는 0, 임시로 6)을 가지도록 수정 */
		if (boardPropertyVO.getUrl() != null && !(boardPropertyVO.getUrl().trim().equals(""))) {
			boardPropertyVO.setGuBun("6");
		}
		
		/* 2019-03-21 홍승비 - 게시판이 속한 그룹게시판이 구분값 99인지 확인하여 isAllGroupBoard값 셋팅 */
		String boardGroupID = boardPropertyVO.getBoardGroupID();
		if (boardGroupID != null) { // 부모가 top인 게시판들(그룹)은 그룹아이디가 없다.
			BoardPropertyVO strGroupProp = ezBoardService.getBoardProperty(boardGroupID, userInfo.getTenantId());
			if (strGroupProp.getGuBun() != null && strGroupProp.getGuBun().equals("99")) {
				isAllGroupBoard = "Y";
			} else {
				isAllGroupBoard = "N";
			}
		}
		/* 2018-11-22 홍승비 - 게시판그룹에서 그룹사게시판 여부 표출 추가 */
		else if (boardPropertyVO.getGuBun() != null && boardPropertyVO.getGuBun().equals("99")) {
			isAllGroupBoard = "Y";
		}
		
		if (!boardPropertyVO.getParentBoardID().equals("top")) {
			style2 = "display:none";			
		}
		
		/* 2019-10-11 홍승비 - 공지사항 게시판 여부 파라미터 추가 */
		String noticeBoardID = ezBoardService.getCompanyNoticeBoardID(userInfo.getCompanyID(), userInfo.getTenantId());
		
		/* 2020-12-04 박기범 - 탭게시판 여부 파라미터 추가 */
		List<HashMap<String, Object>> tabBoardIDList = ezBoardService.getCompanyTabBoardIDList(userInfo.getCompanyID(), userInfo.getTenantId());
		if (tabBoardIDList != null) {
			for (HashMap<String, Object> hashMap : tabBoardIDList) {
				String tabID = hashMap.get("TABID").toString();
				model.addAttribute("tabBoardID" + tabID, hashMap.get("BOARDID").toString());
			}
		}
		
		/* 2024-09-10 조소정 - 게시판 > 카테고리 기능 추가 */
		int boardItemCnt = ezBoardAdminService.getBoardItemCnt(boardID, userInfo.getTenantId());
		
		/* 2018-07-26 홍승비 - 다국어 표출 시 lang 대신 primary 조건 사용하도록 수정 */
		model.addAttribute("model", boardPropertyVO);
		model.addAttribute("use_multiData", use_multiData);
		model.addAttribute("primary", userInfo.getPrimary());
		model.addAttribute("lang_primary", lang_primary);
		model.addAttribute("lang_secondary", lang_secondary);
		model.addAttribute("use_portal", use_portal);
		model.addAttribute("style", style);
		model.addAttribute("style2", style2);
		model.addAttribute("adminType", adminType);
		model.addAttribute("isAllGroupBoard", isAllGroupBoard);
		model.addAttribute("noticeBoardID", noticeBoardID);
		model.addAttribute("lang_tertiary", lang_tertiary);
		model.addAttribute("lang_quaternary", lang_quaternary);
		model.addAttribute("useJapanese", useJapanese);
		model.addAttribute("useChinese", useChinese);
		model.addAttribute("boardItemCnt", boardItemCnt);
		
		logger.debug("boardProperty ended");
		return "admin/ezBoard/boardProperty";
	}

	/**
	 * 게시판관리 게시판그룹이름변경 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveBoardProperty.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveBoardProperty(@CookieValue("loginCookie") String loginCookie, HttpServletResponse response,	HttpServletRequest request, BoardPropertyVO boardPropertyVO) throws Exception {
		logger.debug("saveBoardProperty started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		/* 2019-10-11 홍승비 - 공지사항 게시판 설정 기능 추가 */
		String noticeBoardMod = request.getParameter("noticeBoardMod");
		
		boardPropertyVO.setTenantID(userInfo.getTenantId());
		
		BoardPropertyVO beforeBoardProperty = ezBoardService.getBoardProperty(boardPropertyVO.getBoardID(), userInfo.getTenantId()); // 게시판 이름 변경 전 정보
		
		 BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
		 myFavoriteVO.setUserId(userInfo.getId());
	     myFavoriteVO.setBoardId(boardPropertyVO.getBoardID());
	     myFavoriteVO.setType("4");
	     myFavoriteVO.setTenantID(userInfo.getTenantId());
		 
		int boardItemCount = ezBoardService.getBrdTotalItemCount(myFavoriteVO);
		
		// url 게시판과 
		if (boardItemCount > 0 && (!beforeBoardProperty.getGuBun().equals(boardPropertyVO.getGuBun()) || !beforeBoardProperty.getUrl().equals(boardPropertyVO.getUrl()))) {
			return "nonEmptyBoard";
		}
		
		ezBoardAdminService.saveBoardProperty(boardPropertyVO);
		
		if (!noticeBoardMod.equals("")) { // 공지사항 게시판 설정이 변경되었다면 추가 동작 진행
			if (noticeBoardMod.equals("UPDATE")) {
				ezBoardAdminService.updateNoticeBoard(boardPropertyVO.getBoardID(), userInfo.getTenantId(), userInfo.getCompanyID());
			} else { // DELETE
				ezBoardAdminService.deleteNoticeBoard(userInfo.getTenantId(), userInfo.getCompanyID());
			}
		}
		
		/* 2020-12-04 박기범 - 탭 게시판 설정 기능 추가*/
		BoardPropertyVO boardpro = ezBoardService.getBoardProperty(boardPropertyVO.getBoardID(), userInfo.getTenantId());
		int tabNum = 3; //탭 개수
		
		/* 2023-11-08 민지수 - 카테고리게시판으로 게시판 유형을 변경한 경우, 즐겨찾기와 마이게시판 목록에서 해당 게시판 제거 */
		if (boardpro.getGuBun() != null && boardpro.getGuBun().equals("10")) {
			ezBoardAdminService.deleteMyBoardData("MyBoards", boardPropertyVO.getBoardID(), userInfo.getTenantId());
			ezBoardAdminService.deleteMyBoardData("MyBoardTree", boardPropertyVO.getBoardID(), userInfo.getTenantId());
		}
		
		for (int i = 1; i <= tabNum; i++) {
			String tabBoardMod = request.getParameter("tabBoardMod" + i);
			String tabBoardCheck = request.getParameter("tabBoardCheck" + i);
			String tempCompanyId = boardpro.getCompanyID() != null ? boardpro.getCompanyID() : " " ;
			
			if (!tabBoardMod.equals("")) {
				if(tabBoardMod.equals("UPDATE")) {
					ezBoardAdminService.updateTabBoard(i, boardPropertyVO.getBoardID(), userInfo.getTenantId(), tempCompanyId, boardPropertyVO.getBoardName(), boardPropertyVO.getBoardName2());
				} else { // DELETE
					ezBoardAdminService.deleteTabBoard(i, boardpro.getTenantID(), tempCompanyId);
				}
			} else {
				if (tabBoardCheck.equals("true")) { 
					if (!beforeBoardProperty.getBoardName().equals(boardpro.getBoardName()) || !beforeBoardProperty.getBoardName2().equals(boardpro.getBoardName2())) { // 게시판 이름 수정했을 경우
						ezBoardAdminService.updateTabBoard(i, boardPropertyVO.getBoardID(), userInfo.getTenantId(), tempCompanyId, boardPropertyVO.getBoardName(), boardPropertyVO.getBoardName2());
					}
				}
			}
			
		}
		
		logger.debug("saveBoardProperty ended");
		return "success";
	}
	
	/**
	 * 게시판관리 게시판그룹이름변경 메뉴 확장컬럼 설정화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardExtensionAttribute.do", method = RequestMethod.GET)
	public String boardExtensionAttribute(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardExtensionAttribute started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		/* 2020-02-14 홍승비 - 항목명 다국어 처리를 위한 파라미터 추가 */
		String lang_primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String lang_secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());

		model.addAttribute("lang_user", userInfo.getLang());
		model.addAttribute("lang_primary", lang_primary);
		model.addAttribute("lang_secondary", lang_secondary);
		
		logger.debug("boardExtensionAttribute ended");
		return "admin/ezBoard/boardExtensionAttribute";
	}

	/**
	 * 게시판관리 게시판그룹이름변경 메뉴 확장컬럼 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getAttribute.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getAttribute(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, BoardAttributeVO boardAttributeVO) throws Exception {
		logger.debug("getAttribute started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		List<BoardAttributeVO> list = ezBoardAdminService.getBoardAttribute(boardAttributeVO.getBoardID(), userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();
		sb.append("<ROWS>");
		
		// 확장컬럼 저장 시 이미 MakeXMLString()을 사용하여 XML에 대응하도록 파싱한 COLNAME과 VALUE를 저장하므로, 가져올 때 cleanValue 처리가 필요하지 않음
		if (list != null) {
			for (int i = 0; i < list.size(); i++) {
				BoardAttributeVO obj = list.get(i);
				sb.append("<ROW>");
				sb.append("<CELL><VALUE>" + obj.getColName1() + "</VALUE><DATA1>" + obj.getTableCol() + "</DATA1></CELL>");
				sb.append("<CELL><VALUE>" + obj.getColName2() + "</VALUE></CELL>");
				sb.append("<CELL><VALUE>" + obj.getMust() + "</VALUE></CELL>");
				sb.append("<CELL><VALUE>" + obj.getColType() + "</VALUE></CELL>");
				sb.append("<CELL><VALUE>" + commonUtil.makeListField(obj.getValue()) + "</VALUE></CELL>");
				sb.append("</ROW>");
			}
		}
		
		sb.append("</ROWS>");

		logger.debug("getAttribute ended");
		return sb.toString();
	}

	/**
	 * 게시판관리 게시판그룹이름변경 메뉴 확장컬럼 헤더 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getBoardHeader.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getBoardHeader(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, BoardAttributeVO boardAttributeVO) throws Exception {
		logger.debug("getBoardHeader started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<BoardAttributeVO> list = ezBoardAdminService.getBoardHeader(boardAttributeVO.getColType(), boardAttributeVO.getBoardID(), userInfo.getTenantId());

		StringBuilder sb = new StringBuilder();
		sb.append("<ROWS>");
		
		if (list != null) {
			for (int i = 1; i < list.size(); i++) {
				BoardAttributeVO obj = list.get(i);
				sb.append("<ROW>");
				
				// 확장컬럼 리스트헤더 저장 시 이미 MakeXMLString()을 사용하여 XML에 대응하도록 파싱한 COLNAME과 VALUE를 저장하므로, 가져올 때 cleanValue 처리가 필요하지 않음
				if (userInfo.getLang().equals("1")) {
					sb.append("<CELL><VALUE>" + obj.getColName1() + "</VALUE><DATA1>" + obj.getSn() + "</DATA1></CELL>");
				} else if (userInfo.getLang().equals("2")) {
					sb.append("<CELL><VALUE>" + obj.getColName2() + "</VALUE><DATA1>" + obj.getSn() + "</DATA1></CELL>");
				} else if (userInfo.getLang().equals("3")) {
					sb.append("<CELL><VALUE>" + obj.getColName3() + "</VALUE><DATA1>" + obj.getSn() + "</DATA1></CELL>");
				} else if (userInfo.getLang().equals("4")) {
					sb.append("<CELL><VALUE>" + obj.getColName4() + "</VALUE><DATA1>" + obj.getSn() + "</DATA1></CELL>");
				}

				sb.append("<CELL><VALUE>" + obj.getColName2() + "</VALUE></CELL>");
				sb.append("<CELL><VALUE>" + obj.getValue() + "</VALUE></CELL>");
				sb.append("</ROW>");
			}
		}
		
		sb.append("</ROWS>");

		logger.debug("getBoardHeader ended");
		return sb.toString();
	}

	/**
	 * 게시판관리 게시판그룹이름변경 메뉴 확장컬럼 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveAttribute.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveAttribute(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, BoardAttributeVO boardAttributeVO) throws Exception {
		logger.debug("saveAttribute started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		String rtnValue = ezBoardAdminService.saveAttribute(doc, userInfo, boardAttributeVO);

		logger.debug("saveAttribute ended");

		return rtnValue;
	}

	/**
	 * 게시판관리 게시판그룹이름변경 메뉴의 확장컬럼헤더 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveHeader.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveHeader(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response, BoardListHeaderVO boardListHeaderVO) throws Exception {
		logger.debug("saveHeader started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		String rtnValue = ezBoardAdminService.saveHeader(doc, userInfo, boardListHeaderVO);

		logger.debug("saveHeader ended");

		return rtnValue;
	}

	/**
	 * 게시판관리 게시판 권한설정 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardACL.do", method = RequestMethod.GET)
	public String boardACL(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("boardACL started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String adminType = request.getParameter("adminType");
		String pBoardName = request.getParameter("boardName");
		String pType = request.getParameter("boardType");
		String pParentNeed = request.getParameter("parentNeed");
		String pAccessLevel = request.getParameter("accessLevel");
		String primary = userInfo.getPrimary(); // 사용하지 않는 userLang 변수 제거, primary로 대체
		String isAllGroupBoard = "";
		// 2025-02-10 조수빈 - voc #154032 처리를 위해 전체, 게시, 회사 관리자인 경우에만 권한전파 및 권한복사 버튼 표출하기 위한 변수
		String isBoardAdmin = "NO";
		
		BoardPropertyVO boardProperty = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());

		/* 2018-10-17 홍승비 - 그룹사게시판이라면 권한설정 버튼을 숨긴다. */
		String boardGroupID = boardProperty.getBoardGroupID();
		// 하위게시판인 경우
		if (!boardProperty.getParentBoardID().equals("top") && boardGroupID != null) {
			BoardPropertyVO strGroupProp = ezBoardService.getBoardProperty(boardGroupID, userInfo.getTenantId());
			if (strGroupProp.getGuBun() != null && strGroupProp.getGuBun().equals("99")) {
				isAllGroupBoard = "Y";
			}
		}
		// 게시판 그룹인 경우
		else if (boardProperty.getParentBoardID().equals("top")) {
			if (boardProperty.getGuBun() != null && boardProperty.getGuBun().equals("99")) {
				isAllGroupBoard = "Y";
			}
		}

		// 2023-12-04 조소정 - 사용자 설정 언어로 게시판명 표출되도록 수정
		String userLang = userInfo.getLang();
		String boardName = "";
		
		switch (userLang) {
	    case "1":
	        boardName = boardProperty.getBoardName();
	        break;
	    case "2":
	        boardName = boardProperty.getBoardName2();
	        break;
	    case "3":
	        boardName = boardProperty.getBoardName3();
	        break;
	    case "4":
	        boardName = boardProperty.getBoardName4();
	        break;
	    default:
	    	boardName = boardProperty.getBoardName();
		}

		/* 게시판 권한설정 시 companyID 조건 추가, 겸직한 사원의 경우 해당 겸직정보를 표출함 + 다국어 대응하도록 정보 가져옴 */
		List<BoardPropertyVO> list = ezBoardAdminService.getBoardAccessList(boardID, isAllGroupBoard, userInfo.getCompanyID(), userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		if (list != null) {
			for (int i = 0; i < list.size(); i++) {
				BoardPropertyVO obj = list.get(i);
				sb.append("<ROW>");
				sb.append("<COMPANY><![CDATA[" + obj.getLoginVO().getCompanyName1() + "]]></COMPANY>");
				sb.append("<DESCRIPTION><![CDATA[" + obj.getLoginVO().getDeptName1() + "]]></DESCRIPTION>");
				sb.append("<DISPLAYNAME><![CDATA[" + obj.getLoginVO().getDisplayName1() + "]]></DISPLAYNAME>");
				sb.append("<TITLE><![CDATA[" + obj.getLoginVO().getTitle1() + "]]></TITLE>");
				sb.append("<COMPANY2><![CDATA[" + obj.getLoginVO().getCompanyName2() + "]]></COMPANY2>");
				sb.append("<DESCRIPTION2><![CDATA[" + obj.getLoginVO().getDeptName2() + "]]></DESCRIPTION2>");
				sb.append("<DISPLAYNAME2><![CDATA[" + obj.getLoginVO().getDisplayName2()	+ "]]></DISPLAYNAME2>");
				sb.append("<TITLE2><![CDATA[" + obj.getLoginVO().getTitle2()	+ "]]></TITLE2>");
				sb.append("<ACCESSID>" + obj.getAccessID() + "</ACCESSID>");
				sb.append("<ACCESSNAME><![CDATA[" + obj.getAccessName() + "]]></ACCESSNAME>");
				sb.append("<ACCESSNAME2><![CDATA[" + obj.getAccessName2() + "]]></ACCESSNAME2>");
				sb.append("<BOARDGROUPACL>" + obj.getBoardGroupACL() + "</BOARDGROUPACL>");
				sb.append("<DISPLAYNAME><![CDATA[" + obj.getDisplayName() + "]]></DISPLAYNAME>");
				sb.append("<BOARDADMIN_FG>" + obj.getBoardAdmin_FG() + "</BOARDADMIN_FG>");
				sb.append("<ACCESS_>" + obj.getAccess_() + "</ACCESS_>");
				sb.append("<LISTVIEW_FG>" + obj.getListView_FG() + "</LISTVIEW_FG>");
				sb.append("<READ_FG>" + obj.getRead_FG() + "</READ_FG>");
				sb.append("<WRITE_FG>" + obj.getWrite_FG() + "</WRITE_FG>");
				sb.append("<REPLY_FG>" + obj.getReply_FG() + "</REPLY_FG>");
				sb.append("<DELETE_FG>" + obj.getDelete_FG() + "</DELETE_FG>");
				sb.append("<POSTNOTICE>" + obj.getPostNotice() + "</POSTNOTICE>");
				/* 2019-09-19 게시판 권한의 TYPE값 추가 */
				sb.append("<TYPE><![CDATA[" + obj.getType() + "]]></TYPE>");
				sb.append("</ROW>");
			}
		}
		
		sb.append("</DATA>");
		
		String result = sb.toString().replace("null", "");
		
		String rollInfo = userInfo.getRollInfo();
		// 전체관리자
		boolean isAllAdmin = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), rollInfo, "c");
		// 게시관리자
		boolean isCompanyAdmin = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), rollInfo, "n");
		// 회사관리자
		boolean isPostAdmin = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), rollInfo, "k");
		
		if (isAllAdmin || isCompanyAdmin || isPostAdmin) {
			isBoardAdmin = "YES";
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("primary", primary);
		model.addAttribute("pBoardName", pBoardName);
		model.addAttribute("pType", pType);
		model.addAttribute("pParentNeed", pParentNeed);
		model.addAttribute("adminType", adminType);
		model.addAttribute("pAccessLevel", pAccessLevel);
		model.addAttribute("boardName", boardName);
		model.addAttribute("strList", result);
		model.addAttribute("isAllGroupBoard", isAllGroupBoard);
		model.addAttribute("isBoardAdmin", isBoardAdmin);

		logger.debug("boardACL ended");
		return "admin/ezBoard/boardACL";
	}

	/**
	 * 게시판관리 게시판 권한 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getACL.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getACL(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getACL started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String accessID = request.getParameter("accessID");
		
		BoardPropertyVO boardProperty = ezBoardAdminService.getACL(boardID, accessID, userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();
		sb.append("<NODES>");
		
		if (boardProperty != null) {
			sb.append("<NODE>");
			sb.append("<ACCESS>" + boardProperty.getAccess_() + "</ACCESS>");
			sb.append("<BOARDADMIN>" + boardProperty.getBoardAdmin_FG()	+ "</BOARDADMIN>");
			sb.append("<LIST>" + boardProperty.getListView_FG() + "</LIST>");
			sb.append("<READ>" + boardProperty.getRead_FG() + "</READ>");
			sb.append("<WRITE>" + boardProperty.getWrite_FG() + "</WRITE>");
			sb.append("<REPLY>" + boardProperty.getReply_FG() + "</REPLY>");
			sb.append("<DELETE>" + boardProperty.getDelete_FG() + "</DELETE>");
			sb.append("<INHERIT>" + boardProperty.getInherit_FG() + "</INHERIT>");
			sb.append("<POSTNOTICE>" + boardProperty.getPostNotice() + "</POSTNOTICE>");
			sb.append("</NODE>");
		}
		
		sb.append("</NODES>");

		logger.debug("getACL ended");
		return sb.toString();
	}

	/**
	 * 게시판관리 게시판 권한 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveACL.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveACL(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request,	HttpServletResponse response) {
		logger.debug("saveACL started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String rtnValue = "";
		
		try {
			Document doc = commonUtil.convertStringToDocument(data);
			Map<String, Object> map = new HashMap<String, Object>();
			/* 2018-06-25 홍승비 - 게시판 권한설정 시 companyID 부여 */
			map.put("v_COMPANYID", userInfo.getCompanyID());
			map.put("v_TENANTID", userInfo.getTenantId());
			
			for (int i = 0; i < doc.getElementsByTagName("BOARDID").getLength(); i++) {
				String pAccessName2 = doc.getElementsByTagName("TARGETNAME2").item(i).getTextContent();
				String pAccess_FG = "";
				
				if (pAccessName2 == null || pAccessName2.equals("")) {
					pAccessName2 = doc.getElementsByTagName("TARGETNAME").item(i).getTextContent();
				}
				
				if (doc.getElementsByTagName("ACCESS").item(i).getTextContent().toUpperCase().equals("TRUE")) {
					pAccess_FG = "1";
				} else {
					pAccess_FG = "0";
				}
				
				map.put("v_pBoardID", doc.getElementsByTagName("BOARDID").item(i).getTextContent());
				map.put("v_pAccessID", doc.getElementsByTagName("TARGETID").item(i).getTextContent());
				map.put("v_pAccessName", doc.getElementsByTagName("TARGETNAME").item(i).getTextContent());
				map.put("v_pParentBoardID",	doc.getElementsByTagName("PARENTBOARDID").item(i).getTextContent());
				map.put("v_pInherit", doc.getElementsByTagName("INHERIT").item(i).getTextContent());
				map.put("v_pAdmin", doc.getElementsByTagName("ADMIN").item(i).getTextContent());
				map.put("v_pAccess", pAccess_FG);
				map.put("v_pListView", doc.getElementsByTagName("LIST").item(i).getTextContent());
				map.put("v_pRead", doc.getElementsByTagName("READ").item(i).getTextContent());
				map.put("v_pWrite", doc.getElementsByTagName("WRITE").item(i).getTextContent());
				map.put("v_pReply", doc.getElementsByTagName("REPLY").item(i).getTextContent());
				map.put("v_pDelete", doc.getElementsByTagName("DELETE").item(i).getTextContent());
				map.put("v_pPostNotice", doc.getElementsByTagName("POSTNOTICE").item(i).getTextContent());
				map.put("v_pAccessName2", pAccessName2);
				map.put("v_pBoardGroupACL", doc.getElementsByTagName("TARGETGROUP").item(i).getTextContent());
				map.put("isAllGroupBoard", doc.getElementsByTagName("ISALLGROUPBOARD").item(i).getTextContent());
				/* 2019-09-19 홍승비 - 개인, 부서, 그룹권한 여부 파라미터 추가 */
				map.put("v_pType", doc.getElementsByTagName("TYPE").item(i).getTextContent());
			}
			
			/* 2018-06-25 홍승비 - 게시판 권한설정 시 companyID 부여 */
			// save 서비스 구현
			ezBoardAdminService.saveACL(map);
			
			rtnValue = "OK";
		} catch (Exception e) {
			rtnValue = "ERROR";
			logger.error("EzBoardAdmin :: saveACL :: " + e.getMessage());
		}

		logger.debug("saveACL ended");
		return rtnValue;
	}

	/**
	 * 게시판관리 게시판 권한 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/deleteACL.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String deleteACL(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("deleteACL started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String rtnValue = "";
		
		try {
			Document doc = commonUtil.convertStringToDocument(data);
			
			/* 2018-06-25 홍승비 - 게시판 권한 삭제 시 companyID 조건 부여 */
			ezBoardAdminService.deleteACL(doc, userInfo.getCompanyID(), userInfo.getTenantId());
			
			rtnValue = "OK";
		} catch (Exception e) {
			rtnValue = "ERROR";
			logger.error("EzBoardAdmin :: deleteACL :: " + e.getMessage());
		}

		logger.debug("deleteACL ended");
		return rtnValue;
	}

	/**
	 * 게시판관리 조직도 선택화면 호출 함수 1
	 */
	@RequestMapping(value = "/admin/ezBoard/selectTarget.do", method = RequestMethod.GET)
	public String selectTarget(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("selectTarget started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		String topid = commonUtil.isAdmin(user.getId(), user.getTenantId(), user.getRollInfo(), "c") ? "Top" : user.getCompanyID();
		
		/* 2018-07-26 홍승비 - 비어있는 userLang 대신 primary값이 들어가도록 수정, 사용하지 않는 strXML 제거 */
		model.addAttribute("topid", topid);
		model.addAttribute("primary", user.getPrimary());
		model.addAttribute("deptID", user.getDeptID());
		
		logger.debug("selectTarget ended");
		return "admin/ezBoard/selectTarget";
	}
	
	/**
	 * 게시판관리 조직도 선택화면 호출 함수 2
	 */
	@RequestMapping(value = "/admin/ezBoard/selectTarget2.do", method = RequestMethod.GET)
	public String selectTarget2(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("selectTarget2 started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String topid = "";
		String deptTreeTopId = "";
		String isAllGroupBoard = "";
		
		if(request.getParameter("isAllGroupBoard") != null) {
			isAllGroupBoard = request.getParameter("isAllGroupBoard");
		}
		
		if (commonUtil.isAdmin(user.getId(), user.getTenantId(), user.getRollInfo(), "c")) {
			topid = "Top";
			// 전체관리자이면서 그룹사게시판인 경우, 전체 조직도 표출
			if (isAllGroupBoard != null && isAllGroupBoard.equals("Y")) {
				deptTreeTopId = topid + "/organ";
			}
		} else {
			topid = user.getCompanyID();
			deptTreeTopId = topid;
		}
		
		/* 2018-07-26 홍승비 - 비어있는 userLang 대신 primary값이 들어가도록 수정, 사용하지 않는 strXML 제거 */
		model.addAttribute("topid", topid);
		model.addAttribute("primary", user.getPrimary());
		model.addAttribute("deptID", user.getDeptID());
		model.addAttribute("deptTreeTopId", deptTreeTopId);
		model.addAttribute("isAllGroupBoard", isAllGroupBoard);

		logger.debug("selectTarget2 ended");
		return "admin/ezBoard/selectTarget2";
	}	

	/**
	 * 게시판관리 조직도에 검색 시 중복된 이름이 있을 경우 선택화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/checkName.do", method = RequestMethod.GET)
	public String checkName() throws Exception {
		return "admin/ezBoard/checkName";
	}

	/**
	 * 게시판관리 게시판 권한설정 권한전파 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardUnderGroupCopy.do", method = RequestMethod.GET)
	public String boardUnderGroupCopy(HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardUnderGroupCopy started");

		String boardID = request.getParameter("boardID");
		String isAllGroupBoard = request.getParameter("isAllGroupBoard");
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("isAllGroupBoard", isAllGroupBoard);

		logger.debug("boardUnderGroupCopy ended");
		return "admin/ezBoard/boardUnderGroupCopy";
	}
	
	/**
	 * 게시판관리 게시판 권한설정 권한전파 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/setUnderBoardAcl.do", method = RequestMethod.POST)
	@ResponseBody
	public void setUnderBoardAcl(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("setUnderBoardAcl started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");		
		String type = request.getParameter("type");
		String isAllGroupBoard = request.getParameter("isAllGroupBoard");
		String parentBoardID = ezBoardService.getParentBoardID(boardID, userInfo.getTenantId());
		
		// 권한전파 시 companyID 추가
		List<BoardPropertyVO> list = ezBoardAdminService.getUnderBoardID(boardID, "2", userInfo.getTenantId());
		
		if (type.equals("1")) { // 권한 복사(type 1)
			List<BoardPropertyVO> list2 = ezBoardAdminService.getUnderBoardID(boardID, "1", userInfo.getTenantId());
			
			for (int i = 0; i < list.size(); i++) {
				BoardPropertyVO vo1 = list.get(i);
				
				for (int j = 0; j < list2.size(); j++) {
					BoardPropertyVO vo2 = list2.get(j);
					
					/* 2019-02-13 홍승비 - 게시판그룹에서 관리자(+접근)권한을 전파할 경우, 하위게시판의 나머지 권한들을 true로 고정(게시메일알림 제외) */
					if (parentBoardID != null && parentBoardID.equals("top") && vo2.getBoardAdmin_FG() != null && vo2.getBoardAdmin_FG().equals("true")) {
						vo2.setListView_FG("true");
						vo2.setRead_FG("true");
						vo2.setWrite_FG("true");
						vo2.setReply_FG("true");
						vo2.setDelete_FG("true");
					}
					
					vo2.setBoardID(vo1.getBoardID());
					vo2.setCompanyID(userInfo.getCompanyID());
					vo2.setTenantID(userInfo.getTenantId());
					vo2.setIsAllGroupBoard(isAllGroupBoard);
					vo2.setParentBoardID(vo1.getParentBoardID());
					
					if (vo2.getType() == null) {
						vo2.setType("");
					}
					
					ezBoardAdminService.setUnderBoardIDAcl(vo2);
				}				
			}			
		} else { // 기존권한 삭제 후 복사(type 2)
			for (int i = 0; i < list.size(); i++) {
				BoardPropertyVO vo = list.get(i);
				
				/* 2018-06-26 홍승비 - 권한전파 시 companyID 삽입 추가 */
				ezBoardAdminService.setUnderBoardIDAcl2(boardID, vo.getBoardID(), vo.getParentBoardID(), isAllGroupBoard, userInfo.getCompanyID(), userInfo.getTenantId());
			}
		}
		
		/* 2021-03-16 홍승비 - 기존 트리캐시 제거 동작을 루프 바깥으로 분리, 마지막에 한번만 동작하도록 수정 */
		/* 2018-10-10 홍승비 - 권한전파 시 기존 트리캐시 제거하도록 수정 */
		ezBoardAdminService.trunkBoard(userInfo.getTenantId());

		logger.debug("setUnderBoardAcl ended");
	}
	
	/**
	 * 게시판관리 게시판 권한설정 권한복사 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardAclList.do", method = RequestMethod.GET)
	public String boardAclList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, LoginVO loginVO, Model model) throws Exception {
		logger.debug("boardAclList started");

		String parentBoardID = request.getParameter("parentBoardID");
		String boardID = request.getParameter("boardID");
		String serverName = request.getServerName();
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("serverName", serverName);
		model.addAttribute("parentBoardID", parentBoardID);

		logger.debug("boardAclList ended");
		return "admin/ezBoard/boardAclList";
	}
	
	/**
	 * 게시판관리 게시판 권한설정 권한복사 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/copyBoardAcl.do", method = RequestMethod.POST, produces="text/html;charset=utf-8")
	@ResponseBody
	public String copyBoardAcl(@CookieValue("loginCookie") String loginCookie, @RequestBody String data) throws Exception {
		logger.debug("copyBoardAcl started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String rtnValue = "";
		
		Document doc = commonUtil.convertStringToDocument(data);
		
		/* 2018-06-26 홍승비 - 권한복사 시 companyID 추가 */
		rtnValue = ezBoardAdminService.copyBoardAcl(doc, userInfo.getCompanyID(), userInfo.getTenantId());

		logger.debug("copyBoardAcl ended");
		return rtnValue;
	}
	
	/**
	 * 게시판관리 선택한 게시판 게시물 표출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardConfig.do", method = RequestMethod.GET)
	public String boardConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("boardConfig started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		BoardPropertyVO board = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		String boardName = board.getBoardName();
		String gubun = board.getGuBun();
		String parentBoardID = board.getParentBoardID();
		String tabID = (request.getParameter("tabID") == null ? "1tab1" : request.getParameter("tabID"));
		
		if (gubun.equals("10") && tabID.equals("1tab1")) {
			tabID = "1tab2";
		}
		
		String useFormFlag = ezBoardAdminService.getUseFormFlag(boardID, userInfo.getTenantId());
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardName", commonUtil.cleanValue(boardName));
		model.addAttribute("guBun", gubun);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("tabID", tabID);		
		model.addAttribute("use_Editor", ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId()));
		model.addAttribute("useFormFlag", useFormFlag);

		logger.debug("boardConfig ended");
		return "admin/ezBoard/boardConfig";
	}
	
	/**
	 * 게시판관리 게시판 양식설정 화면[TAB] 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardFormSave.do", method = RequestMethod.GET)
	public String boardFormSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("boardFormSave started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String checkForm = "";
		
		int cnt = ezBoardAdminService.checkForm(boardID, "A", userInfo.getTenantId());
		
		if (cnt > 0) {
			checkForm = "TRUE";
		} else {
			checkForm = "FALSE";
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("checkForm", checkForm);
		model.addAttribute("use_Editor", ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId()));

		logger.debug("boardFormSave ended");
		return "admin/ezBoard/boardFormSave";
	}
	
	/**
	 * 게시판관리 게시판 양식설정 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveForm.do", method = RequestMethod.POST, produces="text/html;charset=utf-8")
	@ResponseBody
	public String saveForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("saveForm started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String formContent = request.getParameter("formContent");
		String realPath = commonUtil.getRealPath(request);
		String editor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String formLocation = "";
		
		if (!editor.equals("HWP")) {
			formLocation = ezBoardAdminService.saveMHT(boardID, formContent, realPath, userInfo.getTenantId());		
		} else {
			formLocation = ezBoardAdminService.saveHWP(boardID, formContent, realPath, userInfo.getTenantId());
		}
		
		ezBoardAdminService.setBoardForm(boardID, formLocation, userInfo.getTenantId());

		logger.debug("saveForm ended");
		return "OK";
	}
	
	/**
	 * 2019-09-19 홍승비 - 그룹권한이 포함된 새로운 게시판관리 조직도 선택화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/selectTargetGroup.do", method = RequestMethod.GET)
	public String selectTargetGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("selectTargetGroup started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		String isAllGroupBoard = request.getParameter("isAllGroupBoard");
		String topid = Optional.ofNullable(request.getParameter("companyID")).orElse(user.getCompanyID());

		if (isAllGroupBoard == null || isAllGroupBoard.equals("")) {
			isAllGroupBoard = "N";
		}

		// 전체관리자이면서 그룹사게시판인 경우 (모든 회사를 조직도에서 표출)
        if (commonUtil.isAdmin(user.getId(), user.getTenantId(), user.getRollInfo(), "c") && !isAllGroupBoard.equals("N")) {
            topid = "Top";
        }

        List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(user.getPrimary(), user.getTenantId());

		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0 ; i < list.size() ; i++) {
			OrganDeptVO vo = list.get(i);
			// 권한을 설정할 게시판이 그룹사게시판이고, 접근한 관리자가 전체관리자인 경우에만 다른 회사를 리스트에 추가
			// 자신이 소속한 회사는 반드시 리스트에 추가
			if ((commonUtil.isAdmin(user.getId(), user.getTenantId(), user.getRollInfo(), "c") && isAllGroupBoard.equals("Y")) || vo.getCn().equals(user.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("isAllGroupBoard", isAllGroupBoard);
		model.addAttribute("topid", topid);
		model.addAttribute("primary", user.getPrimary());
		model.addAttribute("deptID", user.getDeptID());
		model.addAttribute("companyID", user.getCompanyID());
		model.addAttribute("list", resultList);
		
		logger.debug("selectTargetGroup ended");
		return "admin/ezBoard/selectTargetGroup";
	}
	
	
//////////////////////////////////////관리자단 게시판 트리캐시 일괄생성 코드 시작 //////////////////////////////////////
	/**
	 * 2022-09-27 홍승비 - 관리자 > 게시판 > 트리캐시 일괄생성 메뉴 진입
	 */
	@RequestMapping(value = "/admin/ezBoard/boardMakeAllTreeCache.do", method = RequestMethod.GET)
	public String boardMakeAllTreeCache(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("boardMakeAllTreeCache started");
		// 단순 페이지 호출 동작
		logger.debug("boardMakeAllTreeCache ended");
		return "admin/ezBoard/boardMakeAllTreeCache";
	}
	
	/**
	 * 2022-09-28 홍승비 - 관리자 > 게시판 > 트리캐시 일괄생성 동작
	 */
	@RequestMapping(value = "/admin/ezBoard/makeAllTreeCache.do", method = RequestMethod.POST)
	@ResponseBody
	public String makeAllTreeCache(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("makeAllTreeCache started");
		
		long beforeTime = System.currentTimeMillis();
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		
		// 1) 현재 그룹웨어 상의 모든 사용자 ID를 가져옴
		List<OrganUserVO> userCnList = ezOrganAdminService.getUserCnList(tenantID);
		
		try {
			// 멀티스레딩을 위해 스레드 생성, 메인 스레드는 CountDownLatch로 사용자 수만큼의 스레드 작업이 완료되는 것을 기다림
			ExecutorService service = Executors.newFixedThreadPool(8); // 최대 8개의 스레드 생성
			CountDownLatch latch = new CountDownLatch(userCnList.size()); // 사용자 수만큼 스레드 작업 완료 대기
			
			// 2) 각 사용자 ID에 대하여 LoginVO를 만든 뒤, 트리캐시 생성 루프를 진행
			 for (OrganUserVO organUser : userCnList) {
				 LoginVO userInfoT = new LoginVO();
				 
				 userInfoT.setId(organUser.getCn());
				 userInfoT.setTenantId(tenantID);
				 userInfoT.setDn("NOPASSWORD");
				 LoginVO resultVO = loginService.selectUser(userInfoT);
				 
				 // deptPathCode에서 userID가 맨 앞으로 오도록 조정 (로그인쿠키를 사용하는 userInfo 참고)
				 resultVO.setDeptPathCode(organUser.getCn() + "," + resultVO.getDeptPathCode());
				 
				 // 람다식으로 트리캐시 생성 task를 지정, 내부적인 Exception 발생 시 바로 리턴하지 않고 다음 루프를 진행 (삽입된 트리캐시는 롤백되지 않음)
				 service.submit(() -> {
					 makeAllTreeCacheForUsers(resultVO);
					 latch.countDown();
					 
					 // unchecked예외 발생 시 해당 예외 throw
					 throw new IllegalArgumentException();
				 });
			 }
			latch.await(); // 다른 스레드의 작업 완료 대기
		}
		catch (Exception e) {
			logger.debug("makeAllTreeCache aborted, error occurs!");
			logger.error(e.getMessage(), e);
			return "FALSE";
		}
		// 전부 완료된 경우 TRUE를 리턴, 도중에 실패하면 지금까지의 DB 레코드 삽입이 롤백되지 않도록 catch 하고 FALSE 리턴
		
		long afterTime = System.currentTimeMillis();
		long secDiffTime = (afterTime - beforeTime) / 1000;
		
		logger.debug("makeAllTreeCache ended, all process success! process time(s) = " + secDiffTime + " (for [" + userCnList.size() + "] users)");
		
		return "TRUE";
	}
	
	/**
	 * 2022-09-29 홍승비 - 접근 가능한 게시판 전체에 대해 트리캐시를 생성하는 메서드 
	 */
	public String makeAllTreeCacheForUsers(LoginVO userInfo) throws Exception {
		logger.debug("makeAllTreeCacheForUsers started, userID = " + userInfo.getId());
		
		String pRootBoardID = "top";
		String pSubFlag = "1";
		int pSelectBy = 0;
		String pExcludeBoardID = " ";
		String isAdminLeft = "";
		boolean isCompanyAdmin = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c");
		
		String boardGroupAdmin_FG = "NO";
		int pMode = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;n;k") ? 0 : 1;
		
		String strXML = ezBoardService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID,
				commonUtil.getMultiData(userInfo.getPrimary(), userInfo.getTenantId()), isAdminLeft, isCompanyAdmin, boardGroupAdmin_FG, userInfo.getRollInfo(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(strXML);
		NodeList nList = doc.getElementsByTagName("NODE");
		
		ArrayList<String> accessBoardList = new ArrayList<String>();
		ArrayList<String> tempBoardList = new ArrayList<String>();
		ArrayList<String> accessAllBoardList = new ArrayList<String>();
		
		for (int i = 0; i < nList.getLength(); i++) {
			accessBoardList.add(nList.item(i).getChildNodes().item(2).getTextContent());
		}
		
		/* 2019-06-03  홍승비 - 게시판그룹 관리자권한 체크 시 사내겸직 및 하위부서 허용여부 체크하도록 수정 */
		//접근가능한 게시판
		while (accessBoardList.size() != 0) {
			for (int i = 0; i < accessBoardList.size(); i++) {
				boardGroupAdmin_FG = checkIfBoardGroupAdmin(accessBoardList.get(i), userInfo);
				pMode = boardGroupAdmin_FG.equals("OK") || commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;n;k") ? 0 : 1;
				strXML = ezBoardService.getBoardTree(accessBoardList.get(i), userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID,
						commonUtil.getMultiData(userInfo.getPrimary(), userInfo.getTenantId()), isAdminLeft, isCompanyAdmin, boardGroupAdmin_FG, userInfo.getRollInfo(), userInfo.getTenantId());
				doc = commonUtil.convertStringToDocument(strXML);
				nList = doc.getElementsByTagName("NODE");
				
				for (int j = 0; j < nList.getLength(); j++) {
					tempBoardList.add(nList.item(j).getChildNodes().item(2).getTextContent()); 
					accessAllBoardList.add(nList.item(j).getChildNodes().item(2).getTextContent());  
				}
			}
			
			accessBoardList.clear();
			accessBoardList.addAll(tempBoardList);
			tempBoardList.clear();
		}
		
		logger.debug("makeAllTreeCacheForUsers ended, userID = " + userInfo.getId());
		return "TRUE";
	}
	
	/** 2022-09-29 홍승비 - 사내겸직, 하위부서 허용여부 판단하여 게시판 그룹의 관리자권한 체크 */
	public String checkIfBoardGroupAdmin(String pBoardGroupID, LoginVO userInfo) throws Exception {
		logger.debug("checkIfBoardGroupAdmin started");
		
		String result = "NO";
		String deptPath = userInfo.getDeptPathCode();
		StringBuilder deptPathOrgan = new StringBuilder();
		List<String> addJobDeptList = new ArrayList<String>();
		
		/* 2019-09-18 홍승비 - 개인ID 이후, 부서ID 이전 위치에 직위+직책ID (사내겸직 직위 포함) 추가 */
		String userJJID = ezBoardService.getUserJJID(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		for (int ch = 0; ch < deptPath.split(",").length; ch++) {
			if (ch == 0) { // 0 : userID
				deptPathOrgan.append(deptPath.split(",")[ch].trim());
				deptPathOrgan.append(",").append(userJJID);
			} else {
				deptPathOrgan.append(",").append(deptPath.split(",")[deptPath.split(",").length - (ch)].trim());
			}
		}
		
		String userDeptPath = deptPathOrgan.toString();
		addJobDeptList.add(userDeptPath);
		
		List<String> addJobList = ezBoardService.getPDOAddJobDeptID(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		StringJoiner addJobStr = new StringJoiner(",");
		addJobStr.add(userInfo.getDeptID());
		if (addJobList != null && addJobList.size() > 0) {
			for (int i = 0; i < addJobList.size(); i++) {
				addJobStr.add(addJobList.get(i));
				String upperDept = ezBoardService.getUpperDeptID(addJobList.get(i), userInfo.getTenantId());
				
				if (upperDept != null && !upperDept.equals("")) {
					boolean loopContinue = true;
					StringJoiner upperDeptStr = new StringJoiner(",");
					upperDeptStr.add(upperDept);
					
					while (loopContinue) {
						String upperDeptLoop = ezBoardService.getUpperDeptID(upperDept, userInfo.getTenantId());
						if (upperDeptLoop != null && !upperDeptLoop.equals("")) {
							upperDeptStr.add(upperDeptLoop);
							upperDept = upperDeptLoop;
						} else {
							loopContinue = false;
						}
					}
					addJobDeptList.add(addJobList.get(i) + "," + upperDeptStr.toString());
				}
			}
		}
		
		boolean isBoardGroup = false;
		BoardPropertyVO orgBoardProp = ezBoardService.getBoardProperty(pBoardGroupID, userInfo.getTenantId());
		if (orgBoardProp != null) {
			if (orgBoardProp.getBoardGroupID() != null && !orgBoardProp.getBoardGroupID().equals("")) { // 하위게시판
				isBoardGroup = false;
			} else { // 게시판그룹
				isBoardGroup = true;
			}
		}
		
		// 부서, 회사 / 직위, 직책 Set 추가
		Set<String> boardGroupAdminFGSetDept = new HashSet<String>();
		Set<String> boardGroupAdminFGSetJJ = new HashSet<String>();
		Set<String> userJJIDSet = new HashSet<String>(Arrays.asList(userJJID.split(",")));
		
		boolean isUserHasACL = false;
		String tempDeptList = addJobStr.toString();
		int addJobDeptListSize = addJobDeptList.size();
		for (int jl = 0; jl < addJobDeptListSize; jl++) {
			if (isUserHasACL == false) {
				int addJobDeptListPathSize = addJobDeptList.get(jl).split(",").length;
				for (int i = 0; i < addJobDeptListPathSize; i++) {
					int isEqualDept = 0;
					for (int j = 0; j < tempDeptList.split(",").length; j++) {
						if(addJobDeptList.get(jl).split(",")[i].trim().equalsIgnoreCase(tempDeptList.split(",")[j])) {
							isEqualDept = 1;
							break;
						} else {
							isEqualDept = 0;
						}
					}
					
					int isDept = ezBoardService.isDeptChk(addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId());
					
					/* 2019-09-20 홍승비 - 권한그룹을 포함하여 게시판그룹 관리자권한 체크 */
					// 권한그룹 적용 시 개인권한이 다수 존재 가능하므로, 권한을 리스트로 가져온 뒤 '허용(OK)'기준으로 취합한다.
					List<String> boardGroupAdminNew_FG_List = ezBoardService.checkIfBoardGroupAdminNew(pBoardGroupID, addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId(), isDept, isEqualDept, isBoardGroup);
					String boardGroupAdminNew_FG = "";
					// 전달한 ACCESSID에 대한 게시판 관리자권한 리스트 (OK, NO)
					if (boardGroupAdminNew_FG_List != null && boardGroupAdminNew_FG_List.size() > 0) { // 권한이 없으면 공백값을 유지 > 다음 루프 진행
						if (boardGroupAdminNew_FG_List.contains("OK")) { // 동일한 우선순위의 권한에 대해서, OK가 하나라도 존재한다면 OK로 판정
							boardGroupAdminNew_FG = "OK";
						} else {
							boardGroupAdminNew_FG = "NO";
						}
					}
					
					if (!boardGroupAdminNew_FG.equals("")) {
						if (addJobDeptList.get(jl).split(",")[i].trim().equals(userInfo.getId())) { // 개인의 권한
							result = boardGroupAdminNew_FG; // 그룹권한에 포함된 개인권한을 상단에서 취합했으므로, 그대로 사용 가능
							isUserHasACL = true;
							break;
						}
						else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위, 직책 권한
							boardGroupAdminFGSetJJ.add(boardGroupAdminNew_FG);
							isUserHasACL = false;
							// 직위, 직책권한은 레코드 전부 찾을때까지 break 안함
						}
						else { // 부서, 회사의 권한
							boardGroupAdminFGSetDept.add(boardGroupAdminNew_FG);
							isUserHasACL = false;
							break;
						}
					}
				}
			}
		}
		
		// 개인권한이 있다면 개인권한을  result로 사용 / 개인권한이 없다면 직위, 직책권한 -> 부서권한 순으로 체크
		if (isUserHasACL == false) {
			if (boardGroupAdminFGSetJJ.size() > 0 && boardGroupAdminFGSetJJ.contains("OK")) { // 직위, 직책권한이 존재하고 OK를 가지는 경우
				result = "OK";
			} else if (boardGroupAdminFGSetJJ.size() == 0 && boardGroupAdminFGSetDept.contains("OK")) { // 직위, 직책권한이 없고 부서권한이 OK를 가지는 경우
				result = "OK";
			} // 이외의 경우는 직위, 직책권한이 존재하고 NO만 가지는 경우 || 직위, 직잭권한이 없고 부서권한이 NO만 가지는 경우 => 즉 result는 NO로 유지되어 리턴
		}
		
		logger.debug("checkIfBoardGroupAdmin ended");
		return result;
	}
	
//////////////////////////////////////관리자단 게시판 트리캐시 일괄생성 코드 완료 //////////////////////////////////////

	/**
	 * 인사연동 > 부서생성 - 해당 API 호출 시 부서게시판 하위에 부서게시판 생성 로직
	 */
	@RequestMapping(value = "/ezConn/ezBoard/makeDeptBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject makeDeptBoard(HttpServletRequest request) throws Exception {
		logger.debug("makeDeptBoard started");

		JSONObject result;
		Map<String, Object> resultMap = new HashMap<>();
		String[] deptArr;
		
		String tenant = request.getParameter("tenantID");
		String deptID = request.getParameter("deptID"); // 부서아이디 (구분자 ,)
		String companyID = request.getParameter("companyID");
		
		if (StringUtils.isBlank(tenant) || StringUtils.isBlank(deptID) || StringUtils.isBlank(companyID)) {
			resultMap.put("status", "error");
			resultMap.put("message", "PARAM_ERROR");

			result = new JSONObject(resultMap);
			return result;
		} else {
			int tenantID = Integer.parseInt(tenant);
			deptArr = deptID.split(",");

			LoginVO user = new LoginVO();
			user.setLang("");

			// API 호출 시 부서게시판 {BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB} 이 존재하는지 확인 없으면 생성
			String deptBoardID = "{BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB}";
			BoardPropertyVO deptBoardProperty = ezBoardService.getBoardProperty(deptBoardID, tenantID);
			BoardPropertyVO boardPropertyVO = new BoardPropertyVO();

			if (deptBoardProperty == null) {
				try {
					boardPropertyVO.setBoardGroupName("부서게시판");
					boardPropertyVO.setBoardGroupName2("Dept BoardItem");
					boardPropertyVO.setBoardGroupName3("部署掲示板");
					boardPropertyVO.setBoardGroupName4("部门公告板");
					boardPropertyVO.setAccessID("NONE");
					boardPropertyVO.setCompanyID(companyID);
					boardPropertyVO.setTenantID(tenantID);
					boardPropertyVO.setLoginVO(user);
					boardPropertyVO.setBoardGroupID(deptBoardID);
					boardPropertyVO.setGuBun("0");
					ezBoardAdminService.createBoardGroup(boardPropertyVO);
				} catch (SQLException e) {
					logger.error(e.getMessage());
					resultMap.put("status", "error");
					resultMap.put("message", "CREATE_GROUP_ERROR");
					result = new JSONObject(resultMap);
					return result;
				}
			}
			
			List<Map<String, Object>> addDeptlist = new ArrayList<>();
			for (String deptCn : deptArr) {
				try {
					BoardPropertyVO boardPropertyVO2 = new BoardPropertyVO();
					OrganDeptVO deptInfo = ezOrganAdminService.getDeptDisplayNm(deptCn, tenantID);

					if (deptInfo == null) {
						resultMap.put("status", "error");
						resultMap.put("message", "DEPT_ERROR");

						result = new JSONObject(resultMap);
						return result;
					}
					
					String boardID = "{" + ezBoardAdminService.getNewGuid() + "}";

					boardPropertyVO2.setBoardID(boardID);
					boardPropertyVO2.setBoardName(deptInfo.getDisplayName());
					boardPropertyVO2.setBoardName2(deptInfo.getDisplayName2());
					boardPropertyVO2.setBoardName3(deptInfo.getDisplayName2());
					boardPropertyVO2.setBoardName4(deptInfo.getDisplayName2());
					boardPropertyVO2.setAccessID(deptCn);
					boardPropertyVO2.setAccessName(deptInfo.getDisplayName());
					boardPropertyVO2.setAccessName2(deptInfo.getDisplayName2());
					boardPropertyVO2.setCompanyID(companyID);
					boardPropertyVO2.setTenantID(tenantID);
					boardPropertyVO2.setParentBoardID(deptBoardID);
					boardPropertyVO2.setBoardGroupID(deptBoardID);
					boardPropertyVO2.setType("DEPT");
					boardPropertyVO.setGuBun("0");

					ezBoardAdminService.createBoard(boardPropertyVO2);
					Map<String, Object> map = new HashMap<>();
					map.put("boardID", boardID);
					map.put("accessID", deptCn);
					addDeptlist.add(map);
				} catch (SQLException e) {
					logger.error(e.getMessage());
					resultMap.put("status", "error");
					resultMap.put("message", "CREATE_BOARD_ERROR");
					result = new JSONObject(resultMap);
					return result;
				}
			}

			for (Map<String, Object> info : addDeptlist) {
				List<BoardPropertyVO> accessList = ezBoardAdminService.getBoardAccessList((String) info.get("boardID"), "N", companyID, tenantID);
				for (BoardPropertyVO access : accessList) {
					if ((access.getAccessID()).equals(info.get("accessID"))) {
						
						Map<String, Object> map = new HashMap<>();
						map.put("v_COMPANYID", companyID);
						map.put("v_TENANTID", tenantID);
						map.put("v_pBoardID", info.get("boardID"));
						map.put("v_pAccessID", access.getAccessID());
						map.put("v_pAccessName", access.getAccessName());
						map.put("v_pParentBoardID",	access.getParentBoardID());
						map.put("v_pInherit", access.getInherit_FG());
						map.put("v_pAdmin", "false");
						map.put("v_pAccess", access.getAccess_());
						map.put("v_pListView", access.getListView_FG());
						map.put("v_pRead", access.getRead_FG());
						map.put("v_pWrite", access.getWrite_FG());
						map.put("v_pReply", access.getReply_FG());
						map.put("v_pDelete", access.getDelete_FG());
						map.put("v_pPostNotice", access.getPostNotice());
						map.put("v_pAccessName2", access.getAccessName2());
						map.put("v_pBoardGroupACL", access.getBoardGroupACL());
						map.put("isAllGroupBoard", access.getIsAllGroupBoard());
						map.put("v_pType", "DEPT");

						// 상위 그룹게시판 (부서게시판) 권한 하위게시판 따라가도록 설정
						ezBoardAdminService.saveACL(map);
					}
				}
			}
		}
		
		logger.debug("makeDeptBoard ended");
		resultMap.put("status", "ok");
		resultMap.put("message", "SUCCESS");
		result = new JSONObject(resultMap);
		return result;
	}
	
	@RequestMapping(value = "/admin/ezBoard/createModifyHistory.do", method = RequestMethod.POST)
	@ResponseBody
	public String createModifyHistory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("createModifyHistory started");
		String res = "FAIL";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardId = request.getParameter("boardID");

		res = ezBoardAdminService.createModifyHistory(boardId, userInfo.getTenantId());

		logger.debug("createModifyHistory ended");
		return res;
	}
}