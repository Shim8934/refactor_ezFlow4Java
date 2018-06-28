package egovframework.ezEKP.ezPortal.vo;

public class PortalTBLUserInfoVO {
	/** 유저 아이디*/
	private String userID;
	/** 아이디*/
	private String uID;
	/** 스킨 번호*/
	private int skinNum;
	/** 스킨 기본 이미지*/
	private String skinDefaultImage;
	/** 스킨 기본 색상*/
	private String skinDefaultColor;
	/** 포탈 아이디*/
	private String portalUID;
	/** 포탈 스킨 번호*/
	private int portalSkinNum;
	/** 언어값*/
	private String lang;
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getuID() {
		return uID;
	}
	public void setuID(String uID) {
		this.uID = uID;
	}
	public int getSkinNum() {
		return skinNum;
	}
	public void setSkinNum(int skinNum) {
		this.skinNum = skinNum;
	}
	public String getSkinDefaultImage() {
		return skinDefaultImage;
	}
	public void setSkinDefaultImage(String skinDefaultImage) {
		this.skinDefaultImage = skinDefaultImage;
	}
	public String getSkinDefaultColor() {
		return skinDefaultColor;
	}
	public void setSkinDefaultColor(String skinDefaultColor) {
		this.skinDefaultColor = skinDefaultColor;
	}
	public String getPortalUID() {
		return portalUID;
	}
	public void setPortalUID(String portalUID) {
		this.portalUID = portalUID;
	}
	public int getPortalSkinNum() {
		return portalSkinNum;
	}
	public void setPortalSkinNum(int portalSkinNum) {
		this.portalSkinNum = portalSkinNum;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
}	
