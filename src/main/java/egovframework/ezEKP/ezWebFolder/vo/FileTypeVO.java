package egovframework.ezEKP.ezWebFolder.vo;

public class FileTypeVO {
	private String typeId;
	private String typeName;
	private String fileExt;
	private String typeIcon;
	private int    tenantId;
	
	public String getTypeId() {
		return typeId;
	}
	
	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}
	
	public String getTypeName() {
		return typeName;
	}
	
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	
	public String getFileExt() {
		return fileExt;
	}
	
	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}
	
	public String getTypeIcon() {
		return typeIcon;
	}
	
	public void setTypeIcon(String typeIcon) {
		this.typeIcon = typeIcon;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
}