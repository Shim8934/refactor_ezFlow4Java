package egovframework.ezEKP.ezAddress.vo;

public class AddressVO {	
	/** 우편번호 코드*/
	private String zipcode;
	/** 우편번호 시*/
	private String sido;
	/** 우편번호 구분*/
	private String gugun;
	/** 우편번호 동*/
	private String dong;
	/** 우편번호 번지*/
	private String bunji;
	
	
	public String getZipcode() {
		return zipcode;
	}
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	public String getSido() {
		return sido;
	}
	public void setSido(String sido) {
		this.sido = sido;
	}	
	public String getGugun() {
		return gugun;
	}
	public void setGugun(String gugun) {
		this.gugun = gugun;
	}
	public String getDong() {
		return dong;
	}
	public void setDong(String dong) {
		this.dong = dong;
	}
	public String getBunji() {
		return bunji;
	}
	public void setBunji(String bunji) {
		this.bunji = bunji;
	}
	
	
}
