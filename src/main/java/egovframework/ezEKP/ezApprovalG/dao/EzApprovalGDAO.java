package egovframework.ezEKP.ezApprovalG.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezApprovalG.vo.ApprGAdminReceiveVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprDocInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGCabCodeVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGCabinetRecVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGCabinetVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDeliveryListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDeptTempletVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocInfoWebSrvVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGHistoryAttachVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGHistoryDocVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGHistoryLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLineTempletVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpinionVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiptVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiveDocVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGRecordVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSecondApprVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSignInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGWebPartVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGgetDeptStacticsVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzApprovalGDAO")
public class EzApprovalGDAO extends EgovAbstractDAO{

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
	public List<ApprGDocListVO> getAprDocList(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getAprDocList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getAprPortletDocList(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.getAprPortletDocList", map);
	}
	
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
	
	@SuppressWarnings("unchecked")
	public List<ApprGWebPartVO> getWebPartList(Map<String, Object> map) throws Exception{
		return (List<ApprGWebPartVO>) list("EzApprovalG.getWebPartList", map);
	}
	
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
	public List<ApprGRecordVO> getRecordList(Map<String, Object> map) throws Exception{
		return (List<ApprGRecordVO>) list("EzApprovalG.getRecordList", map);
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
	public List<ApprGDocListVO> doSendDocAprDocInfo(Map<String, Object> map1) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.doSendDocAprDocInfo", map1);
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
	
	@SuppressWarnings("unchecked")
	public List<ApprGgetDeptStacticsVO> getDeptStactics(Map<String, Object> map) throws Exception{
		return (List<ApprGgetDeptStacticsVO>) list("EzApprovalG.getDeptStactics", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGAprLineVO> getDocAprLine(Map<String, Object> map) throws Exception{
		return (List<ApprGAprLineVO>) list("EzApprovalG.getDocAprLine", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getDocType(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzApprovalG.getDocType", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getLeftDocCount(Map<String, Object> map) throws Exception{
		return (List<String>) list("EzApprovalG.getLeftDocCount", map);
	}
	
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
		// TODO Auto-generated method stub
		return (List<ApprGRecordVO>) list("EzApprovalG.getRecordInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGRecordVO> getRecViewer(Map<String, Object> map) throws Exception{
		return (List<ApprGRecordVO>) list("EzApprovalG.getRecViewer", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGHistoryDocVO> getRecReadHistory(Map<String, Object> map) throws Exception{
		// TODO Auto-generated method stub
		return (List<ApprGHistoryDocVO>) list("EzApprovalG.getRecReadHistory", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGCabinetVO> getRecordClassInfo(Map<String, Object> map) throws Exception{
		// TODO Auto-generated method stub
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
	public List<ApprGCabinetVO> getCabinetList(Map<String, Object> map) throws Exception{
		return (List<ApprGCabinetVO>) list("EzApprovalG.getCabinetList", map);
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
		return (ApprGLineTempletVO) list("EzApprovalG.gongRamActivateLineInfo", map);
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
	
	public String doApproveDocState(Map<String, Object> map1) throws Exception{
		return (String) select("EzApprovalG.doApproveDocState", map1);
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
	
	public String returnContainerID2(Map<String, Object> map) {
		return (String) select("EzApprovalG.returnContainerID2", map);
	}
	
	public String returnContainerID3(Map<String, Object> map) {
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
	
	public String updateSusinResultReceipt(Map<String, Object> map) {
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
	
	public String getPublicCodeString(Map<String, Object> map)throws Exception{
		return (String)select("EzApprovalG.getPublicCodeString", map);
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
	
	public String chkDocDeleteTemp(Map<String, Object> map) {
		return (String) select("EzApprovalG.chkDocDeleteTemp", map);
	}
	
	public String selectHrefDocInfo(Map<String, Object> map) {
		return (String) select("EzApprovalG.selectHrefDocInfo", map);
	}
	
	public String selectTbSpecialCatalogInfo(Map<String, Object> map) {
		return (String) select("EzApprovalG.selectTbSpecialCatalogInfo", map);
	}
	
	public String getUserRecRight(Map<String, Object> map) throws Exception{
		return (String)select("EzApprovalG.getUserRecRight", map);
	}
	
	public String getUserRecRightCount(Map<String, Object> map) {
		return (String) select("EzApprovalG.getUserRecRightCount", map);
	}
	
	public String getUserRecRightCount2(Map<String, Object> map) {
		return (String) select("EzApprovalG.getUserRecRightCount2", map);
	}
	
	public String selectCodeValue(Map<String, Object> map) {
		return (String) select("EzApprovalG.selectCodeValue", map);
	}
	
	public String selectGongRamDocID(Map<String, Object> map) {
		return (String) select("EzApprovalG.selectGongRamDocID", map);
	}
	
	public int selectDoCallBack(Map<String, Object> map) {
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
	
	public int getRecordListCount(Map<String, Object> map1) throws Exception{
		return (int)select("EzApprovalG.getRecordListCount", map1);
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
	
	public int spGetSerialNo(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.spGetSerialNo", map);
	}
	
	public int getMaxTmpDocSN(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getMaxTmpDocSN", map);
	}
	
	public int getOpinionCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getOpinionCount", map);
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
	
	public int getAprPortletDocCount(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.getAprPortletDocCount", map);
	}
	
	public int getDeliveryListCount(Map<String, Object> map) throws Exception{
		return (int)select("EzApprovalG.getDeliveryListCount", map);
	}

	public int getCabinetListCount(Map<String, Object> map1) throws Exception{
		select("EzApprovalG.getCabinetListCount", map1);
		return (int)map1.get("v_pCount");
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
	
	public int countAttachDocInfo(Map<String, Object> map) {
		return (int) select("EzApprovalG.countAttachDocInfo", map);
	}
	
	public int getTotalAttachSizeTemp(Map<String, Object> map) {
		return (int) select("EzApprovalG.getTotalAttachSizeTemp", map);
	}
	
	public int newRecordVersion(Map<String, Object> map) {
		return (int) select("EzApprovalG.newRecordVersion", map);
	}
	
	public int transferCabinet(Map<String, Object> map) throws Exception{
		return (int) select("EzApprovalG.transferCabinet", map);
	}
	
	public int transferCabinetSn(Map<String, Object> map) {
		return (int) select("EzApprovalG.transferCabinetSn", map);
	}
	
	public int transferCabinetType2(Map<String, Object> map) {
		return (int) select("EzApprovalG.transferCabinetType2", map);
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
	
	public void aprMakeTmp2Ing2(Map<String, Object> map) {
		insert("EzApprovalG.aprMakeTmp2Ing2", map);
	}
	
	public void aprMakeTmp2Ing3(Map<String, Object> map) {
		insert("EzApprovalG.aprMakeTmp2Ing3", map);
	}
	
	public void aprMakeTmp2Ing4(Map<String, Object> map) {
		insert("EzApprovalG.aprMakeTmp2Ing4", map);
	}
	
	public void aprMakeTmp2Ing5(Map<String, Object> map) {
		insert("EzApprovalG.aprMakeTmp2Ing5", map);
	}
	
	public void aprMakeTmp2Ing6(Map<String, Object> map) {
		insert("EzApprovalG.aprMakeTmp2Ing6", map);
	}
	
	public void aprMakeTmp2Ing7(Map<String, Object> map) {
		insert("EzApprovalG.aprMakeTmp2Ing7", map);
	}
	
	public void aprMakeTmp2Ing8(Map<String, Object> map) {
		insert("EzApprovalG.aprMakeTmp2Ing8", map);
	}
	
	public void setUserFormInfo(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.setUserFormInfo", map);
	}
	
	public void createNewDoc(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.createNewDoc", map);
	}
	
	public void createNewDoc2(Map<String, Object> map) {
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
	
	public void insertTbSerialNumGen(Map<String, Object> map) {
		insert("EzApprovalG.insertTbSerialNumGen", map);
	}
	
	public void insertTbCabinetClass(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.insertTbCabinetClass", map);
	}
	
	public void insertTbSpecialCatalogInfo(Map<String, Object> map) {
		insert("EzApprovalG.insertTbSpecialCatalogInfo", map);
	}
	
	public void insertTbSpecialCatalogInfo2(Map<String, Object> map) {
		insert("EzApprovalG.insertTbSpecialCatalogInfo2", map);
	}
	
	public void insertTbOldCabinetExtraInfo(Map<String, Object> map) {
		insert("EzApprovalG.insertTbOldCabinetExtraInfo", map);
	}
	
	public void insertTbCabinetInfo(Map<String, Object> map) {
		insert("EzApprovalG.insertTbCabinetInfo", map);
	}
	
	public void insertTbAprAttachInfo(Map<String, Object> map) {
		insert("EzApprovalG.insertTbAprAttachInfo", map);
	}
	
	public void insertTbAprDocAttachInfo(Map<String, Object> map) {
		insert("EzApprovalG.insertTbAprDocAttachInfo", map);
	}
	
	public void insertTbAprLineInfo(Map<String, Object> map) {
		insert("EzApprovalG.insertTbAprLineInfo", map);
	}
	
	public void insertTbExpAprLine(Map<String, Object> map) {
		insert("EzApprovalG.insertTbExpAprLine", map);
	}
	
	public void insertReceiptInfo(Map<String, Object> map) {
		insert("EzApprovalG.insertReceiptInfo", map);
	}
	
	public void trigerTbCabinet(Map<String, Object> map1) {
		insert("EzApprovalG.trigerTbCabinet", map1);
	}
	
	public void trigerTbCabRoleInfo(Map<String, Object> map1) {
		insert("EzApprovalG.trigerTbCabRoleInfo", map1);
	}
	
	public void insertTbCabinetHistory(Map<String, Object> map) {
		insert("EzApprovalG.insertTbCabinetHistory", map);
	}
	
	public void insertSignInfoAprSN(Map<String, Object> map1) {
		insert("EzApprovalG.insertSignInfoAprSN", map1);
	}
	
	public void insertTbSpecialCatalogInfo_Cab(Map<String, Object> map) {
		insert("EzApprovalG.insertTbSpecialCatalogInfo_Cab", map);
	}
	
	public void insertTbSpecialCatalogInfo_Cab2(Map<String, Object> map) {
		insert("EzApprovalG.insertTbSpecialCatalogInfo_Cab2", map);
	}
	
	public void insertTbAprReceiptProcessInfo(Map<String, Object> map1) {
		insert("EzApprovalG.insertTbAprReceiptProcessInfo", map1);
	}
	
	public void insertTbContainer(Map<String, Object> map) {
		insert("EzApprovalG.insertTbContainer", map);
	}
	
	public void jiJungInsertReceiptProInfo(Map<String, Object> map) {
		insert("EzApprovalG.jiJungInsertReceiptProInfo", map);
	}
	
	public void setMyTaskCode(Map<String, Object> map) throws Exception{
		update("EzApprovalG.setMytaskCode", map);
	}
	
	public void updateDocInfoDocTitle(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateDocInfoDocTitle", map);
	}
	
	public void updateHistoryForLine(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateHistoryForLine", map);
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
		 update("EzApprovalG.aprGetNewID", map);
	}
	
	public void updateSerialNo(Map<String, Object> map) {
		update("EzApprovalG.updateSerialNo", map);
	}
	
	public void updateOpinionInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.updateOpinionInfo", map);
	}
	
	public void updateAttachFileInfo(Map<String, Object> map) {
		update("EzApprovalG.updateAttachFileInfo", map);
	}
	
	public void updateAttachDocInfo(Map<String, Object> map) {
		update("EzApprovalG.updateAttachDocInfo", map);
	}

	public void changeRecordInfo2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.changeRecordInfo2", map);
	}
	
	public void updateTbSerialNumGen(Map<String, Object> map) {
		update("EzApprovalG.updateTbSerialNumGen", map);
	}

	public void updateExistUnit(Map<String, Object> map) {
		update("EzApprovalG.updateExistUnit", map);
	}
	
	public void updateTbCabinetInfo2(Map<String, Object> map) {
		update("EzApprovalG.updateTbCabinetInfo2", map);
	}
	
	public void updateTbCabinetInfo3(Map<String, Object> map) {
		update("EzApprovalG.updateTbCabinetInfo3", map);
	}
	
	public void updateTbCabinetClass(Map<String, Object> map) {
		update("EzApprovalG.updateTbCabinetClass", map);
	}
	
	public void updateTbSeperateAttach(Map<String, Object> map) {
		update("EzApprovalG.updateTbSeperateAttach", map);
	}
	
	public void updateTbAprReceiptProcessInfo(Map<String, Object> map1) {
		update("EzApprovalG.updateTbAprReceiptProcessInfo", map1);
	}
	
	public void jiJungUpdateReceiptProInfo(Map<String, Object> map) {
		update("EzApprovalG.jiJungUpdateReceiptProInfo", map);
	}
	
	public void jiJungUpdateReceiptProInfo2(Map<String, Object> map) {
		update("EzApprovalG.jiJungUpdateReceiptProInfo2", map);
	}
	
	public void jiJungUpdateReceiptProInfo3(Map<String, Object> map) {
		update("EzApprovalG.jiJungUpdateReceiptProInfo3", map);
	}
	
	public void jiJungUpdateReceiptProInfo4(Map<String, Object> map) {
		update("EzApprovalG.jiJungUpdateReceiptProInfo4", map);
	}
	
	public void doResendEndDoc2(Map<String, Object> map) throws Exception{
		update("EzApprovalG.doResendEndDoc2", map);
	}
	
	public void updateTbCabinetInfo(Map<String, Object> map) {
		update("EzApprovalG.updateTbCabinetInfo", map);
	}
	
	public void jiJungUpdateTbDocDelivery(Map<String, Object> map) {
		update("EzApprovalG.jiJungUpdateTbDocDelivery", map);
	}
	
	public void updateDoCallBack(Map<String, Object> map) {
		update("EzApprovalG.updateDoCallBack", map);
	}
	
	public void updateDoCallBack2(Map<String, Object> map) {
		update("EzApprovalG.updateDoCallBack2", map);
	}
	
	public void updateDoCallBack3(Map<String, Object> map) {
		update("EzApprovalG.updateDoCallBack3", map);
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
	
	public void deleteReceiptTempletDetailInfo2(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteReceiptTempletDetailInfo2", map);
	}
	
	public void deleteLineTempletDetailInfo2(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteLineTempletDetailInfo2", map);
	}
	
	public void deleteSerialNo(Map<String, Object> map) {
		delete("EzApprovalG.deleteSerialNo", map);
	}
	
	public void deleteTmpDocInfo(Map<String, Object> map) throws Exception{
		delete("EzApprovalG.deleteTmpDocInfo", map);
	}
	
	public void deleteTbAprAttachInfo(Map<String, Object> map) {
		delete("EzApprovalG.deleteTbAprAttachInfo", map);
	}
	
	public void deleteTbAprDocAttachInfo(Map<String, Object> map) {
		delete("EzApprovalG.deleteTbAprDocAttachInfo", map);
	}

	public void deleteTbAprLineInfo(Map<String, Object> map) {
		delete("EzApprovalG.deleteTbAprLineInfo", map);
	}
	
	public void deleteTbExpAprLine(Map<String, Object> map) {
		delete("EzApprovalG.deleteTbExpAprLine", map);
	}
	
	public void jiJungDeleteReceiptProInfo(Map<String, Object> map) {
		delete("EzApprovalG.jiJungDeleteReceiptProInfo", map);
	}
	
	public void jiJungDeleteReceiptProInfo2(Map<String, Object> map) {
		delete("EzApprovalG.jiJungDeleteReceiptProInfo2", map);
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
	public List<ApprGCabinetVO> selectCabinetTransfer(Map<String, Object> map) {
		return (List<ApprGCabinetVO>) list("EzApprovalG.selectCabinetTransfer", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGCabinetVO> selectTbSeperateAttach(Map<String, Object> map) {
		return (List<ApprGCabinetVO>) list("EzApprovalG.selectTbSeperateAttach", map);
	}
}
