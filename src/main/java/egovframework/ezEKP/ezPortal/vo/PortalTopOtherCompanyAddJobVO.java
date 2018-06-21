package egovframework.ezEKP.ezPortal.vo;

/**
 * 내 회사와 겸직된 다른 회사 정보
 * @author 박성빈
 *
 */
public class PortalTopOtherCompanyAddJobVO {

	private String companyID;
	private String CompanyName;
	private String deptID;
	private String deptName;
	private int apprCount;
	
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public String getCompanyName() {
		return CompanyName;
	}
	public void setCompanyName(String companyName) {
		CompanyName = companyName;
	}
	public String getDeptID() {
		return deptID;
	}
	public void setDeptID(String deptID) {
		this.deptID = deptID;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public int getApprCount() {
		return apprCount;
	}
	public void setApprCount(int apprCount) {
		this.apprCount = apprCount;
	}
}
