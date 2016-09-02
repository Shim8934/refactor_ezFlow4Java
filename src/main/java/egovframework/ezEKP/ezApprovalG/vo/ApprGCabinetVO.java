package egovframework.ezEKP.ezApprovalG.vo;

/**
 * @author YOON
 *
 */
public class ApprGCabinetVO{
	/** 기록물철ID*/
	private String cabinetID; 
	/** 등록일련번호*/
	private String regSerialNo; 
	/** 생산년도*/
	private String productionYear;
	/** 권호수*/
	private String volumeNo; 
	/** 수정여부*/
	private String modifyFlag; 
	/** 인수인계구분*/
	private String cabinetTransferFlag; 
	/** 편철학정여부*/
	private String confirmFlag;
	/** 단위업무코드*/
	private String taskCode; 
	/** 단위업무이름*/
	private String taskName; 
	/** 단위업무이름(다국어)*/
	private String taskName2; 
	/** 처리과부서코드*/
	private String processDeptCode;
	/** 처리과이름*/
	private String processDeptName;
	/** 처리과이름(다국어)*/
	private String processDeptName2; 
	/** 기록물철분류번호*/
	private String cabinetClassNo; 
	/** 기록물형태코드*/
	private String recTypeCode;
	/** 생성일*/
	private String classCreateDate; 
	/** 업무담당자ID*/
	private String ownerID; 
	/** 특수목록여부*/
	private String specialCatalogFlag;
	/** 종료기록물철여부*/
	private String terminateFlag; 
	/** 기록물철소유부서ID*/
	private String ownerDeptID; 
	/** 기록물철소관단위업무코드*/
	private String ownerTask; 
	/** 이관연기신청여부*/
	private String transDelayFlag;
	/** 기록물철제목*/
	private String title; 
	/** 기록물철제목(다국어)*/
	private String title2;
	/** */
	private String cName;
	/** */
	private String mcName;
	/** */
	private String scName;
	/** */
	private String createDate;
	/** */
	private String subCategoryCode;
	/** */
	private String keepingPeriod;
	/** */
	private String tempFlag;
	/** */
	private String diplayRecFlag;
	/** */
	private String sc1;
	/** */
	private String sc2;
	/** */
	private String sc3;
	/** */
	private String keepingMethod;
	/** */
	private String keepingPlace;
	private String limitRange;
	private String specialRecordCode;
	private String publicityCode;
	private String catalogTransferFlag;
	private String catalogTransferYear;
	private String docTransferFlag;
	private String docTransferYear;
	private String cabDeptCode;
	private String cabTitle;
	/** 순서*/
	private String rowNum_;
	private String dispClassNo;
	private String endYear;
	private String displayRecFlag;
	private String delayFlag;
	private String delayEndYFlag;
	private String transferFlag;
	private String version;
	private String modifyReason;
	private String modifierName;
	private String modifyDate;
	private String modifierName2;
	
	private String recordID;
	private String serialNO;
	
