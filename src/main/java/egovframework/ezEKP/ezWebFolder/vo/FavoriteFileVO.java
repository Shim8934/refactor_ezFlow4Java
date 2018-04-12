package egovframework.ezEKP.ezWebFolder.vo;

public class FavoriteFileVO {
	private String targetId;
	private String targetName;
	private String targetType;
	private String targetIconUrl;
	private String targetPath;
	private String targetExt;
	private int targetSize;

	private String createId;
	private String createName1;
	private String createName2;
	private String createDate;
	
	private int tenantId;

	public String getTargetId() {
		return targetId;
	}

	public void setTargetId(String targetId) {
		this.targetId = targetId;
	}

	public String getTargetName() {
		return targetName;
	}

	public void setTargetName(String targetName) {
		this.targetName = targetName;
	}

	public String getTargetType() {
		return targetType;
	}

	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}

	public String getTargetIconUrl() {
		return targetIconUrl;
	}

	public void setTargetIconUrl(String targetIconUrl) {
		this.targetIconUrl = targetIconUrl;
	}

	public String getTargetPath() {
		return targetPath;
	}

	public void setTargetPath(String targetPath) {
		this.targetPath = targetPath;
	}

	public String getTargetExt() {
		return targetExt;
	}

	public void setTargetExt(String targetExt) {
		this.targetExt = targetExt;
	}

	public int getTargetSize() {
		return targetSize;
	}

	public void setTargetSize(int targetSize) {
		this.targetSize = targetSize;
	}

	public String getCreateId() {
		return createId;
	}

	public void setCreateId(String createId) {
		this.createId = createId;
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

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}

	@Override
	public String toString() {
		return "FavoriteFileVO [targetId=" + targetId + ", targetName=" + targetName + ", targetType=" + targetType + ", targetIconUrl=" + targetIconUrl + ", targetPath=" + targetPath
				+ ", targetExt=" + targetExt + ", targetSize=" + targetSize + ", createId=" + createId + ", createName1=" + createName1 + ", createName2=" + createName2 + ", createDate=" + createDate
				+ ", tenantId=" + tenantId + "]";
	}
}
