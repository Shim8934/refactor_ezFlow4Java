package egovframework.ezEKP.ezPMS.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
import egovframework.ezEKP.ezPMS.vo.ProjectCompanyVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMainSettingVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectUserVO;
import egovframework.ezEKP.ezPMS.vo.TaskLogListVO;
import egovframework.ezMobile.ezCommon.web.MCommonGWController;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzPMSGWController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MCommonGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="EzPMSService")
	private EzPMSService ezPMSService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	//프로젝트 리스트 호출
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/userId/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getProjectList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String status = request.getParameter("status");
			
//			Map<String, Object> search = new HashMap<>();
			String projectName = request.getParameter("projectName");
			String planStartDate = request.getParameter("planStartDate");
			String overview = request.getParameter("overview");	
			
			//프로젝트 리스트 가져오기
			//List<ProjectInfoVO> projectList = ezPMSService.getProjectList(info.getTenantId(), info, status, search, info.getOffSet(), lang);
			
			//프로젝트 리스트 환경설정 가져오기
			//ProjectMainSettingVO mainSetting = ezPMSService.getProjectMainSetting(userId, info.getTenantId());
			
			
			JSONObject data = new JSONObject();
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", e.getMessage());
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/" + userId + "] ended.");
		return result;
	}
	
	//새프로젝트 추가
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addNewProject(@RequestBody JSONObject json, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/projects] started.");
		
		JSONObject result = new JSONObject();
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ProjectInfoVO newProject = new ProjectInfoVO();
			newProject.setProjectName(request.getParameter("projectName"));
			newProject.setWeightInput(Integer.parseInt(request.getParameter("weightInput")));
			newProject.setPlanStartDate(request.getParameter("planStartDate"));
			newProject.setPlanEndDate(request.getParameter("planEndDate"));
			newProject.setOverview(request.getParameter("overview"));
			newProject.setAlamMailStatus(Integer.parseInt(request.getParameter("endAlamStatus")));
			newProject.setHeadManagerId(request.getParameter("headManagerId"));
			newProject.setCreatorName(request.getParameter("writerName"));
			newProject.setCreatorId(request.getParameter("creatorId"));
			newProject.setCreateDate(request.getParameter("createDate"));
			newProject.setCreatorName(request.getParameter("creatorName"));
			newProject.setCreatorName2(request.getParameter("creatorName2"));
			newProject.setCreatorDeptname(request.getParameter("creatorDeptname"));
			newProject.setCreatorDeptname2(request.getParameter("creatorDeptname2"));
			
			int projectId = ezPMSService.addNewProject(newProject, request.getParameter("tenantId"));
			
			List<Map<String, Object>> projectMemberList = (List<Map<String, Object>>) json.get("managerList");
			projectMemberList.addAll((List<Map<String, Object>>) json.get("participantList"));
			projectMemberList.addAll((List<Map<String, Object>>) json.get("viewerList"));
			
			for (int i = 0; i < projectMemberList.size(); i++) {
				ProjectMemberVO member = ezPMSService.getUserInfo((String)projectMemberList.get(i).get("userId"), Integer.parseInt(request.getParameter("tenantId")));
				member.setMemberRoleId((int)projectMemberList.get(i).get("roleId"));
				member.setProjectId(projectId);
				ezPMSService.addProjectMember(member, Integer.parseInt(request.getParameter("tenantId")));
			}
			
			JSONObject data = new JSONObject();
			data.put("projectId", projectId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/projects] ended.");
		return result;
	}
	
	//프로젝트 삭제
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}", method = RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteProject(@PathVariable int projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/projects" + projectId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ezPMSService.deleteProject(info.getTenantId(), projectId);
			
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/projects" + projectId + "] ended.");
		return result;
	}
	
	//프로젝트관리 메인 화면 설정 정보 호출
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/users/{userId}/setting", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getMainSetting(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/users/" + userId + "/setting] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ProjectMainSettingVO projectSetting = ezPMSService.getProjectMainSetting(userId, Integer.parseInt(request.getParameter("tenantId")));
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", projectSetting);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/users/" + userId + "/setting] ended.");
		return result;
	}
	
	//프로젝트관리 메인 화면 설정
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/users/{userId}/setting", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateMainSetting(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/users/" + userId + "/setting] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ProjectMainSettingVO project = new ProjectMainSettingVO();
			
			ezPMSService.updateMainSetting(project, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/users/" + userId + "/setting] ended.");
		return result;
	}
	
	//프로젝트 상태 변경
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/status", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject udpateProjectStatus(@PathVariable int projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "/status] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String status = request.getParameter("status");
			
			ezPMSService.updateProjectStatus(projectId, status, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/"+ projectId + "/status] ended.");
		return result;
	}
	
	//프로젝트 개요 정보 호출
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/userId/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getProjectOverview(@PathVariable int projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
			ProjectInfoVO project = ezPMSService.getProjectDetails(projectId, userId, info.getTenantId(), info.getOffSet(), lang);
			
			JSONObject data = new JSONObject();
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "] ended.");
		return result;
	}
	
	//프로젝트 수정
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateProject(@PathVariable int projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ProjectInfoVO project = new ProjectInfoVO();
			ezPMSService.updateProject(project, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "] ended.");
		return result;
	}
	
	//프로젝트 역할별 멤버 보기
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/roles/{roleId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getProjectMember(@PathVariable int projectId, @PathVariable int roleId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/roles/" + roleId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
			List<ProjectMemberVO> memberList = ezPMSService.getProjectMember(projectId, roleId, lang);
			
			JSONObject data = new JSONObject();
			
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/roles/" + roleId + "] ended.");
		return result;
	}
	
	//칸반 순서 변경
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/userId/{userId}/order", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject changeKanbanOrder(@PathVariable int projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "/order] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String orderStatus = request.getParameter("orderStatus");
			
			ezPMSService.changeKanbanOrder(projectId, userId, orderStatus, info.getTenantId());
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "] ended.");
		return result;
	}
	
	//프로젝트 즐겨찾기 추가
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/userId/{userId}/favorites/{projectId}", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addFavoriteProject(@PathVariable String userId, @PathVariable int projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/userId/" + userId + "/favorites/"+ projectId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ezPMSService.addFavoriteProject(projectId, userId, info.getTenantId());
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/userId/" + userId + "/favorites/"+ projectId + "] ended.");
		return result;
	}
	
	//프로젝트 즐겨찾기 삭제
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/userId/{userId}/favorites/{projectId}", method = RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteFavoriteProject(@PathVariable String userId, @PathVariable int projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/userId/" + userId + "/favorites/"+ projectId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ezPMSService.deleteFavortieProject(projectId, userId, info.getTenantId());
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/userId/" + userId + "/favorites/"+ projectId + "] ended.");
		return result;
	}
	
	//작업 이력 추가
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/logs", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addTaskLog(@PathVariable int projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/projects/" + projectId + "/logs] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			TaskLogListVO taskLog = new TaskLogListVO();
			
			ezPMSService.addTaskLog(taskLog, info.getTenantId(), info.getUserId());
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/projects/" + projectId + "/logs] ended.");
		return result;
	}
	
	//작업이력 리스트 호출
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/logs", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getTaskLogList(@PathVariable int projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/logs] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
			int taskId = Integer.parseInt(request.getParameter("taskId"));
			int groupId = Integer.parseInt(request.getParameter("groupId"));
			
			Map<String, Object> search = new HashMap<>();
			
			List<TaskLogListVO> taskLogList = ezPMSService.getTaskLogList(taskId, groupId, search, info.getOffSet(), lang, info.getTenantId());
			
			JSONObject data = new JSONObject();
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/logs] ended.");
		return result;
	}
	
	//프로젝트 리스트 개수 호출
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/userId/{userId}/count", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getProjectListCount(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/" + userId + "/count] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ProjectInfoVO project = new ProjectInfoVO();
			
			int projectListCount = ezPMSService.getProjectListCount(project, info.getTenantId());
			
			JSONObject data = new JSONObject();
			data.put("projectListCount", projectListCount);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/" + userId + "/count] ended.");
		return result;
	}
	
	
	//업무 리스트 개수 호출
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/tasks/count", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getTaskListCount(@PathVariable int projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/tasks/count] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String status = request.getParameter("status");
			String myTask = request.getParameter("myTask");
			
			int taskListCount = ezPMSService.getTaskListCount(status, myTask, projectId, info.getTenantId());
			
			JSONObject data = new JSONObject();
			data.put("taskListCount", taskListCount);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/tasks/count] ended.");
		return result;
	}
	
	//작업이력 리스트 개수 호출
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/logs/count", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getTaskLogListCount(@PathVariable int projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/tasks/count] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			TaskLogListVO taskLog = new TaskLogListVO();
			
			int taskLogListCount = ezPMSService.getTaskLogListCount(taskLog, info.getTenantId());
			
			JSONObject data = new JSONObject();
			data.put("taskLogListCount", taskLogListCount);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/logs/count] ended.");
		return result;
	}
	
	//멤버 수 호출
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/role/{roleId}/count", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getMemberCount(@PathVariable int projectId, @PathVariable int roleId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/role/" + roleId + "/count] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			int memberCount = ezPMSService.getMemberCount(projectId, roleId, info.getTenantId());
			
			JSONObject data = new JSONObject();
			data.put("memberCount", memberCount);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/role/" + roleId + "/count] ended.");
		return result;
	}
	
	// 공통 부분 API
		/**
		 * 프로젝트관리 G/W [GET] 회사리스트 
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping(value="/rest/ezPMS/companies", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
		public JSONObject getCompanyList(HttpServletRequest request) throws Exception {
			LOGGER.debug("ezJournal G/W getCompanyList started.");
			
			JSONObject result = new JSONObject();
			
			try {
				String userId = request.getParameter("userId");
				String serverName = request.getHeader("x-user-host");
				MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
				String companyId = request.getParameter("companyId");
				if (companyId == null || companyId.equals("")) {
					companyId = info.getCompanyId();
				}
				String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
				List<ProjectCompanyVO> compList = ezPMSService.getCompanyList(userId, info.getTenantId(), companyId,lang);
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", compList);
			} catch (Exception e) {
				result.put("code", 1);
				result.put("status", "error");
				result.put("data", "");
			}
			
			LOGGER.debug("ezJournal G/W getCompanyList ended.");
			return result;
		}
		
		/**
		 * 프로젝트관리 G/W [GET] 부서리스트 
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping(value="/rest/ezPMS/depts", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
		public JSONObject getDeptList(HttpServletRequest request) throws Exception {
			LOGGER.debug("ezJournal G/W getDeptList started.");
			
			JSONObject result = new JSONObject();
			
			try {
				String userId = request.getParameter("userId");
				String serverName = request.getHeader("x-user-host");
				MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
				
				LOGGER.debug("userId : " + userId);
				String companyId = request.getParameter("companyId");
				
				if (companyId == null || companyId.equals("")) {
					companyId = info.getCompanyId();
				}
				String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
				List<DeptViewVO> deptList = ezPMSService.getDeptViewList(userId, companyId, info.getTenantId(),lang);
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", deptList);
			} catch (Exception e) {
				result.put("code", 1);
				result.put("status", "error");
				result.put("data", "");
			}
			
			LOGGER.debug("ezJournal G/W getDeptList ended.");
			return result;
		}
		
		/**
		 * 프로젝트관리 G/W [GET] 사원리스트 
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping(value="/rest/ezPMS/users", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
		public JSONObject getUserList(HttpServletRequest request) throws Exception {
			LOGGER.debug("ezJournal G/W getUserList started.");
			
			JSONObject result = new JSONObject();
			
			try {
				String key = request.getParameter("key");
				String value = request.getParameter("value");
				String serverName = request.getHeader("x-user-host");
				MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
				String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
				
				List<ProjectUserVO> userList = ezPMSService.getDeptUserList(info.getTenantId(), key, value,lang);
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", userList);
			} catch (Exception e) {
				result.put("code", 1);
				result.put("status", "error");
				result.put("data", "");
			}
			
			LOGGER.debug("ezJournal G/W getUserList ended.");
			return result;
		}
}