	public String getSerialNO() {
		return serialNO;
	}
	public void setSerialNO(String serialNO) {
		this.serialNO = serialNO;
	}
	public String getRecordID() {
		return recordID;
	}
	public void setRecordID(String recordID) {
		this.recordID = recordID;
	}
	public String getModifierName2() {
		return modifierName2;
	}
	public void setModifierName2(String modifierName2) {
		this.modifierName2 = modifierName2;
	}
	public String getModifierName() {
		return modifierName;
	}
	public void setModifierName(String modifierName) {
		this.modifierName = modifierName;
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
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getTransferFlag() {
		return transferFlag;
	}
	public void setTransferFlag(String transferFlag) {
		this.transferFlag = transferFlag;
	}
	public String getDelayFlag() {
		return delayFlag;
	}
	public void setDelayFlag(String delayFlag) {
		this.delayFlag = delayFlag;
	}
	public String getDisplayRecFlag() {
		return displayRecFlag;
	}
	public void setDisplayRecFlag(String displayRecFlag) {
		this.displayRecFlag = displayRecFlag;
	}
	public String getEndYear() {
		return endYear;
	}
	public void setEndYear(String endYear) {
		this.endYear = endYear;
	}
	public String getDispClassNo() {
		return dispClassNo;
	}
	public void setDispClassNo(String dispClassNo) {
		this.dispClassNo = dispClassNo;
	}
	public String getRowNum_() {
		return rowNum_;
	}
	public void setRowNum_(String rowNum_) {
		this.rowNum_ = rowNum_;
	}
	public String getCabinetID() {
		return cabinetID;
	}
	public void setCabinetID(String cabinetID) {
		this.cabinetID = cabinetID;
	}
	public String getRegSerialNo() {
		return regSerialNo;
	}
	public void setRegSerialNo(String regSerialNo) {
		this.regSerialNo = regSerialNo;
	}
	public String getProductionYear() {
		return productionYear;
	}
	public void setProductionYear(String productionYear) {
		this.productionYear = productionYear;
	}
	public String getVolumeNo() {
		return volumeNo;
	}
	public void setVolumeNo(String volumeNo) {
		this.volumeNo = volumeNo;
	}
	public String getModifyFlag() {
		return modifyFlag;
	}
	public void setModifyFlag(String modifyFlag) {
		this.modifyFlag = modifyFlag;
	}
	public String getCabinetTransferFlag() {
		return cabinetTransferFlag;
	}
	public void setCabinetTransferFlag(String cabinetTransferFlag) {
		this.cabinetTransferFlag = cabinetTransferFlag;
	}
	public String getConfirmFlag() {
		return confirmFlag;
	}
	public void setConfirmFlag(String confirmFlag) {
		this.confirmFlag = confirmFlag;
	}
	public String getTaskCode() {
		return taskCode;
	}
	public void setTaskCode(String taskCode) {
		this.taskCode = taskCode;
	}
	public String getTaskName() {
		return taskName;
	}
	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}
	public String getTaskName2() {
		return taskName2;
	}
	public void setTaskName2(String taskName2) {
		this.taskName2 = taskName2;
	}
	public String getProcessDeptCode() {
		return processDeptCode;
	}
	public void setProcessDeptCode(String processDeptCode) {
		this.processDeptCode = processDeptCode;
	}
	public String getProcessDeptName() {
		return processDeptName;
	}
	public void setProcessDeptName(String processDeptName) {
		this.processDeptName = processDeptName;
	}
	public String getProcessDeptName2() {
		return processDeptName2;
	}
	public void setProcessDeptName2(String processDeptName2) {
		this.processDeptName2 = processDeptName2;
	}
	public String getCabinetClassNo() {
		return cabinetClassNo;
	}
	public void setCabinetClassNo(String cabinetClassNo) {
		this.cabinetClassNo = cabinetClassNo;
	}
	public String getRecTypeCode() {
		return recTypeCode;
	}
	public void setRecTypeCode(String recTypeCode) {
		this.recTypeCode = recTypeCode;
	}
	public String getClassCreateDate() {
		return classCreateDate;
	}
	public void setClassCreateDate(String classCreateDate) {
		this.classCreateDate = classCreateDate;
	}
	public String getOwnerID() {
		return ownerID;
	}
	public void setOwnerID(String ownerID) {
		this.ownerID = ownerID;
	}
	public String getSpecialCatalogFlag() {
		return specialCatalogFlag;
	}
	public void setSpecialCatalogFlag(String specialCatalogFlag) {
		this.specialCatalogFlag = specialCatalogFlag;
	}
	public String getTerminateFlag() {
		return terminateFlag;
	}
	public void setTerminateFlag(String terminateFlag) {
		this.terminateFlag = terminateFlag;
	}
	public String getOwnerDeptID() {
		return ownerDeptID;
	}
	public void setOwnerDeptID(String ownerDeptID) {
		this.ownerDeptID = ownerDeptID;
	}
	public String getOwnerTask() {
		return ownerTask;
	}
	public void setOwnerTask(String ownerTask) {
		this.ownerTask = ownerTask;
	}
	public String getTransDelayFlag() {
		return transDelayFlag;
	}
	public void setTransDelayFlag(String transDelayFlag) {
		this.transDelayFlag = transDelayFlag;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getTitle2() {
		return title2;
	}
	public void setTitle2(String title2) {
		this.title2 = title2;
	}
	public String getcName() {
		return cName;
	}
	public void setcName(String cName) {
		this.cName = cName;
	}
	public String getMcName() {
		return mcName;
	}
	public void setMcName(String mcName) {
		this.mcName = mcName;
	}
	public String getScName() {
		return scName;
	}
	public void setScName(String scName) {
		this.scName = scName;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getSubCategoryCode() {
		return subCategoryCode;
	}
	public void setSubCategoryCode(String subCategoryCode) {
		this.subCategoryCode = subCategoryCode;
	}
	public String getKeepingPeriod() {
		return keepingPeriod;
	}
	public void setKeepingPeriod(String keepingPeriod) {
		this.keepingPeriod = keepingPeriod;
	}
	public String getTempFlag() {
		return tempFlag;
	}
	public void setTempFlag(String tempFlag) {
		this.tempFlag = tempFlag;
	}
	public String getDiplayRecFlag() {
		return diplayRecFlag;
	}
	public void setDiplayRecFlag(String diplayRecFlag) {
		this.diplayRecFlag = diplayRecFlag;
	}
	public String getSc1() {
		return sc1;
	}
	public void setSc1(String sc1) {
		this.sc1 = sc1;
	}
	public String getSc2() {
		return sc2;
	}
	public void setSc2(String sc2) {
		this.sc2 = sc2;
	}
	public String getSc3() {
		return sc3;
	}
	public void setSc3(String sc3) {
		this.sc3 = sc3;
	}
	public String getKeepingMethod() {
		return keepingMethod;
	}
	public void setKeepingMethod(String keepingMethod) {
		this.keepingMethod = keepingMethod;
	}
	public String getKeepingPlace() {
		return keepingPlace;
	}
	public void setKeepingPlace(String keepingPlace) {
		this.keepingPlace = keepingPlace;
	}
	public String getLimitRange() {
		return limitRange;
	}
	public void setLimitRange(String limitRange) {
		this.limitRange = limitRange;
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
	public String getCatalogTransferFlag() {
		return catalogTransferFlag;
	}
	public void setCatalogTransferFlag(String catalogTransferFlag) {
		this.catalogTransferFlag = catalogTransferFlag;
	}
	public String getCatalogTransferYear() {
		return catalogTransferYear;
	}
	public void setCatalogTransferYear(String catalogTransferYear) {
		this.catalogTransferYear = catalogTransferYear;
	}
	public String getDocTransferFlag() {
		return docTransferFlag;
	}
	public void setDocTransferFlag(String docTransferFlag) {
		this.docTransferFlag = docTransferFlag;
	}
	public String getDocTransferYear() {
		return docTransferYear;
	}
	public void setDocTransferYear(String docTransferYear) {
		this.docTransferYear = docTransferYear;
	}
	public String getCabDeptCode() {
		return cabDeptCode;
	}
	public void setCabDeptCode(String cabDeptCode) {
		this.cabDeptCode = cabDeptCode;
	}
	public String getCabTitle() {
		return cabTitle;
	}
	public void setCabTitle(String cabTitle) {
		this.cabTitle = cabTitle;
	}
	public String getDelayEndYFlag() {
		return delayEndYFlag;
	}
	public void setDelayEndYFlag(String delayEndYFlag) {
		this.delayEndYFlag = delayEndYFlag;
	}
	
}
