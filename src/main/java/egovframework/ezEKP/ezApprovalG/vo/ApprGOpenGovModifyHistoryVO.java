package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGOpenGovModifyHistoryVO {
    /**
     * 문서아이디
     */
    private String docID;
    /**
     * 변경자 이름
     */
    private String modifierName;
    /**
     * 변경자 부서명
     */
    private String modifierDeptName;
    /**
     * 변경일자
     */
    private String modifyDate;
    /**
     * 변경사유
     */
    private String modifyReason;
    /**
     * 순서
     */
    private int SN;

    public String getDocID() {
        return docID;
    }

    public void setDocID(String docID) {
        this.docID = docID;
    }

    public String getModifierName() {
        return modifierName;
    }

    public void setModifierName(String modifierName) {
        this.modifierName = modifierName;
    }

    public String getModifierDeptName() {
        return modifierDeptName;
    }

    public void setModifierDeptName(String modifierDeptName) {
        this.modifierDeptName = modifierDeptName;
    }

    public String getModifyDate() {
        return modifyDate;
    }

    public void setModifyDate(String modifyDate) {
        this.modifyDate = modifyDate;
    }

    public String getModifyReason() {
        return modifyReason;
    }

    public void setModifyReason(String modifyReason) {
        this.modifyReason = modifyReason;
    }

    public int getSN() {
        return SN;
    }

    public void setSN(int SN) {
        this.SN = SN;
    }
}
