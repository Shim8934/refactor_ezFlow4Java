package egovframework.ezEKP.ezApproval.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocViewVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository
public class EzApprovalDAO extends EgovAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getUserContInfo(ApprContInfoVO apprContInfoVO) throws Exception {
		return (List<ApprContInfoVO>) list("EzApprovalDAO.getUserContInfo", apprContInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getUserContInfo1(ApprContInfoVO apprContInfoVO) throws Exception {
		return (List<ApprContInfoVO>) list("EzApprovalDAO.getUserContInfo1", apprContInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprDocInfoVO> getCodeContainer(LoginVO userInfo) throws Exception {
		return (List<ApprDocInfoVO>) list("EzApprovalDAO.getCodeContainer", userInfo);
	}

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getUserContTree(Map<String, Object> map) throws Exception {
		return (List<ApprContInfoVO>) list("EzApprovalDAO.getUserContTree", map);
	}

	public String createUserCont(ApprContInfoVO apprContInfoVO) throws Exception {
		return (String) insert("EzApprovalDAO.createUserCont", apprContInfoVO);
	}

	public int getUserContTreeLeaf(ApprContInfoVO apprContInfoVO) throws Exception {
		return (int) select("EzApprovalDAO.getUserContTreeLeaf", apprContInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getDeptContTree(Map<String, Object> map) throws Exception {
		return (List<ApprContInfoVO>) list("EzApprovalDAO.getDeptContTree", map);
	}

	public String createDeptCont(ApprContInfoVO apprContInfoVO) throws Exception {
		return (String) insert("EzApprovalDAO.createDeptCont", apprContInfoVO);
	}

	public int getDeptContTreeLeaf(ApprContInfoVO apprContInfoVO) throws Exception {
		return (int) select("EzApprovalDAO.getDeptContTreeLeaf", apprContInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getSpecialContTree(LoginVO userInfo) throws Exception {
		return (List<ApprContInfoVO>) list("EzApprovalDAO.getSpecialContTree", userInfo);
	}

	@SuppressWarnings("unchecked")
	public List<String> getListContainerCont(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzApprovalDAO.getListContainerCont", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getListContainer(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzApprovalDAO.getListContainer", map);
	}

	public String getIsUse(Map<String, Object> map) throws Exception {
		return (String) select("EzApprovalDAO.getIsUse", map);
	}

	public int getAprDocCount(Map<String, Object> map) throws Exception {
		return (int) select("EzApprovalDAO.getAprDocCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getLeftDocCount(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzApprovalDAO.getLeftDocCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprDocViewVO> getWebPartList(Map<String, Object> map) throws Exception {
		return (List<ApprDocViewVO>) list("EzApprovalDAO.getWebPartList", map);
	}

}
