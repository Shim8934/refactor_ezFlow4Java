package egovframework.ezEKP.ezCircular.vo;

public class CircularConfirmVO {
	/** 확인자아이디*/
	private String memberID;
	/** 확인자이름*/
	private String displayName;
	/** 확인자부서명*/
	private String description;
	/** 확인자회사명*/
	private String company;
	/** 확인자직급*/
	private String title;
	/** 확인일시*/
	private String confirmDate;
	public String getMemberID() {
		return memberID;
	}
	public void setMemberID(String memberID) {
		this.memberID = memberID;
	}
	public String getDisplayName() {
		return displayName;
	}
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getConfirmDate() {
		return confirmDate;
	}
	public void setConfirmDate(String confirmDate) {
		this.confirmDate = confirmDate;
	}
	
}
