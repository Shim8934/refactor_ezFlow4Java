package egovframework.ezEKP.ezPMS.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPMS.vo.BoardViewerVO;
import egovframework.ezEKP.ezPMS.vo.CommentVO;
import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
import egovframework.ezEKP.ezPMS.vo.FileVO;
import egovframework.ezEKP.ezPMS.vo.ProjectBoardFolderVO;
import egovframework.ezEKP.ezPMS.vo.ProjectBoardVO;
import egovframework.ezEKP.ezPMS.vo.ProjectCompanyVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectHolidayVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMainSettingVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskTreeVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.ProjectUserVO;
import egovframework.ezEKP.ezPMS.vo.TaskLogListVO;
import egovframework.ezEKP.ezPMS.vo.TaskMemberVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPMSDAO")
public class EzPMSDAO extends EgovAbstractDAO {
	
	/**
	 * 업무 트리 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ProjectTaskTreeVO> getProjectTaskTree(Map<String, Object> map) {
		return (List<ProjectTaskTreeVO>) list("EzPMSDAO.getProjectTaskTree", map);
	}
	
	/**
	 * 그룹 트리 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ProjectTaskTreeVO> getProjectGroupTree(Map<String, Object> map) {
		return (List<ProjectTaskTreeVO>) list("EzPMSDAO.getProjectGroupTree", map);
	}

	/**
	 * 회사 리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ProjectCompanyVO> getCompanyList(Map<String, Object> map){
		return (List<ProjectCompanyVO>) list("EzPMSDAO.selectCompanyList",map);
	}
	
	/**
	 * 조직도에 쓸 부서리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DeptViewVO> getDeptViewVO(Map<String, Object> map){
		return (List<DeptViewVO>) list("EzPMSDAO.selectDeptList",map);
	}
	
	/**
	 * 해당부서의 사원 리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ProjectUserVO> getDeptUserList(Map<String, Object> map){
		return (List<ProjectUserVO>) list("EzPMSDAO.selectUserList",map);
	}

	/**
	 * 프로젝트 멤버 리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ProjectMemberVO> getProjectMemberList(Map<String, Object> map) {
		return (List<ProjectMemberVO>) list("EzPMSDAO.getProjectMember", map);
	}

	public Long addNewProject(Map<String, Object> map) {
		return (Long) insert("EzPMSDAO.addNewProject", map);
	}
	
	public ProjectMemberVO getUserInfo(HashMap<String, Object> map) {
		return (ProjectMemberVO) select("EzPMSDAO.getUserInfo", map);
	}

	public void addProjectMember(HashMap<String, Object> map) {
		insert("EzPMSDAO.addProjectMember", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getRemainingWeight(Map<String, Object> map) {
		return (Map<String, Object>) select("EzPMSDAO.getRemainingWeight", map);
	}
	
	/**
	 * 프로젝트관리 메인 환경설정 리스트 가져오기 (+메일)
	 */
	public ProjectMainSettingVO getProjectMainSetting(Map<String, Object> map) {
		return (ProjectMainSettingVO) select("EzPMSDAO.getProjectMainSetting", map);
	}

	@SuppressWarnings("unchecked")
	public List<ProjectInfoVO> getProjectList(Map<String, Object> map) {
		return (List<ProjectInfoVO>) list("EzPMSDAO.getProjectList", map);
	}
	
	public Long addTask(ProjectTaskVO vo) {
		return (Long) insert("EzPMSDAO.addTask", vo);
	}
	
	public void addTaskMember(List<TaskMemberVO> list) {
		insert("EzPMSDAO.addTaskMember", list);
	}
	
	public int getProjectWorkingday (ProjectTaskVO taskVO) {
		return (int) select("EzPMSDAO.getProjectWorkingday", taskVO);
	}
	
	public void updateProjectWorkingdaySum (Map<String, Object> map) {
		update("EzPMSDAO.updateProjectWorkingdaySum", map);
	}
	
	public void updateTaskWDNW (Map<String, Object> map) {
		update("EzPMSDAO.updateTaskWDNW", map);
	}

