package egovframework.ezEKP.ezEmail.vo;

public class MailSecureVO {
	
	private String secureId;
	private String userAccount;
	private String folderPath;
	private String mailUid;
	private String password;
	private String maxReadCount;
	private String maxReadDate;
	private String readCount;
	
	public String getSecureId() {
		return secureId;
	}
	public void setSecureId(String secureId) {
		this.secureId = secureId;
	}
	public String getUserAccount() {
		return userAccount;
	}
	public void setUserAccount(String userAccount) {
		this.userAccount = userAccount;
	}
	public String getFolderPath() {
		return folderPath;
	}
	public void setFolderPath(String folderPath) {
		this.folderPath = folderPath;
	}
	public String getMailUid() {
		return mailUid;
	}
	public void setMailUid(String mailUid) {
		this.mailUid = mailUid;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getMaxReadCount() {
		return maxReadCount;
	}
	public void setMaxReadCount(String maxReadCount) {
		this.maxReadCount = maxReadCount;
	}
	public String getMaxReadDate() {
		return maxReadDate;
	}
	public void setMaxReadDate(String maxReadDate) {
		this.maxReadDate = maxReadDate;
	}
	public String getReadCount() {
		return readCount;
	}
	public void setReadCount(String readCount) {
		this.readCount = readCount;
	}
	
	@Override
	public String toString() {
		return "MailSecureVO [userAccount=" + userAccount + ", folderPath=" + folderPath + ", mailUid=" + mailUid
				+ ", password=" + password + ", maxReadCount=" + maxReadCount + ", maxReadDate=" + maxReadDate
				+ ", readCount=" + readCount + "]";
	}
	
}
