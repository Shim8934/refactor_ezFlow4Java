package egovframework.ezEKP.ezCommunity.vo;

public class CommunityCPollAnswerVO {
	/** 보기일련번호*/
	int answerID;
	/** 질문번호*/
	int pollQuestionID;
	/** 보기번호*/
	String answerNo;
	/** 보기내용*/
	String answerContent;
	
	public int getAnswerID() {
		return answerID;
	}
	public void setAnswerID(int answerID) {
		this.answerID = answerID;
	}
	public int getPollQuestionID() {
		return pollQuestionID;
	}
	public void setPollQuestionID(int pollQuestionID) {
		this.pollQuestionID = pollQuestionID;
	}
	public String getAnswerNo() {
		return answerNo;
	}
	public void setAnswerNo(String answerNo) {
		this.answerNo = answerNo;
	}
	public String getAnswerContent() {
		return answerContent;
	}
	public void setAnswerContent(String answerContent) {
		this.answerContent = answerContent;
	}
}