	public int getSortOrder(String upperGroupId) {
		return (int) select("EzPMSDAO.getSortOrder", upperGroupId);
	}
	
	public ProjectInfoVO getProjectDetails(Map<String, Object> map) {
		return (ProjectInfoVO) select("EzPMSDAO.getProjectDetails", map); 
	}
	
	@SuppressWarnings("unchecked")
	public List<ProjectTaskVO> getTaskList(Map<String, Object> map) {
		return (List<ProjectTaskVO>) list("EzPMSDAO.getTaskList", map); 
	}
	
	@SuppressWarnings("unchecked")
	public List<ProjectTaskVO> getTaskListForGantt(Map<String, Object> map) {
		return (List<ProjectTaskVO>) list("EzPMSDAO.getTaskListForGantt", map);
	}
	

	public int getProjectListCount(Map<String, Object> map) {
		return (int) select("EzPMSDAO.getProjectListCount", map);
	}
	
	public void insertMainSetting(Map<String, Object> map) {
		insert("EzPMSDAO.insertMainSetting", map);
	}
	
	public void updateMainSetting(Map<String, Object> map) {
		update("EzPMSDAO.updateMainSetting", map);
	}

	public int getUserProjectRole(Map<String, Object> map) {
		return (int) select ("EzPMSDAO.getUserProjectRole", map);
	}

	public void updateProjectStatus(Map<String, Object> map) {
		update("EzPMSDAO.updateProjectStatus", map);
	}

	public void deleteProject(Map<String, Object> map) {
		update("EzPMSDAO.deleteProject", map);
	}

	public void addFavoriteProject(Map<String, Object> map) {
		insert ("EzPMSDAO.addFavoriteProject", map);		
	}

	public void deleteFavoriteProject(Map<String, Object> map) {
		delete ("EzPMSDAO.deleteFavoriteProject", map);		
	}
	
