package egovframework.ezEKP.ezCabinet.vo;

public class CabinetRelationItemVO {
	private int    relationId;
	private int    itemId;
	private int    relatedItemId;
	private int    itemType;
	private String title;
	private int    useStatus;
	private String companyId;
	private int    tenantId;
	
	public int getRelationId() {
		return relationId;
	}
	
	public void setRelationId(int relationId) {
		this.relationId = relationId;
	}
	
	public int getItemId() {
		return itemId;
	}
	
	public void setItemId(int itemId) {
		this.itemId = itemId;
	}
	
	public int getRelatedItemId() {
		return relatedItemId;
	}
	
	public void setRelatedItemId(int relatedItemId) {
		this.relatedItemId = relatedItemId;
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
	
	public int getUseStatus() {
		return useStatus;
	}
	
	public void setUseStatus(int useStatus) {
		this.useStatus = useStatus;
	}
	
	public String getCompanyId() {
		return companyId;
	}
	
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
}
