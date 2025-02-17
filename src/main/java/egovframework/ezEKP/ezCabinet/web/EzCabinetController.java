package egovframework.ezEKP.ezCabinet.web;

import java.util.List;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
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
	
	@RequestMapping(value = "/ezCabinet/cabinetMain.do", method = RequestMethod.GET)
	public String jspGetCabinetMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) {
		logger.debug("jspGetCabinetMain started");

		String leftFrameWidth = "220";
		int width = 0;

		if (req.getParameter("__wwidth") != null) {
			String widthParam = req.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}

		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		logger.debug("jspGetCabinetMain ended");
		return "ezCabinet/main/cabinetMain";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetLeft.do", method = RequestMethod.GET)
	public String jspGetCabinetLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jspGetCabinetLeft started");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject resultObj = cabinetRestService.getUserCapacity(request, user.getId());
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject capacity = (JSONObject)resultObj.get("capacity");
			model.addAttribute("capacityType" , capacity.get("capacityType"));
			logger.debug("UsedRate: " + capacity.get("usedRate"));
			
			
			model.addAttribute("percent"      , capacity.get("usedRate"));
			model.addAttribute("totalCapacity", capacity.get("totalCapacity"));
			model.addAttribute("useVolume"    , getFileSize(Long.parseLong((String)capacity.get("totalUsed"))));
			model.addAttribute("UserLang", commonUtil.getMultiData(user.getLang(), user.getTenantId()));
		}
		
		logger.debug("jspGetCabinetLeft ended");
		return "ezCabinet/main/cabinetLeft";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetGeneral.do", method = RequestMethod.GET)
	public String jspGetCabinetGeneral(@CookieValue("loginCookie") String loginCookie,  HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCabinetGeneral started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject resultObj = cabinetRestService.getUserPreviewConfig(request, user.getId());
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject userConfig = (JSONObject)resultObj.get("config");
			model.addAttribute("config", userConfig);
		}
		
		logger.debug("jspGetCabinetGeneral ended");
		return "ezCabinet/config/cabinetGeneral";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetConfig.do", method = RequestMethod.GET)
	public String jspGetCabinetConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCabinetConfig started");
		logger.debug("jspGetCabinetConfig ended");
		return "ezCabinet/config/cabinetConfig";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetManagement.do", method = RequestMethod.GET)
	public String jspGetCabinetManagement(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCabinetManagement started");
		String currentNode = request.getParameter("node") != null ? request.getParameter("node") : "";
		model.addAttribute("node", currentNode);
		
		logger.debug("jspGetCabinetManagement ended");
		return "ezCabinet/management/cabinetManagement";
	}
	
	@RequestMapping(value="/ezCabinet/getRelatedFile.do", method = RequestMethod.GET)
	public String jspGetRelatedFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetRelatedFile started");
		
		String itemId = request.getParameter("itemId") != null ? request.getParameter("itemId") : "";
		String module = request.getParameter("module") != null ? request.getParameter("module") : "";
		
		model.addAttribute("module", module);
		model.addAttribute("itemId", itemId);
		
		logger.debug("jspGetRelatedFile ended");
		return "ezCabinet/item/cabinetFileSelect";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetInterLocking.do", method = RequestMethod.GET)
	public String jspGetRelatedCabinetConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetRelatedCabinetConfig started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject resultObj = cabinetRestService.getModuleListForUser(request, user.getId());
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONArray moduleList = (JSONArray) resultObj.get("modules");
			model.addAttribute("modules", moduleList);
		}
		
		logger.debug("jspGetRelatedCabinetConfig ended");
		return "ezCabinet/config/cabinetInterLock";
	}
	
	@RequestMapping(value="/ezCabinet/myCabinet.do", method = RequestMethod.GET)
	public String jspGetCabinetPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetMyCabinet started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String cabinetId   = request.getParameter("cabinetId");
		
		JSONObject resultObj = cabinetRestService.getCabinetInfo(request, user.getId(), cabinetId);
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject cabinet = (JSONObject) resultObj.get("cabinet");
			model.addAttribute("cabinet", cabinet);
		}
		
		JSONObject configObj = cabinetRestService.getUserPreviewConfig(request, user.getId());
		
		if (configObj.get("status").toString().equals("ok")) {
			JSONObject userConfig = (JSONObject)configObj.get("config");
			model.addAttribute("config", userConfig);
		}
		
		/* 2020-01-29 홍승비 - 다국어 대응을 위한 lang 추가 */
		model.addAttribute("cabinetId", cabinetId);
		model.addAttribute("lang", user.getLang());
		
		logger.debug("jspGetMyCabinet ended");
		return "ezCabinet/main/cabinetItem";
	}
	
	@RequestMapping(value="/ezCabinet/getShareCabinet.do", method = RequestMethod.GET)
	public String jspGetShareCabinetPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetShareCabinetPage started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String cabinetId   = request.getParameter("cabinetId");
		
		logger.debug("Cabinet Id: " + cabinetId);
		
		JSONObject shareObj = cabinetRestService.getShareCabinetInfo(request, user.getId(), cabinetId);
		
		if (((Long)shareObj.get("code")).intValue() == 0) {
			JSONObject cabinet = (JSONObject) shareObj.get("cabinet");
			model.addAttribute("cabinet", cabinet);
		}
		
		JSONObject configObj = cabinetRestService.getUserPreviewConfig(request, user.getId());
		
		if (((Long)configObj.get("code")).intValue() == 0) {
			JSONObject userConfig = (JSONObject)configObj.get("config");
			model.addAttribute("config", userConfig);
		}
		
		model.addAttribute("cabinetId", cabinetId);
		logger.debug("jspGetShareCabinetPage ended");
		return "ezCabinet/main/cabinetItem";
	}
	
	@RequestMapping(value="/ezCabinet/addCabinetFile.do", method = RequestMethod.GET)
	public String jspGetAddCabinetFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetAddCabinetFile started");
		String cabinetId = request.getParameter("cabId");
		model.addAttribute("cabinetId", cabinetId);
		
		logger.debug("jspGetAddCabinetFile ended");
		return "ezCabinet/item/cabinetAddFile";
	}
	
	@RequestMapping(value = "/ezCabinet/cabinetAddRelated.do", method = RequestMethod.GET)
	public String jspGetCabinetFileDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCabinetFileDetail started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String module        = request.getParameter("module") != null ? request.getParameter("module") : "";
		
		if (module.equals("")) {
			return "ezCabinet/cabinetAccessDenied";
		}
		
		JSONObject resultObj = cabinetRestService.checkUserActiveModules(request, user.getId(), module);
		
		if (resultObj.get("status").toString().equals("ok")) {
			String activeFlag = resultObj.get("active").toString();
			model.addAttribute("activeFlag", activeFlag);
		}
		
		model.addAttribute("module", module);
		logger.debug("jspGetCabinetFileDetail ended");
		return "ezCabinet/related/cabinetAddRelated";
	}
	
	@RequestMapping(value = "/ezCabinet/getPreviewContent.do", method = RequestMethod.GET)
	public String jspGetPreviewPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetPreviewPage started");
		String module = request.getParameter("module") != null ? request.getParameter("module") : "";
		model.addAttribute("module", module);
		
		logger.debug("jspGetPreviewPage ended");
		return "ezCabinet/preview/cabinetPrevContent";
	}
	
	@RequestMapping(value = "/ezCabinet/getPreviewPhoto.do", method = RequestMethod.GET)
	public String jspGetPreviewPhotoPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetPreviewPhotoPage started");
		logger.debug("jspGetPreviewPhotoPage ended");
		return "ezCabinet/preview/cabinetPrevPhoto";
	}
	
	@RequestMapping(value = "/ezCabinet/cabinetRelatedTreeNotFound.do", method = RequestMethod.GET)
	public String jspGetRelatedTreeNotFound(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetRelatedTreeNotFound started");
		model.addAttribute("message", "ezCabinet.t32");
		logger.debug("jspGetRelatedTreeNotFound ended");
		return "ezCabinet/cabinetBlankTree";
	}
	
	@RequestMapping(value = "/ezCabinet/cabinetShareTreeNotFound.do", method = RequestMethod.GET)
	public String jspGetShareTreeNotFound(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetShareTreeNotFound started");
		model.addAttribute("message", "ezCabinet.t05");
		logger.debug("jspGetShareTreeNotFound ended");
		return "ezCabinet/cabinetBlankTree";
	}
	
	@RequestMapping(value = "/ezCabinet/myShareTreeNotFound.do", method = RequestMethod.GET)
	public String jspGetMyShareTreeNotFound(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetMyShareTreeNotFound started");
		model.addAttribute("message", "ezCabinet.t157");
		logger.debug("jspGetMyShareTreeNotFound ended");
		return "ezCabinet/cabinetBlankTree";
	}
	
	@RequestMapping(value="/ezCabinet/downloadAttachFile", method = RequestMethod.GET, produces="application/zip")
	@ResponseBody
	public void responeDownloadFile(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("responeDownloadFile is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String filePath        = request.getParameter("filePath") != null ? request.getParameter("filePath") : "";
		String fileName        = request.getParameter("fileName") != null ? request.getParameter("fileName") : "";
		
		if (filePath.equals("") || fileName.equals("")) {
			logger.debug("Invalid arguments!!!");
			return;
		}
		
		cabinetRestService.downloadAttachFile(request, response, userInfo.getId(), filePath, fileName);
		
		logger.debug("responeDownloadFile finishes!");
	}
	
	@RequestMapping(value="/ezCabinet/getCompanyTree.do", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	@ResponseBody
	public String jsonGetCompanyTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId       = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject resultObj   = cabinetRestService.getCompanyTree(request, userInfo.getId(), companyId);
		
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getSubNodes.do", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	@ResponseBody
	public String jsonGetSubNodes(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jsonGetSubNodes started");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String deptId          = request.getParameter("nodeId") != null ? request.getParameter("nodeId") : "";
		String level           = request.getParameter("level")  != null ? request.getParameter("level")  : "";
		JSONObject resultObj   = new JSONObject();
		
		if (deptId.equals("") || level.equals("")) {
			logger.debug("Parameter error");
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.getDeptSubNodes(request, userInfo.getId(), deptId, level);
		logger.debug("jsonGetSubNodes ended");
		
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/uploadAttachFile.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonUploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Upload file is running!");
		LoginSimpleVO userInfo         = commonUtil.userInfoSimple(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		JSONObject resultObj           = new JSONObject();
		
		if (multiFiles.size() == 0) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.uploadAttachFile(request, userInfo.getId(), multiFiles);
		
		logger.debug("Upload file finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/deleteAttachFile.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonDeleteFile(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Delete file is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String filePath        = request.getParameter("filePath") != null ? request.getParameter("filePath") : "";
		JSONObject resultObj   = new JSONObject();
		
		if (filePath.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.deleteAttachFile(request, userInfo.getId(), filePath);
		
		logger.debug("Delete file finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveItem.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Save item is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String cabinetId       = request.getParameter("cabinetId")   != null ? request.getParameter("cabinetId")   : "";
		String title           = request.getParameter("title")       != null ? request.getParameter("title")       : "";
		String summary         = request.getParameter("summary")     != null ? request.getParameter("summary")     : "";
		String fileList        = request.getParameter("listFile")    != null ? request.getParameter("listFile")    : "";
		String relatedList     = request.getParameter("relatedList") != null ? request.getParameter("relatedList") : "";
		JSONObject resultObj   = new JSONObject();
		
		if (cabinetId.equals("") || title.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.saveItem(request, userInfo.getId(), cabinetId, title, summary, fileList, relatedList);
		
		logger.debug("Save item finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveModules.do", method = RequestMethod.GET)
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
	
	@RequestMapping(value="/ezCabinet/getUserCapicity.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonGetUserCapacity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetUserCapacity start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = cabinetRestService.getUserCapacity(request, user.getId());
		
		logger.debug("jsonGetUserCapacity end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveUserConfig.do", method = RequestMethod.GET)
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
	
	@RequestMapping(value="/ezCabinet/getMyCabinetTree.do", method = RequestMethod.GET, produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String jsonMyCabinetTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonMyCabinetTree start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String currentNode   = request.getParameter("cabinetNode") != null ? request.getParameter("cabinetNode") : "";
		JSONObject resultObj = cabinetRestService.getMyCabinetTree(request, currentNode, user.getId());

		logger.debug("jsonMyCabinetTree end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getAllCabinetTree.do", method = RequestMethod.GET, produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String jsonAllCabinetTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonAllCabinetTree start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String currentNode   = request.getParameter("cabinetNode") != null ? request.getParameter("cabinetNode") : "";
		JSONObject resultObj = cabinetRestService.getAllCabinetTree(request, currentNode, user.getId());
		
		logger.debug("jsonAllCabinetTree end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getRelatedCabinetTree.do", method = RequestMethod.GET, produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String jsonRelatedCabinetTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonRelatedCabinetTree start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String currentNode   = request.getParameter("cabinetNode") != null ? request.getParameter("cabinetNode") : "";
		JSONObject resultObj = cabinetRestService.getRelatedCabinetTree(request, user.getId(), currentNode);
		
		logger.debug("jsonRelatedCabinetTree end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getSharedCabinetTree.do", method = RequestMethod.GET, produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String jsonSharedCabinetTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonSharedCabinetTree start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = cabinetRestService.getSharedCabinetTree(request, user.getId());
		
		logger.debug("jsonSharedCabinetTree end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getMyShareCabinetTree.do", method = RequestMethod.GET, produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String jsonMyShareCabinetTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonMyShareCabinetTree start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String currentNode   = request.getParameter("cabinetNode") != null ? request.getParameter("cabinetNode") : "";
		JSONObject resultObj = cabinetRestService.getMyShareCabinetTree(request, user.getId(), currentNode);
		
		logger.debug("jsonMyShareCabinetTree end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getSharedCabinetsByUser.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonGetUserSharedCabinet(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetUserSharedCabinet start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String shareId       = request.getParameter("shareId") != null ? request.getParameter("shareId") : "";
		JSONObject resultObj = new JSONObject();
		
		if (shareId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj            = cabinetRestService.getUserSharedCabinet(request, user.getId(), shareId);
		
		logger.debug("jsonGetUserSharedCabinet end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getSubCabinetNodes.do", method = RequestMethod.GET, produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String jsonGetSubCabinetNodes(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetSubCabinetNodes start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String nodeId        = request.getParameter("nodeId")  != null ? request.getParameter("nodeId") : "";
		JSONObject resultObj = cabinetRestService.getCabinetSubNodes(request, user.getId(), nodeId);
		
		logger.debug("jsonGetSubCabinetNodes end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/addCabinet.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonAddCabinet(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonAddCabinet start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String parentId      = request.getParameter("parentId")  != null ? request.getParameter("parentId") : "";
		String cabinetName1  = request.getParameter("cabName1")  != null ? request.getParameter("cabName1") : "";
		
		JSONObject resultObj = new JSONObject();
		
		if (cabinetName1.equals("") || parentId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj            = cabinetRestService.addCabinet(request, user.getId(), parentId, cabinetName1);
		
		logger.debug("jsonAddCabinet end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/renameCabinet.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonRenameCabinet(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonRenameCabinet start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String cabinetId     = request.getParameter("cabinetId") != null ? request.getParameter("cabinetId") : "";
		String cabinetName1  = request.getParameter("cabName1")  != null ? request.getParameter("cabName1")  : "";
		JSONObject resultObj = new JSONObject();
		
		if (cabinetName1.equals("") || cabinetId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj            = cabinetRestService.renameCabinet(request, user.getId(), cabinetId, cabinetName1);
		
		logger.debug("jsonRenameCabinet end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/deleteCabinet.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonDeleteCabinet(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonDeleteCabinet start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String cabinetId     = request.getParameter("cabinetId") != null ? request.getParameter("cabinetId") : "";
		JSONObject resultObj = new JSONObject();
		
		if (cabinetId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj            = cabinetRestService.deleteCabinet(request, user.getId(), cabinetId);
		
		logger.debug("jsonDeleteCabinet end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/moveCabinet.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonMoveCabinet(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonMoveCabinet start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String cabinetId     = request.getParameter("cabinetId") != null ? request.getParameter("cabinetId") : "";
		String parentId      = request.getParameter("parentId")  != null ? request.getParameter("parentId")  : "";
		String mode          = request.getParameter("mode")      != null ? request.getParameter("mode")      : "";
		JSONObject resultObj = new JSONObject();
		
		if (cabinetId.equals("") || parentId.equals("") || mode.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj            = cabinetRestService.moveCabinet(request, user.getId(), cabinetId, parentId, mode);
		
		logger.debug("jsonMoveCabinet end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getCabinetItems.do", method = RequestMethod.POST, produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String jsonGetCabinetItems(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetCabinetItems start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String currentPage   = request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "";
		String cabinetId     = request.getParameter("cabinetId")   != null ? request.getParameter("cabinetId")   : "";
		String title         = request.getParameter("title")       != null ? request.getParameter("title")       : "";
		String summary       = request.getParameter("summary")     != null ? request.getParameter("summary")     : "";
		String recursive     = request.getParameter("recursive")   != null ? request.getParameter("recursive")   : "";
		String creatorName   = request.getParameter("creatorName") != null ? request.getParameter("creatorName") : "";
		String startDate     = request.getParameter("startDate")   != null ? request.getParameter("startDate")   : "";
		String endDate       = request.getParameter("endDate")     != null ? request.getParameter("endDate")     : "";
		String column        = request.getParameter("column")      != null ? request.getParameter("column")      : "";
		String order         = request.getParameter("order")       != null ? request.getParameter("order")       : "";
		String srchMode      = request.getParameter("srchMode")    != null ? request.getParameter("srchMode")    : "";
		String srchOption    = request.getParameter("srchOption")  != null ? request.getParameter("srchOption")  : "";
		String listCntSize   = request.getParameter("listCntSize") != null ? request.getParameter("listCntSize") : "";
		
		logger.debug("CabinetId: " + cabinetId + " || Title: " + title + " || Summary: " + summary + " || Recursive: " + recursive + " || Creator name: " + creatorName + " || Start Date: " + startDate + " || End Date: " + endDate + " || Column: " + column + " || Order: " + order + " || Search mode: " + srchMode + " || Search option: " + srchOption + " || List count: " + listCntSize + " || Current page: " + currentPage);
		
		JSONObject resultObj = new JSONObject();
		
		if (cabinetId.equals("") || listCntSize.equals("") || currentPage.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.getCabinetItems(request, user.getId(), cabinetId, title, summary, recursive, creatorName, startDate, endDate, column, order, srchMode, srchOption, listCntSize, currentPage);
		
		logger.debug("jsonGetCabinetItems end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/deleteItems.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonDeleteItems(@CookieValue("loginCookie") String loginCookie, @RequestParam(value = "itemList") List<String> itemList, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonDeleteItems start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("ItemList: " + String.join(",", itemList));
		
		JSONObject resultObj = new JSONObject();
		
		if (itemList.size() == 0) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.deleteItems(request, user.getId(), itemList);
		
		logger.debug("jsonDeleteItems end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/moveItems.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonMoveItems(@CookieValue("loginCookie") String loginCookie, @RequestParam(value = "itemList") List<String> itemList, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonMoveItems start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String cabinetId     = request.getParameter("cabinetId") != null ? request.getParameter("cabinetId") : "";
		String mode          = request.getParameter("mode")      != null ? request.getParameter("mode")      : "";
		
		logger.debug("CabinetId: " + cabinetId + " || Mode: " + mode + "ItemList: " + String.join(",", itemList));
		
		JSONObject resultObj = new JSONObject();
		
		if (cabinetId.equals("") || itemList.size() == 0 || mode.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.moveItems(request, user.getId(), cabinetId, mode, itemList);
		
		logger.debug("jsonMoveItems end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getCabinetFiles.do", method = RequestMethod.GET, produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String jsonGetCabinetFiles(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetCabinetFiles start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String cabinetId   = request.getParameter("cabinetId")   != null ? request.getParameter("cabinetId")   : "";
		String currentPage = request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "";
		
		logger.debug("CabinetId: " + cabinetId + " || Current page: " + currentPage);
		
		JSONObject resultObj = new JSONObject();
		
		if (cabinetId.equals("") || currentPage.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.getCabinetFiles(request, user.getId(), cabinetId, currentPage);
		
		logger.debug("jsonGetCabinetFiles end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getFilesBySearching.do", method = RequestMethod.POST, produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String jsonGetFilesBySearching(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetFilesBySearching start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String itemTitle     = request.getParameter("title")       != null ? request.getParameter("title")       : "";
		String currentPage   = request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "";
		
		logger.debug("Item title: " + itemTitle + " || Current page: " + currentPage);
		
		JSONObject resultObj = new JSONObject();
		
		if (itemTitle.equals("") || currentPage.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.getFilesBySearching(request, user.getId(), itemTitle, currentPage);
		
		logger.debug("jsonGetFilesBySearching end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveRelatedEmail.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveRelatedEmail(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveRelatedEmail is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String title           = request.getParameter("title")     != null ? request.getParameter("title")     : "";
		String summary         = request.getParameter("summary")   != null ? request.getParameter("summary")   : "";
		String mailTitle       = request.getParameter("mailTitle") != null ? request.getParameter("mailTitle") : "";
		String sender          = request.getParameter("sender")    != null ? request.getParameter("sender")    : "";
		String attach          = request.getParameter("attach")    != null ? request.getParameter("attach")    : "";
		String mode            = request.getParameter("mode")      != null ? request.getParameter("mode")      : "";
		String cabinetId       = request.getParameter("cabinet")   != null ? request.getParameter("cabinet")   : "";
		String content         = request.getParameter("content")   != null ? request.getParameter("content")   : "";
		String receiver        = request.getParameter("receiver")  != null ? request.getParameter("receiver")  : "";
		String forward         = request.getParameter("forward")   != null ? request.getParameter("forward")   : "";
		String dateTime        = request.getParameter("crdDate")   != null ? request.getParameter("crdDate")   : "";
		JSONObject resultObj   = new JSONObject();
		
		if (title.equals("") || mailTitle.equals("") || sender.equals("") || (mode.equals("1") && cabinetId.equals("")) || mode.equals("") || receiver.equals("") || dateTime.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.saveRelatedEmail(request, userInfo.getId(), title, summary, mailTitle, sender, attach, mode, cabinetId, content, receiver, forward, dateTime);
		
		logger.debug("jsonSaveRelatedEmail finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/modifyRelatedItem.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonModifyRelatedItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("jsonModifyRelatedItem is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String itemId          = request.getParameter("itemId")      != null ? request.getParameter("itemId")      : "";
		String title           = request.getParameter("title")       != null ? request.getParameter("title")       : "";
		String summary         = request.getParameter("summary")     != null ? request.getParameter("summary")     : "";
		String relatedList     = request.getParameter("relatedList") != null ? request.getParameter("relatedList") : "";
		JSONObject resultObj   = new JSONObject();
		
		if (itemId.equals("") || title.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.modifyRelatedItem(request, userInfo.getId(), itemId, title, summary, relatedList);
		
		logger.debug("jsonModifyRelatedItem finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveRelatedGroupAddress.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveRelatedGroupAddress(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveRelatedGroupAddress is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String title           = request.getParameter("title")      != null ? request.getParameter("title")      : "";
		String summary         = request.getParameter("summary")    != null ? request.getParameter("summary")    : "";
		String mode            = request.getParameter("mode")       != null ? request.getParameter("mode")       : "";
		String cabinetId       = request.getParameter("cabinet")    != null ? request.getParameter("cabinet")    : "";
		String groupName       = request.getParameter("groupName")  != null ? request.getParameter("groupName")  : "";
		String content         = request.getParameter("content")    != null ? request.getParameter("content")    : "";
		String createUser      = request.getParameter("createUser") != null ? request.getParameter("createUser") : "";
		String createDate      = request.getParameter("createDate") != null ? request.getParameter("createDate") : "";
		String changeUser      = request.getParameter("changeUser") != null ? request.getParameter("changeUser") : "";
		String changeDate      = request.getParameter("changeDate") != null ? request.getParameter("changeDate") : "";
		JSONObject resultObj   = new JSONObject();
		
		logger.debug("Title: " + title + " || summary: "+ summary + " || groupName: "+ groupName +" || createUser: " + createUser + " || createDate: " + createDate + " || changeUser: " + changeUser + " || changeDate: " + changeDate + " || mode: " + mode + " || cabinetId: " + cabinetId + " || content: " + content);
		
		if (title.equals("") || groupName.equals("") || (mode.equals("1") && cabinetId.equals("")) || content.equals("") || mode.equals("") || createUser.equals("") || createDate.equals("")  || changeUser.equals("") || changeDate.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.saveRelatedGroupAdress(request, userInfo.getId(), title, summary, mode, cabinetId, groupName, content, createUser, createDate, changeUser, changeDate);
		
		logger.debug("jsonSaveRelatedGroupAddress finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveRelatedNormalAddress.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveRelatedNormalAddress(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveRelatedNormalAddress is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String title           = request.getParameter("title")      != null ? request.getParameter("title")      : "";
		String summary         = request.getParameter("summary")    != null ? request.getParameter("summary")    : "";
		String mode            = request.getParameter("mode")       != null ? request.getParameter("mode")       : "";
		String cabinetId       = request.getParameter("cabinet")    != null ? request.getParameter("cabinet")    : "";
		String createUser      = request.getParameter("createUser") != null ? request.getParameter("createUser") : "";
		String createDate      = request.getParameter("createDate") != null ? request.getParameter("createDate") : "";
		String changeUser      = request.getParameter("changeUser") != null ? request.getParameter("changeUser") : "";
		String changeDate      = request.getParameter("changeDate") != null ? request.getParameter("changeDate") : "";
		String company         = request.getParameter("company")    != null ? request.getParameter("company")    : "";
		String department      = request.getParameter("department") != null ? request.getParameter("department") : "";
		String position        = request.getParameter("position")   != null ? request.getParameter("position")   : "";
		String email           = request.getParameter("email")      != null ? request.getParameter("email")      : "";
		String compNumber      = request.getParameter("compNumber") != null ? request.getParameter("compNumber") : "";
		String userNumber      = request.getParameter("userNumber") != null ? request.getParameter("userNumber") : "";
		String faxNumber       = request.getParameter("faxNumber")  != null ? request.getParameter("faxNumber")  : "";
		String homePage        = request.getParameter("homePage")   != null ? request.getParameter("homePage")   : "";
		String companyZip      = request.getParameter("companyZip") != null ? request.getParameter("companyZip") : "";
		String compAddr        = request.getParameter("compAddr")   != null ? request.getParameter("compAddr")   : "";
		String homeZip         = request.getParameter("homeZip")    != null ? request.getParameter("homeZip")    : "";
		String homeAddr        = request.getParameter("homeAddr")   != null ? request.getParameter("homeAddr")   : "";
		String memo            = request.getParameter("memo")       != null ? request.getParameter("memo")       : "";
		
		JSONObject resultObj   = new JSONObject();
		
		logger.debug("Title: " + title + "|| summary: "+ summary + " || createUser: " + createUser + " || createDate: " + createDate + " || changeUser: " + changeUser + " || changeDate: " + changeDate + " || mode: " + mode + " || cabinetId: " + cabinetId);
		
		if (title.equals("") || (mode.equals("1") && cabinetId.equals("")) || mode.equals("") || createUser.equals("") || createDate.equals("")  || changeUser.equals("") || changeDate.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.saveRelatedNormalAdress(request, userInfo.getId(), title, summary, mode, cabinetId, createUser, createDate, changeUser, changeDate, company, department, position, email, compNumber, userNumber, faxNumber, homePage, companyZip, compAddr, homeZip, homeAddr, memo);
		
		logger.debug("jsonSaveRelatedNormalAddress finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveRelatedResource.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveRelatedResource(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveRelatedResource is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String title           = request.getParameter("title")      != null ? request.getParameter("title")      : "";
		String summary         = request.getParameter("summary")    != null ? request.getParameter("summary")    : "";
		String mode            = request.getParameter("mode")       != null ? request.getParameter("mode")       : "";
		String cabinetId       = request.getParameter("cabinet")    != null ? request.getParameter("cabinet")    : "";
		String resTitle        = request.getParameter("resTitle")   != null ? request.getParameter("resTitle")   : "";
		String content         = request.getParameter("content")    != null ? request.getParameter("content")    : "";
		String createUser      = request.getParameter("writer")     != null ? request.getParameter("writer")     : "";
		String resDate         = request.getParameter("date")       != null ? request.getParameter("date")       : "";
		String resItem         = request.getParameter("resItem")    != null ? request.getParameter("resItem")    : "";
		JSONObject resultObj   = new JSONObject();
		
		logger.debug("Title: " + title + " || summary: " + summary + " || createUser: " + createUser + " || Resource Date: " + resDate + " || resItem: " + resItem + " || mode: " + mode + " || cabinetId: " + cabinetId + " || resTitle: "+ resTitle + " || content: " + content);
		
		if (title.equals("") || resTitle.equals("") || (mode.equals("1") && cabinetId.equals("")) || mode.equals("") || createUser.equals("") || resDate.equals("")  || resItem.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.saveRelatedResource(request, userInfo.getId(), title, summary, mode, cabinetId, resTitle, content, createUser, resDate, resItem);
		
		logger.debug("jsonSaveRelatedResource finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveRelatedSchedule.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveRelatedSchedule(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveRelatedSchedule is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String title           = request.getParameter("title")         != null ? request.getParameter("title")         : "";
		String summary         = request.getParameter("summary")       != null ? request.getParameter("summary")       : "";
		String mode            = request.getParameter("mode")          != null ? request.getParameter("mode")          : "";
		String cabinetId       = request.getParameter("cabinet")       != null ? request.getParameter("cabinet")       : "";
		String scheduleTitle   = request.getParameter("scheduleTitle") != null ? request.getParameter("scheduleTitle") : "";
		String createUser      = request.getParameter("creator")       != null ? request.getParameter("creator")       : "";
		String createDate      = request.getParameter("createdate")    != null ? request.getParameter("createdate")    : "";
		String scheduleDate    = request.getParameter("scheduledate")  != null ? request.getParameter("scheduledate")  : "";
		String location        = request.getParameter("location")      != null ? request.getParameter("location")      : "";
		String publicstatus    = request.getParameter("publicstatus")  != null ? request.getParameter("publicstatus")  : "";
		String groupname       = request.getParameter("groupname")     != null ? request.getParameter("groupname")     : "";
		String attendant       = request.getParameter("attendant")     != null ? request.getParameter("attendant")     : "";
		String scheduletype    = request.getParameter("scheduletype")  != null ? request.getParameter("scheduletype")  : "";
		String attach          = request.getParameter("attach")        != null ? request.getParameter("attach")        : "";
		String content         = request.getParameter("content")       != null ? request.getParameter("content")       : "";
		JSONObject resultObj   = new JSONObject();
		
		logger.debug("Title: " + title + " || summary: " + summary +" || mode: " + mode + " || cabinetId: " + cabinetId + " || scheduleTitle: " + scheduleTitle +" || createUser: " + createUser + " || createDate: " + createDate + " || scheduleDate: " + scheduleDate + " || location: " + location + " || publicstatus: " + publicstatus + " || groupname: " + groupname + " || attendant: " + attendant + " || scheduletype: " + scheduletype + " || attach: " + attach + " || content: " + content);
		
		if (title.equals("") || scheduleTitle.equals("") || (mode.equals("1") && cabinetId.equals("")) || mode.equals("") || createUser.equals("") || createDate.equals("") || scheduleDate.equals("") || publicstatus.equals("") || scheduletype.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.saveRelatedSchedule(request, userInfo.getId(), title, summary, mode, cabinetId, scheduleTitle, createUser, createDate, scheduleDate, location, publicstatus, groupname, attendant, scheduletype, attach, content);
		
		logger.debug("jsonSaveRelatedSchedule finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveRelatedTodo.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveRelatedTodo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveRelatedTodo is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String title           = request.getParameter("title")    != null ? request.getParameter("title")    : "";
		String mode            = request.getParameter("mode")     != null ? request.getParameter("mode")     : "";
		String cabinetId       = request.getParameter("cabinet")  != null ? request.getParameter("cabinet")  : "";
		String createUser      = request.getParameter("creator")  != null ? request.getParameter("creator")  : "";
		String createDate      = request.getParameter("date")     != null ? request.getParameter("date")     : "";
		String priority        = request.getParameter("priority") != null ? request.getParameter("priority") : "";
		String memo            = request.getParameter("memo")     != null ? request.getParameter("memo")     : "";
		String tasktype        = request.getParameter("tasktype") != null ? request.getParameter("tasktype") : "";
		String executor        = request.getParameter("executor") != null ? request.getParameter("executor") : "";
		String shareList       = request.getParameter("share")    != null ? request.getParameter("share")    : "";
		String attach          = request.getParameter("attach")   != null ? request.getParameter("attach")   : "";
		String content         = request.getParameter("content")  != null ? request.getParameter("content")  : "";
		
		JSONObject resultObj   = new JSONObject();
		
		logger.debug("Title: " + title + " || mode: " + mode + " || cabinetId: " + cabinetId + " || createUser: " + createUser + " || createDate: " + createDate + " || priority: " + priority + " || memo: " + memo + " || tasktype: " + tasktype + " || executor: " + executor + " || shareList: " + shareList + " || attach: " + attach + " || content: " + content);
		
		if (title.equals("") || (mode.equals("1") && cabinetId.equals("")) || mode.equals("") || createUser.equals("") || createDate.equals("") || priority.equals("") || tasktype.equals("") || executor.equals("") || content.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.saveRelatedTodo(request, userInfo.getId(), title, mode, cabinetId, createUser, createDate, priority, memo, tasktype, executor, shareList, attach, content);
		
		logger.debug("jsonSaveRelatedTodo finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveRelatedPhotoBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSavePhotoBoard(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("jsonSavePhotoBoard is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String mode            = request.getParameter("mode")      != null ? request.getParameter("mode")      : "";
		String cabinetId       = request.getParameter("cabinet")   != null ? request.getParameter("cabinet")   : "";
		String title           = request.getParameter("title")     != null ? request.getParameter("title")     : "";
		String summary         = request.getParameter("summary")   != null ? request.getParameter("summary")   : "";
		String boardTitle      = request.getParameter("boardTitle")!= null ? request.getParameter("boardTitle"): "";
		String createUser      = request.getParameter("writer")    != null ? request.getParameter("writer")    : "";
		String createDate      = request.getParameter("date")      != null ? request.getParameter("date")      : "";
		String descript        = request.getParameter("descript")  != null ? request.getParameter("descript")  : "";
		String boardId         = request.getParameter("boardid")   != null ? request.getParameter("boardid")   : "";
		String itemId          = request.getParameter("itemid")    != null ? request.getParameter("itemid")    : "";
		
		JSONObject resultObj   = new JSONObject();
		
		logger.debug("mode: " + mode + " || cabinetId: " + cabinetId + "title: " + title + " || summary: " + summary +  " || boardTitle: " + boardTitle +" || createUser: " + createUser + " || createDate: " + createDate + " || BoardId: " + boardId + " || ItemId: " + itemId + " || Description: " + descript);
		
		if (title.equals("") || (mode.equals("1") && cabinetId.equals("")) || mode.equals("") || title.equals("") || boardTitle.equals("") || createUser.equals("") || createDate.equals("") || boardId.equals("") || itemId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.savePhotoBoard(request, userInfo.getId(), title, summary, boardTitle, mode, cabinetId, createUser, createDate, descript, boardId, itemId);
		
		logger.debug("jsonSavePhotoBoard finishes!");
		return resultObj.toString();
	}
	
	private String getFileSize(long fileSize) {
		String fileSize_ = "";
		
		if (fileSize / 1024 / 1024 >= 1) {
			fileSize_ = String.format("%.2f", ((double)fileSize / 1024 / 1024 * 10) / 10);
			fileSize_ = fileSize_ + "MB";
		}
		else if (fileSize / 1024 >= 1) {
			fileSize_ = String.format("%.2f", ((double)fileSize / 1024));
			fileSize_ = fileSize_ + "KB";
		}
		else {
			fileSize_ = fileSize + "B";
		}
		return fileSize_;
	}
}