package egovframework.ezEKP.ezJournal.vo;

import java.util.List;

public class JournalVO {

	private String journalId;
	private String journalTitle;
	private String journalContent;
	private String journalDate;
	private String deptShare;
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
	private String writerId;
	private List<JournalFileVO> fileList;
	private String thisContent;
	private String nextContent;
	private String formStatus;
	private String isSum;
	private String userImage;
	
	public String getUserImage() {
		return userImage;
	}
	public void setUserImage(String userImage) {
		this.userImage = userImage;
	}
	public String getFormStatus() {
		return formStatus;
	}
	public void setFormStatus(String formStatus) {
		this.formStatus = formStatus;
	}
	public String getThisContent() {
		return thisContent;
	}
	public void setThisContent(String thisContent) {
		this.thisContent = thisContent;
	}
	public String getNextContent() {
		return nextContent;
	}
	public void setNextContent(String nextContent) {
		this.nextContent = nextContent;
	}
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}
	public String getMine() {
		return mine;
	}
	public void setMine(String mine) {
		this.mine = mine;
	}
	public List<JournalFileVO> getFileList() {
		return fileList;
	}
	public void setFileList(List<JournalFileVO> fileList) {
		this.fileList = fileList;
	}
	public String getJournalContent() {
		return journalContent;
	}
	public void setJournalContent(String journalContent) {
		this.journalContent = journalContent;
	}
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
	public String getIsSum() {
		return isSum;
	}
	public void setIsSum(String isSum) {
		this.isSum = isSum;
	}
}
