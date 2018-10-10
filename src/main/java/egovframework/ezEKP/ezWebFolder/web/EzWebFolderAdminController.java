package egovframework.ezEKP.ezWebFolder.web;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.IOUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RequestCallback;
import org.springframework.web.client.ResponseExtractor;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.let.user.login.vo.LoginSimpleVO;
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
	public String webFolderConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("webFolderConfig start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("webFolderConfig end");
		
		return "admin/ezWebFolder/webfolderConfig";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminLeft.do")
	public String webfolderAdminLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderAdminLeft start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-id/" + user.getId();
		
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
			String companyId = (String) resultBody.get("data");
			model.addAttribute("company", companyId);
			model.addAttribute("primary", (String) resultBody.get("primary"));
		}
		
		logger.debug("webfolderAdminLeft end");
		return "admin/ezWebFolder/webfolderAdminLeft";
	}

	@RequestMapping(value="/admin/ezWebFolder/deleteFolderConfirm.do")
	public String deleteFolderConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("deleteFolderConfirm start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		String folderId = request.getParameter("folderId") != null ? request.getParameter("folderId") : "";
		
		if (folderId.equals("")) {
			logger.debug("Folder delete confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
		model.addAttribute("folderId", folderId);
		logger.debug("deleteFolderConfirm end");
		return "admin/ezWebFolder/folderDelete";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/recycleBin.do")
	public String getRecycleBin(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model )throws Exception {
		logger.debug("getRecycleBin start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		//model.addAttribute("listCount", getUsrListCount(loginCookie, request));
		model.addAttribute("lang", commonUtil.userInfoSimple(loginCookie).getLang());
		
		logger.debug("getRecycleBin end");
		return "admin/ezWebFolder/recycleBin";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/folderMoveConfirm.do")
	public String folderMoveConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("folderMoveConfirm start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		String folderId      = request.getParameter("folderId")   != null ? request.getParameter("folderId") : "";
		
		logger.debug("Folder Id: " + folderId);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("mode", "admin");
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
			model.addAttribute("primary", (String) resultBody.get("primary"));
		}
		
		model.addAttribute("folderId", folderId);
		logger.debug("folderMoveConfirm end");
		
		return "admin/ezWebFolder/folderMove";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminRight.do")
	public String webfolderAdminRight(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderAdminRight start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
		
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
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
		}
		
		logger.debug("webfolderAdminRight end");
		return "admin/ezWebFolder/webfolderCompanyConfig";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminPersonal.do")
	public String webfolderAdminPersonal(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderAdminPersonal start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
		
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
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
		}
		
		logger.debug("webfolderAdminPersonal end");
		return "admin/ezWebFolder/webfolderPersonalConfig";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminCompanyFolder.do")
	public String webfolderCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderCompanyFolder start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
		
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
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
			model.addAttribute("primary", (String) resultBody.get("primary"));
		}
		
		logger.debug("webfolderCompanyFolder end");
		return "admin/ezWebFolder/webfolderCompanyFolder";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminCompanyFile.do")
	public String webfolderCompanyFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderCompanyFile start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		String folderId      = request.getParameter("folderId");
		String rootFolder    = request.getParameter("rootFolder");
		String selectedComp  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String level         = request.getParameter("level");
		
		logger.debug("Folder Id: " + folderId + " || Root FolderId: " + rootFolder + " || selected Company: " + selectedComp + " || level: " + level);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
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
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", selectedComp.equals("") ? companyId : selectedComp);
			model.addAttribute("list", companyList);
			model.addAttribute("primary", (String) resultBody.get("primary"));
			model.addAttribute("folderId", folderId);
			model.addAttribute("rootFolder", rootFolder);
		}
		
		model.addAttribute("level", level);
		logger.debug("webfolderCompanyFile end");
		return "admin/ezWebFolder/webfolderCompanyFile";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminDeptFile.do")
	public String webfolderDeptFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderDeptFile start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		String folderId      = request.getParameter("folderId");
		String level         = request.getParameter("level");
		String selectedComp  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		
		logger.debug("Folder Id: " + folderId + " || level: " + level + " || Selected Company: " + selectedComp);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
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
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", selectedComp.equals("") ? companyId : selectedComp);
			model.addAttribute("list", companyList);
			model.addAttribute("primary", (String) resultBody.get("primary"));
			model.addAttribute("folderId", folderId);
		}
		
		model.addAttribute("level", level);
		logger.debug("webfolderDeptFile end");
		return "admin/ezWebFolder/webfolderDeptFile";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminFileHistory.do")
	public String webfolderFileHistory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderFileHistory start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
		
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
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
			model.addAttribute("primary", (String) resultBody.get("primary"));
		}
		
		logger.debug("webfolderFileHistory end");
		return "admin/ezWebFolder/webfolderFileHistory";
	}

	@RequestMapping(value="/admin/ezWebFolder/saveConfig.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveConfig(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("saveConfig start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String personalLimit = request.getParameter("pLimitVal");
		String uploadLimit   = request.getParameter("uLimitVal");
		String companyId     = request.getParameter("companyId");
		
		logger.debug("Personal Limit: " + personalLimit + " || Upload Limit: " + uploadLimit + " || Company Id: " + companyId);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/basicstorage/" + personalLimit + "/comp";
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("uploadLimit", uploadLimit)
										.queryParam("companyId", companyId);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("saveConfig end");
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/getConfig.do", method = RequestMethod.POST)
	@ResponseBody
	public String getConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getConfig start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String companyId     = request.getParameter("companyId");
		
		logger.debug("CompanyId: " + companyId);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/basicstorage/id/" + companyId + "/comp";
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity          = new HttpEntity<>(headers);
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getConfig end");
		
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/getCapacities.do", method = RequestMethod.POST)
	@ResponseBody
	public String getCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getCapacities start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String currPage      = request.getParameter("currentPage");
		String searchStr     = request.getParameter("searchStr");
		String searchOpt     = request.getParameter("searchOpt");
		String companyId     = request.getParameter("companyId");
		String column      = request.getParameter("column");
		String order       = request.getParameter("order");
		
		logger.debug("Current page: " + currPage + " || Search String: " + searchStr + " || Search Operation: " + searchOpt + " || CompanyId: " + companyId + " || Column: " + column + " || Order: " + order);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/basicstorage/id/" + companyId + "/person";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("searchStr", searchStr)
										.queryParam("searchOpt", searchOpt)
										.queryParam("column", column)
										.queryParam("order", order)
										.queryParam("currentPage", currPage);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getCapacities end");
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/updateCapacities.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam(value = "userListParam") List<String> userList, Model model, HttpServletResponse response) throws Exception {
		logger.debug("updateCapacities start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String newStorageValue = request.getParameter("newStorage");
		String companyId       = request.getParameter("companyId");
		
		logger.debug("New storage value: " + newStorageValue + " || CompanyId: " + companyId + " || UserId List: " + String.join(",", userList));
		
		String gwServerUrl     = config.getProperty("config.webFolderGwServerURL");
		String url             = gwServerUrl + "/rest/ezwebfolderadmin/basicstorage/" + newStorageValue + "/person";
				
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
		
		logger.debug("updateCapacities end");
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/restoreCapacities.do", method = RequestMethod.POST)
	@ResponseBody
	public String restoreCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam(value = "userListParam") List<String> userList, HttpServletResponse response, Model model) throws Exception {
		logger.debug("restoreCapacities start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String companyId     = request.getParameter("companyId");
		
		logger.debug("Company Id: " + companyId);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/storagereset/person";
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
		
		logger.debug("restoreCapacities end");
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/getFileLogs.do", method = RequestMethod.POST)
	@ResponseBody
	public String getFileLogs(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getFileLogs start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String currPage      = request.getParameter("currentPage");
		String companyId     = request.getParameter("companyId");
		String column        = request.getParameter("column");
		String order         = request.getParameter("order");
		String listCnt       = request.getParameter("listCntSize");
		String startDate     = request.getParameter("startDate")  != null ? request.getParameter("startDate")  : "";
		String endDate       = request.getParameter("endDate")    != null ? request.getParameter("endDate")    : "";
		String fileExt       = request.getParameter("fileExt")    != null ? request.getParameter("fileExt")    : "";
		String fileName      = request.getParameter("fileName")   != null ? request.getParameter("fileName")   : "";
		String userName      = request.getParameter("userName")   != null ? request.getParameter("userName")   : "";
		String fileType      = request.getParameter("fileType")   != null ? request.getParameter("fileType")   : "";
		String actionType    = request.getParameter("actionType") != null ? request.getParameter("actionType") : "";
		
		logger.debug("Current page: " + currPage + " || CompanyId: " + companyId + " || Column: " + column + " || Order: " + order + " || ListCount: " + listCnt + " || StartDate: " + startDate + " || EndDate: " + endDate + " || File ext: " + fileExt + " || File Name: " + fileName + " || UserName: " + userName + " || File Type: " + fileType + " || Action Type: " + actionType);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/filehistorylist";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("companyId", companyId)
										.queryParam("startDate", startDate)
										.queryParam("fileExt", fileExt)
										.queryParam("fileName", fileName)
										.queryParam("fileType", fileType)
										.queryParam("userName", userName)
										.queryParam("currentPage", currPage)
										.queryParam("column", column)
										.queryParam("order", order)
										.queryParam("listCnt", listCnt)
										.queryParam("actionType", actionType)
										.queryParam("endDate", endDate);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getFileLogs end");
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/getAdminList.do", method = RequestMethod.POST)
	@ResponseBody
	public String webfolderAdminList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderAdminList start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		
		String pageNum      = request.getParameter("pageNum");
		String pageSize     = request.getParameter("pageSize");
		String companyID    = request.getParameter("companyID");
		
		logger.debug("Current page: " + pageNum + " || ListCount: " + pageSize +  " || CompanyId: " + companyID);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolderadmin/webfolderadmin-list";
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("companyId", companyID)
										.queryParam("pageNum", pageNum)
										.queryParam("pageSize", pageSize);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("webfolderAdminList end");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/admin/ezWebFolder/getDepartFolderTree.do", method = RequestMethod.GET)
	@ResponseBody
	public String getDepartmentFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getDepartmentFolderTree start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String companyId     = request.getParameter("companyId");
		String folderId      = request.getParameter("folderId");
		
		logger.debug("CompanyId: " + companyId + " || Folder Id: " + folderId);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/foldersTree/dept";
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("companyId", companyId)
										.queryParam("folderId", folderId)
										.queryParam("userId", user.getId());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getDepartmentFolderTree end");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/admin/ezWebFolder/getCompanyFolderTree.do", method = RequestMethod.GET)
	@ResponseBody
	public String getCompanyFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getCompanyFolderTree start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String companyId     = request.getParameter("companyId");
		String folderId      = request.getParameter("folderId");
		
		logger.debug("CompanyId: " + companyId + " || FolderId: " + folderId);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/foldersTree/comp";
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("companyId", companyId)
										.queryParam("folderId", folderId)
										.queryParam("userId", user.getId());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getCompanyFolderTree end");
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/getSubFolderTree.do", method = RequestMethod.GET)
	@ResponseBody
	public String getSubFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getSubFolderTree start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String folderId      = request.getParameter("folderId");
		String mode          = request.getParameter("mode");
		
		logger.debug("FolderId: " + folderId + " || mode: " + mode);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/subfolder-tree/" + folderId;
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("mode", mode);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getSubFolderTree end");
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/getFolderUsers.do", method = RequestMethod.POST)
	@ResponseBody
	public String getFolderUsers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getFolderUsers start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String folderId      = request.getParameter("folderId");
		String mode          = request.getParameter("mode") != null ? request.getParameter("mode") : "";
		
		logger.debug("Folder Id: " + folderId + " || mode: " + mode);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/folder-users/" + folderId;
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("mode", mode);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getFolderUsers end");
		return resultBody.toString();
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezWebFolder/addCompanyFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String addCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("addCompanyFolder start");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, userInfo.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String folderId        = request.getParameter("folderId");
		String folderName      = request.getParameter("folderName");
		String folderName2     = request.getParameter("folderName2");
		String folderUsers     = request.getParameter("folderUsers");
		
		logger.debug("Folder Id: " + folderId + " || Folder Name1: " + folderName + " || Folder Name2: " + folderName2 + " || Folder users: " + folderUsers);
		
		String gwServerUrl     = config.getProperty("config.webFolderGwServerURL");
		String url             = gwServerUrl + "/rest/ezwebfolderadmin/folders/comp";
		JSONObject jsonObject  = new JSONObject();
		
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("pFolderId", folderId);
		jsonObject.put("fName", folderName);
		jsonObject.put("fName2", folderName2);
		jsonObject.put("fUsers", folderUsers);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(jsonObject, headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("addCompanyFolder end");
		return resultBody.toString();
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezWebFolder/changeCompanyFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String changeCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("changeCompanyFolder start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String folderId       = request.getParameter("folderId");
		String folderName     = request.getParameter("folderName");
		String folderName2    = request.getParameter("folderName2");
		String folderUsers    = request.getParameter("folderUsers");
		
		logger.debug("Folder Id: " + folderId + " || Folder Name1: " + folderName + " || Folder Name2: " + folderName2 + " || Folder users: " + folderUsers);
		
		String gwServerUrl    = config.getProperty("config.webFolderGwServerURL");
		String url            = gwServerUrl + "/rest/ezwebfolderadmin/folders/" + folderId + "/comp";
		JSONObject jsonObject = new JSONObject();
		
		jsonObject.put("userId", user.getId());
		jsonObject.put("fName", folderName);
		jsonObject.put("fName2", folderName2);
		jsonObject.put("fUsers", folderUsers);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(jsonObject, headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		logger.debug("changeCompanyFolder end");
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/delCompanyFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("deleteCompanyFolder start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String folderId      = request.getParameter("folderId");
		
		logger.debug("Folder Id: " + folderId);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/folders/" + folderId;
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId());
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("deleteCompanyFolder end");
		return resultBody.toString();
	}	

	@RequestMapping(value="/admin/ezWebFolder/getFileList.do", method = RequestMethod.POST)
	@ResponseBody
	public String getFileList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getFileList start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String currPage    = request.getParameter("currentPage");
		String startDate   = request.getParameter("startDate");
		String endDate     = request.getParameter("endDate");
		String fileExt     = request.getParameter("fileExt");
		String fileName    = request.getParameter("fileName");
		String userName    = request.getParameter("userName");
		String fileType    = request.getParameter("fileType");
		String folderId    = request.getParameter("folderId");
		String column      = request.getParameter("column");
		String order       = request.getParameter("order");
		String listCnt     = request.getParameter("listCntSize");
		
		logger.debug("Current page: " + currPage + " || StartDate: " + startDate + " || EndDate: " + endDate + " || File ext: " + fileExt + " || File Name: " + fileName + " || User name: " + userName + " || File type: " + fileType + " || Folder Id: " + folderId + " || Column: " + column + " || Order: " + order + " || listCount: " + listCnt);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolderadmin/folders/" + folderId + "/file-list";
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("startDate", startDate)
										.queryParam("fileExt", fileExt)
										.queryParam("fileName", fileName)
										.queryParam("userName", userName)
										.queryParam("fileType", fileType)
										.queryParam("currentPage", currPage)
										.queryParam("column", column)
										.queryParam("order", order)
										.queryParam("listCnt", listCnt)
										.queryParam("endDate", endDate);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getFileList end");
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/moveFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String moveFolder(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("moveFolder start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String folderId     = request.getParameter("folderId");
		String parentFld    = request.getParameter("parentFldId");
		String mode         = request.getParameter("mode");
		
		logger.debug("Folder Id: " + folderId + " || Parent folderId: " + parentFld + " || mode: " + mode);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolderadmin/folders/" + folderId + "/modes/" + mode+ "/folder-move";
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
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
		
		logger.debug("moveFolder end");
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/targetSelect.do")
	public String selectTarget(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("selectTarget start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		String companyId     = request.getParameter("company");
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-id/" + user.getId();
		
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
			model.addAttribute("primary", (String) resultBody.get("primary"));
		}
		
		
		logger.debug("CompanyId: " + companyId);
		
		model.addAttribute("pCompanyID", companyId);
		
		logger.debug("selectTarget end");
		return "admin/ezWebFolder/targetSelect";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminDeptFolder.do")
	public String webfolderDeptFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderDeptFolder start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
		
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
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
			model.addAttribute("primary", (String) resultBody.get("primary"));
		}
		
		logger.debug("webfolderDeptFolder end");
		return "admin/ezWebFolder/webfolderDeptFolder";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezWebFolder/addDeptFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String addDeptFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("addDeptFolder start");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, userInfo.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String folderId        = request.getParameter("folderId");
		String folderName      = request.getParameter("folderName");
		String folderName2     = request.getParameter("folderName2");
		
		logger.debug("FolderId: " + folderId + " || Folder Name1: " + folderName + " || Folder Name2: " + folderName2);
		
		String gwServerUrl     = config.getProperty("config.webFolderGwServerURL");
		String url             = gwServerUrl + "/rest/ezwebfolderadmin/folders/dept";
		JSONObject jsonObject  = new JSONObject();
		
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("pFolderId", folderId);
		jsonObject.put("fName", folderName);
		jsonObject.put("fName2", folderName2);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(jsonObject, headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("addDeptFolder end");
		return resultBody.toString();
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezWebFolder/changeDepartFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String changeDeptFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("changeDeptFolder start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String folderId       = request.getParameter("folderId");
		String folderName     = request.getParameter("folderName");
		String folderName2    = request.getParameter("folderName2");
		
		logger.debug("Folder Id: " + folderId + " || Folder Name: " + folderName + " || Folder Name2: " + folderName2);
		
		String gwServerUrl    = config.getProperty("config.webFolderGwServerURL");
		String url            = gwServerUrl + "/rest/ezwebfolderadmin/folders/" + folderId + "/dept";
		JSONObject jsonObject = new JSONObject();
		
		jsonObject.put("userId", user.getId());
		jsonObject.put("fName", folderName);
		jsonObject.put("fName2", folderName2);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(jsonObject, headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("changeDeptFolder end");
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/makeCompanyFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String makeCompFolder(@CookieValue("loginCookie") String loginCookie,  Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("makeCompFolder start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String companyId    = request.getParameter("companyId");
		
		logger.debug("CompanyId: " + companyId);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolderadmin/company-folder/" + companyId;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity          = new HttpEntity<>(headers);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("makeCompFolder end");
		return resultBody.toString();
	}

	@RequestMapping(value="/admin/ezWebFolder/makeDeptFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String makeDeptFolders(@CookieValue("loginCookie") String loginCookie,  Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("makeDeptFolders start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String companyId    = request.getParameter("companyId");
		
		logger.debug("CompanyId: " + companyId);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolderadmin/dept-folder/" + companyId;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity          = new HttpEntity<>(headers);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("makeDeptFolders end");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/admin/ezWebFolder/checkValidDept.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkValidDept(@CookieValue("loginCookie") String loginCookie,  Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("checkValidDept start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String folderId     = request.getParameter("folderId");
		
		logger.debug("Folder Id: " + folderId);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolderadmin/dept-check/" + folderId;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity          = new HttpEntity<>(headers);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("checkValidDept end");
		return resultBody.toString();
	}
	
	private JSONObject checkWfAdmin(HttpServletRequest request, String userId) throws ParseException {
		logger.debug("checkWfAdmin start");
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolder/check-wfadmin/" + userId;
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("checkWfAdmin end");
		return resultBody;
	}
	
	@RequestMapping(value="/admin/ezWebFolder/exportFileLogs.do", method = RequestMethod.POST)
	@ResponseBody
	public String exportFileLogs(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("exportFileLogs start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck.toString();
		}
		
		String companyId     = request.getParameter("companyId");
		String column        = request.getParameter("column");
		String order         = request.getParameter("order");
		String startDate     = request.getParameter("startDate")  != null ? request.getParameter("startDate")  : "";
		String endDate       = request.getParameter("endDate")    != null ? request.getParameter("endDate")    : "";
		String fileExt       = request.getParameter("fileExt")    != null ? request.getParameter("fileExt")    : "";
		String fileName      = request.getParameter("fileName")   != null ? request.getParameter("fileName")   : "";
		String userName      = request.getParameter("userName")   != null ? request.getParameter("userName")   : "";
		String fileType      = request.getParameter("fileType")   != null ? request.getParameter("fileType")   : "";
		String actionType    = request.getParameter("actionType") != null ? request.getParameter("actionType") : "";
		
		logger.debug("CompanyId: " + companyId + " Column: " + column + " || order: " + order + " || StartDate: " + startDate + " || EndDate: " + endDate + " || File ext: " + fileExt + " || File Name: " + fileName + " || User Name: " + userName + " || File type: " + fileType + " || Action Type: " + actionType);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/export-logs";
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("companyId", companyId)
										.queryParam("startDate", startDate)
										.queryParam("fileExt", fileExt)
										.queryParam("fileName", fileName)
										.queryParam("fileType", fileType)
										.queryParam("userName", userName)
										.queryParam("column", column)
										.queryParam("order", order)
										.queryParam("actionType", actionType)
										.queryParam("endDate", endDate);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("exportFileLogs end");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/admin/ezWebFolder/downloadExcel.do")
	public void downloadExcelReport(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadExcelReport start");
		String fileName    = request.getParameter("fileName");
		
		logger.debug("File Name: " + fileName);
		
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/download-excel";
		
		UriComponentsBuilder builder    = UriComponentsBuilder.fromHttpUrl(url)
											.queryParam("fileName", fileName)
											.queryParam("userAgent", request.getHeader("User-Agent"));
		RestTemplate rest               = new RestTemplate();
		RequestCallback requestCallback = new RequestCallback() {
			@Override
			public void doWithRequest(ClientHttpRequest req) throws IOException {
				req.getHeaders().setAccept(Arrays.asList(MediaType.APPLICATION_OCTET_STREAM, MediaType.ALL));
				req.getHeaders().set("host-name", request.getServerName());
			}
		};
		
		// Streams the response instead of loading it all in memory
		ResponseExtractor<Void> responseExtractor = res -> {
			response.setHeader("Content-Type", "application/zip");
			response.setHeader("Content-Disposition", res.getHeaders().get("Content-Disposition").get(0));
			
			IOUtils.copy(res.getBody(), response.getOutputStream());
			
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
			return null;
		};
		
		rest.execute(builder.build().encode().toUri(), HttpMethod.GET, requestCallback, responseExtractor);
		
		logger.debug("downloadExcelReport end");
	}
	
	/**
	 * 웹폴더관리자 상단 Top Frame - 2018-05-08 장진혁
	 */
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminTop.do")
	public String webfolderAdminTop() throws Exception {
		logger.debug("webfolderAdminTop started");		
		
		logger.debug("webfolderAdminTop ended");
		
		return "admin/ezWebFolder/webfolderAdminTop";		
	}
}