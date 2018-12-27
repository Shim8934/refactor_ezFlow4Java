package egovframework.ezEKP.ezAttitude.vo;

public class AttitudeAnnualVO {
	private String userId;
	private String userName;
	private String userTitle;
	private String userDeptName;
	private String year;
	private String useAnnualCnt;
	private String totalAnnualCnt;
	private String companyId;
	private int tenantId;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserTitle() {
		return userTitle;
	}
	public void setUserTitle(String userTitle) {
		this.userTitle = userTitle;
	}
	public String getUserDeptName() {
		return userDeptName;
	}
	public void setUserDeptName(String userDeptName) {
		this.userDeptName = userDeptName;
	}
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public String getUseAnnualCnt() {
		return useAnnualCnt;
	}
	public void setUseAnnualCnt(String useAnnualCnt) {
		this.useAnnualCnt = useAnnualCnt;
	}
	public String getTotalAnnualCnt() {
		return totalAnnualCnt;
	}
	public void setTotalAnnualCnt(String totalAnnualCnt) {
		this.totalAnnualCnt = totalAnnualCnt;
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
