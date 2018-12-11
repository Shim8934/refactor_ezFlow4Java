package egovframework.ezEKP.ezSurvey.vo;

public class AttachVO {
	private long attachId;
	private long targetId;
	private String targetType;
	private String fileName;
	private long   fileSize;
	private String filePath;
	private String companyId;
	private int    tenantId;
	
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
	
	public String getFileName() {
		return fileName;
	}
	
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public long getFileSize() {
		return fileSize;
	}
	
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
	
	public String getFilePath() {
		return filePath;
	}
	
	public void setFilePath(String filePath) {
		this.filePath = filePath;
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
