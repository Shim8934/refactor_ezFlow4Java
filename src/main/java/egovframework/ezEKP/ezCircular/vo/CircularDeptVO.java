package egovframework.ezEKP.ezCircular.vo;

public class CircularDeptVO {
	/** 회람처 Id */
	private int circularBMId;
	
	/** 제목 */
	private String title;
	
	/** 작성자 */
	private String memberId;
	
	/** 작성일 */
	private String regDate;
	
	/** 테넌트 Id */
	private int tenantId;
	
	private String memberName;

	public int getCircularBMId() {
		return circularBMId;
	}

	public void setCircularBMId(int circularBMId) {
		this.circularBMId = circularBMId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

}
