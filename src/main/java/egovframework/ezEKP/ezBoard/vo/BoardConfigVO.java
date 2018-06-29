package egovframework.ezEKP.ezBoard.vo;

public class BoardConfigVO {
	/** 유저아이디*/
	private String userId; 
	/** 보여줄 리스트 수*/
	private int listCount; 
	/** OFF, W, H 표시*/
	private String preview; 
	/** 아래쪽 리스트*/
	private int previewWList; 
	/** 아래쪽 미리보기 영역*/
	private int previewWContent; 
	/** 오른쪽 리스트*/
	private int previewHList; 
	/** 오른쪽 미리보기 영역*/
	private int previewHContent; 
	/** 게시글 총 갯수*/
	private int totalCnt;
	/** 페이지 수*/
	private int pageCnt;
	/** tenant*/
	private int tenantID;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getListCount() {
		return listCount;
	}
	public void setListCount(int listCount) {
		this.listCount = listCount;
	}
	public String getPreview() {
		return preview;
	}
	public void setPreview(String preview) {
		this.preview = preview;
	}
	public int getPreviewWList() {
		return previewWList;
	}
	public void setPreviewWList(int previewWList) {
		this.previewWList = previewWList;
	}
	public int getPreviewWContent() {
		return previewWContent;
	}
	public void setPreviewWContent(int previewWContent) {
		this.previewWContent = previewWContent;
	}
	public int getPreviewHList() {
		return previewHList;
	}
	public void setPreviewHList(int previewHList) {
		this.previewHList = previewHList;
	}
	public int getPreviewHContent() {
		return previewHContent;
	}
	public void setPreviewHContent(int previewHContent) {
		this.previewHContent = previewHContent;
	}
	public int getTotalCnt() {
		return totalCnt;
	}
	public void setTotalCnt(int totalCnt) {
		this.totalCnt = totalCnt;
	}
	public int getPageCnt() {
		return pageCnt;
	}
	public void setPageCnt(int pageCnt) {
		this.pageCnt = pageCnt;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	
}
