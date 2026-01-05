package egovframework.ezEKP.ezEmail.vo;

import java.util.List;

public class MailWriteOptionsVO {
	private String isMailToMe; // 내게쓰기
	private boolean isCrossBrowser; // browser
	private String postType = "0"; // SENSITIVITY?
	private String useMultiLangMail = "1"; // 안쓰임??

	// from
	private String useFromAddress; // alias 발신인 주소 선택 사용여부
	private String useDistributionSender; // 공용배포그룹 발신인 주소 선택 사용여부
	private List<String[]> fromAddressList;

	// 보안메일
	private String useSecureMail; // 보안메일 사용여부
	private String security = "1"; // 존재의미..? (default=1, isSecureMail:true=3)

	// 첨부
	private String newWindowId = ""; // var newid
	private String stateName; // (randomUUID) var filedate
	private String uploadCommonPath;
	private String uploadCommunityPath;
	private String fileUploadType = ""; // 안쓰임??

	// 파일첨부 제한 관련 변수 설정
	private String mailAttachLimit;
	private String bigSizeMailAttachLimit;
	private String totBigSizeMailAttachLimit;
	private String bigSizeMailAttachDelDate;
	private String bigAttachDownloadDay;
	private String bigAttachDownloadPeriod;
	private String attachWarning;
	private String bigSizeAttachLimitCount;
	private String bigSizeAttachDownloadLimitCount;

	// tenant config
	private String useApprMail; // 승인메일 기능 사용여부
	private String mailInnerDomain; // 내부 메일도메인
	private String useOnlyInnerMail; // 메일 내부망만 사용
	private String mailMaxReceiverCount; // 메일 최대 수신자 수
	private String useMailAddrAutoComplete; // 수신인 자동완성 사용여부
	private boolean useAdditionalInfo; // 메일쓰기 수신인 추가 정보 사용여부
	private String individualMailUser; // 메일 개별발신 최대 인원
	private String useEditor; // 에디터 타입
	private String useLetter; // 메일 편지지 기능 사용여부
	private String useMailWriteSenderClick; // 보낸사람에게 바로 메일보내기 사용

	// HWP 양식작성기
	private String useHWP;
	private String webHWPUrl;
	private String useHwpDownSecurity;
	private String hwpSecurityNum;
	private String approvalFlag;
	private String moduleEditor;

// [module options]
	private String moduleType; // ezPMS, attitudeAbsented, poll
	private String dotNetUrl; // board, Community, approvalG

	// in case of board/Community
	private String boardID = "";
	private String itemID = "";
	private String retransType = "";

	// in case of approvalG
	private String docHref = "";
	private String docID = "";
	private String docImagCnt = "";
	private String docTarget = "";
	private String docType;
	private String orgCompanyID;

	// 업무일지
	private String journalId;

	// ezPMS 게시판
	private String ezPMSProjectId; // ezPMS 게시판, ezPMS
	private String ezPMSBoardId;

	// ezPMS
	private String pmsRoleId;
	private String pmsType;
	private String pmsToUserId;
	private String pmsUserIdType;
	private String pmsTaskId;

	// 근태관리
	private String attitudeId;

	// 근태관리 미입력자 메일발송
	private String companyId;
	private String searchUserName;
	private String searchDeptName;
	private String searchTitle;
	private String searchDeptId;
	private String searchStartDate;
	private String searchEndDate;

	// poll
	private String pollSendType;
	private String folderDate;

	public void setIsMailToMe(String isMailToMe) {
		this.isMailToMe = isMailToMe;
	}
	public String getIsMailToMe() {
		return isMailToMe;
	}

	public void setIsCrossBrowser(boolean isCrossBrowser) {
		this.isCrossBrowser = isCrossBrowser;
	}
	public boolean getIsCrossBrowser() {
		return isCrossBrowser;
	}

	public void setPostType(String postType) {
		this.postType = postType;
	}
	public String getPostType() {
		return postType;
	}

