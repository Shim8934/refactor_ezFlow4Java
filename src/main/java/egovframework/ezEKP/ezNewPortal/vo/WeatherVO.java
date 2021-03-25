package egovframework.ezEKP.ezNewPortal.vo;

public class WeatherVO {
	private String sn;
	private String cityCode;
	private String cityName;
	private String displayName;
	private String primaryLang;
	private String currentWeather;
	private String todayWeather;
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	public String getCityCode() {
		return cityCode;
	}
	public void setCityCode(String cityCode) {
		this.cityCode = cityCode;
	}
	public String getCityName() {
		return cityName;
	}
	public void setCityName(String cityName) {
		this.cityName = cityName;
	}
	public String getDisplayName() {
		return displayName;
	}
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
	public String getPrimaryLang() {
		return primaryLang;
	}
	public void setPrimaryLang(String primaryLang) {
		this.primaryLang = primaryLang;
	}
	public String getCurrentWeather() {
		return currentWeather;
	}
	public void setCurrentWeather(String currentWeather) {
		this.currentWeather = currentWeather;
	}
	public String getTodayWeather() {
		return todayWeather;
	}
	public void setTodayWeather(String todayWeather) {
		this.todayWeather = todayWeather;
	}
}
