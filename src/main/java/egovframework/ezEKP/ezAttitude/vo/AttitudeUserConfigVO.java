package egovframework.ezEKP.ezAttitude.vo;

public class AttitudeUserConfigVO {
	/** 사원아이디*/
	private String userId;
	/** 테넌트 */
	private int tenantId;
	/** 근무시작시간 */
	private String workStartTime;
	/** 근무종료시간 */
	private String workEndTime;
	/** 회사아이디 */
	private String companyId;
	/** 사원명 */
	private String userName;
	/** 사원명(영문) */
	private String userName2;
	/** 사원 직위 */
	private String userTitle;
	/** 부서명 */
	private String deptName;
	/** 근무시간 (0 : 회사규율, 1 : 개인규율) */
	private String gubun;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getWorkStartTime() {
		return workStartTime;
	}
	public void setWorkStartTime(String workStartTime) {
		this.workStartTime = workStartTime;
	}
	public String getWorkEndTime() {
		return workEndTime;
	}
	public void setWorkEndTime(String workEndTime) {
		this.workEndTime = workEndTime;
	}
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserName2() {
		return userName2;
	}
	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}
	public String getUserTitle() {
		return userTitle;
	}
	public void setUserTitle(String userTitle) {
		this.userTitle = userTitle;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
}
