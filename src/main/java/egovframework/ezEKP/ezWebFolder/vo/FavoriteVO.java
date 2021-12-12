package egovframework.ezEKP.ezWebFolder.vo;

public class FavoriteVO {
	private String folderId;
	/** C: 회사 폴더, D: 부서 폴더, U: 개인 폴더 */
	private String folderType;

	private String targetId;
	private String targetName;
	private String targetType;
	private String targetIconUrl;
	private String targetPath;
	private String targetExt;
	private long targetSize;

	private String creatorId;
	private String creatorName;
	private String createDate;

	private String favoriteStatus;
	private int tenantId;

	private int encryptedFlag;
	private int depth;

	public String getFolderId() {
		return folderId;
	}

	public void setFolderId(String folderId) {
		this.folderId = folderId;
	}

	public String getFolderType() {
		return folderType;
	}

	public void setFolderType(String folderType) {
		this.folderType = folderType;
	}

	public String getTargetId() {
		return targetId;
	}

	public void setTargetId(String targetId) {
		this.targetId = targetId;
	}

	public String getTargetName() {
		return targetName;
	}

	public void setTargetName(String targetName) {
		this.targetName = targetName;
	}

	public String getTargetType() {
		return targetType;
	}

	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}

	public String getTargetIconUrl() {
		return targetIconUrl;
	}

	public void setTargetIconUrl(String targetIconUrl) {
		this.targetIconUrl = targetIconUrl;
	}

	public String getTargetPath() {
		return targetPath;
	}

	public void setTargetPath(String targetPath) {
		this.targetPath = targetPath;
	}

	public String getTargetExt() {
		return targetExt;
	}

	public void setTargetExt(String targetExt) {
		this.targetExt = targetExt;
	}

	public long getTargetSize() {
		return targetSize;
	}

	public void setTargetSize(long targetSize) {
		this.targetSize = targetSize;
	}

	public String getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(String creatorId) {
		this.creatorId = creatorId;
	}

	public String getCreatorName() {
		return creatorName;
	}

	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getFavoriteStatus() {
		return favoriteStatus;
	}

	public void setFavoriteStatus(String favoriteStatus) {
		this.favoriteStatus = favoriteStatus;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
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

	public boolean isFolder() {
		return "D".equalsIgnoreCase(targetType);
	}

	public boolean isFile() {
		return "F".equalsIgnoreCase(targetType);
	}

	@Override
	public String toString() {
		return "FavoriteVO [targetId=" + targetId + ", targetName=" + targetName + ", targetType=" + targetType + ", targetIconUrl=" + targetIconUrl + ", targetPath=" + targetPath + ", targetExt="
				+ targetExt + ", targetSize=" + targetSize + ", folderId=" + folderId + ", creatorId=" + creatorId + ", creatorName=" + creatorName + ", createDate=" + createDate + ", favoriteStatus="
				+ favoriteStatus + ", tenantId=" + tenantId + ", encryptedFlag=" + encryptedFlag + ", depth=" + depth + "]";
	}
}
