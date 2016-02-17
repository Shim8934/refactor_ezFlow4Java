package egovframework.ezEKP.ezBoard.vo;

public class BoardConfigVO {
	private String userId; //유저아이디
	private int listCount; // 보여줄 리스트 수
	private String preview; // OFF , W, H 표시
	private int previewWlist; // 오른쪽 리스트
	private int previewWContent; // 오른쪽 미리보기 영역
	private int previewHlist; // 아래쪽 리스트
	private int previewHContent; // 아래쪽 미리보기 영역
	
	public BoardConfigVO() {
		
	}

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

	public int getPreviewWlist() {
		return previewWlist;
	}

	public void setPreviewWlist(int previewWlist) {
		this.previewWlist = previewWlist;
	}

	public int getPreviewWContent() {
		return previewWContent;
	}

	public void setPreviewWContent(int previewWContent) {
		this.previewWContent = previewWContent;
	}

	public int getPreviewHlist() {
		return previewHlist;
	}

	public void setPreviewHlist(int previewHlist) {
		this.previewHlist = previewHlist;
	}

	public int getPreviewHContent() {
		return previewHContent;
	}

	public void setPreviewHContent(int previewHContent) {
		this.previewHContent = previewHContent;
	}
}
