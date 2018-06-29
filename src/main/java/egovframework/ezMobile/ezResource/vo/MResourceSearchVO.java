package egovframework.ezMobile.ezResource.vo;

public class MResourceSearchVO {
	/** 자원ID*/
	private String ownerId;
	/** 순번*/
	private int num;
	/** parent일정번호*/
	private int pNum;
	/** 회사Id*/
	private String companyId;
	/** 부서Id*/
	private String deptId;
	/** 등록자사번*/
	private String writerId;
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
	private int characterId;
	/** 첨부파일여부*/
	private String attachFlag;
	/** 일정공개여부*/
	private String publicFlag;
	/** 승인여부*/
	private String approveFlag;
	/** 스케줄Id*/
	private String scheduleId;
	/** 등록자부서명*/
	private String deptNm;
	/** 영문부서명*/
	private String deptNm2;
	/** 등록자이름*/
	private String ownerNm;
	/** 영문사용자명*/
	private String ownerNm2;
	/** 직급*/
	private String jobTitle;
	/** 영문직급*/
	private String jobTitle2;
	/** 작성자이름*/
	private String writerName;
	/** 작성자부서*/
	private String writerDept;	
	/** 자원타입 all/each */
	private String type;
	/** 사용자Id*/
	private String userId;	
	/** 승인여부*/
	private String apporve;	
	/** 자원관리Id*/
	private String brdId;	
	/** 자원관리회사*/
	private String brdCompany;
	/** 첫번째 작성일*/
	private String firstWriteDay;	
	/** 마지막 작엇일 */
	private String lastWriteDay;
	/** 자원명 */
	private String brdNm;

	public String getBrdNm() {
		return brdNm;
	}
	public void setBrdNm(String brdNm) {
		this.brdNm = brdNm;
	}
		
	public String getFirstWriteDay() {
		return firstWriteDay;
	}
	public void setFirstWriteDay(String firstWriteDay) {
		this.firstWriteDay = firstWriteDay;
	}
	public String getLastWriteDay() {
		return lastWriteDay;
	}
	public void setLastWriteDay(String lastWriteDay) {
		this.lastWriteDay = lastWriteDay;
	}
	public String getBrdId() {
		return brdId;
	}
	public void setBrdId(String brdId) {
		this.brdId = brdId;
	}
	public String getBrdCompany() {
		return brdCompany;
	}
	public void setBrdCompany(String brdCompany) {
		this.brdCompany = brdCompany;
	}
	public String getApporve() {
		return apporve;
	}
	public void setApporve(String apporve) {
		this.apporve = apporve;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getWriterDept() {
		return writerDept;
	}
	public void setWriterDept(String writerDept) {
		this.writerDept = writerDept;
	}
	public String getOwnerId() {
		return ownerId;
	}
	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
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
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public String getDeptId() {
		return deptId;
	}
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
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
	public int getCharacterId() {
		return characterId;
	}
	public void setCharacterId(int characterId) {
		this.characterId = characterId;
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
	public String getScheduleId() {
		return scheduleId;
	}
	public void setScheduleId(String scheduleId) {
		this.scheduleId = scheduleId;
	}
	public String getDeptNm() {
		return deptNm;
	}
	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}
	public String getDeptNm2() {
		return deptNm2;
	}
	public void setDeptNm2(String deptNm2) {
		this.deptNm2 = deptNm2;
	}
	public String getOwnerNm() {
		return ownerNm;
	}
	public void setOwnerNm(String ownerNm) {
		this.ownerNm = ownerNm;
	}
	public String getOwnerNm2() {
		return ownerNm2;
	}
	public void setOwnerNm2(String ownerNm2) {
		this.ownerNm2 = ownerNm2;
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
