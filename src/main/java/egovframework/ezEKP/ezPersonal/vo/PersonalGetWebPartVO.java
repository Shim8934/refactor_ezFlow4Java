package egovframework.ezEKP.ezPersonal.vo;

public class PersonalGetWebPartVO {
	/** */
	String name;
	/** */
	private String url;
	/** */
	private float position;
	/** */
	private float defaultPriority;
	/** */
	private String ID;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public float getPosition() {
		return position;
	}
	public void setPosition(float position) {
		this.position = position;
	}
	public float getDefaultPriority() {
		return defaultPriority;
	}
	public void setDefaultPriority(float defaultPriority) {
		this.defaultPriority = defaultPriority;
	}
	public String getID() {
		return ID;
	}
	public void setID(String iD) {
		ID = iD;
	}
}
