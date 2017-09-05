package egovframework.ezMobile.ezOrgan.service;

import java.util.List;

import egovframework.ezMobile.ezOrgan.vo.MPersonListVO;

public interface MOrganService {
	List<MPersonListVO> getPersonList(String companyID, int tenantID, String pSearchText) throws Exception;
}
