package egovframework.ezMobile.ezOption.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.ezMobile.ezPortal.vo.MPortalTimeLineVO;

public interface MOptionService {

	public MCommonVO commonInfo(String serverName, String userId) throws Exception;
	
	public MOptionVO optionInfo(String userId, int tenantId) throws Exception;

	public void insertOption(String uid, String timeZone, String lang, String mainType, String listCnt, String useSecurity, int tenantId) throws Exception;

	public void updateOption(String userId, String timeZone, String lang, String mainType, String listCnt, String useSecurity, int tenantId, String deviceId, String pinState, String pin, String biometric,String pinChange) throws Exception;

	public List<MPortalTimeLineVO> getTimeLineList(MCommonVO info, String sessionDate, String listCnt, String approvalAccess, String boardAccess) throws Exception;

	public MCommonVO commonInfoWeb(String serverName, String userId) throws Exception;
	
	public String getDevicePinfInfo(String deviceId, String userId) throws Exception;

	public List<MenuInfoVO> getMobileMenuList(Map<String, Object> userInfoMap) throws Exception;
	
}
