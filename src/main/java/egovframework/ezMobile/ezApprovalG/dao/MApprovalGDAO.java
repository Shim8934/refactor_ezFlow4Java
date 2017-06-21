package egovframework.ezMobile.ezApprovalG.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAprLineInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGOpinionInfoVO;
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

	public void updateDocOpinionInfo(Map<String, Object> map) throws Exception {
		update("MApprovalG.updateDocOpinionInfo", map);
	}

}
