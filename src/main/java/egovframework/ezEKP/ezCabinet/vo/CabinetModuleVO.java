package egovframework.ezEKP.ezCabinet.vo;

public class CabinetModuleVO {
	private String companyId;
	private String userId;
	private String moduleType;
	private int    activeStatus;
	private int    tenantId;
	
	public CabinetModuleVO() {}
	
	public CabinetModuleVO(String companyId, String moduleType, int activeStatus, int tenantId) {
		this.companyId    = companyId;
		this.moduleType   = moduleType;
		this.activeStatus = activeStatus;
		this.tenantId     = tenantId;
	}
	
	public CabinetModuleVO(String companyId, String userId, String moduleType, int activeStatus, int tenantId) {
		this.companyId    = companyId;
		this.userId       = userId;
		this.moduleType   = moduleType;
		this.activeStatus = activeStatus;
		this.tenantId     = tenantId;
	}
	
	public String getCompanyId() {
		return companyId;
	}
	
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public String getModuleType() {
		return moduleType;
	}
	
	public void setModuleType(String moduleType) {
		this.moduleType = moduleType;
	}
	
	public int getActiveStatus() {
		return activeStatus;
	}

	public void setActiveStatus(int activeStatus) {
		this.activeStatus = activeStatus;
	}

	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
}
