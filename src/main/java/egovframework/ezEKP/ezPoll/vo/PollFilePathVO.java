package egovframework.ezEKP.ezPoll.vo;

import java.util.List;
import java.util.Map;

public class PollFilePathVO {
	private final String content;
	private final List<Map<String, String>> copyFilePathList;
	private final String targetDirFullPath;
	
	public PollFilePathVO(String content, List<Map<String, String>> copyFilePathList, String targetDirFullPath) {
		this.content = content;
		this.copyFilePathList = copyFilePathList;
		this.targetDirFullPath = targetDirFullPath;
	}
	
	public String getContent() {
		return content;
	}
	
	public List<Map<String, String>> getCopyFilePathList() {
		return copyFilePathList;
	}
	
	public String getTargetDirFullPath() {
		return targetDirFullPath;
	}
}
