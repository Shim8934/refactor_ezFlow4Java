package egovframework.ezEKP.ezJournal.vo;

public class ReceiverFavoriteVO {
	
	/** 즐겨찾기 아이디 */
	private String favoriteId;
	/** 즐겨찾기 명 */
	private String favoriteName;
	/** 즐겨찾기 생성일 */
	private String favoriteDate;
	/** 테넌트아이디 */
	private int tenantId;
	
	public String getFavoriteId() {
		return favoriteId;
	}
	public void setFavoriteId(String favoriteId) {
		this.favoriteId = favoriteId;
	}
	public String getFavoriteName() {
		return favoriteName;
	}
	public void setFavoriteName(String favoriteName) {
		this.favoriteName = favoriteName;
	}
	public String getFavoriteDate() {
		return favoriteDate;
	}
	public void setFavoriteDate(String favoriteDate) {
		this.favoriteDate = favoriteDate;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	
}
