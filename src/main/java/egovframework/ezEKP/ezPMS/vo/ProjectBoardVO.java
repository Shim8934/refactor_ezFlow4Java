package egovframework.ezEKP.ezPMS.vo;

// 게시판 관련 VO
public class ProjectBoardVO {
	// 게시물 아이디
	private int itemId;
	
	// 테넌트 아이디
	private int tenantId;
	
	// 게시자 아이디
	private Long writerId;
	
	// 제목
	private String title;
	
	// 게시 개요
	private String writeOverview;
	
	// 게시 종류
	private int writeType;
	
	// 게시 내용
	private String writeContent;
	
	// 게시일
	private String writeDate;
	
	// 게시 수정일
	private String writeUpdateDate;
	
	// 조회수
	private int readCount;
	
	// 업무 아이디
	private Long taskId;
	
	// 그룹 아이디
	private Long groupId;
	
	// 게시자 명
	private String writerName;
	
	// 게시자 명 다국어
	private String writerName2;
	
	// 게시자 부서
	private String writerDeptName;
	
	// 게시자 부서 다국어
	private String writerDeptName2;
	
	// 게시자 직위
	private String writerPosition;
	
	// 게시자 직위 다국어
	private String writerPosition2;

	public int getItemId() {
		return itemId;
	}

	public void setItemId(int itemId) {
		this.itemId = itemId;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}

	public Long getWriterId() {
		return writerId;
	}

	public void setWriterId(Long writerId) {
		this.writerId = writerId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getWriteOverview() {
		return writeOverview;
	}

	public void setWriteOverview(String writeOverview) {
		this.writeOverview = writeOverview;
	}

	public int getWriteType() {
		return writeType;
	}

	public void setWriteType(int writeType) {
		this.writeType = writeType;
	}

	public String getWriteContent() {
		return writeContent;
	}

	public void setWriteContent(String writeContent) {
		this.writeContent = writeContent;
	}

	public String getWriteDate() {
		return writeDate;
	}

	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}

	public String getWriteUpdateDate() {
		return writeUpdateDate;
	}

	public void setWriteUpdateDate(String writeUpdateDate) {
		this.writeUpdateDate = writeUpdateDate;
	}

	public int getReadCount() {
		return readCount;
	}

	public void setReadCount(int readCount) {
		this.readCount = readCount;
	}

	public Long getTaskId() {
		return taskId;
	}

	public void setTaskId(Long taskId) {
		this.taskId = taskId;
	}

	public Long getGroupId() {
		return groupId;
	}

	public void setGroupId(Long groupId) {
		this.groupId = groupId;
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

	public String getWriterDeptName() {
		return writerDeptName;
	}

	public void setWriterDeptName(String writerDeptName) {
		this.writerDeptName = writerDeptName;
	}

	public String getWriterDeptName2() {
		return writerDeptName2;
	}

	public void setWriterDeptName2(String writerDeptName2) {
		this.writerDeptName2 = writerDeptName2;
	}

	public String getWriterPosition() {
		return writerPosition;
	}

	public void setWriterPosition(String writerPosition) {
		this.writerPosition = writerPosition;
	}

	public String getWriterPosition2() {
		return writerPosition2;
	}

	public void setWriterPosition2(String writerPosition2) {
		this.writerPosition2 = writerPosition2;
	}
	
	
	
}
