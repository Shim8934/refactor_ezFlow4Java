package egovframework.ezMobile.ezOrgan.service;

import java.util.List;

import egovframework.ezMobile.ezOrgan.vo.MOrganListVO;
import egovframework.ezMobile.ezOrgan.vo.MPersonListVO;

public interface MOrganService {
	public List<MPersonListVO> getPersonList(String companyID, int tenantID, String pSearchText, String rowNum) throws Exception;
	
	public MPersonListVO getPersonInfo(String userID, int tenantID) throws Exception;
	
	public int getPersonListCount(String companyID, int tenantID, String pSearchText) throws Exception;

	public List<MOrganListVO> getDeptInfo(String organType, String companyID, String deptId, String lang, int tenantId) throws Exception;

	public List<MOrganListVO> getDeptMemberList(String deptID, String searchFlag, String lang, int tenantId) throws Exception;

	public List<MOrganListVO> getLowDeptInfo(String deptID, String lang, int tenantId) throws Exception;

	public List<MOrganListVO> getHighDeptInfo(String deptID, String deptType, String lang, int tenantId) throws Exception;
}
