package egovframework.ezEKP.ezWebFolder.vo;

public class FileVO {
	private String fileId;
	private String fileName;
	private String filePath;
	private String fileSize;
	private String fileExt;
	private String fileFavourite;
	private String uploaderId;
	private String uploaderName;
	private String createdDate;
	private String updatedDate;
	private String folderId;
	private int tenantId;
	
	public String getFileId() {
		return fileId;
	}
	
	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	
	public String getFileName() {
		return fileName;
	}
	
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public String getFilePath() {
		return filePath;
	}
	
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	
	public String getFileSize() {
		return fileSize;
	}
	
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
	
	public String getFileExt() {
		return fileExt;
	}
	
	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}
	
	public String getFileFavourite() {
		return fileFavourite;
	}
	
	public void setFileFavourite(String fileFavourite) {
		this.fileFavourite = fileFavourite;
	}
	
	public String getUploaderId() {
		return uploaderId;
	}
	
	public void setUploaderId(String uploaderId) {
		this.uploaderId = uploaderId;
	}
	
	public String getUploaderName() {
		return uploaderName;
	}
	
	public void setUploaderName(String uploaderName) {
		this.uploaderName = uploaderName;
	}
	
	public String getCreatedDate() {
		return createdDate;
	}
	
	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}
	
	public String getUpdatedDate() {
		return updatedDate;
	}

	public void setUpdatedDate(String updatedDate) {
		this.updatedDate = updatedDate;
	}

	public String getFolderId() {
		return folderId;
	}
	
	public void setFolderId(String folderId) {
		this.folderId = folderId;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}	
	
}
