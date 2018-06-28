package egovframework.ezEKP.ezEmail.vo;

public class MailPOP3VO {
	
	private String pop3Server;
	private String pop3PortNo;
	private String pop3UserId;
	private String pop3Pw;
	private String saveTo;
	private String deleteYN;
	private String pop3SslYN;
	private String saveTofolder;
	
	public String getPop3Server() {
		return pop3Server;
	}
	public void setPop3Server(String pop3Server) {
		this.pop3Server = pop3Server;
	}
	public String getPop3PortNo() {
		return pop3PortNo;
	}
	public void setPop3PortNo(String pop3PortNo) {
		this.pop3PortNo = pop3PortNo;
	}
	public String getPop3UserId() {
		return pop3UserId;
	}
	public void setPop3UserId(String pop3UserId) {
		this.pop3UserId = pop3UserId;
	}
	public String getPop3Pw() {
		return pop3Pw;
	}
	public void setPop3Pw(String pop3Pw) {
		this.pop3Pw = pop3Pw;
	}
	public String getSaveTo() {
		return saveTo;
	}
	public void setSaveTo(String saveTo) {
		this.saveTo = saveTo;
	}
	public String getDeleteYN() {
		return deleteYN;
	}
	public void setDeleteYN(String deleteYN) {
		this.deleteYN = deleteYN;
	}
	public String getPop3SslYN() {
		return pop3SslYN;
	}
	public void setPop3SslYN(String pop3SslYN) {
		this.pop3SslYN = pop3SslYN;
	}
	public String getSaveTofolder() {
		return saveTofolder;
	}
	public void setSaveTofolder(String saveTofolder) {
		this.saveTofolder = saveTofolder;
	}
	
	@Override
	public String toString() {
		return "MailPOP3VO [pop3Server=" + pop3Server + ", pop3PortNo=" + pop3PortNo + ", pop3UserId=" + pop3UserId
				+ ", pop3Pw=" + pop3Pw + ", saveTo=" + saveTo + ", deleteYN=" + deleteYN + ", pop3SslYN=" + pop3SslYN
				+ ", saveTofolder=" + saveTofolder + "]";
	}
	
}
