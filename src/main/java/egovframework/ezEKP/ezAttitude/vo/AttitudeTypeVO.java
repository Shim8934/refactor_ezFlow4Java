package egovframework.ezEKP.ezAttitude.vo;

public class AttitudeTypeVO {
	/** 근태유형아이디 */
	private String typeId;
	/** 회사아이디 */
	private String companyId;
	/** 테넌트아이디 */
	private int tenantId;
	/** 유형명 */
	private String typeName;
	/** 유형명2 */
	private String typeName2;
	/** 사용여부*/
	private String isuse;
	/** 이미지경로 */
	private String imgPath;
	/** parentId*/
	private String parentId;
	/** 작성양식아이디*/
	private int formId;
	/** 타입 유형여부(기본/추가)*/
	private String isAdd;
	
	public String getTypeId() {
		return typeId;
	}
	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getTypeName() {
		return typeName;
	}
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	public String getTypeName2() {
		return typeName2;
	}
	public void setTypeName2(String typeName2) {
		this.typeName2 = typeName2;
	}
	public String getIsuse() {
		return isuse;
	}
	public void setIsuse(String isuse) {
		this.isuse = isuse;
	}
	public String getImgPath() {
		return imgPath;
	}
	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	public int getFormId() {
		return formId;
	}
	public void setFormId(int formId) {
		this.formId = formId;
	}
	public String getIsAdd() {
		return isAdd;
	}
	public void setIsAdd(String isAdd) {
		this.isAdd = isAdd;
	}
	
}
