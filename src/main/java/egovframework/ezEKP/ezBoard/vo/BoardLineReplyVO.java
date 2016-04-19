package egovframework.ezEKP.ezBoard.vo;

public class BoardLineReplyVO {
	
	/** 한줄댓글아이디*/
	private String replyID;
	/** 유저명*/
	private String userName;
	/** 유저아이디*/
	private String userID;
	/** 내용*/
	private String content;
	/** 작성일*/
	private String writeDate;
	
	public String getReplyID() {
		return replyID;
	}
	public void setReplyID(String replyID) {
		this.replyID = replyID;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}
	
	
}
