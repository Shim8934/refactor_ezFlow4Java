package egovframework.ezEKP.ezWebFolder.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderController_m {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderController_m.class);
	
	@RequestMapping(value="/ezWebFolder/trashCan.do")
	public String trashCan (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		logger.debug("trashCan Started.");
		
		if (loginCookie == null) {
			logger.debug("trashCan illegal arguments!");
			return "cmm/error/egovError";
		}
		
		logger.debug("userInfo=" + commonUtil.userInfoSimple(loginCookie));
		model.addAttribute("userInfo", commonUtil.userInfoSimple(loginCookie));
		
		logger.debug("trashCan ended.");
		return "ezWebFolder/trashCan";
	}
	
	@RequestMapping(value="/ezWebFolder/getTrashCanList.do", method = RequestMethod.POST)
	public String getTrashCanList (@CookieValue("loginCookie") String loginCookie, Model model, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		String userId = request.getParameter("userId") !=null ? request.getParameter("userId") : "";
		int tenantId = request.getParameter("tenantId") !=null ? Integer.parseInt(request.getParameter("tenantId")) : 1;
		String offset = request.getParameter("offset") !=null ? request.getParameter("offset") : "";
		
		String gwServerUrl = config.getProperty("config.webFolderGWServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/" + userId + "/getTrashCanList";
		
		logger.debug("getTrashCanList Started.");
		logger.debug("userId=" + userId + ",tenantId=" + userId + ",offset=" + offset);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", tenantId)
										.queryParam("offset", offset);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("status","ok");
			model.addAttribute("code",0);
			model.addAttribute("data",resultBody.get("data"));
			model.addAttribute("fileCnt",resultBody.get("fileCnt"));
			model.addAttribute("folderCnt",resultBody.get("folderCnt"));
		}else {
			model.addAttribute("status","error");
			model.addAttribute("code",1);
			model.addAttribute("data","");
		}
		
		logger.debug("status=" + status);
		logger.debug("getTrashCanList ended");
		
		return "json";
	}
	
	@RequestMapping(value="/ezWebFolder/permanentDeleteConfirm.do")
	public String permanentDeleteConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception {
		logger.debug("permanentDeleteConfirm Started.");
		String fileList = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String folderList = request.getParameter("folderList") != null ? request.getParameter("folderList") : "";
		
		if (fileList.equals("")) {
			logger.debug("Delete File Confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
		model.addAttribute("fileList", fileList);
		model.addAttribute("folderList", folderList);
		
		logger.debug("permanentDeleteConfirm ended.");
		return "ezWebFolder/filePermanentDelete";
	}
	
	@RequestMapping(value="/ezWebFolder/pemanentDeleteFile.do", method = RequestMethod.POST)
	public String pemanentDeleteFile (@CookieValue("loginCookie") String loginCookie, Model model, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("pemanentDeleteFile Started.");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileList = request.getParameter("fileList");
		String folderList = request.getParameter("folderList");
		String gwServerUrl = config.getProperty("config.webFolderGWServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/file-permanent-delete";
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("lang", user.getLang())
										.queryParam("fileList", fileList)
										.queryParam("folderList", folderList);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		String status = resultBody.get("status").toString();
		
		if (!status.equals("ok")) {
			String reason = resultBody.get("reason").toString();
			model.addAttribute("reason", reason);
		}
		
		logger.debug("status=" + status);
		logger.debug("pemanentDeleteFile ended");
		return "json";
	}
	
	@RequestMapping(value = "/ezWebFolder/favorite.do")
	public String favor(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		logger.debug("favorite started.");

		model.addAttribute("userInfo", commonUtil.userInfo(loginCookie));

		logger.debug("favorite ended.");
		return "ezWebFolder/favorite";
	}
}
