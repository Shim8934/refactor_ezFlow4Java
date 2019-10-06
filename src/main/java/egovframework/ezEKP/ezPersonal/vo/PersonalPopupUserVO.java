package egovframework.ezEKP.ezPersonal.vo;

public class PersonalPopupUserVO {

	private int itemSeq;
	private String userId;
	private String userType;
	private String userName;
	private int tenantId;
	private String companyId;
	private boolean subdeptPermitted;
	private int sn;
	
	public int getItemSeq() {
		return itemSeq;
	}
	public void setItemSeq(int itemSeq) {
		this.itemSeq = itemSeq;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserType() {
		return userType;
	}
	public void setUserType(String userType) {
		this.userType = userType;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public boolean isSubdeptPermitted() {
		return subdeptPermitted;
	}
	public void setSubdeptPermitted(boolean subdeptPermitted) {
		this.subdeptPermitted = subdeptPermitted;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	@Override
	public String toString() {
		return "PersonalPopupUserVO [itemSeq=" + itemSeq + ", userId=" + userId + ", userType=" + userType
				+ ", userName=" + userName + ", tenantId=" + tenantId + ", companyId=" + companyId
				+ ", subdeptPermitted=" + subdeptPermitted + "]";
	}
	public int getSn() {
		return sn;
	}
	public void setSn(int sn) {
		this.sn = sn;
	}
}
