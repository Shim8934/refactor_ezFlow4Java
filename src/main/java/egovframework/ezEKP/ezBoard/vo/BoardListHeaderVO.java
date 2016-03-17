package egovframework.ezEKP.ezBoard.vo;

public class BoardListHeaderVO {
	/** 게시판 ID */
	private String boardID;
	/** header 이름*/
	private String name;
	/** header 이름(다국어)*/
	private String name1;
	/** header 이름(다국어)*/
	private String name2;
	/** header 이름(다국어)*/
	private String name3;
	/** header 이름(다국어)*/
	private String name4;
	/** 헤더 사이즈*/
	private String width;
	/** Header Soring Column 명*/
	private String colName;
	/** SN */
	private String sn;

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getName1() {
		return name1;
	}
	public void setName1(String name1) {
		this.name1 = name1;
	}
	public String getName2() {
		return name2;
	}
	public void setName2(String name2) {
		this.name2 = name2;
	}
	public String getName3() {
		return name3;
	}
	public void setName3(String name3) {
		this.name3 = name3;
	}
	public String getName4() {
		return name4;
	}
	public void setName4(String name4) {
		this.name4 = name4;
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

	
}
