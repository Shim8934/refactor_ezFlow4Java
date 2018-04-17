package egovframework.ezEKP.ezPMS.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectListVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberScheduleVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskListVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.SearchVO;
import egovframework.ezEKP.ezPMS.vo.TaskLogListVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;

public interface EzPMSService {

	public List<ProjectListVO> getProjectList(int tenantId, MCommonVO userInfo, String status, Map<String, Object> map);
	
	public void addNewProject(JSONObject newProject, int tenantId);
	
	public void deleteProject(int tenantId, int projectId);
	
	public void updateMainSetting(JSONObject project, int tenantId);
	
	public void updateProjectStatus(int projectId, String status, int tenantId);
	
	public ProjectListVO getProjectDetails(int projectId, String uerId, int tenantId);
	
	public void updateProject(int projectId, Map<String, Object> map);
	
	public List<ProjectMemberVO> getProjectMember(int projectId, int roleId);
	
	public List<ProjectTaskListVO> getMyTasks(int projectid, String status, int tenantId, String suerId);
	
	public List<ProjectTaskListVO> getProjectTasks(int projectId, String status, int tenantId);
	
	public void changeKanbanOrder(int projectId, String userId, String orderStatus);
	
	public void addFavoriteProject(int projectId, String userId);
	
	public void deleteFavortieProject(int projectId, String userId);
	
	public void addTaskLog(JSONObject taskLog, int tenantId, String userId);
	
	public List<TaskLogListVO> getTaskLogList(int taskId, int groupId, Map<String, Object> map);
	
	public int getProjectListCount(JSONObject project, int tenantId);
	
	public int getTaskListCount(String status, boolean mytask, int projectId, int tenantId);
	
	public int getTaskLogListCount(JSONObject taskLog, int tenantId);
	
	public int getMemberCount(int projectId, int roleId, int tenantId);
	
	public String getKanbanOrder(int projectId, String userId, int tenantId);
	
	public List<String> getProjectNameList(String userId, int tenantId);
	
	public List<ProjectTaskVO> getTaskList(SearchVO search);
	
	public List<ProjectGroupVO> getGroupList(SearchVO search);
	
	public int addTask(ProjectTaskVO task);
	
	public List<ProjectMemberScheduleVO> getMemberScheduleList(int projectId, String startDate, String endDate);
	
	public ProjectTaskVO getTaskDetails(int taskId);
	
	public int updateTask(ProjectTaskVO task);
	
	public int deleteTask(int taskId);
	
	public int addGroup(ProjectGroupVO group);
	
	public ProjectGroupVO getGroupDetails(int groupId);
	
	public int updateGroup(ProjectGroupVO group);
	
	public int deleteGroup(int groupId);
	
	public String getUserRole(String userId, int projectId, int tenantId);
}
