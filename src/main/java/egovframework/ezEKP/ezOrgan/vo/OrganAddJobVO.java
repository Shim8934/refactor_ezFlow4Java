package egovframework.ezEKP.ezOrgan.vo;

public class OrganAddJobVO {
    private String cn;
    private String deptId;
    private String title; // 직위명
    private String title2;
    private String positionCn;
    private int tenant_id;
    private String orderBy;
    private String jobId; // 직위코드
    private String proxy;
    private String manualFlag;
    private String roll_info;
    private String extensionAttribute14;
    private String topMenuType;
    private String connectFlag;
    private String role; // 직책명
    private String role2;
    private String roleId; // 직책코드
    private String userTreeFlag; // 조직도사용여부

    private String titleCd;
    private String RoleCd;

    public String getTitleCd() {
        return titleCd;
    }

    public void setTitleCd(String titleCd) {
        this.titleCd = titleCd;
    }

    public String getRoleCd() {
        return RoleCd;
    }

    public void setRoleCd(String roleCd) {
        RoleCd = roleCd;
    }

    public String getUserTreeFlag() {
        return userTreeFlag;
    }
    public void setUserTreeFlag(String userTreeFlag) {
        this.userTreeFlag = userTreeFlag;
    }
    public String getCn() {
        return cn;
    }
    public void setCn(String cn) {
        this.cn = cn;
    }
    public String getDeptId() {
        return deptId;
    }
    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }
    public String getTitle() {
        return title != null ? title : "";
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
    public String getPositionCn() {
        return positionCn;
    }
    public void setPositionCn(String positionCn) {
        this.positionCn = positionCn;
    }
    public int getTenantId() {
        return tenant_id;
    }
    public void setTenantId(int tenant_id) {
        this.tenant_id = tenant_id;
    }
    public String getOrderBy() {
        return orderBy;
    }
    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }
    public String getJobId() {
        return jobId;
    }
    public void setJobId(String jobId) {
        this.jobId = jobId;
    }
    public String getProxy() {
        return proxy;
    }
    public void setProxy(String proxy) {
        this.proxy = proxy;
    }
    public String getManualFlag() {
        return manualFlag;
    }
    public void setManualFlag(String manualFlag) {
        this.manualFlag = manualFlag;
    }
    public String getRollInfo() {
        return roll_info;
    }
    public void setRollInfo(String roll_info) {
        this.roll_info = roll_info;
    }
    public String getExtensionAttribute14() {
        return extensionAttribute14;
    }
    public void setExtensionAttribute14(String extensionAttribute14) {
        this.extensionAttribute14 = extensionAttribute14;
    }
    public String getTopMenuType() {
        return topMenuType;
    }
    public void setTopMenuType(String topMenuType) {
        this.topMenuType = topMenuType;
    }
    public String getConnectFlag() {
        return connectFlag;
    }
    public void setConnectFlag(String connectFlag) {
        this.connectFlag = connectFlag;
    }
    public String getRole() {
        return role != null ? role : "";
    }
    public void setRole(String role) {
        this.role = role;
    }
    public String getRole2() {
        return role2;
    }
    public void setRole2(String role2) {
        this.role2 = role2;
    }
    public String getRoleId() {
        return roleId;
    }
    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }
}
