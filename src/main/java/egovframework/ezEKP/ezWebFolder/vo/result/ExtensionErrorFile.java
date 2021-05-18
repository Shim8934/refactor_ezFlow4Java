package egovframework.ezEKP.ezWebFolder.vo.result;

public class ExtensionErrorFile {
	private String name;
	private String extension;

	public ExtensionErrorFile(String name, String extension) {
		this.name = name;
		this.extension = extension;
	}
	
	public String getName() {
		return name;
	}

	public String getExtension() {
		return extension;
	}
}
