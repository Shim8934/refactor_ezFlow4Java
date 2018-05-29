package egovframework.ezEKP.ezPMS.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
import egovframework.ezEKP.ezPMS.vo.ProjectBoardVO;
import egovframework.ezEKP.ezPMS.vo.ProjectCompanyVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
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

public interface EzPMSService {

	public List<ProjectInfoVO> getProjectList(int tenantId, String userId, String deptId, String status, Map<String, Object> search, String lang);
	
	public Long addNewProject(Map<String, Object> map);
	
	public void deleteProject(int tenantId, Long projectId);
	
	public void updateMainSetting(ProjectMainSettingVO project, int tenantId);
	
	public void updateProjectStatus(Long projectId, String status, int tenantId, String realStartDate, String planEndDate);
	
	public ProjectInfoVO getProjectDetails(Long projectId, String userId, int tenantId, String mode, String lang, String deptId);
	
	public void updateProject(ProjectInfoVO project, int tenantId);
	
	public List<ProjectMemberVO> getProjectMember(Long projectId, int roleId, String lang);

	public void changeKanbanOrder(Long projectId, String userId, String orderStatus, int tenantId);
	
	public int addFavoriteProject(Long projectId, String userId, int tenantId);
	
	public void deleteFavoriteProject(Long projectId, String userId, int tenantId);
	
	public void addTaskLog(TaskLogListVO taskLog, int tenantId, String userId);
	
	public List<TaskLogListVO> getTaskLogList(Long taskId, Map<String, Object> map, String offset, String lang, int tenantId) throws Exception ;
	
	public int getProjectListCount(ProjectInfoVO project, int tenantId, String userId, String deptId, String lang);
	
	public int getTaskListCount(SearchVO search, String userId);
	
	public int getTaskLogListCount(TaskLogListVO taskLog, int tenantId);
	
	public int getMemberCount(Long projectId, int roleId, int tenantId);
	
	public String getKanbanOrder(Long projectId, String userId, int tenantId);
	
	public List<String> getProjectNameList(String userId, int tenantId);
	
	public List<ProjectTaskVO> getTaskList(SearchVO search, String userId, int limit, int startRow, String orderWhat, String orderHow);
	
	public List<ProjectGroupVO> getGroupList(SearchVO search, String orderWhat, String orderHow, int startRow, int limit, String lang);
	
	public int addTask(ProjectTaskVO taskVO, List<TaskMemberVO> taskMemberList);
	
	public List<ProjectMemberScheduleVO> getMemberScheduleList(Long projectId, String startDate, String endDate);
	
	public ProjectTaskVO getTaskDetails(Long taskId, int tenantId, String lang);
	
	public int updateTask(ProjectTaskVO task);
	
	public void deleteTask(Long taskId, long projectId, int tenantId);

	public void updateTaskInfo(ProjectTaskVO task);
	
	public void addGroup(Map<String, Object> map);
	
	public ProjectGroupVO getGroupDetails(Long groupId);
	
	public int updateGroup(ProjectGroupVO group);
	
	public int deleteGroup(Long groupId);
	
	public String getUserRole(String userId, Long projectId, int tenantId);
	
	public ProjectMainSettingVO getProjectMainSetting(String userId, int tenantId, String userIdType);
	
	public List<ProjectTaskTreeVO> getProjectTaskTree(Long projectId, String onlyGroup, String location, int tenantId, String userId);

	public List<ProjectUserVO> getDeptUserList(int tenantId, String key, String value, String lang) throws Exception;

	public List<ProjectCompanyVO> getCompanyList(String userId, int tenantId, String companyId, String lang) throws Exception;

	public List<DeptViewVO> getDeptViewList(String userId, String companyId, int tenantId, String lang) throws Exception;
	
	public List<ProjectMemberVO> getProjectMemberList(Long projectId, int roleId, String lang, int tenantId, int isGantt);

	public void addProjectMember(ProjectMemberVO projectMemberList, int tenantId);

	public ProjectMemberVO getUserInfo(String userId, int tenantId, String userIdType) throws Exception;
	
	public Map<String, Object> getRemainingWeight(String projectId);

	public int getUserProjectRole(String userId, int tenantId, Long projectId, String deptId);
	
	public List<TaskMemberVO> getTaskMemberList(int tenantId, long taskId, String lang);

	public void deleteProjectMember(Long projectId, int tenantId);
	
	public void deleteTaskMember(Long taskId, int tenantId);

	public void updateProjectRealDate(Long projectId, int tenantId, String realStartDate, String status, String planEndDate);

	public void addKanbanOrder(Long projectId, String userId, String orderStatus, int tenantId);

	public void completeAllTasks(long projectId, int tenantId, String realEndDate, String planEndDate);

	public void addBoard(JSONObject jsonParam, String realPath) throws Exception;
	
	public void deleteBoard(int tenantId, JSONObject jsonParam) throws Exception;
	
	public List<ProjectBoardVO> getBoardList(int tenantId, Long projectId, Long groupId, Long taskId, String userId, int startRow, int limit, String lang);
	
	public int getBoardListCount(int tenantId, Long projectId, Long groupId, Long taskId);
	
	public ProjectBoardVO getBoardDetail(int tenantId, Map<String, Object> param);

	List<ProjectInfoVO> getProgressProject(String status) throws Exception;

	public String getUserTaskRole(String userId, int tenantId, long taskId);

	List<Map<String, Object>> getFilePath(long itemId, int tenantId);

	public int getGroupCount(SearchVO search, int tenantId, String userId);
}
