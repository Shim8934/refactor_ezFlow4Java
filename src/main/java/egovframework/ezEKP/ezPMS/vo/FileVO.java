package egovframework.ezEKP.ezPMS.vo;

public class FileVO {
	
	private String filePath;
	private Long fileSize;
	private String fileName;
	private String fileType;
	private String fileTransSize;
	
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public Long getFileSize() {
		return fileSize;
	}
	public void setFileSize(Long fileSize) {
		this.fileSize = fileSize;
		
		// 파일 크기에 따라 단위를 설정해준다
		int i = 0;
		String unit;
		double size = fileSize;
		
		while(size > 1024.0) {
			size /= 1024.0;
			i++;
		}
		
		switch (i) {
		case 1:
			unit = "KB";
			break;
		case 2:
			unit = "MB";
			break;
		case 3:
			unit = "GB";
			break;
		default:
			unit = "B";
			break;
		}
		
		this.fileTransSize = Math.round(size * 10)/10.0 + unit;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
		
		// 화면에서의 아이콘 종류를 위한 파라미터
		String extension = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
		
		if(extension.equals("jpg") || extension.equals("jpeg") || extension.equals("bmp") || extension.equals("gif") || extension.equals("png") ||
		   extension.equals("tif") || extension.equals("tiff")) {
			extension = "image";
		} else if(extension.equals("doc") || extension.equals("docx")) {
			extension = "doc";
		} else if(extension.equals("xls") || extension.equals("xlsx")) {
			extension = "xls";
		} else if(extension.equals("ppt") || extension.equals("pptx") || extension.equals("pps") || extension.equals("ppsx")) {
			extension = "ppt";
		} else if(extension.equals("txt") || extension.equals("zip") || extension.equals("pdf") || extension.equals("ecm")) {
			// extension = extension 그냥 유지 되면 됨
		} else {
			extension = "file";
		}
		
		this.fileType = extension;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getFileTransSize() {
		return fileTransSize;
	}
	public void setFileTransSize(String fileTransSize) {
		this.fileTransSize = fileTransSize;
	}
}
