package egovframework.ezEKP.ezPortal.vo;

public class PortalTBLTopMenuItemsVO {
	/** 아이디*/
	private String uID;
	/** 페이지 아이디*/
	private String pageUID;
	/** 부모 페이지 아이디*/
	private String parentPageUID;
	/** 소유 페이지 아이디*/
	private String ownerPageID;
	/** 메뉴 아이템 타입*/
	private String menuItemType;
	/** 이름*/
	private String displayName;
	/** 가로 길이*/
	private String width;
	/** 세로 길이*/
	private String height;
	/** Row 포지션*/
	private String rowPos;
	/** Column 포지션*/
	private String columnPos;
	/** 삭제 가능*/
	private String canRemove;
	/** 사이즈 조절 가능*/
	private String canResize;
	/** 바꾸기 가능*/
	private String canReplace;
	/** 가로 정렬*/
	private String align;
	/** 세로 정렬*/
	private String valign;
	/** 상단 여백*/
	private String topMargin;
	/** 하단 여백*/
	private String bottomMargin;
	/** 왼쪽 여백*/
	private String leftMargin;
	/** 오른쪽 여백*/
	private String rightMargin;
	
	public String getuID() {
		return uID;
	}
	public void setuID(String uID) {
		this.uID = uID;
	}
	public String getPageUID() {
		return pageUID;
	}
	public void setPageUID(String pageUID) {
		this.pageUID = pageUID;
	}
	public String getParentPageUID() {
		return parentPageUID;
	}
	public void setParentPageUID(String parentPageUID) {
		this.parentPageUID = parentPageUID;
	}
	public String getOwnerPageID() {
		return ownerPageID;
	}
	public void setOwnerPageID(String ownerPageID) {
		this.ownerPageID = ownerPageID;
	}
	public String getMenuItemType() {
		return menuItemType;
	}
	public void setMenuItemType(String menuItemType) {
		this.menuItemType = menuItemType;
	}
	public String getDisplayName() {
		return displayName;
	}
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
	public String getWidth() {
		return width;
	}
	public void setWidth(String width) {
		this.width = width;
	}
	public String getHeight() {
		return height;
	}
	public void setHeight(String height) {
		this.height = height;
	}
	public String getRowPos() {
		return rowPos;
	}
	public void setRowPos(String rowPos) {
		this.rowPos = rowPos;
	}
	public String getColumnPos() {
		return columnPos;
	}
	public void setColumnPos(String columnPos) {
		this.columnPos = columnPos;
	}
	public String getCanRemove() {
		return canRemove;
	}
	public void setCanRemove(String canRemove) {
		this.canRemove = canRemove;
	}
	public String getCanResize() {
		return canResize;
	}
	public void setCanResize(String canResize) {
		this.canResize = canResize;
	}
	public String getCanReplace() {
		return canReplace;
	}
	public void setCanReplace(String canReplace) {
		this.canReplace = canReplace;
	}
	public String getAlign() {
		return align;
	}
	public void setAlign(String align) {
		this.align = align;
	}
	public String getValign() {
		return valign;
	}
	public void setValign(String valign) {
		this.valign = valign;
	}
	public String getTopMargin() {
		return topMargin;
	}
	public void setTopMargin(String topMargin) {
		this.topMargin = topMargin;
	}
	public String getBottomMargin() {
		return bottomMargin;
	}
	public void setBottomMargin(String bottomMargin) {
		this.bottomMargin = bottomMargin;
	}
	public String getLeftMargin() {
		return leftMargin;
	}
	public void setLeftMargin(String leftMargin) {
		this.leftMargin = leftMargin;
	}
	public String getRightMargin() {
		return rightMargin;
	}
	public void setRightMargin(String rightMargin) {
		this.rightMargin = rightMargin;
	}
}
