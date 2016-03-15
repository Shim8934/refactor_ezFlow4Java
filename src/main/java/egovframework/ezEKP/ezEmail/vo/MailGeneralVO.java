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
	
	public String toString() {
		return "listCount=" + listCount + ",refreshInterval=" + refreshInterval + ",keepDeleteLength=" + keepDeleteLength
				+ ",previewMode=" + previewMode + ",previewWList=" + previewWList + ",previewWContent=" + previewWContent
				+ ",previewHList=" + previewHList + ",previewHContent=" + previewHContent + ",mailSenderNm=" + mailSenderNm;
	}
}
