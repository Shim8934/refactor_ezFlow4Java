package egovframework.ezEKP.ezCommunity.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCommunityController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzCommunityService")
	private EzCommunityService ezCommunityService;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@RequestMapping(value="/ezCommunity/communityMain.do")
	public String  main(){
		
		return "/ezCommunity/communityMain";
	}
	
	@RequestMapping(value ="/ezCommunity/communityLeftCommunity.do")
	public String communityLeftCommunity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request){
		String userId = "", companyID = "";
		String communityCD = "", UserInfo_UserID = "";
		String code = "", codeName = "", UserLevel = "";
		int permit = 0, confirmtype = 0, newmember_confirmtype = 0;
		String pRootBoardID = "top";
		String pSubFlag = "0";
		int pSelectBy = 0;
		String pExcludeBoardID = "";
        boolean CheckSysop = false;
        boolean JoinFlag = false;
        
        LoginVO loginVO = commonUtil.userInfo(loginCookie);
        
        if (request.getParameter("communityCD") != null){
            code = request.getParameter("communityCD");
        }else{
            code = "";
        }
        if (request.getParameter("communityName") != null){
            codeName = request.getParameter("communityName");
        }else{
            codeName = "";
        }
        if (request.getParameter("UserLevel") != null){
            UserLevel = request.getParameter("UserLevel");
        }else{
            UserLevel = "";
        }
        UserInfo_UserID = loginVO.getId();
        userId = loginVO.getId();
        companyID = loginVO.getCompanyID();
        
        if(code.equals("")){
        	/*EZSP_LEFT_COMMUNITY_GET1*/
        	
        }
		
		return "/ezCommunity/communityLeftCommunity";
	}
	
	@RequestMapping(value ="/ezCommunity/GetLeftCommunity.do")
	public void getLeftCommunity(){
		
	}
}
