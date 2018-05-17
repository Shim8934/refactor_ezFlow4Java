package egovframework.ezEKP.ezPMS.vo;

//작업이력
public class TaskLogListVO {
	 // 이력 아이디 
    private Long logId;

    // 테넌트 아이디 
    private int tenantId;

    // 프로젝트 아이디 
    private Long projectId;

    // 그룹 아이디 
    private Long groupId;

    // 업무 아이디 
    private Long taskId;

    // 이력 일 
    private String logDate;

    // 이력 상태 
    private int logStatus;

    // 사용자 아이디 
    private String userId;

    // 사용자 명 
    private String userName;

    // 사용자 명다국어 
    private String userName2;

    // 사용자 부서 
    private String userDeptname;

    // 사용자 부서다국어 
    private String userDeptname2;
    
    //작업이력 내용
    private String logContent;
    
    //작업이름
    private String taskName;
    
    //그룹이름
    private String groupName;
    
    public Long getLogId() {
        return logId;
    }

    public void setLogId(Long logId) {
        this.logId = logId;
    }

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

    public Long getGroupId() {
        return groupId;
    }

    public void setGroupId(Long groupId) {
        this.groupId = groupId;
    }

    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public String getLogDate() {
        return logDate;
    }

    public void setLogDate(String logDate) {
        this.logDate = logDate;
    }

    public int getLogStatus() {
        return logStatus;
    }

    public void setLogStatus(int logStatus) {
        this.logStatus = logStatus;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
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

    public String getUserDeptname() {
        return userDeptname;
    }

    public void setUserDeptname(String userDeptname) {
        this.userDeptname = userDeptname;
    }

    public String getUserDeptname2() {
        return userDeptname2;
    }

    public void setUserDeptname2(String userDeptname2) {
        this.userDeptname2 = userDeptname2;
    }

	public String getLogContent() {
		return logContent;
	}

	public void setLogContent(String logContent) {
		this.logContent = logContent;
	}

	public String getTaskName() {
		return taskName;
	}

	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
}
