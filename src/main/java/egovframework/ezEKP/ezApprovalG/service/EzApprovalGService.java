package egovframework.ezEKP.ezApprovalG.service;

import java.util.List;

import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzApprovalGService {

	public List<ApprGLeftVO> getUseContInfo(LoginVO userInfo, String ownFlag) throws Exception;

	public String getOptionInfo(String code1, String code2, LoginVO userInfo, String mode) throws Exception;

}
