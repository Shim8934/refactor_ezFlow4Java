package egovframework.ezEKP.ezPersonal.vo;

public class PersonalPopupVO {
	/** 회사 아이디*/
	private String companyID;
	/** 일련번호*/
	private Integer itemSeq;
	/** 공지 시작일*/
	private String startDate;
	/** 공지 종료일*/
	private String endDate;
	/** 공지 종료일*/
	private Integer width;
	/** 공지창 높이*/
	private Integer height;
	/** 공지 제목 */
	private String title;
	/** 공지 제목(다국어)*/
	private String title2;
	/** 공지 본문 CLOB*/
	private String content;
	/** 공지 위치*/
	private String position;
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public Integer getItemSeq() {
		return itemSeq;
	}
	public void setItemSeq(Integer itemSeq) {
		this.itemSeq = itemSeq;
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
	public Integer getWidth() {
		return width;
	}
	public void setWidth(Integer width) {
		this.width = width;
	}
	public Integer getHeight() {
		return height;
	}
	public void setHeight(Integer height) {
		this.height = height;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getTitle2() {
		return title2;
	}
	public void setTitle2(String title2) {
		this.title2 = title2;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
}
