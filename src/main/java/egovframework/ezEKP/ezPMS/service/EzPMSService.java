package egovframework.ezEKP.ezPMS.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
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
import egovframework.ezMobile.ezOption.vo.MCommonVO;

public interface EzPMSService {

	public List<ProjectInfoVO> getProjectList(int tenantId, MCommonVO userInfo, String status, Map<String, Object> map, String offset, String lang);
	
	public void addNewProject(ProjectInfoVO newProject, String tenantId);
	
	public void deleteProject(int tenantId, int projectId);
	
	public void updateMainSetting(ProjectMainSettingVO project, int tenantId);
	
	public void updateProjectStatus(int projectId, String status, int tenantId);
	
	public ProjectInfoVO getProjectDetails(int projectId, String userId, int tenantId, String offset, String lang);
	
	public void updateProject(ProjectInfoVO project, int tenantId);
	
	public List<ProjectMemberVO> getProjectMember(int projectId, int roleId, String lang);
	
	public List<ProjectTaskVO> getMyTasks(int projectId, String status, int tenantId, String userId, String offset, String lang);
	
	public List<ProjectTaskVO> getProjectTasks(int projectId, String status, int tenantId, String offset, String lang);
	
	public void changeKanbanOrder(int projectId, String userId, String orderStatus, int tenantId);
	
	public void addFavoriteProject(int projectId, String userId, int tenantId);
	
	public void deleteFavortieProject(int projectId, String userId, int tenantId);
	
	public void addTaskLog(TaskLogListVO taskLog, int tenantId, String userId);
	
	public List<TaskLogListVO> getTaskLogList(int taskId, int groupId, Map<String, Object> map, String offset, String lang, int tenantId);
	
	public int getProjectListCount(ProjectInfoVO project, int tenantId);
	
	public int getTaskListCount(String status, String mytask, int projectId, int tenantId);
	
	public int getTaskLogListCount(TaskLogListVO taskLog, int tenantId);
	
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
	
	public ProjectMainSettingVO getProjectMainSetting(String userId, int tenantId);
	
	public List<ProjectTaskTreeVO> getProjectTaskTree(int projectId);

	List<ProjectUserVO> getDeptUserList(int tenantId, String key, String value, String lang) throws Exception;

	List<ProjectCompanyVO> getCompanyList(String userId, int tenantId, String companyId, String lang) throws Exception;

	List<DeptViewVO> getDeptViewList(String userId, String companyId, int tenantId, String lang) throws Exception;

	public void addProjectMember(ProjectInfoVO newProject, String parameter);

}
