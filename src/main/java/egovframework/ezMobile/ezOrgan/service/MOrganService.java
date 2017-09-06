package egovframework.ezMobile.ezOrgan.service;

import java.util.List;
import java.util.Map;

import egovframework.ezMobile.ezOrgan.vo.MPersonListVO;

public interface MOrganService {
	List<MPersonListVO> getPersonList(String companyID, int tenantID, String pSearchText) throws Exception;
	
	MPersonListVO getPersonInfo(String userID, int tenantID) throws Exception;
	
	int getPersonListCount(String companyID, int tenantID, String pSearchText) throws Exception;
}
