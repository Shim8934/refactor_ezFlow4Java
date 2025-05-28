package egovframework.ezEKP.ezSchedule.vo;

public class ScheduleReminderVO {
	private int scheduleId;
	private String ownerId;
	private String ownerName;
	private String ownerName2;
	private String creatorId;
	private String creatorName;
	private String creatorName2;
	private String repetition;
	private String startDate;
	private String endDate;
	private String remindStartDate;
	private String title;
	private int tenantId;
	private String offSetInfo;
	private String offSetMin;
	private String lang;
	private String dateType;
	private int repeatCount;
	private String todayDate;
	private String scheduleType;
	private String companyId;
	
	public int getScheduleId() {
		return scheduleId;
	}
	public void setScheduleId(int scheduleId) {
		this.scheduleId = scheduleId;
	}
	public String getOwnerId() {
		return ownerId;
	}
	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}
	public String getOwnerName() {
		return ownerName;
	}
	public void setOwnerName(String ownerName) {
		this.ownerName = ownerName;
	}
	public String getOwnerName2() {
		return ownerName2;
	}
	public void setOwnerName2(String ownerName2) {
		this.ownerName2 = ownerName2;
	}
	public String getRepetition() {
		return repetition;
	}
	public void setRepetition(String repetition) {
		this.repetition = repetition;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getRemindStartDate() {
		return remindStartDate;
	}
	public void setRemindStartDate(String remindStartDate) {
		this.remindStartDate = remindStartDate;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getCreatorId() {
		return creatorId;
	}
	public void setCreatorId(String creatorId) {
		this.creatorId = creatorId;
	}
	public String getCreatorName() {
		return creatorName;
	}
	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
	}
	public String getCreatorName2() {
		return creatorName2;
	}
	public void setCreatorName2(String creatorName2) {
		this.creatorName2 = creatorName2;
	}
	public String getOffSetMin() {
		return offSetMin;
	}
	public void setOffSetMin(String offSet) {
		this.offSetMin = offSet;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	
	public String getOffSetInfo() {
		return offSetInfo;
	}
	public void setOffSetInfo(String offSetInfo) {
		this.offSetInfo = offSetInfo;
	}
	
	public String getDateType() {
		return dateType;
	}
	public void setDateType(String dateType) {
		this.dateType = dateType;
	}
	public int getRepeatCount() {
		return repeatCount;
	}
	public void setRepeatCount(int repeatCount) {
		this.repeatCount = repeatCount;
	}
	public String getTodayDate() {
		return todayDate;
	}
	public void setTodayDate(String todayDate) {
		this.todayDate = todayDate;
	}
	
	public String getScheduleType() {
		return scheduleType;
	}
	public void setScheduleType(String scheduleType) {
		this.scheduleType = scheduleType;
	}
	
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	@Override
	public String toString() {
		return "ScheduleReminderVO [scheduleId=" + scheduleId + ", ownerId=" + ownerId + ", ownerName=" + ownerName
				+ ", ownerName2=" + ownerName2 + ", creatorId=" + creatorId + ", creatorName=" + creatorName
				+ ", creatorName2=" + creatorName2 + ", repetition=" + repetition + ", startDate=" + startDate
				+ ", endDate=" + endDate + ", remindStartDate=" + remindStartDate + ", title=" + title + ", tenantId="
				+ tenantId + ", offSetInfo=" + offSetInfo + ", offSetMin=" + offSetMin + ", lang=" + lang + ", dateType="
				+ dateType + ", repeatCount=" + repeatCount + ", todayDate=" + todayDate + ", scheduleType=" + scheduleType + "]";
	}
}
