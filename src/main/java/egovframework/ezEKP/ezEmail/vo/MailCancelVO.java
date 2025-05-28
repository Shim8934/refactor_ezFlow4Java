package egovframework.ezEKP.ezEmail.vo;

public class MailCancelVO {
	
	private String readerEmail;
	private String readerName;
	private String status;
	private String primaryEmail;
	
	public String getReaderEmail() {
		return readerEmail;
	}
	public void setReaderEmail(String readerEmail) {
		this.readerEmail = readerEmail;
	}
	public String getReaderName() {
		return readerName;
	}
	public void setReaderName(String readerName) {
		this.readerName = readerName;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getPrimaryEmail() {
		return primaryEmail;
	}
	public void setPrimaryEmail(String primaryEmail) {
		this.primaryEmail = primaryEmail;
	}
	@Override
	public String toString() {
		return "MailCancelVO [readerEmail=" + readerEmail + ", readerName=" + readerName + ", status=" + status + ", primaryEmail=" + primaryEmail + "]";
	}
	
}
