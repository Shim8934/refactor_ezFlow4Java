package egovframework.ezEKP.ezEmail.vo;

public class MailDeleteVO {
	
	private String userId;
	private int itemSeq;
	private int expireTime;
	private String path;
	private String deleteUnread;
	private String folderName;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getItemSeq() {
		return itemSeq;
	}
	public void setItemSeq(int itemSeq) {
		this.itemSeq = itemSeq;
	}
	public int getExpireTime() {
		return expireTime;
	}
	public void setExpireTime(int expireTime) {
		this.expireTime = expireTime;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getDeleteUnread() {
		return deleteUnread;
	}
	public void setDeleteUnread(String deleteUnread) {
		this.deleteUnread = deleteUnread;
	}
	public String getFolderName() {
		return folderName;
	}
	public void setFolderName(String folderName) {
		this.folderName = folderName;
	}
	
	@Override
	public String toString() {
		return "MailDeleteVO [userId=" + userId + ", itemSeq=" + itemSeq + ", expireTime=" + expireTime + ", path="
				+ path + ", deleteUnread=" + deleteUnread + ", folderName=" + folderName + "]";
	}
	
}
