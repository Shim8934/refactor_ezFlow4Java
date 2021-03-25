package egovframework.ezEKP.ezSurvey.vo;

public class Pagination {

	private int rows = 10;
	private int pages = 10;
	private int pageNo = 1;
	private int totalRows;
	
	public int getBeginIndex() {
		return (pageNo - 1) * rows + 1;
	}
	
	public int getEndIndex() {
		return pageNo * rows;
	}
	
	public int getTotalPages() {
		return (int) Math.ceil((double) totalRows / rows);
	}
	
	public int getTotalBlock() {
		return (int) Math.ceil((double) getTotalPages() / pages);
	}
	
	public int getCurrentBlock() {
		return (int) Math.ceil((double) pageNo / pages);
	}
	
	public int getBeginPage() {
		return (getCurrentBlock() -1 ) * pages + 1;
	}
	
	public int getEndPage() {
		if (getCurrentBlock() == getTotalBlock()) {
			return getTotalBlock();
		} else {
			return getCurrentBlock() * pages;
		}
	}

	public int getRows() {
		return rows;
	}

	public void setRows(int rows) {
		this.rows = rows;
	}

	public int getPages() {
		return pages;
	}

	public void setPages(int pages) {
		this.pages = pages;
	}

	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public int getTotalRows() {
		return totalRows;
	}

	public void setTotalRows(int totalRows) {
		this.totalRows = totalRows;
	}

	@Override
	public String toString() {
		return "Pagination [rows=" + rows + ", pages=" + pages + ", pageNo="
				+ pageNo + ", totalRows=" + totalRows + "]";
	}
	
}
