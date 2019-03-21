package egovframework.ezEKP.ezWebFolder.vo;

public class FolderTreeVO {
	private String id;
	private String text;
	private String parent;
	private String selected;
	private String createId;
	private String folderName1;
	private String folderName2;
	private String folderLevel;
	private String folderPath;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getParent() {
		return parent;
	}

	public void setParent(String parent) {
		this.parent = parent;
	}

	public String getSelected() {
		return selected;
	}

	public void setSelected(String selected) {
		this.selected = selected;
	}

	public String getCreateId() {
		return createId;
	}

	public void setCreateId(String createId) {
		this.createId = createId;
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
	
	public String getFolderLevel() {
		return folderLevel;
	}

	public void setFolderLevel(String folderLevel) {
		this.folderLevel = folderLevel;
	}

	public String getFolderPath() {
		return folderPath;
	}

	public void setFolderPath(String folderPath) {
		this.folderPath = folderPath;
	}
	
	@Override
	public String toString() {
		return "FolderTreeVO [id=" + id + ", text=" + text + ", parent="
				+ parent + ", selected=" + selected + ", createId=" + createId
				+ ", folderName1=" + folderName1 + ", folderName2="
				+ folderName2 + ", folderLevel=" + folderLevel + ", folderPath="+folderPath +"]";
	}


}