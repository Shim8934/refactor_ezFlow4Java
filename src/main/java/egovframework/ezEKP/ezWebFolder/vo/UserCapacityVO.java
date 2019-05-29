package egovframework.ezEKP.ezWebFolder.vo;

public class UserCapacityVO {
	private String cn;
	private String type;
	private String displayName;
	private String companyId;
	private String companyName;
	private String departmentName;
	private String jobTitle;
	private String totalCapacity;
	private String totalUsed;
	private int usedRate;
	private int tenantId;

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

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getDepartmentName() {
		return departmentName;
	}

	public void setDepartmentName(String departmentName) {
		this.departmentName = departmentName;
	}

	public String getJobTitle() {
		return jobTitle;
	}

	public void setJobTitle(String jobTitle) {
		this.jobTitle = jobTitle;
	}

	public String getTotalCapacity() {
		return totalCapacity;
	}

	public void setTotalCapacity(String totalCapacity) {
		this.totalCapacity = totalCapacity;
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

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
}