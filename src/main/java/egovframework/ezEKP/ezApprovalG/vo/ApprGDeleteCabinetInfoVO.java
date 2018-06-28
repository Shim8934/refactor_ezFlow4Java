package egovframework.ezEKP.ezApprovalG.vo;

/**
 * 
 * @author YJKS
 *
 */
public class ApprGDeleteCabinetInfoVO {

	/** 기록물철ID*/
	private String CabinetID;
	/** 삭제회원ID*/
	private String DelUserID;
	/** 삭제회원IP*/
	private String IPAddress;
	/** 회사ID*/
	private String companyID;
	/** 테넌트ID*/
	private String tenantID;
	
	public String getCabinetID() {
		return CabinetID;
	}
	public String getDelUserID() {
		return DelUserID;
	}
	public String getIPAddress() {
		return IPAddress;
	}
	public String getCompanyID() {
		return companyID;
	}
	public String getTenantID() {
		return tenantID;
	}
	public void setCabinetID(String cabinetID) {
		CabinetID = cabinetID;
	}
	public void setDelUserID(String delUserID) {
		DelUserID = delUserID;
	}
	public void setIPAddress(String iPAddress) {
		IPAddress = iPAddress;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public void setTenantID(String tenantID) {
		this.tenantID = tenantID;
	}
	
}
