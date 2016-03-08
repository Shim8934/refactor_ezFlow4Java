package egovframework.ezEKP.ezQuestion.vo;

public class UserPollItemVO {
	/** 게시판ID*/
	int brdId;
	/** 글 번호*/
	int itemNo;
	/** 유저ID*/
	String userId;
	/** 유저이름*/
	String userNm;
	/** 다국어*/
	String userNm2;
	/** 유저EMAIL*/
	String userEmail;
	/** 유저부서ID*/
	String userDeptId;
	/** 유저부서이름*/
	String userDeptNm;
	/** 제목*/
	String title;
	/** 내용*/
	String content;
	/** 작성일*/
	String postDate;
	/** 수정일*/
	String updateDate;
	/** */
	String endDate;
	/** 기간*/
	int postTerm;
	/** */
	int itemRef;
	/** */
	int itemLevel;
	/** */
	int itemStep;
	/** */
	String itemImp;
	/** */
	int HasAttach;
	/** */
	String SrCuserId;
	/** */
	String SrCuserNm;
	/** */
	String SrCuserEmail;
	/** */
	String itemGb;
	/** 조회수*/
	int readCnt;
	/** 설문시작일*/
	String pollStartDate;
	/** 설문종료일*/
	String pollEndDate;
	/** 응답수*/
	int resCnt;
	/** 완료or진행중 구분*/
	String completeFlag;
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
	public String getUserDeptId() {
		return userDeptId;
	}
	public void setUserDeptId(String userDeptId) {
		this.userDeptId = userDeptId;
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
	public String getSrCuserId() {
		return SrCuserId;
	}
	public void setSrCuserId(String srCuserId) {
		SrCuserId = srCuserId;
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
	public int getResCnt() {
		return resCnt;
	}
	public void setResCnt(int resCnt) {
		this.resCnt = resCnt;
	}
	public String getCompleteFlag() {
		return completeFlag;
	}
	public void setCompleteFlag(String completeFlag) {
		this.completeFlag = completeFlag;
	}
	@Override
	public String toString() {
		return "UserPollItemVO [brdId=" + brdId + ", itemNo=" + itemNo
				+ ", userId=" + userId + ", userNm=" + userNm + ", userNm2="
				+ userNm2 + ", userEmail=" + userEmail + ", userDeptId="
				+ userDeptId + ", userDeptNm=" + userDeptNm + ", title="
				+ title + ", content=" + content + ", postDate=" + postDate
				+ ", updateDate=" + updateDate + ", endDate=" + endDate
				+ ", postTerm=" + postTerm + ", itemRef=" + itemRef
				+ ", itemLevel=" + itemLevel + ", itemStep=" + itemStep
				+ ", itemImp=" + itemImp + ", HasAttach=" + HasAttach
				+ ", SrCuserId=" + SrCuserId + ", SrCuserNm=" + SrCuserNm
				+ ", SrCuserEmail=" + SrCuserEmail + ", itemGb=" + itemGb
				+ ", readCnt=" + readCnt + ", pollStartDate=" + pollStartDate
				+ ", pollEndDate=" + pollEndDate + ", resCnt=" + resCnt
				+ ", completeFlag=" + completeFlag + "]";
	}
}
