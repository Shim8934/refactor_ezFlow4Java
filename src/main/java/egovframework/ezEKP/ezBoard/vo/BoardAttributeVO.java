package egovframework.ezEKP.ezBoard.vo;

public class BoardAttributeVO {
	
	/** 게시물아이디*/
	private String boardID;
	/** 추가컬럼*/
	private String tableCol;
	/** */
	private String sn;
	/** */
	private String colName1;
	/** */
	private String colName2;
	/** */
	private String value;
	/** */
	private String colType;
	/** */
	private String must;
	
	public String getBoardID() {
		return boardID;
	}
	public void setBoardID(String boardID) {
		this.boardID = boardID;
	}
	public String getTableCol() {
		return tableCol;
	}
	public void setTableCol(String tableCol) {
		this.tableCol = tableCol;
	}
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	public String getColName1() {
		return colName1;
	}
	public void setColName1(String colName1) {
		this.colName1 = colName1;
	}
	public String getColName2() {
		return colName2;
	}
	public void setColName2(String colName2) {
		this.colName2 = colName2;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getColType() {
		return colType;
	}
	public void setColType(String colType) {
		this.colType = colType;
	}
	public String getMust() {
		return must;
	}
	public void setMust(String must) {
		this.must = must;
	}

}
