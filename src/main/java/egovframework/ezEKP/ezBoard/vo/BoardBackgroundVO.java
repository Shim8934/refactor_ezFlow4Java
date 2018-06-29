package egovframework.ezEKP.ezBoard.vo;

public class BoardBackgroundVO {
	/** 백그라운드ID*/
	private String backgroundID; 
	/** 원본파일이름*/
	private String orgFileName; 
	/** 저장파이리름*/
	private String saveFileName; 
	/** 등록자ID*/
	private String regUserID; 
	/** 등록일*/
	private String regDate; 
	/** 사용여부*/
	private String isUse; 
	/** 순서*/
	private String sn; 
	/** 길이*/
	private String width;
	/** 높이*/
	private String height;
	/** 타입*/
	private String type;
	/** tenantid*/
	private int tenantID;

	public String getBackgroundID() {
		return backgroundID;
	}
	public void setBackgroundID(String backgroundID) {
		this.backgroundID = backgroundID;
	}
	public String getOrgFileName() {
		return orgFileName;
	}
	public void setOrgFileName(String orgFileName) {
		this.orgFileName = orgFileName;
	}
	public String getSaveFileName() {
		return saveFileName;
	}
	public void setSaveFileName(String saveFileName) {
		this.saveFileName = saveFileName;
	}
	public String getRegUserID() {
		return regUserID;
	}
	public void setRegUserID(String regUserID) {
		this.regUserID = regUserID;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	public String getWidth() {
		return width;
	}
	public void setWidth(String width) {
		this.width = width;
	}
	public String getHeight() {
		return height;
	}
	public void setHeight(String height) {
		this.height = height;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	
}
