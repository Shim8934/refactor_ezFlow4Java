package egovframework.ezEKP.ezPMS.service.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.io.FileUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.icu.util.ChineseCalendar;

import egovframework.ezEKP.ezPMS.dao.EzPMSDAO;
import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.BoardViewerVO;
import egovframework.ezEKP.ezPMS.vo.CommentVO;
import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
import egovframework.ezEKP.ezPMS.vo.ProjectBoardFolderVO;
import egovframework.ezEKP.ezPMS.vo.ProjectBoardVO;
import egovframework.ezEKP.ezPMS.vo.ProjectCompanyVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectHolidayVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMainSettingVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberScheduleVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskTreeVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.ProjectUserVO;
import egovframework.ezEKP.ezPMS.vo.SearchVO;
import egovframework.ezEKP.ezPMS.vo.TaskLogListVO;
import egovframework.ezEKP.ezPMS.vo.TaskMemberVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("EzPMSService")
public class EzPMSServiceImpl extends EgovAbstractServiceImpl implements EzPMSService {
	private static final Logger logger = LoggerFactory.getLogger(EzPMSServiceImpl.class);

	@Autowired
	private CommonUtil commonUtil;

	@Resource(name = "EzPMSDAO")
	private EzPMSDAO ezPMSDAO;

	@Resource(name = "jspw")
    private String jspw;

	@Override
	public List<ProjectInfoVO> getProjectList(int tenantId, String userId, String deptId, Map<String, Object> search, String lang, String position, String companyId) {
		logger.debug("[SERVICE] getProjectList started.");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("lang", lang);
		map.put("deptId", deptId);
		map.put("position", position);

		if (search.get("projectSort").equals("1")) {
			map.put("projectSort", "PLAN_START_DATE");
		} else {
			map.put("projectSort", "PLAN_END_DATE");
		}

		search.remove("projectSort");

		map.putAll(search);

		List<ProjectInfoVO> projectList = new ArrayList<ProjectInfoVO>();

		try {
			projectList = ezPMSDAO.getProjectList(map);

			if (projectList != null) {
				for (int i = 0; i < projectList.size(); i++) {
					ProjectInfoVO project = projectList.get(i);

					if (!project.getStatus().equals("C")) {
						Date endDate = sdf.parse(project.getPlanEndDate());
						Date today = new Date();
						String simpToday = sdf.format(today);
						Date now = sdf.parse(simpToday);
						Date startDate = sdf.parse(project.getPlanStartDate());
						int restDueday = 0;
						
						if (startDate.before(now)) {
							restDueday = getWorkingDays(now, endDate, companyId, tenantId, lang);
						} else {
							restDueday = getWorkingDays(startDate, endDate, companyId, tenantId, lang);
						}
						
						projectList.get(i).setRestDueday(restDueday);
					}

					map.put("projectId", projectList.get(i).getProjectId());

					List<Map<String, Object>> statusCount = ezPMSDAO.getStatusCount(map);
					// 각 개수
					int totalTaskCount = 0;
					int completeTaskCount = 0;
					int lateTaskCount = 0;

					for (int j = 0; j < statusCount.size(); j++) {
						String taskStatus = statusCount.get(j).get("status").toString();
						int taskCount = Integer.parseInt(statusCount.get(j).get("count").toString());

						if (taskStatus.equals("C")) {
							completeTaskCount = taskCount;
						} else if (taskStatus.equals("L")) {
							lateTaskCount = taskCount;
						}

						totalTaskCount += taskCount;
					}

					projectList.get(i).setTotalTaskCount(totalTaskCount);
					projectList.get(i).setCompleteTaskCount(completeTaskCount);
					projectList.get(i).setLateTaskCount(lateTaskCount);

					// 프로젝트 이름에 따옴표
					projectList.get(i).setProjectName(
							projectList.get(i).getProjectName().replaceAll("&quot;", "\"").replace("&#39;", "\'"));
				}
			}
		} catch (Exception e) {
			logger.debug("ERROR : " + e.getMessage());
		}

		logger.debug("[SERVICE] getProjectList ended.");
		return projectList;
	}

	@Override
	public Long addNewProject(Map<String, Object> map) {
		logger.debug("[SERVICE] addNewProject started.");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		map.put("progress", 0);

		try {
			// 날짜 차이 계산
			Date startDate = sdf.parse(map.get("planStartDate").toString());
			Date endDate = sdf.parse(map.get("planEndDate").toString());
			int workingDays = getWorkingDays(startDate, endDate, map.get("companyId").toString(), Integer.parseInt(map.get("tenantId").toString()), (String)map.get("lang"));

			map.put("workingDay", workingDays);
			// map.put("workingDay", 0);
			map.put("restDueday", workingDays);

			// 프로젝트 총괄담당자 정보 불러오기
			ProjectMemberVO headManagerInfo = getUserInfo(map.get("headManagerId").toString(), Integer.parseInt(map.get("tenantId").toString()), "user");
			map.put("headManagerDeptname", headManagerInfo.getUserDeptname());
			map.put("headManagerDeptname2", headManagerInfo.getUserDeptname2());
			map.put("headManagerName", headManagerInfo.getUserName());
			map.put("headManagerName2", headManagerInfo.getUserName2());

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			logger.debug("Error : " + e.getMessage() + " " + e.getStackTrace());
		}

		Long projectId = ezPMSDAO.addNewProject(map);
		logger.debug("[SERVICE] addNewProject ended.");
		return projectId;
	}

	@Override
	public void deleteProject(int tenantId, Long projectId) {
		logger.debug("Service deleteProject started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);

		ezPMSDAO.deleteProject(map);

		logger.debug("Service deleteProject ended.");
	}

	@Override
	public void updateMainSetting(ProjectMainSettingVO project, int tenantId) {
		logger.debug("Service updateMainSetting started");

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", project.getUserId());
		param.put("tenantId", tenantId);
		param.put("userIdType", "user");

		ProjectMainSettingVO projectSetting = ezPMSDAO.getProjectMainSetting(param);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", project.getUserId());
		map.put("tenantId", tenantId);
		map.put("viewType", project.getViewType());
		map.put("progressColor", project.getProgressColor());
		map.put("completeColor", project.getCompleteColor());
		map.put("overdueColor", project.getOverdueColor());
		map.put("holdColor", project.getHoldColor());
		map.put("projectSort", project.getProjectSort());
		map.put("listNumber", project.getListNumber());
		map.put("listProjectStatus", project.getListProjectStatus());

		if (projectSetting.getUserId() == null) {
			logger.debug("DAO insertMainSetting started");
			ezPMSDAO.insertMainSetting(map);
		} else {
			logger.debug("DAO updateMainSetting started");
			ezPMSDAO.updateMainSetting(map);
		}

		logger.debug("Service updateMainSetting ended");
	}

	@Override
	public void updateProjectStatus(Long projectId, String status, int tenantId, String realStartDate,
			String planEndDate) {
		logger.debug("updateProjectStatus started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("status", status);
		map.put("tenantId", tenantId);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		try {

			if (status.equals("P")) {
				// 날짜 차이 계산
				Date endDate = sdf.parse(planEndDate);
				Date createDate = sdf.parse(realStartDate);

				int createAndEndDateComp = createDate.compareTo(endDate);

				if (createAndEndDateComp > 0) {
					map.put("status", "L");
				} else {
					map.put("status", "P");
				}
			}

			ezPMSDAO.updateProjectStatus(map);

		} catch (Exception e) {
			logger.debug("ERROR : " + e.getMessage());
		}

		logger.debug("updateProjectStatus ended.");
	}

	@Override
	public ProjectInfoVO getProjectDetails(Long projectId, String userId, int tenantId, String mode, String lang,
			String deptId, String companyId) {
		logger.debug("getProjectDetail started");

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("lang", lang);
		map.put("tenantId", tenantId);
		map.put("mode", mode);
		map.put("userId", userId);
		map.put("deptId", deptId);
		
		if (mode != null && mode.equals("gantt")) {
			map.put("isGantt", 0);
			map.put("roleId", 5);
		} else {
			map.put("isGantt", 1);
			map.put("roleId", 4);	
		}
		
		ProjectInfoVO project = ezPMSDAO.getProjectDetails(map);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			project.setProjectName(project.getProjectName().replaceAll("&quot;", "\"").replaceAll("&#39;", "\'"));

			// 프로젝트 멤버 불러오기
			List<ProjectMemberVO> member = ezPMSDAO.getProjectMemberList(map);
			project.setProjectMember(member);

			if (!project.getStatus().equals("C")) {
				Date startDate = sdf.parse(project.getPlanStartDate());
				Date endDate = sdf.parse(project.getPlanEndDate());
				Date today = new Date();
				String simpToday = sdf.format(today);
				Date now = sdf.parse(simpToday);
				
				int restDueday;
				
				if (startDate.before(now)) {
					restDueday = getWorkingDays(now, endDate, companyId, tenantId, lang);
				} else {
					restDueday = getWorkingDays(startDate, endDate, companyId, tenantId, lang);
				}
				
				project.setRestDueday(restDueday);
			}

		} catch (Exception e) {
			logger.debug("ERROR : " + e.getMessage());
		}

		logger.debug("getProjectDetail ended");

		return project;
	}

	@Override
	public void updateProject(ProjectInfoVO project, int tenantId, String companyId, String lang) {
		logger.debug("Service updateProject Started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", project.getProjectId());
		map.put("projectName", project.getProjectName());
		map.put("weightInput", project.getWeightInput());
		map.put("planStartDate", project.getPlanStartDate());
		map.put("planEndDate", project.getPlanEndDate());
		map.put("overview", project.getOverview());
		map.put("alamMailStatus", project.getAlamMailStatus());
		map.put("headManagerId", project.getHeadManagerId());
		map.put("tenantId", tenantId);
		map.put("mailRepeat", project.getMailRepeat());
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			// 날짜 차이 계산
			Date startDate = sdf.parse(project.getPlanStartDate());
			Date endDate = sdf.parse(project.getPlanEndDate());
			Date nowDate = sdf.parse(project.getCreateDate());

			int workingDays = getWorkingDays(startDate, endDate, companyId, tenantId, lang);

			int restDueday = getWorkingDays(nowDate, endDate, companyId, tenantId, lang);
			map.put("workingday", workingDays);
			map.put("restDueday", restDueday);

			// 프로젝트 총괄담당자 정보 불러오기
			ProjectMemberVO headManagerInfo = getUserInfo(project.getHeadManagerId(), tenantId, "user");
			map.put("headManagerDeptname", headManagerInfo.getUserDeptname());
			map.put("headManagerDeptname2", headManagerInfo.getUserDeptname2());
			map.put("headManagerName", headManagerInfo.getUserName());
			map.put("headManagerName2", headManagerInfo.getUserName2());

		} catch (Exception e) {
			logger.debug("Error : " + e.getMessage());
		}

		ezPMSDAO.updateProjectInfo(map);

		logger.debug("Service updateProject Ended.");
	}

	@Override
	public List<ProjectMemberVO> getProjectMemberList(Long projectId, int roleId, String lang, int tenantId,
			int isGantt) {
		logger.debug("getProjectMemberList started");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("projectId", projectId);
		param.put("roleId", roleId);
		param.put("lang", lang);
		param.put("tenantId", tenantId);
		param.put("isGantt", isGantt);

		List<ProjectMemberVO> list = ezPMSDAO.getProjectMemberList(param);

		logger.debug("getProjectMemberList ended");
		return list;
	}

