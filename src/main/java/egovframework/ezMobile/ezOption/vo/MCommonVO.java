package egovframework.ezMobile.ezOption.vo;

import java.util.Locale;

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
	
	private String title;			/** 직급 */
	
	private String title2;			/** 직급2 */
	
	private String userFileUrl;		/** 사용자 사진 */
	
	private String email; 			/** 사용자 e-mail*/
	
	private String primary;
	
	/** 2018-07-04 홍승비 - 사용자 전화번호 추가 */
	private String phone;
	
	/** 2018-11-02 박종균 - 최종 로그인 시간 추가 */
	private String lastLogin;
	
	/** 2023-08-28 전인하 - 직위 ID 추가 */
	private String jobId;
	
	private Locale locale;
	/** 2024-08-05 한태훈 - 직책 ID 추가 */
	private String roleId;
	
	public String getLastLogin() {
		return lastLogin;
	}

	public void setLastLogin(String lastLogin) {
		this.lastLogin = lastLogin;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
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

	public String getCompanyName2() {
		return companyName2;
	}

	public void setCompanyName2(String companyName2) {
		this.companyName2 = companyName2;
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

	public String getRollInfo() {
		return rollInfo;
	}

	public void setRollInfo(String rollInfo) {
		this.rollInfo = rollInfo;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getTitle2() {
		return title2;
	}

	public void setTitle2(String title2) {
		this.title2 = title2;
	}

	public String getUserFileUrl() {
		return userFileUrl;
	}

	public void setUserFileUrl(String userFileUrl) {
		this.userFileUrl = userFileUrl;
	}

	public String getPrimary() {
		return primary;
	}

	public void setPrimary(String primary) {
		this.primary = primary;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	public String getJobId() {
		return jobId;
	}
	
	public void setJobId(String jobId) {
		this.jobId = jobId;
	}

	public Locale getLocale() {
		return locale;
	}

	public void setLocale(Locale locale) {
		this.locale = locale;
	}

	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	
}
