package egovframework.ezEKP.ezCabinet.vo;

public class UserCapacityVO {
	private String userId;
	private String userName;
	private String departmentId;
	private String departmentName;
	private long   totalCapacity;
	private int    capacityType;
	private String companyId;
	private String companyName;
	private String jobTitle;
	private String totalUsed;
	private int    usedRate;
	private int    tenantId;
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
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
	
	public String getUserName() {
		return userName;
	}
	
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public String getDepartmentId() {
		return departmentId;
	}
	
	public void setDepartmentId(String departmentId) {
		this.departmentId = departmentId;
	}
	
	public String getDepartmentName() {
		return departmentName;
	}
	
	public void setDepartmentName(String departmentName) {
		this.departmentName = departmentName;
	}
	
	public String getCompanyName() {
		return companyName;
	}
	
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	
	public String getJobTitle() {
		return jobTitle;
	}
	
	public void setJobTitle(String jobTitle) {
		this.jobTitle = jobTitle;
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
	
	public int getCapacityType() {
		return capacityType;
	}
	
	public void setCapacityType(int capacityType) {
		this.capacityType = capacityType;
	}
	
	public long getTotalCapacity() {
		return totalCapacity;
	}
	
	public void setTotalCapacity(long totalCapacity) {
		this.totalCapacity = totalCapacity;
	}
}