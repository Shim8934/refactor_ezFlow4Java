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
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			model.addAttribute("isCabinetAdmin", "0");
		}
		else {
			model.addAttribute("isCabinetAdmin", "1");
		}
		
		JSONObject resultObj = cabinetRestService.getUserCapacity(request, user.getId());
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject capacity = (JSONObject)resultObj.get("capacity");
			model.addAttribute("capacityType" , capacity.get("capacityType"));
			model.addAttribute("percent"      , capacity.get("usedRate"));
			model.addAttribute("totalCapacity", capacity.get("totalCapacity"));
			model.addAttribute("useVolume"    , getFileSize(Integer.parseInt(capacity.get("totalUsed").toString())));
		}
		
		logger.debug("jspGetCabinetLeft ended");
		return "ezCabinet/cabinetLeft";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetGeneral.do")
	public String jspGetCabinetGeneral(@CookieValue("loginCookie") String loginCookie,  HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCabinetGeneral started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject resultObj = cabinetRestService.getUserPreviewConfig(request, user.getId());
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject userConfig = (JSONObject)resultObj.get("config");
			model.addAttribute("config", userConfig);
		}
		
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
		String currentNode = request.getParameter("node") != null ? request.getParameter("node") : "";
		model.addAttribute("node", currentNode);
		
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
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONArray moduleList = (JSONArray) resultObj.get("modules");
			model.addAttribute("modules", moduleList);
		}
		
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
	
	@RequestMapping(value="/ezCabinet/saveUserConfig.do")
	@ResponseBody
	public String jsonSaveUserConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveUserConfig start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String prevMode      = request.getParameter("prevMode")  != null ? request.getParameter("prevMode")  : "";
		String listCount     = request.getParameter("listCount") != null ? request.getParameter("listCount") : "";
		String contentWPrev  = request.getParameter("contentW")  != null ? request.getParameter("contentW")  : "";
		String contentHPrev  = request.getParameter("contentH")  != null ? request.getParameter("contentH")  : "";
		JSONObject resultObj = new JSONObject();
		
		if (prevMode.equals("") || listCount.equals("") || (!prevMode.equals("off") && (contentWPrev.equals("") || contentHPrev.equals("")))) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.saveUserConfig(request, user.getId(), prevMode, listCount, contentWPrev, contentHPrev);
		
		logger.debug("jsonSaveUserConfig end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getMyCabinetTree.do")
	@ResponseBody
	public String jsonMyCabinetTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonMyCabinetTree start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String currentNode   = request.getParameter("cabinetNode") != null ? request.getParameter("cabinetNode") : "";
		JSONObject resultObj = new JSONObject();
		
		resultObj            = cabinetRestService.getMyCabinetTree(request, currentNode, user.getId());
		
		logger.debug("jsonMyCabinetTree end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/addCabinet.do")
	@ResponseBody
	public String jsonAddCabinet(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonAddCabinet start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String parentId      = request.getParameter("parentId")  != null ? request.getParameter("parentId") : "";
		String cabinetName1  = request.getParameter("cabName1")  != null ? request.getParameter("cabName1") : "";
		String cabinetName2  = request.getParameter("cabName2")  != null ? request.getParameter("cabName2") : "";
		JSONObject resultObj = new JSONObject();
		
		resultObj            = cabinetRestService.addCabinet(request, user.getId(), parentId, cabinetName1, cabinetName2);
		
		logger.debug("jsonAddCabinet end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/renameCabinet.do")
	@ResponseBody
	public String jsonRenameCabinet(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonRenameCabinet start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String cabinetId     = request.getParameter("cabinetId") != null ? request.getParameter("cabinetId") : "";
		String cabinetName1  = request.getParameter("cabName1")  != null ? request.getParameter("cabName1")  : "";
		String cabinetName2  = request.getParameter("cabName2")  != null ? request.getParameter("cabName2")  : "";
		JSONObject resultObj = new JSONObject();
		
		resultObj            = cabinetRestService.renameCabinet(request, user.getId(), cabinetId, cabinetName1, cabinetName2);
		
		logger.debug("jsonRenameCabinet end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/deleteCabinet.do")
	@ResponseBody
	public String jsonDeleteCabinet(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonDeleteCabinet start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String cabinetId     = request.getParameter("cabinetId") != null ? request.getParameter("cabinetId") : "";
		JSONObject resultObj = new JSONObject();
		
		resultObj            = cabinetRestService.deleteCabinet(request, user.getId(), cabinetId);
		
		logger.debug("jsonDeleteCabinet end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getSubCabinetNodes.do")
	@ResponseBody
	public String jsonGetSubCabinetNodes(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetSubCabinetNodes start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String nodeId        = request.getParameter("nodeId")  != null ? request.getParameter("nodeId") : "";
		JSONObject resultObj = new JSONObject();
		
		resultObj            = cabinetRestService.getCabinetSubNodes(request, user.getId(), nodeId);
		
		logger.debug("jsonGetSubCabinetNodes end");
		return resultObj.toString();
	}
	
	private String getFileSize(int fileSize) {
		String fileSize_ = "";
		
		if (fileSize / 1024 / 1024 >= 1) {
			fileSize_ = String.format("%.2f", (double)(fileSize / 1024 / 1024 * 10) / 10);
			fileSize_ = fileSize_ + "MB";
		}
		else if (fileSize / 1024 >= 1) {
			fileSize_ = String.format("%.2f", (double)(fileSize / 1024));
			fileSize_ = fileSize_ + "KB";
		}
		else {
			fileSize_ = fileSize + "B";
		}
		
		return fileSize_;
	}
}
