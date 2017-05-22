package egovframework.ezEKP.ezCircular.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCircularDAO")
public class EzCircularDAO extends EgovAbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<CircularListVO> getCircularList(Map<String, Object> map) throws Exception {
		return (List<CircularListVO>) list("EzCircularDAO.getCircularList", map);
	}
	
	public CircularConfigVO getCircularList_Config(Map<String, Object> map) throws Exception {
		return (CircularConfigVO) select("EzCircularDAO.getCircularList_Config", map);
	}

	public String getCircularConfig(Map<String, Object> map) throws Exception {
		return (String) select("EzCircularDAO.getCircularConfig", map);
	}

	public void setCircularList_Config_U(CircularConfigVO circularConfigVO) {
		update("EzCircularDAO.setCircularList_Config_U", circularConfigVO);
	}

	public void setCircularList_Config_I(CircularConfigVO circularConfigVO) {
		insert("EzCircularDAO.setCircularList_Config_I", circularConfigVO);
	}
	
	public void setCircularList_Config2_U(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.setCircularList_Config2_U", map);
	}
	
	public void setCircularList_Config2_I(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.setCircularList_Config2_I", map);
	}
	
	public void setCircularConfig(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.setCircularConfig", map);
	}
	
	public void setCircularConfig2(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.setCircularConfig2", map);
	}
	
}
