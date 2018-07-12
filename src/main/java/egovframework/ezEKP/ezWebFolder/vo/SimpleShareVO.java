package egovframework.ezEKP.ezWebFolder.vo;

import java.util.List;

public class SimpleShareVO {
	private String folderFileId;	
	private String folderFileType;
	private String shareId;
	private String sharerId;
	private String sharerName;
	private String shareDate;
	private int    tenantId;
	private List<ShareSubVO> userList;
	
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
	public String getShareId() {
		return shareId;
	}
	public void setShareId(String shareId) {
		this.shareId = shareId;
	}
	public String getSharerId() {
		return sharerId;
	}
	public void setSharerId(String sharerId) {
		this.sharerId = sharerId;
	}
	public String getSharerName() {
		return sharerName;
	}
	public void setSharerName(String sharerName) {
		this.sharerName = sharerName;
	}
	public String getShareDate() {
		return shareDate;
	}
	public void setShareDate(String shareDate) {
		this.shareDate = shareDate;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public List<ShareSubVO> getUserList() {
		return userList;
	}
	public void setUserList(List<ShareSubVO> userList) {
		this.userList = userList;
	}
	
}