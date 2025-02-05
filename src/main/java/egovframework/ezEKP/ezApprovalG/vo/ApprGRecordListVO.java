package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGRecordListVO {
	/** */
	private int tenantID;
	/** */
	private String listType;
	/** */
	private String companyID;
	/** */
	private String lang;
	/** */
	private String cabTitle;
	/** */
	private String transExpire;
	/** */
	private String charger;
	/** */
	private String tempDeptCode;
	/** */
	private String transFlag;
	/** */
	private String listFlag;
	/** */
	private String extraSelectClause;
	/** */
	private String deptCode;
	/** */
	private String orderBy;
	/** */
	private String pageSize;
	/** */
	private String pageNO;
	/** */
	private String multiLang;
	/** */
	private String offsetMin;
	/** */
	private boolean usePublicFlag;
	/** */
	private String cabinetIDs;
	/** */
	private String recDeptCode;
	/** */
	private String title;
	/** */
	private String regType;
	/** */
	private String regStartDate;
	/** */
	private String regEndDate;
	/** */
	private String sc;
	/** */
	private String drafter;
	/** */
	private String userSecurityCode;
	/** */
	private String isUse;
	/** */
	private String userID;
	/** */
	private String dFlag;
	/** */
	private int start;
	/** */
	private int end;
	/** */
	private int limit;
	/** */
	private int rowCount;
	/** */
	private String isDocPrint;
	/** */
	private String nowDate;
	
	private String relayFormID;
	private boolean joinEndReceiptPointInfo;
	
	/* 이유정 - SQL Injection 웹취약점 수정 작업으로 EzApprovalG.getRecordList 관련 파라미터 추가 */
	private String[] cabinetIDArr;
	private String[] chargerArr;
	private String sort;
	private String dispRegisterNo;
	private String recTitle;
	private String dispClassNo;
	private String reSendFlag;
	private String registerDate;
	private String numOfPage;
	private String registerYear;
	private String transYear;
	private String displayReason;
	private String sepTitle;
	
	private String formID;
	
	private String drafterDept;
	
	private String orgDocNum;
	
	private String docNum;
	
	private String selSendStatus;
	
	/* 상위부서아이디 */
	private String upperDeptCode;

	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public String getListType() {
		return listType;
	}
	public void setListType(String listType) {
		this.listType = listType;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	public String getCabTitle() {
		return cabTitle;
	}
	public void setCabTitle(String cabTitle) {
		this.cabTitle = cabTitle;
	}
	public String getTransExpire() {
		return transExpire;
	}
	public void setTransExpire(String transExpire) {
		this.transExpire = transExpire;
	}
	public String getCharger() {
		return charger;
	}
	public void setCharger(String charger) {
		this.charger = charger;
	}
	public String getTempDeptCode() {
		return tempDeptCode;
	}
	public void setTempDeptCode(String tempDeptCode) {
		this.tempDeptCode = tempDeptCode;
	}
	public String getTransFlag() {
		return transFlag;
	}
	public void setTransFlag(String transFlag) {
		this.transFlag = transFlag;
	}
	public String getListFlag() {
		return listFlag;
	}
	public void setListFlag(String listFlag) {
		this.listFlag = listFlag;
	}
	public String getExtraSelectClause() {
		return extraSelectClause;
	}
	public void setExtraSelectClause(String extraSelectClause) {
		this.extraSelectClause = extraSelectClause;
	}
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	public String getOrderBy() {
		return orderBy;
	}
	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}
	public String getPageSize() {
		return pageSize;
	}
	public void setPageSize(String pageSize) {
		this.pageSize = pageSize;
	}
	public String getPageNO() {
		return pageNO;
	}
	public void setPageNO(String pageNO) {
		this.pageNO = pageNO;
	}
	public String getMultiLang() {
		return multiLang;
	}
	public void setMultiLang(String multiLang) {
		this.multiLang = multiLang;
	}
	public String getOffsetMin() {
		return offsetMin;
	}
	public void setOffsetMin(String offsetMin) {
		this.offsetMin = offsetMin;
	}
	public boolean isUsePublicFlag() {
		return usePublicFlag;
	}
	public void setUsePublicFlag(boolean usePublicFlag) {
		this.usePublicFlag = usePublicFlag;
	}
	public String getCabinetIDs() {
		return cabinetIDs;
	}
	public void setCabinetIDs(String cabinetIDs) {
		this.cabinetIDs = cabinetIDs;
	}
	public String getRecDeptCode() {
		return recDeptCode;
	}
	public void setRecDeptCode(String recDeptCode) {
		this.recDeptCode = recDeptCode;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getRegType() {
		return regType;
	}
	public void setRegType(String regType) {
		this.regType = regType;
	}
	public String getRegStartDate() {
		return regStartDate;
	}
	public void setRegStartDate(String regStartDate) {
		this.regStartDate = regStartDate;
	}
	public String getRegEndDate() {
		return regEndDate;
	}
	public void setRegEndDate(String regEndDate) {
		this.regEndDate = regEndDate;
	}
	public String getSc() {
		return sc;
	}
	public void setSc(String sc) {
		this.sc = sc;
	}
	public String getDrafter() {
		return drafter;
	}
	public void setDrafter(String drafter) {
		this.drafter = drafter;
	}
	public String getUserSecurityCode() {
		return userSecurityCode;
	}
	public void setUserSecurityCode(String userSecurityCode) {
		this.userSecurityCode = userSecurityCode;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getdFlag() {
		return dFlag;
	}
	public void setdFlag(String dFlag) {
		this.dFlag = dFlag;
	}
	public int getStart() {
		return start;
	}
	public void setStart(int start) {
		this.start = start;
	}
	public int getEnd() {
		return end;
	}
	public void setEnd(int end) {
		this.end = end;
	}
	public int getLimit() {
		return limit;
	}
	public void setLimit(int limit) {
		this.limit = limit;
	}
	public int getRowCount() {
		return rowCount;
	}
	public void setRowCount(int rowCount) {
		this.rowCount = rowCount;
	}
	public String getIsDocPrint() {
		return isDocPrint;
	}
	public void setIsDocPrint(String isDocPrint) {
		this.isDocPrint = isDocPrint;
	}
	public String getNowDate() {
		return nowDate;
	}
	public void setNowDate(String nowDate) {
		this.nowDate = nowDate;
	}
    public String getRelayFormID() {
        return relayFormID;
    }
    public void setRelayFormID(String relayFormID) {
        this.relayFormID = relayFormID;
    }
    public boolean getJoinEndReceiptPointInfo() {
        return joinEndReceiptPointInfo;
    }
    public void setJoinEndReceiptPointInfo(boolean joinEndReceiptPointInfo) {
        this.joinEndReceiptPointInfo = joinEndReceiptPointInfo;
    }
	public String[] getCabinetIDArr() {
		return cabinetIDArr;
	}
	public void setCabinetIDArr(String[] cabinetIDArr) {
		this.cabinetIDArr = cabinetIDArr;
	}
	public String[] getChargerArr() {
		return chargerArr;
	}
	public void setChargerArr(String[] chargerArr) {
		this.chargerArr = chargerArr;
	}
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
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
	public String getReSendFlag() {
		return reSendFlag;
	}
	public void setReSendFlag(String reSendFlag) {
		this.reSendFlag = reSendFlag;
	}
	public String getRegisterDate() {
		return registerDate;
	}
	public void setRegisterDate(String registerDate) {
		this.registerDate = registerDate;
	}
	public String getNumOfPage() {
		return numOfPage;
	}
	public void setNumOfPage(String numOfPage) {
		this.numOfPage = numOfPage;
	}
	public String getRegisterYear() {
		return registerYear;
	}
	public void setRegisterYear(String registerYear) {
		this.registerYear = registerYear;
	}
	public String getTransYear() {
		return transYear;
	}
	public void setTransYear(String transYear) {
		this.transYear = transYear;
	}
	public String getDisplayReason() {
		return displayReason;
	}
	public void setDisplayReason(String displayReason) {
		this.displayReason = displayReason;
	}
	public String getSepTitle() {
		return sepTitle;
	}
	public void setSepTitle(String sepTitle) {
		this.sepTitle = sepTitle;
	}
	
	public String getFormID() { return formID; }

	public void setFormID(String formID) { this.formID = formID; }

	public String getDrafterDept() { return drafterDept; }

	public void setDrafterDept(String drafterDept) { this.drafterDept = drafterDept; }

	public String getOrgDocNum() { return orgDocNum; }

	public void setOrgDocNum(String orgDocNum) { this.orgDocNum = orgDocNum; }

	public String getDocNum() { return docNum; }

	public void setDocNum(String docNum) { this.docNum = docNum; }

	public String getSelSendStatus() { return selSendStatus; }
	
	public void setSelSendStatus(String selSendStatus) { this.selSendStatus = selSendStatus; }
	
	
	public String getupperDeptCode() {
		return upperDeptCode;
	}
	
	public void setupperDeptCode(String upperDeptCode) {
		this.upperDeptCode = upperDeptCode;
	}
}
