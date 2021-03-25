package egovframework.ezEKP.ezCabinet.vo;

public class CabinetColumnVO {
	private String columnId;
	private int    itemId;
	private String columnName;
	private String columnName1;
	private String columnName2;
	private String columnValue;
	private String companyId;
	private int    tenantId;
	
	public CabinetColumnVO() {}
	
	public CabinetColumnVO(String columnId, int itemId, String columnNm1, String columnNm2, String columnVal, String companyId, int tenantId) {
		this.columnId    = columnId;
		this.itemId      = itemId;
		this.columnName1 = columnNm1;
		this.columnName2 = columnNm2;
		this.columnValue = columnVal;
		this.companyId   = companyId;
		this.tenantId    = tenantId;
	}
	
	public String getColumnId() {
		return columnId;
	}
	
	public void setColumnId(String columnId) {
		this.columnId = columnId;
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
	
	public String getColumnName() {
		return columnName;
	}
	
	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}
}
