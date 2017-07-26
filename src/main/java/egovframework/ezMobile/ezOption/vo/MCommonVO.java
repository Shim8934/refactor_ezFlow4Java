package egovframework.ezMobile.ezOption.vo;

public class MCommonVO {
	
	private int tenantId;			/** 서버 tenantId */
	
	private int lang;				/** 개인환경설정  언어설정 */
	
	private String offSet;			/** 개인환경설정  utc설정  */
	
	private String deptId;			/** 부서Id  */
	
	private String companyId;		/** 회사Id  */

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}

	public int getLang() {
		return lang;
	}

	public void setLang(int lang) {
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
	
}
