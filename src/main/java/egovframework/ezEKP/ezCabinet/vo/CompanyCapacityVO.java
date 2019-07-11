package egovframework.ezEKP.ezCabinet.vo;

public class CompanyCapacityVO {
	private String companyId;
	private int capacityType;
	private String capacityValue;
	private int    tenantId;
	
	public CompanyCapacityVO() {
		
	}
	
	public CompanyCapacityVO(String companyId, int capacityType, String capacityValue, int tenantId) {
		this.companyId     = companyId;
		this.capacityType  = capacityType;
		this.capacityValue = capacityValue;
		this.tenantId      = tenantId;
	}
	
	public String getCompanyId() {
		return companyId;
	}
	
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	public String getCapacityValue() {
		return capacityValue;
	}
	
	public void setCapacityValue(String capacityValue) {
		this.capacityValue = capacityValue;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public int getCapacityType() {
		return capacityType;
	}
	
	public void setCapacityType(int capacityType) {
		this.capacityType = capacityType;
	}
}
