package egovframework.ezEKP.ezBoard.vo;

public class MealDataVO {
	// 일자
	private String mealDate;
	// 한식
	private String aCourse;
	// 해외음식
	private String bCourse;
	// 샐러드바
	private String saladBar;
	// 후식
	private String dessert;
	// 총열량
	private int totalCal;
	// 회사 ID
	private String companyID;
	// 테넌트ID
	private int tenantID;
	
	public String getMealDate() {
		return mealDate;
	}
	public void setMealDate(String mealDate) {
		this.mealDate = mealDate;
	}
	public String getaCourse() {
		return aCourse;
	}
	public void setaCourse(String aCourse) {
		this.aCourse = aCourse;
	}
	public String getbCourse() {
		return bCourse;
	}
	public void setbCourse(String bCourse) {
		this.bCourse = bCourse;
	}
	public String getSaladBar() {
		return saladBar;
	}
	public void setSaladBar(String saladBar) {
		this.saladBar = saladBar;
	}
	public String getDessert() {
		return dessert;
	}
	public void setDessert(String dessert) {
		this.dessert = dessert;
	}
	public int getTotalCal() {
		return totalCal;
	}
	public void setTotalCal(int totalCal) {
		this.totalCal = totalCal;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	
}
