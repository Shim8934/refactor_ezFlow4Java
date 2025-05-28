package egovframework.ezEKP.ezBoard.vo;

public class BoardScrapListVO {

	private String userID;
	
	private String boardID;
	
	private String ItemID; 
	
	private String companyID; 
	
	private int tenant_ID; 
	
	private String scrapDate;
	
	private String scrapContID;

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getBoardID() {
		return boardID;
	}

	public void setBoardID(String boardID) {
		this.boardID = boardID;
	}

	public String getItemID() {
		return ItemID;
	}

	public void setItemID(String itemID) {
		ItemID = itemID;
	}

	public String getCompanyID() {
		return companyID;
	}

	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}

	public int getTenant_ID() {
		return tenant_ID;
	}

	public void setTenant_ID(int tenantID) {
		this.tenant_ID = tenantID;
	}

	public String getScrapDate() {
		return scrapDate;
	}

	public void setScrapDate(String scrapDate) {
		this.scrapDate = scrapDate;
	}

	public String getScrapContID() {
		return scrapContID;
	}

	public void setScrapContID(String scrapContID) {
		this.scrapContID = scrapContID;
	} 

}
