package egovframework.ezEKP.ezApprovalG.service;

import java.util.List;
import java.util.Locale;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezApprovalG.vo.ApprGContInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormConnInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzApprovalGAdminService {

	public String getContainerInfoManage(String deptID, String type, String companyID, String lang, int tenantID) throws Exception;

	public String getContTypeInfo(String type, String companyID, String primary, int tenantID) throws Exception;
	
	public String deleteContainerType(String docTypeID, String companyID, int tenantID) throws Exception;
	
	public String getContainerToDocStateInfo(String companyID, String primary, int tenantID, String approvalFlag) throws Exception;
	
	public String updateContainerToDocStateInfo(Document xmlData, String companyID, int tenantID) throws Exception;
	
	public String getContainerUseDeptInfo(String contID, String companyID, String primary, int tenantID) throws Exception;
	
	public String insertContainer(Document xmlData, String companyID, int tenantID) throws Exception;
	
	public String updateContainer(Document doc, String companyID, int tenantID) throws Exception;
	
	public String deleteContainer(String contID, String companyID, int tenantID) throws Exception;
	
	public String getReceiveGroupInfo(String pid, String mode,	String companyID, String lang, int tenantID, String offset, String approvalFlag) throws Exception;
	
	public String insertReceiveGroupItemInfo(String groupID, String deptID,	String deptName, String deptName2, String pCompanyID, String companyID, int tenantID) throws Exception;
	
	public String deleteReceiveGroupItemInfo(String groupID, String companyID, int tenantID) throws Exception;
	
	public String updateReceiveGroupInfo(String groupID, String groupName, String companyID, int tenantID) throws Exception;
	
	public String insertReceiveGroupInfo(String groupName, String companyID, int tenantID) throws Exception;
	
	public String deleteReceiveGroupInfo(String groupID, String companyID, int tenantID) throws Exception;
	
	public String getTaskCategoryTree(String categoryType, String parentID, String companyID, int tenantID, String approvalFlag) throws Exception;
	
	public String getTaskInSubCategoryForManage(String sCateCode, String langType, String companyID, int tenantID, String approvalFlag, String userFlag) throws Exception;

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
	
	public String getSealList(String realPath, String listFlag, String companyID, String lang, int tenantID, String offset) throws Exception;

	public String sealDelete(String realPath, String dirPath, String fileName) throws Exception;
	
	public String deleteSealInfo(String pSealNum, String companyID, int tenantID) throws Exception;
	
	public String insertSealInfo(String pSealNum, String pSealName, String pSealPath, String pSealWidth, String pSealHeight, String pRegUserID, String pRegUserName, String pRegUserName2, String companyID, int tenantID) throws Exception;

	public String getSealDeptList(String realPath, String listFlag, String deptID, String companyID, String primary, String offset, int tenantID) throws Exception;
	
	public String insertDeptSealInfo(String pSealNum, String pSealName, String pSealPath, String pSealWidth, String pSealHeight, String pRegUserID, String pRegUserName, String pRegUserName2, String deptID, String companyID, int tenantID) throws Exception;

	public String deleteDeptSealInfo(String pSealNum, String deptID, String companyID, int tenantID) throws Exception;
	
	public String getDeptTranSendDocCount(String sYear, String sMonth, String eYear, String eMonth, String pMode, String companyID, String lang, String offset, int tenantID, String approvalFlag) throws Exception;
	
	public String getUserDocCount(String sYear, String sMonth, String eYear, String eMonth, String userFlag, String companyID, LoginVO userInfo, String approvalFlag) throws Exception;

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
	
	public ApprGFormVO getFormContent(String formID, String lang, String companyID,int tenantID, String approvalFlag) throws Exception;
	
	public String delForm(String formID, String companyID, String realPath, int tenantID) throws Exception;
	
	public String getFormRecvAdmin(String formID, String lang, String companyID, int tenantID, String approvalFlag) throws Exception;

	public String saveFormInfo(String contID, String formID, String formInfo, String formConnInfo, String formWorkFlow, String formRecevGroup, String formMhtInfo, String formAutoRule, String formAutoRuleLine, String companyID, String realPath, LoginVO userInfo, String approvalFlag) throws Exception;

	public String setContainerIDForDoc1(String deptID, String containerType, String companyID, int tenantID) throws Exception;
	
	public String setContainerIDForDoc2(String docID, String containerID, String companyID, int tenantID) throws Exception;
	
	public void insertContainerType(String docTypeName, String docTypeName2, String companyID, int tenantID) throws Exception;

	public String getFormProperty(Locale locale, String companyID, int tenantID) throws Exception;

	public String formMove(String companyID, String contID, String selContID, String formID, int tenantID) throws Exception;
	
	public String moveDocList(String strMoveListIDInfo, String SourceContID, String TargetContID, String chkAll, String companyID, int tenantID) throws Exception;

	public String deleteDocList(String xmlPara, String offset, String companyID, int tenantID) throws Exception;
	
	public String getSecurityType(String selected, LoginVO userInfo, String companyID, String approvalFlag) throws Exception;

	public String getKeepType(String selected, LoginVO userInfo, String companyID, String approvalFlag) throws Exception;
	
	public String getEtcName(String code1, String selected, String primary, String langType, String companyID, int tenantID) throws Exception;

	public String getFormAprRule(String formID, String companyID, int tenantID) throws Exception;

	public String getFormAprRuleLine(String formID, String companyID, int tenantID) throws Exception;

	public String getSpecialContList(String deptID, String companyID, String lang, int tenantID, String approvalFlag) throws Exception;

	public String getSpecialContCode(String contType, String companyID, String lang, int tenantID) throws Exception;
	
	public String getSpecialContInfo(String deptID, String contType, String sn, String companyID, String lang, int tenantID) throws Exception;

	public String addSpecialCont(ApprGContInfoVO vo, int tenantID) throws Exception;

	public String delSpecialCont(ApprGContInfoVO vo, int tenantID) throws Exception;
	
	public String changeSpecialContSN(String deptID, String sContType, String sSn, String tContType, String tSn, String companyID, int tenantID) throws Exception;

	public List<ApprGFormConnInfoVO> getFormConnInfo() throws Exception;
	
	public String editApprovalDoc(String docID, String companyID, String formMHT, String formHTML, String realPath, LoginVO userInfo, String filePath, String htmlData) throws Exception;

	public String saveFormInfoHWP(String contID, String formID, String formInfo, String formConnInfo, String formWorkFlow, String formRecevGroup, String formMHT, String formAutoRule, String formAutoRuleLine, String companyID, String realPath, LoginVO userInfo, String approvalFlag) throws Exception;

	public String formConnSave(String formID, String formText, String path, String companyID) throws Exception;
	
	public String getParentContName(String formID, String companyID, int tenantID, String langType) throws Exception;
	
	public int getContDocListCountjson(String containerID, String userID, String userSecurityCode, boolean publicFlag, String subQuery, String companyID, int tenantID) throws Exception;
	
	public int getDeleteDocListCountjson(String userID, String userSecurityCode, boolean publicFlag, String subQuery, String companyID, int tenantID) throws Exception;
	
	public List<ApprGDocListVO> getContDocList_json(String containerID, String userID, String userSecurityCode, boolean publicFlag, String subQuery, int startRow, int pageSize, String pageNum, String orderCell, String orderOption, int totalcnt, String companyID, String lang, int tenantID, String offset, Locale locale) throws Exception;

	public String getIsUse(String code1, String code2, String companyID, String userLang, int tenantID) throws Exception;
	
	public String deleteDocListjson(String[] DocDelIDArr, String[] DocDelNoArr, String[] DocDelTitleArr, String[] DocDelWriterNameArr, String[] DocDelDeptNameArr,String deleteDay, String DeluserId, String offset, String companyID, int tenantID) throws Exception;

	public List<ApprGDocListVO> getDeleteDocList_json(String userID, String subQuery, int startRow, int pageSize, String pageNum, int totalcnt, String companyID, int tenantID, String offset, String lang, Locale locale) throws Exception;
	
	public String getExAttribute(String buJaeId, int tenantID) throws Exception;
}
