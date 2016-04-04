package egovframework.ezEKP.ezCommon.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface EzCommonService {

	public String getContentInfo(String type, String itemID) throws Exception;
	
	public void responseAttach(String pPhysicalFilePath, String pFileName, boolean pAttachment, HttpServletRequest request, HttpServletResponse response) throws Exception;

}
