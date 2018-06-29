package egovframework.ezEKP.ezQuestion.vo;

public class QstUserPollItemVO {
	/** 게시판ID*/
	int brdID;
	/** 글 번호*/
	int itemNo;
	/** 작성자아이디*/
	String userID;
	/** 작성자이름*/
	String userNm;
	/** 다국어*/
	String userNm2;
	/** 작성자이메일*/
	String userEmail;
	/** 작성자부서ID*/
	String userDeptID;
	/** 작성자부서이름*/
	String userDeptNm;
	/** 설문제목*/
	String title;
	/** 설문목적*/
	String content;
	/** 설문등록일시*/
	String postDate;
	/** 설문수정일시*/
	String updateDate;
	/** 종료일시*/
	String endDate;
	/** 설문종료후공개기간*/
	int postTerm;
	/** 관련게시물아이디(사용안함)*/
	int itemRef;
	/** 관련게시물계층레벨(사용안함)*/
	int itemLevel;
	/** 관련게시물내순서(사용안함)*/
	int itemStep;
	/** */
	String itemImp;
	/** 첨부파일여부(사용안함)*/
	int HasAttach;
	/** 원본게시자아이디(사용안함)*/
	String SrCuserID;
	/** 원본게시자이름(사용안함)*/
	String SrCuserNm;
	/** 원본게시자이메일(사용안함)*/
	String SrCuserEmail;
	/** 게시물구분(사용안함)*/
	String itemGb;
	/** 조회수*/
	int readCnt;
	/** 설문접수시작일*/
	String pollStartDate;
	/** 설문접수종료일*/
	String pollEndDate;
	/** 참여자수*/
	int responseCnt;
	/** 종료여부*/
	String completeFlag;
	/** 테넌트아이디*/
	int tenantID;
	
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
	public String getUserDeptID() {
		return userDeptID;
	}
	public void setUserDeptID(String userDeptID) {
		this.userDeptID = userDeptID;
	}
	public String getUserDeptNm() {
		return userDeptNm;
	}
	public void setUserDeptNm(String userDeptNm) {
		this.userDeptNm = userDeptNm;
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
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
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
	public int getItemLevel() {
		return itemLevel;
	}
	public void setItemLevel(int itemLevel) {
		this.itemLevel = itemLevel;
	}
	public int getItemStep() {
		return itemStep;
	}
	public void setItemStep(int itemStep) {
		this.itemStep = itemStep;
	}
	public String getItemImp() {
		return itemImp;
	}
	public void setItemImp(String itemImp) {
		this.itemImp = itemImp;
	}
	public int getHasAttach() {
		return HasAttach;
	}
	public void setHasAttach(int hasAttach) {
		HasAttach = hasAttach;
	}
	public String getSrCuserID() {
		return SrCuserID;
	}
	public void setSrCuserID(String srCuserID) {
		SrCuserID = srCuserID;
	}
	public String getSrCuserNm() {
		return SrCuserNm;
	}
	public void setSrCuserNm(String srCuserNm) {
		SrCuserNm = srCuserNm;
	}
	public String getSrCuserEmail() {
		return SrCuserEmail;
	}
	public void setSrCuserEmail(String srCuserEmail) {
		SrCuserEmail = srCuserEmail;
	}
	public String getItemGb() {
		return itemGb;
	}
	public void setItemGb(String itemGb) {
		this.itemGb = itemGb;
	}
	public int getReadCnt() {
		return readCnt;
	}
	public void setReadCnt(int readCnt) {
		this.readCnt = readCnt;
	}
	public String getPollStartDate() {
		return pollStartDate;
	}
	public void setPollStartDate(String pollStartDate) {
		this.pollStartDate = pollStartDate;
	}
	public String getPollEndDate() {
		return pollEndDate;
	}
	public void setPollEndDate(String pollEndDate) {
		this.pollEndDate = pollEndDate;
	}
	public int getResponseCnt() {
		return responseCnt;
	}
	public void setResponseCnt(int responseCnt) {
		this.responseCnt = responseCnt;
	}
	public String getCompleteFlag() {
		return completeFlag;
	}
	public void setCompleteFlag(String completeFlag) {
		this.completeFlag = completeFlag;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	
}
