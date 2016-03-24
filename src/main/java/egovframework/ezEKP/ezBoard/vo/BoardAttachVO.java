package egovframework.ezEKP.ezBoard.vo;

public class BoardAttachVO {
	/** 게시물아이디 */
	private String itemID;
	/** 첨부파일 GUID*/
	private String guid;
	/** 첨부파일 위치*/
	private String filePath;
	/** 첨부파일 사이즈(바이트단위)*/
	private String fileSize;
	/** 첨부파일 이름*/
	private String fileName;
	
	public String getItemID() {
		return itemID;
	}
	public void setItemID(String itemID) {
		this.itemID = itemID;
	}
	public String getGuid() {
		return guid;
	}
	public void setGuid(String guid) {
		this.guid = guid;
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

}
