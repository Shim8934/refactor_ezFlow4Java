package egovframework.ezEKP.ezPersonal.vo;

public class PersonalShareApprovalVO {
	/** 공유를 제공한 사원의 ID*/
	private String ownerId;
	/** 결재공유를 받은 사원의 ID*/
	private String shareUserId;
	/** 결재공유를 받은 사원의 이름*/
	private String shareUserName;
	/** 결재공유를 받은 날짜*/
	private String shareDate;
	/** 결재공유를 받은 사원의 직급*/
	private String shareUserTitle;
	/** 결재공유를 받은 사원의 부서ID*/
	private String shareUserDeptId;
	/** 결재공유를 받은 사원의 부서명*/
	private String shareUserDeptName;
	private int tenantID;
	
	public String getOwnerId() {
		return ownerId;
	}
	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}
	public String getShareUserId() {
		return shareUserId;
	}
	public void setShareUserId(String shareUserId) {
		this.shareUserId = shareUserId;
	}
	public String getShareUserName() {
		return shareUserName;
	}
	public void setShareUserName(String shareUserName) {
		this.shareUserName = shareUserName;
	}
	public String getShareDate() {
		return shareDate;
	}
	public void setShareDate(String shareDate) {
		this.shareDate = shareDate;
	}
	public String getShareUserTitle() {
		return shareUserTitle;
	}
	public void setShareUserTitle(String shareUserTitle) {
		this.shareUserTitle = shareUserTitle;
	}
	public String getShareUserDeptId() {
		return shareUserDeptId;
	}
	public void setShareUserDeptId(String shareUserDeptId) {
		this.shareUserDeptId = shareUserDeptId;
	}
	public String getShareUserDeptName() {
		return shareUserDeptName;
	}
	public void setShareUserDeptName(String shareUserDeptName) {
		this.shareUserDeptName = shareUserDeptName;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
}
