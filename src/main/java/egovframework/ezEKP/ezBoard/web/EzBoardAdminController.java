package egovframework.ezEKP.ezBoard.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;

import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzBoardAdminController {
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;

	@Resource(name="EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name="EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@RequestMapping(value="/ezBoardAdmin/left_boardSTD.do")
	public String left_boardSTD_admin(@CookieValue("userID") String userID, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception{
		
		String id = egovFileScrty.getUserID(userID);		
		
		loginVO.setId(id);
		loginVO.setPassword("LOGIN");		
		LoginVO user = loginService.selectUser(loginVO);
		
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
		
		return "admin/ezBoard/left_boardStd";
	}
	
	@RequestMapping(value="/ezBoardAdmin/get_Admin_TopBoardList.do")
	public void get_Admin_TopBoardList(HttpServletRequest request, Model model, LoginVO loginVO) throws Exception{		
				
		
	}
	
}
