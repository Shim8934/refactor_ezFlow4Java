package egovframework.ezEKP.ezPMS.vo;

public class TaskMemberVO {
	
	private long taskMemberId;

	private int tenantId;

	private long taskId;
	
	private String userId;
	
	private String userName;
	
	private String userName2;
	
	private String userDeptname;
	
	private String userDeptname2;
	
	private float pctinput;
	
	private String planStartDate;
	
	private String planEndDate;
	
	public long getTaskMemberId() {
		return taskMemberId;
	}

	public void setTaskMemberId(long taskMemberId) {
		this.taskMemberId = taskMemberId;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}

	public long getTaskId() {
		return taskId;
	}

	public void setTaskId(long taskId) {
		this.taskId = taskId;
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

	public String getUserDeptname() {
		return userDeptname;
	}

	public void setUserDeptname(String userDeptname) {
		this.userDeptname = userDeptname;
	}

	public String getUserDeptname2() {
		return userDeptname2;
	}

	public void setUserDeptname2(String userDeptname2) {
		this.userDeptname2 = userDeptname2;
	}

	public float getPctinput() {
		return pctinput;
	}

	public void setPctinput(float pctinput) {
		this.pctinput = pctinput;
	}

	public String getPlanStartDate() {
		return planStartDate;
	}

	public void setPlanStartDate(String planStartDate) {
		this.planStartDate = planStartDate;
	}

	public String getPlanEndDate() {
		return planEndDate;
	}

	public void setPlanEndDate(String planEndDate) {
		this.planEndDate = planEndDate;
	}
}
