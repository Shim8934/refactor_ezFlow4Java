package egovframework.ezEKP.ezNewPortal.vo;

public class PortalUserInfoVO {

	private String userName; //사용자이름
	private String userImg; //사용자 이미지 경로
	private String userId; //사용자 아이디
	private String userDeptName; //사용자가 속한 부서명
	private String userBirthday; //사용자 생일
	private boolean isSolar; //생일 양력 & 음력여부 (양력 true, 음력 false)
	
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserImg() {
		return userImg;
	}
	public void setUserImg(String userImg) {
		this.userImg = userImg;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserDeptName() {
		return userDeptName;
	}
	public void setUserDeptName(String userDeptName) {
		this.userDeptName = userDeptName;
	}
	public String getUserBirthday() {
		return userBirthday;
	}
	public void setUserBirthday(String userBirthday) {
		this.userBirthday = userBirthday;
	}
	
	public boolean isSolar() {
		return isSolar;
	}
	public void setSolar(boolean isSolar) {
		this.isSolar = isSolar;
	}
	
	@Override
	public String toString() {
		return "PortalUserInfoVO [userName=" + userName + ", userImg=" + userImg + ", userId=" + userId
				+ ", userDeptName=" + userDeptName + ", userBirthday=" + userBirthday + ", isSolar=" + isSolar + "]";
	}
	
}
