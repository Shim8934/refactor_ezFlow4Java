package egovframework.ezEKP.ezBoard.vo;

public class BoardReadVO {
	/** 조회자아이디*/
	private String userID;
	/** 조회자이름*/
	private String userName;
	/** 조회자부서명*/
	private String userDeptName;
	/** 조회자회사명*/
	private String userCompanyName;
	/** 조회자직급*/
	private String userTitle;
	/** 조회일시*/
	private String readDate;
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserDeptName() {
		return userDeptName;
	}
	public void setUserDeptName(String userDeptName) {
		this.userDeptName = userDeptName;
	}
	public String getUserCompanyName() {
		return userCompanyName;
	}
	public void setUserCompanyName(String userCompanyName) {
		this.userCompanyName = userCompanyName;
	}
	public String getUserTitle() {
		return userTitle;
	}
	public void setUserTitle(String userTitle) {
		this.userTitle = userTitle;
	}
	public String getReadDate() {
		return readDate;
	}
	public void setReadDate(String readDate) {
		this.readDate = readDate;
	}

}
