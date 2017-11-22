package egovframework.ezMobile.ezEmail.vo;

public class MEmailMessageVO {
	private String subject;
	private String sender;
	private int importance;
	private int size;
	private int read;
	private String href;
	private int attach;
	private int flag;
	private String fromemail;
	private String receivedt;
	private String contentclass;
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getSender() {
		return sender;
	}
	public void setSender(String sender) {
		this.sender = sender;
	}
	public int getImportance() {
		return importance;
	}
	public void setImportance(int importance) {
		this.importance = importance;
	}
	public int getSize() {
		return size;
	}
	public void setSize(int size) {
		this.size = size;
	}
	public int getRead() {
		return read;
	}
	public void setRead(int read) {
		this.read = read;
	}
	public String getHref() {
		return href;
	}
	public void setHref(String href) {
		this.href = href;
	}
	public int getAttach() {
		return attach;
	}
	public void setAttach(int attach) {
		this.attach = attach;
	}
	public int getFlag() {
		return flag;
	}
	public void setFlag(int flag) {
		this.flag = flag;
	}
	public String getFromemail() {
		return fromemail;
	}
	public void setFromemail(String fromemail) {
		this.fromemail = fromemail;
	}
	public String getReceivedt() {
		return receivedt;
	}
	public void setReceivedt(String receivedt) {
		this.receivedt = receivedt;
	}
	public String getContentclass() {
		return contentclass;
	}
	public void setContentclass(String contentclass) {
		this.contentclass = contentclass;
	}
	
}
