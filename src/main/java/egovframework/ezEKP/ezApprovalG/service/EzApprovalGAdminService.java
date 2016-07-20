package egovframework.ezEKP.ezApprovalG.service;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;

public interface EzApprovalGAdminService {

	public String getContainerInfoManage(String deptID, String type, String companyID, String lang) throws Exception;

	public String getContTypeInfo(String type, String companyID, String lang) throws Exception;
	
	public String deleteContainerType(String docTypeID, String companyID) throws Exception;
	
	public String getContainerToDocStateInfo(String companyID, String lang) throws Exception;
	
	public String updateContainerToDocStateInfo(Document xmlData, String companyID) throws Exception;
	
	public String getContainerUseDeptInfo(String contID, String companyID, String lang) throws Exception;
	
	public String insertContainer(Document xmlData, String companyID) throws Exception;
	
	public String updateContainer(Document doc, String companyID) throws Exception;
	
	public String deleteContainer(String contID, String companyID) throws Exception;
	
	public String getReceiveGroupInfo(String pid, String mode,	String companyID, String lang) throws Exception;
	
	public String insertReceiveGroupItemInfo(String groupID, String deptID,	String deptName, String deptName2, String pCompanyID, String companyID) throws Exception;
	
	public String deleteReceiveGroupItemInfo(String groupID, String companyID) throws Exception;
	
	public String updateReceiveGroupInfo(String groupID, String groupName, String companyID) throws Exception;
	
	public String insertReceiveGroupInfo(String groupName, String companyID) throws Exception;
	
	public String deleteReceiveGroupInfo(String groupID, String companyID) throws Exception;
	
	public String getTaskCategoryTree(String categoryType, String parentID, String companyID) throws Exception;
	
	public String getTaskInSubCategoryForManage(Document doc) throws Exception;

	public String getTaskCategoryDuplicate(String categoryType, String categoryCode, String companyID) throws Exception;

	public String setTaskCategory(String categoryType, String categoryCode, String categoryName, String categoryName2, String categoryDesc, String pCode, String companyID) throws Exception;

	public String getTaskCategoryNodeExist(String categoryType, String categoryCode, String companyID) throws Exception;

	public String removeTaskCategory(String categoryType, String categoryCode, String companyID) throws Exception;

	public String getTaskCodeDuplicate(String taskCode, String companyID) throws Exception;

	public String getTaskInfo(String pTaskCode, String pDeptCode, String companyID) throws Exception;

	public String setTaskCode(ApprGTaskVO vo, String companyID) throws Exception;

	public String getTaskCodeNodeExist(String taskCode, String deptID, String companyID) throws Exception;
	
	public String removeTaskCode(String taskCode, String companyID) throws Exception;
	
	public String getTaskCodeDeptInfo(String taskCode, String companyID, String lang) throws Exception;

	public String addTaskCodeDeptInfo(String taskCode, String deptCode, String deptName, String deptName2, String companyID) throws Exception;
	
	public void insertContainerType(String docTypeName, String docTypeName2, String companyID) throws Exception;
	
	public String removeTaskCodeDeptInfo(String taskCode, String deptCode, String deptName, String deptName2, String companyID) throws Exception;
	
}
