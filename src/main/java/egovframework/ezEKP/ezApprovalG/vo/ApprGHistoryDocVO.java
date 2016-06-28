package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGHistoryDocVO {
	/** 문서아이디*/
	private String docID;
	/** 변경순번*/
	private String changeSN;
	/** 문서경로*/
	private String url;
	/** 변경자아이디*/
	private String changeUserID;
	/** 변경자직위*/
	private String changeUserJobTitle;
	/** 변경자직위(다국어)*/
	private String changeUserJobTitle2;
	/** 변경자이름*/
	private String changeUserName;
	/** 변경자이름(다국어)*/
	private String changeUserName2;
	/** 변경자부서아이디*/
	private String changeUserDeptID;
	/** 변경자부서이름*/
	private String changeUserDeptName;
	/** 변경자부서이름(다국어)*/
	private String changeUserDeptName2;
	/** 변경일*/
	private String changeDate;
	/** 사용안함*/
	private String chkFlag;
	
	public String getDocID() {
		return docID;
	}
	public void setDocID(String docID) {
		this.docID = docID;
	}
	public String getChangeSN() {
		return changeSN;
	}
	public void setChangeSN(String changeSN) {
		this.changeSN = changeSN;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getChangeUserID() {
		return changeUserID;
	}
	public void setChangeUserID(String changeUserID) {
		this.changeUserID = changeUserID;
	}
	public String getChangeUserJobTitle() {
		return changeUserJobTitle;
	}
	public void setChangeUserJobTitle(String changeUserJobTitle) {
		this.changeUserJobTitle = changeUserJobTitle;
	}
	public String getChangeUserJobTitle2() {
		return changeUserJobTitle2;
	}
	public void setChangeUserJobTitle2(String changeUserJobTitle2) {
		this.changeUserJobTitle2 = changeUserJobTitle2;
	}
	public String getChangeUserName() {
		return changeUserName;
	}
	public void setChangeUserName(String changeUserName) {
		this.changeUserName = changeUserName;
	}
	public String getChangeUserName2() {
		return changeUserName2;
	}
	public void setChangeUserName2(String changeUserName2) {
		this.changeUserName2 = changeUserName2;
	}
	public String getChangeUserDeptID() {
		return changeUserDeptID;
	}
	public void setChangeUserDeptID(String changeUserDeptID) {
		this.changeUserDeptID = changeUserDeptID;
	}
	public String getChangeUserDeptName() {
		return changeUserDeptName;
	}
	public void setChangeUserDeptName(String changeUserDeptName) {
		this.changeUserDeptName = changeUserDeptName;
	}
	public String getChangeUserDeptName2() {
		return changeUserDeptName2;
	}
	public void setChangeUserDeptName2(String changeUserDeptName2) {
		this.changeUserDeptName2 = changeUserDeptName2;
	}
	public String getChangeDate() {
		return changeDate;
	}
	public void setChangeDate(String changeDate) {
		this.changeDate = changeDate;
	}
	public String getChkFlag() {
		return chkFlag;
	}
	public void setChkFlag(String chkFlag) {
		this.chkFlag = chkFlag;
	}

}
