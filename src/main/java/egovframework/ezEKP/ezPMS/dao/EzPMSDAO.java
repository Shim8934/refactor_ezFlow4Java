package egovframework.ezEKP.ezPMS.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
import egovframework.ezEKP.ezPMS.vo.ProjectCompanyVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskTreeVO;
import egovframework.ezEKP.ezPMS.vo.ProjectUserVO;
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
	public List<ProjectMemberVO> getProjectMember(HashMap<String, Object> map) {
		return (List<ProjectMemberVO>) list("EzPMSDAO.getProjectMember", map);
	}

	@SuppressWarnings("unchecked")
	public void addNewProject(Map<String, Object> map) {
		insert("EzPMSDAO.addNewProject", map);
	}
	
}
