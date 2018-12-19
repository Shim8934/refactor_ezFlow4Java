package egovframework.ezEKP.ezNewPortal.vo;

public class PortletNameVO {

	private int portletId; //포틀릿 아이디
	private int menuId; //포틀릿과 연관된 메뉴 아이디
	private String portletLang; //포틀릿명 언어
	private String portletName; //포틀릿명
	
	public int getPortletId() {
		return portletId;
	}
	public void setPortletId(int portletId) {
		this.portletId = portletId;
	}
	public int getMenuId() {
		return menuId;
	}
	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}
	public String getPortletLang() {
		return portletLang;
	}
	public void setPortletLang(String portletLang) {
		this.portletLang = portletLang;
	}
	public String getPortletName() {
		return portletName;
	}
	public void setPortletName(String portletName) {
		this.portletName = portletName;
	}
	
	@Override
	public String toString() {
		return "PortletNameVO [portletId=" + portletId + ", menuId=" + menuId + ", portletLang=" + portletLang
				+ ", portletName=" + portletName + "]";
	}
	
}
