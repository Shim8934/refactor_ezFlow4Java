package egovframework.ezEKP.ezSurvey.vo;

public class RespondentVO {
	private long responseId;
	private long surveyId;
	private String userId;
	private String userName1;
	private String userName2;
	private String email;
	private String image;
	private String deptId;
	private String deptName1;
	private String deptName2;
	private String responseDate;
	private String companyId;
	private int tenantId;
	private int lotteryResult; /*추첨결과*/
	
	public String getImage() {
		return image;
	}
	
	public void setImage(String image) {
		this.image = image;
	}
	
	public long getResponseId() {
		return responseId;
	}
	
	public void setResponseId(long responseId) {
		this.responseId = responseId;
	}
	
	public long getSurveyId() {
		return surveyId;
	}
	
	public void setSurveyId(long surveyId) {
		this.surveyId = surveyId;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
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
	
	public String getResponseDate() {
		return responseDate;
	}
	
	public void setResponseDate(String responseDate) {
		this.responseDate = responseDate;
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

	public int getLotteryResult() {
		return lotteryResult;
	}

	public void setLotteryResult(int lotteryResult) {
		this.lotteryResult = lotteryResult;
	}
}
