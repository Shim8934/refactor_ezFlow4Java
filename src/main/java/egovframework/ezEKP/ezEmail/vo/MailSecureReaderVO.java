package egovframework.ezEKP.ezEmail.vo;

public class MailSecureReaderVO {
	
	private String secureId;
	private String reader;
	private String readCount;
	private String readDate;
	
	public String getSecureId() {
		return secureId;
	}
	public void setSecureId(String secureId) {
		this.secureId = secureId;
	}
	public String getReader() {
		return reader;
	}
	public void setReader(String reader) {
		this.reader = reader;
	}
	public String getReadCount() {
		return readCount;
	}
	public void setReadCount(String readCount) {
		this.readCount = readCount;
	}
	public String getReadDate() {
		return readDate;
	}
	public void setReadDate(String readDate) {
		this.readDate = readDate;
	}
	
	@Override
	public String toString() {
		return "MailSecureReaderVO [secureId=" + secureId + ", reader=" + reader + ", readCount=" + readCount
				+ ", readDate=" + readDate + "]";
	}
	
}
