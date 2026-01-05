package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGReceiveDocVO {
	/** 원문서 아이디*/
	private String orgDocID;
	/** 경로*/
	private String href;
	/** 의견여부*/
	private String hasOpinionYN;
	/** 첨부여부*/
	private String hasAttachYN;
	/** 공개여부*/
	private String isPublic;
	/** 문서타입*/
	private String docType;
	/** 문서제목*/
	private String docTitle;
	/** 기안자부서아이디*/
	private String writerDeptID;
	/** 문서상태*/
	private String docState;
	/** 결재상태*/
	private String aprState;
	/** 보낸부서아이디*/
	private String sentDeptID;
	/** 보낸부서이름*/
	private String sentDeptName;
	/** 보낸부서이름(다국어)*/
	private String sentDeptName2;
	/** 받은부서아이디*/
	private String receivedDeptID;
	/** 받은부서이름*/
	private String receivedDeptName;
	/** 받은부서이름(다국어)*/
	private String receivedDeptName2;
	/** 진행일자*/
	private String processDate;
	/** 수신순번*/
	private String receiveSN;
	/** 문서아이디*/
	private String docID;
	/** 진행자아이디*/
	private String processorID;
	/** 양식이름*/
	private String formName;
	/** 양식이름(다국어)*/
	private String formName2;
	/** 긴급결재여부*/
	private String urgentApproval;
	/** 예전경로*/
	private String orgHref;
	/** */
	private String sn;
	/** */
	private String aprCount;
	
	private String companyID;
	/** 기안자*/
	private String writerName;
	/** 기안자(다국어)*/
	private String writerName2;
	/** 양식이름*/
	private String formID;
	/* 분리첨부 */
	private String seperateAttachXml;
	/* 기안자ID */
	private String writerId;
	/* 진행자 이름 */
	private String processorName;
	/* 진행자 이름 2*/
	private String processorName2;

	/** 작성자 부서명 */
	private String writerDeptName;

	/** 작성자 부서명 2 */
	private String writerDeptName2;

    private String WRITERJOBTITLE;
	
	private String WRITERJOBTITLE2;
    
	public String getWriterDeptName() {
		return writerDeptName;
	}
	public void setWriterDeptName(String writerDeptName) {
		this.writerDeptName = writerDeptName;
	}
	public String getWriterDeptName2() {
		return writerDeptName2;
	}
	public void setWriterDeptName2(String writerDeptName2) {
		this.writerDeptName2 = writerDeptName2;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public String getOrgDocID() {
		return orgDocID;
	}
	public void setOrgDocID(String orgDocID) {
		this.orgDocID = orgDocID;
	}
	public String getHref() {
		return href;
	}
	public void setHref(String href) {
		this.href = href;
	}
	public String getHasOpinionYN() {
		return hasOpinionYN;
	}
	public void setHasOpinionYN(String hasOpinionYN) {
		this.hasOpinionYN = hasOpinionYN;
	}
	public String getHasAttachYN() {
		return hasAttachYN;
	}
	public void setHasAttachYN(String hasAttachYN) {
		this.hasAttachYN = hasAttachYN;
	}
	public String getIsPublic() {
		return isPublic;
	}
	public void setIsPublic(String isPublic) {
		this.isPublic = isPublic;
	}
	public String getDocType() {
		return docType;
	}
	public void setDocType(String docType) {
		this.docType = docType;
	}
	public String getDocTitle() {
		return docTitle;
	}
	public void setDocTitle(String docTitle) {
		this.docTitle = docTitle;
	}
	public String getWriterDeptID() {
		return writerDeptID;
	}
	public void setWriterDeptID(String writerDeptID) {
		this.writerDeptID = writerDeptID;
	}
	public String getDocState() {
		return docState;
	}
	public void setDocState(String docState) {
		this.docState = docState;
	}
	public String getAprState() {
		return aprState;
	}
	public void setAprState(String aprState) {
		this.aprState = aprState;
	}
	public String getSentDeptName() {
		return sentDeptName;
	}
	public void setSentDeptName(String sentDeptName) {
		this.sentDeptName = sentDeptName;
	}
	public String getSentDeptName2() {
		return sentDeptName2;
	}
	public void setSentDeptName2(String sentDeptName2) {
		this.sentDeptName2 = sentDeptName2;
	}
	public String getReceivedDeptID() {
		return receivedDeptID;
	}
	public void setReceivedDeptID(String receivedDeptID) {
		this.receivedDeptID = receivedDeptID;
	}
	public String getReceivedDeptName() {
		return receivedDeptName;
	}
	public void setReceivedDeptName(String receivedDeptName) {
		this.receivedDeptName = receivedDeptName;
	}
	public String getReceivedDeptName2() {
		return receivedDeptName2;
	}
	public void setReceivedDeptName2(String receivedDeptName2) {
		this.receivedDeptName2 = receivedDeptName2;
	}
	public String getProcessDate() {
		return processDate;
	}
	public void setProcessDate(String processDate) {
		this.processDate = processDate;
	}
	public String getReceiveSN() {
		return receiveSN;
	}
	public void setReceiveSN(String receiveSN) {
		this.receiveSN = receiveSN;
	}
	public String getDocID() {
		return docID;
	}
	public void setDocID(String docID) {
		this.docID = docID;
	}
	public String getProcessorID() {
		return processorID;
	}
	public void setProcessorID(String processorID) {
		this.processorID = processorID;
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
	public String getOrgHref() {
		return orgHref;
	}
	public void setOrgHref(String orgHref) {
		this.orgHref = orgHref;
	}
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	public String getAprCount() {
		return aprCount;
	}
	public void setAprCount(String aprCount) {
		this.aprCount = aprCount;
	}
	public String getSentDeptID() {
		return sentDeptID;
	}
	public void setSentDeptID(String sentDeptID) {
		this.sentDeptID = sentDeptID;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getWriterName2() {
		return writerName2;
	}
	public void setWriterName2(String writerName2) {
		this.writerName2 = writerName2;
	}
	public String getFormID() {
		return formID;
	}
	public void setFormID(String formID) {
		this.formID = formID;
	}
	public String getSeperateAttachXml() {
		return seperateAttachXml;
	}
	public void setSeperateAttachXml(String seperateAttachXml) {
		this.seperateAttachXml = seperateAttachXml;
	}
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}
	public String getProcessorName() { 
		return processorName; 
	}
	public void setProcessorName(String processorName) { 
		this.processorName = processorName; 
	}
	public String getProcessorName2() { 
		return processorName2; 
	}
	public void setProcessorName2(String processorName2) {
		this.processorName2 = processorName2;
	}
    public String getWRITERJOBTITLE() {return WRITERJOBTITLE;}

	public void setWRITERJOBTITLE(String WRITERJOBTITLE) {this.WRITERJOBTITLE = WRITERJOBTITLE;}

	public String getWRITERJOBTITLE2() {return WRITERJOBTITLE2;}

	public void setWRITERJOBTITLE2(String WRITERJOBTITLE2) {this.WRITERJOBTITLE2 = WRITERJOBTITLE2;}
}
