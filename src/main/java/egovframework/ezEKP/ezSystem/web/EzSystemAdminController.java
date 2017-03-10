package egovframework.ezEKP.ezSystem.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezStatistics.web.EzStatisticsMailMainController;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzSystemAdminController {

private static final Logger logger = LoggerFactory.getLogger(EzStatisticsMailMainController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	
	@RequestMapping(value="/admin/Ezsystem/systemMain.do")
	public String statisticsPersonalMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		return "/ezSystem/systemMain";
	}
	
	@RequestMapping(value="/admin/Ezsystem/systemLeftMenu.do")
	public String statisticsLeftMenu(Model model) throws Exception {
		
		return "/ezSystem/systemLeftMenu";
	}
	
	@RequestMapping(value="/admin/Ezsystem/systemMainMenu.do")
	public String systemMainMenu(Model model) throws Exception {
		
		return "/ezSystem/systemMainMenu";
	}
}
