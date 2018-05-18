package egovframework.ezEKP.ezPMS.web;

import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.ezEKP.ezPMS.vo.ProjectPagination;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPMSController3 {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSController3.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private Properties config;
	
	@RequestMapping(value="/ezPMS/getBoardMain.do")
	public String getProjectBoard(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS getProjectBoard started");		
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("onlyGroup", onlyGroup);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}
		
		model.addAttribute("projectId", projectId);
		
		LOGGER.debug("ezPMS getProjectBoard ended");
		
		return "/ezPMS/pmsBoardMain";
	}
	
	@RequestMapping(value="/ezPMS/goAddBoard.do")
	public String goAddBoard(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {		
		LOGGER.debug("ezPMS goAddBoard started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String writerId = userInfo.getId();
		String writerName = userInfo.getDisplayName();
		String writerDeptName = userInfo.getDeptName();	
		String projectName = request.getParameter("projectName");
		String projectId = request.getParameter("projectId");
		String taskName = request.getParameter("taskName");
		String groupId = request.getParameter("groupId");
		String taskId = request.getParameter("taskId");
		String mode = request.getParameter("mode");
		
		model.addAttribute("projectName", projectName);
		model.addAttribute("projectId", projectId);
		model.addAttribute("writerId", writerId);
		model.addAttribute("writerName", writerName);
		model.addAttribute("writerDeptName", writerDeptName);
		model.addAttribute("taskName", taskName);
		model.addAttribute("groupId", groupId);
		model.addAttribute("taskId", taskId);
		model.addAttribute("mode", mode);
		
		LOGGER.debug("ezPMS goAddBoard ended");
		
		return "/ezPMS/pmsAddBoard";
	}
	
	@RequestMapping(value="/ezPMS/addBoard.do")
	public String addBoard(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) throws Exception {		
		LOGGER.debug("ezPMS addBoard started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		param.put("tenantId", userInfo.getTenantId());
		param.put("writerId", userInfo.getId());
		param.put("writeDate", today);
		param.put("writerName", userInfo.getDisplayName1());
		param.put("writerName2", userInfo.getDisplayName2());
		param.put("writerDeptname", userInfo.getDeptName1());
		param.put("writerDeptname2", userInfo.getDeptName2());
		param.put("writerPosition", userInfo.getTitle1());
		param.put("writerPosition2", userInfo.getTitle2());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards", param, request, "post", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("data", "test");
		}
		
		LOGGER.debug("ezPMS addBoard ended");
		
		return "json";
	}
	
	@RequestMapping(value="/ezPMS/getTaskSelectionTree.do")
	public String getTaskSelectionTree(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {		
		LOGGER.debug("ezPMS getTaskTree started");
		
		// 여기 거의 다 getProjectBoard()랑 똑같은데 메서드로 묶어버릴까...
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("onlyGroup", onlyGroup);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}
				
		LOGGER.debug("ezPMS getTaskTree started");
		
		return "/ezPMS/pmsTaskSelectionTree";
	}
	
	@RequestMapping(value="/ezPMS/getBoardList.do", method=RequestMethod.GET)
	public String getBoardList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {	
		LOGGER.debug("ezPMS getBoardList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int totalCount = 0;
		int listCnt = 10;
		int countPage = 10;
		int currentPage = Integer.parseInt(request.getParameter("currentPage"));
		String projectId = request.getParameter("projectId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("groupId", request.getParameter("groupId"));
		param.put("taskId", request.getParameter("taskId"));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/list-count/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			totalCount = Integer.parseInt((String) resultBody.get("data"));
		}
		
		ProjectPagination paging = new ProjectPagination(totalCount, listCnt, countPage, currentPage);
		model.addAttribute("paging", paging);
		
		param.put("startRow", paging.getStartCount());
		param.put("limit", listCnt);
	
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/list/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray boardList = (JSONArray) resultBody.get("data");
			model.addAttribute("data", boardList);
		} 
		
		LOGGER.debug("ezPMS getBoardList ended");
		
		return "/ezPMS/pmsBoardList";
	}
	
	@RequestMapping(value = "/ezPMS/dragAndDrop.do")
	public String projectDragAndDrop(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("ezPMS projectDragAndDrop started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String attachFileNameMaxLength = commonUtil.getTenantConfigRest("attachFileNameMaxLength", userInfo.getId(), request);
			
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
		String mode = "";
		String projectId = "";
		
		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}
		if (request.getParameter("projectId") != null && !request.getParameter("projectId").equals("")) {
			projectId = request.getParameter("projectId");
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("mode", mode);
		model.addAttribute("projectId", projectId);
		LOGGER.debug("ezPMS projectDragAndDrop ended");
		
		return "ezPMS/pmsDragAndDrop";
	}
	
	@SuppressWarnings({"unchecked", "rawtypes"})
	@ResponseBody
	@RequestMapping(value = "/ezPMS/uploadProjectAttach.do", produces = "text/plain; charset=utf-8")
	public String uploadProjectAttach(MultipartHttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("ezPMS uploadProjectAttach started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.projectGWServerURL");
		String url = gwServerUrl + "/rest/ezPMS/attachfiles";
		
		URI uri = URI.create(url);
		
		List<MultipartFile> files = request.getFiles("fileToUpload"); 
		int cnt = files.size();
		int maxSize = 0;
		LOGGER.debug("###files : " + files + ", cnt: " + cnt);
		
		Long[] fileSize = new Long[cnt];        
        String[] resultUpload = new String[cnt];
        String[] sGUID = new String[cnt];
        String[] pUploadSN = new String[cnt];
        maxSize = Integer.parseInt(request.getParameter("maxSize"));
        JSONObject jsonObject = new JSONObject();
        JSONArray jsonArray = new JSONArray();
        
        String mode = "";
		String projectId = "";
		
		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}
		if (request.getParameter("projectId") != null && !request.getParameter("projectId").equals("")) {
			projectId = request.getParameter("projectId");		
		}

		LOGGER.debug("mode : " + mode + " | projectId : " + projectId);
		
		for (int i = 0; i < cnt; i++) {
            resultUpload[i] = "false";
            sGUID[i] = UUID.randomUUID().toString();
            pUploadSN[i] = "{" + sGUID[i] + "}";
        }
        
        HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		if (StringUtils.isNotEmpty(files.get(0).getOriginalFilename()) && StringUtils.isNotBlank(files.get(0).getOriginalFilename()) && cnt > 0) {        	
            for (int i = 0; i < cnt; i++) {
            	JSONObject fileJson = new JSONObject();
            	
            	byte[] bytes = files.get(i).getBytes();
            	fileSize[i] = files.get(i).getSize();
                String originalFilename = files.get(i).getOriginalFilename();
                fileJson.put("bytes", bytes);
                fileJson.put("fileSize", fileSize[i]);
                fileJson.put("originalFilename", originalFilename);
                
                jsonArray.add(fileJson);
            }
        }
        jsonObject.put("fileArray", jsonArray);
		jsonObject.put("cnt", cnt);
		jsonObject.put("maxSize", maxSize);
		jsonObject.put("userId",userInfo.getId());
        
		HttpEntity<JSONObject> entity = new HttpEntity(jsonObject, headers);
		
        RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(uri, HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
	
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		Object data = "";
		
		if (status.equals("ok")) {
			data = resultBody.get("data");
			model.addAttribute("data", data.toString());
		}

		LOGGER.debug("status: " + status);
        LOGGER.debug("uploadProjectAttach ended");
        
        return data.toString();
	}
	
	public String uploadFileDelete(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("ezPMS uploadFileDelete started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String fileList = request.getParameter("fileList");
		
		String mode = "";
		String projectId = "";
		String filePath = "";
		
		LOGGER.debug("fileList : " + fileList);
		
		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}
		
		if (request.getParameter("projectId") != null && !request.getParameter("projectId").equals("")) {
			projectId = request.getParameter("projectId");
		} 

		filePath = "uploadFile";
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("mode", mode);
		param.put("filePath", filePath);
		param.put("fileList", fileList);
		
		String restUrl = "/rest/ezPMS/journals/" + projectId + "/attachfiles";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "delete", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			LOGGER.debug("status : " + status);
		}

		LOGGER.debug("tempUploadFileDelete ended");
        
        return status;
	}
}
