package egovframework.ezEKP.ezSchedule.vo;

// 2025-03-21 조수빈 - 임원의 이름, 다국어 이름 vo
public class ScheSecretaryVO {
	// 임원의 ID
	private String userID;
	// 임원의 이름
	private String userName;
	// 임원의 다국어 이름
	private String userName2;
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserName2() {
		return userName2;
	}
	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}
}
