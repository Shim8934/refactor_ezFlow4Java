package egovframework.ezEKP.ezWebFolder.vo;

public class WebfolderConfigVO {
	private String companyId;
	private String uploadLimit;
	private String companyTotalLimit;
	private String departmentTotalLimit;
	private String userTotalLimit;
	private int tenantId;

	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}

	public String getUploadLimit() {
		return uploadLimit;
	}

	public void setUploadLimit(String uploadLimit) {
		this.uploadLimit = uploadLimit;
	}

	public String getCompanyTotalLimit() {
		return companyTotalLimit;
	}

	public void setCompanyTotalLimit(String companyTotalLimit) {
		this.companyTotalLimit = companyTotalLimit;
	}

	public String getDepartmentTotalLimit() {
		return departmentTotalLimit;
	}

	public void setDepartmentTotalLimit(String departmentTotalLimit) {
		this.departmentTotalLimit = departmentTotalLimit;
	}

	public String getUserTotalLimit() {
		return userTotalLimit;
	}

	public void setUserTotalLimit(String userTotalLimit) {
		this.userTotalLimit = userTotalLimit;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
}