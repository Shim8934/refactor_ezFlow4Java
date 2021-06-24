package egovframework.ezMobile.ezWebfolder.vo;

public class MWebfolderFile {

	private String id;
	/** D: 폴더, F: 파일 */
	private String type;

	private String name;
	private long size;

	private String owner;
	private String date;

	private boolean isFavorite;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public long getSize() {
		return size;
	}

	public void setSize(long size) {
		this.size = size;
	}

	public String getHumanReadableSize() {
		int unit = 1024;

		if (size < unit) {
			return size + " B";
		}

		int exp = (int) (Math.log(size) / Math.log(unit));
		String pre = ("KMGTPE").charAt(exp - 1) + "";

		return String.format("%.1f %sB", size / Math.pow(unit, exp), pre);
	}

	public String getOwner() {
		return owner;
	}

	public void setOwner(String owner) {
		this.owner = owner;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public boolean isFavorite() {
		return isFavorite;
	}

	public void setFavorite(boolean isFavorite) {
		this.isFavorite = isFavorite;
	}

	public boolean isFolder() {
		return "D".equalsIgnoreCase(type);
	}

	public boolean isFile() {
		return "F".equalsIgnoreCase(type);
	}

}
