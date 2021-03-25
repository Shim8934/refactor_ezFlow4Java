package egovframework.ezEKP.ezWebFolder.vo;

public class DuplicateInfoVO {
	public enum Type {
		DIRECTORY, FILE
	}

	private String fileName;
	private Type newType;
	private String newId;
	private String newDate;
	private String newSize;
	private Type oldType;
	private String oldId;
	private String oldDate;
	private String oldSize;
	private String oldOwnerId;

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public Type getNewType() {
		return newType;
	}

	public void setNewType(Type newType) {
		this.newType = newType;
	}

	public String getNewId() {
		return newId;
	}

	public void setNewId(String newId) {
		this.newId = newId;
	}

	public String getNewDate() {
		return newDate;
	}

	public void setNewDate(String newDate) {
		this.newDate = newDate;
	}

	public String getNewSize() {
		return newSize;
	}

	public void setNewSize(String newSize) {
		this.newSize = newSize;
	}

	public Type getOldType() {
		return oldType;
	}

	public void setOldType(Type oldType) {
		this.oldType = oldType;
	}

	public String getOldId() {
		return oldId;
	}

	public void setOldId(String oldId) {
		this.oldId = oldId;
	}

	public String getOldDate() {
		return oldDate;
	}

	public void setOldDate(String oldDate) {
		this.oldDate = oldDate;
	}

	public String getOldSize() {
		return oldSize;
	}

	public void setOldSize(String oldSize) {
		this.oldSize = oldSize;
	}

	public String getOldOwnerId() {
		return oldOwnerId;
	}

	public void setOldOwnerId(String oldOwnerId) {
		this.oldOwnerId = oldOwnerId;
	}

	public boolean isAllFiles() {
		return newType == Type.FILE && oldType == Type.FILE;
	}
}
