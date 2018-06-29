package egovframework.ezEKP.ezPortal.vo;

public class PortalTBLPortalACLVO {
	/** */
	private String uID_;
	/** */
	private String accessID;
	/** */
	private String accessName;
	/** */
	private int view_Right;
	/** */
	private int edit_Right;
	
	public String getuID_() {
		return uID_;
	}
	public void setuID_(String uID_) {
		this.uID_ = uID_;
	}
	public String getAccessID() {
		return accessID;
	}
	public void setAccessID(String accessID) {
		this.accessID = accessID;
	}
	public String getAccessName() {
		return accessName;
	}
	public void setAccessName(String accessName) {
		this.accessName = accessName;
	}
	public int getView_Right() {
		return view_Right;
	}
	public void setView_Right(int view_Right) {
		this.view_Right = view_Right;
	}
	public int getEdit_Right() {
		return edit_Right;
	}
	public void setEdit_Right(int edit_Right) {
		this.edit_Right = edit_Right;
	}
}
