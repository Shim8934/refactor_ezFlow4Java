package egovframework.ezEKP.ezQuestion.vo;


public class QuestionListVO {
	/** 게시판아이디*/
	private int brdId;
	/** 설문번호*/
	private int itemNo;
	/** 유저아이디*/
	private String userId;
	/** 유저이름*/
	private String userNm;
	/** 유저이름(다국어)*/
	private String userNm2;
	/** 유저이메일*/
	private String userEmail;
	/** 제목*/
	private String title;
	/** 제목*/
	private String content;
	/** 유효한 마지막 날*/
	private String pollEndDate;
	/** 유효한 첫 날*/
	private String postDate;
	/** 결과공개*/
	private String publicResultFlg;
	/** 기명여부*/
	private String publicFlg;
	/** */
	private String multiResponseFlg;
	/** */
	private String endFlg;
	/** 대상자*/
	private String responseRange;
	/** 게시글 총갯수*/
	private int totalCnt;
	/** 페이지 갯수*/
	private int totalPage;
	/** 현제 페이지*/
	private int currPage;
	/** 한 페이지사이즈*/
	private int pageSize;
	/** 페이지사이즈*/
	private int blockSize;
	/** 현재블록(불필요 시 삭제)*/
	private int currBlock;
	/** 전체블록(불필요 시 삭제)*/
	private int totalBlock;
	/** 언어*/
	private String lang;
	/** jsp Onclick 시 주소*/
	private String receve;
	
	public int getBrdId() {
		return brdId;
	}
	public void setBrdId(int brdId) {
		this.brdId = brdId;
	}
	public int getItemNo() {
		return itemNo;
	}
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getUserNm2() {
		return userNm2;
	}
	public void setUserNm2(String userNm2) {
		this.userNm2 = userNm2;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getPollEndDate() {
		return pollEndDate;
	}
	public void setPollEndDate(String pollEndDate) {
		this.pollEndDate = pollEndDate;
	}
	public String getPostDate() {
		return postDate;
	}
	public void setPostDate(String postDate) {
		this.postDate = postDate;
	}
	public String getPublicResultFlg() {
		return publicResultFlg;
	}
	public void setPublicResultFlg(String publicResultFlg) {
		this.publicResultFlg = publicResultFlg;
	}
	public String getPublicFlg() {
		return publicFlg;
	}
	public void setPublicFlg(String publicFlg) {
		this.publicFlg = publicFlg;
	}
	public String getMultiResponseFlg() {
		return multiResponseFlg;
	}
	public void setMultiResponseFlg(String multiResponseFlg) {
		this.multiResponseFlg = multiResponseFlg;
	}
	public String getEndFlg() {
		return endFlg;
	}
	public void setEndFlg(String endFlg) {
		this.endFlg = endFlg;
	}
	public String getResponseRange() {
		return responseRange;
	}
	public void setResponseRange(String responseRange) {
		this.responseRange = responseRange;
	}
	public int getTotalCnt() {
		return totalCnt;
	}
	public void setTotalCnt(int totalCnt) {
		this.totalCnt = totalCnt;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getCurrPage() {
		return currPage;
	}
	public void setCurrPage(int currPage) {
		this.currPage = currPage;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public int getBlockSize() {
		return blockSize;
	}
	public void setBlockSize(int blockSize) {
		this.blockSize = blockSize;
	}
	public int getCurrBlock() {
		return currBlock;
	}
	public void setCurrBlock(int currBlock) {
		this.currBlock = currBlock;
	}
	public int getTotalBlock() {
		return totalBlock;
	}
	public void setTotalBlock(int totalBlock) {
		this.totalBlock = totalBlock;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	public String getReceve() {
		return receve;
	}
	public void setReceve(String receve) {
		this.receve = receve;
	}
}
