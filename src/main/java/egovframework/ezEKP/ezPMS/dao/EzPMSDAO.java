package egovframework.ezEKP.ezPMS.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPMS.vo.ProjectTaskTreeVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPMSDAO")
public class EzPMSDAO extends EgovAbstractDAO {
	
	
	
	public List<ProjectTaskTreeVO> getProjectTaskTree(Map<String, Object> map) {
		return (List<ProjectTaskTreeVO>) list("EzPMSDAO.getProjectTaskTree", map);
	}

}
