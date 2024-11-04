package egovframework.ezMobile.ezApprovalG.vo;

public class MApprovalGLeftVO {
	/** 회사아이디*/
	private String companyId;
	/** 테넌트아이디*/
	private int tenantId;
	/** 유저아이디*/
	private String userId;
	/** 결재할문서갯수*/
	private int aprDoCount;
	/** 결재진행문서갯수*/
	private int aprIngCount;
	/** 완료한문서갯수*/
	private int aprEndCount;
	/** 기안한문서갯수*/
	private int aprDraftCount;
	/** 공유결재문서갯수*/
	private int aprShareCount;
	/** 공람할문서갯수*/
	private int gongRamCount;
	/** 공람완료문서갯수*/
	private int gongRamEndCount;
	/** 반송된문서갯수*/
	private int aprBanCount;
	/** 보낸공람문서갯수*/
	private int gongRamSendCount;
	
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getAprDoCount() {
		return aprDoCount;
	}
	public void setAprDoCount(int aprDoCount) {
		this.aprDoCount = aprDoCount;
	}
	public int getAprIngCount() {
		return aprIngCount;
	}
	public void setAprIngCount(int aprIngCount) {
		this.aprIngCount = aprIngCount;
	}
	public int getAprEndCount() {
		return aprEndCount;
	}
	public void setAprEndCount(int aprEndCount) {
		this.aprEndCount = aprEndCount;
	}
	public int getAprDraftCount() {
		return aprDraftCount;
	}
	public void setAprDraftCount(int aprDraftCount) {
		this.aprDraftCount = aprDraftCount;
	}
	public int getAprShareCount() {
		return aprShareCount;
	}
	public void setAprShareCount(int aprShareCount) {
		this.aprShareCount = aprShareCount;
	}
	public int getGongRamCount() {
		return gongRamCount;
	}
	public void setGongRamCount(int gongRamCount) {
		this.gongRamCount = gongRamCount;
	}
	public int getGongRamEndCount() {
		return gongRamEndCount;
	}
	public void setGongRamEndCount(int gongRamEndCount) {
		this.gongRamEndCount = gongRamEndCount;
	}
	public int getAprBanCount() { return aprBanCount; }
	public void setAprBanCount(int aprBanCount) { this.aprBanCount = aprBanCount; }
	
	public int getGongRamSendCount() {
		return gongRamSendCount;
	}
	public void setGongRamSendCount(int gongRamSendCount) {
		this.gongRamSendCount = gongRamSendCount;
	}
	
}
