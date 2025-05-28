package egovframework.ezEKP.ezCabinet.vo;

public class CabinetShareVO {
	private int    shareId;
	private int    cabinetId;
	private String sharerId;
	private String sharerName1;
	private String sharerName2;
	private String sharedId;
	private int    sharedType;
	private int    permission;
	private String shareDate;
	private int    childPermission;
	private int    useStatus;
	private int    saveFlag; // 저장 구분 Flag (검색시 저장 : 0, 최종 저장 : 1)
	private String companyId;
	private int    tenantId;
	
	public int getShareId() {
		return shareId;
	}
	public void setShareId(int shareId) {
		this.shareId = shareId;
	}
	
	public int getCabinetId() {
		return cabinetId;
	}
	
	public void setCabinetId(int cabinetId) {
		this.cabinetId = cabinetId;
	}
	
	public String getSharerId() {
		return sharerId;
	}
	
	public void setSharerId(String sharerId) {
		this.sharerId = sharerId;
	}
	
	public String getSharerName1() {
		return sharerName1;
	}
	
	public void setSharerName1(String sharerName1) {
		this.sharerName1 = sharerName1;
	}
	
	public String getSharerName2() {
		return sharerName2;
	}
	
	public void setSharerName2(String sharerName2) {
		this.sharerName2 = sharerName2;
	}
	
	public String getSharedId() {
		return sharedId;
	}
	
	public void setSharedId(String sharedId) {
		this.sharedId = sharedId;
	}
	
	public int getSharedType() {
		return sharedType;
	}
	
	public void setSharedType(int sharedType) {
		this.sharedType = sharedType;
	}
	
	public int getPermission() {
		return permission;
	}
	
	public void setPermission(int permission) {
		this.permission = permission;
	}
	
	public String getShareDate() {
		return shareDate;
	}
	
	public void setShareDate(String shareDate) {
		this.shareDate = shareDate;
	}
	
	public int getChildPermission() {
		return childPermission;
	}
	
	public void setChildPermission(int childPermission) {
		this.childPermission = childPermission;
	}
	
	public int getUseStatus() {
		return useStatus;
	}
	
	public void setUseStatus(int useStatus) {
		this.useStatus = useStatus;
	}

	public int getSaveFlag() {
		return saveFlag;
	}

	public void setSaveFlag(int saveFlag) {
		this.saveFlag = saveFlag;
	}
	
	public String getCompanyId() {
		return companyId;
	}
	
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
}
