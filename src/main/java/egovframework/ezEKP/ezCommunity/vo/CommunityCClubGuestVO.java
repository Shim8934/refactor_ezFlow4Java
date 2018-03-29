package egovframework.ezEKP.ezCommunity.vo;

public class CommunityCClubGuestVO {
	/** 일련번호*/
	int no;
	/** 작성자아이디*/
	String id;
	/** 작성자이름*/
	String userName;
	/** 작성자이름(다국어)*/
	String userName2;
	/** 작성자회사아이디*/
	String companyID;
	/** 제목(사용안함)*/
	String title;
	/** 내용(CLOB)*/
	String content;
	/** 커뮤니티링크*/
	String contentURL;
	/** 조회수(사용안함)*/
	String readNum;
	/** 작성일시*/
	String writeDay;
	/** 커뮤니티별일련번호*/
	String c_No;
	/** 커뮤니티번호*/
	String c_clubNo;
	
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserName2() {
		return userName2;
	}
	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
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
	public String getContentURL() {
		return contentURL;
	}
	public void setContentURL(String contentURL) {
		this.contentURL = contentURL;
	}
	public String getReadNum() {
		return readNum;
	}
	public void setReadNum(String readNum) {
		this.readNum = readNum;
	}
	public String getWriteDay() {
		return writeDay;
	}
	public void setWriteDay(String writeDay) {
		this.writeDay = writeDay;
	}
	public String getC_No() {
		return c_No;
	}
	public void setC_No(String c_No) {
		this.c_No = c_No;
	}
	public String getC_clubNo() {
		return c_clubNo;
	}
	public void setC_clubNo(String c_clubNo) {
		this.c_clubNo = c_clubNo;
	}
}
