package egovframework.ezEKP.ezCabinet.vo;

public class CabinetItemSearchVO {
	private int    cabinetId;
	private int    startPoint;
	private int    listCount;
	private int    tenantId;
	private String cabinetPath;
	private String userId;
	private String primary;
	private String offset;
	private String title;
	private String summary;
	private String creatorName;
	private String startDate;
	private String endDate;
	private String orderCol;
	private String orderSort;
	private String searchMode;
	private String searchOption;
	
	public CabinetItemSearchVO() {}
	
	/* 2024-07-01 홍승비 - SQL Injection 수정 > sqlOrder 파라미터를 orderCol + orderSort로 수정 */
	public CabinetItemSearchVO(int cabinetId, int listCount, int tenantId, String userId, String primary, String offset, String title, String summary, String creatorName, String startDate, String endDate, String orderCol, String orderSort, String searchMode, String searhOption) {
		this.cabinetId    = cabinetId;
		this.listCount    = listCount;
		this.tenantId     = tenantId;
		this.userId       = userId;
		this.primary      = primary;
		this.offset       = offset;
		this.title        = title;
		this.summary      = summary;
		this.creatorName  = creatorName;
		this.startDate    = startDate;
		this.endDate      = endDate;
		this.orderCol     = orderCol;
		this.orderSort    = orderSort;
		this.searchMode   = searchMode;
		this.searchOption = searhOption;
	}
	
	public int getCabinetId() {
		return cabinetId;
	}
	
	public void setCabinetId(int cabinetId) {
		this.cabinetId = cabinetId;
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
	
	public String getSummary() {
		return summary;
	}
	
	public void setSummary(String summary) {
		this.summary = summary;
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
	
	public String getCabinetPath() {
		return cabinetPath;
	}
	
	public void setCabinetPath(String cabinetPath) {
		this.cabinetPath = cabinetPath;
	}
	
	public String getOffset() {
		return offset;
	}
	
	public void setOffset(String offset) {
		this.offset = offset;
	}
}
