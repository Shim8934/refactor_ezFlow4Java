package egovframework.ezEKP.ezPMS.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezPMS.vo.BoardViewerVO;
import egovframework.ezEKP.ezPMS.vo.CommentVO;
import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
import egovframework.ezEKP.ezPMS.vo.ProjectBoardVO;
import egovframework.ezEKP.ezPMS.vo.ProjectCompanyVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupMemberVO;
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

	public List<ProjectInfoVO> getProjectList(int tenantId, String userId, String deptId, String status, Map<String, Object> search, String lang, String position, String companyId);
	
	public Long addNewProject(Map<String, Object> map);
	
	public void deleteProject(int tenantId, Long projectId);
	
	public void updateMainSetting(ProjectMainSettingVO project, int tenantId);
	
	public void updateProjectStatus(Long projectId, String status, int tenantId, String realStartDate, String planEndDate);
	
	public ProjectInfoVO getProjectDetails(Long projectId, String userId, int tenantId, String mode, String lang, String deptId, String comapnyId);
	
	public void updateProject(ProjectInfoVO project, int tenantId, String companyId);
	
	public List<ProjectMemberVO> getProjectMember(Long projectId, int roleId, String lang);

	public void changeKanbanOrder(Long projectId, String userId, String orderStatus, int tenantId);
	
	public int addFavoriteProject(Long projectId, String userId, int tenantId);
	
	public void deleteFavoriteProject(Long projectId, String userId, int tenantId);
	
	public void addTaskLog(TaskLogListVO taskLog, int tenantId, String userId);
	
	public List<TaskLogListVO> getTaskLogList(Long taskId, Map<String, Object> map, String offset, String lang, int tenantId) throws Exception ;
	
	public int getProjectListCount(ProjectInfoVO project, int tenantId, String userId, String deptId, String lang, String position);
	
	public int getTaskListCount(SearchVO search, String userId, int roleId);
	
	public int getTaskLogListCount(TaskLogListVO taskLog, int tenantId);
	
	public int getMemberCount(Long projectId, int roleId, int tenantId);
	
	public String getKanbanOrder(Long projectId, String userId, int tenantId);
	
	public List<String> getProjectNameList(String userId, int tenantId);
	
	public List<ProjectTaskVO> getTaskList(SearchVO search, String userId, int limit, int startRow, String orderWhat, String orderHow, String location, int roleId);
	
	public List<ProjectGroupVO> getGroupList(SearchVO search, String orderWhat, String orderHow, int startRow, int limit, String lang, String location);
	
	public int addTask(ProjectTaskVO taskVO, List<TaskMemberVO> taskMemberList, String companyId, int tenantId);
	
	public List<ProjectMemberScheduleVO> getMemberScheduleList(Long projectId, String startDate, String endDate);
	
	public ProjectTaskVO getTaskDetails(Long taskId, int tenantId, String lang);
	
	public int updateTask(ProjectTaskVO task, String companyId, int tenantId);
	
	public void deleteTask(Long taskId, long projectId, int tenantId, String companyId) throws Exception;

	public void updateTaskInfo(ProjectTaskVO task, String companyId, int tenantId);

	public void updateTaskStatus(ProjectTaskVO task, String companyId, int tenantId);
	
	public Long addGroup(Map<String, Object> map, String isIssue, String companyId, int tenantId);
	
	public ProjectGroupVO getGroupDetails(long groupId, int tenantId, long projectId) throws Exception;
	
	public void updateGroup(ProjectGroupVO group);
	
	public void deleteGroup(long projectId, long groupId, int tenantId);
	
	public String getUserRole(String userId, Long projectId, int tenantId);
	
	public ProjectMainSettingVO getProjectMainSetting(String userId, int tenantId, String userIdType);
	
	public List<ProjectTaskTreeVO> getProjectTaskTree(Long projectId, String onlyGroup, String location, int tenantId, String userId);

	public List<ProjectUserVO> getDeptUserList(int tenantId, String key, String value, String lang) throws Exception;

	public List<ProjectCompanyVO> getCompanyList(String userId, int tenantId, String companyId, String lang) throws Exception;

	public List<DeptViewVO> getDeptViewList(String userId, String companyId, int tenantId, String lang) throws Exception;
	
	public List<ProjectMemberVO> getProjectMemberList(Long projectId, int roleId, String lang, int tenantId, int isGantt);

	public void addProjectMember(ProjectMemberVO projectMemberList, int tenantId);

	public ProjectMemberVO getUserInfo(String userId, int tenantId, String userIdType) throws Exception;
	
	public Map<String, Object> getRemainingWeight(String projectId, int tenantId);

	public int getUserProjectRole(String userId, int tenantId, Long projectId, String deptId);
	
	public List<TaskMemberVO> getTaskMemberList(int tenantId, long taskId, String lang);

	public void deleteProjectMember(Long projectId, int tenantId);
	
	public void deleteTaskMember(Long taskId, int tenantId);

	public void updateProjectRealDate(Long projectId, int tenantId, String realStartDate, String status, String planEndDate, String companyId);

	public void addKanbanOrder(Long projectId, String userId, String orderStatus, int tenantId);

	public void completeAllTasks(long projectId, int tenantId, String realEndDate, String planEndDate, String companyId);

	public void addBoard(JSONObject jsonParam, String realPath) throws Exception;
	
	public void modifyBoard(JSONObject jsonParam, String realPath) throws Exception;
	
	public void moveBoard(JSONObject jsonParam) throws Exception;
	
	public void deleteBoard(int tenantId, JSONObject jsonParam) throws Exception;
	
	public List<ProjectBoardVO> getBoardList(int tenantId, Long projectId, Long groupId, Long taskId, String userId, int startRow, int listCnt, 
											String lang, String position, String orderWhat, String orderHow, String searchByTaskName, 
											String searchByUser, String searchByStartDate, String searchByEndDate, String searchByTitle, 
											String searchByOverview, String searchByContent);
	
	public int getBoardListCount(int tenantId, Long projectId, Long groupId, Long taskId, String searchByTaskName, String searchByUser, 
								String searchByStartDate, String searchByEndDate, String searchByTitle, String searchByOverview, 
								String searchByContent);
	
	public List<ProjectBoardVO> getBoardNoticeList(int tenantId, Long projectId, Long groupId, Long taskId, int startRow, int listCnt, String lang);
	
	public int getBoardNoticeListCount(int tenantId, Long projectId, Long groupId, Long taskId);
	
	public ProjectBoardVO getBoardDetail(int tenantId, Map<String, Object> param);

	List<ProjectInfoVO> getProgressProject(String status) throws Exception;

	public String getUserTaskRole(String userId, int tenantId, long taskId);
	
	List<Map<String, Object>> getFilePath(long itemId, int tenantId);

	public int getGroupCount(SearchVO search, int tenantId, String userId);

	public void addGroupMember(List<ProjectGroupMemberVO> groupMemberList);
	
	public List<ProjectGroupMemberVO> getUserInfoForGroup(HashMap<String, Object> map);

	public int getUserGroupRole(String userId, int tenantId, long projectId, long groupId);

	public int getBoardViewerCount(int tenantId, String itemId);

	public List<BoardViewerVO> getBoardViewerList(int tenantId, Map<String, Object> param);

	public void addPreTaskRel(long taskId, int pretaskId, long projectId, int tenantId, String type);
	
	public List<Long> getPreTaskRel(int rowIndex, int tenantId, long projectId);
	
	public List<CommentVO> getCommentList(Map<String, Object> param);
	
	public int getCommentListCount(Map<String, Object> param);
	
	public void addComment(JSONObject jsonParam);

	public void deleteComment(int tenantId, JSONObject jsonParam) throws Exception;
	
	public void modifyComment(JSONObject jsonParam) throws Exception;
	
	public List<ProjectGroupMemberVO> getGroupMemberList(Long projectId, int tenantId, Long groupId);
	
	public Float getGroupWeight(Long groupId, int tenantId) throws Exception;
	
	public void updateTaskWeight(ProjectTaskVO taskVO) throws Exception;

	public void updateGroupSort(long projectId, long groupId, int sortOrder, int tenantId);

	public void updateTaskSort(long groupId, long taskId, int sortOrder, int tenantId);

	public void updatePreTaskRel(Map<String, Object> map);

	void updateTaskWDNW(ProjectTaskVO taskVO, float taskWorkingday);

	public void updateTaskGroupId(long projectId, long targetTaskId, long changeGroupId, int tenantId);

	public Float getProjectWeight(Long projectId, int tenantId) throws Exception;
	
	public int getWorkingDays(Date start, Date end, String companyId, int tenantId) throws Exception;
	
	public float getPlanProgress(Date start, Date end, String companyId, int tenantId) throws Exception;
	
	public void updateGroupProgress(long projectId, long groupId, int tenantId) throws Exception;
	
	public void updateGroupDate(long groupId, int tenantId, String companyId) throws Exception;
	
	public ProjectGroupVO getGroupBoundaryDate(long groupId, int tenantId) throws Exception;
	
	public void updateTaskProgress(ProjectTaskVO taskVO) throws Exception;
	
	public String getAncesterGroup(Long groupId, int tenantId) throws Exception;
	
	public void updateProjectDate(long projectId, int tenantId, String companyId) throws Exception;
	
	public ProjectInfoVO getProjectBoundaryDate(long projectId, int tenantId) throws Exception;

	public List<ProjectMemberScheduleVO> getMemberSchedule(long projectId, int tenantId, String lang);

	public void addMemberSchedule(String memberId, int tenantId, String assignedDate, String projectId);
	
	public List<ProjectTaskVO> getTaskListByGroupId(int tenantId, long groupId);
	
	public Date addWorkingDays(Date date, int offset, String companyId, int tenantId);

	public List<String> getDateTaskList(long projectId, String date, String selUserId, String lang, int tenantId);

	public boolean checkIfBoardHasReplies(JSONObject jsonParam);

	public ProjectGroupVO getUpperGroupDate(long groupId, int tenantId) throws Exception;

	Long getUpperGroupId(long groupId, long projectId, int tenantId);
	
	public ProjectTaskVO getTaskSchedule(Map<String, Object> map);
	
	public ProjectGroupVO getGroupSchedule(Map<String, Object> map);
	
	public int checkIfHasPreTaskRel(Map<String, Object> map);
	
	public boolean checkIfPreTaskRelExist(Map<String, Object> map);
	
	public void deletePreTaskRelInTask(Map<String, Object> map);

	public void deletePreTaskRelInGroup(Map<String, Object> map);
	
	public List<TaskMemberVO> getTaskMemberListInGroup(int tenantId, long groupId, String lang)  throws Exception;

	public void deleteGroupMember(Long projectId, long groupId, int tenantId);
	
	public void updateAllTaskDatesInPrj(Map<String, Object> map);
	
	public void updateAllGroupDatesInPrj(Map<String, Object> map);
	
	public void updateTaskStatusScheduler(String UTCTimeStr) throws Exception;

	public void updateProjectGroupEndDate(long projectId, String changeEndDate, int tenantId, long groupId);
	
	public void updateAllTaskWeight(Map<String, Object> map) throws Exception;
}
