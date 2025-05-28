package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGDocAttachInfoVO {
	/** 문서아이디*/
	private String docID;
	/* 첨부될 문서 아이디 */
	private String newDocID;
	/** 첨부순번*/
	private String attachSN;
	/** 첨부문서이름*/
	private String attachDocName;
	/** 첨부문서경로*/
	private String attachDocURL;
	/** 추가첨부정보*/
	private String subAttachYN;
	/** 첨부자아이디*/
	private String attachUserID;
	/** 첨부자이름*/
	private String attachUserName;
	/** 첨부자부서아이디*/
	private String attachUserDeptID;
	/** 첨부자부서이름*/
	private String attachUserDeptName;
	/** 첨부자직위*/
	private String attachUserJobTitle;
	/** 첨부자이름(다국어)*/
	private String attachUserName2;
	/** 첨부자직위(다국어)*/
	private String attachUserJobTitle2;
	/** 첨부자부서이름(다국어)*/
	private String attachUserDeptName2;
	private String companyID;
	private int tenantID;
	
	public String getDocID() {
		return docID;
	}
	public void setDocID(String docID) {
		this.docID = docID;
	}
	public String getNewDocID() {
		return newDocID;
	}
	public void setNewDocID(String newDocID) {
		this.newDocID = newDocID;
	}
	public String getAttachSN() {
		return attachSN;
	}
	public void setAttachSN(String attachSN) {
		this.attachSN = attachSN;
	}
	public String getAttachDocName() {
		return attachDocName;
	}
	public void setAttachDocName(String attachDocName) {
		this.attachDocName = attachDocName;
	}
	public String getAttachDocURL() {
		return attachDocURL;
	}
	public void setAttachDocURL(String attachDocURL) {
		this.attachDocURL = attachDocURL;
	}
	public String getSubAttachYN() {
		return subAttachYN;
	}
	public void setSubAttachYN(String subAttachYN) {
		this.subAttachYN = subAttachYN;
	}
	public String getAttachUserID() {
		return attachUserID;
	}
	public void setAttachUserID(String attachUserID) {
		this.attachUserID = attachUserID;
	}
	public String getAttachUserName() {
		return attachUserName;
	}
	public void setAttachUserName(String attachUserName) {
		this.attachUserName = attachUserName;
	}
	public String getAttachUserDeptID() {
		return attachUserDeptID;
	}
	public void setAttachUserDeptID(String attachUserDeptID) {
		this.attachUserDeptID = attachUserDeptID;
	}
	public String getAttachUserDeptName() {
		return attachUserDeptName;
	}
	public void setAttachUserDeptName(String attachUserDeptName) {
		this.attachUserDeptName = attachUserDeptName;
	}
	public String getAttachUserJobTitle() {
		return attachUserJobTitle;
	}
	public void setAttachUserJobTitle(String attachUserJobTitle) {
		this.attachUserJobTitle = attachUserJobTitle;
	}
	public String getAttachUserName2() {
		return attachUserName2;
	}
	public void setAttachUserName2(String attachUserName2) {
		this.attachUserName2 = attachUserName2;
	}
	public String getAttachUserJobTitle2() {
		return attachUserJobTitle2;
	}
	public void setAttachUserJobTitle2(String attachUserJobTitle2) {
		this.attachUserJobTitle2 = attachUserJobTitle2;
	}
	public String getAttachUserDeptName2() {
		return attachUserDeptName2;
	}
	public void setAttachUserDeptName2(String attachUserDeptName2) {
		this.attachUserDeptName2 = attachUserDeptName2;
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
}
