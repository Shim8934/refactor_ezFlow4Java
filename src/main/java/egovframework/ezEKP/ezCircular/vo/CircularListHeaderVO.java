package egovframework.ezEKP.ezCircular.vo;

public class CircularListHeaderVO {
	/** 회람판 TYPE*/
	private String listType;
	
	private int sn;
	/** header 이름*/
	private String name;
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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
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
