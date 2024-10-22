package egovframework.ezEKP.ezSystem.vo;

public class SystemConfigTypeVO {
	// 분류 타입 코드
	private String typeCode;
	// 분류 타입 이름
	private String typeName;
	// 분류 타입 이름2
	private String typeName2;
	// 분류 타입 설명
	private String description;
	// 작성자 아이디
	private String writerId;
	// 작성자 이름
	private String writerName;
	// 작성자 이름2 
	private String writerName2;
	// 작성일자
	private String writeDate;
	
	private int tenantId;
	
	private String companyId;

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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getWriterId() {
		return writerId;
	}

	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}

	public String getWriterName() {
		return writerName;
	}

	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}

	public String getWriterName2() {
		return writerName2;
	}

	public void setWriterName2(String writerName2) {
		this.writerName2 = writerName2;
	}

	public String getWriteDate() {
		return writeDate;
	}

	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
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

}
