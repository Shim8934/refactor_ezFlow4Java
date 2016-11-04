package egovframework.ezEKP.ezEmail.vo;

import egovframework.let.utl.fcc.service.EgovDateUtil;

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
	
	public void setTimeZoneDate(String offset) {
		readDate = EgovDateUtil.getDateStringInUTC(readDate, offset, false);
	}
	
	@Override
	public String toString() {
		return "MailReadVO [readDate=" + readDate + ", readerEmail=" + readerEmail + ", readerName=" + readerName + "]";
	}
	
}
