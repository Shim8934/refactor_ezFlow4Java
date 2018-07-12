package egovframework.ezEKP.ezWebFolder.vo;

public class SearchVO {

	private String searchExt;
	private String searchFileName;
	private String searchStartDate;
	private String searchEndDate;
	private String searchCreateName;
	private String searchFileType;
	private int searchPageCount;
	private int searchListCount;

	public String getSearchExt() {
		return searchExt;
	}

	public void setSearchExt(String searchExt) {
		this.searchExt = searchExt;
	}

	public String getSearchFileName() {
		return searchFileName;
	}

	public void setSearchFileName(String searchFileName) {
		this.searchFileName = searchFileName;
	}

	public String getSearchStartDate() {
		return searchStartDate;
	}

	public void setSearchStartDate(String searchStartDate) {
		this.searchStartDate = searchStartDate;
	}

	public String getSearchEndDate() {
		return searchEndDate;
	}

	public void setSearchEndDate(String searchEndDate) {
		this.searchEndDate = searchEndDate;
	}

	public String getSearchCreateName() {
		return searchCreateName;
	}

	public void setSearchCreateName(String searchCreateName) {
		this.searchCreateName = searchCreateName;
	}

	public String getSearchFileType() {
		return searchFileType;
	}

	public void setSearchFileType(String searchFileType) {
		this.searchFileType = searchFileType;
	}

	public int getSearchPageCount() {
		return searchPageCount;
	}

	public void setSearchPageCount(int searchPageCount) {
		this.searchPageCount = searchPageCount;
	}

	public int getSearchListCount() {
		return searchListCount;
	}

	public void setSearchListCount(int searchListCount) {
		this.searchListCount = searchListCount;
	}

	@Override
	public String toString() {
		return "SearchVO [searchExt=" + searchExt + ", searchFileName=" + searchFileName + ", searchStartDate=" + searchStartDate + ", searchEndDate=" + searchEndDate + ", searchCreateName="
				+ searchCreateName + ", searchFileType=" + searchFileType + ", searchPageCount=" + searchPageCount + ", searchListCount=" + searchListCount + "]";
	}
}
