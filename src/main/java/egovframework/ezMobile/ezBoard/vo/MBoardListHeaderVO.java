package egovframework.ezMobile.ezBoard.vo;

public class MBoardListHeaderVO {
	/** 게시판 ID */
	private String boardID;
	/** header 이름*/
	private String name;
	/** header 이름(다국어)*/
	private String name2;
	/** 헤더 사이즈*/
	private String width;
	/** Header Soring Column 명*/
	private String colName;
	/** SN */
	private String sn;
	/** tenantID*/
	private int tenantID;

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getName2() {
		return name2;
	}
	public void setName2(String name2) {
		this.name2 = name2;
	}
	public String getWidth() {
		return width;
	}
	public void setWidth(String width) {
		this.width = width;
	}
	public String getColName() {
		return colName;
	}
	public void setColName(String colName) {
		this.colName = colName;
	}
	public String getBoardID() {
		return boardID;
	}
	public void setBoardID(String boardID) {
		this.boardID = boardID;
	}
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
}
