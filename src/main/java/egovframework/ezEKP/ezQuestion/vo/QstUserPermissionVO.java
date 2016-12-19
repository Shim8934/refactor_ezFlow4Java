package egovframework.ezEKP.ezQuestion.vo;

public class QstUserPermissionVO {
	/** 게시판ID*/
	int brdID;
	/** 글 번호*/
	int itemNo;
	/** 유저ID*/
	String userID;
	/** 기명여부(무기명:0, 기명:1)*/
	String publicFlg;
	/** 조사결과공개여부(공걔:1, 비공개:0)*/
	String publicResultFlg;
	/** 중복응답허용여부(비허용:0, 허용:1)*/
	String multiResponseFlg;
	/** 마감여부(즉시마감:1)*/
	String endFlg;
	/** 대상자설정여부(선정:1, 전체:0)*/
	String responseRange;
	
	public int getBrdID() {
		return brdID;
	}
	public void setBrdID(int brdID) {
		this.brdID = brdID;
	}
	public int getItemNo() {
		return itemNo;
	}
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getPublicFlg() {
		return publicFlg;
	}
	public void setPublicFlg(String publicFlg) {
		this.publicFlg = publicFlg;
	}
	public String getPublicResultFlg() {
		return publicResultFlg;
	}
	public void setPublicResultFlg(String publicResultFlg) {
		this.publicResultFlg = publicResultFlg;
	}
	public String getMultiResponseFlg() {
		return multiResponseFlg;
	}
	public void setMultiResponseFlg(String multiResponseFlg) {
		this.multiResponseFlg = multiResponseFlg;
	}
	public String getEndFlg() {
		return endFlg;
	}
	public void setEndFlg(String endFlg) {
		this.endFlg = endFlg;
	}
	public String getResponseRange() {
		return responseRange;
	}
	public void setResponseRange(String responseRange) {
		this.responseRange = responseRange;
	}
}
