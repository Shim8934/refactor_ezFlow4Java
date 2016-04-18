package egovframework.ezEKP.ezOrgan.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzOrganAdminDAO")
public class EzOrganAdminDAO extends EgovAbstractDAO {
	
	public OrganUserVO getUserInfo(Map<String, Object> map) {
		return (OrganUserVO) select("EzOrganAdminDAO.getUserInfo", map);
	}
	
	public int companyCheck(String cn) throws Exception{		
		return (int) select("EzOrganAdminDAO.companyCheck", cn);
	}
	
	public int companyChildCheck(String cn) {
		return (int) select("EzOrganAdminDAO.companyChildCheck", cn);
	}

	public void insertDBData_company(Map<String, Object> map) throws Exception{
		insert("EzOrganAdminDAO.insertDBData_company", map);
	}

	public void insertDBData_dept(Map<String, Object> map) throws Exception{
		insert("EzOrganAdminDAO.insertDBData_dept", map);
	}
	
	public void updateDBData_dept(OrganDeptVO vo) throws Exception{
		update("EzOrganAdminDAO.updateDBData_dept", vo);
	}
	
	public void updateProperty(Map<String, Object> map) throws Exception{
		update("EzOrganAdminDAO.updateProperty", map);
	}	
	
	public void deleteDBData(Map<String, Object> map) throws Exception{
		delete("EzOrganAdminDAO.deleteDBData", map);
	}

	public void moveDBData(Map<String, Object> map) throws Exception{
		delete("EzOrganAdminDAO.moveDBData", map);
	}

	public void retireDBData(Map<String, Object> map) throws Exception{
		delete("EzOrganAdminDAO.retireDBData", map);
	}



}