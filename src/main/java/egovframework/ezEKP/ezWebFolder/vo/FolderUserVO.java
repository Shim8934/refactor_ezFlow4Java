package egovframework.ezEKP.ezWebFolder.vo;

public class FolderUserVO {
	private String userId;
	private String displayName1;
	private String displayName2;
	private String folderId;
	private String userType;
	private boolean subdeptPermitted;
	private boolean folderManager;
	private String displayDeptName1;
	private String displayDeptName2;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getDisplayName1() {
		return displayName1;
	}

	public void setDisplayName1(String displayName1) {
		this.displayName1 = displayName1;
	}

	public String getDisplayName2() {
		return displayName2;
	}

	public void setDisplayName2(String displayName2) {
		this.displayName2 = displayName2;
	}

	public String getFolderId() {
		return folderId;
	}

	public void setFolderId(String folderId) {
		this.folderId = folderId;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public boolean isSubdeptPermitted() {
		return subdeptPermitted;
	}

	public void setSubdeptPermitted(Boolean subdeptPermitted) {
		this.subdeptPermitted = subdeptPermitted;
	}

	public boolean isFolderManager() {
		return folderManager;
	}

	public void setFolderManager(Boolean folderManager) {
		this.folderManager = folderManager;
	}

	public String getDisplayDeptName1() {
		return displayDeptName1;
	}

	public void setDisplayDeptName1(String displayDeptName1) {
		this.displayDeptName1 = displayDeptName1;
	}

	public String getDisplayDeptName2() {
		return displayDeptName2;
	}

	public void setDisplayDeptName2(String displayDeptName2) {
		this.displayDeptName2 = displayDeptName2;
	}
}