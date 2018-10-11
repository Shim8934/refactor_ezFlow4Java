package egovframework.ezEKP.ezNewPortal.vo;

public class FavoriteBoardVO {
	
	private String boardId;
	private String itemId;
	private String writerName;
	private String startDate;
	private String title;
	
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
	
	@Override
	public String toString() {
		return "FavoriteBoardVO [boardId=" + boardId + ", itemId=" + itemId
				+ ", writerName=" + writerName + ", startDate=" + startDate
				+ ", title=" + title + "]";
	}
}
