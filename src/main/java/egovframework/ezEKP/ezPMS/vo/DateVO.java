package egovframework.ezEKP.ezPMS.vo;

public class DateVO {
	
	// 날짜(yyyy-MM-dd)
	private String date;
	
	// 요일
	private int dayOfWeek;
	
	// 기념일일 경우 이름
	private String name;
	
	// 공휴일 여부
	private boolean holidayOrNot;
	
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public int getDayOfWeek() {
		return dayOfWeek;
	}
	public void setDayOfWeek(int dayOfWeek) {
		this.dayOfWeek = dayOfWeek;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean isHolidayOrNot() {
		return holidayOrNot;
	}
	public void setHolidayOrNot(boolean holidayOrNot) {
		this.holidayOrNot = holidayOrNot;
	}
}
