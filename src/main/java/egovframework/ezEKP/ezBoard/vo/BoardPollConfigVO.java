package egovframework.ezEKP.ezBoard.vo;

public class BoardPollConfigVO {
	private String userId;
	private String defaultStartTime;
	private String defaultEndTime;
	private String targetDepts;
	private String targetUsers;
	private int tenantId;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getDefaultStartTime() {
		return defaultStartTime;
	}
	public void setDefaultStartTime(String defaultStartTime) {
		this.defaultStartTime = defaultStartTime;
	}
	public String getDefaultEndTime() {
		return defaultEndTime;
	}
	public void setDefaultEndTime(String defaultEndTime) {
		this.defaultEndTime = defaultEndTime;
	}
	public String getTargetDepts() {
		return targetDepts;
	}
	public void setTargetDepts(String targetDepts) {
		this.targetDepts = targetDepts;
	}
	public String getTargetUsers() {
		return targetUsers;
	}
	public void setTargetUsers(String targetUsers) {
		this.targetUsers = targetUsers;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
}
