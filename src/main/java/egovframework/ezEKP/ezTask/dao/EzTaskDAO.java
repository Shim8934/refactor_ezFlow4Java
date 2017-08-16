package egovframework.ezEKP.ezTask.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezTask.vo.TaskInfoVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzTaskDAO")
public class EzTaskDAO extends EgovAbstractDAO {

	public TaskInfoVO getTaskInfo(Map<String, Object> map) {
		return (TaskInfoVO) select("EzTaskDAO.getTaskInfo", map);
	}
	/* 이효진*/
	
	/* 정수현*/
}
