package egovframework.ezMobile.ezApprovalG.vo;

public class MApprovalGOpinionInfoVO {
	/** 의견내용*/
	private String content;
	/** 의견종류*/
	private String opinionGB;
	/** 의견자아이디*/
	private String userID;
	/** 의견자*/
	private String userName;
	/** 의견자직위*/
	private String userJobTitle;
	/** 의견자부서*/
	private String userDeptName;
	
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserJobTitle() {
		return userJobTitle;
	}
	public void setUserJobTitle(String userJobTitle) {
		this.userJobTitle = userJobTitle;
	}
	public String getUserDeptName() {
		return userDeptName;
	}
	public void setUserDeptName(String userDeptName) {
		this.userDeptName = userDeptName;
	}
	public String getOpinionGB() {
		switch (opinionGB) {
		case "001": 
			opinionGB = "일반의견"; 
			break;
		case "002":
			opinionGB = "반송의견";
			break;
		case "003":
			opinionGB = "보류의견";
			break;
		case "004":
			opinionGB = "회송의견";
			break;
		default:
			opinionGB = "기타의견";
			break;
		}
		return opinionGB;
	}
	public void setOpinionGB(String opinionGB) {
		this.opinionGB = opinionGB;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}

}
