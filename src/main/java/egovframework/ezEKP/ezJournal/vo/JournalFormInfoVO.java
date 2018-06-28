package egovframework.ezEKP.ezJournal.vo;

import java.util.List;

public class JournalFormInfoVO {
	
	/** 일지함아이디 */
	private String typeId;
	/** 양식아이디 */
	private String formId;
	/** 양식이름 */
	private String formName;
	/** 양식설명 */
	private String formInfo;
	/** 양식내용 */
	private String formContent;
	/** 양식작성일 */
	private String formDate;
	/** 양식작성자 */
	private String formWriter;
	/** 양식Flag(기본양식유무) */
	private String formStatus;
	/** 양식사용부서아이디 */
	private List<DeptInfoVO> depts;
	/** 회사아이디 */
	private String companyId;
	/** 테넌트아이디 */
	private int tenantId;
	
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public String getTypeId() {
		return typeId;
	}
	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}
	public String getFormId() {
		return formId;
	}
	public void setFormId(String formId) {
		this.formId = formId;
	}
	public String getFormName() {
		return formName;
	}
	public void setFormName(String formName) {
		this.formName = formName;
	}
	public String getFormInfo() {
		return formInfo;
	}
	public void setFormInfo(String formInfo) {
		this.formInfo = formInfo;
	}
	public String getFormContent() {
		return formContent;
	}
	public void setFormContent(String formContent) {
		this.formContent = formContent;
	}
	public String getFormDate() {
		return formDate;
	}
	public void setFormDate(String formDate) {
		this.formDate = formDate;
	}
	public String getFormWriter() {
		return formWriter;
	}
	public void setFormWriter(String formWriter) {
		this.formWriter = formWriter;
	}
	public String getFormStatus() {
		return formStatus;
	}
	public void setFormStatus(String formStatus) {
		this.formStatus = formStatus;
	}
	public List<DeptInfoVO> getDepts() {
		return depts;
	}
	public void setDepts(List<DeptInfoVO> depts) {
		this.depts = depts;
	}
	
	
}
