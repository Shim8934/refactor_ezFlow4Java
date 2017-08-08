package egovframework.ezMobile.ezOption.service;

import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;

public interface MOptionService {

	public String saveOption(String id, String langFlag, String dpBoardCnt, String resourceChk, String resourceYN, int tenantId)  throws Exception;
		
	public MCommonVO commonInfo(String serverName, String userId) throws Exception;
	
	public MOptionVO optionInfo(String userId, int tenantId) throws Exception;

	public void insertOption(String uid, String timeZone, String lang, String mainType, String listCnt, String useSearch, String useSecurity, int tenantId) throws Exception;

	public void updateOption(String userId, String timeZone, String lang, String mainType, String listCnt, String useSearch, String useSecurity, int tenantId) throws Exception;
	
}
