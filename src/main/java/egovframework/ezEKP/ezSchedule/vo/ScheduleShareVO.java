package egovframework.ezEKP.ezSchedule.vo;

public class ScheduleShareVO {
	/** rowIndex */
	private int rowIndex;	
	/** 리스트 갯수 */
	private int rowCount;	
	/** 공유테이블 ID */
	private int idx;	
	/** 사용자 이름 */
	private String userName;	
	/** 설명 */
	private String description;	
	/** 부서이름 */
	private String deptName;
	
	
	public int getRowIndex() {
		return rowIndex;
	}
	public void setRowIndex(int rowIndex) {
		this.rowIndex = rowIndex;
	}
	public int getRowCount() {
		return rowCount;
	}
	public void setRowCount(int rowCount) {
		this.rowCount = rowCount;
	}
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

}
