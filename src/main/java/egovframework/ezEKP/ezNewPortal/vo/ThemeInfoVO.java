package egovframework.ezEKP.ezNewPortal.vo;

public class ThemeInfoVO {

	private int themeId; //테마 아이디
	private String themeName; //테마명
	private String themeContent; //테마 설명
	private boolean themeUsed; //테마 사용 여부 : 사용(true), 사용 안함(false)
	private boolean themeDefault; //기본 테마적용 여부 : 기본(true), 기본 아님(false)
	private int frameDefault; //해당 테마의 기본 프레임 아이디
	
	public int getThemeId() {
		return themeId;
	}
	public void setThemeId(int themeId) {
		this.themeId = themeId;
	}
	public String getThemeName() {
		return themeName;
	}
	public void setThemeName(String themeName) {
		this.themeName = themeName;
	}
	public String getThemeContent() {
		return themeContent;
	}
	public void setThemeContent(String themeContent) {
		this.themeContent = themeContent;
	}
	public boolean isThemeUsed() {
		return themeUsed;
	}
	public void setThemeUsed(boolean themeUsed) {
		this.themeUsed = themeUsed;
	}
	public boolean isThemeDefault() {
		return themeDefault;
	}
	public void setThemeDefault(boolean themeDefault) {
		this.themeDefault = themeDefault;
	}
	public int getFrameDefault() {
		return frameDefault;
	}
	public void setFrameDefault(int frameDefault) {
		this.frameDefault = frameDefault;
	}
	@Override
	public String toString() {
		return "ThemeInfoVO [themeId=" + themeId + ", themeName=" + themeName + ", themeContent=" + themeContent
				+ ", themeUsed=" + themeUsed + ", themeDefault=" + themeDefault + ", frameDefault=" + frameDefault
				+ "]";
	}
	
}
