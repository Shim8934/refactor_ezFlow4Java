package egovframework.ezEKP.ezEmail.vo;

public class MailReservationVO {
	
	private String messageId;
	private String sendDate;
	private String subject;
	private String modify;
	private String connUrl;
	
	public String getMessageId() {
		return messageId;
	}
	public void setMessageId(String messageId) {
		this.messageId = messageId;
	}
	public String getSendDate() {
		return sendDate;
	}
	public void setSendDate(String sendDate) {
		this.sendDate = sendDate;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getModify() {
		return modify;
	}
	public void setModify(String modify) {
		this.modify = modify;
	}
	public String getConnUrl() {
		return connUrl;
	}
	public void setConnUrl(String connUrl) {
		this.connUrl = connUrl;
	}
	
	@Override
	public String toString() {
		return "MailReservationVO [messageId=" + messageId + ", sendDate=" + sendDate + ", subject=" + subject
				+ ", modify=" + modify + ", connUrl=" + connUrl + "]";
	}
	
}
