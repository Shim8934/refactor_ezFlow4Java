package egovframework.ezMobile.ezBoard.vo;

public class MBoardNewListVO {
	/** 게시판아이디*/
	private String boardID;
	/** 게시판명*/
	private String boardName;
	/** 게시물아이디*/
	private String itemID;
	/** 작성자아이디*/
	private String writerID;
	/** 작성자이름*/
	private String writerName;
	/** 작성자부서명*/
	private String writerDeptName;
	/** 작성자회사명*/
	private String writerCompanyName;
	/** 작성일*/
	private String writeDate;
	/** 게시시작일(예약게시가 아닌경우 작성일과 동일함)*/
	private String startDate;
	/** 답변인경우 원문의 작성일*/
	private String parentWriteDate;
	/** 긴급게시여부*/
	private String importance; 
	/** 제목*/
	private String title;
	/** 첨부여부*/
	private String attachments;
	/** 조회수*/
	private int readCount;
	/** 게시물레벨(사용안함)*/
	private String itemLevel; 
	/** 게시요약(소문자 불가해서 대문자)*/
	private String ABSTRACT;
	/** 게시판이름(다국어)*/
	private String boardName2;
	/** 작성자이름(다국어)*/
	private String writerName2;
	/** 작성자부서명(다국어)*/
	private String writerDeptName2;
	/** 작성자회사명(다국어)*/
	private String writerCompanyName2;
	/**댓글 갯수 */
	private int oneLineCnt;
	/** 게시물트리정보*/
	private String upperItemIDTree;
	/** 게시물번호(순번)*/
	private String docNo;
	/** 노티스*/
	private String notice;
	/** 구분*/
	private String guBun;
	/** 앨범소개*/
	private String mainContent;
	/** 2024-11-12 박기범 - 게시판 공개/비공개 */
	private String publicFlag = "Y";

	private String newItemFlag;
	
	public String getBoardID() {
		return boardID;
	}
	public void setBoardID(String boardID) {
		this.boardID = boardID;
	}
	public String getBoardName() {
		return boardName;
	}
	public void setBoardName(String boardName) {
		this.boardName = boardName;
	}
	public String getItemID() {
		return itemID;
	}
	public void setItemID(String itemID) {
		this.itemID = itemID;
	}
	public String getWriterID() {
		return writerID;
	}
	public void setWriterID(String writerID) {
		this.writerID = writerID;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getWriterDeptName() {
		return writerDeptName;
	}
	public void setWriterDeptName(String writerDeptName) {
		this.writerDeptName = writerDeptName;
	}
	public String getWriterCompanyName() {
		return writerCompanyName;
	}
	public void setWriterCompanyName(String writerCompanyName) {
		this.writerCompanyName = writerCompanyName;
	}
	public String getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getParentWriteDate() {
		return parentWriteDate;
	}
	public void setParentWriteDate(String parentWriteDate) {
		this.parentWriteDate = parentWriteDate;
	}
	public String getImportance() {
		return importance;
	}
	public void setImportance(String importance) {
		this.importance = importance;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getAttachments() {
		return attachments;
	}
	public void setAttachments(String attachments) {
		this.attachments = attachments;
	}
	public int getReadCount() {
		return readCount;
	}
	public void setReadCount(int readCount) {
		this.readCount = readCount;
	}
	public String getItemLevel() {
		return itemLevel;
	}
	public void setItemLevel(String itemLevel) {
		this.itemLevel = itemLevel;
	}
	public String getABSTRACT() {
		return ABSTRACT;
	}
	public void setABSTRACT(String aBSTRACT) {
		ABSTRACT = aBSTRACT;
	}
	public String getBoardName2() {
		return boardName2;
	}
	public void setBoardName2(String boardName2) {
		this.boardName2 = boardName2;
	}
	public String getWriterName2() {
		return writerName2;
	}
	public void setWriterName2(String writerName2) {
		this.writerName2 = writerName2;
	}
	public String getWriterDeptName2() {
		return writerDeptName2;
	}
	public void setWriterDeptName2(String writerDeptName2) {
		this.writerDeptName2 = writerDeptName2;
	}
	public String getWriterCompanyName2() {
		return writerCompanyName2;
	}
	public void setWriterCompanyName2(String writerCompanyName2) {
		this.writerCompanyName2 = writerCompanyName2;
	}
	public int getOneLineCnt() {
		return oneLineCnt;
	}
	public void setOneLineCnt(int oneLineCnt) {
		this.oneLineCnt = oneLineCnt;
	}
	public String getUpperItemIDTree() {
		return upperItemIDTree;
	}
	public void setUpperItemIDTree(String upperItemIDTree) {
		this.upperItemIDTree = upperItemIDTree;
	}
	public String getDocNo() {
		return docNo;
	}
	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}
	public String getNotice() {
		return notice;
	}
	public void setNotice(String notice) {
		this.notice = notice;
	}
	public String getGuBun() {
		return guBun;
	}
	public void setGuBun(String guBun) {
		this.guBun = guBun;
	}
	public String getMainContent() {
		return mainContent;
	}
	public void setMainContent(String mainContent) {
		this.mainContent = mainContent;
	}
	public String getPublicFlag() {
		return publicFlag;
	}
	public void setPublicFlag(String publicFlag) {
		this.publicFlag = publicFlag;
	}
	public String getNewItemFlag() { return newItemFlag; }
	public void setNewItemFlag(String newItemFlag) { this.newItemFlag = newItemFlag; }
}
