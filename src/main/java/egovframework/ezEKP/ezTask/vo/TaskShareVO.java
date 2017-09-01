package egovframework.ezEKP.ezTask.vo;

/** 업무공유목록 */
public class TaskShareVO {
	/** 업무ID */
	private String taskID;
	/** 공유대상자ID */
	private String sharerID;
	/** 공유대상자이름 */
	private String sharerName;
	/** 공유대상자이름 */
	private String sharerName1;
	/** 공유대상자이름 */
	private String sharerName2;
	/** 공유대상자부서이름 */
	private String sharerDeptName;
	/** 공유대상자부서이름 */
	private String sharerDeptName1;
	/** 공유대상자부서이름 */
	private String sharerDeptName2;
	/** 완료율 */
	private String completeRate;
	/** 완료일 */
	private String completeDate;
	/** 메모유무 */
	private String hasMemo;
	/** 첨부유무 */
	private String hasAttach;
	/**  */
	private String updateTime;
	/**  */
	private String newOrder;
	/** email */
	private String email;
	/** 테넌트ID */
	private int tenantID;
	
	public String getTaskID() {
		return taskID;
	}
	public void setTaskID(String taskID) {
		this.taskID = taskID;
	}
	public String getSharerID() {
		return sharerID;
	}
	public void setSharerID(String sharerID) {
		this.sharerID = sharerID;
	}
	public String getSharerName() {
		return sharerName;
	}
	public void setSharerName(String sharerName) {
		this.sharerName = sharerName;
	}
	public String getSharerName1() {
		return sharerName1;
	}
	public void setSharerName1(String sharerName1) {
		this.sharerName1 = sharerName1;
	}
	public String getSharerName2() {
		return sharerName2;
	}
	public void setSharerName2(String sharerName2) {
		this.sharerName2 = sharerName2;
	}
	public String getSharerDeptName() {
		return sharerDeptName;
	}
	public void setSharerDeptName(String sharerDeptName) {
		this.sharerDeptName = sharerDeptName;
	}
	public String getSharerDeptName1() {
		return sharerDeptName1;
	}
	public void setSharerDeptName1(String sharerDeptName1) {
		this.sharerDeptName1 = sharerDeptName1;
	}
	public String getSharerDeptName2() {
		return sharerDeptName2;
	}
	public void setSharerDeptName2(String sharerDeptName2) {
		this.sharerDeptName2 = sharerDeptName2;
	}
	public String getCompleteRate() {
		return completeRate;
	}
	public void setCompleteRate(String completeRate) {
		this.completeRate = completeRate;
	}
	public String getCompleteDate() {
		return completeDate;
	}
	public void setCompleteDate(String completeDate) {
		this.completeDate = completeDate;
	}
	public String getHasMemo() {
		return hasMemo;
	}
	public void setHasMemo(String hasMemo) {
		this.hasMemo = hasMemo;
	}
	public String getHasAttach() {
		return hasAttach;
	}
	public void setHasAttach(String hasAttach) {
		this.hasAttach = hasAttach;
	}
	public String getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}
	public String getNewOrder() {
		return newOrder;
	}
	public void setNewOrder(String newOrder) {
		this.newOrder = newOrder;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
}
