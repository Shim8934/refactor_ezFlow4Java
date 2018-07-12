package egovframework.ezEKP.ezLadder.vo;

public class LadderVO {
	
	private int tenant_id;
	/** 게임 아이디 */ 
	private int ladderId;
	/** 게임 제목 */
	private String title;
	/** 게임 종류 */
	private int type;
	/** 게임 상태 */
	private int status;
	/** 게임 공개 옵션 */
	private int secretFlag;
	/** 게임 작성자 아이디 */
	private String writerId;
	/** 게임 작성자 이름 */
	private String writerName;
	/** 게임 작성자 이름(다국어) */
	private String writerName2;
	/** 게임 작성자 부서 이름 */
	private String deptName;
	/** 게임 작성자 부서 이름(다국어)*/
	private String deptName2;
	/** 사다리 선 갯수 */
	private int lineCnt;
	/** 사다리 그려질 선에 대한 정보 */
	private String lineArray;
	/** 삭제 플래그 */
	private int deleteFlag;
	/** 게임 작성 날짜 */
	private String writeDate;
	/** 게임 시작 날짜 */
	private String startDate;
	/** 게임 삭제 날짜 */ 
	private String deleteDate;
	/** 다국어 */
	private String lang;
	/** offset*/
	private String offset;
	/** 사용자 아이디*/
	private String userId;
	private String pic;
	/** 댓글 갯수 */
	private int cmt;
	/** 생성 24시간 여부*/
	private int newFlag;
	
	
	public int getTenant_id() {
		return tenant_id;
	}
	public void setTenant_id(int tenant_id) {
		this.tenant_id = tenant_id;
	}
	public int getLadderId() {
		return ladderId;
	}
	public void setLadderId(int ladderId) {
		this.ladderId = ladderId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public void setType(String type) {
		this.type = Integer.parseInt(type);
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public void setStatus(String status) {
		this.status = Integer.parseInt(status);
	}
	public int getSecretFlag() {
		return secretFlag;
	}
	public void setSecretFlag(int secretFlag) {
		this.secretFlag = secretFlag;
	}
	public void setSecretFlag(String secretFlag) {
		this.secretFlag = Integer.parseInt(secretFlag);
	}
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getWriterName2() {
		return writerName2;
	}
	public void setWriterName2(String writerName2) {
		this.writerName2 = writerName2;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getDeptName2() {
		return deptName2;
	}
	public void setDeptName2(String deptName2) {
		this.deptName2 = deptName2;
	}
	public int getLineCnt() {
		return lineCnt;
	}
	public void setLineCnt(int lineCnt) {
		this.lineCnt = lineCnt;
	}
	public void setLineCnt(String lineCnt) {
		this.lineCnt = Integer.parseInt(lineCnt);
	}
	public String getLineArray() {
		return lineArray;
	}
	public void setLineArray(String lineArray) {
		this.lineArray = lineArray;
	}
	public int getDeleteFlag() {
		return deleteFlag;
	}
	public void setDeleteFlag(int deleteFlag) {
		this.deleteFlag = deleteFlag;
	}
	public String getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getDeleteDate() {
		return deleteDate;
	}
	public void setDeleteDate(String deleteDate) {
		this.deleteDate = deleteDate;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	
	public String getOffset() {
		return offset;
	}
	public void setOffset(String offset) {
		this.offset = offset;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getPic() {
		return pic;
	}
	public void setPic(String pic) {
		this.pic = pic == null ? "" : pic;
	}
	public int getCmt() {
		return cmt;
	}
	public void setCmt(int cmt) {
		this.cmt = cmt;
	}
	public int getNewFlag() {
		return newFlag;
	}
	public void setNewFlag(int newFlag) {
		this.newFlag = newFlag;
	}
}
