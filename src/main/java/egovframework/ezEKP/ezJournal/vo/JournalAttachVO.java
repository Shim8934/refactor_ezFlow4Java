package egovframework.ezEKP.ezJournal.vo;

public class JournalAttachVO {
	/** 일지아이디 */
	private String journalId;
	/** 첨부파일 아이디*/
	private String fileId;
	/** 첨부파일 위치*/
	private String filePath;
	/** 첨부파일 사이즈(바이트단위)*/
	private String fileSize;
	/** 첨부파일 이름*/
	private String fileName;
	/** 인코딩 파일명*/
	private String encodeFileName;
	/** 인코딩 파일경로*/
	private String encodeFilePath;

	public String getJournalId() {
		return journalId;
	}
	public void setJournalId(String journalId) {
		this.journalId = journalId;
	}
	public String getFileId() {
		return fileId;
	}
	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getFileSize() {
		return fileSize;
	}
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getEncodeFileName() {
		return encodeFileName;
	}
	public void setEncodeFileName(String encodeFileName) {
		this.encodeFileName = encodeFileName;
	}
	public String getEncodeFilePath() {
		return encodeFilePath;
	}
	public void setEncodeFilePath(String encodeFilePath) {
		this.encodeFilePath = encodeFilePath;
	}
}
