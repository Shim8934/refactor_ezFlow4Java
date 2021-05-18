package egovframework.ezEKP.ezWebFolder.vo;

public class FileVO {
	private String fileId;
	private String fileName;
	private String filePath;
	private long fileSize;
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
	private String filePosition;
	private String fileTypeId;
	private String fileTypeName;
	private String fileIconUrl;
	private String fileShareStatus;
	private String favouriteStatus;
	private String folderName;
	private String folderPath;
	private String deleterId;
	private String owerId;
	private int    tenantId;
	private int    folderSort;
	private int    encryptedFlag;
	/* 카이스트 파일 답글 기능 */
	private int    depth;
	private String rootId;
	private String parentId;
	private String hierarchicalPath;
	/* 만료된 폴더인지 확인을 위한 플래그 값 */
	private boolean isExpired;
	private int version; 

	public String getOwnerId() {
		return owerId;
	}
	
	public void setOwnerId(String owerId) {
		this.owerId = owerId;
	}
	
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

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
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

	public String getFileTypeId() {
		return fileTypeId;
	}

	public void setFileTypeId(String fileTypeId) {
		this.fileTypeId = fileTypeId;
	}

	public String getFileTypeName() {
		return fileTypeName;
	}

	public void setFileTypeName(String fileTypeName) {
		this.fileTypeName = fileTypeName;
	}

	public String getFilePosition() {
		return filePosition;
	}

	public void setFilePosition(String filePosition) {
		this.filePosition = filePosition;
	}

	public String getFolderName() {
		return folderName;
	}

	public void setFolderName(String folderName) {
		this.folderName = folderName;
	}

	public String getFolderPath() {
		return folderPath;
	}

	public void setFolderPath(String folderPath) {
		this.folderPath = folderPath;
	}

	public String getDeleterId() {
		return deleterId;
	}

	public void setDeleterId(String deleterId) {
		this.deleterId = deleterId;
	}

	public int getFolderSort() {
		return folderSort;
	}

	public void setFolderSort(int folderSort) {
		this.folderSort = folderSort;
	}

	public int getEncryptedFlag() {
		return encryptedFlag;
	}

	public void setEncryptedFlag(int encryptedFlag) {
		this.encryptedFlag = encryptedFlag;
	}

	public int getDepth() {
		return depth;
	}

	public void setDepth(int depth) {
		this.depth = depth;
	}

	public String getRootId() {
		return rootId;
	}

	public void setRootId(String rootId) {
		this.rootId = rootId;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getHierarchicalPath() {
		return hierarchicalPath;
	}

	public void setHierarchicalPath(String hierarchicalPath) {
		this.hierarchicalPath = hierarchicalPath;
	}

	public boolean isReply() {
		return depth > 1;
	}

	public boolean isExpired() {
		return isExpired;
	}

	public void setExpired(boolean isExpired) {
		this.isExpired = isExpired;
	}
	
	public int getVersion() {
		return version;
	}

	public void setVersion(int version) {
		this.version = version;
	}

	public boolean isFolder() {
		return "folder".equalsIgnoreCase(typeId);
	}
}