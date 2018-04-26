package egovframework.ezEKP.ezPMS.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
import egovframework.ezEKP.ezPMS.vo.ProjectCompanyVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMainSettingVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskTreeVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.ProjectUserVO;
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
		return (List<ProjectCompanyVO>) list("selectCompanyList",map);
	}
	
	/**
	 * 조직도에 쓸 부서리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DeptViewVO> getDeptViewVO(Map<String, Object> map){
		return (List<DeptViewVO>) list("selectDeptList",map);
	}
	
	/**
	 * 해당부서의 사원 리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ProjectUserVO> getDeptUserList(Map<String, Object> map){
		return (List<ProjectUserVO>) list("selectUserList",map);
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

	public int addNewProject(Map<String, Object> map) {
		return (int) insert("addNewProject", map);
	}
	
	public ProjectMemberVO getUserInfo(HashMap<String, Object> map) {
		return (ProjectMemberVO) select("getUserInfo", map);
	}

	public void addProjectMember(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		insert("addProjectMember", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getRemainingWeight(String projectId) {
		return (Map<String, Object>) select("getRemainingWeight", projectId);
	}
	
	/**
	 * 프로젝트관리 메인 환경설정 리스트 가져오기 (+메일)
	 */
	public ProjectMainSettingVO getProjectMainSetting(Map<String, Object> map) {
		return (ProjectMainSettingVO) select("getProjectMainSetting", map);
	}

	@SuppressWarnings("unchecked")
	public List<ProjectInfoVO> getProjectList(Map<String, Object> map) {
		return (List<ProjectInfoVO>) list("getProjectList", map);
	}
	
	public Long addTask(ProjectTaskVO vo) {
		return (Long) insert("addTask", vo);
	}
	
	public void addTaskMember(TaskMemberVO vo) {
		insert("addTaskMember", vo);
	}
	
	public int getProjectWorkingday (String projectId) {
		return (int) select("getProjectWorkingday", projectId);
	}
	
	public void updateProjectWorkingday (Map<String, Object> map) {
		update("updateProjectWorkingday", map);
	}
	
	public void updateTaskWDNW (Map<String, Object> map) {
		update("updateTaskWDNW", map);
	}

	public int getSortOrder(String upperGroupId) {
		return (int) select("getSortOrder", upperGroupId);
	}
	
	public ProjectInfoVO getProjectDetails(Map<String, Object> map) {
		return (ProjectInfoVO) select("getProjectDetails", map); 
	}
	
	@SuppressWarnings("unchecked")
	public List<ProjectTaskVO> getTaskList(Map<String, Object> map) {
		return (List<ProjectTaskVO>) list("getTaskList", map); 
	}
	
	

}
