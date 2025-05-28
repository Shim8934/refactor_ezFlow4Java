package egovframework.ezEKP.ezSchedule.vo;

public class ScheduleInfoVO {
	private String scheduleId;
	
	private String parentId;
	
	private String ownerId;

	private String ownerName;

	private String ownerName2;

	private String creatorId;

	private String creatorName;

	private String creatorName2;

	private String createDate;

	private String modifierId;

	private String modifierName;

	private String modifierName2;

	private String modifyDate;

	private String scheduleType;

	private String importance;

	private String hasAttendant;

	private String hasAttach;

	private String hasComment;

	private String isReadOnly;

	private String isPublic;

	private String dateType;

	private String startDate;

	private String endDate;

	private String repetition;

	private String repetitionDel;

	private String title;

	private String location;
	
	private String content;

	private String contentPath;

	private String groupName;
	
	private String companyid;	

	private int repeatCount;
	
	private String realEndDate;
	
	/** 2021-11-26 홍승비 - 일정완료 데이터 관련 필드 추가 */
	private String completeFG; // 일정 완료된 경우 Y, 아닌 경우 N
	private String isAllRep; // 단일 또는 특정 반복일정의 완료인 경우 N, 전체일정 완료인 경우 Y
	private String repStartDate; // 일정완료 레코드의 일정 시작일 (YYYY-MM-DD HH:mm:SS)

	private String scheduleFlag;
	
	private String googleId;
	
	private boolean isRepetitionChanged;
	
	private String repetitionDelIds;
	
	private String googleRecurringEventId;
	
	private String googleOriginalStartTime;
	
	private long repeatedScheduleOffset;
	
	private String groupColor;

	private String showTop;

	public String getRealEndDate() {
		return realEndDate;
	}

	public void setRealEndDate(String realEndDate) {
		this.realEndDate = realEndDate;
	}

	/**
	 * @return the scheduleId
	 */
	public String getScheduleId() {
		return scheduleId;
	}

	/**
	 * @param scheduleId the scheduleId to set
	 */
	public void setScheduleId(String scheduleId) {
		this.scheduleId = scheduleId;
	}

	/**
	 * @return the parentId
	 */
	public String getParentId() {
		return parentId;
	}

	/**
	 * @param parentId the parentId to set
	 */
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	/**
	 * @return the ownerId
	 */
	public String getOwnerId() {
		return ownerId;
	}

