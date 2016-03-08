package egovframework.ezEKP.ezBoard.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URLDecoder;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardBackgroundVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzBoardAdminController extends EgovFileMngUtil{
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzBoardController ezBoardController;	

	@Resource(name="EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name="EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@RequestMapping(value="/admin/ezBoard/boardMain.do")
	public String boardMain() throws Exception{		
		return "admin/ezBoard/boardMain";
	}
	
	@RequestMapping(value="/admin/ezBoard/boardLeft.do")
	public String boardLeft(@CookieValue("userID") String userID, HttpServletRequest request, Model model) throws Exception{	
		LoginVO user = commonUtil.userInfo(userID);
		String serverName = config.getProperty("config.ServerName");
		
		StringBuilder sb = new StringBuilder();
		String redirectBoardID = "";
	
		if(request.getParameter("BoardID") != null){			
			redirectBoardID  = request.getParameter("BoardID");			
			List<EzBoardVO> leftBoardList = ezBoardService.getLeft_BoardSTD(redirectBoardID);
			
			sb.append("<DATA>");
			for(int i=0; i< leftBoardList.size(); i++){
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
	
	@RequestMapping(value="/admin/ezBoard/boardRight.do")
	public String boardRight() throws Exception{		
		return "admin/ezBoard/boardRight";
	}	
	
	@RequestMapping(value="/admin/ezBoard/get_Admin_TopBoardList.do")
	public String get_Admin_TopBoardList(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{		
		String parentBoardID = request.getParameter("boardType");
		List<BoardTreeVO> list = ezBoardAdminService.get_Admin_TopBoardList(parentBoardID);

		model.addAttribute("topBoardList", list);
		return "json";
	}
	
	@RequestMapping(value="/admin/ezBoard/boardGroupCreate.do")
	public String boardGroupCreate(Model model) throws Exception{
		String lang = config.getProperty("config.primary");
		String use_multiData = config.getProperty("config.Use_MultiData");
		String lang_primary = config.getProperty("config.lang_Primary" + lang);
		String lang_secondary = config.getProperty("config.lang_Secondary" + lang);

		model.addAttribute("use_multiData", use_multiData);
		model.addAttribute("lang_primary", lang_primary);
		model.addAttribute("lang_secondary", lang_secondary);
		
		return "admin/ezBoard/boardGroupCreate";
	}
	
	@RequestMapping(value="/admin/ezBoard/createBoardGroup.do")
	public void createBoardGroup(@CookieValue("userID") String userID, HttpServletResponse response, BoardPropertyVO boardPropertyVO) throws Exception{
		LoginVO user = commonUtil.userInfo(userID);
		String groupName1 = URLDecoder.decode(boardPropertyVO.getBoardGroupName(),"utf-8");
		String groupName2 = URLDecoder.decode(boardPropertyVO.getBoardGroupName2(),"utf-8");
		String accessName1 = user.getDeptName1() + "(" + user.getCompanyName1() + ", " + user.getDeptName1() + ")";
		String accessName2 = user.getDeptName2() + "(" + user.getCompanyName2() + ", " + user.getDeptName2() + ")";
		String uID = user.getId();
		
		boardPropertyVO.setBoardGroupName(groupName1);
		boardPropertyVO.setBoardGroupName2(groupName2);
		boardPropertyVO.setAccessID(uID);
		boardPropertyVO.setAccessName(accessName1);
		boardPropertyVO.setAccessName2(accessName2);
		
		ezBoardAdminService.createBoardGroup(boardPropertyVO);		
	}
	
	@RequestMapping(value="/admin/ezBoard/boardCreate.do")
	public String boardCreate(HttpServletRequest request, Model model) throws Exception{		
		String lang = config.getProperty("config.primary");
		String use_multiData = config.getProperty("config.Use_MultiData");
		String lang_primary = config.getProperty("config.lang_Primary" + lang);
		String lang_secondary = config.getProperty("config.lang_Secondary" + lang);
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String parentBoardName = "";
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(parentBoardID);

		if (lang == "2" && !boardPropertyVO.getBoardName2().equals("")){
			parentBoardName = boardPropertyVO.getBoardName2();
        }else{
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
	
	@RequestMapping(value="/admin/ezBoard/createBoard.do")
	public void createBoard(@CookieValue("userID") String userID, HttpServletResponse response, BoardPropertyVO boardPropertyVO) throws Exception{
		LoginVO user = commonUtil.userInfo(userID);
		
		String boardName1 = URLDecoder.decode(boardPropertyVO.getBoardName(),"utf-8");
		String boardName2 = URLDecoder.decode(boardPropertyVO.getBoardName2(),"utf-8");
		String accessName1 = user.getDeptName1() + "(" + user.getCompanyName1() + ", " + user.getDeptName1() + ")";
		String accessName2 = user.getDeptName2() + "(" + user.getCompanyName2() + ", " + user.getDeptName2() + ")";
		String uID = user.getId();
		
		boardPropertyVO.setBoardName(boardName1);
		boardPropertyVO.setBoardName2(boardName2);
		boardPropertyVO.setAccessID(uID);
		boardPropertyVO.setAccessName(accessName1);
		boardPropertyVO.setAccessName2(accessName2);
		
		ezBoardAdminService.createBoard(boardPropertyVO);
	}
	
	@RequestMapping(value="/admin/ezBoard/boardOrder.do")
	public String boardOrder(HttpServletRequest request, Model model) throws Exception{
		String parentBoardID = request.getParameter("parentBoardID");
		String boardID = request.getParameter("boardID");		
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID);
		
		model.addAttribute("upperBoardID", parentBoardID);
		model.addAttribute("boardName", boardPropertyVO.getBoardName());
		
		return "admin/ezBoard/boardOrder";
	}
	
	@RequestMapping(value="/admin/ezBoard/saveBoardOrder.do")
	public void saveBoardOrder(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String pBoardIDList = request.getParameter("boardList");

		ezBoardAdminService.saveBoardOrder(pBoardIDList);				
	}
	
	@RequestMapping(value="/admin/ezBoard/getSubBoards.do")
	public void getSubBoards(@CookieValue("userID") String userID, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LoginVO user = commonUtil.userInfo(userID);
		
		String upperBoardID = request.getParameter("upperBoardID");		
		String boardTree = ezBoardController.getBoardTree(upperBoardID, user.getId(), user.getDeptID(), user.getCompanyID(), 0, 1, 0, " ", "");

		response.setCharacterEncoding("UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		response.getWriter().write(boardTree);		
	}
	
	@RequestMapping(value="/admin/ezBoard/boardDelete.do")
	public String boardDelete(@CookieValue("userID") String userID, HttpServletRequest request, Model model) throws Exception{
		LoginVO user = commonUtil.userInfo(userID);
		
		String boardID = request.getParameter("boardID");
		String boardGroupID = request.getParameter("boardGroupID");
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID);
		String boardTree = ezBoardController.getBoardTree(boardID, user.getId(), user.getDeptID(), user.getCompanyID(), 0, 1, 0, " ", "");

		if(boardTree.trim().equals("<NODES></NODES>")){
			model.addAttribute("hasSubBoard", 0);
		}else{
			model.addAttribute("hasSubBoard", 1);
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("boardName", boardPropertyVO.getBoardName());
		
		return "admin/ezBoard/boardDelete";
	}
	
	@RequestMapping(value="/admin/ezBoard/deleteBoard.do")
	public void deleteBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String boardID = request.getParameter("boardID");
		
		ezBoardAdminService.deleteBoard(boardID);
	}
	
	@RequestMapping(value="/admin/ezBoard/boardBackGround.do")
	public String boardBackGround() throws Exception{		
		return "admin/ezBoard/boardBackGround";
	}
	
	@RequestMapping(value="/admin/ezBoard/getBackGroundImage.do")
	public void getBackGroundImage(HttpServletResponse response, BoardBackgroundVO boardBackgroundVO) throws Exception{		
		List<BoardBackgroundVO> list = ezBoardAdminService.getBackGroundImage(boardBackgroundVO);
		
		StringBuffer xmlStr = new StringBuffer();
		
		if(list.size() > 0 ) {        	
        	xmlStr.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");        	
        	xmlStr.append("<DATA>");
        	
        	for(int i=0; i < list.size(); i++) {        		
	        	xmlStr.append("<ROW>");
	        	xmlStr.append("<BACKGROUNDID>"+list.get(i).getBackgroundID()+"</BACKGROUNDID>");
	        	xmlStr.append("<ORGFILENAME>"+list.get(i).getOrgFileName()+"</ORGFILENAME>");    	
	        	xmlStr.append("<SAVEFILENAME>"+list.get(i).getSaveFileName()+"</SAVEFILENAME>");
	        	xmlStr.append("<REGUSERID>"+list.get(i).getRegUserID()+"</REGUSERID>");
	        	xmlStr.append("<REGDATE>"+list.get(i).getRegDate()+"</REGDATE>");
	        	xmlStr.append("<ISUSE>"+list.get(i).getIsUse()+"</ISUSE>");
	        	xmlStr.append("<SN>"+list.get(i).getSn()+"</SN>");
	        	xmlStr.append("<WIDTH>"+list.get(i).getWidth()+"</WIDTH>");
	        	xmlStr.append("<HEIGHT>"+list.get(i).getHeight()+"</HEIGHT>");
	        	xmlStr.append("</ROW>");
        	}     
        	
        	xmlStr.append("</DATA>");        	
        	
        	response.setContentType("text/xml"); 
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-cache");
            response.getWriter().write(xmlStr.toString());
        }		
	}
	
	@RequestMapping(value="/admin/ezBoard/statusChangeBackGroundImage.do")
	public void statusChangeBackGroundImage(HttpServletRequest request, HttpServletResponse response, BoardBackgroundVO boardBackgroundVO) throws Exception{
		String mode = request.getParameter("mode");
		boardBackgroundVO.setType(mode);
		
		if(mode.equals("U")){			
			ezBoardAdminService.statusChangeBackGroundImage(boardBackgroundVO);
		}else{
			String[] bIDs = boardBackgroundVO.getBackgroundID().split("/");
			String[] isUses = boardBackgroundVO.getIsUse().split("/");			
			
			for(int i=0; i< bIDs.length; i++){
				boardBackgroundVO.setBackgroundID(bIDs[i]);
				boardBackgroundVO.setIsUse(isUses[i]);	
				
				ezBoardAdminService.statusChangeBackGroundImage(boardBackgroundVO);
			}			
		}
	}
	
	@RequestMapping(value="/admin/ezBoard/selectBackGroundImage.do")
	public String selectBackGroundImage(BoardBackgroundVO boardBackgroundVO, Model model) throws Exception{
		String type = boardBackgroundVO.getType();
	
		if(type.equals("UPT")){
			List<BoardBackgroundVO> list = ezBoardAdminService.getBackGroundImage(boardBackgroundVO);
			
			if(list.size() > 0){
				String filePath = config.getProperty("upload_board.BOARDBACKGROUND");
				String fileName = ((BoardBackgroundVO)list.get(0)).getSaveFileName();			
				
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
	
	@RequestMapping(value="/admin/ezBoard/uploadBackGroundImage.do")
	public void uploadBackGroundImage(MultipartHttpServletRequest request, HttpServletResponse response) throws Exception{		
		MultipartFile file = request.getFile("file1");
		
		String fileType = file.getContentType().split("/")[1];
		String fileName = request.getParameter("guid") +"."+ fileType;		
		String filePath = config.getProperty("upload_board.TEMPUPLOADFILE");
		String realPath = request.getServletContext().getRealPath("");
		String realFullPath = realPath + filePath + "/S_" + fileName;
		
		int width = 0;
		int height = 0;
		
		writeUploadedFile(file, "S_"+fileName, realPath + filePath);
		
		try{
			File imageFile = new File(realFullPath);			
		
			if(imageFile.exists()){			
				BufferedImage bi = ImageIO.read(new File(realFullPath));			    
				width = bi.getWidth();
				height = bi.getHeight();
				
				response.getWriter().write(filePath + "," + fileName + "," + width + "/" + height);
			}
		}catch(Exception e){
			
		}		
	}
	
	@RequestMapping(value="/admin/ezBoard/saveBackGroundImage.do")
	public void saveBackGroundImage(@CookieValue("userID") String userID, HttpServletResponse response, MultipartHttpServletRequest request, BoardBackgroundVO boardBackgroundVO) throws Exception{		
		LoginVO user = commonUtil.userInfo(userID);
		boardBackgroundVO.setRegUserID(user.getId());
			
		MultipartFile file = request.getFile("file1");

		if(file != null){			
			String fileName = boardBackgroundVO.getSaveFileName();		
			String filePath = config.getProperty("upload_board.BOARDBACKGROUND");
			String tempFilePath = config.getProperty("upload_board.TEMPUPLOADFILE");
			String realPath = request.getServletContext().getRealPath("");
						
			writeUploadedFile(file, "S_"+fileName, realPath + filePath);
			
			try{
				File tempFile = new File(realPath + tempFilePath + "/S_" + fileName);
				
				if(tempFile != null){
					tempFile.delete();
				}
				
				boardBackgroundVO.setOrgFileName(file.getOriginalFilename());
				boardBackgroundVO.setSaveFileName(fileName);				
			}catch(Exception e){
				
			}			
		}
        
        ezBoardAdminService.saveBackGroundImage(boardBackgroundVO);	
	}
	
	@RequestMapping(value="/admin/ezBoard/deleteBackGroundImage.do")
	public void deleteBackGroundImage(HttpServletRequest request, HttpServletResponse response, BoardBackgroundVO boardBackgroundVO) throws Exception{		
		String fileName = boardBackgroundVO.getSaveFileName();
		String filePath = config.getProperty("upload_board.BOARDBACKGROUND");
		String realPath = request.getServletContext().getRealPath("");		
		
		try{
			File tempFile = new File(realPath + filePath + "/S_" + fileName);
			
			if(tempFile != null){
				tempFile.delete();
			}			
			ezBoardAdminService.deleteBackGroundImage(boardBackgroundVO);
			
		}catch(Exception e){
			
		}		
	}
	
	@RequestMapping(value="/admin/ezBoard/boardMove.do")
	public String boardMove(HttpServletRequest request, Model model) throws Exception{		
		String boardID = request.getParameter("boardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String hasSubBoard = "";
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID);
		
		if(boardID.equals(boardGroupID)){
			hasSubBoard = "1";
		}else{
			hasSubBoard = "0";
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("boardName", boardPropertyVO.getBoardName());
		model.addAttribute("hasSubBoard", hasSubBoard);
		
		return "admin/ezBoard/boardMove";
	}
	
	@RequestMapping(value="/admin/ezBoard/boardMoveSelect.do")
	public String boardMoveSelect(Model model) throws Exception{
		String serverName = config.getProperty("config.ServerName");
		model.addAttribute("serverName",serverName);
		
		return "admin/ezBoard/boardMoveSelect";
	}
	
	@RequestMapping(value="/admin/ezBoard/moveBoard.do")
	public void moveBoard(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{		
		String orgBoardID = request.getParameter("orgBoardID");
		String newParentBoardID = request.getParameter("newParentBoardID");
		String newBoardGroupID = request.getParameter("newBoardGroupID");
		
		ezBoardAdminService.moveBoard(orgBoardID, newParentBoardID, newBoardGroupID);
	}	
	
}
