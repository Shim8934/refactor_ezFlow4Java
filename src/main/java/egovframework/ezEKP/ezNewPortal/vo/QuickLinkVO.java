package egovframework.ezEKP.ezNewPortal.vo;

public class QuickLinkVO {

	private String quickLinkName; //퀵링크 이름
	private String quickLinkName2; //퀵링크 이름 영어
	private String quickLinkName3; //퀵링크 이름 일본어
	private String quickLinkName4; //퀵링크 이름 중국어
	private String quickLinkName5; //퀵링크 이름 베트남어
	private String quickLinkName6; //퀵링크 이름 인도네시아어
	private String linkType; //퀵링크 링크 유형
	private String linkTypeUrl; //퀵링크 유형 url
	private String url; //퀵링크 url
	private String quickSize; // 퀵링크 사이즈
	private String viewflag;
	
	public String getQuickLinkName() {
		return quickLinkName;
	}
	public void setQuickLinkName(String quickLinkName) {
		this.quickLinkName = quickLinkName;
	}
	public String getLinkType() {
		return linkType;
	}
	public void setLinkType(String linkType) {
		this.linkType = linkType;
	}
	public String getLinkTypeUrl() {
		return linkTypeUrl;
	}
	public void setLinkTypeUrl(String linkTypeUrl) {
		this.linkTypeUrl = linkTypeUrl;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getQuickSize() {
		return quickSize;
	}
	public void setQuickSize(String quickSize) {
		this.quickSize = quickSize;
	}
	
	public String getViewflag() {
		return viewflag;
	}
	public void setViewflag(String viewflag) {
		this.viewflag = viewflag;
	}
	public String getQuickLinkName2() {
		return quickLinkName2;
	}
	public void setQuickLinkName2(String quickLinkName2) {
		this.quickLinkName2 = quickLinkName2;
	}
	public String getQuickLinkName3() {
		return quickLinkName3;
	}
	public void setQuickLinkName3(String quickLinkName3) {
		this.quickLinkName3 = quickLinkName3;
	}
	public String getQuickLinkName4() {
		return quickLinkName4;
	}
	public void setQuickLinkName4(String quickLinkName4) {
		this.quickLinkName4 = quickLinkName4;
	}
	public String getQuickLinkName5() {
		return quickLinkName5;
	}
	public void setQuickLinkName5(String quickLinkName5) {
		this.quickLinkName5 = quickLinkName5;
	}
	public String getQuickLinkName6() {
		return quickLinkName6;
	}
	public void setQuickLinkName6(String quickLinkName6) {
		this.quickLinkName6 = quickLinkName6;
	}
	
	@Override
	public String toString() {
		return "QuickLinkVO [quickLinkName=" + quickLinkName + ", linkType=" + linkType + ", linkTypeUrl=" + linkTypeUrl
				+ ", url=" + url + ", quicksize=" + quickSize + ", viewflag=" + viewflag + "]";
	}
}
