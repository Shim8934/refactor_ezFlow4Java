package egovframework.ezEKP.ezJournal.vo;

public class JournalFileVO {

	private String filePath;
	private Long fileSize;
	private String fileName;
	private String fileType;
	private String fileEncodeName;
	private String fileTransSize;
	
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public Long getFileSize() {
		return fileSize;
	}
	public void setFileSize(Long fileSize) {
		this.fileSize = fileSize;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getFileEncodeName() {
		return fileEncodeName;
	}
	public void setFileEncodeName(String fileEncodeName) {
		this.fileEncodeName = fileEncodeName;
	}
	public String getFileTransSize() {
		return fileTransSize;
	}
	public void setFileTransSize(String fileTransSize) {
		this.fileTransSize = fileTransSize;
	}
	
}
