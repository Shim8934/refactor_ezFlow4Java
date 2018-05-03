package egovframework.ezEKP.ezPMS.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskTreeVO;
import egovframework.ezEKP.ezPMS.vo.SearchVO;
import egovframework.ezEKP.ezPMS.vo.TaskMemberVO;
import egovframework.ezMobile.ezCommon.web.MCommonGWController;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzPMSGWController2 {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSGWController2.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzPMSService")
	private EzPMSService ezPMSService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	
	/**
	 * 프로젝트관리 업무 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/task-list/{projectId}/users/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getTaskList(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/task-list/" + projectId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			SearchVO search = new SearchVO();
			search.setTenantId(info.getTenantId());
			search.setProjectId(Integer.parseInt(projectId));
			search.setMemberId(request.getParameter("headManagerName"));
			
			
			List<ProjectTaskVO> taskList = ezPMSService.getTaskList(search);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", taskList);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/task-list/" + projectId + "/users/" + userId + "] ended.");
		return result;
	}
	
	/**
	 * 프로젝트관리 업무 등록
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{projectId}/users/{userId}", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addTask(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/tasks/" + projectId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			List<Map<String, Object>> taskMemberList1 = (List<Map<String, Object>>) jsonParam.get("managerList");
			List<TaskMemberVO> taskMemberList2 = new ArrayList<TaskMemberVO>();
			
			for (int i = 0; i < taskMemberList1.size(); i++) {
				String taskMemberId = (String)taskMemberList1.get(i).get("userId");
				int tenantId = Integer.parseInt(request.getParameter("tenantId"));
				Float pctinput = Float.parseFloat((String) taskMemberList1.get(i).get("pctinput"));
				
				TaskMemberVO taskMemberVO = new TaskMemberVO();
				taskMemberVO.setTenantId(tenantId);
				taskMemberVO.setUserId(taskMemberId);
				taskMemberVO.setPctinput(pctinput);
				
				ProjectMemberVO member = ezPMSService.getUserInfo(taskMemberId, tenantId, "user");
				
				taskMemberVO.setUserName(member.getUserName());
				taskMemberVO.setUserName2(member.getUserName2());
				taskMemberVO.setUserDeptname(member.getUserDeptname());
				taskMemberVO.setUserDeptname2(member.getUserDeptname2());
				
				taskMemberList2.add(taskMemberVO);
			}
			
			
			ProjectTaskVO projectTaskVO = new ProjectTaskVO();
			projectTaskVO.setTenantId(Integer.parseInt(request.getParameter("tenantId")));
			projectTaskVO.setProjectId(Long.parseLong(projectId));
			projectTaskVO.setGroupId(Long.parseLong(request.getParameter("groupId")));
			projectTaskVO.setTaskName(request.getParameter("taskName"));
			projectTaskVO.setPlanStartDate(request.getParameter("planStartDate"));
			projectTaskVO.setPlanEndDate(request.getParameter("planEndDate"));
			projectTaskVO.setWeight(Float.parseFloat(request.getParameter("weight")));
			projectTaskVO.setOverview(request.getParameter("overview"));
			projectTaskVO.setHeadManagerId(request.getParameter("headManagerId"));
			projectTaskVO.setWriterId(request.getParameter("writerId"));
			projectTaskVO.setWriteDate(request.getParameter("writeDate"));
			projectTaskVO.setWriterName(request.getParameter("writerName"));
			projectTaskVO.setWriterName2(request.getParameter("writerName2"));
			projectTaskVO.setWriterDeptname(request.getParameter("writerDeptname"));
			projectTaskVO.setWriterDeptname2(request.getParameter("writerDeptname2"));
			
			int taskId = ezPMSService.addTask(projectTaskVO, taskMemberList2);
			
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", taskId+"");		
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "fail");		
		}
		
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/tasks/" + projectId + "/users/" + userId + "] ended.");
		return result;
	}
	
	
	/**
	 * 프로젝트관리 업무 상세보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/users/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getTaskDetail(@PathVariable String taskId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ProjectTaskVO taskVO = ezPMSService.getTaskDetails(Integer.parseInt(taskId));
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", taskVO);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] ended.");
		return result;
	}
	
	/**
	 * 프로젝트관리 업무 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/users/{userId}", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateTask(@PathVariable String taskId, @PathVariable String userId, HttpServletRequest request, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			Gson gson = new Gson();
			ProjectTaskVO vo = new ProjectTaskVO();
			vo = gson.fromJson(jsonParam.toJSONString(), ProjectTaskVO.class);
			vo.setTenantId(info.getTenantId());
			
			ezPMSService.updateTask(vo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] ended.");
		return result;
	}
	
	/**
	 * 프로젝트관리 업무 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/users/{userId}", method = RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteTask(@PathVariable String taskId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ezPMSService.deleteTask(Integer.parseInt(taskId));
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] ended.");
		return result;
	}
	
	
	/**
	 * 프로젝트관리 그룹 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/group-list/{projectId}/users/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getGroupList(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/group-list/" + projectId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			SearchVO search = new SearchVO();
			search.setTenantId(info.getTenantId());
			search.setProjectId(Integer.parseInt(projectId));
			
			List<ProjectGroupVO> taskList = ezPMSService.getGroupList(search);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", taskList);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/group-list/" + projectId + "/users/" + userId + "] ended.");
		return result;
	}
	
	
	/**
	 * 프로젝트관리 그룹 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/groups/{projectId}/users/{userId}", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addGroup(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/groups/" + projectId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			Gson gson = new Gson();
			ProjectGroupVO vo = new ProjectGroupVO();
			vo = gson.fromJson(jsonParam.toJSONString(), ProjectGroupVO.class);
			vo.setTenantId(info.getTenantId());
			
			ezPMSService.addGroup(vo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "success");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "fail");		
		}
		
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/groups/" + projectId + "/users/" + userId + "] ended.");
		return result;
	}
	
	/**
	 * 프로젝트관리 그룹 상세보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/groups/{groupId}/users/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getGroupDetail(@PathVariable String groupId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/groups/" + groupId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ProjectGroupVO groupVO = ezPMSService.getGroupDetails(Integer.parseInt(groupId));
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", groupVO);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/groups/" + groupId + "/users/" + userId + "] ended.");
		return result;
	}
	
	
	/**
	 * 프로젝트관리 그룹 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/groups/{groupId}/users/{userId}", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateGroup(@PathVariable String groupId, @PathVariable String userId, HttpServletRequest request, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/groups/" + groupId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			Gson gson = new Gson();
			ProjectGroupVO vo = new ProjectGroupVO();
			vo = gson.fromJson(jsonParam.toJSONString(), ProjectGroupVO.class);
			vo.setTenantId(info.getTenantId());
			
			ezPMSService.updateGroup(vo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/groups/" + groupId + "/users/" + userId + "] ended.");
		return result;
	}
	
	
	/**
	 * 프로젝트관리 그룹 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/groups/{groupId}/users/{userId}", method = RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteGroup(@PathVariable String groupId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/groups/" + groupId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ezPMSService.deleteGroup(Integer.parseInt(groupId));
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/groups/" + groupId + "/users/" + userId + "] ended.");
		return result;
	}
	
	
	/**
	 * 프로젝트관리 업무/그룹 트리
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tree/{projectId}/users/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getProjectTaskTree(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tree/" + projectId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<ProjectTaskTreeVO> list = ezPMSService.getProjectTaskTree(Integer.parseInt(projectId), request.getParameter("onlyGroup"));
			
			LOGGER.debug(list.get(0).getText());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", list);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tree/" + projectId + "/users/" + userId + "] ended.");
		return result;
	}
	
	
	//프로젝트 역할별 멤버 보기
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/member-list/{projectId}/roles/{roleId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getProjectMemberList(@PathVariable int projectId, @PathVariable int roleId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/roles/" + roleId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			
			List<ProjectMemberVO> memberList = ezPMSService.getProjectMemberList(projectId, roleId, lang, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", memberList);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/roles/" + roleId + "] ended.");
		return result;
	}
	
	
	/**
	 * 프로젝트관리 잔여 가중치 및 시작일/종료일 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/weight/{projectId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getRemainingWeight(@PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/weight/" + projectId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			
			Map<String, Object> data = ezPMSService.getRemainingWeight(projectId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/weight/" + projectId + "] ended.");
		return result;
	}
	
	/**
	 * 프로젝트관리 프로젝트 세부 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/users/{userId}/gantt", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getProjectDetailsforGantt(@PathVariable int projectId, @PathVariable String userId,HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/users/" + userId + "/gantt] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
			ProjectInfoVO data = ezPMSService.getProjectDetails(projectId, "juhongsun", info.getTenantId(), info.getOffSet(), lang);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/users/" + userId + "/gantt] ended.");
		return result;
	}
		
	
}
