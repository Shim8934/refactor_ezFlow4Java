package egovframework.ezEKP.ezCircular.vo;

public class CircularFolderVO {
	
	private int circularFolderID;
	
	private String circularFolderName;
	
	private String memberID;
	
	private String regDate;
	
	private String originLocation;

	private int tenantID;

	public int getCircularFolderID() {
		return circularFolderID;
	}

	public void setCircularFolderID(int circularFolderID) {
		this.circularFolderID = circularFolderID;
	}

	public String getCircularFolderName() {
		return circularFolderName;
	}

	public void setCircularFolderName(String circularFolderName) {
		this.circularFolderName = circularFolderName;
	}

	public String getMemberID() {
		return memberID;
	}

	public void setMemberID(String memberID) {
		this.memberID = memberID;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public int getTenantID() {
		return tenantID;
	}

	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	
	public String getOriginLocation() {
		return originLocation;
	}

	public void setOriginLocation(String originLocation) {
		this.originLocation = originLocation;
	}
}
