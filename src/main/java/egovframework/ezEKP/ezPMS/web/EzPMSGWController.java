package egovframework.ezEKP.ezPMS.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezMobile.ezCommon.web.MCommonGWController;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzPMSGWController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MCommonGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	//프로젝트 리스트 호출
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/userId/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getProjectList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String projectName = request.getParameter("projectName");
			String planStartDate = request.getParameter("planStartDate");
			String overview = request.getParameter("overview");
			
			int count = 5;
			
			List<String> list = new ArrayList<>();
			list.add(projectName);
			list.add(serverName);
			list.add(planStartDate);
			list.add(overview);
			
			JSONObject data = new JSONObject();
			data.put("count", count);
			data.put("list", list);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/" + userId + "] ended.");
		return result;
	}
	
	//새프로젝트 추가
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addNewProject(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/projects] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
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
	public JSONObject deleteProject(@PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/projects" + projectId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
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
	
	//프로젝트관리 메인 화면 설정
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/users/{userId}/setting", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateMainSetting(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/users/" + userId + "/setting] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
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
	public JSONObject udpateProjectStatus(@PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "/status] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
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
	public JSONObject getProjectOverview(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
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
	public JSONObject updateProject(@PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
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
	public JSONObject getProjectMember(@PathVariable String projectId, @PathVariable String roleId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/roles/" + roleId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
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
	public JSONObject changeKanbanOrder(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "/order] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
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
	public JSONObject addFavoriteProject(@PathVariable String userId, @PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/userId/" + userId + "/favorites/"+ projectId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
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
	public JSONObject deleteFavoriteProject(@PathVariable String userId, @PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/userId/" + userId + "/favorites/"+ projectId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
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
	public JSONObject addTaskLog(@PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/projects/" + projectId + "/logs] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
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
	public JSONObject getTaskLogList(@PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/logs] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
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
			
			
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
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
	public JSONObject getTaskListCount(@PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/tasks/count] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
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
	public JSONObject getTaskLogListCount(@PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/tasks/count] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
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
	public JSONObject getMemberCount(@PathVariable String projectId, @PathVariable String roleId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/role/" + roleId + "/count] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/role/" + roleId + "/count] ended.");
		return result;
	}
}
