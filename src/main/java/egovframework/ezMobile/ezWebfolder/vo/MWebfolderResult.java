package egovframework.ezMobile.ezWebfolder.vo;

import java.util.List;

import egovframework.ezEKP.ezWebFolder.vo.FileVO;

public class MWebfolderResult {

	private static final String ROOT_FOLDER_ID = "root";

	private List<FileVO> files;

	private String folderName;
	private String folderName2;
	private String parentFolderId;
	private int folderLevel;

	private int totalPages;
	private int fileCount;
	private int folderCount;

	public List<FileVO> getFiles() {
		return files;
	}

	public void setFiles(List<FileVO> files) {
		this.files = files;
	}

	public String getFolderName() {
		return folderName;
	}

	public void setFolderName(String folderName) {
		this.folderName = folderName;
	}
	
	public String getFolderName2() {
		return folderName2;
	}

	public void setFolderName2(String folderName) {
		this.folderName2 = folderName;
	}

	public String getParentFolderId() {
		return parentFolderId;
	}

	public void setParentFolderId(String parentFolderId) {
		this.parentFolderId = parentFolderId;
	}

	public int getFolderLevel() {
		return folderLevel;
	}

	public void setFolderLevel(int folderLevel) {
		this.folderLevel = folderLevel;
	}

	public void setRootFolder() {
		parentFolderId = ROOT_FOLDER_ID;
	}

	public boolean isRootFolder() {
		return ROOT_FOLDER_ID.equals(parentFolderId);
	}

	public int getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(int totalPages) {
		this.totalPages = totalPages;
	}

	public int getFileCount() {
		return fileCount;
	}

	public void setFileCount(int fileCount) {
		this.fileCount = fileCount;
	}

	public int getFolderCount() {
		return folderCount;
	}

	public void setFolderCount(int folderCount) {
		this.folderCount = folderCount;
	}

}