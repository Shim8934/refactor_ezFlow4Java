package egovframework.ezMobile.ezSurvey.vo;

public class MSurveyParticipantVO {
	private long   participantId;
	private String userId;
	private long   surveyId;
	private String userType;
	private String userName;
	private String userName1;
	private String userName2;
	private String email;
	private String deptId;
	private String deptName;
	private String deptName1;
	private String deptName2;
	private String companyId;
	private int    tenantId;
	/** 2021-11-18 홍승비 - 전자설문 대상자 하위부서 플래그 추가 */
	private String subDeptYN;
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public long getSurveyId() {
		return surveyId;
	}
	
	public void setSurveyId(long surveyId) {
		this.surveyId = surveyId;
	}
	
	public String getUserType() {
		return userType;
	}
	
	public void setUserType(String userType) {
		this.userType = userType;
	}
	
	public String getUserName1() {
		return userName1;
	}
	
	public void setUserName1(String userName1) {
		this.userName1 = userName1;
	}
	
	public String getUserName2() {
		return userName2;
	}
	
	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}
	
	public String getEmail() {
		return email;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getDeptId() {
		return deptId;
	}
	
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	
	public String getDeptName1() {
		return deptName1;
	}
	
	public void setDeptName1(String deptName1) {
		this.deptName1 = deptName1;
	}
	
	public String getDeptName2() {
		return deptName2;
	}
	
	public void setDeptName2(String deptName2) {
		this.deptName2 = deptName2;
	}
	
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
	
	public long getParticipantId() {
		return participantId;
	}
	
	public void setParticipantId(long participantId) {
		this.participantId = participantId;
	}
	
	public String getUserName() {
		return userName;
	}
	
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public String getDeptName() {
		return deptName;
	}
	
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getSubDeptYN() {
		return subDeptYN;
	}

	public void setSubDeptYN(String subDeptYN) {
		this.subDeptYN = subDeptYN;
	}
}
