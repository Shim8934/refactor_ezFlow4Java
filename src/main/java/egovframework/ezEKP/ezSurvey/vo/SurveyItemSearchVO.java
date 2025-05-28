package egovframework.ezEKP.ezSurvey.vo;

import java.util.List;

public class SurveyItemSearchVO {
	private int    startPoint;
	private int    listCount;
	private int    tenantId;
	private String pageMode;
	private String userId;
	private String primary;
	private String offset;
	private String title;
	private String creatorName;
	private String startDate;
	private String endDate;
	private String orderCol;
	private String orderSort;
	private String searchMode;
	private String searchOption;
	private String today;
	private List<Long> surveyIds;
	/** 2024-07-11 전인하 - 설문 > 지정공개 대상자 리스트 */
	private List<Long> surveyResultIds;
	private int userMode;

	private String filterStatus; // 상태 필터
	
	public SurveyItemSearchVO() {}
	
	public SurveyItemSearchVO(String pageMode, int listCount, int tenantId, String userId, String primary, String offset, String title, String creatorName, String startDate, String endDate, String orderCol, String orderSort, String searchMode, String searhOption, int userMode) {
		this.pageMode     = pageMode;
		this.listCount    = listCount;
		this.tenantId     = tenantId;
		this.userId       = userId;
		this.primary      = primary;
		this.offset       = offset;
		this.title        = title;
		this.creatorName  = creatorName;
		this.startDate    = startDate;
		this.endDate      = endDate;
		this.orderCol     = orderCol;
		this.orderSort    = orderSort;
		this.searchMode   = searchMode;
		this.searchOption = searhOption;
		this.userMode = userMode;
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
	
	public String getCreatorName() {
		return creatorName;
	}
	
	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
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
	
	public String getOrderCol() {
		return orderCol;
	}

	public void setOrderCol(String orderCol) {
		this.orderCol = orderCol;
	}

	public String getOrderSort() {
		return orderSort;
	}

	public void setOrderSort(String orderSort) {
		this.orderSort = orderSort;
	}

	public String getSearchMode() {
		return searchMode;
	}
	
	public void setSearchMode(String searchMode) {
		this.searchMode = searchMode;
	}
	
	public String getSearchOption() {
		return searchOption;
	}
	
	public void setSearchOption(String searchOption) {
		this.searchOption = searchOption;
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

	public List<Long> getSurveyResultIds() {
		return surveyResultIds;
	}

	public void setSurveyResultIds(List<Long> surveyResultIds) {
		this.surveyResultIds = surveyResultIds;
	}

	public String getFilterStatus() {
		return filterStatus;
	}

	public void setFilterStatus(String filterStatus) {
		this.filterStatus = filterStatus;
	}
}
