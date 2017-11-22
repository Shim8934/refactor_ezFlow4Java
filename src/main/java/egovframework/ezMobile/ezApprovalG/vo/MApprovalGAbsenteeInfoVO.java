package egovframework.ezMobile.ezApprovalG.vo;

public class MApprovalGAbsenteeInfoVO {
	/** 부재자 아이디*/
	private String absenteeId;
	/** 부재자 이름*/
	private String absenteeName;
	/** 부재자 부서아이디*/
	private String absenteeDeptId;
	/** 부재시작일*/
	private String startDate;
	/** 부재종료일*/
	private String endDate;
	/** 테넌트 아이디*/
	private int tenantId;
	/** 유저 아이디*/
	private String userId;
	/** 통합 부재자정보*/
	private String absenteeInfo;
	
	public String getAbsenteeInfo() {
		if (absenteeId != null && !absenteeId.equals("")) {
			absenteeInfo  = absenteeId + ":" + absenteeName + ":" + absenteeDeptId + ":" + startDate + ":" + endDate; 
		}
		
		return absenteeInfo;
	}
	public void setAbsenteeInfo(String absenteeInfo) {
		this.absenteeInfo = absenteeInfo;
	}
	public String getAbsenteeId() {
		return absenteeId;
	}
	public void setAbsenteeId(String absenteeId) {
		this.absenteeId = absenteeId;
	}
	public String getAbsenteeName() {
		return absenteeName;
	}
	public void setAbsenteeName(String absenteeName) {
		this.absenteeName = absenteeName;
	}
	public String getAbsenteeDeptId() {
		return absenteeDeptId;
	}
	public void setAbsenteeDeptId(String absenteeDeptId) {
		this.absenteeDeptId = absenteeDeptId;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
}
