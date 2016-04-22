package egovframework.ezEKP.ezCommunity.vo;

/**
 * @author DC363
 *
 */
public class CommunityCBoardVO {
	/** 게시물일련번호*/
	int no;
	/** 작성자아이디*/
	String id;
	/** 작성자회사아이디*/
	String companyID;
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
	int re_Level;
	/** 조회수*/
	int readNum;
	/** 사용안함*/
	String numM;
	/** 본문저장파일명*/
	String fileName;
	/** 커뮤니티번호 */
	String 	c_ClubNo;
	/** 커뮤니티내번호*/
	int c_No;
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
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
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
	public int getRe_Level() {
		return re_Level;
	}
	public void setRe_Level(int re_Level) {
		this.re_Level = re_Level;
	}
	public int getReadNum() {
		return readNum;
	}
	public void setReadNum(int readNum) {
		this.readNum = readNum;
	}
	public String getNumM() {
		return numM;
	}
	public void setNumM(String numM) {
		this.numM = numM;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getC_ClubNo() {
		return c_ClubNo;
	}
	public void setC_ClubNo(String c_ClubNo) {
		this.c_ClubNo = c_ClubNo;
	}
	public int getC_No() {
		return c_No;
	}
	public void setC_No(int c_No) {
		this.c_No = c_No;
	}
	public String getCharFileName() {
		return charFileName;
	}
	public void setCharFileName(String charFileName) {
		this.charFileName = charFileName;
	}
	@Override
	public String toString() {
		return "CommunityCBoardVO [no=" + no + ", id=" + id + ", companyID="
				+ companyID + ", userName=" + userName + ", userName2="
				+ userName2 + ", title=" + title + ", content=" + content
				+ ", contentUrl=" + contentUrl + ", writeDay=" + writeDay
				+ ", ref=" + ref + ", step=" + step + ", re_Level=" + re_Level
				+ ", readNum=" + readNum + ", numM=" + numM + ", fileName="
				+ fileName + ", c_ClubNo=" + c_ClubNo + ", c_No=" + c_No
				+ ", charFileName=" + charFileName + "]";
	}
	
}
