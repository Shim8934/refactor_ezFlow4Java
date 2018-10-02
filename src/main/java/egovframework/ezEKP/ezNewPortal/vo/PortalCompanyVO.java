package egovframework.ezEKP.ezNewPortal.vo;

public class PortalCompanyVO {

	private String companyId; //회사 아이디
	private String companyName; //회사명
	
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	
	@Override
	public String toString() {
		return "PortalCompanyVO [companyId=" + companyId + ", companyName=" + companyName + "]";
	}
}
