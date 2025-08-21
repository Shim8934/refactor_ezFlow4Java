package egovframework.ezMobile.ezApprovalG.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.ezMobile.ezApprovalG.vo.*;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezOption.vo.MCommonVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MApprovalGDAO")
public class MApprovalGDAO extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<MApprovalGDocInfoVO> getDoApproveList(Map<String, Object> map) throws Exception {
		return (List<MApprovalGDocInfoVO>) list("MApprovalG.getDoApproveList", map);
	}

	public int getDoApproveListCount(Map<String, Object> map) throws Exception {
		return (int) select("MApprovalG.getDoApproveListCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<MApprovalGAprLineInfoVO> getAprLineInfo(Map<String, Object> map) throws Exception {
		return (List<MApprovalGAprLineInfoVO>) list("MApprovalG.getAprLineInfo", map);
	}

	public String getAprDocHref(Map<String, Object> map) throws Exception{
		return (String) select("MApprovalG.getAprDocHref", map);
	}

	public String getAprCommentCount(Map<String, Object> map) throws Exception {
		return (String) select("MApprovalG.getAprCommentCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<MApprovalGOpinionInfoVO> getOpinionInfo(Map<String, Object> map) throws Exception {
		return (List<MApprovalGOpinionInfoVO>) list("MApprovalG.getOpinionInfo", map);
	}

	// 2023-03-13 전인하 - 전자결재 > 모바일 의견 기능 개선 - 의견 수 카운트 조회 쿼리
	public int getOpinionCountInfo(Map<String, Object> map) throws Exception {
		return (int) select("MApprovalG.getOpinionCountInfo", map);
	}

	public void insertOpinionInfo(Map<String, Object> map) throws Exception {
		insert("MApprovalG.insertOpinionInfo", map);
	}

	public int updateDocOpinionInfo(Map<String, Object> map) throws Exception {
		return update("MApprovalG.updateDocOpinionInfo", map);
	}

	// 2023-03-13 전인하 - 전자결재 > 모바일 의견 기능 개선 - 의견 update 쿼리
	public int updateOpinionInfo(Map<String, Object> map) throws Exception {
		return update("MApprovalG.updateOpinionInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<MApprovalGAttachInfoVO> getAttachList(Map<String, Object> map) throws Exception {
		return (List<MApprovalGAttachInfoVO>) list("MApprovalG.getAttachList", map);
	}

	public int deleteOpinionInfo(Map<String, Object> map) throws Exception {
		return delete("MApprovalG.deleteOpinionInfo", map);
	}

	public String getAbsenteeInfo(MCommonVO userInfo) throws Exception {
		return (String) select("MApprovalG.getAbsenteeInfo", userInfo);
	}

	public int setAbsenteeInfo(MApprovalGAbsenteeInfoVO absenteeInfoVO) throws Exception {
		return update("MApprovalG.setAbsenteeInfo", absenteeInfoVO);
	}

	public int checkPass(Map<String, Object> map) throws Exception {
		return (int) select("MApprovalG.checkPass", map);
	}

	public MApprovalGDocInfoVO getAprDocInfo(Map<String, Object> map) throws Exception {
		return (MApprovalGDocInfoVO) select("MApprovalG.getAprDocInfo", map);
	}

	public MApprovalGDocInfoVO getAprMemberSn(Map<String, Object> map) throws Exception {
		return (MApprovalGDocInfoVO) select("MApprovalG.getAprMemberSn", map);
	}

	public String getDocState(Map<String, Object> map) throws Exception {
		return (String) select("MApprovalG.getDocState", map);
	}

	public MApprovalGLeftVO getLeftCount(Map<String, Object> map) throws Exception {
		return (MApprovalGLeftVO) select("MApprovalG.getLeftCount", map);
	}

	public int delAbsenteeInfo(Map<String, Object> map) throws Exception {
		return update("MApprovalG.delAbsenteeInfo", map);
	}

	public int getCheckAprState(Map<String, Object> map) throws Exception {
		return (int) select("MApprovalG.getCheckAprState", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MApprovalGReceiptInfoVO> getEndReceiptInfos(Map<String, Object> map) throws Exception {
		return (List<MApprovalGReceiptInfoVO>) list("mApprovalGDAO.getEndReceiptInfos", map);
	}

	@SuppressWarnings("unchecked")
	public List<MCommonVO> getReceiptInfosOfDept(Map<String, Object> map) throws Exception {
		return (List<MCommonVO>) list("mApprovalGDAO.getReceiptInfosOfDept", map);
	}

	@SuppressWarnings("unchecked")
	public List<MCommonVO> getReceiptInfosOfUser(Map<String, Object> map) throws Exception {
		return (List<MCommonVO>) list("mApprovalGDAO.getReceiptInfosOfUser", map);
	}
	
	public MApprovalGDocInfoVO getEndAprDocInfo(Map<String, Object> map) throws Exception {
		return (MApprovalGDocInfoVO) select("MApprovalG.getEndAprDocInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<MApprovalGAbsenteeAddJobInfoVO> getAbsenteeAddJobInfo(Map<String, Object> map) throws Exception {
		return (List<MApprovalGAbsenteeAddJobInfoVO>) list("MApprovalG.getAbsenteeAddJobInfo", map);
	}

	public int updateAbsenteeAddJobInfo(Map<String, Object> map) throws Exception {
		return update("MApprovalG.updateAbsenteeAddJobInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getLastDocInfo(Map<String, Object> map) throws Exception {
		return (HashMap<String, Object>) select("MApprovalG.getLastDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap> checkChangeDocInfo(Map<String, Object> map) throws Exception {
		return (List<HashMap>) list("MApprovalG.checkChangeDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getEndDocInfo(Map<String, Object> map) throws Exception {
		return (HashMap<String, Object>) select("MApprovalG.getEndDocInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getEndDocInfoEx(Map<String, Object> map) throws Exception {
		return (HashMap<String, Object>) select("MApprovalG.getEndDocInfoEx", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap> getEndDocLineInfo(Map<String, Object> map) throws Exception {
		return (List<HashMap>) list("MApprovalG.getEndDocLineInfo", map);
	}
	
	
	@SuppressWarnings("unchecked")
	public List<HashMap> getEndDocLineInfoEx(Map<String, Object> map) throws Exception {
		return (List<HashMap>) list("MApprovalG.getEndDocLineInfoEx", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap> getEndReceiptDocInfo(Map<String, Object> map) throws Exception {
		return (List<HashMap>) list("MApprovalG.getEndReceiptDocInfo", map);
	}
	
	public int updateDocInfo(Map<String, Object> map) throws Exception {
		return update("MApprovalG.updateDocInfo", map);
	}
	
	public int updateDocInfoEx(Map<String, Object> map) throws Exception {
		return update("MApprovalG.updateDocInfoEx", map);
	}
	
	public void insertDocLineInfo(Map<String, Object> map) throws Exception {
		insert("MApprovalG.insertDocLineInfo", map);
	}
	
	public void insertDocLineInfoEx(Map<String, Object> map) throws Exception {
		insert("MApprovalG.insertDocLineInfoEx", map);
	}
	
	public void insertDocRecvInfo(Map<String, Object> map) throws Exception {
		insert("MApprovalG.insertDocRecvInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap> informationSchemaColumns(Map<String, Object> map) throws Exception {
		return (List<HashMap>) list("MApprovalG.informationSchemaColumns", map);
	}

	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getFormInfo(Map<String, Object> map) throws Exception {
		return (HashMap<String, Object>) select("MApprovalG.formInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getUserInfo(Map<String, Object> map) throws Exception {
		return (HashMap<String, Object>) select("MApprovalG.getUserInfo", map);
	}
	
	public void saveAttachInfo(Map<String, Object> map) throws Exception {
		insert("MApprovalG.saveAttachInfo", map);
	}

	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getAprMemberBySn(Map<String, Object> map) throws Exception {
		return (HashMap<String, Object>) select("MApprovalG.getAprMemberBySn", map);
	}

	public int getIsAbsenteeInfo(Map<String, Object> map) throws Exception {
		return (int) select("MApprovalG.getIsAbsenteeInfo", map);
	}

	public int getAttachFileMaxSn(Map<String, Object> map) throws Exception {
		return (int) select("MApprovalG.getAttachFileMaxSn", map);
	}
	
}