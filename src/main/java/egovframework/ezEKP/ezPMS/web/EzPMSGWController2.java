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
import egovframework.ezEKP.ezPMS.vo.ProjectGroupMemberVO;
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
	public JSONObject getTaskList(@PathVariable long projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/task-list/" + projectId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String isMyTask = request.getParameter("isMyTask") == null ? "A" : request.getParameter("isMyTask");
			int tenantId = info.getTenantId();
			int limit = 0; 
			int startRow = 0;
			String orderWhat = request.getParameter("orderWhat");
			String orderHow = request.getParameter("orderHow");
			
			if (orderWhat == null) {
				orderWhat = "init";
			}
			
			if (request.getParameter("limit") != null) {
				limit = Integer.parseInt(request.getParameter("limit"));
			}
			
			if (request.getParameter("startRow") != null) {
				startRow = Integer.parseInt(request.getParameter("startRow"));
			}
			
			SearchVO search = new SearchVO();
			search.setTenantId(info.getTenantId());
			search.setProjectId(projectId);
			search.setStatus(request.getParameter("status"));
			
			 if (request.getParameter("groupId") != null) {
				 search.setGroupId(Long.parseLong(request.getParameter("groupId"))); 
			 } else {
				 search.setGroupId(0L);
			 }
			
			search.setMemberId(request.getParameter("headManagerName"));
			search.setIsMyTask(isMyTask);
			search.setTenantId(tenantId);
			
			//추가
			search.setTaskName(request.getParameter("searchByTaskName"));
			search.setMemberName(request.getParameter("searchByUser"));
			search.setPlanStartDate(request.getParameter("searchByStartDate"));
			search.setPlanEndDate(request.getParameter("searchByEndDate"));
			search.setUpperGroupName(request.getParameter("searchByUpperGroupName"));
			search.setOverview(request.getParameter("searchByOverview"));
			search.setProjectName(request.getParameter("searchByProjectName"));
			
			List<ProjectTaskVO> taskList = new ArrayList<ProjectTaskVO>();
			taskList = ezPMSService.getTaskList(search, userId, limit, startRow, orderWhat, orderHow);
			 
			for(int i = 0; i < taskList.size(); i++ ){
				taskList.get(i).setTaskMember(ezPMSService.getTaskMemberList(info.getTenantId(), taskList.get(i).getTaskId(), lang));
			}
			
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
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
			ProjectTaskVO taskVO = ezPMSService.getTaskDetails(Long.parseLong(taskId), info.getTenantId(), lang);
			taskVO.setTaskMember(ezPMSService.getTaskMemberList(info.getTenantId(), taskVO.getTaskId(), lang));
			
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
			int tenantId = info.getTenantId();
			
			List<Map<String, Object>> taskMemberList1 = (List<Map<String, Object>>) jsonParam.get("managerList");
			List<TaskMemberVO> taskMemberList2 = new ArrayList<TaskMemberVO>();
			
			for (int i = 0; i < taskMemberList1.size(); i++) {
				String taskMemberId = (String)taskMemberList1.get(i).get("userId");
				Float pctinput = Float.parseFloat(taskMemberList1.get(i).get("pctinput").toString());
				
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
			projectTaskVO.setTenantId(tenantId);
			projectTaskVO.setTaskId(Long.parseLong(request.getParameter("taskId")));
			projectTaskVO.setProjectId(Long.parseLong(request.getParameter("projectId")));
			projectTaskVO.setGroupId(Long.parseLong(request.getParameter("groupId")));
			projectTaskVO.setTaskName(request.getParameter("taskName"));
			projectTaskVO.setWeight(Float.parseFloat(request.getParameter("weight")));
			projectTaskVO.setOverview(request.getParameter("overview"));
			projectTaskVO.setHeadManagerId(request.getParameter("headManagerId"));
			projectTaskVO.setPlanStartDate(request.getParameter("planStartDate"));
			projectTaskVO.setPlanEndDate(request.getParameter("planEndDate"));
			projectTaskVO.setWriterId(request.getParameter("writerId"));
			projectTaskVO.setWriteDate(request.getParameter("writeDate"));
			projectTaskVO.setWriterName(request.getParameter("writerName"));
			projectTaskVO.setWriterName2(request.getParameter("writerName2"));
			projectTaskVO.setWriterDeptname(request.getParameter("writerDeptname"));
			projectTaskVO.setWriterDeptname2(request.getParameter("writerDeptname2"));
			projectTaskVO.setTaskMember(taskMemberList2);
			
			ezPMSService.updateTaskInfo(projectTaskVO);
			
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
	 * 프로젝트관리 그룹 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/groups/users/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getGroupList(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/groups/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String orderWhat = request.getParameter("orderWhat");
			String orderHow = request.getParameter("orderHow");
			int startRow = Integer.parseInt(request.getParameter("startRow") != null ? request.getParameter("startRow") : "-1" );
			int limit = Integer.parseInt(request.getParameter("limit") != null ? request.getParameter("limit") : "-1" ); 
			
			if (orderWhat == null || orderWhat.equals("")) {
				orderWhat = "init";
			}
			
			SearchVO search = new SearchVO();
			search.setTenantId(info.getTenantId());
			search.setProjectId(Long.parseLong(projectId));
			search.setUpperGroupName(request.getParameter("searchByUpperGroupName"));
			search.setMemberName(request.getParameter("searchByUser"));
			search.setPlanStartDate(request.getParameter("searchByStartDate"));
			search.setPlanEndDate(request.getParameter("searchByEndDate"));
			search.setGroupName(request.getParameter("searchByGroupName"));
			search.setOverview(request.getParameter("searchByOverview"));
			search.setProjectName(request.getParameter("searchByProjectName"));
			search.setMemberId(userId);
			
			List<ProjectGroupVO> groupList = ezPMSService.getGroupList(search, orderWhat, orderHow, startRow, limit, lang);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", groupList);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/groups/users/" + userId + "] ended.");
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
			
			Map<String, Object> project = new HashMap<String, Object>();
			project.put("planStartDate", request.getParameter("planStartDate"));
			project.put("planEndDate", request.getParameter("planEndDate"));
			project.put("overview", request.getParameter("overview"));
			project.put("headManagerId", request.getParameter("headManagerId"));
			project.put("creatorId", userId);
			project.put("creatorName", info.getUserName());
			project.put("creatorName2", info.getUserName2());
			project.put("creatorDeptname", info.getDeptName());
			project.put("creatorDeptname2", info.getDeptName2());
			project.put("createDate", request.getParameter("createDate"));
			project.put("tenantId", info.getTenantId());
			
			project.put("treeDepth", request.getParameter("treeDepth"));
			project.put("ancestorGroup", "0");
			project.put("sortOrder", 1);
			project.put("status", "W");
			project.put("upperGroupId", request.getParameter("upperGroupId"));
			
			//수정해야함.
			project.put("progress", "0");
			
			List<Map<String, Object>> projectMemberList = (List<Map<String, Object>>) jsonParam.get("managerList");
//			projectMemberList.addAll((List<Map<String, Object>>) jsonParam.get("participantList"));
//			projectMemberList.addAll((List<Map<String, Object>>) jsonParam.get("viewerList"));
			
			project.put("projectId", projectId);
			project.put("memberCount", projectMemberList.size());
			
			//그룹 생성
			project.put("groupName", request.getParameter("groupName").replaceAll("\"", "&quot;").replaceAll("\'","&#39;"));
			Long groupId = ezPMSService.addGroup(project);
			
			//프로젝트 멤버 테이블에 추가
			List<ProjectGroupMemberVO> groupMemberList = new ArrayList<ProjectGroupMemberVO>();
			HashMap<String, Object> userMap = new HashMap<String, Object>();
			HashMap<String, Object> deptUserMap = new HashMap<String, Object>();
			List<String> userIdArr = new ArrayList<String>();
			List<String> deptIdArr = new ArrayList<String>();
			userMap.put("userIdType", "user");
			userMap.put("tenantId", info.getTenantId());
			userMap.put("groupId", groupId);
			deptUserMap.put("userIdType", "dept");
			deptUserMap.put("tenantId", info.getTenantId());
			deptUserMap.put("groupId", groupId);
			for (int i = 0; i < projectMemberList.size(); i++) {
				if(projectMemberList.get(i).get("userIdType").toString().equals("user")){
					userMap.put("memberRoleId", projectMemberList.get(i).get("memberRoleId").toString());
					userIdArr.add(projectMemberList.get(i).get("userId").toString());
				}
				else{
					deptUserMap.put("memberRoleId", projectMemberList.get(i).get("memberRoleId").toString());
					deptIdArr.add(projectMemberList.get(i).get("userId").toString());
				}
			}
			userMap.put("userId", userIdArr);
			deptUserMap.put("userId", deptIdArr);
			
			List<ProjectGroupMemberVO> member = new ArrayList<ProjectGroupMemberVO>();
			//개인으로 추가된 사용자가 있는지 확인 후 추가.
			if(userIdArr.size() > 0){
				member = ezPMSService.getUserInfoForGroup(userMap);
			}
			
			//부서로 추가된 사용자가 있는지 확인 후 추가.
			if(deptIdArr.size() > 0){
				member.addAll(ezPMSService.getUserInfoForGroup(deptUserMap));
			}
			
			for(int i = 0; i < member.size(); i++){
				member.get(i).setMemberRoleId((int)(projectMemberList.get(i).get("memberRoleId")));
			}
			
//			for (int i = 0; i < projectMemberList.size(); i++) {
//				String memberId = projectMemberList.get(i).get("userId").toString();
//				int tenantId = info.getTenantId();
//				String userIdType = projectMemberList.get(i).get("userIdType").toString();
//				int memberRoleId = (int)projectMemberList.get(i).get("memberRoleId");
//				
//				ProjectMemberVO member = ezPMSService.getUserInfo(memberId, tenantId, userIdType);
//				member.setMemberRoleId(memberRoleId);
//				member.setProjectId(Long.parseLong(projectId));
//				member.setUserIdType(userIdType);
//				
//				ProjectGroupMemberVO groupMember = new ProjectGroupMemberVO();
//				groupMember.setGroupId(groupId);
//				groupMember.setTenantId(tenantId);
//				groupMember.setMemberRoleId(memberRoleId);
//				groupMember.setUserId(userId);
//				groupMember.setUserName(member.getUserName());
//				groupMember.setUserName2(member.getUserName2());
//				groupMember.setUserDeptname(member.getUserDeptname());
//				groupMember.setUserDeptname2(member.getUserDeptname2());
//				
//				
////				ezPMSService.addProjectMember(member, tenantId);
//				groupMemberList.add(groupMember);
//			}
			ezPMSService.addGroupMember(member);
			
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
			
			ProjectGroupVO groupVO = ezPMSService.getGroupDetails(Long.parseLong(groupId));
			
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
			
			ezPMSService.deleteGroup(Long.parseLong(groupId));
			
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
			String location = request.getParameter("location");
			int tenantId = info.getTenantId();
			
			List<ProjectTaskTreeVO> list = ezPMSService.getProjectTaskTree(Long.parseLong(projectId), request.getParameter("onlyGroup"), location, tenantId, userId);
			
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
	public JSONObject getProjectMemberList(@PathVariable Long projectId, @PathVariable int roleId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/roles/" + roleId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			int isGantt = 0;
			
			List<ProjectMemberVO> memberList = ezPMSService.getProjectMemberList(projectId, roleId, lang, tenantId, isGantt);
			
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
	public JSONObject getProjectDetailsforGantt(@PathVariable Long projectId, @PathVariable String userId,HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/users/" + userId + "/gantt] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			int isGantt = 0;
			
			//추후 파라미터로 받도록 수정 필요.
			ProjectInfoVO data = ezPMSService.getProjectDetails(projectId, userId, info.getTenantId(), info.getOffSet(), lang, "");
			data.setProjectMember(ezPMSService.getProjectMemberList(projectId, 4, lang, info.getTenantId(), isGantt));
			
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
		
	/**
	 * 프로젝트관리 업무 상태 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/users/{userId}/status", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateTaskStatus(@PathVariable String taskId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			ProjectTaskVO projectTaskVO = new ProjectTaskVO();
			projectTaskVO.setTenantId(tenantId);
			projectTaskVO.setTaskId(Long.parseLong(request.getParameter("taskId")));
			projectTaskVO.setProjectId(Long.parseLong(request.getParameter("projectId")));
			projectTaskVO.setPlanStartDate(request.getParameter("planStartDate"));
			projectTaskVO.setPlanEndDate(request.getParameter("planEndDate"));
			projectTaskVO.setRealStartDate(request.getParameter("realStartDate"));
			projectTaskVO.setRealEndDate(request.getParameter("realEndDate"));
			projectTaskVO.setRealProgress(Float.parseFloat(request.getParameter("realProgress")));
			projectTaskVO.setStatus(request.getParameter("status"));
			
			ezPMSService.updateTaskStatus(projectTaskVO);
			
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
}
