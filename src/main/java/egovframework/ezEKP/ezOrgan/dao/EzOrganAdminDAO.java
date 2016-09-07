package egovframework.ezEKP.ezOrgan.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzOrganAdminDAO")
public class EzOrganAdminDAO extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getCompanyList(Map<String, Object> map) throws Exception{
		return (List<OrganDeptVO>) list("EzOrganAdminDAO.getCompanyList", map);
	}

	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getAddJobList(Map<String, Object> map) throws Exception{
		return (List<OrganUserVO>) list("EzOrganAdminDAO.getAddJobList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getUserAddJobList(Map<String, Object> map) throws Exception{
		return (List<OrganUserVO>) list("EzOrganAdminDAO.getUserAddJobList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getPermissionList(Map<String, Object> map) throws Exception{
		return (List<OrganUserVO>) list("EzOrganAdminDAO.getPermissionList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getRetireList(Map<String, Object> map) throws Exception{
		return (List<OrganUserVO>) list("EzOrganAdminDAO.getRetireList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getUserCnList() throws Exception {
		return (List<OrganUserVO>) list("EzOrganAdminDAO.userCnList");
	}
	
	public OrganUserVO getUserInfo(Map<String, Object> map) throws Exception{
		return (OrganUserVO) select("EzOrganAdminDAO.getUserInfo", map);
	}
	
	public OrganUserVO getRetireEntryInfo(Map<String, Object> map) throws Exception{
		return (OrganUserVO) select("EzOrganAdminDAO.getRetireEntryInfo", map);
	}

	public int companyCheck(String cn) throws Exception{		
		return (int) select("EzOrganAdminDAO.companyCheck", cn);
	}
	
	public int companyChildCheck(String cn) throws Exception{
		return (int) select("EzOrganAdminDAO.companyChildCheck", cn);
	}

	public int userCheck(String cn) throws Exception{
		return (int) select("EzOrganAdminDAO.userCheck", cn);
	}
	
	public int getPermissionListCount(Map<String, Object> map) throws Exception{
		select("EzOrganAdminDAO.getPermissionListCount", map);
		int ret = (int) map.get("v_pCount");
		
		return ret;
	}
	
	public int getRetireListCount(Map<String, Object> map) throws Exception{
		select("EzOrganAdminDAO.getRetireListCount", map);
		int ret = (int) map.get("v_pCount");
		
		return ret;
	}


	public void insertDBData_company(Map<String, Object> map) throws Exception{
		insert("EzOrganAdminDAO.insertDBData_company", map);
	}

	public void insertDBData_dept(Map<String, Object> map) throws Exception{
		insert("EzOrganAdminDAO.insertDBData_dept", map);
	}

	public void insertDBData_user(Map<String, Object> map) throws Exception{
		insert("EzOrganAdminDAO.insertDBData_user", map);
	}
	
	public void updateDBData_dept(OrganDeptVO vo) throws Exception{
		update("EzOrganAdminDAO.updateDBData_dept", vo);
	}
	
	public void updateDBData_user(OrganUserVO vo) throws Exception{
		update("EzOrganAdminDAO.updateDBData_user", vo);
	}
	
	public void updateProperty(Map<String, Object> map) throws Exception{
		update("EzOrganAdminDAO.updateProperty", map);
	}
	
	public void restoreRetireEntry(Map<String, Object> map) throws Exception{
		update("EzOrganAdminDAO.restoreRetireEntry", map);
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

	public void setAddJob(Map<String, Object> map) throws Exception{
		delete("EzOrganAdminDAO.setAddJob", map);
	}

	public int userCountCheck(String cn) {
		// TODO Auto-generated method stub
		return (int) select("EzOrganAdminDAO.userCountCheck", cn);
	}
		

}