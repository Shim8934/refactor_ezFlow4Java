package egovframework.ezEKP.ezTask.vo;

public class TaskGeneralVO {
	/** userID */
	private String userID;
	/** 업무관리 List 개수 */
	private int listCount;
	/** 업무구분 선택 */
	private String selectTaskStatus;
	/** tenantID */
	private int tenantID;
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public int getListCount() {
		return listCount;
	}
	public void setListCount(int listCount) {
		this.listCount = listCount;
	}
	public String getSelectTaskStatus() {
		return selectTaskStatus;
	}
	public void setSelectTaskStatus(String selectTaskStatus) {
		this.selectTaskStatus = selectTaskStatus;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
}
