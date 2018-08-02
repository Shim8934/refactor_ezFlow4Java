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
	
	public int getType() {
		int mdlType = -1;
		switch(moduleType) {
			case "todo"  : mdlType = 5 ; break;
			case "resrc" : mdlType = 11; break;
			case "projt" : mdlType = 10; break;
			case "jounl" : mdlType = 9 ; break;
			case "option": mdlType = 6 ; break;
			case "commu" : mdlType = 7 ; break;
			case "addrs" : mdlType = 8 ; break;
			case "schedl": mdlType = 4 ; break;
			case "email" : mdlType = 1 ; break;
			case "board" : mdlType = 3 ; break;
			case "apprv" : mdlType = 2 ; break;
		}
		
		return mdlType;
	}
	
	@Override
	public boolean equals(Object object) {
		if (object instanceof CabinetModuleVO) {
			CabinetModuleVO obj = (CabinetModuleVO) object;
			return moduleType.equals(obj.getModuleType()) && companyId.equals(obj.getCompanyId()) && tenantId == obj.tenantId;
		}
		else {
			return false;
		}
	}
	
	@Override
	public int hashCode() {
		return  50 + moduleType.hashCode() + companyId.hashCode() + tenantId;
	}
}
