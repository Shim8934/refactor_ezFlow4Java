package egovframework.ezEKP.ezAddress.vo;

public class AddressFolderVO {	
	private String folderId;
	private String parentId;
	private String ownerId;
	private String folderType;
	private String folderName;
	private String childCount;
	
	public String getFolderId() {
		return folderId;
	}
	public void setFolderId(String folderId) {
		this.folderId = folderId;
	}
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	public String getOwnerId() {
		return ownerId;
	}
	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}
	public String getFolderType() {
		return folderType;
	}
	public void setFolderType(String folderType) {
		this.folderType = folderType;
	}
	public String getFolderName() {
		return folderName;
	}
	public void setFolderName(String folderName) {
		this.folderName = folderName;
	}
	public String getChildCount() {
		return childCount;
	}
	public void setChildCount(String childCount) {
		this.childCount = childCount;
	}
	
	@Override
	public String toString() {
		return "AddressFolderVO [folderId=" + folderId + ", parentId=" + parentId + ", ownerId=" + ownerId
				+ ", folderType=" + folderType + ", folderName=" + folderName + ", childCount=" + childCount + "]";
	}
}
