package egovframework.ezEKP.ezResource.vo;

public class ResObjArrayDestVO {
	/** 시작일*/
	private String interStartDateTime;
	/** 종료일*/
	private String interEndDateTime;
	/** 작성자ID*/
	private String writerID;
	/** 부서명*/
	private String deptNm;
	/** 자원명*/
	private String ownerNm;
	/** 제목*/
	private String title;
	/** 작성일*/
	private String writeDay;
	
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
}
