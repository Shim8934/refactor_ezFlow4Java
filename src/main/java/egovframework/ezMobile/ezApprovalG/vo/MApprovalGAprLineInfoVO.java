package egovframework.ezMobile.ezApprovalG.vo;

public class MApprovalGAprLineInfoVO {
	/** 결재상태*/
	private String aprState;
	/** 결재 종류*/
	private String aprType;
	/** 결재자이름*/
	private String aprMemberName;
	/** 결재자직위*/
	private String aprMemberJobTitle;
	/** 결재자부서명*/
	private String aprMemberDeptName;
	/** 받은날짜*/
	private String receivedDate;
	/** 결재날짜*/
	private String processDate;
	/** 대리결재자이름*/
	private String proxyUserName;
	/** 대리결재자직위*/
	private String proxyUserJobTitle;
	/** 대리결재자부서명*/
	private String proxyUserDeptName;
	/** 결재자사진*/
	private String aprMemberPhoto;
	/** 결재자Id*/
	private String aprMemberId;
	/** 결재자순번*/
	private String aprMemberSn;
	
	public String getAprState() {
		return aprState;
	}
	public void setAprState(String aprState) {
		this.aprState = aprState;
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
	public String getAprMemberDeptName() {
		return aprMemberDeptName;
	}
	public void setAprMemberDeptName(String aprMemberDeptName) {
		this.aprMemberDeptName = aprMemberDeptName;
	}
	public String getReceivedDate() {
		return receivedDate;
	}
	public void setReceivedDate(String receivedDate) {
		this.receivedDate = receivedDate;
	}
	public String getProxyUserName() {
		return proxyUserName;
	}
	public void setProxyUserName(String proxyUserName) {
		this.proxyUserName = proxyUserName;
	}
	public String getProxyUserJobTitle() {
		return proxyUserJobTitle;
	}
	public void setProxyUserJobTitle(String proxyUserJobTitle) {
		this.proxyUserJobTitle = proxyUserJobTitle;
	}
	public String getProxyUserDeptName() {
		return proxyUserDeptName;
	}
	public void setProxyUserDeptName(String proxyUserDeptName) {
		this.proxyUserDeptName = proxyUserDeptName;
	}
	public String getAprMemberPhoto() {
		return aprMemberPhoto;
	}
	public void setAprMemberPhoto(String aprMemberPhoto) {
		this.aprMemberPhoto = aprMemberPhoto;
	}
	public String getProcessDate() {
		return processDate;
	}
	public void setProcessDate(String processDate) {
		this.processDate = processDate;
	}
	public String getAprType() {
		return aprType;
	}
	public void setAprType(String aprType) {
		this.aprType = aprType;
	}
	public String getAprMemberId() { return aprMemberId; }
	public void setAprMemberId(String aprMemberId) { this.aprMemberId = aprMemberId; }
	
	public String getAprMemberSn() {
		return aprMemberSn;
	}
	public void setAprMemberSn(String aprMemberSn) {
		this.aprMemberSn = aprMemberSn;
	}
}
