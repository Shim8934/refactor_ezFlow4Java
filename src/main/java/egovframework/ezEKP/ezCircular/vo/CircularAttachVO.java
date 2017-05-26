package egovframework.ezEKP.ezCircular.vo;

public class CircularAttachVO {
	
	private int		circularFileId;
	private long 	fileSize;
	private String 	fileName;
	private String 	filePath;
	private String 	fileType;
	private String	fileEncodeName;
	private String	fileTranSize;
	
	public int getCircularFileId() {
		return circularFileId;
	}
	public void setCircularFileId(int circularFileId) {
		this.circularFileId = circularFileId;
	}
	public long getFileSize() {
		return fileSize;
	}
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
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
	public String getFileTranSize() {
		return fileTranSize;
	}
	public void setFileTranSize(String fileTranSize) {
		this.fileTranSize = fileTranSize;
	}
}
