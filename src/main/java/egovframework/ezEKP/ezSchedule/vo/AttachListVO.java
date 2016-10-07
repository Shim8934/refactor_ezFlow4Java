package egovframework.ezEKP.ezSchedule.vo;

public class AttachListVO {
	private long attachId;
	private long fileSize;
	private String fileName;
	private String filePath;
	/**
	 * @return the attachId
	 */
	public long getAttachId() {
		return attachId;
	}
	/**
	 * @param attachId the attachId to set
	 */
	public void setAttachId(long attachId) {
		this.attachId = attachId;
	}
	/**
	 * @return the fileSize
	 */
	public long getFileSize() {
		return fileSize;
	}
	/**
	 * @param fileSize the fileSize to set
	 */
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
	/**
	 * @return the fileName
	 */
	public String getFileName() {
		return fileName;
	}
	/**
	 * @param fileName the fileName to set
	 */
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	/**
	 * @return the filePath
	 */
	public String getFilePath() {
		return filePath;
	}
	/**
	 * @param filePath the filePath to set
	 */
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
}
