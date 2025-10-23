package egovframework.ezEKP.ezWebFolder.web;

import static org.apache.commons.lang3.StringUtils.defaultString;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.rest.Rest;
import egovframework.let.utl.rest.Rest.Module;
import egovframework.let.utl.rest.Result;

@Controller
public class EzWebFolderAdminController extends EzFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderAdminController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name = "EzWebFolderAdminService")
	private EzWebFolderAdminService ezWebFolderAdminService;

	@Resource(name = "EzWebFolderService")
	private EzWebFolderService ezWebFolderService;

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Autowired
	private EzCommonService ezCommonService;

	@Autowired
	private EzOrganService ezOrganService;

	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzNotificationService ezNotificationService;
	
	@Autowired
	private EzPersonalService ezPersonalService;

	@Autowired
	private Rest rest;

	@RequestMapping(value = "/admin/ezWebFolder/webFolderMain.do", method = RequestMethod.GET)
	public String webFolderMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("webFolderMain start");
		
		logger.debug("webFolderMain end");
		return "admin/ezWebFolder/webFolderMain";
	}
	
	@RequestMapping(value = "/admin/ezWebFolder/webFolderConfig.do", method = RequestMethod.GET)
	public String webFolderConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("webFolderConfig start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("webFolderConfig end");
		
		return "admin/ezWebFolder/webfolderConfig";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminLeft.do", method = RequestMethod.GET)
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
		headers.set("x-user-host", request.getServerName());
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
		
		model.addAttribute("lang", user.getLang());
		logger.debug("webfolderAdminLeft end");
		return "admin/ezWebFolder/webfolderAdminLeft";
	}

	@RequestMapping(value="/admin/ezWebFolder/deleteFolderConfirm.do", method = RequestMethod.GET)
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
	
	@RequestMapping(value="/admin/ezWebFolder/recycleBin.do", method = RequestMethod.GET)
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
	
	@RequestMapping(value="/admin/ezWebFolder/folderMoveConfirm.do", method = RequestMethod.GET)
	public String folderMoveConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("folderMoveConfirm start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		String folderId      = request.getParameter("folderId")   	!= null ? request.getParameter("folderId") 		: "";
		String folderType    = request.getParameter("folderType")   != null ? request.getParameter("folderType") 	: "";
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
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
			model.addAttribute("folderType", folderType);
		}
		
		model.addAttribute("folderId", folderId);
		logger.debug("folderMoveConfirm end");
		
		return "admin/ezWebFolder/folderMove";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminRight.do", method = RequestMethod.GET)
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
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			boolean isAdminMode   = (boolean) resultBody.get("isAdminMode");
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("isAdminMode", isAdminMode);
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
		}
		
		logger.debug("webfolderAdminRight end");
		return "admin/ezWebFolder/webfolderCompanyConfig";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminPersonal.do", method = RequestMethod.GET)
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
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			boolean isAdminMode   = (Boolean) resultBody.get("isAdminMode");
			String companyId      = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("isAdminMode", isAdminMode);
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
		}
		
		logger.debug("webfolderAdminPersonal end");
		return "admin/ezWebFolder/webfolderPersonalConfig";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminCompanyFolder.do", method = RequestMethod.GET)
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
		headers.set("x-user-host", request.getServerName());
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
			model.addAttribute("isAdminMode", (boolean) resultBody.get("isAdminMode"));
			model.addAttribute("useKlib", (boolean) resultBody.get("useKlib"));
		}
		
		logger.debug("webfolderCompanyFolder end");
		return "admin/ezWebFolder/webfolderCompanyFolder";
	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminCompanyFile.do", method = RequestMethod.GET)
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
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String companyId      = (String) resultBody.get("userCompany");
			String compId  		  = selectedComp.equals("") ? companyId : selectedComp;
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", compId);
			model.addAttribute("companyId", compId);
			model.addAttribute("list", companyList);
			model.addAttribute("primary", (String) resultBody.get("primary"));
			model.addAttribute("folderId", folderId);
			model.addAttribute("rootFolder", rootFolder);
			model.addAttribute("useVersionHistory", (boolean) resultBody.get("useVersionHistory"));
		}
		
		resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/" + user.getId() + "/upload-limit", null, request, "get", null);

		if ("ok".equals(resultBody.get("status"))) {
			model.addAttribute("uploadLimit", (double) resultBody.get("uploadLimit"));
		} else {
			model.addAttribute("uploadLimit", -1);
		}

		model.addAttribute("level", level);

		/*boolean usePreview = "1".equalsIgnoreCase(commonUtil.getTenantConfigRest("useImageConvertServer", user.getId(), request));
		model.addAttribute("usePreview", usePreview);*/

		logger.debug("webfolderCompanyFile end");
		return "admin/ezWebFolder/webfolderCompanyFile";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminDeptFile.do", method = RequestMethod.GET)
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
		headers.set("x-user-host", request.getServerName());
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
			model.addAttribute("useVersionHistory", (boolean) resultBody.get("useVersionHistory"));
		}
		
		model.addAttribute("level", level);

		/*boolean usePreview = "1".equalsIgnoreCase(commonUtil.getTenantConfigRest("useImageConvertServer", user.getId(), request));
		model.addAttribute("usePreview", usePreview);*/

		logger.debug("webfolderDeptFile end");
		return "admin/ezWebFolder/webfolderDeptFile";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminFileHistory.do", method = RequestMethod.GET)
	public String webfolderFileHistory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderFileHistory start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String adminFlag = request.getParameter("adminFlag") == null ? "admin" : request.getParameter("adminFlag");
		logger.debug("adminFlag:" + adminFlag);

		// 2024.05.08 장혜연 : adminFlag값이 user 일 경우 담당하는 그룹폴더가 존재하는 지 확인
		if (adminFlag.equals("user")) {
			if (ezWebFolderAdminService
					.getFolderIdsByManagerUserId(user.getId(), "", user.getCompanyID(), user.getTenantId()).size() <= 0)
				return "cmm/error/adminDenied";
		} else {
			if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
				return "cmm/error/adminDenied";
			}
		}

		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
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
		
		if (adminFlag.equalsIgnoreCase("user")) {
			Result result2 = this.rest.gateway(Module.WEBFOLDER, request)
					.url("/rest/ezwebfolder/check-folderManager/" + user.getId()).exchangeResult();

			if (result2.succeeded()) {
				model.addAttribute("folderListMap", result2.getDataAsJsonObject().get("folderListMap").getAsJsonArray());
			}
		}
		
		model.addAttribute("adminFlag", adminFlag);
		
		logger.debug("webfolderFileHistory end");
		return "admin/ezWebFolder/webfolderFileHistory";
	}

	@RequestMapping(value="/admin/ezWebFolder/saveConfig.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject saveConfig(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("saveConfig start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		JSONParser jp = new JSONParser();
		JSONObject resultBody = new JSONObject();
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
		}
		
		String companyLimit = request.getParameter("companyLimit");
		String departmentLimit = request.getParameter("departmentLimit");
		String userLimit = request.getParameter("userLimit");
		String uploadLimit   = request.getParameter("uploadLimit");
		String companyId     = request.getParameter("companyId");
		
		logger.debug("companyLimit: {}, companyLimit: {},: {}, userLimit: {}, uploadLimit: {}, companyId: {}", companyLimit, departmentLimit, userLimit, uploadLimit, companyId);

		if (StringUtils.isNotEmpty(uploadLimit) && StringUtils.isNotEmpty(departmentLimit) && StringUtils.isNotEmpty(userLimit)) {

			if (Float.compare(Float.parseFloat(uploadLimit),Float.parseFloat(departmentLimit)) > 0 && Float.compare(Float.parseFloat(uploadLimit),Float.parseFloat(userLimit)) > 0) {

				resultBody  = (JSONObject) jp.parse("{\"code\":\"4\"}");
				
				return resultBody;
			}
		}
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/default/capacity/" + companyId;
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("companyLimit", companyLimit)
										.queryParam("departmentLimit", departmentLimit)
										.queryParam("userLimit", userLimit)
										.queryParam("uploadLimit", uploadLimit);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		resultBody                    = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("saveConfig end");
		return resultBody;
	}

	@RequestMapping(value="/admin/ezWebFolder/getConfig.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getConfig start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
		}
		
		String companyId     = request.getParameter("companyId");
		
		logger.debug("companyId: {}", companyId);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/default/capacity";
		
		if (companyId != null && !companyId.isEmpty()) {
			url += "/" + companyId;
		}
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity          = new HttpEntity<>(headers);
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getConfig end");
		
		return resultBody;
	}

	@RequestMapping(value="/admin/ezWebFolder/getCapacities.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getCapacities start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
		}
		
		String type          = request.getParameter("type");
		String currPage      = request.getParameter("currentPage");
		String searchStr     = request.getParameter("searchStr");
		String searchOpt     = request.getParameter("searchOpt");
		String companyId     = request.getParameter("companyId");
		String column      = request.getParameter("column");
		String order       = request.getParameter("order");
		
		logger.debug("Current page: " + currPage + " || Search String: " + searchStr + " || Search Operation: " + searchOpt + " || CompanyId: " + companyId + " || Column: " + column + " || Order: " + order);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/capacity/" + getCapacityURL(type);
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		LoginVO userInfo = commonUtil.getUserForGw(user.getId(), request.getServerName());
		String primary   = userInfo.getPrimary();

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("type", type)
										.queryParam("companyId", companyId)
										.queryParam("searchKeyword", searchStr)
										.queryParam("searchOption", searchOpt)
										.queryParam("column", column)
										.queryParam("order", order)
										.queryParam("primary", primary)
										.queryParam("currentPage", currPage);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getCapacities end");
		return resultBody;
	}

	@RequestMapping(value="/admin/ezWebFolder/updateCapacities.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject updateCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam(value = "list") List<String> list, Model model, HttpServletResponse response) throws Exception {
		logger.debug("updateCapacities start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
		}
		
		String type = request.getParameter("type");
		String value = request.getParameter("value");
		String companyId       = request.getParameter("companyId");
		
		logger.debug("type: {}, value: {}, companyId: {}, list: {}", type, value, companyId, String.join(",", list));
		
		String gwServerUrl     = config.getProperty("config.webFolderGwServerURL");
		String url             = gwServerUrl + "/rest/ezwebfolderadmin/capacity/" + getCapacityURL(type);
				
		HttpHeaders headers    = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity   = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("value", value)
										.queryParam("companyId", companyId)
										.queryParam("list", String.join(",", list));
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("updateCapacities end");
		return resultBody;
	}

	@RequestMapping(value="/admin/ezWebFolder/restoreCapacities.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject restoreCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam(value = "list") List<String> list, HttpServletResponse response, Model model) throws Exception {
		logger.debug("restoreCapacities start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
		}
		
		String type          = request.getParameter("type");
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/capacity/reset/" + getCapacityURL(type);
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("list", String.join(",", list));
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("restoreCapacities end");
		return resultBody;
	}
	
	private String getCapacityURL(String type) {
		switch (type) {
		case "C":
			return "companies";
		case "D":
			return "departments";
		case "U":
			return "users";
		}

		return type;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezWebFolder/getFileLogs.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getFileLogs(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFileLogs start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		String adminFlag     = defaultString(request.getParameter("adminFlag"));
		
		// 2024.05.08 장혜연 : adminFlag값이 user 일 경우 담당하는 그룹폴더가 존재하는 지 확인
		if (adminFlag.equals("user")) {
			if (ezWebFolderAdminService
					.getFolderIdsByManagerUserId(user.getId(), "", user.getCompanyID(), user.getTenantId())
					.size() <= 0) {
				JSONObject resultCheck = new JSONObject();
				resultCheck.put("code", 3);
				return resultCheck;
			}
		} else {
			JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());

			if (!resultCheck.get("status").toString().equals("ok")) {
				return resultCheck;
			}
		}

		String currPage      = request.getParameter("currentPage");
		String companyId     = request.getParameter("companyId");
		String column        = request.getParameter("column");
		String order         = request.getParameter("order");
		String listCnt       = request.getParameter("listCntSize");
		String startDate     = defaultString(request.getParameter("startDate"));
		String endDate       = defaultString(request.getParameter("endDate"));
		String fileExt       = defaultString(request.getParameter("fileExt"));
		String fileName      = defaultString(request.getParameter("fileName"));
		String userName      = defaultString(request.getParameter("userName"));
		String fileType      = defaultString(request.getParameter("fileType"));
		String actionType    = defaultString(request.getParameter("actionType"));
		String sortType    	 = defaultString(request.getParameter("sortType"));
		String sortColumn    = defaultString(request.getParameter("sortColumn"));
		String folderId      = defaultString(request.getParameter("folderId"));
		
		logger.debug("Current page: " + currPage + " || CompanyId: " + companyId + " || Column: " + column + " || Order: " + order + " || ListCount: " + listCnt + " || StartDate: " + startDate 
				+ " || EndDate: " + endDate + " || File ext: " + fileExt + " || File Name: " + fileName + " || UserName: " + userName 
				+ " || File Type: " + fileType + " || Action Type: " + actionType + " || folderId:" + folderId);
		
		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolderadmin/filehistorylist")
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
				.queryParam("endDate", endDate)
				.queryParam("sortType", sortType)
				.queryParam("sortColumn", sortColumn)
				.queryParam("adminFlag", adminFlag)
				.queryParam("folderId", folderId)
				.exchangeBody();

		logger.debug("getFileLogs end");
		return resultBody;
	}

	@RequestMapping(value="/admin/ezWebFolder/getAdminList.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject webfolderAdminList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderAdminList start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
		}
		
		
		String pageNum      = request.getParameter("pageNum");
		String pageSize     = request.getParameter("pageSize");
		String companyID    = request.getParameter("companyID");
		
		logger.debug("Current page: " + pageNum + " || ListCount: " + pageSize +  " || CompanyId: " + companyID);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolderadmin/webfolderadmin-list";
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
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
		return resultBody;
	}
	
	@RequestMapping(value="/admin/ezWebFolder/getDepartFolderTree.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject getDepartmentFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getDepartmentFolderTree start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String companyId     = request.getParameter("companyId");
		String folderId      = request.getParameter("folderId");
		
		logger.debug("CompanyId: " + companyId + " || Folder Id: " + folderId);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/foldersTree/dept";
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
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
		return resultBody;
	}
	
	@RequestMapping(value="/admin/ezWebFolder/getCompanyFolderTree.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject getCompanyFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getCompanyFolderTree start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String companyId     = request.getParameter("companyId");
		String folderId      = request.getParameter("folderId");
		
		logger.debug("CompanyId: " + companyId + " || FolderId: " + folderId);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/foldersTree/comp";
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
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
		return resultBody;
	}

	@RequestMapping(value="/admin/ezWebFolder/getSubFolderTree.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject getSubFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getSubFolderTree start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String folderId      = request.getParameter("folderId");
		String mode          = request.getParameter("mode");
		String type          = request.getParameter("type");
		String adminCheck    = request.getParameter("adminCheck")   != null ? request.getParameter("adminCheck")  : mode;
		
		logger.debug("FolderId: " + folderId + " || mode: " + mode);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/subfolder-tree/" + folderId;
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("mode", mode)
										.queryParam("type", type)
										.queryParam("adminCheck", adminCheck);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getSubFolderTree end");
		return resultBody;
	}

	@RequestMapping(value="/admin/ezWebFolder/getFolderUsers.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getFolderUsers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getFolderUsers start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		String folderId = request.getParameter("folderId");
		/*
		JSONObject permissionCheck = (JSONObject) checkPermissions(request, folderId, null, user.getId());
		
		if ("error".equals(permissionCheck.get("status"))) {
		*/
		Map<String, Object> permissionParams = new HashMap<>();
		permissionParams.put("folderList", folderId);
		
		// 제어권한 (관리자, 담당자, 만든이)
		JSONObject permissionCheck = (JSONObject) commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/permission-check/" + user.getId(),
				permissionParams, request, "get", null);
		boolean isPermitted = Optional.of(permissionCheck)
				.map(result -> result.get("status").toString())
				.map("ok"::equalsIgnoreCase)
				.orElse(false);
		
		if (!isPermitted) {
			return permissionCheck;
		}
		
		String mode          = request.getParameter("mode") != null ? request.getParameter("mode") : "";
		
		logger.debug("Folder Id: " + folderId + " || mode: " + mode);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/folder-users/" + folderId;
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("mode", mode);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getFolderUsers end");
		return resultBody;
	}
	
	// 폴더 담당자가 각자의 파일별 권한 리스트를 가져오는 로직 
	@RequestMapping(value="/admin/ezWebFolder/getFileUsers.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getFileUsers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getFolderUsers start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		String fileId = request.getParameter("fileId");
		/*
		JSONObject permissionCheck = (JSONObject) checkPermissions(request, null, fileId, user.getId());
		
		if ("error".equals(permissionCheck.get("status"))) {
		*/
		Map<String, Object> permissionParams = new HashMap<>();
		permissionParams.put("fileId", fileId);
		
		// 제어권한 (관리자, 담당자, 만든이)
		JSONObject permissionCheck = (JSONObject) commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/permission-check/" + user.getId(),
				permissionParams, request, "get", null);
		boolean isPermitted = Optional.of(permissionCheck)
				.map(result -> result.get("status").toString())
				.map("ok"::equalsIgnoreCase)
				.orElse(false);
		
		if (!isPermitted) {
			return permissionCheck;
		}
		
		String mode         = request.getParameter("mode") != null ? request.getParameter("mode") : "";
		
		logger.debug("fileId: " + fileId + " || mode: " + mode);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/file-users/" + fileId;
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", user.getId())
				.queryParam("mode", mode);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getFolderUsers end");
		return resultBody;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezWebFolder/addCompanyFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject addCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("addCompanyFolder start");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, userInfo.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
		}
		
		String folderId        = request.getParameter("folderId");
		String folderName      = request.getParameter("folderName");
		String folderName2     = request.getParameter("folderName2");
		String folderUsers     = request.getParameter("folderUsers");
		// 회의실 사용 기간
		String startTime       = request.getParameter("startTime");
		String endTime         = request.getParameter("endTime");
		// 폴더 권한 비상속
		String noInherit       = request.getParameter("noInherit");
		
		logger.debug("Folder Id: " + folderId + " || Folder Name1: " + folderName + " || Folder Name2: " + folderName2 + " || Folder users: " + folderUsers);
		
		String gwServerUrl     = config.getProperty("config.webFolderGwServerURL");
		String url             = gwServerUrl + "/rest/ezwebfolderadmin/folders/comp";
		JSONObject jsonObject  = new JSONObject();
		
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("pFolderId", folderId);
		jsonObject.put("fName", folderName);
		jsonObject.put("fName2", folderName2);
		jsonObject.put("fUsers", folderUsers);
		jsonObject.put("startTime", startTime);
		jsonObject.put("endTime", endTime);
		jsonObject.put("noInherit", noInherit);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(jsonObject, headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("addCompanyFolder end");
		return resultBody;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezWebFolder/changeCompanyFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject changeCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("changeCompanyFolder start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		// 2020-12-08 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
		String folderManager   = request.getParameter("folderManager") != null ? request.getParameter("folderManager") : "";
		
		if (!resultCheck.get("status").toString().equals("ok") && !folderManager.equals("1")) {
			return resultCheck;
		}
		
		String folderId       = request.getParameter("folderId");
		String folderName     = request.getParameter("folderName");
		String folderName2    = request.getParameter("folderName2");
		String folderUsers    = request.getParameter("folderUsers");
		String encryption     = request.getParameter("encryption");
		String addUser     	  = request.getParameter("addUser");
		String deleteUser     = request.getParameter("deleteUser");
		String subFolderType  = request.getParameter("subFolderType");
		// 2020-12-09 김은실 - (카이스트)회사 폴더별 관리자 지원 기능
		String addUserManager = request.getParameter("addUserManager");
		String deleteUserManager = request.getParameter("deleteUserManager");
		// 회의실 사용 기간
		String startTime      = request.getParameter("startTime");
		String endTime        = request.getParameter("endTime");
		// 폴더 권한 비상속
		String noInherit      = request.getParameter("noInherit");
		
		logger.debug("Folder Id:" + folderId + ",Folder Name1:" + folderName + ",Folder Name2:" + folderName2 
				+ ",Folder users:" + folderUsers + ",addUser:" + addUser + ",deleteUser:" + deleteUser + ",subFolderType:" + subFolderType
				 + ",addUserManager:" + addUserManager + ",deleteUserManager:" + deleteUserManager);
		
		String gwServerUrl    = config.getProperty("config.webFolderGwServerURL");
		String url            = gwServerUrl + "/rest/ezwebfolderadmin/folders/" + folderId + "/comp";
		JSONObject jsonObject = new JSONObject();
		
		jsonObject.put("userId", user.getId());
		jsonObject.put("fName", folderName);
		jsonObject.put("fName2", folderName2);
		jsonObject.put("fUsers", folderUsers);
		jsonObject.put("encryption", encryption);
		jsonObject.put("addUser", addUser);
		jsonObject.put("deleteUser", deleteUser);
		jsonObject.put("addUserManager", addUserManager);
		jsonObject.put("deleteUserManager", deleteUserManager);
		jsonObject.put("subFolderType", subFolderType);
		jsonObject.put("startTime", startTime);
		jsonObject.put("endTime", endTime);
		jsonObject.put("noInherit", noInherit);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(jsonObject, headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		logger.debug("changeCompanyFolder end");
		return resultBody;
	}

	@RequestMapping(value="/admin/ezWebFolder/delCompanyFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject deleteCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("deleteCompanyFolder start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
		}
		
		String folderId      = request.getParameter("folderId");
		
		logger.debug("Folder Id: " + folderId);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/folders/" + folderId;
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId());
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("deleteCompanyFolder end");
		return resultBody;
	}	

	@RequestMapping(value="/admin/ezWebFolder/getFileList.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getFileList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getFileList start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
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
		String sortType    = request.getParameter("sortType");
		String sortColumn    = request.getParameter("sortColumn");
		
		logger.debug("Current page: " + currPage + " || StartDate: " + startDate + " || EndDate: " + endDate + " || File ext: " + fileExt + " || File Name: " + fileName + " || User name: " + userName + " || File type: " + fileType + " || Folder Id: " + folderId + " || Column: " + column + " || Order: " + order + " || listCount: " + listCnt);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolderadmin/folders/" + folderId + "/file-list2";
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
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
										.queryParam("endDate", endDate)
										.queryParam("sortType", sortType)
										.queryParam("sortColumn", sortColumn);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getFileList end");
		return resultBody;
	}

	@RequestMapping(value="/admin/ezWebFolder/moveFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject moveFolder(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("moveFolder start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
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
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity          = new HttpEntity<>(headers);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("moveFolder end");
		return resultBody;
	}

