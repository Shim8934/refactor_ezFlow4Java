package egovframework.ezEKP.ezApprovalG.dao;

import egovframework.ezEKP.ezApprovalG.vo.ApprGAdminReceiveVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAutoRuleVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGContInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocStateVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormConnInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpenGovModifyHistoryVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiveDocVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSealInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskCodeHistoryVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskDeptInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezApprovalG.vo.KEDAuthorUserInfo;
import egovframework.ezEKP.ezApprovalG.vo.KEDSharedUserInfo;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository("EzApprovalGAdminDAO")
public class EzApprovalGAdminDAO extends EgovAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<ApprGContInfoVO> getContainerInfoManage(Map<String, Object> map) throws Exception {
		return (List<ApprGContInfoVO>) list("EzApprovalGAdmin.getContainerInfoManage", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGContInfoVO> getContTypeInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGContInfoVO>) list("EzApprovalGAdmin.getContTypeInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGContInfoVO> getContainerUseDeptInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGContInfoVO>) list("EzApprovalGAdmin.getContainerUseDeptInfo", map);
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
	public int getTaskListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalGAdmin.getTaskListCount", map);
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
	public List<ApprGDocListVO> searchManageAprDocList(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("EzApprovalGAdmin.searchManageAprDocList", map);
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
	
	public ApprGFormVO getFormContent(Map<String, Object> map) throws Exception {
		return (ApprGFormVO) select("EzApprovalGAdmin.getFormContent", map);
	}

	public Integer deleteContainerTypeSelect(Map<String, Object> map) throws Exception {
		return (Integer) select("EzApprovalGAdmin.deleteContainerTypeSelect", map);
	}
	
	public void deleteContainerTypeDelete1(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteContainerTypeDelete1", map);
	}
	
	public void deleteContainerTypeDelete2(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteContainerTypeDelete2", map);
	}

	public String insertContainerContID(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalGAdmin.insertContainerContID", map);
	}
	
	public String insertFormContainerConti(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalGAdmin.insertFormContainerConti", map);
	}
	
	public String setFormDataSelect(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalGAdmin.setFormDataSelect", map);
	}
	
	public void setFormDataInsert1(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.setFormDataInsert1", map);
	}
	
	public void setFormDataUpdate(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.setFormDataUpdate", map);
	}
	
	public void setFormDataInsert2(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.setFormDataInsert2", map);
	}
	
	public void setFormDataDelete(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.setFormDataDelete", map);
	}
	
	public Integer getTaskCategoryDuplicate(Map<String, Object> map) throws Exception {
		return (Integer) select("EzApprovalGAdmin.getTaskCategoryDuplicate", map);
	}

	public Integer getTaskCategoryNodeExist(Map<String, Object> map) throws Exception {
		return (Integer) select("EzApprovalGAdmin.getTaskCategoryNodeExist", map);
	}

	public Integer getTaskCategoryNodeCnt(Map<String, Object> map) throws Exception {
		return (Integer) select("EzApprovalGAdmin.getTaskCategoryNodeCnt", map);
	}

	public Integer getTaskCodeDuplicate(Map<String, Object> map) throws Exception {
		return (Integer) select("EzApprovalGAdmin.getTaskCodeDuplicate", map);
	}
	
	public Integer getTaskCodeNodeExist(Map<String, Object> map) throws Exception {
		return (Integer) select("EzApprovalGAdmin.getTaskCodeNodeExist", map);
	}
	
	public Integer getTaskCodeDeptCnt(Map<String, Object> map) throws Exception {
		return (Integer) select("EzApprovalGAdmin.getTaskCodeDeptCnt", map);
	}
	
	public Integer searchManageAprDocListCount(Map<String, Object> map) throws Exception {
		return (Integer) select("EzApprovalGAdmin.searchManageAprDocListCount", map);
	}
	
	public void insertEditApproDoc(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertEditApproDoc", map);
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
	public void updateReceiveGroupItemInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.updateReceiveGroupItemInfo", map);
	}
	
	public void insertReceiveGroupInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertReceiveGroupInfo", map);
	}
	
	public void setTaskCategoryInsert(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.setTaskCategoryInsert", map);
	}
	
	public void setTaskCategoryUpdate(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.setTaskCategoryUpdate", map);
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
	
	public Integer insertSealInfoSelect(Map<String, Object> map) throws Exception {
		return (Integer) select("EzApprovalGAdmin.insertSealInfoSelect", map);
	}
	public void insertSealInfoInsert(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertSealInfoInsert", map);
	}
	public void insertSealInfoUpdate(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.insertSealInfoUpdate", map);
	}
	
	public Integer insertDeptSealInfoSelect(Map<String, Object> map) throws Exception {
		return (Integer) select("EzApprovalGAdmin.insertDeptSealInfoSelect", map);
	}
	public void insertDeptSealInfoInsert(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertDeptSealInfoInsert", map);
	}
	public void insertDeptSealInfoUpdate(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.insertDeptSealInfoUpdate", map);
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
	
	public void removeTaskCode1(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.removeTaskCode1", map);
	}
	
	public void removeTaskCode2(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.removeTaskCode2", map);
	}
	
	public void removeDeptInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.removeDeptInfo", map);
	}

	public void deleteSealInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.deleteSealInfo", map);
	}
	
	public void deleteSealDeptInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.deleteSealDeptInfo", map);
	}
	
