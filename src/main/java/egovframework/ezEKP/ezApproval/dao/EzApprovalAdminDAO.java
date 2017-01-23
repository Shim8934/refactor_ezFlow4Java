package egovframework.ezEKP.ezApproval.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezApproval.vo.ApprAutoRuleVO;
import egovframework.ezEKP.ezApproval.vo.ApprCodeVO;
import egovframework.ezEKP.ezApproval.vo.ApprConnInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocGroupVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocItemVO;
import egovframework.ezEKP.ezApproval.vo.ApprExcelOutVO;
import egovframework.ezEKP.ezApproval.vo.ApprFormContVO;
import egovframework.ezEKP.ezApproval.vo.ApprFormInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprLineInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprReceiptInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprReceiveGroupVO;
import egovframework.ezEKP.ezApproval.vo.ApprSealInfoVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository
public class EzApprovalAdminDAO extends EgovAbstractDAO{

	public String getCode2Name(ApprCodeVO apprCodeVO) throws Exception{
		return (String) select("EzApprovalAdminDAO.getCode2Name", apprCodeVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprCodeVO> getDocType(int tenantID) throws Exception{
		return (List<ApprCodeVO>) list("EzApprovalAdminDAO.getDocType", tenantID);
	}

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getContainerInfoManage(LoginVO userInfo) throws Exception{
		return (List<ApprContInfoVO>) list("EzApprovalAdminDAO.getContainerInfoManage", userInfo);
	}

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getContTypeInfo(LoginVO userInfo) throws Exception{
		return (List<ApprContInfoVO>) list("EzApprovalAdminDAO.getContTypeInfo", userInfo);
	}

	public void insertContainerType(Map<String, Object> map) throws Exception{
		insert("EzApprovalAdminDAO.insertContainerType", map);
	}

	public void deleteContainerType(Map<String, Object> map) throws Exception{
		delete("EzApprovalAdminDAO.deleteContainerType", map);
	}
	
	public void deleteContDocState(Map<String, Object> map) throws Exception{
		delete("EzApprovalAdminDAO.deleteContDocState", map);
	}

	public int getContCount(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalAdminDAO.getContCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprCodeVO> getListHeader(Map<String, Object> map) throws Exception{
		return (List<ApprCodeVO>) list("EzApprovalAdminDAO.getListHeader", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getContainerToDocStateInfo(Map<String, Object> map) throws Exception{
		return (List<ApprContInfoVO>) list("EzApprovalAdminDAO.getContainerToDocStateInfo", map);
	}

	public void deleteContainerToDocStateInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalAdminDAO.deleteContainerToDocStateInfo", map);
	}

	public void insertContainerToDocStateInfo(String insString) throws Exception{
		insert("EzApprovalAdminDAO.insertContainerToDocStateInfo", insString);
	}

	@SuppressWarnings("unchecked")
	public List<String> getContainerUseDeptInfo(Map<String, Object> map) throws Exception{
		return (List<String>) list("EzApprovalAdminDAO.getContainerUseDeptInfo", map);
	}

	public void insertContainer(Map<String, Object> map) throws Exception{
		insert("EzApprovalAdminDAO.insertContainer", map);
	}

	public void insertContainerUseDept(String insString) throws Exception{
		insert("EzApprovalAdminDAO.insertContainerUseDept", insString);
	}

	public void updateContainer(Map<String, Object> map) throws Exception{
		update("EzApprovalAdminDAO.updateContainer", map);
	}

	public void deleteContainerUseDept(Map<String, Object> map) throws Exception{
		delete("EzApprovalAdminDAO.deleteContainerUseDept", map);
	}

	public void deleteContainer(Map<String, Object> map) throws Exception{
		delete("EzApprovalAdminDAO.deleteContainer", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getSpecialContList(Map<String, Object> map) throws Exception{
		return (List<ApprContInfoVO>) list("EzApprovalAdminDAO.getSpecialContList", map);
	}

	public String getSpecialContInfoContTypeName(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalAdminDAO.getSpecialContInfoContTypeName", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprCodeVO> getCodeType(Map<String, Object> map) throws Exception{
		return (List<ApprCodeVO>) list("EzApprovalAdminDAO.getCodeType", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getSpecialContInfo(ApprContInfoVO apprContInfoVO) throws Exception{
		return (List<ApprContInfoVO>) list("EzApprovalAdminDAO.getSpecialContInfo", apprContInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<String> getSpecialContInfoFormName(Map<String, Object> map) throws Exception{
		return (List<String>) list("EzApprovalAdminDAO.getSpecialContInfoFormName", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprFormContVO> getFormContainerInfo(Map<String, Object> map) throws Exception{
		return (List<ApprFormContVO>) list("EzApprovalAdminDAO.getFormContainerInfo", map);
	}

	public int getFormContainerCntChild(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalAdminDAO.getFormContainerCntChild", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprFormInfoVO> getFormInfo(ApprFormInfoVO apprFormInfoVO) throws Exception{
		return (List<ApprFormInfoVO>) list("EzApprovalAdminDAO.getFormInfo", apprFormInfoVO);
	}

	public void deleteSpecialContInfo(ApprContInfoVO apprContInfoVO) throws Exception{
		delete("EzApprovalAdminDAO.deleteSpecialContInfo", apprContInfoVO);
	}

	public void insertSpecialContInfo(ApprContInfoVO apprContInfoVO) throws Exception{
		insert("EzApprovalAdminDAO.insertSpecialContInfo", apprContInfoVO);
	}

	public void changeSpecialContSN1(ApprContInfoVO apprContInfoVO) throws Exception{
		update("EzApprovalAdminDAO.changeSpecialContSN1", apprContInfoVO);
	}

	public void changeSpecialContSN2(ApprContInfoVO apprContInfoVO) {
		update("EzApprovalAdminDAO.changeSpecialContSN2", apprContInfoVO);
	}
	
	public void changeSpecialContSN3(ApprContInfoVO apprContInfoVO) {
		update("EzApprovalAdminDAO.changeSpecialContSN3", apprContInfoVO);
	}

	public String getUserSecurityCode(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalAdminDAO.getUserSecurityCode", map);
	}

	public String getCodeIsUse(ApprCodeVO apprCodeVO) throws Exception {
		return (String) select("EzApprovalAdminDAO.getCodeIsUse", apprCodeVO);
	}

	public int getContDocListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalAdminDAO.getContDocListCount", map);
	}

	public String getProcessYN(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalAdminDAO.getProcessYN", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprDocInfoVO> getContDocList(Map<String, Object> map) throws Exception{
		return (List<ApprDocInfoVO>) list("EzApprovalAdminDAO.getContDocList", map);
	}

	public void moveAllDocList1(Map<String, Object> map) throws Exception {
		update("EzApprovalAdminDAO.moveAllDocList1", map);
	}

	public void moveAllDocList2(Map<String, Object> map) throws Exception {
		update("EzApprovalAdminDAO.moveAllDocList2", map);
	}

	public void moveDocList1(Map<String, Object> map) throws Exception {
		update("EzApprovalAdminDAO.moveDocList1", map);
	}

	public void moveDocList2(Map<String, Object> map) throws Exception {
		update("EzApprovalAdminDAO.moveDocList2", map);
	}

	public void deleteAllDocList(Map<String, Object> map) throws Exception {
		update("EzApprovalAdminDAO.deleteAllDocList", map);
	}

	public void deleteDocList(Map<String, Object> map) throws Exception {
		update("EzApprovalAdminDAO.deleteDocList", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprReceiveGroupVO> getReceiveGroupInfo(Map<String, Object> map) throws Exception {
		return (List<ApprReceiveGroupVO>) list("EzApprovalAdminDAO.getReceiveGroupInfo", map);
	}

	public void insertReceiveGroupInfo(ApprReceiveGroupVO apprReceiveGroupVO) throws Exception {
		insert("EzApprovalAdminDAO.insertReceiveGroupInfo", apprReceiveGroupVO);
	}

	public void insertReceiveGroupItemInfo(ApprReceiveGroupVO apprReceiveGroupVO) throws Exception {
		insert("EzApprovalAdminDAO.insertReceiveGroupItemInfo", apprReceiveGroupVO);
	}

	public void updateGroupMainInfo(ApprReceiveGroupVO apprReceiveGroupVO) throws Exception {
		update("EzApprovalAdminDAO.updateGroupMainInfo", apprReceiveGroupVO);
	}

	public void deleteGroupMainInfo(ApprReceiveGroupVO apprReceiveGroupVO) throws Exception {
		delete("EzApprovalAdminDAO.deleteGroupMainInfo", apprReceiveGroupVO);
	}

	public void deleteGroupSubItemInfo(ApprReceiveGroupVO apprReceiveGroupVO) throws Exception {
		delete("EzApprovalAdminDAO.deleteGroupSubItemInfo", apprReceiveGroupVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprDocGroupVO> getItemCodeGroup(ApprDocGroupVO apprDocGroupVO) throws Exception {
		return (List<ApprDocGroupVO>) list("EzApprovalAdminDAO.getItemCodeGroup", apprDocGroupVO);
	}

	public int getItemCodeGroupLeaf(ApprDocGroupVO apprDocGroupVO) throws Exception {
		return (int) select("EzApprovalAdminDAO.getItemCodeGroupLeaf", apprDocGroupVO);
	}

	public int insertItemCodeGroup(ApprDocGroupVO apprDocGroupVO) throws Exception {
		return (int) insert("EzApprovalAdminDAO.insertItemCodeGroup", apprDocGroupVO);
	}

	public void deleteItemCodeGroup(ApprDocGroupVO apprDocGroupVO) throws Exception {
		delete("EzApprovalAdminDAO.deleteItemCodeGroup", apprDocGroupVO);
	}

	public void updateItemCodeGroup(ApprDocGroupVO apprDocGroupVO) throws Exception {
		update("EzApprovalAdminDAO.updateItemCodeGroup", apprDocGroupVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprDocItemVO> getItemCodeItem(ApprDocGroupVO apprDocGroupVO) throws Exception {
		return (List<ApprDocItemVO>) list("EzApprovalAdminDAO.getItemCodeItem", apprDocGroupVO);
	}

	public String getEtcName(ApprCodeVO apprCodeVO) throws Exception {
		return (String) select("EzApprovalAdminDAO.getEtcName", apprCodeVO);
	}

	public int getMaxItemCode(LoginVO userInfo) throws Exception {
		return (int) select("EzApprovalAdminDAO.getMaxItemCode", userInfo);
	}

	public void insertItemCodeItem(ApprDocItemVO apprDocItemVO) throws Exception {
		insert("EzApprovalAdminDAO.insertItemCodeItem", apprDocItemVO);
	}

	public void updateItemCodeItem(ApprDocItemVO apprDocItemVO) throws Exception {
		update("EzApprovalAdminDAO.updateItemCodeItem", apprDocItemVO);
	}

	public void deleteItemCodeItem(ApprDocItemVO apprDocItemVO) throws Exception {
		delete("EzApprovalAdminDAO.deleteItemCodeItem", apprDocItemVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprSealInfoVO> getSealList(ApprSealInfoVO apprSealInfoVO) throws Exception {
		return (List<ApprSealInfoVO>) list("EzApprovalAdminDAO.getSealList", apprSealInfoVO);
	}

	public void deleteSealInfo(ApprSealInfoVO apprSealInfoVO) throws Exception {
		delete("EzApprovalAdminDAO.deleteSealInfo", apprSealInfoVO);
	}

	public void insertSealInfo(ApprSealInfoVO apprSealInfoVO) throws Exception {
		insert("EzApprovalAdminDAO.insertSealInfo", apprSealInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprLineInfoVO> getUserDocCount(ApprExcelOutVO apprExcelOutVO) throws Exception {
		return (List<ApprLineInfoVO>) list("EzApprovalAdminDAO.getUserDocCount", apprExcelOutVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprReceiptInfoVO> getDeptTranSendDocCount(ApprExcelOutVO apprExcelOutVO) throws Exception {
		return (List<ApprReceiptInfoVO>) list("EzApprovalAdminDAO.getDeptTranSendDocCount", apprExcelOutVO);
	}

	public int insertFormContainer(ApprFormContVO apprFormContVO) throws Exception {
		return (int) insert("EzApprovalAdminDAO.insertFormContainer", apprFormContVO);
	}

	public void insertFormContainerUserGroup(String insString) throws Exception {
		insert("EzApprovalAdminDAO.insertFormContainerUserGroup", insString);
	}

	public void deleteFormContainer(Map<String, Object> map) throws Exception{
		delete("EzApprovalAdminDAO.deleteFormContainer", map);
	}

	public void deleteFormContUserGroup(Map<String, Object> map) {
		delete("EzApprovalAdminDAO.deleteFormContUserGroup", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprCodeVO> getAprType(LoginVO userInfo) throws Exception {
		return (List<ApprCodeVO>) list("EzApprovalAdminDAO.getAprType", userInfo);
	}

	@SuppressWarnings("unchecked")
	public List<ApprAutoRuleVO> getFormAprRule(Map<String, Object> map) throws Exception {
		return (List<ApprAutoRuleVO>) list("EzApprovalAdminDAO.getFormAprRule", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprAutoRuleVO> getFormAprRuleLine(Map<String, Object> map) throws Exception {
		return (List<ApprAutoRuleVO>) list("EzApprovalAdminDAO.getFormAprRuleLine", map);
	}

	public String getFormContentReform(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalAdminDAO.getFormContentReform", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprReceiveGroupVO> getFormRecvAdmin(ApprFormInfoVO apprFormInfoVO) throws Exception {
		return (List<ApprReceiveGroupVO>) list("EzApprovalAdminDAO.getFormRecvAdmin", apprFormInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprFormInfoVO> getFormProperty(Map<String, Object> map) throws Exception {
		return (List<ApprFormInfoVO>) list("EzApprovalAdminDAO.getFormProperty", map);
	}

	public String insertFormData(ApprFormInfoVO apprFormInfoVO) throws Exception {
		return (String) insert("EzApprovalAdminDAO.insertFormData", apprFormInfoVO);
	}

	public void setAutoDocNum(ApprFormInfoVO apprFormInfoVO) throws Exception {
		insert("EzApprovalAdminDAO.setAutoDocNum", apprFormInfoVO);
	}

	public void deleteAutoRuleLine(ApprAutoRuleVO apprAutoRuleVO) throws Exception {
		delete("EzApprovalAdminDAO.deleteAutoRuleLine", apprAutoRuleVO);
	}

	public void insertAutoRuleLine(List<ApprAutoRuleVO> apprAutoRuleVOs) throws Exception {
		insert("EzApprovalAdminDAO.insertAutoRuleLine", apprAutoRuleVOs);
	}

	public void deleteAutoRule(ApprAutoRuleVO apprAutoRuleVO) throws Exception {
		delete("EzApprovalAdminDAO.deleteAutoRule", apprAutoRuleVO);
	}

	public void insertAutoRule(List<ApprAutoRuleVO> apprAutoRuleVOs) throws Exception {
		insert("EzApprovalAdminDAO.insertAutoRule", apprAutoRuleVOs);
	}

	public void deleteFormRecv(ApprReceiveGroupVO apprReceiveGroupVO) throws Exception {
		delete("EzApprovalAdminDAO.deleteFormRecv", apprReceiveGroupVO);
	}

	public void insertFormRecv(List<ApprReceiveGroupVO> apprReceiveGroupVOs) throws Exception {
		insert("EzApprovalAdminDAO.insertFormRecv", apprReceiveGroupVOs);
	}

	public void updateFormVersion(ApprFormInfoVO apprFormInfoVO) throws Exception {
		update("EzApprovalAdminDAO.updateFormVersion", apprFormInfoVO);
	}

	public void updateFormData(ApprFormInfoVO apprFormInfoVO) throws Exception {
		update("EzApprovalAdminDAO.updateFormData", apprFormInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprConnInfoVO> getFormConnInfo(LoginVO userInfo) throws Exception {
		return (List<ApprConnInfoVO>) list("EzApprovalAdminDAO.getFormConnInfo", userInfo);
	}

	@SuppressWarnings("unchecked")
	public List<ApprFormInfoVO> getFormContent(ApprFormInfoVO apprFormInfoVO) throws Exception {
		return (List<ApprFormInfoVO>) list("EzApprovalAdminDAO.getFormContent", apprFormInfoVO);
	}

	public int deleteForm(ApprFormInfoVO apprFormInfoVO) throws Exception {
		return delete("EzApprovalAdmin.deleteForm", apprFormInfoVO);
	}

	public void deleteFavoriteForm(ApprFormInfoVO apprFormInfoVO) throws Exception {
		delete("EzApprovalAdmin.deleteFavoriteForm", apprFormInfoVO);
	}

	public int formMove(ApprFormContVO apprFormContVO) throws Exception {
		return update("EzApprovalAdmin.formMove", apprFormContVO);
	}

	public int setFormOrder(ApprFormContVO apprFormContVO) throws Exception {
		return update("EzApprovalAdmin.setFormOrder", apprFormContVO);
	}
	
}
