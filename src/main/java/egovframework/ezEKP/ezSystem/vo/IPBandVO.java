package egovframework.ezEKP.ezSystem.vo;

public class IPBandVO {
	
	private String ipNo;
	private String ipAddress;
	private String access;
	private String explanation;
	private String useFido;
	private String companyId;
	public String getIpNo() {
		return ipNo;
	}
	
	public void setIpNo(String ipNo) {
		this.ipNo = ipNo;
	}
	
	public String getIpAddress() {
		return ipAddress;
	}
	
	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}
	
	public String getAccess() {
		return access;
	}
	
	public void setAccess(String access) {
		this.access = access;
	}
	
	public String getExplanation() {
		return explanation;
	}
	
	public void setExplanation(String explanation) {
		if (explanation==null) { explanation = ""; }
		this.explanation = explanation;
	}
	public String getUseFido() {
		return useFido;
	}
	
	public void setUseFido(String useFido) {
		this.useFido = useFido;
	}
	
	public String getCompanyId() {
		return companyId;
	}
	
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}

}
