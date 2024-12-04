package egovframework.ezEKP.ezBoard.vo;

public class BoardUserScrapContVO {

	private String userScrapContID;
	
	private String userScrapContName;
	
	private String parentScrapContID;
	
	private String description;
	
	private String userID;
	
	private String tenantID;
	
	private String companyID;

	@Override
	public String toString() {
		return "BoardUserScrapContVO [userScrapContID=" + userScrapContID
				+ ", userScrapContName=" + userScrapContName
				+ ", parentScrapContID=" + parentScrapContID + ", description="
				+ description + ", userID=" + userID + ", tenant_ID="
				+ tenantID + ", companyID=" + companyID + "]";
	}

	public String getUserScrapContID() {
		return userScrapContID;
	}

	public void setUserScrapContID(String userScrapContID) {
		this.userScrapContID = userScrapContID;
	}

	public String getUserScrapContName() {
		return userScrapContName;
	}

	public void setUserScrapContName(String userScrapContName) {
		this.userScrapContName = userScrapContName;
	}

	public String getParentScrapContID() {
		return parentScrapContID;
	}

	public void setParentScrapContID(String parentScrapContID) {
		this.parentScrapContID = parentScrapContID;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getTenantID() {
		return tenantID;
	}

	public void setTenantID(String tenantID) {
		this.tenantID = tenantID;
	}

	public String getCompanyID() {
		return companyID;
	}

	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	
	
}
