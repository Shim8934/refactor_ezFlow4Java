package egovframework.ezEKP.ezCommon.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;

public interface EzCommonService {

	public String getContentInfo(String type, String itemID) throws Exception;
	
	public String wpCountLoginTime(String userID) throws Exception;
	
	public BoardAttachVO getAttachInfo(String type, String attID, String mode, int sn, String companyID)throws Exception;
	
	public void responseAttach(String pPhysicalFilePath, String pFileName, boolean pAttachment, HttpServletRequest request, HttpServletResponse response) throws Exception;


}
