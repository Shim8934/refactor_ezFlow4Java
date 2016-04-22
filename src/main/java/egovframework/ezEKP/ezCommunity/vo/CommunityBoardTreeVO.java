package egovframework.ezEKP.ezCommunity.vo;

public class CommunityBoardTreeVO {
	/** 커뮤니티 아이디*/
	String c_ClubNo;
	/** 게시판아이디*/
	String boardID;
	/** 게시판이름*/
	String boardName;
	/** 게시판이름(다국어)*/
	String boardName2;
	/** 게시판 트리뷰 순서*/
	String treeViewOrder;
	/** 게시판 레벨(사용안함)*/
	int boardLevel;
	/** 상위 게시판 아이디*/
	String parentBoardID;
	/** 게시판 설명*/
	String boardDescription;
	/** 게시물 만료기간일수(-1이면 만료되지 않음)*/
	int itemExpires;
	/** 첨부제한(메가단위)*/
	String attachSizeLimit;
	/** 답변알림 여부*/
	int replyNotify;
	/** 게시판이 속해 있는 게시판그룹 아이디*/
	String boardGroupID;
	/** 관리자에게 게시 알림여부*/
	int alertPostItem;
	/** 게시판 구분(일반(0), 그룹(1), 익명(2))*/
	int gubun;
	/** 링크를 건 경우 링크 URL*/
	String url;
	/** 만료게시물 데이터 완전 삭제 대기 시간*/
	int deleteAfter;
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
	int sn;

	public String getC_ClubNo() {
		return c_ClubNo;
	}
	public void setC_ClubNo(String c_ClubNo) {
		this.c_ClubNo = c_ClubNo;
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
	public int getBoardLevel() {
		return boardLevel;
	}
	public void setBoardLevel(int boardLevel) {
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
	public int getItemExpires() {
		return itemExpires;
	}
	public void setItemExpires(int itemExpires) {
		this.itemExpires = itemExpires;
	}
	public String getAttachSizeLimit() {
		return attachSizeLimit;
	}
	public void setAttachSizeLimit(String attachSizeLimit) {
		this.attachSizeLimit = attachSizeLimit;
	}
	public int getReplyNotify() {
		return replyNotify;
	}
	public void setReplyNotify(int replyNotify) {
		this.replyNotify = replyNotify;
	}
	public String getBoardGroupID() {
		return boardGroupID;
	}
	public void setBoardGroupID(String boardGroupID) {
		this.boardGroupID = boardGroupID;
	}
	public int getAlertPostItem() {
		return alertPostItem;
	}
	public void setAlertPostItem(int alertPostItem) {
		this.alertPostItem = alertPostItem;
	}
	public int getGubun() {
		return gubun;
	}
	public void setGubun(int gubun) {
		this.gubun = gubun;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public int getDeleteAfter() {
		return deleteAfter;
	}
	public void setDeleteAfter(int deleteAfter) {
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
	public int getSn() {
		return sn;
	}
	public void setSn(int sn) {
		this.sn = sn;
	}
	
}
