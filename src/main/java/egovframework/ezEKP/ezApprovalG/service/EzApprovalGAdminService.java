package egovframework.ezEKP.ezApprovalG.service;

import java.util.Locale;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzApprovalGAdminService {

	public String getContainerInfoManage(String deptID, String type, String companyID, String primary, int tenantID) throws Exception;

	public String getContTypeInfo(String type, String companyID, String primary, int tenantID) throws Exception;
	
	public String deleteContainerType(String docTypeID, String companyID, int tenantID) throws Exception;
	
	public String getContainerToDocStateInfo(String companyID, String primary, int tenantID) throws Exception;
	
	public String updateContainerToDocStateInfo(Document xmlData, String companyID, int tenantID) throws Exception;
	
	public String getContainerUseDeptInfo(String contID, String companyID, String primary, int tenantID) throws Exception;
	
	public String insertContainer(Document xmlData, String companyID, int tenantID) throws Exception;
	
	public String updateContainer(Document doc, String companyID, int tenantID) throws Exception;
	
	public String deleteContainer(String contID, String companyID, int tenantID) throws Exception;
	
	public String getReceiveGroupInfo(String pid, String mode,	String companyID, String lang, int tenantID, String offset) throws Exception;
	
	public String insertReceiveGroupItemInfo(String groupID, String deptID,	String deptName, String deptName2, String pCompanyID, String companyID, int tenantID) throws Exception;
	
	public String deleteReceiveGroupItemInfo(String groupID, String companyID, int tenantID) throws Exception;
	
	public String updateReceiveGroupInfo(String groupID, String groupName, String companyID, int tenantID) throws Exception;
	
	public String insertReceiveGroupInfo(String groupName, String companyID, int tenantID) throws Exception;
	
	public String deleteReceiveGroupInfo(String groupID, String companyID, int tenantID) throws Exception;
	
	public String getTaskCategoryTree(String categoryType, String parentID, String companyID, int tenantID, String approvalFlag) throws Exception;
	
	public String getTaskInSubCategoryForManage(Document doc, int tenantID) throws Exception;

	public String getTaskCategoryDuplicate(String categoryType, String categoryCode, String companyID, int tenantID) throws Exception;

	public String setTaskCategory(String categoryType, String categoryCode, String categoryName, String categoryName2, String categoryDesc, String pCode, String companyID, int tenantID, String approvalFlag) throws Exception;

	public String getTaskCategoryNodeExist(String categoryType, String categoryCode, String companyID, int tenantID, String approvalFlag) throws Exception;

	public String removeTaskCategory(String categoryType, String categoryCode, String companyID, int tenantID, String approvalFlag) throws Exception;

	public String getTaskCodeDuplicate(String taskCode, String companyID, int tenantID) throws Exception;

	public String getTaskInfo(String pTaskCode, String pDeptCode, String companyID, int tenantID) throws Exception;

	public String setTaskCode(ApprGTaskVO vo, String categoryName, String categoryName2, String categoryDesc, String companyID, LoginVO userInfo, String approvalFlag) throws Exception;

	public String getTaskCodeNodeExist(String taskCode, String deptID, String companyID, int tenantID) throws Exception;
	
	public String removeTaskCode(String taskCode, String companyID, LoginVO userInfo, String approvalFlag) throws Exception;
	
	public String getTaskCodeDeptInfo(String taskCode, String companyID, String lang, int tenantID) throws Exception;

	public String addTaskCodeDeptInfo(String taskCode, String deptCode, String deptName, String deptName2, String companyID, LoginVO userInfo) throws Exception;
	
	public String removeTaskCodeDeptInfo(String taskCode, String deptCode, String deptName, String deptName2, String companyID, LoginVO userInfo) throws Exception;
	
	public String getTaskHistory(String taskCode, String companyID, String lang, int tenantID, String offset) throws Exception;
	
	public String getTaskFullList(String deptCode, String pageSize, String pageNo, String langType, String companyID, int tenantID) throws Exception;
	
	public String getSealList(String listFlag, String companyID, String lang, int tenantID, String offset) throws Exception;

	public String sealDelete(String realPath, String dirPath, String fileName) throws Exception;
	
	public String deleteSealInfo(String pSealNum, String companyID, int tenantID) throws Exception;
	
	public String insertSealInfo(String pSealNum, String pSealName, String pSealPath, String pSealWidth, String pSealHeight, String pRegUserID, String pRegUserName, String pRegUserName2, String companyID, int tenantID) throws Exception;

	public String getSealDeptList(String listFlag, String deptID, String companyID, String primary, String offset, int tenantID) throws Exception;
	
	public String insertDeptSealInfo(String pSealNum, String pSealName, String pSealPath, String pSealWidth, String pSealHeight, String pRegUserID, String pRegUserName, String pRegUserName2, String deptID, String companyID, int tenantID) throws Exception;

	public String deleteDeptSealInfo(String pSealNum, String deptID, String companyID, int tenantID) throws Exception;
	
	public String getDeptTranSendDocCount(String sYear, String sMonth, String eYear, String eMonth, String pMode, String companyID, String lang, String offset, int tenantID) throws Exception;
	
	public String getUserDocCount(String sYear, String sMonth, String eYear, String eMonth, String userFlag, String companyID, LoginVO userInfo) throws Exception;

	public String searchManageAprDocList(String docNumber, String docTitle,
			String drafter, String drafter2, String draftFromYear,
			String draftFromMonth, String draftFromDay, String draftToYear,
			String draftToMonth, String draftToDay, String apprFromYear,
			String apprFromMonth, String apprFromDay, String apprToYear,
			String apprToMonth, String apprToDay, String formID,
			String draftDeptName, String draftDeptName2, String pageNum,
			String pageSize, String docState, String subQuery,
			String orderCell, String orderOption, String companyID, String primary, String approvUser, String offset, int tenantID) throws Exception;

	public String setFormOrder(String formContID, String boardIDList, String companyID, int tenantID) throws Exception;
	
	public String insertFormContainer(String contName, String contName2, String contDescript, String contParent, String contDept, String deptList, String companyID, int tenantID) throws Exception;
	
	public String getGroupDept(String contID, String lang, String companyID, int tenantID) throws Exception;
	
	public String updateFormContainer(String contName, String contName2, String contDescript, String contParent, String contDept, String contID, String deptList, String companyID, int tenantID) throws Exception;
	
	public String deleteFormContainer(String contID, String companyID, int tenantID) throws Exception;
	
	public String getFormContent(String formID, String lang, String companyID,int tenantID) throws Exception;
	
	public String delForm(String formID, String companyID, String realPath, int tenantID) throws Exception;
	
	public String getFormRecvAdmin(String formID, String lang, String companyID, int tenantID) throws Exception;

	public String saveFormInfo(String contID, String formID, String formInfo, String formConnInfo, String formWorkFlow, String formRecevGroup, String formMhtInfo, String companyID, String realPath, LoginVO userInfo) throws Exception;

	public String setContainerIDForDoc1(String deptID, String containerType, String companyID, int tenantID) throws Exception;
	
	public String setContainerIDForDoc2(String docID, String containerID, String companyID, int tenantID) throws Exception;
	
	public void insertContainerType(String docTypeName, String docTypeName2, String companyID, int tenantID) throws Exception;

	public String getFormProperty(Locale locale, String companyID, int tenantID) throws Exception;

	public String formMove(String companyID, String contID, String selContID, String formID, int tenantID) throws Exception;
	
	public String moveDocList(String xmlPara, String companyID, int tenantID) throws Exception;
	

	
}
