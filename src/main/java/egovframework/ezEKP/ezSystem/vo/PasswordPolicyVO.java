package egovframework.ezEKP.ezSystem.vo;

public class PasswordPolicyVO {
	
	private int tenantId;
	private String companyId;
	private String engCharType;
	private String useCapitalLetter;
	private String useSmallLetter;
	private String useNumber;
	private String useSpecial;
	
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public String getEngCharType() {
		return engCharType;
	}
	public void setEngCharType(String engCharType) {
		this.engCharType = engCharType;
	}
	public String getUseCapitalLetter() {
		return useCapitalLetter;
	}
	public void setUseCapitalLetter(String useCapitalLetter) {
		this.useCapitalLetter = useCapitalLetter;
	}
	public String getUseSmallLetter() {
		return useSmallLetter;
	}
	public void setUseSmallLetter(String useSmallLetter) {
		this.useSmallLetter = useSmallLetter;
	}
	public String getUseNumber() {
		return useNumber;
	}
	public void setUseNumber(String useNumber) {
		this.useNumber = useNumber;
	}
	public String getUseSpecial() {
		return useSpecial;
	}
	public void setUseSpecial(String useSpecial) {
		this.useSpecial = useSpecial;
	}
	
	@Override
	public String toString() {
		return "tenantId=" + tenantId + ", companyId=" + companyId + ", engCharType=" + engCharType + ", useCapitalLetter=" + useCapitalLetter
				+ ", useSmallLetter=" + useSmallLetter + ", useNumber=" + useNumber + ", useSpecial=" + useSpecial;
	}
	
}
