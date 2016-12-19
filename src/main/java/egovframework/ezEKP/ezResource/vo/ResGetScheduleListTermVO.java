package egovframework.ezEKP.ezResource.vo;

public class ResGetScheduleListTermVO {
	/** 순번*/
	private int num;
	/** 부모 일정번호*/
	private int pNum;
	/** 자원 예약 게시판ID*/
	private String ownerID;
	/** 제목*/
	private String title;
	/** 위치*/
	private String location;
	/** 시간표시형식*/
	private String timeDisplay;
	/** 게시기간-부터*/
	private String startDate;
	/** 게시기간-까지*/
	private String endDate;
	/** 사용안함*/
	private String alertTime;
	/** 반복 일정 여부*/
	private String reFlag;
	/** 응답여부*/
	private String gResFlag;
	/** 등록자 사번*/
	private String writerID;
	/** 본문내용*/
	private String content;
	/** 중요도*/
	private String importance;
	/** 참가자리스트*/
	private String entryList;
	/** 하루종일*/
	private String allDay;
	/** 자원 등록일*/
	private String writeDay;
	/** 첨부파일여부*/
	private String attachFlag;
	/** 특정순번*/
	private int characterID;
	/** 승인여부*/
	private String approveFlag;
	/** 사용자명*/
	private String ownerNm;
	/** 부서먕*/
	private String deptNm;
	/** 직급*/
	private String jobTitle;
	/** 영문직급*/
	private String jobTitle2;
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getpNum() {
		return pNum;
	}
	public void setpNum(int pNum) {
		this.pNum = pNum;
	}
	public String getOwnerID() {
		return ownerID;
	}
	public void setOwnerID(String ownerID) {
		this.ownerID = ownerID;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getTimeDisplay() {
		return timeDisplay;
	}
	public void setTimeDisplay(String timeDisplay) {
		this.timeDisplay = timeDisplay;
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
	public String getAlertTime() {
		return alertTime;
	}
	public void setAlertTime(String alertTime) {
		this.alertTime = alertTime;
	}
	public String getReFlag() {
		return reFlag;
	}
	public void setReFlag(String reFlag) {
		this.reFlag = reFlag;
	}
	public String getgResFlag() {
		return gResFlag;
	}
	public void setgResFlag(String gResFlag) {
		this.gResFlag = gResFlag;
	}
	public String getWriterID() {
		return writerID;
	}
	public void setWriterID(String writerID) {
		this.writerID = writerID;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getImportance() {
		return importance;
	}
	public void setImportance(String importance) {
		this.importance = importance;
	}
	public String getEntryList() {
		return entryList;
	}
	public void setEntryList(String entryList) {
		this.entryList = entryList;
	}
	public String getAllDay() {
		return allDay;
	}
	public void setAllDay(String allDay) {
		this.allDay = allDay;
	}
	public String getWriteDay() {
		return writeDay;
	}
	public void setWriteDay(String writeDay) {
		this.writeDay = writeDay;
	}
	public String getAttachFlag() {
		return attachFlag;
	}
	public void setAttachFlag(String attachFlag) {
		this.attachFlag = attachFlag;
	}
	public int getCharacterID() {
		return characterID;
	}
	public void setCharacterID(int characterID) {
		this.characterID = characterID;
	}
	public String getApproveFlag() {
		return approveFlag;
	}
	public void setApproveFlag(String approveFlag) {
		this.approveFlag = approveFlag;
	}
	public String getOwnerNm() {
		return ownerNm;
	}
	public void setOwnerNm(String ownerNm) {
		this.ownerNm = ownerNm;
	}
	public String getDeptNm() {
		return deptNm;
	}
	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}
	public String getJobTitle() {
		return jobTitle;
	}
	public void setJobTitle(String jobTitle) {
		this.jobTitle = jobTitle;
	}
	public String getJobTitle2() {
		return jobTitle2;
	}
	public void setJobTitle2(String jobTitle2) {
		this.jobTitle2 = jobTitle2;
	}
}
