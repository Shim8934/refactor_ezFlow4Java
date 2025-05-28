package egovframework.ezMobile.ezBoard.vo;

public class MBoardItemVO {
	/** 유저아이디*/
	private String userID;
	/** 페이지네이션*/
	private int startRow;
	/** 페이지네이션*/
	private int endRow;
	/** 게시글 총갯수*/
	private int totalCount;
	/** 페이지 개수*/
	private int pageCount;
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
	/** 작성자부서아이디*/
	private String writerDeptID;
	/** 작성자부서명*/
	private String writerDeptName;
	/** 작성자회사아이디*/
	private String writerCompanyID;
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
	/** 읽은 여부*/
	private String readFlag;
	/** 공지사항 순서*/
	private String notiNo;
	/** 확장속성*/
	private String extensionAttribute1;
	/** 공지사항(1/0)*/
	private String extensionAttribute2;
	/** 작성자직위*/
	private String extensionAttribute3;
	/** 작성자직위(다국어)*/
	private String extensionAttribute32;
	/** 확장속성*/
	private String extensionAttribute4;
	/** 확장속성*/
	private String extensionAttribute5;
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
	/** 게시문서파일의위치*/
	private String contentLocation;
	/** 게시만료일*/
	private String endDate;
	/** 복사된게시물여부*/
	private String copiedItem;
	/** */
	private String apprFlag;
	/** 파일경로*/
	private String filePath;
	/** top작성자ID*/
	private String topWriterID;
	/** 게시물 비밀번호*/
	private String docPassword;
	/** 첨부여부*/
	private String hasAttach;
	/** 작성자 메일*/
	private String mail;
	/** 업데이트날짜*/
	private String updateDate;
	/** 포토게시판 이미지 개수*/
	private int imageCount;
	/** 포토게시판 이미지 경로*/
	private String imagePath;
	/** 포토게시판 이미지 내용*/
	private String imageContent;
	/** 포토게시판 이미지 명*/
	private String imageNames;
	/** 이미지아이디*/
	private String imageID;
	/** 파일내용*/
	private String fileContent;
	/** 실제경로*/
	private String realPath;
	/** tenantID*/
	private int tenantID;
	/** 메인이미지*/
	private String mainImageID;
	/** 새로운게시물 여부*/
	private String newItemFlag;
	/** 2023-09-25 민지수 - 공지사항 기간설정 시작날짜 */
	private String notiStart;
	/** 2023-09-25 민지수 - 공지사항 기간설정 종료날짜 */
	private String notiEnd;
	/** 2024-11-12 박기범 - 게시판 공개/비공개 */
	private String publicFlag = "Y";
	/** 게시물 수정자 ID */
	private String updaterID;
	/** 게시물 수정자 이름 */
	private String updaterName;
	
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
	public int getPageCount() {
		return pageCount;
	}
	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
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
	public String getReadFlag() {
		return readFlag;
	}
	public void setReadFlag(String readFlag) {
		this.readFlag = readFlag;
	}
	public String getNotiNo() {
		return notiNo;
	}
	public void setNotiNo(String notiNo) {
		this.notiNo = notiNo;
	}
	public String getExtensionAttribute1() {
		return extensionAttribute1;
	}
	public void setExtensionAttribute1(String extensionAttribute1) {
		this.extensionAttribute1 = extensionAttribute1;
	}
	public String getExtensionAttribute2() {
		return extensionAttribute2;
	}
	public void setExtensionAttribute2(String extensionAttribute2) {
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
	public String getContentLocation() {
		return contentLocation;
	}
	public void setContentLocation(String contentLocation) {
		this.contentLocation = contentLocation;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getCopiedItem() {
		return copiedItem;
	}
	public void setCopiedItem(String copiedItem) {
		this.copiedItem = copiedItem;
	}
	public String getApprFlag() {
		return apprFlag;
	}
	public void setApprFlag(String apprFlag) {
		this.apprFlag = apprFlag;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getTopWriterID() {
		return topWriterID;
	}
	public void setTopWriterID(String topWriterID) {
		this.topWriterID = topWriterID;
	}
	public String getDocPassword() {
		return docPassword;
	}
	public void setDocPassword(String docPassword) {
		this.docPassword = docPassword;
	}
	public String getHasAttach() {
		return hasAttach;
	}
	public void setHasAttach(String hasAttach) {
		this.hasAttach = hasAttach;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	public int getImageCount() {
		return imageCount;
	}
	public void setImageCount(int imageCount) {
		this.imageCount = imageCount;
	}
	public String getImagePath() {
		return imagePath;
	}
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}
	public String getImageContent() {
		return imageContent;
	}
	public void setImageContent(String imageContent) {
		this.imageContent = imageContent;
	}
	public String getImageNames() {
		return imageNames;
	}
	public void setImageNames(String imageNames) {
		this.imageNames = imageNames;
	}
	public String getImageID() {
		return imageID;
	}
	public void setImageID(String imageID) {
		this.imageID = imageID;
	}
	public String getFileContent() {
		return fileContent;
	}
	public void setFileContent(String fileContent) {
		this.fileContent = fileContent;
	}
	public String getRealPath() {
		return realPath;
	}
	public void setRealPath(String realPath) {
		this.realPath = realPath;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public String getMainImageID() {
		return mainImageID;
	}
	public void setMainImageID(String mainImageID) {
		this.mainImageID = mainImageID;
	}
	public String getNewItemFlag() {
		return newItemFlag;
	}
	public void setNewItemFlag(String newItemFlag) {
		this.newItemFlag = newItemFlag;
	}	
	public String getNotiStart() {
		return notiStart;
	}	
	public void setNotiStart(String notiStart) {
		this.notiStart = notiStart;
	}	
	public String getNotiEnd() {
		return notiEnd;
	}	
	public void setNotiEnd(String notiEnd) {
		this.notiEnd = notiEnd;
	}
	public String getPublicFlag() {
		return publicFlag;
	}
	public void setPublicFlag(String publicFlag) {
		this.publicFlag = publicFlag;
	}
	public String getUpdaterID() {
		return updaterID;
	}
	public void setUpdaterID(String updaterID) {
		this.updaterID = updaterID;
	}
	public String getUpdaterName() {
		return updaterName;
	}
	public void setUpdaterName(String updaterName) {
		this.updaterName = updaterName;
	}
}
