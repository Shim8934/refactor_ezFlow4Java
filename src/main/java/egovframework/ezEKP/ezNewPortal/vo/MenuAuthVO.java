package egovframework.ezEKP.ezNewPortal.vo;

public class MenuAuthVO {

	private int menuId; // 메뉴 아이디
	private String userId; // 권한 관련 사용자 아이디
	private String userName; // 사용자 이름
	private String userDeptName; // 사용자 부서 이름
	private int userType; // 사용자 or 부서 분리 -- 사용자(1), 부서(0), 직위(2), 직책(3), 권한그룹(4)
	private boolean accessYN; // 접근 가능(true), 접근 불가(false)
	private String subdeptPermitted; // 하위부서 허용 여부(Y/N)

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
	
	public int getUserType() {
		return userType;
	}

	public void setUserType(int userType) {
		this.userType = userType;
	}

	public boolean isAccessYN() {
		return accessYN;
	}

	public void setAccessYN(boolean accessYN) {
		this.accessYN = accessYN;
	}

	public String getSubdeptPermitted() {
		return subdeptPermitted;
	}

	public void setSubdeptPermitted(String subdeptPermitted) {
		this.subdeptPermitted = subdeptPermitted;
	}

	@Override
	public String toString() {
		return "MenuAuthVO [menuId=" + menuId + ", userId=" + userId + ", userName=" + userName + ", userDeptName=" + userDeptName + ", userType=" + userType + ", accessYN=" + accessYN + "]";
	}

}
