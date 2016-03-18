package egovframework.ezEKP.ezBoard.vo;

import egovframework.let.user.login.vo.LoginVO;

/**
 * @author YOON
 *	보드 게시판 정보,보드게시판 어드민 정보,권한정보 등등
 */
public class BoardPropertyVO {
	/** join을 위한 loginVO	*/
	private LoginVO loginVO;
	/** 게시판 아이디	*/
	private String boardID;
	/** 게시판 이름	*/
	private String boardName;
	/** 게시판이름 (임시용도)*/
	private String boardName1;
	/** 게시판이름(다국어)	*/
	private String boardName2;
	/** 게시판 트리뷰 순서	*/
	private String treeViewOrder;
	/** 게시판레벨(사용안함)	*/
	private String boardLevel;
	/** 상위게시판아이디	*/
	private String parentBoardID;
	/** 게시판 설명	*/
	private String boardDescription;
	/** 게시물만료기간일수(-1이면 만료되지 않음)	*/
	private String itemExpires;
	/** 첨부제한(메가단위)	*/
	private String attachSizeLimit;
	/** 답변알림 여부	*/
	private String replyNotify;
	/** 게시판이 속해있는 게시판 그룹아이디	*/
	private String boardGroupID;
	/** 게시판이 속해있는 게시판 그룹이름 */
	private String boardGroupName;
	/** 게시판이 속해있는 게시판 그룹이름2 */
	private String boardGroupName2;
	/** 관리자에게 게시판 알람여부	*/
	private String alertPostItem;
	/** 게시판 구분(일반(0),그룹(1),익명(2))	*/
	private String guBun;
	/** 링크를 건 경우 링크URL	*/
	private String url;
	/** 만료게시물 데이터 완전 삭제 대기 시간	*/
	private String deleteAfter;
	/** 트리뷰에서 게시판 색상	*/
	private String boardColor;
	/** 게시판 순번	*/
	private String boardNo;
	/** 포틀릿 사용여부	*/
	private String portlet;
	/** 한줄답변 사용여부	*/
	private String oneLineReply;
	/** 게시판 트리경로	*/
	private String boardTreePath;
	/** 배경 여부	*/
	private String backGround;
	/** 폼 경로	*/
	private String formLocation;
	/** 템플릿 게시판	*/
	private String formFlag;
	/** ?	*/
	private String apprFlag;
	/** ?	*/
	private String apprMailFlag;
	/** ?   */
	private String apprUserList;
	/** ?   */
	private String orgApprFlag;	
	/** ?	*/
	private String attributeYN;
	/** 게시글 갯수	*/
	private int ss_board_maxRows;
	/** 검색게시글 갯수	*/
	private int ss_searchBoard_maxRows;
	/** 게시판권한여부*/
	private String boardGroupAdmin_FG;
	/** 접근아이디*/
	private String accessID;
	/** 접근표시이름*/
	private String accessName;
	/** 접근표시이름(다국어)*/
	private String accessName2;
	/** 접근레벨(사용안함)*/
	private String accessLevel;
	/** 트리뷰에서 보이는지 여부*/
	private String access_;
	/** 게시판 관리자여부(true/false)*/
	private String boardMin_FG;
	/** 리스트 보이는지 여부(true/false)*/
	private String listView_FG;
	/** 게시물 읽을 수 있는지 여부(true/false)*/
	private String read_FG;
	/** 게시물 작성할 수 있는지 여부(true/false)*/
	private String	write_FG;
	/** 답변을 작성할 수 있는지 여부(true/false)*/
	private String	reply_FG;
	/** 게시물을 삭제할 수 있는지 여부(true/false)*/
	private String	delete_FG;
	/** 권한을 하위로 상속할 것인지 여부(true/false)*/
	private String	inherit_FG;
	/** 게시를 알릴 것인지 여부(true/false)(사용안함)*/
	private String	postNotice;
	/**게시판그룹 acl */
	private String	boardGroupACL;
	/** 접근 여부*/
	private String access_FG;
	/** 게시판관리자 권한여부*/
	private String boardAdmin_FG;
	/** 만료날짜*/
	private String expireDays;
	/** 첨부제한*/
	private String attachLimit;
	/** 메일 여부*/
	private String apprMail_FG;
	/** 게시판유형 Y or N*/
	private String boardType;
	/** 관리자 유형 Y or N*/
	private String adminType;
	/** 버튼 숨김여부 Y or N*/
	private String buttonHidden;
	/** 정렬 기준*/
	private String sortBy;
	/** 페이지 번호*/
	private int page;
	/** 총페이지*/
	private int totalPage;
	/** 총갯수 */
	private int totalCount;
	
