package egovframework.ezEKP.ezOrgan.vo;

public class OrganProxyVO {
	/** 사용자아이디*/
	private String userID;
	/** 대리수신자이름*/
	private String proxyUserName;
	/** 대리수신자아이디*/
	private String proxyUserID;
	/** 대리수신자부서아이디*/
	private String proxyUserDeptID;
	/** 끝날짜*/
	private String endDate;
	/** 시작날짜*/
	private String startDate;
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getProxyUserName() {
		return proxyUserName;
	}
	public void setProxyUserName(String proxyUserName) {
		this.proxyUserName = proxyUserName;
	}
	public String getProxyUserID() {
		return proxyUserID;
	}
	public void setProxyUserID(String proxyUserID) {
		this.proxyUserID = proxyUserID;
	}
	public String getProxyUserDeptID() {
		return proxyUserDeptID;
	}
	public void setProxyUserDeptID(String proxyUserDeptID) {
		this.proxyUserDeptID = proxyUserDeptID;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
}
