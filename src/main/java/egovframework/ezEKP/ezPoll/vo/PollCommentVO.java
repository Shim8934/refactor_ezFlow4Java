package egovframework.ezEKP.ezPoll.vo;

public class PollCommentVO {
	private int cmtId;
	private int qstId;
	private int tenantId;
	private String userId;
	private String textContent;
	private String imageAttach;
	private String fileAttach;
	private String fileName;
	private String filePath;
	private String cmtTime;
	
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
}