	public int getSs_board_maxRows() {
		return ss_board_maxRows;
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
	public String getBoardID() {
		return boardID;
	}
	public void setBoardID(String boardID) {
		this.boardID = boardID;
	}
	public String getBoardName() {
		return boardName;
	}
	public void setBoardName(String boardName) {
		this.boardName = boardName;
	}
	public String getBoardName2() {
		return boardName2;
	}
	public void setBoardName2(String boardName2) {
		this.boardName2 = boardName2;
	}
	public String getTreeViewOrder() {
		return treeViewOrder;
	}
	public void setTreeViewOrder(String treeViewOrder) {
		this.treeViewOrder = treeViewOrder;
	}
	public String getBoardLevel() {
		return boardLevel;
	}
	public void setBoardLevel(String boardLevel) {
		this.boardLevel = boardLevel;
	}
	public String getParentBoardID() {
		return parentBoardID;
	}
	public void setParentBoardID(String parentBoardID) {
		this.parentBoardID = parentBoardID;
	}
	public String getBoardDescription() {
		return boardDescription;
	}
	public void setBoardDescription(String boardDescription) {
		this.boardDescription = boardDescription;
	}
	public String getItemExpires() {
		return itemExpires;
	}
	public void setItemExpires(String itemExpires) {
		this.itemExpires = itemExpires;
	}
	public String getAttachSizeLimit() {
		return attachSizeLimit;
	}
	public void setAttachSizeLimit(String attachSizeLimit) {
		this.attachSizeLimit = attachSizeLimit;
	}
	public String getReplyNotify() {
		return replyNotify;
	}
	public void setReplyNotify(String replyNotify) {
		this.replyNotify = replyNotify;
	}
	public String getBoardGroupID() {
		return boardGroupID;
	}
	public void setBoardGroupID(String boardGroupID) {
		this.boardGroupID = boardGroupID;
	}
	public String getAlertPostItem() {
		return alertPostItem;
	}
	public void setAlertPostItem(String alertPostItem) {
		this.alertPostItem = alertPostItem;
	}
	public String getGuBun() {
		return guBun;
	}
	public void setGuBun(String guBun) {
		this.guBun = guBun;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getDeleteAfter() {
		return deleteAfter;
	}
	public void setDeleteAfter(String deleteAfter) {
		this.deleteAfter = deleteAfter;
	}
	public String getBoardColor() {
		return boardColor;
	}
	public void setBoardColor(String boardColor) {
		this.boardColor = boardColor;
	}
	public String getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(String boardNo) {
		this.boardNo = boardNo;
	}
	public String getPortlet() {
		return portlet;
	}
	public void setPortlet(String portlet) {
		this.portlet = portlet;
	}
	public String getOneLineReply() {
		return oneLineReply;
	}
	public void setOneLineReply(String oneLineReply) {
		this.oneLineReply = oneLineReply;
	}
	public String getBoardTreePath() {
		return boardTreePath;
	}
	public void setBoardTreePath(String boardTreePath) {
		this.boardTreePath = boardTreePath;
	}
	public String getBackGround() {
		return backGround;
	}
	public void setBackGround(String backGround) {
		this.backGround = backGround;
	}
	public String getFormLocation() {
		return formLocation;
	}
	public void setFormLocation(String formLocation) {
		this.formLocation = formLocation;
	}
	public String getFormFlag() {
		return formFlag;
	}
	public void setFormFlag(String formFlag) {
		this.formFlag = formFlag;
	}
	public String getApprFlag() {
		return apprFlag;
	}
	public void setApprFlag(String apprFlag) {
		this.apprFlag = apprFlag;
	}
	public String getApprMailFlag() {
		return apprMailFlag;
	}
	public void setApprMailFlag(String apprMailFlag) {
		this.apprMailFlag = apprMailFlag;
	}
	public String getAttributeYN() {
		return attributeYN;
	}
	public void setAttributeYN(String attributeYN) {
		this.attributeYN = attributeYN;
	}
	public String getBoardGroupAdmin_FG() {
		return boardGroupAdmin_FG;
	}
	public void setBoardGroupAdmin_FG(String boardGroupAdmin_FG) {
		this.boardGroupAdmin_FG = boardGroupAdmin_FG;
	}
	public String getAccessID() {
		return accessID;
	}
	public void setAccessID(String accessID) {
		this.accessID = accessID;
	}
	public String getAccessName() {
		return accessName;
	}
	public void setAccessName(String accessName) {
		this.accessName = accessName;
	}
	public String getAccessName2() {
		return accessName2;
	}
	public void setAccessName2(String accessName2) {
		this.accessName2 = accessName2;
	}
	public String getAccessLevel() {
		return accessLevel;
	}
	public void setAccessLevel(String accessLevel) {
		this.accessLevel = accessLevel;
	}
	public String getAccess_() {
		return access_;
	}
	public void setAccess_(String access_) {
		this.access_ = access_;
	}
	public String getBoardMin_FG() {
		return boardMin_FG;
	}
	public void setBoardMin_FG(String boardMin_FG) {
		this.boardMin_FG = boardMin_FG;
	}
	public String getListView_FG() {
		return listView_FG;
	}
	public void setListView_FG(String listView_FG) {
		this.listView_FG = listView_FG;
	}
	public String getRead_FG() {
		return read_FG;
	}
	public void setRead_FG(String read_FG) {
		this.read_FG = read_FG;
	}
	public String getWrite_FG() {
		return write_FG;
	}
	public void setWrite_FG(String write_FG) {
		this.write_FG = write_FG;
	}
	public String getReply_FG() {
		return reply_FG;
	}
	public void setReply_FG(String reply_FG) {
		this.reply_FG = reply_FG;
	}
	public String getDelete_FG() {
		return delete_FG;
	}
	public void setDelete_FG(String delete_FG) {
		this.delete_FG = delete_FG;
	}
	public String getInherit_FG() {
		return inherit_FG;
	}
	public void setInherit_FG(String inherit_FG) {
		this.inherit_FG = inherit_FG;
	}
	public String getPostNotice() {
		return postNotice;
	}
	public void setPostNotice(String postNotice) {
		this.postNotice = postNotice;
	}
	public String getBoardGroupACL() {
		return boardGroupACL;
	}
	public void setBoardGroupACL(String boardGroupACL) {
		this.boardGroupACL = boardGroupACL;
	}
	public String getAccess_FG() {
		return access_FG;
	}
	public void setAccess_FG(String access_FG) {
		this.access_FG = access_FG;
	}
	public String getBoardAdmin_FG() {
		return boardAdmin_FG;
	}
	public void setBoardAdmin_FG(String boardAdmin_FG) {
		this.boardAdmin_FG = boardAdmin_FG;
	}
	public String getExpireDays() {
		return expireDays;
	}
	public void setExpireDays(String expireDays) {
		this.expireDays = expireDays;
	}
	public String getAttachLimit() {
		return attachLimit;
	}
	public void setAttachLimit(String attachLimit) {
		this.attachLimit = attachLimit;
	}
	public String getBoardName1() {
		return boardName1;
	}
	public void setBoardName1(String boardName1) {
		this.boardName1 = boardName1;
	}
	public String getApprMail_FG() {
		return apprMail_FG;
	}
	public void setApprMail_FG(String apprMail_FG) {
		this.apprMail_FG = apprMail_FG;
	}
	public String getBoardType() {
		return boardType;
	}
	public void setBoardType(String boardType) {
		this.boardType = boardType;
	}
	public String getAdminType() {
		return adminType;
	}
	public void setAdminType(String adminType) {
		this.adminType = adminType;
	}
	public String getButtonHidden() {
		return buttonHidden;
	}
	public void setButtonHidden(String buttonHidden) {
		this.buttonHidden = buttonHidden;
	}
	public String getSortBy() {
		return sortBy;
	}
	public void setSortBy(String sortBy) {
		this.sortBy = sortBy;
	}
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public String getBoardGroupName() {
		return boardGroupName;
	}
	public void setBoardGroupName(String boardGroupName) {
		this.boardGroupName = boardGroupName;
	}
	public String getBoardGroupName2() {
		return boardGroupName2;
	}
	public void setBoardGroupName2(String boardGroupName2) {
		this.boardGroupName2 = boardGroupName2;
	}
	public String getApprUserList() {
		return apprUserList;
	}
	public void setApprUserList(String apprUserList) {
		this.apprUserList = apprUserList;
	}
	public String getOrgApprFlag() {
		return orgApprFlag;
	}
	public void setOrgApprFlag(String orgApprFlag) {
		this.orgApprFlag = orgApprFlag;
	}
	public LoginVO getLoginVO() {
		return loginVO;
	}
	public void setLoginVO(LoginVO loginVO) {
		this.loginVO = loginVO;
	}
	
}
