package egovframework.ezEKP.ezTask.vo;

public class TaskInfoVO {
	/** 업무ID*/
	String taskID;
	/** 공유된 기존업무ID*/
	String parentID;
	/** 담당자ID*/
	String ownerID;
	/** 작성자ID*/
	String creatorID;
	/** 작성자이름*/
	String creatorName;
	/** 작성일*/
	String createDate;
	/** 업무상태*/
	int taskStatus;
	/** 완료율*/
	int completeRate;
	/** */
	String completeDate;
	/** 중요도 */
	int importance;
	/** 업무공유*/
	String hasShare;
	/** 첨부파일*/
	String hasAttach;
	/** 의견*/
	String hasComment;
	/** 시작일*/
	String startDate;
	/** 완료기한*/
	String endDate;
	
	/////반복설정 관련정보들 필요없으면 추후 삭제
	/** */
	String repetition;
	/** */
	String repetitionDelete;
	/** */
	String repetitionStatus;
	
	/** 제목 */
	String title;
	/** */
	String contentPath;
	/** 업무구분(1:개인, 2:지시,협조)*/
	String taskType;
	/** */
	String updateTime;
	/** */
	String newAnswer;
	/** */
	String newRefer;
	/** */
	String personID;
	/** */
	String personName;
	/** */
	String personDeptName;
	/** */
	String personAttach;
	/** */
	String personContentPath;
	/** */
	String taskPersonID;
	/** */
	String taskPersonName;
	/** 테넌트ID*/
	int tenantID;
	
	public String getTaskID() {
		return taskID;
	}
	public void setTaskID(String taskID) {
		this.taskID = taskID;
	}
	public String getParentID() {
		return parentID;
	}
	public void setParentID(String parentID) {
		this.parentID = parentID;
	}
	public String getOwnerID() {
		return ownerID;
	}
	public void setOwnerID(String ownerID) {
		this.ownerID = ownerID;
	}
	public String getCreatorID() {
		return creatorID;
	}
	public void setCreatorID(String creatorID) {
		this.creatorID = creatorID;
	}
	public String getCreatorName() {
		return creatorName;
	}
	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public int getTaskStatus() {
		return taskStatus;
	}
	public void setTaskStatus(int taskStatus) {
		this.taskStatus = taskStatus;
	}
	public int getCompleteRate() {
		return completeRate;
	}
	public void setCompleteRate(int completeRate) {
		this.completeRate = completeRate;
	}
	public String getCompleteDate() {
		return completeDate;
	}
	public void setCompleteDate(String completeDate) {
		this.completeDate = completeDate;
	}
	public int getImportance() {
		return importance;
	}
	public void setImportance(int importance) {
		this.importance = importance;
	}
	public String getHasShare() {
		return hasShare;
	}
	public void setHasShare(String hasShare) {
		this.hasShare = hasShare;
	}
	public String getHasAttach() {
		return hasAttach;
	}
	public void setHasAttach(String hasAttach) {
		this.hasAttach = hasAttach;
	}
	public String getHasComment() {
		return hasComment;
	}
	public void setHasComment(String hasComment) {
		this.hasComment = hasComment;
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
	public String getRepetition() {
		return repetition;
	}
	public void setRepetition(String repetition) {
		this.repetition = repetition;
	}
	public String getRepetitionDelete() {
		return repetitionDelete;
	}
	public void setRepetitionDelete(String repetitionDelete) {
		this.repetitionDelete = repetitionDelete;
	}
	public String getRepetitionStatus() {
		return repetitionStatus;
	}
	public void setRepetitionStatus(String repetitionStatus) {
		this.repetitionStatus = repetitionStatus;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContentPath() {
		return contentPath;
	}
	public void setContentPath(String contentPath) {
		this.contentPath = contentPath;
	}
	public String getTaskType() {
		return taskType;
	}
	public void setTaskType(String taskType) {
		this.taskType = taskType;
	}
	public String getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}
	public String getNewAnswer() {
		return newAnswer;
	}
	public void setNewAnswer(String newAnswer) {
		this.newAnswer = newAnswer;
	}
	public String getNewRefer() {
		return newRefer;
	}
	public void setNewRefer(String newRefer) {
		this.newRefer = newRefer;
	}
	public String getPersonID() {
		return personID;
	}
	public void setPersonID(String personID) {
		this.personID = personID;
	}
	public String getPersonName() {
		return personName;
	}
	public void setPersonName(String personName) {
		this.personName = personName;
	}
	public String getPersonDeptName() {
		return personDeptName;
	}
	public void setPersonDeptName(String personDeptName) {
		this.personDeptName = personDeptName;
	}
	public String getPersonAttach() {
		return personAttach;
	}
	public void setPersonAttach(String personAttach) {
		this.personAttach = personAttach;
	}
	public String getPersonContentPath() {
		return personContentPath;
	}
	public void setPersonContentPath(String personContentPath) {
		this.personContentPath = personContentPath;
	}
	public String getTaskPersonID() {
		return taskPersonID;
	}
	public void setTaskPersonID(String taskPersonID) {
		this.taskPersonID = taskPersonID;
	}
	public String getTaskPersonName() {
		return taskPersonName;
	}
	public void setTaskPersonName(String taskPersonName) {
		this.taskPersonName = taskPersonName;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	@Override
	public String toString() {
		return "TaskInfoVO [taskID=" + taskID + ", parentID=" + parentID
				+ ", ownerID=" + ownerID + ", creatorID=" + creatorID
				+ ", creatorName=" + creatorName + ", createDate=" + createDate
				+ ", taskStatus=" + taskStatus + ", completeRate="
				+ completeRate + ", completeDate=" + completeDate
				+ ", importance=" + importance + ", hasShare=" + hasShare
				+ ", hasAttach=" + hasAttach + ", hasComment=" + hasComment
				+ ", startDate=" + startDate + ", endDate=" + endDate
				+ ", repetition=" + repetition + ", repetitionDelete="
				+ repetitionDelete + ", repetitionStatus=" + repetitionStatus
				+ ", title=" + title + ", contentPath=" + contentPath
				+ ", taskType=" + taskType + ", updateTime=" + updateTime
				+ ", newAnswer=" + newAnswer + ", newRefer=" + newRefer
				+ ", personID=" + personID + ", personName=" + personName
				+ ", personDeptName=" + personDeptName + ", personAttach="
				+ personAttach + ", personContentPath=" + personContentPath
				+ ", taskPersonID=" + taskPersonID + ", taskPersonName="
				+ taskPersonName + ", tenantID=" + tenantID + "]";
	}
}
