package egovframework.ezEKP.ezBoard.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
		logger.debug("boardLeft started");

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
		
		logger.debug("boardLeft ended");
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
		logger.debug("get_Admin_TopBoardList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String parentBoardID = request.getParameter("boardType");
		String rollInfo = userInfo.getRollInfo(); // 전체관리자 권한 확인용
		boolean isCompanyAdmin = false;
		
		if (rollInfo != null && rollInfo.toLowerCase().indexOf("c=1") > -1) {
			isCompanyAdmin = true;
		}
		
		/* 2018-06-25 홍승비 - 게시판 > 관리자 > 좌측 게시판리스트(그룹) 표출 시 companyID 조건 추가 */
		List<BoardTreeVO> list = ezBoardAdminService.get_Admin_TopBoardList(parentBoardID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getCompanyID(), userInfo.getTenantId(), isCompanyAdmin);
		
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
	@RequestMapping(value = "/admin/ezBoard/boardGroupCreate.do")
	public String boardGroupCreate(Model model, @CookieValue("loginCookie") String loginCookie,	LoginVO userInfo) throws Exception {
		logger.debug("boardGroupCreate started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String lang = userInfo.getLang();
		String use_multiData = ezCommonService.getTenantConfig("Use_MultiData", userInfo.getTenantId());
		String lang_primary = ezCommonService.getTenantConfig("LangPrimary" + lang, userInfo.getTenantId());
		String lang_secondary = ezCommonService.getTenantConfig("LangSecondary" + lang, userInfo.getTenantId());
		String rollInfo = userInfo.getRollInfo();
		
		/* 2018-10-15 홍승비 - 관리자단 게시판그룹생성 진입 시 전체관리자 여부 확인 */
		if (rollInfo != null && rollInfo.toLowerCase().indexOf("c=1") > -1) {
			model.addAttribute("isCompanyAdmin", true);
		}
		model.addAttribute("use_multiData", use_multiData);
		model.addAttribute("lang_primary", lang_primary);
		model.addAttribute("lang_secondary", lang_secondary);

		logger.debug("boardGroupCreate ended");
		return "admin/ezBoard/boardGroupCreate";
	}

	/**
	 * 게시판관리 게시판그룹생성 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/createBoardGroup.do")
	public void createBoardGroup(@CookieValue("loginCookie") String loginCookie, HttpServletResponse response, BoardPropertyVO boardPropertyVO)	throws Exception {
		logger.debug("createBoardGroup started");

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
		boardPropertyVO.setCompanyID(user.getCompanyID());
		boardPropertyVO.setTenantID(user.getTenantId());
		boardPropertyVO.setLoginVO(user);

		logger.debug("createBoardGroup ended");
		
		ezBoardAdminService.createBoardGroup(boardPropertyVO);
	}

	/**
	 * 게시판관리 하위게시판등록 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardCreate.do")
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
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(parentBoardID, userInfo.getTenantId());
		
		if (lang.equals("2") && !boardPropertyVO.getBoardName2().equals("")) {
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

		logger.debug("boardCreate ended");
		return "admin/ezBoard/boardCreate";
	}

	/**
	 * 게시판관리 하위게시판등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/createBoard.do")
	public void createBoard(@CookieValue("loginCookie") String loginCookie,	HttpServletResponse response, BoardPropertyVO boardPropertyVO) throws Exception {
		logger.debug("createBoard started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String boardName1 = URLDecoder.decode(boardPropertyVO.getBoardName(), "utf-8");
		String boardName2 = URLDecoder.decode(boardPropertyVO.getBoardName2(), "utf-8");
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
		boardPropertyVO.setAccessID(uID);
		boardPropertyVO.setAccessName(accessName1);
		boardPropertyVO.setAccessName2(accessName2);
		boardPropertyVO.setCompanyID(user.getCompanyID());
		boardPropertyVO.setTenantID(user.getTenantId());
		
		ezBoardAdminService.createBoard(boardPropertyVO);

		logger.debug("createBoard ended");
	}

	/**
	 * 게시판관리 게시판순서조정 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardOrder.do")
	public String boardOrder(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardOrder started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String parentBoardID = request.getParameter("parentBoardID");
		String boardID = request.getParameter("boardID");
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		model.addAttribute("upperBoardID", parentBoardID);
		model.addAttribute("boardName", boardPropertyVO.getBoardName());

		logger.debug("boardOrder ended");
		return "admin/ezBoard/boardOrder";
	}

	/**
	 * 게시판관리 게시판순서조정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveBoardOrder.do")
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
	@RequestMapping(value = "/admin/ezBoard/getSubBoards.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getSubBoards(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getSubBoards started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		String upperBoardID = request.getParameter("upperBoardID");
		String isAdminLeft = "Y";
		boolean isCompanyAdmin = false;
		
		/* 2018-10-16 홍승비 - 전체관리자 플래그 추가 */
		if (user.getRollInfo() != null && user.getRollInfo().toLowerCase().indexOf("c=1") > -1) {
			isCompanyAdmin = true;
		}
		
		// 자신의 회사에 속한 게시판만 표출하도록 compamyID 조건 추가
		String boardTree = ezBoardService.getBoardTree(upperBoardID, user.getId(), user.getDeptID(), user.getCompanyID(), 0, 1, 0, " ", "", isAdminLeft, isCompanyAdmin, user.getTenantId());

		logger.debug("getSubBoards ended");
		return boardTree;
	}

	/**
	 * 게시판관리 그룹 및 게시판삭제 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardDelete.do")
	public String boardDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardDelete started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String isAdminLeft = "Y";
		boolean isCompanyAdmin = false;
		/* 2018-10-16 홍승비 - 전체관리자 플래그 추가 */
		if (user.getRollInfo() != null && user.getRollInfo().toLowerCase().indexOf("c=1") > -1) {
			isCompanyAdmin = true;
		}
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, user.getTenantId());
		
		String boardTree = ezBoardService.getBoardTree(boardID, user.getId(), user.getDeptID(), user.getCompanyID(), 0, 1, 0, " ", "", isAdminLeft, isCompanyAdmin, user.getTenantId());
		if (boardTree.trim().equals("<NODES></NODES>")) {
			model.addAttribute("hasSubBoard", 0);
		} else {
			model.addAttribute("hasSubBoard", 1);
		}
		
		if (boardPropertyVO == null) {
			logger.debug("boardDelete ended");
			return "admin/ezBoard/boardRight";
		} else {
			model.addAttribute("boardID", boardID);
			model.addAttribute("boardGroupID", boardGroupID);
			model.addAttribute("boardName", boardPropertyVO.getBoardName());
			
			logger.debug("boardDelete ended");
			return "admin/ezBoard/boardDelete";
		}
	}

	/**
	 * 게시판관리 그룹 및 게시판삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/deleteBoard.do")
	public void deleteBoard(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("deleteBoard started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		
		ezBoardAdminService.deleteBoard(boardID, userInfo.getTenantId());

		logger.debug("deleteBoard ended");
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
		logger.debug("getBackGroundImage started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boardBackgroundVO.setCompanyID(userInfo.getCompanyID());
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
	@RequestMapping(value = "/admin/ezBoard/statusChangeBackGroundImage.do")
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
	@RequestMapping(value = "/admin/ezBoard/selectBackGroundImage.do")
	public String selectBackGroundImage(BoardBackgroundVO boardBackgroundVO, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("selectBackGroundImage started");

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

		logger.debug("selectBackGroundImage ended");
		return "admin/ezBoard/selectBackGroundImage";
	}

	/**
	 * 게시판관리 배경이미지 파일 업로드 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/uploadBackGroundImage.do")
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

		logger.debug("uploadBackGroundImage ended");
	}

	/**
	 * 게시판관리 배경이미지 정보 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveBackGroundImage.do")
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
		
		/* 2018-06-26 홍승비 - 배경이미지 저장 시  companyID 삽입 */
		ezBoardAdminService.saveBackGroundImage(boardBackgroundVO);

		logger.debug("saveBackGroundImage ended");
	}

	/**
	 * 게시판관리 배경이미지 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/deleteBackGroundImage.do")
	public void deleteBackGroundImage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, BoardBackgroundVO boardBackgroundVO) throws Exception {
		logger.debug("deleteBackGroundImage started");

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

		logger.debug("deleteBackGroundImage ended");
	}

	/**
	 * 게시판관리 게시판이동 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardMove.do")
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
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("boardName", boardPropertyVO.getBoardName());
		model.addAttribute("hasSubBoard", hasSubBoard);

		logger.debug("boardMove ended");
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
		if (newBoardGroupProp.getBoardGroupID() != null) {
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
		
		if (isAllGroupBoardORG.equals(isAllGroupBoardNEW)) {
			ezBoardAdminService.moveBoard(orgBoardID, newParentBoardID,	newBoardGroupID, userInfo.getTenantId());
		}
		else {
			response.sendError(500);
		}

		logger.debug("moveBoard ended");
	}

	/**
	 * 게시판관리 게시판그룹이름변경 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardProperty.do")
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
		
		/* 2018-07-12 홍승비 - 모든 URL게시판은 임시 구분값(실제로는 0, 임시로 6)을 가지도록 수정 */
		if (boardPropertyVO.getUrl() != null && !(boardPropertyVO.getUrl().trim().equals(""))) {
			boardPropertyVO.setGuBun("6");
		}
		
		/* 2018-11-15 홍승비 - 그룹사게시판 여부 판별하여 값을 전달 */
		if (boardPropertyVO.getParentBoardID() != null && !boardPropertyVO.getParentBoardID().equals("top")) {
			BoardPropertyVO parentProp = ezBoardService.getBoardProperty(boardPropertyVO.getParentBoardID(), userInfo.getTenantId());
			if (parentProp.getGuBun() != null && parentProp.getGuBun().equals("99")) {
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

		logger.debug("boardProperty ended");
		return "admin/ezBoard/boardProperty";
	}

	/**
	 * 게시판관리 게시판그룹이름변경 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveBoardProperty.do")
	public void saveBoardProperty(@CookieValue("loginCookie") String loginCookie, HttpServletResponse response,	BoardPropertyVO boardPropertyVO) throws Exception {
		logger.debug("saveBoardProperty started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		boardPropertyVO.setTenantID(userInfo.getTenantId());
		
		ezBoardAdminService.saveBoardProperty(boardPropertyVO);

		logger.debug("saveBoardProperty ended");
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
		logger.debug("getAttribute started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		List<BoardAttributeVO> list = ezBoardAdminService.getBoardAttribute(boardAttributeVO.getBoardID(), userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();
		sb.append("<ROWS>");
		
		if (list != null) {
			for (int i = 0; i < list.size(); i++) {
				BoardAttributeVO obj = list.get(i);
				sb.append("<ROW>");
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(obj.getColName1()) + "</VALUE><DATA1>" + obj.getTableCol() + "</DATA1></CELL>");
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(obj.getColName2()) + "</VALUE></CELL>");
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
	@RequestMapping(value = "/admin/ezBoard/getBoardHeader.do", produces = "text/xml;charset=utf-8")
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
				
				if (userInfo.getLang().equals("1")) {
					sb.append("<CELL><VALUE>" + commonUtil.cleanValue(obj.getColName1()) + "</VALUE><DATA1>" + obj.getSn() + "</DATA1></CELL>");
				} else if (userInfo.getLang().equals("2")) {
					sb.append("<CELL><VALUE>" + commonUtil.cleanValue(obj.getColName2()) + "</VALUE><DATA1>" + obj.getSn() + "</DATA1></CELL>");
				} else if (userInfo.getLang().equals("3")) {
					sb.append("<CELL><VALUE>" + commonUtil.cleanValue(obj.getColName3()) + "</VALUE><DATA1>" + obj.getSn() + "</DATA1></CELL>");
				} else if (userInfo.getLang().equals("4")) {
					sb.append("<CELL><VALUE>" + commonUtil.cleanValue(obj.getColName4()) + "</VALUE><DATA1>" + obj.getSn() + "</DATA1></CELL>");
				}
				
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(obj.getColName2()) + "</VALUE></CELL>");
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
		String rtnValue = ezBoardAdminService.saveHeader(doc, userInfo, boardListHeaderVO);

		logger.debug("saveHeader ended");

		return rtnValue;
	}

	/**
	 * 게시판관리 게시판 권한설정 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardACL.do")
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
		
		String boardName = boardProperty.getBoardName();
		
		/* 게시판 권한설정 시 companyID 조건 추가, 겸직한 사원의 경우 해당 겸직정보를 표출함 + 다국어 대응하도록 정보 가져옴 */
		List<BoardPropertyVO> list = ezBoardAdminService.getBoardAccessList(boardID, userInfo.getCompanyID(), userInfo.getTenantId());
		
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
		model.addAttribute("primary", primary);
		model.addAttribute("pBoardName", pBoardName);
		model.addAttribute("pType", pType);
		model.addAttribute("pParentNeed", pParentNeed);
		model.addAttribute("adminType", adminType);
		model.addAttribute("pAccessLevel", pAccessLevel);
		model.addAttribute("boardName", boardName);
		model.addAttribute("strList", result);
		model.addAttribute("isAllGroupBoard", isAllGroupBoard);

		logger.debug("boardACL ended");
		return "admin/ezBoard/boardACL";
	}

	/**
	 * 게시판관리 게시판 권한 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getACL.do", produces = "text/xml;charset=utf-8")
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
	@RequestMapping(value = "/admin/ezBoard/saveACL.do", produces = "text/xml;charset=utf-8")
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
	@RequestMapping(value = "/admin/ezBoard/deleteACL.do", produces = "text/xml;charset=utf-8")
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
	@RequestMapping(value = "/admin/ezBoard/selectTarget.do")
	public String selectTarget(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("selectTarget started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String topid = "";
		
		if (user.getRollInfo().indexOf("c=1") == -1) {
			topid = user.getCompanyID();
		} else {
			topid = "Top";
		}
		
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
	@RequestMapping(value = "/admin/ezBoard/selectTarget2.do")
	public String selectTarget2(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("selectTarget2 started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String topid = "";
		String deptTreeTopId = "";
		String isAllGroupBoard = "";
		
		if(request.getParameter("isAllGroupBoard") != null) {
			isAllGroupBoard = request.getParameter("isAllGroupBoard");
		}
		
		if (user.getRollInfo().indexOf("c=1") == -1) {
			topid = user.getCompanyID();
			deptTreeTopId = topid;
		} else {
			topid = "Top";
			// 전체관리자이면서 그룹사게시판인 경우, 전체 조직도 표출
			if (isAllGroupBoard != null && isAllGroupBoard.equals("Y")) {
				deptTreeTopId = topid + "/organ";
			}
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
	@RequestMapping(value = "/admin/ezBoard/checkName.do")
	public String checkName() throws Exception {
		return "admin/ezBoard/checkName";
	}

	/**
	 * 게시판관리 게시판 권한설정 권한전파 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardUnderGroupCopy.do")	
	public String boardUnderGroupCopy(HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardUnderGroupCopy started");

		String boardID = request.getParameter("boardID");
		
		model.addAttribute("boardID", boardID);

		logger.debug("boardUnderGroupCopy ended");
		return "admin/ezBoard/boardUnderGroupCopy";
	}
	
	/**
	 * 게시판관리 게시판 권한설정 권한전파 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/setUnderBoardAcl.do")	
	public void setUnderBoardAcl(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("setUnderBoardAcl started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");		
		String type = request.getParameter("type");
		
		// 권한전파 시 companyID 추가
		List<BoardPropertyVO> list = ezBoardAdminService.getUnderBoardID("%"+boardID+"%", "2", userInfo.getTenantId());
		
		if (type.equals("1")) { // 권한 복사(type 1)
			List<BoardPropertyVO> list2 = ezBoardAdminService.getUnderBoardID("%"+boardID+"%", "1", userInfo.getTenantId());
			
			for (int i = 0; i < list.size(); i++) {
				BoardPropertyVO vo1 = list.get(i);
				
				for (int j = 0; j < list2.size(); j++) {
					BoardPropertyVO vo2 = list2.get(j); 
					
					vo2.setBoardID(vo1.getBoardID());
					vo2.setCompanyID(userInfo.getCompanyID());
					vo2.setTenantID(userInfo.getTenantId());
					
					ezBoardAdminService.setUnderBoardIDAcl(vo2);
				}				
			}			
		} else { // 기존권한 삭제 후 복사(type 2)
			for (int i = 0; i < list.size(); i++) {
				BoardPropertyVO vo = list.get(i);
				
				/* 2018-06-26 홍승비 - 권한전파 시 companyID 삽입 추가 */
				ezBoardAdminService.setUnderBoardIDAcl2(boardID, vo.getBoardID(), vo.getParentBoardID(), userInfo.getCompanyID(), userInfo.getTenantId());
			}
		}		

		logger.debug("setUnderBoardAcl ended");
	}
	
	/**
	 * 게시판관리 게시판 권한설정 권한복사 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardAclList.do")	
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
	@RequestMapping(value = "/admin/ezBoard/copyBoardAcl.do", produces="text/html;charset=utf-8")
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
	@RequestMapping(value = "/admin/ezBoard/boardConfig.do")
	public String boardConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("boardConfig started");

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
		model.addAttribute("use_Editor", ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId()));

		logger.debug("boardConfig ended");
		return "admin/ezBoard/boardConfig";
	}
	
	/**
	 * 게시판관리 게시판 양식설정 화면[TAB] 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardFormSave.do")
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
		model.addAttribute("use_Editor", ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId()));

		logger.debug("boardFormSave ended");
		return "admin/ezBoard/boardFormSave";
	}
	
	/**
	 * 게시판관리 게시판 양식설정 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveForm.do", produces="text/html;charset=utf-8")
	@ResponseBody
	public String saveForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("saveForm started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String formContent = request.getParameter("formContent");
		String realPath = commonUtil.getRealPath(request);
		
		String formLocation = ezBoardAdminService.saveMHT(boardID, formContent, realPath, userInfo.getTenantId());		
		
		ezBoardAdminService.setBoardForm(boardID, formLocation, userInfo.getTenantId());

		logger.debug("saveForm ended");
		return "OK";
	}
}