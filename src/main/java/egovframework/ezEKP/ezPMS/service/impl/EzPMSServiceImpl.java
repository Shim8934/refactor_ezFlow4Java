package egovframework.ezEKP.ezPMS.service.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.io.FileUtils;
import org.apache.ibatis.annotations.Param;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.icu.text.SimpleDateFormat;

import egovframework.ezEKP.ezPMS.dao.EzPMSDAO;
import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
import egovframework.ezEKP.ezPMS.vo.ProjectBoardVO;
import egovframework.ezEKP.ezPMS.vo.ProjectCompanyVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMainSettingVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberScheduleVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.ProjectUserVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskTreeVO;
import egovframework.ezEKP.ezPMS.vo.SearchVO;
import egovframework.ezEKP.ezPMS.vo.TaskLogListVO;
import egovframework.ezEKP.ezPMS.vo.TaskMemberVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzPMSService")
public class EzPMSServiceImpl extends EgovAbstractServiceImpl implements EzPMSService {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzPMSDAO")
	private EzPMSDAO ezPMSDAO;

	@Override
	public List<ProjectInfoVO> getProjectList(int tenantId, String userId, String deptId, String status,
			Map<String, Object> search, String lang) {
		LOGGER.debug("[SERVICE] getProjectList started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("lang", lang);
		map.put("deptId", deptId);
		
		if (search.get("projectSort").equals("1")) {
			map.put("projectSort", "PLAN_START_DATE");
		} else {
			map.put("projectSort", "PLAN_END_DATE");
		}
		
		search.remove("projectSort");
		
		map.putAll(search);
		
		List<ProjectInfoVO> projectList = new ArrayList<ProjectInfoVO>();
		
		try{
			projectList = ezPMSDAO.getProjectList(map);
			
			if (projectList != null) {
				for (int i = 0; i < projectList.size(); i++) {
					ProjectInfoVO project = projectList.get(i);
					
					if (!project.getStatus().equals("C")) {
						Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(project.getPlanEndDate());
						Date today = new Date();
						String simpToday = new SimpleDateFormat("yyyy-MM-dd").format(today);
						Date now = new SimpleDateFormat("yyyy-MM-dd").parse(simpToday); 
						
						int restDueday = getWorkinDays(now, endDate);
						projectList.get(i).setRestDueday(restDueday);
					}
					
					if (project.getStatus().equals("W")) {
						projectList.get(i).setStatus("대기");
					} else if (project.getStatus().equals("L")) {
						projectList.get(i).setStatus("지연");
					} else if (project.getStatus().equals("P")) {
						projectList.get(i).setStatus("진행");
					} else if (project.getStatus().equals("C")) {
						projectList.get(i).setStatus("완료");
					} else if (project.getStatus().equals("S")) {
						projectList.get(i).setStatus("보류");
					} else if (project.getStatus().equals("D")) {
						projectList.get(i).setStatus("삭제");
					}
					
					map.put("projectId", projectList.get(i).getProjectId());
					
					List<Map<String, Object>> statusCount = ezPMSDAO.getStatusCount(map);
					//각 개수
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
					
					//프로젝트 이름에 따옴표
					projectList.get(i).setProjectName(projectList.get(i).getProjectName().replaceAll("&quot;", "\"").replace("&#39;", "\'"));
				}
			}
		} catch (Exception e) {
			LOGGER.debug("ERROR : " + e.getMessage());
		}
		
		LOGGER.debug("[SERVICE] getProjectList ended.");
		return projectList;
	}

	@Override
	public Long addNewProject(Map<String, Object> map) {
		LOGGER.debug("[SERVICE] addNewProject started.");
		
		map.put("progress", 0);
		
		try {
			//날짜 차이 계산
			Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(map.get("planStartDate").toString());
			Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(map.get("planEndDate").toString());
			Date createDate = new SimpleDateFormat("yyyy-MM-dd").parse(map.get("createDate").toString());
			
			int createAndStartDateComp = createDate.compareTo(startDate);
			int workingDays = 0;
			
			if (createAndStartDateComp <= 0) {
				workingDays = getWorkinDays(startDate, endDate);
			} else {
				workingDays = getWorkinDays(createDate, endDate);
			}
						
			map.put("workingDay", workingDays);
			//map.put("workingDay", 0);
			map.put("restDueday", workingDays);
			
			//프로젝트 총괄담당자 정보 불러오기
			ProjectMemberVO headManagerInfo = getUserInfo(map.get("headManagerId").toString(), Integer.parseInt(map.get("tenantId").toString()), "user");
			map.put("headManagerDeptname", headManagerInfo.getUserDeptname());
			map.put("headManagerDeptname2", headManagerInfo.getUserDeptname2());
			map.put("headManagerName", headManagerInfo.getUserName());
			map.put("headManagerName2", headManagerInfo.getUserName2());
			
		} catch (Exception e) {
			LOGGER.debug("Error : " + e.getMessage() + " " + e.getStackTrace());
		}
		
		Long projectId = ezPMSDAO.addNewProject(map);
		LOGGER.debug("[SERVICE] addNewProject ended.");
		return projectId;
	}

	@Override
	public void deleteProject(int tenantId, Long projectId) {
		LOGGER.debug("Service deleteProject started.");	
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		
		ezPMSDAO.deleteProject(map);
		
		LOGGER.debug("Service deleteProject ended.");
	}

	@Override
	public void updateMainSetting(ProjectMainSettingVO project, int tenantId) {
		LOGGER.debug("Service updateMainSetting started");
		
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
			LOGGER.debug("DAO insertMainSetting started");
			ezPMSDAO.insertMainSetting(map);
		} else {
			LOGGER.debug("DAO updateMainSetting started");
			ezPMSDAO.updateMainSetting(map);
		}
		
		LOGGER.debug("Service updateMainSetting ended");
	}

