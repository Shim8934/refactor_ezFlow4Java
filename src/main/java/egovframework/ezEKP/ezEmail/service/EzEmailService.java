package egovframework.ezEKP.ezEmail.service;

import java.util.List;

import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailPOP3VO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;

public interface EzEmailService {

	public List<MailGeneralVO> getMailGeneral(String userId) throws Exception;
	public void setMailGeneral(String userId, MailGeneralVO mailGeneral, String mode) throws Exception;
	public MailSignatureVO getMailSignature(String pUserID) throws Exception;
	public void setMailSignature(String pUserID, String pUseFlag, String pContent1, String pContent2, String pContent3) throws Exception;
	public MailColorVO getMailColor(int tenantId) throws Exception;
	public void setMailColor(int pTenantId, String pImportanceColor, String pInColor, String pOutColor) throws Exception;
	public List<MailDeleteVO> getMailDelete(String userId) throws Exception;
	public void setMailDelete(String pUserID, String pPath, int pExpireTime, int pDeleteUnread, String pFolderName) throws Exception;
	public void deleteMailDelete(String pUserID, String pFolderPath, int pItemSeq) throws Exception;
	public List<MailDeleteVO> getMailDeleteList() throws Exception;
	public List<MailReservationVO> getMailReserved(String pEmail) throws Exception;
	public List<MailReservationVO> getMailReserved2() throws Exception;
	public String setMailReserved(String pMessageId, String pSubject, String pSendDate, String pConnUrl, String isReserve) throws Exception;
	public void deleteMailReserved(String pMessageId) throws Exception;
	public String getMailReservedTime(String pMessageId) throws Exception;
	public List<MailReadVO> getMailReadList(String pUserId, String pMessageId, String pMessageId2) throws Exception;
	public List<MailCancelVO> getMailCancelList(String pMessage) throws Exception;
	public void setMailCancelSend(String pMessageId, String pUserEmail, String pSubject, String pCreateDate, String pLocalServerName, List<String> pInnerAddresses) throws Exception;
	public String getMailReceiveMessageId(String pNum) throws Exception;
	public void updateMailReceiveDetailInfo(String pNum, List<String[]> receiveDetailList) throws Exception;
	public List<String> getMailReceiveAddress(String pNum) throws Exception;
	public List<MailPOP3VO> getMailPOP3(String pUserId) throws Exception;
	public void savePop3(String pUserId, String pRet) throws Exception;
	public void setMailPOP3List(String pUserId, String pPop3Server, String pPop3UserId, List<String> pMessageIds, String pPop3DupMsg) throws Exception;
	public List<String> getMailPOP3List(String pUserId, String pPop3Server, String pPop3UserId) throws Exception;
	
}