	public void setUseMultiLangMail(String useMultiLangMail) {
		this.useMultiLangMail = useMultiLangMail;
	}
	public String getUseMultiLangMail() {
		return useMultiLangMail;
	}

	public void setUseFromAddress(String useFromAddress) {
		this.useFromAddress = useFromAddress;
	}
	public String getUseFromAddress() {
		return useFromAddress;
	}

	public void setUseDistributionSender(String useDistributionSender) {
		this.useDistributionSender = useDistributionSender;
	}
	public String getUseDistributionSender() {
		return useDistributionSender;
	}

	public void setFromAddressList(List<String[]> fromAddressList) {
		this.fromAddressList = fromAddressList;
	}
	public List<String[]> getFromAddressList() {
		return fromAddressList;
	}

	public void setUseSecureMail(String useSecureMail) {
		this.useSecureMail = useSecureMail;
	}
	public String getUseSecureMail() {
		return useSecureMail;
	}

	public void setSecurity(String security) {
		this.security = security;
	}
	public String getSecurity() {
		return security;
	}

	public void setNewWindowId(String newWindowId) {
		this.newWindowId = newWindowId;
	}
	public String getNewWindowId() {
		return newWindowId;
	}

	public void setStateName(String stateName) {
		this.stateName = stateName;
	}
	public String getStateName() {
		return stateName;
	}

	public void setUploadCommonPath(String uploadCommonPath) {
		this.uploadCommonPath = uploadCommonPath;
	}
	public String getUploadCommonPath() {
		return uploadCommonPath;
	}

	public void setUploadCommunityPath(String uploadCommunityPath) {
		this.uploadCommunityPath = uploadCommunityPath;
	}
	public String getUploadCommunityPath() {
		return uploadCommunityPath;
	}

	public void setFileUploadType(String fileUploadType) {
		this.fileUploadType = fileUploadType;
	}
	public String getFileUploadType() {
		return fileUploadType;
	}

	public void setMailAttachLimit(String mailAttachLimit) {
		this.mailAttachLimit = mailAttachLimit;
	}
	public String getMailAttachLimit() {
		return mailAttachLimit;
	}

	public void setBigSizeMailAttachLimit(String bigSizeMailAttachLimit) {
		this.bigSizeMailAttachLimit = bigSizeMailAttachLimit;
	}
	public String getBigSizeMailAttachLimit() {
		return bigSizeMailAttachLimit;
	}

	public void setTotBigSizeMailAttachLimit(String totBigSizeMailAttachLimit) {
		this.totBigSizeMailAttachLimit = totBigSizeMailAttachLimit;
	}
	public String getTotBigSizeMailAttachLimit() {
		return totBigSizeMailAttachLimit;
	}

	public void setBigSizeMailAttachDelDate(String bigSizeMailAttachDelDate) {
		this.bigSizeMailAttachDelDate = bigSizeMailAttachDelDate;
	}
	public String getBigSizeMailAttachDelDate() {
		return bigSizeMailAttachDelDate;
	}

	public void setBigAttachDownloadDay(String bigAttachDownloadDay) {
		this.bigAttachDownloadDay = bigAttachDownloadDay;
	}
	public String getBigAttachDownloadDay() {
		return bigAttachDownloadDay;
	}

	public void setBigAttachDownloadPeriod(String bigAttachDownloadPeriod) {
		this.bigAttachDownloadPeriod = bigAttachDownloadPeriod;
	}
	public String getBigAttachDownloadPeriod() {
		return bigAttachDownloadPeriod;
	}

	public void setAttachWarning(String attachWarning) {
		this.attachWarning = attachWarning;
	}
	public String getAttachWarning() {
		return attachWarning;
	}

	public void setBigSizeAttachLimitCount(String bigSizeAttachLimitCount) {
		this.bigSizeAttachLimitCount = bigSizeAttachLimitCount;
	}
	public String getBigSizeAttachLimitCount() {
		return bigSizeAttachLimitCount;
	}

