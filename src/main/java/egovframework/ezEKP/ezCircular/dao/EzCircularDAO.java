package egovframework.ezEKP.ezCircular.dao;

import java.util.HashMap;
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
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getCircularMapList(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, Object>>) list("EzCircularDAO.getCircularMapList", map);
	}
	
	public CircularConfigVO getCircularList_Config(Map<String, Object> map) throws Exception {
		return (CircularConfigVO) select("EzCircularDAO.getCircularList_Config", map);
	}
	
	public CircularListVO getCircular(Map<String, Object> map) throws Exception {
		return (CircularListVO) select("EzCircularDAO.getCircular", map);
	}

	public String getCircularConfig(Map<String, Object> map) throws Exception {
		return (String) select("EzCircularDAO.getCircularConfig", map);
	}
	
	public int getCircularListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.getCircularListCount", map);
	}

	public void setCircularList_Config_I(CircularConfigVO circularConfigVO) {
		insert("EzCircularDAO.setCircularList_Config_I", circularConfigVO);
	}

	public void setCircularList_Config2_I(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.setCircularList_Config2_I", map);
	}
	
	public void setCircularConfig2(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.setCircularConfig2", map);
	}
	
	public void insertCircular(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.insertCircular", map);
	}
	
	public void insertCircularUser(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.insertCircularUser", map);
	}
	
	public void setCircularList_Config_U(CircularConfigVO circularConfigVO) {
		update("EzCircularDAO.setCircularList_Config_U", circularConfigVO);
	}
	
	public void setCircularList_Config2_U(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.setCircularList_Config2_U", map);
	}
	
	public void setCircularConfig(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.setCircularConfig", map);
	}
	
	public void modifyCircular(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.modifyCircular", map);
	}
	
	public void modifyCircularUser(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.modifyCircularUser", map);
	}
	
	public void deleteCircular(Map<String, Object> map) throws Exception{
		delete("EzCircularDAO.deleteCircular", map);
	}
	
	public void deleteCircularUser(Map<String, Object> map) throws Exception{
		delete("EzCircularDAO.deleteCircularUser", map);
	}
	
	
}
