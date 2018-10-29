package egovframework.ezEKP.ezCabinet.vo;

public class CabinetAttachFileVO {
	private int    attachId;
	private int    itemId;
	private String filePath;
	private String fileName;
	private long   fileSize;
	private String fileDescription;
	private String companyId;
	private int    tenantId;
	private int    temp;
	
	public CabinetAttachFileVO() {}
	
	public CabinetAttachFileVO(int attachId, int itemId, String path, String name, long size, String description, String companyId, int tenantId) {
		this.attachId        = attachId;
		this.itemId          = itemId;
		this.filePath        = path;
		this.fileName        = name;
		this.fileSize        = size;
		this.companyId       = companyId;
		this.tenantId        = tenantId;
		this.fileDescription = description;
	}
	
	public int getAttachId() {
		return attachId;
	}
	
	public void setAttachId(int attachId) {
		this.attachId = attachId;
	}
	
	public int getItemId() {
		return itemId;
	}
	
	public void setItemId(int itemId) {
		this.itemId = itemId;
	}
	
	public String getFilePath() {
		return filePath;
	}
	
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	
	public String getFileName() {
		return fileName;
	}
	
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public long getFileSize() {
		return fileSize;
	}
	
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
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
	
	public int getTemp() {
		return temp;
	}
	
	public void setTemp(int temp) {
		this.temp = temp;
	}
	
	public String getFileDescription() {
		return fileDescription;
	}
	
	public void setFileDescription(String fileDescription) {
		this.fileDescription = fileDescription;
	}
}
