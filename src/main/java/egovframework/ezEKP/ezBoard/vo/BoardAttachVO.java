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
	/** 행번호*/
	private int rnum;
	/** 이미지갯수*/
	private int imageCount;
	/** 이미지아이디*/
	private String imageID;
	/** 파일컨탠츠*/
	private String fileContent;
	/** 메인플래그*/
	private String flag;
	/** 이미지명*/
	private String imageName;
	
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
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	public int getImageCount() {
		return imageCount;
	}
	public void setImageCount(int imageCount) {
		this.imageCount = imageCount;
	}
	public String getImageID() {
		return imageID;
	}
	public void setImageID(String imageID) {
		this.imageID = imageID;
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
	public String getImageName() {
		return imageName;
	}
	public void setImageName(String imageName) {
		this.imageName = imageName;
	}
}
