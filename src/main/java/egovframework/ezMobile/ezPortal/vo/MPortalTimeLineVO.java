package egovframework.ezMobile.ezPortal.vo;

public class MPortalTimeLineVO {
	/** 타임라인 타이틀*/
	private String title;
	/** 타임라인 시작*/
	private String startDate;
	/** 타임라인 모듈*/
	private String module;
	/** 타임라인 작성자 (일정관리는 enddate)*/
	private String writerName;
	/** 전자결재문서아이디*/
	private String apprID;
	/** 전자결재문서순번*/
	private String aprMemberSN;
	/** 게시판아이디*/
	private String boardID;
	/** 게시물아이디*/
	private String boardItemID;
	/** 게시판종류*/
	private String boardGuBun;
	/** 메일아이디*/
	private String mailID;
	/** 자원아이디*/
	private String resID;
	/** 자원넘버*/
	private int resNum;
	/** 일정아이디*/
	private String schID;
	/** 일정/자원 종료날짜*/
	private String endDate;
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getModule() {
		return module;
	}
	public void setModule(String module) {
		this.module = module;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getApprID() {
		return apprID;
	}
	public void setApprID(String apprID) {
		this.apprID = apprID;
	}
	public String getBoardID() {
		return boardID;
	}
	public void setBoardID(String boardID) {
		this.boardID = boardID;
	}
	public String getBoardItemID() {
		return boardItemID;
	}
	public void setBoardItemID(String boardItemID) {
		this.boardItemID = boardItemID;
	}
	public String getBoardGuBun() {
		return boardGuBun;
	}
	public void setBoardGuBun(String boardGuBun) {
		this.boardGuBun = boardGuBun;
	}
	public String getMailID() {
		return mailID;
	}
	public void setMailID(String mailID) {
		this.mailID = mailID;
	}
	public String getResID() {
		return resID;
	}
	public void setResID(String resID) {
		this.resID = resID;
	}
	public String getSchID() {
		return schID;
	}
	public void setSchID(String schID) {
		this.schID = schID;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public int getResNum() {
		return resNum;
	}
	public void setResNum(int resNum) {
		this.resNum = resNum;
	}
	public String getAprMemberSN() {
		return aprMemberSN;
	}
	public void setAprMemberSN(String aprMemberSN) {
		this.aprMemberSN = aprMemberSN;
	}
}

