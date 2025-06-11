package egovframework.ezEKP.ezSchedule.vo;

public class ScheduleTypeConfigVO {
	// 사용자 아이디
	private String userId;
	// 일정 유형
	private int scheduleType;
	// 유형에 따라 연결되는 대상 ID
	private String relatedId;
	// 일정 태그 색상
	private String tagColor;
	// 일정 조회 체크 상태
	private String isChecked;
	// 테넌트 아이디
	private int tenantId;
	// 회사 아이디
	private String companyId;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getScheduleType() {
		return scheduleType;
	}
	public void setScheduleType(int scheduleType) {
		this.scheduleType = scheduleType;
	}
	public String getRelatedId() {
		return relatedId;
	}
	public void setRelatedId(String relatedId) {
		this.relatedId = relatedId;
	}
	public String getTagColor() {
		return tagColor;
	}
	public void setTagColor(String tagColor) {
		this.tagColor = tagColor;
	}
	public String getIsChecked() {
		return isChecked;
	}
	public void setIsChecked(String isChecked) {
		this.isChecked = isChecked;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
}
