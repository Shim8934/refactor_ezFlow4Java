package egovframework.ezEKP.ezResource.vo;

public class ResGetRepResourceVO {
	/** 자원예약게시판ID*/
	private String ownerID;
	/** 순번*/
	private int num;
	/** parent일정번호*/
	private int pNum;
	/** 회사ID*/
	private String companyID;
	/** 등록자사번*/
	private String writerID;
	/** 등록자부서명*/
	private String deptNm;
	/** 등록자이름*/
	private String ownerNm;
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
	/** 하루종일*/
	private String allDay;
	/** 사용안함*/
	private String alertTime;
	/** 본문내용*/
	private String content;
	/** 중요도*/
	private String importance;
	/** 반복 일정 여부*/
	private String reFlag;
	/** 응답여부*/
	private String gresFlag;
	/** 자원등록일*/
	private String writeDay;
	/** 참가자리스트*/
	private String entryList;
	/** 특정순번*/
	private int characterID;
	/** 첨부파일여부*/
	private String attachFlag;
	/** 일정공개여부*/
	private String publicFlag;
	/** 승인여부*/
	private String approveFlag;
	
	public String getOwnerID() {
		return ownerID;
	}
	public void setOwnerID(String ownerID) {
		this.ownerID = ownerID;
	}
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
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public String getWriterID() {
		return writerID;
	}
	public void setWriterID(String writerID) {
		this.writerID = writerID;
	}
	public String getDeptNm() {
		return deptNm;
	}
	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}
	public String getOwnerNm() {
		return ownerNm;
	}
	public void setOwnerNm(String ownerNm) {
		this.ownerNm = ownerNm;
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
	public String getAllDay() {
		return allDay;
	}
	public void setAllDay(String allDay) {
		this.allDay = allDay;
	}
	public String getAlertTime() {
		return alertTime;
	}
	public void setAlertTime(String alertTime) {
		this.alertTime = alertTime;
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
	public String getReFlag() {
		return reFlag;
	}
	public void setReFlag(String reFlag) {
		this.reFlag = reFlag;
	}
	public String getGresFlag() {
		return gresFlag;
	}
	public void setGresFlag(String gresFlag) {
		this.gresFlag = gresFlag;
	}
	public String getWriteDay() {
		return writeDay;
	}
	public void setWriteDay(String writeDay) {
		this.writeDay = writeDay;
	}
	public String getEntryList() {
		return entryList;
	}
	public void setEntryList(String entryList) {
		this.entryList = entryList;
	}
	public int getCharacterID() {
		return characterID;
	}
	public void setCharacterID(int characterID) {
		this.characterID = characterID;
	}
	public String getAttachFlag() {
		return attachFlag;
	}
	public void setAttachFlag(String attachFlag) {
		this.attachFlag = attachFlag;
	}
	public String getPublicFlag() {
		return publicFlag;
	}
	public void setPublicFlag(String publicFlag) {
		this.publicFlag = publicFlag;
	}
	public String getApproveFlag() {
		return approveFlag;
	}
	public void setApproveFlag(String approveFlag) {
		this.approveFlag = approveFlag;
	}
}
