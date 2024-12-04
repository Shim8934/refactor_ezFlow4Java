package egovframework.ezEKP.ezApprovalG.service;

import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGContInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormConnInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezApprovalG.vo.KEDAuthorUserInfo;
import egovframework.ezEKP.ezApprovalG.vo.KEDSharedUserInfo;
import egovframework.let.user.login.vo.LoginVO;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface EzApprovalGAdminService {

	public String getContainerInfoManage(String deptID, String type, String companyID, String lang, int tenantID) throws Exception;

	public String getContTypeInfo(String type, String companyID, String primary, int tenantID, String lang) throws Exception;
	
	public String deleteContainerType(String docTypeID, String companyID, int tenantID) throws Exception;
	
	public String getContainerToDocStateInfo(String companyID, String primary, int tenantID, String approvalFlag, String lang) throws Exception;
	
	public String updateContainerToDocStateInfo(Document xmlData, String companyID, int tenantID) throws Exception;
	
	public String getContainerUseDeptInfo(String contID, String companyID, String primary, int tenantID) throws Exception;
	
	public String insertContainer(Document xmlData, String companyID, int tenantID) throws Exception;
	
	public String updateContainer(Document doc, String companyID, int tenantID) throws Exception;
	
	public String deleteContainer(String contID, String companyID, int tenantID) throws Exception;
	
	public String getReceiveGroupInfo(String pid, String mode,	String companyID, String lang, int tenantID, String offset, String approvalFlag) throws Exception;
	
	public String insertReceiveGroupItemInfo(String groupID, String deptID,	String deptName, String deptName2, String pCompanyID, String companyID, int tenantID, String extReceptYn) throws Exception;
	
	public String updateReceiveGroupItemInfo(String groupID, String deptID,	String deptName, String deptName2, String pCompanyID, String companyID, int tenantID) throws Exception;
	
	public String deleteReceiveGroupItemInfo(String groupID, String companyID, int tenantID) throws Exception;
	
	public String updateReceiveGroupInfo(String groupID, String groupName, String companyID, int tenantID) throws Exception;
	
	public String insertReceiveGroupInfo(String groupName, String companyID, int tenantID) throws Exception;
	
	public String deleteReceiveGroupInfo(String groupID, String companyID, int tenantID) throws Exception;
	
	public String getTaskCategoryTree(String categoryType, String parentID, String companyID, int tenantID, String approvalFlag, LoginVO userInfo) throws Exception;
	
	public String getTaskInSubCategoryForManage(String sCateCode, String langType, String companyID, int tenantID, String approvalFlag, String userFlag) throws Exception;

	public String getTaskCategoryDuplicate(String categoryType, String categoryCode, String companyID, int tenantID) throws Exception;

	public String setTaskCategory(String categoryType, String categoryCode, String categoryName, String categoryName2, String categoryDesc, String pCode, String companyID, int tenantID, String approvalFlag) throws Exception;

	public String getTaskCategoryNodeExist(String categoryType, String categoryCode, String companyID, int tenantID, String approvalFlag) throws Exception;

	public String getTaskCategoryNodeCnt(String categoryType, String categoryCode, String companyID, int tenantID, String approvalFlag) throws Exception;

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
	
	public String getTaskFullList(String deptCode, String pageSize, String pageNo, String langType, String companyID, int tenantID, String title, String code, String flag, String orderOption1, String orderOption2) throws Exception;
	
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
			String apprToMonth, String apprToDay, String formID, String formName,
			String draftDeptName, String draftDeptName2, String pageNum,
			String pageSize, String docState, String subQuery,
			String orderCell, String orderOption, String companyID, String primary, String approvUser, String offset, int tenantID) throws Exception;

	public String setFormOrder(String formContID, String boardIDList, String companyID, int tenantID) throws Exception;
	
	public String insertFormContainer(String contName, String contName2, String contDescript, String contParent, String contDept, String deptList, String companyID, int tenantID) throws Exception;
	
	public String getGroupDept(String contID, String lang, String companyID, int tenantID) throws Exception;
	
	public String updateFormContainer(String contName, String contName2, String contDescript, String contParent, String contDept, String contID, String deptList, String companyID, int tenantID) throws Exception;
	
	public String deleteFormContainer(String contID, String companyID, int tenantID) throws Exception;
	
	public ApprGFormVO getFormContent(String formID, String lang, String companyID,int tenantID, String approvalFlag) throws Exception;
	
	public String delForm(String formID, String companyID, String realPath, int tenantID, String officeFlag) throws Exception;
	
	public String getFormRecvAdmin(String formID, String lang, String companyID, int tenantID, String approvalFlag, String useReceiveInfoName) throws Exception;

	public String saveFormInfo(String contID, String formID, String formInfo, String formConnInfo, String formWorkFlow, String formRecevGroup, String formMhtInfo, String formAutoRule, String formAutoRuleLine, String companyID, String realPath, LoginVO userInfo, String approvalFlag, String reformMht, String reformHtml, String reformFunction) throws Exception;

	public String setContainerIDForDoc1(String deptID, String containerType, String companyID, int tenantID) throws Exception;
	
	public String setContainerIDForDoc2(String docID, String containerID, String companyID, int tenantID) throws Exception;
	
	public void insertContainerType(String docTypeName, String docTypeName2, String companyID, int tenantID) throws Exception;

	public String getFormProperty(Locale locale, String companyID, int tenantID) throws Exception;

	public String formMove(String companyID, String contID, String selContID, String formID, int tenantID) throws Exception;
	
	public String moveDocList(String strMoveListIDInfo, String SourceContID, String TargetContID, String chkAll, String companyID, int tenantID) throws Exception;

	/* 2024-06-04 홍승비 - 현재 사용되지 않는 메서드로 확인하여 주석처리 */
	// public String deleteDocList(String xmlPara, String offset, String companyID, int tenantID) throws Exception;
	
	public String getSecurityType(String selected, LoginVO userInfo, String companyID, String approvalFlag) throws Exception;

	public String getKeepType(String selected, LoginVO userInfo, String companyID, String approvalFlag) throws Exception;
	
	public String getEtcName(String code1, String selected, String primary, String langType, String companyID, int tenantID) throws Exception;

	public String getFormAprRule(String formID, String companyID, int tenantID) throws Exception;

	public String getFormAprRuleLine(String formID, String companyID, int tenantID) throws Exception;

	/* 2024-04-19 홍승비 - 특수문서함 관련 기능 > 호출되지 않는 URL로 확인, 관련 메서드와 쿼리 전체 주석처리 */
	/*
	public String getSpecialContList(String deptID, String companyID, String lang, int tenantID, String approvalFlag) throws Exception;

	public String getSpecialContCode(String contType, String companyID, String lang, int tenantID) throws Exception;
	
	public String getSpecialContInfo(String deptID, String contType, String sn, String companyID, String lang, int tenantID) throws Exception;

	public String addSpecialCont(ApprGContInfoVO vo, int tenantID) throws Exception;

	public String delSpecialCont(ApprGContInfoVO vo, int tenantID) throws Exception;
	
	public String changeSpecialContSN(String deptID, String sContType, String sSn, String tContType, String tSn, String companyID, int tenantID) throws Exception;
	*/
	
	public List<ApprGFormConnInfoVO> getFormConnInfo() throws Exception;
	
	public String editApprovalDoc(String docID, String companyID, String formMHT, String formHTML, String realPath, LoginVO userInfo, String filePath, String htmlData) throws Exception;

	public String saveFormInfoHWP(String contID, String formID, String formInfo, String formConnInfo, String formWorkFlow, String formRecevGroup, String formMHT, String formAutoRule, String formAutoRuleLine, String companyID, String realPath, LoginVO userInfo, String approvalFlag) throws Exception;

	public String formConnSave(String formID, String formText, String path, String companyID) throws Exception;
	
	public String getParentContName(String formID, String companyID, int tenantID, String langType) throws Exception;
	
	public int getContDocListCountjson(String containerID, String userID, String userSecurityCode, boolean publicFlag, String companyID, int tenantID, Map<String,Object> queryMap) throws Exception;
	
	public int getDeleteDocListCountjson(String userID, String userSecurityCode, boolean publicFlag, String companyID, int tenantID, Map<String,Object> queryMap) throws Exception;
	
	public List<ApprGDocListVO> getContDocList_json(String containerID, String userID, String userSecurityCode, boolean publicFlag, int startRow, int pageSize, String pageNum, String orderCell, String orderOption, int totalcnt, String companyID, String lang, int tenantID, String offset, Locale locale, Map<String,Object> queryMap) throws Exception;

	public String getIsUse(String code1, String code2, String companyID, String userLang, int tenantID) throws Exception;
	
	public String deleteDocListjson(String[] DocDelIDArr, String[] DocDelNoArr, String[] DocDelTitleArr, String[] DocDelWriterNameArr, String[] DocDelDeptNameArr,String deleteDay, String DeluserId, String offset, String companyID, int tenantID) throws Exception;

	public List<ApprGDocListVO> getDeleteDocList_json(String userID, int startRow, int pageSize, String pageNum, int totalcnt, String companyID, int tenantID, String offset, String lang, Locale locale, Map<String,Object> queryMap) throws Exception;
	
	public String getExAttribute(String buJaeId, int tenantID) throws Exception;
	
	public List<ApprGAttachInfoVO> getAdminTotalDownload(String docIdList, String mode, String companyID, int tenantID) throws Exception;

	public List<ApprGAttachInfoVO> getAdminTotalDownloadCnt(String docIdList, String mode, String companyID, int tenantID) throws Exception;

	public void resendOpenGov(String resendStartTime, String resendEndTime, int tenantId, String companyID) throws Exception;

	public String getModifyOpenGovHistory(String docID, String lang, int tenantId, String companyID, String offset) throws Exception;

	public String getModifyOpenGovHistoryReason(String docID, String sn, int tenantId, String companyID) throws Exception;
	
	/* 2020-05-15 홍승비 - 첨부파일 개수제한 관련 메서드 */
	public int getAttachLimit(String companyID, int tenantId) throws Exception;
	
	public void saveAttachLimit(String attachLimit, String companyID, int tenantId) throws Exception;
	
	public void deleteAttachLimit(String companyID, int tenantId) throws Exception;

	public List<KEDSharedUserInfo> getDocDirShareList(String ownerId, int tenantId) throws Exception;
	
	public List<KEDAuthorUserInfo> getDocDirOwnerList(String companyId, int tenantId) throws Exception;

	public String insertShareDocDir(String ownerId, String ownerType, List<KEDSharedUserInfo> shareList, int tenantId) throws Exception;

	String deleteShareDocDir(String ownerId, int tenantId) throws Exception;
	
	public String getSendOutDocList(String userID, String deptID, String mode, String pageSize, String pageNum, String sortHeader, String sortOption, String companyID, String userLang, int tenantID, String offset, Map<String,Object> queryMap) throws Exception;

	/* 2024-06-04 홍승비 - 구버전 전자결재 전체문서조회(완료문서) 문서목록 호출 함수 > 호출되지 않는 URL로 확인, 관련 메서드와 쿼리 주석처리 */
	/*public String getAdminSearchDocList(
			String formID,
			String formName,
			String docNumber,
			String docTitle, 
			String drafter, 
			String approvUser, 
			String draftDeptName, 
			String draftfrom, 
			String draftto, 
			String apprfrom,
			String apprto, 
			String pageSize, 
			String pageNum, 
			String orderCell, 
			String orderOption, 
			String companyID,  
			int tenantID, 
			String lang, 
			String offSet, 
			String approvalFlag,
			String keyword,
			Locale locale
			) throws Exception;
	*/
	public String auditApprLineManage(String loginCookie, HttpServletRequest request, HttpServletResponse response, ModelAndView model) throws Exception;

	public String getAuditApprLineList(String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception;

	public String auditApprLineManagePop(String loginCookie, HttpServletRequest request, HttpServletResponse response, ModelAndView model) throws Exception;

	public Object getAuditApprLineListPrc(String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception;
	
	public Object getAuditStatisticsDocList(String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception;

	public String xlsSetGroupWithExcel(String loginCookie, MultipartHttpServletRequest request) throws Exception;

	public String xlsxSetGroupWithExcel(String loginCookie, MultipartHttpServletRequest request) throws Exception;
	
	public String getChaebunDeptList(String deptID, String companyID, LoginVO userInfo) throws Exception;

	public String setChaebunDeptList(Document doc, LoginVO userInfo) throws Exception;
	
	/* 2022-12-09 홍승비 - 전자결재G > 현재 년도 기준의 종료예정 기록물철을 리스트로 리턴하는 메서드 */
    public List<Map<String, Object>> getCabinetListByExpireYear(String currYear, String companyID, int tenantID) throws Exception;
    
    /* 2022-12-09 홍승비 - 전자결재G > 현재 년도 기준의 종료예정 기록물철을 원하는 생산연도의 기록물철로 복사하여 삽입하는 메서드 */
	public int cloneMultipleCabinets(String regYear, List<Map<String, Object>> cabinetList, String strLang, String companyID, int tenantID) throws Exception;
	
	/* 2024-04-05 전인하 - 전자결재G > 기록물관리 > 단위업무 관리 > 총 단위업무 갯수 카운트 호출 */
	public int getTaskListCount(String deptCode, String companyID, int tenantID, String title, String code, String flag) throws Exception;

	public List<String> getIronListYear(String companyID, int tenantID) throws Exception;
	
	/* 2024-07-16 기민혁 - 전자결재 > 양식함 이동 */
	public String contMove(String companyID, String contID, String selContID, String parentContID, int tenantID) throws Exception;

	/* 2024-07-17 기민혁 - 전자결재 > 양식함 순서조정 리스트 호출  */
	public List<ApprGFormVO> getSNFContList(String contID, String companyID, int tenantID) throws Exception;

	/* 2024-07-17 기민혁 - 전자결재 > 양식함 순서조정 실행 함수  */
	public String moveContSN(String contID, String groupList, String companyID, int tenantID) throws Exception;
	
}
