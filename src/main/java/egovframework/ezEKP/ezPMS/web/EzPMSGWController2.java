package egovframework.ezEKP.ezPMS.web;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
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

import egovframework.ezEKP.ezPMS.dao.EzPMSDAO;
import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.ProjectUserVO;
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
			String position = request.getParameter("position");
			String companyId = info.getCompanyId();
			int roleId = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
			
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
			taskList = ezPMSService.getTaskList(search, userId, limit, startRow, orderWhat, orderHow, position, roleId);
			 
			for(int i = 0; i < taskList.size(); i++ ){
				Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(taskList.get(i).getPlanStartDate());
				Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(taskList.get(i).getPlanEndDate());
				Date today = new Date();
				String simpToday = new SimpleDateFormat("yyyy-MM-dd").format(today);
				Date now = new SimpleDateFormat("yyyy-MM-dd").parse(simpToday); 
				
				int restDueday = ezPMSService.getWorkingDays(now, endDate, companyId, tenantId);
				taskList.get(i).setRestDueday(restDueday);
				taskList.get(i).setPlanProgress(ezPMSService.getPlanProgress(startDate, endDate, companyId, tenantId));
				taskList.get(i).setTaskMember(ezPMSService.getTaskMemberList(info.getTenantId(), taskList.get(i).getTaskId(), lang));
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", taskList);		
		} catch (Exception e) {
			e.printStackTrace();
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
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String planStartDate = request.getParameter("planStartDate");
			String planEndDate = request.getParameter("planEndDate");
			
			List<Map<String, Object>> taskMemberList1 = (List<Map<String, Object>>) jsonParam.get("managerList");
			List<TaskMemberVO> taskMemberList2 = new ArrayList<TaskMemberVO>();
			
			for (int i = 0; i < taskMemberList1.size(); i++) {
				String taskMemberId = (String)taskMemberList1.get(i).get("userId");
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
			projectTaskVO.setPlanStartDate(planStartDate);
			projectTaskVO.setPlanEndDate(planEndDate);
			projectTaskVO.setWeight(Float.parseFloat(request.getParameter("weight")));
			projectTaskVO.setOverview(request.getParameter("overview"));
			projectTaskVO.setHeadManagerId(request.getParameter("headManagerId"));
			projectTaskVO.setWriterId(request.getParameter("writerId"));
			projectTaskVO.setWriteDate(request.getParameter("writeDate"));
			projectTaskVO.setWriterName(request.getParameter("writerName"));
			projectTaskVO.setWriterName2(request.getParameter("writerName2"));
			projectTaskVO.setWriterDeptname(request.getParameter("writerDeptname"));
			projectTaskVO.setWriterDeptname2(request.getParameter("writerDeptname2"));
			projectTaskVO.setTreeDepth(Integer.parseInt(request.getParameter("treeDepth")));
			
			int taskId = ezPMSService.addTask(projectTaskVO, taskMemberList2, companyId, tenantId);
			
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			Date startDate = dateFormat.parse(planStartDate);
			Date endDate = dateFormat.parse(planEndDate);
			
			Calendar startCal = Calendar.getInstance();
			Calendar endCal = Calendar.getInstance();
			
			startCal.setTime(startDate);
			endCal.setTime(endDate);
			
			List<String> dateList = new ArrayList<String>();
			
			while (startCal.compareTo(endCal) != 1) {
				dateList.add(dateFormat.format(startCal.getTime()));
				System.out.println(dateFormat.format(startCal.getTime()));
				startCal.add(Calendar.DATE, 1);
			}
			
			for (int i = 0; i < taskMemberList2.size(); i++) {
				String memberId = taskMemberList2.get(i).getUserId();
				LOGGER.debug(memberId);
				for (int j = 0; j < dateList.size(); j++) {
					ezPMSService.addMemberSchedule(memberId, tenantId, dateList.get(j), projectId);
				}
			}
			
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
			String projectId = request.getParameter("projectId");
			
			ProjectTaskVO taskVO = ezPMSService.getTaskDetails(Long.parseLong(taskId), info.getTenantId(), lang);
			Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(taskVO.getPlanStartDate());
			Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(taskVO.getPlanEndDate());
			
			taskVO.setTaskMember(ezPMSService.getTaskMemberList(info.getTenantId(), Long.parseLong(taskId), lang));
			taskVO.setPlanProgress(ezPMSService.getPlanProgress(startDate, endDate, info.getCompanyId(), info.getTenantId()));
			
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
			String companyId = info.getCompanyId();
			
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
			
			ezPMSService.updateTaskInfo(projectTaskVO, companyId, tenantId);
			
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
			String location = "general";
			
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
			
			List<ProjectGroupVO> groupList = ezPMSService.getGroupList(search, orderWhat, orderHow, startRow, limit, lang, location);
			
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
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			
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
			project.put("ancesterGroup", "0");
			project.put("sortOrder", 1);
			project.put("status", "W");
			
			if (request.getParameter("upperGroupId") == null) {
				project.put("upperGroupId", 0);
			} else {
				project.put("upperGroupId", request.getParameter("upperGroupId"));
			}
			
			
			//수정해야함.
			project.put("progress", "0");
			
			List<Map<String, Object>> projectMemberList = (List<Map<String, Object>>) jsonParam.get("managerList");
//			projectMemberList.addAll((List<Map<String, Object>>) jsonParam.get("participantList"));
//			projectMemberList.addAll((List<Map<String, Object>>) jsonParam.get("viewerList"));
			
			project.put("projectId", projectId);
			project.put("memberCount", projectMemberList.size());
			
			//그룹 생성
			project.put("groupName", request.getParameter("groupName").replaceAll("\"", "&quot;").replaceAll("\'","&#39;"));
			Long groupId = ezPMSService.addGroup(project, "N", companyId, tenantId);
			
			//프로젝트 멤버 테이블에 추가
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
	public JSONObject getGroupDetails(@PathVariable long groupId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/groups/" + groupId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			long projectId = Long.parseLong(request.getParameter("projectId"));
			
			ProjectGroupVO groupVO = ezPMSService.getGroupDetails(groupId, tenantId, projectId);
			groupVO.setGroupMember(ezPMSService.getGroupMemberList(projectId, tenantId, groupId));
			
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
	public JSONObject updateGroup(@PathVariable long groupId, @PathVariable String userId, HttpServletRequest request, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/groups/" + groupId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			List<Map<String, Object>> managerList = (List<Map<String, Object>>) jsonParam.get("managerList");
			List<ProjectGroupMemberVO> groupManaerList = new ArrayList<ProjectGroupMemberVO>();
			
			for (int i = 0; i < managerList.size(); i++) {
				String groupMemberId = (String)managerList.get(i).get("userId");
				
				ProjectGroupMemberVO groupMember = new ProjectGroupMemberVO();
				groupMember.setTenantId(tenantId);
				groupMember.setUserId(groupMemberId);
				
				ProjectMemberVO member = ezPMSService.getUserInfo(groupMemberId, tenantId, "user");
				
				groupMember.setUserName(member.getUserName());
				groupMember.setUserName2(member.getUserName2());
				groupMember.setUserDeptname(member.getUserDeptname());
				groupMember.setUserDeptname2(member.getUserDeptname2());
				
				groupManaerList.add(groupMember);
			}
			
			ProjectGroupVO groupInfo = new ProjectGroupVO();
			groupInfo.setGroupName(request.getParameter("groupName"));
			groupInfo.setGroupId(groupId);
			groupInfo.setProjectId(Long.parseLong(request.getParameter("projectId")));
			groupInfo.setGroupMember(groupManaerList);
			groupInfo.setOverview(request.getParameter("overview"));
			groupInfo.setTenantId(info.getTenantId());
			groupInfo.setUpperGroupId(Long.parseLong(request.getParameter("upperGroupId")));
			
			//총괄담당자 불러오기
			ProjectMemberVO headManager = ezPMSService.getUserInfo(request.getParameter("headManagerId"), info.getTenantId(), "user");
			groupInfo.setHeadManagerId(request.getParameter("headManagerId"));
			groupInfo.setHeadManagerName(headManager.getUserName());
			groupInfo.setHeadManagerName2(headManager.getUserName2());
			groupInfo.setHeadManagerDeptname(headManager.getUserDeptname());
			groupInfo.setHeadManagerDeptname2(headManager.getUserDeptname2());
			
			ezPMSService.updateGroup(groupInfo);
			
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
	 * 프로젝트관리 그룹 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/groups/{groupId}", method = RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteGroup(@PathVariable long projectId, @PathVariable long groupId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/projects/" + projectId + "/groups/" + groupId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			
			//권한 체크
			String roleCheck = "";
			
			//권한 체크
			//1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
			int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
			if (userProjectRole == 1) {
				roleCheck = "permitted";
			} else if (userProjectRole == 3) {
				//프로젝트 조회자는 열람권한밖에 없음
				roleCheck = "rejected";
			} else {
				//2. group의 담당자인지 확인
				int userGroupRole = ezPMSService.getUserGroupRole(userId, tenantId, projectId, groupId);
				
				if (userGroupRole != 1) {
					roleCheck = "rejected";
				} else {
					roleCheck = "permitted";
				}
			}
			
			LOGGER.debug("DELETEGROUP ROLECHECK : " + roleCheck);
			
			if (roleCheck.equals("permitted")) {
				ezPMSService.deleteGroup(projectId, groupId, tenantId);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/projects/" + projectId + "/groups/" + groupId + "] ended.");
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
			int tenantId = Integer.parseInt(request.getParameter("tenantId"));
			
			Map<String, Object> data = ezPMSService.getRemainingWeight(projectId, tenantId);
			
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
			String companyId = info.getCompanyId();
			String deptId = info.getDeptId();
			
			//추후 파라미터로 받도록 수정 필요.
			ProjectInfoVO data = ezPMSService.getProjectDetails(projectId, userId, info.getTenantId(), info.getOffSet(), lang, deptId, companyId);
			data.setProjectMember(ezPMSService.getProjectMemberList(projectId, 4, lang, info.getTenantId(), isGantt));
			data.setWeight(ezPMSService.getProjectWeight(projectId, info.getTenantId()));
			
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
	public JSONObject updateTaskStatus(@PathVariable long taskId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String roleCheck = "";
			long projectId = Long.parseLong(request.getParameter("projectId"));
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			JSONObject data = new JSONObject();
			String companyId = info.getCompanyId();
			
			//권한 체크
			//1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
			int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
			if (userProjectRole == 1) {
				roleCheck = "permitted";
			} else if (userProjectRole == 3) {
				//프로젝트 조회자는 열람권한밖에 없음
				roleCheck = "rejected";
			} else {
				//2. task의 담당자인지 확인
				String userTaskRole = ezPMSService.getUserTaskRole(userId, tenantId, taskId);
						
				if (userTaskRole == null) {
					roleCheck = "rejected";
				} else {
					roleCheck = "permitted";
				}
			}
			
			data.put("roleCheck", roleCheck);
			
			if (roleCheck.equals("permitted")) {
				ProjectTaskVO projectTaskVO = new ProjectTaskVO();
				
				String planStartDate = request.getParameter("planStartDate");
				String planEndDate = request.getParameter("planEndDate");
				Date start = new SimpleDateFormat("yyyy-MM-dd").parse(planStartDate);
				Date end = new SimpleDateFormat("yyyy-MM-dd").parse(planEndDate);
				
				projectTaskVO.setTenantId(tenantId);
				projectTaskVO.setTaskId(taskId);
				projectTaskVO.setProjectId(projectId);
				projectTaskVO.setPlanStartDate(planStartDate);
				projectTaskVO.setPlanEndDate(planEndDate);
				projectTaskVO.setRealStartDate(request.getParameter("realStartDate"));
				projectTaskVO.setRealEndDate(request.getParameter("realEndDate"));
				projectTaskVO.setRealProgress(Float.parseFloat(request.getParameter("realProgress")));
				projectTaskVO.setStatus(request.getParameter("status"));
				projectTaskVO.setGroupId(Long.parseLong(request.getParameter("groupId")));
				
				int workingday = ezPMSService.getWorkingDays(start, end, companyId, tenantId);
				projectTaskVO.setWorkingday(workingday);
				
				ezPMSService.updateTaskStatus(projectTaskVO, companyId, tenantId);
				
				if (request.getParameter("endTime") != null) {
					long endTime = Long.parseLong(request.getParameter("endTime"));
					int rowIndex = Integer.parseInt(request.getParameter("rowIndex"));
					
					data.put("endDate", endTime);
					
					List<Long> preTaskList = ezPMSService.getPreTaskRel(rowIndex, tenantId, projectId);
					
					if (preTaskList != null && preTaskList.size() != 0) {
						Date postTaskEndTime = new Date(endTime);
						DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
						
						for (int i = 0; i < preTaskList.size(); i++) {
							ProjectTaskVO postTask = ezPMSService.getTaskDetails(preTaskList.get(i), tenantId, lang);
							Date postPlanStartDate = dateFormat.parse(postTask.getPlanStartDate());
							Date postPlanEndDate = dateFormat.parse(postTask.getPlanEndDate());
							long diff = postPlanEndDate.getTime() - postPlanStartDate.getTime();
							int diffDays = (int) diff / (24 * 60 * 60 * 1000);
							
							Calendar cal = Calendar.getInstance();
						    cal.setTime(postTaskEndTime);
						    cal.add(Calendar.DATE, 1); // 다음날 지정
						    
						    int dayNum = cal.get(Calendar.DAY_OF_WEEK);
						    
						    if (dayNum == 7) {
						    	cal.add(Calendar.DATE, 2);
						    } else if (dayNum == 1) {
						    	cal.add(Calendar.DATE, 1);
						    }
						    
						    Calendar cal2 = Calendar.getInstance();
						    cal2.setTime(cal.getTime());
						    cal2.add(Calendar.DATE, diffDays);
						    int dayNum2 = cal2.get(Calendar.DAY_OF_WEEK);
						    
						    if (dayNum2 == 7) {
						    	cal2.add(Calendar.DATE, -1);
						    } else if (dayNum2 == 1) {
						    	cal2.add(Calendar.DATE, -2);
						    }
						    
						    String calStartStr = dateFormat.format(cal.getTime());
						    String calEndStr = dateFormat.format(cal2.getTime());
						    Date calStart = new SimpleDateFormat("yyyy-MM-dd").parse(calStartStr);
							Date calEnd = new SimpleDateFormat("yyyy-MM-dd").parse(calEndStr);
						    
						    int workingdayPT = ezPMSService.getWorkingDays(calStart, calEnd, companyId, tenantId);
						    
							postTask.setPlanStartDate(calStartStr);
							postTask.setPlanEndDate(calEndStr);
							postTask.setWorkingday(workingdayPT);
							ezPMSService.updateTaskStatus(postTask, companyId, tenantId);
						}
						
					}
					
				}
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);		
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] ended.");
		return result;
	}
	
	/**
	 * 프로젝트관리 그룹 리스트(간트차트 용)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/groups/users/{userId}/gantt", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getGroupMemberList(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/groups/users/" + userId +"/gantt] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String orderWhat = request.getParameter("orderWhat");
			String orderHow = request.getParameter("orderHow");
			int startRow = Integer.parseInt(request.getParameter("startRow") != null ? request.getParameter("startRow") : "-1" );
			int limit = Integer.parseInt(request.getParameter("limit") != null ? request.getParameter("limit") : "-1" ); 
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String location = "gantt";
			
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
			
			List<ProjectGroupVO> groupList = ezPMSService.getGroupList(search, orderWhat, orderHow, startRow, limit, lang, location);
			List<ProjectGroupMemberVO> groupMemberList = ezPMSService.getGroupMemberList(Long.parseLong(projectId), info.getTenantId(), null);
			
			for(int i = 0; i < groupList.size(); i++){
				Long groupId = groupList.get(i).getGroupId();
				
				//그룹 가중치를 얻어옴.
				Float weight = ezPMSService.getGroupWeight(groupId, info.getTenantId());
				groupList.get(i).setWeight(weight);
				
				//그룹 멤버를 얻어옴.
				Iterator<ProjectGroupMemberVO> iter = groupMemberList.iterator();
				List<ProjectGroupMemberVO> groupMemberListTemp = new ArrayList<ProjectGroupMemberVO>();
				while(iter.hasNext()){
					ProjectGroupMemberVO groupMember = iter.next();
					if(groupId.equals(groupMember.getGroupId())){
						groupMemberListTemp.add(groupMember);
						iter.remove();
					}
				}
				
				Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(groupList.get(i).getPlanStartDate());
				Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(groupList.get(i).getPlanEndDate());
				Date today = new Date();
				String simpToday = new SimpleDateFormat("yyyy-MM-dd").format(today);
				Date now = new SimpleDateFormat("yyyy-MM-dd").parse(simpToday); 
				
				int restDueday = ezPMSService.getWorkingDays(now, endDate, companyId, tenantId);
				groupList.get(i).setRestDueday(restDueday);
				groupList.get(i).setPlanProgress(ezPMSService.getPlanProgress(startDate, endDate, companyId, tenantId));
				
				groupList.get(i).setGroupMember(groupMemberListTemp);
			}
			
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", groupList);		
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/groups/users/" + userId +"] ended.");
		return result;
	}
	
	/**
	 * 프로젝트관리 업무 가중치 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/weight", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateTaskWeight(@PathVariable String taskId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/weight] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ProjectTaskVO taskVO = new ProjectTaskVO();
			taskVO.setTaskId(Long.parseLong(taskId));
			taskVO.setTenantId(info.getTenantId());
			taskVO.setProjectId(Long.parseLong(request.getParameter("projectId")));
			taskVO.setWeight(Float.parseFloat(request.getParameter("weight")));
			
			String groupId = request.getParameter("groupId") != "" ? request.getParameter("groupId") : "";
			if(!groupId.equals("")){
				taskVO.setGroupId(Long.parseLong(request.getParameter("groupId")));
			}else{
				taskVO.setGroupId(0L);
			}
			
			ezPMSService.updateTaskWeight(taskVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/weight] ended.");
		return result;
	}
	
	/**
	 * 프로젝트관리 업무 진행률 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/progress", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateTaskProgress(@PathVariable String taskId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/progress] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ProjectTaskVO taskVO = new ProjectTaskVO();
			
			
			float realProgress = Float.parseFloat(request.getParameter("progress"));
			taskVO.setTaskId(Long.parseLong(taskId));
			taskVO.setProjectId(Long.parseLong(request.getParameter("projectId")));
			
			String groupId = request.getParameter("groupId") != "" ? request.getParameter("groupId") : "";
			if(!groupId.equals("")){
				taskVO.setGroupId(Long.parseLong(request.getParameter("groupId")));
			}else{
				taskVO.setGroupId(0L);
			}
			
			taskVO.setTenantId(info.getTenantId());
			taskVO.setRealProgress(realProgress);
			
			// 실제 진행률이 100 이상이면 해당 업무의 상태를 완료로 반영.
			if(realProgress >= 100){
				taskVO.setStatus("C");
				taskVO.setRealProgress(100.0F);
			}
			else{
				taskVO.setStatus(request.getParameter("status"));
			}
			
			ezPMSService.updateTaskProgress(taskVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");		
		}
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/progress] ended.");
		return result;
	}
}
