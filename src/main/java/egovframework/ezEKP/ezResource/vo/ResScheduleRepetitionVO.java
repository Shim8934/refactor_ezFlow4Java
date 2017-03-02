package egovframework.ezEKP.ezResource.vo;

import java.util.Date;
import java.util.List;

public class ResScheduleRepetitionVO {
	private int freq; //reWay[0]
	private int selType; //reWay[1]
	private int interval; //reNum
	private int endRecurType; //endFlag
	private int instances; //reCount
	private List<Integer> daysOfWeek; //reYoil
	private int daysOfMonth; //reDay
	private int monthsOfYear; //reMonth
	private int byPosition; //reOld
	private Date startDate;
	private Date endDate;
	private boolean allDay;
	
	public int getFreq() {
		return freq;
	}
	public void setFreq(int freq) {
		this.freq = freq;
	}
	public int getSelType() {
		return selType;
	}
	public void setSelType(int selType) {
		this.selType = selType;
	}
	public int getInterval() {
		return interval;
	}
	public void setInterval(int interval) {
		this.interval = interval;
	}
	public int getEndRecurType() {
		return endRecurType;
	}
	public void setEndRecurType(int endRecurType) {
		this.endRecurType = endRecurType;
	}
	public int getInstances() {
		return instances;
	}
	public void setInstances(int instances) {
		this.instances = instances;
	}
	public List<Integer> getDaysOfWeek() {
		return daysOfWeek;
	}
	public void setDaysOfWeek(List<Integer> daysOfWeek) {
		this.daysOfWeek = daysOfWeek;
	}
	public int getDaysOfMonth() {
		return daysOfMonth;
	}
	public void setDaysOfMonth(int daysOfMonth) {
		this.daysOfMonth = daysOfMonth;
	}
	public int getMonthsOfYear() {
		return monthsOfYear;
	}
	public void setMonthsOfYear(int monthsOfYear) {
		this.monthsOfYear = monthsOfYear;
	}
	public int getByPosition() {
		return byPosition;
	}
	public void setByPosition(int byPosition) {
		this.byPosition = byPosition;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public boolean isAllDay() {
		return allDay;
	}
	public void setAllDay(boolean allDay) {
		this.allDay = allDay;
	}
	
}
