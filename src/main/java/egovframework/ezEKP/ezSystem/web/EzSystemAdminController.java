package egovframework.ezEKP.ezSystem.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezStatistics.web.EzStatisticsMailMainController;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzSystemAdminController {

	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsMailMainController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;
	
	@RequestMapping(value="/admin/ezSystem/systemMain.do")
	public String statisticsPersonalMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		return "/ezSystem/systemMain";
	}
	
	@RequestMapping(value="/admin/ezSystem/systemLeftMenu.do")
	public String statisticsLeftMenu(Model model) throws Exception {
		
		return "/ezSystem/systemLeftMenu";
	}
	
	@RequestMapping(value="/admin/ezSystem/systemMainMenu.do")
	public String systemMainMenu(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		Map<String, String> configMap = new HashMap<String, String>();
		List<SysParamVO> configList = ezSystemAdminService.getSysParam(userInfo.getTenantId());
		
		for (SysParamVO param : configList) {
			configMap.put(param.getName(), param.getValue());
		}
		
		model.addAttribute("configMap", configMap);
		
		return "/ezSystem/systemMainMenu";
	}
		
	@RequestMapping(value="/admin/ezSystem/updateSysParam.do", produces="application/json;charset=utf-8")
	@ResponseBody
	public String updateSysParam(@CookieValue("loginCookie") String loginCookie, Model model, @RequestBody List<Map<String, String>> list) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "{\"msg\":\"fail\"}";
		}
		
		try {
			ezSystemAdminService.updateSysParam(userInfo.getTenantId(), list, userInfo.getLocale());
		} catch (Exception e) {
			return "{\"msg\":\"fail\"}";			
		}
		
		return "{\"msg\":\"success\"}";		
	}
}
