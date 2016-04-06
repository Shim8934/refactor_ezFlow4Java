package egovframework.ezEKP.ezOrgan.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganGetUserInfoVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzOrganDAO")
public class EzOrganDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getDeptTreeInfo(Map<String, Object> map) throws Exception{	
		return (List<OrganDeptVO>) list("EzOrganDAO.getDeptTreeInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getDeptSubTreeInfo(Map<String, Object> map) {		
		return (List<OrganDeptVO>) list("EzOrganDAO.getDeptSubTreeInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getDeptMemberList(Map<String, Object> map) throws Exception {
		return (List<OrganDeptVO>) list("EzOrganDAO.getDeptMemberList", map);		
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> organSearch(Map<String, Object> map) throws Exception {		
		return (List<OrganDeptVO>) list("EzOrganDAO.organSearch", map);
	}	

	public OrganUserVO getTBLUserMaster(Map<String, Object> map) throws Exception {
		return (OrganUserVO) select("EzOrganDAO.getTBLUserMaster", map);
	}
		
	public OrganDeptVO getTBLDeptMaster(Map<String, Object> map) throws Exception{
		return (OrganDeptVO) select("EzOrganDAO.getTBLDeptMaster", map);
	}
	
	public OrganDeptVO getDeptInfo(Map<String, Object> map) {
		return (OrganDeptVO) select("EzOrganDAO.getDeptInfo", map);
	}
	
	public OrganGetUserInfoVO getUserInfo(Map<String, Object> map) {
		return (OrganGetUserInfoVO) select("EzOrganDAO.getUserInfo", map);
	}
	
	public String getPropertyValue(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getPropertyValue", map);
	}

	public String getSIPUriList(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getSIPUriList", map);
	}

	public String getDeptFullPath(String deptID) throws Exception{
		return (String) select("EzOrganDAO.getDeptFullPath", deptID);
	}

	public int deptSubDeptCnt(String deptID) throws Exception{
		// TODO Auto-generated method stub
		return (int) select("EzOrganDAO.deptSubDeptCnt", deptID);
	}

	
}