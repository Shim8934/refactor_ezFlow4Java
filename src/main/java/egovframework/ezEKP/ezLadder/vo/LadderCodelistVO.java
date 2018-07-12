package egovframework.ezEKP.ezLadder.vo;

public class LadderCodelistVO {
	
	/** 테넌트 id */
	private int tenant_id;
	/** 코드  */
	private String code;
	/** 언어  */
	private int language;
	/** 텍스트 */
	private String name;
	/** 설명  */
	private String description;
	
	public int getTenant_id() {
		return tenant_id;
	}
	public void setTenant_id(int tenant_id) {
		this.tenant_id = tenant_id;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public int getLanguage() {
		return language;
	}
	public void setLanguage(int language) {
		this.language = language;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
}
