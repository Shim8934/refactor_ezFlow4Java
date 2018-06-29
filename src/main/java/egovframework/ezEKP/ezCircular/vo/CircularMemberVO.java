package egovframework.ezEKP.ezCircular.vo;

public class CircularMemberVO {
	private String circularBMUserId;
	
	/** 회람처 ID */
	private int circularBMID;
	/** 작성자 */
	private String memberID;
	
	private String memberName;
	
	private String memberName2;
	
	private String company;
	
	private String description;
	
	private String title;
	
	private String mail;
	
	int tenantID;

	public String getCircularBMUserId() {
		return circularBMUserId;
	}

	public void setCircularBMUserId(String circularBMUserId) {
		this.circularBMUserId = circularBMUserId;
	}

	public int getCircularBMID() {
		return circularBMID;
	}

	public void setCircularBMID(int circularBMID) {
		this.circularBMID = circularBMID;
	}

	public String getMemberID() {
		return memberID;
	}

	public void setMemberID(String memberID) {
		this.memberID = memberID;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getMemberName2() {
		return memberName2;
	}

	public void setMemberName2(String memberName2) {
		this.memberName2 = memberName2;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getMail() {
		return mail;
	}

	public void setMail(String mail) {
		this.mail = mail;
	}

	public int getTenantID() {
		return tenantID;
	}

	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}	
	
	
}