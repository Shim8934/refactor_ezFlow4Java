package egovframework.ezEKP.ezSurvey.vo;

public class SurveyGeneralVO {
	private String userId;
	private String companyId;
	private String previewMode;
	private int    listCount;
	private int    contentWpercent;
	private int    contentHpercent;
	private int    previewWpercent;
	private int    previewHpercent;
	private int    tenantId;
	
	public SurveyGeneralVO() {}
	
	public SurveyGeneralVO(String userId, String companyId, String mode, int listCnt, int contWperct, int contHperct, int prevWperct, int prevHperct, int tenantId) {
		this.userId          = userId;
		this.companyId       = companyId;
		this.previewMode     = mode;
		this.listCount       = listCnt;
		this.contentWpercent = contWperct;
		this.contentHpercent = contHperct;
		this.previewWpercent = prevWperct;
		this.previewHpercent = prevHperct;
		this.tenantId        = tenantId;
	}
	
	public int getListCount() {
		return listCount;
	}
	
	public void setListCount(int listCount) {
		this.listCount = listCount;
	}
	
	public String getPreviewMode() {
		return previewMode;
	}
	
	public void setPreviewMode(String previewMode) {
		this.previewMode = previewMode;
	}
	
	public int getContentWpercent() {
		return contentWpercent;
	}
	
	public void setContentWpercent(int contentWpercent) {
		this.contentWpercent = contentWpercent;
	}
	
	public int getContentHpercent() {
		return contentHpercent;
	}
	
	public void setContentHpercent(int contentHpercent) {
		this.contentHpercent = contentHpercent;
	}
	
	public int getPreviewWpercent() {
		return previewWpercent;
	}
	
	public void setPreviewWpercent(int previewWpercent) {
		this.previewWpercent = previewWpercent;
	}
	
	public int getPreviewHpercent() {
		return previewHpercent;
	}
	
	public void setPreviewHpercent(int previewHpercent) {
		this.previewHpercent = previewHpercent;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public String getCompanyId() {
		return companyId;
	}
	
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
}
