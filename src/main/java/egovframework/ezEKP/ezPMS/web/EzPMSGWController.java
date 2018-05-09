package egovframework.ezEKP.ezPMS.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.tools.ant.Project;
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
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
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
			String deptId = request.getParameter("deptId");
			
			String searchByName = "";
			if (!request.getParameter("searchByName").equals("{}")) {
				searchByName = request.getParameter("searchByName").toString();
			}
			//검색 및 환경설정 세팅
			Map<String, Object> search = new HashMap<>();
			search.put("projectSort", request.getParameter("projectSort"));
			search.put("listNumber", request.getParameter("listNumber"));
			search.put("listProjectStatus", request.getParameter("listProjectStatus"));
			search.put("listCount", request.getParameter("listCount"));
			search.put("currentPage", request.getParameter("currentPage"));
			search.put("startCount", request.getParameter("startCount"));
			search.put("viewType", request.getParameter("viewType"));
			//정렬
			search.put("orderWhat", request.getParameter("orderWhat"));
			search.put("orderHow", request.getParameter("orderHow"));
			//검색
			search.put("searchByName", searchByName);
			search.put("searchByUser", request.getParameter("searchByUser"));
			search.put("searchByStartDate", request.getParameter("searchByStartDate"));
			search.put("searchByEndDate", request.getParameter("searchByEndDate"));
			search.put("searchByOverview", request.getParameter("searchByOverview"));
			
			//프로젝트 리스트 가져오기
			List<ProjectInfoVO> projectList = ezPMSService.getProjectList(info.getTenantId(), userId, deptId, status, search, info.getOffSet(), lang);
			
			LOGGER.debug("projectList Count : " + projectList.size());
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", projectList);
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
			
			Map<String, Object> project = new HashMap<String, Object>();
			project.put("projectName", request.getParameter("projectName"));
			project.put("weightInput", request.getParameter("weightInput"));
			project.put("planStartDate", request.getParameter("planStartDate"));
			project.put("planEndDate", request.getParameter("planEndDate"));
			project.put("overview", request.getParameter("overview"));
			project.put("endAlamStatus", request.getParameter("endAlamStatus"));
			project.put("headManagerId", request.getParameter("headManagerId"));
			project.put("writerName", request.getParameter("writerName"));
			project.put("creatorId", request.getParameter("userId"));
			project.put("creatorName", request.getParameter("creatorName"));
			project.put("creatorName2", request.getParameter("creatorName2"));
			project.put("creatorDeptname", request.getParameter("creatorDeptname"));
			project.put("creatorDeptname2", request.getParameter("creatorDeptname2"));
			project.put("createDate", request.getParameter("createDate"));
			project.put("tenantId", info.getTenantId());
			project.put("treeDepth", 0);
			project.put("ancestorGroup", "0");
			project.put("sortOrder", 1);
			project.put("status", "W");
			project.put("upperGroupId", 0);
			
			Long projectId = ezPMSService.addNewProject(project);
			
			LOGGER.debug("addNewProject projectId : " + projectId);
			
			List<Map<String, Object>> projectMemberList = (List<Map<String, Object>>) json.get("managerList");
			projectMemberList.addAll((List<Map<String, Object>>) json.get("participantList"));
			projectMemberList.addAll((List<Map<String, Object>>) json.get("viewerList"));
			
			project.put("projectId", projectId);
			project.put("groupName", request.getParameter("projectName"));
			project.put("memberCount", projectMemberList.size());
			ezPMSService.addGroup(project);
			
			for (int i = 0; i < projectMemberList.size(); i++) {
				String userId = projectMemberList.get(i).get("userId").toString();
				int tenantId = Integer.parseInt(request.getParameter("tenantId"));
				String userIdType = projectMemberList.get(i).get("userIdType").toString();
				
				ProjectMemberVO member = ezPMSService.getUserInfo(userId, tenantId, userIdType);
				member.setMemberRoleId((int)projectMemberList.get(i).get("memberRoleId"));
				member.setProjectId(projectId);
				member.setUserIdType(userIdType);
				
				ezPMSService.addProjectMember(member, Integer.parseInt(request.getParameter("tenantId")));
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", projectId);
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
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/projects/" + projectId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String status = request.getParameter("status");
			String userId = request.getParameter("userId");
			int tenantId = Integer.parseInt(request.getParameter("tenantId"));
			String deptId = request.getParameter("deptId");
			
			LOGGER.debug("status : " + status + ", " + "userId : " + ", tenantId : " + tenantId + ", deptId : " + deptId);
			
			String[] projectIdList = projectId.split("_");
			String roleCheck = "";
			
			for (int i = 0; i < projectIdList.length; i++) {
				int userRole = ezPMSService.getUserProjectRole(userId, tenantId, Long.parseLong(projectIdList[i]), deptId);
				LOGGER.debug("projectId : " + projectIdList[i] + ", role : " + userRole);
				
				if (userRole != 1) {
					roleCheck = "reject";
				}
			}
			
			if (roleCheck.equals("")) {
				for (int i = 0; i < projectIdList.length; i++) {
					ezPMSService.deleteProject(info.getTenantId(),Long.parseLong(projectIdList[i]));	
				}
				roleCheck = "permitted";
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", roleCheck);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/projects/" + projectId + "] ended.");
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
			
			String userIdType = request.getParameter("userIdType");
			int tenantId = Integer.parseInt(request.getParameter("tenantId"));
			
			ProjectMainSettingVO projectSetting = ezPMSService.getProjectMainSetting(userId, tenantId, userIdType);
			
			LOGGER.debug("projectSetting : " + projectSetting.getViewType());
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
			
			int tenantId = Integer.parseInt(request.getParameter("tenantId"));
			
			ProjectMainSettingVO project = new ProjectMainSettingVO();
			project.setViewType(Integer.parseInt(request.getParameter("viewType")));
			project.setProgressColor(request.getParameter("progressColor"));
			project.setCompleteColor(request.getParameter("completeColor"));
			project.setOverdueColor(request.getParameter("overdueColor"));
			project.setHoldColor(request.getParameter("holdColor"));
			project.setProjectSort(Integer.parseInt(request.getParameter("projectSort")));
			project.setListNumber(Integer.parseInt(request.getParameter("listNumber")));
			project.setListProjectStatus(request.getParameter("listProjectStatus"));
			project.setUserId(userId);
			
			LOGGER.debug("[parameter] viewType : " + project.getViewType() + ", progressColor : " + project.getProgressColor() + ", completeColor : " + project.getCompleteColor() + 
					", overdueColor : " + project.getOverdueColor() + ", holdColor : " + project.getHoldColor() + ", projectSort : " + project.getProjectSort() + ", listNumber : " + project.getListNumber() + ", listProjectStatus : " + project.getListProjectStatus());
			
			
			ezPMSService.updateMainSetting(project, tenantId);
			
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
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String status = request.getParameter("status");
			String userId = request.getParameter("userId");
			int tenantId = Integer.parseInt(request.getParameter("tenantId"));
			String deptId = info.getDeptId();
			String nowStatus = request.getParameter("nowStatus");
			String changeDate = request.getParameter("changeDate");
			
			LOGGER.debug("nowStatus" + nowStatus + ", status : " + status + ", " + "userId : " + ", tenantId : " + tenantId + ", deptId : " + deptId);
			
			String[] projectIdList = projectId.split("_");
			String roleCheck = "";
			
			for (int i = 0; i < projectIdList.length; i++) {
				int userRole = ezPMSService.getUserProjectRole(userId, tenantId, Long.parseLong(projectIdList[i]), deptId);
				
				LOGGER.debug("projectId : " + projectIdList[i] + ", role : " + userRole);
				if (userRole != 1) {
					roleCheck = "reject";
				}
			}
			
			if (roleCheck.equals("")) {
				roleCheck = "permitted";
				
				for (int i = 0; i < projectIdList.length; i++) {
					ProjectInfoVO project = ezPMSService.getProjectDetails(Long.parseLong(projectIdList[i]), userId, info.getTenantId(), "new", info.getLang(), deptId);
					String planEndDate = project.getPlanEndDate();
					
					ezPMSService.updateProjectStatus(Long.parseLong(projectIdList[i]), status, info.getTenantId(), changeDate, planEndDate);	
					System.out.println(status);
					System.out.println(nowStatus);
					if (nowStatus.equals("W") && status.equals("P")) {
						System.out.println(status);
						ezPMSService.updateProjectRealDate(Long.parseLong(projectIdList[i]), info.getTenantId(), changeDate, status);
					}
					
					if (status.equals("C")) {
						ezPMSService.updateProjectRealDate(Long.parseLong(projectIdList[i]), info.getTenantId(), changeDate, status);
						ezPMSService.completeAllTasks(Long.parseLong(projectIdList[i]), info.getTenantId(), changeDate);
					}
				}
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", roleCheck);
		} catch (Exception e) {
			LOGGER.debug("ERROR : " + e.getMessage());
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", e.getMessage());
		}
		
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/"+ projectId + "/status] ended.");
		return result;
	}
	
	//프로젝트 개요 정보 호출
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/userId/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getProjectOverview(@PathVariable Long projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String mode = request.getParameter("mode");
			int tenantId = info.getTenantId();
			String deptId = info.getDeptId();
			
			ProjectInfoVO project = ezPMSService.getProjectDetails(projectId, userId, tenantId, mode, lang, deptId);
			String kanbanOrder = ezPMSService.getKanbanOrder(projectId, userId, tenantId);
			int userRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, deptId);
			ProjectMainSettingVO mainSetting = ezPMSService.getProjectMainSetting(userId, tenantId, "user");
			
			if (kanbanOrder == null || kanbanOrder.equals("")) {
				//default : 나의 전체업무, 전체 진행중인업무, 전체 완료된업무, 게시판
				kanbanOrder = "MA,P,C,B";
			}
			
			JSONObject data = new JSONObject();
			data.put("project", project);
			data.put("kanbanOrder", kanbanOrder);
			data.put("userRole", userRole);
			data.put("mainSetting", mainSetting);
			
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
	public JSONObject updateProject(@RequestBody JSONObject json, @PathVariable Long projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			
			ProjectInfoVO project = new ProjectInfoVO();
			project.setProjectId(Long.parseLong(request.getParameter("projectId")));
			project.setProjectName(request.getParameter("projectName"));
			project.setWeightInput(Integer.parseInt(request.getParameter("weightInput")));
			project.setPlanEndDate(request.getParameter("planEndDate"));
			project.setPlanStartDate(request.getParameter("planStartDate"));
			project.setOverview(request.getParameter("overview"));
			project.setAlamMailStatus(Integer.parseInt(request.getParameter("endAlamStatus")));
			project.setHeadManagerId(request.getParameter("headManagerId"));			
			project.setCreateDate(request.getParameter("createDate"));
			
			ezPMSService.updateProject(project, tenantId);
			
			//멤버 삭제 후 다시 넣기
			ezPMSService.deleteProjectMember(projectId, tenantId);
			
			List<Map<String, Object>> projectMemberList = (List<Map<String, Object>>) json.get("managerList");
			projectMemberList.addAll((List<Map<String, Object>>) json.get("participantList"));
			projectMemberList.addAll((List<Map<String, Object>>) json.get("viewerList"));
			System.out.println(projectMemberList.size());
			for (int i = 0; i < projectMemberList.size(); i++) {
				String userId = (String)projectMemberList.get(i).get("userId");
				String userIdType = (String)projectMemberList.get(i).get("userIdType");
				
				ProjectMemberVO member = ezPMSService.getUserInfo(userId, tenantId, userIdType);
				member.setMemberRoleId((int)projectMemberList.get(i).get("memberRoleId"));
				member.setProjectId(projectId);
				member.setUserIdType(userIdType);
				
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
		
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "] ended.");
		return result;
	}
	
	//프로젝트 역할별 멤버 보기
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/roles/{roleId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getProjectMember(@PathVariable Long projectId, @PathVariable int roleId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/roles/" + roleId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			int tenantId = info.getTenantId();
			
			List<ProjectMemberVO> memberList = ezPMSService.getProjectMemberList(projectId, roleId, lang, tenantId);
			
			JSONObject data = new JSONObject();
			data.put("memberList", memberList);
			
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
	public JSONObject changeKanbanOrder(@PathVariable Long projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "/order] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String orderStatus = request.getParameter("orderStatus");
			
			String kanbanOrder = ezPMSService.getKanbanOrder(projectId, userId, info.getTenantId());
			
			if (kanbanOrder == null || kanbanOrder.equals("")) {
				ezPMSService.addKanbanOrder(projectId, userId, orderStatus, info.getTenantId());
			} else if (!kanbanOrder.equals(orderStatus)) {
				ezPMSService.changeKanbanOrder(projectId, userId, orderStatus, info.getTenantId());
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "/order] ended.");
		return result;
	}
	
	//프로젝트 즐겨찾기 추가
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/userId/{userId}/favorites/{projectId}", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addFavoriteProject(@PathVariable String userId, @PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/userId/" + userId + "/favorites/"+ projectId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String[] projectIdList = projectId.split("_");
			
			int addResult = 0;
			
			if (projectIdList.length == 1) {
				addResult = ezPMSService.addFavoriteProject(Long.parseLong(projectIdList[0]), userId, info.getTenantId());
			} else {
				for (int i = 0; i < projectIdList.length; i++) {
					ezPMSService.addFavoriteProject(Long.parseLong(projectIdList[i]), userId, info.getTenantId());
				}
				addResult = 0;
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", addResult);
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
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String[] projectIdList = projectId.split("_");
			
			for (int i = 0; i < projectIdList.length; i++) {
				ezPMSService.deleteFavoriteProject(Long.parseLong(projectIdList[i]), userId, info.getTenantId());
			}
			
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
	public JSONObject getTaskLogList(@PathVariable Long projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/logs] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
			Long taskId = Long.parseLong(request.getParameter("taskId"));
			Long groupId = Long.parseLong(request.getParameter("groupId"));
			
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
			String lang = info.getLang();
			String searchByName = "";
			
			if (lang.equals("1")) {
				lang = "";
			}
			
			if (!request.getParameter("searchByName").equals("{}")) {
				searchByName = request.getParameter("searchByName").toString();
			}
			
			ProjectInfoVO project = new ProjectInfoVO();
			project.setStatus(request.getParameter("listProjectStatus"));
			project.setProjectName(searchByName);
			project.setPlanStartDate(request.getParameter("searchByStartDate"));
			project.setPlanEndDate(request.getParameter("searchByEndDate"));
			project.setOverview(request.getParameter("searchByOverview"));
			project.setHeadManagerName(request.getParameter("searchByUser"));
			
			String deptId = request.getParameter("deptId");
			
			LOGGER.debug("status : " + project.getStatus() + ", deptId : " + deptId);
			int projectListCount = ezPMSService.getProjectListCount(project, info.getTenantId(), userId, deptId, lang);
			
			LOGGER.debug("projectListCount : " + projectListCount);
			
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
	public JSONObject getTaskListCount(@PathVariable Long projectId, HttpServletRequest request) throws Exception {
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
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/roles/{roleId}/count", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getMemberCount(@PathVariable Long projectId, @PathVariable int roleId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/roles/" + roleId + "/count] started.");
		
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
		
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/roles/" + roleId + "/count] ended.");
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
