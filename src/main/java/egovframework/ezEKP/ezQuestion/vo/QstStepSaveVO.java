package egovframework.ezEKP.ezQuestion.vo;

public class QstStepSaveVO {
	/** 게시판아이디*/
	private int brdID;
	/** 아이템번호*/
	private int itemNo;
	/** 유저아이디*/
	private String userID;
	/** 유저이름*/
	private String userNm;
	/** 유저이름2*/
	private String userNm2;
	/** 유저이메일*/
	private String userEmail;
	/** 제목*/
	private String title;
	/** 내용*/
	private String content;
	/** 현재시간*/
	private String postDate;
	/** 기간*/
	private int postTerm;
	/** */
	private int itemRef;
	/** */
	private String itemImp;
	/** 시작일*/
	private String sDate;
	/** 종료일*/
	private String eDate;
	/** 데이터갯수*/
	private int dataCount;
	/** */
	private String resultFlg;
	/** */
	private String publicFlg;
	/** */
	private String multiFlg;
	/** */
	private String resRange;
	
	public int getBrdID() {
		return brdID;
	}
	public void setBrdID(int brdID) {
		this.brdID = brdID;
	}
	public int getItemNo() {
		return itemNo;
	}
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
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
	public String getPostDate() {
		return postDate;
	}
	public void setPostDate(String postDate) {
		this.postDate = postDate;
	}
	public int getPostTerm() {
		return postTerm;
	}
	public void setPostTerm(int postTerm) {
		this.postTerm = postTerm;
	}
	public int getItemRef() {
		return itemRef;
	}
	public void setItemRef(int itemRef) {
		this.itemRef = itemRef;
	}
	public String getItemImp() {
		return itemImp;
	}
	public void setItemImp(String itemImp) {
		this.itemImp = itemImp;
	}
	public String getsDate() {
		return sDate;
	}
	public void setsDate(String sDate) {
		this.sDate = sDate;
	}
	public String geteDate() {
		return eDate;
	}
	public void seteDate(String eDate) {
		this.eDate = eDate;
	}
	public int getDataCount() {
		return dataCount;
	}
	public void setDataCount(int dataCount) {
		this.dataCount = dataCount;
	}
	public String getResultFlg() {
		return resultFlg;
	}
	public void setResultFlg(String resultFlg) {
		this.resultFlg = resultFlg;
	}
	public String getPublicFlg() {
		return publicFlg;
	}
	public void setPublicFlg(String publicFlg) {
		this.publicFlg = publicFlg;
	}
	public String getMultiFlg() {
		return multiFlg;
	}
	public void setMultiFlg(String multiFlg) {
		this.multiFlg = multiFlg;
	}
	public String getResRange() {
		return resRange;
	}
	public void setResRange(String resRange) {
		this.resRange = resRange;
	}
}
