package egovframework.ezEKP.ezWebFolder.vo;

public class FolderTreeVO {
	private String id;
	private String text;
	private String parent;
	private String selected;
	private String createId;
	
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
	
	@Override
	public String toString() {
		return "FolderTreeVO [id=" + id + ", text=" + text + ", parent=" + parent + ", selected=" + selected
				+ ", createId=" + createId + "]";
	}
}