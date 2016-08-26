package egovframework.ezEKP.ezApprovalG.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezApprovalG.vo.ApprGAdminReceiveVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprDocInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocStateVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiveDocVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSealInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskCodeHistoryVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskDeptInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzApprovalGAdminDAO")
public class EzApprovalGAdminDAO extends EgovAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getContainerInfoManage(Map<String, Object> map) throws Exception {
		return (List<ApprGLeftVO>) list("EzApprovalGAdmin.getContainerInfoManage", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getContTypeInfo(String companyID) throws Exception {
		return (List<ApprGLeftVO>) list("EzApprovalGAdmin.getContTypeInfo", companyID);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getContainerUseDeptInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGLeftVO>) list("EzApprovalGAdmin.getContainerUseDeptInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocStateVO> getContainerToDocStateInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGDocStateVO>) list("EzApprovalGAdmin.getContainerToDocStateInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAdminReceiveVO> getReceiveGroupInfo(Map<String, Object> map) throws Exception {
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
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskDeptInfoVO> getTaskCodeDeptInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGTaskDeptInfoVO>) list("EzApprovalGAdmin.getTaskCodeDeptInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getTaskInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGTaskVO>) list("EzApprovalGAdmin.getTaskInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskCodeHistoryVO> getTaskHistory(Map<String, Object> map) throws Exception {
		return (List<ApprGTaskCodeHistoryVO>) list("EzApprovalGAdmin.getTaskHistory", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getTaskFullList(Map<String, Object> map) throws Exception {
		return (List<ApprGTaskVO>) list("EzApprovalGAdmin.getTaskFullList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGSealInfoVO> getSealList(Map<String, Object> map) throws Exception {
		return (List<ApprGSealInfoVO>) list("EzApprovalGAdmin.getSealList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGSealInfoVO> getSealDeptList(Map<String, Object> map) throws Exception {
		return (List<ApprGSealInfoVO>) list("EzApprovalGAdmin.getSealDeptList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> getUserDocCount(Map<String, Object> map) throws Exception {
		return (List<ApprGAprLineVO>) list("EzApprovalGAdmin.getUserDocCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprDocInfoVO> searchManageAprDocList(Map<String, Object> map) throws Exception {
		return (List<ApprGAprDocInfoVO>) list("EzApprovalGAdmin.searchManageAprDocList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGFormVO> getGroupDept(Map<String, Object> map) throws Exception {
		return (List<ApprGFormVO>) list("EzApprovalGAdmin.getGroupDept", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGFormVO> getFormRecvAdmin(Map<String, Object> map) throws Exception {
		return (List<ApprGFormVO>) list("EzApprovalGAdmin.getFormRecvAdmin", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiveDocVO> getDeptTranSendDocCount(Map<String, Object> map) throws Exception {
		return (List<ApprGReceiveDocVO>) list("EzApprovalGAdmin.getDeptTranSendDocCount", map);
	}
	
	public ApprGTaskVO getTaskCode(Map<String, Object> map) throws Exception {
		return (ApprGTaskVO) select("EzApprovalGAdmin.getTaskCode", map);
	}
	
	public ApprGTaskVO getTaskName(Map<String, Object> map) throws Exception {
		return (ApprGTaskVO) select("EzApprovalGAdmin.getTaskName", map);
	}
	
	public ApprGFormVO getFormContent(Map<Object, String> map) throws Exception {
		return (ApprGFormVO) select("EzApprovalGAdmin.getFormContent", map);
	}

	public String deleteContainerType(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalGAdmin.deleteContainerType", map);
	}

	public String insertContainerContID(String companyID) throws Exception {
		return (String) select("EzApprovalGAdmin.insertContainerContID", companyID);
	}
	
	public String insertFormContainerConti(String companyID) throws Exception {
		return (String) select("EzApprovalGAdmin.insertFormContainerConti", companyID);
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
	
	public Integer getTaskCodeDeptCnt(Map<String, Object> map) throws Exception {
		select("EzApprovalGAdmin.getTaskCodeDeptCnt", map);
		return (Integer) map.get("v_pCount");
	}
	
	public Integer searchManageAprDocListCount(Map<String, Object> map) throws Exception {
		select("EzApprovalGAdmin.searchManageAprDocListCount", map);
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
	
	public void insertReceiveGroupItemInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertReceiveGroupItemInfo", map);
	}
	
	public void insertReceiveGroupInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertReceiveGroupInfo", map);
	}
	
	public void setTaskCategory(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.setTaskCategory", map);
	}
	
	public void setTaskHistory(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.setTaskHistory", map);
	}

	public void insertTaskCode(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertTaskCode", map);
	}
	
	public void insertDeptInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertDeptInfo", map);
	}
	
	public void insertSealInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertSealInfo", map);
	}
	
	public void insertDeptSealInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertDeptSealInfo", map);
	}
	
	public void insertFormContainer(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertFormContainer", map);
	}

	public void insertFormContainerGroup(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertFormContainerGroup", map);
	}
	
	public void updateContainer(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.updateContainer", map);
	}

	public void updateReceiveGroupInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.updateReceiveGroupInfo", map);
	}
	
	public void updateTaskCode(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.updateTaskCode", map);
	}
	
	public void updateDeptInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.updateDeptInfo", map);
	}
	
	public void removeTaskCode(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.removeTaskCode1", map);
		update("EzApprovalGAdmin.removeTaskCode2", map);
	}
	
	public void removeDeptInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.removeDeptInfo", map);
	}

	public void deleteSealInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.deleteSealInfo", map);
	}
	
	public void deleteDeptSealInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.deleteSealInfo", map);
	}
	
	public void setFormOrder(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.setFormOrder", map);
	}
	
	public void updateFormContainer(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.updateFormContainer", map);
	}
	
	public void deleteContainerDocState(String companyID) throws Exception {
		delete("EzApprovalGAdmin.deleteContainerDocState", companyID);
	}

	public void deleteContainerUseDep(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteContainerUseDep", map);
	}

	public void deleteContainer(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteContainer", map);
	}

	public void deleteReceiveGroupItemInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteReceiveGroupItemInfo", map);
	}

	public void deleteReceiveGroupInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteReceiveGroupInfo", map);
	}

	public void removeTaskCategory(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.removeTaskCategory", map);
	}

	public void deleteFormContUserGroup(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteFormContUserGroup", map);
	}

	public void deleteFormContainer(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteFormContainer", map);
	}
	
	public void deleteForm(Map<Object, String> map) throws Exception {
		delete("EzApprovalGAdmin.deleteForm", map);
	}

	

	

	





	

	public String setFormData(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalGAdmin.setFormData", map);
	}



}
