package egovframework.ezEKP.ezPortal.vo;

public class PortalMyPortalListVO {
	/** 아이디*/
	private String uID_;
	/** 이름*/
	private String displayName;
	/** 다국어 이름*/
	private String displayName2;
	
	public String getuID_() {
		return uID_;
	}
	public void setuID_(String uID_) {
		this.uID_ = uID_;
	}
	public String getDisplayName() {
		return displayName;
	}
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
	public String getDisplayName2() {
		return displayName2;
	}
	public void setDisplayName2(String displayName2) {
		this.displayName2 = displayName2;
	}
}
