package egovframework.ezEKP.ezPoll.vo;

public class PollUsersVO {
	private int tenantId;
	private int qstId;
	private String userId;
	private String userName;
	private String userName2;
	private String DeptId;
	private String DeptName;
	private String DeptName2;
	private int userStatus;
	
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public int getQstId() {
		return qstId;
	}
	public void setQstId(int qstId) {
		this.qstId = qstId;
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
	public String getDeptId() {
		return DeptId;
	}
	public void setDeptId(String deptId) {
		DeptId = deptId;
	}
	public String getDeptName() {
		return DeptName;
	}
	public void setDeptName(String deptName) {
		DeptName = deptName;
	}
	public String getDeptName2() {
		return DeptName2;
	}
	public void setDeptName2(String deptName2) {
		DeptName2 = deptName2;
	}
	public int getUserStatus() {
		return userStatus;
	}
	public void setUserStatus(int userStatus) {
		this.userStatus = userStatus;
	}
}
