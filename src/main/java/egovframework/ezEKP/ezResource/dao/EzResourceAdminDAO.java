package egovframework.ezEKP.ezResource.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezResource.vo.ResGetClsAclListVO;
import egovframework.ezEKP.ezResource.vo.ResGetSubClsListVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzResourceAdminDAO")
public class EzResourceAdminDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<ResGetSubClsListVO> getSubClsList(Map<String, Object> map){
		return  (List<ResGetSubClsListVO>) list("EzResourceAdminDAO.getSubClsList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetSubClsListVO> getAdmSubClsList(Map<String, Object> map){
		return  (List<ResGetSubClsListVO>) list("EzResourceAdminDAO.getAdmSubClsList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetClsAclListVO> getClsAclList(Map<String, Object> map){
		return  (List<ResGetClsAclListVO>) list("EzResourceAdminDAO.getClsAclList", map);
	}
	
	public int delResAcll(Map<String, Object> map) {
		return delete("EzResourceAdminDAO.delResAcll", map);
	}
	
	public void addClsData(Map<String, Object> map) {
		insert("EzResourceAdminDAO.addClsData", map);
	}
	
	public void saveACL(Map<String, Object> map) {
		insert("EzResourceAdminDAO.saveACL", map);
	}
	
	public void modifyClsData(Map<String, Object> map) {
		update("EzResourceAdminDAO.modifyClsData", map);
	}
	
	public void chgClsOrder(Map<String, Object> map) {
		update("EzResourceAdminDAO.chgClsOrder", map);
	}
	
	public void moveCls(Map<String, Object> map) {
		update("EzResourceAdminDAO.moveCls", map);
	}
	
	public void delClsData(Map<String, Object> map) {
		delete("EzResourceAdminDAO.delClsData", map);
	}
}
