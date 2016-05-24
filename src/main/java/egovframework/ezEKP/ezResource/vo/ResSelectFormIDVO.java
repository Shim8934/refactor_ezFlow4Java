package egovframework.ezEKP.ezResource.vo;

public class ResSelectFormIDVO {
	/** 자원예약게시판ID*/
	private String resID;
	/** 자원이름*/
	private String brdNm;
	/** 본문*/
	private String formText;
	
	public String getResID() {
		return resID;
	}
	public void setResID(String resID) {
		this.resID = resID;
	}
	public String getBrdNm() {
		return brdNm;
	}
	public void setBrdNm(String brdNm) {
		this.brdNm = brdNm;
	}
	public String getFormText() {
		return formText;
	}
	public void setFormText(String formText) {
		this.formText = formText;
	}
}
