package egovframework.ezEKP.ezEmail.vo;

public class MailSignatureTemplateVO {
	private String signNo;
	private String content;
	private String displayname;
	private String displayname2;
	private String tenantId;
	private String companyId;
	
	public String getSignNo() {
		return signNo;
	}
	
	public void setSignNo(String signNo) {
		this.signNo = signNo;
	}
	
	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
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
	
	public String getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}
	
	public String getCompanyId() {
		return companyId;
	}
	
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
}
