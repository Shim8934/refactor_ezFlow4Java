package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGRecordVO {
	/** 기록물아이디*/
	private String recordID;
	/** 문서아이디*/
	private String docID;
	/** 생산/접수등록번호*/
	private String registerNo;
	/** 기록물생성일*/
	private String createDate;
	/** 문서종류*/
	private String docType;
	/** 기록물종류*/
	private String registerType;
	/** */
	private String docState;
	/** */
	private String cabinetID;
	/** */
	private String seperateAttachNo;
	/** 기록물경로*/
	private String href;
	/** */
	private String containerID;
	/** 양식아이디*/
	private String formID;
	/** 작성자아이디*/
	private String writerID;
	/** */
	private String confirmFlag;
	/** */
	private String cabinetClassNo;
	/** */
	private String cabDeptCode;
	/** */
	private String ownerDeptID;
	/** 생산/접수등록일자*/
	private String registerDate;
	/** 결재권자*/
	private String aprMemberTitle;
	/** 결재권자*/
	private String 	aprMemberTitle2;
	/** 기안자이름*/
	private String drafterName;
	/** 기안자이름(다국어)*/
	private String drafterName2;
	/** 첨부여부*/
	private String attachFlag;
	/** */
	private String ownerTask;
	/** 반려여부*/
	private String rejectFlag;
	/** 보안여부*/
	private String securityApproval;
	/** */
	private String dispRegisterNo;
	/** */
	private String recTitle;
	/** */
	private String dispClassNo;
	/** */
	private String receiptName;
	/** */
	private String reSendFlag;
	/** 순서*/
	private String rowNum_;
	/** 처리과부서코드*/
	private String recDeptCode;
	/** 처리과이름*/
	private String recDeptName;
	/**특수목록여부*/
	private String specialCatalogFlag;
	/**생산/접수등록번호*/
	private String recRegSn;
	/**시행일자*/
	private String executeDate;
	/**수신자이름*/
	private String receiptMemberName;
	/**수신자이름2*/
	private String receiptMemberName2;
	/**문서과 배부번호*/
	private String deliveryNo;
	/**생산기관 등록번호*/
	private String produceDeptregNo;
	/**변경구분*/
	private String modifyFlag;
	/**전자기록물여부*/
	private String electronicRecFlag;
	/**신/구 기록물 구분*/
	private String oldRecordFlag;
	/**구기록물철생산기관*/
	private String createOrganName;
	/**구기록물문서번호*/
	private String recordNo;
	/**구기록물보존기간*/
	private String recKp;
	/**요약*/
	private String summary;
	/**기록물형태*/
	private String recordType;
	/**쪽수*/
	private String numOfPage;
	
	/**기록물 권한*/
	/**사용자id*/
	private String userId;
	/**사용자권한*/
	private String userRight;
	/**사용자 이름*/
	private String userName;
	/**사용자 이름(다국어)*/
	private String userName2;
	/**사용자 직위*/
	private String userTitle;
	/**사용자 직위(다국어)*/
	private String userTitle2;
	/**부서 코드*/
	private String deptCode;
	/**부서 이름*/
	private String deptName;
	/**부서 이름(다국어)*/
	private String deptName2;
	
	/**기록물철 변경이력*/
	/**제목*/
	private String title;
	/**기안자*/
	private String drafter;
	/**기안자(다국어)*/
	private String drafter2
	/**변경 일자*/;
	private String modifyDate;
	/**변경 사유*/
	private String modifyReason;
	/**변경자이름*/
	private String modifierName;
	/**변경자이름(다국어)*/
	private String modifierName2;
	/**변경자id*/
	private String modifierId;
	/**기록물철버전*/
	private String version;
	
	private String specialRecordCode;
	private String publiCityCode;
	private String limitRange;
	private String manualRegFlag;
	private String user_Id;
	
	public String getUser_Id() {
		return user_Id;
	}
	public void setUser_Id(String user_Id) {
		this.user_Id = user_Id;
	}
	public String getLimitRange() {
		return limitRange;
	}
	public String getDrafterName2() {
		return drafterName2;
	}
	public void setDrafterName2(String drafterName2) {
		this.drafterName2 = drafterName2;
	}
	public void setLimitRange(String limitRange) {
		this.limitRange = limitRange;
	}
	public String getManualRegFlag() {
		return manualRegFlag;
	}
	public void setManualRegFlag(String manualRegFlag) {
		this.manualRegFlag = manualRegFlag;
	}
	public String getPubliCityCode() {
		return publiCityCode;
	}
	public void setPubliCityCode(String publiCityCode) {
		this.publiCityCode = publiCityCode;
	}
	public String getSpecialRecordCode() {
		return specialRecordCode;
	}
	public void setSpecialRecordCode(String specialRecordCode) {
		this.specialRecordCode = specialRecordCode;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserRight() {
		return userRight;
	}
	public void setUserRight(String userRight) {
		this.userRight = userRight;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserName2() {
		return userName2;
	}
	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}
	public String getUserTitle() {
		return userTitle;
	}
	public void setUserTitle(String userTitle) {
		this.userTitle = userTitle;
	}
	public String getUserTitle2() {
		return userTitle2;
	}
	public void setUserTitle2(String userTitle2) {
		this.userTitle2 = userTitle2;
	}
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getDeptName2() {
		return deptName2;
	}
	public void setDeptName2(String deptName2) {
		this.deptName2 = deptName2;
	}
	public String getRecordID() {
		return recordID;
	}
	public void setRecordID(String recordID) {
		this.recordID = recordID;
	}
	public String getDocID() {
		return docID;
	}
	public void setDocID(String docID) {
		this.docID = docID;
	}
	public String getRegisterNo() {
		return registerNo;
	}
	public void setRegisterNo(String registerNo) {
		this.registerNo = registerNo;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getDocType() {
		return docType;
	}
	public void setDocType(String docType) {
		this.docType = docType;
	}
	public String getRegisterType() {
		return registerType;
	}
	public void setRegisterType(String registerType) {
		this.registerType = registerType;
	}
	public String getDocState() {
		return docState;
	}
	public void setDocState(String docState) {
		this.docState = docState;
	}
	public String getCabinetID() {
		return cabinetID;
	}
	public void setCabinetID(String cabinetID) {
		this.cabinetID = cabinetID;
	}
	public String getSeperateAttachNo() {
		return seperateAttachNo;
	}
	public void setSeperateAttachNo(String seperateAttachNo) {
		this.seperateAttachNo = seperateAttachNo;
	}
	public String getHref() {
		return href;
	}
	public void setHref(String href) {
		this.href = href;
	}
	public String getContainerID() {
		return containerID;
	}
	public void setContainerID(String containerID) {
		this.containerID = containerID;
	}
	public String getFormID() {
		return formID;
	}
	public void setFormID(String formID) {
		this.formID = formID;
	}
	public String getWriterID() {
		return writerID;
	}
	public void setWriterID(String writerID) {
		this.writerID = writerID;
	}
	public String getConfirmFlag() {
		return confirmFlag;
	}
	public void setConfirmFlag(String confirmFlag) {
		this.confirmFlag = confirmFlag;
	}
	public String getCabinetClassNo() {
		return cabinetClassNo;
	}
	public void setCabinetClassNo(String cabinetClassNo) {
		this.cabinetClassNo = cabinetClassNo;
	}
	public String getCabDeptCode() {
		return cabDeptCode;
	}
	public void setCabDeptCode(String cabDeptCode) {
		this.cabDeptCode = cabDeptCode;
	}
	public String getOwnerDeptID() {
		return ownerDeptID;
	}
	public void setOwnerDeptID(String ownerDeptID) {
		this.ownerDeptID = ownerDeptID;
	}
	public String getRegisterDate() {
		return registerDate;
	}
	public void setRegisterDate(String registerDate) {
		this.registerDate = registerDate;
	}
	public String getAprMemberTitle() {
		return aprMemberTitle;
	}
	public void setAprMemberTitle(String aprMemberTitle) {
		this.aprMemberTitle = aprMemberTitle;
	}
	public String getDrafterName() {
		return drafterName;
	}
	public void setDrafterName(String drafterName) {
		this.drafterName = drafterName;
	}
	public String getAttachFlag() {
		return attachFlag;
	}
	public void setAttachFlag(String attachFlag) {
		this.attachFlag = attachFlag;
	}
	public String getOwnerTask() {
		return ownerTask;
	}
	public void setOwnerTask(String ownerTask) {
		this.ownerTask = ownerTask;
	}
	public String getRejectFlag() {
		return rejectFlag;
	}
	public void setRejectFlag(String rejectFlag) {
		this.rejectFlag = rejectFlag;
	}
	public String getSecurityApproval() {
		return securityApproval;
	}
	public void setSecurityApproval(String securityApproval) {
		this.securityApproval = securityApproval;
	}
	public String getDispRegisterNo() {
		return dispRegisterNo;
	}
	public void setDispRegisterNo(String dispRegisterNo) {
		this.dispRegisterNo = dispRegisterNo;
	}
	public String getRecTitle() {
		return recTitle;
	}
	public void setRecTitle(String recTitle) {
		this.recTitle = recTitle;
	}
	public String getDispClassNo() {
		return dispClassNo;
	}
	public void setDispClassNo(String dispClassNo) {
		this.dispClassNo = dispClassNo;
	}
	public String getReceiptName() {
		return receiptName;
	}
	public void setReceiptName(String receiptName) {
		this.receiptName = receiptName;
	}
	public String getReSendFlag() {
		return reSendFlag;
	}
	public void setReSendFlag(String reSendFlag) {
		this.reSendFlag = reSendFlag;
	}
	public String getRowNum_() {
		return rowNum_;
	}
	public void setRowNum_(String rowNum_) {
		this.rowNum_ = rowNum_;
	}
	public String getRecDeptCode() {
		return recDeptCode;
	}
	public void setRecDeptCode(String recDeptCode) {
		this.recDeptCode = recDeptCode;
	}
	public String getRecDeptName() {
		return recDeptName;
	}
	public void setRecDeptName(String recDeptName) {
		this.recDeptName = recDeptName;
	}
	public String getSpecialCatalogFlag() {
		return specialCatalogFlag;
	}
	public void setSpecialCatalogFlag(String specialCatalogFlag) {
		this.specialCatalogFlag = specialCatalogFlag;
	}
	public String getRecRegSn() {
		return recRegSn;
	}
	public void setRecRegSn(String recRegSn) {
		this.recRegSn = recRegSn;
	}
	public String getExecuteDate() {
		return executeDate;
	}
	public void setExecuteDate(String executeDate) {
		this.executeDate = executeDate;
	}
	public String getReceiptMemberName() {
		return receiptMemberName;
	}
	public void setReceiptMemberName(String receiptMemberName) {
		this.receiptMemberName = receiptMemberName;
	}
	public String getDeliveryNo() {
		return deliveryNo;
	}
	public void setDeliveryNo(String deliveryNo) {
		this.deliveryNo = deliveryNo;
	}
	public String getProduceDeptregNo() {
		return produceDeptregNo;
	}
	public void setProduceDeptregNo(String produceDeptregNo) {
		this.produceDeptregNo = produceDeptregNo;
	}
	public String getModifyFlag() {
		return modifyFlag;
	}
	public void setModifyFlag(String modifyFlag) {
		this.modifyFlag = modifyFlag;
	}
	public String getElectronicRecFlag() {
		return electronicRecFlag;
	}
	public void setElectronicRecFlag(String electronicRecFlag) {
		this.electronicRecFlag = electronicRecFlag;
	}
	public String getOldRecordFlag() {
		return oldRecordFlag;
	}
	public void setOldRecordFlag(String oldRecordFlag) {
		this.oldRecordFlag = oldRecordFlag;
	}
	public String getCreateOrganName() {
		return createOrganName;
	}
	public void setCreateOrganName(String createOrganName) {
		this.createOrganName = createOrganName;
	}
	public String getRecordNo() {
		return recordNo;
	}
	public void setRecordNo(String recordNo) {
		this.recordNo = recordNo;
	}
	public String getRecKp() {
		return recKp;
	}
	public void setRecKp(String recKp) {
		this.recKp = recKp;
	}
	public String getSummary() {
		return summary;
	}
	public void setSummary(String summary) {
		this.summary = summary;
	}
	public String getRecordType() {
		return recordType;
	}
	public void setRecordType(String recordType) {
		this.recordType = recordType;
	}
	public String getNumOfPage() {
		return numOfPage;
	}
	public void setNumOfPage(String numOfPage) {
		this.numOfPage = numOfPage;
	}
	public String getAprMemberTitle2() {
		return aprMemberTitle2;
	}
	public void setAprMemberTitle2(String aprMemberTitle2) {
		this.aprMemberTitle2 = aprMemberTitle2;
	}
	public String getReceiptMemberName2() {
		return receiptMemberName2;
	}
	public void setReceiptMemberName2(String receiptMemberName2) {
		this.receiptMemberName2 = receiptMemberName2;
	}
	public String getDrafter() {
		return drafter;
	}
	public void setDrafter(String drafter) {
		this.drafter = drafter;
	}
	public String getDrafter2() {
		return drafter2;
	}
	public void setDrafter2(String drafter2) {
		this.drafter2 = drafter2;
	}
	public String getModifyDate() {
		return modifyDate;
	}
	public void setModifyDate(String modifyDate) {
		this.modifyDate = modifyDate;
	}
	public String getModifyReason() {
		return modifyReason;
	}
	public void setModifyReason(String modifyReason) {
		this.modifyReason = modifyReason;
	}
	public String getModifierName() {
		return modifierName;
	}
	public void setModifierName(String modifierName) {
		this.modifierName = modifierName;
	}
	public String getModifierName2() {
		return modifierName2;
	}
	public void setModifierName2(String modifierName2) {
		this.modifierName2 = modifierName2;
	}
	public String getModifierId() {
		return modifierId;
	}
	public void setModifierId(String modifierId) {
		this.modifierId = modifierId;
	}
	
}
