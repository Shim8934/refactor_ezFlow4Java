package egovframework.ezEKP.ezBoard.web;

import java.net.URLDecoder;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzBoardAdminController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;

	@Resource(name="EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name="EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@RequestMapping(value="/admin/ezBoard/boardMain.do")
	public String boardMain(HttpServletRequest request, Model model) throws Exception{		
		return "admin/ezBoard/boardMain";
	}
	
	@RequestMapping(value="/admin/ezBoard/boardLeft.do")
	public String boardLeft(@CookieValue("userID") String userID, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception{	
		LoginVO user = commonUtil.userInfo(userID);
		String serverName = config.getProperty("config.ServerName");
		
		/*
		String redirectBoardGroupID = "";
		String redirectBoardID = "";
		
		if(request.getParameter("BoardID") != null){			
			redirectBoardID  = request.getParameter("BoardID");			
			List<EzBoardVO> leftBoardList = ezBoardService.getLeft_BoardSTD(redirectBoardID);
			
			for(int i=0; i< leftBoardList.size(); i++){
				redirectBoardGroupID += leftBoardList.get(i).getBoardGroupId();
				
				if(i != leftBoardList.size()-1){
					redirectBoardGroupID += ",";
				}
			}			
		}
		model.addAttribute("redirectBoardID", redirectBoardID);
		model.addAttribute("redirectBoardGroupID", redirectBoardGroupID); */
		model.addAttribute("user", user);
		model.addAttribute("serverName", serverName);
		
		return "admin/ezBoard/boardLeft";
	}
	
	@RequestMapping(value="/admin/ezBoard/boardRight.do")
	public String boardRight(HttpServletRequest request, Model model) throws Exception{		
		return "admin/ezBoard/boardRight";
	}	
	
	@RequestMapping(value="/admin/ezBoard/get_Admin_TopBoardList.do")
	public String get_Admin_TopBoardList(HttpServletRequest request, Model model) throws Exception{		
		String parentBoardID = request.getParameter("boardType");
		List<BoardTreeVO> list = ezBoardAdminService.get_Admin_TopBoardList(parentBoardID);

		model.addAttribute("topBoardList", list);
		return "json";
	}
	
	@RequestMapping(value="/admin/ezBoard/boardGroupCreate.do")
	public String boardGroupCreate(HttpServletRequest request, Model model) throws Exception{
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
	public void createBoardGroup(@CookieValue("userID") String userID, HttpServletRequest request, HttpServletResponse response, BoardPropertyVO boardPropertyVO) throws Exception{
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
	public void createBoard(@CookieValue("userID") String userID, HttpServletRequest request, HttpServletResponse response, BoardPropertyVO boardPropertyVO) throws Exception{
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
	
}
