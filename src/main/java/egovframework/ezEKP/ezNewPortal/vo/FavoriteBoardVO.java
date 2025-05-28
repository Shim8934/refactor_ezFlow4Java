package egovframework.ezEKP.ezNewPortal.vo;

public class FavoriteBoardVO {
	
	private String boardId;
	private String itemId;
	private String writerName;
	private String startDate;
	private String title;
	private String gubun;
	// 2023-07-28 황인경 - 즐겨찾기 포틀릿 > 다국어 지원 > 작성자명 
	private String writerName2;
	private String publicFlag;
	
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public String getBoardId() {
		return boardId;
	}
	public void setBoardId(String boardId) {
		this.boardId = boardId;
	}
	public String getItemId() {
		return itemId;
	}
	public void setItemId(String itemId) {
		this.itemId = itemId;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getWriterName2() {
		return writerName2;
	}
	public String getPublicFlag() {
		return publicFlag;
	}
	public void setPublicFlag(String publicFlag) {
		this.publicFlag = publicFlag;
	}
	
	@Override
	public String toString() {
		return "FavoriteBoardVO [boardId=" + boardId + ", itemId=" + itemId
				+ ", writerName=" + writerName + ", startDate=" + startDate
				+ ", title=" + title + "]";
	}
}
