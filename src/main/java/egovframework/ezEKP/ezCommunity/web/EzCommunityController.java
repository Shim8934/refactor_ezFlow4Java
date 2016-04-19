package egovframework.ezEKP.ezCommunity.web;

import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCommunityController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="EzCommunityService")
	private EzCommunityService ezCommunityService;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@RequestMapping(value="/ezCommunity/communityMain.do")
	public String  main(){
		
		return "/ezCommunity/communityMain";
	}
	
	@RequestMapping(value = "/ezCommunity/communityLeftCommunity.do")
	public String communityLeftCommunity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap model) throws Exception{
		String userId = "", companyID = "";
		String communityCD = "", userInfoUserID = "";
		String code = "", codeName = "", userLevel = "";
		int permit = 0, confirmType = 0, newMemberConfirmtype = 0;
		String pRootBoardID = "top";
		String pSubFlag = "0";
		int pSelectBy = 0;
		String pExcludeBoardID = "";
        boolean checkSysop = false;
        boolean joinFlag = false;
        Document xmlret;
        Document xmlcop;
        
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
            userLevel = request.getParameter("UserLevel");
        }else{
            userLevel = "";
        }
        userInfoUserID = loginVO.getId();
        userId = loginVO.getId();
        companyID = loginVO.getCompanyID();
        
        if(code.equals("")){
        	String vPermit = ezCommunityService.leftCommunityGet1(code, userInfoUserID);
        	
        	if(vPermit==null){
        		userLevel = "0";
        	}else{
        		userLevel = vPermit;
        		joinFlag = true;
        	}
        	
        	String clubConfirmType = ezCommunityService.leftCommunityGet2(code);
        	if(clubConfirmType != null){
        		newMemberConfirmtype = Integer.parseInt(clubConfirmType);
        	}
        	
        	//쓰는데 없는거같음
        	/*//dll
        	String boardGroupAdminFG = ezCommunityService.checkIfBoardGroupAdmin(pRootBoardID, loginVO.getId(), loginVO.getDeptID(), loginVO.getCompanyID());
        	
        	int pMode = 0;
        	
        	if(boardGroupAdminFG.equals("OK") || loginVO.getRollInfo().toLowerCase().indexOf("c=1") > -1 || loginVO.getRollInfo().toLowerCase().indexOf("k=1") > -1 || loginVO.getRollInfo().toLowerCase().indexOf("t=1") > -1){
        		pMode = 0;
        	}else{
        		pMode = 1;
        	}
        	//dll
        	String retXML = ezCommunityService.getBoardTree(pRootBoardID, loginVO.getId(), loginVO.getDeptID(), loginVO.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, code, commonUtil.getMultiData(loginVO.getLang()));
        	
        	if(retXML.substring(0, 5).toUpperCase().equals("ERROR")){
        		xmlret = commonUtil.convertStringToDocument(retXML);
        	}else{
        		xmlret = commonUtil.convertStringToDocument("<RESULT>ERROR</RESULT>");
        	}*/
        	

        	if(userInfoUserID.equals(ezCommunityService.leftCommunityGet4(code))){
        		checkSysop = true;
        	}
        	
        }        

        /*String rtnVal = commonUtil.getQueryResult(ezCommunityService.leftCommunityGet3(userId));
		xmlcop = commonUtil.convertStringToDocument(rtnVal);*/
		
		
		model.addAttribute("code",code);
		model.addAttribute("codeName",codeName);
		model.addAttribute("UserLevel",userLevel);
		model.addAttribute("newmember_confirmtype",newMemberConfirmtype);
		model.addAttribute("ch_CommunityAdmin",loginVO.getRollInfo().indexOf("t=1"));
		model.addAttribute("CheckSysop",checkSysop);
		model.addAttribute("lang",loginVO.getLang());
		model.addAttribute("userId", userId);
		model.addAttribute("UserInfo_UserID",userInfoUserID);
		
		return "/ezCommunity/communityLeftCommunity";
	}

	@RequestMapping(value = "/ezCommunity/GetLeftCommunity.do", method = RequestMethod.POST, produces = "TEXT/XML;CHARSET=UTF-8")
	@ResponseBody
	public String getLeftCommunity(@CookieValue("loginCookie")String loginCookie) throws Exception{
		String userId = "";
        StringBuilder sb = new StringBuilder();
        
        LoginVO loginVO = commonUtil.userInfo(loginCookie);
        
        userId = loginVO.getId();
        
        List<CommunityLeftCommunityVO> leftCommunityList =ezCommunityService.leftCommunityGet3(userId);
        
        sb.append("<DATA>");
        for(CommunityLeftCommunityVO leftCommunity : leftCommunityList){
        	sb.append(commonUtil.getQueryResult(leftCommunity));
        }
        sb.append("</DATA>");
        
        return sb.toString();
	}
	
	@RequestMapping(value = "/ezCommunity/GetLeftBoardList.do", method = RequestMethod.POST, produces = "TEXT/XML;CHARSET=UTF-8")
	@ResponseBody
	public String getLeftBoardList(@CookieValue("loginCookie")String loginCookie) throws Exception{
		StringBuilder sb = new StringBuilder();
		
		List<CommunityCBoardVO> leftBoardList= ezCommunityService.getLeftBoardList();
		sb.append("<DATA>");
		for(CommunityCBoardVO leftBoard : leftBoardList){
			sb.append(commonUtil.getQueryResult(leftBoard));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}
	
	@RequestMapping(value = "/ezCommunity/commMake.do")
	public String commMake(@CookieValue("loginCookie")String loginCookie, Locale locale, ModelMap model, HttpServletRequest request) throws Exception{
		String userInfoUserID = "", userInfoDisplayName = "";
		String langPrimary="", langSecondary="";
		String flag = "";
		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		if(request.getParameter("flag") != null){
			flag = request.getParameter("flag");
		}
		
		userInfoUserID = loginVO.getId();
		langPrimary = config.getProperty("config.lang_Primary"+loginVO.getLang());
		langSecondary = config.getProperty("config.lang_Secondary"+loginVO.getLang());

		if(loginVO.getLang().equals("2")){
			userInfoDisplayName = loginVO.getDisplayName2();
		}else{
			userInfoDisplayName = loginVO.getDisplayName1();
		}
		
System.out.println(getCategory("", "", "", locale));

		model.addAttribute("lang_Primary", langPrimary);
		model.addAttribute("lang_Secondary", langSecondary);
		model.addAttribute("UserInfo_UserID", userInfoUserID);
		model.addAttribute("UserInfo_DisplayName", userInfoDisplayName);
		model.addAttribute("flag", flag);		
		model.addAttribute("idSpanValue", getCategory("", "", "", locale));
		return "/ezCommunity/communityCommMake";
	}
	
	private String getCategory(String strSelCateA, String strSelCateB, String strSelCateC, Locale locale) throws Exception{
		StringBuilder strHTML = new StringBuilder();
		
		strHTML.append("<Select name=\"c_cate_a\">");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t80", locale) + "</Option>");
		strHTML.append(ezCommunityService.getCategoryValueA(strSelCateA, locale));
		strHTML.append("</Select>");
		strHTML.append("<Select name=\"c_cate_b\" class=\"text\">");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t81", locale) + "</Option>");
		strHTML.append(ezCommunityService.getCategoryValueB(strSelCateB, locale));
		strHTML.append("</Select>");
		strHTML.append("<Select name=\"c_cate_c\" class=\"text\" style='display:none'>");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t82", locale) + "</Option>");
		strHTML.append(ezCommunityService.getCategoryValueC(strSelCateC, locale));
		strHTML.append("</Select>");
		
		return strHTML.toString();
	}
}
