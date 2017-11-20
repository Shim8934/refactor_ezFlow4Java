package egovframework.ezEKP.ezCircular.vo;

public class CircularDeptUserVO {
	/** 회람처멤버 Id */
	private int circularBMUserID;
	/** 회람처 Id */
	private int circularBMID;
	/** 회람처 멤버 */
	private String memberID;
	/** 회람처 멤버 이름 */
	private String memberName;
	/** 회람처 멤버 이름 2 */
	private String memberName2;
	/** 테넌트 ID */
	private int tenantId;
	
	public int getCircularBMUserID() {
		return circularBMUserID;
	}
	public void setCircularBMUserID(int circularBMUserID) {
		this.circularBMUserID = circularBMUserID;
	}
	public int getCircularBMID() {
		return circularBMID;
	}
	public void setCircularBMID(int circularBMID) {
		this.circularBMID = circularBMID;
	}
	public String getMemberID() {
		return memberID;
	}
	public void setMemberID(String memberID) {
		this.memberID = memberID;
	}
	public String getMemberName() {
		return memberName;
	}
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	public String getMemberName2() {
		return memberName2;
	}
	public void setMemberName2(String memberName2) {
		this.memberName2 = memberName2;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}

}