	@Override
	public void updateProjectStatus(Long projectId, String status, int tenantId, String realStartDate, String planEndDate) {
		LOGGER.debug("updateProjectStatus started.");
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("status", status);
		map.put("tenantId", tenantId);
		
		try {
			
			if (status.equals("P")) {
				//날짜 차이 계산
				Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(planEndDate);
				Date createDate = new SimpleDateFormat("yyyy-MM-dd").parse(realStartDate);
				
				int createAndEndDateComp = createDate.compareTo(endDate);
				
				if(createAndEndDateComp > 0) {
					map.put("status", "L");
				} else {
					map.put("status", "P");
				}
			}
			
			ezPMSDAO.updateProjectStatus(map);
			
		} catch (Exception e) {
			LOGGER.debug("ERROR : " + e.getMessage());
		}
		
		LOGGER.debug("updateProjectStatus ended.");
	}

	@Override
	public ProjectInfoVO getProjectDetails(Long projectId, String userId, int tenantId, String mode, String lang, String deptId) {
		LOGGER.debug("getProjectDetail started");
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("lang", lang);
		map.put("tenantId", tenantId);
		map.put("mode", mode);
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("isGantt", 1);
		map.put("roleId", 4);
		
		ProjectInfoVO project = ezPMSDAO.getProjectDetails(map);
		
		try {
			project.setProjectName(project.getProjectName().replaceAll("&quot;", "\"").replaceAll("&#39;", "\'"));
			
			if (!project.getStatus().equals("C")) {
				Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(project.getPlanEndDate());
				Date today = new Date();
				String simpToday = new SimpleDateFormat("yyyy-MM-dd").format(today);
				Date now = new SimpleDateFormat("yyyy-MM-dd").parse(simpToday); 
				
				int restDueday = getWorkinDays(now, endDate);
				project.setRestDueday(restDueday);
				
				//프로젝트 멤버 불러오기
				List<ProjectMemberVO> member = ezPMSDAO.getProjectMemberList(map);
				project.setProjectMember(member);
			}
		} catch (Exception e) {
			LOGGER.debug("ERROR : " + e.getMessage());
		}
		
		LOGGER.debug("getProjectDetail ended");
		
		return project;
	}

	@Override
	public void updateProject(ProjectInfoVO project, int tenantId) {
		LOGGER.debug("Service updateProject Started.");
		
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
		
		try {
			//날짜 차이 계산
			Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(project.getPlanStartDate());
			Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(project.getPlanEndDate());
			Date nowDate = new SimpleDateFormat("yyyy-MM-dd").parse(project.getCreateDate());
			
			int createAndStartDateComp = nowDate.compareTo(startDate);
			int workingDays = 0;
			
			if (createAndStartDateComp <= 0) {
				workingDays = getWorkinDays(startDate, endDate);
			} else {
				workingDays = getWorkinDays(nowDate, endDate);
			}
			
			int restDueday = getWorkinDays(nowDate, endDate);
			map.put("workingday", workingDays);
			map.put("restDueday", restDueday);
			
			//프로젝트 총괄담당자 정보 불러오기
			ProjectMemberVO headManagerInfo = getUserInfo(project.getHeadManagerId(), tenantId, "user");
			map.put("headManagerDeptname", headManagerInfo.getUserDeptname());
			map.put("headManagerDeptname2", headManagerInfo.getUserDeptname2());
			map.put("headManagerName", headManagerInfo.getUserName());
			map.put("headManagerName2", headManagerInfo.getUserName2());
			
		} catch (Exception e) {
			LOGGER.debug("Error : " + e.getMessage());
		}
		
		ezPMSDAO.updateProjectInfo(map);
		
		LOGGER.debug("Service updateProject Ended.");
	}

