package egovframework.ezEKP.ezQuestion.vo;

public class QstVO {
	/** 게시판ID*/
	int brdId;
	/** 설문번호*/
	int itemNo;
	/** 질문번호*/
	int questionNo;
	/** 질문내용*/
	String quesContent;
	/** 응답형태(객관식:1, 주관식:2, 우선순위:4)*/
	int answerType;
	/** (사용안함)*/
	int answerViewType;
	/** 다중선택여부(다답형:1)*/
	String multiSelect;
	/** 질문표시순서(순번변경가능)*/
	int quesSn;
	
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
	public String getQuesContent() {
		return quesContent;
	}
	public void setQuesContent(String quesContent) {
		this.quesContent = quesContent;
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
	public String getMultiSelect() {
		return multiSelect;
	}
	public void setMultiSelect(String multiSelect) {
		this.multiSelect = multiSelect;
	}
	public int getQuesSn() {
		return quesSn;
	}
	public void setQuesSn(int quesSn) {
		this.quesSn = quesSn;
	}
}
