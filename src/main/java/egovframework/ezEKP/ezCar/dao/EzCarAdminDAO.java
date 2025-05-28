package egovframework.ezEKP.ezCar.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCar.vo.CarGetClsAclListVO;
import egovframework.ezEKP.ezCar.vo.CarGetSubClsListVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCarAdminDAO")
public class EzCarAdminDAO extends EgovAbstractDAO {
	
	
	@SuppressWarnings("unchecked")
	public List<CarGetClsAclListVO> getClsAclList(Map<String, Object> map){
		return  (List<CarGetClsAclListVO>) list("EzCarAdminDAO.getClsAclList", map);
	}

	public CarGetSubClsListVO getBrdInfo(Map<String, Object> map) {
		return (CarGetSubClsListVO) select("EzCarAdminDAO.getBrdInfo", map);	
	}
	
	public void modifyClsData(Map<String, Object> map) {
		update("EzCarAdminDAO.modifyClsData", map);
	}
	
	
	public int addClsData_S1(Map<String, Object> map) {
		return (int)select("EzCarAdminDAO.addClsData_S1", map);
	}
	
	public int addClsData_S2(Map<String, Object> map) {
		return (int)select("EzCarAdminDAO.addClsData_S1", map);
	}
	
	public int addClsData_S3(Map<String, Object> map) {
		return (int)select("EzCarAdminDAO.addClsData_S1", map);
	}
	
	public void addClsData_I1(Map<String, Object> map) {
		insert("EzCarAdminDAO.addClsData_I1", map);
	}
	
	public void addClsData_I2(Map<String, Object> map) {
		insert("EzCarAdminDAO.addClsData_I2", map);
	}
	
	public void addClsData_I3(Map<String, Object> map) {
		insert("EzCarAdminDAO.addClsData_I3", map);
	}
	
	public void delResAcll(Map<String, Object> map) {
		delete("EzCarAdminDAO.delResAcll", map);
	}
	
	public void saveACL(Map<String, Object> map) {
		insert("EzCarAdminDAO.saveACL", map);
	}
	
	public int saveACL_U(Map<String, Object> map) {
		return update("EzCarAdminDAO.saveACL_U", map);
	}
	
	public int getSubResCnt(Map<String, Object> map) {
		return (int)select("EzCarDAO.subResCnt", map);
	}
	
	public int getSubClsCnt(Map<String, Object> map) {
		return (int)select("EzCarDAO.subClsCnt", map);
	}
	
	public void delClsData_D1(Map<String, Object> map) {
		delete("EzCarAdminDAO.delClsData_D1", map);
	}
	
	public void delClsData_U1(Map<String, Object> map) {
		update("EzCarAdminDAO.delClsData_U1", map);
	}
	
	public void delClsData_D2(Map<String, Object> map) {
		delete("EzCarAdminDAO.delClsData_D2", map);
	}
		
	public void delClsData_D4(Map<String, Object> map) {
		delete("EzCarAdminDAO.delClsData_D4", map);
	}
	
	public void delClsData_D5(Map<String, Object> map) {
		delete("EzCarAdminDAO.delClsData_D5", map);
	}
	

	public void deleteClass(Map<String, Object> map) {
		delete("EzCarAdminDAO.deleteClass", map);
		
	}
}
