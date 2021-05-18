package egovframework.ezEKP.ezWebFolder.vo;

public class TrashCanVO {
	private String trashCanId;
	private String trashCanName;
	private String trashCanIconUrl;
	private String trashCanPath;
	private String trashCanExt;
	private long trashCanSize;
	private String createId;
	private String createName1;
	private String createName2;
	private String createDate;
	private String updateDate;
	private String fileFolderId;
	private String folderUpper;
	private int version;
	
	public String getTrashCanId() {
		return trashCanId;
	}
	public void setTrashCanId(String trashCanId) {
		this.trashCanId = trashCanId;
	}
	public String getTrashCanName() {
		return trashCanName;
	}
	public void setTrashCanName(String trashCanName) {
		this.trashCanName = trashCanName;
	}
	public String getTrashCanIconUrl() {
		return trashCanIconUrl;
	}
	public void setTrashCanIconUrl(String trashCanIconUrl) {
		this.trashCanIconUrl = trashCanIconUrl;
	}
	public String getTrashCanPath() {
		return trashCanPath;
	}
	public void setTrashCanPath(String trashCanPath) {
		this.trashCanPath = trashCanPath;
	}
	public String getTrashCanExt() {
		return trashCanExt;
	}
	public void setTrashCanExt(String trashCanExt) {
		this.trashCanExt = trashCanExt;
	}
	public long getTrashCanSize() {
		return trashCanSize;
	}
	public void setTrashCanSize(long trashCanSize) {
		this.trashCanSize = trashCanSize;
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
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	public String getFileFolderId() {
		return fileFolderId;
	}
	public void setFileFolderId(String fileFolderId) {
		this.fileFolderId = fileFolderId;
	}
	public String getFolderUpper() {
		return folderUpper;
	}
	public void setFolderUpper(String folderUpper) {
		this.folderUpper = folderUpper;
	}

	/**
	 * 버전이 1 이상이면 버전기록에서 삭제된 파일이다.<br>
	 * 파일 이름 또한 "이름.docx (2)" 이런식으로 붙어 나오게 된다.<br>
	 * 0이면 일반적인 폴더와 파일이다.
	 */
	public int getVersion() {
		return version;
	}

	public void setVersion(int version) {
		this.version = version;
	}
}
