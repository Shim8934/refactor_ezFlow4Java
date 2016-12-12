package egovframework.ezEKP.ezEmail.vo;

import org.springframework.beans.factory.annotation.Autowired;

import egovframework.let.utl.fcc.service.CommonUtil;

public class MailReadVO {
	
	private String readDate;
	private String readerEmail;
	private String readerName;
	
	@Autowired
	private CommonUtil commonUtil;
	
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
