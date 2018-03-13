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
	/** 행번호*/
	private int rnum;
	/** 파일컨탠츠*/
	private String fileContent;
	/** 메인플래그*/
	private String flag;
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
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	public String getFileContent() {
		return fileContent;
	}
	public void setFileContent(String fileContent) {
		this.fileContent = fileContent;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
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
