package egovframework.ezEKP.ezCommunity.vo;

public class CommunityBoardPropertyVO {
	/** 커뮤니티 아이디*/
	String c_ClubNo;
	/** 게시판 트리뷰 순서*/
	String treeViewOrder;
	/** 게시판 설명*/
	String boardDescription;
	/** 게시물 만료기간일수(-1이면 만료되지 않음)*/
	Integer itemExpires;
	/** 게시판이 속해 있는 게시판그룹 아이디*/
	String boardGoroupID;
	/** 관리자에게 게시 알림여부*/
	String alertPostItem;
	/** 만료게시물 데이터 완전 삭제 대기 시간*/
	String deleteAfter;
	/** 트리뷰에서 게시판 색상*/
	String boardColor;
	/** 게시판 순번*/
	int boardNo;
	/** 버전 사용유무*/
	String versionUse;
	/** 체크 인/아웃 사용유무*/
	String checkUse;
	/** 게시판 위치*/
	String showPosition;
	/** 순서*/
	String sn;
	/** 개시글 갯수*/
	int ss_Board_MaxRows;
	/** 검색 개시글 갯수*/
	int ss_SearchBoard_MaxRows;
	/** 게시판 아이디*/
	String boardID;
	/** 접근아이디*/
	String accessID;
	/** 접근표시이름*/
	String accessName;
	/** 접근표시이름(다국어)*/
	String accessName2;
	/** 접근레벨*/
	Integer accessLevel;
	/** 트리뷰에서 보이는지 여부*/
	int access_;
	/** 상위게시판아이디	*/
	String parentBoardID;
	/** 게시판 이름*/
	String boardName;
	/** 게시판 이름(다국어)*/
	String boardName2;
	/** 접근 여부*/
	String access_FG;
	/** 게시판 관리자 권한 여부*/
	String boardAdmin_FG;
	/** 리스트 보이는지 여부*/
	String listView_FG;
	/** 읽기 권한 여부*/
	String read_FG;
	/** 쓰기 권한 여부*/
	String write_FG;
	/** 답변 권한 여부*/
	String reply_FG;
	/** 삭제 권한 여부*/
	String delete_FG;
	/** 권한 상속 여부*/
	String inherit_FG;
	/** 게시 알림 여부*/
	String postNotice;
	/** 만료 날짜*/
	String expireDays;
	/** 첨부제한(메가단위)	*/
	String attachSizeLimit;
	/** 게시판 권한 여부*/
	String boardGroupAdmin_FG;
	/** 답변 알림 여부*/
	String replyNotify;
	/** 게시판 구분(일반(0),그룹(1),익명(2))*/
	String gubun;
	/** 링크를 건 경우 링크URL*/
	String url;
	public String getC_ClubNo() {
		return c_ClubNo;
	}
	public void setC_ClubNo(String c_ClubNo) {
		this.c_ClubNo = c_ClubNo;
	}
	public String getTreeViewOrder() {
		return treeViewOrder;
	}
	public void setTreeViewOrder(String treeViewOrder) {
		this.treeViewOrder = treeViewOrder;
	}
	public String getBoardDescription() {
		return boardDescription;
	}
	public void setBoardDescription(String boardDescription) {
		this.boardDescription = boardDescription;
	}
	public Integer getItemExpires() {
		return itemExpires;
	}
	public void setItemExpires(Integer itemExpires) {
		this.itemExpires = itemExpires;
	}
	public String getBoardGoroupID() {
		return boardGoroupID;
	}
	public void setBoardGoroupID(String boardGoroupID) {
		this.boardGoroupID = boardGoroupID;
	}
	public String getAlertPostItem() {
		return alertPostItem;
	}
	public void setAlertPostItem(String alertPostItem) {
		this.alertPostItem = alertPostItem;
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
	public int getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(int boardNo) {
		this.boardNo = boardNo;
	}
	public String getVersionUse() {
		return versionUse;
	}
	public void setVersionUse(String versionUse) {
		this.versionUse = versionUse;
	}
	public String getCheckUse() {
		return checkUse;
	}
	public void setCheckUse(String checkUse) {
		this.checkUse = checkUse;
	}
	public String getShowPosition() {
		return showPosition;
	}
	public void setShowPosition(String showPosition) {
		this.showPosition = showPosition;
	}
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	public int getSs_Board_MaxRows() {
		return ss_Board_MaxRows;
	}
	public void setSs_Board_MaxRows(int ss_Board_MaxRows) {
		this.ss_Board_MaxRows = ss_Board_MaxRows;
	}
	public int getSs_SearchBoard_MaxRows() {
		return ss_SearchBoard_MaxRows;
	}
	public void setSs_SearchBoard_MaxRows(int ss_SearchBoard_MaxRows) {
		this.ss_SearchBoard_MaxRows = ss_SearchBoard_MaxRows;
	}
	public String getBoardID() {
		return boardID;
	}
	public void setBoardID(String boardID) {
		this.boardID = boardID;
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
	public Integer getAccessLevel() {
		return accessLevel;
	}
	public void setAccessLevel(Integer accessLevel) {
		this.accessLevel = accessLevel;
	}
	public int getAccess_() {
		return access_;
	}
	public void setAccess_(int access_) {
		this.access_ = access_;
	}
	public String getParentBoardID() {
		return parentBoardID;
	}
	public void setParentBoardID(String parentBoardID) {
		this.parentBoardID = parentBoardID;
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
	public String getExpireDays() {
		return expireDays;
	}
	public void setExpireDays(String expireDays) {
		this.expireDays = expireDays;
	}
	public String getAttachSizeLimit() {
		return attachSizeLimit;
	}
	public void setAttachSizeLimit(String attachSizeLimit) {
		this.attachSizeLimit = attachSizeLimit;
	}
	public String getBoardGroupAdmin_FG() {
		return boardGroupAdmin_FG;
	}
	public void setBoardGroupAdmin_FG(String boardGroupAdmin_FG) {
		this.boardGroupAdmin_FG = boardGroupAdmin_FG;
	}
	public String getReplyNotify() {
		return replyNotify;
	}
	public void setReplyNotify(String replyNotify) {
		this.replyNotify = replyNotify;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}

	
}
