package egovframework.let.user.login.vo;

public class TenantServerNameVO {
    
    /**
     * 사용자가 사이트에 접속하기 위해 사용하는 서버 이름
     */
    private String serverName;
    
    /**
     * 위 서버 이름이 속한 Tenant의 고유 ID 번호
     */
    private int tenantId;

    public String getServerName() {
        return serverName;
    }

    public void setServerName(String serverName) {
        this.serverName = serverName;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }
    
}
