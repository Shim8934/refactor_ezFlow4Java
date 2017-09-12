package egovframework.ezEKP.ezSystem.web;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.util.EzSystemUtil;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzSystemAdminController {

	private static final Logger logger = LoggerFactory.getLogger(EzSystemAdminController.class);
	
	@Autowired
	private Properties config;
	
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
	 * 전체 서버 목록 가져오기.
	 * config.properties에 현재 포함 다른 서버 목록 전부 저장
	 * */
	@RequestMapping(value="/admin/ezSystem/sysREST.do")
	public String sysREST(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request , Model model) throws Exception {
		logger.debug("sysREST started.");
		
		//관리자 권한 체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		InetAddress local = InetAddress.getLocalHost();
		String localIP = local.getHostAddress();		
		logger.debug("localIP : " + localIP);		
		
		String serverName = request.getServerName();
		String curServer = config.getProperty("config.curServer");
	
		/**
		 * config.properties에 있는 서버 목록 불러오기
		 * */
		int n = 1;
		ArrayList<String> serverList = new ArrayList<String>();
		ArrayList<String> getServerList = new ArrayList<String>();
		while (true) {
			// 1. 첫 번째 서버 정보의 갯수가 1, 정보가 존재하지 않는 경우
			// 2. 정보가 더이상 존재하지 않는 경우
			// 3. 그 외는 serverList에 저장
			if (n == 1 && config.getProperty("config.SysServer" + n) == null) {
				logger.debug("Empty serverlist in configProperties.");
				getServerList.add("EMPTY");
				break;
			} else if (config.getProperty("config.SysServer" + n) == null) {
				logger.debug("Searching serverlist is ending.");
				break;
			} else {
				getServerList.add(config.getProperty("config.SysServer" + n));
				n ++;
			}
		}
		
		serverList = ezSystemAdminService.getServerInfo(localIP, config.getProperty("config." + curServer) ,serverName, getServerList);

		model.addAttribute("serverList", serverList);
		model.addAttribute("curServer", curServer);
		
		logger.debug("sysREST ended.");		
		return "/ezSystem/sysMonitor";
	}

	/**
	 * 선택된 서버의 CPU, 메모리, 네트워크 등 정보 가져오기
	 * */
	@RequestMapping(value="/admin/ezSystem/sysMonitorREST.do")
	public String sysMonitorREST(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("sysMonitorREST started.");
		logger.debug("<<<serverSN : " + request.getParameter("serverSN"));
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);	
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}		
		
		InetAddress local = InetAddress.getLocalHost();
		String localIP = local.getHostAddress();		
		logger.debug("localIP : " + localIP);		
		
		String serverName = request.getServerName();
		String serverSN = request.getParameter("serverSN"); //0부터 찍힘
		String hostInfo = "config.SysServer" + serverSN; 
		String address = config.getProperty(hostInfo);		
		String curServer = request.getParameter("curServer");
		boolean chkServer; 
		
		// 현재 서버와 조회하는 서버가 같을 경우
		if (curServer.equalsIgnoreCase("SysServer"+serverSN)) {
			chkServer = true;
		} else {
			chkServer = false;
		}
		
		String result = ezSystemAdminService.getSysMonitorInfo(localIP, serverName, address, chkServer);

		/**
		 * RESTful API로 받아온 데이터를 가공해서 던짐
		 * */
		JSONParser parser = new JSONParser();
		JSONObject jObj = (JSONObject) parser.parse(result);
		JSONArray jArr = (JSONArray) jObj.get("getSysMonitorInfo");

		logger.debug(jArr.get(0).toString());
		logger.debug(jArr.get(1).toString());
		logger.debug(jArr.get(2).toString());
		logger.debug(jArr.get(3).toString());
		logger.debug(jArr.get(4).toString());
		logger.debug(jArr.get(5).toString());
		
		model.addAttribute("osInfo", jArr.get(0).toString());
		model.addAttribute("cpuInfo", jArr.get(1).toString());
		model.addAttribute("memoryInfo", jArr.get(2).toString());
		model.addAttribute("fileSysInfoList", jArr.get(3).toString());
		model.addAttribute("diskioInfo", jArr.get(4).toString());
		model.addAttribute("netTrafficList", jArr.get(5).toString());
		
		logger.debug("sysMonitorREST ended.");
		
		return "json";
	}
	
	/**
	 * 타 서버에서 이 서버로 RESTful로 접근할 때 발생
	 * 서버리스트 정보 가져오기
	 * */
	@RequestMapping(value="/ezSystem/util/getSysInfo", method=RequestMethod.POST)
	@ResponseBody
	public String getSysInfo () throws Exception {
		
		logger.debug("inner getSysInfo start.");
		
		String result = "";
		InetAddress local = InetAddress.getLocalHost();
		String localIP = local.getHostAddress();		
		logger.debug("localIP : " + localIP);		
		
		String serverList = EzSystemUtil.getSysInfo(localIP);
		
		if (serverList.equalsIgnoreCase(null)) {
			result ="FALSE";
		} else {
			result = serverList;
		}
		
		logger.debug("getSysInfo end.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSystem/util/getSysMonitorInfo", method=RequestMethod.POST)
	@ResponseBody
	public String getSysMonitorInfo () throws Exception {
		
		logger.debug("inner getSysMonitorInfo start.");
		
		JSONObject jObj = new JSONObject();
		JSONArray jArr = new JSONArray();
		
		InetAddress local = InetAddress.getLocalHost();
		String localIP = local.getHostAddress();		
		logger.debug("localIP : " + localIP);
		
		String osInfo = EzSystemUtil.getSysInfo(localIP);
		String cpuInfo = EzSystemUtil.getCpuInfo(localIP);
		String memoryInfo = EzSystemUtil.getMemoryInfo(localIP);
		String fileSysInfoList  = EzSystemUtil.getFileSysInfo(localIP);
		String diskioInfo = EzSystemUtil.getDiskioInfo(localIP);
		String netTrafficList = EzSystemUtil.getNetDataInfo(localIP);
		
		jArr.add(osInfo);
		jArr.add(cpuInfo);
		jArr.add(memoryInfo);
		jArr.add(fileSysInfoList);
		jArr.add(diskioInfo);
		jArr.add(netTrafficList);
		
		jObj.put("getSysMonitorInfo", jArr);
		
		logger.debug("getSysMonitorInfo end.");
		
		return jObj.toString();
	}

}
