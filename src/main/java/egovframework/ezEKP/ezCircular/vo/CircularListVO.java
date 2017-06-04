package egovframework.ezEKP.ezCircular.vo;

public class CircularListVO {
	/** 회람판ID */
	private int circularId;
	
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
	private int status;
	
	/** 작성자 */
	private String memberId;
	
	/** 작성자이름 */
	private String memberName;
	
	/** 작성자이름2 */
	private String memberName2;
	
	/** 작성일 */
	private String regDate;
	
	/** 종료일 */
	private String endDate;
	
	/** 회람자Id */
	private String circularUserId;
	
	/** 확인상태 */
	private String confirmStatus;
	
	/** 확인일 */
	private String confirmDate;
	
	/** 변경상태 */
	private int updateStatus;

	/** 테넌트 ID */
	private int tenantId;

	public int getCircularId() {
		return circularId;
	}

	public void setCircularId(int circularId) {
		this.circularId = circularId;
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

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
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

	public String getCircularUserId() {
		return circularUserId;
	}

	public void setCircularUserId(String circularUserId) {
		this.circularUserId = circularUserId;
	}

	public String getConfirmStatus() {
		return confirmStatus;
	}

	public void setConfirmStatus(String confirmStatus) {
		this.confirmStatus = confirmStatus;
	}

	public String getConfirmDate() {
		return confirmDate;
	}

	public void setConfirmDate(String confirmDate) {
		this.confirmDate = confirmDate;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public int getUpdateStatus() {
		return updateStatus;
	}

	public void setUpdateStatus(int updateStatus) {
		this.updateStatus = updateStatus;
	}
}
