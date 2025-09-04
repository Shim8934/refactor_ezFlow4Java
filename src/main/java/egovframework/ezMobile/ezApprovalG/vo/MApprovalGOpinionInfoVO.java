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
	/** 2023-03-13 전인하 - 전자결재 > 모바일 의견 기능 개선 - 의견 순번 */
	private int opinionSN;
	private int groupSN;
	private String docID;
	
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
	
	public int getOpinionSN() {
		return opinionSN;
	}
	public void setOpinionSN(int opinionSN) {
		this.opinionSN = opinionSN;
	}

	public int getGroupSN() {
		return groupSN;
	}

	public void setGroupSN(int groupSN) {
		this.groupSN = groupSN;
	}

	public String getDocID() {
		return docID;
	}

	public void setDocID(String docID) {
		this.docID = docID;
	}
}
