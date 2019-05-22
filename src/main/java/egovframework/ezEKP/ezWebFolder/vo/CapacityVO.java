package egovframework.ezEKP.ezWebFolder.vo;

public class CapacityVO {
	private String cn;
	private String type;
	private String totalCapacity;
	private String companyId;
	private String totalUsed;
	private int    usedRate;
	private int    tenantId;

	public String getCn() {
		return cn;
	}

	public void setCn(String cn) {
		this.cn = cn;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getTotalCapacity() {
		return totalCapacity;
	}

	public void setTotalCapacity(String totalCapacity) {
		this.totalCapacity = totalCapacity;
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

	public String getTotalUsed() {
		return totalUsed;
	}

	public void setTotalUsed(String totalUsed) {
		this.totalUsed = totalUsed;
	}

	public int getUsedRate() {
		return usedRate;
	}

	public void setUsedRate(int usedRate) {
		this.usedRate = usedRate;
	}
}