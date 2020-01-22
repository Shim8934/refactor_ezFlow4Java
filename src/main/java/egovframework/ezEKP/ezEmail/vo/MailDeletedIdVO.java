package egovframework.ezEKP.ezEmail.vo;

public class MailDeletedIdVO {

	public long mailBoxId;
	public long mailUid;

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
		return "mailBoxId=" + mailBoxId + ",mailUid=" + mailUid;
	}
	
}
