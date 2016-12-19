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
	
	public ResGetSubClsListVO getBrdInfo(Map<String, Object> map) {
		return (ResGetSubClsListVO) select("EzResourceAdminDAO.getBrdInfo", map);	
	}
	
	public int getSubResCnt(Map<String, Object> map) {
		return (int)select("EzResourceDAO.subResCnt", map);
	}
	
	public int getSubClsCnt(Map<String, Object> map) {
		return (int)select("EzResourceDAO.subClsCnt", map);
	}
	
	public int addClsData_S1(Map<String, Object> map) {
		return (int)select("EzResourceAdminDAO.addClsData_S1", map);
	}
	
	public int addClsData_S2(Map<String, Object> map) {
		return (int)select("EzResourceAdminDAO.addClsData_S1", map);
	}
	
	public int addClsData_S3(Map<String, Object> map) {
		return (int)select("EzResourceAdminDAO.addClsData_S1", map);
	}
	
	public int chgClsOrder_S1(Map<String, Object> map) {
		return (int)select("EzResourceAdminDAO.chgClsOrder_S1", map);
	}
	
	public int chgClsOrder_S2(Map<String, Object> map) {
		return (int)select("EzResourceAdminDAO.chgClsOrder_S2", map);
	}
	
	public int moveCls_S1(Map<String, Object> map) {
		return (int)select("EzResourceAdminDAO.moveCls_S1", map);
	}
	
	public int moveCls_S2(Map<String, Object> map) {
		return (int)select("EzResourceAdminDAO.moveCls_S2", map);
	}
	
	public int moveCls_S3(Map<String, Object> map) {
		return (int)select("EzResourceAdminDAO.moveCls_S3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Integer> moveSubCls_S1(Map<String, Object> map) {
		return (List<Integer>)list("EzResourceAdminDAO.moveSubCls_S1", map);
	}
	
	public void addClsData(Map<String, Object> map) {
		insert("EzResourceAdminDAO.addClsData", map);
	}
	
	public void saveACL(Map<String, Object> map) {
		insert("EzResourceAdminDAO.saveACL", map);
	}
	
	public void addClsData_I1(Map<String, Object> map) {
		insert("EzResourceAdminDAO.addClsData_I1", map);
	}
	
	public void addClsData_I2(Map<String, Object> map) {
		insert("EzResourceAdminDAO.addClsData_I2", map);
	}
	
	public void addClsData_I3(Map<String, Object> map) {
		insert("EzResourceAdminDAO.addClsData_I3", map);
	}
	
	public void modifyClsData(Map<String, Object> map) {
		update("EzResourceAdminDAO.modifyClsData", map);
	}
	
	public void chgClsOrder_U1(Map<String, Object> map) {
		update("EzResourceAdminDAO.chgClsOrder_U1", map);
	}
	
	public void chgClsOrder_U2(Map<String, Object> map) {
		update("EzResourceAdminDAO.chgClsOrder_U2", map);
	}
	
	public int saveACL_U(Map<String, Object> map) {
		return update("EzResourceAdminDAO.saveACL_U", map);
	}
	
	public void moveCls(Map<String, Object> map) {
		update("EzResourceAdminDAO.moveCls", map);
	}
	
	public void moveSubCls_U1(Map<String, Object> map) {
		update("EzResourceAdminDAO.moveSubCls_U1", map);
	}
	
	public void delClsData_U1(Map<String, Object> map) {
		update("EzResourceAdminDAO.delClsData_U1", map);
	}
	
	public void delClsData(Map<String, Object> map) {
		delete("EzResourceAdminDAO.delClsData", map);
	}
	
	public void delResAcll(Map<String, Object> map) {
		delete("EzResourceAdminDAO.delResAcll", map);
	}
	
	public void delClsData_D1(Map<String, Object> map) {
		delete("EzResourceAdminDAO.delClsData_D1", map);
	}
	
	public void delClsData_D2(Map<String, Object> map) {
		delete("EzResourceAdminDAO.delClsData_D2", map);
	}
	
	public void delClsData_D3(Map<String, Object> map) {
		delete("EzResourceAdminDAO.delClsData_D3", map);
	}
	
	public void delClsData_D4(Map<String, Object> map) {
		delete("EzResourceAdminDAO.delClsData_D4", map);
	}
	
	public void delClsData_D5(Map<String, Object> map) {
		delete("EzResourceAdminDAO.delClsData_D5", map);
	}
	
	
}
