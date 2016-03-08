package egovframework.ezEKP.ezBoard.vo;

import java.sql.Date;

public class BoardListVO {
	
	/** 유저아이디*/
	private String userID;
	/** 페이지네이션*/
	private int startRow;
	/** 페이지네이션*/
	private int endRow;
	/** 게시글 총갯수*/
	private int totalCount;
	/** 서브쿼리 정렬*/
	private String orderBySub;
	/** 메인쿼리 정렬*/
	private String orderByMain;
	/** 로우넘버*/
	private int rNum;
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
	private Date writeDate;
	/** 게시시작일(예약게시가 아닌경우 작성일과 동일함)*/
	private Date startDate;
	/** 답변인경우 원문의 작성일*/
	private Date parentWriteDate;
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
	/** 게시요약*/
	private String _abstract;
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
	/** 읽은 여부*/
	private String readFlag;
	/** 확장속성*/
	private String extensionAttribute5;
	/** 공지사항 순서*/
	private String notiNo;
	/** 확장속성*/
	private String extensionAttribute6;
	/** 확장속성*/
	private String extensionAttribute7;
	/** 확장속성*/
	private String extensionAttribute8;
	/** 확장속성*/
	private String extensionAttribute9;
	/** 확장속성*/
	private String extensionAttribute10;
	
	public int getrNum() {
		return rNum;
	}
	public void setrNum(int rNum) {
		this.rNum = rNum;
	}
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
	public Date getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(Date writeDate) {
		this.writeDate = writeDate;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getParentWriteDate() {
		return parentWriteDate;
	}
	public void setParentWriteDate(Date parentWriteDate) {
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
	public String get_abstract() {
		return _abstract;
	}
	public void set_abstract(String _abstract) {
		this._abstract = _abstract;
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
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public int getStartRow() {
		return startRow;
	}
	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}
	public int getEndRow() {
		return endRow;
	}
	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public String getOrderBySub() {
		return orderBySub;
	}
	public void setOrderBySub(String orderBySub) {
		this.orderBySub = orderBySub;
	}
	public String getOrderByMain() {
		return orderByMain;
	}
	public void setOrderByMain(String orderByMain) {
		this.orderByMain = orderByMain;
	}
	public String getReadFlag() {
		return readFlag;
	}
	public void setReadFlag(String readFlag) {
		this.readFlag = readFlag;
	}
	public String getExtensionAttribute5() {
		return extensionAttribute5;
	}
	public void setExtensionAttribute5(String extensionAttribute5) {
		this.extensionAttribute5 = extensionAttribute5;
	}
	public String getNotiNo() {
		return notiNo;
	}
	public void setNotiNo(String notiNo) {
		this.notiNo = notiNo;
	}
	public String getExtensionAttribute6() {
		return extensionAttribute6;
	}
	public void setExtensionAttribute6(String extensionAttribute6) {
		this.extensionAttribute6 = extensionAttribute6;
	}
	public String getExtensionAttribute7() {
		return extensionAttribute7;
	}
	public void setExtensionAttribute7(String extensionAttribute7) {
		this.extensionAttribute7 = extensionAttribute7;
	}
	public String getExtensionAttribute8() {
		return extensionAttribute8;
	}
	public void setExtensionAttribute8(String extensionAttribute8) {
		this.extensionAttribute8 = extensionAttribute8;
	}
	public String getExtensionAttribute9() {
		return extensionAttribute9;
	}
	public void setExtensionAttribute9(String extensionAttribute9) {
		this.extensionAttribute9 = extensionAttribute9;
	}
	public String getExtensionAttribute10() {
		return extensionAttribute10;
	}
	public void setExtensionAttribute10(String extensionAttribute10) {
		this.extensionAttribute10 = extensionAttribute10;
	}
	
}