	public void setFormOrder(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.setFormOrder", map);
	}
	
	public void updateFormContainer(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.updateFormContainer", map);
	}
	
	public void deleteContainerDocState(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteContainerDocState", map);
	}

	public void deleteContainerUseDep(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteContainerUseDep", map);
	}

	public void deleteContainer1(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteContainer1", map);
	}
	public void deleteContainer2(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteContainer2", map);
	}

	public void deleteReceiveGroupItemInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteReceiveGroupItemInfo", map);
	}

	public void deleteReceiveGroupInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteReceiveGroupInfo", map);
	}

	public void removeTaskCategory(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.removeTaskCategory", map);
	}

	public void deleteFormContUserGroup(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteFormContUserGroup", map);
	}

	public void deleteFormContainer1(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteFormContainer1", map);
	}
	public void deleteFormContainer2(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteFormContainer2", map);
	}
	
	public void deleteForm1(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteForm1", map);
	}
	
	public void deleteForm2(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdmin.deleteForm2", map);
	}
	
	public void deleteForm3(Map<String, Object> map) throws Exception{
		delete("EzApprovalGAdmin.deleteForm3", map);		
	}
	
	public String setContainerIDForDoc1(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalGAdmin.setContainerIDForDoc1", map);
	}

	public void setContainerIDForDoc2(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.setContainerIDForDoc2", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGFormVO> getFormProperty(Map<String, Object> map) throws Exception {
		return (List<ApprGFormVO>) list("EzApprovalGAdmin.getFormProperty", map);
	}

	public void formMove(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.formMove", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGListHeaderVO> getAdminListHeader(Map<String, Object> map) throws Exception {
		return (List<ApprGListHeaderVO>) list("EzApprovalGAdmin.getAdminListHeader", map);
	}
	
	public void moveAllDocListF(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdminDAO.moveAllDocListF", map);
	}

	public void moveAllDocListS(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdminDAO.moveAllDocListS", map);
	}

	public void moveDocListF(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdminDAO.moveDocListF", map);
	}

	public void moveDocListS(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdminDAO.moveDocListS", map);
	}
	
	/* 2024-06-04 홍승비 - 현재 사용되지 않는 쿼리로 확인하여 주석처리 */
	/*public void deleteDocList(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdminDAO.deleteDocList", map);
	}*/
	
	public void deleteDocListjson(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdminDAO.deleteDocListjson", map);
	}
	
	public void deleteAllDocList(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdminDAO.deleteAllDocList", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getCodeType(Map<String, Object> map) throws Exception {
		return (List<ApprGLeftVO>) list("EzApprovalGAdminDAO.getCodeType", map);
	}

	public void setAutoDocNum(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdminDAO.setAutoDocNum", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGAutoRuleVO> getFormAprRule(Map<String, Object> map) throws Exception {
		return (List<ApprGAutoRuleVO>) list("EzApprovalGAdminDAO.getFormAprRule", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGAutoRuleVO> getFormAprRuleLine(Map<String, Object> map) throws Exception{
		return (List<ApprGAutoRuleVO>) list("EzApprovalGAdminDAO.getFormAprRuleLine", map);
	}

	public void insertAutoRule(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdminDAO.insertAutoRule", map);
	}

	public void insertAutoRuleLine(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdminDAO.insertAutoRuleLine", map);
	}

	public void deleteAutoRule(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdminDAO.deleteAutoRule", map);
	}
	
	public void deleteAutoRuleLine(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdminDAO.deleteAutoRuleLine", map);
	}
	
	/* 2024-04-19 홍승비 - 특수문서함 관련 기능 > 호출되지 않는 URL로 확인, 관련 메서드와 쿼리 전체 주석처리 */
	/*
	@SuppressWarnings("unchecked")
	public List<ApprGContInfoVO> getSpecialContList(Map<String, Object> map) throws Exception {
		return (List<ApprGContInfoVO>) list("EzApprovalGAdminDAO.getSpecialContList", map);
	}

	public String getSpecialContInfoContTypeName(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalGAdminDAO.getSpecialContInfoContTypeName", map);
	}

	public ApprGContInfoVO getSpecialContInfo(Map<String, Object> map) throws Exception {
		return (ApprGContInfoVO) select("EzApprovalGAdminDAO.getSpecialContInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getSpecialContInfoFormName(Map<String, Object> map) {
		return (List<String>) list("EzApprovalGAdminDAO.getSpecialContInfoFormName", map);
	}

	public void deleteSpecialContInfo(ApprGContInfoVO vo) throws Exception {
		delete("EzApprovalGAdminDAO.deleteSpecialContInfo", vo);
	}

	public void insertSpecialContInfo(ApprGContInfoVO vo) throws Exception {
		insert("EzApprovalGAdminDAO.insertSpecialContInfo", vo);
	}
	
	public void changeSpecialContSN1(ApprGContInfoVO vo) throws Exception {
		update("EzApprovalGAdminDAO.changeSpecialContSN1", vo);
	}

	public void changeSpecialContSN2(ApprGContInfoVO vo) throws Exception {
		update("EzApprovalGAdminDAO.changeSpecialContSN2", vo);
	}

	public void changeSpecialContSN3(ApprGContInfoVO vo) throws Exception {
		update("EzApprovalGAdminDAO.changeSpecialContSN3", vo);
	}
	*/
	
	public int checkContainer(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalGAdminDAO.checkContainer", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGFormConnInfoVO> getFormConnInfo() {
		return (List<ApprGFormConnInfoVO>) list("EzApprovalGAdminDAO.getFormConnInfo");
	}
	
	public String getParentContName(Map<String, Object> map) {
		return (String) select("EzApprovalGAdminDAO.getParentContName", map);
	}
	
	public int getContDocListCountjson(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalGAdminDAO.getContDocListCountjson", map);
	}
	
	public int getDeleteDocListCountjson(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalGAdminDAO.getDeletetDocListCountjson", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getContDocListjson(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalGAdminDAO.getContDocListjson", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getDeleteDocListjson(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalGAdminDAO.getDeleteDocListjson", map);
	}
	
	public void insertDelDoc(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertDelDoc", map);
	}
	
	public String insertShareDocDir(Map<String, Object> map) throws Exception {
		String result = "NO";
		if(insert("EzApprovalGAdmin.insertShareDocDir", map) == null){
			result = "YES";
		}
		return result;
	}
	
	public int deleteShareDocDir(Map<String, Object> map) throws Exception {
		return delete("EzApprovalGAdmin.deleteShareDocDir", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<KEDSharedUserInfo> getShareDocDirShareList (Map<String, Object> map) throws Exception {
		return (List<KEDSharedUserInfo>) list("EzApprovalGAdmin.getShareDocDirShareList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<KEDAuthorUserInfo> getShareDocDirOwnerList (Map<String, Object> map) throws Exception {
		return (List<KEDAuthorUserInfo>) list("EzApprovalGAdmin.getShareDocDirOwnerList", map);
	}

	public void updateAutodoc(Map<String, Object> map) {
		update("EzApprovalGAdminDAO.updateAutoDoc", map);
	}

	public void removeAutoDoc(Map<String, Object> map) {
		update("EzApprovalGAdminDAO.removeAutoDoc", map);
	}
	
	/* 2021-01-21 심기영 오피스결재 추가 */
	public void insertOfficeFormFlag(Map<String, Object> map) {
		insert("EzApprovalGAdmin.insertOfficeFormFlag", map);
	}
	/* 2021-01-21 심기영 오피스결재 추가 */
	public void deleteOfficeFormFlag(Map<String, Object> map) {
		delete("EzApprovalGAdmin.deleteOfficeFormFlag", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAttachInfoVO> getAdminTotalDownload(Map<String, Object> map) throws Exception{
		return (List<ApprGAttachInfoVO>) list("EzApprovalGAdminDAO.getAdminTotalDownload", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGAttachInfoVO> getAdminTotalDownloadCnt(Map<String, Object> map) throws Exception{
		return (List<ApprGAttachInfoVO>) list("EzApprovalGAdminDAO.getAdminTotalDownloadCnt", map);
	}

	public void resendOpenGov(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdminDAO.resendOpenGov", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGOpenGovModifyHistoryVO> getOpenGovModifyHistory(Map<String, Object> map1) throws Exception {
		return (List<ApprGOpenGovModifyHistoryVO>) list("EzApprovalGAdminDAO.getOpenGovModifyHistory", map1);
	}

	public String getOpenGovModifyHistoryReason(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalGAdminDAO.getOpenGovModifyHistoryReason", map);
	}
	
	/* 2020-05-15 홍승비 - 첨부파일 개수제한 관련 쿼리 */
	public int cntAttachLimit(Map<String, Object> map) throws Exception {
		return (int)select("EzApprovalGAdminDAO.cntAttachLimit", map);
	}
	
	public int getAttachLimit(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalGAdminDAO.getAttachLimit", map);
	}
	
	public void saveAttachLimit(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdminDAO.saveAttachLimit", map);
	}
	
	public void deleteAttachLimit(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdminDAO.deleteAttachLimit", map);
	}

	public void updateAttachLimit(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdminDAO.updateAttachLimit", map);
	}
	
	public int getSendOutDocListCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalGAdminDAO.getSendOutDocListCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getSendOutDocList(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalGAdminDAO.getSendOutDocList", map);
	}
	
	public int checkSendOutInfoTable(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalGAdminDAO.checkSendOutInfoTable", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectSendOutInfo(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) select("EzApprovalGAdminDAO.selectSendOutInfo", map);
	}
	
	public int insertSendOutInfo(Map<String, Object> map) throws Exception{
		return update("EzApprovalGAdminDAO.insertSendOutInfo", map);
	}
	
	public int updateSendOutInfo(Map<String, Object> map) throws Exception{
		return update("EzApprovalGAdminDAO.updateSendOutInfo", map);
	}
	
	public int getSendOutDocListCount_file(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalGAdminDAO.getSendOutDocListCount_file", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getSendOutDocList_file(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalGAdminDAO.getSendOutDocList_file", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectSendOutInfoList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) list("EzApprovalGAdminDAO.selectSendOutInfoList", map);
	}
	
	public int getSearchDocListCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalGAdminDAO.getSearchDocListCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getSearchDocList(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalGAdminDAO.getSearchDocList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getAuditApprLineList(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, Object>>) list("EzApprovalGAdmin.getAuditApprLineList", map);
	}

	public int getAuditApprLineListCnt(Map<String, Object> map) throws Exception {
		return (int)select("EzApprovalGAdminDAO.getAuditApprLineListCnt", map);
	}

	public void getAuditApprLineListDel(Map<String, Object> map) throws Exception {
		super.delete("EzApprovalGAdminDAO.getAuditApprLineListDel", map);
	}

	public void getAuditApprLineListIns(Map<String, Object> map) throws Exception {
		super.insert("EzApprovalGAdminDAO.getAuditApprLineListIns", map);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getAuditStatisticsDocList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzApprovalGAdmin.getAuditStatisticsDocList", map);
	}

	public void insertReceiveGroupSubWithExcel(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdmin.insertReceiveGroupSubWithExcel", map);
	}

	public Integer checkDeptId(String deptId) throws Exception {
		return (Integer) select("EzApprovalGAdminDAO.checkDeptId", deptId);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getChaebunDeptList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzApprovalGAdminDAO.getChaebunDeptList", map);
	}
	
	public void deleteChaebunDeptList(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdminDAO.deleteChaebunDeptList", map);
	}
	
	public void insertChaebunDeptList(Map<String, Object> map) throws Exception {
		insert("EzApprovalGAdminDAO.insertChaebunDeptList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> checkChaebunDeptList(Map<String, Object> map) throws Exception{
		return (List<String>) list("EzApprovalGAdminDAO.checkChaebunDeptList", map);
	}
	
	public void removeMyTaskCode(Map<String, Object> map) throws Exception {
		delete("EzApprovalGAdminDAO.removeMyTaskCode", map);
	}
	
	/* 2022-12-09 홍승비 - 전자결재G > 현재 년도 기준의 종료예정 기록물철을 리스트로 리턴하는 쿼리 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCabinetListByExpireYear(Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) list("EzApprovalGAdminDAO.getCabinetListByExpireYear", map);
	}

	public ArrayList<String> getIronListYear(String companyID, int tenantID) throws Exception {
		return (ArrayList<String>)list(
			"EzApprovalGAdminDAO.getIronListYear",
			new HashMap() {{
				put("companyID", companyID);
				put("tenantID", tenantID);
			}}
		);
	}

	/* 2024-07-16 기민혁 - 전자결재 > 양식함 이동 하위 문서함 체크 */
	@SuppressWarnings("unchecked")
	public List<String> checkContList(Map<String, Object> map) {
		return (List<String>) list("EzApprovalGAdminDAO.checkContList", map);
	}
	
	/* 2024-07-16 기민혁 - 전자결재 > 양식함 이동 */
	public void contMove(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.contMove", map);
	}

	/* 2024-07-17 기민혁 - 전자결재 > 양식함 순서조정 리스트 호출  */
	@SuppressWarnings("unchecked")
	public List<ApprGFormVO> getSNFContList(Map<String, Object> map){
		return (List<ApprGFormVO>) list("EzApprovalGAdmin.getSNFContList",map);
	}

	/* 2024-07-17 기민혁 - 전자결재 > 양식함 순서조정 실행 함수  */
	public void setContSN(Map<String, Object> map) throws Exception {
		update("EzApprovalGAdmin.setContSN", map);
	}
}
