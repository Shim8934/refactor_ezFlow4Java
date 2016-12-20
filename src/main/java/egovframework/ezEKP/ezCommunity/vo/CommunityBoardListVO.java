package egovframework.ezEKP.ezCommunity.vo;

public class CommunityBoardListVO {
	/** get1*/
	
	String c_ClubGubun;
	
	String c_ClubConfirmType;
	
	String permit;
	
	/** get2*/
	/** 게시물아이디*/
	String itemID;
	/** 작성자아이디*/
	String writerID;
	/** 작성자이름*/
	String writerName;
	/** 작성자이름(다국어)*/
	String writerName2;
	/** 작성자부서명*/
	String writerDeptName;
	/** 작성자부서명(다국어)*/
	String writerDeptName2;
	/** 작성자회사이름*/
	String writerCompanyName;
	/** 작성자회사이름(다국어)*/
	String writerCompanyName2;
	/** 게시시작일(예약게시가 아닌경우 작성일과 동일함)*/
	String startDate;
	/** 작성일 */
	String writeDate;
	/** 답변인경우 원문의 작성일*/
	String parentWriteDate;
	/** 긴급게시여부*/
	int importance;
	/** 제목*/
	String title;
	/** 조회수*/
	int readCount;
	/** 첨부여부*/
	String attachments;
	/** 게시물레벨*/
	int itemLevel;
	/** 게시요약*/
	String absTract;
	/** 읽은 여부*/
	String readFlag;
	/** 게시판아이디*/
	String boardID;
	/** 게시판이름*/
	String boardName;
	/** 만료일자*/
	String endDate;

	public String getC_ClubGubun() {
		return c_ClubGubun;
	}

	public void setC_ClubGubun(String c_ClubGubun) {
		this.c_ClubGubun = c_ClubGubun;
	}

	public String getC_ClubConfirmType() {
		return c_ClubConfirmType;
	}

	public void setC_ClubConfirmType(String c_ClubConfirmType) {
		this.c_ClubConfirmType = c_ClubConfirmType;
	}

	public String getPermit() {
		return permit;
	}

	public void setPermit(String permit) {
		this.permit = permit;
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

	public String getWriterName2() {
		return writerName2;
	}

	public void setWriterName2(String writerName2) {
		this.writerName2 = writerName2;
	}

	public String getWriterDeptName() {
		return writerDeptName;
	}

	public void setWriterDeptName(String writerDeptName) {
		this.writerDeptName = writerDeptName;
	}

	public String getWriterDeptName2() {
		return writerDeptName2;
	}

	public void setWriterDeptName2(String writerDeptName2) {
		this.writerDeptName2 = writerDeptName2;
	}

	public String getWriterCompanyName() {
		return writerCompanyName;
	}

	public void setWriterCompanyName(String writerCompanyName) {
		this.writerCompanyName = writerCompanyName;
	}

	public String getWriterCompanyName2() {
		return writerCompanyName2;
	}

	public void setWriterCompanyName2(String writerCompanyName2) {
		this.writerCompanyName2 = writerCompanyName2;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getWriteDate() {
		return writeDate;
	}

	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}

	public String getParentWriteDate() {
		return parentWriteDate;
	}

	public void setParentWriteDate(String parentWriteDate) {
		this.parentWriteDate = parentWriteDate;
	}

	public int getImportance() {
		return importance;
	}

	public void setImportance(int importance) {
		this.importance = importance;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getReadCount() {
		return readCount;
	}

	public void setReadCount(int readCount) {
		this.readCount = readCount;
	}

	public String getAttachments() {
		return attachments;
	}

	public void setAttachments(String attachments) {
		this.attachments = attachments;
	}

	public int getItemLevel() {
		return itemLevel;
	}

	public void setItemLevel(int itemLevel) {
		this.itemLevel = itemLevel;
	}

	public String getAbsTract() {
		return absTract;
	}

	public void setAbsTract(String absTract) {
		this.absTract = absTract;
	}

	public String getReadFlag() {
		return readFlag;
	}

	public void setReadFlag(String readFlag) {
		this.readFlag = readFlag;
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

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	
}
