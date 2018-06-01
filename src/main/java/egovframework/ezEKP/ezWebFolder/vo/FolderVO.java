package egovframework.ezEKP.ezWebFolder.vo;

public class FolderVO {
	private String folderId;
	private String folderName1;
	private String folderName2;
	private String folderType;
	private String folderPath;
	private int    folderStep;
	private int    folderLevel;
	private String folderUpper;
	private String useStatus;
	private String ownerId;
	private String createId;
	private String createDate;
	private String createName1;
	private String createName2;
	private String updateId;
	private String updateDate;
	private String companyId;
	private String deleterId;
	private int    tenantId;

	public String getFolderId() {
		return folderId;
	}

	public void setFolderId(String folderId) {
		this.folderId = folderId;
	}

	public String getFolderName1() {
		return folderName1;
	}

	public void setFolderName1(String folderName1) {
		this.folderName1 = folderName1;
	}

	public String getFolderName2() {
		return folderName2;
	}

	public void setFolderName2(String folderName2) {
		this.folderName2 = folderName2;
	}

	public String getFolderType() {
		return folderType;
	}

	public void setFolderType(String folderType) {
		this.folderType = folderType;
	}

	public String getFolderPath() {
		return folderPath;
	}

	public void setFolderPath(String folderPath) {
		this.folderPath = folderPath;
	}

	public int getFolderStep() {
		return folderStep;
	}

	public void setFolderStep(int folderStep) {
		this.folderStep = folderStep;
	}

	public int getFolderLevel() {
		return folderLevel;
	}

	public void setFolderLevel(int folderLevel) {
		this.folderLevel = folderLevel;
	}

	public String getFolderUpper() {
		return folderUpper;
	}

	public void setFolderUpper(String folderUpper) {
		this.folderUpper = folderUpper;
	}

	public String getUseStatus() {
		return useStatus;
	}

	public void setUseStatus(String useStatus) {
		this.useStatus = useStatus;
	}

	public String getOwnerId() {
		return ownerId;
	}

	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
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

	public String getUpdateId() {
		return updateId;
	}

	public void setUpdateId(String updateId) {
		this.updateId = updateId;
	}

	public String getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
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

	public String getDeleterId() {
		return deleterId;
	}

	public void setDeleterId(String deleterId) {
		this.deleterId = deleterId;
	}

	@Override
	public String toString() {
		return "FolderVO [folderId=" + folderId + ", folderName1=" + folderName1 + ", folderName2=" + folderName2 + ", folderType=" + folderType + ", folderPath=" + folderPath + ", folderStep="
				+ folderStep + ", folderLevel=" + folderLevel + ", folderUpper=" + folderUpper + ", useStatus=" + useStatus + ", ownerId=" + ownerId + ", createId=" + createId + ", createDate="
				+ createDate + ", createName1=" + createName1 + ", createName2=" + createName2 + ", updateId=" + updateId + ", updateDate=" + updateDate + ", companyId=" + companyId + ", deleterId="
				+ deleterId + ", tenantId=" + tenantId + "]";
	}
}