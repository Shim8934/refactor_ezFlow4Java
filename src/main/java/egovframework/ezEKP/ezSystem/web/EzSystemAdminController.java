package egovframework.ezEKP.ezSystem.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezStatistics.web.EzStatisticsMailMainController;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.util.EzSystemUtil;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.FileSysInfoVO;
import egovframework.ezEKP.ezSystem.vo.SysMonitorVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzSystemAdminController {

	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsMailMainController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCommonService ezCommonService;
	
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
						
						if (items.length >= 2) {
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
	
	//**/ 로그인 로그기록
	@RequestMapping(value="/admin/ezSystem/systemLoginHist.do")
	public String systemLoginHist(@CookieValue("loginCookie") String loginCookie)throws Exception {
		
		logger.debug("started systemLoginHistMain controller.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("ended systemLoginHistMain controller.");
		
		return "/ezSystem/systemLoginHist";
		
	}
	
	
	@RequestMapping(value="/admin/ezSystem/systemLoginHistList.do")
	public String systemLoginHistList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req,
			@RequestParam(required=false)String searchKeycode, @RequestParam(required=false)String searchKeyword,
			@RequestParam(required=false)String startDate, @RequestParam(required=false)String endDate) throws Exception {
		
		logger.debug("started systemLoginHistList controller.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String offset = userInfo.getOffset();
		String currPage = req.getParameter("GotoPage");
		
		if (currPage == null || currPage.equals("")) {
			currPage = "1";
		}
		
		int maxItemPerPage = 20; 
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;
		int currentPage = Integer.parseInt(currPage);
		
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if ( userInfo.getLang().equals(sysLang))  {
			sysLang = userInfo.getLang();
		}
		
		List<ConnectionInfoVO> loginHistList = ezSystemAdminService.getLoginHist(Integer.valueOf(userInfo.getTenantId()), 
				commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode, searchKeyword, sysLang, startDate, endDate);
		
		int itemCnt = ezSystemAdminService.getLoginHistCount(userInfo.getTenantId(), commonUtil.getMinuteUTC(offset), searchKeycode, searchKeyword, sysLang, startDate, endDate);
		int totalPage = itemCnt / maxItemPerPage ;
		
		if ((totalPage * maxItemPerPage) != itemCnt && (itemCnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1 ;
		}
		
		currentPage = Math.min(currentPage, totalPage);	
		
		model.addAttribute("loginHistList", loginHistList); 
		model.addAttribute("lang", sysLang);
		model.addAttribute("currPage", currentPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("itemCnt", itemCnt);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchKeycode", searchKeycode);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		logger.debug("ended systemLoginHistList controller."  );
		
		return "json";
	}
	
	/** 
	 * 관리자->시스템 모니터링
	 */
	@RequestMapping(value="/admin/ezSystem/sysMonitor.do")
	public String sysMonitor(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("systemStatus started");
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		SysMonitorVO serverList = new SysMonitorVO();
		serverList.setOsName(System.getProperty("os.name"));
		serverList.setOsVer(System.getProperty("os.version"));		
	
		model.addAttribute("serverList", serverList);
		logger.debug("systemStatus ended");
		
		return "/ezSystem/sysMonitor";
	}
	
	/**
	 *  관리자->시스템 모니터링
	 * */
	@RequestMapping(value="/admin/ezSystem/sysMonitorInfo.do")
	public String sysMonitorInfo(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("sysMonitorInfo started");
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);	
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}		
		
		SysMonitorVO osInfo = new SysMonitorVO();
		osInfo.setOsName(System.getProperty("os.name"));
		osInfo.setOsVer(System.getProperty("os.version"));
		
		SysMonitorVO cpuInfo = EzSystemUtil.getCpuInfo(userInfo.getTenantId());
		SysMonitorVO memoryInfo = EzSystemUtil.getMemoryInfo(userInfo.getTenantId());
		List<FileSysInfoVO> fileSysInfoList  = EzSystemUtil.getFileSysInfo(userInfo.getTenantId());
		String diskioInfo = EzSystemUtil.getDiskioInfo(userInfo.getTenantId());
		String netTrafficList = EzSystemUtil.getNetByteInfo(userInfo.getTenantId());
		
		model.addAttribute("osInfo", osInfo);
		model.addAttribute("cpuInfo", cpuInfo);
		model.addAttribute("memoryInfo", memoryInfo);
		model.addAttribute("fileSysInfoList", fileSysInfoList);
		model.addAttribute("diskioInfo", diskioInfo);
		model.addAttribute("netTrafficList", netTrafficList);		
		
		logger.debug("sysMonitorInfo ended");
		
		return "json";
	}
	
}
