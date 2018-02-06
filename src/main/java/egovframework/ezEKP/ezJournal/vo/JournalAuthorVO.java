package egovframework.ezEKP.ezJournal.vo;


public class JournalAuthorVO {

	private String userId;
	private String userName;
	private String jikwi;
	private String deptName;
	private String tenantId;
	private String authDept;
	private String deptId;
	private String mail;
	private String[] authDeptList;
	
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public String getDeptId() {
		return deptId;
	}
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	public String[] getAuthDeptList() {
		return authDeptList;
	}
	public void setAuthDeptList(String[] authDeptList) {
		this.authDeptList = authDeptList;
	}
	public String getAuthDept() {
		return authDept;
	}
	public void setAuthDept(String authDept) {
		this.authDept = authDept;
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
	public String getJikwi() {
		return jikwi;
	}
	public void setJikwi(String jikwi) {
		this.jikwi = jikwi;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getTenantId() {
		return tenantId;
	}
	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}
}
