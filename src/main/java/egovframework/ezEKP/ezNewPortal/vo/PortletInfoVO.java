package egovframework.ezEKP.ezNewPortal.vo;

public class PortletInfoVO {

	private int portletId; //포틀릿 아이디
	private int portletOrder; //포틀릿 순서
	private String portletName; //포틀릿명
	private int menuId; //포틀릿과 연결된 메뉴 아이디
	private String portletUrl; //포틀릿 경로
	private boolean isGeneral; //포틀릿 타입 : 기본(true), 추가(false)
	private int defaultOrder; //제공된 포틀릿 기본 순서
	private int portletCategory; //게시판(0), 메일(1), 결재(2), 외부링크(3)
	private String connectionUrl; //포틀릿 연결 url
	private boolean portletUsed; //포틀릿 사용 여부 : 사용(true), 사용안함(false)
	private String portletBoardId; // 포틀릿 연결 게시판 id
	
	public int getPortletId() {
		return portletId;
	}
	public void setPortletId(int portletId) {
		this.portletId = portletId;
	}
	public int getPortletOrder() {
		return portletOrder;
	}
	public void setPortletOrder(int portletOrder) {
		this.portletOrder = portletOrder;
	}
	public String getPortletName() {
		return portletName;
	}
	public void setPortletName(String portletName) {
		this.portletName = portletName;
	}
	public int getMenuId() {
		return menuId;
	}
	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}
	public String getPortletUrl() {
		return portletUrl;
	}
	public void setPortletUrl(String portletUrl) {
		this.portletUrl = portletUrl;
	}
	public boolean isGeneral() {
		return isGeneral;
	}
	public void setGeneral(boolean isGeneral) {
		this.isGeneral = isGeneral;
	}
	public int getDefaultOrder() {
		return defaultOrder;
	}
	public void setDefaultOrder(int defaultOrder) {
		this.defaultOrder = defaultOrder;
	}
	public int getPortletCategory() {
		return portletCategory;
	}
	public void setPortletCategory(int portletCategory) {
		this.portletCategory = portletCategory;
	}
	public String getConnectionUrl() {
		return connectionUrl;
	}
	public void setConnectionUrl(String connectionUrl) {
		this.connectionUrl = connectionUrl;
	}
	public boolean isPortletUsed() {
		return portletUsed;
	}
	public void setPortletUsed(boolean portletUsed) {
		this.portletUsed = portletUsed;
	}
	public String getPortletBoardId() {
		return portletBoardId;
	}
	public void setPortletBoardId(String portletBoardId) {
		this.portletBoardId = portletBoardId;
	}
	
	@Override
	public String toString() {
		return "PortletInfoVO [portletId=" + portletId + ", portletOrder=" + portletOrder + ", portletName="
				+ portletName + ", menuId=" + menuId + ", portletUrl=" + portletUrl + ", isGeneral=" + isGeneral
				+ ", defaultOrder=" + defaultOrder + ", portletCategory=" + portletCategory + ", connectionUrl="
				+ connectionUrl + ", portletUsed=" + portletUsed + ", portletBoardId=" + portletBoardId + "]";
	}
}
