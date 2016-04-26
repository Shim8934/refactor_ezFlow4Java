package egovframework.ezEKP.ezResource.vo;

public class ResGetRepDateTimesVO {
	/** 자원 예약 게시판ID*/
	private String ownerID;
	/** 회사번호*/
	private String companyID;
	/** 순번*/
	private int num;
	
	public String getOwnerID() {
		return ownerID;
	}
	public void setOwnerID(String ownerID) {
		this.ownerID = ownerID;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
}
