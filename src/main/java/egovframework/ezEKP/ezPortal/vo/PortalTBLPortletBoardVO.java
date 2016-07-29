package egovframework.ezEKP.ezPortal.vo;

public class PortalTBLPortletBoardVO {
	/** */
	private String uID;
	/** */
	private String creatorID;
	/** */
	private String userType;
	/** */
	private String boardID;
	/** */
	private int itemCount;
	/** */
	private String itemFields;
	
	public String getuID() {
		return uID;
	}
	public void setuID(String uID) {
		this.uID = uID;
	}
	public String getCreatorID() {
		return creatorID;
	}
	public void setCreatorID(String creatorID) {
		this.creatorID = creatorID;
	}
	public String getUserType() {
		return userType;
	}
	public void setUserType(String userType) {
		this.userType = userType;
	}
	public String getBoardID() {
		return boardID;
	}
	public void setBoardID(String boardID) {
		this.boardID = boardID;
	}
	public int getItemCount() {
		return itemCount;
	}
	public void setItemCount(int itemCount) {
		this.itemCount = itemCount;
	}
	public String getItemFields() {
		return itemFields;
	}
	public void setItemFields(String itemFields) {
		this.itemFields = itemFields;
	}
}
