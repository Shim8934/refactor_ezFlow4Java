package egovframework.ezEKP.ezWebFolder.vo;

public class FileVO {
	private String fileId;
	private String fileName;
	private String filePath;
	private String fileSize;
	private String typeId;
	private int    downloadCnt;
	private String fileExt;
	private String folderId;
	private String useStatus;
	private String createId;
	private String createName1;
	private String createName2;
	private String createDate;
	private String updateId;
	private String updateDate;	
	private int tenantId;
	private String fileIconUrl;
	private String fileShareStatus;
	private String favouriteStatus;
	
	public String getFavouriteStatus() {
		return favouriteStatus;
	}

	public void setFavouriteStatus(String favouriteStatus) {
		this.favouriteStatus = favouriteStatus;
	}

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
	
	public String getTypeId() {
		return typeId;
	}
	
	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}
	
	public int getDownloadCnt() {
		return downloadCnt;
	}
	
	public void setDownloadCnt(int downloadCnt) {
		this.downloadCnt = downloadCnt;
	}
	
	public String getFileExt() {
		return fileExt;
	}
	
	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}
	
	public String getFolderId() {
		return folderId;
	}
	
	public void setFolderId(String folderId) {
		this.folderId = folderId;
	}
	
	public String getUseStatus() {
		return useStatus;
	}
	
	public void setUseStatus(String useStatus) {
		this.useStatus = useStatus;
	}
	
	public String getCreateId() {
		return createId;
	}
	
	public void setCreateId(String createId) {
		this.createId = createId;
	}
	
	public String getCreateName1() {
		return createName1;
	}

	public void setCreateName1(String createName1) {
		this.createName1 = createName1;
	}

	public String getCreateName2() {
		return createName2;
	}

	public void setCreateName2(String createName2) {
		this.createName2 = createName2;
	}

	public String getCreateDate() {
		return createDate;
	}
	
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	
	public String getUpdateId() {
		return updateId;
	}
	
	public void setUpdateId(String updateId) {
		this.updateId = updateId;
	}
	
	public String getUpdateDate() {
		return updateDate;
	}
	
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public String getFileIconUrl() {
		return fileIconUrl;
	}
	
	public void setFileIconUrl(String fileIconUrl) {
		this.fileIconUrl = fileIconUrl;
	}
	
	public String getFileShareStatus() {
		return fileShareStatus;
	}
	
	public void setFileShareStatus(String fileShareStatus) {
		this.fileShareStatus = fileShareStatus;
	}
	
}
