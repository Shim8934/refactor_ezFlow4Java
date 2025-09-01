package egovframework.ezEKP.ezBoard.vo;

public class BoardVO {
	
	/**게시판 그룹아이디	 */
	private String boardGroupId;	
	/**승인유저아이디	 */
	private String apprUserId;
	/** 게시판아이디	 */
	private String boardId;
	/** 게시글 갯수	*/
	private int ss_board_maxRows;
	/** 검색게시글 갯수	*/
	private int ss_searchBoard_maxRows;
	/** 게시판명	*/
	private String boardName;
	/** 게시판 유형*/
	private String boardType;
	/** 페이지 번호*/
	private int pageNum;
	/** 셀순서*/
	private String orderCell;
	/** 순서옵션*/
	private String orderOption;
	/** 언어 */
	private String lang;
	/** 검색 조건 */
	private String searchQuery;
	/** 리스트 타입 (1: 일반보기, 2: 안읽은 게시물 보기, 3: 완료게시물 보기) */
	private String type;
	/** 검색조건 제목*/
	private String title;
	/** 검색조건 작성자*/
	private String writerName;
	/** 검색조건*/
	private String ABSTRACT;
	/** 검색 여부*/
	private String subFlag;
	/** 이전 게시물아이디*/
	private String previousItemID;
	/** 이전 게시물타이틀*/
	private String previousTitle;
	/** 다음게시물아이디*/
	private String nextItemID;
	/** 다음게시물타이틀*/
	private String nextTitle;
	/** 게시판종류*/
	private String mode;
	/** tenant*/
	private int tenantID;
	/** 현재시간*/
	private String nowDate;
	/** 게시글 내용*/
	private String content;
	/** 2019-04-04 홍승비 - 게시판 좋아요 기능 플래그 추가 */
	private String likeFlag;
	/** 2023-04-06 기민혁 - 게시판 싫어요 기능 플래그 추가 */
	private String disLikeFlag;
	/** 키워드 */
	private String keyword;
	/** 키워드 사용여부 */
	private String useKeyword;
	/** 2023-05-03 기민혁 - 게시판 스크랩 */
	private String scrap;
	/** 2023-05-22 기민혁 - 게시판 스크랩함 ID */
	private String scrapContID;
	/** 2023-05-22 기민혁 - 게시판 스크랩함 이름 */
	private String scrapContTitle;
    /** 제목 + 내용 검색인 경우 표기용 */
    private String titleAndCont;
	/** 게시판 리스트표출방식 (G:기본/E:확장형) */
	private String listShowType;
	
	public int getSs_board_maxRows() {
		return ss_board_maxRows;
	}
	public String getBoardName() {
		return boardName;
	}
	public void setBoardName(String boardName) {
		this.boardName = boardName;
	}
	public void setSs_board_maxRows(int ss_board_maxRows) {
		this.ss_board_maxRows = ss_board_maxRows;
	}
	public int getSs_searchBoard_maxRows() {
		return ss_searchBoard_maxRows;
	}
	public void setSs_searchBoard_maxRows(int ss_searchBoard_maxRows) {
		this.ss_searchBoard_maxRows = ss_searchBoard_maxRows;
	}
	public String getApprUserId() {
		return apprUserId;
	}
	public void setApprUserId(String apprUserId) {
		this.apprUserId = apprUserId;
	}
	public String getBoardGroupId() {
		return boardGroupId;
	}
	public void setBoardGroupId(String boardGroupId) {
		this.boardGroupId = boardGroupId;
	}
	public String getBoardId() {
		return boardId;
	}
	public void setBoardId(String boardId) {
		this.boardId = boardId;
	}
	public String getBoardType() {
		return boardType;
	}
	public void setBoardType(String boardType) {
		this.boardType = boardType;
	}
	public int getPageNum() {
		return pageNum;
	}
	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}
	public String getOrderCell() {
		return orderCell;
	}
	public void setOrderCell(String orderCell) {
		this.orderCell = orderCell;
	}
	public String getOrderOption() {
		return orderOption;
	}
	public void setOrderOption(String orderOption) {
		this.orderOption = orderOption;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	public String getSearchQuery() {
		return searchQuery;
	}
	public void setSearchQuery(String searchQuery) {
		this.searchQuery = searchQuery;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getABSTRACT() {
		return ABSTRACT;
	}
	public void setABSTRACT(String aBSTRACT) {
		ABSTRACT = aBSTRACT;
	}
	public String getSubFlag() {
		return subFlag;
	}
	public void setSubFlag(String subFlag) {
		this.subFlag = subFlag;
	}
	public String getPreviousItemID() {
		return previousItemID;
	}
	public void setPreviousItemID(String previousItemID) {
		this.previousItemID = previousItemID;
	}
	public String getPreviousTitle() {
		return previousTitle;
	}
	public void setPreviousTitle(String previousTitle) {
		this.previousTitle = previousTitle;
	}
	public String getNextItemID() {
		return nextItemID;
	}
	public void setNextItemID(String nextItemID) {
		this.nextItemID = nextItemID;
	}
	public String getNextTitle() {
		return nextTitle;
	}
	public void setNextTitle(String nextTitle) {
		this.nextTitle = nextTitle;
	}
	public String getMode() {
		return mode;
	}
	public void setMode(String mode) {
		this.mode = mode;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public String getNowDate() {
		return nowDate;
	}
	public void setNowDate(String nowDate) {
		this.nowDate = nowDate;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getLikeFlag() {
		return likeFlag;
	}
	public void setLikeFlag(String likeFlag) {
		this.likeFlag = likeFlag;
	}
	public String getDisLikeFlag() {
		return disLikeFlag;
	}
	public void setDisLikeFlag(String disLikeFlag) {
		this.disLikeFlag = disLikeFlag;
	}
	public String getScrap() {
		return scrap;
	}
	public void setScrap(String scrap) {
		this.scrap = scrap;
	}
	public String getScrapContID() {
		return scrapContID;
	}
	public void setScrapContID(String scrapContID) {
		this.scrapContID = scrapContID;
	}
	public String getScrapContTitle() {
		return scrapContTitle;
	}
	public void setScrapContTitle(String scrapContTitle) {
		this.scrapContTitle = scrapContTitle;
	}
	
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getUseKeyword() {
		return useKeyword;
	}
	public void setUseKeyword(String useKeyword) {
		this.useKeyword = useKeyword;
	}
	public String getTitleAndCont() {
		return titleAndCont;
	}
	public void setTitleAndCont(String titleAndCont) {
		this.titleAndCont = titleAndCont;
	}
	public String getListShowType() {
		return listShowType;
	}

	public void setListShowType(String listShowType) {
		this.listShowType = listShowType;
	}
}