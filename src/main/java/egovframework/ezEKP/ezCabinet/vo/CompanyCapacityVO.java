package egovframework.ezEKP.ezCabinet.vo;

public class CompanyCapacityVO {
	private String companyId;
	private String capacityValue;
	private int    tenantId;
	
	public CompanyCapacityVO() {
		
	}
	
	public CompanyCapacityVO(String companyId, String capacityValue, int tenantId) {
		this.companyId     = companyId;
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
}
