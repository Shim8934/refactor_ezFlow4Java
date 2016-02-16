package egovframework.ezEKP.ezBoard.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzBoardAdminController {
	
	@Autowired
	private CommonUtil commonUtil;	

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
		
		return "admin/ezBoard/boardLeft";
	}
	
	@RequestMapping(value="/admin/ezBoard/get_Admin_TopBoardList.do")
	public String get_Admin_TopBoardList(HttpServletRequest request, Model model) throws Exception{		
		String parentBoardID = request.getParameter("boardType");
		List<BoardTreeVO> list = ezBoardAdminService.get_Admin_TopBoardList(parentBoardID);

		model.addAttribute("topBoardList", list);
		return "json";
	}
	
}
