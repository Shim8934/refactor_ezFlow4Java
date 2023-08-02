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
	/** 2023-03-03 이가은 - 게시판 댓글 좋아요, 싫어요 기능 변수 추가 (특정 댓글에 대한 좋아요/싫어요 갯수) */
	private int re_like;
	private int re_hate;
	
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
	public int getRe_like() {
		return re_like;
	}
	public void setRe_like(int re_like) {
		this.re_like = re_like;
	}
	public int getRe_hate() {
		return re_hate;
	}
	public void setRe_hate(int re_hate) {
		this.re_hate = re_hate;
	}

}
