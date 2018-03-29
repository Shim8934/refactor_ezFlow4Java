package egovframework.ezEKP.ezPersonal.vo;

public class PersonalSliderImageVO {
	/** 슬라이드ID*/
	private String sliderID;
	/** 슬라이드이름*/
	private String sliderName;
	/** 슬라이드이름(다국어)*/
	private String sliderName2;
	/** 파일이름*/
	private String fileName;
	/** 이미지 경로*/
	private String imagePath;
	/** 수정한 사용자ID*/
	private String regUserID;
	/** 수정날짜*/
	private String regDate;
	/** 회사ID*/
	private String companyID;
	/** 사용여부*/
	private int isUse;
	/** 순서*/
	private int sn;
	public String getSliderID() {
		return sliderID;
	}
	public void setSliderID(String sliderID) {
		this.sliderID = sliderID;
	}
	public String getSliderName() {
		return sliderName;
	}
	public void setSliderName(String sliderName) {
		this.sliderName = sliderName;
	}
	public String getSliderName2() {
		return sliderName2;
	}
	public void setSliderName2(String sliderName2) {
		this.sliderName2 = sliderName2;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getImagePath() {
		return imagePath;
	}
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
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
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public int getIsUse() {
		return isUse;
	}
	public void setIsUse(int isUse) {
		this.isUse = isUse;
	}
	public int getSn() {
		return sn;
	}
	public void setSn(int sn) {
		this.sn = sn;
	}
}
