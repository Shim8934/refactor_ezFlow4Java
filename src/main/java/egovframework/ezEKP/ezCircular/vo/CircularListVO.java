package egovframework.ezEKP.ezCircular.vo;

public class CircularListVO {
	/** 회람판ID */
	private int circularID;
	/** 제목 */
	private String title;
	/** 중요도 */
	private int importance;
	/** 옵션 */
	private int option;
	/** 내용 */
	private String content;
	/** 첨부파일 */
	private int hasFile;
	/** 회람상태 */
	private Integer status;
	/** 작성자 */
	private String memberID;
	/** 작성자이름 */
	private String memberName;
	/** 작성자이름2 */
	private String memberName2;
	/** 작성일 */
	private String regDate;
	/** 종료일 */
	private String endDate;
	/** 회람자Id */
	private String circularUserID;
	/** 본인확인상태 */
	private String confirmStatus;
	/** 확인일 */
	private String confirmDate;
	/** 회람자확인상태 카운트 */
	private String confirmCount;
	/** 회람자확인상태 카운트*/
	private String confirmTotalCount;
	/** 변경상태 */
	private int updateStatus;
	/** 변경일 */
	private String updateDate;
	/** 테넌트 ID */
	private int tenantID;
	/** 의견상태 */
	private String commentStatus;
	/** 공유상태 */
	private String shareStatus;
	/** 회사Id */
	private String companyID;

	public int getCircularID() {
		return circularID;
	}
	public void setCircularID(int circularID) {
		this.circularID = circularID;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getImportance() {
		return importance;
	}
	public void setImportance(int importance) {
		this.importance = importance;
	}
	public int getOption() {
		return option;
	}
	public void setOption(int option) {
		this.option = option;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getHasFile() {
		return hasFile;
	}
	public void setHasFile(int hasFile) {
		this.hasFile = hasFile;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
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
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getCircularUserID() {
		return circularUserID;
	}
	public void setCircularUserID(String circularUserID) {
		this.circularUserID = circularUserID;
	}
	public String getConfirmStatus() {
		return confirmStatus;
	}
	public void setConfirmStatus(String confirmStatus) {
		this.confirmStatus = confirmStatus;
	}
	public String getConfirmCount() {
		return confirmCount;
	}
	public void setConfirmCount(String confirmCount) {
		this.confirmCount = confirmCount;
	}
	public String getConfirmTotalCount() {
		return confirmTotalCount;
	}
	public void setConfirmTotalCount(String confirmTotalCount) {
		this.confirmTotalCount = confirmTotalCount;
	}
	public String getConfirmDate() {
		return confirmDate;
	}
	public void setConfirmDate(String confirmDate) {
		this.confirmDate = confirmDate;
	}
	public int getUpdateStatus() {
		return updateStatus;
	}
	public void setUpdateStatus(int updateStatus) {
		this.updateStatus = updateStatus;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public String getCommentStatus() {
		return commentStatus;
	}
	public void setCommentStatus(String commentStatus) {
		this.commentStatus = commentStatus;
	}
	public String getShareStatus() {
		return shareStatus;
	}
	public void setShareStatus(String shareStatus) {
		this.shareStatus = shareStatus;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
}
