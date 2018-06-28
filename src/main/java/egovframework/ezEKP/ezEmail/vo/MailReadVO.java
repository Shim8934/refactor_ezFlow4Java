package egovframework.ezEKP.ezEmail.vo;

public class MailReadVO {
	
	private String readDate;
	private String readerEmail;
	private String readerName;
	
	public String getReadDate() {
		return readDate;
	}
	public void setReadDate(String readDate) {
		this.readDate = readDate;
	}
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
	
	@Override
	public String toString() {
		return "MailReadVO [readDate=" + readDate + ", readerEmail=" + readerEmail + ", readerName=" + readerName + "]";
	}
	
}
