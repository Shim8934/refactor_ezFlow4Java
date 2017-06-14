package egovframework.ezMobile.ezEmail.vo;

public class MEmailFolderVO {
	
	private String name;
	private String fullName;
	private int unReadCount;
	private boolean hasSub;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public int getUnReadCount() {
		return unReadCount;
	}
	public void setUnReadCount(int unReadCount) {
		this.unReadCount = unReadCount;
	}
	public boolean isHasSub() {
		return hasSub;
	}
	public void setHasSub(boolean hasSub) {
		this.hasSub = hasSub;
	}
	
	@Override
	public String toString() {
		return "MEmailFolderVO [name=" + name + ", fullName=" + fullName + ", unReadCount=" + unReadCount + ", hasSub="
				+ hasSub + "]";
	}
	
}
