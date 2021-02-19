package egovframework.ezMobile.ezApprovalG.vo;

public class MApprovalGAbsenteeAddJobInfoVO {
    /** 테넌트 아이디*/
    private int tenantId;
    /** 유저 아이디*/
    private String userId;
    /** 부재중인 부서아이디*/
    private String absenteeDeptId;
    /** 부재중 정보*/
    private String absenteeInfo;
    /** 부재중인 부서명*/
    private String deptName;
    /** 부재중인 부서명(다국어)*/
    private String deptName2;
    /** 직위명*/
    private String title;
    /** 직위명(다국어)*/
    private String title2;
    /** 직위 아이디(본직은 -1)*/
    private String jobId;

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

    public String getAbsenteeDeptId() {
        return absenteeDeptId;
    }

    public void setAbsenteeDeptId(String absenteeDeptId) {
        this.absenteeDeptId = absenteeDeptId;
    }

    public String getAbsenteeInfo() {
        return absenteeInfo;
    }

    public void setAbsenteeInfo(String absenteeInfo) {
        this.absenteeInfo = absenteeInfo;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getDeptName2() {
        return deptName2;
    }

    public void setDeptName2(String deptName2) {
        this.deptName2 = deptName2;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTitle2() {
        return title2;
    }

    public void setTitle2(String title2) {
        this.title2 = title2;
    }

    public String getJobId() {
        return jobId;
    }

    public void setJobId(String jobId) {
        this.jobId = jobId;
    }
}
