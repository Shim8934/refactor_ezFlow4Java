package egovframework.ezEKP.ezAttitude.vo;

public class AttitudeConfigVO {
	
	private String companyId;
	private int tenantId;
	private String workStartTime;
	private String workEndTime;
	private String closedDay;
	private String attitudeModAppl;
	private String closedDateAttitude;
	
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
	
}
