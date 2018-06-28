package egovframework.ezEKP.ezCommon.vo;

public class ApprovPWDVO {
	/** 유저아이디*/
	private String userID;
	/** 암호설정여부*/
	private String flag;
	/** 암호*/
	private String pwd;
	/** 암호타입*/
	private String pwdType;
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getPwdType() {
		return pwdType;
	}
	public void setPwdType(String pwdType) {
		this.pwdType = pwdType;
	}

}
