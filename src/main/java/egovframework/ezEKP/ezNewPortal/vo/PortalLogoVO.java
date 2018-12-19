package egovframework.ezEKP.ezNewPortal.vo;

public class PortalLogoVO {

	private String logoType;
	private String logoUrl;
	private boolean logoDefault;
	
	public String getLogoType() {
		return logoType;
	}
	public void setLogoType(String logoType) {
		this.logoType = logoType;
	}
	public String getLogoUrl() {
		return logoUrl;
	}
	public void setLogoUrl(String logoUrl) {
		this.logoUrl = logoUrl;
	}
	public boolean isLogoDefault() {
		return logoDefault;
	}
	public void setLogoDefault(boolean logoDefault) {
		this.logoDefault = logoDefault;
	}
	@Override
	public String toString() {
		return "PortalLogoVO [logoType=" + logoType + ", logoUrl=" + logoUrl + ", logoDefault=" + logoDefault + "]";
	}
	
	
}
