package egovframework.ezEKP.ezNewPortal.vo;

public class UserPortalSettingVO {

	private String userId; //사용자 아이디
	private int usedTheme; //사용자 설정 테마 아이디
	private String usedFrame; //사용자 설정 프레임 이름
	private int usePaging;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getUsedTheme() {
		return usedTheme;
	}
	public void setUsedTheme(int usedTheme) {
		this.usedTheme = usedTheme;
	}
	public String getUsedFrame() {
		return usedFrame;
	}
	public void setUsedFrame(String usedFrame) {
		this.usedFrame = usedFrame;
	}
	public int getUsePaging() {
		return usePaging;
	}
	public void setUsePaging(int usePaging) {
		this.usePaging = usePaging;
	}
	
	@Override
	public String toString() {
		return "UserPortalSettingVO [userId=" + userId + ", usedTheme=" + usedTheme + ", usedFrame=" + usedFrame + "]";
	}
	
}
