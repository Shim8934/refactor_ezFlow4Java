package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGSummaryVO {
    String docID;
    String companyID;
    int tenant_ID;
    String summary; // 요약 본문정보
    String summaryPath; // 요약 mht 저장경로
    String mode; // Query 구분용 ; APR(진행중문서) / END(완료문서)로 구분

    public ApprGSummaryVO() {
    }

    public ApprGSummaryVO(String docID, String companyID, int tenantID, String summary, String summaryPath) {
        this.docID = docID;
        this.companyID = companyID;
        this.tenant_ID = tenantID;
        this.summary = summary;
        this.summaryPath = summaryPath;
    }

    public String getDocID() {
        return docID;
    }

    public void setDocID(String docID) {
        this.docID = docID;
    }

    public String getCompanyID() {
        return companyID;
    }

    public void setCompanyID(String companyID) {
        this.companyID = companyID;
    }

    public int getTenantID() {
        return tenant_ID;
    }

    public void setTenantID(int tenantID) {
        this.tenant_ID = tenantID;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getSummaryPath() {
        return summaryPath;
    }

    public void setSummaryPath(String summaryPath) {
        this.summaryPath = summaryPath;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }
}
