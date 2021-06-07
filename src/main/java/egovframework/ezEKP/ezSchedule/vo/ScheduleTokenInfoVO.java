package egovframework.ezEKP.ezSchedule.vo;

public class ScheduleTokenInfoVO {
	
	private String userID;
	private String googleAccessToken;
	private String googleRefreshToken;
	private String googleCreateDate;
	private String googleUpdateDate;
	private String companyID;
	private int tenantID;

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getGoogleAccessToken() {
		return googleAccessToken;
	}

	public void setGoogleAccessToken(String googleAccessToken) {
		this.googleAccessToken = googleAccessToken;
	}

	public String getGoogleRefreshToken() {
		return googleRefreshToken;
	}

	public void setGoogleRefreshToken(String googleRefreshToken) {
		this.googleRefreshToken = googleRefreshToken;
	}
	
	public String getGoogleCreateDate() {
		return googleCreateDate;
	}

	public void setGoogleCreateDate(String googleCreateDate) {
		this.googleCreateDate = googleCreateDate;
	}

	public String getGoogleUpdateDate() {
		return googleUpdateDate;
	}

	public void setGoogleUpdateDate(String googleUpdateDate) {
		this.googleUpdateDate = googleUpdateDate;
	}

	public String getCompanyID() {
		return companyID;
	}

	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}

	public int getTenantID() {
		return tenantID;
	}

	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}

	@Override
	public String toString() {
		return "ScheduleTokenInfoVO [userID=" + userID + ", googleAccessToken="
				+ googleAccessToken + ", googleRefreshToken="
				+ googleRefreshToken + ", googleCreateDate=" + googleCreateDate
				+ ", googleUpdateDate=" + googleUpdateDate + ", companyID="
				+ companyID + ", tenantID=" + tenantID + "]";
	}
}
