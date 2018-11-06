package egovframework.ezEKP.ezNewPortal.vo;

public class PortalLogoVO {

	private String logoType;
	private String logoUrl;
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
	@Override
	public String toString() {
		return "PortalLogoVO [logoType=" + logoType + ", logoUrl=" + logoUrl + "]";
	}
	
	
}
