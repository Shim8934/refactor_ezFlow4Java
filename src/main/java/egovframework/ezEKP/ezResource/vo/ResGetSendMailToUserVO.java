package egovframework.ezEKP.ezResource.vo;

public class ResGetSendMailToUserVO {
	/** */
	private String writerID;
	/** */
	private String ownerNm;
	/** */
	private String deptNm;
	/** */
	private String title;
	/** */
	private String startDate;
	/** */
	private String endDate;
	/** */
	private String brd_Nm;
	/** */
	private String mail;
	/** 2023-08-02 황인경 - 자원관리 > 자원예약 > 관리자 승인/거절 메일 > 제목, 본문 실사용자원 다국어 지원  */
	private String brd_Nm2;
	
	public String getWriterID() {
		return writerID;
	}
	public void setWriterID(String writerID) {
		this.writerID = writerID;
	}
	public String getOwnerNm() {
		return ownerNm;
	}
	public void setOwnerNm(String ownerNm) {
		this.ownerNm = ownerNm;
	}
	public String getDeptNm() {
		return deptNm;
	}
	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
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
	public String getBrd_Nm() {
		return brd_Nm;
	}
	public void setBrd_Nm(String brdNm) {
		this.brd_Nm = brdNm;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public String getBrd_Nm2() {
		return brd_Nm2;
	}
	public void setBrd_Nm2(String brd_Nm2) {
		this.brd_Nm2 = brd_Nm2;
	}
}
