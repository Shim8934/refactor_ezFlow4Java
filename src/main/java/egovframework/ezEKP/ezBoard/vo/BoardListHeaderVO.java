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
	/** header 이름(인도네시아어)*/
	private String name6;
	/** 헤더 사이즈*/
	private String width;
	/** Header String Column 명*/
	private String colName;
	/** SN */
	private String sn;
	/** tenantID*/
	private int tenantID;
	/** 2018-07-25 홍승비 - 기본헤더 다국어 저장을 위한 분기 변수 */
	private String isInitHeader;

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
	public String getName6() {
		return name6;
	}
	public void setName6(String name6) {
		this.name6 = name6;
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
	public String getIsInitHeader() {
		return isInitHeader;
	}
	public void setIsInitHeader(String isInitHeader) {
		this.isInitHeader = isInitHeader;
	}
	
}
