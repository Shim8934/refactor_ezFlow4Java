package egovframework.ezMobile.ezOption.vo;

public class MCommonVO {
	
	private int tenantId;			/** 서버 tenantId */
	
	private String lang;			/** 개인환경설정  언어설정 */
	
	private String offSet;			/** 개인환경설정  utc설정  */
	
	private String deptId;			/** 부서Id  */
	
	private String companyId;		/** 회사Id  */
	
	private String userId;			/** 사용자Id  */
	
	private String userName;		/** 사용자이름  */
	
	private String userName2;		/** 사용자이름2  */

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
	
}
