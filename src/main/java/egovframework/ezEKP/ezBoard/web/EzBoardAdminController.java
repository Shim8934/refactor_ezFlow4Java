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

	@Autowired
	private EzBoardController ezBoardController;

	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;

	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;

	/**
	 * 게시판관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardMain.do")
	public String boardMain() throws Exception {
		return "admin/ezBoard/boardMain";
	}
	
	/**
	 * 게시판관리 왼쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardLeft.do")
	public String boardLeft(@CookieValue("loginCookie") String loginCookie,	HttpServletRequest request, Model model) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);
		String serverName = config.getProperty("config.ServerName");

		StringBuilder sb = new StringBuilder();
		String redirectBoardID = "";

		if (request.getParameter("BoardID") != null) {
			redirectBoardID = request.getParameter("BoardID");
			List<BoardVO> leftBoardList = ezBoardService.getLeft_BoardSTD(redirectBoardID);

			sb.append("<DATA>");
			for (int i = 0; i < leftBoardList.size(); i++) {
				sb.append("<ROW><BOARDGROUPID>");
				sb.append(leftBoardList.get(i).getBoardGroupId());
				sb.append("</BOARDGROUPID></ROW>");
			}
			sb.append("</DATA>");
		}
		model.addAttribute("redirectBoardID", redirectBoardID);
		model.addAttribute("redirectBoardGroupID", sb.toString());
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
	public String get_Admin_TopBoardList(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		String parentBoardID = request.getParameter("boardType");
		List<BoardTreeVO> list = ezBoardAdminService.get_Admin_TopBoardList(parentBoardID);

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
	public String boardGroupCreate(Model model) throws Exception {
		String lang = config.getProperty("config.primary");
		String use_multiData = config.getProperty("config.Use_MultiData");
		String lang_primary = config.getProperty("config.lang_Primary" + lang);
		String lang_secondary = config.getProperty("config.lang_Secondary" + lang);

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

		ezBoardAdminService.createBoardGroup(boardPropertyVO);
	}

	/**
	 * 게시판관리 하위게시판등록 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardCreate.do")
	public String boardCreate(HttpServletRequest request, Model model) throws Exception {
		String lang = config.getProperty("config.primary");
		String use_multiData = config.getProperty("config.Use_MultiData");
		String lang_primary = config.getProperty("config.lang_Primary" + lang);
		String lang_secondary = config.getProperty("config.lang_Secondary" + lang);
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String parentBoardName = "";

		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(parentBoardID);

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

		ezBoardAdminService.createBoard(boardPropertyVO);
	}

	/**
	 * 게시판관리 게시판순서조정 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardOrder.do")
	public String boardOrder(HttpServletRequest request, Model model) throws Exception {
		String parentBoardID = request.getParameter("parentBoardID");
		String boardID = request.getParameter("boardID");

		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID);

		model.addAttribute("upperBoardID", parentBoardID);
		model.addAttribute("boardName", boardPropertyVO.getBoardName());

		return "admin/ezBoard/boardOrder";
	}

	/**
	 * 게시판관리 게시판순서조정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveBoardOrder.do")
	public void saveBoardOrder(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String pBoardIDList = request.getParameter("boardList");

		ezBoardAdminService.saveBoardOrder(pBoardIDList);
		// board_treechache 테이블 trunk
		ezBoardAdminService.trunkBoard();
	}
	
	/**
	 * 게시판관리 게시판 서브트리 표출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getSubBoards.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getSubBoards(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);

		String upperBoardID = request.getParameter("upperBoardID");
		String boardTree = ezBoardController.getBoardTree(upperBoardID,	user.getId(), user.getDeptID(), user.getCompanyID(), 0, 1, 0, " ", "");

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

		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID);
		String boardTree = ezBoardController.getBoardTree(boardID, user.getId(), user.getDeptID(), user.getCompanyID(), 0, 1, 0, " ", "");

		if (boardTree.trim().equals("<NODES></NODES>")) {
			model.addAttribute("hasSubBoard", 0);
		} else {
			model.addAttribute("hasSubBoard", 1);
		}

		model.addAttribute("boardID", boardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("boardName", boardPropertyVO.getBoardName());

		return "admin/ezBoard/boardDelete";
	}

	/**
	 * 게시판관리 그룹 및 게시판삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/deleteBoard.do")
	public void deleteBoard(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String boardID = request.getParameter("boardID");

		ezBoardAdminService.deleteBoard(boardID);
		// board_treechache 테이블 trunk
		ezBoardAdminService.trunkBoard();
	}

	/**
	 * 게시판관리 배경이미지 관리 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardBackGround.do")
	public String boardBackGround() throws Exception {
		return "admin/ezBoard/boardBackGround";
	}

	/**
	 * 게시판관리 현재 배경이미지 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/getBackGroundImage.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getBackGroundImage(HttpServletResponse response, BoardBackgroundVO boardBackgroundVO) throws Exception {
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
				xmlStr.append("<REGDATE>" + list.get(i).getRegDate() + "</REGDATE>");
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
	public void statusChangeBackGroundImage(HttpServletRequest request,	HttpServletResponse response, BoardBackgroundVO boardBackgroundVO) throws Exception {
		String mode = request.getParameter("mode");
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
	public String selectBackGroundImage(BoardBackgroundVO boardBackgroundVO, Model model) throws Exception {
		String type = boardBackgroundVO.getType();

		if (type.equals("UPT")) {
			List<BoardBackgroundVO> list = ezBoardAdminService.getBackGroundImage(boardBackgroundVO);

			if (list.size() > 0) {
				String filePath = config.getProperty("upload_board.BOARDBACKGROUND");
				String fileName = ((BoardBackgroundVO) list.get(0)).getSaveFileName();

				model.addAttribute("width", boardBackgroundVO.getWidth());
				model.addAttribute("height", boardBackgroundVO.getHeight());
				model.addAttribute("backgroundID", boardBackgroundVO.getBackgroundID());
				model.addAttribute("filePath", filePath);
				model.addAttribute("fileName", fileName);
			}else{
				model.addAttribute("fileName", "");
			}
		}else{
			model.addAttribute("fileName", "");
		}
		model.addAttribute("type", type);

		return "admin/ezBoard/selectBackGroundImage";
	}

	/**
	 * 게시판관리 배경이미지 파일 업로드 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/uploadBackGroundImage.do")
	public void uploadBackGroundImage(MultipartHttpServletRequest request, HttpServletResponse response) throws Exception {
		MultipartFile file = request.getFile("file1");

		String fileType = file.getContentType().split("/")[1];
		String fileName = request.getParameter("guid") + "." + fileType;
		String filePath = config.getProperty("upload_board.TEMPUPLOADFILE");
		String realPath = request.getServletContext().getRealPath("");
		String realFullPath = realPath + filePath + File.separator + "S_" + fileName;

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

		}
	}

	/**
	 * 게시판관리 배경이미지 정보 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveBackGroundImage.do")
	public void saveBackGroundImage(@CookieValue("loginCookie") String loginCookie,	HttpServletResponse response, MultipartHttpServletRequest request, BoardBackgroundVO boardBackgroundVO) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);
		boardBackgroundVO.setRegUserID(user.getId());

		MultipartFile file = request.getFile("file1");

		if (file != null) {
			String fileName = boardBackgroundVO.getSaveFileName();
			String filePath = config.getProperty("upload_board.BOARDBACKGROUND");
			String tempFilePath = config.getProperty("upload_board.TEMPUPLOADFILE");
			String realPath = request.getServletContext().getRealPath("");

			writeUploadedFile(file, "S_" + fileName, realPath + filePath);

			try {
				File tempFile = new File(realPath + tempFilePath + File.separator + "S_" + fileName);

				if (tempFile != null) {
					tempFile.delete();
				}

				boardBackgroundVO.setOrgFileName(file.getOriginalFilename());
				boardBackgroundVO.setSaveFileName(fileName);
			} catch (Exception e) {

			}
		}

		ezBoardAdminService.saveBackGroundImage(boardBackgroundVO);
	}

	/**
	 * 게시판관리 배경이미지 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/deleteBackGroundImage.do")
	public void deleteBackGroundImage(HttpServletRequest request, HttpServletResponse response, BoardBackgroundVO boardBackgroundVO) throws Exception {
		String fileName = boardBackgroundVO.getSaveFileName();
		String filePath = config.getProperty("upload_board.BOARDBACKGROUND");
		String realPath = request.getServletContext().getRealPath("");

		try {
			File tempFile = new File(realPath + filePath + File.separator +"S_" + fileName);

			if (tempFile != null) {
				tempFile.delete();
			}
			ezBoardAdminService.deleteBackGroundImage(boardBackgroundVO);

		} catch (Exception e) {

		}
	}

	/**
	 * 게시판관리 게시판이동 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardMove.do")
	public String boardMove(HttpServletRequest request, Model model) throws Exception {
		String boardID = request.getParameter("boardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String hasSubBoard = "";

		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID);

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
	public String boardMoveSelect(Model model) throws Exception {
		String serverName = config.getProperty("config.ServerName");
		model.addAttribute("serverName", serverName);

		return "admin/ezBoard/boardMoveSelect";
	}

	/**
	 * 게시판관리 게시판 이동 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/moveBoard.do")
	public void moveBoard(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String orgBoardID = request.getParameter("orgBoardID");
		String newParentBoardID = request.getParameter("newParentBoardID");
		String newBoardGroupID = request.getParameter("newBoardGroupID");

		ezBoardAdminService.moveBoard(orgBoardID, newParentBoardID,	newBoardGroupID);
		// board_treechache 테이블 trunk
		ezBoardAdminService.trunkBoard();
	}

	/**
	 * 게시판관리 게시판그룹이름변경 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardProperty.do")
	public String boardProperty(HttpServletRequest request,	HttpServletResponse response, Model model) throws Exception {
		String lang = config.getProperty("config.primary");
		String use_multiData = config.getProperty("config.Use_MultiData");
		String lang_primary = config.getProperty("config.lang_Primary" + lang);
		String lang_secondary = config.getProperty("config.lang_Secondary" + lang);
		String use_portal = config.getProperty("config.Use_Portal");
		String boardID = request.getParameter("boardID");
		String adminType = request.getParameter("adminType");
		String style = "";

		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID);

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
	public void saveBoardProperty(HttpServletResponse response,	BoardPropertyVO boardPropertyVO) throws Exception {
		String boardID = boardPropertyVO.getBoardID();
		ezBoardAdminService.saveBoardProperty(boardPropertyVO);		
		
		if(boardPropertyVO.getPortlet() != null){
			if(boardPropertyVO.getPortlet().equals("Y")){
				ezBoardAdminService.saveBoardProperty_port(boardID);
			}
		}
		
		if(boardPropertyVO.getApprFlag() != null){			
			
			if(boardPropertyVO.getApprFlag().equals("Y")){
				String[] flag = boardPropertyVO.getApprUserList().split(";");				
				
				for(int i=0; i < flag.length; i++){
					String apprUserID = flag[i];
					String pMode = "DEL";
					
					if(i != 0){
						pMode = "";
					}					
					ezBoardAdminService.saveBoardProperty_appr(boardID, apprUserID, pMode);
				}
				
				if(boardPropertyVO.getOrgApprFlag() != null){
					if(!boardPropertyVO.getApprFlag().equals(boardPropertyVO.getOrgApprFlag())){
						ezBoardAdminService.apprProperty_info(boardID, "Y");
					}
				}
			}else{
				String pMode = "DEL";				
				ezBoardAdminService.saveBoardProperty_appr(boardID, "", pMode);
				
				if(boardPropertyVO.getOrgApprFlag() != null){
					if(!boardPropertyVO.getApprFlag().equals(boardPropertyVO.getOrgApprFlag())){
						ezBoardAdminService.apprProperty_info(boardID, "N");
					}
				}
			}
		}		
		// board_treechache 테이블 trunk
		ezBoardAdminService.trunkBoard();
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
	public String getAttribute(HttpServletRequest request, HttpServletResponse response, BoardAttributeVO boardAttributeVO) throws Exception {
		List<BoardAttributeVO> list = ezBoardAdminService.getBoardAttribute(boardAttributeVO.getBoardID());

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
				sb.append("<CELL><VALUE>" + obj.getValue() + "</VALUE></CELL>");
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
	public String getBoardHeader(HttpServletRequest request, HttpServletResponse response, BoardAttributeVO boardAttributeVO) throws Exception {
		List<BoardAttributeVO> list = ezBoardAdminService.getBoardHeader(boardAttributeVO.getColType(), boardAttributeVO.getBoardID());

		StringBuilder sb = new StringBuilder();
		sb.append("<ROWS>");

		if (list != null) {
			for (int i = 0; i < list.size(); i++) {
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
	public String saveAttribute(@RequestBody String data, HttpServletRequest request, HttpServletResponse response,	BoardAttributeVO boardAttributeVO) throws Exception {
		Document doc = commonUtil.convertStringToDocument(data);

		String boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
		ezBoardAdminService.deleteAttribute(boardID);

		int colSize = doc.getElementsByTagName("COLNAME1").getLength();
		String attributeYN = "N";
		boardAttributeVO.setBoardID(boardID);

		for (int i = 0; i < colSize; i++) {
			boardAttributeVO.setTableCol(doc.getElementsByTagName("TABLECOL").item(i).getTextContent());
			boardAttributeVO.setSn(i + "");
			boardAttributeVO.setColName1(doc.getElementsByTagName("COLNAME1").item(i).getTextContent());
			boardAttributeVO.setColName2(doc.getElementsByTagName("COLNAME2").item(i).getTextContent());
			boardAttributeVO.setValue(doc.getElementsByTagName("VALUE").item(i).getTextContent());
			boardAttributeVO.setColType(doc.getElementsByTagName("COLTYPE").item(i).getTextContent());
			boardAttributeVO.setMust(doc.getElementsByTagName("MUST").item(i).getTextContent());

			ezBoardAdminService.saveAttribute(boardAttributeVO);
		}

		if (colSize > 0) {
			attributeYN = "Y";
		}

		boardAttributeVO.setValue(attributeYN);

		ezBoardAdminService.updateAttribute(boardAttributeVO);

		return "OK";
	}

	/**
	 * 게시판관리 게시판그룹이름변경 메뉴의 확장컬럼헤더 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveHeader.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveHeader(@RequestBody String data, HttpServletRequest request, HttpServletResponse response, BoardListHeaderVO boardListHeaderVO) throws Exception {
		Document doc = commonUtil.convertStringToDocument(data);

		String boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
		ezBoardAdminService.deleteHeader(boardID);

		int colSize = doc.getElementsByTagName("NAME1").getLength();
		boardListHeaderVO.setBoardID(boardID);

		for (int i = 0; i < colSize; i++) {
			boardListHeaderVO.setSn(i + "");
			boardListHeaderVO.setName1(doc.getElementsByTagName("NAME1").item(i).getTextContent());
			boardListHeaderVO.setName2(doc.getElementsByTagName("NAME2").item(i).getTextContent());
			boardListHeaderVO.setName3(doc.getElementsByTagName("NAME1").item(i).getTextContent());
			boardListHeaderVO.setName4(doc.getElementsByTagName("NAME2").item(i).getTextContent());
			boardListHeaderVO.setColName(doc.getElementsByTagName("COLNAME").item(i).getTextContent());
			boardListHeaderVO.setWidth(doc.getElementsByTagName("WIDTH").item(i).getTextContent());
			boardListHeaderVO.setName("Y");

			ezBoardAdminService.saveHeader(boardListHeaderVO);
		}

		return "OK";
	}

	/**
	 * 게시판관리 게시판 권한설정 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardACL.do")
	public String boardACL(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String adminType = request.getParameter("adminType");
		String pBoardName = request.getParameter("boardName");
		String pType = request.getParameter("boardType");
		String pParentNeed = request.getParameter("parentNeed");
		String pAccessLevel = request.getParameter("accessLevel");
		String strUserLang = "";

		BoardPropertyVO boardProperty = ezBoardService.getBoardProperty(boardID);
		String boardName = boardProperty.getBoardName();

		List<BoardPropertyVO> list = ezBoardAdminService.getBoardAccessList(boardID);

		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");

		if (list != null) {
			for (int i = 0; i < list.size(); i++) {
				BoardPropertyVO obj = list.get(i);
				sb.append("<ROW>");
				sb.append("<COMPANY>" + obj.getLoginVO().getCompanyName1() + "</COMPANY>");
				sb.append("<DESCRIPTION>" + obj.getLoginVO().getDeptName1() + "</DESCRIPTION>");
				sb.append("<DISPLAYNAME>" + obj.getLoginVO().getDisplayName1() + "</DISPLAYNAME>");
				sb.append("<TITLE>" + obj.getLoginVO().getTitle1() + "</TITLE>");
				sb.append("<COMPANY2>" + obj.getLoginVO().getCompanyName2() + "</COMPANY2>");
				sb.append("<DESCRIPTION2>" + obj.getLoginVO().getDeptName2() + "</DESCRIPTION2>");
				sb.append("<DISPLAYNAME2>" + obj.getLoginVO().getDisplayName2()	+ "</DISPLAYNAME2>");
				sb.append("<TITLE2>" + obj.getLoginVO().getTitle2()	+ "</TITLE2>");
				sb.append("<ACCESSID>" + obj.getAccessID() + "</ACCESSID>");
				sb.append("<ACCESSNAME>" + obj.getAccessName() + "</ACCESSNAME>");
				sb.append("<ACCESSNAME2>" + obj.getAccessName2() + "</ACCESSNAME2>");
				sb.append("<BOARDGROUPACL>" + obj.getBoardGroupACL() + "</BOARDGROUPACL>");
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
	public String getACL(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String boardID = request.getParameter("boardID");
		String accessID = request.getParameter("accessID");

		BoardPropertyVO boardProperty = ezBoardAdminService.getACL(boardID, accessID);

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
	public String saveACL(@RequestBody String data, HttpServletRequest request,	HttpServletResponse response) throws Exception {
		Document doc = commonUtil.convertStringToDocument(data);
		Map<String, Object> map = new HashMap<String, Object>();

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
		// board_treechache 테이블 trunk
		ezBoardAdminService.trunkBoard();

		return "OK";
	}

	/**
	 * 게시판관리 게시판 권한 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/deleteACL.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String deleteACL(@RequestBody String data, HttpServletRequest request, HttpServletResponse response)	throws Exception {
		Document doc = commonUtil.convertStringToDocument(data);

		for (int i = 0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
			ezBoardAdminService.deleteACL(doc.getElementsByTagName("BOARDID").item(i).getTextContent(),	doc.getElementsByTagName("TARGETID").item(i).getTextContent());
		}
		// board_treechache 테이블 trunk
		ezBoardAdminService.trunkBoard();

		return "OK";
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

		model.addAttribute("defaultwin", "To");
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

		model.addAttribute("defaultwin", "To");
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
	public void setUnderBoardAcl(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		String boardID = request.getParameter("boardID");
		String type = request.getParameter("type");
		
		List<BoardPropertyVO> list = ezBoardAdminService.getUnderBoardID("%"+boardID+"%", "2");

		if(type.equals("1")){
			List<BoardPropertyVO> list2 = ezBoardAdminService.getUnderBoardID("%"+boardID+"%", "1");

			for(int i = 0; i < list.size(); i++){
				BoardPropertyVO vo1 = list.get(i);
				
				for(int j = 0; j < list2.size(); j++){
					BoardPropertyVO vo2 = list2.get(j);
					vo2.setBoardID(vo1.getBoardID());
					
					ezBoardAdminService.setUnderBoardIDAcl(vo2);
				}				
			}			
		}else{			
			for(int i = 0; i < list.size(); i++){
				BoardPropertyVO vo = list.get(i);
				ezBoardAdminService.setUnderBoardIDAcl2(boardID, vo.getBoardID(), vo.getParentBoardID());
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
		String serverName = config.getProperty("config.ServerName");
		/*
		 * 2016-03-31 장진혁 현재 사용되지 않아서 주석처리
		String strLang = config.getProperty("config.primary");
		String use_editor = config.getProperty("config.EDITOR");
		String use_ie11Browser = config.getProperty("config.IE11EDITOR");
		String pRootBoardID = "top";
		String pExcludeBoardID = " ";
        String pSubFlag = "0";
        
        int pSelectBy = 0;
        int pMode = 0;        
        
		loginVO = commonUtil.userInfo(loginCookie);
		String pUserID = loginVO.getId();
		String pDeptID = loginVO.getDeptID();
		String pCompanyID = loginVO.getCompanyID();
		String pRollInfo = loginVO.getRollInfo();
        
        String BoardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pRootBoardID, pUserID, pDeptID, pCompanyID);
        
        if (BoardGroupAdmin_FG == "OK" || pRollInfo.toLowerCase().indexOf("c=1") > -1 || pRollInfo.toLowerCase().indexOf("c=1") > -1 || pRollInfo.toLowerCase().indexOf("k=1") > -1 || pRollInfo.toLowerCase().indexOf("n=1") > -1){
            pMode = 0;
        }else{
            pMode = 1;
        }
        
        String resultXML = ezBoardController.getBoardTree(pRootBoardID, pUserID, pDeptID, pCompanyID, pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, commonUtil.getMultiData(strLang));
        */
        
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
	public String copyBoardAcl(@RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
		Document doc = commonUtil.convertStringToDocument(data);
		
		for(int i=0; i < doc.getElementsByTagName("BOARDID").getLength(); i++){
			String boardID = doc.getElementsByTagName("BOARDID").item(i).getTextContent();
			String defaultBoardID = doc.getElementsByTagName("DEFAULTBOARDID").item(i).getTextContent();
			String parentBoardID = doc.getElementsByTagName("PARENTBOARDID").item(i).getTextContent();
			
			ezBoardAdminService.copyBoardAcl(boardID, defaultBoardID, parentBoardID);
		}
		
		return "OK";
	}
	
	/**
	 * 게시판관리 선택한 게시판 게시물 표출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardConfig.do")
	public String boardConfig(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		String boardID = request.getParameter("boardID");
		String boardName = request.getParameter("boardName");		
		String boardType = request.getParameter("boardType");
		String parentBoardID = request.getParameter("parentBoardID");
		String tabID = (request.getParameter("tabID") == null ? "1tab1" : request.getParameter("tabID"));
System.out.println(boardName);
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardName", boardName);
		model.addAttribute("boardType", boardType);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("tabID", tabID);		
		model.addAttribute("use_IE11Browser", config.getProperty("config.IE11EDITOR"));
		model.addAttribute("use_Editor", config.getProperty("config.EDITOR"));
		
		return "admin/ezBoard/boardConfig";
	}
	
	/**
	 * 게시판관리 게시판 양식설정 화면[TAB] 호출 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/boardFormSave.do")
	public String boardFormSave(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		String boardID = request.getParameter("boardID");
		String checkForm = "";
		
		int cnt = ezBoardAdminService.checkForm(boardID, "A");
		
		if(cnt > 0){
			checkForm = "TRUE";
		}else{
			checkForm = "FALSE";
		}		
		model.addAttribute("boardID", boardID);
		model.addAttribute("checkForm", checkForm);
		model.addAttribute("use_Editor", config.getProperty("config.EDITOR"));
		
		return "admin/ezBoard/boardFormSave";
	}
	
	/**
	 * 게시판관리 게시판 양식설정 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezBoard/saveForm.do", produces="text/html;charset=utf-8")
	@ResponseBody
	public String saveForm(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{		
		String boardID = request.getParameter("boardID");
		String formContent = request.getParameter("formContent");
		String realPath = request.getServletContext().getRealPath("");
		
		String formLocation = ezBoardAdminService.saveMHT(boardID, formContent, realPath);		

		ezBoardAdminService.setBoardForm(boardID, formLocation);
		
		return "OK";
	}
}

