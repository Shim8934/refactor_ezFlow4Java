package egovframework.ezEKP.ezQuestion.vo;

public class UserPermissionVO {
	/** 게시판ID*/
	int brdId;
	/** 글 번호*/
	int itemNo;
	/** 유저ID*/
	String userId;
	/** 기명여부*/
	String publicFlg;
	/** 결과공개*/
	String publicResultFlg;
	/** */
	String multiResponseFlg;
	/** */
	String endFlg;
	/** */
	String responseRange;
	/** */
	int responseCnt;
	public int getBrdId() {
		return brdId;
	}
	public void setBrdId(int brdId) {
		this.brdId = brdId;
	}
	public int getItemNo() {
		return itemNo;
	}
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
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
	public int getResponseCnt() {
		return responseCnt;
	}
	public void setResponseCnt(int responseCnt) {
		this.responseCnt = responseCnt;
	}
	@Override
	public String toString() {
		return "UserPermissionVO [brdId=" + brdId + ", itemNo=" + itemNo
				+ ", userId=" + userId + ", publicFlg=" + publicFlg
				+ ", publicResultFlg=" + publicResultFlg
				+ ", multiResponseFlg=" + multiResponseFlg + ", endFlg="
				+ endFlg + ", responseRange=" + responseRange
				+ ", responseCnt=" + responseCnt + "]";
	}
	
}
