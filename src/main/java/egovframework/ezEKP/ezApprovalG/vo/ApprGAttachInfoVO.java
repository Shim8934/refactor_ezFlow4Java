package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGAttachInfoVO {

	/** 첨부타입*/
	private String attachType;
	/** 첨부타입코드*/
	private String attachTypeCode;
	/** 첨부남바*/
	private String attachSN;
	/** 첨부명*/
	private String attachName;
	/** 첨부href*/
	private String attachHref;
	/** 첨부 유저 이름*/
	private String attachUserName;
	/** 첨부유저직업명*/
	private String attachUserJobTitle;
	/** 첨부유저직위명*/
	private String attachUserDeptName;
	/** 문서아이디*/
	private String docID;
	/** 첨부리얼이름*/
	private String realAttachName;
	public String getAttachType() {
		return attachType;
	}
	public void setAttachType(String attachType) {
		this.attachType = attachType;
	}
	public String getAttachTypeCode() {
		return attachTypeCode;
	}
	public void setAttachTypeCode(String attachTypeCode) {
		this.attachTypeCode = attachTypeCode;
	}
	public String getAttachSN() {
		return attachSN;
	}
	public void setAttachSN(String attachSN) {
		this.attachSN = attachSN;
	}
	public String getAttachName() {
		return attachName;
	}
	public void setAttachName(String attachName) {
		this.attachName = attachName;
	}
	public String getAttachHref() {
		return attachHref;
	}
	public void setAttachHref(String attachHref) {
		this.attachHref = attachHref;
	}
	public String getAttachUserName() {
		return attachUserName;
	}
	public void setAttachUserName(String attachUserName) {
		this.attachUserName = attachUserName;
	}
	public String getAttachUserJobTitle() {
		return attachUserJobTitle;
	}
	public void setAttachUserJobTitle(String attachUserJobTitle) {
		this.attachUserJobTitle = attachUserJobTitle;
	}
	public String getAttachUserDeptName() {
		return attachUserDeptName;
	}
	public void setAttachUserDeptName(String attachUserDeptName) {
		this.attachUserDeptName = attachUserDeptName;
	}
	public String getDocID() {
		return docID;
	}
	public void setDocID(String docID) {
		this.docID = docID;
	}
	public String getRealAttachName() {
		return realAttachName;
	}
	public void setRealAttachName(String realAttachName) {
		this.realAttachName = realAttachName;
	}
}
