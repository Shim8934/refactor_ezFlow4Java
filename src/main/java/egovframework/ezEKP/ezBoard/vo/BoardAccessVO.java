package egovframework.ezEKP.ezBoard.vo;

public class BoardAccessVO {
	
	private String accessID;
	private String accessName;
	
	public String getAccessID() {
		return accessID;
	}
	public void setAccessID(String accessID) {
		this.accessID = accessID;
	}
	public String getAccessName() {
		return accessName;
	}
	public void setAccessName(String accessName) {
		this.accessName = accessName;
	}
	
	@Override
	public String toString() {
		return "BoardAccessVO [accessID=" + accessID + ", accessName=" + accessName + "]";
	}
	
}