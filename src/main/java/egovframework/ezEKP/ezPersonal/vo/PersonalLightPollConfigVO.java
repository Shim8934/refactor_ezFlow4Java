package egovframework.ezEKP.ezPersonal.vo;

public class PersonalLightPollConfigVO {
	/** 빠른설문 옵션ID(ai) */
	private int lightpollOptionId;
	/** 사용자 아이디 */
	private String userId;
	/** 미리보기창 (0 normal, 1 bottom, 2 side) */
	private int isPreview;
	/** 테넌트 아이디 */
	private int tenantId;
	
	public int getLightpollOptionId() {
		return lightpollOptionId;
	}
	public void setLightpollOptionId(int lightpollOptionId) {
		this.lightpollOptionId = lightpollOptionId;
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
