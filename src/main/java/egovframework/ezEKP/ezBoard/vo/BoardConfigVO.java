package egovframework.ezEKP.ezBoard.vo;

public class BoardConfigVO {
	private String userId; //유저아이디
	private int listCount; // 보여줄 리스트 수
	private String preview; // OFF , W, H 표시
	private int previewWList; // 오른쪽 리스트
	private int previewWContent; // 오른쪽 미리보기 영역
	private int previewHList; // 아래쪽 리스트
	private int previewHContent; // 아래쪽 미리보기 영역
	/** 게시글 총 갯수*/
	private int totalCnt;
	/** 페이지 수*/
	private int pageCnt;
	
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
	
}
