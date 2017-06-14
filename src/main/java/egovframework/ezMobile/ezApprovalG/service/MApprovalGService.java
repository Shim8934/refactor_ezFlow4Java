package egovframework.ezMobile.ezApprovalG.service;

import java.util.List;

import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.let.user.login.vo.LoginVO;

public interface MApprovalGService {

	public List<MApprovalGDocInfoVO> getDoApproveList(LoginVO userInfo, String listType) throws Exception;

}
