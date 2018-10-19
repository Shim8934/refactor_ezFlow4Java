package egovframework.ezEKP.ezNewPortal.vo;

public class PortletNameInfoVO {
	private int portletId; //포틀릿 아이디
	private String portletName; //포틀릿명
	private String portletLang; //포틀릿 언어
	
	public int getPortletId() {
		return portletId;
	}
	public void setPortletId(int portletId) {
		this.portletId = portletId;
	}
	public String getPortletName() {
		return portletName;
	}
	public void setPortletName(String portletName) {
		this.portletName = portletName;
	}
	public String getPortletLang() {
		return portletLang;
	}
	public void setPortletLang(String portletLang) {
		this.portletLang = portletLang;
	}
	
	@Override
	public String toString() {
		return "PortletNameInfoVO [portletId=" + portletId + ", portletName="
				+ portletName + ", portletLang=" + portletLang + "]";
	}
}
