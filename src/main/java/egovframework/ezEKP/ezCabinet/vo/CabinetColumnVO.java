package egovframework.ezEKP.ezCabinet.vo;

public class CabinetColumnVO {
	private int    columId;
	private int    itemId;
	private String columnName1;
	private String columnName2;
	private String columnValue;
	private String companyId;
	private int    tenantId;
	
	public int getColumId() {
		return columId;
	}
	
	public void setColumId(int columId) {
		this.columId = columId;
	}
	
	public int getItemId() {
		return itemId;
	}
	
	public void setItemId(int itemId) {
		this.itemId = itemId;
	}
	
	public String getColumnName1() {
		return columnName1;
	}
	
	public void setColumnName1(String columnName1) {
		this.columnName1 = columnName1;
	}
	
	public String getColumnName2() {
		return columnName2;
	}
	
	public void setColumnName2(String columnName2) {
		this.columnName2 = columnName2;
	}
	
	public String getColumnValue() {
		return columnValue;
	}
	
	public void setColumnValue(String columnValue) {
		this.columnValue = columnValue;
	}
	
	public String getCompanyId() {
		return companyId;
	}
	
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
}
