package egovframework.ezEKP.ezCommunity.vo;

public class CommunityCBoardVO {
	/** 게시물일련번호*/
	int no;
	/** 작성자아이디*/
	String id;
	/** 작성자회사아이디*/
	String companyId;
	/** 작성자이름*/
	String userName;
	/** 작성자이름(다국어)*/
	String userName2;
	/** 통합게시판제목*/
	String title;
	/** CLOB통합게시판내용*/
	String content;
	/** 본문저장파일경로*/
	String contentUrl;
	/** 작성일시*/
	String writeDay;
	/** 관련 글 여부 */
	int ref;
	/** 관련글내의정렬순서*/
	int step;
	/** 댓글레벨*/
	int reLevel;
	/** 조회수*/
	int readNum;
	/** 사용안함*/
	int numM;
	/** 본문저장파일명*/
	String fileName;
	/** 커뮤니티번호 */
	String 	cClubNo;
	/** 커뮤니티내번호*/
	int cNo;
	/** CLOB첨부파일 이름*/
	String charFileName;
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
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
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
	public String getContentUrl() {
		return contentUrl;
	}
	public void setContentUrl(String contentUrl) {
		this.contentUrl = contentUrl;
	}
	public String getWriteDay() {
		return writeDay;
	}
	public void setWriteDay(String writeDay) {
		this.writeDay = writeDay;
	}
	public int getRef() {
		return ref;
	}
	public void setRef(int ref) {
		this.ref = ref;
	}
	public int getStep() {
		return step;
	}
	public void setStep(int step) {
		this.step = step;
	}
	public int getReLevel() {
		return reLevel;
	}
	public void setReLevel(int reLevel) {
		this.reLevel = reLevel;
	}
	public int getReadNum() {
		return readNum;
	}
	public void setReadNum(int readNum) {
		this.readNum = readNum;
	}
	public int getNumM() {
		return numM;
	}
	public void setNumM(int numM) {
		this.numM = numM;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getcClubNo() {
		return cClubNo;
	}
	public void setcClubNo(String cClubNo) {
		this.cClubNo = cClubNo;
	}
	public int getcNo() {
		return cNo;
	}
	public void setcNo(int cNo) {
		this.cNo = cNo;
	}
	public String getCharFileName() {
		return charFileName;
	}
	public void setCharFileName(String charFileName) {
		this.charFileName = charFileName;
	}
	
}
