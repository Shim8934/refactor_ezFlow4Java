package egovframework.ezEKP.ezOrgan.vo;

import java.util.List;
import java.util.Map;

public class TeamsOrganVO {
	
	private String delegatedAuthToken;
	
	private String publicAuthToken;
	
	private String mode;
	
	private String appId;
	
	private String tenant;
	
	private String tenantId;

	/* Teams 클라이언트 종류(Web/Desktop/Mobile..) */
	private String device;

	private String usePresence;

	private int presenceInterval;

	private String photoPath;

	private List<Map<String, String>> companyList;

	public String getDelegatedAuthToken() {
		return delegatedAuthToken;
	}

	public void setDelegatedAuthToken(String delegatedAuthToken) {
		this.delegatedAuthToken = delegatedAuthToken;
	}

	public String getPublicAuthToken() {
		return publicAuthToken;
	}

	public void setPublicAuthToken(String publicAuthToken) {
		this.publicAuthToken = publicAuthToken;
	}

	public String getMode() {
		return mode;
	}

	public void setMode(String mode) {
		this.mode = mode;
	}

	public String getAppId() {
		return appId;
	}

	public void setAppId(String appId) {
		this.appId = appId;
	}

	public String getTenant() {
		return tenant;
	}

	public void setTenant(String tenant) {
		this.tenant = tenant;
	}

	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}

	public String getDevice() {
		return device;
	}

	public void setDevice(String device) {
		this.device = device;
	}

	public String getUsePresence() {
		return usePresence;
	}

	public void setUsePresence(String usePresence) {
		this.usePresence = usePresence;
	}

	public int getPresenceInterval() {
		return presenceInterval;
	}

	public void setPresenceInterval(int presenceInterval) {
		this.presenceInterval = presenceInterval;
	}

	public String getPhotoPath() {
		return photoPath;
	}

	public void setPhotoPath(String photoPath) {
		this.photoPath = photoPath;
	}

	public List<Map<String, String>> getCompanyList() {
		return companyList;
	}

	public void setCompanyList(List<Map<String, String>> companyList) {
		this.companyList = companyList;
	}

}
