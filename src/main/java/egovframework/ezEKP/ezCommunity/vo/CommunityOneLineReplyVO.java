package egovframework.ezEKP.ezCommunity.vo;

public class CommunityOneLineReplyVO {
	/** 게시물아이디*/
	String itemID;
	/** 한줄답변아이디*/
	String replyID;
	/** 게시판아이디*/
	String boardID;
	/** 답변자아이디*/
	String userID;
	/** 답변자이름*/
	String userName;
	/** 답변자이름(다국어)*/
	String userName2;
	/** 답변일자*/
	String writeDate;
	/** 한줄답변내용*/
	String content;
	
	public String getItemID() {
		return itemID;
	}
	public void setItemID(String itemID) {
		this.itemID = itemID;
	}
	public String getReplyID() {
		return replyID;
	}
	public void setReplyID(String replyID) {
		this.replyID = replyID;
	}
	public String getBoardID() {
		return boardID;
	}
	public void setBoardID(String boardID) {
		this.boardID = boardID;
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
	public String getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	
}
