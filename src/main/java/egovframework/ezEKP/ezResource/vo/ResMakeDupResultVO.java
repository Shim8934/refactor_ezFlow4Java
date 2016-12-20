package egovframework.ezEKP.ezResource.vo;

public class ResMakeDupResultVO {
	/** 시작일*/
	private String startDateTime;
	/** 종료일*/
	private String endDateTime;
	/** 하루종일 여부*/
	private int allDay;
	/** */
	private String interStartDateTime;
	/** */
	private String interEndDateTime;
	/** 작성자ID*/
	private String writerID;
	/** 부서명*/
	private String deptNm;
	/** */
	private String ownerNm;
	/** */
	private String title;
	/** 작성일*/
	private String writeDay;
	/** 테이블명*/
	private String tableName;
	/** */
	private String durationDateTime;
	
	public String getStartDateTime() {
		return startDateTime;
	}
	public void setStartDateTime(String startDateTime) {
		this.startDateTime = startDateTime;
	}
	public String getEndDateTime() {
		return endDateTime;
	}
	public void setEndDateTime(String endDateTime) {
		this.endDateTime = endDateTime;
	}
	public int getAllDay() {
		return allDay;
	}
	public void setAllDay(int allDay) {
		this.allDay = allDay;
	}
	public String getInterStartDateTime() {
		return interStartDateTime;
	}
	public void setInterStartDateTime(String interStartDateTime) {
		this.interStartDateTime = interStartDateTime;
	}
	public String getInterEndDateTime() {
		return interEndDateTime;
	}
	public void setInterEndDateTime(String interEndDateTime) {
		this.interEndDateTime = interEndDateTime;
	}
	public String getWriterID() {
		return writerID;
	}
	public void setWriterID(String writerID) {
		this.writerID = writerID;
	}
	public String getDeptNm() {
		return deptNm;
	}
	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}
	public String getOwnerNm() {
		return ownerNm;
	}
	public void setOwnerNm(String ownerNm) {
		this.ownerNm = ownerNm;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getWriteDay() {
		return writeDay;
	}
	public void setWriteDay(String writeDay) {
		this.writeDay = writeDay;
	}
	public String getTableName() {
		return tableName;
	}
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	public String getDurationDateTime() {
		return durationDateTime;
	}
	public void setDurationDateTime(String durationDateTime) {
		this.durationDateTime = durationDateTime;
	}
}
