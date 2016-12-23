package egovframework.ezEKP.ezApproval.vo;

public class ApprReceiptInfoVO {
	/** */
	private String sentDeptID;
	/** */
	private String sentDeptName;
	/** */
	private int aprCount;
	/** */
	private String receiveDeptID;
	/** */
	private String receiveDeptName;
	
	public String getSentDeptID() {
		return sentDeptID;
	}
	public void setSentDeptID(String sentDeptID) {
		this.sentDeptID = sentDeptID;
	}
	public String getSentDeptName() {
		return sentDeptName;
	}
	public void setSentDeptName(String sentDeptName) {
		this.sentDeptName = sentDeptName;
	}
	public int getAprCount() {
		return aprCount;
	}
	public void setAprCount(int aprCount) {
		this.aprCount = aprCount;
	}
	public String getReceiveDeptID() {
		return receiveDeptID;
	}
	public void setReceiveDeptID(String receiveDeptID) {
		this.receiveDeptID = receiveDeptID;
	}
	public String getReceiveDeptName() {
		return receiveDeptName;
	}
	public void setReceiveDeptName(String receiveDeptName) {
		this.receiveDeptName = receiveDeptName;
	}
	
}
