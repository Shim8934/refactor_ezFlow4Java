package egovframework.ezEKP.ezTask.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskInfoVO;
import egovframework.ezEKP.ezTask.vo.TaskShareVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzTaskDAO")
public class EzTaskDAO extends EgovAbstractDAO {
	/* 이효진*/
	@SuppressWarnings("unchecked")
	public List<TaskCommentVO> getCommentList(Map<String, Object> map) {
		return (List<TaskCommentVO>) list("EzTaskDAO.getCommentList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<TaskShareVO> getShareList(Map<String, Object> map) {
		return (List<TaskShareVO>) list("EzTaskDAO.getShareList", map);
	}
	
	public TaskInfoVO getTaskInfo(Map<String, Object> map) {
		return (TaskInfoVO) select("EzTaskDAO.getTaskInfo", map);
	}
	
	public void updateHasComment(Map<String, Object> map) {
		update("EzTaskDAO.updateHasComment", map);
	}
	
	public int insertComment(Map<String, Object> map) {
		return update("EzTaskDAO.insertComment", map);
	}
	/* 정수현*/
	public void taskSaveConfig(Map<String, Object> map) throws Exception {
		insert("EzTaskDAO.taskSaveConfig", map);
	}

	public String getDelayColor(Map<String, Object> map) throws Exception {
		return (String) select("EzTaskDAO.getDelayColor", map);
	}

	public void taskUpdateConfig(Map<String, Object> map) throws Exception {
		update("EzTaskDAO.taskUpdateConfig", map);
	}
}
