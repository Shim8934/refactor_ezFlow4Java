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

	/**
	 * @return the defaultView
	 */
	public int getDefaultView() {
		return defaultView;
	}

	/**
	 * @param defaultView the defaultView to set
	 */
	public void setDefaultView(int defaultView) {
		this.defaultView = defaultView;
	}

	/**
	 * @return the startDay
	 */
	public int getStartDay() {
		return startDay;
	}

	/**
	 * @param startDay the startDay to set
	 */
	public void setStartDay(int startDay) {
		this.startDay = startDay;
	}

	/**
	 * @return the startTime
	 */
	public int getStartTime() {
		return startTime;
	}

	/**
	 * @param startTime the startTime to set
	 */
	public void setStartTime(int startTime) {
		this.startTime = startTime;
	}

	/**
	 * @return the endTime
	 */
	public int getEndTime() {
		return endTime;
	}

	/**
	 * @param endTime the endTime to set
	 */
	public void setEndTime(int endTime) {
		this.endTime = endTime;
	}

	/**
	 * @return the isAutoDelete
	 */
	public int getIsAutoDelete() {
		return isAutoDelete;
	}

	/**
	 * @param isAutoDelete the isAutoDelete to set
	 */
	public void setIsAutoDelete(int isAutoDelete) {
		this.isAutoDelete = isAutoDelete;
	}

}
