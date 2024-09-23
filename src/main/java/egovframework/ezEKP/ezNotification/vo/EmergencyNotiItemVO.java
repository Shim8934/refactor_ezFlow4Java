package egovframework.ezEKP.ezNotification.vo;

public class EmergencyNotiItemVO {
	private int notiId;
	private String writerName;
	private String writerName2;
	private String writerDeptName;
	private String writerDeptName2;
	private String writerId;
	private String writerPhoto;
	private String notiTitle;
	private String notiBody;
	private String writeDate;
	private int tenantId;
	public int getNotiId() {
		return notiId;
	}
	public void setNotiId(int notiId) {
		this.notiId = notiId;
	}
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}
	public String getNotiTitle() {
		return notiTitle;
	}
	public void setNotiTitle(String notiTitle) {
		this.notiTitle = notiTitle;
	}
	public String getNotiBody() {
		return notiBody;
	}
	public void setNotiBody(String notiBody) {
		this.notiBody = notiBody;
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
	public String getWriterDeptName() {
		return writerDeptName;
	}
	public void setWriterDeptName(String writerDeptName) {
		this.writerDeptName = writerDeptName;
	}
	public String getWriterDeptName2() {
		return writerDeptName2;
	}
	public void setWriterDeptName2(String writerDeptName2) {
		this.writerDeptName2 = writerDeptName2;
	}
	public String getWriterPhoto() {
		return writerPhoto;
	}
	public void setWriterPhoto(String writerPhoto) {
		this.writerPhoto = writerPhoto;
	}
}
