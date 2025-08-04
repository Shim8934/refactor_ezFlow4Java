package egovframework.ezEKP.ezApprovalG.vo;

public class KEDAuthorUserInfo {
	private String ownerId;
	private String ownerType;
	private String ownerName;
	private String ownerName2;
	private String ownerCompanyId;

	public String getOwnerName2() {	return ownerName2; }
	public void setOwnerName2(String ownerName2) { this.ownerName2 = ownerName2; }
	public String getOwnerName() {
		return ownerName;
	}
	public void setOwnerName(String ownerName) {
		this.ownerName = ownerName;
	}
	public String getOwnerId() { return ownerId; }
	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}
	public String getOwnerType() {
		return ownerType;
	}
	public void setOwnerType(String ownerType) {
		this.ownerType = ownerType;
	}
	public String getOwnerCompanyId() { 
		return ownerCompanyId; 
	}
	public void setOwnerCompanyId(String ownerCompany) { 
		this.ownerCompanyId = ownerCompany; 
	}
}
