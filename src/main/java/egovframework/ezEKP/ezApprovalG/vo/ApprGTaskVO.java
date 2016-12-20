package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGTaskVO {
	/** 대기능코드*/
	private String categoryCode;
	/** 대기능명*/
	private String cName;
	/** 대기능명(다국어)*/
	private String cName2;
	/** 중기능코드*/
	private String mcategoryCode;
	/** 중기능명*/
	private String mcName;
	/** 중기능명(다국어)*/
	private String mcName2;
	/** 소기능코드*/
	private String subCategoryCode;
	/** 소기능명*/
	private String scName;
	/** 단위업무코드*/
	private String taskCode;
	/** 단위업무명*/
	private String taskName;
	
	private String taskName1;
	/** 단위업무명(다국어)*/
	private String taskName2;
	/** 보존년도*/
	private String keepingPeriod;
	/** 비치기록물여부*/
	private String displayRecFlag;
	/** 비치기록물이관시기*/
	private String displayRecTrasTime;
	/** 특수목록위치*/
	private String specialCatalogFlag; 
	/** 제1특수목록*/
	private String sc1;
	/** 제2특수목록*/
	private String sc2;
	/** 제3특수목록*/
	private String sc3;
	/** 임시여부*/
	private String tempFlag;
	/** 보존방법코드*/
	private String keepingMethod;
	/** 보존장소*/
	private String keepingPlace;
	/** 처리과부서코드*/
	private String processDeptCode;
	/** 처리과이름*/
	private String processDeptName;
	/** 처리과이름(다국어)*/
	private String processDeptName2;
	/** 소기능명(다국어)*/
	private String scName2;
	/** */
	private String cabinetID;
	/** */
	private String cabinetClassNo;
	/** */
	private String ownerID;
	/** */
	private String title;
	/** */
	private String title2;
	/** */
	private String recTypeCode;
	/** */
	private String regSerialNo;
	/** */
	private String volumeNo;
	/** */
	private String productionYear;
	/** */
	private String cabinetTransferFlag;
	/** */
	private String tcabinetID;
	/** */
	private String tDeptCode;
	/** */
	private String displayEndDate;
	/** */
	private String categoryType;
	/** */
	private String description;
	/** */
	private String name;
	/** */
	private String name2;
	/** */
	private String createDate;
	/** */
	private String kpReason;
	/** */
	private String exDisplayFrequency;
	/** */
	private String displayUsage;
	/** */
	private String processDate;
	/** */
	private String applyDate;
	
	/** 기록물철등록 */
	private String numOfRec;
	private String numOfPage;
	private String numOfFile;
	private String modifyFlag;
	private String oldCabinetFlag;
	private String createOrganName;
	private String classificationNo;
	private String expirationYear;
	private String displayReason;
	private String cabCharger;
	private String confirmFlag;
	private String catalogTransferFlag;
	private String catalogTransferYear;
	private String docTransferFlag;
	private String docTransferYear;
	private String tCabinetName;
	private String tCabinetName1;
	private String tCabinetName2;
	private String tDeptName;
	private String tDeptName1;
	private String tDeptName2;
	private String tProduceYear;
	private String tVolumNo;
	private String transferDate;
	private String serialNo;
	private String tTaskName;
	private String tTaskCode;
	private String tRegSerialNo;
	private String tVolumeNo; 
	
	public String gettRegSerialNo() {
		return tRegSerialNo;
	}
	public void settRegSerialNo(String tRegSerialNo) {
		this.tRegSerialNo = tRegSerialNo;
	}
	public String gettVolumeNo() {
		return tVolumeNo;
	}
	public void settVolumeNo(String tVolumeNo) {
		this.tVolumeNo = tVolumeNo;
	}
	public String gettTaskName() {
		return tTaskName;
	}
	public void settTaskName(String tTaskName) {
		this.tTaskName = tTaskName;
	}
	public String gettTaskCode() {
		return tTaskCode;
	}
	public void settTaskCode(String tTaskCode) {
		this.tTaskCode = tTaskCode;
	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String gettDeptName() {
		return tDeptName;
	}
	public void settDeptName(String tDeptName) {
		this.tDeptName = tDeptName;
	}
	public String gettCabinetName() {
		return tCabinetName;
	}
	public void settCabinetName(String tCabinetName) {
		this.tCabinetName = tCabinetName;
	}
	public void setCreateOrganName(String createOrganName) {
		this.createOrganName = createOrganName;
	}
	public String getNumOfRec() {
		return numOfRec;
	}
	public void setNumOfRec(String numOfRec) {
		this.numOfRec = numOfRec;
	}
	public String getNumOfPage() {
		return numOfPage;
	}
	public void setNumOfPage(String numOfPage) {
		this.numOfPage = numOfPage;
	}
	public String getNumOfFile() {
		return numOfFile;
	}
	public void setNumOfFile(String numOfFile) {
		this.numOfFile = numOfFile;
	}
	public String getModifyFlag() {
		return modifyFlag;
	}
	public void setModifyFlag(String modifyFlag) {
		this.modifyFlag = modifyFlag;
	}
	public String getOldCabinetFlag() {
		return oldCabinetFlag;
	}
	public void setOldCabinetFlag(String oldCabinetFlag) {
		this.oldCabinetFlag = oldCabinetFlag;
	}
	public String getCreateOrganName() {
		return createOrganName;
	}
	public void setCreateOrgdnName(String createOrganName) {
		this.createOrganName = createOrganName;
	}
	public String getClassificationNo() {
		return classificationNo;
	}
	public void setClassificationNo(String classificationNo) {
		this.classificationNo = classificationNo;
	}
	public String getExpirationYear() {
		return expirationYear;
	}
	public void setExpirationYear(String expirationYear) {
		this.expirationYear = expirationYear;
	}
	public String getDisplayReason() {
		return displayReason;
	}
	public void setDisplayReason(String displayReason) {
		this.displayReason = displayReason;
	}
	public String getCabCharger() {
		return cabCharger;
	}
	public void setCabCharger(String cabCharger) {
		this.cabCharger = cabCharger;
	}
	public String getConfirmFlag() {
		return confirmFlag;
	}
	public void setConfirmFlag(String confirmFlag) {
		this.confirmFlag = confirmFlag;
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
	public String gettCabinetName1() {
		return tCabinetName1;
	}
	public void settCabinetName1(String tCabinetName1) {
		this.tCabinetName1 = tCabinetName1;
	}
	public String gettCabinetName2() {
		return tCabinetName2;
	}
	public void settCabinetName2(String tCabinetName2) {
		this.tCabinetName2 = tCabinetName2;
	}
	public String gettDeptName1() {
		return tDeptName1;
	}
	public void settDeptName1(String tDeptName1) {
		this.tDeptName1 = tDeptName1;
	}
	public String gettDeptName2() {
		return tDeptName2;
	}
	public void settDeptName2(String tDeptName2) {
		this.tDeptName2 = tDeptName2;
	}
	public String gettProduceYear() {
		return tProduceYear;
	}
	public void settProduceYear(String tProduceYear) {
		this.tProduceYear = tProduceYear;
	}
	public String gettVolumNo() {
		return tVolumNo;
	}
	public void settVolumNo(String tVolumNo) {
		this.tVolumNo = tVolumNo;
	}
	public String getTransferDate() {
		return transferDate;
	}
	public void setTransferDate(String transferDate) {
		this.transferDate = transferDate;
	}
	public String getCategoryCode() {
		return categoryCode;
	}
	public void setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
	}
	public String getcName() {
		return cName;
	}
	public void setcName(String cName) {
		this.cName = cName;
	}
	public String getcName2() {
		return cName2;
	}
	public void setcName2(String cName2) {
		this.cName2 = cName2;
	}
	public String getMcategoryCode() {
		return mcategoryCode;
	}
	public void setMcategoryCode(String mcategoryCode) {
		this.mcategoryCode = mcategoryCode;
	}
	public String getMcName() {
		return mcName;
	}
	public void setMcName(String mcName) {
		this.mcName = mcName;
	}
	public String getMcName2() {
		return mcName2;
	}
	public void setMcName2(String mcName2) {
		this.mcName2 = mcName2;
	}
	public String getSubCategoryCode() {
		return subCategoryCode;
	}
	public void setSubCategoryCode(String subCategoryCode) {
		this.subCategoryCode = subCategoryCode;
	}
	public String getScName() {
		return scName;
	}
	public void setScName(String scName) {
		this.scName = scName;
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
	public String getKeepingPeriod() {
		return keepingPeriod;
	}
	public void setKeepingPeriod(String keepingPeriod) {
		this.keepingPeriod = keepingPeriod;
	}
	public String getDisplayRecFlag() {
		return displayRecFlag;
	}
	public void setDisplayRecFlag(String displayRecFlag) {
		this.displayRecFlag = displayRecFlag;
	}
	public String getDisplayRecTrasTime() {
		return displayRecTrasTime;
	}
	public void setDisplayRecTrasTime(String displayRecTrasTime) {
		this.displayRecTrasTime = displayRecTrasTime;
	}
	public String getSpecialCatalogFlag() {
		return specialCatalogFlag;
	}
	public void setSpecialCatalogFlag(String specialCatalogFlag) {
		this.specialCatalogFlag = specialCatalogFlag;
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
	public String getTempFlag() {
		return tempFlag;
	}
	public void setTempFlag(String tempFlag) {
		this.tempFlag = tempFlag;
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
	public String getScName2() {
		return scName2;
	}
	public void setScName2(String scName2) {
		this.scName2 = scName2;
	}
	public String getCabinetID() {
		return cabinetID;
	}
	public void setCabinetID(String cabinetID) {
		this.cabinetID = cabinetID;
	}
	public String getCabinetClassNo() {
		return cabinetClassNo;
	}
	public void setCabinetClassNo(String cabinetClassNo) {
		this.cabinetClassNo = cabinetClassNo;
	}
	public String getOwnerID() {
		return ownerID;
	}
	public void setOwnerID(String ownerID) {
		this.ownerID = ownerID;
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
	public String getRecTypeCode() {
		return recTypeCode;
	}
	public void setRecTypeCode(String recTypeCode) {
		this.recTypeCode = recTypeCode;
	}
	public String getRegSerialNo() {
		return regSerialNo;
	}
	public void setRegSerialNo(String regSerialNo) {
		this.regSerialNo = regSerialNo;
	}
	public String getVolumeNo() {
		return volumeNo;
	}
	public void setVolumeNo(String volumeNo) {
		this.volumeNo = volumeNo;
	}
	public String getProductionYear() {
		return productionYear;
	}
	public void setProductionYear(String productionYear) {
		this.productionYear = productionYear;
	}
	public String getCabinetTransferFlag() {
		return cabinetTransferFlag;
	}
	public void setCabinetTransferFlag(String cabinetTransferFlag) {
		this.cabinetTransferFlag = cabinetTransferFlag;
	}
	public String getTcabinetID() {
		return tcabinetID;
	}
	public void setTcabinetID(String tcabinetID) {
		this.tcabinetID = tcabinetID;
	}
	public String gettDeptCode() {
		return tDeptCode;
	}
	public void settDeptCode(String tDeptCode) {
		this.tDeptCode = tDeptCode;
	}
	public String getDisplayEndDate() {
		return displayEndDate;
	}
	public void setDisplayEndDate(String displayEndDate) {
		this.displayEndDate = displayEndDate;
	}
	public String getCategoryType() {
		return categoryType;
	}
	public void setCategoryType(String categoryType) {
		this.categoryType = categoryType;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getName2() {
		return name2;
	}
	public void setName2(String name2) {
		this.name2 = name2;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getKpReason() {
		return kpReason;
	}
	public void setKpReason(String kpReason) {
		this.kpReason = kpReason;
	}
	public String getExDisplayFrequency() {
		return exDisplayFrequency;
	}
	public void setExDisplayFrequency(String exDisplayFrequency) {
		this.exDisplayFrequency = exDisplayFrequency;
	}
	public String getDisplayUsage() {
		return displayUsage;
	}
	public void setDisplayUsage(String displayUsage) {
		this.displayUsage = displayUsage;
	}
	public String getProcessDate() {
		return processDate;
	}
	public void setProcessDate(String processDate) {
		this.processDate = processDate;
	}
	public String getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}
	public String getTaskName1() {
		return taskName1;
	}
	public void setTaskName1(String taskName1) {
		this.taskName1 = taskName1;
	}
	
	
}
