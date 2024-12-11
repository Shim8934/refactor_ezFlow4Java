package egovframework.ezEKP.ezBoard.vo;

import java.util.List;

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
	/** 2023-03-03 이가은 - 댓글 답글 변수 추가 */
	private int replyLevel;
	private String parentReplyID;
	private String parentWriterName;
	private String updateDate;

	// 2023-10-30 전인하 - 이모티콘
	private String imageContent;
	/** 댓글 첨부파일 리스트 */
	private List<BoardReplyAttachVO> replyAttach;
	
	/** 댓글 첨부 정보를 JOIN으로 받기 위한 DB 맵핑용 변수 */
	private String fileName;
	private String fileSize;
	private String filePath;
	private String fileSN;
	
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
	public int getReplyLevel() {
		return replyLevel;
	}
	public void setReplyLevel(int replyLevel) {
		this.replyLevel = replyLevel;
	}
	public String getParentWriterName() {
		return parentWriterName;
	}
	public void setParentWriterName(String parentWriterName) {
		this.parentWriterName = parentWriterName;
	}
	public String getParentReplyID() {
		return parentReplyID;
	}
	public void setParentReplyID(String parentReplyID) {
		this.parentReplyID = parentReplyID;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	
	public String getImageContent() {
		return imageContent;
	}
	public void setImageContent(String imageContent) {
		this.imageContent = imageContent;
	}

	public List<BoardReplyAttachVO> getReplyAttach() {
		return replyAttach;
	}

	public void setReplyAttach(List<BoardReplyAttachVO> replyAttach) {
		this.replyAttach = replyAttach;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getFileSN() {
		return fileSN;
	}

	public void setFileSN(String fileSN) {
		this.fileSN = fileSN;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
}
