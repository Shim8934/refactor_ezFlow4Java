package egovframework.ezEKP.ezNewPortal.vo;

public class MenuInfoVO {

	private int menuId; //메뉴 아이디
	private int menuOrder; //메뉴 순서
	private String menuName; //메뉴 이름
	private String menuUrl; //메뉴 url
	private boolean isGeneral; //메뉴 타입 : 기본(true), 추가(false)
	private String iconUrl; //아이콘 이미지 경로
	private int defaultOrder; //메뉴 기본 순서(기본 제공)
	private boolean menuUsed; //메뉴 사용 여부 : 사용(true), 미사용(false)
	private String companyLang; //회사 사용 언어
	
	public int getMenuId() {
		return menuId;
	}
	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}
	public int getMenuOrder() {
		return menuOrder;
	}
	public void setMenuOrder(int menuOrder) {
		this.menuOrder = menuOrder;
	}
	public String getMenuName() {
		return menuName;
	}
	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}
	public String getMenuUrl() {
		return menuUrl;
	}
	public void setMenuUrl(String menuUrl) {
		this.menuUrl = menuUrl;
	}
	public boolean isGeneral() {
		return isGeneral;
	}
	public void setGeneral(boolean isGeneral) {
		this.isGeneral = isGeneral;
	}
	public String getIconUrl() {
		return iconUrl;
	}
	public void setIconUrl(String iconUrl) {
		this.iconUrl = iconUrl;
	}
	public int getDefaultOrder() {
		return defaultOrder;
	}
	public void setDefaultOrder(int defaultOrder) {
		this.defaultOrder = defaultOrder;
	}
	public boolean isMenuUsed() {
		return menuUsed;
	}
	public void setMenuUsed(boolean menuUsed) {
		this.menuUsed = menuUsed;
	}
	public String getCompanyLang() {
		return companyLang;
	}
	public void setCompanyLang(String companyLang) {
		this.companyLang = companyLang;
	}
	
	@Override
	public String toString() {
		return "MenuInfoVO [menuId=" + menuId + ", menuOrder=" + menuOrder + ", menuName=" + menuName + ", menuUrl="
				+ menuUrl + ", isGeneral=" + isGeneral + ", iconUrl=" + iconUrl + ", defaultOrder=" + defaultOrder
				+ ", menuUsed=" + menuUsed + ", companyLang=" + companyLang + "]";
	}
}