	public void setBigSizeAttachDownloadLimitCount(String bigSizeAttachDownloadLimitCount) {
		this.bigSizeAttachDownloadLimitCount = bigSizeAttachDownloadLimitCount;
	}
	public String getBigSizeAttachDownloadLimitCount() {
		return bigSizeAttachDownloadLimitCount;
	}

	public void setUseApprMail(String useApprMail) {
		this.useApprMail = useApprMail;
	}
	public String getUseApprMail() {
		return useApprMail;
	}

	public void setMailInnerDomain(String mailInnerDomain) {
		this.mailInnerDomain = mailInnerDomain;
	}
	public String getMailInnerDomain() {
		return mailInnerDomain;
	}

	public void setUseOnlyInnerMail(String useOnlyInnerMail) {
		this.useOnlyInnerMail = useOnlyInnerMail;
	}
	public String getUseOnlyInnerMail() {
		return useOnlyInnerMail;
	}

	public void setMailMaxReceiverCount(String mailMaxReceiverCount) {
		this.mailMaxReceiverCount = mailMaxReceiverCount;
	}
	public String getMailMaxReceiverCount() {
		return mailMaxReceiverCount;
	}

	public void setUseMailAddrAutoComplete(String useMailAddrAutoComplete) {
		this.useMailAddrAutoComplete = useMailAddrAutoComplete;
	}
	public String getUseMailAddrAutoComplete() {
		return useMailAddrAutoComplete;
	}

	public void setUseAdditionalInfo(boolean useAdditionalInfo) {
		this.useAdditionalInfo = useAdditionalInfo;
	}
	public boolean getUseAdditionalInfo() {
		return useAdditionalInfo;
	}

	public void setIndividualMailUser(String individualMailUser) {
		this.individualMailUser = individualMailUser;
	}
	public String getIndividualMailUser() {
		return individualMailUser;
	}

	public void setUseEditor(String useEditor) {
		this.useEditor = useEditor;
	}
	public String getUseEditor() {
		return useEditor;
	}

	public void setUseLetter(String useLetter) {
		this.useLetter = useLetter;
	}
	public String getUseLetter() {
		return useLetter;
	}

	public void setUseMailWriteSenderClick(String useMailWriteSenderClick) {
		this.useMailWriteSenderClick = useMailWriteSenderClick;
	}
	public String getUseMailWriteSenderClick() {
		return useMailWriteSenderClick;
	}

	public void setUseHWP(String useHWP) {
		this.useHWP = useHWP;
	}
	public String getUseHWP() {
		return useHWP;
	}

	public void setWebHWPUrl(String webHWPUrl) {
		this.webHWPUrl = webHWPUrl;
	}
	public String getWebHWPUrl() {
		return webHWPUrl;
	}

	public void setUseHwpDownSecurity(String useHwpDownSecurity) {
		this.useHwpDownSecurity = useHwpDownSecurity;
	}
	public String getUseHwpDownSecurity() {
		return useHwpDownSecurity;
	}

	public void setHwpSecurityNum(String hwpSecurityNum) {
		this.hwpSecurityNum = hwpSecurityNum;
	}
	public String getHwpSecurityNum() {
		return hwpSecurityNum;
	}

	public void setApprovalFlag(String approvalFlag) {
		this.approvalFlag = approvalFlag;
	}
	public String getApprovalFlag() {
		return approvalFlag;
	}

	public void setModuleEditor(String moduleEditor) {
		this.moduleEditor = moduleEditor;
	}
	public String getModuleEditor() {
		return moduleEditor;
	}

	public void setModuleType(String moduleType) {
		this.moduleType = moduleType;
	}
	public String getModuleType() {
		return moduleType;
	}

	public void setDotNetUrl(String dotNetUrl) {
		this.dotNetUrl = dotNetUrl;
	}
	public String getDotNetUrl() {
		return dotNetUrl;
	}

