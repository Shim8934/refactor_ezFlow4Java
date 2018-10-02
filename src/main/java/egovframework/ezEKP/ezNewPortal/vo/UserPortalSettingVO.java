package egovframework.ezEKP.ezNewPortal.vo;

public class UserPortalSettingVO {

	private String userId; //사용자 아이디
	private int usedTheme; //사용자 설정 테마 아이디
	private int usedFrame; //사용자 설정 프레임 아이디
	
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
	public int getUsedFrame() {
		return usedFrame;
	}
	public void setUsedFrame(int usedFrame) {
		this.usedFrame = usedFrame;
	}
	
	@Override
	public String toString() {
		return "UserPortalSettingVO [userId=" + userId + ", usedTheme=" + usedTheme + ", usedFrame=" + usedFrame + "]";
	}
	
}
