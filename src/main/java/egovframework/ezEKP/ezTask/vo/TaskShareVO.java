package egovframework.ezEKP.ezTask.vo;

/** 업무공유목록 */
public class TaskShareVO {
	/** 업무ID */
	private String taskID;
	/** 공유대상자ID */
	private String sharerID;
	/** 공유대상자이름 */
	private String sharereName;
	/** 공유대상자부서이름 */
	private String sharerDeptName;
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
	public String getSharereName() {
		return sharereName;
	}
	public void setSharereName(String sharereName) {
		this.sharereName = sharereName;
	}
	public String getSharerDeptName() {
		return sharerDeptName;
	}
	public void setSharerDeptName(String sharerDeptName) {
		this.sharerDeptName = sharerDeptName;
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
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	@Override
	public String toString() {
		return "TaskShareVO [taskID=" + taskID + ", sharerID=" + sharerID
				+ ", sharereName=" + sharereName + ", sharerDeptName="
				+ sharerDeptName + ", completeRate=" + completeRate
				+ ", completeDate=" + completeDate + ", hasMemo=" + hasMemo
				+ ", hasAttach=" + hasAttach + ", updateTime=" + updateTime
				+ ", newOrder=" + newOrder + ", tenantID=" + tenantID + "]";
	}
}
