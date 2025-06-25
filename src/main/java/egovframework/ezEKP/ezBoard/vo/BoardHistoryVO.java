package egovframework.ezEKP.ezBoard.vo;

public class BoardHistoryVO {
    private String boardID;
    private String itemID;
    private String parentItemID;
    private String version;
    private String modifyUserID;
    private String modifyUserName;
    private String modifiedDate;
    private String contentLocation;

    public String getBoardID() {
        return boardID;
    }

    public void setBoardID(String boardID) {
        this.boardID = boardID;
    }

    public String getItemID() {
        return itemID;
    }

    public void setItemID(String itemID) {
        this.itemID = itemID;
    }

    public String getParentItemID() {
        return parentItemID;
    }

    public void setParentItemID(String parentItemID) {
        this.parentItemID = parentItemID;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getModifyUserID() {
        return modifyUserID;
    }

    public void setModifyUserID(String modifyUserID) {
        this.modifyUserID = modifyUserID;
    }

    public String getModifyUserName() {
        return modifyUserName;
    }

    public void setModifyUserName(String modifyUserName) {
        this.modifyUserName = modifyUserName;
    }

    public String getModifiedDate() {
        return modifiedDate;
    }

    public void setModifiedDate(String modifiedDate) {
        this.modifiedDate = modifiedDate;
    }

    public String getContentLocation() {
        return contentLocation;
    }

    public void setContentLocation(String contentLocation) {
        this.contentLocation = contentLocation;
    }
}
