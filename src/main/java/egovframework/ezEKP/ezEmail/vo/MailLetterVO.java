package egovframework.ezEKP.ezEmail.vo;

public class MailLetterVO {
	
	private int letterNo;
	private String displayname;
	private String displayname2;
	private int letterOrder;
	private int letterBoxNo;
	private String letterId;
	private String letterContent;
	
	public int getLetterNo() {
		return letterNo;
	}
	public void setLetterNo(int letterNo) {
		this.letterNo = letterNo;
	}
	public String getDisplayname() {
		return displayname;
	}
	public void setDisplayname(String displayname) {
		this.displayname = displayname;
	}
	public String getDisplayname2() {
		return displayname2;
	}
	public void setDisplayname2(String displayname2) {
		this.displayname2 = displayname2;
	}
	public int getLetterOrder() {
		return letterOrder;
	}
	public void setLetterOrder(int letterOrder) {
		this.letterOrder = letterOrder;
	}
	public int getLetterBoxNo() {
		return letterBoxNo;
	}
	public void setLetterBoxNo(int letterBoxNo) {
		this.letterBoxNo = letterBoxNo;
	}
	public String getLetterId() {
		return letterId;
	}
	public void setLetterId(String letterId) {
		this.letterId = letterId;
	}
	public String getLetterContent() {
		return letterContent;
	}
	public void setLetterContent(String letterContent) {
		this.letterContent = letterContent;
	}
	
	@Override
	public String toString() {
		return "MailLetterVO [letterNo=" + letterNo + ", displayname="
				+ displayname + ", displayname2=" + displayname2
				+ ", letterOrder=" + letterOrder + ", letterBoxNo="
				+ letterBoxNo + ", letterId=" + letterId + ", "
						+ "letterContent=" + letterContent + "]";
	}
	
}
