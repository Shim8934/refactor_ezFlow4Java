package egovframework.ezEKP.ezBoard.vo;

public class BoardReplyAttachVO {
    /** 게시물아이디 */
	private String itemID;
    /** 댓글 아이디*/
    private String replyID;
	/** 첨부파일 GUID*/
	private String guid;
	/** 첨부파일 위치*/
	private String filePath;
	/** 첨부파일 사이즈(바이트단위)*/
	private String fileSize;
	/** 첨부파일 이름*/
	private String fileName;
	/** 순번 */
	private String sn;

    public String getItemID() {
        return itemID;
    }

    public void setItemID(String itemID) {
        this.itemID = itemID;
    }

    public String getReplyID() {
        return replyID;
    }

    public void setReplyID(String replyID) {
        this.replyID = replyID;
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

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }
}
