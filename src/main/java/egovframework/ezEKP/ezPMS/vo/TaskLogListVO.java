package egovframework.ezEKP.ezPMS.vo;

//작업이력
public class TaskLogListVO {
	 // 이력 아이디 
    private int logId;

    // 테넌트 아이디 
    private int tenantId;

    // 프로젝트 아이디 
    private int projectId;

    // 그룹 아이디 
    private int groupId;

    // 업무 아이디 
    private int taskId;

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

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public int getProjectId() {
        return projectId;
    }

    public void setProjectId(int projectId) {
        this.projectId = projectId;
    }

    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
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
}
