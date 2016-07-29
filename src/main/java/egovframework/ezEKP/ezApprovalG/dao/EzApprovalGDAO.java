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
import egovframework.ezEKP.ezApprovalG.vo.ApprGDeptTempletVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocAttachInfoVO;
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
		return (List<ApprGAprLineVO>) list("EzApprovalG.setBujeInfoList", map);
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
	public List<HashMap<String, Object>> getDocType(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzApprovalG.getDocType", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getLeftDocCount(Map<String, Object> map) throws Exception{
		return (List<String>) list("EzApprovalG.getLeftDocCount", map);
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
	
	public String aprGetNewID(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.aprGetNewID", map);
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
	
	public String deleteTmpDocInfo(Map<String, Object> map) throws Exception{
		select("EzApprovalG.deleteTmpDocInfo", map);
		return (String)map.get("v_PHREF");
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
	
	public String doBanSongAprType(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.doBanSongAprType", map);
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
	
	public String getFormConnFlag(Map<String, Object> map) throws Exception{
		return (String) select("EzApprovalG.getFormConnFlag", map);
	}
	
	public int getAprDocListCount(Map<String, Object> map) throws Exception{
		select("EzApprovalG.getAprDocListCount", map);
		return (int)map.get("v_pCount");
	}
	
	public int getWebPartListCount(Map<String, Object> map) throws Exception{
		select("EzApprovalG.getWebPartListCount", map);
		return (int)map.get("v_pCount");
	}

	public int getCountChildFormCont(Map<String, Object> map) throws Exception{
		select("EzApprovalG.getCountChildFormCont", map);
		return (int)map.get("v_pCount");
	}
	
	public int getLineTempletSN(Map<String, Object> map) throws Exception{
		select("EzApprovalG.getLineTempletSN", map);
		return (int)map.get("v_pCount");
	}
	
	public int getReceiptTempletSN(Map<String, Object> map) throws Exception{
		select("EzApprovalG.getReceiptTempletSN", map);
		return (int)map.get("v_pCount");
	}
	
	public int getRecordListCount(Map<String, Object> map) throws Exception{
		select("EzApprovalG.getRecordListCount", map);
		return (int)map.get("v_pCount");
	}
	
	public int updateHistoryForAttach_M(Map<String, Object> map) throws Exception{
		select("EzApprovalG.updateHistoryForAttach_M", map);
		return (int)map.get("v_pCount");
	}
	
	public int isCabCharger(Map<String, Object> map) throws Exception{
		select("EzApprovalG.isCabCharger", map);
		return (int)map.get("v_Result");
	}
	
	public int receiverChk(Map<String, Object> map) throws Exception{
		select("EzApprovalG.receiverChk", map);
		return (int)map.get("v_pCount");
	}
	
	public int doProcessCount(Map<String, Object> map) throws Exception{
		select("EzApprovalG.doProcessCount", map);
		return (int)map.get("v_pCount");
	}
	
	public int doApproveLineCnt(Map<String, Object> map1) throws Exception{
		select("EzApprovalG.doApproveLineCnt", map1);
		return (int)map1.get("v_pCount");
	}
	
	public int updateSignInfoAprSN(Map<String, Object> map) throws Exception{
		select("EzApprovalG.updateSignInfoAprSN", map);
		return (int)map.get("v_pCount");
	}
	
	public int getReceiptProcessInfoRec(Map<String, Object> map3) throws Exception{
		select("EzApprovalG.getReceiptProcessInfoRec", map3);
		return (int)map3.get("v_pCount");
	}
	
	public int doDocCompleteReceiptCnt(Map<String, Object> map) throws Exception{
		select("EzApprovalG.doDocCompleteReceiptCnt", map);
		return (int)map.get("v_pCount");
	}
	
	public int setLastOpinionToOrgDocOpinionSN(Map<String, Object> map1) throws Exception{
		select("EzApprovalG.setLastOpinionToOrgDocOpinionSN", map1);
		return (int)map1.get("v_pCount");
	}
	
	public int spGetSerialNo(Map<String, Object> map) throws Exception{
		select("EzApprovalG.spGetSerialNo", map);
		return (int)map.get("v_RtnSN");
	}
	
	public int getMaxTmpDocSN(Map<String, Object> map) throws Exception{
		select("EzApprovalG.getMaxTmpDocSN", map);
		return (int)map.get("v_pCount");
	}
	
	public int getOpinionCount(Map<String, Object> map) throws Exception{
		select("EzApprovalG.getOpinionCount", map);
		return (int)map.get("v_pCount");
	}
	
	public int getReceiveDocListCount(Map<String, Object> map) throws Exception{
		select("EzApprovalG.getReceiveDocListCount", map);
		return (int)map.get("v_pCount");
	}
	
	public int compareLineHistory(Map<String, Object> map) throws Exception{
		select("EzApprovalG.compareLineHistory", map);
		return (int)map.get("v_pCount");
	}
	
	public int updateDeliveryListCount(Map<String, Object> map) throws Exception{
		select("EzApprovalG.updateDeliveryListCount", map);
		return (int)map.get("v_pCount");
	}
	
	public int updateDeliveryListSNMax(Map<String, Object> map) throws Exception{
		select("EzApprovalG.updateDeliveryListSNMax", map);
		return (int)map.get("v_pCount");
	}
	
	public int getSearchDocListCount(Map<String, Object> map) throws Exception{
		select("EzApprovalG.getSearchDocListCount", map);
		return (int)map.get("v_pCount");
	}
	
	public int getContDocListCount(Map<String, Object> map) throws Exception{
		select("EzApprovalG.getContDocListCount", map);
		return (int)map.get("v_pCount");
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
	
	public void setUserFormInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.setUserFormInfo", map);
	}

	public void delUserFormInfo(Map<String, Object> map) throws Exception{
		update("EzApprovalG.delUserFormInfo", map);
	}
	
	public void createNewDoc(Map<String, Object> map) throws Exception{
		update("EzApprovalG.createNewDoc", map);
	}
	
	public void updateHistoryForAttach(Map<String, Object> map1) throws Exception{
		update("EzApprovalG.updateHistoryForAttach", map1);
	}
	
	public void saveRecReadHist(Map<String, Object> map) throws Exception{
		update("EzApprovalG.saveRecReadHist", map);
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
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> sendoffercheck_enddocinfo(Map<String, Object> map) throws Exception{
		return (List<ApprGDocListVO>) list("EzApprovalG.sendoffercheck_enddocinfo", map);
	}
}