	public void setBoardID(String boardID) {
		this.boardID = boardID;
	}
	public String getBoardID() {
		return boardID;
	}

	public void setItemID(String itemID) {
		this.itemID = itemID;
	}
	public String getItemID() {
		return itemID;
	}

	public void setRetransType(String retransType) {
		this.retransType = retransType;
	}
	public String getRetransType() {
		return retransType;
	}

	public void setDocHref(String docHref) {
		this.docHref = docHref;
	}
	public String getDocHref() {
		return docHref;
	}

	public void setDocID(String docID) {
		this.docID = docID;
	}
	public String getDocID() {
		return docID;
	}

	public void setDocImagCnt(String docImagCnt) {
		this.docImagCnt = docImagCnt;
	}
	public String getDocImagCnt() {
		return docImagCnt;
	}

	public void setDocTarget(String docTarget) {
		this.docTarget = docTarget;
	}
	public String getDocTarget() {
		return docTarget;
	}

	public void setDocType(String docType) {
		this.docType = docType;
	}
	public String getDocType() {
		return docType;
	}

	public void setOrgCompanyID(String orgCompanyID) {
		this.orgCompanyID = orgCompanyID;
	}
	public String getOrgCompanyID() {
		return orgCompanyID;
	}

	public void setJournalId(String journalId) {
		this.journalId = journalId;
	}
	public String getJournalId() {
		return journalId;
	}

	public void setEzPMSProjectId(String ezPMSProjectId) {
		this.ezPMSProjectId = ezPMSProjectId;
	}
	public String getEzPMSProjectId() {
		return ezPMSProjectId;
	}

	public void setEzPMSBoardId(String ezPMSBoardId) {
		this.ezPMSBoardId = ezPMSBoardId;
	}
	public String getEzPMSBoardId() {
		return ezPMSBoardId;
	}

	public void setPmsRoleId(String pmsRoleId) {
		this.pmsRoleId = pmsRoleId;
	}
	public String getPmsRoleId() {
		return pmsRoleId;
	}

	public void setPmsType(String pmsType) {
		this.pmsType = pmsType;
	}
	public String getPmsType() {
		return pmsType;
	}

	public void setPmsToUserId(String pmsToUserId) {
		this.pmsToUserId = pmsToUserId;
	}
	public String getPmsToUserId() {
		return pmsToUserId;
	}

	public void setPmsUserIdType(String pmsUserIdType) {
		this.pmsUserIdType = pmsUserIdType;
	}
	public String getPmsUserIdType() {
		return pmsUserIdType;
	}

	public void setPmsTaskId(String pmsTaskId) {
		this.pmsTaskId = pmsTaskId;
	}
	public String getPmsTaskId() {
		return pmsTaskId;
	}

