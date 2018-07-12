package egovframework.ezEKP.ezPMS.web;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.annotations.Param;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
import egovframework.ezEKP.ezPMS.vo.ProjectCompanyVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMainSettingVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberScheduleVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.ProjectUserVO;
import egovframework.ezEKP.ezPMS.vo.SearchVO;
import egovframework.ezEKP.ezPMS.vo.TaskLogListVO;
import egovframework.ezMobile.ezCommon.web.MCommonGWController;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzPMSGWController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="EzPMSService")
	private EzPMSService ezPMSService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
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
			String deptId = info.getDeptId();		
			String searchByName = request.getParameter("searchByProjectName");
			String searchByUser = request.getParameter("searchByUser");
			String searchByOverview = request.getParameter("searchByOverview");
			String companyId = info.getCompanyId();
			
			if (searchByName != null  && !searchByName.equals("")) {
				searchByName = searchByName.replace("\\","\\\\");
				searchByName = searchByName.replace("%", "\\%");
				searchByName = searchByName.replace("_", "\\_");
			}
			
			if (searchByUser != null && !searchByUser.equals("")) {
				searchByUser = searchByUser.replace("\\","\\\\");
				searchByUser = searchByUser.replace("%", "\\%");
				searchByUser = searchByUser.replace("_", "\\_");
			}
			
			if (searchByOverview != null && !searchByOverview.equals("")) {
				searchByOverview = searchByOverview.replace("\\","\\\\");
				searchByOverview = searchByOverview.replace("%", "\\%");
				searchByOverview = searchByOverview.replace("_", "\\_");
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
			
			List<ProjectInfoVO> projectList;
			
			//프로젝트 리스트 가져오기
			// admin 파라미터는 관리자모드에서만 넘어온다. 이 때 userId를 ""로 넘겨서 모든 프로젝트 검색이 가능하도록 한다.
			if(request.getParameter("admin") != null && request.getParameter("admin").equals("true")) {
				projectList = ezPMSService.getProjectList(info.getTenantId(), "", deptId, status, search, lang, request.getParameter("position"), companyId);
			} else {
				projectList = ezPMSService.getProjectList(info.getTenantId(), userId, deptId, status, search, lang, request.getParameter("position"), companyId);
			}
			
			LOGGER.debug("projectList Count : " + projectList.size());
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", projectList);
		} catch (Exception e) {
			e.printStackTrace();

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
		JSONObject data = new JSONObject();
		
		try{
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			
			Map<String, Object> project = new HashMap<String, Object>();
			project.put("projectName", request.getParameter("projectName").replaceAll("\"", "&quot;").replaceAll("\'","&#39;"));
			project.put("weightInput", request.getParameter("weightInput"));
			project.put("planStartDate", request.getParameter("planStartDate"));
			project.put("planEndDate", request.getParameter("planEndDate"));
			project.put("overview", request.getParameter("overview"));
			project.put("endAlamStatus", request.getParameter("endAlamStatus"));
			project.put("headManagerId", request.getParameter("headManagerId"));
			project.put("writerName", info.getUserName());
			project.put("creatorId", userId);
			project.put("creatorName", info.getUserName());
			project.put("creatorName2", info.getUserName2());
			project.put("creatorDeptname", info.getDeptName());
			project.put("creatorDeptname2", info.getDeptName2());
			project.put("createDate", request.getParameter("createDate"));
			project.put("tenantId", info.getTenantId());
			//최상위 그룹 생성을 위한 파라미터
			project.put("treeDepth", 0);
			project.put("ancestorGroup", "0");
			project.put("sortOrder", -1);
			project.put("status", "W");
			project.put("upperGroupId", 0);
			project.put("companyId", companyId);
			
			Long projectId = ezPMSService.addNewProject(project);
			
			LOGGER.debug("addNewProject projectId : " + projectId);
			
			List<Map<String, Object>> projectMemberList = (List<Map<String, Object>>) json.get("managerList");
			projectMemberList.addAll((List<Map<String, Object>>) json.get("participantList"));
			projectMemberList.addAll((List<Map<String, Object>>) json.get("viewerList"));
			
			project.put("projectId", projectId);
			project.put("memberCount", projectMemberList.size());
			
			// 이슈리스트 그룹 생성
			project.put("groupName", "이슈 리스트");
			ezPMSService.addGroup(project, "Y", companyId, tenantId);
			
			//그룹 생성
			project.put("sortOrder", 0);
			project.put("groupName", request.getParameter("projectName").replaceAll("\"", "&quot;").replaceAll("\'","&#39;"));
			long groupId = ezPMSService.addGroup(project, "N", companyId, tenantId);
			
			data.put("projectId", projectId);
			data.put("groupId", groupId);
			
			//프로젝트 멤버 테이블에 추가
			for (int i = 0; i < projectMemberList.size(); i++) {
				String memberId = projectMemberList.get(i).get("userId").toString();
				String userIdType = projectMemberList.get(i).get("userIdType").toString();
				
				ProjectMemberVO member = ezPMSService.getUserInfo(memberId, tenantId, userIdType);
				member.setMemberRoleId((int)projectMemberList.get(i).get("memberRoleId"));
				member.setProjectId(projectId);
				member.setUserIdType(userIdType);
				
				ezPMSService.addProjectMember(member, tenantId);
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
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String status = request.getParameter("status");
			int tenantId = info.getTenantId();
			String deptId = info.getDeptId();
			
			LOGGER.debug("status : " + status + ", " + "userId : " + userId + ", tenantId : " + tenantId + ", deptId : " + deptId);
			
			String[] projectIdList = projectId.split("_");
			String roleCheck = "";
			
			// admin 파라미터는 관리자모드에서만 넘어온다. 값이 넘어오지 않을 때만 roleCheck를 시행한다.
			if(request.getParameter("admin") == null || !request.getParameter("admin").equals("true")) {
				for (int i = 0; i < projectIdList.length; i++) {
					int userRole = ezPMSService.getUserProjectRole(userId, tenantId, Long.parseLong(projectIdList[i]), deptId);
					LOGGER.debug("projectId : " + projectIdList[i] + ", role : " + userRole);
					
					if (userRole != 1) {
						roleCheck = "reject";
					}
				}
			}
			
			if (roleCheck.equals("")) {
				for (int i = 0; i < projectIdList.length; i++) {
					ezPMSService.deleteProject(tenantId, Long.parseLong(projectIdList[i]));	
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
			int tenantId = info.getTenantId();
			
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
			int tenantId = info.getTenantId();
			
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
			e.printStackTrace();
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
	public JSONObject updateProjectStatus(@PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "/status] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String deptId = info.getDeptId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			String status = request.getParameter("status");
			String nowStatus = request.getParameter("nowStatus");
			String changeDate = request.getParameter("changeDate");
			String companyId = info.getCompanyId();
			
			LOGGER.debug("nowStatus : " + nowStatus + ", status : " + status + ", " + "userId : " + userId + ", tenantId : " + tenantId + ", deptId : " + deptId);
			
			String[] projectIdList = projectId.split("_");
			String roleCheck = "";
			
			// admin 파라미터는 관리자모드에서만 넘어온다. 값이 넘어오지 않을 때만 roleCheck를 시행한다.
			if(request.getParameter("admin") == null || !request.getParameter("admin").equals("true")) {
				
				for (int i = 0; i < projectIdList.length; i++) {
					int userRole = ezPMSService.getUserProjectRole(userId, tenantId, Long.parseLong(projectIdList[i]), deptId);
					
					LOGGER.debug("projectId : " + projectIdList[i] + ", role : " + userRole);
					if (userRole != 1) {
						roleCheck = "reject";
					}
				}
			} else {
				userId = ""; // 관리자 모드에서는 userId를 ""으로 넘겨야 ezPMSService.getProjectDetails()에서 값을 불러올 수 있음
			}
			
			if (roleCheck.equals("")) {
				roleCheck = "permitted";
				
				for (int i = 0; i < projectIdList.length; i++) {
					ProjectInfoVO project = ezPMSService.getProjectDetails(Long.parseLong(projectIdList[i]), userId, info.getTenantId(), "new", lang, deptId, companyId);
					String planEndDate = project.getPlanEndDate();
					
					ezPMSService.updateProjectStatus(Long.parseLong(projectIdList[i]), status, info.getTenantId(), changeDate, planEndDate);	
					
					if (nowStatus.equals("W") && status.equals("P")) {
						ezPMSService.updateProjectRealDate(Long.parseLong(projectIdList[i]), info.getTenantId(), changeDate, status, planEndDate, companyId);
					}
					
					if (status.equals("C")) {
						ezPMSService.updateProjectRealDate(Long.parseLong(projectIdList[i]), info.getTenantId(), changeDate, status, planEndDate, companyId);
						ezPMSService.completeAllTasks(Long.parseLong(projectIdList[i]), info.getTenantId(), changeDate, planEndDate, companyId);
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
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			String deptId = info.getDeptId();
			String mode = request.getParameter("mode");
			String companyId = info.getCompanyId();
			
			JSONObject data = new JSONObject();
			
			// admin 파라미터는 관리자모드에서만 넘어온다. 이 때 userId를 ""로 넘겨서 모든 프로젝트 검색이 가능하도록 한다.
			if(request.getParameter("admin") != null && request.getParameter("admin").equals("true")) {
				ProjectInfoVO project = ezPMSService.getProjectDetails(projectId, "", tenantId, mode, lang, deptId, companyId);
				data.put("project", project);
			} else {
				ProjectInfoVO project = ezPMSService.getProjectDetails(projectId, userId, tenantId, mode, lang, deptId, companyId);
				String kanbanOrder = ezPMSService.getKanbanOrder(projectId, userId, tenantId);
				int userRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, deptId);
				ProjectMainSettingVO mainSetting = ezPMSService.getProjectMainSetting(userId, tenantId, "user");
				
				if (kanbanOrder == null || kanbanOrder.equals("")) {
					if (userRole == 3) {
						//조회자 default : 나의 전체업무, 전체 진행중인업무, 전체 완료된업무, 게시판
						kanbanOrder = "A,P,C,B";
					} else {
						//default : 나의 전체업무, 전체 진행중인업무, 전체 완료된업무, 게시판
						kanbanOrder = "MA,P,C,B";
					}
				}
				
				data.put("project", project);
				data.put("kanbanOrder", kanbanOrder);
				data.put("userRole", userRole);
				data.put("mainSetting", mainSetting);
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
			String companyId = info.getCompanyId();
			
			ProjectInfoVO project = new ProjectInfoVO();
			project.setProjectId(projectId);
			project.setProjectName(request.getParameter("projectName"));
			project.setWeightInput(Integer.parseInt(request.getParameter("weightInput")));
			project.setPlanEndDate(request.getParameter("planEndDate"));
			project.setPlanStartDate(request.getParameter("planStartDate"));
			project.setOverview(request.getParameter("overview"));
			project.setAlamMailStatus(Integer.parseInt(request.getParameter("endAlamStatus")));
			project.setHeadManagerId(request.getParameter("headManagerId"));			
			project.setCreateDate(request.getParameter("createDate"));
			
			ezPMSService.updateProject(project, tenantId, companyId);
			
			//멤버 삭제 후 다시 넣기
			ezPMSService.deleteProjectMember(projectId, tenantId);
			
			List<Map<String, Object>> projectMemberList = (List<Map<String, Object>>) json.get("managerList");
			projectMemberList.addAll((List<Map<String, Object>>) json.get("participantList"));
			projectMemberList.addAll((List<Map<String, Object>>) json.get("viewerList"));
			
			for (int i = 0; i < projectMemberList.size(); i++) {
				String userId = (String)projectMemberList.get(i).get("userId");
				String userIdType = (String)projectMemberList.get(i).get("userIdType");
				
				ProjectMemberVO member = ezPMSService.getUserInfo(userId, tenantId, userIdType);
				member.setMemberRoleId((int)projectMemberList.get(i).get("memberRoleId"));
				member.setProjectId(projectId);
				member.setUserIdType(userIdType);
				
				ezPMSService.addProjectMember(member, tenantId);
			}
			
			long groupId = Long.parseLong(request.getParameter("groupId"));
			//프로젝트 정보를 프로젝트와 같은 이름의 최상위 그룹 정보도 바꿈
			ProjectGroupVO groupInfo = new ProjectGroupVO();
			groupInfo.setGroupName(request.getParameter("projectName"));
			groupInfo.setGroupId(groupId);
			groupInfo.setProjectId(Long.parseLong(request.getParameter("projectId")));
			groupInfo.setOverview(request.getParameter("overview"));
			groupInfo.setTenantId(info.getTenantId());
			groupInfo.setUpperGroupId(0L);
			groupInfo.setHeadManagerId(request.getParameter("headManagerId"));
			groupInfo.setPlanStartDate(request.getParameter("planStartDate"));
			groupInfo.setPlanEndDate(request.getParameter("planEndDate"));
			
			ezPMSService.updateGroup(groupInfo);
			
			JSONObject data = new JSONObject();
			data.put("projectId", projectId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "] ended.");
		return result;
	}
	
	//프로젝트 역할별 멤버 보기
	@SuppressWarnings({ "unchecked", "null" })
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/roles/{roleId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getProjectMember(@PathVariable Long projectId, @PathVariable int roleId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/roles/" + roleId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			int isGantt = 1;
			
			List<ProjectMemberVO> memberList = ezPMSService.getProjectMemberList(projectId, roleId, lang, tenantId, isGantt);
			
			//사원 이미지 사진 불러오기
			for (ProjectMemberVO member: memberList) {
				String imagePath = ezOrganService.getPropertyValue(member.getUserId(), "extensionAttribute2", tenantId);
				
				if (imagePath != null && !imagePath.equals("")) {
					String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", tenantId)+ commonUtil.separator + imagePath;
					String fullPath = request.getServletContext().getRealPath(realPath);
										
					if (fullPath != null || !fullPath.equals("")) {
						member.setUserImage("/ezCommon/downloadAttach.do?filePath=" + realPath);
					} else {
						member.setUserImage("/images/poll/default_pic_vote.gif");
					}

					if (member.getUserIdType().equals("dept")) {
						member.setUserImage("/images/poll/default_pic_vote.gif");
					}
					
				} else {
					member.setUserImage("/images/poll/default_pic_vote.gif");
				}
			}
		
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
			int tenantId = info.getTenantId();
			String orderStatus = request.getParameter("orderStatus");
			String kanbanOrder = ezPMSService.getKanbanOrder(projectId, userId, tenantId);
			
			if (kanbanOrder == null || kanbanOrder.equals("")) {
				ezPMSService.addKanbanOrder(projectId, userId, orderStatus, tenantId);
			} else if (!kanbanOrder.equals(orderStatus)) {
				ezPMSService.changeKanbanOrder(projectId, userId, orderStatus, tenantId);
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
	public JSONObject addTaskLog(@PathVariable long projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/projects/" + projectId + "/logs] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			String userId = request.getParameter("userId");
			String userName = info.getUserName();
			String userName2 = info.getUserName2();
			String userDeptname = info.getDeptName();
			String userDeptname2 = info.getDeptName2();
			
			TaskLogListVO taskLog = new TaskLogListVO();
			taskLog.setUserId(userId);
			taskLog.setUserName(userName);
			taskLog.setUserName2(userName2);
			taskLog.setUserDeptname(userDeptname);
			taskLog.setUserDeptname2(userDeptname2);
			taskLog.setTenantId(tenantId);
			taskLog.setProjectId(Long.parseLong(request.getParameter("projectId")));
			taskLog.setLogStatus(Integer.parseInt(request.getParameter("logStatus")));
			taskLog.setLogContent(request.getParameter("logContent"));
			taskLog.setLogDate(request.getParameter("logDate"));
			
			if (!request.getParameter("groupId").equals("") && request.getParameter("groupId") != null) {
				taskLog.setGroupId(Long.parseLong(request.getParameter("groupId")));
			}
			
			if (!request.getParameter("taskId").equals("") && request.getParameter("taskId") != null) {
				taskLog.setTaskId(Long.parseLong(request.getParameter("taskId")));
			}
			
			ezPMSService.addTaskLog(taskLog, tenantId, userId);
			
			
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			e.printStackTrace();
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
			String searchByContent = request.getParameter("searchByContent");

			//검색을 위한 search 파라미터
			Map<String, Object> search = new HashMap<>();
			search.put("location", request.getParameter("location"));
			search.put("startCount", request.getParameter("startCount"));
			search.put("listNumber", request.getParameter("listNumber"));
			search.put("listCount", request.getParameter("listCount"));
			search.put("orderWhat", request.getParameter("orderWhat"));
			search.put("orderHow", request.getParameter("orderHow"));
			search.put("taskId", request.getParameter("taskId"));
			search.put("groupId", request.getParameter("groupId"));
			search.put("searchByStatus", request.getParameter("searchByStatus"));

			if (searchByContent != null) {
				searchByContent = searchByContent.replace("\\","\\\\");
				searchByContent = searchByContent.replace("%", "\\%");
				searchByContent = searchByContent.replace("_", "\\_");
			}
			
			search.put("searchByContent", searchByContent);
			
			List<TaskLogListVO> taskLogList = ezPMSService.getTaskLogList(projectId, search, info.getOffSet(), lang, info.getTenantId());
			JSONObject data = new JSONObject();
			data.put("taskLogList", taskLogList);
			
			if (request.getParameter("taskId") != null) {
				if (request.getParameter("taskId").equals("0")) {
					long groupId = Long.parseLong(request.getParameter("groupId"));
					ProjectGroupVO groupDetails = ezPMSService.getGroupDetails(groupId, info.getTenantId(), projectId);
					data.put("groupDetails", groupDetails);
					data.put("taskDetails", "{}");
				} else {
					long taskId = Long.parseLong(request.getParameter("taskId"));
					ProjectTaskVO taskDetails = ezPMSService.getTaskDetails(taskId, info.getTenantId(), lang);
					data.put("taskDetails", taskDetails);
					data.put("groupDetails", "{}");
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
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String searchByName = request.getParameter("searchByProjectName").toString();
			String searchByUser = request.getParameter("searchByUser").toString();
			String searchByOverview = request.getParameter("searchByOverview").toString();
			
			if (searchByName != null && !searchByName.equals("")) {
				searchByName = request.getParameter("searchByProjectName").toString();
				searchByName = searchByName.replace("\\","\\\\");
				searchByName = searchByName.replace("%", "\\%");
				searchByName = searchByName.replace("_", "\\_");
			}
			
			if (searchByUser != null && !searchByUser.equals("")) {
				searchByUser = searchByUser.replace("\\","\\\\");
				searchByUser = searchByUser.replace("%", "\\%");
				searchByUser = searchByUser.replace("_", "\\_");
			}
			
			if (searchByOverview != null && !searchByOverview.equals("")) {
				searchByOverview = searchByOverview.replace("\\","\\\\");
				searchByOverview = searchByOverview.replace("%", "\\%");
				searchByOverview = searchByOverview.replace("_", "\\_");
			}
			
			ProjectInfoVO project = new ProjectInfoVO();
			project.setStatus(request.getParameter("listProjectStatus"));
			project.setProjectName(searchByName);
			project.setPlanStartDate(request.getParameter("searchByStartDate"));
			project.setPlanEndDate(request.getParameter("searchByEndDate"));
			project.setOverview(searchByOverview);
			project.setHeadManagerName(searchByUser);
			
			String deptId = request.getParameter("deptId");
			
			LOGGER.debug("status : " + project.getStatus() + ", deptId : " + deptId);
			int projectListCount;
			
			// admin 파라미터는 관리자모드에서만 넘어온다. 이 때 userId를 ""로 넘겨서 모든 프로젝트 검색이 가능하도록 한다.
			if(request.getParameter("admin") != null && request.getParameter("admin").equals("true")) {
				projectListCount = ezPMSService.getProjectListCount(project, info.getTenantId(), "", deptId, lang, request.getParameter("position"));
			} else {
				projectListCount = ezPMSService.getProjectListCount(project, info.getTenantId(), userId, deptId, lang, request.getParameter("position"));
			}
			
			LOGGER.debug("projectListCount : " + projectListCount);
			
			JSONObject data = new JSONObject();
			data.put("projectListCount", projectListCount);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
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
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String status = request.getParameter("status");
			String isMyTask = request.getParameter("isMyTask");
			String deptId = info.getDeptId();
			long groupId = 0;
			int roleId = 0;
			
			if (projectId != 0) {
				roleId = ezPMSService.getUserProjectRole(userId, info.getTenantId(), projectId, info.getDeptId());
			}
			
			if (request.getParameter("groupId") != null) {
				 groupId = Long.parseLong(request.getParameter("groupId")); 
			 }

			SearchVO search = new SearchVO();
			search.setTenantId(info.getTenantId());
			search.setStatus(status);
			search.setIsMyTask(isMyTask);
			search.setProjectId(projectId);
			search.setGroupId(groupId);
			search.setUpperGroupName(request.getParameter("searchByUpperGroupName"));
			search.setPlanStartDate(request.getParameter("searchByStartDate"));
			search.setPlanEndDate(request.getParameter("searchByEndDate"));
			search.setOverview(request.getParameter("searchByOverview"));
			search.setMemberName(request.getParameter("searchByUser"));
			search.setProjectName(request.getParameter("searchByProjectName"));
			search.setTaskName(request.getParameter("searchByTaskName"));
			
			int taskListCount = ezPMSService.getTaskListCount(search, userId, roleId, deptId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", taskListCount);
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
	public JSONObject getTaskLogListCount(@PathVariable long projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/"+ projectId + "/tasks/count] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			TaskLogListVO taskLog = new TaskLogListVO();
			taskLog.setProjectId(projectId);
			
			String searchByContent = request.getParameter("searchByContent");
			
			if (searchByContent != null) {
				searchByContent = searchByContent.replace("\\","\\\\");
				searchByContent = searchByContent.replace("%", "\\%");
				searchByContent = searchByContent.replace("_", "\\_");
			}
			
			taskLog.setLogContent(searchByContent);
			
			if (!request.getParameter("searchByStatus").equals("") && request.getParameter("searchByStatus") != null) {
				taskLog.setLogStatus(Integer.parseInt(request.getParameter("searchByStatus")));
			}
			
			if (!request.getParameter("groupId").equals("") && request.getParameter("groupId") != null) {
				taskLog.setGroupId(Long.parseLong(request.getParameter("groupId")));
			}
			
			if (!request.getParameter("taskId").equals("") && request.getParameter("taskId") != null) {
				taskLog.setTaskId(Long.parseLong(request.getParameter("taskId")));
			}
			
			int taskLogListCount = ezPMSService.getTaskLogListCount(taskLog, info.getTenantId());
			
			JSONObject data = new JSONObject();
			data.put("taskLogListCount", taskLogListCount);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
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
	
	//나의 업무 : 담당그룹 개수 호출
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/users/{userId}/groups/count", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getGroupCount(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/users/" + userId + "/groups/count] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
					
			SearchVO search = new SearchVO();
			search.setGroupName(request.getParameter("searchByGroupName"));
			search.setUpperGroupName(request.getParameter("searchByUpperGroupName"));
			search.setMemberName(request.getParameter("searchByUser"));
			search.setProjectName(request.getParameter("searchByProjectName"));
			search.setOverview(request.getParameter("searchByOverview"));
			search.setPlanStartDate(request.getParameter("searchByStartDate"));
			search.setPlanEndDate(request.getParameter("searchByEndDate"));
			
			int groupCount = ezPMSService.getGroupCount(search, info.getTenantId(), userId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", groupCount);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/users/" + userId + "/groups/count] ended.");
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
				int tenantId = info.getTenantId();
				
				List<ProjectUserVO> userList = ezPMSService.getDeptUserList(info.getTenantId(), key, value,lang);
				
				for (ProjectUserVO member: userList) {
					String imagePath = ezOrganService.getPropertyValue(member.getUserId(), "extensionAttribute2", tenantId);
					
					if (imagePath != null && !imagePath.equals("")) {
						String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", tenantId)+ commonUtil.separator + imagePath;
						String fullPath = request.getServletContext().getRealPath(realPath);
						
						if (fullPath != null || !fullPath.equals("")) {
							member.setUserImg(imagePath);
						} else {
							member.setUserImg("/images/poll/default_pic_vote.gif");
						}
					} else {
						member.setUserImg("/images/poll/default_pic_vote.gif");
					}
				}
				
				
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
		
		/**
		 * 프로젝트관리 G/W [GET] 총괄담당자 후보 정보 호출 (부서까지) 
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping(value="/rest/ezPMS/list/users", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
		public JSONObject getHeadManagerList(@RequestBody JSONObject json, HttpServletRequest request) throws Exception {
			LOGGER.debug("ezPMS G/W getHeadManagerList started.");
			
			JSONObject result = new JSONObject();
			
			try {
				String serverName = request.getHeader("x-user-host");
				MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
				String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
				int tenantId = info.getTenantId();
				List<Map<String, Object>> userList = (List<Map<String, Object>>) json.get("userList");
				
				List<ProjectUserVO> managerList = new ArrayList<ProjectUserVO>();
				
				for (int i = 0; i < userList.size(); i++) {
					if (userList.get(i).get("userIdType").equals("user")) {
						String userId = userList.get(i).get("userId").toString();
						List<ProjectUserVO> memberList = ezPMSService.getDeptUserList(tenantId, "CN", userId, lang);
						
						for (ProjectUserVO member : memberList) {
							if (!managerList.contains(member)) {
								managerList.add(member);
							}
						}
					} else {
						String userId = userList.get(i).get("userId").toString();
						List<ProjectUserVO> deptUserList = ezPMSService.getDeptUserList(tenantId, "DEPARTMENT", userId, lang);
						
						for (ProjectUserVO member : deptUserList) {
							if (!managerList.contains(member)) {
								managerList.add(member);
							}
						}
					}
				}
				
				for (ProjectUserVO member: managerList) {
					String imagePath = ezOrganService.getPropertyValue(member.getUserId(), "extensionAttribute2", tenantId);
					
					if (imagePath != null && !imagePath.equals("")) {
						String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", tenantId)+ commonUtil.separator + imagePath;
						String fullPath = request.getServletContext().getRealPath(realPath);
					
						if (fullPath != null || !fullPath.equals("")) {
							member.setUserImg("/ezCommon/downloadAttach.do?filePath=" + realPath);
						} else {
							member.setUserImg("/images/poll/default_pic_vote.gif");
						}
					} else {
						member.setUserImg("/images/poll/default_pic_vote.gif");
					}
				}
				
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", managerList);
			} catch (Exception e) {
				result.put("code", 1);
				result.put("status", "error");
				result.put("data", "");
			}
			
			LOGGER.debug("ezPMS G/W getHeadManagerList ended.");
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
				String[] taskIdList = taskId.split("_");
				int tenantId = info.getTenantId();
				String deptId = info.getDeptId();
				long projectId = Long.parseLong(request.getParameter("projectId"));
				String companyId = request.getParameter("companyId");
				String roleCheck = "";
				
				//권한 체크
				//1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
				int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, deptId);
				if (userProjectRole == 1) {
					roleCheck = "permitted";
				} else if (userProjectRole == 3) {
					//프로젝트 조회자는 열람권한밖에 없음
					roleCheck = "rejected";
				} else {
					//2. task의 담당자인지 확인
					for (int i = 0; i < taskIdList.length; i++) {
						String userTaskRole = ezPMSService.getUserTaskRole(userId, tenantId, Long.parseLong(taskIdList[i]));
							
						if (userTaskRole == null) {
							roleCheck = "rejected";
							break;
						}
					}
					
					if (roleCheck.equals("")) {
						roleCheck = "permitted";
					}
				}
				
				LOGGER.debug("DELETETASK ROLECHECK : " + roleCheck);
				
				if (roleCheck.equals("permitted")) {
					for (int i = 0; i < taskIdList.length; i++) {
						ezPMSService.deleteTask(Long.parseLong(taskIdList[i]), projectId, tenantId, companyId);
					}
					
				}
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", roleCheck);		
			} catch (Exception e) {
				result.put("status", "error");
				result.put("code", 1);
				result.put("data", "");		
			}
			
			LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] ended.");
			return result;
		}
		
	/**
	 * file path 불러오기
	 */
		@SuppressWarnings("unchecked")
		@RequestMapping(value = "/rest/ezPMS/items/{itemId}/files", method = RequestMethod.GET, produces="application/json;charset=utf-8")
		public JSONObject getFilePath (@PathVariable long itemId, HttpServletRequest request) throws Exception {
			LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/items/" + itemId + "/files] started.");

			JSONObject result = new JSONObject();
			
			try{
				String serverName = request.getHeader("x-user-host");
				String userId = request.getParameter("userId");
				MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
				String filePath = "";
				String imageFileType = "PNG,JPEG,BMP,GIF,JPG";
				
				List<Map<String, Object>> filePathList = ezPMSService.getFilePath(itemId, info.getTenantId());
				
				for (int i = 0; i < filePathList.size(); i++) {
					String fileName = filePathList.get(i).get("fileName").toString();
					fileName = fileName.substring(fileName.indexOf("."), fileName.length());
					
					if (fileName.contains(imageFileType)) {
						filePath = filePathList.get(i).get("filePath").toString();
						break;
					}
				}
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", filePath);		
			} catch (Exception e) {
				result.put("status", "error");
				result.put("code", 1);
				result.put("data", "");		
			}
			
			LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/items/" + itemId + "/files] ended.");
			return result;
		}
	
		//사용자의 프로젝트 권한 체크
		@SuppressWarnings("unchecked")
		@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/users/{userId}/role", method = RequestMethod.GET, produces="application/json;charset=utf-8")
		public JSONObject getUserProjectRole(@PathVariable Long projectId, @PathVariable String userId, HttpServletRequest request) throws Exception {
			LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/users/" + userId + "/role] started.");
			
			JSONObject result = new JSONObject();
			
			try {
				String serverName = request.getHeader("x-user-host");
				MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
				int tenantId = info.getTenantId();
				
				int userRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", userRole);
			} catch (Exception e) {
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "");
			}
			
			
			LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/users/" + userId + "/role] ended.");
			return result;
		}
		
		@SuppressWarnings("unchecked")
		@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/preTasks/{preTaskId}/type/{type}", method = RequestMethod.POST, produces="application/json;charset=utf-8")
		public JSONObject addPreTaskRel(@PathVariable long taskId, @PathVariable int preTaskId, @PathVariable String type, HttpServletRequest request) throws Exception {
			LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tasks/" + taskId + "/preTasks/" + preTaskId + "/type/" + type + "] started.");
			
			JSONObject result = new JSONObject();
			
			try {
				String userId = request.getParameter("userId");
				String serverName = request.getHeader("x-user-host");
				MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
				int tenantId = info.getTenantId();
				String roleCheck = "";
				long projectId = Long.parseLong(request.getParameter("projectId"));
				String companyId = info.getCompanyId();
				
				//권한 체크
				//1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
				int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
				if (userProjectRole == 1) {
					roleCheck = "permitted";
				} else {
					roleCheck = "rejected";
				}
			
				if (roleCheck.equals("permitted")) {
					//preTaskRel 테이블에 데이터 추가
					ezPMSService.addPreTaskRel(taskId, preTaskId, projectId, tenantId, type);
				}
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", roleCheck);
			} catch (Exception e) {
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "");
			}
			
			
			LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tasks/" + taskId + "/preTasks/" + preTaskId + "/type/" + type + "] ended.");
			return result;
		}
		
		@SuppressWarnings("unchecked")
		@RequestMapping(value = "/rest/ezPMS/project/{projectId}/gantt/order", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
		public JSONObject changeGanttOrder(@PathVariable long projectId, HttpServletRequest request, @RequestBody JSONObject json) throws Exception {
			LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/project/" + projectId + "/gantt/order] started.");
			
			JSONObject result = new JSONObject();
			
			try {
				String userId = request.getParameter("userId");
				String serverName = request.getHeader("x-user-host");
				MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
				int tenantId = info.getTenantId();
				String roleCheck = "permitted";
				
				//권한 체크
				//1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
				int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
				if (userProjectRole == 1) {
					roleCheck = "permitted";
				} else {
					//프로젝트 조회자는 열람권한밖에 없음
					//참여자는 간트 조정 불가
					roleCheck = "rejected";
				}
				
				LOGGER.debug("changeganttorder ROLECHECK : " + roleCheck);
				
				if (roleCheck.equals("permitted")) {
					//순서 변경된 taskId의 groupId변경 (groupId가 -1이면 변경 X)
					long changeGroupId = Long.parseLong(request.getParameter("changeGroupId"));
					
					if (changeGroupId != -1) {
						long targetTaskId = Long.parseLong(request.getParameter("targetTaskId"));
						int treeDepth = Integer.parseInt(request.getParameter("treeDepth"));
						ezPMSService.updateTaskGroupId(projectId, targetTaskId, changeGroupId, tenantId, treeDepth);
					}
					
					//그룹 순서 변경
					List<Map<String, Object>> groupList = (List<Map<String, Object>>) json.get("groupList");
					
					for (int i = 0; i < groupList.size(); i++) {
						long groupId = Long.parseLong(groupList.get(i).get("groupId").toString());
						int sortOrder = Integer.parseInt(groupList.get(i).get("order").toString());
					
						ezPMSService.updateGroupSort(projectId, groupId, sortOrder, tenantId);
					}
					
					//task 순서 변경
					List<Map<String, Object>> taskList = (List<Map<String, Object>>) json.get("taskList");
					
					for (int i = 0; i < taskList.size(); i++) {
						long groupId = Long.parseLong(taskList.get(i).get("groupId").toString());
						int sortOrder = Integer.parseInt(taskList.get(i).get("order").toString());
						long taskId = Long.parseLong(taskList.get(i).get("taskId").toString());
						int preTaskIndex = Integer.parseInt(taskList.get(i).get("depends").toString()); 
						
						ezPMSService.updateTaskSort(groupId, taskId, sortOrder, tenantId);
						
//						if (preTaskIndex != -1) {
//							ezPMSService.updatePreTaskRel(taskId, preTaskIndex, tenantId, projectId);
//						}
					}
				}
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", roleCheck);
			} catch (Exception e) {
				e.printStackTrace();
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "");
			}
			
			LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/project/" + projectId + "/gantt/order] ended.");
			return result;
		}
		
		@SuppressWarnings("unchecked")
		@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/management/members", method = RequestMethod.GET, produces="application/json;charset=utf-8")
		public JSONObject getMemberSchedule(@PathVariable long projectId, HttpServletRequest request) throws Exception {
			LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/management/members] started.");
			
			JSONObject result = new JSONObject();

			try {
				String userId = request.getParameter("userId");
				String serverName = request.getHeader("x-user-host");
				MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
				int tenantId = info.getTenantId();
				String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
				
				ProjectInfoVO project = ezPMSService.getProjectDetails(projectId, userId, tenantId, "gantt", lang, info.getDeptId(), info.getCompanyId());
				String planStartDate = project.getPlanStartDate();
				String planEndDate = project.getPlanEndDate();
				List<ProjectMemberVO> memberList = project.getProjectMember();
				List<ProjectMemberScheduleVO> memberScheduleList = ezPMSService.getMemberSchedule(projectId, tenantId, lang);
				
				DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
				Date startDate = dateFormat.parse(planStartDate);
				Date endDate = dateFormat.parse(planEndDate);
				
				Calendar startCal = Calendar.getInstance();
				Calendar endCal = Calendar.getInstance();
				
				startCal.setTime(startDate);
				endCal.setTime(endDate);
				
				List<String> dateList = new ArrayList<String>();
				
				while (startCal.compareTo(endCal) != 1) {
					if (startCal.get(Calendar.DAY_OF_WEEK) == 1 || startCal.get(Calendar.DAY_OF_WEEK) == 7) {	
						startCal.add(Calendar.DATE, 1);
					} else {
						dateList.add(dateFormat.format(startCal.getTime()));		
						startCal.add(Calendar.DATE, 1);
					}
				}
				
				JSONObject data = new JSONObject();
				data.put("planStartDate", planStartDate);
				data.put("planEndDate", planEndDate);
				data.put("memberList", memberList);
				data.put("memberScheduleList", memberScheduleList);
				data.put("dateList", dateList);
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", data);
			} catch (Exception e) {
				e.printStackTrace();
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "");
			}
		
			LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/project/" + projectId + "/management/members] ended.");
			return result;
		}
		
		@SuppressWarnings("unchecked")
		@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/dates/{date}/users/{selUserId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
		public JSONObject getDateTaskList(@PathVariable long projectId, @PathVariable String date, @PathVariable String selUserId, HttpServletRequest request) throws Exception {
			LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/project/" + projectId + "/dates/" + date + "/users/" + selUserId + "] started.");
			
			JSONObject result = new JSONObject();

			try {
				String userId = request.getParameter("userId");
				String serverName = request.getHeader("x-user-host");
				MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
				int tenantId = info.getTenantId();
				String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
				
				List<String> taskList = ezPMSService.getDateTaskList(projectId, date, selUserId, lang, tenantId);
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", taskList);
			} catch (Exception e) {
				e.printStackTrace();
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "");
			}
		
			LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/project/" + projectId + "/dates/" + date + "/users/" + selUserId + "] ended.");
			return result;
		}
}
