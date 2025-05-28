package egovframework.ezEKP.ezBoard.vo;

public class BoardKeywordVO {
    /** 키워드ID */
    String keywordId;
    /** 키워드이름 */
    String keywordName;
    /** 게시판ID */
    String boardId;
    /** 게시물ID */
    String itemId;
    /** 테넌트ID */
    int tenant_id;
    /** 순번 */
    int sn;
    
    public BoardKeywordVO(String keywordId, String keywordName, String boardId, String itemId, int tenant_id, int sn) {
        this.keywordId = keywordId;
        this.keywordName = keywordName;
        this.boardId = boardId;
        this.itemId = itemId;
        this.tenant_id = tenant_id;
        this.sn = sn;
    }

    public BoardKeywordVO() {}

    public String getKeywordId() {
        return keywordId;
    }

    public void setKeywordId(String keywordId) {
        this.keywordId = keywordId;
    }

    public String getKeywordName() {
        return keywordName;
    }

    public void setKeywordName(String keywordName) {
        this.keywordName = keywordName;
    }

    public String getBoardId() {
        return boardId;
    }

    public void setBoardId(String boardId) {
        this.boardId = boardId;
    }

    public String getItemId() {
        return itemId;
    }

    public void setItemId(String itemId) {
        this.itemId = itemId;
    }

    public int getTenant_id() {
        return tenant_id;
    }

    public void setTenant_id(int tenantId) {
        this.tenant_id = tenantId;
    }

    public int getSn() {
        return sn;
    }

    public void setSn(int sn) {
        this.sn = sn;
    }
}