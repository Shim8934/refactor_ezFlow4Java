package egovframework.ezEKP.ezStatistics.vo;

public class StatApprVO {
	/** tenantID*/
	private int tenantID;
	/** 회사아이디*/
	private String company;
	/** 날짜*/
	private String date;
	/** 검색번호*/
	private String searchID;
	/** 타입*/
	private String type;
	/** 시작날짜*/
	private String startDate;
	/** 끝날짜*/
	private String endDate;
	/** 검색리스트*/
	private String searchList;
	/** 언어*/
	private String lang;
	/** yyyy-MM-dd*/
	private String today;
	
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getSearchID() {
		return searchID;
	}
	public void setSearchID(String searchID) {
		this.searchID = searchID;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
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
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public String getSearchList() {
		return searchList;
	}
	public void setSearchList(String searchList) {
		this.searchList = searchList;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	public String getToday() {
		return today;
	}
	public void setToday(String today) {
		this.today = today;
	}

}
