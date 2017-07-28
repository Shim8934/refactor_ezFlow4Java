package egovframework.ezMobile.ezApprovalG.vo;

public class MApprovalGAttachInfoVO {
	/** 첨부파일 경로*/
	private String attachHref;
	/** 첨부파일 이름*/
	private String attachName;
	/** 첨부파일 사이즈*/
	private String attachFileSize;
	
	public String getAttachHref() {
		return attachHref;
	}
	public void setAttachHref(String attachHref) {
		this.attachHref = attachHref;
	}
	public String getAttachName() {
		return attachName;
	}
	public void setAttachName(String attachName) {
		this.attachName = attachName;
	}
	public String getAttachFileSize() {
		return attachFileSize;
	}
	public void setAttachFileSize(String attachFileSize) {
		this.attachFileSize = attachFileSize;
	}
}
