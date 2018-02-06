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
