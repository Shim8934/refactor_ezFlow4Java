package egovframework.ezEKP.ezNewPortal.vo;

public class PortalBoardTreeVO {

	private String id;
	private String parent;
	private String text;
	private String boardName1;
	private String boardName2;
	private String boardName3;
	private int sort;
	private String topParent;
	private String boardColor;
	private int gubun;
	
	public String getBoardColor() {
		return boardColor;
	}
	public void setBoardColor(String boardColor) {
		this.boardColor = boardColor;
	}
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
	public String getBoardName3() {
		return boardName3;
	}
	public void setBoardName3(String boardName3) {
		this.boardName3 = boardName3;
	}
	public int getSort() {
		return sort;
	}
	public void setSort(int sort) {
		this.sort = sort;
	}
	public String getTopParent() {
		return topParent;
	}
	public void setTopParent(String topParent) {
		this.topParent = topParent;
	}
	public int getGubun() {
		return gubun;
	}
	public void setGubun(int gubun) {
		this.gubun = gubun;
	}
	@Override
	public String toString() {
		return "PortalBoardTreeVO [id=" + id + ", parent=" + parent + ", text=" + text + ", boardName1=" + boardName1
				+ ", boardName2=" + boardName2 + ", boardName3=" + boardName3 + ", sort=" + sort + ", topParent=" + topParent + ", boardColor="
				+ boardColor + ", gubun=" + gubun + "]";
	}
}
