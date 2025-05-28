package egovframework.ezEKP.ezDoc24.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezDoc24.vo.EzDoc24VO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("ezDoc24DAO")
public class EzDoc24DAO extends EgovAbstractDAO{
	
	public String checkId(Map<String, Object> map) throws Exception {
		return (String) select("EzDoc24DAO.checkId", map);
	}
	public Object insertDept(Map<String, Object> map) throws Exception {
		return insert("EzDoc24DAO.insertDept", map);
	}
	public int updateDept(Map<String, Object> map) throws Exception {
		return (int) update("EzDoc24DAO.updateDept", map);
	}
	@SuppressWarnings("unchecked")
	public List<EzDoc24VO> getDoc24List() throws Exception{
		return (List<EzDoc24VO>) list("EzDoc24DAO.getDoc24List");
		
	}
}
