package egovframework.ezEKP.ezTask.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezTask.vo.TaskAttachVO;
import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskConfigVO;
import egovframework.ezEKP.ezTask.vo.TaskGeneralVO;
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
	
	@SuppressWarnings("unchecked")
	public List<TaskInfoVO> getTaskList(Map<String, Object> map) throws Exception {
		return (List<TaskInfoVO>) list("EzTaskDAO.getTaskList", map);
	}
	
	public TaskInfoVO getTaskInfo(Map<String, Object> map) {
		return (TaskInfoVO) select("EzTaskDAO.getTaskInfo", map);
	}
	
	public TaskConfigVO getOriginColor(Map<String, Object> map) throws Exception {
		return (TaskConfigVO) select("EzTaskDAO.getOriginColor", map);
	}

	public TaskGeneralVO getTaskGeneral(Map<String, Object> map) {
		return (TaskGeneralVO) select("EzTaskDAO.getTaskGeneral", map);
	}

	public String getTaskCount(Map<String, Object> map) throws Exception {
		return (String) select("EzTaskDAO.getTaskCount", map);
	}

	public String getTaskCount2(Map<String, Object> map) throws Exception {
		return (String) select("EzTaskDAO.getTaskCount2", map);
	}

	public String getTaskAllCount(Map<String, Object> map) {
		return (String) select("EzTaskDAO.getTaskAllCount", map);
	}

	public String insertTask(Map<String, Object> map) throws Exception {
		return (String) insert("EzTaskDAO.insertTask", map);
	}
	
	public int insertComment(Map<String, Object> map) {
		return update("EzTaskDAO.insertComment", map);
	}
	
	public void insertTaskShare(Map<String, Object> map) throws Exception {
		insert("EzTaskDAO.insertTaskShare", map);
	}
	
	public void taskSaveConfig(Map<String, Object> map) throws Exception {
		insert("EzTaskDAO.taskSaveConfig", map);
	}
	
	public void insertTaskAttach(Map<String, Object> map) throws Exception {
		insert("EzTaskDAO.insertTaskAttach", map);
	}
	
	public void taskSaveGeneral(Map<String, Object> map) {
		insert("EzTaskDAO.taskSaveGeneral", map);
	}
	
	public void updateHasComment(Map<String, Object> map) {
		update("EzTaskDAO.updateHasComment", map);
	}
	
	public void updateTaskStatus(Map<String, Object> map) {
		update("EzTaskDAO.updateTaskStatus", map);
	}
	
	public void updateTaskWork(Map<String, Object> map) {
		update("EzTaskDAO.updateTaskWork", map);
	}
	
	public void updateTask(Map<String, Object> map) throws Exception {
		update("EzTaskDAO.updateTask", map);
	}
	
	public void taskUpdateConfig(Map<String, Object> map) throws Exception {
		update("EzTaskDAO.taskUpdateConfig", map);
	}
	
	public void updateTaskGeneral(Map<String, Object> map) {
		update("EzTaskDAO.updateTaskGeneral", map);
	}

	public void deleteComment(Map<String, Object> map) {
		delete("EzTaskDAO.deleteComment", map);
	}
	
	public void deleteTaskAttach(Map<String, Object> map) throws Exception {
		delete("EzTaskDAO.deleteTaskAttach", map);
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
