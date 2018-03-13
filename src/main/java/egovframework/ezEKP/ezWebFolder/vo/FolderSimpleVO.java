package egovframework.ezEKP.ezWebFolder.vo;

import java.util.List;
import java.util.Map;

public class FolderSimpleVO {
	private String folderId;
	private String folderName;
	private String folderName2;
	private int hasSubFolder;
	private int folderLevel;
	private List<FolderSimpleVO> listSubFolders;

	public String getFolderId() {
		return folderId;
	}

	public void setFolderId(String folderId) {
		this.folderId = folderId;
	}

	public String getFolderName() {
		return folderName;
	}

	public void setFolderName(String folderName) {
		this.folderName = folderName;
	}

	public int getHasSubFolder() {
		return hasSubFolder;
	}

	public void setHasSubFolder(int hasSubFolder) {
		this.hasSubFolder = hasSubFolder;
	}

	public List<FolderSimpleVO> getListSubFolders() {
		return listSubFolders;
	}

	public void setListSubFolders(List<FolderSimpleVO> listSubFolders) {
		this.listSubFolders = listSubFolders;
	}

	public int getFolderLevel() {
		return folderLevel;
	}

	public void setFolderLevel(int folderLevel) {
		this.folderLevel = folderLevel;
	}

	public String getFolderName2() {
		return folderName2;
	}

	public void setFolderName2(String folderName2) {
		this.folderName2 = folderName2;
	}
	
}