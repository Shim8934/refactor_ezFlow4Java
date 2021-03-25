package egovframework.ezEKP.ezAttitude.vo;

public class AttitudeVO2 {
	/** 출근/지각 근태아이디*/
	private String inAttitudeId;
	/** 퇴근/조퇴 근태아이디*/
	private String outAttitudeId;
	/** 회사아이디*/
	private String companyId;
	/** 테넌트*/
	private int tenantId;
	/** 작성자아이디*/
	private String writerId;
	/** 부서아이디*/
	private String deptId;
	/** 출근/지각 일*/
	private String startDate;
	/** 출근/지각 시간*/
	private String startTime;
	/** 퇴근/조퇴 일*/
	private String endDate;
	/** 퇴근/조퇴 시간*/
	private String endTime;
	/** 출근/지각 수정신청여부*/
	private String inModAppl;
	/** 퇴근/조퇴 수정신청여부*/
	private String outModAppl;
	/** 퇴근/조퇴 근무상태*/
	private String workStatus;
	
	public String getInAttitudeId() {
		return inAttitudeId;
	}
	public String getOutAttitudeId() {
		return outAttitudeId;
	}
	public String getCompanyId() {
		return companyId;
	}
	public int getTenantId() {
		return tenantId;
	}
	public String getWriterId() {
		return writerId;
	}
	public String getDeptId() {
		return deptId;
	}
	public String getStartDate() {
		return startDate;
	}
	public String getStartTime() {
		return startTime;
	}
	public String getEndDate() {
		return endDate;
	}
	public String getEndTime() {
		return endTime;
	}
	public String getInModAppl() {
		return inModAppl;
	}
	public String getOutModAppl() {
		return outModAppl;
	}
	public String getWorkStatus() {
		return workStatus;
	}
	public void setInAttitudeId(String inAttitudeId) {
		this.inAttitudeId = inAttitudeId;
	}
	public void setOutAttitudeId(String outAttitudeId) {
		this.outAttitudeId = outAttitudeId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public void setInModAppl(String inModAppl) {
		this.inModAppl = inModAppl;
	}
	public void setOutModAppl(String outModAppl) {
		this.outModAppl = outModAppl;
	}
	public void setWorkStatus(String workStatus) {
		this.workStatus = workStatus;
	}
	
	@Override
	public String toString() {
		return "AttitudeVO2 [inAttitudeId=" + inAttitudeId + ", outAttitudeId="
				+ outAttitudeId + ", companyId=" + companyId + ", tenantId="
				+ tenantId + ", writerId=" + writerId + ", deptId=" + deptId
				+ ", startDate=" + startDate + ", startTime=" + startTime
				+ ", endDate=" + endDate + ", endTime=" + endTime
				+ ", inModAppl=" + inModAppl + ", outModAppl=" + outModAppl
				+ ", workStatus=" + workStatus + "]";
	}
}