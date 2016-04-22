package egovframework.ezEKP.ezResource.vo;

public class ResGetItemListVO {
	/** 자원 아이디*/
	private int brdID;
	/** 자원 이름*/
	private String brdNm;
	/** 사용허가유무*/
	private String approveFlag;
	
	public int getBrdID() {
		return brdID;
	}
	public void setBrdID(int brdID) {
		this.brdID = brdID;
	}
	public String getBrdNm() {
		return brdNm;
	}
	public void setBrdNm(String brdNm) {
		this.brdNm = brdNm;
	}
	public String getApproveFlag() {
		return approveFlag;
	}
	public void setApproveFlag(String approveFlag) {
		this.approveFlag = approveFlag;
	}
}
