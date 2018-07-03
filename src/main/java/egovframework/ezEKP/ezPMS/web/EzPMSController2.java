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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;

import egovframework.ezEKP.ezPMS.vo.ProjectPagination;
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
		int tenantId = userInfo.getTenantId();
		
		String projectId = request.getParameter("projectId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/weight/" + projectId, param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			model.addAttribute("remainingWeight", data.get("remainingWeight"));
			model.addAttribute("projectStartDate", data.get("projectStartDate"));
			model.addAttribute("projectEndDate", data.get("projectEndDate"));
			model.addAttribute("weightInput", data.get("weightInput"));
			model.addAttribute("projectStatus", data.get("projectStatus"));
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
		
		param.remove("managerList");
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + projectId + "/users/" + userInfo.getId(), param, request, "post", jsonList);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			String taskId = (String) resultBody.get("data");
			model.addAttribute("data", taskId);
		}
				
		LOGGER.debug("ezPMS addTask ended");
		
		return "json";
	}
	
	
	/**
	 * 프로젝트관리 업무 상세보기 호출함수
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
//	@RequestMapping(value="/ezPMS/goTaskDetail.do")
//	public String goTaskDetail(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
//		
//		LOGGER.debug("ezPMS TaskListMain started");
//		
//		LoginVO userInfo = commonUtil.userInfo(loginCookie);
//		
//		String taskId = request.getParameter("taskId");
//		
//		HashMap<String, Object> param = new HashMap<String, Object>();
//		
//		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId(), param, request, "get", null);
//		String status = resultBody.get("status").toString();
//		
//		if(status.equals("ok")) {
//			JSONObject taskDetail = (JSONObject) resultBody.get("data");
//			model.addAttribute("taskDetail", taskDetail);
//		}
//		
//		LOGGER.debug("ezPMS TaskListMain ended");
//		
//		return "/ezPMS/taskListMain";
//	}
	
	
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
		String groupId = request.getParameter("groupId");
		String roleId = request.getParameter("roleId");
		
		String url = null;
		
		// 상위그룹이 프로젝트 자체일 때는 groupId값이 넘어오지 않는다
		if(groupId != null && !groupId.equals("")) {
			url = "/rest/ezPMS/member-list/" + projectId + "/groupId/" + groupId;
		} else {
			url = "/rest/ezPMS/member-list/" + projectId + "/roles/" + roleId;
		}
		
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
		String groupId = request.getParameter("groupId");
		String type = request.getParameter("type");
		
		model.addAttribute("projectId", projectId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("type", type);
		
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
	
	/**
	 * 프로젝트관리 간트차트 프로젝트, 업무 데이터 조회
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/getProjectForGantt.do")
	public String getProjectForGantt(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS getProjectForGantt started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String projectId = request.getParameter("projectId");
		String taskStatus = request.getParameter("status");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("position", "gantt");
		param.put("status", taskStatus);
		
		JSONObject resultBodyTask = commonUtil.getJsonFromRestApi("/rest/ezPMS/task-list/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBodyTask.get("status").toString();
		
		if(status.equals("ok")) {
			JSONObject taskList = (JSONObject) resultBodyTask.get("data");
			model.addAttribute("taskList", taskList.get("taskList"));
			model.addAttribute("userRoleId", taskList.get("userRoleId"));
		}
		
		JSONObject resultBodyProject = commonUtil.getJsonFromRestApi("/rest/ezPMS/projects/" + projectId + "/users/" + userInfo.getId() + "/gantt", param, request, "get", null);
		status = resultBodyProject.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("projectDetail", resultBodyProject.get("data"));
		}
		
		JSONObject resultBodyGroup = commonUtil.getJsonFromRestApi("/rest/ezPMS/projects/" + projectId + "/groups/users/" + userInfo.getId() + "/gantt", param, request, "get", null);
		status = resultBodyGroup.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("groupList", resultBodyGroup.get("data"));
		}
		
		if(taskStatus != null){
			model.addAttribute("taskStatus", taskStatus);
		}

		model.addAttribute("projectId", projectId);
		LOGGER.debug("ezPMS getProjectForGantt ended");
		
		return "/ezPMS/taskListGantt";
	}
	
	/**
	 * 업무 데이터 상세 조회
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/getTaskDetails.do")
	public String getTaskDetails(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS getTaskDetails started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String taskId = request.getParameter("taskId");
		String projectId = request.getParameter("projectId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", userInfo.getTenantId());
		param.put("projectId", projectId);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONObject taskDetails = (JSONObject) resultBody.get("data");
			model.addAttribute("taskDetails", taskDetails);
		}
		
		param.put("userIdType", request.getParameter("userIdType"));
		JSONObject resultMS = commonUtil.getJsonFromRestApi("/rest/ezPMS/users/"+ userInfo.getId() +"/setting", param, request, "get", null);
		status = resultMS.get("status").toString();
		
		if(status.equals("ok")) {
			JSONObject mainSetting = (JSONObject) resultMS.get("data");
			model.addAttribute("mainSetting", mainSetting);
		}
		
		JSONObject resultBodyWeight = commonUtil.getJsonFromRestApi("/rest/ezPMS/weight/" + projectId, param, request, "get", null);
		status = resultBodyWeight.get("status").toString();
		
		if(status.equals("ok")) {
			JSONObject weightData = (JSONObject) resultBodyWeight.get("data");
			model.addAttribute("weightData", weightData);
		}
		
		LOGGER.debug("ezPMS getTaskDetails ended");
		
		return "/ezPMS/pmsTaskDetails";
	}
	
	/**
	 * 업무 데이터 상세 조회 (업무정보 탭)
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/getTaskDetailsTab.do")
	public String getTaskDetailsTab(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS getTaskDetailsTab started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String taskId = request.getParameter("taskId");
		String groupId = request.getParameter("groupId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("projectId", request.getParameter("projectId"));
		
		if (groupId == null || groupId.equals("")) {
			JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId(), param, request, "get", null);
			String status = resultBody.get("status").toString();
			
			if(status.equals("ok")) {
				JSONObject taskDetails = (JSONObject) resultBody.get("data");
				model.addAttribute("taskDetails", taskDetails);
				model.addAttribute("target", "task");
			}
		} else {
			JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/groups/" + Long.parseLong(groupId) + "/users/" + userInfo.getId(), param, request, "get", null);
			String status = resultBody.get("status").toString();
			
			if(status.equals("ok")) {
				JSONObject taskDetails = (JSONObject) resultBody.get("data");
				model.addAttribute("taskDetails", taskDetails);
				model.addAttribute("target", "group");
			}
		}
		
		
		LOGGER.debug("ezPMS getTaskDetailsTab ended");
		
		return "/ezPMS/pmsTaskInfoTab";
	}
	
	/**
	 * 업무 정보 수정 페이지 호출
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/goUpdateTaskInfo.do")
	public String goTaskInfo(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS goTaskInfo started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String taskId = request.getParameter("taskId");
		long projectId = 0;
		String target = request.getParameter("target");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", userInfo.getTenantId());
		
		if (target.equals("task")) {
			JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId(), param, request, "get", null);
			String status = resultBody.get("status").toString();
			
			if(status.equals("ok")) {
				JSONObject taskDetails = (JSONObject) resultBody.get("data");
				model.addAttribute("taskDetails", taskDetails);
				projectId = Long.parseLong(taskDetails.get("projectId").toString());
			}
			
			JSONObject resultBodyWeight = commonUtil.getJsonFromRestApi("/rest/ezPMS/weight/" + projectId, param, request, "get", null);
			status = resultBodyWeight.get("status").toString();
			
			if(status.equals("ok")) {
				JSONObject weightData = (JSONObject) resultBodyWeight.get("data");
				model.addAttribute("weightData", weightData);
			}
		} else if (target.equals("group")) {
			projectId = Long.parseLong(request.getParameter("projectId"));
			param.put("projectId", projectId);
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/groups/" + Long.parseLong(taskId) + "/users/" + userInfo.getId(), param, request, "get", null);
			String status = resultBody.get("status").toString();
			
			if(status.equals("ok")) {
				JSONObject taskDetails = (JSONObject) resultBody.get("data");
				model.addAttribute("taskDetails", taskDetails);
				LOGGER.debug("Headmanager name : " + taskDetails.get("headManagerName"));
				
				JSONObject resultBodyMember = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/member-list/group/" + Long.parseLong(taskId) + "/users/" + userInfo.getId(), param, request, "get", null);
				status = resultBodyMember.get("status").toString();
				
				if(status.equals("ok")) {
					JSONArray groupTaskMember = (JSONArray) resultBodyMember.get("data");
					model.addAttribute("groupTaskMember", groupTaskMember);
				}
			}
		}
		
		model.addAttribute("target", request.getParameter("target"));
		
		LOGGER.debug("ezPMS goUpdateTaskInfo ended");
		
		return "/ezPMS/pmsTaskInfoUpdate";
	}
	
	/**
	 * 업무 정보 수정
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/updateTaskInfo.do")
	public String updateTaskInfo(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS updateTaskInfo started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		String taskId = (String)param.get("taskId");
		
		JSONObject jsonList = new JSONObject();
		jsonList.put("managerList", param.get("managerList"));
		
		String url = "/rest/ezPMS/tasks/" + taskId + "/users/" + userId;
				
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "put", jsonList);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("result", "success");
		}
		
		LOGGER.debug("ezPMS updateTaskInfo ended");
		
		return "json";
	}
	
	/**
	 * 업무 상태 수정팝업 호출.
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/goUpdateTaskStatus.do")
	public String goTaskStatus(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS goUpdateTaskStatus started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
//		String taskId = (String)param.get("taskId");
//		
//		JSONObject jsonList = new JSONObject();
//		jsonList.put("managerList", param.get("managerList"));
//		
//		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId(), param, request, "put", jsonList);
//		String status = resultBody.get("status").toString();
		
		LOGGER.debug("ezPMS goUpdateTaskStatus ended");
		
		return "/ezPMS/pmsTaskStatusUpdate";
	}
	
	/**
	 * 업무 상태 수정
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/updateTaskStatus.do")
	public String updateTaskStatus(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS updateTaskStatus started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String taskId = (String)param.get("taskId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId() + "/status", param, request, "put", null);
		String status = resultBody.get("status").toString();
		
		LOGGER.debug("ezPMS updateTaskStatus ended");
		
		return "json";
	}
	
	/**
	 * 업무 관련 게시물 조회 (관련게시물 탭)
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/getBoardListTab.do")
	public String getBoardListTab(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS getBoardListTab started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String taskId = request.getParameter("taskId");
		String projectId = request.getParameter("projectId");
		String userId = userInfo.getId();
		String groupId = request.getParameter("groupId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("taskId", taskId);
		param.put("startRow", 0);
		param.put("limit", 10);
		param.put("groupId", groupId);
		
//		String boardUrl = "/rest/ezPMS/boards/list/" + projectId + "/users/" + userId;
//		JSONObject boardResult = commonUtil.getJsonFromRestApi(boardUrl, param, request, "get", null);
//		String boardStatus = boardResult.get("status").toString();
//		
//		if(boardStatus.equals("ok")) {
//			JSONArray boardList = (JSONArray) boardResult.get("data");
//			model.addAttribute("boardList", boardList);
//			model.addAttribute("groupId", groupId);
//			model.addAttribute("taskId", taskId);
//		}
		
		model.addAttribute("projectId", projectId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("taskId", taskId);
		
		LOGGER.debug("ezPMS getBoardListTab ended");
		
		return "/ezPMS/pmsBoardListTab";
	}
	
	/**
	 * 업무 작업이력 조회 (작업이력 탭)
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/getTaskLogListTab.do")
	public String getTaskLogListTab(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS getTaskLogListTab started");
		
		String projectId = request.getParameter("projectId");
		String groupId = request.getParameter("groupId");
		String taskId = request.getParameter("taskId");
		
		model.addAttribute("projectId", projectId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("taskId", taskId);
		
		LOGGER.debug("ezPMS getTaskLogListTab ended");
		
		return "/ezPMS/pmsTaskLogListTab";
	}
	
	/**
	 * 새 그룹 추가 팝업 호출.
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/goAddGroup.do")
	public String goAddGroup(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS goAddGroup started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
//		String taskId = (String)param.get("taskId");
//		
//		JSONObject jsonList = new JSONObject();
//		jsonList.put("managerList", param.get("managerList"));
//		
//		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId(), param, request, "put", jsonList);
//		String status = resultBody.get("status").toString();
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("userName", userInfo.getDisplayName());
		
		LOGGER.debug("ezPMS goAddGroup ended");
		
		return "/ezPMS/pmsAddGroup";
	}
	
	/**
	 * 그룹 추가
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/addGroup.do")
	public String addGroup(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS addGroup started");
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			String projectId = (String) param.get("projectId");
			String url = "/rest/ezPMS/groups/"+ projectId +"/users/" + userInfo.getId();
			String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
			
			param.put("createDate", today);
			param.put("userId", userInfo.getId());
			
			JSONObject jsonList = new JSONObject();
			jsonList.put("managerList", param.get("managerList"));
			jsonList.put("participantList", param.get("participantList"));
			
			param.remove("managerList");
			param.remove("participantList"); 
			JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "post", jsonList);
			String status = resultBody.get("status").toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		LOGGER.debug("ezPMS addGroup ended");
		
		return "json";
	}
	
	/**
	 * 그룹 삭제
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/deleteGroup.do")
	@ResponseBody
	public String deleteGroup(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS deleteGroup started");
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			long projectId = Long.parseLong(param.get("projectId").toString());
			long groupId = Long.parseLong(param.get("groupId").toString());
			String userId = userInfo.getId();
			
			param.put("userId", userId);
			
			String url = "/rest/ezPMS/projects/" + projectId + "/groups/"+ groupId;
			
			commonUtil.getJsonFromRestApi(url, param, request, "delete", null);
		} catch (Exception e) {
			e.printStackTrace();
		}
		LOGGER.debug("ezPMS deleteGroup ended");
		
		return "json";
	}
	
	/**
	 * 업무 가중치 수정.
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/updateTaskWeight.do")
	public String updateTaskWeight(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS updateTaskWeight started");
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String taskId = (String)param.get("taskId");
			String userId = userInfo.getId();
			
			param.put("userId", userId);
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/weight/", param, request, "put", null);
			String status = resultBody.get("status").toString();
			
//			if(status.equals("ok")) {
//				JSONObject taskDetails = (JSONObject) resultBody.get("data");
//				model.addAttribute("taskDetails", taskDetails);
//			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS updateTaskWeight ended");
		
		return "json";
	}
	
	/**
	 * 업무 실제진행률 수정.
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/updateTaskProgress.do")
	public String updateTaskProgress(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS updateTaskProgress started");
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String taskId = (String)param.get("taskId");
			String userId = userInfo.getId();
			
			param.put("userId", userId);
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/progress/", param, request, "put", null);
			String status = resultBody.get("status").toString();
			
//			if(status.equals("ok")) {
//				JSONObject taskDetails = (JSONObject) resultBody.get("data");
//				model.addAttribute("taskDetails", taskDetails);
//			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS updateTaskProgress ended");
		
		return "json";
	}
}
