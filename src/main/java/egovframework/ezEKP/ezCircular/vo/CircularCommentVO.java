package egovframework.ezEKP.ezCircular.vo;

public class CircularCommentVO {
	/** 회람팜ID */
	String circularID;
	/** 코멘트ID */
	String circularCommentID;
	/** 회람자ID */
	String circularUserID;
	/** 댓글내용 */
	String circularComment;
	/** 작성자ID */
	String memberID;
	/** 작성자이름 */
	String memberName;
	/** 작성자이름 (다국어)*/
	String memberName2;
	/** 작성일 */
	String regDate;
	/** 댓글상태 */
	int status;
	/** 테넌트ID */
	int tenantID;
	
	public String getCircularID() {
		return circularID;
	}
	public void setCircularID(String circularID) {
		this.circularID = circularID;
	}
	public String getCircularCommentID() {
		return circularCommentID;
	}
	public void setCircularCommentID(String circularCommentID) {
		this.circularCommentID = circularCommentID;
	}
	public String getCircularUserID() {
		return circularUserID;
	}
	public void setCircularUserID(String circularUserID) {
		this.circularUserID = circularUserID;
	}
	public String getCircularComment() {
		return circularComment;
	}
	public void setCircularComment(String circularComment) {
		this.circularComment = circularComment;
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
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	
}
