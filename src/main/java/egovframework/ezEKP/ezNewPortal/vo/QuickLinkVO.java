package egovframework.ezEKP.ezNewPortal.vo;

public class QuickLinkVO {

	private String quickLinkName; //퀵링크 이름
	private String linkType; //퀵링크 링크 유형
	private String linkTypeUrl; //퀵링크 유형 url
	private String url; //퀵링크 url
	
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
	
	@Override
	public String toString() {
		return "QuickLinkVO [quickLinkName=" + quickLinkName + ", linkType=" + linkType + ", linkTypeUrl=" + linkTypeUrl
				+ ", url=" + url + "]";
	}
	
	
}
