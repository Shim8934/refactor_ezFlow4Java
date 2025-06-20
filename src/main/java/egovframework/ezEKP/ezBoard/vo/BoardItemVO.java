package egovframework.ezEKP.ezBoard.vo;

public class BoardItemVO {
	/** */
	private String itemID;
	/** */
	private String mode;
	/** */
	private String conLocation;
	/** */
	private String title;
	/** */
	private int tenantID;
	/** */
	private String filePath;
	/** 2017.12.29 강민수92 추가 */
	private String boardID;

	private String addThumbnail;
	private String thumbnailExt;
	private String thumbnailPath;

	private String attachFilePath;
	private String attachFileName;
	private String satCallURL;
	private String writerID;

//	private String
	public String getItemID() {
		return itemID;
	}
	public void setItemID(String itemID) {
		this.itemID = itemID;
	}
	public String getMode() {
		return mode;
	}
	public void setMode(String mode) {
		this.mode = mode;
	}
	public String getConLocation() {
		return conLocation;
	}
	public void setConLocation(String conLocation) {
		this.conLocation = conLocation;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getBoardID() {
		return boardID;
	}
	public void setBoardID(String boardID) {
		this.boardID = boardID;
	}
	
	public String getAddThumbnail() {
		return addThumbnail;
	}
	public String getAttachFilePath() {
		return attachFilePath;
	}

	public void setAttachFilePath(String attachFilePath) {
		this.attachFilePath = attachFilePath;
	}

	public String getAttachFileName() {
		return attachFileName;
	}

	public void setAttachFileName(String attachFileName) {
		this.attachFileName = attachFileName;
	}

	public String getSatCallURL() {
		return satCallURL;
	}
	
	public void setSatCallURL(String satCallURL) {
		this.satCallURL = satCallURL;
	}
	
	public void setAddThumbnail(String addThumbnail) {
		this.addThumbnail = addThumbnail;
	}
	
	public String getThumbnailExt() {
		return thumbnailExt;
	}
	
	public void setThumbnailExt(String thumbnailExt) {
		this.thumbnailExt = thumbnailExt;
	}
	
	public String getThumbnailPath() {
		return thumbnailPath;
	}
	
	public void setThumbnailPath(String thumbnailPath) {
		this.thumbnailPath = thumbnailPath;
	}

	public String getWriterID() {
		return writerID;
	}

	public void setWriterID(String writerID) {
		this.writerID = writerID;
	}
}
