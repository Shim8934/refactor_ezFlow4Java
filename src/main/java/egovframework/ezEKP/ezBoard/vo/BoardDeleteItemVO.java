package egovframework.ezEKP.ezBoard.vo;

public class BoardDeleteItemVO {
	/** */
	private String boardID;
	/** */
	private String itemID;
	/** */
	private int tenantID;
	
	public String getBoardID() {
		return boardID;
	}
	public void setBoardID(String boardID) {
		this.boardID = boardID;
	}
	public String getItemID() {
		return itemID;
	}
	public void setItemID(String itemID) {
		this.itemID = itemID;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	
}
