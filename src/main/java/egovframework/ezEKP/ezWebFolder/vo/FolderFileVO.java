package egovframework.ezEKP.ezWebFolder.vo;

public class FolderFileVO {

	String seqId;
	String userId;
	String userType;
	String folderFileId;
	String folderFileType;
	String createId;
	String createDate;
	String tenantId;
	
	String folderfileName;
	String filePath;
	String fileSize;
	String typeId;
	String folderType;
	String folderPath;
	String useStatus;
	String ownerId;
	String companyId;
	
	public String getFolderfileName() {
		return folderfileName;
	}

	public void setFolderfileName(String folderfileName) {
		this.folderfileName = folderfileName;
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

	public String getFolderType() {
		return folderType;
	}

	public void setFolderType(String folderType) {
		this.folderType = folderType;
	}

	public String getFolderPath() {
		return folderPath;
	}

	public void setFolderPath(String folderPath) {
		this.folderPath = folderPath;
	}

	public String getUseStatus() {
		return useStatus;
	}

	public void setUseStatus(String useStatus) {
		this.useStatus = useStatus;
	}

	public String getOwnerId() {
		return ownerId;
	}

	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}

	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}

	public String getSeqId() {
		return seqId;
	}

	public void setSeqId(String seqId) {
		this.seqId = seqId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public String getFolderFileId() {
		return folderFileId;
	}

	public void setFolderFileId(String folderFileId) {
		this.folderFileId = folderFileId;
	}

	public String getFolderFileType() {
		return folderFileType;
	}

	public void setFolderFileType(String folderFileType) {
		this.folderFileType = folderFileType;
	}

	public String getCreateId() {
		return createId;
	}

	public void setCreateId(String createId) {
		this.createId = createId;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getTenantId() {
		return tenantId;
	}

	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}
	
	@Override
	public String toString() {
		return "FolderFileVO [seqId=" + seqId + ", userId=" + userId
				+ ", userType=" + userType + ", folderFileId=" + folderFileId
				+ ", folderFileType=" + folderFileType + ", createId="
				+ createId + ", createDate=" + createDate + ", tenantId="
				+ tenantId + "]";
	}
		
}
