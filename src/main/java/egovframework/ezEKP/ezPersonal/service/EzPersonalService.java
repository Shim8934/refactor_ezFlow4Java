package egovframework.ezEKP.ezPersonal.service;

import java.util.List;

import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO;

public interface EzPersonalService {
	public List<PersonalGetSliderListVO> getSilderList(String companyID, String mode, String sliderID) throws Exception;
	
	public PersonalGetEmpOfMonthVO getEmpOfMonth (String pTerm) throws Exception;

	public String setApprovalPwd(String userID, String flag, String newPWD, String pwdType) throws Exception;

	public String getApprovNotiConfig(String userID) throws Exception;

	public String setApprovNotiMail(String userID, String alert, String complete, String bansong, String callBack, String hesong, String saveMailFlag) throws Exception;
}
