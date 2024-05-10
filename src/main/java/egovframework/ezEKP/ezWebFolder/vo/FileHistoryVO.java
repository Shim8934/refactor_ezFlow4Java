package egovframework.ezEKP.ezWebFolder.vo;

public class FileHistoryVO {
	private String fileId;
	private String fileName;
	private String filePath;
	private String modifiedDate;
	private String modifiedAuthorName;
	private String modifiedAuthorName2;
	private long fileSize;
	private int version;

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

	public String getModifiedDate() {
		return modifiedDate;
	}

	public void setModifiedDate(String modifiedDate) {
		this.modifiedDate = modifiedDate;
	}

	public String getModifiedAuthorName() {
		return modifiedAuthorName;
	}

	public void setModifiedAuthorName(String modifiedAuthorName) {
		this.modifiedAuthorName = modifiedAuthorName;
	}

	public String getModifiedAuthorName2() {
		return modifiedAuthorName2;
	}

	public void setModifiedAuthorName2(String modifiedAuthorName2) {
		this.modifiedAuthorName2 = modifiedAuthorName2;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long size) {
		this.fileSize = size;
	}

	public int getVersion() {
		return version;
	}

	public void setVersion(int version) {
		this.version = version;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	@Override
	public String toString() {
		return "FileHistoryVO [fileId=" + fileId + ", fileName=" + fileName + ", filePath=" + filePath + ", modifiedDate=" + modifiedDate + ", modifiedAuthorName=" + modifiedAuthorName + ", modifiedAuthorName2="
				+ modifiedAuthorName2 + ", fileSize=" + fileSize + ", version=" + version + "]";
	}
}
