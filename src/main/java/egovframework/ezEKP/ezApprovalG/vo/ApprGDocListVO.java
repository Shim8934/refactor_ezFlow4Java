package egovframework.ezEKP.ezApprovalG.vo;


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
	private String startDate;
	/** 완료일자*/
	private String endDate;
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
	/** 보안등급*/
	private String securityCode;
	/** 보존연한*/
	private String storagePeriod;
	/** 키워드*/
	private String keyword;
	/** 회사아이디*/
	private String companyID;
	/** 분류코드*/
	private String itemCode;
	/** 분류이름*/
	private String itemName;
	/** 보안결재설정날짜*/
	private String securityApproval;
	/** 임시필드*/
	private String tempAttribute;
	/** 상태*/
	private String status;
	/** 특수기록물코드*/
	private String specialRecordCode;
	/** 공개구분*/
	private String publicityCode;
	/** 공개제한부분표시*/
	private String limitRange;
	/** 쪽수*/
	private String pageNum;
	/** 기록물철아이디*/
	private String cabinetID;
	/** 단위업무코드*/
	private String taskCode;
	/** 단위번호코드*/
	private String docNumCode;
	/** 원문서번호코드*/
	private String orgDocNumCode;
	/** 분리첨부XML*/
	private String seperateAttachXML;
	/** 요약*/
	private String summary;
	/** 분류이름(다국어)*/
	private String itemName2;
	/** */
	private String signCheck;
	/** */
	private String edmsYN;
	/** */
	private String containerID;
	/** */
	private String receiptPointName;
	/** */
	private String receiptPointName2;
	/** */
	private String processYN;
	
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
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
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
	public String getSecurityCode() {
		return securityCode;
	}
	public void setSecurityCode(String securityCode) {
		this.securityCode = securityCode;
	}
	public String getStoragePeriod() {
		return storagePeriod;
	}
	public void setStoragePeriod(String storagePeriod) {
		this.storagePeriod = storagePeriod;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public String getItemCode() {
		return itemCode;
	}
	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	public String getSecurityApproval() {
		return securityApproval;
	}
	public void setSecurityApproval(String securityApproval) {
		this.securityApproval = securityApproval;
	}
	public String getTempAttribute() {
		return tempAttribute;
	}
	public void setTempAttribute(String tempAttribute) {
		this.tempAttribute = tempAttribute;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getSpecialRecordCode() {
		return specialRecordCode;
	}
	public void setSpecialRecordCode(String specialRecordCode) {
		this.specialRecordCode = specialRecordCode;
	}
	public String getPublicityCode() {
		return publicityCode;
	}
	public void setPublicityCode(String publicityCode) {
		this.publicityCode = publicityCode;
	}
	public String getLimitRange() {
		return limitRange;
	}
	public void setLimitRange(String limitRange) {
		this.limitRange = limitRange;
	}
	public String getPageNum() {
		return pageNum;
	}
	public void setPageNum(String pageNum) {
		this.pageNum = pageNum;
	}
	public String getCabinetID() {
		return cabinetID;
	}
	public void setCabinetID(String cabinetID) {
		this.cabinetID = cabinetID;
	}
	public String getTaskCode() {
		return taskCode;
	}
	public void setTaskCode(String taskCode) {
		this.taskCode = taskCode;
	}
	public String getDocNumCode() {
		return docNumCode;
	}
	public void setDocNumCode(String docNumCode) {
		this.docNumCode = docNumCode;
	}
	public String getOrgDocNumCode() {
		return orgDocNumCode;
	}
	public void setOrgDocNumCode(String orgDocNumCode) {
		this.orgDocNumCode = orgDocNumCode;
	}
	public String getSeperateAttachXML() {
		return seperateAttachXML;
	}
	public void setSeperateAttachXML(String seperateAttachXML) {
		this.seperateAttachXML = seperateAttachXML;
	}
	public String getSummary() {
		return summary;
	}
	public void setSummary(String summary) {
		this.summary = summary;
	}
	public String getItemName2() {
		return itemName2;
	}
	public void setItemName2(String itemName2) {
		this.itemName2 = itemName2;
	}
	public String getSignCheck() {
		return signCheck;
	}
	public void setSignCheck(String signCheck) {
		this.signCheck = signCheck;
	}
	public String getEdmsYN() {
		return edmsYN;
	}
	public void setEdmsYN(String edmsYN) {
		this.edmsYN = edmsYN;
	}
	public String getContainerID() {
		return containerID;
	}
	public void setContainerID(String containerID) {
		this.containerID = containerID;
	}
	public String getReceiptPointName() {
		return receiptPointName;
	}
	public void setReceiptPointName(String receiptPointName) {
		this.receiptPointName = receiptPointName;
	}
	public String getReceiptPointName2() {
		return receiptPointName2;
	}
	public void setReceiptPointName2(String receiptPointName2) {
		this.receiptPointName2 = receiptPointName2;
	}
	public String getProcessYN() {
		return processYN;
	}
	public void setProcessYN(String processYN) {
		this.processYN = processYN;
	}
	
}
