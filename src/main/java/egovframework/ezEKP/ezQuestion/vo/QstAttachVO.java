package egovframework.ezEKP.ezQuestion.vo;

public class QstAttachVO {
	/** 게시판id*/
	public int brdId;
	/** 설문번호*/
	public int itemNo;
	/** 질문번호*/
	public int questionNo;
	/** 보기번호*/
	public int answerNo;
	/** 첨부번호*/
	public int attachNo;
	/** 첨부이름*/
	public String attachName;
	/** 첨부URL*/
	public String attachUrl;
	/** 첨부유형*/
	public String attachType;
	
	public int getBrdId() {
		return brdId;
	}
	public void setBrdId(int brdId) {
		this.brdId = brdId;
	}
	public int getItemNo() {
		return itemNo;
	}
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}
	public int getQuestionNo() {
		return questionNo;
	}
	public void setQuestionNo(int questionNo) {
		this.questionNo = questionNo;
	}
	public int getAnswerNo() {
		return answerNo;
	}
	public void setAnswerNo(int answerNo) {
		this.answerNo = answerNo;
	}
	public int getAttachNo() {
		return attachNo;
	}
	public void setAttachNo(int attachNo) {
		this.attachNo = attachNo;
	}
	public String getAttachName() {
		return attachName;
	}
	public void setAttachName(String attachName) {
		this.attachName = attachName;
	}
	public String getAttachUrl() {
		return attachUrl;
	}
	public void setAttachUrl(String attachUrl) {
		this.attachUrl = attachUrl;
	}
	public String getAttachType() {
		return attachType;
	}
	public void setAttachType(String attachType) {
		this.attachType = attachType;
	}
}
