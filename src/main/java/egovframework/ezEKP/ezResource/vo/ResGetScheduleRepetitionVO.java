package egovframework.ezEKP.ezResource.vo;

public class ResGetScheduleRepetitionVO {
	/** 자원예약게시판ID*/
	private String ownerID;
	/** 순번*/
	private int num;
	/** 회사ID*/
	private String companyID;
	/** 반복시작일*/
	private String startDateTime;
	/** 반복종료일*/
	private String endDateTime;
	/** 등록자반복방법*/
	private String reWay;
	/** 반복 일/주/개월 수*/
	private String reNum;
	/** 반복 일*/
	private String reDay;
	/** 반복 요일*/
	private String reYoil;
	/** 반복 월*/
	private String reMonth;
	/** 반복 번째*/
	private String reOrd;
	/** 반복 끝 범위 여부*/
	private String endFlag;
	/** 반복 회수*/
	private String reCount;
	/** 하루종일 여부*/
	private String allDay;
	
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
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public String getStartDateTime() {
		return startDateTime;
	}
	public void setStartDateTime(String startDateTime) {
		this.startDateTime = startDateTime;
	}
	public String getEndDateTime() {
		return endDateTime;
	}
	public void setEndDateTime(String endDateTime) {
		this.endDateTime = endDateTime;
	}
	public String getReWay() {
		return reWay;
	}
	public void setReWay(String reWay) {
		this.reWay = reWay;
	}
	public String getReNum() {
		return reNum;
	}
	public void setReNum(String reNum) {
		this.reNum = reNum;
	}
	public String getReDay() {
		return reDay;
	}
	public void setReDay(String reDay) {
		this.reDay = reDay;
	}
	public String getReYoil() {
		return reYoil;
	}
	public void setReYoil(String reYoil) {
		this.reYoil = reYoil;
	}
	public String getReMonth() {
		return reMonth;
	}
	public void setReMonth(String reMonth) {
		this.reMonth = reMonth;
	}
	public String getReOrd() {
		return reOrd;
	}
	public void setReOrd(String reOrd) {
		this.reOrd = reOrd;
	}
	public String getEndFlag() {
		return endFlag;
	}
	public void setEndFlag(String endFlag) {
		this.endFlag = endFlag;
	}
	public String getReCount() {
		return reCount;
	}
	public void setReCount(String reCount) {
		this.reCount = reCount;
	}
	public String getAllDay() {
		return allDay;
	}
	public void setAllDay(String allDay) {
		this.allDay = allDay;
	}
	
}
