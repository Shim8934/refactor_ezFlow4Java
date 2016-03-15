package egovframework.ezEKP.ezBoard.vo;

public class BoardVO {
	
	/**게시판 그룹아이디	 */
	private String boardGroupId;	
	/**승인유저아이디	 */
	private String apprUserId;
	/** 게시판아이디	 */
	private String boardId;
	/** 게시글 갯수	*/
	private int ss_board_maxRows;
	/** 검색게시글 갯수	*/
	private int ss_searchBoard_maxRows;
	/** 게시판명	*/
	private String boardName;
	/** 게시판 유형*/
	private String boardType;
	/** 페이지 번호*/
	private int pageNum;
	/** 셀순서*/
	private String orderCell;
	/** 순서옵션*/
	private String orderOption;
	/** 언어 */
	private String lang;

	public int getSs_board_maxRows() {
		return ss_board_maxRows;
	}
	public String getBoardName() {
		return boardName;
	}
	public void setBoardName(String boardName) {
		this.boardName = boardName;
	}
	public void setSs_board_maxRows(int ss_board_maxRows) {
		this.ss_board_maxRows = ss_board_maxRows;
	}
	public int getSs_searchBoard_maxRows() {
		return ss_searchBoard_maxRows;
	}
	public void setSs_searchBoard_maxRows(int ss_searchBoard_maxRows) {
		this.ss_searchBoard_maxRows = ss_searchBoard_maxRows;
	}
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
	public String getBoardType() {
		return boardType;
	}
	public void setBoardType(String boardType) {
		this.boardType = boardType;
	}
	public int getPageNum() {
		return pageNum;
	}
	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}
	public String getOrderCell() {
		return orderCell;
	}
	public void setOrderCell(String orderCell) {
		this.orderCell = orderCell;
	}
	public String getOrderOption() {
		return orderOption;
	}
	public void setOrderOption(String orderOption) {
		this.orderOption = orderOption;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
}