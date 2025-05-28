package egovframework.ezMobile.ezResource.vo;

public class MResourceScheduleVO {
	/** 자원예약게시판ID*/
	private String ownerId;
	/** 순번*/
	private String num;
	/** parent일정번호*/
	private String pNum;
	/** 회사Id*/
	private String companyId;
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
	/** 자원아이디*/
	private String resId;
	/** 사용자아이디*/
	private String userId;
	/** 자원명 */
	private String brdNm;
	/** 자원명 */
	private String brdNm2;
	/** 캘린더 날짜*/
	private String date;
	/** 캘린더 값*/
	private String value;
	/** 승인자원여부 값*/
	private String resApproveFlag;
	/** 중복여부 값*/
	private String repeatYn;
	/** 승인권한 여부 값*/
	private String apprAuthYn;
	/** 자원 관리자 id */
	private String managerIds;
	
	public String getApprAuthYn() {
		return apprAuthYn;
	}
	public void setApprAuthYn(String apprAuthYn) {
		this.apprAuthYn = apprAuthYn;
	}
	public String getBrdNm2() {
		return brdNm2;
	}
	public void setBrdNm2(String brdNm2) {
		this.brdNm2 = brdNm2;
	}
	
	public String getRepeatYn() {
		return repeatYn;
	}
	public void setRepeatYn(String repeatYn) {
		this.repeatYn = repeatYn;
	}
	public String getResApproveFlag() {
		return resApproveFlag;
	}
	public void setResApproveFlag(String resApproveFlag) {
		this.resApproveFlag = resApproveFlag;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}

	public String getBrdNm() {
		return brdNm;
	}
	public void setBrdNm(String brdNm) {
		this.brdNm = brdNm;
	}
	
	
	
	public String getResId() {
		return resId;
	}
	public void setResId(String resId) {
		this.resId = resId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getTenantId() {
		return tenantId;
	}
	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}
	/** 구분아이디*/
	private String tenantId;
	
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String getpNum() {
		return pNum;
	}
	public void setpNum(String pNum) {
		this.pNum = pNum;
	}
	public String getOwnerId() {
		return ownerId;
	}
	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
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
	public String getManagerIds() {
		return managerIds;
	}
	public void setManagerIds(String managerIds) {
		this.managerIds = managerIds;
	}
	
}
