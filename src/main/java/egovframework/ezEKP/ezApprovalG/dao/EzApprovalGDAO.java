package egovframework.ezEKP.ezApprovalG.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezApprovalG.vo.ApprGAdminReceiveVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGCabCodeVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGCabinetVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDeptTempletVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLineTempletVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpinionVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiptVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGRecordVO;
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
	
	public void transactionSQL(Map<String, Object> map) throws Exception{
		insert("EzApprovalG.transactionSQL", map);
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

}
