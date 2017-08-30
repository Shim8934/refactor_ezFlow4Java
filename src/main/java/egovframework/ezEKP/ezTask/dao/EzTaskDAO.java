package egovframework.ezEKP.ezTask.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskAttachVO;
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
	
	@SuppressWarnings("unchecked")
	public List<TaskAttachVO> getAttachList(Map<String, Object> map) throws Exception {
		return (List<TaskAttachVO>) list("EzTaskDAO.getAttachList", map);
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
	
	public void deleteComment(Map<String, Object> map) {
		delete("EzTaskDAO.deleteComment", map);
	}
	
	public void updateTaskStatus(Map<String, Object> map) {
		update("EzTaskDAO.updateTaskStatus", map);
	}
	
	public void updateTaskWork(Map<String, Object> map) {
		update("EzTaskDAO.updateTaskWork", map);
	}
	
	public String insertTask(Map<String, Object> map) throws Exception {
		return (String) insert("EzTaskDAO.insertTask", map);
	}
	
	public void updateTask(Map<String, Object> map) throws Exception {
		update("EzTaskDAO.updateTask", map);
	}
	
	public void insertTaskShare(Map<String, Object> map) throws Exception {
		insert("EzTaskDAO.insertTaskShare", map);
	}
	
	public void deleteTaskAttach(Map<String, Object> map) throws Exception {
		delete("EzTaskDAO.deleteTaskAttach", map);
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

	@SuppressWarnings("unchecked")
	public List<TaskInfoVO> taskGetList(Map<String, Object> map) throws Exception {
		return (List<TaskInfoVO>) list("EzTaskDAO.taskGetList", map);
	}

	public String getTaskCount(Map<String, Object> map) throws Exception {
		return (String) select("EzTaskDAO.getTaskCount", map);
	}

	public String getTaskCount2(Map<String, Object> map) throws Exception {
		return (String) select("EzTaskDAO.getTaskCount2", map);
	}

	public void insertTaskAttach(Map<String, Object> map) throws Exception {
		insert("EzTaskDAO.insertTaskAttach", map);
	}

	public void taskDelete(Map<String, Object> map) throws Exception {
		delete("EzTaskDAO.taskDelete", map);
	}

	public void taskDeleteShare(Map<String, Object> map) throws Exception {
		delete("EzTaskDAO.taskDeleteShare", map);
	}

	public void taskDeleteAttach(Map<String, Object> map) throws Exception {
		delete("EzTaskDAO.taskDeleteAttach", map);
	}
}
