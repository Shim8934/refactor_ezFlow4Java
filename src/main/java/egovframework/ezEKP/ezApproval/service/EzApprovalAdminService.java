package egovframework.ezEKP.ezApproval.service;

import java.util.List;
import java.util.Locale;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezApproval.vo.ApprConnInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocGroupVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocItemVO;
import egovframework.ezEKP.ezApproval.vo.ApprExcelOutVO;
import egovframework.ezEKP.ezApproval.vo.ApprFormContVO;
import egovframework.ezEKP.ezApproval.vo.ApprFormInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprReceiveGroupVO;
import egovframework.ezEKP.ezApproval.vo.ApprSealInfoVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzApprovalAdminService {

	public List<ApprContInfoVO> getUseContInfo(ApprContInfoVO apprContInfoVO) throws Exception;

	public List<ApprDocInfoVO> getCodeContainer(LoginVO userInfo) throws Exception;

	public String getUserContTree(LoginVO userInfo, String parentContID) throws Exception;

	public String getListContainer(LoginVO userInfo) throws Exception;

	public String getDeptContTree(LoginVO userInfo, String parentContID) throws Exception;

	public List<ApprContInfoVO> getSpecialContTree(LoginVO userInfo) throws Exception;

	public String getDocType(String selected, LoginVO userInfo) throws Exception;

	public String getContainerInfoManage(String deptID, String mode, String companyID, LoginVO userInfo) throws Exception;

	public String getContTypeInfo(String mode, String companyID, LoginVO userInfo) throws Exception;

	public String insertContainerType(String docTypeName, String docTypeName2, String companyID, int tenantID) throws Exception;

	public String deleteContainerType(String codeID, String companyID, int tenantID) throws Exception;

	public String getContainerToDocStateInfo(String companyID, Locale locale, String lang, int tenantID) throws Exception;

	public String updateContainerToDocStateInfo(Document doc, String companyID, String lang, int tenantID) throws Exception;

	public String getContainerUseDeptInfo(String contID, String companyID, String lang, int tenantID) throws Exception;

	public String insertContainer(String contType, String contOwnDeptID, String selUseDept, String companyID, String lang, int tenantID) throws Exception;

	public String updateContainer(String contType, String contID, String contOwnDeptID, String selUseDept, String companyID, String lang, int tenantID) throws Exception;

	public String deleteContainer(String contID, String companyID, String lang, int tenantID) throws Exception;

	public String getSpecialContList(String deptID, String companyID, String lang, int tenantID) throws Exception;

	public String getSpecialContCode(String contType, String companyID, String lang, int tenantID) throws Exception;

	public String getSpecialContInfo(String deptID, String contType, String sn, String companyID, String lang, int tenantID) throws Exception;

	public String getFormContainerInfo(String id, String deptID, String companyID, String lang, int tenantID) throws Exception;

	public String getFormInfo(ApprFormInfoVO apprFormInfoVO) throws Exception;

	public String addSpecialCont(ApprContInfoVO apprContInfoVO, int tenantID) throws Exception;

	public String delSpecialCont(ApprContInfoVO apprContInfoVO, int tenantID) throws Exception;

	public String changeSpecialContSN(String deptID, String sContType, String sSn, String tContType, String tSn, String companyID, int tenantID) throws Exception;

	public String getContDocList(String contID, String userID, StringBuilder subQuery, int pageSize, int pageNum, String sortHeader, String sortOption, String companyID, LoginVO userInfo) throws Exception;

	public String moveDocList(String xmlPara, String companyID, int tenantID) throws Exception;

	public String getKeepType(String selected, LoginVO userInfo) throws Exception;

	public String deleteDocList(String xmlPara, String offset, String companyID, int tenantID) throws Exception;

	public String getReceiveGroupInfo(String groupID, String mode, String companyID, String lang, int tenantID) throws Exception;

	public String insertReceiveGroupInfo(ApprReceiveGroupVO apprReceiveGroupVO) throws Exception;

	public String insertReceiveGroupItemInfo(ApprReceiveGroupVO apprReceiveGroupVO) throws Exception;

	public String updateGroupMainInfo(ApprReceiveGroupVO apprReceiveGroupVO) throws Exception;

	public String deleteGroupMainInfo(ApprReceiveGroupVO apprReceiveGroupVO) throws Exception;

	public String deleteGroupSubItemInfo(ApprReceiveGroupVO apprReceiveGroupVO) throws Exception;

	public String getItemCodeGroup(ApprDocGroupVO apprDocGroupVO) throws Exception;

	public int insertItemCodeGroup(ApprDocGroupVO apprDocGroupVO) throws Exception;

	public String deleteItemCodeGroup(ApprDocGroupVO apprDocGroupVO) throws Exception;

	public String updateItemCodeGroup(ApprDocGroupVO apprDocGroupVO) throws Exception;

	public String getItemCodeItem(ApprDocGroupVO apprDocGroupVO) throws Exception;

	public String getSecurityType(String selected, LoginVO userInfo) throws Exception;

	public int getMaxItemCode(LoginVO userInfo) throws Exception;

	public String insertItemCodeItem(ApprDocItemVO apprDocItemVO) throws Exception;

	public String updateItemCodeItem(ApprDocItemVO apprDocItemVO) throws Exception;

	public String deleteItemCodeItem(ApprDocItemVO apprDocItemVO) throws Exception;

	public String getSealList(ApprSealInfoVO apprSealInfoVO) throws Exception;

	public String insertSealInfo(ApprSealInfoVO apprSealInfoVO) throws Exception;

	public String getUserDocCount(ApprExcelOutVO apprExcelOutVO, Locale locale, String offset) throws Exception;

	public String getDeptTranSendDocCount(ApprExcelOutVO apprExcelOutVO, String offset) throws Exception;

	public String insertFormContainer(ApprFormContVO apprFormContVO, String offset) throws Exception;

	public String deleteFormContainer(String formContID, String companyID, int tenantID) throws Exception;

	public String getListHeader(String code, LoginVO userInfo) throws Exception;

	public String getAprType(LoginVO userInfo) throws Exception;

	public String getFormAprRule(String formID, String companyID, int tenantID) throws Exception;

	public String getFormAprRuleLine(String formID, String companyID, int tenantID) throws Exception;

	public String getFormContentReform(String formID, String lang, String companyID, int tenantID) throws Exception;

	public String getFormRecvAdmin(ApprFormInfoVO apprFormInfoVO) throws Exception;

	public String getFormProperty(Locale locale, String companyID, int tenantID) throws Exception;

	public String saveFormInfo(ApprFormInfoVO apprFormInfoVO, String realPath, Locale locale) throws Exception;

	public String saveFormInfoReform(ApprFormInfoVO apprFormInfoVO, String realPath, Locale locale) throws Exception;

	public List<ApprConnInfoVO> getFormConnInfo(LoginVO userInfo) throws Exception;

	public String getFormContent(ApprFormInfoVO apprFormInfoVO) throws Exception;

	public String deleteForm(ApprFormInfoVO apprFormInfoVO) throws Exception;

	public String formMove(ApprFormContVO apprFormContVO) throws Exception;

	public String setFormOrder(ApprFormContVO apprFormContVO) throws Exception;

	public String saveHwpFormInfo(ApprFormInfoVO apprFormInfoVO, String realPath, Locale locale) throws Exception;

}
