package egovframework.ezEKP.ezCabinet.vo;

public class CabinetItemSimpleVO {
	private int    itemId;
	private int    cabinetId;
	private int    itemType;
	private String title;
	private int    tenantId;
	
	public int getItemId() {
		return itemId;
	}
	
	public void setItemId(int itemId) {
		this.itemId = itemId;
	}
	
	public int getCabinetId() {
		return cabinetId;
	}
	
	public void setCabinetId(int cabinetId) {
		this.cabinetId = cabinetId;
	}
	
	public int getItemType() {
		return itemType;
	}
	
	public void setItemType(int itemType) {
		this.itemType = itemType;
	}
	
	public String getTitle() {
		return title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
}
