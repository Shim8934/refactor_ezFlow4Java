package egovframework.ezEKP.ezCircular.vo;

public class CircularFolderVO {
	
	private int circularFolderId;
	
	private String circularFolderName;
	
	private String memberId;
	
	private String regDate;
	
	private int tenantId;
	
	public int getCircularFolderId() {
		return circularFolderId;
	}

	public void setCircularFolderId(int circularFolderId) {
		this.circularFolderId = circularFolderId;
	}

	public String getCircularFolderName() {
		return circularFolderName;
	}

	public void setCircularFolderName(String circularFolderName) {
		this.circularFolderName = circularFolderName;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
}
