package egovframework.ezEKP.ezApproval.service;

import java.util.List;

import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocInfoVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzApprovalAdminService {

	public List<ApprContInfoVO> getUseContInfo(ApprContInfoVO apprContInfoVO) throws Exception;

	public List<ApprDocInfoVO> getCodeContainer(LoginVO userInfo) throws Exception;

	public String getUserContTree(LoginVO userInfo, String parentContID) throws Exception;

	public String getListContainer(LoginVO userInfo) throws Exception;

	public String getDeptContTree(LoginVO userInfo, String parentContID) throws Exception;

	public List<ApprContInfoVO> getSpecialContTree(LoginVO userInfo) throws Exception;

	public String getDocType(String selected, LoginVO userInfo) throws Exception;

}
