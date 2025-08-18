package egovframework.ezEKP.ezEmail.service;

import java.io.InputStream;
import java.io.File;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.vo.MailboxProgressVO;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import egovframework.ezEKP.ezEmail.util.EmailImportance;
import egovframework.ezEKP.ezEmail.vo.MailBlobVO;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailDeletedIdVO;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailPOP3VO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezEmail.vo.MailSecureReaderVO;
import egovframework.ezEKP.ezEmail.vo.MailSecureVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxUserVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureTemplateVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzEmailService {

	public List<MailGeneralVO> getMailGeneral(int tenantId, String userId) throws Exception;
	public void setMailGeneral(int tenantId, String userId, MailGeneralVO mailGeneral, String mode, String inMailBox) throws Exception;
	public MailSignatureVO getMailSignature(int tenantId, String pUserID) throws Exception;
	public void setMailSignature(int tenantId, String pUserID, String pUseFlag, String pContent1, String pContent2, String pContent3) throws Exception;
	public MailColorVO getMailColor(int tenantId) throws Exception;
	public void setMailColor(int pTenantId, String pImportanceColor, String pInColor, String pOutColor) throws Exception;
	public List<MailDeleteVO> getMailDelete(int tenantId, String userId) throws Exception;
	public void setMailDelete(int tenantId, String pUserID, String pPath, int pExpireTime, int pDeleteUnread, String pFolderName, String pAutoDeletionOption) throws Exception;
	public void deleteMailDelete(int tenantId, String pUserID, String pFolderPath) throws Exception;
	public List<MailBlobVO> getOrphanedMailBlobList() throws Exception;
	public List<MailDeletedIdVO> getMailDeletedIdList() throws Exception;
	public List<MailDeleteVO> getMailDeleteList() throws Exception;
	public List<MailReservationVO> getMailReserved(int tenantId, String pUserId) throws Exception;
	public List<MailReservationVO> getMailReserved2() throws Exception;
	public String setMailReserved(int tenantId, String pMessageId, String pSubject, String pSendDate, String mailId, String sender, String isReserve) throws Exception;
	public void deleteMailReserved(String pMessageId) throws Exception;
	public String getMailReservedTime(String pMessageId) throws Exception;
	public List<MailReadVO> getMailReadList(int tenantId, String pUserId, String pMessageId) throws Exception;
	public List<MailCancelVO> getMailCancelList(String pMessage) throws Exception;
	public String getMailReceiveMessageId(String pNum) throws Exception;
	public void updateMailReceiveDetailInfo(String pNum, String[] receiveDetail) throws Exception;
	public List<String> getMailReceiveAddress(String pNum) throws Exception;
	public List<MailPOP3VO> getMailPOP3(int tenantId, String pUserId) throws Exception;
	public void savePop3(int tenantId, String pUserId, String pRet) throws Exception;
	public void setMailPOP3List(int tenantId, String pUserId, String pPop3Server, String pPop3UserId, List<String> pMessageIds) throws Exception;
	public List<String> getMailPOP3List(int tenantId, String pUserId, String pPop3Server, String pPop3UserId) throws Exception;
	public String setIndividualAlias(String userId, int tenantID, String primaryMail, List<String> individualAliasList) throws Exception;
	public String setIndividualAlias(String userId, int tenantID, String primaryMail, List<String> individualAliasList, String type, String companyId) throws Exception;
	public int deleteIndividualAlias(String userId, int tenantID) throws Exception;
	public String checkIndividualAlias(String individualAlias, int tenantId) throws Exception;
	String checkIndividualAliasWithoutOwned(String userEmail, String individualAlias, int tenantId) throws Exception;
	String updatePrimaryIndividualAlias(String userEmail, String originAlias, String updateAlias, int tenantId) throws Exception;
	public Map<String, String> getAliasAddressMap(List<String> addressList, int tenantId) throws Exception;
	
	public void sendMail(String loginCookie, InternetAddress from, InternetAddress[] toArr, InternetAddress[] ccArr, InternetAddress[] bccArr, String subject, String content, boolean isSaved) throws Exception;
	public void sendMail(String userEmail, String password, Locale userLocale, InternetAddress from, InternetAddress[] toArr, InternetAddress[] ccArr, InternetAddress[] bccArr, String subject, String content, boolean isSaved, EmailImportance importance) throws Exception;
	public void sendMail(String userEmail, String password, Locale userLocale, InternetAddress from, InternetAddress[] toArr, InternetAddress[] ccArr, InternetAddress[] bccArr, String subject, String content) throws Exception;
	public void sendMail(String userEmail, String password, Locale userLocale, InternetAddress from, InternetAddress[] toArr, InternetAddress[] ccArr, InternetAddress[] bccArr, String subject, String content, boolean isSaved, EmailImportance importance, String fileName, String contentType, InputStream inputStream) throws Exception;
	
	public void sendMailWithExplicitRecipients(InternetAddress[] recipients, String loginCookie, InternetAddress from, InternetAddress[] toArr, InternetAddress[] ccArr, InternetAddress[] bccArr, String subject, String content, boolean isSaved) throws Exception;
	
	public String mailContentDownload(String loginCookie, String url, String realPath) throws Exception;
	public boolean checkMailQuota(LoginVO userInfo, String password) throws Exception;
	public int getMaxMessageSize(int tenantId) throws Exception;
	List<String[]> getAliasAddress(String userId, int tenantId, String useFromAddress, String useDistributionSender) throws Exception;
	public List<Map<String, String>> getMailListT(LoginVO userInfo, String password, String dateTime, int count) throws Exception;
	public List<MailDistributionVO> getDistributionList(String companyId, int tenantId) throws Exception;
	public List<MailDistributionVO> getDistributionSearchList(String companyId, int tenantId, String searchValue) throws Exception;
	public List<MailDistributionVO> getDistributionSearchListByItem(String companyId, int tenantId, String searchValue, String searchType) throws Exception;
	public MailSignatureVO getInitMailSignature(int tenantId) throws Exception;
	public boolean addEzTalkNotification(String userId, String senderName, String subject, String type, String subType, String linkUrl);
	public boolean setInitInboxRule(int tenantId, String userId) throws Exception;
	public List<String> getInitInboxRuleMailbox(int tenantId) throws Exception;
	public int setMailSecure(int tenantId, String userId, String password, int maxReadCount, String maxReadDate) throws Exception;
	public String updateMailSecure(int tenantId, String userId, int secureId, String url) throws Exception;
	public int checkSecureMailPassword(String secureId, String reader, String password) throws Exception;
	public MailSecureVO getSecureMailInfo(String secureId, String reader) throws Exception;
	public String updateSecureMailReaderInfo(String secureId, String reader) throws Exception;
	public MailSecureVO getSecureMailInfoWithPassword(String secureId) throws Exception;
	public MailSecureVO getSecureMailInfoWithPassword(String userId, int tenantId, String url) throws Exception;
	public List<MailSecureReaderVO> getSecureMailReaderInfo(String secureId) throws Exception;
	public String checkDistributionIsIncluded (String standardCn, String searchCn, int tenantId) throws Exception;
	List<MailDistributionVO> getDistributioUpperList(String userName, int tenantId) throws Exception;
	public List<String> aliasMailCheck(String address) throws Exception;
	public List<Map<String, String>> getUserSharedMailboxList(String userId, boolean useUnreadCount, int tenantId) throws Exception;
	public boolean checkUserShareId(String userId, String shareId, int tenantId) throws Exception;
	/**
	 * <pre>
	 * 사용자의 공유사서함 사용 권한 체크
	 * 
	 * permissionType
	 *   0: 공유자인지 체크
	 *   1(001): 삭제(이동/복사 포함) 권한이 있는지 체크
	 *   2(010): 메일 보내기 권한이 있는지 체크
	 *   3(011): 메일 보내기, 삭제 권한이 있는지 체크
	 *   4(100): 관리(편지함 관리/메일 환경설정) 권한이 있는지 체크
	 *   5(101): 관리, 삭제 권한이 있는지 체크
	 *   6(110): 관리, 메일 보내기 권한이 있는지 체크
	 *   7(111): 관리, 메일 보내기, 삭제 권한이 있는지 체크
	 * </pre>
	 */
	public boolean checkUserShareId(String userId, String shareId, int permissionType, int tenantId) throws Exception;
	public List<MailSharedMailboxVO> getSharedMailboxList(String compId, int tenantId) throws Exception;
	public MailSharedMailboxVO getSharedMailboxInfo(String shareId, int tenantId) throws Exception;
	public MailSharedMailboxVO getSharedMailboxInfo(String shareId, int tenantId, String lang) throws Exception;
	public String delSharedMailboxAllUser(String shareId, int tenantId) throws Exception;
	public String setSharedMailboxUsers(String shareId, JSONArray userList, int tenantId) throws Exception;
	public List<MailSharedMailboxVO> getSharedMailboxSearchList(String companyId, int tenantId, String searchValue) throws Exception;
	public List<MailSharedMailboxVO> getSharedMailboxListSearchByItem(String companyId, int tenantId, String searchType, String searchValue) throws Exception;
	public MailSharedMailboxUserVO getSharedMailboxPermissionInfo(String shareId, int tenantId, String userId) throws Exception;
	public int deleteUserFromAllSharedMailbox(String userId, int tenantId) throws Exception;
	public JSONArray selectAllSignatureTemplate(String companyId, String tenantId) throws Exception;
	public JSONArray selectSearchSignatureTemplate(String companyId, String tenantId, String search, String userLang) throws Exception;
	public void deleteSignatureTemplate(String signNo) throws Exception;
	public JSONArray selectOneSignatureTemplate(String signNo) throws Exception;
	public void addSignatureTemplate(MailSignatureTemplateVO signTemplate) throws Exception;
	public void setSignatureTemplate(MailSignatureTemplateVO signTemplate) throws Exception;
	MailDistributionVO getDistributionSub(String userName, String subMail, String companyId, int tenantId) throws Exception;
	public int addDistributionList(String id, String name, List<String> memberList, List<Map<String, String>> subList, String compId, int tenantId) throws Exception;
	public int updateDistributionList(String id, String name, List<String> memberList, List<Map<String, String>> subList, String compId, int tenantId) throws Exception;
	public JSONObject recallMailByMessageId(String address, String messageId) throws Exception;
	public void cancelMailByMailUid(Long mailUid, Long mailboxId) throws Exception;
	public int getTotalUnreadCount(String userId, int tenantId) throws Exception;
	public JSONObject getUnreadCountAll(JSONObject requestObject, String userId, Locale locale, int tenantId) throws Exception;
	/**
	 * 멀티도메인
	 */
	public String getMultiDomainList(int tenantId) throws Exception;
	public int addMultiDomain(int tenantId, String domainName) throws Exception;
	public int delMultiDomain(int tenantId, String delDomain, String saveDomainList) throws Exception;
	public String getCompanyConfig(int tenantId, String companyId, String propertyName) throws Exception;
	public int saveCompanyMultiDomain(int tenantId, String companyId, String primaryDomain, String saveDomainList) throws Exception;
	
	public int addDistributionList(String id, String name, List<String> memberList, List<Map<String, String>> subList, String compId, int tenantId, String selectDomain) throws Exception;
	public String setIndividualAliasForMig(String userId, int tenantID, String targetAddr, String individualAliasList) throws Exception;
	
	public MailDistributionVO getDistributionInfo(String cn, int tenantId) throws Exception;
	public int addDistributionList(String id, String name, List<String> memberList,List<Map<String, String>> distributionSubList, 
			String companyId, int tenantID, String selectDomain, String ownerId, String policy, String explaination, String endDate, String loginCookie) throws Exception;
	public List<MailDistributionVO> getUserOwnerDistributionList(String companyId, int tenantId, String ownerId) throws Exception;
	public List<MailDistributionVO> getUserIncludedDistributionList(String companyId, int tenantId, String userId) throws Exception;
	public int secessionDistribution(int tenantId, String cn, String userId) throws Exception;
	public MailDistributionVO getUserDistributionInfo(String cn, int tenantId) throws Exception;
	public JSONArray getUserDistributionApplyList(String cn, int tenantId) throws Exception;
	public int setUserDistributionApply(String cn, int tenantId, String userId, String type) throws Exception;
	public int updateDistributionList(String id, String name, List<String> memberList, List<Map<String, String>> subList, String compId, int tenantId,
			String ownerId, String policy, String explaination, String endDate, String loginCookie) throws Exception;
	public JSONArray getUserDistributionMemberList(String domain, String cn) throws Exception;
	public int checkUserDistributionInCludedMember(String domain, String cn, String userId) throws Exception;
	public List<MailDistributionVO> userDistributionListSearch(String domain, String searchRange, String searchValue, String userId) throws Exception;
	public int checkUserDistributionApply(String cn, String domain, String userId) throws Exception;
	public List<MailDistributionVO> getExpiredUserDistributionList() throws Exception;
	public void sendUserDLMail(String loginCookie, String cn, String type, List<String> toList) throws Exception;
	public JSONArray getFolderQuota(String String, Locale locale) throws Exception;
	
	public String setBigAttachCountInfo(String[] fileIdArr, int limitCount, int tenantId) throws Exception;
	public String checkBigAttachDownloadCount(String fileId, int tenantId) throws Exception;
	public void updateBigAttachDownloadCount(String fileId, int tenantId) throws Exception;
	public void deleteBigAttachCountInfo(File[] fileList, int tenantId) throws Exception;
	public void deleteBigAttachCountInfo(String[] fileIdArr, int tenantId) throws Exception;
	public int deleteMailDeleteForUser(String pUserEmail) throws Exception;

	public int deleteMailsByMessageIds(String messageIds) throws Exception;
	public int blockMailsByMessageIds(String messageIds) throws Exception;
	public int unblockMailsByMessageIds(String messageIds) throws Exception;
	public int checkBlockedMailByMessageId(String messageId) throws Exception;
	
	public void setMailboxProgress(String userKey, String userId, String action, int tenantId, int percent) throws Exception;
	public int updateMailboxProgress(String userKey, int percent) throws Exception;
	int updateMailboxProgressState(String userKey, String state, String stateDescription);
	MailboxProgressVO getMailboxProgress(String userKey) throws Exception;
	public int delMailboxProgress(String userKey) throws Exception;
	
	public JSONArray getMailOutOfOfficeTemplateList(String userEmail) throws Exception;
	public JSONObject getMailOutOfOfficeTemplate(String userEmail, String displayName) throws Exception;
	public int deleteMailOutOfOfficeTemplate(String userEmail, String displayName) throws Exception;
	public int saveMailOutOfOfficeTemplate(String userEmail, String modDisplayName, String displayName, String content, String type) throws Exception;
	
	public JSONArray getUserMailTemplateList(String userEmail) throws Exception;
	public JSONObject getUserMailTemplate(String userEmail, String templateId) throws Exception;
	public int saveUserMailTemplate(String userEmail, String displayName, String content, String realPath, String editorType, int tenantId) throws Exception;
	public int deleteUserMailTemplate(String userEmail, String templateId, String type, String realPath, int tenantId) throws Exception;

	/**
	 * 해당 주소 도메인이 내부주소에 포함된 도메인인지 확인 로직
	 * @param forwardAddress
	 * @param tenantId
	 * @return "OK" : 내부주소 List에 등록됨 , "FAIL" : 내부주소 List에 등록된 주소가 아님
	 * @throws Exception
	 */
	public String checkInnerDomain(String forwardAddress, int tenantId) throws Exception;

	public JSONObject getDistributionMemberList(String domain, String cn) throws Exception;
	
	/* 승인메일 */
	JSONArray getAdminCompApprMailList(int tenantId, String companyId, String type, String id, String lang, int pageStartNum, int listCount) throws Exception;
	JSONArray getAdminApprMailList(int tenantId, String companyId, String type, String id, String lang, int pageStartNum, int listCount) throws Exception;
	int getAdminApprMailListCount(int tenantId, String companyId, String type, String id) throws Exception;
	JSONArray getApprMailList(int tenantId, String companyId, String type, String id, String lang, int pageStartNum, int listCount, String domainName) throws Exception;
	int getApprMailListCount(int tenantId, String companyId, String type, String id) throws Exception;
	JSONArray setUTCtoUserTime(JSONArray array, String offset, int tenantId) throws Exception;
	JSONArray formatApprEmail(JSONArray array, String offset, int tenantId, Locale locale) throws Exception;
	JSONArray setApprover(JSONArray array, Locale locale) throws Exception;
	JSONArray setHref(JSONArray array) throws Exception;
	String setHref(String senderId, String mailUID) throws Exception;
	JSONArray setStateByLocale(JSONArray array, Locale locale) throws Exception;
	public String setStateByLocale(String state, Locale locale) throws Exception;
	boolean checkApprMailApprover(int tenantId, String companyId, String cn) throws Exception;
	public List<String> getApprAllowedDomainList(int tenantId, String companyId) throws Exception;
	public List<String> checkApprAllowedDomain(int tenantId, String companyId, String[] domainNameList) throws Exception;
	public int insertApprAllowedDomain(int tenantId, String companyId, String domainName) throws Exception;
	public int deleteApprAllowedDomain(int tenantId, String companyId, String[] domainNameList) throws Exception;
	public List<String> getApproverList(int tenantId, String companyId) throws Exception;
	public List<OrganUserVO> getApproverList(int tenantId, String companyId, String lang) throws Exception;
	public List<OrganUserVO> getApproverSearchList(int tenantId, String companyId, String lang, String searchType, String searchValue) throws Exception;
	//public List<String> checkApprover(int tenantId, String companyId, String[] userIdList) throws Exception;
	public int resetApprover(int tenantId, String companyId, String[] userIdList) throws Exception;
	public int insertApprover(int tenantId, String companyId, String[] userIdList) throws Exception;
	public int deleteApprover(int tenantId, String companyId, String[] userIdList) throws Exception;
	public List<String> getExceptionUserList(int tenantId, String companyId) throws Exception;
	//public List<String> checkExceptionUser(int tenantId, String companyId, String[] userIdList) throws Exception;
	public boolean checkExceptionUser(int tenantId, String companyId, String userId) throws Exception;
	public int resetExceptionUser(int tenantId, String companyId, String[] userIdList) throws Exception;
	public int insertExceptionUser(int tenantId, String companyId, String[] userIdList) throws Exception;
	public int deleteExceptionUser(int tenantId, String companyId, String[] userIdList) throws Exception;
	public Map<String, String> getApprAllHistoryInfo(int tenantId, String companyId, long mailUID, String userId, String lang) throws Exception;
	public int insertApprCompHistory(int tenantId, String companyId, long mailUID, String userId, MimeMessage message) throws Exception;
	public int insertApprHistory(int tenantId, String companyId, long mailUID, String userId, String approverId, MimeMessage message) throws Exception;
	public int deleteApprCompHistory(int tenantId, String companyId, long mailUID, String userId) throws Exception;
	public int deleteApprHistory(int tenantId, String companyId, long mailUID, String userId) throws Exception;
	public int checkApprHistoryAll(int tenantId, String companyId, String userId, List<Map<String, Object>> mailDataList) throws Exception;
	public int checkApprHistoryMultiple(int tenantId, String companyId, String userId, List<Map<String, Object>> mailDataList) throws Exception;
	public int updateApprCompHistory(int tenantId, String companyId, long mailUID, String userId, String state, String approverId, String approverName, String approverName2, String memo) throws Exception;
	public int updateApprHistory(int tenantId, String companyId, long mailUID, String userId, String state, String memo) throws Exception;
	public int applyApprCompMail(String loginCookie, long mailUID, MimeMessage message) throws Exception;
	public int applyApprCompMail(String loginCookie, long mailUID, MimeMessage message, String shareId) throws Exception;
	public int applyApprCompMail(String userId, int tenantId, Map<String, Object> paramMap, long mailUID, MimeMessage message) throws Exception;
	public int applyApprMail(String loginCookie, long mailUID, MimeMessage message, String approverId) throws Exception;
	public int applyApprMail(String loginCookie, long mailUID, MimeMessage message, String approverId, String shareId) throws Exception;
	public int applyApprMail(String userId, int tenantId, Map<String, Object> paramMap, long mailUID, MimeMessage message, String approverId) throws Exception;
	public int setApprMailCancel(String loginCookie, String applicantEmail, long uid) throws Exception;
	public int setApprMailCancel(int tenantId, Map<String, Object> paramMap, String applicantEmail, long uid) throws Exception;
	public int setApprCompMailApproval(String loginCookie, String applicantEmail, long uid) throws Exception;
	public int setApprMailApproval(String loginCookie, String applicantEmail, long uid) throws Exception;
	public int setApprMailApproval(String userId, int tenantId, Map<String, Object> paramMap) throws Exception;
	public int setApprMailApproval(String userId, int tenantId, Map<String, Object> paramMap, String applicantEmail, long uid) throws Exception;
	public int setApprCompMailReject(String loginCookie, String applicantEmail, long uid, String memo) throws Exception;
	public int setApprMailReject(String loginCookie, String applicantEmail, long uid, String memo) throws Exception;
	public int setApprMailReject(String userId, int tenantId, Map<String, Object> paramMap, String applicantEmail, long uid, String memo) throws Exception;
	public int setApprCompMailDelete(String loginCookie, String applicantEmail, long uid) throws Exception;
	public List<Map<String, String>> getAutoDeleteApprMailHistoryList(int tenantId, String lang) throws Exception;
	public List<Map<String, String>> getOldApprMailHistoryList(int tenantId, String lang) throws Exception;
	public int setApprMailAutoDelete(int tenantId, String companyId, String applicantEmail, long uid) throws Exception;
	public int setOldApprMailDelete(int tenantId, String companyId, String applicantEmail, long uid) throws Exception;
	public List<Map<String, String>> getApprCompMailHistorySearchList(int tenantId, String companyId, String lang, Locale locale, String offset) throws Exception;
	public List<Map<String, String>> getApprCompMailHistorySearchList(int tenantId, String companyId, String lang, Locale locale, String offset, String sDate, String eDate) throws Exception;
	public List<Map<String, String>> getApprCompMailHistorySearchList(int tenantId, String companyId, String lang, Locale locale, String offset, String sDate, String eDate, int pageStartNum, int listCount) throws Exception;
	public int getApprCompMailHistorySearchListCnt(int tenantId, String companyId, String sDate, String eDate) throws Exception;
	public List<Map<String, String>> getApprCompMailHistorySearchUserCnt(int tenantId, String companyId, String lang, String sDate, String eDate) throws Exception;
	public JSONArray getApprMailHistorySearchList(int tenantId, String companyId, String lang, Locale locale, String offset) throws Exception;
	public JSONArray getApprMailHistorySearchList(int tenantId, String companyId, String lang, Locale locale, String offset, String sDate, String eDate) throws Exception;
	public JSONArray getApprMailHistorySearchList(int tenantId, String companyId, String lang, Locale locale, String offset, String sDate, String eDate, int pageStartNum, int listCount) throws Exception;
	public int getApprMailHistorySearchListCnt(int tenantId, String companyId, String sDate, String eDate) throws Exception;
	public List<Map<String, String>> getApprMailHistorySearchUserCnt(int tenantId, String companyId, String lang, String sDate, String eDate) throws Exception;
	public void actionTrashMailAllDelete(IMAPAccess ia, String folderId) throws Exception;
	public void actionMailMoveTrash(IMAPAccess ia, Map<String, long[]> folderUids, String cmd, Locale locale, int tenantID, String userEmail, String domainName) throws Exception;
	public String encryptSecureValue(String encryptValue, boolean useKlibEncrypt) throws Exception;
	public String decryptSecureValue(String decryptValue, boolean useKlibEncrypt) throws Exception;
}