	public void setAttitudeId(String attitudeId) {
		this.attitudeId = attitudeId;
	}
	public String getAttitudeId() {
		return attitudeId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public String getCompanyId() {
		return companyId;
	}

	public void setSearchUserName(String searchUserName) {
		this.searchUserName = searchUserName;
	}
	public String getSearchUserName() {
		return searchUserName;
	}

	public void setSearchDeptName(String searchDeptName) {
		this.searchDeptName = searchDeptName;
	}
	public String getSearchDeptName() {
		return searchDeptName;
	}

	public void setSearchTitle(String searchTitle) {
		this.searchTitle = searchTitle;
	}
	public String getSearchTitle() {
		return searchTitle;
	}

	public void setSearchDeptId(String searchDeptId) {
		this.searchDeptId = searchDeptId;
	}
	public String getSearchDeptId() {
		return searchDeptId;
	}

	public void setSearchStartDate(String searchStartDate) {
		this.searchStartDate = searchStartDate;
	}
	public String getSearchStartDate() {
		return searchStartDate;
	}

	public void setSearchEndDate(String searchEndDate) {
		this.searchEndDate = searchEndDate;
	}
	public String getSearchEndDate() {
		return searchEndDate;
	}

	public void setPollSendType(String pollSendType) {
		this.pollSendType = pollSendType;
	}
	public String getPollSendType() {
		return pollSendType;
	}

	public void setFolderDate(String folderDate) {
		this.folderDate = folderDate;
	}
	public String getFolderDate() {
		return folderDate;
	}

	@Override
	public String toString() {
		return "MailWriteOptionsVO [isMailToMe=" + isMailToMe + ", isCrossBrowser=" + isCrossBrowser + ", postType="
				+ postType + ", useMultiLangMail=" + useMultiLangMail + ", useFromAddress=" + useFromAddress + ", useDistributionSender=" + useDistributionSender
				+ ", fromAddressList=" + fromAddressList + ", useSecureMail=" + useSecureMail + ", security=" + security
				+ ", newWindowId=" + newWindowId + ", stateName=" + stateName + ", uploadCommonPath=" + uploadCommonPath
				+ ", uploadCommunityPath=" + uploadCommunityPath
				+ ", fileUploadType=" + fileUploadType + ", mailAttachLimit=" + mailAttachLimit
				+ ", bigSizeMailAttachLimit=" + bigSizeMailAttachLimit + ", totBigSizeMailAttachLimit="
				+ totBigSizeMailAttachLimit + ", bigSizeMailAttachDelDate=" + bigSizeMailAttachDelDate
				+ ", bigAttachDownloadDay=" + bigAttachDownloadDay + ", bigAttachDownloadPeriod="
				+ bigAttachDownloadPeriod + ", attachWarning=" + attachWarning + ", bigSizeAttachLimitCount="
				+ bigSizeAttachLimitCount + ", bigSizeAttachDownloadLimitCount=" + bigSizeAttachDownloadLimitCount
				+ ", useApprMail=" + useApprMail + ", mailInnerDomain=" + mailInnerDomain + ", useOnlyInnerMail="
				+ useOnlyInnerMail + ", mailMaxReceiverCount=" + mailMaxReceiverCount + ", useMailAddrAutoComplete="
				+ useMailAddrAutoComplete + ", useAdditionalInfo=" + useAdditionalInfo + ", individualMailUser="
				+ individualMailUser + ", useEditor=" + useEditor + ", useLetter=" + useLetter
				+ ", useMailWriteSenderClick=" + useMailWriteSenderClick + ", useHWP=" + useHWP + ", webHWPUrl="
				+ webHWPUrl + ", useHwpDownSecurity=" + useHwpDownSecurity + ", hwpSecurityNum=" + hwpSecurityNum
				+ ", approvalFlag=" + approvalFlag + ", moduleEditor=" + moduleEditor + ", moduleType=" + moduleType
				+ ", dotNetUrl=" + dotNetUrl + ", boardID=" + boardID + ", itemID=" + itemID + ", retransType="
				+ retransType + ", docHref=" + docHref + ", docID=" + docID + ", docImagCnt=" + docImagCnt
				+ ", docTarget=" + docTarget + ", docType=" + docType + ", orgCompanyID=" + orgCompanyID
				+ ", journalId=" + journalId + ", ezPMSProjectId=" + ezPMSProjectId + ", ezPMSBoardId=" + ezPMSBoardId
				+ ", pmsRoleId=" + pmsRoleId + ", pmsType=" + pmsType + ", pmsToUserId=" + pmsToUserId
				+ ", pmsUserIdType=" + pmsUserIdType + ", pmsTaskId=" + pmsTaskId + ", attitudeId=" + attitudeId
				+ ", companyId=" + companyId + ", searchUserName=" + searchUserName + ", searchDeptName="
				+ searchDeptName + ", searchTitle=" + searchTitle + ", searchDeptId=" + searchDeptId
				+ ", searchStartDate=" + searchStartDate + ", searchEndDate=" + searchEndDate + ", pollSendType="
				+ pollSendType + ", folderDate=" + folderDate + "]";
	}
}