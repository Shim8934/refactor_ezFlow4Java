package egovframework.ezMobile.ezApprovalG.vo;

public class MApprovalGOpinionInfoVO {
	/** 의견내용*/
	private String content;
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

}
