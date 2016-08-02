package egovframework.ezEKP.ezPersonal.service;

import java.util.List;

import egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO;

public interface EzPersonalService {
	public List<PersonalGetSliderListVO> getSilderList(String companyID, String mode, String sliderID) throws Exception;

	public String setApprovalPwd(String userID, String flag, String newPWD, String pwdType) throws Exception;
}
