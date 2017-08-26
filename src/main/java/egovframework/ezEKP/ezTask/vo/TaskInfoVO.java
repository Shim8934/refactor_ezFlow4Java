package egovframework.ezEKP.ezTask.vo;

import java.util.List;

public class TaskInfoVO {
	/** 업무ID */
	private String taskID;
	/** 업무원본ID */
	private String parentID;
	/** 소유자ID */
	private String ownerID;
	/** 작성자ID */
	private String creatorID;
	/** 작성자이름 */
	private String creatorName;
	/** 작성자이름 */
	private String creatorName1;
	/** 작성자이름2 */
	private String creatorName2;
	/** 작성일 */
	private String createDate;
	/** 업무상태(시작안함, 진행중, 완료, 지연) */
	private int taskStatus;
	/** 완료율*/
	private int completeRate;
	/** 완료일 */
	private String completeDate;
	/** 중요도 */
	private int importance;
	/** 공유여부 */
	private String hasShare;
	/** 첨부유무 */
	private String hasAttach;
	/** 메모유무 */
	private String hasComment;
	/** 시작일 */
	private String startDate;
	/** 완료기한 */
	private String endDate;
	
	/** 제목 */
	private String title;
	/** 지시사항 본문경로 */
	private String contentPath;
	/** 업무구분(1:개인, 2:지시, 3:협조) */
	private String taskType;
	/** */
	private String updateTime;
	/** N으로 그냥 고정(사용하는부분 모르겠음)*/
	private String newAnswer;
	/** N으로 그냥 고정(사용하는부분 모르겠음)*/
	private String newRefer;
	/** 담당자ID */
	private String personID;
	/** 담당자 이름 */
	private String personName;
	/** 담당자 이름2*/
	private String personName2;
	/** 담당자 부서명*/
	private String personDeptName;
	/** 담당자 부서명2*/
	private String personDeptName2;
	/** 담당자 email */
	private String personEmail;
	/** 진행사항 파일첨부*/
	private String personAttach;
	/** 진행사항 본문경로 */
	private String personContentPath;
	/** 공유자관련 VO */
	private List<TaskShareVO> shareList;
	
	/** */
	private String taskPersonID;
	/** */
	private String taskPersonName;
	/** */
	private String taskPersonName2;
	/** 테넌트ID*/
	private int tenantID;
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
	public String getPersonName2() {
		return personName2;
	}
	public void setPersonName2(String personName2) {
		this.personName2 = personName2;
	}
	public String getPersonDeptName() {
		return personDeptName;
	}
	public void setPersonDeptName(String personDeptName) {
		this.personDeptName = personDeptName;
	}
	public String getPersonDeptName2() {
		return personDeptName2;
	}
	public void setPersonDeptName2(String personDeptName2) {
		this.personDeptName2 = personDeptName2;
	}
	public String getPersonEmail() {
		return personEmail;
	}
	public void setPersonEmail(String personEmail) {
		this.personEmail = personEmail;
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
	public List<TaskShareVO> getShareList() {
		return shareList;
	}
	public void setShareList(List<TaskShareVO> shareList) {
		this.shareList = shareList;
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
	public String getTaskPersonName2() {
		return taskPersonName2;
	}
	public void setTaskPersonName2(String taskPersonName2) {
		this.taskPersonName2 = taskPersonName2;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
}
