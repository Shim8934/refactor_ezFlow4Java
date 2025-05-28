package egovframework.ezEKP.ezSurvey.vo;

public class ResultViewPermissionVO {
    
    /** 설문 아이디 */
    private long survey_id;
    /** 회사 아이디 */
    private String company_id;
    /** 테넌트 아이디 */
    private int tenant_id;
    /** 권한자 아이디 */
    private String cn;
    /** 권한자 이름 */
    private String cnName;
    /** 권한자 이름 */
    private String cnName2;
    /** 권한자 타입 */
    private String user_type;
    /** 하위부서 권한 여부(Y/N)*/
    private String subdept_permitted;

    public long getSurvey_id() {
        return survey_id;
    }
    public void setSurvey_id(long survey_id) {
        this.survey_id = survey_id;
    }
    public String getCompany_id() {
        return company_id;
    }
    public void setCompany_id(String company_id) {
        this.company_id = company_id;
    }
    public int getTenant_id() {
        return tenant_id;
    }
    public void setTenant_id(int tenant_id) {
        this.tenant_id = tenant_id;
    }
    public String getCn() {
        return cn;
    }
    public void setCn(String cn) {
        this.cn = cn;
    }
    public String getUser_type() {
        return user_type;
    }
    public void setUser_type(String user_type) {
        this.user_type = user_type;
    }
    public String getSubdept_permitted() {
        return subdept_permitted;
    }
    public void setSubdept_permitted(String subdept_permitted) {
        this.subdept_permitted = subdept_permitted;
    }
    public String getCnName() {
        return cnName;
    }
    public void setCnName(String cnName) {
        this.cnName = cnName;
    }
    public String getCnName2() {
        return cnName2;
    }
    public void setCnName2(String cnName2) {
        this.cnName2 = cnName2;
    }
}

