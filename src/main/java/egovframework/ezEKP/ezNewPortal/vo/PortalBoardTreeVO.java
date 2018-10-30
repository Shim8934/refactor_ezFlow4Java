package egovframework.ezEKP.ezNewPortal.vo;

public class PortalBoardTreeVO {

	private String id;
	private String parent;
	private String text;
	private String boardName1;
	private String boardName2;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getParent() {
		return parent;
	}
	public void setParent(String parent) {
		this.parent = parent;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getBoardName1() {
		return boardName1;
	}
	public void setBoardName1(String boardName1) {
		this.boardName1 = boardName1;
	}
	public String getBoardName2() {
		return boardName2;
	}
	public void setBoardName2(String boardName2) {
		this.boardName2 = boardName2;
	}
	
	@Override
	public String toString() {
		return "PortalBoardTreeVO [id=" + id + ", parent=" + parent + ", text=" + text + ", boardName1=" + boardName1
				+ ", boardName2=" + boardName2 + "]";
	}
	
}
