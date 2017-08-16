package egovframework.ezEKP.ezTask.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezTask.vo.TaskInfoVO;
import egovframework.ezEKP.ezTask.vo.TaskShareVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzTaskDAO")
public class EzTaskDAO extends EgovAbstractDAO {
	/* 이효진*/
	@SuppressWarnings("unchecked")
	public List<TaskShareVO> getShareList(Map<String, Object> map) {
		return (List<TaskShareVO>) list("EzTaskDAO.getShareList", map);
	}
	
	public TaskInfoVO getTaskInfo(Map<String, Object> map) {
		return (TaskInfoVO) select("EzTaskDAO.getTaskInfo", map);
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
