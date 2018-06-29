package egovframework.ezEKP.ezCircular.vo;

public class CircularConfigVO {
	/** 회람옵션ID */
	private int circularOptionID;
	/** 작성자 */
	private String memberID;
	/** 리스트 개수 */
	private int listCnt;
	/** 미리보기 */
	private int isPreview;
	/** 미리보기 리스트 값 */
	private String previewListValue;
	/** 미리보기 내용 값 */
	private String previewContentValue;
	/** 테넌트 ID */
	private int tenantID;
	
	public int getCircularOptionID() {
		return circularOptionID;
	}
	public void setCircularOptionID(int circularOptionID) {
		this.circularOptionID = circularOptionID;
	}
	public String getMemberID() {
		return memberID;
	}
	public void setMemberID(String memberID) {
		this.memberID = memberID;
	}
	public int getListCnt() {
		return listCnt;
	}
	public void setListCnt(int listCnt) {
		this.listCnt = listCnt;
	}
	public int getIsPreview() {
		return isPreview;
	}
	public void setIsPreview(int isPreview) {
		this.isPreview = isPreview;
	}
	public String getPreviewListValue() {
		return previewListValue;
	}
	public void setPreviewListValue(String previewListValue) {
		this.previewListValue = previewListValue;
	}
	public String getPreviewContentValue() {
		return previewContentValue;
	}
	public void setPreviewContentValue(String previewContentValue) {
		this.previewContentValue = previewContentValue;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
}
