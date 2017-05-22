package egovframework.ezEKP.ezCircular.service;

import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;

public interface EzCircularService {

	public CircularConfigVO getCircularList_Config(String memberId, int tenantId) throws Exception;

	public void setCircularList_Config(CircularConfigVO circularConfigVO) throws Exception;
	
	public void setCircularList_Config2(String userID, String listCount, String previewMode, String list, String content, int tenantID) throws Exception;
	
	public String setCircularConfig(String userID, int listCount, String preView, int tenantID) throws Exception;
}