	@SuppressWarnings("unchecked")
	public List<Long> getFavoriteProject(Map<String, Object> map) {
		return (List<Long>) list("EzPMSDAO.getFavoriteProject", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<TaskMemberVO> getTaskMemberList(Map<String, Object> map) {
		return (List<TaskMemberVO>) list("EzPMSDAO.getTaskMemberList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<TaskMemberVO> getTaskMemberListForGantt(Map<String, Object> map) {
		return (List<TaskMemberVO>) list("EzPMSDAO.getTaskMemberListForGantt", map);
	}

	public void deleteProjectMember(HashMap<String, Object> map) {
		delete ("EzPMSDAO.deleteProjectMember", map);		
	}
	
	public void deleteTaskMember(Map<String, Object> map) {
		delete ("EzPMSDAO.deleteTaskMember", map);		
	}

	public void updateProjectInfo(Map<String, Object> map) {
		update ("EzPMSDAO.updateProjectInfo", map);
		
	}

	public void updateProjectRealDate(HashMap<String, Object> map) {
		update ("EzPMS.updateProjectRealDate", map);
		
	}
	
	public String getKanbanOrder(Map<String, Object> map) {
		return (String) select("EzPMSDAO.getKanbanOrder", map);
	}
	
	public Long addTaskGroup(Map<String, Object> map) {
		return (Long)insert ("EzPMSDAO.addTaskGroup", map);
	}
	
	public Integer addBoard(ProjectBoardVO vo) {
		return (Integer) insert ("EzPMSDAO.addBoard", vo);
	}
	
	public Integer getMaxDocNo(Map<String, Object> map) {
		return (Integer) select("EzPMSDAO.getMaxDocNo", map);
	}
	
	public void updateRootItemId(int itemId) {
		update("EzPMSDAO.updateRootItemId", itemId);
	}
	
	public Integer addBoardReplay(ProjectBoardVO vo) {
		return (Integer) insert ("EzPMSDAO.addBoardReply", vo);
	}
	
	public void updateBoard(Map<String, Object> map) {
		update ("EzPMSDAO.updateBoard", map);
	}
	
	public void updateBoardReplyToGeneral(Map<String, Object> map) {
		update ("EzPMSDAO.updateBoardReplyToGeneral", map);
	}
	
	public void moveBoard(Map<String, Object> map) {
		update ("EzPMSDAO.moveBoard", map);
	}
	
	public void deleteBoard(Map<String, Object> map) {
		update ("EzPMSDAO.deleteBoard", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ProjectBoardVO> getBoardList(Map<String, Object> map) {
		return (List<ProjectBoardVO>) list("EzPMSDAO.getBoardList", map);
	}
	
	public int getBoardListCount(Map<String, Object> map) {
		return (int) select("EzPMSDAO.getBoardListCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ProjectBoardVO> getBoardNoticeList(Map<String, Object> map) {
		return (List<ProjectBoardVO>) list("EzPMSDAO.getBoardNoticeList", map);
	}
	
	public int getBoardNoticeListCount(Map<String, Object> map) {
		return (int) select("EzPMSDAO.getBoardNoticeListCount", map);
	}
	
	public ProjectBoardVO getBoardDetail(Map<String, Object> param) {
		return (ProjectBoardVO) select("EzPMSDAO.getBoardDetail", param);
	}
	
	public void insertReadBoardLog(Map<String, Object> map) {
		insert("EzPMSDAO.insertReadBoardLog", map);
	}
	
	public int getBoardViewerCount(Map<String, Object> map) {
		return (int) select("EzPMSDAO.getBoardViewerCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardViewerVO> getBoardViewerList(Map<String, Object> map) {
		return (List<BoardViewerVO>) list("EzPMSDAO.getBoardViewerList", map);
	}
	
	public void updateBoardReadCount(int itemId) {
		update("EzPMSDAO.updateBoardReadCount", itemId);
	}
	
	public void addKanbanOrder(Map<String, Object> map) {
		insert ("EzPMSDAO.addKanbanOrder", map);
	}
	
	public void changeKanbanOrder(Map<String, Object> map) {
		update ("EzPMSDAO.changeKanbanOrder", map);
	
	}

	public void completeAllTasks(HashMap<String, Object> map) {
		update ("EzPMSDAO.completeAllTasks", map);
		
	}
	
	public void updateTask(Map<String, Object> map) {
		update ("EzPMSDAO.updateTask", map);
		
	}
	
	@SuppressWarnings("unchecked")
	public List<ProjectGroupVO> getGroupList(Map<String, Object> map){
		return (List<ProjectGroupVO>) list ("EzPMSDAO.getGroupList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ProjectGroupVO> getGroupListForGantt(Map<String, Object> map){
		return (List<ProjectGroupVO>) list ("EzPMSDAO.getGroupListForGantt", map);
	}
	
	public ProjectTaskVO getTaskDetails(Map<String, Object> map){
		return (ProjectTaskVO) select ("EzPMSDAO.getTaskDetails", map);
	}

	@SuppressWarnings("unchecked")
	public List<ProjectTaskVO> getMyTasks(Map<String, Object> map) {
		return (List<ProjectTaskVO>) list ("EzPMSDAO.getMyTasks", map);
	}

	public int getTaskListCount(Map<String, Object> map) {
		return (int) select ("EzPMSDAO.getTaskListCount", map);
	}

	public void addTaskLog(Map<String, Object> map) {
		insert ("EzPMSDAO.addTaskLog", map);
		
	}

	public int getTaskLogListCount(Map<String, Object> map) {
		return (int) select ("EzPMSDAO.getTaskLogListCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<TaskLogListVO> getTaskLogList(Map<String, Object> map) {
		return (List<TaskLogListVO>) list ("EzPMSDAO.getTaskLogList", map);
	}

	@SuppressWarnings("unchecked")
	public List<ProjectInfoVO> getProgressProject(HashMap<String, Object> map) {
		return (List<ProjectInfoVO>) list("EzPMSDAO.getProgressProject", map);
	}

	public void insertProjectAttach(Map<String, Object> map) {
		insert("EzPMSDAO.insertProjectAttach", map);
	}
	
	public void deleteProjectAttach(Map<String, Object> map) {
		delete("EzPMSDAO.deleteProjectAttach", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<FileVO> getBoardAttach(Map<String, Object> map) {
		return (List<FileVO>) list("EzPMSDAO.getBoardAttach", map);
	}
	
	public int checkReadBoardOrNot(Map<String, Object> map) {
		if(select("EzPMSDAO.checkReadBoardOrNot", map) == null) {
			return -1;
		} else {
			return (int) select("EzPMSDAO.checkReadBoardOrNot", map);
		}
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getStatusCount(Map<String, Object> map) {
		return (List<Map<String, Object>>) list("EzPMSDAO.getStatusCount", map);
	}

	public String getUserTaskRole(Map<String, Object> map) {
		return (String) select("EzPMSDAO.getUserTaskRole", map);
	}

	public void deleteTask(Map<String, Object> map) {
		update("EzPMSDAO.deleteTask", map);		
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getFilePath(Map<String, Object> map) {
		return (List<Map<String, Object>>) list("EzPMSDAO.getFilePath", map);
	}

	public void updateTaskInfo(ProjectTaskVO vo) {
		update ("EzPMSDAO.updateTaskInfo", vo);
	}

	public int getGroupCount(Map<String, Object> map) {
		return (int) select("EzPMSDAO.getGroupCount", map);
	}
	
	public void updateTaskStatus(ProjectTaskVO vo) {
		update ("EzPMSDAO.updateTaskStatus", vo);
	}
	
	public void addTaskGroupMember(List<ProjectGroupMemberVO> groupMember) {
		insert ("EzPMSDAO.addTaskGroupMember", groupMember);
	}
	
	@SuppressWarnings("unchecked")
	public List<ProjectGroupMemberVO> getUserInfoForGroup(HashMap<String, Object> map) {
		return (List<ProjectGroupMemberVO>) list("EzPMSDAO.getUserInfoForGroup", map);
	}

	public int getUserGroupRole(Map<String, Object> map) {
		return (int) select("EzPMSDAO.getUserGroupRole", map);
	}

	public void deleteGroup(Map<String, Object> map) {
		update("EzPMSDAO.deleteGroup", map);		
	}

	public void addPreTaskRel(Map<String, Object> map) {
		insert ("EzPMSDAO.addPreTaskRel", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommentVO> getCommentList(Map<String, Object> map) {
		return (List<CommentVO>) list("EzPMSDAO.getCommentList", map);
	}
	
	public int getCommentListCount(Map<String, Object> map) {
		return (int) select("EzPMSDAO.getCommentListCount", map);
	}
	
	public void addComment(CommentVO vo) {
		insert("EzPMSDAO.addComment", vo);
	}

	public void deleteComment(Map<String, Object> map) {
		update("EzPMSDAO.deleteComment", map);
	}
	
	public void updateComment(Map<String, Object> map) {
		update("EzPMSDAO.updateComment", map);
	}

	@SuppressWarnings("unchecked")
	public List<Long> getPreTaskRel(Map<String, Object> map) {
		return (List<Long>) list("EzPMSDAO.getPreTaskRel", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ProjectGroupMemberVO> getGroupMemberList(Map<String, Object> map) {
		return (List<ProjectGroupMemberVO>) list("EzPMSDAO.getGroupMemberList", map);
	}

	public void updateGroupSort(Map<String, Object> map) {
		update ("EzPMSDAO.updateGroupSort", map);
		
	}

	public void updateTaskSort(Map<String, Object> map) {
		update ("EzPMSDAO.updateTaskSort", map);
	}

	public void updatePreTaskRel(Map<String, Object> map) {
		update ("EzPMSDAO.updatePreTaskRel", map);
	}

	public ProjectGroupVO getGroupDetails(Map<String, Object> map) {
		return (ProjectGroupVO) select ("EzPMSDAO.getGroupDetails", map);
	}
	
	public Float getGroupWeight(Map<String, Object> map) {
		return (Float) select("EzPMSDAO.getGroupWeight", map);
	}
	
	public void updateGroupInfo(ProjectGroupVO group) {
		update ("EzPMSDAO.updateGroupInfo", group);
	}
	
	public void updateTaskWeight(ProjectTaskVO taskVO) {
		update("EzPMSDAO.updateTaskWeight", taskVO);
	}
	public void updateTaskGroupId(Map<String, Object> map) {
		update("EzPMSDAO.updateTaskGroupId", map);
	}
	
	public Float getProjectWeight(Map<String, Object> map) {
		return (Float) select("EzPMSDAO.getProjectWeight", map);
	}
	
	public void updateGroupProgress(Map<String, Object> map){
		update("EzPMSDAO.updateGroupProgress", map);
	}
	
	public void updateGroupDate(Map<String, Object> map){
		update("EzPMSDAO.updateGroupDate", map);
	}

	public ProjectGroupVO getGroupBoundaryDate(Map<String, Object> map) {
		return (ProjectGroupVO) select("EzPMSDAO.getGroupBoundaryDate", map);
	}
	
	public void updateTaskProgress(ProjectTaskVO taskVO) {
		update("EzPMSDAO.updateTaskProgress", taskVO);
	}
	
	public String getAncesterGroup(Map<String, Object> map) {
		return (String) select("EzPMSDAO.getAncesterGroup", map);
	}

	public void updateProjectProgress(ProjectTaskVO taskVO) {
		update("EzPMSDAO.updateProjectProgress", taskVO);
	}

	public ProjectInfoVO getProjectBoundaryDate(Map<String, Object> map) {
		return (ProjectInfoVO) select("EzPMSDAO.getProjectBoundaryDate", map);
	}
	
	public void updateProjectDate(Map<String, Object> map){
		update("EzPMSDAO.updateProjectDate", map);
	}
	
	public Float getProjectProgress(ProjectTaskVO taskVO) {
		return (Float) select("EzPMSDAO.getProjectProgress", taskVO);
	}
	
	@SuppressWarnings("unchecked")
	public List<TaskMemberVO> getMemberSchedule(Map<String, Object> map) {
		return (List<TaskMemberVO>) list("EzPMSDAO.getMemberSchedule", map);
	}

	@SuppressWarnings("unchecked")
	public List<ProjectTaskVO> getTaskListByGroupId(Map<String, Object> map) {
		return (List<ProjectTaskVO>) list("EzPMSDAO.getTaskListByGroupId", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getDateTaskList(Map<String, Object> map) {
		return (List<String>) list("EzPMSDAO.getDateTaskList", map);		
	}
	
	public int checkIfBoardHasReplies(Map<String, Object> map) {
		return (int) select("EzPMSDAO.checkIfBoardHasReplies", map);
	}

	public ProjectGroupVO getUpperGroupDate(Map<String, Object> map) {
		return (ProjectGroupVO) select ("EzPMSDAO.getUpperGroupDate", map);
	}
	
	public Long getUpperGroupId(Map<String, Object> map) {
		return (Long) select ("EzPMSDAO.getUpperGroupId", map);
	}
	
	public ProjectTaskVO getTaskSchedule(Map<String, Object> map) {
		return (ProjectTaskVO) select("EzPMSDAO.getTaskSchedule", map);
	}
	
	public ProjectGroupVO getGroupSchedule(Map<String, Object> map) {
		return (ProjectGroupVO) select("EzPMSDAO.getGroupSchedule", map);
	}
	
	public int checkIfHasPreTaskRel(Map<String, Object> map) {
		return (int) select("EzPMSDAO.checkIfHasPreTaskRel", map);
	}
	
//	public int checkIfPreTaskRelExist(Map<String, Object> map) {
//		return (int) select("EzPMSDAO.checkIfPreTaskRelExist", map);
//	}
	
	public void deletePreTaskRelInTask(Map<String, Object> map) {
		delete("EzPMSDAO.deletePreTaskRelInTask", map);
	}
	
	public void deletePreTaskRelInGroup(Map<String, Object> map) {
		delete("EzPMSDAO.deletePreTaskRelInGroup", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<TaskMemberVO> getTaskMemberListInGroup(Map<String, Object> map) {
		return (List<TaskMemberVO>) list("EzPMSDAO.getTaskMemberListInGroup", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getLaggingAncestorGroupIds(Map<String, Object> map) {
		return (List<String>) list("EzPMSDAO.getLaggingAncestorGroupIds", map);
	}

	public void deleteGroupMember(Map<String, Object> map) {
		delete("EzPMSDAO.deleteGroupMember", map);
	}
	
	public void updateAllTaskDatesInPrj(Map<String, Object> map) {
		update("EzPMSDAO.updateAllTaskDatesInPrj", map);
	}
	
	public void updateAllGroupDatesInPrj(Map<String, Object> map) {
		update("EzPMSDAO.updateAllGroupDatesInPrj", map);
	}
	
	public void updateProjectStatusScheduler() {
		update("EzPMSDAO.updateProjectStatusScheduler");
	}
	
	public void updateTaskStatusScheduler() {
		update("EzPMSDAO.updateTaskStatusScheduler");
	}

	public void updateProjectGroupEndDate(Map<String, Object> map) {
		update("EzPMSDAO.updateProjectGroupEndDate", map);
	}
	
	public int getProjectWorkingdaySum (ProjectTaskVO taskVO) {
		return (int) select("EzPMSDAO.getProjectWorkingdaySum", taskVO);
	}

	public void updateAllTaskWeight(Map<String, Object> map) {
		update("EzPMSDAO.updateAllTaskWeight", map);
	}

	public int getWeightInput(Map<String, Object> map) {
		return (int) select("EzPMSDAO.getProjectWeightInput", map);
	}

	public void updateProjectWorkingdaySum2(Map<String, Object> map) {
		update("EzPMSDAO.updateProjectWorkingdaySum2", map);
	}

	public int getDateTaskCount(Map<String, Object> map) {
		return (int) select ("EzPMSDAO.getDateTaskCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<ProjectHolidayVO> getCustomHoliday(Map<String, Object> map) {
		return (List<ProjectHolidayVO>) list("EzPMSDAO.getCustomHoliday", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ProjectBoardFolderVO> getBoardFolderList(Map<String, Object> map) {
		return (List<ProjectBoardFolderVO>) list("EzPMSDAO.getBoardFolderList", map);
	}
	
	public void addBoardFolder(Map<String, Object> map) {
		insert ("EzPMSDAO.addBoardFolder", map);
	}
	
	public void updateBoardFolder(Map<String, Object> map) {
		update ("EzPMSDAO.updateBoardFolder", map);
	}
	
	public void deleteBoardFolder(Map<String, Object> map) {
		update ("EzPMSDAO.deleteBoardFolder", map);
	}

	public ProjectBoardFolderVO getBoardFolder(Map<String, Object> map) {
		return (ProjectBoardFolderVO) select ("EzPMSDAO.getBoardFolder", map);
	}
	
	public void updateTaskName(Map<String, Object> map) {
		update ("EzPMSDAO.updateTaskName", map);
	}
	
	public void updateGroupName(Map<String, Object> map) {
		update ("EzPMSDAO.updateGroupName", map);
	}
	
	public void updateProjectName(Map<String, Object> map) {
		update ("EzPMSDAO.updateProjectName", map);
	}
	
	public void updateTaskEndDate(Map<String, Object> map) {
		update ("EzPMSDAO.updateTaskEndDate", map);
	}
	
	public int getTaskOverProjectDate(Map<String, Object> map) {
		return (int) select ("EzPMSDAO.getTaskOverProjectDate", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getMinMaxGroupRealDate(Map<String, Object> map) {
		return (Map<String, Object>) select ("EzPMSDAO.getMinMaxGroupRealDate", map);
	}
	
	public void updateGroupRealDate(Map<String, Object> map) {
		update ("EzPMSDAO.updateGroupRealDate", map);
	}
	
	public float getProjectRealProgress(Map<String, Object> map) {
		return (float) select ("EzPMSDAO.getProjectRealProgress", map);
	}

	public void updateProjectRestDueday(Map<String, Object> map) {
		update ("EzPMSDAO.updateProjectRestDueday", map);
		
	}

	public String getuserCompanyId(Map<String, Object> map) {
		return (String) select("EzPMSDAO.getUserCompanyId", map);
	}

	@SuppressWarnings("unchecked")
	public List<Long> getGroupTaskNoneList(Map<String, Object> map) {
		return (List<Long>) list("EzPMSDAO.getGroupTaskNoneList", map);
	}
} 
