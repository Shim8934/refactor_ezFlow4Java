package egovframework.ezEKP.ezEmail.vo;

public class MailBlobVO {

	public long mailBlobId;
	public long mailBoxId;
	public long mailUid;

	public long getMailBlobId() {
		return mailBlobId;
	}

	public void setMailBlobId(long mailBlobId) {
		this.mailBlobId = mailBlobId;
	}
		
	public long getMailBoxId() {
		return mailBoxId;
	}

	public void setMailBoxId(long mailBoxId) {
		this.mailBoxId = mailBoxId;
	}

	public long getMailUid() {
		return mailUid;
	}

	public void setMailUid(long mailUid) {
		this.mailUid = mailUid;
	}

	public String toString() {
		return String.valueOf(mailBlobId);
	}
	
}
