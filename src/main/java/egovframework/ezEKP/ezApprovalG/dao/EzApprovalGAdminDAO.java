package egovframework.ezEKP.ezApprovalG.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezApprovalG.vo.ApprGAdminReceiveVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocStateVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
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
	
	@SuppressWarnings("unchecked")
	public List<ApprGAdminReceiveVO> getReceiveGroupInfo(Map<String, Object> map) {
		return (List<ApprGAdminReceiveVO>) list("EzApprovalGAdmin.getReceiveGroupInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getTaskCategotyTree(Map<String, Object> map) throws Exception {
		return (List<ApprGTaskVO>) list("EzApprovalGAdmin.getTaskCategotyTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getTaskInSubCategoryForManage(Map<String, Object> map) throws Exception {
		return (List<ApprGTaskVO>) list("EzApprovalGAdmin.getTaskInSubCategoryForManage", map);
	}
	
	public ApprGTaskVO getTaskInfo(Map<String, Object> map) throws Exception {
		return (ApprGTaskVO) select("EzApprovalGAdmin.getTaskInfo", map);
	}
	
	public ApprGTaskVO getTaskCode(Map<String, Object> map) throws Exception {
		return (ApprGTaskVO) select("EzApprovalGAdmin.getTaskCode", map);
	}
	
	public ApprGTaskVO getTaskName(Map<String, Object> map) throws Exception {
		return (ApprGTaskVO) select("EzApprovalGAdmin.getTaskName", map);
	}

	public String deleteContainerType(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalGAdmin.deleteContainerType", map);
	}

	public String insertContainerContID(String companyID) throws Exception{
		return (String) select("EzApprovalGAdmin.insertContainerContID", companyID);
	}
	
	public Integer getTaskCategoryDuplicate(Map<String, Object> map) throws Exception {
		select("EzApprovalGAdmin.getTaskCategoryDuplicate", map);
		return (Integer) map.get("v_pCount");
	}

	public Integer getTaskCategoryNodeExist(Map<String, Object> map) throws Exception {
		select("EzApprovalGAdmin.getTaskCategoryNodeExist", map);
		return (Integer) map.get("v_pCount");
	}

	public Integer getTaskCodeDuplicate(Map<String, Object> map) throws Exception {
		select("EzApprovalGAdmin.getTaskCodeDuplicate", map);
		return (Integer) map.get("v_pCount");
	}
	
	public Integer getTaskCodeNodeExist(Map<String, Object> map) throws Exception {
		select("EzApprovalGAdmin.getTaskCodeNodeExist", map);
		return (Integer) map.get("v_pCount");
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
	
	public void insertReceiveGroupItemInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalGAdmin.insertReceiveGroupItemInfo", map);
	}
	
	public void insertReceiveGroupInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalGAdmin.insertReceiveGroupInfo", map);
	}
	
	public void setTaskCategory(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.setTaskCategory", map);
	}
	
	public void updateContainer(Map<String, Object> map) throws Exception{
		update("EzApprovalGAdmin.updateContainer", map);
	}

	public void updateReceiveGroupInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalGAdmin.updateReceiveGroupInfo", map);
	}
	
	public void updateTaskCode(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.updateTaskCode", map);
	}

	public void deleteContainerDocState(String companyID) throws Exception {
		delete("EzApprovalGAdmin.deleteContainerDocState", companyID);
	}

	public void deleteContainerUseDep(Map<String, Object> map) throws Exception{
		delete("EzApprovalGAdmin.deleteContainerUseDep", map);
	}

	public void deleteContainer(Map<String, Object> map) throws Exception{
		delete("EzApprovalGAdmin.deleteContainer", map);
	}

	public void deleteReceiveGroupItemInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalGAdmin.deleteReceiveGroupItemInfo", map);
	}

	public void deleteReceiveGroupInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteReceiveGroupInfo", map);
	}

	public void removeTaskCategory(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.removeTaskCategory", map);
	}

	public void setTaskHistory(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.setTaskHistory", map);
	}

	public void insertTaskCode(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertTaskCode", map);
	}

	public void removeTaskCode(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.removeTaskCode1", map);
		update("EzApprovalGAdmin.removeTaskCode2", map);
	}



}
