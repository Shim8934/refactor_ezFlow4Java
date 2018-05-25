package egovframework.ezEKP.ezPMS.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
import egovframework.ezEKP.ezPMS.vo.ProjectBoardVO;
import egovframework.ezEKP.ezPMS.vo.ProjectCompanyVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMainSettingVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskTreeVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.ProjectUserVO;
import egovframework.ezEKP.ezPMS.vo.TaskLogListVO;
import egovframework.ezEKP.ezPMS.vo.TaskMemberVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

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
	public List<ProjectMemberVO> getProjectMemberList(HashMap<String, Object> map) {
		return (List<ProjectMemberVO>) list("EzPMSDAO.getProjectMember", map);
	}

	public Long addNewProject(Map<String, Object> map) {
		return (Long) insert("EzPMSDAO.addNewProject", map);
	}
	
	public ProjectMemberVO getUserInfo(HashMap<String, Object> map) {
		return (ProjectMemberVO) select("EzPMSDAO.getUserInfo", map);
	}

	public void addProjectMember(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		insert("EzPMSDAO.addProjectMember", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getRemainingWeight(String projectId) {
		return (Map<String, Object>) select("EzPMSDAO.getRemainingWeight", projectId);
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
	
	public void addTaskMember(TaskMemberVO vo) {
		insert("EzPMSDAO.addTaskMember", vo);
	}
	
	public int getProjectWorkingday (String projectId) {
		return (int) select("EzPMSDAO.getProjectWorkingday", projectId);
	}
	
	public void updateProjectWorkingday (Map<String, Object> map) {
		update("EzPMSDAO.updateProjectWorkingday", map);
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
	

	public int getProjectListCount(Map<String, Object> map) {
		return (int) select("EzPMSDAO.getProjectListCount", map);
	}
	
	public void insertMainSetting(Map<String, Object> map) {
		insert("EzPMSDAO.insertMainSetting", map);
	}
	
	public void updateMainSetting(Map<String, Object> map) {
		update("EzPMSDAO.updateMainSetting", map);
	}

	public int getUserProjectRole(HashMap<String, Object> map) {
		return (int) select ("EzPMSDAO.getUserProjectRole", map);
	}

	public void updateProjectStatus(HashMap<String, Object> map) {
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

	public void deleteProjectMember(HashMap<String, Object> map) {
		delete ("EzPMSDAO.deleteProjectMember", map);		
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
	
	public void addTaskGroup(Map<String, Object> map) {
		insert ("EzPMSDAO.addTaskGroup", map);
	}
	
	public Integer addBoard(ProjectBoardVO vo) {
		return (Integer) insert ("EzPMSDAO.addBoard", vo);
	}
	
	@SuppressWarnings("unchecked")
	public List<ProjectBoardVO> getBoardList(Map<String, Object> map) {
		return (List<ProjectBoardVO>) list("EzPMSDAO.getBoardList", map);
	}
	
	public int getBoardListCount(Map<String, Object> map) {
		return (int) select("EzPMSDAO.getBoardListCount", map);
	}
	
	public ProjectBoardVO getBoardDetail(Map<String, Object> param) {
		return (ProjectBoardVO) select("EzPMSDAO.getBoardDetail", param);
	}
	
	public void insertReadBoardLog(Map<String, Object> map) {
		insert("EzPMSDAO.insertReadBoardLog", map);
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
		// TODO Auto-generated method stub
		return (List<ProjectInfoVO>) list("EzPMSDAO.getProgressProject", map);
	}

	public void insertProjectAttach(Map<String, Object> attachMap) {
		insert("EzPMSDAO.insertProjectAttach", attachMap);
	}
	
	/*public FileVO*/
	public int checkReadBoardOrNot(Map<String, Object> map) {
		if(select("EzPMSDAO.checkReadBoardOrNot", map) == null) {
			return -1;
		} else {
			return (int) select("EzPMSDAO.checkReadBoardOrNot", map);
		}
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getStatusCount(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return (List<Map<String, Object>>) list("EzPMSDAO.getStatusCount", map);
	}
}
