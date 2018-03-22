package egovframework.ezEKP.ezJournal.vo;

public class JournalEnvVO {

	/* 보여줄 리스트 수 */
	private String listCnt;
	/* 미리보기설정 (N(없음), W(세로분할), H(가로분할)) */
	private String viewenv;
	/* 아래쪽 본문 미리보기 영역 */
	private int previewWContent;
	/* 오른쪽 본문 미리보기 영역 */
	private int previewHContent;
	/* 수신일지 도착알림메일 여부 */
	private String recvAlert;
	/* 댓글알림메일 여부 */
	private String replyAlert;
	private String previewHcontent;
	private String previewWcontent;
	
	public String getPreviewHcontent() {
		return previewHcontent;
	}
	public void setPreviewHcontent(String previewHcontent) {
		this.previewHcontent = previewHcontent;
	}
	public String getPreviewWcontent() {
		return previewWcontent;
	}
	public void setPreviewWcontent(String previewWcontent) {
		this.previewWcontent = previewWcontent;
	}
	public String getListCnt() {
		return listCnt;
	}
	public void setListCnt(String listCnt) {
		this.listCnt = listCnt;
	}
	public String getViewenv() {
		return viewenv;
	}
	public void setViewenv(String viewenv) {
		this.viewenv = viewenv;
	}
	public int getPreviewWContent() {
		return previewWContent;
	}
	public void setPreviewWContent(int previewWContent) {
		this.previewWContent = previewWContent;
	}
	public int getPreviewHContent() {
		return previewHContent;
	}
	public void setPreviewHContent(int previewHContent) {
		this.previewHContent = previewHContent;
	}
	public String getRecvAlert() {
		return recvAlert;
	}
	public void setRecvAlert(String recvAlert) {
		this.recvAlert = recvAlert;
	}
	public String getReplyAlert() {
		return replyAlert;
	}
	public void setReplyAlert(String replyAlert) {
		this.replyAlert = replyAlert;
	}
}