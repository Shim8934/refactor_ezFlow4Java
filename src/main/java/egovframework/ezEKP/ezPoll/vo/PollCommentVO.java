package egovframework.ezEKP.ezPoll.vo;

public class PollCommentVO {
	private int cmtId;
	private int qstId;
	private int tenantId;
	private String userId;
	private String userName1;
	private String userName2;
	private String textContent;
	private String imageAttach;
	private String fileAttach;
	private String fileName;
	private String filePath;
	private String cmtTime;
	private String userImage;
	private String deptId;
	private String companyId;
	
	public int getCmtId() {
		return cmtId;
	}
	
	public void setCmtId(int cmtId) {
		this.cmtId = cmtId;
	}
	
	public int getQstId() {
		return qstId;
	}
	
	public void setQstId(int qstId) {
		this.qstId = qstId;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public String getImageAttach() {
		return imageAttach;
	}
	
	public void setImageAttach(String imageAttach) {
		this.imageAttach = imageAttach;
	}
	
	public String getFileAttach() {
		return fileAttach;
	}
	
	public void setFileAttach(String fileAttach) {
		this.fileAttach = fileAttach;
	}
	
	public String getCmtTime() {
		return cmtTime;
	}
	
	public void setCmtTime(String cmtTime) {
		this.cmtTime = cmtTime;
	}
	
	public String getTextContent() {
		return textContent;
	}
	
	public void setTextContent(String textContent) {
		this.textContent = textContent;
	}
	
	public String getFileName() {
		return fileName;
	}
	
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public String getFilePath() {
		return filePath;
	}
	
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getUserImage() {
		return userImage;
	}

	public void setUserImage(String userImage) {
		this.userImage = userImage;
	}

	public String getUserName1() {
		return userName1;
	}

	public void setUserName1(String userName1) {
		this.userName1 = userName1;
	}

	public String getUserName2() {
		return userName2;
	}

	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}

	public String getDeptId() {
		return deptId;
	}

	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}

	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}		
	
}
