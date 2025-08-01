package egovframework.ezEKP.ezResource.vo;

public class ResGetItemListVO {
	/** 자원 아이디*/
	private int brd_ID;
	/** 자원 이름*/
	private String brd_Nm;
	/** 사용허가유무*/
	private String approveFlag;
	/** 정원 **/
	private String res_max_user_cnt;
	
	public String getRes_max_user_cnt() {
		return res_max_user_cnt;
	}
	public void setRes_max_user_cnt(String res_max_user_cnt) {
		this.res_max_user_cnt = res_max_user_cnt;
	}
	public int getBrd_ID() {
		return brd_ID;
	}
	public void setBrd_ID(int brd_ID) {
		this.brd_ID = brd_ID;
	}
	public String getBrd_Nm() {
		return brd_Nm;
	}
	public void setBrd_Nm(String brd_Nm) {
		this.brd_Nm = brd_Nm;
	}
	public String getApproveFlag() {
		return approveFlag;
	}
	public void setApproveFlag(String approveFlag) {
		this.approveFlag = approveFlag;
	}
}
