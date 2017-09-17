package egovframework.ezMobile.ezApprovalG.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAbsenteeInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAprLineInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAttachInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGLeftVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGOpinionInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGTLVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

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

	public void insertOpinionInfo(Map<String, Object> map) throws Exception {
		insert("MApprovalG.insertOpinionInfo", map);
	}

	public int updateDocOpinionInfo(Map<String, Object> map) throws Exception {
		return update("MApprovalG.updateDocOpinionInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<MApprovalGTLVO> getTimeLineList(Map<String, Object> map) throws Exception {
		return (List<MApprovalGTLVO>) list("MApprovalG.getTimeLineList", map);
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

	public String getDocState(Map<String, Object> map) throws Exception {
		return (String) select("MApprovalG.getDocState", map);
	}

	public MApprovalGLeftVO getLeftCount(Map<String, Object> map) throws Exception {
		return (MApprovalGLeftVO) select("MApprovalG.getLeftCount", map);
	}

	public int delAbsenteeInfo(Map<String, Object> map) throws Exception {
		return update("MApprovalG.delAbsenteeInfo", map);
	}

}