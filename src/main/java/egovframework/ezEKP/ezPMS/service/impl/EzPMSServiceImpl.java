package egovframework.ezEKP.ezPMS.service.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.swing.SortOrder;

import org.apache.tools.ant.Project;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.icu.text.SimpleDateFormat;

import egovframework.ezEKP.ezPMS.dao.EzPMSDAO;
import egovframework.ezEKP.ezPMS.service.EzPMSAdminService;
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
import egovframework.ezMobile.ezCommon.web.MCommonGWController;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
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
			Map<String, Object> search, String offset, String lang) {
		LOGGER.debug("[SERVICE] getProjectList started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("offset", offset);
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
				}
			}
		} catch (Exception e) {
			LOGGER.debug("ERROR : " + e.getMessage());
		}
		
		LOGGER.debug("[SERVICE] getProjectList ended.");
		return projectList;
	}

	@Override
	public int addNewProject(Map<String, Object> map) {
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
		
		int projectId = ezPMSDAO.addNewProject(map);
		LOGGER.debug("[SERVICE] addNewProject ended.");
		return projectId;
	}

	@Override
	public void deleteProject(int tenantId, int projectId) {
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
	public void updateProjectStatus(int projectId, String status, int tenantId, String realStartDate, String planEndDate) {
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
	public ProjectInfoVO getProjectDetails(int projectId, String userId, int tenantId, String mode, String lang, String deptId) {
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
		
		List<ProjectMemberVO> member = ezPMSDAO.getProjectMemberList(map);
		project.setProjectMember(member);
		
		LOGGER.debug("getProjectDetail ended");
		
		return project;
	}

	@Override
	public void updateProject(ProjectInfoVO project, int tenantId) {
		LOGGER.debug("Service updateProject Started.");
		
		Map<String, Object> map = new HashMap<>();
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
	public List<ProjectMemberVO> getProjectMemberList(int projectId, int roleId, String lang, int tenantId) {
		LOGGER.debug("getProjectMemberList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("projectId", projectId);
		param.put("roleId", roleId);
		param.put("lang", lang);
		param.put("tenantId", tenantId);
		param.put("isGantt", 0);
		
		List<ProjectMemberVO> list = ezPMSDAO.getProjectMemberList(param);
		
		LOGGER.debug("getProjectMemberList ended");
		return list;
	}

	@Override
	public List<ProjectTaskVO> getMyTasks(int projectId, String status, int tenantId, String userId, String offset, String lang) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ProjectTaskVO> getProjectTasks(int projectId, String status, int tenantId, String offset, String lang) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void changeKanbanOrder(int projectId, String userId, String orderStatus, int tenantId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public int addFavoriteProject(int projectId, String userId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		List<Integer> favoriteProjectId = ezPMSDAO.getFavoriteProject(map);
		
		for (int i = 0; i < favoriteProjectId.size(); i++) {
			if (projectId == favoriteProjectId.get(i)) {
				return 1;
			}
		}
		
		ezPMSDAO.addFavoriteProject(map);
		return 0;
	}

	@Override
	public void deleteFavortieProject(int projectId, String userId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectId", projectId);
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		ezPMSDAO.deleteFavoriteProject(map);
		
	}

	@Override
	public void addTaskLog(TaskLogListVO taskLog, int tenantId, String userId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<TaskLogListVO> getTaskLogList(int taskId, int groupId, Map<String, Object> map, String offset, String lang, int tenantId) {
		// TODO Auto-generated method stub
		return null;
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
	public int getTaskListCount(String status, String mytask, int projectId, int tenantId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int getTaskLogListCount(TaskLogListVO taskLog, int tenantId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int getMemberCount(int projectId, int roleId, int tenantId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getKanbanOrder(int projectId, String userId, int tenantId) {
		LOGGER.debug("[SERVICE] getKanbanOrder started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		
		String kanbanOrder = ezPMSDAO.getKanbanOrder(map);
		
		if (kanbanOrder == null || kanbanOrder.equals("")) {
			//default : 나의 전체업무, 전체 진행중인업무, 전체 완료된업무, 게시판
			kanbanOrder = "MA,P,C,B";
		}
		
		LOGGER.debug("[SERVICE] getKanbanOrder ended.");
		return kanbanOrder;
	}

	@Override
	public List<String> getProjectNameList(String userId, int tenantId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ProjectTaskVO> getTaskList(SearchVO search) {
		LOGGER.debug("[SERVICE] getTaskList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", "juhongsun");
		param.put("projectId", search.getProjectId());
		param.put("taskName", search.getTaskName());
		param.put("upperGroupName", search.getUpperGroupName());
		param.put("headManagerName", search.getMemberId());
		param.put("overview", search.getOverview());
		param.put("planStartDate", search.getPlanStartDate());
		param.put("planEndDate", search.getPlanEndDate());
		param.put("lang", ""); //파라미터로 받아와야함.
		param.put("status", search.getStatus());
		param.put("tenantId", search.getTenantId());
		
		List<ProjectTaskVO> list = ezPMSDAO.getTaskList(param);
		
		LOGGER.debug("[SERVICE] getTaskList ended");
		return list;
	}

	@Override
	public List<ProjectGroupVO> getGroupList(SearchVO search) {
		// TODO Auto-generated method stub
		return null;
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
	public List<ProjectMemberScheduleVO> getMemberScheduleList(int projectId, String startDate, String endDate) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProjectTaskVO getTaskDetails(int taskId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int updateTask(ProjectTaskVO task) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteTask(int taskId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void addGroup(Map<String, Object> map) {
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
		
	}

	@Override
	public ProjectGroupVO getGroupDetails(int groupId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int updateGroup(ProjectGroupVO group) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteGroup(int groupId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getUserRole(String userId, int projectId, int tenantId) {
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
		
		
		LOGGER.debug("[mainSetting] userMail : " + mainSetting.getUserMail());
		LOGGER.debug("[SERVICE] getProjectMainSetting ended.");
		return mainSetting;
	}

	@Override
	public List<ProjectTaskTreeVO> getProjectTaskTree(int projectId, String onlyGroup) {
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("project_Id", projectId);
		
		List<ProjectTaskTreeVO> list = ezPMSDAO.getProjectGroupTree(map);
		
		for(int i = 0; i < list.size(); i++) {
			ProjectTaskTreeVO vo = list.get(i);
			vo.setIcon("jstree-folder");
			if(vo.getParent().equals("0")) {
				vo.setParent("#");
			}
		}
		
		if(onlyGroup.equals("false")) {
			List<ProjectTaskTreeVO> list2 = ezPMSDAO.getProjectTaskTree(map);
			
			for(int i = 0; i < list2.size(); i++) {
				ProjectTaskTreeVO vo = list2.get(i);
				vo.setIcon("jstree-file");
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
		
		HashMap<String, Object> param = new HashMap<>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		param.put("userIdType", userIdType);
		
		userInfo = ezPMSDAO.getUserInfo(param);
		
		LOGGER.debug("Service getUserInfo Ended");
		return userInfo;
	}
	
	//유저의 프로젝트 role 확인
	@Override
	public List<Integer> getUserProjectRole (String userId, int tenantId, int projectId, String deptId) {
		LOGGER.debug("[SERVICE] getUserProjectRole started");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		param.put("projectId", projectId);	
		param.put("deptId", deptId);
		
		List<Integer> projectRole = ezPMSDAO.getUserProjectRole(param);
		LOGGER.debug("[SERVICE] getUserProjectRole ended");
		return projectRole;
	}
	
	@Override
	public List<ProjectMemberVO> getProjectMember(int projectId, int roleId, String lang) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void addProjectMember(ProjectMemberVO projectMemberList, int tenantId) {		
		LOGGER.debug("[SERVICE] ezPMS addProjectMember Started");
		HashMap<String, Object> map = new HashMap<>();
		
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
		HashMap<String, Object> map = new HashMap<>();
		map.put("taskId", taskId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		
		List<TaskMemberVO> taskMemberList = ezPMSDAO.getTaskMemberList(map);
		LOGGER.debug("[SERVICE] ezPMS getTaskMemberList Ended");
		return taskMemberList;
	}

	@Override
	public void deleteProjectMember(int projectId, int tenantId) {
		LOGGER.debug("[SERVICE] deleteProjectMember Started");
		HashMap<String, Object> map = new HashMap<>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		
		ezPMSDAO.deleteProjectMember(map);
		
		LOGGER.debug("[SERVICE] deleteProjectMember Ended");
	}

	@Override
	public void updateProjectRealStartDate(int projectId, int tenantId, String realStartDate) {
		LOGGER.debug("[SERVICE] updateProjectRealStartDate Started");
		HashMap<String, Object> map = new HashMap<>();
		map.put("projectId", projectId);
		map.put("tenantId", tenantId);
		map.put("realStartDate", realStartDate);
		
		ezPMSDAO.updateProjectRealStartDate(map);
		LOGGER.debug("[SERVICE] updateProjectRealStartDate Ended");
	}

//	by mslim
	@Override
	public void addBoard(ProjectBoardVO vo) {
		LOGGER.debug("[SERVICE] addBoard Started");
		ezPMSDAO.addBoard(vo);
		LOGGER.debug("[SERVICE] addBoard Started");
	}
}
