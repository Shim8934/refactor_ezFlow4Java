package egovframework.ezEKP.ezAttitude.vo;

public class AttitudeApplicationVO {
	/** 근태 아이디 */
	private String attitudeId;
	/** 계열사 아이디 */
	private String companyId;
	/** 고객사 아이디 */
	private int tenantId;
	/** 신청자 아이디 */
	private String writerId;
	/** 신청자 이름 */
	private String writerName;
	/** 신청자 이름(영문) */
	private String writerName2;
	/** 신청자 직위 */
	private String writerTitle;
	/** 신청자 직위(영문) */
	private String writerTitle2;
	/** 신청자 부서 아이디 */
	private String writerDeptId;
	/** 신청자 부서명 */
	private String writerDeptName;
	/** 신청자 부서명(영문) */
	private String writerDeptName2;
	/** 출근 날짜 */
	private String originDate;
	/** 변경 일자 */
	private String changeDate;
	/** 변경 시각 */
	private String changeTime;
	/** 삭제 여부 */
	private String delFlag;
	/** 승인자 아이디 */
	private String apprUserId;
	/** 승인자 이름 */
	private String apprUserName;
	/** 승인자 이름(영문) */
	private String apprUserName2;
	/** 승인일자 */
	private String apprDate;
	/** 승인상태 */
	private String apprStatus;
	/** 사유 */
	private String content;
	/** 타입 아이디 */
	private String typeId;
	/** 타입명 */
	private String typeName;
	/** 타입명2 */
	private String typeName2;
	/** 재신청 횟수 */
	private String applCnt;
	/** 부서 이름 */
	private String description;
	/** 직위 */
	private String title;
	/** 신청일자*/
	private String applDate;
	
	
	public String getAttitudeId() {
		return attitudeId;
	}
	public void setAttitudeId(String attitudeId) {
		this.attitudeId = attitudeId;
	}
	public String getcompanyId() {
		return companyId;
	}
	public void setcompanyId(String companyId) {
		this.companyId = companyId;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getWriterName2() {
		return writerName2;
	}
	public void setWriterName2(String writerName2) {
		this.writerName2 = writerName2;
	}
	public String getWriterTitle() {
		return writerTitle;
	}
	public void setWriterTitle(String writerTitle) {
		this.writerTitle = writerTitle;
	}
	public String getWriterTitle2() {
		return writerTitle2;
	}
	public void setWriterTitle2(String writerTitle2) {
		this.writerTitle2 = writerTitle2;
	}
	public String getWriterDeptId() {
		return writerDeptId;
	}
	public void setWriterDeptId(String writerDeptId) {
		this.writerDeptId = writerDeptId;
	}
	public String getWriterDeptName() {
		return writerDeptName;
	}
	public void setWriterDeptName(String writerDeptName) {
		this.writerDeptName = writerDeptName;
	}
	public String getWriterDeptName2() {
		return writerDeptName2;
	}
	public void setWriterDeptName2(String writerDeptName2) {
		this.writerDeptName2 = writerDeptName2;
	}
	public String getChangeDate() {
		return changeDate;
	}
	public void setChangeDate(String changeDate) {
		this.changeDate = changeDate;
	}
	public String getChangeTime() {
		return changeTime;
	}
	public void setChangeTime(String changeTime) {
		this.changeTime = changeTime;
	}
	public String getDelFlag() {
		return delFlag;
	}
	public void setDelFlag(String delFlag) {
		this.delFlag = delFlag;
	}
	public String getApprUserId() {
		return apprUserId;
	}
	public void setApprUserId(String apprUserId) {
		this.apprUserId = apprUserId;
	}
	public String getApprUserName() {
		return apprUserName;
	}
	public void setApprUserName(String apprUserName) {
		this.apprUserName = apprUserName;
	}
	public String getApprUserName2() {
		return apprUserName2;
	}
	public void setApprUserName2(String apprUserName2) {
		this.apprUserName2 = apprUserName2;
	}
	public String getApprDate() {
		return apprDate;
	}
	public void setApprDate(String apprDate) {
		this.apprDate = apprDate;
	}
	public String getApprStatus() {
		return apprStatus;
	}
	public void setApprStatus(String apprStatus) {
		this.apprStatus = apprStatus;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		if (content != null){
			this.content = content.replaceAll("\'", "\"");
		}
	}
	public String getOriginDate() {
		return originDate;
	}
	public void setOriginDate(String originDate) {
		this.originDate = originDate;
	}
	@Override
	public String toString() {
		return "AttitudeApplicationVO [attitudeId=" + attitudeId
				+ ", companyId=" + companyId + ", tenantId=" + tenantId
				+ ", writerId=" + writerId + ", WriterName=" + writerName
				+ ", WriterName2=" + writerName2 + ", writerTitle="
				+ writerTitle + ", writerTitle2=" + writerTitle2
				+ ", writerDeptId=" + writerDeptId + ", writerDeptName="
				+ writerDeptName + ", writerDeptName2=" + writerDeptName2
				+ ", originDate=" + originDate + ", changeDate=" + changeDate
				+ ", changeTime=" + changeTime + ", delFlag=" + delFlag
				+ ", apprUserId=" + apprUserId + ", apprUserName="
				+ apprUserName + ", apprUserName2=" + apprUserName2
				+ ", apprDate=" + apprDate + ", apprStatus=" + apprStatus
				+ ", content=" + content + "]";
	}
	public String getTypeName() {
		return typeName;
	}
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	public String getTypeName2() {
		return typeName2;
	}
	public void setTypeName2(String typeName2) {
		this.typeName2 = typeName2;
	}
	public String getTypeId() {
		return typeId;
	}
	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}
	public String getApplCnt() {
		return applCnt;
	}
	public void setApplCnt(String applCnt) {
		this.applCnt = applCnt;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getApplDate() {
		return applDate;
	}
	public void setApplDate(String applDate) {
		this.applDate = applDate;
	}
}
