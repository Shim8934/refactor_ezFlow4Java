package egovframework.ezMobile.ezSurvey.vo;

public class MAttachVO {
	private long   attachId;
	private long   surveyId;
	private long   targetId;
	private String targetType;
	private String fname;
	private String furl;
	private long   fileSize;
	private String fpath;
	private String companyId;
	private int    tenantId;
	
	public String getFurl() {
		return furl;
	}
	
	public void setFurl(String furl) {
		this.furl = furl;
	}
	
	public long getAttachId() {
		return attachId;
	}
	
	public void setAttachId(long attachId) {
		this.attachId = attachId;
	}
	
	public long getTargetId() {
		return targetId;
	}
	
	public void setTargetId(long targetId) {
		this.targetId = targetId;
	}
	
	public String getTargetType() {
		return targetType;
	}
	
	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}
	
	public long getFileSize() {
		return fileSize;
	}
	
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
	
	public String getFname() {
		return fname;
	}
	
	public void setFname(String fname) {
		this.fname = fname;
	}
	
	public String getFpath() {
		return fpath;
	}
	
	public void setFpath(String fpath) {
		this.fpath = fpath;
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
	
	public long getSurveyId() {
		return surveyId;
	}
	
	public void setSurveyId(long surveyId) {
		this.surveyId = surveyId;
	}
}
