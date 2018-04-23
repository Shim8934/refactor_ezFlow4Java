package egovframework.ezEKP.ezWebFolder.vo;

public class WebfolderEnvVO {
	private String cn;
	private String envType;
	private String envValue;
	private int tenantId;
	
	public String getCn() {
		return cn;
	}
	
	public void setCn(String cn) {
		this.cn = cn;
	}
	
	public String getEnvType() {
		return envType;
	}
	
	public void setEnvType(String envType) {
		this.envType = envType;
	}
	
	public String getEnvValue() {
		return envValue;
	}
	
	public void setEnvValue(String envValue) {
		this.envValue = envValue;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
}
