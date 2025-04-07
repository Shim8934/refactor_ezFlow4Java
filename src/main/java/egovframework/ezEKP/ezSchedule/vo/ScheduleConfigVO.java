package egovframework.ezEKP.ezSchedule.vo;

public class ScheduleConfigVO {
	/** 일간, 주간, 월간 */
	private int defaultView;	
	/** 월요일부터 또는 일요일부터 */
	private int startDay;	
	/** 일정 시작 시간 */
	private int startTime;	
	/** 일정 종료 시간 */
	private int endTime;	
	/** 자동 삭제 여부 */
	private int isAutoDelete;	
	/** tenant*/
	private int tenantID;
	/** 미리알림시간 */
	private int reminderTime;
	
	// 월 / 주 / 일 보기 고정 사용 여부
	private String defaultViewCheck;

	public String getDefaultViewCheck() {
		return defaultViewCheck;
	}
	public void setDefaultViewCheck(String defaultViewCheck) {
		this.defaultViewCheck = defaultViewCheck;
	}
	public int getDefaultView() {
		return defaultView;
	}
	
	public void setDefaultView(int defaultView) {
		this.defaultView = defaultView;
	}
	public int getStartDay() {
		return startDay;
	}
	public void setStartDay(int startDay) {
		this.startDay = startDay;
	}
	public int getStartTime() {
		return startTime;
	}
	public void setStartTime(int startTime) {
		this.startTime = startTime;
	}
	public int getEndTime() {
		return endTime;
	}
	public void setEndTime(int endTime) {
		this.endTime = endTime;
	}
	public int getIsAutoDelete() {
		return isAutoDelete;
	}
	public void setIsAutoDelete(int isAutoDelete) {
		this.isAutoDelete = isAutoDelete;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public int getReminderTime() {
		return reminderTime;
	}
	public void setReminderTime(int reminderTime) {
		this.reminderTime = reminderTime;
	}
	
}
