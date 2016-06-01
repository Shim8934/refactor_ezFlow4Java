package egovframework.ezEKP.ezCommunity.vo;

public class CommunityCOutApplicationVO {
	/** 커뮤니티ID*/
	String c_clubNo;
	/** 마스터ID*/
	String userID;
	/** 폐쇄 신청 일자 */
	String outDate;
	/** 폐쇄 사유(CLOB)*/
	String outReason;
	public String getC_clubNo() {
		return c_clubNo;
	}
	public void setC_clubNo(String c_clubNo) {
		this.c_clubNo = c_clubNo;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getOutDate() {
		return outDate;
	}
	public void setOutDate(String outDate) {
		this.outDate = outDate;
	}
	public String getOutReason() {
		return outReason;
	}
	public void setOutReason(String outReason) {
		this.outReason = outReason;
	}
}
