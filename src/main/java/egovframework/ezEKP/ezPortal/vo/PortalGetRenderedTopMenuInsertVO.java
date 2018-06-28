package egovframework.ezEKP.ezPortal.vo;

public class PortalGetRenderedTopMenuInsertVO {
	/** 아이디*/
	private String uID;
	/** 부모 아이디*/
	private String parentUID;
	/** 이름*/
	private String displayName;
	/** 가로길이*/
	private String width;
	/** 세로길이*/
	private String height;
	/** Row 길이*/
	private String rowLength;
	/** Column 길이*/
	private String columnLength;
	/** Row 분리값*/
	private String rowSplit;
	/** Column 분리값*/
	private String columnSplit;
	
	public String getuID() {
		return uID;
	}
	public void setuID(String uID) {
		this.uID = uID;
	}
	public String getParentUID() {
		return parentUID;
	}
	public void setParentUID(String parentUID) {
		this.parentUID = parentUID;
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
	public String getRowLength() {
		return rowLength;
	}
	public void setRowLength(String rowLength) {
		this.rowLength = rowLength;
	}
	public String getColumnLength() {
		return columnLength;
	}
	public void setColumnLength(String columnLength) {
		this.columnLength = columnLength;
	}
	public String getRowSplit() {
		return rowSplit;
	}
	public void setRowSplit(String rowSplit) {
		this.rowSplit = rowSplit;
	}
	public String getColumnSplit() {
		return columnSplit;
	}
	public void setColumnSplit(String columnSplit) {
		this.columnSplit = columnSplit;
	}
}
