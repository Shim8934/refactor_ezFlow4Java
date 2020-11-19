package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGPreviewVO {
	/** 유저아이디*/
	private String userId; 
	/** OFF, W, H 표시*/
	private String preview; 
	/** tenant*/
	private int tenantID;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getPreview() {
		return preview;
	}
	public void setPreview(String preview) {
		this.preview = preview;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
}
