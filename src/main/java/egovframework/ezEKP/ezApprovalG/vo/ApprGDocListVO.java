package egovframework.ezEKP.ezApprovalG.vo;

import java.sql.Date;

public class ApprGDocListVO {
	/** 문서 아이디*/
	private String docID;
	/** 양식 아이디*/
	private String formID;
	/** 원문서 아이디*/
	private String orgDocID;
	/** 문서타입*/
	private String docType;
	/** 문서상태*/
	private String docState;
	/** 결재상태*/
	private String functionType;
	/** 경로*/
	private String href;
	/** 문서제목*/
	private String docTitle;
	/** 문서번호*/
	private String docNo;
	/** 첨부여부*/
	private String hasAttachYn;
	/** 의견여부*/
	private String hasOpinionYn;
	/** 기안일자*/
	private Date startDate;
	/** 완료일자*/
	private Date endDate;
	/** 기안자아이디*/
	private String writerID;
	/** 기안자이름*/
	private String writerName;
	/** 기안자직위*/
	private String writerJobTitle;
	/** 기안자부서아이디*/
	private String writerDeptID;
	/** 기안자부서이름*/
	private String writerDeptName;
	/** 공개여부*/
	private String isPublic;
	/** 기안자이름(다국어)*/
	private String writerName2;
	/** 기안자직위(다국어)*/
	private String writerJobTitle2;
	/** 기안자부서이름(다국어)*/
	private String writerDeptName2;
	/** 결재순번*/
	private String aprMemberSN;
	/** 결재방법*/
	private String aprType;
	/** 결재상태*/
	private String aprState;
	/** 결재자아이디*/
	private String aprMemberID;
	/** 결재자이름*/
	private String aprMemberName;
	/** 결재자이름(다국어)*/
	private String aprMemberName2;
	/** 결재자직위*/
	private String aprMemberJobTitle;
	/** 결재자직위(다국어)*/
	private String aprMemberJobTitle2;
	/** 결재자부서아이디*/
	private String aprMemberDeptID;
	/** 결재자부서이름*/
	private String aprMemberDeptName;
	/** 결재자부서이름(다국어)*/
	private String aprMemberDeptName2;
	/** 양식이름*/
	private String formName;
	/** 양식이름(다국어)*/
	private String formName2;
	/** 긴급결재여부*/
	private String urgentApproval;
	/** 수신일자*/
	private String receivedDate;
	
	public String getDocID() {
		return docID;
	}
	public void setDocID(String docID) {
		this.docID = docID;
	}
	public String getFormID() {
		return formID;
	}
	public void setFormID(String formID) {
		this.formID = formID;
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
	public String getDocState() {
		return docState;
	}
	public void setDocState(String docState) {
		this.docState = docState;
	}
	public String getFunctionType() {
		return functionType;
	}
	public void setFunctionType(String functionType) {
		this.functionType = functionType;
	}
	public String getHref() {
		return href;
	}
	public void setHref(String href) {
		this.href = href;
	}
	public String getDocTitle() {
		return docTitle;
	}
	public void setDocTitle(String docTitle) {
		this.docTitle = docTitle;
	}
	public String getDocNo() {
		return docNo;
	}
	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}
	public String getHasAttachYn() {
		return hasAttachYn;
	}
	public void setHasAttachYn(String hasAttachYn) {
		this.hasAttachYn = hasAttachYn;
	}
	public String getHasOpinionYn() {
		return hasOpinionYn;
	}
	public void setHasOpinionYn(String hasOpinionYn) {
		this.hasOpinionYn = hasOpinionYn;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public String getWriterID() {
		return writerID;
	}
	public void setWriterID(String writerID) {
		this.writerID = writerID;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getWriterJobTitle() {
		return writerJobTitle;
	}
	public void setWriterJobTitle(String writerJobTitle) {
		this.writerJobTitle = writerJobTitle;
	}
	public String getWriterDeptID() {
		return writerDeptID;
	}
	public void setWriterDeptID(String writerDeptID) {
		this.writerDeptID = writerDeptID;
	}
	public String getWriterDeptName() {
		return writerDeptName;
	}
	public void setWriterDeptName(String writerDeptName) {
		this.writerDeptName = writerDeptName;
	}
	public String getIsPublic() {
		return isPublic;
	}
	public void setIsPublic(String isPublic) {
		this.isPublic = isPublic;
	}
	public String getWriterName2() {
		return writerName2;
	}
	public void setWriterName2(String writerName2) {
		this.writerName2 = writerName2;
	}
	public String getWriterJobTitle2() {
		return writerJobTitle2;
	}
	public void setWriterJobTitle2(String writerJobTitle2) {
		this.writerJobTitle2 = writerJobTitle2;
	}
	public String getWriterDeptName2() {
		return writerDeptName2;
	}
	public void setWriterDeptName2(String writerDeptName2) {
		this.writerDeptName2 = writerDeptName2;
	}
	public String getAprMemberSN() {
		return aprMemberSN;
	}
	public void setAprMemberSN(String aprMemberSN) {
		this.aprMemberSN = aprMemberSN;
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
	public String getAprMemberID() {
		return aprMemberID;
	}
	public void setAprMemberID(String aprMemberID) {
		this.aprMemberID = aprMemberID;
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
	public String getAprMemberJobTitle() {
		return aprMemberJobTitle;
	}
	public void setAprMemberJobTitle(String aprMemberJobTitle) {
		this.aprMemberJobTitle = aprMemberJobTitle;
	}
	public String getAprMemberJobTitle2() {
		return aprMemberJobTitle2;
	}
	public void setAprMemberJobTitle2(String aprMemberJobTitle2) {
		this.aprMemberJobTitle2 = aprMemberJobTitle2;
	}
	public String getAprMemberDeptID() {
		return aprMemberDeptID;
	}
	public void setAprMemberDeptID(String aprMemberDeptID) {
		this.aprMemberDeptID = aprMemberDeptID;
	}
	public String getAprMemberDeptName() {
		return aprMemberDeptName;
	}
	public void setAprMemberDeptName(String aprMemberDeptName) {
		this.aprMemberDeptName = aprMemberDeptName;
	}
	public String getAprMemberDeptName2() {
		return aprMemberDeptName2;
	}
	public void setAprMemberDeptName2(String aprMemberDeptName2) {
		this.aprMemberDeptName2 = aprMemberDeptName2;
	}
	public String getFormName() {
		return formName;
	}
	public void setFormName(String formName) {
		this.formName = formName;
	}
	public String getFormName2() {
		return formName2;
	}
	public void setFormName2(String formName2) {
		this.formName2 = formName2;
	}
	public String getUrgentApproval() {
		return urgentApproval;
	}
	public void setUrgentApproval(String urgentApproval) {
		this.urgentApproval = urgentApproval;
	}
	public String getReceivedDate() {
		return receivedDate;
	}
	public void setReceivedDate(String receivedDate) {
		this.receivedDate = receivedDate;
	}
}
