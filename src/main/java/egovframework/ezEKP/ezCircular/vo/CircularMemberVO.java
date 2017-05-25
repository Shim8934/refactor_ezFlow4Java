package egovframework.ezEKP.ezCircular.vo;

public class CircularMemberVO {
	private String circularBMUserId;
	
	/** 회람처 Id */
	private int circularBMId;
	
	/** 작성자 */
	private String memberId;
	
	private String memberName;
	
	private String memberName2;
	
	/** 테넌트 Id */
	private int tenantId;

	public String getCircularBMUserId() {
		return circularBMUserId;
	}

	public void setCircularBMUserId(String circularBMUserId) {
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