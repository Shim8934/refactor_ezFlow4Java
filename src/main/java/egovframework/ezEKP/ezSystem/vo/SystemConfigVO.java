package egovframework.ezEKP.ezSystem.vo;

public class SystemConfigVO {
	/** CODE */
	private String code;
	/** CODEVALUE */
	private String codeValue;
	/** DESCRIPTION */
	private String description;
	/** WRITERID */
	private String writerid;
	/** WRITERNAME */
	private String writername;
	/** WRITEDATE */
	private String writedate;
	
	private String typeCode;
	
	private String typeName;
	
	private String typeName2;
	
	private int tenantId;
	
	private String companyId;
	
	private String isDeleteBlock;
	
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	
	public String getCodeValue() {
		return codeValue;
	}

	public void setCodeValue(String codeValue) {
		this.codeValue = codeValue;
	}

	
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	
	public String getWriterid() {
		return writerid;
	}

	public void setWriterid(String writerid) {
		this.writerid = writerid;
	}

	public String getWritername() {
		return writername;
	}

	public void setWritername(String writername) {
		this.writername = writername;
	}
	
	public String getWritedate() {
		return writedate;
	}

	public void setWritedate(String writedate) {
		this.writedate = writedate;
	}

	public String getTypeCode() {
		return typeCode;
	}

	public void setTypeCode(String typeCode) {
		this.typeCode = typeCode;
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

	public String getIsDeleteBlock() {
		return isDeleteBlock;
	}

	public void setIsDeleteBlock(String isDeleteBlock) {
		this.isDeleteBlock = isDeleteBlock;
	}
}
