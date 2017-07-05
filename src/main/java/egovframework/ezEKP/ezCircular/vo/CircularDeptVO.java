package egovframework.ezEKP.ezCircular.vo;

public class CircularDeptVO {
	/** 회람처 ID */
	private int circularBMID;
	/** 제목 */
	private String title;
	/** 작성자 */
	private String memberID;
	/** 작성일 */
	private String regDate;
	
	private String memberName;
	/** 멤버Count*/
	private int memberNameCount;
	
	/** 테넌트 Id */
	private int tenantID;
	public int getCircularBMID() {
		return circularBMID;
	}
	public void setCircularBMID(int circularBMID) {
		this.circularBMID = circularBMID;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getMemberID() {
		return memberID;
	}
	public void setMemberID(String memberID) {
		this.memberID = memberID;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public String getMemberName() {
		return memberName;
	}
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public int getMemberNameCount() {
		return memberNameCount;
	}
	public void setMemberNameCount(int memberNameCount) {
		this.memberNameCount = memberNameCount;
	}
	
}
