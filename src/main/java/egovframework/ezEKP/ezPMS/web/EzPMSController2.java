package egovframework.ezEKP.ezPMS.web;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;

import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPMSController2 {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSController2.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private Properties config;
	
	
	/**
	 * 프로젝트관리 프로젝트 업무 트리 호출함수
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/projectTaskTree.do")
	public String projectTaskTree(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS projectTaskTree started");
		
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
				
		LOGGER.debug("ezPMS projectTaskTree ended");
		
		return "json";
	}
	
	
	/**
	 * 프로젝트관리 업무 리스트 호출함수
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/projectTaskList.do")
	public String projectTaskList(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS projectTaskList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String projectId = request.getParameter("projectId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/task-list/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray taskList = (JSONArray) resultBody.get("data");
			model.addAttribute("taskList", taskList);
		}
		
		LOGGER.debug("ezPMS projectTaskList ended");
		
		return "/ezPMS/taskListMain";
	}
	
	
	/**
	 * 프로젝트관리 업무 리스트 메인 화면 호출함수
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/taskListMain.do")
	public String taskListMain(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS taskListMain started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String projectId = request.getParameter("projectId");
		
		model.addAttribute("projectId", projectId);
		
		LOGGER.debug("ezPMS taskListMain ended");
		
		return "/ezPMS/pmsTaskListMain";
	}
	
	
	/**
	 * 프로젝트관리 업무 등록 화면 호출함수
	 * @param request
	 * @param model
	 * @param vo
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/goAddTask.do")
	public String goAddTask(HttpServletRequest request, Model model, ProjectTaskVO vo,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS addTask started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String writerId = userInfo.getId();
		String writerName = userInfo.getDisplayName();
		String writerDeptName = userInfo.getDeptName();
		
		String projectId = request.getParameter("projectId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/weight/" + projectId, param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			model.addAttribute("remainingWeight", data.get("remainingWeight"));
			model.addAttribute("projectStartDate", data.get("projectStartDate"));
			model.addAttribute("projectEndDate", data.get("projectEndDate"));
			model.addAttribute("weightInput", data.get("weightInput"));
		}
		
		model.addAttribute("projectId", projectId);
		model.addAttribute("writerId", writerId);
		model.addAttribute("writerName", writerName);
		model.addAttribute("writerDeptName", writerDeptName);
		
		LOGGER.debug("ezPMS addTask ended");
		
		return "/ezPMS/pmsAddTask";
	}
	
	
	/**
	 * 프로젝트관리 업무 등록 함수
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/addTask.do")
	public String addTask(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) throws Exception {
		
		LOGGER.debug("ezPMS addTask started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		String projectId = (String) param.get("projectId");
		
		param.put("tenantId", userInfo.getTenantId());
		param.put("writerId", userInfo.getId());
		param.put("writeDate", today);
		param.put("writerName", userInfo.getDisplayName1());
		param.put("writerName2", userInfo.getDisplayName2());
		param.put("writerDeptname", userInfo.getDeptName1());
		param.put("writerDeptname2", userInfo.getDeptName2());
		
		JSONObject jsonList = new JSONObject();
		jsonList.put("managerList", param.get("managerList"));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + projectId + "/users/" + userInfo.getId(), param, request, "post", jsonList);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
		}
				
		LOGGER.debug("ezPMS addTask ended");
		
		return "";
	}
	
	
	/**
	 * 프로젝트관리 업무 상세보기 호출함수
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/goTaskDetail.do")
	public String goTaskDetail(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS TaskListMain started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String taskId = request.getParameter("taskId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONObject taskDetail = (JSONObject) resultBody.get("data");
			model.addAttribute("taskDetail", taskDetail);
		}
		
		LOGGER.debug("ezPMS TaskListMain ended");
		
		return "/ezPMS/taskListMain";
	}
	
	
	/**
	 * 프로젝트 참여 멤버 조회
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getProjectMemberList.do")
	public String getProjectMemberList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS getProjectMemberList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String projectId = request.getParameter("projectId");
		String roleId = request.getParameter("roleId");
		
		String url = "/rest/ezPMS/member-list/" + projectId + "/roles/" + roleId;
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray memberList = (JSONArray) resultBody.get("data");
			model.addAttribute("memberList", memberList);
		}
		
		LOGGER.debug("ezPMS getProjectMemberList ended");
		
		return "ezPMS/memberList";
	}
	
	
	/**
	 * 프로젝트관리 멤버리스트 페이지 호출함수
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/goProjectMemberList.do")
	public String goProjectMemberList(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS goProjectMemberList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String projectId = request.getParameter("projectId");
		
		model.addAttribute("projectId", projectId);
		
		LOGGER.debug("ezPMS goProjectMemberList ended");
		
		return "/ezPMS/pmsSetTaskMember";
	}
	
	/**
	 * 프로젝트관리 멤버리스트 페이지 호출함수
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/goGroupTree.do")
	public String goGroupTree(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS goGroupTree started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String projectId = request.getParameter("projectId");
		
		model.addAttribute("projectId", projectId);
		
		LOGGER.debug("ezPMS goGroupTree ended");
		
		return "/ezPMS/groupTree";
	}
	
}
