package egovframework.ezEKP.ezApproval.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezApproval.vo.ApprCodeVO;
import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocInfoVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository
public class EzApprovalAdminDAO extends EgovAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getUserContInfo(ApprContInfoVO apprContInfoVO) throws Exception{
		return (List<ApprContInfoVO>) list("EzApprovalAdminDAO.getUserContInfo", apprContInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getUserContInfo1(ApprContInfoVO apprContInfoVO) throws Exception{
		return (List<ApprContInfoVO>) list("EzApprovalAdminDAO.getUserContInfo1", apprContInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprDocInfoVO> getCodeContainer(LoginVO userInfo) throws Exception{
		return (List<ApprDocInfoVO>) list("EzApprovalAdminDAO.getCodeContainer", userInfo);
	}

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getUserContTree(Map<String, Object> map) throws Exception{
		return (List<ApprContInfoVO>) list("EzApprovalAdminDAO.getUserContTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getDeptContTree(Map<String, Object> map) throws Exception{
		return (List<ApprContInfoVO>) list("EzApprovalAdminDAO.getDeptContTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getListContainerCont(Map<String, Object> map) throws Exception{
		return (List<String>) list("EzApprovalAdminDAO.getListContainerCont", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getListContainer(Map<String, Object> map) throws Exception{
		return (List<String>) list("EzApprovalAdminDAO.getListContainer", map);
	}
	
	public String getCode2Name(ApprCodeVO apprCodeVO) throws Exception{
		return (String) select("EzApprovalAdminDAO.getCode2Name", apprCodeVO);
	}

	public int getUserContTreeLeaf(ApprContInfoVO apprContInfoVO) throws Exception{
		return (int) select("EzApprovalAdminDAO.getUserContTreeLeaf", apprContInfoVO);
	}

	public String createUserCont(ApprContInfoVO apprContInfoVO) throws Exception{
		return (String) insert("EzApprovalAdminDAO.createUserCont", apprContInfoVO);
	}

	public int getDeptContTreeLeaf(ApprContInfoVO apprContInfoVO) throws Exception{
		return (int) select("EzApprovalAdminDAO.getDeptContTreeLeaf", apprContInfoVO);
	}

	public String createDeptCont(ApprContInfoVO apprContInfoVO) throws Exception{
		return (String) insert("EzApprovalAdminDAO.createDeptCont", apprContInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<ApprContInfoVO> getSpecialContTree(LoginVO userInfo) throws Exception{
		return (List<ApprContInfoVO>) list("EzApprovalAdminDAO.getSpecialContTree", userInfo);
	}

	@SuppressWarnings("unchecked")
	public List<ApprCodeVO> getDocType(int tenantID) throws Exception{
		return (List<ApprCodeVO>) list("EzApprovalAdminDAO.getDocType", tenantID);
	}


}
