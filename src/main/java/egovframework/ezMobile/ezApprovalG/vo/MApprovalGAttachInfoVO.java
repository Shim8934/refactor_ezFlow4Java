package egovframework.ezMobile.ezApprovalG.vo;

public class MApprovalGAttachInfoVO {
	/** 첨부파일 경로*/
	private String attachHref;
	/** 첨부파일 이름*/
	private String attachName;
	/** 첨부파일 사이즈*/
	private int attachFileSize;
	/** 첨부파일 안번호*/
	private int groupAttachSn;
	
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
	public int getAttachFileSize() {
		return attachFileSize;
	}
	public void setAttachFileSize(int attachFileSize) {
		this.attachFileSize = attachFileSize;
	}
	public int getGroupAttachSn() {
		return groupAttachSn;
	}
	public void setGroupAttachSn(int groupAttachSn) {
		this.groupAttachSn = groupAttachSn;
	}
}