//	
//	@RequestMapping(value="/admin/ezWebFolder/targetSelect.do", method = RequestMethod.GET)
//	public String selectTarget(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
//		logger.debug("selectTarget start");
//		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
//		
//		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok")) {
//			return "cmm/error/adminDenied";
//		}
//		
//		String companyId     = request.getParameter("company");
//		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
//		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-id/" + user.getId();
//		
//		HttpHeaders headers  = new HttpHeaders();
//		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
//		headers.set("x-user-host", request.getServerName());
//		HttpEntity<?> entity = new HttpEntity<>(headers);
//		
//		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
//		RestTemplate rest             = new RestTemplate();
//		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
//		
//		JSONParser jp                 = new JSONParser();
//		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
//		String status                 = resultBody.get("status").toString();
//		
//		if (status.equals("ok")) {
//			model.addAttribute("primary", (String) resultBody.get("primary"));
//		}
//		
//		
//		logger.debug("CompanyId: " + companyId);
//		
//		model.addAttribute("pCompanyID", companyId);
//		
//		logger.debug("selectTarget end");
//		return "admin/ezWebFolder/targetSelect";
//	}

	@RequestMapping(value="/admin/ezWebFolder/webfolderAddMemberList.do", method = RequestMethod.GET)
	public String webfolderAddMemberList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderDeptFolder start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		// 2020-12-10 김은실 - (카이스트)회사 폴더별 관리자 지원 기능  : 사용자화면(:담당자)
		Boolean isManager        = Boolean.valueOf(request.getParameter("isManager"));		//false : Boolean.valueOf(null, "", "false", "1", "abc")
		
		if (!checkWfAdmin(request, user.getId()).get("status").toString().equals("ok") && !isManager) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("webfolderDeptFolder end");
		return "admin/ezWebFolder/webfolderAddMemberList";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminDeptFolder.do", method = RequestMethod.GET)
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
		headers.set("x-user-host", request.getServerName());
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
			model.addAttribute("isAdminMode", (boolean) resultBody.get("isAdminMode"));
			model.addAttribute("useKlib", (boolean) resultBody.get("useKlib"));
		}
		
		logger.debug("webfolderDeptFolder end");
		return "admin/ezWebFolder/webfolderDeptFolder";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezWebFolder/addDeptFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject addDeptFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("addDeptFolder start");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, userInfo.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
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
		headers.set("x-user-host", request.getServerName());
		HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(jsonObject, headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("addDeptFolder end");
		return resultBody;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezWebFolder/changeDepartFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject changeDeptFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("changeDeptFolder start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
		}
		
		String folderId       = request.getParameter("folderId");
		String folderName     = request.getParameter("folderName");
		String folderName2    = request.getParameter("folderName2");
		String encryption     = request.getParameter("encryption");
		
		logger.debug("Folder Id: " + folderId + " || Folder Name: " + folderName + " || Folder Name2: " + folderName2);
		
		String gwServerUrl    = config.getProperty("config.webFolderGwServerURL");
		String url            = gwServerUrl + "/rest/ezwebfolderadmin/folders/" + folderId + "/dept";
		JSONObject jsonObject = new JSONObject();
		
		jsonObject.put("userId", user.getId());
		jsonObject.put("fName", folderName);
		jsonObject.put("fName2", folderName2);
		jsonObject.put("encryption", encryption);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(jsonObject, headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("changeDeptFolder end");
		return resultBody;
	}

	@RequestMapping(value="/admin/ezWebFolder/makeCompanyFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject makeCompFolder(@CookieValue("loginCookie") String loginCookie,  Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("makeCompFolder start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
		}
		
		String companyId    = request.getParameter("companyId");
		
		logger.debug("CompanyId: " + companyId);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolderadmin/company-folder/" + companyId;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity          = new HttpEntity<>(headers);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("makeCompFolder end");
		return resultBody;
	}

	@RequestMapping(value="/admin/ezWebFolder/makeDeptFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject makeDeptFolders(@CookieValue("loginCookie") String loginCookie,  Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("makeDeptFolders start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
		}
		
		String companyId    = request.getParameter("companyId");
		
		logger.debug("CompanyId: " + companyId);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolderadmin/dept-folder/" + companyId;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity          = new HttpEntity<>(headers);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("makeDeptFolders end");
		return resultBody;
	}
	
	@RequestMapping(value="/admin/ezWebFolder/checkValidDept.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject checkValidDept(@CookieValue("loginCookie") String loginCookie,  Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("checkValidDept start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());
		
		if (!resultCheck.get("status").toString().equals("ok")) {
			return resultCheck;
		}
		
		String folderId     = request.getParameter("folderId");
		
		logger.debug("Folder Id: " + folderId);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolderadmin/dept-check/" + folderId;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity          = new HttpEntity<>(headers);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("checkValidDept end");
		return resultBody;
	}
	
	private JSONObject checkWfAdmin(HttpServletRequest request, String userId) throws ParseException {
		logger.debug("checkWfAdmin start");
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolder/check-wfadmin/" + userId;
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("checkWfAdmin end");
		return resultBody;
	}
	
	private JSONObject checkPermissions(HttpServletRequest request, String folderIdList, String fileIdList, String userId) throws ParseException {
		logger.debug("checkPermissions start");

		Map<String, Object> permissionParams = new HashMap<>();
		permissionParams.put("folderList", Optional.ofNullable(folderIdList).orElse(""));
		permissionParams.put("fileList", Optional.ofNullable(fileIdList).orElse(""));
		permissionParams.put("adminCheck", true);

		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userId + "/checkpermissions",
				null, request, "post", new JSONObject(permissionParams));

		logger.debug("checkPermissions end");
		return resultBody;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezWebFolder/exportFileLogs.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject exportFileLogs(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("exportFileLogs start");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		String adminFlag     = request.getParameter("adminFlag")  != null ? request.getParameter("adminFlag")  : "";

		// 2024.05.08 장혜연 : adminFlag값이 user 일 경우 담당하는 그룹폴더가 존재하는 지 확인
		if (adminFlag.equals("user")) {
			if (ezWebFolderAdminService
					.getFolderIdsByManagerUserId(user.getId(), "", user.getCompanyID(), user.getTenantId())
					.size() <= 0) {
				JSONObject resultCheck = new JSONObject();
				resultCheck.put("code", 3);
				return resultCheck;
			}
		} else {
			JSONObject resultCheck = (JSONObject) checkWfAdmin(request, user.getId());

			if (!resultCheck.get("status").toString().equals("ok")) {
				return resultCheck;
			}
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
		String folderId      = request.getParameter("folderId")   != null ? request.getParameter("folderId")   : "";
		String sortType    	 = request.getParameter("sortType")   != null ? request.getParameter("sortType")   : "";
		String sortColumn    = request.getParameter("sortColumn") != null ? request.getParameter("sortColumn") : "";
		
		logger.debug("CompanyId: " + companyId + " Column: " + column + " || order: " + order + " || StartDate: " + startDate 
				+ " || EndDate: " + endDate + " || File ext: " + fileExt + " || File Name: " + fileName + " || User Name: " + userName 
				+ " || File type: " + fileType + " || Action Type: " + actionType + "||adminFlag:" + adminFlag + "||folderId" + folderId
				+ "||sortType:" + sortType + "||sortColumn:" + sortColumn);
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/export-logs";
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		headers.set("Accept-Language", locale.toString());
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
										.queryParam("endDate", endDate)
										.queryParam("sortType", sortType)
										.queryParam("sortColumn", sortColumn)
										.queryParam("adminFlag", adminFlag)
										.queryParam("folderId", folderId);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("exportFileLogs end");
		return resultBody;
	}
	
	@RequestMapping(value="/admin/ezWebFolder/downloadExcel.do", method = RequestMethod.GET)
	@ResponseBody
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
				req.getHeaders().set("x-user-host", request.getServerName());
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
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminTop.do", method = RequestMethod.GET)
	public String webfolderAdminTop() throws Exception {
		logger.debug("webfolderAdminTop started");
		
		logger.debug("webfolderAdminTop ended");
		
		return "admin/ezWebFolder/webfolderAdminTop";
	}

	/**
	 * 웹폴더 개설 신청 이력 조회 페이지 호출
	 */
	@RequestMapping(value="/admin/ezWebFolder/applicationHistoryMain.do", method = RequestMethod.GET)
	public String webfolderApplicationHistoryMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("webfolderApplicationHistoryMain started.");
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String companyId = user.getCompanyID();
		String userRoll = user.getRollInfo();
		if (!(userRoll.contains("c=1") || userRoll.contains("k=1") || userRoll.contains("f=1"))) {
			return "cmm/error/adminDenied";
		}
		
		// get companyList, companyId, isAdminMode
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url).queryParam("mode", "admin");
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();

		JSONArray companyList = new JSONArray();
		if (status.equals("ok")) {
			companyList = (JSONArray) resultBody.get("data");
		} 
		// end companyList, companyId, isAdminMode
		
		model.addAttribute("userCompany", companyId);
		model.addAttribute("list", companyList);

		logger.debug("webfolderApplicationHistoryMain ended.");
		return "admin/ezWebFolder/webfolderApplicationHistory";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/getApplicationHistoryList.do", method = RequestMethod.POST, produces="application/json;charset=utf8")
	@ResponseBody
	@SuppressWarnings("unchecked")
	public JSONObject getApplicationHistoryList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("getApplicationHistoryList started.");

		LoginVO user = commonUtil.userInfo(loginCookie);
		String userCompanyId = user.getCompanyID();
		int tenantId = user.getTenantId();
		
		String reStatus = "ERROR";
		int reTotalSize = 0;
		String reHistoryList = "[]";
		
		String companyId = request.getParameter("companyId");
		companyId = companyId.trim().equals("") ? userCompanyId : companyId;
		String pageNum = request.getParameter("pageNum");
		String pageListSize = request.getParameter("pageListSize");
		logger.debug("companyId=" + companyId + ", tenantId=" + tenantId
				 + ", pageNum=" + pageNum + ", pageListSize=" + pageListSize);
		
		if (pageNum.trim().equals("") || pageListSize.trim().equals("")) {
			reStatus = "MISSING_VALUE";
		} else {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("companyId", companyId);
			param.put("tenantId", tenantId);
			param.put("pageNum", pageNum);
			param.put("pageListSize", pageListSize);
			param.put("offset",commonUtil.getMinuteUTC(user.getOffset()));
			JSONObject resultJson = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/getApplyHistoryList",
					param, request, "post", null);
			if (resultJson != null) {
				reStatus = (String) resultJson.get("status");
				if (reStatus.equalsIgnoreCase("OK")) {
					reTotalSize = ((Long) resultJson.get("totalSize")).intValue();
					reHistoryList = (String) resultJson.get("historyList");
				}
			}
		}

		JSONObject returnJson = new JSONObject();
		returnJson.put("status", reStatus);
		returnJson.put("totalSize", reTotalSize);
		returnJson.put("historyList", reHistoryList);
		logger.debug("status=" + reStatus + ", totalSize=" + reTotalSize);
		logger.debug("getApplicationHistoryList ended.");
		return returnJson;
	}	
	
	@RequestMapping(value="/admin/ezWebFolder/getApplicationHistory.do", method = RequestMethod.POST, produces="application/json;charset=utf8")
	@ResponseBody
	@SuppressWarnings("unchecked")
	public JSONObject getApplicationHistory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("getApplicationHistory started.");
		
		String reStatus = "ERROR";
		String appHistory = "[]";
		String appHistoryMember = "[]";
		
		String applyId = request.getParameter("applyId");
		logger.debug("applyId=" + applyId);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("applyId", applyId);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		param.put("offset",commonUtil.getMinuteUTC(userInfo.getOffset()));

		JSONObject resultJson = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/getApplyHistory", param, request, "post", null);
		if (resultJson != null) {
			reStatus = (String) resultJson.get("status");
			if (reStatus.equalsIgnoreCase("OK")) {
				appHistory = (String) resultJson.get("appHistory");
				appHistoryMember = (String) resultJson.get("appHistoryMemberList");
			}
		}
		
		JSONObject returnJson = new JSONObject();
		returnJson.put("status", reStatus);
		returnJson.put("appHistory", appHistory);
		returnJson.put("appHistoryMember", appHistoryMember);
		logger.debug("getApplicationHistory ended.");
		return returnJson;
	}

	@RequestMapping(value="/admin/ezWebFolder/setApprovalToApplyForOpening.do", method = RequestMethod.POST, produces="application/json;charset=utf8")
	@ResponseBody
	@SuppressWarnings("unchecked")
	public JSONObject setApprovalToApplyForOpening(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) throws Exception {
		logger.debug("setApprovalToApplyForOpening started.");
		
		String reStatus = "ERROR";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		String lang = userInfo.getLang();
		
		String applyId = request.getParameter("applyId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("applyId", applyId);
		param.put("userId", userId);
		
		JSONObject resultJson = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/approvalToApplyForOpening", param, request, "post", null);
		if (resultJson != null) {
			reStatus = (String) resultJson.get("status"); // OK, DUPLICATE_FOLDER_NAME, ADD_ERROR, ERROR
			String folderName = (String) resultJson.get("folderName");
			String applicantId = (String) resultJson.get("applicantId");
			folderName = commonUtil.cleanValueUnescape(folderName);
			
			if (reStatus.equalsIgnoreCase("OK")) {
	        	String notiSubType = "OPEN_ADMIT";
	        	
	        	List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
	        	Map<String, Object> recipientMap = new HashMap<String, Object>();
	        	recipientMap.put("userType", "PERSON");
	        	recipientMap.put("companyId", userInfo.getCompanyID());
	        	recipientMap.put("cn", applicantId);
	        	notiRecipientList.add(recipientMap);
	        	
				String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "WEBFOLDER", notiSubType, folderName, "", "", "", "", "", "");
				logger.debug("webfolder " +  notiSubType + " noti status : " + notiStatus);
				
				if (!ezPersonalService.hasNotiDiableItem(applicantId, NotiType.fromString("WEBFOLDER_OPEN_ADMIT"), NotiPlatform.MAIL, tenantId)) {
					List<OrganUserVO> toUserList = new ArrayList<OrganUserVO>();
					toUserList.add(ezOrganService.getUserInfo(applicantId, lang, tenantId));
					
					String mailSubject = egovMessageSource.getMessage("ezWebFolder.ksa54", locale);
					String mailContent = egovMessageSource.getMessage("ezWebFolder.ksa58", locale);
					mailSubject = String.format(mailSubject, folderName);
					mailContent = String.format(mailContent, folderName);
					
					reStatus = sendNotiMail(loginCookie, toUserList, mailSubject, mailContent, locale); // OK, EMAIL_ERROR
				} else {
					reStatus = "OK";
				}
				
			}
		}
		
		JSONObject returnJson = new JSONObject();
		returnJson.put("status", reStatus);
		logger.debug("setApprovalToApplyForOpening ended. reStatus=" + reStatus);
		return returnJson;
	}
	 
	@RequestMapping(value="/admin/ezWebFolder/setRefusalToApplyForOpening.do", method = RequestMethod.POST, produces="application/json;charset=utf8")
	@ResponseBody
	@SuppressWarnings("unchecked")
	public JSONObject setRefusalToApplyForOpening(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) throws Exception {
		logger.debug("setRefusalToApplyForOpening started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		String lang = userInfo.getLang();
		
		String reStatus = "ERROR";
		
		String applyId = request.getParameter("applyId");
		String reasonContent = request.getParameter("reasonCont");
		logger.debug("applyId=" + applyId + ", reasonContent=" + reasonContent);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("applyId", applyId);

		param.put("offset",userInfo.getOffset());

		JSONObject resultJson = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/RefuseToApplyForOpening", param, request, "post", null);
		if (resultJson != null) {
			reStatus = (String) resultJson.get("status"); // OK, ERROR
			String folderName = (String) resultJson.get("folderName");
			String applicantId = (String) resultJson.get("applicantId");
			folderName = commonUtil.cleanValueUnescape(folderName);
			
			if (reStatus.equalsIgnoreCase("OK")) {
				String notiSubType = "OPEN_REJECT";
				
				List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();

				Map<String, Object> recipientMap = new HashMap<String, Object>();
				recipientMap.put("userType", "PERSON");
				recipientMap.put("companyId", userInfo.getCompanyID());
				recipientMap.put("cn", applicantId);
				notiRecipientList.add(recipientMap);
				String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "WEBFOLDER", notiSubType, folderName, "", "", "", "", "", "");
				logger.debug("webfolder " +  notiSubType + " noti status : " + notiStatus);
				
				
				if (!ezPersonalService.hasNotiDiableItem(applicantId, NotiType.fromString("WEBFOLDER_OPEN_REJECT"), NotiPlatform.MAIL, tenantId)) {
					List<OrganUserVO> toUserList = new ArrayList<OrganUserVO>();
					toUserList.add(ezOrganService.getUserInfo(applicantId, lang, tenantId));
					
					String mailSubject = egovMessageSource.getMessage("ezWebFolder.ksa55", locale);
					String mailContent = egovMessageSource.getMessage("ezWebFolder.ksa60", locale);
					mailSubject = String.format(mailSubject, folderName);
					mailContent = String.format(mailContent, folderName, reasonContent);
					
					reStatus = sendNotiMail(loginCookie, toUserList, mailSubject, mailContent, locale); // OK, EMAIL_ERROR
				} else {
					reStatus = "OK";
				}
				
			}
		}
		
		JSONObject returnJson = new JSONObject();
		returnJson.put("status", reStatus);
		logger.debug("setRefusalToApplyForOpening ended. reStatus=" + reStatus);
		return returnJson;
	}
	
	private String sendNotiMail(String loginCookie, List<OrganUserVO> toUser, String subject, String content, Locale locale) {
		String reStr = "OK";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userName = userInfo.getDisplayName();
		String userEmail = userInfo.getEmail();
		int tenantId = userInfo.getTenantId();
		logger.debug("fromEmail=" + userEmail + ", subject=" + subject + ", content=" + content);
		
		try {
			String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
			
			InternetAddress from = new InternetAddress();
			from.setPersonal(userName, "UTF-8");
			from.setAddress(userEmail);

			InternetAddress[] toArr = new InternetAddress[toUser.size()];
			
			int nowi = 0;
			for (OrganUserVO vo : toUser) {
				String voMail = vo.getMail();
				String voCn = vo.getCn();
				voMail = voMail.trim().equals("") ? voCn + "@" + domainName : voMail;
				
				InternetAddress addrTemp = new InternetAddress();
				addrTemp.setPersonal(vo.getDisplayName(), "UTF-8");
				addrTemp.setAddress(voMail);
				
				toArr[nowi] = addrTemp;
				nowi++;
			}

			content = commonUtil.createNotiMailContent(content, tenantId, locale);
			ezEmailService.sendMail(loginCookie, from, toArr, null, null, subject, content, false);
		} catch (Exception e) {
			reStr = "EMAIL_ERROR";
			logger.error(e.getMessage(), e);
		}
		
		return reStr;
	}
	
	@RequestMapping(value = "/admin/ezWebfolder/webfolderUserAdd.do", method = RequestMethod.GET)
	public String personalPopupUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("personalPopupUser started");
		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		// 2020-11-26 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
		String folderManager = request.getParameter("folderManager");
		
		if (auth == null && userInfo.getRollInfo().indexOf("f=1") == -1 && folderManager.isEmpty() ) {
			return "cmm/error/adminDenied";
		}
		auth = userInfo;
		
		String deptID = auth.getDeptID();
		String cn = request.getParameter("cn") == null ? "" : request
				.getParameter("cn");
		String textName = request.getParameter("name") == null ? "" : request
				.getParameter("name");
		String useOcs = config.getProperty("config.USE_OCS");
		String companyId = request.getParameter("companyId");
		String lang = auth.getLang();
		String useShowAllCompanies = ezCommonService.getTenantConfig("useShowAllCompanies", userInfo.getTenantId());
		
		model.addAttribute("deptID", deptID);
		model.addAttribute("cn", cn);
		model.addAttribute("textName", textName);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("companyId", companyId);
		model.addAttribute("useShowAllCompanies", useShowAllCompanies);
		model.addAttribute("folderManager", folderManager);
		model.addAttribute("dept", auth.getDeptID());
		model.addAttribute("lang", lang);
		
		logger.debug("personalPopupUser ended");
		return "admin/ezWebFolder/webfolderUserAdd";
	}
}