package egovframework.ezEKP.ezEmail.vo;

public class MailLetterBoxVO {
	
	private int letterBoxNo;
	private int parentLetterBoxNo;
	private String displayname;
	private String displayname2;
	private String companyID;
	
	public int getLetterBoxNo() {
		return letterBoxNo;
	}
	public void setLetterBoxNo(int letterBoxNo) {
		this.letterBoxNo = letterBoxNo;
	}
	public int getParentLetterBoxNo() {
		return parentLetterBoxNo;
	}
	public void setParentLetterBoxNo(int parentLetterBoxNo) {
		this.parentLetterBoxNo = parentLetterBoxNo;
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
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	
	@Override
	public String toString() {
		return "MailLetterBoxVO [letterBoxNo=" + letterBoxNo
				+ ", parentLetterBoxNo=" + parentLetterBoxNo + ", displayname="
				+ displayname + ", displayname2=" + displayname2
				+ ", companyID=" + companyID + "]";
	}

}
