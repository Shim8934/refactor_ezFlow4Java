package egovframework.ezEKP.ezSystem.vo;

public class CountryVO implements Comparable<CountryVO>{
	
	private String countryCode;
	private String countryCode2;
	private String startIP;
	private String endIP;
	private String startIPNumber;
	private String endIPNumber;
	private String countryName;
	private String imagePath;
	
	public String getCountryCode() {
		return countryCode;
	}
	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}
	public String getCountryCode2() {
		return countryCode2;
	}
	public void setCountryCode2(String countryCode2) {
		this.countryCode2 = countryCode2;
	}
	public String getStartIP() {
		return startIP;
	}
	public void setStartIP(String startIP) {
		this.startIP = startIP;
	}
	public String getEndIP() {
		return endIP;
	}
	public void setEndIP(String endIP) {
		this.endIP = endIP;
	}
	public String getStartIPNumber() {
		return startIPNumber;
	}
	public void setStartIPNumber(String startIPNumber) {
		this.startIPNumber = startIPNumber;
	}
	public String getEndIPNumber() {
		return endIPNumber;
	}
	public void setEndIPNumber(String endIPNumber) {
		this.endIPNumber = endIPNumber;
	}
	public String getCountryName() {
		return countryName;
	}
	public void setCountryName(String countryName) {
		this.countryName = countryName;
	}
	public String getImagePath() {
		return imagePath;
	}
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}
	
	@Override
	public String toString() {
		return "CountryVO [countryCode=" + countryCode + ", countryCode2="
				+ countryCode2 + ", startIP=" + startIP + ", endIP=" + endIP
				+ ", startIPNumber=" + startIPNumber + ", endIPNumber="
				+ endIPNumber + ", countryName=" + countryName + ", imagePath=" + imagePath +"]";
	}
	
	@Override
	public int compareTo(CountryVO o) {
		return this.countryName.compareTo(o.countryName);
	}
}
