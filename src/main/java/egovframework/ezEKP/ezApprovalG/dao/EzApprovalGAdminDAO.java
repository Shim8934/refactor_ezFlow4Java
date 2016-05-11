package egovframework.ezEKP.ezApprovalG.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezApprovalG.vo.ApprGDocStateVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzApprovalGAdminDAO")
public class EzApprovalGAdminDAO extends EgovAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getContainerInfoManage(Map<String, Object> map) throws Exception{
		return (List<ApprGLeftVO>) list("EzApprovalGAdmin.getContainerInfoManage", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getContTypeInfo(String companyID) throws Exception{
		return (List<ApprGLeftVO>) list("EzApprovalGAdmin.getContTypeInfo", companyID);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getContainerUseDeptInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGLeftVO>) list("EzApprovalGAdmin.getContainerUseDeptInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocStateVO> getContainerToDocStateInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDocStateVO>) list("EzApprovalGAdmin.getContainerToDocStateInfo", map);
	}

	public String deleteContainerType(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalGAdmin.deleteContainerType", map);
	}

	public String insertContainerContID(String companyID) throws Exception{
		return (String) select("EzApprovalGAdmin.insertContainerContID", companyID);
	}

	public void insertContainerType(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertContainerType", map);
	}

	public void insertContainer(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertContainer", map);
	}

	public void insertContainerUseDep(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertContainerUseDep", map);
	}
	
	public void insertContainerDocState(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertContainerDocState", map);
	}
	
	public void deleteContainerDocState(String companyID) throws Exception {
		delete("EzApprovalGAdmin.deleteContainerDocState", companyID);
	}


}
