package egovframework.ezEKP.ezEmail.vo;

public class MailSharedMailboxUserVO {
	
	private String userId;
	private String userName;
	private String deptId;
	private String deptName;
	private String compId;
	private String compName;
	private String deletePermission;
	private String sendPermission;
	private String shareId;
	private String shareName;
	
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
	
	public String getCompId() {
		return compId;
	}
	
	public void setCompId(String compId) {
		this.compId = compId;
	}
	
	public String getCompName() {
		return compName;
	}
	
	public void setCompName(String compName) {
		this.compName = compName;
	}
	
	public String getDeletePermission() {
		return deletePermission;
	}
	
	public void setDeletePermission(String deletePermission) {
		this.deletePermission = deletePermission;
	}
	
	public String getSendPermission() {
		return sendPermission;
	}
	
	public void setSendPermission(String sendPermission) {
		this.sendPermission = sendPermission;
	}
	
	public String getShareId() {
		return shareId;
	}
	
	public void setShareId(String shareId) {
		this.shareId = shareId;
	}
	
	public String getShareName() {
		return shareName;
	}
	
	public void setShareName(String shareName) {
		this.shareName = shareName;
	}
	
	@Override
	public String toString() {
		return "MailSharedMailboxUserVO [userId=" + userId + ", userName=" + userName + ", deptId=" + deptId
				+ ", deptName=" + deptName + ", compId=" + compId + ", compName=" + compName + ", deletePermission="
				+ deletePermission + ", sendPermission=" + sendPermission + ", shareId=" + shareId + ", shareName="
				+ shareName + "]";
	}
	
}
