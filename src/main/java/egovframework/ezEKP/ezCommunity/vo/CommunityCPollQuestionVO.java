package egovframework.ezEKP.ezCommunity.vo;

public class CommunityCPollQuestionVO {
	/** 질문일련번호*/
	int questionID;
	/** 설문일련번호*/
	int pollManagerID;
	/** 질문번호*/
	int questionNo;
	/** 질문내용*/
	String questionContent;
	/** 답변갯수*/
	int  answerCount;
	/** 응답형태*/
	int answerType;
	/** 응답답변형태*/
	int answerViewType;
	
	public int getQuestionID() {
		return questionID;
	}
	public void setQuestionID(int questionID) {
		this.questionID = questionID;
	}
	public int getPollManagerID() {
		return pollManagerID;
	}
	public void setPollManagerID(int pollManagerID) {
		this.pollManagerID = pollManagerID;
	}
	public int getQuestionNo() {
		return questionNo;
	}
	public void setQuestionNo(int questionNo) {
		this.questionNo = questionNo;
	}
	public String getQuestionContent() {
		return questionContent;
	}
	public void setQuestionContent(String questionContent) {
		this.questionContent = questionContent;
	}
	public int getAnswerCount() {
		return answerCount;
	}
	public void setAnswerCount(int answerCount) {
		this.answerCount = answerCount;
	}
	public int getAnswerType() {
		return answerType;
	}
	public void setAnswerType(int answerType) {
		this.answerType = answerType;
	}
	public int getAnswerViewType() {
		return answerViewType;
	}
	public void setAnswerViewType(int answerViewType) {
		this.answerViewType = answerViewType;
	}
	
}
