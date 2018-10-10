package egovframework.ezEKP.ezWebFolder.vo;

public class FileLogVO {
	private String logId;
	private String fileType;
	private String fileName;
	private long fileSize;
	private String fileExt;
	private String logType;
	private String createId;
	private String createName1;
	private String createName2;
	private String createDate;
	private String companyId;
	private int tenantId;
	
	public String getLogId() {
		return logId;
	}

	public void setLogId(String logId) {
		this.logId = logId;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
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

	public String getLogType() {
		return logType;
	}

	public void setLogType(String logType) {
		this.logType = logType;
	}

	public String getCreateId() {
		return createId;
	}

	public void setCreateId(String createId) {
		this.createId = createId;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getCompanyId() {
		return companyId;
	}	

	public String getCreateName1() {
		return createName1;
	}

	public void setCreateName1(String createName1) {
		this.createName1 = createName1;
	}

	public String getCreateName2() {
		return createName2;
	}

	public void setCreateName2(String createName2) {
		this.createName2 = createName2;
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

	public String getFileExt() {
		return fileExt;
	}

	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}
}