	@Override
	public void changeKanbanOrder(Long projectId, String userId, String orderStatus, int tenantId) {
		logger.debug("[SERVICE] changeKanbanOrder started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("userId", userId);
		map.put("orderStatus", orderStatus);
		map.put("tenantId", tenantId);

		ezPMSDAO.changeKanbanOrder(map);

		logger.debug("[SERVICE] changeKanbanOrder ended.");
	}

	@Override
	public void addKanbanOrder(Long projectId, String userId, String orderStatus, int tenantId) {
		logger.debug("[SERVICE] addKanbanOrder started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("userId", userId);
		map.put("orderStatus", orderStatus);
		map.put("tenantId", tenantId);

		ezPMSDAO.addKanbanOrder(map);
		logger.debug("[SERVICE] changeKanbanOrder ended.");
	}

	@Override
	public int addFavoriteProject(Long projectId, String userId, int tenantId) {
		logger.debug("[SERVICE] addFavoriteProject started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		int isChecked = 0;
		
		List<Long> favoriteProjectId = ezPMSDAO.getFavoriteProject(map);

		for (int i = 0; i < favoriteProjectId.size(); i++) {
			Long favoriteProject = favoriteProjectId.get(i);
			
			if (projectId.compareTo(favoriteProject) == 0) {
				System.out.println(favoriteProject);
				isChecked = 1;
				break;
			}
		}
		System.out.println(isChecked);
		if (isChecked == 0) {
			ezPMSDAO.addFavoriteProject(map);
		}
		
		logger.debug("isChecked : " + isChecked);
		logger.debug("[SERVICE] addFavoriteProject ended.");
		return isChecked;
	}

	@Override
	public void deleteFavoriteProject(Long projectId, String userId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("userId", userId);
		map.put("tenantId", tenantId);

		ezPMSDAO.deleteFavoriteProject(map);

	}

	@Override
	public void addTaskLog(TaskLogListVO taskLog, int tenantId, String userId) {
		logger.debug("[SERVICE] addTaskLog started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", taskLog.getUserId());
		map.put("userName", taskLog.getUserName());
		map.put("userName2", taskLog.getUserName2());
		map.put("userDeptname", taskLog.getUserDeptname());
		map.put("userDeptname2", taskLog.getUserDeptname2());
		map.put("tenantId", taskLog.getTenantId());
		map.put("projectId", taskLog.getProjectId());
		map.put("logStatus", taskLog.getLogStatus());
		map.put("logContent", taskLog.getLogContent());
		map.put("logDate", taskLog.getLogDate());
		map.put("groupId", taskLog.getGroupId());
		map.put("taskId", taskLog.getTaskId());

		ezPMSDAO.addTaskLog(map);
		logger.debug("[SERVICE] addTaskLog ended");
	}

	@Override
	public List<TaskLogListVO> getTaskLogList(Long projectId, Map<String, Object> map, String offset, String lang,
			int tenantId) throws Exception {
		logger.debug("[SERVICE] getTaskLogList started");
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		map.put("offset", commonUtil.getMinuteUTC(offset));

		List<TaskLogListVO> taskLogList = ezPMSDAO.getTaskLogList(map);

		logger.debug("[SERVICE] getTaskLogList ended");
		return taskLogList;
	}

	@Override
	public int getProjectListCount(ProjectInfoVO project, int tenantId, String userId, String deptId, String lang,
			String position) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", project.getStatus());
		map.put("searchByName", project.getProjectName());
		map.put("lang", lang);
		map.put("searchByStartDate", project.getPlanStartDate());
		map.put("searchByEndDate", project.getPlanEndDate());
		map.put("searchByOverview", project.getOverview());
		map.put("searchByUser", project.getHeadManagerName());
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("position", position);

		int projectListCount = ezPMSDAO.getProjectListCount(map);

		return projectListCount;
	}

	@Override
	public int getTaskListCount(SearchVO search, String userId, int roleId, String deptId) {
		logger.debug("[SERVICE] getTaskListCount started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", search.getStatus());
		map.put("isMyTask", search.getIsMyTask());
		map.put("projectId", search.getProjectId());
		map.put("tenantId", search.getTenantId());
		map.put("userId", userId);
		map.put("groupId", search.getGroupId());
		map.put("upperGroupName", search.getUpperGroupName());
		map.put("searhByStartDate", search.getPlanStartDate());
		map.put("searchByEndDate", search.getPlanEndDate());
		map.put("searchByOverview", search.getOverview());
		map.put("searchByUser", search.getMemberName());
		map.put("taskName", search.getTaskName());
		map.put("searchByProjectName", search.getProjectName());
		map.put("roleId", roleId);
		map.put("deptId", deptId);
		

		int taskCount = ezPMSDAO.getTaskListCount(map);

		logger.debug("[SERVICE] getTaskListCount ended.");
		return taskCount;
	}

	@Override
	public int getTaskLogListCount(TaskLogListVO taskLog, int tenantId) {
		logger.debug("[SERVICE] getTaskLogListCount started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", taskLog.getProjectId());
		map.put("searchByContent", taskLog.getLogContent());
		map.put("searchByStatus", taskLog.getLogStatus());
		map.put("groupId", taskLog.getGroupId());
		map.put("taskId", taskLog.getTaskId());
		map.put("tenantId", tenantId);

		int taskLogListCount = ezPMSDAO.getTaskLogListCount(map);

		logger.debug("taskLogListCount : " + taskLogListCount);
		logger.debug("[SERVICE] getTaskLogListCount ended.");
		return taskLogListCount;
	}

	@Override
	public int getMemberCount(Long projectId, int roleId, int tenantId) {
		return 0;
	}

	@Override
	public String getKanbanOrder(Long projectId, String userId, int tenantId) {
		logger.debug("[SERVICE] getKanbanOrder started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);

		String kanbanOrder = "";
		kanbanOrder = ezPMSDAO.getKanbanOrder(map);

		logger.debug("[SERVICE] getKanbanOrder ended.");
		return kanbanOrder;
	}

	@Override
	public List<String> getProjectNameList(String userId, int tenantId) {
		return null;
	}

	@Override
	public List<ProjectTaskVO> getTaskList(SearchVO search, String userId, int limit, int startRow, String orderWhat,
			String orderHow, String location, int roleId, String deptId) {
		logger.debug("[SERVICE] getTaskList started");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("projectId", search.getProjectId());
		param.put("taskName", search.getTaskName());
		param.put("upperGroupName", search.getUpperGroupName());
		param.put("headManagerName", search.getMemberName());
		param.put("overview", search.getOverview());
		param.put("searhByStartDate", search.getPlanStartDate());
		param.put("searchByEndDate", search.getPlanEndDate());
		param.put("lang", ""); // 파라미터로 받아와야함.
		param.put("status", search.getStatus());
		param.put("tenantId", search.getTenantId());
		param.put("limit", limit);
		param.put("startRow", startRow);
		param.put("groupId", search.getGroupId());
		param.put("isMyTask", search.getIsMyTask());
		param.put("roleId", roleId);
		param.put("deptId", deptId);
		
		// 정렬
		param.put("orderWhat", orderWhat);
		param.put("orderHow", orderHow);
		param.put("location", location);

		// 검색
		param.put("searchByOverview", search.getOverview());
		param.put("searchByUser", search.getMemberName());
		param.put("taskName", search.getTaskName());
		param.put("searchByProjectName", search.getProjectName());

		List<ProjectTaskVO> list = ezPMSDAO.getTaskList(param);

		logger.debug("[SERVICE] getTaskList ended");
		return list;
	}
	
	@Override
	public List<ProjectTaskVO> getTaskListForGantt(SearchVO search, String userId, int limit, int startRow, String orderWhat, String orderHow, String location, int roleId, String deptId, ArrayList<String> holidayList) {
		logger.debug("[SERVICE] getTaskListForGantt started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("projectId", search.getProjectId());
		param.put("taskName", search.getTaskName());
		param.put("upperGroupName", search.getUpperGroupName());
		param.put("headManagerName", search.getMemberName());
		param.put("overview", search.getOverview());
		param.put("searhByStartDate", search.getPlanStartDate());
		param.put("searchByEndDate", search.getPlanEndDate());
		param.put("lang", ""); // 파라미터로 받아와야함.
		param.put("status", search.getStatus());
		param.put("tenantId", search.getTenantId());
		param.put("limit", limit);
		param.put("startRow", startRow);
		param.put("groupId", search.getGroupId());
		param.put("isMyTask", search.getIsMyTask());
		param.put("roleId", roleId);
		param.put("deptId", deptId);
		
		// 정렬
		param.put("orderWhat", orderWhat);
		param.put("orderHow", orderHow);
		param.put("location", location);
		
		// 검색
		param.put("searchByOverview", search.getOverview());
		param.put("searchByUser", search.getMemberName());
		param.put("taskName", search.getTaskName());
		param.put("searchByProjectName", search.getProjectName());
		param.put("holidayList", holidayList);
		
		List<ProjectTaskVO> list = ezPMSDAO.getTaskListForGantt(param);
		
		logger.debug("[SERVICE] getTaskListForGantt ended");
		return list;
	}

	@Override
	public List<ProjectGroupVO> getGroupList(SearchVO search, String orderWhat, String orderHow, int startRow,
			int limit, String lang, String location) {
		logger.debug("[SERVICE] getGroupList started.");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("projectId", search.getProjectId());
		param.put("tenantId", search.getTenantId());
		param.put("lang", lang);
		param.put("orderWhat", orderWhat);
		param.put("orderHow", orderHow);
		param.put("startRow", startRow);
		param.put("limit", limit);
		param.put("searchByUpperGroupName", search.getUpperGroupName());
		param.put("searchByUser", search.getMemberName());
		param.put("searchByStartDate", search.getPlanStartDate());
		param.put("searchByEndDate", search.getPlanEndDate());
		param.put("searchByGroupName", search.getGroupName());
		param.put("searchByOverview", search.getOverview());
		param.put("searchByProjectName", search.getProjectName());
		param.put("userId", search.getMemberId());
		param.put("location", location);

		List<ProjectGroupVO> list = ezPMSDAO.getGroupList(param);

		logger.debug("[SERVICE] getGroupList ended.");
		return list;
	}
	
	@Override
	public List<ProjectGroupVO> getGroupListForGantt(SearchVO search, String orderWhat, String orderHow, int startRow,
			int limit, String lang, String location, ArrayList<String> holidayList) {
		logger.debug("[SERVICE] getGroupListForGantt started.");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("projectId", search.getProjectId());
		param.put("tenantId", search.getTenantId());
		param.put("lang", lang);
		param.put("orderWhat", orderWhat);
		param.put("orderHow", orderHow);
		param.put("startRow", startRow);
		param.put("limit", limit);
		param.put("searchByUpperGroupName", search.getUpperGroupName());
		param.put("searchByUser", search.getMemberName());
		param.put("searchByStartDate", search.getPlanStartDate());
		param.put("searchByEndDate", search.getPlanEndDate());
		param.put("searchByGroupName", search.getGroupName());
		param.put("searchByOverview", search.getOverview());
		param.put("searchByProjectName", search.getProjectName());
		param.put("userId", search.getMemberId());
		param.put("location", location);
		param.put("holidayList", holidayList);
		
		List<ProjectGroupVO> list = ezPMSDAO.getGroupListForGantt(param);
		
		logger.debug("[SERVICE] getGroupListForGantt ended.");
		return list;
	}

	@Override
	public int addTask(ProjectTaskVO taskVO, List<TaskMemberVO> taskMemberList, String companyId, int tenantId, String lang) {
		logger.debug("[SERVICE] addTask started.");
		Long taskId = (long) 0;

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		try {

			String projectId = taskVO.getProjectId() + "";

			// 정렬 순서 구하기
			int sortOrder = ezPMSDAO.getSortOrder(taskVO.getGroupId() + "");
			taskVO.setSortOrder(sortOrder);

			// 투입률 총합
			float sumPctinput = 0;

			taskVO.setRealProgress((float) 0);
			taskVO.setMemberCount(taskMemberList.size());

			// workingday 계산
			Date startDate = sdf.parse(taskVO.getPlanStartDate());
			Date endDate = sdf.parse(taskVO.getPlanEndDate());
//			Date createDate = new SimpleDateFormat("yyyy-MM-dd").parse(taskVO.getWriteDate());
			
			int calWorkingDays = getWorkingDays(startDate, endDate, companyId, tenantId, lang);

//			int createAndEndDateComp = createDate.compareTo(endDate);
//
//			if (createAndEndDateComp > 0) {
//				taskVO.setStatus("L");
//			} else {
//				taskVO.setStatus("W");
//			}
			
			taskVO.setStatus("W");

			// 업무 총괄담당자 정보 불러오기
			ProjectMemberVO headManagerInfo = getUserInfo(taskVO.getHeadManagerId(), taskVO.getTenantId(), "user");
			taskVO.setHeadManagerName(headManagerInfo.getUserName());
			taskVO.setHeadManagerName2(headManagerInfo.getUserName2());
			taskVO.setHeadManagerDeptname(headManagerInfo.getUserDeptname());
			taskVO.setHeadManagerDeptname2(headManagerInfo.getUserDeptname2());
			taskVO.setRealWorkingday(calWorkingDays);

			taskId = ezPMSDAO.addTask(taskVO);

			for (int i = 0; i < taskMemberList.size(); i++) {
				TaskMemberVO taskMemberVO = taskMemberList.get(i);
				taskMemberList.get(i).setTaskId(taskId);
				sumPctinput += taskMemberVO.getPctinput();
			}
			ezPMSDAO.addTaskMember(taskMemberList);

			float taskWorkingday = calWorkingDays * (sumPctinput / 100);

			HashMap<String, Object> map1 = new HashMap<String, Object>();
			map1.put("projectId", projectId);
			map1.put("workingday", taskWorkingday);
			map1.put("realWorkingday", calWorkingDays);
			map1.put("tenantId", taskVO.getTenantId());
			ezPMSDAO.updateProjectWorkingdaySum(map1);

			// 가중치 계산
			updateTaskWDNW(taskVO, taskWorkingday);

			// 프로젝트 직속 업무가 아니라면 업무가 속한 모든 조상그룹의 일정을 업데이트 해준다.
			if (!taskVO.getGroupId().equals(0L)) {
				String ancesterGroup = getAncesterGroup(taskVO.getGroupId(), taskVO.getTenantId());
				String[] ancGroupArr = ancesterGroup.split(",");

				for (int i = 0; i < ancGroupArr.length; i++) {
					updateGroupDate(Long.parseLong(ancGroupArr[i]), taskVO.getTenantId(), companyId, lang);
					
					//조상 그룹의 하위 그룹 중에서 하위 업무가 없는 그룹들을 찾아서 일정을 업데이트 해줌
					List<Long> groupTaskNoneList = getGroupTaskNoneList(Long.parseLong(ancGroupArr[i]), companyId, taskVO.getTenantId(), Long.parseLong(projectId));
					int groupTaskNoneListCount = groupTaskNoneList.size();
					
					for (int j = 0; j < groupTaskNoneListCount; j++) {
						updateGroupDate(groupTaskNoneList.get(j), taskVO.getTenantId(), companyId, lang);
					}
				}
			}

			// 프로젝트 직속 업무가 아니라면 업무가 속한 모든 조상그룹의 진행률을 업데이트 해준다.
			if (!taskVO.getGroupId().equals(0L)) {
				String ancesterGroup = getAncesterGroup(taskVO.getGroupId(), taskVO.getTenantId());
				String[] ancGroupArr = ancesterGroup.split(",");

				for (int i = 0; i < ancGroupArr.length; i++) {
					map1.put("groupId", ancGroupArr[i]);
					ezPMSDAO.updateGroupProgress(map1);
				}
			}

			// 업무가 속한 프로젝트의 진행률을 업데이트 해준다.
			ezPMSDAO.updateProjectProgress(taskVO);

			// 업데이트 후 프로젝트 진행률을 조회
			ProjectInfoVO projectDetails = ezPMSDAO.getProjectDetails(map1);

			// 프로젝트 진행률이 100이상인데 업무가 추가 되었으면, 진행으로 상태를 바꾼다.
			if (Math.round(projectDetails.getProgress() * 100) / 100.0d >= 100) {
				map1.put("status", "P");
				ezPMSDAO.updateProjectStatus(map1);
				// 업무가 속한 프로젝트 날짜 업데이트
				Date projectStartDate = sdf.parse(projectDetails.getPlanStartDate());
				Date projectEndDate = sdf.parse(projectDetails.getPlanEndDate());
				if(endDate.compareTo(projectEndDate) > 0){
					Map<String, Object> map = new HashMap<String, Object>();
					int workingday = getWorkingDays(projectStartDate, endDate, companyId, tenantId, lang);

					map.put("workingday", workingday);
					map.put("planStartDate", projectStartDate);
					map.put("planEndDate", endDate);

					ezPMSDAO.updateProjectDate(map);
				}
			}

			logger.debug("[SERVICE] updateTaskProgress ended.");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("[SERVICE] addTask ended.");

		return taskId.intValue();
	}

	private List<Long> getGroupTaskNoneList(long groupId, String companyId, int tenantId, long projectId) {
		logger.debug("[SERVICE] getGroupTaskNoneList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", groupId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("projectId", projectId);
		
		logger.debug("[SERVICE] getGroupTaskNoneList ended.");
		return ezPMSDAO.getGroupTaskNoneList(map);
	}

	@Override
	public List<ProjectMemberScheduleVO> getMemberScheduleList(Long projectId, String startDate, String endDate) {
		return null;
	}

	@Override
	public ProjectTaskVO getTaskDetails(Long taskId, int tenantId, String lang) {
		logger.debug("[SERVICE] getTaskDetails started.");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("taskId", taskId);
		param.put("tenantId", tenantId);
		param.put("lang", lang);

		ProjectTaskVO taskDetails = ezPMSDAO.getTaskDetails(param);
		
		String pretaskIds = taskDetails.getPretask();
		
		if(pretaskIds != null && !pretaskIds.equals("")) {
			String[] pretaskIdArr = pretaskIds.split(",");
			
			Long projectId = taskDetails.getProjectId();
			param.put("projectId", projectId);
			
			List<String> pretaskFullNames = new ArrayList<String>();
			List<String> pretaskNames = new ArrayList<String>();
			
			for(String pretaskId : pretaskIdArr) {
				String pretaskFullName = "";
				String pretaskName = "";
				
				param.put("taskId", pretaskId);	
				ProjectTaskVO pretaskVO = ezPMSDAO.getTaskDetails(param);
				
				String[] pretaskAncesterGroup = pretaskVO.getAncesterGroup().split(",");
				
				for(int i = 1; i < pretaskAncesterGroup.length; i++) {
					param.put("groupId", pretaskAncesterGroup[i]);
					pretaskFullName += ezPMSDAO.getGroupDetails(param).getGroupName() + " > ";
				}
				
				pretaskFullName += pretaskVO.getTaskName();
				pretaskName = pretaskVO.getTaskName();
				pretaskFullNames.add(pretaskFullName);
				pretaskNames.add(pretaskName);
			}
			
			taskDetails.setPretaskFullNames(pretaskFullNames);
			taskDetails.setPretaskNames(pretaskNames);
		}
		
//		if (taskDetails != null) {
//
//			String pretaskId = taskDetails.getPretask();
//			String pregroupId = taskDetails.getPregroup();
//			
//			if(pretaskId != null || pregroupId != null) {
//				
//				Long projectId = taskDetails.getProjectId();
//				param.put("projectId", projectId);
//				
//				String pretaskAncesterIds[] = taskDetails.getPretaskAncesterGroupIds().split(",");	
//				
//				String pretaskName = "";
//				
//				for(int i = 1; i < pretaskAncesterIds.length; i++) {
//					param.put("groupId", pretaskAncesterIds[i]);
//					pretaskName += ezPMSDAO.getGroupDetails(param).getGroupName() + " > ";
//				}
//				
//				if(pretaskId != null) {
//					param.put("taskId", pretaskId);	
//					pretaskName += ezPMSDAO.getTaskDetails(param).getTaskName();
//				} else {
//					pretaskName = pretaskName.substring(0, pretaskName.lastIndexOf(">") - 1);
//				}
//				
//				taskDetails.setPretaskName(pretaskName);
//			}
//		}
		
		logger.debug("[SERVICE] getTaskDetails ended.");
		return taskDetails;
	}

//	@Override
//	public int updateTask(ProjectTaskVO task, String companyId, int tenantId, String lang) {
//		logger.debug("[SERVICE] updateTask started.");
//		////////////////////현재 호출하는 부분 없는 듯 2018-07-02 홍대표/////////////////////////////////////////////
//		Long taskId = (long) 0;
//
//		try {
//			List<TaskMemberVO> taskMemberList = task.getTaskMember();
//
//			String projectId = task.getProjectId() + "";
//
//			// 정렬 순서 구하기
//			int sortOrder = ezPMSDAO.getSortOrder(task.getGroupId() + "");
//			task.setSortOrder(sortOrder);
//
//			// 투입률 총합
//			float sumPctinput = 0;
//
//			task.setRealProgress((float) 0);
//			task.setMemberCount(taskMemberList.size());
//
//			// workingday 계산
//			Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(task.getPlanStartDate());
//			Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(task.getPlanEndDate());
//			Date createDate = new SimpleDateFormat("yyyy-MM-dd").parse(task.getWriteDate());
//
//			int calWorkingDays = getWorkingDays(startDate, endDate, companyId, tenantId, lang);
//
//			int createAndEndDateComp = createDate.compareTo(endDate);
//
//			if (createAndEndDateComp > 0) {
//				task.setStatus("L");
//			} else {
//				task.setStatus("W");
//			}
//
//			// 업무 총괄담당자 정보 불러오기
//			ProjectMemberVO headManagerInfo = getUserInfo(task.getHeadManagerId(), task.getTenantId(), "user");
//			task.setHeadManagerName(headManagerInfo.getUserName());
//			task.setHeadManagerName2(headManagerInfo.getUserName2());
//			task.setHeadManagerDeptname(headManagerInfo.getUserDeptname());
//			task.setHeadManagerDeptname2(headManagerInfo.getUserDeptname2());
//
//			taskId = ezPMSDAO.addTask(task);
//
//			for (int i = 0; i < taskMemberList.size(); i++) {
//				TaskMemberVO taskMemberVO = taskMemberList.get(i);
//				taskMemberList.get(i).setTaskId(taskId);
//				sumPctinput += taskMemberVO.getPctinput();
//			}
//			ezPMSDAO.addTaskMember(taskMemberList);
//
//			float taskWorkingday = calWorkingDays * (sumPctinput / 100);
//
//			HashMap<String, Object> map1 = new HashMap<String, Object>();
//			map1.put("projectId", projectId);
//			map1.put("workingday", taskWorkingday);
//			map1.put("tenantId", tenantId);
//			map1.put("realWorkingday", calWorkingDays);
//			
//			//task
//			map1.put("taskId", taskId);
//			map1.put("roleId", 3);
//
//			ProjectTaskVO taskVO = ezPMSDAO.getTaskDetails(map1);
//			map1.replace("realWorkingday", taskVO.getRealWorkingday() - calWorkingDays);
//			//업무수정하면서 워킹데이합계 재계산
//			ezPMSDAO.updateProjectWorkingdaySum(map1);
//
//			// 가중치 계산
//			updateTaskWDNW(task, taskWorkingday);
//
//			// 프로젝트 직속 업무가 아니라면 업무가 속한 모든 조상그룹의 일정을 업데이트 해준다.
//			if (!task.getGroupId().equals(0L)) {
//				String ancesterGroup = getAncesterGroup(task.getGroupId(), task.getTenantId());
//				String[] ancGroupArr = ancesterGroup.split(",");
//
//				for (int i = 0; i < ancGroupArr.length; i++) {
//					updateGroupDate(Long.parseLong(ancGroupArr[i]), task.getTenantId(), companyId);
//				}
//			}
//
//			// 업무가 속한 프로젝트 날짜 업데이트
//			// updateProjectDate(task.getProjectId(), task.getTenantId(),
//			// companyId);
//		} catch (Exception e) {
//			logger.error(e.getMessage(), e);
//		}
//
//		logger.debug("[SERVICE] updateTask ended.");
//
//		return taskId.intValue();
//	}

	@Override
	public void deleteTask(Long taskId, long projectId, int tenantId, String companyId, String lang) throws Exception {
		logger.debug("[SERVICE] deleteTask started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskId", taskId);
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		//getTaskListCount에서 userId 조건을 피하기 위해 roleId = 3
		map.put("roleId", 3);

		ProjectTaskVO taskVO = ezPMSDAO.getTaskDetails(map);
		int weightInput = ezPMSDAO.getWeightInput(map);

		ezPMSDAO.deleteTask(map);

		//삭제 후 업무의 갯수를 구해온다.
		int taskCnt = ezPMSDAO.getTaskListCount(map);
		//프로젝트에 업무가 존재한다면 일정, 진행률, 가중치를 조정.
		if(taskCnt > 0){
			// 프로젝트 직속 업무가 아니라면 업무가 속한 모든 조상그룹의 일정을 업데이트 해준다.
			if (!taskVO.getGroupId().equals(0L)) {
				String ancesterGroup = getAncesterGroup(taskVO.getGroupId(), taskVO.getTenantId());
				String[] ancGroupArr = ancesterGroup.split(",");
				
				for (int i = 0; i < ancGroupArr.length; i++) {
					//그룹이 프로젝트일 경우 별도로 처리.
					if(i == 0){
						
					}
					updateGroupDate(Long.parseLong(ancGroupArr[i]), taskVO.getTenantId(), companyId, lang);
				}
			}
			
			// 프로젝트 직속 업무가 아니라면 업무가 속한 모든 조상그룹의 진행률을 업데이트 해준다.
			if (!taskVO.getGroupId().equals(0L)) {
				String ancesterGroup = getAncesterGroup(taskVO.getGroupId(), taskVO.getTenantId());
				String[] ancGroupArr = ancesterGroup.split(",");
				
				for (int i = 0; i < ancGroupArr.length; i++) {
					map.put("groupId", ancGroupArr[i]);
					ezPMSDAO.updateGroupProgress(map);
				}
			}
			
			// 삭제 하면서 프로젝트와 프로젝트 하위 업무 가중치 계산
			HashMap<String, Object> map2 = new HashMap<String, Object>();
			float taskWorkingday = taskVO.getRealWorkingday();
			
			ezPMSDAO.updateProjectWorkingdaySum2(map);
			
			// 가중치 계산
			if (weightInput == 0) {
				int projectWorkingdaySum = ezPMSDAO.getProjectWorkingdaySum(taskVO);
				float calWeight = (taskWorkingday / projectWorkingdaySum) * 100;
				System.out.println(">>>>>>>>>>>>>>" + calWeight + " = (" + taskWorkingday + " / " + projectWorkingdaySum + ") * 100");
				map2.put("weight", calWeight);
				map2.put("workingdaySum", projectWorkingdaySum);
			} else {
				map2.put("weight", taskVO.getWeight());
			}
			map2.put("taskId", taskId);
			map2.put("workingday", taskWorkingday);
			map2.put("tenantId", tenantId);
			map2.put("projectId", projectId);

			ezPMSDAO.updateTaskWDNW(map2);
			
			//프로젝트가 가중치 자동 계산일 경우 모든 업무의 가중치 재계산
			if (weightInput == 0) {
				ezPMSDAO.updateAllTaskWeight(map2);
			}
			
			// 업무가 속한 프로젝트의 진행률을 업데이트 해준다.
			ezPMSDAO.updateProjectProgress(taskVO);
			
			// 업데이트 후 프로젝트 진행률을 조회
			ProjectInfoVO projectDetails = ezPMSDAO.getProjectDetails(map);
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			
			Double projectProgress = Math.round(projectDetails.getProgress() * 100) / 100.0d;
			// 완료상태가 아닌 프로젝트인데, 업무를 삭제하면서 진행률이 100퍼센트 됐다면 완료상태로 바꾸어주고 실제종료일을 오늘 날짜로 바꾸어준다.
			if ( projectProgress >= 100 && !projectDetails.getStatus().equals("C")) {
				map.put("status", "C");
				ezPMSDAO.updateProjectStatus(map);
				Date startDate = sdf.parse(projectDetails.getPlanStartDate());
				Date endDate = sdf.parse(sdf.format(new Date()));
				int workingday = getWorkingDays(startDate, endDate, companyId, tenantId, lang);

				map.put("restDueday", workingday);
				map.put("progress", projectProgress);
				map.put("changeDate", endDate);

				ezPMSDAO.updateProjectRealDate((HashMap<String, Object>)map);
			}
		}

		logger.debug("[SERVICE] deleteTask ended.");
	}

	@Override
	public Long addGroup(Map<String, Object> map, String isIssue, String companyId, int tenantId, String lang) {
		logger.debug("[SERVICE] addGroup started.");
		map.put("delStatus", 0);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			// 날짜 차이 계산
			Date startDate = sdf.parse(map.get("planStartDate").toString());
			Date endDate = sdf.parse(map.get("planEndDate").toString());
			Date createDate = sdf.parse(map.get("createDate").toString());

			int createAndStartDateComp = createDate.compareTo(startDate);
			int workingDays = 0;

			if (createAndStartDateComp <= 0) {
				workingDays = getWorkingDays(startDate, endDate, companyId, tenantId, lang);
			} else {
				workingDays = getWorkingDays(createDate, endDate, companyId, tenantId, lang);
			}

			map.put("workingDay", workingDays);
			map.put("restDueday", workingDays);
			map.put("isIssue", isIssue);

			// 프로젝트 총괄담당자 정보 불러오기
			ProjectMemberVO headManagerInfo = getUserInfo(map.get("headManagerId").toString(),
					Integer.parseInt(map.get("tenantId").toString()), "user");
			map.put("headManagerDeptname", headManagerInfo.getUserDeptname());
			map.put("headManagerDeptname2", headManagerInfo.getUserDeptname2());
			map.put("headManagerName", headManagerInfo.getUserName());
			map.put("headManagerName2", headManagerInfo.getUserName2());
		} catch (Exception e) {
			logger.debug("ERROR : " + e.getMessage() + " " + e.getStackTrace());
		}
		Long groupId = ezPMSDAO.addTaskGroup(map);
		logger.debug("[SERVICE] addGroup ended.");
		return groupId;
	}

	@Override
	public ProjectGroupVO getGroupDetails(long groupId, int tenantId, long projectId) {
		logger.debug("[SERVICE] getGroupDetails started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("groupId", groupId);
		map.put("tenantId", tenantId);

		ProjectGroupVO groupInfo = ezPMSDAO.getGroupDetails(map);
		groupInfo.setWeight(ezPMSDAO.getGroupWeight(map));
		String pretaskId = null;
		String pregroupId = null;
		
		if(groupInfo != null) {
			pretaskId = groupInfo.getPretask();
			pregroupId = groupInfo.getPregroup();
		}
		
		if(pretaskId != null || pregroupId != null) {
			
			String pretaskAncesterIds[] = groupInfo.getPretaskAncesterGroupIds().split(",");	
			
			String pretaskName = "";
			
			for(int i = 1; i < pretaskAncesterIds.length; i++) {
				map.put("groupId", pretaskAncesterIds[i]);
				pretaskName += ezPMSDAO.getGroupDetails(map).getGroupName() + " > ";
			}
			
			if(pretaskId != null) {
				map.put("taskId", pretaskId);	
				pretaskName += ezPMSDAO.getTaskDetails(map).getTaskName();
			} else {
				pretaskName = pretaskName.substring(0, pretaskName.lastIndexOf(">") - 1);
			}
			
			groupInfo.setPretaskName(pretaskName);
		}
		
		logger.debug("[SERVICE] getGroupDetails ended.");
		return groupInfo;
	}

	@Override
	public void updateGroup(ProjectGroupVO group, String lang) {
		logger.debug("[SERVICE] updateGroup started.");
		
		try {
			//총괄담당자 불러오기
			ProjectMemberVO headManager = getUserInfo(group.getHeadManagerId(), group.getTenantId(), "user");
			group.setHeadManagerName(headManager.getUserName());
			group.setHeadManagerName2(headManager.getUserName2());
			group.setHeadManagerDeptname(headManager.getUserDeptname());
			group.setHeadManagerDeptname2(headManager.getUserDeptname2());
			
			ezPMSDAO.updateGroupInfo(group);
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			
			//upperGroupId가 0일 경우 planStartDate와 planEndDate를 불러와 workingDay계산 후 저장
			//프로젝트 최상위 그룹
			if (group.getUpperGroupId() == 0) {
				Date startDate = sdf.parse(group.getPlanStartDate());
				Date endDate = sdf.parse(group.getPlanEndDate());
				
				int workingDay = getWorkingDays(startDate, endDate, "", group.getTenantId(), lang);
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("planStartDate", group.getPlanStartDate());
				map.put("planEndDate", group.getPlanEndDate());
				map.put("workingday", workingDay);
				map.put("groupId", group.getGroupId());
				map.put("tenantId", group.getTenantId());
				
				ezPMSDAO.updateGroupDate(map);
			} else {
				//그룹 멤버 삭제 후 추가
				deleteGroupMember(group.getProjectId(), group.getGroupId(), group.getTenantId());
				addGroupMember(group.getGroupMember());
			}
			
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		logger.debug("[SERVICE] updateGroup ended.");
	}

	@Override
	public void deleteGroup(long projectId, long groupId, int tenantId) {
		logger.debug("[SERVICE] deleteGroup started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("groupId", groupId);
		map.put("tenantId", tenantId);

		ezPMSDAO.deleteGroup(map);

		logger.debug("[SERVICE] deleteGroup ended.");
	}

	@Override
	public String getUserRole(String userId, Long projectId, int tenantId) {
		return null;
	}

	@Override
	public ProjectMainSettingVO getProjectMainSetting(String userId, int tenantId, String userIdType) {
		logger.debug("[SERVICE] getProjectMainSetting started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("userIdType", userIdType);

		ProjectMainSettingVO mainSetting = new ProjectMainSettingVO();

		logger.debug("[Parameter] userId : " + userId + ", tenantId : " + tenantId + ", userIdType : " + userIdType);
		try {
			mainSetting = ezPMSDAO.getProjectMainSetting(map);
		} catch (Exception e) {
			System.out.println("ERROR : " + e.getMessage());
		}

		logger.debug("listStatus : " + mainSetting.getListProjectStatus());
		logger.debug("[mainSetting] userMail : " + mainSetting.getUserMail());
		logger.debug("[SERVICE] getProjectMainSetting ended.");
		return mainSetting;
	}

	@Override
	public List<ProjectTaskTreeVO> getProjectTaskTree(Long projectId, String onlyGroup, String location, int tenantId,
			String userId) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("project_Id", projectId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("location", location);

		List<ProjectTaskTreeVO> list = ezPMSDAO.getProjectGroupTree(map);

		for (int i = 0; i < list.size(); i++) {
			ProjectTaskTreeVO vo = list.get(i);
			vo.setIcon("jstree-folder");

			if (vo.getParent().equals("0")) {
				vo.setParent("#");
			}

			map.put("taskId", vo.getTaskId());
			map.put("groupId", vo.getGroupId());
			map.put("projectId", projectId);

			int taskGroupCount = 0;

			if (location != null && !location.equals("")) {
				if (location.equals("taskLog")) {
					taskGroupCount = ezPMSDAO.getTaskLogListCount(map);
				} else if (location.equals("taskList")) {
					taskGroupCount = ezPMSDAO.getTaskListCount(map);
				} else if (location.equals("board")) {
					taskGroupCount = ezPMSDAO.getBoardListCount(map);
				} else if (location.equals("comment")) {
					taskGroupCount = ezPMSDAO.getCommentListCount(map);
				}
			}

			if (taskGroupCount != 0) {
				vo.setText(vo.getText() + " (" + taskGroupCount + ")");
			}
		}

		if (onlyGroup.equals("false")) {
			List<ProjectTaskTreeVO> list2 = ezPMSDAO.getProjectTaskTree(map);

			for (int i = 0; i < list2.size(); i++) {
				ProjectTaskTreeVO vo = list2.get(i);
				vo.setIcon("jstree-file");

				if (location != null && !location.equals("")) {

					if (location.equals("taskLog")) {
						map.put("taskId", vo.getTaskId());
						map.put("groupId", vo.getGroupId());
						map.put("projectId", projectId);

						int taskGroupCount = ezPMSDAO.getTaskLogListCount(map);

						if (taskGroupCount != 0) {
							vo.setText(vo.getText() + " (" + taskGroupCount + ")");
						}

						map.remove("taskId");
						map.remove("groupId");
						map.remove("projectId");
					} else if (location.equals("board")) {
						map.put("taskId", vo.getTaskId());
						map.put("groupId", vo.getGroupId());

						int taskGroupCount = ezPMSDAO.getBoardListCount(map);
						if (taskGroupCount > 0) {
							vo.setText(vo.getText() + " (" + taskGroupCount + ")");
						}

						map.remove("taskId");
						map.remove("groupId");
					} else if (location.equals("comment")) {
						map.put("taskId", vo.getTaskId());
						map.put("groupId", vo.getGroupId());

						int taskGroupCount = ezPMSDAO.getCommentListCount(map);
						if (taskGroupCount > 0) {
							vo.setText(vo.getText() + " (" + taskGroupCount + ")");
						}

						map.remove("taskId");
						map.remove("groupId");
					}
				}

				list.add(vo);
			}
		}
		
		return list;
	}

	@Override
	public List<ProjectUserVO> getDeptUserList(int tenantId, String key, String value, String lang) throws Exception {
		logger.debug("getDeptUserList started");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("key", key);
		param.put("value", value);
		param.put("lang", lang);
		List<ProjectUserVO> userList = ezPMSDAO.getDeptUserList(param);

		logger.debug("getDeptUserList ended");
		return userList;
	}

	@Override
	public List<ProjectCompanyVO> getCompanyList(String userId, int tenantId, String companyId, String lang)
			throws Exception {
		logger.debug("getCompanyList started");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		param.put("companyId", companyId);
		param.put("lang", lang);
		List<ProjectCompanyVO> compList = ezPMSDAO.getCompanyList(param);

		logger.debug("getCompanyList ended");
		return compList;
	}

	@Override
	public List<DeptViewVO> getDeptViewList(String userId, String companyId, int tenantId, String lang)
			throws Exception {
		logger.debug("getDeptViewList started");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		param.put("companyId", companyId);
		param.put("lang", lang);
		List<DeptViewVO> deptList = ezPMSDAO.getDeptViewVO(param);

		logger.debug("getDeptViewList ended");
		return deptList;
	}

	@Override
	public int getWorkingDays(Date start, Date end, String companyId, int tenantId, String lang) {
		logger.debug("[SERVICE]getWorkingDays started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("planStartDate", start);
		map.put("planEndDate", end);
		map.put("planStartDateShort",
				start.toString().substring(start.toString().indexOf("-") + 1));
		map.put("planEndDateShort",
				end.toString().substring(end.toString().indexOf("-") + 1));

		// Ignore argument check
		Calendar startCal = GregorianCalendar.getInstance();
		startCal.setTime(start);
		int startWeek = startCal.get(Calendar.DAY_OF_WEEK);
		startCal.add(Calendar.DAY_OF_WEEK, -startWeek + 1);

		Calendar endCal = GregorianCalendar.getInstance();
		endCal.setTime(end);
		int endWeek = endCal.get(Calendar.DAY_OF_WEEK);
		endCal.add(Calendar.DAY_OF_WEEK, -endWeek + 1);

		// end Saturday to start Saturday
		long days = (endCal.getTimeInMillis() - startCal.getTimeInMillis()) / (1000 * 60 * 60 * 24);
		long daysWithoutSunday = days - (days * 2 / 7);

		if (startWeek == Calendar.SUNDAY) {
			startWeek = Calendar.MONDAY;
		}
		if (endWeek == Calendar.SATURDAY) {
			endWeek = Calendar.FRIDAY;
		}

		int workingDays = (int) (daysWithoutSunday - startWeek + endWeek + 1);
		
		HashSet<String> solarHolidayMap = new HashSet<String>();
		HashSet<String> lunarHolidayMap = new HashSet<String>();
		int noRepeatHolidayCount = 0;
		
		//고정공휴일 & 사용자 정의 공휴일 불러오기
		map.put("lang", lang); //parameter추가
		
		if (lang.equals("3")) {
			map.put("country", "jap");
		} else {
			map.put("country", "kor");
		}
		
		List<ProjectHolidayVO> holidayList = ezPMSDAO.getCustomHoliday(map);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		for (ProjectHolidayVO vo : holidayList) {
			if (vo.getIsRepeat() == 1) {
				if (vo.getIsSolar() == 1) {
					String solarHoliday = vo.getHoliday();
					solarHolidayMap.add(solarHoliday);
				} else {
					String lunarHoliday = vo.getHoliday();
					lunarHolidayMap.add(lunarHoliday);
				}
			} else {
				Calendar cal = GregorianCalendar.getInstance();
				try {
					cal.setTime(sdf.parse(vo.getHoliday()));
				} catch (ParseException e) {
					logger.error(e.getMessage(), e);
				}
				
				if(cal.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY && cal.get(Calendar.DAY_OF_WEEK) != Calendar.SATURDAY) {
					noRepeatHolidayCount++;
				}
			}
		}
		
		//토요일 일요일이 포함이 안된 고정공휴일 & 사용자 정의 공휴일 개수 구하기
		int holidays = getWorkingDays2(start, end, solarHolidayMap, lunarHolidayMap).size();
		
		//고정공휴일과 사용자 정의 공휴일이 개수를  workindays에서 뺌
		workingDays = workingDays - holidays - noRepeatHolidayCount;
		
		logger.debug("WORKINGDAYS : " + workingDays);
		logger.debug("[SERVICE]getWorkingDays ended");
		return workingDays;
	}
	
	 public String getDateByString(Date date, String separator) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy"+separator+"MM"+separator+"dd");
		return sdf.format(date);
	 }
	 
	/**
	* 양력날짜를 음력날짜로 변환
	* @param 양력날짜 (yyyyMMdd)
	* @return 음력날짜 (yyyyMMdd)
	*/ 
	 public String converSolarToLunar(String date, String separator) {
		 ChineseCalendar chineseCalendar = new ChineseCalendar();
		 Calendar cal = Calendar.getInstance();
	 
		 cal.set(Calendar.YEAR, Integer.parseInt(date.substring(0, 4)));
		 cal.set(Calendar.MONTH, Integer.parseInt(date.substring(5, 7)) - 1);
		 cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(date.substring(8)));
	 
		 chineseCalendar.setTimeInMillis(cal.getTimeInMillis());
	 
		 int y = chineseCalendar.get(ChineseCalendar.EXTENDED_YEAR) - 2637;
		 int m = chineseCalendar.get(ChineseCalendar.MONTH) + 1;
		 int d = chineseCalendar.get(ChineseCalendar.DAY_OF_MONTH);
	 
		 StringBuffer ret = new StringBuffer();
		 ret.append(String.format("%04d", y)).append(separator);
		 ret.append(String.format("%02d", m)).append(separator);
		 ret.append(String.format("%02d", d));
	 
		 return ret.toString();
	 } // end converSolarToLunar
	 
	 public String getDay(String date, int amount) {
		 Calendar cal = Calendar.getInstance();
		 cal.set(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(5, 7)) - 1, Integer.parseInt(date.substring(8)));
		 cal.add(Calendar.DAY_OF_MONTH, amount);
	 
		 return getDateByString(cal.getTime(), "-");
	}
	 
	public HashSet<String> getWorkingDays2(Date startDate, Date endDate, HashSet<String> solarHolidayMap, HashSet<String> lunarHolidayMap) {
		HashSet<String> holidayList = new HashSet<String>();
		
		Calendar startCal = Calendar.getInstance();
		startCal.setTime(startDate);
		Calendar endCal = Calendar.getInstance();
		endCal.setTime(endDate);
		
		int startYear = startCal.get(Calendar.YEAR);
		int endYear = endCal.get(Calendar.YEAR);
		
		SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");

		String solarDate = "";
		String lunarDate = "";
		 
		for(int i = startYear; i <= endYear;) {
			solarDate = getDateByString(startCal.getTime(), "-");
			lunarDate = converSolarToLunar(solarDate, "-");
			startCal.add(Calendar.DAY_OF_MONTH, 1);
			 
			// 양력휴일 체크
			String solarMmdd = solarDate.substring(5);
			 	
			if(solarHolidayMap.contains(solarMmdd)) {
				try {
					Date date = fmt.parse(solarDate);
					Calendar cal = Calendar.getInstance();
					cal.setTime(date);
					
					if (cal.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY && cal.get(Calendar.DAY_OF_WEEK) != Calendar.SATURDAY) {
						holidayList.add(solarDate);
					}
				} catch (ParseException e) {
					logger.error(e.getMessage(), e);
				}
			}
	 
			// 음력휴일 체크
			String lunarMmdd = lunarDate.substring(5);
			 
			if(lunarHolidayMap.contains(lunarMmdd)) {
				// 음력 12월은 마지막날이 29일, 30일 계속 번갈아가면서 있으므로
				// 양력에서 하루를 빼준날이 구정시작하는 날짜이다.
				if(lunarMmdd.equals("01-01")) {
					String lunarDay = getDay(solarDate, -1);
					 	
					try {
						Date date = fmt.parse(lunarDay);
						Calendar cal = Calendar.getInstance();
						cal.setTime(date);
						
						if (cal.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY && cal.get(Calendar.DAY_OF_WEEK) != Calendar.SATURDAY) {
							holidayList.add(lunarDay);
						}
					} catch (ParseException e) {
						logger.error(e.getMessage(), e);
					}
				}
				 	
				try {
					Date date = fmt.parse(solarDate);
					Calendar cal = Calendar.getInstance();
					cal.setTime(date);
						
					if (cal.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY && cal.get(Calendar.DAY_OF_WEEK) != Calendar.SATURDAY) {
						holidayList.add(solarDate);
					}
				} catch (ParseException e) {
					logger.error(e.getMessage(), e);
				}
			}
	 
			startYear = startCal.get(Calendar.YEAR);
			 	
			if (startYear != i) {
				i++;
			}

			if (startCal.getTimeInMillis() > endCal.getTimeInMillis()) {
				break;
			}
		} // end for_i
		
		return holidayList;
	}
	// 유저 정보 불러오기
	@Override
	public ProjectMemberVO getUserInfo(String userId, int tenantId, String userIdType) throws Exception {
		logger.debug("Service getUserInfo Started");
		ProjectMemberVO userInfo = new ProjectMemberVO();

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		param.put("userIdType", userIdType);

		userInfo = ezPMSDAO.getUserInfo(param);

		logger.debug("Service getUserInfo Ended");
		return userInfo;
	}

	// 유저의 프로젝트 role 확인
	@Override
	public int getUserProjectRole(String userId, int tenantId, Long projectId, String deptId) {
		logger.debug("[SERVICE] getUserProjectRole started");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		param.put("projectId", projectId);
		param.put("deptId", deptId);

		int projectRole = ezPMSDAO.getUserProjectRole(param);
		logger.debug("[SERVICE] getUserProjectRole ended");
		return projectRole;
	}

	@Override
	public List<ProjectMemberVO> getProjectMember(Long projectId, int roleId, String lang) {
		return null;
	}

	@Override
	public void addProjectMember(ProjectMemberVO projectMemberList, int tenantId) {
		logger.debug("[SERVICE] ezPMS addProjectMember Started");
		HashMap<String, Object> map = new HashMap<String, Object>();

		try {
			map.put("userId", projectMemberList.getUserId());
			map.put("userName", projectMemberList.getUserName());
			map.put("userName2", projectMemberList.getUserName2());
			map.put("userDeptname", projectMemberList.getUserDeptname());
			map.put("userDeptname2", projectMemberList.getUserDeptname2());
			map.put("userPosition", projectMemberList.getUserPosition());
			map.put("userPosition2", projectMemberList.getUserPosition2());
			map.put("memberRoleId", projectMemberList.getMemberRoleId());
			map.put("userIdType", projectMemberList.getUserIdType());
			map.put("projectId", projectMemberList.getProjectId());
			map.put("tenantId", tenantId);

			ezPMSDAO.addProjectMember(map);

		} catch (Exception e) {
			logger.debug("ERROR : " + e.getMessage());
		}

		logger.debug("[SERVICE] ezPMS addProjectMember Ended");
	}

	@Override
	public Map<String, Object> getRemainingWeight(String projectId, int tenantId) {
		logger.debug("[SERVICE] ezPMS getRemainingWeight Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);

		logger.debug("[SERVICE] ezPMS getRemainingWeight Ended");
		return ezPMSDAO.getRemainingWeight(map);
	}

	@Override
	public List<TaskMemberVO> getTaskMemberList(int tenantId, long taskId, String lang) {
		logger.debug("[SERVICE] ezPMS getTaskMemberList Started");
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("taskId", taskId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);

		List<TaskMemberVO> taskMemberList = ezPMSDAO.getTaskMemberList(map);
		logger.debug("[SERVICE] ezPMS getTaskMemberList Ended");
		return taskMemberList;
	}
	
	@Override
	public List<TaskMemberVO> getTaskMemberListForGantt(int tenantId, long projectId, String lang) {
		logger.debug("[SERVICE] ezPMS getTaskMemberListForGantt Started");
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		
		List<TaskMemberVO> taskMemberList = ezPMSDAO.getTaskMemberListForGantt(map);
		logger.debug("[SERVICE] ezPMS getTaskMemberListForGantt Ended");
		return taskMemberList;
	}

	@Override
	public void deleteProjectMember(Long projectId, int tenantId) {
		logger.debug("[SERVICE] deleteProjectMember Started");
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);

		ezPMSDAO.deleteProjectMember(map);

		logger.debug("[SERVICE] deleteProjectMember Ended");
	}

	@Override
	public void updateProjectRealDate(Long projectId, int tenantId, String changeDate, String status,
			String planEndDate, String companyId, String lang) {
		logger.debug("[SERVICE] updateProjectRealDate Started");
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("changeDate", changeDate);
		map.put("status", status);
		map.put("progress", 100);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			Date endDate = sdf.parse(planEndDate);
			Date today = new Date();
			String simpToday = sdf.format(today);
			Date now = sdf.parse(simpToday);
			int restDueday = getWorkingDays(now, endDate, companyId, tenantId, lang);

			map.put("restDueday", restDueday);
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		}
		
		map.put("lang", lang);
		
		ProjectInfoVO projectInfo = ezPMSDAO.getProjectDetails(map);
		String realStartDate = projectInfo.getRealStartDate();
		Long projectGroupId = projectInfo.getGroupId();
		
		if((status.equals("P") && realStartDate == null)) {
			ezPMSDAO.updateProjectRealDate(map);
			
			map.put("realStartDate", changeDate);
			map.put("groupId", projectGroupId);
			ezPMSDAO.updateGroupRealDate(map);
		} else if(status.equals("C")) {
			ezPMSDAO.updateProjectRealDate(map);
			
			map.put("realStartDate", realStartDate);
			map.put("realEndDate", changeDate);
			map.put("groupId", projectGroupId);
			ezPMSDAO.updateGroupRealDate(map);
		}
		
		logger.debug("[SERVICE] updateProjectRealDate Ended");
	}

	@Override
	public void completeAllTasks(long projectId, int tenantId, String realEndDate, String planEndDate,
			String companyId, String lang) {
		logger.debug("[SERVICE] completeAllTasks Started");
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("realEndDate", realEndDate);
		map.put("status", "C");
		map.put("progress", 100);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			Date endDate = sdf.parse(planEndDate);
			Date today = new Date();
			String simpToday = sdf.format(today);
			Date now = sdf.parse(simpToday);
			int restDueday = getWorkingDays(now, endDate, companyId, tenantId, lang);

			map.put("restDueday", restDueday);
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		}

		ezPMSDAO.completeAllTasks(map);
		logger.debug("[SERVICE] completeAllTasks Ended");
	}

	@Override
	@Transactional
	public void addBoard(JSONObject jsonParam, String realPath) throws Exception {
		logger.debug("[SERVICE] addBoard started");

		int tenantId = (int) jsonParam.get("tenantId");
		int projectId = Integer.parseInt((String) jsonParam.get("projectId"));
		int lastInsertId;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("projectId", projectId);
		map.put("folderId", jsonParam.get("folderId"));

		int docNo = ezPMSDAO.getMaxDocNo(map) + 1;

		String mode = (String) jsonParam.get("mode");

		ProjectBoardVO vo = new ProjectBoardVO();
		vo.setTenantId(tenantId);
		vo.setWriterId((String) jsonParam.get("writerId"));
		vo.setWriteDate((String) jsonParam.get("writeDate"));
		vo.setWriterName((String) jsonParam.get("writerName"));
		vo.setWriterName2((String) jsonParam.get("writerName2"));
		vo.setWriterDeptName((String) jsonParam.get("writerDeptname"));
		vo.setWriterDeptName2((String) jsonParam.get("writerDeptname2"));
		vo.setTitle((String) jsonParam.get("title"));
		vo.setWriteContent((String) jsonParam.get("writeContent"));
		vo.setWriteType((int) jsonParam.get("writeType"));
		vo.setReadCount(0);
		vo.setFolderId(Long.parseLong(jsonParam.get("folderId").toString()));
		vo.setWriterPosition((String) jsonParam.get("writerPosition"));
		vo.setWriterPosition2((String) jsonParam.get("writerPosition2"));
		vo.setWriteOverview((String) jsonParam.get("writeOverview"));
		vo.setDocNo(docNo);

		if (mode.equals("reply")) {
			vo.setRootItemId(Integer.parseInt((String)jsonParam.get("rootItemId")));
			vo.setUpperItemId(Integer.parseInt((String)jsonParam.get("itemId")));
			// 답변을 쓰는 글의 level보다 1이 증가
			vo.setItemLevel(Integer.parseInt((String) jsonParam.get("itemLevel")) + 1);
			
			map.put("itemId", jsonParam.get("itemId"));
			ProjectBoardVO upperItem = ezPMSDAO.getBoardDetail(map);
			//답변의 경우 최근에 답변 달은 것이 최상위로 와야함(by design)
			vo.setUpperDocNoTree(upperItem.getUpperDocNoTree() + getReverseDateNow() + "{" + docNo + "}");
			
			lastInsertId = ezPMSDAO.addBoardReplay(vo);
		} else {
			vo.setRootItemId(docNo);
			vo.setUpperDocNoTree("{" + docNo + "}");
			// 게시물의 id가 rootId가 됨
			lastInsertId = ezPMSDAO.addBoard(vo);
			//ezPMSDAO.updateRootItemId(docNo);
		}

		String fileList = jsonParam.get("fileList").toString();

		// 첨부파일 저장
		Map<String, Object> attachMap = new HashMap<String, Object>();
		String pDirPath = "";

		if (fileList != null && !fileList.equals("")) {

			pDirPath = commonUtil.getUploadPath("upload_project.ROOT", tenantId);
			pDirPath = realPath + pDirPath;

			if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
				pDirPath = pDirPath + commonUtil.separator;
			}

			File file = new File(pDirPath + "uploadFile" + commonUtil.separator + projectId + "_uploadFile");

			if (!file.exists()) {
				file.mkdirs();
			}

			String[] attach = fileList.split("/");

			attachMap.put("tenantId", tenantId);

			for (int i = 0; i < attach.length; i++) {
				String[] files = attach[i].split(":");
				String filePath = files[0];
				String fileName = files[1];
				String fileSize = files[2];
				String extension = fileName.substring(fileName.lastIndexOf(".") + 1);

				logger.debug("filePath : " + filePath + " | fileName : " + fileName + " | fileSize : " + fileSize);

				String uploadFilePath = commonUtil.separator + projectId + "_uploadFile" + commonUtil.separator
						+ filePath + "." + extension;
				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + "." + extension;
				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + projectId + "_uploadFile"
						+ commonUtil.separator + filePath + "." + extension;

				attachMap.put("last_insert_id", lastInsertId);
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFilePath);

				ezPMSDAO.insertProjectAttach(attachMap);

				fileMove(beforeFilePath, afterFilePath); // Temp 폴더에서 첨부파일 이동
			}
		}
		logger.debug("[SERVICE] addBoard ended");
	}

	@SuppressWarnings("unchecked")
	@Override
	public void modifyBoard(JSONObject jsonParam, String realPath) throws Exception {
		logger.debug("[SERVICE] modifyBoard started");

		int tenantId = (int) jsonParam.get("tenantId");
		int projectId = Integer.parseInt((String) jsonParam.get("projectId"));
		int itemId = Integer.parseInt((String) jsonParam.get("itemId"));

		Map<String, Object> map = new HashMap<String, Object>();

		Iterator<String> keysItr = jsonParam.keySet().iterator();
		
		String keyStr = "";
		
		while (keysItr.hasNext()) {
			String key = keysItr.next();
			Object value = jsonParam.get(key);
			keyStr += key + ", ";
			map.put(key, value);
		}
		
		logger.debug("Parameters : " + keyStr);

		ezPMSDAO.updateBoard(map);

		// 첨부파일 전부 삭제 후 다시 저장
		ezPMSDAO.deleteProjectAttach(map);

		String fileList = jsonParam.get("fileList").toString();

		Map<String, Object> attachMap = new HashMap<String, Object>();
		String pDirPath = "";

		if (fileList != null && !fileList.equals("")) {

			pDirPath = commonUtil.getUploadPath("upload_project.ROOT", tenantId);
			pDirPath = realPath + pDirPath;

			if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
				pDirPath = pDirPath + commonUtil.separator;
			}

			File file = new File(pDirPath + "uploadFile" + commonUtil.separator + projectId + "_uploadFile");

			if (!file.exists()) {
				file.mkdirs();
			}

			String[] attach = fileList.split("/");

			attachMap.put("tenantId", tenantId);

			for (int i = 0; i < attach.length; i++) {
				String[] files = attach[i].split(":");
				String filePath = files[0];
				String fileName = files[1];
				String fileSize = files[2];
				String extension = fileName.substring(fileName.lastIndexOf(".") + 1);

				logger.debug("filePath : " + filePath + " | fileName : " + fileName + " | fileSize : " + fileSize);

				String uploadFilePath = commonUtil.separator + projectId + "_uploadFile" + commonUtil.separator
						+ filePath + "." + extension;
				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + "." + extension;
				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + projectId + "_uploadFile"
						+ commonUtil.separator + filePath + "." + extension;

				attachMap.put("last_insert_id", itemId);
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFilePath);

				ezPMSDAO.insertProjectAttach(attachMap);

				fileMove(beforeFilePath, afterFilePath); // Temp 폴더에서 첨부파일 이동
			}
		}

		logger.debug("[SERVICE] modifyBoard ended");
	}

	@Transactional
	@SuppressWarnings("unchecked")
	@Override
	public void moveBoard(JSONObject jsonParam) throws Exception {
		logger.debug("[SERVICE] moveBoard started");

		List<String> itemIds = (ArrayList<String>) jsonParam.get("itemIds");
		
		// 중복 제거
		Set<String> itemIdsSet = new HashSet<String>(itemIds);
		itemIds = new ArrayList<String>(itemIdsSet);
		
		String userId = (String) jsonParam.get("userId");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", jsonParam.get("folderId"));
		
		Iterator<String> keysItr = jsonParam.keySet().iterator();

		while (keysItr.hasNext()) {
			String key = keysItr.next();
			Object value = jsonParam.get(key);
			// logger.debug("parameter = [ key : " + key + ", value : " + value + "]");
			map.put(key, value);
		}

		int authority = ezPMSDAO.getUserProjectRole(map);

		int docNo = ezPMSDAO.getMaxDocNo(map) + 1;
		map.put("docNo", docNo);
		map.put("rootItemId", docNo);
		map.put("upperDocNoTree", "{" + docNo + "}");
		
		for (String itemId : itemIds) {
			map.put("itemId", itemId);
			ProjectBoardVO boardVO = ezPMSDAO.getBoardDetail(map);

			if (boardVO.getWriterId().equals(userId) || authority == 1) {
				
				if(boardVO.getItemLevel() > 0) {
					ezPMSDAO.updateBoardReplyToGeneral(map);
				}
				
				ezPMSDAO.moveBoard(map);
			} else {
				Exception e = new Exception("Only project Manager and Writer are authorized to modify article");
				throw e;
			}
		}
		logger.debug("[SERVICE] moveBoard ended");
	}

	@SuppressWarnings("unchecked")
	@Transactional
	@Override
	public void deleteBoard(int tenantId, JSONObject jsonParam) throws Exception {
		logger.debug("[SERVICE] deleteBoard started");

		List<String> itemIds = (ArrayList<String>) jsonParam.get("itemIds");
		
		// 중복 제거
		Set<String> itemIdsSet = new HashSet<String>(itemIds);
		itemIds = new ArrayList<String>(itemIdsSet);
		
		String userId = (String) jsonParam.get("userId");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("projectId", jsonParam.get("projectId"));
		map.put("userId", userId);
		map.put("deptId", jsonParam.get("deptId"));

		int authority = ezPMSDAO.getUserProjectRole(map);

		for (String itemId : itemIds) {
			map.put("itemId", itemId);
			ProjectBoardVO boardVO = ezPMSDAO.getBoardDetail(map);

			if (boardVO.getWriterId().equals(userId) || authority == 1) {
				ezPMSDAO.deleteBoard(map);
			} else {
				Exception e = new Exception("Only project Manager and Writer are authorized to delete article");
				throw e;
			}
		}
		logger.debug("[SERVICE] deleteBoard ended");
	}

	@Override
	public List<ProjectBoardVO> getBoardList(int tenantId, Long projectId, Long folderId, String userId,
			int startRow, int listCnt, String lang, String position, String orderWhat, String orderHow,
			String searchByTaskName, String searchByUser, String searchByStartDate, String searchByEndDate,
			String searchByTitle, String searchByOverview, String searchByContent) {
		logger.debug("[SERVICE] getBoardList Started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("projectId", projectId);
		map.put("folderId", folderId);
		map.put("startRow", startRow);
		map.put("listCnt", listCnt);
		map.put("lang", lang);
		map.put("position", position);
		map.put("orderHow", orderHow);

		map.put("searchByTaskName", searchByTaskName);
		map.put("searchByUser", searchByUser);
		map.put("searchByStartDate", searchByStartDate);
		map.put("searchByEndDate", searchByEndDate);
		map.put("searchByTitle", searchByTitle);
		map.put("searchByOverview", searchByOverview);
		map.put("searchByContent", searchByContent);

		if (orderWhat != null) {
			if (orderWhat.equals("ITEM_ID")) {
				orderWhat = "B.item_id";
			} else if (orderWhat.equals("FILE")) {
				orderWhat = "file_cnt";
			} else if (orderWhat.equals("TITLE")) {
				orderWhat = "B.title";
			} else if (orderWhat.equals("TASK_NAME")) {
				orderWhat = "T.task_name";
			} else if (orderWhat.equals("DEPT_NAME")) {
				orderWhat = "writer_deptname";
			} else if (orderWhat.equals("WRITER_NAME")) {
				orderWhat = "writer_name";
			} else if (orderWhat.equals("WRITE_DATE")) {
				orderWhat = "B.write_date";
			} else if (orderWhat.equals("READ_COUNT")) {
				orderWhat = "B.read_count";
			}
		}

		map.put("orderWhat", orderWhat);

		List<ProjectBoardVO> boardList = ezPMSDAO.getBoardList(map);
		
		for (ProjectBoardVO boardVO : boardList) {
					
			map = new HashMap<String, Object>();
			map.put("userId", userId);
			map.put("itemId", boardVO.getItemId());

			if (ezPMSDAO.checkReadBoardOrNot(map) != -1) {
				boardVO.setReadOrNot(true);
			}
		}

		logger.debug("[SERVICE] getBoardList Ended");
		return boardList;
	}

	@Override
	public int getBoardListCount(int tenantId, Long projectId, Long folderId, String searchByTaskName,
			String searchByUser, String searchByStartDate, String searchByEndDate, String searchByTitle,
			String searchByOverview, String searchByContent) {
		logger.debug("[SERVICE] getBoardListCount Started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("projectId", projectId);
		map.put("folderId", folderId);

		map.put("searchByTaskName", searchByTaskName);
		map.put("searchByUser", searchByUser);
		map.put("searchByStartDate", searchByStartDate);
		map.put("searchByEndDate", searchByEndDate);
		map.put("searchByTitle", searchByTitle);
		map.put("searchByOverview", searchByOverview);
		map.put("searchByContent", searchByContent);

		logger.debug("[SERVICE] getBoardListCount Ended");
		return ezPMSDAO.getBoardListCount(map);
	}

	
	@Override
	public List<ProjectBoardVO> getBoardNoticeList(int tenantId, Long projectId, Long folderId, int startRow, int listCnt, String lang) {
		logger.debug("[SERVICE] getBoardNoticeList Started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("projectId", projectId);
		map.put("folderId", folderId);
		map.put("startRow", startRow);
		map.put("listCnt", listCnt);
		map.put("lang", lang);
		logger.debug("[SERVICE] getBoardNoticeList Ended");
		return ezPMSDAO.getBoardNoticeList(map);
	}

	@Override
	public int getBoardNoticeListCount(int tenantId, Long projectId, Long folderId) {
		logger.debug("[SERVICE] getBoardNoticeListCount Started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("projectId", projectId);
		map.put("folderId", folderId);
		
		logger.debug("[SERVICE] getBoardNoticeListCount Ended");
		return ezPMSDAO.getBoardNoticeListCount(map);
	}

	@Transactional
	@Override
	public ProjectBoardVO getBoardDetail(int tenantId, Map<String, Object> map) {
		logger.debug("[SERVICE] getBoardDetail started");

		map.put("tenantId", tenantId);
		ProjectBoardVO boardVO = ezPMSDAO.getBoardDetail(map);

		if (ezPMSDAO.checkReadBoardOrNot(map) == -1) {
			ezPMSDAO.insertReadBoardLog(map);

			if (!boardVO.getWriterId().equals(map.get("userId"))) {
				ezPMSDAO.updateBoardReadCount((int) map.get("itemId"));
			}
		}

		boardVO.setFileList(ezPMSDAO.getBoardAttach(map));

		logger.debug("[SERVICE] getBoardDetail ended");
		return boardVO;
	}

	@Override
	public List<ProjectInfoVO> getProgressProject(String status, String mode) throws Exception {
		logger.debug("getProgressProject Started");
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("status", "P");
		map.put("lang", ""); // 수정 필요'
		map.put("mode", mode);
		
		List<ProjectInfoVO> projectList = ezPMSDAO.getProgressProject(map);

		logger.debug("getProgressProject Ended");
		return projectList;
	}

	// 파일 이동 함수
	private void fileMove(String beforeFilePath, String afterFilePath) {
		logger.debug("fileMove started.");
		logger.debug("beforeFilePath = " + beforeFilePath + " || afterFilePath = " + afterFilePath);

		File srcFile = new File(beforeFilePath);
		File destFile = new File(afterFilePath);

		try {
			boolean rename = srcFile.renameTo(destFile);
			if (!rename) {
				FileUtils.copyFile(srcFile, destFile);

				if (!srcFile.delete()) {
					FileUtils.deleteQuietly(destFile);
					throw new IOException(
							"Failed to delete original file '" + srcFile + "' after copy to '" + destFile + "'");
				}
			}
		} catch (FileNotFoundException e) {
			// 수정 시, 이미 업로드되어있는 파일들은 upload폴더에 옮겨져있기 때문에 tempUpload폴더에서 찾을 수 없다.
			// 따라서 Exception 발생하지만 문제되지 않음
			logger.debug("e.message=" + e.getMessage());
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("fileMove ended.");
	}

	public String getUserTaskRole(String userId, int tenantId, long taskId) {
		logger.debug("[SERVICE] getUserTaskRole started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("taskId", taskId);

		String userTaskRole = ezPMSDAO.getUserTaskRole(map);

		logger.debug("[SERVICE] getUserTaskRole ended");
		return userTaskRole;
	}

	@Override
	public List<Map<String, Object>> getFilePath(long itemId, int tenantId) {
		logger.debug("[SERVICE] getFilePath started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("itemId", itemId);

		List<Map<String, Object>> fileList = ezPMSDAO.getFilePath(map);
		logger.debug("[SERVICE] getFilePath ended");

		return fileList;
	}

	public void updateTaskInfo(ProjectTaskVO task, String companyId, int tenantId, String lang) {
		logger.debug("[SERVICE] updateTaskInfo started.");
		Long taskId = (long) 0;

		try {
			List<TaskMemberVO> taskMemberList = task.getTaskMember();
			taskId = task.getTaskId();

			String projectId = task.getProjectId() + "";

			// 투입률 총합
			float sumPctinput = 0;

			task.setRealProgress((float) 0);
			task.setMemberCount(taskMemberList.size());

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			
			// workingday 계산
			Date startDate = sdf.parse(task.getPlanStartDate());
			Date endDate = sdf.parse(task.getPlanEndDate());

			int calWorkingDays = getWorkingDays(startDate, endDate, companyId, tenantId, lang);

			/* 업무 정보 수정 시에는 상태를 수정하지 않음
			int createAndEndDateComp = createDate.compareTo(endDate);

			if (createAndEndDateComp > 0) {
				task.setStatus("L");
			} else {
				task.setStatus("W");
			}*/

			// 업무 총괄담당자 정보 불러오기
			ProjectMemberVO headManagerInfo = getUserInfo(task.getHeadManagerId(), task.getTenantId(), "user");
			task.setHeadManagerName(headManagerInfo.getUserName());
			task.setHeadManagerName2(headManagerInfo.getUserName2());
			task.setHeadManagerDeptname(headManagerInfo.getUserDeptname());
			task.setHeadManagerDeptname2(headManagerInfo.getUserDeptname2());

			ezPMSDAO.updateTaskInfo(task);
			deleteTaskMember(taskId, task.getTenantId());

			for (int i = 0; i < taskMemberList.size(); i++) {
				TaskMemberVO taskMemberVO = taskMemberList.get(i);
				taskMemberList.get(i).setTaskId(taskId);
				sumPctinput += taskMemberVO.getPctinput();
			}
			ezPMSDAO.addTaskMember(taskMemberList);

			float taskWorkingday = calWorkingDays * (sumPctinput / 100);

			HashMap<String, Object> map1 = new HashMap<String, Object>();
			map1.put("projectId", projectId);
			map1.put("workingday", taskWorkingday);
			map1.put("tenantId", tenantId);
			map1.put("realWorkingday", calWorkingDays);
			

			//업무수정하면서 워킹데이합계 재계산
			ezPMSDAO.updateProjectWorkingdaySum2(map1);
			
			// 가중치 계산
			updateTaskWDNW(task, taskWorkingday);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("[SERVICE] updateTaskInfo ended.");
	}

	@Override
	public void deleteTaskMember(Long taskId, int tenantId) {
		logger.debug("[SERVICE] deleteTaskMember Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskId", taskId);
		map.put("tenantId", tenantId);

		ezPMSDAO.deleteTaskMember(map);

		logger.debug("[SERVICE] deleteTaskMember Ended");

	}

	@Override
	public int getGroupCount(SearchVO search, int tenantId, String userId) {
		logger.debug("[SERVICE] getGroupCount Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		// 검색
		map.put("searchByGroupName", search.getGroupName());
		map.put("searchByUpperGroupName", search.getUpperGroupName());
		map.put("searchByUser", search.getMemberName());
		map.put("searchByProjectName", search.getProjectName());
		map.put("searchByOverview", search.getOverview());
		map.put("searchByStartDate", search.getPlanStartDate());
		map.put("searchByEndDate", search.getPlanEndDate());

		int groupCount = ezPMSDAO.getGroupCount(map);

		logger.debug("[SERVICE] getGroupCount Ended");
		return groupCount;
	}

	public void updateTaskStatus(ProjectTaskVO task, String companyId, int tenantId, String lang) {
		logger.debug("[SERVICE] updateTaskStatus started.");
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", task.getProjectId());
		map.put("tenantId", tenantId);
		map.put("taskId", task.getTaskId());

		ProjectTaskVO taskVO = ezPMSDAO.getTaskDetails(map);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			// 날짜 차이 계산
			Date startDate = sdf.parse(task.getPlanStartDate());
			Date endDate = sdf.parse(task.getPlanEndDate());

			int calWorkingDays = getWorkingDays(startDate, endDate, companyId, tenantId, lang);
			task.setRealWorkingday(calWorkingDays);

			if (task.getStatus() != null) {
				if (task.getStatus().equals("P")) {
					Date createDate = sdf.parse(task.getRealStartDate());
					int createAndEndDateComp = createDate.compareTo(endDate);

					if (createAndEndDateComp > 0) {
						task.setStatus("L");
					} else {
						task.setStatus("P");
					}
				}
			}

			ezPMSDAO.updateTaskStatus(task);
			
			// 프로젝트 직속 업무가 아니라면 업무가 속한 모든 조상그룹의 일정을 업데이트 해준다.
			if (!task.getGroupId().equals(0L)) {
				String ancesterGroup = getAncesterGroup(task.getGroupId(), task.getTenantId());
				String[] ancGroupArr = ancesterGroup.split(",");

				for (int i = 0; i < ancGroupArr.length; i++) {
					updateGroupDate(Long.parseLong(ancGroupArr[i]), task.getTenantId(), companyId, lang);
				}
			}
			
			// 프로젝트 직속 업무가 아니라면 업무가 속한 모든 조상그룹의 진행률을 업데이트 해준다.
			HashMap<String, Object> map1 = new HashMap<String, Object>();
			map1.put("projectId", task.getProjectId());
			map1.put("workingday", calWorkingDays);
			map1.put("realWorkingday", calWorkingDays);
			map1.put("tenantId", tenantId);
			
			if (!task.getGroupId().equals(0L)) {
				String ancesterGroup = getAncesterGroup(task.getGroupId(), task.getTenantId());
				String[] ancGroupArr = ancesterGroup.split(",");

				for (int i = 0; i < ancGroupArr.length; i++) {
					map1.put("groupId", ancGroupArr[i]);
					ezPMSDAO.updateGroupProgress(map1);
				}
			}
			
			map1.replace("realWorkingday", taskVO.getRealWorkingday() - calWorkingDays);
			//업무수정하면서 워킹데이합계 재계산
			ezPMSDAO.updateProjectWorkingdaySum2(map1);
			// 가중치 계산
			updateTaskWDNW(task, calWorkingDays);
			
			// 업무가 속한 프로젝트의 진행률을 업데이트 해준다.
			ezPMSDAO.updateProjectProgress(task);

			// 업데이트 후 프로젝트 진행률을 조회
			ProjectInfoVO projectDetails = ezPMSDAO.getProjectDetails(map1);

			// 프로젝트 진행률이 100이상인데 업무가 추가 되었으면, 진행으로 상태를 바꾼다.
			if (Math.round(projectDetails.getProgress() * 100) / 100.0d >= 100) {
				map1.put("status", "P");
				ezPMSDAO.updateProjectStatus(map1);
			}

			// 업무가 속한 프로젝트 날짜 업데이트
			// updateProjectDate(task.getProjectId(), task.getTenantId(),
			// companyId);
		} catch (Exception e) {
			logger.debug("ERROR : " + e.getMessage());
		}

		logger.debug("[SERVICE] updateTaskStatus ended.");
	}

	@Override
	public void addGroupMember(List<ProjectGroupMemberVO> groupMember) {
		logger.debug("[SERVICE] addGroupMember started.");

		ezPMSDAO.addTaskGroupMember(groupMember);

		logger.debug("[SERVICE] addGroupMember ended.");
	}

	@Override
	public List<ProjectGroupMemberVO> getUserInfoForGroup(HashMap<String, Object> map) {
		return ezPMSDAO.getUserInfoForGroup(map);
	}

	@Override
	public int getUserGroupRole(String userId, int tenantId, long projectId, long groupId) {
		logger.debug("[SERVICE] getUserGroupRole started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("projectId", projectId);
		map.put("groupId", groupId);

		int userGroupRole = ezPMSDAO.getUserGroupRole(map);

		logger.debug("[SERVICE] getUserGroupRole ended.");
		return userGroupRole;
	}

	@Override
	public int getBoardViewerCount(int tenantId, String itemId, long projectId) {
		logger.debug("[SERVICE] getBoardViewerCount started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("itemId", itemId);
		map.put("projectId", projectId);
		
		ProjectBoardVO boardVO = ezPMSDAO.getBoardDetail(map);
		map.put("writerId", boardVO.getWriterId());
		logger.debug("[SERVICE] getBoardViewerCount ended.");

		return ezPMSDAO.getBoardViewerCount(map);
	}

	@Override
	public List<BoardViewerVO> getBoardViewerList(int tenantId, Map<String, Object> param) {
		logger.debug("[SERVICE] getBoardViewerList started.");

		param.put("tenantId", tenantId);
		
		ProjectBoardVO boardVO = ezPMSDAO.getBoardDetail(param);
		param.put("writerId", boardVO.getWriterId());
		logger.debug("[SERVICE] getBoardViewerList ended.");

		return ezPMSDAO.getBoardViewerList(param);
	}

	@Override
	public void addPreTaskRel(long taskId, int pretaskId, long projectId, int tenantId, String type) {
		logger.debug("[SERVICE] addPreTaskRel started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskId", taskId);
		map.put("pretaskId", pretaskId);
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("type", type);

		ezPMSDAO.addPreTaskRel(map);
		logger.debug("[SERVICE] addPreTaskRel ended.");
	}

	@Override
	public List<Long> getPreTaskRel(int rowIndex, int tenantId, long projectId) {
		logger.debug("[SERVICE] getPreTaskRel started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rowIndex", rowIndex);
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);

		List<Long> postTaskList = ezPMSDAO.getPreTaskRel(map);
		logger.debug("[SERVICE] getPreTaskRel ended.");
		return postTaskList;
	}

	@Override
	public List<CommentVO> getCommentList(Map<String, Object> param) {
		logger.debug("[SERVICE] getCommentList started.");

		logger.debug("[SERVICE] getCommentList ended.");
		return ezPMSDAO.getCommentList(param);
	}

	@Override
	public int getCommentListCount(Map<String, Object> param) {
		logger.debug("[SERVICE] getCommentListCount started.");

		logger.debug("[SERVICE] getCommentListCount ended.");
		return ezPMSDAO.getCommentListCount(param);
	}

	@Override
	public void addComment(JSONObject jsonParam) {
		logger.debug("[SERVICE] addComment started.");

		CommentVO vo = new CommentVO();

		if (jsonParam.get("taskId") != null && !((String) jsonParam.get("taskId")).equals("")) {
			vo.setTaskId(Long.parseLong((String) jsonParam.get("taskId")));
		}

		vo.setTenantId((int) jsonParam.get("tenantId"));
		vo.setGroupId(Long.parseLong((String) jsonParam.get("groupId")));
		vo.setUpdateDate((String) jsonParam.get("updateDate"));
		vo.setCommentContent((String) jsonParam.get("commentContent"));
		vo.setWriterId((String) jsonParam.get("writerId"));
		vo.setWriteDate((String) jsonParam.get("writeDate"));
		vo.setWriterName((String) jsonParam.get("writerName"));
		vo.setWriterName2((String) jsonParam.get("writerName2"));
		vo.setWriterDeptName((String) jsonParam.get("writerDeptName"));
		vo.setWriterDeptName2((String) jsonParam.get("writerDeptName2"));

		ezPMSDAO.addComment(vo);

		logger.debug("[SERVICE] addComment ended.");
	}

	@Override
	public void deleteComment(int tenantId, JSONObject jsonParam) throws Exception {
		logger.debug("[SERVICE] deleteComment started");

		String userId = (String) jsonParam.get("userId");
		String writerId = (String) jsonParam.get("writerId");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("projectId", jsonParam.get("projectId"));
		map.put("userId", userId);
		map.put("deptId", jsonParam.get("deptId"));

		int authority = ezPMSDAO.getUserProjectRole(map);

		map.put("commentId", jsonParam.get("commentId"));

		if (writerId.equals(userId) || authority == 1) {
			ezPMSDAO.deleteComment(map);
		} else {
			Exception e = new Exception("Only project Manager and Writer are authorized to delete article");
			throw e;
		}

		logger.debug("[SERVICE] deleteComment ended");
	}

	@Override
	public void modifyComment(JSONObject jsonParam) throws Exception {
		logger.debug("[SERVICE] modifyComment started");

		String userId = (String) jsonParam.get("userId");
		String writerId = (String) jsonParam.get("writerId");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", jsonParam.get("tenantId"));
		map.put("projectId", jsonParam.get("projectId"));
		map.put("userId", userId);
		map.put("deptId", jsonParam.get("deptId"));

		int authority = ezPMSDAO.getUserProjectRole(map);

		map.put("commentId", jsonParam.get("commentId"));
		map.put("commentContent", jsonParam.get("commentContent"));
		
		logger.debug("userId : " + userId + ", writerId : " + writerId);
		
		if (writerId.equals(userId) || authority == 1) {
			ezPMSDAO.updateComment(map);
		} else {
			Exception e = new Exception("Only project Manager and Writer are authorized to modify article");
			throw e;
		}

		logger.debug("[SERVICE] modifyComment ended");
	}

	@Override
	public List<ProjectGroupMemberVO> getGroupMemberList(Long projectId, int tenantId, Long groupId) {
		logger.debug("[SERVICE] getGroupMemberList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("groupId", groupId);

		logger.debug("[SERVICE] getGroupMemberList ended.");
		return ezPMSDAO.getGroupMemberList(map);
	}

	@Override
	public void updateTaskWDNW(ProjectTaskVO taskVO, float taskWorkingday) {
		
		HashMap<String, Object> map2 = new HashMap<String, Object>();
		// 가중치 계산
		String projectId = taskVO.getProjectId().toString();
		Long taskId = taskVO.getTaskId();
		
		map2.put("tenantId", taskVO.getTenantId());
		map2.put("projectId", projectId);
		int weightInput = ezPMSDAO.getProjectDetails(map2).getWeightInput();

		if (weightInput == 0) {
			int projectWorkingdaySum = ezPMSDAO.getProjectWorkingdaySum(taskVO);
			float calWeight = (taskWorkingday / projectWorkingdaySum) * 100;
			System.out.println(">>>>>>>>>>>>>>" + calWeight + " = (" + taskWorkingday + " / " + projectWorkingdaySum + ") * 100");
			map2.put("weight", calWeight);
			map2.put("workingdaySum", projectWorkingdaySum);
		} else {
			map2.put("weight", taskVO.getWeight());
		}
		map2.put("taskId", taskId);
		map2.put("workingday", taskWorkingday);

		ezPMSDAO.updateTaskWDNW(map2);
		
		//프로젝트가 가중치 자동 계산일 경우 모든 업무의 가중치 재계산
		if (weightInput == 0) {
			ezPMSDAO.updateAllTaskWeight(map2);
		}
	}

	@Override
	public void updateGroupSort(long projectId, long groupId, int sortOrder, int tenantId) {
		logger.debug("[SERVICE] updateGroupSort started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("groupId", groupId);
		map.put("sortOrder", sortOrder);
		map.put("tenantId", tenantId);

		ezPMSDAO.updateGroupSort(map);

		logger.debug("[SERVICE] updateGroupSort started.");
	}

	@Override
	public void updateTaskSort(long groupId, long taskId, int sortOrder, int tenantId) {
		logger.debug("[SERVICE] updateTaskSort started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", groupId);
		map.put("taskId", taskId);
		map.put("sortOrder", sortOrder);
		map.put("tenantId", tenantId);

		ezPMSDAO.updateTaskSort(map);
		logger.debug("[SERVICE] updateTaskSort ended.");
	}

	@Override
	public void updatePreTaskRel(Map<String, Object> map) {
		logger.debug("[SERVICE] updatePreTaskRel started.");
		
//		String type = (String) map.get("type");
//		
//		if(type.equals("task2task") || type.equals("group2task")) {
//			//프로젝트 task 시작날짜와 끝날짜 update
//			ProjectTaskVO projectTaskVO = new ProjectTaskVO();
//			projectTaskVO.setTenantId(tenantId);
//			projectTaskVO.setTaskId(taskId);
//			projectTaskVO.setProjectId(projectId);
//			projectTaskVO.setPlanStartDate(request.getParameter("planStartDate"));
//			projectTaskVO.setPlanEndDate(request.getParameter("planEndDate"));
//			projectTaskVO.setRealProgress(Float.parseFloat(request.getParameter("realProgress")));
//			
//			ezPMSService.updateTaskStatus(projectTaskVO, companyId, tenantId);
//		} else {
//			//프로젝트 group내의 모든 task의 시작날짜와 끝날짜 update
//			long groupId = taskId;
//			
//			List<ProjectTaskVO> tasksInGroup = ezPMSService.getTaskListByGroupId(tenantId, groupId);
//		
//			ProjectGroupVO oldGroupVO = ezPMSService.getGroupDetails(groupId, tenantId, projectId);
//			
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//			Date oldGroupStartDate = sdf.parse(oldGroupVO.getPlanStartDate());
//			Date newGroupStartDate = sdf.parse(request.getParameter("planStartDate"));
//			
//			logger.debug("oldGroupStartDate : " + sdf.format(oldGroupStartDate) + ", newGroupStartDate : " + sdf.format(newGroupStartDate));
//			
//			int offset = ezPMSService.getWorkingDays(oldGroupStartDate, newGroupStartDate, companyId, tenantId) - 1;
//			logger.debug("offset : " + offset);
//			
//			for(ProjectTaskVO taskVO : tasksInGroup) {
//				
//				// offset만큼 workingday기준으로 날짜를 증가시킴
//				Date oldStartDate = sdf.parse(taskVO.getPlanStartDate());
//				String newStartDate = sdf.format(ezPMSService.addWorkingDays(oldStartDate, offset, companyId, tenantId));
//				Date oldEndDate = sdf.parse(taskVO.getPlanEndDate());
//				String newEndDate = sdf.format(ezPMSService.addWorkingDays(oldEndDate, offset, companyId, tenantId));
//				
//				logger.debug("oldStartDate : " + sdf.format(oldStartDate) + ", newStartDate : " + newStartDate);
//				logger.debug("oldEndDate   : " + sdf.format(oldEndDate) +   ", newEndDate   : " + newEndDate);
//				
//				taskVO.setTenantId(tenantId);
//				taskVO.setProjectId(projectId);
//				taskVO.setPlanStartDate(newStartDate);
//				taskVO.setPlanEndDate(newEndDate);
//				taskVO.setRealProgress(Float.parseFloat(request.getParameter("realProgress")));
//				
//				ezPMSService.updateTaskStatus(taskVO, companyId, tenantId);
//				
//				ezPMSService.updateGroupDate(groupId, tenantId, companyId);
//			}
//		}
		
		ezPMSDAO.updatePreTaskRel(map);
		logger.debug("[SERVICE] updatePreTaskRel ended.");
	}

	@Override
	public Float getGroupWeight(Long groupId, int tenantId) {
		logger.debug("[SERVICE] getGroupWeight started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", groupId);
		map.put("tenantId", tenantId);

		logger.debug("[SERVICE] getGroupWeight ended.");
		return ezPMSDAO.getGroupWeight(map);
	}

	@Override
	public void updateTaskWeight(ProjectTaskVO taskVO) throws Exception {
		logger.debug("[SERVICE] updateTaskWeight started.");

		ezPMSDAO.updateTaskWeight(taskVO);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", taskVO.getGroupId());
		map.put("tenantId", taskVO.getTenantId());
		map.put("projectId", taskVO.getProjectId());

		// 프로젝트 직속 업무가 아니라면 업무가 속한 모든 조상그룹의 진행률을 업데이트 해준다.
		if (!taskVO.getGroupId().equals(0L)) {
			String ancesterGroup = getAncesterGroup(taskVO.getGroupId(), taskVO.getTenantId());
			String[] ancGroupArr = ancesterGroup.split(",");

			for (int i = 0; i < ancGroupArr.length; i++) {
				map.put("groupId", ancGroupArr[i]);
				ezPMSDAO.updateGroupProgress(map);
			}
		}

		// 업무가 속한 프로젝트의 진행률을 업데이트 해준다.
		ezPMSDAO.updateProjectProgress(taskVO);

		// 업데이트 후 프로젝트 진행률을 조회
		ProjectInfoVO projectDetails = ezPMSDAO.getProjectDetails(map);

		// 프로젝트 진행률이 100이상이면, 상태를 완료로 바꾼다.
		if (Math.round(projectDetails.getProgress() * 100) / 100.0d >= 100) {
			map.put("status", "C");
		} else {
			map.put("status", "P");
		}
		ezPMSDAO.updateProjectStatus(map);

		logger.debug("[SERVICE] updateTaskWeight ended.");
	}

	@Override
	public void updateTaskGroupId(long projectId, long targetTaskId, long toGroupId, long fromGroupId, int tenantId, int treeDepth, String lang) throws Exception {
		logger.debug("[SERVICE] updateTaskGroupId started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("targetTaskId", targetTaskId);
		map.put("toGroupId", toGroupId);
		map.put("tenantId", tenantId);
		map.put("treeDepth", treeDepth);

		ezPMSDAO.updateTaskGroupId(map);
		updateGroupLatestInfo(projectId, toGroupId, tenantId, lang);
		updateGroupLatestInfo(projectId, fromGroupId, tenantId, lang);
		
		logger.debug("[SERVICE] updateTaskGroupId ended.");
	}

	@Override
	public Float getProjectWeight(Long projectId, int tenantId) throws Exception {
		logger.debug("[SERVICE] getProjectWeight started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);

		logger.debug("[SERVICE] getProjectWeight ended.");
		return ezPMSDAO.getProjectWeight(map);
	}

	@Override
	public float getPlanProgress(Date start, Date end, String companyId, int tenantId, String lang) throws Exception {
		logger.debug("[SERVICE] getPlanProgress started.");
		Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String simpToday = sdf.format(today);
		Date now = sdf.parse(simpToday);
		
		Calendar cal = new GregorianCalendar();
		cal.add(Calendar.DATE, 1);
		
		Date tomorrow = cal.getTime();
		String simpTomorrow = sdf.format(tomorrow);
		Date tomorrowDate = sdf.parse(simpTomorrow);

		int totalWorkingdays = getWorkingDays(start, end, companyId, tenantId, lang);
		int restDueday = getWorkingDays(tomorrowDate, end, companyId, tenantId, lang);
		float planProgress = 0;
		
		//시작일이 오늘날짜보다 늦으면(대기 상태)이면 계획진행률을 0으로 리턴
		if(now.compareTo(start) >= 0){
			if (totalWorkingdays == 0) {
				totalWorkingdays = 1;
			}
			if (restDueday > 0) {
				planProgress = ((float) (totalWorkingdays - restDueday) / totalWorkingdays) * 100;
			} else {
				planProgress = 100;
			}
		}
		
		logger.debug("[SERVICE] getPlanProgress started.");
		return planProgress;
	}

	@Override
	public void updateGroupProgress(long projectId, long groupId, int tenantId) {
		logger.debug("[SERVICE] updateGroupProgress started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("groupId", groupId);
		map.put("tenantId", tenantId);

		ezPMSDAO.updateGroupProgress(map);
		logger.debug("[SERVICE] updateGroupProgress ended.");
	}

	@Override
	public void updateGroupDate(long groupId, int tenantId, String companyId, String lang) throws Exception {
		logger.debug("[SERVICE] updateGroupDate started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", groupId);
		map.put("tenantId", tenantId);

		ProjectGroupVO groupVO = new ProjectGroupVO();
		// 그룹에 속한 업무들 중 가장 빠른 계획 시작일과 가장 늦은 계획 종료일을 얻어옴.
		groupVO = getGroupBoundaryDate(groupId, tenantId);
		
		//그룹인데 하위업무가 없을 경우 상위 그룹의 날짜를 얻어온다.
		if(groupVO.getPlanStartDate() == null){
			groupVO = getUpperGroupDate(groupId, tenantId);
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date startDay = sdf.parse(groupVO.getPlanStartDate());
		Date endDay = sdf.parse(groupVO.getPlanEndDate());

		// 위에서 얻어 온 시작일, 종료일을 기준으로 워킹데이를 구함.
		int workingday = getWorkingDays(startDay, endDay, companyId, tenantId, lang);

		map.put("workingday", workingday);
		map.put("planStartDate", startDay);
		map.put("planEndDate", endDay);

		ezPMSDAO.updateGroupDate(map);
		logger.debug("[SERVICE] updateGroupDate ended.");
	}

	@Override
	public ProjectGroupVO getGroupBoundaryDate(long groupId, int tenantId) throws Exception {
		logger.debug("[SERVICE] getGroupBoundaryDate started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", groupId);
		map.put("tenantId", tenantId);

		logger.debug("[SERVICE] getGroupBoundaryDate ended.");
		return ezPMSDAO.getGroupBoundaryDate(map);
	}

	@Override
	public void updateTaskProgress(ProjectTaskVO taskVO) throws Exception {
		logger.debug("[SERVICE] updateTaskProgress started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", taskVO.getGroupId());
		map.put("tenantId", taskVO.getTenantId());
		map.put("projectId", taskVO.getProjectId());

		// 업무의 진행률을 업데이트 해준다.
		ezPMSDAO.updateTaskProgress(taskVO);
//		if(taskVO.getRealProgress() == 100){
//			updateTaskEndDate(taskVO.getTenantId(), taskVO.getTaskId());
//		}

		// 프로젝트 직속 업무가 아니라면 업무가 속한 모든 조상그룹의 진행률을 업데이트 해준다.
		if (!taskVO.getGroupId().equals(0L)) {
			String ancesterGroup = getAncesterGroup(taskVO.getGroupId(), taskVO.getTenantId());
			String[] ancGroupArr = ancesterGroup.split(",");

			for (int i = 0; i < ancGroupArr.length; i++) {
				map.put("groupId", ancGroupArr[i]);
				ezPMSDAO.updateGroupProgress(map);
			}
		}

		// 업무가 속한 프로젝트의 진행률을 업데이트 해준다.
		ezPMSDAO.updateProjectProgress(taskVO);

		// 업데이트 후 프로젝트 진행률을 조회
		ProjectInfoVO projectDetails = ezPMSDAO.getProjectDetails(map);

		// 프로젝트 진행률이 100이상이면, 상태를 완료로 바꾼다.
		if (Math.round(projectDetails.getProgress() * 100) / 100.0d >= 100) {
			map.put("status", "C");
		} else {
			map.put("status", "P");
		}
		ezPMSDAO.updateProjectStatus(map);

		logger.debug("[SERVICE] updateTaskProgress ended.");
	}

	@Override
	public String getAncesterGroup(Long groupId, int tenantId) throws Exception {
		logger.debug("[SERVICE] getAncesterGroup started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", groupId);
		map.put("tenantId", tenantId);

		logger.debug("[SERVICE] getAncesterGroup ended.");
		return ezPMSDAO.getAncesterGroup(map);
	}

//	@Override
//	public void updateProjectDate(long projectId, int tenantId, String companyId, String lang) throws Exception {
//		logger.debug("[SERVICE] updateProjectDate started.");
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("projectId", projectId);
//		map.put("tenantId", tenantId);
//
//		ProjectInfoVO projectVO = new ProjectInfoVO();
//		// 프로젝트에 속한 업무들 중 가장 빠른 계획 시작일과 가장 늦은 계획 종료일을 얻어옴.
//		projectVO = getProjectBoundaryDate(projectId, tenantId);
//
//		Date startDay = new SimpleDateFormat("yyyy-MM-dd").parse(projectVO.getPlanStartDate());
//		Date endDay = new SimpleDateFormat("yyyy-MM-dd").parse(projectVO.getPlanEndDate());
//
//		// 위에서 얻어 온 시작일, 종료일을 기준으로 워킹데이를 구함.
//		int workingday = getWorkingDays(startDay, endDay, companyId, tenantId, lang);
//
//		map.put("workingday", workingday);
//		map.put("planStartDate", startDay);
//		map.put("planEndDate", endDay);
//
//		ezPMSDAO.updateProjectDate(map);
//		logger.debug("[SERVICE] updateProjectDate ended.");
//	}

	@Override
	public ProjectInfoVO getProjectBoundaryDate(long projectId, int tenantId) throws Exception {
		logger.debug("[SERVICE] getProjectBoundaryDate started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);

		logger.debug("[SERVICE] getProjectBoundaryDate ended.");
		return ezPMSDAO.getProjectBoundaryDate(map);
	}

	@Override
	public List<ProjectMemberScheduleVO> getMemberSchedule(long projectId, int tenantId, String lang, String companyId, String planStartDate, String planEndDate) throws Exception {
		logger.debug("[SERVICE] getMemberSchedule started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		
		List<ProjectMemberScheduleVO> memberScheduleVOs = new ArrayList<ProjectMemberScheduleVO>();
		
		List<TaskMemberVO> taskMemberVOs = ezPMSDAO.getMemberSchedule(map);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		// 공휴일 리스트를 가져와서 Calendar클래스로 변환
		Set<String> holidayList = getHolidayList(planStartDate, planEndDate, tenantId, companyId, lang);
		Set<Calendar> holidaySet = new HashSet<Calendar>();
		
		holidayList.forEach(holiday -> {
			try {
				Calendar cal = new GregorianCalendar();
				cal.setTime(sdf.parse(holiday));
				holidaySet.add(cal);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		});
		
		taskMemberVOs.forEach(vo -> {
			Calendar startDate = new GregorianCalendar();
			Calendar endDate   = new GregorianCalendar();
			try {
				startDate.setTime(sdf.parse(vo.getPlanStartDate()));
				endDate.setTime(sdf.parse(vo.getPlanEndDate()));
				
				do {
					if(startDate.get(Calendar.DAY_OF_WEEK) != 1 && startDate.get(Calendar.DAY_OF_WEEK) != 7 && !holidaySet.contains(startDate)) {
						ProjectMemberScheduleVO scheduleVO = new ProjectMemberScheduleVO();
						scheduleVO.setAssignedDate(sdf.format(startDate.getTime()));
						scheduleVO.setTaskId(vo.getTaskId());
						scheduleVO.setDeptName(vo.getUserDeptname());
						scheduleVO.setUserName(vo.getUserName());
						scheduleVO.setUserId(vo.getUserId());
						scheduleVO.setProjectId(projectId);
						scheduleVO.setTenantId(tenantId);
						
						memberScheduleVOs.add(scheduleVO);
					}
					
					startDate.add(Calendar.DATE, 1);
				} while(startDate.compareTo(endDate) < 1);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		});
		
		logger.debug("[SERVICE] getMemberSchedule ended.");
		return memberScheduleVOs;
	}

	@Override
	public List<ProjectTaskVO> getTaskListByGroupId(int tenantId, long groupId) {
		logger.debug("[SERVICE] getTaskListByGroupId started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", groupId);
		map.put("tenantId", tenantId);
		
		logger.debug("[SERVICE] getTaskListByGroupId ended.");
		return ezPMSDAO.getTaskListByGroupId(map);	
	}

	@Override
	public Date addWorkingDays(Date date, int offset, String companyId, int tenantId) {
		logger.debug("[SERVICE] addWorkingDays started");
		
		Calendar cal = GregorianCalendar.getInstance();
		cal.setTime(date);
		
		int addAmount = 1;
		
		if(offset < 0) {
			offset = -offset;
			addAmount = -1;
		}
		
		int i = 0;
		
		while(i < offset) {
			cal.add(Calendar.DATE, addAmount);
			
			// 평일일 때만 i를 증가
			if(cal.get(Calendar.DAY_OF_WEEK) != 1 && cal.get(Calendar.DAY_OF_WEEK) != 7) {
				i++;
			}
		}
		
		logger.debug("[SERVICE] addWorkingDays ended");
		return new Date(cal.getTimeInMillis());
	}
	
	public List<String> getDateTaskList(long projectId, String date, String selUserId, String lang, int tenantId) {
		logger.debug("[SERVICE] getDateTaskList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("date", date);
		map.put("selUserId", selUserId);
		map.put("lang", lang);
		map.put("tenantId", tenantId);
		
		logger.debug("[SERVICE] getDateTaskList ended.");
		return ezPMSDAO.getDateTaskList(map);
	}
	
	@Override
	public boolean checkIfBoardHasReplies(JSONObject jsonParam) {
		logger.debug("[SERVICE] checkIfBoardHasReplies started.");
		boolean result = false;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemIds", jsonParam.get("itemIds"));
		map.put("tenantId", jsonParam.get("tenantId"));
		
		if(ezPMSDAO.checkIfBoardHasReplies(map) > 0) {
			result = true;
		}
		
		logger.debug("[SERVICE] checkIfBoardHasReplies ended.");
		return result;
	}
	
	public ProjectGroupVO getUpperGroupDate(long groupId, int tenantId) throws Exception {
		logger.debug("[SERVICE] getUpperGroupDate started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", groupId);
		map.put("tenantId", tenantId);

		logger.debug("[SERVICE] getUpperGroupDate ended.");
		return ezPMSDAO.getUpperGroupDate(map);
	}
	
	@Override
	public Long getUpperGroupId(long groupId, long projectId, int tenantId) {
		logger.debug("[SERVICE] getUpperGroupId started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", groupId);
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);

		logger.debug("[SERVICE] getUpperGroupId ended.");
		return ezPMSDAO.getUpperGroupId(map);
	}
	
	@Override
	public ProjectTaskVO getTaskSchedule(Map<String, Object> map) {
		logger.debug("[SERVICE] getTaskSchedule started.");
		logger.debug("[SERVICE] getTaskSchedule ended.");
		return ezPMSDAO.getTaskSchedule(map);
	}

	@Override
	public ProjectGroupVO getGroupSchedule(Map<String, Object> map) {
		logger.debug("[SERVICE] getGroupSchedule started.");
		logger.debug("[SERVICE] getGroupSchedule ended.");
		return ezPMSDAO.getGroupSchedule(map);
	}

	@Override
	public int checkIfHasPreTaskRel(Map<String, Object> map) {
		logger.debug("[SERVICE] checkIfHasPreTaskRel started.");
		logger.debug("[SERVICE] checkIfHasPreTaskRel ended.");
		return ezPMSDAO.checkIfHasPreTaskRel(map);
	}

//	@Override
//	public boolean checkIfPreTaskRelExist(Map<String, Object> map) {
//		logger.debug("[SERVICE] checkIfExistPreTaskRel started.");
//		boolean result = false;
//		
//		if(ezPMSDAO.checkIfPreTaskRelExist(map) > 0) {
//			result = true;
//		} 
//		
//		logger.debug("[SERVICE] checkIfExistPreTaskRel ended.");
//	
//		return result;
//	}
	
//	@Override
//	public List<Integer> getLaggingGroupIds(Map<String, Object> map) {
//		logger.debug("[SERVICE] getLaggingGroupIds started.");
//		
//		Set<Integer> groupIdSet = new HashSet<Integer>();
//		
//		if(ezPMSDAO.checkIfPreTaskRelExist(map) > 0) {
//			List<String> groupIdsStr = ezPMSDAO.getLaggingAncestorGroupIds(map);
//			
//			Iterator<String> iterator = groupIdsStr.iterator();
//			
//			while(iterator.hasNext()) {
//				
//				String[] groupIdStrArr = iterator.next().split(",");
//				
//				for(String groupIdStr : groupIdStrArr) {
//					groupIdSet.add(Integer.parseInt(groupIdStr));
//				}
//			}
//		}
//		
//		List<Integer> groupIds = new ArrayList<Integer>(groupIdSet);
//		
//		logger.debug("[SERVICE] getLaggingGroupIds ended.");
//		return groupIds;
//	}

	@Override
	public void deletePreTaskRelInTask(Map<String, Object> map) {
		logger.debug("[SERVICE] deletePreTaskRelInTask started.");
		ezPMSDAO.deletePreTaskRelInTask(map);
		logger.debug("[SERVICE] deletePreTaskRelInTask ended.");
	}
	
	@Override
	public void deletePreTaskRelInGroup(Map<String, Object> map) {
		logger.debug("[SERVICE] deletePreTaskRelInGroup started.");
		ezPMSDAO.deletePreTaskRelInGroup(map);
		logger.debug("[SERVICE] deletePreTaskRelInGroup ended.");	
	}

	@Override
	public List<TaskMemberVO> getTaskMemberListInGroup(int tenantId, long groupId, String lang)  throws Exception  {
		logger.debug("[SERVICE] ezPMS getTaskMemberListInGroup Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", groupId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);

		List<TaskMemberVO> taskMemberList = ezPMSDAO.getTaskMemberListInGroup(map);
		logger.debug("[SERVICE] ezPMS getTaskMemberListInGroup Ended");
		return taskMemberList;
	}

	@Override
	public void deleteGroupMember(Long projectId, long groupId, int tenantId) {
		logger.debug("[SERVICE] ezPMS deleteGroupMember Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("groupId", groupId);
		map.put("tenantId", tenantId);
		
		ezPMSDAO.deleteGroupMember(map);
		logger.debug("[SERVICE] ezPMS deleteGroupMember Ended");
	}

	@Override
	public void updateAllTaskDatesInPrj(Map<String, Object> map) {
		logger.debug("[SERVICE] ezPMS updateAllTaskDatesInPrj Started");
		ezPMSDAO.updateAllTaskDatesInPrj(map);
		updateAllTaskWeight(map);
		ezPMSDAO.updateProjectWorkingdaySum2(map);
		
		ProjectTaskVO taskVO = new ProjectTaskVO();
		taskVO.setTenantId((int) map.get("tenantId"));
		taskVO.setProjectId((Long) map.get("projectId"));
		ezPMSDAO.updateProjectProgress(taskVO);
		logger.debug("[SERVICE] ezPMS updateAllTaskDatesInPrj Ended");
	}

	@Override
	public void updateAllGroupDatesInPrj(Map<String, Object> map) {
		logger.debug("[SERVICE] ezPMS updateAllGroupDatesInPrj Started");
		ezPMSDAO.updateAllGroupDatesInPrj(map);
		logger.debug("[SERVICE] ezPMS updateAllGroupDatesInPrj Ended");
	}
	
	@Override
	public void updateProjectStatusScheduler() throws Exception {
		logger.debug("[SERVICE] ezPMS updateProjectStatusScheduler Started");
		ezPMSDAO.updateProjectStatusScheduler();
		logger.debug("[SERVICE] ezPMS updateProjectStatusScheduler Ended");
	}
	
	@Override
	public void updateTaskStatusScheduler() throws Exception {
		logger.debug("[SERVICE] ezPMS updateTaskStatusScheduler Started");
		ezPMSDAO.updateTaskStatusScheduler();
		logger.debug("[SERVICE] ezPMS updateTaskStatusScheduler Ended");
	}

	@Override
	public void updateProjectGroupEndDate(long projectId, String changeEndDate, int tenantId, long groupId) {
		logger.debug("[SERVICE] ezPMS updateProjectGroupEndDate started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("planEndDate", changeEndDate);
		map.put("tenantId", tenantId);
		map.put("groupId", groupId);
		
		ezPMSDAO.updateProjectGroupEndDate(map);
		logger.debug("[SERVICE] ezPMS updateProjectGroupEndDate ended");
		
	}

	@Override
	public void updateAllTaskWeight(Map<String, Object> map) {
		//map에 projectId, tenantId를 담아서 넘겨주면 됨.
		ezPMSDAO.updateProjectWorkingdaySum2(map);
		int weightInput = ezPMSDAO.getWeightInput(map);
		if(weightInput == 0){
			ProjectTaskVO taskVO = new ProjectTaskVO();
			taskVO.setTenantId((int)map.get("tenantId"));
			taskVO.setProjectId((Long)map.get("projectId"));
			
			int projectWorkingdaySum = ezPMSDAO.getProjectWorkingdaySum(taskVO);
			map.put("workingdaySum", projectWorkingdaySum);
			ezPMSDAO.updateAllTaskWeight(map);
		}
	}

	@Override
	public int getDateTaskCount(String date, long projectId, int tenantId, String memberId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchDate", date);
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("memberId", memberId);
		
		return ezPMSDAO.getDateTaskCount(map);
	}

	@Override
	public void updateGroupLatestInfo(long projectId, long groupId, int tenantId, String lang) throws Exception {
		String ancesterGroup = getAncesterGroup(groupId, tenantId);
		String[] ancGroupArr = ancesterGroup.split(",");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//해당 그룹과 상위그룹 일정 업데이트
		for (int i = 0; i < ancGroupArr.length; i++) {
			updateGroupDate(Long.parseLong(ancGroupArr[i]), tenantId, "companyid", lang);
		}
		
		//해당 그룹과 상위그룹 진행률 업데이트
		for (int i = 0; i < ancGroupArr.length; i++) {
			map.put("groupId", ancGroupArr[i]);
			ezPMSDAO.updateGroupProgress(map);
		}
		
	}

	@Override
	public List<String> getDateList(String startDateStr, String EndDateStr) throws Exception {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(startDateStr);
		Date endDate = dateFormat.parse(EndDateStr);

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
		return dateList;
	}

	@Override
	public HashSet<String> getHolidayList(String planStartDate, String planEndDate, int tenantId, String companyId, String lang) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("planStartDate", planStartDate);
		map.put("planEndDate", planEndDate);
		map.put("planStartDateShort",
				planStartDate.toString().substring(planStartDate.toString().indexOf("-") + 1));
		map.put("planEndDateShort",
				planEndDate.toString().substring(planEndDate.toString().indexOf("-") + 1));
		
		HashSet<String> solarHolidayMap = new HashSet<String>();
		HashSet<String> lunarHolidayMap = new HashSet<String>();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		//고정공휴일 & 사용자 정의 공휴일 불러오기
		map.put("lang", lang); //parameter추가
		
		if (lang.equals("3")) {
			map.put("country", "jap");
		} else {
			map.put("country", "kor");
		}
		
		List<ProjectHolidayVO> holidayList = ezPMSDAO.getCustomHoliday(map);
		HashSet<String> holidayDateList = new HashSet<String>();
		
		for (int i = 0; i < holidayList.size(); i++) {
			if (holidayList.get(i).getIsRepeat() == 1) {
				if (holidayList.get(i).getIsSolar() == 1) {
					String solarHoliday = holidayList.get(i).getHoliday();
					solarHolidayMap.add(solarHoliday);
				} else {
					String lunarHoliday = holidayList.get(i).getHoliday();
					lunarHolidayMap.add(lunarHoliday);
				}
			} else {
				holidayDateList.add(holidayList.get(i).getHoliday());
			}
		}
		
		try {
			holidayDateList.addAll(getWorkingDays2(sdf.parse(planStartDate), sdf.parse(planEndDate), solarHolidayMap, lunarHolidayMap));
			
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		}
		
		return holidayDateList;
	}

	@Override
	public List<ProjectBoardFolderVO> getBoardFolderList(long projectId, int tenantId, String lang, String location) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		
		List<ProjectBoardFolderVO> folderList = ezPMSDAO.getBoardFolderList(map);

		for (int i = 0; i < folderList.size(); i++) {
			ProjectBoardFolderVO vo = folderList.get(i);
			vo.setIcon("jstree-folder");
			map.put("projectId", projectId);
			map.put("folderId", vo.getId());
			
			int taskGroupCount = ezPMSDAO.getBoardListCount(map);
			
			if (location == null || !location.equals("folderSetting")) {
				if (taskGroupCount != 0) {
					vo.setText(vo.getText() + " (" + taskGroupCount + ")");
				}
			}
		}
		
		return folderList;
	}

	@Override
	public ProjectBoardFolderVO getBoardFolder (long projectId, int tenantId, String lang, long folderId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		map.put("folderId", folderId);
		
		return ezPMSDAO.getBoardFolder(map);
	}

	@Override
	public void addBoardFolder(int tenantId, String folderName, String folderName2, long projectId, String creatorId,
			int folderOrder) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("folderName", folderName);
		map.put("folderName2", folderName2);
		map.put("creatorId", creatorId);
		map.put("folderOrder", folderOrder);
		
		ezPMSDAO.addBoardFolder(map);
	}

	@Override
	public void updateBoardFolder(String folderName, String folderName2, long projectId, long folderId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("folderName", folderName);
		map.put("folderName2", folderName2);
		map.put("folderId", folderId);
		
		ezPMSDAO.updateBoardFolder(map);
	}

	@Override
	public void deleteBoardFolder(long projectId, long folderId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("folderId", folderId);
		
		ezPMSDAO.deleteBoardFolder(map);
	}

	@Override
	public void updateTaskNameGantt(ProjectTaskVO taskVO, String taskType) throws Exception {
		logger.debug("[SERVICE] ezPMS updateTaskNameGantt started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", taskVO.getProjectId());
		map.put("tenantId", taskVO.getTenantId());
		if(taskType.equals("p")) {
			map.put("groupId", taskVO.getGroupId());
			map.put("projectName", taskVO.getTaskName());
			map.put("groupName", taskVO.getTaskName());
			ezPMSDAO.updateProjectName(map);
			ezPMSDAO.updateGroupName(map);
		} else if(taskType.equals("t")) {
			map.put("taskName", taskVO.getTaskName());
			map.put("taskId", taskVO.getTaskId());
			ezPMSDAO.updateTaskName(map);
		} else {
			map.put("groupId", taskVO.getTaskId());
			map.put("groupName", taskVO.getTaskName());
			ezPMSDAO.updateGroupName(map);
		}
		
		logger.debug("[SERVICE] ezPMS updateTaskNameGantt ended");
	}

	@Override
	public void updateTaskEndDate(int tenantId, long taskId) throws Exception {
		logger.debug("[SERVICE] ezPMS updateTaskEndDate started");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Map<String, Object> map = new HashMap<String, Object>();
		
		Date today = new Date();
		String simpToday = sdf.format(today);
		// Date now = sdf.parse(simpToday);
		
		map.put("realEndDate", simpToday);
		map.put("tenantId", tenantId);
		map.put("taskId", taskId);
		
		ezPMSDAO.updateTaskEndDate(map);
		logger.debug("[SERVICE] ezPMS updateTaskEndDate ended");
	}

	@Override
	public int getTaskOverProjectDate(Long projectId, int tenantId, String planEndDate, String planStartDate) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("planEndDate", planEndDate);
		map.put("planStartDate", planStartDate);
		
		return ezPMSDAO.getTaskOverProjectDate(map);
	}
	
	@Override
	public Map<String, Object> getMinMaxGroupRealDate(Map<String, Object> map) {
		logger.debug("[SERVICE] ezPMS getMinMaxGroupRealDate started");	
		logger.debug("[SERVICE] ezPMS getMinMaxGroupRealDate ended");
		return ezPMSDAO.getMinMaxGroupRealDate(map);
	}

	@Override
	public void updateGroupRealDate(Map<String, Object> map) {
		logger.debug("[SERVICE] ezPMS updateGroupRealDate started");
		ezPMSDAO.updateGroupRealDate(map);
		logger.debug("[SERVICE] ezPMS updateGroupRealDate ended");
	}

	@Override
	public float getProjectRealProgress(Map<String, Object> map) {
		logger.debug("[SERVICE] ezPMS getProjectRealProgress started");	
		logger.debug("[SERVICE] ezPMS getProjectRealProgress ended");
		return ezPMSDAO.getProjectRealProgress(map);
	}

	@Override
	public void updateProjectRestDueday(int restDueday, long projectId, int tenantId) {
		logger.debug("[SERVICE] ezPMS updateProjectRestDueday started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("restDueday", restDueday);
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		
		ezPMSDAO.updateProjectRestDueday(map);
		
		logger.debug("[SERVICE] ezPMS updateProjectRestDueday ended");
		
	}

	@Override
	public String getUserCompanyId(String userId, int tenantId) {
		logger.debug("[SERVICE] ezPMS getUserCompanyId started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		
		logger.debug("[SERVICE] ezPMS getUserCompanyId ended");
		return ezPMSDAO.getuserCompanyId(map);
	}
	
	/**
	 * 게시판 9999년도부터 뒤로 날짜계산 표출 Method
	 */
	public String getReverseDateNow() {
		logger.debug("[SERVICE] ezPMS getReverseDateNow started");

		StringBuilder reverseDate = new StringBuilder();
		Calendar cal = Calendar.getInstance();
		
		reverseDate.append(9999 - cal.get(Calendar.YEAR));
		reverseDate.append(21 - cal.get(Calendar.MONTH));
		reverseDate.append(41 - cal.get(Calendar.DATE));
		reverseDate.append(33 - cal.get(Calendar.HOUR));
		reverseDate.append(69 - cal.get(Calendar.MINUTE));
		reverseDate.append(69 - cal.get(Calendar.SECOND));

		logger.debug("[SERVICE] ezPMS getReverseDateNow ended");
		return reverseDate.toString();
	}
}
