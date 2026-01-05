package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGFormVO {
	/** 양식함아이디*/
	private String formContID;
	/** 양식아이디*/
	private String formID;
	/** 양식이름*/
	private String formName;
	/** 양식이름(다국어)*/
	private String formName2;
	/** 양식종류*/
	private String formDocType;
	/** 양식설명*/
	private String formDescription;
	/** 양식파일경로*/
	private String formFileLocation;
	/** 연동양식여부*/
	private String formConnFlag;
	/** 양식순서*/
	private String formOrder;
	/** 양식함이름*/
	private String formContName;
	/** 양식함이름(다국어)*/
	private String formContName2;
	/** 양식함관리부서아이디*/
	private String formContOwnDepID;
	/** 상위양식함아이디*/
	private String formContParents;
	/** 양식함설명*/
	private String formContDescription;
	/** 양식함사용중인 그룹아이디*/
	private String formContUserDepID;
	/** 양식별 고정수신처*/
	private String deptID;
	/** 양식별 고정수신처 순번*/
	private String deptSn;
	/** 양식별 고정수신처 이름*/
	private String deptName;
	/** 캐비넷아이디*/
	private String cabinetID;
	
	/** 속성값 조회를 위한 */
	private String code;
	
	private String id;
	
	private String name;
	
	private String description;
	
	private String upperCode;
	
	/** 일반 */
	private String keepPeriod;
	private String securityLevel;
	private String isPublic;
	private String itemCode;
	private String itemName;
	private String itemName2;
	private String useFlag;
	private String keepPeriodCode;
	private String userID;
	
	/** 폼빌더 */
	private String reformFlag;
	/** 폼버전 */
	private String formVersion;
	
	// 오피스 양식 여부
	private OfficeFlag officeFlag;
		
	private enum OfficeFlag {
		Y, N
	}
		
	private String companyID;

	/** 기결재통과 */
	private String passAprLineFlag;
	
	/** 원문정보공개 */
	private String openGovFlag;
	
	/** xslt연동 */
	private String formXslt;
	
	/**양식 세부설정**/
	private String aprOption;
	
	/** 시행문 타입 */
	private String sihangType;
	
	/** 2022-01-07 홍승비 - 전자결재G 일괄기안 옵션 추가 */
	private String formDraftAllFlag;

	/* 2024-11-25 기민혁 - 전자결재G > 최근서식 시간 */
	private String resendStartDate;

	/** 2025-07-02 김유진 - 모바일 기안 */
	private String mobileDraftFlag;
	
	public String getPassAprLineFlag() {
		return passAprLineFlag;
	}

	public void setPassAprLineFlag(String passAprLineFlag) {
		this.passAprLineFlag = passAprLineFlag;
	}

	public String getFormContID() {
		return formContID;
	}

	public void setFormContID(String formContID) {
		this.formContID = formContID;
	}

	public String getFormID() {
		return formID;
	}

	public void setFormID(String formID) {
		this.formID = formID;
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

	public String getFormDocType() {
		return formDocType;
	}

	public void setFormDocType(String formDocType) {
		this.formDocType = formDocType;
	}

	public String getFormDescription() {
		return formDescription;
	}

	public void setFormDescription(String formDescription) {
		this.formDescription = formDescription;
	}

	public String getFormFileLocation() {
		return formFileLocation;
	}

	public void setFormFileLocation(String formFileLocation) {
		this.formFileLocation = formFileLocation;
	}

	public String getFormConnFlag() {
		return formConnFlag;
	}

	public void setFormConnFlag(String formConnFlag) {
		this.formConnFlag = formConnFlag;
	}

	public String getFormOrder() {
		return formOrder;
	}

	public void setFormOrder(String formOrder) {
		this.formOrder = formOrder;
	}

	public String getFormContName() {
		return formContName;
	}

	public void setFormContName(String formContName) {
		this.formContName = formContName;
	}

	public String getFormContName2() {
		return formContName2;
	}

	public void setFormContName2(String formContName2) {
		this.formContName2 = formContName2;
	}

	public String getFormContOwnDepID() {
		return formContOwnDepID;
	}

	public void setFormContOwnDepID(String formContOwnDepID) {
		this.formContOwnDepID = formContOwnDepID;
	}

	public String getFormContParents() {
		return formContParents;
	}

	public void setFormContParents(String formContParents) {
		this.formContParents = formContParents;
	}

	public String getFormContDescription() {
		return formContDescription;
	}

	public void setFormContDescription(String formContDescription) {
		this.formContDescription = formContDescription;
	}

	public String getFormContUserDepID() {
		return formContUserDepID;
	}

	public void setFormContUserDepID(String formContUserDepID) {
		this.formContUserDepID = formContUserDepID;
	}

	public String getDeptID() {
		return deptID;
	}

	public void setDeptID(String deptID) {
		this.deptID = deptID;
	}

	public String getDeptSn() {
		return deptSn;
	}

	public void setDeptSn(String deptSn) {
		this.deptSn = deptSn;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getUpperCode() {
		return upperCode;
	}

	public void setUpperCode(String upperCode) {
		this.upperCode = upperCode;
	}

	public String getKeepPeriod() {
		return keepPeriod;
	}

	public void setKeepPeriod(String keepPeriod) {
		this.keepPeriod = keepPeriod;
	}

	public String getSecurityLevel() {
		return securityLevel;
	}

	public void setSecurityLevel(String securityLevel) {
		this.securityLevel = securityLevel;
	}

	public String getIsPublic() {
		return isPublic;
	}

	public void setIsPublic(String isPublic) {
		this.isPublic = isPublic;
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

	public String getItemName2() {
		return itemName2;
	}

	public void setItemName2(String itemName2) {
		this.itemName2 = itemName2;
	}

	public String getUseFlag() {
		return useFlag;
	}

	public void setUseFlag(String useFlag) {
		this.useFlag = useFlag;
	}

	public String getKeepPeriodCode() {
		return keepPeriodCode;
	}

	public void setKeepPeriodCode(String keepPeriodCode) {
		this.keepPeriodCode = keepPeriodCode;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getCabinetID() {
		return cabinetID;
	}

	public void setCabinetID(String cabinetID) {
		this.cabinetID = cabinetID;
	}
	
	public String getReformFlag() {
		return reformFlag;
	}

	public void setReformFlag(String reformFlag) {
		this.reformFlag = reformFlag;
	}

	public String getFormVersion() {
		return formVersion;
	}

	public void setFormVersion(String formVersion) {
		this.formVersion = formVersion;
	}
	
	public OfficeFlag getOfficeFlag() {
		return officeFlag;
	}
	public void setOfficeFlag(OfficeFlag officeFlag) {
		this.officeFlag = officeFlag;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}

	public String getOpenGovFlag() {
		return openGovFlag;
	}

	public void setOpenGovFlag(String openGovFlag) {
		this.openGovFlag = openGovFlag;
	}

	public String getAprOption() {
		return aprOption;
	}

	public void setAprOption(String aprOption) {
		this.aprOption = aprOption;
	}

    public String getSihangType() {
        return sihangType;
    }

    public void setSihangType(String sihangType) {
        this.sihangType = sihangType;
    }

    public String getFormXslt() {
        return formXslt;
    }

    public void setFormXslt(String formXslt) {
        this.formXslt = formXslt;
    }

	public String getFormDraftAllFlag() {
		return formDraftAllFlag;
	}

	public void setFormDraftAllFlag(String formDraftAllFlag) {
		this.formDraftAllFlag = formDraftAllFlag;
	}

	public String getResendStartDate() { return resendStartDate; }

	public void setResendStartDate(String resendStartDate) { this.resendStartDate = resendStartDate; }

	public String getMobileDraftFlag() {
		return mobileDraftFlag;
	}

	public void setMobileDraftFlag(String mobileDraftFlag) {
		this.mobileDraftFlag = mobileDraftFlag;
	}
}
