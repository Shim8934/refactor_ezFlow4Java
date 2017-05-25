package egovframework.ezEKP.ezCircular.vo;

public class CircularDeptUserVO {
	/** 회람처멤버 Id */
	private int circularBMUserId;
	
	/** 회람처 Id */
	private int circularBMId;
	
	/** 회람처 멤버 */
	private String memberId;
	
	/** 회람처 멤버 이름 */
	private String memberName;
	
	/** 회람처 멤버 이름 2 */
	private String memberName2;
	
	/** 테넌트 ID */
	private int tenantId;

	public int getCircularBMUserId() {
		return circularBMUserId;
	}

	public void setCircularBMUserId(int circularBMUserId) {
		this.circularBMUserId = circularBMUserId;
	}

	public int getCircularBMId() {
		return circularBMId;
	}

	public void setCircularBMId(int circularBMId) {
		this.circularBMId = circularBMId;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
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
