package egovframework.ezEKP.ezApproval.vo;

public class ApprFormContVO {

	/** */
	private String formContID;
	/** */
	private String formContName;
	/** */
	private String formContName2;
	/** */
	private String formContOwnDepID;
	/** */
	private String formContParents;
	/** */
	private String formContDescription;
	/** */
	private String formContDept;
	/** */
	private String companyID;
	/** */
	private int tenantID;
	/** */
	private int id;
	/** 그룹별로 권한 줄때 사용*/
	private String formContDepts;
	
	public String getFormContID() {
		return formContID;
	}
	public void setFormContID(String formContID) {
		this.formContID = formContID;
	}
	public String getFormContName() {
		return formContName;
	}
	public void setFormContName(String formContName) {
		this.formContName = formContName;
	}
	public String getFormContOwnDepID() {
		return formContOwnDepID;
	}
	public void setFormContOwnDepID(String formContOwnDepID) {
		this.formContOwnDepID = formContOwnDepID;
	}
	public String getFormContParents() {
		return formContParents;
	}
	public void setFormContParents(String formContParents) {
		this.formContParents = formContParents;
	}
	public String getFormContDescription() {
		return formContDescription;
	}
	public void setFormContDescription(String formContDescription) {
		this.formContDescription = formContDescription;
	}
	public String getFormContName2() {
		return formContName2;
	}
	public void setFormContName2(String formContName2) {
		this.formContName2 = formContName2;
	}
	public String getFormContDept() {
		return formContDept;
	}
	public void setFormContDept(String formContDept) {
		this.formContDept = formContDept;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getFormContDepts() {
		return formContDepts;
	}
	public void setFormContDepts(String formContDepts) {
		this.formContDepts = formContDepts;
	}
	
}
