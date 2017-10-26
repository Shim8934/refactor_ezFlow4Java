package egovframework.ezMobile.ezApprovalG.vo;

public class MApprovalGDocInfoVO {
	/** 문서번호*/
	private String docID;
	/** 문서 제목*/
	private String docTitle;
	/** 기안날짜*/
	private String startDate;
	/** 기안자*/
	private String writerName;
	/** 기안자부서명*/
	private String writerDeptName;
	/** 기안자직위*/
	private String writerJobTitle;
	/** 원본 문서번호*/
	private String orgDocID;
	/** 첨부여부*/
	private String hasAttachYN;
	/** 의견여부*/
	private String hasOpinionYN;
	/** 결재자아이디*/
	private String aprMemberID;
	/** 결재자 이름*/
	private String aprMemberName;
	/** 결재자 이름(다국어)*/
	private String aprMemberName2;
	/** 결재자 부서아이디*/
	private String aprMemberDeptID;
	/** 결재자 순번*/
	private String aprMemberSN;
	/** 문서경로*/
	private String href;
	/** 양식 아이디*/
	private String formID;
	/** 문서상태*/
	private String docState;
	/** 결재종류*/
	private String aprType;
	/** 결재상태*/
	private String aprState;
	/** 문서상태*/
	private String functionType;
	/** 긴급결재여부 Y or N*/
	private String urgentApproval;
	
	public String getDocID() {
		return docID;
	}
	public void setDocID(String docID) {
		this.docID = docID;
	}
	public String getDocTitle() {
		return docTitle;
	}
	public void setDocTitle(String docTitle) {
		this.docTitle = docTitle;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getWriterDeptName() {
		return writerDeptName;
	}
	public void setWriterDeptName(String writerDeptName) {
		this.writerDeptName = writerDeptName;
	}
	public String getWriterJobTitle() {
		return writerJobTitle;
	}
	public void setWriterJobTitle(String writerJobTitle) {
		this.writerJobTitle = writerJobTitle;
	}
	public String getOrgDocID() {
		return orgDocID;
	}
	public void setOrgDocID(String orgDocID) {
		this.orgDocID = orgDocID;
	}
	public String getHasAttachYN() {
		return hasAttachYN;
	}
	public void setHasAttachYN(String hasAttachYN) {
		this.hasAttachYN = hasAttachYN;
	}
	public String getAprMemberID() {
		return aprMemberID;
	}
	public void setAprMemberID(String aprMemberID) {
		this.aprMemberID = aprMemberID;
	}
	public String getHref() {
		return href;
	}
	public void setHref(String href) {
		this.href = href;
	}
	public String getFormID() {
		return formID;
	}
	public void setFormID(String formID) {
		this.formID = formID;
	}
	public String getAprMemberName() {
		return aprMemberName;
	}
	public void setAprMemberName(String aprMemberName) {
		this.aprMemberName = aprMemberName;
	}
	public String getAprMemberName2() {
		return aprMemberName2;
	}
	public void setAprMemberName2(String aprMemberName2) {
		this.aprMemberName2 = aprMemberName2;
	}
	public String getAprMemberDeptID() {
		return aprMemberDeptID;
	}
	public void setAprMemberDeptID(String aprMemberDeptID) {
		this.aprMemberDeptID = aprMemberDeptID;
	}
	public String getDocState() {
		return docState;
	}
	public void setDocState(String docState) {
		this.docState = docState;
	}
	public String getHasOpinionYN() {
		return hasOpinionYN;
	}
	public void setHasOpinionYN(String hasOpinionYN) {
		this.hasOpinionYN = hasOpinionYN;
	}
	public String getAprType() {
		return aprType;
	}
	public void setAprType(String aprType) {
		this.aprType = aprType;
	}
	public String getAprState() {
		return aprState;
	}
	public void setAprState(String aprState) {
		this.aprState = aprState;
	}
	public String getFunctionType() {
		return functionType;
	}
	public void setFunctionType(String functionType) {
		this.functionType = functionType;
	}
	public String getUrgentApproval() {
		return urgentApproval;
	}
	public void setUrgentApproval(String urgentApproval) {
		this.urgentApproval = urgentApproval;
	}
	public String getAprMemberSN() {
		return aprMemberSN;
	}
	public void setAprMemberSN(String aprMemberSN) {
		this.aprMemberSN = aprMemberSN;
	}
	
}
