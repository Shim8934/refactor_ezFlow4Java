package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGGroupDocInfoVO {
	
	/** DOCID */
	private String docID;
	/** 탭번호 */
	private String tabSN;
	/** DOCHREF */
	private String docHref;
	/** HASOPINIONYN */
	private String hasOpinionYN;
	/** ORGDOCID */
	private String orgDocID;
	/** 그룹 DOCID */
	private String groupDocID;
	/** DOCTYPE */
	private String docType;
	/** 회사ID */
	private String companyID;

	/* 그룹 DOCID */
	private String groupDocSN;
	/* 대외문서여부 */
	private String extYN;
	
	public String getDocID() {
		return docID;
	}
	public void setDocID(String docID) {
		this.docID = docID;
	}
	public String getTabSN() {
		return tabSN;
	}
	public void setTabSN(String tabSN) {
		this.tabSN = tabSN;
	}
	public String getGroupDocID() {
		return groupDocID;
	}
	public void setGroupDocID(String groupDocID) {
		this.groupDocID = groupDocID;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public String getDocHref() {
		return docHref;
	}
	public void setDocHref(String docHref) {
		this.docHref = docHref;
	}
	public String getHasOpinionYN() {
		return hasOpinionYN;
	}
	public void setHasOpinionYN(String hasOpinionYN) {
		this.hasOpinionYN = hasOpinionYN;
	}
	public String getOrgDocID() {
		return orgDocID;
	}
	public void setOrgDocID(String orgDocID) {
		this.orgDocID = orgDocID;
	}
	public String getDocType() {
		return docType;
	}
	public void setDocType(String docType) {
		this.docType = docType;
	}
	public String getgroupDocSN() {
		return groupDocSN;
	}
	public void setgroupDocSN(String groupDocSN) {
		this.groupDocSN = groupDocSN;
	}
    public String getExtYN() {return extYN;}
    public void setExtYN(String extYN) {this.extYN = extYN;}
}
