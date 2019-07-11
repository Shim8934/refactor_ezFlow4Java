package egovframework.ezEKP.ezPMS.vo;

public class ProjectPagination {

	private int totalPage;
	private int startPage;
	private int endPage;
	private int startCount;
	private int currentPage;
	
	public ProjectPagination(int totalCount, int listCnt, int countPage, int currentPage){
		this.currentPage = currentPage; 
		totalPage = totalCount / listCnt;

		if (totalCount % listCnt > 0) {
		    totalPage++;
		}
		if (totalPage < currentPage) {
			currentPage = totalPage;
		}
		
		startPage = ((currentPage - 1) / countPage) * countPage + 1;
		endPage = startPage + countPage - 1;
		
		if (endPage > totalPage) {
		    endPage = totalPage;
		}
		
		startCount = (currentPage-1)*listCnt;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public int getStartPage() {
		return startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public int getStartCount() {
		return startCount;
	}
}
