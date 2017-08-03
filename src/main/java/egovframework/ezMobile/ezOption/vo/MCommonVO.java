package egovframework.ezMobile.ezOption.vo;

public class MCommonVO {
	
	private int tenantId;			/** 서버 tenantId */
	
	private String lang;			/** 개인환경설정  언어설정 */
	
	private String offSet;			/** 개인환경설정  utc설정  */
	
	private String deptId;			/** 부서Id  */
	
	private String deptName;		/** 부서이름    */
	
	private String deptName2;		/** 부서이름2  */
	
	private String companyId;		/** 회사Id  */
	
	private String companyName;		/** 회사이름    */
	
	private String companyName2;	/** 회사이름2  */
	
	private String userId;			/** 사용자Id  */
	
	private String userName;		/** 사용자이름  */
	
	private String userName2;		/** 사용자이름2  */
	
	private String rollInfo;		/** 사용자 권한  */

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}

	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}

	public String getOffSet() {
		return offSet;
	}

	public void setOffSet(String offSet) {
		this.offSet = offSet;
	}

	public String getDeptId() {
		return deptId;
	}

	public void setDeptId(String deptId) {
		this.deptId = deptId;
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

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserName2() {
		return userName2;
	}

	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getDeptName2() {
		return deptName2;
	}

	public void setDeptName2(String deptName2) {
		this.deptName2 = deptName2;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getCompanyName2() {
		return companyName2;
	}

	public void setCompanyName2(String companyName2) {
		this.companyName2 = companyName2;
	}

	public String getRollInfo() {
		return rollInfo;
	}

	public void setRollInfo(String rollInfo) {
		this.rollInfo = rollInfo;
	}
	
	
}
