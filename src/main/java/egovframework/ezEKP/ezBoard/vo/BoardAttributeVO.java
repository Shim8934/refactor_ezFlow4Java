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
	private String colName3;
	/** */
	private String colName4;	
	/** */
	private String colName6;	
	/** */
	private String value;
	/** */
	private String colType;
	/** */
	private String must;
	/** tenantID */
	private int tenantID;
	
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
		this.value = value != null ? value : "";
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
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public String getColName3() {
		return colName3;
	}
	public void setColName3(String colName3) {
		this.colName3 = colName3;
	}
	public String getColName4() {
		return colName4;
	}
	public void setColName4(String colName4) {
		this.colName4 = colName4;
	}
	public String getColName6() {
		return colName6;
	}
	public void setColName6(String colName6) {
		this.colName6 = colName6;
	}

}
