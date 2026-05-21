package egovframework.ezEKP.ezApprovalG.dao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezApprovalG.vo.*;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopOtherCompanyAddJobVO;
import egovframework.let.user.login.vo.LoginVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzApprovalGDAO")
public class EzApprovalGDAO extends EgovAbstractDAO {
	
	// 캐비닛 문서 정보 삭제
	public void deleteCabInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.deleteCabInfo", map);
	}
	
	// 캐비닛 문서 정보 삭제 후 로그 추가
	public void insertDelCabInfo(Map<String, Object> map) {
		insert("EzApprovalG.insertDelCabInfo", map);
	}
	
	// 캐비닛 문서 삭제 전 진행중문서 확인
	public String selectExpCabDocInfo(Map<String, Object> map){
		return (String) select("EzApprovalG.selectExpCabDocInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGListHeaderVO> getListHeader(Map<String, Object> map) throws Exception{
		return (List<ApprGListHeaderVO>) list("EzApprovalG.getListHeader", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getUseContInfo1(Map<String, Object> map) throws Exception{
		return (List<ApprGLeftVO>) list("EzApprovalG.getUseContInfo1", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getUseContInfo2(Map<String, Object> map) throws Exception{
		return (List<ApprGLeftVO>) list("EzApprovalG.getUseContInfo2", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getUseContInfo3(Map<String, Object> map) throws Exception{
		return (List<ApprGLeftVO>) list("EzApprovalG.getUseContInfo3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getAprDocList(Map<Object, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getAprDocList", map);
	}
	
	// 김민재 - 구버전 포탈 포틀릿 소스로 현재 사용하지 않아 주석처리
	/*@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getAprPortletDocList(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getAprPortletDocList", map);
	}
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getAprPortletList_progress(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getAprPortletList_progress", map);
	}
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getAprPortletList_reject(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getAprPortletList_reject", map);
	}
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getAprPortletList_draft(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getAprPortletList_draft", map);
	}
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getAprPortletList_progressDtl(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("EzApprovalG.getAprPortletList_progressDtl", map);
	}*/
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> getAprLineInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.getAprLineInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> checkPermission(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.checkPermission", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> getLineInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.getLineInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAttachInfoVO> getAttachInfoDB(Map<String, Object> map) throws Exception{
		return (List<ApprGAttachInfoVO>) list("EzApprovalG.getAttachInfoDB", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiptVO> getReceiptInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiptVO>) list("EzApprovalG.getReceiptInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGOpinionVO> getOpinionInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGOpinionVO>) list("EzApprovalG.getOpinionInfo", map);
	}
	
	/* 2024-04-29 홍승비 - 현재 getWebPartList 메서드는 LEFT와 COUNT 분기만 호출되는 것으로 확인, 관련된 코드 주석처리 */
	/*@SuppressWarnings("unchecked")
	public List<ApprGWebPartVO> getWebPartList(Map<String, Object> map) throws Exception{
		return (List<ApprGWebPartVO>) list("EzApprovalG.getWebPartList", map);
	}*/
	
	@SuppressWarnings("unchecked")
	public List<ApprGFormVO> getFormInfo(Map<String, Object> map) throws Exception{ 
		return (List<ApprGFormVO>) list("EzApprovalG.getFormInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGFormVO> getFormContainerInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGFormVO>) list("EzApprovalG.getFormContainerInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getSecurityType(Map<String, Object> map) throws Exception{
		return (List<ApprGLeftVO>) list("EzApprovalG.getSecurityType", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getAprType(Map<String, Object> map) throws Exception{
		return (List<ApprGLeftVO>) list("EzApprovalG.getAprType", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGLineTempletVO> getTempList(Map<String, Object> map) throws Exception{
		return (List<ApprGLineTempletVO>) list("EzApprovalG.getTempList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAdminReceiveVO> getReceiptGroupInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGAdminReceiveVO>) list("EzApprovalG.getReceiptGroupInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGLineTempletVO> getLineTempletInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGLineTempletVO>) list("EzApprovalG.getLineTempletInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGLineTempletVO> getLineTempletDetailInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGLineTempletVO>) list("EzApprovalG.getLineTempletDetailInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGFormVO> getFormInfoDetail(Map<String, Object> map) throws Exception{
		return (List<ApprGFormVO>) list("EzApprovalG.getFormInfoDetail", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiptVO> getFormRecvAprDB(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiptVO>) list("EzApprovalG.getFormRecvAprDB", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> addToAprLineDB(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.addToAprLineDB", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDeptTempletVO> getReceiptTempletInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDeptTempletVO>) list("EzApprovalG.getReceiptTempletInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAdminReceiveVO> getTempListDB(Map<String, Object> map) throws Exception{
		return (List<ApprGAdminReceiveVO>) list("EzApprovalG.getTempListDB", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDeptTempletVO> getReceiptTempletDetailInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDeptTempletVO>) list("EzApprovalG.getReceiptTempletDetailInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiptVO> addToAprDept(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiptVO>) list("EzApprovalG.addToAprDept", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getTaskCategory(Map<String, Object> map) throws Exception{
		return (List<ApprGTaskVO>) list("EzApprovalG.getTaskCategory", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getTaskMiddleCategory(Map<String, Object> map) throws Exception{
		return (List<ApprGTaskVO>) list("EzApprovalG.getTaskMiddleCategory", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getTaskSubCategory(Map<String, Object> map) throws Exception{
		return (List<ApprGTaskVO>) list("EzApprovalG.getTaskSubCategory", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getTaskSubCategoryAll(Map<String, Object> map) throws Exception {
		return (List<ApprGTaskVO>) list("EzApprovalG.getTaskSubCategoryAll", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getTaskInSubCategory(Map<String, Object> map) throws Exception{
		return (List<ApprGTaskVO>) list("EzApprovalG.getTaskInSubCategory", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGCabinetVO> getSimpleCabinetList(Map<String, Object> map) throws Exception{
		return (List<ApprGCabinetVO>) list("EzapprovalG.getSimpleCabinetList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> findTask(Map<String, Object> map) throws Exception{
		return (List<ApprGTaskVO>) list("EzapprovalG.findTask", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAttachInfoVO> getAttachFileInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGAttachInfoVO>) list("EzApprovalG.getAttachFileInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAttachInfoVO> updateHistoryForAttach_I(Map<String, Object> map) throws Exception{
		return (List<ApprGAttachInfoVO>) list("EzApprovalG.updateHistoryForAttach_I", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGListInfoVO> getListInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGListInfoVO>) list("EzApprovalG.getListInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGListInfoVO> getLVFieldInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGListInfoVO>) list("EzApprovalG.getLVFieldInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRecordVO> getRecordList(ApprGRecordListVO recordListVO) throws Exception{
		return (List<ApprGRecordVO>) list("EzApprovalG.getRecordList", recordListVO);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGCabCodeVO> getCodeInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGCabCodeVO>) list("EzApprovalG.getCodeInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocAttachInfoVO> getAttachDocInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDocAttachInfoVO>) list("EzApprovalG.getAttachDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getDocInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getEA5Value(Map<String, Object> map) throws Exception{
		return (List<OrganUserVO>) list("EzApprovalG.getEA5Value", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getMyTaskCode(Map<String, Object> map) throws Exception{
		return (List<ApprGTaskVO>) list("EzApprovalG.getMyTaskCode", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getCabinetInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGTaskVO>) list("EzApprovalG.getCabinetInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGHistoryDocVO> getHistoryForDoc(Map<String, Object> map) throws Exception{
		return (List<ApprGHistoryDocVO>) list("EzApprovalG.getHistoryForDoc", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGHistoryLineVO> getHistoryForLine(Map<String, Object> map) throws Exception{
		return (List<ApprGHistoryLineVO>) list("EzApprovalG.getHistoryForLine", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGHistoryAttachVO> getHistoryForAttach(Map<String, Object> map) throws Exception{
		return (List<ApprGHistoryAttachVO>) list("EzApprovalG.getHistoryForAttach", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGHistoryLineVO> getHistoryForLineDetail(Map<String, Object> map) throws Exception{
		return (List<ApprGHistoryLineVO>) list("EzApprovalG.getHistoryForLineDetail", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> doApproveLineInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.doApproveLineInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> doApproveLineList(Map<String, Object> map2) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.doApproveLineList", map2);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> setBujaeInfoList(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.setBujaeInfoList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> doDocCompleteDocInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.doDocCompleteDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiptVO> doSendDocReceiptInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiptVO>) list("EzApprovalG.doSendDocReceiptInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGReceiptVO> doSendDocReceiptInfo2(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiptVO>) list("EzApprovalG.doSendDocReceiptInfo2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> doSendDocAprDocInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.doSendDocAprDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> doSendDocAprDocInfo2(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.doSendDocAprDocInfo2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiptVO> doSendDocReceiptGroupSub(Map<String, Object> map2) throws Exception{
		return (List<ApprGReceiptVO>) list("EzApprovalG.doSendDocReceiptGroupSub", map2);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiptVO> updateProcessYNReceipt(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiptVO>) list("EzApprovalG.updateProcessYNReceipt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiptVO> updateProcessYNReceipt2(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiptVO>) list("EzApprovalG.updateProcessYNReceipt2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> doApproveEndDocInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.doApproveEndDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGCabinetRecVO> setCabinetRecList(Map<String, Object> map) throws Exception{
		return (List<ApprGCabinetRecVO>) list("EzApprovalG.setCabinetRecList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGCabinetRecVO> setCabinetRecvList(Map<String, Object> map) throws Exception{
		return (List<ApprGCabinetRecVO>) list("EzApprovalG.setCabinetRecvList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGOpinionVO> setLastOpinionToOrgDoc(Map<String, Object> map) throws Exception{
		return (List<ApprGOpinionVO>) list("EzApprovalG.setLastOpinionToOrgDoc", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGSignInfoVO> updateHabyuiResultSignInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGSignInfoVO>) list("EzApprovalG.updateHabyuiResultSignInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> updateHabyuiResultAprMember(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.updateHabyuiResultAprMember", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAttachInfoVO> getTotalAttachSize(Map<String, Object> map) throws Exception{
		return (List<ApprGAttachInfoVO>) list("EzApprovalG.getTotalAttachSize", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> compareLineHistory1(Map<String, Object> map1) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.compareLineHistory1", map1);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getApproveDocInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getApproveDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGSignInfoVO> getSignInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGSignInfoVO>) list("EzApprovalG.getSignInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGLineTempletVO> getCallBackYNLineList(Map<String, Object> map) throws Exception{
		return (List<ApprGLineTempletVO>) list("EzApprovalG.getCallBackYNLineList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGLineTempletVO> getCallBackYNForceLine(Map<String, Object> map) throws Exception{
		return (List<ApprGLineTempletVO>) list("EzApprovalG.getCallBackYNForceLine", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAttachInfoVO> getTotalDownload(Map<String, Object> map) throws Exception{
		return (List<ApprGAttachInfoVO>) list("EzApprovalG.getTotalDownload", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiveDocVO> getReceiveDocList(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiveDocVO>) list("EzApprovalG.getReceiveDocList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiveDocVO> getOrgDocInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiveDocVO>) list("EzApprovalG.getOrgDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiveDocVO> getReceivedDocInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiveDocVO>) list("EzApprovalG.getReceivedDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getNextDocInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getNextDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGSecondApprVO> getSecondApprovalInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGSecondApprVO>) list("EzApprovalG.getSecondApprovalInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGCabinetVO> getFindSimpleCabinetList(Map<String, Object> map) throws Exception{
		return (List<ApprGCabinetVO>) list("EzApprovalG.getFindSimpleCabinetList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprDocInfoVO> doSusinHesongAprDocInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGAprDocInfoVO>) list("EzApprovalG.doSusinHesongAprDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> getAprLineInfoAprState(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.getAprLineInfoAprState", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> getAprLineInfoAprStateChamJo(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.getAprLineInfoAprStateChamJo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> getInnerLineInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.getInnerLineInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getSearchDocList(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getSearchDocList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAttachInfoVO> aprAttachMail(Map<String, Object> map) throws Exception{
		return (List<ApprGAttachInfoVO>) list("EzApprovalG.aprAttachMail", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getContDocList(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getContDocList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getGamSaSearchDocList(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getGamSaSearchDocList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getSendOutDocList(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getSendOutDocList", map);
	}
	
	/* 2024-05-27 홍승비 - 호출되지 않는 구버전 쿼리 주석처리 */
	/*@SuppressWarnings("unchecked")
	public List<ApprGgetDeptStacticsVO> getDeptStactics(Map<String, Object> map) throws Exception{
		return (List<ApprGgetDeptStacticsVO>) list("EzApprovalG.getDeptStactics", map);
	}*/
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> getDocAprLine(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.getDocAprLine", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGCabCodeVO> getDocType(Map<String, Object> map) throws Exception{
		return (List<ApprGCabCodeVO>) list("EzApprovalG.getDocType", map);
	}
	
	/* 2024-04-15 홍승비 - 호출되지 않는 구버전 쿼리 주석처리 */
	/*@SuppressWarnings("unchecked")
	public List<String> getLeftDocCount(Map<String, Object> map) throws Exception{
		return (List<String>) list("EzApprovalG.getLeftDocCount", map);
	}*/
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> doBanSongAprType(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.doBanSongAprType", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> sendoffercheck_enddocinfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.sendoffercheck_enddocinfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRecordVO> getRecordInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGRecordVO>) list("EzApprovalG.getRecordInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGRecordVO> getRecViewer(Map<String, Object> map) throws Exception{
		return (List<ApprGRecordVO>) list("EzApprovalG.getRecViewer", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGHistoryDocVO> getRecReadHistory(Map<String, Object> map) throws Exception{
		return (List<ApprGHistoryDocVO>) list("EzApprovalG.getRecReadHistory", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGCabinetVO> getRecordClassInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGCabinetVO>) list("EzApprovalG.getRecordClassInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRecordVO> getRecordHistory(Map<String, Object> map) throws Exception{
		return (List<ApprGRecordVO>) list("EzApprovalG.getRecordHistory", map);
	}
	@SuppressWarnings("unchecked")
	public List<ApprGRecordVO> getRecordSimpleInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGRecordVO>) list("EzApprovalG.getRecordSimpleInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGCabinetVO> getRecScInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGCabinetVO>) list("EzApprovalG.getRecScInfo", map);
	}
	@SuppressWarnings("unchecked")
	public List<ApprGDeliveryListVO> getDeliveryList(Map<String, Object> map) throws Exception{
		return (List<ApprGDeliveryListVO>) list("EzApprovalG.getDeliveryList", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGCabinetVO> getCabinetList(ApprGCabinetListVO cabinetListVO) throws Exception{
		return (List<ApprGCabinetVO>) list("EzApprovalG.getCabinetList", cabinetListVO);
	}
	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getCabinetDetailInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGTaskVO>) list("EzApprovalG.getCabinetDetailInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getCabScInfo(Map<String, Object> map)throws Exception{
		return (List<ApprGTaskVO>) list("EzApprovalG.getCabScInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getCabinetSimpleInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGTaskVO>) list("EzApprovalG.getCabinetSimpleInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getCabinetSimpleInfo2(Map<String, Object> map) throws Exception{
		return (List<ApprGTaskVO>) list("EzApprovalG.getCabinetSimpleInfo2", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGCabinetVO> getCabinetHistory(Map<String, Object> map) throws Exception{
		return (List<ApprGCabinetVO>) list("EzApprovalG.getCabinetHistory", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGRecordVO> getTaskCharger(Map<String, Object> map) throws Exception{
		return (List<ApprGRecordVO>) list("EzApprovalG.getTaskCharger", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> doSendOffer_endDocInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.doSendOffer_endDocInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> doSendOffer_expendDocInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.doSendOffer_expendDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiptVO> doSendOffer_receiptId(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiptVO>) list("EzApprovalG.doSendOffer_receiptId", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocInfoWebSrvVO> getDocInfoSP(Map<String, Object> map) throws Exception{
		return (List<ApprGDocInfoWebSrvVO>) list("EzApprovalG.getDocInfoSP", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> countRecTempDocID3(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.countRecTempDocID3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGCabinetVO> selectExistUnit(Map<String, Object> map) throws Exception{
		return (List<ApprGCabinetVO>) list("EzApprovalG.selectExistUnit", map);
	}
	
	public ApprGLineTempletVO gongRamActivateLineInfo(Map<String, Object> map) throws Exception{
		return (ApprGLineTempletVO) select("EzApprovalG.gongRamActivateLineInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRecordVO> selectUserName(Map<String, Object> map) throws Exception{
		return (List<ApprGRecordVO>) list("EzApprovalG.selectUserName", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGReceiptVO> doResendEndDoc1(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiptVO>) list("EzApprovalG.doResendEndDoc1", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGReceiptVO> doResendEndDoc3(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiptVO>) list("EzApprovalG.doResendEndDoc3", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGRecordVO> doSendDoc_ReceiptGroupSub(Map<String, Object> map) throws Exception{
		return (List<ApprGRecordVO>) list("EzApprovalG.doSendDoc_ReceiptGroupSub", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGCabinetVO> selectCabinetTransfer(Map<String, Object> map) throws Exception{
		return (List<ApprGCabinetVO>) list("EzApprovalG.selectCabinetTransfer", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGCabinetVO> selectTbSeperateAttach(Map<String, Object> map) throws Exception{
		return (List<ApprGCabinetVO>) list("EzApprovalG.selectTbSeperateAttach", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getKeepType(Map<String, Object> map) throws Exception{
		return (List<ApprGLeftVO>) list("EzApprovalG.getKeepType", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGTaskVO> getCodeContainer(Map<String, Object> map) throws Exception{
		return (List<ApprGTaskVO>) list("EzApprovalG.getCodeContainer", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprUserContInfoVO> getUserContTree(Map<String, Object> map) throws Exception{
		return (List<ApprUserContInfoVO>) list("EzApprovalG.getUserContTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> docAttachLineInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGAprLineVO>) list("EzApprovalG.docAttachLineInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprUserContInfoVO> getUserContTreeLeaf(Map<String, Object> map) throws Exception{
		return (List<ApprUserContInfoVO>) list("EzApprovalG.getUserContTreeLeaf", map);
	}
			
	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getContainerInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGLeftVO>) list("EzApprovalG.getContainerInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getUserContList(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("EzApprovalG.getUserContList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getUserContListAll(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("EzApprovalG.getUserContListAll", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGContInfoVO> getSpecialContTree(LoginVO userInfo) throws Exception {
		return (List<ApprGContInfoVO>) list("EzApprovalG.getSpecialContTree", userInfo);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> doBanSongAprTypeS(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("EzApprovalG.doBanSongAprTypeS", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> doHabyuiHesongType(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("EzApprovalG.doHabyuiHesongType", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> doHabyuiHesongTypeS(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("EzApprovalG.doHabyuiHesongTypeS", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprDocInfoVO> doSusinHesongAprDocInfoS(Map<String, Object> map) throws Exception {
		return (List<ApprGAprDocInfoVO>) list("EzApprovalG.doSusinHesongAprDocInfoS", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getDocInfoS(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("EzApprovalG.getDocInfoS", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> relayAprLineXmlForExt(Map<String, Object> map) throws Exception {
		return (List<ApprGAprLineVO>) list("EzApprovalG.relayAprLineXmlForExt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRelayVO> recRelayInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGRelayVO>) list("EzApprovalG.recRelayInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRelayVO> recRelayExchInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGRelayVO>) list("EzApprovalG.recRelayExchInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRelayVO> recRelayAttachInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGRelayVO>) list("EzApprovalG.recRelayAttachInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRelayVO> recRelaySignInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGRelayVO>) list("EzApprovalG.recRelaySignInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRelayVO> relayGetByXDocIDInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGRelayVO>) list("EzApprovalG.relayGetByXDocIDInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRelayVO> relayGetAttachInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGRelayVO>) list("EzApprovalG.relayGetAttachInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRelayVO> getRelayInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGRelayVO>) list("EzApprovalG.getRelayInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRelayVO> getRelaySignInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGRelayVO>) list("EzApprovalG.getRelaySignInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRelayVO> getSendAckDocInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGRelayVO>) list("EzApprovalG.getSendAckDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getTenantID() throws Exception {
		return (List<OrganUserVO>) list("EzApprovalG.getTenantID");
	}
	
	public ApprGDocListVO doSendOfferRejectAprDoc(Map<String, Object> map) throws Exception{
		return (ApprGDocListVO) select("EzApprovalG.doSendOfferRejectAprDoc", map);
	}
	
	public ApprGReceiveDocVO doSendOfferRejectReceipt(Map<String, Object> map) throws Exception{
		return (ApprGReceiveDocVO) select("EzApprovalG.doSendOfferRejectReceipt", map);
	}
	
	public ApprGDocListVO setCabinetReject1(Map<String, Object> map) throws Exception{
		return (ApprGDocListVO) select("EzApprovalG.setCabinetReject1", map);
	}
	
	public ApprGDocListVO setCabinetReject2(Map<String, Object> map) throws Exception{
		return (ApprGDocListVO) select("EzApprovalG.setCabinetReject2", map);
	}
	
	public String getCode2Name(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getCode2Name", map);
	}

	public String getName2Code(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getName2Code", map);
	}

	public String getIsUse(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getIsUse", map);
	}

	public String getAprDocListReceiveSN(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getAprDocListReceiveSN", map);
	}
	
	public String getAccessYNG(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getAccessYNG", map);
	}
	
	public String getApprovalPWD(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getApprovalPWD", map);
	}
	
	public String getCabinetCode2Name(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getCabinetCode2Name", map);
	}
	
	public String getDocHrefYear(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getDocHrefYear", map);
	}
	
	public String getSepAttachSN(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getSepAttachSN", map);
	}
	
	public String getDocTitle(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getDocTitle", map);
	}
	
	public String getDraftUserID(Map<String, Object> map2) throws Exception{
		return (String) select("EzApprovalG.getDraftUserID", map2);
	}
	
	public String getDocInfoHref(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getDocInfoHref", map);
	}
	
	public String getSusinSNInside(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getSusinSNInside", map);
	}
	
	public String returnContainerID(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.returnContainerID", map);
	}
	
	public String returnContainerID2(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.returnContainerID2", map);
	}
	
	public String returnContainerID3(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.returnContainerID3", map);
	}
	
	public String makeContainer(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.makeContainer", map);
	}
	
	public String getRecordSCFlag(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getRecordSCFlag", map);
	}
	
	public String getDraftDate(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getDraftDate", map);
	}
	
	public String updateSusinResultReceipt(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.updateSusinResultReceipt", map);
	}
	
	public String setCabinetRecvAprMemdtID(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.setCabinetRecvAprMemdtID", map);
	}
	
	public String updateHabyuiResultAprMemberNM(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.updateHabyuiResultAprMemberNM", map);
	}
	
	public String updateHabyuiResultAprMemberJobTitle(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.updateHabyuiResultAprMemberJobTitle", map);
	}
	
	public String chkDocDelete(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.chkDocDelete", map);
	}
	
	public String getApprovalPWD1(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getApprovalPWD1", map);
	}
	
	public String getLastOpinionContent(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getLastOpinionContent", map);
	}
	
	public String gongRamDocInfo(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.gongRamDocInfo", map);
	}
	
	public String getDocRecvState(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getDocRecvState", map);
	}
	
	public String getNewVolumeNo(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getNewVolumeNo", map);
	}
	
	public String doSusinHesongSentDeptID(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.doSusinHesongSentDeptID", map);
	}
	
	public String getSearchList(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getSearchList", map);
	}
	
	public String getFormConnFlag(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getFormConnFlag", map);
	}
	
	public String getDocInfoDState(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getDocInfoDState", map);
	}
	
	public String getApprovalPWD2(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getApprovalPWD2", map);
	}
	
	public String getSusinSN(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getSusinSN", map);
	}
	
	public String setUserFormInfoYN(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.setUserFormInfoYN", map);
	}
	
	public String selectAprGetNewID(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.selectAprGetNewID", map);
	}
	
	public String aprDeleteDocInfoFlag(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.aprDeleteDocInfoFlag", map);
	}
	
	public String chkDocDeleteTemp(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.chkDocDeleteTemp", map);
	}
	
	public String selectHrefDocInfo(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.selectHrefDocInfo", map);
	}
	
	public String selectTbSpecialCatalogInfo(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.selectTbSpecialCatalogInfo", map);
	}
	
	public String getUserRecRight(Map<String, Object> map) throws Exception{
		return (String)select("EzApprovalG.getUserRecRight", map);
	}
	
	public String getUserRecRightCount(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getUserRecRightCount", map);
	}
	
	public String getUserRecRightCount2(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getUserRecRightCount2", map);
	}
	
	public String selectCodeValue(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.selectCodeValue", map);
	}
	
	public String selectGongRamDocID(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.selectGongRamDocID", map);
	}
	
	public String getCabCodeList(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getCabCodeList", map);
	}
	
	public String getStartDateTime(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getStartDateTime", map);
	}
	
	public String getEndDateTime(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getEndDateTime", map);
	}
	
	public String maxTmpDocSn(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.maxTmpDocSn", map);
	}
	
	public String selectUserSecurityCode(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.selectUserSecurityCode", map);
	}

	public String getSendFlag(Map<String, Object> map)throws Exception {
		return (String) select("EzApprovalG.getSendFlag", map);
	}
	
	public String setCabinetRecvAprMemberDeptId(Map<String, Object> map)throws Exception {
		return (String) select("EzApprovalG.setCabinetRecvAprMemberDeptId", map);
	}
	
	public String checkResend(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.checkResend", map);
	}
	
	public String getReceiptProcessInfoRecS(Map<String, Object> map3) throws Exception {
		return (String) select("EzApprovalG.getReceiptProcessInfoRecS", map3);
	}
	
	public String lastKyulJeHabYuiYN(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.lastKyulJeHabYuiYN", map);
	}
	
	public String lastHabYuiSN(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.lastHabYuiSN", map);
	}
	
	public String getDeptSymbol(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getDeptSymbol", map);
	}
	
	public int checkReceivedDoc(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.checkReceivedDoc", map);
	}
	
	public int selectDoCallBack(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.selectDoCallBack", map);
	}
	
	public int getAprDocListCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getAprDocListCount", map);
	}
	
	public int getWebPartListCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getWebPartListCount", map);
	}

	public int getCountChildFormCont(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getCountChildFormCont", map);
	}
	
	public int getLineTempletSN(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getLineTempletSN", map);
	}
	
	public int getReceiptTempletSN(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getReceiptTempletSN", map);
	}
	
	public int getRecordListCount(Map<String, Object> map) throws Exception {
		return (int)select("EzApprovalG.getRecordListCount", map);
	}
	
	public int updateHistoryForAttach_M(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.updateHistoryForAttach_M", map);
	}
	
	public int isCabCharger(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.isCabCharger", map);
	}
	
	public int receiverChk(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.receiverChk", map);
	}
	
	public int doProcessCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.doProcessCount", map);
	}
	
	public int doApproveLineCnt(Map<String, Object> map1) throws Exception{
		return (int)select("EzApprovalG.doApproveLineCnt", map1);
	}
	
	public int updateSignInfoAprSN(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.updateSignInfoAprSN", map);
	}
	
	public int getReceiptProcessInfoRec(Map<String, Object> map3) throws Exception{
		return (int)select("EzApprovalG.getReceiptProcessInfoRec", map3);
	}
	
	public int doDocCompleteReceiptCnt(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.doDocCompleteReceiptCnt", map);
	}
	
	public int setLastOpinionToOrgDocOpinionSN(Map<String, Object> map1) throws Exception{
		return (int)select("EzApprovalG.setLastOpinionToOrgDocOpinionSN", map1);
	}
	
	public int getWhoKyulCount(Map<String, Object> map) throws Exception {
		return (int)select("EzApprovalG.getWhoKyulCount", map);
	}
	
	public String spGetSerialNo(Map<String, Object> map) throws Exception{
		return (String)select("EzApprovalG.spGetSerialNo", map);
	}
	
	public String notifiCationSeq(Map<String, Object> map) throws Exception{
		return (String)select("EzApprovalG.notifiCationSeq", map);
	}
	
	public String transferCabinetSn(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.transferCabinetSn", map);
	}
	
	public int getMaxTmpDocSN(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getMaxTmpDocSN", map);
	}
	
	public int getReceiveDocListCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getReceiveDocListCount", map);
	}
	
	public int compareLineHistory(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.compareLineHistory", map);
	}
	
	public int updateDeliveryListCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.updateDeliveryListCount", map);
	}
	
	public int updateDeliveryListSNMax(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.updateDeliveryListSNMax", map);
	}
	
	public int getSearchDocListCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getSearchDocListCount", map);
	}
	
	public int getContDocListCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getContDocListCount", map);
	}
	
	public int getGamSaSearchDocListCount(Map<String, Object> map) throws Exception{
		select("EzApprovalG.getGamSaSearchDocListCount", map);
		return (int)map.get("v_pCount");
	}
	
	public int getUncompleteDocCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getUncompleteDocCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getUncompleteDocList(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getUncompleteDocList", map);
	}
	
	public int gongRamActivateCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.gongRamActivateCount", map);
	}
	
	public int getUncabinetedDocCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getUncabinetedDocCount", map);
	}
	
	public int chkIfNotArrangedCabExist(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.chkIfNotArrangedCabExist", map);
	}
	
	public int getSendOutDocListCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getSendOutDocListCount", map);
	}
	
	/*public int getAprPortletDocCount(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.getAprPortletDocCount", map);
	}*/
	
	public int getDeliveryListCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getDeliveryListCount", map);
	}

	public int getCabinetListCount(ApprGCabinetListVO cabinetListVO) throws Exception{
		return (int)select("EzApprovalG.getCabinetListCount", cabinetListVO);
	}

	public int getReceiptInfo_receivesNm(Map<String, Object> map)throws Exception{
		return (int)select("EzApprovalG.getReceiptInfo_receivesNm", map);
	}
	
	public int getUserRight(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getUserRight", map);
	}

	public int sendOfferCheck_EndReceipt(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.sendOfferCheck_EndReceipt", map);
	}
	
	public List<String> sendOfferCheck_EndReceipt2(Map<String, Object> map) throws Exception{
	    return (List<String>) list("EzApprovalG.sendOfferCheck_EndReceipt2", map);
	}
	
	public int checkAprLine(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.checkAprLine", map);
	}
	
	public int getDocAprCnt(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.getDocAprCnt", map);
	}
	
	public int getDocInfoRef(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.getDocInfoRef", map);
	}
	
	public int getDocInfoHab(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.getDocInfoHab", map);
	}
	
	public int getDocInfoJeonKyul(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.getDocInfoJeonKyul", map);
	}
	
	public int countVieTempDocID(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.countVieTempDocID", map);
	}
	
	public int countVieTempDocID2(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.countVieTempDocID2", map);
	}
	
	public int countRecTempDocID(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.countRecTempDocID", map);
	}
	
	public int countRecTempDocID2(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.countRecTempDocID2", map);
	}
	
	public int rollBackFlag(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.rollBackFlag", map);
	}
	
	public int countAttachFile(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.countAttachFile", map);
	}
	
	public int countAttachDocInfo(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.countAttachDocInfo", map);
	}
	
	public int getTotalAttachSizeTemp(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.getTotalAttachSizeTemp", map);
	}
	
	public int newRecordVersion(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.newRecordVersion", map);
	}
	
	public int transferCabinet(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.transferCabinet", map);
	}
	
	public int transferCabinetType2(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.transferCabinetType2", map);
	}
	
	public int selectCabID(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.selectCabID", map);
	}
	
	public int selectCabID2(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.selectCabID2", map);
	}
	
	public int selectHistoryCnt(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.selectHistoryCnt", map);
	}
	
	public int cabinetHistory(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.cabinetHistory", map);
	}
	
	public int changeCabBsicInfoCount(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.changeCabBsicInfoCount", map);
	}
	
	public int changeCabSpeacialCount(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.changeCabSpeacialCount", map);
	}
	
	public int getWhoKyulMaxReceivSN(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getWhoKyulMaxReceivSN", map);
	}
	
	public int getWhoKyulSingInfoCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getWhoKyulSingInfoCnt", map);
	}
	
	public int signCheckCount(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.signCheckCount", map);
	}
	
	public int historyDocInfoCount(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.historyDocInfoCount", map);
	}
	
	public int delUserConutCnt(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.delUserConutCnt", map);
	}
	
	public int userContListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.userContListCount", map);
	}
	
	public int getUserContDocListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getUserContDocListCount", map);
	}
	
	public int gongRamActivateCount2(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.gongRamActivateCount2", map);
	}
	
	public int lastKyulJeCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.lastKyulJeCnt", map);
	}
	
	public int lastKyulJeHabYuiSN(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.lastKyulJeHabYuiSN", map);
	}
	
	public int getUserContSubCount(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getUserContSubCount", map);
	}
	
	public String getUserContMaxID(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getUserContMaxID", map);
	}
	
	public void transactionSQL(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.transactionSQL", map);
	}
	
	public void insertNotifyItem(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertNotifyItem", map);
	}
	
	public void spRollbackSN(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.spRollbackSN", map);
	}
	
	public void addNewVolume(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.addNewVolume", map);
	}
	
	public void confirmClassify(Map<String, Object> map) throws Exception{
		update("EzApprovalG.confirmClassify", map);
	}
	
	public void doSendOfferApprove1(Map<String, Object> map) throws Exception{
		update("EzApprovalG.doSendOfferApprove1", map);
	}
	
	public void doSendOfferApprove2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.doSendOfferApprove2", map);
	}
	
	public void insertRoleInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRoleInfo", map);
	}

	public void insertMultiRoleInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertMultiRoleInfo", map);
	}

	public void updateReceiptOffer(Map<String, Object> map)throws Exception{
		insert("EzApprovalG.updateReceiptOffer", map);
	}
	
	public void aprMakeTmp2Ing(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.aprMakeTmp2Ing", map);
	}
	
	public void aprMakeTmp2Ing2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.aprMakeTmp2Ing2", map);
	}
	
	public void aprMakeTmp2Ing3(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.aprMakeTmp2Ing3", map);
	}
	
	public void aprMakeTmp2Ing4(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.aprMakeTmp2Ing4", map);
	}
	
	public void aprMakeTmp2Ing5(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.aprMakeTmp2Ing5", map);
	}
	
	public void aprMakeTmp2Ing6(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.aprMakeTmp2Ing6", map);
	}
	
	public void aprMakeTmp2Ing7(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.aprMakeTmp2Ing7", map);
	}
	
	public void aprMakeTmp2Ing8(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.aprMakeTmp2Ing8", map);
	}
	
	public void aprMakeTmp2Ing9(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.aprMakeTmp2Ing9", map);
	}
	
	public void aprMakeTmp2Ing10(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.aprMakeTmp2Ing10", map);
	}
	
	public void aprMakeTmp2Ing11(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.aprMakeTmp2Ing11", map);
	}
	
	public void aprMakeTmp2Ing12(Map<String, Object> map) throws Exception{
		update("EzApprovalG.aprMakeTmp2Ing12", map);
	}
	
	public int checkTmpDocHasGongRam(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.checkTmpDocHasGongRam", map);
	}
	
	public String getTmpDocID(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getTmpDocID", map);
	}
	
	public void setUserFormInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.setUserFormInfo", map);
	}
	
	public void createNewDoc(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.createNewDoc", map);
	}
	
	public void createNewDoc2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.createNewDoc2", map);
	}
	
	public void insertSerialNo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertSerialNo", map);
	}

	public void moveRecord(Map<String, Object> map) throws Exception{
		update("EzApprovalG.moveRecord", map);
	}

	public void changeRecordInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.changeRecordInfo", map);
	}

	public void delUserFormInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.delUserFormInfo", map);
	}

	public void updateHistoryForAttach(Map<String, Object> map1) throws Exception{
		insert("EzApprovalG.updateHistoryForAttach", map1);
	}
	
	public void saveRecReadHist(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.saveRecReadHist", map);
	}
	
	public void insertRecordHistory(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRecordHistory", map);
	}
	
	public void insertRecordHistory2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRecordHistory2", map);
	}
	
	public void insertTbSerialNumGen(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbSerialNumGen", map);
	}
	
	public void insertTbCabinetClass(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbCabinetClass", map);
	}
	
	public void insertTbSpecialCatalogInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbSpecialCatalogInfo", map);
	}
	
	public void insertTbSpecialCatalogInfo2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbSpecialCatalogInfo2", map);
	}
	
	public void insertTbOldCabinetExtraInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbOldCabinetExtraInfo", map);
	}
	
	public void insertTbCabinetInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbCabinetInfo", map);
	}
	
	public void insertTbAprAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbAprAttachInfo", map);
	}
	
	public void insertTbAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbAprDocAttachInfo", map);
	}
	
	public void insertTbAprLineInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbAprLineInfo", map);
	}
	
	public void insertTbExpAprLine(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbExpAprLine", map);
	}
	
	public void insertReceiptInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertReceiptInfo", map);
	}
	
	public void trigerTbCabinet(Map<String, Object> map1) throws Exception{
		insert("EzApprovalG.trigerTbCabinet", map1);
	}
	
	public void trigerTbCabRoleInfo(Map<String, Object> map1) throws Exception{
		insert("EzApprovalG.trigerTbCabRoleInfo", map1);
	}
	
	public void insertTbCabinetHistory(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbCabinetHistory", map);
	}
	
	public void insertSignInfoAprSN(Map<String, Object> map1)throws Exception{
		insert("EzApprovalG.insertSignInfoAprSN", map1);
	}
	
	public void insertTbSpecialCatalogInfo_Cab(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbSpecialCatalogInfo_Cab", map);
	}
	
	public void insertTbSpecialCatalogInfo_Cab2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbSpecialCatalogInfo_Cab2", map);
	}
	
	public void insertTbContainer(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbContainer", map);
	}
	
	public void jiJungInsertReceiptProInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.jiJungInsertReceiptProInfo", map);
	}

	public void insertHistory(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertHistory", map);
	}
	
	public void insertHistory2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertHistory2", map);
	}
	
	public void insertTbSpecialCatalogInfoRec(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbSpecialCatalogInfoRec", map);
	}
	
	public void insertTbCabRoleInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbCabRoleInfo", map);
	}
	
	public void insertStrSql1(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertStrSql1", map);
	}
	
	public void insertCabinetHistory(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertCabinetHistory", map);
	}
	
	public void insertCabinetHistory2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertCabinetHistory2", map);
	}
	
	public void insertCabinetHistory_CAB(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertCabinetHistory_CAB", map);
	}
	
	public void setMyTaskCode(Map<String, Object> map) throws Exception{
		update("EzApprovalG.setMytaskCode", map);
	}
	
	public void updateDocInfoDocTitle(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateDocInfoDocTitle", map);
	}
	
	public void updateDocInfoAprstate(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateDocInfoAprstate", map);
	}	
	
	public void updateHistoryForLine(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.updateHistoryForLine", map);
	}
	public void updateHistoryForLine2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.updateHistoryForLine2", map);
	}
	
	public void insertFormRecvTB(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertFormRecvTB", map);
	}
	
	public void insertApprLine(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertApprLine", map);
	}
	
	public void insertExApprLine(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertExApprLine", map);
	}
	
	public void insertOptionInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertOptionInfo", map);
	}
	
	public void insertAprAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertAprAttachInfo", map);
	}
	
	public void insertLastDeptLine(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertLastDeptLine", map);
	}
	
	public void insertLastAprLine(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertLastAprLine", map);
	}
	
	public void insertCamjoAPrDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertCamjoAPrDocInfo", map);
	}
	
	public void insertCamjoExAPrDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertCamjoExAPrDocInfo", map);
	}
	
	public void insertCamjoAprAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertCamjoAprAttachInfo", map);
	}
	
	public void insertCamjoAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertCamjoAprDocAttachInfo", map);
	}
	
	public void insertCamjoAprOpinionInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertCamjoAprOpinionInfo", map);
	}
	
	public void insertCamjoAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertCamjoAprReceiptProcessInfo", map);
	}
	
	public void insertCamjoAprLineInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertCamjoAprLineInfo", map);
	}
	
	public void insertCamjoExAprLine(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertCamjoExAprLine", map);
	}
	
	public void insertSignInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertSignInfo", map);
	}
	
	public void insertDeptAssistAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDeptAssistAprDocInfo", map);
	}
	
	public void insertDeptAssistExAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDeptAssistExAprDocInfo", map);
	}
	
	public void insertDeptAssistAprAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDeptAssistAprAttachInfo", map);
	}
	
	public void insertDeptAssistAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDeptAssistAprDocAttachInfo", map);
	}
	
	public void insertDeptAssistAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDeptAssistAprReceiptProcessInfo", map);
	}
	
	public void insertRecord(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRecord", map);
	}
	
	public void insertRegSeperateAttach(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRegSeperateAttach", map);
	}
	
	public void insertRegAudioVisualExInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRegAudioVisualExInfo", map);
	}
	
	public void insertSpecialCatalogInfo_Rec(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertSpecialCatalogInfo_Rec", map);
	}
	
	public void insertSpecialCatalogInfo_Rec2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertSpecialCatalogInfo_Rec2", map);
	}
	
	public void insertTmpReceiptPointInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTmpReceiptPointInfo", map);
	}
	
	public void insertTmpAprOpinionInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTmpAprOpinionInfo", map);
	}
	
	public void insertTmpAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTmpAprDocAttachInfo", map);
	}
	
	public void insertTmpAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTmpAttachInfo", map);
	}
	
	public void insertTmpExpAprLine(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTmpExpAprLine", map);
	}
	
	public void insertTmpAprLineInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTmpAprLineInfo", map);
	}
	
	public void insertTmpExpAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTmpExpAprDocInfo", map);
	}
	
	public void insertTmpAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTmpAprDocInfo", map);
	}
	
	public void insertRejectEndAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRejectEndAprDocInfo", map);
	}
		
	public void insertRejectEndAprLineInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRejectEndAprLineInfo", map);
	}
	
	public void insertRejectEndAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRejectEndAttachInfo", map);
	}
	
	public void insertRejectEndDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRejectEndDocAttachInfo", map);
	}
	
	public void insertRejectEndAprOpinionInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRejectEndAprOpinionInfo", map);
	}
	
	public void insertRejectEndReceiptPointInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRejectEndReceiptPointInfo", map);
	}

	public void insertRejectEndAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRejectEndAprReceiptProcessInfo", map);
	}

	public void insertRejectExpendAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRejectExpendAprDocInfo", map);	
	}

	public void insertRejectExpendAprLine(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRejectExpendAprLine", map);
	}
	
	/* 2024-05-28 홍승비 - 호출되지 않는 구버전 쿼리 주석처리 */
	/*public void insertReciptInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertReciptInfo", map);
	}*/
	
	public void insertLinTemplet(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertLinTemplet", map);
	}
	
	public void insertLinTempletDetail(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertLinTempletDetail", map);
	}
	
	public void insertDeptTemplet(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDeptTemplet", map);
	}
	
	public void insertDeptTempletDetail(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDeptTempletDetail", map);
	}
	
	public void insertReSendEndReceiptPointInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertReSendEndReceiptPointInfo", map);
	}
	
	public void insertReSendAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertReSendAprDocInfo", map);
	}
	
	public void insertReSendExpAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertReSendExpAprDocInfo", map);
	}
	
	public void insertReSendAprAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertReSendAprAttachInfo", map);
	}
	
	public void insertReSendAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertReSendAprDocAttachInfo", map);
	}
	
	public void insertReSendAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertReSendAprReceiptProcessInfo", map);
	}
	
	public void insertProHistoryReceiptInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertProHistoryReceiptInfo", map);
	}
	
	public void insertProHistoryReceiptInfo2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertProHistoryReceiptInfo2", map);
	}
	
	public void insertHesongAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertHesongAprReceiptProcessInfo", map);
	}
	
	public void insertHesongAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertHesongAprDocInfo", map);
	}
	
	public void insertHesongExpAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertHesongAprDocInfo", map);
	}
	
	public void insertHesongAprAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertHesongAprAttachInfo", map);
	}

	public void insertHesongAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertHesongAprDocAttachInfo", map);
	}

	public void insertHesongAprOpinionInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertHesongAprOpinionInfo", map);
	}

	public void insertHesongAprReceiptProcessInfo2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertHesongAprReceiptProcessInfo2", map);
	}
	
	public void insertRejectAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRejectAprReceiptProcessInfo", map);
	}
	
	public void insertGamsaAprOpinionInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGamsaAprOpinionInfo", map);
	}
	
	public void insertGongRamAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamAprDocInfo", map);
	}
	
	public void insertGongRamExpAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamExpAprDocInfo", map);
	}
	
	public void insertGongRamAprOpinionInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamAprOpinionInfo", map);
	}

	public void insertGongRamAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamAprDocAttachInfo", map);
	}

	public void insertGongRamAprAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamAprAttachInfo", map);
	}
	
	public void insertGongRamAprLineInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamAprLineInfo", map);
	}
	
	public void insertGongRamExpAprLine(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamExpAprLine", map);
	}
	
	public void insertGianAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGianAprDocAttachInfo", map);
	}
	
	public void insertRegRecord(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRegRecord", map);
	}
	
	public void insertRegEndAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRegEndAttachInfo", map);
	}
	
	public void insertBebuAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertBebuAprDocInfo", map);
	}
	
	public void insertBebuExpAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertBebuExpAprDocInfo", map);
	}

	public void insertBebuAprAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertBebuAprAttachInfo", map);
	}

	public void insertBebuAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertBebuAprDocAttachInfo", map);
	}

	public void insertBebuAprOpinionInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertBebuAprOpinionInfo", map);
	}

	public void insertBebuAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertBebuAprReceiptProcessInfo", map);
	}
	
	public void insertBebuDocDelivery(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertBebuDocDelivery", map);
	}
	
	public void insertDosendAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDosendAprReceiptProcessInfo", map);
	}
	
	public void insertDoSendAprAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDoSendAprAttachInfo", map);
	}

	public void insertDosendAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDosendAprDocAttachInfo", map);
	}
	
	public void insertChangeCabCabinetHistory(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertChangeCabCabinetHistory", map);
	}
	
	public void insertChangeCabScHistory_Cab(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertChangeCabScHistory_Cab", map);
	}

	public void insertChangeCabCabinetHistory2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertChangeCabCabinetHistory2", map);
	}
	
	public void insertChangeCabSpecialCatalogInfo_Cab(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertChangeCabSpecialCatalogInfo_Cab", map);
	}
	
	public void insertChangeCabExtCabinetHistory(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertChangeCabExtCabinetHistory", map);
	}
	
	public void insertRegCabinetCalss(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRegCabinetCalss", map);
	}
	
	public void insertSetBebuAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertSetBebuAprReceiptProcessInfo", map);
	}
	
	public void insertRecRoleInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRecRoleInfo", map);
	}
	
	public void insertRecRoleInfo2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertRecRoleInfo2", map);
	}
	
	public void insertApprovEndAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertApprovEndAprDocInfo", map);
	}
	
	public void insertApprovEndAprLineInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertApprovEndAprLineInfo", map);
	}
	
	public void insertApprovEndAttachInfo(Map<String, Object> map)  throws Exception{
		insert("EzApprovalG.insertApprovEndAttachInfo", map);
	}

	public void insertApprovEndAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertApprovEndAprDocAttachInfo", map);
	}

	public void insertApprovEndAprOpinionInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertApprovEndAprOpinionInfo", map);
	}

	public void insertApprovEndReceiptPointInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertApprovEndReceiptPointInfo", map);
	}
	
	public void insertApprovEndReceiptProcessInfo(Map<String, Object> map)  throws Exception{
		insert("EzApprovalG.insertApprovEndReceiptProcessInfo", map);
	}

	public void insertApprovExpEndAprDocInfo(Map<String, Object> map)  throws Exception{
		insert("EzApprovalG.insertApprovExpEndAprDocInfo", map);
	}

	public void insertApprovExpEndAprLine(Map<String, Object> map)  throws Exception{
		insert("EzApprovalG.insertApprovExpEndAprLine", map);
	}
	
	public void insertDoSendAprDocInfo(Map<String, Object> map)  throws Exception{
		insert("EzApprovalG.insertDoSendAprDocInfo", map);
	}

	public void insertDoSendAprDocInfo2(Map<String, Object> map)  throws Exception{
		insert("EzApprovalG.insertDoSendAprDocInfo2", map);
	}
	
	public void insertDoSendExpAprDocInfo(Map<String, Object> map)  throws Exception{
		insert("EzApprovalG.insertDoSendExpAprDocInfo", map);
	}

	public void insertDoSendExpAprDocInfo2(Map<String, Object> map)  throws Exception{
		insert("EzApprovalG.insertDoSendExpAprDocInfo2", map);
	}
	
	public void insertDocSendAprAttachInfo(Map<String, Object> map)  throws Exception{
		insert("EzApprovalG.insertDocSendAprAttachInfo", map);
	}
	
	public void insertDocSendAprAttachInfo2(Map<String, Object> map)  throws Exception{
		insert("EzApprovalG.insertDocSendAprAttachInfo2", map);
	}
	
	public void insertDocSendAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDocSendAprDocAttachInfo", map);
	}

	public void insertDocSendAprDocAttachInfo2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDocSendAprDocAttachInfo2", map);
	}

	public void insertDocSendAprOpenGovDocInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertDocSendAprOpenGovDocInfo", map);
	}

	public void insertDocSendAprOpenGovFileInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertDocSendAprOpenGovFileInfo", map);
	}

	public void insertDocSendAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDocSendAprReceiptProcessInfo", map);
	}
	
	public void insertDocSendAprReceiptProcessInfo2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDocSendAprReceiptProcessInfo2", map);
	}
	
	public void insertGongRamSaveAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamSaveAprDocInfo", map);
	}

	public void insertGongRamSaveExpAprDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamSaveExpAprDocInfo", map);
	}

	public void insertGongRamSaveAprOpinionInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamSaveAprOpinionInfo", map);
	}
	
	public void insertGongRamSaveAprDocAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamSaveAprDocAttachInfo", map);
	}

	public void insertGongRamSaveAprAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamSaveAprAttachInfo", map);
	}
	
	public void insertGongRamSaveAprLineInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamSaveAprLineInfo", map);
	}

	public void insertGongRamSaveExpAprLine(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertGongRamSaveExpAprLine", map);
	}
	
	public void insertHesongAprReceiptProcessInfo3(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertHesongAprReceiptProcessInfo3", map);
	}
	
	public void insertHistoryDocInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertHistoryDocInfo", map);
	}
	
	public void insertUserCont(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertUserCont", map);
	}
	
	public void inserUserContList(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.inserUserContList", map);
	}

	public void insertRejectEndAprDocInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRejectEndAprDocInfoS", map);
	}

	public void insertRejectEndAprLineInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRejectEndAprLineInfoS", map);
	}

	public void insertRejectEndAttachInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRejectEndAttachInfoS", map);
	}

	public void insertRejectEndDocAttachInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRejectEndDocAttachInfoS", map);
	}

	public void insertRejectEndAprOpinionInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRejectEndAprOpinionInfoS", map);
	}

	public void insertRejectEndReceiptPointInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRejectEndReceiptPointInfoS", map);
	}

	public void insertRejectEndAprReceiptProcessInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRejectEndAprReceiptProcessInfoS", map);
	}

	public void insertRejectExpendAprDocInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRejectExpendAprDocInfoS", map);
	}

	public void insertRejectExpendAprLineS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRejectExpendAprLineS", map);
	}
	
	public void insertBebuAprReceiptProcessInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertBebuAprReceiptProcessInfoS", map);
	}
	
	public void insertSetBebuAprReceiptProcessInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertSetBebuAprReceiptProcessInfoS", map);
	}
	
	public void insertSetBebuLineInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertSetBebuLineInfoS", map);
	}
	
	public void insertSetBebuExpLineInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertSetBebuExpLineInfoS", map);
	}
	
	public void insertHesongReceiptInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertHesongReceiptInfo", map);
	}
	
	public void insertHesongAprLineInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertHesongAprLineInfo", map);
	}
	
	public void insertSetHesongExpLineInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertSetHesongExpLineInfoS", map);
	}
	
	public void insertHesongAprLineInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertHesongAprLineInfoS", map);
	}
	
	public void insertHesongAprDocInfoS(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertHesongAprDocInfoS", map);
	}
	
	public void insertRelayDB(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRelayDB", map);
	}
	
	public void insertRelayExchInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRelayExchInfo", map);
	}
	
	public void insertRelayExchInfo2(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRelayExchInfo2", map);
	}
	
	public void insertRecRelayAttachInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRecRelayAttachInfo", map);
	}
	
	public void insertRecRelaySignInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRecRelaySignInfo", map);
	}
	
	public void insertRelayAprDocInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRelayAprDocInfo", map);
	}
	
	public void insertRelayExpAprDocInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRelayExpAprDocInfo", map);
	}
	
	public void insertRelayAttchInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRelayAttchInfo", map);
	}
	
	public void insertRelayAprReceiptProessInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRelayAprReceiptProessInfo", map);
	}
	
	public void insertRelayFailMessage(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRelayFailMessage", map);
	}
	
	public void insertRelayAprLineInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRelayAprLineInfo", map);
	}

	public void insertRelayExpAprLineInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRelayExpAprLineInfo", map);
	}
	
	public void setJijung(Map<String, Object> map) throws Exception{
		update("EzApprovalG.setJijung", map);
	}
	
	public void gongRamUpdate(Map<String, Object> map) throws Exception{
		update("EzApprovalG.gongRamUpdate", map);
	}
	
	public void gongRamActivateAprState(Map<String, Object> map) throws Exception{
		update("EzApprovalG.gongRamActivateAprState", map);
	}
	
	public void aprGetNewID(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.aprGetNewID", map);
	}
	
	public void updateSerialNo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateSerialNo", map);
	}
	
	public void updateAttachFileInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateAttachFileInfo", map);
	}
	
	public void changeRecordInfo2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.changeRecordInfo2", map);
	}
	
	public void updateTbSerialNumGen(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateTbSerialNumGen", map);
	}

	public void updateExistUnit(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateExistUnit", map);
	}
	
	public void updateTbCabinetInfo2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateTbCabinetInfo2", map);
	}
	
	public void updateTbCabinetInfo3(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateTbCabinetInfo3", map);
	}
	
	public void updateTbCabinetClass(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateTbCabinetClass", map);
	}
	
	public void updateTbSeperateAttach(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateTbSeperateAttach", map);
	}

	public ApprGReceiveDocVO getReceiptProInfo(Map<String, Object> map) throws Exception{
		return (ApprGReceiveDocVO) select("EzApprovalG.getReceiptProInfo", map);
	}

	public void jiJungUpdateReceiptProInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.jiJungUpdateReceiptProInfo", map);
	}
	
	public void jiJungUpdateReceiptProInfo2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.jiJungUpdateReceiptProInfo2", map);
	}
	
	public void jiJungUpdateReceiptProInfo3(Map<String, Object> map) throws Exception{
		update("EzApprovalG.jiJungUpdateReceiptProInfo3", map);
	}
	
	public void jiJungUpdateReceiptProInfo4(Map<String, Object> map) throws Exception{
		update("EzApprovalG.jiJungUpdateReceiptProInfo4", map);
	}
	
	public void doResendEndDoc2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.doResendEndDoc2", map);
	}
	
	public void updateTbCabinetInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateTbCabinetInfo", map);
	}
	
	public void jiJungUpdateTbDocDelivery(Map<String, Object> map) throws Exception{
		update("EzApprovalG.jiJungUpdateTbDocDelivery", map);
	}
	
	public void updateDoCallBack(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateDoCallBack", map);
	}
	
	public void updateDoCallBack2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateDoCallBack2", map);
	}
	
	public void updateDoCallBack3(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateDoCallBack3", map);
	}
	
	public void updateModifyFlag(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateModifyFlag", map);
	}
	
	public void updateTbRecord(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateTbRecord", map);
	}
	
	public void updateTbExpendAprDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateTbExpendAprDocInfo", map);
	}
	
	public void updateTbEndAprDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateTbEndAprDocInfo", map);
	}
	
	public void updateCabinetClass(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateCabinetClass", map);
	}
	
	public void updateCabinetClass2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateCabinetClass2", map);
	}
	
	public void updateAprDocOptionInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateAprDocOptionInfo", map);
	}
	
	public void updateAprDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateAprDocInfo", map);
	}
	
	public void updateExpAprDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateExpAprDocInfo", map);
	}
	
	public void updateAprLineInfo1(Map<String, Object> updateAprLineInfo1) throws Exception {
		update("EzApprovalG.updateAprLineInfo1", updateAprLineInfo1);
	}
	
	public void updateAprLineInfo(Map<String, Object> map3) throws Exception{
		update("EzApprovalG.updateAprLineInfo", map3);
	}
	
	public void updateAprLineInfo2(Map<String, Object> map3) throws Exception{
		update("EzApprovalG.updateAprLineInfo2", map3);
	}
	
	public void updateAprLineInfo3(Map<String, Object> map3) throws Exception{
		update("EzApprovalG.updateAprLineInfo3", map3);
	}
	
	public void updatePersonalAgreeLineInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updatePersonalAgreeLineInfo", map);
	}
	
	public void updateProxyExpAprLine(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateProxyExpAprLine", map);
	}
	
	public void updateBoryuAprLineInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateBoryuAprLineInfo", map);
	}
	
	public void updateBoryuAprDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateBoryuAprDocInfo", map);
	}
	
	public void updateReSendEndReceiptPointInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateReSendEndReceiptPointInfo", map);
	}
	
	public void updateProEndReceiptPointInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateProEndReceiptPointInfo", map);
	}
	
	public void updateProEndReceiptPointInfo2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateProEndReceiptPointInfo2", map);
	}
	
	public void updateProEndAprDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateProEndAprDocInfo", map);
	}
	
	public void updateReceiptPointInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateReceiptPointInfo", map);
	}
	
	public void updateSusinEndReceiptPointInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateSusinEndReceiptPointInfo", map);
	}
	
	public void updateSusinEndReceiptPointInfo2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateSusinEndReceiptPointInfo2", map);
	}
	
	public void updateHesongAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateHesongAprReceiptProcessInfo", map);
	}
	
	public void updateRejectAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateRejectAprReceiptProcessInfo", map);
	}
	
	public void updateProYnEndReceiptPointInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateProYnEndReceiptPointInfo", map);
	}
	
	public void updateGamsaAprDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateGamsaAprDocInfo", map);
	}
	
	public void updateJubsuAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateJubsuAprReceiptProcessInfo", map);
	}
	
	public void updateJubsuDocDelivery(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateJubsuDocDelivery", map);
	}
	
	public void updateChamjoAprLineInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateChamjoAprLineInfo", map);
	}
	
	public void updateChamjoEndAprLineInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateChamjoEndAprLineInfo", map);
	}
	
	public void updateGongRamAprDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateGongRamAprDocInfo", map);
	}
	
	public void updateBebuDocDeivery(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateBebuDocDeivery", map);
	}
	
	public void updateDoSendAprDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateDoSendAprDocInfo", map);
	}
	
	public void updateDoSendExpAprDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateDoSendExpAprDocInfo", map);
	}
	
	public void updateChangeCabCabinetClass(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateChangeCabCabinetClass", map);
	}
	
	public void updateChangeCabExtCabinetClass(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateChangeCabExtCabinetClass", map);
	}
	
	public void updateSetBebuAprReceiptProcessInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateSetBebuAprReceiptProcessInfo", map);
	}
	
	public void updateSetBebuAprReceiptProcessInfo2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateSetBebuAprReceiptProcessInfo2", map);
	}
	
	public void updateDoSendAprDocInfo2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateDoSendAprDocInfo2", map);
	}
	
	public void updateDoSendAprDocInfo3(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateDoSendAprDocInfo3", map);
	}
	
	public void updateDelayCabinetClass(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateDelayCabinetClass", map);
	}
	
	public void updateEndCabCabinetClass(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateEndCabCabinetClass", map);
	}
	
	public void updateReqDelayCabinetClass(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateReqDelayCabinetClass", map);
	}
	
	public void updateBanSongAprLineInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateBanSongAprLineInfo", map);
	}

	public void updateBanSongAprDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateBanSongAprDocInfo", map);
	}
	
	public void updateBanSongAprLineInfo2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateBanSongAprLineInfo2", map);
	}
	
	public void updateGongRamSaveAprDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateGongRamSaveAprDocInfo", map);
	}
	
	public void updateGongRamSaveAprDocInfo2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateGongRamSaveAprDocInfo2", map);
	}
	
	public void updateSignCheck(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateSignCheck", map);
	}
	
	public void updateUserCont(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateUserCont", map);
	}
	
	public void updateSetBebuReceiptProcessInfoS(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateSetBebuReceiptProcessInfoS", map);
	}
	
	public void updateSetBebuDocInfoS(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateSetBebuDocInfoS", map);
	}
	
	public void updateBebuReceiptInfoS(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateBebuReceiptInfoS", map);
	}
	
	public void updateHesongReceiptInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateHesongReceiptInfo", map);
	}
	
	public void updateHesongLineInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateHesongLineInfo", map);
	}
	
	public void updateHesongDocInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateHesongDocInfo", map);
	}
	
	public void updateAprDocInfoS(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateAprDocInfoS", map);
	}
	
	public void resetSerialNo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.resetSerialNo", map);
	}

	public void updateResetDoc(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateResetDoc", map);
	}

	public void updateGongRamDocSate(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateGongRamDocSate", map);
	}

	public void updateProAprDocInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateProAprDocInfo", map);
	}

	public void updateRelayFiled(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateRelayFiled", map);
	}
	
	public void updateRelayExchInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateRelayExchInfo", map);
	}
	
	public void updateRecRelayInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateRecRelayInfo", map);
	}
	
	public void updateRecExchInfo(Map<String, Object> map) {
		update("EzApprovalG.updateRecExchInfo", map);
	}
	
	public void updateRecRelayInfoRollback(Map<String, Object> map) {
		update("EzApprovalG.updateRecRelayInfoRollback", map);
	}

	public void updateRecExchInfoRollback(Map<String, Object> map) {
		update("EzApprovalG.updateRecExchInfoRollback", map);
	}
	
	public void updateRelaySusinState(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateRelaySusinState", map);
	}
	
	public void upadateRelayDocInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.upadateRelayDocInfo", map);
	}
	
	public void updateRecvDocInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateRecvDocInfo", map);
	}
	
	public void updateRelayExpDocInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateRelayExpDocInfo", map);
	}
	
	public void updateRelayCabinetDocInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateRelayCabinetDocInfo", map);
	}

	public void updateRelaycabinetExpDocInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateRelaycabinetExpDocInfo", map);
	}
	
	public void deleteReceiptInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteReceiptInfo", map);
	}

	public void deleteLineTempletDetailInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteLineTempletDetailInfo", map);
	}

	public void deleteReceiptTempletDetailInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteReceiptTempletDetailInfo", map);
	}

	public void deleteOpinionInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteOpinionInfo", map);
	}

	public void deleteAttachFileInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteAttachFileInfo", map);
	}

	public void deleteAttachDocInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteAttachDocInfo", map);
	}

	public void doCallBack(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.doCallBack", map);
	}
	
	public void aprDeleteDocInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.aprDeleteDocInfo", map);
	}
	
	public void aprDeleteDocInfo2(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.aprDeleteDocInfo2", map);
	}
	
	public void aprDeleteDocInfo3(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.aprDeleteDocInfo3", map);
	}
	
	public void aprDeleteDocInfo4(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.aprDeleteDocInfo4", map);
	}
	
	public void aprDeleteDocInfo5(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.aprDeleteDocInfo5", map);
	}
	
	public void aprDeleteDocInfo6(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.aprDeleteDocInfo6", map);
	}
	
	public void aprDeleteDocInfo7(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.aprDeleteDocInfo7", map);
	}
	
	public void aprDeleteDocInfo8(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.aprDeleteDocInfo8", map);
	}
	
	public void aprDeleteDocInfo9(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.aprDeleteDocInfo9", map);
	}
	
	public void deleteReceiptTempletDetailInfo2(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteReceiptTempletDetailInfo2", map);
	}
	
	public void deleteLineTempletDetailInfo2(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteLineTempletDetailInfo2", map);
	}
	
	public void deleteSerialNo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteSerialNo", map);
	}
	
	public void deleteTmpDocInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpDocInfo", map);
	}
	
	public void deleteTmpDocInfo2(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpDocInfo2", map);
	}
	
	public void deleteTmpDocInfo3(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpDocInfo3", map);
	}
	
	public void deleteTmpDocInfo4(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpDocInfo4", map);
	}
	
	public void deleteTmpDocInfo5(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpDocInfo5", map);
	}
	
	public void deleteTmpDocInfo6(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpDocInfo6", map);
	}
	
	public void deleteTmpDocInfo7(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpDocInfo7", map);
	}
	
	public void deleteTmpDocInfo8(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpDocInfo8", map);
	}
	
	public void deleteTbAprAttachInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTbAprAttachInfo", map);
	}
	
	public void deleteTbAprDocAttachInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTbAprDocAttachInfo", map);
	}

	public void deleteTbAprLineInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTbAprLineInfo", map);
	}
	
	public void deleteTbExpAprLine(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTbExpAprLine", map);
	}
	
	public void jiJungDeleteReceiptProInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.jiJungDeleteReceiptProInfo", map);
	}
	
	public void jiJungDeleteReceiptProInfo2(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.jiJungDeleteReceiptProInfo2", map);
	}
	
	public void deleteTbSpecialCatalogInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTbSpecialCatalogInfo", map);
	}
	
	public void deleteTbCabRoleInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTbCabRoleInfo", map);
	}
	
	public void deleteTbSpecialCatalogInfo_Cab(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTbSpecialCatalogInfo_Cab", map);
	}
	
	public void deleteFormRecvTB(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteFormRecvTB", map);
	}
	
	public void deleteExApprLine(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteExApprLine", map);
	}
	
	public void deleteApprLineInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteApprLineInfo", map);
	}
	
	public void deleteLastDeptLine(Map<String, Object> map) throws Exception  {
		delete("EzApprovalG.deleteLastDeptLine", map);
	}
	
	public void deleteLastAprLine(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteLastAprLine", map);
	}
	
	public void deleteTmpReceiptPointInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpReceiptPointInfo", map);
	}

	public void deleteTmpAprOpinionInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpAprOpinionInfo", map);
	}

	public void deleteTmpAprDocAttachInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpAprDocAttachInfo", map);
	}

	public void deleteTmpAttachInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpAttachInfo", map);
	}

	public void deleteTmpAprLineInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpAprLineInfo", map);
	}

	public void deleteTmpExpAprLine(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpExpAprLine", map);
	}

	public void deleteTmpExpAprDocInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpExpAprDocInfo", map);
	}

	public void deleteTmpAprDocInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpAprDocInfo", map);
	}
	
	public void deleteReSendEndReceiptPointInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteReSendEndReceiptPointInfo", map);
	}
	
	public void deleteHesongExpAprLine(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteHesongExpAprLine", map);
	}
	
	public void deleteHesongAprLineInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteHesongAprLineInfo", map);
	}
	
	public void deleteGongRamAprLineInfo(Map<String, Object> map) {
		delete("EzApprovalG.deleteGongRamAprLineInfo", map);
	}

	public void deleteGongRamExpAprLine(Map<String, Object> map) {
		delete("EzApprovalG.deleteGongRamExpAprLine", map);
	}
	
	public void deleteRollBackSignInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteRollBackSignInfo", map);
	}
	
	public void deleteRegAprAttachInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteRegAprAttachInfo", map);
	}
	
	public void deleteDoSendAprAttachInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteDoSendAprAttachInfo", map);
	}

	public void deleteDoSendAprDocAttachInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteDoSendAprDocAttachInfo", map);
	}
	
	public void deleteChangeCabSpecialCatalogInfo_Cab(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteChangeCabSpecialCatalogInfo_Cab", map);
	}
	
	public void deleteSetBebuExpAprLine(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteSetBebuExpAprLine", map);
	}
	
	public void deleteSetBebuAprLineInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteSetBebuAprLineInfo", map);
	}
	
	public void deleteRecRoleInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteRecRoleInfo", map);
	}
	
	public void deleteGongRamSaveAprLineInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteGongRamSaveAprLineInfo", map);
	}

	public void deleteGongRamSaveExpAprLine(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteGongRamSaveExpAprLine", map);
	}
	
	public void deleteSignCheck(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteSignCheck", map);
	}
	
	public void delUserConttList(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.delUserConttList", map);
	}
	
	public void delUserCont(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.delUserCont", map);
	}
	
	public void deleteUserContDoc(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteUserContDoc", map);
	}
	
	public void deleteRecRelayInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteRecRelayInfo", map);
	}

	public void deleteRelayAprDocInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteRelayAprDocInfo", map);
	}
	
	public void deleteRelayReceiptProcessInfo(Map<String, Object> map) {
		delete("EzApprovalG.deleteRelayReceiptProcessInfo", map);
	}

	public void deleteRelayAttachInfo(Map<String, Object> map) {
		delete("EzApprovalG.deleteRelayAttachInfo", map);
	}

	public void deleteRelayExpAprDocInfo(Map<String, Object> map) {
		delete("EzApprovalG.deleteRelayExpAprDocInfo", map);
	}

	public void deleteRelayAprDocInfo2(Map<String, Object> map) {
		delete("EzApprovalG.deleteRelayAprDocInfo2", map);
	}
	
	public void deleteRelayAprLineInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteRelayAprLineInfo", map);
	}

	public void deleteRelayExpAprLineInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteRelayExpAprLineInfo", map);
	}
	
	public ApprGTaskVO getAllCategory(Map<String, Object> map) throws Exception {
		return (ApprGTaskVO) select("EzApprovalG.getAllCategory", map);
	}

	public ApprGFormVO getAutoDocNumItem(Map<String, Object> map) throws Exception {
		return (ApprGFormVO) select("EzApprovalG.getAutoDocNumItem", map);
	}

	public ApprGDocListVO doSendOffer_AprDocInfo(Map<String, Object> map) throws Exception {
		return (ApprGDocListVO) select("EzApprovalG.doSendOffer_AprDocInfo", map);
	}

	public ApprGDocListVO doSendOffer_expAprDocInfo(Map<String, Object> map) throws Exception {
		return (ApprGDocListVO) select("EzApprovalG.doSendOffer_expAprDocInfo", map);
	}

	public ApprGLineTempletVO getOrgDocLineInfo(Map<String, Object> map) throws Exception {
		return  (ApprGLineTempletVO) select("EzApprovalG.getOrgDocLineInfo", map);
	}

	public String doSusinHesongDeptID(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.doSusinHesongDeptID", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getAddress(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzApprovalG.getAddress", map);
	}

	public ApprGAprLineVO getSameOrgHAPYUIDoc(Map<String, Object> map) throws Exception {
		return (ApprGAprLineVO) select("EzApprovalG.getSameOrgHAPYUIDoc", map);
	}
	
	public ApprGDocListVO setcabinetHesong(Map<String, Object> map) throws Exception {
		return (ApprGDocListVO) select("EzApprovalG.setcabinetHesong", map);
	}

	public String getHapyuiCount(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getHapyuiCount", map);
	}

	public void delCirculation(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.delCirculation", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> getCirculationInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGAprLineVO>) list("EzApprovalG.getCirculationInfo", map);
	}

	public String getCircularDocID(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getCircularDocID", map);
	}

	public String getLastDocDate(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getLastDocDate", map);
	}

	public void deleteOpinionTypeInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteOpinionTypeInfo", map);
	}
	
	public void OpinionDel2(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.OpinionDel2", map);
	}
	
	public void OpinionDel3(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.OpinionDel3", map);
	}
	
	public void updateReBebuOpinionSN(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateReBebuOpinionSN", map);
	}
	
	public void updateHasOpinionYN(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateHasOpinionYN", map);
	}
	
	public void updateWhoKyulAprLine(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateWhoKyulAprLine", map);
	}
	
	public void doWhoKyulComplete(Map<String, Object> map) throws Exception {
		update("EzApprovalG.doWhoKyulComplete", map);
	}
	
	public String getWhoKyulYN(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getWhoKyulYN", map);
	}
	
	public String getDraftDeptID(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getDraftDeptID", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getLastHabYuiDocState(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getLastHabYuiDocState", map);
	}

	public void updateDocNumber(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateDocNumber", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> getChamJoLineList(Map<String, Object> map) throws Exception {
		return (List<ApprGAprLineVO>) list("EzApprovalG.getChamJoLineList", map);
	}

	public void updateChamJoLineState(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateChamJoLineState", map);
	}

	public int getLineAprMode(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getLineAprMode", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> chamJoEndPerMission(Map<String, Object> map) throws Exception {
		return (List<ApprGAprLineVO>) list("EzApprovalG.chamJoEndPerMission", map);
	}

	public String getChamJoDocID(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getChamJoDocID", map);
	}

	public void updateSusinState(Map<String, Object> map) {
		update("EzApprovalG.updateSusinState", map);
	}

	public void updateBanSongChamJoAprLineInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateBanSongChamJoAprLineInfo", map);
	}
	
	public int getCountDoingDocInfo(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getCountDoingDocInfo", map);
	}
	// 김민재 - 구버전 포탈 포틀릿 소스로 현재 사용하지 않아 주석처리
	/*@SuppressWarnings("unchecked")
	public Map<String, Object> getPortletApprGapTime(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) select("EzApprovalG.getPortletApprGapTime", map);
	}*/
	
	public String getDocExt(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getDocExt", map);
	}
	
	public void deleteInitReceiptPonit(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteInitReceiptPonit", map);
	}
	public void setInitReceiptPonit(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.setInitReceiptPonit", map);
	}
	public int checkNonElecRec(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.checkNonElecRec", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGRecordTempVO> getNonElecInfoSusinInit(Map<String, Object> map) throws Exception {
		return (List<ApprGRecordTempVO>) list("EzApprovalG.getNonElecInfoSusinInit", map);
	}
	
	public void setNonElecRecCabID(Map<String, Object> map) throws Exception {
		update("EzApprovalG.setNonElecRecCabID", map);
	}
	public void setEndNonElecRecDocDel(Map<String, Object> map) throws Exception {
		update("EzApprovalG.setEndNonElecRecDocDel", map);
	}
	public String getOrgDocID(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getOrgDocID", map);
	}
	public String getRecordID(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getRecordID", map);
	}
	public void updateNonElecRecInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateNonElecRecInfo", map);
	}
	public void updateNonElecRecInfo2(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateNonElecRecInfo2", map);
	}
	public void updateNonElecRecInfo3(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateNonElecRecInfo3", map);
	}
	public String getDocHrefInfoHref(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getDocHrefInfoHref", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTopOtherCompanyAddJobVO> getAllCompanyList(Map<String, Object> map) {
		return (List<PortalTopOtherCompanyAddJobVO>) list("EzApprovalG.getAllCompanyList", map);
	}
		
	public void deleteSpecialInfoNonElecRec(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteSpecialInfoNonElecRec", map);
	}
	public void insertSpecialInfoNonElecRec(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertSpecialInfoNonElecRec", map);
	}
	public void insertSpecialInfoNonElecRec2(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertSpecialInfoNonElecRec2", map);
	}
	@SuppressWarnings("unchecked")
	public List<ApprGRecordTempVO> selectSpecialInfoNonElecRec(Map<String, Object> map) throws Exception {
		return (List<ApprGRecordTempVO>) list("EzApprovalG.selectSpecialInfoNonElecRec", map);
	}
	
	public int getLinkedAttachFileCount(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getLinkedAttachFileCount", map);
	}
	
	public String getFormIdOfTempDocument(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getFormIdOfTempDocument", map);
	}
	
	public String getReformFlag(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getReformFlag", map);
	}
	
	public String getReformFlagOfTempDoc(String formUrl) throws Exception {
		return (String) select("EzApprovalG.getReformFlagOfTempDoc", Collections.singletonMap("formUrl", formUrl));
	}
	
	public ApprGFormVO getReformInfoForApprovalDocument(Map<String, Object> map) throws Exception {
		return (ApprGFormVO) select("EzApprovalG.getReformInfoForApprovalDocument", map);
	}
	
	public void susinNonElecRecDocDel1(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.susinNonElecRecDocDel1", map);
	}
	public void susinNonElecRecDocDel2(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.susinNonElecRecDocDel2", map);
	}
	public void susinNonElecRecDocDel3(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.susinNonElecRecDocDel3", map);
	}
	public void susinNonElecRecDocDel4(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.susinNonElecRecDocDel4", map);
	}
	public void susinNonElecRecDocDel5(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.susinNonElecRecDocDel5", map);
	}
	public void susinNonElecRecDocDel6(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.susinNonElecRecDocDel6", map);
	}
	public void susinNonElecRecDocDel7(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.susinNonElecRecDocDel7", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getPortletApprMemeberList(Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>)list("EzApprovalG.getPortletApprMemeberList", map); 
	}
	public String getExtAttr1(Map<String, Object> map) throws Exception{
		return (String)select("EzApprovalG.getExtAttr1", map);
	}
	public ApprGDocInfoWebSrvVO getHWPdownload(Map<String, Object> map) throws Exception{
		return (ApprGDocInfoWebSrvVO)select("EzApprovalG.getHWPdownload", map);
	}
	public String isBebuDocExist(Map<String, Object> map) throws Exception{
		return (String)select("EzApprovalG.isBebuDocExist", map);
	}
	public void updateDocDeliveryHref(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateDocDeliveryHref", map);
	}

	public void moveRecord2(Map<String, Object> map) throws Exception {
		update("EzApprovalG.moveRecord2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getRelayReqDeptID(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzApprovalG.getRelayReqDeptID", map);
	}

	public String getDocSendType(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getDocSendType", map);
	}
	
	public String getDocNumZeroCnt(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getDocNumZeroCnt", map);
	}
	
	public void setDocNumZeroCnt(Map<String, Object> map) throws Exception {
		update("EzApprovalG.setDocNumZeroCnt", map);
	}

	public void updateOpinionInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateOpinionInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getShareOwnerId(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzApprovalG.getShareOwnerId", map);
	}
	
	public int getCheckAprState(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getCheckAprState", map);
	}
	
	public void insertReuseAttachFileInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertReuseAttachFileInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public ArrayList<String> getReceiptPointNameList(Map<String, Object> map) throws Exception {
		return (ArrayList<String>) list("EzApprovalG.getReceiptPointNameList", map);
	}

	public String getOrgLastAprMemberName(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getOrgLastAprMemberName", map);
	}

	public String getreceiverName(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getreceiverName", map);
	}
	
	public int checkHabYuiState(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.checkHabYuiState", map);
	}
	
	public void setHesongCabinetID(Map<String, Object> map) throws Exception {
		update("EzApprovalG.setHesongCabinetID", map);
	}
	
	public String getAprOrgDocID(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getAprOrgDocID", map);
	}
	
	public int getEndAprOpinionCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getEndAprOpinionCnt", map);
	}
	
	public void insertHesongOpinion(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertHesongOpinion", map);
	}

	public String getTmpDocHref(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getTmpDocHref", map);
	}
	
	public String getTmpHref(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getTmpHref", map);
	}

	@SuppressWarnings("unchecked")
	public ArrayList<String> getTmpDocList(Map<String, Object> map) throws Exception {
		return (ArrayList<String>) list("EzApprovalG.getTmpDocList", map);
	}
	
	public void setHesongBansongCabinetID(Map<String, Object> map) throws Exception {
		update("EzApprovalG.setHesongBansongCabinetID", map);
	}

	public String getDeptIdOfCabinet(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getDeptIdOfCabinet", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGProxyVO> getProxyInfo_U(Map<String, Object> map) throws Exception {
		return (List<ApprGProxyVO>) list("EzApprovalG.getProxyInfo_U", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGProxyVO> getProxyInfo_A(Map<String, Object> map) throws Exception {
		return (List<ApprGProxyVO>) list("EzApprovalG.getProxyInfo_A", map);
	}

	public int checkDocIdIsDuplicated(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.checkDocIdIsDuplicated", map);
	}
	
	public int checkProxyAprLine(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.checkProxyAprLine", map);
	}
	
	public ApprGFormVO getFormPath(Map<String, Object> map) throws Exception {
		return (ApprGFormVO) select("EzApprovalG.getFormPath", map);
	}
	
	public void insertOpenGovAttachInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertOpenGovAttachInfo", map);
	}

	public void deleteOpenGovAttachInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteOpenGovAttachInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGOpenGovAttachVO> getAttachListForOpenGov(Map<String, Object> map) throws Exception {
		return (List<ApprGOpenGovAttachVO>) list("EzApprovalG.getAttachListForOpenGov", map);
	}

	public void aprMakeTmp2Ing13(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.aprMakeTmp2Ing13", map);		
	}

	public void aprMakeTmp2Ing14(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.aprMakeTmp2Ing14", map);
	}

    public void aprDeleteDocInfo13(Map<String, Object> map) throws Exception {
	    delete("EzApprovalGDAO.aprDeleteDocInfo13", map);
    }

    public void aprDeleteDocInfo14(Map<String, Object> map) throws Exception {
        delete("EzApprovalGDAO.aprDeleteDocInfo14", map);
    }

	//2019-05-03 공람자지정
	public void deleteGongRamLineInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteGongRamLineInfo", map);
	}
	
	/* 2024-05-31 홍승비 - 호출되지 않는 구버전 쿼리 주석처리 */
	/*public void insertGongRamLineInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertGongRamLineInfo", map);
	}*/
	
	public int checkGongRamLineCount(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.checkGongRamLineCount", map);
	}
	
	public void insertGongRamSendAprLineInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertGongRamSendAprLineInfo", map);
	}
	
	public void insertGongRamSendExpAprLine(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertGongRamSendExpAprLine", map);
	}
	
	public void deleteGongRamSendAprLineInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteGongRamSendAprLineInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> getGongRamLineInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGAprLineVO>) list("EzApprovalG.getGongRamLineInfo", map);
	}

	public void insertOpenGovDocInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertOpenGovDocInfo", map);		
	}

	public void deleteOpenGovDocInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteOpenGovDocInfo", map);		
	}

	public void updateFileOpenFlag(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateFileOpenFlag", map);
	}

	public String getOpenGovFlag(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getOpenGovFlag", map);
	}

	public ApprGOpenGovInfoVO getOpenGovInfo(Map<String, Object> map) throws Exception {
		return (ApprGOpenGovInfoVO) select("EzApprovalG.getOpenGovInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getFileOpenFlagList(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzApprovalG.getFileOpenFlagList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getFileOpenSNList(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzApprovalG.getFileOpenSNList", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGDocListForOpenGovVO> getSearchDocListForOpenGov(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListForOpenGovVO>) list("EzApprovalG.getSearchDocListForOpenGov", map);
	}

	public int getSearchDocListCountForOpenGov(Map<String, Object> map) throws Exception {
		return (int)select("EzApprovalG.getSearchDocListCountForOpenGov", map);
	}

	public ApprGOpenGovInfoVO getOpenGovInfoForUpdate(Map<String, Object> map) throws Exception {
		return (ApprGOpenGovInfoVO) select("EzApprovalG.getOpenGovInfoForUpdate", map);
	}

	public void updateOpenGovDocInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateOpenGovDocInfo_EXPENDAPRDOCINFO", map);
		update("EzApprovalG.updateOpenGovDocInfo_RECORD", map);
		update("EzApprovalG.updateOpenGovDocInfo_OPENGOVDOCINFO", map);
	}

	public void updateOpenGovDocInfoComp_createDate(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateOpenGovDocInfoComp_createDate", map);
	}
	
	public void updateOpenGovFileInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateOpenGovDocInfo_OPENGOVFILEINFO", map);
	}

	public int isSN(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.isSN", map);
	}

	public int getSN(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getSN", map);
	}

	public void insertModifyOpenGovHistory(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertModifyOpenGovHistory", map);
	}

	public String getOpenGovLimitDate(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getOpenGovLimitDate", map);
	}

	public void updateOpenGovDocFileSize(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateOpenGovDocFileSize", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGOpenGovCsvVO> getOpenGovCSV() throws Exception {
		return (List< ApprGOpenGovCsvVO>) list("EzApprovalG.getOpenGovCSV");
	}
	
    public void updateReceivedDept(Map<String, Object> map) throws Exception {
        update("EzApprovalG.updateReceivedDept", map);
    }
    
	public String getFormAprOptionInfo(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getFormAprOptionInfo", map);
	}    

	public void updateReBebuAprReceiptProcessInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateReBebuAprReceiptProcessInfo", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getDeliveryDeptInfo(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) select("EzApprovalG.getDeliveryDeptInfo", map);
	}
	
	public int isRelayDoc(Map<String, Object> map) throws Exception {
        return (int) select("EzApprovalG.isRelayDoc", map);
	}
	
	public ApprGReceiveDocVO getBebuRelayDocSenderInfo(Map<String, Object> map) throws Exception {
	        return (ApprGReceiveDocVO) select("EzApprovalG.getBebuRelayDocSenderInfo", map);
	}
	
	public void updateBebuRelayDocSenderInfo(Map<String, Object> map) throws Exception {
	        update("EzApprovalG.updateBebuRelayDocSenderInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGFormVO> getFormContainer(Map<String, Object> map) {
		return (List<ApprGFormVO>) list("EzApprovalG.getFormContainer", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<KEDSharedUserInfo> getShareList(Map<String, Object> map) {
		return (List<KEDSharedUserInfo>)list("EzApprovalG.getShareList", map);
	}
	
	public ApprGAprLineVO selectHabyuiResultAprMemberInfoVO(Map<String, Object> map) throws Exception{
		return (ApprGAprLineVO) select("EzApprovalG.selectHabyuiResultAprMemberInfoVO", map);
	}

	public void deleteRejectOrgDocOpinions(Map<String, Object> map) {
		delete("EzApprovalG.deleteRejectOrgDocOpinions",map);
	}

	public void delOpinionsExceptHesong(Map<String, Object> map) {
		delete("EzApprovalG.delOpinionsExceptHesong", map);
	}
	
	public void delOpinionsExceptDrafters(Map<String, Object> map) {
		delete("EzApprovalG.delOpinionsExceptDrafters", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getLeftDocCountNew(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) select("EzApprovalG.getLeftDocCount_new", map);
	}
	
	public void updateEndAprDocOptionInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateEndAprDocOptionInfo", map);
	}
	
	public void copyOpinionsFromOrgDoc(Map<String, Object> map) {
		insert("EzApprovalG.copyOpinionsFromOrgDoc", map);
	}
	
	public void copyOpinionsFromOrgDoc2(Map<String, Object> map) {
		insert("EzApprovalG.copyOpinionsFromOrgDoc2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> doApproveLineInfoForPassAprLine(Map<String, Object> map) throws Exception {
		return (List<ApprGAprLineVO>) list("EzApprovalG.doApproveLineInfoForPassAprLine", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> doApproveLineInfoForCancelToPassAprLine(Map<String, Object> map) throws Exception {
		return (List<ApprGAprLineVO>) list("EzApprovalG.doApproveLineInfoForCancelToPassAprLine", map);
	}
	
	public void updateDrafterToApproved(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateDrafterToApproved", map);
	}
	
	public void setAprLineStateBanSongToStay(Map<String, Object> map) throws Exception {
		update("EzApprovalG.setAprLineStateBanSongToStay", map);
	}
	
	public String getPassAprLineFlagByDocID(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getPassAprLineFlagByDocID", map);
	}
	
	/* 2020-07-23 홍승비 - 완료문서의 전체 정보를 가져오는 쿼리 */
	public ApprGDocListVO getEndDocInfo(Map<String, Object> map) throws Exception {
		return (ApprGDocListVO) select("EzApprovalG.getEndDocInfo", map);
	}
	
	/* 2020-07-23 홍승비 - 전달한 사용자ID에 대하여, 특정 진행문서의 전체 정보를 가져오는 쿼리 */
	public ApprGDocListVO getIngDocInfo(Map<String, Object> map) throws Exception {
		return (ApprGDocListVO) select("EzApprovalG.getIngDocInfo", map);
	}
	
	public List<ApprGLineTempletVO> getNextAprLineInfo(Map<String, Object> map) throws Exception {
	    return (List<ApprGLineTempletVO>) list("EzApprovalG.getNextAprLineInfo", map);
	}

	/* 2020-10-05 홍승비 - 임시저장문서의 결재선 중에서 결재상태 값이 없는 데이터 카운트 리턴 쿼리 */
	public int getNullTmpDocAprStateCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getNullTmpDocAprStateCnt", map);
	}
	
	public void updateDocInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateDocInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getDocList(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, Object>>) list("EzApprovalG.getDocList", map);
	}
	
	public int cntAttachFileCanDownload(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.cntAttachFileCanDownload", map);
	}

	public int cntIsBigAttachFile(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.cntIsBigAttachFile", map);
	}

	public int cntDownloadLimitCntExists(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.cntDownloadLimitCntExists", map);
	}

	public int getBigAttachFileDownloadCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getBigAttachFileDownloadCnt", map);
	}

	public void insertBigAttachFileDownloadCnt(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertBigAttachFileDownloadCnt", map);
	}
	
	public void updateBigAttachFileDownloadCnt(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateBigAttachFileDownloadCnt", map);
	}

	public void deleteBigAttachFileDownloadCnt(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteBigAttachFileDownloadCnt", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGAttachInfoVO> getBigAttachFileForDelete(Map<String, Object> map) throws Exception {
		return (List<ApprGAttachInfoVO>) list("EzApprovalG.getBigAttachFileForDelete", map);
	}

	public void updateIsBigAttachDel(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateIsBigAttachDel", map);
	}

	public String getAttachFileMinSaveDate(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getAttachFileMinSaveDate", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGYesanGamsaVO> getGamsaYesanDeptInfo(Map<String, Object> map) throws Exception {
	    return (List<ApprGYesanGamsaVO>) list("EzApprovalG.getGamsaYesanDeptInfo", map);
	}
	
	public Map<String, Object> getDocProcessState(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) select("EzApprovalG.getDocProcessState", map);
	}
	
	// 정주환 수신문서 스케쥴러 DB 등록
	public void insertSendDocDB(Map<String, Object> map) {
		insert("EzApprovalG.insertSendDocDB", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getSendDocList() throws Exception {
	    return (List<HashMap<String, Object>>) list("EzApprovalG.getSendDocList");
	}
	
	public void deleteSendDocList(HashMap<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteSendDocList", map);
	}

	public String getOrgDocIDByMode(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getOrgDocIDByMode", map);
	}
	
	public String getChaebunDept(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getChaebunDept", map);
	}

	public void deleteDocDelivery(Map<String, Object> map) throws Exception {
	    delete("EzApprovalG.deleteDocDelivery", map);
	}
	
	public List<String> selectDuplicateRebebuDoc(Map<String, Object> map) throws Exception {
	    return (List<String>) list("EzApprovalG.selectDuplicateRebebuDoc", map);
	}
	
	public void insertMoveRebebuOpinion(Map<String, Object> map) throws Exception {
	    insert("EzApprovalG.insertMoveRebebuOpinion", map);
	}
	
	public void updateAprReceiptProcessInfoRootDocID(Map<String, Object> map) throws Exception {
	    update("EzApprovalG.updateAprReceiptProcessInfoRootDocID", map);
	}
    
    public List<ApprGReceiptVO> selectDisbandGroupReceipt(Map<String, Object> map) throws Exception {
        return (List<ApprGReceiptVO>) list("EzApprovalG.selectDisbandGroupReceipt", map);
    }
    
    public void insertDisbandGroupReceipt(Map<String, Object> map) throws Exception {
        insert ("EzApprovalG.insertDisbandGroupReceipt", map);
    }
    
    public List<Map<String, Object>> getReceiptInfoIng(Map<String, Object> map) throws Exception {
        return (List<Map<String, Object>>) list("EzApprovalG.getReceiptInfoIng", map);
    }

	public void updateHistoryAttachInfo(Map<String, Object> map) {
		update("EzApprovalG.updateHistoryAttachInfo", map);		
	}

    public void deleteEndAprLineInfo(Map<String, Object> map) throws Exception {
        delete("EzApprovalG.deleteEndAprLineInfo", map);
    }

    public void updateEndAprDocInfoCont(Map<String, Object> map) throws Exception {
	    update("EzApprovalG.updateEndAprDocInfoCont", map);
    }
    
    public void rollbackJubsuAprReceiptProcessInfo(Map<String, Object> map) throws Exception {
	    update("EzApprovalG.rollbackJubsuAprReceiptProcessInfo", map);
    }
    
    public void saveFilterDataInfo(Map<String, Object> map) throws Exception {
    	insert ("EzApprovalG.saveFilterDataInfo", map);
    }
    
    // 문서24 관련 메서드
    public String checkbtnReSend24Display(Map<String, Object> map) throws Exception {
    	return (String) select("EzApprovalG.checkbtnReSend24Display", map);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> getDoc24Info(Map<String, Object> map) throws Exception {
    	return (Map<String, Object>) select("EzApprovalG.getDoc24Info", map);
    }
    
	public void insertReciptInfoDoc24(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertReciptInfoDoc24", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getReceiptHistoryInfo(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) list("EzApprovalG.getReceiptHistoryInfo", map);
	}
	
    /* 2022-01-11 홍승비 - 일괄기안 > 표출할 양식 리스트 리턴 */
	@SuppressWarnings("unchecked")
	public List<ApprGFormVO> getDraftAllFormInfo(Map<String, Object> map) throws Exception { 
		return (List<ApprGFormVO>) list("EzApprovalG.getDraftAllFormInfo", map);
	}
	/* 2022-01-11 홍승비 - 일괄기안 > 안으로 묶인 문서 리스트 리턴 (재기안 시 사용) */
	@SuppressWarnings("unchecked")
	public List<ApprGGroupDocInfoVO> getGroupDocList(Map<String, Object> map) throws Exception {
		return (List<ApprGGroupDocInfoVO>) list("EzApprovalG.getGroupDocList", map);
	}
	/* 2022-01-11 홍승비 - 일괄기안 > 임시저장 또는 재기안을 위하여 그룹으로 묶인 일괄기안 문서의 GROUPDOCSN값 리턴 */
	public String getGroupDocSN(Map<String, Object> map) {
		return (String) select("EzApprovalG.getGroupDocSN", map);
	}
	/* 2022-01-17 홍승비 - 일괄기안 > 1안 이후 안 추가 시 결재선 복사 */
	public void copyAprLine(ApprGAttachOptionVO apprGAttachOptionVO) throws Exception {
		insert("EzApprovalG.copyAprLine", apprGAttachOptionVO);
	}
	/* 2022-01-17 홍승비 - 일괄기안 > 1안 이후 안 추가 시 EXP결재선 복사 */
	public void copyExpAprLine(ApprGAttachOptionVO apprGAttachOptionVO) throws Exception {
		insert("EzApprovalG.copyExpAprLine", apprGAttachOptionVO);
	}
	/* 2022-01-17 홍승비 - 일괄기안 > 1안 이후 안 추가 시 일반첨부 복사 */
	public void copyAttachFile(ApprGAttachOptionVO apprGAttachOptionVO) throws Exception {
		insert("EzApprovalG.copyAttachFile", apprGAttachOptionVO);
	}
	/* 2022-01-17 홍승비 - 일괄기안 > 1안 이후 안 추가 시 문서첨부 복사 */
	public void copyAttachDoc(ApprGAttachOptionVO apprGAttachOptionVO) throws Exception {
		insert("EzApprovalG.copyAttachDoc", apprGAttachOptionVO);
	}
	/* 2022-01-17 홍승비 - 일괄기안 > 1안 이후 안 추가 시 일반첨부 히스토리 복사 */
	public void copyAttachHistory(ApprGAttachOptionVO apprGAttachOptionVO) throws Exception {
		insert("EzApprovalG.copyAttachHistory", apprGAttachOptionVO);
	}
	/* 2022-01-17 홍승비 - 일괄기안 > 1안 이후 안 추가 시 의견정보 복사 */
	public void copyOpinionInfo(ApprGAttachOptionVO apprGAttachOptionVO) throws Exception {
		insert("EzApprovalG.copyOpinionInfo", apprGAttachOptionVO);
	}
	/* 2022-01-17 홍승비 - 일괄기안 > 1안 이후 안 추가 시 원문공개 첨부파일정보 복사 */
	public void copyParentOpenGovFileInfo(Map<String, Object> map) throws Exception{
		 insert("EzApprovalG.copyParentOpenGovFileInfo", map);
	}
	/* 2022-01-17 홍승비 - 일괄기안 > 결재정보 원문공개 첨부파일정보 리턴 */
	@SuppressWarnings("unchecked")
	public List<ApprGOpenGovAttachVO> getAttachListForOpenGovDraftAll(Map<String, Object> map) throws Exception {
		return (List<ApprGOpenGovAttachVO>) list("EzApprovalG.getAttachListForOpenGovDraftAll", map);
	}
	/* 2022-01-18 홍승비 - 일괄기안 > 일괄기안문서의 그룹정보 삭제 */
	public void deleteGroupDocList(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteGroupDocList", map);
	}
	/* 2022-01-18 홍승비 - 일괄기안 > 일괄기안문서의 그룹정보 삽입 (임시저장) */
	public void saveTmpGroup(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.saveTmpGroup", map);
	}
	/* 2022-02-10 홍승비 - 일괄기안 > 일괄기안문서의 그룹정보 삽입 (실제 기안 시) */
	public void saveAprGroup(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.saveAprGroup", map);
	}
	/* 2022-01-27 홍승비 - 일괄기안 > 주어진 DOCID에 대해 일괄기안문서 그룹정보 카운트 리턴 */
	public int cntGroupDocID(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.cntGroupDocID", map);
	}
	/* 2022-02-18 홍승비 - 일괄기안 > 그룹으로 묶인 1안의 보류의견 또는 반송의견을 각 안으로 복사 */
	public void copyFirstTabOpinion(Map<String, Object> map) {
		insert("EzApprovalG.copyFirstTabOpinion", map);
	}
	/* 2022-03-02 홍승비 > 결재문서가 가진 모든 타입의 의견 총 갯수를 리턴 */
	public int getAprDocOpinionCnt(Map<String, Object> map) {
		return (int) select("EzApprovalG.getAprDocOpinionCnt", map);
	}
	
	public String getFormIdFromApr(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getFormIdFromApr", map);
	}
	
	public void deleteEndOpinionInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteEndOpinionInfo", map);
	}

	public ApprGDocListVO doSendOfferRejectEndDoc(Map<String, Object> map) throws Exception {
		return (ApprGDocListVO) select("EzApprovalG.doSendOfferRejectEndDoc", map);
	}

	public void updateRecInfoRejectFlag(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateRecInfoRejectFlag", map);
	}
	
	public String getApprovConfig(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getApprovConfig", map);
	}
	
	public void setApprovConfig(Map<String, Object> map) throws Exception{
		update("EzApprovalG.setApprovConfig", map);
	}
	
	public void setApprovConfig2(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.setApprovConfig2", map);
	}
	
	/* 2022-06-17 홍승비 - DOCID를 전달하면 해당 문서가 진행문서(APR)인지, 완료문서(END)인지 문자열로 리턴함 */
	public String getAprOrEndStr(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getAprOrEndStr", map);
	}
	
	/* 2022-07-20 홍승비 - CABINETCLASSNO를 전달하면 해당 기록물철분류의 생산년도를 리턴 */
	public String getCabProduceYear(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getCabProduceYear", map);
	}

	/* 2022-09-21 홍승비 - 전자결재G > 이미 정상적으로 문서번호가 부여된 레코드가 존재하는 경우, TBL_RECORD 중복 삽입 오류 시 현재 문서번호를 롤백하지 않도록 예외처리 레코드 추가 */
	public void insertRegErrorNoRollbackRecord(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertRegErrorNoRollbackRecord", map);
	}

	/* 2022-09-21 홍승비 - 정상적인 문서번호 채번 뒤의 중복삽입 오류가 발생한 경우, 기존 문서번호를 롤백하지 않도록 카운트 체크 */
	public int getNoRollbackRecordCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getNoRollbackRecordCnt", map);
	}

	/* 2023-02-02 홍승비 - 부서수신함 > 접수 > 수신문 지정 시, 완료된 원문서의 수신자 정보를 갱신 (동일 부서에 대하여 새롭게 지정된 수신자 "개인"의 정보로 갱신 / 승인상태는 "대기"로 유지) */
	public void updateSusinEndReceiptPointInfoForJiJung(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateSusinEndReceiptPointInfoForJiJung", map);
	}

	/* 2023-02-21 홍승비 - 완료문서 재사용 > 문서의 모든 내용 재사용 시, 첨부파일의 히스토리도 첨부파일 기반으로 추가 (첨부자 정보는 기안자 정보로 통일) */
	public void insertReuseAttachHistory(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertReuseAttachHistory", map);	
	}

	// 2023-06-26 민지수 - 완료문서 추가의견 저장
	public void insertAddOptionInfo(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertAddOptionInfo", map);
	}
	// 완료문서 추가의견 삭제
	public void deleteAddOpinionInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteAddOpinionInfo", map);
	}
	// 완료문서 추가의견을 제외한 의견 순번 조회
	public int getExistingOpinionSN(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.selectOpinionSn", map);
	}
	// 완료문서 추가의견 존재 여부 조회
    public String getOpinionAddGB(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.selectOpinionAddGb", map);
    }
	// 완료문서 일반의견 존재 여부 조회
	public String getOpinionYn(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.selectOpinionYn",map);
	}
	// 완료문서 의견여부 조회
	public String getHasopinionYn(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.selectHasOpinionYn",map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGOutOfOfficeInfoVO> getAllProxyInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGOutOfOfficeInfoVO>) list("EzApprovalG.getAllProxyInfo", map);
	}
	
	// 2023-09-25 전인하 - 전자결재G > 배부대장 미리보기 > 진행문서 열람권한 조회
	public String getAccessYNGforAPR(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getAccessYNGforAPR", map);
	}

    /* 2023-06-20 전인하 - 전자결재G > 기록물대장 미리보기 - 보안결재 문서인 경우, 지정된 날짜(SECURITYAPPROVAL)를 리턴 */
    public String checkSecurityApprovalDate(Map<String, Object> map)  throws Exception {
		return (String) select("EzApprovalG.checkSecurityApprovalDate", map);
    }
    
    /* 2023-11-30 홍승비 - 전자결재 > 서명 재맵핑 > DOCID를 조건으로 TBL_SIGNINFO 테이블의 결재서명 데이터를 전부 가져오는 쿼리 */
	@SuppressWarnings("unchecked")
	public List<ApprGSignInfoVO> getAllSignInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGSignInfoVO>) list("EzApprovalG.getAllSignInfo", map);
	}
	
	/* 2023-12-05 홍승비 - 전자결재 > 서명 재맵핑 > 결재서명 전체를 재맵핑하기 위해, TBL_SIGNINFO에 '정상적인 서명 데이터'가 확정 삽입되는 시점 이후 기안된 문서인지 카운트하는 쿼리 */
	public int getSignRemapApplyDocCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalG.getSignRemapApplyDocCnt", map);
	}
	
	/* 2023-03-24 한태훈 - 전자결재G > 통합PC저장 다운로드(gubun 값 : D) 이력 남기기 (차후 다운로드 이력 외 다른 이력 삽입 가능) */
	public void insertTotalSaveHistory(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertTotalSaveHistory",map);
	}

	/* 2023-06-22 한태훈 - 전자결재G > 기록물등록대장, 완료문서조회 > 통합PC저장을 위해 선택된 모든 문서들의 결재문서, 첨부파일, 문서첨부파일 정보 리턴 */
	@SuppressWarnings("unchecked")
	public List<ApprGAttachInfoVO> getTotalDownloadAll(Map<String, Object> map) throws Exception {
		return (List<ApprGAttachInfoVO>) list("EzApprovalG.getTotalDownloadAll", map);
	}
	
	/* 2023-06-22 한태훈 - 전자결재G > 기록물등록대장, 완료문서조회 > 다중 문서 통합PC저장 시 선택된 모든 완료 문서의 모든 의견 정보 리턴 */
	@SuppressWarnings("unchecked")
	public List<ApprGOpinionVO> getDocsOpinionInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGOpinionVO>) list("EzApprovalG.getDocsOpinionInfo", map);
	}

	// 2024-06-07 전인하 - 기록물대장 > 하위부서 리스트 조회 
    public List<OrganDeptVO> getUnderDeptList(Map<String, Object> map) {
		return (List<OrganDeptVO>) list("EzApprovalGDAO.getUnderDeptList", map);
    }

	public String checkHasAttachFile(HashMap<String, String> map) throws Exception {
		return (String)select("EzApprovalGDAO.checkHasAttachFile", map);
	}

	public void insertAttachInfo(ApprGAttachInfoVO info) {
		insert("EzApprovalGDAO.insertAttachInfo", info);
	}
	
	public ApprGAttachInfoVO getAttachDocInfo(ApprGAttachInfoVO attachInfo) throws Exception {
		return (ApprGAttachInfoVO)select("EzApprovalGDAO.getAttachDocInfo", attachInfo);
	}

	public List<ApprGDocAttachInfoVO> getAttachedDocList(HashMap<String, String> map) throws Exception {
		return (List<ApprGDocAttachInfoVO>)list("EzApprovalGDAO.getAttachedDocList", map);
	}

	public void insertDocAttachInfo(ApprGDocAttachInfoVO vo) throws Exception {
		insert("EzApprovalGDAO.insertDocAttachInfo", vo);
	}

	/* 2024-06-18 양지혜 - 비전자문서의 분리첨부 유무 및 RECORDID 확인 */
	public String chkNonElecRec(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.chkNonElecRec", map);
	}

	/* 2024-06-24 양지혜 - 지정반송 > 반송위치에 표출할 결재라인 호출 */
	public List<ApprGAprLineVO> getReturnUserList(Map<String, Object> map) throws Exception {
		return (List<ApprGAprLineVO>) list("EzApprovalG.getReturnUserList", map);
	}

	/* 2024-06-24 양지혜 - 지정반송 > 결재라인 업데이트 */
	public void updateReturnByDesignation(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateReturnByDesignation", map);
	}

    // 2024-04-23 한태훈 > 결재 알림 발송 위한 결재 문서 정보 가져오기
	public ApprGDocListVO getDocInfoForNoti(Map<String, Object> map) throws Exception {
		return (ApprGDocListVO) select("EzApprovalG.getDocInfoForNoti", map);
	}

	// 2024-04-23 한태훈 > 결재 알림 발송 위한 유저 정보 가져오기
	public OrganUserVO getUserInfoForNoti(Map<String, Object> map) throws Exception {
		return (OrganUserVO) select("EzApprovalG.getUserInfoForNoti", map);
	}

	// 2024-04-23 한태훈 > 결재 알림 발송 위한 결재 순서 가져오기
	public ApprGDocListVO getAprMemberSnForNoti(Map<String, Object> map) throws Exception {
		return (ApprGDocListVO) select("EzApprovalG.getAprMemberSnForNoti", map);
	}

	// 2024-04-23 한태훈 > 결재 알림 발송 위한 수신 처리 정보 가져오기
	public ApprGSusinProcessInfoVO getSusinProcessInfo(Map<String, Object> map) throws Exception {
		return (ApprGSusinProcessInfoVO) select("EzApprovalG.getSusinProcessInfo", map);
	}

	// 2024-04-23 한태훈 > 결재 알림 발송 위한 공람 결재선 정보 가져오기
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> getGongramAprLineInfo(Map<String, Object> map) {
		return (List<ApprGAprLineVO>) list("EzApprovalG.getGongramAprLineInfo", map);
	}

    public int isExistDocAttach(Map<String, Object> map)  throws Exception {
        return (int) select("EzApprovalG.isExistDocAttach", map);
    }

    /* 2024-06-11 조소정 - 공람할문서 또는 공람완료문서 재사용 시 원문서 ID 가져오기 */
	public String getOrgDocIDfromGongram(Map<String, Object> map) {
		return (String) select("EzApprovalG.getOrgDocIDfromGongram", map);
	}

	/* 2023-05-16 임정은 - 전자결재G > 기록물등록대장 > 공람정보 > 중간순번 공람회수 시 delete */
	public void updateOtherGongRamExpAprLine(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateOtherGongRamExpAprLine", map);
	}

	public void updateOtherGongRamAprLineInfo(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateOtherGongRamAprLineInfo", map);
	}
	
	public void updateCreateDateOfOpenGovDocInfo(Map<String, Object> param) {
		update("EzApprovalG.updateCreateDateOfOpenGovDocInfo", param);
	}

	/* 2024-08-07 김유진 - 전자결재G > 기록물배부대장 > 배부문서 정보 가져오기 */
	@SuppressWarnings("unchecked")
	public List<ApprGDeliveryListVO> getDeliveryInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDeliveryListVO>) list("EzApprovalG.getDeliveryInfo", map);
	}
	/* 2024-08-07 김유진 - 전자결재G > 기록물배부대장 > 배부정보 가져오기 */
	@SuppressWarnings("unchecked")
	public List<ApprGDeliveryListVO> getDistributeInfo(Map<String, Object> map) throws Exception {
		return (List<ApprGDeliveryListVO>) list("EzApprovalG.getDistributeInfo", map);
	}
	/* 2024-08-07 김유진 - 전자결재G > tbl_distributeInfo 테이블의 parentDocID 값 가져오기 */
	public String getDistributeParentDocID(Map<String, Object> map) {
		return (String) select("EzApprovalG.getDistributeParentDocID", map);
	}
	/* 2024-08-07 김유진 - 전자결재G > 배부정보의 최대 SN 값 가져오기 */
	public String getDistributeInfoSN(Map<String, Object> map) {
		return (String) select("EzApprovalG.getDistributeInfoSN", map);
	}
	/* 2024-08-07 김유진 - 전자결재G > 배부정보 추가 */
	public void insertDistributeInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertDistributeInfo", map);
	}
	/* 2024-08-07 김유진 - 전자결재G > 배부정보 삭제 */
	public void deleteDistributeInfo(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteDistributeInfo", map);
	}
	
	/* 2024-12-18 한태훈 - 전자결재G > 열람권한 정보 가져오기 */
	public String getPublicityYN(Map<String, Object> map) {
		return (String) select("EzApprovalG.getPublicityYN", map);
	}

	public String getGongRamId(Map<String, Object> map){
		return (String) select("EzApprovalG.getGongRamId", map);
	}

	public void delAprMakeTmp2Ing12(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.delAprMakeTmp2Ing12", map);
	}

	public int checkAutoSaveDocId(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.checkAutoSaveDocId", map);
	}

	public void aprDeleteDocInfo15(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.aprDeleteDocInfo15", map);
	}

	public void aprDeleteDocInfo16(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.aprDeleteDocInfo16", map);
	}

	public void aprDeleteDocInfo17(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.aprDeleteDocInfo17", map);
	}

	public void deleteTbAprDocInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTbAprDocInfo", map);
	}
    
	/* 2024-11-25 기민혁 - 전자결재G > 최근서식 리스트 표출 */
	@SuppressWarnings("unchecked")
	public List<ApprGFormVO> getResendFormInfo(Map<String, Object> map) throws Exception{
		return (List<ApprGFormVO>) list("EzApprovalG.getResendFormInfo", map);
	}
	/* 2024-12-10 기민혁 - 전자결재 > 수정 버전 호출 */
	public String getEditVersion(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalG.getEditVersion", map);
	}

	/* 2024-12-25 기민혁 - 전자결재 > 일괄 지정 수신 문서 확인 */
	public ApprGReceiveDocVO checkDocReceiveInfo(Map<String, Object> map) throws Exception {
		return (ApprGReceiveDocVO) select("EzApprovalG.checkDocReceiveInfo", map);
	}
	
	public Map<String, String> getUpperDeptInfo(Map<String, Object> map) throws Exception {
		return (Map<String, String>) select("EzApprovalG.getUpperDeptInfo", map);
	}

	public List<String> getSameDeptBoxUseID(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzApprovalG.getSameDeptBoxUseID", map);
	}
	/* 2024-12-27 이가은 - 전자결재 > 공람완료문서 삭제기능 */
	public void insertGongramDeleteHistory(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.insertGongramDeleteHistory", map);
	}

    public ApprGSummaryVO getSummary(Map<String, Object> map) throws Exception {
		return (ApprGSummaryVO) select("EzApprovalG.getSummary", map);
    }

	public void saveSummary(ApprGSummaryVO summary) throws Exception {
		update("EzApprovalG.saveSummary", summary);
	}

	/*2025-01-20 강동주 - 전자결재 > 백단 결재 > 문서 핸들링 시 오류 발생하였을 때 insert */
	public void saveFailDocID(Map<String, Object> map) throws Exception {
		insert("EzApprovalG.saveFailDocID", map);
	}
	
	public Map<String, Object> getFailDocID(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) select("EzApprovalG.getFailDocID", map);
	}
	
	public void updateFailDocID(Map<String, Object> map) throws Exception {
		update("EzApprovalG.updateFailDocID", map);
	}
	
	public void deleteFailDocID(Map<String, Object> map) throws Exception {
		delete("EzApprovalG.deleteFailDocID", map);
	}
	public Map<String, Object> getDashBoardProGressDocCount(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) select("EzApprovalG.getDashBoardProGressDocCount", map);
	}
	
	public List<ApprGReceiveDocVO> getDashBoardDeptBox(Map<String, Object> map) throws Exception{
		return (List<ApprGReceiveDocVO>) list("EzApprovalG.getDashBoardDeptBox", map);
	}
	
	public List<ApprGDocListVO> getDashBoardDocList(Map<Object, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getDashBoardDocList", map);
	}
	
	public List<ApprGDocListVO> getDashBoardDoingLines(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("EzApprovalG.getDashBoardDoingLines", map);
	}
	
	public List<ApprGDocListVO> getDashBoardDoingLines2(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("EzApprovalG.getDashBoardDoingLines2", map);
	}

    public ApprGAprDocInfoVO getOrgDocWriterInfo(Map<String, Object> map) throws Exception {
        return (ApprGAprDocInfoVO) select("EzApprovalG.getOrgDocWriterInfo", map);
    }

    public ApprGDocListVO getApprovalDocInfo(Map<String, Object> map) throws Exception {
        return (ApprGDocListVO) select("EzApprovalG.getApprovalDocInfo", map);
    }

    public ApprGDocListVO getViewDocInfo(Map<String, Object> map) {
        return (ApprGDocListVO) select("EzApprovalG.getViewDocInfo", map);
    }

	public int getChkDocExist(Map<String, Object> map)  throws Exception {
		return (int) select("EzApprovalG.getChkDocExist", map);
	}

    public List<String> getChiefDept(String userID) {
        return (List<String>) list("EzApprovalG.getChiefDept", userID);
    }

    public String getDocDeptPath(Map<String, Object> map) {
        return (String) select("EzApprovalG.getDocDeptPath", map);
    }

	public int checkAccessFormCont(Map<String, Object> map)  throws Exception {
		return (int) select("EzApprovalG.checkAccessFormCont", map);
	}
}
