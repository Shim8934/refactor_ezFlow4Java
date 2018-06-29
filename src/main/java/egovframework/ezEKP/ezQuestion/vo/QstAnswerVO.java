package egovframework.ezEKP.ezQuestion.vo;

public class QstAnswerVO {
	/** 게시판ID*/
	int brdID;
	/** 설문번호*/
	int itemNo;
	/** 설문질문번호*/
	int questionNo;
	/** 설문질문별보기번호*/
	int answerNo;
	/** 설문질문별보기내용*/
	String answerContent;
	
	public int getBrdID() {
		return brdID;
	}
	public void setBrdID(int brdID) {
		this.brdID = brdID;
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
	public String getAnswerContent() {
		return answerContent;
	}
	public void setAnswerContent(String answerContent) {
		this.answerContent = answerContent;
	}
}
