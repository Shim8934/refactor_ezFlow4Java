package egovframework.ezEKP.ezWebFolder.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderAdminController extends EgovFileMngUtil {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzWebFolderAdminService")
	private EzWebFolderAdminService ezWebFolderAdminService;
	
	@Resource(name = "EzWebFolderService")
	private EzWebFolderService ezWebFolderService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderAdminController.class);
	
	@RequestMapping(value = "/admin/ezWebFolder/webFolderConfig.do")
	public String webFolderConfig(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("webFolderConfig started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		logger.debug("webFolderConfig ended");
		
		return "admin/ezWebFolder/webfolderConfig";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminLeft.do")
	public String webfolderAdminLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        
		return "admin/ezWebFolder/webfolderAdminLeft";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminRight.do")
	public String webfolderAdminRight(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		LoginVO userInfo     = commonUtil.userInfo(loginCookie);
		String personalLimit = "";
		String uploadLimit 	 = "";

		//Get list of companies
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(j++, vo);
			}
		}	
        
		model.addAttribute("list", resultList);
		model.addAttribute("userCompany", userInfo.getCompanyID());
		
		return "admin/ezWebFolder/webfolderCompanyConfig";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminPersonal.do")
	public String webfolderAdminPersonal(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		//Get list of companies
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(j++, vo);
			}
		}		

		model.addAttribute("list", resultList);
		model.addAttribute("userCompany", userInfo.getCompanyID());

		return "admin/ezWebFolder/webfolderPersonalConfig";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminCompanyFolder.do")
	public String webfolderCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		//Get list of companies
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(j++, vo);
			}
		}
		
		model.addAttribute("list", resultList);
		model.addAttribute("userCompany", userInfo.getCompanyID());
		
		return "admin/ezWebFolder/webfolderCompanyFolder";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminCompanyFile.do")
	public String webfolderCompanyFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        model.addAttribute("companyID", "S907000");
        
		return "admin/ezWebFolder/webfolderCompanyFile";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminFileHistory.do")
	public String webfolderFileHistory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		//Get list of companies
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(j++, vo);
			}
		}		

		model.addAttribute("list", resultList);
		model.addAttribute("primary", userInfo.getPrimary());
		model.addAttribute("userCompany", userInfo.getCompanyID());
        
		return "admin/ezWebFolder/webfolderFileHistory";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/saveConfig.do", method = RequestMethod.POST)
	public void saveConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {       
		logger.debug("saveConfig is running!");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);        
		String personalLimit = request.getParameter("pLimitVal");
		String uploadLimit   = request.getParameter("uLimitVal");
		String companyId     = request.getParameter("companyId");		
		
		String gwServerUrl = config.getProperty("config.webfolderGwServerURL");		
		String url = gwServerUrl + "/webfolderadmin/basicstorage/" + personalLimit + "/comp";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("uploadLimit", uploadLimit)
				.queryParam("companyId", companyId);
		RestTemplate rest = new RestTemplate();
		
		rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);	
	
		logger.debug("saveConfig finishes!");
	}
	
	@RequestMapping(value="/admin/ezWebFolder/getConfig.do", method = RequestMethod.POST)	
	public String getConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		logger.debug("getConfig is running!");		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);    
		String companyId = request.getParameter("companyId");		
		
		String gwServerUrl = config.getProperty("config.webfolderGwServerURL");
		String url = gwServerUrl + "/webfolderadmin/basicstorage/id/" + companyId + "/comp";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("tenantId", userInfo.getTenantId());	
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);		
		JSONParser jp = new JSONParser();		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());				
		String status = resultBody.get("status").toString();
				
		if (status.equals("ok")) {			
			JSONObject webfolderConfig = (JSONObject) resultBody.get("data");			
			model.addAttribute("webfolderConfig", webfolderConfig);
		}
		
		logger.debug("getConfig finishes!");
		
		return "json";
	}	
	
	@RequestMapping(value="/admin/ezWebFolder/getCapacities.do", method = RequestMethod.POST)	
	public String getCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {     			
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String currPage  = request.getParameter("currentPage");
		String searchStr = request.getParameter("searchStr");
		String searchOpt = request.getParameter("searchOpt");
		String companyId = request.getParameter("companyId");
		
		String gwServerUrl = config.getProperty("config.webfolderGwServerURL");
		String url = gwServerUrl + "/webfolderadmin/basicstorage/id/" + companyId + "/person";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("primary", userInfo.getPrimary())
				.queryParam("searchStr", searchStr)
				.queryParam("searchOpt", searchOpt)
				.queryParam("currentPage", currPage);
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);		
		JSONParser jp = new JSONParser();		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());				
		String status = resultBody.get("status").toString();
				
		if (status.equals("ok")) {			
			JSONArray listUserCapacity = (JSONArray) resultBody.get("data");
			long totalPages = (long) resultBody.get("totalPages");
			long totalUsers = (long) resultBody.get("totalUsers");
			model.addAttribute("capacityList", listUserCapacity);
			model.addAttribute("totalPages", totalPages);
			model.addAttribute("totalUsers", totalUsers);
		}
	
		return "json";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/updateCapacities.do", method = RequestMethod.POST)
	public void updateCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam(value = "userListParam") List<String> userList, HttpServletResponse response) throws Exception {       
		LoginVO userInfo       = commonUtil.userInfo(loginCookie);        
		String newStorageValue = request.getParameter("newStorage");
		String companyId       = request.getParameter("companyId");
		
		String gwServerUrl = config.getProperty("config.webfolderGwServerURL");		
		String url = gwServerUrl + "/webfolderadmin/basicstorage/" + newStorageValue + "/person";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("companyId", companyId)
				.queryParam("userList", String.join(",", userList));			
		RestTemplate rest = new RestTemplate();
		
		rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
	}
	
	@RequestMapping(value="/admin/ezWebFolder/restoreCapacities.do", method = RequestMethod.POST)
	public void restoreCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam(value = "userListParam") List<String> userList, HttpServletResponse response) throws Exception {       
		LoginVO userInfo       = commonUtil.userInfo(loginCookie);		
		String companyId       = request.getParameter("companyId");
		String totalAmount     = "0";
		
		String gwServerUrl = config.getProperty("config.webfolderGwServerURL");		
		String url = gwServerUrl + "/webfolderadmin/storagereset/person";
		
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("companyId", companyId)
				.queryParam("userList", String.join(",", userList));			
		RestTemplate rest = new RestTemplate();
		
		rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		
/*		try {
			WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyId, userInfo.getTenantId());
			if (webfolderConfig != null) {
				totalAmount = webfolderConfig.getTotalLimit();
			}
			
			for (String userId : userList) {
				ezWebFolderAdminService.updateNewAmount(userId, totalAmount, companyId, userInfo.getTenantId());
			}			
		}
		catch (Exception e) {
			e.printStackTrace();
		}*/
	}
	
	@RequestMapping(value="/admin/ezWebFolder/getFileLogs.do", method = RequestMethod.POST)	
	public String getFileLogs(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {     			
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String offset    = userInfo.getOffset();
		String primary   = userInfo.getPrimary();
		int currPage     = Integer.parseInt(request.getParameter("currentPage"));
		String companyId = request.getParameter("companyId");
		String startDate = request.getParameter("startDate") != null ? request.getParameter("startDate") : "";	
		String endDate   = request.getParameter("endDate")   != null ? request.getParameter("endDate")   : "";
		String fileExt   = request.getParameter("fileExt")   != null ? request.getParameter("fileExt")   : "";
		String fileName  = request.getParameter("fileName")  != null ? request.getParameter("fileName")  : "";
		String userName  = request.getParameter("userName")  != null ? request.getParameter("userName")  : "";		
		int totalRows = 0;
		int totalPages = 0;
		int pageSize = 10;
		String searchChk = "1";
		
		logger.debug("StartDate: " + startDate + " || EndDate: " + endDate + " || FileExt: " + fileExt + " || FileName: " + fileName + " || Username: " + userName);
		
		if (startDate.equals("") && endDate.equals("") && fileExt.equals("") && fileName.equals("") && userName.equals("")) {
			searchChk = "0";
		}
		
		if (searchChk.equals("1")) {
			if (startDate.equals("")) {
				//Get logs in three months
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date now = new Date();						 
				Calendar cal = Calendar.getInstance();
				cal.setTime(now);	
				cal.add(Calendar.MONTH, -3);
				
				startDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, true);
				endDate = commonUtil.getDateStringInUTC(sdf.format(now), offset, true); 
			}
			else {
				String startDateTmp = startDate + " 00:00:00";
				String endDateTmp   = endDate + " 23:59:59";
				
				startDate = commonUtil.getDateStringInUTC(startDateTmp, userInfo.getOffset(), true);
				endDate   = commonUtil.getDateStringInUTC(endDateTmp, userInfo.getOffset(), true);
			}
		}
		
		logger.debug("SearchChk: " + searchChk + " || StartDate in UTC: " + startDate + " || EndDate in UTC: " + endDate);
		
		List<FileLogVO> listFileLogs = ezWebFolderAdminService.getListFileLogs(companyId, searchChk, startDate, endDate, fileExt, fileName, userName, primary, offset, userInfo.getTenantId());
		
		//Paging
		if (listFileLogs != null) {
			totalRows  = listFileLogs.size();
		}
		
		totalPages = (totalRows + pageSize - 1)/pageSize;
		List<FileLogVO> renderList = new ArrayList<FileLogVO>();
		
		logger.debug("totalUsers: " + totalRows + " || TotalPages: " + totalPages + " || CurrPage: " + currPage);

		if (totalPages == 0 || totalPages == 1) {
			model.addAttribute("fileLogList", listFileLogs);
		}
		else {
			if (currPage < totalPages) {				
				int startPoint = (currPage - 1) * pageSize;
				int endPoint = currPage * pageSize;
				renderList = listFileLogs.subList(startPoint, endPoint);	
				model.addAttribute("fileLogList", renderList);
			}
			else {
				if (currPage > totalPages) {
					currPage = totalPages;
				}
				int startPoint = (currPage - 1) * pageSize;
				int endPoint = totalRows;				
				
				renderList = listFileLogs.subList(startPoint, endPoint);
				model.addAttribute("fileLogList", renderList);
			}
		}
		
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("totalRows", totalRows);
		return "json";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/getCompanyFolderTree.do", method = RequestMethod.POST)	
	public String getCompanyFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {     			
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String offset    = userInfo.getOffset();				
		String companyId = request.getParameter("companyId");
		
		logger.debug("Company ID: " + companyId);
		
		FolderVO folderVO = ezWebFolderService.getCompanyFolderId(companyId, offset, userInfo.getTenantId());
		FolderSimpleVO company = ezWebFolderService.getSimpleFolder(folderVO.getFolderId(), userInfo.getTenantId());
		ezWebFolderService.getAllSubDepts(company, userInfo.getTenantId(), 1);
		
		model.addAttribute("companyTree", company);

		return "json";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/getSubFolderTree.do", method = RequestMethod.POST)	
	public String getSubFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {     			
		LoginVO userInfo = commonUtil.userInfo(loginCookie);				
		String folderId = request.getParameter("folderId");		

		FolderSimpleVO folder = ezWebFolderService.getSimpleFolder(folderId, userInfo.getTenantId());
		ezWebFolderService.getAllSubDepts(folder, userInfo.getTenantId(), 1);
		
		model.addAttribute("subTree", folder);

		return "json";
	}
	
	
	@RequestMapping(value="/admin/ezWebFolder/targetSelect.do")
	public String selectTarget(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
		logger.debug("select target is running!");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userInfoDeptCode="";				
		String pCompanyID="";

		userInfoDeptCode = userInfo.getDeptID();
		pCompanyID = userInfo.getCompanyID();
		
		String langData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());

		model.addAttribute("pCompanyID", pCompanyID);
		model.addAttribute("userInfoDeptCode", userInfoDeptCode);
		model.addAttribute("langData", langData);
		model.addAttribute("primary", userInfo.getPrimary());
		
		logger.debug("select target finishes!");
		return "admin/ezWebFolder/targetSelect";
	}
	
	
}
