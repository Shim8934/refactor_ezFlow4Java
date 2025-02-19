package egovframework.ezEKP.ezEmail.vo;

public class MailDeleteVO {
	
	private String userEmail;
	private int itemSeq;
	private int expireTime;
	private String path;
	private String deleteUnread;
	private String folderName;
	private String autoDeletionOption; // 2025.02.18 한슬기 : 편지함 메일 자동삭제 방식 선택옵션(지운편지함으로이동(default) : trash / 영구삭제 : permanently)

	public String getAutoDeletionOption() {
		return autoDeletionOption;
	}
	public void setAutoDeletionOption(String autoDeletionOption) {
		this.autoDeletionOption = autoDeletionOption;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
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
		return "MailDeleteVO [userEmail=" + userEmail + ", itemSeq=" + itemSeq + ", expireTime=" + expireTime + ", path="
				+ path + ", deleteUnread=" + deleteUnread + ", folderName=" + folderName + "]";
	}
	
}
