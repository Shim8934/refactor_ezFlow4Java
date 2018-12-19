package egovframework.ezEKP.ezNewPortal.vo;

public class LogoInfoVO {

	private String logoType; //로고 위치 : 포탈, 로그인페이지, 대표이미지
	private String logoUrl; //로고 경로
	
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
		return "LogoInfoVO [logoType=" + logoType + ", logoUrl=" + logoUrl + "]";
	}
	
}
