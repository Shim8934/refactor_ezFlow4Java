package egovframework.ezEKP.ezAddress.vo;

public class AddressZipCodeVO {	
	private String zipCode;
	private String doro;
	private String jibun;
	
	public String getZipCode() {
		return zipCode;
	}
	public void setZipCode(String zipCode) {
		this.zipCode = zipCode;
	}
	public String getDoro() {
		return doro;
	}
	public void setDoro(String doro) {
		this.doro = doro;
	}
	public String getJibun() {
		return jibun;
	}
	public void setJibun(String jibun) {
		this.jibun = jibun;
	}
	
	@Override
	public String toString() {
		return "AddressZipCodeVO [zipCode=" + zipCode + ", doro=" + doro + ", jibun=" + jibun + "]";
	}
}
