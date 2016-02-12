package egovframework.ezEKP.ezBoard.vo;

public class EzBoardVO {
	
	/**
	 * 게시판 그룹아이디 
	 */
	private String boardGroupId = "";
	/**
	 * 승인유저아이디
	 */
	private String apprUserId = "";
	/**
	 *  게시판아이디
	 */
	private String boardId = "";

	public String getApprUserId() {
		return apprUserId;
	}

	public void setApprUserId(String apprUserId) {
		this.apprUserId = apprUserId;
	}

	public String getBoardGroupId() {
		return boardGroupId;
	}

	public void setBoardGroupId(String boardGroupId) {
		this.boardGroupId = boardGroupId;
	}

	public String getBoardId() {
		return boardId;
	}

	public void setBoardId(String boardId) {
		this.boardId = boardId;
	}

}