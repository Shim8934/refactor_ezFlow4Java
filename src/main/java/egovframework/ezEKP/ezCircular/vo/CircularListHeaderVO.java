package egovframework.ezEKP.ezCircular.vo;

public class CircularListHeaderVO {
	/** 회람판 TYPE*/
	private String listType;
	
	private int sn;
	
	/** header 이름*/
	private String name1;
	/** header 이름(다국어)*/
	private String name2;
	/** header 이름(다국어)*/
	private String name3;
	/** header 이름(다국어)*/
	private String name4;
	/** 헤더 COLUMN 명*/
	private String colName;
	/** 헤더 사이즈*/
	private int width;
	/** TENANT ID*/
	private int tenantID;
	
	public String getListType() {
		return listType;
	}
	public void setListType(String listType) {
		this.listType = listType;
	}
	public int getSn() {
		return sn;
	}
	public void setSn(int sn) {
		this.sn = sn;
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
	public String getColName() {
		return colName;
	}
	public void setColName(String colName) {
		this.colName = colName;
	}
	public int getWidth() {
		return width;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	
}
