package egovframework.ezEKP.ezCommunity.vo;

public class CommunityBoardItemVO {
	/** 게시물아이디*/
	String itemID;
	/** 게시판아이디*/
	String boardID;
	/** 게시판 이름*/
	String boardName;
	/** 작성자아이디*/
	String writerID;
	/** 작성자이름*/
	String writerName;
	/** 작성자이름(다국어)*/
	String writerName2;
	/** 작성자부서코드*/
	String writerDeptID;
	/** 작성자부서명*/
	String writerDeptName;
	/** 작성자부서명(다국어)*/
	String writerDeptName2;
	/** 작성자회사코드*/
	String writerCompanyID;
	/** 작성자회사명*/
	String writerCompanyName;
	/** 작성자회사명(다국어)*/
	String writerCompanyName2;
	/** 작성일*/
	String writeDate;
	/** 답변인경우원문의작성일*/
	String parentWriteDate;
	/** 수정일*/
	String updateDate;
	/** 긴급게시여부*/
	int importance;
	/** 제목*/
	String title;
	/** 게시문서파일의위치*/
	String contentLocation;
	/** 조회수*/
	int readCount;
	/** 게시시작일(예약게시가아닌경우작성일과동일함)*/
	String startDate;
	/** 게시만료일*/
	String endDate;
	/** 게시요약*/
	String absTract;
	/** 첨부여부*/
	String attachments;
	/** CLOB 게시물트리정보(답변쓰레드정보를담고있음)*/
	String upperItemIDTree;
	/** 게시물레벨(사용안함)*/
	int itemLevel;
	/** 복사된게시물여부*/
	int copiedItem;
	/** 확장속성1(예약필드)*/
	int extensionAttribute1;
	/** 확장속성2(예약필드)*/
	int extensionAttribute2;
	/** 확장속성3(예약필드)*/
	String extensionAttribute3;
	/** 확장속성32(예약필드)*/
	String extensionAttribute32;
	/** 확장속성4(예약필드)*/
	String extensionAttribute4;
	/** 확장속성5(예약필드)*/
	String extensionAttribute5;
	/** 게시물번호(순번)*/
	int docNo;
	/** 게시물암호(익명게시시사용)*/
	String docPassword;
	/** 게시판 구분(일반(0), 그룹(1), 익명(2))*/
	String gubun;
	public String getItemID() {
		return itemID;
	}
	public void setItemID(String itemID) {
		this.itemID = itemID;
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
	public String getWriterDeptID() {
		return writerDeptID;
	}
	public void setWriterDeptID(String writerDeptID) {
		this.writerDeptID = writerDeptID;
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
	public String getWriterCompanyID() {
		return writerCompanyID;
	}
	public void setWriterCompanyID(String writerCompanyID) {
		this.writerCompanyID = writerCompanyID;
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
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
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
	public String getContentLocation() {
		return contentLocation;
	}
	public void setContentLocation(String contentLocation) {
		this.contentLocation = contentLocation;
	}
	public int getReadCount() {
		return readCount;
	}
	public void setReadCount(int readCount) {
		this.readCount = readCount;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getAbsTract() {
		return absTract;
	}
	public void setAbsTract(String absTract) {
		this.absTract = absTract;
	}
	public String getAttachments() {
		return attachments;
	}
	public void setAttachments(String attachments) {
		this.attachments = attachments;
	}
	public String getUpperItemIDTree() {
		return upperItemIDTree;
	}
	public void setUpperItemIDTree(String upperItemIDTree) {
		this.upperItemIDTree = upperItemIDTree;
	}
	public int getItemLevel() {
		return itemLevel;
	}
	public void setItemLevel(int itemLevel) {
		this.itemLevel = itemLevel;
	}
	public int getCopiedItem() {
		return copiedItem;
	}
	public void setCopiedItem(int copiedItem) {
		this.copiedItem = copiedItem;
	}
	public int getExtensionAttribute1() {
		return extensionAttribute1;
	}
	public void setExtensionAttribute1(int extensionAttribute1) {
		this.extensionAttribute1 = extensionAttribute1;
	}
	public int getExtensionAttribute2() {
		return extensionAttribute2;
	}
	public void setExtensionAttribute2(int extensionAttribute2) {
		this.extensionAttribute2 = extensionAttribute2;
	}
	public String getExtensionAttribute3() {
		return extensionAttribute3;
	}
	public void setExtensionAttribute3(String extensionAttribute3) {
		this.extensionAttribute3 = extensionAttribute3;
	}
	public String getExtensionAttribute32() {
		return extensionAttribute32;
	}
	public void setExtensionAttribute32(String extensionAttribute32) {
		this.extensionAttribute32 = extensionAttribute32;
	}
	public String getExtensionAttribute4() {
		return extensionAttribute4;
	}
	public void setExtensionAttribute4(String extensionAttribute4) {
		this.extensionAttribute4 = extensionAttribute4;
	}
	public String getExtensionAttribute5() {
		return extensionAttribute5;
	}
	public void setExtensionAttribute5(String extensionAttribute5) {
		this.extensionAttribute5 = extensionAttribute5;
	}
	public int getDocNo() {
		return docNo;
	}
	public void setDocNo(int docNo) {
		this.docNo = docNo;
	}
	public String getDocPassword() {
		return docPassword;
	}
	public void setDocPassword(String docPassword) {
		this.docPassword = docPassword;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
}
