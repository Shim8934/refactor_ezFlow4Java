package egovframework.ezEKP.ezResource.vo;

public class ResAdminVO {
	/** 게시판ID*/
	private String brdID;
	/** 게시판명*/
	private String brdNm;
	/** 영문 게시판명*/
	private String brdNm2;
	/** 담당자 ID*/
	private String ownerID;
	/** 담당자명*/
	private String ownerNm;
	/** 영문 담당자명*/
	private String ownerNm2;
	/** 담당자 메일주소*/
	private String mailAddress;
	
	public String getBrdID() {
		return brdID;
	}
	public void setBrdID(String brdID) {
		this.brdID = brdID;
	}
	public String getBrdNm() {
		return brdNm;
	}
	public void setBrdNm(String brdNm) {
		this.brdNm = brdNm;
	}
	public String getBrdNm2() {
		return brdNm2;
	}
	public void setBrdNm2(String brdNm2) {
		this.brdNm2 = brdNm2;
	}
	public String getOwnerID() {
		return ownerID;
	}
	public void setOwnerID(String ownerID) {
		this.ownerID = ownerID;
	}
	public String getOwnerNm() {
		return ownerNm;
	}
	public void setOwnerNm(String ownerNm) {
		this.ownerNm = ownerNm;
	}
	public String getOwnerNm2() {
		return ownerNm2;
	}
	public void setOwnerNm2(String ownerNm2) {
		this.ownerNm2 = ownerNm2;
	}
	public String getMailAddress() {
		return mailAddress;
	}
	public void setMailAddress(String mailAddress) {
		this.mailAddress = mailAddress;
	}
	
}
