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
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzTaskDAO")
public class EzTaskDAO extends EgovAbstractDAO {
	/* 이효진*/
	@SuppressWarnings("unchecked")
	public List<TaskCommentVO> getCommentList(Map<String, Object> map) throws Exception {
		return (List<TaskCommentVO>) list("EzTaskDAO.getCommentList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<TaskShareVO> getShareList(Map<String, Object> map) throws Exception {
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
	
	public TaskInfoVO getTaskInfo(Map<String, Object> map) throws Exception {
		return (TaskInfoVO) select("EzTaskDAO.getTaskInfo", map);
	}
	
	public TaskConfigVO getOriginColor(Map<String, Object> map) throws Exception {
		return (TaskConfigVO) select("EzTaskDAO.getOriginColor", map);
	}
	
	public int selectCompletionOfRepTask(Map<String, Object> map) throws Exception {
		Object returnVal = select("EzTaskDAO.selectCompletionOfRepTask", map);
		return returnVal == null ? 0 : (int) returnVal;
	}
	
	public int getStatusOfRepTask(Map<String, Object> map) throws Exception {
		Object returnVal = select("EzTaskDAO.getStatusOfRepTask", map);
		return returnVal == null ? 0 : (int) returnVal;
	}

	public TaskGeneralVO getTaskGeneral(Map<String, Object> map) throws Exception {
		return (TaskGeneralVO) select("EzTaskDAO.getTaskGeneral", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getTaskRepeDelList(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzTaskDAO.getTaskRepeDelList", map) ;
	}

	public String getTaskCount(Map<String, Object> map) throws Exception {
		return (String) select("EzTaskDAO.getTaskCount", map);
	}

	public String getTaskCount2(Map<String, Object> map) throws Exception {
		return (String) select("EzTaskDAO.getTaskCount2", map);
	}

	public String getTaskCount3(Map<String, Object> map) throws Exception {
		return (String) select("EzTaskDAO.getTaskCount3", map);
	}

	public String getTaskAllCount(Map<String, Object> map) throws Exception {
		return (String) select("EzTaskDAO.getTaskAllCount", map);
	}

	public String insertTask(Map<String, Object> map) throws Exception {
		return (String) insert("EzTaskDAO.insertTask", map);
	}
	
	public int insertComment(Map<String, Object> map) throws Exception {
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

	public void insertTaskRepeDel(Map<String, Object> map) {
		insert("EzTaskDAO.insertTaskRepeDel", map);
	}

	public void updateHasComment(Map<String, Object> map) {
		update("EzTaskDAO.updateHasComment", map);
	}
	
	public void updateNumberOfTotalReps(Map<String, Object> map) {
		update("EzTaskDAO.updateNumberOfTotalReps", map);
	}	
	
	public void updateTaskStatus(Map<String, Object> map) {
		update("EzTaskDAO.updateTaskStatus", map);
	}
	
	public void updateRepetionTaskStatus(Map<String, Object> map) {
		insert("EzTaskDAO.updateRepetionTaskStatus", map);
	}	
	
	public void updateTaskWork(Map<String, Object> map) {
		update("EzTaskDAO.updateTaskWork", map);
	}
	
	public void updateTask(Map<String, Object> map) throws Exception {
		update("EzTaskDAO.updateTask", map);
	}
	
	public void updateTaskStartDate(Map<String, Object> map) throws Exception {
		update("EzTaskDAO.updateTaskStartDate", map);
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
	
	public void repTaskDelete(Map<String, Object> map) throws Exception {
		delete("EzTaskDAO.repTaskDelete", map);
	}	

	public void taskDeleteShare(Map<String, Object> map) throws Exception {
		delete("EzTaskDAO.taskDeleteShare", map);
	}

	public void taskDeleteAttach(Map<String, Object> map) throws Exception {
		delete("EzTaskDAO.taskDeleteAttach", map);
	}

	public void insertTaskGeneral(Map<String, Object> map) throws Exception {
		insert("EzTaskDAO.insertTaskGeneral", map);
	}
}
