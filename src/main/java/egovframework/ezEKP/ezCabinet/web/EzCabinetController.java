package egovframework.ezEKP.ezCabinet.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@Controller
public class EzCabinetController {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetRestService cabinetRestService;
	
	@RequestMapping(value = "/ezCabinet/cabinetMain.do")
	public String jspGetCabinetMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) {
		logger.debug("jspGetCabinetMain started");
		logger.debug("jspGetCabinetMain ended");
		return "ezCabinet/cabinetMain";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetLeft.do")
	public String jspGetCabinetLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jspGetCabinetLeft started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, userInfo.getId()).get("code") != 0) {
			model.addAttribute("isCabinetAdmin", "0");
		}
		else {
			model.addAttribute("isCabinetAdmin", "1");
		}
		
		logger.debug("jspGetCabinetLeft ended");
		return "ezCabinet/cabinetLeft";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetGeneral.do")
	public String jspGetCabinetGeneral(@CookieValue("loginCookie") String loginCookie,  HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCabinetGeneral started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetCabinetGeneral ended");
		return "ezCabinet/cabinetGeneral";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetConfig.do")
	public String jspGetCabinetConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCabinetConfig started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetCabinetConfig ended");
		return "ezCabinet/cabinetConfig";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetManagement.do")
	public String jspGetCabinetManagement(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCabinetManagement started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetCabinetManagement ended");
		return "ezCabinet/cabinetManagement";
	}
	
	@RequestMapping(value="/ezCabinet/getRelatedFile.do")
	public String jspGetRelatedFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetRelatedFile started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetRelatedFile ended");
		return "ezCabinet/cabinetFileSelect";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetInterLocking.do")
	public String jspGetRelatedCabinetConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetRelatedCabinetConfig started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject resultObj = cabinetRestService.getModuleListForUser(request, user.getId());
		
		if (!resultObj.get("status").toString().equals("ok")) {
			return "cmm/error/dataAccessFailure";
		}
		
		JSONArray moduleList = (JSONArray) resultObj.get("modules");
		model.addAttribute("modules", moduleList);
		
		logger.debug("jspGetRelatedCabinetConfig ended");
		return "ezCabinet/cabinetInterLock";
	}
	
	@RequestMapping(value="/ezCabinet/myCabinet.do")
	public String jspGetMyCabinet(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetMyCabinet started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetMyCabinet ended");
		return "ezCabinet/cabinetItem";
	}
	
	@RequestMapping(value="/ezCabinet/addCabinetFile.do")
	public String jspGetAddCabinetFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetAddCabinetFile started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String cabinetId   = request.getParameter("cabId");
		model.addAttribute("cabinetId", cabinetId);
		
		logger.debug("jspGetAddCabinetFile ended");
		return "ezCabinet/cabinetAddFile";
	}
	
	@RequestMapping(value="/ezCabinet/shareCabinet.do")
	public String jspGetShareCabinetPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetShareCabinetPage started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String cabinetId   = request.getParameter("cabId");
		model.addAttribute("cabinetId", cabinetId);
		
		logger.debug("jspGetShareCabinetPage ended");
		return "ezCabinet/cabinetShare";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezCabinet/getCompanyTree.do")
	@ResponseBody
	public String jsonGetCompanyTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId       = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject resultObj   = new JSONObject();
		
		if (companyId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.getCompanyTree(request, userInfo.getId(), companyId);
		
		return resultObj.toString();
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezCabinet/getSubNodes.do")
	@ResponseBody
	public String jsonGetSubNodes(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String deptId          = request.getParameter("deptId") != null ? request.getParameter("deptId") : "";
		String level           = request.getParameter("level") != null ? request.getParameter("level") : "";
		JSONObject resultObj   = new JSONObject();
		
		if (deptId.equals("") || level.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.getDeptSubNodes(request, userInfo.getId(), deptId, level);
		
		return resultObj.toString();
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezCabinet/uploadFile.do", method = RequestMethod.POST)
	public String uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Upload file is running!");
		
		/*LoginSimpleVO userInfo         = commonUtil.userInfoSimple(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		String folderId                = request.getParameter("folderId");
		String gwServerUrl             = config.getProperty("config.webFolderGwServerURL");
		String url                     = gwServerUrl + "/rest/ezwebfolder/filemanage/file-upload";
		
		SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
		requestFactory.setBufferRequestBody(false);
		
		RestTemplate restTemplate                       = new RestTemplate(requestFactory);
		List<HttpMessageConverter<?>> messageConverters = restTemplate.getMessageConverters();
		
		for (int i = 0; i < messageConverters.size(); i++) {
			HttpMessageConverter<?> messageConverter = messageConverters.get(i);
			
			if (messageConverter.getClass().equals(ResourceHttpMessageConverter.class)) {
				messageConverters.set(i, new BnkResourceHttpMessageConverter());
			}
		}
		
		MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
		JSONObject jsonObject             = new JSONObject();
		JSONArray jsonArray               = new JSONArray();
		
		for (MultipartFile file: multiFiles) {
			JSONObject fileJson = new JSONObject();
			
			fileJson.put("originalFilename", file.getOriginalFilename());
			jsonArray.add(fileJson);
			map.add("files", new MultipartFileResource(file.getInputStream(), file.getOriginalFilename()));
		}
		
		jsonObject.put("nameArray", jsonArray);
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("folderId", folderId);
		
		map.add("data", jsonObject);
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.MULTIPART_FORM_DATA);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<MultiValueMap<String, Object>>(map, headers);
		UriComponentsBuilder builder                     = UriComponentsBuilder.fromHttpUrl(url);
		ResponseEntity<String> result                    = restTemplate.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp         = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		String status         = resultBody.get("status").toString();
		JSONArray listFileVO  = null;
		
		if (status.equals("ok")) {
			listFileVO = (JSONArray) resultBody.get("data");
			model.addAttribute("listFile", listFileVO);
		}
		else {
			String reason = resultBody.get("reason").toString();
			model.addAttribute("reason", reason);
		}
		
		*/
		
		logger.debug("Upload file finishes!");
		return "json";
	}
	
	@RequestMapping(value="/ezCabinet/saveModules.do")
	@ResponseBody
	public String jsonSaveModulesSetting(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveModulesSetting start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String moduleList    = request.getParameter("modules")   != null ? request.getParameter("modules")    : "";
		JSONObject resultObj = new JSONObject();
		
		if (moduleList.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		ObjectMapper mapper = new ObjectMapper();
		JSONArray modules   = mapper.readValue(moduleList, new TypeReference<JSONArray>(){});
		
		resultObj = cabinetRestService.saveModulesSettingForUser(request, modules, user.getId());
		
		logger.debug("jsonSaveModulesSetting end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getUserCapicity.do")
	@ResponseBody
	public String jsonGetUserCapacity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetUserCapacity start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = cabinetRestService.getUserCapacity(request, user.getId());
		
		logger.debug("jsonGetUserCapacity end");
		return resultObj.toString();
	}
	
}
