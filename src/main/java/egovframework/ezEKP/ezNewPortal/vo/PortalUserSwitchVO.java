package egovframework.ezEKP.ezNewPortal.vo;

public class PortalUserSwitchVO {
    private String userId;
    private String deptId;
    private String deptName;
    private String deptName2;
    private String companyId;
    private String companyName;
    private String companyName2;
    private String title;
    private String title2;
    private String jobId;
    private String jobType;
    private boolean curr;

    @Override
    public String toString() {
        return "PortalUserSwitchVO{" +
                "userId='" + userId + '\'' +
                ", deptId='" + deptId + '\'' +
                ", deptName='" + deptName + '\'' +
                ", deptName2='" + deptName2 + '\'' +
                ", companyId='" + companyId + '\'' +
                ", companyName='" + companyName + '\'' +
                ", companyName2='" + companyName2 + '\'' +
                ", title='" + title + '\'' +
                ", title2='" + title2 + '\'' +
                ", jobId='" + jobId + '\'' +
                ", jobType='" + jobType + '\'' +
                ", curr=" + curr +
                '}';
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
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

    public String getCompanyId() {
        return companyId;
    }

    public void setCompanyId(String companyId) {
        this.companyId = companyId;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyName2() {
        return companyName2;
    }

    public void setCompanyName2(String companyName2) {
        this.companyName2 = companyName2;
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

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    public boolean isCurr() {
        return curr;
    }

    public void setCurr(boolean curr) {
        this.curr = curr;
    }
}
