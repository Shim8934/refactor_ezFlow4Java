package egovframework.ezEKP.ezEmail.service;

import java.util.List;
import java.util.Map;

import javax.mail.internet.InternetAddress;

import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailPOP3VO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzEmailService {

	public List<MailGeneralVO> getMailGeneral(int tenantId, String userId) throws Exception;
	public void setMailGeneral(int tenantId, String userId, MailGeneralVO mailGeneral, String mode) throws Exception;
	public MailSignatureVO getMailSignature(int tenantId, String pUserID) throws Exception;
	public void setMailSignature(int tenantId, String pUserID, String pUseFlag, String pContent1, String pContent2, String pContent3) throws Exception;
	public MailColorVO getMailColor(int tenantId) throws Exception;
	public void setMailColor(int pTenantId, String pImportanceColor, String pInColor, String pOutColor) throws Exception;
	public List<MailDeleteVO> getMailDelete(int tenantId, String userId) throws Exception;
	public void setMailDelete(int tenantId, String pUserID, String pPath, int pExpireTime, int pDeleteUnread, String pFolderName) throws Exception;
	public void deleteMailDelete(int tenantId, String pUserID, String pFolderPath) throws Exception;
	public List<MailDeleteVO> getMailDeleteList() throws Exception;
	public List<MailReservationVO> getMailReserved(int tenantId, String pUserId) throws Exception;
	public List<MailReservationVO> getMailReserved2() throws Exception;
	public String setMailReserved(int tenantId, String pMessageId, String pSubject, String pSendDate, String pUserId, String isReserve) throws Exception;
	public void deleteMailReserved(String pMessageId) throws Exception;
	public String getMailReservedTime(String pMessageId) throws Exception;
	public List<MailReadVO> getMailReadList(int tenantId, String pUserId, String pMessageId) throws Exception;
	public List<MailCancelVO> getMailCancelList(String pMessage) throws Exception;
	public void setMailCancelSend(int tenantId, String pMessageId, String pUserId, String pSubject, String pLocalServerName, List<String> pInnerAddresses) throws Exception;
	public String getMailReceiveMessageId(String pNum) throws Exception;
	public void updateMailReceiveDetailInfo(String pNum, List<String[]> receiveDetailList) throws Exception;
	public List<String> getMailReceiveAddress(String pNum) throws Exception;
	public List<MailPOP3VO> getMailPOP3(int tenantId, String pUserId) throws Exception;
	public void savePop3(int tenantId, String pUserId, String pRet) throws Exception;
	public void setMailPOP3List(int tenantId, String pUserId, String pPop3Server, String pPop3UserId, List<String> pMessageIds) throws Exception;
	public List<String> getMailPOP3List(int tenantId, String pUserId, String pPop3Server, String pPop3UserId) throws Exception;
	public List<String> getIndividualAlias(String userAccount) throws Exception;
	public String setIndividualAlias(String userId, int tenantID, String primaryMail, List<String> individualAliasList) throws Exception;
	public String checkIndividualAlias(String individualAlias) throws Exception;
	public Map<String, String> getIndividualAliasMap(List<String> addressList, int tenantId) throws Exception;
	public void sendMail(String loginCookie, InternetAddress from, InternetAddress[] toArr, InternetAddress[] ccArr, InternetAddress[] bccArr, String subject, String content, boolean isSaved) throws Exception;
	public String mailContentDownload(String loginCookie, String url, String realPath) throws Exception;
	public boolean checkMailQuota(LoginVO userInfo, String password) throws Exception;
}
