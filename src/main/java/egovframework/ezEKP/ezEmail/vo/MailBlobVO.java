package egovframework.ezEKP.ezEmail.vo;

public class MailBlobVO {

	public long mailBlobId;
	public Long mailBoxId;
	public Long mailUid;

	public long getMailBlobId() {
		return mailBlobId;
	}

	public void setMailBlobId(long mailBlobId) {
		this.mailBlobId = mailBlobId;
	}
		
	public Long getMailBoxId() {
		return mailBoxId;
	}

	public void setMailBoxId(Long mailBoxId) {
		this.mailBoxId = mailBoxId;
	}

	public Long getMailUid() {
		return mailUid;
	}

	public void setMailUid(Long mailUid) {
		this.mailUid = mailUid;
	}

	public String toString() {
		return String.valueOf(mailBlobId);
	}
	
}
