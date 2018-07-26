package egovframework.ezEKP.ezJournal.vo;

public class JournalInfoVO {

	private String journalId;
	private String journalTitle;
	private String journalContent;
	private String journalDate;
	private String isPublic;				/* 부서공유 여부 */
	private String writeId;
	private String writerName;
	private String deptName;
	private String formId;
	private String formName;
	private String typeId;
	private int replyCount;
	private int fileCount;
	private int viewCount;
	private int totalRecv;
	private int checkRecv;
	private String isView;
	private String mine;
	private String filePath;				/* 파일 경로 */
	private String hasAttach;				/* 파일첨부 유무 */
	private String hasReceiver;				/* 수신자 유무 */
	private String hasComment;				/* 댓글 유무 */
	
	public String getJournalId() {
		return journalId;
	}
	public void setJournalId(String journalId) {
		this.journalId = journalId;
	}
	public String getJournalTitle() {
		return journalTitle;
	}
	public void setJournalTitle(String journalTitle) {
		this.journalTitle = journalTitle;
	}
	public String getJournalContent() {
		return journalContent;
	}
	public void setJournalContent(String journalContent) {
		this.journalContent = journalContent;
	}
	public String getJournalDate() {
		return journalDate;
	}
	public void setJournalDate(String journalDate) {
		this.journalDate = journalDate;
	}
	public String getIsPublic() {
		return isPublic;
	}
	public void setIsPublic(String isPublic) {
		this.isPublic = isPublic;
	}
	public String getWriteId() {
		return writeId;
	}
	public void setWriteId(String writeId) {
		this.writeId = writeId;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getFormId() {
		return formId;
	}
	public void setFormId(String formId) {
		this.formId = formId;
	}
	public String getFormName() {
		return formName;
	}
	public void setFormName(String formName) {
		this.formName = formName;
	}
	public String getTypeId() {
		return typeId;
	}
	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}
	public int getReplyCount() {
		return replyCount;
	}
	public void setReplyCount(int replyCount) {
		this.replyCount = replyCount;
	}
	public int getFileCount() {
		return fileCount;
	}
	public void setFileCount(int fileCount) {
		this.fileCount = fileCount;
	}
	public int getViewCount() {
		return viewCount;
	}
	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}
	public int getTotalRecv() {
		return totalRecv;
	}
	public void setTotalRecv(int totalRecv) {
		this.totalRecv = totalRecv;
	}
	public int getCheckRecv() {
		return checkRecv;
	}
	public void setCheckRecv(int checkRecv) {
		this.checkRecv = checkRecv;
	}
	public String getIsView() {
		return isView;
	}
	public void setIsView(String isView) {
		this.isView = isView;
	}
	public String getMine() {
		return mine;
	}
	public void setMine(String mine) {
		this.mine = mine;
	}
	public String getHasAttach() {
		return hasAttach;
	}
	public void setHasAttach(String hasAttach) {
		this.hasAttach = hasAttach;
	}
	public String getHasReceiver() {
		return hasReceiver;
	}
	public void setHasReceiver(String hasReceiver) {
		this.hasReceiver = hasReceiver;
	}
	public String getHasComment() {
		return hasComment;
	}
	public void setHasComment(String hasComment) {
		this.hasComment = hasComment;
	}
	
}
