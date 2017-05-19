package egovframework.ezEKP.ezCircular.vo;

public class CircularConfigVO {
	/** 회람옵션ID */
	private int circularOptionId;
	
	/** 작성자 */
	private String memberId;
	
	/** 메일수신여부 */
	private int isMailReceive;
	
	/** 리스트 개수 */
	private int listCnt;
	
	/** 미리보기 */
	private int isPreview;
	
	/** 미리보기 리스트 값 */
	private String previewListValue;
	
	/** 미리보기 내용 값 */
	private String previewContentValue;
	
	/** 테넌트 ID */
	private int tenantId;

	public int getCircularOptionId() {
		return circularOptionId;
	}

	public void setCircularOptionId(int circularOptionId) {
		this.circularOptionId = circularOptionId;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public int getIsMailReceive() {
		return isMailReceive;
	}

	public void setIsMailReceive(int isMailReceive) {
		this.isMailReceive = isMailReceive;
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

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	
}
