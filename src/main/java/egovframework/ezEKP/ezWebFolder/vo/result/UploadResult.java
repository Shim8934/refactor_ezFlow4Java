package egovframework.ezEKP.ezWebFolder.vo.result;

import java.util.List;

import egovframework.ezEKP.ezWebFolder.vo.FileVO;

public class UploadResult {
	private List<FileVO> successFiles;
	private List<ExtensionErrorFile> failureList;

	public List<FileVO> getSuccessFiles() {
		return successFiles;
	}

	public void setSuccessFiles(List<FileVO> successFiles) {
		this.successFiles = successFiles;
	}

	public List<ExtensionErrorFile> getFailureList() {
		return failureList;
	}

	public void setFailureList(List<ExtensionErrorFile> failureList) {
		this.failureList = failureList;
	}

	public boolean success() {
		return successFiles.size() + failureList.size() > 0;
	}
}
