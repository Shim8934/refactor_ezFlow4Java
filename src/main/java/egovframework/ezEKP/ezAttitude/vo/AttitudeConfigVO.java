package egovframework.ezEKP.ezAttitude.vo;

public class AttitudeConfigVO {
	/** 회사아이디 */
	private String companyId;
	/** 테넌트아이디 */
	private int tenantId;
	/** 근무시작시간 */
	private String workStartTime;
	/** 근무종료시간 */
	private String workEndTime;
	/** 휴무요일 */
	private String closedDay;
	/** 근태수정신청 */
	private String attitudeModAppl;
	/** 휴무일근태등록 */
	private String closedDateAttitude;
	/** 설정일자 */
	private String confSetDate;
	
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
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
	public String getClosedDay() {
		return closedDay;
	}
	public void setClosedDay(String closedDay) {
		this.closedDay = closedDay;
	}
	public String getAttitudeModAppl() {
		return attitudeModAppl;
	}
	public void setAttitudeModAppl(String attitudeModAppl) {
		this.attitudeModAppl = attitudeModAppl;
	}
	public String getClosedDateAttitude() {
		return closedDateAttitude;
	}
	public void setClosedDateAttitude(String closedDateAttitude) {
		this.closedDateAttitude = closedDateAttitude;
	}
	public String getConfSetDate() {
		return confSetDate;
	}
	public void setConfSetDate(String confSetDate) {
		this.confSetDate = confSetDate;
	}
	
}
