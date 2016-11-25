package egovframework.ezEKP.ezOrgan.vo;

public class OrganDeptVO {
	/** 부모 회사/부서*/
	private String parentCn;
	/** 회사/부서아이디*/
	private String cn;
	/** 회사/부서명*/
	private String department;
	/** 부서명*/
	private String displayName;
	/** 부서명(다국어)*/
	private String displayName1;
	/** 부서명(다국어)*/
	private String displayName2;
	/** 부서명(다국어)*/
	private String deptNM;
	/** 메일주소*/
	private String mail;
	/** 상위부서ID*/
	private String extensionAttribute1;
	/** 회사ID*/
	private String extensionAttribute2;
	/** 회사명*/
	private String extensionAttribute3;
	/** 문서과ID*/
	private String extensionAttribute4;
	/** 발신명의*/
	private String extensionAttribute5;
	/** 부서약어*/
	private String extensionAttribute6;
	/** 관인경로*/
	private String extensionAttribute7;
	/** 기관여부*/
	private String extensionAttribute8;
	/** 부서장ID*/
	private String extensionAttribute9;
	/** DocSymBol*/
	private String extensionAttribute10;
	/** */
	private String extensionAttribute11;
	/** */
	private String extensionAttribute12;
	/** */
	private String extensionAttribute13;
	/** */
	private String extensionAttribute14;
	/** 정렬순서값*/
	private String extensionAttribute15;
	/** LDAP 경로*/
	private String adsPath;
	/** 최종업데이트일자*/
	private String updateDT;
	/** dept*/
	private String type;
	
    /** 사용자가 속한 Tenant의 고유 ID */
    private int tenantId = -1;
	
	public String getCn() {
		return cn;
	}
	public void setCn(String cn) {
		this.cn = cn;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}	
	public String getDisplayName() {
		return displayName;
	}
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
	public String getDisplayName1() {
		return displayName1;
	}
	public void setDisplayName1(String displayName1) {
		this.displayName1 = displayName1;
	}
	public String getDisplayName2() {
		return displayName2;
	}
	public void setDisplayName2(String displayName2) {
		this.displayName2 = displayName2;
	}
	public String getDeptNM() {
		return deptNM;
	}
	public void setDeptNM(String deptNM) {
		this.deptNM = deptNM;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public String getExtensionAttribute1() {
		return extensionAttribute1;
	}
	public void setExtensionAttribute1(String extensionAttribute1) {
		this.extensionAttribute1 = extensionAttribute1;
	}
	public String getExtensionAttribute2() {
		return extensionAttribute2;
	}
	public void setExtensionAttribute2(String extensionAttribute2) {
		this.extensionAttribute2 = extensionAttribute2;
	}
	public String getExtensionAttribute3() {
		return extensionAttribute3;
	}
	public void setExtensionAttribute3(String extensionAttribute3) {
		this.extensionAttribute3 = extensionAttribute3;
	}
	public String getExtensionAttribute4() {
		return extensionAttribute4;
	}
	public void setExtensionAttribute4(String extensionAttribute4) {
		this.extensionAttribute4 = extensionAttribute4;
	}
	public String getExtensionAttribute5() {
		return extensionAttribute5;
	}
	public void setExtensionAttribute5(String extensionAttribute5) {
		this.extensionAttribute5 = extensionAttribute5;
	}
	public String getExtensionAttribute6() {
		return extensionAttribute6;
	}
	public void setExtensionAttribute6(String extensionAttribute6) {
		this.extensionAttribute6 = extensionAttribute6;
	}
	public String getExtensionAttribute7() {
		return extensionAttribute7;
	}
	public void setExtensionAttribute7(String extensionAttribute7) {
		this.extensionAttribute7 = extensionAttribute7;
	}
	public String getExtensionAttribute8() {
		return extensionAttribute8;
	}
	public void setExtensionAttribute8(String extensionAttribute8) {
		this.extensionAttribute8 = extensionAttribute8;
	}
	public String getExtensionAttribute9() {
		return extensionAttribute9;
	}
	public void setExtensionAttribute9(String extensionAttribute9) {
		this.extensionAttribute9 = extensionAttribute9;
	}
	public String getExtensionAttribute10() {
		return extensionAttribute10;
	}
	public void setExtensionAttribute10(String extensionAttribute10) {
		this.extensionAttribute10 = extensionAttribute10;
	}
	public String getExtensionAttribute11() {
		return extensionAttribute11;
	}
	public void setExtensionAttribute11(String extensionAttribute11) {
		this.extensionAttribute11 = extensionAttribute11;
	}
	public String getExtensionAttribute12() {
		return extensionAttribute12;
	}
	public void setExtensionAttribute12(String extensionAttribute12) {
		this.extensionAttribute12 = extensionAttribute12;
	}
	public String getExtensionAttribute13() {
		return extensionAttribute13;
	}
	public void setExtensionAttribute13(String extensionAttribute13) {
		this.extensionAttribute13 = extensionAttribute13;
	}
	public String getExtensionAttribute14() {
		return extensionAttribute14;
	}
	public void setExtensionAttribute14(String extensionAttribute14) {
		this.extensionAttribute14 = extensionAttribute14;
	}
	public String getExtensionAttribute15() {
		return extensionAttribute15;
	}
	public void setExtensionAttribute15(String extensionAttribute15) {
		this.extensionAttribute15 = extensionAttribute15;
	}
	public String getAdsPath() {
		return adsPath;
	}
	public void setAdsPath(String adsPath) {
		this.adsPath = adsPath;
	}
	public String getUpdateDT() {
		return updateDT;
	}
	public void setUpdateDT(String updateDT) {
		this.updateDT = updateDT;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getParentCn() {
		return parentCn;
	}
	public void setParentCn(String parentCn) {
		this.parentCn = parentCn;
	}

    public int getTenantId() {
        return tenantId;
    }
    
    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }
	
}
