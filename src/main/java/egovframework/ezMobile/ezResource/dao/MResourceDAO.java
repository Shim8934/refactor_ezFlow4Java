package egovframework.ezMobile.ezResource.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MResourceDAO")
public class MResourceDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<MResourceGetAdmSubClsTreeVO> getAdmSubClsTree(Map<String, Object> map){
		return  (List<MResourceGetAdmSubClsTreeVO>) list("MResourceDAO.getAdmSubClsTree", map);
	}
}

