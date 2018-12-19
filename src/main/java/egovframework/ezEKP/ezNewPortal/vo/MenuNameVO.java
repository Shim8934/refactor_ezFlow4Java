package egovframework.ezEKP.ezNewPortal.vo;

public class MenuNameVO {

	private int menuId; //메뉴 아이디
	private String menuLang; //메뉴명의 언어
	private String menuName; //메뉴명
	
	public int getMenuId() {
		return menuId;
	}
	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}
	public String getMenuLang() {
		return menuLang;
	}
	public void setMenuLang(String menuLang) {
		this.menuLang = menuLang;
	}
	public String getMenuName() {
		return menuName;
	}
	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}
	
	@Override
	public String toString() {
		return "MenuNameVO [menuId=" + menuId + ", menuLang=" + menuLang + ", menuName=" + menuName + "]";
	}
}
