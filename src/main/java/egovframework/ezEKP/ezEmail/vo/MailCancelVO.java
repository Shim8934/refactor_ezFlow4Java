package egovframework.ezEKP.ezEmail.vo;

public class MailCancelVO {
	
	private String readerEmail;
	private String status;
	
	public String getReaderEmail() {
		return readerEmail;
	}
	public void setReaderEmail(String readerEmail) {
		this.readerEmail = readerEmail;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	@Override
	public String toString() {
		return "MailCancelVO [readerEmail=" + readerEmail + ", status=" + status + "]";
	}
	
}
