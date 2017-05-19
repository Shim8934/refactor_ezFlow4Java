package egovframework.ezEKP.ezCircular.service;

import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;

public interface EzCircularService {

	public CircularConfigVO getCircularList_Config(String memberId, int tenantId) throws Exception;
	
}
