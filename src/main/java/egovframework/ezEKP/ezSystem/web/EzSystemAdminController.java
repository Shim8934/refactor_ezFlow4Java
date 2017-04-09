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

import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezStatistics.web.EzStatisticsMailMainController;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzSystemAdminController {

	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsMailMainController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;
	
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
    
	@RequestMapping(value="/admin/ezSystem/systemMain.do")
	public String systemMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		return "/ezSystem/systemMain";
	}
	
	@RequestMapping(value="/admin/ezSystem/systemLeftMenu.do")
	public String systemLeftMenu(Model model) throws Exception {
		
		return "/ezSystem/systemLeftMenu";
	}
	
	@RequestMapping(value="/admin/ezSystem/systemMainMenu.do")
	public String systemMainMenu(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("systemMainMenu started");
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("tenantID=" + userInfo.getTenantId());
		
		Map<String, String> configMap = new HashMap<String, String>();
		List<SysParamVO> configList = ezSystemAdminService.getSysParam(userInfo.getTenantId());
		int licensedUserCount = 0;
		
		for (SysParamVO param : configList) {
			configMap.put(param.getName(), param.getValue());
			
			if (param.getName().equals("LicenseKey")) {
				String licenseKey = param.getValue();
				
				if (licenseKey != null && !licenseKey.equals("")) {
					try {
						// 라이센스키를 복호화한다.
						licenseKey = egovFileScrty.decryptAES(licenseKey);
						
						String items[] = licenseKey.split(":");
						
						if (items.length == 2) {
							licensedUserCount = Integer.parseInt(items[1]);
						}						
					} catch (Exception e) {
					}					
				}
			}
		}
		
		int userCount = ezOrganAdminService.getUserCount(userInfo.getTenantId());
		
		// masteradmin 사용자를 제외하기 위해 1을 뺀다.
		userCount--;
		
		model.addAttribute("configMap", configMap);
		model.addAttribute("licensedUserCount", licensedUserCount);
		model.addAttribute("userCount", userCount);
		
		logger.debug("systemMainMenu ended");
		
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
