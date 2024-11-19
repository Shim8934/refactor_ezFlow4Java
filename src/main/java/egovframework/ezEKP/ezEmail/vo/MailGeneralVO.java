package egovframework.ezEKP.ezEmail.vo;

public class MailGeneralVO {
	
	private String listCount;
	
	private String refreshInterval;
	
	private String keepDeleteLength;
	
	private String previewMode;
	
	private String previewWList;
	
	private String previewWContent;
	
	private String previewHList;
	
	private String previewHContent;
	
	private String mailSenderNm;
	
	private String previewSubTree;
	
	private String previewMailImage;

	private String previewMail;

	private String textOption;
	
	private String mailSearchPeriod;
	
	private String defaultCursorPosition; // 메일쓰기창 기본 커서 위치/ recipient: 받는사람, content : 내용
	
	private String defaultSeparateSend; // 개별발신 기본 사용 여부 Y : 개별발신, N : 사용안함
	
	private String mailSendResult;
	
	private String editorFontFamily;
	
	private String editorFontSize;
	
	public String getMailSendResult() {
		return mailSendResult;
	}

	public void setMailSendResult(String mailSendResult) {
		this.mailSendResult = mailSendResult;
	}

	public String getMailSearchPeriod() {
		return mailSearchPeriod;
	}

	public void setMailSearchPeriod(String mailSearchPeriod) {
		this.mailSearchPeriod = mailSearchPeriod;
	}

	public String getListCount() {
		return listCount;
	}
	
	public void setListCount(String listCount) {
		this.listCount = listCount;
	}
	
	public String getRefreshInterval() {
		return refreshInterval;
	}
	
	public void setRefreshInterval(String refreshInterval) {
		this.refreshInterval = refreshInterval;
	}

	public String getKeepDeleteLength() {
		return keepDeleteLength;
	}
	
	public void setKeepDeleteLength(String keepDeleteLength) {
		this.keepDeleteLength = keepDeleteLength;
	}
	
	public String getPreviewMode() {
		return previewMode;
	}
	
	public void setPreviewMode(String previewMode) {
		previewMode = previewMode != null ? previewMode.trim() : previewMode;
		
		this.previewMode = previewMode;
	}
	
	public String getPreviewWList() {
		return previewWList;
	}
	
	public void setPreviewWList(String previewWList) {
		this.previewWList = previewWList;
	}
	
	public String getPreviewWContent() {
		return previewWContent;
	}
	
	public void setPreviewWContent(String previewWContent) {
		this.previewWContent = previewWContent;
	}
	
	public String getPreviewHList() {
		return previewHList;
	}
	
	public void setPreviewHList(String previewHList) {
		this.previewHList = previewHList;
	}
	
	public String getPreviewHContent() {
		return previewHContent;
	}
	
	public void setPreviewHContent(String previewHContent) {
		this.previewHContent = previewHContent;
	}
	
	public String getMailSenderNm() {
		return mailSenderNm;
	}
	
	public void setMailSenderNm(String mailSenderNm) {
		this.mailSenderNm = mailSenderNm;
	}
	
	public String getPreviewSubTree() {
		return previewSubTree;
	}

	public void setPreviewSubTree(String previewSubTree) {
		this.previewSubTree = previewSubTree;
	}
	
	public String getPreviewMailImage() {
		return previewMailImage;
	}
	
	public void setPreviewMailImage(String previewMailImage) {
		this.previewMailImage = previewMailImage;
	}

	public String getPreviewMail() {
		return previewMail;
	}

	public void setPreviewMail(String previewMail) {
		this.previewMail = previewMail;
	}
	
	public String getTextOption() {
		return textOption;
	}
	
	public void setTextOption(String textOption) {
		this.textOption = textOption;
	}
	
	public String getDefaultCursorPosition() {
		return defaultCursorPosition;
	}
	
	public void setDefaultCursorPosition(String defaultCursorPosition) {
		this.defaultCursorPosition = defaultCursorPosition;
	}
	
	public String getDefaultSeparateSend() {
		return defaultSeparateSend;
	}
	
	public void setDefaultSeparateSend(String defaultSeparateSend) {
		this.defaultSeparateSend = defaultSeparateSend;
	}

	public String getEditorFontFamily() {
		return editorFontFamily;
	}
	public void setEditorFontFamily(String editorFontFamily) {
		this.editorFontFamily = editorFontFamily;
	}
	public String getEditorFontSize() {
		return editorFontSize;
	}
	public void setEditorFontSize(String editorFontSize) {
		this.editorFontSize = editorFontSize;
	}

	public String toString() {
		return "listCount=" + listCount + ",refreshInterval=" + refreshInterval + ",keepDeleteLength=" + keepDeleteLength
				+ ",previewMode=" + previewMode + ",previewWList=" + previewWList + ",previewWContent=" + previewWContent
				+ ",previewHList=" + previewHList + ",previewHContent=" + previewHContent + ",mailSenderNm=" + mailSenderNm
				+ ",previewSubtree=" + previewSubTree + ",previewmailImage=" + previewMailImage + ",previewMail=" + previewMail + ",textOption=" + textOption
				+ ",mailSearchPeriod=" + mailSearchPeriod + ",defaultCursorPosition=" + defaultCursorPosition + ",defaultSeparateSend=" + defaultSeparateSend
				+ ",mailSendResult=" + mailSendResult + ",editorFontFamily=" + editorFontFamily + ",editorFontSize=" + editorFontSize ;
	}

}
