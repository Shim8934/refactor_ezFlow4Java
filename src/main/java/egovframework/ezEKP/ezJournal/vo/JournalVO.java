package egovframework.ezEKP.ezJournal.vo;

public class JournalVO {

	private String journalId;
	private String journalTitle;
	private String journalDate;
	private String deptShare;
	private String writerName;
	private String deptName;
	private String formName;
	private String typeId;
	private int replyCount;
	private int fileCount;
	private int viewCount;
	private int totalRecv;
	private int checkRecv;
	private String isView;
	
	public String getIsView() {
		return isView;
	}
	public void setIsView(String isView) {
		this.isView = isView;
	}
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
	public String getJournalDate() {
		return journalDate;
	}
	public void setJournalDate(String journalDate) {
		this.journalDate = journalDate;
	}
	public String getDeptShare() {
		return deptShare;
	}
	public void setDeptShare(String deptShare) {
		this.deptShare = deptShare;
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
}
