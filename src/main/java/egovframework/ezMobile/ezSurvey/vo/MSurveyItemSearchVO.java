package egovframework.ezMobile.ezSurvey.vo;

import java.util.List;

public class MSurveyItemSearchVO {
	private int    startPoint;
	private int    endPoint;
	private int    listCount;
	private int    tenantId;
	private String pageMode;
	private String userId;
	private String primary;
	private String offset;
	private String title;
	private String startDate;
	private String endDate;
	private String today;
	private List<Long> surveyIds;
	private int userMode;
	
	public MSurveyItemSearchVO() {}
	
	public MSurveyItemSearchVO(String pageMode, int startPoint, int endPoint, int tenantId, String userId, String primary, String offset, String title, String endDate, int userMode) {
		this.pageMode     = pageMode;
		this.startPoint   = startPoint;
		this.listCount    = endPoint - startPoint + 1;
		this.tenantId     = tenantId;
		this.userId       = userId;
		this.primary      = primary;
		this.offset       = offset;
		this.title        = title;
		this.endDate      = endDate;
		this.userMode     = userMode;
	}
	
	public int getStartPoint() {
		return startPoint;
	}
	
	public void setStartPoint(int startPoint) {
		this.startPoint = startPoint;
	}
	
	public int getListCount() {
		return listCount;
	}
	
	public void setListCount(int listCount) {
		this.listCount = listCount;
	}
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public String getPrimary() {
		return primary;
	}
	
	public void setPrimary(String primary) {
		this.primary = primary;
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
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public String getOffset() {
		return offset;
	}
	
	public void setOffset(String offset) {
		this.offset = offset;
	}
	
	public String getToday() {
		return today;
	}
	
	public void setToday(String today) {
		this.today = today;
	}
	
	public List<Long> getSurveyIds() {
		return surveyIds;
	}
	
	public void setSurveyIds(List<Long> surveyIds) {
		this.surveyIds = surveyIds;
	}
	
	public String getPageMode() {
		return pageMode;
	}
	
	public void setPageMode(String pageMode) {
		this.pageMode = pageMode;
	}

	public int getUserMode() {
		return userMode;
	}

	public void setUserMode(int userMode) {
		this.userMode = userMode;
	}

	public int getEndPoint() {
		return endPoint;
	}

	public void setEndPoint(int endPoint) {
		this.endPoint = endPoint;
	}
	
}
