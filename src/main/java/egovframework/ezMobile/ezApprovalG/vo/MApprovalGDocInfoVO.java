package egovframework.ezMobile.ezApprovalG.vo;

public class MApprovalGDocInfoVO {
	/** 문서번호*/
	private String docID;
	/** 문서 제목*/
	private String docTitle;
	/** 기안날짜*/
	private String startDate;
	/** 기안자*/
	private String writerName;
	/** 기안자부서명*/
	private String wirterDeptName;
	
	public String getDocID() {
		return docID;
	}
	public void setDocID(String docID) {
		this.docID = docID;
	}
	public String getDocTitle() {
		return docTitle;
	}
	public void setDocTitle(String docTitle) {
		this.docTitle = docTitle;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getWirterDeptName() {
		return wirterDeptName;
	}
	public void setWirterDeptName(String wirterDeptName) {
		this.wirterDeptName = wirterDeptName;
	}

}
