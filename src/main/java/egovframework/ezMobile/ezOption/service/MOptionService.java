package egovframework.ezMobile.ezOption.service;

import egovframework.ezMobile.ezOption.vo.MCommonVO;

public interface MOptionService {

	public String saveOption(String id, String langFlag, String dpBoardCnt, String resourceChk, String resourceYN, int tenantId)  throws Exception;
	
	public MCommonVO commonInfo(String serverName, String userId) throws Exception;

}
