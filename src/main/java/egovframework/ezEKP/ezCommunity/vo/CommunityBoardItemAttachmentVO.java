package egovframework.ezEKP.ezCommunity.vo;

public class CommunityBoardItemAttachmentVO {
	/* 게시물아이디*/
	String itemID;
	/* 게시물 GUID*/
	String guID;
	/* 첨부파일위치*/
	String filePath;
	/* 첨부파일사이즈(바이트단위)*/
	String fileSize;
	/* 첨부파일 이름*/
	String fileName;
	
	public String getItemID() {
		return itemID;
	}
	public void setItemID(String itemID) {
		this.itemID = itemID;
	}
	public String getGuID() {
		return guID;
	}
	public void setGuID(String guID) {
		this.guID = guID;
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
