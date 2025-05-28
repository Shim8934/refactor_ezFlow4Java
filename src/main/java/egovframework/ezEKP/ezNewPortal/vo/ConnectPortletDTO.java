package egovframework.ezEKP.ezNewPortal.vo;

import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezSystem.vo.SystemConfigVO;

public class ConnectPortletDTO {
	private SystemConfigVO systemConfig;
	private String userId;
	private String deptId;
	private int currentPage;
	private int listCnt;
	private int tenantId;
	private String companyId;
	private int portletId;
	private HttpServletRequest request;
	
	public ConnectPortletDTO() {}
	
	public ConnectPortletDTO(String userId, String deptId) {
        this.userId = userId;
        this.deptId = deptId;
    }
	
	public SystemConfigVO getSystemConfig() {
		return systemConfig;
	}
	public void setSystemConfig(SystemConfigVO systemConfig) {
		this.systemConfig = systemConfig;
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
	public HttpServletRequest getRequest() {
		return request;
	}
	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}
	public int getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}
	public int getListCnt() {
		return listCnt;
	}
	public void setListCnt(int listCnt) {
		this.listCnt = listCnt;
	}
	
	public int getStartRow() {
		return (this.currentPage - 1) * this.listCnt;
	}
	
	public int getEndRow() {
		return (this.currentPage * this.listCnt - 1);
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}

	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}

	public int getPortletId() {
		return portletId;
	}

	public void setPortletId(int portletId) {
		this.portletId = portletId;
	}
	
}
