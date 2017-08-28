package egovframework.ezEKP.ezTask.vo;

public class TaskAttachVO {
	/** 파일명 */
	private String fileName;
	/** 파일경로 */
	private String filePath;
	/** 파일사이즈 */
	private String fileSize;
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
	public String getFileSize() {
		return fileSize;
	}
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
}
