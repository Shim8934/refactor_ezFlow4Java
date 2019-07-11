package egovframework.ezEKP.ezPersonal.vo;

public class PersonalPopopConfigVO {
	/** 팝업공지 옵션ID(ai) */
	private int popupOptionId;
	/** 사용자 아이디 */
	private String userId;
	/** 미리보기창 (0 normal, 1 bottom, 2 side) */
	private int isPreview;
	/** 테넌트 아이디 */
	private int tenantId;
	
	public int getPopupOptionId() {
		return popupOptionId;
	}
	public void setPopupOptionId(int popupOptionId) {
		this.popupOptionId = popupOptionId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getIsPreview() {
		return isPreview;
	}
	public void setIsPreview(int isPreview) {
		this.isPreview = isPreview;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
}
