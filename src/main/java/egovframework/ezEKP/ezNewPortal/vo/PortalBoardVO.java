package egovframework.ezEKP.ezNewPortal.vo;

public class PortalBoardVO {

	private String boardId; //게시판 아이디
	private String boardGroup; //게시판이 속해있는 그룹
	private String boardParentId; //부모게시판 아이디
	private String boardName; //게시판명
	
	public String getBoardId() {
		return boardId;
	}
	public void setBoardId(String boardId) {
		this.boardId = boardId;
	}
	public String getBoardGroup() {
		return boardGroup;
	}
	public void setBoardGroup(String boardGroup) {
		this.boardGroup = boardGroup;
	}
	public String getBoardParentId() {
		return boardParentId;
	}
	public void setBoardParentId(String boardParentId) {
		this.boardParentId = boardParentId;
	}
	public String getBoardName() {
		return boardName;
	}
	public void setBoardName(String boardName) {
		this.boardName = boardName;
	}
	
	@Override
	public String toString() {
		return "PortalBoardVO [boardId=" + boardId + ", boardGroup=" + boardGroup + ", boardParentId=" + boardParentId
				+ ", boardName=" + boardName + "]";
	}
}
