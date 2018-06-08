package egovframework.ezEKP.ezPMS.vo;

//검색 관련 VO
public class SearchVO {
	
	//테넌트 아이디
	private int tenantId;
	
	//프로젝트 아이디
	private Long projectId;
	
	//프로젝트 이름
	private String projectName;
	
	//상태
	private String status;
	
	//업무 아이디
	private Long taskId;
	
	//업무 명
	private String taskName;
	
	//그룹 아이디
	private Long groupId;
	
	//그룹 명
	private String GroupName;
	
	//상위그룹 아이디
	private Long upperGroupId;
	
	//상위그룹 명
	private String upperGroupName;
	
	//담당자 아이디
	private String memberId;
	
	//담당자 명
	private String memberName;
	
	//개요
	private String overview;
	
	//계획시작일
	private String planStartDate;
	
	//계획종료일
	private String planEndDate;
	
	//나의 업무인지 아닌지
	private String isMyTask;
	
	//위치
	private String lcoation;

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public Long getProjectId() {
		return projectId;
	}

	public void setProjectId(Long projectId) {
		this.projectId = projectId;
	}

	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Long getTaskId() {
		return taskId;
	}

	public void setTaskId(Long taskId) {
		this.taskId = taskId;
	}

	public String getTaskName() {
		return taskName;
	}

	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}

	public Long getGroupId() {
		return groupId;
	}

	public void setGroupId(Long groupId) {
		this.groupId = groupId;
	}

	public String getGroupName() {
		return GroupName;
	}

	public void setGroupName(String groupName) {
		GroupName = groupName;
	}

	public Long getUpperGroupId() {
		return upperGroupId;
	}

	public void setUpperGroupId(Long upperGroupId) {
		this.upperGroupId = upperGroupId;
	}

	public String getUpperGroupName() {
		return upperGroupName;
	}

	public void setUpperGroupName(String upperGroupName) {
		this.upperGroupName = upperGroupName;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getOverview() {
		return overview;
	}

	public void setOverview(String overview) {
		this.overview = overview;
	}

	public String getPlanStartDate() {
		return planStartDate;
	}

	public void setPlanStartDate(String planStartDate) {
		this.planStartDate = planStartDate;
	}

	public String getPlanEndDate() {
		return planEndDate;
	}

	public void setPlanEndDate(String planEndDate) {
		this.planEndDate = planEndDate;
	}

	public String getIsMyTask() {
		return isMyTask;
	}

	public void setIsMyTask(String isMyTask) {
		this.isMyTask = isMyTask;
	}

	public String getLcoation() {
		return lcoation;
	}

	public void setLcoation(String lcoation) {
		this.lcoation = lcoation;
	}

}
