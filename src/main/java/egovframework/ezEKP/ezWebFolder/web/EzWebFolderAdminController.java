package egovframework.ezEKP.ezWebFolder.web;

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
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderAdminController extends EgovFileMngUtil {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzWebFolderAdminService")
	private EzWebFolderAdminService ezWebFolderAdminService;
	
	@Resource(name = "EzWebFolderService")
	private EzWebFolderService ezWebFolderService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderAdminController.class);
	
	@RequestMapping(value = "/admin/ezWebFolder/webFolderConfig.do")
	public String webFolderConfig(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("webFolderConfig started");
		logger.debug("webFolderConfig ended");
		
		return "admin/ezWebFolder/webfolderConfig";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminLeft.do")
	public String webfolderAdminLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/company-id/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("offset", user.getOffset())
										.queryParam("lang", user.getLang());
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String companyId = (String) resultBody.get("data");
			model.addAttribute("company", companyId);
		}
		
		return "admin/ezWebFolder/webfolderAdminLeft";
	}

	@RequestMapping(value="/admin/ezWebFolder/folderMoveConfirm.do")
	public String folderMoveConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("File Move Confirm is running!");
		String folderId   = request.getParameter("folderId")   != null ? request.getParameter("folderId")   : "";
		String rootFolder = request.getParameter("rootFolder") != null ? request.getParameter("rootFolder") : "";
		
		model.addAttribute("folderId", folderId);
		model.addAttribute("rootFolder", rootFolder);
		logger.debug("Folder Move Confirm finishes!");
		
		return "admin/ezWebFolder/folderMove";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminRight.do")
	public String webfolderAdminRight(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/company-list/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("offset", user.getOffset())
										.queryParam("lang", user.getLang());
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
		}
		
		return "admin/ezWebFolder/webfolderCompanyConfig";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminPersonal.do")
	public String webfolderAdminPersonal(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/company-list/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("offset", user.getOffset())
										.queryParam("lang", user.getLang());
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
		}
		
		return "admin/ezWebFolder/webfolderPersonalConfig";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminCompanyFolder.do")
	public String webfolderCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/company-list/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("offset", user.getOffset())
										.queryParam("lang", user.getLang());
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
			model.addAttribute("primary", user.getLang());
		}
		
		return "admin/ezWebFolder/webfolderCompanyFolder";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminCompanyFile.do")
	public String webfolderCompanyFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String folderId     = request.getParameter("folderId");
		String rootFolder   = request.getParameter("rootFolder");
		
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/company-list/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("offset", user.getOffset())
										.queryParam("lang", user.getLang());
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
			model.addAttribute("primary", user.getLang());
			model.addAttribute("folderId", folderId);
			model.addAttribute("rootFolder", rootFolder);
		}
		
		return "admin/ezWebFolder/webfolderCompanyFile";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminFileHistory.do")
	public String webfolderFileHistory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/company-list/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("offset", user.getOffset())
										.queryParam("lang", user.getLang());
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
			model.addAttribute("primary", user.getLang());
		}
		
		return "admin/ezWebFolder/webfolderFileHistory";
	}

	@RequestMapping(value="/admin/ezWebFolder/saveConfig.do", method = RequestMethod.POST)
	public void saveConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("saveConfig is running!");
		
		String personalLimit = request.getParameter("pLimitVal");
		String uploadLimit   = request.getParameter("uLimitVal");
		String companyId     = request.getParameter("companyId");
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/basicstorage/" + personalLimit + "/comp";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("uploadLimit", uploadLimit)
										.queryParam("companyId", companyId);
		
		RestTemplate rest = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		logger.debug("Status: " + status);
		logger.debug("saveConfig finishes!");
	}

	@RequestMapping(value="/admin/ezWebFolder/getConfig.do", method = RequestMethod.POST)
	public String getConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getConfig is running!");
		
		String companyId     = request.getParameter("companyId");
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/basicstorage/id/" + companyId + "/comp";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject webfolderConfig = (JSONObject) resultBody.get("data");
			model.addAttribute("webfolderConfig", webfolderConfig);
		}
		
		logger.debug("getConfig finishes!");
		
		return "json";
	}

	@RequestMapping(value="/admin/ezWebFolder/getCapacities.do", method = RequestMethod.POST)
	public String getCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String currPage      = request.getParameter("currentPage");
		String searchStr     = request.getParameter("searchStr");
		String searchOpt     = request.getParameter("searchOpt");
		String companyId     = request.getParameter("companyId");
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/basicstorage/id/" + companyId + "/person";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("primary", user.getLang())
										.queryParam("searchStr", searchStr)
										.queryParam("searchOpt", searchOpt)
										.queryParam("currentPage", currPage);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray listUserCapacity = (JSONArray) resultBody.get("data");
			long totalPages            = (long) resultBody.get("totalPages");
			long totalUsers            = (long) resultBody.get("totalUsers");
			model.addAttribute("capacityList", listUserCapacity);
			model.addAttribute("totalPages", totalPages);
			model.addAttribute("totalUsers", totalUsers);
		}
		
		return "json";
	}

	@RequestMapping(value="/admin/ezWebFolder/updateCapacities.do", method = RequestMethod.POST)
	public void updateCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam(value = "userListParam") List<String> userList, HttpServletResponse response) throws Exception {
		//LoginVO userInfo       = commonUtil.userInfo(loginCookie);
		String newStorageValue = request.getParameter("newStorage");
		String companyId       = request.getParameter("companyId");
		
		String gwServerUrl     = config.getProperty("config.webfolderGwServerURL");
		String url             = gwServerUrl + "/webfolderadmin/basicstorage/" + newStorageValue + "/person";
				
		HttpHeaders headers    = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity   = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("companyId", companyId)
										.queryParam("userList", String.join(",", userList));
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		logger.debug("Status: " + status);
	}

	@RequestMapping(value="/admin/ezWebFolder/restoreCapacities.do", method = RequestMethod.POST)
	public void restoreCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam(value = "userListParam") List<String> userList, HttpServletResponse response) throws Exception {
		//LoginVO userInfo     = commonUtil.userInfo(loginCookie);
		String companyId     = request.getParameter("companyId");
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/storagereset/person";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("companyId", companyId)
										.queryParam("userList", String.join(",", userList));
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		logger.debug("Status: " + status);
	}

	@RequestMapping(value="/admin/ezWebFolder/getFileLogs.do", method = RequestMethod.POST)
	public String getFileLogs(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String offset        = user.getOffset();
		String primary       = user.getLang();
		String currPage      = request.getParameter("currentPage");
		String companyId     = request.getParameter("companyId");
		String startDate     = request.getParameter("startDate") != null ? request.getParameter("startDate") : "";
		String endDate       = request.getParameter("endDate")   != null ? request.getParameter("endDate")   : "";
		String fileExt       = request.getParameter("fileExt")   != null ? request.getParameter("fileExt")   : "";
		String fileName      = request.getParameter("fileName")  != null ? request.getParameter("fileName")  : "";
		String userName      = request.getParameter("userName")  != null ? request.getParameter("userName")  : "";
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/filehistorylist";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("primary", primary)
										.queryParam("offset", offset)
										.queryParam("companyId", companyId)
										.queryParam("startDate", startDate)
										.queryParam("fileExt", fileExt)
										.queryParam("fileName", fileName)
										.queryParam("userName", userName)
										.queryParam("currentPage", currPage)
										.queryParam("endDate", endDate);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray listFileLogs = (JSONArray) resultBody.get("data");
			long totalPages        = (long) resultBody.get("totalPages");
			long totalRows         = (long) resultBody.get("totalRows");
			model.addAttribute("fileLogList", listFileLogs);
			model.addAttribute("totalPages", totalPages);
			model.addAttribute("totalRows", totalRows);
		}
		
		return "json";
	}

	@RequestMapping(value="/admin/ezWebFolder/getAdminList.do", method = RequestMethod.POST)
	public String webfolderAdminList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String pageNum      = request.getParameter("pageNum");
		String pageSize     = request.getParameter("pageSize");
		String companyID    = request.getParameter("companyID");
		String primary      = user.getLang();
		String gwServerUrl  = config.getProperty("config.webfolderGwServerURL");
		String url          = gwServerUrl + "/webfolderadmin/webfolderadmin-list";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("primary", primary)
										.queryParam("companyId", companyID)
										.queryParam("pageNum", pageNum)
										.queryParam("pageSize", pageSize);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray listUsers = (JSONArray) resultBody.get("data");
			long totalRows      = (long) resultBody.get("count");
			model.addAttribute("listOfUsers", listUsers);
			model.addAttribute("totalRows", totalRows);
		}
		
		return "json";
	}

	@RequestMapping(value="/admin/ezWebFolder/getCompanyFolderTree.do", method = RequestMethod.POST)
	public String getCompanyFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		//LoginVO userInfo     = commonUtil.userInfo(loginCookie);
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String companyId     = request.getParameter("companyId");
		String folderId	     = request.getParameter("folderId");
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/foldersTree";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("primary", user.getLang())
										.queryParam("companyId", companyId)
										.queryParam("folderId", folderId)
										.queryParam("offset", user.getOffset());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject folderTree = (JSONObject) resultBody.get("data");
			model.addAttribute("companyTree", folderTree);
		}
		
		return "json";
	}

	@RequestMapping(value="/admin/ezWebFolder/getSubFolderTree.do", method = RequestMethod.POST)
	public String getSubFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String folderId      = request.getParameter("folderId");
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/subfolder-tree/" + folderId;
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("primary", user.getLang())
										.queryParam("offset", user.getOffset());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject folderTree = (JSONObject) resultBody.get("data");
			model.addAttribute("subTree", folderTree);
		}
		
		return "json";
	}

	@RequestMapping(value="/admin/ezWebFolder/getFolderUsers.do", method = RequestMethod.POST)
	public String getFolderUsers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String folderId      = request.getParameter("folderId");
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/folder-users/" + folderId;
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url).queryParam("offset", user.getOffset());
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray folderUsers = (JSONArray) resultBody.get("data");
			model.addAttribute("folderUsers", folderUsers);
		}
		
		return "json";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezWebFolder/addCompanyFolder.do", method = RequestMethod.POST)
	public String addCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderId        = request.getParameter("folderId");
		String companyId	   = request.getParameter("companyId");
		String folderName	   = request.getParameter("folderName");
		String folderUsers     = request.getParameter("folderUsers");
		String gwServerUrl     = config.getProperty("config.webfolderGwServerURL");
		String url             = gwServerUrl + "/webfolderadmin/folders";
		JSONObject jsonObject  = new JSONObject();
		
		jsonObject.put("offset", userInfo.getOffset());
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("lang", userInfo.getLang());
		jsonObject.put("pFolderId", folderId);
		jsonObject.put("companyId", companyId);
		jsonObject.put("fName", folderName);
		jsonObject.put("fUsers", folderUsers);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(jsonObject, headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		return "json";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezWebFolder/changeCompanyFolder.do", method = RequestMethod.POST)
	public String changeCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user    = commonUtil.userInfoSimple(loginCookie);
		String folderId       = request.getParameter("folderId");
		String folderName	  = request.getParameter("folderName");
		String folderUsers    = request.getParameter("folderUsers");
		String gwServerUrl    = config.getProperty("config.webfolderGwServerURL");
		String url            = gwServerUrl + "/webfolderadmin/folders/" + folderId;
		JSONObject jsonObject = new JSONObject();
		
		jsonObject.put("offset", user.getOffset());
		jsonObject.put("userId", user.getId());
		jsonObject.put("fName", folderName);
		jsonObject.put("fUsers", folderUsers);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(jsonObject, headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		return "json";
	}

	@RequestMapping(value="/admin/ezWebFolder/delCompanyFolder.do", method = RequestMethod.POST)
	public String deleteCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String folderId      = request.getParameter("folderId");
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/webfolderadmin/folders/" + folderId;
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("offset", user.getOffset());
		RestTemplate rest            = new RestTemplate();
		rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		
		return "json";
	}	

	@RequestMapping(value="/admin/ezWebFolder/getFileList.do", method = RequestMethod.POST)
	public String getFileList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String primary     = user.getLang();
		String offset      = user.getOffset();
		String currPage    = request.getParameter("currentPage");
		String startDate   = request.getParameter("startDate");
		String endDate     = request.getParameter("endDate");
		String fileExt     = request.getParameter("fileExt");
		String fileName    = request.getParameter("fileName");
		String userName    = request.getParameter("userName");
		String fileType    = request.getParameter("fileType");
		String folderId    = request.getParameter("folderId");
		
		String gwServerUrl = config.getProperty("config.webfolderGwServerURL");
		String url         = gwServerUrl + "/webfolderadmin/folders/" + folderId + "/file-list";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("primary", primary)
										.queryParam("offset", offset)
										.queryParam("startDate", startDate)
										.queryParam("fileExt", fileExt)
										.queryParam("fileName", fileName)
										.queryParam("userName", userName)
										.queryParam("fileType", fileType)
										.queryParam("currentPage", currPage)
										.queryParam("endDate", endDate);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray fileList = (JSONArray) resultBody.get("data");
			long totalPages    = (long) resultBody.get("totalPages");
			long totalRows     = (long) resultBody.get("totalRows");
			model.addAttribute("totalPages", totalPages);
			model.addAttribute("totalRows", totalRows);
			model.addAttribute("fileList", fileList);
		}
		
		return "json";
	}

	@RequestMapping(value="/admin/ezWebFolder/moveFolder.do", method = RequestMethod.POST)
	public String moveFolder(@CookieValue("loginCookie") String loginCookie,  Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Move Folder is running!");
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String folderId     = request.getParameter("folderId");
		String parentFld    = request.getParameter("parentFldId");
		String mode         = request.getParameter("mode");
		String gwServerUrl  = config.getProperty("config.webfolderGwServerURL");
		String url          = gwServerUrl + "/webfolderadmin/folders/" + folderId + "/modes/" + mode+ "/folder-move";
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("primary", user.getLang())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("parentFld", parentFld);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity          = new HttpEntity<>(headers);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (!status.equals("ok")) {
			String reason      = resultBody.get("reason").toString();
			model.addAttribute("reason", reason);
		}
		
		logger.debug("Move Folder finishes!");
		
		return "json";
	}

	@RequestMapping(value="/admin/ezWebFolder/targetSelect.do")
	public String selectTarget(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
		logger.debug("select target is running!");
		
		LoginVO userInfo  = commonUtil.userInfo(loginCookie);
		String pCompanyID = userInfo.getCompanyID();
		
		model.addAttribute("pCompanyID", pCompanyID);
		model.addAttribute("primary", userInfo.getPrimary());
		
		logger.debug("select target finishes!");
		return "admin/ezWebFolder/targetSelect";
	}

}