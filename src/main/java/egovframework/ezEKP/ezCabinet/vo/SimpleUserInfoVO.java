package egovframework.ezEKP.ezCabinet.vo;

public class SimpleUserInfoVO {
	private String userName;
	private String userId;
	
	public SimpleUserInfoVO() {}
	
	public SimpleUserInfoVO(String userName, String userId) {
		this.userId   = userId;
		this.userName = userName;
	}
	
	public String getUserName() {
		return userName;
	}
	
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
}