	@Override
	public List<ProjectMemberVO> getProjectMemberList(Long projectId, int roleId, String lang, int tenantId, int isGantt) {
		LOGGER.debug("getProjectMemberList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("projectId", projectId);
		param.put("roleId", roleId);
		param.put("lang", lang);
		param.put("tenantId", tenantId);
		param.put("isGantt", isGantt);
		
		List<ProjectMemberVO> list = ezPMSDAO.getProjectMemberList(param);
		
		LOGGER.debug("getProjectMemberList ended");
		return list;
	}

	@Override
	public List<ProjectTaskVO> getMyTasks(Long projectId, String status, int tenantId, String userId, String offset, String lang, int limit, int startRow) {
		LOGGER.debug("[SERVICE] getMyTasks started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("status", status);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("lang", lang);
		map.put("offset", offset);
		map.put("limit", limit);
		map.put("startRow", startRow);
		
		List<ProjectTaskVO> taskList = ezPMSDAO.getMyTasks(map);
		
		LOGGER.debug("[SERVICE] getMyTasks ended");
		return taskList;
	}

	@Override
	public List<ProjectTaskVO> getProjectTasks(Long projectId, String status, int tenantId, String offset, String lang) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void changeKanbanOrder(Long projectId, String userId, String orderStatus, int tenantId) {
		LOGGER.debug("[SERVICE] changeKanbanOrder started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("userId", userId);
		map.put("orderStatus", orderStatus);
		map.put("tenantId", tenantId);
		
		ezPMSDAO.changeKanbanOrder(map);
		
		LOGGER.debug("[SERVICE] changeKanbanOrder ended.");
	}
	
	@Override
	public void addKanbanOrder(Long projectId, String userId, String orderStatus, int tenantId) {
		LOGGER.debug("[SERVICE] addKanbanOrder started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("userId", userId);
		map.put("orderStatus", orderStatus);
		map.put("tenantId", tenantId);
		
		ezPMSDAO.addKanbanOrder(map);
		LOGGER.debug("[SERVICE] changeKanbanOrder ended.");
	}
	
	@Override
	public int addFavoriteProject(Long projectId, String userId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		List<Long> favoriteProjectId = ezPMSDAO.getFavoriteProject(map);
		
		for (int i = 0; i < favoriteProjectId.size(); i++) {
			if (projectId == favoriteProjectId.get(i)) {
				return 1;
			}
		}
		
		ezPMSDAO.addFavoriteProject(map);
		return 0;
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
		LOGGER.debug("[SERVICE] addTaskLog started");
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
		LOGGER.debug("[SERVICE] addTaskLog ended");
	}

	@Override
	public List<TaskLogListVO> getTaskLogList(Long projectId, Map<String, Object> map, String offset, String lang, int tenantId) throws Exception {
		LOGGER.debug("[SERVICE] getTaskLogList started");
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		List<TaskLogListVO> taskLogList = ezPMSDAO.getTaskLogList(map);
		
		LOGGER.debug("[SERVICE] getTaskLogList ended");
		return taskLogList;
	}

	@Override
	public int getProjectListCount(ProjectInfoVO project, int tenantId, String userId, String deptId, String lang) {
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
		
		int projectListCount = ezPMSDAO.getProjectListCount(map);		
		
		return projectListCount;
	}

	@Override
	public int getTaskListCount(SearchVO search, String userId) {
		LOGGER.debug("[SERVICE] getTaskListCount started.");
		
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
		map.put("taskName", search.getProjectName());
		
		int taskCount = ezPMSDAO.getTaskListCount(map);
		
		LOGGER.debug("[SERVICE] getTaskListCount ended.");
		return taskCount;
	}

	@Override
	public int getTaskLogListCount(TaskLogListVO taskLog, int tenantId) {
		LOGGER.debug("[SERVICE] getTaskLogListCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", taskLog.getProjectId());
		map.put("searchByContent", taskLog.getLogContent());
		map.put("searchByStatus", taskLog.getLogStatus());
		map.put("groupId", taskLog.getGroupId());
		map.put("taskId", taskLog.getTaskId());
		map.put("tenantId", tenantId);
		
		int taskLogListCount = ezPMSDAO.getTaskLogListCount(map);
		
		LOGGER.debug("taskLogListCount : " + taskLogListCount);
		LOGGER.debug("[SERVICE] getTaskLogListCount ended.");
		return taskLogListCount;
	}

	@Override
	public int getMemberCount(Long projectId, int roleId, int tenantId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getKanbanOrder(Long projectId, String userId, int tenantId) {
		LOGGER.debug("[SERVICE] getKanbanOrder started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		
		String kanbanOrder = "";
		kanbanOrder = ezPMSDAO.getKanbanOrder(map);
		
		LOGGER.debug("[SERVICE] getKanbanOrder ended.");
		return kanbanOrder;
	}

	@Override
	public List<String> getProjectNameList(String userId, int tenantId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ProjectTaskVO> getTaskList(SearchVO search, String userId, int limit, int startRow, String orderWhat, String orderHow) {
		LOGGER.debug("[SERVICE] getTaskList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("projectId", search.getProjectId());
		param.put("taskName", search.getTaskName());
		param.put("upperGroupName", search.getUpperGroupName());
		param.put("headManagerName", search.getMemberId());
		param.put("overview", search.getOverview());
		param.put("searhByStartDate", search.getPlanStartDate());
		param.put("searchByEndDate", search.getPlanEndDate());
		param.put("lang", ""); //파라미터로 받아와야함.
		param.put("status", search.getStatus());
		param.put("tenantId", search.getTenantId());
		param.put("limit", limit);
		param.put("startRow", startRow);
		param.put("groupId", search.getGroupId());
		//정렬
		param.put("orderWhat", orderWhat);
		param.put("orderHow", orderHow);
		//검색
		param.put("searchByOverview", search.getOverview());
		param.put("searchByUser", search.getMemberName());
		param.put("taskName", search.getProjectName());
		
		List<ProjectTaskVO> list = ezPMSDAO.getTaskList(param);
		
		LOGGER.debug("[SERVICE] getTaskList ended");
		return list;
	}

	@Override
	public List<ProjectGroupVO> getGroupList(SearchVO search) {
		LOGGER.debug("[SERVICE] getGroupList started.");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("projectId", search.getProjectId());
		param.put("tenantId", search.getTenantId());
		param.put("lang", ""); // 수정 필요
		
		List<ProjectGroupVO> list = ezPMSDAO.getGroupList(param);
		
		LOGGER.debug("[SERVICE] getGroupList ended.");
		return list;
	}

	@Override
	public int addTask(ProjectTaskVO taskVO, List<TaskMemberVO> taskMemberList) {
		LOGGER.debug("[SERVICE] addTask started.");
		Long taskId = (long) 0;
		
		try {
			
			String projectId = taskVO.getProjectId()+"";
			
			// 정렬 순서 구하기
			int sortOrder = ezPMSDAO.getSortOrder(taskVO.getGroupId()+"");
			taskVO.setSortOrder(sortOrder);
			
			// 투입률 총합
			float sumPctinput = 0;
			
			taskVO.setRealProgress((float) 0);
			taskVO.setMemberCount(taskMemberList.size());
			
			//workingday 계산
			Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(taskVO.getPlanStartDate());
			Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(taskVO.getPlanEndDate());
			Date createDate = new SimpleDateFormat("yyyy-MM-dd").parse(taskVO.getWriteDate());
			
			int calWorkingDays = getWorkinDays(startDate, endDate);
			
			int createAndEndDateComp = createDate.compareTo(endDate);
			
			if(createAndEndDateComp > 0) {
				taskVO.setStatus("L");
			} else {
				taskVO.setStatus("W");
			}
			
			//업무 총괄담당자 정보 불러오기
			ProjectMemberVO headManagerInfo = getUserInfo(taskVO.getHeadManagerId(), taskVO.getTenantId(), "user");
			taskVO.setHeadManagerName(headManagerInfo.getUserName());
			taskVO.setHeadManagerName2(headManagerInfo.getUserName2());
			taskVO.setHeadManagerDeptname(headManagerInfo.getUserDeptname());
			taskVO.setHeadManagerDeptname2(headManagerInfo.getUserDeptname2());
			
			taskId = ezPMSDAO.addTask(taskVO);
			
			for(int i=0;i<taskMemberList.size();i++) {
				TaskMemberVO taskMemberVO = taskMemberList.get(i);
				taskMemberVO.setTaskId(taskId);
				sumPctinput += taskMemberVO.getPctinput();
				ezPMSDAO.addTaskMember(taskMemberVO);
			}
			
			float taskWorkingday = calWorkingDays * (sumPctinput / 100);
			
			HashMap<String, Object> map1 = new HashMap<String, Object>();
			map1.put("projectId", projectId);
			map1.put("workingday", taskWorkingday);
			ezPMSDAO.updateProjectWorkingday(map1);
			
			HashMap<String, Object> map2 = new HashMap<String, Object>();
			
			// 가중치 계산
			if(taskVO.getWeight() == -1) {
				int projectWorkingday = ezPMSDAO.getProjectWorkingday(projectId);
				float calWeight = (taskWorkingday / projectWorkingday) * 100;
				System.out.println(">>>>>>>>>>>>>>" + calWeight + " = " + taskWorkingday + " + " + projectWorkingday);
				map2.put("weight", calWeight);
			} else {
				map2.put("weight", taskVO.getWeight());
			}
			map2.put("taskId", taskId);
			map2.put("workingday", taskWorkingday);
			
			ezPMSDAO.updateTaskWDNW(map2);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		LOGGER.debug("[SERVICE] addTask ended.");
		
		return taskId.intValue();
	}

	@Override
	public List<ProjectMemberScheduleVO> getMemberScheduleList(Long projectId, String startDate, String endDate) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProjectTaskVO getTaskDetails(Long taskId, int tenantId, String lang) {
		LOGGER.debug("[SERVICE] getTaskDetails started.");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("taskId", taskId);
		param.put("tenantId", tenantId);
		param.put("lang", lang);
		
		ProjectTaskVO taskDetails = ezPMSDAO.getTaskDetails(param);
		
		LOGGER.debug("[SERVICE] getTaskDetails ended.");
		return taskDetails;
	}

	@Override
	public int updateTask(ProjectTaskVO task) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void deleteTask(Long taskId, long projectId, int tenantId) {
		LOGGER.debug("[SERVICE] deleteTask started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskId", taskId);
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		
		ezPMSDAO.deleteTask(map);
		
		LOGGER.debug("[SERVICE] deleteTask ended.");
	}

	@Override
	public void addGroup(Map<String, Object> map) {
		LOGGER.debug("[SERVICE] addGroup started.");
		map.put("delStatus", 0);
		
		try{
			//날짜 차이 계산
			Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(map.get("planStartDate").toString());
			Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(map.get("planEndDate").toString());
			Date createDate = new SimpleDateFormat("yyyy-MM-dd").parse(map.get("createDate").toString());
			
			int createAndStartDateComp = createDate.compareTo(startDate);
			int workingDays = 0;
			
			if (createAndStartDateComp <= 0) {
				workingDays = getWorkinDays(startDate, endDate);
			} else {
				workingDays = getWorkinDays(createDate, endDate);
			}
						
			map.put("workingDay", workingDays);
			map.put("restDueday", workingDays);
			
			//프로젝트 총괄담당자 정보 불러오기
			ProjectMemberVO headManagerInfo = getUserInfo(map.get("headManagerId").toString(), Integer.parseInt(map.get("tenantId").toString()), "user");
			map.put("headManagerDeptname", headManagerInfo.getUserDeptname());
			map.put("headManagerDeptname2", headManagerInfo.getUserDeptname2());
			map.put("headManagerName", headManagerInfo.getUserName());
			map.put("headManagerName2", headManagerInfo.getUserName2());
		} catch (Exception e) {
			LOGGER.debug("ERROR : " + e.getMessage() + " " + e.getStackTrace());
		}
		ezPMSDAO.addTaskGroup(map);
		LOGGER.debug("[SERVICE] addGroup ended.");
	}

	@Override
	public ProjectGroupVO getGroupDetails(Long groupId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int updateGroup(ProjectGroupVO group) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteGroup(Long groupId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getUserRole(String userId, Long projectId, int tenantId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProjectMainSettingVO getProjectMainSetting(String userId, int tenantId, String userIdType) {
		LOGGER.debug("[SERVICE] getProjectMainSetting started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("userIdType", userIdType);
		
		ProjectMainSettingVO mainSetting = new ProjectMainSettingVO();
		
		LOGGER.debug("[Parameter] userId : " + userId + ", tenantId : " + tenantId + ", userIdType : " + userIdType);
		try{
			mainSetting = ezPMSDAO.getProjectMainSetting(map);
		} catch (Exception e) {
			System.out.println("ERROR : " + e.getMessage());
		}
		
		LOGGER.debug("listStatus : " + mainSetting.getListProjectStatus());
		LOGGER.debug("[mainSetting] userMail : " + mainSetting.getUserMail());
		LOGGER.debug("[SERVICE] getProjectMainSetting ended.");
		return mainSetting;
	}

	@Override
	public List<ProjectTaskTreeVO> getProjectTaskTree(Long projectId, String onlyGroup, String location, int tenantId, String userId) {
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("project_Id", projectId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		
		List<ProjectTaskTreeVO> list = ezPMSDAO.getProjectGroupTree(map);
		
		for(int i = 0; i < list.size(); i++) {
			ProjectTaskTreeVO vo = list.get(i);
			vo.setIcon("jstree-folder");
			
			if(vo.getParent().equals("0")) {
				vo.setParent("#");
			}
			
			map.put("taskId", vo.getTaskId());
			map.put("groupId", vo.getGroupId());
			map.put("projectId", projectId);
			
			int taskGroupCount = 0;
			
			if (location.equals("taskLog")) {
				taskGroupCount = ezPMSDAO.getTaskLogListCount(map);
			} else if (location.equals("taskList")) {
				taskGroupCount = ezPMSDAO.getTaskListCount(map);
			} else if(location.equals("board")) {
				int boardCount = ezPMSDAO.getBoardListCount(map);
				
				if(boardCount > 0) {
					vo.setText(vo.getText() + "(" + boardCount + ")");
				}
			}

			if (taskGroupCount != 0) {
				vo.setText(vo.getText() + " (" + taskGroupCount + ")");
			} 
		}
		
		if(onlyGroup.equals("false")) {
			List<ProjectTaskTreeVO> list2 = ezPMSDAO.getProjectTaskTree(map);
			
			for(int i = 0; i < list2.size(); i++) {
				ProjectTaskTreeVO vo = list2.get(i);
				vo.setIcon("jstree-file");
				
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
				} else if(location.equals("board")) {
					map.put("taskId", vo.getTaskId());
					map.put("groupId", vo.getGroupId());
					
					int boardCount = ezPMSDAO.getBoardListCount(map);
					if(boardCount > 0) {
						vo.setText(vo.getText() + "(" + boardCount + ")");
					}
					
					map.remove("taskId");
					map.remove("groupId");
				}
				
				list.add(vo);
			}
		}
		
		return list;
	}
	
	@Override
	public List<ProjectUserVO> getDeptUserList(int tenantId, String key ,String value, String lang) throws Exception{
		LOGGER.debug("getDeptUserList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("key", key);
		param.put("value", value);
		param.put("lang", lang);
		List<ProjectUserVO> userList = ezPMSDAO.getDeptUserList(param);
		
		LOGGER.debug("getDeptUserList ended");
		return userList;
	}
	
	@Override
	public List<ProjectCompanyVO> getCompanyList(String userId, int tenantId, String companyId,String lang) throws Exception {
		LOGGER.debug("getCompanyList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		param.put("companyId", companyId);
		param.put("lang", lang);
		List<ProjectCompanyVO> compList = ezPMSDAO.getCompanyList(param);
		
		LOGGER.debug("getCompanyList ended");
		return compList;
	}

	@Override
	public List<DeptViewVO> getDeptViewList(String userId,String companyId, int tenantId,String lang) throws Exception {
		LOGGER.debug("getDeptViewList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		param.put("companyId", companyId);
		param.put("lang", lang);
		List<DeptViewVO> deptList = ezPMSDAO.getDeptViewVO(param);
		
		LOGGER.debug("getDeptViewList ended");
		return deptList;
	}
	
	public int getWorkinDays(Date start, Date end){
	    //Ignore argument check

	    Calendar c1 = GregorianCalendar.getInstance();
	    c1.setTime(start);
	    int w1 = c1.get(Calendar.DAY_OF_WEEK);
	    c1.add(Calendar.DAY_OF_WEEK, -w1 + 1);

	    Calendar c2 = GregorianCalendar.getInstance();
	    c2.setTime(end);
	    int w2 = c2.get(Calendar.DAY_OF_WEEK);
	    c2.add(Calendar.DAY_OF_WEEK, -w2 + 1);

	    //end Saturday to start Saturday 
	    long days = (c2.getTimeInMillis()-c1.getTimeInMillis())/(1000*60*60*24);
	    long daysWithoutSunday = days-(days*2/7);

	    if (w1 == Calendar.SUNDAY) {
	        w1 = Calendar.MONDAY;
	    }
	    if (w2 == Calendar.SUNDAY) {
	        w2 = Calendar.MONDAY;
	    }
	    
	    int workingDays = (int) (daysWithoutSunday-w1+w2);
	    return workingDays;
	}
	
	//유저 정보 불러오기
	@Override
	public ProjectMemberVO getUserInfo(String userId, int tenantId, String userIdType) throws Exception {
		LOGGER.debug("Service getUserInfo Started");
		ProjectMemberVO userInfo = new ProjectMemberVO();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		param.put("userIdType", userIdType);
		
		userInfo = ezPMSDAO.getUserInfo(param);
		
		LOGGER.debug("Service getUserInfo Ended");
		return userInfo;
	}
	
	//유저의 프로젝트 role 확인
	@Override
	public int getUserProjectRole (String userId, int tenantId, Long projectId, String deptId) {
		LOGGER.debug("[SERVICE] getUserProjectRole started");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		param.put("projectId", projectId);	
		param.put("deptId", deptId);
		
		int projectRole = ezPMSDAO.getUserProjectRole(param);
		LOGGER.debug("[SERVICE] getUserProjectRole ended");
		return projectRole;
	}
	
	@Override
	public List<ProjectMemberVO> getProjectMember(Long projectId, int roleId, String lang) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void addProjectMember(ProjectMemberVO projectMemberList, int tenantId) {		
		LOGGER.debug("[SERVICE] ezPMS addProjectMember Started");
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
			// TODO Auto-generated catch block
			LOGGER.debug("ERROR : " + e.getMessage());
		}
		
		LOGGER.debug("[SERVICE] ezPMS addProjectMember Ended");
	}

	@Override
	public Map<String, Object> getRemainingWeight(String projectId) {
		return ezPMSDAO.getRemainingWeight(projectId);
	}

	@Override
	public List<TaskMemberVO> getTaskMemberList(int tenantId, long taskId, String lang) {
		LOGGER.debug("[SERVICE] ezPMS getTaskMemberList Started");
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("taskId", taskId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		
		List<TaskMemberVO> taskMemberList = ezPMSDAO.getTaskMemberList(map);
		LOGGER.debug("[SERVICE] ezPMS getTaskMemberList Ended");
		return taskMemberList;
	}

	@Override
	public void deleteProjectMember(Long projectId, int tenantId) {
		LOGGER.debug("[SERVICE] deleteProjectMember Started");
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		
		ezPMSDAO.deleteProjectMember(map);
		
		LOGGER.debug("[SERVICE] deleteProjectMember Ended");
	}

	@Override
	public void updateProjectRealDate(Long projectId, int tenantId, String changeDate, String status, String planEndDate) {
		LOGGER.debug("[SERVICE] updateProjectRealDate Started");
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("changeDate", changeDate);
		map.put("status", status);
		map.put("progress", 100);
		
		try {
			Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(planEndDate);
			Date today = new Date();
			String simpToday = new SimpleDateFormat("yyyy-MM-dd").format(today);
			Date now = new SimpleDateFormat("yyyy-MM-dd").parse(simpToday);
			int restDueday = getWorkinDays(now, endDate);
			
			map.put("restDueday", restDueday);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
		ezPMSDAO.updateProjectRealDate(map);
		LOGGER.debug("[SERVICE] updateProjectRealDate Ended");
	}

	@Override
	public void completeAllTasks(long projectId, int tenantId, String realEndDate, String planEndDate) {
		LOGGER.debug("[SERVICE] completeAllTasks Started");
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("realEndDate", realEndDate);
		map.put("status", "C");
		map.put("progress", 100);

		try {
			Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(planEndDate);
			Date today = new Date();
			String simpToday = new SimpleDateFormat("yyyy-MM-dd").format(today);
			Date now = new SimpleDateFormat("yyyy-MM-dd").parse(simpToday);
			int restDueday = getWorkinDays(now, endDate);
			
			map.put("restDueday", restDueday);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
		ezPMSDAO.completeAllTasks(map);
		LOGGER.debug("[SERVICE] completeAllTasks Started");
	}

	@Override
	@Transactional
	public void addBoard(JSONObject jsonParam, String realPath) throws Exception {
		LOGGER.debug("[SERVICE] addBoard Started");
		
		int tenantId = (int)jsonParam.get("tenantId");
		int projectId = Integer.parseInt((String) jsonParam.get("projectId"));
		
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
		vo.setGroupId(Long.parseLong((String) jsonParam.get("groupId")));
		if(!jsonParam.get("taskId").equals("null")) {
			vo.setTaskId(Long.parseLong((String) jsonParam.get("taskId")));
		}
		vo.setWriterPosition((String) jsonParam.get("writerPosition"));
		vo.setWriterPosition2((String) jsonParam.get("writerPosition2"));
		vo.setWriteOverview((String) jsonParam.get("writeOverview"));
		
		int last_insert_id = ezPMSDAO.addBoard(vo);
		
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
				file.mkdir();
			}
			
			String[] attach = fileList.split("/");
			
			attachMap.put("tenantId", tenantId);
			
			for (int i = 0; i < attach.length; i++) {
				String[] files = attach[i].split(":");
				String filePath = files[0];
				String fileName = files[1];
				String fileSize = files[2];
				String extension = fileName.substring(fileName.lastIndexOf(".") + 1);
				
				LOGGER.debug("filePath : " + filePath + " | fileName : " + fileName + " | fileSize : " + fileSize);
				
				String uploadFilePath = commonUtil.separator + projectId + "_uploadFile" + commonUtil.separator + filePath + "." + extension;
				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + "." + extension;
				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + projectId + "_uploadFile" + commonUtil.separator + filePath + "." + extension;
			
				attachMap.put("last_insert_id", last_insert_id);
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFilePath);
				
				ezPMSDAO.insertProjectAttach(attachMap);
				
				try {
					fileMove(beforeFilePath, afterFilePath);	// Temp 폴더에서 첨부파일 이동
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				}
			}
		}
		LOGGER.debug("[SERVICE] addBoard Ended");
	}

	@SuppressWarnings("unchecked")
	@Transactional
	@Override
	public void deleteBoard(int tenantId, JSONObject jsonParam) throws Exception {
		LOGGER.debug("[SERVICE] deleteBoard started");
		
		ArrayList<String> itemIds = (ArrayList<String>) jsonParam.get("itemIds");
		String userId = (String) jsonParam.get("userId");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("projectId", jsonParam.get("projectId"));
		map.put("roleId", 1);
		
		List<ProjectMemberVO> memberList = ezPMSDAO.getProjectMemberList(map);
		String headManagerId = memberList.get(0).getUserId();
		
		for(String itemId : itemIds) {
			map.put("itemId", itemId);
			ProjectBoardVO boardVO = ezPMSDAO.getBoardDetail(map);
			if(boardVO.getWriterId().equals(userId) || headManagerId.equals(userId)) {
				ezPMSDAO.deleteBoard(map);
			} else {
				Exception e = new Exception("Only project Manager and Writer are authorized to delete article");
				throw e;
			}
		}
		LOGGER.debug("[SERVICE] deleteBoard ended");
	}
	
	@Override
	public List<ProjectBoardVO> getBoardList(int tenantId, Long projectId, Long groupId, Long taskId, String userId, int startRow, int limit, String lang) {
		LOGGER.debug("[SERVICE] getBoardList Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("projectId", projectId);
		map.put("groupId", groupId);
		map.put("taskId", taskId);
		map.put("startRow", startRow);
		map.put("limit", limit);
		map.put("lang", lang);
		
		List<ProjectBoardVO> boardList = ezPMSDAO.getBoardList(map);
		
		for(ProjectBoardVO boardVO : boardList) {
			map = new HashMap<String, Object>();
			map.put("userId", userId);
			map.put("itemId", boardVO.getItemId());
			
			if(ezPMSDAO.checkReadBoardOrNot(map) != -1) {
				boardVO.setReadOrNot(true);
			}
		}
		
		LOGGER.debug("[SERVICE] getBoardList Ended");
		return boardList;
	}

	@Override
	public int getBoardListCount(int tenantId, Long projectId, Long groupId, Long taskId) {
		LOGGER.debug("[SERVICE] getBoardListCount Started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("projectId", projectId);
		map.put("groupId", groupId);
		map.put("taskId", taskId);
		
		LOGGER.debug("[SERVICE] getBoardListCount Ended");
		return ezPMSDAO.getBoardListCount(map);
	}
	
	@Transactional
	@Override
	public ProjectBoardVO getBoardDetail(int tenantId, Map<String, Object> map) {
		LOGGER.debug("[SERVICE] getBoardDetail started");
		
		map.put("tenantId", tenantId);
		ProjectBoardVO boardVO = ezPMSDAO.getBoardDetail(map);
		
		if(ezPMSDAO.checkReadBoardOrNot(map) == -1) {
			ezPMSDAO.insertReadBoardLog(map);
			if(!boardVO.getWriterId().equals(map.get("userId"))) {
				ezPMSDAO.updateBoardReadCount((int) map.get("itemId"));
			}
		}
		boardVO.setFileList(ezPMSDAO.getBoardAttach(map));
		
		LOGGER.debug("[SERVICE] getBoardDetail ended");
		return boardVO;
	}
	
	@Override
	public List<ProjectInfoVO> getProgressProject(String status) throws Exception{
		LOGGER.debug("getProgressProject Started");
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("status", "P");
		map.put("lang", ""); //수정 필요
		List<ProjectInfoVO> projectList = ezPMSDAO.getProgressProject(map);
		
		LOGGER.debug("getProgressProject Ended");
		return projectList;
	}

	// 파일 이동 함수
	private void fileMove(String beforeFilePath, String afterFilePath) throws Exception {
		LOGGER.debug("fileMove started.");
		LOGGER.debug("beforeFilePath = " + beforeFilePath + " || afterFilePath = " + afterFilePath);
		
		File srcFile = new File(beforeFilePath);
		File destFile = new File(afterFilePath);
		
		try {
			boolean rename = srcFile.renameTo(destFile);
			if (!rename) {
				FileUtils.copyFile(srcFile, destFile);
				if (!srcFile.delete()) {
					FileUtils.deleteQuietly(destFile);
					throw new IOException("Failed to delete original file '" + srcFile +
							"' after copy to '" + destFile + "'");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		LOGGER.debug("fileMove ended.");
	}

	@Override
	public String getUserTaskRole(String userId, int tenantId, long taskId) {
		LOGGER.debug("[SERVICE] getUserTaskRole started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("taskId", taskId);
		
		String userTaskRole = ezPMSDAO.getUserTaskRole(map);
		
		LOGGER.debug("[SERVICE] getUserTaskRole ended");
		return userTaskRole;
	}
	
	@Override
	public List<Map<String, Object>> getFilePath(long itemId, int tenantId) {
		LOGGER.debug("[SERVICE] getFilePath started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("itemId", itemId);
		
		List<Map<String, Object>> fileList = ezPMSDAO.getFilePath(map);
		LOGGER.debug("[SERVICE] getFilePath ended");
		
		return fileList;
	}
}
