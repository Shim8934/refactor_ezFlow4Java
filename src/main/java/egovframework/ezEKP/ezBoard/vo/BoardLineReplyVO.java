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
	/** 2017.12.29 게시물 아이디 */
	private String boardItemID;
	/** 2017.12.29 게시판 아이디 */
	private String boardID;
	/** 2018-07-02 홍승비 - deptID 추가 */
	private String deptID;
	
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
	public String getBoardItemID() {
		return boardItemID;
	}
	public void setBoardItemID(String boardItemID) {
		this.boardItemID = boardItemID;
	}
	public String getBoardID() {
		return boardID;
	}
	public void setBoardID(String boardID) {
		this.boardID = boardID;
	}
	public String getDeptID() {
		return deptID;
	}
	public void setDeptID(String deptID) {
		this.deptID = deptID;
	}
	
}
