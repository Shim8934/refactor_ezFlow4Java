package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGAprLineVO {
	/** 문서아이디*/
	private String docID;
	/** 결재자아이디*/
	private String orgUserID;
	/** 대리결재자아이디*/
	private String proxyUserID;
	/** 대리결재자이름*/
	private String proxyUserName;
	/** 대리결재자이름(다국어)*/
	private String proxyUserName2;
	/** 대리결재자직위*/
	private String proxyUserJobTitle;
	/** 대리결재자직위(다국어)*/
	private String proxyUserJobTitle2;
	/** 대리결재자부서아이디*/
	private String proxyUserDeptID;
	/** 대리결재자부서이름*/
	private String proxyUserDeptName;
	/** 대리결재자부서이름(다국어)*/
	private String proxyUserDeptName2;
	/** 사용자아이디*/
	private String userID;
	/** 양식아이디*/
	private String formID;
	/** 결재자순번*/
	private String aprMemberSN;
	/** 결재방법*/
	private String aprType;
	/** 결재상태*/
	private String aprState;
	/** 결재자아이디*/
	private String aprMemberID;
	/** 결재자부서여부*/
	private String aprMemberIsDeptYN;
	/** 결재자이름*/
	private String aprMemberName;
	/** 결재자직위*/
	private String aprMemberJobTitle;
	/** 결재자부서아이디*/
	private String aprMemberDeptID;
	/** 결재자부서이름*/
	private String aprMemberDeptName;
	/** 결재자회사아이디*/
	private String aprMemberLdapPath;
	/** 도착일자*/
	private String receivedDate;
	/** 결재일자*/
	private String processDate;
	/** 결재안함사유*/
	private String reasonDoNotApprov;
	/** 발의자여부*/
	private String isProposerYN;
	/** 보고자여부*/
	private String isBriefUserYN;
	/** 결재자이름(다국어)*/
	private String aprMemberName2;
	/** 결재자직위(다국어)*/
	private String aprMemberJobTitle2;
	/** 결재자부서이름(다국어)*/
	private String aprMemberDeptName2;
	/** */
	private String processorID;
	/** */
	private String receivedDeptID;
	/** */
	private String flag;
	/** */
	private String gDocID;
	/** */
	private String aprCount;
	/** */
	private String docType;
	/** */
	private String docState;
	/** */
	private String orgDocID;
	/** */
	private String companyID;
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getFormID() {
		return formID;
	}
	public void setFormID(String formID) {
		this.formID = formID;
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
	public String getAprMemberIsDeptYN() {
		return aprMemberIsDeptYN;
	}
	public void setAprMemberIsDeptYN(String aprMemberIsDeptYN) {
		this.aprMemberIsDeptYN = aprMemberIsDeptYN;
	}
	public String getAprMemberName() {
		return aprMemberName;
	}
	public void setAprMemberName(String aprMemberName) {
		this.aprMemberName = aprMemberName;
	}
	public String getAprMemberJobTitle() {
		return aprMemberJobTitle;
	}
	public void setAprMemberJobTitle(String aprMemberJobTitle) {
		this.aprMemberJobTitle = aprMemberJobTitle;
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
	public String getAprMemberLdapPath() {
		return aprMemberLdapPath;
	}
	public void setAprMemberLdapPath(String aprMemberLdapPath) {
		this.aprMemberLdapPath = aprMemberLdapPath;
	}
	public String getReceivedDate() {
		return receivedDate;
	}
	public void setReceivedDate(String receivedDate) {
		this.receivedDate = receivedDate;
	}
	public String getProcessDate() {
		return processDate;
	}
	public void setProcessDate(String processDate) {
		this.processDate = processDate;
	}
	public String getReasonDoNotApprov() {
		return reasonDoNotApprov;
	}
	public void setReasonDoNotApprov(String reasonDoNotApprov) {
		this.reasonDoNotApprov = reasonDoNotApprov;
	}
	public String getIsProposerYN() {
		return isProposerYN;
	}
	public void setIsProposerYN(String isProposerYN) {
		this.isProposerYN = isProposerYN;
	}
	public String getIsBriefUserYN() {
		return isBriefUserYN;
	}
	public void setIsBriefUserYN(String isBriefUserYN) {
		this.isBriefUserYN = isBriefUserYN;
	}
	public String getAprMemberName2() {
		return aprMemberName2;
	}
	public void setAprMemberName2(String aprMemberName2) {
		this.aprMemberName2 = aprMemberName2;
	}
	public String getAprMemberJobTitle2() {
		return aprMemberJobTitle2;
	}
	public void setAprMemberJobTitle2(String aprMemberJobTitle2) {
		this.aprMemberJobTitle2 = aprMemberJobTitle2;
	}
	public String getAprMemberDeptName2() {
		return aprMemberDeptName2;
	}
	public void setAprMemberDeptName2(String aprMemberDeptName2) {
		this.aprMemberDeptName2 = aprMemberDeptName2;
	}
	public String getDocID() {
		return docID;
	}
	public void setDocID(String docID) {
		this.docID = docID;
	}
	public String getOrgUserID() {
		return orgUserID;
	}
	public void setOrgUserID(String orgUserID) {
		this.orgUserID = orgUserID;
	}
	public String getProxyUserID() {
		return proxyUserID;
	}
	public void setProxyUserID(String proxyUserID) {
		this.proxyUserID = proxyUserID;
	}
	public String getProxyUserName() {
		return proxyUserName;
	}
	public void setProxyUserName(String proxyUserName) {
		this.proxyUserName = proxyUserName;
	}
	public String getProxyUserName2() {
		return proxyUserName2;
	}
	public void setProxyUserName2(String proxyUserName2) {
		this.proxyUserName2 = proxyUserName2;
	}
	public String getProxyUserJobTitle() {
		return proxyUserJobTitle;
	}
	public void setProxyUserJobTitle(String proxyUserJobTitle) {
		this.proxyUserJobTitle = proxyUserJobTitle;
	}
	public String getProxyUserJobTitle2() {
		return proxyUserJobTitle2;
	}
	public void setProxyUserJobTitle2(String proxyUserJobTitle2) {
		this.proxyUserJobTitle2 = proxyUserJobTitle2;
	}
	public String getProxyUserDeptID() {
		return proxyUserDeptID;
	}
	public void setProxyUserDeptID(String proxyUserDeptID) {
		this.proxyUserDeptID = proxyUserDeptID;
	}
	public String getProxyUserDeptName() {
		return proxyUserDeptName;
	}
	public void setProxyUserDeptName(String proxyUserDeptName) {
		this.proxyUserDeptName = proxyUserDeptName;
	}
	public String getProxyUserDeptName2() {
		return proxyUserDeptName2;
	}
	public void setProxyUserDeptName2(String proxyUserDeptName2) {
		this.proxyUserDeptName2 = proxyUserDeptName2;
	}
	public String getProcessorID() {
		return processorID;
	}
	public void setProcessorID(String processorID) {
		this.processorID = processorID;
	}
	public String getReceivedDeptID() {
		return receivedDeptID;
	}
	public void setReceivedDeptID(String receivedDeptID) {
		this.receivedDeptID = receivedDeptID;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getgDocID() {
		return gDocID;
	}
	public void setgDocID(String gDocID) {
		this.gDocID = gDocID;
	}
	public String getAprCount() {
		return aprCount;
	}
	public void setAprCount(String aprCount) {
		this.aprCount = aprCount;
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
	public String getOrgDocID() {
		return orgDocID;
	}
	public void setOrgDocID(String orgDocID) {
		this.orgDocID = orgDocID;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	
}
