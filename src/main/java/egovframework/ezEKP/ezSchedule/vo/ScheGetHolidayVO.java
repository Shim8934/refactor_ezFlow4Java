package egovframework.ezEKP.ezSchedule.vo;

public class ScheGetHolidayVO {
	/** 기념일ID*/
	private int holidayID;
	/** 기념일 이름*/
	private String holidayName;
	/** 기념일 이름2*/
	private String holidayName2;
	/** 기념일 날짜*/
	private String holidayDate;
	/** 음력/양력 여부*/
	private int isSolar;
	/** 반복 여부*/
	private int isRepeat;
	/** 휴일 여부*/
	private int isRest;
	/** 사용 여부*/
	private int isUse;
	/** 사용 회사*/
	private String useCompany;
	
	public int getHolidayID() {
		return holidayID;
	}
	public void setHolidayID(int holidayID) {
		this.holidayID = holidayID;
	}
	public String getHolidayName() {
		return holidayName;
	}
	public void setHolidayName(String holidayName) {
		this.holidayName = holidayName;
	}
	public String getHolidayName2() {
		return holidayName2;
	}
	public void setHolidayName2(String holidayName2) {
		this.holidayName2 = holidayName2;
	}
	public String getHolidayDate() {
		return holidayDate;
	}
	public void setHolidayDate(String holidayDate) {
		this.holidayDate = holidayDate;
	}
	public int getIsSolar() {
		return isSolar;
	}
	public void setIsSolar(int isSolar) {
		this.isSolar = isSolar;
	}
	public int getIsRepeat() {
		return isRepeat;
	}
	public void setIsRepeat(int isRepeat) {
		this.isRepeat = isRepeat;
	}
	public int getIsRest() {
		return isRest;
	}
	public void setIsRest(int isRest) {
		this.isRest = isRest;
	}
	public int getIsUse() {
		return isUse;
	}
	public void setIsUse(int isUse) {
		this.isUse = isUse;
	}
	public String getUseCompany() {
		return useCompany;
	}
	public void setUseCompany(String useCompany) {
		this.useCompany = useCompany;
	}
}
