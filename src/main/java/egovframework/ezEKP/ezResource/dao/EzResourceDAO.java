package egovframework.ezEKP.ezResource.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzResourceDAO")
public class EzResourceDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(Map<String, Object> map){
		return  (List<ResGetAdmSubClsTreeVO>) list("EzResourceDAO.getAdmSubClsTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetAdmSubClsTreeVO> getSubClsTree(Map<String, Object> map){
		return  (List<ResGetAdmSubClsTreeVO>) list("EzResourceDAO.getSubClsTree", map);
	}
}

