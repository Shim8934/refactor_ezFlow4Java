package egovframework.ezEKP.ezStatistics.vo;

public class StatDailyDocCountLogVO {
	/** 등록날*/
	private String regDate;
	/** 기안개수*/
	private int draftCnt;
	/** 기안중 개수*/
	private int draftingCnt;
	/** 기안완료개수*/
	private int draftEndCnt;
	/** */
	private int returnCnt;
	/** 양식아이디*/
	private String formID;
	/** 양식명*/
	private String formInfo;
	
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public int getDraftCnt() {
		return draftCnt;
	}
	public void setDraftCnt(int draftCnt) {
		this.draftCnt = draftCnt;
	}
	public int getDraftingCnt() {
		return draftingCnt;
	}
	public void setDraftingCnt(int draftingCnt) {
		this.draftingCnt = draftingCnt;
	}
	public int getDraftEndCnt() {
		return draftEndCnt;
	}
	public void setDraftEndCnt(int draftEndCnt) {
		this.draftEndCnt = draftEndCnt;
	}
	public int getReturnCnt() {
		return returnCnt;
	}
	public void setReturnCnt(int returnCnt) {
		this.returnCnt = returnCnt;
	}
	public String getFormID() {
		return formID;
	}
	public void setFormID(String formID) {
		this.formID = formID;
	}
	public String getFormInfo() {
		return formInfo;
	}
	public void setFormInfo(String formInfo) {
		this.formInfo = formInfo;
	}
	
}
