package egovframework.ezEKP.ezBoard.vo;

public class BoardTreeVO {
	/** 게시판아이디	*/
	private String boardId;
	/** 게시판이름	*/
	private String boardName;
	/** 게시판이름 2	*/
	private String boardName2;
	/** 트리순서	*/
	private String treeViewOrder;
	/** 게시판 색	*/
	private String boardColor;
	/** 구분	*/
	private String guBun;
	/** 그룹acl	*/
	private String boardGroupAcl;
	/** 확장여부	*/
	private String expanded;
	/** 셀렉트	*/
	private String select;
	/** 이즈맆	*/
	private String isLeaf;
	
	public String getBoardId() {
		return boardId;
	}
	public void setBoardId(String boardId) {
		this.boardId = boardId;
	}
	public String getBoardName() {
		return boardName;
	}
	public void setBoardName(String boardName) {
		this.boardName = boardName;
	}
	public String getBoardName2() {
		return boardName2;
	}
	public void setBoardName2(String boardName2) {
		this.boardName2 = boardName2;
	}
	public String getTreeViewOrder() {
		return treeViewOrder;
	}
	public void setTreeViewOrder(String treeViewOrder) {
		this.treeViewOrder = treeViewOrder;
	}
	public String getBoardColor() {
		return boardColor;
	}
	public void setBoardColor(String boardColor) {
		this.boardColor = boardColor;
	}
	public String getGuBun() {
		return guBun;
	}
	public void setGuBun(String guBun) {
		this.guBun = guBun;
	}
	public String getBoardGroupAcl() {
		return boardGroupAcl;
	}
	public void setBoardGroupAcl(String boardGroupAcl) {
		this.boardGroupAcl = boardGroupAcl;
	}
	public String getExpanded() {
		return expanded;
	}
	public void setExpanded(String expanded) {
		this.expanded = expanded;
	}
	public String getSelect() {
		return select;
	}
	public void setSelect(String select) {
		this.select = select;
	}
	public String getIsLeaf() {
		return isLeaf;
	}
	public void setIsLeaf(String isLeaf) {
		this.isLeaf = isLeaf;
	}

}
