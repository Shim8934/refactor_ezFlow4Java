package egovframework.ezEKP.ezAttitude.vo;

public class AttitudeFormVO {
	/** 작성양식 아이디 */
	private int formId;
	/** 테넌트 아이디*/
	private int tenantId;
	/** 작성양식명 */
	private String formName;
	/** 작성양식명2 */
	private String formName2;
	/** 작성양식html */
	private String formHtml;
	
	public int getFormId() {
		return formId;
	}
	public void setFormId(int formId) {
		this.formId = formId;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getFormName() {
		return formName;
	}
	public void setFormName(String formName) {
		this.formName = formName;
	}
	public String getFormName2() {
		return formName2;
	}
	public void setFormName2(String formName2) {
		this.formName2 = formName2;
	}
	public String getFormHtml() {
		return formHtml;
	}
	public void setFormHtml(String formHtml) {
		this.formHtml = formHtml;
	}
	
	

}
