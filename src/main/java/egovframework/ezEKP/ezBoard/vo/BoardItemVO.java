package egovframework.ezEKP.ezBoard.vo;

public class BoardItemVO {
	/** */
	private String itemID;
	/** */
	private String mode;
	/** */
	private String conLocation;
	/** */
	private String title;
	/** */
	private int tenantID;
	/** */
	private String filePath;
	
	public String getItemID() {
		return itemID;
	}
	public void setItemID(String itemID) {
		this.itemID = itemID;
	}
	public String getMode() {
		return mode;
	}
	public void setMode(String mode) {
		this.mode = mode;
	}
	public String getConLocation() {
		return conLocation;
	}
	public void setConLocation(String conLocation) {
		this.conLocation = conLocation;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	
}
