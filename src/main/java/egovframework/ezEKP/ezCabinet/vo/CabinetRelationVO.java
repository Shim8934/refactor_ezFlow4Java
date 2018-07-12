package egovframework.ezEKP.ezCabinet.vo;

public class CabinetRelationVO {
	private int    relationId;
	private int    itemId;
	private int    relatedItemId;
	private String companyId;
	private int    tenantId;
	private int    temp;
	
	public CabinetRelationVO() {}
	
	public CabinetRelationVO(int relationId, int itemId, int relatedId, String companyId, int tenantId) {
		this.relationId    = relatedId;
		this.itemId        = itemId;
		this.relatedItemId = relatedId;
		this.companyId     = companyId;
		this.tenantId      = tenantId;
	}
	
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
	
	public int getTemp() {
		return temp;
	}
	
	public void setTemp(int temp) {
		this.temp = temp;
	}
}
