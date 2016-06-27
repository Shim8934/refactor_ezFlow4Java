package egovframework.ezEKP.ezCommunity.vo;

public class CommunityCComCloseVO {
	/** 커뮤니티ID*/
	String c_ClubNo;
	/** 커뮤니티명*/
	String c_ClubName;
	/** 커뮤니티명(다국어)*/
	String c_ClubName2;
	/** 마스터ID*/
	String c_SysopID;
	/** 회사명*/
	String companyName;
	/** 폐쇄 신청 일자*/
	String applicationDate;
	/** 폐쇄 사유(CLOB)*/
	String closeReason;
	/** 폐쇄상태*/
	String closeState;
	/** 폐쇄상태(다국어)*/
	String closeState2;
	/** 사용자ID*/
	String userName;
	/** 사용자ID(다국어)*/
	String userName2;
	public String getC_ClubNo() {
		return c_ClubNo;
	}
	public void setC_ClubNo(String c_ClubNo) {
		this.c_ClubNo = c_ClubNo;
	}
	public String getC_ClubName() {
		return c_ClubName;
	}
	public void setC_ClubName(String c_ClubName) {
		this.c_ClubName = c_ClubName;
	}
	public String getC_ClubName2() {
		return c_ClubName2;
	}
	public void setC_ClubName2(String c_ClubName2) {
		this.c_ClubName2 = c_ClubName2;
	}
	public String getC_SysopID() {
		return c_SysopID;
	}
	public void setC_SysopID(String c_SysopID) {
		this.c_SysopID = c_SysopID;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public String getApplicationDate() {
		return applicationDate;
	}
	public void setApplicationDate(String applicationDate) {
		this.applicationDate = applicationDate;
	}
	public String getCloseReason() {
		return closeReason;
	}
	public void setCloseReason(String closeReason) {
		this.closeReason = closeReason;
	}
	public String getCloseState() {
		return closeState;
	}
	public void setCloseState(String closeState) {
		this.closeState = closeState;
	}
	public String getCloseState2() {
		return closeState2;
	}
	public void setCloseState2(String closeState2) {
		this.closeState2 = closeState2;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserName2() {
		return userName2;
	}
	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}
	
}
