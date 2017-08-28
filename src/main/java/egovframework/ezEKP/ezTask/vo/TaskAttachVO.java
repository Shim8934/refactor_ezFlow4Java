package egovframework.ezEKP.ezTask.vo;

public class TaskAttachVO {
	/** 업무ID */
	private String taskID;
	/** 파일ID */
	private String attachID;
	/** 파일명 */
	private String fileName;
	/** 파일경로 */
	private String filePath;
	/** 파일사이즈 */
	private String fileSize;
	public String getTaskID() {
		return taskID;
	}
	public void setTaskID(String taskID) {
		this.taskID = taskID;
	}
	public String getAttachID() {
		return attachID;
	}
	public void setAttachID(String attachID) {
		this.attachID = attachID;
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
	public String getFileSize() {
		return fileSize;
	}
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
}
