package egovframework.ezEKP.ezPMS.web;

import java.net.URI;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
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
		
		model.addAttribute("projectName", projectName);
		model.addAttribute("projectId", projectId);
		model.addAttribute("writerId", writerId);
		model.addAttribute("writerName", writerName);
		model.addAttribute("writerDeptName", writerDeptName);
		model.addAttribute("taskName", taskName);
		model.addAttribute("groupId", groupId);
		model.addAttribute("taskId", taskId);
		
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
		
		return "ezPMS/projectDragAndDrop";
	}
	
	@RequestMapping(value = "/ezPMS/uploadProjectAttach.do", produces = "text/plain; charset=utf-8")
	public String uploadProjectAttach(MultipartHttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("ezPMS uploadProjectAttach started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.journalGWServerURL");
		String url = gwServerUrl + "/rest/ezPMS/attachfiles";
		
		URI uri = URI.create(url);
	}
}
