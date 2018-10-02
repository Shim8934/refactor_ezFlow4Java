package egovframework.ezEKP.ezNewPortal.vo;

public class MenuAuthVO {

	private int menuId; //메뉴 아이디
	private String userId; //권한 관련 사용자 아이디
	private String userName; //사용자 이름
	private String userDeptName; //사용자 부서 이름
	private boolean isUser; //사용자 or 부서 분리 -- 사용자(true), 부서(false)
	private boolean accessYN; //접근 가능(true), 접근 불가(false)
	
	public int getMenuId() {
		return menuId;
	}
	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserDeptName() {
		return userDeptName;
	}
	public void setUserDeptName(String userDeptName) {
		this.userDeptName = userDeptName;
	}
	public boolean isUser() {
		return isUser;
	}
	public void setUser(boolean isUser) {
		this.isUser = isUser;
	}
	public boolean isAccessYN() {
		return accessYN;
	}
	public void setAccessYN(boolean accessYN) {
		this.accessYN = accessYN;
	}
	
	@Override
	public String toString() {
		return "MenuAuthVO [menuId=" + menuId + ", userId=" + userId + ", userName=" + userName + ", userDeptName="
				+ userDeptName + ", isUser=" + isUser + ", accessYN=" + accessYN + "]";
	}
	
}