	/**
	 * @param ownerId the ownerId to set
	 */
	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}

	/**
	 * @return the ownerName
	 */
	public String getOwnerName() {
		return ownerName;
	}

	/**
	 * @param ownerName the ownerName to set
	 */
	public void setOwnerName(String ownerName) {
		this.ownerName = ownerName;
	}

	/**
	 * @return the ownerName2
	 */
	public String getOwnerName2() {
		return ownerName2;
	}

	/**
	 * @param ownerName2 the ownerName2 to set
	 */
	public void setOwnerName2(String ownerName2) {
		this.ownerName2 = ownerName2;
	}

	/**
	 * @return the creatorId
	 */
	public String getCreatorId() {
		return creatorId;
	}

	/**
	 * @param creatorId the creatorId to set
	 */
	public void setCreatorId(String creatorId) {
		this.creatorId = creatorId;
	}

	/**
	 * @return the creatorName
	 */
	public String getCreatorName() {
		return creatorName;
	}

	/**
	 * @param creatorName the creatorName to set
	 */
	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
	}

	/**
	 * @return the creatorName2
	 */
	public String getCreatorName2() {
		return creatorName2;
	}

	/**
	 * @param creatorName2 the creatorName2 to set
	 */
	public void setCreatorName2(String creatorName2) {
		this.creatorName2 = creatorName2;
	}

	/**
	 * @return the createDate
	 */
	public String getCreateDate() {
		return createDate;
	}

	/**
	 * @param createDate the createDate to set
	 */
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	/**
	 * @return the modifierId
	 */
	public String getModifierId() {
		return modifierId;
	}

	/**
	 * @param modifierId the modifierId to set
	 */
	public void setModifierId(String modifierId) {
		this.modifierId = modifierId;
	}

	/**
	 * @return the modifierName
	 */
	public String getModifierName() {
		return modifierName;
	}

	/**
	 * @param modifierName the modifierName to set
	 */
	public void setModifierName(String modifierName) {
		this.modifierName = modifierName;
	}

	/**
	 * @return the modifierName2
	 */
	public String getModifierName2() {
		return modifierName2;
	}

	/**
	 * @param modifierName2 the modifierName2 to set
	 */
	public void setModifierName2(String modifierName2) {
		this.modifierName2 = modifierName2;
	}

	/**
	 * @return the modifyDate
	 */
	public String getModifyDate() {
		return modifyDate;
	}

	/**
	 * @param modifyDate the modifyDate to set
	 */
	public void setModifyDate(String modifyDate) {
		this.modifyDate = modifyDate;
	}

	/**
	 * @return the scheduleType
	 */
	public String getScheduleType() {
		return scheduleType;
	}

	/**
	 * @param scheduleType the scheduleType to set
	 */
	public void setScheduleType(String scheduleType) {
		this.scheduleType = scheduleType;
	}

	/**
	 * @return the importance
	 */
	public String getImportance() {
		return importance;
	}

	/**
	 * @param importance the importance to set
	 */
	public void setImportance(String importance) {
		this.importance = importance;
	}

	/**
	 * @return the hasAttendant
	 */
	public String getHasAttendant() {
		return hasAttendant;
	}

	/**
	 * @param hasAttendant the hasAttendant to set
	 */
	public void setHasAttendant(String hasAttendant) {
		this.hasAttendant = hasAttendant;
	}

	/**
	 * @return the hasAttach
	 */
	public String getHasAttach() {
		return hasAttach;
	}

	/**
	 * @param hasAttach the hasAttach to set
	 */
	public void setHasAttach(String hasAttach) {
		this.hasAttach = hasAttach;
	}

	/**
	 * @return the hasComment
	 */
	public String getHasComment() {
		return hasComment;
	}

	/**
	 * @param hasComment the hasComment to set
	 */
	public void setHasComment(String hasComment) {
		this.hasComment = hasComment;
	}

	/**
	 * @return the isReadOnly
	 */
	public String getIsReadOnly() {
		return isReadOnly;
	}

	/**
	 * @param isReadOnly the isReadOnly to set
	 */
	public void setIsReadOnly(String isReadOnly) {
		this.isReadOnly = isReadOnly;
	}

	/**
	 * @return the isPublic
	 */
	public String getIsPublic() {
		return isPublic;
	}

	/**
	 * @param isPublic the isPublic to set
	 */
	public void setIsPublic(String isPublic) {
		this.isPublic = isPublic;
	}

	/**
	 * @return the dateType
	 */
	public String getDateType() {
		return dateType;
	}

	/**
	 * @param dateType the dateType to set
	 */
	public void setDateType(String dateType) {
		this.dateType = dateType;
	}

	/**
	 * @return the startDate
	 */
	public String getStartDate() {
		return startDate;
	}

	/**
	 * @param startDate the startDate to set
	 */
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	/**
	 * @return the endDate
	 */
	public String getEndDate() {
		return endDate;
	}

	/**
	 * @param endDate the endDate to set
	 */
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	/**
	 * @return the repetition
	 */
	public String getRepetition() {
		return repetition;
	}

	/**
	 * @param repetition the repetition to set
	 */
	public void setRepetition(String repetition) {
		this.repetition = repetition;
	}

	/**
	 * @return the repetitionDel
	 */
	public String getRepetitionDel() {
		return repetitionDel;
	}

	/**
	 * @param repetitionDel the repetitionDel to set
	 */
	public void setRepetitionDel(String repetitionDel) {
		this.repetitionDel = repetitionDel;
	}

	/**
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * @param title the title to set
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * @return the location
	 */
	public String getLocation() {
		return location;
	}

	/**
	 * @param location the location to set
	 */
	public void setLocation(String location) {
		this.location = location;
	}

	/**
	 * @return the contentPath
	 */
	public String getContentPath() {
		return contentPath;
	}

	/**
	 * @param contentPath the contentPath to set
	 */
	public void setContentPath(String contentPath) {
		this.contentPath = contentPath;
	}

	/**
	 * @return the groupName
	 */
	public String getGroupName() {
		return groupName;
	}

	/**
	 * @param groupName the groupName to set
	 */
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public int getRepeatCount() {
		return repeatCount;
	}

	public void setRepeatCount(int repeatCount) {
		this.repeatCount = repeatCount;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	public String getCompanyid() {
		return companyid;
	}

	public void setCompanyid(String companyid) {
		this.companyid = companyid;
	}
	
	public String getScheduleFlag() {
		return scheduleFlag;
	}

	public void setScheduleFlag(String scheduleFlag) {
		this.scheduleFlag = scheduleFlag;
	}
	
	public String getGoogleId() {
		return googleId;
	}

	public void setGoogleId(String googleId) {
		this.googleId = googleId;
	}
	
	public boolean isRepetitionChanged() {
		return isRepetitionChanged;
	}

	public void setRepetitionChanged(boolean isRepetitionChanged) {
		this.isRepetitionChanged = isRepetitionChanged;
	}
	
	public String getRepetitionDelIds() {
		return repetitionDelIds;
	}

	public void setRepetitionDelIds(String repetitionDelIds) {
		this.repetitionDelIds = repetitionDelIds;
	}
	
	public String getGoogleRecurringEventId() {
		return googleRecurringEventId;
	}

	public void setGoogleRecurringEventId(String googleRecurringEventId) {
		this.googleRecurringEventId = googleRecurringEventId;
	}
	
	public String getGoogleOriginalStartTime() {
		return googleOriginalStartTime;
	}

	public void setGoogleOriginalStartTime(String googleOriginalStartTime) {
		this.googleOriginalStartTime = googleOriginalStartTime;
	}
	
	public long getRepeatedScheduleOffset() {
		return repeatedScheduleOffset;
	}

	public void setRepeatedScheduleOffset(long repeatedScheduleOffset) {
		this.repeatedScheduleOffset = repeatedScheduleOffset;
	}

	public String getCompleteFG() {
		return completeFG;
	}

	public void setCompleteFG(String completeFG) {
		this.completeFG = completeFG;
	}

	public String getIsAllRep() {
		return isAllRep;
	}

	public void setIsAllRep(String isAllRep) {
		this.isAllRep = isAllRep;
	}

	public String getRepStartDate() {
		return repStartDate;
	}

	public void setRepStartDate(String repStartDate) {
		this.repStartDate = repStartDate;
	}
	
	public String getGroupColor() {
		return groupColor;
	}

	public void setGroupColor(String groupColor) {
		this.groupColor = groupColor;
	}

	public String getShowTop() { return showTop; }

	public void setShowTop(String showTop) { this.showTop = showTop; }

	@Override
	public String toString() {
		return "ScheduleInfoVO [scheduleId=" + scheduleId + ", parentId="
				+ parentId + ", ownerId=" + ownerId + ", ownerName="
				+ ownerName + ", ownerName2=" + ownerName2 + ", creatorId="
				+ creatorId + ", creatorName=" + creatorName
				+ ", creatorName2=" + creatorName2 + ", createDate="
				+ createDate + ", modifierId=" + modifierId + ", modifierName="
				+ modifierName + ", modifierName2=" + modifierName2
				+ ", modifyDate=" + modifyDate + ", scheduleType="
				+ scheduleType + ", importance=" + importance
				+ ", hasAttendant=" + hasAttendant + ", hasAttach=" + hasAttach
				+ ", hasComment=" + hasComment + ", isReadOnly=" + isReadOnly
				+ ", isPublic=" + isPublic + ", dateType=" + dateType
				+ ", startDate=" + startDate + ", endDate=" + endDate
				+ ", repetition=" + repetition + ", repetitionDel="
				+ repetitionDel + ", title=" + title + ", location=" + location
				+ ", content=" + content + ", contentPath=" + contentPath
				+ ", groupName=" + groupName + ", companyid=" + companyid
				+ ", repeatCount=" + repeatCount + ", completeFG=" + completeFG
				+ ", isAllRep=" + isAllRep + ", repStartDate=" + repStartDate
				+ ", groupColor=" + groupColor + "]";
	}

}
