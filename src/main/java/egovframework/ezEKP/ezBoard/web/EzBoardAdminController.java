package egovframework.ezEKP.ezBoard.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

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

	@Autowired
	private Properties config;

	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;

	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzBoardAdminController.class);

	/**
	 * 게시판관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardMain.do")
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
	@RequestMapping(value = "/admin/ezBoard/boardLeft.do")
	public String boardLeft(@CookieValue("loginCookie") String loginCookie,	HttpServletRequest request, Model model) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);

		String serverName = request.getServerName();
		String redirectBoardID = "";
		String redirectBoardGroupID = "";

		if (request.getParameter("boardID") != null) {
			redirectBoardID = request.getParameter("boardID");
			List<BoardVO> leftBoardList = ezBoardService.getLeft_BoardSTD(redirectBoardID, user.getTenantId());

			redirectBoardGroupID = leftBoardList.get(0).getBoardGroupId();
		}
		model.addAttribute("redirectBoardID", redirectBoardID);
		model.addAttribute("redirectBoardGroupID", redirectBoardGroupID);
		model.addAttribute("user", user);
		model.addAttribute("serverName", serverName);

		return "admin/ezBoard/boardLeft";
	}

	/**
	 * 게시판관리 오른쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardRight.do")
	public String boardRight() throws Exception {
		return "admin/ezBoard/boardRight";
	}
	
	/**
	 * 게시판관리 상단메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/get_Admin_TopBoardList.do")
	public String get_Admin_TopBoardList(HttpServletRequest request, HttpServletResponse response, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String parentBoardID = request.getParameter("boardType");
		List<BoardTreeVO> list = ezBoardAdminService.get_Admin_TopBoardList(parentBoardID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());

		for (int i = 0; i < list.size(); i++) {
			BoardTreeVO vo = list.get(i);
			String creanValue = commonUtil.cleanValue(vo.getBoardName());
			vo.setBoardName(creanValue);
		}
		
		model.addAttribute("topBoardList", list);
		
		return "json";
	}

	/**
	 * 게시판관리 게시판그룹생성 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardGroupCreate.do")
	public String boardGroupCreate(Model model, @CookieValue("loginCookie") String loginCookie,	LoginVO userInfo) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String lang = userInfo.getLang();
		String use_multiData = ezCommonService.getTenantConfig("Use_MultiData", userInfo.getTenantId());
		String lang_primary = ezCommonService.getTenantConfig("LangPrimary" + lang, userInfo.getTenantId());
		String lang_secondary = ezCommonService.getTenantConfig("LangSecondary" + lang, userInfo.getTenantId());

		model.addAttribute("use_multiData", use_multiData);
		model.addAttribute("lang_primary", lang_primary);
		model.addAttribute("lang_secondary", lang_secondary);

		return "admin/ezBoard/boardGroupCreate";
	}

	/**
	 * 게시판관리 게시판그룹생성 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/createBoardGroup.do")
	public void createBoardGroup(@CookieValue("loginCookie") String loginCookie, HttpServletResponse response, BoardPropertyVO boardPropertyVO)	throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String groupName1 = URLDecoder.decode(boardPropertyVO.getBoardGroupName(), "utf-8");
		String groupName2 = URLDecoder.decode(boardPropertyVO.getBoardGroupName2(), "utf-8");
		String accessName1 = user.getDeptName1() + "(" + user.getCompanyName1()	+ ", " + user.getDeptName1() + ")";
		String accessName2 = user.getDeptName2() + "(" + user.getCompanyName2()	+ ", " + user.getDeptName2() + ")";
		String uID = user.getId();

		boardPropertyVO.setBoardGroupName(groupName1);
		boardPropertyVO.setBoardGroupName2(groupName2);
		boardPropertyVO.setAccessID(uID);
		boardPropertyVO.setAccessName(accessName1);
		boardPropertyVO.setAccessName2(accessName2);
		boardPropertyVO.setTenantID(user.getTenantId());

		ezBoardAdminService.createBoardGroup(boardPropertyVO);
	}

	/**
	 * 게시판관리 하위게시판등록 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardCreate.do")
	public String boardCreate(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String lang = userInfo.getLang();
		String use_multiData = ezCommonService.getTenantConfig("Use_MultiData", userInfo.getTenantId());
		String lang_primary = ezCommonService.getTenantConfig("LangPrimary" + lang, userInfo.getTenantId());
		String lang_secondary = ezCommonService.getTenantConfig("LangSecondary" + lang, userInfo.getTenantId());
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String parentBoardName = "";

		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(parentBoardID, userInfo.getTenantId());

		if (lang == "2" && !boardPropertyVO.getBoardName2().equals("")) {
			parentBoardName = boardPropertyVO.getBoardName2();
		} else {
			parentBoardName = boardPropertyVO.getBoardName();
		}

		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("parentBoardName", parentBoardName);
		model.addAttribute("use_multiData", use_multiData);
		model.addAttribute("lang_primary", lang_primary);
		model.addAttribute("lang_secondary", lang_secondary);

		return "admin/ezBoard/boardCreate";
	}

	/**
	 * 게시판관리 하위게시판등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/createBoard.do")
	public void createBoard(@CookieValue("loginCookie") String loginCookie,	HttpServletResponse response, BoardPropertyVO boardPropertyVO) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);

		String boardName1 = URLDecoder.decode(boardPropertyVO.getBoardName(), "utf-8");
		String boardName2 = URLDecoder.decode(boardPropertyVO.getBoardName2(), "utf-8");
		String accessName1 = user.getDeptName1() + "(" + user.getCompanyName1()	+ ", " + user.getDeptName1() + ")";
		String accessName2 = user.getDeptName2() + "(" + user.getCompanyName2()	+ ", " + user.getDeptName2() + ")";
		String uID = user.getId();

		boardPropertyVO.setBoardName(boardName1);
		boardPropertyVO.setBoardName2(boardName2);
		boardPropertyVO.setAccessID(uID);
		boardPropertyVO.setAccessName(accessName1);
		boardPropertyVO.setAccessName2(accessName2);
		boardPropertyVO.setTenantID(user.getTenantId());

		ezBoardAdminService.createBoard(boardPropertyVO);
	}

	/**
	 * 게시판관리 게시판순서조정 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardOrder.do")
	public String boardOrder(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String parentBoardID = request.getParameter("parentBoardID");
		String boardID = request.getParameter("boardID");

		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());

		model.addAttribute("upperBoardID", parentBoardID);
		model.addAttribute("boardName", boardPropertyVO.getBoardName());

		return "admin/ezBoard/boardOrder";
	}

	/**
	 * 게시판관리 게시판순서조정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveBoardOrder.do")
	public void saveBoardOrder(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String pBoardIDList = request.getParameter("boardList");

		ezBoardAdminService.saveBoardOrder(pBoardIDList, userInfo.getTenantId());
	}
	
	/**
	 * 게시판관리 게시판 서브트리 표출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getSubBoards.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getSubBoards(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);

		String upperBoardID = request.getParameter("upperBoardID");
		String boardTree = ezBoardService.getBoardTree(upperBoardID, user.getId(), user.getDeptID(), user.getCompanyID(), 0, 1, 0, " ", "", user.getTenantId());

		return boardTree;
	}

	/**
	 * 게시판관리 그룹 및 게시판삭제 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardDelete.do")
	public String boardDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);

		String boardID = request.getParameter("boardID");
		String boardGroupID = request.getParameter("boardGroupID");
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, user.getTenantId());
		
		String boardTree = ezBoardService.getBoardTree(boardID, user.getId(), user.getDeptID(), user.getCompanyID(), 0, 1, 0, " ", "", user.getTenantId());
		if (boardTree.trim().equals("<NODES></NODES>")) {
			model.addAttribute("hasSubBoard", 0);
		} else {
			model.addAttribute("hasSubBoard", 1);
		}

		if (boardPropertyVO == null) {
			return "admin/ezBoard/boardRight";
		} else {
			model.addAttribute("boardID", boardID);
			model.addAttribute("boardGroupID", boardGroupID);
			model.addAttribute("boardName", boardPropertyVO.getBoardName());
			
			return "admin/ezBoard/boardDelete";
		}
	}

	/**
	 * 게시판관리 그룹 및 게시판삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/deleteBoard.do")
	public void deleteBoard(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");

		ezBoardAdminService.deleteBoard(boardID, userInfo.getTenantId());
	}

	/**
	 * 게시판관리 배경이미지 관리 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardBackGround.do")
	public String boardBackGround(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("boardBackGround started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		model.addAttribute("tenantID", userInfo.getTenantId());

		logger.debug("boardBackGround ended");
		
		return "admin/ezBoard/boardBackGround";
	}

	/**
	 * 게시판관리 현재 배경이미지 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getBackGroundImage.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getBackGroundImage(HttpServletResponse response, BoardBackgroundVO boardBackgroundVO, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boardBackgroundVO.setTenantID(userInfo.getTenantId());
		
		List<BoardBackgroundVO> list = ezBoardAdminService.getBackGroundImage(boardBackgroundVO);

		StringBuffer xmlStr = new StringBuffer();

		if (list.size() > 0) {
			xmlStr.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
			xmlStr.append("<DATA>");

			for (int i = 0; i < list.size(); i++) {
				xmlStr.append("<ROW>");
				xmlStr.append("<BACKGROUNDID>" + list.get(i).getBackgroundID() + "</BACKGROUNDID>");
				xmlStr.append("<ORGFILENAME>" + list.get(i).getOrgFileName() + "</ORGFILENAME>");
				xmlStr.append("<SAVEFILENAME>" + list.get(i).getSaveFileName() + "</SAVEFILENAME>");
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
		
		return xmlStr.toString();
	}

	/**
	 * 게시판관리 배경이미지 상태값 변경 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/statusChangeBackGroundImage.do")
	public void statusChangeBackGroundImage(HttpServletRequest request,	HttpServletResponse response, BoardBackgroundVO boardBackgroundVO, @CookieValue("loginCookie") String loginCookie) throws Exception {
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
	}

	/**
	 * 게시판관리 선택한 배경이미지 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/selectBackGroundImage.do")
	public String selectBackGroundImage(BoardBackgroundVO boardBackgroundVO, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String type = boardBackgroundVO.getType();
		
		boardBackgroundVO.setTenantID(userInfo.getTenantId());

		if (type.equals("UPT")) {
			List<BoardBackgroundVO> list = ezBoardAdminService.getBackGroundImage(boardBackgroundVO);

			if (list.size() > 0) {
				String filePath = commonUtil.getUploadPath("upload_board.BOARDBACKGROUND", userInfo.getTenantId());
				String fileName = ((BoardBackgroundVO) list.get(0)).getSaveFileName();

				model.addAttribute("width", boardBackgroundVO.getWidth());
				model.addAttribute("height", boardBackgroundVO.getHeight());
				model.addAttribute("backgroundID", boardBackgroundVO.getBackgroundID());
				model.addAttribute("filePath", filePath);
				model.addAttribute("fileName", fileName);
			} else {
				model.addAttribute("fileName", "");
			}
		} else {
			model.addAttribute("fileName", "");
		}
		model.addAttribute("type", type);

		return "admin/ezBoard/selectBackGroundImage";
	}

	/**
	 * 게시판관리 배경이미지 파일 업로드 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/uploadBackGroundImage.do")
	public void uploadBackGroundImage(MultipartHttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
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
			File imageFile = new File(realFullPath);

			if (imageFile.exists()) {
				BufferedImage bi = ImageIO.read(new File(realFullPath));
				width = bi.getWidth();
				height = bi.getHeight();

				response.getWriter().write(filePath + "," + fileName + "," + width + "/" + height);
			}
		} catch (Exception e) {
			logger.debug("uploadBackGroundImage error");
		}
	}

	/**
	 * 게시판관리 배경이미지 정보 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveBackGroundImage.do")
	public void saveBackGroundImage(@CookieValue("loginCookie") String loginCookie,	HttpServletResponse response, MultipartHttpServletRequest request, BoardBackgroundVO boardBackgroundVO) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		boardBackgroundVO.setRegUserID(user.getId());
		boardBackgroundVO.setTenantID(user.getTenantId());

		MultipartFile file = request.getFile("file1");

		if (file != null) {
			String fileName = boardBackgroundVO.getSaveFileName();
			String filePath = commonUtil.getUploadPath("upload_board.BOARDBACKGROUND", user.getTenantId());
			String tempFilePath = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", user.getTenantId());
			String realPath = commonUtil.getRealPath(request);

			writeUploadedFile(file, "S_" + fileName, realPath + filePath);

			try {
				File tempFile = new File(realPath + tempFilePath + commonUtil.separator + "S_" + fileName);

				if (tempFile != null) {
					tempFile.delete();
				}

				boardBackgroundVO.setOrgFileName(file.getOriginalFilename());
				boardBackgroundVO.setSaveFileName(fileName);
			} catch (Exception e) {
				logger.error("EzBoardAdmin :: saveBackGroungImage");
			}
		}

		ezBoardAdminService.saveBackGroundImage(boardBackgroundVO);
	}

	/**
	 * 게시판관리 배경이미지 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/deleteBackGroundImage.do")
	public void deleteBackGroundImage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, BoardBackgroundVO boardBackgroundVO) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String fileName = boardBackgroundVO.getSaveFileName();
		String filePath = commonUtil.getUploadPath("upload_board.BOARDBACKGROUND", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		
		boardBackgroundVO.setTenantID(userInfo.getTenantId());

		try {
			File tempFile = new File(realPath + filePath + commonUtil.separator +"S_" + fileName);

			if (tempFile != null) {
				tempFile.delete();
			}
			
			ezBoardAdminService.deleteBackGroundImage(boardBackgroundVO);

		} catch (Exception e) {
			logger.error("EzBoardAdmin :: deleteBackGroundImage");
		}
	}

	/**
	 * 게시판관리 게시판이동 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardMove.do")
	public String boardMove(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
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

		model.addAttribute("boardID", boardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("boardName", boardPropertyVO.getBoardName());
		model.addAttribute("hasSubBoard", hasSubBoard);

		return "admin/ezBoard/boardMove";
	}

	/**
	 * 게시판관리 이동할 게시판 선택화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardMoveSelect.do")
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
	@RequestMapping(value = "/admin/ezBoard/moveBoard.do")
	public void moveBoard(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String orgBoardID = request.getParameter("orgBoardID");
		String newParentBoardID = request.getParameter("newParentBoardID");
		String newBoardGroupID = request.getParameter("newBoardGroupID");

		ezBoardAdminService.moveBoard(orgBoardID, newParentBoardID,	newBoardGroupID, userInfo.getTenantId());
	}

	/**
	 * 게시판관리 게시판그룹이름변경 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardProperty.do")
	public String boardProperty(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request,	HttpServletResponse response, Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String lang = userInfo.getLang();
		String use_multiData = ezCommonService.getTenantConfig("Use_MultiData", userInfo.getTenantId());
		String lang_primary = ezCommonService.getTenantConfig("LangPrimary" + lang, userInfo.getTenantId());
		String lang_secondary = ezCommonService.getTenantConfig("LangSecondary" + lang, userInfo.getTenantId());
		String use_portal = ezCommonService.getTenantConfig("Use_Portal", userInfo.getTenantId());
		String boardID = request.getParameter("boardID");
		String adminType = request.getParameter("adminType");
		String style = "";

		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());

		if (boardPropertyVO.getBoardName2() == null	|| boardPropertyVO.getBoardName2().equals("")) {
			boardPropertyVO.setBoardName2(boardPropertyVO.getBoardName1());
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

		model.addAttribute("model", boardPropertyVO);
		model.addAttribute("use_multiData", use_multiData);
		model.addAttribute("lang", lang);
		model.addAttribute("lang_primary", lang_primary);
		model.addAttribute("lang_secondary", lang_secondary);
		model.addAttribute("use_portal", use_portal);
		model.addAttribute("style", style);
		model.addAttribute("adminType", adminType);

		return "admin/ezBoard/boardProperty";
	}

	/**
	 * 게시판관리 게시판그룹이름변경 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveBoardProperty.do")
	public void saveBoardProperty(@CookieValue("loginCookie") String loginCookie, HttpServletResponse response,	BoardPropertyVO boardPropertyVO) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		boardPropertyVO.setTenantID(userInfo.getTenantId());
		
		ezBoardAdminService.saveBoardProperty(boardPropertyVO);
	}
	
	/**
	 * 게시판관리 게시판그룹이름변경 메뉴 확장컬럼 설정화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardExtensionAttribute.do")
	public String boardExtensionAttribute() throws Exception {
		return "admin/ezBoard/boardExtensionAttribute";
	}

	/**
	 * 게시판관리 게시판그룹이름변경 메뉴 확장컬럼 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getAttribute.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getAttribute(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, BoardAttributeVO boardAttributeVO) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		List<BoardAttributeVO> list = ezBoardAdminService.getBoardAttribute(boardAttributeVO.getBoardID(), userInfo.getTenantId());

		StringBuilder sb = new StringBuilder();
		sb.append("<ROWS>");

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

		return sb.toString();
	}

	/**
	 * 게시판관리 게시판그룹이름변경 메뉴 확장컬럼 헤더 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getBoardHeader.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getBoardHeader(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, BoardAttributeVO boardAttributeVO) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		List<BoardAttributeVO> list = ezBoardAdminService.getBoardHeader(boardAttributeVO.getColType(), boardAttributeVO.getBoardID(), userInfo.getTenantId());

		StringBuilder sb = new StringBuilder();
		sb.append("<ROWS>");

		if (list != null) {
			for (int i = 1; i < list.size(); i++) {
				BoardAttributeVO obj = list.get(i);
				sb.append("<ROW>");
				sb.append("<CELL><VALUE>" + obj.getColName1() + "</VALUE><DATA1>" + obj.getSn() + "</DATA1></CELL>");
				sb.append("<CELL><VALUE>" + obj.getColName2() + "</VALUE></CELL>");
				sb.append("<CELL><VALUE>" + obj.getValue() + "</VALUE></CELL>");
				sb.append("</ROW>");
			}
		}
		sb.append("</ROWS>");

		return sb.toString();
	}

	/**
	 * 게시판관리 게시판그룹이름변경 메뉴 확장컬럼 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveAttribute.do", produces = "text/xml;charset=utf-8")
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
	@RequestMapping(value = "/admin/ezBoard/saveHeader.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveHeader(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response, BoardListHeaderVO boardListHeaderVO) throws Exception {
		logger.debug("saveHeader started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		String rtnValue = ezBoardAdminService.saveHeader(doc, userInfo, boardListHeaderVO);;

		logger.debug("saveHeader ended");

		return rtnValue;
	}

	/**
	 * 게시판관리 게시판 권한설정 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardACL.do")
	public String boardACL(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String adminType = request.getParameter("adminType");
		String pBoardName = request.getParameter("boardName");
		String pType = request.getParameter("boardType");
		String pParentNeed = request.getParameter("parentNeed");
		String pAccessLevel = request.getParameter("accessLevel");
		String strUserLang = "";

		BoardPropertyVO boardProperty = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		String boardName = boardProperty.getBoardName();

		List<BoardPropertyVO> list = ezBoardAdminService.getBoardAccessList(boardID, userInfo.getTenantId());

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
				sb.append("</ROW>");
			}
		}
		sb.append("</DATA>");

		String result = sb.toString().replace("null", "");

		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("strUserLang", strUserLang);
		model.addAttribute("pBoardName", pBoardName);
		model.addAttribute("pType", pType);
		model.addAttribute("pParentNeed", pParentNeed);
		model.addAttribute("adminType", adminType);
		model.addAttribute("pAccessLevel", pAccessLevel);
		model.addAttribute("boardName", boardName);
		model.addAttribute("strList", result);

		return "admin/ezBoard/boardACL";
	}

	/**
	 * 게시판관리 게시판 권한 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getACL.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getACL(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
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

		return sb.toString();
	}

	/**
	 * 게시판관리 게시판 권한 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveACL.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveACL(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request,	HttpServletResponse response) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String rtnValue = "";
		try {
			Document doc = commonUtil.convertStringToDocument(data);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_TENANTID", userInfo.getTenantId());
			
			for (int i = 0; i < doc.getElementsByTagName("BOARDID").getLength(); i++) {
				String pAccessName2 = doc.getElementsByTagName("TARGETNAME2").item(i).getTextContent();
				String pAccess_FG = "";
				
				if (pAccessName2.equals("") || pAccessName2 == null) {
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
			}
			// save 서비스 구현
			ezBoardAdminService.saveACL(map);
			
			rtnValue = "OK";
		} catch (Exception e) {
			rtnValue = "ERROR";
			logger.error("EzBoardAdmin :: saveACL :: " + e.getMessage());
		}

		return rtnValue;
	}

	/**
	 * 게시판관리 게시판 권한 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/deleteACL.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String deleteACL(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String rtnValue = "";
		try {
			Document doc = commonUtil.convertStringToDocument(data);
			
			ezBoardAdminService.deleteACL(doc, userInfo.getTenantId());
			
			rtnValue = "OK";
		} catch (Exception e) {
			rtnValue = "ERROR";
			logger.error("EzBoardAdmin :: deleteACL :: " + e.getMessage());
		}
		
		return rtnValue;
	}

	/**
	 * 게시판관리 조직도 선택화면 호출 함수 1
	 */
	@RequestMapping(value = "/admin/ezBoard/selectTarget.do")
	public String selectTarget(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);
		String topid = "";

		if (user.getRollInfo().indexOf("c=1") == -1) {
			topid = user.getCompanyID();
		} else {
			topid = "Top";
		}

		model.addAttribute("strXML", "");
		model.addAttribute("topid", topid);
		model.addAttribute("userLang", "");
		model.addAttribute("deptID", user.getDeptID());

		return "admin/ezBoard/selectTarget";
	}
	
	/**
	 * 게시판관리 조직도 선택화면 호출 함수 2
	 */
	@RequestMapping(value = "/admin/ezBoard/selectTarget2.do")
	public String selectTarget2(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);
		String topid = "";

		if (user.getRollInfo().indexOf("c=1") == -1) {
			topid = user.getCompanyID();
		} else {
			topid = "Top";
		}

		model.addAttribute("strXML", "");
		model.addAttribute("topid", topid);
		model.addAttribute("userLang", "");
		model.addAttribute("deptID", user.getDeptID());

		return "admin/ezBoard/selectTarget2";
	}	

	/**
	 * 게시판관리 조직도에 검색 시 중복된 이름이 있을 경우 선택화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/checkName.do")
	public String checkName() throws Exception {
		return "admin/ezBoard/checkName";
	}

	/**
	 * 게시판관리 게시판 권한설정 권한전파 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardUnderGroupCopy.do")	
	public String boardUnderGroupCopy(HttpServletRequest request, Model model) throws Exception{
		String boardID = request.getParameter("boardID");		
		model.addAttribute("boardID", boardID);
		
		return "admin/ezBoard/boardUnderGroupCopy";
	}
	
	/**
	 * 게시판관리 게시판 권한설정 권한전파 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/setUnderBoardAcl.do")	
	public void setUnderBoardAcl(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String type = request.getParameter("type");
		
		List<BoardPropertyVO> list = ezBoardAdminService.getUnderBoardID("%"+boardID+"%", "2", userInfo.getTenantId());

		if (type.equals("1")) {
			List<BoardPropertyVO> list2 = ezBoardAdminService.getUnderBoardID("%"+boardID+"%", "1", userInfo.getTenantId());

			for (int i = 0; i < list.size(); i++) {
				BoardPropertyVO vo1 = list.get(i);
				
				for (int j = 0; j < list2.size(); j++) {
					BoardPropertyVO vo2 = list2.get(j);
					vo2.setBoardID(vo1.getBoardID());
					vo2.setTenantID(userInfo.getTenantId());
					
					ezBoardAdminService.setUnderBoardIDAcl(vo2);
				}				
			}			
		} else {			
			for (int i = 0; i < list.size(); i++) {
				BoardPropertyVO vo = list.get(i);
				ezBoardAdminService.setUnderBoardIDAcl2(boardID, vo.getBoardID(), vo.getParentBoardID(), userInfo.getTenantId());
			}
		}		
	}
	
	/**
	 * 게시판관리 게시판 권한설정 권한복사 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardAclList.do")	
	public String boardAclList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, LoginVO loginVO, Model model) throws Exception{				
		String parentBoardID = request.getParameter("parentBoardID");
		String boardID = request.getParameter("boardID");
		String serverName = request.getServerName();
		
        model.addAttribute("boardID", boardID);
        model.addAttribute("serverName", serverName);
        model.addAttribute("parentBoardID", parentBoardID);
		
		return "admin/ezBoard/boardAclList";
	}
	
	/**
	 * 게시판관리 게시판 권한설정 권한복사 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/copyBoardAcl.do", produces="text/html;charset=utf-8")
	@ResponseBody
	public String copyBoardAcl(@CookieValue("loginCookie") String loginCookie, @RequestBody String data) throws Exception {
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String rtnValue = "";
		
		Document doc = commonUtil.convertStringToDocument(data);
		
		rtnValue = ezBoardAdminService.copyBoardAcl(doc, userInfo.getTenantId());
		
		return rtnValue;
	}
	
	/**
	 * 게시판관리 선택한 게시판 게시물 표출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardConfig.do")
	public String boardConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String boardName = request.getParameter("boardName");		
		String boardType = request.getParameter("boardType");
		String parentBoardID = request.getParameter("parentBoardID");
		String tabID = (request.getParameter("tabID") == null ? "1tab1" : request.getParameter("tabID"));
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardName", commonUtil.cleanValue(boardName));
		model.addAttribute("boardType", boardType);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("tabID", tabID);		
		model.addAttribute("use_IE11Browser", ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId()));
		model.addAttribute("use_Editor", ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId()));
		
		return "admin/ezBoard/boardConfig";
	}
	
	/**
	 * 게시판관리 게시판 양식설정 화면[TAB] 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardFormSave.do")
	public String boardFormSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
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
		model.addAttribute("use_Editor", ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId()));
		
		return "admin/ezBoard/boardFormSave";
	}
	
	/**
	 * 게시판관리 게시판 양식설정 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveForm.do", produces="text/html;charset=utf-8")
	@ResponseBody
	public String saveForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String formContent = request.getParameter("formContent");
		String realPath = commonUtil.getRealPath(request);
		
		String formLocation = ezBoardAdminService.saveMHT(boardID, formContent, realPath, userInfo.getTenantId());		

		ezBoardAdminService.setBoardForm(boardID, formLocation, userInfo.getTenantId());
		
		return "OK";
	}
}

