package egovframework.ezMobile.ezSurvey.vo;

import java.util.List;

public class MSurveyVO {
	private long surveyId;
	private String companyId;
	private int tenantId;
	private String title;
	private String purpose;
	private String creatorId;
	private String createDate;
	private String updateDate;
	private String startDate;
	private String endDate;
	private String creatorName;
	private String creatorName1;
	private String creatorName2;
	private String deleteUser;
	private String updateUser;
	private int useStatus;
	private int openDays;
	private int resultPublicFlag;
	private int anonymousFlag;
	private int multiAnswerFlag;
	private int paritipateFlag;
	private int attachFlag;
	private int modifyFlag;
	private int draftFlag;
	private int responseFlag;
	private int totalUser;
	private int updateMode;
	private List<MSurveyParticipantVO> userList;
	private List<MAttachVO> attachList;
	private int mailFlag;
	private int popupFlag;
	
	public int getUpdateMode() {
		return updateMode;
	}
	
	public void setUpdateMode(int updateMode) {
		this.updateMode = updateMode;
	}
	
	public int getTotalUser() {
		return totalUser;
	}
	
	public void setTotalUser(int totalUser) {
		this.totalUser = totalUser;
	}
	
	public long getSurveyId() {
		return surveyId;
	}
	
	public void setSurveyId(long surveyId) {
		this.surveyId = surveyId;
	}
	
	public String getCompanyId() {
		return companyId;
	}
	
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public String getTitle() {
		return title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getPurpose() {
		return purpose;
	}
	
	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}
	
	public String getCreatorId() {
		return creatorId;
	}
	
	public void setCreatorId(String creatorId) {
		this.creatorId = creatorId;
	}
	
	public String getCreateDate() {
		return createDate;
	}
	
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	
	public String getUpdateDate() {
		return updateDate;
	}
	
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	
	public String getStartDate() {
		return startDate;
	}
	
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	
	public String getEndDate() {
		return endDate;
	}
	
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	
	public String getCreatorName1() {
		return creatorName1;
	}
	
	public void setCreatorName1(String creatorName1) {
		this.creatorName1 = creatorName1;
	}
	
	public String getCreatorName2() {
		return creatorName2;
	}
	
	public void setCreatorName2(String creatorName2) {
		this.creatorName2 = creatorName2;
	}
	
	public String getDeleteUser() {
		return deleteUser;
	}
	
	public void setDeleteUser(String deleteUser) {
		this.deleteUser = deleteUser;
	}
	
	public String getUpdateUser() {
		return updateUser;
	}
	
	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}
	
	public int getUseStatus() {
		return useStatus;
	}
	
	public void setUseStatus(int useStatus) {
		this.useStatus = useStatus;
	}
	
	public int getOpenDays() {
		return openDays;
	}
	
	public void setOpenDays(int openDays) {
		this.openDays = openDays;
	}
	
	public int getResultPublicFlag() {
		return resultPublicFlag;
	}
	
	public void setResultPublicFlag(int resultPublicFlag) {
		this.resultPublicFlag = resultPublicFlag;
	}
	
	public int getAnonymousFlag() {
		return anonymousFlag;
	}
	
	public void setAnonymousFlag(int anonymousFlag) {
		this.anonymousFlag = anonymousFlag;
	}
	
	public int getMultiAnswerFlag() {
		return multiAnswerFlag;
	}
	
	public void setMultiAnswerFlag(int multiAnswerFlag) {
		this.multiAnswerFlag = multiAnswerFlag;
	}
	
	public int getParitipateFlag() {
		return paritipateFlag;
	}
	
	public void setParitipateFlag(int paritipateFlag) {
		this.paritipateFlag = paritipateFlag;
	}
	
	public int getAttachFlag() {
		return attachFlag;
	}
	
	public void setAttachFlag(int attachFlag) {
		this.attachFlag = attachFlag;
	}
	
	public String getCreatorName() {
		return creatorName;
	}
	
	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
	}
	
	public List<MAttachVO> getAttachList() {
		return attachList;
	}
	
	public void setAttachList(List<MAttachVO> attachList) {
		this.attachList = attachList;
	}
	
	public List<MSurveyParticipantVO> getUserList() {
		return userList;
	}
	
	public void setUserList(List<MSurveyParticipantVO> userList) {
		this.userList = userList;
	}
	
	public int getModifyFlag() {
		return modifyFlag;
	}
	
	public void setModifyFlag(int modifyFlag) {
		this.modifyFlag = modifyFlag;
	}
	
	public int getDraftFlag() {
		return draftFlag;
	}
	
	public void setDraftFlag(int draftFlag) {
		this.draftFlag = draftFlag;
	}
	
	public int getResponseFlag() {
		return responseFlag;
	}
	
	public void setResponseFlag(int responseFlag) {
		this.responseFlag = responseFlag;
	}

	public int getMailFlag() {
		return mailFlag;
	}

	public void setMailFlag(int mailFlag) {
		this.mailFlag = mailFlag;
	}

	public int getPopupFlag() {
		return popupFlag;
	}

	public void setPopupFlag(int popupFlag) {
		this.popupFlag = popupFlag;
	}
}
