package egovframework.ezEKP.ezCommunity.vo;

public class CommunityBoardItemReadVO {
	/** 게시판아이디*/
	String boardID;
	/** 게시물아이디*/
	String itemID;
	/** 조회자아이디*/
	String userID;
	/** 조회자이름*/
	String userName;
	/** 조회자이름(다국어)*/
	String userName2;
	/** 조회자부서명*/
	String userDeptName;
	/** 조회자부서명(다국어)*/
	String userDeptName2;
	/** 조회자회사명*/
	String userCompanyName;
	/** 조회자회사명(다국어)*/
	String userCompanyName2;
	/** 조회자직급*/
	String userTitle;
	/** 조회자직급(다국어)*/
	String userTitle2;
	/** 조회일시*/
	String readDate;
	
	public String getBoardID() {
		return boardID;
	}
	public void setBoardID(String boardID) {
		this.boardID = boardID;
	}
	public String getItemID() {
		return itemID;
	}
	public void setItemID(String itemID) {
		this.itemID = itemID;
	}
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
	public String getUserName2() {
		return userName2;
	}
	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}
	public String getUserDeptName() {
		return userDeptName;
	}
	public void setUserDeptName(String userDeptName) {
		this.userDeptName = userDeptName;
	}
	public String getUserDeptName2() {
		return userDeptName2;
	}
	public void setUserDeptName2(String userDeptName2) {
		this.userDeptName2 = userDeptName2;
	}
	public String getUserCompanyName() {
		return userCompanyName;
	}
	public void setUserCompanyName(String userCompanyName) {
		this.userCompanyName = userCompanyName;
	}
	public String getUserCompanyName2() {
		return userCompanyName2;
	}
	public void setUserCompanyName2(String userCompanyName2) {
		this.userCompanyName2 = userCompanyName2;
	}
	public String getUserTitle() {
		return userTitle;
	}
	public void setUserTitle(String userTitle) {
		this.userTitle = userTitle;
	}
	public String getUserTitle2() {
		return userTitle2;
	}
	public void setUserTitle2(String userTitle2) {
		this.userTitle2 = userTitle2;
	}
	public String getReadDate() {
		return readDate;
	}
	public void setReadDate(String readDate) {
		this.readDate = readDate;
	}
}
