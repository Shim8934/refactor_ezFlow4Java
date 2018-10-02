package egovframework.ezEKP.ezNewPortal.vo;

public class FrameInfoVO {

	private int frameId; //프레임 아이디
	private String frameName; //프레임 이름
	private int themeId; //프레임과 연관된 테마 아이디
	private boolean frameUsed; //프레임 사용여부 : 사용(true) 미사용(false)
	private boolean frameDefault; //기본 프레임인지 여부 : 기본(true), 기본 아님(false)
	public int getFrameId() {
		return frameId;
	}
	public void setFrameId(int frameId) {
		this.frameId = frameId;
	}
	
	public String getFrameName() {
		return frameName;
	}
	
	public void setFrameName(String frameName) {
		this.frameName = frameName;
	}
	
	public int getThemeId() {
		return themeId;
	}
	
	public void setThemeId(int themeId) {
		this.themeId = themeId;
	}
	
	public boolean isFrameUsed() {
		return frameUsed;
	}
	
	public void setFrameUsed(boolean frameUsed) {
		this.frameUsed = frameUsed;
	}
	
	public boolean isFrameDefault() {
		return frameDefault;
	}
	
	public void setFrameDefault(boolean frameDefault) {
		this.frameDefault = frameDefault;
	}
	
	@Override
	public String toString() {
		return "FrameInfoVO [frameId=" + frameId + ", frameName=" + frameName + ", themeId=" + themeId + ", frameUsed="
				+ frameUsed + ", frameDefault=" + frameDefault + "]";
	}
}
